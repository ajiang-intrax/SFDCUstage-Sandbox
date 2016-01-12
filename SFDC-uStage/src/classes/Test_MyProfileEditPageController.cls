@isTest(seeAllData=false)
private class Test_MyProfileEditPageController{

    static testMethod void myUnitTest() {
        
        PageReference p=Page.AppEngine_Home; 
       //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        Test.setCurrentPage(p); 
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        sysAdmin.Email='test@josele.com';
        //update sysAdmin;
        //Portal User
        User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = 'test@josele.com', User_Interests__c='Hosting an au pair');
            
        insert user;
        Applicant_Info__c app= new Applicant_Info__c (Name='TestApp', Email__c='test@test.com',CreatedBy__c=user.id);
        insert app;
        Person_Info__c per= new Person_Info__c (Name='TestPerson', Email__c='test@test.com',Primary_Applicant__c=true,Applicant_Info__c=app.id);
        insert per;
        System.runAs(user) {
       
        test.starttest();
        
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        System.currentPageReference().getHeaders().put('USER-AGENT','rv:12.0');
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'rv:12.0');
        ApexPages.currentPage().getParameters().put('DbUserEmail', 'test@josele.com');
        
        MyProfileEditPageController ng = new MyProfileEditPageController();
        ng.DbUserEmail = 'test@josele.com';
        Pagereference pg1 = ng.save();
        Pagereference pg2 = ng.cancel();
        Pagereference pg3 = ng.confirm();
        
        
        ApexPages.currentPage().getParameters().put('DbUserEmail', 'test@josele.com');
        MyProfileEditPageController ng2 = new MyProfileEditPageController();
        ng2.DbUserEmail = 'test111@josele.com';
        Pagereference pg12 = ng2.save();
        Pagereference pg22 = ng2.cancel();
        Pagereference pg32 = ng2.confirm();
        
        user.User_Interests__c = 'Becoming a high school exchange student';
        user.username='test111@josele.com';
        update user;
        MyProfileEditPageController ng3 = new MyProfileEditPageController();
        //user.username= 'test111@06030000000pqifforce.com';
        ng3.DbUserEmail = 'test111@josele.com';
        Pagereference pg13 = ng3.save();
        Pagereference pg23 = ng3.cancel();
        Pagereference pg33 = ng3.confirm();     
        ng3.update_contact();
        test.stoptest();
        ng3.getUser();
      }
     
    }
    static testMethod void myUnitTest2() {
        
        PageReference p=Page.AppEngine_Home; 
       //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        Test.setCurrentPage(p); 
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Account
        Account account2  = new Account(Name = 'Test2', RecordTypeId = rt.Id, Type = 'Partner');
        insert account2;
        
        //Contact
        Contact contact2 = new Contact(LastName = 'LastName2', AccountId = account2.Id, Email = 'test2@test.com');
        insert contact2;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        sysAdmin.Email='test@josele.com';
        //update sysAdmin;
        //Portal User
        User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = 'test@josele.com', User_Interests__c='Hosting an au pair');
            
        insert user;
        
        User user2 = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName12', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact2.Id,Intrax_Id__c ='Test',
                                    Username = 'test123@josele.com', User_Interests__c='Hosting an au pair');
            
        insert user2;
        
        Applicant_Info__c app= new Applicant_Info__c (Name='TestApp', Email__c='test@test.com',CreatedBy__c=user.id);
        insert app;
        Person_Info__c per= new Person_Info__c (Name='TestPerson', Email__c='test@test.com',Primary_Applicant__c=true,Applicant_Info__c=app.id);
        insert per;
        System.runAs(user) {
       
        test.starttest();
        
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        System.currentPageReference().getHeaders().put('USER-AGENT','rv:12.0');
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'rv:12.0');
        ApexPages.currentPage().getParameters().put('DbUserEmail', 'test@josele.com');
        
        MyProfileEditPageController ng = new MyProfileEditPageController();
        ng.DbUserEmail = 'test@josele.com';
        Pagereference pg1 = ng.save();
        Pagereference pg2 = ng.cancel();
        Pagereference pg3 = ng.confirm();
        
        ng.DbUserEmail = '@.comtest@josele.com';
        Pagereference pg4 = ng.save();
        
        ApexPages.currentPage().getParameters().put('DbUserEmail', 'test@josele.com');
        MyProfileEditPageController ng2 = new MyProfileEditPageController();
        ng2.DbUserEmail = 'test111@josele.com';
        Pagereference pg12 = ng2.save();
        Pagereference pg22 = ng2.cancel();
        Pagereference pg32 = ng2.confirm();
        
        user.User_Interests__c = 'Becoming a high school exchange student';
        user.username='test111@josele.com';
        update user;
        MyProfileEditPageController ng3 = new MyProfileEditPageController();
        //user.username= 'test111@06030000000pqifforce.com';
        ng3.DbUserEmail = 'test111@josele.com';
        Pagereference pg13 = ng3.save();
        Pagereference pg23 = ng3.cancel();
        Pagereference pg33 = ng3.confirm();     
        ng3.update_contact();
        test.stoptest();
        ng3.getUser();
      }
     
    }
    
}