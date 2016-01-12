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
private class Test_Trigger_Accommodation {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        RecordType engWTRecordType = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
         
        Engagement__c eng = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', RecordTypeId = engWTRecordType.Id);
         
        insert eng;
        
    	Accommodation_Site__c asite = new Accommodation_Site__c(
    			Street__c = '600 California St', Street_2__c = '10th Floor', City__c = 'San Francisco',
    			Country__c = 'United States', Postal_Code__c = '94108', Name = 'Test');
    	
    	insert aSite;
    	
    	Accommodation__c acc = new Accommodation__c (
    			Accommodation_Site__c = asite.Id,
    			Engagement__c = eng.Id
    			);
    			
    	insert acc;
    	
    	Accommodation__c acc_check1 = [SELECT Is_Current__c FROM Accommodation__c where Id =: acc.Id];
    	
    	system.assertEquals(acc_check1.Is_Current__c, true);
    	
    	Accommodation__c acc2 = new Accommodation__c (
    			Accommodation_Site__c = asite.Id,
    			Engagement__c = eng.Id
    			);
    			
    	insert acc2;
    	
    	
    }
}