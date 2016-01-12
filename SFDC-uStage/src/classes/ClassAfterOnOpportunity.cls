//This class is part of Invoice IT Deployment
public with sharing class ClassAfterOnOpportunity {
    public void handleAfterOnOpportunity(map<Id,Opportunity> newMap,map<Id,Opportunity> oldMap) {
        map<String, invoiceit_s__Configuration__c> mapConfiguration = invoiceit_s__Configuration__c.getAll();
        list<invoiceit_s__Job__c> listOfOrdersToInsert = new list<invoiceit_s__Job__c>();
        list<Id> opportunityIdsForCreateOrder = new list<Id>();
        list<Id> opportunityIdsForPaymentTriggerDates = new list<Id>();
        list<String> currencyCodes = new list<String>();
        map<Id,OpportunityLineItem> map_linesToUpdate = new map<Id,OpportunityLineItem>();
                
        for(Opportunity opportunity : newMap.values()){
            Opportunity opportunityOld = oldMap.get(opportunity.Id);
            //Add the opportunity ids to the listforcreateorder
            if(opportunity.Create_Order__c && opportunity.Create_Order__c !=opportunityOld.Create_Order__c){
                opportunityIdsForCreateOrder.add(opportunity.Id);
                currencyCodes.add(opportunity.CurrencyIsoCode);
            }
            /*
                Run the logic to pass the trigger dates when any of the following field is changed
                Opportunity.CloseDate
                Opportunity.Match_Date__c
                Opportunity.Engagement_Start__c
                Opportunity.Stage
            */
            if( (opportunity.Create_Order__c && opportunity.Create_Order__c != opportunityOld.Create_Order__c)
                || 
                opportunity.StageName != opportunityOld.StageName
                ||
                opportunity.Operation_Stage__c  != opportunityOld.Operation_Stage__c
                || 
                opportunity.CloseDate != opportunityOld.CloseDate
                ||
                opportunity.Match_Date__c != opportunityOld.Match_Date__c
                ||
                opportunity.Engagement_Start__c != opportunityOld.Engagement_Start__c)
            {
                opportunityIdsForPaymentTriggerDates.add(opportunity.Id);
            }
        }
        
        invoiceit_s__Job__c job = new invoiceit_s__Job__c();
        
        //Create order and order products
        if(opportunityIdsForCreateOrder.size() > 0){
            //Put the currencies in the map
            invoiceit_s__Currency__c[] currencies = [select Id,Name from invoiceit_s__Currency__c where Name IN :currencyCodes];
            map<String,Id> map_IsoCode_CurrencyId = new map<String,Id>();
            for(invoiceit_s__Currency__c c : currencies){
                if(!map_IsoCode_CurrencyId.ContainsKey(c.Name)){
                    map_IsoCode_CurrencyId.put(c.Name, c.Id);
                }   
            }
            
            for(Id opportunityId : opportunityIdsForCreateOrder){
                Opportunity opportunity = newMap.get(opportunityId);
                
                job.invoiceit_s__Account__c = opportunity.AccountId;
                job.invoiceit_s__Billing_Contact__c = opportunity.Primary_Contact__c;
                job.invoiceit_s__CurrencyL__c = map_IsoCode_CurrencyId.get(''+opportunity.CurrencyISOCode);  
                job.invoiceit_s__Start_Date__c = system.today();
                job.Opportunity__c = opportunity.Id;
                job.invoiceit_s__Shipping_Contact__c = opportunity.Primary_Contact__c;
                job.Name = opportunity.Name;
                job.Intrax_Region__c = opportunity.Intrax_Region__c;
                system.debug('Intrax region is ='+job.Intrax_Region__c);
                
                //order date is copied to service start when below custom setting is true.
                boolean bAlignStartDateToActivationDate = mapConfiguration.get('USE_SERVICE_START_DATE_FOR_INVOICE').invoiceit_s__Boolean_Value__c;
                if(bAlignStartDateToActivationDate != null && bAlignStartDateToActivationDate) {
                    job.invoiceit_s__Service_Activation_Date__c = job.invoiceit_s__Start_Date__c;
                }
            }
            
            
            list<OpportunityLineItem> opportunityLineItems = [  Select UnitPrice, Trigger_Date_1__c, Trigger_Date_2__c,Trigger_Date_3__c, TotalPrice, ServiceDate, 
                                                            Quantity, PricebookEntry.ProductCode, PricebookEntry.UnitPrice, 
                                                            PricebookEntry.CurrencyIsoCode, PricebookEntry.Name, PricebookEntryId, 
                                                            Percentage_1__c, Percentage_2__c, Percentage_3__c, Payment_Plan__c, OpportunityId, ListPrice, 
                                                            Description, CurrencyIsoCode, PricebookEntry.Product2.Description From OpportunityLineItem
                                                            where OpportunityId = :job.Opportunity__c
                                                            and Order_Rate_Plan_Charge_Id_1__c = null];
        	
        	//We need to check if there are opportunity lineitems present and then insert the job
        	if(!opportunityLineItems.isEmpty()){
        		insert job;
        	}
            list<invoiceit_s__Job_Product__c> listOfOrderProducts = new list<invoiceit_s__Job_Product__c>();
            list<invoiceit_s__Job_Rate_Plan__c> listOfOrderRatePlans = new list<invoiceit_s__Job_Rate_Plan__c>();
            list<invoiceit_s__Job_Rate_Plan_Charge__c> listOfOrderCharges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
            
            for(OpportunityLineItem line : opportunityLineItems){
                
                if(line.Percentage_1__c != null){
                    invoiceit_s__Job_Product__c orderProduct = new invoiceit_s__Job_Product__c();
                    invoiceit_s__Job_Rate_Plan__c orderRatePlan = new invoiceit_s__Job_Rate_Plan__c();
                    invoiceit_s__Job_Rate_Plan_Charge__c orderCharge = new invoiceit_s__Job_Rate_Plan_Charge__c();
                    
                    //Populate the order product
                    orderProduct.Name = line.PricebookEntry.Name;
                    orderProduct.invoiceit_s__Job__c = job.Id;
                    orderProduct.invoiceit_s__Product_Code__c = line.PricebookEntry.ProductCode;
                    orderProduct.CurrencyIsoCode = line.CurrencyIsoCode;
                    orderProduct.Installment__c = 1;
                    listOfOrderProducts.add(orderProduct);
                    
                    //populate the order rate plan
                    orderRatePlan.Name = 'Default';
                    listOfOrderRatePlans.add(orderRatePlan);
                    
                    //populate the order charge
                    orderCharge.invoiceit_s__Price_Format__c = 'Default';
                    orderCharge.invoiceit_s__Unit_Of_Measurement__c = 'Unit';
                    orderCharge.invoiceit_s__Price_Type__c = 'One Time';
                    orderCharge.invoiceit_s__CurrencyL__c = map_IsoCode_CurrencyId.get(''+opportunity.CurrencyISOCode);
                    orderCharge.invoiceit_s__Quantity__c = line.Quantity;                              
                    orderCharge.invoiceit_s__Is_Product_Editable__c = true;
                    orderCharge.invoiceit_s__Product_Charge_Category__c = 'Taxable';
                    orderCharge.Installment__c = 1;
                    orderCharge.Opportunity_Product_Id__c = line.Id;
                    orderCharge.Product_Description__c = line.PricebookEntry.Product2.Description;
                    orderCharge.invoiceit_s__Service_Activation_Date__c = line.Trigger_Date_1__c;
                    
                    //Calculate the values based on the proportionate value
                    Double proportion = line.Percentage_1__c/100;
                    
                    //If there was a second installment mention the split on the charge name
                    if(line.Percentage_2__c != null){
                        orderCharge.Name = line.PricebookEntry.Name + ' - Installment 1';
                    }else{
                        orderCharge.Name = line.PricebookEntry.Name;
                    }
                                            
                    orderCharge.invoiceit_s__Unit_Price__c = proportion * line.UnitPrice;
                    orderCharge.invoiceit_s__Price__c = proportion * line.TotalPrice;
                    
                    listOfOrderCharges.add(orderCharge);
                }
                
                if(line.Percentage_2__c != null){
                    invoiceit_s__Job_Product__c orderProduct = new invoiceit_s__Job_Product__c();
                    invoiceit_s__Job_Rate_Plan__c orderRatePlan = new invoiceit_s__Job_Rate_Plan__c();
                    invoiceit_s__Job_Rate_Plan_Charge__c orderCharge = new invoiceit_s__Job_Rate_Plan_Charge__c();
                    
                    //Populate the order product
                    orderProduct.Name = line.PricebookEntry.Name;
                    orderProduct.invoiceit_s__Job__c = job.Id;
                    orderProduct.invoiceit_s__Product_Code__c = line.PricebookEntry.ProductCode;
                    orderProduct.CurrencyIsoCode = line.CurrencyIsoCode;
                    orderProduct.Installment__c = 2;
                    listOfOrderProducts.add(orderProduct);
                    
                    //populate the order rate plan
                    orderRatePlan.Name = 'Default';
                    listOfOrderRatePlans.add(orderRatePlan);
                    
                    //populate the order charge
                    orderCharge.invoiceit_s__Price_Format__c = 'Default';
                    orderCharge.invoiceit_s__Unit_Of_Measurement__c = 'Unit';
                    orderCharge.invoiceit_s__Price_Type__c = 'One Time';
                    orderCharge.invoiceit_s__CurrencyL__c = map_IsoCode_CurrencyId.get(''+opportunity.CurrencyISOCode);
                    orderCharge.invoiceit_s__Quantity__c = line.Quantity;                              
                    orderCharge.invoiceit_s__Is_Product_Editable__c = true;
                    orderCharge.invoiceit_s__Product_Charge_Category__c = 'Taxable';
                    orderCharge.Installment__c = 2;
                    orderCharge.Opportunity_Product_Id__c = line.Id;
                    orderCharge.Product_Description__c = line.PricebookEntry.Product2.Description;
                    orderCharge.invoiceit_s__Service_Activation_Date__c = line.Trigger_Date_2__c;
                    
                    //Calculate the values based on the proportionate value
                    Double proportion = line.Percentage_2__c/100;
                    
                    orderCharge.Name = line.PricebookEntry.Name + ' - Installment 2';                       
                    orderCharge.invoiceit_s__Unit_Price__c = proportion * line.UnitPrice;
                    orderCharge.invoiceit_s__Price__c = proportion * line.TotalPrice;
                    
                    listOfOrderCharges.add(orderCharge);
                }
                
                if(line.Percentage_3__c != null){
                    invoiceit_s__Job_Product__c orderProduct = new invoiceit_s__Job_Product__c();
                    invoiceit_s__Job_Rate_Plan__c orderRatePlan = new invoiceit_s__Job_Rate_Plan__c();
                    invoiceit_s__Job_Rate_Plan_Charge__c orderCharge = new invoiceit_s__Job_Rate_Plan_Charge__c();
                    
                    //Populate the order product
                    orderProduct.Name = line.PricebookEntry.Name;
                    orderProduct.invoiceit_s__Job__c = job.Id;
                    orderProduct.invoiceit_s__Product_Code__c = line.PricebookEntry.ProductCode;
                    orderProduct.CurrencyIsoCode = line.CurrencyIsoCode;
                    orderProduct.Installment__c = 3;
                    listOfOrderProducts.add(orderProduct);
                    
                    //populate the order rate plan
                    orderRatePlan.Name = 'Default';
                    listOfOrderRatePlans.add(orderRatePlan);
                    
                    //populate the order charge
                    orderCharge.invoiceit_s__Price_Format__c = 'Default';
                    orderCharge.invoiceit_s__Unit_Of_Measurement__c = 'Unit';
                    orderCharge.invoiceit_s__Price_Type__c = 'One Time';
                    orderCharge.invoiceit_s__CurrencyL__c = map_IsoCode_CurrencyId.get(''+opportunity.CurrencyISOCode);
                    orderCharge.invoiceit_s__Quantity__c = line.Quantity;                              
                    orderCharge.invoiceit_s__Is_Product_Editable__c = true;
                    orderCharge.invoiceit_s__Product_Charge_Category__c = 'Taxable';
                    orderCharge.Installment__c = 3;
                    orderCharge.Opportunity_Product_Id__c = line.Id;
                    orderCharge.Product_Description__c = line.PricebookEntry.Product2.Description;
                    orderCharge.invoiceit_s__Service_Activation_Date__c = line.Trigger_Date_3__c;
                    
                    //Calculate the values based on the proportionate value
                    Double proportion = line.Percentage_3__c/100;
                    
                    orderCharge.Name = line.PricebookEntry.Name + ' - Installment 3';                       
                    orderCharge.invoiceit_s__Unit_Price__c = proportion * line.UnitPrice;
                    orderCharge.invoiceit_s__Price__c = proportion * line.TotalPrice;
                    
                    listOfOrderCharges.add(orderCharge);
                }
            }
            
            system.debug('listOfOrderProducts Value ='+listOfOrderProducts);
            
            insert listOfOrderProducts;
            
            for(Integer i = 0; i < listOfOrderProducts.size(); i++){
                listOfOrderRatePlans[i].invoiceit_s__Job_Product__c = listOfOrderProducts[i].Id;
            }
            
            insert listOfOrderRatePlans;
            
            for(Integer i = 0; i < listOfOrderRatePlans.size(); i++){
                listOfOrderCharges[i].invoiceit_s__Job_Rate_Plan__c = listOfOrderRatePlans[i].Id;
            }
            
            insert listOfOrderCharges;
            
            for(invoiceit_s__Job_Rate_Plan_Charge__c charge : listOfOrderCharges){
                OpportunityLineItem oli;
                if(!map_linesToUpdate.containsKey(charge.Opportunity_Product_Id__c)){
                    oli = new OpportunityLineItem(Id = charge.Opportunity_Product_Id__c);
                    map_linesToUpdate.put(charge.Opportunity_Product_Id__c,oli);
                }else{
                    oli = map_linesToUpdate.get(charge.Opportunity_Product_Id__c);
                }
                if(charge.Installment__c == 1){
                    oli.Order_Rate_Plan_Charge_Id_1__c = charge.Id;
                }else if(charge.Installment__c == 2){
                    oli.Order_Rate_Plan_Charge_Id_2__c = charge.Id;
                }else if(charge.Installment__c == 3){
                    oli.Order_Rate_Plan_Charge_Id_3__c = charge.Id;
                }
            }
            
            update map_linesToUpdate.values();
            
            job.invoiceit_s__Create_Invoice_Automatically__c = true;
            job.invoiceit_s__Recalculate__c = true; 
            
            if(job.Id != null){
				update job;            	
            }
        }
        
        //If the list of opportunities for the payment trigger is > 0 then query all the payment plans for the opportunitylineitems
        //to verify if there are any of them that match the criteria queried for
        system.debug('opportunityIdsForPaymentTriggerDates ='+opportunityIdsForPaymentTriggerDates);
        if(opportunityIdsForPaymentTriggerDates.size() > 0){
            map<Id,OpportunityLineItem> map_linesToUpdateForDates = new map<Id,OpportunityLineItem>();
            //Query the payment plan related information for the opportunitylineitems belonging to these opportunities
            OpportunityLineItem[] lines = [ Select OpportunityId, Percentage_1__c, Percentage_2__c, Percentage_3__c, Trigger_Date_1__c, Trigger_Date_2__c, Trigger_Date_3__c, 
                                            Payment_Plan__r.Stage_3__c, Payment_Plan__r.Percentage_3__c, Payment_Plan__r.No_of_days_3__c, Payment_Plan__r.Date_Field_2__c, 
                                            Payment_Plan__r.Stage_1__c, Payment_Plan__r.Percentage_2__c, Payment_Plan__r.Stage_2__c, Payment_Plan__r.No_of_days_2__c, 
                                            Payment_Plan__r.Date_Field_3__c, Payment_Plan__r.No_of_days_1__c, Payment_Plan__r.Date_Field_1__c, Payment_Plan__r.Percentage_1__c, 
                                            Payment_Plan__r.Operation_Stage_1__c, Payment_Plan__r.Operation_Stage_2__c, Payment_Plan__r.Operation_Stage_3__c, Payment_Plan__c 
                                            From OpportunityLineItem
                                            where OpportunityId IN : opportunityIdsForPaymentTriggerDates
                                            and Payment_Plan__c != null];
                                            //and (Trigger_Date_1__c = null or Trigger_Date_2__c = null or Trigger_Date_3__c = null)];
            system.debug('lines ='+lines);
            
            for(OpportunityLineItem line : lines){
                Opportunity opportunity = newMap.get(line.OpportunityId);
                SObject sobj = opportunity;
                
                String datefield1 = line.Payment_Plan__r.Date_Field_1__c;
                String datefield2 = line.Payment_Plan__r.Date_Field_2__c;
                String datefield3 = line.Payment_Plan__r.Date_Field_3__c;
                
                String stage1 = line.Payment_Plan__r.Stage_1__c;
                String stage2 = line.Payment_Plan__r.Stage_2__c;
                String stage3 = line.Payment_Plan__r.Stage_3__c;
                
                String operationStage1 = line.Payment_Plan__r.Operation_Stage_1__c;
                String operationStage2 = line.Payment_Plan__r.Operation_Stage_2__c;
                String operationStage3 = line.Payment_Plan__r.Operation_Stage_3__c;
                
                Decimal noofdays1 = line.Payment_Plan__r.No_of_days_1__c == null ? 0 : line.Payment_Plan__r.No_of_days_1__c;
                Decimal noofdays2 = line.Payment_Plan__r.No_of_days_2__c == null ? 0 : line.Payment_Plan__r.No_of_days_2__c;
                Decimal noofdays3 = line.Payment_Plan__r.No_of_days_3__c == null ? 0 : line.Payment_Plan__r.No_of_days_3__c;
                
                if( line.Percentage_1__c != null
                    && 
                    (stage1 == null || stage1 == opportunity.StageName)
                    &&
                    (operationStage1 == null || operationStage1 == opportunity.Operation_Stage__c)
                    &&
                    (datefield1 != null || datefield1 == 'Now'))
                {
                    system.debug('In first if');
                    OpportunityLineItem oli;
                    if(!map_linesToUpdateForDates.containsKey(line.Id)){
                        oli = new OpportunityLineItem(Id = line.Id);
                        map_linesToUpdateForDates.put(line.Id,oli);
                    }else{
                        oli = map_linesToUpdateForDates.get(line.Id);
                    }
                    
                    if(datefield1 == 'Now'){
                        if(line.Trigger_Date_1__c == null){
                            oli.Trigger_Date_1__c = System.today() + Integer.ValueOf(noofdays1);    
                        }
                    }else{
                        if(sobj.get(datefield1) == null){
                            oli.Trigger_Date_1__c = null;                           
                        }else{
                            oli.Trigger_Date_1__c = ((Date)sobj.get(datefield1)) + Integer.ValueOf(noofdays1);  
                        }
                    }
                }
                
                if( line.Percentage_2__c != null    
                    &&
                    (stage2 == null || stage2 == opportunity.StageName)
                    &&
                    (operationStage2 == null || operationStage2 == opportunity.Operation_Stage__c)
                    &&
                    (datefield2 != null || datefield1 == 'Now'))
                {
                    OpportunityLineItem oli;
                    if(!map_linesToUpdateForDates.containsKey(line.Id)){
                        oli = new OpportunityLineItem(Id = line.Id);
                        map_linesToUpdateForDates.put(line.Id,oli);
                    }else{
                        oli = map_linesToUpdateForDates.get(line.Id);
                    }
                    if(datefield2 == 'Now'){
                        if(line.Trigger_Date_2__c == null){
                            oli.Trigger_Date_2__c = System.today() + Integer.ValueOf(noofdays2);    
                        }
                    }else{
                        if(sobj.get(datefield2) == null){
                            oli.Trigger_Date_2__c = null;
                        }else{
                            oli.Trigger_Date_2__c = ((Date)sobj.get(datefield2)) + Integer.ValueOf(noofdays2);
                        }   
                    }
                }
                
                if( line.Percentage_3__c != null
                    &&
                    (stage3 == null || stage3 == opportunity.StageName)
                    &&
                    (operationStage3 == null || operationStage3 == opportunity.Operation_Stage__c)
                    &&
                    (datefield3 != null || datefield1 == 'Now'))
                {
                    OpportunityLineItem oli;
                    if(!map_linesToUpdateForDates.containsKey(line.Id)){
                        oli = new OpportunityLineItem(Id = line.Id);
                        map_linesToUpdateForDates.put(line.Id,oli);
                    }else{
                        oli = map_linesToUpdateForDates.get(line.Id);
                    }
                    
                    if(datefield3 == 'Now'){
                        if(line.Trigger_Date_3__c == null){
                            oli.Trigger_Date_3__c = System.today() + Integer.ValueOf(noofdays3);    
                        }
                    }else{
                        if(sobj.get(datefield3) == null){
                            oli.Trigger_Date_3__c = null;
                        }else{
                            oli.Trigger_Date_3__c = ((Date)sobj.get(datefield3)) + Integer.ValueOf(noofdays3);
                        }
                    }
                }
            }
            
            system.debug('linesToUpdate ='+map_linesToUpdateForDates.values());
            //Update the opportunitylineitems
            if(map_linesToUpdateForDates.values().size() > 0){
                update map_linesToUpdateForDates.values();
            }
        }
    }
}