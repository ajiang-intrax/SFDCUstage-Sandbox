@isTest(seeAllData=false)
private class Test_Batch_IGI_CheckIn_Assessment {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        RecordType IGIApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 20), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        
        
         Contact c = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert c;
        
         List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
         Applicant_Info__c appInfo = new Applicant_Info__c();
      	if(profiles.size() > 0)
      	{
        	User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            insert user;
            appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Internship', createdBy__c = user.id, RecordTypeId = IGIApplRecordType.ID
                                                                  );
      	}
      	else
      	{
      		appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Internship', RecordTypeId = IGIApplRecordType.ID
                                                                  );
      	}
      	
        if (appInfo != NULL)
        	insert appInfo;
        
        
        
        Batch_IGI_CheckIn_Assessment batch = new Batch_IGI_CheckIn_Assessment();
        Database.executeBatch(batch);
        
        test.stopTest();
    }
    
    static testMethod void myUnitTest_checkInExists() {
    	test.startTest();
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        RecordType IGIApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 20), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        
        
         Contact c = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert c;
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        Applicant_Info__c appInfo = new Applicant_Info__c();
      	if(profiles.size() > 0)
      	{
        	User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            insert user;
            appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Internship', createdBy__c = user.id, RecordTypeId = IGIApplRecordType.ID
                                                                  );
      	}
      	else
      	{
      		appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Internship', RecordTypeId = IGIApplRecordType.ID
                                                                  );
      	}
         if (appInfo != NULL)
        	insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Name = 'CheckIn Test', RecordTypeId = Constants.ASS_IGI_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        
        
        Batch_IGI_CheckIn_Assessment batch = new Batch_IGI_CheckIn_Assessment();
        Database.executeBatch(batch);

        test.stopTest();
    }
    
   
}