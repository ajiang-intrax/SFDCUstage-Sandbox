@isTest(seeAllData = true)
private class Test_ApplicatiInfoHelper {

    static testMethod void myUnitTest1() {
        
         //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
        //Record Type
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
       
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Record Type
        RecordType rtopp = [select id, Name from RecordType where SobjectType='Opportunity' Limit 1];
       
        //Assert for Results
        System.assertEquals(true, rtopp!=null);
        
        
        RecordType rtHC = [SELECT id FROM RecordType WHERE DeveloperName = 'Host_Company' and SobjectType = 'Lead' ];

        
        //Account
        Account account  = new Account(Name = 'Test', Intrax_Region__c = 'United States', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Opportunity
        Opportunity op = new Opportunity(Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = rtopp.id, 
                                            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
                                            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Lead
        Lead leHC1 = new Lead(
            FirstName = 'Larry', LastName = 'Ellison', Email = 'larry@oracle.com',
            Lead_Type__c = 'Host Company', Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'WEST',
            Intrax_Region__c = 'United States', OwnerId = UserInfo.getUserId(),
            Related_To_Id__c = account.Intrax_Id__c, Company = 'OracleHC1');
            
        insert leHC1;    
        
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
        
       
        test.starttest();
        
        ApplicantInfoHelper controller = new ApplicantInfoHelper();
        
        ApplicantInfoHelper.hasalreadyCloningUpdated ();
        ApplicantInfoHelper.setalreadyCloningUpdated();
        ApplicantInfoHelper.hasalreadySyncedFields();
        ApplicantInfoHelper.setalreadySyncedFields();
        
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, null);
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Canada');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Chile');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Ayusa Germany');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Brazil');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Turkey');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax France');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Japan');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Korea');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Peru');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Japan');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'Intrax Singapore');
        ApplicantInfoHelper.setApp_IntraxRegion_and_Market(appInfo, 'test');
        
        ApplicantInfoHelper.syncOppFields(op.Id, appInfo);
        
        ApplicantInfoHelper.syncLeadFields(leHC1, appInfo);
        
        ApplicantInfoHelper.syncAccountFields(account.Id, appInfo);
        
        
        test.stoptest();
        
      }
     
    }
    static testMethod void myUnitTest2() {
      List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
      Account PTAcc = new Account(FirstName = 'Test_Old', LastName='VP',personEmail='ptemail@acc.com',Phone='3432323',RecordTypeId = participantRecordType[0].Id);
      insert PTAcc;
      User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
      RecordType rtWTPT= [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1]; 
        System.runAs(sysAdmin){
        
       
            
         //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-old', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  /*Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,*/ Intrax_Program__c = 'Work Travel',
                                                                  Application_Stage__c = 'Accepted', Account__c=PTAcc.Id,
                                                                  Application_Level__c ='Main', RecordTypeId = rtWTPT.Id, 
                                                                  Engagement_Start__c = System.today(), createdBy__c = sysAdmin.Id);
        insert appInfo;
        Person_Info__c p=  new Person_Info__c();
        p.Applicant_Info__c=appInfo.Id;
        p.email__c='ptemail@acc.com';
        insert p;
        Member__c m= new Member__c();
        m.Account_name__c=PTAcc.Id;
        m.First_Name__c='Test';
        insert m;
        Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-new', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  /*Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,*/ Intrax_Program__c = 'Work Travel',
                                                                  Application_Stage__c = 'Working', Account__c=PTAcc.Id,
                                                                  Application_Level__c ='Main', RecordTypeId = rtWTPT.Id, 
                                                                  Engagement_Start__c = System.today(), createdBy__c = sysAdmin.Id);
        insert appInfo1;
        Person_Info__c p1=  new Person_Info__c();
        p1.Applicant_Info__c=appInfo1.Id;
        p1.email__c='ptemail@acc.com';
        p1.Role__c='Student';
        p1.Primary_Applicant__c=true;
        insert p1;
        test.starttest();
        
        ApplicantInfoHelper controller = new ApplicantInfoHelper();
        test.stoptest();
        
      }
        
    }
    
}