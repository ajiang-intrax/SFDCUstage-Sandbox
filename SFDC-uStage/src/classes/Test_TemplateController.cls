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
private class Test_TemplateController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        PageReference pageRef = Page.Partner_DefaultIP_Selection;
        Test.setCurrentPage(pageRef);
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        Account partnerAccount  = new Account(Name = 'Partner Account', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'AuPairCare');
        insert partnerAccount;
        
        Contact contactPartner = new Contact(FirstName = 'Partner', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contactPartner;               
        
        User user = [SELECT Id,Email,ContactId,Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true AND ContactId!=null AND Contact.PTR_Portal_Intrax_Program_Default__c != null LIMIT 1];
        
        
		Test.startTest();
		System.assertEquals(Page.Partner_DefaultIP_Selection.getUrl(),pageRef.getUrl());
		
        TemplateController controller = new TemplateController();                
        controller.user.Type__c='Partner';          
        System.assertEquals(controller.IsPartner,false);
                       
        controller.getDefaultIP();
        controller.getContactIP();
        controller.getContactIPSize();
        controller.checkLogin();
        controller.UpdateToAPC();
        controller.UpdateToAyusa();
        controller.UpdateToEA();
        controller.UpdateToIntern();
        controller.UpdateToWT();        
        controller.getAppStatus();
        controller.getIsMatchingStage();
        controller.getUnreadCount();
        controller.accountIds('Participant');        
       	Test.stopTest();
       	
        System.currentPageReference().getParameters().put('uIn','test');
        System.currentPageReference().getParameters().put('id','123oUnvbr');
        TemplateController controllerb = new TemplateController();
        controllerb.user.Intrax_Id__c = '123213';
        controllerb.user.Type__c='Partner'; 
    }
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //User user = [SELECT Id,Email,ContactId,Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Type__c = 'Participant' AND Profile.Name = 'OCPM PT' AND User_Interests__c='Becoming an au pair' AND isActive=true AND ContactId!=null AND Contact.PTR_Portal_Intrax_Program_Default__c != null LIMIT 1];
        
        //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'PTTest', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
            
            insert user;
        System.runAs(user){
		Test.startTest();
		
		
        TemplateController controller = new TemplateController();        
        controller.user.Intrax_Id__c = null;
                      
        controller.getDefaultIP();
        controller.getContactIP();
        controller.getContactIPSize();
        controller.checkLogin();
        controller.UpdateToAPC();
        controller.UpdateToAyusa();
        controller.UpdateToEA();
        controller.UpdateToIntern();
        controller.UpdateToWT();        
        controller.getAppStatus();
        controller.getIsMatchingStage();
        controller.getUnreadCount();
        controller.accountIds('Participant');   
        controller.getCurrentApp();
        controller.getOriginalApp();
       	Test.stopTest();
        }
         
        
    }
    
    static testMethod void myUnitTest3() {
        // TO DO: implement unit test
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
         
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //RecordType rtPw = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='PW Participant' Limit 1];
        
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;       
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];       
        
        //User user = [SELECT Id,Email,ContactId,Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Type__c = 'Host' AND Profile.Name = 'OCPM PT' AND User_Interests__c='Hosting an au pair' AND isActive=true AND ContactId!=null AND Contact.PTR_Portal_Intrax_Program_Default__c != null LIMIT 1];
        
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'PTTest', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
        System.runAs(user){
		Test.startTest();
		
		
        TemplateController controller = new TemplateController();        
        controller.user.Intrax_Id__c = null;
                      
        controller.getDefaultIP();
        controller.getContactIP();
        controller.getContactIPSize();
        controller.checkLogin();
        controller.UpdateToAPC();
        controller.UpdateToAyusa();
        controller.UpdateToEA();
        controller.UpdateToIntern();
        controller.UpdateToWT();        
        controller.getAppStatus();
        controller.getIsMatchingStage();
        controller.getUnreadCount();
        controller.accountIds('Host');        
       	Test.stopTest();
        }
         
        
    }
}