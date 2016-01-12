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
private class Test_IGI_HC_Controller {

    static testMethod void myUnitTest() {
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
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
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      //sAccount__c sacc_hc = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC'];
      //sAccount__c sacc_hc1 = [SELECT Id, Name FROM sAccount__c WHERE Name = 'Test HC1'];
      Contact c = new Contact(FirstName = 'Test', LastName='Contact', accountId=ac_hc.Id);
      insert c;
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
        Contact c2 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
      if(profiles.size() > 0){
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Host Company',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
            User user2 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c2.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user2;
            
            
            //Fetch intract Id for this account id
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc.Id];
            
            user.Intrax_Id__c = portalAccount.Intrax_Id__c;
            user.Type__c = portalAccount.type;
            //update user;
            
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
            
            user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
            user1.Type__c = portalAccount1.type;
            //update user1;
            
           Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',  Intrax_Program__c = 'Ayusa',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Application_Stage__c = 'Declined - Agent', 
                                        Type__c = 'Participant',
                                        Createdby__c = user.Id);
           insert appInfo; 
             
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id, Host_Opportunity_Id__c = op.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          list<Position__c> plist = new list<Position__c>();
          insert plist;
          plist.add(p);
          update plist;
         /* Candidate__c ca = new Candidate__c(
            Name = 'Candidate Test', Type__c = 'Participant', Email__c = 'test@test.com', Account_Id__c = ac_pt.Id
          );
          insert ca;*/
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
          insert ca;
                    
          Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c (Document_Type__c = 'Resume', Name='Test', Engagement__c = ca.Id);
         
          insert ipu;
          
          Match__c m = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
            Match__c m1 = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;
          
           Match__c mm = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id, Start_Date__c = date.today(), End_Date__c = (date.today() + 100),
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          
          Trip__c trip = new Trip__c (Name='Test', Engagement__c = ca.Id);
          
          insert trip;
          
