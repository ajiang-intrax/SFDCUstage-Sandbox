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
@isTest
private class Test_Batch_Notifications_APC {

   @testSetup
    static void dataSetup1() { 
      
        // TO DO: implement unit test
        //Record Type
         RecordType rtMatch = [select id,Name from RecordType where SobjectType='Match__c' and Name='AuPairCare' Limit 1];
         RecordType rtEng = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
         RecordType rtOpp = [select id,Name from RecordType where SobjectType='Opportunity' and Name='AuPairCare PT' Limit 1];
         RecordType rtPosHF = [select id,Name from RecordType where SobjectType='POsition__c' and Name='AuPairCare HF' Limit 1];
         
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
         RecordType rtPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
         
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
        
        Engagement__c eng = new Engagement__c(Name = 'Test Eng',RecordTypeId= rtEng.Id, Type__c = 'Participant', In_Country__c='No' , Account_Id__c = account.Id, status__c = 'On Program', Intrax_Program__c = 'AuPairCare');
        insert eng;

        Date triggerDate = System.today()+180;
        Match__c match = new Match__c(Name='testMatch', Status__c = 'Confirmed', Participant_Id__c = account.Id, RecordTypeId = rtMatch.Id, Engagement__c = eng.Id,Participant_Opportunity_Id__c=opp.Id, Position_Name__c=pos.Id,Match_Date__c=System.today()+10, Start_Date__c=System.today()-10, End_Date__c = triggerDate);
        insert match;

        System.debug('match id---->'+match.Id);

        //JOSE B-02918
        list<Match__c> mlist = new list<Match__c>();

        Date triggerDate1 = System.today()-1;
        
        Match__c match1 = new Match__c(Name='testMatch', Participant_Id__c = account.Id, RecordTypeId = rtMatch.Id, 
                        Engagement__c = eng.Id,Participant_Opportunity_Id__c=opp.Id, Position_Name__c=pos.Id,Match_Date__c=System.today()+10,
                        Offer_Accepted_Date__c = triggerDate1, Status__c='Requested', Offer_Status__c='Accepted', Request_Expiration__c = System.today()-2,
                        Start_Date__c=System.today()-14, End_Date__c = triggerDate1);
        mlist.add(match1);

        insert mlist; 
         
        
   }

    static testMethod void myUnitTest() { 
        
        dataSetup1();

        test.startTest();
        
        Batch_Notifications_APC batch = new Batch_Notifications_APC();
        Database.executeBatch(batch,5);
       
        test.stopTest();
        
    }

    static testMethod void myUnitTest1() {
        
        dataSetup1(); 

        test.startTest();
        
        Batch_Notifications_APC_MatchAcc24Hrs batch1 = new Batch_Notifications_APC_MatchAcc24Hrs();
        Database.executeBatch(batch1,5);

        //Batch_MatchExpire batch3= new Batch_MatchExpire();
        //Database.executeBatch(batch3,5);
       
        test.stopTest();
        
    }

