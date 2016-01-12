global class ScheduleSevisAutoSendingBatch implements Schedulable {
	/**
	* To schedule this batch:
	* NOTE: It should run from 7:30am to 18:30pm hourly, but if you make
	* changes and need to requeue run the command below from the developer's console
	*
	* ScheduleSevisAutoSendingBatch.scheduleIt();
	*/
	/*
	* comment it out because system admin wants set the batch time on the fly
	public static String CRON_EXP = '0 30 7,8,9,10,11,12,13,14,15,16,17,18 * * ? *';
	*/
	
	/* the batch transaction cannot exceed the governal limites. since each Sevis engagment process takes over 20 SOQLs
	*  in order to make sure the transaction can go through successfully, we inlcude only 6 EVs per transaction
	 */ 
	global void execute(SchedulableContext sc) {
		SevisAutoSendingBatch  myBatch = new SevisAutoSendingBatch();
		Id jobId = Database.executeBatch(myBatch, 6);
		System.debug('*************************************Done Schedule Sevis Batch Apex job:  ' + jobId); 
	}
	
	
	 /**
	* Static method used to schedule this task
	*
	* @return The jobId from the scheduled run
	*
	* This method currently is only called from test class
	*/
	global static String scheduleIt() {
		String CRON_EXP = '0 30 7,8,9,10,11,12,13,14,15,16,17,18 * * ? *';
		ScheduleSevisAutoSendingBatch sBatch = new ScheduleSevisAutoSendingBatch();
		return System.schedule('Sevis Auto Sending Batch', CRON_EXP, sBatch);
	}
 
}