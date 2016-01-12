public with sharing class EU_APC_checklist_Controller {
	
	public Opportunity opp{get;set;}
	public Audit_Document__c ad{get;set;}
	public string editMode{get;set;}
	public string oppId;	
	
	public void checkAuditDocs(){
		string oppId = ApexPages.CurrentPage().getParameters().get('id');
		try{
				ad = [Select a.SystemModstamp, a.Ref_2_Verified_Date__c, a.Ref_2_Signed_by_Ref__c, a.Ref_2_Match_Work_History__c, a.Ref_1_Verified_Date__c, a.Ref_1_Signed_by_Ref__c, a.Ref_1_Match_Work_History__c, a.Program_Agreement_PT_Sign_Init__c, a.Pers_Reference_Verified_Date__c, a.Pers_Reference_Signed_by_Ref__c, a.Passport_Name_Matches__c, a.Passport_Date_of_Birth__c, a.Passport_Birth_City__c, a.OwnerId, a.Opportunity__c, a.Name, a.Med_Physician_Signature__c, a.Med_Participant_Signature__c, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.ConnectionSentId, a.ConnectionReceivedId, a.Backgound_Check_Translated__c 
							From Audit_Document__c a
							WHERE a.Opportunity__c =: oppId order by a.createdDate ASC LIMIT 1];
					 
			}catch(Exception e){
				system.debug('***** Creating Audit Doc!!');
				Audit_Document__c ad_insert = new Audit_Document__c (
						Name = opp.Name,	
						Opportunity__c = oppId
					);
				insert ad_insert;	
				ApexPages.addMessages(e);
			}
	}
	
	public EU_APC_checklist_Controller(ApexPages.StandardController sc){
		oppId = ApexPages.CurrentPage().getParameters().get('id');
		
		if(ApexPages.currentPage().getParameters().get('editMode') != null){
			editMode = ApexPages.CurrentPage().getParameters().get('editMode');
		}
		
		if(oppId != null){
			opp = [Select  o.Account.Name, o.Account.Casper_Id__c, o.Account.isPersonAccount, 
					//o.invoiceit_crmx__VAT__c, o.invoiceit_crmx__Total__c, o.invoiceit_crmx__Total_Profit__c, o.invoiceit_crmx__Total_Cost__c, o.invoiceit_crmx__Total_Contract_Value__c, o.invoiceit_crmx__TotalQuoteValue__c, o.invoiceit_crmx__TotalProfitPercent__c, o.invoiceit_crmx__TotalOrderValue__c, o.invoiceit_crmx__Tax__c, o.invoiceit_crmx__Sub_Total__c, o.invoiceit_crmx__Shipping_Contact__c, o.invoiceit_crmx__Number_Of_Terms__c, o.invoiceit_crmx__Net_Total__c, o.invoiceit_crmx__Discount_Value__c, o.invoiceit_crmx__Discount_Percent__c, o.invoiceit_crmx__Discount_Code__c, o.invoiceit_crmx__CurrencyL__c, o.invoiceit_crmx__Billing_Contact__c, 
					o.Workers_Comp_Received__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, o.Transportation_Note__c, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Start__c, o.Program_Duration__c, 
					//o.Product_Group__c, 
					o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.IsWon, o.IsDeleted, o.IsClosed, o.Intrax_Region__c, o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, o.How_Heard__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Engagement_Start__c, o.Engagement_End__c, o.Description, o.Deadline__c, 
					//o.CurrencyIsoCode, 
					o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c 
					From Opportunity o 
					Where Id =: oppId];
		}
	}
	
	public pageReference editOpp(){
		
	 	PageReference p = new PageReference('/apex/EU_APC_checklist');
	 	p.getParameters().put('id',opp.Id);
	 	p.getParameters().put('editMode','true');
	 	p.setRedirect(true);
	 	return p;
	}
	
	public PageReference CancelOpp(){
		PageReference p = new PageReference('/apex/EU_APC_checklist');
	 	p.getParameters().put('id',opp.Id);
	 	p.setRedirect(true);
	 	return p;
	}
	
	public PageReference saveOpp(){
		system.debug('***** Gettin in saveOpp!');
		try{
			update opp;
			update ad;
		}catch(Exception e){
			ApexPages.addMessages(e);
		}
		PageReference p = new PageReference('/apex/EU_APC_checklist');
	 	p.getParameters().put('id',opp.Id);
	 	p.setRedirect(true);
	 	return p;
	}
}