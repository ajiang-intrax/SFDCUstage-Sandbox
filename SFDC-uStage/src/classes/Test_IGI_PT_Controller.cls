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

private class Test_IGI_PT_Controller {

    static testMethod void myUnitTest() {
      
      System.debug('********Test_IGI_PT_Controller BEGIN');
    
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      
      //sAccount__c sacc_pt1 = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test PT1'];
      
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      
      //sAccount__c sacc_hc1 = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC1'];
      
      
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
    
       
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      //sAccount__c sacc_pt = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test PT'];
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
      //sAccount__c sacc_hc = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC'];
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      
      System.debug('********profiles->'+profiles);
        
      if(profiles.size() > 0){
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
            
         //   user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
        //    user1.Type__c = portalAccount1.type;
        //    update user1;

            
            //Create a new test account and set contact as portal contact
            //Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = c.Id, type = 'Participant');
            //insert portalAccount;
            
            //Fetch intract Id for this account id
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
           // user.Intrax_Id__c = portalAccount.Intrax_Id__c;
          //  user.Type__c = portalAccount.type;
          //  update user;
            
            
          Opportunity op = new Opportunity(
          Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
          Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
         closeDate = date.today(), StageName = 'Closed Won');
    	 insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
          Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id,Visa_Interview_Date__c=System.today().adddays(-5),Visa_Interview_Status__c = 'Declined – Appealing Decision');
          insert ca;
          /*
          Match__c m = new Match__c(
            Name = 'Web Design - Match', Interview_Status__c = 'Initiated', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending',Interview_Date__c=System.now().adddays(5));         
          insert m;        
          
          Match__c m1 = new Match__c(
            Name = 'Web Design - Match', Interview_Status__c = 'Initiated' , Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending',Interview_Request_HC1__c=System.now().adddays(10), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;            
          */
          list<Engagement__c > candList =  new list<Engagement__c >();
          candList.add(ca);
          
          List<Match__c> matchlist=new list<Match__c>();
            //matchlist.add(m);
            //matchlist.add(m1);
          User admin = [SELECT Id, Name FROM User WHERE name =: 'ULM Admin' LIMIT 1];
          
          System.debug('********admin->'+admin);
          
      
            system.runAs(admin){
               System.debug('********INadmin');
              test.startTest();
              
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
                
              //General Page test
              IGI_PT_Controller controller = new IGI_PT_Controller(sc);
              IGI_PT_Controller controller1 = new IGI_PT_Controller();
              controller1.getIsDepartureTripIndicated();
         	  //controller1.applyForPosition(m2.id);
              
              
               System.debug('********IGI_PT_Controller'+controller);
              //Detail Page Test
              //ApexPages.currentPage().getParameters().put('mid', m.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              IGI_PT_Controller controller2 = new IGI_PT_Controller(sc);
              //controller2.RetrieveMatches();
              controller2.engagementInfo = candList; 
              //controller2.matchInfo = m;
              controller2.matchInfoList = matchlist;
              controller2.isAccountCreated =true;
              controller2.navigator();
              controller2.checkLogin();
              
              test.stopTest();
            }
            
             System.debug('********Test_IGI_PT_Controller END');
            
      }
    
    }
    static testMethod void myUnitTest2() {
    	
    	 List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
    	
      	
      	Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
		Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];

		//Portal User
		User userigi = new User(Alias = 'alias', Email = 'testUser@test.igi.com', EmailEncodingKey = 'UTF-8', 
								LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
								ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
								ContactId = c1.Id, Intrax_Id__c ='Test',
								Username = Math.random() + '@test.com', User_Interests__c='Finding an Internship');
		insert userigi;
		System.runAs(userigi) {
			
		RecordType rtIGIPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
		RecordType OppsrtIGIPT = [select id, Name from RecordType where SobjectType='Opportunity' and Name='ICD Intern PT' Limit 1];
			
		 Account ac_pt = new Account(
         FirstName = 'Test2', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
         type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated');
      	 insert ac_pt;
      
  		Engagement__c caconf = new Engagement__c (
        Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id
      	);
     	insert caconf;
	
		Trip__c trip=new Trip__c(Name='TestTrip',Engagement__c=caconf.id,Arrival_To_Host_Community__c=True);
		insert trip;
		ApexPages.currentPage().getParameters().put('tId', trip.id);
							
		//Create a new test account and set contact as portal contact
		Account portalAccountpt = new Account(Name = 'TestName', Portal_Contact_Name__c = c1.Id, Type = 'Partner');
		insert portalAccountpt;
			
		//Fetch intract Id for this account id
        portalAccountpt = [Select Id, Intrax_Id__c from Account where Id =: portalAccountpt.Id];
		
		Applicant_Info__c appInfoIGIPT = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
														  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
														  Country__c = 'United States', Home_Phone__c = '12345',Intrax_Program_Category__c='Business',
														  Partner_Intrax_Id__c = portalAccountpt.Intrax_Id__c, Home_Responsibilities__c = 'Test',
														  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
														  State__c = 'CA', Live_With_Pets__c = 'No',Engagement__c=caconf.id,
														  Month_Arrival__c ='1', Allow_Intrax_To_Apply__c=True,
														  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test', 
														  Curfew_Indicated__c = 'No', RecordTypeId = rtIGIPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
														  Prior_Exchange_Experience__c = 'No',Language_3__c='English',Language_2__c='',Language_1__c='',
														  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
														  Engagement_Start__c = System.today()-2,Application_Level__c='Main',Intrax_Program__c='Internship',Application_Type__c='Orignal',Gender_Preference__c = 'female');
		insert appInfoIGIPT;
		system.debug('CreatedBy::::'+appInfoIGIPT.CreatedBy);
		
		Engagement__c ca = new Engagement__c (
        Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id,Visa_Interview_Date__c=System.today().adddays(-5),Visa_Interview_Status__c = 'Declined – Appealing Decision');
        insert ca;
		
		 Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
		
		
		
		Opportunity op = new Opportunity(
          Name = 'Test Opportunity', AccountId = ac_pt1.Id, RecordTypeId = OppsrtIGIPT.id, 
          Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
          closeDate = date.today(), StageName = 'Closed Won');
    	  insert op;
    	 
		Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1));
          insert p;
          
	   Match__c m2 = new Match__c(
            Name = 'Web Design - Match', Interview_Status__c = 'Completed' , Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending',Interview_Request_HC2__c=System.now().adddays(15), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m2;
	   
	  /* Match__c m3 = new Match__c(
        Name = 'Web Design - Match', Interview_Status__c = 'Completed' , Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
        Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending',Interview_Request_HC3__c=System.now().adddays(20));
          insert m3;*/
          
          
          Date d=date.today();

		
		
		test.startTest();
		  
		//  IGI_PT_Controller controller18 = new IGI_PT_Controller();
		
		  ApexPages.currentPage().getParameters().put('EnggID', ca.Id);
			  
	      
	      ApexPages.currentPage().getParameters().put('Apply', 'true');
          ApexPages.currentPage().getParameters().put('canc', 'true');
          ApexPages.currentPage().getParameters().put('noShow', 'true');
          ApexPages.currentPage().getParameters().put('removeMatch', 'true');
          ApexPages.currentPage().getParameters().put('rejMatch', 'true');
          ApexPages.currentPage().getParameters().put('Offer', 'true');
              
	      IGI_PT_Controller controller17 = new IGI_PT_Controller();
	      list<Engagement__c> engInfo = new list<Engagement__c>();
	      engInfo.add(ca);
	      controller17.engagementInfo = engInfo;
	    
	      
	      List<MatchWrapper> matchWrapList = new List<MatchWrapper>();
          matchWrapList = controller17.getlstMatchWrapper();
	      
	      ApexPages.currentPage().getParameters().put('EnggParam', ca.Id);
	      controller17.OrientationRedirect();
	      
	      ApexPages.currentPage().getParameters().put('ActionType', 'SaveInterviewDate');
	      controller17.SaveVisaDate();
	      
	      ApexPages.currentPage().getParameters().put('ActionType', 'SaveInterviewStatus');
	      //controller17.SaveVisaDate();
	      
	      ApexPages.currentPage().getParameters().put('type', 'arrival');
	      controller17.saveTrip();
	      ApexPages.currentPage().getParameters().put('type', 'departure');
	      controller17.saveTrip();
	      controller17.getIsArrivalTripIndicated();
	      controller17.ApplyforPosition='True';
	      controller17.removeMatch(m2.Id);
	      controller17.applyForPosition(m2.id);	 
	     
	      controller17.getlstMatchWrapper();
	      controller17.Initialize();
	       	          
	      test.stopTest();
		}
	     
    	
    }
    
     static testMethod void myUnitTest2a() {
    	
    	 List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
    	
      	Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
		Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
    

		//Portal User
		User userigi = new User(Alias = 'alias', Email = 'testUser@test.igi.com', EmailEncodingKey = 'UTF-8', 
								LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
								ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
								ContactId = c1.Id, Intrax_Id__c ='Test',
								Username = Math.random() + '@test.com', User_Interests__c='Finding an Internship');
		insert userigi;
		System.runAs(userigi) {
			
		RecordType rtIGIPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
		RecordType OppsrtIGIPT = [select id, Name from RecordType where SobjectType='Opportunity' and Name='ICD Intern PT' Limit 1];
			
		 Account ac_pt = new Account(
         FirstName = 'Test2', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
         type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated');
      	 insert ac_pt;
      
  		Engagement__c caconf = new Engagement__c (
        Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id
      	);
     	insert caconf;
	
		Trip__c trip=new Trip__c(Name='TestTrip',Engagement__c=caconf.id,Arrival_To_Host_Community__c=True);
		insert trip;
		ApexPages.currentPage().getParameters().put('tId', trip.id);
							
		//Create a new test account and set contact as portal contact
		Account portalAccountpt = new Account(Name = 'TestName', Portal_Contact_Name__c = c1.Id, Type = 'Partner');
		insert portalAccountpt;
			
		//Fetch intract Id for this account id
        portalAccountpt = [Select Id, Intrax_Id__c from Account where Id =: portalAccountpt.Id];
		
		Applicant_Info__c appInfoIGIPT = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
														  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
														  Country__c = 'United States', Home_Phone__c = '12345',Intrax_Program_Category__c='Business',
														  Partner_Intrax_Id__c = portalAccountpt.Intrax_Id__c, Home_Responsibilities__c = 'Test',
														  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
														  State__c = 'CA', Live_With_Pets__c = 'No',Engagement__c=caconf.id,
														  Month_Arrival__c ='1', Allow_Intrax_To_Apply__c=True,
														  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test', 
														  Curfew_Indicated__c = 'No', RecordTypeId = rtIGIPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
														  Prior_Exchange_Experience__c = 'No',Language_3__c='English',Language_2__c='',Language_1__c='',
														  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
														  Engagement_Start__c = System.today()-2,Application_Level__c='Main',Intrax_Program__c='Internship',Application_Type__c='Orignal',Gender_Preference__c = 'female');
		insert appInfoIGIPT;
		system.debug('CreatedBy::::'+appInfoIGIPT.CreatedBy);
		
		Engagement__c ca = new Engagement__c (
        Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id,Visa_Interview_Date__c=System.today().adddays(-5),Visa_Interview_Status__c = 'Declined – Appealing Decision');
        insert ca;
		
		 Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
		
		
		
		Opportunity op = new Opportunity(
          Name = 'Test Opportunity', AccountId = ac_pt1.Id, RecordTypeId = OppsrtIGIPT.id, 
          Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
          closeDate = date.today(), StageName = 'Closed Won');
    	  insert op;
    	 
		Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1));
          insert p;
          
	
	   
	 
          
          
          Date d=date.today();
          Match__c m4 = new Match__c(Name = 'Web Design - Match', Interview_Status__c = 'Initiated' , Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
        	Participant_Opportunity_Id__c = op.Id, start_date__c=date.today(),End_Date__c= d.addDays(30),Status__c = 'Interview Pending',Interview_Request_HC3__c=System.now().adddays(20));
          insert m4;
		
		
		test.startTest();
		  
		//  IGI_PT_Controller controller18 = new IGI_PT_Controller();
		
		  ApexPages.currentPage().getParameters().put('EnggID', ca.Id);
		  ApexPages.currentPage().getParameters().put('mId', m4.Id);		  
	      
	      ApexPages.currentPage().getParameters().put('Apply', 'true');
          ApexPages.currentPage().getParameters().put('canc', 'true');
          ApexPages.currentPage().getParameters().put('noShow', 'true');
          ApexPages.currentPage().getParameters().put('removeMatch', 'true');
          ApexPages.currentPage().getParameters().put('rejMatch', 'true');
          ApexPages.currentPage().getParameters().put('Offer', 'true');
              
	      IGI_PT_Controller controller17 = new IGI_PT_Controller();
	      list<Engagement__c> engInfo = new list<Engagement__c>();
	      engInfo.add(ca);
	      controller17.engagementInfo = engInfo;
	      controller17.mId = m4.Id;
	      
	      List<MatchWrapper> matchWrapList = new List<MatchWrapper>();
          matchWrapList = controller17.getlstMatchWrapper();
	      
	      ApexPages.currentPage().getParameters().put('EnggParam', ca.Id);
	      controller17.OrientationRedirect();
	      
	      ApexPages.currentPage().getParameters().put('ActionType', 'SaveInterviewDate');
	      controller17.SaveVisaDate();
	      

	      
	      ApexPages.currentPage().getParameters().put('type', 'arrival');
	      controller17.saveTrip();
	      ApexPages.currentPage().getParameters().put('type', 'departure');
	      controller17.saveTrip();
	      controller17.getIsArrivalTripIndicated();
	      controller17.ApplyforPosition='True';
	   
	     
            
	      controller17.getlstMatchWrapper();
	      controller17.Initialize();
	      //controller17.AcceptOffer(m3.Id);
	      controller17.RejectMatch(m4.Id);
	      controller17.cancelMatch(m4.Id);
	      controller17.UpdateNoShow(m4.Id);	
	      controller17.PTDeclinedInterview(m4.Id);
	      controller17.applyForPosition(m4.Id);
	      controller17.removeMatch(m4.Id);      
	      
	      //controller17.updateMatchInfo(matchWrapList);
	          
	      test.stopTest();
		}
	     
    	
    }
    
    
    // Test for PT with an associated group
    static testMethod void myUnitTest3() {
    	
    	list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
    	
      	
      	Account ac_pt1 = new Account(
		          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
		          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
		          OwnerId = UserInfo.getUserId()
		          );
        insert ac_pt1;
      
		Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];

		//Portal User
		/*User usertest3 = new User(Alias = 'alias', Email = 'testUser@test.igi.com', EmailEncodingKey = 'UTF-8', 
								LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
								ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
								ContactId = c1.Id, Intrax_Id__c ='Test',
								Username = Math.random() + '@test.com', User_Interests__c='Finding an Internship');
		insert usertest3;*/
        User admin = [SELECT Id, Name FROM User WHERE name =: 'ULM Admin' LIMIT 1];
		System.runAs(admin) {
			
		RecordType rtIGIPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
		RecordType OppsrtIGIPT = [select id, Name from RecordType where SobjectType='Opportunity' and Name='ICD Intern PT' Limit 1];
			
		 Account ac_pt = new Account(FirstName = 'Test2', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
							         type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated');
      	 insert ac_pt;
      
  		Engagement__c caconf = new Engagement__c ( Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program_Options__c = 'Business Internship');
     	insert caconf;
		
		/*
		Trip__c trip=new Trip__c(Name='TestTrip',Engagement__c=caconf.id,Arrival_To_Host_Community__c=True);
		insert trip;
		
		ApexPages.currentPage().getParameters().put('tId', trip.id);
		*/					
		//Create a new test account and set contact as portal contact
		Account portalAccountpt = new Account(Name = 'TestName', Portal_Contact_Name__c = c1.Id, Type = 'Partner');
		insert portalAccountpt;
			
		//Fetch intract Id for this account id
        portalAccountpt = [Select Id, Intrax_Id__c from Account where Id =: portalAccountpt.Id];
		
		Group__c gr = new Group__c(Name='Group Test',Intrax_Program_Category__c='Social Development', Intrax_program_option__c='WEST',Engagement_Start__c = date.today() + 50, Engagement_End__c = date.today() + 100, Location__c = 'Madrid', Country__c = 'Spain');
		insert gr;
		
		Intrax_Program_Upload__c ipu_invoice = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS', Group__c = gr.Id, Document_Type__c='Invoice');
      	insert ipu_invoice;
      
      	Intrax_Program_Upload__c ipu_group_upload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test2', Document_service__c  = 'DS', Group__c = gr.Id, Document_Type__c='University-Group-Uploads');
      	insert ipu_group_upload;
      	
      	Intrax_Program_Upload__c ipu_pre_departure = new Intrax_Program_Upload__c(Document_Guid__c = 'Test3', Document_service__c  = 'DS', Group__c = gr.Id, Document_Type__c='Pre-Departure-Orientation-Info');
      	insert ipu_pre_departure;
      	      	
		Applicant_Info__c appInfoIGIPT = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
														  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
														  Country__c = 'United States', Home_Phone__c = '12345',Intrax_Program_Category__c='Business',
														  Partner_Intrax_Id__c = portalAccountpt.Intrax_Id__c, Home_Responsibilities__c = 'Test',
														  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
														  State__c = 'CA', Live_With_Pets__c = 'No',Engagement__c=caconf.id, Group__c = gr.Id,
														  Month_Arrival__c ='1', Allow_Intrax_To_Apply__c=True, createdBy__c = admin.ID,
														  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test', 
														  Curfew_Indicated__c = 'No', RecordTypeId = rtIGIPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
														  Prior_Exchange_Experience__c = 'No',Language_3__c='English',Language_2__c='',Language_1__c='',
														  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
														  Engagement_Start__c = System.today()-2,Application_Level__c='Main',Intrax_Program__c='Internship',Application_Type__c='Orignal',Gender_Preference__c = 'female');
		
		insert appInfoIGIPT;
		
		Engagement__c ca = new Engagement__c ( Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id,Visa_Interview_Date__c=System.today().adddays(-5),Visa_Interview_Status__c = 'Declined – Appealing Decision');
        insert ca;
		
		Account ac_hc = new Account(Name = 'Test HC', type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      	insert ac_hc;
				
		Opportunity op = new Opportunity( Name = 'Test Opportunity', AccountId = ac_pt1.Id, RecordTypeId = OppsrtIGIPT.id, Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
          									closeDate = date.today(), StageName = 'Closed Won');
    	insert op;
    	 
		Position__c p = new Position__c(Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+30));
        
        insert p;
        		
		test.startTest();
		
		ApexPages.currentPage().getParameters().put('dType', 'Invoice');
      	ApexPages.currentPage().getParameters().put('groupId', gr.Id);
      	ApexPages.currentPage().getParameters().put('docGUID', 'Test');
      	
		IGI_PT_Controller controller = new IGI_PT_Controller();
		
		controller.load_by_doctype();
		controller.load_by_docGUID();
		controller.load(ipu_invoice);
		
		
        test.stopTest();
		}
	     
    	
    }
        
    static testMethod void myUnitTest4() {
      
      System.debug('********Test_IGI_PT_Controller BEGIN');
    
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
        
      if(profiles.size() > 0){
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
          insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
            
         //   user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
        //    user1.Type__c = portalAccount1.type;
        //    update user1;

            
            //Create a new test account and set contact as portal contact
            //Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = c.Id, type = 'Participant');
            //insert portalAccount;
            
            //Fetch intract Id for this account id
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
           // user.Intrax_Id__c = portalAccount.Intrax_Id__c;
          //  user.Type__c = portalAccount.type;
          //  update user;
            
            
          Opportunity op = new Opportunity(
          Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
          Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
         closeDate = date.today(), StageName = 'Closed Won');
    	 insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
          Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id,Visa_Interview_Date__c=System.today().adddays(-5),Visa_Interview_Status__c = 'Declined – Appealing Decision');
          insert ca;
          /*
          Match__c m = new Match__c(
            Name = 'Web Design - Match', Interview_Status__c = 'Initiated', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending',Interview_Date__c=System.now().adddays(5));         
          insert m;        
          
          Match__c m1 = new Match__c(
            Name = 'Web Design - Match', Interview_Status__c = 'Initiated' , Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending',Interview_Request_HC1__c=System.now().adddays(10), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;
          */
          list<Engagement__c > candList =  new list<Engagement__c >();
          candList.add(ca);
          
          List<Match__c> matchlist=new list<Match__c>();
          //matchlist.add(m);
          //matchlist.add(m1);
          User admin = [SELECT Id, Name FROM User WHERE name =: 'ULM Admin' LIMIT 1];
          
          System.debug('********admin->'+admin);
          
      
            system.runAs(admin){
               System.debug('********INadmin');
              test.startTest();
              
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
                
              //General Page test
              
              IGI_PT_Controller controller = new IGI_PT_Controller(sc);
              
              string Sched='true';
              string noShow;
              string remove;
              string removeMatch;
              string ReSchedSched;
              string IntDate;
              string InputInterview;
              string detail;
              string MakOff;
              string Offer;
              string rejMatch;
              string reSched;
              string reSchedule;
              string initCancel;
              string schreSchedule;
              string schCanc;
              string schreSched;
              string schCancel;
              string canc;
              string SaveCanc;
              string SaveSchreSchedule;
              string SaveSchCanc;
                            
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              // ApexPages.currentPage().getParameters().put('SaveInterview', 'true');
              //ApexPages.currentPage().getParameters().put('mid', m.Id);              
              IGI_PT_Controller controller16 = new IGI_PT_Controller(sc);               
              
              //controller16.matchInfo=m;
              controller16.Sched ='True';
              controller16.schCancel ='True';
              controller16.canc ='True';
              controller16.noShow ='True';
              controller16.remove ='True';
              controller16.removeMatch ='True';
              controller16.MakOff ='True';
              controller16.detail ='True';
              controller16.Offer ='True';
              controller16.reqOther ='True';
              controller16.rejMatch ='True';
              controller16.confirm ='True';
              controller16.SaveReqOther ='True';
              controller16.RevAccept='True';
              ApexPages.currentPage().getParameters().put('Apply', 'true');
              ApexPages.currentPage().getParameters().put('canc', 'true');
              ApexPages.currentPage().getParameters().put('noShow', 'true');
              ApexPages.currentPage().getParameters().put('removeMatch', 'true');
              ApexPages.currentPage().getParameters().put('rejMatch', 'true');
              ApexPages.currentPage().getParameters().put('Offer', 'true');
              
              //controller16.navigator();
              controller16.Sched=Sched;
              controller16.show=True;
              /*
              controller16.removeMatch(m.Id);
              controller16.CancelMatch(m.Id);
              controller16.UpdateNoShow(m.Id);
              controller16.AcceptOffer(m.Id);
              controller16.RejectMatch(m.Id);
              */
              
              List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        	  if(sysAdmin!=null && sysAdmin.size()>0)
        	  {
        	  	Notification__c nt = new Notification__c ( Type__c = 'Visa Interview', Engagement__c = ca.id, Status__c = 'Not Started', OwnerID = sysAdmin[0].Id);
          		insert nt;
          		
          		Notification__c nt1 = new Notification__c ( Type__c = 'Visa Result', Engagement__c = ca.id, Status__c = 'Not Started', OwnerID = sysAdmin[0].Id);
          		insert nt1;
          		
          		Notification__c nt2 = new Notification__c ( Type__c = 'Orientation', Engagement__c = ca.id, Status__c = 'Not Started', OwnerID = sysAdmin[0].Id);
          		insert nt2;
        	  }
              
              test.stopTest();
            }
           
            
      }
    
    }

    static testMethod void scormUnittest() {
      User guest;
      Account ac_pt = new Account(
          FirstName = 'Scorm_Test', LastName = 'PT', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
    
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Scorm_Test PT'];
       User admin = [SELECT Id, Name FROM User WHERE name =: 'ULM Admin' LIMIT 1];
       Engagement__c ca = new Engagement__c ( Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program__c='Internship');
       insert ca;
       Notification__c nt = new Notification__c ( Type__c = 'Orientation', Engagement__c = ca.Id , Status__c = 'Not Started', OwnerID = admin.Id,Intrax_Program__c='Internship');
        insert nt;
       Engagement__c ca1 = new Engagement__c ( Name = 'Candidate Test1', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program__c='Internship');
       insert ca1;
       Notification__c nt1= new Notification__c ( Type__c = 'Orientation', Engagement__c = ca1.Id , Status__c = 'Not Started', OwnerID = admin.Id,Intrax_Program__c='Internship');
        insert nt1;
       Engagement__c ca2 = new Engagement__c ( Name = 'Candidate Test2', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program__c='Internship');
       insert ca2;
       Notification__c nt2= new Notification__c ( Type__c = 'Orientation', Engagement__c = ca2.Id , Status__c = 'Not Started', OwnerID = admin.Id,Intrax_Program__c='Internship');
        insert nt2;
         Engagement__c ca3 = new Engagement__c ( Name = 'Candidate Test3', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program__c='Internship');
       insert ca3;
       Notification__c nt3= new Notification__c ( Type__c = 'Orientation', Engagement__c = ca3.Id , Status__c = 'Not Started', OwnerID = admin.Id,Intrax_Program__c='Internship');
        insert nt3; 
         Engagement__c ca4 = new Engagement__c ( Name = 'Candidate Test4', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program__c='Internship');
       insert ca4;
       ca4.Orientation_Date__c=null;
        ca4.Visa_Type__c ='J-1';
        ca4.Status__c='Program Ready';
        update ca4;
        Engagement__c ca5 = new Engagement__c ( Name = 'Candidate Test5', Type__c = 'Participant',Account_Id__c = ac_pt.Id, Intrax_Program__c='Internship');
       insert ca5;
          Scorm__c scormRec = new Scorm__c(Name = 'alias',Course_Id__c='ahkhak72kjhgkahsd',Multi_Step_Course__c=false,Score__c=10.0,Course_Name__c='APC Test Course',
                                      Scorm_Application_ID__c='EVZYGQR5ND',Learner_Id__c='abc@yahooo.com',
                                      HasLatestResult__c=false, Total_Time__c='0',Engagement__c=ca.Id ,Passed_Date__c=date.today());
          insert scormRec; 
         Scorm__c scormRec1 = new Scorm__c(Name = 'aliasewr',Course_Id__c='ahkhak72kjhgkahsd',Result__c='Passed',Multi_Step_Course__c=false,Score__c=10.0,Course_Name__c='APC Test Course',
                                      Registration_Id__c='sdfdsfafsda',Scorm_Application_ID__c='EVZYGQR5ND',Learner_Id__c='abc@yahooo.com',
                                     Complete_Status__c='completed', HasLatestResult__c=false, Total_Time__c='0',Engagement__c=ca1.Id ,Passed_Date__c=date.today());
          insert scormRec1; 
          Scorm__c scormRec2 = new Scorm__c(Name = 'aliasewr',Course_Id__c='ahkhak72kjhgkahsd',Result__c='Passed',Multi_Step_Course__c=false,Score__c=10.0,Course_Name__c='APC Test Course',
                                      Registration_Id__c='sdfdsfafsda',Scorm_Application_ID__c='EVZYGQR5ND',Learner_Id__c='abc@yahooo.com',
                                    Complete_Status__c='completed',HasLatestResult__c=false, Total_Time__c='0',Engagement__c=ca2.Id ,Passed_Date__c=date.today());
          insert scormRec2; 
        Scorm__c scormRec3 = new Scorm__c(Name = 'aliasewr3',Course_Id__c='ahkhak72kjhgkahsd',Multi_Step_Course__c=false,Score__c=10.0,Course_Name__c='APC Test Course',
                                      Registration_Id__c='sdfdsfafsda',Scorm_Application_ID__c='EVZYGQR5ND',Learner_Id__c='abc@yahooo.com',
                                    Complete_Status__c='completed',HasLatestResult__c=false, Total_Time__c='0',Engagement__c=ca3.Id ,Passed_Date__c=date.today());
          insert scormRec3; 
      
          system.runAs(admin){
               test.startTest();
               IGI_PT_Controller scorm_controller = new IGI_PT_Controller();
               ScormWebService sws = new ScormWebService();
               sws.setTestMode();
        	   scorm_controller.checkLogin();
               System.debug('********afterlogin method');
               ApexPages.currentPage().getParameters().put('EnggParam', ca.id);
               scorm_controller.callScormService();
              
               IGI_PT_Controller scorm_controller1 = new IGI_PT_Controller();
               ApexPages.currentPage().getParameters().put('EnggParam', ca1.id);
               scorm_controller1.callScormService();
                            
              
                           
              IGI_PT_Controller scorm_controller4 = new IGI_PT_Controller();
               ApexPages.currentPage().getParameters().put('EnggParam',null);
               scorm_controller4.callScormService();
              
              IGI_PT_Controller scorm_controller5 = new IGI_PT_Controller();
               ApexPages.currentPage().getParameters().put('EnggParam',ca4.id);
               scorm_controller5.callScormService();
              IGI_PT_Controller scorm_controller6 = new IGI_PT_Controller();
               ApexPages.currentPage().getParameters().put('EnggParam',ca5.id);
               scorm_controller6.callScormService();
              
              ApexPages.currentPage().getParameters().put('EnggParam', ca3.id);
              IGI_PT_Controller scorm_controller2 = new IGI_PT_Controller();
              ScormWebService sws1 = new ScormWebService();
               sws1.setTestMode();
               scorm_controller2.callScormService();
              
               test.stopTest();
             }
      }  
}