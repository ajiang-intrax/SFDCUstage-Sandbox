//This component is part of Invoice IT Deployment
public with sharing class ClassAfterOnOpportunityLineItem {
	public voId handleAfterInsertOnOpportunityLineItem(map<Id,OpportunityLineItem> newMap) {

		set<Id> pricebookEntryIds = new set<Id>();
        
        for(OpportunityLineItem newOppLineItem : newMap.values()) {
            pricebookEntryIds.add(newOppLineItem.PricebookEntryId);
        }
         
        list<OpportunityLineItem> opportunityLineItemsToUpdate = new list<OpportunityLineItem>();
        
        map<Id, PricebookEntry> map_PricebookEntryId_PricebookEntry = new map<Id, PricebookEntry>([	SELECT Product2.Payment_Plan__c
        																	FROM PricebookEntry 
        																	WHERE Id IN: pricebookEntryIds]);

		for(OpportunityLineItem opportunityLineItem : newMap.values()) {
			OpportunityLineItem updateOpportunityLineItem = new OpportunityLineItem (Id = opportunityLineItem.Id);                
                
			if(map_PricebookEntryId_PricebookEntry.ContainsKey(opportunityLineItem.PricebookEntryId)){
				updateOpportunityLineItem.Payment_Plan__c = map_PricebookEntryId_PricebookEntry.get(opportunityLineItem.PricebookEntryId).Product2.Payment_Plan__c;    
			}
			opportunityLineItemsToUpdate.add(updateOpportunityLineItem);
		}
		
		
		update opportunityLineItemsToUpdate;
	}
      
 	public voId handleBeforeUpdateOnOpportunityLineItem(map<Id,OpportunityLineItem> oldMap, map<Id,OpportunityLineItem> newMap) {
 		list<invoiceit_s__Job_Rate_Plan_Charge__c> chargesToUpdate = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
 		set<Id> paymentPlanIds = new set<Id>();
 		list<OpportunityLineItem> opportunityLinesToProcessPaymentPlans = new list<OpportunityLineItem>();
 		list<OpportunityLineItem> opportunityLinesToProcessDates = new list<OpportunityLineItem>();
 		
 		//Get a list of payment plans to query for
 		for(OpportunityLineItem newOpportunityLineItem : newMap.values()){
            OpportunityLineItem oldOpportunityLineItem = oldMap.get(newOpportunityLineItem.Id);
            
            if(	newOpportunityLineItem.Payment_Plan__c != null
            	&& newOpportunityLineItem.Payment_Plan__c != oldOpportunityLineItem.Payment_Plan__c)
            {
            	if(!paymentPlanIds.contains(newOpportunityLineItem.Payment_Plan__c)){
            		paymentPlanIds.add(newOpportunityLineItem.Payment_Plan__c);
            	}
            	
            	opportunityLinesToProcessPaymentPlans.add(newOpportunityLineItem);
            }
            
            if(	(oldOpportunityLineItem.Trigger_Date_1__c != newOpportunityLineItem.Trigger_Date_1__c)
            	||
            	(oldOpportunityLineItem.Trigger_Date_2__c != newOpportunityLineItem.Trigger_Date_2__c)
            	||
            	(oldOpportunityLineItem.Trigger_Date_3__c != newOpportunityLineItem.Trigger_Date_3__c))
            {
            	opportunityLinesToProcessDates.add(newOpportunityLineItem);	
            }
 		}
 		
 		//If the payment plan ids are not empty then query for them
 		//Query the payment plan details for the split
		map<Id,Payment_Plan__c> map_Id_paymentPlan = new map<Id,Payment_Plan__c>([select Percentage_1__c, Percentage_2__c,Percentage_3__c from Payment_Plan__c where id = :paymentPlanIds]);

		//Now populate the opportunity line items with the payment plan related data
		for(OpportunityLineItem newOpportunityLineItem : opportunityLinesToProcessPaymentPlans){
            OpportunityLineItem oldOpportunityLineItem = oldMap.get(newOpportunityLineItem.Id);
            
            //Reset the payment plan proportions if they have changed
            if(	newOpportunityLineItem.Payment_Plan__c != null
            	&& newOpportunityLineItem.Payment_Plan__c != oldOpportunityLineItem.Payment_Plan__c)
            {
            	Payment_Plan__c paymentPlan = map_Id_paymentPlan.get(newOpportunityLineItem.Payment_Plan__c);
            	
            	newOpportunityLineItem.Percentage_1__c = paymentPlan.Percentage_1__c;
            	newOpportunityLineItem.Percentage_2__c = paymentPlan.Percentage_2__c;
            	newOpportunityLineItem.Percentage_3__c = paymentPlan.Percentage_3__c;
            	newOpportunityLineItem.Trigger_Date_1__c = null;
            	newOpportunityLineItem.Trigger_Date_2__c = null;
            	newOpportunityLineItem.Trigger_Date_3__c = null;
            }
 		}
 		
 		list<Id> listOfChargeIds = new list<Id>();
 		
 		for(OpportunityLineItem newOpportunityLineItem : opportunityLinesToProcessDates){
 			OpportunityLineItem oldOpportunityLineItem = oldMap.get(newOpportunityLineItem.Id);
 			
 			if(newOpportunityLineItem.Order_Rate_Plan_Charge_Id_1__c != null && oldOpportunityLineItem.Trigger_Date_1__c != newOpportunityLineItem.Trigger_Date_1__c){
            	invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(id = newOpportunityLineItem.Order_Rate_Plan_Charge_Id_1__c);
            	charge.invoiceit_s__Service_Activation_Date__c = newOpportunityLineItem.Trigger_Date_1__c;
            	chargesToUpdate.add(charge);
            	listOfChargeIds.add(charge.Id);
            }
            
            if(newOpportunityLineItem.Order_Rate_Plan_Charge_Id_2__c != null && oldOpportunityLineItem.Trigger_Date_2__c != newOpportunityLineItem.Trigger_Date_2__c){
            	invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(id = newOpportunityLineItem.Order_Rate_Plan_Charge_Id_2__c);
            	charge.invoiceit_s__Service_Activation_Date__c = newOpportunityLineItem.Trigger_Date_2__c;
            	chargesToUpdate.add(charge);
            	listOfChargeIds.add(charge.Id);
            }
            
            if(newOpportunityLineItem.Order_Rate_Plan_Charge_Id_3__c != null && oldOpportunityLineItem.Trigger_Date_3__c != newOpportunityLineItem.Trigger_Date_3__c){
            	invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(id = newOpportunityLineItem.Order_Rate_Plan_Charge_Id_3__c);
            	charge.invoiceit_s__Service_Activation_Date__c = newOpportunityLineItem.Trigger_Date_3__c;
            	chargesToUpdate.add(charge);
            	listOfChargeIds.add(charge.Id);
            }
 		}
 		
 		//To ensure the first invoice for this order is created immediately we would have to do this
        //See if there is already an invoice for this order (using roll up summary field: No of Invoices)
        //If it is 0 then right after the charges are updated make the order field : Create Invoice Automatically? true
        
        system.debug('chargesToUpdate ='+chargesToUpdate);
        if(chargesToUpdate.size() > 0){
        	update chargesToUpdate;
        }
        //Get the order id from the order charges and we need to query for this now
        
        list<AggregateResult> results = [SELECT invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__c orderId
        							FROM invoiceit_s__Job_Rate_Plan_Charge__c
        							WHERE invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.No_of_Invoice_Lines__c = 0 
        							AND id IN :listOfChargeIds
        							GROUP BY invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__c];
		
		list<invoiceit_s__Job__c> ordersToUpdate = new list<invoiceit_s__Job__c>();
		
		for(AggregateResult result : results){
			Id id = (Id)result.get('orderId');
			invoiceit_s__Job__c job = new invoiceit_s__Job__c(Id = id, invoiceit_s__Create_Invoice_Automatically__c = true);
			ordersToUpdate.add(job);
		}
		
		//Update the orders
		if(ordersToUpdate.size() > 0){
			update ordersToUpdate;
		}
 	}     
}