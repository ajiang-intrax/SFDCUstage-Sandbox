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
private class Test_TriggerEducation {

    static testMethod void myUnitTest() {
     Applicant_Info__c newApp = new Applicant_Info__c(Name='test',Height__c = '60', WEight__c = '30',RecordTypeId = constants.AuPairCarePT_Record_Type_Id,University_Indicated__c='No',Additional_Training_Indicated__c='No');
     Insert newApp;
     Education__c university = new Education__c(Applicant_Info__c=newApp.id,Institution_Type__c='University/College');
     insert university;
     
     Education__c certification = new Education__c(Applicant_Info__c=newApp.id,Institution_Type__c='Vocational Training');
     insert certification;
     
     newApp.University_Indicated__c='Yes';
     newApp.Additional_Training_Indicated__c='Yes';
     update newApp;
     
     delete university;
     delete certification;
 }
}