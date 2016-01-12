@isTest(seeAllData = true)
private class Test_extension_controller 
{
    /*static testMethod void myUnitTest() {
    //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Becoming an au pair';
        
         //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
            insert user;
            
          //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
            //System.runAs(sysAdmin) {
            System.runAs(user) {
                //AA Applicant Info APCPT
                Applicant_Info__c appInfoAPCPT = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',Allow_Intrax_To_Apply__c=True,
                                                                  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test',
                                                                  Home_Country__c = 'United States',
                                                                  Being_AuPair_Indicated__c ='Yes', 
                                                                  AP_Completion_Year_Indicated__c = 'No',
                                                                  Visa_Denied__c = 'Yes',
                                                                  Visa_Type__c = 'J-1', 
                                                                  US_Passport_Indicated__c = 'Yes',
                                                                  Childcare_Experience_Indicated__c ='No',
                                                                  Drivers_Licence_Indicated__c = 'No',
                                                                  Curfew_Indicated__c = 'No',RecordTypeId = rtAPCPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Language_3__c='English',Language_2__c='',Language_1__c='',
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
                                                                  Engagement_Start__c = System.today()-2, Accommodation_Preference__c = 'Homestay',Application_Level__c='Main',Intrax_Program__c='AuPairCare',Application_Type__c='Orignal',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfoAPCPT;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoAPCPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert personInfo;
                
                Experience__c experience = new Experience__c(Name='ExperienceName', Frequency__c = 'Daily', Applicant_Info__c=appInfoAPCPT.Id, IsExperienced__c = true, Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                insert experience;
                
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfoAPCPT.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',Functional_Areas__c = 'Accounting');
                insert posInfo;
                
                Audit_Info__c  auditinfo =new Audit_Info__c(Applicant_Info__c = appInfoAPCPT.Id, Name='Janet jackson');
                
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test',
                Document_service__c  = 'DS',Applicant_Info__c = appInfoAPCPT.Id,
                document_type__c = 'Introductory-Video', AWS_ET_Preset__c = 'Generic 720p', AWS_ET_Job_Status__c = 'Success');
                insert ipUpload;
                
                //Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Document_Guid__c = 'Test222', Document_service__c  = 'DS',Applicant_Info__c = appInfoAPCPT.Id,Document_Type__c='DS-7002-(Company-Signature)');
                //insert ipUpload2;
                
                list<Intrax_Program_Upload__c> DocListEducation= new list<Intrax_Program_Upload__c> ();
                DocListEducation.add(ipUpload);
                
                Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
                
                //Record Type
            RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
            
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                         Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', Partner_Id__c = portalAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                         Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
            insert engagement;
            
            appInfoAPCPT.Engagement__c = engagement.id;
            appInfoAPCPT.Opportunity_Name__c = opportunity.id;
            update appInfoAPCPT;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(appInfoAPCPT);
            extension_controller ex = new extension_controller(sc);
            ex.CloneAppApc();
                
            }
    }*/
    
    static testMethod void myUnitTest() 
    {
    //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
            
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
            
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
          
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
          
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Engagement_End__c = date.today().addMonths(3)+1, Program_Duration__c = 'Academic Year');
      insert myEngagement;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair'); 
                                    
        insert user;
            
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
            
