global class Schedulable_Daily_IGI_Matches implements Schedulable 
{
	global void execute(SchedulableContext sc)
	{
		Batch_Match_SOAChange Matchbatch = new Batch_Match_SOAChange();
		Database.executeBatch(Matchbatch);
		
	}
}