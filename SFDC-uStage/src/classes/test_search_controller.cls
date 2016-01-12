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
private class test_search_controller {
    static testMethod void myUnitTest() {
        PageReference p=Page.apc_hf_au_pair_profile; 
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        RecordType rtHf = [select id,Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        
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
        System.runAs(user) {
            
             
        
        Account myAccountPT = new Account(LastName='Test',personEmail='a@a.com');
        insert myAccountPT;
            
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3', Account_Id__c = myAccountPT.Id);
        insert myEngagement;
        
            Account myAccountHF = new Account(LastName='Test', recordTypeId = rtHf.id, Type = 'Host Family', personEmail='a@a.com');
            insert myAccountHF;
                
            Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
            insert myPosition;
          
           list<Applicant_Info__c> ApplicantList = new  list<Applicant_Info__c>();
                
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Type__c = 'Original',Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id,
                                                                  CreatedBy__c=user.id,   
                                                                  Primary_Language__c = 'English');
                                            
                ApplicantList.add(appInfoHF);
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Type__c = 'Original', Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, 
                                                                  CreatedBy__c=user.id, 
                                                                  Primary_Language__c = 'English',Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3');
              
                
               ApplicantList.add(appInfoPT);
               
               insert ApplicantList;
        
                
               
               //Creating Match Record Status=Confirmed
               Match__c match = new Match__c(Name = 'TestMatch', Position_Name__c = myPosition.Id, Engagement__c = myEngagement.Id,/* Participant_Id__c = ac_pt1.Id,
               Participant_Opportunity_Id__c = op.Id,*/ Status__c = 'Confirmed', End_Date__c=date.today().addMonths(3));
              
               insert match;
               
               // Creating Education records
               list<Education__c> eduList = new  list<Education__c>();
               
               Education__c ed1 = new Education__c(Institution_Type__c = 'Secondary-School-Diploma', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
               Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoPT.Id, Engagement__c = myEngagement.Id);
               eduList.add(ed1);
                            
               Education__c ed2 = new Education__c(Institution_Type__c = 'University/College', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
               Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoPT.Id, Engagement__c = myEngagement.Id);
                eduList.add(ed2);
                
               Education__c ed3 = new Education__c(Institution_Type__c = 'Vocational Training', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
               Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoPT.Id , Engagement__c = myEngagement.Id);
               eduList.add(ed3);
               
               //insert eduList;
               
               //Creting Essays Records
               Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfoPT.Id, 
               Narrative__c = '900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
               //insert essay;
               
               //Creating Family And Reference records and primary
               list<Person_Info__c> personInfoList = new list<Person_Info__c>();
               
               Person_Info__c primary = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = 'primary', Gender__c = 'Male', Role__c = 'Participant',
                                                    Applicant_Info__c = appInfoPT.Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
               
               personInfoList.add(primary);
               
               Person_Info__c personParent = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Role__c = 'Parent',
                                                    Applicant_Info__c = appInfoPT.Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
               
                personInfoList.add(personParent);
                
                Person_Info__c personSibling = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Role__c = 'Sibling',
                                                    Applicant_Info__c = appInfoPT.Id, 
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                
                personInfoList.add(personSibling);
                
                Person_Info__c personReference = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Role__c = 'Reference',
                                                    Applicant_Info__c = appInfoPT.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                
                personInfoList.add(personReference);
                
                
                //insert personInfoList;
                
                /*Experience__c experience = new Experience__c(Name='ExperienceName', Children_Ages__c = '0-2', Experience_Type__c = 'Babysitting', Frequency__c = 'Daily', Engagement__c = myEngagement.Id, Applicant_Info__c=appInfoPT.Id, IsExperienced__c = true, Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                insert experience;
                
                Experience_Detail__c experienceDet = new Experience_Detail__c(Name='ExperienceDetName',   Experience_Name__c=experience.Id, Special_Needs_Indicated__c = 'Yes', Gender__c = 'Male', Date_of_Birth__c = date.today() - 100);
                insert experienceDet;
                
                Reference__c refer = new Reference__c(Name='Reference', Reference_Status__c = 'Active', Reference_Requested__c = true, Status__c ='Confirmed', Experience_Name__c = experience.id, Engagement__c = myEngagement.Id, Applicant_Info__c=appInfoPT.Id );
                
                               
                list<Intrax_Program_Upload__c> ipulist = new list<Intrax_Program_Upload__c>();
                Intrax_Program_Upload__c ipUpload01 = new Intrax_Program_Upload__c(Document_Guid__c = 'Test01',
                Applicant_Info__c = appInfoPT.Id,
                document_type__c = 'Doctor');
                ipulist.add(ipUpload01);
                
                Intrax_Program_Upload__c ipUpload02 = new Intrax_Program_Upload__c(Document_Guid__c = 'Test',
                Applicant_Info__c = appInfoPT.Id,
                document_type__c = 'Lifeguard');
                ipulist.add(ipUpload02);
                
                insert ipulist;
                
                DISC__c disctest= new DISC__c (AppID__c = appInfoPT.Id, Engagement__c = myEngagement.Id);
                insert disctest;
                
                Assessment__c ass = new Assessment__c(Name = 'CheckIn Test', Application__c = appInfoPT.Id ,RecordTypeId = Constants.ASS_APC_PT_PR_Interview, Status__c = 'Not Yet Started', Engagement__c = myEngagement.Id);
                insert ass;
                
                
                //----------------------------------------------------TEST----------------------------------------------------//
                   
            test.startTest();
            
            ApexPages.currentPage().getParameters().put('recordId', myEngagement.Id);
            ApexPages.CurrentPage().getParameters().put('Id', appInfoPT.Id);  
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(myEngagement);
            search_controller controller = new search_controller('Engagement__c');
            
            ApexPages.StandardSetController results =  controller.results;
            
            PageReference pr = controller.saveVisit();
        
            pr = controller.saveVisit();
            //pr = controller.saveVisit();
                
            controller.saveAsFavorite();
            controller.getFavoriteRecords();                    
            controller.removeAsFavorite();
            
            controller.saveAsDismissed();
            controller.getDismissedRecords();           
        
            controller.removeAsDismissed(); 
               
            
            controller.sortingSelected = 'Language_1__c';
            controller.LanguageSelected = new list<String>{'Spanish'};
            controller.nationalitySelected = new list<String>{'Spanish'};
            controller.swimmersSelected = 'Yes';
            controller.ageSelected = '18';
            controller.experienceselected = new list<String>{'0 - 1'};
            controller.experienceTypeSelected = new list<String>{'Camp'};
            controller.dietSelected = new list<String>{'Diabetic'};
            controller.genderSelected = 'Female';
            controller.ArrivalSelected = '01/01/2016';
            controller.currentLocationSelected = 'In-Country';
            controller.trainingSelected = 'Infant Specialized';
            controller.hobbiesSelected = new list<String>{'Soccer'};    
            
            controller.dismissedSelected = 'false';
            controller.FavoriteSelected = 'true';   
            
            controller.showOnlyFavorite();
            //controller.showOnlySuggested();
            
            //controller.f_field = 'Nationality__c';
            controller.applyFilter();
            controller.f_object = 'Engagement__c';
            controller.f_field = 'Gender__c';
            controller.f_label = 'Gender';
            //controller.applyFilter();
 
            controller.saveSearchName = 'Test';
            //controller.saveSearch();          

            controller.savedSearchSelected = 'Test';
            //controller.applySavedSearch();
                        
            test.stopTest();*/
        }
        
    }   
    
