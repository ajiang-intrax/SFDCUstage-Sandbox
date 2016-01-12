global class Schedulable_ShareHCPortalUsers implements Schedulable {
	global void execute(SchedulableContext sc){
		ShareHCPortalUsers batch = new ShareHCPortalUsers();
		Database.executeBatch(batch);
	}
}