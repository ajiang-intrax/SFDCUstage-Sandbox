@isTest(seeAllData=true)
private class Test_ShareHCPortalUsers{

    static testMethod void myUnitTest() {
          Test.startTest();
    
    
            List<Profile> HCprofiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
            List<Account> HCAccList =  [Select Intrax_Id__c from Account  limit 1];
            List<Contact > ContactList =  [Select Id from Contact limit 1];
            List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
       
       
            Account participantInfo = new Account(FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
            type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',OwnerId = UserInfo.getUserId());
        
            insert participantInfo;
        
            Contact co = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: participantInfo.Id];
           
       
       
            Account hostCompany1 = new Account(Name = 'Host1 - Company',type='Host Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany1;
            Contact c1 = new Contact(FirstName = 'Test', LastName='Test', accountId=hostCompany1.Id , ManualHCPortalUserShareExists__c=false);
            insert c1;
            system.debug('***c1****'+c1);
            Contact c2 = [select ID, Name FROm Contact WHERE ID =: c1.id];
            system.debug('***c2.Name****'+c2.Name);
            c1.LastName='Test';
            update c1;
            
            User PartnerUser1 = new User(Alias = 'alias', Email = 'testUser0002@test.com', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = HCprofiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = co.Id, Intrax_Id__c =HCAccList[0].Intrax_Id__c, Type__c='Host Company', IsActive=true,EmailEncodingKey = 'UTF-8', 
                                    Username = 'test123@test.com');
                                    
           system.debug('***PartnerUser1****'+PartnerUser1);                      
            
            insert PartnerUser1;  
     
           
     
     
     
        
     ShareHCPortalUsers ng = new ShareHCPortalUsers();
  
      Database.executeBatch(ng);
       
      
        ShareHCPortalUsers ng1 = new ShareHCPortalUsers();
        ShareHCPortalUsers.FirstRun =true;
  
      Database.executeBatch(ng1);
       Test.stopTest();
    }
    
}