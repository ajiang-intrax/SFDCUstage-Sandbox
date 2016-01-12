global class NotificationBatch implements Database.Batchable<sObject>{
	public String taskQuery;
	global final String query;
	global final String objType;
	global NotificationBatch (String inQuery, String inObjType){
		query = inQuery;
		objType = inObjType;
	}
	
	global Database.Querylocator start(Database.BatchableContext BC ){
		List<String> months = Notification_Generator.getMonthList(false);
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope ){
		//do the core work
		//Create Notification record
		if (objType == 'Task'){
			List<Task> taskList = (List<Task>)scope;
			//Notification_Generator ng = new Notification_Generator(taskList);
			//ng.sortTaskBasket();
		}
		else if (objType == 'Match__c'){
			List<Match__c> matchList = (List<Match__c>)scope;
			Notification_Generator ng = new Notification_Generator(matchList);
			ng.processAssessments();
		}
	}
	
	global void finish(Database.BatchableContext BC){
		
	}

}