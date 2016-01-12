trigger Trigger_Con_Match on Match__c (after insert, after update, before update,before insert) {    
// TRIGGER VARS INSTANTIATION
    if(TriggerExclusion.isTriggerExclude('Match')){
        return;
    }
    List<Engagement__c> lstMatchEngs = new List<Engagement__c>();
    list<Match__c> lstOtherMatches = new list<Match__c>(); 
    List<Match__c>lstWithdrawnMatches = new List<Match__c>();
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    Map<Id,Match__c> MapHFRecMatchesToBeNotified = new  Map<Id,Match__c>();
    
    //Story B-01705  (Start)
    //Map<Id,Match__c> MapInterviewtobeNotified = new  Map<Id,Match__c>();
    //Map<Id,Match__c> MapInterviewOffertobeNotified = new  Map<Id,Match__c>(); 
    Set<Id> MapInterviewtobeNotified = new  Set<Id>();
    Set<Id> MapInterviewOffertobeNotified = new  Set<Id>();
    boolean SevisUEV;
    list<Notification__c> CloseInitiatedNotify  = new  list<Notification__c>();
    //Story B-01705  (End)
    
    //Check for the request type
    // BEFORE TRIGGER STARTS HERE 
    if(Trigger.isBefore){
    //BEFORE UPDATE TRIGGER STARTS HERE  
        if(Trigger.isUpdate){
            //JOSE B-03283
            Map<Id,Engagement__c> MapEngPre;
            try{
            set<Id> setIdEngPre = new set<Id>();
            Set<ID> ids = Trigger.newMap.keySet();
            list<Match__c> mlist = [SELECT Id, Engagement__c FROM Match__c WHERE id in :ids];
            for(Match__c m:mlist){
                if(m.Engagement__c != null)
                setIdEngPre.add(m.Engagement__c);
            }
            if(setIdEngPre!=null && setIdEngPre.size()>0)
            MapEngPre = new map<Id,Engagement__c>([select Id, Name, In_Country__c from Engagement__c where Id IN: setIdEngPre]);
            
            }catch(Exception e){
                system.debug('******** EXCEPTION IN Trigger_Con_Match RETRIEVING AuPairCare Match: ' + e);
            }
             
             //D-02107
                 
             MatchTriggerHelper.setHostAccount(trigger.new, trigger.oldMap);
           //D-02107  
           
           //B-03463
           MatchTriggerHelper.setAddHostAcc(trigger.new,trigger.oldMap);
           //B-03463
            // Added as per AY2 293
            for(Match__c m: trigger.new){ 
                
                system.debug('******* Updating validation Visit date');
                
                String old_MatchStatus = trigger.oldMap.get(m.Id).Status__c ;
                String new_MatchStatus = trigger.newMap.get(m.Id).Status__c ;
                
                if(m.Status__c == 'Confirmed' && IUtilities.isIncluded(m.Intrax_Program_Option__c,'Ayusa High School') ){//&& map_matches.get(m.Id) == 'Complete')
                    try{
                        date old_vv_date = trigger.oldMap.get(m.Id).Validation_Visit_Date__c;
                        date new_vv_date = trigger.newMap.get(m.Id).Validation_Visit_Date__c;
                        
                        String old_MatchType = trigger.oldMap.get(m.Id).Match_Type__c ;
                        String new_MatchType = trigger.newMap.get(m.Id).Match_Type__c ;
                        
                        if(m.Match_Type__c == 'Temporary' && m.Validation_Visit_Date__c == null ) m.Validation_Visit_Due_Date__c = m.Start_Date__c + 20; //&& m.Validation_Visit_Due_Date__c == null
                        else if(m.Match_Type__c == 'Temporary' && m.Validation_Visit_Date__c != null && old_vv_date != new_vv_date ) m.Validation_Visit_Due_Date__c = m.Validation_Visit_Date__c + 20; //&& m.Validation_Visit_Due_Date__c == null
                        else if(m.Match_Type__c == 'Permanent' && m.Validation_Visit_Date__c == null ) m.Validation_Visit_Due_Date__c = m.Start_Date__c + 45; //&& m.Validation_Visit_Due_Date__c == null
                        else if (new_MatchType == 'Permanent' && old_MatchType == 'Temporary' &&  m.Validation_Visit_Date__c != null) m.Validation_Visit_Due_Date__c = null;
                        
                    }catch(Exception e){
                        system.debug('******** In order to set a Validation Visit Date, an Start Date is required: ' + e);
                    }
                }
                
                if(old_MatchStatus != new_MatchStatus && new_MatchStatus == 'Confirmed'){
                //JOSE B-03102 - Field Portal Assessments and Logic (Match Update Due Dates)
                    try{
                        if(m.Intrax_Program__c =='AuPairCare'){
                            system.debug('@@@@@m.HF_Arrival_Date__c: ' + m.HF_Arrival_Date__c);
                            date dArrival;
                            if(m.HF_Arrival_Date__c != null){
                                //HF AND PT monthly contacts due dates = the last day of the month when the PT arrives in the home of the HF
                                dArrival = m.HF_Arrival_Date__c.addMonths(1).toStartOfMonth() - 1;
                                system.debug('@@@@@dArrival: ' + dArrival);
                                m.HF_Monthly_Contact_Due_Date__c = dArrival;
                                m.PT_Monthly_Contact_Due_Date__c = dArrival;
                                m.Orientation_Due_Date__c = m.HF_Arrival_Date__c + 14;
                                m.Welcome_Call_Due_Date__c = m.HF_Arrival_Date__c + 2;
                            }
                            //JOSE B-03283
                            if(m.Engagement__c != null && MapEngPre.get(m.Engagement__c).In_Country__c == 'Yes' && m.Start_Date__c!=null){
                                
                                m.ICAP_HF_check_in_due_date__c = m.Start_Date__c + 45;
                                m.ICAP_PT_check_in_due_date__c = m.Start_Date__c + 45;
                            }
                        }
                        //END JOSE B-03102 
                    }catch(Exception e){
                            system.debug('******** EXCEPTION IN Trigger_Con_Match WHEN AUPAIRCARE Match IS CONFIRMED: ' + e);
                    }
                }
                if(old_MatchStatus != new_MatchStatus && new_MatchStatus == 'Completed'){
                    m.Actual_End_Date__c = m.End_Date__c;
                }
                
            }
            
            //IUtilities.setValidationVisitDueDate(trigger.new);
              //SEVIS MATCH STARTS
        /*  set<Id> setEngId = new set<Id>();
          set<Id> setEngIds = new set<Id>();
          Map<Id,Engagement__c> mapEngRec;
          Map<Id,Engagement__c> mapEngRecs;
          List<Engagement__c> engagements = new List<Engagement__c>(); 
          for (Match__c newValues : Trigger.new){
           if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' )
           {
            if(newValues.Engagement__c !=null)
            {
             setEngId.add(newValues.Engagement__c);
            }
           }
          }
      
       if (setEngId !=null && setEngId.size()>0)
       {
       
       mapEngRec = new Map<Id,Engagement__c>([select Id,Sevis__c,Sevis_UEV_SOA_Add__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id IN:setEngId ]);
               
       }
     
           
             for (Match__c newValues : Trigger.new){
             
             if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' ){
               
                if(mapEngRec!=null && newValues.Engagement__c !=null && mapEngRec.size()>0)
                {
                 if(mapEngRec.get(newValues.Engagement__c)!=null)
                 {
                  engagements.add(mapEngRec.get(newValues.Engagement__c));
                  }
                 }                 
                 
                if(engagements.size() > 0){
                    
                }
                else{
                   
                    newValues.SEVIS_UEV_SOA_Add__c = false;
                    
                }
            }
            
           }
            */
            //SEVIS MATCH ENDS
   
        }
         //BEFORE UPDATE TRIGGER ENDS HERE
        //BEFORE INSERT TRIGGER STARTS HERE
       if(Trigger.isInsert)
       {   //D-02107
         
         MatchTriggerHelper.setHostAccount(trigger.new, trigger.oldMap);
       }

        //BEFORE INSERT TRIGGER ENDS HERE   
         
    }
    // BEFORE TRIGGER ENDS HERE 
    // AFTER TRIGGER STARTS HERE  
    if(Trigger.isAfter) {
    // AFTER ALL TRIGGER STARTS HERE    
        string strMatName;
        Set<Id> ConfMatchIds = new set<Id>();
        Set<Id> ValidatorMatchIds = new set<Id>();
        Set<Id> NewMatchIds = new set<Id>();
        
        date map_old_date ;
        date map_new_date;
        string matName;
        string old_camp_session;
        string new_camp_session;
        
        //Story B-01705  (Start)
        string old_InterviewStatus;
        string new_InterviewStatus;
        
        string old_OfferStatus;
        string new_OfferStatus;
        //Story B-01705  (End)
        // AFTER ALL TRIGGER ENDS HERE    
        //Check for the event type
        // AFTER INSERT TRIGGER STARTS HERE     
        if(Trigger.isInsert) {
            //Start Pay Event B-02402
            //-->Start APC PayEvent POC
            if(MatchTriggerHelper.firstRun){ 
                MatchTriggerHelper.firstRun = false; 
                //Log new Match owners for APC Match Owner History tracking
                List<Id> apcMatchIds = New List<Id>();
                Map<Id, Id> matchPositionIds = New Map<Id, Id>();
                for(Match__c m : Trigger.new){
                    if(m.Intrax_Program__c == 'AuPairCare'){
                        apcMatchIds.add(m.Id);
                        matchPositionIds.put(m.Id, m.Position_Name__c);
                    }
                }
                MatchTriggerHelper.logOwnership(matchPositionIds);
            }
            //End Pay Event B-02402
            
                          
            //Story B-01705  (Start)
            MapInterviewtobeNotified = new  Set<Id>();
            //Story B-01705  (End)  
            
            // code optimisation 
            Map<Id,Engagement__c> MapEng;
            Map<Id,Position__c> MapPos;
            set<Id> setIdEng = new set<Id>();
            set<Id> setIdPos = new set<Id>();
            
            for(Match__c matInfo : trigger.new){
                if(matInfo.Engagement__c != null)
                {
                    setIdEng.add(matInfo.Engagement__c);
                }
                if(matInfo.Position_Name__c != null)
                {
                 if(matInfo.status__c!='Withdrawn' && matInfo.status__c!='Saved')
                 {
                    setIdPos.add(matInfo.Position_Name__c);
                 }
                }

                if(matInfo.Intrax_Program__c == 'AuPairCare'){
                    Notification_Generator.callAPCNotifications(null, matInfo);//old,new,
                }             
            }
            
            if(setIdEng != null && setIdEng.size() > 0){
                MapEng = new map<Id, Engagement__c>([SELECT Id, Partner_Id__c,In_Country__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c where Id IN :setIdEng]);
            }
            
            if(setIdPos != null && setIdPos.size() > 0){
                MapPos = new map<Id,Position__c>([select Id, OwnerId, Double_Placement_Indicated__c from Position__c where Id IN: setIdPos]);
            }
            // code optimisation    
            
            system.debug('check point');
            list<Match__c> lstHFRecMatchesToBeNotified = new list<Match__c>();
            for(Match__c matInfo : trigger.new){
                
                //Story B-01705  (Start)
                
                if(matInfo.Interview_Status__c == 'Initiated' && matInfo.RecordTypeId==Constants.MAT_INTERNSHIP && matInfo.Intrax_Program__c =='Internship' && matInfo.Engagement__c != NULL)
                {
                    //list<Notification__c> lstIntvExistNotify = [SELECT ID FROM Notification__c WHERE Match__c = :matInfo.Id AND Engagement__c = :matInfo.Engagement__c AND Type__c = 'Interview' ];
                    //if (lstIntvExistNotify.size() == 0)
                    //{
                    MapInterviewtobeNotified.add(matInfo.Id);
                    //}
                }
                
                //Story B-01705  (End)
                
                    // code optimisation 
                    system.debug('check point');
                    //lstMatchEngs = [SELECT Id, Partner_Id__c,In_Country__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: matInfo.Engagement__c];
                   if(matInfo.Engagement__c != null)
                   {
                    if(mapEng.get(matInfo.Engagement__c)!=null)
                    {
                        lstMatchEngs.add(mapEng.get(matInfo.Engagement__c));
                    }
                   }
                    // code optimisation                  
                //IGI 818
                //AA B-03326
                if(matInfo.RecordTypeId==Constants.MAT_INTERNSHIP && matInfo.Intrax_Program__c =='Internship'){
                    new_camp_session = trigger.newMap.get(matInfo.Id).Campaign_Session__c ;
                    if(trigger.oldMap != null) old_camp_session = trigger.oldMap.get(matInfo.Id).Campaign_Session__c ;
                    
                    MatchTriggerHelper.count_camp_session(old_camp_session, new_camp_session);
                }
                //end IGI 818
                
                strMatName=matInfo.name;
                //if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test'))) 
                NewMatchIds.add(matInfo.Id);
                if(matInfo.Status__c=='Recommended' && matInfo.RecordTypeId==Constants.MAT_AYUSA && matInfo.Intrax_Program__c =='Ayusa')
                {
                    lstHFRecMatchesToBeNotified.add(matInfo);
                }                    
                if(matInfo.status__c!='Withdrawn' && matInfo.status__c!='Saved')
                {
                    
                    // code optimisation 
                     system.debug('check point');
                    //Position__c position =[select OwnerId, Double_Placement_Indicated__c from Position__c where Id = :matInfo.Position_Name__c];
                    Position__c position = new Position__c();
                    if(mapPos.get(matInfo.Position_Name__c)!=null)
                    {
                        position = mapPos.get(matInfo.Position_Name__c);
                    }
                    
                    
                    List<Engagement__c> LstEngtoUpdate = new List<Engagement__c>();
                   // code optimisation 
                        
                            if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                            {
                                for(Engagement__c engInfo : lstMatchEngs){ 
                                    if(engInfo.Placement_status__c=='Not Placed' || engInfo.Placement_status__c=='EXEMPT')
                                    {
                                        if(matInfo.status__c!='Confirmed' && matInfo.status__c!='Withdrawn' && matInfo.status__c!='Saved'){
                                            engInfo.Placement_status__c='Pending';                                      
                                        }                                                                               
                                    }
                                    //B-01193
                                    if(matInfo.Status__c=='Confirmed'){
                                        engInfo.Placement_status__c='Confirmed';
                                        if(position!=null && position.OwnerId!=null && String.valueOf(position.OwnerId).left(3) != '00G')
                                            engInfo.OwnerId = position.OwnerId;                                                                 
                                    }
                                    // code optimisation 
                                    LstEngtoUpdate.add(engInfo);
                                }
                                if(LstEngtoUpdate!=null && LstEngtoUpdate.size()>0)
                                {
                                 system.debug('check point');
                                 update LstEngtoUpdate;
                                }
                                // code optimisation 
                            }
                        } 
                //B-01478
                if(matInfo.Status__c == 'Confirmed' && matInfo.Intrax_Program__c =='Ayusa')
                {                       
                    if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                    {
                        for(Engagement__c engInfo : lstMatchEngs)
                        {   
                            //Commented for B-02465 (Start)                            
                            //engInfo.Engagement_End__c=matInfo.End_Date__c;
                            //update engInfo;
                            //Commented for B-02465 (End) 
                        }
                    }
                }                                  
            }
            
            if(!Test.isRunningTest()){
                for(Match__c mat: Trigger.new){
                    if(mat.start_date__c!=null)
                    {
                        if(trigger.oldMap != NULL){
                            map_old_date = trigger.oldMap.get(mat.Id).start_date__c;
                            map_new_date = trigger.newMap.get(mat.Id).start_date__c;
                        }
                    }
                    if(trigger.oldMap != NULL){
                        matName = trigger.newMap.get(mat.Id).name;
                    }
                    /*if(map_new_date != NULL && mat.status__c == 'Confirmed'){
Notification_Generator notifygen = new Notification_Generator();
notifygen.CreatePTOrientationNotification(mat.Id);
}*/
                }
            }
            //call helper class method to execute the logic to update the related opportunity and match records
            system.debug('*******strMatName-1'+ strMatName);
            // If(matName !='TestMatchTestTest1234Test####Test123' || !blnDeployTestFlag)
            //  if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))
            //  MatchTriggerHelper.updateOpportunityOperationStageByMatchStatus(Trigger.Newmap.Keyset());
            
            // Call to SharingHelper for sharing when Mtach is created and updated
            system.debug('*******strMatName-2'+ strMatName);
            if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))  
                SharingSecurityHelper.shareMatch(ConfMatchIds,ValidatorMatchIds,NewMatchIds);
            if(lstHFRecMatchesToBeNotified!=null && lstHFRecMatchesToBeNotified.size()>0)
            {
                Notification_Generator.CreateRecommendedStuNotification(lstHFRecMatchesToBeNotified);
            }
            
            //Story B-01705  (Start)
            if(MapInterviewtobeNotified != NULL && MapInterviewtobeNotified.size() > 0)
            {
                Notification_Generator.CreateIGIInterviewNotification(MapInterviewtobeNotified);
            }
            //Story B-01705  (End)
            //SEVIS MATCH STARTS
            
            //B-03349       
            MatchTriggerHelper.updateWTOtherMatchesToWithdrawn(trigger.new, trigger.oldMap); 
            
         /* set<Id> setEngId = new set<Id>();
          set<Id> setEngIds = new set<Id>();
          Map<Id,Engagement__c> mapEngRec;
          Map<Id,Engagement__c> mapEngRecs;
          List<Engagement__c> engagements = new List<Engagement__c>(); 
          for (Match__c newValues : Trigger.new){
           if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' )
           {
            if(newValues.Engagement__c !=null)
            {
             setEngId.add(newValues.Engagement__c);
            }
           }
        
         }
      
       if (setEngId !=null && setEngId.size()>0)
       {
       
       mapEngRec = new Map<Id,Engagement__c>([select Id,Sevis__c,Sevis_UEV_SOA_Add__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id IN:setEngId ]);
               
       }
     
             for (Match__c newValues : Trigger.new){
             
             if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' ){
               
                if(mapEngRec!=null && newValues.Engagement__c !=null && mapEngRec.size()>0)
                {
                 if(mapEngRec.get(newValues.Engagement__c)!=null)
                 {
                  engagements.add(mapEngRec.get(newValues.Engagement__c));
                  }
                 }                 
                 
                if(engagements.size() > 0){
                    
                        engagements[0].Sevis_UEV_SOA_Add__c =  true;
                        engagements[0].Sevis_UEV_Nonstandard_SoA__c = false;
                        update engagements[0];
                    
                }
               
            }
            
           }*/
            
            //SEVIS MATCH ENDS
            
            
            
        }
        // AFTER INSERT TRIGGER ENDS HERE 
        // AFTER UPDATE TRIGGER STARTS HERE 
        if(Trigger.isUpdate) {
            
            //Story B-01705  (Start)
            MapInterviewtobeNotified = new  Set<Id>();
            MapInterviewOffertobeNotified = new  Set<Id>();
            //Story B-01705  (End)
            
            list<Match__c> lstHFRecMatchesToBeNotified = new list<Match__c>();
            
            list<Match__c> lstHFConfStuToBeNotified = new list<Match__c>();
            list<Engagement__c> lstEngToBeUpdated = new List<Engagement__c>();
            Map<Id,Engagement__c> MapEngToBeUpdated = new Map<Id,Engagement__c>();
            Map<Id,Account> mapAccToBeUpdated = new Map<Id,Account>();
            Map<Id,Applicant_Info__c> mapPTAppToBeUpdated = new Map<Id,Applicant_Info__c>();
            
            //AYII-680 (Start)
            Map<id,Position__c>lstPosToBeUpdated=New Map<id,Position__c>();
            //AYII-680 (End)
            //optimisation effort
            
           /* set<ID> setPosName = new set<ID>();
            set<Id> setIdEng = new set<Id>();
            set<ID> setMid = new set<ID>();
            Map<Id, Engagement__c> MapEng;
            set<ID> setMatchWith = new set<ID>();
            set<ID> setEngWith = new set<ID>();
            set<Id>setMatchinit = new set<Id>();
            set<Id>setEnginit = new set<Id>();
            set<Id>setMatchAcc = new set<Id>();
            set<Id>setEngAcc = new set<Id>();
            set<Id>setMatchIntv = new set<Id>();
            set<Id>setEngIntv = new set<Id>();
            set<Id>setMatchIntvOffr = new set<Id>();
            set<Id>setEngIntvOffr = new set<Id>();
            map<Id,list<Notification__c>> mapInitiatedExistNotify = new map<Id,list<Notification__c>>();
            map<Id,list<Notification__c>> mapAcceptedExistNotify = new map<Id,list<Notification__c>>();
            map<Id,list<Notification__c>> mapIntvExistNotify =new map<Id,list<Notification__c>>();
            map<Id,list<Notification__c>> mapIntvOfferedExistNotify= new map<Id,list<Notification__c>>();
            List<Notification__c> listInitiatedExistNotify = new List <Notification__c>();
            List<Notification__c> listAcceptedExistNotify = new List <Notification__c>();
            List<Notification__c> listIntvExistNotify = new List <Notification__c>();
            List<Notification__c> listIntvOfferedExistNotify = new List <Notification__c>();
                        
           for(Match__c m  :Trigger.new){
            if(m.status__c=='Withdrawn' && m.Engagement__c!= null)
            {
             setMatchWith.add(m.Id);
             setEngWith.add(m.Engagement__c);
            }
            
            setPosName.add(m.Position_Name__c);
            setMid.add(m.id);
            setIdEng.add(m.Engagement__c);
            old_InterviewStatus = trigger.oldMap.get(m.Id).Interview_Status__c;
            new_InterviewStatus = trigger.newMap.get(m.Id).Interview_Status__c;
            
            old_OfferStatus = trigger.oldMap.get(m.Id).Offer_Status__c;
            new_OfferStatus = trigger.newMap.get(m.Id).Offer_Status__c;
            
            if(setMatchWith!=null && setMatchWith.size()>0 && setEngWith!=null && setEngWith.size()>0)
            {
             if(m.Engagement__c !=null)
             {
             lstOtherMatches =  [SELECT Id,  Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id, Engagement__c FROM Match__c WHERE Engagement__c IN:setEngWith and id NOT IN: setMatchWith];
             }
              if (m.Intrax_Program__c == 'Ayusa')
              {
              lstWithdrawnMatches = [SELECT Id,  Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id, Engagement__c FROM Match__c WHERE Engagement__c IN:setEngWith and id NOT IN: setMatchWith and status__c IN ('Withdrawn', 'Saved','Ended Early')];
              }
              else
              {
              lstWithdrawnMatches = [SELECT Id,  Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id, Engagement__c FROM Match__c WHERE Engagement__c IN:setEngWith and id NOT IN: setMatchWith and status__c IN ('Withdrawn', 'Ended Early')];
              }
            }
         
            
            if(old_InterviewStatus != new_InterviewStatus && old_InterviewStatus == 'Initiated' && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
             {
              setMatchinit.add(m.Id);
              setEnginit.add(m.Engagement__c);            
             }
             system.debug('@@setEnginit' +setEnginit);
            if(old_OfferStatus != new_OfferStatus && (new_OfferStatus == 'Accepted' || new_OfferStatus == 'Declined') && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
             {
              setMatchAcc.add(m.Id);
              setEngAcc.add(m.Engagement__c);
             }
            
            if(old_InterviewStatus != new_InterviewStatus && m.Interview_Status__c == 'Initiated' && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
            {
             setMatchIntv.add(m.Id);
             setEngIntv.add(m.Engagement__c);
            }
            system.debug('@@setEnginit' +setMatchIntv);
            if(old_OfferStatus != new_OfferStatus && m.Offer_Status__c == 'Offered' && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
             {
              setMatchIntvOffr.add(m.Id);
              setEngIntvOffr.add(m.Engagement__c);
             }
            
                      
          }
              
           
          if(setMatchinit !=null && setMatchinit.size()>0 && setEnginit!=null && setEnginit.size()>0) 
          { 
           listInitiatedExistNotify = [SELECT Match__c FROM Notification__c WHERE Match__c IN: setMatchinit AND Engagement__c IN: setEnginit AND Type__c = 'Initiated' AND Status__c = 'Not Started' ];
          }
           if(setMatchAcc !=null && setMatchAcc.size()>0 && setEngAcc!=null && setEngAcc.size()>0) 
          {
           listAcceptedExistNotify =[SELECT Match__c FROM Notification__c WHERE Match__c IN:setMatchAcc AND Engagement__c IN:setEngAcc AND Type__c = 'Offer Extended' AND Status__c = 'Not Started' ];
          }
           if(setMatchIntv !=null && setMatchIntv.size()>0 && setEngIntv!=null && setEngIntv.size()>0) 
          {
           listIntvExistNotify =[SELECT Match__c FROM Notification__c WHERE Match__c IN:setMatchIntv AND Engagement__c IN:setEngIntv AND Type__c = 'Initiated' ];
          }
           if(setMatchIntvOffr !=null && setMatchIntvOffr.size()>0 && setEngIntvOffr!=null && setEngIntvOffr.size()>0) 
          {
           listIntvOfferedExistNotify =[SELECT Match__c FROM Notification__c WHERE Match__c IN:setMatchIntvOffr AND Engagement__c IN:setEngIntvOffr AND Type__c = 'Offer Extended'];
          }
          
            
          for (Notification__c noti : listInitiatedExistNotify)
           {
            if (!mapInitiatedExistNotify.containsKey(noti.Match__c))
            {
              mapInitiatedExistNotify.put(noti.Match__c,new List<Notification__c>());
             }
             mapInitiatedExistNotify.get(noti.Match__c).add(noti);
            }   
            
            
           for (Notification__c noti : listAcceptedExistNotify)
           {
            if (!mapAcceptedExistNotify.containsKey(noti.Match__c))
            {
              mapAcceptedExistNotify.put(noti.Match__c,new List<Notification__c>());
             }
             mapAcceptedExistNotify.get(noti.Match__c).add(noti);
            } 
              
            for (Notification__c noti : listIntvExistNotify)
           {
            if (!mapIntvExistNotify.containsKey(noti.Match__c))
            {
              mapIntvExistNotify.put(noti.Match__c,new List<Notification__c>());
             }
             mapIntvExistNotify.get(noti.Match__c).add(noti);
            }  
             
            for (Notification__c noti : listIntvOfferedExistNotify)
           {
            if (!mapIntvOfferedExistNotify.containsKey(noti.Match__c))
            {
              mapIntvOfferedExistNotify.put(noti.Match__c,new List<Notification__c>());
             }
             mapIntvOfferedExistNotify.get(noti.Match__c).add(noti);
            }   
           
          
            if(setIdEng != null && setIdEng.size() > 0){
               MapEng = new map<Id, Engagement__c>([SELECT Id, In_Country__c,Partner_Id__c,Placement_status__c,Status__c, Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id IN: setIdEng LIMIT 1]);

            }
             */ 
              //optimisation effort
            system.debug('***Trigger.newMap.keySet()*********'+Trigger.newMap.keySet());
            List<Account> PTAccList = new List<Account>();
            List<Applicant_Info__c> PTAppList = new List<Applicant_Info__c>();
           /* List<Notification__c> lstInitiatedExistNotify;
            List<Notification__c> lstAcceptedExistNotify;
            List<Notification__c> lstIntvExistNotify;
            List<Notification__c> lstIntvOfferedExistNotify;*/ // for optimisation effort
            for(Match__c m  :Trigger.new){
               
              //Story B-03131
              
            list<Contact> lstHCContacts=new list<Contact>();
            list<Contact> lstHCPos=new list<Contact>();
            list<User> lstUser=new list<User>();
            set<Id> HCContactIds =  new set<Id>();
              
           string  old_Participant_Id = trigger.oldMap.get(m.Id).Participant_Id__c;
           string  new_Participant_Id = trigger.newMap.get(m.Id).Participant_Id__c;
           string  old_Engagement = trigger.oldMap.get(m.Id).Engagement__c;
           string  new_Engagement = trigger.newMap.get(m.Id).Engagement__c;  
             // sharing PT account with HC portal user
               if(old_Participant_Id != new_Participant_Id && new_Participant_Id != NULL){
                    system.debug('Old Part****'+old_Participant_Id);
                    system.debug('New Part****'+new_Participant_Id);
              
                          Position__c position =[select Host_Company_Id__c,OwnerId, Double_Placement_Indicated__c from Position__c where Id = :m.Position_Name__c];
                          system.debug('***position.Host_Company_Id__c******'+position.Host_Company_Id__c);    
                          lstHCContacts = [Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId=: position.Host_Company_Id__c];
                         
                          system.debug('***lstHCContacts******'+lstHCContacts);
                          if(lstHCContacts!=null && lstHCContacts.size()>0)
                          {
                          For(Contact con: lstHCContacts)  
                          HCContactIds.add(con.Id);  
                          system.debug('***HCContactIds******'+HCContactIds);
                   
                          If(HCContactIds!=null)
                          lstUser = [Select u.Type__c, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.ContactId in :HCContactIds];
                          system.debug('***lstUser******'+lstUser);
                          if(lstUser!=null && lstUser.size()>0)
                          {
                            Sharing_Security_Controller.shareAccount(new_Participant_Id,lstUser);
                            system.debug('***share Account******');
                          }
                          }
               }
                if(old_Engagement != new_Engagement && new_Engagement != NULL){
                    system.debug('Old old_Engagement****'+old_Engagement);
                    system.debug('New new_Engagement****'+new_Engagement);
                     
                          Position__c position =[select Host_Company_Id__c,OwnerId, Double_Placement_Indicated__c from Position__c where Id = :m.Position_Name__c];
                          system.debug('***position.Host_Company_Id__c******'+position.Host_Company_Id__c);    
                          lstHCContacts = [Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId=: position.Host_Company_Id__c];
                          
                          system.debug('***lstHCContacts******'+lstHCContacts);
                          if(lstHCContacts!=null && lstHCContacts.size()>0)
                          {
                          For(Contact con: lstHCContacts)  
                          HCContactIds.add(con.Id);  
                          system.debug('***HCContactIds******'+HCContactIds);
                   
                          If(HCContactIds!=null)
                          lstUser = [Select u.Type__c, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.ContactId in :HCContactIds];
                          system.debug('***lstUser******'+lstUser);
                          if(lstUser!=null && lstUser.size()>0)
                          {
                            Sharing_Security_Controller.shareEngRecord(new_Engagement,lstUser);
                            system.debug('***share Engagement******');
                          }
                          }
             
               }  
               
                String match_status_old = trigger.oldMap.get(m.Id).Status__c;
                String match_status_new = trigger.newMap.get(m.Id).Status__c;
               
                if(match_status_old != match_status_new && match_status_new == 'Confirmed')
                { 
                     system.debug('Old old_Engagement****'+match_status_old);
                     system.debug('New new_Engagement****'+match_status_new);
                     Position__c position =[select Host_Company_Id__c,OwnerId, Double_Placement_Indicated__c,Id, Intrax_Program__c from Position__c where Id = :m.Position_Name__c];
                     Engagement__c eng = [Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id=: m.Engagement__c];
                     
                     //Updating Position Status for AuPairCare
                     /*if(position.Intrax_Program__c == 'AuPairCare') {                  	
                     	position.Status__c = 'Closed - Filled';                     	
                        lstPosToBeUpdated.put(position.id,position);
                     }*/
                       
                      
                      //   sharing  for HC Portal User to Engagement and PT Account 
                      lstHCContacts = [Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId=: position.Host_Company_Id__c];
                         
                          system.debug('***lstHCContacts******'+lstHCContacts);
                          if(lstHCContacts!=null && lstHCContacts.size()>0)
                          {
                          For(Contact con: lstHCContacts)  
                          HCContactIds.add(con.Id);  
                          system.debug('***HCContactIds******'+HCContactIds);
                   
                          If(HCContactIds!=null)
                          lstUser = [Select u.Type__c, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.ContactId in :HCContactIds];
                          system.debug('***lstUser******'+lstUser);
                          if(lstUser!=null && lstUser.size()>0)
                          {
                            Sharing_Security_Controller.shareAccount(m.Participant_Id__c,lstUser);
                            Sharing_Security_Controller.shareEngRecord(eng.Id,lstUser);
                            system.debug('***share Account******');
                          }
                          }     
                      // sharing for PT Users and Partner Users on Position and HC Account   
                          
                     List<Applicant_Info__c> appInfo =new List<Applicant_Info__c>();
                                List<User> lstParnerUsr = new List<User>();
                                 appInfo = [Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c,a.CreatedById, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                    where a.engagement__c = :m.Engagement__c];
                                 if(appInfo!=null && appInfo.size()>0)
                                     {
                                       system.debug('***appInfo******'+appInfo);
                                       for(Applicant_Info__c aInfo : appInfo)
                                        {                               
                                            //Share the PT Account with the applicant
                                            system.debug('***sharing CreatedBy__c******'+aInfo.CreatedBy__c);
                                            Sharing_Security_Controller.shareAccount(position.Host_Company_Id__c, aInfo.CreatedBy__c);
                                            Sharing_Security_Controller.sharePositionRecord(position.Id, aInfo.CreatedBy__c);
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
                                            Sharing_Security_Controller.shareAccount(position.Host_Company_Id__c,lstParnerUsr);
                                            Sharing_Security_Controller.sharePositionRecord(position.Id,lstParnerUsr);
                                        }
                                }  
                
                     
             
                }
              //End B-03131 
             
                //Story B-01705  (Start)
                old_InterviewStatus = trigger.oldMap.get(m.Id).Interview_Status__c;
                new_InterviewStatus = trigger.newMap.get(m.Id).Interview_Status__c;
                
                old_OfferStatus = trigger.oldMap.get(m.Id).Offer_Status__c;
                new_OfferStatus = trigger.newMap.get(m.Id).Offer_Status__c;
               /* lstInitiatedExistNotify = new List<Notification__c>(); // for optimisation effort
                lstAcceptedExistNotify = new List<Notification__c>();
                lstIntvExistNotify = new List<Notification__c>(); 
                lstIntvOfferedExistNotify = new List<Notification__c>();*/
                
                if(old_InterviewStatus != new_InterviewStatus && old_InterviewStatus == 'Initiated' && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
                {  
                    list<Notification__c> lstInitiatedExistNotify = [SELECT ID FROM Notification__c WHERE Match__c =: m.Id AND Engagement__c =: m.Engagement__c AND Type__c = 'Initiated' AND Status__c = 'Not Started' ];
                      //optimisation effort 
                      /* if(mapInitiatedExistNotify!=null && mapInitiatedExistNotify.size()>0)
                        {
                         if(mapInitiatedExistNotify.get(m.Id)!=null)
                         {
                          lstInitiatedExistNotify = mapInitiatedExistNotify.get(m.id);
                          }
                         }*/
                 
                    if (lstInitiatedExistNotify != NULL && lstInitiatedExistNotify.size() > 0)
                    {
                        for (Notification__c sNotify :lstInitiatedExistNotify)
                        {
                            sNotify.Status__c = 'Confirmed';
                            CloseInitiatedNotify.add(sNotify);
                        }
                    }
                }
                
                if(old_OfferStatus != new_OfferStatus && (new_OfferStatus == 'Accepted' || new_OfferStatus == 'Declined') && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
                {
                    list<Notification__c> lstAcceptedExistNotify = [SELECT ID FROM Notification__c WHERE Match__c =: m.Id AND Engagement__c =: m.Engagement__c AND Type__c = 'Offer Extended' AND Status__c = 'Not Started' ];
                     //optimisation effort  
                   /* if(mapAcceptedExistNotify!=null && mapAcceptedExistNotify.size()>0)
                    {
                     if(mapAcceptedExistNotify.get(m.Id)!=null)
                     {
                      lstAcceptedExistNotify = mapAcceptedExistNotify.get(m.id);
                      }
                     } */  
                                     
                    if (lstAcceptedExistNotify != NULL && lstAcceptedExistNotify.size() > 0)
                    {
                        for (Notification__c AcctNotify :lstAcceptedExistNotify)
                        {
                            AcctNotify.Status__c = 'Confirmed';
                            CloseInitiatedNotify.add(AcctNotify);
                        }
                    }
                }
                
                if(old_InterviewStatus != new_InterviewStatus && m.Interview_Status__c == 'Initiated' && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
                {   //optimisation effort
                    list<Notification__c> lstIntvExistNotify = [SELECT ID FROM Notification__c WHERE Match__c =: m.Id AND Engagement__c =: m.Engagement__c AND Type__c = 'Initiated' ];
                   /* if(mapIntvExistNotify!=null && mapIntvExistNotify.size()>0)
                    {
                     if(mapIntvExistNotify.get(m.Id)!=null)
                     {
                      lstIntvExistNotify = mapIntvExistNotify.get(m.id);
                      }
                     }*/
                 
                    if (lstIntvExistNotify.size() == 0)
                    {
                        MapInterviewtobeNotified.add(m.Id);
                    }
                }
                
                if(old_OfferStatus != new_OfferStatus && m.Offer_Status__c == 'Offered' && m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship' && m.Engagement__c != NULL)
                {
                    list<Notification__c> lstIntvOfferedExistNotify = [SELECT ID FROM Notification__c WHERE Match__c =: m.Id AND Engagement__c =: m.Engagement__c AND Type__c = 'Offer Extended' ];
                   //optimisation effort
                   /* if(mapIntvOfferedExistNotify!=null && mapIntvOfferedExistNotify.size()>0)
                    {
                     if(mapIntvOfferedExistNotify.get(m.Id)!=null)
                     {
                      lstIntvOfferedExistNotify = mapIntvOfferedExistNotify.get(m.id);
                      }
                     }*/
                 
                   
                    if (lstIntvOfferedExistNotify.size() == 0)
                    {
                        MapInterviewOffertobeNotified.add(m.Id);
                    }
                }
                //Story B-01705  (End)
                
                //AA B-03326
                if(m.RecordTypeId==Constants.MAT_INTERNSHIP && m.Intrax_Program__c =='Internship'){
                //IGI 818 
                new_camp_session = trigger.newMap.get(m.Id).Campaign_Session__c ;
                old_camp_session = trigger.oldMap.get(m.Id).Campaign_Session__c ;
                
                MatchTriggerHelper.count_camp_session(old_camp_session, new_camp_session);                                  
                // end IGI 818
                }
                Position__c position =[select OwnerId, Double_Placement_Indicated__c from Position__c where Id = :m.Position_Name__c];
               
                strMatName=m.name;
                system.debug('***strMatName*********'+strMatName);
                string strOldErrorTag = trigger.oldMap.get(m.Id).sys_error_tag__c;
                string strNewErrorTag = trigger.newMap.get(m.Id).sys_error_tag__c;
                string strOldValidator = trigger.oldMap.get(m.Id).validator__c;
                string strNewValidator = trigger.newMap.get(m.Id).validator__c;
                boolean strNewAssExists = trigger.oldMap.get(m.Id).MCAssExists__c;
                boolean strOldAssExists = trigger.newMap.get(m.Id).MCAssExists__c;
                system.debug('***lstMatchEngs*********'+lstMatchEngs);                   
                lstMatchEngs = [SELECT Id,Initial_Match_Offer_Accepted__c,In_Country__c,Partner_Id__c,Placement_status__c,Status__c, Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: m.Engagement__c LIMIT 1];
                 //optimisation effort
                /* if(m.Engagement__c != null)
                   {
                    if(mapEng.get(m.Engagement__c)!=null)
                    {
                        lstMatchEngs.add(mapEng.get(m.Engagement__c));
                    }
                   }*/
                //optimisation effort
                system.debug('@@lstMatchEngs' +lstMatchEngs);
                //AYII-680 (Start)
                if (m.Intrax_Program__c == 'Ayusa')
                {   
                    list<Match__c> lstDblMatchCnt = [SELECT ID FROM Match__c WHERE Status__c = 'Confirmed' AND Position_Name__c = :m.Position_Name__c AND ((Start_Date__c >= :m.Start_Date__c AND Start_Date__c <= :m.End_Date__c) OR (End_Date__c  >= :m.Start_Date__c AND End_Date__c  <= :m.End_Date__c) OR (Start_Date__c <= :m.Start_Date__c AND End_Date__c  >= :m.End_Date__c) OR (Start_Date__c >= :m.Start_Date__c AND End_Date__c  <= :m.End_Date__c))];
                    
                    if(lstDblMatchCnt.size() >= 2)
                    {
                        position.Double_Placement_Indicated__c = 'Yes';
                        lstPosToBeUpdated.put(position.id,position);
                    }
                    else
                    {
                        position.Double_Placement_Indicated__c = 'No';
                        lstPosToBeUpdated.put(position.id,position);
                    }
                }
                
                //B-02432 For updating Match date in Opp 
                if(m.Intrax_Program__c=='Ayusa' && trigger.oldMap.get(m.Id).Status__c!=trigger.newMap.get(m.Id).Status__c && trigger.newMap.get(m.Id).Status__c == 'Confirmed')
                {
                    
                    if (m.Match_Date__c != null)
                    {
                        
                        system.debug('@@ match date @@' +m.Match_Date__c);
                        
                        MatchTriggerHelper.updateOppMatchDate(m.Id);
                    }
                }
                //B-02432 Ends
                
                if(m.Status__c == 'Confirmed' && m.Intrax_Program__c =='Ayusa')
                {         
                    //B-01478
                    if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                    {
                        for(Engagement__c engInfo : lstMatchEngs)
                        {  
                            //Commented for B-02465 (Start)                              
                            //engInfo.Engagement_End__c=m.End_Date__c;
                            //MapEngToBeUpdated.put(engInfo.Id,engInfo);
                            //Commented for B-02465 (End) 
                        }
                    }
                    
                    
                    if(strOldErrorTag==strNewErrorTag && m.validator__c ==null && strNewAssExists==strOldAssExists)
                    {
                        
                        if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                        {
                            for(Engagement__c engInfo : lstMatchEngs)
                            { 
                                //Position__c position =[select OwnerId from Position__c where Id = :m.Position_Name__c];
                                engInfo.OwnerId = position.OwnerId;
                                engInfo.Placement_status__c='Confirmed';
                                MapEngToBeUpdated.put(engInfo.Id,engInfo);
                            }
                        }
                        
                    }
                    else if(strOldValidator != strNewValidator && strOldErrorTag==strNewErrorTag && strNewAssExists==strOldAssExists)
                    {
                        if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))     
                            ValidatorMatchIds.add(m.Id);
                        system.debug('*******strMatName-4'+ strMatName);
                        // if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))
                        
                    }
                    
                }
                else if(strOldValidator != strNewValidator && strOldErrorTag==strNewErrorTag && strNewAssExists==strOldAssExists)
                {
                    if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))      
                        ValidatorMatchIds.add(m.Id);
                    system.debug('*******strMatName-4'+ strMatName);
                    //  if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))
                    //  SharingSecurityHelper.shareMatch(ConfMatchIds,ValidatorMatchIds,NewMatchIds);
                    
                }
                
                else if(m.status__c=='Withdrawn')
                {
                    if (m.Engagement__c != NULL){
                        //optimisation effort
                        lstOtherMatches =  [SELECT Id,Position_Name__c,Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id, Engagement__c FROM Match__c WHERE Engagement__c=: m.Engagement__c and id!=:m.Id];
                        //optimisation effort
                        //AYII 742 (Start)
                        system.debug('@@lstOtherMatches' +lstOtherMatches);
                        if (m.Intrax_Program__c == 'Ayusa')
                        { //optimisation effort
                            lstWithdrawnMatches = [SELECT Id,Position_Name__c,Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id, Engagement__c FROM Match__c WHERE Engagement__c=: m.Engagement__c and id!=:m.Id and status__c IN ('Withdrawn', 'Saved','Ended Early')];
                        system.debug('@@lstWithdrawnMatches'+lstWithdrawnMatches);
                        }
                        else
                        { //optimisation effort
                            lstWithdrawnMatches = [SELECT Id,Position_Name__c,Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id, Engagement__c FROM Match__c WHERE Engagement__c=: m.Engagement__c and id!=:m.Id and status__c IN ('Withdrawn', 'Ended Early')];
                         system.debug('@@lstWithdrawnMatches'+lstWithdrawnMatches);
                        }
                        //AYII 742 (End)
                        
                        if(lstWithdrawnMatches!=null && lstWithdrawnMatches.size()>0 && lstOtherMatches!=null && lstOtherMatches.size()>0 && lstWithdrawnMatches.size()==lstOtherMatches.size())
                        {
                            
                            // lstMatchEngs = [SELECT Id, Partner_Id__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: m.Engagement__c];
                            if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                            {
                                for(Engagement__c engInfo : lstMatchEngs)
                                { 
                                    engInfo.Placement_status__c='Not Placed';
                                    MapEngToBeUpdated.put(engInfo.Id,engInfo);
                                }
                            }
                            
                        }
                        else if(lstOtherMatches!=null && lstOtherMatches.size()>0)
                        {
                            For(Match__c mat:lstOtherMatches)
                            {
                                //lstMatchEngs = [SELECT Id, Partner_Id__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: mat.Engagement__c];
                                If(mat.status__c=='Confirmed')
                                {
                                    //lstMatchEngs = [SELECT Id, Partner_Id__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: mat.Engagement__c];
                                    //optimisation effort
                                    position =[select OwnerId from Position__c where Id = :mat.Position_Name__c];
                                    //optimisation effort
                                    if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                                    {
                                        for(Engagement__c engInfo : lstMatchEngs)
                                        { 
                                            engInfo.Placement_status__c='Confirmed';
                                            engInfo.ownerId = position.OwnerId;
                                            MapEngToBeUpdated.put(engInfo.Id,engInfo);
                                            
                                        }
                                    }
                                }
                                else if(mat.status__c!='Withdrawn' && mat.status__c!='Ended Early')
                                {
                                    // lstMatchEngs = [SELECT Id, Partner_Id__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: mat.Engagement__c];
                                    if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                                    {
                                        for(Engagement__c engInfo : lstMatchEngs)
                                        { 
                                            //if(mat.status__c=='Ended Early' &&  engInfo.Placement_status__c!='Not Placed')
                                            //  engInfo.Placement_status__c='Not Placed';
                                            // else
                                            engInfo.Placement_status__c='Pending';
                                            
                                            MapEngToBeUpdated.put(engInfo.Id,engInfo);
                                            
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                        else
                        {
                            // lstMatchEngs = [SELECT Id, Partner_Id__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: m.Engagement__c];
                            if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                            {
                                for(Engagement__c engInfo : lstMatchEngs)
                                { 
                                    engInfo.Placement_status__c='Not Placed';
                                    MapEngToBeUpdated.put(engInfo.Id,engInfo);
                                    
                                }
                            }
                        }
                    } 
                }
                else if(m.status__c!='Confirmed' && m.status__c!='Withdrawn' && m.status__c!='Saved' && m.status__c!='Ended Early')
                {
                    //lstMatchEngs = [SELECT Id, Partner_Id__c,Placement_status__c,Engagement_Start__c,OwnerId, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id=: m.Engagement__c];
                    if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                    {
                        for(Engagement__c engInfo : lstMatchEngs)
                        { 
                            if( engInfo.Placement_status__c=='Not Placed')
                            {
                                engInfo.Placement_status__c='Pending';
                                MapEngToBeUpdated.put(engInfo.Id,engInfo);
                            }
                        }
                    }
                }
                
                
                Id i  = m.Id;
                date start_dt_old = trigger.oldMap.get(m.Id).Start_Date__c;
                date start_dt_new = trigger.newMap.get(m.Id).Start_Date__c;
                String validator_old = trigger.oldMap.get(m.Id).Validator__c;
                String validator_new = trigger.newMap.get(m.Id).Validator__c;
                String status_old = trigger.oldMap.get(m.Id).Status__c;
                String status_new = trigger.newMap.get(m.Id).Status__c;
                String offer_status_old = trigger.oldMap.get(m.Id).Offer_Status__c;
                String offer_status_new = trigger.newMap.get(m.Id).Offer_Status__c;
                
                system.debug('***status_old******'+status_old);
                system.debug('***status_new******'+status_new);
                
                Set<Id> ConfMatchLstPTtoBeNotified;
                Set<Id> ReqMatchLstPTtoBeNotified;
                
                //B-02413
                if(m.Intrax_Program__c == 'AuPairCare')
                {
                    //B-02747
                    Match__c mOld = Trigger.oldMap.get(m.Id);                                       
                    Notification_Generator.callAPCNotifications(mOld, m);//old,new,
                    
                    if(status_old != status_new)
                    {
                        //B-03175  
                        //if match is confirmed. change the owner of APC PT Account and PT Application to AD (Match.Position.owner?) Only if the owner is AD (and not a queue)
                        if(status_new == 'Confirmed'){                                           
                            System.debug('ENTERED CONFIRMED positoin owner----->'+position.OwnerId);        
                            System.debug('ENTERED CONFIRMED participant owner----->'+m.Participant_Id__c);                      
                            //m.Participant_Id__r.OwnerId = position.OwnerId;      
                            //MapAccToBeUpdated.put(m.Participant_Id__r.Id,m.Participant_Id__c);  
                            
                          /* PTAccList = [SELECT Id,OwnerId FROM Account WHERE Id=:m.Participant_Id__c LIMIT 1];
                            if(PTAccList!=null && PTAccList.size()>0){
                                PTAccList[0].ownerId = position.OwnerId;
                                update PTAccList[0];
                            }
                            
                            PTAppList = [Select a.Id,a.OwnerId,a.Engagement__c From Applicant_Info__c a where a.engagement__c = :m.Engagement__c];
                            if(PTAppList!=null && PTAppList.size()>0)
                            {
                                for(Applicant_Info__c app:PTAppList){
                                    app.OwnerId = position.ownerId;                                 
                                }                               
                                update PTAppList;            
                            } */                  
                        }
                        
                        if(status_new == 'Ended Early' && status_old=='Confirmed')
                        {
                            System.debug('Aupair match ended early');
                            
                            Opportunity matchBreakOpp;
                            System.debug('Before creating match break opportunity');
                            matchBreakOpp = MatchTriggerHelper.createMatchBreakOpp(m.Id,trigger.newMap.get(m.Id).Position_Name__c,lstMatchEngs);
                            
                            //This change is specifcally exculde the migrated apc matches which have already ended-early in the casper system.
                            //we just create the match break opportunity and leave it team. The finance team has to manually calculate and add the
                            //service credit product to match break opportunity and close it, to generate the so,rv and si.
                            if(matchBreakOpp!=null)// && (m.Sys_Admin_Tag__c == null || m.Sys_Admin_Tag__c ==''))
                            {
                                //Get the discretionary discount if any on the assessment
                                List<Assessment__c> exitAssessment = [Select id,Discretionary_Discount__c from assessment__c 
                                                                      where Match_Name__c =:m.id  and
                                                                      RecordTypeId = :Constants.ASS_APC_Exit_Interview];
                                //and Status__c = 'Confirmed' ];
                                system.debug('@@exitAssessment'+exitAssessment); 
                                        
                                if(exitAssessment!=null && exitAssessment.size()>0)
                                {
                                    List<Account> hostAccount = [select id,Discretionary_Discount__c,rematch_type__c from
                                                                 Account where id = :matchBreakOpp.AccountId];
                                    if(hostAccount!=null && hostAccount.size()>0)
                                    {
                                        //check if  this qualified match break or non-qualified match break and update the account accordingly.
                                        String isQualified;
                                        if(m.Match_Period__c!=null && 
                                           m.Match_Period__c <183 && 
                                           (math.abs(m.End_Date__c.daysBetween(m.Start_Date__c))>=365) &&
                                           m.Match_Type__c == 'Original')
                                        {
                                            //Yes this is qualified match
                                            isQualified = 'Qualified';
                                        }
                                        else 
                                            isQualified = 'Non-Qualified';
                                        
                                        hostAccount[0].rematch_type__c = isQualified;
                                        hostAccount[0].Discretionary_Discount__c = exitAssessment[0].Discretionary_Discount__c;
                                        update hostAccount[0];
                                    }
                                    
                                }
                                
                                System.debug('MatchBreak opportunity successful. Opportunity is : ' + matchBreakOpp);
                                boolean isSuccessful=false;
                                decimal serviceCreditAmount = 0.0;
                                System.debug('@@@@@m.ID : ' + m.Id);
                                System.debug('@@@@@m.Match_Period__c : ' + m.Match_Period__c);
                                
                                //Calculate Service Credit only if it is not a migrated match.
                                if(m.Sys_Admin_Tag__c == null || m.Sys_Admin_Tag__c =='')
                                {
                                    serviceCreditAmount = MatchTriggerHelper.processServiceCredit(m,lstMatchEngs,matchBreakOpp);
                                    if(serviceCreditAmount!=1)
                                    {
                                        if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                                        {
                                            //if the match break is happening on a overseas aupair, the change it to incountry aupair
                                            //if not just ignore
                                            if(lstMatchEngs[0].In_Country__c == 'No')
                                            {
                                                lstMatchEngs[0].In_Country__c = 'Yes';
                                                update lstMatchEngs[0];
                                                System.debug('Engagement is changed to incountry');
                                            }
                                        }
                                        System.debug('service credit processed successfully.');
                                        //Create the SO for the service Credit
                                        System.debug('Calling the Intacct_Wrapper to initiate the creation of SO,RC,SI for service credit');
                                        Intacct_Wrapper intacctWrap = new Intacct_Wrapper();
                                        System.debug('before calling apply service credit. serviceCreditAmount' + serviceCreditAmount);
                                        intacctWrap.CreateAndApplyServiceCredit(matchBreakOpp.Id,matchBreakOpp.AccountId,m.Host_Family_Child_Opportuniy__c,serviceCreditAmount,m.id);
                                    }
                                    System.debug('Before closing match break opportunity');
                                    matchBreakOpp.StageName = 'Closed Won';
                                    update matchBreakOpp;
                                }
                                else
                                {
                                    System.debug('This is a migrated match. We dont have previous sales invoices to calculate the Service Credit' +
                                                 ' Hence leave the match break opportunity in prospecting stage only');
                                }
                                
                                
                            }
                            else
                            {
                                System.debug('Match break opportunity creation failed. Hence service credit not processed');
                            }
                        }
                    }
                    
                    if(offer_status_old != offer_status_new){
                        if(offer_status_new == 'Accepted'){                                           
                            System.debug('1.ENTERED CONFIRMED');
                            //B-02654 Jose - Creating Opportunity for travel payment
                            MatchTriggerHelper.createChildPtOpp(m.Id,trigger.newMap.get(m.Id).Engagement__c);
                            // END B-02654 
                            //B-02953 Jose - setting Booking Flight Deadline
                            MatchTriggerHelper.setFlightDeadLine(trigger.newMap.get(m.Id).Engagement__c);
                            // END B-02953 
                        }
                     }
                    
                }
                
                
                //B-01478. Update eng start dates
                if(status_old != status_new && status_new == 'Confirmed' && m.Intrax_Program__c =='Ayusa')
                {    
                    lstOtherMatches =  [SELECT Id,Start_Date__c,Status__c,Engagement__r.Placement_Status__c,Engagement__r.Id,Engagement__c,Engagement__r.Engagement_End__c,Engagement__r.Engagement_Start__c,End_Date__c,CreatedDate FROM Match__c WHERE Engagement__c=: m.Engagement__c AND Status__c = 'Confirmed' AND id!=:m.Id ORDER BY Start_Date__c ASC LIMIT 1];
                    if(lstOtherMatches.size()==0){//only match
                        if(lstMatchEngs!=null && lstMatchEngs.size()>0){
                            for(Engagement__c engInfo : lstMatchEngs)
                            { 
                                if(engInfo.Status__c!='On Program')
                                {
                                    engInfo.Engagement_Start__c = m.Start_Date__c;                                  
                                    MapEngToBeUpdated.put(engInfo.Id,engInfo);
                                }
                            }
                        }
                    }
                    else if(lstOtherMatches.size()>0 && lstOtherMatches!= null){//other matches exist. 1st confirmed match
                        if(lstMatchEngs!=null && lstMatchEngs.size()>0){
                            for(Engagement__c engInfo : lstMatchEngs)
                            { 
                                if(engInfo.Status__c!='On Program')
                                {
                                    engInfo.Engagement_Start__c = lstOtherMatches[0].Start_Date__c;                                     
                                    MapEngToBeUpdated.put(engInfo.Id,engInfo);
                                }
                            }
                        }
                    }
                    
                }
                //B-03029 (Start)
                else if(start_dt_old != start_dt_new && status_new == 'Confirmed' && m.Intrax_Program__c =='Ayusa')
                {
                    if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                    {
                        for(Engagement__c engInfo : lstMatchEngs)
                        { 
                            if(engInfo.Status__c!='On Program')
                            {
                                 engInfo.Engagement_Start__c = m.Start_Date__c;                                     
                                 MapEngToBeUpdated.put(engInfo.Id,engInfo);
                            }
                        }
                    }
                }
                //B-03029 (End)
                
                // MT 140 Changes
                if(status_old != status_new && status_new == 'Confirmed')
                {
                    //if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))
                    ConfMatchIds.add(m.Id);
                    if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                    {
                        //  Position__c position =[select OwnerId from Position__c where Id = :m.Position_Name__c];
                        
                        for(Engagement__c engInfo : lstMatchEngs)
                        { 
                            if(engInfo.Placement_status__c!='Confirmed')
                            {
                                engInfo.OwnerId = position.OwnerId; 
                                engInfo.Placement_status__c='Confirmed';
                                 //B-03377 starts
                                 if(DocuSign_Controller.OfferAccepted == true)
                                 {
                                  engInfo.Initial_Match_Offer_Accepted__c = date.today();
                                  system.debug('offr acepted');
                                 } 
                                  
                                //B-03299
                                system.debug('debug:: engInfo.Intrax_Program__c==='+engInfo.Intrax_Program__c);
                                system.debug('debug:: m.Match_Type__c=='+m.Match_Type__c);
                                If(m.Intrax_Program__c=='AuPairCare' && m.Match_Type__c =='Extension')
                                engInfo.status__c='Processing';
                                
                                MapEngToBeUpdated.put(engInfo.Id,engInfo);
                            }
                        }
                    }
                    if(m.RecordTypeId == Constants.MAT_AYUSA && m.Intrax_Program__c =='Ayusa' && m.Is_Primary_SOA__c!=True)
                    {
                        lstHFConfStuToBeNotified.add(m);
                    }
                    system.debug('****** ConfMatchIds*******'+ConfMatchIds);
                    //    if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test'))){
                    //  system.debug('****** Trying to update status');
                    // SharingSecurityHelper.shareMatch(ConfMatchIds,ValidatorMatchIds,NewMatchIds);
                    //   }
                    
                }
                
                // D-01392    
                string oldPosition = trigger.oldMap.get(m.Id).Position_Name__c;
                string newPosition = trigger.newMap.get(m.Id).Position_Name__c;
                
                if( (m.Intrax_Program__c =='Internship' || m.Intrax_Program__c =='Work Travel') && oldPosition!=newPosition)
                {
                    
                    NewMatchIds.add(m.Id);
                }
                ///
                
                string OldCampaign = trigger.oldMap.get(m.Id).Campaign__c;
                string newCampaign = trigger.newMap.get(m.Id).Campaign__c;
                
                if(m.RecordTypeId == Constants.MAT_INTERNSHIP &&  m.Intrax_Program__c =='Work Travel' && OldCampaign!=newCampaign)
                {
                    //if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test')))
                    ValidatorMatchIds.add(m.Id);
                }
                list<Match__c> OtherConfirmedmatches = new list<Match__c>();
                list<Match__c> OtherARRmatches = new list<Match__c>();
                list<Match__c> OtherWEmatches = new list<Match__c>();
                list<Engagement__c> EngUpdatelist = new list<Engagement__c>();
                if(status_old != status_new && status_new == 'Ended Early' && m.Intrax_Program__c != 'AuPairCare')
                { 
                    lstOtherMatches =  [SELECT Id,  Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id, Engagement__c FROM Match__c WHERE Engagement__c=: m.Engagement__c and id!=:m.Id];
                    
                    if(lstOtherMatches!=null && lstOtherMatches.size()>0)
                    {
                        For(Match__c match:lstOtherMatches)
                        {
                            If(match.Status__c=='Confirmed')
                                OtherConfirmedmatches.add(match);
                            If(match.Status__c=='Applied' || match.Status__c=='Recommended' || match.Status__c=='Requested' )
                                OtherARRmatches.add(match);
                            If(match.Status__c=='Withdrawn' || match.Status__c=='Ended Early')
                                OtherWEmatches.add(match); 
                        }
                        if(OtherConfirmedmatches!=null && OtherConfirmedmatches.size()>0)
                        {
                            if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                            {
                                For(Engagement__c eng:lstMatchEngs)
                                {
                                    if(eng.Placement_status__c!='Confirmed')
                                    {
                                        eng.Placement_status__c='Confirmed';
                                        EngUpdatelist.add(eng);
                                    }
                                }
                            }
                        }
                        else if(OtherARRmatches!=null && OtherARRmatches.size()>0)
                        {
                            if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                            {
                                For(Engagement__c eng:lstMatchEngs)
                                {
                                    if(eng.Placement_status__c!='Pending')
                                    {
                                        eng.Placement_status__c='Pending';
                                        EngUpdatelist.add(eng);
                                    }
                                }
                            }
                        }
                        else if(OtherWEmatches!=null && OtherWEmatches.size()>0)
                        {
                            if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                            {
                                For(Engagement__c eng:lstMatchEngs)
                                {
                                    if(eng.Placement_status__c!='Not Placed')
                                    {
                                        eng.Placement_status__c='Not Placed';
                                        EngUpdatelist.add(eng);
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        if(lstMatchEngs!=null && lstMatchEngs.size()>0)
                        {
                            For(Engagement__c eng:lstMatchEngs)
                            {
                                if(eng.Placement_status__c!='Not Placed')
                                {
                                    eng.Placement_status__c='Not Placed';
                                    EngUpdatelist.add(eng);
                                }
                            }
                        }
                    }
                    if(EngUpdatelist!=null && EngUpdatelist.size()>0)
                        update EngUpdatelist;
                }
                
                if(status_old != status_new && status_new =='Recommended' && m.Intrax_Program__c =='Ayusa' && m.RecordTypeId==Constants.MAT_AYUSA && m.Recommendation_Expiration__c ==null)
                {
                    
                    system.debug('***here*******');
                    MapHFRecMatchesToBeNotified.put(m.Id,m);
                    
                    system.debug('***MapHFRecMatchesToBeNotified*******'+MapHFRecMatchesToBeNotified);
                }
                //Handle Notification
                /*//D-01720. Commented to not delete notifications (this was affecting APC). 
if((start_dt_new == NULL) || (start_dt_old!=start_dt_new && m.Status__c == 'Confirmed') || (status_old!=status_new && m.Status__c != 'Confirmed')){
list<Notification__c> ObjNotification = new List<Notification__c>();
ObjNotification = [Select n.Type__c, n.SystemModstamp, n.Subject__c, n.Status__c, n.Position__c, n.Portal_URL__c, n.Partner_Email__c, n.OwnerId, n.Name, n.Match__c, n.MatchStartDate__c, n.LastModifiedDate, n.LastModifiedById, n.IsDeleted, n.Intrax_Program__c, n.Id, n.Engagement__c, n.CurrencyIsoCode, n.CreatedDate, n.CreatedById, n.Contact__c, n.ConnectionSentId, n.ConnectionReceivedId, n.Body__c, n.Account__c, n.AccountId__c From Notification__c n where n.match__c =:m.Id and n.engagement__c = :m.Engagement__c and Type__c != 'Offer Extended'];
if(ObjNotification!=null && ObjNotification.size()>0){
for (Notification__c notify : ObjNotification){
delete notify;
}
}
}
*/
            }     
            //B-03349       
            MatchTriggerHelper.updateWTOtherMatchesToWithdrawn(trigger.new, trigger.oldMap); 
            system.debug('BeforeMatchTriggerHelper::::');
            if( (ConfMatchIds!=null && ConfMatchIds.size()>0) || (ValidatorMatchIds!=null && ValidatorMatchIds.size()>0) || (NewMatchIds!=null && NewMatchIds.size()>0))
            {
                if(!(blnDeployTestFlag && strMatName.containsIgnoreCase('Test'))) 
                    SharingSecurityHelper.shareMatch(ConfMatchIds,ValidatorMatchIds,NewMatchIds);
                system.debug('******Match Update Call*****c****'+ConfMatchIds+'***N***'+NewMatchIds);
                system.debug('******Match Update Call*****Trigger.Newmap.keyset()****'+Trigger.Newmap.keyset());
                MatchTriggerHelper.updateOpportunityOperationStageByMatchStatus(Trigger.Newmap.keyset());
            }
            if(lstHFConfStuToBeNotified!=null && lstHFConfStuToBeNotified.size()>0)
            {
                Notification_Generator.CreateConfirmedStuNotification(lstHFConfStuToBeNotified);
                
            }
            if(MapHFRecMatchesToBeNotified!=null)
            {
                system.debug('***Inside Map***'+MapHFRecMatchesToBeNotified);
                set<Id> MatchIds =  MapHFRecMatchesToBeNotified.keyset();
                for(Id mid: MatchIds)
                {                   
                    Match__c mat = new Match__c();
                    mat = MapHFRecMatchesToBeNotified.get(mid);
                    lstHFRecMatchesToBeNotified.add(mat);
                }
                system.debug('***Inside Map***'+lstHFRecMatchesToBeNotified);
                if(lstHFRecMatchesToBeNotified!=null && lstHFRecMatchesToBeNotified.size()>0)
                    Notification_Generator.CreateRecommendedStuNotification(lstHFRecMatchesToBeNotified);
                
            }
            List<Engagement__c> lstEngUpdate = new List<Engagement__c>();
            Set<id> EngIds = MapEngToBeUpdated.keySet() ;
            system.debug('****EngIds******'+EngIds);
            system.debug('****MapEngToBeUpdated******'+MapEngToBeUpdated);
            For(Id engId:EngIds)
            {
                Engagement__c eng = new Engagement__c();
                eng = MapEngToBeUpdated.get(engId);
                system.debug('****eng******'+eng);
                lstEngUpdate.add(Eng);
            }
            system.debug('****lstEngUpdate******'+lstEngUpdate);
            
            if( lstEngUpdate!=null &&  lstEngUpdate.size()>0)
                update  lstEngUpdate; 
            
            //AYII-680 (Start)
            if(lstPosToBeUpdated != null && lstPosToBeUpdated.size() > 0)
            {
                update lstPosToBeUpdated.values();
            }
            //AYII-680 (End)    
            
            //Story B-01705 (Start)
            if(MapInterviewtobeNotified != NULL && MapInterviewtobeNotified.size() > 0)
            {
                Notification_Generator.CreateIGIInterviewNotification(MapInterviewtobeNotified);
            }
            
            if(MapInterviewOffertobeNotified != NULL && MapInterviewOffertobeNotified.size() > 0)
            {
                Notification_Generator.CreateIGIOfferNotification(MapInterviewOffertobeNotified);
            }
            
            if(CloseInitiatedNotify != NULL && CloseInitiatedNotify.size() > 0)
            {
                update CloseInitiatedNotify;                    
            }
            //Story B-01705 (End)  
            
            //SEVIS MATCH STARTS
         /*set<Id> setEngId = new set<Id>();
          set<Id> setEngIds = new set<Id>();
          Map<Id,Engagement__c> mapEngRec;
          Map<Id,Engagement__c> mapEngRecs;
          List<Engagement__c> engagements = new List<Engagement__c>(); 
          for (Match__c newValues : Trigger.new){
           if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' )
           {
            if(newValues.Engagement__c !=null)
            {
             setEngId.add(newValues.Engagement__c);
            }
           }
           
           if(newValues.Intrax_Program__c =='Internship')
           {
            if ((trigger.oldMap.get(newValues.Id).ARO_Signed_TIPP__c != trigger.newMap.get(newValues.Id).ARO_Signed_TIPP__c) || (trigger.oldMap.get(newValues.Id).PT_Signed_TIPP__c != trigger.newMap.get(newValues.Id).PT_Signed_TIPP__c))
            {
             if(newValues.Engagement__c !=null)
             {
              setEngIds.add(newValues.Engagement__c);
             }
            }
           
           }
           
         }
      
       if (setEngId !=null && setEngId.size()>0)
       {
       
       mapEngRec = new Map<Id,Engagement__c>([select Id,Sevis__c,Sevis_UEV_SOA_Add__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id IN:setEngId ]);
               
       }
        if (setEngIds !=null && setEngIds.size()>0)
       {
       
       mapEngRecs = new Map<Id,Engagement__c>([select Id,Sevis__c,Sevis_UEV_SOA_Add__c, Sevis_UEV_SOA_Edit__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Internship') and e.Sevis__c != NULL and e.Id IN:setEngIds]);
               
       }   
           
             for (Match__c newValues : Trigger.new){
             
             if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' ){
                
                if(mapEngRec!=null && newValues.Engagement__c !=null && mapEngRec.size()>0)
                {
                 if(mapEngRec.get(newValues.Engagement__c)!=null)
                 {
                 engagements.add(mapEngRec.get(newValues.Engagement__c));
                  }
                 }                 
                 
                if(engagements.size() > 0){
                   
                        engagements[0].Sevis_UEV_SOA_Add__c =  true;
                        engagements[0].Sevis_UEV_Nonstandard_SoA__c = false;
                        update engagements[0];
                    
                }
                
            }
             
             
             
             
             
              if ((trigger.oldMap.get(newValues.Id).ARO_Signed_TIPP__c != trigger.newMap.get(newValues.Id).ARO_Signed_TIPP__c) || (trigger.oldMap.get(newValues.Id).PT_Signed_TIPP__c != trigger.newMap.get(newValues.Id).PT_Signed_TIPP__c))
                {
                
                    if(mapEngRecs!=null && newValues.Engagement__c !=null && mapEngRecs.size()>0)
                    {
                     if(mapEngRecs.get(newValues.Engagement__c)!=null)
                     {
                       engagements.add(mapEngRecs.get(newValues.Engagement__c));
                      }
                     }                 
                 
                    
                    if(engagements.size() > 0)
                    {
                        engagements[0].Sevis_UEV_SOA_Edit__c = true; 
                        update engagements[0];
                    }
             }
             
             
             
             
             
            }//SEVIS MATCH ENDS
        */
        //END JOSE B-03102    
                   
        }
         // AFTER UPDATE TRIGGER ENDS HERE 
        // Call to SharingHelper for sharing when Mtach is created and updated 
        //SharingSecurityHelper.shareMatch(ConfMatchIds,ValidatorMatchIds,NewMatchIds);
    }
    // AFTER TRIGGER ENDS HERE
}