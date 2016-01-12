@isTest
private class Test_FlowController {

    static testMethod void myUnitTest() {	
		test.startTest();
        Applicant_Info__c a = new Applicant_Info__c();
        a.Intrax_Program__c = 'Internship';
        a.Last_Name__c = 'test';
        a.Street__c = 'test';
        a.City__c = 'test';
        a.State__c = 'CA';
        a.Postal_Code__c = '12345';
        a.Country__c = 'United States';
        a.Home_Phone__c = '12345';
        a.Date_of_Birth__c = date.ValueOf('1968-09-21');
        a.Email__c = 'test@test.com';
        insert a;
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        PageReference flsync = Page.FLAppSyncLeadExists;
        FlowController fc = new FlowController(sc);
        Test.setCurrentPageReference(flsync);
        fc.getFinishPage();
        fc.getFinishPageAppInfo();
        fc.getUserType();           
        test.stopTest();
	}
	
	static testMethod void myUnitTest1() {	
		test.startTest();
		//Record Type
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
		//Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        Applicant_Info__c a = new Applicant_Info__c();
        a.Intrax_Program__c = 'Internship';
        a.Last_Name__c = 'test';
        a.Street__c = 'test';
        a.City__c = 'test';
        a.State__c = 'CA';
        a.Postal_Code__c = '12345';
        a.Country__c = 'United States';
        a.Home_Phone__c = '12345';
        a.Date_of_Birth__c = date.ValueOf('1968-09-21');
        a.Email__c = 'test@test.com';
        a.Account__c = account.Id;
        insert a;
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        PageReference flsync = Page.FLAppSyncLeadExists;
        FlowController fc = new FlowController(sc);
        Test.setCurrentPageReference(flsync);
        fc.getFinishPage();
        fc.getFinishPageAppInfo();
        fc.getUserType();           
        test.stopTest();
	}

}