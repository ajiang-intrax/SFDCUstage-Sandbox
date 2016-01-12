global class Schedulable_GeoLocate_accSites implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_GeoLocate_AccSites batch = new Batch_GeoLocate_AccSites();
		Database.executeBatch(batch);
	}
}