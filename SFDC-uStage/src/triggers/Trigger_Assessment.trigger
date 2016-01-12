trigger Trigger_Assessment on Assessment__c (before update, after insert, after update) {
//   List<DeploymentTestCreation__c> lstDeploy {get; set;}

    string strAssName;
    boolean blnOldManualShare;
    boolean blnNewManualShare;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    list<string> engIdsToUpdate =  new list<string>();
    map<Accommodation__c,Accommodation_Site__c> mapCreateAccs = new map<Accommodation__c,Accommodation_Site__c>();
    list<Accommodation__c> accToBeInserted = new list<Accommodation__c>();
    list<Accommodation_Site__c> asiteToBeInserted =  new list<Accommodation_Site__c>();
    
    map<string, Accommodation_Site__c> map_asite_eng = new map<string, Accommodation_Site__c>();
    map<string, date> map_arrivalDate_to_eng = new map<string, date>();  
	
	list<Notification__c> notificationsToUpdate;
	Assessment__Share ass_share=new Assessment__Share();
    String flag;
    string AssessmentStatus_old;
    string AssessmentStatus_new;
    
    system.debug('*******blnDeployTestFlag*******'+blnDeployTestFlag); 
	
	//B-01523
	if(Trigger.isAfter){		
		if(Trigger.isInsert || Trigger.isUpdate){
            //##### Dale's Code Begins here Create new Pay_Events, but only once per transaction.
            if(Assessment_Trigger_Helper.firstRun){
		        //Get a list of Opportunity Ids related to Assessments.
		        List<Id> aIds = New List<Id>();
		        for(Assessment__c a : trigger.new){
		            	aIds.add(a.Id);
		        }
				//Get a Map of PE related Opportunities: ID, Recruiting_Staff, Field_Staff, LeadSource                
		        Map<Id,Assessment__c> mAssOppt = New Map<Id,Assessment__c>([SELECT id, Opportunity__r.id, Opportunity__r.Field_Staff__c, Opportunity__r.Recruiting_Staff__c, Opportunity__r.LeadSource 
		                                    FROM Assessment__c
		                                    WHERE id in :aIds
		                                   ]);
            
	            List<Assessment__c> pa = New List<Assessment__c>();
	            List<Pay_Event__c> pe = New List<Pay_Event__c>();
	            Map<Id, RecordType> rt = New Map<Id, RecordType>([SELECT Id, Name FROM RecordType]);
	            for(Assessment__c a : trigger.new){
                    //Any Assessment Record Type could create a Pay Event so long as Pay_Event_Ready has changed to true
	                if (a.Pay_Event_Ready__c == TRUE && ((Trigger.isUpdate && a.pay_Event_Ready__c != Trigger.oldMap.get(a.Id).Pay_Event_Ready__c) || Trigger.isInsert)){
                        Assessment__c aOppt = mAssOppt.get(a.Id);
                        //Bit of a hack, because the APC PT Check-In could trigger 3 different types of Pay Events,
                        //and up to 2 Pay Events for 1 assessment.  Tried hard to avoid this, but no more elegant idea occurred... 
                        if(aOppt != null && rt.get(a.RecordTypeId).Name == 'APC PT Check-In'){
                            if(aOppt.Opportunity__r.LeadSource == 'Repeat' && aOppt.Opportunity__r.Recruiting_Staff__c != null){
								Pay_Event__c npe = Assessment_Trigger_Helper.createPayEvent(a);
                                npe.OwnerId = aOppt.Opportunity__r.Recruiting_Staff__c;
                                npe.Payee__c = npe.OwnerId;
                                //JOSE B-03207
                                npe.HF_Account_Name__c = a.Host_Name__c;
                                //END JOSE B-03207
                                npe.Source__c = 'APC HF Repeat Bonus';
                                pe.add(npe);
                            }
                            if(aOppt.Opportunity__r.LeadSource == 'Field Staff' && aOppt.Opportunity__r.Field_Staff__c != null){
								Pay_Event__c npe1 = Assessment_Trigger_Helper.createPayEvent(a);
                               	npe1.OwnerId = aOppt.Opportunity__r.Field_Staff__c;
                               	npe1.Payee__c = npe1.OwnerId;
                               	//JOSE B-03207
                               	npe1.HF_Account_Name__c = a.Host_Name__c;
                               	//END JOSE B-03207
                               	npe1.Source__c = 'APC New HF L1';
                               	pe.add(npe1);
                            }    
							if(aOppt.Opportunity__r.LeadSource != 'Repeat' && aOppt.Opportunity__r.Recruiting_Staff__c != null){
								Pay_Event__c npe2 = Assessment_Trigger_Helper.createPayEvent(a);
                               	npe2.OwnerId = aOppt.Opportunity__r.Recruiting_Staff__c;
                               	npe2.Payee__c = npe2.OwnerId;
                               	//JOSE B-03207
                               	npe2.HF_Account_Name__c = a.Host_Name__c;
                               	//END JOSE B-03207
                               	npe2.Source__c = 'APC New HF L2';
                                pe.add(npe2);}
                        	}
                        else {
                            Pay_Event__c npe = Assessment_Trigger_Helper.createPayEvent(a);
                       		npe.OwnerId = a.OwnerId;
                   			npe.Payee__c = a.OwnerId;
                   			//JOSE B-03207
                            npe.HF_Account_Name__c = a.Host_Name__c;
                            //END JOSE B-03207
                       		npe.Source__c = rt.get(a.RecordTypeId).Name;
							pe.add(npe);                              
                        }
                	}
            	}
            	insert(pe);
                //Order of Execution recurision limited to 1 pass for this loop due to insert duplicate risk.
                //Added by Saroj for APC PT PR Interview Sharing (Start)
                if(Trigger.isInsert)
				{
					for(Assessment__c shareAss : trigger.new)
					{
						if(shareAss.Application__c != NULL && rt.get(shareAss.RecordTypeId).Name == 'AP PR Interview')
						{
							Applicant_Info__c AppPartnerId = [SELECT Partner_Intrax_Id__c FROM Applicant_Info__c WHERE Id =: shareAss.Application__c];
							if(AppPartnerId != NULL && AppPartnerId.Partner_Intrax_Id__c != NULL)
							{
								list<User> lstPartnerUsr=[Select u.Name, u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.Account__c, u.AccountId, u.AboutMe From User u where u.Intrax_Id__c =: AppPartnerId.Partner_Intrax_Id__c AND Id !=: shareAss.CreatedById];
								if(lstPartnerUsr != NULL && lstPartnerUsr.size() > 0)
								{
									Map<Id,List<User>> PartnerAssMap = new Map<Id,List<User>>();
									PartnerAssMap.put(shareAss.Id,lstPartnerUsr);
									Sharing_Security_Controller.sharePartnerAssessment(PartnerAssMap);
								}
								
							}
						}
					}
				}
				//Added by Saroj for APC PT PR Interview Sharing (End)
                
                Assessment_Trigger_Helper.firstRun = false;
            }
            //##### Dale's Code Ends here.
            
			for(Assessment__c assInfo : trigger.new){  
				if(assInfo.RecordTypeId == Constants.ASS_AY_Home_Visit && assInfo.Match_Name__c != NULL){
					List<Match__c> mat = [SELECT Id,Name,Home_Visit_Date__c FROM Match__c WHERE Id=:assInfo.Match_Name__c LIMIT 1];
					if(mat.size()>0){
						if(assInfo.Assessment_Date__c != NULL){
							mat[0].Home_Visit_Date__c = assInfo.Assessment_Date__c;
							update mat;
						}
					}
				}
			}
		}
		if(Trigger.isUpdate)
		{
			 // ManualSharing - Ownership change
            
            if(!(blnDeployTestFlag))
            {
                
                set<Id> allshareIDs = new set<Id>();
                for(Assessment__c shr: Trigger.new)
                {
                    if(Trigger.oldMap!=null && Trigger.oldMap.get(shr.Id).OwnerId!=null &&  shr.OwnerId != Trigger.oldMap.get(shr.Id).OwnerId) { 
                    allshareIDs.add(shr.id);
                    }
                }
                if(allshareIDs != NULL && allshareIDs.size()>0)
                {
                	flag='after';
                	SharingSecurityHelper.persistSharingwithOwner(ass_share, flag, allshareIDs);    
                }
            }
		}
				
	}
	
	
    if(Trigger.isBefore) {
         Set<Id> AssessmentIds = new set<Id>();
         Set<Id> ReShareAssessmentIds = new set<Id>();
         //Check for the event type
       	 //lstDeploy = Constants.lstDeployTestFlag;
     	 //system.debug('*******lstDeploy*******'+lstDeploy);  
     
         if(Trigger.isUpdate) {
         	
           // Getting all the Notifications related to the Assessments in context
           notificationsToUpdate = [SELECT Id, Assessment__c, Status__c, Assessment__r.Status__c, Engagement__c FROM Notification__c WHERE Assessment__c IN: trigger.new];

           for(Assessment__c assInfo : trigger.new){  
                blnOldManualShare = trigger.oldMap.get(assInfo.Id).ManualShareExists__c;
                blnNewManualShare = trigger.newMap.get(assInfo.Id).ManualShareExists__c;
                strAssName = assInfo.Name;
                system.debug('Inside Trigger blnOldManualShare*******'+blnOldManualShare); 
                system.debug('Inside Trigger blnNewManualShare*******'+blnNewManualShare);
                
                // RELATED TO IGI 600 & 502
   		   		AssessmentStatus_old = trigger.oldMap.get(assInfo.Id).Status__c;
   		   		AssessmentStatus_new = trigger.newMap.get(assInfo.Id).Status__c;
   		   		date AssessmentConfirmedDate_old = trigger.oldMap.get(assInfo.Id).Confirmed_Date__c;
   		   		date AssessmentConfirmedDate_new = trigger.newMap.get(assInfo.Id).Confirmed_Date__c;
   		   		
                if(AssessmentStatus_old != AssessmentStatus_new && (assInfo.RecordtypeId == Constants.ASS_IGI_PT_Check_In || assInfo.RecordtypeId == Constants.ASS_WT_PT_Check_In || assInfo.RecordTypeId == Constants.ASS_IGI_PT_Monthly_Contact || assInfo.RecordTypeId == Constants.ASS_IGI_PT_Mid_Program ||  assInfo.RecordTypeId == Constants.ASS_IGI_HC_Mid_Program ||  assInfo.RecordTypeId == Constants.ASS_IGI_PT_Final_Program || assInfo.RecordTypeId == Constants.ASS_IGI_HC_Final_Program  || assInfo.RecordTypeId == Constants.ASS_WT_PT_Monthly_Contact)){
                	for(Notification__c n : notificationsToUpdate){
                		if(n.Assessment__c == assInfo.Id)
                			if(AssessmentStatus_new == 'Not Yet Started') n.Status__c = 'Not Started';
                			else n.Status__c = AssessmentStatus_new;
                	}
                	
                }
                
   		   		// RELATED TO IGI 502
   		   		if(AssessmentStatus_old != AssessmentStatus_new && AssessmentStatus_new == 'Confirmed' && AssessmentConfirmedDate_old == AssessmentConfirmedDate_new && (assInfo.RecordtypeId == Constants.ASS_IGI_PT_Check_In || assInfo.RecordtypeId == Constants.ASS_WT_PT_Check_In ||  assInfo.RecordTypeId == Constants.ASS_IGI_PT_Monthly_Contact || assInfo.RecordTypeId == Constants.ASS_IGI_PT_Mid_Program ||  assInfo.RecordTypeId == Constants.ASS_IGI_HC_Mid_Program || assInfo.RecordTypeId == Constants.ASS_WT_PT_Monthly_Contact)){
   		   			if(assInfo.RecordtypeId == Constants.ASS_WT_PT_Check_In || assInfo.RecordtypeId == Constants.ASS_IGI_PT_Check_In) {
   		   				engIdsToUpdate.add(assInfo.Engagement__c);
   		   				// we need to sync some fields through the Engagement
   		   				map_arrivalDate_to_eng.put(assInfo.Engagement__c, assInfo.Actual_Arrival__c);   		   			
   		   			}
   		   			if(assInfo.Street__c != null ){
   		   				list<Accommodation__c> accList = [SELECT Id, Accommodation_Site__c, Accommodation_Site__r.Street__c, Accommodation_Site__r.Street_2__c, Accommodation_Site__r.State__c, Accommodation_Site__r.Postal_Code__c, Accommodation_Site__r.City__c,
   		   				 									Engagement__c, createdDate, Accommodation_Site__r.Business_Name__c, Accommodation_Site__r.Type__c  
   		   													FROM Accommodation__c 
   		   													WHERE Engagement__c =: assInfo.Engagement__c
   		   													order by createdDate desc];
   		   				//system.debug('******* assInfo:  ' +assInfo.Street__c+ ' / accList: ' + accList[0].Accommodation_Site__r.Street__c);
   		   				if(accList.size() > 0 ){
   		   					if(accList[0].Accommodation_Site__r.Street__c != assInfo.Street__c || accList[0].Accommodation_Site__r.Street_2__c != assInfo.Street_2__c
   		   						|| accList[0].Accommodation_Site__r.State__c != assInfo.State__c || accList[0].Accommodation_Site__r.City__c != assInfo.City__c
   		   						|| accList[0].Accommodation_Site__r.Postal_Code__c != assInfo.Postal_Code__c
   		   						|| accList[0].Accommodation_Site__r.Business_Name__c != assInfo.Accommodation_Business__c || accList[0].Accommodation_Site__r.Type__c != assInfo.Accommodation_Type__c){
   		   						system.debug('****** Creating accommodation site record...');
		   		   				Accommodation_Site__c asite = new Accommodation_Site__c();
		   		   				asite.Name = assInfo.Street__c;
		   		   				asite.Street__c = assInfo.Street__c;
		   		   				asite.Street_2__c = assInfo.Street_2__c;
		   		   				asite.City__c = assInfo.City__c;
		   		   				asite.State__c = assInfo.State__c;
		   		   				asite.Postal_Code__c = assInfo.Postal_Code__c;
		   		   				asite.Country__c = assInfo.Country__c;
		   		   				asite.Business_Name__c = assInfo.Accommodation_Business__c;
		   		   				asite.Type__c = assInfo.Accommodation_Type__c;
		   		   				// IGI 669
		   		   				asite.Address_Verified__c = assinfo.Address_Verified__c;
		   		   				asiteToBeInserted.add(asite);
		   		   				map_asite_eng.put(assInfo.Engagement__c, asite); 
   		   					}
   		   				}else{
	   		   					system.debug('****** Creating accommodation site record...');
		   		   				Accommodation_Site__c asite = new Accommodation_Site__c();
		   		   				asite.Name = assInfo.Street__c;
		   		   				asite.Street__c = assInfo.Street__c;
		   		   				asite.Street_2__c = assInfo.Street_2__c;
		   		   				asite.City__c = assInfo.City__c;
		   		   				asite.State__c = assInfo.State__c;
		   		   				asite.Postal_Code__c = assInfo.Postal_Code__c;
		   		   				asite.Country__c = assInfo.Country__c;
		   		   				asite.Business_Name__c = assInfo.Accommodation_Business__c;
		   		   				asite.Type__c = assInfo.Accommodation_Type__c;
		   		   				// IGI 669-675
		   		   				asite.Address_Verified__c = assinfo.Address_Verified__c;
		   		   				asiteToBeInserted.add(asite);
		   		   				map_asite_eng.put(assInfo.Engagement__c, asite); 
   		   				}
   		   				
   		   			}
   		   		}
   		   
                if(blnOldManualShare!=blnNewManualShare && blnNewManualShare) {
                    if(!(blnDeployTestFlag && strAssName.containsIgnoreCase('Test')))
                    AssessmentIds.add(assInfo.Id);    
                }              
                system.debug('Inside Trigger ass*******'+AssessmentIds); 
           }
           system.debug('Inside Trigger ass strAssName*******'+strAssName); 
              
           if(AssessmentIds!=null) SharingSecurityHelper.shareAssessment(AssessmentIds);
                     
           for(Assessment__c record: Trigger.new) {
       		 	if(Trigger.oldMap != null && Trigger.oldMap.get(record.Id).OwnerId!=null && record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId && record.ManualShareExists__c==True) {       		 
               		ReShareAssessmentIds.add(record.Id);
       		 	}
             	system.debug('**ReShareAssessmentIds**'+ReShareAssessmentIds);
   		   }
   		   if(ReShareAssessmentIds!=null && ReShareAssessmentIds.size()>0) {
      		 	/*SharingSecurityHelper.persistAssessmentSharing(
       	     	JSON.serialize(
            				[Select a.UserOrGroupId, a.RowCause, a.ParentId, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted,a.AccessLevel From Assessment__Share a
            					WHERE  a.ParentId IN :ReShareAssessmentIds AND 
                  		 		a.RowCause = 'Manual']));*/
            flag='before';
            SharingSecurityHelper.persistSharingwithOwner(ass_share, flag, ReShareAssessmentIds);   
   		   }
   		   
   		   
		}
		system.debug('****** map_asite_eng SIZE: ' + map_asite_eng.size());
		
		if(map_asite_eng.size() > 0){
			try{
				upsert asiteToBeInserted;
			}catch(Exception e){
				system.debug('***** Impossible to insert Accommodation Site records' + e );
			}
			
			if(map_asite_eng.size() > 0){
				for(string engId : map_asite_eng.keySet()){
					
					system.debug('****** map_asite_eng ID: ' + engId);
					Accommodation__c a = new Accommodation__c();
	   		   		a.Engagement__c = engId;
	   		   		a.Accommodation_Site__c = map_asite_eng.get(engId).Id;
	   		   		accToBeInserted.add(a);//map_acc_to_asite.put()
				}
				try{
					upsert AccToBeInserted;			
				}catch(Exception e){
					system.debug('****** Impossible to create Accommodation records: ' + e);
				}
			}		
		}	
		
		// Related to IGI 600
		if(NotificationsToUpdate.size() > 0){
			try{
				update notificationsToUpdate;
			}catch(Exception e){
				system.debug('***** Impossible to update notification status...');
			}
		}
		// Related to 502
		if(engIdsToUpdate.size() > 0){
			list<Engagement__c> engsToUpdate = [SELECT Id, Status__c, Actual_Arrival__c FROM Engagement__c WHERE Id IN: engIdsToUpdate];
			// Getting the Notifications we need to update
			if(engsToUpdate.size() > 0){
				for(Engagement__c e : engsToUpdate){
					e.Status__c = 'On Program';
					e.Actual_Arrival__c = map_arrivalDate_to_eng.get(e.Id);
				}
				try{
					update engsToUpdate;
				}catch(Exception e){
					system.debug('***** Impossible to update engagement Status: ' + e);
				}
			}
		}
		 
	}
 
}