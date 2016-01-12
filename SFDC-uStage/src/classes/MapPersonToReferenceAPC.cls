public with sharing class MapPersonToReferenceAPC {

public static void MapExperienceToRef(String experienceID){
	
	 system.debug('@@@@@ Inside MapExperienceToRef(String experienceID)');
	
	list<Experience__c> experienceList = new list<Experience__c>();
	Experience__c experience = new Experience__c();
	list<Reference__c> referenceList = new list<Reference__c>();
	List<Reference__c> newreference = new List<Reference__c>();
    List<Reference__c> referenceAux = new List<Reference__c>();
    Reference__c referenceNew = new Reference__c(); 
    Person_Info__c primaryApplicant = new  Person_Info__c();    
	
	try{
	
	list<RecordType> RClist = [select id, Name from RecordType where SobjectType='Reference__c' and Name='APC PT' Limit 1];
	
	experienceList = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                    exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                    exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c,
                                    exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                    exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Frequency__c,
                                    exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,exp.Reference_Language__c
                                    FROM Experience__c exp 
                                    WHERE Id =:experienceID];
    
    if(experienceList != null && experienceList.size()>0){
    
    	experience = experienceList[0];
    	
    	referenceList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
         			Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
         			Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c,Reference_Language__c
                    from Reference__c where Experience_Name__c =: experience.Id AND Reference_Status__c = 'Active'];
                    
        primaryApplicant = [SELECT Id, Name from Person_Info__c where Applicant_Info__c =: experience.Applicant_info__c  and Primary_Applicant__c  = true ];
    }
    
    //Iteration for References
    if(referenceList !=null && referenceList.size()>0){   
        for(Reference__c r:referenceList){
        
        	/*if(r.First_Name__c == experience.First_Name__c 
        		&& r.Last_Name__c == experience.Last_Name__c 
        		&& r.Email__c == experience.Email__c 
        		&& r.Experience_Name__c == experience.Id){
	       */ 	
	        	if(r.Experience_Name__c == experience.Id){
        			
	        	//updating an old member record                
	            system.debug('@@@@@ Updating an old reference record');
	            r.Phone__c = experience.Phone__c; 
	            r.Phone_Country_Code__c = experience.Phone_Country_Code__c;
	            referenceAux.add(r);
	        }
        }   	
            
	}else{
                
    	//mapping a new member record            
        //referenceNew.Reference_Contact_Requested__c = experience.Reference_Contact_Requested__c;
        
        system.debug('@@@@@ Mapping a new reference record');
        system.debug('@@@@@ experience.Experience_Type__c: ' + experience.Experience_Type__c);
        system.debug('@@@@@ experience.First_Name__c: ' + experience.First_Name__c);
        
        if(experience.Experience_Category__c == 'Public/Group'){
        	referenceNew.Name = experience.First_Name__c + ' ' + experience.Last_Name__c;
        }else{
        	referenceNew.Name = experience.Name;
        }
        referenceNew.First_Name__c = experience.First_Name__c;
        referenceNew.Last_Name__c = experience.Last_Name__c;
        referenceNew.Email__c = experience.Email__c;
        referenceNew.Phone__c = experience.Phone__c;
        referenceNew.Phone_Country_Code__c = experience.Phone_Country_Code__c;
        referenceNew.Reference_Request_Note__c = experience.Reference_Request_Note__c; 
        referenceNew.Reference_Requested__c = true;
        referenceNew.Constant_Reference_URL__c = Constants.derivedbaseUrl;
        referenceNew.Intrax_Program__c = 'AuPairCare';
        referenceNew.Applicant_Info__c = experience.Applicant_Info__c;
        referenceNew.Experience_Name__c = experience.Id;
        referenceNew.Reference_Status__c = 'Active' ;
        referenceNew.Reference_Language__c = experience.Reference_Language__c;
        referenceNew.Primary_Applicant_Id__c = primaryApplicant.Id;
        if(RClist != null && RClist.size()>0){
        	referenceNew.RecordTypeId = RClist[0].Id ;
        }
        
        
        newreference.add(referenceNew);
    }
    
	}catch(Exception e){
    	system.debug('@@@@@ Impossible map experience to reference: ' + e);
	}
	
	//update old reference records;
    try{
    	if(referenceAux.size()> 0){
    		update(referenceAux);
        	system.debug('@@@@@ update reference OK');
        }
    }catch(Exception e){
        system.debug('@@@@@ Impossible update existing reference: ' + e);
    }
    
    //insert new reference records; 
    try{
    	if(newreference.size()> 0){
        	insert(newreference);
        	system.debug('@@@@@ insert reference OK');
        }
    }catch(Exception e){
         system.debug('@@@@@ Impossible insert new reference: ' + e);
    }


}//End method MapExperienceToRef(String experienceID)

