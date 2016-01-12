@isTest
private class Test_Applicant_Country_List {
	
	
static testMethod void testApplicantCountryList() {
	
		test.startTest();
		RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Contracted',PersonBirthdate = date.newInstance(1998, 01, 01),
                                                    RecordTypeId = participantAccountRecordType.Id, Citizenship__pc = 'United States',
                                                    Intrax_Programs__c = 'Ayusa', type='Participant',
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com', Legal_Residence__pc = 'United States');
        insert participantAccount;
		
        Engagement__c e = new Engagement__c();
        e.Name='TestName';
        e.Intrax_Program__c='Ayusa';
        e.Intrax_program_options__c='Ayusa High School';
        e.Placement_Status__c='Not Placed';
        e.Status__c='Processing';
        e.Account_Id__c = participantAccount.Id;
        insert e;
                
        
        Applicant_Info__c ai = new Applicant_Info__c();
		ai.Placement_Pending__c = 'Yes';
		ai.Type__c = 'Participant';
        ai.Application_Stage__c= 'Accepted';
        ai.Intrax_Program_Options__c = 'Ayusa High School';
        ai.Engagement__c=e.Id;
		insert ai;
		
        Person_Info__c p = new Person_Info__c();
        p.Country_of_Residence__c = 'Armenia';
        p.Role__c = 'Student';
        p.Primary_Applicant__c = true;
        p.Applicant_Info__c = ai.Id;
        p.Applicant_Info__r = ai;
                
        
        Person_Info__c p1 = new Person_Info__c();
        p1.Country_of_Residence__c = 'Armenia';
        p1.Role__c = 'Student';
        p1.Primary_Applicant__c = true;
        p1.Applicant_Info__c = ai.Id;
        p1.Applicant_Info__r = ai;
                
        
        insert p;
        insert p1;
        
        Applicant_Country_List.doGet();        
        Applicant_Country_List.doNothing();
        
        
        test.stopTest();
}
        
}