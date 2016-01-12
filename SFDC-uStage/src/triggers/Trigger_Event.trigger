trigger Trigger_Event on Event (after insert, after update) {

	if(trigger.isAfter){
		if(trigger.isUpdate){
			try{
				list<Event> eventList = [Select e.WhoId, e.WhatId, e.Type, e.CreatedDate, e.LastModifiedDate,
				e.CreatedById, e.Assigned_To_Orig__c, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e 
					WHERE Id IN: trigger.new];
    	
				for(Event event : eventList){
					if (event.WhatId!=null ){
						
						system.debug('******isUpdate****** event_WhatId=====...' + event.WhatId );
						
						list<Case> caseList = [Select  c.Type,  c.Last_Activity__c,
						 c.Id,  c.CreatedDate, c.CreatedById, c.ContactId, c.ConnectionSentId, c.ConnectionReceivedId, c.Concerned_Citizen__c, 
						   c.ClosedDate,c.AccountId From Case c
		       										WHERE Id=: event.WhatId];
		       			if 	(caseList!=null && caseList.size()>0)
		       			{
		       				caseList[0].Last_Activity__c=event.LastModifiedDate;
		       				update caseList[0];
		       			}						
						
					
						
					}
					
				}
			}catch(Exception e){
				system.debug('******Catch Update event ...');
			}
		}
		if(trigger.IsInsert){
			try{
				list<Event> eventList = [Select e.WhoId, e.WhatId, e.Type, e.CreatedDate, e.LastModifiedDate,
				e.CreatedById, e.Assigned_To_Orig__c, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e 
					WHERE Id IN: trigger.new];
    	
				for(Event event : eventList){
					if (event.WhatId!=null ){
						
						system.debug('******IsInsert****** event_WhatId=====...' + event.WhatId );
						
						list<Case> caseList = [Select  c.Type,  c.Last_Activity__c,
						 c.Id,  c.CreatedDate, c.CreatedById, c.ContactId, c.ConnectionSentId, c.ConnectionReceivedId, c.Concerned_Citizen__c, 
						   c.ClosedDate,c.AccountId From Case c
		       										WHERE Id=: event.WhatId];
		       			if 	(caseList!=null && caseList.size()>0)
		       			{
		       				caseList[0].Last_Activity__c=event.LastModifiedDate;
		       				update caseList[0];
		       			}						
						
					
						
					}
					
				}
			}catch(Exception e){
				system.debug('******Catch Insert event ...');
			}
		}
	
	}

}