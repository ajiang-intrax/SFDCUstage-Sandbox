public class APC_Reference_Controller {

public Reference__c reference{get; set;}
public Person_Info__c primaryApplicant{get; set;}
public String ReferenceStatus{get; set;}
public String Status{get; set;}
public String Category{get; set;}
public Experience__c experience{get; set;}
public list<Experience_Detail__c> experDetList{get; set;}
public List<SelectOption> listCountryCodeOptions {get; set;}
public string quickLink {get;set;}

	public APC_Reference_Controller() { 
		listCountryCodeOptions = Constants.PHONE_COUNTRY_CODES;
		system.debug('@@@@@Enter constructor APC_Reference_Controller()');
		ReferenceStatus = '';
		Status = '';
		Category = '';
		Id idRef = ApexPages.currentPage().getParameters().get('id');
		reference = new Reference__c();
		Person_Info__c person = new Person_Info__c();
		primaryApplicant = new Person_Info__c();
		experience = new Experience__c();
		
		if(idRef!=null){
			list<Reference__c> referenceList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c,
			 		Email__c, Mobile__c, Person_Info__c, Applicant_Info__c, Time_Known__c, Data_Verified__c, Data_Verified_Description__c, Rating__c,
					Recommend_Participation__c, Recommend_Participation_Description__c, Eligibility_Confirmation__c, Relation_To_Participant__c,
					Participant_Traits__c, Participant_Suitability__c, Status__c, Primary_Applicant__c, Allow_AuPair__c, Reference_Created_Date__c,
         			Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
         			Intrax_Program__c, Type__c, Review_Date__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c,Reference_Language__c
                    from Reference__c where Id =: idRef];
            
            if(referenceList != null && referenceList.size()>0){
            	reference = referenceList[0];
            	
            	if(reference.Primary_Applicant_Id__c !=null){
            		primaryApplicant = [SELECT Id, Name, Primary_Applicant__c from Person_Info__c where Id =: reference.Primary_Applicant_Id__c ];
            		system.debug('@@@@@primaryApplicant.Name: ' + primaryApplicant.Name);
            	}
            	
            	
            	if(reference.Experience_Name__c != null){
            		experience =  [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                    exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                    exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c,
                                    exp.Current_Job__c, exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c,
                                    exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                    exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Frequency__c,
                                    exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,exp.Reference_Language__c
                                    FROM Experience__c exp 
                                    WHERE exp.Id =: reference.Experience_Name__c];
                    
                    Category = experience.Experience_Category__c;
                    
                    experDetList = [select p.Id, p.Name, p.Experience_Name__c, p.Date_of_Birth__c, Special_Needs_Description__c, Special_Needs_Indicated__c, Gender__c
                                From Experience_Detail__c p 
                                Where p.Experience_Name__c = :experience.Id 
                                order by p.Date_of_Birth__c ASC]; 
                }
            }
        }
        //ebd if(idRef!=null){}
        
        //B-01905
        if(ApexPages.currentPage().getParameters().get('quickLink')!=null){
        	quickLink = ApexPages.currentPage().getParameters().get('quickLink');
        }
	}
	
	public PageReference submitForm(){
		reference.Status__c = 'Complete';
		reference.Reference_Created_Date__c = date.today();
		update reference;
		checkStatus();
		return null;
	}
	
	public PageReference AcceptReference(){
		reference.Status__c = 'Confirmed';
		reference.Review_Date__c = date.today() ;
		update reference;
		
		//B-02335  (Start)
		integer pConfirmCnt = 0;
		integer cConfirmCnt = 0;
		
		list<Reference__c> referenceListCheck = [SELECT Name,Id, Status__c, Person_Info__c
				from Reference__c where Applicant_Info__c =: reference.Applicant_Info__c AND Status__c = 'Confirmed'];
		if (referenceListCheck!= NULL && referenceListCheck.size()>0)		
		{
			for (Reference__c singleRef : referenceListCheck)
			{
				if (singleRef.Person_Info__c == NULL)
				{
					cConfirmCnt = cConfirmCnt + 1;
				}
				else if (singleRef.Person_Info__c != NULL)
				{
					pConfirmCnt = pConfirmCnt + 1;
				}
			}
			
			Applicant_Info__c AInfo = [SELECT PageStatus_Complete__c FROM Applicant_Info__c WHERE ID =: reference.Applicant_Info__c];
			
			if (cConfirmCnt >= 2 && pConfirmCnt >= 1)
			{
				if(AInfo.PageStatus_Complete__c != null && AInfo.PageStatus_Complete__c != '')
				{
					if(!(AInfo.PageStatus_Complete__c.contains('042')))
					{
						AInfo.PageStatus_Complete__c = AInfo.PageStatus_Complete__c + ';042'; 
					}
				}
				else
				{
					AInfo.PageStatus_Complete__c = '042'; 
				}
			}
			else
			{
				if(AInfo.PageStatus_Complete__c != null && AInfo.PageStatus_Complete__c != '')
				{
					if(AInfo.PageStatus_Complete__c.contains(';042'))
					{
						AInfo.PageStatus_Complete__c = AInfo.PageStatus_Complete__c.replace(';042',''); 
					}
					else if (AInfo.PageStatus_Complete__c.contains('042'))
					{
						AInfo.PageStatus_Complete__c = AInfo.PageStatus_Complete__c.replace('042',''); 
					}
				}
			}
			update AInfo;			
		}
		
		//B-02335  (End)
		
		//B-01905
		pageReference p;
		if(quickLink != NULL && quickLink == 'yes'){
			p = new pageReference('/apex/pr_app_references_to_review');
	        p.setRedirect(true);
		}
		else{
			p = new pageReference('/apex/apc_ap_main_reference_check?id=' + reference.Applicant_Info__c);
	        p.setRedirect(true);
		}
        return p;
	}
	
	public PageReference RejectReference(){
		reference.Status__c = 'Rejected';
		reference.Reference_Status__c = 'Canceled';
		reference.Review_Date__c = date.today();
		update reference;
		
		
		//B-02335  (Start)
		integer pConfirmCnt = 0;
		integer cConfirmCnt = 0;
		
		list<Reference__c> referenceListCheck = [SELECT Name,Id, Status__c, Person_Info__c
				from Reference__c where Applicant_Info__c =: reference.Applicant_Info__c AND Status__c = 'Confirmed'];
		if (referenceListCheck!= NULL && referenceListCheck.size()>0)		
		{
			for (Reference__c singleRef : referenceListCheck)
			{
				if (singleRef.Person_Info__c == NULL)
				{
					cConfirmCnt = cConfirmCnt + 1;
				}
				else if (singleRef.Person_Info__c != NULL)
				{
					pConfirmCnt = pConfirmCnt + 1;
				}
			}
			
			Applicant_Info__c AInfo = [SELECT PageStatus_Complete__c FROM Applicant_Info__c WHERE ID =: reference.Applicant_Info__c];
			
			if (cConfirmCnt >= 2 && pConfirmCnt >= 1)
			{
				if(AInfo.PageStatus_Complete__c != null && AInfo.PageStatus_Complete__c != '')
				{
					if(!(AInfo.PageStatus_Complete__c.contains('042')))
					{
						AInfo.PageStatus_Complete__c = AInfo.PageStatus_Complete__c + ';042'; 
					}
				}
				else
				{
					AInfo.PageStatus_Complete__c = '042'; 
				}
			}
			else
			{
				if(AInfo.PageStatus_Complete__c != null && AInfo.PageStatus_Complete__c != '')
				{
					if(AInfo.PageStatus_Complete__c.contains(';042'))
					{
						AInfo.PageStatus_Complete__c = AInfo.PageStatus_Complete__c.replace(';042',''); 
					}
					else if (AInfo.PageStatus_Complete__c.contains('042'))
					{
						AInfo.PageStatus_Complete__c = AInfo.PageStatus_Complete__c.replace('042',''); 
					}
				}
			}
			update AInfo;			
		}
		
		//B-02335  (End)
		
		//B-01905
		pageReference p;
		if(quickLink != NULL && quickLink == 'yes'){
			p = new pageReference('/apex/pr_app_references_to_review');
	        p.setRedirect(true);
		}
		else{
			p = new pageReference('/apex/apc_ap_main_reference_check?id=' + reference.Applicant_Info__c);
	        p.setRedirect(true);
		}
		return p;
	}
	
	
	public void checkStatus(){
		system.debug('@@@@@Enter method AcheckStatus()');
		Id idRef = ApexPages.currentPage().getParameters().get('id');
		reference = new Reference__c();
		if(idRef!=null){
			list<Reference__c> referenceList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c,
			 		Email__c, Mobile__c, Person_Info__c, Applicant_Info__c, Time_Known__c, Data_Verified__c, Data_Verified_Description__c,
					Recommend_Participation__c, Recommend_Participation_Description__c, Eligibility_Confirmation__c, Relation_To_Participant__c,
					Participant_Traits__c, Participant_Suitability__c, Status__c, Primary_Applicant__c, Allow_AuPair__c, Reference_Created_Date__c,
         			Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
         			Intrax_Program__c, Type__c,Review_Date__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c,Reference_Language__c
                    from Reference__c where Id =: idRef];
            
            if(referenceList != null && referenceList.size()>0){
            	reference = referenceList[0];
            }
		}
		//Checking Active or Canceled
		if(reference.Reference_Status__c == 'Active'){
			ReferenceStatus = 'Active';
		}else{
			ReferenceStatus = 'Canceled';
		}
		//Checking Complete or Incomplete
		if(reference.Status__c == 'Complete' || reference.Status__c == 'Confirmed' ){
			Status = 'Complete';
		}else if(reference.Status__c == 'Rejected'){
			Status = 'Rejected';
		}else{
			reference.Status__c = 'Incomplete';
			update reference; 
			Status = 'Incomplete';
		}
	}
	
}