/*
    Purpose         :   Helper class for Trigger_Position.
                
    Created Date    :   03/19/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
                        V_1.2 - 08/23/2012 - Modified - Story 2098
*/
public with sharing class PositionTriggerHelper {

    //Start Pay Event B-02402    
    public static boolean firstRun = true; //Limit Trigger execution to 1 pass per transaction

    //@future
    public static void logOwnership(List<Id> positionIds){
        //Get Matches related to all Positions
        List<Position__c> positions = [SELECT Id, Name, OwnerId FROM Position__c WHERE Id in :positionIds];
        Map<Id, Position__c> mpos = New Map<Id, Position__c>(positions);
        List<Match__c> matches = [SELECT Id, Name, Position_Name__c FROM Match__c WHERE Position_Name__c in :positionIds ORDER BY Position_Name__c];
        //Now create new MOH instances for each updating APC Position Owner instance
        List<Match_Owner_History__c> matchOwnerHistories = New List<Match_Owner_History__c>();
        for(Match__c m : matches){
            Match_Owner_History__c moh = New Match_Owner_History__c();
            moh.Match__c = m.Id;
            moh.Start_Date__c = Date.today();
            moh.Match_Owner__c = mpos.get(m.Position_Name__c).OwnerId;
            moh.Changed_By__c = UserInfo.getUserId();
            system.debug('@@@@@insidelogOwnership');
            if(mpos.get(m.Position_Name__c).OwnerId.getSObjectType().getDescribe().getName() == 'User'){
                matchOwnerHistories.add(moh);
            }
        }
        insert matchOwnerHistories;
    }
    //End Pay Event B-02402 
    
    /**
    * Description   :   This method checks if the status of position record is "Closed - Filled", then update the related opportunity OperationStage to Matched.
    * @args         :   List of positions
    * @return       :   void
    */
    public static void updateOpportunityOperationStageByPositionStatus(List<Position__c> positions) {
        
        //property to hold positions related opportunities id
        //Set<Id> oppIds = new Set<Id>();
        Set<Id> posIds = new Set<Id>();
        //Property to hold the other matches records need to be updated
        List<Match__c> matchesToBeUpdated = new List<Match__c>();
        
        //loop through the positions and get the related opportunity id
        /*for(Position__c position : positions) {
            if(position.Host_Opportunity_Id__c != null && position.Status__c == Constants.POSITION_STATUS_CLOSED_FILLED) {
                
                //add opportunity id in set 
                oppIds.add(position.Host_Opportunity_Id__c);
            }
        } 
        
        //Create a map to hold the opportunity data from database
        Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>([Select Id, Operation_Stage__c from Opportunity where Id IN : oppIds]);
        
        //Create a list of opportunity records to be updated
        List<Opportunity> opportunitiesToBeUpdated = new List<Opportunity>();*/
        
        //loop through the positions agian and update the related opportunity  if needed
        for(Position__c position : positions) {
/*          if(position.Host_Opportunity_Id__c != null && position.Status__c == Constants.POSITION_STATUS_CLOSED_FILLED
                && mapOpportunities.containsKey(position.Host_Opportunity_Id__c) 
                && mapOpportunities.get(position.Host_Opportunity_Id__c).Operation_Stage__c != Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED) {
                    
                    //update the Operation_Stage__c field and add in the list to be updated
                    mapOpportunities.get(position.Host_Opportunity_Id__c).Operation_Stage__c = Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED;
                    opportunitiesToBeUpdated.add(mapOpportunities.get(position.Host_Opportunity_Id__c));
                    
            }*/
            if(position.Host_Opportunity_Id__c != null //&& position.Status__c == Constants.POSITION_STATUS_CLOSED_FILLED
                && position.Positions_Sold__c == position.Matched_Count__c )
            {
                posIds.add(position.Id);    
            }           
        }
        
        //perform the DML operation only if required
        //if(opportunitiesToBeUpdated.size() > 0)
            //update opportunitiesToBeUpdated;
            
        if (posIds.size() > 0){
            
            //Query match object to find out all other match with post-match status
            for(Match__c match : [Select Id, Status__c, Interview_Date__c from Match__c 
                                    where 
                                     Position_Name__c IN: posIds
                                    AND Status__c NOT IN : Constants.MATCH_POST_MATCH_VALUES
                                    ]) {
                
                //Check for updating the status only is match status is "Assigned" or "Interview Pending" and interview date is in future - Story 2098
                /* Commented out due to MT 140
                if(Constants.MATCH_STATUS_ASSIGNED.equalsIgnoreCase(match.Status__c) 
                    || (Constants.MATCH_STATUS_INTERVIEW_PENDING.equalsIgnoreCase(match.Status__c)
                        && match.Interview_Date__c > DateTime.now())) {
                    
                    //update the status of the macth status to Withdrawn and add in the list to be updated
                    match.Status__c = Constants.MATCH_STATUS_WITHDRAWN;
                    matchesToBeUpdated.add(match);
                }*/
                
                if((match.Status__c == 'Saved' || match.Status__c == 'Applied' || match.Status__c == 'Recommended' || match.Status__c == 'Requested')){
                    match.Status__c = Constants.MATCH_STATUS_WITHDRAWN;
                    matchesToBeUpdated.add(match);
                }
                
            }           
        }
        
        if(matchesToBeUpdated.size() > 0)
            update matchesToBeUpdated;          
    }
    //B-03457
    public static void setNewHostAccount(list<Position__c> po,map<Id, Position__c> mapPosition){
       set<ID> setpid = new set<ID>();
       List<Match__c> matlist = new List<Match__c>();
       List<Match__c> updateMatlist = new List<Match__c>();
       for(Position__c p: po)
        {
          //if(p.Intrax_Program__c != 'AuPairCare')
            //{
             setpid.add(p.Id);
            //}
         }
      if(setpid!=null)
      { 
       matlist = [Select id,name,Position_Name__c,Host_Account__c,Position_HostCompany__c from Match__c where Position_Name__c IN:setpid];
      } 
   if(matlist!=null && matlist.size()>0){  
     for(Position__c itrPos : po){
      Position__c oldPos = new Position__c();
       if(mapPosition != null){
       oldPos = mapPosition.get(itrPos.Id);
      }
      if(itrPos.Host_Company_Id__c != oldPos.Host_Company_Id__c) //&& itrPos.Intrax_Program__c !='AuPairCare'
       {
        for(Match__c m:matlist)
        {  
         if((m.Position_Name__c == itrPos.Id)&& m.Host_Account__c != null && m.Position_HostCompany__c != null)
         {
          m.Host_Account__c = m.Position_HostCompany__c;
          updateMatlist.add(m);
         }
        }
      } 
    } 
   } 
    if(updateMatlist!=null && updateMatlist.size()>0)
      {
       TriggerExclusion.triggerExclude('Match', true);
       update updateMatlist;
       TriggerExclusion.triggerExclude('Match', false);
      } 
   
    }
    //B-03457
    
    
    static testMethod void testUpdateOpportunityOperationStageByPositionStatus() {
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0) {
            //Create test data
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
            insert hostOpportunity;
            
            //Create the list of position to test the Bulk scenerio
            List<Position__c> positions = new List<Position__c>();
            
            
            //Create 20 records in bulk 
            for(Integer i = 0; i< 2; i++) {
                //Insert Position Instance
                positions.add(new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                        Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3, Status__c = 'Test'));
            }
            
            //Start test from
            Test.startTest();
            
            //insert data in bulk
            insert positions;
            
            //Match__c m = new Match__c(Name = 'Test', Participant_Id__c = hostCompany.Id, Participant_Opportunity_Id__c = hostOpportunity.Id, Position_Name__c = positions[0].Id, Status__c = 'Saved');
            Match__c m1 = new Match__c(Name = 'Test', Participant_Id__c = hostCompany.Id, Participant_Opportunity_Id__c = hostOpportunity.Id, Position_Name__c = positions[0].Id, Status__c = 'Saved');
            
            System.assertEquals(positions[0].Positions_Sold__c, positions[0].Matched_Count__c);            

            PositionTriggerHelper p = new PositionTriggerHelper();
            PositionTriggerHelper.updateOpportunityOperationStageByPositionStatus(positions);
            //assert result
            List<Opportunity> opportunities = [Select Id, Operation_Stage__c from Opportunity where Id =: hostOpportunity.Id];
            
            //check for the size
            if(opportunities.size() > 0) {
                System.assert(opportunities[0].Operation_Stage__c == null || opportunities[0].Operation_Stage__c == '');
            }
            
            //Create 20 records in bulk 
            for(Position__c position : positions) {
                //Insert Position Instance
                position.Status__c = Constants.POSITION_STATUS_CLOSED_FILLED;
            }
            
            //update records
            update positions;
            
            //assert result
            opportunities = [Select Id, Operation_Stage__c from Opportunity where Id =: hostOpportunity.Id];
            
            //assert result
            if(opportunities.size() > 0) {
                //System.assertEquals(Constants.OPPORTUNITY_OPERATIONAL_STAGE_MATCHED, opportunities[0].Operation_Stage__c);
            }
            
            //stop test here
            Test.stopTest();
        }
    }   
}