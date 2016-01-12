trigger Trigger_Referred_Lead on Referred_Lead__c (before insert) {
  for (Referred_Lead__c rl: trigger.new){
    //Link the Referred Lead instance to an Account Parent
    if(String.isBlank(rl.Account__c) && String.isNotBlank(rl.Related_To_Id__c)){
        List<Account> accts = [SELECT id FROM Account 
                               WHERE Intrax_Id__c = :rl.Related_to_Id__c 
                               ORDER BY CreatedDate 
                               DESC Limit 1];
        for (Account a : accts) {
        	rl.Account__c = a.id;
        }
    }
  }
}