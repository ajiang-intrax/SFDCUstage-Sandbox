public class WTTriggerHelper{

public static boolean skipEngagementafterupdate=false;
public static void OPClosedWon(List<Opportunity> newopp){

       List<Position__c> lstPosition = [Select p.OwnerId,p.Status__c,p.Match_Offer_Status__c,p.Type__c,p.Opportunity_Stage__c, p.RecordTypeId, p.Name, p.Intrax_Program_Options__c, p.Id, p.Host_Opportunity_Id__c From Position__c p where p.Host_Opportunity_Id__c IN :newopp and (p.Status__c='Closed - Filled' or p.Status__c='Matching')];
       List<Position__c> lstPostoupdate = new List<Position__c>();
       system.debug('******op stage updated lstPosition*******'+lstPosition);
        If(lstPosition!=null && lstPosition.size()>0)
         {
             for(Position__c p:lstPosition)
              {  
                p.Opportunity_Stage__c = 'Closed Won';
                lstpostoupdate.add(p);
             
              }
           }
          if(lstpostoupdate!=null && lstpostoupdate.size()>0)
           {
              TriggerExclusion.triggerExclude('Position', true);
              update lstpostoupdate;
              TriggerExclusion.triggerExclude('Position', false);
            }
  if(lstpostoupdate!=null && lstpostoupdate.size()>=1)
    positionMatchUpdate(lstpostoupdate);
 }


public static void positionMatchUpdate(List<Position__c> lstpos)
{ 
   Map<Id, Position__c> mapPos=new Map<Id, Position__c>();
    List<Position__c> lstposOppstage = new List<Position__c>();
    Set<Id> lstposHostOpp = new Set<Id>();
    List<Opportunity> lstOpp= new List<Opportunity>();
    List<Position__c> lstHostPos= new List<Position__c>();
    List<Match__c> lstPosMatchesToBeUpdated = new List<Match__c>();
    List<Engagement__c> lstengtobeupdated = new List<Engagement__c>();
    List<Engagement__c> lstEngupdate = new List<Engagement__c>();
    Set<Id> lstengtoupdate = new Set<Id>();
    Map<Id,List<Engagement__c>> EngPosmap=new Map<Id,List<Engagement__c>>();
    for(Position__c pos:lstpos){
    system.debug('****Inside positionMatchUpdate '+pos.RecordtypeId+' '+pos.Status__c+' '+pos.Match_Offer_Status__c); 
        if(pos.RecordTypeId == Constants.POS_WORK_TRAVEL &&  (pos.Status__c == 'Matching' || pos.Status__c == 'Closed - Filled')  && (pos.Match_Offer_Status__c == 'Offered' || pos.Match_Offer_Status__c == 'Accepted'))
         {
            system.debug('****Inside positionMatchUpdate1');
             if(pos.Opportunity_Stage__c == 'Closed Won')
             {
                system.debug('****Inside positionMatchUpdate2');
               lstposOppstage.add(pos);
             }
             else if(pos.Host_Opportunity_Id__c!=null)
            {
               lstposHostOpp.add(pos.Host_Opportunity_Id__c);
            }
          mapPos.put(pos.Id,pos);
          EngPosmap.put(pos.Id,new List<Engagement__c>());
        }
    }
    if(lstposHostOpp!=null && lstposHostOpp.size()>=1)
    {
         lstOpp=[Select o.OwnerId,(Select Id from Positions__r),o.Id,o.Operation_Stage__c,o.StageName, o.CreatedById From Opportunity o where id in :lstposHostOpp and o.StageName='Closed Won'] ;               
         for(Opportunity itropp:lstOpp)
         {
          for(Position__c posopp:itropp.Positions__r)
          {
             lstHostPos.add(posopp);
          }
        }
    }
    

    List<Match__c> allPosMatches = new List<Match__c>();
    

    if(lstposOppstage!=null && lstposOppstage.size()>=1)
    {
    allPosMatches=[Select m.Status__c,m.Engagement__c,m.Engagement__r.Status__c,m.Engagement__r.Placement_status__c,m.Participant_Opportunity_Id__c,m.RecordTypeId, m.Position_Name__c,m.Position_Name__r.Host_Company_Id__c,m.Offer_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id From Match__c m where  m.Offer_Status__c = 'Offered' and m.RecordTypeId =: Constants.MAT_INTERNSHIP and m.Intrax_Program__c= 'Work Travel' and m.Service_Level__c='Independent' and Position_Name__c in :lstposOppstage];
    }
    if(lstHostPos!=null && lstHostPos.size()>=1)
    {
    allPosMatches=[Select m.Status__c,m.Engagement__c,m.Engagement__r.Status__c,m.Engagement__r.Placement_status__c,m.Engagement__r.OwnerId,m.Participant_Opportunity_Id__c,m.RecordTypeId, m.Position_Name__c,m.Position_Name__r.Host_Company_Id__c,m.Offer_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id From Match__c m where  m.Offer_Status__c = 'Offered' and m.RecordTypeId =: Constants.MAT_INTERNSHIP and m.Intrax_Program__c= 'Work Travel' and m.Service_Level__c='Independent' and Position_Name__c in :lstHostPos];
    }
    for(Match__c m:allPosMatches)
     {
       m.Offer_Status__c='Accepted';
       m.Status__c = 'Confirmed';
       if(m.Host_Account__c != m.Position_Name__r.Host_Company_Id__c)
       {
        m.Host_Account__c = m.Position_Name__r.Host_Company_Id__c;
       }
       lstPosMatchesToBeUpdated.add(m);
   
       lstengtoupdate.add(m.Engagement__c);
   
         
        system.debug('****lstPosMatches m *****'+m);
     }
          
    if(lstPosMatchesToBeUpdated!=null && lstPosMatchesToBeUpdated.size()>0)
     {
        TriggerExclusion.triggerExclude('Match', true);
        update lstPosMatchesToBeUpdated;
        TriggerExclusion.triggerExclude('Match', false);
     }
    if(lstengtoupdate!=null && lstengtoupdate.size()>0)
    {
     lstengtobeupdated =[Select Id,name,(Select Id,name,Position_Name__c from Matches__r),ownerId,Placement_Status__c, Status__c,Opportunity_Id__c from Engagement__c where id in :lstengtoupdate];
    }
    for(Engagement__c eng:lstengtobeupdated)
    {
       for(Match__c mat:eng.Matches__r)
       {
          if(EngPosmap.containsKey(mat.Position_Name__c))
          {
           EngPosMap.get(mat.Position_Name__c).add(eng);
           break;
           }
         }
      }
     system.debug('**EngPosMap size***'+EngPosMap.size());
     system.debug('**EngPosMap***'+EngPosMap);
       for(Id pos:EngPosMap.keyset())
       {
        List<Engagement__c> englist=new List<Engagement__c>();
        englist = EngPosmap.get(pos);
        for(Engagement__c engInfo:englist)
        {        
              engInfo.Placement_status__c='Confirmed';
             // engInfo.Status__c='Program Ready';
              Position__c p=mapPos.get(pos);
              engInfo.OwnerId=p.ownerId;
              system.debug('Engagement to update'+ engInfo.Name);
             lstEngupdate.add(engInfo);
        }
       }
      
       if(lstEngupdate!=null && lstEngupdate.size()>=1)
       {
       TriggerExclusion.triggerExclude('Opportunity', true);
       TriggerExclusion.triggerExclude('Notification', true);
       skipEngagementafterupdate=true;
       update lstEngupdate;
       TriggerExclusion.triggerExclude('Opportunity', false);
       TriggerExclusion.triggerExclude('Notification', false);
       TriggerExclusion.triggerExclude('Engagement', false);
       }
      List<Engagement__c> newUpdateEng = new List<Engagement__c>();
      List<Opportunity> newUpdateEngOpp = new List<Opportunity>();
      List<Opportunity> updateOpplist = new List<Opportunity>();
      Set<Id> oppId=new Set<Id>();
      newUpdateEng=[Select Id, name,Status__c,Opportunity_Id__c from Engagement__c where id in :lstEngupdate];
      if(newUpdateEng!=null && newUpdateEng.size()>0)
      {
       for(Engagement__c newEng:newUpdateEng)
       {
        system.debug('Engagement name + status'+newEng.Name+' '+newEng.Status__c);
        if(newEng.Status__c=='Program Ready')
        {
         oppId.add(newEng.Opportunity_Id__c);
        }
       }
      }
      if(oppId!=null && OppId.size()>0)
      {
       newUpdateEngOpp=[Select id,StageName,Name from Opportunity where id in :OppId]; 
      }
      if(newUpdateEngOpp!=null && newUpdateEngOpp.size()>0)
      {
       for(Opportunity Opp:newUpdateEngOpp)
       {
        if(opp.StageName != 'Program Ready')
        {
         System.debug('Opportunity to update'+opp.name);
         opp.StageName='Closed Won';
         updateOpplist.add(opp);
        }
       }
      }
      if(updateOpplist!=null && updateOpplist.size()>=0)
      {
       TriggerExclusion.triggerExclude('Opportunity', true);
       update updateOpplist;
       TriggerExclusion.triggerExclude('Opportunity', false);
      }
       
    }
    
}