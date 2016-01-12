trigger Trigger_on_Payment on Payment__c (after insert) 
{
 if(trigger.isAfter)
  {
   if(trigger.isInsert)
   {
    for (Payment__c pay : Trigger.new) {
     if(pay.Account_Name__c != null && pay.Sucess__c == true)
     {
        /*system.debug('payment' + pay);
        if(!Test.isRunningTest())
        IntAcctOppSyncHelper.CreateAccountReceivables(pay.Opportunity_Name__c,pay.Account_Name__c,pay.Id);*/
      }
     }
    }
  }
 }