@isTest(seeAllData=false)
public class Test_Visa_Support_Letter 
{
	 public static testMethod void TestVisaSupportLetterMethod() 
    {
        Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Terminated', BillingStreet = 'Test', BillingState = 'CA', BillingPostalCode = '11111', BillingCity = 'Test',BillingCountry='USA', Workers_Comp_Received__c = date.today(),Business_License_Received__c=date.today(),EIN__c ='Test',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      Account IntraxId = [SELECT Intrax_Id__c FROM Account WHERE personEmail = 'testpt@test.com' limit 1];
      
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Terminated', BillingStreet = 'Test', BillingState = 'CA', BillingPostalCode = '11111', BillingCity = 'Test',BillingCountry='USA', Workers_Comp_Received__c = date.today(),Business_License_Received__c=date.today(),EIN__c ='Test',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Work Travel', status__c = 'Contracted', BillingStreet = 'Test', BillingState = 'CA', BillingPostalCode = '11111', BillingCity = 'Test',BillingCountry='USA', Workers_Comp_Received__c = date.today(),Business_License_Received__c=date.today(),EIN__c ='Test',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      Account IntraxIdhc = [SELECT Intrax_Id__c FROM Account WHERE personEmail = 'testpt@test.com' limit 1];
      
      Contact c_hc = new Contact(FirstName = 'Test HC', LastName = 'HC', Email = 'testc@test.com',
                                Intrax_Programs__c = 'Work Travel', OwnerId = UserInfo.getUserId(), 
                                AccountId = ac_hc.Id );
      insert c_hc;
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
      
         
      
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, 
            Type='Participant', Intrax_Programs__c = 'Work Travel', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Country__c='Australia',
            Intrax_Program__c = 'Work Travel', Intrax_Region__c = 'Europe',  
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1), Status__c='Matching'
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id, Service_Level__c ='Premium'
          );
          insert ca;
          
          
 		          
          Match__c m = new Match__c(
            Name = 'Test - Match', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,End_Date__c=date.today().addMonths(3),
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
            
          );
          insert m;
           
           User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
           system.runAs(sysAdmin)
            {
            	//Engagement__c eg = new Engagement__c();
             ApexPages.currentPage().getParameters().put('Id', ca.Id);
             ApexPages.standardController controller = new ApexPages.standardController(ca);
             test.startTest();
             Visa_Support_Letter letter = new Visa_Support_Letter(controller);
       		 letter.updNotification();
       		 test.stopTest();
            }
           
      
    }
    
    public static testMethod void TestVisaSupportLetterMethodNew() 
    {
        Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Terminated', BillingStreet = 'Test', BillingState = 'CA', BillingPostalCode = '11111', BillingCity = 'Test',BillingCountry='USA', Workers_Comp_Received__c = date.today(),Business_License_Received__c=date.today(),EIN__c ='Test',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      Account IntraxId = [SELECT Intrax_Id__c FROM Account WHERE personEmail = 'testpt@test.com' limit 1];
      
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Terminated', BillingStreet = 'Test', BillingState = 'CA', BillingPostalCode = '11111', BillingCity = 'Test',BillingCountry='USA', Workers_Comp_Received__c = date.today(),Business_License_Received__c=date.today(),EIN__c ='Test',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Work Travel', status__c = 'Contracted', BillingStreet = 'Test', BillingState = 'CA', BillingPostalCode = '11111', BillingCity = 'Test',BillingCountry='USA', Workers_Comp_Received__c = date.today(),Business_License_Received__c=date.today(),EIN__c ='Test',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      Account IntraxIdhc = [SELECT Intrax_Id__c FROM Account WHERE personEmail = 'testpt@test.com' limit 1];
      
      Contact c_hc = new Contact(FirstName = 'Test HC', LastName = 'HC', Email = 'testc@test.com',
                                Intrax_Programs__c = 'Work Travel', OwnerId = UserInfo.getUserId(), 
                                AccountId = ac_hc.Id );
      insert c_hc;
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
      
         
      
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, 
            Type='Participant', Intrax_Programs__c = 'Work Travel', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Country__c='Australia',
            Intrax_Program__c = 'Work Travel', Intrax_Region__c = 'Europe', Status__c = 'Matching', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id, Service_Level__c ='Independent'
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'Web Design - Match', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Applied', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
           
           User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
           system.runAs(sysAdmin)
            {
            	//Engagement__c eg = new Engagement__c();
             ApexPages.currentPage().getParameters().put('Id', ca.Id);
             ApexPages.standardController controller = new ApexPages.standardController(ca);
             test.startTest();
             Visa_Support_Letter letter = new Visa_Support_Letter(controller);
       		 letter.updNotification();
       		 test.stopTest();
            }
           
      
     }
    
}