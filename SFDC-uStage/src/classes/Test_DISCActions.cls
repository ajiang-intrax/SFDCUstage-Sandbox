@isTest(seeAllData=true)

public class Test_DISCActions 
{
	static testMethod void myUnitTest()
	{
		//Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
    	//AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        RecordType acctrt = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        //Account
        Account PTaccount  = new Account(FirstName='Test123', LastName='Test123',PersonEmail='Test123@Test123.com', RecordTypeId = acctrt.Id, Type = 'Participant');
        insert PTaccount;
        
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
        
            //Run in user context
            System.runAs(sysAdmin) {
        
        		//AA Applicant Info APCPT
                Applicant_Info__c appInfoAPCPT = new Applicant_Info__c(Name = 'test-APC', Account__c = PTaccount.ID, Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
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
                
                ApexPages.currentPage().getParameters().put('id', appInfoAPCPT.ID);
                
                DISCHelper DH = new DISCHelper();
                DH.RegisterDISCUser();
                
                DH.FetchDISCResult();
                
				DISCHandler DHR = new DISCHandler();
				DHR.batchfetchdata();
				DISCHandler.CandidateInfo cndt = new DISCHandler.CandidateInfo();
				
				DHR.candidateReset('test123456');
				
				DHR.feeddata('test12345678','test7878','test7878','test7878@test.com');
				
				boolean rg = DHR.registerUser('test123456789','test78789','test78789','test787899@test.com');
				
				system.debug('***rg***'+rg);
				
				string onDmdStr = DHR.onDemandfetchdata(appInfoAPCPT.ID);
				
				system.debug('***onDmdStr***'+onDmdStr);
                
                string xmlstr ='<?xml version="1.1" encoding="UTF-8"?><root><candidates><candidate><candidateID>3D9F12EE-27D3-4AFC-90CC-FF498867921E</candidateID><fname>Test91</fname><lname>Test31</lname><email>3D9F12EE-27D3-4AFC-90CC-FF4988</email><reportURL>http://apc.prfwebsite.com/report/3D9F12EE-27D3-4AFC-90CC-FF498867921E.htm</reportURL><testTimeTaken>0:1:14</testTimeTaken><D>21</D><I>21</I><S>12</S><C>3</C><pointSystemResult>3</pointSystemResult><candidateIP>97.65.179.5</candidateIP><summaryOfPersonality>Test</summaryOfPersonality><candidateAddedDateTime>2015-02-04 16:22:35</candidateAddedDateTime><testCompletionDateTime>2015-02-04 16:33:31</testCompletionDateTime><currentDateTime>2015-02-05 17:21:17</currentDateTime></candidate></candidates></root>';
                
                List<DISCHandler.CandidateInfo> lstcndt = DHR.read(xmlstr);
                
                DISCWebService DWS = new DISCWebService();
                
               
                
                DISCWebService.registerUserResponse_element DW = new DISCWebService.registerUserResponse_element();
                DISCWebService.feedDataResponse_element DW1 = new DISCWebService.feedDataResponse_element();
                DISCWebService.candidateResetResponse_element DW2 = new DISCWebService.candidateResetResponse_element();
                DISCWebService.registerUserRequest_element DW3 = new DISCWebService.registerUserRequest_element();
                DISCWebService.feedDataRequest_element DW4 = new DISCWebService.feedDataRequest_element();
                DISCWebService.candidateResetRequest_element DW5 = new DISCWebService.candidateResetRequest_element();
                DISCWebService.fetchDataResponse_element DW6 = new DISCWebService.fetchDataResponse_element();
                DISCWebService.fetchDataRequest_element DW7 = new DISCWebService.fetchDataRequest_element();
                DISCWebService.PersonalityTestWebServiceAccessPointPort DW8 = new DISCWebService.PersonalityTestWebServiceAccessPointPort();
                
                try
                {
                	string str = DW8.registerUser('test','test');
                }
                catch(Exception ex)
				{
			    	system.debug('Not able to call Webservice');
				}
				
				try
				{
                	string str1 = DW8.feedData('test','test');
				}
                catch(Exception ex)
				{
			    	system.debug('Not able to call Webservice');
				}
				
				try
				{
                	string str2 = DW8.candidateReset('test','test');
				}
				catch(Exception ex)
				{
			    	system.debug('Not able to call Webservice');
				}
				
				try
				{
                	string str3 = DW8.fetchData('test','test');
				}
				catch(Exception ex)
				{
			    	system.debug('Not able to call Webservice');
				}
                
                
                AsyncDISCWebService asyncDWS = new AsyncDISCWebService();
                AsyncDISCWebService.fetchDataResponse_elementFuture asyncDW = new AsyncDISCWebService.fetchDataResponse_elementFuture();
                AsyncDISCWebService.registerUserResponse_elementFuture asyncDW1 = new AsyncDISCWebService.registerUserResponse_elementFuture();
                AsyncDISCWebService.feedDataResponse_elementFuture asyncDW2 = new AsyncDISCWebService.feedDataResponse_elementFuture();
                AsyncDISCWebService.candidateResetResponse_elementFuture asyncDW3 = new AsyncDISCWebService.candidateResetResponse_elementFuture();
                AsyncDISCWebService.AsyncPersonalityTestWebServiceAccessPointPort asyncDW4 = new AsyncDISCWebService.AsyncPersonalityTestWebServiceAccessPointPort();
            }
	}
}