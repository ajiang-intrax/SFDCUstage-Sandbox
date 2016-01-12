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
private class Test_Trigger_Campaign_Position {
/*
    Purpose         :   Test class for Trigger_Campaign.
                
    Created Date    :   03/19/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void testCampaign() {
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0) {
            //Create test data
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
           
            //Create the list of position to test the Bulk scenerio
            List<Position__c> positions = new List<Position__c>();
            
            
            //Create 20 records in bulk 
            for(Integer i = 0; i< 2; i++) {
                //Insert Position Instance
                positions.add(new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id,  
                                                        Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3, Status__c = 'Test'));
            }
            
            //Start test from
            Test.startTest();
            
            //insert data in bulk
            insert positions;
            List<Profile> profiles = [Select p.Name, p.Id From Profile p where p.Name='OCPM Agent Portal' limit 1];
            RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1]; 
            Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
       		insert account;    		 
         Account account1  = new Account(Name = 'Test1', RecordTypeId = rt.Id, Type = 'Partner');
       		insert account1;  
	        //Contact
	        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
	        insert contact;
	         Contact contact1 = new Contact(LastName = 'LastName1', AccountId = account.Id, Email = 'test1@test.com');
	        insert contact1;
               User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',type__c='Partner',
                                    Username = Math.random() + '@test.com');
            
               insert user;
         
               User user1 = new User(Alias = 'alias1', Email = 'testUser1@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact1.Id, Intrax_Id__c ='Test',type__c='Partner',
                                    Username = Math.random() + '@test.com');
            
              insert user1;
             
             
            
            Campaign testCamp= new Campaign(Name='TestCamp',Partner_Name__c=account.Id);
            insert testCamp;
            Campaign testCamp1= new Campaign(Name='TestCamp1',Partner_Name__c=account.Id);
            insert testCamp1;
            
            Campaign_Position__c testCampPos= new  Campaign_Position__c(Name='TestCampPos',Campaign__c=testCamp.Id,position__c=positions[0].Id);
            insert testCampPos;
            
            testCampPos.Campaign__c = testCamp1.id;
            update testCampPos;
            //stop test here
            Test.stopTest();
        }
    }

}