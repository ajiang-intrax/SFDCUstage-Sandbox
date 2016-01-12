@isTest(seeAllData = true)
private class Test_apc_resource_controller 
{
	static testMethod void myUnitTest()
	{
		//Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
		//Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Contact
        Contact contact1 = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test1@test1.com');
        insert contact1;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
            insert user;
            
            User user1 = new User(Alias = 'alias123', Email = 'testUser1@test1.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test1.com', User_Interests__c='Hosting an au pair');
            
            insert user1;
            
             RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
             
            Portal_Content__c cont = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Participant', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'Applying');
		    insert cont;
		    
		    Portal_Content__c cont1 = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Participant', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'Matching');
		    insert cont1;
		    
		    Portal_Content__c cont2 = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Participant', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'On Program');
		    insert cont2;
            
            Applicant_Info__c appInfoAPCPT = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                                  Partner_Intrax_Id__c = sAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Engagement_Start__c = System.today()-2, Accommodation_Preference__c = 'Homestay',Application_Level__c='Main',Intrax_Program__c='AuPairCare',Application_Type__c='Original',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfoAPCPT;
                
                RecordType rtAPCHF = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
            
           
                
            
            apc_resource_controller apr = new apc_resource_controller();
            apr.showResources();
            
            System.runAs(user)
            {
            	apc_resource_controller apr1 = new apc_resource_controller();
            	apr1.showResources();
            }
           
	}
	
	static testMethod void myUnitTest1()
	{
		//Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
		//Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Contact
        Contact contact1 = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test1@test1.com');
        insert contact1;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
            insert user;
            
            User user1 = new User(Alias = 'alias123', Email = 'testUser1@test1.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test1.com', User_Interests__c='Hosting an au pair');
            
            insert user1;
            
             RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
            
            
                RecordType rtAPCHF = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
                
                
            Portal_Content__c cont = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Host', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'Applying');
		    insert cont;
		    
		    Portal_Content__c cont1 = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Host', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'Matching');
		    insert cont1;
		    
		    Portal_Content__c cont2 = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Host', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'On Program');
		    insert cont2;
            
            Applicant_Info__c appInfoAPCHF = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                                  Partner_Intrax_Id__c = sAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Curfew_Indicated__c = 'No',RecordTypeId = rtAPCHF.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Language_3__c='English',Language_2__c='',Language_1__c='',
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
                                                                  Engagement_Start__c = System.today()-2, Accommodation_Preference__c = 'Homestay',Application_Level__c='Main',Intrax_Program__c='AuPairCare',Application_Type__c='Original',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user1.Id);
                insert appInfoAPCHF;
            
            apc_resource_controller apr = new apc_resource_controller();
            apr.showResources();
            apr.KeySearch = 'Test';
           
            System.runAs(user1)
            {
            	apc_resource_controller apr2 = new apc_resource_controller();
            	apr2.showResources();
            }
	}
	
	
	static testMethod void myUnitTest2()
	{
		//Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
		//Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Contact
        Contact contact1 = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test1@test1.com');
        insert contact1;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
            insert user;
            
            User user1 = new User(Alias = 'alias123', Email = 'testUser1@test1.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test1.com', User_Interests__c='Hosting an au pair');
            
            insert user1;
            
             RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
            
            
                RecordType rtAPCHF = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
                
                
            Portal_Content__c cont = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Host', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'Applying');
		    insert cont;
		    
		    Portal_Content__c cont1 = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Host', Body__c = 'Test Test', Category__c= 'Program Information', Program_Stage__c = 'Matching');
		    insert cont1;
		    
		    Portal_Content__c cont2 = new Portal_Content__c(Name='Test', Subject__c='test',Intrax_Program__c = 'AuPairCare', Type__c = 'Resource', Status__c = 'Active', User_Type__c = 'Host', Category__c= 'Program Information', Program_Stage__c = 'On Program', Body__c = 'Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test');
		    insert cont2;
            
           
            apc_resource_controller apr = new apc_resource_controller();
            apr.showResources();
                   
            ApexPages.currentPage().getParameters().put('cat', 'Program Information');
            ApexPages.currentPage().getParameters().put('kSearch', 'test');
            apr.showCatResourceDetails();
            
            ApexPages.currentPage().getParameters().put('cId', cont2.Id);
            apr.showResourceDetails();
            
            ApexPages.currentPage().getParameters().put('cName', cont2.name);
            apr.showResourceDetails();
            
            ApexPages.currentPage().getParameters().put('cat', 'Program Information');
            ApexPages.currentPage().getParameters().put('kSearch', '');
            apr.showCatResourceDetails();
	}
}