          Rating__c rating = new Rating__c(Score__c = '3', Match__c = m.Id);
          insert rating;
          
          Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Engagement__c = ca.Id,Document_Guid__c = 'Test', Document_service__c  = 'DS');
          insert ipUpload;
          
           Match__c m2 = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
          );
          insert m2;
          
          Campaign camp = new Campaign(Name = 'Name');
          insert camp;
          Campaign_Session__c c_session = new Campaign_Session__c (Campaign__c = camp.Id, Session_Label__c = 'Test');
          insert c_session;
          
          system.runAs(user){
              
              test.startTest();
              
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
                
                //General Page test
              IGI_HC_Controller controller = new IGI_HC_Controller(sc);
              
              controller.campaignSessionSelected='abc';
              controller.campaignSelected='abc';
              //Detail Page Test
              ApexPages.currentPage().getParameters().put('mid', m.Id);
              ApexPages.currentPage().getParameters().put('pid', p.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              ApexPages.currentPage().getParameters().put('saveMatch', 'true');
              ApexPages.currentPage().getParameters().put('fpage', 'true');
              ApexPages.currentPage().getParameters().put('tripId', trip.Id );
              
              controller.campaignSelected = c.Id;
              IGI_HC_Controller controller1 = new IGI_HC_Controller();
              
              controller1.mid = m.Id;
              controller1.matchInfo=m;
              controller1.offerPosition();
              controller1.offerIGIPosition();
              controller1.rejectCandidate();
              controller1.validator();
              controller.getPTResume();
              controller1.saveMatchInfo();
              controller.update_matchInfo();
            
              controller1.mid = m.Id;
              controller1.matchInfo = mm;
              //controller1.OfferPosition();
                
              ApexPages.currentPage().getParameters().put('matID',m2.Id);
              controller1.ReSchedule(m2.Id);
              controller1.offerCandidate();
              
              
              controller1.removeMatch(m2.Id);
              
              controller.fpage = 'test';
              controller.noShow = 'test';
              controller.remove = 'Test';
              controller.comp = 'test';
              controller.compNoShow = 'Test';
              controller.partNoShow = 'Test';
              controller.canc = 'Test';
              
             
            test.stopTest();
              
          }
            }
            
           
                /*
                  //General Page test
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
               
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('SaveMatch','true');
              ApexPages.currentPage().getParameters().put('mid', '/' + m.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              
              
              IGI_HC_Controller controller3 = new IGI_HC_Controller(sc);
              controller3.matchInfo=m;
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(-6).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(7).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              controller3.requestInterview();
              */
                  
      }  
      
      static testMethod void myUnitTest2() {
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      Contact c = new Contact(FirstName = 'Test', LastName='Contact', Intrax_Programs__c = 'Internship', accountId=ac_hc.Id);
      insert c;
      
      Contact c1 = [SELECT Id, LastName, FirstName, Intrax_Programs__c FROM Contact WHERE Name = 'Test PT1'];
      Contact c2 = [SELECT Id, LastName, FirstName, Intrax_Programs__c FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
      if(profiles.size() > 0){
            User user = new User(Alias = 'alias', Email = 'testUser1231243@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Host Company',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
            User user2 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c2.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user2;
            
            
            //Fetch intract Id for this account id
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc.Id];
            
            user.Intrax_Id__c = portalAccount.Intrax_Id__c;
            user.Type__c = portalAccount.type;
            //update user;
            
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
            
            user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
            user1.Type__c = portalAccount1.type;
            //update user1;
            
           Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',  Intrax_Program__c = 'Ayusa',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Application_Stage__c = 'Declined - Agent', 
                                        Type__c = 'Participant',
                                        Createdby__c = user.Id);
           insert appInfo; 
             
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id, Host_Opportunity_Id__c = op.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          list<Position__c> plist = new list<Position__c>();
          insert plist;
          plist.add(p);
          update plist;
         /* Candidate__c ca = new Candidate__c(
            Name = 'Candidate Test', Type__c = 'Participant', Email__c = 'test@test.com', Account_Id__c = ac_pt.Id
          );
          insert ca;*/
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
           /* Match__c m1 = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;*/
          
       
                    
          Rating__c rating = new Rating__c(Score__c = '3', Match__c = m.Id);
          insert rating;
          
          Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Engagement__c = ca.Id,Document_Guid__c = 'Test', Document_service__c  = 'DS');
          insert ipUpload;
          
           Match__c m2 = new Match__c(Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
                        Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
                        );
          insert m2;
        /* Match__c m3 = new Match__c(Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
                        Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
                        );
          insert m3;
          Match__c m4 = new Match__c(Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
                        Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
                        );
          insert m4;
          Match__c m5 = new Match__c(Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
                        Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
                        );
          insert m5;*/
          
         system.runAs(user){
              
              test.startTest();
              
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
                
                //General Page test
              //IGI_HC_Controller controller = new IGI_HC_Controller(sc);
              
              //IGI_HC_Controller controller1 = new IGI_HC_Controller();
               
              //Detail Page Test
              ApexPages.currentPage().getParameters().put('mid', '/' + m.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              ApexPages.currentPage().getParameters().put('saveMatch', 'true');
              
              IGI_HC_Controller controller2 = new IGI_HC_Controller(sc);
              controller2.engagementInfo = ca;
              //controller2.accountInfo = ac_hc;
              controller2.applicantInfo = appInfo;
              controller2.matchInfo = m;
              
              controller2.getPickValues(controller2.matchInfo, 'Status__c', null);
              
              //controller2.positionInfoList = plist;
              
              controller2.nextPage = 'test';
              /*controller2.IntDate = '';
              controller2.InputInterview = 'Int1';
              */
              controller2.checkLoginWithMatchSearch();
              controller2.navigator();
              controller2.iLIMIT=2;
              controller2.limits='1';
              controller2.checkLoginWithConfirmMatchSearch();
              controller2.firstForMatch();
              controller2.nextForMatch();
              controller2.previousForMatch();
              controller2.LastForMatch();
               controller2.firstlist();
              //controller2.next();
              
             // controller2.last();
            // controller2.previous();
             controller2.getNextButtonDisabledForMatch();
             controller2.getPreviousButtonDisabledForMatch();
              controller2.setCurrentPositionSelected('Test');
              controller2.getCurrentPositionSelected();
              controller2.reload();
              
              controller2.getDocListPTResume();
              controller2.getDocListPTPhoto();
              controller2.getCheckParticipantPhoto();
              controller2.getPTResume();
              controller2.getCampaignEnggPhotos();
              
              ApexPages.currentPage().getParameters().put('docGuid', 'Test');
              
              controller2.load();
              //controller2.requestInterview();  
              
              // Testing the sorting methods
              //controller2.SortDirection = 'ASC';
              controller2.participantSelected = 'Test';
              controller2.positionNameSelected = 'Test';
              controller2.matchStatusSelected = 'Accepted';
              controller2.offerStatusSelected = 'Offered';
              controller2.PositionStatusSelected = 'Offered';
              controller2.IntProgramSelected = 'Work Travel';
              controller2.SeasonSelected = 'Summer';
              controller2.ratingSelected = '3';
              controller2.sortExpression = 'Rating';
              controller2.ProgramYearSelected = '2014';
              
             
            
              String sOQLQueryForMatch = 'SELECT Engagement__c, Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c, Offer_Status__c, Participant_Id__c, Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Participant_Id__r.LastName, Participant_Id__r.FirstName, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,' +
                                           'Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_company_Id__r.Industry ' +
                                           'FROM Match__c WHERE Id IN: mAux2 AND';
            controller2.processSOQLQueryString(sOQLQueryForMatch);
          
            controller2.HC_Positions = plist;
            controller2.getHCPositions();
            controller2.totalPageNumber = 1;
            controller2.pageNavigation();
          

            
            controller2.getPreviousButtonDisabledforMatch();
            controller2.getNextButtonDisabledforMatch();
            controller2.calculatePageSize(5); 
            
            controller2.matchInfo = m;
            //controller2.update_matchInfo();
            
            //controller2.OfferPosition();
            /*
            controller1.mId = m.Id;
            controller1.rejectCandidate();
            
            controller1.mid = m.Id;
            controller1.matchInfo = mm;
            controller1.OfferPosition();
            
            ApexPages.currentPage().getParameters().put('matID',m2.Id);
            controller1.offerCandidate();
            */
           controller2.limits = '5';
            controller2.getItems();
            
            controller2.sortExpression = 'Name';
            controller2.setSortDirection('ASC');
            controller2.getSortDirection();
            controller2.setSortDirection('DESC');
            controller2.getSortDirection();  
                       
           //controller2.doSearchConfirmForPageSize();
        
       
            test.stopTest();
              
          }
     }        
           
                /*
                  //General Page test
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
               
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('SaveMatch','true');
              ApexPages.currentPage().getParameters().put('mid', '/' + m.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              
              
              IGI_HC_Controller controller3 = new IGI_HC_Controller(sc);
              controller3.matchInfo=m;
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(-6).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(7).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              controller3.requestInterview();
              */
              
             
          
      }  
    
     static testMethod void myUnitTestCamp() {
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
       Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
   
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
       Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
        
      
      Contact c = new Contact(FirstName = 'Test', LastName='Contact', Intrax_Programs__c = 'Internship', accountId=ac_hc.Id);
      insert c;
      Contact c1 = [SELECT Id, LastName, FirstName, Intrax_Programs__c FROM Contact WHERE Name = 'Test PT1'];

   
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
      if(profiles.size() > 0){
            User user = new User(Alias = 'alias', Email = 'testUser1231243@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Host Company',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
          
            
            
            //Fetch intract Id for this account id
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc.Id];
            
            user.Intrax_Id__c = portalAccount.Intrax_Id__c;
            user.Type__c = portalAccount.type;
            //update user;
            
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
            
            user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
            user1.Type__c = portalAccount1.type;
            //update user1;
            
            
           Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',  Intrax_Program__c = 'Ayusa',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Application_Stage__c = 'Declined - Agent', 
                                        Type__c = 'Participant',
                                        Createdby__c = user.Id);
           insert appInfo; 
             
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id, Host_Opportunity_Id__c = op.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          list<Position__c> plist = new list<Position__c>();
          insert plist;
          plist.add(p);
          update plist;
        
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
        
       
                    
          Rating__c rating = new Rating__c(Score__c = '3', Match__c = m.Id);
          insert rating;
          
          Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Engagement__c = ca.Id,Document_Guid__c = 'Test', Document_service__c  = 'DS');
          insert ipUpload;
          
        
       
          
        system.runAs(user){
              
              test.startTest();
              
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
                
              
              ApexPages.currentPage().getParameters().put('mid', '/' + m.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              ApexPages.currentPage().getParameters().put('saveMatch', 'true');
              
              IGI_HC_Controller controller2 = new IGI_HC_Controller(sc);
              controller2.engagementInfo = ca;
              //controller2.accountInfo = ac_hc;
              controller2.applicantInfo = appInfo;
              controller2.matchInfo = m;
              
              controller2.getPickValues(controller2.matchInfo, 'Status__c', null);
              
              //controller2.positionInfoList = plist;
              
              controller2.nextPage = 'test';
              
              controller2.checkLoginWithMatchSearch();
              ApexPages.currentPage().getParameters().put('mId', m.Id);
              controller2.entertippform();
                          
              controller2.firstlist();
              controller2.nextlist(); 
              controller2.previouslist();
             // controller2.lastlist(); 
              controller2.navigator();
              controller2.iLIMIT=2;
              controller2.limits='1';
              controller2.checkLoginWithConfirmMatchSearch();
             
            
              
              ApexPages.currentPage().getParameters().put('docGuid', 'Test');
              
              controller2.load();

              controller2.participantSelected = 'Test';
              controller2.positionNameSelected = 'Test';
              controller2.matchStatusSelected = 'Accepted';
              controller2.offerStatusSelected = 'Offered';
              controller2.PositionStatusSelected = 'Offered';
              controller2.IntProgramSelected = 'Work Travel';
              controller2.SeasonSelected = 'Summer';
              controller2.ratingSelected = '3';
              controller2.sortExpression = 'Name';
              controller2.ProgramYearSelected = '2014';
              controller2.doSearchForPageSize();
              controller2.doSearchConfirmForPageSize();
            
              String sOQLQueryForMatch = 'SELECT Engagement__c, Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c, Offer_Status__c, Participant_Id__c, Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Participant_Id__r.LastName, Participant_Id__r.FirstName, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,' +
                                           'Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_company_Id__r.Industry ' +
                                           'FROM Match__c WHERE Id IN: mAux2 AND';
            controller2.processSOQLQueryString(sOQLQueryForMatch);
          
            controller2.HC_Positions = plist;
            controller2.getHCPositions();
            controller2.totalPageNumber = 1;
            controller2.pageNavigation();

            
            
            
            controller2.getPreviousButtonDisabledforMatch();
            controller2.getNextButtonDisabledforMatch();
            controller2.calculatePageSize(5); 
            
            controller2.matchInfo = m;
            
           controller2.limits = '5';
            controller2.getItems();
            
            controller2.sortExpression = 'Name';
            controller2.setSortDirection('ASC');
            controller2.getSortDirection();
            controller2.setSortDirection('DESC');
            controller2.getSortDirection();  
                       
        
             controller2.doSearchPositionsForPageSize();
            
            controller2.campaignSessionSelected='abcd';
            controller2.campaignSelected='a0d180000004I1Y';
            controller2.doSearchCampaignsForPageSize();
            
            ApexPages.currentPage().getParameters().put('ptid',ca.Id);
            
            List<Intrax_Program_Upload__c> DocLists = controller2.getDocList();
            // List<Intrax_Program_Upload__c> matchDocLists = controller2.getMatchDocList();
            test.stopTest();
              
          }
       }        
     }
      static testMethod void myUnitTest3() {
      RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
     // Contact ptContact=[Select id,firstname, lastname from Contact where id =:ac_pt.PersonContactId];
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
     Account Hc_Acc = new Account(
          Name='Test HC Company',
          type = 'Host Company', Intrax_Programs__c = 'Work Travel', status__c = 'Contracted',Workers_Comp_Received__c=System.today(),
          Business_License_Received__c=system.today(),EIN__c='324324334',Phone='234324',
          OwnerId = UserInfo.getUserId(),BillingStreet='Street 25',BillingState='SS',BillingCity='City',BillingCountry='saffdsdf',BillingPostalcode='334334');
          
      insert Hc_Acc;
      
      Contact c = new Contact(FirstName = 'Test', LastName='Contact', accountId=ac_hc.Id);
      insert c;
      /*Contact Ptcontact = new Contact(FirstName = 'Test_PT', LastName='Contact_PT', accountId=ac_pt.Id);
      insert Ptcontact;*/
      Contact c1 = [SELECT Id, name,Email,AccountId FROM Contact WHERE Name = 'Test PT1'];
      Contact c2 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
      if(profiles.size() > 0){
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Host Company',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
            User user2 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c2.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user2;
            
            
            //Fetch intract Id for this account id
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc.Id];
            
            user.Intrax_Id__c = portalAccount.Intrax_Id__c;
            user.Type__c = portalAccount.type;
            //update user;
            
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
            
            user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
            user1.Type__c = portalAccount1.type;
            //update user1;
            
           Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',  Intrax_Program__c = 'Ayusa',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Application_Stage__c = 'Declined - Agent', 
                                        Type__c = 'Participant',
                                        Createdby__c = user.Id);
           insert appInfo; 
             
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id, Host_Opportunity_Id__c = op.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          list<Position__c> plist = new list<Position__c>();
          insert plist;
          plist.add(p);
          update plist;
         /* Candidate__c ca = new Candidate__c(
            Name = 'Candidate Test', Type__c = 'Participant', Email__c = 'test@test.com', Account_Id__c = ac_pt.Id
          );
          insert ca;*/
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
            Match__c m1 = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;
          
           Match__c mm = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id, Start_Date__c = date.today(), End_Date__c = (date.today() + 100),
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          
          Rating__c rating = new Rating__c(Score__c = '3', Match__c = m.Id);
          insert rating;
          
          Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Engagement__c = ca.Id,Document_Guid__c = 'Test', Document_service__c  = 'DS');
          insert ipUpload;
          
           Match__c m2 = new Match__c(Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
                        Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
                        );
          insert m2;
          
           Match__c m3 = new Match__c(Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
                        Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
                        );
          insert m3;
          
           
          system.runAs(user){
              
                test.startTest();
              
                //Set request parameters
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
                        
                ApexPages.currentPage().getParameters().put('ptid',ca.Id);
            
                IGI_HC_Controller controller6 = new IGI_HC_Controller();
            
                ApexPages.currentPage().getParameters().put('ptid',ca.Id);
                ApexPages.currentPage().getParameters().put('matchid',m.Id);
                IGI_HC_Controller controller7 = new IGI_HC_Controller();
                ApexPages.currentPage().getParameters().put('id',hc_acc.Id);
                
                ApexPages.currentPage().getParameters().put('nextPage','Home');
                controller7.loadContact();
                Id a=controller7.gethcAccountId();
                Account acc= controller7.getAccount();
                controller7.preLoad();
                controller7.validatorhost();
               
                controller7.hca_navigator();

                ApexPages.currentPage().getParameters().put('id',c2.Id);
                controller7.LoadSelectedContact();
                //controller7.savehcContact();
                test.stopTest();              
          }
     }        
           
                /*
                  //General Page test
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
               
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('SaveMatch','true');
              ApexPages.currentPage().getParameters().put('mid', '/' + m.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              
              
              IGI_HC_Controller controller3 = new IGI_HC_Controller(sc);
              controller3.matchInfo=m;
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate','');
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(-6).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller3.requestInterview();
              controller3.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(7).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              controller3.requestInterview();
              */
                        
          
              /* Not needed in this version
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
              IGI_HC_Controller controller4 = new IGI_HC_Controller(sc);
              controller4.matchInfo=m;
              controller4.engagementInfo= ca;
              //controller4.positionInfo = p;
            
             
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
              ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(ca);
                
                //General Page test
              IGI_HC_Controller controller11 = new IGI_HC_Controller(sc1);
              
              IGI_HC_Controller controller12 = new IGI_HC_Controller();
              
              //Detail Page Test
              ApexPages.currentPage().getParameters().put('mid', '/' + m1.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              IGI_HC_Controller controller14 = new IGI_HC_Controller(sc1);
              controller14.matchInfo=m1;
              controller14.navigator();
              controller14.checkLogin();
              controller14.requestInterview();              
            
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('SaveMatch','true');
              ApexPages.currentPage().getParameters().put('mid', '/' + m1.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              IGI_HC_Controller controller13 = new IGI_HC_Controller(sc1);
              controller13.matchInfo=m1;
              controller13.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller13.requestInterview();
              controller13.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller13.requestInterview();
              controller13.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              controller13.requestInterview();
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('mid', m1.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              ApexPages.currentPage().getParameters().put('ReSchedSched', 'true');
              ApexPages.currentPage().getParameters().put('reSchedule', 'true');
              ApexPages.currentPage().getParameters().put('SaveCanc', 'true');
              ApexPages.currentPage().getParameters().put('SaveSchreSchedule', 'true');
              ApexPages.currentPage().getParameters().put('SaveSchCanc', 'true');
              ApexPages.currentPage().getParameters().put('removeMatch', 'true');
              ApexPages.currentPage().getParameters().put('Offer', 'true');
              ApexPages.currentPage().getParameters().put('noShow', 'true');
              ApexPages.currentPage().getParameters().put('noAttend', 'true');
              ApexPages.currentPage().getParameters().put('rejMatch', 'true');
              IGI_HC_Controller controller15 = new IGI_HC_Controller(sc1);
              controller15.matchInfo=m1;
              controller15.navigator();
              IGI_HC_Controller controller16 = new IGI_HC_Controller(sc1);
              controller16.matchInfo=m1;
              controller16.navigator();
              controller16.Sched=Sched;
              //SaveMatch='true';
             // controller16.SaveMatch=SaveMatch;
              controller16.saveMatchInfo();
              ReSchedSched ='true';
              controller16.ReSchedSched=ReSchedSched;
              controller16.ReSchedSchedMatchInfo(m1.Id);
              reSchedule ='true';
              controller16.reSchedule=reSchedule;
              controller16.ReSchedule(m1.Id);
              SaveCanc ='true';
              controller16.SaveCanc=SaveCanc;
              controller16.CancelMatch(m1.Id);
              SaveSchreSchedule ='true';
              controller16.SaveSchreSchedule=SaveSchreSchedule;
              controller16.ReSchedule(m1.Id);
              SaveSchCanc ='true';
              controller16.SaveSchCanc=SaveSchCanc;
              controller16.CancelMatch(m1.Id);
              
              removeMatch ='true';
              controller16.removeMatch=removeMatch;
              controller16.removeMatch(m1.Id);
             
              Offer ='true';
              controller16.Offer=Offer;
              controller16.MakeOffer(m1.Id);
              noShow ='true';
              controller16.noShow=noShow;
              controller16.UpdateNoShow(m1.Id);
              //NoAttend ='true';
              // controller16.NoAttend=NoAttend;
              controller16.NotAttend(m1.Id);
              rejMatch ='true';
              controller16.rejMatch=rejMatch;
              controller16.RejectMatch(m1.Id);
               */
                  
      }  
      /*
      static testMethod void myUnitTest4() {
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt1;
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
        Account ac_hc1 = new Account(
          Name = 'Test HC1',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc1;
      
      Contact c = new Contact(FirstName = 'Test', LastName='Contact', accountId=ac_hc.Id);
      insert c;
        Contact c1 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
        Contact c2 = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
    
      //get Profile record
      List<Profile> profiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
      if(profiles.size() > 0){
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Host Company',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c1.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user1;
            
            User user2 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Asia/Tehran', 
                                    ContactId = c2.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user2;
            
            
            //Fetch intract Id for this account id
            Account portalAccount = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc.Id];
            
            user.Intrax_Id__c = portalAccount.Intrax_Id__c;
            user.Type__c = portalAccount.type;
            //update user;
            
             Account portalAccount1 = [Select Id, Intrax_Id__c, type from Account where Id =: ac_hc1.Id];
            
            user1.Intrax_Id__c = portalAccount1.Intrax_Id__c;
            user1.Type__c = portalAccount1.type;
            //update user1;
            
           Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',  Intrax_Program__c = 'Ayusa',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Application_Stage__c = 'Declined - Agent', 
                                        Type__c = 'Participant',
                                        Createdby__c = user.Id);
           insert appInfo; 
             
          Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id, Host_Opportunity_Id__c = op.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
          
          list<Position__c> plist = new list<Position__c>();
          insert plist;
          plist.add(p);
          update plist;
         /* Candidate__c ca = new Candidate__c(
            Name = 'Candidate Test', Type__c = 'Participant', Email__c = 'test@test.com', Account_Id__c = ac_pt.Id
          );
          insert ca;*/
          
          /* //uncomment
          Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
          insert ca;
          
          Match__c m = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m;
            Match__c m1 = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          insert m1;
          
           Match__c mm = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id, Start_Date__c = date.today(), End_Date__c = (date.today() + 100),
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          
          Rating__c rating = new Rating__c(Score__c = '3', Match__c = m.Id);
          insert rating;
          
          Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Engagement__c = ca.Id,Document_Guid__c = 'Test', Document_service__c  = 'DS');
          insert ipUpload;
          
           Match__c m2 = new Match__c(Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt1.Id,
                        Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9), Offer_Status__c = 'Offered'
                        );
          //insert m2;
          
          system.runAs(user){
              
                test.startTest();
              
                //Set request parameters
                
                /*ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
                        
                ApexPages.currentPage().getParameters().put('ptid',ca.Id);
            
                IGI_HC_Controller controller6 = new IGI_HC_Controller();
            
                ApexPages.currentPage().getParameters().put('ptid',ca.Id);
                ApexPages.currentPage().getParameters().put('matchid',m.Id);
                IGI_HC_Controller controller7 = new IGI_HC_Controller();
                */              
               /* //uncomment
              //General Page test
              //Set request parameters
              ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ca);
               
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('SaveMatch','true');
              ApexPages.currentPage().getParameters().put('mid', '/' + m.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              
              
              IGI_HC_Controller controller3 = new IGI_HC_Controller(sc);
              controller3.matchInfo=m;
              controller3.navigator();
                 
              /* Not needed in this version*/
              /*//uncomment
              ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(ca);
              IGI_HC_Controller controller4 = new IGI_HC_Controller(sc1);
              controller4.matchInfo=m;
              controller4.engagementInfo= ca;
              //controller4.positionInfo = p;
                         
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
              ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(ca);
                
                //General Page test
              IGI_HC_Controller controller11 = new IGI_HC_Controller(sc2);
              
              IGI_HC_Controller controller12 = new IGI_HC_Controller();
              
              //Detail Page Test
              ApexPages.currentPage().getParameters().put('mid', '/' + m1.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              
              
              IGI_HC_Controller controller14 = new IGI_HC_Controller(sc1);
              controller14.matchInfo=m1;
              controller14.navigator();
              controller14.checkLogin();             
            
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('SaveMatch','true');
              ApexPages.currentPage().getParameters().put('mid', '/' + m1.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              IGI_HC_Controller controller13 = new IGI_HC_Controller(sc1);
              controller13.matchInfo=m1;
              controller13.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int1');
              controller13.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int2');
              controller13.navigator();
              ApexPages.currentPage().getParameters().put('IntDate',String.valueof(System.now().addDays(2).format()));
              ApexPages.currentPage().getParameters().put('InputInterview', 'Int3');
              ApexPages.currentPage().getParameters().put('compOffset',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset1',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('compOffset2',String.valueof(System.now()));
              ApexPages.currentPage().getParameters().put('mid', m1.Id);
              ApexPages.currentPage().getParameters().put('nextPage', 'test');
              ApexPages.currentPage().getParameters().put('ReSchedSched', 'true');
              ApexPages.currentPage().getParameters().put('reSchedule', 'true');
              ApexPages.currentPage().getParameters().put('SaveCanc', 'true');
              ApexPages.currentPage().getParameters().put('SaveSchreSchedule', 'true');
              ApexPages.currentPage().getParameters().put('SaveSchCanc', 'true');
              ApexPages.currentPage().getParameters().put('removeMatch', 'true');
              ApexPages.currentPage().getParameters().put('Offer', 'true');
              ApexPages.currentPage().getParameters().put('noShow', 'true');
              ApexPages.currentPage().getParameters().put('noAttend', 'true');
              ApexPages.currentPage().getParameters().put('rejMatch', 'true');
              IGI_HC_Controller controller15 = new IGI_HC_Controller(sc1);
              controller15.matchInfo=m1;
              controller15.navigator();
              IGI_HC_Controller controller16 = new IGI_HC_Controller(sc1);
              controller16.matchInfo=m1;
              //controller16.navigator();
              controller16.Sched=Sched;
              //SaveMatch='true';
             // controller16.SaveMatch=SaveMatch;
              ApexPages.currentPage().getParameters().put('Comp', 'true');
              ApexPages.currentPage().getParameters().put('CompNoShow', 'true');
              ApexPages.currentPage().getParameters().put('PartNoShow', 'true');
              controller16.saveMatchInfo();
              ReSchedSched ='true';
              
              removeMatch ='true';
              controller16.removeMatch=removeMatch;
              controller16.removeMatch(m1.Id);
                   
            test.stopTest();              
          
        }        
           
      }
      }
      */
}