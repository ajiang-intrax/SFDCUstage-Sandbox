@isTest(seeAllData=true)
private class Test_ParticipantPortalController
{
	static testMethod void myUnitTest() 
	{
		Test.startTest();
		//Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States', BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert account;
        
        //Fetch intract Id for this account id
        //Account hostAccount = [Select Id, Intrax_Id__c from Account where Id =: account.Id LIMIT 1];
        //System.debug('@@@@@@ value in hostAccount ' + hostAccount);
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States', BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert partnerAccount;
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        //Account
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com',BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert participantAccount;
        
        //Contact
        Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = participantAccount.Id, Program_Year__c = '2013',
                                                    Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started');
        insert opportunity;
        
        //Record Type
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Work Travel PT' Limit 1];
        
         
        User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) 
            {
                
                List<User> users = [select Id, Intrax_Id__c from User where Id = : userInfo.getUserId()]; 
                System.debug('######### value in user Id ' + users);
                 
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'CA', City__c = 'Fremont', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '94538',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = users[0].Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Work Travel', Partner_Account__c = partnerAccount.Id,
                                                                  Intrax_Program_Options__c = 'YES',
                                                                  CreatedBy__c=userInfo.getUserId());
                insert appInfo;
                
                //Personal Info
                /*Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17));
                insert personInfo;*/
                
                
                //Position
                Position__c position = new Position__c(Name = 'Test', Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id, RecordTypeId = constants.POS_WORK_TRAVEL);
                insert position;
                
                School__c school = new School__c(Name = 'Test School', Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Match
                Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned', 
                                                Engagement__c = engagement.Id, 
                                                Portal_Contact_ID__c = contact.Id,
                                                Interview_Status__c = 'Scheduled');
                insert match;
                
                //Trip
                Trip__c trip = new Trip__c(Match__c = match.Id, Engagement__c = engagement.Id);
                insert trip;
                
               	ParticipantPortalController controller = new ParticipantPortalController();
               
               	ApexPages.currentPage().getParameters().put('matchId', match.ID);
               	ParticipantPortalController controller1 = new ParticipantPortalController();
               
               	ApexPages.currentPage().getParameters().put('tripId', trip.ID);
               	//ParticipantPortalController controller2 = new ParticipantPortalController();
               	/*
               	PageReference pg = controller2.checkLogin();
               	PageReference pg1 = controller2.addTravelInfo();
               	PageReference pg2 = controller2.saveInfoOfTrip();
               	PageReference pg3 = controller2.updateIndividualTrip();
               	PageReference pg4 = controller2.backToTrips();
               	PageReference pg5 = controller2.backToPartcipant();
               	PageReference pg6 = controller2.backToMatches();
               	controller2.deleteTrip();
               	*/
                //ParticipantPortalController controller3 = new ParticipantPortalController();
               
               	Test.stopTest();
            }
                
	}		
	
	static testMethod void myUnitTest2() 
	{
		Test.startTest();
		//Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States', BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert account;
        
        //Fetch intract Id for this account id
        //Account hostAccount = [Select Id, Intrax_Id__c from Account where Id =: account.Id LIMIT 1];
        //System.debug('@@@@@@ value in hostAccount ' + hostAccount);
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States', BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert partnerAccount;
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        //Account
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com',BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
        insert participantAccount;
        
        //Contact
        Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = participantAccount.Id, Program_Year__c = '2013',
                                                    Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started');
        insert opportunity;
        
        //Record Type
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Work Travel PT' Limit 1];
        
         
        User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) 
            {
                
                List<User> users = [select Id, Intrax_Id__c from User where Id = : userInfo.getUserId()]; 
                System.debug('######### value in user Id ' + users);
                 
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'CA', City__c = 'Fremont', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '94538',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = users[0].Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Work Travel', Partner_Account__c = partnerAccount.Id,
                                                                  Intrax_Program_Options__c = 'YES',
                                                                  CreatedBy__c=userInfo.getUserId());
                insert appInfo;
                
                //Personal Info
                /*Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17));
                insert personInfo;*/
                
                
                //Position
                Position__c position = new Position__c(Name = 'Test', Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id, RecordTypeId = constants.POS_WORK_TRAVEL);
                insert position;
                
                School__c school = new School__c(Name = 'Test School', Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Match
                Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned', 
                                                Engagement__c = engagement.Id, 
                                                Portal_Contact_ID__c = contact.Id,
                                                Interview_Status__c = 'Scheduled');
                insert match;
                
                //Trip
                Trip__c trip = new Trip__c(Match__c = match.Id, Engagement__c = engagement.Id);
                insert trip;
                
               	//ParticipantPortalController controller = new ParticipantPortalController();
               
               	ApexPages.currentPage().getParameters().put('matchId', match.ID);
               	//ParticipantPortalController controller1 = new ParticipantPortalController();
               
               	ApexPages.currentPage().getParameters().put('tripId', trip.ID);
               	ParticipantPortalController controller2 = new ParticipantPortalController();
               	PageReference pg = controller2.checkLogin();
               	PageReference pg1 = controller2.addTravelInfo();
               	PageReference pg2 = controller2.saveInfoOfTrip();
               	PageReference pg3 = controller2.updateIndividualTrip();
               	PageReference pg4 = controller2.backToTrips();
               	PageReference pg5 = controller2.backToPartcipant();
               	PageReference pg6 = controller2.backToMatches();
               	controller2.deleteTrip();
               	
                //ParticipantPortalController controller3 = new ParticipantPortalController();
              Engagement__c engagement_n = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2015', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
              insert engagement_n; 
               List<User> sysAdmins = [select Id from user where userName = : Constants.Sys_Admin];
        	  if(sysAdmins!=null && sysAdmins.size()>0)
        	  {
        	  	Notification__c nt = new Notification__c ( Type__c = 'Visa Interview', Engagement__c = engagement_n.id, Status__c = 'Not Started', OwnerID = sysAdmins[0].Id);
          		insert nt;
          		
          		Notification__c nt1 = new Notification__c ( Type__c = 'Visa Result', Engagement__c = engagement_n.id, Status__c = 'Not Started', OwnerID = sysAdmins[0].Id);
          		insert nt1;
          		
          		
        	  }
               
               
               	Test.stopTest();
            }
                
	}		
}