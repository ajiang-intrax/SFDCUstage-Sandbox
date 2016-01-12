@isTest
private class Test_MapPersonToReferenceMember {

    static testMethod void myUnitTest1() {
        
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        sysAdmin.Email='test@josele.com';
        //update sysAdmin;
        //Portal User
        User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = 'test@josele.com', User_Interests__c='Hosting an au pair');
            
        insert user;
        
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        Account myAccount = new Account(Name='Test');
        insert myAccount;
         
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccount.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
        
        
        System.runAs(sysAdmin){
        
       
            
         //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country', Position__c= myPosition.id,
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = sysAdmin.Id);
        insert appInfo;
        
        //Personal Info
        Person_Info__c personInfo = new Person_Info__c(Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Parent',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfo;  
        
        //Personal Info Reference
        Person_Info__c personInfoRef = new Person_Info__c(Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = 'Jose', Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Denia', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfoRef;   
        
         
        //Personal Info Reference
        Person_Info__c personInfoPrimary = new Person_Info__c(Primary_Applicant__c  = true, Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Host',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfoPrimary;   
        
        
        //get Person_Info list for References 
        
        
       
        test.starttest();
        
        MapPersonToReferenceMember controller = new MapPersonToReferenceMember();
        
        MapPersonToReferenceMember.MapPersonToRef(appInfo.Id, portalAccount.id);
        
        
        test.stoptest();
        
      }
     
    }
    
     static testMethod void myUnitTest2() {
        
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        sysAdmin.Email='test@josele.com';
        //update sysAdmin;
        //Portal User
        User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = 'test@josele.com', User_Interests__c='Hosting an au pair');
            
        insert user;
        
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        Account myAccount = new Account(Name='Test');
        insert myAccount;
         
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccount.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
        
        
        System.runAs(sysAdmin){
        
       
            
         //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country', Position__c= myPosition.id,
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = sysAdmin.Id);
        insert appInfo;
        
        //Personal Info
        Person_Info__c personInfo = new Person_Info__c(Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Parent',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfo;  
        
        //Personal Info Reference
        Person_Info__c personInfoRef = new Person_Info__c(Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = 'Jose', Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Denia', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfoRef;   
        
         
        //Personal Info Reference
        Person_Info__c personInfoPrimary = new Person_Info__c(Primary_Applicant__c  = true, Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Host',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfoPrimary;   
        
        //Member
        Member__c member = new Member__c(Name='membertest', Account_Name__c = portalAccount.id, Family_Member__c = true,
                                                    First_Name__c  = 'Josema', Gender__c = 'Male', Email__c='test1@josele.com',
                                                    Last_Name__c = 'Martinex', 
                                                    Date_of_Birth__c = date.newInstance(1981, 2, 17) );
        insert member;  
       
        
        //reference
        Reference__c reference = new Reference__c(Name='membertest',  Applicant_Info__c = appInfo.Id ,
                                                    First_Name__c  = 'Joes', Email__c='tesst@josele.com',
                                                    Last_Name__c = 'Lopez' );
        insert reference;
        //get Person_Info list for References 
        
        
       
        test.starttest();
        
        MapPersonToReferenceMember controller = new MapPersonToReferenceMember();
        MapPersonToReferenceMember.MapPersonToRef(appInfo.Id, portalAccount.id);
        
        test.stoptest();
        
      }
    }
    
    static testMethod void myUnitTest3() {
        
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        sysAdmin.Email='test@josele.com';
        //update sysAdmin;
        //Portal User
        User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = 'test@josele.com', User_Interests__c='Hosting an au pair');
            
        insert user;
        
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        Account myAccount = new Account(Name='Test');
        insert myAccount;
         
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccount.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
        
         System.runAs(sysAdmin){
        
       
            
         //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country', Position__c= myPosition.id,
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = sysAdmin.Id);
        insert appInfo;
        
        //Personal Info
        Person_Info__c personInfo = new Person_Info__c(Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = 'Josele', Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Martinex', Role__c ='Parent',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfo;  
        
        //Personal Info Reference
        Person_Info__c personInfoRef = new Person_Info__c(Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = 'Jose', Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Denia', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfoRef;   
        
         
        //Personal Info Reference
        Person_Info__c personInfoPrimary = new Person_Info__c(Primary_Applicant__c  = true, Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = 'Jose', Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Denia', Role__c ='Host',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfoPrimary;   
        
        //Member
        Member__c member = new Member__c(Name='membertest', Account_Name__c = portalAccount.id, Family_Member__c = true,
                                                    First_Name__c  = 'Josele', Gender__c = 'Male', Email__c='test@josele.com',
                                                    Last_Name__c = 'Martinex', 
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert member;  
       
        
        //reference
        Reference__c reference = new Reference__c(Name='membertest',  Applicant_Info__c = appInfo.Id ,
                                                    First_Name__c  = 'Jose', Email__c='test@josele.com',
                                                    Last_Name__c = 'Denia' );
        insert reference;
        //get Person_Info list for References 
        
        
       
        test.starttest();
        
        MapPersonToReferenceMember controller = new MapPersonToReferenceMember();
        MapPersonToReferenceMember.MapPersonToRef(appInfo.Id, portalAccount.id);
        
        test.stoptest();
        
      }
     
    }
}