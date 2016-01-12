public class OppStageController {
Map<Id,Map<Id,List<Match__c>>> holder = new Map<Id,Map<Id,List<Match__c>>>();
Map<String, Map<String, String>> statCount = new Map<String,Map<String,String>>();
public void loaddata() {
List<Opportunity> wtHCIndOpps = [select Id,(Select Id from Positions__r),LastModifiedDate  from Opportunity where RecordType.Name = 'Work Travel HC' and Service_Level__c = 'Independent' and StageName = 'Closed Won' order by LastModifiedDate desc nulls last limit 100];


Set<Id> allOppIds = new Set<Id>();
Set<Id> allPosIds = new Set<Id>();

for (Opportunity wtHCIndOpp : wtHCIndOpps){
    allOppIds.add(wtHCIndOpp.Id);
    for (Position__c aPos : wtHCIndOpp.Positions__r){
        allPosIds.add(aPos.Id);
    }
}
List<Position__c> allPositions = [select Id,Host_Opportunity_Id__c from Position__c where Host_Opportunity_Id__c in :allOppIds order by Host_Opportunity_Id__c];
List<Match__c> allAssMatches = [select Id,Position_Name__c,Position_Name__r.Host_Opportunity_Id__c from Match__c where Position_Name__c in :allPosIds];

for (Position__c aPos : allPositions){
    if (!holder.containsKey(aPos.Host_Opportunity_Id__c)){
        holder.put(aPos.Host_Opportunity_Id__c,new Map<Id,List<Match__c>>());
        holder.get(aPos.Host_Opportunity_Id__c).put(aPos.Id,new List<Match__c>());
    }
    else{
        holder.get(aPos.Host_Opportunity_Id__c).put(aPos.Id,new List<Match__c>());
    }
}

for (Match__c aMatch : allAssMatches){
    holder.get(aMatch.Position_Name__r.Host_Opportunity_Id__c).get(aMatch.Position_Name__c).add(aMatch);
}

for (Id oppId : holder.keySet()){
    //System.debug(holder.get(oppId));
    statCount.put(oppId,new Map<String,String>());
    statCount.get(oppId).put('PosCount',String.ValueOf(holder.get(oppId).KeySet().size()));
    Integer count = 0;
    for (Id posId: holder.get(oppId).KeySet()){
        count = count+holder.get(oppId).get(posId).size();
    }
    statCount.get(oppId).put('TotalMatches',String.valueOf(count));
    //if (oppId == Id.ValueOf('00613000019pXfZ'))
        System.debug('Opportunity: '+oppId+', No. of Positions and total matches: '+statCount.get(oppId));
}
/*for (Opportunity wtHCIndOpp : wtHCIndOpps){
    List<Position__c> assPositions = wtHCIndOpp.Positions__r;
    List<Match__c> assPosMatches = [select Id from Match__c where Position_Name__c in :assPositions];
    statCount.put(wtHCIndOpp.Id,new Map<String,String>());
    statCount.get(wtHCIndOpp.Id).put('PosCount',String.ValueOf(assPositions.size()));
    statCount.get(wtHCIndOpp.Id).put('TotalMatches',String.ValueOf(assPosMatches.size()));
}*/

//System.debug(statCount);
}
   public Map<String, Map<String, String>> getOppId()
   {
       return statcount;
   }
   public set<string> getoppkey()
   {
       return statcount.keyset();
   }
}