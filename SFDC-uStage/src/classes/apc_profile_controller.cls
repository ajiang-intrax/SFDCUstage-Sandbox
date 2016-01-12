public without sharing class apc_profile_controller {
	
	public list<Applicant_Info__c> applist{get;set;}
	public Applicant_Info__c applicant{get;set;}
	public map<String, Experience__c> mapExperienceRef{get;set;}
	public map<String, String> ExpDetDOBStart{get;set;}
	public map<String, String> ExpDetDOBEnd{get;set;}
	
	public set<String> favRecords {get;set;}
	
	public map<String, boolean> isFavoriteId{	
		get{
			map<String, Boolean> isFavoriteIdAux = new map<String, Boolean>();
	    	list<User_Preference__c> up = [SELECT Id, User__c, Saved_Records__c FROM User_Preference__c WHERE 
	    										User__c =: userInfo.getUserId()
	    										AND Object__c = 'Applicant Info'];
	    											
	    	if(up.size() > 0){ 	
	    		if (up[0].Saved_Records__c != null && up[0].Saved_Records__c != '')
	    		favRecords = (set<String>) json.deserialize(up[0].Saved_Records__c, set<String>.class);
		    	else
		    	favRecords = new set<String>();
	    	}else
	    		favRecords = new set<String>();
	    	
	    	for(applicant_Info__c a:applist){
	    		if(favRecords.contains(a.Id)){
	    			isFavoriteIdAux.put(a.Id, true);
	    		}else
	    			isFavoriteIdAux.put(a.Id, false);
	    	}
	    	system.debug('@@@@@isFavoriteId: ' + isFavoriteIdAux);
			return isFavoriteIdAux;
	    	
	    }
		set;
	}
	
	public set<String> disRecords {get;set;}
    public map<String, boolean> isDismissedId{get{
    	map<String, Boolean> isDismissedIdAux = new map<String, Boolean>();
    	list<User_Preference__c> up = [SELECT Id, User__c, Dismissed_Records__c FROM User_Preference__c WHERE 
    										User__c =: userInfo.getUserId()
    										AND Object__c = 'Applicant Info'];
    											
    	if(up.size() > 0){
	    	if (up[0].Dismissed_Records__c != null)
	    	disRecords = (set<String>) json.deserialize(up[0].Dismissed_Records__c, set<String>.class);
	    	else 
	    	disRecords = new set<String>();
	    }else 
	    	disRecords = new set<String>();
	    for(applicant_Info__c a:applist){
	    	if(disRecords.contains(a.Id)){
	    		isDismissedIdAux.put(a.Id, true);
	    	}else 
	    		isDismissedIdAux.put(a.Id, false);
	    }
	    system.debug('@@@@@isDismissedId: ' + isDismissedIdAux);
		return isDismissedIdAux;
    }
    set;}
	
	public List<Intrax_Program_Upload__c> phyDocList{get{
		List<Intrax_Program_Upload__c> listdoc = new List<Intrax_Program_Upload__c>();
		listdoc = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        		  where d.Applicant_Info__c =: applicant.Id and d.Document_Type__C IN ('Doctor', 'Doctor-Partner') ];
        
		system.debug('@@@@@listdoc: ' + listdoc);
		return listdoc;
	}
	set;}
	
	public List<Intrax_Program_Upload__c> LifeGuardDocList{get{
		List<Intrax_Program_Upload__c> listdoc = new List<Intrax_Program_Upload__c>();
		listdoc = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        		  where d.Applicant_Info__c =: applicant.Id and d.Document_Type__C IN ('Lifeguard') ];
        
		system.debug('@@@@@listdoc: ' + listdoc);
		return listdoc;
	}
	set;}
	
	public Person_Info__c primary{
		get{
			Person_Info__c prim = new Person_Info__c();
			list<Person_Info__c> primaryList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,
													Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c, Date_of_Birth__c,
													Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Overall_Health__c, Physical_Exam_Date__c
													FROM Person_Info__c 
													WHERE Applicant_Info__c =: applicant.id 
													AND Primary_Applicant__c = true limit 1 ];
				
			if(primaryList != null && primaryList.size() > 0){
				prim = primaryList[0];
			}
			system.debug('@@@@@primary: ' + prim);
			return prim;
	}
		set;
	}
	
	public list<sObject> familyList{
		get{
			list<sObject> famList;
			if(key_object == 'Engagement__c'){
				famList = [SELECT Id, Age__c, Name, nick_name__c, Gender__c, Role__c, First_Name__c, Profession__c, Family_Member__c
														FROM Member__c 
														WHERE Account_Name__c =: participant.Account_Id__c 
														AND Role__c IN ('Participant','Parent','Sibling') 
														AND family_member__c = true
														order by Age__c DESC ];
			
				//famList = (list<Member__c>) famList;
			}else{
				famList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,
														Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c,
														Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Family_Role__c, First_Name__c,Profession__c
														FROM Person_Info__c 
														WHERE Applicant_Info__c =: applicant.id 
														AND Role__c IN ('Participant','Parent','Sibling') 
														order by Age__c DESC ];
			}
			system.debug('@@@@@famList: ' + famList);
			return famList;
		}
	}
	
	public list<Person_Info__c> siblingList{get{
		
		list<Person_Info__c> sibList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,
													Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c,Date_of_Birth__c,
													Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Family_Role__c, First_Name__c,Profession__c
													FROM Person_Info__c WHERE Applicant_Info__c =: applicant.id AND Role__c IN ('Participant','Sibling') order by Age__c DESC ];
		system.debug('@@@@@siblingList: ' + sibList);
		return sibList;
	}
	set;}
	
	public Assessment__c asseessmentInterv{
		get{
			Assessment__c ass = new Assessment__c();
			list<Assessment__c> assList;
			if(key_object == 'Engagement__c'){
				assList = [Select Id, Name, Status__c, Assessment_Date__c, PT_Suitability__c, PT_Assessment__c, Participant_Traits__c
												FROM Assessment__c 
												WHERE Engagement__c =: participant.Id 
												AND RecordTypeId =: Constants.ASS_APC_PT_PR_Interview];
			
			}else{
				assList = [Select Id, Name, Status__c, Assessment_Date__c, PT_Suitability__c, PT_Assessment__c, Participant_Traits__c
												FROM Assessment__c 
												WHERE Application__c =: applicant.Id 
												AND RecordTypeId =: Constants.ASS_APC_PT_PR_Interview];
			}
					
			if(assList != null && assList.size() > 0){
				ass = assList[0];
			}
			system.debug('@@@@@asseessmentInterv: ' + ass);
			return ass;
		}	
	}
	
	public DISC__c discInfo {
		get{
			DISC__c disc = new DISC__c();
			list<DISC__c> discInfoList;
			if(key_object == 'Engagement__c'){
				discInfoList = [SELECT AppID__c, D_Score__c, I_Score__c, S_Score__c, C_Score__c, Summary_of_Personality__c, CDescription__c, IDescription__c, DDescription__c, SDescription__c
	     					FROM DISC__c WHERE Engagement__c =: participant.Id order by CreatedDate desc limit 1 ];
			}else{
				discInfoList = [SELECT AppID__c, D_Score__c, I_Score__c, S_Score__c, C_Score__c, Summary_of_Personality__c, CDescription__c, IDescription__c, DDescription__c, SDescription__c
	     					FROM DISC__c WHERE AppID__c =: applicant.Id order by CreatedDate desc limit 1 ];
			}  
	        if(discInfoList.size() > 0){ 
	        	disc = discInfoList[0];
	        }
	        system.debug('@@@@@discInfo: ' + disc);
	        return disc;
		}
		set;
	}
	public list<DISC__c> discInfoList {get;set;}
	
	public Map<String ,Map<String, Intrax_Program_Upload__c>> MapPTVideoThumb {get;set;}
    public Integer MapVideoSize {get;set;}
	
	public String returnURL{
		get{
			string value;
			if(key_object == 'Engagement__c'){
				value = aws_controller.getParticipantPhotoList(new list<Engagement__c>{participant}).get(participant.Id);
			}else{
				value = aws_controller.getParticipantPhotoList(applist).get(applicant.Id);
			}
			return value; 
		}
		set;
	}
	
	public String ChildrenAges{get;set;}
	public String ChildrenTypes{get;set;}
	public list<Experience__c> listExperience{
		get{
			list<Experience__c> listExp;
			if(key_object == 'Engagement__c'){
				listExp = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                    exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                    exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c,
                                    exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                    exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Reference_Language__c,
                                    exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,  exp.Reference_Received__c
                                    FROM Experience__c exp 
                                    WHERE exp.Engagement__c = :participant.Id 
                                    AND IsExperienced__c = true];
			}else {
				listExp = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                    exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                    exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c,
                                    exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                    exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Reference_Language__c,
                                    exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,  exp.Reference_Received__c
                                    FROM Experience__c exp 
                                    WHERE exp.Applicant_Info__c = :applicant.Id AND IsExperienced__c = true];
			}
			
	        Set<String> setAges = new Set<String>();
	        Set<String> setTypes = new Set<String>();
	        list<String> listAges = new list<String>();
        
        
	        for(Experience__c e:listExp){
	        	if(e.Children_Ages__c!=null){
		        	list<String> aux = e.Children_Ages__c.split(';', 0);
		        	system.debug('@@@@@aux: ' + aux);
		        	for(String a:aux){
		        		setAges.add(a);	
		        	}
	        	}
	        	if(e.Experience_Type__c!=null){
		        	setTypes.add(e.Experience_Type__c);	
		        }
	        }
        
	        listAges.addAll(setAges);
	        listAges.sort();
	        system.debug('@@@@@listAges: ' + listAges);
	        ChildrenAges = '';
	        ChildrenTypes = '';
	        if(listAges!=null && listAges.size()>0){
		        for(String sa:listAges){
			    	ChildrenAges += sa + ' yrs, ';	
			    }
	        }
	        if(setTypes!=null && setTypes.size()>0){
		        for(String st:setTypes){
			    	ChildrenTypes += st + ', ';	
			    }
	        }
		    ChildrenAges = ChildrenAges.removeEnd(', ');
		    ChildrenTypes = ChildrenTypes.removeEnd(', ');
	        system.debug('@@@@@ChildrenAges: ' + ChildrenAges);
	        system.debug('@@@@@ChildrenTypes: ' + ChildrenTypes);
	        
	        system.debug('@@@@@listExp: ' + listExp);
	        return listExp;
		}
		set;
	}
	
	public map<String, String> MapExpDetSize{get;set;}
	public map<String, list<Experience_Detail__c>> MapExperienceDet{get;set;}
	public map<String, Boolean> MapExpDetNeed{get;set;}
	/*
	public map<String, list<Experience_Detail__c>> MapExperienceDet{get{
		
		list<Experience__c> listExperienceAux = listExperience; 
		map<String, list<Experience_Detail__c>> MapExpDet = new map<String, list<Experience_Detail__c>>();
		list<Experience_Detail__c> listExpDet = [select p.Id, p.Name, p.Experience_Name__c, p.Date_of_Birth__c, Special_Needs_Description__c, Special_Needs_Indicated__c, Gender__c
                                From Experience_Detail__c p 
                                WHERE p.Experience_Name__c IN :listExperienceAux order by CreatedDate ASC];
        for(Experience__c exp:listExperienceAux){
      		list<Experience_Detail__c> AuxList = new list<Experience_Detail__c>();
            for(Experience_Detail__c expDet:listExpDet){
            	if(expDet.Experience_Name__c==exp.id){
                	AuxList.add(expDet);
                }
            }
            MapExpDet.put(exp.id,AuxList);		
        }
        system.debug('@@@@@MapExperienceDet: ' + MapExpDet);
        return MapExpDet;	
	}set;}
	*/
	
	public list<String> HLightList {
		get{
			list<String> HLList;
			if(key_object == 'Engagement__c'){		
				map<String, list<String>> map_hl = apc_portal_utilities.highLightsBuilder(new list<Engagement__c>{participant});
				HLList = map_hl.get(participant.Id);
			}else{
				HLList = apc_portal_utilities.highLightsBuilder(applicant, primary,
											LifeGuardDocList, siblingList,
				 							listExperience, mapEducation.get('University/College'),
											mapEducation.get('Vocational Training'));	
			}	
        	return HLList;
		}
		set;
	}
	
	public string key_object;
	public Engagement__c participant {get;set;}
	
	public apc_profile_controller(string obj){
		
		key_object = obj;
		
		if(key_object == 'Engagement__c'){
			try{
				participant = [Select Id, Name, Nationality__c, Intrax_Program__c, Age_At_program_Start__c, Swimming_Level__c, Gender__c, Type__c, Actual_Arrival__c, Account_Id__r.FirstName, Account_Id__r.Nick_Name__pc, Account_Id__r.LastName, Intrax_Program_Options__c, Interest_Sports__c, Interest_Fine_Arts__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Special_Diet_Description__c, Allergy_Description__c,
								Language_1__c, Language_2__c, Language_3__c,Language_1_Proficiency__c, Language_2_Proficiency__c , Language_3_Proficiency__c, Interests_Hobbies__c, Driving_Transmission__c, Driving_Snow_Experience__c, Interests_Hobbies_Description__c, Interests_Leisure__c, Allergies_Indicated__c, Special_Diet_Indicated__c, Driving_Experience__c, Driving_Experience_Description__c,
                				(SELECT Id, Name, Swimming_Level__c, Driving_Frequency__c, Drivers_Licence_Acquired__c, Home_Country__c FROM Applicant_Info__r) FROM Engagement__c WHERE Id =: ApexPages.CurrentPage().getParameters().get('Id')
                				];
               	
               	applicant = [SELECT Id, (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Description__c, Contagious_Disease_Description__c, Drug_Dependency_Description__c, Medication_Description__c, Hospitalization_Description__c, Psychiatric_Treatment_Description__c FROM Person_Info__r),
										(SELECT Id, Experience_Type__c FROM Experience__r), Engagement__c, Account__r.Skype_ID__pc, Account__r.personHomePhone, Account__r.personOtherPhone,
										Name, Special_Diet__c, US_Arrival_Date__c, Account__c, Account__r.FirstName, Account__r.LastName, Account__r.personEmail,
							  			Intrax_Program_Options__c, Swimming_Level__c, Childcare_total_hours__c, Home_Country__c, Intrax_Program__c, Type__c, Application_Level__c, Under_2_Total_Hours__c,
							  			Application_Stage__c, Language_Spoken_1__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Drivers_Licence_Expires__c, Driving_Transmission__c,
							  			Driving_Experience__c, Driving_Snow_Experience__c, Interest_Sports__c, Interests_Hobbies__c, Interest_Fine_Arts__c, Interests_Leisure__c, Interests_Hobbies_Description__c,
							  			Allergies_Indicated__c, Allergy_description__c, Special_Diet_Indicated__c, Language_1__c, Language_1_Proficiency__c, Language_2__c, Language_3__c, Language_2_Proficiency__c, Language_3_Proficiency__c,
							  			Lived_Independently__c, US_Experience_Indicated__c, Family_Description__c, Driving_Experience_Description__c
							  			FROM Applicant_Info__c
							  			WHERE Engagement__c =: participant.Id];
				
						
                
			}catch(Exception e){
				system.debug('***** Error!' + e);
				participant = new Engagement__c();
			}
		/* START _ PUT IN A METHOD*/ 	
			//Creating Relation Between Experience and Reference
		mapExperienceRef = new map<String, Experience__c>();
		list<Reference__c> listRef = new list<Reference__c>();
		listRef = getlistChildCareRef();
		if(listRef != null && listRef.size() > 0){
			list<String> rList = new list<String>();
			for(Reference__c r:listRef){
				rList.add(r.Experience_Name__c);
			}
			list<Experience__c> listExp = [SELECT exp.ID, exp.First_Name__c, exp.Last_Name__c,exp.Name, exp.Number_of_Children__c, exp.Children_Ages__c, exp.Special_Needs_Indicated__c, Experience_Category__c
	                                    		FROM Experience__c exp 
	                                    		WHERE exp.Id IN : rList];
				
			for(Reference__c re:listRef){
				for(Experience__c exp:listExp){
					if(re.Experience_Name__c == exp.Id )
						mapExperienceRef.put(re.id, exp);	
				}
			}
		}//END Experience and Reference Mixing process
		
		//Creating MAp for Experience Details
		list<Experience__c> listExperienceAux = listExperience; 
		ExpDetDOBStart = new map<String, String>();
		ExpDetDOBEnd = new map<String, String>();
		map<String, list<Experience_Detail__c>> MapExpDet = new map<String, list<Experience_Detail__c>>();
		MapExpDetSize = new map<String, String>();
		MapExpDetNeed = new map<String, Boolean>();
		list<Experience_Detail__c> listExpDet = [select p.Id, p.Name, p.Experience_Name__c, p.Date_of_Birth__c, Special_Needs_Description__c, Special_Needs_Indicated__c, Gender__c
                                					From Experience_Detail__c p 
                                					WHERE p.Experience_Name__c IN :listExperienceAux 
                                					order by CreatedDate ASC];
        for(Experience__c exp:listExperienceAux){
      		list<Experience_Detail__c> AuxList = new list<Experience_Detail__c>();
            for(Experience_Detail__c expDet:listExpDet){
            	if(expDet.Experience_Name__c==exp.id){
                	AuxList.add(expDet);
                }
                if(expDet.Special_Needs_Indicated__c=='Yes')
                	MapExpDetNeed.put(exp.id,true);
            }
            
            
            for(Experience_Detail__c ed:AuxList){
            	if(ed.Date_of_Birth__c < exp.Start_Date__c){
            		ExpDetDOBStart.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.Start_Date__c)/365.2425)));
            	}else if(ed.Date_of_Birth__c >= exp.Start_Date__c){
            		ExpDetDOBStart.put(ed.id, '0');
            	}
            	ExpDetDOBEnd.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.End_Date__c)/365.2425)));
            	
            }
            MapExpDet.put(exp.id,AuxList);
            MapExpDetSize.put(exp.id,string.valueof(AuxList.size()));			
        }
        
        
        
        system.debug('@@@@@MapExperienceDet: ' + MapExpDet);
        system.debug('@@@@@MapExpDetSize: ' + MapExpDetSize);
        MapExperienceDet = MapExpDet;
		}
		
		/* END _ PUT IN A METHOD*/ 
		
		
	}
	public apc_profile_controller() {
				
		applicant = new Applicant_Info__c();
		MapPTVideoThumb = new Map<String ,Map<String, Intrax_Program_Upload__c>>();
		MapVideoSize=0;
		
		String idpt = ApexPages.CurrentPage().getParameters().get('id');
		if(idpt != null){
			applist = [Select Id, (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Description__c, Contagious_Disease_Description__c, Drug_Dependency_Description__c, Medication_Description__c, Hospitalization_Description__c, Psychiatric_Treatment_Description__c FROM Person_Info__r),
										(SELECT Id, Experience_Type__c FROM Experience__r), Engagement__c, Account__r.Skype_ID__pc, Account__r.personHomePhone, Account__r.personOtherPhone,
										Name, Special_Diet__c, US_Arrival_Date__c, Account__c, Account__r.FirstName, Account__r.LastName, Account__r.personEmail,
							  			Intrax_Program_Options__c, Swimming_Level__c, Childcare_total_hours__c, Home_Country__c, Intrax_Program__c, Type__c, Application_Level__c, Under_2_Total_Hours__c,
							  			Application_Stage__c, Language_Spoken_1__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Drivers_Licence_Expires__c, Driving_Transmission__c,
							  			Driving_Experience__c, Driving_Snow_Experience__c, Interest_Sports__c, Interests_Hobbies__c, Interest_Fine_Arts__c, Interests_Leisure__c, Interests_Hobbies_Description__c,
							  			Allergies_Indicated__c, Allergy_description__c, Special_Diet_Indicated__c, Language_1__c, Language_1_Proficiency__c, Language_2__c, Language_3__c, Language_2_Proficiency__c, Language_3_Proficiency__c,
							  			Lived_Independently__c, US_Experience_Indicated__c, Family_Description__c, Driving_Experience_Description__c
							  			from Applicant_Info__c 
							  			WHERE Id =: idpt];
			
			system.debug('@@@@@applist: ' + applist);
			if(applist != null && applist.size() > 0){
				applicant = applist[0];
			} 
		}
		
		//Creating Relation Between Experience and Reference
		mapExperienceRef = new map<String, Experience__c>();
		list<Reference__c> listRef = new list<Reference__c>();
		listRef = getlistChildCareRef();
		if(listRef != null && listRef.size() > 0){
			list<String> rList = new list<String>();
			for(Reference__c r:listRef){
				rList.add(r.Experience_Name__c);
			}
			list<Experience__c> listExp = [SELECT exp.ID, exp.First_Name__c, exp.Last_Name__c,exp.Name, exp.Number_of_Children__c, exp.Children_Ages__c, exp.Special_Needs_Indicated__c, Experience_Category__c
	                                    FROM Experience__c exp 
	                                    WHERE exp.Id IN : rList];
				
			for(Reference__c re:listRef){
				for(Experience__c exp:listExp){
					if(re.Experience_Name__c == exp.Id )
						mapExperienceRef.put(re.id, exp);	
				}
			}
		}//END Experience and Reference Mixing process
		
		//Creating MAp for Experience Details
		list<Experience__c> listExperienceAux = listExperience; 
		ExpDetDOBStart = new map<String, String>();
		ExpDetDOBEnd = new map<String, String>();
		map<String, list<Experience_Detail__c>> MapExpDet = new map<String, list<Experience_Detail__c>>();
		MapExpDetSize = new map<String, String>();
		MapExpDetNeed = new map<String, Boolean>();
		list<Experience_Detail__c> listExpDet = [select p.Id, p.Name, p.Experience_Name__c, p.Date_of_Birth__c, Special_Needs_Description__c, Special_Needs_Indicated__c, Gender__c
                                From Experience_Detail__c p 
                                WHERE p.Experience_Name__c IN :listExperienceAux order by CreatedDate ASC];
        for(Experience__c exp:listExperienceAux){
      		list<Experience_Detail__c> AuxList = new list<Experience_Detail__c>();
            for(Experience_Detail__c expDet:listExpDet){
            	if(expDet.Experience_Name__c==exp.id){
                	AuxList.add(expDet);
                }
                if(expDet.Special_Needs_Indicated__c=='Yes')
                	MapExpDetNeed.put(exp.id,true);
            }
            
            
            for(Experience_Detail__c ed:AuxList){
            	if(ed.Date_of_Birth__c < exp.Start_Date__c){
            		ExpDetDOBStart.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.Start_Date__c)/365.2425)));
            	}else if(ed.Date_of_Birth__c >= exp.Start_Date__c){
            		ExpDetDOBStart.put(ed.id, '0');
            	}
            	ExpDetDOBEnd.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.End_Date__c)/365.2425)));
            	
            }
            MapExpDet.put(exp.id,AuxList);
            MapExpDetSize.put(exp.id,string.valueof(AuxList.size()));			
        }
        
        
        
        system.debug('@@@@@MapExperienceDet: ' + MapExpDet);
        system.debug('@@@@@MapExpDetSize: ' + MapExpDetSize);
        MapExperienceDet = MapExpDet;
        //END Creating MAp for Experience Detail	
	
	
	}
	
	public list<String> pt_photos{get;set;}
	
	public map<String,list<Education__c>> mapEducation{
		get{		
			list<Education__c> listCollege = new list<Education__c>();
			list<Education__c> listVocational = new list<Education__c>();
			list<Education__c> listSecondary = new list<Education__c>();
			map<String,list<Education__c>> mapAuxEdu = new map<String,list<Education__c>>();
			list<Education__c> listEdu;
			if(key_object == 'Engagement__c'){
				listEdu = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c,Address_Street_1__c,Address_Street_2__c,Phone__c,Phone_Country_Code__c,Program_Type_Other__c,Study_Level__c,City__c,Country__c,Postal_Code__c,State__c,Certification__c
			                              	FROM Education__c WHERE Engagement__c =: participant.Id order by CreatedDate DESC];
	        }else{ 
	        	listEdu = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c,Address_Street_1__c,Address_Street_2__c,Phone__c,Phone_Country_Code__c,Program_Type_Other__c,Study_Level__c,City__c,Country__c,Postal_Code__c,State__c,Certification__c
			                              	FROM Education__c WHERE Applicant_Info__c =: applicant.Id order by CreatedDate DESC];
	        
	        }
	        	
	        for(Education__c edu:listEdu){
	        	if(edu.Institution_Type__c == 'High/Secondary School'){
	        		listSecondary.add(edu);		
	        	}else if(edu.Institution_Type__c == 'University/College'){
	        		listCollege.add(edu);		
	        	}else if(edu.Institution_Type__c == 'Vocational Training'){
	        		listVocational.add(edu);		
	        	}
	        }
	        
	        mapAuxEdu.put('High/Secondary School',listSecondary);
	        mapAuxEdu.put('University/College',listCollege);
	        mapAuxEdu.put('Vocational Training',listVocational);
	        
	        return mapAuxEdu;
		}
        
	}
	
	public map<String, String> getmapLang(){
		map<String, String> mapLang = new map<String, String>();
		if(key_object == 'Engagement__c'){
			if(participant.Language_1__c != null){
			mapLang.put(participant.Language_1__c, participant.Language_1_Proficiency__c);
			}
			if(participant.Language_2__c != null){
				mapLang.put(participant.Language_2__c, participant.Language_2_Proficiency__c);
			}
			if(participant.Language_3__c != null){
				mapLang.put(participant.Language_3__c, participant.Language_3_Proficiency__c);
			}
		}else{
			if(applicant.Language_1__c != null){
				mapLang.put(applicant.Language_1__c, applicant.Language_1_Proficiency__c);
			}
			if(applicant.Language_2__c != null){
				mapLang.put(applicant.Language_2__c, applicant.Language_2_Proficiency__c);
			}
			if(applicant.Language_3__c != null){
				mapLang.put(applicant.Language_3__c, applicant.Language_3_Proficiency__c);
			}
		}
		system.debug('@@@@@mapLang:'+ mapLang);
		return mapLang;
	}
	
	public list<String> listLanguage{
		get{
		
			list<String> listLang = new list<String>();
			//list<String> listLangAux = new list<String>();
			
			if(key_object == 'Engagement__c'){
				if(participant.Language_1__c != null){
					listLang.add(participant.Language_1__c);
				}
				if(participant.Language_2__c != null){
					listLang.add(participant.Language_2__c);
				}
				if(participant.Language_3__c != null){
					listLang.add(participant.Language_3__c);
				}
			}else{
				if(applicant.Language_1__c != null){
					listLang.add(applicant.Language_1__c);
				}
				if(applicant.Language_2__c != null){
					listLang.add(applicant.Language_2__c);
				}
				if(applicant.Language_3__c != null){
					listLang.add(applicant.Language_3__c);
				}
			}
			/*
			if(listLang!=null && listLang.size()>0){
				for(String ll:listLang){
					if(ll == 'English'){
						listLangAux.add(ll);
					}
				}
				for(String ll:listLang){
					if(ll != 'English'){
						listLangAux.add(ll);
					}
				}
			}
			system.debug('@@@@@listLangAux:'+ listLangAux);
			*/
			return listLang;
		}
	}
	
	public list<Reference__c> getlistPersonalRef(){
		list<Reference__c> refList;
		if(key_object == 'Engagement__c'){
			refList = [SELECT id,Applicant_Info__c, Name, Participant_Traits__c, Relation_to_Participant__c, Time_Known__c 
						FROM Reference__c
	                 	WHERE Engagement__c =: participant.Id AND Reference_Status__c = 'Active' 
	                 	AND Reference_Requested__c = true AND (Status__c ='Confirmed' OR Status__c = 'Complete') 
	                 	AND Person_Info__c != null];
		}else{
			refList = [SELECT id,Applicant_Info__c, Name, Participant_Traits__c, Relation_to_Participant__c, Time_Known__c 
						FROM Reference__c
	                 	WHERE Applicant_Info__c =: applicant.Id AND Reference_Status__c = 'Active' 
	                 	AND Reference_Requested__c = true AND (Status__c ='Confirmed' OR Status__c = 'Complete') 
	                 	AND Person_Info__c != null];
		}
		return refList;
	}
	
	public list<Reference__c> getlistChildCareRef(){		
		list<Reference__c> refList;
		if(key_object == 'Engagement__c'){
			refList = [SELECT id,Applicant_Info__c, Name, Participant_Traits__c, Experience_Name__c, Rating__c 
							FROM Reference__c
		                 	WHERE Engagement__c =: participant.Id AND Reference_Status__c = 'Active' AND
		                 	Reference_Requested__c = true AND (Status__c ='Confirmed' OR Status__c = 'Complete') 
		                 	AND Experience_Name__c != null]; 
		}else{
			refList = [SELECT id,Applicant_Info__c, Name, Participant_Traits__c, Experience_Name__c, Rating__c 
							FROM Reference__c
		                 	WHERE Applicant_Info__c =: applicant.Id AND Reference_Status__c = 'Active' AND
		                 	Reference_Requested__c = true AND (Status__c ='Confirmed' OR Status__c = 'Complete') AND Experience_Name__c != null]; 
		}   
		
		return refList;    
	}
	
	public list<String> getParticipantPhotoList(){
    	list<Intrax_Program_Upload__c> photos;
    	if(key_object == 'Engagement__c'){    		
    		photos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
    												WHERE Engagement__c = :participant.Id
    												AND Document_Type__c = 'Participant-Album' limit 5
    												];
    	}else{
    		photos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
    												WHERE Applicant_Info__c = :applicant.Id
    												AND Document_Type__c = 'Participant-Album' limit 5
    												];
    	}
    	list<String> myGUIDs = new list<String>();
    	
    	for(Intrax_Program_Upload__c ipu : photos) myGUIDs.add(ipu.Document_GUID__c);
    				
    	return pt_photos = aws_controller.getPhotoList(myGUIDs);
    }
    
    public void retrieveVideo(){
    	if(key_object == 'Engagement__c'){
	   		MapPTVideoThumb = aws_controller.getVideosParticipant(applicant); 
    	}else{
    		MapPTVideoThumb = aws_controller.getVideosParticipant(participant);
    	}               
	    set<String> mapvidKeys;
	    list<Map<String, Intrax_Program_Upload__c>> mapvidValues;
	                       
	    if(MapPTVideoThumb != null && !MapPTVideoThumb.isEmpty() && !MapPTVideoThumb.values()[0].isEmpty() ){
	    	MapVideoSize = MapPTVideoThumb.size();
	        system.debug('@@@@@### MapVideoSize: ' + MapVideoSize);
	        system.debug('@@@@@### mapvidKeys: ' + mapvidKeys);
	        system.debug('@@@@@### mapvidValues: ' + mapvidValues);
	    }else{
	    	MapVideoSize=0;
	    }
    }
    
    public List<Essay__c> essayList{
        get{        
        	list<Essay__c> eList;
        	if(key_object == 'Engagement__c'){
        		eList = [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                WHERE Engagement__c =: participant.Id
                                and Name != 'Parent Letter'
                                ORDER BY ordinal__c ASC];
        	}else{        
    			eList =  [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                WHERE Applicant_Info__c =: applicant.Id
                                and Name != 'Parent Letter'
                                ORDER BY ordinal__c ASC];
        	}
        	
        	return eList;
        }
     }
     
    public PageReference loadPic(){
     
	    PageReference p;   
	    p = aws_controller.loadPhoto(applicant);   
	    return p; 
    
    }
    
    public boolean interview_scheduled{get;set;}
    
    public boolean hasInterviewInProgress{
    	get{
	    	interview_scheduled = false;
	    	
	    	if(applicant.Engagement__c != null){
	    		Engagement__c pt_eng = [SELECT Id, (SELECT Id, Position_Name__c FROM Matches__r) 
	    									FROM Engagement__c WHERE Id =: applicant.Engagement__c];
	    		
	    		// WE need to identify the HF Position__c
	    		list<Applicant_Info__c> hf_apps = [SELECT Id, Position__c, createdDate 
	    												FROM Applicant_Info__c 
	    												WHERE CreatedBy__c =: userInfo.getUserId() 
	    												ORDER BY CreatedDate DESC];
	    		
	    		if(hf_apps.size() > 0){
	    			Applicant_Info__c hf_app = hf_apps[0];
		    		if(hf_app.Position__c != null){
			    		Position__c hf_pos = [SELECT Id, (SELECT Id FROM Matches__r) FROM Position__c WHERE Id =: hf_app.Position__c];		    		
			    		
			    		for(Match__c m_pt : pt_eng.Matches__r){
			    			for(Match__c m_hf : hf_pos.Matches__r){
			    				if(m_pt.Id == m_hf.Id){
			    					interview_scheduled = true;
			    					break;
			    				}
			    			}
			    		}
		    		}
	    		} 
	    	} 
	    	return interview_scheduled;  		
    	}   	
    }     

}