global class Schedulable_Notifications_APC_Match implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
       
        Batch_Notifications_APC_MatchChecklist batch1 = new Batch_Notifications_APC_MatchChecklist();
        Batch_Notifications_APC_MatchPreDeplist batch2 = new Batch_Notifications_APC_MatchPreDeplist();
    
        Batch_Notifications_APC_HFAccApp24Hrs batch3 = new Batch_Notifications_APC_HFAccApp24Hrs();
        Batch_Notifications_APC_HFAccApp48Hrs batch4 = new Batch_Notifications_APC_HFAccApp48Hrs();
    
        Database.executeBatch(batch1,10);
        Database.executeBatch(batch2,10);
    
        Database.executeBatch(batch3,10);
        Database.executeBatch(batch4,10);
      
        
    }
}