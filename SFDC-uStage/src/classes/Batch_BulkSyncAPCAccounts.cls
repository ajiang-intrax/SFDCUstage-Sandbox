global class Batch_BulkSyncAPCAccounts implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable {
global final String query;
global final String context;
global final String contextText;
//global List<Intacct__c> intacctList;
global List<Account> accountList;
	global Batch_BulkSyncAPCAccounts (String q){
		query = q;
        accountList= new List<Account>();
	}

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		System.debug('context---->'+context);
		System.debug('scope---->'+scope);
       
       accountList = scope;
       IntAcctOppSyncHelper.updateAcctList =new List<Account>();
       IntAcctOppSyncHelper.insertIntacctLstInner= new List<Intacct__c>();
       System.debug('before updateAcctList' + IntAcctOppSyncHelper.updateAcctList);
       System.debug('before insertIntacctLstInner' + IntAcctOppSyncHelper.insertIntacctLstInner);
       System.debug('Account List is : ' + accountList);
       for(Account act : accountList)
       {
        System.debug('calling bulkSyncAccountToCustomer for account ' + act.Id);
		IntAcctOppSyncHelper.bulkSyncAccountToCustomer(act);           
       }
       System.debug('after updateAcctList' + IntAcctOppSyncHelper.updateAcctList);
       System.debug('after insertIntacctLstInner' + IntAcctOppSyncHelper.insertIntacctLstInner);
       
       insert IntAcctOppSyncHelper.insertIntacctLstInner;
       update IntAcctOppSyncHelper.updateAcctList;
              
    }
    
    global void execute(SchedulableContext ctx) {
   	   Database.executeBatch(this);
    }
	
	global void finish(Database.BatchableContext BC){
	   
	}
}