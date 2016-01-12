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
private class Test_EU_APC_DepartureList_Controller {

    static testMethod void myUnitTest() {
        Account ac = new Account(
	    		FirstName = 'Test', LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
	    		type = 'Participant', Intrax_Programs__c = 'AuPairCare', status__c = 'Contracted',
	    		OwnerId = UserInfo.getUserId()
	    		);
	    insert ac;
	    
	    Contact c_ac = [SELECT Id, Name FROM Contact WHERE AccountId =: ac.Id];
	    
	    Account ac_partner = new Account(
	    		Name='Partner_Test', type = 'Partner', 
	    		//CurrencyIsoCode = 'USD - U.S. Dollar', 
	    		status__c = 'Contracted',
	    		OwnerId = UserInfo.getUserId()
	    		);
	    Contact c_partner = new Contact(AccountId = ac_partner.Id, lastName='Test', firstName = 'Partner'
	    //, CurrencyIsoCode = 'USD - U.S. Dollar'
	    );
	    
	    Opportunity op = new Opportunity(
        		Name = 'Test Trigger Opp 1', AccountId = ac.Id, RecordTypeId = Constants.OPP_AUPAIRCARE_PT, StageName = 'Prospecting',
        		Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'Europe', 
        		closeDate = date.today(), Intrax_Market__c = 'Germany', coordinator__c = c_partner.Id, Interviewer__c = c_partner.Id, 
        		Intrax_Program_Options__c = 'Extension', Interview_Docs_Received__c = date.today());
        		
        insert op;
        
        /*Audit_Document__c ad = new Audit_Document__c(
        	Name = 'Test', Opportunity__c = op.Id
        );
        
        insert ad;
        */
        
        List<Profile> profiles = [Select Id from Profile where Name = 'System Administrator' limit 1];
        try{
    	User user = new User(Alias = 'alias', Email = 'testUser@test456.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName456', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles',                                     
                                    Username = Math.random() + '@test456.com');
            
        insert user;
        
        
        system.runAs(user){
        	test.startTest();
            	
            	//Set request parameters
            	//ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(op);
                
                //General Page test
            	EU_APC_DepartureList_Controller controller = new EU_APC_DepartureList_Controller();
            	
            	//Detail Page Test
            	List<Opportunity> lstOpp=new list<Opportunity>();
            	//controller.ad = ad;
            	lstOpp=controller.getOtherOpps();            	       	
            	
            	test.stopTest();
        }
        }
        catch(exception e){
            system.debug('Unable to create user.Reason:'+e);
        }
            	
    }
}