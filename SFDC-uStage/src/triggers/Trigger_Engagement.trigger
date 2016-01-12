trigger Trigger_Engagement on Engagement__c (after insert, after update,before insert, before update) {
    //I have to exclude this trigger if Auto Sync Application.
    if(TriggerExclusion.isTriggerExclude('Engagement')){
        return;
    }
    
    // TRIGGER VARS INSTANTIATION  
    Set<Id> PartnerEngIds = new set<Id>();
    Set<Id> CREngIds = new set<Id>();
    Set<Id> NewEngIds = new set<Id>();
    Set<Id> engagementListToBeNotified = new Set<Id>();
    Set<Id> engagementIGIListToBeNotified = new Set<Id>();
    Set<Id> EnggTripList = new Set<Id>();
    Set<Id> CloseNotifyEnggList = new Set<Id>();
    Set<Id> CloseNotifyEnggList_IGI = new Set<Id>();
    Engagement__Share eng_share=new Engagement__Share();
    String flag;
    Set<Id> EnggOrientList = new Set<Id>();
    string strEngName;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag; 
    // Below line move to on Line 533
    //User SysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
    List<Engagement__c> APCConfEngs = new List<Engagement__c>();
    //AFTER TRIGGER STARTS HERE
    if(trigger.isAfter) {
        
        //Check if its insert or update
        //AFTER INSERT TRIGGER STARTS HERE
         if(trigger.isInsert){
                 
             for(Engagement__c eng:trigger.new){
                strEngName= eng.Name;
                NewEngIds.add(eng.Id);
                
                if(eng.Partner_Id__c != NULL){
                    PartnerEngIds.add(eng.id);
                }
                
                if(!(blnDeployTestFlag && strEngName.containsIgnoreCase('Test')))                
                SharingSecurityHelper.shareEngagement(NewEngIds,PartnerEngIds,CREngIds);
                
             }
              
         }
         //AFTER INSERT TRIGGER ENDS HERE 
          //AFTER UPDATE TRIGGER STARTS HERE          
        if(Trigger.isUpdate) {
                // OPTIMISING CODE FOR QUERY LIMITS ..AP start
               set<Id> setId = new set<Id>();
              // set<Id> setAcId = new set<Id>();
               map<Id, Opportunity> mapOppRecord;
               list<Opportunity> lstToUpdate = new list<Opportunity>();
               list<Opportunity> lstToUpdateHSWW = new list<Opportunity>();
               list<Opportunity> lstOppHSWW = new list<Opportunity>();
               set<Id> setHSWWid = new set<ID>();
               //list<Applicant_Info__c>applicant = new list<Applicant_Info__c>();
               //set<Id> setEngId = new set<Id>();
               for(Engagement__c eng:trigger.new){
                  // NewEngIds.add(eng.Id);//.. optimisation
                  if(eng.Opportunity_Id__c != null)
                   {             
                   setId.add(eng.Opportunity_Id__c);
                   //setEngId.add(Eng.id);
                   //B-03062
                   if(eng.Status__c == 'Cancelled' || eng.Status__c == 'Terminated' || eng.Status__c == 'Early Departure')
                   {
                    if(eng.RecordTypeId == Constants.ENG_AYUSA_PT || eng.RecordTypeId == Constants.ENG_HS_WORLDWIDE_PT)
                    {
                     setHSWWid.add(Eng.Opportunity_Id__c);
                    } 
                   }
                    //B-03062
                   }
                  
                    
                  }
             // D-01738
               Map<Id,List<Applicant_Info__c>> WTAppln=new Map<Id, List<Applicant_Info__c>>();
               Map<Id,User> AppWTuser=new Map<Id,User>();
               Map<Id,User> createdUser = new Map<Id,User>();
               List<Applicant_Info__c> WT_appln=new List<Applicant_Info__c>();
               List<User> createdUserlst= new List<User>();
               Set<Id> appCreatedId = new Set<Id>();
               Set<Id> WTEngAccId=new Set<Id>();
               if(Trigger.new[0]!=null && Trigger.new[0].Intrax_Program__c == 'Work Travel')
               {
                 for(Engagement__c WTEng:trigger.new)
                 {
                  WTEngAccId.add(WTEng.Account_Id__c);
                  WTAppln.put(WTEng.Id,new List<Applicant_Info__c>());
                 }
                 WT_appln = [Select a.Engagement__c,a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c, a.Arriving_Time__c, a.Account__c,a.CreatedById From Applicant_Info__c a where  a.Account__c in :WTEngAccId and a.Engagement__c in :trigger.new];
                 for(Applicant_Info__c app:WT_appln)
                 {
                  appCreatedId.add(app.CreatedBy__c);
                 }
                createdUserlst =[Select id,type__c,Intrax_Id__c from User where Id IN :appCreatedId and Profile.Name ='OCPM PT'];
                for(User u:createdUserlst)
                {
                  createduser.put(u.id,u);
                }
                for(Applicant_Info__c a:WT_appln)
                { 
                  User createdby=createdUser.get(a.CreatedBy__c);
                  System.debug('Created user'+createdby);
                  if(createdby != null)
                  {
                   AppWTuser.put(a.Id,createdby);
                  }
                  WTAppln.get(a.Engagement__c).add(a);
                }
                
                 
               }
                   //.. optimisation
                 /*  if(eng.Account_Id__c != null)
                   {
                    setAcId.add(Eng.Account_Id__c);
                   }
                 
                  
                 if(setAcId !=null && setAcId.size()>0)
                 {
                  list<Applicant_Info__c> applicant = [Select a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c,a.Program_Year__c, a.Arriving_Time__c, a.Account__c,a.CreatedById From Applicant_Info__c a where  a.Account__c IN:setAcId and a.Engagement__c IN:NewEngIds];
                  }*/
                //.. optimisation
                if(setId != null && setId.size() > 0){
                 mapOppRecord = new map<Id, Opportunity>([Select Id,Intrax_Programs__c from Opportunity where Id IN :setId]);
                 }
                 
                 if(setHSWWid!=null && setHSWWid.size()>0)
                 {
                 lstOppHSWW = [Select id,Name, Reason__c , Reason_Detail__c from Opportunity where Id IN:setHSWWid];
                 }
                 
            /*  // optimising d-01745
              if(setEngId!=null && setEngId.size()>0)
              {
               if(setAcId!=null && setAcId.size()>0)
               {
                system.debug('@@setengid' +setEngId);
                system.debug('@@setacid' +setAcId);
               applicant = [Select a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c,a.Program_Year__c, a.Arriving_Time__c, a.Account__c,a.CreatedById From Applicant_Info__c a where  a.Account__c IN:setAcId and a.Engagement__c IN:setEngId];
               system.debug('@@applicant' +applicant);
               }
              }
             // optimising d-01745*/
              for(Engagement__c eng:trigger.new){
                
                if (eng.Status__c == 'Program Complete' || eng.Status__c == 'Early Departure' || eng.Status__c == 'Cancelled' || eng.Status__c == 'Terminated')
                {
                   if(eng.Intrax_Program__c=='Internship'){
                    CloseNotifyEnggList_IGI.add(eng.id);  
                   }
                   else if(eng.Intrax_Program__c!='Internship')   
                   {
                    CloseNotifyEnggList.add(eng.id);
                   }
                   
                }
                
                if (trigger.oldMap.get(Eng.Id).Placement_Status__c!=trigger.newMap.get(Eng.Id).Placement_Status__c && trigger.newMap.get(Eng.Id).Placement_Status__c == 'Pending')
                {
                  if(mapOppRecord != null && Eng.Opportunity_Id__c != null && mapOppRecord.size()>0)
                 {
                   Opportunity oppToUpdate = mapOppRecord.get(Eng.Opportunity_Id__c);
                   if(oppToUpdate !=null)
                   {
                     if (oppToUpdate.Intrax_Programs__c == 'Ayusa')
                     {
                     oppToUpdate.Operation_Stage__c ='Match Ready';
                     lstToUpdate.add(oppToUpdate);
                      }
                    }
                  }          
                 }
                 
                 //B-03062 STARTS
                 if(eng.Status__c == 'Cancelled' || eng.Status__c == 'Terminated' || eng.Status__c == 'Early Departure')
                  {
                  if(eng.RecordTypeId == Constants.ENG_AYUSA_PT || eng.RecordTypeId == Constants.ENG_HS_WORLDWIDE_PT)
                  {
                   if (lstOppHSWW != null &&  lstOppHSWW.size()>0)
                   { system.debug('list' +lstOppHSWW);
                    for(Opportunity oppo:lstOppHSWW)
                    {
                     oppo.Reason__c = eng.Reason__c;
                     oppo.Reason_Detail__c = eng.Reason_Detail__c;
                     lstToUpdateHSWW.add(oppo);
                    }
                   }
                  }
                 }
                 
                 //B-03062 ENDS
                
                //B-03131   ---Updating the PT Account on Engagement-Share PT Account with PT User and Partner User
                string old_Account_Id = trigger.oldMap.get(eng.Id).Account_Id__c;
                string new_Account_Id = trigger.newMap.get(eng.Id).Account_Id__c;
                if(old_Account_Id != new_Account_Id && new_Account_Id != NULL){
                    system.debug('Old PT****'+old_Account_Id);
                    system.debug('New PT****'+new_Account_Id);
                    
                    
                  List<Applicant_Info__c> appInfo =new List<Applicant_Info__c>();
                                List<User> lstParnerUsr = new List<User>();
                                 appInfo = [Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c,a.CreatedById, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                    where a.engagement__c = :eng.Id];
                                 if(appInfo!=null && appInfo.size()>0)
                                     {
                                       system.debug('***appInfo******'+appInfo);
                                       for(Applicant_Info__c aInfo : appInfo)
                                        {                               
                                            //Share the PT Account with the applicant
                                            system.debug('***sharing CreatedBy__c******'+aInfo.CreatedBy__c);
                                            Sharing_Security_Controller.shareAccount(new_Account_Id, aInfo.CreatedBy__c);
                                         }
                                     }   
                   ////////Sharing PT Account  with Partner Users
                                if (eng.Partner_Id__c!=null)
                                {
                                    lstParnerUsr=[Select u.Name, u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.Account__c, u.AccountId, u.AboutMe From User u where u.Intrax_Id__c =: eng.Partner_id__c];
                                       system.debug('******lstParnerUsr********'+lstParnerUsr);
                                        If(lstParnerUsr!=null && lstParnerUsr.size()>0)
                                        {
                                             system.debug('***sharing lstParnerUsr******'+lstParnerUsr); 
                                            Sharing_Security_Controller.shareAccount(new_Account_Id,lstParnerUsr);
                                        }
                                }  
                
                }
                 //B-03131
                 
                 
                 
                 // OPTIMISING CODE FOR QUERY LIMITS ..AP ends
                NewEngIds.add(eng.Id);
                // New code for MT 140
                strEngName= eng.Name;
                string status_old = trigger.oldMap.get(eng.Id).Status__c;
                string status_new = trigger.newMap.get(eng.Id).Status__c;
                string old_Partner = trigger.oldMap.get(eng.Id).Partner_Id__c;
                string new_Partner = trigger.newMap.get(eng.Id).Partner_Id__c;
                string old_Owner = trigger.oldMap.get(eng.Id).OwnerId;
                string new_Owner = trigger.newMap.get(eng.Id).OwnerId;
                date Orientation_old = trigger.oldMap.get(eng.Id).Orientation_Date__c;
                date Orientation_new = trigger.newMap.get(eng.Id).Orientation_Date__c;
                //IGI - 724 (Start)
                string placement_status_old = trigger.oldMap.get(eng.Id).Placement_Status__c;
                string placement_status_new = trigger.newMap.get(eng.Id).Placement_Status__c;
                //IGI - 724 (End)
                
                //B-01504 (Start)
                string preProgramTrip_old = trigger.oldMap.get(eng.Id).Pre_Program_Trip_Indicated__c;
                string preProgramTrip_new = trigger.newMap.get(eng.Id).Pre_Program_Trip_Indicated__c;
                Integer adYear ;    
                
                try{
                     
                      if(eng.Intrax_Program__c == 'Ayusa' && preProgramTrip_old != preProgramTrip_new){
                       //List<Opportunity> opp = [SELECT Id,Pre_Program_Trip_Indicated__c FROM Opportunity WHERE Id=: eng.Opportunity_Id__c LIMIT 1];
                         // OPTIMISING CODE FOR QUERY LIMITS ..AP starts
                         if(mapOppRecord!=null && mapOppRecord.size()>0){
                        list<Opportunity> opp = new list<Opportunity>();
                        if(mapOppRecord.get(eng.Opportunity_Id__c)!=null){
                        opp.add(mapOppRecord.get(eng.Opportunity_Id__c));
                        }
                        // OPTIMISING CODE FOR QUERY LIMITS ..AP 
                        if(opp != null && opp.size()>0){
                            opp[0].Pre_Program_Trip_Indicated__c = preProgramTrip_new;
                            update opp;
                        }
                    }// OPTIMISING CODE FOR QUERY LIMITS ..AP
                   }
                }catch(exception e){
                    System.debug('Error: '+e);
                    eng.addError(e);
                }
                //B-01504 (End)        
                
                //B-02747
               if(eng.Intrax_Program__c == 'AuPairCare'){
                   Engagement__c engOld = Trigger.oldMap.get(eng.Id);                                       
                   Notification_Generator.callAPCNotifications(engOld, eng);//old,new,                                                                                             
               }   
                  
               //B-03301               
               if(eng.Intrax_Program__c == 'AuPairCare' && eng.Placement_Status__c == 'Confirmed'){
                   APCConfEngs.add(eng);                   
               }
                
                if(status_old != status_new && status_new == 'Cancelled'){
                    list<Match__c> matches = [SELECT Id, Status__c, Engagement__c FROM Match__c WHERE Engagement__c =: eng.Id ];
                    system.debug('****** matches: ' + matches.size());
                    for(Match__c m : matches){
                        m.Status__c = 'Withdrawn';
                    }
                    update matches;
                }
                 // end of MT 140 code
                if(old_Partner != new_Partner && new_Partner != NULL){
                    system.debug('old partner****'+old_Partner);
                    system.debug('new partner****'+new_Partner);
                    PartnerEngIds.add(eng.id);
                     if(!(blnDeployTestFlag && strEngName.containsIgnoreCase('Test')))     
                        SharingSecurityHelper.shareEngagement(NewEngIds,PartnerEngIds,CREngIds);        
                
                } 
                  if (eng.Intrax_Program__c == 'Work Travel' && (status_new != status_old) && (eng.Status__c == 'Program Ready')){
                   //List<Opportunity> op = [SELECT Id,StageName FROM Opportunity WHERE Id=: eng.Opportunity_Id__c LIMIT 1];
                       // OPTIMISING CODE FOR QUERY LIMITS ..AP start
                       if(mapOppRecord!=null && mapOppRecord.size()>0){
                        list<Opportunity> op = new list<Opportunity>();
                         if(mapOppRecord.get(eng.Opportunity_Id__c)!=null){
                         op.add(mapOppRecord.get(eng.Opportunity_Id__c));
                         }
                        if(op != null && op.size()>0){
                            op[0].StageName = 'Closed Won';
                            update op;
                        }
                       } 
                      // OPTIMISING CODE FOR QUERY LIMITS ..AP ends
                }
                 if (eng.Intrax_Program__c == 'Work Travel' && (status_new != status_old) && (eng.Status__c == 'Cancelled')){
                  // List<Opportunity> op = [SELECT Id,StageName FROM Opportunity WHERE Id=: eng.Opportunity_Id__c LIMIT 1];
                       // OPTIMISING CODE FOR QUERY LIMITS ..AP start
                       if(mapOppRecord!=null && mapOppRecord.size()>0){
                        list<Opportunity> op = new list<Opportunity>();
                         if(mapOppRecord.get(eng.Opportunity_Id__c)!=null){
                         op.add(mapOppRecord.get(eng.Opportunity_Id__c));
                         } // OPTIMISING CODE FOR QUERY LIMITS ..AP ends
                        if(op != null && op.size()>0){
                            op[0].StageName = 'Closed Cancel';
                            update op;
                        }
                       } // OPTIMISING CODE FOR QUERY LIMITS ..AP ends
                }
               
                                             
                if (eng.Intrax_Program__c == 'Work Travel' && (status_new != status_old) && (eng.Status__c == 'On Program')){
                    EnggTripList.add(eng.ID);
                }
                
                if (eng.Intrax_Program__c == 'Internship'  && eng.Orientation_Date__c != NULL && (Orientation_old != Orientation_new)){
                    EnggOrientList.add(eng.ID);
                    system.debug('Inside list orientation****');
                }
                
                if(eng.Type__c == 'Participant' && eng.Intrax_Program__c == 'Internship' && eng.Orientation_Date__c == NULL  &&  eng.Status__c == 'Program Ready' && eng.Visa_Type__c == 'J-1'){
                    system.debug('Notification orientation****');
                      List<Scorm__c> sco_eng = [Select Id from Scorm__c where Engagement__c =:eng.id];
                      if(sco_eng.isEmpty() ){
                         Trigger_Engagement_Helper.setScorm(eng);
                       }
                  }
                 if (eng.Intrax_Program__c == 'AuPairCare'  && eng.Type__c =='Participant' ){
                     if(eng.Engagement_Start__c!=null)
                        {
                            adYear = eng.Engagement_Start__c.year();
                            system.debug('@@adYear' +adYear); 
                            //adYear = adYear+1;
                        }
                }
               /*  If(old_Owner != new_Owner)
                {
                    system.debug('old partner****'+old_Partner);
                    system.debug('new partner****'+new_Partner);
                    CREngIds.add(eng.id);
                          if(!(blnDeployTestFlag && strEngName.containsIgnoreCase('Test')))         
                        SharingSecurityHelper.shareEngagement(NewEngIds,PartnerEngIds,CREngIds);
                } */  
                
                //Check for Notifications
                //&& ((eng.Status__c != Trigger.oldMap.get(eng.Id).Status__c)
                //IGI - 724 (Changed the below IF condition)
                //if (eng.Intrax_Program__c == 'Work Travel' && ((eng.Orientation_Date__c == NULL || eng.Terms_Accepted_Date__c == NULL || eng.SEVIS_ID__c != NULL)  && ((eng.Status__c == 'Processing' || eng.Status__c == 'Program Ready' || eng.Status__c == 'On Program'))) || (placement_status_old != placement_status_new && eng.Status__c == 'On Program' && (eng.Placement_Status__c == 'Not Placed' || eng.Placement_Status__c == 'Exempt') ))
                //if (eng.Intrax_Program__c == 'Work Travel' && ((eng.Orientation_Date__c == NULL || eng.Terms_Accepted_Date__c == NULL || eng.SEVIS_ID__c != NULL)  && ((eng.Status__c == 'Processing' || eng.Status__c == 'Program Ready'))) || (placement_status_old != placement_status_new && eng.Status__c == 'On Program' && (eng.Placement_Status__c == 'Not Placed' || eng.Placement_Status__c == 'Exempt') ))
               /* if (eng.Intrax_Program__c == 'Work Travel' && (((eng.Orientation_Date__c == NULL || eng.Visa_Interview_Date__c == NULL || eng.Terms_Accepted_Date__c == NULL || eng.SEVIS_ID__c != NULL)  && ((eng.Status__c == 'Processing' || eng.Status__c == 'Program Ready'))) || (placement_status_old != placement_status_new && eng.Status__c == 'On Program' && (eng.Placement_Status__c == 'Not Placed' || eng.Placement_Status__c == 'Exempt') ))){
                   //  List<Account> lstAccount = [Select a.Id, a.FirstName From Account a where a.Id = : eng.Account_Id__c];
                   // if(lstAccount!=null && lstAccount.size()>0)
                   //
                   if(eng.Account_Id__c !=null){
                  // optimising d-01745
                        list<Applicant_Info__c> applicant = [Select a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c, a.Arriving_Time__c, a.Account__c,a.CreatedById From Applicant_Info__c a where  a.Account__c =:eng.Account_Id__c and a.Engagement__c =: eng.Id];
                          // optimising d-01745
                          system.debug('@@applicant'+applicant);
                          //optimisation effort 
                         // set<ID> setAppId = new set<ID>();
                          list<User> usr = new list<User>();
                          if(applicant!=null && applicant.size()>0)
                          {
                           for(Applicant_Info__c ap:applicant)
                           {
                             setAppId.add(ap.CreatedBy__c);
                           }
                          
                          }
                          
                          if(setAppId!=null && setAppId.size()>0)
                          {
                           usr = [select id,type__c,Intrax_Id__c from User where Id IN: setAppId and Profile.Name ='OCPM PT'];
                           }//
                         //optimisation effort
                        if(applicant!=null && applicant.size()>0){
                            for(Applicant_Info__c app :applicant){ 
                                //IGI 735 (Start)
                                //optimisation effort
                                  list<User> usr = [select id,type__c,Intrax_Id__c from User where Id = :app.CreatedBy__c and Profile.Name ='OCPM PT'];
                                  system.debug('@@user'+usr); 
                                 //optimisation effort
                                 //IGI 735 (End)
                                 if(usr!=null && usr.size()>0){
                                    for(User u:usr) {
                                        if(u.type__c!='Partner'){
                                            engagementListToBeNotified.add(eng.Id);
                                        }
                                    }
                                 }
                            }
                        }
                     }
                    
                    //engagementListToBeNotified.add(eng.Id);
                 }*/
                 if (eng.Intrax_Program__c == 'Work Travel' && (((eng.Orientation_Date__c == NULL || eng.Visa_Interview_Date__c == NULL || eng.Terms_Accepted_Date__c == NULL || eng.SEVIS_ID__c != NULL)  && ((eng.Status__c == 'Processing' || eng.Status__c == 'Program Ready'))) || (placement_status_old != placement_status_new && eng.Status__c == 'On Program' && (eng.Placement_Status__c == 'Not Placed' || eng.Placement_Status__c == 'Exempt') ))){
                 
                   if(eng.Account_Id__c !=null){
                 
                         list<Applicant_Info__c> applicant = WTAppln.get(eng.Id); 
                          system.debug('@@applicant'+applicant);
                         
                        if(applicant!=null && applicant.size()>0){
                            for(Applicant_Info__c app :applicant){ 
                                
                                  User usr = AppWTuser.get(app.Id);
                                  system.debug('@@user'+usr); 
                                 
                                 if(usr!=null ){
                                        if(usr.type__c!='Partner'){
                                            engagementListToBeNotified.add(eng.Id);
                                 
                                      }
                                 }
                            }
                        }
                     }
                    
                    //engagementListToBeNotified.add(eng.Id);
                 } 
                 
                //  && eng.Orientation_Date__c == NULL  &&  eng.Status__c == 'Program Ready'
                if (eng.Intrax_Program__c == 'Internship' && ((eng.Orientation_Date__c == NULL  &&  eng.Status__c == 'Program Ready') || (eng.SEVIS_ID__c != NULL && (eng.Status__c == 'Processing' || eng.Status__c == 'Program Ready') ) ) )
                {
                  
                   if(eng.Account_Id__c !=null){
                        list<Applicant_Info__c> applicant = [Select a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c,a.Program_Year__c, a.Arriving_Time__c, a.Account__c,a.CreatedById From Applicant_Info__c a where  a.Account__c =:eng.Account_Id__c and a.Engagement__c =: eng.Id];
                        system.debug('@@applicant'+applicant);
                        //optimisation effort 
                         /* set<ID> setAppId = new set<ID>();
                          list<User> usr = new list<User>();
                          if(applicant!=null && applicant.size()>0)
                          {
                           for(Applicant_Info__c ap:applicant)
                           {
                             setAppId.add(ap.CreatedBy__c);
                           }
                          
                          }
                          
                          if(setAppId!=null && setAppId.size()>0)
                          {
                           usr = [select id,type__c,Intrax_Id__c from User where Id IN: setAppId and Profile.Name ='OCPM PT'];
                           }*/
                         //optimisation effort
                        if(applicant!=null && applicant.size()>0){
                            for(Applicant_Info__c app :applicant){ 
                            //optimisation effort
                                list<User> usr = [select id,type__c,Intrax_Id__c from User where Id = :app.CreatedBy__c and Profile.Name ='OCPM PT'];
                              //optimisation effort  
                                if(usr!=null && usr.size()>0){
                                    for(User u:usr){
                                        if(u.type__c!='Partner'){
                                            engagementIGIListToBeNotified.add(eng.Id);
                                        }
                                    }
                                }
                             }
                        }
                        
                    }                    
                   
                }        
                
                                                
            }
            
            //B-03301
            if(APCConfEngs!=null && APCConfEngs.size()>0){
                IUtilities.syncEngToOpp(APCConfEngs);
            }
            
            if(lstToUpdateHSWW !=null && lstToUpdateHSWW.size()>0)
            {
             update lstToUpdateHSWW;
            }
            
            if(lstToUpdate!=null && lstToUpdate.size()>0)
            {
             update lstToUpdate;
            }
            if(engagementListTobeNotified!=null && engagementListTobeNotified.size()>0)    
                Notification_Generator.sendWTOrientation(engagementListTobeNotified);
            
            if(engagementIGIListTobeNotified!=null && engagementIGIListTobeNotified.size()>0)    
                Notification_Generator.sendIGINotifications(engagementIGIListTobeNotified);
            
            if(EnggTripList != NULL && EnggTripList.size()>0)
            {
                list<Notification__c> arrivalNotification = [SELECT ID, Status__c FROM Notification__c WHERE Type__c = 'Travel Info Needed' AND Status__c != 'Confirmed' AND Engagement__c IN :EnggTripList];
                if(arrivalNotification != NULL && arrivalNotification.size()>0)
                {
                    for (Notification__c updNotify : arrivalNotification)
                    {
                        updNotify.Status__c = 'Confirmed';
                    }
                    update arrivalNotification;
                }
            }
             // Story B-01251
            if(EnggOrientList != NULL && EnggOrientList.size()>0)
            {
                 system.debug('Inside Notification orientation****');
                list<Notification__c> orientNotification = [SELECT ID, Status__c FROM Notification__c WHERE Type__c = 'Orientation' AND Status__c != 'Confirmed' AND Engagement__c IN :EnggOrientList];
                if(orientNotification != NULL && orientNotification.size()>0)
                {
                    for (Notification__c orientNotify : orientNotification)
                    {
                        orientNotify.Status__c = 'Confirmed';
                    }
                    update orientNotification;
                   
                }
             }
            
            //B-01900 (Start)
            if (CloseNotifyEnggList != NULL && CloseNotifyEnggList.size() > 0)
            {
                list<Notification__c> NotifyListToChange = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c IN :CloseNotifyEnggList AND(Status__c = 'Not Started' OR Status__c = 'In Progress')];
                
                if(NotifyListToChange != NULL && NotifyListToChange.size()>0)
                {
                    for (Notification__c NotcompleteNotify : NotifyListToChange)
                    {
                          NotcompleteNotify.Status__c = 'Not Initiated';
                    }
                    update NotifyListToChange;
                }
            }
            //B-01900 (End)
            //D-01870 (Start)
            if (CloseNotifyEnggList_IGI != NULL && CloseNotifyEnggList_IGI.size() > 0)
            {
                list<Notification__c> NotifyListToChange_IGI = [SELECT ID, Status__c,Type__c FROM Notification__c WHERE Engagement__c IN :CloseNotifyEnggList_IGI AND Type__c !='Host Final Program' AND Type__c!='Final Program Assessment' AND(Status__c = 'Not Started' OR Status__c = 'In Progress')];
                
                if(NotifyListToChange_IGI != NULL && NotifyListToChange_IGI.size()>0)
                {
                    for (Notification__c NotcompleteNotify_IGI : NotifyListToChange_IGI)
                    {
                          NotcompleteNotify_IGI.Status__c = 'Not Initiated';
                    }
                    update NotifyListToChange_IGI;
                }
            }
           //D-01870 (End)
            
            // ManualSharing - Ownership change - VP (Start)
            
            if(!(blnDeployTestFlag))
            {
                
                set<Id> allshareIDs = new set<Id>();
                for(Engagement__c engshr: Trigger.new)
                {
                  if(Trigger.oldMap!=null && Trigger.oldMap.get(engshr.Id).OwnerId!=null &&  engshr.OwnerId != Trigger.oldMap.get(engshr.Id).OwnerId)
                  {
                    allshareIDs.add(engshr.id);
                  }
                }
                if(allshareIDs != NULL && allshareIDs.size()>0)
                {
                    flag='after';
                    SharingSecurityHelper.persistSharingWithOwner(eng_share, flag, allshareIDs);    
                }
            }
           // ManualSharing - Ownership change - VP (End) 
          // D-01738        
          if(WTTriggerHelper.skipEngagementafterupdate)
          {
           TriggerExclusion.triggerExclude('Engagement', true);
          }
        } //AFTER UPDATE TRIGGER ENDS HERE         
        //B-01689
       Trigger_Engagement_Helper.setsyncOppFromEng();
      
       if(!Test.isRunningTest())
        {
            User SysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            Map<Id, Engagement__c> EngMembersMap 
                    = new Map<Id, Engagement__c>([SELECT Id,Member__r.J2_Dependent__c , SEVIS_LOCK__c , LastModifiedById FROM Engagement__c WHERE Id IN :Trigger.New]);
             List<Engagement__c> oppEnglst = new List<Engagement__c>();
             for(Engagement__c eng:trigger.new)
             {
                Engagement__c queryMember = EngMembersMap.get(eng.id);
                
                boolean old_sevis_lock = false;
                
                if(Trigger.isUpdate)
                {
                    old_sevis_lock = trigger.oldMap.get(eng.Id).SEVIS_LOCK__c;
                }
                
                boolean new_sevis_lock = trigger.newMap.get(eng.Id).SEVIS_LOCK__c; 
                                           
                if((queryMember.Member__r.J2_Dependent__c == NULL || queryMember.Member__r.J2_Dependent__c == false) && !(old_sevis_lock != new_sevis_lock && new_sevis_lock == False && queryMember.LastModifiedById == SysAdmin.Id))
                //if(queryMember.Member__r.J2_Dependent__c == NULL || queryMember.Member__r.J2_Dependent__c == false)
                {
                    oppEnglst.add(eng);
                }
             }
             if(oppEnglst != NULL && oppEnglst.size() > 0)     
            {
                IUtilities.syncEngToOpp(oppEnglst);
            }  
        }      
                 
       }//AFTER TRIGGER ENDS HERE
    //BEFORE TRIGGER STARTS HERE
    if(Trigger.isBefore){
    //BEFORE INSERT TRIGGER STARTS HERE
        if(Trigger.isInsert)
         {
         set<string> setPartnerId = new set<string>();
         //List<Account> partnerAccount = new List<Account>(); // for optimisation effort
         map<String, Account> mapPartAcc = new map<String, Account>();
           //optimisation effort
         /* for(Engagement__c eng:trigger.new){ 
            if(eng.Partner_Id__c != null)
            { 
            setPartnerId.add(eng.Partner_Id__c);
            }
                      
            
           }
           
           if(setPartnerId!=null && setPartnerId.size()>0)
           {
           
           partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                    WHERE Intrax_Id__c IN:setPartnerId AND type = 'Partner']; 
           }
           
           if(partnerAccount !=null && partnerAccount.size()>0)
           {
             for(Account itrAccount : partnerAccount)
             {
              mapPartAcc.put(itrAccount.Intrax_Id__c , itrAccount);             
             }
           
           }
          
           system.debug('@@partnerAccount' +partnerAccount);
           
            */        
           //optimisation effort
         
         
            for(Engagement__c eng:trigger.new){ 
            //List<Account> partnerAccount1 = new List<Account>(); // for optimisation effort
                
            if(eng.Intrax_Program__c == 'AuPairCare' && eng.Type__c == 'Participant' && (eng.In_Country__c == '' || eng.In_Country__c == NULL))
            {
                eng.In_Country__c = 'No';
            }
             //optimisation effort 
            List<Account> partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                    WHERE Intrax_Id__c =: eng.Partner_Id__c
                                    AND type = 'Partner']; 
                            
            //optimisation effort 
            
            //B-03105 Engagement SEVIS Fields Defaults for APC
             if(eng.Intrax_Program__c == 'AuPairCare' && eng.Type__c == 'Participant')
            {
                eng.SEVIS_Position__c = '330-INDEPENDENT NON PROFIT HOSPITALS OR OTHER ORGANIZATION GROUPS';
                eng.SEVIS_Program__c = '13-AUPAIR';
                eng.SEVIS_Subject_Category__c = 'Family and Consumer Sciences/Human Sciences';
                eng.SEVIS_Subject_Code__c = 'Child Care Provider/Assistant 19.0709';
                eng.Other_Org_Funding__c =true;
                eng.Other_Org_Name__c = 'Current Program Sponsor';
                eng.Total_Compensation__c=9983;
                
            }
            
            //END B-03105
            //optimisation effort 
         /* if(mapPartAcc!=null && mapPartAcc.size()>0){
               if(mapPartAcc.get(eng.Partner_Id__c)!= null)
               {
                partnerAccount1.add(mapPartAcc.get(eng.Partner_Id__c));
                }
               }  */
              //optimisation effort 
                     
            if (partnerAccount.size() > 0){
                System.debug('Setting the ID');
                eng.Partner_Account__c = partnerAccount[0].Id;
                system.debug('@@partnerAccount' +partnerAccount[0].Id);
            }
            else
                eng.Partner_Account__c = NULL;
        }
         } //BEFORE INSERT TRIGGER ENDS HERE
         
          //BEFORE UPDATE TRIGGER STARTS HERE
         if(Trigger.isUpdate)
         {
            Set<Id> engIds = new Set<Id>();
            //optimisation effort
           /* Set<string> setPartnerId = new set<string>();
            List<Account> partnerAccount = new List<Account>();
            Set<ID> setaccntId = new set<ID>();
            list<Account> AccountLastName1 = new list<Account>();
            list<Account> AccountLastName = new list<Account>();
            map<String, Account> mapPartAcc = new map<String, Account>();
            map<String, Account> mapAccLastName = new map<String, Account>();
            
            for(Engagement__c eng:trigger.new){ 
            string old_Partner = trigger.oldMap.get(eng.Id).Partner_Id__c;
            string new_Partner = trigger.newMap.get(eng.Id).Partner_Id__c;
            System.debug('Old Partner '+old_Partner+' New Partner '+new_Partner);
            
            if(eng.Dep_PNR_number__c != Trigger.oldMap.get(eng.Id).Dep_PNR_number__c &&  (eng.Intrax_Program__c == 'AuPairCare'))
           {
               if (eng.Dep_PNR_number__c != NULL)
               {
                if (eng.Account_Id__c != NULL)
                {
                 setaccntId.add(eng.Account_Id__c);
                 system.debug('@@ eng.Account_Id__c' +eng.Account_Id__c);
                 }
                }
            }
            if(eng.Partner_Id__c != null)
            { 
              if(((old_Partner != new_Partner) || (old_Partner == new_Partner)) && new_Partner != NULL) {
              setPartnerId.add(eng.Partner_Id__c);
             }
            }
                      
            
           }
           
           if(setaccntId!=null && setaccntId.size()>0)
           {
            AccountLastName1 = [SELECT LastName FROM Account Where Id IN:setaccntId];
           }
           if(setPartnerId!=null && setPartnerId.size()>0)
           {
           
           partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                    WHERE Intrax_Id__c IN:setPartnerId AND type = 'Partner']; 
           }
           if(partnerAccount !=null && partnerAccount.size()>0)
           {
             for(Account itrAccount : partnerAccount)
             {
              mapPartAcc.put(itrAccount.Intrax_Id__c , itrAccount);             
             }
           
           }
           if(AccountLastName1!=null && AccountLastName1.size()>0)
           {
            for(Account itrAccount : AccountLastName1)
            {
             mapAccLastName.put(itrAccount.Id,itrAccount);
            }
                      
           }
            */        
           //optimisation effort
        for(Engagement__c eng:trigger.new){
        // List<Account> partnerAccount1 = new List<Account>(); // for optimisation effort
            
            if(eng.Intrax_Program__c == 'AuPairCare' && eng.Type__c == 'Participant' && (eng.In_Country__c == '' || eng.In_Country__c == NULL))
            {
                eng.In_Country__c = 'No';
            }
             
            strEngName= eng.Name;
               string old_Partner = trigger.oldMap.get(eng.Id).Partner_Id__c;
                string new_Partner = trigger.newMap.get(eng.Id).Partner_Id__c;
            System.debug('Old Partner '+old_Partner+' New Partner '+new_Partner);
            if(((old_Partner != new_Partner) || (old_Partner == new_Partner)) && new_Partner != NULL) 
            {
             //optimisation effort
            List<Account> partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                    WHERE Intrax_Id__c =: eng.Partner_Id__c
                                    AND type = 'Partner'];
            //optimisation effort
            
         /*  if(mapPartAcc!=null && mapPartAcc.size()>0)
           {
            if(mapPartAcc.get(eng.Partner_Id__c)!= null)
             {
              partnerAccount1.add(mapPartAcc.get(eng.Partner_Id__c));
             }
            } */ 
           
            if (partnerAccount.size() > 0){
                System.debug('Setting the ID');
                eng.Partner_Account__c = partnerAccount[0].Id;
                system.debug('@@partnerAccount' +partnerAccount[0].Id);
            }
            else
               eng.Partner_Account__c = NULL;   
            }
           else if(new_Partner==NULL){
                eng.Partner_Account__c = NULL; 
           }       
          // if(eng.OwnerId != Trigger.oldMap.get(eng.Id).OwnerId && Trigger.oldMap.get(eng.Id).OwnerId!=null)
           if(Trigger.oldMap!=null && Trigger.oldMap.get(eng.Id).OwnerId!=null &&  eng.OwnerId != Trigger.oldMap.get(eng.Id).OwnerId)
           {
             if(!(blnDeployTestFlag && strEngName.containsIgnoreCase('Test')))
            engIds.add(eng.Id); // Manual sharing code below
            system.debug('**engIds**'+engIds);
           }
           
           /*if(eng.Status__c != Trigger.oldMap.get(eng.Id).Status__c &&  (eng.Status__c == 'On Program'))
           {
                eng.In_Country__c = 'Yes';
           }*/
           
           
           if(eng.Dep_PNR_number__c != Trigger.oldMap.get(eng.Id).Dep_PNR_number__c &&  (eng.Intrax_Program__c == 'AuPairCare'))
           {
               if (eng.Dep_PNR_number__c != NULL)
               {
                if (eng.Account_Id__c != NULL)
                {
                    //optimisation effort
                    list<Account> AccountLastName = [SELECT LastName FROM Account Where Id =: eng.Account_Id__c];
                     //optimisation effort
                  /*  if(mapAccLastName!=null && mapAccLastName.size()>0)
                    {
                      if(mapAccLastName.get(eng.Account_Id__c)!=null)
                      {
                       AccountLastName.add(mapAccLastName.get(eng.Account_Id__c));
                      }
                    }  */
                     
                   
                    if(AccountLastName != NULL && AccountLastName.size()>0)
                    {
                        eng.Departure_Trip_URL__c = 'https://www.checkmytrip.com/cmt/apf/cmtng/pnr_retrieve?&SITE=NCMTNCMT&LANGUAGE=US&R=' + eng.Dep_PNR_number__c + '&N=' + AccountLastName[0].LastName;
                    }
                }
               }
               else 
               {
                   eng.Departure_Trip_URL__c = NULL;
               }
            }
           
         } 
        // Manual sharing - Ownership Change - VP
         if(EngIds!=null && EngIds.size()>0)
           {           
            /*SharingSecurityHelper.persistEngSharing(
            JSON.serialize(
            [Select e.UserOrGroupId, e.RowCause, e.ParentId, e.LastModifiedDate, e.LastModifiedById, e.IsDeleted,  e.AccessLevel From Engagement__Share e
             WHERE  e.ParentId IN :engIds AND 
                    RowCause = 'Manual'])); */
            flag='before';
            SharingSecurityHelper.persistSharingWithOwner(eng_share, flag, engIds);                    
           }
           
           
         }//BEFORE UPDATE TRIGGER ENDS HERE
      }//BEFORE TRIGGER ENDS HERE
    }