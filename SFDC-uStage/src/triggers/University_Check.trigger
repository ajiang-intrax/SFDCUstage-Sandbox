trigger University_Check on University_Event__c (before insert, before update) {
	
   /* if (Trigger.isInsert)
    {
        for (University_Event__C U : Trigger.new) {
            university_Event__C[] uevent = [select University_Name__c from 
            university_event__C where User_ID__c = :U.User_ID__C and  event_date__C = :U.Event_Date__c 
            and Is_Active__c = True and ID != :U.ID
            ];
            if (U.Is_Active__C == True & !uevent.isEmpty())
            {
            //error
            trigger.new[0].addError('Only one University can be active for a user for a given date.');
            }
        }   
    }
    
    if (Trigger.isUpdate)
    {
        for (University_Event__C U : Trigger.new) {
            university_Event__C[] uevent = [select University_Name__c from 
            university_event__C where User_ID__c = :U.User_ID__C and  event_date__C = :U.Event_Date__c 
             and Is_Active__c = True and ID != :U.ID
            ];
            if (U.Is_Active__C == True & !uevent.isEmpty())
            {
            //error
             trigger.new[0].addError('Only one University can be active for a user for a given date.');
            }
        }   
    }*/    
}