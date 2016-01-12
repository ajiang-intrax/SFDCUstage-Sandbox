@isTest
private class Test_MapPersonToReferenceAPC {

    static testMethod void myUnitTest() {
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
                                                    First_Name__c  = 'test', Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                Experience__c experience = new Experience__c(Name='ExperienceName', Frequency__c = 'Daily', Applicant_Info__c=appInfo.Id, IsExperienced__c = true, Start_Date__c = date.today() - 100, End_Date__c = date.today() + 10, Employer_Name__c = 'Test');
                insert experience;
                
                Reference__c reference = new Reference__c(Name='ReferenceName', Reference_Status__c = 'Active',
                Primary_Applicant_Id__c = personInfo.id , Experience_Name__c = experience.id, Applicant_Info__c = appInfo.id);
                insert reference;
                
                Reference__c reference01 = new Reference__c(Name='ReferenceName', Reference_Status__c = 'Active',  Status__c = 'Confirmed',
                Primary_Applicant_Id__c = personInfo.id , Experience_Name__c = experience.id, Applicant_Info__c = appInfo.id);
                insert reference01;
                
                Test.startTest(); 
                
                //Calling Controller
                
                String expId = experience.id;
                MapPersonToReferenceAPC.MapExperienceToRef(expId);
                String perId = personinfo.id;
                MapPersonToReferenceAPC.MapPersonToRef(perId);
                delete reference;
                delete reference01;
                MapPersonToReferenceAPC.MapExperienceToRef(expId);
                MapPersonToReferenceAPC.MapPersonToRef(perId);
                Test.stopTest();
                
            }
        }
    }
}