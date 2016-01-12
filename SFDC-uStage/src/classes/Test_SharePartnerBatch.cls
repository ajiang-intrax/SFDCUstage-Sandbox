@isTest(seeAllData=true)
private class Test_SharePartnerBatch{

    static testMethod void myUnitTest() {
          Test.startTest();
      
      
      
      
            List<Profile> HCprofiles = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
            List<Account> HCAccList =  [Select Intrax_Id__c from Account  limit 1];
            List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
       
       
            Account participantInfo = new Account(FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
            type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',OwnerId = UserInfo.getUserId());
        
            insert participantInfo;
        
            Contact co = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: participantInfo.Id];
           
        
            
            User PartnerUser1 = new User(Alias = 'alias', Email = 'testUser0002@test.com', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = HCprofiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = co.Id, Intrax_Id__c =HCAccList[0].Intrax_Id__c, Type__c='Partner', IsActive=true,EmailEncodingKey = 'UTF-8', 
                                    Username = 'test123@test.com');
                                    
           system.debug('***PartnerUser1****'+PartnerUser1);                      
            
            insert PartnerUser1;  
  
      
        
     SharePartnerBatch ng = new SharePartnerBatch();
  
      //Database.executeBatch(ng);
       
      
        //SharePartnerBatch ng1 = new SharePartnerBatch();
        //SharePartnerBatch.FirstRun =true;
  
      //Database.executeBatch(ng1);
       Test.stopTest();
    }
    
}