@isTest(SeeAllData=false)
public class Test_Batch_Notification_Reminders 
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
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt1.Id, status__c = 'New'
          );
          insert ca;
          
          Notification__c nt = new Notification__c(Type__c='Parent',Status__c = 'Not Started',Contact__c=c1.id);
          
          insert nt;
          
          Notification__c nt1 = new Notification__c(Type__c='Job Information Needed',Status__c = 'Not Started',Contact__c=c1.id,Engagement__c=ca.id, Parent_Notification__c = nt.id,Subject__c='Job Information Required',Email_Sent_At__c = date.today()-15,Intrax_Program__c = 'Work Travel', Body__c='Our records indicate that you are currently On Program and do not have a job. You are required to submit your new job information and documents as soon as you secure employment. Intrax will need to review and approve your job details before you can begin working.');
          insert nt1;
          nt1.Email_Sent_At__c = date.today()-15;
          update nt1;
          Batch_Notification_Reminders BNR = new Batch_Notification_Reminders();
          Database.executeBatch(BNR);
          test.stopTest();
      	 }
	}
}