     static testMethod void myUnitTest2() {
        PageReference p=Page.apc_hf_au_pair_profile; 
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        RecordType rtHf = [select id,Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        
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
        System.runAs(user) {            
             
        
            Account myAccountPT = new Account(LastName='Test',personEmail='a@a.com');
            insert myAccountPT;
                
            Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3', Account_Id__c = myAccountPT.Id);
            insert myEngagement;
        
            Account myAccountHF = new Account(LastName='Test', recordTypeId = rtHf.id, Type = 'Host Family', personEmail='a@a.com');
            insert myAccountHF;
                
            Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
            insert myPosition;
          
           list<Applicant_Info__c> ApplicantList = new  list<Applicant_Info__c>();
                
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Type__c = 'Original',Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id,
                                                                  CreatedBy__c=user.id,   
                                                                  Primary_Language__c = 'English');
                                            
                ApplicantList.add(appInfoHF);
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Type__c = 'Original', Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, 
                                                                  CreatedBy__c=user.id, 
                                                                  Primary_Language__c = 'English',Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3');
              
                
               ApplicantList.add(appInfoPT);
               
               insert ApplicantList;
            
            test.startTest();
            
            ApexPages.currentPage().getParameters().put('recordId', myEngagement.Id);
            ApexPages.CurrentPage().getParameters().put('Id', appInfoPT.Id);  
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(myEngagement);
            /*search_controller controller = new search_controller('Engagement__c');
            
            //ApexPages.StandardSetController results =  controller.results;
            
            integer totalPages = controller.totalPages;
            
            
            controller.pageNumberSelected = '1';
            //controller.setpageNumber();
            
            controller.pageSize = 5;
            //controller.setPageSize();
            
            list<SelectOption> pageSizeOptions = controller.pageSizeOptions;
            list<SelectOption> pageNumbers = controller.pageNumbers;
            
            
            //list<Engagement__c> myEngagements = controller.getengList();
            
            controller.resetQuery();*/
  
  /*
            List<SearchWrapper> wrappers = controller.wrappers;         
            controller.buildWrapper();
            controller.removeElementFromWrapper();
            */
            //controller.clearAllFilters();
            /*controller.getIsMyFiltersEmpty();
            
            //controller.createSelectionRecord(myPosition.Id, myEngagement_1.Id);
            
            map<String, list<String>> highlights = controller.highlights;
            list<SelectOption> USArrivalDates = controller.USArrivalDates;
            list<SelectOption> hobbiesOptions = controller.hobbiesOptions;
            list<SelectOption> DietOptions = controller.DietOptions;
            list<SelectOption> ageOptions = controller.ageOptions;
            list<SelectOption> experienceTypeOptions = controller.experienceTypeOptions;
            List<SelectOption> ExperienceOptions = controller.ExperienceOptions;
            List<SelectOption> LanguageOptions = controller.LanguageOptions;
            List<SelectOption> NationalityOptions = controller.NationalityOptions; 
            list<SelectOption> sortingOptions = controller.sortingOptions;          
            
            controller.sortingSelected = 'Language_1__c';
            controller.LanguageSelected = new list<String>{'Spanish'};
            controller.nationalitySelected = new list<String>{'Spanish'};
            controller.swimmersSelected = 'Yes';
            controller.ageSelected = '18';
            controller.experienceselected = new list<String>{'0 - 1'};
            controller.experienceTypeSelected = new list<String>{'Camp'};
            controller.dietSelected = new list<String>{'Diabetic'};
            controller.genderSelected = 'Female';
            controller.ArrivalSelected = '01/01/2016';
            controller.currentLocationSelected = 'In-Country';
            controller.trainingSelected = 'Infant Specialized';
            controller.hobbiesSelected = new list<String>{'Soccer'};    
            
            controller.dismissedSelected = 'false';
            controller.FavoriteSelected = 'true';   

            //controller.f_field = 'Nationality__c';
            //controller.applyFilter();
            controller.f_object = 'Engagement__c';
            controller.f_field = 'Gender__c';
            controller.f_label = 'Gender';
            //controller.applyFilter();
            
            controller.f_value = 'Female';
            //controller.removeFilter();
            
            //controller.f_field = 'Language_1__c';
            //controller.applyFilter();     
            
            //controller.removeFilter('Engagement__c', 'Language Spoken');  
            //controller.removeFilter('Engagement__c', 'Nationality');  
            
            //controller.getIsMyFiltersEmpty();         
            //controller.getParticipantPhotoList();
            
            //controller.applyFilter();         
            //controller.retrieveVideo();       
    
            //results =  controller.results;
            
            //controller.isAlreadySavedSearch;
            // Others:
            controller.f_value_string(new list<String>{'String1', 'String2'});
            controller.f_value_string(new set<String>{'String1', 'String2'});
            
            // Jose - B-02655 for community_results()
            
            //ApexPages.StandardSetController community_results =  controller.community_results;
            //controller.getengCommList();
            //controller.setpageNumberComm();*/
            
            test.stopTest();        
            
        }        
    }
   
