/*
    Purpose         :   This class is to create the unique contact records in Notify object.
    					This class fecth contacts related to the Host Company. This HC should be stamped on Position related to Match records.
                
    Created Date    :   04/01/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
global class Batch_CreateNotifyRecords implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator('SELECT ID FROM ACCOUNT');
	}
	
	//execute method
	global void execute(Database.BatchableContext BC, List<SObject> scope) {
		
	}
	
	/*//start method to create the initial query and retrieve the appropriate records
	global Database.QueryLocator start(Database.BatchableContext bc) {
		
		//check if running from test method then only execute one batch with the latest data
		if(Test.isRunningTest())
			return Database.getQueryLocator('Select Id, Position_Name__r.Host_Company_ID__c from Match__c where Notify__c = true Order by CreatedDate Desc limit 1');
		return Database.getQueryLocator('Select Id, Position_Name__r.Host_Company_ID__c from Match__c where Notify__c = true');
	}
	
	//execute method
	global void execute(Database.BatchableContext BC, List<SObject> scope) {
		
		//Loop through the current list and create a set of the accounts
		Set<Id> setAccountIds = new Set<Id>(); 
		
		for(Match__c match : (List<Match__c>)scope) {
			if(match.Position_Name__r.Host_Company_ID__c != null) {
				setAccountIds.add(match.Position_Name__r.Host_Company_ID__c);
			}
		}
		
		//Create a set of Contact ids
		Set<Id> contactIdsToBeNotified = new Set<Id>();
		
		//loop through the current list and create a set of contact records
		for (Account company : [Select Id, (Select Id from Contacts limit 1) from Account where Id IN: setAccountIds]) {
			if(company.Contacts != null && company.Contacts.size() > 0)
				contactIdsToBeNotified.add(company.Contacts[0].Id);
		}
		
		//Create a list of existing contacts in Notify object
		Set<Id> existingIds = new Set<Id>();
		
		//Existing contacts
		for(Notify__c notify : [Select Id, Contact__c from Notify__c where Contact__c IN : contactIdsToBeNotified]) {
			if(notify.Contact__c != null)
				existingIds.add(notify.Contact__c);
		}
		
		//remove existing contacts from the list of contacts to be notified
		contactIdsToBeNotified.removeAll(existingIds);
		
		//loop through the new list and create new notify records
		List<Notify__c> listNotifyContacts = new List<Notify__c>();
		
		//Loop through the set
		for(Id contactId : contactIdsToBeNotified) {
			listNotifyContacts.add(New Notify__c(Contact__c = contactId));
		}
		
		//Check for the record size
		if(listNotifyContacts.size() > 0) 
			insert listNotifyContacts;
	}*/
	
	
	//method for the post processing of the records
	global void finish(Database.BatchableContext BC){
		
	}
}