        //Run in user context
        //System.runAs(sysAdmin) {
        System.runAs(sysAdmin) {        
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English');
                                            
                insert appInfoHF;
                
                Person_Info__c HFpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoHF.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert HFpersonInfo;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English');
              
                
               insert appInfoPT;
               
               appInfoPT.Opportunity_Name__c = opportunity.id;
               appInfoPT.Account__c = myAccountPT.id;
               update appInfoPT;
               
               Person_Info__c PTpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert PTpersonInfo;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
             Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
            
             insert match;
             
             Experience__c ExperienceTest = new Experience__c (Name = 'test',Experience_Type__c='Aupair',Frequency__c='Weekly',Applicant_Info__c = appInfoPT.Id);
            insert ExperienceTest;
        
            Experience_Detail__c experDetails = new Experience_Detail__c(Name='test', Experience_Name__c=ExperienceTest.id);
            insert experDetails;
        
            Essay__c Essaytest= new Essay__c (Name = 'test',Applicant_Info__c = appInfoPT.Id);
            insert Essaytest;
            
            DISC__c disctest= new DISC__c (AppID__c = appInfoPT.Id);
            insert disctest;
            
            Education__c edutest= new Education__c (Applicant_Info__c = appInfoPT.Id);
            insert edutest;
            
            Intrax_Program_Upload__c iputest= new Intrax_Program_Upload__c (Name = 'test',Applicant_Info__c = appInfoPT.Id);
            insert iputest;
            
             
             Test.startTest();
             ApexPages.StandardController sc = new ApexPages.StandardController(appInfoPT);
             extension_controller ex = new extension_controller(sc);
             ex.checkLogin();
             ex.CloneAppApc();
             Test.stopTest();
        }
    }
    /*
    static testMethod void myUnitTest1() 
    {
    //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
            
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
            
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
          
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
          
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year');
      insert myEngagement;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair'); 
                                    
        insert user;
            
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
                
                Opportunity hfopportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Host Family', Intrax_Programs__c = 'AuPairCare');
                insert hfopportunity;
            
        //Run in user context
        //System.runAs(sysAdmin) {
        System.runAs(sysAdmin) {        
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = hfopportunity.id);
                                            
                insert appInfoHF;
                
                Person_Info__c HFpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoHF.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert HFpersonInfo;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = opportunity.id);
              
                
               insert appInfoPT;
               
               
               Person_Info__c PTpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert PTpersonInfo;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,
                                               // Participant_Id__c = ac_pt1.Id, Participant_Opportunity_Id__c = op.Id,
                                               Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
            
             insert match;
              Test.startTest();
              ApexPages.currentPage().getParameters().put('AppType', 'Extension');
              
             ApexPages.StandardController sc = new ApexPages.StandardController(appInfoHF);
             extension_controller ex = new extension_controller(sc);
             ex.CloneAppApc();
              Test.stopTest();
        }
    }
    */
    
    static testMethod void myUnitTest2() 
    {
    //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
            
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
            
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
          
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
          
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year');
      insert myEngagement;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair'); 
                                    
        insert user;
            
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
                
                Opportunity hfopportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Host Family', Intrax_Programs__c = 'AuPairCare');
                insert hfopportunity;
            
        //Run in user context
        //System.runAs(sysAdmin) {
        System.runAs(sysAdmin) {        
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = hfopportunity.id);
                                            
                insert appInfoHF;
                
                Person_Info__c HFpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoHF.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert HFpersonInfo;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = opportunity.id);
              
                
               insert appInfoPT;
               
               
               Person_Info__c PTpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert PTpersonInfo;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
             Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
            
             insert match;
              Test.startTest();
              ApexPages.currentPage().getParameters().put('AppType', 'Renewal');
              
             ApexPages.StandardController sc = new ApexPages.StandardController(appInfoHF);
             extension_controller ex = new extension_controller(sc);
             ex.CloneAppApc();
              Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest3() 
    {
    //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
            
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
            
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
          
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
          
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year');
      insert myEngagement;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair'); 
                                    
        insert user;
            
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
                
                Opportunity hfopportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Host Family', Intrax_Programs__c = 'AuPairCare');
                insert hfopportunity;
            
        //Run in user context
        //System.runAs(sysAdmin) {
        System.runAs(sysAdmin) {        
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = hfopportunity.id);
                                            
                insert appInfoHF;
                
                Person_Info__c HFpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoHF.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert HFpersonInfo;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = opportunity.id);
              
                
               insert appInfoPT;
               
               
               Person_Info__c PTpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert PTpersonInfo;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
             Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
            
             insert match;
              Test.startTest();
              //ApexPages.currentPage().getParameters().put('AppType', 'Renewal');
              
             ApexPages.StandardController sc = new ApexPages.StandardController(appInfoHF);
             extension_controller ex = new extension_controller(sc);
             ex.getcheckWorkingApps();
             ex.getnewAppId();
             ex.HFCancelProcess();
             extension_controller.updateExtensionAPAgreed(appInfoHF.id);
              Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest4() 
    {
    //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
            
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
            
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
          
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
          
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year');
      insert myEngagement;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair'); 
                                    
        insert user;
            
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
                
                Opportunity hfopportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Host Family', Intrax_Programs__c = 'AuPairCare');
                insert hfopportunity;
            
        //Run in user context
        //System.runAs(sysAdmin) {
        System.runAs(sysAdmin) {        
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = hfopportunity.id);
                                            
                insert appInfoHF;
                
                Person_Info__c HFpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoHF.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert HFpersonInfo;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = opportunity.id);
              
                
               insert appInfoPT;
               
               
               Person_Info__c PTpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert PTpersonInfo;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               //Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
             //Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
            
             //insert match;
              Test.startTest();
              //ApexPages.currentPage().getParameters().put('AppType', 'Renewal');
              
             ApexPages.StandardController sc = new ApexPages.StandardController(appInfoPT);
             extension_controller ex = new extension_controller(sc);
             ex.APCancelProcess();
              Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest5() 
    {
    //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
            
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
            
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
          
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
          
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year');
      insert myEngagement;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair'); 
                                    
        insert user;
            
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
                
                Opportunity hfopportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Host Family', Intrax_Programs__c = 'AuPairCare');
                insert hfopportunity;
            
        //Run in user context
        //System.runAs(sysAdmin) {
        System.runAs(sysAdmin) {        
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = hfopportunity.id);
                                            
                insert appInfoHF;
                
                Person_Info__c HFpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoHF.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert HFpersonInfo;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = opportunity.id);
              
                
               insert appInfoPT;
               
               
               Person_Info__c PTpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert PTpersonInfo;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
             Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
            
             insert match;
              Test.startTest();
              //ApexPages.currentPage().getParameters().put('AppType', 'Renewal');
              
             ApexPages.StandardController sc = new ApexPages.StandardController(appInfoPT);
             extension_controller ex = new extension_controller(sc);
             //ex.APExtensiontoRenew();
              Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest6() 
    {
    //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
            
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
            
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
          
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
          
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year');
      insert myEngagement;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair'); 
                                    
        insert user;
            
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Participant', Intrax_Programs__c = 'AuPairCare');
                insert opportunity;
                
                Opportunity hfopportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                        StageName = 'Prospecting', AccountId = account.Id, Program_Year__c = '2013',
                                                        Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',
                                                        Type='Host Family', Intrax_Programs__c = 'AuPairCare');
                insert hfopportunity;
            
        //Run in user context
        //System.runAs(sysAdmin) {
        System.runAs(sysAdmin) {        
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = hfopportunity.id);
                                            
                insert appInfoHF;
                
                Person_Info__c HFpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoHF.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert HFpersonInfo;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Working', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id, 
                                                                  Primary_Language__c = 'English', Opportunity_Name__c = opportunity.id);
              
                
               insert appInfoPT;
               
               
               Person_Info__c PTpersonInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17),
                                                    Citizenship__c ='United States',
                                                    Country_of_Residence__c = 'United States',
                                                    Nationality__c = 'American',
                                                    Marital_Status__c ='Married',
                                                    Secondary_School_Indicated__c ='No',
                                                    Offence_Indicated__c = 'Yes',
                                                    Overall_Health__c = 'Fair' ,
                                                    Contagious_Disease_Indicated__c = 'Yes',
                                                    Drug_Dependency_Indicated__c = 'Yes',
                                                    Pregnancy_Indicated__c = 'Yes',
                                                    Medication_Indicated__c ='Yes',
                                                    Hospitalization_Indicated__c ='Yes',
                                                    Physical_Disabilities_Indicated__c = 'Yes',
                                                    Psychiatric_Treatment_Indicated__c ='Yes');
                insert PTpersonInfo;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
             Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
            
             insert match;
              Test.startTest();
              //ApexPages.currentPage().getParameters().put('AppType', 'Renewal');
              
             ApexPages.StandardController sc = new ApexPages.StandardController(appInfoHF);
             extension_controller ex = new extension_controller(sc);
             //ex.HFExtensiontoRenew();
              Test.stopTest();
        }
    }
}