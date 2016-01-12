global class Schedulable_IGI_HOST_FP implements Schedulable {
	global void execute(SchedulableContext sc){
		Batch_IGI_HOST_FP_Assessment batch = new Batch_IGI_HOST_FP_Assessment();
		Database.executeBatch(batch,10);
	}
}