global class Schedulable_fetchDISCresult implements Schedulable {
	global void execute(SchedulableContext sc){
		Batch_fetchDISCresult batch = new Batch_fetchDISCresult();
		Database.executeBatch(batch);
	}
}