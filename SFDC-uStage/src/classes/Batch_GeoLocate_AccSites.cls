global class Batch_GeoLocate_AccSites implements Database.Batchable<sObject>, DataBase.AllowsCallouts{
    
    global Database.Querylocator start (Database.BatchableContext BC){
        // Right now, we only need to geoLocate WT HC Accounts
        
        /*list<Accommodation_Site__c> asiteList = [Select Id, Street__c, City__c, State__c, Postal_Code__c, Country__c
                                            FROM Accommodation_Site__c
                                            ];
        system.debug('***** AccSites to process: ' + asiteList.size());                                 
        list<iGeoLocate__c> geoList_existing = [SELECT Id, Accommodation_Site__c FROM iGeoLocate__c WHERE Accommodation_Site__c != null and Accommodation_Site__c IN: asiteList];
        system.debug('***** existing geoCode Records: ' + geoList_existing.size());
        set<Id> asite_existing = new set<Id>();
        for(iGeoLocate__c g : geoList_existing){ 
            for(Accommodation_Site__c a : asitelist){
                if(a.Id == g.Accommodation_Site__c){
                    asite_existing.add(a.Id);
                }
            }
        }
        
        system.debug('***** Existing accounts: '+ asite_existing.size());
        return Database.getQueryLocator([Select Id, Street__c, City__c, State__c, Postal_Code__c, Country__c, Name
                                            FROM Accommodation_Site__c 
                                            WHERE Id NOT IN: asite_existing LIMIT 200
                                            ]); 
      */ 
      	// IGI 747: The queries has been optimized to avoid timeout GL issues
       	return Database.getQueryLocator([Select Id, Street__c, City__c, State__c, Postal_Code__c, Country__c
                                            FROM Accommodation_Site__c where Id NOT IN 
                                            (SELECT Accommodation_Site__c FROM iGeoLocate__c WHERE Accommodation_Site__c != null)
                                            limit 200
                                            ]);
       
    }
    
    global void execute (Database.Batchablecontext BC, list<Accommodation_Site__c> accSiteList){
        
        list<iGeoLocate__c> geoLocList = new list<iGeoLocate__c>();
        
        for(Accommodation_Site__c a: accSiteList){
            iGeoLocate__c geoLoc = new iGeoLocate__c();
            geoLoc.Accommodation_Site__c = a.Id;
            //geoLoc.Name = a.Name + '_Geolocate';
            geoLocList.add(geoLoc);
        }
        
        insert geoLocList;
        
    }
    
    
    global void finish(Database.BatchableContext BC){}
}