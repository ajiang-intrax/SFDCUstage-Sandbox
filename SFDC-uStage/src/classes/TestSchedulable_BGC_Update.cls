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
@isTest(SeeAllData=true) 
private class TestSchedulable_BGC_Update {

    static testMethod void myUnitTest() {
        /*Applicant_Info__c ap = new Applicant_Info__c(
        	Name = 'Test 1', 
        	Type__c = 'Host Family', 
        	Engagement_Start__c = date.parse('09/17/2012')
        	);
        	
        insert ap;
        
        Person_Info__c p1 = new Person_Info__c(
        	Name = 'Sibling 1', 
        	applicant_info__c = ap.id, 
        	date_of_birth__c = date.parse('09/20/1995'),
        	BackGround_Check__c = 'Not Required', 
        	Primary_Applicant__c = false
        	);
        
        insert p1;*/
        
        Test.startTest();
        //Database.executeBatch(new BGC_Update());
        Test.StopTest();
    }
}