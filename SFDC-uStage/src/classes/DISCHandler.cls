public class DISCHandler 
{
	public list<CandidateInfo> fetchedCandidates; 
	public string DISCMessage;
	
	public map<string,CandidateInfo> CandidateMaps;
	
	public DISCHandler()
	{
		fetchedCandidates = new list<CandidateInfo>();
		DISCMessage = '';
		
		CandidateMaps = new map<string,CandidateInfo>();
	}
		
	public void batchfetchdata()
	{
		try
		{
			string KeyValue = '';
			Application_Constants__c appconstant = Application_Constants__c.getInstance('DISC_FetchData');
        	KeyValue=appconstant.Value__c;
			
			DISCWebService disc = new DISCWebService();
			DISCWebService.fetchDataRequest_element fetchData = new DISCWebService.fetchDataRequest_element();
			DISCWebService.PersonalityTestWebServiceAccessPointPort discPort = new DISCWebService.PersonalityTestWebServiceAccessPointPort();
			
			String discFetchData = '';
			
			if(!Test.isRunningTest()) 
			{
				system.debug('Running for not test classes');
				discFetchData = discPort.fetchData(KeyValue,'{"return":"ALL"}');
			}
			else
			{
				system.debug('Running for test classes');
				discFetchData = discPort.fetchData(KeyValue,'{"fromDateTime":"2013-02-01 04:38:26","toDateTime":"2014-02-02 04:38:26"}');
			}
			
			system.debug('***discFetchData***'+discFetchData); 
			
			list<CandidateInfo> fetchedCandidates = read(discFetchData);
			system.debug('***Fetched data size***'+fetchedCandidates.size());
			system.debug('***Fetched data are***'+fetchedCandidates);
			if(fetchedCandidates != null && fetchedCandidates.size() > 0)
			{
				for(CandidateInfo cInfo : fetchedCandidates)
				{
					system.debug('***Candidate ID***'+cinfo.CandidateID);
					system.debug('***Candidate DScore***'+cinfo.DScore);
					CandidateMaps.put(cinfo.CandidateID,cInfo);
				}
				
				if (CandidateMaps.size() > 0)
				{
					updateDISCRecord(CandidateMaps);
				}
			}
		}
		catch(Exception ex)
		{
    		System.debug(ex);
		}
		
	}
	
	public string onDemandfetchdata(string APId)
	{
		try
		{
			string KeyValue = '';
			Application_Constants__c appconstant = Application_Constants__c.getInstance('DISC_FetchData');
        	KeyValue=appconstant.Value__c;
			
			DISCWebService disc = new DISCWebService();
			DISCWebService.fetchDataRequest_element fetchData = new DISCWebService.fetchDataRequest_element();
			DISCWebService.PersonalityTestWebServiceAccessPointPort discPort = new DISCWebService.PersonalityTestWebServiceAccessPointPort();
			
			if (APId != NULL)
			{
				String InputValue = '{"candidateID":"'  + APId + '"}';
				String discFetchData = discPort.fetchData(KeyValue,InputValue);
				//discFetchData = discFetchData.replace('&', '&amp;');
				//system.debug('***discFetchData***'+discFetchData);
				
				list<CandidateInfo> fetchedCandidates = read(discFetchData);
				system.debug('***Fetched data size***'+fetchedCandidates.size());
				system.debug('***Fetched data are***'+fetchedCandidates);
				if(fetchedCandidates != null && fetchedCandidates.size() > 0)
				{
					for(CandidateInfo cInfo : fetchedCandidates)
					{
						system.debug('***Candidate ID***'+cinfo.CandidateID);
						system.debug('***Candidate DScore***'+cinfo.DScore);
						
						if (cinfo.pointSystemResult != NULL && cinfo.pointSystemResult != '')
						{
							CandidateMaps.put(cinfo.CandidateID,cInfo);
						}
						else
						{
							DISCMessage = 'Fail';
						}
						
					}
					
					if (CandidateMaps.size() > 0)
					{
						updateDISCRecord(CandidateMaps);
						DISCMessage = 'Success';
					}
					
				}
				else
				{
					DISCMessage = 'Fail';
		
				}
			}
			else
			{
				DISCMessage = 'Fail';
		
			}
			
		}
		catch(Exception ex)
		{
    		System.debug(ex);
		}
		
		return DISCMessage;
	}
	
	
	
	public boolean registerUser(string userid, string fname, string lname,string email)
	{
		try
		{
			string KeyValue = '';
			Application_Constants__c appconstant = Application_Constants__c.getInstance('DISC_RegisterUser');
        	KeyValue=appconstant.Value__c;
			
			DISCWebService disc = new DISCWebService();
			DISCWebService.registerUserRequest_element registerUserData = new DISCWebService.registerUserRequest_element();
			DISCWebService.PersonalityTestWebServiceAccessPointPort discPort = new DISCWebService.PersonalityTestWebServiceAccessPointPort();
			string userdata = '[{"userid":"' + userid + '","fname":"' + fname + '","lname":"' + lname + '","email":"' + email + '"}]';
			String discRegisterUserData = discPort.registerUser(KeyValue,userdata);
			system.debug('***Register data are***'+discRegisterUserData);
			string chkString = '<ok>1</ok>';
			if (discRegisterUserData.contains(chkString))
			{
				DISC__c InsDISC = new DISC__c();
				InsDISC.AppID__c = userid;
				InsDISC.Candidate_Added_DateTime__c = DateTime.now();
				insert InsDISC;
				return true;
			}
			else
			{
				return false;
			}
		}
		catch(Exception ex)
		{
    		System.debug(ex);
    		return false;
		}
		
	}
	
	public void candidateReset(string userid)
	{
		try
		{
			string KeyValue = '';
			Application_Constants__c appconstant = Application_Constants__c.getInstance('DISC_CandidateReset');
        	KeyValue=appconstant.Value__c;
        	
			DISCWebService disc = new DISCWebService();
			DISCWebService.candidateResetRequest_element candidateResetData = new DISCWebService.candidateResetRequest_element();
			DISCWebService.PersonalityTestWebServiceAccessPointPort discPort = new DISCWebService.PersonalityTestWebServiceAccessPointPort();
			string userdata = '{"candidateID":"' + userid + '"}';
			String discCandidateReset = discPort.candidateReset(KeyValue,userdata); 
			system.debug('***Candidate Reset data are***'+discCandidateReset);
		}
		catch(Exception ex)
		{
    		System.debug(ex);
		}
	}
	
	public void feeddata(string userid, string fname, string lname,string email)
	{
		try
		{
			string KeyValue = '';
			Application_Constants__c appconstant = Application_Constants__c.getInstance('DISC_FeedData');
        	KeyValue=appconstant.Value__c;
        	
			DISCWebService disc = new DISCWebService();
			DISCWebService.feedDataRequest_element feedData = new DISCWebService.feedDataRequest_element();
			DISCWebService.PersonalityTestWebServiceAccessPointPort discPort = new DISCWebService.PersonalityTestWebServiceAccessPointPort();
			string userdata = '[{"userid":"' + userid + '","fname":"' + fname + '","lname":"' + lname + '","email":"' + email + '"}]';
			String discfeedData = discPort.feedData(KeyValue,userdata);
			system.debug('***Feed data are***'+discfeedData);
		}
		catch(Exception ex)
		{
    		System.debug(ex);
		}
		
	}
	
	public void updateDISCRecord(map<string,CandidateInfo> cndtMap)
	{
		Set<Id> appInfoIds = new Set<Id>();
		system.debug('Availabale Candidates are : '+ cndtMap);
		list<DISC__c> updDISCList = [SELECT AppID__c, D_Score__c, I_Score__c, S_Score__c, C_Score__c, Point_System_Result__c, IP_Address__c, Summary_of_Personality__c, Test_Completion_DateTime__c, Test_Time_Taken__c, Report_URL__c, DDescription__c, IDescription__c, SDescription__c, CDescription__c FROM DISC__c WHERE AppID__c IN :cndtMap.keySet()];
		system.debug('Availabale Candidates are : '+ updDISCList);
		if (updDISCList != NULL && updDISCList.size() > 0)
		{
			for(DISC__c cndtInfo : updDISCList)
			{
				system.debug('Test*****'+cndtMap.get(cndtInfo.AppID__c));
				cndtInfo.D_Score__c = cndtMap.get(cndtInfo.AppID__c).DScore;
				cndtInfo.I_Score__c = cndtMap.get(cndtInfo.AppID__c).IScore;
				cndtInfo.S_Score__c = cndtMap.get(cndtInfo.AppID__c).SScore;
				cndtInfo.C_Score__c = cndtMap.get(cndtInfo.AppID__c).CScore;
				cndtInfo.Point_System_Result__c = cndtMap.get(cndtInfo.AppID__c).pointSystemResult;
				cndtInfo.IP_Address__c = cndtMap.get(cndtInfo.AppID__c).IPAddress;
				cndtInfo.Summary_of_Personality__c = cndtMap.get(cndtInfo.AppID__c).summaryOfPersonality;
				cndtInfo.Test_Completion_DateTime__c = cndtMap.get(cndtInfo.AppID__c).testCompletionDateTime;
				cndtInfo.Test_Time_Taken__c = cndtMap.get(cndtInfo.AppID__c).testTimeTaken;
				cndtInfo.Report_URL__c = cndtMap.get(cndtInfo.AppID__c).ReportURL;
				cndtInfo.DDescription__c = cndtMap.get(cndtInfo.AppID__c).DDescription;
				cndtInfo.IDescription__c = cndtMap.get(cndtInfo.AppID__c).IDescription;
				cndtInfo.SDescription__c = cndtMap.get(cndtInfo.AppID__c).SDescription;
				cndtInfo.CDescription__c = cndtMap.get(cndtInfo.AppID__c).CDescription;
				
				if(cndtMap.get(cndtInfo.AppID__c).ReportURL != NULL && cndtMap.get(cndtInfo.AppID__c).ReportURL != '')
				{
					appInfoIds.add(cndtInfo.AppID__c);
				}
			}
			update updDISCList;
			
			if(appInfoIds != NULL && appInfoIds.size()>0)
			{
				list<Applicant_Info__c> appUpdList = [SELECT ID, PageStatus_Started__c, PageStatus_Complete__c from Applicant_Info__c WHERE ID IN :appInfoIds];
				if(appUpdList != NULL && appUpdList.size()>0)
				{
					for (Applicant_Info__c AppInd : appUpdList)
					{
						if(!(AppInd.PageStatus_Complete__c.contains('039')) )
						{
							if(AppInd.PageStatus_Complete__c != null && AppInd.PageStatus_Complete__c != '')
							{
								AppInd.PageStatus_Complete__c = AppInd.PageStatus_Complete__c + ';039'; 
			                }
			                else
			                {
			                	AppInd.PageStatus_Complete__c = '039'; 
			                }
			            }
					}
					update appUpdList;
				}
			}
		}
	}
	
	public class CandidateInfo 
 	{
 		public String CandidateID;
        public Integer DScore;
        public Integer IScore;
        public Integer SScore;
        public Integer CScore;
        public String ReportURL;
        public String testTimeTaken;
        public String pointSystemResult;
        public String CandidateAddedDateTime;
        public Datetime testCompletionDateTime;
        public String IPAddress;
        public String summaryOfPersonality;
        
        public String DDescription;
        public String IDescription;
        public String SDescription;
        public String CDescription;
    }
    
 	public List<CandidateInfo> read(String document) 
 	{
        List<CandidateInfo> ret = new List<CandidateInfo>();
        boolean isSafeToGetNextXmlElement = true;

        XmlStreamReader reader = new XmlStreamReader(document);

        while(isSafeToGetNextXmlElement) 
        {
            if (reader.getEventType() == XmlTag.START_ELEMENT) 
            {
                if ('candidate' == reader.getLocalName()) 
                {
                    CandidateInfo item = parseItem(reader);
                    ret.add(item);
                }
            }
            if (reader.hasNext()) 
            {
                reader.next();
            } 
            else 
            {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }        
		
		system.debug('Total Size ****' + ret.size());
        return ret;
    }

    public CandidateInfo parseItem(XmlStreamReader reader) 
    {

        CandidateInfo ret = new CandidateInfo();
        boolean isSafeToGetNextXmlElement = true;

        while(isSafeToGetNextXmlElement) 
        {
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'candidate' == reader.getLocalName()) 
            {
                isSafeToGetNextXmlElement = false;  
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) 
            {
                if ('CandidateID' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String CandidateID = parseString(reader);
                        ret.CandidateID = CandidateID;
                }
                if ('D' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String DStr = parseString(reader);
                        ret.DScore = Integer.valueof(DStr.trim());
                }
                if ('I' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String IStr = parseString(reader);
                        ret.IScore = Integer.valueof(IStr.trim());
                }
                if ('S' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String SStr = parseString(reader);
                        ret.SScore = Integer.valueof(SStr.trim());
                }
                if ('C' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String CStr = parseString(reader);
                        ret.CScore = Integer.valueof(CStr.trim());
                }
                if ('reportURL' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String rptURL = parseString(reader);
                        ret.ReportURL = rptURL;
                }
                if ('testTimeTaken' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String tstTimeTaken = parseString(reader);
                        ret.testTimeTaken = tstTimeTaken;
                }
                if ('pointSystemResult' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String ptSystemResult = parseString(reader);
                        if(ptSystemResult != NULL && ptSystemResult != '')
                        {
                        	ret.pointSystemResult = ptSystemResult.trim();
                        }
                }
                if ('candidateIP' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String IPAddr = parseString(reader);
                        ret.IPAddress = IPAddr;
                }
                if ('summaryOfPersonality' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String sumOfPersonality = parseString(reader);
                        ret.summaryOfPersonality = sumOfPersonality;
                }
                if ('testCompletionDateTime' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String tstCompletionDateTime = parseString(reader);
                        if(tstCompletionDateTime != NULL && tstCompletionDateTime != '')
                        {
                        	ret.testCompletionDateTime = DateTime.valueOf(tstCompletionDateTime);	
                        }
                }
                
                if ('DDescription' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String DDescription = parseString(reader);
                        ret.DDescription = DDescription;
                }
                
                if ('IDescription' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String IDescription = parseString(reader);
                        ret.IDescription = IDescription;
                }
                
                if ('SDescription' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String SDescription = parseString(reader);
                        ret.SDescription = SDescription;
                }
                
                if ('CDescription' == reader.getLocalName() && reader.getNamespace() == null) 
                {
                        String CDescription = parseString(reader);
                        ret.CDescription = CDescription;
                }
               
            }
            if (reader.hasNext()) 
            {
                reader.next();
            } else 
            {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }        

        return ret;

    }

    public String parseString(XmlStreamReader reader) {
        String ret = '';

        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) 
        {
            if (reader.getEventType() == XmlTag.END_ELEMENT) 
            {
                break;
            } 
            else if (reader.getEventType() == XmlTag.CHARACTERS) 
            {
                ret = ret + reader.getText();
            } 
            else if (reader.getEventType() == XmlTag.CDATA) 
            {
                ret = reader.getText();
            }
            if (reader.hasNext()) 
            {
                reader.next();
            } else 
            {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return ret.trim();
    }
    
    
}