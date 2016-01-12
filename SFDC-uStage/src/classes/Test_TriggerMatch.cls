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
private class Test_TriggerMatch {

 /*   Purpose         :   Test class for Trigger_Match.
                
    Created Date    :   03/20/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
static testMethod void testUpdateOpportunityOperationStageByMatchStatus() {
        System.debug('***Test Trigger Match***');
         
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ]; 
        List<RecordType> AyusaPt = [Select Id from RecordType where DeveloperName = 'Ayusa_PT' AND IsPersonType = false AND SObjectType = 'Opportunity' AND IsActive = true ];
          Test.startTest();    
        //check for the record type size 
        if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
            insert hostOpportunity;
            
            //Insert Position Instance
            Position__c position1 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3,Country__c='Australia' );
            
            insert position1;
            
            //Insert Position Instance
            Position__c position2 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3,Country__c='Australia' );
            
            insert position2;
            
            //Create test data
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 2; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType[0].Id, PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            
            //Create list of opportunities
            List<Opportunity> listOpportunity = new List<Opportunity>();
            integer i=0;
            //insert in list
            for(Account acc : listAccount) {
                i++;
                listOpportunity.add(new Opportunity(Name = 'Test'+i, AccountId = acc.Id, CloseDate = Date.Today(), Project_Name__c = 'test',
                                                    App_Fee_Paid__c = true, Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', 
                                                    Engagement_Start__c = Date.today(), StageName = 'Prospecting',Operation_Stage__c='Match Ready'));
            }
            
            insert listOpportunity;
            
            //Create matched records with Interview Pending Status
            List<Match__c> matchesForPosition1 = new List<Match__c>();
            List<Match__c> matchesForPosition2 = new List<Match__c>();
            
            Map<Id,Match__c> mapOppIdMatch = new Map<Id,Match__c>();
            
            //Engagement
            Engagement__c engagement1 = new Engagement__c(Name='Test Engagement', 
                                                         Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', 
                                                         Status__c = 'Prospecting');
            insert engagement1;
            
            //Engagement
            Engagement__c engagement2 = new Engagement__c(Name='Test Engagement', 
                                                         Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', 
                                                         Status__c = 'Prospecting');
            insert engagement2;
            
            //loop through the opportunity and add records in the list
            for(Opportunity opp : listOpportunity){
                //matchesForPosition1.add(new Match__c(Name = 'TestMatchA',Engagement__c=engagement1.id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Applied', Interview_Date__c = Date.today() + 1 ));
                //matchesForPosition2.add(new Match__c(Name = 'TestMatchB',Engagement__c=engagement2.id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position2.Id, Status__c = 'Applied'));
            	//mapOppIdMatch.put(opp.Id, new Match__c(Name = 'TestMatchA',Engagement__c=engagement1.id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Applied', Interview_Date__c = Date.today() + 1 ));
            }
            
            Match__c m = new Match__c(Name = 'TestMatchA',Engagement__c=engagement1.id, Participant_Id__c = ListOpportunity[0].AccountId, Participant_Opportunity_Id__c = ListOpportunity[0].Id, Position_Name__c = position1.Id, Status__c = 'Applied', Interview_Date__c = Date.today() + 1 );
            mapOppIdMatch.put(ListOpportunity[0].Id,m);
            //insert matches data'
            //insert matchesForPosition1;
            insert mapOppIdMatch.values();
            //insert matchesForPosition2;

            
            //loop for the matchesForPosition1 and update status with Matched
            for(Match__c match : mapOppIdMatch.values()) {
                match.Status__c = Constants.MATCH_STATUS_MATCHED;
            }
            update mapOppIdMatch.values();
            
            for(Match__c match : mapOppIdMatch.values()) {
                match.Status__c = Constants.MATCH_STATUS_INTERVIEW_PENDING;
                match.Interview_Date__c = Date.today().adddays(2);
            }
            
            //update matchesForPosition1
           
            //loop for the matchesForPosition2 and update status with Matched
           
            /*
            for(Match__c match : matchesForPosition2) {
                match.Status__c = Constants.MATCH_STATUS_MATCHED;
            }*/
            
            update mapOppIdMatch.values();
            //update matchesForPosition2;
            
