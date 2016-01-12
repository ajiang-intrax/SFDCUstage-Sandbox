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

@isTest(seeAllData=true)

private class Test_CloneApp_Controller {

    static testMethod void myUnitTest() {
        
        Account participantInfo = new Account(FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
                                                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',OwnerId = UserInfo.getUserId());
        
        insert participantInfo;
        
        Contact co = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: participantInfo.Id];
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User currentUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        User user1 = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    User_Interests__c ='Becoming a high school exchange student',Type__c = 'Participant',
                                    ContactId = co.Id, Intrax_Id__c = participantInfo.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
        
        insert user1;
        
        RecordType hfRecType = [Select Id from RecordType where Name = 'Ayusa HF' and SobjectType = 'Applicant_Info__c'];
        RecordType ApcRecType = [Select Id from RecordType where Name = 'AuPairCare PT' and SobjectType = 'Applicant_Info__c'];
        
        Applicant_Info__c appInfoTest = new Applicant_Info__c(Name = 'test',  Account__c = participantInfo.Id, RecordTypeId = hfRecType.Id, Home_Street_1__c = 'test',
                                                                        Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family',
                                                                        Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',
                                                                        Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Program_Year__c = '2014',
                                                                        Intrax_Program_Options__c = 'Ayusa High School', Sys_Allow_Cloning__c = true, Application_Stage__c = 'Accepted',
                                                                        CreatedBy__c = user1.Id);
        system.runas(currentUser){
         insert appInfoTest;
        }
                                
        Applicant_Info__c appInfoCloneTest = new Applicant_Info__c(Name = 'test', Account__c = participantInfo.Id, RecordTypeId = hfRecType.Id, Home_Street_1__c = 'test',
                                                                    Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family',
                                                                    Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test', Program_Year__c = '2014',
                                                                    Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Accepted',
                                                                    Intrax_Program_Options__c = 'Ayusa High School', Sys_Allow_Cloning__c = true);
        
        
        //system.runas(currentUser){
            //insert appInfoCloneTest;
       // }
        
        
      
        Person_Info__c personInfoTest = new Person_Info__c(Name = 'test', First_Name__c = 'test', Middle_Name__c = 'test', Last_Name__c = 'test', Mobile__c = '654123654',
                                                            Email__c = 'test@test.com', Education_Level__c = 'University', Profession__c = 'test', Employer_Name__c = 'test', Title__c = 'test', Work_Phone__c = '698546321',
                                                            Work_Supervisor__c = 'test', Interests__c = 'Basketball', Community_Service__c = 'test', Preferred_Phone_Type__c = 'Mobile', Gender__c = 'Male', Role__c = 'Parent',
                                                            Role_Other__c = 'test', Residency_Status__c = 'test', Primary_Applicant__c = true, Family_Member__c = true,  Applicant_Info__c = appInfoTest.Id);
        insert personInfoTest;
        
        Member__c memberTest = new Member__c(Name = 'test',Account_Name__c = participantInfo.Id , First_Name__c = 'test', Last_Name__c = 'test', Role__c = 'Parent', Gender__c = 'male', Email__c = 'test@test.com', Mobile__c = '654123654', Phone__c = '987456321',Profession__c = 'test', Emergency_Contact_Indicated__c = 'Yes', Family_Member__c = true);
        insert memberTest;
        
        School__c schoolTest = new School__c(Name = 'test', Name__c = 'test', Street__c = 'test', City__c = 'test', State__c = 'test', Postal_Code__c = '69857', Country__c = 'Spain', Category__c = 'Public', Contact_Name__c = 'test', Contact_Title__c = 'test', Phone__c = '698369369',Email__c = 'test@test.com', Student_Census__c = 4, Applicant_Info__c = appInfoTest.Id);
        insert schoolTest;
        
        Location__c locationTest = new Location__c(Name = 'test', Occupancy_Start__c = date.parse('02/02/2013'), Occupancy_End__c = date.parse('03/02/2013'), City__c = 'test', State__c = 'test', Postal_Code__c = '66954', Applicant_Info__c = appInfoTest.Id);
        insert locationTest;
        
        Essay__c Essaytest= new Essay__c (Name = 'test',Applicant_Info__c = appInfoTest.Id);
        insert Essaytest;
        
        //Case 1 everything OK      
        system.runAs(user1){
        test.startTest();
        
        //CASE 1
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(appInfoTest);
        CloneApp_Controller cac = new CloneApp_Controller(sc);
        cac.applicantInfo = appInfoTest; 
        
        //cac.deleteAllowCloning();       
        //cac.CloneApp();
        //cac.applicantClone(appInfoTest);
       
        test.stopTest();
        }
        
    }
    
    
     static testMethod void myUnitTest3() {
        
        Account participantInfo = new Account(FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
                                                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',OwnerId = UserInfo.getUserId());
        
        insert participantInfo;
        
        Contact co = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: participantInfo.Id];
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User currentUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        User user1 = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    User_Interests__c ='Becoming a high school exchange student',Type__c = 'Participant',
                                    ContactId = co.Id, Intrax_Id__c = participantInfo.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
        
        insert user1;
        
        RecordType hfRecType = [Select Id from RecordType where Name = 'Ayusa HF' and SobjectType = 'Applicant_Info__c'];
        RecordType ApcRecType = [Select Id from RecordType where Name = 'AuPairCare PT' and SobjectType = 'Applicant_Info__c'];
        
        Applicant_Info__c appInfoTest = new Applicant_Info__c(Name = 'test',  Account__c = participantInfo.Id, RecordTypeId = hfRecType.Id, Home_Street_1__c = 'test',
                                                                        Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family',
                                                                        Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',
                                                                        Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Program_Year__c = '2014',
                                                                        Intrax_Program_Options__c = 'Ayusa High School', Sys_Allow_Cloning__c = true, Application_Stage__c = 'Accepted',
                                                                        CreatedBy__c = user1.Id);
        //system.runas(currentUser){
            upsert appInfoTest;
        //}
                                
        Applicant_Info__c appInfoCloneTest = new Applicant_Info__c(Name = 'test', Account__c = participantInfo.Id, RecordTypeId = hfRecType.Id, Home_Street_1__c = 'test',
                                                                    Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family',
                                                                    Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test', Program_Year__c = '2014',
                                                                    Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Accepted',
                                                                    Intrax_Program_Options__c = 'Ayusa High School', Sys_Allow_Cloning__c = true);
        
        
        system.runas(currentUser){
            insert appInfoCloneTest;
        }
        
        
      
        Person_Info__c personInfoTest = new Person_Info__c(Name = 'test', First_Name__c = 'test', Middle_Name__c = 'test', Last_Name__c = 'test', Mobile__c = '654123654',
                                                            Email__c = 'test@test.com', Education_Level__c = 'University', Profession__c = 'test', Employer_Name__c = 'test', Title__c = 'test', Work_Phone__c = '698546321',
                                                            Work_Supervisor__c = 'test', Interests__c = 'Basketball', Community_Service__c = 'test', Preferred_Phone_Type__c = 'Mobile', Gender__c = 'Male', Role__c = 'Parent',
                                                            Role_Other__c = 'test', Residency_Status__c = 'test', Primary_Applicant__c = true, Family_Member__c = true,  Applicant_Info__c = appInfoTest.Id);
        insert personInfoTest;
        
        Member__c memberTest = new Member__c(Name = 'test',Account_Name__c = participantInfo.Id , First_Name__c = 'test', Last_Name__c = 'test', Role__c = 'Parent', Gender__c = 'male', Email__c = 'test@test.com', Mobile__c = '654123654', Phone__c = '987456321',Profession__c = 'test', Emergency_Contact_Indicated__c = 'Yes', Family_Member__c = true);
        insert memberTest;
        
        School__c schoolTest = new School__c(Name = 'test', Name__c = 'test', Street__c = 'test', City__c = 'test', State__c = 'test', Postal_Code__c = '69857', Country__c = 'Spain', Category__c = 'Public', Contact_Name__c = 'test', Contact_Title__c = 'test', Phone__c = '698369369',Email__c = 'test@test.com', Student_Census__c = 4, Applicant_Info__c = appInfoTest.Id);
        insert schoolTest;
        
        Location__c locationTest = new Location__c(Name = 'test', Occupancy_Start__c = date.parse('02/02/2013'), Occupancy_End__c = date.parse('03/02/2013'), City__c = 'test', State__c = 'test', Postal_Code__c = '66954', Applicant_Info__c = appInfoTest.Id);
        insert locationTest;
        
        Essay__c Essaytest= new Essay__c (Name = 'test',Applicant_Info__c = appInfoTest.Id);
        insert Essaytest;
        
        //Case 1 everything OK      
        system.runAs(user1){
        test.startTest();
        
        //CASE 1
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(appInfoTest);
        CloneApp_Controller cac = new CloneApp_Controller(sc);
        cac.applicantInfo = appInfoTest; 
        
       
        //CloneApp_Controller.personPaClone(appInfoTest, appInfoCloneTest);
        //CloneApp_Controller.memberClone(appInfoTest, appInfoCloneTest);
        //cac.schoolClone(appInfoTest, appInfoCloneTest);             
       
        test.stopTest();
        }
        
    }
    
