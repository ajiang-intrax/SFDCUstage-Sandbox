@isTest(seeAllData=true)
public with sharing class Test_SiteRegisterController {
    static testMethod void myUnitTest() {
        User nu = new User(firstname='Test',Email='a@a.com', lastname='Test', Username = 'test',User_Interests__c = 'Finding an internship',TimeZoneSidKey='(GMT+13:45) Chatham Daylight Time (Pacific/Chatham)'
        ,LocaleSidKey='English (Australia)');
        
        SiteRegisterController src = new SiteRegisterController(new Apexpages.StandardController(nu));
        src.password = 'Thisisatest1234';
        src.confirmPassword = 'Thisisatest1234';    
        SiteRegisterController.isApexBeingTested=true; 
        src.IsUserInterestinURL = false;
        PageReference p=Page.AppEngine_SiteRegister;
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getHeaders().put('USER-AGENT', 'rv:11.0');
       
        
        
        src.getUser();
        src.getInterests();
        src.getLocales();
        src.getTimeZones();
        src.registerUser();
        src.checkLogin();
        ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        //src.checkLogin();
        // User Interests field can be set through the URL
        ApexPages.currentPage().getParameters().put('uIn', 'AYPT');      
        src.registerUser();
        ApexPages.currentPage().getParameters().put('uIn', 'AYHF');      
        src.registerUser();
        test.startTest();
        ApexPages.currentPage().getParameters().put('uIn', 'CNPT');       
        src.registerUser();
        ApexPages.currentPage().getParameters().put('uIn', 'IGIC');        
        //src.registerUser();
        ApexPages.currentPage().getParameters().put('uIn', 'WTPT');      
        //src.registerUser();
        //ApexPages.currentPage().getParameters().put('uIn', 'APCHF');      
        //src.registerUser();
        // Negative case: Incorrect Parameter
        //ApexPages.currentPage().getParameters().put('uIn', 'hhh');      
        //src.registerUser();
        
        src.getLangFromURL();
        ApexPages.currentPage().getParameters().put('lang', 'es');
        src.getLangFromURL();
        ApexPages.currentPage().getParameters().put('lang', 'es');
        src.getLangFromURL();
        ApexPages.currentPage().getParameters().put('lang', 'it');
        src.getLangFromURL();
        
        test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        User nu = new User(firstname='Test', Email='a@a.com',lastname='Test', Username = 'test',User_Interests__c = 'Finding an internship', TimeZoneSidKey='(GMT+13:45) Chatham Daylight Time (Pacific/Chatham)'
        ,LocaleSidKey='English (Australia)');
        
        SiteRegisterController src = new SiteRegisterController(new Apexpages.StandardController(nu));
        src.password = 'Thisisatest1234';
        src.confirmPassword = 'Thisisatest123';     
        SiteRegisterController.isApexBeingTested=true; 
        PageReference p=Page.AppEngine_SiteRegister; 
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getHeaders().put('USER-AGENT', 'other');
        
        test.startTest();
        src.getUser();
        src.getInterests();
        src.getLocales();
        src.getTimeZones();
        src.registerUser();
        src.checkLogin();
        
        
        SiteRegisterController.isApexBeingTested=false;
        src.registerUser();
        test.stopTest();
        
    }
    
     static testMethod void myUnitTest3() {
        User nu = new User(firstname='Test', Email='a@a.com',lastname='Test', Username = 'test',User_Interests__c = 'Finding an internship',TimeZoneSidKey='(GMT+13:45) Chatham Daylight Time (Pacific/Chatham)'
        ,LocaleSidKey='English (Australia)');
        
        SiteRegisterController src = new SiteRegisterController();
        
    }
    
     static testMethod void myUnitTest4() {
        
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
        
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        
        User nu = new User(ProfileId = profiles[0].Id, Alias = 'alias', EmailEncodingKey = 'UTF-8',firstname='test', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', lastname='User 1', Username = 'test99@test.com',User_Interests__c = 'Finding an internship',TimeZoneSidKey='America/Los_Angeles'
        ,email = 'test@test.com', ContactId = contact.Id);
      
        insert nu;
        
         //Run in user context
        System.runAs(nu) {
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                Country__c = 'United States', Home_Phone__c = '12345',Type__c='Participant', ETR_Received_Date__c=null, email__c = nu.Email, last_name__c = nu.LastName
                                );
        insert appInfo;
        
        Test.setCurrentPageReference(new PageReference('/apex/AppEngine_SiteRegister')); 
        System.currentPageReference().getParameters().put('uIn', 'APCHF');
        System.currentPageReference().getParameters().put('FN', 'test');
        System.currentPageReference().getParameters().put('LN', 'test');
        System.currentPageReference().getParameters().put('email', 'test');
        System.currentPageReference().getParameters().put('partnerApp', 'true');
        
        SiteRegisterController src = new SiteRegisterController(new Apexpages.StandardController(nu));
        src.password = 'Thisisatest1234';
        src.confirmPassword = 'Thisisatest1234';     
        SiteRegisterController.isApexBeingTested=true;
        src.email = 'test@test.com'; 
        src.confirmEmail = 'test@test.com';
        //src.username = 'test';
        
        
        system.debug('*****@@@nu: '+nu);
         
        test.startTest();
        src.isValidEmail(); 
        src.isValidPassword();
        src.getUser();
        src.getInterests();
        src.getLocales();
        src.getTimeZones();
        SiteRegisterController.isApexBeingTested=false;
        src.registerUser();
        test.stopTest();
        
        }
    
    }
    
    static testMethod void myUnitTest5() {
        User nu = new User(firstname='Test',Email='a@a.com', lastname='Test', Username = 'test@lkjasd.com',User_Interests__c = 'Hosting an au pair',TimeZoneSidKey='(GMT+13:45) Chatham Daylight Time (Pacific/Chatham)'
        ,LocaleSidKey='English (Australia)');
        
        Test.setCurrentPageReference(new PageReference('/apex/AppEngine_SiteRegister')); 
        System.currentPageReference().getParameters().put('uIn', 'APCPT');
        
        SiteRegisterController src = new SiteRegisterController(new Apexpages.StandardController(nu));
            
        SiteRegisterController.isApexBeingTested=true; 
        src.IsUserInterestinURL = false;
        src.email = 'a@a.com'; 
        src.confirmEmail = 'tests@mail.com'; 
        src.password = 'test1234';
        src.confirmPassword  = 'test1234';
        
        test.startTest();
        src.isValidEmail(); 
        src.isValidPassword();
        src.getUser();
        src.getInterests();
        src.getLocales();
        src.getTimeZones();
         SiteRegisterController.isApexBeingTested=true;
        // User Interests field can be set through the URL
        
        src.registerUser();
        test.stopTest();
    }
    
    static testMethod void myUnitTest6() {
        
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
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User nu = new User(ProfileId = profiles[0].Id, Alias = 'alias', EmailEncodingKey = 'UTF-8',firstname='test', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', lastname='User 1', Username = 'test98@test.com',User_Interests__c = 'Finding an internship',TimeZoneSidKey='America/Los_Angeles'
        ,email = 'wrong@test.com', ContactId = contact.Id);
      
        insert nu;
        
        
        //Application
        Applicant_Info__c appInfo = new Applicant_Info__c(Intrax_Program__c = 'Internship', Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                Country__c = 'United States', Home_Phone__c = '12345',Type__c='Participant', ETR_Received_Date__c=null, email__c = nu.Email, last_name__c = nu.LastName);
        insert appInfo;
        
        Test.setCurrentPageReference(new PageReference('/apex/AppEngine_SiteRegister')); 
        System.currentPageReference().getParameters().put('FN', 'test');
        System.currentPageReference().getParameters().put('LN', 'test');
        System.currentPageReference().getParameters().put('email', 'test');
       
        
        SiteRegisterController src = new SiteRegisterController(new Apexpages.StandardController(nu));
        src.password = 'Thisisatest1234';
        src.confirmPassword = 'Thisisatest1234';     
        SiteRegisterController.isApexBeingTested=true;
        src.email = 'test@test.com'; 
        src.confirmEmail = 'test@test.com';
        //src.username = 'test';
        
        system.debug('*****@@@nu: '+nu);
         
        test.startTest();
        src.isValidEmail(); 
        src.isValidPassword();
        src.getUser();
        src.getInterests();
        src.getLocales();
        src.getTimeZones();
        SiteRegisterController.isApexBeingTested=true;
        src.registerUser();
        test.stopTest();
    
    }
    
    static testMethod void myUnitTest7() {
        
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
        
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
         User nu = new User(ProfileId = profiles[0].Id, Alias = 'alias', EmailEncodingKey = 'UTF-8',firstname='test', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', lastname='User 1', Username = 'test97@test.com',User_Interests__c = 'Finding an internship',TimeZoneSidKey='America/Los_Angeles'
        ,email = 'wrong@test.com', ContactId = contact.Id);
        
        insert nu;
        //Engagement
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Intrax_Program__c = 'Internship', Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                Country__c = 'United States', Home_Phone__c = '12345',Type__c='Participant', ETR_Received_Date__c=null, email__c = 'test2@test.com', last_name__c = 'UserLast', Engagement__c = engagement.id);
        insert appInfo;
        
        Notification__c nt = new Notification__c ( Type__c = 'Orientation', Engagement__c = engagement.id, Status__c = 'Not Started', OwnerID = sysAdmin.Id);
        insert nt;
        
        Assessment__c assessment = new Assessment__c(Name = 'Test', Status__c = 'Not Yet Started', Engagement__c = engagement.Id);
        insert assessment;
        
        Test.setCurrentPageReference(new PageReference('/apex/AppEngine_SiteRegister')); 
        System.currentPageReference().getParameters().put('partnerApp', 'true');
        
        SiteRegisterController src = new SiteRegisterController(new Apexpages.StandardController(nu));
        src.password = 'Thisisatest1234';
        src.confirmPassword = 'Thisisatest1234';     
        src.email = 'test2@test.com'; 
        src.confirmEmail = 'test2@test.com';
        src.Locale='English (United States)';
        src.User_Interests='Hosting an au pair';
        src.firstname = 'Alan2'; 
        src.lastname = 'UserLast'; 
        src.timezone = 'America/Los_Angeles'; 
        //src.username = 'Tim';
        src.Locale = 'en_US';
        src.userId = nu.Id;
        
        system.debug('*****@@@nu: '+nu);
         
        test.startTest();
        
        //src.isValidEmail(); 
        //src.isValidPassword();
        src.getUser();
        src.getInterests();
        src.getLocales();
        src.getTimeZones();
        SiteRegisterController.isApexBeingTested=true;
        src.registerUser();
        src.User_Interests='AYHF';
        src.registerUser();
        src.User_Interests='CNPT';
        src.registerUser();
        src.User_Interests='APCHF';
        src.registerUser();
        test.stopTest();
    
    }
    
}