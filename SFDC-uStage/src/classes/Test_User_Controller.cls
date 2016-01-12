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
 
 
@isTest(SeeAllData=true)
private class Test_User_Controller { 

    
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
	        
	        User_Controller c1 = new User_Controller();
	        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(userIGI);
	        User_Controller c = new User_Controller(sc);
	               
	        c.activeUser = userIGI;
	        c.getActiveUserType();
	        c.getCheckHFUser();
	        c.getIsInternshipUser();
	        c.getIsWTUser();
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
	        
	        User_Controller c1 = new User_Controller();
	        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(userWT);
	        User_Controller c = new User_Controller(sc);
	               
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
        	test.stopTest();
        }
        
    }
}