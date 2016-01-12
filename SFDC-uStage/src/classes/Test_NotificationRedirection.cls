@isTest(seeAllData=true)
private class Test_NotificationRedirection {

    static testMethod void myUnitTest() {   	
    	
    	  RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com');
        insert participantAccount;
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10),Country__c='Australia',
                                                Host_Company_Id__c = account.Id, Status__c='Matching'
                                                );
        insert position;
        
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
         Match__c match = new Match__c(Name = 'Test Match',
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
        
          Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotification.Intrax_Program__c = match.Intrax_Program__c;     
                newNotification.Intrax_Program_Options__c = match.Intrax_Program_Option__c;        
             
                insert newNotification; 
            List<User> sysAdmin = [select Id from user where Profile.Name = 'System Administrator'];  
       
         Notification__c ObjNotification = new Notification__c();
                ObjNotification.Subject__c = 'Your Recommended Students';            
                ObjNotification.Body__c = 'Ayusa has recommended some students for your family! Click here to view these students and finalize your match today!';            
                ObjNotification.Type__c = 'Recommended Students';               
                ObjNotification.Position__c = position.Id;               
                ObjNotification.Status__c = 'Not Started';
                ObjNotification.Intrax_Program__c = match.Intrax_Program__c;     
                ObjNotification.Intrax_Program_Options__c = match.Intrax_Program_Option__c;     
                ObjNotification.Parent_Notification__c = newNotification.Id;
                ObjNotification.Action_URL__c = 'NotificationRedirection?NotifyRec=true';
                ObjNotification.OwnerId = sysAdmin[0].Id;
             insert ObjNotification;   
             
             Notification__c ObjNotification1 = new Notification__c();
                ObjNotification1.Subject__c = 'Your Recommended Students';            
                ObjNotification1.Body__c = 'Ayusa has recommended some students for your family! Click here to view these students and finalize your match today!';            
                ObjNotification1.Type__c = 'Recommended Students';               
                ObjNotification1.Match__c = match.Id;               
                ObjNotification1.Status__c = 'Not Started';
                ObjNotification1.Intrax_Program__c = match.Intrax_Program__c;     
                ObjNotification1.Intrax_Program_Options__c = match.Intrax_Program_Option__c;     
                ObjNotification1.Parent_Notification__c = newNotification.Id;
                ObjNotification1.Action_URL__c = 'NotificationRedirection?NotifyRec=true';
                ObjNotification1.OwnerId = sysAdmin[0].Id;
             insert ObjNotification1;                                
               // 
       test.startTest();                  
        ApexPages.currentPage().getParameters().put('posId',position.Id);
        NotificationRedirectionController nrc = new NotificationRedirectionController();        
        pagereference pg = nrc.redirect();
        
         ApexPages.currentPage().getParameters().put('NotifyRec','true');
         NotificationRedirectionController nrc1 = new NotificationRedirectionController();       
        pagereference pg1 = nrc1.redirect();
        
           ApexPages.currentPage().getParameters().put('ConfmatId',match.Id);
         NotificationRedirectionController nrc2 = new NotificationRedirectionController();
              pagereference pg2 = nrc2.redirect();
         //Record Type
        test.stopTest();

    }
    
}