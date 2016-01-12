trigger Trigger_Con_Applicant_Info on Applicant_Info__c (before update, before insert, after update, after insert) {
      
    //Trigger Exclusion Logic 
    list<Applicant_Info__c> lstApplicationInfo = new list<Applicant_Info__c>();
    list<Applicant_Info__c> lstApplication_Include = new list<Applicant_Info__c>();//List contains trigger.new values.
    list<Applicant_Info__c> lstApplication_Exclude = new list<Applicant_Info__c>();//List contains trigger.new values to exclude.
    //list<Applicant_Info__c> lstApplication_TriggerNew = new list<Applicant_Info__c>();//Trigger.New values. Always use this list instead of trigger.new.
    Applicant_Info__c oldApplicaton = new Applicant_Info__c();
    Boolean skipAutoAppSyncValidation = false;
    for(Applicant_Info__c itrAppInfo : trigger.new){
        if(trigger.oldMap != null){
            oldApplicaton = trigger.oldMap.get(itrAppInfo.Id);
        }        
        if(itrAppInfo.Intrax_Program__c == 'Work Travel' && itrAppInfo.Application_Stage__c != oldApplicaton.Application_Stage__c && (oldApplicaton.Application_Stage__c == 'Working' || oldApplicaton.Application_Stage__c == 'Submitted') && itrAppInfo.Application_Stage__c == 'In-Review'){
            lstApplicationInfo.add(itrAppInfo);
        }else{          
            if(TriggerExclusion.mapSkipAfterUpdate != null && TriggerExclusion.mapSkipAfterUpdate.size() > 0 && TriggerExclusion.mapSkipAfterUpdate.get('AutoSyncRecord') != null && itrAppInfo.Sys_Admin_Tag__c == TriggerExclusion.mapSkipAfterUpdate.get('AutoSyncRecord')){
                //Do Nothing.
            }else{
                lstApplication_Include.add(itrAppInfo);
            }
        }
    }  
    
    if(lstApplicationInfo != null && lstApplicationInfo.size() > 0){
        map<String, list<Applicant_Info__c>> mapTrigger = TriggerExclusion.excludeTrigger(lstApplicationInfo);
        if(mapTrigger != null && mapTrigger.size() > 0){
            if(mapTrigger.get('exclude') != null){                
                if(trigger.isAfter){ 
                    skipAutoAppSyncValidation = true;
                }
                //Auto Sync Application - Validation
                map<String, list<Applicant_Info__c>> mapAutoSyncValidation = autoSyncApplication.autoAppSyncValidation(mapTrigger.get('exclude'), skipAutoAppSyncValidation);
                if(mapAutoSyncValidation != null && mapAutoSyncValidation.size() > 0){
                    if(mapAutoSyncValidation.get('exclude') != null){
                        lstApplication_Exclude = mapAutoSyncValidation.get('exclude');
                    }
                    if(mapAutoSyncValidation.get('include') != null){
                        lstApplication_Include.addAll(mapAutoSyncValidation.get('include'));
                    } 
                }
               if(lstApplication_Exclude != null && lstApplication_Exclude.size() > 0){
                    //Auto Sync Application Process
                    autoSyncApplication autoSync = new autoSyncApplication();
                    autoSync.autoSyncWTApplication(lstApplication_Exclude, trigger.oldMap);
               }
            }
            if(mapTrigger.get('include') != null){
                for(Applicant_Info__c itrApp : mapTrigger.get('include')){
                    lstApplication_Include.add(itrApp);
                }               
            }
        }
    }
    //Trigger Exclusion Logic.
    if((lstApplication_Exclude != null && lstApplication_Include == null) || (lstApplication_Exclude.size() > 0 && lstApplication_Include.size() == 0)){
        return;
    }else if((lstApplication_Exclude == null && lstApplication_Include == null) || (lstApplication_Exclude.size() == 0 && lstApplication_Include.size() == 0)){
        return;
    }//else{
        //if(lstApplication_Include != null && lstApplication_Include.size() > 0){
            //lstApplication_TriggerNew = lstApplication_Include;          
    
    // TRIGGER VARS INSTANTIATION  
    //Geo Instantiate Google Geo Controller
    System.debug('Inside Account trigger before instance creation');
    googleGeoController gGeoC = new googleGeoController();
    System.debug('Inside Account trigger after instance creation');
        
    string strAppInfoName;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    Id SuccessChildOppId1;
    
    //Added by Saroj for Manual Sharing Issue (Start)
    /*list<Applicant_Info__Share> AppSharetoPersist = new list<Applicant_Info__Share>();
    list<Manual_Sharing_Info__c> ManualShareInfolst = new list<Manual_Sharing_Info__c>();
    
    map<string,list<string>> AppSharePersistList = new map<string,list<string>>();*/
    Applicant_Info__Share app_share=new Applicant_Info__Share();
    String flag;
    //Added by Saroj for Manual Sharing Issue (End)
    
    set<Id> setOpportunity = new set<Id>();
    list<Opportunity> lstOppToUpdate = new list<Opportunity>();
    map<Id, Opportunity> mapOpportunity;
    //B-01488 for Apc pt
    set<Id> setOppoApc = new set<Id>();
    list<Opportunity> lstOppApcToUpdate = new list<Opportunity>();
    map<Id, Opportunity> mapOppApc;
    //B-01488 for Apc pt
    
    if(trigger.isBefore && trigger.isUpdate){
        Set<ID> befAppsIds = new Set<Id>();
        for(Applicant_Info__c itrAppInfo : trigger.new){
            befAppsIds.add(itrAppInfo.Account__c);
            system.debug('***** Application Owner trig'+itrAppInfo.ownerId);
            if(itrAppInfo.Opportunity_Name__c != null && itrAppInfo.Intrax_Program__c == 'Ayusa'){
                setOpportunity.add(itrAppInfo.Opportunity_Name__c);
            }
            //itrAppInfo.OwnerId = '00519000000mXP6';
        }        
        
        if(setOpportunity != null && setOpportunity.size() > 0){
            mapOpportunity = new map<Id, Opportunity>([select Id, StageName, CloseDate, RecordTypeId from Opportunity where Id IN :setOpportunity]);
        }
        
        if(mapOpportunity != null && mapOpportunity.size() > 0){
            for(Applicant_Info__c itrAppInfo : trigger.new){
                Applicant_Info__c oldMapAppInfo = trigger.oldMap.get(itrAppInfo.Id);
                if(itrAppInfo.RecordTypeId  == Constants.AyusaPT_Record_Type_Id && itrAppInfo.Opportunity_Name__c != null && oldMapAppInfo.Application_Stage__c != itrAppInfo.Application_Stage__c && itrAppInfo.Application_Stage__c == 'In-Review'){
                    Opportunity oppAppInfo = mapOpportunity.get(itrAppInfo.Opportunity_Name__c);
                    if(oppAppInfo.RecordTypeId  == Constants.OPP_AYUSA_PT && oppAppInfo.StageName != 'Closed Won'){
                        oppAppInfo.StageName = 'Closed Won';
                        oppAppInfo.CloseDate = Date.Today();
                        lstOppToUpdate.add(oppAppInfo);
                    }
                }               
            }
            if(lstOppToUpdate != null && lstOppToUpdate.size() > 0){
                update lstOppToUpdate;
            }
        }
    }
   
      //B-01488 for Apc pt
    
    if(trigger.isBefore && trigger.isUpdate){
        Set<ID> AppsIds = new Set<Id>();
        for(Applicant_Info__c itrAppInfo : trigger.new){
            AppsIds.add(itrAppInfo.Account__c);
            if(itrAppInfo.Opportunity_Name__c != null && itrAppInfo.Intrax_Program__c == 'AuPairCare'){
                setOppoApc.add(itrAppInfo.Opportunity_Name__c);
            }
            
        }        
        
        if(setOppoApc != null && setOppoApc.size() > 0){
            mapOppApc = new map<Id, Opportunity>([select Id, StageName, CloseDate, RecordTypeId from Opportunity where Id IN :setOppoApc]);
        }
        
        if( mapOppApc != null &&  mapOppApc.size() > 0){
            for(Applicant_Info__c itrAppInfo : trigger.new){
                Applicant_Info__c oldMapAppInfoApc = trigger.oldMap.get(itrAppInfo.Id);
                if(itrAppInfo.RecordTypeId  == Constants.AuPairCarePT_Record_Type_Id && itrAppInfo.Opportunity_Name__c != null && oldMapAppInfoApc.Application_Stage__c != itrAppInfo.Application_Stage__c && itrAppInfo.Application_Stage__c == 'In-Review'){
                    Opportunity oppAppInfoApc = mapOppApc.get(itrAppInfo.Opportunity_Name__c);
                    if(oppAppInfoApc.RecordTypeId  == Constants.OPP_AUPAIRCARE_PT && oppAppInfoApc.StageName != 'Closed Won'){
                      oppAppInfoApc.StageName = 'Closed Won';
                      oppAppInfoApc.CloseDate = Date.Today();
                      lstOppApcToUpdate.add(oppAppInfoApc);
                    }
                }               
            }
            if(lstOppApcToUpdate != null && lstOppApcToUpdate.size() > 0){
                update lstOppApcToUpdate;
            }
        }
    }
      //B-01488 for Apc pt ends
      
    if(trigger.isBefore){        
        
        if(trigger.isUpdate){
            
                // Added for persisting sharing on ownership change
                Set<Id> appInfoIds = new Set<Id>();
                Set<Id> APCOwnerChanges = new set<Id>();
                //List<User> allADs = [select Id,Profile.Name from User where Profile.Name = 'APC AD PC'];
                //Set<Id> ADIDSet = (new Map<Id,sObject>(allADs)).keySet();
                List<User> allADs = new List<User>();
                Set<Id> ADIDSet = new Set<Id>();
            
                if(Trigger.old[0]!=null && Trigger.old[0].OwnerId!=null && trigger.new[0]!=null && trigger.new[0].OwnerId != Trigger.old[0].OwnerId){
                    allADs = [select Id,Profile.Name from User where Profile.Name = 'APC AD PC'];
                    ADIDSet = (new Map<Id,sObject>(allADs)).keySet();
                }
                
                for(Applicant_Info__c record: trigger.new) {
                    if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null && record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) 
                    {      
                        if (ADIDSet.contains(record.OwnerId)){
                            APCOwnerChanges.add(record.Id);
                        }   
                        else{ 
                            appInfoIds.add(record.Id);
                        }
                    }
                    system.debug('**appInfoIds**'+appInfoIds);
                     //B-03166  
                    system.debug('Trigger.oldMap.get(record.Id).Partner_Intrax_Id__c' +Trigger.oldMap.get(record.Id).Partner_Intrax_Id__c); 
                     system.debug('Trigger.newMap.get(record.Id).Partner_Intrax_Id__c' +Trigger.newMap.get(record.Id).Partner_Intrax_Id__c);  
                    if((Trigger.newMap.get(record.Id).Partner_Intrax_Id__c!=null && record.Type__c == 'Participant') && (record.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id || record.RecordTypeId == Constants.AyusaPT_Record_Type_Id))
                    {
                     system.debug('Trigger.oldMap.get(record.Id).Partner_Intrax_Id__c' +Trigger.oldMap.get(record.Id).Partner_Intrax_Id__c);
                     String partac = Trigger.newMap.get(record.Id).Partner_Intrax_Id__c;
                     ApplicantInfoHelper.setApp_IntraxRegion_and_MarketForPT(record);
                    }
                    // B-03166 
               }
               
               if((APCOwnerChanges!=null && APCOwnerChanges.size()>0)) {
                flag='before';
                //Hypothetical case - if we have a bunch where both APC Owner and Other owner types set together then do both here
                if (APCOwnerChanges!=null && APCOwnerChanges.size()>0)
                    SharingSecurityHelper.persistSharingWithOwner(app_share, flag, APCOwnerChanges);
                if (appInfoIds!=null && appInfoIds.size()>0)
                    SharingSecurityHelper.persistSharingWithOwner(app_share, flag, appInfoIds); 
               }
               //If we have exclusively other type owner set to app info then do the other before updates 
               else{
                        for(Applicant_Info__c ap: trigger.new){
                            system.debug('***** Application Owner trig'+ap.ownerId);
                            //B-02410 (Start)
                            if(ap.RecordTypeId== Constants.AuPairCareHF_Record_Type_Id && ap.Application_Type__c == 'Original' && trigger.oldMap.get(ap.Id).Application_Level__c != trigger.newMap.get(ap.Id).Application_Level__c && trigger.newMap.get(ap.Id).Application_Level__c == 'Main' && trigger.newMap.get(ap.Id).Application_Stage__c == 'Working' && ap.Position__c == NULL && ap.Account__c != NULL)
                            {
                                system.debug('*****Inside the Position create block***');
                                id newposID = null;
                                newposID = AppTriggerHelper.CreateAppPos(ap);
                                if(newposID != null) ap.Position__c = newposID;
                            }
                            //B-02410 (End)
                            else if(ap.RecordTypeId== Constants.AuPairCareHF_Record_Type_Id && ap.Application_Type__c == 'Original' && trigger.newMap.get(ap.Id).Application_Level__c == 'Main' && trigger.newMap.get(ap.Id).Application_Stage__c == 'Working' && ap.Position__c != NULL && ap.Account__c != NULL)
                            {
                                if(AppTriggerHelper.APCHFSyncNeeded(trigger.oldMap.get(ap.Id), ap))
                                {
                                    AppTriggerHelper.APCHFSync(ap);
                                }
                            }
                            
                            //B-03217
                            
                             if(ap.Intrax_Program__c == 'AuPairCare' &&  (!(ap.Name.contains('-APC'))) && (ap.type__c=='Participant' || ap.type__c=='Host Family'))
                                {
                                 if(trigger.newMap.get(ap.Id).Engagement_Start__c != null)
                                   {
                                    Integer adYear;
                                    String appName;
                                    appName = ap.Name;
                                     if(ap.Engagement_Start__c!=null)
                                    {
                                        adYear = ap.Engagement_Start__c.year();
                                       system.debug('@@adYear' +adYear);  
                                    }
                                  
                                    appName = appName +'-APC'+adYear;  
                                    ap.Name = appName;
                                    ap.Program_Year__c = String.Valueof(adYear);
                                   system.debug('@@appname' +appName); 
                                  
                                }        
                              }
                            
                            //B-03217                    
                         
                            // B-01630  (Start)
                            /* if(ap.RecordTypeId == Constants.WT_PT_Record_Type_Id && (ap.Application_Stage__c == 'Submitted' || ap.Application_Stage__c == 'In-Review'))
            {
            system.debug('ap.CreatedBy__r.Profile.Name' + ap.CreatedBy__r.Profile.Name);
            if(ap.Email__c != NULL)
            {
            if((ap.CreatedBy__r.Profile.Name == NULL || ap.CreatedBy__r.Profile.Name != 'OCPM PT'))
            {
            list<User> lstusers = [SELECT Id, Username,User_Interests__c,Email FROM User WHERE Email=:ap.Email__c AND Profile.Name = 'OCPM PT' order by createdDate DESC];
            if(lstusers != NULL && lstusers.size() > 0)
            {
            ap.CreatedBy__c = lstusers[0].Id;
            system.debug('lstusers[0].Id' + lstusers[0].Id);
            system.debug('ap.CreatedBy__c' + ap.CreatedBy__c);
            
            
            } 
            }
            
            list<Applicant_Info__c> ExistingAppInfo = [select id,name from Applicant_Info__c  where (Email__c =: ap.Email__c AND application_Stage__c != 'Cancelled') order by createdDate DESC];
            if(ExistingAppInfo != NULL && ExistingAppInfo.size() > 1 && ap.Application_Type__c != 'Renewal')
            {
            ap.Application_Type__c = 'Renewal';
            }
            }
            }*/
                            // B-02147 Start
                            if(ap.Account__c!=null && ap.application_Stage__c=='Accepted')
                            {
                                list<Applicant_Info__c> ExistingAppInfo = [select id, CreatedBy__c, CreatedBy__r.Profile.Name, Intrax_Program__c, RecordTypeId , name ,Application_Type__c from Applicant_Info__c  where (Account__c =: ap.Account__c AND application_Stage__c = 'Accepted' AND createdDate < :ap.createdDate) order by createdDate DESC];
                                if(ExistingAppInfo != NULL && ExistingAppInfo.size() >= 1 && (ap.Application_Type__c != 'Repeat' || ap.CreatedBy__r.Profile.Name != 'OCPM PT'))
                                {
                                    list<User> lstusers = new list<User>();
                                    For(Applicant_Info__c existingApp : ExistingAppInfo)
                                    {
                                        //Jose's changes to avoid change Application_Type__c when we extend/clone the APC Application
                                        if(existingApp.RecordTypeId==ap.RecordTypeId && existingApp.Intrax_Program__c != 'AuPairCare')
                                        {
                                            ap.Application_Type__c = 'Repeat';
                                        }
                                        
                                        if(ap.CreatedBy__r.Profile.Name == NULL || ap.CreatedBy__r.Profile.Name != 'OCPM PT')
                                        {                           
                                            if(existingApp.CreatedBy__r.Profile.Name == 'OCPM PT') 
                                            {                           
                                                lstusers = [SELECT Id, Username,User_Interests__c,Email FROM User WHERE Id=:existingApp.CreatedBy__c order by createdDate DESC];
                                                if(lstusers != NULL && lstusers.size() > 0)
                                                {
                                                    ap.CreatedBy__c = lstusers[0].Id;
                                                    system.debug('lstusers[0].Id' + lstusers[0].Id);
                                                    system.debug('ap.CreatedBy__c' + ap.CreatedBy__c);
                                                    if(ap.RecordTypeId == Constants.AyusaHF_Record_Type_Id)lstusers[0].User_Interests__c='Hosting an international student';
                                                    if(ap.RecordTypeId == Constants.AyusaPT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming a high school exchange student';
                                                    if(ap.RecordTypeId == Constants.WT_PT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming a Work Travel Participant';
                                                    if(ap.RecordTypeId == Constants.Centers_Record_Type_Id)lstusers[0].User_Interests__c='Studying English';
                                                    if(ap.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id)lstusers[0].User_Interests__c='Finding an internship';
                                                    if(ap.RecordTypeId == Constants.AuPairCareHF_Record_Type_Id)lstusers[0].User_Interests__c='Hosting an au pair';
                                                    if(ap.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming an au pair';
                                                    
                                                    //update lstusers[0];           
                                                } 
                                            }
                                            else
                                            {
                                                list<Applicant_Info__c> AllExistingAppInfo = [select id, CreatedBy__c, name from Applicant_Info__c  where Account__c =: ap.Account__c and CreatedBy__r.Profile.Name = 'OCPM PT' order by createdDate DESC];
                                                if(AllExistingAppInfo!=null && AllExistingAppInfo.size()>0)
                                                {
                                                    lstusers = [SELECT Id, Username,User_Interests__c,Email FROM User WHERE Id=:AllExistingAppInfo[0].CreatedBy__c order by createdDate DESC];
                                                    if(lstusers != NULL && lstusers.size() > 0)
                                                    {
                                                        ap.CreatedBy__c = lstusers[0].Id;
                                                        if(ap.RecordTypeId == Constants.AyusaHF_Record_Type_Id)lstusers[0].User_Interests__c='Hosting an international student';
                                                        if(ap.RecordTypeId == Constants.AyusaPT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming a high school exchange student';
                                                        if(ap.RecordTypeId == Constants.WT_PT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming a Work Travel Participant';
                                                        if(ap.RecordTypeId == Constants.Centers_Record_Type_Id)lstusers[0].User_Interests__c='Studying English';
                                                        if(ap.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id)lstusers[0].User_Interests__c='Finding an internship';
                                                        if(ap.RecordTypeId == Constants.AuPairCareHF_Record_Type_Id)lstusers[0].User_Interests__c='Hosting an au pair';
                                                        if(ap.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming an au pair';
                                                        //update lstusers[0]; 
                                                    }
                                                }
                                            }
                                        }
                                        else if(ap.CreatedBy__c!=null && ap.CreatedBy__r.Profile.Name == 'OCPM PT')
                                       
                                        {
                                            lstusers = [SELECT Id, Username,User_Interests__c,Email FROM User WHERE Id=:ap.CreatedBy__c order by createdDate DESC];                            
                                            if(lstusers != NULL && lstusers.size() > 0)
                                            {
                                                if(ap.RecordTypeId == Constants.AyusaHF_Record_Type_Id)lstusers[0].User_Interests__c='Hosting an international student';
                                                if(ap.RecordTypeId == Constants.AyusaPT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming a high school exchange student';
                                                if(ap.RecordTypeId == Constants.WT_PT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming a Work Travel Participant';
                                                if(ap.RecordTypeId == Constants.Centers_Record_Type_Id)lstusers[0].User_Interests__c='Studying English';
                                                if(ap.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id)lstusers[0].User_Interests__c='Finding an internship';
                                                if(ap.RecordTypeId == Constants.AuPairCareHF_Record_Type_Id)lstusers[0].User_Interests__c='Hosting an au pair';
                                                if(ap.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id)lstusers[0].User_Interests__c='Becoming an au pair';
                                                //update lstusers[0];
                                            }
                                        }
                                    }
                                    //If(lstusers.size()>0)
                                    //update lstusers[0];
                                }
                            }
                            
                            //B-02147 End          //if(ap.RecordTypeId == N/A)lstusers[0].User_Interests__c='Looking for an intern';
                            
                            
                            
                            // B-01688
                            if(ap.Engagement_Start__c != null && ap.Intrax_Program__c == 'Internship'){
                                ap.Program_Year__c = string.ValueOf(ap.Engagement_Start__c.Year());
                            }
                            
                            // B-01630  (End) 
                            
                            strAppInfoName = ap.name;
                            string partner_id_old = trigger.oldMap.get(ap.Id).Partner_Intrax_Id__c;
                            string partner_id_new = trigger.newMap.get(ap.Id).Partner_Intrax_Id__c;
                            
                            string partner_name_old = trigger.oldMap.get(ap.Id).Partner_Account__c;
                            string partner_name_new = trigger.newMap.get(ap.Id).Partner_Account__c;
                            string stage_old = trigger.oldMap.get(ap.Id).Application_Stage__c;
                            string stage_new = trigger.newMap.get(ap.Id).Application_Stage__c;
                            string level_old = trigger.oldMap.get(ap.Id).Application_Level__c;
                            string level_new = trigger.newMap.get(ap.Id).Application_Level__c;
                            
                            if(partner_id_new != null ){
                                if(partner_id_old != partner_id_new){
                                    try{
                                        Account partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                                                  WHERE Intrax_Id__c =: partner_id_new
                                                                  AND type = 'Partner'];
                                        
                                        ap.Partner_Account__c = partnerAccount.Id;
                                        ap.Pluto_Id__c = partnerAccount.Pluto_Id__c;
                                        if(ap.RecordTypeId != Constants.AuPairCarePT_Record_Type_Id && ap.RecordTypeId != Constants.AyusaPT_Record_Type_Id )//B-03166
                                        {
                                         ap = ApplicantInfoHelper.setApp_IntraxRegion_and_Market(ap, partnerAccount.Name);
                                        } 
                                        //B-03166  
                                        system.debug('partner_id_old' +partner_id_old); 
                                        system.debug('partner_id_new' +partner_id_new);  
                                        if((partner_id_old == null && partner_id_new!=null) || (partner_id_old != partner_id_new && ap.Type__c == 'Participant') && (ap.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id || ap.RecordTypeId == Constants.AyusaPT_Record_Type_Id))
                                        {
                                         system.debug('partner_id_old' +partner_id_old);
                                         ApplicantInfoHelper.setApp_IntraxRegion_and_MarketForPT(ap);
                                        }
                                        // B-03166 
                                   
                                    }
                                    catch(Exception e){
                                        system.debug('Please, insert a valid Intrax Partner ID: ' + e);
                                    }
                                }
                            }else{
                                ap.Partner_Account__c = null;
                            }
                            
                            // B-02286   Second Placement
                            
                            if (ap.Intrax_Program__c == 'Internship')
                            {
                                Date eng_start_date_old = trigger.oldMap.get(ap.Id).Engagement_Start__c;
                                Date eng_start_date_new = trigger.newMap.get(ap.Id).Engagement_Start__c;
                                Date eng_end_date_old = trigger.oldMap.get(ap.Id).Engagement_End__c;
                                Date eng_end_date_new = trigger.newMap.get(ap.Id).Engagement_End__c;
                                
                                if (eng_start_date_new!=null && eng_end_date_new!=null)
                                    if (eng_start_date_old!=eng_start_date_new || eng_end_date_old!=eng_end_date_new )
                                {
                                    List<Position_Info__c>  listPositionInfo = [Select pos.Id, pos.Applicant_Info__c, pos.Placement_Number__c, pos.End_Date__c, pos.Start_Date__c
                                                                                FROM Position_Info__c pos 
                                                                                where pos.Applicant_info__c != '' and pos.Applicant_info__c =: ap.Id and pos.Placement_Number__c!=2];
                                    
                                    
                                    if(listPositionInfo!=null && listPositionInfo.size() > 0) {
                                        system.debug('listPositionInfo : ' + listPositionInfo);
                                        listPositionInfo[0].Placement_Number__c=1;
                                        listPositionInfo[0].Start_Date__c=eng_start_date_new;
                                        listPositionInfo[0].End_Date__c=eng_end_date_new;
                                        update listPositionInfo[0];
                                    }
                                    
                                    
                                    List<Position_Info__c> listPositionInfoSecond = [Select pos.Id, pos.Applicant_Info__c, pos.Placement_Number__c,  pos.End_Date__c, pos.Start_Date__c
                                                                                     FROM Position_Info__c pos 
                                                                                     where pos.Applicant_info__c != '' and pos.Applicant_info__c =: ap.Id and pos.Placement_Number__c=2];
                                    
                                    
                                    if(listPositionInfoSecond!=null && listPositionInfoSecond.size() > 0) {
                                        system.debug('listPositionInfoSecond : ' + listPositionInfoSecond);
                                        listPositionInfoSecond[0].Placement_Number__c=2;
                                        listPositionInfoSecond[0].End_Date__c=eng_end_date_new;
                                        listPositionInfo[0].End_Date__c=listPositionInfoSecond[0].Start_Date__c;
                                        update listPositionInfoSecond[0];
                                        update listPositionInfo[0];
                                        
                                    } 
                                    
                                    
                                }  
                            }
                            
                            if(appInfoIds!=null && appInfoIds.size()>0){
                                flag='before';
                                SharingSecurityHelper.persistSharingWithOwner(app_share, flag, appInfoIds); 
                            }
            
                            
                            for(Applicant_Info__c record: trigger.new)
                            {
                                string newString = ''; 
                                string newIPO='';                                                                   
                                
                                /*
                                if(record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId && Trigger.oldMap.get(record.Id).OwnerId!=null)
                                {
                                    appInfoIds.add(record.Id);
                                    system.debug('**appInfoIds***'+appInfoIds);
                                    if(!(blnDeployTestFlag))
                                    {   
                                        
                                        //Added by Saroj for Manual Sharing Issue (Start)
                                        AppSharetoPersist = [Select a.UserOrGroupId, a.RowCause, a.ParentId, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.AccessLevel From Applicant_Info__Share a 
                                                             WHERE  a.ParentId = :record.Id AND 
                                                             RowCause = 'Manual'];
                                        
                                        
                                        if(AppSharetoPersist != NULL && AppSharetoPersist.size()>0)
                                        {
                                            list<string> lststr = new list<string>();
                                            for(Applicant_Info__Share appshr :AppSharetoPersist)
                                            {
                                                Manual_Sharing_Info__c newmShare = new Manual_Sharing_Info__c();
                                                newmShare.Object_ID__c = record.Id;
                                                newmShare.User_ID__c = appshr.UserOrGroupId;
                                                ManualShareInfolst.add(newmShare);
                                                //lststr.add(appshr.UserOrGroupId);
                                            }
                                        }
                                        //Added by Saroj for Manual Sharing Issue (End)
                                        
                                        
                                        SharingSecurityHelper.persistAppInfoSharing(
            JSON.serialize(
            [Select a.UserOrGroupId, a.RowCause, a.ParentId, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.AccessLevel From Applicant_Info__Share a 
            WHERE  a.ParentId IN :appInfoIds AND 
            RowCause = 'Manual']));
                                    }
                                }*/
                                system.debug('**Here***');
                                system.debug('**record.Intrax_Program_Options__c***'+record.Intrax_Program_Options__c);
                                system.debug('**record.Intrax_Program_Category__c***'+record.Intrax_Program_Category__c);
                                string strIPOValues;
                                boolean blnExists=false;
                                if(record.Intrax_Program_Options__c!=null)
                                {
                                    strIPOValues= record.Intrax_Program_Options__c;
                                }
                                
                                If((record.Intrax_Program_Category__c=='Business' || record.Intrax_Program_Category__c=='Information Media & Communications' || record.Intrax_Program_Category__c=='Public Administration & Law' || record.Intrax_Program_Category__c=='Engineering')) 
                                {
                                    
                                    newIPO += 'Business Internship';            
                                } 
                                else if(record.Intrax_Program_Category__c=='Social Development')  
                                {
                                    
                                    newIPO += 'Social Development';
                                } 
                                else if(record.Intrax_Program_Category__c=='Hospitality & Tourism')  
                                {
                                    
                                    newIPO += 'Hospitality Internship';
                                }    
                                if(strIPOValues!=null)
                                {
                                    if(strIPOValues.contains('Practical Training') || strIPOValues.contains('Internship Group') || strIPOValues.contains('Internship - J1') || strIPOValues.contains('WEST'))
                                        blnExists = true;
                                    
                                    List<String> partsIPO = strIPOValues.split(';');       
                                    if(blnExists)
                                    {             
                                        for(String s: partsIPO)
                                        {
                                            if(s.contains('Practical Training'))
                                                newString = newString + s + ';' ;
                                            
                                            if(s.contains('Internship Group'))
                                                newString = newString + s + ';' ;
                                            
                                            if(s.contains('Internship - J1'))
                                                newString = newString + s + ';' ;
                                            
                                            if(s.contains('WEST'))
                                                newString = newString + s + ';' ;
                                            
                                        }
                                    }
                                }
                                //  (Trigger.oldMap.get(record.Id).Intrax_Program_Category__c != Trigger.newMap.get(record.Id).Intrax_Program_Category__c )
                                if(record.Intrax_Program__c=='Internship' && record.RecordTypeId==Constants.ICD_Intern_PT_Record_Type_Id)
                                {
                                    record.Intrax_Program_Options__c= newString + newIPO ;
                                    system.debug('**record.Intrax_Program_Options__c **'+record.Intrax_Program_Options__c );
                                }
                                
                                
                            }
                            /*
                            //Added by Saroj for Manual Sharing Issue (Start)
                            if (ManualShareInfolst != NULL && ManualShareInfolst.size()>0)
                            {
                                insert ManualShareInfolst;
                            }
                            //Added by Saroj for Manual Sharing Issue (End)
                            */
                            //Check if Application is Approved
                            /*Person_Info__c personInfo = [SELECT Id, First_Name__c, Last_Name__c, Gender__c, Date_of_Birth__c, Citizenship__c, Email__c, Mobile__c,
            Phone__c, Skype_Id__c, Best_Call_Time__c, Primary_Applicant__c 
            FROM Person_Info__c WHERE applicant_Info__c =: ap.Id and Primary_Applicant__c =: true];
            system.debug('******** Are we here?');
            IUtilities.AppToRelatedObjectSync(ap, personInfo);*/
                            //Exclude Apc for Lead conversion
                            //Map<ID, Schema.RecordTypeInfo> aprtMap = Schema.SObjectType.Applicant_Info__c.getRecordTypeInfosById();
                            //String Recordtype = aprtMap.get(ap.RecordTypeId).getName();
                            Lead theLead;
                            if (ap.Lead__c != NULL){// && Recordtype !='AuPairCare HF' || Recordtype !='AuPairCare PT'){
                                theLead = [select isConverted,ConvertedAccountId, Intrax_Programs__c, Intrax_Program_Options__c, Intrax_Region__c, Countries_of_Interest__c, Last_Applicant_Update__c, Lead_Type__c, 
                                           Location_of_Interest__c, Functional_Areas__c, Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c, Desired_Start_Date__c, Street, City, State, Country, PostalCode, How_Heard__c, RB_First_Name__c, 
                                           RB_Last_Name__c, Reason__c, Reason_Detail__c, Phone, Enquiry_Channel__c, FirstName, LastName, Gender__c, Date_of_Birth__c, Citizenship__c, Email, MobilePhone, Skype_Id__c, Best_Call_Time__c
                                           from Lead 
                                           where Id = :ap.Lead__c];
                            } 
                            //Ay 358 - commented as on 10/01/2014
                            if (
                                (level_old!=level_new && level_new == 'Main' && ap.Application_Stage__c== 'Working') || 
                                (stage_old!=stage_new && ap.Application_Level__c== 'Main' && stage_new== 'Working')  || 
                                (ap.Application_Level__c== 'Main' && stage_new== 'Working' && ap.Opportunity_Name__c==null) ||
                                (ap.Application_Level__c== 'Basic' && stage_new== 'Working' && ap.Opportunity_Name__c==null && 
                                 ap.Intrax_Program__c == 'AuPairCare' && ap.Type__c == 'Host Family'))                   
                            {
                                // Add the logic to convert Lead to Acc and Opp
                                
                                if (ap.Lead__c != NULL){
                                    /* Commented out per CN 80 --> Code move a few lines above
            Lead theLead = [select isConverted,ConvertedAccountId, Intrax_Programs__c, Intrax_Program_Options__c, Intrax_Region__c, Countries_of_Interest__c, Last_Applicant_Update__c, Lead_Type__c, 
            Location_of_Interest__c, Functional_Areas__c, Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c, Desired_Start_Date__c, Street, City, State, Country, PostalCode, How_Heard__c, RB_First_Name__c, 
            RB_Last_Name__c, Reason__c, Reason_Detail__c, Phone, Enquiry_Channel__c, FirstName, LastName, Gender__c, Date_of_Birth__c, Citizenship__c, Email, MobilePhone, Skype_Id__c, Best_Call_Time__c
            from Lead 
            where Id = :ap.Lead__c];
            */
                                    //If lead is converted handle it here
                                    // If lead is added new, it won't work here and hence added to after update
                                    if (theLead.IsConverted){
                                        System.debug('Lead is already converted');
                                        if (ap.Account__c == NULL ){
                                            system.debug('Account not tagged yet');
                                            ap.Account__c = theLead.ConvertedAccountId;
                                            
                                            if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test'))) 
                                                Sharing_Security_Controller.shareAccount(theLead.ConvertedAccountId,ap.createdBy__c);
                                        }
                                        else{
                                            if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test'))) 
                                                Sharing_Security_Controller.shareAccount(ap.Account__c ,ap.createdBy__c);
                                            system.debug('Account is already tagged');
                                        }
                                    }
                                    
                                    
                                }
                                else{
                                    if (ap.Account__c != NULL){
                                        system.debug('Lead not present, but account already tagged');  
                                        if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test'))) Sharing_Security_Controller.shareAccount(ap.Account__c ,ap.createdBy__c);                       
                                    }
                                    else{
                                        system.debug('Create Lead and Convert');
                                    }
                                }
                                if(ap.Account__c != NULL){
                                    
                                     //MT-289
                                    /*String associatedOpportunityBaseQuery = 'select Id,Name,StageName, isClosed, Type, Intrax_Programs__c, AccountId, '+
                                                                                'Intrax_Program_Options__c, Intrax_Region__c, Countries_of_Interest__c, '+
                                                                                'Last_Applicant_Update__c,Location_of_Interest__c,Functional_Areas__c, Position_Types__c,'+
                                                                                'Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c,'+
                                                                                ' Engagement_Start__c, Engagement_End__c, How_Heard__c, RB_First_Name__c, RB_Last_Name__c, Reason__c, '+
                                                                                'Reason_Detail__c, Enquiry_Channel__c from Opportunity '+
                                                                                'where Type = \''+ap.Type__c+'\' and Intrax_Programs__c = \''+ap.Intrax_Program__c+'\' and '+
                                                                                'Parent_Opportunity__c = null  and AccountId = \''+ap.Account__c+'\'';
                                    //For all applications except AP EU Applications
                                    Boolean isNonEUAPApplication = true;
                                    System.debug('isNonEUAPApplication:'+isNonEUAPApplication);
                                    if (ap.Type__c == 'Participant'){
                                        isNonEUAPApplication = ap.Partner_Intrax_Id__c!=null && ap.Partner_Intrax_Id__c!='I-0000283'&& ap.Partner_Intrax_Id__c!='I-0000066'&& ap.Partner_Intrax_Id__c!='I-0468328' && ap.Partner_Intrax_Id__c!='I-0468327' && ap.Partner_Intrax_Id__c!='I-0468330' && ap.Partner_Intrax_Id__c!='I-0011701';
                                    }
                                    System.debug('isNonEUAPApplication after:'+isNonEUAPApplication);
                                    if(isNonEUAPApplication){
                                        associatedOpportunityBaseQuery = associatedOpportunityBaseQuery + ' and StageName not in ( \'Closed Cancel\' , \'Closed Won\' , \'Closed Lost\' ) order by lastModifiedDate desc';
                                    }
                                    System.debug('associatedOpportunityBaseQuery:'+associatedOpportunityBaseQuery);
                                    list<Opportunity> associatedOpportunity = Database.Query(associatedOpportunityBaseQuery);*/
                                    
                                    list<Opportunity> associatedOpportunity = [select Id,Name,StageName, isClosed, Type, Intrax_Programs__c, AccountId, Intrax_Program_Options__c, Intrax_Region__c, Countries_of_Interest__c, Last_Applicant_Update__c, 
                                                                               Location_of_Interest__c, Functional_Areas__c, Position_Types__c, Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c, Engagement_Start__c, Engagement_End__c, How_Heard__c, 
                                                                               RB_First_Name__c, RB_Last_Name__c, Reason__c, Reason_Detail__c, Enquiry_Channel__c
                                                                               from Opportunity where 
                                                                               //isClosed != true and -- Commented as per AYUSA 508
                                                                               Type = :ap.Type__c and Intrax_Programs__c = :ap.Intrax_Program__c and
                                                                               Parent_Opportunity__c = null  and AccountId = :ap.Account__c and StageName not in ( 'Closed Cancel' ,'Closed - Cancelled', 'Closed Won' , 'Closed Lost' ) order by lastModifiedDate desc];
                                    // StageName != 'Closed Cancel'   
                                    if (associatedOpportunity.size() > 0){
                                        system.debug('****** Opportunity present. Now Checking status...');
                                        
                                        // || associatedOpportunity[0].StageName == 'Closed Lost'
                                        if( associatedOpportunity[0].StageName == 'Prospecting' || associatedOpportunity[0].StageName == 'Review' || associatedOpportunity[0].StageName == 'Qualified'  ){
                                            associatedOpportunity[0].StageName = 'Processing';
                                        }
                                        
                                        
                                        if (associatedOpportunity[0].StageName != 'Closed Won' && associatedOpportunity[0].StageName !='Closed Lost' &&  associatedOpportunity[0].StageName !='Closed Cancel' && associatedOpportunity[0].StageName !='Closed - Cancelled' && ap.Application_Stage__c!='Accepted' && ap.Application_Stage__c!='Cancelled' )
                                        {
                                            update associatedOpportunity[0];
                                        }                            
                                        //associatedOpportunity[0].StageName = 'Processing'; AYUSA 508 - Assigned included in the previous if statement
                                        
                                        ap.Opportunity_Name__c = associatedOpportunity[0].Id;
                                    }
                                    
                                    
                                    else{
                                        system.debug('****** Opportunity not present');
                                        //Get the owner of the Account and check if active
                                        List<Account> ownerId = [select ownerId from Account where id = :ap.Account__c];
                                        List<User> activeOwner = [select Id from User where Id = :ownerId[0].ownerId and isActive = true];
                                        Opportunity newOpp = new Opportunity();
                                        
                                        if (activeOwner.size()== 0){
                                            //Get the default owner from Queue
                                            List<OpportunityOwners__c> ownerMap = OpportunityOwners__c.getAll().values();
                                            
                                            //If owner is Queue, reassign
                                            for (OpportunityOwners__c owner : ownerMap){
                                                if (owner.QueueName__c == 'Default'){
                                                    List<User> theNewOwner = [select Id from User where userName = :owner.OwnerForLeadConvert__c];
                                                    newOpp.OwnerId = theNewOwner[0].Id;
                                                }
                                            }
                                        }
                                        else{
                                            newOpp.OwnerId = ownerId[0].ownerId;
                                        }
                                        system.debug('**aaplicant Name ****'+ap.Name);
                                        newOpp.Intrax_Programs__c = ap.Intrax_Program__c;
                                        system.debug('**aaplicant Name Record type ****'+ap.RecordType.Name);
                                        string appName;
                                        appName = ap.name;
                                        system.debug('**aaplicant Name-1 ****'+appName);
                                        if(ap.Intrax_Program__c == 'Work Travel' && ap.type__c=='Participant' && (!(ap.Name.contains('-WT'))))
                                        { 
                                            Integer adYear ;                
                                            if(ap.Engagement_End__c!=null)
                                            {
                                                adYear = ap.Engagement_End__c.year();           
                                                if (ap.Season__c == 'Winter')
                                                {
                                                    adYear = adYear -1;
                                                }
                                                ap.Program_Year__c = string.valueOf(adYear);
                                            }
                                            appName = appName +'-WT'+adYear;
                                            system.debug('**aaplicant Name-2 ****'+appName);
                                        }  else
                                        {
                                            
                                            //EU 107
                                            if(ap.Intrax_Program__c == 'Ayusa' && ap.type__c=='Host Family' && (!(ap.Name.contains('-AY'))))
                                            {
                                                Integer adYear;
                                                if(ap.Engagement_Start__c!=null)
                                                {
                                                    adYear = ap.Engagement_Start__c.year();
                                                    adYear = adYear+1;
                                                }
                                                appName = appName +'-AY'+adYear;                      
                                            }
                                            else if(ap.Intrax_Program__c == 'Ayusa' && ap.type__c=='Participant' && (!(ap.Name.contains('-AY'))))
                                            {
                                                if(ap.Program_Year__c!= null){
                                                    String[] proYearSplit = ap.Program_Year__c.split('-');
                                                    String adYear = proYearSplit[1];
                                                    appName = appName +'-AY'+adYear;
                                                }
                                            }
                                            else if(ap.Intrax_Program__c == 'AuPairCare' &&  (!(ap.Name.contains('-APC'))) && (ap.type__c=='Participant' || ap.type__c=='Host Family'))
                                            {
                                                Integer adYear;
                                               /* if(ap.US_Arrival_date__c!= null)
                                                {
                                                    adYear = ap.US_Arrival_date__c.year();
                                                    adYear = adYear+1;
                                                }*/
                                                 if(ap.Engagement_Start__c!=null)
                                                {
                                                    adYear = ap.Engagement_Start__c.year();
                                                   system.debug('@@adYear' +adYear);  
                                                }
                                              
                                                appName = appName +'-APC'+adYear;  
                                            
                                            }                  
                                        }
                                        newOpp.Name = appName;
                                        newOpp.CloseDate = date.today();
                                        if(ap.Intrax_Program_Options__c!=null && ap.Intrax_Program_Options__c !='') //B-03197
                                        {
                                         newOpp.Intrax_Program_Options__c = ap.Intrax_Program_Options__c;
                                        } 
                                        newOpp.Type = ap.Type__c;
                                        newOpp.Intrax_Region__c = ap.Intrax_Region__c;
                                        newOpp.Countries_of_Interest__c = ap.Country_of_Interest__c;
                                        newOpp.Projects_of_Interest__c = ap.Projects_of_Interest__c;
                                        newOpp.Functional_Areas__c = ap.Functional_Areas__c;
                                        newOpp.Position_Types__c = ap.Position_Types__c;
                                        newOpp.Intrax_Center__c = ap.Intrax_Center__c;
                                       /*if(ap.Intrax_Program__c != 'Ayusa' && ap.type__c!='Participant')
                                        {*/
                                         newOpp.Service_Level__c = ap.Service_Level__c;
                                         newOpp.Location_of_Interest__c = ap.Location_of_Interest__c;
                                        //}
                                        newOpp.Program_Start__c = ap.Program_Start__c;
                                        newOpp.Intrax_Program_Category__c  = ap.Intrax_Program_Category__c;
                                        //B-2452. Skipping mapping of program year for Ayusa Germany.. AP
                                       // if(ap.Partner_Intrax_Id__c != 'I-0000283' && ap.Intrax_Program__c != 'Ayusa' && ap.type__c!='Participant'){
                                        if(ap.Program_Year__c!=null && ap.Program_Year__c !='') //B-03197
                                         {
                                         newOpp.Program_Year__c = ap.Program_Year__c;
                                         }
                                         newOpp.Program_Duration__c = ap.Program_Duration__c;// D-01706
                                      //  }
                                        newOpp.Engagement_Start__c = ap.Engagement_Start__c;
                                        newOpp.Engagement_End__c = ap.Engagement_End__c;
                                        newOpp.How_Heard__c = ap.How_Heard__c;
                                        newOpp.RB_First_Name__c = ap.RB_First_Name__c;
                                        newOpp.RB_Last_Name__c = ap.RB_Last_Name__c;
                                        newOpp.Reason__c = ap.Reason__c;
                                        newOpp.Reason_Detail__c = ap.Reason_Detail__c;
                                        newOpp.StageName = 'Processing';
                                        newOpp.AccountId = ap.Account__c;
                                        // CN 80 - field additions
                                        newOpp.Last_Applicant_Update__c = ap.Last_Applicant_Update__c;
                                        newOpp.Enquiry_Channel__c = ap.Enquiry_Channel__c;
                                        // IGI 640 - Setting Partner Id
                                        newOpp.Partner_Account__c = ap.Partner_Account__c;
                                        
                                        insert newOpp;  
                                        system.debug('**aaplicant Name-3 ****'+newOpp.Name);
                                        system.debug('**aaplicant Name-3 ****'+ap.Name);
                                        system.debug('*****newOpp*****'+newOpp);       
                                        ap.Opportunity_Name__c = newOpp.Id; 
                                    }
                                }
                            }
                            //Ay 358 End - commented as on 10/01/2014
                            
                            // CN 80 - Sync Account fields
                            /*
            list<Person_Info__c> personInfo = [SELECT Id, First_Name__c, Last_Name__c, Gender__c, Date_Of_Birth__c, Citizenship__c, email__c, Mobile__c, Phone__c, Skype_Id__c, Best_call_Time__c, Applicant_Info__c 
            FROM Person_Info__c 
            WHERE Applicant_Info__c =: ap.Id and Primary_Applicant__c =: true LIMIT 1];             
            */
                            //B-03337.  This should happen before syncAppOpp, so the submitted date copies to opp's application date
                            if(stage_old!=stage_new && stage_new=='Submitted' && ap.Submitted_Date__c==null){
                                ap.Submitted_Date__c = System.Today();
                            }
            
                           System.debug('Has already synced fields:'+ApplicantInfoHelper.hasalreadySyncedFields());
                           system.debug('**aaplicant Name-3 ****'+ap.Name);
                            // CN 80 - sync opportunity fields
                            if(!ApplicantInfoHelper.hasalreadySyncedFields()){
                                if (ap.Intrax_Program__c != 'AuPairCare')
                                {
                                    if(ap.Account__c != null) ApplicantInfoHelper.syncAccountFields(ap.Account__c, ap);  
                                    if(ap.Lead__c != null && !ap.Lead__r.isConverted) ApplicantInfoHelper.syncLeadFields(theLead, ap);
                                    
                                    if(ap.Opportunity_Name__c != null) {
                                        
                                        Opportunity op = [select Id,Name,StageName
                                                          from Opportunity
                                                          Where Id =: ap.Opportunity_Name__c];
                                        //       
                                        if (ap.Application_Stage__c!='Accepted' && ap.Application_Stage__c!='Cancelled' && op.StageName != 'Closed Won' && op.StageName !='Closed Lost'  &&  op.StageName !='Closed Cancel')
                                        {
                                            ApplicantInfoHelper.syncOppFields(ap.Opportunity_Name__c, ap);
                                        }    
                                    }
                                }
                                else if (ap.Intrax_Program__c == 'AuPairCare' && ap.Application_Type__c != 'Extension' && ap.Application_Type__c != 'Renewal')
                                {
                                    if(ap.Account__c != null) ApplicantInfoHelper.syncAccountFields(ap.Account__c, ap);  
                                    if(ap.Lead__c != null && !ap.Lead__r.isConverted) ApplicantInfoHelper.syncLeadFields(theLead, ap);
                                    
                                    if(ap.Opportunity_Name__c != null) {
                                        
                                        Opportunity op = [select Id,Name,StageName
                                                          from Opportunity
                                                          Where Id =: ap.Opportunity_Name__c];
                                        //       
                                        if (ap.Application_Stage__c!='Accepted' && ap.Application_Stage__c!='Cancelled' && op.StageName != 'Closed Won' && op.StageName !='Closed Lost'  &&  op.StageName !='Closed Cancel')
                                        {
                                            ApplicantInfoHelper.syncOppFields(ap.Opportunity_Name__c, ap);
                                        }    
                                    }
                                }
                                
                            }
                            
                            
                            //B-02245
                            string rtName = Schema.SObjectType.Applicant_Info__c.getRecordTypeInfosById().get(ap.RecordTypeId).getName();
                            
                            if(rtName== 'AuPairCare PT' && ap.Country_of_Interest__c != NULL && ap.Partner_Intrax_Id__c == NULL && ap.Partner_Account__c == NULL){
                                //List<Lead_Routing__c> leadRoutesQuery = new List<Lead_Routing__c>();
                                List<LeadRouting__c> leadRoutesQuery = new List<LeadRouting__c>();
                                List<Person_Info__c> personInfo = new List<Person_Info__c>();
                                String PartnerAccountName, PartnerIntraxID;
                                
                                personInfo= [SELECT Id, Name, Applicant_Info__c,Primary_Applicant__c, Citizenship__c FROM Person_Info__c WHERE Applicant_Info__c =: ap.Id AND Primary_Applicant__c = TRUE LIMIT 1];
                                if(personInfo!=NULL && personInfo.size()>0){
                                    System.debug('-------ap.Country_of_Interest__c:'+ap.Country_of_Interest__c);
                                    System.debug('-------personInfo[0].Id:'+personInfo[0].Id);
                                    System.debug('-------personInfo[0].Citizenship__c:'+personInfo[0].Citizenship__c);
                                    if(personInfo[0].Citizenship__c != NULL){
                                        //leadRoutesQuery = [select Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c,Partner_Intrax_Id__c FROM Lead_Routing__c WHERE (Country_Of_Origin__c = :personInfo[0].Citizenship__c AND Lead_Type__c = 'Participant' AND Program__c = 'AuPairCare' AND Country_of_Interest__c = :ap.Country_of_Interest__c) ORDER BY Priority__c ASC LIMIT 1];
                                        leadRoutesQuery = [select Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c,Partner_Intrax_Id__c FROM LeadRouting__c WHERE (Country_Of_Origin__c = :personInfo[0].Citizenship__c AND Lead_Type__c = 'Participant' AND Program__c = 'AuPairCare' AND Country_of_Interest__c = :ap.Country_of_Interest__c and NewRule__c = false) ORDER BY Priority__c ASC LIMIT 1];                            
                                        System.debug('-------size:'+leadRoutesQuery.size());
                                        if(leadRoutesQuery != NULL && leadRoutesQuery.size()>0){
                                            if(leadRoutesQuery[0].Partner_Intrax_Id__c != NULL){
                                                PartnerIntraxID = leadRoutesQuery[0].Partner_Intrax_Id__c;
                                            }
                                        }
                                        System.debug('-------PartnerIntraxID:'+PartnerIntraxID);
                                        if(PartnerIntraxID != null ){               
                                            try{
                                                Account partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                                                          WHERE Intrax_Id__c =: PartnerIntraxID
                                                                          AND type = 'Partner']; 
                                                System.debug('-------size 2:'+PartnerAccount.Intrax_Id__c);
                                                if(partnerAccount != NULL)  {                         
                                                    ap.Partner_Account__c = partnerAccount.Id;
                                                    ap.Partner_Intrax_Id__c = partnerAccount.Intrax_Id__c;
                                                    ap.Pluto_Id__c = partnerAccount.Pluto_Id__c;
                                                    ap.Sales_Notes__c = 'Auto-Assigned To Partner';//Used in notifications also as triggering criteria
                                                    if(ap.RecordTypeId != Constants.AuPairCarePT_Record_Type_Id && ap.RecordTypeId != Constants.AyusaPT_Record_Type_Id )  //B-03166
                                                    {
                                                     ap = ApplicantInfoHelper.setApp_IntraxRegion_and_Market(ap, partnerAccount.Name);
                                                    } 
                                                }
                                            }
                                            catch(Exception e){
                                                system.debug('Please, insert a valid Intrax Partner ID: ' + e);
                                            }
                                        }                      
                                    }                    
                                }                    
                            }//End of B-02245     
                          /*  if ((ap.Intrax_Program__c == 'Work Travel') && (ap.Application_Stage__c=='Accepted') && (ap.CreatedBy__r.Profile.Name !='OCPM PT') && (ap.Link_Token__c == null))
                            {
                                Blob b = Crypto.GenerateAESKey(128);
                                String h = EncodingUtil.ConvertTohex(b);
                                ap.Link_Token__c = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
                            }  //B-2480                                     
                         */
                         if(rtName == 'AuPairCare HF' && (ap.Application_Type__c == 'Original' || ap.Application_Type__c == 'Renewal' || ap.Application_Type__c == 'Rematch') && ap.PageStatus_Complete__c != trigger.oldMap.get(ap.Id).PageStatus_Complete__c && ap.Position__c != NULL)
                         {
                            if (ap.PageStatus_Complete__c != NULL)
                            {
                                if(ap.PageStatus_Complete__c.contains('001') && ap.PageStatus_Complete__c.contains('003') && ap.PageStatus_Complete__c.contains('004') && ap.PageStatus_Complete__c.contains('005') && ap.PageStatus_Complete__c.contains('007') && ap.PageStatus_Complete__c.contains('044'))
                                {
                                    AppTriggerHelper.UpdPosProfile(ap.Position__c);
                                }
                            }
                         }
                          system.debug('**aaplicant Name-3 ****'+ap.Name);
                         if(rtName == 'AuPairCare HF' && (ap.Application_Type__c == 'Original' || ap.Application_Type__c == 'Extension') && ap.Position__c != NULL && ap.PageStatus_Complete__c != NULL && (ap.PageStatus_Complete__c != trigger.oldMap.get(ap.Id).PageStatus_Complete__c || ap.Terms_Accepted_Date__c != trigger.oldMap.get(ap.Id).Terms_Accepted_Date__c || ap.Terms_Accepted__c != trigger.oldMap.get(ap.Id).Terms_Accepted__c))
                         {
                            if(ap.PageStatus_Complete__c.contains('009') && ap.PageStatus_Complete__c.contains('045') && ap.Terms_Accepted_Date__c != NULL && ap.Terms_Accepted__c == true)
                            {
                                ap.Application_Stage__c = 'Accepted';
                                AppTriggerHelper.UpdPosStatus(ap.Position__c);
                            }
                         }
                         system.debug('***** Application Owner trig'+ap.ownerId);
                        } 
            }
                        
        }
    
            }
    if(trigger.isBefore){
        if(trigger.isInsert){
            string app;
            system.debug('******Inside Trigger*********');
            for(Applicant_Info__c ap: trigger.new)
            {
                system.debug('***** Application Owner trig'+ap.ownerId);
                string rtName = Schema.SObjectType.Applicant_Info__c.getRecordTypeInfosById().get(ap.RecordTypeId).getName();
                system.debug('Record Type of Application: ' + rtName);
                strAppInfoName = ap.name;             
                //Map to hold the Queue Name as a Key and Queue Id as Value
                Lead objLead;
                User user = [Select Id, ContactId,Type__c,Intrax_Id__c,User_Interests__c from User where Id =: UserInfo.getUserId()]; 
                if(user!=null)
                    app = user.User_Interests__c ;
                
                Map<String, Id> maptoHoldQueueNameWithQueueID = new Map<String, Id>();
                
                List<QueueSobject> lstQue =[Select Id, Queue.Name, Queue.ID from QueueSobject WHERE Queue.Name =: Constants.QUEUE_NAME OR Queue.Name =: Constants.QUEUE_APC_NAME OR Queue.Name =: Constants.QUEUE_APCPT_NAME OR Queue.Name =: Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE OR Queue.name=:Constants.QUEUE_NAME_IGI ];
                
                //Loop through List of Queue
                for(QueueSobject que : lstQue) {
                    
                    //Populating Map with Values
                    maptoHoldQueueNameWithQueueID.put(que.Queue.Name, que.Queue.Id);
                }
                
               
                
                if (ap.Lead__c != NULL){
                    objLead = [select isConverted,ConvertedAccountId,Field_Staff__c,Rating from Lead where Id = :ap.Lead__c];
                    if(objLead!=null){
                        
                        if(ap.OwnerId == objLead.Field_Staff__c && objLead.Rating=='Hot'){
                            ap.OwnerId = objLead.Field_Staff__c;
                            system.debug('****appInfoLead.OwnerId*******'+ap.OwnerId);
                        }
                    }
                    // CN 80 - Updating Lead on Applicant Creation
                    system.debug('***** Has already Synced? ' + ApplicantInfoHelper.hasalreadySyncedFields());
                    if(!ApplicantInfoHelper.hasalreadySyncedFields()) ApplicantInfoHelper.syncLeadFields(objLead, ap);
                }
                //else if(ap.RecordType.Name == 'Centers' || app=='Studying English') 
                else if(rtName == 'Centers' || app=='Studying English') {                
                    
                    //System.debug('Please Enter in this Loop' + ap.RecordType.Name);
                    System.debug('Please Enter in this Loop' + rtName);
                    
                    //Checking presence of value in map
                    if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE) && ap.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE)) {
                        
                        //Populating Account Info Owner Id Field with Queue ID
                        ap.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE);  
                    }  
                } 
                
                else if(rtName == 'ICD Intern PT' || rtName == 'Work Travel PT' || app=='Finding an internship' ) {
                    
                    //System.debug('Please Enter in this Loop' + ap.RecordType.Name);
                    System.debug('Please Enter in this Loop' +rtName);
                    
                    //Checking presence of value in map
                    if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_NAME_IGI  ) && ap.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_IGI  )) {
                        
                        //Populating Account Info Owner Id Field with Queue ID
                        ap.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_IGI );  
                    }  
                }
                
                ////Populating Applicant Info OwnerId field in case of APC Applications
                else if(rtName == 'AuPairCare HF') {
                    
                    System.debug('Please Enter in this Loop1' + ap.RecordType.Name);
                    System.debug('Please Enter in this Loop1' +rtName);
                    
                    //Checking presence of value in map
                    if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_APC_NAME  ) && ap.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_APC_NAME  )) {
                        
                        //Populating Account Info Owner Id Field with Queue ID
                        ap.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_APC_NAME );  
                    } 
                    System.debug('Please Enter in this Loop - owner changed'); 
                }     
                else if(rtName == 'AuPairCare PT' ) {
                    
                    System.debug('Please Enter in this Loop2' + ap.RecordType.Name);
                    System.debug('Please Enter in this Loop2' +rtName);
                    
                    //Checking presence of value in map
                    if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_APCPT_NAME  ) && ap.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_APCPT_NAME  )) {
                        
                        //Populating App Info Owner Id Field with Queue ID
                        ap.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_APCPT_NAME );  
                    } 
                    System.debug('Please Enter in this Loop - owner changed'); 
                }                   
                //Populating Applicant Info OwnerId field in case of Ayusa Applications. 
                //B-01390. Skipping High School Worldwide Applicant Info change of ownership   
                else if(rtName != 'HS Worldwide HF')
                {
                    //System.debug('Please Enter in this Loop' + ap.RecordType.Name);
                    System.debug('Please Enter in this Loop' + rtName);
                    
                    //Checking presence of value in map
                    if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_NAME) && ap.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME)) {
                        
                        //Populating Account Info Owner Id Field with Queue ID
                        ap.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME);  
                    } 
                }
                
                // for(Applicant_Info__c record: Trigger.new)
                // 
                string newString = ''; 
                string newIPO='';
                string strIPOValues;
                boolean blnExists=false;
                if(ap.Intrax_Program_Options__c!=null)
                {
                    strIPOValues= ap.Intrax_Program_Options__c;
                }
                
                
                If((ap.Intrax_Program_Category__c=='Business' || ap.Intrax_Program_Category__c=='Information Media & Communications' || ap.Intrax_Program_Category__c=='Public Administration & Law' || ap.Intrax_Program_Category__c=='Engineering')) 
                {
                    
                    newIPO += 'Business Internship';            
                } 
                else if(ap.Intrax_Program_Category__c=='Social Development')  
                {
                    
                    newIPO += 'Social Development';
                } 
                else if(ap.Intrax_Program_Category__c=='Hospitality & Tourism')  
                {
                    
                    newIPO += 'Hospitality Internship';
                }  
                if(strIPOValues!=null)
                {
                    if(strIPOValues.contains('Practical Training') || strIPOValues.contains('Internship Group') || strIPOValues.contains('Internship - J1') || strIPOValues.contains('WEST'))
                        blnExists = true;
                    
                    List<String> partsIPO = strIPOValues.split(';');      
                    if(blnExists)
                    {             
                        for(String s: partsIPO)
                        {
                            if(s.contains('Practical Training'))
                                newString = newString + s + ';' ;
                            
                            if(s.contains('Internship Group'))
                                newString = newString + s + ';' ;
                            
                            if(s.contains('Internship - J1'))
                                newString = newString + s + ';' ;
                            
                            if(s.contains('WEST'))
                                newString = newString + s + ';' ;
                            
                        }
                    }
                }
                system.debug('**news-3 **'+newString );
                
                if(ap.Intrax_Program_Category__c  != null && ap.Intrax_Program__c=='Internship' && ap.RecordTypeId==Constants.ICD_Intern_PT_Record_Type_Id)
                {
                    ap.Intrax_Program_Options__c= newString + newIPO ;
                }
                
                system.debug('----rtName:' + rtName);
                
                string partner_id_new = ap.Partner_Intrax_Id__c;                
                string partner_name_new = ap.Partner_Account__c; 
               
                if(partner_id_new != null){
                    
                    try{
                        Account partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                                  WHERE Intrax_Id__c =: partner_id_new
                                                  AND type = 'Partner'];                            
                        ap.Partner_Account__c = partnerAccount.Id;
                        ap.Pluto_Id__c = partnerAccount.Pluto_Id__c;
                        if((ap.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id || ap.RecordTypeId == Constants.AyusaPT_Record_Type_Id) && ap.Type__c == 'Participant')
                         {
                          ap = ApplicantInfoHelper.setApp_IntraxRegion_and_MarketForPT(ap);
                         } 
                        else
                        {
                         ap = ApplicantInfoHelper.setApp_IntraxRegion_and_Market(ap, partnerAccount.Name); 
                        }
                    }
                    catch(Exception e){
                        system.debug('Please, insert a valid Intrax Partner ID: ' + e);
                    }
                } 
                else //B-03166
                {
                  if(ap.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id || ap.RecordTypeId == Constants.AyusaPT_Record_Type_Id )
                  {
                   ap = ApplicantInfoHelper.setApp_IntraxRegion_and_MarketForPT(ap);
                  } 
                } //B-03166                                             
                system.debug('***** Application Owner trig'+ap.ownerId);
            }
        }
    }
    
    if(trigger.isAfter){              
        
        if(trigger.isInsert){
            
            for(Applicant_Info__c ap: trigger.new){
                system.debug('***** Application Owner trig'+ap.ownerId);
                strAppInfoName = ap.name;
                set<Id> PartnerRoleId = new set<Id>();
                if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test'))) 
                {
                    Sharing_Security_Controller.shareRecord(ap.id);
                    Sharing_Security_Controller.shareRecordGuestUsers(ap.Id);
                }
                
                String app_Partner_Id = trigger.newMap.get(ap.Id).Partner_Intrax_Id__c;
                system.debug('**app_Partner_Id******'+app_Partner_Id);
                 system.debug('**aaplicant Name-3 ****'+ap.Name);
             //   system.debug('*****WT Repeat Application Acc'+ap.Account__c+' '+ap.Intrax_Program__c+' '+ap.Application_Level__c+' '+ap.Application_Stage__c);
                if(app_Partner_Id!=null && app_Partner_Id!='')
                {
                    try{
                        
                        List<User> lstUser=[Select u.UserRole.PortalRole, u.UserRole.PortalType, u.UserRole.DeveloperName, 
                                            u.UserRole.RollupDescription, u.UserRole.ParentRoleId, u.UserRole.Name, 
                                            u.UserRole.Id, u.UserRoleId, u.ProfileId, u.PortalRole, u.ManagerId, u.IsPortalSelfRegistered,
                                            u.IsPortalEnabled, u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.FirstName,
                                            u.CreatedById, u.Account__c, u.AccountId  From User u where u.Intrax_Id__c =:app_Partner_Id];
                        
                        If(lstUser.size() > 0 && lstUser!=null)
                        {
                            if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test'))) 
                            {
                                Sharing_Security_Controller.shareApplicantRecord(ap.Id,lstUser);                            
                                /* For(User usr:lstUser)
{
PartnerRoleId.add(usr.UserRole.ParentRoleId);
}
If(PartnerRoleId!=null && PartnerRoleId.size()>0)
{                                                         
Sharing_Security_Controller.sharePartnerRoleUp(ap.Id,PartnerRoleId);
}*/
                            }
                        }
                        
                    }                            
                    catch(Exception e){
                        
                        
                        system.debug(e);
                        
                    }
                    
                }
                             
             system.debug('***** Application Owner trig - after insert'+ap.ownerId);
              system.debug('**aaplicant Name-3 ****'+ap.Name);
           
            }
          }        
        if(trigger.isUpdate){
            //Geo Initialization
            Set<id> AccIds = new Set<Id>();
            Set<Id> AppIds = new Set<Id>();
            for (Applicant_Info__c appInfo : trigger.new){
              if (appInfo.Type__c=='Host Family' && appInfo.Intrax_Program__c =='AuPairCare' && appInfo.Account__c != null)
                    AccIds.add(appInfo.Account__c);
             
            }
            List<iGeoLocate__c> iGeos = new List<iGeoLocate__c>();
            if (AccIds.size() > 0){
                iGeos = [select Id,Account__c,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Id!=null AND Account__c != null and Account__c in :AccIds];
            }
            
            Map<Id,iGeoLocate__c> appAccWGeo = new Map<Id,iGeoLocate__c>();
            List<iGeoLocate__c> iGeosForDistanceComputation = new List<iGeoLocate__c>();
            
            if(iGeos.size()>0){
                for (iGeoLocate__c iGeo : iGeos){
                    if (iGeo.GeoAddress__Latitude__s != null && iGeo.GeoAddress__Longitude__s != null){
                        //The applicant has a GeoCode Account
                        appAccWGeo.put(iGeo.Account__c,iGeo);
                    }
                }
            }
            //Geo Initialization
            // Added for persisting sharing on ownership change
                Set<Id> appInfoIds = new Set<Id>();
                Set<Id> APCOwnerChanges = new set<Id>();
                //List<User> allADs = [select Id,Profile.Name from User where Profile.Name = 'APC AD PC'];
                //Set<Id> ADIDSet = (new Map<Id,sObject>(allADs)).keySet();
                List<User> allADs = new List<User>();
                Set<Id> ADIDSet = new Set<Id>();
            
                if(Trigger.old[0]!=null && Trigger.old[0].OwnerId!=null && trigger.new[0]!=null && trigger.new[0].OwnerId != Trigger.old[0].OwnerId){
                    allADs = [select Id,Profile.Name from User where Profile.Name = 'APC AD PC'];
                    ADIDSet = (new Map<Id,sObject>(allADs)).keySet();
                }
                
                for(Applicant_Info__c apshr: trigger.new){
                    if(Trigger.oldMap!=null && Trigger.oldMap.get(apshr.Id).OwnerId!=null &&  apshr.OwnerId != Trigger.oldMap.get(apshr.Id).OwnerId) 
                    {
                        if (ADIDSet.contains(apshr.OwnerId)){
                            APCOwnerChanges.add(apshr.Id);
                        }   
                        else{ 
                            appInfoIds.add(apshr.Id);
                        }
                    }
                    system.debug('**appInfoIds**'+appInfoIds);
               }
               
               if((APCOwnerChanges!=null && APCOwnerChanges.size()>0)) {
                flag='after';
                //Hypothetical case - if we have a bunch where both APC Owner and Other owner types set together then do both here
                if (APCOwnerChanges!=null && APCOwnerChanges.size()>0)
                    SharingSecurityHelper.persistSharingWithOwner(app_share, flag, APCOwnerChanges);
                if (appInfoIds!=null && appInfoIds.size()>0)
                    SharingSecurityHelper.persistSharingWithOwner(app_share, flag, appInfoIds); 
               }
               //If we have exclusively other type owner set to app info then do the other before updates 
               else{            
                       flag='after';
                       if (appInfoIds!=null && appInfoIds.size()>0)
                        SharingSecurityHelper.persistSharingWithOwner(app_share, flag, appInfoIds); 
            
                    /*
                        list<Applicant_Info__Share> allManualAppShare = new list<Applicant_Info__Share>();
                        list<Manual_Sharing_Info__c> selMShareSQL = [SELECT Object_ID__c, User_ID__c FROM Manual_Sharing_Info__c WHERE Object_ID__c IN : allshareIDs];
                        if (selMShareSQL != NULL && selMShareSQL.size()>0)
                        {
                            for (Manual_Sharing_Info__c SingleShr : selMShareSQL)
                            {
                                Applicant_Info__Share singleappshr = new Applicant_Info__Share();
                                singleappshr.ParentId = SingleShr.Object_ID__c;
                                singleappshr.UserOrGroupId = SingleShr.User_ID__c;
                                singleappshr.AccessLevel = 'Edit';
                                allManualAppShare.add(singleappshr);
                            }
                            if(allManualAppShare != NULL && allManualAppShare.size()>0)
                            {
                                insert allManualAppShare;
                                delete selMShareSQL;
                            }
                        }
                    }
                    
                }*/ 
                
                //Added by Saroj for Manual Sharing Issue (End)
                
                //Set<Id> appIds = new set<Id>();   
                set<Id> PartnerAppids =new set<Id>(); 
                Set<Id> engagementListToBeNotified = new Set<Id>();   
                Set<Id> WTAppIds = new set<Id>();
                Set<Id> IGIAppIds = new set<Id>();
                Map<Id,Id> WTAppUser = new Map<Id,Id>();  
                Set<Id>  EngIds =  new set<Id>();
                Set<Id>  EngAccIds =  new set<Id>();    
                string newOwner;
                string oldOwner;
                
                Set<Id> IGIEnggLstoBeNotified; 
                Set<Id> IGIEnggReqDocsLstoBeNotified;
                
                Set<Id> APCAppLstoBeNotified;   
                Set<Id> APCAppDeclinedToBeNotified;
                Set<Id> APCAppAcceptedLstoBeNotified;
                Set<Id> APCAppSubExtensionLstoBeNotified;
                Set<Id> APCAppMainAccLstoBeNotified;
                Set<Id> APCAppFlaggedLstoBeNotified;
                Set<Id> APCHFAppQualifiedLstoBeNotified;
                Set<Id> APCHFExtAppSubLstoBeNotified;
                Set<Id> APCPTExtAppSubLstoBeNotified;
                Set<Id> APCAppAutoAssLstoBeNotified;
                set<ID> setPosIday = new set<ID>();
                List<Position__c> listposay = new List<Position__c>();
                List<Position__c> listposayupdate = new List<Position__c>();
                
                for(Applicant_Info__c ap: trigger.new){
                 
                 if (ap.Application_Stage__c == 'Accepted' && trigger.oldMap.get(ap.Id).Airport__c !=trigger.newMap.get(ap.Id).Airport__c && trigger.newMap.get(ap.Id).Airport__c != null)
                 {
                   if((ap.Position__c !=null) && (ap.RecordTypeId == Constants.AyusaHF_Record_Type_Id ||ap.RecordTypeId == Constants.AyusaHS_Worldwide_HF_Type_Id))
                  {
                  setPosIday.add(ap.Position__c);
                  }
                 }
                  system.debug('**aaplicant Name-3 ****'+ap.Name);
                
                }
               
                if(setPosIday!=null && setPosIday.size()>0)
                {
                listposay = [SELECT id, Name, Airport__c from Position__c p where p.Id IN: setPosIday];
                }
                
                
                //JOSE B-03187
                try{
                    system.debug('@@@@@ If App change to Accepted Set Engagement.Application_Accepted_Date__c');
                    set<Id> listEngApp = new set<id>();
                    List<Engagement__c> listEngAppAccepted = new List<Engagement__c>();
                    map<Id,Date> mapEngApp = new  map<Id,Date>();
                    List<Engagement__c> listEngUpdate = new List<Engagement__c>();
                    
                    for(Applicant_Info__c ap: trigger.new){
                        if (ap.Application_Stage__c == 'Accepted' && trigger.oldMap.get(ap.Id).Application_Stage__c !=trigger.newMap.get(ap.Id).Application_Stage__c && trigger.newMap.get(ap.Id).Accepted_Date__c != null){
                            //if(ap.Engagement__c !=null && ap.RecordTypeId== Constants.AuPairCarePT_Record_Type_Id){
                            if(ap.Engagement__c !=null){
                                listEngApp.add(ap.Engagement__c);
                                mapEngApp.put(ap.Engagement__c, ap.Accepted_Date__c);
                            }
                        }
                    }
                    if(listEngApp!=null && listEngApp.size()>0){
                        listEngAppAccepted = [SELECT id, Name, Application_Accepted_Date__c from Engagement__c where Id IN: listEngApp];
                    }
                    if(listEngAppAccepted!=null && listEngAppAccepted.size()>0){
                        for(Engagement__c eng: listEngAppAccepted){
                            eng.Application_Accepted_Date__c = mapEngApp.get(eng.Id);
                            listEngUpdate.add(eng);
                        }
                        upsert listEngUpdate;
                    }
                }catch(Exception e){
                    system.debug('@@@@@ Exception trying to update Engagement.Application_Accepted_Date__c: ' + e);
                }
                //END JOSE B-03187
                
                
                
                for(Applicant_Info__c ap: trigger.new){
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    string stage_old = trigger.oldMap.get(ap.Id).Application_Stage__c;
                    string stage_new = trigger.newMap.get(ap.Id).Application_Stage__c;
                    string level_old = trigger.oldMap.get(ap.Id).Application_Level__c;
                    string level_new = trigger.newMap.get(ap.Id).Application_Level__c;
                    string old_CreatedBy = trigger.oldMap.get(ap.Id).CreatedBy__c;
                    string new_CreatedBy = trigger.newMap.get(ap.Id).CreatedBy__c;
                    string old_Partner = trigger.oldMap.get(ap.Id).Partner_Intrax_Id__c;
                    string new_Partner = trigger.newMap.get(ap.Id).Partner_Intrax_Id__c;
                    
                    string salesNotes_old = trigger.oldMap.get(ap.Id).Sales_Notes__c;
                    string salesNotes_new = trigger.newMap.get(ap.Id).Sales_Notes__c;
                    
                    system.debug('*******old_CreatedBy**********'+old_CreatedBy);
                    system.debug('*******new_CreatedBy**********'+new_CreatedBy);
                    system.debug('*******ap Eng**********'+ap.Engagement__c);
                    strAppInfoName = ap.Name;
                      system.debug('**aaplicant Name-3 ****'+ap.Name);
                    
                    // B-03064 start
                    if (ap.Application_Stage__c == 'Accepted'  && trigger.oldMap.get(ap.Id).Airport__c !=trigger.newMap.get(ap.Id).Airport__c && trigger.newMap.get(ap.Id).Airport__c != null)
                     {system.debug('ap.RecordTypeId' +ap.RecordTypeId);
                      if((ap.Position__c !=null) && (ap.RecordTypeId == Constants.AyusaHF_Record_Type_Id ||ap.RecordTypeId == Constants.AyusaHS_Worldwide_HF_Type_Id))
                       {system.debug('ap.RecordTypeId' +ap.RecordTypeId);
                        if(listposay !=null && listposay.size()>0)
                        {
                         for(Position__c p:listposay)
                         {
                          p.Airport__c = ap.Airport__c;
                          listposayupdate.add(p);  
                         }}
                        system.debug('@@ listposayupdate' +listposayupdate);
                         system.debug('**aaplicant Name-3 ****'+ap.Name);
                       }
                      }
                   
                    //B-03064 end
                   
                    //Story B-01566
                    //D-01291  (Start)
                    if (ap.Engagement__c != NULL && stage_old != stage_new  && stage_new == 'Accepted' &&  ap.RecordTypeId== Constants.ICD_Intern_PT_Record_Type_Id)
                    {
                        list<Engagement__c> qSelect = [SELECT Name, Status__c FROM Engagement__c WHERE ID = :ap.Engagement__c AND Status__c = 'New'];
                        if(qSelect != NULL && qSelect.size() > 0)
                        {
                            qSelect[0].Status__c = 'Processing';
                            update qSelect;
                        }
                    }
                    //D-01291  (End)
                    //end story B-01566
                    system.debug('***** Application Owner trig'+ap.ownerId);
                     system.debug('**aaplicant Name-3 ****'+ap.Name);
                    // B-02452. AP
                                   
                    list <Opportunity> opp = new list<Opportunity>();
                   /*
                    String OldPgmYr; 
                    string NewPgmYr ;
                    if(ap.Last_App_Sync__c!=null){
                    system.debug('@@ pgm year ayusapt' +ap.RecordType.Name);
                    if (ap.RecordType.Name == 'Ayusa PT' && ap.Opportunity_Name__c !=null){
                     AppTriggerHelper.PgmYrAyusa(ap,ap.Program_year__c);               
                     ap.Program_Year_AyusaPT__c = opp[0].Program_Year__c;
                    
                     }
                     
                    }*/
                    //AA Fixed 101 SOQL issue Add Aupair condition
                    if(ap.Engagement__c!=null && ap.Intrax_Program__c!='AuPairCare'){
                     
                     // opp = [SELECT Name,RecordType.Name,Program_Year__c FROM Opportunity WHERE ID = :ap.Opportunity_Name__c];
                      list<Engagement__c> eng = [SELECT Name,Partner_Id__c,Account_Id__r.Name,RecordType.Name,Program_Year__c FROM Engagement__c WHERE ID = :ap.Engagement__c and Partner_Id__c='I-0000283'and Intrax_Program__c='Ayusa' and Type__c='Participant' limit 1];
                     String strEngName;
                      System.debug('Inside Eng Name update');
                       if (eng!=null && eng.size()>=1){
                        if((eng[0].RecordType.Name == 'Ayusa PT' || eng[0].RecordType.Name == 'HS Worldwide PT') && ap.Program_Year__c !=null)
                            {
                              //eng[0].Program_Year__c = ap.Program_Year__c;
                              List<String> PgEng = ap.Program_Year__c.split('-');
                             if(PgEng.size()>=2) {
                              if(eng[0].RecordType.Name == 'Ayusa PT'){
                                eng[0].Program_Year__c=PgEng[1];
                                strEngName = (eng[0].Account_Id__r.Name + ':AY' + PgEng[1]);
                               
                              }
                              if(eng[0].RecordType.Name == 'HS Worldwide PT'){
                               eng[0].Program_Year__c=PgEng[0];
                               strEngName = (eng[0].Account_Id__r.Name + ':AY' + PgEng[0]);  
                               }
                              }
                               system.debug('Program Year'+eng[0].Program_Year__c);
                               system.debug('@@ strEngName'+strEngName);
                               eng[0].Name = strEngName;
                               update eng[0];
                             /* NewPgmYr = opp[0].Program_Year__c;
                              if(ap.Program_Year_AyusaPT__c!=null && ap.Program_Year_AyusaPT__c != NewPgmYr){
                              opp[0].Program_Year__c = ap.Program_Year_AyusaPT__c;
                              system.debug('@@ pgm year ayusapt' +ap.Program_Year_AyusaPT__c);
                              update opp[0];}*/
                         }         
                      }
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                     system.debug('**aaplicant Name-3 ****'+ap.Name);
                   // B-02452 AP
                    if(old_Partner!=new_Partner && new_Partner!=null) {                       
                        
                        List<User> lstUser=[Select u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.FirstName,u.type__c,
                                            u.CreatedById, u.Account__c, u.AccountId  From User u where u.Intrax_Id__c =:new_Partner and u.type__c='Partner'];
                        if(lstUser.size() > 0 && lstUser!=null) {
                            if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test'))){
                                Sharing_Security_Controller.shareApplicantRecord(ap.Id,lstUser);
                            }
                        } 
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                  //  System.debug('****SwitchOffIntacct****'+!Global_Constants__c.getInstance().switchOffIntacct__c);
                    //<Intacct Integration Code Comment Starts>    
                    
                    
                   //if (!Global_Constants__c.getInstance().switchOffIntacct__c && ap.Application_Level__c == 'Basic' && ap.Application_Stage__c == 'Working' &&  ap.RecordTypeId== Constants.AuPairCareHF_Record_Type_Id && ap.Intrax_Region__c == 'United States')
                   if (ap.Application_Level__c == 'Basic' && ap.Application_Stage__c == 'Working' &&  ap.RecordTypeId== Constants.AuPairCareHF_Record_Type_Id && ap.Intrax_Region__c == 'United States')
    
                    {
                        if(ap.Account__c != null)
                        {
                            System.debug('sharing account');
                            //share the person account first if not already shared
                            //Sharing_Security_Controller.shareAccount(ap.Account__c ,ap.createdBy__c);
                        }
                        
                        if (ap.Opportunity_Name__c != null)
                        { 
                            System.debug('sharing Opportunity_Name__c');
                            //First share the parent opporutunity if not already shared.
                            //Sharing_Security_Controller.shareOpportunity(ap.Opportunity_Name__c,ap.createdBy__c);
                            
                            //Create a child opportunity (application fee) if does not exist
                            List<Opportunity > lChildCOpps=[Select id,StageName,Reason__c,Reason_Detail__c,ChildOppType__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                                                            Engagement_End__c,Parent_Opportunity__c,RecordTypeID from Opportunity where Parent_Opportunity__c= :ap.Opportunity_Name__c  and ChildOppType__c=:'Application'];
                            system.debug('@@childopp @@' +lChildCOpps);
                            
                            
                            Opportunity SuccessChildOpp;
                            string OppFeeType = 'Application';
                            /*if(lChildCOpps.size()==0)
                            {
                                List<Person_Info__c> personInfo = [SELECT Id, First_Name__c, Last_Name__c, Gender__c, Date_of_Birth__c,Country_of_Residence__c, Citizenship__c, Email__c, Mobile__c,
                                                                   Phone__c, Skype_Id__c, Best_Call_Time__c, Primary_Applicant__c 
                                                                   FROM Person_Info__c WHERE applicant_Info__c =: ap.Id and Primary_Applicant__c =: true];
                                String CurrencyCode;
                                
                                Id lChildOppId;
                                
                                system.debug('*trigger**'+ap);
                                system.debug('*personInfo**'+personInfo);
                                if(personInfo!=null && personInfo.size()>0)
                                {                                 
                                    
                                    List<PriceBookEntry> PriceBookList = new List<PriceBookEntry>(); 
                                    PriceBookList = Pricing_Publisher.getAPCPricebookDetail('United States','All','Fixed',ap.Intrax_Program__c,'Application'); 
                                    // ap.Intrax_Program__c = APC, ap.Country_of_Interest = All,ap.Intrax_Program_Category__c = business,personInfo[0].Country_of_Residence__c='United States'
                                    system.debug('*PriceBookList**'+personInfo[0].Country_of_Residence__c);
                                    system.debug('*PriceBookList**'+PriceBookList);
                                    system.debug('*PriceBookList**'+ap.Intrax_Program_Category__c);
                                    if(PriceBookList!=null && PriceBookList.size()>0)
                                    {
                                        CurrencyCode=PriceBookList[0].CurrencyIsoCode;
                                        
                                        //if(ap.Application_Stage__c != Trigger.oldMap.get(ap.Id).Application_Stage__c)// && opp equals prev opp
                                        
                                        SuccessChildOpp = AppTriggerHelper.CreateAppOpp(ap,ap.Opportunity_Name__c,CurrencyCode,OppFeeType);
                                        if(SuccessChildOpp!=null && ap.PromoCode__c == null)
                                        {
                                            System.debug('after creating');
                                            Sharing_Security_Controller.shareOpportunity(SuccessChildOpp.Id,ap.createdBy__c);
                                            List<PriceBookEntry> PriceBookListNoPromo = new List<PriceBookEntry>(); 
                                            PriceBookListNoPromo = Pricing_Publisher.getAPCPricebookDetail('United States','All','Fixed',ap.Intrax_Program__c,'Application'); 
                                            AppTriggerHelper.CreateAppOppProduct('application_fee',SuccessChildOpp.Id,PriceBookListNoPromo ); 
                                        }
                                        
                                        system.debug('@@ ap,ap.oppname,currency code,oppfee@@' +ap +ap.Opportunity_Name__c);
                                        system.debug('@@ currency code @@' +CurrencyCode);
                                        system.debug('@@ OppFeeType @@' +OppFeeType);
                                        // IntAcctOppSyncHelper.CreateAccountReceivables(ap.Account__c,ap.Opportunity_Name__c,ap.Intrax_Id__c);
                                    }
                                }
                            }
                            else*/ 
                                
                                if(lChildCOpps.size()>0)
                                SuccessChildOpp = lChildCOpps[0];
                            
                            if(SuccessChildOpp!=null)
                            {  
                                List<OpportunityLineItem> lChildProdcts=[Select o.Quantity,o.OpportunityId,o.PricebookEntry.Product2.Name,o.Id,o.Discount From OpportunityLineItem o where o.OpportunityId =: SuccessChildOpp.id];
                                // system.debug('@@lChildProdcts @@' +lChildProdcts);
                                //   system.debug('@@lChildProdctsPricebookEntry.Product2.Name @@' +lChildProdcts[1].PricebookEntry.Product2.Name);
                                if(lChildProdcts != null && lChildProdcts.size()>0)
                                {   Boolean createdwaived=false;
                                 for ( OpportunityLineItem olitem :lChildProdcts)
                                 {   
                                     if(olitem.PricebookEntry.Product2.Name =='Waived Application Fee')
                                         createdwaived = True;
                                     
                                 }                                 
                                 if(ap.PromoCode__c != null && createdwaived==false)// && lChildProdcts[1].PricebookEntry.Product2.Name!='Waived Application Fee')// olitem.PricebookEntry.Product2.Name !='Waived Application Fee'
                                 {
                                     system.debug('*inside promocode**');
                                     List<PriceBookEntry> PriceBookListPc = new List<PriceBookEntry>(); 
                                     PriceBookListPc = Pricing_Publisher.getAPCDiscountedPb('United States','All','Fixed',ap.Intrax_Program__c,'Application', ap.PromoCode__c);
                                     system.debug('*PriceBookListPc**'+PriceBookListPc);
                                     OppFeeType = 'Promo Code';                  
                                     AppTriggerHelper.CreateAppOppProduct(OppFeeType,SuccessChildOpp.id,PriceBookListPc);
                                 }
                                 
                                }   
                            }
                        }
                        
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                     system.debug('**aaplicant Name-3 ****'+ap.Name);
                    //<Intacct Integration Code Comment Ends>  
                    //Geo 
                    //if (String.isBlank(Trigger.oldMap.get(ap.Id).Private_Bedroom_Indicated__c))
                   if (ap.Private_Bedroom_Indicated__c != null && ap.Private_Bedroom_Indicated__c.equals('Yes'))
                    {
                        if (appAccWGeo.containsKey(ap.Account__c)){
                            iGeosForDistanceComputation.add(appAccWGeo.get(ap.Account__c));
                        }
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    //Geo-End
                    List<Intrax_Program_Upload__c> ReqIPUList =  new list<Intrax_Program_Upload__c>();
                    //B-01247  (Start)
                    system.debug('*******IGIEnggReqDocsLstoBeNotified**********'+IGIEnggReqDocsLstoBeNotified);
                    system.debug('*******IGIEnggLstoBeNotified**********'+IGIEnggLstoBeNotified);
                    if(ap.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id && ap.CreatedBy__c!=null && ap.Engagement__c!=null)
                    {
                        IGIEnggLstoBeNotified =  new set<Id>();
                        If(ap.Application_Level__c == 'Main' && ap.Application_Stage__c == 'Submitted')
                        { 
                            IGIEnggReqDocsLstoBeNotified =  new set<Id>();                         
                            If(ap.Intrax_Program_Category__c=='Business' || ap.Intrax_Program_Category__c=='Information Media & Communications' || ap.Intrax_Program_Category__c=='Public Administration & Law' || ap.Intrax_Program_Category__c=='Engineering')
                            {
                                ReqIPUList =[Select i.View_File__c, i.RecordTypeId, i.Parent_Intrax_Program_Upload__c, i.OwnerId, i.Name, i.Is_Parent__c, i.IsDeleted, i.Intrax_Programs__c, i.Id, i.Engagement__c, i.Document_Type__c, i.Document_GUID__c, i.Applicant_Info__c From Intrax_Program_Upload__c i where i.Applicant_Info__c =:ap.Id and i.Document_Type__c in :Constants.IGI_BUS_IN_REQ_DOCTYPES];
                                if(ReqIPUList!=null && ReqIPUList.size()>0)
                                {
                                    Boolean blnJobOfferDocument=false;Boolean blnPassport=false;Boolean blnResume=false;Boolean blnLangProof=false;
                                    
                                    For(Intrax_Program_Upload__c ipu :ReqIPUList)
                                    {
                                        //if(ipu.Document_Type__c == 'Offer-Document')
                                        //blnJobOfferDocument = true;                                       
                                        if(ipu.Document_Type__c == 'Passport')
                                            blnPassport = true;
                                        else if(ipu.Document_Type__c == 'Resume')
                                            blnResume = true;
                                        else if(ipu.Document_Type__c == 'Proof-of-Language-Level')
                                            blnLangProof = true;
                                    }//|| !blnJobOfferDocument
                                    if(!blnLangProof   || !blnPassport || !blnResume )
                                        IGIEnggReqDocsLstoBeNotified.add(ap.Engagement__c);
                                }
                                else
                                    IGIEnggReqDocsLstoBeNotified.add(ap.Engagement__c);                             
                            }
                            /*else if (ap.Intrax_Program_Category__c=='Social Development')
    {
    ReqIPUList =[Select i.View_File__c, i.RecordTypeId, i.Parent_Intrax_Program_Upload__c, i.OwnerId, i.Name, i.Is_Parent__c, i.IsDeleted, i.Intrax_Programs__c, i.Id, i.Engagement__c, i.Document_Type__c, i.Document_GUID__c, i.Applicant_Info__c From Intrax_Program_Upload__c i where i.Applicant_Info__c =:ap.Id and i.Document_Type__c in :Constants.IGI_SD_REQ_DOCTYPES];
    if(ReqIPUList!=null && ReqIPUList.size()>0)
    {
    Boolean blnResume=false;
    
    For(Intrax_Program_Upload__c ipu :ReqIPUList)
    {                                   
    if(ipu.Document_Type__c == 'Resume')
    blnResume = true;                                       
    }
    if(!blnResume)
    IGIEnggReqDocsLstoBeNotified.add(ap.Engagement__c);
    } 
    else
    IGIEnggReqDocsLstoBeNotified.add(ap.Engagement__c); 
    }*/
                            else if (ap.Intrax_Program_Category__c=='Hospitality & Tourism')
                            {
                                ReqIPUList =[Select i.View_File__c, i.RecordTypeId, i.Parent_Intrax_Program_Upload__c, i.OwnerId, i.Name, i.Is_Parent__c, i.IsDeleted, i.Intrax_Programs__c, i.Id, i.Engagement__c, i.Document_Type__c, i.Document_GUID__c, i.Applicant_Info__c From Intrax_Program_Upload__c i where i.Applicant_Info__c =:ap.Id and i.Document_Type__c in :Constants.IGI_HT_REQ_DOCTYPES];
                                if(ReqIPUList!=null && ReqIPUList.size()>0)
                                {
                                    Boolean blnJobOfferDocument=false;Boolean blnPassport=false;Boolean blnResume=false;Boolean blnLangProof=false;boolean blnIntroVideo=false;boolean blnUnivDiploma=false;
                                    
                                    For(Intrax_Program_Upload__c ipu :ReqIPUList)
                                    {
                                        // if(ipu.Document_Type__c == 'Offer-Document')
                                        //blnJobOfferDocument = true;
                                        if(ipu.Document_Type__c == 'Passport')
                                            blnPassport = true;
                                        else if(ipu.Document_Type__c == 'Resume')
                                            blnResume = true;
                                        else if(ipu.Document_Type__c == 'Proof-of-Language-Level')
                                            blnLangProof = true;   
                                        else if(ipu.Document_Type__c == 'Introduction-Video')
                                            blnIntroVideo = true;
                                        //else if(ipu.Document_Type__c == 'University-Diploma')
                                        //blnUnivDiploma = true;                                
                                    }//|| !blnJobOfferDocument || !blnUnivDiploma
                                    if(!blnLangProof || !blnPassport || !blnResume || !blnIntroVideo )
                                        IGIEnggReqDocsLstoBeNotified.add(ap.Engagement__c);
                                } 
                                else
                                    IGIEnggReqDocsLstoBeNotified.add(ap.Engagement__c); 
                            }
                            system.debug('*******IGIEnggReqDocsLstoBeNotified**********'+IGIEnggReqDocsLstoBeNotified);
                            system.debug('*******IGIEnggLstoBeNotified**********'+IGIEnggLstoBeNotified);
                            system.debug('***** Application Owner trig'+ap.ownerId);
                            if(IGIEnggReqDocsLstoBeNotified!= NULL && IGIEnggReqDocsLstoBeNotified.size() > 0)
                            {
                                Notification_Generator.sendIGIDocNotifications(IGIEnggReqDocsLstoBeNotified);
                            }
                            system.debug('***** Application Owner trig'+ap.ownerId);
                        }
                        system.debug('*******IGIEnggReqDocsLstoBeNotified**********'+IGIEnggReqDocsLstoBeNotified);
                        system.debug('*******IGIEnggLstoBeNotified**********'+IGIEnggLstoBeNotified);
                        list<Person_Info__c> EmergencyInfoList = [select ID, Name From Person_Info__c p Where p.Applicant_Info__c = :ap.Id and Emergency_Contact_Indicated__c = 'Yes']; 
                        
                        list<Person_Info__c> HealthInfoList = [select ID, Name, Hospitalization_Indicated__c, Psychiatric_Treatment_Indicated__c, Medication_Indicated__c From Person_Info__c Where Applicant_Info__c = :ap.Id and Primary_Applicant__c = true]; 
                        
                        if(EmergencyInfoList.size() <= 0)
                        {
                            IGIEnggLstoBeNotified.add(ap.Engagement__c);
                        }
                        else if (EmergencyInfoList.size() > 0)
                        {
                            boolean sendEmergency = true;
                            for (Person_Info__c pin : EmergencyInfoList)
                            {
                                if(pin.Name != 'null null' && pin.Name != '')
                                {
                                    sendEmergency = false;
                                }
                            }
                            if (sendEmergency == true)
                            {
                                IGIEnggLstoBeNotified.add(ap.Engagement__c);
                            }
                        }
                        
                        if(ap.Visa_Type__c == 'J-1' && ap.Application_Stage__c == 'Accepted' && ap.Engagement__r.Visa_Interview_Date__c == NULL)
                        {
                            IGIEnggLstoBeNotified.add(ap.Engagement__c);
                        }
                        
                        if(ap.Engagement__r.Terms_Accepted_Date__c == NULL)
                        {
                            IGIEnggLstoBeNotified.add(ap.Engagement__c);
                        }
                        
                        
                        if (HealthInfoList != NULL && HealthInfoList.size()>0)
                        {
                            Person_Info__c HealthPInfo = HealthInfoList[0];
                            if (ap.Allergies_Indicated__c == NULL || ap.Allergies_Indicated__c == '' || ap.Disabilities__c == NULL || ap.Disabilities__c == '' || ap.Special_Diet_Indicated__c == NULL || ap.Special_Diet_Indicated__c == '' || HealthPInfo.Hospitalization_Indicated__c == NULL || HealthPInfo.Hospitalization_Indicated__c == '' || HealthPInfo.Medication_Indicated__c == NULL || HealthPInfo.Medication_Indicated__c == '' || HealthPInfo.Psychiatric_Treatment_Indicated__c == NULL || HealthPInfo.Psychiatric_Treatment_Indicated__c == '')
                            {
                                IGIEnggLstoBeNotified.add(ap.Engagement__c);
                            }
                        }
                        system.debug('***** Application Owner trig'+ap.ownerId);
                        if(IGIEnggLstoBeNotified!= NULL && IGIEnggLstoBeNotified.size() > 0)
                        {
                            Notification_Generator.sendIGINotifications(IGIEnggLstoBeNotified);
                        }
                    }
                    //B-01247  (End)
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    if(old_CreatedBy != new_CreatedBy && ap.RecordTypeId == Constants.WT_PT_Record_Type_Id && old_CreatedBy!=null && ap.Engagement__c!=null)
                    {
                        list<Engagement__c> lstEng = [select id, Orientation_Date__c,Visa_Interview_Date__c,Terms_Accepted_Date__c,Intrax_Program__c,Intrax_Program_Options__c,status__c,Account_Id__c  from Engagement__c where id=:ap.Engagement__c ];
                        system.debug('*******lstEng**********'+lstEng);  
                        /*For(Engagement__c eng : lstEng)
    {
    EngIds.add(eng.Id);
    EngAccIds.add(eng.Account_Id__c);
    }*/
                        
                        if(lstEng!=null && lstEng.size()>0){
                            for(Engagement__c eng: lstEng) {
                                if ((eng.Orientation_Date__c == NULL || eng.Terms_Accepted_Date__c == NULL || eng.Visa_Interview_Date__c==NULL)  && ((eng.Status__c == 'Processing' || eng.Status__c == 'Program Ready' || eng.Status__c == 'On Program'))){
                                    engagementListToBeNotified.add(eng.Id);
                                }
                            }
                            system.debug('*******engagementListToBeNotified**********'+engagementListToBeNotified); 
                            if(engagementListToBeNotified !=null && engagementListToBeNotified.size()>0)
                                Notification_Generator.sendWTOrientation(engagementListTobeNotified);
                        }
                        if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test')))
                            WTAppIds.add(ap.Id); 
                    }
                    else if(ap.RecordTypeId == Constants.WT_PT_Record_Type_Id &&(( trigger.oldMap.get(ap.Id).Engagement__c !=trigger.newMap.get(ap.Id).Engagement__c && trigger.newMap.get(ap.Id).Engagement__c !=null) ||( old_CreatedBy != new_CreatedBy && new_CreatedBy!=null) ))
                    {        if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test')))
                        WTAppIds.add(ap.Id);                           
                     
                    }
                    
                    else if(ap.RecordTypeId == Constants.WT_PT_Record_Type_Id && (trigger.oldMap.get(ap.Id).Account__c !=trigger.newMap.get(ap.Id).Account__c && trigger.newMap.get(ap.Id).Account__c !=null))
                    {
                        if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test')))
                        {
                            if(ap.CreatedBy__c !=null)    
                                Sharing_Security_Controller.shareAccount(ap.Account__c, ap.CreatedBy__c);
                        } 
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    //D-01292  : Added By Saroj (Start)
                    
                    if(old_CreatedBy != new_CreatedBy && ap.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id && new_CreatedBy != null && ap.Engagement__c!=null)
                    {
                        if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test')))
                            IGIAppIds.add(ap.Id); 
                    }
                    else if(ap.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id &&(( trigger.oldMap.get(ap.Id).Engagement__c !=trigger.newMap.get(ap.Id).Engagement__c && trigger.newMap.get(ap.Id).Engagement__c !=null) ||( old_CreatedBy != new_CreatedBy && new_CreatedBy!=null) ))
                    {        if(!(blnDeployTestFlag && strAppInfoName.containsIgnoreCase('Test')))
                        IGIAppIds.add(ap.Id);                           
                     
                    }
                    
                    //D-01292  : Added By Saroj (End)
                    
                    
                    if (ap.Application_Level__c == 'Main' && ap.Application_Stage__c == 'Accepted'){
                        if (ap.Type__c == 'Host Family'){
                            //do matching
                            List<sPerson_Info__c> childrenHistory;
                            List<String> roleList;
                            string partialUrl;
                            string derivedUrl;
                            
                            //Load History
                            /* if (ap.Nemo_Id__c != NULL){
    childrenHistory = [SELECT Id,First_Name__c,Date_Of_Birth__c,Nemo_Member_Id__c from sPerson_Info__c 
    where role__c in ('Child','Other') and  nemo_member_id__c != null and Nemo_Family_Id__c = :ap.Nemo_Id__c];
    }
    else{
    childrenHistory = [SELECT Id,First_Name__c,Date_Of_Birth__c,Nemo_Member_Id__c from sPerson_Info__c 
    where role__c in ('Child','Other') and  nemo_member_id__c != null];
    }
    // Pick Children and Others
    List<Person_Info__c> children = [SELECT Id,First_Name__c,Date_Of_Birth__c from Person_Info__c 
    where Applicant_Info__c = :ap.Id and role__c in ('Child','Other')];
    
    for (Person_Info__c child : children){
    for (sPerson_Info__c childHistory : childrenHistory){
    if (child.First_Name__c.trim() == childHistory.First_Name__c.trim() && child.Date_Of_Birth__c == childHistory.Date_Of_Birth__c){
    //Match Found from history
    child.Nemo_Id__c = childHistory.Nemo_Member_Id__c;
    update child;
    break; 
    }
    }
    }*/
                            // add code here for notifications
                            
                            // -----Commented for HF letters release   
                            
                            List<Person_Info__c> HostFamilyReferences = [SELECT Id,First_Name__c,Reference_Url__c,Reference_Requested__c,Date_Of_Birth__c from Person_Info__c 
                                                                         where Applicant_Info__c = :ap.Id and role__c in ('Reference')];
                            system.debug('**persreferences***'+HostFamilyReferences);   
                            
                            for (Person_Info__c pers : HostFamilyReferences) {
                                partialUrl='/AyusaHFRef?id='+pers.Id;
                                derivedUrl= Constants.derivedbaseUrl + partialUrl ; 
                                pers.Reference_Url__c=derivedUrl;
                                pers.Reference_Requested__c=true;
                                partialUrl='/AyusaHFRefDecline?id='+pers.Id;
                                derivedUrl= Constants.derivedbaseUrl + partialUrl ; 
                                pers.Reference_Declined_Url__c=derivedUrl;
                                
                                /* moved below - AY2 694
    update pers;
    */
                            }
                            // AY2 694
                            update HostFamilyReferences;
                            // -----Commented for HF letters release   
                        }
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    //Ay 358 - - commented as on 10/01/2014
                    
                    //Check if Application is HF and Approved
                    Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Applicant_Info__c.getRecordTypeInfosById();
                    String Rtype = rtMap.get(ap.RecordTypeId).getName();
                    
                    system.debug('@@@@@Into converted Lead');
                    system.debug('@@@@@Rtype: ' + Rtype);
                    /*
    if ( (ap.Application_Level__c == 'Main'  && ap.Application_Stage__c =='Working' && Rtype =='Ayusa HF') ||
    (ap.Application_Level__c == 'Basic'  && ap.Application_Stage__c =='Working' && Rtype =='Ayusa PT') ||
    (ap.Application_Level__c == 'Basic'  && ap.Application_Stage__c =='Working' && Rtype =='AuPairCare HF') ||
    (ap.Application_Level__c == 'Basic'  && ap.Application_Stage__c =='Working' && Rtype =='AuPairCare PT') ||
    (ap.Application_Level__c == 'Basic'  && ap.Application_Stage__c =='Working' && Rtype =='Centers') ||
    (ap.Application_Level__c == 'Main'  && ap.Application_Stage__c =='Working' && Rtype =='ICD Intern PT') ||
    (ap.Application_Level__c == 'Main'  && ap.Application_Stage__c =='Working' && Rtype =='Work Travel PT'))
    
    */
                    
                    //B-01506
                    if(ap.RecordTypeId==Constants.AyusaPT_Record_Type_Id && ap.Lead__c != NULL){ 
                        Lead theLead = [select isConverted,ConvertedAccountId,Name,OwnerId,Low_Grade_Count__c from Lead where Id = :ap.Lead__c];  
                        if (theLead!= NULL && !theLead.IsConverted){                
                            theLead.Low_Grade_Count__c = ap.Low_Grade_Count__c; 
                            try{
                                update theLead;
                            } 
                            catch(exception e){
                                System.debug('****Impossible to update lead:'+e);
                            }
                        }                   
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    //Database.LeadConvertResult lcrBackup;
                    //Rolled back to original. B-01474 //[Jose]- For APC we convert the lead in "Basic" Level 
                    //Include migrated APC records for lead conversion in Main Working                                 
                    if ( (ap.Application_Level__c == 'Main' && ap.Application_Stage__c =='Working' && Rtype !='Ayusa HF' &&  ((RType == 'Work Travel PT') || (RType == 'Ayusa PT') || (RType == 'ICD Intern PT') || ((Rtype =='AuPairCare HF' || Rtype =='AuPairCare PT') && ap.sys_admin_tag__c!= null)) )
                        || (ap.Application_Level__c == 'Main' && Rtype =='Ayusa HF' && (ap.Application_Stage__c =='Submitted' || ap.Application_Stage__c =='In-Review')) || 
                        (ap.Application_Level__c == 'Basic'  && ap.Application_Stage__c =='Working' && Rtype =='AuPairCare HF') ||
                        (ap.Application_Level__c == 'Basic'  && ap.Application_Stage__c =='Working' && Rtype =='AuPairCare PT')){   
                            system.debug('****here-SS*****'+ ap.Intrax_Program__c+'**'+ap.type__c+'***'+ap.Program_Year__c+'***'+ap.Partner_Intrax_Id__c);   
                            //Do not convert lead for WT, if Program year is blank. //B-01527 (Converting after Program year is filled)
                            if(!((ap.Intrax_Program__c == 'Work Travel' && ap.type__c=='Participant' && ap.Program_Year__c == NULL) || (ap.Intrax_Program__c == 'Internship' && ap.type__c=='Participant' && ap.Partner_Intrax_Id__c==NULL))){                          
                                system.debug('****here-SS1*****');   
                                // Add the logic to convert Lead to Acc and Opp
                                if (ap.Lead__c != NULL){
                                    Lead theLead = [select isConverted,Field_Staff__c,ConvertedAccountId,Name,OwnerId,Lead_Type__c,Intrax_Programs__c from Lead where Id = :ap.Lead__c];
                                    
                                    String LeadIP;
                                    if(theLead != NULL){
                                        LeadIP = theLead.Intrax_Programs__c;
                                       
                                    }
                                   
                                                                       
                                    //B-01986. Exclude Centers from Lead conversion.
                                    if(theLead.Lead_Type__c != 'Participant' || !(LeadIP.contains('English and Professional Skills'))){
                                        //convert Lead and existing lead trigger will tag the newly created account
                                        if (!theLead.IsConverted){
                                            
                                            // CN 80 - Sync Lead fields
                                            //system.debug('***** Has already Synced? ' + ApplicantInfoHelper.hasalreadySyncedFields());
                                            //if(!ApplicantInfoHelper.hasalreadySyncedFields()) ApplicantInfoHelper.syncLeadFields(theLead, ap);
                                            try{
                                                List<User> theOwner = [select Id from User where Id = :theLead.OwnerId];
                                                List<QueueSObject> theQueue = [select QueueId,Q.Queue.Name, Q.Queue.DeveloperName from QueueSObject Q where queueId = :theLead.OwnerId];
                                                List<OpportunityOwners__c> ownerMap = OpportunityOwners__c.getAll().values();
                                                OpportunityOwners__c defaultOwner = OpportunityOwners__c.getvalues('Default');
                                                System.debug(defaultOwner);
                                                
                                                Database.LeadConvert lc = new database.LeadConvert();
                                                Boolean ownerSet = false;
                                                //If owner is Queue, reassign
                                                if (theQueue.size() > 0){
                                                    system.debug('******** theQueue[0].Queue.DeveloperName:' + theQueue[0].Queue.DeveloperName);
                                                    for (OpportunityOwners__c owner : ownerMap){
                                                        system.debug('******** owner.QueueName__c:' + owner.QueueName__c);
                                                        if (owner.QueueName__c == theQueue[0].Queue.DeveloperName){
                                                            List<User> theNewOwner = [select Id from User where userName = :owner.OwnerForLeadConvert__c];
                                                            if (theNewOwner.size() > 0){
                                                                lc.setOwnerId(theNewOwner[0].Id);
                                                                ownerSet = true;
                                                            }
                                                        }
                                                    }
                                                    
                                                    if (!ownerSet){
                                                        System.debug('Owner not set');
                                                        List<User> defaultOwnerUser = [select Id from User where userName = :defaultOwner.OwnerForLeadConvert__c];
                                                        if(defaultOwnerUser.size()>0){
                                                            lc.setOwnerId(defaultOwnerUser[0].Id);
                                                            ownerSet = true;
                                                        }
                                                    }
                                                }
                                                else{
                                                    lc.setOwnerId(theOwner[0].Id);
                                                    ownerSet = true;
                                                }
                                                
                                                lc.setLeadId(ap.Lead__c);
                                                if (ap.Account__c != null){
                                                    lc.setAccountId(ap.Account__c);
                                                }
                                                if (ap.Opportunity_Name__c != null){
                                                    lc.setDoNotCreateOpportunity(true);
                                                }
                                                else{
                                                    system.debug('new Opportunity- Lead');
                                                    //B-01527                                    
                                                    lc.setOpportunityName(ap.Name);
                                                }
                                                
                                                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                                                lc.setConvertedStatus(convertStatus.MasterLabel);
                                                system.debug('***** Application Owner trig'+ap.ownerId);
                                                 system.debug('**aaplicant Name-3 ****'+ap.Name);
                                                System.debug('LC IS:'+lc);
                                                //B-01641.B-03208 Skipping lead conversion for Ayusa Germany,France,Spain,Poland,UK/euorpe
                                                if(Rtype =='AuPairCare PT' || Rtype =='Ayusa PT'){
                                                    if(ap.Partner_Intrax_Id__c!=null && ap.Partner_Intrax_Id__c!='I-0000283'&& ap.Partner_Intrax_Id__c!='I-0000066'&& ap.Partner_Intrax_Id__c!='I-0468328'&& ap.Partner_Intrax_Id__c!='I-0468327'&&ap.Partner_Intrax_Id__c!='I-0468330'){
                                                        Database.LeadConvertResult lcr = Database.convertLead(lc);
                                                        
                                                        System.debug('LCR IS:'+lcr);
                                                        if(lcr.isSuccess()){
                                                            //lcrBackup = lcr;
                                                        }
                                                    }
                                                }
                                                else{
                                                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                                                }
                                            }
                                            catch (Exception e){
                                                System.debug(e);
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                     system.debug('**aaplicant Name-3 ****'+ap.Name);
                    //Ay 358 End - - commented as on 10/01/2014
                    
                    // Checking if the current application can be cloned
                    string app_stage_old = trigger.oldMap.get(ap.Id).application_stage__c;
                    string app_stage_new = trigger.newMap.get(ap.Id).application_stage__c;
                    string app_intx_prg = trigger.newMap.get(ap.id).Intrax_Program__c;
                    if(app_stage_old != app_stage_new && ap.Type__c == 'Host Family' && !(Test.isRunningTest()) ){
                        IUtilities.check_clone_App(trigger.new); 
                        /*if(app_stage_new == 'Accepted' && ap.Type__c == 'Host Family' && !(Test.isRunningTest()))
    {
    Notification_Generator notifygen = new Notification_Generator();
    notifygen.CreateHFInterviewNotification(ap.Id);
    }*/
                    }else if(app_stage_new == 'Working' && !(Test.isRunningTest()) && app_intx_prg !='AuPairCare'){
                        IUtilities.clearAllowCloning(trigger.new);
                        
                    }
                    system.debug('debug::WTAppIds=='+WTAppIds);
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    if(WTAppIds!=null && WTAppIds.size()>0)
                    { 
                        SharingSecurityHelper.shareWTParticipant(WTAppIds);
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                    //D-01292  : Added By Saroj (Start)
                    system.debug('debug::IGIAppIds=='+IGIAppIds);
                    if(IGIAppIds!=null && IGIAppIds.size()>0)
                    { 
                        SharingSecurityHelper.shareWTParticipant(IGIAppIds);
                    }
                    //D-01292  : Added By Saroj (End)
                    system.debug('***** Application Owner trig'+ap.ownerId); 
                     system.debug('**aaplicant Name-3 ****'+ap.Name);                               
                    //B-02747
                    Applicant_Info__c apOld = Trigger.oldMap.get(ap.Id);                                       
                    if(ap.Intrax_Program__c == 'AuPairCare'){ 
                        //This is something that we need to follow in the future. Commenting for now.
                        /*if(lcrBackup.isSuccess())
                        {
                            Id ConvertedOppId = lcrBackup.getOpportunityId();
                            
                            if(ConvertedOppId!=null)
                            {
                                System.debug('converted oppid' + ConvertedOppId + ' and ap.CreatedById' + ap.CreatedByid);
                                Sharing_Security_Controller.shareOpportunity(ConvertedOppId,ap.CreatedByid); 
                                /*List<Opportunity> opLst = [select Id, Type,Intrax_Programs__c from opportunity where id= :ConvertedOppId];
                                if(opLst!=null && opLst.size()>0)
                                {
                                    opLst[0].Type = ap.Type;
                                    opLst[0].Intrax_Programs__c = 'AuPairCare';
                                    
                                }
                            }
                            else
                                System.debug('converted oppid is null');
                        }*/
                        system.debug('@@@@@Here Notification_Generator apOld: ' + apOld.Application_Stage__c);
                        system.debug('@@@@@Here Notification_Generator ap: ' + ap.Application_Stage__c);
                         system.debug('**aaplicant Name-3 ****'+ap.Name);
                        Notification_Generator.callAPCNotifications(apOld, ap);//old,new,                                                                     
                    }
                    system.debug('***** Application Owner trig'+ap.ownerId);
                   
                }
                //B-03064 update
                update listposayupdate;
                //B-03064 update
                //Geo Bulkified Geo Call
                if (iGeosForDistanceComputation.size() > 0){
                    system.debug('***** ENTERED --->');
                    gGeoC.sObjectList = iGeosForDistanceComputation;
                    gGeoC.theInstanceGateKeeper();
                } 
                           
                //Geo Bulkified Geo Call ends
                /*
                //Ownership change moved from //Geo Controller to the trigger
                List<GeoMatch__c> geoMatchesForOwnerChange = [select FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__r.Id from GeoMatch__C where FromiGeoLocate__r.Account__r.Id IN :AccIds];
                if(geoMatchesForOwnerChange!=null && geoMatchesForOwnerChange.size()>0){
                    //gGeoC.changeOwnerForGeoMatchedApplications(geoMatchesForOwnerChange);  
                    system.debug('***** ENTERED --->AGAIN');
                    gGeoC.sObjectList = geoMatchesForOwnerChange;
                    gGeoC.theInstanceGateKeeper();      
                }
                */
                Applicant_Info__c NewAppInfo ;
                Applicant_Info__c OldAppInfo;
                            
                NewAppInfo = trigger.new[0];
                OldAppInfo = trigger.old[0];
                
                Applicant_Info__c AppInfoObject = new Applicant_Info__c(); // This takes all available fields from the required object.
                Schema.SObjectType objType = AppInfoObject.getSObjectType();
                Set<String> nemoIds = new Set<String>();
                string NewNemoId;
                string RecdDate;
                string doctype;
                Map<String, Schema.SObjectField> M = Schema.SObjectType.Applicant_Info__c.fields.getMap();
                if(NewAppInfo.Type__c=='Participant')
                {
                    for (String str : M.keyset())
                    { 
                        // System.debug('Field name: '+str +'. New value: ' + NewAppInfo.get(str) +'. Old value: '+OldAppInfo.get(str));
                        if(str.equals('nemo_id__c'))
                        {
                            if(NewAppInfo.get(str)!= OldAppInfo.get(str))
                            {
                                nemoIds.add(String.valueOf(NewAppInfo.get(str)));
                                // System.debug('********String.valueOf(NewAppInfo.get(str))*************'+String.valueOf(NewAppInfo.get(str)));  
                                // System.debug('Field name:nemoIds '+nemoIds);                  
                            }}
                        
                    }
                    
                    
                    for(String strNemo: nemoIds) {
                        System.debug('Field name:strNemo '+strNemo);
                        System.debug('Field name:nemoIds '+nemoIds);
                        if(strNemo!=null && strNemo!='')
                        {
                            System.debug('Field name:strNemo '+strNemo);
                            
                            if(NewAppInfo.get('ETR_Received_Date__c')!=null)
                            {
                                system.debug('****ETR_Received_Date__c*********'+NewAppInfo.get('ETR_Received_Date__c'));
                                doctype='Teacher';
                                AppTriggerHelper.AutoPdfUpload(String.Valueof(NewAppInfo.get('id')),String.Valueof(NewAppInfo.get('Name')),doctype);
                            }
                            if(NewAppInfo.get('SOR_Received_Date__c')!=null)
                            {
                                system.debug('****SOR_Received_Date__c*********'+NewAppInfo.get('SOR_Received_Date__c'));
                                doctype='School';
                                AppTriggerHelper.AutoPdfUpload(String.Valueof(NewAppInfo.get('id')),String.Valueof(NewAppInfo.get('Name')),doctype);
                            }
                            
                            
                        }            
                    }
                    system.debug('****Trigger.New*********'+trigger.new);
                    
                    system.debug('***** Application Owner trig'+NewAppInfo.ownerId);
                }
            }//END OF AFTER UPDATE 
        }
    }    
    //}  
  //}  
}