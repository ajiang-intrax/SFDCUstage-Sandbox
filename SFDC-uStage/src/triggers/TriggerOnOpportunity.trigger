//This component is part of Invoice IT Deployment
trigger TriggerOnOpportunity on Opportunity (after update) {
    //I have to exclude this trigger if Auto Sync Application.
    if(TriggerExclusion.isTriggerExclude('Opportunity')){
        return;
    }
    
    Map<String,Trigger_Exclusion__c> triggerExclusionMapAll = Trigger_Exclusion__c.getAll();
    Map<String,Trigger_Exclusion__c> triggerExclusionMapOpp = new Map<String,Trigger_Exclusion__c>();
    for (String csName : triggerExclusionMapAll.keySet()){
        If (triggerExclusionMapAll.get(csName).Object__c == 'Opportunity'){
            triggerExclusionMapOpp.put(csName,triggerExclusionMapAll.get(csName));
        }
    }
    
    Set<String> fieldNames = Opportunity.sObjectType.getDescribe().fields.getMap().keySet();
    Integer matchCount = 0;
    Integer fieldCount = triggerExclusionMapOpp.keyset().size();
    for (String csName : triggerExclusionMapOpp.keySet()){
        for (String fieldName : fieldNames){
            if(triggerExclusionMapOpp.get(csName).Field_Name__c.equalsIgnoreCase(fieldName)){
                if (Trigger.new[0].get(fieldName) != null && Trigger.new[0].get(fieldName).equals(triggerExclusionMapOpp.get(csName).value__c)){
                    System.debug('I have to be excluded it seems because,'+Trigger.new[0].get(fieldName)+triggerExclusionMapOpp.get(csName).value__c);
                    //return;
                    matchCount = matchCount + 1;
                }
            }
        }
    }  
    
    if (fieldCount == matchCount){
        System.debug('Returning from TriggerOnOpportunity due to exclusion rule matching');
        return;
    }   
    
   ClassAfterOnOpportunity classAfterOnOpportunity = new ClassAfterOnOpportunity();
   classAfterOnOpportunity.handleAfterOnOpportunity(Trigger.newMap,Trigger.oldMap);
}