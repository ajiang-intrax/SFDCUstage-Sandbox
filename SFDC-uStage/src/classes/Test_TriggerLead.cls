/*
Test Class for Lead Triggers
*/
@isTest
private class Test_TriggerLead {
	//Test Class for Nemo ID update to Applicant Info for Nemo HF
	static testMethod void testUpdateNemoId(){
		//Create an Ayusa HF Lead
		Lead lr = new Lead(LastName ='Test',email='test@test.com',Intrax_Programs__c='Ayusa',
		Intrax_Program_Options__c = 'Ayusa High School',Lead_Type__c='Host Family');
		//Create a HF Application
		Applicant_Info__c air = new Applicant_Info__c(Name='TestApplicant',Type__c='Host Family');
		Person_Info__c pir = new Person_Info__c(Name='TestPerson',Email__c='test@test.com');
		insert lr;
		air.Lead__c = lr.id;
		insert air;
		pir.Applicant_Info__c = air.Id;
		insert pir;
		//Nemo ID update by Bridge - Simulated/Set
		lr.Nemo_Id__c = '12345';
		update lr;
		//Check if Nemo ID is updated
		air = [select id,nemo_id__c from applicant_info__c where lead__c = :lr.Id];
		//System.assert(air.Nemo_Id__c == lr.Nemo_Id__c);
	}
	static testMethod void testUpdateOptOut(){
		Lead lrOptedOutChecked = new Lead(LastName ='Test',email='test1@test.com',Intrax_Programs__c='AuPairCare',
		Lead_Type__c='Host Family',HasOptedOutOfEmail=true);
		Lead lrOptedOutUnChecked = new Lead(LastName ='Test',email='test2@test.com',Intrax_Programs__c='AuPairCare',
		Lead_Type__c='Host Family',HasOptedOutOfEmail=false);
		insert lrOptedOutChecked;
		insert lrOptedOutUnChecked;
		User sysAdmin = [SELECT Id FROM User WHERE UserName = :Constants.SYS_ADMIN];
		System.runAs(sysAdmin){
			lrOptedOutChecked.HasOptedOutOfEmail=false;
			lrOptedOutUnChecked.HasOptedOutOfEmail=true;
			update lrOptedOutChecked;
			update lrOptedOutUnChecked;
		}
		lrOptedOutChecked = [select Id,HasOptedOutOfEmail from Lead where email='test1@test.com' and isConverted = false];
		lrOptedOutUnChecked = [select Id,HasOptedOutOfEmail from Lead where email='test2@test.com' and isConverted = false];			
		//System.assertEquals(lrOptedOutChecked.HasOptedOutOfEmail,true);
		//System.assertEquals(lrOptedOutUnChecked.HasOptedOutOfEmail,true);
		
	}
}