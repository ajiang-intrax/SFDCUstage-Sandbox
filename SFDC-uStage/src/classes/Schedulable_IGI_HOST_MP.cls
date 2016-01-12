global class Schedulable_IGI_HOST_MP implements Schedulable {
	global void execute(SchedulableContext sc){
		Batch_IGI_HOST_MP_Assessment batch = new Batch_IGI_HOST_MP_Assessment();
		Database.executeBatch(batch);
	}
}