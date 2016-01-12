public with sharing class ResourcesController 
{
	/*public list<Document> getWT_Travels()
	{
		list<Document> WTTrvlList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name From Document d WHERE d.Folder.DeveloperName = :'WT_Travels' ORDER BY d.Name ASC];
		system.debug('***Total Documents*****'+WTTrvlList.size());
		return WTTrvlList;
	}*/
	
	public list<Document> DocumentList {get; set;}
	public String[] KeyTags {get;set;}
	public User user {get; set;}
	public map<String, string> KeyTagMapping{get; set;}
	
	public map<ID, string> KeyPhaseMapping{get; set;}
	public string PhaseStr{get; set;}
	public string urlpara{get; set;} 
	//added the following for B-02540:
	public static final String WT_ONLY = 'WT';
	public static final String IGI_ONLY = 'IGI';
	public static final String BOTH_IGI_WT = 'WT_IGI';
	public string HC_User_Resource_Access{get; set;}
	
	
	public void allWTDocuments()
	{
		KeyPhaseMapping = new map<ID, string>();
		PhaseStr = '';
		string DestinationStr = '';
		string WTResourceFolderName = '';
		user = [Select Id, User_Interests__c, ContactId,Type__c,Intrax_Id__c, Contact.Intrax_Programs__c, Contact.AccountId from User where Id =: UserInfo.getUserId()];
		Global_Constants__c ResourceSetting = Global_Constants__c.getInstance();
		
		
		system.debug('before strfoldername******************'+ urlpara);
		
		system.debug('*** getting user access ***');
		HC_User_Resource_Access = getResourceAccessString();
        
		
		list <string> strfoldername = new list<string>();
		
		 if(ApexPages.currentPage().getUrl()!=null)
         {
         	if (ApexPages.currentPage().getParameters().get('program') != NULL)
         	{
         		urlpara = ApexPages.currentPage().getParameters().get('program');
         	}
         	else
         	{
         		urlpara = '';
         	}
         	system.debug('urlpara ***************************'+ urlpara);
         }       
		
		if (user.User_Interests__c == 'Becoming a Work Travel Participant')
		{
			
			WTResourceFolderName = ResourceSetting.Portal_Resource_WT_Participant__c;
			urlpara = 'pt';
			/*strfoldername.add(ResourceSetting.Portal_Resource_WT_Participant__c);
			*/
				system.debug('ResourceSetting.Portal_Resource_WT_Participant__c**************'+ strfoldername);
        
			
		}
		else if (user.User_Interests__c == 'Looking for an intern')
		{
			
			system.debug('Looking for an intern*************************'+ urlpara);
			if (HC_User_Resource_Access == WT_ONLY) urlpara = 'wt';
			else if (HC_User_Resource_Access == IGI_ONLY) urlpara = 'igi';
        
			if (urlpara == 'wt')
			{
				strfoldername.add(ResourceSetting.Portal_Resource_Host_Company__c);
				system.debug('adding Portal_Resource_Host_Company****************************'+ strfoldername);
        
				
			}
			else if (urlpara == 'igi')
			{
				strfoldername.add(ResourceSetting.Portal_Resource_IGI_Host_Company__c);
				system.debug('adding Portal_IGI_Resource_Host_Company***************'+ strfoldername);
        
			}
		//	else
			//{
		//		strfoldername.add(ResourceSetting.Portal_Resource_Host_Company__c);
		//		strfoldername.add(ResourceSetting.Portal_Resource_IGI_Host_Company__c);	
			//	system.debug('adding both************************'+ strfoldername);
        			
			//}
		}
	
		if (user.User_Interests__c == 'Becoming a Work Travel Participant' )
		{
			
				
				DocumentList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name, d.Keywords, d.Description, d.type, d.BodyLength From Document d WHERE d.Folder.DeveloperName = :WTResourceFolderName ORDER BY d.Name ASC];
				
			
				if (DocumentList != NULL && DocumentList.size() > 0 )
				{
					Set<String> KeyTagsSet = new Set<String>();
			    	for (Document doc : DocumentList)
			      		KeyTagsSet.add(doc.Keywords);
			 
					KeyTags = new String[KeyTagsSet.size()];
					
			    	Integer i = 0;
			    	for (String KeyTag : KeyTagsSet) 
			    	{ 
			      		KeyTags[i] = KeyTag;
			      		i++;
			    	}
			    	KeyTags.sort();
			    }
				
			
		}
		if ( user.User_Interests__c == 'Looking for an intern')
		{
			if (strfoldername.size() > 0)
			{
				
				system.debug('DocumentList***********'+ DocumentList);
        	
				DocumentList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name, d.Keywords, d.Description, d.type, d.BodyLength From Document d WHERE d.Folder.DeveloperName IN :strfoldername ORDER BY d.Name ASC];
							
				if (DocumentList != NULL &&  DocumentList.size() > 0)
				{
					Set<String> KeyTagsSet = new Set<String>();
			    	for (Document doc : DocumentList)
			      		KeyTagsSet.add(doc.Keywords);
			 
					KeyTags = new String[KeyTagsSet.size()];
					
			    	Integer i = 0;
			    	for (String KeyTag : KeyTagsSet) 
			    	{ 
			      		KeyTags[i] = KeyTag;
			      		i++;
			    	}
			    	KeyTags.sort();
			    }
				
			}
		}
		
		if (user.User_Interests__c == 'Finding an Internship')
		{
			KeyTagMapping = new map<String, string>();
			list<Applicant_Info__c> applists = [Select ID, Name, Country_of_Interest__c, Engagement__c, Application_Stage__c, Payment_Received__c  From Applicant_Info__c where CreatedBy__c =: UserInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by LastModifiedDate DESC];
			
			if(applists != NULL && applists.size()>0)
			{
				DestinationStr = applists[0].Country_of_Interest__c;
				
				if(applists[0].Engagement__c != NULL)
				{
					list<Match__c> matchInfoList = [SELECT Position_Name__r.Country__c FROM Match__c WHERE Engagement__c = :applists[0].Engagement__c AND Status__c != 'Withdrawn' order by CreatedDate DESC];
					if(matchInfoList != NULL && matchInfoList.size()>0)
					{
						if (matchInfoList[0].Position_Name__r.Country__c != NULL && matchInfoList[0].Position_Name__r.Country__c != '')
						{
							DestinationStr = matchInfoList[0].Position_Name__r.Country__c;
						}
					}
					
				}
			}
			
			if (DestinationStr != '')
			{
				system.debug('Destination is ***'+ DestinationStr);
				DestinationStr = DestinationStr.replaceAll(' ', '');
				system.debug('Updated Destination is ***'+ DestinationStr);
				string FolderNameStr = 'Portal_Resource_IGI_'+DestinationStr;
				//DocumentList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name, d.Keywords, d.Description, d.type, d.BodyLength From Document d WHERE d.Folder.DeveloperName = :FolderNameStr ORDER BY d.Name ASC];
				DocumentList = new list<Document>(); 
				if(applists != NULL && applists.size()>0)
				{
					list<Match__c> confmatchInfoList = new list<Match__c>();
					if(applists[0].Engagement__c != NULL)
					{
						confmatchInfoList = [SELECT Position_Name__r.Country__c, Status__c FROM Match__c WHERE Engagement__c = :applists[0].Engagement__c AND Status__c != 'Withdrawn' order by CreatedDate DESC];
					}
					
					if (confmatchInfoList != NULL && confmatchInfoList.size() > 0 && confmatchInfoList[0].Status__c == 'Confirmed')
					{
						DocumentList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name, d.Keywords, d.Description, d.type, d.BodyLength From Document d WHERE d.Folder.DeveloperName = :FolderNameStr AND (Keywords like 'Phase1|%' OR Keywords like 'Phase2|%' OR Keywords like 'Phase3|%')
						ORDER BY d.Keywords DESC];
						
						PhaseStr = 'Phase3';
					}
					else if (applists[0].Payment_Received__c != NULL && (applists[0].Application_Stage__c == 'Submitted' || applists[0].Application_Stage__c == 'Accepted' || applists[0].Application_Stage__c == 'In-Review'))
					{
						DocumentList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name, d.Keywords, d.Description, d.type, d.BodyLength From Document d WHERE d.Folder.DeveloperName = :FolderNameStr AND (Keywords like 'Phase1|%' OR Keywords like 'Phase2|%')
						ORDER BY d.Keywords DESC];
						
						PhaseStr = 'Phase2';
					}
					else if (applists[0].Payment_Received__c == NULL && (applists[0].Application_Stage__c == 'Submitted' || applists[0].Application_Stage__c == 'Accepted' || applists[0].Application_Stage__c == 'In-Review'))
					{
						DocumentList = [Select d.id, d.Folder.DeveloperName, d.FolderId, d.Name, d.Keywords, d.Description, d.type, d.BodyLength From Document d WHERE d.Folder.DeveloperName = :FolderNameStr AND Keywords like 'Phase1|%'
						ORDER BY d.Keywords DESC];
						
						PhaseStr = 'NoPhase';
					}
				}
				
				
				if (DocumentList.size() > 0)
				{
					List<String> iKey; 
					Set<String> KeyTagsSet = new Set<String>();
			    	for (Document doc : DocumentList)
			    	{
			      		//KeyTagsSet.add(doc.Keywords);
			      		iKey = doc.Keywords.split('\\|');
			      		
			      		if(iKey[0] != NULL)
			      		{
			      			KeyPhaseMapping.put(doc.id, iKey[0]);
			      		}
			      		else
			      		{
			      			KeyPhaseMapping.put(doc.id, 'WrongFormat');
			      		}
			      		
			      		if(iKey[1] != NULL)
			      		{
			      			KeyTagsSet.add(iKey[1]);
			      			KeyTagMapping.put(doc.Keywords, iKey[1]);
			      		}
			      		else
			      		{
			      			KeyTagMapping.put(doc.Keywords, 'WrongFormat');
			      		}
			      		
			    	}
			    	
					KeyTags = new String[KeyTagsSet.size()];
					List<String> individualKey; 
			    	Integer i = 0;
			    	for (String KeyTag : KeyTagsSet) 
			    	{ 
			    		KeyTags[i] = KeyTag;
			    		i++;
			    	}
			    	KeyTags.sort();
			    	
			    	system.debug('****KeyPhaseMapping***'+KeyPhaseMapping);
			    }
			}
		}
		
	}
	//added to support B-02540
	public String getResourceAccessString(){
		if (user.Contact.Intrax_Programs__c != NULL)
		{
		if (user.Contact.Intrax_Programs__c.contains('Internship')){
			if(user.Contact.Intrax_Programs__c.contains('Work Travel')) return BOTH_IGI_WT;
			else return IGI_ONLY;
		}
		else if(user.Contact.Intrax_Programs__c.contains('Work Travel')) return WT_ONLY;
		else return '';
		}
		else return '';
	}
	
	 public PageReference getDocumentUrl()
    {
        string str = '/servlet/servlet.FileDownload?file=' + ApexPages.currentPage().getParameters().get('guid');
        return new PageReference(str);
    }
    
}