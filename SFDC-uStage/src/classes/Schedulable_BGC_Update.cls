global class Schedulable_BGC_Update implements Schedulable {
	global void execute(SchedulableContext sc){
		BGC_Update batch = new BGC_Update();
		Database.executeBatch(batch);
	}
}