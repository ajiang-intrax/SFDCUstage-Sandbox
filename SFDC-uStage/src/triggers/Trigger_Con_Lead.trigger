trigger Trigger_Con_Lead on Lead (after insert, after update, before insert, before update) {
    //Instantiate Google Geo Controller
    System.debug('Inside Lead trigger before instance creation');
    googleGeoController gGeoC = new googleGeoController();
    System.debug('Inside Lead trigger after instance creation');
    
    // Creating the variables to store the data we need
    string lead_new_IP; // IP = Intrax Programs
    string lead_new_IPO; // IPO = Intrax Program Options
    string lead_old_IP;
    string lead_old_IPO;
    string lead_new_intrax_region;
    string lead_new_intrax_market;
    boolean lead_isConverted_old;
    boolean lead_isConverted_new;
    string lead_new_Scholarship_Interest;
    LeadShare lead_share=new LeadShare();
    String sflag;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    //Added 5/30/2012 to work around govenor limits  DL    
    list<Schema.PicklistEntry> ipValues, ipoValues;

    if(trigger.isBefore){
        //Strip Bad North American State Codes if they exist on incoming Marketo leads
        //Chg 5/30/2012 to use Constants instead of string literal  DL
        if (userinfo.getUserName().equals(Constants.MARKETO_USER)) {
            IUtilities.stripBadStates(Trigger.new);
        }
        
        if(trigger.isInsert){             
            
            for(Lead l: Trigger.new){
            //Updating the Intrax Region on a Lead coming from Marketo
                l.Inferred_Intrax_Region__c = IUtilities.update_Intrax_Region(l.mkto2__Inferred_Country__c, l.Citizenship__c, l.Country);                   
            //Getting the base URL from a lead coming from Marketo
                l.Original_Referrer_BaseURL__c = IUtilities.update_BaseURL(l.mkto2__Original_Referrer__c);                                				
            }
                        			
            //Sets Jigsaw action indicator so assignment rules and filters can identify new Jigsaw created records
            for (Lead i : Trigger.new) {
                if (i.Jigsaw != NULL) {
                    i.Jigsaw_Import__c = true;
                    i.Lead_Type__c = 'Host Company';
                }
            }
        } 
        // End trigger.IsInsert
        
        if(trigger.isUpdate){
            // ****** Code coming from MsplChgs
            for (Lead ld : Trigger.newMap.values()) {
                ld.Intrax_Programs_Chgs__c = ld.Intrax_Programs__c;
                ld.Projects_of_Interest_Chgs__c = ld.Projects_of_Interest__c;
            }
            // ****** Code coming from MsplChgs
            
            if (userinfo.getUserName().equals(Constants.SYS_ADMIN)) {
                System.debug('MAtched!');
                for (Lead newValues : Trigger.new){
                    System.debug('ID:'+newValues.Id);
                    for (Lead oldValues: Trigger.old){
                        System.debug('OLDVALUE: '+oldValues.HasOptedOutOfEmail+'NEWVALUE: '+newValues.HasOptedOutOfEmail);
                        if (oldValues.HasOptedOutOfEmail == true){
                            if (newValues.HasOptedOutOfEmail == false){
                                System.debug('Sys Admin can\'t uncheck. That makes SFDC Master and Casper Slave');
                                newValues.HasOptedOutOfEmail = true;
                            }
                        }                       
                    }
                }
            }           
            
          //If requested, match selected leads to a franchise
          //Added 5/30/2012 to work around govenor limits  DL
          //Get current Lead Intrax_Programs__c and Intrax_Program_Options__c multi-select Picklist Values
          try {
            Schema.sObjectType soType = Trigger.new.getSObjectType();            
            Schema.DescribeSObjectResult soDescribe = soType.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = soDescribe.fields.getMap();
            ipValues = fieldMap.get('Intrax_Programs__c').getDescribe().getPickListValues();
            ipoValues = fieldMap.get('Intrax_Program_Options__c').getDescribe().getPickListValues();
          }catch(Exception e) {
            System.debug('ERROR:' + e);
          }
         //End 5/30/2012 add
          
          // Getting the value before updating the register
          for(Lead le: Trigger.new) {          
                //Obtaining the older value of lead.Intrax_Programs__c and Intrax_Program_Options__c
                lead_old_IP = trigger.oldMap.get(le.Id).Intrax_Programs__c;                
                lead_old_IPO = trigger.oldMap.get(le.Id).Intrax_Program_Options__c;                         
                
                // Getting the previous info to know whether a lead is been converted or not.
                lead_isConverted_old = trigger.oldMap.get(le.Id).isConverted;
            
                //Obtaining the updated value of lead.Intrax_Programs__c and Intrax_Program_Options__c
                lead_new_IP = trigger.newMap.get(le.Id).Intrax_Programs__c;
                lead_new_IPO = trigger.newMap.get(le.Id).Intrax_Program_Options__c;
                
                lead_new_intrax_region = trigger.newMap.get(le.Id).Intrax_Region__c;
                lead_new_intrax_market= trigger.newMap.get(le.Id).Intrax_Market__c;
                lead_new_Scholarship_Interest = trigger.newMap.get(le.Id).Scholarship_Interest__c;
                // Getting the new values to know whether a lead has been converted or not.
                lead_isConverted_new = trigger.newMap.get(le.Id).isConverted;
                
                // Now we need to check whether the lead has been converted.
                if(lead_isConverted_old != lead_isConverted_new){
                    list<Opportunity> oppObjList = new List<Opportunity>();
                    //D-01969
                    if(le.ConvertedOpportunityId!=null){
                    			oppObjList = [SELECT o.Scholarship_incomplete_documents__c, o.Scholarship_Status__c, o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, 
                                                o.Work_Permit_Status__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, 
                                                o.Transportation_Note__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, 
                                                o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, 
                                                o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, 
                                                o.Referral_Code__c, o.RecordType.Name, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, 
                                                o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, 
                                                o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, 
                                                o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, 
                                                o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, 
                                                o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, 
                                                o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, 
                                                o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate,
                                                o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, 
                                                o.Is_From_MKTO__c, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Invoice_No__c, o.Intrax_Region__c, o.Intrax_Programs__c, 
                                                o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, 
                                                o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, 
                                                o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, 
                                                o.How_Heard__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, 
                                                o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, 
                                                o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Field_Staff__c, 
                                                o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, 
                                                o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c, o.Direct_Placement__c, o.Description, o.Deadline__c, o.Current_Visa__c, 
                                                o.CurrencyIsoCode, o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, 
                                                o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, 
                                                o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, 
                                                o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, 
                                                o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c 
                                          FROM  Opportunity o
                                          WHERE o.Id =: le.ConvertedOpportunityId];
                    	}
                    if(oppObjList!=null && oppObjList.size()>0 ){
                    	Opportunity oppObj = oppObjList[0];
                        oppObj = IUtilities.update_opp_programs(oppObj, lead_old_IP, lead_old_IPO);
                        // Updating the Intrax Region and Market
                        oppObj = IUtilities.update_opp_intrax_region(oppObj, lead_new_intrax_region,lead_new_intrax_market);
                        system.debug('****** Updating missing docs - lead convert');
                        Lead lead_obj=trigger.newMap.get(le.Id);
                        oppObj = IUtilities.Update_Opportunity(oppObj,lead_obj, true);
                        oppObj = IUtilities.update_opp_missing_docs(oppObj, true, lead_new_Scholarship_Interest); 
                        System.debug('oppObj is : ' + oppObj);
                        update oppObj;
                        IUtilities.OpportunityToEngagement(new list<Opportunity>{oppObj});                        
                    }   
                    
                    //IUtilities.update_opp_programs(le.ConvertedOpportunityId, lead_old_IP, lead_old_IPO);
                    // Updating the Intrax Region and Market
                    //IUtilities.update_opp_intrax_region(le.ConvertedOpportunityId, lead_new_intrax_region,lead_new_intrax_market); // Lead Map fields [ Lead IntraxRegion -> Account's Intrax Region ]  and 
                                                                                                                                     //  [Lead IntraxMarket -> Account's Intrax Market ] are done in Lead Map Fields [B-02547]
                   
                    // Updating the missing documents field
                    //list<Opportunity> op = [SELECT id, Incomplete_Missing_Documents__c, RecordTypeId, Intrax_Region__c, Intrax_Market__c FROM Opportunity WHERE Id =: le.ConvertedOpportunityId];
                    //Need to uncomment above and delete below line - SPillai
                    //list<Opportunity> op = [SELECT id, Incomplete_Missing_Documents__c, RecordTypeId, Intrax_Region__c, Intrax_Market__c, Intrax_Programs__c, Type FROM Opportunity WHERE Id =: le.ConvertedOpportunityId];
                    //system.debug('****** Updating missing docs - lead convert');
                    //system.debug('****** Number of opps:' + op.size());
                    //IUtilities.update_opp_missing_docs(op, true);
                  
                    /*
                    // Updating Currency on Opportunity based on Intrax Market
                    IUtilities.update_opp_Currency(op, true);*/
                    //Need to uncomment above - Spillai
                    
                    // Setting Opportunity.Type = Lead.type
                    //string lead_new_Type = trigger.newMap.get(le.Id).Lead_Type__c;
                    
                    
                     // IUtilities.update_opp_missing_docs(op, true);
                        
                   
                }
                //This code is only available if the user is marketo!
                //Chg 5/30/2012 to use Constants instead of string literal  DL
                //if(UserInfo.getUserName() == 'marketosfdc@intraxinc.com.qa' )
                if(UserInfo.getUserName().equals(Constants.MARKETO_USER)){
                        //Modifing values if necessary
                        //Deprecated 5/30/2012 to work around govenor limits  DL
                        //string updated_value_IP = IUtilities.appendSelections(le, 'Intrax_Programs__c', lead_old_IP, lead_new_IP);
                        //string updated_value_IPO = IUtilities.appendSelections(le, 'Intrax_Program_options__c', lead_old_IPO, lead_new_IPO);
                        //Added 5/30/2012
                        string updated_value_IP = IUtilities.appendSelections(ipValues, lead_old_IP, lead_new_IP);
                        string updated_value_IPO = IUtilities.appendSelections(ipoValues, lead_old_IPO, lead_new_IPO);
                        //End 5/30/2012 changes
                        le.Intrax_Programs__c = updated_value_IP;
                        le.Intrax_Program_Options__c = updated_value_IPO;
                    }
                }
            Set<Id> leadShareIds = new set<Id>();
	   	    for(Lead record: Trigger.new) {
       		 	if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null && record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) {       		 
               		leadShareIds.add(record.Id);
       		 	}
             	system.debug('**leadShareIds**'+leadShareIds);
   		   }
   		   if(leadShareIds!=null && leadShareIds.size()>0) {
            sflag='before';
            SharingSecurityHelper.persistSharingwithOwner(lead_share, sflag, leadShareIds);   
   		   }
        } // End trigger.isBefore - isUpdate 
    } // End trigger.isBefore 
        
    if(trigger.isAfter){
        if(trigger.isInsert){
            // **** This comes from AssignToFranchise & IntraxMainLeadTrg
            /* AYII 398
            if(irt) LangoLeadAssignment.notifyFranchise(null, Trigger.new, 'AfterInsert'); 
            */            
          IUtilities.ConvertHotLead(Trigger.new);
        } // end isAfter - IsInsert

        if(Trigger.isUpdate){
             // **** This comes from AssignToFranchise & IntraxMainLeadTrg
             /* AYII 398
            if(irt) LangoLeadAssignment.notifyFranchise(System.Trigger.oldMap, Trigger.new, 'AfterUpdate'); 
            */
            // ***** Code coming from UpdateNemoIdToApplicantInfo
            
            List<Lead> geoLeads = new List<Lead>();
            for (Lead lr : trigger.new ){
                //Adding Geo Processes
                if (lr.Lead_Type__c == 'Host Family' && lr.Intrax_Programs__c == 'AuPairCare' && lr.Status == 'Qualified' ){
                    geoLeads.add(lr);
                }
                //Pick all Applicantions which are tagged to the lead 
                List<Applicant_Info__c> appInfoList = [select Id,Nemo_Id__c,Partner_Intrax_Id__c,Application_Level__c from applicant_info__c where lead__c = :lr.Id order by lastmodifieddate desc];
                //set<Applicant_Info__c> appInfoNeedsToBeUpdatedSet = new set<Applicant_Info__c>(); // Auxiliar set to avoid duplicates
                list<Applicant_Info__c> appInfoNeedsToBeUpdated = new list<Applicant_Info__c>();
                List<Opportunity> oppToBeUpdated = new List<Opportunity>();
                // Now we need to check whether the lead has been converted.
               
                //If found update all applications with the Nemo ID (for HF) + AccId
                if (!appInfoList.isEmpty()){
                    for (Applicant_Info__c appInfo : appInfoList)
                    {
                        // If Lead record has Nemo ID (created by Lead Bridge)
                        //Check if the lead record is Ayusa HostFamily
                        //MT 364. Introduced flag variable in this for loop.
                        Boolean flag=false;
                        if (!ApplicantInfoHelper.hasalreadySyncedFields() && !(lr.Nemo_Id__c == '' || lr.Nemo_Id__c == null) && lr.Intrax_Programs__c =='Ayusa' && lr.Intrax_Program_Options__c=='Ayusa High School' && lr.Lead_Type__c == 'Host Family'){
                            appInfo.Nemo_Id__c = lr.Nemo_Id__c;
                            appInfoNeedsToBeUpdated.add(appInfo);
                            flag=true;
                        }
                        if (lr.IsConverted){
                            System.debug('****** Lead is converted');
                            appInfo.Account__c = lr.ConvertedAccountId;
                            List<Opportunity> OppList = [select Id,StageName from Opportunity where AccountId = :lr.ConvertedAccountId order by lastModifiedDate desc];
                            if (OppList.size() > 0){
                            System.debug('****** opp exists');      
                            System.debug('****** OppList[0].StageName: '+OppList[0].StageName);
                            System.debug('****** appInfo.Partner_Intrax_Id__c: '+appInfo.Partner_Intrax_Id__c);
                            System.debug('****** appInfo Id'+appInfo);
                                //B-01641. Excluding when the app is (Basic and I-0000283)
                                if(OppList[0].StageName=='Prospecting' && !(appInfo.Partner_Intrax_Id__c == 'I-0000283' && appInfo.Application_Level__c == 'Basic'))
                                {
                                    System.debug('****** wrong route'); 
                                    OppList[0].StageName='Processing';
                                    //Trigger_Engagement_Helper.syncOppFromEng=false;
                                    update OppList[0];
                                }
                               // IUtilities.OpportunityToEngagement(oppList); 
                                appInfo.Opportunity_Name__c = OppList[0].Id;
                            }
                            if(!flag)
                                appInfoNeedsToBeUpdated.add(appInfo);
                        }
                                        
                    }
                }
                /* if (lr.IsConverted){
                   System.debug('****** Create new engagement');
                 List<Opportunity> Opp = [select Id,StageName from Opportunity where Id = :lr.ConvertedOpportunityId order by lastModifiedDate desc];
                if (Opp.size() > 0){
                     // Creating new Engagement Record
                    IUtilities.OpportunityToEngagement(Opp);
                  }
                }*/
                if(appInfoNeedsToBeUpdated.size() > 0)
                    update appInfoNeedsToBeUpdated;
            }
            // ***** Code coming from UpdateNemoIdToApplicantInfo
            gGeoC.sObjectList = geoLeads;
            //gGeoC.theInstanceGateKeeper();
            // ManualSharing - Ownership change
            
               if(!(blnDeployTestFlag))
               { 
                 set<Id> allshareIDs = new set<Id>();
                 for(Lead shr: Trigger.new)
                 {
                   if(Trigger.oldMap!=null && Trigger.oldMap.get(shr.Id).OwnerId!=null &&  shr.OwnerId != Trigger.oldMap.get(shr.Id).OwnerId) { 
                    allshareIDs.add(shr.id);
                   }
                 }
                 if(allshareIDs != NULL && allshareIDs.size()>0)
                  {
                	sflag='after';
                	SharingSecurityHelper.persistSharingwithOwner(lead_share, sflag, allshareIDs);    
                  }
                }  
          
          
          
          } //end isAfter - isUpdate
                
        }    /// end isAfter
           
}