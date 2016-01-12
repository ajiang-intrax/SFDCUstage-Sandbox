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
private class Test_Schedulable_Calc_GeoCoords_Acc {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
		Test.startTest();
		String cronJobId = '0 0 0 1 1 ? 2022';
		String jobId = System.schedule('TestSchedulalbeCalcGeoCoordsAcc', cronJobId, new Schedulable_Calc_GeoCoords_Acc());
		CronTrigger cronTrigger = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobId];
		system.assertEquals(cronJobId, cronTrigger.CronExpression);
		
		String cronJobIdAccSites = '0 0 0 1 1 ? 2022';
		String jobIdAccSites = System.schedule('TestSchedulalbeCalcGeoCoordsAccSites', cronJobIdAccSites, new Schedulable_Calc_GeoCoords_AccSites());
		CronTrigger cronTriggerAccSites = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobIdAccSites];
		system.assertEquals(cronJobIdAccSites, cronTriggerAccSites.CronExpression);
		
		Test.stopTest();
    }
}