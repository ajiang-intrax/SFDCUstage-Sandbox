@isTest(SeeAllData=true)
private class Test_HFPortal_Controller {

    static testMethod void myUnitTest() {
        
        User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
        
        //Run in user context
        //system.runAs(sysAdmin) {
            /*
        //Record Type
        RecordType partnerRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Account
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        */
        //Account
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Contracted',PersonBirthdate = date.newInstance(1998, 01, 01),
                                                    RecordTypeId = participantAccountRecordType.Id, Citizenship__pc = 'United States',
                                                    Intrax_Programs__c = 'Ayusa', type='Participant',
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com', Nationality__c = 'Spain');
        insert participantAccount;
        
        // Creating a few engagement records
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        Engagement__c engagement1 = new Engagement__c(Name='Test Engagement 1', Account_Id__c = participantAccount.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Program_Duration__c ='Academic Year',Placement_Status__c = 'Not Placed',
                                                     Program_Year__c ='2013', Status__c = 'Processing', Needs_Travel__c ='Yes', Gender__c = 'Female');
        insert engagement1;
        
        Engagement__c engagement2 = new Engagement__c(Name='Test Engagement 2', Account_Id__c = participantAccount.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Program_Duration__c ='Academic Year',Placement_Status__c = 'Not Placed',
                                                     Program_Year__c ='2013', Status__c = 'Processing', Needs_Travel__c ='Yes', Gender__c = 'Female');
        insert engagement2;
        
        /*
        Engagement__c engagement2 = new Engagement__c(Name='Test Engagement 2', Account_Id__c = participantAccount.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Processing', Needs_Travel__c ='Yes', Gender__c = 'Male');
        insert engagement2;
        */
        RecordType applicationRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Ayusa PT' Limit 1];
        RecordType applicationHFRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Ayusa HF' Limit 1];
        //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                          Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                          Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test',
                                                          Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', RecordTypeId = applicationRecordType.Id,
                                                          Special_Diet_Indicated__c = 'No', Engagement__c = engagement1.Id,
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                          Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                          Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                          Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                          Intrax_Program_Options__c = 'YES');
        insert appInfo;
        
        Essay__c studentGoals = new Essay__c(Name='Goals', Narrative__c = 'Goals Test', Applicant_Info__c = appInfo.Id);
        insert studentGoals;
        Essay__c studentLetter = new Essay__c(Name='Student Letter', Narrative__c = 'Letter Test', Applicant_Info__c = appInfo.Id);
        insert studentLetter;
        Essay__c studentInterests = new Essay__c(Name='Interest', Narrative__c = 'Interest Tests', Applicant_Info__c = appInfo.Id);
        insert studentInterests;
        Essay__c studentVolunteer = new Essay__c(Name='Volunteer', Narrative__c = 'Volunteer Tests', Applicant_Info__c = appInfo.Id);
        insert studentVolunteer;
        
        Intrax_Program_Upload__c familyPhoto = new Intrax_Program_Upload__c(Applicant_Info__c = appInfo.Id, Document_Type__c = 'Family', Name ='Family Photo Test', Document_Name__c = 'Test');
        insert familyPhoto;
        
        
            
            Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                          Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                          Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test',
                                                          Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', RecordTypeId = applicationHFRecordType.Id,
                                                          Special_Diet_Indicated__c = 'No', Engagement__c = engagement1.Id,
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                          Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                          Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                          Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                          Intrax_Program_Options__c = 'YES', Account__c = participantAccount.Id );
            insert appInfoHF;
            
            Opportunity opp = new Opportunity(Name = 'Test', AccountId = participantAccount.Id, CloseDate = Date.Today(), Project_Name__c = 'test',
                                                    App_Fee_Paid__c = true, Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', 
                                                    Engagement_Start__c = Date.today(), StageName = 'Closed Won');
            insert opp;
            
            RecordType posHFRecordType = [select id,Name from RecordType where SobjectType='Position__c' and Name='Ayusa HF' Limit 1];
        Position__c position1 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = appInfoHF.Account__c, Host_Opportunity_Id__c = opp.Id, 
                                                    Intrax_Program__c = 'Test', Status__c = 'Matching', RecordTypeId=posHFRecordType.Id, Country__c = 'Spain',
                                                Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3 );
            insert position1;
            
            RecordType matAyRecordType = [select id,Name from RecordType where SobjectType='Match__c' and Name='Ayusa' Limit 1];                    
        
        Match__c mat = new Match__c(Name = 'Test Match', Engagement__c = engagement1.Id, 
                                    Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Recommended', 
                                    RecordTypeId = matAyRecordType.Id, Recommendation_Expiration__c = System.now() );        
        insert mat;
          
        Match__c matCon = new Match__c(Name = 'Test Match', Engagement__c = engagement2.Id, 
                                    Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Confirmed', 
                                    Match_Type__c = 'Permanant',
                                    RecordTypeId = matAyRecordType.Id, Recommendation_Expiration__c = System.now() );        
        insert matCon;
             test.startTest();
            HFPortal_Controller hfp = new HFPortal_Controller();
            System.currentPageReference().getParameters().put('engagementId', engagement1.Id);
            
            hfp.checkLogin();
            
            hfp.getItems();
            //hfp.getSortDirection();
            
            hfp.getStudentLetterEssay(appInfo.Id);
            hfp.getStudentGoalsEssay(appInfo.Id);
            hfp.getStudentInterestsEssay(appInfo.Id);
            hfp.getStudentVolunteerEssay(appInfo.Id);
            
            hfp.nationalitySelected = 'Spain';
            hfp.genderSelected = 'Male';
            list<String> ages = new list<String>();
            ages.add('14'); ages.add('15'); ages.add('16'); ages.add('17');
            hfp.ageRangeSelected = ages;
            //hfp.setSortDirection('DESC');
            hfp.searchStudentsList();
            /*
            hfp.next();
            hfp.previous();
            hfp.first();
            hfp.last();
            */
            hfp.getNextButtonDisabled();
            hfp.getPreviousButtonDisabled();
            hfp.calculatePageSize(5);
            hfp.calculatePageSize(10);
            
            hfp.getMatchStatus();
            hfp.getProgDuration();
            hfp.getPositionId();
            
            
            hfp.SaveMatch();
            hfp.saveSelectedMatches();
            hfp.getCheckForSavedMatch();
            hfp.MatchStatusSelected='Saved Students';
            hfp.religionSelected='Catholic';
            List<String> studs = new List<String>{};
            studs.add('Badminton');
            hfp.studInterestSelected= studs;
            hfp.getPositionList();
        
            List<Position__c> lstPos = new List<Position__c>();
            lstPos.add(position1);
            //hfp.GetPosConfMatchesList(lstPos);
        
            hfp.getConfMatchText();
            ApexPages.CurrentPage().getParameters().put('participantId', engagement1.Id);
            //HFPortal_Controller hfp2 = new HFPortal_Controller();
            
         //}
    test.stopTest();   
    }
}