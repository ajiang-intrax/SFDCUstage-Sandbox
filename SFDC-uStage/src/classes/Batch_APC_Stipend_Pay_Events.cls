global class Batch_APC_Stipend_Pay_Events implements Database.Batchable<sObject>, Schedulable {
    Date runDate = Global_Constants__c.getInstance().Batch_Pay_Event_Run_Date__c;    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        try{
            //Use Custom Setting to force run on a specific date.
            //Jose´s changes for 2 period month
            Date EndPeriodDate;
            Date StartPeriodDate;
            if(runDate == null){
                runDate = date.today();
            }
            if(runDate.day() > 15 ){
                EndPeriodDate = runDate.addMonths(1).toStartofMonth().addDays(-1);  
                StartPeriodDate = runDate.toStartofMonth().addDays(15);
                system.debug('@@@@@@ Period between 16th and End of Month');
            }else{
                EndPeriodDate = runDate.toStartofMonth().addDays(14);   
                StartPeriodDate = runDate.toStartofMonth();
                system.debug('@@@@@@ Period between 0 and 15th');
            }
            system.debug('@@@@@@ StartPeriodDate: ' + StartPeriodDate);
            system.debug('@@@@@@ EndPeriodDate: ' + EndPeriodDate); 
              
            if(test.isRunningTest()) runDate = date.today().toStartOfMonth().addMonths(1).addDays(-1);
            system.debug('@@@@@@ runDate1: ' + runDate);
            //Start with join of Match Owner History to Match so we can get the ownership chronology of each Match
            return Database.getQueryLocator([SELECT Name, id, Match_Owner__c, Start_Date__c, End_Date__c, Match__r.Host_Account__c, Match__r.Id,
                                Match__r.Name, Match__r.Start_Date__c, Match__r.End_Date__c, Match__r.Position_Name__r.Intrax_Region__c, 
                                Match__r.RecordTypeId, Match__r.Engagement__c, Match__r.Intrax_Program__c, Match__r.Actual_End_Date__c 
                                FROM Match_Owner_History__c 
                                WHERE Match__r.Intrax_Program__c = 'AuPairCare' and
                                ((Match__r.Status__c = 'Confirmed' and Match__r.End_Date__c >= :StartPeriodDate) or (Match__r.Status__c = 'Ended Early' and Match__r.Actual_End_Date__c >= :StartPeriodDate)) and
                                Match__r.Start_Date__c <= :EndPeriodDate
                                ORDER BY Match__r.Id ASC, Start_Date__c DESC, CreatedDate DESC 
                                ]);  
        }catch(Exception e){
            system.debug('***** Imposible to create APC Stipend in class Batch_APC_Stipend_Pay_Events: ' + e);
            return null; 
        }
    } 
    
    global void execute(SchedulableContext sc){
        Batch_APC_Stipend_Pay_Events batch = new Batch_APC_Stipend_Pay_Events();
        Database.executeBatch(batch);
    } 
    
    global void execute(Database.BatchableContext BC, List<Match_Owner_History__c> monthMatchHistories){
        try{
            //Use Custom Setting to force run on a specific date. 
            //Jose´s changes for 2 period month
            Date EndPeriodDate;
            Date StartPeriodDate;
            if(runDate == null){
                runDate = date.today();
            }
            if(runDate.day() > 15 ){
                EndPeriodDate = runDate.addMonths(1).toStartofMonth().addDays(-1);  
                StartPeriodDate = runDate.toStartofMonth().addDays(15);
                system.debug('@@@@@@ Period between 16th and End of Month');
            }else{
                EndPeriodDate = runDate.toStartofMonth().addDays(14);   
                StartPeriodDate = runDate.toStartofMonth();
                system.debug('@@@@@@ Period between 0 and 15th');
            }
            system.debug('@@@@@@ StartPeriodDate: ' + StartPeriodDate);
            system.debug('@@@@@@ EndPeriodDate: ' + EndPeriodDate);
              
              
            if(test.isRunningTest()) runDate = date.today().toStartOfMonth().addMonths(1).addDays(-1);        
    
            //Fill in any empty MOH End_Dates.  The assumption here is that ownership changes on
            //Position (Match parent) insert a new MOH instance, but does not update the last MOH
            //instance End Date.  This could be moved to an @Future method on the Position side. 
            List<Match_Owner_History__c> updateMOH = New List<Match_Owner_History__c>();
            List<Match_Owner_History__c> lmoh = New List<Match_Owner_History__c>();
            List<Id> matchIDs = New List<Id>();
            
            ID lmid = null;
            Date lsd = null;
            system.debug('@@@@@@ monthMatchHistories: ' + monthMatchHistories);
            system.debug('@@@@@@ runDate2: ' + runDate);
            
            for(Match_Owner_History__c moh : monthMatchHistories){
                if(moh.Match__r.Id == lmid){
                    system.debug('@@@@@@ moh.Match__r.Id: ' + moh.Match__r.Id);
                    system.debug('@@@@@@ lmid: ' + lmid);   
                    moh.End_Date__c = lsd;
                    updateMOH.add(moh);
                }
                lmid = moh.Match__c;
                lsd = moh.Start_Date__c;
                system.debug('@@@@@@ moh.Id: ' + moh.Id);
                system.debug('@@@@@@ lmid: ' + lmid);
                system.debug('@@@@@@ lsd: ' + lsd);
                matchIDs.add(moh.Match__c);
            }
            update updateMOH;
    
            //Get Stipend Pay Events that already exist so far for this month--we'll update them, and create new ones as needed.
            List<Pay_Event__c> payEvents = [SELECT Id, Name, Approved_By__c, Event_Date__c, Reference_Id__c, Payee__c, Quantity__c 
                                            FROM Pay_Event__c 
                                            WHERE Reference_Id__c In :matchIDs and
                                                  (Stage__c = 'Pending' OR Stage__c = 'Unearned') and
                                                  Source__c = 'APC FS Stipend' and
                                                  Event_Date__c >= :StartPeriodDate and
                                                  Event_Date__c < :EndPeriodDate
                                            ];
            
            //Set up to quickly find existing PayEvent using Match ID + Payee
            Map<String, Pay_Event__c> lookUpPayEvents = New Map<String, Pay_Event__c>();
            for(Pay_Event__c pe : payEvents){
                pe.Quantity__c = 0;
                lookUpPayEvents.put(pe.Reference_Id__c + pe.Payee__c, pe);
            }
            
            //Holds pre-existing and newly created PEs that we'll need to upsert at the end
            List<Pay_Event__c> upsertPayEvents = New List<Pay_Event__c>();        
    
            //Cycle through all days in month up to today, working out who owned each Match on each day, and
            //then working out whether we already have a Pay Event (needs update) or that a new one needs to be created.
            //The key idea here is that Stipend is earned 1 day at a time, for each day MOH indicates an active Match
            //was owned.
            for(Match_Owner_History__c moh : monthMatchHistories){
                //Jose's Changes for 2 stipment period month
                system.debug('@@@@@Match Owner in context: ' + moh.id);
                system.debug('@@@@@Match Owner in context name: ' + moh.Name);
                Integer dayOfMonth = 0;
                if(runDate.day() > 15){
                    system.debug('@@@@@second month period');
                    dayOfMonth = 15;
                }else{
                    system.debug('@@@@@first month period');
                    dayOfMonth = 0;
                }
                while (dayOfMonth < (runDate.day())){
                    dayOfMonth++;
                    Pay_Event__c updatePE = lookUpPayEvents.get('' + moh.Match__r.Id + moh.Match_Owner__c);                 
                    system.debug('@@@@@updatePE:' + updatePE);
                    Date pDate = date.newinstance(runDate.year(), runDate.month(), dayOfMonth);
                    system.debug('@@@@@pDate:' + pDate);
                    if(moh.Match__r.start_date__c <= pDate && ((moh.Match__r.status__c=='Confirmed' && moh.Match__r.End_Date__c >= pDate) || (moh.Match__r.status__c=='Ended Early' && moh.Match__r.Actual_End_Date__c >= pDate))){
                        if(updatePE != null && moh.Start_Date__c <= pdate && (moh.End_Date__c == null || moh.End_Date__c >= pdate)){
                            system.debug('@@@@@here1');  
                            updatePE.Quantity__c++;
                            updatePE.Event_Date__c = pDate;
                            updatePE.Approved_By__c = Global_Constants__c.getInstance().ULM_Admin_ID__c;
                        }else if (updatePE == null && moh.Start_Date__c <= pdate && (moh.End_Date__c == null || moh.End_Date__c >= pdate)){
                            Pay_Event__c newPE = New Pay_Event__c();
                            //newPE.Stage__c = 'Unearned';
                            newPE.Stage__c = 'Pending';
                            //JOSE B-03207
                            newPE.HF_Account_Name__c = moh.Match__r.Host_Account__c;
                            //END JOSE B-03207
                            newPE.Payee__c = moh.Match_Owner__c;
                            newPE.OwnerId = moh.Match_Owner__c;
                            newPE.Quantity__c = 1;
                            newPE.Source__c = 'APC FS Stipend';
                            newPE.Reference_Object__c = 'Match';
                            newPE.Reference_Id__c = moh.Match__c;
                            newPE.Event_Date__c = pDate;
                            newPE.Customer__c = moh.Match__r.Name.left(40);
                            newPE.Approved_By__c = Global_Constants__c.getInstance().ULM_Admin_ID__c;
                            newPE.Intrax_Program__c = moh.Match__r.Intrax_Program__c;
                            newPE.Intrax_Region__c = moh.Match__r.Position_Name__r.Intrax_Region__c;
                            lookUpPayEvents.put('' + moh.Match__c + newPE.Payee__c, newPE); //This will only happen once / month per key
                        } 
                    }
                }
            }
            Set<String> mapIds = new Set<String>();
            mapIds = lookUpPayEvents.keySet();
            for(String key : mapIds){
                upsertPayEvents.add(lookUpPayEvents.get(key));
            }
            upsert upsertPayEvents;
        }catch(Exception e){
            system.debug('***** Imposible to create APC Bonus in class Batch_APC_Bonus_Pay_Events - execute method: ' + e);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}