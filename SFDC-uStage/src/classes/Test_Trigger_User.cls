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
@isTest(seeAllData=True)
private class Test_Trigger_User {
/*
    Purpose         :   Test class for Trigger_User.
                
    Created Date    :   03/19/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void testUser() {
     
            
            //Start test from
            Test.startTest();
            
            //insert data in bulk
       
            List<Profile> profiles = [Select p.Name, p.Id From Profile p where p.Name='Intrax Standard User' limit 1];
          
	     
               User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    Intrax_Id__c ='Test',type__c='Partner',ManualShareExists__c=false,
                                    Username = Math.random() + '@test.com');
            
               insert user;
         
                        
            user.ManualShareExists__c = true;
            update user;
            //stop test here
            Test.stopTest();
        }
    
}