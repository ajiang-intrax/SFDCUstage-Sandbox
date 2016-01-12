@isTest(seeAllData=true)
public class Test_ResourcesController 
{
	static testMethod void myResourceUnitTest()
	{
		test.startTest();
		/*ResourcesController RC = new ResourcesController();
		RC.allWTDocuments();
		
		PageReference pc = RC.getDocumentUrl();*/
		
		Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
    
       
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      
      System.debug('********profiles->'+profiles);
        
     
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Becoming a Work Travel Participant');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c = 'Finding an Internship');
            
            insert user1;
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program_Options__c = 'Business Internship'
          );
          insert ca;
          System.runAs(user)
          {
          	ResourcesController RC = new ResourcesController();
			RC.allWTDocuments();
		
			PageReference pc = RC.getDocumentUrl();
          }
          
         
          test.stopTest();
	}
	
	static testMethod void myResourceUnitTest1()
	{
		test.startTest();
		/*ResourcesController RC = new ResourcesController();
		RC.allWTDocuments();
		
		PageReference pc = RC.getDocumentUrl();*/
		
		Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
    
       
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      
      System.debug('********profiles->'+profiles);
        
     
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Finding an Internship');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c = 'Finding an Internship');
            
            insert user1;
            
            system.debug('**User1***'+user1.id);
            system.debug('**User***'+user.id);
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won', Payment_Received__c = date.today());
        insert op1;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program_Options__c = 'Business Internship'
          );
          insert ca;
          
           RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='ICD Intern PT' Limit 1];
          
          Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = ca.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = p.Id, CreatedBy__c = user1.id,
                                                                  Country_of_Interest__c = 'United States', Opportunity_Name__c = op.Id, ownerId = user1.id
                                                                  );
          insert appInfo;
          
          
         
          appInfo.CreatedBy__c = user1.id;
          appInfo.ownerid = user1.id;
          update appInfo;
          
         
          
          System.runAs(user1)
          {
          	System.debug('appInfo.CreatedBy__c: ' + appInfo.CreatedBy__c);
          	System.debug('appInfo.OwnerID: ' + appInfo.OwnerID);
          	System.debug('Current User1: ' + UserInfo.getUserId());
          	ResourcesController RC1 = new ResourcesController();
			RC1.allWTDocuments();
			list<Applicant_Info__c> applists1 = [Select ID  From Applicant_Info__c where id =: appInfo.id order by LastModifiedDate DESC]; 
			system.debug('***applists1****'+applists1);
			system.debug('***applists1.size()****'+applists1.size());
			PageReference pc1 = RC1.getDocumentUrl();
			System.debug('Current User1: ' + UserInfo.getUserId());
          }
          
           System.runAs(user)
          {
          	System.debug('Current User: ' + UserInfo.getUserId());
          	ResourcesController RC2 = new ResourcesController();
			RC2.allWTDocuments();
			System.debug('Current User1 ' + UserInfo.getUserId());
		  }
          
          test.stopTest();
	}
	
	static testMethod void myResourceUnitTest2()
	{
		test.startTest();
		/*ResourcesController RC = new ResourcesController();
		RC.allWTDocuments();
		
		PageReference pc = RC.getDocumentUrl();*/
		
		Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
    
       
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      
      System.debug('********profiles->'+profiles);
        
     
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Finding an Internship');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c = 'Finding an Internship');
            
            insert user1;
            
            system.debug('**User1***'+user1.id);
            system.debug('**User***'+user.id);
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won', Payment_Received__c = date.today());
        insert op1;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program_Options__c = 'Business Internship'
          );
          insert ca;
          
           Match__c m = new Match__c(
            Name = 'Web Design - Match', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          
           RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='ICD Intern PT' Limit 1];
          
          Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = ca.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = p.Id, CreatedBy__c = user1.id,
                                                                  Country_of_Interest__c = 'United States', Opportunity_Name__c = op.Id, ownerId = user1.id
                                                                  );
          insert appInfo;
          
         
          
           appInfo.CreatedBy__c = user1.id;
          appInfo.ownerid = user1.id;
          update appInfo;
          
         
          
          System.runAs(user1)
          {
          	System.debug('Current User1: ' + UserInfo.getUserId());
          	ResourcesController RC1 = new ResourcesController();
			RC1.allWTDocuments();
			System.debug('Current User1: ' + UserInfo.getUserId());
		
			PageReference pc1 = RC1.getDocumentUrl();
			
          }
          
           System.runAs(user)
          {
          	System.debug('Current User: ' + UserInfo.getUserId());
          	ResourcesController RC2 = new ResourcesController();
			RC2.allWTDocuments();
			System.debug('Current User: ' + UserInfo.getUserId());
		  }
          
          test.stopTest();
	}
	
	
	static testMethod void myResourceUnitTest3()
	{
		test.startTest();
		/*ResourcesController RC = new ResourcesController();
		RC.allWTDocuments();
		
		PageReference pc = RC.getDocumentUrl();*/
		
		Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
    
       
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      
      System.debug('********profiles->'+profiles);
        
     
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com',User_Interests__c = 'Finding an Internship');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c = 'Finding an Internship');
            
            insert user1;
            
            system.debug('**User1***'+user1.id);
            system.debug('**User***'+user.id);
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won', Payment_Received__c = date.today());
        insert op1;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program_Options__c = 'Business Internship'
          );
          insert ca;
          
           RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='ICD Intern PT' Limit 1];
          
         
          
          Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = ca.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = p.Id, CreatedBy__c = user.id,
                                                                  Country_of_Interest__c = 'United States', Opportunity_Name__c = op1.Id, ownerId = user.id
                                                                  );
          insert appInfo1;
         
          
          
          appInfo1.CreatedBy__c = user.id;
          appInfo1.ownerid = user.id;
          update appInfo1;
          
          System.runAs(user1)
          {
          	ResourcesController RC1 = new ResourcesController();
			RC1.allWTDocuments();
			list<Applicant_Info__c> applists1 = [Select ID  From Applicant_Info__c where id =: appInfo1.id order by LastModifiedDate DESC]; 
			system.debug('***applists1****'+applists1);
			system.debug('***applists1.size()****'+applists1.size());
			PageReference pc1 = RC1.getDocumentUrl();
			System.debug('Current User1: ' + UserInfo.getUserId());
          }
          
           System.runAs(user)
          {
          	System.debug('Current User: ' + UserInfo.getUserId());
          	ResourcesController RC2 = new ResourcesController();
			RC2.allWTDocuments();
			System.debug('Current User1 ' + UserInfo.getUserId());
		  }
          
          test.stopTest();
	}
	
	
}