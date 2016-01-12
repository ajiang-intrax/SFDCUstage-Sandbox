global class Batch_IGI_Visa_Status implements Database.Batchable<sObject>
{
	global Database.queryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator([SELECT Id, Status__c, Intrax_Program__c, Visa_Interview_Date__c, Visa_Interview_Status__c FROM Engagement__c
		                                WHERE Intrax_Program__c =: 'Internship'		                                
		                                AND Visa_Interview_Date__c != NULL AND Visa_Interview_Date__c <= :date.today()
		                                AND (Visa_Interview_Status__c = NULL OR Visa_Interview_Status__c = '' OR Visa_Interview_Status__c = 'Declined – Appealing Decision')
		                                AND Status__c =: 'Program Ready']);
	}
	
	global void execute (Database.BatchableContext BC, list<Engagement__c> EnggList)
	{
		set<id> EnggSet = new set<id>();
		
		for(Engagement__c SingleEngg : EnggList)    	
		{
			EnggSet.add(SingleEngg.ID);
		}
		
		//Check whether there is already a visa result notification which is not completed yet
		//If yes, remove that engagement from list and call the IGINotifications for other engagements.
		list<Notification__c> VisaNotifications = [SELECT ID, Engagement__r.ID FROM Notification__c WHERE Type__c = 'Visa Result' AND (Status__c = 'Not Initiated' or Status__c = 'Not Started' or Status__c = 'In Progress') AND Engagement__c != NULL AND Engagement__c IN :EnggSet];
		
		if(VisaNotifications.size() > 0)
		{
			for(Notification__c SingleVisaNotifications :VisaNotifications)
			{
				EnggSet.remove(SingleVisaNotifications.Engagement__r.ID);
			}
		}
		if(EnggSet != NULL && EnggSet.size() > 0)
		{
			System.debug('Calling IGI Notifications');
			Notification_Generator.sendIGINotifications(EnggSet);
		}
	}
	global void finish(Database.BatchableContext BC)
	{
    }
}