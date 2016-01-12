global class Batch_Notifications_ScheduledPayment implements Database.Batchable<sObject>, Schedulable{
    
	List<Notification__c> APCNotificationListHF = new List<Notification__c>();
    List<Portal_Content__c> pcPaymentList = new List<Portal_Content__c>();
    
    global Database.Querylocator start(Database.BatchableContext BC )
    {
        Date triggerDate = System.today()+3;
        return Database.getQueryLocator([SELECT Id,Ship_Date__c,Payment_Status__c,Account__c FROM Sales_Invoice__c WHERE Payment_Status__c='Open' AND Ship_Date__c!=NULL AND Ship_Date__c=:TriggerDate]);        
    }
    
    global void execute(Database.BatchableContext BC, List<Sales_Invoice__c> salesInvoiceList )
    {
        System.debug('list size------>'+salesInvoiceList.size());
               
        if(salesInvoiceList!=null && salesInvoiceList.size()>0){
            pcPaymentList = getPCList('Scheduled Payment Reminder','Host');
         
            for(Sales_Invoice__c SI:salesInvoiceList){
                if(pcPaymentList!=null && pcPaymentList.size()>0){
                    //call notification generator method to create notification.
                    //createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                   
                    Notification_Generator.createAPCNotificationFromCS(SI,pcPaymentList[0].Notification_Type__c,pcPaymentList[0].Short_Summary__c,pcPaymentList[0].Subject__c,pcPaymentList[0].Body__c, pcPaymentList[0].Dynamic_Content__c, pcPaymentList[0].Urgency__c,pcPaymentList[0].User_Type__c, pcPaymentList[0].Header_Image__c);
                }
                
            }
        }        
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc){
    	Batch_Notifications_ScheduledPayment batch = new Batch_Notifications_ScheduledPayment();
		Database.executeBatch(batch, 20);
    }
    
    global List<Portal_Content__c> getPCList(string sKey, string sUserType){
        List<Portal_Content__c> PortalContentList = [SELECT Id,Name,Type__c,Object__c,Record_Type_Name__c,Status__c,key__c,RegEx__c,Notification_Type__c,
                                                     Short_Summary__c,Subject__c,Body__c,Dynamic_Content__c,Urgency__c,User_Type__c, Header_Image__c  FROM Portal_Content__c 
                                                     WHERE Type__c='Notification' AND Key__c=:sKey AND User_Type__c=:sUserType LIMIT 1];
        
        if(PortalContentList!=null && PortalContentList.size()>0)
            return PortalContentList;
        else
            return null;
    }
}