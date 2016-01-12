@isTest(seeAllData=true)
public class Test_Batch_SkylinkDataProcessing 
{
	static testMethod void myUnitTest() 
	{
		test.startTest();
        
        Account myAccount = new Account(Name='Test',Casper_ID__c ='1211692');
         insert myAccount;
        
         Engagement__c myEngagement= new Engagement__c(Name='TestEngagement',Account_Id__c=myAccount.Id, Status__c ='Program Ready', Engagement_Country__c = 'United States',Intrax_Program__c = 'AuPairCare');
         insert myEngagement;
        
        Batch_SkylinkDataProcessing batch = new Batch_SkylinkDataProcessing();
        Database.executeBatch(batch);
       
        test.stopTest(); 
	}
}