/*
B-03207 JOSE (APC - Field - Lead Bonus Payments)
We handle BONUS “APC Lead Bonus NHF+FSB” and “APC Field Sales Bonus” for In Country AuPairs
*/
global class Batch_APC_Bonus_Pay_Events implements Database.Batchable<sObject>, Schedulable {
    Date runDate = Global_Constants__c.getInstance().Batch_Pay_Event_Run_Date__c;    

    global Database.QueryLocator start(Database.BatchableContext BC){ 
        //Use Custom Setting to force run on a specific date.
        
        if(runDate == null){
        	runDate = date.today();
        }
       
        system.debug('@@@@@@ runDate: ' + runDate);
          
        //Start with join of Match Owner History to Match so we can get the ownership chronology of each Match
        return Database.getQueryLocator([SELECT Name, id, Start_Date__c, End_Date__c, Host_Account__c, Intrax_Program__c, Position_Name__c,
        								Position_Name__r.Intrax_Region__c, RecordTypeId, Engagement__c, Position_Name__r.OwnerId
                            			FROM Match__c 
                            			WHERE Status__c = 'Confirmed' and 
                                  		Intrax_Program__c = 'AuPairCare' and
                                  		HF_Arrival_Date__c <= :runDate and
                                  		HF_Arrival_Date__c > 2015-12-02 and 
                                  		Match_Type__c = 'Original' and Engagement__r.In_Country__c = 'Yes' and
                                  		Position_Name__c != null
                            			order BY CreatedDate DESC
                            			]);  
    }
    
    global void execute(SchedulableContext sc){
        Batch_APC_Bonus_Pay_Events batch = new Batch_APC_Bonus_Pay_Events();
        Database.executeBatch(batch);
    } 
    
    global void execute(Database.BatchableContext BC, List<Match__c> MatchList){
        
        try{
        //Use Custom Setting to force run on a specific date. 
        system.debug('@@@@@@ MatchList: ' + MatchList);
        system.debug('@@@@@@ MatchList.size(): ' + MatchList.size());
        if(runDate == null){
        	runDate = date.today();
        }
        system.debug('@@@@@@ runDate: ' + runDate);
        //list of IDs to query for existing Pay Events
        list<Id> matchIDs = New List<Id>();
        //list of IDs to query for Matches realted Pay Events non creation
        set<Id> matchNoIDs = New set<Id>();
        //List of Matches for Pay Event creation
        list<Match__c> matchListCreate = New List<Match__c>();
        //List of Positions ID for Pay Event creation
        list<Applicant_Info__c> applist = New List<Applicant_Info__c>();
        //List of Positions ID for Pay Event creation
        list<Id> postionsId = New List<Id>();
        //Pay Event list to update
        list<Pay_Event__c> insertPayEvents = new list<Pay_Event__c>();
        
        for(Match__c m : MatchList){
            matchIDs.add(m.Id);
        }
        //Get Stipend Pay Events that already exist. We dont want to create new ones if the already exist
        List<Pay_Event__c> payEvents = [SELECT Id, Name, Approved_By__c, Event_Date__c, Reference_Id__c, Payee__c, Quantity__c 
                                        FROM Pay_Event__c 
                                        WHERE Reference_Id__c In :matchIDs and
                                              /*(Stage__c = 'Pending' OR Stage__c = 'Unearned') and*/
                                              (Source__c = 'APC Lead Bonus NHF+FSB' OR Source__c = 'APC Field Sales Bonus')
                                        ];
        system.debug('@@@@@@ payEvents: ' + payEvents);
        if(payEvents!=null && payEvents.size()>0){
        //Retrieving IDs for non creation Payvent	
        	for(Pay_Event__c pev : payEvents){
        	    matchNoIDs.add(Id.valueOf(pev.Reference_Id__c));
        	}
        	system.debug('@@@@@@ matchNoIDs: ' + matchNoIDs);
        	system.debug('@@@@@@ matchNoIDs.size(): ' + matchNoIDs.size());
        	
        	matchListCreate = [SELECT Name, id, Start_Date__c, End_Date__c, Host_Account__c, Intrax_Program__c, Position_Name__c, Position_Name__r.OwnerId,
        								Position_Name__r.Intrax_Region__c, RecordTypeId, Engagement__c
                            			FROM Match__c 
                            			WHERE Status__c = 'Confirmed' and 
                                  		Intrax_Program__c = 'AuPairCare' and
                                  		HF_Arrival_Date__c <= :date.today() and 
                                  		HF_Arrival_Date__c > 2015-12-02 and
                                  		Match_Type__c = 'Original' and Engagement__r.In_Country__c = 'Yes' and
                                  		Position_Name__c != null and
                                  		Id IN: matchIDs and Id NOT IN: matchNoIDs  
                            			order BY CreatedDate DESC
                            			];
            system.debug('@@@@@@ matchListCreate: ' + matchListCreate);
            system.debug('@@@@@@ matchListCreate.size(): ' + matchListCreate.size());
            
            for(Match__c mpos : matchListCreate){
            	postionsId.add(mpos.Position_Name__c);
            }
            system.debug('@@@@@@ postionsId: ' + postionsId);
            
            appList = [SELECT Name, id, Field_Staff__c, OwnerId, Position__c
                            			FROM Applicant_Info__c 
                            			WHERE
                                  		Intrax_Program__c = 'AuPairCare' AND
                                  		Application_Stage__c != 'Cancelled' AND 
                                  		Position__c IN: postionsId 
                            			order BY CreatedDate DESC
                            			];
            system.debug('@@@@@@ appList: ' + appList);
            
            map<Id, Applicant_Info__c> mapApp = new map<Id, Applicant_Info__c>();
            for(Applicant_Info__c ap:appList){
            	mapApp.put(ap.Position__c, ap);
            }
            system.debug('@@@@@@ mapApp: ' + mapApp); 
           	
           	if(appList!=null && appList.size()>0){
				for(Match__c mpe : matchListCreate){
	           		Pay_Event__c newPE = New Pay_Event__c();
	                // CREATING PAY EVENT
	                newPE.Stage__c = 'Pending';
	                newPE.HF_Account_Name__c = mpe.Host_Account__c;
	                newPE.OwnerId = mpe.Position_Name__r.OwnerId; 
	                newPE.Quantity__c = 1;
	                newPE.Reference_Object__c = 'Match';
	                newPE.Reference_Id__c = mpe.Id;
	                newPE.Event_Date__c = runDate;
	                newPE.Customer__c = mpe.Name.left(40);
	                newPE.Approved_By__c = Global_Constants__c.getInstance().ULM_Admin_ID__c;
	                newPE.Intrax_Program__c = mpe.Intrax_Program__c;
	                if(mapApp.get(mpe.Position_Name__c).Field_Staff__c != null){
	                	newPE.Payee__c = mapApp.get(mpe.Position_Name__c).Field_Staff__c;
	                	newPE.Source__c = 'APC Lead Bonus NHF+FSB';
	                }else{
	                	system.debug('@@@@@@ mpe.Position_Name__r.OwnerId: ' + mpe.Position_Name__r.OwnerId);
	                	newPE.Payee__c = mpe.Position_Name__r.OwnerId;
	                	newPE.Source__c = 'APC Field Sales Bonus';
	                }
	                
	                insertPayEvents.add(newPE);
	           	}
           	} 
        //we don't find any existing Pay Event	
        }else{
        	system.debug('@@@@@@ We dont find any Pay Event record');
        	for(Match__c mpos : MatchList){
            	postionsId.add(mpos.Position_Name__c);
            }
            system.debug('@@@@@@ postionsId: ' + postionsId);
            
            appList = [SELECT Name, id, Field_Staff__c, OwnerId, Position__c
                            			FROM Applicant_Info__c 
                            			WHERE
                                  		Intrax_Program__c = 'AuPairCare' AND
                                  		Application_Stage__c != 'Cancelled' AND 
                                  		Position__c IN: postionsId 
                            			order BY CreatedDate DESC
                            			];
            system.debug('@@@@@@ appList: ' + appList);
            
            map<Id, Applicant_Info__c> mapApp = new map<Id, Applicant_Info__c>();
            for(Applicant_Info__c ap:appList){
            	mapApp.put(ap.Position__c, ap);
            }
            system.debug('@@@@@@ mapApp: ' + mapApp); 
           	
           	if(appList!=null && appList.size()>0){
				for(Match__c mpe : MatchList){
	           		Pay_Event__c newPE = New Pay_Event__c();
	                // CREATING PAY EVENT
	                newPE.Stage__c = 'Pending';
	                newPE.HF_Account_Name__c = mpe.Host_Account__c;
	                newPE.OwnerId = mpe.Position_Name__r.OwnerId; 
	                newPE.Quantity__c = 1;
	                newPE.Reference_Object__c = 'Match';
	                newPE.Reference_Id__c = mpe.Id;
	                newPE.Event_Date__c = runDate;
	                newPE.Customer__c = mpe.Name.left(40);
	                newPE.Approved_By__c = Global_Constants__c.getInstance().ULM_Admin_ID__c;
	                newPE.Intrax_Program__c = mpe.Intrax_Program__c;
	                if(mapApp.get(mpe.Position_Name__c).Field_Staff__c != null){
	                	system.debug('@@@@@@ mapApp.get(mpe.Position_Name__c).Field_Staff__c: ' + mapApp.get(mpe.Position_Name__c).Field_Staff__c);
	                	newPE.Payee__c = mapApp.get(mpe.Position_Name__c).Field_Staff__c;
	                	newPE.Source__c = 'APC Lead Bonus NHF+FSB';
	                }else{
	                	system.debug('@@@@@@ mpe.Position_Name__r.OwnerId: ' + mpe.Position_Name__r.OwnerId);
	                	newPE.Payee__c = mpe.Position_Name__r.OwnerId;
	                	newPE.Source__c = 'APC Field Sales Bonus';
	                }
	                system.debug('@@@@@@ new Pay Event: ' + newPE);
	                
	                insertPayEvents.add(newPE);
	           	}
           	} 
        }
        
        if(insertPayEvents!=null && insertPayEvents.size()>0){
        	system.debug('@@@@@@ inserting Pay Event list'); 
        	upsert insertPayEvents;
        }
    	}catch(Exception e){
			system.debug('***** Imposible to create APC Bonus in class Batch_APC_Bonus_Pay_Events: ' + e);
		}
    
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}