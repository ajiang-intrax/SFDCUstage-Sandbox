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
@isTest(SeeAllData=false)

private class Test_Rating_Controller {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
        insert ac_pt;
        
        Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
          OwnerId = UserInfo.getUserId()
          );
          
        insert ac_hc;
        
        Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',  Account_Id__c = ac_pt.Id
          );
        insert ca;
        
        Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id, Host_Opportunity_Id__c = op.Id, Tipped_Position__c = 'Yes',
            Intrax_Program__c = 'Internship', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled', 
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          );
        insert p;
          
        Match__c m = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), 
            Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          
       insert m;
       
       Match__c m2 = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, Status__c = 'Interview Pending', Interview_Request_HC1__c=System.now().adddays(3), 
            Interview_Request_HC2__c=System.now().adddays(5), Interview_Request_HC3__c=System.now().adddays(9)
          );
          
       insert m2;
          
       Rating__c rating = new Rating__c(Score__c = '3', Match__c = m.Id);
       insert rating;
       
      
       Rating_Controller rc = new Rating_Controller();
       rc.roundValue('1');
       rc.roundValue('3.25');
       rc.roundValue('3.63');
       rc.saveRating();
       
       ApexPages.currentPage().getParameters().put('mId', m2.Id);
       
       Rating_Controller rc2 = new Rating_Controller();
       rc2.saveRating();
       
       Rating_Controller rc3 = new Rating_Controller();
       rc3.saveRating();
       
      
       
       
    }
}