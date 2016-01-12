global class Batch_Calc_GeoCoords_Acc implements dataBase.Batchable<sObject>, DataBase.AllowsCallouts {

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
        
        string query = 'SELECT Id, Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState, Account__r.BillingCountry, Account__r.BillingPostalCode, Account__c, Account__r.Type FROM iGeoLocate__c WHERE Account__c != null AND Account__r.Type =  \'Host Company\' AND Account__r.Intrax_Programs__c includes (\'Work Travel\') AND geoAddress__Latitude__s = null AND Sys_Admin_Tag__c = null LIMIT ' + getGeoCoordRecordLimit();
        return Database.getQueryLocator(query);
        /*return Database.getqueryLocator([SELECT Id, Account__c, Account__r.Type FROM iGeoLocate__c WHERE Account__c != null AND Account__r.Type =  'Host Company' 
                                            AND Account__r.Intrax_Programs__c includes ('Work Travel')
                                            AND geoAddress__Latitude__s = null
                                            LIMIT 5]);*/
    }
    
    global void execute (Database.Batchablecontext BC, list<iGeoLocate__c> glList){
        set<Id> glIds = new set<Id>();
        list<iGeoLocate__c> recordsSkipped = new list<iGeoLocate__c>();
        
        for(iGeoLocate__c g : glList){
            if(g.Account__r.BillingStreet == null || g.Account__r.BillingCity == null || g.Account__r.BillingState == null
                || g.Account__r.BillingPostalCode == null || g.Account__r.BillingCountry == null){
                g.Sys_Admin_Tag__c = 'Missing Address Field. GeoLocation Skipped.';
                recordsSkipped.add(g);
            }else glIds.add(g.Id);
        }
        
        /*for(iGeoLocate__c g : glList){
            glIds.add(g.Id);
        }*/
        
        if(glIds.size() > 0){
            iGeoLocateTriggerHelper.computelstGeoCode_batch(glIds);
        }
        
        if(recordsSkipped.size() > 0){
            update recordsSkipped;
        }
    }
    
    global void finish(Database.BatchableContext BC){}
}