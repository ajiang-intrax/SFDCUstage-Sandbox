@isTest(seeAllData=true)
private class Test_EngagementRankRedirectionController{

    static testMethod void myUnitTest() {
	     Account myAccount = new Account(Name='Test');
         insert myAccount;
        
         Engagement__c myEngagement= new Engagement__c(Name='TestEngagement',Account_Id__c=myAccount.Id, Status__c ='Not Placed', Engagement_Country__c = 'United States'
         ,Intrax_Program__c = 'Internship');
         insert myEngagement;
     ApexPages.StandardController sc = new ApexPages.StandardController(myEngagement);
     EngagementRankRedirectionController errc = new EngagementRankRedirectionController(sc);

     errc.redirect();
     
      Engagement__c myEngagement1= new Engagement__c(Name='TestEngagement',Account_Id__c=myAccount.Id, Status__c ='Not Placed', Engagement_Country__c = 'United States'
         ,Intrax_Program__c = 'Ayusa');
         insert myEngagement1;
     ApexPages.StandardController sc1 = new ApexPages.StandardController(myEngagement1);
     EngagementRankRedirectionController errc1 = new EngagementRankRedirectionController(sc1);

     errc1.redirect();
    }
    
}