//This component is part of Invoice IT Deployment
trigger TriggerOnOpportunityLineItem on OpportunityLineItem (after insert, before update) {
    
    Map<String,Trigger_Exclusion__c> triggerExclusionMapAll = Trigger_Exclusion__c.getAll();
    Map<String,Trigger_Exclusion__c> triggerExclusionMapOpp = new Map<String,Trigger_Exclusion__c>();
    for (String csName : triggerExclusionMapAll.keySet()){
        If (triggerExclusionMapAll.get(csName).Object__c == 'OpportunityLineItem'){
            triggerExclusionMapOpp.put(csName,triggerExclusionMapAll.get(csName));
        }
    }
    
    Set<String> fieldNames = OpportunityLineItem.sObjectType.getDescribe().fields.getMap().keySet();
    Integer matchCount = 0;
    Integer fieldCount = triggerExclusionMapOpp.keyset().size();
    for (String csName : triggerExclusionMapOpp.keySet()){
        for (String fieldName : fieldNames){
            if(triggerExclusionMapOpp.get(csName).Field_Name__c.equalsIgnoreCase(fieldName)){
                if (Trigger.new[0].get(fieldName) != null && String.ValueOf(Trigger.new[0].get(fieldName)).length() > 0){
                    System.debug('I have to be excluded it seems because,'+Trigger.new[0].get(fieldName)+triggerExclusionMapOpp.get(csName).value__c);
                    //return;
                    matchCount = matchCount + 1;
                }
            }
        }
    }  
    
    if (fieldCount == matchCount){
        System.debug('Returning from TriggerOnOpportunityLineItem due to exclusion rule matching');
        return;
    }   
    
    ClassAfterOnOpportunityLineItem classAfterOnOpportunityLineItem = new ClassAfterOnOpportunityLineItem();
    if(trigger.isInsert){
        classAfterOnOpportunityLineItem.handleAfterInsertOnOpportunityLineItem(trigger.newMap); 
    }
    if(trigger.isUpdate){
        classAfterOnOpportunityLineItem.handleBeforeUpdateOnOpportunityLineItem(trigger.oldMap, trigger.newMap);    
    }
}