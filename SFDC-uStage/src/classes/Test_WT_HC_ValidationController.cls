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
private class Test_WT_HC_ValidationController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account ac_pt1 = new Account(
		          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
		          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
		          OwnerId = UserInfo.getUserId()
		          );
        insert ac_pt1;
        RecordType OppsrtIGIPT = [select id, Name from RecordType where SobjectType='Opportunity' and Name='ICD Intern PT' Limit 1];
        
        Opportunity op = new Opportunity( Name = 'Test Opportunity', AccountId = ac_pt1.Id, RecordTypeId = OppsrtIGIPT.id, Type='Participant', Intrax_Programs__c = 'Work Travel', Intrax_Region__c = 'Europe', 
          									closeDate = date.today(), StageName = 'Closed Won');
    	insert op;
    	
    	ApexPages.StandardController sc = new ApexPages.StandardController(op);
    	WT_HC_ValidationController controller = new WT_HC_ValidationController(sc);
    	controller.getFinishPage();
    }
}