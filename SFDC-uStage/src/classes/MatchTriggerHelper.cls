/*
    Purpose         :   Helper class for Trigger_Match.
                
    Created Date    :   03/20/2012
    
    Current Version :   v1.0
     
    Revision Log    :   V_1.1 Created
                        V_1.2 - 08/23/2012 - Modified - Story 2098
*/
public with sharing class MatchTriggerHelper {
    
    public static boolean firstRun = true; //Limit Trigger execution to 1 pass per transaction   

    /**
    * Description   :   This method checks for all the match records having "Matched" status and update the related opportunity.
    *                   This will also update all the match records for same opportunity-participant pair with Withdrawn status if those are post matched.
    * @args         :   List of matches
    * @return       :   void
    */

   //--> Start APC Pay Events B-02402
   //Helper class that takes a map of new (just inserted) Match to Position Ids, works out the Position Owner,
   //and then creates an appropriate new Match_Owner_History

    //@future
    public static void logOwnership(Map<Id, Id> matchPositionIds){
        //Use MatchId -> PositionId map to get list of Position IDs for which we need to look up Owner
        Set<Id> mapIds = new Set<Id>();
        mapIds = matchPositionIds.keySet();
        List<Id> positionIds = New List<Id>();
        for(Id key : mapIds){
            positionIds.add(matchPositionIds.get(key));
        }
        Map<Id, Position__c> mpos = New Map<Id, Position__c>([SELECT Id, Name, OwnerId FROM Position__c WHERE Id in :positionIds]);
        //Now loop through passed matchPosition map to create new MOH, looking up Position owner from newly created Map for each
        List<Match_Owner_History__c> matchOwnerHistories = New List<Match_Owner_History__c>();
        for(Id mId : mapIds){
            Match_Owner_History__c moh = New Match_Owner_History__c();
            moh.Match__c = mId;
            moh.Start_Date__c = Date.today();
            moh.Match_Owner__c = mpos.get(matchPositionIds.get(mId)).OwnerId;
            moh.Changed_By__c = UserInfo.getUserId();
            if(mpos.get(matchPositionIds.get(mId)).OwnerId.getSObjectType().getDescribe().getName() == 'User'){
                matchOwnerHistories.add(moh);
            }
        }
        system.debug('@@@@@@@matchOwnerHistories' + matchOwnerHistories);
        insert matchOwnerHistories;
   }
   //<-- End APC Pay Events POC  
    
   public static void count_camp_session(string old_camp_session, string new_camp_session){
        system.debug('***** CAMP SEASON - OLD: ' + old_camp_session + ' / NEW: ' + new_camp_session);
        if(old_camp_session != new_camp_session){
            //list<AggregateResult> camp_session_count; 
            integer camp_session_count;
            Campaign_Session__c camp_session;
            
            if(new_camp_session == null){ 
                camp_session_count = [SELECT count() FROM Match__c WHERE Campaign_Session__c =: old_camp_session];
                camp_session = [SELECT Id, Spaces_Filled__c FROM Campaign_Session__c WHERE Id =: old_camp_session];
            }
            else {
                camp_session_count = [SELECT count() FROM Match__c WHERE Campaign_Session__c =: new_camp_session];
                camp_session = [SELECT Id, Spaces_Filled__c FROM Campaign_Session__c WHERE Id =: new_camp_session];
                 
            }
            
            camp_session.Spaces_Filled__c = camp_session_count;
            update camp_session;            
            
        } 
   }
   //B-02432 Starts.. by AP
   public static void updateOppMatchDate(Id mId){
    System.debug('@@ match id @@' +mId);
    Opportunity PartOpp = new Opportunity();
    List<Match__c> match =[Select Id,Participant_Opportunity_Id__c,Match_Date__c,Participant_Opportunity_Id__r.Match_Date__c,Participant_Id__c,Status__c from Match__c  where ID =: mId];
    System.debug('@@ opp date match date @@' +match[0].Participant_Opportunity_Id__r.Match_Date__c +match[0].Match_Date__c);
    if (match[0].Participant_Opportunity_Id__r.Match_Date__c == null )
        {
         match[0].Participant_Opportunity_Id__r.Match_Date__c = match[0].Match_Date__c;
         System.debug('@@opp id  @@'+match[0].Participant_Opportunity_Id__r.Id);
         System.debug('@@ opp date match date @@' +match[0].Participant_Opportunity_Id__r.Match_Date__c +match[0].Match_Date__c);
         PartOpp = [Select Id,Match_Date__c from Opportunity where ID =:match[0].Participant_Opportunity_Id__r.Id];
         PartOpp.Match_Date__c = match[0].Match_Date__c;
         update PartOpp;
        } 
    
   }//B-02432 Ends
    //D-02107
  public static void setHostAccount(list<Match__c> lstMat,map<Id, Match__c> mapMatch)
   { 
    for(Match__c itrMatch : lstMat){
     Match__c oldMatch = new Match__c();
     if(mapMatch != null){
      oldMatch = mapMatch.get(itrMatch.Id);
     }
   
     if(itrMatch.Intrax_Program__c !='AuPairCare' && itrMatch.Host_Account__c == null && itrMatch.Position_HostCompany__c != null){
      if(itrMatch.Status__c =='Confirmed' && itrMatch.Status__c != oldMatch.Status__c){
       itrMatch.Host_Account__c = itrMatch.Position_HostCompany__c;
       }
      if(mapMatch == null)
       { system.debug('new match@@');
        itrMatch.Host_Account__c = itrMatch.Position_HostCompany__c;
       }
      }     
     }
    }
     //D-02107 ends
     
    //B-03463 starts
  public static void setAddHostAcc(list<Match__c> lstMat,map<Id, Match__c> mapMatch)
   { 
    for(Match__c itrMatch : lstMat){
     Match__c oldMatch = new Match__c();
      if(mapMatch != null){
       oldMatch = mapMatch.get(itrMatch.Id);
      }
     if(itrMatch.Intrax_Program__c !='AuPairCare' && itrMatch.Host_Account__c != null){
       if(itrMatch.Position_HostCompany__c!= oldMatch.Position_HostCompany__c)
        {
         itrMatch.Host_Account__c = itrMatch.Position_HostCompany__c;
        }
      }     
     }
    }
     //B-03463 ends
     
    //B-03349
    public static void updateWTOtherMatchesToWithdrawn(list<Match__c> lstNewMatch, map<Id, Match__c> mapOldMatch){
        system.debug('lstNewMatch::' +lstNewMatch + 'mapOldMatch::' +mapOldMatch);
        list<Match__c> lstMatchToUpdate = new list<Match__c>();
        list<Match__c> lstMatch = new list<Match__c>();
        set<Id> setEngId = new set<Id>();
        set<Id> setMatchEngId = new set<Id>();
        set<Id> setMatchId = new set<Id>();
        set<Id> setMatchWithdrawnId = new set<Id>();
        list<Notification__c> lstNotification = new list<Notification__c>();
        list<Notification__c> lstNotificationToUpdate = new list<Notification__c>();
        map<Id, Engagement__c> mapEngagement = new map<Id, Engagement__c>();
    
        for(Match__c itrMatch : lstNewMatch){
            Match__c oldMap = new Match__c();
            if(mapOldMatch != null){
                oldMap = mapOldMatch.get(itrMatch.Id);
            }
            if(itrMatch.Intrax_Program__c == 'Work Travel' && itrMatch.Status__c != oldMap.Status__c && itrMatch.Status__c == 'Withdrawn'){
                setMatchWithdrawnId.add(itrMatch.Id);
            }           
            
            if(itrMatch.Intrax_Program__c == 'Work Travel' && itrMatch.Status__c != oldMap.Status__c && itrMatch.Status__c == 'Confirmed'){
                if(itrMatch.Engagement__c != null){
                    setEngId.add(itrMatch.Engagement__c);
                }
            }
        }
        
        if(setEngId != null && setEngId.size() > 0){
            mapEngagement = new map<Id, Engagement__c>([select Id, Status__c from Engagement__c where Id IN :setEngId]);
            
            for(Match__c itrMatch : lstNewMatch){
                Match__c oldMap = new Match__c();
                if(mapOldMatch != null){
                    oldMap = mapOldMatch.get(itrMatch.Id);
                }
                if(itrMatch.Intrax_Program__c == 'Work Travel' && itrMatch.Status__c != oldMap.Status__c && itrMatch.Status__c == 'Confirmed'){
                    if(itrMatch.Engagement__c != null && mapEngagement.get(itrMatch.Engagement__c) != null){
                        Engagement__c engRecord = new Engagement__c();
                        engRecord = mapEngagement.get(itrMatch.Engagement__c);
                        if((engRecord.Status__c == 'Program Ready' ||engRecord.Status__c == 'Processing' || engRecord.Status__c == 'New')){
                            setMatchEngId.add(itrMatch.Engagement__c);
                            setMatchId.add(itrMatch.Id);
                        }
                    }
                }
            }
        }        
        
        if(setMatchEngId != null && setMatchEngId.size() > 0){ 
            lstMatch = [SELECT Id,  Status__c, Offer_Status__c, Engagement__c, (select Id, Type__c, Status__c from Notifiers__r) FROM Match__c where Engagement__c IN:setMatchEngId and Id NOT IN:setMatchId];
            
            if(lstMatch != null && lstMatch.size() > 0){
                for(Match__c itrMatch : lstMatch){
                    if(itrMatch.Status__c == 'Saved' || itrMatch.Status__c == 'Applied' || itrMatch.Status__c == 'Recommended' || itrMatch.Status__c == 'Requested'){
                        itrMatch.Status__c = 'Withdrawn';
                        if(itrMatch.Offer_Status__c == 'Offered'){
                            itrMatch.Offer_Status__c = 'Declined';                      
                        }
                        lstMatchToUpdate.add(itrMatch);
                        setMatchWithdrawnId.add(itrMatch.Id);
                    }
                }
            }           
        }
        
        if(setMatchWithdrawnId != null && setMatchWithdrawnId.size() > 0){
            lstNotification = [select Id, Type__c, Status__c from Notification__c where Match__c IN :setMatchWithdrawnId];
            
            if(lstNotification != null && lstNotification.size() > 0){
                for(Notification__c itrNotification : lstNotification){
                    if(itrNotification.Type__c == 'Offer Extended' && (itrNotification.Status__c == 'Not Started' || itrNotification.Status__c == 'In Progress')){
                        itrNotification.Status__c = 'Not Initiated';
                        lstNotificationToUpdate.add(itrNotification);
                    }
                }
            }
        }
        
        if(lstMatchToUpdate != null && lstMatchToUpdate.size() > 0){
            TriggerExclusion.triggerExclude('Match', true);
            TriggerExclusion.triggerExclude('Position', true);
            update lstMatchToUpdate;
            TriggerExclusion.triggerExclude('Match', false);
            TriggerExclusion.triggerExclude('Position', false);
        }  
        
        if(lstNotificationToUpdate != null && lstNotificationToUpdate.size() > 0){
            update lstNotificationToUpdate;
        }
    }    
    
    public static void updateOpportunityOperationStageByMatchStatus(Set<Id> matchIds) {
        System.debug('******** matchIds***'+matchIds);
   List<Match__c> matches =[Select Id,Is_Future_SOA__c,Position_Name__r.Id,Placement_Number__c,Participant_Opportunity_Id__c, Participant_Id__c,Status__c,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c,Position_Name__r.Host_Company_Id__c, Interview_Date__c from Match__c  
                               where ID IN:matchIds AND Intrax_Program__c != 'Work Travel'];
        //Property to hold match related opportunities id
        Set<Id> oppIds = new Set<Id>();
        
        //Property to hold the participant id
        //This set will be used in retrival of all the matches records having same participant and opportunity
        Set<Id> ptIds = new Set<Id>();
        
        //loop through the matche and get the related opportunity and participant id
        for(Match__c match : matches) {         
            // MT 140 Changes
            //if(match.Participant_Opportunity_Id__c != null && match.Status__c == Constants.MATCH_STATUS_MATCHED) {
            if(match.Participant_Opportunity_Id__c != null && match.Status__c == 'Confirmed') {    
                //add opportunity id in set 
                oppIds.add(match.Participant_Opportunity_Id__c);
                System.debug('******** OPIDSSSSSSS'+oppIds);
            }
            // MT 140 Matches
            //if(match.Participant_Id__c != null  && match.Status__c == Constants.MATCH_STATUS_MATCHED) {
            if(match.Participant_Id__c != null  && match.Status__c == 'Confirmed') {
                
                //add participant id
                ptIds.add(match.Participant_Id__c);
                System.debug('******* PTIDSSSSSSS'+ptIds);
            }
        } 
        
        //Create a map to hold the opportunity data from database
        Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>([Select Id, Operation_Stage__c from Opportunity where Id IN : oppIds]);
        
        //Create a list of opportunity records to be updated
        List<Opportunity> opportunitiesToBeUpdated = new List<Opportunity>();
        
        //loop through the positions agian and update the related opportunity  if needed
        for(Match__c match : matches) {
            if(match.Participant_Opportunity_Id__c != null 
                && match.Status__c == Constants.MATCH_STATUS_MATCHED
                && mapOpportunities.containsKey(match.Participant_Opportunity_Id__c) 
                && mapOpportunities.get(match.Participant_Opportunity_Id__c).Operation_Stage__c != Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED) {
                    
                    //update the Operation_Stage__c field and add in the list to be updated
                    mapOpportunities.get(match.Participant_Opportunity_Id__c).Operation_Stage__c = Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED;
                    opportunitiesToBeUpdated.add(mapOpportunities.get(match.Participant_Opportunity_Id__c));
                    
            }
        }
        
        //perform the DML operation only if required
        if(opportunitiesToBeUpdated.size() > 0)
            update opportunitiesToBeUpdated;
            
        //Property to hold the other matches records need to be updated
        List<Match__c> matchesToBeUpdated = new List<Match__c>();
        List<Match__c> lstOtherMatches = [Select Id, Status__c, Interview_Date__c , Placement_Number__c , Is_Future_SOA__c from Match__c  
                                where 
                                Participant_Opportunity_Id__c != null AND Participant_Opportunity_Id__c IN: oppIds 
                                AND Participant_Id__c != null AND Participant_Id__c IN: ptIds 
                                //AND Status__c IN: Constants.MATCH_POST_MATCH_VALUES
                                AND ID NOT IN: matches];
        //Query match object to find out all other match with post-match status
        for(Match__c match : lstOtherMatches) {
        system.debug('***** Changing status to confirmed');    
            //Check for updating the status only is match status is "Assigned" or "Interview Pending" and interview date is in future - Story 2098
            /* Commented out due to MT 140
            if(Constants.MATCH_STATUS_ASSIGNED.equalsIgnoreCase(match.Status__c) 
                || (Constants.MATCH_STATUS_INTERVIEW_PENDING.equalsIgnoreCase(match.Status__c)
                    && match.Interview_Date__c > DateTime.now())) {
                
                //update the status of the macth status to Withdrawn and add in the list to be updated
                match.Status__c = Constants.MATCH_STATUS_WITHDRAWN;
                matchesToBeUpdated.add(match);
            }*/
            system.debug('****** match being updated: ' + match.Id);
            if(match.Status__c == 'Saved' || match.Status__c == 'Applied' || match.Status__c == 'Recommended' || match.Status__c == 'Requested'){
                if (match.Placement_Number__c == null && match.Is_Future_SOA__c == false )
                {
                match.Status__c = Constants.MATCH_STATUS_WITHDRAWN;
                matchesToBeUpdated.add(match);
                }
            }
        }
        
        System.debug('******* matchestobepdatedsize: '+matchesToBeUpdated.size());
        //Check for the matchesToBeUpdated size and perform the DML operation only if required
        if(matchesToBeUpdated.size() > 0)
            update matchesToBeUpdated;
    }
 /*   static testMethod void testUpdateOpportunityOperationStageByMatchStatus() {
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
            insert hostOpportunity;
            
            //Insert Position Instance
            Position__c position1 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3 );
            
            insert position1;
            
            //Insert Position Instance
            Position__c position2 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3 );
            
            insert position2;
            
            //Create test data
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 20; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType[0].Id, PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            
            //Create list of opportunities
            List<Opportunity> listOpportunity = new List<Opportunity>();
            
            //insert in list
            for(Account acc : listAccount) {
                listOpportunity.add(new Opportunity(Name = 'Test', AccountId = acc.Id, CloseDate = Date.Today(), Project_Name__c = 'test',
                                                    App_Fee_Paid__c = true, Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', 
                                                    Engagement_Start__c = Date.today(), StageName = 'Closed Won'));
            }
            
            insert listOpportunity;
            
            //Create matched records with Interview Pending Status
            List<Match__c> matchesForPosition1 = new List<Match__c>();
            List<Match__c> matchesForPosition2 = new List<Match__c>();
            
            //loop through the opportunity and add records in the list
            for(Opportunity opp : listOpportunity){
                matchesForPosition1.add(new Match__c(Name = 'Test', Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Interview Pending' ));
                matchesForPosition2.add(new Match__c(Name = 'Test', Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position2.Id, Status__c = 'Interview Pending' ));
            }
            
            //insert matches data'
            insert matchesForPosition1;
            insert matchesForPosition2;
            
            //loop for the matchesForPosition1 and update status with Matched
            for(Match__c match : matchesForPosition1) {
                match.Status__c = Constants.MATCH_STATUS_MATCHED;
            }
            
            //update matchesForPosition1
            update matchesForPosition1;
            
            //assert for the result
            for(Match__c match : [Select Id, Participant_Opportunity_Id__r.Operation_Stage__c from Match__c where Id IN: matchesForPosition1]) {
                //System.assertEquals(Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED, match.Participant_Opportunity_Id__r.Operation_Stage__c);
            }
            
            //loop for the matchesForPosition2 and update status with Matched
            for(Match__c match : matchesForPosition2) {
                match.Status__c = Constants.MATCH_STATUS_MATCHED;
            }
            
            //update matchesForPosition1
            update matchesForPosition2;
            
            //assert for the result
            for(Match__c match : [Select Id, Participant_Opportunity_Id__r.Operation_Stage__c from Match__c where Id IN: matchesForPosition2]) {
                //System.assertEquals(Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED, match.Participant_Opportunity_Id__r.Operation_Stage__c);
            }
            
            //assert for the result
            for(Match__c match : [Select Id, Status__c from Match__c where Id IN: matchesForPosition1]) {
                //System.assertEquals(Constants.MATCH_STATUS_WITHDRAWN, match.Status__c);
            }
        }
    }*/
    
    public static Opportunity createMatchBreakOpp(Id mId, Id positionId, List<Engagement__c> matchEngagementLst)
    {
        Opportunity matchBreakOpp = null;
        List<Applicant_Info__c> appInfoList = 
                                [SELECT Id,Opportunity_Name__c,Intrax_Program__c,RecordType.Name,Account__c,Application_Type__c,
                                 name,Intrax_Program_Options__c,Type__c,Intrax_Region__c,Country_of_Interest__c,Intrax_Program_Category__c,
                                 Service_Level__c,Location_of_Interest__c,CreatedBy__c,CreatedById
                                 FROM Applicant_Info__c WHERE Position__c=:positionId
                                 AND  Intrax_Program__c='AuPairCare' 
                                 AND RecordType.Name='AuPairCare HF' 
                                 AND Application_Stage__c = 'Accepted'
                                 AND Application_Level__c = 'Main'
                                 LIMIT 1];
                            if(appInfoList!=null && appInfoList.size()>0){                           
                                matchBreakOpp = AppTriggerHelper.CreateAppOpp(appInfoList[0],appInfoList[0].Opportunity_Name__c,'USD','Match Break');
                            }
        return matchBreakOpp;
    }
    
    public static decimal processServiceCredit(Match__c matchObj, List<Engagement__c> matchEngagementLst,Opportunity matchBreakOpp)
    {
        //Id matchBreakOppId = null;
        decimal serviceCreditAmount=0.0;
        Pricing_Controller pc = new Pricing_Controller();
        pc.match = matchObj;
        pc.engagementObj = matchEngagementLst[0];
        List<OpportunityLineitem> allServiceCredits = new List<OpportunityLineitem>();
        
        System.debug('In processServiceCredit method');
        
        allServiceCredits = pc.getMatchBreakOpportunityProducts('APC USA','Host Family','Match Break',matchBreakOpp);
        if(allServiceCredits!=null && allServiceCredits.size()>0)
        {
            for(OpportunityLineItem item: allServiceCredits)
                serviceCreditAmount = serviceCreditAmount + item.unitPrice;
            
            System.debug('serviceCreditAmount : ' + serviceCreditAmount );
            System.debug('Available service credits : ' + allServiceCredits );
            insert allServiceCredits;
            return serviceCreditAmount;
        }
        else 
        {
            System.debug('No service credits products available');
            return 1;
            
        }
    }
    
    //B-02654 Jose - Creating Opportunity for travel payment
    public static void createChildPtOpp(Id mId, Id engagementId)
    {
        System.debug('createChildPtOpp');
        List<Applicant_Info__c> appInfoList = 
            [SELECT Id,Opportunity_Name__c,Intrax_Program__c,RecordType.Name,Account__c,Application_Type__c,Account__r.Intacct_Sync_By__c,
             name,Intrax_Program_Options__c,Type__c,Intrax_Region__c,Country_of_Interest__c,Intrax_Program_Category__c,
             Service_Level__c,Location_of_Interest__c,CreatedBy__c, CreatedById
             FROM Applicant_Info__c WHERE Engagement__c=:engagementId
             AND  Intrax_Program__c='AuPairCare' 
             AND RecordType.Name='AuPairCare PT' 
             AND Application_Stage__c = 'Accepted'
             AND Application_Level__c = 'Main'
             LIMIT 1];
        if(appInfoList!=null && appInfoList.size()>0)
        {                           
            System.debug('createChildPtOpp of type end of program. applicant details' + appInfoList[0]);
            AppTriggerHelper.CreateAppOpp(appInfoList[0],appInfoList[0].Opportunity_Name__c,'USD','End of program');
            
            //Moved this code to apc_ap_travel_payment page load
            //Now create Intacct PT account and sync it
            /*boolean isIntacctSuccessful = false;
            Intacct_Wrapper intacctWrap = new Intacct_Wrapper();
            if(appInfoList[0].Account__r.Intacct_Sync_By__c==null)
                isIntacctSuccessful = intacctWrap.CreateIntacctAccnt_Sync(appInfoList[0].Account__c);
            else
            {
                //Account already created so just sync it.
                isIntacctSuccessful = intacctWrap.SyncIntacctAccnt(appInfoList[0].Account__c);
            }
            
            if(isIntacctSuccessful)
                System.debug('Intacct participant account successfully created and synced');
            else
                System.debug('Intacct participant account creation and sycn failed.');*/
        }
        
    }
    
    //B-02953 Jose - setting Booking Flight Deadline
    public static void setFlightDeadLine(Id engagementId)
    {
        system.debug('@@@@@setEngagementDeadLine');
        
        List<Engagement__c> engagementList = [SELECT Id,Name, Departure_Request_Deadline__c, Engagement_End__c FROM Engagement__c WHERE Id =:engagementId LIMIT 1];
        
        if(engagementList!=null && engagementList.size()>0){                           
            
            system.debug('@@@@setting booking deadline of Engagement ' + engagementList[0]);
            
            APC_Program_Settings__c dLineAPC = APC_Program_Settings__c.getInstance();
            Integer deadLineAux = 0;
            if(Integer.valueOf(dLineAPC.Return_Travel_Deadline_Days__c) != null){
                deadLineAux = Integer.valueOf(dLineAPC.Return_Travel_Deadline_Days__c);
            }
            
            Date deadLineAPC;
            deadLineAPC = engagementList[0].Engagement_End__c;
            
            if(deadLineAPC != null){
                deadLineAPC = deadLineAPC.addDays(-deadLineAux);
            }
            system.debug('@@@@@deadLineAPC: ' + deadLineAPC);
            engagementList[0].Departure_Request_Deadline__c = deadLineAPC;
            update engagementList[0];
            system.debug('@@@@@after engagement Id ' + engagementList[0].Id + ' updated ');
            
        }else{
            system.debug('@@@@@engagement not found');
        }
        
    }
}