        static testMethod void myUnitTest2() {
        //APC
         Account participantInfo = new Account(FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
                                                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',OwnerId = UserInfo.getUserId());
         insert participantInfo;
         Contact co = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: participantInfo.Id limit 1];
         list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
         RecordType ApcRecType = [Select Id from RecordType where Name = 'AuPairCare PT' and SobjectType = 'Applicant_Info__c'];
         User user1 = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    User_Interests__c ='Becoming a high school exchange student',Type__c = 'Participant',
                                    ContactId = co.Id,
                                    Username = Math.random() + '@test.com');
        
         insert user1;
         
         Applicant_Info__c appInfoApcTest = new Applicant_Info__c(Name = 'test',  RecordTypeId = ApcRecType.Id, Home_Street_1__c = 'test',
                                                                        Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test2', Home_Country__c = 'test', Type__c = 'Participant',
                                                                        Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',
                                                                        Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo',
                                                                        Intrax_Program_Options__c = 'AuPairCare', Sys_Allow_Cloning__c = true, Application_Stage__c = 'Accepted',Intrax_Program__c='AuPairCare',
                                                                        CreatedBy__c = user1.Id);
        
        insert appInfoApcTest;
        
        Applicant_Info__c appInfoApcCloneTest = new Applicant_Info__c(Name = 'test', Account__c = participantInfo.Id, RecordTypeId = ApcRecType.Id, Home_Street_1__c = 'test',
                                                                    Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Participant',
                                                                    Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',
                                                                    Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Accepted',
                                                                    Intrax_Program_Options__c = 'Ayusa High School', Sys_Allow_Cloning__c = true,Intrax_Program__c='AuPairCare',
                                                                    CreatedBy__c = user1.Id);
        
