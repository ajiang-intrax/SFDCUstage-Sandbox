global class Schedulable_DepartureTrip implements Schedulable 
{
	global void execute(SchedulableContext sc)
	{
		Batch_WT_DepartureTrip batch = new Batch_WT_DepartureTrip();
		Database.executeBatch(batch);
	}
}