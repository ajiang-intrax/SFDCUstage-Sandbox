public class TriggerExclusion {
    
    public static map<String, String> mapTriggerExclude = new map<String, String>();
    public static map<String, String> mapSkipAfterUpdate = new map<String, String>();
    public static boolean skipUpdate_AutoSync = false;
    
    public static void triggerExclude(String objectName, Boolean mapAction){        
        if(!mapAction){
            mapTriggerExclude.clear();
        }
        if(mapAction){
            mapTriggerExclude.put(objectName, 'Trigger Exclusion');
        }
    }
    
    public static boolean isTriggerExclude(String objectName){
        if(mapTriggerExclude.get(objectName) != null){
            system.debug('Trigger Exclude ' +'('+objectName +'): ' +mapTriggerExclude.get(objectName));
           return true;
        }  
        return false;
    }

    public static map<String, list<sObject>> excludeTrigger(list<sObject> listSObject){        
        String triggerObject = String.valueOf(listSObject[0].getsObjectType());     
        Map<String,Trigger_Exclusion__c> triggerExclusionMapAll = Trigger_Exclusion__c.getAll();
        map<String, list<sObject>> mapTriggerNew = new map<String, list<sObject>>();
        Map<String,Trigger_Exclusion__c> triggerExclusionMap = new Map<String,Trigger_Exclusion__c>();
        set<String> fieldNames = new set<String>();
        set<Id> setExcludeId = new set<Id>();
        list<sObject> lstExcludeFromTriggerNew = new list<sObject>();
        list<sObject> lstIncludeInTriggerNew = new list<sObject>();
        
        for (String csName : triggerExclusionMapAll.keySet()){
            If (triggerExclusionMapAll.get(csName).Object__c == triggerObject){
                triggerExclusionMap.put(csName,triggerExclusionMapAll.get(csName));
            }
        }
        
        if(triggerObject == 'Applicant_Info__c'){
            fieldNames = Applicant_Info__c.sObjectType.getDescribe().fields.getMap().keySet();
        }
        
        if(triggerObject == 'iGeoLocate__c'){
            fieldNames = Applicant_Info__c.sObjectType.getDescribe().fields.getMap().keySet();
        }
        
        for(sObject itrObject : listSObject){
            Integer countValue = 0;
            for (String csName : triggerExclusionMap.keySet()){
                for (String fieldName : fieldNames){
                    if(triggerExclusionMap.get(csName).Field_Name__c == fieldName){
                        if(itrObject.get(fieldName) != null && itrObject.get(fieldName).equals(triggerExclusionMap.get(csName).value__c)){
                            countValue++;                           
                            if(countValue == triggerExclusionMap.size()){
                                lstExcludeFromTriggerNew.add(itrObject);
                                setExcludeId.add(itrObject.Id);
                            }
                        }
                    }
                }
            }
        }
        
        if(setExcludeId == null){
            lstIncludeInTriggerNew = listSObject;
        }else{              
            for(sObject itrObject : listSObject){
                if(!setExcludeId.contains(itrObject.Id)){
                    lstIncludeInTriggerNew.add(itrObject);
                }
            }
        }
                
        if(lstExcludeFromTriggerNew != null && lstExcludeFromTriggerNew.size() > 0){
            mapTriggerNew.put('exclude', lstExcludeFromTriggerNew);
        }
        if(lstIncludeInTriggerNew != null && lstIncludeInTriggerNew.size() > 0){
            mapTriggerNew.put('include', lstIncludeInTriggerNew);
        }
        return mapTriggerNew;
    }

}