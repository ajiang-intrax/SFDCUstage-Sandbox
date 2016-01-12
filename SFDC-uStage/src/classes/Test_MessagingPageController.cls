@isTest(SeeAllData=true)
public class Test_MessagingPageController {
	static testMethod void myUnitTest() {
		
	MessagingPageController mpc = new MessagingPageController();
	test.startTest();
	List<String> sites = new List<String>();
	sites.add('test');
	
	RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
	
	Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
    insert account;
        
	Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com', PTR_Portal_intrax_program_default__c='Ayusa');
    insert contact;
	
	Site_Message__c SM = new Site_Message__c();
	SM.Title__c='Test';
	SM.Intrax_Program__c = 'Ayusa';
	SM.sites__c = 'Intrax_Partner_Portal';
	SM.Display_Start_Date_Time__c = System.Now();
	SM.Type__c = 'System Message';
	insert SM;
	
	Site_Message__c SM1 = new Site_Message__c();
	SM1.Title__c='Test';
	SM1.Intrax_Program__c = 'Ayusa';
	SM1.sites__c = 'Intrax_Partner_Portal';
	SM1.Display_Start_Date_Time__c = System.Now();
	SM1.Type__c = 'Announcement';
	SM1.Target_User_Type__c='Partner';
	SM1.Promote_To_Front__c = FALSE;
	insert SM1;
	
	Site_Message__c SM12 = new Site_Message__c();
	SM12.Title__c='Test';
	SM12.Intrax_Program__c = 'Ayusa';
	SM12.sites__c = 'Intrax_Partner_Portal';
	SM12.Display_Start_Date_Time__c = System.Now();
	SM12.Type__c = 'Announcement';
	SM12.Target_User_Type__c='Partner';
	SM12.Promote_To_Front__c = TRUE;
	insert SM12;
	
	User partner = [SELECT Id,Intrax_Id__c, Name, User_Interests__c,ContactId, Contact.Intrax_Programs__c From User WHERE Intrax_Id__c != null and Type__c = 'Partner' AND Profile.Name = 'OCPM Agent Portal' AND ContactId!= NULL AND Contact.Intrax_Programs__c != NULL LIMIT 1];
	
	system.runAs(partner){
		MessagingPageController.checkmsg();	
		MessagingPageController.checkAnnouncement();
		MessagingPageController.checkPriorityAnnouncement();
		MessagingPageController.checkAnnouncement_Top3();
		MessagingPageController.checkPriorAnnouncement_Top3();
		MessagingPageController.matchAndReplace('abc','test','test123');
		mpc.processSOQLQueryString('SELECT ID FROM NULL AND');
	}
	test.stopTest();
	}
}