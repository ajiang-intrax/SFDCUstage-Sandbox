trigger Trigger_Con_Opportunity on Opportunity (after insert, after update, before insert, before update) {
    //I have to exclude this trigger if Auto Sync Application.
    if(TriggerExclusion.isTriggerExclude('Opportunity')){
        return;
    }
    list<Opportunity> lstopp_Exclude = new list<Opportunity>();
    //Trigger Exclusion Logic - WT
    Opportunity oldOpportunity = new Opportunity();
    
    for(Opportunity itropp : trigger.new){
     if(trigger.oldMap != null){
        oldOpportunity = trigger.oldMap.get(itropp.Id);      
     if(itropp.RecordTypeId==Constants.OPP_WORK_TRAVEL_HC && itropp.Service_Level__c=='Independent' && itropp.StageName != oldOpportunity.StageName && itropp.StageName == 'Closed Won'){
        lstopp_Exclude.add(itropp);
      }
     }
    }
 
   system.debug('**Opportunity exclude list**'+lstopp_Exclude);
  
    if(lstopp_Exclude != null && lstopp_Exclude.size() > 0){
      if(Trigger.isbefore && Trigger.isupdate){
      WTTriggerHelper.OPClosedWon(lstopp_Exclude);
      return;
     }
     else if(Trigger.isafter && Trigger.isupdate)
     {
      return;
     }
   }
   


   //Trigger Exclusion Logic - WT

    OpportunityShare opp_share=new OpportunityShare();
    String sflag;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    if(trigger.isBefore){       
        //Holders
        Set<ID> sParentOppids= new Set<ID>();
        List<Opportunity> lParentOpprecs= New List<Opportunity>();
        Map<Id,Opportunity> mOpp= New Map<Id,Opportunity>();
        Map<ID,Opportunity > mapParentkeyopp= New Map<ID,Opportunity >();
        List<Opportunity> lUpdatechilds= new List<Opportunity>();
        //Get Record Types - commented on 01-10-2014 
        //RecordType OppRrdId=[Select id from RecordType where SobjectType='Opportunity' and DeveloperName='Group_Participant'];
        //Set the flag to prevent recursion
        if(Recursive_Handling_class.hasAlreadyCreatedFollowUpTasks()){
            //Get the parent opportunities   
            system.debug('*****op Trigger.New*******'+Trigger.New);  
            for(Opportunity O:Trigger.New){
                if(O.Parent_Opportunity__c!=null && O.RecordTypeId==Constants.OPP_GROUP_PARTICIPANT){
                    sParentOppids.add(O.Parent_Opportunity__c);  
                }
            }
            //Load the parent Opportunities
            lParentOpprecs=[Select id,StageName,Reason__c,Reason_Detail__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                            Engagement_End__c,Parent_Opportunity__c from Opportunity where id in :sParentOppids];
            //Is this needed?
            for(Opportunity O:lParentOpprecs){
                if(!mOpp.containsKey(O.id)){
                    mOpp.put(O.id,O);
                }else{
                    mOpp.get(O.id);
                }
            }
            //If Parent Opp is present 
            for(Opportunity O:Trigger.New){     
                if(mOpp.ContainsKey(O.Parent_Opportunity__c) && O.RecordTypeId==Constants.OPP_GROUP_PARTICIPANT){
                    //Overwrite values from parent
                    O.Countries_of_Interest__c=mOpp.get(O.Parent_Opportunity__c).Countries_of_Interest__c;
                    O.Location_of_Interest__c=mOpp.get(O.Parent_Opportunity__c).Location_of_Interest__c;
                    O.Program_Year__c=mOpp.get(O.Parent_Opportunity__c).Program_Year__c;
                    O.Engagement_Start__c=mOpp.get(O.Parent_Opportunity__c).Engagement_Start__c;
                    O.Engagement_End__c=mOpp.get(O.Parent_Opportunity__c).Engagement_End__c;
                    //If parent is closed lost or closed cancel, overwrite with values from parent
                    if(mOpp.get(O.Parent_Opportunity__c).Stagename == 'Closed Lost' || mOpp.get(O.Parent_Opportunity__c).Stagename == 'Closed Cancel'){
                        O.StageName=mOpp.get(O.Parent_Opportunity__c).StageName;
                        O.Reason__c=mOpp.get(O.Parent_Opportunity__c).Reason__c;
                        O.Reason_Detail__c=mOpp.get(O.Parent_Opportunity__c).Reason_Detail__c;
                    }
                }
            }//For End  
        }
        
        if(trigger.isInsert)
        {
            system.debug('lead converted and opp created');
            for(Opportunity O:Trigger.New)
            {
             system.debug('this is opp now' +Trigger.New);
             List<String> parts = new List<String>();
             if (O.Countries_of_Interest__c != null)
                parts = (O.Countries_of_Interest__c).split(';');
             if((parts!=null) && (parts.size()==1))
                  {
                      o.Country_of_Interest__c = parts[0];
                      system.debug('** o.Country_of_Interest' +parts[0]);
                  }
             else if(parts.size()>1)     
             {
              o.Country_of_Interest__c = '';
             }
              
            }
            IUtilities.update_opp_missing_docs(trigger.new, false);
            system.debug('****** FLAG!!! ' + Trigger_Engagement_Helper.getsyncOppFromEng());
            if(!Trigger_Engagement_Helper.getsyncOppFromEng()) IUtilities.OpportunityToEngagement(trigger.new);  
            for(Opportunity O:Trigger.New)
            {
             system.debug('this is opp now' +Trigger.New);
            }         
        }
        if(trigger.isUpdate)        
        { 
          Set<Id> oppShareIds = new set<Id>();
          for(Opportunity record: Trigger.new) {
                if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null &&  record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) {                
                    oppShareIds.add(record.Id);
                }
                system.debug('**oppShareIds**'+oppShareIds);
           }
           if(oppShareIds!=null && oppShareIds.size()>0) {
            sflag='before';
            SharingSecurityHelper.persistSharingwithOwner(opp_share, sflag, oppShareIds);   
           }
        
            else{
                  system.debug('ENTERED ELSE');
              //If we have exclusively other type owner set to opp then do the other before updates
              
            //optimising code for soql query limit by .. AP. starts
          set<String> setId = new set<String>();
          map<String, Account> mapAccRecord = new map<String, Account>();
           list<Account> lstAccount = new list<Account>();
            for(Opportunity op: Trigger.new){
             if(op.Partner_Id__c != null)
              {          
              setId.add(op.Partner_Id__c);
              }
             }
            if(setId != null && setId.size() > 0){
              lstAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                                   WHERE type = 'Partner' AND Intrax_Id__c IN :setId];

                if (lstAccount!= null && lstAccount.size()>0) {                                   
                for(Account itrAccount : lstAccount){
                    mapAccRecord.put(itrAccount.Intrax_Id__c , itrAccount);             
                }}
             
              }
            
            for(Opportunity op: Trigger.new){
                system.debug('*****op*******'+op);              
                list<Account> partnerAccount = new list<Account>(); //..AP
                string old_Partner = trigger.oldMap.get(op.Id).Partner_Id__c;
                string new_Partner = trigger.newMap.get(op.Id).Partner_Id__c;
                system.debug('*****partners*******'+old_Partner +new_Partner); 
                if(((old_Partner != new_Partner) || (old_Partner == new_Partner)) && new_Partner != NULL)
                    //if((old_Partner != new_Partner) && new_Partner != NULL)
                {
                   if(mapAccRecord!=null && mapAccRecord.size()>0){
                   if(mapAccRecord.get(op.Partner_Id__c)!= null)
                   {
                    partnerAccount.add(mapAccRecord.get(op.Partner_Id__c));
                    }
                   }
                   //optimising code for soql query limit by .. AP. ends
                    /*List<Account> partnerAccount = [SELECT Id, Pluto_Id__c, Name, type, Intrax_Id__c FROM Account 
                                                   WHERE Intrax_Id__c =: op.Partner_Id__c
                                                    AND type = 'Partner'];*/
                     system.debug('*****partner account*******'+partnerAccount.size());                                  
                     if (partnerAccount.size() > 0){
                        System.debug('Setting the ID');
                        op.Partner_Account__c = partnerAccount[0].Id;
                    }
                    //else  Commented for D-01697 
                      //  op.Partner_Account__c = NULL; Commented for D-01697 
                }
                else if(new_Partner == NULL)
                    op.Partner_Account__c = NULL;
                
                //Check if Application is HF and Approved
                if (op.Type == 'Participant')
                {
                    system.debug('*****op*******'+op);
                    if ((op.Intrax_Program_Options__c !=null && op.Intrax_Program_Options__c.contains('ProWorld Group')) || (op.Intrax_Program_Options__c !=null && op.Intrax_Program_Options__c.contains('Internship Group')) )
                    {                    
                        op.RecordTypeId=Constants.OPP_GROUP_PARTICIPANT;                
                    }
                    else if (op.Intrax_Programs__c.contains('AuPairCare'))
                    {
                        op.RecordTypeId=Constants.OPP_AUPAIRCARE_PT;
                    }
                    else if (op.Intrax_Programs__c.equals('English and Professional Skills'))
                    {                       
                        op.RecordTypeId=Constants.OPP_CENTERS_PT;                        
                    }                   
                    else if (op.Intrax_Programs__c.equals('Internship'))
                    {  
                        if(op.Countries_of_Interest__c ==null)
                        {
                            op.RecordTypeId=Constants.OPP_ICD_INTERN_PT;
                        }
                        else if(op.Countries_of_Interest__c.equals('United States'))     
                        { 
                            op.RecordTypeId=Constants.OPP_ICD_INTERN_PT;
                        }
                        else if(op.Countries_of_Interest__c !='United States')    
                        { 
                            //op.RecordTypeId=Constants.OPP_IIA_INTERN_PT;
                            op.RecordTypeId=Constants.OPP_ICD_INTERN_PT;
                        }
                    }
                    
                    else if (op.Intrax_Programs__c.contains('ProWorld'))
                    {
                        op.RecordTypeId=Constants.OPP_PW_PARTICIPANT;
                    }
                    else if (op.Intrax_Programs__c.contains('Ayusa'))
                    {
                        op.RecordTypeId=Constants.OPP_AYUSA_PT;
                    }                  
                    else if (op.Intrax_Programs__c.equals('Work Travel'))
                    {
                        op.RecordTypeId=Constants.OPP_WORK_TRAVEL_PT;
                    }
                    
                    
                }
                else if (op.Type=='Host Company')
                {                
                    if (op.Intrax_Programs__c.contains('ProWorld'))
                    {
                        op.RecordTypeId=Constants.OPP_PW_HC;
                    }
                    else if (op.Intrax_Programs__c.contains('Work Travel'))
                    {
                        op.RecordTypeId=Constants.OPP_WORK_TRAVEL_HC;
                    }  
                    else
                    {
                        op.RecordTypeId=Constants.OPP_INTERN_HC;
                    }
                }               
                else if (op.Type=='Institution')
                {
                    op.RecordTypeId=Constants.OPP_PW_UNIVERSITY;
                }                
                
                else if (op.Type=='Host Family')
                {
                    op.RecordTypeId=Constants.OPP_HOST_FAMILY;
                }
                
            }
            
            // Logic For Parent
            List<Opportunity> lChildCOpps= new List<Opportunity>();
            set<id> oppId= new set<id>();
            for(Opportunity op: Trigger.new){
                If(op.Parent_Opportunity__c== null)
                    oppId.add(op.id);
            }
            system.debug('debug:::setofoppId===='+oppId);
            
            If(oppId != null && oppId.size()>0){
            lChildCOpps=[Select id,StageName,Reason__c,Reason_Detail__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                                            Engagement_End__c,Parent_Opportunity__c,RecordTypeID from Opportunity where Parent_Opportunity__c in :oppId];
            system.debug('****lChildCOpps*******'+lChildCOpps);
            }
            
            for(Opportunity O:lChildCOpps){
                if(!mapParentkeyopp.containskey(O.id)){
                    mapParentkeyopp.put(O.ID,O);    
                }else{
                    mapParentkeyopp.get(O.id);
                }              
            }// For End
            system.debug('****mapParentkeyopp*******'+mapParentkeyopp);
            for(Opportunity O:lChildCOpps){
                if(mapParentkeyopp.containskey(O.ID)){
                    O.Countries_of_Interest__c=Trigger.Newmap.get(O.Parent_Opportunity__c).Countries_of_Interest__c;
                    O.Location_of_Interest__c =Trigger.Newmap.get(O.Parent_Opportunity__c).Location_of_Interest__c;
                    O.Program_Year__c = Trigger.Newmap.get(O.Parent_Opportunity__c).Program_Year__c;
                    O.Engagement_Start__c = Trigger.Newmap.get(O.Parent_Opportunity__c).Engagement_Start__c;
                    O.Engagement_End__c = Trigger.Newmap.get(O.Parent_Opportunity__c).Engagement_End__c;
                    
                    if(Trigger.Newmap.get(O.Parent_Opportunity__c).Stagename == 'Closed Lost' || Trigger.Newmap.get(O.Parent_Opportunity__c).Stagename == 'Closed Cancel'){
                        O.StageName=Trigger.Newmap.get(O.Parent_Opportunity__c).StageName;
                        O.Reason__c=Trigger.Newmap.get(O.Parent_Opportunity__c).Reason__c;
                        O.Reason_Detail__c=Trigger.Newmap.get(O.Parent_Opportunity__c).Reason_Detail__c;
                    }
                    lUpdatechilds.add(O);    
                }
            }// For End
            system.debug('****lUpdatechilds******'+lUpdatechilds);
            Recursive_Handling_class.setAlreadyCreatedFollowUpTasks();
            
            if(lUpdatechilds.size()>0 && lUpdatechilds!=null)
                update lUpdatechilds;                    
            
          
            }
        
        } // End isBefore isUpdate
    }
    if(trigger.isAfter)
    {   
        if(trigger.isUpdate){ 
        
            // ManualSharing - Ownership change
            
             set<Id> allshareIDs = new set<Id>();
             for(Opportunity shr: Trigger.new)
             {
                if(Trigger.oldMap!=null && Trigger.oldMap.get(shr.Id).OwnerId!=null &&  shr.OwnerId != Trigger.oldMap.get(shr.Id).OwnerId) {  
                allshareIDs.add(shr.id);
                }
             }
             if(allshareIDs != NULL && allshareIDs.size()>0)
             {
                sflag='after';
                SharingSecurityHelper.persistSharingwithOwner(opp_share, sflag, allshareIDs);    
             }
             else{
                system.debug('ENTERED ELSE');
                //If we have exclusively other type owner set to opp then do the other before updates
                         
                for(Opportunity Op:Trigger.New){
                    system.debug('******op stage updated*******'+Op);
                    string stage_old = trigger.oldMap.get(Op.Id).StageName;
                    string stage_new = trigger.newMap.get(Op.Id).StageName;
                    // string pgm_year_old = trigger.neMap.get(Op.Id).StageName;
                    system.debug('******op stage updated stage_new*******'+stage_new);
                    system.debug('******op stage updated stage_old*******'+stage_old);
                    System.debug('opportunity  ' + op);
                    System.debug('opportunity Type ' + op.Type);
                    System.debug('opportunity Intrax_Programs__c ' + op.Intrax_Programs__c);
                   if(Op.RecordTypeId==Constants.OPP_WORK_TRAVEL_HC && stage_old!=stage_new && stage_new!=null && op.Service_Level__c=='Independent' && stage_new!='Closed Won'){
                        List<Position__c> lstPosition = [Select p.Type__c,p.Opportunity_Stage__c, p.RecordTypeId, p.Name, p.Intrax_Program_Options__c, p.Id, p.Host_Opportunity_Id__c From Position__c p where p.Host_Opportunity_Id__c =:Op.Id];
                        List<Position__c> listPosition = new List<Position__c>();
                        system.debug('******op stage updated lstPosition*******'+lstPosition);
                        If(lstPosition!=null && lstPosition.size()>0)
                        {
                          for(Position__c plist:lstPosition)
                           {
                            plist.Opportunity_Stage__c = stage_new;
                            listPosition.add(plist);
                           }
                        }
                      if(listPosition!=null && listPosition.size()>0)
                         update listPosition;
                      system.debug('******op stage updated lstPosition*******'+listPosition);
                      
                      }
                    
                    //B-02654 Jose
                    if (Op.Type == 'Participant' && op.Intrax_Programs__c == 'AuPairCare' ){
                        //share the APC PT Opportunity record 
                        system.debug('Inside PT opportuniy trigger after insert -- loop CreatedBy__c' + op.CreatedBy__c);
                        system.debug('Inside PT opportuniy trigger after insert -- loop CreatedByid' + op.CreatedByid);
                        if(Op.CreatedBy__c!=null)
                            Sharing_Security_Controller.shareOpportunity(Op.Id,Op.CreatedBy__c);
                        
                        if(Op.CreatedByid!=null) 
                            Sharing_Security_Controller.shareOpportunity(Op.Id,Op.CreatedByid); 
                    }
                    
                    //if it is APC Host family opportunity then share it with the APC HF user
                    if (Op.Type == 'Host Family' && op.Intrax_Programs__c == 'AuPairCare' ){
                        //share the Opportunity record
                        system.debug('Inside HF opportuniy trigger after insert -- loop CreatedBy__c' + op.CreatedBy__c);
                        system.debug('Inside HF opportuniy trigger after insert -- loop CreatedByid' + op.CreatedByid);
                        if(Op.CreatedBy__c!=null)
                        Sharing_Security_Controller.shareOpportunity(Op.Id,Op.CreatedBy__c);
                        
                        if(Op.CreatedByid!=null) 
                         Sharing_Security_Controller.shareOpportunity(Op.Id,Op.CreatedByid); 
                        
                        //B-02736. Creation of Match Opportunity                                      
                        if(stage_old!='Closed Won' && stage_old!=stage_new && stage_new=='Closed Won' 
                           && op.ChildOppType__c != 'Match Break' && op.Parent_Opportunity__c != null){
                            System.debug('Calling the Intacct_Wrapper to initiate the creation of SO,RC,SI and AR in Intacct System');
                            Intacct_Wrapper intacctWrap = new Intacct_Wrapper();
                            intacctWrap.CreateSalesOrder(op.Id,op.AccountId);
                            if(op.ChildOppType__c == 'Application'){
                                List<Applicant_Info__c> appInfoList = 
                                    [SELECT Id,Opportunity_Name__c,Intrax_Program__c,RecordType.Name,Account__c,
                                     name,Intrax_Program_Options__c,Type__c,Intrax_Region__c,Country_of_Interest__c,Intrax_Program_Category__c,
                                     Service_Level__c,Location_of_Interest__c,CreatedBy__c
                                     FROM Applicant_Info__c WHERE Opportunity_Name__c=:Op.parent_opportunity__c 
                                     AND  Intrax_Program__c='AuPairCare' 
                                     AND RecordType.Name='AuPairCare HF' LIMIT 1]; 
                                if(appInfoList!=null && appInfoList.size()>0){                           
                                    AppTriggerHelper.CreateAppOpp(appInfoList[0],appInfoList[0].Opportunity_Name__c,'USD','Match');
                                }
                            }
                        }
                        
                        if(stage_old!='Closed Won' && stage_old!=stage_new && stage_new=='Closed Won' 
                           && op.ChildOppType__c == 'Match Break' && op.Parent_Opportunity__c != null && op.Special_Notes__c !=null){
                            System.debug('Calling the Intacct_Wrapper to initiate the creation of SO,RC,SI and AR in Intacct System' +
                                        'for match break opportunity which has manualy inserted service credit products');
                            Intacct_Wrapper intacctWrap = new Intacct_Wrapper();
                            intacctWrap.CreateSalesOrder(op.Id,op.AccountId);
                        }
                    }
                    
                    if (Op.Type == 'Participant' && op.Intrax_Programs__c == 'AuPairCare' ){
                        //share the Opportunity record
                        system.debug('Inside opportuniy trigger after insert -- loop CreatedBy__c' + op.CreatedBy__c);
                        //Sharing_Security_Controller.shareOpportunity(Op.Id,Op.CreatedBy__c);
                        
                        //B-03374
                        if(op.Country_of_Interest__c == 'United States' && stage_old!=stage_new && (stage_new=='Closed Won' || stage_new=='Closed Cancel')){
                            if(op.AccountId!=null){
                                //Share the Account with HQ_APC_Exec role
                                Sharing_Security_Controller.shareOppAccWithRole(op.AccountId,'HQ_APC_Exec');
                            }
                        }
                        
                        //B-02736. Creation of Match Opportunity                                      
                        if(stage_old!='Closed Won' && stage_old!=stage_new && stage_new=='Closed Won' && op.Parent_Opportunity__c != null){
                            System.debug('Calling the Intacct_Wrapper to initiate the creation of SO,RC,SI and AR in Intacct System');
                            Intacct_Wrapper intacctWrap = new Intacct_Wrapper();
                            intacctWrap.CreateSalesOrder(op.Id,op.AccountId);
                        }
                    }
                  
                } 
                
                
                IUtilities.update_opp_PrimaryContact(trigger.new);
                
                // B-01689 --> we need to be sure the code does not get into an infinite loop --> FLAG       
                system.debug('****** FLAG!!! ' + Trigger_Engagement_Helper.getsyncOppFromEng());          
                if(!Trigger_Engagement_Helper.getsyncOppFromEng()) {
                    Trigger_Engagement_Helper.setsyncOppFromEng();
                    IUtilities.OpportunityToEngagement(trigger.new); 
                }
           
            }
          
        }
        
        if(trigger.isInsert){
            
            // IGI 492 related
            IUtilities.create_hc_validation_assessment(trigger.new);
        } // End if update
        
    }
}