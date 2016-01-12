global class Batch_IGI_MC_Assessment implements Database.Batchable<sObject> {
    
    public static integer rows_count = 0;
    
    global Database.queryLocator start(Database.BatchableContext BC){
        //Applying patch to avoid Engagements without applications
        
        return Database.getQueryLocator([SELECT Id, Status__c, (Select CreatedBy__c from Applicant_Info__r), Intrax_Program__c, Engagement_Start__c, Engagement_End__c FROM Engagement__c
                                                    WHERE Intrax_Program__c =: 'Internship'
                                                    AND (Status__c =: 'On Program')                                           
                                                    AND Engagement_End__c > :date.today() 
                                                    AND Id IN (select Engagement__c from applicant_Info__c WHERE Applicant_Info__c.CreatedBy__r.Profile.Name = 'OCPM PT') ]);
    }
    
    global void execute (Database.BatchableContext BC, list<Engagement__c> DummyengList){
        // Getting all the Assessments that already exist (We need to exclude them form the batch creation)
        // Creating the list of Assessments that needs tobe created    DummyengList
      list<Engagement__c> engList = new list<Engagement__c>();
        Integer NoOfDays;
        Integer NoOfDaysToday;
        if(DummyengList != NULL)
        {
            for (Engagement__c en : DummyengList)
            {
                if(en.Engagement_Start__c != NULL && en.Engagement_End__c != NULL)
                {
                    NoOfDays =  en.Engagement_Start__c.daysBetween(en.Engagement_End__c);
                    NoOfDaysToday= en.Engagement_Start__c.daysBetween(date.today());
                    if (NoOfDaysToday< NoOfDays/2)
                    {
                        system.debug('*NoOfDaysToday< NoOfDays/2');
                        engList.add(en);
                    }
                    else 
                    {
                    	// if exists MP then add MC
                    	system.debug('*****exists MP'); 
                    	list<Assessment__c> ass_MP_exist = [SELECT Id, RecordTypeId, Engagement__c, Time_Period__c, Status__c
                                                    FROM Assessment__c 
                                                    WHERE Engagement__c=:  en.ID
                                                    AND RecordTypeId =: Constants.ASS_IGI_PT_Mid_Program
                                                    //and Status__c = 'Confirmed'
                                                    order by Confirmed_Date__c desc];
                                                    
                         if     (ass_MP_exist!=null && ass_MP_exist.size()>0)
                          {
                          	 system.debug('***** ass_MP_exist.size() size: ' + ass_MP_exist.size()); 
       
                          engList.add(en);
                          }
                                                
                    }
                }
                
            }
        }
        
        
        //IGI - 750 (Start)
        map<Id, Applicant_Info__c> IGI_Engg_App_Map = new map<Id, Applicant_Info__c>();
        for (Engagement__c enggVal : engList)
        {
            List<Applicant_Info__c> getApplList = enggVal.Applicant_Info__r;
            if (getApplList != null && getApplList.size() > 0)
            {
                IGI_Engg_App_Map.put(enggVal.ID, getApplList[0]);
            }
            
        }
        //IGI - 750 (End)
        
        rows_count += engList.size();                           
        system.debug('***** RC: Initial Engagements managed in the flow: ' + engList.size() + ' / Rows Counter: ' + rows_count);    
        
        list<Assessment__c> new_assessments =  new list<Assessment__c>();
        list<Assessment__c> lstNotifyAssEngagements = new list<Assessment__c>(); 
        
        map<Id, Id> Ids_for_MCNotification = new map<Id, Id>(); // maps: ass.Engagement__c, ass.Id
        
        //IGI 600
        //set<Id> Ids_for_CheckInNotification = new set<Id>();
        map<Id, Id> Ids_for_CheckInNotification = new map<Id, Id>(); // maps: ass.Engagement__c, ass.Id
        
        //B-02344 
 
          // 0. Checking all the Engagements that already have a Final Program assessment
        list<Assessment__c> ass_FP_exist = [SELECT Id, RecordTypeId, Engagement__c, Time_Period__c, Status__c
                                                    FROM Assessment__c 
                                                    WHERE Engagement__c 
                                                    IN: engList 
                                                    AND RecordTypeId =: Constants.ASS_IGI_PT_Final_Program
                                                    order by Confirmed_Date__c desc];
        rows_count += ass_FP_exist.size();
        system.debug('***** RC: FP Assessment list size: ' + ass_FP_exist.size() + ' / Rows Counter: ' + rows_count); 
         // 2. Creating a set that contains all the Engagement (IDs) that already have a FP
        set<Id> engs_FP_exist_Ids = new set<Id>();
        if(ass_FP_exist!=null && ass_FP_exist.size() > 0){
            for(Assessment__c a : ass_FP_exist) engs_FP_exist_Ids.add(a.Engagement__c);
        }
        
        
        // 1. Checking all the Engagements that already have a MC created
        list<Assessment__c> ass_MC_exist = [SELECT Id, RecordTypeId, Engagement__c, Time_Period__c, Status__c
                                                    FROM Assessment__c 
                                                    WHERE Engagement__c 
                                                    IN: engList 
                                                    AND (RecordTypeId =: Constants.ASS_IGI_PT_Monthly_Contact )
                                                    order by Confirmed_Date__c desc];
        rows_count += ass_MC_Exist.size();
        system.debug('***** RC: MC Assessment list size: ' + ass_MC_exist.size() + ' / Rows Counter: ' + rows_count);   
        
        // 2. Creating a set that contains all the Engagement (IDs) that already have at least a MC
        set<Id> engs_MC_exist_Ids = new set<Id>();
        if(ass_MC_exist.size() > 0){
            for(Assessment__c a : ass_MC_exist) engs_MC_exist_Ids.add(a.Engagement__c);
        }
        
        // 3. We need all the Engagements that do not have a MC and FP Assessment yet
        list<Assessment__c> ass_checkIn_exist = [SELECT Id, RecordTypeId, Engagement__c, Time_Period__c, Status__c, Engagement__r.Status__c
                                                    FROM Assessment__c 
                                                    WHERE Engagement__c IN: engList
                                                    AND Engagement__r.Status__c = 'On Program' 
                                                    AND Engagement__c NOT IN: engs_FP_exist_Ids   //// We don´t need to do anything with MC if a FP already exist
                                                    AND Engagement__c NOT IN: engs_MC_exist_Ids  // We don´t need to do anything with Check-Ins if a MC already exist
                                                    AND RecordTypeId =: Constants.ASS_IGI_PT_Check_In];
        rows_count += ass_CheckIn_exist.size();
        system.debug('***** RC: MC Assessment with a Check-In list size: ' + ass_checkIn_exist.size() + ' / Rows Counter: ' + rows_count);
        
        
        // 3. Getting all the related assessments & notifications for the Engagements in context
        list<Assessment__c> ass_all = [SELECT Id, RecordTypeId, Engagement__c, Time_Period__c, Confirmed_Date__c, Status__c
                                                    FROM Assessment__c 
                                                    WHERE Engagement__c IN: engList
                                                    AND (RecordTypeId =: Constants.ASS_IGI_PT_Check_In OR RecordTypeId =: Constants.ASS_IGI_PT_Monthly_Contact OR RecordTypeId =: Constants.ASS_IGI_PT_Mid_Program) // Do we need to still get both?
                                                    ORDER BY Confirmed_Date__c desc];
        rows_count += ass_all.size();
        system.debug('***** RC: All Assessments list size: ' + ass_all.size() + ' / Rows Counter: ' + rows_count);
        
        list<Notification__c> notification_all = [SELECT ID, Status__c, Type__c, Engagement__c, Assessment__c FROM Notification__c 
                                                    WHERE Engagement__c IN: engList
                                                    AND (Type__c =: 'Monthly Contact')];
                                                    
        rows_count += notification_all.size();
        system.debug('***** RC: Notification all: ' + notification_all.size() + ' / Rows Counter: ' + rows_count);
        
        // Preparing the data --> Initializing map to store EngagmentId --> List of related Assessments
        map<Id, list<Assessment__c>> map_all_assess_for_eng = new map<Id, list<Assessment__c>>();
        // Initializing map to store EngagementId --> List of related Notifcations
        map<Id, Notification__c> map_CheckIn_Notif_to_Eng = new map<Id, Notification__c>();
        
        map<Id, Notification__c> map_Notif_to_Ass = new map<Id, Notification__c>(); // mapping Assessment_Id --> Notification record
        
        for(Engagement__c e : engList){
            map_all_assess_for_eng.put(e.Id, new list<Assessment__c>());
        }       

        for(Assessment__c a: ass_all){
            map_all_assess_for_eng.get(a.Engagement__c).add(a);
        }   
        
        for(Notification__c n : notification_all){
            system.debug('****** MC Notification: ' + n.Id);
            
            map_Notif_to_Ass.put(n.Assessment__c, n);
        }
    
        for(Engagement__c e : engList){
                system.debug('******* EngagementID: ' + e.Id + ' / Associated Assessments: ' + map_all_assess_for_eng.get(e.Id).size());
        }   
        
        if(ass_MC_exist.size() > 0){
            for( Assessment__c a : ass_MC_exist){
                engs_MC_exist_Ids.add(a.Engagement__c);
            }
            list<Engagement__c> eng_MC_exist_list = [SELECT Id, Engagement_Start__c, status__c, RecordTypeId FROM Engagement__c WHERE Id IN: engs_MC_exist_Ids];
            rows_count += eng_MC_exist_list.size();
            system.debug('***** RC: Engagements that have a MC Assessment associated: ' + eng_MC_exist_list.size() + ' / Rows Counter: ' + rows_count);
            
            list<Assessment__c> mc_Due_30 = new list<Assessment__c>();
            list<Assessment__c> mc_Due_32 = new list<Assessment__c>();
        
            for(Engagement__c e : eng_MC_exist_list){
                system.debug('***++++ engagement ID: ' + e.Id );
                list<Assessment__c> assessment_sorted = map_all_assess_for_eng.get(e.Id);
                system.debug('***++++ assessment_sorted size: ' + assessment_sorted.size());
                system.debug('***++++ assessment_sorted size: ' + assessment_sorted[0].Status__c + assessment_sorted[0].Confirmed_Date__c + '----'+assessment_sorted[0].Id );
                //system.debug('***** Assessment_sorted[0]: + ' + Assessment_sorted[0].Id + ' / ' + 'Assessment_sorted[1]: + ' + Assessment_sorted[1].Id);
                if(e.Status__c == 'On Program' && assessment_sorted[0].Status__c == 'Confirmed' && (date.today() >= assessment_sorted[0].Confirmed_Date__c + 25)){
                    Assessment__c a  = new Assessment__c (Name ='Monthly Contact', RecordTypeId = Constants.ASS_IGI_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = e.Id, OwnerId = IGI_Engg_App_Map.get(e.Id).CreatedBy__c);
                    new_assessments.add(a);
                } 
              /*  
                else if(e.Status__c == 'On Program' && (date.today() >= assessment_sorted[0].Confirmed_Date__c + 30) && (date.today() <= assessment_sorted[0].Confirmed_Date__c + 32) && assessment_sorted[0].RecordTypeId == Constants.ASS_IGI_PT_Monthly_Contact && !(assessment_sorted[0].Status__c == 'Complete' || assessment_sorted[0].Status__c == 'Confirmed'))
                {
                    mc_Due_30.add(assessment_sorted[0]);
                } else if(e.Status__c == 'On Program' && (date.today() > assessment_sorted[0].Confirmed_Date__c + 32) && assessment_sorted[0].RecordTypeId == Constants.ASS_IGI_PT_Monthly_Contact && !(assessment_sorted[0].Status__c == 'Complete' || assessment_sorted[0].Status__c == 'Confirmed'))
                {
                    mc_Due_32.add(assessment_sorted[0]);
                } 
                */ 
            }
            
            list<Notification__c> MCs_Notif_to_Update = new list<Notification__c>();
            // Now, we need to update the associated notifications...
            if(mc_Due_30.size() > 0){
                for(Assessment__c a : mc_Due_30){
                    system.debug('****** MC Due 30 days - Notification: ' + map_Notif_to_Ass.get(a.Id) + ' / Assessment Id: ' + a.Id);
                    if(map_Notif_to_Ass.get(a.Id) != null){
                        map_Notif_to_Ass.get(a.Id).Subject__c = 'Monthly Contact Late';
                        map_Notif_to_Ass.get(a.Id).Body__c = 'You have neglected to complete your Monthly Contact within 25 days. Please complete it now.';
                        MCs_Notif_to_Update.add(map_Notif_to_Ass.get(a.Id));
                    }
                }
            }
            if(mc_Due_32.size() > 0){
                for(Assessment__c a : mc_Due_32){
                    system.debug('****** MC Due 32 days - Notification: ' + map_Notif_to_Ass.get(a.Id) + ' / Assessment Id: ' + a.Id);
                    if(map_Notif_to_Ass.get(a.Id) != null){                 
                        map_Notif_to_Ass.get(a.Id).Subject__c = 'Monthly Contact Warning';
                        map_Notif_to_Ass.get(a.Id).Body__c = 'You have failed to complete your Monthly Contact and are out of compliance with U.S. State Department regulations. Additionally, you are at risk of losing your good standing on the program. Please complete your Monthly Contact immediately.';
                        MCs_Notif_to_Update.add(map_Notif_to_Ass.get(a.Id));
                    }
                }
            }
            try{
                update MCs_Notif_to_Update;
            }catch(Exception e){
                system.debug('Impossible to update Monthly Contact notifications: ' + e );
            }
            
        }
        
        set<Id> engs_checkIn_exist_Ids = new set<Id>();
        if(ass_checkIn_exist.size() > 0){
            for( Assessment__c a : ass_checkIn_exist){
                engs_checkIn_exist_Ids.add(a.Engagement__c);
            }

            list<Engagement__c> eng_checkIn_Exist_list = [SELECT Id, Engagement_Start__c, status__c, RecordTypeId FROM Engagement__c WHERE Id IN: engs_checkIn_exist_Ids];
            rows_count += eng_checkIn_Exist_list.size();
            system.debug('***** RC: Engagements with an Check-In associated: ' + eng_checkIn_Exist_list.size() + ' / Rows Counter: ' + rows_count);
            
            list<Engagement__c> checkIn_Due = new list<Engagement__c>();
            
            for(Engagement__c e : eng_checkIn_Exist_list){
                list<Assessment__c> assessment_sorted = map_all_assess_for_eng.get(e.Id);
                
                system.debug('******* assessment_sorted: ' + assessment_sorted[0].RecordTypeId + ' / ConfirmedDate: ' + assessment_sorted[0].Confirmed_Date__c);
                
                if(assessment_sorted[0].Status__c == 'Confirmed' && assessment_sorted[0].confirmed_Date__c <= (date.today()-14)){
                    //system.debug('****** We need a new Assessment!!!!' );
                    Assessment__c a  = new Assessment__c (Name ='Monthly Contact', RecordTypeId = Constants.ASS_IGI_PT_Monthly_Contact, Status__c = 'Not Yet Started', Engagement__c = e.Id, OwnerId = IGI_Engg_App_Map.get(e.Id).CreatedBy__c);
                    new_assessments.add(a);
                    //Ids_for_MCNotification.add(e.Id);
                }else{
                    system.debug('******* WE ARE OK...');
                }
            }
            //Notification_generator.sendIGIMonthlyContactNotification(Ids_for_MCNotification);
            list<Notification__c> CheckIns_To_Update = new list<Notification__c>();
            
        } 
        
        if(new_assessments.size() > 0){
            try{
                insert new_assessments;
            }catch(Exception e){
                system.debug('****** Impossible to insert MC Assessments: ' + e);
            }
        }
        
        
        // From here: New notifications Management
        //string  SOQLQuery =  'Select a.RecordTypeId, a.Status__c,a.Name, a.Month_Number__c,a.Record_Type_Group__c,a.Assessment_Date__c,a.Host_Name__c, a.Match_Name__c, a.Participant_Name__c, a.Position_Name__c, a.Engagement__c, a.Count_Down__c, a.Id, a.ManualShareExists__c From Assessment__c a where a.ManualShareExists__c=True and (a.RecordTypeId = \'' + Constants.ASS_IGIPT_Monthly_Contact + '\' OR a.RecordTypeId = \'' + Constants.ASS_IGI_PT_Check_In + '\') Order By a.CreatedDate';
        string  SOQLQuery =  'Select a.RecordTypeId, a.Status__c,a.Name, a.Month_Number__c,a.Record_Type_Group__c,a.Assessment_Date__c,a.Host_Name__c, a.Match_Name__c, a.Participant_Name__c, a.Position_Name__c, a.Engagement__c, a.Count_Down__c, a.Id, a.ManualShareExists__c From Assessment__c a where a.ManualShareExists__c=True and a.RecordTypeId = \'' + Constants.ASS_IGI_PT_Monthly_Contact + '\' Order By a.CreatedDate';
        lstNotifyAssEngagements = Database.Query(SOQLQuery);
        
        rows_count += lstNotifyAssEngagements.size();                           
        system.debug('***** RC: list of notifications to be created (manual share exists): ' + lstNotifyAssEngagements.size() + ' / Rows Counter: ' + rows_count);  
        
        list<Notification__c> existingNotifications = [SELECT Id, Assessment__c FROM Notification__c WHERE Assessment__c IN: lstNotifyAssEngagements];
        rows_count += existingNotifications.size();                         
        system.debug('***** RC: list of related existing notifications: ' + existingNotifications.size() + ' / Rows Counter: ' + rows_count);   
        
        map<Id, Id> map_ass_to_notification = new map<Id, Id>();
        for(Notification__c n : existingNotifications){
            map_ass_to_notification.put(n.Assessment__c, n.Id);
        }
        
        for(Assessment__c ass: lstNotifyAssEngagements) {
            
            if(ass.RecordTypeId == Constants.ASS_IGI_PT_Monthly_Contact && map_ass_to_notification.get(ass.Id) == null && !(ass.Status__c == 'Confirmed' || ass.Status__c == 'Complete')){ // IGI 730: We only want to create a new Notif in case the Assessment has been manually completed (or started)
                system.debug('***** Creating MC Notification!');
                Ids_for_MCNotification.put(ass.Engagement__c, ass.Id);
            }
        }
        
        if(Ids_for_MCNotification != null && Ids_for_MCNotification.size() > 0)
        
            Notification_Generator.sendIGIMonthlyContactNotification(Ids_for_MCNotification);
        
    }
    
    
    global void finish(Database.BatchableContext BC){
    
    }   
}