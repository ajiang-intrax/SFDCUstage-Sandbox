global class Schedulable_BGC_NotifyMembers implements Schedulable {
	global void execute(SchedulableContext sc){
		Batch_BGC_NotifyMembers batch = new Batch_BGC_NotifyMembers();
		Database.executeBatch(batch);
	}
}