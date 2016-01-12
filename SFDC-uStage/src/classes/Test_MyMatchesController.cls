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
@isTest(seeAllData=false)

private class Test_MyMatchesController {

    static testMethod void myUnitTest() {
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      Account IntraxId = [SELECT Intrax_Id__c FROM Account WHERE personEmail = 'testpt@test.com' limit 1];
      system.debug('****** IntraxId:' + IntraxId.Intrax_Id__c);
      
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      //sAccount__c sacc_pt = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test PT'];
      //sAccount__c sacc_pt1 = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test PT1'];
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      Account IntraxIdhc = [SELECT Intrax_Id__c FROM Account WHERE personEmail = 'testpt@test.com' limit 1];
      system.debug('****** IntraxId:' + IntraxIdhc.Intrax_Id__c);
      
      Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      Contact c_hc = new Contact(FirstName = 'Test HC', LastName = 'HC', Email = 'testc@test.com',
                                Intrax_Programs__c = 'Internship', OwnerId = UserInfo.getUserId(), 
                                AccountId = ac_hc.Id );
      insert c_hc;
      
      //sAccount__c sacc_hc = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC'];
      //sAccount__c sacc_hc1 = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC1'];
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
      
      Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE FirstName = 'Test HC'];
    
      //get Profile record
      list<Profile> profile_PT = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
      list<Profile> profile_HC = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
      
        
      if(profile_PT.size() > 0 && profile_HC.size() > 0){
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profile_PT[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c = IntraxId.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
            
        insert user;
        User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profile_HC[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c = IntraxIdhc.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
            
        insert user1;
        
        //Fetch intract Id for this account id
        Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
        
       /* user.Intrax_Id__c = portalAccount.Intrax_Id__c;
        user.Type__c = portalAccount.type;
        system.debug('***** user.Type: ' + user.Type__c);
        update user;*/
        
         Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc.Id];
        
      /*  user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
        user1.Type__c = portalAccount1.type;
        system.debug('***** user1.Type: ' + user1.Type__c);
        update user1;*/
        
            
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1),Country__c='Australia'
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'Web Design - Match', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
            Match__c m1 = new Match__c(
            Name = 'Web Design - Match', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;
          
            test.startTest();
            system.runAs(user){
              //Set request parameters
                //General Page test
              ApexPages.CurrentPage().getParameters().put('nextPage', 'Test');
              ApexPages.CurrentPage().getParameters().put('mId', m.Id);
              MyMatchesController controller = new MyMatchesController();
              controller.navigator();
            }
            test.stopTest();
            
      }
    
    }
    
    static testMethod void myUnitTest2() {
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      Account IntraxId = [SELECT Intrax_Id__c FROM Account WHERE personEmail = 'testpt@test.com' limit 1];
      system.debug('****** IntraxId:' + IntraxId.Intrax_Id__c);
      
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      //sAccount__c sacc_pt = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test PT'];
      //sAccount__c sacc_pt1 = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test PT1'];
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      Account IntraxIdhc = [SELECT Intrax_Id__c FROM Account WHERE Name = 'Test HC' limit 1];
      system.debug('****** IntraxId:' + IntraxIdhc.Intrax_Id__c);
      
      Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      Contact c_hc = new Contact(FirstName = 'Test HC', LastName = 'HC', Email = 'testc@test.com',
                                Intrax_Programs__c = 'Internship', OwnerId = UserInfo.getUserId(), 
                                AccountId = ac_hc.Id );
      insert c_hc;
      
      //sAccount__c sacc_hc = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC'];
      //sAccount__c sacc_hc1 = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC1'];
      
      Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
      
      Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE FirstName = 'Test HC'];
    
      //get Profile record
      list<Profile> profile_PT = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
      list<Profile> profile_HC = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
      
        
      if(profile_PT.size() > 0 && profile_HC.size() > 0){
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profile_PT[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c = IntraxId.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
            
        insert user;
        User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profile_HC[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c = IntraxIdhc.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
            
        insert user1;
        
        //Fetch intract Id for this account id
        Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_pt.Id];
        
        Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc.Id];
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Country__c='Australia',Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'Web Design - Match', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
            Match__c m1 = new Match__c(
            Name = 'Web Design - Match', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;
          
            test.startTest();
            
            system.runAs(user1){
              //Set request parameters
                //General Page test
              MyMatchesController controller = new MyMatchesController();
              //controller.navigator();
            }
            test.stopTest();
            
      }
    
    }
    
}