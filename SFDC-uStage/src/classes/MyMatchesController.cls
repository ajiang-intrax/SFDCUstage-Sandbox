public without sharing class MyMatchesController {
    //Initial Definitions
    public Account accInfo{get;set;}
    public Contact contactInfo;
    public Match__c matchInfo{get;set;}
    public List<Match__c> matchInfoList{get;set;}
    public List<Match__c> InterviewsList{get;set;}
    public Engagement__c engagementInfo{get;set;}
    public list<Engagement__c> EngagementInfoList{get;set;}
    public List<Position__c> positionInfo{get;set;}
    public List<Position__c> positionInfoList;
    
    // Properties  
    public string mId {get; set{
        mId = value;
        }
    }
    
    public string nextPage{get;set{
        nextPage = value;
        }
    }   
    
    public PageReference navigator(){
        
        PageReference P = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        
        if (ApexPages.currentPage().getParameters().get('mId') != null){
               P.getParameters().put('mId',ApexPages.currentPage().getParameters().get('mId'));
        }
        
            
        P.setRedirect(true);
        return P;    
    }   
    
    public MyMatchesController(){
        
        User activeUser = [select Id, Intrax_Id__c from User where Id = : userInfo.getUserId()];
        
        system.debug('*************** userID: ' +activeUser.Intrax_Id__c);      
        if(activeUser.Id != null){
        	try{
            	accInfo = [SELECT Id, Name, Intrax_Id__c, Type FROM Account WHERE Intrax_Id__c =: activeUser.Intrax_Id__c LIMIT 1]; 
            	system.debug('*************** Account ID: ' + accInfo.Name);
            
            	if(accInfo.Type == 'Participant'){
                    engagementInfoList = [Select e.Type__c, e.Terms_Accepted__c, e.TEFL_Course_Taken__c, e.SystemModstamp, e.Status__c, e.Resume_Received__c, e.Resume_Rating__c, e.RecordTypeId, e.Preparedness_Rating__c, e.Position_Types__c, e.Position_Types_Other__c, e.OwnerId, e.Opportunity_Id__c, e.Name, e.Match_Notes__c, e.Location_of_Interest__c, e.LastModifiedDate, e.LastModifiedById, e.IsDeleted, e.Intrax_Region__c, e.Intrax_Program__c, e.Intrax_Program_Options__c, e.Id, e.Functional_Areas__c, e.Functional_Areas_Other__c, e.Experience_Summary__c, e.Engagement_Start__c, e.Engagement_End__c, e.Engagement_Country__c, e.Description__c, e.CreatedDate, e.CreatedById, e.ConnectionSentId, e.ConnectionReceivedId, e.Attitude_Rating__c, e.Account_Id__c 
                    						From Engagement__c e
                    						Where e.Account_Id__c =: accInfo.Id
                    						AND Intrax_Program__c =: 'Internship'];
                    system.debug('**************** GENERAL PAGE');
                
                    matchInfoList = [SELECT Engagement__c, Participant_Id__c, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,
                                            	Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_Company_Id__r.Industry
                                            	FROM Match__c 
                                        	WHERE Engagement__c IN: engagementInfoList
                                        	AND Status__c != 'Withdrawn' 
                                        	//AND Interview_status__c!=null  
                                        	order by Interview_Date__c DESC LIMIT 3];
                    system.debug('****** HC Id: '+ matchInfoList[0].Position_Name__r.Host_Company_Id__c);
                    system.debug('****** HC Id: '+ matchInfoList[0].Position_Name__r.Host_Company_Id__r.Id);
                	system.debug('****** HC Name: '+ matchInfoList[0].Position_Name__r.Host_Company_Id__r.Name);
                	
                    InterviewsList = [SELECT Engagement__c, Participant_Id__c, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,
                                            Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_Company_Id__r.Industry
                                            FROM Match__c 
                                        	WHERE Engagement__c IN: engagementInfoList
                                        AND Status__c != 'Withdrawn' AND Interview_Status__c = 'Scheduled'   order by Interview_Date__c DESC LIMIT 3];
                    
                    system.debug('************* List of Matches: '+ matchInfoList);         
                }
        	}catch(Exception e){
                system.debug('*********** ' + e);
            }
        
            try{
	                if(accInfo.Type == 'Host Company'){
	                	matchInfoList = new list<Match__c>();
	                	positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
		                                        FROM Position__c 
		                                        WHERE Host_Company_Id__c =: accInfo.Id];
		                system.debug('************* position:' + positionInfoList);
		                
		                if(positionInfoList.size() > 0){
		                    List<Match__c> mAux;
		                    List<Match__c> mAux2 = new list<Match__c>();
		                    for(Position__c p : positionInfoList){
		                        mAux = [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
		                            Name, Participant_Id__c, status__c,Participant_Id__r.Best_Call_Time__pc, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c        
		                             FROM Match__c WHERE Position_Name__c =: p.Id ];
		                        system.debug('************** mAUX: ' + mAux);
		                                    
		                        if(mAux.size() > 0){
		                            mAux2.addAll(mAux);
		                        }
		                        
		                    }
	                	
	                	 matchInfoList = [SELECT Engagement__c, Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c, Offer_Status__c, Participant_Id__c, Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Participant_Id__r.LastName, Participant_Id__r.FirstName, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,
		                                       Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_company_Id__r.Industry
		                                       FROM Match__c WHERE Id IN: mAux2 order by CreatedDate DESC LIMIT 3];
	                	
	                	
	                	
	                	
	                	
	                	/*
	                    positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
	                                            FROM Position__c 
	                                            WHERE Host_Company_Id__c =: accInfo.Id];
	                    system.debug('************* position:' + positionInfoList);
	                    
	                    if(positionInfoList.size() > 0){
	                        List<Match__c> mAux;
	                        List<Match__c> mAux2 = new list<Match__c>();
	                        for(Position__c p : positionInfoList){
	                            mAux = [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                                        	Name, Participant_Id__c, status__c,Participant_Id__r.Best_Call_Time__pc, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c        
                                         	FROM Match__c 
                                         	WHERE Position_Name__c =: p.Id AND Status__c != 'Withdrawn' LIMIT 3];
	                            system.debug('************** mAUX: ' + mAux);
	                                        
	                            if(mAux.size() > 0 ){
	                                mAux2.addAll(mAux);
	                            }
	                            
	                        }
	                        matchInfoList = [SELECT Engagement__c, Participant_Id__c, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,
                                            	Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_Company_Id__r.Industry
                                            	FROM Match__c  
                                         		WHERE Id IN: mAux2 
                                         		AND Interview_status__c != 'Company Declined Interview' and Interview_status__c!=null  ORDER BY Interview_Date__c ASC LIMIT 3];
	                        system.debug('****** HC Id: '+ matchInfoList[0].Position_Name__r.Host_Company_Id__c);
                    		system.debug('****** HC Id: '+ matchInfoList[0].Position_Name__r.Host_Company_Id__r.Id);
                			system.debug('****** HC Name: '+ matchInfoList[0].Position_Name__r.Host_Company_Id__r.Name);
	                        */
	                         positionInfo = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c 
			                                    FROM Position__c 
			                                    WHERE  Host_Company_Id__c =: accInfo.Id];
	              
	                         InterviewsList =  [SELECT Id, Name, status__c,Interview_Status__c,Participant_Id__r.LastName,Participant_Id__r.FirstName,Interview_Date__c,Participant_Id__r.Skype_ID__pc,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c,
				                                    Position_Name__r.Host_Company_Id__c,Participant_Id__r.Best_Call_Time__pc, Position_Name__r.Regional_Location__c, Position_Name__r.Position_Supervisor__r.Name,Position_Name__r.Name, Position_Name__c, Position_Name__r.Host_Company_Id__r.Name FROM Match__c 
				                                    WHERE Position_Name__c IN: positionInfo
				                                    AND Interview_Status__c = 'Scheduled' ORDER BY Interview_Date__c ASC LIMIT 3];
	                                                     
	                    }
	                }
	            }
                catch(Exception e){
                    system.debug('*********** ' + e);
                }
            }
        }
    }