@isTest(seeAllData = true)
private class Test_message_center_controller {

    static testMethod void myUnitTest() {
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        Account partnerAccount  = new Account(Name = 'Partner Account', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'AuPairCare');
        insert partnerAccount;
        
        Contact contactPartner = new Contact(FirstName = 'Partner', LastName = 'Contact', AccountId = partnerAccount.Id, Email = 'test@test.com', PTR_Portal_Intrax_Program_Default__c = 'AupairCare');
        insert contactPartner;               
        
        User user = [SELECT Id,Email,ContactId,Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND isActive=true AND ContactId!=null AND Contact.PTR_Portal_Intrax_Program_Default__c != null LIMIT 1];
        
            Notification__c notification = new Notification__c();             
            notification.Status__c = 'Not Started';
            
            notification.Subject__c = 'test!';
            notification.Body__c = 'test';          
            notification.Intrax_Program__c = 'AuPairCare';                                                        
            notification.account__c = User.Contact.AccountId;
            notification.Parent_Notification__c = NULL;                         
             notification.contact__c = User.ContactId;                              
            notification.message_type__c = 'Application';
            notification.Type__c = 'test';
            notification.hide_from_user__c = false;
            notification.short_summary__c = 'test';
            notification.channels__c = 'Email; Portal';
            notification.Message_Status__c = 'Unread';
            notification.urgency__c = 'High';
            notification.User_Type__c = 'Partner';
            insert notification;
                
        
        
        
        System.runAs(user){
            Test.startTest();
            
            PageReference pageRef = new PageReference('/apex/message_center');
            Test.setCurrentPage(pageRef);
            System.debug('pageRef in tests-->'+pageRef);
            
                message_center_controller mc = new message_center_controller();
                
                mc.contIdChosen = notification.Id;
                mc.geturgentNotificationsListPTR();                
                mc.getNotificationsListAPC();
                mc.checkLogin();
                mc.markAsRead();
                mc.accountIds('Participant');
                                
                
            Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest_1() {
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
            
            Notification__c notification = new Notification__c();             
            notification.Status__c = 'Not Started';
            
            notification.Subject__c = 'test!';
            notification.Body__c = 'test';          
            notification.Intrax_Program__c = 'AuPairCare';                                                        
            notification.account__c = User.Contact.AccountId;
            notification.Parent_Notification__c = NULL;                         
             notification.contact__c = User.ContactId;                              
            notification.message_type__c = 'Application';
            notification.Type__c = 'test';
            notification.hide_from_user__c = false;
            notification.short_summary__c = 'test';
            notification.channels__c = 'Email; Portal';
            notification.Message_Status__c = 'Unread';
            notification.urgency__c = 'High';
            notification.User_Type__c = 'Participant';
            insert notification;
                
        
        
        
        System.runAs(user){
            Test.startTest();
            
            PageReference pageRef = new PageReference('/apex/message_center');
            Test.setCurrentPage(pageRef);
            System.debug('pageRef in tests-->'+pageRef);
            
                message_center_controller mc = new message_center_controller();
                
                mc.contIdChosen = notification.Id;
                mc.geturgentNotificationsListPTR();
                mc.getNotificationsListAPC();                
                //mc.checkLogin();
                mc.markAsRead();
                mc.accountIds('Participant');
                
                
            Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest_2() {
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
            
            Notification__c notification = new Notification__c();             
            notification.Status__c = 'Not Started';
            
            notification.Subject__c = 'test!';
            notification.Body__c = 'test';          
            notification.Intrax_Program__c = 'AuPairCare';                                                        
            notification.account__c = User.Contact.AccountId;
            notification.Parent_Notification__c = NULL;                         
             notification.contact__c = User.ContactId;                              
            notification.message_type__c = 'Application';
            notification.Type__c = 'test';
            notification.hide_from_user__c = false;
            notification.short_summary__c = 'test';
            notification.channels__c = 'Email; Portal';
            notification.Message_Status__c = 'Unread';
            notification.urgency__c = 'Low';
            notification.User_Type__c = 'Host';
            insert notification;
                
        
        
        
        System.runAs(user){
            Test.startTest();
            
            PageReference pageRef = new PageReference('/apex/message_center');
            Test.setCurrentPage(pageRef);
            System.debug('pageRef in tests-->'+pageRef);
            
                message_center_controller mc = new message_center_controller();
                
                mc.contIdChosen = notification.Id;
                mc.geturgentNotificationsListPTR();                
                mc.getNotificationsListAPC();
                mc.accountIds('Host');
                //mc.checkLogin();
                mc.markAsRead();
                
                
            Test.stopTest();
        }
    }
        
}