global class Batch_Notifications_APC_MatchAcademy implements Database.Batchable<sObject>, Schedulable
{
    //List<Match__c> confMatchList = new List<Match__c>();
    List<Notification__c> APCNotificationListPT = new List<Notification__c>();
    List<Portal_Content__c> pContentListPT = new List<Portal_Content__c>();
    
    global Database.Querylocator start(Database.BatchableContext BC )
    {
        //14 days after match Start date
        Date triggerDate1 = System.today()+14;
         
        return Database.getQueryLocator([SELECT Id,Name,Intrax_Program__c,Intrax_Program_Option__c,Status__c,Start_Date__c,End_Date__c, Airport_Code__c, Engagement__c, Engagement__r.In_Country__c, Participant_Id__c,Position_Name__c,CreatedById,Position_Name__r.Host_Company_Id__c,Match_Date__c, HF_Arrival_Date__c FROM Match__c WHERE Intrax_Program__c = 'AuPairCare' AND Status__c = 'Confirmed' AND Airport_Code__c = null AND Engagement__r.In_Country__c = 'No' AND Start_Date__c =: triggerDate1 ]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Match__c> confMatchList )
    {
        System.debug('list size------>'+confMatchList.size());
               
        if(confMatchList!=null && confMatchList.size()>0){
            pContentListPT = getPCList('Academy Hotel Info Reminder','Host');
         
            for(Match__c m:confMatchList){
                if(pContentListPT!=null && pContentListPT.size()>0){
                    //call notification generator method to create notification.
                    //createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                     
                    Notification_Generator.createAPCNotificationFromCS(m,pContentListPT[0].Notification_Type__c,pContentListPT[0].Short_Summary__c,pContentListPT[0].Subject__c,pContentListPT[0].Body__c,pContentListPT[0].Dynamic_Content__c, pContentListPT[0].Urgency__c,pContentListPT[0].User_Type__c, pContentListPT[0].Header_Image__c);
                }
                
            }
        }        
        
    }          
      
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc){
        Batch_Notifications_APC_MatchAcademy batch = new Batch_Notifications_APC_MatchAcademy();
        Database.executeBatch(batch, 20);
    } 
    
    global List<Portal_Content__c> getPCList(string sKey, string sUserType){
        List<Portal_Content__c> PortalContentList = [SELECT Id,Name,Type__c,Object__c,Record_Type_Name__c,Status__c,key__c,RegEx__c,Notification_Type__c,
                                                     Short_Summary__c,Subject__c,Body__c,Dynamic_Content__c,Urgency__c,User_Type__c,Header_Image__c FROM Portal_Content__c 
                                                     WHERE Type__c='Notification' AND Key__c=:sKey AND User_Type__c=:sUserType LIMIT 1];
        
        if(PortalContentList!=null && PortalContentList.size()>0)
            return PortalContentList;
        else
            return null;
    }

}