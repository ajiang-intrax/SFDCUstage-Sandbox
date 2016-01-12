public class GlobalSalesMatrixController{
		
	public LeadRouting__c objLeadRouting {get; set;}
	public leadRouting__c newLeadRouting {get; set;}
	public list<LeadRouting__c> lstLeadRoutingSelectdRecord {get; set;}
	public list<LeadRouting__c> lstLeadRoutingdRecordCloned;
	public list<LeadRouting__c> summaryRecord {get; set;}
	
	public String approvedRecordId {get; set;}
	public String rejectedRecordId {get; set;}
	public String deletedRecordId {get; set;}
	
	public String leadSelectType;
	public String programSelectType;
	public String countryOrginSelectType;
	public String countryInterestSelectType;
	public String queueSelectType;
	
	public Boolean isGSMActive {get; set;}
	public Boolean isUserApprover {get; set;}
	
	public Boolean filterBlock {get; set;}
	public Boolean isFiltered {get; set;}
	public Boolean updateLeadRecord {get; set;}	
	public Boolean noUpdateRecord {get; set;}
	public Boolean deleteLeadRecord {get; set;}
	public Boolean isCreate {get; set;}
	public Boolean newLeadRecord {get; set;}	
	public Boolean summaryDate {get; set;}
	public Boolean summaryReport {get; set;}	
	
	public ApexPages.StandardSetController setController {get; set;}
	public Integer recordCount {get; set;}
	public Integer pageSize{get; set;}
	public String queryString;
	
	public GlobalSalesMatrixController(ApexPages.StandardController controller){
		isUserApprover = false;
		objLeadRouting = new LeadRouting__c();
		newLeadRouting = new LeadRouting__c();
		lstLeadRoutingSelectdRecord = new list<LeadRouting__c>();
		lstLeadRoutingdRecordCloned = new list<LeadRouting__c>();
		summaryRecord = new list<LeadRouting__c>();
		
		setBoolean();
		checkGSMActive();	
		checkUserApprover();		
	}
	
	public GlobalSalesMatrixController(ApexPages.StandardSetController setStandardcontroller) {
        setController = setStandardcontroller;
    }
	
	public void setBoolean(){	
		filterBlock = true;
		isFiltered = false;
		isCreate = false;			
		newLeadRecord = false;		
		updateLeadRecord = false;
		noUpdateRecord = false;
		deleteLeadRecord = false;
		summaryDate = false;
		summaryReport = false;		
	}
	
	public void checkGSMActive(){
		if(Global_Constants__c.getInstance().GSM_Activate__c){
			isGSMActive= true;
		}else {
			isGSMActive = false;
		}
	}
	
	public void checkUserApprover(){
		if(Global_Constants__c.getInstance().GSMApprover__c != null){
			list<String> lstUserId = Global_Constants__c.getInstance().GSMApprover__c.replaceAll(' ','').split(',', 0);
			set<String> setUserId = new set<String>();
			for(String itrUserId : lstUserId){
				setUserId.add(itrUserId);
			}			
			if(setUserId.contains(UserInfo.getUserId().substring(0, 15))){
				isUserApprover = true;
			}
		}
	}
	
	public Boolean hasNext {
        get {
        	if(setController != null){
            return setController.getHasNext();
        	}
        	return false;
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
        	if(setController != null){
            	return setController.getHasPrevious();
        	}
        	return false;
        }
        set;
    }
    
    public void nextPage() {   
    	updateLeadRecord = false;
    	noUpdateRecord = false;
    	deleteLeadRecord = false;	
    	fetchSetControllerRecord('next');
		setController.next();
        lstLeadRoutingSelectdRecord = setController.getRecords();        
    }
	
	public void previousPage() {		
		updateLeadRecord = false;
		noUpdateRecord = false;
		deleteLeadRecord = false;
		fetchSetControllerRecord('previous');
        setController.previous();
        lstLeadRoutingSelectdRecord = setController.getRecords();
    }
    
     public void firstPage() {
     	updateLeadRecord = false;
     	noUpdateRecord = false;
     	deleteLeadRecord = false;
     	fetchSetControllerRecord('first');
        setController.first();        
        lstLeadRoutingSelectdRecord = setController.getRecords();
    }
  
    public void lastPage() {
    	updateLeadRecord = false;
    	noUpdateRecord = false;
    	deleteLeadRecord = false;
    	fetchSetControllerRecord('last');
        setController.last();        
        lstLeadRoutingSelectdRecord = setController.getRecords();
    }
    
    public Integer pageNumber {
        get {
        	if(setController != null){
            return setController.getPageNumber();
        	}
        	return 1;
        }
        set;
    }
    
    public void fetchSetControllerRecord(String action) { 
    	Integer pageNo;
    	if(action != 'main'){
    		pageNo = setController.getPageNumber();
    	}		
		if(action == 'next'){
			pageNo = pageNo++;
		}else if(action == 'previous'){ 
			pageNo = pageNo--;
		}
        setController = null;
        lstLeadRoutingSelectdRecord = null;
        pageSize = 100;	
		setController = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
		setController.setPageSize(pageSize);
		if(action != 'main'){
			setController.setpageNumber(pageNo);
		}
		recordCount = setController.getResultSize();
		if(action == 'update' || action == 'delete' || action == 'main'){
			lstLeadRoutingSelectdRecord = setController.getRecords();
		}
    }
	
	public void filterRecord(){
		setBoolean();
		isFiltered = true;
		setController = null;
		lstLeadRoutingSelectdRecord = null;		
		String filterQuery = '';
		
		if(objLeadRouting.Lead_Type__c != null || objLeadRouting.Program__c != null || objLeadRouting.Country_of_Origin__c != null || objLeadRouting.Country_of_Interest__c != null || objLeadRouting.Queue__c != null){
			if(objLeadRouting.Lead_Type__c != null){
				leadSelectType = objLeadRouting.Lead_Type__c;
				filterQuery = 'Lead_Type__c = :leadSelectType';
			}
			if(objLeadRouting.Program__c != null){
				programSelectType = objLeadRouting.Program__c;
				filterQuery = (filterQuery == '') ? ('Program__c = :programSelectType') : (filterQuery +' and Program__c = :programSelectType');
			}
			if(objLeadRouting.Country_of_Origin__c != null){
				countryOrginSelectType = objLeadRouting.Country_of_Origin__c;
				filterQuery = (filterQuery == '') ? ('Country_of_Origin__c = :countryOrginSelectType') : (filterQuery +' and Country_of_Origin__c = :countryOrginSelectType');
			}
			if(objLeadRouting.Country_of_Interest__c != null){
				countryInterestSelectType = objLeadRouting.Country_of_Interest__c;
				filterQuery = (filterQuery == '') ? ('Country_of_Interest__c = :countryInterestSelectType') : (filterQuery +' and Country_of_Interest__c = :countryInterestSelectType');
			}
			if(objLeadRouting.Queue__c != null){
				queueSelectType = objLeadRouting.Queue__c;
				filterQuery = (filterQuery == '') ? ('Queue__c = :queueSelectType') : (filterQuery +' and Queue__c = :queueSelectType');
			}
		}
		if(filterQuery != ''){			
			queryString = 'Select Id, NewRule__c, SubmittedBy__c, isDelete__c, Name_Link__c, isApprove_Reject__c, ProposedIntraxProgram__c, ProposedIntraxProgramOption__c, ProposedName__c, ProposedRoutingGroup__c, ProposedQueue__c, ProposedPriority__c, ProposedCountryofInterest__c, ProposedCountryofOrigin__c, ProposedLeadType__c, ProposedProgram__c, Name, Program__c, Country_of_Origin__c, Country_of_Interest__c, Intrax_Program__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, Queue__c, Routing_Group__c, Flag__c from LeadRouting__c where ' +filterQuery;
			lstLeadRoutingdRecordCloned = Database.query('Select Id, NewRule__c, SubmittedBy__c, isDelete__c, Name_Link__c, isApprove_Reject__c, ProposedIntraxProgram__c, ProposedIntraxProgramOption__c, ProposedName__c, ProposedRoutingGroup__c, ProposedQueue__c, ProposedPriority__c, ProposedCountryofInterest__c, ProposedCountryofOrigin__c, ProposedLeadType__c, ProposedProgram__c, Name, Program__c, Country_of_Origin__c, Country_of_Interest__c, Intrax_Program__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, Queue__c, Routing_Group__c, Flag__c from LeadRouting__c where ' +filterQuery);
			fetchSetControllerRecord('main');
		}
	}
	
	public void newRecord(){
		objLeadRouting.clear();		
		newLeadRouting.clear();
		setBoolean();
		isCreate = true;
	}
	
	public void summaryDateSelection(){
		setBoolean();
		objLeadRouting.StartDate__c = null;
		objLeadRouting.EndDate__c = null;
		filterBlock = false;
		summaryDate = true;
	}
	
	public Pagereference submitDate(){				
		if(objLeadRouting.StartDate__c == null || objLeadRouting.EndDate__c == null){
			String errorMsg = 'Please choose Start and End Date.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, +errorMsg));
			summaryReport = false;
			return null;
		}else if(objLeadRouting.StartDate__c > objLeadRouting.EndDate__c){
			String errorMsg = 'Start Date cannot be greater than End Date.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, +errorMsg));
			summaryReport = false;
			return null;
		}else{
			setBoolean();
			summaryRecord.clear();
			approvedRecordId = '';
			rejectedRecordId = '';
			summaryRecord = [Select Id, Name, NewRule__c, SubmittedBy__c, ProposedName__c, ProposedIntraxProgram__c, ProposedIntraxProgramOption__c, ProposedRoutingGroup__c, ProposedCountryofInterest__c, ProposedCountryofOrigin__c, ProposedLeadType__c, ProposedProgram__c, ProposedQueue__c, ProposedPriority__c, Program__c, isApprove_Reject__c, Country_of_Origin__c, Country_of_Interest__c, Intrax_Program__c, Name_Link__c,
								Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, Queue__c, Routing_Group__c, isDelete__c, Flag__c, LastModified_Date__c from LeadRouting__c where LastModified_Date__c >= :objLeadRouting.StartDate__c and LastModified_Date__c <= :objLeadRouting.EndDate__c and isApprove_Reject__c = true];	
			filterBlock = false;	
			summaryDate = true;
			summaryReport = true;
		return null;
		}				
	}
	
	public void backGSM(){
		objLeadRouting.clear();
		setBoolean();
	}
	
	public PageReference createRecord(){
		Boolean skipNameLogic = false;	
		newLeadRecord = false;					
		String leadRoutingName = '';
		String leadRoutingGroup = '';
		map<String, LeadRouting_Mapping__c> mapLeadRouting_Mapping = LeadRouting_Mapping__c.getAll();
		map<String, LeadRouting__c> mapDuplicateCheck = new map<String, LeadRouting__c>();
		list<LeadRouting__c> lstDuplicateCheck = new list<LeadRouting__c>();
		lstDuplicateCheck = [select Id, Name from LeadRouting__c];		
		if(newLeadRouting.Country_of_Origin__c == null && newLeadRouting.Country_of_Interest__c == null && newLeadRouting.Lead_Type__c == null && newLeadRouting.Program__c == null
			&& newLeadRouting.Queue__c == null){
			String errorMsg = 'Please select an option to create new rule.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, +errorMsg));
			return null;
		}
		for(LeadRouting__c itrDuplicate : lstDuplicateCheck){
			mapDuplicateCheck.put(itrDuplicate.Name, itrDuplicate);
		}		
		if(newLeadRouting.Program__c != null && mapLeadRouting_Mapping.get(newLeadRouting.Program__c) != null){
			leadRoutingName = mapLeadRouting_Mapping.get(newLeadRouting.Program__c).Abbreviation__c;
			if(newLeadRouting.Program__c == 'Internship - J1' || newLeadRouting.Program__c == 'ProWorld Internship'){
				skipNameLogic = true;
				newLeadRouting.Intrax_Program_Option__c = true;
				newLeadRouting.Intrax_Program__c = false;
			}else{
				newLeadRouting.Intrax_Program_Option__c = false;
				newLeadRouting.Intrax_Program__c = true;
			}
		}
		if(newLeadRouting.Lead_Type__c != null && mapLeadRouting_Mapping.get(newLeadRouting.Lead_Type__c) != null){
			if(!skipNameLogic){
				leadRoutingName = leadRoutingName == '' ? mapLeadRouting_Mapping.get(newLeadRouting.Lead_Type__c).Abbreviation__c : leadRoutingName + ' ' +mapLeadRouting_Mapping.get(newLeadRouting.Lead_Type__c).Abbreviation__c;
			}			
		}
		if(newLeadRouting.Country_of_Interest__c != null && mapLeadRouting_Mapping.get(newLeadRouting.Country_of_Interest__c) != null){
			if(!skipNameLogic){
				leadRoutingName = leadRoutingName == '' ? mapLeadRouting_Mapping.get(newLeadRouting.Country_of_Interest__c).Abbreviation__c : leadRoutingName + ' ' +mapLeadRouting_Mapping.get(newLeadRouting.Country_of_Interest__c).Abbreviation__c;
			}			
		}
		if(leadRoutingName != ''){
			leadRoutingGroup = leadRoutingName;
		}
		if(newLeadRouting.Country_of_Origin__c != null){
			leadRoutingName = leadRoutingName == '' ? newLeadRouting.Country_of_Origin__c : leadRoutingName + ' - ' +newLeadRouting.Country_of_Origin__c;
		}
		if(mapDuplicateCheck.containsKey(leadRoutingName)){
			String errorMsg = 'This rule already exist.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, +errorMsg));
			return null;
		}
		newLeadRouting.Name = LeadRoutingName;
		newLeadRouting.Routing_Group__c = leadRoutingGroup;
		newLeadRouting.NewRule__c = true;
		newLeadRouting.SubmittedBy__c = UserInfo.getFirstName();		
		newLeadRouting.isApprove_Reject__c = true;
		if(newLeadRouting.Queue__c != null){
			newLeadRouting.Priority__c = (mapLeadRouting_Mapping.get(newLeadRouting.Queue__c) != null) ? mapLeadRouting_Mapping.get(newLeadRouting.Queue__c).Priority__c : null;
		}
		newLeadRecord = true;
		insert newLeadRouting;	
		newLeadRouting.clear();
		return null;
	}	
	
	public PageReference updateRecord(){	
		Boolean skipNameLogic = false;	
		updateLeadRecord = false;
		noUpdateRecord = false;
		deleteLeadRecord = false;
		String leadRoutingName = '';
		String leadRoutingGroup = '';
		set<String> setDuplicateLead =  new set<String>();			
		setDuplicateLead.clear();
		map<String, LeadRouting_Mapping__c> mapLeadRouting_Mapping = LeadRouting_Mapping__c.getAll();
		list<LeadRouting__c> lstDuplicateCheck = new list<LeadRouting__c>();
		map<String, LeadRouting__c> mapDuplicateCheck = new map<String, LeadRouting__c>();
		lstDuplicateCheck = [select Id, Name from LeadRouting__c];
		for(LeadRouting__c itrDuplicate : lstDuplicateCheck){
			mapDuplicateCheck.put(itrDuplicate.Name, itrDuplicate);
		}
		
		list<LeadRouting__c> lstToUpdate = new list<LeadRouting__c>();
		lstToUpdate.clear();
		
		for(LeadRouting__c itrRecord : lstLeadRoutingSelectdRecord){
			skipNameLogic = false;
			itrRecord.Flag__c = false;			
			leadRoutingName = '';
			leadRoutingGroup = '';
			for(LeadRouting__c itrCloned : lstLeadRoutingdRecordCloned){
				if(itrCloned.Id == itrRecord.Id){
					if(itrCloned.Country_of_Interest__c != itrRecord.Country_of_Interest__c || itrCloned.Country_of_Origin__c != itrRecord.Country_of_Origin__c
						|| itrCloned.Lead_Type__c != itrRecord.Lead_Type__c || itrCloned.Program__c != itrRecord.Program__c){
						
						if(itrRecord.Program__c != null && mapLeadRouting_Mapping.get(itrRecord.Program__c) != null){
							leadRoutingName = mapLeadRouting_Mapping.get(itrRecord.Program__c).Abbreviation__c;
							if(itrRecord.Program__c == 'Internship - J1' || itrRecord.Program__c == 'ProWorld Internship'){
								skipNameLogic = true;
							}
						}
						if(itrRecord.Lead_Type__c != null && mapLeadRouting_Mapping.get(itrRecord.Lead_Type__c) != null){
							if(!skipNameLogic){
								leadRoutingName = leadRoutingName == '' ? mapLeadRouting_Mapping.get(itrRecord.Lead_Type__c).Abbreviation__c : leadRoutingName + ' ' +mapLeadRouting_Mapping.get(itrRecord.Lead_Type__c).Abbreviation__c;
							}							
						}
						if(itrRecord.Country_of_Interest__c != null && mapLeadRouting_Mapping.get(itrRecord.Country_of_Interest__c) != null){
							if(!skipNameLogic){
								leadRoutingName = leadRoutingName == '' ? mapLeadRouting_Mapping.get(itrRecord.Country_of_Interest__c).Abbreviation__c : leadRoutingName + ' ' +mapLeadRouting_Mapping.get(itrRecord.Country_of_Interest__c).Abbreviation__c;
							}							
						}
						if(leadRoutingName != ''){
							leadRoutingGroup = leadRoutingName;
						}
						if(itrRecord.Country_of_Origin__c != null){
							leadRoutingName = leadRoutingName == '' ? itrRecord.Country_of_Origin__c : leadRoutingName + ' - ' +itrRecord.Country_of_Origin__c;
						}
						if(mapDuplicateCheck.containsKey(leadRoutingName)){
							if(itrRecord.Id != mapDuplicateCheck.get(leadRoutingName).Id){
								setDuplicateLead.add(itrRecord.Id);
							}										
						}
					}
						
				}
			}
		}
		if(setDuplicateLead.size() > 0){
			for(String  itrDuplicateId : setDuplicateLead){
				for(LeadRouting__c itrRecord : lstLeadRoutingSelectdRecord){
					if(itrRecord.Id == itrDuplicateId){
						itrRecord.Flag__c = true;
					}
				}
			}		
			String errorMsg = 'Rules already exist. Please correct the highlighted rows.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, +errorMsg));	
			return null;
		}else{
			for(LeadRouting__c itrRecord : lstLeadRoutingSelectdRecord){
				skipNameLogic = false;
				leadRoutingName = '';
				leadRoutingGroup = '';
				for(LeadRouting__c itrCloned : lstLeadRoutingdRecordCloned){
					if(itrCloned.Id == itrRecord.Id){
						if(itrCloned.Country_of_Interest__c != itrRecord.Country_of_Interest__c || itrCloned.Country_of_Origin__c != itrRecord.Country_of_Origin__c 
							|| itrCloned.Lead_Type__c != itrRecord.Lead_Type__c || itrCloned.Program__c != itrRecord.Program__c 
							|| itrCloned.Queue__c != itrRecord.Queue__c){
								if(itrCloned.Country_of_Interest__c != itrRecord.Country_of_Interest__c || itrCloned.Country_of_Origin__c != itrRecord.Country_of_Origin__c
									|| itrCloned.Lead_Type__c != itrRecord.Lead_Type__c || itrCloned.Program__c != itrRecord.Program__c){
									
									if(itrRecord.Program__c != null && mapLeadRouting_Mapping.get(itrRecord.Program__c) != null){
										leadRoutingName = mapLeadRouting_Mapping.get(itrRecord.Program__c).Abbreviation__c;
										if(itrRecord.Program__c == 'Internship - J1' || itrRecord.Program__c == 'ProWorld Internship'){
											skipNameLogic = true;
											itrRecord.Intrax_Program_Option__c = true;
											itrRecord.Intrax_Program__c = false;
										}else{
											itrRecord.Intrax_Program_Option__c = false;
											itrRecord.Intrax_Program__c = true;
										}
									}
									if(itrRecord.Lead_Type__c != null && mapLeadRouting_Mapping.get(itrRecord.Lead_Type__c) != null){
										if(!skipNameLogic){
											leadRoutingName = leadRoutingName == '' ? mapLeadRouting_Mapping.get(itrRecord.Lead_Type__c).Abbreviation__c : leadRoutingName + ' ' +mapLeadRouting_Mapping.get(itrRecord.Lead_Type__c).Abbreviation__c;
										}										
									}
									if(itrRecord.Country_of_Interest__c != null && mapLeadRouting_Mapping.get(itrRecord.Country_of_Interest__c) != null){
										if(!skipNameLogic){
											leadRoutingName = leadRoutingName == '' ? mapLeadRouting_Mapping.get(itrRecord.Country_of_Interest__c).Abbreviation__c : leadRoutingName + ' ' +mapLeadRouting_Mapping.get(itrRecord.Country_of_Interest__c).Abbreviation__c;
										}
									}
									if(leadRoutingName != ''){
										leadRoutingGroup = leadRoutingName;
									}
									if(itrRecord.Country_of_Origin__c != null){
										leadRoutingName = leadRoutingName == '' ? itrRecord.Country_of_Origin__c : leadRoutingName + ' - ' +itrRecord.Country_of_Origin__c;
									}
									itrRecord.ProposedName__c = leadRoutingName;
									itrRecord.ProposedRoutingGroup__c = leadRoutingGroup;
								}
								itrRecord.SubmittedBy__c = UserInfo.getFirstName();
								itrRecord.isApprove_Reject__c = true;
								if(itrCloned.Queue__c != itrRecord.Queue__c){
									itrRecord.ProposedPriority__c = (itrRecord.Queue__c == null) ? 0 : ((mapLeadRouting_Mapping.get(itrRecord.Queue__c) != null) ? mapLeadRouting_Mapping.get(itrRecord.Queue__c).Priority__c : 0);
									itrRecord.ProposedQueue__c = (itrRecord.Queue__c == null) ? '--None--' : itrRecord.Queue__c;
									itrRecord.Queue__c = itrCloned.Queue__c;
									itrRecord.Priority__c = itrCloned.Priority__c;
								}
								
								if(itrCloned.Program__c != itrRecord.Program__c){
									itrRecord.ProposedProgram__c = (itrRecord.Program__c == null) ? '--None--' : itrRecord.Program__c;
									itrRecord.Program__c = itrCloned.Program__c;
								}
								
								if(itrCloned.Lead_Type__c != itrRecord.Lead_Type__c){
									itrRecord.ProposedLeadType__c = (itrRecord.Lead_Type__c == null) ? '--None--' : itrRecord.Lead_Type__c;
									itrRecord.Lead_Type__c = itrCloned.Lead_Type__c;
								}
								
								if(itrCloned.Country_of_Interest__c != itrRecord.Country_of_Interest__c){
									itrRecord.ProposedCountryofInterest__c = (itrRecord.Country_of_Interest__c == null) ? '--None--' : itrRecord.Country_of_Interest__c ;
									itrRecord.Country_of_Interest__c = itrCloned.Country_of_Interest__c;
								}
								
								if(itrCloned.Country_of_Origin__c != itrRecord.Country_of_Origin__c){
									itrRecord.ProposedCountryofOrigin__c = (itrRecord.Country_of_Origin__c == null) ? '--None--' : itrRecord.Country_of_Origin__c;
									itrRecord.Country_of_Origin__c = itrCloned.Country_of_Origin__c;
								}
								
								if(itrCloned.Intrax_Program__c != itrRecord.Intrax_Program__c){
									itrRecord.ProposedIntraxProgram__c =  (itrRecord.Intrax_Program__c) ? 'TRUE' : 'FALSE';
									itrRecord.Intrax_Program__c = itrCloned.Intrax_Program__c;
								} 
								
								if(itrCloned.Intrax_Program_Option__c != itrRecord.Intrax_Program_Option__c){
									itrRecord.ProposedIntraxProgramOption__c =  (itrRecord.Intrax_Program_Option__c) ? 'TRUE' : 'FALSE';
									itrRecord.Intrax_Program_Option__c = itrCloned.Intrax_Program_Option__c;
								}
								
							lstToUpdate.add(itrRecord);													
						}				
					}
				}
			}	
		}
		if(lstToUpdate.size() > 0){			
			updateLeadRecord = true;	
			update lstToUpdate;				
			fetchSetControllerRecord('update');
		}else{
			noUpdateRecord = true;
		}
		return null;
	}
	
	public void deleteRecord(){
		list<LeadRouting__c> lstRecordTo_Delete = new list<LeadRouting__c>();
		lstRecordTo_Delete.clear();
		if(deletedRecordId != null){			
			lstRecordTo_Delete = [Select Id, isDelete__c, isApprove_Reject__c, SubmittedBy__c from LeadRouting__c where Id = :deletedRecordId];
			lstRecordTo_Delete[0].isDelete__c = true;
			lstRecordTo_Delete[0].isApprove_Reject__c = true;
			lstRecordTo_Delete[0].SubmittedBy__c = UserInfo.getFirstName();
		}
		if(lstRecordTo_Delete.size() > 0){
			update lstRecordTo_Delete;
			updateLeadRecord = false;	
			noUpdateRecord = false;	
			deleteLeadRecord = true;
			fetchSetControllerRecord('delete');
			deletedRecordId = '';
		}
	}
    
    public void appprovalAction(){
    	list<LeadRouting__c> lstRecordToApprove_Reject = new list<LeadRouting__c>();    	
    	lstRecordToApprove_Reject.clear();
    	if(approvedRecordId != ''){
    		lstRecordToApprove_Reject = [Select Id, NewRule__c, SubmittedBy__c, isApprove_Reject__c, ProposedIntraxProgram__c, ProposedIntraxProgramOption__c, ProposedQueue__c, ProposedPriority__c, ProposedName__c, ProposedRoutingGroup__c, ProposedCountryofInterest__c, 
    										ProposedCountryofOrigin__c, ProposedLeadType__c, ProposedProgram__c, Name, Program__c, Country_of_Origin__c, 
    										Country_of_Interest__c, Intrax_Program__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, 
    										Queue__c, Routing_Group__c, isDelete__c, Flag__c from LeadRouting__c where Id = :approvedRecordId];
    		if(lstRecordToApprove_Reject != null && lstRecordToApprove_Reject.size() > 0){
    			if(lstRecordToApprove_Reject[0].NewRule__c){
    				lstRecordToApprove_Reject[0].NewRule__c = false;
    				lstRecordToApprove_Reject[0].isApprove_Reject__c = false;
    				lstRecordToApprove_Reject[0].SubmittedBy__c = '';
    				update lstRecordToApprove_Reject[0];
    			}else if(lstRecordToApprove_Reject[0].isDelete__c){
    				delete lstRecordToApprove_Reject[0];
    			}else{
	    			if(lstRecordToApprove_Reject[0].ProposedQueue__c != null){
	    				lstRecordToApprove_Reject[0].Queue__c = (lstRecordToApprove_Reject[0].ProposedQueue__c == '--None--') ? '' :  lstRecordToApprove_Reject[0].ProposedQueue__c;
	    				lstRecordToApprove_Reject[0].ProposedQueue__c = '';
	    				if(lstRecordToApprove_Reject[0].ProposedPriority__c != null){
	    					lstRecordToApprove_Reject[0].Priority__c = (lstRecordToApprove_Reject[0].ProposedPriority__c == 0) ? null : lstRecordToApprove_Reject[0].ProposedPriority__c;
							lstRecordToApprove_Reject[0].ProposedPriority__c = null;
	    				}
					}
	    			if(lstRecordToApprove_Reject[0].ProposedCountryofInterest__c != null){
	    				lstRecordToApprove_Reject[0].Country_of_Interest__c = (lstRecordToApprove_Reject[0].ProposedCountryofInterest__c == '--None--') ? '' :  lstRecordToApprove_Reject[0].ProposedCountryofInterest__c;
	    				lstRecordToApprove_Reject[0].ProposedCountryofInterest__c = '';
	    			}    			
	    			if(lstRecordToApprove_Reject[0].ProposedCountryofOrigin__c != null){
	    				lstRecordToApprove_Reject[0].Country_of_Origin__c = (lstRecordToApprove_Reject[0].ProposedCountryofOrigin__c == '--None--') ? '' :  lstRecordToApprove_Reject[0].ProposedCountryofOrigin__c;
	    				lstRecordToApprove_Reject[0].ProposedCountryofOrigin__c = '';
	    			} 
	    			if(lstRecordToApprove_Reject[0].ProposedLeadType__c != null){
	    				lstRecordToApprove_Reject[0].Lead_Type__c = (lstRecordToApprove_Reject[0].ProposedLeadType__c == '--None--') ? '' :  lstRecordToApprove_Reject[0].ProposedLeadType__c;
	    				lstRecordToApprove_Reject[0].ProposedLeadType__c = '';
	    			} 
	    			if(lstRecordToApprove_Reject[0].ProposedProgram__c != null){
	    				lstRecordToApprove_Reject[0].Program__c = (lstRecordToApprove_Reject[0].ProposedProgram__c == '--None--') ? '' :  lstRecordToApprove_Reject[0].ProposedProgram__c;
	    				lstRecordToApprove_Reject[0].ProposedProgram__c = '';
	    			} 
	    			if(lstRecordToApprove_Reject[0].ProposedName__c != null){	    				
	    				lstRecordToApprove_Reject[0].Name = lstRecordToApprove_Reject[0].ProposedName__c;
	    				lstRecordToApprove_Reject[0].ProposedName__c = '';
	    			}
	    			if(lstRecordToApprove_Reject[0].ProposedRoutingGroup__c != null){
	    				lstRecordToApprove_Reject[0].Routing_Group__c = lstRecordToApprove_Reject[0].ProposedRoutingGroup__c;
	    				lstRecordToApprove_Reject[0].ProposedRoutingGroup__c = '';
	    			}
	    			if(lstRecordToApprove_Reject[0].ProposedIntraxProgram__c != null){
	    				lstRecordToApprove_Reject[0].Intrax_Program__c = (lstRecordToApprove_Reject[0].ProposedIntraxProgram__c == 'TRUE') ? true : false;
	    				lstRecordToApprove_Reject[0].ProposedIntraxProgram__c = '';
	    			}
	    			if(lstRecordToApprove_Reject[0].ProposedIntraxProgramOption__c != null){
	    				lstRecordToApprove_Reject[0].Intrax_Program_Option__c = (lstRecordToApprove_Reject[0].ProposedIntraxProgramOption__c == 'TRUE') ? true : false;
	    				lstRecordToApprove_Reject[0].ProposedIntraxProgramOption__c = '';
	    			}
	    			lstRecordToApprove_Reject[0].SubmittedBy__c = '';
	    			lstRecordToApprove_Reject[0].isApprove_Reject__c = false;
	    			update lstRecordToApprove_Reject[0];
	    		}    			
    			summaryRecord.clear();
    			approvedRecordId = '';
    			summaryRecord = [Select Id, Name, NewRule__c, SubmittedBy__c, ProposedIntraxProgram__c, ProposedIntraxProgramOption__c, ProposedName__c, ProposedRoutingGroup__c, ProposedCountryofInterest__c, ProposedCountryofOrigin__c, ProposedLeadType__c, 
								ProposedProgram__c, ProposedQueue__c, ProposedPriority__c, Program__c, isApprove_Reject__c, Country_of_Origin__c, Country_of_Interest__c, Intrax_Program__c, 
								Name_Link__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, Queue__c, Routing_Group__c, isDelete__c, Flag__c, 
								LastModified_Date__c from LeadRouting__c where LastModified_Date__c >= :objLeadRouting.StartDate__c and LastModified_Date__c <= :objLeadRouting.EndDate__c and isApprove_Reject__c = true];
    		}
    	}else if(rejectedRecordId != ''){
    		lstRecordToApprove_Reject = [Select Id, NewRule__c, isApprove_Reject__c, SubmittedBy__c, ProposedIntraxProgram__c, ProposedIntraxProgramOption__c, ProposedQueue__c, ProposedPriority__c, ProposedName__c, ProposedRoutingGroup__c, ProposedCountryofInterest__c, 
    										ProposedCountryofOrigin__c, ProposedLeadType__c, ProposedProgram__c, Name, Program__c, Country_of_Origin__c, 
    										Country_of_Interest__c, Intrax_Program__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, 
    										Queue__c, Routing_Group__c, isDelete__c, Flag__c from LeadRouting__c where Id = :rejectedRecordId];
    		if(lstRecordToApprove_Reject != null && lstRecordToApprove_Reject.size() > 0){
    			if(lstRecordToApprove_Reject[0].NewRule__c){
    				delete lstRecordToApprove_Reject[0];
	    		}else if(lstRecordToApprove_Reject[0].isDelete__c){
	    			lstRecordToApprove_Reject[0].isApprove_Reject__c = false;
	    			lstRecordToApprove_Reject[0].isDelete__c = false;
	    			lstRecordToApprove_Reject[0].SubmittedBy__c = '';
	    			update lstRecordToApprove_Reject[0];
	    		}else{
	    			lstRecordToApprove_Reject[0].ProposedQueue__c = '';
					lstRecordToApprove_Reject[0].ProposedCountryofInterest__c = '';
					lstRecordToApprove_Reject[0].ProposedCountryofOrigin__c = '';
					lstRecordToApprove_Reject[0].ProposedLeadType__c = '';
					lstRecordToApprove_Reject[0].ProposedProgram__c = '';
					lstRecordToApprove_Reject[0].ProposedName__c = '';
					lstRecordToApprove_Reject[0].ProposedRoutingGroup__c = '';
					lstRecordToApprove_Reject[0].ProposedPriority__c = null;
					lstRecordToApprove_Reject[0].ProposedIntraxProgram__c = '';
					lstRecordToApprove_Reject[0].ProposedIntraxProgramOption__c = '';
					lstRecordToApprove_Reject[0].SubmittedBy__c = '';
					lstRecordToApprove_Reject[0].isApprove_Reject__c = false;
					update lstRecordToApprove_Reject[0];
	    		}	
    		}    				
			summaryRecord.clear();
			rejectedRecordId = '';
			summaryRecord = [Select Id, Name, NewRule__c, SubmittedBy__c, ProposedIntraxProgram__c, ProposedIntraxProgramOption__c, ProposedName__c, ProposedRoutingGroup__c, ProposedPriority__c, ProposedCountryofInterest__c, ProposedCountryofOrigin__c, ProposedLeadType__c, 
								ProposedProgram__c, ProposedQueue__c, Program__c, isApprove_Reject__c, Country_of_Origin__c, Country_of_Interest__c, Intrax_Program__c, 
								Name_Link__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, Queue__c, Routing_Group__c, isDelete__c, Flag__c, 
								LastModified_Date__c from LeadRouting__c where LastModified_Date__c >= :objLeadRouting.StartDate__c and 
								LastModified_Date__c <= :objLeadRouting.EndDate__c and isApprove_Reject__c = true];
    	}
    }
    
    public PageReference excelGenerate(){
		PageReference pageRef = Page.GlobalSalesMatrix_GenerateExcel;
		pageRef.setRedirect(false);
		return pageRef;
	}
}