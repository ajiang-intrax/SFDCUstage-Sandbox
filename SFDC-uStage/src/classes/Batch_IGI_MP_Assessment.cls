global class Batch_IGI_MP_Assessment implements Database.Batchable<sObject> {
	
     public static integer rows_count = 0; 
    
    global Database.queryLocator start(Database.BatchableContext BC){
        list<Engagement__c> engListForBatch = new list<Engagement__c>();
        
        return Database.getQueryLocator([SELECT Id, Status__c, (Select CreatedBy__c from Applicant_Info__r), Intrax_Program__c, Intrax_Program_Options__c, Engagement_Start__c , Engagement_End__c FROM Engagement__c
                                                    WHERE Intrax_Program__c =: 'Internship'
                                                    AND (Status__c =: 'On Program') 
                                                   // AND (Engagement_Start__c <= :(date.today()+14))
                                                    AND Engagement_End__c > :date.today() 
                                                    AND Id in (select Engagement__c from applicant_Info__c WHERE Applicant_Info__c.CreatedBy__r.Profile.Name = 'OCPM PT') ]);
    }
    
    global void execute (Database.BatchableContext BC, list<Engagement__c> DummyengList){
    	
    	
    	
        list<Engagement__c> engList = new list<Engagement__c>();
        Integer NoOfDays;
        Integer NoOfDaysToday;
        if(DummyengList != NULL)
        {
            for (Engagement__c en : DummyengList)
            {
               
               if ( en.Intrax_Program_Options__c != 'WEST' ){ 
               system.debug('***** not WEST ' );
                if(en.Engagement_Start__c != NULL && en.Engagement_End__c != NULL)
                {
                    NoOfDays =  en.Engagement_Start__c.daysBetween(en.Engagement_End__c);
                    NoOfDaysToday= en.Engagement_Start__c.daysBetween(date.today());
                    if (NoOfDaysToday >= NoOfDays/2 && NoOfDays > 180 )
                    {
                        engList.add(en);
                    }
                }
               }
               else {
               	system.debug('*****  WEST ' );
               	list<Match__c> match_exist = [SELECT Start_Date__c, End_Date__c
                                                    FROM Match__c 
                                                    WHERE Engagement__c =: en.Id and Status__c=: 'Confirmed' order by CreatedDate desc ];
                  if    (match_exist.size() > 0)  
                  {    
                  	system.debug('*****  WEST and found match  with seze = ' + match_exist.size()  );                         
               	  if( match_exist[0].Start_Date__c   != NULL && match_exist[0].End_Date__c != NULL)
                  {
                	 
                    NoOfDays = match_exist[0].Start_Date__c.daysBetween(match_exist[0].End_Date__c);
                    NoOfDaysToday= match_exist[0].Start_Date__c.daysBetween(date.today());
                    if (NoOfDaysToday >= NoOfDays/2 && NoOfDays > 180 )
                    {
                        engList.add(en);
                    }
                }
               }
               }
                
            }
        }
    	
    	
        map<Id, Applicant_Info__c> WT_Engg_App_Map = new map<Id, Applicant_Info__c>();
        for (Engagement__c enggVal : engList)
        {
            List<Applicant_Info__c> getApplList = enggVal.Applicant_Info__r;
            if (getApplList != null && getApplList.size() > 0)
            {
                WT_Engg_App_Map.put(enggVal.ID, getApplList[0]);
            }
            
        }
        
        rows_count += engList.size();
        system.debug('***** RC: Initial Engagement List size: ' + engList.size() + ' / Rows Counter: ' + rows_count);
        list<Assessment__c> new_assessments =  new list<Assessment__c>();
        // 1. Retrieving all the existing Check-In Assessments
        list<Assessment__c> ass_checkIn_exist = [SELECT Id, RecordTypeId, Engagement__c, Time_Period__c, Status__c, Confirmed_Date__c
                                                    FROM Assessment__c 
                                                    WHERE Engagement__c IN: engList 
                                                    //AND Engagement__c NOT IN: engs_MC_exist_Ids  // We don´t need to do anything with Check-Ins if a MC already exist
                                                    AND RecordTypeId =: Constants.ASS_IGI_PT_Mid_Program];
                                                    
        rows_count += ass_checkIn_exist.size();
        system.debug('***** RC: CheckIn Assessment list size: ' + ass_checkIn_exist.size() + ' / Rows Counter: ' + rows_count); 
        // 2. Creating list of engagements that already have a Check-In Assessment created
        list<Id> engIds_checkIn = new list<Id>();
        for(Assessment__c a : ass_checkIn_exist){
            engIds_checkIn.add(a.Engagement__c);
        }
                                            
        // 3. Now, getting the list of Engagements we need a check-in Assessment for
        list<Engagement__c> engs_checkIn_notexist =  new list<Engagement__c>();
        engs_checkIn_notexist = [SELECT Id, Status__c FROM Engagement__c 
                                    WHERE Id =: engList
                                    AND Id NOT IN: engIds_checkIn];
        rows_count += engs_checkIn_notexist.size();                         
        system.debug('***** RC: Engagements without a CheckIn assesssment: ' + engs_checkIn_notexist.size() + ' / Rows Counter: ' + rows_count);                            
        // 4. Getting all the existing Notifications. We need to this to update the existing ones in case they are due.
        list<Notification__c> notification_all = [SELECT ID, Status__c, Type__c, Engagement__c, Assessment__c FROM Notification__c 
                                                    WHERE Engagement__c IN: engList
                                                    AND (Type__c =: 'Mid Program Assessment') //OR Type__c =: 'Monthly Contact')
                                                    AND (Status__c =: 'Complete' OR Status__c =: 'Confirmed') // NEW: We don´t need to get the already Completed or Confirmed --> TEST
                                                    ];
        rows_count += notification_all.size();                          
        system.debug('***** RC: All the checkIn Notifications: ' + notification_all.size() + ' / Rows Counter: ' + rows_count); 
                                                
        // 5. Preparing the data --> Mapping to store Engagment Id --> List of related Assessments
        map<Id, list<Assessment__c>> map_all_assess_for_eng = new map<Id, list<Assessment__c>>();
        for(Engagement__c e : engList){
            map_all_assess_for_eng.put(e.Id, new list<Assessment__c>());
        }
        for(Assessment__c a: ass_checkIn_exist){
            map_all_assess_for_eng.get(a.Engagement__c).add(a);
        }   
        
        // 6. Initializing map: Engagement ID --> Check-In Notification
        map<Id, Notification__c> map_CheckIn_Notif_to_Eng = new map<Id, Notification__c>();
        // 7. Initializing map: Assessment_Id --> Notification record
        map<Id, Notification__c> map_Notif_to_Ass = new map<Id, Notification__c>(); 
        
        set<Id> engs_checkIn_exist_Ids = new set<Id>();
        
        // 8. Processing existing notifications to check whether we need to update them or not
        if(ass_checkIn_exist.size() > 0){
            // 8.1. Creating list of engagements we need to check
            for( Assessment__c a : ass_checkIn_exist){
                engs_checkIn_exist_Ids.add(a.Engagement__c);
            }
            // 8.2 Getting all the necessary data
            list<Engagement__c> eng_checkIn_Exist_list = [SELECT Id, Engagement_Start__c, status__c, RecordTypeId FROM Engagement__c WHERE Id IN: engs_checkIn_exist_Ids];
            
            rows_count += eng_checkIn_Exist_list.size();                            
            system.debug('***** RC: All related Engagmements list: ' + eng_checkIn_Exist_list.size() + ' / Rows Counter: ' + rows_count);   
            list<Engagement__c> checkIn_Due = new list<Engagement__c>();
            
            // 8.3. Assessing data
            for(Engagement__c e : eng_checkIn_Exist_list){
                list<Assessment__c> assessment_sorted = map_all_assess_for_eng.get(e.Id);
                
                if(e.Status__c == 'On Program' && (date.today() >= e.Engagement_Start__c + 25) && map_CheckIn_Notif_to_Eng.get(e.Id) != null && assessment_sorted[0].RecordTypeId == Constants.ASS_IGI_PT_Mid_Program && !(assessment_sorted[0].Status__c == 'Complete' || assessment_sorted[0].Status__c == 'Confirmed')){
                    checkIn_Due.add(e);
                } 
                
                else{
                    system.debug('******* WE ARE OK...');
                }
            }
            
            // 8.4. Updating records (if any)
            list<Notification__c> CheckIns_To_Update = new list<Notification__c>();
            if(checkIn_Due.Size() > 0){
                
                for(Engagement__c e : checkIn_Due){
                    system.debug('******* DUE CHeckIN: ' + map_CheckIn_Notif_to_Eng.get(e.Id));
                    map_CheckIn_Notif_to_Eng.get(e.Id).subject__c = 'Call to Mid Program Assessment!' ;
                    map_CheckIn_Notif_to_Eng.get(e.Id).Body__c = 'You are very close to being out of status on your program because you have failed to Mid Program Assessment in a timely manner. Please call us at 1-888-224-0450 during business hours of 9:00am to 5:00pm to complete this process with one of our representatives.';
                    map_CheckIn_Notif_to_Eng.get(e.Id).Status__c = 'Not Started';
                    checkIns_To_Update.add(map_CheckIn_Notif_to_Eng.get(e.Id)); 
                }
                try{
                    update checkIns_To_Update;
                }catch(Exception e){
                    system.debug('****** Impossible to update Due check-In notifications: ' +e);
                }
            }
        }                       
        
        // 9. Creating the CheckIn Assessment for those engagement that does not have one yet
        for(Engagement__c e : engs_checkIn_notexist){
            if(e.Status__c == 'On Program'){
                Assessment__c a  = new Assessment__c (Name ='Mid Program', RecordTypeId = Constants.ASS_IGI_PT_Mid_Program, Status__c = 'Not Yet Started', Engagement__c = e.Id, OwnerId = WT_Engg_App_Map.get(e.Id).CreatedBy__c);
                new_assessments.add(a); 
            }   
        }
        try{
            insert new_assessments;
        }catch(Exception e){
            system.debug('****** Impossible to insert Assessments from Batch_IGI_Assessment_Generator: ' + e);
        }
        
        // 10. NOTIFICATIONS - New notifications Management
        list<Assessment__c> lstNotifyAssEngagements = new list<Assessment__c>();
        map<Id, Id> Ids_for_CheckInNotification = new map<Id, Id>(); // maps: ass.Engagement__c, ass.Id
        
        // 10.1. We only generate new notifications in case the Assessment has previously been shared. 
        //string  SOQLQuery =  'Select a.RecordTypeId, a.Status__c,a.Name, a.Month_Number__c,a.Record_Type_Group__c,a.Assessment_Date__c,a.Host_Name__c, a.Match_Name__c, a.Participant_Name__c, a.Position_Name__c, a.Engagement__c, a.Count_Down__c, a.Id, a.ManualShareExists__c From Assessment__c a where a.ManualShareExists__c=True and (a.RecordTypeId = \'' + Constants.ASS_WT_PT_Monthly_Contact + '\' OR a.RecordTypeId = \'' + Constants.ASS_IGI_PT_Check_In + '\') Order By a.CreatedDate';
        string  SOQLQuery =  'Select a.RecordTypeId, a.Status__c,a.Name, a.Month_Number__c,a.Record_Type_Group__c,a.Assessment_Date__c,a.Host_Name__c, a.Match_Name__c, a.Participant_Name__c, a.Position_Name__c, a.Engagement__c, a.Count_Down__c, a.Id, a.ManualShareExists__c From Assessment__c a where a.ManualShareExists__c=True and a.RecordTypeId = \'' + Constants.ASS_IGI_PT_Mid_Program + '\' Order By a.CreatedDate';
        lstNotifyAssEngagements = Database.Query(SOQLQuery);
        
        rows_count += lstNotifyAssEngagements.size();                           
        system.debug('***** RC: list of notifications to be created (manual share exists): ' + lstNotifyAssEngagements.size() + ' / Rows Counter: ' + rows_count);  
        
        // 10.2. Preparing the data to send it to the method that actually sends the notifications
        for(Assessment__c ass: lstNotifyAssEngagements) {
            system.debug('***** ASS ID: ' + ass.ID + ' / ' +ass.Name);
            if(ass.RecordTypeId == Constants.ASS_IGI_PT_Mid_Program && !(ass.Status__c == 'Confirmed' || ass.Status__c == 'Complete' )){ // IGI 730: We only want to create a new Notif in case the Assessment has been manually completed (or started)
                system.debug('***** Creating Check-in Notification!');
                Ids_for_CheckInNotification.put(ass.Engagement__c, ass.Id);
            }
            
        }
        if(Ids_for_CheckInNotification != null && Ids_for_CheckInNotification.size() > 0) 
            Notification_Generator.sendIGIMidProgramNotification(Ids_for_CheckInNotification);
        
    } 
    
    global void finish(Database.BatchableContext BC){
    
    }   
}