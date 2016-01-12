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
@isTest(seeAllData=true)
private class Test_Trigger_Case {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        /* TEST CODE FOR IGI 889 */
        RecordType engWTRecordType = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='Work Travel PT' Limit 1];
         
        Engagement__c eng = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', 
        										RecordTypeId = engWTRecordType.Id, Current_Accommodation_State__c = 'VT');
         
        insert eng;
        
        RecordType wtrt = [SELECT Id FROM RecordType WHERE Name = 'Work Travel' AND sObjectType = 'Case'];
        Case c =  new Case(Type = 'Administrative', Reason = 'Monthly Contact', RecordTypeId = wtrt.Id,
        					Origin = 'Web', Status = 'New', Priority = 'High',
        					Description = 'Test', Engagement__c = eng.Id);
        
        insert c;
        
        Case c_check = [SELECT Id, OwnerId, Owner.Name FROM Case WHERE Id =: c.Id];
        system.debug('****** Case Owner: ' + c_check.Owner.Name);
        
        QueueSObject queue = [SELECT QueueId,SobjectType FROM QueueSobject WHERE SObjectType = 'Case' and Queue.Name = 'Work Travel Support Northeast'];
        system.assertEquals (queue.QueueId, c_check.OwnerId);
        
        /*END TC IGI 889 */
    }
}