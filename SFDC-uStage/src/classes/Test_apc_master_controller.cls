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
@isTest(seeAllData=True)
private class Test_apc_master_controller {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        //Record Type
         RecordType rtMatch = [select id,Name from RecordType where SobjectType='Match__c' and Name='AuPairCare' Limit 1];
         RecordType rtEng = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
         RecordType rtOpp = [select id,Name from RecordType where SobjectType='Opportunity' and Name='AuPairCare PT' Limit 1];
         RecordType rtPosHF = [select id,Name from RecordType where SobjectType='POsition__c' and Name='AuPairCare HF' Limit 1];
         RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
         RecordType rtPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];        
         RecordType partnerrt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1]; 
         
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Account
        Account partneraccount  = new Account(Name = 'Test', RecordTypeId = partnerrt.Id, Type = 'Partner');
        insert partneraccount;
                
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = partneraccount.Id, Email = 'test@test.com');
        insert contact;
        //portal user
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
        insert user; 
        
                
        
        
        //Account
        Account account  = new Account(LastName = 'Test', RecordTypeId = rt.Id, Type = 'Participant', Intrax_Programs__c='AuPairCare', PersonEmail='test@test123.com');
        insert account;
        
        //Account
        Account hostaccount  = new Account(LastName = 'Test', RecordTypeId = rtPT.Id, Type = 'Host Family', PersonEmail='hosttest@test123.com');
        insert hostaccount;
        
        Position__c pos = new Position__c(Name='Test Position',RecordTypeId=rtPosHF.Id,Type__c='Host Family', Host_Company_Id__c=hostaccount.Id,Intrax_Program__c='AuPairCare' );
        insert pos;
        
        Opportunity opp = new Opportunity(Name = 'Test Opp', RecordTypeId = rtOpp.Id, AccountId=account.Id, Intrax_Region__c = 'United States', Intrax_Programs__c='AuPairCare', CloseDate= System.Today()+10, StageName='Processing');
        insert opp;
        
        
        Engagement__c eng = new Engagement__c(Name = 'Test Eng',RecordTypeId= rtEng.Id, Type__c = 'Participant', Account_Id__c = account.Id, status__c = 'On Program', Intrax_Program__c = 'AuPairCare');
        insert eng;
        
        
            
        Date triggerDate = System.today()+180;
        Match__c match = new Match__c(Name='testMatch', Status__c = 'Confirmed', Participant_Id__c = account.Id, RecordTypeId = rtMatch.Id, Engagement__c = eng.Id,Participant_Opportunity_Id__c=opp.Id, Position_Name__c=pos.Id,Match_Date__c=System.today()+10, Start_Date__c=System.today()-10, End_Date__c = triggerDate);
        insert match;        
        List<Match__c> matchList = new List<Match__c>();
        matchList.add(match);
        
               
        
        
        //System.runAs(user){
        //AA Applicant Info APCPT
                Applicant_Info__c appInfoAPCPT = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',Allow_Intrax_To_Apply__c=True,
                                                                  Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPCPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Language_3__c='English',Language_2__c='',Language_1__c='',
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
                                                                  Engagement_Start__c = System.today()-2, Accommodation_Preference__c = 'Homestay',Application_Level__c='Main',Application_Stage__c = 'Accepted',Intrax_Program__c='AuPairCare',Application_Type__c='Orignal',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = UserInfo.getUserId());
                insert appInfoAPCPT;
        
        
        Experience__c ex = new Experience__c(Name='test',Engagement__c=eng.Id, IsExperienced__c = true,Applicant_Info__c=appInfoAPCPT.Id,Start_Date__c=System.today(),End_Date__c=(System.today()+365));
        insert ex;
        
        Experience_detail__c expDet = new Experience_Detail__c(Name='test',Date_of_Birth__c=System.today()-1000,Experience_Name__c=ex.Id,Special_Needs_Indicated__c='Yes');
        insert expDet;
        
        Reference__c ref = new Reference__c(Name='test', Experience_Name__c = ex.Id,Engagement__c =eng.Id,Reference_Status__c = 'Active',Reference_Requested__c = true,Status__c ='Confirmed') ;
        insert ref;
        
        List<Applicant_Info__c> appList = new List<Applicant_Info__c>();
        appList.add(appInfoAPCPT);
        
        
        Test.startTest();
        pagereference pageref = Page.apc_hf_match_request;//apc_ap_interviews;//apc_ap_travel_payment_confirmation; 
        system.Test.setcurrentPage(pageref);
        
        apc_home_controller apcHome = new apc_home_controller();               
        apcHome.myHome = new home_controller();
        apcHome.myHomeMatch = new apc_match_controller();
        //apcHome.mySearch = new search_controller();
            
        apc_portal_controller PC = new apc_portal_controller();
        PC.pc = new Pricing_Controller();
        PC.ConfMatchList = matchList;
        PC.ConfMatch = match;
        PC.checkradio();
        PC.getairportcode1();
        PC.getairportcode();
        PC.getairportscode();
        PC.selected = 'SFO-';
        PC.radio = 'SFO-';
        PC.chkBx = true;
        //PC.getOpportunityProductCart();
        PC.navigator();
        PC.populateSelectedItems();
        PC.populateSelectedCartList();
        //PC.viewtransfercost();
        PC.click();
        PC.inCountrySkipPage();
        PC.sendEmailToExpert();
        
        
        
        //apc_profile_controller paramcontroller = new apc_profile_controller('Engagement__c');
                
        apc_profile_controller controller = new apc_profile_controller();        
        ApexPages.currentPage().getParameters().put('Id', eng.Id);
        controller.participant = eng;
        controller.applicant = appInfoAPCPT;
        List<experience__c> listEx = new List<Experience__c>();
        listEx.add(ex);
        controller.listExperience = listEx;                
        controller.getlistChildCareRef();
        controller.getlistPersonalRef();
        controller.getmapLang();
        controller.getParticipantPhotoList();
        controller.retrieveVideo();
        //controller.loadPic();
        controller.appList = appList;
        controller.isFavoriteId = new Map<String,Boolean>();
        controller.isDismissedId = new Map<String,Boolean>();
        controller.ChildrenAges = 'test';
        controller.ChildrenTypes = 'test';
        controller.returnURL = 'test';
        controller.disRecords = new set<String>();
        controller.phyDocList = new List<Intrax_Program_Upload__c>();
        controller.LifeGuardDocList = new List<Intrax_Program_Upload__c>();
        controller.primary = new Person_Info__c();        
        controller.siblingList = new List<Person_Info__c>();        
        controller.discInfo = new DISC__c();
        controller.discInfoList = new List<DISC__c>();
        controller.HLightList = new List<String>();
        Test.stopTest();
        
       // }
    }
}