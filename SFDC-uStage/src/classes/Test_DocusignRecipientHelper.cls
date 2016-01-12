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
private class Test_DocusignRecipientHelper {

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
        
        insert dstest; 
        dsfs__DocuSign_Recipient_Status__c dstest1 = new dsfs__DocuSign_Recipient_Status__c (Person_Info__c=personInfo.Id,dsfs__Parent_Status_Record__c=dstest.Id,dsfs__DocuSign_Recipient_Id__c='E7BB27F3-3405-49A0-B476-E9AEA314B12D');
        dstest1.dsfs__Date_Signed__c = date.parse('01/01/2010');
        
        list<dsfs__DocuSign_Recipient_Status__c > lstdst = new list<dsfs__DocuSign_Recipient_Status__c >();
        lstdst.add(dstest1);
        
        insert lstdst;
        // DSStatusTriggerHelper.updateApplicantInfoFk(lstdst);
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and IsPersonType=True and Name='Participant' Limit 1];
        RecordType hostCompanyRecordType1 = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        RecordType engrt = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        Account account  = new Account(FirstName = 'Test', LastName = 'Trigger',PersonEmail = 'test@test.com', RecordTypeId = hostCompanyRecordType.Id, Type = 'Participant', 
                                        Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
          Account hostComp = new Account( Name = 'hostc',Type = 'Host Company', RecordTypeId = hostCompanyRecordType1.Id);
          insert hostComp;
         Opportunity opp = new Opportunity(Name = 'tst Opp', AccountId = account.Id, CloseDate = Date.Today(), StageName = 'Processing',
                                                            Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'High School Worldwide', Engagement_Start__c = Date.today());
         insert opp;
         Opportunity hostOpp = new Opportunity(Name = 'Host - Opp', AccountId = hostComp.Id, CloseDate = Date.Today(),
                                                            Intrax_Programs__c = 'Internship', StageName = 'Prospecting',Intrax_Program_Options__c = 'Business Internship', Engagement_Start__c = Date.today());
          insert hostOpp;
        
        Engagement__c eng = new Engagement__c(Name = 'test eng',RecordTypeId = engrt.Id,Intrax_Program__c = 'Internship',Type__c = 'Participant',Opportunity_Id__c =opp.Id);
        insert eng;
        
        Position__c pos2 = new Position__c(Name = 'TestPosition',Tipped_Position__c = 'Yes', Host_Company_Id__c=hostComp.Id,Host_Opportunity_Id__c = hostOpp.Id, 
                                                    Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'High School Worldwide', Engagement_Start__c = Date.today() + 3,Country__c='Australia' );
            
        insert pos2;
        
        
        
        Match__c mat = new Match__c(Name = 'test match',Participant_Id__c = opp.AccountId,Participant_Opportunity_Id__c = opp.Id, Position_Name__c = pos2.Id,Engagement__c =eng.Id, Status__c = 'Applied');
        insert mat;
        dstest.Match__c =mat.Id; 
        update dstest;
        
        Development_Plan__c devplan = new Development_Plan__c(Name = 'test dev',Match_Name__c = mat.Id);
        insert devplan;
        
        DSRStatusTriggerHelper.updateDevelopmentPlan(lstdst);
        
    }
}