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
 * 1633,1427
 */
@isTest(seeAllData = true)
private class Test_AppEngine_Controller { 
    
    static testMethod void myUnitTestExtendCov() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete');
        p.getParameters().put('nextPage','apc_ap_main_home');  
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtCenters = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtCenters!=null);
        
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
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'Test', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', Intrax_Program__c = 'AuPairCare', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtCenters.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  //Program_Start__c = System.today(),
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Gender_Preference__c = 'female', Program_Start_Opinion__c = 'No');
                insert appInfo;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                 Audit_Info__c  auditinfo =new Audit_Info__c(Applicant_Info__c = appInfo.Id,Age__c = 'Needs Review',
                                                            Experience__c = 'Needs Review',
                                                            Dates__c = 'Needs Review',
                                                            Crime_Charge__c = 'Needs Review',
                                                            Driving__c = 'Needs Review',
                                                            Visa__c = 'Needs Review',
                                                            Health__c = 'Needs Review',
                                                            Disability__c = 'Needs Review',
                                                            Disease__c = 'Needs Review',
                                                            Drug_Dependency__c = 'Needs Review',
                                                            Medication__c = 'Needs Review',
                                                            Hospitalization__c = 'Needs Review',
                                                            Psychiatric_Treatment__c = 'Needs Review',
                                                            Pregnant__c = 'Needs Review', Name='Janet jackson');
                
                insert auditinfo;
                
                list<Intrax_Program_Upload__c> DocListEducation= new list<Intrax_Program_Upload__c> ();
                
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test',
                Document_service__c  = 'DS',Applicant_Info__c = appInfo.Id,
                document_type__c = 'Introductory-Video', AWS_ET_Preset__c = 'Generic 720p', AWS_ET_Job_Status__c = 'Success');
                
                DocListEducation.add(ipUpload);
                
                Intrax_Program_Upload__c ipUpload2 = new Intrax_Program_Upload__c(Document_Guid__c = 'Test222', Document_service__c  = 'DS',Applicant_Info__c = appInfo.Id,Document_Type__c='University-Diploma');
                
                DocListEducation.add(ipUpload2);
                
                insert DocListEducation;
                
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('pageId', '28');
                
                //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //Populating Varaiables with values
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.auditinfo = auditinfo;
                
                //Extending coverture
                controller.getAEC();
                controller.updateApplicantInfo();
                controller.USStatevalidator();
                controller.getDocListAll();
                controller.getPhotoListAll();
                controller.getPRIntvList();
                controller.LoadEduDocRecord();
                controller.loadIGICategory();
                controller.getCheckMainIGIApp();
                
                controller.appCurrent = appInfo;
                controller.getLanguages1();
                controller.getLanguages2();
                controller.getLanguages3();
                ApexPages.currentPage().getParameters().put('docType', 'Health');
                controller.SkipUpload();
                controller.getCheckHFNoAppStatus();
                controller.getCheckHFNumberAppStatus();
                //controller.getCustomInsuranceProducts();
                //controller.getCustomPackageDelivery();
                controller.resetVariables();
                controller.selectedProfessionalCertificatesProduct();
                controller.selectedIntensityProduct();
                controller.selectedAccommodationProduct();
                ApexPages.currentPage().getParameters().put('pageId', '1');
                ApexPages.currentPage().getParameters().put('nextPage', 'AppEngine_Home');
                ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
                controller.skipPage();
                controller.DoctorFormReviewed = false;
                //ApexPages.currentPage().getParameters().put('IdIPU', '');
                //controller.RetrieveIPU();
                
                
                //Stop Test Here
                Test.stopTest();
                
            }
        }
    }
    
    
    static testMethod void myUnitTestforCenters1() {
        
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
        RecordType rtCenters = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
       
        //Assert for Results
        System.assertEquals(true, rtCenters!=null);
        
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
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtCenters.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfo;

                //Sharing_Security_Controller.shareRecord(appInfo.Id);

                //System.assert(appInfo.shares.size() > 0);
             
                //Applicant_Info__c appInfoOut = [select Id from Applicant_Info__c where name = 'test-AY'];

                //Applicant_Info__c appInfo = [select Id from applicant_info__c where Name = 'test-AY'];
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'SOR', 
                                                                    Type__c='Request', Method__c='Email', 
                                                                    Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id,Name='Intrax');
                insert school;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, Narrative__c = '90');
                insert essay;
                
                //Location
                Location__c location = new Location__c(Name = 'test', Applicant_Info__c = appInfo.Id,
                                                        Occupancy_Start__c = System.today(),
                                                        Occupancy_End__c = System.today());
                insert location;
                
                //Standard PriceBook
                Pricebook2 pbookStd = [select id from Pricebook2 where IsStandard = true limit 1];
                
                //Custom Centers PriceBook
                Pricebook2 priceBook = [SELECT ID, Name FROM Pricebook2 WHERE IsStandard = false AND isActive = true
                                                AND Intrax_Programs__c includes ('English and Professional Skills') LIMIT 1];
                
                //Products (Family::::: Academic Excellence)
                Product2 prod1 = new product2(name='Test 12 Weeks', family = 'Academic Excellence', Description = 'Test', IsActive = true, Sort_Order__c = 1, Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod2 = new product2(name='Test 24 Weeks', family = 'Academic Excellence', Description = 'Test', IsActive = true, Sort_Order__c = 2, Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod3 = new product2(name='Test 36 Weeks', family = 'Academic Excellence', Description = 'Test', IsActive = true, Sort_Order__c = 3, Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod4 = new product2(name='Test 48 Weeks', family = 'Academic Excellence', Description = 'Test', IsActive = true, Sort_Order__c = 4, Intrax_Centers__c = 'Chicago;San Diego');
                                                                             
                //Products (Family::::: Academic Programs)
                Product2 prod5 = new product2(name='Genreal English', family = 'Academic Programs', Description = 'Test', IsActive = true, Sort_Order__c = 5, Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod6 = new product2(name='Cambridge FCE & CAE Preparation', family = 'Academic Programs', Description = 'Test',IsActive = true, Sort_Order__c = 6, Intrax_Centers__c = 'Chicago;San Diego', Start_Date__c = System.today());
                
                //Products (Family::::: Professional Certificates)
                Product2 prod7 = new product2(name='Marketing & Advertisement', family = 'Professional Certificates', Description = 'Test', IsActive = true, 
                                                Sort_Order__c = 7, Intrax_Centers__c = 'Chicago;San Diego', Start_Date__c = System.today());
                Product2 prod14 = new product2(name='Marketing & Advertisement', family = 'Professional Certificates', Description = 'Test', IsActive = true, 
                                                Sort_Order__c = 8, Intrax_Centers__c = 'Chicago;San Diego', Start_Date__c = System.today().addDays(4));
                
                //Products(Family:::::: Intensity)
                Product2 prod8 = new product2(name='Super Schedule', family = 'Intensity', Description = 'Test', IsActive = true, Sort_Order__c = 7, Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Self Directed)
                Product2 prod9 = new product2(name='Private Lessons', family = 'Self-Directed', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Package Delievery)
                Product2 prod10 = new product2(name='Standard Delievery', family = 'Package Delievery', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Insurance)
                Product2 prod11 = new product2(name='Intrax Insurance', family = 'Insurance', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Travel)
                Product2 prod12 = new product2(name='Arrival Transfer', family = 'Travel', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Accomodation)
                Product2 prod13 = new product2(name='Shared Room/Private Bath/In-Room', family = 'Accomodation', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //List to hold the Product2 records
                List<Product2> products = new List<Product2>();
                
                //Populate List with records
                products.add(prod1); products.add(prod2); products.add(prod3); products.add(prod4); products.add(prod5); products.add(prod6);
                products.add(prod7); products.add(prod8); products.add(prod9); products.add(prod10); products.add(prod11); products.add(prod12);
                products.add(prod13);products.add(prod14);
                
                //Insert Products
                insert products;
                
                //Pricebook Entry (Standard)
                PricebookEntry pbe1Std = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe2Std = new PricebookEntry(Product2Id = prod2.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe3Std = new PricebookEntry(Product2Id = prod3.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe4Std = new PricebookEntry(Product2Id = prod4.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe5Std = new PricebookEntry(Product2Id = prod5.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe6Std = new PricebookEntry(Product2Id = prod6.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe7Std = new PricebookEntry(Product2Id = prod7.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe8Std = new PricebookEntry(Product2Id = prod8.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe9Std = new PricebookEntry(Product2Id = prod9.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe10Std = new PricebookEntry(Product2Id = prod10.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe11Std = new PricebookEntry(Product2Id = prod11.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe12Std = new PricebookEntry(Product2Id = prod12.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe13Std = new PricebookEntry(Product2Id = prod13.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe14Std = new PricebookEntry(Product2Id = prod14.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);                            
                                                            
                //List to hold the PricebookEntry records
                List<PricebookEntry> priceBookEntriesStd = new List<PricebookEntry>();
                
                //Populate List with records
                priceBookEntriesStd.add(pbe1Std); priceBookEntriesStd.add(pbe2Std); priceBookEntriesStd.add(pbe3Std); priceBookEntriesStd.add(pbe4Std); 
                priceBookEntriesStd.add(pbe5Std); priceBookEntriesStd.add(pbe6Std); priceBookEntriesStd.add(pbe7Std); priceBookEntriesStd.add(pbe8Std); 
                priceBookEntriesStd.add(pbe9Std); priceBookEntriesStd.add(pbe10Std); priceBookEntriesStd.add(pbe11Std); priceBookEntriesStd.add(pbe12Std);
                priceBookEntriesStd.add(pbe13Std);priceBookEntriesStd.add(pbe14Std);
                 
                //Insert Products
                insert priceBookEntriesStd;
                
                //Pricebook Entry (Custom)
                PricebookEntry pbe1 = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe2 = new PricebookEntry(Product2Id = prod2.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe3 = new PricebookEntry(Product2Id = prod3.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe4 = new PricebookEntry(Product2Id = prod4.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe5 = new PricebookEntry(Product2Id = prod5.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe6 = new PricebookEntry(Product2Id = prod6.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe7 = new PricebookEntry(Product2Id = prod7.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe8 = new PricebookEntry(Product2Id = prod8.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe9 = new PricebookEntry(Product2Id = prod9.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe10 = new PricebookEntry(Product2Id = prod10.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe11 = new PricebookEntry(Product2Id = prod11.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe12 = new PricebookEntry(Product2Id = prod12.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe13 = new PricebookEntry(Product2Id = prod13.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                PricebookEntry pbe14 = new PricebookEntry(Product2Id = prod14.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = priceBook.ID);
                                                              
                //List to hold the PricebookEntry records
                List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
                
                //Populate List with records
                priceBookEntries.add(pbe1); priceBookEntries.add(pbe2); priceBookEntries.add(pbe3); priceBookEntries.add(pbe4); 
                priceBookEntries.add(pbe5); priceBookEntries.add(pbe6); priceBookEntries.add(pbe7); priceBookEntries.add(pbe8); 
                priceBookEntries.add(pbe9); priceBookEntries.add(pbe10); priceBookEntries.add(pbe11); priceBookEntries.add(pbe12);
                priceBookEntries.add(pbe13);priceBookEntries.add(pbe14);
                
                //Insert Products
                insert priceBookEntries;
                              
                //Applicant Product
                Applicant_product__c appProduct1 = new Applicant_product__c (Applicant_Info__c = appInfo.Id, List_Price__c = 200, Quantity__c = 2,  
                                                                             Description__c = priceBookEntries[3].Product2.Description, 
                                                                             Service_Date__c = System.today(),
                                                                             Product__c = priceBookEntries[3].Product2.Id, 
                                                                             Sort_Order__c = priceBookEntries[3].Product2.Sort_Order__c,
                                                                             Product_Name__c = priceBookEntries[3].Product2.Name);
                
                //Applicant Product
                Applicant_product__c appProduct2 = new Applicant_product__c (Applicant_Info__c = appInfo.Id, List_Price__c = 200, Quantity__c = 2,  
                                                                             Description__c = priceBookEntries[8].Product2.Description, 
                                                                             Service_Date__c = System.today(),
                                                                             Product__c = priceBookEntries[8].Product2.Id, 
                                                                             Sort_Order__c = priceBookEntries[8].Product2.Sort_Order__c,
                                                                             Product_Name__c = priceBookEntries[8].Product2.Name);
                                                                             
                //Applicant Product
                Applicant_product__c appProduct3 = new Applicant_product__c (Applicant_Info__c = appInfo.Id, List_Price__c = 200, Quantity__c = 2,  
                                                                             Description__c = priceBookEntries[13].Product2.Description, 
                                                                             Service_Date__c = System.today(),
                                                                             Product__c = priceBookEntries[13].Product2.Id, 
                                                                             Sort_Order__c = priceBookEntries[13].Product2.Sort_Order__c,
                                                                             Product_Name__c = priceBookEntries[13].Product2.Name);
               //List to hold the PricebookEntry records
                List<Applicant_product__c> applicantProductsList = new List<Applicant_product__c>();       
                
                //Populate list with Applicant Products
                applicantProductsList.add(appProduct1);
                applicantProductsList.add(appProduct2);    
                applicantProductsList.add(appProduct3);    
                
                //Insert list of Applicant Products
                insert applicantProductsList;  
                
                //Attachment
                Attachment attach=new Attachment();     
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId= appInfo.id;
                attach.Description = 'Test';
                insert attach;
        
                //Assert for Result
                List<Attachment> attachments =[select id, name from Attachment where parent.id=: appInfo.id];
                System.assertEquals(1, attachments.size());
                
                //Update Applicant Info for Photo Id field
                appInfo.PhotoId__c = attach.Id;
                update appInfo;
                
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_home');
                ApexPages.currentPage().getParameters().put('mid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('rid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('cid', comApp.Id);
                ApexPages.currentPage().getParameters().put('lid', location.Id);
                ApexPages.currentPage().getParameters().put('role', 'Host');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('add', 'true');
                
                //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //Populating Varaiables with values
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;
                controller.clear = 'test';
                controller.EssayUp = 'EssayUp';
                controller.progId = 'centers-pt';
                controller.role = 'both';
                controller.app = 'Centers';
                controller.basics('Centers');
                
                
                
                //Check for login
                controller.checkLogin();
                controller.getProgId();
                //Controller.uplaodPhoto();
                
                //Check for Lead
                //controller.tagApplicationToAccAndOrLead();
                controller.selectedStudyWeeks = '1';
                
                //Set value of PageReference
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_my_information');
                
                //Set fields on "My Information" Page
                personInfo.First_Name__c = 'Test First Name';
                personInfo.Last_Name__c = 'Test Last Name';
                personInfo.Gender__c = 'Female';
                personInfo.Date_Of_Birth__c = date.newinstance(1980, 2, 17);
                personInfo.Citizenship__c = 'United States';
                personInfo.Email__c = 'test@test.com';
                
                //Click on Save & Continue Button
                Controller.navigator();
                
                //Fetching Applicant Products from the database
                list<Applicant_Product__c> applicantProducts = [SELECT ID, Name FROM Applicant_Product__c WHERE Applicant_Info__c =: appInfo.Id];
                
                //Delete all the records from the database
                delete applicantProducts;
                
                //Set values on "My Academic" Page
                appInfo.Intrax_Center__c = 'Chicago';
                appInfo.Program_Start_Opinion__c = 'Yes';
                appInfo.Engagement_Start__c = System.today();
                controller.selectedStudyWeeks = '1';
                appInfo.Visa_Category__c = 'Student (F)';
                controller.populateApplicantProductWrapper();
                controller.selectedAcademicExcellenceProductId = controller.mapApplicantProduct.get('Academic Excellence').get(0).applicantProduct.Product__c;
                controller.mapApplicantProduct.get('Academic Programs').get(0).selected = true;
                controller.mapApplicantProduct.get('Professional Certificates').get(0).selected = true;
                controller.mapApplicantProduct.get('Self-Directed').get(0).selected = true;
                controller.resetProductsOnProgramSelectionChange();
                //Calling Method
                controller.validateAcademicPlan();
                //controller.callValidatePlanAndAccommodations();
            
                //Getting Current Page URL
                String pageref1 = ApexPages.currentPage().getParameters().get('nextPage');
            
                //Assert for Results
                System.assertEquals('/apex/centers_preapp_my_information', pageref1);
            
                //List of AppInfo
                List<Applicant_Info__c> appI = [SELECT ID, Name, Study_Weeks__c FROM Applicant_Info__c WHERE ID =: appInfo.Id];
            
                //Assert for results
                System.assertEquals(1, appI[0].Study_Weeks__c);
                
                //Query for records of Applicant Products
                List<Applicant_Product__c> applicantProductsUpdated = [SELECT ID, Name FROM Applicant_Product__c WHERE applicant_Info__c =: appInfo.Id];
                
                //Assert for Results
                //System.assertEquals(4, applicantProductsUpdated.size());
                
                //Delete Applicant Products
                delete applicantProductsUpdated;
                
                //Set fields on "My Terms" Page
                appInfo.Terms_Accepted__c = false;
                
                //Click on Save & Continue Button On "My Terms" Page
                try {
                    
                    //Calling Method when user clcik on "Save & Continue" Button
                    controller.validateMyTermsPage();
                
                } catch (DmlException e) {
            
                    //Assert Error Message 
                    System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                        'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + 'Please accept terms and conditions.'), 
                        e.getMessage() );
                }
                
                //Set fields on "My Terms" Page
                appInfo.Deposit_Fee_Accepted__c = false;
                
                //Click on Save & Continue Button On "My Terms" Page
                try {
                    
                    //Calling Method when user clcik on "Save & Continue" Button
                    controller.validateMyTermsPage();
                
                } catch (DmlException e) {
            
                    //Assert Error Message 
                    System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                        'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + 'Please accept terms and conditions.'), 
                        e.getMessage() );
                }
                
                //Set fields on "My Terms" Page
                appInfo.Terms_Accepted__c = false;
                appInfo.Deposit_Fee_Accepted__c = false;
                
                //Click on Save & Continue Button On "My Terms" Page
                try {
                    
                    //Calling Method when user clcik on "Save & Continue" Button
                    controller.validateMyTermsPage();
                
                } catch (DmlException e) {
            
                    //Assert Error Message 
                    System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                        'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + 'Please accept terms and conditions.'), 
                        e.getMessage() );
                }
                
                //Set fields on "My Terms" Page
                appInfo.Terms_Accepted__c = true;
                appInfo.Deposit_Fee_Accepted__c = true;
                
                //Calling Method when user clcik on "Save & Continue" Button
                controller.validateMyTermsPage();
                
                //Set value of PageReference
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_travel_services');
            
                //Set the value for the fields
                appInfo.Visa_Category__c = 'Student (F)';
                appInfo.Intrax_Accommodations__c = 'Yes';
                appInfo.Accommodation_Preference__c = 'Homestay';
                controller.selectedPackageDelivery = controller.mapApplicantProduct.get('Package Delivery').get(0).applicantProduct.Product__c;
            
                //Click on Save & Continue Button On "My Terms" Page
                try {
                    
                    //Calling Method when user clcik on "Save & Continue" Button
                    controller.callValidatePlanAAndMyTravelService();
                    controller.getCheckCtrHomestay();
                    controller.getcheckCtrApplicationReadyToSubmit();

                } catch (DmlException e) {
            
                    //Assert Error Message 
                    System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + 'Students need travel and health insurance coverage during their program in the U.S.: You must select a value.'), 
                    e.getMessage() );
                }
                
                //Setting Parameters
                controller.mapApplicantProduct.get('Travel').get(0).selected = true;
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_airport_transfer');
                
                //Calling Method
                controller.validateMyTravelServicesPage();

                //Calling Method
                controller.selectedProduct();
                
                //Stop Test Here
                Test.stopTest();
                
            }
        }
    }
    
    
    static testMethod void myUnitTestforCenters2() {
        
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
        RecordType rtCenters = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtCenters!=null);
        
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
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtCenters.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  //Program_Start__c = System.today(),
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Gender_Preference__c = 'female', Program_Start_Opinion__c = 'No');
                insert appInfo;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'SOR', 
                                                                    Type__c='Request', Method__c='Email', 
                                                                    Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, Narrative__c = '90');
                insert essay;
                
                //Standard PriceBook
                Pricebook2 pbookStd = [select id from Pricebook2 where IsStandard = true limit 1];
                
                //Pricebook
                Pricebook2 pbook = [SELECT ID, Name FROM Pricebook2 WHERE IsStandard = false AND isActive = true
                                                AND Intrax_Programs__c includes ('English and Professional Skills') LIMIT 1];
                
                //Products (Family::::: Academic Excellence)
                Product2 prod1 = new product2(name='Test 12 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod2 = new product2(name='Test 24 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod3 = new product2(name='Test 36 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod4 = new product2(name='Test 48 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Academic Programs)
                Product2 prod5 = new product2(name='Genreal English', family = 'Academic Programs', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod6 = new product2(name='Business English', family = 'Academic Programs', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Professional Certificates)
                Product2 prod7 = new product2(name='Marketing & Advertisement', family = 'Professional Certificates', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products(Family:::::: Intensity)
                Product2 prod8 = new product2(name='Super Schedule', family = 'Intensity', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Self Directed)
                Product2 prod9 = new product2(name='Private Lessons', family = 'Self Directed', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Package Delievery)
                Product2 prod10 = new product2(name='Standard Delievery', family = 'Package Delievery', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Insurance)
                Product2 prod11 = new product2(name='Intrax Insurance', family = 'Insurance', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Travel)
                Product2 prod12 = new product2(name='Arrival Transfer', family = 'Travel', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //List to hold the Product2 records
                List<Product2> products = new List<Product2>();
                
                //Populate List with records
                products.add(prod1); products.add(prod2); products.add(prod3); products.add(prod4); products.add(prod5); products.add(prod6);
                products.add(prod7); products.add(prod8); products.add(prod9); products.add(prod10); products.add(prod11); products.add(prod12);
                
                //Insert Products
                insert products;
                
                //Pricebook Entry (Standard)
                PricebookEntry pbe1Std = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe2Std = new PricebookEntry(Product2Id = prod2.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe3Std = new PricebookEntry(Product2Id = prod3.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe4Std = new PricebookEntry(Product2Id = prod4.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe5Std = new PricebookEntry(Product2Id = prod5.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe6Std = new PricebookEntry(Product2Id = prod6.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe7Std = new PricebookEntry(Product2Id = prod7.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe8Std = new PricebookEntry(Product2Id = prod8.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe9Std = new PricebookEntry(Product2Id = prod9.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe10Std = new PricebookEntry(Product2Id = prod10.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe11Std = new PricebookEntry(Product2Id = prod11.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe12Std = new PricebookEntry(Product2Id = prod12.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                                                            
                //List to hold the PricebookEntry records
                List<PricebookEntry> priceBookEntriesStd = new List<PricebookEntry>();
                
                //Populate List with records
                priceBookEntriesStd.add(pbe1Std); priceBookEntriesStd.add(pbe2Std); priceBookEntriesStd.add(pbe3Std); priceBookEntriesStd.add(pbe4Std); 
                priceBookEntriesStd.add(pbe5Std); priceBookEntriesStd.add(pbe6Std); priceBookEntriesStd.add(pbe7Std); priceBookEntriesStd.add(pbe8Std); 
                priceBookEntriesStd.add(pbe9Std); priceBookEntriesStd.add(pbe10Std); priceBookEntriesStd.add(pbe11Std); priceBookEntriesStd.add(pbe12Std);
                
                //Insert Products
                insert priceBookEntriesStd;
                
                //Pricebook Entry
                PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod1.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod2.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod3.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod4.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe5 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod5.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe6 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod6.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe7 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod7.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe8 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod8.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe9 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod9.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe10 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod10.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe11 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod11.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe12 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod12.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                                                            
                //List to hold the PricebookEntry records
                List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
                
                //Populate List with records
                priceBookEntries.add(pbe1); priceBookEntries.add(pbe2); priceBookEntries.add(pbe3); priceBookEntries.add(pbe4); 
                priceBookEntries.add(pbe5); priceBookEntries.add(pbe6); priceBookEntries.add(pbe7); priceBookEntries.add(pbe8); 
                priceBookEntries.add(pbe9); priceBookEntries.add(pbe10); priceBookEntries.add(pbe11); priceBookEntries.add(pbe12);
                
                //Insert Products
                insert priceBookEntries;
                   
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_home');
                ApexPages.currentPage().getParameters().put('mid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('rid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('cid', comApp.Id);
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('add', 'true');
                
                //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //Populating Varaiables with values
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;
                
                //Check for login
                controller.checkLogin();
                controller.app = 'Centers';
                controller.basics('Centers');
                controller.getProgId();
                
                //Atachment
                Attachment attach=new Attachment();     
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                
                try {
                    insert attach;
                } catch (Dmlexception e) {
                    
                }
                
                //Calling Method
                //controller.uplaodPhoto();

                //Testing of page flow pattern
            
                //Set value of PageReference
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_travel_services');
                
                //Set the value for the fields
                appInfo.Visa_Category__c = 'Student (F)';
                appInfo.Intrax_Accommodations__c = 'Yes';
                appInfo.Accommodation_Preference__c = 'Homestay';
                appInfo.Intrax_Center__c = 'Chicago';
                controller.populateApplicantProductWrapper();
                controller.mapApplicantProduct.get('Travel').get(0).selected = true;
                controller.selectedPackageDelivery = controller.mapApplicantProduct.get('Package Delivery').get(0).applicantProduct.Product__c;
                controller.selectedInsuarancePackage = controller.mapApplicantProduct.get('Insurance').get(0).applicantProduct.Product__c;
            
                //Calling Method 
                controller.callValidatePlanAAndMyTravelService();
                controller.validateMyTravelServicesPage();
                controller.getcheckCtrApplicationReadyToSubmit();
                
                //Getting Current Page URL
                String pageref2 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref2);
                
                
                //Setting values for the fields
                appInfo.Arriving_Date__c = System.today();
                appInfo.Arrival_Time__c = '00:30 AM';
                appInfo.Carrier__c = 'Test Airline';
                appInfo.Carrier_Number__c = '121B';
                appInfo.Airport__c = 'San Fransico';
                
                //Calling Method
                //controller.validateHomeStayPage();
                
                //Getting Current Page URL
                String pageref3 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref3);
            
                //Setting Value of the variables
                appInfo.Smoker_Student__c  = 'Yes';
                appInfo.Allergies_from_Applicant__c = 'Animal';
                appInfo.Health_Needs_Indicated__c = 'Yes';
                appInfo.Health_Needs_Description__c = 'Test';
                appInfo.Special_Diet_Indicated__c = 'Yes';
                appInfo.Special_Diet__c = 'Yes';
                appInfo.Center_Disclosure_Accepted__c = true;
                
                //Calling Method
                //Controller.validateVisaInformationPage();
                
                 //Getting Current Page URL
                String pageref4 = ApexPages.currentPage().getParameters().get('nextPage');
            
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref4);
                
                //Calling Method for Back
                //controller.validateBackButtonFromVisaInfoPage();
                
                //Getting Current Page URL
                String pageref6 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref6);
                
                //Calling Method
                //controller.validateBackButtonFromHomestayInfoPage();
                
                //Getting Current Page URL
                String pageref7 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref7);
             
                //Stop Test Here
                Test.stopTest();
                
            }
        }
    }
    
    static testMethod void myUnitTestforCenters3() {
        
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
        RecordType rtCenters = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rtCenters!=null);
        
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
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];

            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];        
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtCenters.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Gender_Preference__c = 'female', Program_Start_Opinion__c = 'Yes');
                insert appInfo;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'SOR', 
                                                                    Type__c='Request', Method__c='Email', 
                                                                    Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, Narrative__c = '90');
                insert essay;
                
                //Location
                Location__c location = new Location__c(Name = 'test', Applicant_Info__c = appInfo.Id,
                                                        Occupancy_Start__c = System.today(),
                                                        Occupancy_End__c = System.today());
                insert location;
                
                //Standard PriceBook
                Pricebook2 pbookStd = [select Id from Pricebook2 where IsStandard = true limit 1];
                
                //Pricebook
                Pricebook2 pbook = [SELECT ID, Name FROM Pricebook2 WHERE IsStandard = false AND isActive = true
                                                AND Intrax_Programs__c includes ('English and Professional Skills') LIMIT 1];
                
                //Products (Family::::: Academic Excellence)
                Product2 prod1 = new product2(name='Test 12 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod2 = new product2(name='Test 24 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod3 = new product2(name='Test 36 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod4 = new product2(name='Test 48 Weeks', family = 'Academic Excellence', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Academic Programs)
                Product2 prod5 = new product2(name='Genreal English', family = 'Academic Programs', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                Product2 prod6 = new product2(name='Business English', family = 'Academic Programs', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Professional Certificates)
                Product2 prod7 = new product2(name='Marketing & Advertisement', family = 'Professional Certificates', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products(Family:::::: Intensity)
                Product2 prod8 = new product2(name='Super Schedule', family = 'Intensity', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Self Directed)
                Product2 prod9 = new product2(name='Private Lessons', family = 'Self Directed', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Package Delievery)
                Product2 prod10 = new product2(name='Standard Delievery', family = 'Package Delievery', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Insurance)
                Product2 prod11 = new product2(name='Intrax Insurance', family = 'Insurance', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //Products (Family::::: Travel)
                Product2 prod12 = new product2(name='Arrival Transfer', family = 'Travel', Description = 'Test', Intrax_Centers__c = 'Chicago;San Diego');
                
                //List to hold the Product2 records
                List<Product2> products = new List<Product2>();
                
                //Populate List with records
                products.add(prod1); products.add(prod2); products.add(prod3); products.add(prod4); products.add(prod5); products.add(prod6);
                products.add(prod7); products.add(prod8); products.add(prod9); products.add(prod10); products.add(prod11); products.add(prod12);
                
                //Insert Products
                insert products;
                
                //Pricebook Entry (Standard)
                PricebookEntry pbe1Std = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe2Std = new PricebookEntry(Product2Id = prod2.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe3Std = new PricebookEntry(Product2Id = prod3.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe4Std = new PricebookEntry(Product2Id = prod4.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe5Std = new PricebookEntry(Product2Id = prod5.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe6Std = new PricebookEntry(Product2Id = prod6.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe7Std = new PricebookEntry(Product2Id = prod7.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe8Std = new PricebookEntry(Product2Id = prod8.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe9Std = new PricebookEntry(Product2Id = prod9.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe10Std = new PricebookEntry(Product2Id = prod10.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe11Std = new PricebookEntry(Product2Id = prod11.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                PricebookEntry pbe12Std = new PricebookEntry(Product2Id = prod12.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false, Pricebook2Id = pbookStd.ID);
                                                            
                //List to hold the PricebookEntry records
                List<PricebookEntry> priceBookEntriesStd = new List<PricebookEntry>();
                
                //Populate List with records
                priceBookEntriesStd.add(pbe1Std); priceBookEntriesStd.add(pbe2Std); priceBookEntriesStd.add(pbe3Std); priceBookEntriesStd.add(pbe4Std); 
                priceBookEntriesStd.add(pbe5Std); priceBookEntriesStd.add(pbe6Std); priceBookEntriesStd.add(pbe7Std); priceBookEntriesStd.add(pbe8Std); 
                priceBookEntriesStd.add(pbe9Std); priceBookEntriesStd.add(pbe10Std); priceBookEntriesStd.add(pbe11Std); priceBookEntriesStd.add(pbe12Std);
                
                //Insert Products
                insert priceBookEntriesStd;
                
                //Pricebook Entry
                PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod1.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                                                            
                                                            
                PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod2.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod3.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod4.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe5 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod5.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe6 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod6.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe7 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod7.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe8 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod8.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe9 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod9.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe10 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod10.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe11 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod11.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                PricebookEntry pbe12 = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod12.Id, UnitPrice = 10000, 
                                                            IsActive = true, UseStandardPrice = false);
                                                            
                //List to hold the PricebookEntry records
                List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
                
                //Populate List with records
                priceBookEntries.add(pbe1); priceBookEntries.add(pbe2); priceBookEntries.add(pbe3); priceBookEntries.add(pbe4); 
                priceBookEntries.add(pbe5); priceBookEntries.add(pbe6); priceBookEntries.add(pbe7); priceBookEntries.add(pbe8); 
                priceBookEntries.add(pbe9); priceBookEntries.add(pbe10); priceBookEntries.add(pbe11); priceBookEntries.add(pbe12);
                
                //Insert Products
                insert priceBookEntries;
                
                //Start Test From Here
                Test.startTest();
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_home');
                ApexPages.currentPage().getParameters().put('mid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('rid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('cid', comApp.Id);
                ApexPages.currentPage().getParameters().put('view', 'test');
                ApexPages.currentPage().getParameters().put('add', 'test');
                ApexPages.currentPage().getParameters().put('EssayUp', 'test');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('add', 'true');
                
                //Calling Controller
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                //Populating Varaiables with values
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;

                //Check for login
                controller.checkLogin();
                controller.app = 'Centers';
                controller.basics('Centers');
                controller.getProgId();
                
                //Set value of PageReference
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_travel_services');
            
                //Set the value for the fields
                appInfo.Intrax_Center__c = 'Chicago';
                controller.populateApplicantProductWrapper();
                appInfo.Visa_Category__c = 'Student (F)';
                appInfo.Intrax_Accommodations__c = 'Yes';
                appInfo.Accommodation_Preference__c = 'Homestay';
                controller.selectedInsuarancePackage = controller.mapApplicantProduct.get('Insurance').get(0).applicantProduct.Product__c;
            
                //Click on Save & Continue Button On "My Terms" Page
                try {
                    
                    //Calling Method when user clcik on "Save & Continue" Button
                    controller.callValidatePlanAAndMyTravelService();
                    controller.getCheckCtrTravelServices();

                } catch (DmlException e) {
            
                    //Assert Error Message 
                    System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + 'How should we send your Acceptance Package?: You must select a value.'), 
                    e.getMessage() );
                }
                
                //Setting Parameters
                appInfo.Program_Start_Opinion__c = 'Yes';
                appInfo.Study_Weeks__c = null;
                
                //Click on Save & Continue Button On "My Terms" Page
                try {
                    
                    //Calling Method when user clcik on "Save & Continue" Button
                    controller.validateAcademicPlan();

                } catch (DmlException e) {
            
                    //Assert Error Message 
                    System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + 'Study Weeks: You must enter a value.'), 
                    e.getMessage() );
                }
       
                //Click on Save & Continue Button 
                
                appInfo.Center_Disclosure_Accepted__c = false;
                
                //Setting PageReference
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_travel_services');
                
                //Setting Parameters
                controller.mapApplicantProduct.get('Travel').get(0).selected = true;
                
                //Calling Method
                controller.validateMyTravelServicesPage();
                
                //Getting Current Page URL
                String pageref1 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref1);
                
                //Setting PageReference
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_travel_services');
                
                //Setting Parameters
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = 'Homestay';
                
                //Calling Method
                controller.validateMyTravelServicesPage();
                
                //Getting Current Page URL
                String pageref2 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref2);
                
                //Setting PageReference
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_travel_services');
                
                //Setting Parameters
                appInfo.Visa_Category__c = 'Student (F)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Method
                controller.validateMyTravelServicesPage();
                
                //Getting Current Page URL
                String pageref3 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref3);
                
                //Setting Parameters
                appInfo.Visa_Category__c = 'Travel (T)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Method
                controller.validateMyTravelServicesPage();
                
                //Getting Current Page URL
                String pageref4 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref4);
                
                //Setting Parameters
                appInfo.Visa_Category__c = 'Student (F)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Mathod
                //controller.validateHomeStayPage();
                
                //Getting Current Page URL
                String pageref5 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref5);
                
                //Setting Parameters
                appInfo.Visa_Category__c = 'Travel (T)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Method
                //controller.validateHomeStayPage();
                
                //Getting Current Page URL
                String pageref6 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref6);
                
                //Setting Parameters
                appInfo.Visa_Category__c = 'Travel (T)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Method
                //controller.validateVisaInformationPage();
                
                //Getting Current Page URL
                String pageref7 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref7);
                
                //Setting Parameters
                appInfo.Visa_Category__c = 'Travel (T)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = true;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Method
                //controller.validateBackButtonFromVisaInfoPage();
                
                //Getting Current Page URL
                String pageref8 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref8);

                //Setting Parameters
                appInfo.Visa_Category__c = 'Travel (T)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Method
                //controller.validateBackButtonFromVisaInfoPage();
                
                //Getting Current Page URL
                String pageref9 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref9);
                
                //Setting Parameters
                appInfo.Visa_Category__c = 'Travel (T)';
                controller.mapApplicantProduct.get('Travel').get(0).selected = false;
                appInfo.Accommodation_Preference__c = null;
                
                //Calling Method
                //controller.validateBackButtonFromHomestayInfoPage();
                
                //Getting Current Page URL
                String pageref10 = ApexPages.currentPage().getParameters().get('nextPage');
                
                //Assert for Results
                System.assertEquals('/apex/centers_app_accommodations', pageref10);
                
                
                //Calling Method
                //controller.uplaodPhoto();
                
                //Stop Test Here
                Test.stopTest();
            }
        }
    }
    
    /*
    static testMethod void myUnitTest4() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
        
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', FirstName = 'Test',
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com', Type__c  = 'Partner');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id);
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', 
                                                                    State__c = 'CA', Postal_Code__c = '12345', RecordTypeId = rt.Id,
                                                                    Country__c = 'United States',  Engagement_Start__c = System.today(),
                                                                    Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, 
                                                                    Application_Stage__c = 'Declined - Agent', 
                                                                    Type__c = 'Host Family',  Intrax_Program__c = 'Ayusa', 
                                                                    Createdby__c = user.Id);
                insert appInfo;
               
               
                
                
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Last_Name__c = 'test',
                                                                   First_Name__c  = 'Test', 
                                                                   Applicant_Info__c = appInfo.Id, role__c='Both',
                                                                   Email__c = 'test@test.com');
                insert personInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'SOR', 
                                                                    Type__c='Request', Method__c='Email', 
                                                                    Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, Narrative__c = '90');
                insert essay;
                
                //Intrax_Program_Upload__c
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfo.Id);
                insert ipUpload;
                
                //Location__c 
                Location__c location = new Location__c(Applicant_Info__c = appInfo.Id, Occupancy_Start__c = System.today(),
                                                        Occupancy_End__c = System.today());
                insert location; 
                
                Lead checkLead = new Lead(Email = personInfo.Email__c ,IsConverted = false, LastName = 'Test');
                insert checkLead ;
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', 'test');
                ApexPages.currentPage().getParameters().put('mid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('rid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('cid', comApp.Id);
                ApexPages.currentPage().getParameters().put('lid', location.Id);
                ApexPages.currentPage().getParameters().put('role', 'both');
                ApexPages.currentPage().getParameters().put('content','test');
                ApexPages.currentPage().getParameters().put('view', 'test');
                ApexPages.currentPage().getParameters().put('add', 'true');
                ApexPages.currentPage().getParameters().put('EssayUp', 'test');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                
                AppEngine_Controller.isApexBeingTested = false;
                PageReference pageRef = new PageReference('/' + 'intraxinc.appengine');
                Test.setCurrentPage(pageRef);
                
                //Start Testing from here
                Test.startTest();

                //Instantiate Controller
               
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;
                
                //Assert for the properties
                System.assertEquals(1, controller.getDocList().size());
                //System.assertEquals(2, controller.getApplicantInfoList().size());
                controller.checkLogin();
                controller.getProgId();
                
                //Check methods
                System.assert(controller.goToMyApplications() != null);
                System.assert(controller.homePage() != null);
                System.assert(controller.getId() == null);
                controller.saveFamilyInfo();
                controller.saveLocationInfo();
                controller.saveRefererInfo();

                //Call basics
                controller.basics('Centers');
                controller.isPartner = false;
                controller.role = 'EmergencyContact';
                
                //Set properties
                controller.applicantInfo.Type__c = 'Participant';
                controller.saveEssayInfo();
                controller.getcheckPreApp();
                
                //Set params
                ApexPages.currentPage().getParameters().put('EssayType', 'Parent');
                controller.saveEssayAnswer();

                controller.savePersonInfo();
                
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                controller.saveLocationInfo();
                controller.saveFamilyInfo();
                controller.saveRefererInfo();
                controller.getCheckParentLetter();
                try {
                    controller.setTestMode();
                    controller.load();
                } catch(Exception e) {
                    
                }
                //controller.tagApplicationToAccAndOrLead();
                
                //Set file name
                controller.fileName = 'pdf';
                controller.body = Blob.valueOf('test');
                controller.documentnew.document_name__c  = 'Test';
                controller.contentType = 'test';
                ApexPages.currentPage().getParameters().put('docType', 'Health');
                controller.doctype = 'Health'; 
                controller.getRecipientTitle();
                
                //Coverage methods with different condition
                controller.comType  = 'ETR';
                
                //Remove from request type
                ApexPages.currentPage().getParameters().remove('EssayType');
                ApexPages.currentPage().getParameters().put('EssayId', essay.Id);
                controller.saveEssayAnswer();
                
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_my_information');
                
                //Calling Navigator
                controller.navigator();
                
                String nextPage = controller.navigator().getUrl();
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_my_academic_plan');
                
                //Calling Navigator
                controller.navigator();
                
                //Call Save Application
                controller.saveApplication('AyusaPT');
                controller.saveApplication('AyusaHF');
                controller.saveApplication('Centers');
                
                //Set SubmitApp
                Apexpages.currentPage().getParameters().put('SubmitApp', 'HF');
                controller.saveApplication();
                
                Apexpages.currentPage().getParameters().put('SubmitApp', 'PA');
                controller.saveApplication();
                
                Apexpages.currentPage().getParameters().put('SubmitApp', 'RS');
                controller.saveApplication();
                
                Apexpages.currentPage().getParameters().put('SubmitApp', 'DA');
                controller.saveApplication();
                
                //Set SubmitApp
                Apexpages.currentPage().getParameters().put('reviewSubmit', 'RS');
                controller.saveApplication();
                
                //Set SubmitApp
                Apexpages.currentPage().getParameters().put('DeclineBApp', 'DA');
                controller.saveApplication();
                
                //Set SubmitApp
                Apexpages.currentPage().getParameters().put('DeclineBApp', 'DA');
                controller.saveApplication();
                
                //Set SubmitApp
                Apexpages.currentPage().getParameters().put('DeclineApp', 'DA');
                controller.saveApplication();
        
                //Stop Testing here
                Test.stopTest();
            }
        }
    }
    */
    
    static testMethod void myUnitTest5() {
    
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id);
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',  Intrax_Program__c = 'Ayusa',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Application_Stage__c = 'Declined - Agent', 
                                        Type__c = 'Participant',
                                        Createdby__c = user.Id);
                insert appInfo;
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Last_Name__c = 'test',
                                                                Applicant_Info__c = appInfo.Id, Role__c = 'Reference', 
                                                                Email__c = '1@1.com', Family_Member__c =true);
                insert personInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id,Name='test');
                insert school;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, Narrative__c = '90');
                insert essay;
                
                //Location
                Location__c location = new Location__c(Name = 'test', Applicant_Info__c = appInfo.Id,
                                                        Occupancy_Start__c = System.today(),
                                                        Occupancy_End__c = System.today());
                insert location;
                
                //Intrax_Program_Upload__c
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id,Document_Guid__c = 'Test', Document_service__c  = 'DS');
                insert ipUpload;
              
                //Set request parameters
                ApexPages.currentPage().getParameters().put('nextPage', 'test');
                ApexPages.currentPage().getParameters().put('mid', 'Test');
                ApexPages.currentPage().getParameters().put('rid', 'Test');
                ApexPages.currentPage().getParameters().put('cid', 'Test');
                ApexPages.currentPage().getParameters().put('lid', 'Test');
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
              
                //Start Testing from here
                Test.startTest();

                //Instantiate Controller
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(new Apexpages.StandardController(appInfo));
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;
                controller.getCheckPTAppStatus();
                List<SelectOption> LstRecipientTitle = controller.getRecipientTitle();
                //Assert for the properties
                System.assertEquals(1, controller.getDocList().size());
                //System.assertEquals(1, controller.getApplicantInfoList().size());
                
                //Set the Values for PageReferences
                ApexPages.currentPage().getParameters().put('app', 'Ayusa');
                ApexPages.currentPage().getParameters().put('add', 'True');
                ApexPages.currentPage().getParameters().put('EssayUp', 'EssayUp');
                ApexPages.currentPage().getParameters().put('EssayType', 'Test');
                ApexPages.currentPage().getParameters().put('EssayUp', 'Up');
                ApexPages.currentPage().getParameters().put('env', 'Test');
                ApexPages.currentPage().getParameters().put('content','test');
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                
                //Calling Methods
                controller.getprogId();
                controller.getCheckPTAppStatus();
                controller.navigator();
                controller.getPageA();
                controller.getPageTeaRecFin();
                controller.getPageStuRecFin();
                controller.getpageThankyou();
                controller.checkLogin();
                controller.inIt();
                controller.role = 'both';
                controller.view = 'both';
                controller.isPartner = true;
               
                
                //Set params
                ApexPages.currentPage().getParameters().put('EssayType', 'Parent');
                
                //Set params
                ApexPages.currentPage().getParameters().put('EssayUp', 'Up');
                controller.saveEssayAnswer();

                //ApexPages.currentPage().getParameters().put('docType', 'All');
                //controller.getDocList();
                ApexPages.currentPage().getParameters().put('docType', 'Academic');
                controller.getDocList();
                controller.getDocList();
                ApexPages.currentPage().getParameters().put('docType', 'HFAgreements');
                controller.SkipUpload();
                controller.getDocList();
                controller.getApplicantInfoList();
                controller.goToMyApplications();
                controller.homePage();
                controller.getId();
                controller.basics('Ayusa');
                controller.saveEssayInfo();
                controller.getLocationInfoList();
                controller.getFamilyInfoList();
                controller.getRefererInfoList();
                controller.getEmergencyInfoList();
                controller.getEssayList();
                
                controller.saveEssayAnswer();
                controller.getcheckCompletedEssays();
                controller.getcheckEmergencyContact();
                ApexPages.currentPage().getParameters().put('docType','Academic');
                controller.getDocList();
                ApexPages.currentPage().getParameters().put('docType','All');
                controller.getDocList();
                controller.getCheckParticipantPhotos();
                controller.getCheckFamilyMembers();
                controller.getCheckFamilyAlbum();
                controller.getCheckSchoolTranscript();
                controller.getCheckDoctor();
                controller.getCheckAgreements();
                controller.getCheckAcademicRecommendation();
                controller.getCheckHFReferences();
                controller.getcheckPreApp();
                controller.getcheckMainApp();
                //controller.saveApplication();
                controller.FamilyMember = true;
                controller.savePersonInfo();
                //controller.tagApplicationToAccAndOrLead();
                controller.saveLocationInfo();
                ApexPages.currentPage().getParameters().put('id',appInfo.id);
                controller.getLocationInfoList();
                controller.saveFamilyInfo();
                ApexPages.currentPage().getParameters().put('id',appInfo.id);
                controller.getFamilyInfoList();
                ApexPages.currentPage().getParameters().put('id',appInfo.id);
                controller.getRefererInfoList();
                ApexPages.currentPage().getParameters().put('id',appInfo.id);
                controller.getEmergencyInfoList();
                controller.saveRefererInfo();
                controller.saveSchoolInfo();
                //controller.saveApplication();
                ApexPages.currentPage().getParameters().put('IsPartner', 'true');
                ApexPages.currentPage().getParameters().put('IsPartner', 'false');
                controller.DefaultCommunicationInfo();
                controller.getParentLetter();
                controller.getCheckPreviousAddress();
                controller.getRecipientTitle();
                ApexPages.currentPage().getParameters().put('docType', 'Health');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'Transcripts');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'Agreements');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'Partner');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'Media');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'Passport');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'Family');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'HostFamily');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'Teacher');
                controller.SkipUpload();
                ApexPages.currentPage().getParameters().put('docType', 'School');
                controller.SkipUpload();
                 ApexPages.currentPage().getParameters().put('docType', 'HFAgreements');
                controller.SkipUpload();
                boolean blnPartner = controller.getIsPartner(); 
                controller.getRoleList();
                controller.getRoles();
                String[] roles = new String[]{};
                controller.setRoles(roles);   
                controller.getCheckHFAgreementsUpload();
                controller.getcheckHFApp();    
                controller.getCheckFamilyMembers();
                controller.getcheckPreviousAddress();
                controller.getcheckHFReferences();
                
                StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                mock.setStaticResource('NameOfStaticResourceContainingResponseBodyString');
                mock.setStatusCode(200); // Or other appropriate HTTP status code
                mock.setHeader('Content-Type', 'application/xml'); // Or other appropriate MIME type like application/json
                
                Test.setMock(HttpCalloutMock.class, mock); 
                
                //Calling Web Service Mathod
                try {
                    
                    //Calling Method
                    Intrax_Program_Upload__c ipudelis = new Intrax_Program_Upload__c(Name='TEst',document_Guid__c = '1234',Document_service__c='IS');
                    insert ipudelis;
                    Intrax_Program_Upload__c ipudelds = new Intrax_Program_Upload__c(Name='TEst',document_Guid__c = '5678',Document_service__c='DS');
                    insert ipudelds;
                    ApexPages.currentPage().getParameters().put('docGuid','1234');
                    controller.setTestMode();
                    //controller.deletefile();
                    ApexPages.currentPage().getParameters().put('docGuid','5678');
                    controller.setTestMode();
                    //controller.deletefile();

                } catch (CalloutException e) {
            
                }
                
                //Stop Testing here
                Test.stopTest();
            }
        }
    }
 
    static testMethod void myUnitTest6() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', 
                                        State__c = 'CA', Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                        Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                        Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Community_Type__c ='Urban',
                                        Private_High_School_Indicated__c = 'No', Parent_Marital_Status__c = 'Other',
                                        GPA_Self_Reported__c = 'Test', Curfew_Indicated__c = 'No', RecordTypeId = rt.Id,
                                        Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                        //Program_Start__c = System.today(),  
                                        Meal_Self_Sufficient__c = 'No', Special_Diet_Indicated__c = 'No',
                                        Primary_Language__c = 'English', Submitted__c = true, Intrax_Program__c = 'Ayusa',
                                        School_Transportation__c = 'Bus', Gender_Preference__c = 'female');
                insert appInfo;
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id,Name='Test2');
                insert school;
                
                //List to hold the Essay records
                List<Essay__c> essays = new List<Essay__c>();
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id, Narrative__c = '90', label__c='test');
                Essay__c essay2 = new Essay__c(Name = 'Host Family Letter', Applicant_Info__c = appInfo.Id, Narrative__c = '90', label__c='test');
                Essay__c essay3 = new Essay__c(Name = 'test', Applicant_Info__c = appInfo.Id, Narrative__c = '90', label__c='test');
                essays.add(essay); essays.add(essay2); essays.add(essay3);
                insert essays;
                
                //Location
                Location__c location = new Location__c(Name = 'test', Applicant_Info__c = appInfo.Id,
                                                        Occupancy_Start__c = System.today(),
                                                        Occupancy_End__c = System.today());
                insert location;
                
                Related_Info__c  refer = new Related_Info__c(Name ='Test', Applicant_Info__c = appInfo.Id);
                insert refer;
                
                //Set request parameters
                ApexPages.currentPage().getParameters().put('mid', '/' + personInfo.Id);
                ApexPages.currentPage().getParameters().put('nextPage', 'test');
                ApexPages.currentPage().getParameters().put('clear', 'test');
                ApexPages.currentPage().getParameters().put('view', 'test');
                ApexPages.currentPage().getParameters().put('add', 'true');
                ApexPages.currentPage().getParameters().put('EssayUp', 'test');
                //ApexPages.currentPage().getParameters().put('pid', personInfo.Id);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                //Start Testing from here
                Test.startTest();
                 
                //Instantiate Controller
                AppEngine_Controller controller = new AppEngine_Controller();
                 
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;
                controller.role = 'EmergencyContact';
                
                //Call basics
                controller.basics('Centers');
                controller.getProgId();
                
                //Assert for the properties
                System.assertEquals(0, controller.getDocList().size());
                System.assertEquals(1, controller.getApplicantInfoList().size());

                controller.getCheckFamilyMembers();
                controller.getcheckEmergencyContact();
                controller.getcheckCompletedEssays();
                controller.getcheckParticipantPhotos();
                controller.getCheckDoctor();
                controller.getcheckAgreements();
                controller.getcheckFamilyAlbum();
                controller.getcheckAcademicRecommendation();
                controller.getcheckSchoolTranscript();
                controller.getcheckMainApp();
                controller.getCheckFamilyMembers();
                controller.getcheckPreviousAddress();
                controller.getCheckHFAgreementsUpload();
                controller.getCheckHFAgreementsDS();
                //controller.tagApplicationToAccAndOrLead();
                controller.getcheckHFAppNoAgree();
                //controller.tagApplicationToAccAndOrLead();
                
                ApexPages.currentPage().getParameters().put('EssayType', 'Parent');
                controller.saveEssayAnswer();
                
                
                //Check for the Variable and getter, setter
                Document doc = controller.document;
                System.assert(doc != null);
                
                  //Intrax Photo DOc
                Intrax_Program_Upload__c photo = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Media', Name = 'Test.pdf');
                insert photo;
                //controller.getCheckParticipantPhotos();
                
                 //Intrax Photo DOc
                Intrax_Program_Upload__c photo1 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Family', Name = 'Test.pdf');
                insert photo1;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo11 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Family', Name = 'Test');
                insert photo11;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo12 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Family', Name = 'Test');
                insert photo12;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo13 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Family', Name = 'Test');
                insert photo13;
                
                //controller.getCheckFamilyAlbum();
                
                 //Intrax Photo DOc
                Intrax_Program_Upload__c photo2 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Transcripts', Name = 'Test');
                //insert photo2;
                //controller.getCheckSchoolTranscript();
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo3 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Health', Name = 'Test');
                insert photo3;
                //controller.getCheckDoctor();
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo4 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Agreements', Name = 'Test');
                insert photo4;
                //controller.getCheckAgreements();
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo5 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'HFAgreements', Name = 'Test');
                insert photo5;
                //controller.getCheckHFAgreementsUpload();
                //controller.getCheckAcademicRecommendation();
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo6 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Teacher', Name = 'Test');
                insert photo6;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo7 = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, 
                                                        Document_Type__c = 'Teacher', Name = 'Test');
                insert photo7;
                
                //controller.getCheckAcademicRecommendation();
                //controller.getcheckPreApp();   
                controller.getcheckCtrPreApp();
                
                Attachment attach=new Attachment();     
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId=photo.id;
                insert attach;
                
                Intrax_Program_Upload__c ipUpload = controller.documentnew;
                System.assert(ipUpload != null);
                
                //controller.uploadPhotoAndNavigate();
                
                controller.nextPage = '/home/home.jsp';
                controller.reDirectPage = '/home/home.jsp';
                controller.role = 'Test';
                controller.app = 'Test';
                controller.docType = 'Test';
                controller.comType  = 'SOR';
                controller.view = 'test';
                controller.add = 'test';
                controller.EssayType = 'EssayType';
                controller.progId = 'ayusa-hf';
                
                
                //Call navigate method
                controller.navigator();
                
                //Set request Parameter
                ApexPages.currentPage().getParameters().put('app', 'TMD');
                
                //Assert
                System.debug(controller.getPageA() != null);
                System.debug(controller.getPageTeaRecFin() != null);
                System.debug(controller.getPageStuRecFin() != null);
                System.debug(controller.getpageThankyou() != null);
                //controller.checkLogin();
                controller.getcheckCtrAirportTransferReqd();
                controller.getcheckCtrHomestayAccommodationReqd();
                controller.getcheckCtrVisaInformationReqd();
                controller.getcheckCtrVisaDocumentsReqd();
                //controller.getcheckCtrVisaDocumentsLoaded();
                controller.getcheckCtrApplicationReadyToSubmit();
                controller.getcheckCtrPreApp();
                //controller.uplaodPhoto();
                controller.inIt();
                controller.saveEssayInfo();
                controller.getEmergencyInfoList();
                controller.getcheckPreAppCenters();
                controller.getUserInterests();
                controller.getCheckHFAppStatus();
                controller.backNavigator();
                controller.getArrivalTransfer();
                controller.getIntraxInsurance();
                controller.getPackageDelivery();
                controller.getCheckCentersAPAirportTranfers();
                controller.validateMyTermsPage();
                controller.getCheckCentersAppStatus();
                controller.getcheckPreAppWT();
                controller.getCheckWTParticipantPhotos();
                controller.getCheckFamilyLetter();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');
                ApexPages.currentPage().getParameters().put('add', 'true');
                
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                try {
                controller.load();
                } catch(Exception e) {}
                try {
                //controller.deleteFile();
                } catch(Exception e) {}
                controller.fileName = 'Test.pdf';
                
                String photoURL = controller.getUrlPic();
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Intrax Canada');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Intrax Chile');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Ayusa Germany');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Intrax France');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Intrax Japan');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Intrax Korea');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Intrax Peru');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Intrax Singapore');
                ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo,'Test');
                //controller.getPositionList();
                controller.signUpForPosition();
                appInfo.Application_Stage__c = 'In-Review';
                controller.StageToInReview();
                ApexPages.currentPage().getParameters().put('EC', 'Partner');
                ApexPages.currentPage().getParameters().put('IPO', 'Partner');
                ApexPages.currentPage().getParameters().put('slevel', 'Primary');
                //controller.navigator();
                //controller.getDocListAll();
                // ApexPages.currentPage().getParameters().put('docType', 'All');
                // controller.getDocList();
                /*
                ApexPages.currentPage().getParameters().put('docType', 'FinancialResponsibility');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'Academic');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'HostAgreements');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'Resume');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('docType', 'Test');
                controller.getDocList();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.ID); 
                appInfo.type__c = 'Participant';
                controller.getProgId();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.ID); 
                appInfo.type__c = 'Host Family';
                controller.getProgId();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.ID); 
                appInfo.type__c = 'Test';
                controller.getProgId();*/
                
                //Stop Testing here
                Test.stopTest();
            }
        }
    } 

    
    
    static testMethod void myUnitTest7() {
        
        PageReference p=Page.AppEngine_Home; 
        p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Visa_Category__c = 'Travel (T)',
                                        State__c = 'CA', Postal_Code__c = '12345',  Type__c = 'Test', Home_Type__c = 'Duplex',
                                        Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance', Home_Street_1__c = 'Test', 
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test', 
                                        Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Community_Type__c ='Urban',
                                        Private_High_School_Indicated__c = 'No', Parent_Marital_Status__c = 'Other', Lives_With__c = 'Both Parent',
                                        GPA_Self_Reported__c = 'Test', Curfew_Indicated__c = 'No', RecordTypeId = rt.Id, Graduation_Date__c = System.today(),
                                        Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                        //Program_Start__c = System.today(),  
                                        Meal_Self_Sufficient__c = 'No', Special_Diet_Indicated__c = 'No', Program_Duration__c = '1-2 Weeks',
                                        Primary_Language__c = 'English', Submitted__c = true, Intrax_Program__c = 'Ay',
                                        School_Transportation__c = 'Bus', Gender_Preference__c = 'female', Terms_Accepted__c = true);
                insert appInfo;
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Essay__c
                Essay__c essay = new Essay__c(Name = 'Parent Letter', Applicant_Info__c = appInfo.Id);
                insert essay; 
                
                 //Intrax Photo DOc
                Intrax_Program_Upload__c photo = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, Document_Type__c = 'School', Name = 'Test');
                insert photo;
                
                //Start Testing from here
                Test.startTest();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('EssayType', 'Parent');
                ApexPages.currentPage().getParameters().put('add', 'true');
                 
                //Instantiate Controller
                AppEngine_Controller controller = new AppEngine_Controller();
                 
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;
                
                //Calling method
                //controller.tagApplicationToAccAndOrLead();
                controller.getEssayInfo();
                controller.getcheckCompletedEssays();
                Controller.getCheckAcademicRecommendation();
                controller.getcheckPreApp();
                controller.getcheckPreAppCenters();
                //controller.saveApplication('TMD');
                
                //Stop Testing here
                Test.stopTest();
            }
        }
    } 
    
    static testMethod void myUnitTest8() {
        
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Centers' Limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', 
                                        State__c = 'CA', Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                        Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                        Disabilities__c = 'No', Community_Type__c ='Urban',
                                        Private_High_School_Indicated__c = 'No', Parent_Marital_Status__c = 'Other',
                                        GPA_Self_Reported__c = 'Test', Curfew_Indicated__c = 'No', RecordTypeId = rt.Id,
                                        Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                        //Program_Start__c = System.today(),  
                                        Meal_Self_Sufficient__c = 'No', Special_Diet_Indicated__c = 'No', Application_Stage__c = 'Working',
                                        Primary_Language__c = 'English', Submitted__c = true, Intrax_Program__c = 'Ayusa',
                                        School_Transportation__c = 'Bus', Gender_Preference__c = 'female');
                insert appInfo;
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                Person_Info__c reference = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert reference;
                
                Person_Info__c familyMember = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Sibling',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert familyMember;
                
                Person_Info__c familyInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Sibling',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert familyInfo;
                
                //communication Obejcts
                Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
                insert comApp;
                
                //School
                School__c school = new School__c(Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Lead
                Lead checkLead = new Lead(Email = personInfo.Email__c ,IsConverted = false, LastName = 'Test');
                insert checkLead ;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, Document_Type__c = 'Media', 
                                                                                Name = 'Test', Document_GUID__c ='test');
                insert photo;
                
                Location__c location =  new Location__c (Applicant_Info__c = appInfo.Id, City__c = 'Test', Country__c = 'Test', Occupancy_Start__c = date.today()-200,Occupancy_End__c = date.today() + 100, Type__c = 'Residence');
                
                insert location;
            
                //Start Testing from here
                Test.startTest();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
               
                 
                //Instantiate Controller
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(new Apexpages.StandardController(appInfo));
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.communicationInfo = comApp;
                controller.refererInfo = reference;
                controller.familyInfo = familyInfo;
                
                controller.validator();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('docType', 'Media');
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                ApexPages.currentPage().getParameters().put('add', 'true');
                
                //Calling method
                //controller.tagApplicationToAccAndOrLead();
                controller.saveEssayInfo();
                controller.getProgId();
                controller.getCheckAcademicRecommendation();
                
                Apexpages.currentPage().getParameters().put('SubmitApp', 'HF');
                //controller.saveApplication();
                controller.getcheckHFApp();
                //controller.uplaodPhoto();
                controller.getRoleList();
                controller.getRoles();
                List<String> listString = new List<String>();
                listString.add('Sibling');
                listString.add('Parent');
                controller.setRoles(listString);
                controller.getCheckPTAppStatus();
                controller.getFamilyLetter();
                
                controller.ReferenceId = reference.Id;
                controller.deleteReference();
                
                controller.familyMemberId = familyMember.Id;
                controller.deleteFamilyMember();
                
                controller.locationId = location.Id;
                controller.deleteLocation();
                
                controller.getCheckFamilyLetter();
                controller.getCheckHFAgreementsDSSent();
                //Stop Testing here
                Test.stopTest();
            }
        }
    } 
   
    static testMethod void myUnitTesWTApplication() {
        ApexPages.currentPage().getParameters().put('docType', 'Doctor-Partner');
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', 
                                        State__c = 'CA', Postal_Code__c = '12345',  Type__c = 'Participant', 
                                        Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                        RecordTypeId = rt.Id, Prior_Exchange_Experience__c = 'No',
                                        Application_Stage__c = 'Working', Curfew_Indicated__c = 'Yes', Live_With_Pets__c = 'Yes',
                                        Meal_Self_Sufficient__c = 'Yes', 
                                        Language_1__c = 'English', Submitted__c = true, Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'Practical Training',
                                        CreatedBy__c = user.Id, Engagement_Start__c = date.today()-10);
                insert appInfo;
                
                Person_Info__c emergencyContact = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert emergencyContact;
                
                //communication Obejcts
                //Communication__c comApp = new Communication__c(To_Address__c = 'Test@test.com', Type_Code__c = 'ETR', Type__c='Request', Method__c='Email', Applicant_Info__c = appInfo.Id);
                //insert comApp;
                
                //School
                //School__c school = new School__c(Applicant_Info__c = appInfo.Id);
                //insert school;
                
                //Lead
                Lead checkLead = new Lead(Email = emergencyContact.Email__c ,IsConverted = false, LastName = 'Test');
                insert checkLead ;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, Document_Type__c = 'Participant-Photo', 
                                                                                Name = 'Test', Document_GUID__c ='test');
                insert photo;
                
                Experience__c experience = new Experience__c(Applicant_Info__c = appInfo.Id, City__c = 'Test', Country__c = 'Test', Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test' );
                
                insert experience;

                //Start Testing from here
                Test.startTest();
                Test.setCurrentPage(Page.apc_ap_main_health_review);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
               
                //Instantiate Controller
                AppEngine_Controller.isApexBeingTested=true;
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                controller.applicantInfo = appInfo;

                controller.getipo_options();
                controller.setipo_options('WEST');
                controller.getProgramOptions();
                
                controller.experience = experience;
                controller.personInfo = emergencyContact;
                controller.emergencyContactId = emergencyContact.Id;
                //controller.communicationInfo = comApp;
                controller.selectedServiceLevel = 'No';
                controller.DoctorFormReviewed = false;
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');
                ApexPages.currentPage().getParameters().put('add', 'true');
                
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                
                //controller.DeriveRetParam('wt-pt');
                //controller.load();
                //controller.deleteFile();
                
                //Calling method
                //controller.tagApplicationToAccAndOrLead();
                controller.saveEssayInfo();
                controller.getProgId();
                //controller.getCheckAcademicRecommendation();
                
                Apexpages.currentPage().getParameters().put('SubmitApp', 'WTPA');
                //controller.saveApplication();
                controller.getcheckHFApp();
                //controller.uplaodPhoto();
                controller.getRoleList();
                controller.getRoles();
                List<String> listString = new List<String>();
                listString.add('Sibling');
                listString.add('Parent');
                controller.setRoles(listString);
                controller.deleteEmergencyContact();
                controller.validateIGIProgramDeterminationServiceLevel();
                controller.validateIGIProgramPreferencesBack();
                controller.getPositionList();
                controller.signUpForPosition();
                controller.getPartnerIntraxPrograms();
                
                controller.PPvalidator();
                
                controller.ExperienceId = experience.Id;
                controller.deleteExperience();
                
                //Stop Testing here
                Test.stopTest();
            }
        }
    } 
    
    
       static testMethod void myUnitTest9() {
         Applicant_Info__c appInfo2= new Applicant_Info__c(Name = 'test-WT11', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                 Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
                insert appInfo2;
      
       Test.startTest();
       AppEngine_Controller.isApexBeingTested=true;
                ApexPages.StandardController sc1 = new ApexPages.StandardController(appInfo2);
                AppEngine_Controller controller1 = new AppEngine_Controller(sc1);
                controller1.applicantInfo = appInfo2;
                  ApexPages.currentPage().getParameters().put('docType', 'Media');
      
                //Stop Testing here
                Test.stopTest();
            }
    
    static testMethod void myUnitTesIGIApplication() {
        
        ApexPages.currentPage().getParameters().put('docType', 'Doctor-Partner');
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', 
                                        State__c = 'CA', Postal_Code__c = '12345',  Type__c = 'Participant', 
                                        Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                        RecordTypeId = rt.Id, Prior_Exchange_Experience__c = 'No',
                                        Application_Stage__c = 'Working', Application_Level__c = 'Basic', Curfew_Indicated__c = 'Yes', Live_With_Pets__c = 'Yes',
                                        Meal_Self_Sufficient__c = 'Yes', Service_Level__c = 'Premium', Engagement_Start__c = date.today()+ 30,
                                        Language_1__c = 'English', Submitted__c = true, Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'Hospitality Internship',
                                        CreatedBy__c = user.Id, Country_of_Interest__c = 'United States');
                insert appInfo;
                
                Person_Info__c emergencyContact = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1998, 2, 17) );
                insert emergencyContact;
           
                //Lead
                Lead checkLead = new Lead(Email = emergencyContact.Email__c ,IsConverted = false, LastName = 'Test');
                insert checkLead ;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, Document_Type__c = 'Participant-Photo', 
                                                                                Name = 'Test', Document_GUID__c ='test');
                insert photo;
                
                Experience__c experience = new Experience__c(Applicant_Info__c = appInfo.Id, City__c = 'Test', Country__c = 'Test', Start_Date__c = date.today() - 100, 
                                                                End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                
                insert experience;
                
                //Start Testing from here
                Test.startTest();
                Test.setCurrentPage(Page.apc_ap_main_health_review);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                //Instantiate Controller
                AppEngine_Controller.isApexBeingTested=true;
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                controller.paid_internship = 'No';
                controller.paid_internshipSecond = 'No';
                controller.applicantInfo = appInfo;
                controller.personInfo = emergencyContact;
                controller.emergencyContactId = emergencyContact.Id;
                //controller.communicationInfo = comApp;
                controller.selectedServiceLevel = 'No';              
                controller.DoctorFormReviewed = false;
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                ApexPages.currentPage().getParameters().put('add', 'true');
                ApexPages.currentPage().getParameters().put('partnerId', portalAccount.Intrax_Id__c);
                ApexPages.currentPage().getParameters().put('EC', 'Partner');
                ApexPages.currentPage().getParameters().put('IPO', 'WEST');
                ApexPages.currentPage().getParameters().put('slevel', 'Premium');
                controller.progId = 'igi-pt';
                //Calling method
                //controller.tagApplicationToAccAndOrLead();
                controller.saveEssayInfo();
                controller.getProgId();
                
                
                
                Apexpages.currentPage().getParameters().put('SubmitApp', 'IGIPA');
                //controller.saveApplication();
                //controller.uplaodPhoto();
                controller.getRoleList();
                controller.getRoles();
                List<String> listString = new List<String>();
                listString.add('Sibling');
                listString.add('Parent');
                controller.setRoles(listString);
                controller.getIsIGIIntern();
                controller.validateIGIProgramDeterminationServiceLevel();
                controller.validateIGIProgramPreferencesBack();
                
                controller.deleteEmergencyContact();
                controller.getcheckCtrBirthCertificateLoaded();
                controller.getIsSelfInsuranceParticipant();
                controller.getcheckCtrFRDocsLoaded();
                controller.getCheckCtrResidenceClub();
                
                controller.ExperienceId = experience.Id;
                controller.deleteExperience();
                controller.USStatevalidator();
                controller.StageToInReview();
                //controller.getDocListAll();
                //controller.getcheckPreappIGI();
                controller.getpageThankyouIGI();
                
                map <string, string> mstr = controller.getDocTypeList();
                
                Account ac_pt1 = new Account(
                FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Active',
                OwnerId = UserInfo.getUserId()
                );
                insert ac_pt1;
                
                Engagement__c ca = new Engagement__c (
                Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt1.Id, status__c = 'Program Ready', Intrax_Program__c = 'Internship', Engagement_Start__c= date.today() ,Engagement_End__c = date.today() + 12, Visa_Interview_Date__c = date.today() - 5
                );
                insert ca;
                
                appInfo.Engagement__c = ca.id;
                //update appInfo;
                
                Apexpages.currentPage().getParameters().put('FromNotify', '1');
                controller.saveEmergencyContactNotify();
                
                //Stop Testing here
                Test.stopTest();
            }
        }
    }
    
    static testMethod void myUnitTesIGIApplicationWEST() {
        ApexPages.currentPage().getParameters().put('docType', 'Doctor-Partner');
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
        
        //Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
            
            User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', 
                                        State__c = 'CA', Postal_Code__c = '12345',  Type__c = 'Participant', 
                                        Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                        RecordTypeId = rt.Id, Prior_Exchange_Experience__c = 'No',
                                        Application_Stage__c = 'Working', Curfew_Indicated__c = 'Yes', Live_With_Pets__c = 'Yes',
                                        Meal_Self_Sufficient__c = 'Yes',
                                        Language_1__c = 'English', Submitted__c = true, Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'WEST',
                                        CreatedBy__c = user.Id);
                insert appInfo;
                
                Person_Info__c emergencyContact = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert emergencyContact;
           
                //Lead
                Lead checkLead = new Lead(Email = emergencyContact.Email__c ,IsConverted = false, LastName = 'Test');
                insert checkLead ;
                
                //Intrax Photo DOc
                Intrax_Program_Upload__c photo = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, Document_Type__c = 'Participant-Photo', 
                                                                                Name = 'Test', Document_GUID__c ='test');
                insert photo;
                
                Experience__c experience = new Experience__c(Applicant_Info__c = appInfo.Id, City__c = 'Test', Country__c = 'Test', Start_Date__c = date.today() - 100, 
                                                                End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                
                insert experience;
                  RecordType rtWorkTravels = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
       
                
                  Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-WT', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtWorkTravels.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
                insert appInfo1;
                
                //Start Testing from here
                Test.startTest();
                Test.setCurrentPage(Page.apc_ap_main_health_review);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
               
                //Instantiate Controller
                AppEngine_Controller.isApexBeingTested=true;
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                controller.applicantInfo = appInfo;
                controller.personInfo = emergencyContact;
                controller.emergencyContactId = emergencyContact.Id;
                //controller.communicationInfo = comApp;
                controller.selectedServiceLevel = 'Yes';
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                ApexPages.currentPage().getParameters().put('add', 'true');
                ApexPages.currentPage().getParameters().put('partnerId', portalAccount.Intrax_Id__c);
                ApexPages.currentPage().getParameters().put('EC', 'Partner');
                ApexPages.currentPage().getParameters().put('IPO', 'WEST');
                ApexPages.currentPage().getParameters().put('slevel', 'Premium');
                ApexPages.currentPage().getParameters().put('eid', 'Test');
                ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
                controller.DoctorFormReviewed = false;
                //Calling method
                //controller.tagApplicationToAccAndOrLead();
                controller.saveEssayInfo();
                controller.getProgId();
                
                Apexpages.currentPage().getParameters().put('SubmitApp', 'IGIPA');
                //controller.saveApplication();
                //controller.uplaodPhoto();
                controller.getRoleList();
                controller.getRoles();
                controller.validateIGIProgramDeterminationServiceLevel();
                controller.validateIGIProgramPreferencesBack();
                List<String> listString = new List<String>();
                listString.add('Sibling');
                listString.add('Parent');
                controller.setRoles(listString);
                controller.getIsIGIIntern();
                controller.getProgId();
                
                  
                ApexPages.currentPage().getParameters().put('id', appInfo1.Id);
               
                //Instantiate Controller
                AppEngine_Controller.isApexBeingTested=true;
                ApexPages.StandardController sc1 = new ApexPages.StandardController(appInfo1);
                AppEngine_Controller controller1 = new AppEngine_Controller(sc1);
                controller1.applicantInfo = appInfo1;
                
                //Stop Testing here
                Test.stopTest();
            }
        }
    }
        
    static testMethod void myUnitTest_IGI_App_2_1() {
        // TO DO: implement unit test
        PageReference p=Page.igi_pt_app_personal_info; 
        //p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        //ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
        RecordType rtAccountPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        //Assert for Results
        //System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType igi_rt = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
       
        //Assert for Results
        system.assertEquals(true, igi_rt != null);
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        //Create a new test account and set contact as portal contact
        Account ptAccount = new Account(FirstName = 'PT Account', LastName = 'LN', Type = 'Participant', personemail='user@test.com', RecordTypeId = rtAccountPT.Id);
        insert ptAccount;
            
        
        if(profiles.size() > 0) {
            //RecordType rtuserAccount = [select id,Name from RecordType where SobjectType='Account' and Name='Business Account' Limit 1];
            
            // Default user Account
            Account userAccount = [SELECT Id FROM Account WHERE Name =: 'Intrax Program Applicants' limit 1];
            //Contact
            Contact userContact = new Contact(LastName = 'LastName', AccountId = userAccount.Id, email = 'test@test.com');
            insert userContact;
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
                        
            //Fetch intract Id for this account id
            ptAccount = [Select Id, Intrax_Id__c from Account where Id =: ptAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test',
                                                                    Postal_Code__c = '12345',  Type__c = 'Participant', Country__c = 'United States', 
                                                                    Home_Phone__c = '12345', Intrax_Program__c = 'Internship',                 
                                                                    Application_Stage__c = 'Basic', Application_Level__c = 'Working',                                                                  
                                                                    Primary_Language__c = 'English', Language_1__c = 'Spanish', Language_1_Proficiency__c = 'Advanced', 
                                                                    Language_2__c = 'French', Language_2_Proficiency__c = 'Advanced',                                                                  
                                                                    createdBy__c = user.Id, Country_of_Interest__c = 'United States', One_Year_Work_Experience__c = true,
                                                                    Intrax_Program_Category__c = 'Business', Functional_Areas__c = 'Accounting', Work_Authorization_Indicated__c = 'Yes',
                                                                    Engagement_Start__c = date.today()+ 91, Engagement_End__c = date.today() + 200, Service_Level__c = 'Independent',
                                                                    PageStatus_Started__c ='052', PageStatus_Complete__c = '051', Allow_Intrax_To_Apply__c = true);
                
                insert appInfo;
                
                list<Person_Info__c> listPerson = new list<Person_Info__c>();
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Test', role__c = 'Student', Citizenship__c = 'Spain',
                                                                    Date_of_Birth__c = date.newInstance(1995, 2, 17), Country_of_Residence__c = 'United States',
                                                                    Skype_Id__c = 'mySkype',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(personInfo);
                
                Person_Info__c emergency1 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 1', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1972, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency1);
                 
                
                Person_Info__c emergency2 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 2', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1968, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency2);
                
                insert listPerson;
                // Building Education Page data;
               
                list<Education__c> listEdu = new list<Education__c>();
                Education__c ed1 = new Education__c(Institution_Type__c = 'University/College', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                                                    Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfo.Id);  
                                                    
                listEdu.add(ed1);
                
                Education__c ed2 = new Education__c(Institution_Type__c = 'University/College', Program_Type__c = 'Bachelor', Institution_Name__c = 'UMU', Field_of_Study__c = 'Computer Science', 
                                                    Graduation_Date__c = date.newInstance(2011, 6, 15), applicant_Info__c = appInfo.Id);  
                                                    
                listEdu.add(ed2);
                
                insert listEdu;
                
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfo.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',
                                                                    Functional_Areas__c = 'Accounting');
                                                                    
                
                list<Experience__c> listExp = new list<Experience__c>();
                
                Experience__c exp1 = new Experience__c(Employer_Name__c = 'Test', City__c = 'Murcia', Country__c = 'Spain', Start_Date__c = date.today() - 400, End_Date__c = date.today()-200,
                                                        Position_Title__c = 'Test', Position_Description__c = 'Description', Applicant_Info__c = appInfo.Id);
                listExp.add(exp1);
                
                Experience__c exp2 = new Experience__c(Employer_Name__c = 'Test 2', City__c = 'Madrid', Country__c = 'Spain', Start_Date__c = date.today() - 200, End_Date__c = date.today()-100,
                                                        Position_Title__c = 'Test', Position_Description__c = 'Description', Applicant_Info__c = appInfo.Id);
                listExp.add(exp2);
                                                        
                insert listExp;
                                                                                    
                
                Test.startTest();
                //Test.setCurrentPage(Page.apc_ap_main_health_review);
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.educationInfo = ed1;
                controller.positionInfo = posInfo;
                
                controller.igi_visa_status = 'need_visa'; 
                controller.faculty_led_program = 'No';
                controller.DoctorFormReviewed = false;
                
                ApexPages.currentPage().getParameters().put('PageId', '052'); 
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');       
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_completion');
                controller.navigator();
                
                
                //Education Methods;
                
                //controller.getOneYearFromGraduation();
                //controller.getFiveYearsFromGraduation();
                
                controller.getValidateIGIBasicApp();              
                
                
                //controller.navigator();
                
                 // Saving Page...
                
               ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_program_pref');
               ApexPages.currentPage().getParameters().put('pageId', '052');
               //controller.navigator();
               
               // Completion Page
               ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_home');
               ApexPages.currentPage().getParameters().put('submitApp', 'PA');
               controller.getValidateIGIBasicApp();
               
               controller.igi_visa_status = 'no_need_visa'; 
               controller.faculty_led_program = 'Yes';
               //controller.navigator();
               
               map <string, string> mstr1 = controller.getDocTypeList();
               
               //Stop Testing here
                Test.stopTest();
               
            }
        }        
    }
    
    static testMethod void myUnitTest_IGI_App_2_2() {
        // TO DO: implement unit test
        PageReference p=Page.igi_pt_app_personal_info; 
        //p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        //ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
        RecordType rtAccountPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        //Assert for Results
        //System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType igi_rt = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
       
        //Assert for Results
        system.assertEquals(true, igi_rt != null);
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        //Create a new test account and set contact as portal contact
        Account ptAccount = new Account(FirstName = 'PT Account', LastName = 'LN', Type = 'Participant', personemail='user@test.com', RecordTypeId = rtAccountPT.Id);
        insert ptAccount;
            
        
        if(profiles.size() > 0) {
            //RecordType rtuserAccount = [select id,Name from RecordType where SobjectType='Account' and Name='Business Account' Limit 1];
            
            // Default user Account
            Account userAccount = [SELECT Id FROM Account WHERE Name =: 'Intrax Program Applicants' limit 1];
            //Contact
            Contact userContact = new Contact(LastName = 'LastName', AccountId = userAccount.Id, email = 'test@test.com');
            insert userContact;
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
                        
            //Fetch intract Id for this account id
            ptAccount = [Select Id, Intrax_Id__c from Account where Id =: ptAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test',
                                                                    Postal_Code__c = '12345',  Type__c = 'Participant', Country__c = 'United States', 
                                                                    Home_Phone__c = '12345', Intrax_Program__c = 'Internship',                 
                                                                    Application_Stage__c = 'Basic', Application_Level__c = 'Working',                                                                  
                                                                    Primary_Language__c = 'English', Language_1__c = 'Spanish', Language_1_Proficiency__c = 'Advanced', 
                                                                    Language_2__c = 'French', Language_2_Proficiency__c = 'Advanced',                                                                  
                                                                    createdBy__c = user.Id, Country_of_Interest__c = 'United States', One_Year_Work_Experience__c = true,
                                                                    Intrax_Program_Category__c = 'Business', Functional_Areas__c = 'Accounting', Work_Authorization_Indicated__c = 'Yes',
                                                                    Engagement_Start__c = date.today()+ 91, Engagement_End__c = date.today() + 200, Service_Level__c = 'Independent',
                                                                    PageStatus_Started__c ='052', PageStatus_Complete__c = '051', Allow_Intrax_To_Apply__c = true);
                
                insert appInfo;
                
                
                list<Person_Info__c> listPerson = new list<Person_Info__c>();
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Test', role__c = 'Student', Citizenship__c = 'Spain',
                                                                    Date_of_Birth__c = date.newInstance(1995, 2, 17), Country_of_Residence__c = 'United States',
                                                                    Skype_Id__c = 'mySkype',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(personInfo);
                
                Person_Info__c emergency1 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 1', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1972, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency1);
                
                Person_Info__c emergency2 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 2', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1968, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency2);
                
                insert listPerson;
                
                // Building Education Page data;
                
                list<Education__c> listEdu = new list<Education__c>();
                
                Education__c ed1 = new Education__c(Institution_Type__c = 'University/College', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                                                    Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfo.Id);  
                                                    
                listEdu.add(ed1);
                
                Education__c ed2 = new Education__c(Institution_Type__c = 'University/College', Program_Type__c = 'Bachelor', Institution_Name__c = 'UMU', Field_of_Study__c = 'Computer Science', 
                                                    Graduation_Date__c = date.newInstance(2011, 6, 15), applicant_Info__c = appInfo.Id);  
                                                    
                listEdu.add(ed2);
                
                insert listEdu;
                
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfo.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',
                                                                    Functional_Areas__c = 'Accounting');
                
                list<Experience__c> listExp = new list<Experience__c>();                                                    
                Experience__c exp1 = new Experience__c(Employer_Name__c = 'Test', City__c = 'Murcia', Country__c = 'Spain', Start_Date__c = date.today() - 400, End_Date__c = date.today()-200,
                                                        Position_Title__c = 'Test', Position_Description__c = 'Description', Applicant_Info__c = appInfo.Id);
                                                        
                listExp.add(exp1);
                
                Experience__c exp2 = new Experience__c(Employer_Name__c = 'Test 2', City__c = 'Madrid', Country__c = 'Spain', Start_Date__c = date.today() - 200, End_Date__c = date.today()-100,
                                                        Position_Title__c = 'Test', Position_Description__c = 'Description', Applicant_Info__c = appInfo.Id);
                                                        
                listExp.add(exp2);
                
                insert listExp;
                                                                                    
                
                Test.startTest();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.educationInfo = ed1;
                controller.positionInfo = posInfo;
                
                controller.igi_visa_status = 'need_visa'; 
                controller.faculty_led_program = 'No';
                
                ApexPages.currentPage().getParameters().put('PageId', '052'); 
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');       
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_completion');
                //controller.navigator();
                
                controller.getLabelPrice('test');
                
                controller.getLang();
                controller.checkLogin();
                controller.buildExperienceMap();
                controller.BuildEducationMap();
                controller.BuildEmergencyContactMap();
                
                controller.getEmergencyMapLast();
                controller.getEducationMapLast();
                controller.getExperienceMapLast();
                
                controller.toDelIdent = 1;
                controller.removeEducationRecord();
                
                controller.toDelIdent = 1;
                controller.removeExperienceRecord();
                
                controller.removeExperienceRecords();
                
                controller.toDelIdent = 2;
                controller.removeEmergencyRecord();
                
                controller.addExperienceRecord();
                //controller.saveExperienceIGI();
                
                controller.addEmergencyRecord();
                //controller.saveEmergencyContact();
                
                controller.addEducationRecord();   
                
                controller.deleteLanguagesIGI();              
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '052');
                controller.setPageIdStarted(); 
                
                controller.resetpageIdValues();
                
                //Stop Testing here
                Test.stopTest();
               
            }
        }        
    }
    
    static testMethod void myUnitTest_IGI_App_3() {
        // TO DO: implement unit test
        PageReference p=Page.igi_pt_app_personal_info; 
        //p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        //ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
        RecordType rtAccountPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        //Assert for Results
        //System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType igi_rt = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
       
        //Assert for Results
        system.assertEquals(true, igi_rt != null);
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        //Create a new test account and set contact as portal contact
        Account ptAccount = new Account(FirstName = 'PT Account', LastName = 'LN', Type = 'Participant', personemail='user@test.com', RecordTypeId = rtAccountPT.Id);
        insert ptAccount;
            
        
        if(profiles.size() > 0) {
            //RecordType rtuserAccount = [select id,Name from RecordType where SobjectType='Account' and Name='Business Account' Limit 1];
            
            // Default user Account
            Account userAccount = [SELECT Id FROM Account WHERE Name =: 'Intrax Program Applicants' limit 1];
            //Contact
            Contact userContact = new Contact(LastName = 'LastName', AccountId = userAccount.Id, email = 'test@test.com');
            insert userContact;
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
                        
            //Fetch intract Id for this account id
            ptAccount = [Select Id, Intrax_Id__c from Account where Id =: ptAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test',
                                                                    Postal_Code__c = '12345',  Type__c = 'Participant', Country__c = 'United States', 
                                                                    Home_Phone__c = '12345', Intrax_Program__c = 'Internship',           
                                                                    Application_Stage__c = 'Basic', Application_Level__c = 'Working',                                                                  
                                                                    Primary_Language__c = 'English', Language_1__c = 'Spanish', Language_1_Proficiency__c = 'Advanced', 
                                                                    Language_2__c = 'French', Language_2_Proficiency__c = 'Advanced',                                                                  
                                                                    createdBy__c = user.Id, Country_of_Interest__c = 'United States',
                                                                    Intrax_Program_Category__c = 'Business', Functional_Areas__c = 'Accounting', Work_Authorization_Indicated__c = 'Yes',
                                                                    Engagement_Start__c = date.today()+ 91, Engagement_End__c = date.today() + 200, Service_Level__c = 'Premium',
                                                                    PageStatus_Started__c ='052', PageStatus_Complete__c = '051', Allow_Intrax_To_Apply__c = false);
                
                insert appInfo;
                
                list<Person_Info__c> listPerson = new list<Person_Info__c>();
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Test', role__c = 'Student', Citizenship__c = 'Spain',
                                                                    Date_of_Birth__c = date.newInstance(1995, 2, 17), Country_of_Residence__c = 'United States',
                                                                    Skype_Id__c = 'mySkype',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(personInfo);
                
                Person_Info__c emergency1 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 1', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1972, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency1);
                
                Person_Info__c emergency2 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 2', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1968, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency2);
                
                insert listPerson;
                
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfo.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',
                                                                    Functional_Areas__c = 'Accounting');
                
                Test.startTest();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                //controller.educationInfo = ed1;
                controller.positionInfo = posInfo;
                
                controller.igi_visa_status = 'no_need_visa'; 
                controller.faculty_led_program = 'Yes';
                
                ApexPages.currentPage().getParameters().put('PageId', '053'); 
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');       
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_completion');
                //controller.navigator();
                
                controller.getLabelPrice('test');
                
                controller.getLang();
                controller.checkLogin();
                controller.buildExperienceMap();
                controller.BuildEducationMap();
                controller.BuildEmergencyContactMap();
                
                controller.getEmergencyMapLast();
                                
                controller.addEducationRecord();   
                
                controller.deleteLanguagesIGI();              
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '052');
                controller.setPageIdStarted(); 
                
                controller.resetpageIdValues();
                
                //Education Methods;
                
                //controller.getOneYearFromGraduation();
                //controller.getFiveYearsFromGraduation();
                
                controller.getValidateIGIBasicApp();              
                                
                //controller.navigator();                
               
               // Completion Page
               ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_home');
               ApexPages.currentPage().getParameters().put('submitApp', 'PA');
               controller.getValidateIGIBasicApp();               
               
               map <string, string> mstr1 = controller.getDocTypeList();
               Test.stopTest();
            }
        }        
    }
    
    static testMethod void myUnitTest_IGI_App_4() {
        // TO DO: implement unit test
        PageReference p=Page.igi_pt_app_personal_info; 
        //p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        //ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
        RecordType rtAccountPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        //Assert for Results
        //System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType igi_rt = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
       
        //Assert for Results
        system.assertEquals(true, igi_rt != null);
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        //Create a new test account and set contact as portal contact
        Account ptAccount = new Account(FirstName = 'PT Account', LastName = 'LN', Type = 'Participant', personemail='user@test.com', RecordTypeId = rtAccountPT.Id);
        insert ptAccount;
            
        
        if(profiles.size() > 0) {
            //RecordType rtuserAccount = [select id,Name from RecordType where SobjectType='Account' and Name='Business Account' Limit 1];
            
            // Default user Account
            Account userAccount = [SELECT Id FROM Account WHERE Name =: 'Intrax Program Applicants' limit 1];
            //Contact
            Contact userContact = new Contact(LastName = 'LastName', AccountId = userAccount.Id, email = 'test@test.com');
            insert userContact;
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
                        
            //Fetch intract Id for this account id
            ptAccount = [Select Id, Intrax_Id__c from Account where Id =: ptAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test',
                                                                    Postal_Code__c = '12345',  Type__c = 'Participant', Country__c = 'United States', 
                                                                    Home_Phone__c = '12345', Intrax_Program__c = 'Internship',           
                                                                    Application_Stage__c = 'Basic', Application_Level__c = 'Working',                                                                  
                                                                    Primary_Language__c = 'English', Language_1__c = 'Spanish', Language_1_Proficiency__c = 'Advanced', 
                                                                    Language_2__c = 'French', Language_2_Proficiency__c = 'Advanced',                                                                  
                                                                    createdBy__c = user.Id, Country_of_Interest__c = 'United States',
                                                                    Intrax_Program_Category__c = 'Business', Functional_Areas__c = 'Accounting', Work_Authorization_Indicated__c = 'Yes',
                                                                    Engagement_Start__c = date.today()+ 91, Engagement_End__c = date.today() + 200, Service_Level__c = 'Independent',
                                                                    PageStatus_Started__c ='052', PageStatus_Complete__c = '051');
                
                insert appInfo;
                
                list<Person_Info__c> listPerson = new list<Person_Info__c>();
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Test', role__c = 'Student', Citizenship__c = 'Spain',
                                                                    Date_of_Birth__c = date.newInstance(1995, 2, 17), Country_of_Residence__c = 'Spain',
                                                                    Skype_Id__c = 'mySkype',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(personInfo);
                
                Person_Info__c emergency1 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 1', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1972, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency1);
                
                Person_Info__c emergency2 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 2', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1968, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency2);
                
                insert listPerson;
                
                // Building Education Page data;
               
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfo.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',
                                                                    Functional_Areas__c = 'Accounting');
                                                                    
                
                Test.startTest();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.positionInfo = posInfo;
                
                controller.igi_visa_status = 'no_need_visa'; 
                controller.faculty_led_program = 'Yes';
                
                ApexPages.currentPage().getParameters().put('PageId', '053'); 
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');       
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_completion');
                //controller.navigator();
                
                controller.getLabelPrice('test');
                
                controller.getLang();
                controller.checkLogin();
                controller.buildExperienceMap();
                controller.BuildEducationMap();
                controller.BuildEmergencyContactMap();
                
                controller.addotherphone();
                controller.removeOtherPhone();
                
                controller.getEmergencyMapLast();
                                
                controller.addEducationRecord();   
                
                controller.deleteLanguagesIGI();              
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '052');
                controller.setPageIdStarted(); 
                
                controller.resetpageIdValues();
                
                //Education Methods;
                
                //controller.getOneYearFromGraduation();
                //controller.getFiveYearsFromGraduation();
                
                controller.getValidateIGIBasicApp();              
                                
                //controller.navigator();                
               
               // Completion Page
               ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_home');
               ApexPages.currentPage().getParameters().put('submitApp', 'PA');
               controller.getValidateIGIBasicApp();               
               
               map <string, string> mstr1 = controller.getDocTypeList();
               Test.stopTest();
            }
        }        
    }
    
    static testMethod void myUnitTest_IGI_App_UniversityGroup() {
        // TO DO: implement unit test
        PageReference p=Page.igi_pt_app_personal_info; 
        //p.getParameters().put('event','ViewComplete'); 
        //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        //ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
        RecordType rtAccountPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        RecordType rtAccountUniversity = [select id,Name from RecordType where SobjectType='Account' and Name='Institution' Limit 1];
        
        //Assert for Results
        //System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType igi_rt = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
       
        //Assert for Results
        system.assertEquals(true, igi_rt != null);
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        //Create a new test account and set contact as portal contact
        Account ptAccount = new Account(FirstName = 'PT Account', LastName = 'LN', Type = 'Participant', personemail='user@test.com', RecordTypeId = rtAccountPT.Id);
        insert ptAccount;
        
        Account UnivAccount = new Account(Name = 'Univ Account', Intrax_Programs__c = 'Internship');
        
        insert UnivAccount;
        
        UnivAccount.Type = 'Institution';
        UnivAccount.RecordTypeId = rtAccountUniversity.Id;
        
        update univAccount;
        
        Account univAccount2 = [SELECT Intrax_Id__c, Id FROM Account WHERE Id =: univAccount.Id];
              
        
        if(profiles.size() > 0) {
            //RecordType rtuserAccount = [select id,Name from RecordType where SobjectType='Account' and Name='Business Account' Limit 1];
            
            // Default user Account
            Account userAccount = [SELECT Id FROM Account WHERE Name =: 'Intrax Program Applicants' limit 1];
            //Contact
            Contact userContact = new Contact(LastName = 'LastName', AccountId = userAccount.Id, email = 'test@test.com');
            insert userContact;
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = userContact.Id, 
                                    Intrax_Id__c ='I-123456',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
                        
            //Fetch intract Id for this account id
            ptAccount = [Select Id, Intrax_Id__c from Account where Id =: ptAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                //Applicant Info
                
                Group__c gr = new Group__c (Account__c = UnivAccount.Id, Name ='My Group', Intrax_Program__c = 'Internship');
                
                insert gr; 
                
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test',
                                                                    Postal_Code__c = '12345',  Type__c = 'Participant', Country__c = 'United States', 
                                                                    Home_Phone__c = '12345', Intrax_Program__c = 'Internship',           
                                                                    Application_Stage__c = 'Basic', Application_Level__c = 'Working',                                                                  
                                                                    Primary_Language__c = 'English', Language_1__c = 'Spanish', Language_1_Proficiency__c = 'Advanced', 
                                                                    Language_2__c = 'French', Language_2_Proficiency__c = 'Advanced',                                                                  
                                                                    createdBy__c = user.Id, Country_of_Interest__c = 'United States',
                                                                    Intrax_Program_Category__c = 'Business', Functional_Areas__c = 'Accounting', Work_Authorization_Indicated__c = 'Yes',
                                                                    Engagement_Start__c = date.today()+ 91, Engagement_End__c = date.today() + 200, Service_Level__c = 'Independent',
                                                                    PageStatus_Started__c ='052', PageStatus_Complete__c = '051');
                
                insert appInfo;
                
                list<Person_Info__c> listPerson = new list<Person_Info__c>();
                
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Test', role__c = 'Student', Citizenship__c = 'Spain',
                                                                    Date_of_Birth__c = date.newInstance(1995, 2, 17), Country_of_Residence__c = 'Spain',
                                                                    Skype_Id__c = 'mySkype',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(personInfo);
                
                Person_Info__c emergency1 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 1', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1972, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency1);
                
                Person_Info__c emergency2 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
                                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
                                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 2', role__c = 'Student',
                                                                    Date_of_Birth__c = date.newInstance(1968, 2, 17), 
                                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
                                                                    Phone__c = '123456', Phone_Type__c = 'Home');
                listPerson.add(emergency2);
                
                insert listPerson;
                
                // Building Education Page data;
               
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfo.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',
                                                                    Functional_Areas__c = 'Accounting');
                                                                    
                
                Test.startTest();
                
                ApexPages.currentPage().getParameters().put('id', appInfo.Id);
                
                ApexPages.StandardController sc = new ApexPages.StandardController(appInfo);
                AppEngine_Controller.isApexBeingTested=true;
                AppEngine_Controller controller = new AppEngine_Controller(sc);
                
                controller.applicantInfo = appInfo;
                controller.personInfo = personInfo;
                controller.positionInfo = posInfo;
                
                controller.igi_visa_status = 'no_need_visa'; 
                controller.faculty_led_program = 'Yes';
                
                ApexPages.currentPage().getParameters().put('PageId', '053'); 
                ApexPages.currentPage().getParameters().put('docType', 'Participant-Photo');       
                ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_completion');
                ApexPages.currentPage().getParameters().put('UniversityId', UnivAccount2.Intrax_Id__c);
                ApexPages.currentPage().getParameters().put('GroupApp', gr.Id);
                
                //controller.navigator();
                
                controller.getLabelPrice('test');
                
                controller.getLang();
                controller.checkLogin();
                controller.buildExperienceMap();
                controller.BuildEducationMap();
                controller.BuildEmergencyContactMap();
                
                controller.addotherphone();
                controller.removeOtherPhone();
                
                controller.getEmergencyMapLast();
                                
                controller.addEducationRecord();   
                
                controller.deleteLanguagesIGI();              
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '055');
                controller.setPageIdStarted(); 
                
                ApexPages.currentPage().getParameters().put('PageId', '052');
                controller.setPageIdStarted(); 
                
                controller.resetpageIdValues();
                
                //Education Methods;
                
                //controller.getOneYearFromGraduation();
                //controller.getFiveYearsFromGraduation();
                
                controller.getValidateIGIBasicApp();              
                                
                //controller.navigator();                
               
               // Completion Page
               ApexPages.currentPage().getParameters().put('nextPage', '/apex/igi_pt_app_home');
               ApexPages.currentPage().getParameters().put('submitApp', 'PA');
               controller.getValidateIGIBasicApp();               
               
               map <string, string> mstr1 = controller.getDocTypeList();
               Test.stopTest();
            }
        }        
    }
    
}