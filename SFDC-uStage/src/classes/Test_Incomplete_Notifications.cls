@isTest(SeeAllData=true)
public class Test_Incomplete_Notifications 
{
	Incomplete_Notifications InNotify = new Incomplete_Notifications();
	list<Notification__c> lNot = InNotify.getNDetails();
}