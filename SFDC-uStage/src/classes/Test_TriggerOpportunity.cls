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
private class Test_TriggerOpportunity {

    static testMethod void Positive_Cases() {
        // Creating Initial Data:
        Account ac = new Account(
                FirstName = 'Test', LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'AuPairCare', status__c = 'Contracted',
                OwnerId = UserInfo.getUserId()
                );
        insert ac;
        Contact c_ac = [SELECT Id, Name FROM Contact WHERE AccountId =: ac.Id];
        
        Account ac_partner = new Account(
                Name='Partner_Test', type = 'Partner', //CurrencyIsoCode = 'USD - U.S. Dollar', 
                status__c = 'Contracted',
                OwnerId = UserInfo.getUserId()
                );
        Contact c_partner = new Contact(AccountId = ac_partner.Id, lastName='Test', firstName = 'Partner'
                                        //, CurrencyIsoCode = 'USD - U.S. Dollar'
                                        );
        
        // Test 1.1: Creating a new Opportunity with RecordType = 'AuPairCare PT' and Intrax_Region__c = 'Europe'
        Opportunity op = new Opportunity(
                Name = 'Test Trigger Opp 1', AccountId = ac.Id, RecordTypeId = Constants.OPP_AUPAIRCARE_PT, StageName = 'Prospecting',
                Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'Europe', Description = 'Test Clone 1',
                closeDate = date.today(), Intrax_Market__c = 'Germany', coordinator__c = c_partner.Id, Interviewer__c = c_partner.Id, 
                Intrax_Program_Options__c = 'Extension', Interview_Docs_Received__c = date.today());
                
        insert op;
        
        //Opportunity opp_check = [SELECT Id, Incomplete_Missing_Documents__c, Primary_Contact__c, Description FROM Opportunity WHERE Name = 'Test Trigger Opp 1'];
        
        op.Description ='Test Clone 1 Update';
        update op;
        
         // Test 1.2: Testing Intrax_Market == France
        Opportunity op2 = new Opportunity(
                Name = 'Test Trigger Opp 2', AccountId = ac.Id, RecordTypeId = Constants.OPP_AUPAIRCARE_PT, StageName = 'Prospecting',
                Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'Europe', Description = 'Test Clone 2',
                closeDate = date.today(), Intrax_Market__c = 'France', coordinator__c = c_partner.Id, Interviewer__c = c_partner.Id, 
                Intrax_Program_Options__c = 'Extension', Interview_Docs_Received__c = date.today());
       
        insert op2;
        
         // Test 1.3: Testing Intrax_Market == Spain
        Opportunity op3 = new Opportunity(
                Name = 'Test Trigger Opp 3', AccountId = ac.Id, RecordTypeId = Constants.OPP_AUPAIRCARE_PT, StageName = 'Prospecting',
                Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'Europe', Description = 'Test Clone 2',
                closeDate = date.today(), Intrax_Market__c = 'Spain', coordinator__c = c_partner.Id, Interviewer__c = c_partner.Id, 
                Intrax_Program_Options__c = 'Extension', Interview_Docs_Received__c = date.today());
       
        insert op3;
        
        //  Test 1.4: Inserting a list of opportunities. Testing GL
        list<Opportunity> opp_list = new list<Opportunity>();
        integer recordsToInsert = 3;
        for(Integer i=0; i<recordsToInsert; i++){
            Opportunity op_bulk = new Opportunity(
                Name = 'Test Trigger Opp Bulk ' + i, AccountId = ac.Id, RecordTypeId = Constants.OPP_AUPAIRCARE_PT, 
                Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'Europe', Intrax_Market__c = 'United Kingdom', 
                closeDate = date.today(), StageName = 'Review');
            opp_list.add(op_bulk);
        }
        insert opp_list;
        
        list<Opportunity> op_bulk_check = [SELECT Id, Incomplete_Missing_Documents__c FROM Opportunity WHERE Name LIKE 'Test Trigger Opp Bulk%'];
        
        //for(Opportunity o: op_bulk_check){
        //    system.assertEquals(o.Incomplete_Missing_Documents__c, 'Agreement;Agency Agreement;Background Check;Character Reference;Childcare Reference 1;Childcare Reference 2;Diploma;Driving License;Medical Form;Doctors Note;Passport;Photos;Video');
        //}
    }
    
    
     static testMethod void Negative_Cases() {
        // Creating Initial Data:
        Account ac = new Account(
                FirstName = 'Test', LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'AuPairCare', status__c = 'Contracted',
                OwnerId = UserInfo.getUserId()
                );
        insert ac;
        
        // Test 1.1: Creating a new Opportunity with RecordType = 'AuPairCare PT' and Intrax_Region__c = 'Chile'
        Opportunity op_1 = new Opportunity(
                Name = 'Test Trigger Opp 1', AccountId = ac.Id, RecordTypeId = Constants.OPP_AUPAIRCARE_PT, 
                Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'Chile', 
                closeDate = date.today(), StageName = 'Review');
                
        insert op_1;
        
        //Opportunity opp_check_1 = [SELECT Id, Incomplete_Missing_Documents__c FROM Opportunity WHERE Name = 'Test Trigger Opp 1'];
        //system.assertEquals(opp_check_1.Incomplete_Missing_Documents__c, null);
        
        // Test 1.2: Creating a new Opportunity with RecordType = 'AuPairCare PT' and Intrax_Region__c = 'Europe' and Incomplete_Missing_Documents__c != null
        Opportunity op_2 = new Opportunity(
                Name = 'Test Trigger Opp 2', AccountId = ac.Id, RecordTypeId = Constants.OPP_AUPAIRCARE_PT, 
                Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'Chile', Incomplete_Missing_Documents__c = 'Video',
                closeDate = date.today(), StageName = 'Review');
                
        insert op_2;
        
        //Opportunity opp_check_2 = [SELECT Id, Incomplete_Missing_Documents__c FROM Opportunity WHERE Name = 'Test Trigger Opp 2'];
        //system.assertEquals(opp_check_2.Incomplete_Missing_Documents__c, 'Video');
   
     
     }
    
}