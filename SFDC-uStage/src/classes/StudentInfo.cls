@RestResource(urlMapping='/GetStudentsInfo/*')
global with sharing class StudentInfo {
    
    
    static testMethod void testDoGet(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Application_Constants__c ObjJobSetting = Application_Constants__c.getValues('iViewerInfo_Endpoint');
        if(ObjJobSetting!=null)
        req.requestURI = ObjJobSetting.Value__c;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        

        List<Map<String, String>> results = StudentInfo.doGet();
        System.assert(results != null);
        
        for(Map<String, String> applicant : results){
            System.assertNotEquals(applicant, null);
            
        }
        
        List<Person_Info__c> result = [SELECT 
                Id,
                Applicant_Info__r.Id,   
                First_Name__c,
                Date_Of_Birth__c,
                Gender__c,
                Birth_Country__c,
                Applicant_info__r.Home_Country__c,
                Applicant_info__r.Program_Duration__c,
                Applicant_info__r.Engagement_Start__c,
                Applicant_info__r.Interests_Top__c,
                Applicant_info__r.Religion__c,
                Applicant_Info__r.Languages_Spoken__c, 
                Applicant_info__r.Allergies_Indicated__c,
                Applicant_info__r.Live_With_Pets__c,
                Applicant_info__r.Special_Diet__c,
                Applicant_info__r.Double_Placement_Indicated__c,
                Applicant_info__r.Single_No_Children_Indicated__c,
                Applicant_Info__r.Application_Level__c,
                Applicant_Info__r.Private_High_School_Tuition__c,
                Applicant_Info__r.RecordTypeId,
                Applicant_Info__r.Type__c,
                Role__c, 
                Primary_Applicant__c
                FROM Person_Info__c where Primary_Applicant__c = true and Role__c = 'Student' and Applicant_Info__r.Type__c = 'Participant'];
        
        
        
        
    }
    
    static testMethod void testGetList(){
        List<Person_Info__c> personList = StudentInfo.getList();
        System.assertNotEquals(null, personList);   
    
    }
    
    private static List<Person_Info__c> getList(){
        
        return [SELECT 
                Id,
                Applicant_Info__r.Id,   
                First_Name__c,
                Date_Of_Birth__c,
                Gender__c,
                Birth_Country__c,
                Country_of_Residence__c,
                Applicant_info__r.Home_Country__c,
                Applicant_info__r.Program_Duration__c,
                Applicant_info__r.Engagement_Start__c,
                Applicant_info__r.Interests_Top__c,
                Applicant_info__r.Religion__c,
                Applicant_Info__r.Languages_Spoken__c, 
                Applicant_info__r.Allergies_Indicated__c,
                Applicant_info__r.Live_With_Pets__c,
                Applicant_info__r.Special_Diet__c,
                Applicant_info__r.Double_Placement_Indicated__c,
                Applicant_info__r.Single_No_Children_Indicated__c,
                Applicant_Info__r.Application_Level__c,
                Applicant_Info__r.Private_High_School_Tuition__c,
                Applicant_Info__r.RecordTypeId,
                Applicant_Info__r.Type__c,
                Role__c, 
                Primary_Applicant__c
                FROM Person_Info__c where Primary_Applicant__c = true and Role__c = 'Student' and Applicant_Info__r.Type__c = 'Participant']; //add flag check if applicant be shown or not
    
    }
    
    
    static testMethod void testPrepareGetResponse(){
        
      List<Person_Info__c> personList = new List<Person_Info__c>();
      Applicant_Info__c app = new Applicant_Info__c();
      app.Home_Country__c = 'Singapore';
      
      Person_Info__c pc = new Person_Info__c();
      pc.Applicant_Info__r = app;
      
      pc.Birth_Country__c = 'Singapore';
      pc.First_Name__c ='name';
      pc.Gender__c = 'M';
      
      personList.add(pc);   
      
      System.debug('SIIIIIIIZEEEEE : ' + personList.size());
      
      List<Intrax_Program_Upload__c> ipuList = new List<Intrax_Program_Upload__c>();
      Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c();
      ipu.Document_GUID__c = '/ayusa/asdasd';
      ipuList.add(ipu);
      
        
      List<Map<String, String>> mapres = prepareGetResponse(personList, ipuList);
      System.assertNotEquals(null, mapres);
        
    
    }
    
    
    
    private static List<Map<String, String>> prepareGetResponse(List<Person_Info__c> personList, List<Intrax_Program_Upload__c> ipus){
        List<Map<String, String>> mapres = new List<Map<String, String>>();     
        
        for(Person_Info__c p: personList){
            Map<String, String> infoMap = new Map<String, String>();
            String applicantId= p.Applicant_Info__r.Id;
            //String applicantId = 'a0Ue0000000A2gf';
            infoMap.put('id',applicantId);
            
            //Intrax_Program_Upload__c ipuc = [Select Name, Document_Type__c, Document_Service__c, Document_GUID__c, Applicant_Info__c From Intrax_Program_Upload__c where Applicant_Info__c = :applicantId];
    
            ipus = getIPUs(applicantId);
            //infoMap.put('photo_url',ipuc.Document_GUID__c);
            if(ipus.size()>0){
                Intrax_Program_Upload__c ipuc = ipus.get(0);
                infoMap.put('photo_url',ipuc.Document_GUID__c);
                //ipuc = null;
            }else{              
                infoMap.put('photo_url','no photo available');
            }
            
            //ipuc=null;
            infoMap.put('first_name',p.First_Name__c);
            infoMap.put('date_of_birth',String.valueOf(p.Date_Of_Birth__c));
            infoMap.put('sex',p.Gender__c);
            infoMap.put('country',p.Applicant_info__r.Home_Country__c);
            infoMap.put('program_length',p.Applicant_Info__r.Program_Duration__c);
            infoMap.put('program_start',String.valueOf(p.Applicant_Info__r.Engagement_Start__c));
            //infoMap.put('program_start','');
            infoMap.put('interests',p.Applicant_info__r.Interests_Top__c);
            infoMap.put('hobbies',p.Applicant_info__r.Interests_Top__c);
            infoMap.put('religion',p.Applicant_info__r.Religion__c);
            infoMap.put('father_occupation','');
            infoMap.put('mother_occupation','');
            infoMap.put('siblings','');
            
            //Essay__c essay = [SELECT Narrative__c,  Ordinal__c FROM Essay__c where Applicant_Info__r.Id = :p.Applicant_Info__r.Id limit 1];
            //Essay__c essay_FuturePlans = [SELECT Narrative__c,  Ordinal__c, Name FROM Essay__c where Applicant_Info__r.Id = :p.Applicant_Info__r.Id and Name ='Goals' limit 1];
            
            //infoMap.put('essay',essay.Narrative__c);
            //infoMap.put('future_plans',essay_FuturePlans.Narrative__c);
            infoMap.put('languages',p.Applicant_Info__r.Languages_Spoken__c);
            infoMap.put('allergies',p.Applicant_info__r.Allergies_Indicated__c);
            infoMap.put('live_with_pets',p.Applicant_info__r.Live_With_Pets__c);
            infoMap.put('dietary_restrictions',p.Applicant_info__r.Special_Diet__c);
            infoMap.put('double_placement',p.Applicant_info__r.Double_Placement_Indicated__c);
            infoMap.put('no_kids_placement',p.Applicant_info__r.Single_No_Children_Indicated__c);
            infoMap.put('tuition_private_school',p.Applicant_Info__r.Private_High_School_Tuition__c);
            infoMap.put('english_teacher_recommendation','');
            infoMap.put('partner_recommendation','');
            
            mapres.add(infoMap);
            infoMap = null;
        }
        
        return mapres;
    }
    
    @HttpGet
    global static List<Map<String, String>> doGet() {
        List<Map<String, String>> mapres = new List<Map<String, String>>();
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        List<Person_Info__c> result = getList();
        
        mapres = prepareGetResponse(result, new List<Intrax_Program_Upload__c>());
        
        return mapres;
    }
    
    
  
    static testMethod void testDoPost(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Application_Constants__c ObjJobSetting = Application_Constants__c.getValues('iViewerInfo_Endpoint');
        if(ObjJobSetting!=null)
        req.requestURI = ObjJobSetting.Value__c; 
       // req.requestURI = Constants.GetStudentsInfoURI;  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.addParameter('country', 'Singapore');
        req.addParameter('gender', 'M');
        req.addParameter('ages', '18');
        RestContext.response = res;
        

        List<Map<String, String>> results = StudentInfo.doPost(null, null, null,'1','0');
        System.assertNotEquals(results, null);
        results = null;
        results = StudentInfo.doPost('Singapore', 'M', '18,22', '1','0');
        System.assertNotEquals(results, null);
        
        results = null;
        results = StudentInfo.doPost('Singapore', 'M', null, '1','0');
        System.assertNotEquals(results, null);
        
        results = null;
        results = StudentInfo.doPost('Singapore', null, null, '1','0');
        System.assertNotEquals(results, null);
        
        results = null;
        results = StudentInfo.doPost(null, 'M', '18', '1','0');
        System.assertNotEquals(results, null);
        
        results = null;
        results = StudentInfo.doPost(null, null, '18', '1','0');
        System.assertNotEquals(results, null);
        
        results = null;
        results = StudentInfo.doPost(null, 'M', null, '1','0');
        System.assertNotEquals(results, null);
        
        
        results = null;
        results = StudentInfo.doPost('Singapore', null, '18,21', '1','0');
        System.assertNotEquals(results, null);
        
        
    }
    
    static testMethod void testPreparePostResponse(){
        
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
      
      List<String> agesList = new List<String>();
      agesList.add('23');
      List<Intrax_Program_Upload__c> ipuList = new List<Intrax_Program_Upload__c>();
      Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c();
      ipuList.add(ipu);
      //should be changed again.later  
      List<Map<String, String>> mapres = StudentInfo.preparePostResponse(personList, agesList, '23', ipuList, 10);
      System.assertNotEquals(null, mapres);
        
    
    }
    
    private static List<Intrax_Program_Upload__c> getIPUs(String applicantId){
        return [Select Name, Document_Type__c, Document_Service__c, Document_GUID__c, Applicant_Info__c From Intrax_Program_Upload__c where Applicant_Info__c = :applicantId and Name='profilepic'];
    
    }
    
    private static List<Map<String, String>> preparePostResponse(List<Engagement__c> personList, List<String> agesList, String ages, List<Intrax_Program_Upload__c> ipus, Integer totalRecordCount){
        List<Map<String, String>> mapres = new List<Map<String, String>>();
        Map<String,String> mapEngApp = new Map<String,String>();
        String appId='';
        Set<Id> engIds = new Set<Id>();
        
        for(Engagement__c eng: personList){
        	engIds.add(eng.Id);
        }
                
    	List<Applicant_Info__c> appInfoList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount,Language_spoken_1__c,Language_spoken_2__c,Language_spoken_3__c,Language_spoken_years_1__c,Language_spoken_years_2__c,Language_spoken_years_3__c,Allergies_from_Partner__c,Live_With_Pets__c,Special_Diet_Indicated__c,Special_Diet__c,Double_Placement_Indicated__c,Single_No_Children_Indicated__c,Private_High_School_Indicated__c,English_Summary__c,General_Summary__c FROM Applicant_Info__c WHERE Engagement__c IN:engIds AND Application_Stage__c='Accepted'];
    	if(appInfoList.size()>0){    		    	
	    	for(Applicant_Info__c a: appInfoList){
	    		MapEngApp.put(a.Engagement__c,a.Id);
	    	}
    	}
            
        for(Engagement__c p: personList){
        	if(mapEngApp.get(p.Id)!= null && mapEngApp.get(p.Id)!= ''){        		
	            Map<String, String> infoMap = new Map<String, String>();
	            // applicantId= p.Applicant_Info__r.Id;
	            String applicantId = mapEngApp.get(p.Id);
	            //String applicantId = 'a0Ue0000000A2gf';
	            infoMap.put('id',applicantId);
	            
	            //Intrax_Program_Upload__c ipuc = [Select Name, Document_Type__c, Document_Service__c, Document_GUID__c, Applicant_Info__c From Intrax_Program_Upload__c where Applicant_Info__c = :applicantId];
	    
	            ipus = getIPUs(applicantId);
	            //infoMap.put('photo_url',ipuc.Document_GUID__c);
	            if(ipus.size()>0){
	                Intrax_Program_Upload__c ipuc = ipus.get(0);
	                infoMap.put('photo_guid',ipuc.Document_GUID__c);
	                //ipuc = null;
	            }else{
	                infoMap.put('photo_guid','no photo available');
	            }
	            
	            //ipuc=null;
	            infoMap.put('first_name',p.Account_Id__r.FirstName);      
	            infoMap.put('age',String.valueOf(p.Age_At_Program_Start__c)); //person.age at program start :CHANGETO
	            infoMap.put('gender',p.Gender__c);
	            infoMap.put('country',p.Account_Id__r.Legal_Residence__pc);//person.country of residence
	            infoMap.put('program_length',p.Program_Duration__c);
	            infoMap.put('interests',p.Interests_Top__c);
	            infoMap.put('agesList',String.valueOf(agesList.size()));
	            
	            
	            mapres.add(infoMap);
	            //infoMap = null;
	        }
        }
        
        
        Map<String, String> pageInfo = new Map<String, String>();
        pageInfo.put('record_count',String.valueOf(totalRecordCount));
        mapres.add(pageInfo);
    
        
        return mapres;
    
    }
    
    
  @HttpPost
    global static List<Map<String, String>> doPost(String country,
        String gender, String ages, String page, String pageSize) {
        
        List<Map<String, String>> mapres = new List<Map<String, String>>(); 
        RestRequest req = RestContext.request;
        Map <String, String> reqParams = req.params;
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        System.debug('REQUEST POST PARAM COUNTRY = ' + country);
        System.debug('REQUEST POST PARAM GENDER = ' + gender);
        System.debug('REQUEST POST PARAM AGEs = ' + ages);
        
        Integer pageNo = Integer.valueOf(page); 
        Integer pgSize = Integer.valueOf(pageSize);
        
        Integer pLimit = Integer.valueOf(pageSize);
        Integer pOffset = (pgSize*pageNo) - (pgSize);
        
        List<Engagement__c> result = null;
      //  List<Integer> agesList = new List<Integer>();
      //  agesList.add(17);
      //  agesList.add(19);
      
        List<String> agesList = new List<String>();
        
        String filterString = '';
        
        //check which parameters are passed
        /*
        String pStudent = 'Student';
        String pParticipant = 'Participant';
        String pPlacementPending = 'YES';
        String pApplicationStage = 'Accepted';
        String pIntraxProgramOptions = 'Ayusa High School';
        */
        String eIntraxProg = 'Ayusa';
        String eIntraxProgOption = 'Tomodachi';
        String eRecordType = 'Ayusa PT';
        String eStatus_Proc = 'Processing';
        String eStatus_ProgReady = 'Program Ready';
        String sPlacementStatus_NP = 'Not Placed';
        String sPlacementStatus_Pending = 'Pending';
        
        //String qry = 'SELECT Id, Applicant_Info__r.Id, First_Name__c, Date_Of_Birth__c, Age_At_Program_Start__c, Gender__c, Birth_Country__c, Country_of_Residence__c, Applicant_info__r.Home_Country__c, Applicant_info__r.Program_Duration__c, Applicant_info__r.Engagement_Start__c, Applicant_info__r.Interests_Top__c, Applicant_info__r.Religion__c, Applicant_Info__r.Languages_Spoken__c, Applicant_info__r.Allergies_Indicated__c, Applicant_info__r.Live_With_Pets__c, Applicant_info__r.Special_Diet__c, Applicant_info__r.Double_Placement_Indicated__c, Applicant_info__r.Single_No_Children_Indicated__c,Applicant_Info__r.Application_Level__c, Applicant_Info__r.Private_High_School_Tuition__c, Applicant_Info__r.RecordTypeId, Applicant_Info__r.Type__c, Applicant_Info__r.CreatedDate, Role__c, Primary_Applicant__c FROM Person_Info__c where Primary_Applicant__c = true and Role__c = :pStudent and Applicant_Info__r.Type__c = :pParticipant and Applicant_Info__r.Placement_Pending__c= :pPlacementPending and Applicant_Info__r.Application_Stage__c= :pApplicationStage and Applicant_Info__r.Intrax_Program_Options__c includes(:pIntraxProgramOptions)' ;
        
        String qry = 'SELECT Id,Name,RecordType.Name,Nationality__c, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name, Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Gender__c, Priority_Engagement__c,Age_At_Program_Start__c,Account_Id__r.Religion__pc,Account_Id__r.Legal_Residence__pc FROM Engagement__c WHERE Intrax_Program__c =: eIntraxProg and RecordType.Name = :eRecordType and Intrax_Program_Options__c != :eIntraxProgOption and(Status__c =: eStatus_Proc OR Status__c =: eStatus_ProgReady) and (Placement_Status__c =:sPlacementStatus_NP OR Placement_Status__c =: sPlacementStatus_Pending )';
        
        if(country!=null && gender!=null && ages!=null){
            //country, gender, ages
            qry = qry + ' and Account_Id__r.Legal_Residence__pc = :country and Gender__c = :gender';
            agesList = ages.split(',', -1);
            Integer k = 0;
            Decimal ageD = 0;
            qry = qry + ' and Age_At_Program_Start__c IN('; 
            for(String age : agesList)  {
                ageD = decimal.valueOf(age);
                qry = qry + age;
                if(k < agesList.size()-1){
                    qry = qry + ',';
                }
                k++;
                System.debug(qry);
                
            }
            qry = qry + ')';
            
        }else if(country!=null && gender!=null && ages==null){
            //country, gender
            qry = qry + ' and Account_Id__r.Legal_Residence__pc = :country and Gender__c = :gender';
        
        }else if(country!=null && gender==null && ages==null){
            //country
            qry = qry + ' and Account_Id__r.Legal_Residence__pc = :country';
        
        }else if(country==null && gender!=null && ages==null){
            //gender
            qry = qry + ' and Gender__c = :gender';
        
        }else if(country==null && gender==null && ages!=null){
            //ages
            agesList = ages.split(',', -1);
       
            
            Integer k = 0;
            Decimal ageD = 0;
            qry = qry + ' and Age_At_Program_Start__c IN('; 
            for(String age : agesList)  {
                ageD = decimal.valueOf(age);
                qry = qry + age;
                if(k < agesList.size()-1){
                    qry = qry + ',';
                }
                k++;
                System.debug(qry);
                
            }
            qry = qry + ')';
            
            //qry = qry + ' and(Age_At_Program_Start__c = 18 or Age_At_Program_Start__c = 19)';
            
        
        }else if(country==null && gender!=null && ages!=null){
            //gender, ages
            qry = qry + ' and Gender__c = :gender';
            agesList = ages.split(',', -1);
            Integer k = 0;
            Decimal ageD = 0;
            qry = qry + ' and Age_At_Program_Start__c IN('; 
            for(String age : agesList)  {
                ageD = decimal.valueOf(age);
                qry = qry + age;
                if(k < agesList.size()-1){
                    qry = qry + ',';
                }
                k++;
                System.debug(qry);
                
            }
            qry = qry + ')';
        
        }else if(country!=null && gender==null && ages!=null){
            //country, ages
            qry = qry + ' and Account_Id__r.Legal_Residence__pc = :country';
            agesList = ages.split(',', -1);
            Integer k = 0;
            Decimal ageD = 0;
            qry = qry + ' and Age_At_Program_Start__c IN('; 
            for(String age : agesList)  {
                ageD = decimal.valueOf(age);
                qry = qry + age;
                if(k < agesList.size()-1){
                    qry = qry + ',';
                }
                k++;
                System.debug(qry);
                
            }
            qry = qry + ')';
        
        }else{//return all
            //qry = 'SELECT Id, Applicant_Info__r.Id, First_Name__c, Date_Of_Birth__c, Age_At_Program_Start__c, Gender__c, Birth_Country__c, Country_of_Residence__c, Applicant_info__r.Home_Country__c, Applicant_info__r.Program_Duration__c, Applicant_info__r.Engagement_Start__c, Applicant_info__r.Interests_Top__c, Applicant_info__r.Religion__c, Applicant_Info__r.Languages_Spoken__c, Applicant_info__r.Allergies_Indicated__c, Applicant_info__r.Live_With_Pets__c, Applicant_info__r.Special_Diet__c, Applicant_info__r.Double_Placement_Indicated__c, Applicant_info__r.Single_No_Children_Indicated__c,Applicant_Info__r.Application_Level__c, Applicant_Info__r.Private_High_School_Tuition__c, Applicant_Info__r.RecordTypeId, Applicant_Info__r.Type__c, Applicant_Info__r.CreatedDate, Role__c, Primary_Applicant__c FROM Person_Info__c where Primary_Applicant__c = true and Role__c = :pStudent and Applicant_Info__r.Type__c = :pParticipant and Applicant_Info__r.Placement_Pending__c= :pPlacementPending and Applicant_Info__r.Application_Stage__c= :pApplicationStage  and Applicant_Info__r.Intrax_Program_Options__c includes(:pIntraxProgramOptions)' ;
			qry = 'SELECT Id,Name,RecordType.Name, Nationality__c, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name, Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Gender__c, Priority_Engagement__c,Age_At_Program_Start__c,Account_Id__r.Religion__pc,Account_Id__r.Legal_Residence__pc FROM Engagement__c WHERE Intrax_Program__c =: eIntraxProg and RecordType.Name = :eRecordType and Intrax_Program_Options__c != :eIntraxProgOption and(Status__c =: eStatus_Proc OR Status__c =: eStatus_ProgReady) and (Placement_Status__c =:sPlacementStatus_NP OR Placement_Status__c =: sPlacementStatus_Pending )';
        }
        
        //get count first
        //List<Person_Info__c> resultCount = Database.query(qry);
        List<Engagement__c> resultCount = Database.query(qry);
        Integer queryCount = resultCount.size();
       
       
        qry += ' ORDER BY Priority_Engagement__c DESC,Name ASC LIMIT :pLimit OFFSET :pOffset';
        
        //do query
        result = Database.query(qry);
        
         
        mapres = preparePostResponse(result, agesList, ages, new List<Intrax_Program_Upload__c>(), queryCount);
        
        return mapres;
    }
    
   static testMethod void testCheckIfAgeQualified(){
        List<String> agesList = new List<String>();
        agesList.add('17');
        agesList.add('19');
        System.assertEquals(true, StudentInfo.checkIfAgeQualified(17, agesList));
        System.assertEquals(false, StudentInfo.checkIfAgeQualified(22, agesList));
    
   }
   
     private static Boolean checkIfAgeQualified(Decimal age, List<String> agesList) {
            
            Boolean isQualified = false;
            for(String a : agesList)    {
                if(Decimal.valueOf(a) == age){
                    isQualified = true;
                }
            }
            
            return isQualified;
            
            //String todaysDateStr = todaysDate.format('yyyy-MM-dd'); //formatting complies with SOQL
         
    }
    
    
    
}