    static testMethod void myUnitTest2() {
        
        // TO DO: implement unit test
        //Record Type
         RecordType rtMatch = [select id,Name from RecordType where SobjectType='Match__c' and Name='AuPairCare' Limit 1];
         RecordType rtEng = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
         RecordType rtOpp = [select id,Name from RecordType where SobjectType='Opportunity' and Name='AuPairCare PT' Limit 1];
         RecordType rtPosHF = [select id,Name from RecordType where SobjectType='POsition__c' and Name='AuPairCare HF' Limit 1];
         
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
         RecordType rtPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
         
        //Account
        Account account  = new Account(LastName = 'Test', RecordTypeId = rt.Id, Type = 'Participant', Intrax_Programs__c='AuPairCare', PersonEmail='test@test123.com');
        insert account;
        
        //Account
        Account hostaccount  = new Account(LastName = 'Test', RecordTypeId = rtPT.Id, Type = 'Host Family', PersonEmail='hosttest@test123.com');
        insert hostaccount;
        
        Position__c pos = new Position__c(Name='Test Position',RecordTypeId=rtPosHF.Id,Type__c='Host Family', Host_Company_Id__c=hostaccount.Id,Intrax_Program__c='AuPairCare' );
        insert pos;
        
        Engagement__c eng = new Engagement__c(Name = 'Test Eng',RecordTypeId= rtEng.Id, Type__c = 'Participant', In_Country__c='No' , Account_Id__c = account.Id, status__c = 'On Program', Intrax_Program__c = 'AuPairCare', Engagement_End__c = System.today() + 90);
        insert eng;

        Engagement__c eng2 = new Engagement__c(Name = 'Test Eng2',RecordTypeId= rtEng.Id, Type__c = 'Participant', In_Country__c='Yes' , Account_Id__c = account.Id, status__c = 'On Program', Intrax_Program__c = 'AuPairCare', Engagement_End__c = System.today() + 90);
        insert eng2;

        Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test', Special_Diet_Indicated__c = 'No', Engagement__c = eng.Id,
                                                                  Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2015', Application_Stage__c='Working',
                                                                  Application_Level__c ='Main', CreatedDate=System.today()-1,
                                                                  Intrax_Program__c='AuPairCare', Type__c='Participant', Application_Type__c='Original');
        insert appInfoPT;


        Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test', Special_Diet_Indicated__c = 'No', Engagement__c = eng.Id,
                                                                  Engagement_Start__c = (System.today() - 10), Program_Duration__c = '1-3 Weeks',
                                                                  Program_Year__c  = '2015', Application_Stage__c='Working',
                                                                  Application_Level__c ='Main', CreatedDate=System.today()-1,
                                                                  Intrax_Program__c='AuPairCare', Type__c='Host Family', Application_Type__c='Original');
        insert appInfoHF;
        
        
        Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c(Name = 'test', Engagement__c = eng.Id ,Document_Type__c = 'Proof-of-Education', Review_Status__c ='Accepted');
        insert ipu;
        
        //JOSE B-02918
        list<Match__c> mlist = new list<Match__c>();

        Date triggerDate1 = System.today()-1;
        
        Date triggerDate2 = System.today()-14; 
        
        Match__c match2 = new Match__c(Name='testMatch', Participant_Id__c = account.Id, RecordTypeId = rtMatch.Id, Match_Date__c = System.today()-3, 
                        Engagement__c = eng.Id,Position_Name__c=pos.Id, 
                        Offer_Accepted_Date__c = triggerDate1, Status__c='Confirmed', Offer_Status__c='Accepted', Airport_Code__c = null,
                        Start_Date__c=triggerDate2, End_Date__c = System.today() + 90);
        mlist.add(match2);
        
        
        insert mlist;  

        test.startTest();
        Batch_Notifications_APC_MatchPreDeplist batch5 = new Batch_Notifications_APC_MatchPreDeplist();
        Database.executeBatch(batch5,5);

        Batch_Notifications_APC_MatchChecklist batch2= new Batch_Notifications_APC_MatchChecklist();
        Database.executeBatch(batch2,5);
        
        Batch_Notifications_APC_MatchAcademy batch1 = new Batch_Notifications_APC_MatchAcademy();
        Database.executeBatch(batch1,5);

        Batch_Notifications_APC_EngPlanForDep batch4 = new Batch_Notifications_APC_EngPlanForDep();
        Database.executeBatch(batch4,5);

        Batch_Notifications_APC_PTAppCreated batch6 = new Batch_Notifications_APC_PTAppCreated();
        Database.executeBatch(batch6,5);

        Batch_Notifications_APC_HFAppCreated batch8 = new Batch_Notifications_APC_HFAppCreated();
        Database.executeBatch(batch8,5);

        Batch_Notifications_APC_EngProofEdu batch7 = new Batch_Notifications_APC_EngProofEdu();
        Database.executeBatch(batch7,5);


        test.stopTest();
        
    }

    static testMethod void myUnitTest3() { 
        
        // TO DO: implement unit test
        //Record Type
         RecordType rtMatch = [select id,Name from RecordType where SobjectType='Match__c' and Name='AuPairCare' Limit 1];
         RecordType rtEng = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
         RecordType rtOpp = [select id,Name from RecordType where SobjectType='Opportunity' and Name='AuPairCare PT' Limit 1];
         RecordType rtPosHF = [select id,Name from RecordType where SobjectType='POsition__c' and Name='AuPairCare HF' Limit 1];
         
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
         RecordType rtPT = [select id,Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
         
        //Account
        Account account  = new Account(LastName = 'Test', RecordTypeId = rt.Id, Type = 'Participant', Intrax_Programs__c='AuPairCare', PersonEmail='test@test123.com');
        insert account;
        
        //Account
        Account hostaccount  = new Account(LastName = 'Test', RecordTypeId = rtPT.Id, Type = 'Host Family', PersonEmail='hosttest@test123.com');
        insert hostaccount;
        
        Position__c pos = new Position__c(Name='Test Position',RecordTypeId=rtPosHF.Id,Type__c='Host Family', Host_Company_Id__c=hostaccount.Id,Intrax_Program__c='AuPairCare' );
        insert pos;
        
        Engagement__c eng = new Engagement__c(Name = 'Test Eng',RecordTypeId= rtEng.Id, Type__c = 'Participant', In_Country__c='No' , Account_Id__c = account.Id, status__c = 'On Program', Intrax_Program__c = 'AuPairCare', Engagement_End__c = System.today() + 90);
        insert eng;
        
        test.startTest();
        
        Batch_Notifications_APC_EngProofEdu batch = new Batch_Notifications_APC_EngProofEdu();
        Database.executeBatch(batch,5);
       
        test.stopTest();
        
    }

}