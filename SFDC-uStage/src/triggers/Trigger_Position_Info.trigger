trigger Trigger_Position_Info on Position_Info__c (after update) 
{
	if(Trigger.isAfter) 
	{
		if(trigger.isUpdate)
		{
			set<ID> EnggList = new set<ID>();
			string old_status_val;
			for (Position_Info__c newValues : Trigger.new)
			{
				old_status_val = trigger.oldMap.get(newValues.Id).Status__c;
				if (old_status_val != newValues.Status__c && newValues.Status__c == 'Declined' && newValues.Engagement__c != NULL && newValues.Intrax_Program__c == 'Work Travel' && newValues.Is_Primary_SOA__c == true)
				{
					Engagement__c enggRec = [SELECT ID, Name, Status__c FROM Engagement__c WHERE ID = :newValues.Engagement__c];
					if (enggRec != NULL && enggRec.Status__c == 'On Program')
					{
						EnggList.add(newValues.Engagement__c);
					}
				}
			}
			if(EnggList != null && EnggList.size() > 0)
			{
				Notification_Generator.CreatePrimaryJobNotification(EnggList);
			}
		}
	} 
}