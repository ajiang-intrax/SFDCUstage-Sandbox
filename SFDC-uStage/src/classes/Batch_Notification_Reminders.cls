global class Batch_Notification_Reminders implements Database.Batchable<sObject>
{
	list<Notification__c> allParentID = new list<Notification__c>();
	set<ID> allUniqueParentID = new set<ID>();
	list<Notification__c> NotificationQry = new list<Notification__c>();
	
	public static list<JobSettings__c> JobSettingList;
    public Integer getIntervalDays()
    {
    	Integer IntValDays = 7;
        JobSettingList = JobSettings__c.getAll().values();
        if(JobSettingList != null && JobSettingList.size() > 0){
            for(JobSettings__c js : JobSettingList){
                if(js.Name == 'NotificationReminderBatch'){
                    IntValDays = integer.valueOf(js.Interval_in_Days__c);
                }
            }
        }
        return IntValDays;
    } 
	
	global Database.Querylocator start(Database.BatchableContext BC )
	{
		system.debug('getIntervalDays()**'+ getIntervalDays());
		allParentID = [SELECT Parent_Notification__r.id FROM Notification__c WHERE ((Intrax_Program__c = 'Work Travel' or Intrax_Program__c = 'Internship' ) AND (Status__c = 'Not Started' OR Status__c = 'Incomplete') AND (Email_Sent_At__c != NULL AND Email_Sent_At__c <= :datetime.now()-getIntervalDays()) AND (Engagement__c != NULL) AND (Engagement__r.status__c NOT IN ('Cancelled', 'Terminated', 'Program Complete','Early Departure')) AND (Is_Parent__c = false))];
		
		for (Integer i = 0; i< allParentID.size(); i++)
		{
			allUniqueParentID.add(allParentID[i].Parent_Notification__r.id); 
		} 
		
		return Database.getQueryLocator([SELECT ID, Name FROM Notification__c WHERE ID IN :allUniqueParentID AND Contact__c != NULL]);
	}
	
	global void execute(Database.BatchableContext BC, List<Notification__c> NotifyList )
	{
		Map<Id,Notification__c> MapNotifyToBeUpdated = new Map<Id,Notification__c>();
		
		list <Notification__c> updNotificationList = new list <Notification__c>();
       	list <Notification__c> AllChildNotificationList = [SELECT ID, Name FROM Notification__c WHERE ((Intrax_Program__c = 'Work Travel'  or Intrax_Program__c = 'Internship') AND (Parent_Notification__r.id IN :NotifyList) AND (Status__c = 'Not Started' OR Status__c = 'Incomplete') AND (Email_Sent_At__c != NULL AND Email_Sent_At__c <= :datetime.now()-getIntervalDays()) AND (Engagement__r.status__c NOT IN ('Cancelled', 'Terminated', 'Program Complete','Early Departure')) AND (Is_Parent__c = false))];
       
       	for(Notification__c PNotfy : NotifyList)
       	{
       		MapNotifyToBeUpdated.put(PNotfy.Id,PNotfy);
       	}
       	if (AllChildNotificationList != NULL && AllChildNotificationList.size() > 0)
       	{
	       	for(Notification__c CNotfy : AllChildNotificationList)
	       	{
	       		MapNotifyToBeUpdated.put(CNotfy.Id,CNotfy);
	       	}
       	}
       	
       	
       	Set<id> NotiIds = MapNotifyToBeUpdated.keySet() ;
        For(Id NId:NotiIds)
         {
              Notification__c SingleNotify = new Notification__c();
              SingleNotify = MapNotifyToBeUpdated.get(NId);
              SingleNotify.Email_Sent_At__c = datetime.now();
              updNotificationList.add(SingleNotify);
         }
         
         if(updNotificationList != NULL && updNotificationList.size() > 0)
       	 {
       		update updNotificationList;
       	 }
    	 
       	
    }          
      
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}