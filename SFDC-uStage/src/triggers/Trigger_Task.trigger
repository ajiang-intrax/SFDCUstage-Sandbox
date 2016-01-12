trigger Trigger_Task on Task (after insert, after update) {
	
	
	if(trigger.isAfter){
		if(trigger.isUpdate){
			try{
				list<Task> taskList = [Select t.WhoId, t.WhatId, t.Type,  t.CreatedDate, t.CreatedById,t.ActivityDate,t.LastModifiedDate,t.AccountId From Task t 
		       										WHERE Id IN: trigger.new];
    	
				for(Task task : taskList){
					if (task.WhatId!=null ){
						
						system.debug('******isUpdate****** task_WhatId=====...' + task.WhatId );
						
						list<Case> caseList = [Select  c.Type,  c.Last_Activity__c,
						 c.Id,  c.CreatedDate, c.CreatedById, c.ContactId, c.ConnectionSentId, c.ConnectionReceivedId, c.Concerned_Citizen__c, 
						   c.ClosedDate,c.AccountId From Case c
		       										WHERE Id=: task.WhatId];
		       			if 	(caseList!=null && caseList.size()>0)
		       			{
		       				caseList[0].Last_Activity__c=task.LastModifiedDate;
		       				update caseList[0];
		       			}						
						
					
						
					}
					
				}
			}catch(Exception e){
				system.debug('******Catch Update task ...');
			}
		}
		if(trigger.IsInsert){
			try{
				list<Task> taskList = [Select t.WhoId, t.WhatId, t.Type,  t.CreatedDate, t.CreatedById,t.ActivityDate,t.LastModifiedDate, t.AccountId From Task t 
		       										WHERE Id IN: trigger.new];
    	
				for(Task task : taskList){
					if (task.WhatId!=null ){
						
						system.debug('****** IsInsert********task_WhatId=====...' + task.WhatId );
						
						list<Case> caseList = [Select  c.Type,  c.Last_Activity__c,
						 c.Id,  c.CreatedDate, c.CreatedById, c.ContactId, c.ConnectionSentId, c.ConnectionReceivedId, c.Concerned_Citizen__c, 
						   c.ClosedDate,c.AccountId From Case c
		       										WHERE Id=: task.WhatId];
		       			if 	(caseList!=null && caseList.size()>0)
		       			{
		       				caseList[0].Last_Activity__c=task.LastModifiedDate;
		       				update caseList[0];
		       			}						
						
					
						
					}
					
				}
			}catch(Exception e){
				system.debug('******Catch Insert task ...');
			}
		}
	
	}

}