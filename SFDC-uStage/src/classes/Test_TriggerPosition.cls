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
private class Test_TriggerPosition {
/*
    Purpose         :   Test class for Trigger_Position.
                
    Created Date    :   03/19/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void testUpdateOpportunityOperationStageByPositionStatus() {
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0) {
            //Create test data
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
            insert hostOpportunity;
            
            //Create the list of position to test the Bulk scenerio
            List<Position__c> positions = new List<Position__c>();
            
            
            //Create 20 records in bulk 
            for(Integer i = 0; i< 2; i++) {
                //Insert Position Instance
                positions.add(new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                        Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3, Status__c = 'Test'));
            }
            
            //Start test from
            Test.startTest();
            
            //insert data in bulk
            insert positions;
            
            //assert result
            List<Opportunity> opportunities = [Select Id, Operation_Stage__c from Opportunity where Id =: hostOpportunity.Id];
            
            //check for the size
            if(opportunities.size() > 0) {
                System.assert(opportunities[0].Operation_Stage__c == null || opportunities[0].Operation_Stage__c == '');
            }
            
            //Create 20 records in bulk 
            for(Position__c position : positions) {
                //Insert Position Instance
                position.Status__c = Constants.POSITION_STATUS_CLOSED_FILLED;
            }
            
            //update records
            update positions;
            
            //assert result
            opportunities = [Select Id, Operation_Stage__c from Opportunity where Id =: hostOpportunity.Id];
            
            //assert result
            if(opportunities.size() > 0) {
                //System.assertEquals(Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED, opportunities[0].Operation_Stage__c);
            }
            
            //stop test here
            Test.stopTest();
        }
    }
}