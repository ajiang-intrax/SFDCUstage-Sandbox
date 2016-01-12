global class Schedulable_GeoLocate_Accounts implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_GeoLocate_Accounts batch = new Batch_GeoLocate_Accounts();
		Database.executeBatch(batch);
	}
}