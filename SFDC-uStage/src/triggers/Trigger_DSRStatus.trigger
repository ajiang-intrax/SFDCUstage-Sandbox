trigger Trigger_DSRStatus on dsfs__DocuSign_Recipient_Status__c (before Insert, after Update) {
 if(Trigger.isBefore) {
    
    //Chekc for the event type
    if(Trigger.isInsert) {
      
      //call helper class method to execute the logic to update the related opportunity and match records
    system.debug('****Trigger.new******'+Trigger.new);
      DSRStatusTriggerHelper.updateApplicantInfoFk(Trigger.new);
      }
      }

 if(Trigger.isAfter) {
    if(Trigger.isUpdate) {
       system.debug('check0');
       //List<dsfs__DocuSign_Recipient_Status__c> DocSignRecStat = new List<dsfs__DocuSign_Recipient_Status__c>();
       DSRStatusTriggerHelper.updateHostAccount(trigger.new);
       DSRStatusTriggerHelper.updateDevelopmentPlan(Trigger.new);
    }
    if(Trigger.isInsert) {
       system.debug('check01');
       DSRStatusTriggerHelper.updateDevelopmentPlan(Trigger.new);
    }
 }
}