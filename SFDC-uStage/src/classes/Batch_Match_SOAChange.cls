global class Batch_Match_SOAChange implements Database.Batchable<sObject>
{
	global Database.queryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator([Select m.Position_Name__c, m.Participant_Id__c,m.Is_Future_SOA__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m 
		                                     where m.Status__c = 'Confirmed' and m.Is_Future_SOA__c = true and m.Intrax_Program__c =: 'Internship'
		                                     AND m.Start_Date__c <= :date.today()
		                                     order by LastModifiedDate DESC]);
		                                           
		                                           
		                                           
	}
	global void execute (Database.BatchableContext BC, list<Match__c> MatchList)
	{
		list<Match__c> UpdList = new list<Match__c>();
		if(MatchList!=null && MatchList.size()>0)
		{
			for (Match__c OneMatch : MatchList)
			{
				
					OneMatch.Is_Primary_SOA__c = true;
					OneMatch.SEVIS_UEV_SOA_Add__c = true;
					OneMatch.Is_Future_SOA__c = false;
					UpdList.add(OneMatch);
				
				
			}
		}
		if (UpdList.size() > 0)
		{
			update UpdList;
		}
	}
	global void finish(Database.BatchableContext BC)
	{
    }

}