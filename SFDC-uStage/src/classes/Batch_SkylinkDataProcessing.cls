global class Batch_SkylinkDataProcessing implements Database.Batchable<sObject>, DataBase.AllowsCallouts 
{
	global Database.queryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator([SELECT Id, Name FROM Engagement__c LIMIT 1]);
	}
	global void execute (Database.BatchableContext BC, list<Engagement__c> EnggList)
	{
		SkylinkXMLParsing sky = new SkylinkXMLParsing();
		sky.fetchXMLData();
	}
	global void finish(Database.BatchableContext BC)
	{
    }
}