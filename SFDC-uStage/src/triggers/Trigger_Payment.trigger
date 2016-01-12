trigger Trigger_Payment on Payment__c (after insert) {
    /*if(Trigger.isAfter) 
    {   
        if(trigger.isInsert)
        {
            for(Payment__c payment :trigger.new)
            {
                if(payment.Account_Name__c != null){
                    System.debug('ENTERED PAYMENT TRIGGER---'+payment.Sucess__c);
                    //Notification_Generator.callAPCNotifications(null, payment);//old,new,
                }
            }
        }
    }
    */
}