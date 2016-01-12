global class BGC_Update implements Database.Batchable<sObject> {
	static date dt = date.today();
	public final static Integer BGC_AGE = 17;
	
	
	global Database.Querylocator start (DataBase.BatchableContext BC){
		return DataBase.getQueryLocator([Select  p.Applicant_Info__r.Engagement_Start__c, p.Primary_Applicant__c, 
											p.Date_of_Birth__c, p.Name, p.Background_Check__c, p.Applicant_Info__r.Id,
											p.Applicant_Info__r.Type__c  
											From Person_Info__c p  
											where  p.Applicant_Info__r.Type__c = 'Host Family'
											AND p.Primary_Applicant__c = false
											AND p.Date_of_Birth__c != NULL				
											]);
	}
	
	global void execute(Database.BatchableContext BC, list<Person_Info__c> person){
		List<Task> t = new List<Task>();
		Applicant_Info__c op;
		for( Person_Info__c p: person){
			// Checking if:
			// 		1. The person is already 17 years old.
			//		2. the Engagement Start is before the Birthday
			system.debug('************ DOB: ' + p.Date_of_Birth__c);
			system.debug('************ BGC: ' + p.Background_Check__c);
			
			if(p.Background_Check__c == 'Not Required'){
				system.debug('************ IF 1');
				system.debug('************ DIF ' + ( dt.year() - p.Date_of_Birth__c.year()));
				if((dt.year() - p.Date_of_Birth__c.year()) == BGC_AGE) {
					system.debug('************ IF 2');
					if((p.Applicant_Info__r.Engagement_Start__c.Month() <= p.Date_of_Birth__c.Month()) && (p.Applicant_Info__r.Engagement_Start__c.Day() <= p.Date_of_Birth__c.Day())){
						system.debug('************ IF 3');
						op = [SELECT a.Opportunity_Name__r.OwnerId 
								FROM Applicant_Info__c a 
								WHERE a.Id =: p.Applicant_Info__r.Id 
								LIMIT 1
								];
								
						system.debug('******** op: '+ op.Opportunity_Name__r.OwnerId);
						t.add(new Task(subject = 'Other', 
										description = 'Background Check needed',
										status = 'Not Started', 
										Priority = 'Normal',
										OwnerId = op.Opportunity_Name__r.OwnerId, 
										whatId = op.Id
										));
						p.Background_Check__c = null;
						system.debug('*************** t: ' + t);	
					}
				}
			}
		}
		update person;
		system.debug('****** Accesing here??');
		insert t;
		system.debug('****** Accesing here?? + Task: ' + t);
		
	}	
	
	global void finish(Database.BatchableContext BC){}
}