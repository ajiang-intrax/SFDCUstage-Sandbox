//This component is part of Invoice IT Deployment
global with sharing class InvoiceIT_SchedulerToUpdateOrderCharge implements Schedulable{
	global void execute(SchedulableContext sc) {
		invoiceit_s__Job_Rate_Plan_Charge__c[] charges = [	select id, invoiceit_s__Service_Activation_Date__c, invoiceit_s__Status__c 
															from invoiceit_s__Job_Rate_Plan_Charge__c
															where invoiceit_s__Status__c = 'In Progress'
															and invoiceit_s__Service_Activation_Date__c < :System.today()];
		
		for(invoiceit_s__Job_Rate_Plan_Charge__c charge : charges){
			charge.invoiceit_s__Status__c = 'Completed';	
		}
		
		update charges;
   }
}