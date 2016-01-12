global class Schedulable_IGI_MP_Assessment implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_IGI_MP_Assessment batch = new Batch_IGI_MP_Assessment();
		Database.executeBatch(batch);
		
	}
}