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
private class Test_BatchOnUserDeletion {

    static testMethod void myUnitTest() {
    	User portalUser = [Select Id, IsUserNotServiced__c, isActive from User where isActive = false and isPortalEnabled = true limit 1];   
    	portalUser.IsUserNotServiced__c = true;
    	update portalUser;
    	String cronJobId = '0 0 0 1 1 ? 2025';
    	Test.startTest();
    	String scheduleJobId = system.schedule('Test_BatchOnUserDeletion', cronJobId, new BatchOnUserDeletion());
    	CronTrigger cronTrigger = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :scheduleJobId];
    	system.assertEquals(cronJobId, cronTrigger.CronExpression);
    	system.assertEquals(0, cronTrigger.TimesTriggered);
    	system.assertEquals('2025-01-01 00:00:00', String.valueOf(cronTrigger.NextFireTime));
    	Test.stopTest();
    }
}