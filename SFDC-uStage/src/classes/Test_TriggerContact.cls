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
private class Test_TriggerContact {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // Test 1.1. Inserting Business Account + Contact
        Account a = new Account(
            Name = 'Trigger HC', Email_Business__c = 'testhc@test.com',
            type = 'Host Company', Intrax_Programs__c = 'Internship', 
            OwnerId = UserInfo.getUserId()
            );
            
        insert a;
        
        Contact c = new Contact(
            FirstName = 'Test', LastName = 'Triggerc', Email = 'testc@test.com',
            Intrax_Programs__c = 'Internship', OwnerId = UserInfo.getUserId(), AccountId = a.Id
            );
        
        insert c;       
     /*   sContact__c sc = [SELECT Id, Last_Name__c, Email__c FROM sContact__c WHERE Last_Name__c = 'Triggerc'];
        system.assertEquals(sc.Email__c, 'testc@test.com');*/
        
        c.Email = 'test1c@test.com';
        
        update c;
        /*sc = [SELECT Id, Last_Name__c, Email__c FROM sContact__c WHERE Last_Name__c = 'Triggerc'];
        system.assertEquals(sc.Email__c, 'test1c@test.com');*/  
        
    }
    
    static testMethod void bulk_Test(){
        Account a = new Account(
            Name = 'Trigger HC', Email_Business__c = 'testhc@test.com',
            type = 'Host Company', Intrax_Programs__c = 'Internship', 
            OwnerId = UserInfo.getUserId()
            );
            
        insert a;
        // If want to test the Governor Limits, change this parameter to 201.
        integer recordsToInsert = 3;
        list<Contact> co = new list<Contact>();
        for (integer i = 0 ; i < recordsToInsert; i++){
            Contact c = new Contact(
                FirstName = 'Test', LastName = 'Triggerc', Email = 'test_'+ i +'@test.com',
                Intrax_Programs__c = 'Internship', OwnerId = UserInfo.getUserId(), AccountId = a.Id
                );
            co.add(c);
        }
        insert co;
    }
}