             Test.stopTest();
        }
    }
    
     static testMethod void myUnitTest1(){  
      List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
      List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ]; 
      List<RecordType> AyusaPt = [Select Id from RecordType where DeveloperName = 'Ayusa_PT' AND IsPersonType = false AND SObjectType = 'Opportunity' AND IsActive = true ];
          
       Test.startTest();    
        if (AyusaPt.size()>0)
        {
        system.debug('@@inside ayusa@@');
          Account hostComp = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
          insert hostComp;
            
          Opportunity hostOpp = new Opportunity(Name = 'Host - Opp', AccountId = hostComp.Id, CloseDate = Date.Today(),
                                                            Intrax_Programs__c = 'Ayusa', StageName = 'Prospecting',Intrax_Program_Options__c = 'High School Worldwide', Engagement_Start__c = Date.today());
          insert hostOpp;
            
          Position__c pos1 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostComp.Id, Host_Opportunity_Id__c = hostOpp.Id, 
                                                    Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', Engagement_Start__c = Date.today() + 3,Country__c='Australia' );
          insert pos1;
          
          Position__c pos2 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostComp.Id, Host_Opportunity_Id__c = hostOpp.Id, 
                                                    Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', Engagement_Start__c = Date.today() + 3,Country__c='Australia' );
            
          insert pos2;
          
          
          //Create test data
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 2; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType[0].Id, PersonEmail = 'test1'+i+'@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            
            //Create list of opportunities
            List<Opportunity> listOpportunity = new List<Opportunity>();
            integer i=0;
            //insert in list
            for(Account acc : listAccount) {
                i++;
                listOpportunity.add(new Opportunity(Name = 'Test'+i, AccountId = acc.Id, CloseDate = Date.Today(), Project_Name__c = 'test',
                                                    App_Fee_Paid__c = true, Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Ayusa', 
                                                    Engagement_Start__c = Date.today(), StageName = 'Prospecting',Operation_Stage__c='Match Ready'));
            }
            
            insert listOpportunity;
            
            //Create matched records with Interview Pending Status
            List<Match__c> matchForPos1 = new List<Match__c>();
            List<Match__c> matchForPos2 = new List<Match__c>();
            
            Map<Id,Match__c> mapOppIdMatch = new Map<Id,Match__c>();
            
            //Engagement
            Engagement__c engagement = new Engagement__c(Name='Test Engagement', 
                                                         Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                         Type__c = 'Participant', 
                                                         Status__c = 'Prospecting');
            insert engagement;
            
            
            //loop through the opportunity and add records in the list
            for(Opportunity opp : listOpportunity){
                //matchForPos1.add(new Match__c(Name = 'TestMatchA', Engagement__c=engagement.id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = pos1.Id, Status__c = 'Applied', Interview_Date__c = Date.today() + 1 ));
                //matchForPos2.add(new Match__c(Name = 'TestMatchB', Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = pos2.Id, Status__c = 'Applied'));
                //mapOppIdMatch.put(opp.Id, new Match__c(Name = 'TestMatchA', Engagement__c=engagement.id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = pos1.Id, Status__c = 'Applied', Interview_Date__c = Date.today() + 1 ));
            }
            
            Match__c m = new Match__c(Name = 'TestMatchA', Engagement__c=engagement.id, Participant_Id__c = ListOpportunity[0].AccountId, Participant_Opportunity_Id__c = ListOpportunity[0].Id, Position_Name__c = pos1.Id, Status__c = 'Applied', Interview_Date__c = Date.today() + 1 );
            mapOppIdMatch.put(ListOpportunity[0].Id, m);
            //insert matches data'
            //insert matchForPos1;
            insert mapOppIdMatch.values();
            
            //insert matchForPos2;
          for(Match__c match : mapOppIdMatch.values()) {
                match.Status__c = 'Confirmed';
            }
                     update mapOppIdMatch.values();
              
         }
          Test.stopTest();
        }
           
    
    
       static testMethod void myUnitTest() {
       
         Test.startTest();         
           
         //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', //Account_Id__c = account.Id, 
        //RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', 
                                                     //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                     Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
                
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        Opportunity opp = new Opportunity(Name = 'Host - Opp', AccountId = account.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', Engagement_Start__c = Date.today());
            insert opp;
            
        Engagement__c engagement1 = new Engagement__c(Name='Test Engagement',Account_Id__c = account.Id, 
        //RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant',Placement_Status__c = 'Not Placed',Opportunity_Id__c=opp.Id,
                                                     //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                     Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement1;
             
            
        
        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10), Country__c='Australia',
                                                Host_Company_Id__c = account.Id, Status__c='Matching'
                                                );
        insert position;
         List<RecordType> partnerAdminRecordType = [Select Id from RecordType where DeveloperName = 'Partner_Admin' AND SObjectType = 'Account' AND IsActive = true ];
          Account partnerAdmin = new Account(Name = 'Test - Partner', RecordTypeId = partnerAdminRecordType[0].Id);
            insert partnerAdmin;
          Campaign testCamp1= new Campaign(Name='TestCamp1',Partner_Name__c=partnerAdmin.Id);
            insert testCamp1;          
            Account hostCompany1 = new Account(Name = 'Host1 - Company',type='Host Company', RecordTypeId = hostCompanyRecordType.Id);
           insert hostCompany1;      
        
         Campaign_Session__c testCampSession= new  Campaign_Session__c(Campaign__c=testCamp1.Id,Host_Company_Name__c=account.Id);
            insert testCampSession;
            
           Campaign_Session__c testCampSession1= new  Campaign_Session__c(Campaign__c=testCamp1.Id,Host_Company_Name__c=hostCompany1.Id);
            insert testCampSession1;   
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id,Campaign_Session__c = testCampSession.Id                                      
                                        );
        insert match;
        
        match.Campaign_Session__c = testCampSession1.Id;
        update match;
         
        match.Campaign_Session__c = null;
        update match; 
        engagement1.Placement_Status__c = 'Pending';
        update engagement1;
         Test.stopTest();
    }
}