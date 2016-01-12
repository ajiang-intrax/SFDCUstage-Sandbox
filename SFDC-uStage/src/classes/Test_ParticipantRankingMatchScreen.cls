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
public with sharing class Test_ParticipantRankingMatchScreen {
/*
    Purpose         :   Test class for RankingtchController.
               
    Created Date    :   06/06/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void myUnitTest() {
        //start testing from here
        Test.startTest();
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            //Insert Host Opportunity
            Engagement__c hostOpportunity = new Engagement__c(Name = 'Host - Opp', Account_Id__c = hostCompany.Id, Status__c = 'Test',
                                                            Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostOpportunity;
            
            //Insert Position Instance
            Position__c position = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id,
                                                    Intrax_Program__c = 'Internship',Country__c='Test', Engagement_Start__c = date.today(),Engagement_End__c = date.today().addDays(15), Status__c = 'Matching' );
            
            insert position;
            
            //List of positions
            List<Position__c> positions = new List<Position__c>();
            
            //insert in list
            for(Integer i = 0; i < 2; i++) {
                positions.add(new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id,Country__c='Test', 
                                                    Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(),Engagement_End__c = date.today().addDays(15), Status__c = 'Matching' ));
            }
            
            //insert data in bulk 
            insert positions;
            
            //instantiate controller 
            ParticipantRankingMatchScreen controller = new ParticipantRankingMatchScreen(new ApexPages.StandardController(hostOpportunity));
            system.debug('*******controller********'+controller);
            //Set program options
            List<SelectOption> programOptions = controller.programOptions;            
            List<SelectOption> langLevel = controller.langLevel;           
            List<SelectOption> CompType = controller.CompType;          
            List<SelectOption> lstFuncAreas = controller.lstFuncAreas;     
            List<SelectOption> PositionType=controller.PositionType;
             //List<SelectOption> CountriesOfInt=controller.CountriesOfInt;
             system.debug('*******programOptions ********'+controller.programOptions);
             system.debug('*******PositionType********'+controller.PositionType);
            //controller.inIt();
            
            //Call method manually as webservice can not be hit through test method
            controller.mapOfListPositionWrapper = new Map<Integer, List<PositionWrapper>>();
            controller.mapOfListPositionWrapper.put(1, new List<PositionWrapper>{new PositionWrapper(new Position__c(), 1, 1)});
            
            //Call method
            controller.sortDir = 'ASC';
            //controller.sortResults();
            
            //select records in list
           // controller.getNext();
            //controller.getPrevious();
             system.debug('*******controller********'+controller);
            for(Integer i = 0; i < controller.resultsStopNumber; i++)
                controller.getPossibleMatchesList()[i].selected = true;
            pagereference pg=controller.save();
             system.debug('*******controller********'+controller);
              system.debug('*******pg********'+pg);
            
            //Search functionality
          //  controller.selectProgramOption = 'Test-Unique';
           // controller.selectlangLevel = '5';           
          //  controller.inIt();
            system.debug('********reached her*******');
            controller.selectProgramOption = 'Hospitality Internship';
            controller.selectlangLevel = '5';            
            controller.regLocation = 'Test';            
            controller.selectPositionTypes.add('Business Management');
            controller.initIntern();
            system.debug('*******controller********'+controller);
            
            controller.selectProgramOption = 'Business Internship';
            controller.selectlangLevel = '1';
            controller.selectAreas.add('Marketing');
            controller.initIntern();
            
            controller.selectProgramOption = 'Summer Entrepreneurship';
            controller.selectlangLevel = '1';
            controller.selectAreas.add('Marketing');
            controller.initIntern();
            
            controller.selectProgramOption = 'WEST';
            controller.selectlangLevel = '1';
            controller.selectAreas.add('Marketing');
            controller.initIntern();
            
            controller.selectProgramOption = 'Test-Unique';
            controller.selectlangLevel = '2';
            controller.initIntern();
            
                        
            controller.selectProgramOption = 'Test-Unique';          
            controller.selectCompType='Paid';
            controller.selectAreas.add('Accounting');
            
           
            controller.initIntern();
            
            //Coverage for Opportunity Wrapper
            PositionWrapper pWrapper = new PositionWrapper(new Position__c());
            System.assert(!pWrapper.selected);
            System.assert(pWrapper.position != null);
            
            //Create a instance of Result Set manually 
            wwwIntraxincComMatchRanking.resultSet resultSet = new wwwIntraxincComMatchRanking.resultSet();
            wwwIntraxincComMatchRanking.result res = new wwwIntraxincComMatchRanking.result();
            wwwIntraxincComMatchRanking.attribute attribute = new wwwIntraxincComMatchRanking.attribute();
            attribute.Id = 1;
            
            res.attributes = new List<wwwIntraxincComMatchRanking.attribute>();
            res.attributes.add(attribute);
            resultSet.list_x = new List<wwwIntraxincComMatchRanking.result>();
            resultSet.list_x.add(res);
            
            RankingMatchUtility.mapPositionsWithIds = new Map<Integer, Position__c>{1 => new Position__c()};
            Map<Integer, List<PositionWrapper>> mapResult = RankingMatchUtility.parseResponseForPositions(resultSet);
            
            //Assert for the result
            System.assertEquals(1, mapResult.size());
            
            //stop test here
            Test.stopTest();
        }
    }
}