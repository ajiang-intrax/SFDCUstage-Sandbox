global without sharing class MapPersonToReferenceMember {
//public without sharing class MapPersonToReferenceMember {

public MapPersonToReferenceMember(){

}

WebService static void MapPersonToRef(String appinfoID, String accountID){
//public static void MapPersonToRef(String appinfoID, String accountID){

        // Get the subject of the Chatter post from the flow
        //String appinfoID = (String) request.inputParameters.get('AppInfoID');
        //String accountID = (String) request.inputParameters.get('AccountID');
         
        // Use the Chatter APIs to post it to the current user's feed
        List<Person_Info__c> personinfo = new List<Person_Info__c>();
        List<Person_Info__c> personinfoRef = new List<Person_Info__c>();
        List<Member__c> member = new List<Member__c>();
        List<Member__c> newmember = new List<Member__c>();
        List<Member__c> memberAux = new List<Member__c>();
        Applicant_Info__c appinfo = new Applicant_Info__c(); 
        Person_Info__c primaryApplicant = new Person_Info__c();
        List<Reference__c> reference = new List<Reference__c>();
        List<Reference__c> newreference = new List<Reference__c>();
        List<Reference__c> referenceAux = new List<Reference__c>();
        
        boolean isUpdate;
               
        system.debug('******appinfoId: ' + appinfoID);
        system.debug('******accountInfoId: ' + accountID);
   
        //getting APC HF Reference Record Type 
        list<RecordType> RClist = [select id, Name from RecordType where SobjectType='Reference__c' and Name='APC PT' Limit 1];
        
        //get Position Id for References       
        
        appinfo = [SELECT Id, Position__c, Type__c, Intrax_Program_Options__c, Intrax_Program__c  from Applicant_Info__c where Id =: appinfoID ];
        
        system.debug('******Applicant_info.Postion__c: ' + appinfo.Position__c);
        
        //get Person_Info list for Family references and Emergency Contacts 
        
        personinfo = [SELECT Id,Applicant_Info__c, Name, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c,
                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c,
                    Country_of_Residence__c, Other_Phone__c, Role_Other__c, Reference_Request_Note__c, Title__c,
                    Residency_Status__c, Work_Supervisor__c, Employer_Name__c, Intrax_Program_Option__c,
                    Special_Needs_Description__c,Special_Needs_Indicated__c, Phone_Type__c
                    from Person_Info__c 
                    where Applicant_Info__c =: appinfoID  and (role__c in ('Parent','Spouse or Partner','Child','Sibling','Other','Friend','Step Parent') or Emergency_Contact_Indicated__c =: 'Yes')];
        
        //get Member list for Family references and Emergency Contacts 
        
        member = [SELECT Name,Account_Name__c, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c,
                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c,
                    Country_of_Residence__c, Other_Phone__c, Role_Other__c, Residency_Status__c, Title__c,
                    Work_Supervisor__c, Employer_Name__c, Intrax_Program_Option__c,
                    Special_Needs_Description__c,Special_Needs_Indicated__c, Phone_Type__c
                    from Member__c
                    where Account_Name__c =: accountID ];
        
        //get Person_Info list for References 
        
        personinfoRef = [SELECT Name,Id,Applicant_Info__c, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c, Reference_Language__c,
                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c, Reference_Request_Note__c, Reference_Contact_Requested__c
                    from Person_Info__c where Applicant_Info__c =: appinfoID  and role__c  =: 'Reference'];
        
        //get Reference list for References 
                    
        reference = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Position__c, Person_Info__c, Applicant_Info__c,
         			Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId, Intrax_Program__c, Type__c
                    from Reference__c where Position__c =: appinfo.Position__c ];             
        
        primaryApplicant = [SELECT Id, Name from Person_Info__c where Applicant_Info__c =: appinfoID  and Primary_Applicant__c  = true ];
        
                    
        //Comparasion condition criteria for person_info
        
        system.debug('***** personinfo.size() = ' + personinfo.size());
        system.debug('***** member.size() = ' + member.size());
        system.debug('***** personinfoRef.size() = ' + personinfoRef.size());
        system.debug('***** reference.size() = ' + reference.size());
        
        //Iteration for Members
        
        for(Person_Info__c p:personinfo){
            
            isUpdate = false;
                       
            Member__c memberNew = new Member__c();
            
            
            if (member.size() > 0){
            
            	for(Member__c m:member){
	            
	            system.debug('*****@@@ p= ' + p);
       			system.debug('*****@@@ m = ' + m);
	                
	            
	            if ((p.First_Name__c == m.First_Name__c && p.Last_Name__c == m.Last_Name__c && p.Email__c == m.Email__c && p.Email__c != null) ||
	            	(p.Name == m.Name && p.Date_Of_Birth__c == m.Date_Of_Birth__c && p.Date_Of_Birth__c !=null)){
	                
	                //updating an old member record                
	                system.debug('***** updating an old member record');
	                m.Role__c = p.Role__c;
	                m.Gender__c = p.Gender__c;
	                m.Email__c = p.Email__c;
	                m.Mobile__c = p.Mobile__c;
	                m.Phone__c = p.Phone__c;
	                m.Profession__c = p.Profession__c;
	                m.Emergency_Contact_Indicated__c = p.Emergency_Contact_Indicated__c;
	                m.Family_Member__c = p.Family_Member__c;
	                m.Country_of_Residence__c = p.Country_of_Residence__c;
	                m.Other_Phone__c = p.Other_Phone__c;
	                m.Role_Other__c = p.Role_Other__c;
	                m.Account_Name__c = accountID;  
	                m.Residency_Status__c = p.Residency_Status__c;
	                m.Title__c = p.Title__c;
	                m.Employer_Name__c = p.Employer_Name__c;
	                m.Work_Supervisor__c = p.Work_Supervisor__c;
	                m.Intrax_Program_Option__c = p.Intrax_Program_Option__c;
	                
	                //new for APC
	                m.Phone_Type__c = p.Phone_Type__c;
	                m.Special_Needs_Indicated__c = p.Special_Needs_Indicated__c;
	                m.Special_Needs_Description__c = p.Special_Needs_Description__c;
	                m.Date_Of_Birth__c = p.Date_Of_Birth__c;
	                
	                // Updating BGC info
	                /*if(m.Background_Check_At__c == null || p.Background_Check_At__c > m.Background_Check_At__c){
	                	m.Background_Check_At__c = p.Background_Check_At__c;
	                	m.Background_Check_By__c = p.Background_Check_By__c;
	                	m.Background_Check_Id__c = p.Background_Check_Id__c;
	                	m.Background_Check_Msg__c = p.Background_Check_Msg__c;
	                	m.Background_Check_Consent_Received__c = p.Background_Check_Consent_Received__c;
	                	m.Background_Check__c = p.Background_Check__c;
	                }*/             
	                memberAux.add(m);
	                isUpdate = true;
	                
	                }
            	}
            
            	if(isUpdate == false){
            	
            	//mapping a new member record            
                
                system.debug('***** 1 mapping a new member record');
                memberNew.Name = p.Name;
                memberNew.First_Name__c = p.First_Name__c;
                memberNew.Last_Name__c = p.Last_Name__c;
                memberNew.Date_Of_Birth__c = p.Date_Of_Birth__c;
                memberNew.Role__c = p.Role__c;
                memberNew.Gender__c = p.Gender__c;
                memberNew.Email__c = p.Email__c;
                memberNew.Mobile__c = p.Mobile__c;
                memberNew.Phone__c = p.Phone__c;
                memberNew.Profession__c = p.Profession__c;
                memberNew.Emergency_Contact_Indicated__c = p.Emergency_Contact_Indicated__c;
                memberNew.Family_Member__c = p.Family_Member__c;
                memberNew.Account_Name__c = accountID;
               	memberNew.Country_of_Residence__c = p.Country_of_Residence__c;
	            memberNew.Other_Phone__c = p.Other_Phone__c;
	            memberNew.Role_Other__c = p.Role_Other__c;
	            memberNew.Residency_Status__c = p.Residency_Status__c;
	            memberNew.Title__c = p.Title__c;
	            memberNew.Employer_Name__c = p.Employer_Name__c;
	            memberNew.Work_Supervisor__c = p.Work_Supervisor__c;
	            memberNew.Intrax_Program_Option__c = p.Intrax_Program_Option__c;
	            // Updating BGC Info
	            /*memberNew.Background_Check_At__c = p.Background_Check_At__c;
            	memberNew.Background_Check_By__c = p.Background_Check_By__c;
            	memberNew.Background_Check_Id__c = p.Background_Check_Id__c;
            	memberNew.Background_Check_Msg__c = p.Background_Check_Msg__c;
            	memberNew.Background_Check_Consent_Received__c = p.Background_Check_Consent_Received__c;
            	memberNew.Background_Check__c = p.Background_Check__c;
                */
                 //new for APC
	            memberNew.Phone_Type__c = p.Phone_Type__c;
	            memberNew.Special_Needs_Indicated__c = p.Special_Needs_Indicated__c;
	            memberNew.Special_Needs_Description__c = p.Special_Needs_Description__c;
                            
                newmember.add(memberNew);          	
            	
            	}
            
            }else{
                
             	//mapping a new member record            
                
                system.debug('***** 2 mapping a new member record');
                
                memberNew.Name = p.Name;
                memberNew.First_Name__c = p.First_Name__c;
                memberNew.Last_Name__c = p.Last_Name__c;
                memberNew.Date_Of_Birth__c = p.Date_Of_Birth__c;
                memberNew.Role__c = p.Role__c;
                memberNew.Gender__c = p.Gender__c;
                memberNew.Email__c = p.Email__c;
                memberNew.Mobile__c = p.Mobile__c;
                memberNew.Phone__c = p.Phone__c;
                memberNew.Profession__c = p.Profession__c;
                memberNew.Emergency_Contact_Indicated__c = p.Emergency_Contact_Indicated__c;
                memberNew.Family_Member__c = p.Family_Member__c;
                memberNew.Account_Name__c = accountID;
                memberNew.Country_of_Residence__c = p.Country_of_Residence__c;
	            memberNew.Other_Phone__c = p.Other_Phone__c;
	            memberNew.Role_Other__c = p.Role_Other__c;
	            memberNew.Residency_Status__c = p.Residency_Status__c;
	            memberNew.Title__c = p.Title__c;
	            memberNew.Employer_Name__c = p.Employer_Name__c;
	            memberNew.Work_Supervisor__c = p.Work_Supervisor__c;
	            memberNew.Intrax_Program_Option__c = p.Intrax_Program_Option__c;
	            
	            // Updating BGC Info
	            /*memberNew.Background_Check_At__c = p.Background_Check_At__c;
            	memberNew.Background_Check_By__c = p.Background_Check_By__c;
            	memberNew.Background_Check_Id__c = p.Background_Check_Id__c;
            	memberNew.Background_Check_Msg__c = p.Background_Check_Msg__c;
            	memberNew.Background_Check_Consent_Received__c = p.Background_Check_Consent_Received__c;
            	memberNew.Background_Check__c = p.Background_Check__c;
                */
                
                //new for APC 
                memberNew.Phone_Type__c = p.Phone_Type__c;
	            memberNew.Special_Needs_Indicated__c = p.Special_Needs_Indicated__c;
	            memberNew.Special_Needs_Description__c = p.Special_Needs_Description__c;
                            
                newmember.add(memberNew);
                                                    
            }
        }                                                                            
        
         //Iteration for References
        
        for(Person_Info__c p:personinfoRef){
            
            isUpdate = false;
                       
            Reference__c referenceNew = new Reference__c();
            
            if (reference.size() > 0){
            
            	for(Reference__c r:reference){
	                if (p.First_Name__c == r.First_Name__c && p.Last_Name__c == r.Last_Name__c && p.Email__c == r.Email__c && r.Applicant_Info__c == appinfo.Id){
	                
	                //updating an old member record                
	                system.debug('***** updating an old reference record');
	                r.Mobile__c = p.Mobile__c; 
	                r.Person_Info__c = p.Id;
	                r.Reference_Request_Note__c = p.Reference_Request_Note__c;
	                                                
	                referenceAux.add(r);
	                isUpdate = true;
	                
	                }
            	}
            
            	if(isUpdate == false){
            	
            	//mapping a new member record            
                
                system.debug('***** 1 mapping a new reference record');
                
                //primaryApplicant = [SELECT Id, Name from Person_Info__c where Applicant_Info__c =: appinfoID  and Primary_Applicant__c  = true ];
                
                referenceNew.Name = p.Name;
                referenceNew.First_Name__c = p.First_Name__c;
                referenceNew.Last_Name__c = p.Last_Name__c;
                referenceNew.Email__c = p.Email__c;
                referenceNew.Phone__c = p.Phone__c;
                referenceNew.Mobile__c = p.Mobile__c;
                referenceNew.Position__c = appinfo.Position__c;
                referenceNew.Reference_Request_Note__c = p.Reference_Request_Note__c; 
                referenceNew.Reference_Requested__c = true;
                referenceNew.Constant_Reference_URL__c = Constants.derivedbaseUrl; 
                referenceNew.Intrax_Program__c = 'AuPairCare';
         		referenceNew.Reference_Status__c = 'Active' ;
        		referenceNew.Reference_Language__c = p.Reference_Language__c;
                referenceNew.Primary_Applicant_Id__c = primaryApplicant.Id;
                referenceNew.Intrax_Program__c = appinfo.Intrax_Program__c;
                referenceNew.Applicant_Info__c = appinfo.Id;
                referenceNew.Person_Info__c = p.Id;
                if(RClist != null && RClist.size()>0){
		        	referenceNew.RecordTypeId = RClist[0].Id ;
		        }
                newreference.add(referenceNew);          	
            	}
            
            }else{
                
             	//mapping a new member record            
                
                system.debug('***** 2 mapping a new reference record');
                
                referenceNew.Name = p.Name;
                referenceNew.First_Name__c = p.First_Name__c;
                referenceNew.Last_Name__c = p.Last_Name__c;
                referenceNew.Email__c = p.Email__c;
                referenceNew.Phone__c = p.Phone__c;
                referenceNew.Position__c = appinfo.Position__c;
                referenceNew.Mobile__c = p.Mobile__c;
                referenceNew.Reference_Request_Note__c = p.Reference_Request_Note__c; 
                referenceNew.Reference_Requested__c = true;
                referenceNew.Constant_Reference_URL__c = Constants.derivedbaseUrl; 
                referenceNew.Intrax_Program__c = 'AuPairCare';
         		referenceNew.Reference_Status__c = 'Active' ;
        		referenceNew.Reference_Language__c = p.Reference_Language__c;
                referenceNew.Primary_Applicant_Id__c = primaryApplicant.Id;
                referenceNew.Intrax_Program__c = appinfo.Intrax_Program__c;
                referenceNew.Applicant_Info__c = appinfo.Id;
                referenceNew.Person_Info__c = p.Id;
                if(RClist != null && RClist.size()>0){
		        	referenceNew.RecordTypeId = RClist[0].Id ;
		        }
                
                newreference.add(referenceNew);
                                                    
            }
        }   
            
        //update old members records; 
        try{
        
        	if (memberAux.size()> 0){
        
        		update(memberAux);
        		system.debug('*****update member OK');
        
        	}
        
        }catch(Exception e){
        
        system.debug(e);
        
        }
        //insert new members records; 
        
        try{
        
        	if (newmember.size()> 0){
        
        		insert(newmember);
        		
        		system.debug('*****insert member OK');
        
        	}
        
        }catch(Exception e){
        
        system.debug(e);
        
        }
        
        //update old reference records;
        
        try{
        
        	if (referenceAux.size()> 0){
        
        		update(referenceAux);
        		system.debug('*****update reference OK');
        
        	}
        
        }catch(Exception e){
        
        system.debug(e);
        
        }
        //insert new reference records; 
        
        try{
        
        	if (newreference.size()> 0){
        
        		insert(newreference);
        		
        		system.debug('*****insert reference OK');
        
        	}
        
        }catch(Exception e){
        
        system.debug(e);
        
        }
       
}
 

}