global class Schedulable_IGI_DailyJobs implements Schedulable 
{
	global void execute(SchedulableContext sc)
	{
		Batch_IGI_Visa_Status batch = new Batch_IGI_Visa_Status();
		Database.executeBatch(batch);
	}
}