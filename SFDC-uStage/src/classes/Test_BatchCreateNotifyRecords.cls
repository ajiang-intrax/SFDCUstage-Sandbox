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
private class Test_BatchCreateNotifyRecords {
/*
    Purpose         :   Test class for Batch_CreateNotifyRecords.
                
    Created Date    :   04/03/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
	private static testMethod void myUnitTestMethod() {
		
		 //Fetch record type Id from database of Type Business Account
        /*List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0) {
	        //Create test data
	        Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
	        insert hostCompany;
	        
	        Contact contact = new Contact(LastName = 'Test', AccountId = hostCompany.Id, Email = 'test@test.com');
	        insert contact;
	        	        
	        //Insert Host Opportunity
	        Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
	                                                        Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
	        insert hostOpportunity;
	        
	        //Create the list of position to test the Bulk scenerio
	        List<Position__c> positions = new List<Position__c>();
	        
	        
	        //Insert Position Instance
		    Position__c position = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
		                                                Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3, Status__c = 'Test');
	        insert position;
	        
	        //Insert match record
	        Match__c match = new Match__c(Name = 'test', Position_Name__c = position.Id, Interview_Date__c = DateTime.now() );
	        insert match;
	        
	        //start test from here
	        Test.startTest();
	        
	        Id batchJobId = Database.executeBatch(new Batch_CreateNotifyRecords(), 1);
	        
	        //Stop test here
	        Test.stopTest();
	        
	        //Assert for the results
	        Integer notifiedCount = [Select count() from Notify__c where Contact__c =: contact.Id];
	        //System.assertEquals(1, notifiedCount);
        }*/
	}
}