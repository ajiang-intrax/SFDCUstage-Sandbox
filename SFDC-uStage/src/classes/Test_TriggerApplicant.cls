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
@isTest(seeAllData = true)
public with sharing class Test_TriggerApplicant {
/*
    Purpose         :   Test class for Trigger_Applcant.
                
    Created Date    :   01/14/2013
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void testAutoPdfUpload() {
        
        
            //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account.Id);
        insert contact2;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            Account portalAccount2 = new Account(Name = 'TestName2', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount2;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            portalAccount2 = [Select Id, Intrax_Id__c from Account where Id =: portalAccount2.Id];
            
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount.Intrax_Id__c, type__c = 'Partner');
            
            insert user;
            
            User user2 = new User(Alias = 'alias2', Email = 'testUser2@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact2.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount2.Intrax_Id__c, type__c = 'Partner');
            
            insert user2;
            
            Lead lead; 
        
            lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                         postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                         Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                         email='dlampson@intraxinc.com',Rating='Hot');
                                         
            insert lead;  
            
            //Run in user context
            
            //Eng Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
                        
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013-2014', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            //Create Test Data
            Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test12', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                    Country__c = 'United States', Home_Phone__c = '12345', Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,ETR_Received_Date__c=null,
                                    Intrax_Program_Options__c = 'Practical Training', Intrax_Program_Category__c='Business', //Account__c = account.Id,
                                    RecordTypeId=Constants.WT_PT_Record_Type_Id, Lead__c = lead.Id, Application_Level__c = 'Basic', Application_Stage__c= 'Working', Type__c='Participant',
                                    Intrax_Program__c='Work Travel', createdBy__c = user.Id,Engagement_End__c = System.today(),Program_Year__c ='2013-2014');
            insert appInfo;
            
            lead.Field_Staff__c = appInfo.OwnerId;
            update lead;
            
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes');
            insert personInfo;
            
            //communication Obejcts
            Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
            insert comApp;
            
            //Intrax_Program_Upload__c
            Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_1', Document_service__c  = 'DS', Document_Type__c = 'Offer-Document');
            insert ipUpload;
            
            Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_2', Document_service__c  = 'DS', Document_Type__c = 'Passport');
            insert ipUpload2;                 
            
            Database.LeadConvert lc = new database.LeadConvert();           
            lc.setLeadId(lead.id);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];         
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);          
            System.assert(lcr.isSuccess());

            //Start test from
           
           // Trigger_Applicant.isApexNotTested=true;
           
           // AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'Teacher');
            //appInfo.Engagement__c = engagement.Id;
            
            
            Test.startTest();
            appInfo.Nemo_Id__c='109617';
            appInfo.ETR_Received_Date__c = System.Today(); 
            appInfo.Partner_Intrax_Id__c = portalAccount2.Intrax_Id__c;   
            appInfo.OwnerId = User2.Id;          
            appInfo.Intrax_Program_Options__c = 'Internship';     
             
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Working';                    
            
            update appInfo;
            
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Submitted'; 
            appInfo.Engagement__c = engagement.Id;
            update appInfo;
            Test.stopTest();
            
            appInfo.Application_Stage__c = 'Accepted'; 
            update appInfo; 
            //stop test here
            //Test.stopTest();
            }
        }
        
        
        static testMethod void testAutoPdfUpload2() {
        
        
            //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account.Id);
        insert contact2;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            Account portalAccount2 = new Account(Name = 'TestName2', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount2;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            portalAccount2 = [Select Id, Intrax_Id__c from Account where Id =: portalAccount2.Id];
            
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount.Intrax_Id__c, type__c = 'Partner');
            
            insert user;
            
            User user2 = new User(Alias = 'alias2', Email = 'testUser2@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact2.Id,
                                    Username = Math.random() + '@test.com',  Intrax_Id__c = portalAccount2.Intrax_Id__c, type__c = 'Partner');
            
            insert user2;
            
            Lead lead; 
        
            lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                         postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                         Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                         email='dlampson@intraxinc.com',Rating='Hot');
                                         
            //insert lead;  
            
            //Run in user context
            //Opportunity
            Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'Internship');
            insert opportunity;
            
            //Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
            
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            //Create Test Data
            Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                    Country__c = 'United States', Home_Phone__c = '12345', Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,ETR_Received_Date__c=null,
                                    Intrax_Program_Options__c = 'Practical Training; Internship Group; Internship - J1; WEST', Intrax_Program_Category__c='Business', Account__c = account.Id,
                                    RecordTypeId=Constants.ICD_Intern_PT_Record_Type_Id, Application_Level__c = 'Basic', Application_Stage__c= 'Working', Type__c='Participant',
                                    Intrax_Program__c='Internship', createdBy__c = user.Id);
            insert appInfo;
            
            //lead.Field_Staff__c = appInfo.OwnerId;
            //update lead;
            
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes');
            insert personInfo;
            
            //communication Obejcts
            Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
            insert comApp;
            
            //Intrax_Program_Upload__c
            Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_3', Document_service__c  = 'DS', Document_Type__c = 'Offer-Document');
            insert ipUpload;
            
            Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_4', Document_service__c  = 'DS', Document_Type__c = 'Passport');
            insert ipUpload2;            
            /*           
            Database.LeadConvert lc = new database.LeadConvert();           
            lc.setLeadId(lead.id);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];         
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);          
            System.assert(lcr.isSuccess());
            */
            //Start test from
           
           // Trigger_Applicant.isApexNotTested=true;
           
            AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'School');
            
            AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'Teacher');
            
            Opportunity childOpp = AppTriggerHelper.CreateAppOpp(appInfo,opportunity.id,'USD','Test');
            id appoppid = childOpp.Id;
            appInfo.Nemo_Id__c='109617';
            appInfo.ETR_Received_Date__c = System.Today(); 
            appInfo.Partner_Intrax_Id__c = portalAccount2.Intrax_Id__c;   
            appInfo.OwnerId = User2.Id;          
            appInfo.Intrax_Program_Options__c = 'Internship';     
             
            appInfo.Intrax_Program_Category__c = 'Public Administration & Law';     
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Working'; 
            
            update appInfo;             
            
            Test.startTest();
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Submitted'; 
            appInfo.Engagement__c = engagement.Id;
            update appInfo;
            Test.stopTest();           
            
            //stop test here
            //Test.stopTest();
            }
        }
    
        static testMethod void testAutoPdfUpload2_1() {
        
        
            //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account.Id);
        insert contact2;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            list<Account> listAcc = new list<Account>();
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            listAcc.add(portalAccount);
            
            Account portalAccount2 = new Account(Name = 'TestName2', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            listAcc.add(portalAccount2);
            
            insert listAcc;
            
            //Fetch intract Id for this account id
            //portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            //portalAccount2 = [Select Id, Intrax_Id__c from Account where Id =: portalAccount2.Id];
            
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount.Intrax_Id__c, type__c = 'Partner');
            
            insert user;
            
            User user2 = new User(Alias = 'alias2', Email = 'testUser2@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact2.Id,
                                    Username = Math.random() + '@test.com',  Intrax_Id__c = portalAccount2.Intrax_Id__c, type__c = 'Partner');
            
            insert user2;
            
            Lead lead; 
        
            lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                         postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                         Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                         email='dlampson@intraxinc.com',Rating='Hot');
                                         
            //insert lead;  
            
            //Run in user context
            //Opportunity
            Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'Internship');
            insert opportunity;
            
            //Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
            
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            //Create Test Data
            Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                    Country__c = 'United States', Home_Phone__c = '12345', Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,ETR_Received_Date__c=null,
                                    Intrax_Program_Options__c = 'Practical Training; Internship Group; Internship - J1; WEST', Intrax_Program_Category__c='Business', Account__c = account.Id,
                                    RecordTypeId=Constants.ICD_Intern_PT_Record_Type_Id, Application_Level__c = 'Basic', Application_Stage__c= 'Working', Type__c='Participant',
                                    Intrax_Program__c='Internship', createdBy__c = user.Id);
            insert appInfo;
            
            //lead.Field_Staff__c = appInfo.OwnerId;
            //update lead;
            
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes');
            insert personInfo;
            
            //communication Obejcts
            Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
            insert comApp;
            
            //Intrax_Program_Upload__c
            Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_5', Document_service__c  = 'DS', Document_Type__c = 'Offer-Document');
            insert ipUpload;
            
            Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_6', Document_service__c  = 'DS', Document_Type__c = 'Passport');
            insert ipUpload2;            
            /*           
            Database.LeadConvert lc = new database.LeadConvert();           
            lc.setLeadId(lead.id);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];         
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);          
            System.assert(lcr.isSuccess());
            */
            //Start test from
           
           // Trigger_Applicant.isApexNotTested=true;
           
           // AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'Teacher');
            
            
            
            Test.startTest();
            appInfo.Nemo_Id__c='109617';
            appInfo.ETR_Received_Date__c = System.Today(); 
            appInfo.Partner_Intrax_Id__c = portalAccount2.Intrax_Id__c;   
            appInfo.OwnerId = User2.Id;          
            appInfo.Intrax_Program_Options__c = 'Internship';     
             
            appInfo.Intrax_Program_Category__c = 'Social Development';     
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Working'; 
            
            update appInfo;             
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Submitted'; 
            appInfo.Engagement__c = engagement.Id;
            update appInfo;
            
            //appInfo.Application_Stage__c = 'Accepted'; 
            //update appInfo;
            
            Test.stopTest();
            
            
            
            //stop test here
            //Test.stopTest();
            }
        }
    
        static testMethod void testAutoPdfUpload2_2() {
        
        
            //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account.Id);
        insert contact2;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
        	list<Account> listAcc = new list<Account>();
        	
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            listAcc.add(portalAccount);
            
            Account portalAccount2 = new Account(Name = 'TestName2', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            listAcc.add(portalAccount2);
            
            insert listAcc;
            
            //Fetch intract Id for this account id
            //portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            //portalAccount2 = [Select Id, Intrax_Id__c from Account where Id =: portalAccount2.Id];
            
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount.Intrax_Id__c, type__c = 'Partner');
            
            insert user;
            
            User user2 = new User(Alias = 'alias2', Email = 'testUser2@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact2.Id,
                                    Username = Math.random() + '@test.com',  Intrax_Id__c = portalAccount2.Intrax_Id__c, type__c = 'Partner');
            
            insert user2;
            
            Lead lead; 
        
            lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                         postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                         Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                         email='dlampson@intraxinc.com',Rating='Hot');
                                         
            //insert lead;  
            
            //Run in user context
            //Opportunity
            Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'Internship');
            insert opportunity;
            
            //Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
            
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            //Create Test Data
            Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                    Country__c = 'United States', Home_Phone__c = '12345', Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,ETR_Received_Date__c=null,
                                    Intrax_Program_Options__c = 'Practical Training; Internship Group; Internship - J1; WEST', Intrax_Program_Category__c='Business', Account__c = account.Id,
                                    RecordTypeId=Constants.ICD_Intern_PT_Record_Type_Id, Application_Level__c = 'Basic', Application_Stage__c= 'Working', Type__c='Participant',
                                    Intrax_Program__c='Internship', createdBy__c = user.Id);
            insert appInfo;
            
            //lead.Field_Staff__c = appInfo.OwnerId;
            //update lead;
            
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes');
            insert personInfo;
            
            //communication Obejcts
            Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
            insert comApp;
            
            //Intrax_Program_Upload__c
            Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_7', Document_service__c  = 'DS', Document_Type__c = 'Offer-Document');
            insert ipUpload;
            
            Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_8', Document_service__c  = 'DS', Document_Type__c = 'Passport');
            insert ipUpload2;            
            /*           
            Database.LeadConvert lc = new database.LeadConvert();           
            lc.setLeadId(lead.id);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];         
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);          
            System.assert(lcr.isSuccess());
            */
            //Start test from
           
           // Trigger_Applicant.isApexNotTested=true;
           
           // AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'Teacher');
            
                       
            
            Test.startTest();
            
            appInfo.Nemo_Id__c='109617';
            appInfo.ETR_Received_Date__c = System.Today(); 
            appInfo.Partner_Intrax_Id__c = portalAccount2.Intrax_Id__c;   
            appInfo.OwnerId = User2.Id;          
            appInfo.Intrax_Program_Options__c = 'Internship';     
             
            appInfo.Intrax_Program_Category__c = 'Hospitality & Tourism';     
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Working'; 
            
            update appInfo;  
            
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Submitted'; 
            appInfo.Engagement__c = engagement.Id;
            update appInfo;
            
            //appInfo.Application_Stage__c = 'Accepted'; 
            //update appInfo;
            
            Test.stopTest();
            
            
            
            //stop test here
            //Test.stopTest();
            }
        }
    
        static testMethod void testAutoPdfUpload3() {
        
        
            //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account.Id);
        insert contact2;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            Account portalAccount2 = new Account(Name = 'TestName2', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount2;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            portalAccount2 = [Select Id, Intrax_Id__c from Account where Id =: portalAccount2.Id];
            
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount.Intrax_Id__c, type__c = 'Partner');
            
            insert user;
            
            User user2 = new User(Alias = 'alias2', Email = 'testUser2@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact2.Id,
                                    Username = Math.random() + '@test.com',  Intrax_Id__c = portalAccount2.Intrax_Id__c, type__c = 'Partner');
            
            insert user2;
            
            Lead lead; 
        
            lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                         postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                         Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                         email='dlampson@intraxinc.com',Rating='Hot');
                                         
            insert lead;  
            
            //Run in user context
            //Opportunity 
            Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Host Family', Intrax_Programs__c = 'Ayusa');
            insert opportunity;
            
            //Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
            
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Host Family', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            //Create Test Data
            Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                    Country__c = 'United States', Home_Phone__c = '12345', Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,ETR_Received_Date__c=null,
                                    Intrax_Program_Options__c = 'Ayusa High School; Practical Training; Internship Group; Internship - J1; WEST', Intrax_Program_Category__c='Business',// Account__c = account.Id,
                                    RecordTypeId=Constants.AyusaHF_Record_Type_Id, Application_Level__c = 'Basic', Application_Stage__c= 'Working', Type__c='Host Family',
                                    Intrax_Program__c='Ayusa', createdBy__c = user.Id,Program_Year__c = '2014-2015', Engagement_Start__c = System.today());
            insert appInfo;
            
            lead.Field_Staff__c = appInfo.OwnerId;
            update lead;
            
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes', Role__c = 'Reference');
            insert personInfo;
            
            //communication Obejcts
            Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
            insert comApp;
            
            //Intrax_Program_Upload__c
            Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_9', Document_service__c  = 'DS', Document_Type__c = 'Offer-Document');
            insert ipUpload;
            
            Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_10', Document_service__c  = 'DS', Document_Type__c = 'Passport');
            insert ipUpload2;
                      
            Database.LeadConvert lc = new database.LeadConvert();           
            lc.setLeadId(lead.id);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];         
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);          
            System.assert(lcr.isSuccess());
            
            //Start test from
           
           // Trigger_Applicant.isApexNotTested=true;
           
           // AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'Teacher');
            //appInfo.Engagement__c = engagement.Id;
            appInfo.Nemo_Id__c='109617';
            appInfo.ETR_Received_Date__c = System.Today(); 
            appInfo.Partner_Intrax_Id__c = portalAccount2.Intrax_Id__c;   
            appInfo.OwnerId = User2.Id;          
            appInfo.Intrax_Program_Options__c = 'Internship';     
             
            appInfo.Intrax_Program_Category__c = 'Finance';     
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Working'; 
            //insert data in bulk
            update appInfo;
                                    
            appInfo.Application_Stage__c = 'Submitted'; 
            update appInfo;
            
            appInfo.Application_Stage__c = 'Accepted'; 
            update appInfo;
            
            //stop test here
            //Test.stopTest();
            }
        }
        
        
        static testMethod void TestApplication1() {
        
        
            //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account.Id);
        insert contact2;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            Account portalAccount2 = new Account(Name = 'TestName2', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount2;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            portalAccount2 = [Select Id, Intrax_Id__c from Account where Id =: portalAccount2.Id];
            
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount.Intrax_Id__c, type__c = 'Partner');
            
            insert user;
            
            User user2 = new User(Alias = 'alias2', Email = 'testUser2@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact2.Id,
                                    Username = Math.random() + '@test.com',  Intrax_Id__c = portalAccount2.Intrax_Id__c, type__c = 'Partner');
            
            insert user2;
            
            Lead lead; 
        
            lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                         postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                         Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                         email='dlampson@intraxinc.com',Rating='Hot');
                                         
            //insert lead;  
            
            //Run in user context
            //Opportunity
            Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'Internship');
            insert opportunity;
            
            //Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
            
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            //Create Test Data
            Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                    Country__c = 'United States', Home_Phone__c = '12345', Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,ETR_Received_Date__c=null,
                                    Intrax_Program_Category__c='Business', Account__c = account.Id,
                                    RecordTypeId=Constants.AuPairCarePT_Record_Type_Id, Application_Level__c = 'Basic', Application_Stage__c= 'Working', Type__c='Participant',
                                    Intrax_Program__c='AuPairCare', createdBy__c = user.Id, Application_Type__c = 'Original');
            insert appInfo;
            
            //lead.Field_Staff__c = appInfo.OwnerId;
            //update lead;
            
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes');
            insert personInfo;
            
            //communication Obejcts
            Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
            insert comApp;
            
            //Intrax_Program_Upload__c
            Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_7', Document_service__c  = 'DS', Document_Type__c = 'Offer-Document');
            insert ipUpload;
            
            Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_8', Document_service__c  = 'DS', Document_Type__c = 'Passport');
            insert ipUpload2;            
            /*           
            Database.LeadConvert lc = new database.LeadConvert();           
            lc.setLeadId(lead.id);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];         
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);          
            System.assert(lcr.isSuccess());
            */
            //Start test from
           
           // Trigger_Applicant.isApexNotTested=true;
           
           // AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'Teacher');
            
            appInfo.Nemo_Id__c='109617';
            appInfo.ETR_Received_Date__c = System.Today(); 
            appInfo.Partner_Intrax_Id__c = portalAccount2.Intrax_Id__c;   
            appInfo.OwnerId = User2.Id;          
            appInfo.Intrax_Program_Options__c = 'Internship';     
             
            appInfo.Intrax_Program_Category__c = 'Hospitality & Tourism';     
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Working'; 
            
            update appInfo;             
            
            //Test.startTest();
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Submitted'; 
            //appInfo.Engagement__c = engagement.Id;
            update appInfo;
            //Test.stopTest();
            
            Test.startTest();
            appInfo.Application_Stage__c = 'Accepted'; 
            update appInfo;
            
           
            
            Test.stopTest();
            //stop test here
            //Test.stopTest();
            }
        }
        
        static testMethod void TestApplication2() {
        
        
            //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account.Id);
        insert contact2;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            Account portalAccount2 = new Account(Name = 'TestName2', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount2;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            portalAccount2 = [Select Id, Intrax_Id__c from Account where Id =: portalAccount2.Id];
            
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Intrax_Id__c = portalAccount.Intrax_Id__c, type__c = 'Partner');
            
            insert user;
            
            User user2 = new User(Alias = 'alias2', Email = 'testUser2@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact2.Id,
                                    Username = Math.random() + '@test.com',  Intrax_Id__c = portalAccount2.Intrax_Id__c, type__c = 'Partner');
            
            insert user2;
            
            Lead lead; 
        
            lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                         postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                         Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                         email='dlampson@intraxinc.com',Rating='Hot');
                                         
            //insert lead;  
            
            //Run in user context
            //Opportunity
            Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'Internship');
            insert opportunity;
            
            //Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
            
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            //Create Test Data
            Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                    Country__c = 'United States', Home_Phone__c = '12345', Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,ETR_Received_Date__c=null,
                                    Intrax_Program_Category__c='Business', Account__c = account.Id,
                                    RecordTypeId=Constants.AuPairCareHF_Record_Type_Id, Application_Level__c = 'Basic', Application_Stage__c= 'Working', Type__c='Host Family',
                                    Intrax_Program__c='AuPairCare', createdBy__c = user.Id, Application_Type__c = 'Original');
            insert appInfo;
            
            //lead.Field_Staff__c = appInfo.OwnerId;
            //update lead;
            
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes');
            insert personInfo;
            
            //communication Obejcts
            Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
            insert comApp;
            
            //Intrax_Program_Upload__c
            Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_7', Document_service__c  = 'DS', Document_Type__c = 'Offer-Document');
            insert ipUpload;
            
            Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test_8', Document_service__c  = 'DS', Document_Type__c = 'Passport');
            insert ipUpload2;            
            /*           
            Database.LeadConvert lc = new database.LeadConvert();           
            lc.setLeadId(lead.id);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];         
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);          
            System.assert(lcr.isSuccess());
            */
            //Start test from
           
           // Trigger_Applicant.isApexNotTested=true;
           
           // AppTriggerHelper.AutoPdfUpload(appInfo.Id,appInfo.Name,'Teacher');
            
            
           // Test.stopTest();
            Test.startTest();
            
            appInfo.Nemo_Id__c='109617';
            appInfo.ETR_Received_Date__c = System.Today(); 
            appInfo.Partner_Intrax_Id__c = portalAccount2.Intrax_Id__c;   
            appInfo.OwnerId = User2.Id;          
            appInfo.Intrax_Program_Options__c = 'Internship';     
             
            appInfo.Intrax_Program_Category__c = 'Hospitality & Tourism';     
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Working'; 
            
            update appInfo;             
            
           // Test.startTest();
            appInfo.Application_Level__c = 'Main';
            appInfo.Application_Stage__c = 'Submitted'; 
            //appInfo.Engagement__c = engagement.Id;
            update appInfo;
            
            appInfo.Application_Stage__c = 'Accepted'; 
            update appInfo;
            
            
            Test.stopTest();
            //stop test here
            //Test.stopTest();
            }
        }
        
    static testMethod void TestApplication3()
    {
        
        /*ResourcesController RC = new ResourcesController();
        RC.allWTDocuments();
        
        PageReference pc = RC.getDocumentUrl();*/
        
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
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Finding an Internship');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c = 'Finding an Internship');
            
            insert user1;
            
            system.debug('**User1***'+user1.id);
            system.debug('**User***'+user.id);
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won', Payment_Received__c = date.today());
        insert op1;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program_Options__c = 'Business Internship'
          );
          insert ca;
          
           RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='ICD Intern PT' Limit 1];
          
          Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = ca.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = p.Id,CreatedBy__c = user1.id,
                                                                  Country_of_Interest__c = 'United States', Opportunity_Name__c = op.Id, ownerId = user1.id
                                                                  );
          insert appInfo;
          
          ID PosID = AppTriggerHelper.CreateAppPos(appInfo);
          
          AppTriggerHelper.StageCloser(appInfo);
          
          appInfo.Application_Stage__c = 'Accepted';
          //update appInfo;
          
          
                    Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = ca.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Basic', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = p.Id,
                                                                  Country_of_Interest__c = 'United States', Opportunity_Name__c = op.Id, ownerId = user1.id
                                                                  );
          insert appInfo1;
          
                   
          
           appInfo1.Application_Level__c ='Main';
          update appInfo1;
          Test.startTest();
         appInfo1.Intrax_Program_Category__c='Business';
          appInfo1.Application_Stage__c = 'Submitted';
          update appInfo1;
          Test.stopTest();                         
          
    }
    
    
    static testMethod void TestApplication4()
    {
        
        /*ResourcesController RC = new ResourcesController();
        RC.allWTDocuments();
        
        PageReference pc = RC.getDocumentUrl();*/
        
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
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Finding an Internship');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c = 'Finding an Internship');
            
            insert user1;
            
            system.debug('**User1***'+user1.id);
            system.debug('**User***'+user.id);
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won', Payment_Received__c = date.today());
        insert op1;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program_Options__c = 'Business Internship'
          );
          insert ca;
          
           RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='ICD Intern PT' Limit 1];
          
          Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = ca.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = p.Id,CreatedBy__c = user1.id,
                                                                  Country_of_Interest__c = 'United States', Opportunity_Name__c = op.Id
                                                                  );
          insert appInfo;
          test.startTest();
          appInfo.Application_Stage__c = 'Accepted';
          appInfo.CreatedBy__c = user.id;
          update appInfo;
          
          test.stopTest();
          
    }
    static testMethod void TestApplication5()
    {
                 
        Account ac_pt = new Account(
          FirstName = 'Tests', LastName = 'hf', PersonEmail = 'testpt111@test.com',Gender__pc = 'Male',
          type = 'Host Family', Intrax_Programs__c = 'AuPairCare',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
           
       Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Tests hf'];
        
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      
      System.debug('********profiles->'+profiles);
            
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Finding an Internship');
            
            insert user;
                   
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting');
        insert op;
         Opportunity opchild = new Opportunity(
            Name = 'Test Opportunity1',ChildOppType__c='Application', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
             Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States',Parent_Opportunity__c= op.Id,
            closeDate = date.today(), StageName = 'Prospecting');
        insert opchild;
       
           RecordType AuPairCareHF = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='AuPairCare HF' Limit 1];
          
          Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = AuPairCareHF.Id, 
                                                                  Special_Diet_Indicated__c = 'No', 
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Basic', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES',CreatedBy__c = user.id,
                                                                  Country_of_Interest__c = 'United States',Intrax_Region__c = 'United States',Opportunity_Name__c = op.Id,Application_Stage__c = 'Working');
         
          test.startTest();                                                        
          
          insert appInfo;
          
         
          appInfo.Promo_Code_Indicated__c = 'YES';
          update appInfo;
          appInfo.CreatedBy__c = user.id;
          update appInfo;
          
          test.stopTest();
          
    }
    
    //JOSE B-03187 
    static testMethod void TestApplication6(){
                 
      try{
      Account ac_pt = new Account(FirstName = 'Tests', LastName = 'hf', PersonEmail = 'testpt111@test.com',Gender__pc = 'Male',
          						type = 'Host Family', Intrax_Programs__c = 'AuPairCare', OwnerId = UserInfo.getUserId());
      insert ac_pt;
           
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Tests hf'];
        
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      system.debug('********profiles->'+profiles);
            
      User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Finding an Internship');
            
       insert user;
                   
         Engagement__c engagement = new Engagement__c(  Name='Test Engagement', 
         											Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
													Type__c = 'Participant', Program_Duration__c ='1 - 4 weeks',
													Program_Year__c ='2013-2014', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
         
         insert engagement;
          
          RecordType AuPairCarePT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='AuPairCare PT' Limit 1];
          
          Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = AuPairCarePT.Id, 
                                                                  Special_Diet_Indicated__c = 'No', 
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Basic', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'AuPairCare', 
                                                                  Intrax_Program_Options__c = 'YES',CreatedBy__c = user.id,  Accepted_Date__c = System.today(), Engagement__c=engagement.id,
                                                                  Country_of_Interest__c = 'United States',Intrax_Region__c = 'United States',Application_Stage__c = 'Working');
         
         test.startTest();                                                        
         insert appInfo;
         appInfo.Application_Stage__c = 'Accepted';
         update appInfo;
         test.stopTest();
      }catch(Exception e){
      	system.debug('@@@@@Exception in TestApplication6:' + e);
      }
          
    }
    
    
}