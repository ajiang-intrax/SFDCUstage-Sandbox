global class Schedulable_SkylinkDataProcessing implements Schedulable {
	global void execute(SchedulableContext sc){
		Batch_SkylinkDataProcessing batch = new Batch_SkylinkDataProcessing();
		Database.executeBatch(batch);
	}
}