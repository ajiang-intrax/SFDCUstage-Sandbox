global class Batch_Calc_GeoCoords_AccSites implements dataBase.Batchable<sObject>, DataBase.AllowsCallouts {

    public static list<JobSettings__c> GeoCoordRecordLimitList;
    public string getGeoCoordRecordLimit(){
        string BatchLimit = '1';
        GeoCoordRecordLimitList = JobSettings__c.getAll().values();
        if(GeoCoordRecordLimitList != null && GeoCoordRecordLimitList.size() > 0){
            for(JobSettings__c js : GeoCoordRecordLimitList){
                if(js.Name == 'GeoCoordRecordLimit'){
                    BatchLimit = string.valueOf(integer.valueOf(js.BatchLimit__c));
                }
            }
        }
        return BatchLimit;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC){
        string batchLimit = getGeoCoordRecordLimit();
        system.debug('***** Batch Limit: '+ batchLimit);
        
        string query = 'SELECT Id, Accommodation_Site__c,Accommodation_Site__r.Street__c, Accommodation_Site__r.State__c, Accommodation_Site__r.City__c, Accommodation_Site__r.Postal_Code__c, Accommodation_Site__r.Country__c, Account__c, Account__r.Type FROM iGeoLocate__c WHERE Accommodation_Site__c != null AND geoAddress__Latitude__s = null AND Sys_Admin_Tag__c = null LIMIT ' + BatchLimit;
        return Database.getQueryLocator(query);
        /*
        return Database.getqueryLocator([SELECT Id, Account__c, Account__r.Type FROM iGeoLocate__c WHERE Accommodation_Site__c != null
                                            AND geoAddress__Latitude__s = null
                                            LIMIT 2]);
                                            */
    }
    
    global void execute (Database.Batchablecontext BC, list<iGeoLocate__c> glList){
        set<Id> glIds = new set<Id>();
        list<iGeoLocate__c> recordsSkipped = new list<iGeoLocate__c>();
        
        for(iGeoLocate__c g : glList){
            if(g.Accommodation_Site__r.Street__c == null || g.Accommodation_Site__r.City__c == null || g.Accommodation_Site__r.State__c == null
                || g.Accommodation_Site__r.Postal_Code__c == null || g.Accommodation_Site__r.Country__c == null){
                g.Sys_Admin_Tag__c = 'Missing Address Field. GeoLocation Skipped.';
                recordsSkipped.add(g);
            }else glIds.add(g.Id);
        }
        
        if(glIds.size() > 0){
            iGeoLocateTriggerHelper.computelstGeoCode_batch(glIds);
        }
        
        if(recordsSkipped.size() > 0){
            update recordsSkipped;
        }
    }
    
    global void finish(Database.BatchableContext BC){}
}