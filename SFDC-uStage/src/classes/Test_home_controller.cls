@isTest(seeAllData = true)
private class Test_home_controller {

    static testMethod void myUnitTestHFApp() {
        
        PageReference p=Page.apc_hf_home; 
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
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
            
        //Run in user context
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
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=user.id, 
                                                                  Primary_Language__c = 'English');
              
                
               insert appInfoPT;
               
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoPT.Id,Document_Type__c='Participant-Photo', Account__c = appInfoPT.Account__c);
                insert ipUpload;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
               Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
              
               insert match;
               
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('id', appInfoHF.Id);
                
                //Calling Controller
                home_Controller controller = new home_Controller();
                
                //Accesing to variables and methods
                Applicant_Info__c app = controller.applicant;
                Applicant_Info__c appPT = new Applicant_Info__c();
                appPT = controller.applicantPT;
                String photo1 = controller.Pt_Photo;
                String photo2 = controller.Pt_Photo_acc;
                Boolean dis = controller.disControlLen;
                String userAgentCheck = controller.userAgentCheck;
                String UserInterests = controller.UserInterests;
                String userProfileName = controller.userProfileName;
                String buttonClass = controller.buttonClass;
                PageReference pc = controller.changeDisableLen();
                controller.checkUser();
                PageReference pr = controller.checkLogin();
                PageReference pf = controller.checkLogin();
                
                appInfoPT.CreatedBy__c = NULL;
                update appInfoPT;
                controller.applicantPT = NULL;
                appPT = controller.applicantPT;
                match.Status__c = 'Withdrawn';
                update match;
                controller.applicantPT = NULL;
                appPT = controller.applicantPT;
                
                
                //Stop Test Here
                Test.stopTest();
                
            }
    }
    
    static testMethod void myUnitTestPTApp() {
        
        PageReference p=Page.apc_hf_home; 
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
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
        
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', OwnerId=sysAdmin.Id);
        insert myEngagement;
            
        //Run in user context
        System.runAs(sysAdmin) {
                
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id,CreatedBy__c=user.id,   
                                                                  Primary_Language__c = 'English');
                                            
                insert appInfoHF;
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Position__c = myPosition.Id,
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id,
                                                                  Primary_Language__c = 'English');
              
                
               insert appInfoPT;
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
               Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
              
               insert match;
               
               Selection__c selection = new Selection__c(Name = 'test', Engagement__c = myEngagement.Id , Status__c='Active', OwnerId=sysAdmin.Id, Interview_End_Date__c = date.today().addMonths(3) );
               
               //insert selection;
               
               Selection__c selection2 = new Selection__c(Name = 'test', Engagement__c = myEngagement.Id , Status__c='Active', OwnerId=selection.OwnerId );
               
               //insert selection2;
               
               User_Profile__c usprof = new User_Profile__c(Name='test', User__c = sysAdmin.id );
               insert usprof;
               
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('conf', 'true');
                ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
                ApexPages.currentPage().getParameters().put('confExtend', 'true');
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/apc_ap_home');
                
                //Calling Controller
                home_Controller controller = new home_Controller();
                Applicant_Info__c appHF = new Applicant_Info__c();
                appHF = controller.applicantHF;
                PageReference pr = controller.confirmPtExtension();
                
                appInfoHF.CreatedBy__c = NULL;
                update appInfoHF;
                controller.applicantHF = NULL;
                appHF = controller.applicantHF;
                match.Status__c = 'Withdrawn';
                update match;
                controller.applicantHF = NULL;
                appHF = controller.applicantHF;
                
                //List<Intrax_Program_Upload__c> iputestList = controller.getHostFamilyProfilePhoto();
                Boolean booltest = controller.getcheckForOnProgramInterviewing();
                boolean booltest1 = controller.getfutureInterviewsExist();
                Applicant_Info__c applicantPTnoExt = controller.applicantPTnoExtend;
                Account acct = controller.partnerAcc;
                User_Profile__c upad = controller.userProfAD;
                User_Profile__c upad2 = controller.userProfRM;
                Person_Info__c PersonInfotest = controller.PersonInfo; 
                Date dTodayTest = controller.dToday;
                string urltest = controller.getReturnURL();
                String photo4 = controller.photoADUrl;
                
                
                //Stop Test Here
                Test.stopTest();
                
            }
    }
}