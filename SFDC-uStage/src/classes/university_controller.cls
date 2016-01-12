public without sharing class university_controller {
	
	public map<Id, list<Applicant_Info__c>> map_gr_app{get;set;} // Group Id --> List of related apps
	public list<Group__c> grList{get;set;}
	public map<Id, Person_Info__c> map_app_person{get;set;}
				
	public Applicant_Info__c applicantInfo{get;set;}
	public Person_Info__c personInfo {get;set;}
	public list<Person_Info__c> emergencyList{get;set;}
	
	public User activeUser {get;set;}	
	//For Resource Documents (Start)
	
	public list<Document> DocumentList {get; set;}
	public String[] KeyTags {get;set;}
	
	public String SocialDevlink {get;set;}
	public String Businesslink {get;set;}
	public String Directlink {get;set;}
	public String UnivReportLink {get;set;}
	
	public Intrax_Program_Upload__c doc_itinerary{get;set;}
	
	public String responseXML{get; set;}
	public String fileUploadUrl{
		get{
			return Constants.fileUploadUrl2;
		}set;
	}
	
	public string progId{
		get{
			return 'upload_grp';
		}
		set;
	}
	
	public String retParam {get;set;}

	public map<string, map<String, boolean>> mapdocTypesByGroup{get;set;}
	public map<Id, list<Intrax_Program_Upload__c>> mapInvoicesByGroup{get;set;} 
	public map<Id, list<Intrax_Program_Upload__c>> mapOtherDocsByGroup{get;set;}
	
	public Account ContactUsUser{get;set;}
	
	public String DeriveRetParam(String ProgramId){
	    string retParam;
	    string DocumentType;
	                
	    if(ApexPages.currentPage().getParameters().get('docType')!=null)
	    {
	        DocumentType =  ApexPages.currentPage().getParameters().get('docType');
	    	system.debug('####### docType' +DocumentType);
	    }
	    
	    if(ProgramId == 'upload_grp'){
	      if(Constants.UNIV_GRP_DOCTYPES.containsKey(DocumentType)) {
	        	retParam = Site.getBaseUrl() +  Constants.UNIV_GRP_DOCTYPES.get(DocumentType);
	            //retParam = retParam + '&id=' + 'a2h180000008S9S';             
	            system.debug('####### retParam' +retParam);     
	      } 
	    }	    
	    
	    return retParam;
    }
		
	public university_controller(){
		
		// Initializing vars.. 
		map_gr_app = new map<Id, list<Applicant_Info__c>>();
		map_app_person = new map<Id, Person_Info__c>();
		mapdocTypesByGroup = new map<string, map<String, boolean>>();
		mapInvoicesByGroup = new map<Id, list<Intrax_Program_Upload__c>>();
		mapOtherDocsByGroup = new map<Id, list<Intrax_Program_Upload__c>>();
		//ds = new list<dsfs__DocuSign_Status__c>();
		
		grList = new list<Group__c>();
		
		ContactUsUser = new Account();
		//Commented out for testing purposes
		User user = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Id =: userInfo.getUserId()];
		
		grList = [SELECT Id, Name, Country__c, Location__c, Engagement_Start__c, Engagement_End__c, Account__c, Account__r.Intrax_Id__c, Description__c FROM Group__c WHERE Account__c =: user.Contact.AccountId];
		
		if(user.Contact.AccountId != NULL)
		{
			ContactUsUser = [Select a.Owner.Phone, a.Owner.Email, a.Owner.Name, a.OwnerId, a.Owner.Title, a.Name From Account a where a.id =: user.Contact.AccountId];
		}
		// for testing...
		/*grList = [SELECT Id, Name, Country__c, Location__c, Engagement_Start__c, Engagement_End__c, Account__c, Account__r.Intrax_Id__c
					FROM Group__c WHERE Id IN ('a2h180000008QMB', 'a2h180000008RCH')];
		*/
		
		 if(progId!=null && ApexPages.currentPage().getParameters().get('docType') != null){
            string RetString = DeriveRetParam(progId);
            System.debug('####### RetString' +RetString); 
            retParam = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(RetString)),'UTF-8');
            System.debug('####### retParam' +retParam); 
        }
            
		system.debug('**** Number of groups detected: ' + grList.size());
		if(grList.size() > 0){
			
			for(Group__c g : grList){
					map_gr_app.put(g.Id, new list<Applicant_Info__c>());
					mapInvoicesByGroup.put(g.Id, new list<Intrax_Program_Upload__c>());
					mapOtherDocsByGroup.put(g.Id, new list<Intrax_Program_Upload__c>());
					
					mapdocTypesByGroup.put(g.Id, new map<string, boolean>());
					mapdocTypesByGroup.get(g.Id).put('Itinerary', false);
					mapdocTypesByGroup.get(g.Id).put('Group-Agreement', false);
					mapdocTypesByGroup.get(g.Id).put('Group-Proposal', false);
					mapdocTypesByGroup.get(g.Id).put('Invoice', false);
					mapdocTypesByGroup.get(g.Id).put('Welcome-Document', false);					
					mapdocTypesByGroup.get(g.Id).put('Crisis-Plan', false);
					mapdocTypesByGroup.get(g.Id).put('University-Group-Uploads', false);
					mapdocTypesByGroup.get(g.Id).put('Program-Feedback', false);
					mapdocTypesByGroup.get(g.Id).put('Pre-Departure-Orientation-Info', false);
					mapdocTypesByGroup.get(g.Id).put('Proof-of-Insurance', false);
					mapdocTypesByGroup.get(g.Id).put('University-Group-Uploads', false);
					mapdocTypesByGroup.get(g.Id).put('Reference', false);
					
				}
			
			list<Applicant_Info__c> appInfoList = [SELECT Id, Group__c, Application_Stage__c, Engagement__c, Engagement__r.Status__c FROM Applicant_Info__c WHERE Group__c IN: grList];
			
			list<Intrax_Program_Upload__c> ipuList = [SELECT Id, Document_Type__c, Document_Guid__c, Group__c, createdDate, Name FROM Intrax_Program_Upload__c WHERE Group__c IN: grList order by createdDate desc];
			
			system.debug('***** Applications related to groups: ' + appInfoList.size());
			
			if(appInfoList.size() > 0){
				list<Person_Info__c> personInfoList = [SELECT Id, Primary_Applicant__c, First_Name__c, Last_Name__c, Applicant_Info__c, Email__c FROM Person_Info__c 
														WHERE Applicant_Info__c IN: appInfoList
														AND Primary_Applicant__c =: true];
				
				
														
								
				for(Applicant_Info__c a : appInfoList){
					map_gr_app.get(a.Group__c).add(a);
				}
				
				for(Person_Info__c p: personInfoList){
					map_app_person.put(p.Applicant_Info__c, p);
				}			
				
			}
			
			// Building the documents map
			for(Intrax_Program_Upload__c i : ipuList){
				mapdocTypesByGroup.get(i.Group__c).put(i.Document_Type__c, true);
			}
			
			// Identifying the Invoices we have related to each group
			for(Group__c g : grList){
				if(mapDocTypesByGroup.get(g.Id).get('Invoice') == true || mapDocTypesByGroup.get(g.Id).get('University-Group-Uploads') == true){
					for(Intrax_Program_Upload__c i : ipuList){		
						if(i.Document_Type__c == 'Invoice' && i.Group__c == g.Id){										
							mapInvoicesByGroup.get(g.Id).add(i);
						}else if(i.Document_Type__c == 'University-Group-Uploads' && i.Group__c == g.Id){
							mapOtherDocsByGroup.get(g.Id).add(i);
						}
					}
				}
			}
			
			
		}	
		
		//Resource and report Links (Start)		
		SocialDevlink ='';
		Businesslink ='';
		Directlink ='';
		UnivReportLink = '';
		
		DocumentList = new list<Document>();
		DocumentList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name, d.Keywords, d.Description, d.type, d.BodyLength From Document d WHERE d.Folder.DeveloperName = 'UniversityPortalAdmin'];
		if (DocumentList != NULL && DocumentList.size() > 0){
			for (Document singleDoc: DocumentList){
				if(singleDoc.Keywords == 'social-dev')
				{
					SocialDevlink = singleDoc.id;
				}
				if(singleDoc.Keywords == 'Business')
				{
					Businesslink = singleDoc.id;
				}
				if(singleDoc.Keywords == 'Direct')
				{
					Directlink = singleDoc.id;
				}
			}
		}
		
		list <report> rpts = [select id, name, description from report where ownerid IN (select id from folder where developername = 'MyIntrax_IGI_University') and ownerid != null ];
		if (rpts != NULL && rpts.size() >0)
		{
			UnivReportLink = rpts[0].Id;
		}
		//Resource and report Links (End)
			
	}
	
	public PageReference load_by_doctype(){
		Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();	    
	    system.debug('DocType: ' +ApexPages.currentPage().getParameters().get('dType') );
	    system.debug('GroupId: ' +ApexPages.currentPage().getParameters().get('groupId') );
	    	    
	    loadDoc = [Select Document_service__c,Name,Document_GUID__c, createdDate, document_type__c, Group__c
	    				from Intrax_Program_Upload__c 
	    				where document_type__c =: ApexPages.currentPage().getParameters().get('dType')
	    				and Group__c =: ApexPages.currentPage().getParameters().get('groupId')
	    				order by createdDate desc limit 1];	
	    				
	    PageReference p = load(loadDoc);
	    return p;	    
	}
	
	public PageReference load_by_docGuid(){
		Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();	    

	    loadDoc = [Select Document_service__c,Name,Document_GUID__c, createdDate
	    				from Intrax_Program_Upload__c 
	    				where document_GUID__c =: ApexPages.currentPage().getParameters().get('docGUID')
	    				//and Group__c =: ApexPages.currentPage().getParameters().get('groupId')
	    				order by createdDate desc];	
	    				
	    PageReference p = load(loadDoc);
	    return p;	    
	}
	
	public PageReference load( Intrax_Program_Upload__c loadDoc){
    
	    // Instantiate a new http object 
	    Http h = new Http();
	    HttpResponse res = new HttpResponse();
	    
	    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
	    HttpRequest req = new HttpRequest();
	    req.setMethod('POST'); 
	    //AA Fixed View File functionality.
	    req.setHeader('Accept', 'application/xml');
	    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
	    String body = '';
	    if (loadDoc.Document_service__c == 'DS'){
	        req.setEndpoint(Constants.documentService+'GetFile');
	    }
	    /*
	    else if(loadDoc.Document_service__c == 'VS'){
	        req.setEndpoint(Constants.videoService+'GetVideoSignedUrl');
	    }*/
	    else{	        
	        req.setEndpoint(Constants.imageService+'GetFile');
	    }
	    
	    body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';
	
	    /*if(loadDoc.Document_service__c=='VS'){
	     	body = body + ApexPages.currentPage().getParameters().get('docGuid') +'&protocol=rtmp';
	    } else{
	     	body = body + ApexPages.currentPage().getParameters().get('docGuid');
	    }*/
	    body = body + loadDoc.Document_GUID__c;
	    
	    system.debug('debug::RequestBody'+body);
	    req.setBody(body);
	    Dom.Document docRes = new Dom.Document();
	    String returnurl = null;
	    
	    if (!Test.isRunningTest()){
	         res = h.send(req);
	
	         responseXML = res.getBody();
	
	         docRes.load(responseXML);
	         List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
	         //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
	         for (dom.XmlNode node : resnodelist){
	            
	            system.debug('debug::node.Name=='+node.getName());
	            system.debug('debug::node.getText=='+node.getText());
	              
                if (loadDoc.Document_service__c != 'VS' && node.getName() == 'result'){
                    returnurl = node.getText();
                    //spillai video changes
                    return new PageReference(returnurl);
                }
                /* 
                if (loadDoc.Document_service__c == 'VS' && node.getName() == 'signedUrl'){
                    system.debug('debug::VS==node.Name=='+node.getName());
                    returnurl = node.getText();
                    //spillai video changes
                    rtmpUrlVideo = returnurl;
                    PageReference videoPage = Page.playVideo;
                    return null;
                }*/
                
                if(node.getName() == 'error'){
                //customMessage=true;
                string error= node.getText();
                    if(error.contains('is not found')){                        
                        if(Site.getBaseUrl() != null && Site.getBaseUrl().contains('force.com')){
	                        pageReference p = new pageReference('/apex/SiteDocViewer?id=' + applicantInfo.Id+'&docGuid='+loadDoc.Document_GUID__c);
	                        p.setRedirect(true);
	                        return p;   
                        } else{
	                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, we appear to be unable to locate this file. Document GUID='+loadDoc.document_Guid__c);
	                        ApexPages.addMessage(msg);
	                        return null;
                        }
                    }
                }   
	         }
	         //spillai video changes
	         return null;
	    }
	    else{
	        return new PageReference('');
	    }
	 
	}
	
	public boolean isHealthInfoCompleted{get;set;}
	public boolean isAppFeeCompleted{get;set;}
	public boolean isAppPaymentCompleted{get;set;}
	
	public void update_applicant_info(){
		system.debug('******* AppInfo Value: ' + ApexPages.currentPage().getParameters().get('appInfo'));
		system.debug('******* Group Id Value: ' + ApexPages.currentPage().getParameters().get('groupId'));
		
		applicantInfo = [SELECT Id, Name, Home_Street_1__c, Home_Street_2__c, Home_City__c, Home_State__c, Home_Country__c, Home_postal_Code__c, Language_1__c, Language_1_Proficiency__c, 
							Language_2__c, Language_2_Proficiency__c, Language_3__c, Language_3_Proficiency__c, Engagement__c, Resume__c, Passport_Number__c, PageStatus_Complete__c, 
							Opportunity_Name__c, Opportunity_Name__r.Application_Fee_Received__c, Opportunity_Name__r.Payment_Received__c, Terms_Accepted__c
							FROM Applicant_Info__c WHERE ID =: ApexPages.currentPage().getParameters().get('appInfo')];
		
		if(applicantInfo.PageStatus_Complete__c != null && applicantInfo.PageStatus_Complete__c.Contains('059')) isHealthInfoCompleted = true;
		else isHealthInfoCompleted = false;
		
		if(applicantInfo.Opportunity_Name__c != null && applicantInfo.Opportunity_Name__r.Application_Fee_Received__c != null) isAppFeeCompleted = true;
		else isAppFeeCompleted = false;
		
		if(applicantInfo.Opportunity_Name__c != null && applicantInfo.Opportunity_Name__r.Payment_Received__c != null) isAppPaymentCompleted = true;
		else isAppPaymentCompleted = false;
		
		personInfo = [SELECT Id, Name, First_Name__c, Last_Name__c, Applicant_Info__c, Primary_Applicant__c, Date_of_Birth__c, Gender__c, Country_of_Residence__c, Citizenship__c, Email__c, Skype_Id__c, Phone_Country_Code__c, Phone__c,
							Phone_Country_Code_Other__c, Other_Phone__c, Role_Other__c, Health_Concerns__c
							FROM Person_Info__c WHERE Primary_Applicant__c =: true AND Applicant_Info__c =: applicantInfo.Id];

		emergencyList = [SELECT Id, Emergency_Contact_Indicated__c, First_Name__c, Last_Name__c, Email__c, Mobile__c, Role_Other__c, Applicant_Info__c
							FROM Person_Info__c 
							WHERE Emergency_Contact_Indicated__c = 'Yes' 
							AND Applicant_info__c =: applicantInfo.Id];
		
	}
	
	public pageReference checkLogin(){
        system.debug('****** UserName' + userInfo.getUserName());
        system.debug('****** Usertype' + userInfo.getUserType());
        if(userInfo.getUserType() == 'Guest'){
            pageReference p = Page.AppEngine_SiteLoginPage;
            p.setRedirect(true);
            return p;
        }else return null;        
    }
    
    
    //For Resource Documents and report (Start)
    public PageReference getDocumentUrl(){
        string str = '/servlet/servlet.FileDownload?file=' + ApexPages.currentPage().getParameters().get('guid');
        return new PageReference(str);
    }
    
    public PageReference getReportUrl()
    {
        string str = '/' + ApexPages.currentPage().getParameters().get('guid') + '?export=1&enc=UTF-8&xf=xls';
        return new PageReference(str);
    }
    
    //For Resource Documents and report (End)
}