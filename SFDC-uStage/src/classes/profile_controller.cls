public without sharing class profile_controller {
	
	public list<Applicant_Info__c> applist{get;set;}
	public Applicant_Info__c applicant{get;set;}
	public map<String, Experience__c> mapExperienceRef{get;set;}
	public map<String, String> ExpDetDOBStart{get;set;}
	public map<String, String> ExpDetDOBEnd{get;set;}
	
	public set<String> favRecords {get;set;}
	
	public Integer num_photos {
		get{
			list<Intrax_Program_Upload__c> photos;
	    	if(key_object == 'Engagement__c'){    		
	    		photos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
	    												WHERE Engagement__c = :participant.Id
	    												AND Document_Type__c = 'Participant-Album' limit 15
	    												];
	    	}else{
	    		photos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
	    												WHERE Applicant_Info__c = :applicant.Id
	    												AND Document_Type__c = 'Participant-Album' limit 15
	    												];
	    	}
		    return photos.size();
		}
		
		set;
	}
	
	public Integer num_videos {
		get{
			list<Intrax_Program_Upload__c> videos;
	    	if(key_object == 'Engagement__c'){    		
	    		videos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
	    												WHERE Engagement__c = :participant.Id
	    												AND Document_Type__c = 'Introductory-Video' limit 5
	    												];
	    	}else{
	    		videos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
	    												WHERE Applicant_Info__c = :applicant.Id
	    												AND Document_Type__c = 'Introductory-Video' limit 5
	    												];
	    	}
		    return videos.size();					
		}	
		set;
	}
	
    public list<User_Preference__c> user_preferences{    	
    	 get{
            if (user_preferences == null){
            	user_preferences = [SELECT Id, User__c, Dismissed_Records__c, Saved_Records__c, Viewed_Records__c, Saved_Searches__c 
            						FROM User_Preference__c 
            						WHERE User__c =: userInfo.getUserId()
                                    AND Object__c =: key_object];
            }
            
            return user_preferences;
        }set;    	
    }
	
