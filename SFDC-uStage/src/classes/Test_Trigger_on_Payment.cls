@isTest(seeAllData = true)
private class Test_Trigger_on_Payment {
  static testMethod void myUnitTest() 
         {
             Test.startTest();
           Account testAccnt = new Account (Name = 'test');
           insert testAccnt;
           
            Applicant_Info__c testApp = new Applicant_Info__c(Name = 'testerApp');
            insert testApp; 
          
           testAccnt = [Select Id, Name from Account where ID = :testAccnt.Id];
           Intacct__c testInt = new Intacct__c(Type__c = 'Create Sales Invoice',Account__c = testAccnt.Id);
           insert testInt;
           
           Payment__c pay = new Payment__c(Account_Name__c = testAccnt.Id, Card_Holder__c = testApp.Id);
           insert pay;
           Test.stopTest();
         }
}