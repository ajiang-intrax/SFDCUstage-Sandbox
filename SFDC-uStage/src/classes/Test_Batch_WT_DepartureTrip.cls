@isTest(SeeAllData=false)
public class Test_Batch_WT_DepartureTrip 
{
	static testMethod void myUnitTest()
	{
		Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Active',
          OwnerId = UserInfo.getUserId()
          );
      	insert ac_pt1;
      	
      	Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
      	
      	List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
      	
      	 if(profiles.size() > 0)
      	 {
      	 	 test.startTest();
      		User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
         
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt1.Id, status__c = 'On Program', Intrax_Program__c = 'Work Travel', Engagement_Start__c= date.today() ,Engagement_End__c = date.today() + 12
          );
          insert ca;
          
          Batch_WT_DepartureTrip BNR = new Batch_WT_DepartureTrip();
          Database.executeBatch(BNR);
          test.stopTest();
          
      	 }
	}
}