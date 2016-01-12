global class Batch_Notifications_APC_EngProofEdu implements Database.Batchable<sObject>, Schedulable
{
    //JOSE B-02918 Notification APC
    //List<Match__c> confMatchList = new List<Match__c>();
    List<Notification__c> APCNotificationListPT = new List<Notification__c>();
    List<Portal_Content__c> pContentListPT = new List<Portal_Content__c>();
    
    global Database.Querylocator start(Database.BatchableContext BC )
    {
        //90 days before eng end date
        Date triggerDate = System.today()+30;
        //List<Engagement__c> engList = [SELECT Id,Name,Intrax_Program__c,Type__c,Engagement_End__c,Engagement_Start__c,Intrax_Program_Options__c,CreatedById,Account_Id__c,Arrival_PNR_Number__c,Dep_PNR_number__c FROM Engagement__c WHERE Intrax_Program__c = 'AuPairCare' AND Type__c='Participant' AND Engagement_End__c =: triggerDate];
         
        return Database.getQueryLocator([SELECT Id,Name,Intrax_Program__c,Type__c,Engagement_End__c,Engagement_Start__c,Intrax_Program_Options__c,CreatedById,Account_Id__c,Arrival_PNR_Number__c,Dep_PNR_number__c FROM Engagement__c WHERE Intrax_Program__c = 'AuPairCare' AND Type__c='Participant' AND Status__c='On Program' AND Engagement_End__c =: triggerDate]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Engagement__c> engList )
    {
        try{
        system.debug('list size------>'+engList.size());
        set<Id> Engset=new set<Id>();       
        list<Engagement__c> engListAux = new list<Engagement__c>();
        if(engList!=null && engList.size()>0){
            for(Engagement__c eng: engList){
                    Engset.add(eng.Id);
            }
            
            pContentListPT = getPCList('Proof Education Reminder','Participant');
         	list<Intrax_Program_Upload__c> ProofList = [Select document_name__c, Engagement__c, Document_Type__c, document_guid__c from Intrax_Program_Upload__c
	                        							   where Engagement__c in:Engset AND Document_Type__c IN ('Proof-of-Education') AND Review_Status__c ='Accepted' order by CreatedDate desc ];
	        
	        system.debug('debug::Inside isProofEducation ====' + ProofList);
            
	        if(ProofList!=null && ProofList.size()>0){
	        	for(Intrax_Program_Upload__c ipu:ProofList){
	            	Engset.remove(ipu.Engagement__c);    
	            }
	            engListAux = [SELECT Id,Name,Intrax_Program__c,Type__c,Engagement_End__c,Engagement_Start__c,Intrax_Program_Options__c,CreatedById,Account_Id__c,Arrival_PNR_Number__c,Dep_PNR_number__c 
	            FROM Engagement__c 
	            WHERE id in:Engset];
	            
	            if(engListAux!=null && engListAux.size()>0){
	            	for(Engagement__c eng:engListAux){
	                	if(pContentListPT!=null && pContentListPT.size()>0){
	                    	//call notification generator method to create notification.
	                    	//createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                   
	                    	Notification_Generator.createAPCNotificationFromCS(eng,pContentListPT[0].Notification_Type__c,pContentListPT[0].Short_Summary__c,pContentListPT[0].Subject__c,pContentListPT[0].Body__c, pContentListPT[0].Dynamic_Content__c, pContentListPT[0].Urgency__c,pContentListPT[0].User_Type__c,  pContentListPT[0].Header_Image__c);
	                	}
	                }
	            }
	            	
	        }else{                							      
		        for(Engagement__c eng:engList){
	                if(pContentListPT!=null && pContentListPT.size()>0){
	                    //call notification generator method to create notification.
	                    //createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                   
	                    Notification_Generator.createAPCNotificationFromCS(eng,pContentListPT[0].Notification_Type__c,pContentListPT[0].Short_Summary__c,pContentListPT[0].Subject__c,pContentListPT[0].Body__c, pContentListPT[0].Dynamic_Content__c, pContentListPT[0].Urgency__c,pContentListPT[0].User_Type__c,  pContentListPT[0].Header_Image__c);
	                }
	                
	            }
	        }
        }
        }catch(Exception e){
        	system.debug('Exception in Batch_Notifications_APC_EngProofEdu: ' + e);
        }        
        
    }          
      
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc){
    	Batch_Notifications_APC_EngProofEdu batch = new Batch_Notifications_APC_EngProofEdu();
		Database.executeBatch(batch, 20);
    }
    
    global List<Portal_Content__c> getPCList(string sKey, string sUserType){
        List<Portal_Content__c> PortalContentList = [SELECT Id,Name,Type__c,Object__c,Record_Type_Name__c,Status__c,key__c,RegEx__c,Notification_Type__c,
                                                     Short_Summary__c,Subject__c,Body__c,Dynamic_Content__c,Urgency__c,User_Type__c, Header_Image__c FROM Portal_Content__c 
                                                     WHERE Type__c='Notification' AND Key__c=:sKey AND User_Type__c=:sUserType LIMIT 1];
        
        if(PortalContentList!=null && PortalContentList.size()>0)
            return PortalContentList;
        else
            return null;
    }

}