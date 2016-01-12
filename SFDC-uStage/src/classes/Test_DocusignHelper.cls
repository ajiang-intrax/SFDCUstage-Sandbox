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
private class Test_DocusignHelper {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //Create Test Data
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test',height__c='60', weight__c='60',City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                Country__c = 'United States', Home_Phone__c = '12345',Type__c='Participant', ETR_Received_Date__c=null
                                );
        insert appInfo;
        
        Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = 'Test', Applicant_Info__c = appInfo.Id, 
                                Role__c = 'Parent', Residency_Status__c ='Full-Time', Date_of_Birth__c = date.parse('01/01/1960'));
        insert personInfo;
         
        dsfs__DocuSign_Status__c dstest = new dsfs__DocuSign_Status__c(Person_Info__c=personInfo.Id);
        
        list<dsfs__DocuSign_Status__c > lstdst = new list<dsfs__DocuSign_Status__c >();
        lstdst.add(dstest);
        
        insert lstdst;
        // DSStatusTriggerHelper.updateApplicantInfoFk(lstdst);
        
    }
}