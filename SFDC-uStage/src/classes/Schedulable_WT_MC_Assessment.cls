global class Schedulable_WT_MC_Assessment implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_WT_MC_Assessment batch = new Batch_WT_MC_Assessment();
		Database.executeBatch(batch);
	}
}