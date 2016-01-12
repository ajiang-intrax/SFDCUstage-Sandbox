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
private class Test_autoSyncApplication {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        RecordType recType = [select Id, Name from RecordType where SobjectType = 'Account' and Name = 'Partner Admin' limit 1];
        
        //Partner Account
        Account account = new Account();
        account.Name = 'Test Partner Account';
        account.Type = 'Partner';
        account.Intrax_Programs__c = 'Work Travel';	   
        account.RecordTypeID = recType.Id;
        insert account;   
        
        Account partnerAccount = [Select Id, Intrax_Id__c from Account where Id = :account.Id];
        
        //Applicant Info
        Applicant_Info__c applicantInfo = new Applicant_Info__c(Name = 'Test-WT Application', Intrax_Program__c = 'Work Travel', Application_Stage__c = 'Submitted', 
        							Application_Level__c = 'Main', Service_Level__c = 'Premium', Partner_Intrax_Id__c = partnerAccount.Intrax_Id__c);
        insert applicantInfo;
        
        list<Person_Info__c> lstPersonInfo = new list<Person_Info__c>();
        
        Person_Info__c	personInfo_PrimaryApplicant = new Person_Info__c();
        personInfo_PrimaryApplicant.Name = 'Primary Person Info';
        personInfo_PrimaryApplicant.Last_Name__c = 'Test';
        personInfo_PrimaryApplicant.Applicant_Info__c = applicantInfo.Id;
        personInfo_PrimaryApplicant.Primary_Applicant__c = true;
        lstPersonInfo.add(personInfo_PrimaryApplicant);
        
        Person_Info__c	personInfo_NotPrimaryApplicant = new Person_Info__c();
        personInfo_NotPrimaryApplicant.Name = 'Not Primary Person Info';
        personInfo_NotPrimaryApplicant.Last_Name__c = 'Test';
        personInfo_NotPrimaryApplicant.Applicant_Info__c = applicantInfo.Id;
        personInfo_NotPrimaryApplicant.Primary_Applicant__c = false;
        lstPersonInfo.add(personInfo_NotPrimaryApplicant);
        
        insert lstPersonInfo;
        
        system.assertEquals(lstPersonInfo.size(), 2);
        
        applicantInfo.Application_Stage__c = 'In-Review';
        update applicantInfo;
        
        Test.startTest();
        
        applicantInfo.Application_Stage__c = 'Submitted';
        update applicantInfo;
        
        applicantInfo.Application_Stage__c = 'In-Review';
        update applicantInfo;
        
        Test.stopTest();
    }
}