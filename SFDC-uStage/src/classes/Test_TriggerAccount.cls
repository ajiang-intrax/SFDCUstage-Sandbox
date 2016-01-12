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
 
 /*
 This class is no longer needed since we are testing all the methods in the IUtilities class. 
 */
@isTest(seeAllData = true)
private class Test_TriggerAccount {
    
    /*static testMethod void sAccountAction_OneRecord(){
        // Test 1.1: Inserting one PT Account
        Account ac = new Account(
                FirstName = 'Test', LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
                OwnerId = UserInfo.getUserId()
                );
        insert ac;
        
        // Checking out that the sAccount has been correctly inserted
        sAccount__c sa = [SELECT s.Id, s.Name, s.Account_Name__c FROM sAccount__c s WHERE s.Account_Name__c =: ac.Id];
        system.assertEquals(sa.Account_Name__c, ac.Id);
        
        //Test 1.2: Updating the previously inserted account
        ac.FirstName = 'Test_Update';
        update ac;
        // Checking out that the sAccount has been correctly inserted
        sAccount__c sa_update = [SELECT s.Id, s.Name, s.Account_Name__c, s.First_Name__c FROM sAccount__c s WHERE s.Account_Name__c =: ac.Id];
        system.assertEquals(sa_update.First_Name__c, ac.FirstName);
        
        // Test 1.3: Inserting one HC Account
        Account achc = new Account(
                Name = 'Test Trigger HC',
                type = 'Host Company', Intrax_Programs__c = 'Internship', status__c = 'Contracted',
                OwnerId = UserInfo.getUserId()
                );
        insert achc;
        
        // Checking out that the sAccount has been correctly inserted
        sAccount__c sahc = [SELECT s.Id, s.Name, s.Account_Name__c FROM sAccount__c s WHERE s.Account_Name__c =: achc.Id];
        system.assertEquals(sahc.Account_Name__c, achc.Id);
        
        //Test 1.4: Updating the previously inserted account
        achc.Name = 'Test_UpdateHC';
        update ac;
        // Checking out that the sAccount has been correctly inserted
        sAccount__c sa_updatehc = [SELECT s.Id, s.Name, s.Account_Name__c, s.First_Name__c FROM sAccount__c s WHERE s.Account_Name__c =: achc.Id];
        system.assertEquals(sa_updatehc.First_Name__c, achc.FirstName);  
    }*/
    
    /*static testMethod void sAccountActionUpdate_Bulk(){
        // Test 2.1: Inserting multiple Accounts at the same time
        list<Account> acc = new list<Account>();
        integer recordsToInsert = 3;
        for(integer i = 0 ; i < recordsToInsert; i++){
            Account a = new Account(
                FirstName = 'Test_'+i, LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
                OwnerId = UserInfo.getUserId()
            );
            acc.add(a);
        }
        insert acc;
        
        // Test 2.2: Updating the previously inserted Accounts
        // now, let´s update all the recently inserted records. 
        system.debug('***** now, let´s update all the recently inserted records');
        list<Account> ac_update = [SELECT Id, FirstName FROM Account WHERE Id IN: acc];
        for(Account a: ac_update){
            a.FirstName = a.FirstName + '_Updated';
            system.debug('***** NEW NAME: ' +a.FirstName);
        }
        update ac_update;
        // Checking out that the sAccount has been correctly inserted
        for(Account a: ac_update){
            sAccount__c sa = [SELECT s.Id, s.Name, s.Account_Name__c FROM sAccount__c s WHERE s.Account_Name__c =: a.Id];       
            system.assertEquals(sa.Account_Name__c, a.Id);  
        }    
    }
          
    static testMethod void sAccountActionUpdate_BulkMixed(){
        // Test 3.1: Inserting multiple Accounts to insert/update at the same time -- If want to test Governor Limits, change recordsToInsert = 201
        list<Account> acc = new list<Account>();
        integer recordsToInsert = 3;
        for(integer i = 0 ; i < recordsToInsert; i++){
            Account a = new Account(
                FirstName = 'Test_'+i, LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
                OwnerId = UserInfo.getUserId()
            );
            acc.add(a);
        }
        insert acc;
        
        // now, let´s update all the recently inserted records. 
        system.debug('***** now, let´s update all the recently inserted records');
        list<Account> ac_update = [SELECT Id, FirstName FROM Account WHERE Id IN: acc];
        for(Account a: ac_update){
            a.FirstName = a.FirstName + '_Updated';
            system.debug('***** NEW NAME: ' +a.FirstName);
        }
        
        // Creating and account that should be inserted instead of updated
        system.debug('***** Creating and account that should be inserted instead of updated');
        Account ac = new Account(
                FirstName = 'Test', LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
                type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
                OwnerId = UserInfo.getUserId()
                );
        // To test this, we should: insert the account --> Delete the associated sAccount created --> Try to update the sAccount.
        insert ac;
        // Checking out that the sAccount has been correctly inserted
        sAccount__c sa = [SELECT s.Id, s.Name, s.Account_Name__c FROM sAccount__c s WHERE s.Account_Name__c =: ac.Id];
        system.assertEquals(sa.Account_Name__c, ac.Id);
        system.debug('***** Deleting the sAccount...');
        delete sa;
        
        Account ac_inserted = [SELECT Id, FirstName FROM Account WHERE FirstName = 'Test'];
        ac_inserted.FirstName = ac.FirstName + '_Updated';
        ac_update.add(ac_inserted);
        // Now, trying to update...
        system.debug('***** Updating the record that must be inserted');
        update ac_update;
        
        for(Account a: ac_update){
            system.assertEquals(a.FirstName.contains('_Updated'), true);
        }   
    }*/
    
    static testMethod void testUpdateOptOut(){
        Account arOptedOutChecked = new Account(LastName ='Test',PersonEmail='test1@test.com',Intrax_Programs__c='AuPairCare',
        Type='Host Family',PersonHasOptedOutOfEmail=true);
        Account arOptedOutUnChecked = new Account(LastName ='Test',PersonEmail='test2@test.com',Intrax_Programs__c='AuPairCare',
        Type='Host Family',PersonHasOptedOutOfEmail=false);
        insert arOptedOutChecked;
        insert arOptedOutUnChecked;
        User sysAdmin = [SELECT Id FROM User WHERE UserName = :Constants.SYS_ADMIN];
        System.runAs(sysAdmin){
            arOptedOutChecked.PersonHasOptedOutOfEmail=false;
            arOptedOutUnChecked.PersonHasOptedOutOfEmail=true;
            update arOptedOutChecked;
            update arOptedOutUnChecked;
        }
        arOptedOutChecked = [select Id,PersonHasOptedOutOfEmail from Account where PersonEmail='test1@test.com'];
        arOptedOutUnChecked = [select Id,PersonHasOptedOutOfEmail from Account where PersonEmail='test2@test.com'limit 1];         
        System.assertEquals(arOptedOutChecked.PersonHasOptedOutOfEmail,true);
        System.assertEquals(arOptedOutUnChecked.PersonHasOptedOutOfEmail,true);
        
    }   
}