global class Batch_Notifications_APC_PTAppCreated implements Database.Batchable<sObject>, Schedulable
{
    //List<Match__c> confMatchList = new List<Match__c>();
    List<Notification__c> APCNotificationListPT = new List<Notification__c>();
    List<Portal_Content__c> pContentListPT = new List<Portal_Content__c>();
    
    global Database.Querylocator start(Database.BatchableContext BC )
    {
        Date triggerDate1= System.today()-1;
        Date triggerDate2 = System.today()-2;
        return Database.getQueryLocator([SELECT Id,CreatedBy__c,Name,Intrax_Program__c,Type__c,Intrax_Program_Options__c,CreatedById,Account__c,Partner_Account__c,APplication_Type__c, APplication_Level__c,Application_Stage__c,Accepted_Date__c,CreatedDate FROM Applicant_Info__c WHERE Intrax_Program__c='AuPairCare' AND Type__c='Participant' AND Application_Type__c='Original' AND Application_Stage__c='Working' AND (DAY_ONLY(CreatedDate)=:TriggerDate1 OR DAY_ONLY(CreatedDate)=:TriggerDate2)]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Applicant_Info__c> accAppList )
    {
        System.debug('list size------>'+accAppList.size());
               
        if(accAppList!=null && accAppList.size()>0){
            pContentListPT = getPCList('Reminder to Complete App PT','Participant');
         
            for(Applicant_Info__c app:accAppList){
                if(pContentListPT!=null && pContentListPT.size()>0){
                    //call notification generator method to create notification.
                    //createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                     
                    Notification_Generator.createAPCNotificationFromCS(app,pContentListPT[0].Notification_Type__c,pContentListPT[0].Short_Summary__c,pContentListPT[0].Subject__c,pContentListPT[0].Body__c, pContentListPT[0].Dynamic_Content__c,pContentListPT[0].Urgency__c,pContentListPT[0].User_Type__c, pContentListPT[0].Header_Image__c);
                }
                
            }
        }        
        
    }          
      
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc){
        Batch_Notifications_APC_PTAppCreated batch = new Batch_Notifications_APC_PTAppCreated();
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