        insert appInfoApcCloneTest;
        
        
        Person_Info__c personInfoTest = new Person_Info__c(Name = 'test', First_Name__c = 'test', Middle_Name__c = 'test', Last_Name__c = 'test', Mobile__c = '654123654',
                                                            Email__c = 'test@test.com', Education_Level__c = 'University', Profession__c = 'test', Employer_Name__c = 'test', Title__c = 'test', Work_Phone__c = '698546321',
                                                            Work_Supervisor__c = 'test', Interests__c = 'Basketball', Community_Service__c = 'test', Preferred_Phone_Type__c = 'Mobile', Gender__c = 'Male', Role__c = 'Parent',
                                                            Role_Other__c = 'test', Residency_Status__c = 'test', Primary_Applicant__c = true, Family_Member__c = true,  Applicant_Info__c = appInfoApcTest.Id);
        insert personInfoTest;
        
        Experience__c ExperienceTest = new Experience__c (Name = 'test',Experience_Type__c='Aupair',Frequency__c='Weekly',Applicant_Info__c = appInfoApcTest.Id);
        insert ExperienceTest;
        
        Experience_Detail__c experDetails = new Experience_Detail__c(Name='test', Experience_Name__c=ExperienceTest.id);
        insert experDetails;
        
        Essay__c Essaytest= new Essay__c (Name = 'test',Applicant_Info__c = appInfoApcTest.Id);
        insert Essaytest;


            system.runAs(user1){
                
                test.startTest();
                
                ApexPages.currentPage().getParameters().put('cloned', 'True');
                ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(appInfoApcTest);
                CloneApp_Controller cac2 = new CloneApp_Controller(sc2);
                cac2.CloneAppApc();
                CloneApp_Controller.personPaCloneApc(appInfoApcTest , appInfoApcCloneTest);
                /*
                //CloneApp_Controller.essayCloneapc(appInfoApcTest , appInfoApcCloneTest );
                //CloneApp_Controller.experienceClone(appInfoApcTest , appInfoApcCloneTest);
                appInfoApcTest.Type__c='Participant';
                cac2.CloneAppApc();
                ApexPages.currentPage().getParameters().put('AppType', 'Renewal');
                ApexPages.currentPage().getParameters().put('vstate', 'Abc');
                cac2.CloneAppApc();
                CloneApp_Controller.essayCloneapc(appInfoApcTest, appInfoApcCloneTest);
                cac2.navigateToNewAppHome();
                cac2.getnewAppId();
                cac2.getcheckWorkingApps();
                cac2.checkLogin();
             	*/
                test.stopTest();
            }

    }
    
}