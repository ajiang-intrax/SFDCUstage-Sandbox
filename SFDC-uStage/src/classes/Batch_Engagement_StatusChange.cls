global class Batch_Engagement_StatusChange implements Database.Batchable<sObject>
{
	global Database.queryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator([SELECT Id, Status__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c FROM Engagement__c
		                                            WHERE (Intrax_Program__c =: 'Ayusa' OR Intrax_Program__c =: 'Work Travel' OR Intrax_Program__c =: 'Internship' OR Intrax_Program__c =: 'AuPairCare') 
		                                            AND ((Engagement_Start__c <= :date.today() AND Status__c =: 'Program Ready')
		                                            OR (Engagement_End__c <= :date.today() AND Status__c =: 'On Program'))]);
		                                           
		                                           
		                                           // AND (((Engagement_Start__c = :date.today() OR Engagement_Start__c = :(date.today()-1)) AND Status__c =: 'Program Ready')
		                                           // OR ((Engagement_End__c = :date.today() OR Engagement_End__c = :(date.today()-1)) AND Status__c =: 'On Program'))]);
		                                           // AND (Status__c =: 'Program Ready' OR Status__c =: 'On Program')
		                                            //AND (Engagement_Start__c = :date.today() OR Engagement_End__c = :date.today())]);	
	}
	global void execute (Database.BatchableContext BC, list<Engagement__c> EnggList)
	{
		list<Engagement__c> UpdEnggList = new list<Engagement__c>();
		if(EnggList!=null && EnggList.size()>0)
		{
			for (Engagement__c OneEngg : EnggList)
			{
				//if (OneEngg.Engagement_Start__c == date.today() && OneEngg.Status__c == 'Program Ready')
				if (OneEngg.Status__c == 'Program Ready' && OneEngg.Engagement_Start__c <= date.today() && (OneEngg.Intrax_Program__c == 'Ayusa' || OneEngg.Intrax_Program__c == 'AuPairCare'))
				{
					OneEngg.Status__c = 'On Program';
					UpdEnggList.add(OneEngg);
				}
				//else if (OneEngg.Engagement_End__c == date.today() && OneEngg.Status__c == 'On Program')
				else if (OneEngg.Status__c == 'On Program'  && OneEngg.Engagement_End__c < date.today() && (OneEngg.Intrax_Program__c == 'Ayusa' || OneEngg.Intrax_Program__c == 'Work Travel' || OneEngg.Intrax_Program__c == 'Internship' || OneEngg.Intrax_Program__c == 'AuPairCare'))
				{
					OneEngg.Status__c = 'Program Complete';
					UpdEnggList.add(OneEngg);
				}
			}
		}
		if (UpdEnggList.size() > 0)
		{
			update UpdEnggList;
		}
	}
	global void finish(Database.BatchableContext BC)
	{
    }
}