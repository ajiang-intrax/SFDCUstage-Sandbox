@isTest(seeAllData=false)
private class Test_Batch_IGI_HOST_FP_Assessment  {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        RecordType IGIApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'West', SEVIS_Program__c = '15-Intern', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 1), Engagement_End__c = (date.today() + 180),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2015', Status__c = 'On Program', Needs_Travel__c ='Yes', Visa_Type__c= 'J-1');
        insert WTengagement;
        
        
        
         Contact c = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert c;
        
         List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
         Applicant_Info__c appInfo = new Applicant_Info__c();
        if(profiles.size() > 0)
        {
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = c.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            insert user;
            appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Internship', createdBy__c = user.id, RecordTypeId = IGIApplRecordType.ID
                                                                  );
        }
        else
        {
            appInfo = new Applicant_Info__c(Name = 'test-AY', Special_Diet_Indicated__c = 'No', Engagement__c = WTengagement.Id,
                                                                  Primary_Language__c = 'English', Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2014',
                                                                  Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Internship', RecordTypeId = IGIApplRecordType.ID
                                                                  );
        }
        
        if (appInfo != NULL)
            insert appInfo;
        
        Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
      insert ac_hc;
      
       Contact c_hc = new Contact(FirstName = 'Test', LastName='Contact', accountId=ac_hc.Id);
      insert c_hc;
      
       Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_hc.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
            
       Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id, Host_Opportunity_Id__c = op.Id,Tipped_Position__c='No',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
          insert p;
       
       Match__c mm = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = WTengagement.Id,  Start_Date__c = (date.today()-1), End_Date__c = (date.today() + 4),
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed', Interview_Request_HC1__c=System.now().adddays(3), Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
        insert mm;
        
         Assessment__c F_Assessment = new Assessment__c(Name = 'MCTest', RecordTypeId = Constants.ASS_IGI_PT_Final_Program , Status__c = 'Not Yet Started', Engagement__c = WTEngagement.Id);
        insert F_Assessment;
        
        Notification__c MC_Notif = new Notification__c(Type__c = 'Final Program Assessment', Engagement__c = WTengagement.Id, Assessment__c = F_Assessment.Id);
        insert MC_Notif;
       
        
        Batch_IGI_HOST_FP_Assessment batch = new Batch_IGI_HOST_FP_Assessment();
        Database.executeBatch(batch);
        
        test.stopTest();
    }
    
    
}