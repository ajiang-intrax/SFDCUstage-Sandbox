@isTest(seeAllData = true)
private class Test_profile_controller { 
    
    static testMethod void myUnitTest01() {
        PageReference p=Page.apc_hf_au_pair_profile; 
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
            
       
        
        Account myAccountPT = new Account(Name='Test');
        insert myAccountPT;
            
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3');
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
            
            
            Account myAccountHF = new Account(Name='Test');
            insert myAccountHF;
                
            Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
            insert myPosition;
          
             Selection__c mySelection = new Selection__c(Position__c = myPosition.Id, Engagement__c = myEngagement.Id); 
             insert mySelection;
                
                list<Applicant_Info__c> ApplicantList = new  list<Applicant_Info__c>();
                
                //Applicant Info HF
                Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                                  RecordTypeId = rtAPC.Id, Position__c= myPosition.id,CreatedBy__c=user.id,   
                                                                  Primary_Language__c = 'English');
                                            
                ApplicantList.add(appInfoHF);  
                
                //Applicant Info PT
                Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id,
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
               
               insert eduList;
               
               //Creting Essays Records
               Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfoPT.Id, 
               Narrative__c = '900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
               insert essay;
               
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
                
                
                insert personInfoList;
                
                Experience__c experience = new Experience__c(Name='ExperienceName', Children_Ages__c = '0-2', Experience_Type__c = 'Babysitting', Frequency__c = 'Daily', Engagement__c = myEngagement.Id, Applicant_Info__c=appInfoPT.Id, IsExperienced__c = true, Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                insert experience;
                
                Experience_Detail__c experienceDet = new Experience_Detail__c(Name='ExperienceDetName',   Experience_Name__c=experience.Id, Special_Needs_Indicated__c = 'Yes', Gender__c = 'Male', Date_of_Birth__c = date.today() - 100);
                insert experienceDet;
                
                Reference__c refer = new Reference__c(Name='Reference', Reference_Status__c = 'Active', Reference_Requested__c = true, Status__c ='Confirmed', Experience_Name__c = experience.id, Engagement__c = myEngagement.Id, Applicant_Info__c=appInfoPT.Id );
                
                User_Preference__c userPref = new User_Preference__c( User__c = sysAdmin.id, Object__c = 'Applicant Info', Saved_Records__c ='["a0U180000005XCFEA2","a0U180000005XbIEAU","a0U180000005sQzEAI"]' ,
                Dismissed_Records__c='["a0U180000005XCFEA2","a0U180000005XbIEAU","a0U180000005sQzEAI"]');
                
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
                
                //Start Test From Here
                Test.startTest();
                
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare',Position__c= myPosition.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id,
                                                                  Primary_Language__c = 'English',Language_1__c='Lang1',  Language_2__c='Lang2', Language_3__c='Lan3');
                                                                  
                 insert appInfo;             
                
                //Set request parameters for constructor without parameters
                ApexPages.currentPage().getParameters().put('id', myEngagement.Id);
                
                //Calling Controller with parameters
                profile_controller controller = new profile_controller();
                
                //Calling Controller with parameters
                profile_controller controllerAux = new profile_controller('Engagement__c');
                profile_controller controllerAux2 = new profile_controller('Position__c');
                
                //Set request parameters for constructor without parameters
                //ApexPages.currentPage().getParameters().put('id', appInfoPT.Id);
                
                //Public Variables
                //list<Applicant_Info__c> applist = controller.applist;
                Applicant_Info__c applicant= controller.applicant;
                map<String, Experience__c> mapExperienceRef= controller.mapExperienceRef;
                map<String, String> ExpDetDOBStart= controller.ExpDetDOBStart;
                map<String, String> ExpDetDOBEnd= controller.ExpDetDOBEnd;
                list<DISC__c> discInfoList11 = controller.discInfoList;
    
                set<String> favRecords = controller.favRecords;
                set<String> disRecords = controller.disRecords;
                
                Person_Info__c primary01 = controller.primary;
                
                list<Person_Info__c> siblingList01 = controller.siblingList;
                list<Experience__c> listExperienceAux = controller.listExperience;
                
                list<Reference__c> test2 = controller.getlistPersonalRef();
                list<Reference__c> test3 = controller.getlistChildCareRef();
                
                list<Applicant_Info__c> applistAux = new list<Applicant_Info__c>();
                controller.applist = applistAux;
                map<String, boolean> isFavoriteId1 = new map<String, boolean>();
                isFavoriteId1 = controller.isFavoriteId;
                map<String, boolean> isDismissedId1 = new map<String, boolean>();
                isDismissedId1 = controller.isDismissedId;
                list<Intrax_Program_Upload__c> phyDocList1 = controller.phyDocList;
                list<Intrax_Program_Upload__c> LifeGuardDocList1 = controller.LifeGuardDocList;
                list<sObject> familyList01 = controller.familyList;
                map<String, String> MapExpDetSize01 = new map<String, String>();
                MapExpDetSize01 = controller.MapExpDetSize;
                map<String, list<Experience_Detail__c>> MapExperienceDet01 = new map<String, list<Experience_Detail__c>>();
                MapExperienceDet01 = controller.MapExperienceDet;
                map<String, Boolean> MapExpDetNeed01 = new map<String, Boolean>();
                MapExpDetNeed01 = controller.MapExpDetNeed;
                Boolean hasInterviewInProgress01 = controller.hasInterviewInProgress;
                List<Essay__c> essayList01 = controller.essayList;
                Assessment__c asseessmentInterv01 = controller.asseessmentInterv;
                DISC__c discInfo01 = controller.discInfo; 
                list<String> HLightList01 = controller.HLightList;
                map<String,list<Education__c>> mapEducation01 = controller.mapEducation;
                map<String, String> AuxLangMap =  controller.getmapLang();
                list<String> listLanguage01 = controller.listLanguage;
                //list<String> pt_photos01 = controller.pt_photos;
                //list<String> ptphotoMethod = controller.getParticipantPhotoList();
                
                
                //Changing Key_Object
                controller.key_object = 'Applicant_Info__c';
                
                list<sObject> familyList02 = controller.familyList;
                list<Person_Info__c> siblingList02 = controller.siblingList;
                list<Experience__c> listExperienceAux2 = controller.listExperience;
                Assessment__c asseessmentInterv02 = controller.asseessmentInterv;
                DISC__c discInfo02 = controller.discInfo; 
                list<String> HLightList02 = controller.HLightList;
                map<String,list<Education__c>> mapEducation02 = controller.mapEducation;
                map<String, String> AuxLangMap2 =  controller.getmapLang();
                list<String> listLanguage02 = controller.listLanguage;
                list<Reference__c> test4 = controller.getlistPersonalRef();
                list<Reference__c> test5 = controller.getlistChildCareRef();
                User usertest1 = controller.currentUser;
                Pagereference pagetest1 = controller.saveParticipant();
                 controller.saveAsFavorite();
                Boolean isFavorite01 = controller.isFavorite;
                isFavoriteId1 = controller.isFavoriteId;
                controller.removeAsFavorite();
                controller.retrieveVideo();
                //Boolean exceedInterviewLimit01 = controller.exceedInterviewLimit;
                controller.requestInterview();
                PageReference page01 = controller.saveAsDismissed();
                //controller.removeAsDismissed();       
               
                
                
                //Stop Test Here
                Test.stopTest();
                
            }
    }
}