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
private class Test_Trigger_Development_Plan {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Test.startTest();
        
        Date todaysDate = Date.today();
        Date startDate = todaysDate.addDays(120);
        Date endDate = todaysDate.addDays(230);

         //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', //Account_Id__c = account.Id, 
        //RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'Business Internship; Internship - J1', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', Engagement_Start__c = startDate, Engagement_End__c = endDate,
                                                     //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                     Program_Year__c ='2015', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;

        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'Business Internship; Internship - J1', Intrax_Region__c = 'United States');
        insert account;
        
        Opportunity opp = new Opportunity(Name = 'Host - Opp', AccountId = account.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'Business Internship; Internship - J1', Engagement_Start__c = startDate);
            insert opp;

        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Internship',  
                                                Intrax_Region__c = 'United States', Engagement_Start__c = startDate,
                                                Engagement_End__c = endDate, Country__c='United States',
                                                Host_Company_Id__c = account.Id, Status__c='Matching', Tipped_Position__c = 'No' 
                                                );
        insert position;
        
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = position.Id, Status__c = 'Assigned', 
                                        Engagement__c = engagement.Id                                    
                                        );
        insert match;
        
        Development_Plan__c phaseOne = new Development_Plan__c(Name = 'Phase One', Match_Name__c = match.Id, Start__c=startDate, End__c = startDate.addDays(30));
        Development_Plan__c phaseTwo = new Development_Plan__c(Name = 'Phase Two', Match_Name__c = match.Id, Start__c=startDate.addDays(61), End__c = startDate.addDays(90));
        Development_Plan__c phaseThree = new Development_Plan__c(Name = 'Phase Three', Match_Name__c = match.Id, Start__c=startDate.addDays(31), End__c = startDate.addDays(60));
        
        //first, we test inserts of Development_Plan__c objects to verify that the trigger insert code fires
        insert phaseOne;
        insert phaseTwo;
        insert phaseThree;
        
        //now, we test updates of the Development_Plan__c objects to verify the trigger update code fires 
        phaseTwo.Start__c = startDate.addDays(31);
        phaseTwo.End__c = startDate.addDays(60);
        update phaseTwo;
        
        phaseThree.Start__c = startDate.addDays(61);
        phaseThree.End__c = startDate.addDays(90);
        update phaseThree;
        
        //now, we test delete of a Development_Plan__c object to verify the trigger delete code fires
        delete phaseTwo;
        Test.stopTest();
    }
}