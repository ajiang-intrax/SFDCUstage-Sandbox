public class apc_docusign_content_helper 
{
	public string spouseName{get; set;}
	
	public  apc_docusign_content_helper(ApexPages.StandardController controller)
	{
		spouseName = '';
		if (ApexPages.currentPage().getParameters().get('id') != NULL)
		{
			Id URLObjId = ApexPages.currentPage().getParameters().get('id');
			if (URLObjId.getSObjectType() == Applicant_Info__c.sObjectType)
			{
				Applicant_Info__c AggrementApp = (Applicant_Info__c)controller.getRecord();
				//system.debug(AggrementApp.Account__c);
				if(AggrementApp != NULL && AggrementApp.Account__c != NULL)
				{
					list<Member__c> allMembers = [SELECT 	First_Name__c, Last_Name__c FROM Member__c WHERE Account_Name__c =: AggrementApp.Account__c AND (Role__c = 'Spouse or Partner' OR Role__c = 'Spouse')];
					if(allMembers != NULL && allMembers.size() > 0)
					{
						spouseName = allMembers[0].First_Name__c + ' ' + allMembers[0].Last_Name__c;
					}
				}
			}
			else if (URLObjId.getSObjectType() == Match__c.sObjectType)
			{
				Match__c AggrementMatch = (Match__c)controller.getRecord();
				if(AggrementMatch != NULL && AggrementMatch.Position_Name__c != NULL && AggrementMatch.Position_Name__r.Host_Company_Id__c != NULL)
				{
					list<Member__c> allMembers = [SELECT 	First_Name__c, Last_Name__c FROM Member__c WHERE Account_Name__c =: AggrementMatch.Position_Name__r.Host_Company_Id__c AND (Role__c = 'Spouse or Partner' OR Role__c = 'Spouse')];
					if(allMembers != NULL && allMembers.size() > 0)
					{
						spouseName = allMembers[0].First_Name__c + ' ' + allMembers[0].Last_Name__c;
					}
				}
			}
		}
		  
	}
}