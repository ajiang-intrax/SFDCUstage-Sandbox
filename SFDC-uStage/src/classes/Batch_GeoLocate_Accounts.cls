global class Batch_GeoLocate_Accounts implements Database.Batchable<sObject>, DataBase.AllowsCallouts{
    
    global Database.Querylocator start (Database.BatchableContext BC){
        // Right now, we only need to geoLocate WT HC Accounts
        /*list<Account> accList = [Select Id, Type, Intrax_Programs__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                                            FROM Account 
                                            WHERE Type = 'Host Company' 
                                            AND Intrax_Programs__c includes ('Work Travel') 
                                            //and Address_GeoCoordinates__c != null
                                            ];
        system.debug('***** Number of WT HCs: ' + accList.size());                                  
        list<iGeoLocate__c> geoList_existing = [SELECT Id, Account__c FROM iGeoLocate__c WHERE Account__c != null and Account__c IN: accList];
        system.debug('***** existing geoCode Records: ' + geoList_existing.size());
        set<Id> account_existing = new set<Id>();
        for(iGeoLocate__c g : geoList_existing){ 
            for(Account a : acclist){ 
                if(a.Id == g.Account__c){
                    account_existing.add(a.Id);
                }
            }
        }
        
        system.debug('***** Existing accounts: '+ account_existing.size());
        return Database.getQueryLocator([Select Id, Type, Intrax_Programs__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Name
                                            FROM Account 
                                            WHERE Id NOT IN: account_existing 
                                            AND Type = 'Host Company' 
                                            AND Intrax_Programs__c includes ('Work Travel') LIMIT 200
                                            ]); 
       */
       // IGI 747: The queries has been optimized to avoid timeout GL issues
       return Database.getQueryLocator([Select Id, Type, Intrax_Programs__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                                            FROM Account 
                                            WHERE Type = 'Host Company' 
                                            AND Intrax_Programs__c includes ('Work Travel') 
                                            AND Id IN (SELECT Account__c FROM iGeoLocate__c WHERE Account__c != null)
                                            limit 200
                                            ]);
    }
    
    global void execute (Database.Batchablecontext BC, list<Account> accList){
        
        list<iGeoLocate__c> geoLocList = new list<iGeoLocate__c>();
        
        for(Account a: accList){
            iGeoLocate__c geoLoc = new iGeoLocate__c();
            geoLoc.Account__c = a.Id;
            //geoLoc.Name = a.Name + '_GeoLocate';
            geoLocList.add(geoLoc);
        }
        
        insert geoLocList;
        
    }
    
    
    global void finish(Database.BatchableContext BC){}
}