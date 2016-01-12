@isTest(SeeAllData=true)
public class Test_DocuSign_Helper
{
    public static testMethod void DocuSignHandlerMethodsTest() 
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
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
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
        
        
       //  DocusignIWTSettings__c testsettings = DocusignIWTSettings__c.getInstance(); 
        //Engagement__c testEng = [SELECT ID, Name, Account_Id__c FROM Engagement__c WHERE Account_Id__c != NULL LIMIT 1];
        Docusign_Settings__c testsettings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
        ApexPages.currentPage().getParameters().put('id', ca.ID);
        
        PageReference pref = DocuSign_Helper.CreateIWTTCEnvelope();
        
        
    }
    
    public static testMethod void DocuSignHandlerJobMethodsTest() 
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
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
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

         //Member        
         Member__c mem = new Member__c(Name = 'Web Design - Member',Account_Name__c=ac_hc.id);
         insert mem;
        
       //  DocusignIWTSettings__c testsettings = DocusignIWTSettings__c.getInstance(); 
        //Engagement__c testEng = [SELECT ID, Name, Account_Id__c FROM Engagement__c WHERE Account_Id__c != NULL LIMIT 1];
         Docusign_Settings__c testsettings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
        ApexPages.currentPage().getParameters().put('id', m.ID);
        
        PageReference pref = DocuSign_Helper.CreateIWTJobEnvelope();
        
        //APC
        Applicant_Info__c appInfoTest = new Applicant_Info__c(Name = 'test', Home_Street_1__c = 'test',Account__c = portalAccount1.Id,
                                                                        Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family',
                                                                        Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',
                                                                        Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Program_Year__c = '2014',
                                                                        Intrax_Program_Options__c = 'Ayusa High School', Sys_Allow_Cloning__c = true, Application_Stage__c = 'Accepted');
        upsert appInfoTest;
        ApexPages.currentPage().getParameters().put('id', appInfoTest.ID);
        ApexPages.currentPage().getParameters().put('uType', 'Participant');
        
        Docusign_Settings__c settings =Docusign_Settings__c.getValues('AuPairCare');
        PageReference prefapc = DocuSign_Helper.CreateAPCHFEnvelope();
        
        Docusign_helper.updApp(appInfoTest.ID);
        Docusign_helper.updDs(appInfoTest.id,'21312321');
        Docusign_helper.updEngg(ca.id,'21312321');
        Docusign_helper.updMember(mem.id,appInfoTest.ID);
    }
    
    
    public static testMethod void MemberDocuSignHandlerMethodsTest() 
    {
         Docusign_Settings__c ObjDocSetting = Docusign_Settings__c.getValues('Ayusa_BGC_Age_18'); 
        Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
        Member__c testmem = new Member__c();
           
      Account testacc  = new Account(FirstName = 'Test', LastName = 'HF Account', Status__c = 'Prospect',
                             Type = 'Host Family',PersonMailingStreet = '10 test st',PersonMailingState = 'CA',
                              PersonMailingCity = 'test',PersonMailingPostalCode = '12345',Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                             Intrax_Region__c = 'United States', PersonEmail = 'test@test2.com');
                
      insert testacc; 
       testmem.Account_Name__c = testacc.Id;
    testmem.First_Name__c = 'tester fn';
    testmem.Last_Name__c = 'tester ln';
    testmem.ESSN__c = '123-45-6789';
    testmem.Middle_Name__c = 'xmiddlename';
    testmem.Date_of_Birth__c = date.ValueOf('1968-09-21');    
    testmem.Email__c = 'test@test.com';
    testmem.Background_Check__c = null;   
    testmem.BGC_Signed_Date__c =Date.today();  
    insert testmem;  
        ApexPages.currentPage().getParameters().put('mid', testmem.ID);
        
        DocuSign_Helper obj = new DocuSign_Helper();
        PageReference pref = obj.CreateAYMemberBGCEnvelope();
        
       // string url = DocuSign_Util.getSigningURL('IWT',testsettings.Docusign_Username__c, testsettings.Docusign_Password__c, testsettings.Docusign_Integrator_Key__c, testsettings.Docusign_Webservice_Endpoint__c, '', '', '', '', '', 'Participant');
        
    }
    public static testMethod void OpenPDFMethodsTest() 
    {
      dsfs__DocuSign_Status__c dsEnv = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c WHERE dsfs__DocuSign_Envelope_ID__c != NULL AND dsfs__DocuSign_Envelope_ID__c != '' LIMIT 1];
      ApexPages.currentPage().getParameters().put('envelopeID', dsEnv.dsfs__DocuSign_Envelope_ID__c);
      DocuSign_Helper obj = new DocuSign_Helper();
        obj.OpenEnvelopePDF();
    }
    
     public static testMethod void DocuSignIGITCMethodsTest() 
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
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
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
        
        
       //  DocusignIWTSettings__c testsettings = DocusignIWTSettings__c.getInstance(); 
        //Engagement__c testEng = [SELECT ID, Name, Account_Id__c FROM Engagement__c WHERE Account_Id__c != NULL LIMIT 1];
         Docusign_Settings__c testsettings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
        ApexPages.currentPage().getParameters().put('id', ca.ID);
        
        PageReference pref = DocuSign_Helper.CreateIGITCEnvelope();
        
        DocuSign_Helper.updDSEngg(ca.id, '111111','Internship Terms & Conditions');
        DocuSign_Helper.updMatch(m1.id, ca.id,'2222222'); 
        
        
    }
    
    public static testMethod void DocuSignHandlerPTJobMethodsTest() 
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
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
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

         //Member        
         Member__c mem = new Member__c(Name = 'Web Design - Member',Account_Name__c=ac_hc.id);
         insert mem;
        
        // DocusignIWTSettings__c testsettings = DocusignIWTSettings__c.getInstance(); 
        //Engagement__c testEng = [SELECT ID, Name, Account_Id__c FROM Engagement__c WHERE Account_Id__c != NULL LIMIT 1];
        Docusign_Settings__c testsettings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
        ApexPages.currentPage().getParameters().put('id', m.ID);
        
        PageReference pref = DocuSign_Helper.CreateWTCandidateJob(); 
        
        //APC
        Applicant_Info__c appInfoTest = new Applicant_Info__c(Name = 'test', Home_Street_1__c = 'test',Account__c = portalAccount1.Id,
                                                                        Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family',
                                                                        Business_in_Home_Description__c = 'test',   Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',
                                                                        Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Program_Year__c = '2014',
                                                                        Intrax_Program_Options__c = 'Ayusa High School', Sys_Allow_Cloning__c = true, Application_Stage__c = 'Accepted');
        upsert appInfoTest;
        ApexPages.currentPage().getParameters().put('id', appInfoTest.ID);
        ApexPages.currentPage().getParameters().put('uType', 'Participant');
        
        Docusign_Settings__c settings =Docusign_Settings__c.getValues('AuPairCare');
        PageReference prefapc = DocuSign_Helper.CreateAPCHFEnvelope();
        
        Docusign_helper.updApp(appInfoTest.ID);
        Docusign_helper.updDs(appInfoTest.id,'21312321');
        Docusign_helper.updEngg(ca.id,'21312321');
        Docusign_helper.updMember(mem.id,appInfoTest.ID);
    }
}