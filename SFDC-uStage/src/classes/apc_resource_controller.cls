public with sharing class apc_resource_controller 
{
	public list<Portal_Content__c> allResource{get; set;}
    public map<string, list<Portal_Content__c>> CategoryResourceMap{get; set;}
    public list<string> allCategories{get; set;}
    public map<string, string> CategoryAvailableMap{get; set;}
    public map<string, string> ResourceBodyMap{get; set;}
    public string KeySearch{get;set;}
    public Portal_Content__c ResourceDetail{get; set;}
    
    public list<Portal_Content__c> allCatResLst{get; set;}
    
    public map<string, integer> CategoryResCnt{get;set;} 
    
    public string UserTye{get;set;} 
    
    public string appStage{get;set;}
    
    public list<Portal_Content__c> allQuickLinkLst{get; set;}
    
    
    public apc_resource_controller()
    {
        allResource = new list<Portal_Content__c>();
        CategoryResourceMap = new map<string, list<Portal_Content__c>>();
        allCategories = new list<string>();
        CategoryAvailableMap = new map<string, string>();
        ResourceBodyMap = new map<string, string>();
        allCatResLst = new list<Portal_Content__c>();
        CategoryResCnt = new map<string, integer>();
        UserTye= '';
        appStage = ''; 
        allQuickLinkLst = new list<Portal_Content__c>();
        
        if (userInfo.getUserType() != 'Guest')
        {
	        list<User> UInfoList = [SELECT Id, User_Interests__c, ProfileId, Type__c FROM User WHERE Id =: userInfo.getUserId()];
	        if (UInfoList != NULL && UInfoList.size() > 0)
	        {
	            if (UInfoList[0].User_Interests__c == 'Hosting an au pair')
	            {
	                UserTye = 'Host';
	            }
	            else if (UInfoList[0].User_Interests__c == 'Becoming an au pair')
	            {
	                UserTye = 'Participant';
	            }
	            else if (UInfoList[0].Type__c == 'Partner')
	            {
	                UserTye = 'Partner';
	            }
	            else
	            {
	            	 UserTye = 'All';
	            }
	        }
        }
        
        if( UserTye == 'All' || UserTye == 'Partner' || UserTye == 'Host')
        {
        	appStage = 'ALl';
        }
        
        if (UserTye != '' && UserTye != 'All' && UserTye != 'Partner' && UserTye != 'Host')
        {
        	list<Applicant_Info__c> ApplicantInfoList = [Select a.Engagement__c, a.Position__c, a.Application_Type__c, a.Application_Stage__c, a.Application_Level__c, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c From Applicant_Info__c a
            where a.CreatedBy__c =: UserInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by a.CreatedDate DESC];
            
            if(ApplicantInfoList != NULL && ApplicantInfoList.size() >0)
            {
            	if(ApplicantInfoList[0].Application_Type__c == 'Original' && ApplicantInfoList[0].Application_Stage__c == 'Working')
            	{
            		appStage = 'Applying';
            	}
            	else if (ApplicantInfoList[0].Application_Stage__c == 'Accepted')
            	{
            		if(UserTye == 'Host')
            		{
            			if(ApplicantInfoList[0].Position__c != NULL)
            			{
            				list<Match__c> lstmatch = [SELECT Name, Status__c, Engagement__c, Engagement__r.Status__c, Engagement__r.Engagement_End__c FROM Match__c WHERE Position_Name__c = :ApplicantInfoList[0].Position__c AND Status__c = 'Confirmed' ORDER BY CreatedDate DESC];
            				
            				if(lstmatch != NULL && lstmatch.size() == 0)
            				{
            					appStage = 'Matching';
            				}
            				else
            				{
            					system.debug('lstmatch[0].Engagement__r.Status__c' + lstmatch[0].Engagement__r.Status__c);
            					if(lstmatch[0].Status__c == 'Confirmed' && (lstmatch[0].Engagement__r.Status__c == 'Processing' || lstmatch[0].Engagement__r.Status__c == 'Program Ready'))
            					{
            						appStage = 'Pre-Arrival';
            					}
            					else if (lstmatch[0].Status__c == 'Confirmed' && lstmatch[0].Engagement__r.Status__c == 'On Program')
            					{
            						if (lstmatch[0].Engagement__r.Engagement_End__c != NULL)
            						{
            							if(date.today() > lstmatch[0].Engagement__r.Engagement_End__c - 90)
            							{
            								appStage = 'Pre-Departure';
            							}
            							else appStage = 'On Program';
            						}
            						else
            							appStage = 'On Program';
            					}
            				}
            			}
            		}
            		else if(UserTye == 'Participant')
            		{
            			if(ApplicantInfoList[0].Engagement__c != NULL)
            			{
            				list<Match__c> lstmatch = [SELECT Name, Status__c, Engagement__c, Engagement__r.Status__c, Engagement__r.Engagement_End__c FROM Match__c WHERE Engagement__c = :ApplicantInfoList[0].Engagement__c AND Status__c = 'Confirmed' ORDER BY CreatedDate DESC];
            				
            				if(lstmatch != NULL && lstmatch.size() == 0)
            				{
            					appStage = 'Matching';
            				}
            				else
            				{
            					if(lstmatch[0].Status__c == 'Confirmed' && (lstmatch[0].Engagement__r.Status__c == 'Processing' || lstmatch[0].Engagement__r.Status__c == 'Program Ready'))
            					{
            						appStage = 'Pre-Arrival';
            					}
            					else if (lstmatch[0].Status__c == 'Confirmed' && lstmatch[0].Engagement__r.Status__c == 'On Program')
            					{
            						if (lstmatch[0].Engagement__r.Engagement_End__c != NULL)
            						{
            							if(date.today() > lstmatch[0].Engagement__r.Engagement_End__c - 90)
            							{
            								appStage = 'Pre-Departure';
            							}
            							else appStage = 'On Program';
            						}
            						else
            							appStage = 'On Program';
            					}
            				}
            			}
            		}
            		
            	}
            	else if ((ApplicantInfoList[0].Application_Stage__c == 'Working' || ApplicantInfoList[0].Application_Stage__c == 'Submitted' || ApplicantInfoList[0].Application_Stage__c == 'In-Review') && (ApplicantInfoList[0].Application_Type__c == 'Extension' || ApplicantInfoList[0].Application_Type__c == 'Renewal') )
            	{
            		appStage = 'Matching';
            	}
            }
        }
    }
    
    public void showResources()
    {
    	allResource = new list<Portal_Content__c>();
        CategoryResourceMap = new map<string, list<Portal_Content__c>>();
        allCategories = new list<string>();
        CategoryAvailableMap = new map<string, string>();
        ResourceBodyMap = new map<string, string>();
        CategoryResCnt = new map<string, integer>();
        allQuickLinkLst = new list<Portal_Content__c>();
        
        if (UserTye != '' && appStage != '')
            {
                Schema.DescribeFieldResult fieldResult = Portal_Content__c.Category__c.getDescribe();
                List<Schema.PicklistEntry> pCategories = fieldResult.getPicklistValues();
                list<Portal_Content__c> allResWithoutFilter = new list<Portal_Content__c>();
                
                String SOQLQuery;
                
                SOQLQuery = 'Select p.User_Type__c, p.Urgency__c, p.Type__c, p.Subject__c, p.Status__c, p.Short_Summary__c, p.RegEx__c, p.Record_Type_Name__c, '+
                			+ 'p.Program_Stage__c, p.Object__c, p.Notification_Type__c, p.Name, p.Key__c, p.Intrax_Program__c, p.Id, p.Featured__c, p.FAQ__c, p.CreatedDate,  p.Category__c, p.Body__c From Portal_Content__c p '+
                			+ 'WHERE p.Type__c = \'Resource\' AND p.Intrax_Program__c INCLUDES (\'AuPairCare\') AND p.Status__c = \'Active\' ';
                
                if(UserTye != 'All')
                {
                	SOQLQuery = SOQLQuery + ' AND p.User_Type__c  INCLUDES (' + '\'' + UserTye  + '\'' + ')';
                }
                
                if(appStage != 'All')
                {
                	SOQLQuery = SOQLQuery + ' AND p.Program_Stage__c  INCLUDES (' + '\'' + appStage  + '\'' + ')';
                }
                /*else
                {
                	SOQLQuery = SOQLQuery + ' AND p.Program_Stage__c != NULL ';
                }*/
                
                SOQLQuery = SOQLQuery + ' ORDER BY p.Featured__c DESC';
                
                allResWithoutFilter = Database.query(SOQLQuery);
                
                if (KeySearch == NULL || KeySearch == '')
                {
                	allResource = allResWithoutFilter;                              
                }
                else
                {
                	system.debug('***KeySearch****'+KeySearch);
                	
                    if(allResWithoutFilter != NULL && allResWithoutFilter.size()>0)
                    {
                    	for (Portal_Content__c SinResWithout :allResWithoutFilter)
                    	{
                    		string BodyStr = SinResWithout.body__c.toLowerCase();
                    		string SubjectStr = SinResWithout.Subject__c.toLowerCase();
                    		if(BodyStr.contains(KeySearch.toLowerCase()) || SubjectStr.contains(KeySearch.toLowerCase()))
                    		{
                    			system.debug('***Inside Search Loop****');
                    			allResource.add(SinResWithout);
                    		}
                    	}
                    }
                     
                
                }
                
                
                if(allResource != NULL && allResource.size() > 0)
                {
                    for( Schema.PicklistEntry SingleCat : pCategories)
                    {
                    	integer cnt = 0;
                        allCategories.add(SingleCat.getValue());
                        list<Portal_Content__c> lstRes = new list<Portal_Content__c>();
                        //options.add(new SelectOption(f.getLabel(), f.getValue()));
                        for (Portal_Content__c SingleResorce :allResource)
                        {
                        	if(SingleResorce.Category__c != NULL && SingleResorce.Category__c != '')
                        	{
	                            Set<String> CategoryValues = new Set<String>(SingleResorce.Category__c.split(';'));
	                            for (String str : CategoryValues)
	                            {
	                                if (str == SingleCat.getValue())
	                                {
	                                	//if (cnt < 10)
	                                	//{
	                                    	lstRes.add(SingleResorce);
	                                	//}
	                                	cnt = cnt +1 ;
	                                    if (SingleResorce.Body__c.length() > 400)
	                                    {
	                                    	string strVal = SingleResorce.Body__c.substring(0,400);
	                                    	system.debug('***LastIndex***' + strVal.lastIndexOf(' '));
	                                    	if(strVal.lastIndexOf(' ') != -1)
	                                    	{
	                                        	ResourceBodyMap.put(SingleResorce.Id,strVal.substring(0,strVal.lastIndexOf(' ')));
	                                    	}
	                                    	else
	                                    		ResourceBodyMap.put(SingleResorce.Id,strVal.substring(0,400));
	                                    }
	                                    else
	                                        ResourceBodyMap.put(SingleResorce.Id, SingleResorce.Body__c);
	                                }
	                            }
                        	}
                        }
                        if (lstRes != NULL && lstRes.size()>0)
                        {
                            CategoryResourceMap.put(SingleCat.getValue(),lstRes);
                            CategoryAvailableMap.put(SingleCat.getValue(),'Available');
                        }
                        else
                        {
                            CategoryResourceMap.put(SingleCat.getValue(),new list<Portal_Content__c>());
                            CategoryAvailableMap.put(SingleCat.getValue(),'NotAvailable');
                        }
                        
                        CategoryResCnt.put(SingleCat.getValue(),cnt);
                    }
                }
            }
            
            if (UserTye != '')
            {
            	String QuickLinkSOQLQuery;
                
                QuickLinkSOQLQuery = 'Select p.User_Type__c, p.Urgency__c, p.Type__c, p.Subject__c, p.Status__c, p.Short_Summary__c, p.RegEx__c, p.Record_Type_Name__c, '+
                			+ 'p.Program_Stage__c, p.Object__c, p.Notification_Type__c, p.Name, p.Key__c, p.Intrax_Program__c, p.Id, p.Featured__c, p.FAQ__c, p.CreatedDate,  p.Category__c, p.Body__c From Portal_Content__c p '+
                			+ 'WHERE p.Type__c = \'Resource\' AND p.Intrax_Program__c INCLUDES (\'AuPairCare\') AND p.Status__c = \'Active\' ';
                
                if(UserTye != 'All')
                {
                	QuickLinkSOQLQuery = QuickLinkSOQLQuery + ' AND p.User_Type__c  INCLUDES (' + '\'' + UserTye  + '\'' + ')';
                }
                
                QuickLinkSOQLQuery = QuickLinkSOQLQuery + ' AND p.Program_Stage__c = NULL ';
                
                
                QuickLinkSOQLQuery = QuickLinkSOQLQuery + ' ORDER BY p.Featured__c DESC';
                
                allQuickLinkLst = Database.query(QuickLinkSOQLQuery);
            }
       
    }
    
    public void showResourceDetails()
    {
    	ResourceDetail = new Portal_Content__c();
    	
    	if (ApexPages.currentPage().getParameters().get('cId') != NULL)
    	{
    		list<Portal_Content__c> allResLst = [Select p.User_Type__c, p.Urgency__c, p.Type__c, p.Subject__c, p.Status__c, p.Short_Summary__c, p.RegEx__c, p.Record_Type_Name__c, 
                                p.Program_Stage__c, p.Object__c, p.Notification_Type__c, p.Name,  p.Key__c, p.Intrax_Program__c, p.Id, p.Featured__c, p.FAQ__c, 
                                p.CreatedDate, p.Category__c, p.Body__c From Portal_Content__c p 
                                WHERE Id = :ApexPages.currentPage().getParameters().get('cId')];
            if(allResLst != NULL && allResLst.size() > 0)
            {
            	ResourceDetail = allResLst[0];
            }
    	}
    	else if (ApexPages.currentPage().getParameters().get('cName') != NULL && ApexPages.currentPage().getParameters().get('cName') != '')
    	{
    		list<Portal_Content__c> allResLst = [Select p.User_Type__c, p.Urgency__c, p.Type__c, p.Subject__c, p.Status__c, p.Short_Summary__c, p.RegEx__c, p.Record_Type_Name__c, 
                                p.Program_Stage__c, p.Object__c, p.Notification_Type__c, p.Name,  p.Key__c, p.Intrax_Program__c, p.Id, p.Featured__c, p.FAQ__c, 
                                p.CreatedDate, p.Category__c, p.Body__c From Portal_Content__c p 
                                WHERE p.Name = :ApexPages.currentPage().getParameters().get('cName')];
            if(allResLst != NULL && allResLst.size() > 0)
            {
            	ResourceDetail = allResLst[0];
            }
    	}
    }
    
    public void showCatResourceDetails()
    {
    	allCatResLst = new list<Portal_Content__c>();
    	ResourceBodyMap = new map<string, string>();
    	
    	string searchKey = ApexPages.currentPage().getParameters().get('kSearch');
    	
    	list<Portal_Content__c> allResWithoutFilter = new  list<Portal_Content__c>();
    	
    	if (ApexPages.currentPage().getParameters().get('cat') != NULL)
    	{
    		string categoryStr = ApexPages.currentPage().getParameters().get('cat');
    		
    		String SOQLQuery;
    		//+ ' AND p.Category__c  INCLUDES (' + '\'' + categoryStr  + '\'' + ')';
    		SOQLQuery = 'Select p.User_Type__c, p.Urgency__c, p.Type__c, p.Subject__c, p.Status__c, p.Short_Summary__c, p.RegEx__c, p.Record_Type_Name__c, '+
                			+ 'p.Program_Stage__c, p.Object__c, p.Notification_Type__c, p.Name, p.Key__c, p.Intrax_Program__c, p.Id, p.Featured__c, p.FAQ__c, p.CreatedDate,  p.Category__c, p.Body__c From Portal_Content__c p '+
                			+ 'WHERE p.Type__c = \'Resource\' AND p.Intrax_Program__c INCLUDES (\'AuPairCare\') AND p.Status__c = \'Active\' ' +
                			+ ' AND p.Category__c  = ' + '\'' + categoryStr  + '\'';
            
            if(UserTye != 'All')
            {
              	SOQLQuery = SOQLQuery + ' AND p.User_Type__c  INCLUDES (' + '\'' + UserTye  + '\'' + ')';
            }
            if(appStage != 'All')
            {
            	SOQLQuery = SOQLQuery + ' AND p.Program_Stage__c  INCLUDES (' + '\'' + appStage  + '\'' + ')';
            }
            
    		SOQLQuery = SOQLQuery + ' ORDER BY p.Featured__c DESC';
                
            allResWithoutFilter = Database.query(SOQLQuery);
    		
    		/*if(UserTye == 'All')
    		{
    			allResWithoutFilter = [Select p.User_Type__c, p.Urgency__c, p.Type__c, p.Subject__c, p.Status__c, p.Short_Summary__c, p.RegEx__c, p.Record_Type_Name__c, 
                                p.Program_Stage__c, p.Object__c, p.Notification_Type__c, p.Name,  p.Key__c, p.Intrax_Program__c, p.Id, p.Featured__c, p.FAQ__c, 
                                p.CreatedDate, p.Category__c, p.Body__c From Portal_Content__c p 
                                WHERE p.Type__c = 'Resource' AND p.Intrax_Program__c INCLUDES ('AuPairCare') AND p.Status__c = 'Active' AND p.Category__c INCLUDES (:ApexPages.currentPage().getParameters().get('cat'))  ORDER BY p.Featured__c DESC];
    		}
    		else
    		{
    			allResWithoutFilter = [Select p.User_Type__c, p.Urgency__c, p.Type__c, p.Subject__c, p.Status__c, p.Short_Summary__c, p.RegEx__c, p.Record_Type_Name__c, 
                                p.Program_Stage__c, p.Object__c, p.Notification_Type__c, p.Name,  p.Key__c, p.Intrax_Program__c, p.Id, p.Featured__c, p.FAQ__c, 
                                p.CreatedDate, p.Category__c, p.Body__c From Portal_Content__c p 
                                WHERE p.Type__c = 'Resource' AND p.Intrax_Program__c INCLUDES ('AuPairCare') AND p.User_Type__c INCLUDES (:UserTye) AND p.Status__c = 'Active' AND p.Category__c INCLUDES (:ApexPages.currentPage().getParameters().get('cat'))  ORDER BY p.Featured__c DESC];
    		}*/
    		
    		if (searchKey == NULL || searchKey == '')
    		{
    				allCatResLst = allResWithoutFilter;
    		}	
    		else
    		{
	    		if(allResWithoutFilter != NULL && allResWithoutFilter.size()>0)
	            {
	              	for (Portal_Content__c SinResWithout :allResWithoutFilter)
	               	{
	               		string BodyStr = SinResWithout.body__c.toLowerCase();
	               		string SubjectStr = SinResWithout.Subject__c.toLowerCase();
	               		if(BodyStr.contains(searchKey.toLowerCase()) || SubjectStr.contains(searchKey.toLowerCase()))
	               		{
	               			system.debug('***Inside Search Loop****');
	               			allCatResLst.add(SinResWithout);
	              		}
	               	}
	            }
    		}
    		
    		if(allCatResLst != NULL && allCatResLst.size() > 0)
    		{
    			for (Portal_Content__c SingleResorce : allCatResLst)
    			{
    				if (SingleResorce.Body__c.length() > 400)
	                {
	                   	string strVal = SingleResorce.Body__c.substring(0,400);
	                   	system.debug('***LastIndex***' + strVal.lastIndexOf(' '));
	                   	if(strVal.lastIndexOf(' ') != -1)
	                    {
	                     	ResourceBodyMap.put(SingleResorce.Id,strVal.substring(0,strVal.lastIndexOf(' ')));
	                    }
	                    else
	                    	ResourceBodyMap.put(SingleResorce.Id,strVal.substring(0,400));
	                }
	                else
	                	ResourceBodyMap.put(SingleResorce.Id, SingleResorce.Body__c);
    			}
    		}
    		
    	}
    }
}