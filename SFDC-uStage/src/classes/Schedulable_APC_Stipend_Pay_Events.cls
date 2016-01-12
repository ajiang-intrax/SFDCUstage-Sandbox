global class Schedulable_APC_Stipend_Pay_Events implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_APC_Stipend_Pay_Events batch = new Batch_APC_Stipend_Pay_Events();
		Database.executeBatch(batch);
	}
}