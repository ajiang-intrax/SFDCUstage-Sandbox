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
private class Test_Trigger_Campaign_Member {
/*
    Purpose         :   Test class for Trigger_Campaign_Member.
                
    Created Date    :   03/19/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void testCampaign() {
           Test.startTest();
       
            RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1]; 
            Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
       		insert account;    		 
        
	        //Contact
	        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
	        insert contact;
	       
            
             
             Lead lr = new Lead(LastName ='Test',email='test@test.com',Intrax_Programs__c='Ayusa',
		    Intrax_Program_Options__c = 'Ayusa High School',Lead_Type__c='Host Family');
		    
		    insert lr;
            
            Campaign testCamp= new Campaign(Name='TestCamp');
            insert testCamp;
            
            Campaign testCamp1= new Campaign(Name='TestCamp1');
            insert testCamp1;
            
           CampaignMember testCampMem = new CampaignMember(CampaignId=testCamp.Id, LeadId=lr.Id);
           insert testCampMem;
           
            CampaignMember testCampMem1 = new CampaignMember(CampaignId=testCamp1.Id, ContactId=contact.Id);
           insert testCampMem1;
           
           lr.Sys_Event_ID__c = testCamp.Id;
           update lr;
           
           contact.Sys_Event_ID__c = testCamp1.Id;
           update contact;
           
           testCampMem.Status = 'Registered';
           update testCampMem;
           
            testCampMem1.Status = 'Registered';
           update testCampMem1;
            //stop test here
            Test.stopTest();
        }
    }