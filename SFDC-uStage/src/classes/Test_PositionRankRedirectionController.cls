@isTest(seeAllData=true)
private class Test_PositionRankRedirectionController{

    static testMethod void myUnitTest() {
	     Account myAccount = new Account(Name='Test');
         insert myAccount;
        
         Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccount.Id, Status__c ='Matching', Country__c = 'United States'
         ,Intrax_Program__c = 'Internship');
         insert myPosition;
     ApexPages.StandardController sc = new ApexPages.StandardController(myPosition);
     PositionRankRedirectionController prrc = new PositionRankRedirectionController(sc);

     prrc.redirect();
     
     Position__c myPosition1 = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccount.Id, Status__c ='Matching', Country__c = 'United States'
         ,Intrax_Program__c = 'Ayusa');
         insert myPosition1;
     ApexPages.StandardController sc1 = new ApexPages.StandardController(myPosition1);
     PositionRankRedirectionController prrc1 = new PositionRankRedirectionController(sc1);

     prrc1.redirect();
    }
    
}