@isTest(seeAllData=true)
private class Test_SkylinkXMLParsing{

    static testMethod void myUnitTest() {
	     Account myAccount = new Account(Name='Test',Casper_ID__c ='1211692');
         insert myAccount;
        
         Engagement__c myEngagement= new Engagement__c(Name='TestEngagement',Account_Id__c=myAccount.Id, Status__c ='Program Ready', Engagement_Country__c = 'United States',Intrax_Program__c = 'AuPairCare');
         insert myEngagement;
         
         SkylinkXMLParsing sky = new SkylinkXMLParsing();
		 sky.fetchXMLData();
     
    }
    
}