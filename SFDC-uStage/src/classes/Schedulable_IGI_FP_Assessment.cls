global class Schedulable_IGI_FP_Assessment implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_IGI_FP_Assessment batch = new Batch_IGI_FP_Assessment();
		Database.executeBatch(batch);
		
	}
}