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
public class Test_Batch_MatchANDInterview_Expire {

    static testMethod void myUnitTest() {
       
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        RecordType rteng = [select id,Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        
        //Account
        Account accountEng  = new Account(OwnerId = UserInfo.getUserId(),FirstName='testfirst',lastName = 'Testlast',PersonEmail='aa@test.com',PersonHomePhone='2345678977', RecordTypeId = rteng.Id, Type = 'Host Family');
        insert accountEng;
        
        Engagement__c myEngagement_1 = new Engagement__c(
            Name='TestEngagement',Account_Id__c=accountEng.id ,  Program_Duration__c = 'Academic Year', Type__c = 'Participant', Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized',
            Gender__c = 'Male', Actual_Arrival__c = date.today() + 100, Driving_Frequency__c = 'Sometimes (2-3 days per week)', OwnerId=sysAdmin.Id, Status__c = 'On Program',
            Language_1__c = 'Spanish', Driving_Experience__c = 'City', Allergies_Indicated__c = 'Yes', Drivers_Licence_Indicated__c = 'Yes', Swimming_Indicated__c = 'Yes'
        );
        insert myEngagement_1;
        
        RecordType rtposition = [select id, Name from RecordType where SobjectType='Position__c' and Name='AuPairCare HF' Limit 1];
        
        Account myAccountpo = new Account(Name='Test');
        insert myAccountpo;
        
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c = myAccountpo.Id, Status__c ='Matching', Country__c = 'United States', 
                                                 RecordTypeId =rtposition.id,Pets__c = 'Yes', Pet_Types__c = 'Dog');
        insert myPosition;
        
        
        Selection__c sec = new Selection__c(
        Name = 'Testselection',  OwnerId = UserInfo.getUserId(),Intrax_Program__c='AuPairCare',Position__c=myPosition.id,Engagement__c=myEngagement_1.id,
        Interview_Start_Date__c=date.newInstance(2015, 6, 20), Interview_End_Date__c=date.newInstance(2015, 7, 20),Status__c='Active');
        insert sec;
        
        RecordType rtmatch = [select id, Name from RecordType where SobjectType='Match__c' and Name='AuPairCare' Limit 1];
        
        match__c match= new match__c(Name=sec.Name,Position_Name__c=myPosition.id,RecordTypeId=rtmatch.id,
                                     status__c = 'Requested',Arrival_Date__c=date.newInstance(2015, 7, 20),Request_Expiration__c=date.newInstance(2015, 6, 20));
        insert match;
        system.debug('debug::testMatch'+match);
        
        Batch_InterviewExpire batchInterview = new Batch_InterviewExpire();
        Database.executeBatch(batchInterview);
        
        Batch_MatchExpire batchMatch = new Batch_MatchExpire();
        Database.executeBatch(batchMatch);
    }
    
}