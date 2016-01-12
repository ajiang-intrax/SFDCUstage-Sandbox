global class Schedulable_Batch_Oppty_Email_Attachment implements Schedulable {
	global void execute(SchedulableContext sc){
		Batch_Oppty_Email_Attachment_Generator batch = new Batch_Oppty_Email_Attachment_Generator();
		Database.executeBatch(batch,10);
	}
}