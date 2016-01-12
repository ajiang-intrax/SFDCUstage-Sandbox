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
private class Test_Plugin_geoDistance_Calc {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        Application_Constants__c setting = new Application_Constants__c();
        setting.Name = 'EndPoint_AddressValidation';
        setting.Key__c = 'EndPoint_AddressValidation';
        setting.Value__c = 'http://svc.dev.intraxinc.com:8080/AddressService-v3/AddressService';
        insert setting;
        iGeoLocateTriggerHelper.isTest = true;
        Assessment__c a = new Assessment__c(Street__c = '240 OFarrell St', City__c = 'San Francisco', Country__c = 'United States', Postal_Code__c = '94102', State__c = 'CA',
        									Status__c = 'Incomplete' );
       	insert a;
       	
       	iGeoLocate__c gl_a = new iGeoLocate__c(Assessment__c = a.Id);
       	insert gl_a;
       	
       	Account acc = new Account(Name = 'Test', Intrax_Programs__c = 'Work Travel', Type = 'Host Company', BillingStreet = '600 California', 
    							BillingCity = 'San Francisco', BillingState = 'CA', BillingCountry='United States', BillingPostalCode='94108');
    	insert acc;
    	iGeoLocate__c gl_acc = new iGeoLocate__c(Account__c = acc.Id);
       	insert gl_acc;
    	
       			
        Plugin_geoDistance_Calc Plugin = new Plugin_geoDistance_Calc();
        Map<String,String> inputParams = new Map<String,String>();
        
        Map<String,Object> outputParams = new Map<String,Object>();
        	    
        inputParams.put('AssessmentId',a.Id);
        inputParams.put('AccountId',acc.Id);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = Plugin.invoke(request);
        
        Process.PluginDescribeResult result2 = Plugin.describe();
        
                
        test.stopTest();
    }
}