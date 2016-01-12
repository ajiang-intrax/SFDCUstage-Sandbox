global class Schedulable_WT_CheckIn_Assessment implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_WT_CheckIn_Assessment batch = new Batch_WT_CheckIn_Assessment();
		Database.executeBatch(batch);
	}
}