global class Batch_Notifications_APC_EngPlanForDep implements Database.Batchable<sObject>, Schedulable
{
    //List<Match__c> confMatchList = new List<Match__c>();
    List<Notification__c> APCNotificationListPT = new List<Notification__c>();
    List<Portal_Content__c> pContentListPT = new List<Portal_Content__c>();
    
    global Database.Querylocator start(Database.BatchableContext BC )
    {
        //90 days before eng end date
        Date triggerDate = System.today()+90;
        //List<Engagement__c> engList = [SELECT Id,Name,Intrax_Program__c,Type__c,Engagement_End__c,Engagement_Start__c,Intrax_Program_Options__c,CreatedById,Account_Id__c,Arrival_PNR_Number__c,Dep_PNR_number__c FROM Engagement__c WHERE Intrax_Program__c = 'AuPairCare' AND Type__c='Participant' AND Engagement_End__c =: triggerDate];
         
        return Database.getQueryLocator([SELECT Id,Name,Intrax_Program__c,Type__c,Engagement_End__c,Engagement_Start__c,Intrax_Program_Options__c,CreatedById,Account_Id__c,Arrival_PNR_Number__c,Dep_PNR_number__c FROM Engagement__c WHERE Intrax_Program__c = 'AuPairCare' AND Type__c='Participant' AND Engagement_End__c =: triggerDate]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Engagement__c> engList )
    {
        System.debug('list size------>'+engList.size());
               
        if(engList!=null && engList.size()>0){
            pContentListPT = getPCList('Planning for Departure PT','Participant');
         
            for(Engagement__c eng:engList){
                if(pContentListPT!=null && pContentListPT.size()>0){
                    //call notification generator method to create notification.
                    //createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                   
                    Notification_Generator.createAPCNotificationFromCS(eng,pContentListPT[0].Notification_Type__c,pContentListPT[0].Short_Summary__c,pContentListPT[0].Subject__c,pContentListPT[0].Body__c, pContentListPT[0].Dynamic_Content__c, pContentListPT[0].Urgency__c,pContentListPT[0].User_Type__c,  pContentListPT[0].Header_Image__c);
                }
                
            }
        }        
        
    }          
      
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc){
    	Batch_Notifications_APC_EngPlanForDep batch = new Batch_Notifications_APC_EngPlanForDep();
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