/**	public map<String, boolean> isFavoriteId{	
		get{
			map<String, Boolean> isFavoriteIdAux = new map<String, Boolean>();
	    	try{
		    	list<User_Preference__c> up = [SELECT Id, User__c, Saved_Records__c FROM User_Preference__c WHERE 
		    										User__c =: userInfo.getUserId()
		    										AND Object__c = 'Engagement'];
		    											
		    	if(up.size() > 0){ 	
		    		if (up[0].Saved_Records__c != null && up[0].Saved_Records__c != '')
		    		favRecords = (set<String>) json.deserialize(up[0].Saved_Records__c, set<String>.class);
			    	else
			    	favRecords = new set<String>();
		    	}else
		    		favRecords = new set<String>();
		    	if(key_object == 'Engagement__c'){
			    	if(favRecords.contains(applicant.Id)) isFavoriteIdAux.put(applicant.Id, true);
			    	else isFavoriteIdAux.put(applicant.Id, false);
	    		}else if(key_object == 'Applicant_Info__c'){
			    	for(applicant_Info__c a:applist){
			    		if(favRecords.contains(a.Id)){
			    			isFavoriteIdAux.put(a.Id, true);
			    		}else
			    			isFavoriteIdAux.put(a.Id, false);
			    	}
		    	}
	    	}catch(Exception e){
	    		//system.debug('Error getting the favorite records: ' + e);
	    	}
	    	//system.debug('@@@@@isFavoriteId: ' + isFavoriteIdAux);
			return isFavoriteIdAux;
	    	
	    }
		set;
	}
	
	
	
	public Boolean isFavorite{	
		get{
	    	list<User_Preference__c> up = [SELECT Id, User__c, Saved_Records__c FROM User_Preference__c WHERE 
	    										User__c =: userInfo.getUserId()
    											AND Object__c = :key_object];
	    								
	    	if(up.size() > 0){ 	
	    		if (up[0].Saved_Records__c != null && up[0].Saved_Records__c != '') favRecords = (set<String>) json.deserialize(up[0].Saved_Records__c, set<String>.class);
		    	else favRecords = new set<String>();
	    	}else favRecords = new set<String>();
	    	

    		return (favRecords.contains(participant.Id));
		}
		set;
	}
	
	
	*/	
	
	
	public map<String, boolean> isFavoriteId{	
		get{
			map<String, Boolean> isFavoriteIdAux = new map<String, Boolean>();
			
	    	try{
	    					
				list<Selection__c> selection = [Select s.Position__c, s.Interview_End_Date__c, s.Id, s.Engagement__c, s.Favorite__c
												From Selection__c s
												Where s.Intrax_Program__c = 'AuPairCare' 
												And s.Position__c =: myPosition.Id];											 
													
				
				for(Selection__c sel : selection){	    		
					if (sel.Engagement__c != null){						
	    				isFavoriteIdAux.put(sel.Engagement__c,sel.Favorite__c);
	    			}
	    		}
	    		
	    		if (!isFavoriteIdAux.containsKey(participant.Id)){
	    			isFavoriteIdAux.put(participant.Id,false);
	    		}
	    		
			}catch(Exception e){
	    		//system.debug('Error getting the favorite records: ' + e);
	    	}
		    	
	    	//system.debug('@@@@@isFavoriteId: ' + isFavoriteIdAux);
			return isFavoriteIdAux;
		    	
		    }
		set;
		}
	
	public boolean isFavorite{	
		get{
			
	    	try{		
				list<Selection__c> selection = [Select s.Position__c, s.Id, s.Engagement__c, s.Favorite__c
											From Selection__c s
											Where s.Intrax_Program__c = 'AuPairCare' 
											And Position__c =: myPosition.Id
											And Engagement__c =: participant.Id
											ORDER BY CreatedDate DESC
											LIMIT 1];	
				
			 	if (selection.size() > 0){
			 		return selection.get(0).Favorite__c;
			 	}else{			
		    		return false;
			 	}
			 	
			}catch(Exception e){
	    		//system.debug('Error getting the favorite records: ' + e);
	    		return false;
	    	}
		    	

		    }
		set;
		}
	
	public void saveAsFavorite(){	
	    saveSelection (true);
    }
    
    public void removeAsFavorite(){    	
    	saveSelection (false);    	
    }
    
    public void saveSelection(boolean favorite){
    
		Selection__c selection;
		Position__c position = new Position__c();
				
    	try{	
    		myPosition = getMyPosition();														
			selection = [Select Position__c, Id, Engagement__c, Favorite__c
										From Selection__c 
										Where Intrax_Program__c = 'AuPairCare' 
										And Position__c =: myPosition.Id
										And Engagement__c =: participant.Id
										ORDER BY CreatedDate DESC
										LIMIT 1];		
												
			}catch(Exception e){
	    		//system.debug('Error getting the favorite records: ' + e);
	    	}		    	

			if (selection != null) {
				
				selection.Favorite__c = favorite;
				//system.debug('****** UPDATE: ' + selection);
				update selection;
				
			} else {
				//B-02881
				Engagement__c eng = [SELECT Id,Account_Id__r.LastName FROM Engagement__c 
	                                WHERE Id =: participant.Id LIMIT 1];
				selection = new Selection__c (
                    Name = myPosition.Host_Company_Id__r.LastName+' '+ eng.Account_Id__r.LastName,
					Position__c = myPosition.Id,					
					Favorite__c = favorite,
					Engagement__c = [SELECT Id 
	                                FROM Engagement__c 
	                                WHERE Id =: participant.Id LIMIT 1].Id,
					Intrax_Program__c = 'AuPairCare'					
				);
				
				//system.debug('****** INSERT: ' + selection);
				insert selection;
				
			}
    }
		
	public boolean hadInterview{
		get{
			try{
				myPosition = getMyPosition();
	    		list<Selection__c> selection = [Select s.Position__c, s.Id, s.Engagement__c, s.Favorite__c,s.Status__c, s.Interview_Start_Date__c, s.Interview_End_Date__c
											From Selection__c s
											Where s.Intrax_Program__c = 'AuPairCare' 
											And s.Position__c =: myPosition.Id
											And s.Engagement__c =: participant.Id
											ORDER BY CreatedDate DESC
											LIMIT 1 ];											 
													
				
				
	    		if (selection.size() > 0) {
	    			if(selection.get(0).Status__c != null) return true;
	    			else return false;	
	    		}else{
	    			return false;
	    		}	    	
					
			}catch(Exception e){
	    		//system.debug('Error getting the interview records: ' + e);
	    		return false;
	    	}
    	}
    	set;	
	}
	public boolean hasInterviewInProgress{
    	get{
    		
	    	try{
	    		myPosition = getMyPosition();
	    		if(myPosition != null){
	    			list<Selection__c> selection = [Select s.Position__c, s.Id, s.Engagement__c, s.Favorite__c,s.Status__c, s.Interview_Start_Date__c, s.Interview_End_Date__c
											From Selection__c s
											Where s.Intrax_Program__c = 'AuPairCare' 
											And s.Position__c =: myPosition.Id
											And s.Engagement__c =: participant.Id
											ORDER BY CreatedDate DESC
											LIMIT 1 ];											 
													
	    			if (selection.size() > 0) {
	    				return (selection.get(0).Status__c == 'Active');	
	    			}else{
	    				return false;
	    			}
	    	
	    		}else{
	    			return false;
	    		}
			}catch(Exception e){
	    		//system.debug('Error getting the interview records: ' + e);
	    		return false;
	    	}
    	}
    	set;	
    }
    
       
     public Integer InterviewHours {
       get{ 
       //system.debug('debug::InterviewHours');
       Integer interviewHours = 0;
       
       if (participant!=null)
       {
       //system.debug('@@@@@participant.Id: ' + participant.Id);
                //Showing interviewHours Hours
                if (participant.In_Country__c == 'No') {        
                    APC_Program_Settings__c ps = [Select OSAP_Interview_Hours__c From APC_Program_Settings__c];           
                    interviewHours = integer.valueOf(ps.OSAP_Interview_Hours__c);
                }else{
                    APC_Program_Settings__c ps = [Select ICAP_Interview_Hours__c From APC_Program_Settings__c];
                    interviewHours = integer.valueOf(ps.ICAP_Interview_Hours__c);
                }
         //system.debug('debug::interviewHours For Participant'+interviewHours);
       } 
       return   interviewHours;
       } 
    }
    	
		
	public void requestInterview(){
		
		//system.debug('******** requestInterview');
		Selection__c selection;
		//Position__c position = new Position__c();
		Engagement__c engagement = new Engagement__c();
		Datetime end_date;
		
		try{
			myPosition = getMyPosition();
    		selection = [Select s.Position__c, s.Id, s.Engagement__c, s.Favorite__c,s.Status__c, 
									 s.Interview_Start_Date__c, s.Interview_End_Date__c
								From Selection__c s
								Where s.Intrax_Program__c = 'AuPairCare' 
								And s.Position__c =: myPosition.Id
								And s.Engagement__c =: participant.Id
								ORDER BY CreatedDate DESC
								LIMIT 1 ];											 
														
		}catch(Exception e){
    		//system.debug('Error getting the interview records: ' + e);
    	}
    	
    	if (participant.In_Country__c == 'No') {   		
    		APC_Program_Settings__c ps = [Select OSAP_Interview_Hours__c From APC_Program_Settings__c];    		
    		end_date = DateTime.now().addHours(Integer.valueOf(ps.OSAP_Interview_Hours__c));
    	}else{
    		APC_Program_Settings__c ps = [Select ICAP_Interview_Hours__c From APC_Program_Settings__c];
    		end_date = DateTime.now().addHours(Integer.valueOf(ps.ICAP_Interview_Hours__c));
    	}
    	    	
		if (selection != null) {		
    			
			selection.Status__c = 'Active';
			selection.Interview_Start_Date__c = DateTime.now();
			selection.Interview_End_Date__c = end_date;
			selection.Favorite__c = true;
			//system.debug('****** UPDATE: ' + selection);
			update selection;
						
		} else {
            //B-02881
            Engagement__c eng = [SELECT Id,Account_Id__r.LastName 
            						FROM Engagement__c 
	                                WHERE Id =: participant.Id LIMIT 1];
			selection = new Selection__c (
                Name = myPosition.Host_Company_Id__r.LastName+' '+ eng.Account_Id__r.LastName,
				Position__c = myPosition.Id,					
				Favorite__c = true,
				Engagement__c = [SELECT Id 
                                FROM Engagement__c 
                                WHERE Id =: participant.Id LIMIT 1].Id,
				Intrax_Program__c = 'AuPairCare',
				Status__c = 'Active',
				Interview_Start_Date__c = DateTime.now(),
				Interview_End_Date__c = end_date
			);
			
			//system.debug('****** INSERT: ' + selection);
			insert selection;
			
		}	
	}
		
	public PageReference saveAsDismissed(){
    	
	   	if(user_preferences.size() == 0){
    		// We need to create a new record
    		User_Preference__c upnew = new User_Preference__c(User__c = userInfo.getUserId());
    		disRecords = new set<String>();
    		disRecords.add(participant.Id);
    		upnew.Dismissed_Records__c = json.serialize(disRecords);
    		upnew.Object__c = key_object;
    		
    		//system.debug('disRecords: ' + disRecords);    	
    		insert upnew;	
    	}else{
    		// We already have a record for this user --> We need to deserialize the existing data
    		if (user_preferences[0].Dismissed_Records__c != null) disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
    		else disRecords = new set<String>();
    		//system.debug('****** deserialized: ' + disRecords);
    		//if(disRecords.size() > 0){
    			disRecords.add(participant.Id);
    			//system.debug('****** deserialized 2: ' + disRecords);
    			user_preferences[0].Dismissed_Records__c = json.serialize(disRecords);
    			update user_preferences[0];
    		//}
    	}
    	
    	 PageReference pageRef = new PageReference('/apex/apc_hf_search_au_pairs');
    	 pageRef.setRedirect(true); 
    	 return pageRef;
    	
    }
    
    public void removeAsDismissed(){

    	disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
    	//system.debug('***** disRecords: ' + disRecords);
    	//system.debug('***** recordId: ' + participant.Id);
    	if(disRecords.contains(participant.Id)){
    		disRecords.remove(participant.Id);
    		user_preferences[0].Dismissed_Records__c = json.serialize(disRecords);
    		update user_preferences[0];
    	}
    	//system.debug('***** disRecords: ' + disRecords);
    	    										
    }
    
    public Boolean exceedHFInterviewLimit{
    	get{    		
	    	try{
	    		
	    		APC_Program_Settings__c program_settings = [Select Female_PT_Interview_Count_Limit__c, Male_PT_Interview_Count_Limit__c From APC_Program_Settings__c];
	    		    										
				Integer num_interviews = [Select Count()
										  From Selection__c s
										  Where s.Intrax_Program__c = 'AuPairCare'
											And s.Status__c = 'Active'
											And s.Interview_Start_Date__c != null
											And s.Engagement__r.Gender__c =: participant.Gender__c
											And s.Position__c =: myPosition.Id];		
													
				//system.debug('exceedHFInterviewLimit: ' + num_interviews);			
				//system.debug('participant.Gender__c: ' + participant.Gender__c);		
							
				if (num_interviews == null) num_interviews = 0;
								
				if (participant.Gender__c == 'Female') {
					return (num_interviews >= program_settings.Female_PT_Interview_Count_Limit__c);
				}else{	
					return (num_interviews >= program_settings.Male_PT_Interview_Count_Limit__c);
				}
									
			}catch(Exception e){
	    		//system.debug('Error getting the interview records: ' + e);
	    		return true;
	    	}
    	}
    	set;	
    }
    
    
    public Boolean exceedPTInterviewLimit{
    	get{    		
	    	try{
	    		
	    		APC_Program_Settings__c program_settings = [Select OSAP_Interview_Count_Limit__c, ICAP_Interview_Count_Limit__c From APC_Program_Settings__c];

	    		Integer num_interviews = [Select Count()
										  From Selection__c s
										  Where s.Intrax_Program__c = 'AuPairCare'
											And s.Status__c = 'Active'
											And s.Interview_Start_Date__c != null											
											And s.Engagement__c =: participant.Id];							
				
		
				if (participant.In_Country__c == 'No') {
					return (num_interviews >= program_settings.OSAP_Interview_Count_Limit__c);
				}else{
					return (num_interviews >= program_settings.ICAP_Interview_Count_Limit__c);
				}
									
			}catch(Exception e){
	    		//system.debug('Error getting the interview records: ' + e);
	    		return true;
	    	}
    	}
    	set;	
    }
   
    public Position__c incompleteHFapp{get{
        try{
            if(incompleteHFapp == null){
            	Applicant_Info__c applicant;            	
            	List<Applicant_Info__c> applicantsList = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c, Account__r.Id, Account__r.PersonEmail, Account__r.Skype_ID__pc, Account__r.PersonHomePhone
									    	From Applicant_Info__c
									    	Where ((Application_Type__c != 'Original'
									    			And Application_Stage__c = 'Accepted'
									    			And Application_Level__c = 'Main')
									    		or 
									    			(Application_Type__c = 'Original'
									    			And (Application_Stage__c = 'Working' OR Application_Stage__c = 'Accepted')
									    			And Application_Level__c = 'Main'))
									    		And CreatedBy__c =: userInfo.getUserId()
									    	ORDER BY CreatedDate DESC
											LIMIT 1   ];
                if(applicantsList!=null && applicantsList.size()>0){
                    applicant = applicantsList[0];
                }
				String positionId='';
                if(applicant!=null)
                	positionId = applicant.Position__c;
				   
			list<Position__c> incompleteHFapplist = [SELECT Id, Name,
														(select id,Application_Level__c,Application_Type__c 
														from Applicant_Info__r 
														where CreatedBy__c  =: userInfo.getUserId() ORDER BY CreatedDate DESC limit 1),
													 Profile_Complete__c 
                                                     FROM Position__c WHERE Id  =:  positionId
                                                     AND Status__c NOT IN ('Withdrawn')
                                                     ORDER BY CreatedDate DESC
                                                     LIMIT 1];  

                                                         
                if(incompleteHFapplist!=null && incompleteHFapplist.size()>0){
                    incompleteHFapp = incompleteHFapplist[0];
                    //system.debug('@@@@@incompleteHFapp.Id: ' + incompleteHFapp.Name);
                    //system.debug('@@@@@incompleteHFapp.Applicant_Info__Id: ' + incompleteHFapp.Applicant_Info__r[0].id);
                    return incompleteHFapp;
                }else{
                    Position__c pos = new Position__c(); 
                    return pos;
                }
            }else{
                return incompleteHFapp;
            }
        }catch(Exception e){
            //system.debug('Error getting to verify App profile Completion Status: ' + e);
            Position__c pos = new Position__c(); 
            return pos;
        }
    }set;}
    
    public Pagereference HFappCheck(){
    	Applicant_Info__c applicant;            	
        List<Applicant_Info__c> applicantsLists = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c, Applicant_Info__c.Account__r.Id, Account__r.Skype_ID__pc, Account__r.personHomePhone
									    	From Applicant_Info__c
									    	Where ((Application_Type__c = 'Renewal'
									    			And Application_Stage__c = 'Accepted'
									    			And Application_Level__c = 'Main')
									    		or 
									    			(Application_Type__c = 'Original'
									    			And (Application_Stage__c = 'Working' OR application_Stage__c = 'Accepted')
									    			And Application_Level__c = 'Main'))
									    		And CreatedBy__c =: userInfo.getUserId()
									    	ORDER BY CreatedDate DESC
											LIMIT 1   ];
        if(applicantsLists!=null && applicantsLists.size()>0){
            applicant = applicantsLists[0];
        }
        
        String positionId = '';
        if(applicant!=null)
			positionId = applicant.Position__c;
			
        list<Position__c> incompleteHFapplist = [SELECT Id, Name,
                                                 (select id,Application_Level__c,Application_Type__c 
                                                 	from Applicant_Info__r 
                                                 	where CreatedBy__c  =: userInfo.getUserId() ORDER BY CreatedDate DESC limit 1),
                                                 Profile_Complete__c 
                                                 FROM Position__c WHERE Id  =: positionId 
                                                 AND Status__c NOT IN ('Withdrawn') ORDER BY CreatedDate DESC LIMIT 1];
                                                 
        //system.debug('@@@@@incompleteHFapp.Id: ' + incompleteHFapplist[0].Applicant_Info__r[0]);
        
        if(incompleteHFapplist != null && incompleteHFapplist.size() > 0 && incompleteHFapplist[0].Applicant_Info__r[0].Application_Type__c == 'Original'){
            PageReference pageRef = new PageReference('/apex/apc_hf_app_home?id='+incompleteHFapplist[0].Applicant_Info__r[0].id);
            pageRef.setRedirect(true); 
            return pageRef;
            //system.debug('@@@@@incompleteHFapp.Id: ' + incompleteHFapplist[0].Applicant_Info__r[0]);
        }else{
            PageReference pageRef = new PageReference('/apc_hf_app_personal_info?id='+incompleteHFapplist[0].Applicant_Info__r[0].id);
            pageRef.setRedirect(true); 
            return pageRef;
            //system.debug('@@@@@incompleteHFapp.Id: ' + incompleteHFapplist[0].Applicant_Info__r[0]);
        }
        return null;
    }
    
	public set<String> disRecords {get;set;}
	
    public map<String, boolean> isDismissedId{get{
    	map<String, Boolean> isDismissedIdAux = new map<String, Boolean>();

    	if(user_preferences.size() > 0){
	    	if (user_preferences[0].Dismissed_Records__c != null)
	    	disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
	    	else 
	    	disRecords = new set<String>();
	    }else 
	    	disRecords = new set<String>();
	    if(key_object == 'Engagement__c'){
		    if(disRecords.contains(applicant.Id)) isDismissedIdAux.put(applicant.Id, true);
			else isDismissedIdAux.put(applicant.Id, false);
	    }else if(key_object == 'Applicant_Info__c'){	    
		    for(applicant_Info__c a:applist){
		    	if(disRecords.contains(a.Id)){
		    		isDismissedIdAux.put(a.Id, true);
		    	}else 
		    		isDismissedIdAux.put(a.Id, false);
		    }
	    }
	    
	    //system.debug('@@@@@isDismissedId: ' + isDismissedIdAux);
		return isDismissedIdAux;
    }
    set;}
    	
    	
    	
   public Boolean isDismissed{
   	get{
								
    	try{    		
	    	if(user_preferences.size() > 0){
	    		//system.debug('***** ' + user_preferences[0].Dismissed_Records__c);
	    		if (user_preferences[0].Dismissed_Records__c != null) disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
	    		else disRecords = new set<String>();
	    	}else disRecords = new set<String>();

			//system.debug('***** disRecords: ' + disRecords);
	    	return disRecords.contains(participant.Id);
	    			
	    	
    	}catch(Exception e){
	    	//system.debug('***** Exception getDismissedRecords: ' + e);
	    	return false;
	    }
	
    }
    set;}
    
    
    
   
    
	public List<Intrax_Program_Upload__c> phyDocList{get{
		List<Intrax_Program_Upload__c> listdoc = new List<Intrax_Program_Upload__c>();
		listdoc = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        		  where d.Applicant_Info__c =: applicant.Id and d.Document_Type__C IN ('Doctor', 'Doctor-Partner') ];
        
		//system.debug('@@@@@listdoc: ' + listdoc);
		return listdoc;
	}
	set;}
	
	public List<Intrax_Program_Upload__c> LifeGuardDocList{get{
		List<Intrax_Program_Upload__c> listdoc = new List<Intrax_Program_Upload__c>();
		listdoc = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        		  where d.Applicant_Info__c =: applicant.Id and d.Document_Type__C IN ('Lifeguard') ];
        
		//system.debug('@@@@@listdoc: ' + listdoc);
		return listdoc;
	}
	set;}
	
	public Person_Info__c primary{
		get{
			Person_Info__c prim = new Person_Info__c();
			list<Person_Info__c> primaryList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,Phone_Country_Code__c,
													Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c, Date_of_Birth__c, Physical_Disabilities_Description__c,
													Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Overall_Health__c, Physical_Exam_Date__c, Hospitalization_Description__c, Contagious_Disease_Description__c,
													Drug_Dependency_Description__c, Chronic_Disease_Description__c, Illness_Description__c, Medication_Description__c, Psychiatric_Treatment_Description__c
													FROM Person_Info__c 
													WHERE Applicant_Info__c =: applicant.id 
													AND Primary_Applicant__c = true limit 1 ];
				
			if(primaryList != null && primaryList.size() > 0){
				prim = primaryList[0];
			}
			//system.debug('@@@@@primary: ' + prim);
			return prim;
	}
		set;
	}
	
    public Selection__c selection{
            get{
                Selection__c prim = new Selection__c();
                
                list<Selection__c> selectionlist = [Select s.Position__c,s.Id, s.Interview_End_Date__c,s.Engagement__c, s.Favorite__c
                                                    From Selection__c s
                                                    Where s.Intrax_Program__c = 'AuPairCare' 
                                                    And s.Position__c =: myPosition.Id
                                                    And Engagement__c =: participant.Id];
                    
                if(selectionlist != null && selectionlist.size() > 0){
                    prim = selectionlist[0];
                }
                //system.debug('@@@@@selection: ' + prim);
                return prim;
        }
            set;
	}
    
    public boolean siblingsIndicated {get;set;}
    
	public list<sObject> familyList{
		get{
			list<sObject> famList;
			if(key_object == 'Engagement__c'){
				famList = [SELECT Id, Age__c, Name, nick_name__c, Gender__c, Role__c, First_Name__c, Profession__c, Family_Member__c
														FROM Member__c 
														WHERE Account_Name__c =: participant.Account_Id__c 
														AND (Role__c IN ('Participant','Parent','Sibling') 	OR family_member__c = true)
														order by Age__c DESC ];
				for(sObject m : famList){
					if(m.get('Role__c') == 'Sibling') {
						siblingsIndicated = true;
						break;
					}
				}
			
			}else{
				famList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c, Hospitalization_Description__c,
														Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c,
														Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Family_Role__c, First_Name__c,Profession__c
														FROM Person_Info__c 
														WHERE Applicant_Info__c =: applicant.id 
														AND Role__c IN ('Participant','Parent','Sibling') 
														order by Age__c DESC ];
			}
			//system.debug('@@@@@famList: ' + famList);
			return famList;
		}
	}
	
	public list<Person_Info__c> siblingList{get{
		
		list<Person_Info__c> sibList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c, Hospitalization_Description__c ,
													Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c,Date_of_Birth__c,
													Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Family_Role__c, First_Name__c,Profession__c
													FROM Person_Info__c WHERE Applicant_Info__c =: applicant.id AND Role__c IN ('Participant','Sibling') order by Age__c DESC ];
		//system.debug('@@@@@siblingList: ' + sibList);
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
			//system.debug('@@@@@asseessmentInterv: ' + ass);
			return ass;
		}	
	}
	
	public Assessment__c exitInterv{
		get{
	        List<Assessment__c> listAssessment;
			Assessment__c assessment;
			
			if(key_object == 'Engagement__c'){
				listAssessment = [Select  a.Participant_Description__c, a.Match_Break_Reason_Detail__c, a.Vacation_Days_Taken__c, a.Education_Allowance_Owed__c, a.Stipend_Owed_Amount__c
									From Assessment__c a
									Where Engagement__c =: participant.Id  
										and a.RecordType.Name = 'APC Exit Interview'
									ORDER BY CreatedDate DESC
									LIMIT 1];
			
			}else{
				listAssessment = [Select  a.Participant_Description__c, a.Match_Break_Reason_Detail__c, a.Vacation_Days_Taken__c, a.Education_Allowance_Owed__c, a.Stipend_Owed_Amount__c
									From Assessment__c a
									Where Engagement__c =: applicant.Id 
										and a.RecordType.Name = 'APC Exit Interview'
									ORDER BY CreatedDate DESC
									LIMIT 1];
			}
			
			 if(listAssessment.size() > 0){ 
	        	assessment = listAssessment[0];
	        }		
		
			//system.debug('@@@@@exitInterv: ' + assessment);
			return assessment;
		}	
	}
	
	public Double Stipend_Owed_Amount{
		get{
			Double amount = 0;
			AggregateResult[] sumResult;
			
			if(key_object == 'Engagement__c'){
				sumResult = [Select SUM(a.Stipend_Owed_Amount__c) amount
									From Assessment__c a
									Where Engagement__c =: participant.Id  
										and a.RecordType.Name = 'APC Exit Interview'
									];
			
			}else{
				sumResult = [Select SUM(a.Stipend_Owed_Amount__c) amount
									From Assessment__c a
									Where Engagement__c =: applicant.Id 
										and a.RecordType.Name = 'APC Exit Interview'
									];
			}
			amount = (Double)sumResult[0].get('amount');
			
			if(amount < 500) amount = 500 - amount;
			
			return amount;
		}		
	}
	
	public Integer Vacation_Days_Taken{
		get{
			Integer days = 0;
			AggregateResult[] sumResult;
			
			if(key_object == 'Engagement__c'){
				sumResult = [Select SUM(a.Vacation_Days_Taken__c) total
									From Assessment__c a
									Where Engagement__c =: participant.Id  
										and a.RecordType.Name = 'APC Exit Interview'
									];
			
			}else{
				sumResult = [Select SUM(a.Vacation_Days_Taken__c) total
									From Assessment__c a
									Where Engagement__c =: applicant.Id 
										and a.RecordType.Name = 'APC Exit Interview'
									];
			}
			
			days = (Integer)sumResult[0].get('total');
			
			if(days < 10) days = 10 - days;
			
			return days;
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
	        //system.debug('@@@@@discInfo: ' + disc);
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
				//value = aws_controller.getParticipantPhotoList(new list<Engagement__c>{participant}).get(participant.Id);
				try{
						Intrax_Program_Upload__c DocumentLoad = [Select i.Engagement__r.id, i.Position__r.id, i.Document_GUID__c, i.CreatedDate 
																	From Intrax_Program_Upload__c i Where (i.Document_Type__c = 'Media' OR i.Document_Type__c = 'Participant-Photo') 
																	AND Engagement__c =: participant.Id
																	order by i.createdDate limit 1 ];
						//value = aws_controller.getPhotoURL(DocumentLoad.Document_GUID__c.replace('/original/','/thumbnail/'));
                    List<Engagement__c> ptEngList= new List<Engagement__c>();
                    ptEngList.add(participant);
                    participantPhoto = aws_controller.getParticipantIPUURL(ptEngList,False);
                    value=participantPhoto.get(participant.id);
                    //system.debug('debug::::Newvalue=='+value);
					}catch(Exception e){
						value = 'no-picture';
					}
			}else{
				if(key_object == 'Position__c'){	
					try{
						Intrax_Program_Upload__c DocumentLoad = [Select i.Engagement__r.id, i.Position__r.id, i.Document_GUID__c, i.CreatedDate 
																	From Intrax_Program_Upload__c i Where (i.Document_Type__c = 'Media' OR i.Document_Type__c = 'Participant-Photo') 
																	AND Position__c =: profile.Id
																	order by i.createdDate limit 1 ];
					value = aws_controller.getPhotoURL(DocumentLoad.Document_GUID__c.replace('/original/','/thumbnail/'));
					}catch(Exception e){
						value = 'no-picture';
					}
				} else {
					value = aws_controller.getParticipantPhotoList(applist).get(applicant.Id);
				}
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
                                    WHERE exp.Engagement__c = :participant.Id AND exp.Engagement__c != NULL
                                    AND IsExperienced__c = true];
			}else {
				listExp = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                    exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                    exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c,
                                    exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                    exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Reference_Language__c,
                                    exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,  exp.Reference_Received__c
                                    FROM Experience__c exp 
                                    WHERE exp.Applicant_Info__c = :applicant.Id AND exp.Applicant_Info__c != NULL 
                                    AND IsExperienced__c = true];
			}
			
	        Set<String> setAges = new Set<String>();
	        Set<String> setTypes = new Set<String>();
	        list<String> listAges = new list<String>();
        
        
	        for(Experience__c e:listExp){
	        	if(e.Children_Ages__c!=null){
		        	list<String> aux = e.Children_Ages__c.split(';', 0);
		        	//system.debug('@@@@@aux: ' + aux);
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
	        //system.debug('@@@@@listAges: ' + listAges);
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
	        //system.debug('@@@@@ChildrenAges: ' + ChildrenAges);
	        //system.debug('@@@@@ChildrenTypes: ' + ChildrenTypes);
	        
	        //system.debug('@@@@@listExp: ' + listExp);
	        return listExp;
		}
		set;
	}
	
	public list<Experience__c> listICAPExperience{
		get{
			list<Experience__c> listICAPExp = new list<Experience__c>();
			
			for(Experience__c exp:listExperience){
				if(exp.country__c == 'United States'){
					listICAPExp.add(exp);
				}
			}
			
			for(Experience__c exp:listExperience){
				if(exp.country__c != 'United States'){
					listICAPExp.add(exp);
				}
			}
			
			return listICAPExp;
			
			
		}set;
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
        //system.debug('@@@@@MapExperienceDet: ' + MapExpDet);
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
	
	
	
	public list<Member__c> listMember{
		get{
			Account members;
			List<Member__c> listMemeber = new List<Member__c>();
			
			if(key_object == 'Position__c'){
				if(ApexPages.currentPage().getParameters().get('Id') != null){
					List<Account> membersList = [Select (Select Age__c, Email__c, First_Name__c, Gender__c, Last_Name__c, Phone__c, Profession__c, Role__c
							 		From Members__r
							 		Order by Age__c Desc) 
									From Account a 
									Where Id =: profile.Host_Company_Id__c];
                    
                    if(membersList!=null && membersList.size()>0){
                        members = membersList[0];
                    }                    
				}
				else{ 
					myPosition = getMyPosition();
					List<Account> membersList = [Select (Select Age__c, Email__c, First_Name__c, Gender__c, Last_Name__c, Phone__c, Profession__c, Role__c
							 		From Members__r
							 		Order by Age__c Desc) 
									From Account a 
									Where a.Id =: myPosition.Host_Company_Id__c ];
                    
                    if(membersList!=null && membersList.size()>0){
                        members = membersList[0];
                    }
				}
			}
			
			for(Member__c m : members.Members__r){
    			listMemeber.add(m);
    		}
			
	        return listMemeber;
		}
		set;
	}
	public Position__c myPosition{get;set;}
	public Position__c getMyPosition(){
		try{
            Applicant_Info__c applicant;
			List<Applicant_Info__c> appList = [Select Id, (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Description__c, Contagious_Disease_Description__c, Drug_Dependency_Description__c, Medication_Description__c, Hospitalization_Description__c, Psychiatric_Treatment_Description__c FROM Person_Info__r),
											(SELECT Id, Experience_Type__c FROM Experience__r), Engagement__c, Account__r.Skype_ID__pc, Account__r.personHomePhone, Account__r.personOtherPhone,
											Name, Engagement_Start__c, Special_Diet__c, US_Arrival_Date__c, Account__c, Account__r.FirstName, Account__r.LastName, Account__r.personEmail, Account__r.Id,
								  			Intrax_Program_Options__c, Swimming_Level__c, Childcare_total_hours__c, Home_Country__c, Intrax_Program__c, Type__c, Application_Level__c, Under_2_Total_Hours__c,
								  			Application_Stage__c, Language_Spoken_1__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Drivers_Licence_Expires__c, Driving_Transmission__c, Brothers_Indicated__c, Sisters_Indicated__c,
								  			Driving_Experience__c, Driving_Snow_Experience__c, Interest_Sports__c, Interests_Hobbies__c, Interest_Fine_Arts__c, Interests_Leisure__c, Interests_Hobbies_Description__c,
								  			Allergies_Indicated__c, Allergy_description__c, Special_Diet_Indicated__c, Language_1__c, Language_1_Proficiency__c, Language_2__c, Language_3__c, Language_2_Proficiency__c, Language_3_Proficiency__c,
								  			Lived_Independently__c, US_Experience_Indicated__c, Family_Description__c, Driving_Experience_Description__c,Extension_Departure_Airport__c, Drivers_wChildren_Indicated__c, Drivers_Accident_Indicated__c,Position__c,
								  			Drivers_Accident_Detail__c, Drivers_US_Licence_Expiration__c, Drivers_US_Licence_State__c, Height__c, Weight__c, Application_Type__c
								  			From Applicant_Info__c
	                                        Where Application_Level__c = 'Main' 
	                                        AND (Application_Stage__c != 'Cancelled' AND Application_Stage__c != 'Declined' AND Application_Stage__c != 'Declined - Agent')
									        And CreatedBy__c =: userInfo.getUserId()
									    	ORDER BY CreatedDate DESC
											LIMIT 1   ];
			
			//system.debug('****** ' + applicant.Account__r.FirstName);
														
			/* D - 01824 
			Applicant_Info__c applicant = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c 
									    	From Applicant_Info__c
	                                       Where ((Application_Type__c = 'Renewal'
	                                               And Application_Stage__c = 'Accepted'
	                                               And Application_Level__c = 'Main')
	                                              or 
	                                              (Application_Type__c = 'Original'
	                                               And Application_Level__c = 'Main'
	                                               And (Application_Stage__c = 'Working' OR Application_Stage__c = 'Accepted')
	                                              )
	                                              or 
	                                              (Application_Type__c = 'Rematch'
	                                               And Application_Level__c = 'Main'
	                                               And (Application_Stage__c = 'Working' OR Application_Stage__c = 'Accepted')
	                                              )
	                                             )
									    		And CreatedBy__c =: userInfo.getUserId()
									    	ORDER BY CreatedDate DESC
											LIMIT 1   ];
							*/			
            
            if(appList!=null && appList.size()>0){
                applicant = appList[0];
            }
            String id='';
            if(applicant!=null)
				id = applicant.Position__c;			
			
            Position__c position;
            
			List<Position__c> positionList = [SELECT Id, Name, Host_Company_Id__r.IsPersonAccount, Host_Company_Id__r.Gender__pc, Host_Company_Id__r.Skype_ID__pc, Host_Company_Id__r.PhotoUrl, Host_Company_Id__r.Phone, Host_Company_Id__r.PersonMailingStreet, 
										Host_Company_Id__r.PersonMailingState, Host_Company_Id__r.PersonMailingPostalCode, Host_Company_Id__r.PersonMailingCountry, Host_Company_Id__r.PersonMailingCity, 
										Host_Company_Id__r.PersonEmail, Host_Company_Id__r.Nick_Name__pc, Host_Company_Id__r.Name, Host_Company_Id__r.FirstName, Host_Company_Id__r.LastName, Pets__c, Pet_Types__c,
										Interests_Leisure__c, Interests_Hobbies__c, Interest_Sports__c, Interest_Fine_Arts__c, Status__c, Host_Company_Id__r.Age__pc, State__c, City__c
										FROM Position__c
										WHERE Id  =:  id
										AND Status__c NOT IN ('Closed', 'Filled', 'Withdrawn')
										ORDER BY CreatedDate DESC
										LIMIT 1   ];
            if(positionList!=null && positionList.size()>0){
                position = positionList[0];
            }					
			//system.debug('@@@@@ getMyPosition: ' + position);
			return position;	
		}catch(Exception e){
            system.debug('******** Exception: ' + e);  
            return null;      
        } 
	}	
	
	
	public string key_object;
	public Engagement__c participant {get;set;}
	public Position__c profile{get;set;}
	public List<String> listPet{get;set;}
	
		
	
	public profile_controller(string obj){
		
		key_object = obj;
		
		participant = new Engagement__c();
		applicant = new Applicant_Info__c();
		MapPTVideoThumb = new Map<String ,Map<String, Intrax_Program_Upload__c>>();
		MapVideoSize=0;
		
		//myPosition = getMyPosition();	
				
		if(key_object == 'Position__c'){
			try{				
				if(ApexPages.currentPage().getParameters().get('Id') != null){
					List<Applicant_Info__c> applicantList = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c, Account__r.Id, Account__r.Skype_ID__pc
								    	From Applicant_Info__c
                                        Where Application_Level__c = 'Main' 
                                        AND (Application_Stage__c != 'Cancelled' AND Application_Stage__c != 'Declined' AND Application_Stage__c != 'Declined - Agent')
								        And CreatedBy__c =: userInfo.getUserId()
								    	ORDER BY CreatedDate DESC
										LIMIT 1   ];
                    
                    if(applicantList!=null && applicantList.size()>0){
                       applicant =  applicantList[0];
                    }
											
					List<Position__c> profileList = [SELECT Id, Name, Host_Company_Id__c,Host_Company_Id__r.IsPersonAccount, Host_Company_Id__r.Gender__pc, Host_Company_Id__r.Skype_ID__pc, Host_Company_Id__r.PhotoUrl, Host_Company_Id__r.Phone, Host_Company_Id__r.PersonMailingStreet, 
										Host_Company_Id__r.PersonMailingState, Host_Company_Id__r.PersonMailingPostalCode, Host_Company_Id__r.PersonMailingCountry, Host_Company_Id__r.PersonMailingCity, 
										Host_Company_Id__r.PersonEmail, Host_Company_Id__r.Nick_Name__pc, Host_Company_Id__r.Name, Host_Company_Id__r.FirstName, Host_Company_Id__r.LastName, Pets__c, Pet_Types__c,
										Interests_Leisure__c, Interests_Hobbies__c, Interest_Sports__c, Interest_Fine_Arts__c, Status__c, Host_Company_Id__r.Age__pc, State__c, City__c
								FROM Position__c
								WHERE Id =: ApexPages.currentPage().getParameters().get('Id')
								LIMIT 1];
                    
                    if(profileList!=null && profileList.size()>0){
                        profile = profileList[0];
                    }
                    
				}else{					
					profile = getMyPosition();	
				}
		        			  
				//system.debug('***** profile:' + profile);
		       	listPet = new List<String>();
		       			        			  
		        if (profile.Pets__c == 'Yes' && profile.Pet_Types__c != null)	{
		        	listPet = profile.Pet_Types__c.split(';');
		        }	
		    }catch(Exception e){
				system.debug('***** Error!' + e);
				profile = new Position__c();
			}
		}
		
		else if(key_object == 'Engagement__c'){
			try{
				participant = [Select Id, Name, Engagement_Type__c, Placement_Status__c, Special_Needs_Indicated__c, Infant_Specialized_Circulated__c, Nationality__c, Engagement_Start__c, Intrax_Program__c, Age_At_program_Start__c, Swimming_Level__c, Gender__c, Type__c, Actual_Arrival__c, Account_Id__r.FirstName, Account_Id__r.Nick_Name__pc, Account_Id__r.LastName, Intrax_Program_Options__c, Interest_Sports__c, Interest_Fine_Arts__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Special_Diet_Description__c, Allergy_Description__c,
								Language_1__c, Language_2__c, Language_3__c,Language_1_Proficiency__c, Language_2_Proficiency__c , Language_3_Proficiency__c, Interests_Hobbies__c, Driving_Transmission__c, Driving_Snow_Experience__c, Interests_Hobbies_Description__c, Interests_Leisure__c, Engagement_End__c, Childcare_Total_Hours__c, Account_Id__r.Age__pc,
								Allergies_Indicated__c, Special_Diet_Indicated__c, Driving_Experience__c, Driving_Experience_Description__c, OwnerId, Interview_Availability__c, Special_Diet__c, In_Country__c, Pets_Allergy_Indicated__c, Pet_Allergy_Types__c, Pets_Allergy_Description__c, Earliest_Match_Date__c, Latest_Match_Date__c,
								Extension_Departure_Airport__c, Drivers_wChildren_Indicated__c, Drivers_Licence_Expires__c, Drivers_Accident_Indicated__c, Drivers_Accident_Detail__c, US_Drivers_Licence_State__c, US_Drive_wChildren_Indicated__c, US_Drivers_Licence_Issued__c, US_Drivers_Licence_Expiry_Date__c, US_Drivers_Accident_Indicated__c, US_Drivers_Accident_Detail__c, US_Car_Type_Experience__c, Special_Needs_Circulated__c,
                				(SELECT Id, Name, Swimming_Level__c, Driving_Frequency__c, Drivers_Licence_Acquired__c, Home_Country__c FROM Applicant_Info__r) 
                				FROM Engagement__c 
                				WHERE Id =: ApexPages.CurrentPage().getParameters().get('Id')
                				];
               	
               	applicant = [SELECT Id, (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Description__c, Contagious_Disease_Description__c, Drug_Dependency_Description__c, Medication_Description__c, Hospitalization_Description__c, Psychiatric_Treatment_Description__c FROM Person_Info__r),
										(SELECT Id, Experience_Type__c FROM Experience__r), Engagement__c, Account__r.Skype_ID__pc, Account__r.personHomePhone, Account__r.personOtherPhone,
										Name, Engagement_Start__c, Special_Diet__c, US_Arrival_Date__c, Account__c, Account__r.FirstName, Account__r.LastName, Account__r.personEmail, Account__r.Id,
							  			Intrax_Program_Options__c, Swimming_Level__c, Childcare_total_hours__c, Home_Country__c, Intrax_Program__c, Type__c, Application_Level__c, Under_2_Total_Hours__c,
							  			Application_Stage__c, Language_Spoken_1__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Drivers_Licence_Expires__c, Driving_Transmission__c, Brothers_Indicated__c, Sisters_Indicated__c,
							  			Driving_Experience__c, Driving_Snow_Experience__c, Interest_Sports__c, Interests_Hobbies__c, Interest_Fine_Arts__c, Interests_Leisure__c, Interests_Hobbies_Description__c,
							  			Allergies_Indicated__c, Allergy_description__c, Special_Diet_Indicated__c, Language_1__c, Language_1_Proficiency__c, Language_2__c, Language_3__c, Language_2_Proficiency__c, Language_3_Proficiency__c,
							  			Lived_Independently__c, US_Experience_Indicated__c, Family_Description__c, Driving_Experience_Description__c,Extension_Departure_Airport__c, Drivers_wChildren_Indicated__c, Drivers_Accident_Indicated__c,
							  			Drivers_Accident_Detail__c, Drivers_US_Licence_Expiration__c, Drivers_US_Licence_State__c, Height__c, Weight__c, Application_Type__c
							  			FROM Applicant_Info__c
							  			WHERE Engagement__c =: participant.Id];
				//system.debug('****** NAME: ' + applicant.Account__r.FirstName);
			}catch(Exception e){
				//system.debug('***** Error!' + e);
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
		
		//system.debug('***** mapExperienceRef' + mapExperienceRef);
		
		
		//Creating MAp for Experience Details
		list<Experience__c> listExperienceAux = listExperience; 
		ExpDetDOBStart = new map<String, String>();
		ExpDetDOBEnd = new map<String, String>();
		map<String, list<Experience_Detail__c>> MapExpDet = new map<String, list<Experience_Detail__c>>();
		MapExpDetSize = new map<String, String>();
		MapExpDetNeed = new map<String, Boolean>();
		list<Experience_Detail__c> listExpDet = [select p.Id, p.Name, p.Experience_Name__c, p.Date_of_Birth__c, Special_Needs_Description__c, Special_Needs_Indicated__c, Gender__c, Age_At_Start__c, Age_At_End__c, Child_Age_at_Start__c, Child_Age_At_End__c
                                					From Experience_Detail__c p 
                                					WHERE p.Experience_Name__c IN :listExperienceAux 
                                					order by CreatedDate ASC];
        //system.debug('***** listExpDet: ' + listExpDet);
         //system.debug('***** listExperienceAux: ' + listExperienceAux);
        for(Experience__c exp:listExperienceAux){
      		list<Experience_Detail__c> AuxList = new list<Experience_Detail__c>();
            for(Experience_Detail__c expDet:listExpDet){
            	if(expDet.Experience_Name__c==exp.id){
                	AuxList.add(expDet);
                }
                if(expDet.Special_Needs_Indicated__c == 'Yes')
                	MapExpDetNeed.put(exp.id,true);
                else MapExpDetNeed.put(exp.id,false);
            }
            
            
            for(Experience_Detail__c ed:AuxList){            	
        		ExpDetDOBStart.put(ed.id, 'no-data');
        		ExpDetDOBEnd.put(ed.id, 'no-data');
            }
            
            for(Experience_Detail__c ed:AuxList){
            	if(ed.Date_of_Birth__c != null && exp.Start_Date__c != null){            		           	 
	            	if(ed.Date_of_Birth__c < exp.Start_Date__c){
	            		ExpDetDOBStart.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.Start_Date__c)/365.2425)));
	            	}else if(ed.Date_of_Birth__c >= exp.Start_Date__c){
	            		ExpDetDOBStart.put(ed.id, '0');
	            	}
	            	
		            if(ed.Date_Of_Birth__c != NULL && exp.End_Date__c != NULL){
	            		ExpDetDOBEnd.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.End_Date__c)/365.2425)));
		            }
            	}else{             		
            		//if(ed.Child_Age_At_Start__c != null) ExpDetDOBStart.put(ed.Id, string.valueOf(integer.valueOf(ed.Child_Age_At_Start__c)));         
            		//if(ed.Child_Age_At_End__c != null) ExpDetDOBEnd.put(ed.Id, string.valueOf(integer.valueOf(ed.Child_Age_At_End__c)));
            		if(ed.Child_Age_At_Start__c != null) ExpDetDOBStart.put(ed.Id, string.valueOf(ed.Child_Age_At_Start__c));      
            		if(ed.Child_Age_At_End__c != null) ExpDetDOBEnd.put(ed.Id, string.valueOf(ed.Child_Age_At_End__c));              			
            	}
            	
            }
            MapExpDet.put(exp.id,AuxList);
            MapExpDetSize.put(exp.id,string.valueof(AuxList.size()));			
        }
        
        
        
        //system.debug('@@@@@MapExperienceDet: ' + MapExpDet);
        //system.debug('@@@@@MapExpDetSize: ' + MapExpDetSize);
        MapExperienceDet = MapExpDet;
        
		}
		
		/* END _ PUT IN A METHOD*/ 
		
	}
	public profile_controller() {
		
		participant = new Engagement__c();
		applicant = new Applicant_Info__c();
		MapPTVideoThumb = new Map<String ,Map<String, Intrax_Program_Upload__c>>();
		MapVideoSize=0;
		
		Id myId = (Id)ApexPages.CurrentPage().getParameters().get('id');
		/*
		Schema.SObjectType token = myId.getSObjectType();
		Schema.DescribeSObjectResult dr = token.getDescribe();
		key_object = dr.getName();
		*/
		
		key_object = 'Engagement__c';		
		
		//myPosition = getMyPosition();		
		
		if(key_object == 'Engagement__c'){
			participant = [Select Id, Name, Engagement_Type__c, Special_Needs_Indicated__c, Nationality__c, Engagement_Start__c, Intrax_Program__c, Age_At_program_Start__c, Swimming_Level__c, Gender__c, Type__c, Actual_Arrival__c, Account_Id__r.FirstName, Account_Id__r.Nick_Name__pc, Account_Id__r.LastName, Intrax_Program_Options__c, Interest_Sports__c, Interest_Fine_Arts__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Special_Diet_Description__c, Allergy_Description__c,
								Language_1__c, Language_2__c, Language_3__c,Language_1_Proficiency__c, Language_2_Proficiency__c , Language_3_Proficiency__c, Interests_Hobbies__c, Driving_Transmission__c, Driving_Snow_Experience__c, Interests_Hobbies_Description__c, Interests_Leisure__c, Allergies_Indicated__c, Special_Diet_Indicated__c, Driving_Experience__c, Driving_Experience_Description__c, Account_Id__r.Age__pc, Special_Needs_Circulated__c,
                				(SELECT Id, Name, Swimming_Level__c, Driving_Frequency__c, Drivers_Licence_Acquired__c, Home_Country__c FROM Applicant_Info__r), Childcare_Total_Hours__c, Drivers_Licence_Expires__c, OwnerId, Interview_Availability__c, Special_Diet__c, In_Country__c, Infant_Specialized_Circulated__c
                				FROM Engagement__c
                				WHERE Id =: myId
                				];
            //system.debug('debug::controller.participant'+participant); 	
           	applicant = [SELECT Id, (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Description__c, Contagious_Disease_Description__c, Drug_Dependency_Description__c, Medication_Description__c, Hospitalization_Description__c, Psychiatric_Treatment_Description__c FROM Person_Info__r),
									(SELECT Id, Experience_Type__c FROM Experience__r), Engagement_Start__c, Engagement__c, Account__r.Skype_ID__pc, Account__r.personHomePhone, Account__r.personOtherPhone,
									Name, Special_Diet__c, US_Arrival_Date__c, Account__c, Account__r.FirstName, Account__r.LastName, Account__r.personEmail, Account__r.Id,
						  			Intrax_Program_Options__c, Swimming_Level__c, Childcare_total_hours__c, Home_Country__c, Intrax_Program__c, Type__c, Application_Level__c, Under_2_Total_Hours__c,
						  			Application_Stage__c, Language_Spoken_1__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Drivers_Licence_Expires__c, Driving_Transmission__c,
						  			Driving_Experience__c, Driving_Snow_Experience__c, Interest_Sports__c, Interests_Hobbies__c, Interest_Fine_Arts__c, Interests_Leisure__c, Interests_Hobbies_Description__c,
						  			Allergies_Indicated__c, Allergy_description__c, Special_Diet_Indicated__c, Language_1__c, Language_1_Proficiency__c, Language_2__c, Language_3__c, Language_2_Proficiency__c, Language_3_Proficiency__c,
						  			Lived_Independently__c, US_Experience_Indicated__c, Family_Description__c, Driving_Experience_Description__c, Brothers_Indicated__c, Sisters_Indicated__c
						  			FROM Applicant_Info__c
						  			WHERE Engagement__c =: participant.Id];
		}else if(key_object == 'Applicant_Info__c'){
			applist = [Select Id, (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Description__c, Contagious_Disease_Description__c, Drug_Dependency_Description__c, Medication_Description__c, Hospitalization_Description__c, Psychiatric_Treatment_Description__c FROM Person_Info__r),
										(SELECT Id, Experience_Type__c FROM Experience__r), Engagement__c, Account__r.Skype_ID__pc, Account__r.personHomePhone, Account__r.personOtherPhone,
										Name, Engagement_Start__c, Special_Diet__c, US_Arrival_Date__c, Account__c, Account__r.FirstName, Account__r.LastName, Account__r.personEmail, Account__r.Id,
							  			Intrax_Program_Options__c, Swimming_Level__c, Childcare_total_hours__c, Home_Country__c, Intrax_Program__c, Type__c, Application_Level__c, Under_2_Total_Hours__c,
							  			Application_Stage__c, Language_Spoken_1__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Drivers_Licence_Expires__c, Driving_Transmission__c,
							  			Driving_Experience__c, Driving_Snow_Experience__c, Interest_Sports__c, Interests_Hobbies__c, Interest_Fine_Arts__c, Interests_Leisure__c, Interests_Hobbies_Description__c,
							  			Allergies_Indicated__c, Allergy_description__c, Special_Diet_Indicated__c, Language_1__c, Language_1_Proficiency__c, Language_2__c, Language_3__c, Language_2_Proficiency__c, Language_3_Proficiency__c,
							  			Lived_Independently__c, US_Experience_Indicated__c, Family_Description__c, Driving_Experience_Description__c
							  			FROM Applicant_Info__c 
							  			WHERE Id =: myId];
			
			//system.debug('@@@@@applist: ' + applist);
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
                else MapExpDetNeed.put(exp.id,false);
            }
            
            
            for(Experience_Detail__c ed:AuxList){
            	
            	ExpDetDOBStart.put(ed.Id, 'no-data');
            	ExpDetDOBEnd.put(ed.Id, 'no-data');
            	if(ed.Date_of_Birth__c != null && exp.Start_Date__c != null){
	            	if(ed.Date_of_Birth__c < exp.Start_Date__c){
	            		ExpDetDOBStart.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.Start_Date__c)/365.2425)));
	            	}else if(ed.Date_of_Birth__c >= exp.Start_Date__c){
	            		ExpDetDOBStart.put(ed.id, '0');
	            	}
            	}else{
            		ExpDetDOBStart.put(ed.id, '0');
            	}
            	if(ed.Date_of_Birth__c != null && exp.End_Date__c != null){
	            	ExpDetDOBEnd.put(ed.id, string.valueof(Math.Floor(ed.Date_Of_Birth__c.daysBetween(exp.End_Date__c)/365.2425)));
            	}else {
            		ExpDetDOBEnd.put(ed.id, '0');
            	}
	            	
            	
            }
            MapExpDet.put(exp.id,AuxList);
            MapExpDetSize.put(exp.id,string.valueof(AuxList.size()));			
        }
        
        
        
        //system.debug('@@@@@MapExperienceDet: ' + MapExpDet);
        //system.debug('@@@@@MapExpDetSize: ' + MapExpDetSize);
        MapExperienceDet = MapExpDet;
        //END Creating MAp for Experience Detail	

	}
	
	
	
	public map<String,list<Education__c>> mapEducation{
		get{		
			list<Education__c> listCollege = new list<Education__c>();
			list<Education__c> listVocational = new list<Education__c>();
			list<Education__c> listSecondary = new list<Education__c>();
			map<String,list<Education__c>> mapAuxEdu = new map<String,list<Education__c>>();
			list<Education__c> listEdu;
			if(key_object == 'Engagement__c'){
				listEdu = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c,Address_Street_1__c,Address_Street_2__c,Phone__c,Phone_Country_Code__c,Program_Type_Other__c,Study_Level__c,City__c,Country__c,Postal_Code__c,State__c,Certification__c
			                              	FROM Education__c WHERE Engagement__c =: participant.Id AND Engagement__c != NULL order by CreatedDate DESC];
	        }else{ 
	        	listEdu = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c,Address_Street_1__c,Address_Street_2__c,Phone__c,Phone_Country_Code__c,Program_Type_Other__c,Study_Level__c,City__c,Country__c,Postal_Code__c,State__c,Certification__c
			                              	FROM Education__c WHERE Applicant_Info__c =: applicant.Id AND Applicant_Info__c != NULL order by CreatedDate DESC];
	        
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
	
	public boolean languages_indicated{
		get{
			return (participant.Language_1__c != null || participant.Language_2__c != null || participant.Language_3__c !=  null);
		}
		set;
	}
	
	public map<String, String> getmapLang(){
		map<String, String> mapLang = new map<String, String>();
		for(string lang : listLanguage){
			mapLang.put(lang, 'no-proficiency');
		}
		try{					
			if(key_object == 'Engagement__c'){
				if(participant.Language_1__c != null && participant.Language_1_Proficiency__c != '' && participant.Language_1_Proficiency__c != null){					
					mapLang.put(participant.Language_1__c, participant.Language_1_Proficiency__c);
				}
				if(participant.Language_2__c != null && participant.Language_2_Proficiency__c != '' && participant.Language_2_Proficiency__c != null){					 
					mapLang.put(participant.Language_2__c, participant.Language_2_Proficiency__c);
				}
				if(participant.Language_3__c != null && participant.Language_3_Proficiency__c != '' && participant.Language_3_Proficiency__c != null){					
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
			//system.debug('@@@@@mapLang:'+ mapLang);
			return mapLang;
		}catch(Exception e){
			//system.debug('********* MapLang Exception: ' + e);
			return mapLang;
		} 
	}
	
	public list<String> listLanguage{
		get{
		
			list<String> listLang = new list<String>();
			
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
			//system.debug('**** listLang: ' + listLang);
			return listLang;
		}
	}
	
	public list<Reference__c> getlistPersonalRef(){
		list<Reference__c> refList;
		if(key_object == 'Engagement__c'){
			refList = [SELECT id,Applicant_Info__c, Name, Participant_Traits__c, Relation_to_Participant__c, Time_Known__c, Rating__c 
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
		                 	WHERE Engagement__c =: participant.Id AND Engagement__c != NULL
		                 	AND Reference_Status__c = 'Active' AND
		                 	Reference_Requested__c = true AND (Status__c ='Confirmed' OR Status__c = 'Complete') 
		                 	AND Experience_Name__c != null]; 
		}else{
			refList = [SELECT id,Applicant_Info__c, Name, Participant_Traits__c, Experience_Name__c, Rating__c 
							FROM Reference__c
		                 	WHERE Applicant_Info__c =: applicant.Id AND Applicant_Info__c != NULL AND Reference_Status__c = 'Active' AND 
		                 	Reference_Requested__c = true AND (Status__c ='Confirmed' OR Status__c = 'Complete') AND Experience_Name__c != null]; 
		}   
		
		return refList;    
	}
		
	public Map<String, String> photoList{get;set;}
    public Map<String, String> participantPhoto{get;set;}
		
	public Map<String, String> getParticipantPhotoList(){
			list<Intrax_Program_Upload__c> photos;
			photoList = new Map<String, String>();
			List<Engagement__c> ptEngList = new List<Engagement__c>();
	    	if(key_object == 'Engagement__c'){    		
	    		photos = [SELECT Document_GUID__c, Description__c FROM Intrax_Program_Upload__c 
	    												WHERE Engagement__c = :participant.Id
	    												AND Document_Type__c = 'Participant-Album' limit 15
	    												];
	    		ptEngList.add(participant);
	    	}else if(key_object == 'Position__c'){
	    		photos = [SELECT Document_GUID__c, Description__c FROM Intrax_Program_Upload__c 
	    												WHERE Position__c = : profile.Id
	    												AND Document_Type__c = 'Participant-Album' limit 15
	    												];
	    	}else {
	    		photos = [SELECT Document_GUID__c, Description__c FROM Intrax_Program_Upload__c 
	    												WHERE Applicant_Info__c = :applicant.Id
	    												AND Document_Type__c = 'Participant-Album' limit 15
	    												];
	    	}

			Map<String, String> myGUIDs = new Map<String, String>();
	    	
	    	
	    	
	    	if(key_object != 'Engagement__c'){
	    		for(Intrax_Program_Upload__c ipu : photos) myGUIDs.put(ipu.Document_GUID__c, ipu.Description__c);
		    	photoList = aws_controller.getPhotoListWithDesc(myGUIDs);
	    	}
	    	else{
	    		aws_controller.noOfAPPhotos = 15;
	    		photoList = aws_controller.getParticipantIPUURL(ptEngList,true);
	    		//photoList = aws_controller.getPhotoListWithDesc(myGUIDs);
	    	}
			//system.debug('+-+-+-+- photoList: ' + photoList);
	    	return photoList;	    	
	}
	
	
/*	public list<String> getParticipantPhotoList(){
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
    }*/
    
    public void retrieveVideo(){
    	if(key_object == 'Engagement__c'){
	   		MapPTVideoThumb = aws_controller.getVideosParticipant(participant); 
    	}else{
    		MapPTVideoThumb = aws_controller.getVideosParticipant(applicant);
    	}               
	    set<String> mapvidKeys;
	    list<Map<String, Intrax_Program_Upload__c>> mapvidValues;
	                       
	    if(MapPTVideoThumb != null && !MapPTVideoThumb.isEmpty() && !MapPTVideoThumb.values()[0].isEmpty() ){
	    	MapVideoSize = MapPTVideoThumb.size();
	        //system.debug('@@@@@### MapVideoSize: ' + MapVideoSize);
	        //system.debug('@@@@@### mapvidKeys: ' + mapvidKeys);
	        //system.debug('@@@@@### mapvidValues: ' + mapvidValues);
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
                                AND Engagement__c != NULL
                                AND Name != 'Parent Letter'
                                ORDER BY ordinal__c ASC];
        	}else{
        		
        		if(key_object == 'Position__c'){
        			eList = [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                WHERE Position__c =: profile.Id
                                AND Position__c != NULL
                                ORDER BY ordinal__c ASC];
        		}else{        
    				eList =  [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                WHERE Applicant_Info__c =: applicant.Id
                                AND Applicant_Info__c != NULL
                                AND Name != 'Parent Letter'
                                ORDER BY ordinal__c ASC]; 
        		}        		
        		
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
    
   /* public boolean hasInterviewInProgress{
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
    }*/
    
    
    public User currentUser{
        get{        
        	User user = [SELECT Id, User_Interests__c, Type__c FROM User WHERE Id =: UserInfo.getUserId()];
        	return user;
        }
    }
    
    
    public PageReference saveParticipant(){
	    //system.debug('@@@@@inside saveParticipant');
	    update participant;
	    
	    participant = [SELECT Id, Name, Engagement_Type__c, Placement_Status__c, Special_Needs_Indicated__c, Infant_Specialized_Circulated__c, Nationality__c, Engagement_Start__c, Intrax_Program__c, Age_At_program_Start__c, Swimming_Level__c, Gender__c, Type__c, Actual_Arrival__c, Account_Id__r.FirstName, Account_Id__r.Nick_Name__pc, Account_Id__r.LastName, Intrax_Program_Options__c, Interest_Sports__c, Interest_Fine_Arts__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, Special_Diet_Description__c, Allergy_Description__c,
								Language_1__c, Language_2__c, Language_3__c,Language_1_Proficiency__c, Language_2_Proficiency__c , Language_3_Proficiency__c, Interests_Hobbies__c, Driving_Transmission__c, Driving_Snow_Experience__c, Interests_Hobbies_Description__c, Interests_Leisure__c, Engagement_End__c, Childcare_Total_Hours__c, Account_Id__r.Age__pc,
								Allergies_Indicated__c, Special_Diet_Indicated__c, Driving_Experience__c, Driving_Experience_Description__c, OwnerId, Interview_Availability__c, Special_Diet__c, In_Country__c, Pets_Allergy_Indicated__c, Pet_Allergy_Types__c, Pets_Allergy_Description__c, Earliest_Match_Date__c, Latest_Match_Date__c,
								Extension_Departure_Airport__c, Drivers_wChildren_Indicated__c, Drivers_Licence_Expires__c, Drivers_Accident_Indicated__c, Drivers_Accident_Detail__c, US_Drivers_Licence_State__c, US_Drive_wChildren_Indicated__c, US_Drivers_Licence_Issued__c, US_Drivers_Licence_Expiry_Date__c, US_Drivers_Accident_Indicated__c, US_Drivers_Accident_Detail__c, US_Car_Type_Experience__c, Special_Needs_Circulated__c,
                				(SELECT Id, Name, Swimming_Level__c, Driving_Frequency__c, Drivers_Licence_Acquired__c, Home_Country__c FROM Applicant_Info__r) FROM Engagement__c WHERE Id =: ApexPages.CurrentPage().getParameters().get('Id')
                				];

	    return null;
    } 
    
	public Date firstAvailableArrivalDate{
	get{
		try{
			APC_ArrivalDates__c arrivalDates =  [Select US_Arrival__c, Match_Request_Deadline__c
											   From APC_ArrivalDates__c
											   Where Match_Request_Deadline__c > :date.today()
											   Order By Match_Request_Deadline__c Asc
											   Limit 1];
											   
			return arrivalDates.US_Arrival__c;
		
		}catch(Exception e){
	   		//system.debug('Error getting arrival dates: ' + e);			
	   		return date.today();
		}
	}set;
	}
    
    
    public void saveVisit(){
        //system.debug('****** saveVisit'); 
        
        set<String> viewRecords = new set<String>();
             
        if(user_preferences.size() == 0){
            // We need to create a new record
            User_Preference__c upnew = new User_Preference__c(User__c = userInfo.getUserId());          
            viewRecords.add(participant.Id);
            upnew.Viewed_Records__c = json.serialize(viewRecords);
            upnew.Object__c = key_object;
            
            //system.debug('viewRecords: ' + viewRecords);        
            insert upnew;   
        }else{
            // We already have a record for this user --> We need to deserialize the existing data
            if (user_preferences[0].Viewed_Records__c != null) {
                 viewRecords = (set<String>) json.deserialize(user_preferences[0].Viewed_Records__c, set<String>.class);
            }
            
            //system.debug('****** deserialized: ' + viewRecords);
            
            if (!viewRecords.contains(participant.Id)) {
                viewRecords.add(participant.Id);
                //system.debug('****** deserialized 2: ' + viewRecords);
                user_preferences[0].Viewed_Records__c = json.serialize(viewRecords);
                update user_preferences[0];
                
                Engagement__c engagement = [Select Id, Portal_Views_Count__c FROM Engagement__c WHERE Id =: participant.Id];
        
                if (engagement.Portal_Views_Count__c == null) {
                    engagement.Portal_Views_Count__c = 1;
                }else{
                    engagement.Portal_Views_Count__c = engagement.Portal_Views_Count__c + 1 ;
                }                                       
                
                update engagement;
            }           
        } 
            
    }

}