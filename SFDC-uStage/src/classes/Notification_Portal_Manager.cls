public without sharing class Notification_Portal_Manager {
	
	public list<Notification__c> notifications {get;set;}
	public list<Notification__c> AYRecNotifications {get;set;}
	
	public Notification_Portal_Manager(){
		
		User activeUser =[SELECT Id FROM User WHERE Id =: userInfo.getUserId()];
		notifications = new list<Notification__c>();
		
		notifications = [SELECT Id, Status__c, Type__c, Intrax_Program__c,Action_URL__c, Subject__c, ownerId, Body__c, Is_Parent__c, Engagement__c
							FROM Notification__c  WHERE OwnerId =: activeUser.Id
							AND Is_Parent__c =: false
							AND (Status__c = 'Not Started' OR Status__c = 'Incomplete' OR Type__c ='Visa Support Letter' OR (Status__c = 'In Progress'  and Type__c ='Orientation' ) ) and Type__c !='Recommended Students' ORDER BY CreatedDate DESC];
	  
	  AYRecNotifications = [SELECT Id, Status__c, Type__c, Intrax_Program__c,Action_URL__c, Subject__c, ownerId, Body__c, Is_Parent__c, Engagement__c
							FROM Notification__c  WHERE OwnerId =: activeUser.Id
							AND Is_Parent__c =: false
							AND (Status__c = 'Not Started' OR Status__c = 'Incomplete') and Type__c ='Recommended Students'];
										//WHERE (Id ='a1gc0000000Gh2d' OR Id='a1gc0000000Gh2i')];
	}
	
	

}