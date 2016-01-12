trigger Trigger_Notification on Notification__c (before update) {
  for(Notification__c record:Trigger.new){
  if(record.Intrax_Program__c =='Work Travel')
  {
   system.debug('Old status:'+Trigger.oldMap.get(record.Id).Status__c+' New Status:'+record.Status__c);
   if((Trigger.oldMap.get(record.Id).Status__c!='Complete' &&  record.Status__c == 'Complete') || 
      (Trigger.oldMap.get(record.Id).Status__c!='Confirmed'&& Trigger.oldMap.get(record.Id).Status__c !='Complete' &&  record.Status__c == 'Confirmed')) {            
          record.Completed_date__c=date.today();       
       }
   }        

  }
   
}