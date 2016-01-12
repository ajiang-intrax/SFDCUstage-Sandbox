public with sharing class FlowSAcountController {
  
  public sAccount__c saccountInfo{get; set;}
  
  public FlowSAcountController(ApexPages.StandardController controller){
    saccountInfo = (sAccount__c)controller.getRecord();
  }  
  
  public PageReference getFinishPage() {
    saccountInfo = 
       [Select a.Id , a.Account_Name__c From sAccount__c a where a.Id = :saccountInfo.Id];
    System.debug(saccountInfo);
    if (saccountInfo.Account_Name__c != null)
       return new PageReference('/'+saccountInfo.Account_Name__c);
    else
       return new PageReference('/'+saccountInfo.Id);
    }
    
    static testMethod void testIt(){
      test.startTest();
      sAccount__c a = new sAccount__c();
    a.Last_Name__c = 'test';
    a.Mailing_Street__c = 'test';
    a.Mailing_City__c = 'test';
    a.Mailing_State__c = 'CA';
    a.Mailing_Postal_Code__c = '12345';
    a.Mailing_Country__c = 'United States';
    a.Phone__c = '12345';
    a.Email__c = 'test@test.com';
    insert a;
    ApexPages.StandardController sc = new ApexPages.StandardController(a);
        PageReference flsync = Page.sObjectVerificationPage;
        FlowSAcountController fc = new FlowSAcountController(sc);
        Test.setCurrentPageReference(flsync);
        fc.getFinishPage();      
        test.stopTest();
    }
}