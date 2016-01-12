@isTest(SeeAllData=true)
public class Test_WT_Job_Content_Extn
{
    public static testMethod void TestIWTJobPlacementMethod() 
    {
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
                                    Username = Math.random() + '@test.com');
            
            insert user;
             User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
          
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
        
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
            
          
            
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled',Tipped_Position__c='No',
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'Web Design - Match', Interview_Status__c = 'Initiated', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending');         
          insert m;        
          
          Match__c m1 = new Match__c(
            Name = 'Web Design - Match', Interview_Status__c = 'Initiated' , Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;
        ApexPages.standardController controller = new ApexPages.standardController(m);
        WT_Job_Content_Extn extension = new WT_Job_Content_Extn(controller);
    }
}