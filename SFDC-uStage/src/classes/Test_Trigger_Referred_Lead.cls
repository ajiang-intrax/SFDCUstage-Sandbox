/*
  Referred_Lead__c Trigger Test Class
  Methods:
	 		testAccountID()--Verifies Participant-referred HC Lead instances are correctly associated with
							 the correct participant's PersonAccount instance via the Referred_Lead__c instance
							 lookup fields.  
 */
@isTest
private class Test_Trigger_Referred_Lead {

    static testMethod void testAccountID() {
        // Setup:  New Account for Participant (PersonAccount)

        // First get Lead Host Company Record Type ID so we can use it throughout the TCs
        RecordType rtHC = [SELECT id FROM RecordType WHERE DeveloperName = 'Host_Company' and SobjectType = 'Lead' ]; 

	    // Create new Particpant Person Account that we'll link leads and referred lead instances to       
        Account a1 = new Account(
            FirstName = 'One', LastName='Participant1', PersonEmail = 'testapt1@test.com',
            Type = 'Participant', Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'WEST',
            Intrax_Region__c = 'United States', OwnerId = UserInfo.getUserId()
            );
        insert a1;
        Account a1r = [SELECT ID, Intrax_Id__c, PersonEmail, IsPersonAccount, Type FROM Account WHERE Id = :a1.Id];  
        system.assertEquals(a1r.PersonEmail, 'testapt1@test.com');
        system.assertEquals(a1r.IsPersonAccount, true);  
        system.assertEquals(a1r.Type, 'Participant'); 
        
        // Create second Account for negative test case
        Account a2 = new Account(
            FirstName = 'Two', LastName='Participant2', PersonEmail = 'testapt2@test.com',
            Type = 'Participant', Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'WEST',
            Intrax_Region__c = 'United States', OwnerId = UserInfo.getUserId()
            );
        insert a2;
        Account a2r = [SELECT ID, Intrax_Id__c, PersonEmail, IsPersonAccount, Type FROM Account WHERE Id = :a2.Id];  
        system.assertEquals(a2r.PersonEmail, 'testapt2@test.com');
        system.assertEquals(a2r.IsPersonAccount, true);  
        system.assertEquals(a2r.Type, 'Participant'); 

        // Create Lead to link with the Referred Lead instance.        
        Lead leHC1 = new Lead(
            FirstName = 'Larry', LastName = 'Ellison', Email = 'larry@oracle.com',
            Lead_Type__c = 'Host Company', Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'WEST',
            Intrax_Region__c = 'United States', OwnerId = UserInfo.getUserId(),
            Related_To_Id__c = a1r.Intrax_Id__c, Company = 'OracleHC1'
        );  
            
        insert leHC1;  
        Lead leHC1r = [SELECT Id, Company, Related_To_Id__c, Lead_Type__c FROM Lead WHERE Company = 'OracleHC1'];
        system.assertEquals(leHC1r.Related_To_Id__c, a1r.Intrax_Id__c); 
        system.assertEquals(leHC1r.Company, 'OracleHC1');
        system.assertEquals(leHC1r.Lead_Type__c, 'Host Company');

        // Test Case 1:  Expect Positive Case - Confirming WEST HC to link to existing PT 
        Referred_Lead__c rl1 = new Referred_Lead__c(
            Lead__c = leHC1r.Id
        );

        insert rl1;
        Referred_Lead__c rl1r = [SELECT Id, Account__c, Lead__c, Related_To_Id__c FROM Referred_Lead__c WHERE Id = :rl1.Id];
        system.assertEquals(rl1r.Related_To_Id__c, a1r.Intrax_Id__c); 
        system.assertEquals(rl1r.Lead__c, leHC1r.id);
        system.assertEquals(rl1r.Account__c, a1r.Id);
        
        // Test Case 2:  Negative Case - Bad Intrax ID on Lead
        leHC1r.Related_To_Id__c = 'sadf23098df';
        update leHC1r;
        Referred_Lead__c rl2 = new Referred_Lead__c(
            Lead__c = leHC1r.Id
        );
        insert rl2;
        Referred_Lead__c rl2r = [SELECT Id, Account__c, Lead__c, Related_To_Id__c FROM Referred_Lead__c WHERE Id = :rl2.Id];
        system.assertEquals(rl2r.Related_To_Id__c, 'sadf23098df'); 
        system.assertEquals(rl2r.Lead__c, leHC1r.id);
        system.assertEquals(rl2r.Account__c, null); 
        leHC1r.Related_To_Id__c = a1r.Intrax_Id__c;
        update leHC1r;
        
        //Test Case 3: Negative Case - Referred Lead Account already set
        Referred_Lead__c rl3 = new Referred_Lead__c(
            Lead__c = leHC1r.Id, Account__c = a2r.Id
        );
        insert rl3;
        Referred_Lead__c rl3r = [SELECT Id, Account__c, Lead__c, Related_To_Id__c FROM Referred_Lead__c WHERE Id = :rl3.Id];
        system.assertEquals(rl3r.Related_To_Id__c, a1r.Intrax_Id__c); 
        system.assertEquals(rl3r.Lead__c, leHC1r.id);
        system.assertEquals(rl3r.Account__c, a2r.Id);  
       
        //Test Case 4: Negative Case - No Intrax Id
        leHC1r.Related_To_Id__c = null;
        update leHC1r;
        Referred_Lead__c rl4 = new Referred_Lead__c(
            Lead__c = leHC1r.Id
        );
        insert rl4;
        Referred_Lead__c rl4r = [SELECT Id, Account__c, Lead__c, Related_To_Id__c FROM Referred_Lead__c WHERE Id = :rl4.Id];
        system.assertEquals(rl4r.Related_To_Id__c, null); 
        system.assertEquals(rl4r.Lead__c, leHC1r.id);
        system.assertEquals(rl4r.Account__c, null);  
    }
}