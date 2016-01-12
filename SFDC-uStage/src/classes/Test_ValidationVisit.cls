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
private class Test_ValidationVisit {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
          Test.startTest();
        
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id,Program_Role__c='Ayusa Validator',Intrax_programs__c='Ayusa');
        insert contact;
        
         
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
      
        
            User tstuser = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles',Type__c = 'Partner', ContactId = contact.Id,
                                    Username = Math.random() + '@test.com');
            
            insert tstuser;
        
                   
            //insert data in bulk 

              List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
             List<RecordType> participantRecordType1 = [Select Id from RecordType where DeveloperName = 'Participant'  AND SObjectType = 'Account' AND IsActive = true ];
    List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
       
              if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
           
            //Insert Host Opportunity
            Engagement__c hostEngagement = new Engagement__c(Name = 'Host - Opp', Account_Id__c = hostCompany.Id, Status__c = 'Test',
                                                            Intrax_Program__c = 'Ayusa', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostEngagement;
            //Insert Position Instance
            Position__c position = new Position__c(Name = 'TestPosition',Country__c='Australia', Host_Company_ID__c = hostCompany.Id, 
                                                    Intrax_Program__c = 'Ayusa', Engagement_Start__c = date.today(),Engagement_End__c = date.today().addDays(15), Status__c='Matching' );
            
            insert position;
         
            List<Engagement__c> listEngagement = new List<Engagement__c>();
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 20; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType1[0].Id, PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            //insert in list
            for(Account acc : listAccount) {
                listEngagement.add(new Engagement__c(Name = 'Test', Type__c='Participant',status__c='Match Ready', Account_Id__c = acc.Id,
                                                    Intrax_Program__c = 'Ayusa',Engagement_Start__c = date.today().addDays(-15),Engagement_End__c = date.today().addDays(35)));
            }
            
            insert listEngagement;
            
            
 Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = listAccount[0].Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
            
            Match__c m = new Match__c(
            Name = 'TestMatchTestTest1234Test####Test123', Position_Name__c = position.Id, validator__c= contact.Id,Engagement__c =  listEngagement.get(0).Id, Participant_Id__c = listAccount.get(0).Id,
            Status__c = 'Confirmed', start_date__c=  date.today().addDays(35), Match_Type__c='Temporary', Participant_Opportunity_Id__c = op.Id);
            
            insert m;
            List<Match__c> result = new list<Match__c>();
            ValidationVisit_Controller controller = new ValidationVisit_Controller();
            ValidationVisit_Controller.isTest=true;
            controller.user = tstuser;
            result=controller.getlstValidationVisits();
             Test.stopTest();
              }
    }
}