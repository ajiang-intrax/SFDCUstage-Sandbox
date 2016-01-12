global class Schedulable_Notification_Reminders implements Schedulable 
{
	global void execute(SchedulableContext sc)
	{
		Batch_Notification_Reminders batch = new Batch_Notification_Reminders();
		Database.executeBatch(batch);
	}
}