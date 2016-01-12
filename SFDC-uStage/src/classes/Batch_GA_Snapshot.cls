public class Batch_GA_Snapshot implements Schedulable, Database.Batchable<MA_Snapshot__c>, Database.AllowsCallouts, Database.Stateful {
	
    private Integer maxHeapSize = 0;
    private Integer rowsAdded = 0;
    private String messageSubject;
    private String messageBody = 'Batch Google Analytics Snapshot Extraction job processing results:\n';
    
    //List of KPI Query settings that have been used in this batch execution, along 
    //with the End Date processed for each    
    private List<KPI_GA_Query_Info__c> kpiQueryUpdates = new List<KPI_GA_Query_Info__c>();
    private List<String> kpiQueryLog = new List<String>();
    
    public Iterable<MA_Snapshot__c> start(Database.BatchableContext info){
		//Iterable list to be returned to batch execute--will contain response for all active KPI GA Query Info
		//queries that return GA data from callouts
    	List<MA_Snapshot__c> mas = new List<MA_Snapshot__c>();  

        //Get Google oAuth Access info and request token
        KPI_GA_oAuth__c gAuth = KPI_GA_oAuth__c.getInstance();

        try {
        	String token = getGAAaccessToken(gAuth.Endpoint__c, gAuth.ISS__c, gAuth.Scope__c);     
            
        	if (token != 'error'){
        		//Get list of active KPI GA Query Info queries to be sent to GA Core Reporting API
				Map<String, KPI_GA_Query_Info__c> qi = KPI_GA_Query_Info__c.getAll();
            	for(String q : qi.keySet()){
                	if(qi.get(q).Active__c == True){
	            		Integer r = 0;
	            	    //Start Date precedence:  Explicit Start Date, Last Update Date, Default (Yesterday)
	            		Date nextSnapshotAt;
						if(qi.get(q).Start_Date__c != null){
                            nextSnapshotAt = qi.get(q).Start_Date__c;
                        } else if(qi.get(q).Last_GA_Update_At__c != null) {
                            nextSnapshotAt = qi.get(q).Last_GA_Update_At__c.addDays(1);
                        } else {
                            nextSnapshotAt = Date.Today().addDays(-1);
                        }                     
                        //End Date precedence:  Explicit End Date, Default (Yesterday) 
                        Date lastSnapshotAt = qi.get(q).End_Date__c == null ? Date.today().addDays(-1) : qi.get(q).End_Date__c;
                        
            			while(r < Integer.valueOf(qi.get(q).Max_Days__c) && nextSnapshotAt <= lastSnapshotAT){
							//Google requires string date params in a specific format
							//Design below assumes single-day iteration.  Could be extended to date aggregation queries (e.g., week) with 
							//use of different Start/End dates
                            Datetime dts = datetime.newInstance(nextSnapshotAt.Year(), nextSnapshotAt.Month(), nextSnapshotAt.Day());
            				String startDate = dts.format('YYYY-MM-dd');
            				String endDate = startDate;
                            
			        		//Now call the Google API
			        		Http h = new Http();
							HttpRequest req = new HttpRequest();
							HttpResponse res = new HttpResponse();
		            		//build up GA Core Reporting API using Custom Setting values
		            		String segment = qi.get(q).Segment__c == null ? '' : '&segment=' + EncodingUtil.urlEncode(qi.get(q).Segment__c, 'UTF-8');
                            String sortList = qi.get(q).Sort_List__c == null ? '' : '&sort=-ga%3A' + qi.get(q).Sort_List__c.replace(',','%2Cga%3A');
							String filter = qi.get(q).Filter__c == null ? '' : '&filter=' + EncodingUtil.urlEncode(qi.get(q).Filter__c, 'UTF-8');
                            req.setEndpoint(qi.get(q).GA_Analytics_Endpoint__c + 
                				'?ids=ga' + EncodingUtil.urlEncode(':'+ qi.get(q).ProfileId__c, 'UTF-8') + 
                				'&start-date=' + startDate + 
                				'&end-date=' + endDate +  
                				'&metrics=ga%3A' + qi.get(q).Metrics__c.replace(',','%2Cga%3A') +
                				'&dimensions=ga%3A' + qi.get(q).Dimensions__c.replace(',','%2Cga%3A') + 
                                filter +
                                segment +
                				sortList +
                                '&samplingLevel=' + qi.get(q).Sampling_Level__c +
                				'&max-results=' + Integer.valueOf(qi.get(q).Max_Results__c)); 
							//system.debug('..........Endpoint: ' + req);
	            			req.setMethod('GET'); 
							req.setHeader('Authorization','Bearer ' + token);
	                		req.setTimeout(80000);
							messageBody = req.getEndpoint();
							res = h.send(req);
							String response_debug = res.getBody() +' '+ res.getStatusCode();
							//System.debug('Response =' + response_debug );  
							if(res.getStatusCode() == 200) {
                    			mas.addAll(ParseRows(res.getBody(), Integer.valueOf(qi.get(q).Query_Number__c), Integer.valueOf(qi.get(q).Max_Results__c), String.valueOf(qi.get(q).Source_System_Code__c), String.valueOf(qi.get(q).Sys_Admin_Tag__c)));
								kpiQueryLog.add('\nProfile / Query Number: ' + qi.get(q).Name + ' / ' + Integer.valueOf(qi.get(q).Query_Number__c) + ' -- ' + startDate + ' to ' + endDate + ' -- Memory Used: ' + Limits.getHeapSize());
                            } else {
                                throw new ServiceCalloutException('Google Analytics API request failed: ' + res.getStatusCode() + ' at ' + Datetime.now() + ' in Batch_GA_Snapshots for Query: ' + qi.get(q).Name);
                            }
                			r++;
            				nextSnapshotAt = nextSnapshotAt.addDays(1);
                			//system.debug('.......Loop End:' + r + ' date ' + nextSnapshotAt + ' newMAS size: ' + mas.size());
                    		//system.debug('.......Heap Size now is: ' + Limits.getHeapSize());
                    		if(Limits.getHeapSize() > maxHeapSize) maxHeapSize = Limits.getHeapSize();  
                		}
                        if(qi.get(q).Last_GA_Update_At__c != null && qi.get(q).Last_GA_Update_At__c >= nextSnapshotAt) {
                            if(nextSnapshotAt > qi.get(q).End_Date__c){
                                //Clear custom start/end dates when all data has been fetched
                                kpiQueryUpdates.add(new KPI_GA_Query_Info__c(Id = qi.get(q).Id, Start_Date__c = null, End_Date__c = null));
                            } else {
                                //Move up custom start date to where we've stopped
                        		kpiQueryUpdates.add(new KPI_GA_Query_Info__c(Id = qi.get(q).Id, Start_Date__c = nextSnapshotAt));
                            }
                        } else {
                            //No fill-in, so just move marker forward to where we stopped, and clear any new query seed StartDate
                			kpiQueryUpdates.add(new KPI_GA_Query_Info__c(Id = qi.get(q).Id, Start_Date__c = null, Last_GA_Update_At__c = nextSnapshotAt.addDays(-1)));
                        }
                		//system.debug('......CS KPI Query Date update to: ' + kpiQueryUpdates);
                	}
        		}
        	}
        } catch(Exception e) {
            //Set up email notification content, which will be sent in the 'finish' method
            messageBody = e.getMessage();
            messageSubject = 'Error from Salesforce Org: ' + UserInfo.getOrganizationName();
        }
        //Should have a good list of new MA_Snapshot__c instances, so send them into the batch chunker
		//system.debug('......Rows to Update: ' + rowsAdded);
        rowsAdded = mas.size();
        return mas;
    }
    
    public void execute(Database.BatchableContext info, List<MA_Snapshot__c> scope){
        try{
        	insert scope;
        } catch(System.DmlException e){
            //Set up email notification content, which will be sent in the 'finish' method
            messageBody = e.getMessage() + '\nOne or more transactions failed.  Please ensure KPI Query Dates are consistent with MA_Snapshot data by deleting any partial-day data and manually resetting KPI_GA_Query__c date fields to be consistent with the MA_Snapshot data.';
            messageSubject = 'Error from Salesforce Org: ' + UserInfo.getOrganizationName();
            rowsAdded = 0;
        } 
    }
    
    public void finish(Database.BatchableContext info){
        //system.debug('......Max Heap Size reached: ' + maxHeapSize);
        //system.debug('......Query Setting updates: ' + kpiQueryUpdates);
        try{
            //Force DML exception via a field overflow 
            if(Test.isRunningTest()){
            	for(KPI_GA_Query_Info__c q : kpiQueryUpdates){
                	if(q.Last_GA_Update_At__c == Date.Today().addDays(-20)){
						q.Sys_Admin_Tag__c = 'A long string to force a DML exception';
                	}
            	}
            }            
        	update(kpiQueryUpdates);
        } catch(Exception e){
            messageBody = e.getMessage() + '\nBatch GA Snapshots failed during Final stage.  All GA data was inserted into MA_Snapshots, but the KPI_GA_Query_Info Start/End and/or Last_GA_Update_At fields must be manually updated based on the dates found in MA_Snapshot.';
            messageSubject = 'Error from Salesforce Org: ' + UserInfo.getOrganizationName();
        } finally {
            //Honours any pre-set exception content, then sends email for all conditions
            //Remember:  Email may **not** be sent under some conditions (e.g., uncatchable system exceptions like Limits)
            //and data exceptions that cause a rollback of everything (including email transactions).  
            Decimal heapLimitUsed = ((maxHeapSize/12582912.0)*100).setScale(2);
            //system.debug('......Heap Percent factors: ' + maxHeapSize);
            messageBody = messageBody + '\nGA Rows: ' + rowsAdded + '\n' + 'Max Heap Used: ' + maxHeapSize + ' (' + heapLimitUsed + '%)' + '\n';
            for(String qs : kpiQueryLog){
                messageBody = messageBody + qs;
            }
            messageSubject = messageSubject == null ? 'Success:  Batch_GA_Snapshot Completed in Org ' + UserInfo.getOrganizationName() : messageSubject;            
			statusEmail(messageSubject, messageBody);
        }
    }

    private static void statusEmail(String subject, String body){
		Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
		List<String> toAddresses = new List<String>();
        if(Global_Constants__c.getInstance().Fault_Email_Address__c != null){
        	if(Global_Constants__c.getInstance().Fault_Email_Address__c.contains('@intraxinc.com')) toAddresses.add(Global_Constants__c.getInstance().Fault_Email_Address__c);
        }
        if(KPI_GA_oAuth__c.Use_Notification_Email__c != null){
        	if(String.valueOf(KPI_GA_oAuth__c.Use_Notification_Email__c).contains('@intraxinc.com')) toAddresses.add(String.valueOf(KPI_GA_oAuth__c.Use_Notification_Email__c));
        }
        if(toAddresses.size()>0){
        	mail.setToAddresses(toAddresses);
        	mail.setReplyTo('noreply@intraxinc.com');
     		mail.setSenderDisplayName('Batch GA Snapshot Job');
     		mail.setSubject(subject);
     		mail.setPlainTextBody(body);
     		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
    }
    
    private static List<MA_Snapshot__c> ParseRows(String res, Integer queryNumber, Integer maxResults, String sourceSystemCode, String sysAdminTag){
        List<MA_Snapshot__c> mas = new List<MA_Snapshot__c>();
        List<String> headerNames = new LIST<String>();
        String profileId;
        String accountId;
        String profileName;
        Date qStartDate;
        Date qEndDate;
        Integer qTotalResults = 0;

        //Extract GA response body columnHeader, rows and profileInfo data.  Create new MA_Snapshot 
        //instances inline to conserve heap.  This scheme depends columnHeader and profileInfo always
        //preceeding the row data in the JSON structure, something GA current assures.
        JSONParser parser = JSON.createParser(res);
		while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'rows')) {
                while (parser.nextToken() == JSONToken.START_ARRAY){
                	while (parser.nextToken() == JSONToken.START_ARRAY){
                        integer h = 0;
                        MA_Snapshot__c nmas = new MA_Snapshot__c();
                        nmas.Name = profileName;
                        nmas.Date__c = qEndDate;
                        nmas.Profile_Id__c = profileId;  
                        nmas.Account_Id__c = accountId;
                        nmas.Query_Number__c = queryNumber;
                        nmas.Source_System__c = sourceSystemCode;
                        nmas.Sys_Admin_Tag__c = sysAdminTag;
                        //Assumption is that resBody columnHeaders and rows tokens are ordered sequentially, and
                        //that rows tokens always come at the end or the resBody JSON string.  Furthermore, rows
                        //are assumed to be an array of arrays.  
                		while (parser.nextToken() != JSONToken.END_ARRAY && h < headerNames.size()) { 
                			String value = parser.getText().trim();
                        	if(headerNames[h] == 'source') nmas.Source__c = value;
                        	if(headerNames[h] == 'landingPagePath'){
                    			nmas.Landing_Page_Path__c = value;
                        		if(nmas.Landing_Page_Path__c.length() > 255){
                            		nmas.Landing_Page_Path__c = nmas.Landing_Page_Path__c.substring(0,255);
                            	}
                        	}                            
                        	if(headerNames[h] == 'pagePath'){
	                    		nmas.Page_Path__c = value;
                        		if(nmas.Page_Path__c.length() > 255){
                            		nmas.Page_Path__c = nmas.Page_Path__c.substring(0,255);
                            	}
                        	}
                        	if(headerNames[h] == 'users'){
	                    		nmas.Users__c = Integer.valueOf(value);
                        	}
                        	if(headerNames[h] == 'bounces'){
		                		nmas.Bounces__c = Integer.valueOf(value);
                        	}
                        
                    		if(headerNames[h] == 'sessions'){
	                			nmas.Sessions__c = Integer.valueOf(value);
                    		}                          
                                 
                        	if(headerNames[h] == 'pageviews'){
                        		nmas.Page_Views__c = Integer.valueOf(value);
                        	}
                        
                        	if(headerNames[h] == 'medium'){
	                    		nmas.Traffic_Type__c = value;
                        	}
                        
                        	if(headerNames[h] == 'goalCompletionLocation'){
                        		nmas.Goal_Completion_Location__c = value;
                        		if(nmas.Goal_Completion_Location__c.length() > 255){
                            		nmas.Goal_Completion_Location__c = nmas.Goal_Completion_Location__c.substring(0,255);
                            	}
                        	}
                        
                        	if(headerNames[h] == 'goalPreviousStep1'){
                        		nmas.Goal_Previous_Step_1__c = value;
                        		if( nmas.Goal_Previous_Step_1__c.length() > 255){
                         			nmas.Goal_Previous_Step_1__c =  nmas.Goal_Previous_Step_1__c.substring(0,255);
                            	}
                       		}
                        
                        	if(headerNames[h] == 'goalPreviousStep2'){
                        		nmas.Goal_Previous_Step_2__c = value;
                        		if(nmas.Goal_Previous_Step_2__c.length() > 255){
                            		nmas.Goal_Previous_Step_2__c = nmas.Goal_Previous_Step_2__c.substring(0,255);
                            	}
                        	}
                        
                        	if(headerNames[h] == 'eventCategory'){
                        		nmas.Event_Category__c = value;
                        	}
                        
                        	if(headerNames[h] == 'eventLabel'){
                        		nmas.Event_Label__c = value;
                        	}
                        
                        	if(headerNames[h] == 'eventAction'){
                        		nmas.Event_Action__c = value;
                        		if(nmas.Event_Action__c.length() > 255){
                            		nmas.Event_Action__c = nmas.Event_Action__c.substring(0,255);
                            	}
                        	}
                        
                        	if(headerNames[h] == 'goal1Completions'){
                        		nmas.Goal_1_Completions__c = Integer.valueOf(value);
                        	}
                        
                        	if(headerNames[h] == 'goalCompletionsAll'){
                        		nmas.Goal_Completions_All__c = Double.valueOf(value);
                        	}
                        
                        	if(headerNames[h] == 'pageviewsPerSession'){
                        		nmas.Pageviews_Per_Session__c = Decimal.valueOf(value).setScale(3);
                        	}                             
                            
                            h++;
                		}
                        //system.debug('.........New MAS: ' + nmas);
                        mas.add(nmas);
                	}
            	}
            } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'columnHeaders'){
                    while (parser.nextToken() == JSONToken.START_ARRAY){
                        while(parser.nextToken() == JSONToken.START_OBJECT){
                            while(parser.nextToken() != JSONToken.END_OBJECT){
                                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'name'){
                                    parser.nextToken();
                                    headerNames.add(parser.getText().substringAfter('ga:'));
                                }
                            }
                        }
                    }

            } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'query'){
                    while(parser.nextToken() != JSONToken.END_OBJECT){
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'start-date'){
                            parser.nextToken();
                            qStartDate = Date.valueOf(parser.getText());
                        }else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'end-date'){
                            parser.nextToken();
                            qEndDate = Date.valueOf(parser.getText());
                        }
                    }
            } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'totalResults'){
                	 parser.nextToken();
            		 qTotalResults = Integer.valueOf(parser.getText());
                	 if(qTotalResults >= maxResults){
            			throw new ServiceCalloutException('Google Results exceed Max Results Limit: ' + qTotalResults + ' / ' + maxResults + ' at ' + Datetime.now() + ' in Batch_GA_Snapshots. QueryNumber: ' + queryNumber );                    	
                	 }
            } else {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'profileInfo'){
                    while(parser.nextToken() != JSONToken.END_OBJECT){
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'profileId'){
                            parser.nextToken();
                            profileId = parser.getText();
                        }else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'accountId'){
                            parser.nextToken();
                            accountId = parser.getText();
                        }else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'profileName'){
                            parser.nextToken();
                            profileName = parser.getText();
                        }
                    }
                }
            }
        }        
        //system.debug('....New MAS: ' + mas);
        return mas;
    } 
    
	//Returns an Google Analytics Core API v3 autheticated oAuth token good for 1 hour
    private static string getGAAaccessToken(String endpoint, String iss, String scope){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();

       	req.setEndpoint(endpoint);
		req.setMethod('POST');
		req.setHeader('ContentType','application/x-www-form-urlencoded');

       	//Header formation
		String header = '{"alg":"RS256","typ":"JWT"}';
		String header_encoded = EncodingUtil.base64Encode(blob.valueof(header));

       	//Claim formation
		String claim_set = '{"iss":"' + ISS + '"';
       		claim_set += ',"scope":"' + scope + '"';        
			claim_set += ',"aud":"' + endpoint + '"';        
			claim_set += ',"exp":"' + datetime.now().addHours(1).getTime()/1000;
			claim_set += '","iat":"' + datetime.now().getTime()/1000 + '"}';
		String claim_set_encoded = EncodingUtil.base64Encode(blob.valueof(claim_set));
        
		//Signature formation
       	String signature_encoded = header_encoded + '.' + claim_set_encoded;
		String key = 'MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAL52hM+0xJl9tm6OzcyUV13Nr3ecZQNSJ+tB3rFwp6zSWQQHVAF6iUG/dcQFkm3RfOsFFr+3prnAmmT4QN2Ef47lAXvXN2acYOR0SYkHYltkTFRh1LsFN2vTMy8DShwx8Niq4C6UWna7CmQWlYxvE3s1Kp12tD/85LqM6IgkS9CLAgMBAAECgYByzxyV2+CaqZXbpQdXJ6BWchMwZbzaOJ7JiEZF7aOVYKK58/Tmg0fTsya5B6bRvfKv9LxWysycsgYfkSoAncsJfB082yG/DajAx1A/vuDVHYHl1B0mFjTFjauWuB2Ee9XXCMF0KCm28m1j1/JX5+0w5RSSeHHHd1nqzs+8inS7sQJBAOxJxfTakdgkQHvMhEoumDVbbrK0i9+TMKNIesqhkq9ubmjOkxlpA4GBxo5RO3ejoipa4IJFJ8kJU0h4Lm0G2FkCQQDOWhdh/8Lq3390T8r5S7aYvI30hbHw4XbO/d0HbUJKSqq0yns3xTPfmxhZZPiON6capwufzrkrcXolWZBWEJODAkEAy4eEVzPJ+pbHYJu6u7dE7njyckYoUY2UkKFG+7GPC0OhIPAHLxUQqwYhBMed5KDzd25OAogVDArXTQ4QV2NVCQJBAJM/upvV1JOh9ONc5SxMGPqY4ntww+9uFEfU49qe3sUAzxu/uXmsoT2ZASEZajyh/f6I4USiUYRsr4rjhJnFrl0CQQCPBRvVbNFrKTvQJ3jurkxgpOVLm+6BmwfxxFQZVUiykmcmp3zG6/VdZrsrhHfLTqI0sRhb3g76uPwF8NQOvw8t';
		blob private_key = EncodingUtil.base64Decode(key); 
       	signature_encoded = signature_encoded.replaceAll('=','');
       	String signature_encoded_url = EncodingUtil.urlEncode(signature_encoded,'UTF-8');
		blob signature_blob = blob.valueof(signature_encoded_url);
		String signature_blob_string = EncodingUtil.base64Encode(Crypto.sign('RSA-SHA256', signature_blob, private_key));

       	//JWT formation
       	//string hacks required by GA's insistance on using URL-safe encoding--which is not supported by Apex classes
		String JWT = signature_encoded + '.' + signature_blob_string;
		JWT = JWT.replaceAll('=','');
      	JWT = JWT.replace('+', '-'); //added based on google docs 
       	JWT = JWT.replace('/', '_'); //added based on google docs 
        
       	//Grant formation
		String grant_string= 'urn:ietf:params:oauth:grant-type:jwt-bearer';

        //Token request
        req.setBody('grant_type=' + grant_string + '&assertion=' + JWT);
		res = h.send(req);
		String response_debug = res.getBody() +' Status Code: '+ res.getStatusCode();
		//system.debug('........oAuth ResponseBody:' + res.getBody());
        //Return setup
        if(res.getStatusCode() == 200) {
            Map<String, Object> token_info = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
			//system.debug('.......Token is: ' + token_info);
            return String.valueof(token_info.get('access_token'));
        } else {
            throw new ServiceCalloutException('Google oAuth request failed: ' + response_debug + ' at ' + Datetime.now() + ' in Batch_GA_Snapshots');
        }
    } 
    
	public void execute(SchedulableContext sc){
		Batch_GA_Snapshot batch = new Batch_GA_Snapshot();
		Database.executeBatch(batch);
	}    
}