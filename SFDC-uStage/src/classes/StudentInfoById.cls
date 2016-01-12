@RestResource(urlMapping='/GetStudentsInfoById/*')
global with sharing class StudentInfoById {

    static testMethod void testDoGet(){
    	
    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
        Application_Constants__c ObjJobSetting = Application_Constants__c.getValues('iViewerInfoId_Endpoint');
        if(ObjJobSetting!=null)
        req.requestURI = ObjJobSetting.Value__c; 
		
		 
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		

		List<Map<String, String>> results = StudentInfoById.doGet();
		System.assert(results != null);
		
		for(Map<String, String> applicant : results){
			System.assertNotEquals(applicant, null);
		}
		
		
	}
	
	static testMethod void testPrepareGetResponse(){
	
	 test.startTest();
			 
	  List<Engagement__c> personList = new List<Engagement__c>();
            
      Engagement__c pc = new Engagement__c();                
      pc.Name='name';
      pc.Gender__c = 'M';
      pc.Program_Duration__c = 'Fall Semester';
      pc.Interests_Top__c = 'Badminton';
      
      personList.add(pc);   
      
      
      System.debug('SIIIIIIIZEEEEE : ' + personList.size());
      
      Applicant_Info__c app = new Applicant_Info__c();
      app.Home_Country__c = 'Singapore';
      app.Engagement__c = pc.Id;
	  app.Special_Diet_Indicated__c = 'Yes';
	  //System.debug('SIIIIIIIZEEEEE : ' + personList.size());
	  
	  List<Intrax_Program_Upload__c> ipuList = new List<Intrax_Program_Upload__c>();
	  Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c();
	  ipu.Document_GUID__c = '/ayusa/asdasd';
	  ipuList.add(ipu);
	  ipuList.add(ipu);
	  
	  List<Person_Info__c> parents = new List<Person_Info__c>();
	  
	  Person_Info__c father = new Person_Info__c();
	  father.Profession__c = 'Lawyer';
	  father.Gender__c = 'Male';
	  father.Role__c = 'Parent';
	  
	  Person_Info__c mother = new Person_Info__c();
	  mother.Profession__c = 'Housewife';
	  mother.Gender__c = 'Male';
	  father.Role__c = 'Parent';
	  
	  parents.add(father);
	  parents.add(mother);
	  
	  test.stopTest();
	 
		
	  List<Map<String, String>> mapres = prepareGetResponse(personList, ipuList, parents);
	  System.assertNotEquals(null, mapres);
		
	
	}
	
	static testMethod void testGetIPUs(){
		getIPUs('a0Ue0000000A2gzEAC');
	}
	
	private static List<Intrax_Program_Upload__c> getIPUs(String applicantId){
		return [Select Name, Document_Type__c, Document_Service__c, Document_GUID__c, Applicant_Info__c From Intrax_Program_Upload__c where Applicant_Info__c = :applicantId and Name='profilepic'];
	
	}
	
	static testMethod void testGetParentsList(){
		getParentsList('a0Ue0000000A2gzEAC');
	}
	
	private static List<Person_Info__c> getParentsList(String applicantId){
		return [Select p.Role__c, p.Profession__c, p.Name, p.Gender__c, p.Applicant_Info__c From Person_Info__c p where p.Role__c = 'Parent' and Applicant_Info__r.Id = :applicantId];
		
	}
	
	
	private static List<Map<String, String>> prepareGetResponse(List<Engagement__c> personList, List<Intrax_Program_Upload__c> ipus, List<Person_Info__c> parentsList){
		
		List<Map<String, String>> mapres = new List<Map<String, String>>();
		Map<String,Applicant_Info__c> mapEngApp = new Map<String,Applicant_Info__c>();
        String appId='';
        Set<Id> engIds = new Set<Id>();
        
        for(Engagement__c eng: personList){
        	engIds.add(eng.Id);
        }
                
    	List<Applicant_Info__c> appInfoList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount,Language_spoken_1__c,Language_spoken_2__c,Language_spoken_3__c,Language_spoken_years_1__c,Language_spoken_years_2__c,Language_spoken_years_3__c,Allergies_from_Partner__c,Live_With_Pets__c,Special_Diet_Indicated__c,Special_Diet__c,Double_Placement_Indicated__c,Single_No_Children_Indicated__c,Private_High_School_Indicated__c,English_Summary__c,General_Summary__c FROM Applicant_Info__c WHERE Engagement__c IN:engIds AND Application_Stage__c='Accepted'];
    	if(appInfoList.size()>0){    		    	
	    	for(Applicant_Info__c a: appInfoList){
	    		MapEngApp.put(a.Engagement__c,a);
	    	}
    	}
    	
		for(Engagement__c p: personList){
			
			Map<String, String> infoMap = new Map<String, String>();
			String applicantId;
			Applicant_Info__c appInfoObj = new Applicant_Info__c();
			if(mapEngApp.get(p.Id)!=null){
				appInfoObj = mapEngApp.get(p.Id);
				applicantId= appInfoObj.Id;
			}
			//String applicantId = 'a0Ue0000000A2gf';
			infoMap.put('id',applicantId);
			
			//Intrax_Program_Upload__c ipuc = [Select Name, Document_Type__c, Document_Service__c, Document_GUID__c, Applicant_Info__c From Intrax_Program_Upload__c where Applicant_Info__c = :applicantId];
	
			List<Intrax_Program_Upload__c> result2 = getIPUs(applicantId);
			//infoMap.put('photo_url',ipuc.Document_GUID__c);
			if(result2.size()>0){
				Intrax_Program_Upload__c ipuc = result2.get(0);
				infoMap.put('photo_url',ipuc.Document_GUID__c);
				//ipuc = null;
			}else{
				infoMap.put('photo_url','no photo available');
			}
			
			
			//ipuc=null;
			infoMap.put('first_name',p.Account_Id__r.FirstName);
			//infoMap.put('date_of_birth',String.valueOf(p.Date_Of_Birth__c));
			infoMap.put('age',String.valueOf(p.Age_At_Program_Start__c));//change to age at program start
			infoMap.put('gender',p.Gender__c);
			infoMap.put('country',p.Account_Id__r.Legal_Residence__pc);
			infoMap.put('nationality',p.Nationality__c);
			
			infoMap.put('program_length',p.Program_Duration__c);
			//infoMap.put('program_start',String.valueOf(p.Applicant_Info__r.Engagement_Start__c));
			infoMap.put('interests',p.Interests_Top__c);
			//infoMap.put('hobbies',p.Applicant_info__r.Interests_Top__c);
			infoMap.put('religion',p.Account_Id__r.Religion__pc);
			
			//List<Person_Info__c> parentsList = getParentsList(applicantId);
			
			parentsList = getParentsList(applicantId);
			for(Person_Info__c parent: parentsList){	
				if(parent.Gender__c == 'Male'){	
					infoMap.put('father_occupation',parent.Profession__c);
				}
				if(parent.Gender__c == 'Female'){	
					infoMap.put('mother_occupation',parent.Profession__c);
				}
			}
			
			List<Person_Info__c> siblingsList = [Select p.Role__c, p.Date_Of_Birth__c, p.Age__c, p.Gender__c, p.Applicant_Info__c From Person_Info__c p where p.Role__c = 'Sibling' and Applicant_Info__r.Id = :applicantId];
			
			String siblingsString = '';
			for(Person_Info__c sibling: siblingsList){	
				siblingsString = siblingsString + sibling.Gender__c + ',' + sibling.Age__c + ';';
			}
			
			infoMap.put('siblings',siblingsString);
			
			List<Essay__c> essay = [SELECT Narrative__c,  Ordinal__c FROM Essay__c where Applicant_Info__r.Id = :applicantId and Name ='Student Letter' limit 1];
			List<Essay__c> essay_FuturePlans = [SELECT Narrative__c,  Ordinal__c, Name FROM Essay__c where Applicant_Info__r.Id = :applicantId and Name ='Goals' limit 1];
			
			//infoMap.put('essay',essay.Narrative__c);
			//infoMap.put('future_plans',essay_FuturePlans.Narrative__c);
			
			Essay__c essayFromDB = new Essay__c();
			Essay__c essayFuturePlanFromDB = new Essay__c();
			
			if(essay.size()>0){
				essayFromDB = essay.get(0);				
			}
			if(essay_FuturePlans.size()>0){
				essayFuturePlanFromDB = essay_FuturePlans.get(0);				
			}
			
			infoMap.put('student_letter',essayFromDB.Narrative__c);
			infoMap.put('future_plans',essayFuturePlanFromDB.Narrative__c);
			infoMap.put('languages1',appInfoObj.Language_spoken_1__c);//check from here also
			infoMap.put('languages2',appInfoObj.Language_spoken_2__c);
			infoMap.put('languages3',appInfoObj.Language_spoken_3__c);
			
			infoMap.put('languagesyrs1',appInfoObj.Language_spoken_years_1__c);
			infoMap.put('languagesyrs2',appInfoObj.Language_spoken_years_2__c);
			infoMap.put('languagesyrs3',appInfoObj.Language_spoken_years_3__c);
			
			infoMap.put('allergies',appInfoObj.Allergies_from_Partner__c);
			infoMap.put('live_with_pets',appInfoObj.Live_With_Pets__c);
			if(appInfoObj.Special_Diet_Indicated__c=='YES'){
				infoMap.put('dietary_restrictions','Yes : ' +appInfoObj.Special_Diet__c);
			}else{
				infoMap.put('dietary_restrictions','No');
			}
			infoMap.put('double_placement',appInfoObj.Double_Placement_Indicated__c);
			infoMap.put('no_kids_placement',appInfoObj.Single_No_Children_Indicated__c);
			infoMap.put('private_high_school',appInfoObj.Private_High_School_Indicated__c);
			
			//TODO
			infoMap.put('english_teacher_recommendation',appInfoObj.English_Summary__c);
			infoMap.put('student_summary',appInfoObj.General_Summary__c);
			
			mapres.add(infoMap);
			infoMap = null;
		}
		
		return mapres;
		
	}
	
	
    @HttpGet
    global static List<Map<String, String>> doGet() {
    //global static List<Person_Info__c> doGet() {
    
    	//System.debug('Test logging');
    	
    
    	List<Map<String, String>> mapres = new List<Map<String, String>>();
    	
        RestRequest req = RestContext.request;
        Map <String, String> reqParams = req.params;
        
        //System.debug('REQUEST PARAMS = ' + reqParams);
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String applicantInfoId='';
        
        if(req.requestURI!=null)
    		applicantInfoId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    	
        //List<Account> result = [Select a.PersonBirthdate, a.Languages_Spoken__pc, a.Gender__pc, a.FirstName, a.Citizenship__pc From Account a];
        /*
  		List<Person_Info__c> PI = [SELECT 
		  		Id,
		  		Applicant_Info__r.Id,	
			  	First_Name__c,
			  	Date_Of_Birth__c,
				Gender__c,
				Birth_Country__c,
				Country_of_Residence__c,
				Age__c,
				Age_At_Program_Start__c,
				Nationality__c,
				Applicant_info__r.Home_Country__c,
				Applicant_info__r.Program_Duration__c,
				Applicant_info__r.Engagement_Start__c,
				Applicant_info__r.Interests_Top__c,
				Applicant_info__r.Religion__c,
				Applicant_Info__r.Languages_Spoken__c,
				Applicant_Info__r.Language_spoken_years_3__c,
				Applicant_Info__r.Language_spoken_years_2__c,
				Applicant_Info__r.Language_spoken_years_1__c,
				Applicant_Info__r.Language_spoken_3__c,
				Applicant_Info__r.Language_spoken_2__c,
				Applicant_Info__r.Language_spoken_1__c, 
				Applicant_info__r.Allergies_from_Partner__c,
				Applicant_info__r.Live_With_Pets__c,
				Applicant_info__r.Special_Diet_Indicated__c,
				Applicant_info__r.Special_Diet__c,
				Applicant_info__r.Double_Placement_Indicated__c,
				Applicant_info__r.Single_No_Children_Indicated__c,
				Applicant_Info__r.Application_Level__c,
				Applicant_Info__r.Private_High_School_Indicated__c,
				Applicant_Info__r.RecordTypeId,
				Applicant_Info__r.Type__c,
				Applicant_Info__r.English_Summary__c,
				Applicant_Info__r.General_Summary__c,
				Role__c, 
				Primary_Applicant__c
				FROM Person_Info__c where Primary_Applicant__c = true and Role__c = 'Student' and Applicant_Info__r.Type__c = 'Participant' and Applicant_Info__r.Id = :applicantInfoId];
				*/
				List<Applicant_Info__c> AI = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount,Language_spoken_1__c,Language_spoken_2__c,Language_spoken_3__c,Language_spoken_years_1__c,Language_spoken_years_2__c,Language_spoken_years_3__c,Allergies_from_Partner__c,Live_With_Pets__c,Special_Diet_Indicated__c,Special_Diet__c,Double_Placement_Indicated__c,Single_No_Children_Indicated__c,Private_High_School_Indicated__c,English_Summary__c,General_Summary__c FROM Applicant_Info__c WHERE Id=:applicantInfoId LIMIT 1];
				
				List<Engagement__c> result = new List<Engagement__c>();				
				if(AI.size()>0){
					result = [SELECT Id,Name, Nationality__c, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name, Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Gender__c, Priority_Engagement__c,Age_At_Program_Start__c,Account_Id__r.Religion__pc,Account_Id__r.Legal_Residence__pc FROM Engagement__c WHERE Id=: AI[0].Engagement__r.Id LIMIT 1];
				}
				
				mapres = prepareGetResponse(result, new List<Intrax_Program_Upload__c>(), new List<Person_Info__c>());
		
        return mapres;
    }
  
 
}