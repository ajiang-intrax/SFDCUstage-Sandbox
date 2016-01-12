/*
B-03207 JOSE (APC - Field - Lead Bonus Payments)
We handle BONUS “APC HF Repeat Bonus” for Extension Matches
*/
global class Batch_APC_Bonus_Rep_Extension_Pay_Events implements Database.Batchable<sObject> , Schedulable {
    Date runDate = Global_Constants__c.getInstance().Batch_Pay_Event_Run_Date__c;    

    global Database.QueryLocator start(Database.BatchableContext BC){ 
        //Use Custom Setting to force run on a specific date.
        
        if(runDate == null){
            runDate = date.today();
        }
       
        system.debug('@@@@@@ runDate: ' + runDate);
          
        //Start with join of Match Owner History to Match so we can get the ownership chronology of each Match
        return Database.getQueryLocator([SELECT Name, id, Start_Date__c, End_Date__c, Host_Account__c, Intrax_Program__c, Position_Name__c,
                                        Position_Name__r.Intrax_Region__c, RecordTypeId, Engagement__c, Engagement__r.In_Country__c, Position_Name__r.OwnerId, Match_Type__c, Status__c
                                        FROM Match__c 
                                        WHERE Status__c = 'Confirmed' and 
                                        Intrax_Program__c = 'AuPairCare' and
                                        HF_Arrival_Date__c <= :runDate and
                                        HF_Arrival_Date__c > 2015-12-02 and
                                        Match_Type__c = 'Extension' and Engagement__r.In_Country__c = 'Yes' and 
                                        Host_Account__c != null AND Position_Name__c != null
                                        order BY CreatedDate ASC
                                        ]);   
    }
    
    global void execute(SchedulableContext sc){
        Batch_APC_Bonus_Rep_Extension_Pay_Events batch = new Batch_APC_Bonus_Rep_Extension_Pay_Events();
        Database.executeBatch(batch);
    }  
    
    global void execute(Database.BatchableContext BC, List<Match__c> MatchList){
        
        try{
        //Use Custom Setting to force run on a specific date. 
        system.debug('@@@@@@ MatchList: ' + MatchList);
        if(runDate == null){
            runDate = date.today();
        }
        system.debug('@@@@@@ runDate: ' + runDate);
        //list of IDs to query for existing Pay Events
        Set<Id> matchIDs = New Set<Id>();
        //list of IDs to query for existing Pay Events
        Set<Id> hostAccIDs = New Set<Id>();
        //Map to retrieve the previous match of the match record thruog the HF Account
        map<Id, Match__c> mapOldMatch = new map<Id, Match__c>();
        map<Id, Match__c> mapNewMatch = new map<Id, Match__c>();
        
        list<Match__c> confirmList = new list<Match__c>();
        
        
        //list of IDs to query for Matches realted Pay Events non creation
        set<Id> matchNoIDs = New set<Id>();
        //List of Matches for Pay Event creation
        list<Match__c> matchListCreate = New List<Match__c>();
        //List of Positions ID for Pay Event creation
        
        //Pay Event list to update
        list<Pay_Event__c> insertPayEvents = new list<Pay_Event__c>();
        
        for(Match__c m : MatchList){
            matchIDs.add(m.Id);
            mapNewMatch.put(m.Host_Account__c, m);
        }
        system.debug('@@@@@@ matchIDs: ' + matchIDs);
        system.debug('@@@@@@ mapNewMatch: ' + mapNewMatch);
        
        for(Match__c m : MatchList){
            hostAccIDs.add(m.Host_Account__c);
        }
        
        
        list<Match__c> previousMatchHF = [Select id, Start_Date__c, End_Date__c, Host_Account__c, Intrax_Program__c, Position_Name__c, Status__c,
                                        Position_Name__r.Intrax_Region__c, RecordTypeId, Engagement__c, Position_Name__r.OwnerId, Engagement__r.Status__c
                                        from Match__c 
                                        WHERE Host_Account__c != null AND Host_Account__c IN: hostAccIDs AND Id NOT IN: matchIDs ORDER BY CreatedDate ASC];
        
        
         system.debug('@@@@@@ previousMatchHF: ' + previousMatchHF);
         
         for(Match__c m:previousMatchHF){
            mapOldMatch.put(m.Host_Account__c, m);  
         }
         system.debug('@@@@@@ mapOldMatch: ' + mapOldMatch);
         
         if(mapOldMatch!= null && mapOldMatch.size()>0){
            for(Match__c mp: mapOldMatch.values()){
                if(mp.Status__c == 'Withdrawn' || mp.Status__c == 'Completed'){
                    confirmList.add(mapOldMatch.get(mp.Host_Account__c));   
                }
            }
         }
         
         
        
        if(confirmList!=null && confirmList.size()>0){                          
            //Get Stipend Pay Events that already exist. We dont want to create new ones if the already exist
            List<Pay_Event__c> payEvents = [SELECT Id, Name, Approved_By__c, Event_Date__c, Reference_Id__c, Payee__c, Quantity__c 
                                            FROM Pay_Event__c 
                                            WHERE Reference_Id__c In :matchIDs and
                                                  /*(Stage__c = 'Pending' OR Stage__c = 'Unearned') and*/
                                                  Source__c = 'APC HF Repeat Bonus'
                                            ];
            system.debug('@@@@@@ payEvents: ' + payEvents);
            if(payEvents!=null && payEvents.size()>0){
            //Retrieving IDs for non creation Payvent   
                for(Pay_Event__c pev : payEvents){
                    matchNoIDs.add(Id.valueOf(pev.Reference_Id__c));
                }
                system.debug('@@@@@@ matchNoIDs: ' + matchNoIDs);
                system.debug('@@@@@@ matchNoIDs.size(): ' + matchNoIDs.size());
                
                //remove from the list the Matches related to an existing Pay Event APC HF Repeat Bonus
                matchListCreate = [SELECT Name, id, Start_Date__c, End_Date__c, Host_Account__c, Intrax_Program__c, Position_Name__c, Position_Name__r.OwnerId,
                                            Position_Name__r.Intrax_Region__c, RecordTypeId, Engagement__c
                                            FROM Match__c 
                                            WHERE Status__c = 'Confirmed' and 
                                            Intrax_Program__c = 'AuPairCare' and
                                            HF_Arrival_Date__c <= :runDate and
                                            HF_Arrival_Date__c > 2015-12-02 and
                                            Match_Type__c = 'Extension' and Engagement__r.In_Country__c = 'Yes' and 
                                            Host_Account__c != null AND Position_Name__c != null and
                                            Id IN: matchIDs and Id NOT IN: matchNoIDs 
                                            order BY CreatedDate DESC
                                            ];
                system.debug('@@@@@@ matchListCreate: ' + matchListCreate);
                
                if(matchListCreate!=null && matchListCreate.size()>0){
                    Pay_Event__c newPE = New Pay_Event__c();
                    for(Match__c mpe : matchListCreate){
                        newPE = New Pay_Event__c();
                        // CREATING PAY EVENT
                        newPE.Stage__c = 'Pending';
                        newPE.HF_Account_Name__c = mpe.Host_Account__c;
                        newPE.OwnerId = mpe.Position_Name__r.OwnerId; 
                        newPE.Quantity__c = 1;
                        newPE.Reference_Object__c = 'Match';
                        newPE.Reference_Id__c = mpe.Id;
                        newPE.Event_Date__c = runDate;
                        newPE.Customer__c = mpe.Name.left(40);
                        newPE.Approved_By__c = Global_Constants__c.getInstance().ULM_Admin_ID__c;
                        newPE.Intrax_Program__c = mpe.Intrax_Program__c;
                        newPE.Payee__c = mpe.Position_Name__r.OwnerId;
                        newPE.Source__c = 'APC HF Repeat Bonus';
                    }
                    insertPayEvents.add(newPE);
                }
                 
            //we don't find any existing Pay Event  
            }else{
                for(Match__c mpe : MatchList){
                    Pay_Event__c newPE = New Pay_Event__c();
                    // CREATING PAY EVENT
                    newPE.Stage__c = 'Pending';
                    newPE.HF_Account_Name__c = mpe.Host_Account__c;
                    newPE.OwnerId = mpe.Position_Name__r.OwnerId; 
                    newPE.Quantity__c = 1;
                    newPE.Reference_Object__c = 'Match';
                    newPE.Reference_Id__c = mpe.Id;
                    newPE.Event_Date__c = runDate;
                    newPE.Customer__c = mpe.Name.left(40);
                    newPE.Approved_By__c = Global_Constants__c.getInstance().ULM_Admin_ID__c;
                    newPE.Intrax_Program__c = mpe.Intrax_Program__c;
                    system.debug('@@@@@@ mpe.Position_Name__r.OwnerId: ' + mpe.Position_Name__r.OwnerId);
                    newPE.Payee__c = mpe.Position_Name__r.OwnerId;
                    newPE.Source__c = 'APC HF Repeat Bonus';
                    
                    system.debug('@@@@@@ new Pay Event: ' + newPE);
                    insertPayEvents.add(newPE);
                }  
            }
            
            if(insertPayEvents!=null && insertPayEvents.size()>0){
                system.debug('@@@@@@ inserting Pay Event list'); 
                upsert insertPayEvents;
            }
            
        }else{//end if confirmList
            system.debug('***** No Pay Events to create');
        }
        }catch(Exception e){
            system.debug('***** Imposible to create APC Bonus in class Batch_APC_Bonus_Rep_Extension_Pay_Events: ' + e);
        }
    
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}