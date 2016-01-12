@isTest(seeAllData=false)
private class Test_IPUTriggerHelper{

    static testMethod void myUnitTest() {
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        
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
                
                Education__c ed1 = new Education__c(Institution_Type__c = 'Secondary-School-Diploma', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoAPCPT.Id);
                insert ed1;
                            
                
                Education__c ed2 = new Education__c(Institution_Type__c = 'University/College', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoAPCPT.Id);
                insert ed2;
                
                Education__c ed3 = new Education__c(Institution_Type__c = 'Vocational Training', Program_Type__c = 'Bachelor', Institution_Name__c = 'UPCT', Field_of_Study__c = 'Engineering', 
                Graduation_Date__c = date.newInstance(2013, 6, 15), applicant_Info__c = appInfoAPCPT.Id);
                insert ed3;
                
                Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Applicant_Info__c = appInfoAPCPT.Id,Document_Type__c='Secondary-School-Diploma',Education__c=ed2.id);
                insert ipUpload;
                
                
     IPUTriggerHelper ng = new IPUTriggerHelper();
     //IPUTriggerHelper.deleteIPU(ipUpload.Id);
     
    }
    
}