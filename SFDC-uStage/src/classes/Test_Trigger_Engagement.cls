@isTest
private class Test_Trigger_Engagement {

    static testMethod void myUnitTest() {


	 RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
                        
                        
          Account account = new Account(
                FirstName = 'Test', LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'AuPairCare', status__c = 'Contracted',
                OwnerId = UserInfo.getUserId()
                );
      
        insert account;       
        
           Account accountUpdate = new Account(
                FirstName = 'Testupdate', LastName = 'Triggerupdate', PersonEmail = 'update@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'AuPairCare', status__c = 'Contracted',
                OwnerId = UserInfo.getUserId()
                );
      
        insert accountUpdate;                
                        
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2015-2016', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
	    insert engagement;   
        
        engagement.Account_Id__c=  accountUpdate.Id;
        
        update   engagement;
      

    }
}