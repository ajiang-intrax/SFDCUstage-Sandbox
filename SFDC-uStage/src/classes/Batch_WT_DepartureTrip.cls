global class Batch_WT_DepartureTrip implements Database.Batchable<sObject>
{
	list<Engagement__c> allEngagements = new list<Engagement__c>();
	
	global Database.Querylocator start(Database.BatchableContext BC )
	{
		return Database.getQueryLocator([SELECT ID, Name FROM Engagement__c WHERE Status__c = 'On Program' AND Intrax_Program__c = 'Work Travel' AND Engagement_End__c <= :date.today()+14]);
	}
	
	global void execute(Database.BatchableContext BC, List<Engagement__c> EnggList )
	{
		SET<ID> AllEnggList = new SET<ID>();
		system.debug('***EnggList****'+EnggList);
		for(Engagement__c SingleEngg : EnggList)       	
		{
			AllEnggList.add(SingleEngg.ID);
		}
		
		list<Trip__c> TripList = [SELECT ID, Engagement__r.ID FROM Trip__c WHERE Engagement__c != NULL AND Engagement__c IN :AllEnggList AND Departure_from_Host_Community__c = :true];
		
		if(TripList.size() > 0)
		{
			for(Trip__c SingleTrip :TripList)
			{
				AllEnggList.remove(SingleTrip.Engagement__r.ID);
			}
		}
		
		list<Notification__c> DepartNotifications = [SELECT ID, Engagement__r.ID FROM Notification__c WHERE Type__c = 'Departure Info Needed' AND Engagement__c != NULL AND Engagement__c IN :AllEnggList];
		
		if(DepartNotifications.size() > 0)
		{
			for(Notification__c SingleDepartNotifications :DepartNotifications)
			{
				AllEnggList.remove(SingleDepartNotifications.Engagement__r.ID);
			}
		}
		if(AllEnggList != NULL && AllEnggList.size() > 0)
		{
			Notification_Generator.CreateDepartureNotification(AllEnggList);
		}
    }          
          
    global void finish(Database.BatchableContext BC)
    {
        
    }
}