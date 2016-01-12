/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=false)
private class Test_Batch_WT_Assessment_Generator {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
          Contact userContact = new Contact(LastName = 'LastName', AccountId = account.Id, email = 'test@test.com');
	      insert userContact;
        
         list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
         User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
          insert user;
            
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel', CreatedBy__c = user.id
                                                                  );
        insert appInfo;
        
        test.startTest();
        
        Batch_WT_CheckIn_Assessment batch = new Batch_WT_CheckIn_Assessment();
        Database.executeBatch(batch);
        
        list<Assessment__c> CheckIn_Assessment = [SELECT Id, Engagement__c FROM Assessment__c WHERE Engagement__c =: WTEngagement.Id];
        
        Assessment__c MC_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert MC_Assessment;
        
        Database.executeBatch(batch);
        
        test.stopTest();
    }
    /*
    static testMethod void myUnitTest_oldBatch() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel'
                                                                  );
        insert appInfo;
        
        test.startTest();
        
        Batch_WT_Assessment_Generator batch = new Batch_WT_Assessment_Generator();
        Database.executeBatch(batch);
        
        list<Assessment__c> CheckIn_Assessment = [SELECT Id, Engagement__c FROM Assessment__c WHERE Engagement__c =: WTEngagement.Id];
        
        Assessment__c MC_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert MC_Assessment;
        
        Database.executeBatch(batch);
        
        test.stopTest();
    }
    */
    static testMethod void myUnitTest_checkInExists() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        Contact userContact = new Contact(LastName = 'LastName', AccountId = account.Id, email = 'test@test.com');
	      insert userContact;
        
         list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
         User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
          insert user;
            
        
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel', createdBy__c = user.id
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Name = 'CheckIn Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        test.startTest();
        
        Batch_WT_CheckIn_Assessment batch = new Batch_WT_CheckIn_Assessment();
        Database.executeBatch(batch);

        test.stopTest();
    }
    
    /*
    static testMethod void myUnitTest_checkInExists_oldBatch() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel'
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Name = 'CheckIn Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        test.startTest();
        
        Batch_WT_Assessment_Generator batch = new Batch_WT_Assessment_Generator();
        Database.executeBatch(batch);

        test.stopTest();
    }
    */
    static testMethod void myUnitTest_checkInExists_Due() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        Contact userContact = new Contact(LastName = 'LastName', AccountId = account.Id, email = 'test@test.com');
	      insert userContact;
        
         list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
         User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
          insert user;
            
        
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel', CreatedBy__c = user.id
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Confirmed_Date__c = (date.today() - 31), Name = 'CheckIn Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        test.startTest();
        
        Batch_WT_CheckIn_Assessment batch = new Batch_WT_CheckIn_Assessment();
        Database.executeBatch(batch);

        test.stopTest();
    }
    /*
    static testMethod void myUnitTest_checkInExists_Due_oldBatch() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel'
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Confirmed_Date__c = (date.today() - 31), Name = 'CheckIn Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        test.startTest();
        
        Batch_WT_Assessment_Generator batch = new Batch_WT_Assessment_Generator();
        Database.executeBatch(batch);

        test.stopTest();
    }
    */
    static testMethod void myUnitTest_MCNotExists() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        Contact userContact = new Contact(LastName = 'LastName', AccountId = account.Id, email = 'test@test.com');
	      insert userContact;
        
         list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
         User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
          insert user;
            
        
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'On Program', Needs_Travel__c ='Yes');
        insert WTengagement;
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel', CreatedBy__c = user.id
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id, Confirmed_Date__c = date.today()-31);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        /*
        Assessment__c MC_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert MC_Assessment;
        
        Notification__c MC_Notif = new Notification__c(Type__c = 'Monthly Contact', Engagement__c = WTengagement.Id, Assessment__c = MC_Assessment.Id);
        insert MC_Notif;
        */
        test.startTest();
        
        Batch_WT_MC_Assessment batch = new Batch_WT_MC_Assessment();
        Database.executeBatch(batch);
        
        test.stopTest();
    }
    /*
    static testMethod void myUnitTest_MCNotExists_oldBatch() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'On Program', Needs_Travel__c ='Yes');
        insert WTengagement;
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel'
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id, Confirmed_Date__c = date.today()-31);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        Assessment__c MC_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert MC_Assessment;
        
        Notification__c MC_Notif = new Notification__c(Type__c = 'Monthly Contact', Engagement__c = WTengagement.Id, Assessment__c = MC_Assessment.Id);
        insert MC_Notif;
        
        test.startTest();
        
        Batch_WT_Assessment_Generator batch = new Batch_WT_Assessment_Generator();
        Database.executeBatch(batch);
        
        test.stopTest();
    }
    */
     static testMethod void myUnitTest_MCExists() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        Contact userContact = new Contact(LastName = 'LastName', AccountId = account.Id, email = 'test@test.com');
	      insert userContact;
        
         list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
         User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
          insert user;
            
        
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'On Program', Needs_Travel__c ='Yes');
        insert WTengagement;
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel', CreatedBy__c = user.id
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id, Confirmed_Date__c = date.today()-31);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        Assessment__c MC_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert MC_Assessment;
        
        Notification__c MC_Notif = new Notification__c(Type__c = 'Monthly Contact', Engagement__c = WTengagement.Id, Assessment__c = MC_Assessment.Id);
        insert MC_Notif;
        
        test.startTest();
        
        Batch_WT_MC_Assessment batch = new Batch_WT_MC_Assessment();
        Database.executeBatch(batch);
        
        test.stopTest();
    }
    /*
    static testMethod void myUnitTest_MCExists_oldbatch() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 20),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'On Program', Needs_Travel__c ='Yes');
        insert WTengagement;
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Work Travel'
                                                                  );
        insert appInfo;
        
        Assessment__c CheckIn_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Check_In, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id, Confirmed_Date__c = date.today()-31);
        insert CheckIn_Assessment;
        
        Notification__c CheckIn_Notif = new Notification__c(Type__c = 'Check-In Assessment', Engagement__c = WTengagement.Id, Assessment__c = CheckIn_Assessment.Id);
        insert CheckIn_Notif;
        
        Assessment__c MC_Assessment = new Assessment__c(Name = 'MC Test', RecordTypeId = Constants.ASS_WT_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert MC_Assessment;
        
        Notification__c MC_Notif = new Notification__c(Type__c = 'Monthly Contact', Engagement__c = WTengagement.Id, Assessment__c = MC_Assessment.Id);
        insert MC_Notif;
        
        test.startTest();
        
        Batch_WT_Assessment_Generator batch = new Batch_WT_Assessment_Generator();
        Database.executeBatch(batch);
        
        test.stopTest();
    }
 */   
}