global class Schedulable_Notifications_APC implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        Batch_Notifications_APC batch1 = new Batch_Notifications_APC();
        Batch_Notifications_APC_AcceptedApp24Hrs batch2 = new Batch_Notifications_APC_AcceptedApp24Hrs();
        Batch_Notifications_APC_AcceptedApp48Hrs batch3 = new Batch_Notifications_APC_AcceptedApp48Hrs();
      
        Batch_Notifications_APC_PTAppCreated batch4 = new Batch_Notifications_APC_PTAppCreated();
        Batch_Notifications_APC_EngPlanForDep batch5 = new Batch_Notifications_APC_EngPlanForDep();
        
        Database.executeBatch(batch1,10);
        Database.executeBatch(batch2,10);
        Database.executeBatch(batch3,10);

        Database.executeBatch(batch4,10);

        Database.executeBatch(batch5,10);
        
    }
}