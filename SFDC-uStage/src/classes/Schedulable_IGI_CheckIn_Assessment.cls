global class Schedulable_IGI_CheckIn_Assessment implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_IGI_CheckIn_Assessment batch = new Batch_IGI_CheckIn_Assessment();
		Database.executeBatch(batch);
	}
}