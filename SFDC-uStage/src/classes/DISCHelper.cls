public class DISCHelper 
{
	public Applicant_Info__c appdetails{get;set;}
	public string DISCResultMessage{get; set;}
	public list<DISC__c> lstDISCRecord;
	
	public DISC__c DISCRecord{get; set;}
	
	public DISCHelper()
	{
		appdetails = new Applicant_Info__c();
		DISCRecord = new DISC__c();
		DISCResultMessage = '';
		if (System.currentPageReference().getParameters().get('id') != NULL)
		{
			appdetails = [SELECT ID, Name,CreatedBy__c, Account__c,PageStatus_Started__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE ID =: System.currentPageReference().getParameters().get('id')];
			
			lstDISCRecord = [SELECT ID, Name, AppID__c,Point_System_Result__c, Report_URL__c, Test_Completion_DateTime__c FROM DISC__C WHERE AppID__c = : System.currentPageReference().getParameters().get('id')];
			
			if(lstDISCRecord != NULL && lstDISCRecord.size() > 0)
			{
				DISCRecord = lstDISCRecord[0];
			}
		}
	}
	
	/*public PageReference PageStatus()
	{
		if (System.currentPageReference().getParameters().get('id') != NULL && appdetails != NULL)
		{	
			Applicant_Info__c appupdate = [SELECT ID, Name,CreatedBy__c, Account__c,PageStatus_Started__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE ID =: System.currentPageReference().getParameters().get('id')];
			
			if(!(appupdate.PageStatus_Started__c.contains('31')) )
			{
				if(appupdate.PageStatus_Started__c != null && appupdate.PageStatus_Started__c != '')
				{
					appupdate.PageStatus_Started__c = appupdate.PageStatus_Started__c + ';31'; 
                }
                else
                {
                	appupdate.PageStatus_Started__c = '31'; 
                }
                update appupdate;
            }
            
            if(appupdate.PageStatus_Complete__c.contains('039'))
            {
            	string RedURL = '/apex/apc_ap_main_agreements?id=' + appupdate.ID;
				PageReference DISCHomePage =new PageReference(RedURL);
				DISCHomePage.setRedirect(true);
				return DISCHomePage; 
            }
            else
            {
            	string RedURL = '/apex/apc_ap_main_disc?id=' + appupdate.ID;
				PageReference DISCHomePage =new PageReference(RedURL);
				DISCHomePage.setRedirect(true);
				return DISCHomePage; 
            }
		}
		else return null;
	}
	*/
	public PageReference RegisterDISCUser() 
	{
		Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
		
		if (System.currentPageReference().getParameters().get('id') != NULL)
		{
			system.debug('***appdetails***'+appdetails);
			//string AppID = System.currentPageReference().getParameters().get('id');
			//Applicant_Info__c appdetails = [SELECT ID, Name,CreatedBy__c, Account__c FROM Applicant_Info__c WHERE ID =: AppID];
			
			list<DISC__c> ExistDISCRec = [SELECT Name, AppID__c FROM DISC__c WHERE AppID__c = :appdetails.ID];
			if (ExistDISCRec != NULL && ExistDISCRec.size() == 0)
			{
				if (appdetails.Account__c != NULL)
				{
					Account pAccountDetails = [SELECT FirstName,LastName, PersonEmail FROM Account WHERE ID = :appdetails.Account__c];
					
					try
					{
						DISCHandler DH = new DISCHandler();
						boolean RegisterResult = DH.registerUser(appdetails.ID, pAccountDetails.FirstName, pAccountDetails.LastName, pAccountDetails.PersonEmail);
						if (RegisterResult)
						{
							lstDISCRecord = [SELECT ID, Name, AppID__c,Point_System_Result__c, Report_URL__c, Test_Completion_DateTime__c FROM DISC__C WHERE AppID__c = : appdetails.ID];
			
							if(lstDISCRecord != NULL && lstDISCRecord.size() > 0)
							{
								DISCRecord = lstDISCRecord[0];
							}
							string URLStr = BaseURLsettings.DISC_URL__c + 'home/' + appdetails.ID;
							PageReference DISCTestLink=new PageReference(URLStr);
				      		DISCTestLink.setRedirect(true);
				      		return DISCTestLink;
						}
						else return null;
					}
					catch(Exception ex)
					{
			    		return null;
					}	
				}
				else return null;
			}
			else
			{
				//string URLStr = 'http://apc.prfwebsite.com/home/' + appdetails.Id;
				string URLStr = BaseURLsettings.DISC_URL__c + 'home/' + appdetails.ID;
				PageReference DISCTestLink=new PageReference(URLStr);
				DISCTestLink.setRedirect(true);
				return DISCTestLink;
			}
		}
		else return null;
		
	}
	
	public PageReference FetchDISCResult() 
	//public void FetchDISCResult() 
	{
		system.debug('***appdetails***'+appdetails);
		if (System.currentPageReference().getParameters().get('id') != NULL)
		{
			DISCHandler DH = new DISCHandler();
			DISCResultMessage = DH.onDemandfetchdata(appdetails.ID);
			system.debug('DISCResultMessage' + DISCResultMessage);
			
			lstDISCRecord = [SELECT ID, Name, AppID__c, Point_System_Result__c, Report_URL__c, Test_Completion_DateTime__c FROM DISC__C WHERE AppID__c = : appdetails.ID];
			
			if(lstDISCRecord != NULL && lstDISCRecord.size() > 0)
			{
				DISCRecord = lstDISCRecord[0];
				if (DISCRecord.Point_System_Result__c == NULL || DISCRecord.Point_System_Result__c == '' || DISCRecord.Point_System_Result__c == 'Retake')
				{
					return null;
				}
				else
				{
					string DSURL = '/apex/apc_ap_main_agreements?id=' + appdetails.ID;
					PageReference AgreementPage =new PageReference(DSURL);
					AgreementPage.setRedirect(true);
					return AgreementPage;
				}
			}
			else return null;
		}
		else return null;
	}
	
	
	/*public static void ResetDISCUser()
	{
		string AppID = System.currentPageReference().getParameters().get('id');
				
		try
		{
			DISCHandler DH = new DISCHandler();
			DH.candidateReset(AppID);
		}
		catch(Exception ex)
		{
    		system.debug(ex);
		}	
	}*/
}