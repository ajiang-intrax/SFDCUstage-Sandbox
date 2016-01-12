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
private class Test_AppEngine_Controller_APC {

        static testMethod void myUnitTest() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','SignComplete'); 
        Test.setCurrentPage(p); 
        
         //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
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
            System.runAs(sysAdmin) {
        
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
                //RecordType rt_pos = [select id,Name from RecordType where SobjectType='Position_Info' and Name='Default' Limit 1];
 
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
                
                Test.startTest();
                 
                 //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfoAPCPT);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                sysAdmin.User_Interests__c = 'Becoming an au pair';
                ApexPages.currentPage().getParameters().put('appType', 'apc-pt');
                
                
                ApexPages.currentPage().getParameters().put('docType', 'AllDocuments');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'FinancialResponsibility');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'Academic');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'HostAgreements');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'Resume');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'igi-documents');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'igi-documents');
                appInfoAPCPT.Intrax_Program_Category__c = 'Hospitality & Tourism';
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'igi-documents');
                appInfoAPCPT.Intrax_Program_Category__c = 'Social Development';
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'Test');
                controller.getDocList();
                
                controller.applicantinfo = appInfoAPCPT;
                controller.personInfo =  personInfo;
                controller.addlanguage = 3;
                controller.deletelanguagesIGI();
                controller.isVideoSuccessinit();
                controller.AuditPreApp();
                
                personinfo.Date_of_Birth__c = date.newInstance(1992, 2, 17);
                personinfo.Citizenship__c ='Spain';
                personinfo.Country_of_Residence__c = 'Spain';
                personinfo.Nationality__c = 'Spanish';
                personinfo.Marital_Status__c ='Single';
                personinfo.Secondary_School_Indicated__c ='Yes';
                personinfo.Offence_Indicated__c = 'No';
                personinfo.Overall_Health__c = 'Good';
                personinfo.Contagious_Disease_Indicated__c = 'No';
                personinfo.Drug_Dependency_Indicated__c = 'No';
                personinfo.Pregnancy_Indicated__c = 'No';
                personinfo.Medication_Indicated__c ='No';
                personinfo.Hospitalization_Indicated__c ='No';
                personinfo.Physical_Disabilities_Indicated__c = 'No';
                personinfo.Psychiatric_Treatment_Indicated__c ='No';
                controller.personinfo = personInfo;
                controller.AuditPreApp();
                
                controller.QualifyPreApp();
                controller.UnqualifyPreApp();
                controller.login_redirect();
                controller.deleteExperienceAPC();
                controller.deleteReferenceAPC();
                controller.deletePersonReferenceAPC();
                //controller.skipPage();
                
                controller.savePersonInfoReferNew();
                controller.savePersonInfoReferPTNew(); 
                controller.savePersonRole('Spouse or Partner');
                controller.savePersonRole('Host');
                controller.savePersonEmergency();
                
                controller.getCheckWTParticipantPhotos();
                controller.getCheckPreviousAddress();
                controller.getCheckHFAgreementsUpload();
                controller.getCheckHFAgreementsDS();
                controller.getCheckHFAgreementsDSSent();
                controller.getCheckHFReferences();
                controller.getcheckPreApp();
                controller.getcheckPreAppCenters();
                controller.getcheckPreAppWT();
                controller.getcheckCtrHomestayAccommodationReqd();
                controller.getcheckCtrVisaInformationReqd();
                controller.getcheckCtrVisaDocumentsReqd();
                controller.getcheckCtrAirportTransferReqd();
                controller.getcheckCtrPreApp();
        
                //New line addedd
                controller.login_redirect();
                controller.getCheckSwimCert();
                controller.getcheckMainApp();
                controller.getCheckFamilyMembers();
                controller.getcheckEmergencyContact();
                controller.getcheckParticipantPhotos();
                controller.getCheckDoctor();
                controller.getcheckAgreements();
                controller.getcheckFamilyAlbum();
                controller.getcheckAcademicRecommendation();
                controller.getcheckSchoolTranscript();
                
                
                //Stop Test Here
                Test.stopTest();
            }
        
    }
        
        static testMethod void myUnitTestforAPCPT() {
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Contact
        
        list<Account> listAcc = new list<Account>();
        
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
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
        listAcc.add(portalAccount);
        
        insert listAcc;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        
            //Run in user context
        System.runAs(sysAdmin) {
        
                //AA Applicant Info APCPT
                Applicant_Info__c appInfoAPCPT = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',Allow_Intrax_To_Apply__c=True,
                                                                  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPCPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Language_3__c='English',Language_2__c='',Language_1__c='',
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
                                                                  Engagement_Start__c = System.today()-2, Accommodation_Preference__c = 'Homestay',Application_Level__c='Main',Intrax_Program__c='AuPairCare',Application_Type__c='Orignal',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfoAPCPT;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoAPCPT.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfoAPCPT.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',Functional_Areas__c = 'Accounting');
                insert posInfo;
                
                list<Education__c> Edulist = new list<Education__c>();
                
                Education__c ed1 = new Education__c(Institution_Type__c = 'Secondary-School-Diploma', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoAPCPT.Id);
                Edulist.add(ed1);
                            
                
                Education__c ed2 = new Education__c(Institution_Type__c = 'University/College', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoAPCPT.Id);
                Edulist.add(ed2);
                
                Education__c ed3 = new Education__c(Institution_Type__c = 'Vocational Training', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoAPCPT.Id);
                Edulist.add(ed3);
                
                insert Edulist;
                
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoAPCPT.Id,Document_Type__c='Secondary-School-Diploma',Education__c=ed2.id);
                
                list<Intrax_Program_Upload__c> DocListEducation= new list<Intrax_Program_Upload__c> ();
                DocListEducation.add(ipUpload);
                
                insert DocListEducation;
                
                Test.startTest();
                 
                 //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfoAPCPT);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //AA
                //controller.DocListEducation=DocListEducation;
                controller.LoadEduDocRecord();
                controller.addedu = 'university';
                controller.addEducationRecordApc();
                controller.addedu = 'certification';
                controller.addEducationRecordApc();
                controller.educationType = 'university';
                controller.delEducationRec=ed1.id;
                controller.LoadEduDocRecord();
                controller.removeEducationRecordapc();
                
                sysAdmin.User_Interests__c = 'Becoming an au pair';
                ApexPages.currentPage().getParameters().put('appType', 'apc-pt');
                /*
                controller.login_redirect();
                controller.getCheckSwimCert();
                controller.getcheckMainApp();
                controller.getCheckFamilyMembers();
                controller.getcheckEmergencyContact();
                controller.getcheckParticipantPhotos();
                controller.getCheckDoctor();
                controller.getcheckAgreements();
                controller.getcheckFamilyAlbum();
                controller.getcheckAcademicRecommendation();
                controller.getcheckSchoolTranscript();
                 */               
                controller.saveRefererInfo();
                controller.saveEducationApc();
                
                controller.addExperienceRecord();
                controller.addEmergencyRecord();
                controller.getEmergencyMapLast();
                controller.getExperienceMapLast();
                
                controller.buildEducationMap();
                controller.buildExperienceMap();
                controller.getPositionList();
   
                controller.signUpForPosition();
                String photoURL = controller.getUrlPic();
                controller.StageToInReview();
                controller.removeOtherPhone();
                //controller.deletelanguagesIGI();
                controller.getLanguageLevel();
                controller.getUSAStatesList();
                controller.CheckPtVideoUpdate();
                controller.isVideoSuccess();
                ApexPages.currentPage().getParameters().put('id', appInfoAPCPT.Id);
                controller.login_redirect_internal();
                appInfoAPCPT.Allow_Intrax_To_Apply__c=False;
                controller.login_redirect_internal();
                sysAdmin.User_Interests__c = 'Finding an internship';
                controller.login_redirect();
               
                ApexPages.currentPage().getParameters().put('id', appInfoAPCPT.ID); 
                appInfoAPCPT.type__c = 'Participant';
                controller.getProgId();
                
                ApexPages.currentPage().getParameters().put('id', appInfoAPCPT.ID); 
                appInfoAPCPT.type__c = 'Host Family';
                controller.getProgId();
                
                ApexPages.currentPage().getParameters().put('id', appInfoAPCPT.ID); 
                appInfoAPCPT.type__c = 'Test';
                //controller.getProgId();
                
                ApexPages.currentPage().getParameters().put('partnerApp', 'True');
                ApexPages.currentPage().getParameters().put('EC', 'Partner');
                ApexPages.currentPage().getParameters().put('IPO', 'Partner');
                
                //Stop Test Here
                Test.stopTest();
            }
        
    }
    
        static testMethod void myUnitTestforAPCHF() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
       
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', BillingStreet = 'TestAddress', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                list<Person_Info__c> listAuxPerson = new list<Person_Info__c>();
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfo;

                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                //insert personInfo;
                listAuxPerson.add(personInfo);
                
                
                //personRef
                Person_Info__c personref = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                //insert personref;
                listAuxPerson.add(personref);
                
                Experience__c experience = new Experience__c(Name='ExperienceName', Frequency__c = 'Daily', Applicant_Info__c=appInfo.Id, IsExperienced__c = true, Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                insert experience;
                
                list<Person_Info__c> personInfoReferList = new list<Person_Info__c>();
                list<Person_Info__c>  children = new list<Person_Info__c>();
                list<Person_Info__c>  parents = new list<Person_Info__c>();
                list<Person_Info__c>  Family = new list<Person_Info__c>();
                list<Experience__c>  listExperience = new list<Experience__c>();
                list<Essay__c>  essayList = new list<Essay__c>();
                
                personInfoReferList.add(personref);
                children.add(personref);
                parents.add(personref);
                Family.add(personref);
                listExperience.add(experience);
                
                //personEmergency
               
                
                Person_Info__c personEmergency = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                //insert personEmergency;
                listAuxPerson.add(personEmergency);
                 //familyInfo
                Person_Info__c familyInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                //insert familyInfo;
                listAuxPerson.add(familyInfo);
                 //personRef
                Person_Info__c refererInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                //insert refererInfo;
                listAuxPerson.add(refererInfo);
                
                //insert list
                insert listAuxPerson;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, 
                Narrative__c = '900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
                insert essay;
                
                essayList.add(essay);
                
                Position_Info__c positionInfo = new Position_Info__c(Name='PositioninfoName', Applicant_Info__c=appInfo.Id, Company_Country__c = 'United States' , Company_State__c = 'CALI' );
                insert positionInfo;
                
                
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_home');
                ApexPages.currentPage().getParameters().put('mid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('rid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('role', 'Host');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('add', 'true');
                ApexPages.currentPage().getParameters().put('AuPairPref', 'true');
                ApexPages.currentPage().getParameters().put('saveExperienceDetail', 'true');
                ApexPages.currentPage().getParameters().put('saveChildReference', 'true');
                ApexPages.currentPage().getParameters().put('pageId', '28');
                ApexPages.currentPage().getParameters().put('savePersonRef', 'true');
                ApexPages.currentPage().getParameters().put('saveChildren', 'true');
                ApexPages.currentPage().getParameters().put('saveParents', 'true');
                ApexPages.currentPage().getParameters().put('saveFamily', 'true');
                ApexPages.currentPage().getParameters().put('vstate', 'true');
                ApexPages.currentPage().getParameters().put('idNeeded', 'true');
                ApexPages.currentPage().getParameters().put('viewpage', 'true');
                ApexPages.currentPage().getParameters().put('roleInput', 'true');
                //ApexPages.currentPage().getParameters().put('docType', 'true');
                ApexPages.currentPage().getParameters().put('expireMonth', 'true');
                ApexPages.currentPage().getParameters().put('expireYear', 'true');
                ApexPages.currentPage().getParameters().put('maskCCNumber', 'true');
                ApexPages.currentPage().getParameters().put('paymentTxId', 'true');
                ApexPages.currentPage().getParameters().put('paymentAmount', 'true');
                ApexPages.currentPage().getParameters().put('paymentDate', 'true');
                
                
                //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //Populating Varaiables with values
                controller.user = user;
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.positionInfo = positionInfo;
                controller.personInfoReferList = personInfoReferList;
                controller.familyInfo = familyInfo;
                controller.refererInfo = refererInfo;
                controller.personEmergency = personEmergency;
                controller.children = children;
                controller.parents = parents;
                controller.Family = Family;
                controller.listExperience = listExperience;
                controller.essayList = essayList;
                controller.personRole = personInfo;
                controller.experience = experience;
                controller.experienceId = experience.id;
                                
                controller.paymentTxId = 'test';
                controller.paymentAmount = '1000';
                controller.paymentDate = '02/2/02/2014';
                controller.clear = 'test';
                controller.EssayUp = 'EssayUp';
                controller.progId = 'ayusa-hf';
                controller.role = 'both';
                controller.app = 'apc';
                controller.basics('apc');
                
                //Check for login
                controller.checkLogin();
                //controller.getProgId();
                controller.saveUserInfo();
                
                //Getting  variables
                String aux1 = controller.derivedBaseUrl;
                String aux2 = controller.retURL;
                Boolean aux3 = controller.isExperienced;
                String aux4 = controller.partnerId;
                String aux5 = controller.participantId;
                controller.getPartnerIntraxPrograms();
                controller.USStatevalidator();
                
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_my_information');
                
                //Set fields on "My Information" Page
                personInfo.First_Name__c = 'Test First Name';
                personInfo.Last_Name__c = 'Test Last Name';
                personInfo.Gender__c = 'Female';
                personInfo.Date_Of_Birth__c = date.newinstance(1980, 2, 17);
                personInfo.Citizenship__c = 'United States';
                personInfo.Email__c = 'test@test.com';
                
                //Click on Save & Continue Button
                
                controller.navigator();
                controller.PageStatusController();
                controller.getcheckCompletedEssays();
                controller.getcheckCompletedEssaysWT();
                appInfo.Application_Stage__c = 'Working';
                controller.getCheckHFNumberAppStatus();
                controller.resetVariables();
                controller.selectedProfessionalCertificatesProduct();
                controller.selectedIntensityProduct();
                controller.selectedAccommodationProduct();
                controller.callValidatePlanAndAccommodations();
                controller.getCategoryExperience();
                controller.getTypeExperience();
                controller.getlistUSArrivalDates();
                controller.addotherphone();
                controller.addlanguage= 0;
                controller.addlanguages();
                
                
                Apexpages.currentPage().getParameters().put('SubmitApp','HF');
                controller.saveApplication();
                /*Apexpages.currentPage().getParameters().put('SubmitApp','APCPT');
                controller.saveApplication();
                Apexpages.currentPage().getParameters().put('SubmitApp','PA');
                controller.saveApplication();
                Apexpages.currentPage().getParameters().put('SubmitApp','IGIPA');
                personInfo.Pregnancy_Indicated__c = 'No';
                controller.saveApplication();
                */
                controller.addlanguage = 3;
                controller.deletelanguages();
                controller.addlanguage = 2;
                controller.deletelanguages();
                controller.addlanguage = 1;
                controller.deletelanguages();
                
                
                
                controller.setCurrentDate();
                controller.addotherparent();
                controller.addPtReference();
                controller.getTypeCard();
                controller.getMonth();
                controller.getYear();
                
                ApexPages.currentPage().getParameters().put('event', 'Cancel');
                //controller.MethodAPCTCFinal();
                ApexPages.currentPage().getParameters().put('event', 'Decline');
                controller.MethodAPCTCFinal();
                
                
                
                appInfo.Any_Sibling_Indicated__c = 'Yes';
                
                List<PersonInfoFamilyWrapper> wrappersfamily = new List<PersonInfoFamilyWrapper>();
                List<PersonInfoParentWrapper> wrappersParent = new List<PersonInfoParentWrapper>();
                List<PersonInfoChildWrapper> wrappers = new List<PersonInfoChildWrapper>();
                List<ExperienceDetailWrapper> wrappersExp = new List<ExperienceDetailWrapper>();
                List<Experience_Detail__c>  experDetails = new List<Experience_Detail__c>();
                controller.wrappersfamily = wrappersfamily;
                controller.wrappersParent = wrappersParent;
                controller.wrappers = wrappers;
                controller.wrappersExp = wrappersExp;
                
                controller.iWantMyJSValues();
                controller.useCurrentBillingAddressInfo= true;
                //controller.blankOutAddressDetailsOnPaymentPage();
                controller.useCurrentBillingAddressInfo= false;
                controller.blankOutAddressDetailsOnPaymentPage();
                controller.backToPaymentEditPage();
            
                appInfo.Application_Level__c = 'Yes';
                appInfo.Engagement_Start__c = System.today();
                controller.selectedStudyWeeks = '1';
                appInfo.Visa_Category__c = 'Student (F)';
                controller.getStudFVisa();
            
               
                //Add Apexpages.currentPage().getParameters() for save app
                Apexpages.currentPage().getParameters().put('SubmitApp', 'APCHF');
                Apexpages.currentPage().getParameters().put('LevelAppUp', 'true');
                Apexpages.currentPage().getParameters().put('reviewSubmit', 'RS');
                Apexpages.currentPage().getParameters().put('DeclineBApp', 'DA');
                Apexpages.currentPage().getParameters().put('DeclineApp', 'DA');
                controller.saveApplication();
                
                
                //controller.PPvalidator();
                controller.deleteAllowCloning();
                
                //controller.saveApplication('TMD');
                //controller.saveApplication('AyusaPT');
                //controller.saveApplication('Participant');
                //controller.saveApplication('AyusaHF');
                controller.saveApplication('APCHF');
                //controller.saveApplication('APCPT');
                //controller.saveApplication('Centers');
                //controller.saveApplication('IGI');
                //controller.saveApplication('WT');
                controller.getCheckHFNoAppStatus();
                controller.deleteExperienceAPC(); 
                
                PaymentWrapper payWrapper = new PaymentWrapper();
                controller.payWrapper = payWrapper;
                //controller.navigateToPaymentNonEditPage();
                
                
                
                Payment__c payment = new Payment__c();
                controller.payment = payment;
                
                
                controller.promoCodeValue = 'APCFAMILY';
                List<PriceBookEntry> couponCodes = new List<PriceBookEntry>();
                List<PriceBookEntry> standartFeeApc = new List<PriceBookEntry>();
                Pricebook2 standardPB = [select id from Pricebook2 where IsStandard = true limit 1];
                
                list<Product2> prodList = new list<Product2>();
                
                Product2 prod1 = new product2(name='Application Fee', family = 'Host Family',Intrax_Program__c= 'AupairCare',ChildOppType__c='Application',Description = 'Application Fee', IsActive = true,Fee_Type__c='Fixed');
                prodList.add(prod1);
                Product2 prod2 = new product2(name='Waived application fee',family = 'Promo codes',Intrax_Program__c= 'AupairCare',ChildOppType__c='Application', Description = 'Waived application fee', IsActive = true,Fee_Type__c='Fixed',Promo_Code__c = 'APCFAMILY');
                prodList.add(prod2);
                insert  prodList; 
                
                //For Standard Pricebook
                PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
                couponCodes.add(standardPrice1);
                PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
                couponCodes.add(standardPrice2);

                //For Custom Pricebook
                Pricebook2 ApcPriceBook2test = new Pricebook2 (name='APC USA HF',Intrax_Programs__c= 'AupairCare',Description='Price book for APC HFs in USA',IsActive = true,Price_Book_Code__c= 'APC USA');
                insert ApcPriceBook2test;
                
                PricebookEntry customPbEntry1 = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false, Pricebook2Id = ApcPriceBook2test.ID);
                couponCodes.add(customPbEntry1);
                //PricebookEntry customPbEntry2 = new PricebookEntry(Product2Id = prod2.Id, UnitPrice = -50, IsActive = true, UseStandardPrice = false, Pricebook2Id = ApcPriceBook2test.ID);
                //insert customPbEntry2;
                
                //standartFeeApc.add(customPbEntry1);
                //insert standartFeeApc;
                
                //couponCodes.add(customPbEntry1);
                insert couponCodes;
                //controller.standartFeeApc = standartFeeApc;
                controller.couponCodes = couponCodes;
                controller.checkPromo();
                controller.makeAWSPayment();
                
                appInfo.Type__c = 'Participant';
                controller.navigator(); 
                controller.AddressValidation_controller();
                //controller.checkDocuSign();
                 
                //Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test',Document_service__c  = 'IS',Applicant_Info__c = appInfo.Id,
                //document_type__c = 'Participant-Album');
                //insert ipUpload;
                //ApexPages.currentPage().getParameters().put('IdIPU', ipUpload.id);
                //controller.RetrieveIPU();
                
                //Stop Test Here
                Test.stopTest();
                
            }
        }
    }
    
    static testMethod void myUnitTestforIPU() {
        Test.startTest();
       
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
       
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                list<Person_Info__c> listAuxPerson = new list<Person_Info__c>();
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfo;
        
        
        Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test',Document_service__c  = 'IS',Applicant_Info__c = appInfo.Id,
                document_type__c = 'Participant-Album');
                insert ipUpload;
                ApexPages.currentPage().getParameters().put('IdIPU', ipUpload.id);
                //controller.RetrieveIPU();
                
                //Stop Test Here
                Test.stopTest();
    }
    
        }
    }
    static testMethod void myUnitTestforAPCHF1() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
       
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country_of_Interest__c = 'Whatever', Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfo;

                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                
                
                //personRef
                Person_Info__c personref = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personref;
                
                Experience__c experience = new Experience__c(Name='ExperienceName', Frequency__c = 'Daily', Applicant_Info__c=appInfo.Id, IsExperienced__c = true, Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                insert experience;
                
                list<Person_Info__c> personInfoReferList = new list<Person_Info__c>();
                list<Person_Info__c>  children = new list<Person_Info__c>();
                list<Person_Info__c>  parents = new list<Person_Info__c>();
                list<Person_Info__c>  Family = new list<Person_Info__c>();
                list<Experience__c>  listExperience = new list<Experience__c>();
                list<Essay__c>  essayList = new list<Essay__c>();
                
                personInfoReferList.add(personref);
                children.add(personref);
                parents.add(personref);
                Family.add(personref);
                listExperience.add(experience);
                
                //personEmergency
                Person_Info__c personEmergency = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personEmergency;
                
                 //familyInfo
                Person_Info__c familyInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert familyInfo;
                
                 //personRef
                Person_Info__c refererInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert refererInfo;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, 
                Narrative__c = '900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
                insert essay;
                
                essayList.add(essay);
                
                Program_Duration__c setting1 = new Program_Duration__c();
                setting1.Name = 'Test Setting';
                setting1.Country__c = 'Whatever';
                setting1.min_Duration__c = 5;
                setting1.Category__c = 'Whatever';
                setting1.max_Duration__c = 6;
                setting1.Intrax_Program__c = 'Whatever';
                setting1.Intrax_Program_Option__c = 'Whatever';
                insert setting1;
                
                
                /*Lead_Routing__c setting2 = new Lead_Routing__c();
                setting2.Name = 'Test Setting';
                setting2.Program__c = 'Internship';
                insert setting2;
                */
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_home');
                ApexPages.currentPage().getParameters().put('mid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('rid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('role', 'Host');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('add', 'true');
                ApexPages.currentPage().getParameters().put('AuPairPref', 'true');
                ApexPages.currentPage().getParameters().put('saveExperienceDetail', 'true');
                ApexPages.currentPage().getParameters().put('saveChildReference', 'true');
                ApexPages.currentPage().getParameters().put('pageId', '28');
                ApexPages.currentPage().getParameters().put('savePersonRef', 'true');
                ApexPages.currentPage().getParameters().put('saveChildren', 'true');
                ApexPages.currentPage().getParameters().put('saveParents', 'true');
                ApexPages.currentPage().getParameters().put('saveFamily', 'true');
                ApexPages.currentPage().getParameters().put('vstate', 'true');
                ApexPages.currentPage().getParameters().put('idNeeded', 'true');
                ApexPages.currentPage().getParameters().put('viewpage', 'true');
                ApexPages.currentPage().getParameters().put('roleInput', 'true');
                //ApexPages.currentPage().getParameters().put('docType', 'true');
                ApexPages.currentPage().getParameters().put('expireMonth', 'true');
                ApexPages.currentPage().getParameters().put('expireYear', 'true');
                ApexPages.currentPage().getParameters().put('maskCCNumber', 'true');
                ApexPages.currentPage().getParameters().put('paymentTxId', 'true');
                ApexPages.currentPage().getParameters().put('paymentAmount', 'true');
                ApexPages.currentPage().getParameters().put('paymentDate', 'true');
                
                
                //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //Populating Varaiables with values
                controller.user = user;
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                
                controller.personInfoReferList = personInfoReferList;
                controller.familyInfo = familyInfo;
                controller.refererInfo = refererInfo;
                controller.personEmergency = personEmergency;
                controller.children = children;
                controller.parents = parents;
                controller.Family = Family;
                controller.listExperience = listExperience;
                controller.essayList = essayList;
                controller.personRole = personInfo;
                controller.experience = experience;
                controller.experienceId = experience.id;
                                
                controller.paymentTxId = 'test';
                controller.paymentAmount = '1000';
                controller.paymentDate = '02/2/02/2014';
                controller.clear = 'test';
                controller.EssayUp = 'EssayUp';
                controller.progId = 'ayusa-hf';
                controller.role = 'both';
                controller.app = 'apc';
                controller.basics('apc');
          
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_my_information');
                
                //Set fields on "My Information" Page
                personInfo.First_Name__c = 'Test First Name';
                personInfo.Last_Name__c = 'Test Last Name';
                personInfo.Gender__c = 'Female';
                personInfo.Date_Of_Birth__c = date.newinstance(1980, 2, 17);
                personInfo.Citizenship__c = 'United States';
                personInfo.Email__c = 'test@test.com';
                
                //Click on Save & Continue Button
             
                controller.addlanguage = 2;
                controller.deletelanguages();
                controller.addlanguage = 1;
             
                
                
                controller.PageStatusController('031');
                controller.PageStatusController('034');
                controller.PageStatusController('021');
                controller.PageStatusController('026');
                controller.PageStatusController('028');
                controller.PageStatusController('035');
                controller.PageStatusController('030');
                
                /*
                ApexPages.currentPage().getParameters().put('pageId', '001');
                controller.PageStatusController('001');
                controller.PageStatusController('029');
                ApexPages.currentPage().getParameters().put('pageId', '028');
                appInfo.PageStatus_Started__c = '020';
                appInfo.PageStatus_Complete__c = '020';
                controller.PageStatusController('021');
                //controller.PageStatusController();
                appInfo.PageStatus_Started__c = '020';
                controller.PageStatusController('026');
                controller.PageStatusController('027');
                */
                
                ApexPages.currentPage().getParameters().put('event', 'Cancel');
                controller.MethodAPCTCFinal();
                ApexPages.currentPage().getParameters().put('event', 'Decline');
                controller.MethodAPCTCFinal();
                
                appInfo.Any_Sibling_Indicated__c = 'Yes';
                
                List<PersonInfoFamilyWrapper> wrappersfamily = new List<PersonInfoFamilyWrapper>();
                List<PersonInfoParentWrapper> wrappersParent = new List<PersonInfoParentWrapper>();
                List<PersonInfoChildWrapper> wrappers = new List<PersonInfoChildWrapper>();
                List<ExperienceDetailWrapper> wrappersExp = new List<ExperienceDetailWrapper>();
                List<Experience_Detail__c>  experDetails = new List<Experience_Detail__c>();
                controller.wrappersfamily = wrappersfamily;
                controller.wrappersParent = wrappersParent;
                controller.wrappers = wrappers;
                controller.wrappersExp = wrappersExp;
                
                //controller.savePersonInfoReferNew();
                //controller.savePersonInfoReferPTNew(); 
                //controller.savePersonRole('Spouse or Partner');
                //controller.savePersonRole('Host');
                //controller.savePersonEmergency();
                
                appInfo.PageStatus_Complete__c = '020;051;052;053;056;058';
                controller.getCheckMainIGIApp();
                controller.getcheckCtrPassportLoaded();
                controller.getIsSelfInsuranceParticipant();
                controller.getcheckCtrFRDocsLoaded();
                controller.getCheckCtrResidenceClub();
                controller.saveHealthInfo();
                /*
                controller.saveApplication('AyusaPT');
                controller.saveApplication('AyusaHF');
                controller.saveApplication('APCPT');
                controller.saveApplication('Centers');
                controller.saveApplication('IGI');
                controller.saveApplication('WT');
                */
               
                controller.addsiblings();
                controller.deletesiblings();
                controller.delWrapper();
                controller.addRows();
                //controller.saveChildren();
                controller.delWrapperPar();
                controller.addRowsPar();
                controller.delWrapperFamily();
                controller.addRowsParfamily();
                //controller.saveParents();
                //controller.saveFamily();
                controller.delWrapperExp();
                controller.addRowsExp();
                //controller.saveExperienceDet();
                controller.addEmergContact();
                //controller.apcredirect();
                controller.login_redirect();
                sysAdmin.User_Interests__c = 'Becoming an au pair';
                //controller.apcredirect();
                controller.login_redirect();
                controller.cleanHowHeard();
               
                ApexPages.currentPage().getParameters().put('partnerId', '034jskj');
                controller.navigator(); 
                //Stop Test Here
                Test.stopTest();
                
            }
        }
    }
    
    static testMethod void myUnitTestforAPCHF2() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
       
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country_of_Interest__c = 'Whatever', Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfo;

                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                
                
                //personRef
                Person_Info__c personref = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personref;
                
                Experience__c experience = new Experience__c(Name='ExperienceName', Frequency__c = 'Daily', Applicant_Info__c=appInfo.Id, IsExperienced__c = true, Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                insert experience;
                
                list<Person_Info__c> personInfoReferList = new list<Person_Info__c>();
                list<Person_Info__c>  children = new list<Person_Info__c>();
                list<Person_Info__c>  parents = new list<Person_Info__c>();
                list<Person_Info__c>  Family = new list<Person_Info__c>();
                list<Experience__c>  listExperience = new list<Experience__c>();
                list<Essay__c>  essayList = new list<Essay__c>();
                
                personInfoReferList.add(personref);
                children.add(personref);
                parents.add(personref);
                Family.add(personref);
                listExperience.add(experience);
                
                //personEmergency
                Person_Info__c personEmergency = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personEmergency;
                
                 //familyInfo
                Person_Info__c familyInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert familyInfo;
                
                 //personRef
                Person_Info__c refererInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert refererInfo;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, 
                Narrative__c = '900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
                insert essay;
                
                essayList.add(essay);
                
                Program_Duration__c setting1 = new Program_Duration__c();
                setting1.Name = 'Test Setting';
                setting1.Country__c = 'Whatever';
                setting1.min_Duration__c = 5;
                setting1.Category__c = 'Whatever';
                setting1.max_Duration__c = 6;
                setting1.Intrax_Program__c = 'Whatever';
                setting1.Intrax_Program_Option__c = 'Whatever';
                insert setting1;
                
                
                /*Lead_Routing__c setting2 = new Lead_Routing__c();
                setting2.Name = 'Test Setting';
                setting2.Program__c = 'Internship';
                insert setting2;
                */
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_home');
                ApexPages.currentPage().getParameters().put('mid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('rid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('role', 'Host');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('add', 'true');
                ApexPages.currentPage().getParameters().put('AuPairPref', 'true');
                ApexPages.currentPage().getParameters().put('saveExperienceDetail', 'true');
                ApexPages.currentPage().getParameters().put('saveChildReference', 'true');
                ApexPages.currentPage().getParameters().put('pageId', '28');
                ApexPages.currentPage().getParameters().put('savePersonRef', 'true');
                ApexPages.currentPage().getParameters().put('saveChildren', 'true');
                ApexPages.currentPage().getParameters().put('saveParents', 'true');
                ApexPages.currentPage().getParameters().put('saveFamily', 'true');
                ApexPages.currentPage().getParameters().put('vstate', 'true');
                ApexPages.currentPage().getParameters().put('idNeeded', 'true');
                ApexPages.currentPage().getParameters().put('viewpage', 'true');
                ApexPages.currentPage().getParameters().put('roleInput', 'true');
                //ApexPages.currentPage().getParameters().put('docType', 'true');
                ApexPages.currentPage().getParameters().put('expireMonth', 'true');
                ApexPages.currentPage().getParameters().put('expireYear', 'true');
                ApexPages.currentPage().getParameters().put('maskCCNumber', 'true');
                ApexPages.currentPage().getParameters().put('paymentTxId', 'true');
                ApexPages.currentPage().getParameters().put('paymentAmount', 'true');
                ApexPages.currentPage().getParameters().put('paymentDate', 'true');
                
                
                //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //Populating Varaiables with values
                
                ApexPages.currentPage().getParameters().put('pageId', '001');
                controller.PageStatusController('001');
                controller.PageStatusController('029');
                ApexPages.currentPage().getParameters().put('pageId', '028');
                appInfo.PageStatus_Started__c = '020';
                appInfo.PageStatus_Complete__c = '020';
                controller.PageStatusController('021');
                //controller.PageStatusController();
                appInfo.PageStatus_Started__c = '020';
                controller.PageStatusController('026');
                controller.PageStatusController('027');
                
                
                
                List<PersonInfoFamilyWrapper> wrappersfamily = new List<PersonInfoFamilyWrapper>();
                List<PersonInfoParentWrapper> wrappersParent = new List<PersonInfoParentWrapper>();
                List<PersonInfoChildWrapper> wrappers = new List<PersonInfoChildWrapper>();
                List<ExperienceDetailWrapper> wrappersExp = new List<ExperienceDetailWrapper>();
                List<Experience_Detail__c>  experDetails = new List<Experience_Detail__c>();
                controller.wrappersfamily = wrappersfamily;
                controller.wrappersParent = wrappersParent;
                controller.wrappers = wrappers;
                controller.wrappersExp = wrappersExp;
                
                controller.savePersonInfoReferNew();
                controller.savePersonInfoReferPTNew(); 
                controller.savePersonRole('Spouse or Partner');
                controller.savePersonRole('Host');
                controller.savePersonEmergency();
                
               
                controller.saveApplication('AyusaPT');
                controller.saveApplication('AyusaHF');
                controller.saveApplication('APCPT');
                controller.saveApplication('Centers');
                controller.saveApplication('IGI');
                controller.saveApplication('WT');
               
                Essay__c t11 = controller.EssayParentLetter;
                Essay__c t12 = controller.EssayFamilyLetter;
                User t13 = controller.setUserType;
                String t14 = controller.UserInterests;
                Boolean t15 = controller.isArrival; 
                Boolean t16 = controller.isVisaDocPageSubmitted;
                Applicant_Info__c tapp = controller.appCurrent;
                Boolean t1 = controller.DoctorFormReviewed;
                Boolean t2 = controller.BGCFormReviewed;
                Boolean t3 =controller.SecondaryFormReviewed;
                //Boolean t4 =controller.LicenseExpires;  
                Position_Info__c t5 =controller.positionInfoSecond;
                map<integer,Person_Info__c> t6 =controller.dependentsMap;  
                Group__c t7 =controller.groupInfo; 
                String t8 =controller.locationId ;
                String t9 =controller.familyMemberId ;
                String t10 =controller.emergencyContactId;
                List<Person_Info__c> t111 =controller.comPersonInfoList;
                List<Applicant_Info__c> t121 =controller.AppListGeneral;
                
                Position__c t131 = controller.posInfo ;
                String t141 = controller.did ;
                
                Boolean t151 = controller.SOR ;
                String t161 = controller.EssayNarrative;
                String t171 = controller.EssayLabel;    
                Blob t181 = controller.body;
                String t191 = controller.contentType;
                String t112 = controller.fileName;
                string t122 = controller.strPersonInfoFirstName;
                string t132 = controller.strPersonInfoLastName;
                string t142 = controller.strPersonInfoEmail;
                String t152 = controller.responseXML;
                String t162 = controller.essayId;
                String t172 = controller.env;
                String t182 = controller.edu_id;
                String t192 = controller.retParam ;
                String t103 = controller.idNeeded; 
                
                String t113 = controller.awsWebBaseUrl;
                String t123 = controller.uploadDocDescription ;
                boolean t133 = controller.isTestExecution ;
                String t143 = controller.selectedServiceLevel ;
                List<String> t153 = controller.listProgramCategories ;
                String t163 = controller.rtmpUrlVideo ;
                Component.Apex.OutputLabel t131a = controller.getLabelPrice('Hi');
                Boolean t173 = controller.ETR;
                // IGI App 2.0 Variables
                string t183 = controller.citizen;
                string t193 = controller.currently_studying;
                string t104 = controller.faculty_led_program;
                string t114 = controller.igi_Visa_Status;
                string t124 = controller.one_year_exp;
                string t134 = controller.five_years_exp;
                string t144 = controller.countryOfInterestSelected;
                list<SelectOption> t154 = controller.countryOfInterestList;
                string t164 = controller.paid_internship;
                string t174 = controller.paid_internshipSecond;
                    
                Document t184 = controller.document;
                Intrax_Program_Upload__c t194 = controller.documentnew;
                String t105 = controller.nextPage;
                String t115 = controller.reDirectPage;
                String t125 = controller.view ;
                String t135 = controller.eduid;
                AppEngine_Controller t145 = controller.getAEC();
                controller.updateApplicantInfo();
                string t155 = controller.getDefaultIP();
                pageReference t165 = controller.validator();
                pageReference t175 = controller.PPvalidator();
                PageReference t185 = controller.getPageA();
                PageReference t194a = controller.getPageTeaRecFin();
                PageReference t106 = controller.getPageStuRecFin();
                PageReference t116 = controller.ProceedSubmit();
                
                 list<dsfs__DocuSign_Recipient_Status__c> t126 = controller.docusRecipientList;
                 dsfs__DocuSign_Recipient_Status__c t136 = controller.docusUserRec2AD;
                 List<Person_Info__c> t146 = controller.personEmergencyList ;
                 Account t156 = controller.personaccount;
                 Opportunity t166 = controller.opportunity;
                 Account t176 = controller.appAccount;
                 String t186 = controller.DescriptionCoupon;  
                 String t196 = controller.refUrl ;
                 String t107 = controller.vstate ;
                 String t117 = controller.swimParam ;
                 String t127 = controller.phyParam ;
                 String t137 = controller.bgcParam ;
                 String t147 = controller.driveParam ;
                 String t157 = controller.Proofparam ;
                 String t167 = controller.mediaparam ;
                 String t177 = controller.apchf_mediaparam ;
                 String t187 = controller.Transcriptsparam ;
                 String t197 = controller.Passportparam ;
                 String t108 = controller.Videoparam ;
                 String t118 = controller.ProgramType ;
                 string t128 = controller.EducationId;
                 String t138 = controller.returnURL ;
                 Map<String, Intrax_Program_Upload__c> t148 = controller.MapPhotoAlbum ;
                 Integer t158 = controller.MapAlbumSize ;
                 Map<String, Intrax_Program_Upload__c> t168 = controller.MapPTVideo ;
                 Map<String ,Map<String, Intrax_Program_Upload__c>> t178 = controller.MapPTVideoThumb ;
                 Integer t188 = controller.MapVideoSize ;
                 String t198 = controller.igiMediaParam;
                 String t109 = controller.igiDocsParam;
                 String t119 = controller.igiDepsParam;
                 Integer t129 = controller.NumberOfChild;
                 List<Experience_Detail__c>  t139 = controller.experDetails ;
                 Boolean t149 = controller.addsibling;
                 List<PriceBookEntry> t159 = controller.standartFeeApc;
                 Boolean t169 = controller.promoCode ;
                 List<SelectOption> t179 = controller.getpromoCodecheck();
                 String t189 = controller.expireMonth ;
                 String t199 = controller.expireYear ;
                 String t200 = controller.maskCCNumber ;
                 String t210 = controller.paymentId ;
                 String t220 = controller.AuPairPref ;
                 PageReference t230 = controller.sendAppToReview();
                 List<SelectOption> t240 = controller.getCertificationType();
                 controller.syncAPCHFtoPT();
                 String t250 = controller.getAPCPtName();
                 PageReference t260 = controller.skipPage();
                 string t270 = controller.MailingStreet;
                 string t280 = controller.MailingStreet2;
                 string t290 = controller.MailingCity;
                 string t201 = controller.MailingState;
                 string t211 = controller.MailingPostalCode;
                 string t221 = controller.Country;
                 map<Integer,String> t231 = controller.potentialMatchesList ;
                 AddressValidation_Processor t241 = controller.avProcessor;
                 integer t251 = controller.addressid;
                 controller.navigateToPaymentNonEditPage();
                 String t261 = controller.paymentError;
                 controller.CloseApplicationOpp();
                 
                //Stop Test Here
                Test.stopTest();
                
            }
        }
    }
    
    
}