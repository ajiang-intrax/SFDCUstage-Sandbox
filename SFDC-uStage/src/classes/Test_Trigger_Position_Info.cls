@isTest
private class Test_Trigger_Position_Info 
{
	static testMethod void testPosTrigger()
	{
		Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
    
       
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      
      System.debug('********profiles->'+profiles);
        
     
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Position_Info__c ps = new Position_Info__c(Name = 'Test', Engagement__c = ca.id, Is_Primary_SOA__c = true, Supervisor_First_Name__c = 'Test', Supervisor_Last_Name__c ='Test',
          Intrax_Program__c = 'Work Travel', Company_Name__c = 'Test', Company_Street_1__c = '3700 Beacon Ave', Company_City__c = 'Fremont', Company_State__c = 'CA', 
          Company_Postal_Code__c = '94538', Status__c = 'In-Review');
          insert ps;
          ps.Status__c = 'Declined';
          update ps;
	}
}