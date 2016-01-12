public class Incomplete_Notifications 
{
	public list<Notification__c> allNot {get; set;}
	public ID notID {get; set;}
	
	public list<Notification__c> getNDetails()
	{
		allNot = [SELECT ID, Name, type__c, Subject__c FROM Notification__c where Parent_Notification__c = :notID AND (Status__c = 'Not Started' OR Status__c = 'Incomplete')];
		return allNot;
	}
}