global class Schedulable_IGI_MC_Assessment implements Schedulable{
    global void execute(SchedulableContext sc){
        Batch_IGI_MC_Assessment batch = new Batch_IGI_MC_Assessment();
        Database.executeBatch(batch,100);
        
    }
}