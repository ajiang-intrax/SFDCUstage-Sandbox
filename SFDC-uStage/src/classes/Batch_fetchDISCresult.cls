global class Batch_fetchDISCresult implements Database.Batchable<sObject>, DataBase.AllowsCallouts 
{
	global Database.queryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator([SELECT Id, Name FROM DISC__c LIMIT 1]);
	}
	global void execute (Database.BatchableContext BC, list<DISC__c> DISCList)
	{
		DISCHandler DH = new DISCHandler();
		DH.batchfetchdata();
	}
	global void finish(Database.BatchableContext BC)
	{
    }
}