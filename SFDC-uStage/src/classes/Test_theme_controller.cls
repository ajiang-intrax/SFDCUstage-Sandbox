@isTest(SeeAllData=true)
private class Test_theme_controller { 

    
    static testMethod void myUnitTestIGI() {
        // TO DO: implement unit test
        
        Account participantInfoIGI = new Account(FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
                            type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
                            OwnerId = UserInfo.getUserId());
         
        insert participantInfoIGI;
        
        Contact coIGI = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: participantInfoIGI.Id ];
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User userIGI = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    User_Interests__c ='Finding an internship',Type__c = 'Participant',
                                    ContactId = coIGI.Id, Intrax_Id__c = participantInfoIGI.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
                                    
        insert userIGI;
             
                
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States', BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert partnerAccount;
        
         //Record Type
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = participantInfoIGI.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Needs_Travel__c ='Yes', Status__c = 'On Program', Placement_Status__c = 'Not Placed');
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='ICD Intern PT' Limit 1];
        insert engagement;
        
         //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'CA', City__c = 'Fremont', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '94538',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = partnerAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', Partner_Account__c = partnerAccount.Id,
                                                                  Intrax_Program_Options__c = 'YES',
                                                                  CreatedBy__c = userIGI.Id);
        insert appInfo;
        
        system.runAs(userIGI){
          test.startTest();
          
          theme_controller c1 = new theme_controller();
          ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(userIGI);
          theme_controller c = new theme_controller(sc);
                 
          c.activeUser = userIGI;
          c.getActiveUserType();
          c.getCheckHFUser();
          c.getIsInternshipUser();
          c.getIsWTUser();
          c.getIsAPCUser();
          c.checkLogin();
          c.getIntraxId();
          c.getEngagementId();
          boolean bl = c.getOnProgramEngg();
          c.getAccSiteInfo();
          c.getApplicationId();
          c.getIsAYUSAParticipant();
          c.getIsWTParticipant();
          c.getIsIGIParticipant();
      c.getDefaultIP();
            c.GoSearch();
            c.currentEng = engagement;
            c.getcheckNotificationlist();
          test.stopTest();
        }
        
        
    }
   
    
    static testMethod void myUnitTestWT() {
        // TO DO: implement unit test
        
        Account participantInfoWT = new Account(FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
                            type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Terminated',
                            OwnerId = UserInfo.getUserId());
         
        insert participantInfoWT;
        
        Contact coWT = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: participantInfoWT.Id ];
        //Contact co = new Contact(FirstName = 'Test1', LastName = 'Partner', AccountId = participantInfo.Id, email='test@test.com');
               
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        
         User userWT = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    User_Interests__c ='Becoming a Work Travel Participant',Type__c = 'Participant',
                                    ContactId = coWT.Id, Intrax_Id__c = participantInfoWT.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
                                    
        insert userWT;       
                
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States', BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert partnerAccount;
        
        //Record Type
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = participantInfoWT.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Needs_Travel__c ='Yes', Status__c = 'On Program', Placement_Status__c = 'Not Placed');
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='ICD Intern PT' Limit 1];
        insert engagement;
        
         //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'CA', City__c = 'Fremont', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '94538',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = partnerAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', Partner_Account__c = partnerAccount.Id,
                                                                  Intrax_Program_Options__c = 'YES',
                                                                  CreatedBy__c = userWT.Id);
        insert appInfo;
        
               
        system.runAs(userWT){
          test.startTest();
          
          theme_controller c1 = new theme_controller();
          ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(userWT);
          theme_controller c = new theme_controller(sc);
          ApexPages.currentPage().getParameters().put('eid', engagement.Id);
      c.ConfirmNotificationlist();      
          c.activeUser = userWT;          
          c.getIntraxId();
          c.getEngagementId();
          boolean bl = c.getOnProgramEngg();
          c.getAccSiteInfo();
          c.getApplicationId();
          c.getIsAYUSAParticipant();
          c.getIsWTParticipant();
          c.getIsIGIParticipant();
      c.getDefaultIP();
            c.GoSearch();
            c.getCurrentApp();
            c.getOriginalApp();
            c.getEngChecklist();
            c.getApplicationInfo();
        c.getApplicationId();
        c.getEngagementId();
        c.getOnProgramEngg();
        c.getHasConfirmedMatch();
        c.setConfirmedDate();
        c.setNextDueDate();
        Id engIdVal = c.engagementId;
        test.stopTest();
        }
        
    }
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        PageReference pageRef = Page.Partner_DefaultIP_Selection;
        Test.setCurrentPage(pageRef);
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        Account partnerAccount  = new Account(Name = 'Partner Account', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'AuPairCare');
        insert partnerAccount;
        
        Contact contactPartner = new Contact(FirstName = 'Partner', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contactPartner;               
        
        User user = [SELECT Id,Email,ContactId,Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true AND ContactId!=null AND Contact.PTR_Portal_Intrax_Program_Default__c != null LIMIT 1];
        
        
    Test.startTest();
    System.assertEquals(Page.Partner_DefaultIP_Selection.getUrl(),pageRef.getUrl());
    
        theme_controller controller = new theme_controller();                
        controller.user.Type__c='Partner';          
        System.assertEquals(controller.IsPartner,false);
                       
        controller.getDefaultIP();
        controller.getContactIP();
        controller.getContactIPSize();
        controller.checkLogin();
        controller.UpdateToAPC();
        controller.UpdateToAyusa();
        controller.UpdateToEA();
        controller.UpdateToIntern();
        controller.UpdateToWT();        
        controller.getAppStatus();
        controller.getIsMatchingStage();
        controller.getUnreadCount();
        controller.accountIds('Participant');        
         Test.stopTest();
         
        System.currentPageReference().getParameters().put('uIn','test');
        System.currentPageReference().getParameters().put('id','123oUnvbr');
        theme_controller controllerb = new theme_controller();
        controllerb.user.Intrax_Id__c = '123213';
        controllerb.user.Type__c='Partner'; 
    }
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //User user = [SELECT Id,Email,ContactId,Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Type__c = 'Participant' AND Profile.Name = 'OCPM PT' AND User_Interests__c='Becoming an au pair' AND isActive=true AND ContactId!=null AND Contact.PTR_Portal_Intrax_Program_Default__c != null LIMIT 1];
        
        //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'PTTest', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
            insert user;
        System.runAs(user){
    Test.startTest();
    
    
        theme_controller controller = new theme_controller();        
        controller.user.Intrax_Id__c = null;
                      
        controller.getDefaultIP();
        controller.getContactIP();
        controller.getContactIPSize();
        controller.checkLogin();
        controller.UpdateToAPC();
        controller.UpdateToAyusa();
        controller.UpdateToEA();
        controller.UpdateToIntern();
        controller.UpdateToWT();        
        controller.getAppStatus();
        controller.getIsMatchingStage();
        controller.getUnreadCount();
        controller.accountIds('Participant');   
        controller.getCurrentApp();
        controller.getOriginalApp();
         Test.stopTest();
        }
         
        
    }
    
    static testMethod void myUnitTest3() {
        // TO DO: implement unit test
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;       
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];       
        
        //User user = [SELECT Id,Email,ContactId,Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Type__c = 'Host' AND Profile.Name = 'OCPM PT' AND User_Interests__c='Hosting an au pair' AND isActive=true AND ContactId!=null AND Contact.PTR_Portal_Intrax_Program_Default__c != null LIMIT 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'PTTest', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
        System.runAs(user){
    Test.startTest();
    
    
        theme_controller controller = new theme_controller();        
        controller.user.Intrax_Id__c = null;
                      
        controller.getDefaultIP();
        controller.getContactIP();
        controller.getContactIPSize();
        controller.checkLogin();
        controller.UpdateToAPC();
        controller.UpdateToAyusa();
        controller.UpdateToEA();
        controller.UpdateToIntern();
        controller.UpdateToWT();        
        controller.getAppStatus();
        controller.getIsMatchingStage();
        controller.getUnreadCount();
        controller.accountIds('Host');  
        controller.getCurrentApp();
        controller.getOriginalApp(); 
      controller.getApplicationInfo();
      controller.getApplicationId();
      controller.getEngagementId();
      controller.getOnProgramEngg();
      
         Test.stopTest();
        }
         
        
    }
    
}