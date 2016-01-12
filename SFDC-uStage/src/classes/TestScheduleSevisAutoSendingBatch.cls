@isTest
public with sharing class TestScheduleSevisAutoSendingBatch {
	 public static CronTrigger fetchCronTrigger(String jobId) {
		return [
			select CronExpression,
			TimesTriggered,
			NextFireTime
			from CronTrigger
			where Id = :jobId
			];
	}

 	static testMethod void testScheduledSevis() {

		Test.startTest();
		String CRON_EXP = '0 30 7,8,9,10,11,12,13,14,15,16,17,18 * * ? *';
		ScheduleSevisAutoSendingBatch.scheduleIt();
		String jobId = System.schedule('Test Schedule Sevis Batch: 001',CRON_EXP,new ScheduleSevisAutoSendingBatch());
		CronTrigger ct = fetchCronTrigger(jobId);
		System.assertEquals(CRON_EXP, ct.CronExpression, 'Did not get the same Cron Expression back');
		System.assertEquals(0, ct.TimesTriggered, 'The job has been run and should not have');
 		Test.stopTest();
	}
}