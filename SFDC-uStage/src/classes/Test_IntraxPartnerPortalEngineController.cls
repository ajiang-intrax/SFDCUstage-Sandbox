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
 /**  Description      :     Test class for IntraxPartnerPortalEngineController.
  * 
  *  Created Date      :     7/13/2013
  *
  *   Created By       :     Bill Feeheley
  *  
  *  Current vision    :     v1.0
  * 
  *  Revision Logs     :     v1.0 - Created
  *                
  *  Coverage          :     v1.0 - 95%
  *                   
  **/
@isTest(seeAllData=true)
private class Test_IntraxPartnerPortalEngineController {

    static testMethod void myUnitTest() {
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        //Fetch intract Id for this account id
        //Account hostAccount = [Select Id, Intrax_Id__c from Account where Id =: account.Id LIMIT 1];
        //System.debug('@@@@@@ value in hostAccount ' + hostAccount);
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        //Account
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com');
        insert participantAccount;
        
        //Contact
        Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_intrax_program_default__c='Ayusa');
        insert contact;
        
        //Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = participantAccount.Id, Program_Year__c = '2013',
                                                    Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started');
        insert opportunity;
        
        //Record Type
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, engagementRecordType != null);
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test11 Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes',Placement_Status__c='Confirmed');
        insert engagement;
        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, partnerApplicationRecordType != null);
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Check for list Size
        if(profiles.size() > 0) {
            /*
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c = partnerAccount.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
            
            insert user;
            */
            User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                List<User> users = [select Id, Intrax_Id__c from User where Id = : userInfo.getUserId()]; 
                System.debug('######### value in user Id ' + users);
                 
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = users[0].Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Intrax_Program_Options__c = 'YES', PageStatus_Complete__c = '041');
                insert appInfo;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                //Attachment
                Attachment attach=new Attachment();     
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId= appInfo.id;
                attach.Description = 'Test';
                insert attach;
                
                //Assert for Result
                List<Attachment> attachments =[select id, name from Attachment where parent.id=: appInfo.id];
                System.assertEquals(1, attachments.size());
                
                //Update Applicant Info for Photo Id field
                appInfo.PhotoId__c = attach.Id;
                update appInfo;
                
                //Position
                Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia',Tipped_Position__c='No');
                insert position;
                
                //School
                School__c school = new School__c(Name = 'Test School', Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Match
                Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned', 
                                                Engagement__c = engagement.Id, 
                                                Portal_Contact_ID__c = contact.Id,
                                                Interview_Status__c = 'Scheduled');
                insert match;
                
                //Trip
                Trip__c trip = new Trip__c(Match__c = match.Id, Engagement__c = engagement.Id);
                insert trip;
                
                //Assessment
                Assessment__c assessment = new Assessment__c(Name = 'Test Assessment', Engagement__c = engagement.Id,
                                                             Match_Name__c = match.Id, Resident_Participants__c = '2', Resident_Total__c = '2');
                insert assessment;
                
                //Start test from here
                Test.startTest();
                
                //Calling constructor
                Test.setCurrentPage(Page.pr_app_list);
                
                //Setting value of the parameter
                ApexPages.currentPage().getParameters().put('isAssessments', 'true');
                ApexPages.currentPage().getParameters().put('isNeedsTravel', 'true');
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                ApexPages.currentPage().getParameters().put('AssessmentId', assessment.Id);
                ApexPages.currentPage().getParameters().put('campId', 'test');
                ApexPages.currentPage().getParameters().put('search', 'test');
                ApexPages.currentPage().getParameters().put('AppName', 'test');
                ApexPages.currentPage().getParameters().put('EngName', 'test');
                ApexPages.currentPage().getParameters().put('AppId', appInfo.Id);
                ApexPages.currentPage().getParameters().put('ParticipantId', engagement.Id);
                ApexPages.currentPage().getParameters().put('progId', 'test');
                ApexPages.currentPage().getParameters().put('notStartedAssApps', 'yes');
                ApexPages.currentPage().getParameters().put('incompleteAssApps', 'yes');
                ApexPages.currentPage().getParameters().put('toHealthReviewApps', 'yes');
                
                ApexPages.currentPage().getParameters().put('ApplicationLevelSelected', 'Main');
                ApexPages.currentPage().getParameters().put('ApplicationStageSelected', 'Declined');
                ApexPages.currentPage().getParameters().put('toHealthReviewApps', 'test');
                ApexPages.currentPage().getParameters().put('partPartnerAccSelected', 'test');
                
                ApexPages.currentPage().getParameters().put('programDurationSelected', 'test');
                ApexPages.currentPage().getParameters().put('programYearSelected', 'test');
                ApexPages.currentPage().getParameters().put('ProgramSeasonSelected', 'test');
                ApexPages.currentPage().getParameters().put('IntraxRegionSelected', 'test');
                ApexPages.currentPage().getParameters().put('StatusSelected', 'Match Pending');
                ApexPages.currentPage().getParameters().put('IntraxProgramSelected', 'Ayusa');
                
                
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                
                // Auxiliary Functions
                controller.getIncompleteMissingDocs();
                controller.getSelectedPicklistValues(participantAccount.Intrax_Programs__c);
                
                controller.match = match;
                controller.updateMatch();
                
                try{
                    controller.load();
                    controller.deletefile();
                }catch(Exception e){}
                try{
                    controller.deletefile();
                }catch(Exception e){}
                
                controller.uploadDocs();
                String aux1 = 'Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate, Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.name, Engagement__r.Name,'  
                                + 'SNK_Indicated__C, Double_Placement_Indicated__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Placement_Type__c, Participant_Opportunity_Id__r.Name,  Status__c FROM Match__c WHERE';
                controller.processSOQLQueryString(aux1);
                String aux2 = 'Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate, Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.name, Engagement__r.Name,'  
                                + 'SNK_Indicated__C, Double_Placement_Indicated__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Placement_Type__c, Participant_Opportunity_Id__r.Name,  Status__c FROM Match__c WHERE Name = Test AND';
                controller.processSOQLQueryString(aux2);
                
                controller.assessmentField = 'PTMayY';
                controller.getAssFieldSet();
                
                //Setting parameters
                controller.nextPage = '/apex/IntraxPartnerPortal_Participant';
                controller.reDirectPage = 'true';
                controller.docType = 'yes';
                 
                //Switching to Participant Page
                PageReference pageRef = Page.pr_pt_list;
                Test.setCurrentPage(pageRef);
                
                //Searching for Participant
                controller.doSearchForParticipant();
                //Searching for Assessments
                
                controller.IntraxProgramSelected='Work Travel';
                controller.PlacementStatusSelected = 'Confirmed';
                controller.EngagementStatusSelected = 'Confirmed';
                controller.doSearchForParticipant();
                                               
                controller.itotalPageNumber = 90;
                controller.dofullCount();
                controller.dofullCount_app();
                
                //controller.listMatches();
                //controller.listAssessment();
                //controller.engagementIntraxProgram();
                
                //Calling Pagination methods
                controller.next();
                controller.first();
                controller.last();
                controller.lastForParticipant();
                controller.previous();
                controller.pageNavigationForParticipant();
                controller.lastForAssessment();
                controller.pageNavigationForAssessment();
                controller.firstForApplications();
                controller.nextforApplications();
                controller.previousforApplications();
                
                
                controller.CampStrURL = 'test';
                controller.partialUrl = 'test';
                controller.derivedUrl = 'test';
                controller.orgId = 'test';
                controller.strEid = 'test';
                controller.retParam1 = 'test';
                controller.retParam2 = 'test';
                controller.retParam3 = 'test';
                controller.retParam4 = 'test';
                controller.retParam5 = 'test';
                controller.retParam6 = 'test';
                controller.retParam7 = 'test';
                controller.retParam8 = 'test';
                controller.retParam9 = 'test';
                controller.retParam10 = 'test';
                controller.retParam11 = 'test';
                controller.retParam12 = 'test';
                
                controller.responseXML = 'test';
                controller.returnURLHF = 'test';
                controller.returnURLListHF = new List<String>{'test','test2'};
                controller.position = position;
                controller.personPrimary = personInfo;
                controller.assId = appInfo.Id;
                controller.testsfdc = true;
                controller.EssayFamilyLetter = new List<Essay__c>();
                controller.FamilyLetter = new Essay__c();
                controller.listApplication = new List<Applicant_Info__c>{appInfo};
                
                controller.matchId = 'test';
                controller.listMatches = new List<Match__c>();
                
                controller.URLSearchValue = 'test';
                controller.engList = new List<Engagement__c>{engagement};
                controller.appList = new List<Applicant_Info__c>{appInfo};
                controller.SearchAgain();
                controller.OpenParticipantsWithSearch();
                controller.OpenApplicationsWithSearch();
                
                controller.listApplication = new List<Applicant_Info__c>();
                controller.listAssessment = new List<Assessment__c>();
                //controller.engagementIntraxProgram = 'test';
                controller.createMatchOptions = new List<SelectOption>();
                controller.positionId = position.Id;
                
                controller.viewSelected = 'Interviews to Start';
                //controller.engagementIntraxProgram = 'AuPairCare';
                
                //Setting Parameters
                controller.selectedParticipant  = engagement.Id;
                controller.checkLoginWithParticipantSearch();
                controller.doSearchForParticipant();
                controller.doActionForViewList();
                controller.openTIPPForm();
                //Switching to Participant Page
                pageRef = Page.pr_app_list;
                Test.setCurrentPage(pageRef);
                
                //Searching for Application
                controller.doSearch();
                
                //Setting parameter value
                ApexPages.currentPage().getParameters().put('workingStatus', 'true');
                ApexPages.currentPage().getParameters().put('notStartedAssApps', 'yes');
                ApexPages.currentPage().getParameters().put('incompleteAssApps', 'yes');
                ApexPages.currentPage().getParameters().put('toHealthReviewApps', 'yes');
                ApexPages.currentPage().getParameters().put('bgCheckReviewApps', 'yes');
                ApexPages.currentPage().getParameters().put('schoolDetailsVerifyApps', 'yes');
                
                controller.incompleteAssApps = new Set<Id>();
                controller.notStartedAssApps = new Set<Id>();
                controller.toHealthReviewApps = new Set<Id>();
                controller.bgCheckReviewApps = new Set<Id>();
                controller.schoolDetailsVerifyApps = new Set<Id>();
                //Searching for Application
                
                PageReference pageRefTemp = Page.pr_pt_match_details;
                Test.setCurrentPage(pageRefTemp);
                
                controller.doSearch();
                
                ApexPages.currentPage().getParameters().put('submittedStatus', 'true');
                
                //calling doSearchforCampaigns
                controller.doSearchforCampaigns();                
                
                //Calling Pagination methods
                controller.pageNavigation();
                
                //Switching to Participant Page
                pageRef = Page.Matches;
                Test.setCurrentPage(pageRef);
                
                //Searching for Application
                //controller.doSearchForMatches();
                
                //Calling Pagination methods
                //controller.checkLoginWithMatchSearch();
                controller.pageNavigationForMatch();
                controller.lastForMatches();
                
                //Setting Parameters
                controller.hostCompany = account;
                controller.selectedMatch = match.Id;
                controller.doSearchForMatches();
                
                //Setting variable
                Boolean myBoolean = controller.getNextButtonDisabledForParticipant();
                myBoolean = controller.getNextButtonDisabledForParticipant();
                myBoolean = controller.getPreviousButtonDisabledForParticipant();
                myBoolean = controller.getNextButtonDisabled();
                myBoolean = controller.getPreviousButtonDisabled();
                myBoolean = controller.getNextButtonDisabledForMatches();
                myBoolean = controller.getPreviousButtonDisabledForMatches();
                myBoolean = controller.getNextButtonDisabledForAssessments();
                myBoolean = controller.getPreviousButtonDisabledForAssessments();
                controller.sortExpression = 'ASC';
                controller.sortExpressionForAssessments = 'ASC';
                String direction = controller.getSortDirection();
                direction = controller.getSortDirectionForAssessments();
                controller.getItems();
                controller.setSortDirection('ASC');
                controller.setSortDirectionForAssessments('ASC');
                controller.sortExpression = '';
                controller.sortExpressionForAssessments = '';
                controller.getSortDirection();
                controller.getSortDirectionForAssessments();
                //controller.listApplication = new List<Applicant_Info__c>();
                //controller.listApplication.add(appInfo);
                //controller.listMatches.add(match);
                
                //Calling Other Methods
                controller.checkLogin();
                controller.addTravelInfo();
                controller.saveInfoOfTrip();
                controller.updateIndividualTrip();
                controller.backToTrips();
                controller.backToPartcipant();
                controller.backToMatches();
                controller.tripIdForDelete = trip.Id;
                list<Trip__c> listTrips = new list<Trip__c>();
                listTrips.add(trip);
                controller.listTrips = listTrips;
                controller.deleteTrip();
                
                controller.calculatePageSize(10);
                controller.IntraxProgramSelected = 'Ayusa';
                
                //Setting Parameters
                Apexpages.currentPage().getParameters().put('isPartner', 'true');
                controller.checkLogin();
                
                controller.totalPageNumber = 0;
                controller.pageNavigationForAssessment();
                controller.totalPageNumber = 0;
                controller.pageNavigationForParticipant();
                controller.totalPageNumber = 0;
                controller.pageNavigationForMatch();
                controller.totalPageNumber = 0;
                controller.pageNavigation();
                ApexPages.currentPage().getParameters().put('mOrigin', 'pos');
                controller.engagementId = engagement.Id;
                controller.createMatch();
                
                IntraxPartnerPortalEngineController.EngagementMatchWrapper EW = new IntraxPartnerPortalEngineController.EngagementMatchWrapper(engagement,match);
                                
                try {
                    controller.updateParticipant();
                    controller.updateMatch();
                    
                } catch (exception e) {
                    
                }
                
                controller.checkLoginWithReportSearch();
                controller.getallpartnerreports();
                controller.getReportUrl();
                
                //Setting Parameters
                Apexpages.currentPage().getParameters().put('participantId', engagement.Id);
                IntraxPartnerPortalEngineController controller1 = new IntraxPartnerPortalEngineController();
                
                controller.getDocList();
                controller.participant = engagement;
                controller.updateParticipant();
               controller.getPartDocList();
               controller.getVisaSupportLetter();
                 
                //Stop Test here
                Test.stopTest();
            }                  
        }    
    }
    
    
    static testMethod void myUnitTest2() {
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        //Contact
        Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'Ayusa');
        insert contact;
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        Intrax_Program_Upload__c ipu_pendingSchool = new Intrax_Program_Upload__c(Document_Type__c = 'Pre-Departure-Orientation-Agreement', Name='Test', Engagement__c = engagement.Id);
        insert ipu_pendingSchool;
        
        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia', Status__c='Matching');
        insert position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, Start_Date__c = System.TODAY(), End_Date__c = System.Today()+10,
                                        Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
        
        //Assessment
        Assessment__c assessment = new Assessment__c(Name = 'Test Assessment', Engagement__c = engagement.Id,
                                                     Match_Name__c = match.Id, Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessment;
        //Check for list Size
        if(profiles.size() > 0) {
            
            User user = [SELECT Id FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true LIMIT 1];
            User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(user) {
                Test.startTest();
                Test.setCurrentPage(Page.pr_app_list);
                //Searching for Participant
                ApexPages.CurrentPage().getParameters().put('isAssessments', 'true');
                ApexPages.currentPage().getParameters().put('mOrigin', 'mat');
                
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                controller.participant = engagement;
                controller.IntraxProgramSelected = 'Ayusa';
                controller.PlacementStatusSelected = 'Confirmed';
                controller.EngagementStatusSelected = 'On Program';
                controller.NeedsTravelSelected ='Yes';
                controller.PendingPDOSelected = 'No';
                controller.DoublePlacementSelected = 'false';
                controller.SingleNoChildrenSelected = 'false';
                controller.pendingSchoolSelected = 'Yes';
                
                controller.doSearchOnTheBasisOfPageSizeForParticipant();
                controller.getDefaultIP();
                Test.stopTest();
            }                  
        }    
    }
    
    
    static testMethod void myUnitTest2_1() {
                //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        //Contact
        Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contact;
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        Intrax_Program_Upload__c ipu_pendingSchool = new Intrax_Program_Upload__c(Document_Type__c = 'Pre-Departure-Orientation-Agreement', Name='Test', Engagement__c = engagement.Id);
        insert ipu_pendingSchool;
        
       //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia', Status__c='Matching');
        insert position;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        //Match
        Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id, 
                                        Portal_Contact_ID__c = contact.Id,
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
        insert match;
        
        //Assessment
        Assessment__c assessment = new Assessment__c(Name = 'Test Assessment', Engagement__c = engagement.Id,
                                                     Match_Name__c = match.Id, Resident_Participants__c = '2', Resident_Total__c = '2');
        insert assessment;
        //Check for list Size
        if(profiles.size() > 0) {
            
            User user = [SELECT Id FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true LIMIT 1];
            User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(user) {
                Test.startTest();
                Test.setCurrentPage(Page.pr_app_list);
                //Searching for Participant
                ApexPages.CurrentPage().getParameters().put('isAssessments', 'true');
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                controller.participant = engagement;
                
                controller.doSearchOnTheBasisOfPageSizeForParticipant();
                controller.loadphoto(ipu_pendingSchool.document_guid__c);
                Test.stopTest();
            }                  
        }    
    }
    
    static testMethod void myUnitTest5() {
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company Test123', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        
        list<Account> IntraxId = [SELECT Intrax_Id__c FROM Account WHERE Name = 'Host Company Test123' LIMIT 1];
        system.debug('********* Intrax Id: ' + IntraxId[0].Intrax_Id__c);
        
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        User user = [SELECT Id FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true LIMIT 1];
        user.Intrax_Id__c = IntraxId[0].Intrax_Id__c;
        update user;
        
        Campaign camp = new Campaign(Name = 'Campaign - Test', type = 'Hiring Tour', Status = 'Planned', partner_name__c = partnerAccount.Id, isActive = true);
        
        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia');
        insert position;
        
        Campaign_Position__c cp = new Campaign_Position__c (Name = 'City One - Partner', Campaign__c = camp.Id, 
                                                                Allocated_Quantity__c = 1, Expiration_Date__c = date.newInstance(2014, 1, 1), position__c = position.Id);
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        //Check for list Size
        if(profiles.size() > 0) {
            //Run in user context
            System.runAs(user) {
                Test.startTest();
                Test.setCurrentPage(Page.pr_app_list);
                //Searching for Participant
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                //controller.application = appInfo;
                //controller.IntraxProgramSelected = 'Ayusa';
                //controller.applicationLevelSelected = 'Main';
                //controller.applicationStageSelected = 'Working';
                //controller.FromDate = date.parse('01/01/2013');
                //controller.ToDate = date.parse('01/01/2014');
                controller.campaignSelected = 'Campaign - Test';
                
                //controller.doSearchForPageSize();
                
                controller.doSearchCampaignsForPageSize();
                controller.checkLoginWithCampaignSearch();
                
                Test.stopTest();
            }                  
        }    
    }
    
    
    static testMethod void myUnitTest4() {
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company Test123', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        
        list<Account> IntraxId = [SELECT Intrax_Id__c FROM Account WHERE Name = 'Host Company Test123' LIMIT 1];
        system.debug('********* Intrax Id: ' + IntraxId[0].Intrax_Id__c);
        
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        User user = [SELECT Id FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true LIMIT 1];
        user.Intrax_Id__c = IntraxId[0].Intrax_Id__c;
        update user;
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = user.Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Intrax_Program_Options__c = 'YES');
        insert appInfo;
        
        //ApexPages.currentPage().getParameters().put('AppId', appInfo.Id);
        //Check for list Size
        if(profiles.size() > 0) {
            //Run in user context
            System.runAs(user) {
                Test.startTest();
                //Searching for Participant
                Test.setCurrentPage(Page.pr_app_list);
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                list<string> appStages = new List<string>();
                appstages.add('working');
                
                controller.application = appInfo;
                controller.IntraxProgramSelected = 'Ayusa';
                controller.applicationLevelSelected = 'Main';
                controller.applicationStageSelected = appstages;
                controller.FromDate = date.parse('01/01/2013');
                controller.ToDate = date.parse('01/01/2014');
                
                controller.doSearchForPageSize();
                
                controller.doSearchOnTheBasisOfPageSizeForParticipant();
                controller.checkLoginWithApplicationSearch();
                
                Test.stopTest();
            }                  
        }    
    }
    
    static testMethod void myUnitTest3() {
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        Account partnerAccount  = new Account(Name = 'Host Company Test123', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        
        
        list<Account> IntraxId = [SELECT Intrax_Id__c FROM Account WHERE Name = 'Host Company Test123' LIMIT 1];
        system.debug('********* Intrax Id: ' + IntraxId[0].Intrax_Id__c);
        
        
        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),Single_No_Children_Indicated__c = 'Yes',
                                                Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia');
        insert position;
        
        //Engagement
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'On Program', Needs_Travel__c ='Yes');
        insert engagement;
                
        RecordType matchRecordType = [select id, Name from RecordType where SobjectType='Match__c' and Name='Ayusa' Limit 1];
        
        Match__c match = new Match__c (Name = 'Test Match', Portal_Contact_Id__c = partnerAccount.ID,
                                            Status__c = 'On Program', recordTypeId = matchRecordType.Id, 
                                            Position_Name__c = position.Id, Engagement__c = engagement.Id, Match_Type__c = 'Permanent'
                                            );
        
        User user = [SELECT Id FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true LIMIT 1];
        user.Intrax_Id__c = IntraxId[0].Intrax_Id__c;
        update user;
        
        //Check for list Size
        if(profiles.size() > 0) {
            //Run in user context
            System.runAs(user) {
                Test.startTest();
                Test.setCurrentPage(Page.pr_app_list);
                //Searching for Participant
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                controller.hostCompany = partnerAccount;
                controller.IntraxProgramSelected = 'Ayusa';
                controller.SNCIndicatedSelected = 'No';
                controller.EngagementStatusSelected = 'On Program';
                
                controller.checkLoginWithMatchSearch();
                controller.doSearchOnTheBasisOfPageSizeForMatch();
                
                Test.stopTest();
            }                  
        }    
    }
    
    
    static testMethod void myUnitTest6() {
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        //Fetch intract Id for this account id
        //Account hostAccount = [Select Id, Intrax_Id__c from Account where Id =: account.Id LIMIT 1];
        //System.debug('@@@@@@ value in hostAccount ' + hostAccount);
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        //Account
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com');
        insert participantAccount;
        
        //Contact
        Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'Work Travel');
        insert contact;
        
        //Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = participantAccount.Id, Program_Year__c = '2013',
                                                    Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started');
        insert opportunity;
        
        //Record Type
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, engagementRecordType != null);
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test11 Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes',Placement_Status__c='Confirmed');
        insert engagement;
        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, partnerApplicationRecordType != null);
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Check for list Size
        if(profiles.size() > 0) {
            /*
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c = partnerAccount.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
            
            insert user;
            */
            User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                List<User> users = [select Id, Intrax_Id__c from User where Id = : userInfo.getUserId()]; 
                System.debug('######### value in user Id ' + users);
                 
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = users[0].Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Intrax_Program_Options__c = 'YES');
                insert appInfo;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                //Attachment
                Attachment attach=new Attachment();     
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId= appInfo.id;
                attach.Description = 'Test';
                insert attach;
                
                //Assert for Result
                List<Attachment> attachments =[select id, name from Attachment where parent.id=: appInfo.id];
                System.assertEquals(1, attachments.size());
                
                //Update Applicant Info for Photo Id field
                appInfo.PhotoId__c = attach.Id;
                update appInfo;
                
                //Position
                Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia',Tipped_Position__c='No');
                insert position;
                
                //School
                School__c school = new School__c(Name = 'Test School', Applicant_Info__c = appInfo.Id);
                insert school;
                
                //Match
                Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned', 
                                                Engagement__c = engagement.Id, 
                                                Portal_Contact_ID__c = contact.Id,
                                                Interview_Status__c = 'Scheduled');
                insert match;
                
                //Trip
                Trip__c trip = new Trip__c(Match__c = match.Id, Engagement__c = engagement.Id);
                insert trip;
                
                //Assessment
                Assessment__c assessment = new Assessment__c(Name = 'Test Assessment', Engagement__c = engagement.Id,
                                                             Match_Name__c = match.Id, Resident_Participants__c = '2', Resident_Total__c = '2');
                insert assessment;
                
                //Start test from here
                Test.startTest();
                
                //Calling constructor
                Test.setCurrentPage(Page.pr_app_list);
                //Setting value of the parameter
                ApexPages.currentPage().getParameters().put('isAssessments', 'true');
                ApexPages.currentPage().getParameters().put('isNeedsTravel', 'true');
                ApexPages.currentPage().getParameters().put('docGuid', 'Test');
                ApexPages.currentPage().getParameters().put('AssessmentId', assessment.Id);
                
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                
                // Auxiliary Functions
                controller.getIncompleteMissingDocs();
                controller.getSelectedPicklistValues(participantAccount.Intrax_Programs__c);
                
                controller.getAppDocList();
                controller.match = match;
                controller.updateMatch();
                
                try{
                    controller.load();
                    controller.deletefile();
                }catch(Exception e){}
                try{
                    controller.deletefile();
                }catch(Exception e){}
                
               
                
               
                
                //Setting Parameters
                ApexPages.currentPage().getParameters().put('mOrigin', 'pos');
                Apexpages.currentPage().getParameters().put('matchId', match.Id);
                Apexpages.currentPage().getParameters().put('tripId', trip.Id);
                Apexpages.currentPage().getParameters().put('pID', position.Id);
                
                IntraxPartnerPortalEngineController controller2 = new IntraxPartnerPortalEngineController();
                
                //Setting Parameters
                Apexpages.currentPage().getParameters().put('Id', appInfo.Id);
                IntraxPartnerPortalEngineController controller3 = new IntraxPartnerPortalEngineController();
                
                
                
                //Setting Parameters
                Apexpages.currentPage().getParameters().put('isPhotoAvaialable', 'true');
                IntraxPartnerPortalEngineController controller4 = new IntraxPartnerPortalEngineController();
                
                //Variable to hold the sObject Instance
                sObject sObj;
                
                //List of Applicant_Info__c records
                List<Applicant_Info__c> applicationInfoList = new List<Applicant_Info__c>(); 
                
                //Populating list with applicant Info record clones
                
             /*   sObj = (sObject)appInfo.clone(false);
                applicationInfoList.add((Applicant_Info__c)sObj);
                
                sObj = (sObject)appInfo.clone(false);
                applicationInfoList.add((Applicant_Info__c)sObj);
                
                sObj = (sObject)appInfo.clone(false);
                applicationInfoList.add((Applicant_Info__c)sObj);
                
                sObj = (sObject)appInfo.clone(false);
                applicationInfoList.add((Applicant_Info__c)sObj);
                
                sObj = (sObject)appInfo.clone(false);
                applicationInfoList.add((Applicant_Info__c)sObj);
                
                System.assertEquals(5, applicationInfoList.size());
                System.debug('@@@@@@@ value in applicationInfoList ' + applicationInfoList);
                
                insert applicationInfoList;*/
                
                //List of Match records
                List<Match__c> matchList = new List<Match__c>();
                
                //Populating list with Match record clones
                
                sObj = (sObject)match.clone(false);
                matchList.add((Match__c)sObj);
                
                /*sObj = (sObject)match.clone(false);
                matchList.add((Match__c)sObj);
                
                sObj = (sObject)match.clone(false);
                matchList.add((Match__c)sObj);
                
                sObj = (sObject)match.clone(false);
                matchList.add((Match__c)sObj);
                
                sObj = (sObject)match.clone(false);
                matchList.add((Match__c)sObj);*/
                
                System.assertEquals(1, matchList.size());
                
                insert matchList;
                
                //List of Engagement records
                List<Engagement__c> engagementList = new List<Engagement__c>();
                
                //Populating list with Match record clones
                
                sObj = (sObject)engagement.clone(false);
                engagementList.add((Engagement__c)sObj);
                
                /*sObj = (sObject)engagement.clone(false);
                engagementList.add((Engagement__c)sObj);
                
                sObj = (sObject)engagement.clone(false);
                engagementList.add((Engagement__c)sObj);
                
                sObj = (sObject)engagement.clone(false);
                engagementList.add((Engagement__c)sObj);
                
                sObj = (sObject)engagement.clone(false);
                engagementList.add((Engagement__c)sObj);*/
                
                System.assertEquals(1, engagementList.size());
                
                insert engagementList;
                
                //List of Match records
                List<Assessment__c> assessmentList = new List<Assessment__c>();
                
                //Populating list with Match record clones
                
                sObj = (sObject)assessment.clone(false);
                assessmentList.add((Assessment__c)sObj);
                
                /*sObj = (sObject)assessment.clone(false);
                assessmentList.add((Assessment__c)sObj);
                
                sObj = (sObject)assessment.clone(false);
                assessmentList.add((Assessment__c)sObj);
                
                sObj = (sObject)assessment.clone(false);
                assessmentList.add((Assessment__c)sObj);
                
                sObj = (sObject)assessment.clone(false);
                assessmentList.add((Assessment__c)sObj);*/
                
                //System.assertEquals(5, matchList.size());
                
                insert assessmentList;
                 
                //Stop Test here
                Test.stopTest();
            }                  
        }    
    }
    
    static testMethod void myUnitTest7() {
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        //Fetch intract Id for this account id
        //Account hostAccount = [Select Id, Intrax_Id__c from Account where Id =: account.Id LIMIT 1];
        //System.debug('@@@@@@ value in hostAccount ' + hostAccount);
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        Contact contactPartner = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com');
        insert contactPartner;
        
        //Account
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com');
        insert participantAccount;
        
        //Contact
        Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_intrax_program_default__c='Ayusa');
        insert contact;
        
        //Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = participantAccount.Id, Program_Year__c = '2013',
                                                    Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started');
        insert opportunity;
        
        //Record Type
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, engagementRecordType != null);
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test11 Engagement', Account_Id__c = account.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Partner_Id__c = partnerAccount.Intrax_Id__c, Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes',Placement_Status__c='Not Placed');
        insert engagement;
        
        //Record Type
        RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, partnerApplicationRecordType != null);
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Taiwan Mgr' limit 1];
        
        //Check for list Size
        if(profiles.size() > 0) {
            
            User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
            System.runAs(sysAdmin) {
                
                List<User> users = [select Id, Intrax_Id__c from User where Id = : userInfo.getUserId()]; 
                System.debug('######### value in user Id ' + users);
                 
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = users[0].Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Intrax_Program_Options__c = 'YES', PageStatus_Complete__c = '041');
                insert appInfo;
                
                //Applicant Info
                Applicant_Info__c appInfo2 = new Applicant_Info__c(Name = 'test-AYa', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = users[0].Intrax_Id__c, Home_Responsibilities__c = 'Test',
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
                                                                  Intrax_Program_Options__c = 'YES', PageStatus_Complete__c = '041');
                insert appInfo2;
                
                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                
                //Position
                Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia',Tipped_Position__c='No');
                insert position;
                
                //Match
                Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned', 
                                                Engagement__c = engagement.Id, 
                                                Portal_Contact_ID__c = contact.Id,
                                                Interview_Status__c = 'Scheduled');
                insert match;
                
                //Assessment
                Assessment__c assessment = new Assessment__c(Name = 'Test Assessment', Engagement__c = engagement.Id,
                                                             Match_Name__c = match.Id, Resident_Participants__c = '2', Resident_Total__c = '2');
                insert assessment;
                
                //Start test from here
                Test.startTest();
                
                //Calling constructor
                Test.setCurrentPage(Page.pr_pt_list);
                
                //Setting value of the parameter
                
                ApexPages.currentPage().getParameters().put('awaitingEngs', 'yes');
                ApexPages.currentPage().getParameters().put('actInterEngs', 'yes');
                ApexPages.currentPage().getParameters().put('inCountryEngs', 'yes');
                ApexPages.currentPage().getParameters().put('interFeedEngs', 'yes');
                ApexPages.currentPage().getParameters().put('newMatchesEngs', 'yes');
                ApexPages.currentPage().getParameters().put('extensionEngs', 'yes');
                ApexPages.currentPage().getParameters().put('preArrivalEngs', 'yes');
                ApexPages.currentPage().getParameters().put('ProgramUSAEngs', 'yes');
                
                IntraxPartnerPortalEngineController controller = new IntraxPartnerPortalEngineController();
                
                //Searching for Participant
                controller.doSearchForParticipant();
                //Searching for Assessments
                
                controller.activeInterEngsParam = 'yes';
                controller.doSearchForParticipant();
                controller.inCountryEngsParam = 'yes';
                controller.doSearchForParticipant();
                controller.interviewFeedbackEngsParam = 'yes';
                controller.doSearchForParticipant();
                controller.newMatchesEngsParam = 'yes';
                controller.doSearchForParticipant();
                controller.extensionEngsParam = 'yes';
                controller.doSearchForParticipant();
                controller.preArrivalEngsParam = 'yes';
                controller.doSearchForParticipant();
                controller.ProgramUSAEngsParam = 'yes';
                controller.engName = 'Test';
                controller.programDurationSelected = '3';
                controller.ProgramYearSelected = '2014';
                controller.ProgramSeasonSelected = 'Winter';
                controller.IntraxRegionSelected = 'USA';
                controller.ProgramSvLvlSelected = 'Intrax';
                controller.IntraxProgramSelected = 'Ayusa';
                controller.doSearchForParticipant();
                                               
                controller.itotalPageNumber = 90;
                
                
                controller.viewSelected = 'Interviews to Start';
                controller.doActionForViewListEng();
                controller.viewSelected = 'Awaiting Placement';
                controller.doActionForViewListEng();
                controller.viewSelected = 'Active Interviews';
                controller.doActionForViewListEng();
                controller.viewSelected = 'In-Country';
                controller.doActionForViewListEng();
                controller.viewSelected = 'Interview Feedback';
                controller.doActionForViewListEng();
                controller.viewSelected = 'New Matches (last 30 days)';
                controller.doActionForViewListEng();
                controller.viewSelected = 'Extensions';
                controller.doActionForViewListEng();
                controller.viewSelected = 'Pre-Arrival';
                controller.doActionForViewListEng();
                controller.viewSelected = 'On Program (In USA)';
                controller.doActionForViewListEng();
                set<Id> testeng1 = controller.retrieveEngagementList('activeInterEngsParam');
                set<Id> testeng2 = controller.retrieveEngagementList('interviewFeedbackEngsParam');
                set<Id> testeng3 = controller.retrieveEngagementList('newMatchesEngsParam');
                set<Id> testeng4 = controller.retrieveEngagementList('extensionEngsParam');
                
                controller.viewSelected = 'Start';
                controller.doActionForViewList();
                controller.viewSelected = 'Interviews to Complete';
                controller.doActionForViewList();
                controller.viewSelected = 'Interviews to Start';
                controller.doActionForViewList();
                controller.viewSelected = 'Health Forms to Review';
                controller.doActionForViewList();
                controller.viewSelected = 'BG Checks to Review';
                controller.doActionForViewList();
                controller.viewSelected = 'School Details to Verify';
                controller.doActionForViewList();
                
                list<Selection__c> testselect = controller.selectedInterviews;
                pageReference ptest =  controller.openTIPPPDFForm();
                
                //Stop Test here
                Test.stopTest();
            }                  
        }    
    }
}