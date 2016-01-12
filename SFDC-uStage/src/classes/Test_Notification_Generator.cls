@isTest(seeAllData=true)
private class Test_Notification_Generator {

    static testMethod void myUnitTest() {
        
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     	test.startTest();
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        Notification_Generator ngen1 = new Notification_Generator(matchlist);
        ngen.matchList = matchlist;
        ngen.processAssessments();
        ngen.CreateHFInterviewNotification(AppInfo.Id);
        ngen.CreatePTOrientationNotification(matchlist[0].Id);
        ngen.getRecordTypesReady();        
        List<String> strMonthList = Notification_Generator.getMonthList(true);                
        
       
        
        test.stopTest();
       
       
    }
      static testMethod void myUnitTest3() {
        
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
       
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
               
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        test.startTest();
          set<id> tengid = new set<id>();
        
          tengid.add(PTengagement.ID);
        Notification_Generator.CreatePrimaryJobNotification(tengid);
        test.stopTest();
        }
    static testMethod void myUnitTest1() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     Applicant_Info__c igiappInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id,
                                                                  Visa_Category__c = 'Work (J)'
                                                                  );
        insert igiappInfo;
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        Notification_Generator ngen1 = new Notification_Generator(matchlist);
        ngen.matchList = matchlist;
        ngen.processAssessments();
        ngen.CreateHFInterviewNotification(AppInfo.Id);
        ngen.CreatePTOrientationNotification(matchlist[0].Id);
        ngen.getRecordTypesReady();
        List<String> strMonthList = Notification_Generator.getMonthList(true);
        
        
        
                
        test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        
        //Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
        
        
 Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     Applicant_Info__c igiappInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id,
                                                                  Visa_Category__c = 'Work (J)'
                                                                  );
        insert igiappInfo;
        test.startTest();
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        Notification_Generator ngen1 = new Notification_Generator(matchlist);
        ngen.matchList = matchlist;
        ngen.processAssessments();
        ngen.CreateHFInterviewNotification(AppInfo.Id);
        ngen.CreatePTOrientationNotification(matchlist[0].Id);
        ngen.getRecordTypesReady();
        List<String> strMonthList = Notification_Generator.getMonthList(true);
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        Engagement__c WTengagement1 = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement1;
        
        Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
        
 Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
     
        
        Match__c match2 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = WTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match2;
        
        Notification_Generator.CreateCandidateJobNotification(match2.id);
        Notification_Generator.CreateCandidateJobNotification(match2.id);
        test.stopTest();
    }
    
    
    static testMethod void myUnitTest40() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
       
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        
        
       /* Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;*/
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        
        update appInfo;
        
        set<Id> probEngForNotificationSet3 = new set<Id>{WTEngagement.Id};
        
        Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c(Name = 'test', Applicant_Info__c = appInfo.Id, Engagement__c = WTEngagement.Id ,Document_Type__c = 'Proof-of-Language-Level', Review_Status__c ='Accepted');
        insert ipu;
        Intrax_Program_Upload__c ipu1 = new Intrax_Program_Upload__c(Name = 'test1', Applicant_Info__c = appInfo.Id, Engagement__c = WTEngagement.Id ,Document_Type__c = 'Passport', Review_Status__c ='Accepted');
        insert ipu1;
        Intrax_Program_Upload__c ipu2 = new Intrax_Program_Upload__c(Name = 'test2', Applicant_Info__c = appInfo.Id, Engagement__c = WTEngagement.Id ,Document_Type__c = 'Resume', Review_Status__c ='Accepted');
        insert ipu2;
        Notification_Generator.MarkIGINotifyComplete(appInfo.Id, 'Hospitality & Tourism');
       
                
        test.stopTest();
    }
    
     static testMethod void myUnitTest400() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        //Notification_Generator ngen = new Notification_Generator();
       
       
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        
        
       /* Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;*/
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet3 = new set<Id>{WTEngagement.Id};
        
        Notification_Generator.UpdateNotification(WTEngagement.Id);
        
                
        test.stopTest();
    }
    
     static testMethod void myUnitTest4000() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
        
   
        
        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10),Country__c='Australia',
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
       
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
    
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];

      
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', 
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        //Notification_Generator ngen = new Notification_Generator();
       
     
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        
        
       /* Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;*/
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet3 = new set<Id>{WTEngagement.Id};
        
        Notification_Generator.sendIGIDocNotifications(probEngForNotificationSet3);
        
                
        test.stopTest();
    }
    
    static testMethod void myUnitTest44() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        //Notification_Generator ngen = new Notification_Generator();
       
 
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
                
        Engagement__c WTengagement1 = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement1;
        
       /* Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;*/
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement1.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement1.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        
        appInfo.Engagement__c = WTEngagement1.Id;
        update appInfo;
        
        set<Id> probEngForNotificationSet3 = new set<Id>{WTEngagement1.Id};
        
        Notification_Generator.CreateDepartureNotification(probEngForNotificationSet3);
         
                
        test.stopTest();
    }
    static testMethod void myUnitTest444() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
 
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
                
        Engagement__c WTengagement1 = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement1;
        
       /* Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;*/
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement1.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement1.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        
        appInfo.Engagement__c = WTEngagement1.Id;
        update appInfo;
        
        set<Id> probEngForNotificationSet3 = new set<Id>{WTEngagement1.Id};
        
       Notification_Generator.MarkIGINotifyComplete(appInfo.Id, 'Business');
       
        
                
        test.stopTest();
    }
    static testMethod void myUnitTest4444() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        //Notification_Generator ngen = new Notification_Generator();
       
      
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
                
        Engagement__c WTengagement1 = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement1;
        
       /* Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;*/
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement1.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement1.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        
        appInfo.Engagement__c = WTEngagement1.Id;
        update appInfo;
        
        set<Id> probEngForNotificationSet3 = new set<Id>{WTEngagement1.Id};
        
        Notification_Generator.MarkIGINotifyComplete(appInfo.Id, 'Social Development');
      
        
                
        test.stopTest();
    }
     static testMethod void myUnitTest5() {
        
        //Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     	test.startTest();
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        //Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        Notification_Generator ngen1 = new Notification_Generator(matchlist);
        //ngen.matchList = matchlist;
        //ngen.processAssessments();
        ngen1.CreateHFInterviewNotification(AppInfo.Id);
        //ngen.CreatePTOrientationNotification(matchlist[0].Id);
        ngen1.getRecordTypesReady();
        List<String> strMonthList = Notification_Generator.getMonthList(true);
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert IGIengagement;
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        //probEngForNotificationSet.add(engagement.Id);
        Notification_Generator.sendWTOrientation(probEngForNotificationSet);
        WTEngagement.Status__c = 'On Program';
        WTEngagement.Placement_Status__c = 'Not Placed';
        update WTEngagement;
        set<Id> probEngForNotificationSet5 = new set<Id>{WTEngagement.Id};
        Notification_Generator.sendWTOrientation(probEngForNotificationSet5);
        
        
        
        // WT Check-In Assessments
        map<Id, Id> probEngForNotificationMap = new map<Id, Id>();
        probEngForNotificationMap.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        Notification_Generator.sendWTCheckInNotification(probEngForNotificationMap);
        
        // WT MC Assessments
        RecordType assessmentWTMC_RT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWT_MC = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTMC_RT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWT_MC;
       
        
        //Notification_Generator.CreateJobOfferNotification(match1.id);
        test.stopTest();
       
       
    }
    
    static testMethod void myUnitTest6() {
        
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     	test.startTest();
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        Notification_Generator ngen1 = new Notification_Generator(matchlist);
        ngen.matchList = matchlist;
        ngen.processAssessments();
        ngen.CreateHFInterviewNotification(AppInfo.Id);
        //ngen.CreatePTOrientationNotification(matchlist[0].Id);
        ngen.getRecordTypesReady();
        List<String> strMonthList = Notification_Generator.getMonthList(true);
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert IGIengagement;
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        //probEngForNotificationSet.add(engagement.Id);
        Notification_Generator.sendWTOrientation(probEngForNotificationSet);
        WTEngagement.Status__c = 'On Program';
        WTEngagement.Placement_Status__c = 'Not Placed';
        update WTEngagement;
        set<Id> probEngForNotificationSet5 = new set<Id>{WTEngagement.Id};
        Notification_Generator.sendWTOrientation(probEngForNotificationSet5);
        
        
        
        // WT Check-In Assessments
        map<Id, Id> probEngForNotificationMap = new map<Id, Id>();
        probEngForNotificationMap.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        Notification_Generator.sendIGICheckInNotification(probEngForNotificationMap);
        
        test.stopTest();
       
       
    }
    
    
    
    static testMethod void myUnitTest7() {
        
        //Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     	test.startTest();
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
       
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert IGIengagement;
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        //probEngForNotificationSet.add(engagement.Id);
        Notification_Generator.sendWTOrientation(probEngForNotificationSet);
        WTEngagement.Status__c = 'On Program';
        WTEngagement.Placement_Status__c = 'Not Placed';
        update WTEngagement;
        set<Id> probEngForNotificationSet5 = new set<Id>{WTEngagement.Id};
        Notification_Generator.sendWTOrientation(probEngForNotificationSet5);
        
        
        
        // WT Check-In Assessments
        map<Id, Id> probEngForNotificationMap = new map<Id, Id>();
        probEngForNotificationMap.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        Notification_Generator.sendWTCheckInNotification(probEngForNotificationMap);
        
        // WT MC Assessments
        RecordType assessmentWTMC_RT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWT_MC = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTMC_RT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWT_MC;
        map<Id, Id> probEngForNotificationMap_MC = new map<Id, Id>();//{WTEngagement.Id};
        probEngForNotificationMap_MC.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        //probEngForNotificationSet.add(engagement.Id);
        Notification_Generator.sendWTMonthlyContactNotification(probEngForNotificationMap_MC);
        
        list <member__c> member1 = [SELECT ID, Email__c, Account_Name__r.PersonEmail FROM Member__c LIMIT 1];
        
        Notification_Generator.CreateMemberBGCReqNotification(member1);
         Notification_Generator.CreateHFApprovalNotification(HFPositions);
         
            
         list<Match__c> HFMatches = new list<Match__c>();
         HFMatches.add(match1);
             
          Notification_Generator.CreateRecommendedStuNotification(HFMatches); 
          
         // match1.Status__c='Confirmed';
          //update match1;
          
         // list<Match__c> HFConfMatches = new list<Match__c>();
          // HFConfMatches.add(match1);        
         //  Notification_Generator.CreateConfirmedStuNotification(HFConfMatches);
          
        //list <Notification__c> notf = [SELECT Engagement__c, ID FROM Notification__c WHERE Engagement__c != NULL LIMIT 1];
        
        list <Notification__c> notf = new list <Notification__c>();
        Map<Engagement__c,List<Notification__c>> notfmap = new map<Engagement__c, List<Notification__c>>();
        notfmap.put(engagement, notf);
        
        Notification_Generator.createNotification(notfmap);
        
        
        test.stopTest();
       
       
    }
    
     static testMethod void myUnitTest8() {
        
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     Applicant_Info__c igiappInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Internship', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id,
                                                                  Visa_Category__c = 'Work (J)'
                                                                  );
        insert igiappInfo;
     	
        test.startTest();
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        List<String> strMonthList = Notification_Generator.getMonthList(true);
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        Engagement__c WTengagement1 = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement1;
        
        Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
                                                        
                                                        
        insert IGIengagement;
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
       
        igiappInfo.Engagement__c = IGIEngagement.Id;
        if(sysAdmin!=null && sysAdmin.size()>0)
        igiappInfo.CreatedBy__c = sysAdmin[0].Id;
        update igiappInfo;
        
        set<Id> probEngForNotificationSet1 = new set<Id>{IGIEngagement.Id};
        Notification_Generator.sendIGINotifications(probEngForNotificationSet1);
        
        IGIEngagement.Visa_Interview_Date__c = date.today();
        update IGIEngagement;
        set<Id> probEngForNotificationSet2 = new set<Id>{IGIEngagement.Id};
        Notification_Generator.sendIGINotifications(probEngForNotificationSet2);
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        
        Notification_Generator.CreateDepartureNotification(probEngForNotificationSet);
        
            
                
        test.stopTest();
    }
    
    static testMethod void myUnitTest9() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id, Status__c = 'Matching'
                                                );
        insert position;
        
        
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
          
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
       
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 95), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2014', Status__c = 'On Program', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = WTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_IGI_PT_Mid_Program)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        //probEngForNotificationSet.add(engagement.Id);
        //Notification_Generator.sendWTOrientation(probEngForNotificationSet);
        WTEngagement.Status__c = 'On Program';
        WTEngagement.Placement_Status__c = 'Not Placed';
        update WTEngagement;
        set<Id> probEngForNotificationSet5 = new set<Id>{WTEngagement.Id};
    //    Notification_Generator.sendWTOrientation(probEngForNotificationSet5);
        
        
        
        // IGI Mid Program Assessments
        map<Id, Id> probEngForNotificationMap = new map<Id, Id>();
        probEngForNotificationMap.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        Notification_Generator.sendIGIMidProgramNotification(probEngForNotificationMap);
        
         // IGI Final Program Assessments
         
        RecordType assessmentIGIRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_IGI_PT_Final_Program)];
        Assessment__c assessmentIGIPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentIGIRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentIGIPT;
         
        map<Id, Id> probEngForNotificationMapFinal = new map<Id, Id>();
        probEngForNotificationMapFinal.put(assessmentIGIPT.Engagement__c, assessmentIGIPT.Id);
        Notification_Generator.sendIGIFinalProgramNotification(probEngForNotificationMapFinal);
        
        test.stopTest();
       
       
    }
    
     static testMethod void myUnitTest10() {
        test.startTest();
        Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id, Status__c = 'Matching'
                                                );
        insert position;
        
      
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
       
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 95), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2014', Status__c = 'On Program', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_IGI_PT_Monthly_Contact)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        //probEngForNotificationSet.add(engagement.Id);
        //Notification_Generator.sendWTOrientation(probEngForNotificationSet);
        WTEngagement.Status__c = 'On Program';
        WTEngagement.Placement_Status__c = 'Not Placed';
        update WTEngagement;
        set<Id> probEngForNotificationSet5 = new set<Id>{WTEngagement.Id};
    //    Notification_Generator.sendWTOrientation(probEngForNotificationSet5);
        
        
        
        // IGI Mid Program Assessments
        map<Id, Id> probEngForNotificationMap = new map<Id, Id>();
        probEngForNotificationMap.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        Notification_Generator.sendIGIMonthlyContactNotification(probEngForNotificationMap);
        
        test.stopTest();
       
       
    }
    
     static testMethod void myUnitTest11() {
        
        //Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
        test.startTest();
     
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        Notification_Generator ngen1 = new Notification_Generator(matchlist);
        ngen.matchList = matchlist;
        ngen.processAssessments();
        ngen.CreateHFInterviewNotification(AppInfo.Id);
        //ngen.CreatePTOrientationNotification(matchlist[0].Id);
        ngen.getRecordTypesReady();
        List<String> strMonthList = Notification_Generator.getMonthList(true);
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert IGIengagement;
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        //probEngForNotificationSet.add(engagement.Id);
        Notification_Generator.sendWTOrientation(probEngForNotificationSet);
        WTEngagement.Status__c = 'On Program';
        WTEngagement.Placement_Status__c = 'Not Placed';
        update WTEngagement;
        set<Id> probEngForNotificationSet5 = new set<Id>{WTEngagement.Id};
        Notification_Generator.sendWTOrientation(probEngForNotificationSet5);
        
        
        
        // WT Check-In Assessments
        map<Id, Id> probEngForNotificationMap = new map<Id, Id>();
        probEngForNotificationMap.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        Notification_Generator.sendWTCheckInNotification(probEngForNotificationMap);
        
        // WT MC Assessments
        RecordType assessmentWTMC_RT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWT_MC = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTMC_RT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWT_MC;
       
        set<id> midset = new set<id>();
        midset.add(match1.id);
        //Notification_Generator.CreateIGIInterviewNotification(midset);
        test.stopTest();
       
       
    }
    
     static testMethod void myUnitTest12() {
        
        //Notification_Generator ng = new Notification_Generator(new List<Match__c>());
        
         //Record Type
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
                                                Host_Company_Id__c = account.Id
                                                );
        insert position;
        
        position.Status__c = 'Matching';
        update position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
     List<Position__c> HFPositions = new  List<Position__c> ();
     HFPositions.add(position);
        //Assessment
        RecordType assessmentHFRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get('December'))];
        Assessment__c assessmentHF = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentHFRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentHF;
        
        //Assessment
        RecordType assessmentPTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get('December'))];
        Assessment__c assessmentPT = new Assessment__c(Name = 'Test Assessment', 
                                                        //Engagement__c = engagement.Id,
                                                        Time_Period__c = 'December',
                                                        Match_Name__c = match.Id, 
                                                        RecordTypeId = assessmentPTRT.Id,
                                                        Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessmentPT;        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = engagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES', Position__c = position.Id
                                                                  );
        insert appInfo;
        
     
     
        test.startTest();
        ApexPages.currentPage().getParameters().put('nextPage', 'Test');
        Notification_Generator ngen = new Notification_Generator();
       
        list<Match__c> matchlist = new list<Match__c>();
        matchlist.add(match);
        Notification_Generator ngen1 = new Notification_Generator(matchlist);
        ngen.matchList = matchlist;
        ngen.processAssessments();
        ngen.CreateHFInterviewNotification(AppInfo.Id);
        //ngen.CreatePTOrientationNotification(matchlist[0].Id);
        ngen.getRecordTypesReady();
        List<String> strMonthList = Notification_Generator.getMonthList(true);
        
        
        // WT Notifications
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
        
        RecordType IGIengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Engagement
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Work Travel', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert WTengagement;
        
        Engagement__c IGIengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = IGIengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert IGIengagement;
        
         Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2013', Status__c = 'Not Placed', Needs_Travel__c ='Yes', 
                                                        SEVIS_ID__c = '11111111');
        insert PTengagement;
        
         Opportunity op1 = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op1;
        
         Match__c match1 = new Match__c(Name = 'Test Match1', 
                                        Position_Name__c = position.Id, Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        //Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op1.Id);
        insert match1;
        
        RecordType assessmentWTRT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWTPT = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTRT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWTPT;
        
        appInfo.Engagement__c = WTEngagement.Id;
        List<User> sysAdmin = [select Id from user where userName = : Constants.Sys_Admin];
        if(sysAdmin!=null && sysAdmin.size()>0)
        appInfo.CreatedBy__c = sysAdmin[0].Id;
        
        update appInfo;
        
        
        set<Id> probEngForNotificationSet = new set<Id>{WTEngagement.Id};
        //probEngForNotificationSet.add(engagement.Id);
        Notification_Generator.sendWTOrientation(probEngForNotificationSet);
        WTEngagement.Status__c = 'On Program';
        WTEngagement.Placement_Status__c = 'Not Placed';
        update WTEngagement;
        set<Id> probEngForNotificationSet5 = new set<Id>{WTEngagement.Id};
        Notification_Generator.sendWTOrientation(probEngForNotificationSet5);
        
        
        
        // WT Check-In Assessments
        map<Id, Id> probEngForNotificationMap = new map<Id, Id>();
        probEngForNotificationMap.put(assessmentWTPT.Engagement__c, assessmentWTPT.Id);
        Notification_Generator.sendWTCheckInNotification(probEngForNotificationMap);
        
        // WT MC Assessments
        RecordType assessmentWTMC_RT = [SELECT Id FROM RecordType WHERE Id =: (Constants.ASS_WT_PT_Check_In)];
        Assessment__c assessmentWT_MC = new Assessment__c(Name = 'Test Assessment', 
                                                        Engagement__c = WTengagement.Id,
                                                        RecordTypeId = assessmentWTMC_RT.Id,
                                                        ManualShareExists__c = true
                                                        );
        insert assessmentWT_MC;
       
        set<id> midset = new set<id>();
        midset.add(match1.id);
        //Notification_Generator.CreateIGIOfferNotification(midset);
        test.stopTest();
       
       
    }
    
    Static testMethod void initTEST(){
    	test.startTest();
    	Notification_Generator NG = new Notification_Generator();
    	NG.taskList = new List<Task>();
    	NG.taskListNotified = new List<Task>();
    	NG.matchListNotified = new List<Match__c>();
    	NG.notificationList = new List<Notification__c>();
    	NG.task = new Task();
    	NG.ProcessedPT = new Map<Id,Match__c>();
    	NG.ProcessedCo = new Map<Id,Match__c>();
    	NG.NotifyAbtMatch = new Map<Id,Match__c>();
    	NG.NotifyAbtAcc = new Map<Id,List<Match__c>>();
    	NG.NotifyAbtPos = new Map<Id,Map<Id,List<Match__c>>>();    	
    	test.stopTest();
    }
   static testMethod void myUnitTestforAPCPT() {
        
         //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        RecordType rtAPCPT_Eng = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Becoming an au pair';
        
         //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
            insert user;
            
          //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
         
            //Run in user context
            System.runAs(sysAdmin) {
        
                //AA Applicant Info APCPT
                Applicant_Info__c appInfoAPCPT_old = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                                  Sales_Notes__c=null,
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',Allow_Intrax_To_Apply__c=True,
                                                                  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPCPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Language_3__c='English',Language_2__c='',Language_1__c='',
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
                                                                  Engagement_Start__c = System.today()-2, Accommodation_Preference__c = 'Homestay',Application_Level__c='Basic',Intrax_Program__c='AuPairCare',Application_Type__c='Orignal',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfoAPCPT_old;
                
                Applicant_Info__c appInfoAPCPT_new = new Applicant_Info__c(Name = 'test-APC-new', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                                  Sales_Notes__c='Sales Notes', Account__c = portalAccount.Id,
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',Allow_Intrax_To_Apply__c=True,
                                                                  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPCPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Language_3__c='English',Language_2__c='',Language_1__c='',
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
                                                                  Engagement_Start__c = System.today()-2, Accommodation_Preference__c = 'Homestay',Application_Level__c='Main',Intrax_Program__c='AuPairCare',Application_Type__c='Orignal',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfoAPCPT_new;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true, Email__c='old_apcpt@test.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoAPCPT_old.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                Person_Info__c personInfo_new = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true, Email__c='new_apcpt@test.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfoAPCPT_new.Id, Emergency_Contact_Indicated__c = 'Yes',RecordTypeId = constants.APC_Participant_Record_Type_Id,
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo_new;
                Engagement__c PTengagement = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = rtAPCPT_Eng.ID,
                                                        Intrax_Program__c = 'AuPaircare',Intrax_Program_Options__c = 'Infant Specialized', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2015', Status__c = 'Not Placed', Needs_Travel__c ='Yes',
                                                        Arrival_PNR_Number__c = null,Departure_PNR_Number__c=null
                                                        );
              insert PTengagement;
              Engagement__c PTengagement_new = new Engagement__c(Name='Test Engagement1_new', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = rtAPCPT_Eng.ID,
                                                        Intrax_Program__c = 'AuPaircare',Intrax_Program_Options__c = 'Infant Specialized', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',                                                        
                                                        Program_Year__c ='2015', Status__c = 'Not Placed', Needs_Travel__c ='Yes',
                                                        Arrival_PNR_Number__c = '34324234',Departure_PNR_Number__c=234234
                                                        );
              insert PTengagement_new;
               RecordType rtposition = [select id, Name from RecordType where SobjectType='Position__c' and Name='AuPairCare HF' Limit 1];
        
               Account myAccountpo = new Account(Name='Test');
               insert myAccountpo;
        
               Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c = myAccountpo.Id, Status__c ='Matching', Country__c = 'United States', 
                                    RecordTypeId =rtposition.id,Pets__c = 'Yes', Pet_Types__c = 'Dog');
               insert myPosition;
               RecordType rtmatch = [select id, Name from RecordType where SobjectType='Match__c' and Name='AuPairCare' Limit 1];
               Match__c match1 = new Match__c(Name = 'Test Match1', 
                                         Status__c = 'Applied', 
                                        Engagement__c = PTengagement.Id, 
                                        start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10),
                                        Offer_Status__c = 'Applied',
                                        Position_Name__c=myPosition.Id,
                                        //Portal_Contact_ID__c = contact.Id,
                                        RecordTypeId=rtmatch.id,
                                        Interview_Status__c = 'Scheduled');
               insert match1;
               Match__c match2 = new Match__c(Name = 'Test Match2', 
                                         Status__c = 'Confirmed', 
                                        Offer_Status__c = 'Confirmed',
                                        Engagement__c = PTengagement.Id, 
                                        start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10), Position_Name__c=myPosition.Id,
                                        //Portal_Contact_ID__c = contact.Id,
                                        RecordTypeId=rtmatch.id,
                                        Interview_Status__c = 'Scheduled');
                insert match2;

                Match__c match22 = new Match__c(Name = 'Test Match22', 
                                        Status__c = 'Ended Early', 
                                        Offer_Status__c = 'Confirmed',
                                        Engagement__c = PTengagement.Id, 
                                        start_date__c=(date.today() -10),
                                        End_Date__c = (date.today() +10), Position_Name__c=myPosition.Id,
                                        //Portal_Contact_ID__c = contact.Id,
                                        RecordTypeId=rtmatch.id,
                                        Interview_Status__c = 'Scheduled');
                insert match22;

                list<Match__c> mlist44 = new list<Match__c>();
                mlist44.add(match2);
                
                RecordType rtassCPT = [select id, Name from RecordType where SobjectType='Assessment__c' and Name='APC Exit Interview' Limit 1];
                Assessment__c ass = new Assessment__c(Name = 'test', Match_Name__c = match2.Id, RecordTypeId = rtassCPT.Id , Status__c = 'Confirmed');
                insert ass;
                
                Position_Info__c posInfo = new Position_Info__c(Applicant_Info__c = appInfoAPCPT_old.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',Functional_Areas__c = 'Accounting');
                insert posInfo;
                Position_Info__c posInfo_new = new Position_Info__c(Applicant_Info__c = appInfoAPCPT_new.Id, Company_Name__c = 'Test', Position_Title__c = 'Test', Intrax_Program_Category__c = 'Business', Tipped_Position__c = 'Yes',Functional_Areas__c = 'Accounting');
                insert posInfo_new;
                Selection__c s_old = new Selection__c(Name='Test1', Intrax_Program__c='AuPairCare',Engagement__c=PTengagement.Id, Position__c=myPosition.Id,Status__c='Inactive');
                insert s_old;
                Selection__c s_new = new Selection__c(Name='Test2', Intrax_Program__c='AuPairCare',Engagement__c=PTengagement_new.Id, Position__c=myPosition.Id,Status__c='Active');
                insert s_new;

                Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c(Name = 'test', Engagement__c = PTengagement_new.Id ,Document_Type__c = 'Proof-of-Education', Review_Status__c ='Accepted');
                insert ipu;
                Test.startTest();
                Notification_Generator NG = new Notification_Generator();
                appInfoAPCPT_old.Application_Stage__c = 'Submitted';
                appInfoAPCPT_new.Application_Stage__c = 'Working';
                Notification_Generator.callAPCNotifications(appInfoAPCPT_old,appInfoAPCPT_new);
                Notification_Generator.iAmAlreadyCalled=false;
                appInfoAPCPT_old.Sales_notes__c = null;
                appInfoAPCPT_new.Sales_notes__c = 'Sales notes';
                
                Notification_Generator.callAPCNotifications(appInfoAPCPT_old,appInfoAPCPT_new);
                Notification_Generator.iAmAlreadyCalled=false;
                Notification_Generator.callAPCNotifications(PTengagement,PTengagement_new);
                PTengagement_new.Arrival_PNR_Number__c=null;
                Notification_Generator.iAmAlreadyCalled=false;
                Notification_Generator.callAPCNotifications(PTengagement,PTengagement_new);
                Notification_Generator.iAmAlreadyCalled =false;
                Notification_Generator.callAPCNotifications(match1,match2);
                Notification_Generator.iAmAlreadyCalled =false;
                Notification_Generator.callAPCNotifications(match1,match2);
                Notification_Generator.iAmAlreadyCalled =false;
                Notification_Generator.callAPCNotifications(s_old,s_new);
                s_old=null;
                Notification_Generator.iAmAlreadyCalled =false;
                Notification_Generator.callAPCNotifications(s_old,s_new);
                Notification_Generator.createAPCNotificationFromCS(s_new,'Participant', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]', 'nfUrgency', 'Host', true);
                Notification_Generator.createAPCNotificationFromCS(s_new,'Host', 'nfShortSum', 'nfSubject', 'nfBody', 'nfDynamic', 'nfUrgency', 'Participant', true); 
                Notification_Generator.createAPCNotificationFromCS(match1,'Parent', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]', 'nfUrgency', 'Participant', true);
                Notification_Generator.createAPCNotificationFromCS(match22,'Partner', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]', 'nfUrgency', 'Host', true);
                
                Notification_Generator.createAPCNotificationFromCS(appInfoAPCPT_new,'Host', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]' , 'nfUrgency', 'Partner', true);
                Notification_Generator.createAPCNotificationFromCS(appInfoAPCPT_new,'Participant', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]' , 'nfUrgency', 'Participant', true);
                
                Notification_Generator.createAPCNotificationFromCS(PTengagement_new,'Participant', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]', 'nfUrgency', 'Host', true);
                Notification_Generator.createAPCNotificationFromCS(PTengagement_new,'Host', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]', 'nfUrgency', 'Participant', true);
                
                Notification_Generator.createAPCNotificationFromCS(ipu,'nfType', 'nfShortSum', 'nfSubject', 'nfBody', '[LinkToPTinPTR] [LinkToAppPTinPTR] [ME_Name] [ME_Email] [ME_Phone] [Match__ArrivalDate] [Match_HFName] [Match__HFArrivalDate] [AcademyHotel] [AcademyAddress] [AcademyPhone] [Ass_MatchBreakDate] [Ass_MatchBreakDate] [Ass_EducationAllowanceOwed] [Ass_VacationDaysTaken] [Sel_EngName] [Sel_InterviewEndDate] [Sel_InterviewEndDate] [Eng_ArrivalTrip] [CurrentDate+2weeks] [Sel_InterviewEndDate]', 'nfUrgency', 'Participant', true);
                Notification_Generator.CreateConfirmedStuNotification(mlist44);
                Notification_Generator.CreateJobOfferNotification(match1.Id);
                Notification_Generator.CreateJobOfferNotification(match22.Id);
                Set<Id> engsetId = new Set<Id>();
                engsetId.add(PTengagement_new.Id);
                Notification_Generator.CreatePrimaryJobNotification(engsetId);

                String test434 = Notification_Generator.globalDomainURL; 
                APC_Academy_Details__c ad = Notification_Generator.academyDetails;
                Test.stopTest();
            }
            
    }
    
    
      
    
}