/*
    Purpose         :   Test class for BatchMatchController.
               
    Created Date    :   02/06/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
@isTest
private class Test_BatchMatchController {
    
    //Test method 
   /* static testMethod void testConstructor() {
        
        //start testing from here
        Test.startTest();
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostOpportunity;
            
            //Insert Position Instance
            Position__c position = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(),Engagement_End__c = date.today().addDays(15) );
            
            insert position;
            
            //Create test data
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 2; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType[0].Id, PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            
            //Create list of opportunities
            List<Opportunity> listOpportunity = new List<Opportunity>();
            
            //insert in list
            for(Account acc : listAccount) {
                listOpportunity.add(new Opportunity(Name = 'Test', Type='Participant',Operation_Stage__c='Match Ready', AccountId = acc.Id, CloseDate = Date.Today(), Project_Name__c = 'test',
                                                    App_Fee_Paid__c = true, Intrax_Programs__c = 'Internship', 
                                                    Engagement_Start__c = date.today().addDays(-15),Engagement_End__c = date.today().addDays(35), StageName = 'Closed Won'));
            }
            
            insert listOpportunity;
            
            //instantiate controller 
            BatchMatchController controller = new BatchMatchController(new ApexPages.StandardController(position));
            PageReference bm = Page.BatchMatch;
            Test.setCurrentPageReference(bm);
            controller.sortExpression = 'name';
            controller.inIt();
            
            //assert for the properties
            System.assert(controller.totalResults >= 1);
            
            //select records in list
            controller.getNext();
            controller.getPrevious();
            
            for(Integer i = 0; i < controller.resultsStopNumber; i++)
                controller.getPossibleMatchesList()[i].selected = true;
            controller.save();
            
            //assert the result
            Integer counter = [Select count() from Match__c where Position_Name__c =: position.Id];
            System.assertEquals(controller.resultsStopNumber, counter);
            
            //Coverage
            controller.getSortDirection();
            controller.setSortDirection('DESC');
            
            //stop test here
            Test.stopTest();
            
        }
    }*/
}