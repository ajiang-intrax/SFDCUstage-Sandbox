global class Schedulable_Calc_GeoCoords_AccSites implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_Calc_GeoCoords_AccSites batch = new Batch_Calc_GeoCoords_AccSites();
		Database.executeBatch(batch);
	}
}