   static testMethod void myUnitTest3() {
        PageReference p=Page.apc_hf_au_pair_profile; 
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        RecordType rtHf = [select id,Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        
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
        System.runAs(user) {            
             
        
            Account myAccountPT = new Account(LastName='Test',personEmail='a@a.com');
            insert myAccountPT;
                
            Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3', Account_Id__c = myAccountPT.Id);
            insert myEngagement;
        
            Account myAccountHF = new Account(LastName='Test', recordTypeId = rtHf.id, Type = 'Host Family', personEmail='a@a.com');
            insert myAccountHF;
                
            Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States',Pets__c='Yes', Pet_Types__c='dog;cat;elephant');
            insert myPosition;
          
           list<Applicant_Info__c> ApplicantList = new  list<Applicant_Info__c>();
                
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Type__c = 'Original',Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id,
                                                                  CreatedBy__c=user.id,   
                                                                  Primary_Language__c = 'English');
                                            
                ApplicantList.add(appInfoHF);
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Type__c = 'Original', Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, 
                                                                  CreatedBy__c=user.id, 
                                                                  Primary_Language__c = 'English',Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3');
              
                
               ApplicantList.add(appInfoPT);
               
               insert ApplicantList;
                
                
                
            
                
            
            ApexPages.currentPage().getParameters().put('recordId', myEngagement.Id);
            ApexPages.CurrentPage().getParameters().put('Id', appInfoPT.Id);  
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(myEngagement);
            search_controller controller = new search_controller('Engagement__c');
            
            ApexPages.StandardSetController results =  controller.results;    
            
            controller.previousPage();
            controller.nextPage();      
            
            set<String> values = new set<String>();
            values.add('Male');
            map<String, set<String>> filters = new map<String, set<String>>();
            filters.put('Gender', values);
            
            controller.myfilters = new map<string, map<String, set<String>>>();
            controller.myFilters.put('Engagement__c', filters);
            test.startTest(); 
            
            controller.saveSearchName = 'Test';
            controller.saveSearch();        
            List<SelectOption> options = controller.savedSearchNames;       
            
            controller.sortingSelected = '';
            controller.savedSearchSelected = 'Test';
            //controller.applySavedSearch();
            
            controller.pageNumberSelected2= '1';
            controller.setpageNumber2();
            
            Date firstAvailableArrivalDate = controller.firstAvailableArrivalDate;
            controller.retrieveVideo();
            
            controller.nationalityOptions_final = null;
            List<SelectOption> NationalityOptions =  controller.NationalityOptions;
            
            list<String> getSuggestedId = controller.getSuggestedId();
            list<String> getFavoriteId = controller.getFavoriteId();
            //Position__c getCurrentPosition = controller.getCurrentPosition();
                        
            List<String> myStrings = new List<String> { 'one', 'two' };
            list<String> removeElementFromList = controller.removeElementFromList(myStrings, 'two');
            
            controller.f_object = 'Engagement__c';
            controller.f_field = 'Gender__c';
            controller.f_label = 'Gender';
            controller.processSelectedValues('Male');
            
            controller.key_Object = 'Applicant_Info__c';
            controller.resetQuery();
            
            
            
            
            //controller.createSelectionRecord('AAAAAA', 'BBBB');
            //controller.removeFilter('Engagement__c', 'Special Diet');         
            //controller.showOnlySuggested();
            test.stopTest();
        }
        
    } 
}