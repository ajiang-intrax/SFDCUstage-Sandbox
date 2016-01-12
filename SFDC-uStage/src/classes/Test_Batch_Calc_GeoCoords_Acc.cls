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
@isTest(seeAllData = true)
private class Test_Batch_Calc_GeoCoords_Acc {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
		Database.QueryLocator queryLocator;
		Database.BatchableContext BC;
		list<iGeoLocate__c> lstIGeoLocate = new list<iGeoLocate__c>();
		Batch_Calc_GeoCoords_Acc obj = new Batch_Calc_GeoCoords_Acc();
		queryLocator = obj.start(bc);
		
		Database.QueryLocatorIterator iteratorQueryLocator =  queryLocator.iterator();
		while (iteratorQueryLocator.hasNext()){
		    iGeoLocate__c iGeoLocateDetails = (iGeoLocate__c)iteratorQueryLocator.next();  
		    lstIGeoLocate.add(iGeoLocateDetails);
		}
		obj.execute(BC, lstIGeoLocate);
		obj.finish(BC);
		Test.stopTest();
    }
}