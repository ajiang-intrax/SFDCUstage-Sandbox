@isTest
private class Test_Trigger_IPU {
 static testMethod void myUnitTest() {
     Applicant_Info__c newApp = new Applicant_Info__c(Name='test',Height__c = '60', WEight__c = '30');
     
     RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
     //Assert for Results
     System.assertEquals(true, hostCompanyRecordType != null);
    
     //Account
     Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
     insert account;
     Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id);
     insert position;
     
     Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c(Name='test',Applicant_Info__c=newApp.id, Position__c = position.Id, Document_GUID__c='xyz',
     Document_Name__c='test.jpg',Document_Service__c='IS',Document_Type__c='Bathroom', Review_Status__c = 'Accepted');
     insert newApp;
     insert loaddoc;
     //loaddoc.Description__c = 'Changed Description';
     //update loadDoc;
    // delete loadDoc;
 }
}