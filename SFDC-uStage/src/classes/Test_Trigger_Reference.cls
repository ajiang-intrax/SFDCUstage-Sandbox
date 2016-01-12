@isTest (seeAllData = True)
private class Test_Trigger_Reference {
 static testMethod void myUnitTest() {
  test.starttest();
   
     Applicant_Info__c newApp = new Applicant_Info__c(Name='test',Height__c = '60', WEight__c = '30');
    
     insert newApp;
     RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
     
     //Account
     Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
     insert account;
   
     //Position
     Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id, Status__c ='Confirmed');
     insert position;
     
     ///Reference  
     reference__c newRef=new reference__c (Name='testref',Position__c=position.id,Applicant_Info__c=newApp.id,Status__c='Confirmed');
     insert newRef;
     delete newRef;
     
   test.stoptest();   

 }
}