public static void MapPersonToRef(String personID){
	
	 system.debug('@@@@@ Inside MapPersonToRef(String personID)');
	
	list<Person_Info__c> personinfoList = new list<Person_Info__c>();
	Person_Info__c person = new Person_Info__c();
	list<Reference__c> referenceList = new list<Reference__c>();
	List<Reference__c> newreference = new List<Reference__c>();
    List<Reference__c> referenceAux = new List<Reference__c>();
    Reference__c referenceNew = new Reference__c();    
    Person_Info__c primaryApplicant = new  Person_Info__c();    
	
	try{
	
	list<RecordType> RClist = [select id, Name from RecordType where SobjectType='Reference__c' and Name='APC PT' Limit 1];
	
	personinfoList = [SELECT Id,Applicant_Info__c, Name, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c,
                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c,
                    Country_of_Residence__c, Other_Phone__c, Role_Other__c, Reference_Request_Note__c, Title__c,
                    Residency_Status__c, Work_Supervisor__c, Employer_Name__c, Intrax_Program_Option__c, Reference_Language__c,
                    Special_Needs_Description__c,Special_Needs_Indicated__c, Phone_Type__c, Reference_Contact_Requested__c
                    from Person_Info__c 
                    where Id =: personID];
	
	
    if(personinfoList != null && personinfoList.size()>0){
    
    	person = personinfoList[0];
    	
    	referenceList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
         			Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
         			Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c, Reference_Language__c
                    from Reference__c where Person_Info__c =: person.Id AND Reference_Status__c = 'Active'];
        
        primaryApplicant = [SELECT Id, Name from Person_Info__c where Applicant_Info__c =: person.Applicant_info__c  and Primary_Applicant__c  = true ];
    
    }
    
    //Iteration for References
    if(referenceList !=null && referenceList.size()>0){   
        for(Reference__c r:referenceList){
        
        	/*if(r.First_Name__c == experience.First_Name__c 
        		&& r.Last_Name__c == experience.Last_Name__c 
        		&& r.Email__c == experience.Email__c 
        		&& r.Experience_Name__c == experience.Id){
	       */ 	
	        	if(r.Person_Info__c == person.Id){
        			
	        	//updating an old member record                
	            system.debug('@@@@@ Updating an old reference record');
	            //r.Phone__c = person.Phone__c; 
	            //r.Phone_Country_Code__c = person.Phone_Country_Code__c;
	            referenceAux.add(r);
	        }
        }   	
            
	}else{
                
    	//mapping a new member record            
        //referenceNew.Reference_Contact_Requested__c = experience.Reference_Contact_Requested__c;
        
        system.debug('@@@@@ Mapping a new reference record');
        
        referenceNew.Name = person.Name;
        referenceNew.First_Name__c = person.First_Name__c;
        referenceNew.Last_Name__c = person.Last_Name__c;
        referenceNew.Email__c = person.Email__c;
        //referenceNew.Phone__c = person.Phone__c;
        //referenceNew.Phone_Country_Code__c = person.Phone_Country_Code__c;
        referenceNew.Reference_Request_Note__c = person.Reference_Request_Note__c; 
        referenceNew.Reference_Requested__c = true;
        referenceNew.Constant_Reference_URL__c = Constants.derivedbaseUrl;
        referenceNew.Intrax_Program__c = 'AuPairCare';
        referenceNew.Applicant_Info__c = person.Applicant_Info__c;
        referenceNew.Person_Info__c = person.Id;
        referenceNew.Reference_Status__c = 'Active' ;
        referenceNew.Reference_Language__c = person.Reference_Language__c;
        referenceNew.Primary_Applicant_Id__c = primaryApplicant.Id;
        if(RClist != null && RClist.size()>0){
        	referenceNew.RecordTypeId = RClist[0].Id ;
        }
        
        
        newreference.add(referenceNew);
    }
    
	}catch(Exception e){
    	system.debug('@@@@@ Impossible map experience to reference: ' + e);
	}
	
	//update old reference records;
    try{
    	if(referenceAux.size()> 0){
    		update(referenceAux);
        	system.debug('@@@@@ update reference OK');
        }
    }catch(Exception e){
        system.debug('@@@@@ Impossible update existing reference: ' + e);
    }
    
    //insert new reference records; 
    try{
    	if(newreference.size()> 0){
        	insert(newreference);
        	system.debug('@@@@@ insert reference OK');
        }
    }catch(Exception e){
         system.debug('@@@@@ Impossible insert new reference: ' + e);
    }


}//End method MapPersonToRef(String personID)

}// End Class