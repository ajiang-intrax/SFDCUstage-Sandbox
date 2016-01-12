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
public class Test_Batch_WT_Visa_Status 
{
	static testMethod void myUnitTest()
	{
		 test.startTest();
		Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Active',
          OwnerId = UserInfo.getUserId()
          );
      	insert ac_pt1;
      	
      	Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
      	
      	List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      	
      
         
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt1.Id, status__c = 'Program Ready', Intrax_Program__c = 'Work Travel',
            Intrax_Program_Options__c = 'Test',  Engagement_Start__c= date.today() , Engagement_End__c = date.today() + 12, 
           	Visa_Interview_Date__c = date.today() - 5, Orientation_Date__c = date.today()+10
          );
          insert ca;
          
          
      
     
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c = 'Finding an Work Travel');
            
            insert user1;
            
          RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Work Travel PT' Limit 1];
          
          Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
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
                                                                  Intrax_Program_Options__c = 'YES',  CreatedBy__c = user1.id,
                                                                  Country_of_Interest__c = 'United States'
                                                                  );
                
          insert appInfo;
          
          Batch_WT_Visa_Status BNR = new Batch_WT_Visa_Status();
          Database.executeBatch(BNR);
          test.stopTest();
          
      	 
	}
}