global class Schedulable_Calc_GeoCoords_Acc implements Schedulable{
	global void execute(SchedulableContext sc){
		Batch_Calc_GeoCoords_Acc batch = new Batch_Calc_GeoCoords_Acc();
		Database.executeBatch(batch);
	}
}