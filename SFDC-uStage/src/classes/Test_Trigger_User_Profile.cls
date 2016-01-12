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
private class Test_Trigger_User_Profile {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Account accountRM = new Account(Name = 'Test', OwnerId = UserInfo.getUserId());
        insert accountRM;
        
        Contact contact = new Contact(LastName = 'LastName', Email = 'test@test.com', AccountId=accountRM.Id);
        insert contact;
        
        list<Profile> profiles = [Select Id from Profile where id=:constants.APCRMProfileId limit 1];//Name = 'APC RM' 
        User userRM = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id,Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
        insert userRM;
        
       Area_Profile__c area = new Area_Profile__c(Name = 'alias', Climate__c = 'test', Cities_Cervised__c= 'test');
       insert area;
        
       User_Profile__c userProf = new User_Profile__c(User__c = userRM.id, Name = 'alias', Employment_Term_Length__c = '3 months', Area_Profile__c = area.Id , 
       OwnerId = UserInfo.getUserId(), Monthly_Stipend__c = 45 ,Is_Active__c =True);
       insert userProf; 
        
       Scorm__c scormRec = new Scorm__c(Name = 'alias',Course_Id__c='ahkhak72kjhgkahsd',Course_Name__c='APC Test Course',Scorm_Application_ID__c='EVZYGQR5ND',Learner_Id__c='abc@yahooo.com',Total_Time__c='0',User_Profile__c=userProf.id);
       insert scormRec;                        
    }
}