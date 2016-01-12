/*
Purpose         :   This trigger is to handle all the pre and post processing logic for position object's dml operations.

Created Date    :   03/19/2012

Current Version :   v1.0

Revision Log    :   V_1.1 Created
*/
trigger Trigger_Position on Position__c (before insert,before update,after insert, after update) {
    // TRIGGER VARS INSTANTIATION  
    if(TriggerExclusion.isTriggerExclude('Position')){
        return;
    }
    
    list<Position__c> lstpos_Exclude = new list<Position__c>();
    //Trigger Exclusion Logic - WT
    Position__c oldPosition = new Position__c();
    
    for(Position__c itrpos : trigger.new){
     if(trigger.oldMap != null){
        oldPosition = trigger.oldMap.get(itrpos.Id);      
     if(itrpos.RecordTypeId==Constants.POS_WORK_TRAVEL  && itrpos.Status__c == 'Matching' && (itrpos.Match_Offer_Status__c == 'Offered' || itrpos.Match_Offer_Status__c == 'Accepted')){
        lstpos_Exclude.add(itrpos);
      }
     }
    }
 
   system.debug('**Position exclude list**'+lstpos_Exclude);
  
    if(lstpos_Exclude != null && lstpos_Exclude.size() > 0){
      if(Trigger.isafter && Trigger.isupdate){
      WTTriggerHelper.positionMatchUpdate(lstpos_Exclude);
     } 
   }
   
    list<Position__Share> PosSharetoPersist = new list<Position__Share>();
    list<Manual_Sharing_Info__c> ManualShareInfolst = new list<Manual_Sharing_Info__c>();
    Set<ID> setPositionId = new Set<ID>();
    list<Engagement__c> lstToUpdate = new list<Engagement__c>();
    List<Engagement__c> engagement = new List<Engagement__c>(); 
    set<String> setmatchEngId = new set<String>();
    
    Position__Share pos_share=new Position__Share();
    String flag;
    
    //Check for the request type
    // BEFORE TRIGGER STARTS HERE 
    if(Trigger.isBefore)
    {  // BEFORE INSERT TRIGGER STARTS HERE         
        if(Trigger.isInsert)
        {
            list<Position__c> lstIGIPos=new list<Position__c>();
            for(Position__c record: Trigger.new)
            {
                string newString = ''; 
                string newIPO='';
                string strIPOValues;
                boolean blnExists =false;
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
                system.debug('**news-3 **'+newString );
                
                if(record.Intrax_Program_Category__c  != null && record.Intrax_Program__c=='Internship' && record.RecordTypeId==Constants.POS_ICD_INTERN_PT)
                {
                    record.Intrax_Program_Options__c= newString + newIPO ;
                }
                
            }
        }// BEFORE INSERT TRIGGER ENDS HERE  
        // BEFORE UPDATE TRIGGER STARTS HERE  
        if(Trigger.isUpdate)
        {
            boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
            List<Match__c> lstPosMatchesforSOAEdit = new list<Match__c>();
            Set<Id> positionIds = new Set<Id>();
            Set<Id>setPosId = new Set<Id>();
            string strPosName;
            set<string> setPosHCiD = new set<string>();
            Map<Id,Match__c>mapPosMatchesforSOAEdit;
            
            List<Member__c> listmember = new  List<Member__c>();
            map<Id,List<Member__c>> mapAllMembers = new map<Id,List<Member__c>>();
            
            for(Position__c record:Trigger.New){
                strPosName = record.Name;
               // setPosId.add(record.Id);    
                if(record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId && Trigger.oldMap.get(record.Id).OwnerId!=null)
                {
                    if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test')))  
                        positionIds.add(record.Id);
                    system.debug('**positionIds**'+positionIds);
                }           
            }
            // optimisation effort
            /*
            if(setPosId!=NULL && setPosId.size()>0)
            {
                mapPosMatchesforSOAEdit = new map<Id,Match__c>([Select m.Status__c, m.RecordTypeId, m.Position_Name__c, m.Offer_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id From Match__c m where m.Position_Name__c IN:setPosId and m.Is_Future_SOA__c= true and m.Status__c = 'Confirmed' and m.Intrax_Program__c= 'Internship']);
            }*/
            // optimisation effort
            if(positionIds!=null && positionIds.size()>0)  
            {                           
                 flag='before';
                 SharingSecurityHelper.persistSharingWithOwner(pos_share, flag, positionIds);                          
            } 
            else{
                //If we have exclusively other type owner set to position then do the other before updates
                
                for(Position__c record: Trigger.new)
                {
                    strPosName = record.Name;
                    string newString = ''; 
                    string newIPO='';
                    string strIPOValues;
                    boolean blnExists =false;
                     //optimisation effort (below set )
                   /* if (record.Status__c == 'Pending' && record.Intrax_Program__c == 'Ayusa')
                    {
                        setPosHCiD.add(record.Host_Company_Id__c);
                        system.debug('@@ setPosHCiD'+setPosHCiD);
                    }*/
                    //optimisation effort
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
                    
                    system.debug('**news-3 **'+newString );
                    if(Trigger.oldMap.get(record.Id).Intrax_Program_Category__c  != Trigger.newMap.get(record.Id).Intrax_Program_Category__c  && record.Intrax_Program__c=='Internship' && record.RecordTypeId==Constants.POS_ICD_INTERN_PT)
                    {
                        record.Intrax_Program_Options__c= newString + newIPO ;
                    }
                    
                    //B 02275
                
                    //optimisation effort
                     lstPosMatchesforSOAEdit=[Select m.Status__c, m.RecordTypeId, m.Position_Name__c, m.Offer_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id From Match__c m where m.Position_Name__c=:record.id and m.Is_Future_SOA__c= true and m.Status__c = 'Confirmed' and m.Intrax_Program__c= 'Internship'];
                   /* if( mapPosMatchesforSOAEdit!=null && record.id !=null &&  mapPosMatchesforSOAEdit.size()>0)
                    {
                     if( mapPosMatchesforSOAEdit.get(record.id)!=null)
                     {
                      lstPosMatchesforSOAEdit.add( mapPosMatchesforSOAEdit.get(record.id));
                      }
                     } */
                    
                    if(lstPosMatchesforSOAEdit!=null && lstPosMatchesforSOAEdit.size()>0)
                    {
                        record.SEVIS_UEV_SOA_Edit__c=false;
                    }
                    
                    //end B 02275   
                   
                }
               
                // added for AYII 139 (Start)
                //optimisation effort
               /* if(setPosHCiD!=null && setPosHCiD.size()>0)
                  {
                    listmember=[Select Account_Name__c From Member__c m WHERE (Account_Name__c In :setPosHCiD) AND (Role__c = 'Spouse or Partner' OR  Role__c = 'Spouse' OR  Role__c = 'Child' OR Role__c = 'Parent' OR Role__c = 'Sibling' OR Role__c = 'Other')
                                  AND (Residency_Status__c != 'Lives Elsewhere')];
                  }
                  
                for (Member__c mem : listmember)
                {
                  if (!mapAllMembers.containsKey(mem.Account_Name__c))
                  {
                   mapAllMembers.put(mem.Account_Name__c,new List<Member__c>());
                  }
                   mapAllMembers.get(mem.Account_Name__c).add(mem);
                }
                */
               //optimisation effort
                for(Position__c AllPos: Trigger.new)
                {
                   //list <Member__c> allmembers = new list <Member__c>();// for optimisation effort
                    if (AllPos.Status__c == 'Pending' && AllPos.Intrax_Program__c == 'Ayusa')
                    {
                    //optimisation effort
                         list <Member__c> allmembers = [Select m.Role__c From Member__c m
    WHERE (Account_Name__c = :AllPos.Host_Company_Id__c) AND (Role__c = 'Spouse or Partner' OR  Role__c = 'Spouse' OR  Role__c = 'Child' OR Role__c = 'Parent' OR Role__c = 'Sibling' OR Role__c = 'Other')
    AND (Residency_Status__c != 'Lives Elsewhere')];
                    //optimisation effort
                     
                    /* if(mapAllMembers!=null && mapAllMembers.size()>0)
                     {
                      if(mapAllMembers.get(AllPos.Host_Company_Id__c)!=null)
                      {
                      allmembers = mapAllMembers.get(AllPos.Host_Company_Id__c);
                      }
                     }*/
                     
                     
                       if (allmembers.size() == 0)
                        {
                            AllPos.Single_No_Children_Indicated__c = 'Yes';
                        }
                        else
                        {
                            AllPos.Single_No_Children_Indicated__c = 'No';
                        }
                    }
                }
            }
        } // BEFORE UPDATE TRIGGER ENDS HERE  
        // added for AYII 139 (End)
    } // BEFORE TRIGGER ENDS HERE 
    // AFTER TRIGGER STARTS HERE  
    if(Trigger.isAfter) {
        // AFTER ALL TRIGGER STARTS HERE   
        string strPosName ;
        Position__c positionInfo;
        Account accountInfo;
        Opportunity opp;
        List<Contact> UserContact;
        List<User> activeUser = new list<User>();
        Set<Id> PositionIds =  new set<Id>();   
        Set<Id> setPosHCiD =  new set<Id>();
        boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
        map<Id, Applicant_Info__c> mapApplicantInfo;
        map<Id, Contact> mapContact;
       // List<Applicant_Info__c> accAppInfo = new List<Applicant_Info__c>();
        
        system.debug('*******blnDeployTestFlag*******'+blnDeployTestFlag);
        //Chekc for the event type
        // AFTER ALL TRIGGER ENDS HERE          
        // AFTER INSERT TRIGGER STARTS HERE     
        if(Trigger.isInsert) {
            
            //call helper class method to execute the logic to update the related opportunity record
            //PositionTriggerHelper.updateOpportunityOperationStageByPositionStatus(Trigger.New);
            
            system.debug('*******Inside Trigger blnDeployTestFlag*********'+ blnDeployTestFlag);
            //optimisation effort
           /* for(position__c pos:trigger.new)
            {
                if(pos.Host_Company_Id__c!=null)
                {
                    setPosHCiD.add(pos.Host_Company_Id__c);
                }
            }
            
            if(setPosHCiD!=null&& setPosHCiD.size()>0)
            {
                
                accountInfo = [SELECT Id, Name, Intrax_Id__c,CreatedById, Type, isPersonAccount, LastName FROM Account where Id IN:setPosHCiD];
            system.debug('@@accountInfo'+accountInfo);
            }
            
            if(accountInfo!=null && accountInfo.size()>0)
            {
                for (Account a:accountInfo)
                {
                    mapApplicantInfo = new Map<Id, Applicant_Info__c>([Select a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c, a.Arriving_Time__c, a.Account__c From Applicant_Info__c a where a.Account__c =:a.Id]);
                    mapContact =   new Map<Id,Contact>([Select Id,AccountId from Contact where AccountId=:a.Id]);
                    system.debug('@@mapApplicantInfo' +mapApplicantInfo +mapContact);
                }
               }*/
            //optimisation effort
            for(position__c pos:trigger.new)
            {
                system.debug('****position*****'+pos);
                strPosName = pos.Name;
                // if(!strPosName.containsIgnoreCase('Test') )  
                if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test')))
                {              
                    Sharing_Security_Controller.sharePosRecordGuestUsers(pos.Id);
                    if(pos.RecordTypeId == Constants.POS_AYUSA_HF)
                    {
                        if(pos.RecordTypeId == Constants.POS_AYUSA_HF)
                        {
                            iGeolocate__c objiGeolocate=new iGeolocate__c();
                            objiGeolocate.position__c = pos.Id;
                            //objiGeolocate.Name = pos.Name + '_GeoLocate';
                            insert objiGeolocate;
                            system.debug('****objiGeolocate*****'+objiGeolocate);
                        }
                    }
                }
                
                accountInfo = [SELECT Id, Name, Intrax_Id__c,CreatedById, Type, isPersonAccount, LastName
FROM Account where Id=:pos.Host_Company_Id__c];
                
               List<Applicant_Info__c>  accAppInfo = [Select a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c, a.Arriving_Time__c, a.Account__c From Applicant_Info__c a where a.Account__c=:accountInfo.Id];
               // if(mapApplicantInfo != null && pos.Host_Company_Id__c!=null && mapApplicantInfo.size()>0)
               //{
                     
                   // accAppInfo.add(mapApplicantInfo.get(pos.Host_Company_Id__c));
                    System.debug('trigger: accAppInfo---->'+accAppInfo);  
                     System.debug('trigger: pos.Host_Company_Id__c---->'+pos.Host_Company_Id__c); 
                     // System.debug('trigger: mapApplicantInfo---->'+mapApplicantInfo); 
                    if(accAppInfo!=null && accAppInfo.size()>0)
                    {
                        for(Applicant_Info__c app: accAppInfo)
                        {
                            // if(!strPosName.containsIgnoreCase('Test'))
                            if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test'))){      
                                System.debug('trigger: position Id---->'+pos.Id);  
                                System.debug('trigger: app.Createdby---->'+app.CreatedBy__c);                          
                                Sharing_Security_Controller.sharePositionRecord(pos.Id,app.CreatedBy__c);
                            }
                        }
                    } 
              //  }
                if(pos.Host_Opportunity_Id__c!=null)
                    opp=[Select o.OwnerId, o.Id, o.CreatedById From Opportunity o where o.Id=:pos.Host_Opportunity_Id__c];
                if(opp!=null)
                {
                    // if(!strPosName.containsIgnoreCase('Test'))
                    if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test')))     
                        Sharing_Security_Controller.sharePositionRecord(pos.Id,opp.CreatedById);
                }
                
                //optimisation effort
                UserContact = [Select Id,AccountId from Contact where AccountId=:accountInfo.Id];
                
              //  if(mapContact!=null && pos.Host_Company_Id__c !=null && mapContact.size()>0)
               // {
                 /* if(mapContact.get(pos.Host_Company_Id__c)!=null)
                   {
                    UserContact.add(mapContact.get(pos.Host_Company_Id__c));
                    }*/
                    system.debug('*******Inside Trigger UserContact*********'+UserContact);
                    if(UserContact!=null && UserContact.size()>0)
                    {
                        activeUser = [Select Id,contactId from user where contactId =: UserContact[0].Id];
                        system.debug('*******Inside Trigger activeUser*********'+activeUser);                  
                        if(activeUser!=null && activeUser.size()>0)
                        {
                            //if(!strPosName.containsIgnoreCase('Test'))
                            if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test')))
                                Sharing_Security_Controller.sharePositionRecord(pos.Id,activeUser[0].Id);   
                        }             
                    }
               // }
                
                If(pos.RecordTypeId == Constants.POS_WORK_TRAVEL || pos.RecordTypeId == Constants.POS_ICD_INTERN_PT )
                {
                    if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test')))
                        PositionIds.add(pos.Id);
                } 
            }
            If(PositionIds!=null)
                SharingSecurityHelper.shareHCPortalContactPositions(PositionIds);            
        }// AFTER INSERT TRIGGER ENDS HERE    
        // AFTER UPDATE TRIGGER STARTS HERE  
        if(Trigger.isUpdate)
            //--> Start Pay Events B-02402
            //For APC Positions, we need to create a new Match Owner History instance anytime
            //the Position Owner changes as Match ownership is derived from the Position parent.
        {
            if(PositionTriggerHelper.firstRun){
                PositionTriggerHelper.firstRun = false;                      
                //Log Ownership Changes for APC Match Owner History tracking
                List<Id> apcPositions = New List<Id>();
                for(Position__c pos : Trigger.new){
                    if(pos.Intrax_Program__c == 'AuPairCare' && pos.OwnerId != Trigger.oldMap.get(pos.Id).OwnerId){
                        apcPositions.add(pos.Id);
                    }
                }
                PositionTriggerHelper.logOwnership(apcPositions);
            }
            
            //B-03457
            PositionTriggerHelper.setNewHostAccount(trigger.new,trigger.oldMap);
            //B-03457 
                      
            //End Pay Event B-02402
            
            List<Match__c> lstPosMatches = new list<Match__c>();
            List<Position__c> lstHFPosToBeNotified = new list<Position__c>();
            List<Match__c> lstPosMatchesToBeUpdated = new list<Match__c>();
            list<Contact> lstHCContacts=new list<Contact>();
            list<User> lstUser=new list<User>();
            Set<Id> HCMatchesId =  new set<Id>();
            Set<Id> HCMatchEngIds = new set<Id>();
            List<Engagement__c> lstEngagements=new List<Engagement__c>();
            List<Match__c> lstHCMatches=new list<Match__c>();
            List<Match__c> lstMatches=new List<Match__c>();
            set<Id> HCContactIds =  new set<Id>();
            Set<Id> HCAccountIds =  new set<Id>();  
            set<Id>  posIds = new set<Id>();
            set<string> allshareIDs = new set<string>();
            Set<Id> setHCAccntIds =  new set<Id>(); 
            Set<Id> setPositIds =  new set<Id>();
            Set<Id> setPosIds2 = new set<Id>();
            Set<Id> setPosOppId = new set<id>();
            Map<Id,Opportunity> mapPosOpp;
            Map<Id, iGeoLocate__c> mapobjiGeolocate;
            Map<Id,Match__c>mapHCMatches;
            Map<Id,Contact>mapHCContacts;
            Map<Id,Match__c>maplstPosMatches;
            Set<Id> setGeoPosId = new set<ID>();
           // List<iGeolocate__c> lstobjiGeolocate = new List<iGeolocate__c>();
            Set<Id> allPosOwnerShareIDs = new Set<Id>();
              //optimisation effort
           /* for(position__c pos: Trigger.new){
                 
                setPositIds.add(pos.Id);
                setPosOppId.add(pos.Host_Opportunity_Id__c);
                
                string OldMailingStreet = trigger.oldMap.get(pos.Id).Street__c;
                string NewMailingStreet = trigger.newMap.get(pos.Id).Street__c;
                string OldMailingCity = trigger.oldMap.get(pos.Id).City__c;
                string NewMailingCity = trigger.newMap.get(pos.Id).City__c;
                string OldMailingCountry = trigger.oldMap.get(pos.Id).Country__c;
                string NewMailingCountry = trigger.newMap.get(pos.Id).Country__c;
                string OldMailingPostalCode = trigger.oldMap.get(pos.Id).Postal_Code__c;
                string NewMailingPostalCode = trigger.newMap.get(pos.Id).Postal_Code__c;
                string OldMailingState = trigger.oldMap.get(pos.Id).State__c;
                string NewMailingState = trigger.newMap.get(pos.Id).State__c;
                string OldHostAccount = trigger.oldMap.get(pos.Id).Host_Company_Id__c;
                string NewHostAccount = trigger.newMap.get(pos.Id).Host_Company_Id__c;                
                
                if(OldHostAccount != NewHostAccount && NewHostAccount != null) 
                {
                    setHCAccntIds.add(trigger.newMap.get(pos.Id).Host_Company_Id__c);
                    system.debug('@@setHCAccntIds' +setHCAccntIds);
                }
                
                
                if(pos.RecordTypeId == Constants.POS_WORK_TRAVEL && pos.Status__c == 'Matching' && pos.Match_Offer_Status__c == 'Offered')
                {
                    if(pos.Opportunity_Stage__c == 'Closed Won')
                    {
                        setPosIds2.add(pos.Id);
                    }system.debug('@@setPosIds2'+setPosIds2);
                }
                if(pos.RecordTypeId == Constants.POS_AYUSA_HF)
                {
                    if(OldMailingStreet != NewMailingStreet || OldMailingCity!=NewMailingCity ||  OldMailingCountry!=NewMailingCountry || OldMailingPostalCode!=NewMailingPostalCode || OldMailingState!=NewMailingState)
                    {
                        setGeoPosId.add(pos.Id);
                       
                    } system.debug('@@setGeoPosId'+setGeoPosId);
                }
            }  
            
            if(setHCAccntIds !=null && setHCAccntIds.size()>0)
            {
                mapHCContacts = new Map<Id,Contact>([Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId IN: setHCAccntIds]);
            }
            
            if(setPositIds != null && setPositIds.size()>0)
            {
               
               mapHCMatches = new Map<Id,Match__c>([Select Id,Position_Name__r.Id, Position_Name__c,Status__c,Position_Name__r.RecordTypeId,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c,Position_Name__r.Host_Company_Id__c, Interview_Date__c from Match__c 
                                where status__c!='Withdrawn' and Position_Name__c IN: setPositIds]);
            }
            if(setPosIds2!=null  && setPosIds2.size()>0)
            {
                maplstPosMatches = new map<Id,Match__c>([Select m.Status__c, m.RecordTypeId, m.Position_Name__c, m.Offer_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id From Match__c m where m.Position_Name__c IN: setPosIds2 and m.Offer_Status__c = 'Offered' and m.RecordTypeId =: Constants.MAT_INTERNSHIP and m.Intrax_Program__c= 'Work Travel' and m.Service_Level__c='Independent']);
            }
            
            if(setPosOppId !=null && setPosOppId.size()>0)
            {
                mapPosOpp =    new Map<Id,Opportunity>([Select o.OwnerId, o.Id,o.Operation_Stage__c,o.StageName, o.CreatedById From Opportunity o where o.Id IN: setPosOppId]);               
             system.debug('mapPosOpp'+mapPosOpp);   
            }
            if(setGeoPosId != null && setGeoPosId.size()>0)
            {
             mapobjiGeolocate = new map<Id, iGeoLocate__c>([Select i.SystemModstamp, i.Position__c, i.OwnerId, i.Name, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, i.CurrencyIsoCode, i.CreatedDate, i.CreatedById, i.Contact__c, i.ConnectionSentId, i.ConnectionReceivedId, i.Account__c From iGeoLocate__c i where i.Position__c IN: setGeoPosId]);
            system.debug('@@lstobjiGeolocate'+lstobjiGeolocate);
            }*/
            //optimisation effort
            for(position__c pos: Trigger.new){
                // SET FOR SEVIS POSITION TRIGGER ADDED BELOW
                if (pos.Sevis_UEV_SOA_Edit__c){
                    system.debug('@@ adding positionid');
                    setPositionId.add(pos.Id);
                }  // SET FOR SEVIS POSITION TRIGGER ADDED BELOW
                allshareIDs.add(pos.id);
                
                //persist sharing code
                if(Trigger.oldMap!=null && Trigger.oldMap.get(pos.Id).OwnerId!=null &&  pos.OwnerId != Trigger.oldMap.get(pos.Id).OwnerId) {             
                        allPosOwnerShareIDs.add(pos.Id);
                }
                
                if(pos.Host_Opportunity_Id__c != null && pos.Positions_Sold__c == pos.Matched_Count__c )
                {
                    posIds.add(pos.Id);    
                }
                //if(posIds!=null)
                //PositionTriggerHelper.updateOpportunityOperationStageByPositionStatus(posIds);   
                List<Opportunity> lstOpp = new list<Opportunity>();
                string newOwner;
                string oldOwner;
                
                strPosName = trigger.newMap.get(pos.Id).Name;
                string strOldStatus = trigger.oldMap.get(pos.Id).Status__c;
                string strNewStatus = trigger.newMap.get(pos.Id).Status__c;
                string strOldOppStage = trigger.oldMap.get(pos.Id).Opportunity_Stage__c;
                string strNewOppStage = trigger.newMap.get(pos.Id).Opportunity_Stage__c;
                string strOldMatchOfferStatus = trigger.oldMap.get(pos.Id).Match_Offer_Status__c;
                string strNewMatchOfferStatus = trigger.newMap.get(pos.Id).Match_Offer_Status__c;
                string OldHostAccount = trigger.oldMap.get(pos.Id).Host_Company_Id__c;
                string NewHostAccount = trigger.newMap.get(pos.Id).Host_Company_Id__c;
                string OldMailingStreet = trigger.oldMap.get(pos.Id).Street__c;
                string NewMailingStreet = trigger.newMap.get(pos.Id).Street__c;
                string OldMailingCity = trigger.oldMap.get(pos.Id).City__c;
                string NewMailingCity = trigger.newMap.get(pos.Id).City__c;
                string OldMailingCountry = trigger.oldMap.get(pos.Id).Country__c;
                string NewMailingCountry = trigger.newMap.get(pos.Id).Country__c;
                string OldMailingPostalCode = trigger.oldMap.get(pos.Id).Postal_Code__c;
                string NewMailingPostalCode = trigger.newMap.get(pos.Id).Postal_Code__c;
                string OldMailingState = trigger.oldMap.get(pos.Id).State__c;
                string NewMailingState = trigger.newMap.get(pos.Id).State__c;
                system.debug('****position*****'+pos);
                //if(!strPosName.containsIgnoreCase('Test'))
                
                
                // B-03011
                
                if(OldHostAccount != NewHostAccount && NewHostAccount != NULL){
                  
                    if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test')))
                    {
                        
                        
                        //Sharing pos with HC users
                         //optimisation effort
                        lstHCContacts = [Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId=: NewHostAccount];
                         //optimisation effort
                       
                      /*  if(mapHCContacts!=null && NewHostAccount !=null && mapHCContacts.size()>0)
                        {
                         if(mapHCContacts.get(NewHostAccount)!=null)
                         {
                          lstHCContacts.add(mapHCContacts.get(NewHostAccount));
                          }
                         }  */
                       
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
                                Sharing_Security_Controller.sharePositionRecord(pos.Id,lstUser);
                                system.debug('***share position******');
                            }
                        }
                        // sharing engagement & PT Account with HC users , Sharing HC Account with PT Users & Partner Users
                         //optimisation effort
                        lstHCMatches = [Select Id,Position_Name__r.Id, Position_Name__c,Status__c,Position_Name__r.RecordTypeId,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c,Position_Name__r.Host_Company_Id__c, Interview_Date__c from Match__c 
where status__c!='Withdrawn' and Position_Name__c =: pos.Id];
                       //optimisation effort
                       
                      /* if(mapHCMatches!=null && mapHCMatches.size()>0)
                        {
                         if(mapHCMatches.get(pos.Id)!=null)
                         {
                          lstHCMatches.add(mapHCMatches.get(pos.Id));
                          }
                         }  */
                                
                        If(lstHCMatches!=null && lstHCMatches.size()>0)
                        {
                            system.debug('***lstHCContacts******'+lstHCMatches);
                            For(Match__c m:lstHCMatches)  
                                HCMatchesId.add(m.Engagement__c);
                            
                            If(HCMatchesId!=null)
                            {
                                system.debug('***lstHCContacts******'+HCMatchesId);
                                lstEngagements = [Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id in : HCMatchesId];
                                if(lstEngagements!=null && lstEngagements.size()>0)
                                {
                                    system.debug('***lstEngagements******'+lstEngagements);
                                    for(Engagement__c eng:lstEngagements)
                                    {
                                        HCMatchEngIds.add(eng.Id);
                                        HCAccountIds.add(eng.Account_Id__c);
                                        
                                        ///Sharing HC Account  with PT Users and Partner Users
                                        List<Applicant_Info__c> appInfo =new List<Applicant_Info__c>();
                                        List<User> lstParnerUsr = new List<User>();
                                        appInfo = [Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c,a.CreatedById, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                                   where a.engagement__c = :eng.Id];
                                        if(appInfo!=null && appInfo.size()>0)
                                        {
                                            system.debug('***appInfo******'+appInfo);
                                            for(Applicant_Info__c aInfo : appInfo)
                                            {                               
                                                //Share the HC Account with the applicant
                                                system.debug('***sharing newHCAccount for aInfo.CreatedBy__c******'+aInfo.CreatedBy__c);
                                                Sharing_Security_Controller.shareAccount(NewHostAccount, aInfo.CreatedBy__c);
                                            }
                                        }
                                        //Sharing HC Account  with Partner Users
                                        if (eng.Partner_Id__c!=null)
                                        {
                                            lstParnerUsr=[Select u.Name, u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.Account__c, u.AccountId, u.AboutMe From User u where u.Intrax_Id__c =: eng.Partner_id__c];
                                            system.debug('******lstParnerUsr********'+lstParnerUsr);
                                            If(lstParnerUsr!=null && lstParnerUsr.size()>0)
                                            {
                                                system.debug('***sharing newHCAccount for aInfo.CreatedBy__c******'+lstParnerUsr); 
                                                Sharing_Security_Controller.shareAccount(NewHostAccount,lstParnerUsr);
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                }  
                                //sharing engagement & PT Account with HC users
                                if (HCMatchEngIds!=null && HCMatchEngIds.size()>0 && lstUser!=null && lstUser.size()>0 )  
                                {
                                    Sharing_Security_Controller.shareHCEngHCUsers(HCMatchEngIds,lstUser);
                                    system.debug('***sharing engagement with HC users******'+HCMatchEngIds); 
                                    system.debug('***sharing engagement with HC users******'+lstUser); 
                                }    
                                
                                if (HCAccountIds!=null && HCAccountIds.size()>0 && lstUser!=null && lstUser.size()>0)  
                                {
                                    system.debug('***sharing PT Account with HC users******'+HCAccountIds); 
                                    system.debug('***sharing PT Account with HC users******'+lstUser); 
                                    Sharing_Security_Controller.shareHCAccHCUsers(HCAccountIds,lstUser);
                                    
                                }
                            }                     
                            
                        }
                        
                    }
                } 
                //B-01515
                if(pos.RecordTypeId == Constants.POS_AYUSA_HF && strOldStatus !=strNewStatus && strOldStatus != 'Closed - Filled' && strNewStatus == 'Matching' && Notification_Generator.MatchingPosFlag==false)
                {
                    lstHFPosToBeNotified.add(pos);
                }
                
               /* if(pos.RecordTypeId == Constants.POS_WORK_TRAVEL && pos.Status__c == 'Matching' && pos.Match_Offer_Status__c == 'Offered')
                {
                    if(pos.Opportunity_Stage__c == 'Closed Won')
                    {    //optimisation effort             
                        lstPosMatches=[Select m.Status__c, m.RecordTypeId, m.Position_Name__c, m.Offer_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id From Match__c m where m.Position_Name__c=:pos.id and m.Offer_Status__c = 'Offered' and m.RecordTypeId =: Constants.MAT_INTERNSHIP and m.Intrax_Program__c= 'Work Travel' and m.Service_Level__c='Independent'];
                         //optimisation effort
                       
                       
                     /*  if(maplstPosMatches!=null && maplstPosMatches.size()>0)
                        {
                         if(maplstPosMatches.get(pos.id)!=null)
                         {
                          lstPosMatches.add(maplstPosMatches.get(pos.id));
                          }
                         }  // commented till here for the comment 3 lines above 
                     
                        if(lstPosMatches!=null && lstPosMatches.size()>0)
                        {
                            for(Match__c m:lstPosMatches)
                            {
                                m.Offer_Status__c='Accepted';
                                // m.Status__c = 'Confirmed';
                                lstPosMatchesToBeUpdated.add(m);
                                system.debug('****lstPosMatches m *****'+m);
                            }
                        }
                    }
                    else if(pos.Host_Opportunity_Id__c!=null)
                    {   
                     //optimisation effort
                        lstOpp=[Select o.OwnerId, o.Id,o.Operation_Stage__c,o.StageName, o.CreatedById From Opportunity o where o.Id=:pos.Host_Opportunity_Id__c];               
                        //optimisation effort
                      //  if(mapPosOpp.get(pos.Host_Opportunity_Id__c)!=null)
                        //{
                           // lstOpp.add(mapPosOpp.get(pos.Host_Opportunity_Id__c));
                            If(lstOpp !=null && lstOpp.size()>0) 
                            {
                                if(lstOpp[0].StageName =='Closed Won')
                                {
                                    lstPosMatches=[Select m.Status__c, m.RecordTypeId, m.Position_Name__c, m.Offer_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id From Match__c m where m.Position_Name__c=:pos.id and m.Offer_Status__c = 'Offered' and m.RecordTypeId =: Constants.MAT_INTERNSHIP and m.Intrax_Program__c= 'Work Travel' and m.Service_Level__c='Independent'];
                                    system.debug('****lstPosMatches*****'+lstPosMatches);
                                    if(lstPosMatches!=null && lstPosMatches.size()>0)
                                    {
                                        for(Match__c m:lstPosMatches)
                                        {
                                            m.Offer_Status__c='Accepted';
                                            lstPosMatchesToBeUpdated.add(m);
                                            system.debug('****lstPosMatches m *****'+m);
                                        }
                                    }
                                }
                            }
                       // }
                    }
                    if(lstPosMatchesToBeUpdated!=null && lstPosMatchesToBeUpdated.size()>0)
                        update lstPosMatchesToBeUpdated;
                }*/
                
                
                if(!(blnDeployTestFlag && strPosName.containsIgnoreCase('Test')))
                {
                    if(pos.RecordTypeId == Constants.POS_AYUSA_HF)
                    {
                        if(OldMailingStreet != NewMailingStreet || OldMailingCity!=NewMailingCity ||  OldMailingCountry!=NewMailingCountry || OldMailingPostalCode!=NewMailingPostalCode || OldMailingState!=NewMailingState)
                        {
                            system.debug('****pos*********'+ pos);
                             //optimisation effort
                            List<iGeolocate__c> lstobjiGeolocate=[Select i.SystemModstamp, i.Position__c, i.OwnerId, i.Name, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, i.CurrencyIsoCode, i.CreatedDate, i.CreatedById, i.Contact__c, i.ConnectionSentId, i.ConnectionReceivedId, i.Account__c From iGeoLocate__c i where i.Position__c =: pos.Id  ];
                            //optimisation effort
                           /* if(mapobjiGeolocate!=null && mapobjiGeolocate.size()>0)
                            {
                             if(mapobjiGeolocate.get(pos.Id)!=null)
                             {
                              lstobjiGeolocate.add(mapobjiGeolocate.get(pos.Id));
                              }
                            }  */
                           if(lstobjiGeolocate!=null && lstobjiGeolocate.size()>0)
                            {
                                For(iGeolocate__c igeo :lstobjiGeolocate)
                                {
                                    system.debug('****igeo*********'+ igeo);
                                    igeo.isUpdated__c = true;  
                                    system.debug('****igeo isUpdated__c*********'+ igeo.isUpdated__c);                         
                                }
                                update lstobjiGeolocate;
                            }
                            
                            else
                            {
                                iGeolocate__c objiGeolocate=new iGeolocate__c();
                                objiGeolocate.position__c = pos.Id;
                                //   objiGeolocate.Name = pos.Name + '_GeoLocate';
                                insert objiGeolocate;
                            }
                        }
                    }
                }
                
            }
            if(lstHFPosToBeNotified!=null && lstHFPosToBeNotified.size()>0)
                Notification_Generator.CreateHFApprovalNotification(lstHFPosToBeNotified);
            
            //manual share            
            if(allPosOwnerShareIDs != NULL && allPosOwnerShareIDs.size()>0)
            {
                flag='after';
                SharingSecurityHelper.persistSharingWithOwner(pos_share, flag, allPosOwnerShareIDs);    
            }
           
            //SEVIS_POSITION Trigger MERGED
         /*   
            //Get Match
            List<Match__c> matches = [select Id,Engagement__c from Match__c where Position_Name__c IN:setPositionId  and Status__c = 'Confirmed'];
            //Get Engagement
            
            if(matches!=null && matches.size()>0){
                for (Match__c match : matches){
                    system.debug('@@ adding match.eng');
                    setmatchEngId.add(match.Engagement__c);
                }
                engagement = [select Id,Sevis__c,Sevis_UEV_SOA_Edit__c from Engagement__c e where e.Id IN :setmatchEngId ];
            }
            
            if(engagement != null && engagement.size() > 0){
                for(Engagement__c itrEngagement : engagement){
                    if (itrEngagement.Sevis__c != NULL){
                        system.debug('@@ doing update');
                        itrEngagement.Sevis_UEV_SOA_Edit__c =  true;
                        lstToUpdate.add(itrEngagement);
                    }
                }
            }               
            if (lstToUpdate.size() > 0){
                system.debug('@@ updating eng');
                update lstToUpdate;
            }
            */
        } // AFTER UPDATE TRIGGER ENDS HERE  
    }// AFTER TRIGGER ENDS HERE  
    
    
    
    
}