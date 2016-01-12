global class Schedulable_WT_DailyJobs implements Schedulable 
{
	global void execute(SchedulableContext sc)
	{
		Batch_WT_Visa_Status batch = new Batch_WT_Visa_Status();
		Database.executeBatch(batch);
	}
}