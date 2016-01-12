trigger Trigger_DSStatus on dsfs__DocuSign_Status__c (before Insert) {
 if(Trigger.isBefore) {
    
    //Chekc for the event type
    if(Trigger.isInsert) {
      
      //call helper class method to execute the logic to update the related opportunity and match records
    system.debug('****Trigger.new******'+Trigger.new);
      DSStatusTriggerHelper.updateApplicantInfoFk(Trigger.new);
      }
      }

}