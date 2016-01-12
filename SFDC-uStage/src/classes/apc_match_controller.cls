public without sharing class apc_match_controller {
    
    public Selection__c matchSelection{get;set;}
    
    public list<Engagement__c> Engagementlst{get;set;}
    public list<Selection__c> activeInterview{get;set;}
    public list<Selection__c> InActivelst{get;set;}
    public list<Match__c> otherConfMatch{get;set;}
    public set<string> pTEngids=new set<string>();
    public map<string, DateTime> ptTimeZone{get;set;}
    public list<Match__c> ConfMatch{get;set;}
    //JOSE-D-02160
    public list<Match__c> AllConfMatch{get;set;} 
    public list<Match__c> withdrawnMatch{get;set;}
    public List<Applicant_Info__c> ApplicantInfoList{get;set;}
    
    public list<Selection__c> ReqIntlist{get;set;}
    public Match__c ReqmatchObj{get;set;}
    public Id requestId {get; set;}
    public Id SelcEngIds {get; set;}
    public Selection__c expirInterview{get;set;}
    public Integer InterviewExtension{get;set;}
    public map<String, String> SelectionCountryCode{get;set;}
    public list<Selection__c> SuggestedAPs{get;set;}
    
    public User user{get;set;}
    public Applicant_Info__c currentApp{get;set;}
    public string URLAux{get;set;}
    public map<String, String> returnURLmap {get;set;}
    //JOSE-D-02160
    public map<String, String> AllConfMatchPhotos {get;set;}
    public map<String, String> participantPhoto {get;set;}
    public set<Id> activeSelcEngIds=new set<Id>();
    public boolean expireflag{get;set;}
    public string OSAPArrivalDate{get;set;}
    //Get User TimeZone
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //system.debug('debug:::Display name: ' + tz.getDisplayName());
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 *3600 *24.0);
    }}
    /*
Public string tzname{get{
TimeZone tz = UserInfo.getTimeZone();

string tz2=tz.getDisplayName();
String[] s= tz2.split(' ');
//system.debug('debug:::split string ' + s);
Integer i=0; 
List<String> newString =  new List<String>();
for(String str:s)
{
i=str.length();
String x,finalstring;
x= str.substring(0,1);
finalstring = x;
//system.debug('debug:::substring ' + x);
newString.add(finalstring);
finalstring='';
//system.debug('debug:::finalstring ' + finalstring);
//system.debug('debug:::newString ' + newString);
}
String xyz= String.valueOf(newString);
String fxyz =xyz.replace(',','');


//return tz.getDisplayName();
return fxyz;  
}}*/
    
    
    //Jose Getting HF AD (User_Profile) from Position Owner
    public User_Profile__c userProfAD{get{
        
        if(userProfAD == null){
            //system.debug('@@@@@ userProdAd applicantinfo.Position__r.OwnerId: ' + ApplicantInfoList[0].Position__r.OwnerId);
            list<User_Profile__c> userProfADList = [Select Id, User__c, Area_Profile__c, OwnerId, User_Email__c, User_Name__c, User_Phone__c,
                                                    Area_Profile__r.Name, Area_Profile__r.Educational_Institution_1_URL__c, Area_Profile__r.Educational_Institution_2_URL__c, Area_Profile__r.Educational_Institution_3_URL__c,
                                                    Area_Profile__r.Educational_Institution_1__c, Area_Profile__r.Educational_Institution_2__c, Area_Profile__r.Educational_Institution_3__c,
                                                    Area_Profile__r.Climate__c, Area_Profile__r.Description__c, Area_Profile__r.APC_Field_Region__c
                                                    From User_Profile__c
                                                    where User__c =: ApplicantInfoList[0].Position__r.OwnerId]; 
            if(userProfADList!=null && userProfADList.size()>0){
                userProfAD = userProfADList[0];
                return userProfAD;
            }else{
                User_Profile__c userProfADAux = new User_Profile__c(); 
                return userProfADAux;
            }
        }else{
            return userProfAD;
        }
        
    }
                                      set;}
    
    public apc_match_controller(){
        ApplicantInfoList = [Select a.PageStatus_Complete__c,a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
                             a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Submitted__c, a.Study_Time__c, a.Street__c, a.State__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, 
                             a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
                             a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Accommodation_Price_Range__c, a.Arrival_Time__c, a.Health_Needs_Indicated__c,
                             a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Points_of_Interest__c, 
                             a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, a.Opportunity_Name__c, a.Nearest_City__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c,a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.IsDeleted, a.Intrax_Program_Options__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Government_Assistence_Indicated__c, a.GPA__c, a.GPA_Self_Reported__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, 
                             a.Exchange_Agency_Employer_Name__c, a.Intrax_Program__c, a.Terms_Accepted__c, a.Program_Start_Opinion__c, a.Arriving_Date__c, a.Arriving_Time__c, a.Carrier__c, a.Carrier_Number__c, a.Intrax_Accommodations__c, a.Flexible_Dates__c,
                             a.Entity_Id__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c, a.English_Teach_Name__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c,
                             a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Country_of_Birth__c,a.Visa_Type__c, a.How_Heard__c,a.How_Heard_Detail__c,a.How_Heard_Other__c, a.Engagement_End__c, a.Smoker_Student__c, a.Health_Needs_Description__c,
                             a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c, a.Questions__c, a.Visa_Category__c, a.Program_Start__c, a.Study_Weeks__c, a.Accommodation_Preference__c, a.Program_Selector__c,
                             a.Daily_Meal_Commitment__c, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.CreatedById, 
                             a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.Children_Enrolled__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Intrax_Center__c,
                             a.Bedrooms__c, a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.RecordType.Name, a.IsVisaDocumentPageSubmitted__c,Intrax_Region__c,
                             a.Citizenship__c, a.Attendance_Problems__c, a.Allergies_Other_Partner__c,a.Allergies_Other_desc__c,a.Attendance_Problems_Description__c, a.Application_Stage__c, a.Application_Level__c, a.Allergies_from_Partner__c,
                             a.Allergies_from_Applicant__c, a.Allergies_Indicated__c, a.Airport__c, a.Account__c, a.Academic_Years_Completed__c,a.School_Name_SOR__c, a.Primary_Activity__c, a.Experience_Complete__c,
                             a.Functional_Areas__c, a.Position_Types__c, a.Service_Level__c, a.Projects_of_Interest__c, a.Location_Preference_1__c, a.Location_Preference_2__c, a.Location_Preference_3__c, SYS_Allow_Cloning__c,
                             Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,a.Extension_Length__c,
                             a.Application_Type__c, a.Engagement__c, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c, a.Extension_Au_Pair_Agreed__c, a.Engagement__r.Interview_Availability__c,
                             a.Position__r.Profile_Complete__c,a.Position__r.Status__c,a.Position__c,a.position__r.Owner.Name,a.position__r.Owner.email,a.position__r.Owner.phone,a.Driving_Frequency__c,a.Swimming_Level__c
                             From Applicant_Info__c a
                             where a.CreatedBy__c =: UserInfo.getUserId() AND a.Intrax_Program__c = 'AuPairCare' AND Application_Stage__c != 'Cancelled' order by a.CreatedDate DESC];
        //system.debug('debug::ApplicantInfoList'+ApplicantInfoList);
        ReqmatchObj = new match__c();
        expirInterview= new selection__c();
        matchSelection= new selection__c();
        URLAux = ApexPages.currentPage().getUrl();
        
        SuggestedAPs = new list<Selection__c>();
        
        if(ApplicantInfoList!=null && ApplicantInfoList.size()>0){
            checkInterviews();	
        }
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User WHERE id = :UserInfo.getUserId()];
        
        If(URLAux.contains('/apex/apc_hf_match_request') && ApexPages.currentPage().getParameters().get('id') != null){
            //Active Interviews
            list<Selection__c> slst= [Select id,Engagement__c,Interview_Start_Date__c,Interview_End_Date__c,Interview_Extended__c,Status__c, Reason_Other__c,Recommendation_Type__c,Interview_Feedback__c,Interview_Feedback_Options__c,
                                      Engagement__r.Account_Id__r.Name,Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Skype_ID__pc,Engagement__r.Account_Id__r.Phone,Engagement__r.Account_Id__r.Citizenship__pc,
                                      Engagement__r.Earliest_Match_Date__c,Engagement__r.Latest_Match_Date__c,Engagement__r.In_Country__c,Engagement__r.Account_Id__r.Birth_City__pc,Engagement__r.Gender__c,Engagement__r.Account_Id__r.PersonEmail,Position__c from Selection__c 
                                      where id=:ApexPages.currentPage().getParameters().get('id')];
            for(Selection__c ac: slst){
                //system.debug('debug::ac.id==='+ac.id);
                matchSelection=ac;
            }
        }
        
    }
    
    public List<selectOption> getOSAPArrivalDates {
        get {
        	List<APC_ArrivalDates__c> OSAP_ArrivalDates =  [Select US_Arrival__c, Match_Request_Deadline__c
                                                           From APC_ArrivalDates__c
                                                           Where Match_Request_Deadline__c >= :date.today()
                                                           Order By Match_Request_Deadline__c Asc];
           
			List<SelectOption> options = new List<SelectOption>();
            //options.add(new selectOption('','NONE'));
            for (APC_ArrivalDates__c arc: OSAP_ArrivalDates)
            {
                //string airportcodename = arc.US_Arrival__c.month()+ '/' + arc.US_Arrival__c.day() + '/' + arc.US_Arrival__c.year();
                
                string airportcodename = datetime.newInstance(arc.US_Arrival__c.year(), arc.US_Arrival__c.month(),arc.US_Arrival__c.day()).format('MM/dd/yyyy');
                options.add(new selectOption(airportcodename,airportcodename));
                airportcodename = '';
            }
            //system.debug('*************options:'+options);
            return options;
        }
    }
     public Person_Info__c primary{
		get{
			Person_Info__c prim = new Person_Info__c();
			list<Person_Info__c> primaryList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,Phone_Country_Code__c,
													Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c, Date_of_Birth__c, Physical_Disabilities_Description__c,
													Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Overall_Health__c, Physical_Exam_Date__c, Hospitalization_Description__c, Contagious_Disease_Description__c,
													Drug_Dependency_Description__c, Chronic_Disease_Description__c, Illness_Description__c, Medication_Description__c, Psychiatric_Treatment_Description__c
													FROM Person_Info__c 
													WHERE Applicant_Info__c =: ApplicantInfoList[0].Id
													AND Primary_Applicant__c = true limit 1 ];
				
			if(primaryList != null && primaryList.size() > 0){
				prim = primaryList[0];
			}
			//system.debug('@@@@@primary: ' + prim);
			return prim;
	}
		set;
	}
    public void checkInterviews(){
        //Active Interviews
        SelectionCountryCode = new map<String, String>();
        InActivelst= new list<Selection__c>();
        activeInterview = [Select id,Name,Engagement__c,Engagement__r.In_Country__c,Interview_Start_Date__c,Interview_End_Date__c,Interview_Extended__c,Status__c, Reason_Other__c,Recommendation_Type__c,Interview_Feedback__c,Interview_Feedback_Options__c,
                           Engagement__r.Account_Id__r.Name,Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Skype_ID__pc,Engagement__r.Account_Id__r.Phone, Engagement__r.Account_Id__r.PersonHomePhone, Engagement__r.Account_Id__r.Citizenship__pc,
                           Engagement__r.Earliest_Match_Date__c,Engagement__r.Latest_Match_Date__c,Engagement__r.Account_Id__r.Birth_City__pc,Engagement__r.Account_Id__r.BillingCountry,Engagement__r.Account_Id__r.BillingCity,Engagement__r.Gender__c,Engagement__r.Account_Id__r.PersonEmail,Position__c, 
                           Engagement__r.Placement_Status__c,Engagement__r.Interview_Availability__c
                           from Selection__c 
                           where Position__c =: ApplicantInfoList[0].Position__c AND Status__c='Active' order by Interview_End_Date__c ASC];
        //system.debug('debug::Active Interview List'+ activeInterview);
        
        
        if (ApplicantInfoList[0].Position__c != NULL)	
        {		
            list<User_Preference__c> RemovalAps = [SELECT Id, User__c, Dismissed_Records__c, Saved_Records__c FROM User_Preference__c WHERE 
                                                   User__c =: UserInfo.getUserId() 
                                                   AND Object__c = 'Engagement__c'];	
            
          ///Default Filter (Start)
           date d_today = date.today();
            //system.debug('debug::RemovalAps==='+RemovalAps);
            string query = '';
            boolean hasChildrenUnder2 = false;      
            boolean sameSexCouple = false;  
            boolean hasSpecialNeeds = false;
            boolean singleParent = true;

	   

	   position__c myPosition = [SELECT Host_Company_Id__c,Host_Company_Id__r.Gender__pc, Pets__c,Pet_Types__c  FROM Position__C WHERE ID =: ApplicantInfoList[0].Position__c];
            
            //position.Host_Company_Id__c != null && position.Host_Company_Id__c != ''){
            list<Member__c> familyMembers = [SELECT Id, Age__c, Special_Needs_Indicated__c, Account_Name__c, Role__c, gender__c
                                                FROM Member__c
                                                WHERE Account_Name__c =: myPosition.Host_Company_Id__c
                                                ];
            
                                                
            if(familyMembers.size() > 0){
                for(Member__c m : familyMembers){
                    if(m.Age__c < 2) hasChildrenUnder2 = true;
                    if(m.Role__c == 'Spouse or Partner'){                       
                        singleParent = false;                       
                        if(myPosition.Host_Company_Id__r.Gender__pc == m.Gender__c) sameSexCouple = true;   
                        
                    }else if(m.Role__c == 'Child' && m.Special_Needs_Indicated__c == 'Yes'){
                        hasSpecialNeeds = true;
                    }                                           
                }
            }               
            

            if(myPosition.Pets__c == 'Yes' && myPosition.Pet_Types__c != null){
                list<String> pets = myPosition.Pet_Types__c.split(';');                 
                String s_pets = '(';
                for(String s: pets){
                    s_pets += '\'' + s + '\',';
                }
                s_pets = s_pets.substring(0,s_pets.length() -1);
                s_pets += ')';
                query += ' AND (Engagement__r.Pets_Allergy_Indicated__c = \'No\' OR (Engagement__r.Pets_Allergy_Indicated__c = \'Yes\' AND (Engagement__r.Pet_Allergy_Types__c NOT IN ' + s_pets + ')))';
            }
            
            if(singleParent == true){
                if(myPosition.Host_Company_Id__r.Gender__pc == 'Male') query += 'AND Engagement__r.Single_Father_Indicated__c = \'Yes\'';
                else if(myPosition.Host_Company_Id__r.Gender__pc == 'Female') query += 'AND Engagement__r.Single_Mother_Indicated__c = \'Yes\'';
            }
            
            if(sameSexCouple){
                query += ' AND Engagement__r.Same_Sex_Couple_Indicated__c = \'Yes\'';
            }
            
            if(hasChildrenUnder2){
                query += ' AND Engagement__r.Under_2_Circulated__c = true';
            }else{              
                //Modified on Oct 29 after checking with Yang: 
                query += ' AND (Engagement__r.Under_2_Circulated__c = false AND Engagement__r.Infant_Specialized_Circulated__c = false)';
                //query += ' AND Engagement__r.Infant_Specialized_Circulated__c = false';
                                
            }
            
            if(hasSpecialNeeds){                
                query += ' AND (Engagement__r.Special_Needs_Circulated__c = \'Circulate SN\' OR Engagement__r.Special_Needs_Circulated__c = \'Circulate Both\')';
            }else{
            	query += ' AND (Engagement__r.Special_Needs_Circulated__c = \'Circulate Standard\' OR Engagement__r.Special_Needs_Circulated__c = \'Circulate Both\')';
            }
            
            //query += getEarlyEndedCriteria();
            
            query += ' AND ((Engagement__r.In_Country__c = \'Yes\' AND Engagement__r.Latest_Match_Date__c >= :d_today) OR (Engagement__r.In_Country__c = \'No\') OR (Engagement__r.In_Country__c = null))'; 


	    
	    
	    ///Default Filter (End)
            
            
            String SuggestedAPsQuery = 'Select Engagement__r.Circulation_Start_Date__c, Engagement__r.Circulation_End_Date__c, id,Name,Engagement__c,Interview_Start_Date__c,Interview_End_Date__c,Interview_Extended__c,Status__c, Reason_Other__c,Recommendation_Type__c,Interview_Feedback__c,Interview_Feedback_Options__c,'+
                + ' Engagement__r.Account_Id__r.Name,Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Skype_ID__pc,Engagement__r.Account_Id__r.Phone,Engagement__r.Account_Id__r.Citizenship__pc,'+
                + ' Engagement__r.Account_Id__r.Birth_City__pc,Engagement__r.Account_Id__r.BillingCountry,Engagement__r.Account_Id__r.BillingCity,Engagement__r.Gender__c,Engagement__r.Account_Id__r.PersonEmail,Position__c'+ 
                + ' , Engagement__r.Account_Id__r.Age__pc from Selection__c'+
                + ' where Intrax_Program__c = \'AuPairCare\' AND Position__c =\'' + ApplicantInfoList[0].Position__c +'\''+
                + ' AND Engagement__r.Placement_Status__c = \'Not Placed\' ' +
                + ' AND ((Engagement__r.Status__c = \'Processing\') ' +
                + ' OR (Engagement__r.Status__c = \'On Program\' AND Engagement__r.Circulation_Start_Date__c <= : d_today AND Engagement__r.Circulation_End_Date__c >= : d_today)) '+
                + ' AND Status__c = null AND  Recommendation_Type__c IN (\'System\', \'Staff\') ' +
                + ' AND Engagement__r.RecordTypeId = \'' + Constants.ENG_AUPAIRCARE_PT + '\'' +
                + ' AND Engagement__c NOT IN (SELECT Engagement__c FROM Match__c WHERE Offer_Status__c IN (\'Offered\') )';
                
                ///Default Filter (Start)
                if (query != '')
	    		{
	    			SuggestedAPsQuery += query;
	    		}
                ///Default Filter (End)
            /*String SuggestedAPsQuery = 'Select Id, Name, Nationality__c, In_Country__c, Infant_Specialized_Indicated__c, Infant_Specialized_Circulated__c, Special_Needs_Indicated__c, Engagement_Start__c, Latest_Match_Date__c, Earliest_Match_Date__c, Intrax_Program__c, Age_At_program_Start__c, Swimming_Level__c, Gender__c, Type__c, Actual_Arrival__c, Account_Id__r.FirstName, Account_Id__r.Nick_Name__pc, Intrax_Program_Options__c, Interest_Sports__c, Interest_Fine_Arts__c, Language_1__c, Language_2__c, Language_3__c, ' +
                        + ' Special_Diet__c, Interests_Hobbies__c, Childcare_Total_Hours__c, Driving_Frequency__c, Under_2_Total_Hours__c, Circulation_Start_Date__c, Circulation_End_Date__c, Special_Needs_Circulated__c, Account_Id__r.Age__pc,' +
                        + '(SELECT Id, Name, Swimming_Level__c, Driving_Frequency__c, Drivers_Licence_Acquired__c, Home_Country__c, Accepted_Date__c FROM Applicant_Info__r WHERE Application_Stage__c = \'Accepted\' order by CreatedDate desc  LIMIT 1) FROM Engagement__c' +
                        + ' WHERE Intrax_Program__c = \'AuPairCare\' AND type__c = \'Participant\'' + 
                        + ' AND Placement_Status__c = \'Not Placed\' ' +
                        + ' AND ((Status__c = \'Processing\') ' +
                        + ' OR (Status__c = \'On Program\' AND Circulation_Start_Date__c <= : d_today AND Circulation_End_Date__c >= : d_today)) '+
                        + ' AND ID IN (SELECT Engagement__c FROM Applicant_Info__c WHERE Application_Level__c = \'Main\' AND (Application_Stage__c = \'Accepted\' OR Application_Stage__c = \'Submitted\' OR Application_Stage__c = \'In-Review\')) ' +
                        + ' AND RecordTypeId = \'' + Constants.ENG_AUPAIRCARE_PT + '\'' + 
                        + ' AND ID NOT IN (SELECT Engagement__c FROM Match__c WHERE Offer_Status__c IN (\'Offered\') )';
            */            
            
            if(RemovalAps.size() > 0 && RemovalAps[0].Dismissed_Records__c != null)
            {
                set<String> d = (set<String>) json.deserialize(RemovalAps[0].Dismissed_Records__c, set<String>.class);	
                if(d.size() > 0)
                {
                    SuggestedAPsQuery += ' AND Engagement__c NOT IN ' + f_value_string(d);
                }
            }
            
            SuggestedAPsQuery += ' order by Recommendation_Type__c DESC limit 5';
            //system.debug('debug::SuggestedAPsQuery'+ SuggestedAPsQuery);
            SuggestedAPs = Database.query(SuggestedAPsQuery);
            //system.debug('debug::SuggestedAPs List'+ SuggestedAPs);
        }                   
        If(activeInterview.size()>0){
            for(Selection__c ac: ActiveInterview){
                activeSelcEngIds.add(ac.Engagement__c);
                
            }
        }   
        
        If(activeInterview.size()>0 && URLAux.contains('/apex/apc_hf_interviews')){
            for(Selection__c ac: activeInterview){
                //system.debug('ActiveInterview###############'+ activeInterview);
                if (ac.Engagement__c !=null) {
                    Applicant_Info__c applicant = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c 
                                                   From Applicant_Info__c
                                                   Where Engagement__c =: ac.Engagement__c
                                                   ORDER BY CreatedDate DESC
                                                   LIMIT 1   ];
                    //system.debug('applicant###############'+ applicant.id);	
                    if 	(applicant!=null){						
                        list<Person_Info__c> primaryList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,Phone_Country_Code__c,
                                                            Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c, Date_of_Birth__c, Physical_Disabilities_Description__c,
                                                            Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Overall_Health__c, Physical_Exam_Date__c, Hospitalization_Description__c, Contagious_Disease_Description__c,
                                                            Drug_Dependency_Description__c, Chronic_Disease_Description__c, Illness_Description__c, Medication_Description__c, Psychiatric_Treatment_Description__c
                                                            FROM Person_Info__c 
                                                            WHERE Applicant_Info__c =: applicant.Id
                                                            AND Primary_Applicant__c = true limit 1 ];
                        if(primaryList != null && primaryList.size() > 0){
                            //system.debug('primaryList[0]###############'+ primaryList[0]);	
                            SelectionCountryCode.put(ac.Id, primaryList[0].Phone_Country_Code__c);
                            // system.debug('SelectionCountryCode###############'+ SelectionCountryCode);	
                        }	
                    }
                }
            }
        } 
        
        // For Past Interviews Match selection
        If(ApplicantInfoList[0].Position__c != null){
            InActivelst = [Select id,Interview_Start_Date__c,Engagement__r.Gender__c,Interview_End_Date__c,Interview_Extended__c,Status__c, Reason_Other__c,Recommendation_Type__c,Interview_Feedback__c,Interview_Feedback_Options__c,
                           Engagement__c, Engagement__r.Account_Id__r.Name,Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Skype_ID__pc,Engagement__r.Account_Id__r.Phone,Engagement__r.Account_Id__r.PersonHomePhone,Engagement__r.Account_Id__r.Citizenship__pc,
                           Engagement__r.Earliest_Match_Date__c,Engagement__r.Latest_Match_Date__c,Engagement__r.Account_Id__r.Birth_City__pc,Engagement__r.Account_Id__r.BillingCountry,Engagement__r.Account_Id__r.BillingCity,Engagement__r.Account_Id__r.PersonEmail,Position__c from Selection__c 
                           where Position__c =: ApplicantInfoList[0].Position__c AND Status__c='InActive'];
            //system.debug('debug::Past Interview List'+ InActivelst);
        }
     // Past Interviews country Code population
     If(InActivelst != null && InActivelst.size()>0 && URLAux.contains('/apex/apc_hf_interviews')){         	
         	Map<Id,Id> selEng = new Map<Id,Id>();
         	Map<Id,Id> mapEngAppInfo = new Map<Id,Id>();
            Map<Id,Person_Info__c> mapAppPersonInfo = new Map<Id,Person_Info__c>();
            for(Selection__c ac: InActivelst){
                if (ac.Engagement__c !=null) {                	
					selEng.put(ac.Id, ac.Engagement__c);
                }
            }
         	
         	List<Engagement__c> engList = [select Id,(select Id,Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c from Applicant_Info__r ORDER BY CreatedDate DESC LIMIT 1) from engagement__c where id in:selEng.values()];
            if(engList!=null && engList.size()>0){
                for(Engagement__c eng: engList)
                mapEngAppInfo.put(eng.Id, eng.Applicant_Info__r[0].Id);
            }
         
         	List<Applicant_Info__c> applicantList = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c, 
                                                   (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,Phone_Country_Code__c,
                                                            Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c, Date_of_Birth__c, Physical_Disabilities_Description__c,
                                                            Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Overall_Health__c, Physical_Exam_Date__c, Hospitalization_Description__c, Contagious_Disease_Description__c,
                                                            Drug_Dependency_Description__c, Chronic_Disease_Description__c, Illness_Description__c, Medication_Description__c, Psychiatric_Treatment_Description__c
                                                            FROM Person_Info__r 
                                                            WHERE Primary_Applicant__c = true limit 1)
                                                   From Applicant_Info__c
                                                   Where Id IN: mapEngAppInfo.values()
                                                   ORDER BY CreatedDate DESC
                                                   ];
            
         	if(applicantList!=null && applicantList.size()>0){
                for(Applicant_Info__c app: applicantList){
                    if(app.Person_Info__r!=null && app.Person_Info__r.size()>0)
                		mapAppPersonInfo.put(app.Id, app.Person_Info__r);
                    else
                        mapAppPersonInfo.put(app.Id, null);
                }
            }
         
            for(Selection__c ac: InActivelst){
                //system.debug('ActiveInterview###############'+ InActivelst);
                if (ac.Engagement__c !=null) {
                    /*Applicant_Info__c applicant = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c, 
                                                   (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,Phone_Country_Code__c,
                                                            Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c, Date_of_Birth__c, Physical_Disabilities_Description__c,
                                                            Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Overall_Health__c, Physical_Exam_Date__c, Hospitalization_Description__c, Contagious_Disease_Description__c,
                                                            Drug_Dependency_Description__c, Chronic_Disease_Description__c, Illness_Description__c, Medication_Description__c, Psychiatric_Treatment_Description__c
                                                            FROM Person_Info__r 
                                                            WHERE Primary_Applicant__c = true limit 1)
                                                   From Applicant_Info__c
                                                   Where Engagement__c =: ac.Engagement__c
                                                   ORDER BY CreatedDate DESC
                                                   LIMIT 1   ];
					*/
                    //system.debug('applicant###############'+ applicant.id);	
                    if(mapEngAppInfo.get(ac.Engagement__c) !=null){
                    //if(applicant!=null){						
                        /*list<Person_Info__c> primaryList = [SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c, Physical_Disabilities_Indicated__c,Phone_Country_Code__c,
                                                            Contagious_Disease_Indicated__c, Drug_Dependency_Indicated__c, Medication_Indicated__c, Hospitalization_Indicated__c, Date_of_Birth__c, Physical_Disabilities_Description__c,
                                                            Psychiatric_Treatment_Indicated__c, Pregnancy_Indicated__c, Braces_Indicated__c, Overall_Health__c, Physical_Exam_Date__c, Hospitalization_Description__c, Contagious_Disease_Description__c,
                                                            Drug_Dependency_Description__c, Chronic_Disease_Description__c, Illness_Description__c, Medication_Description__c, Psychiatric_Treatment_Description__c
                                                            FROM Person_Info__c 
                                                            WHERE Applicant_Info__c =: applicant.Id
                                                            AND Primary_Applicant__c = true limit 1 ];
						*/
                        if(mapAppPersonInfo.get(mapEngAppInfo.get(ac.Engagement__c))!=null){
                            SelectionCountryCode.put(ac.Id, mapAppPersonInfo.get(mapEngAppInfo.get(ac.Engagement__c)).Phone_Country_Code__c);
                        }
                        /*
                        if(applicant.Person_Info__r != null && applicant.Person_Info__r.size() > 0){
                            //system.debug('primaryList[0]###############'+ primaryList[0]);	
                            SelectionCountryCode.put(ac.Id, applicant.Person_Info__r[0].Phone_Country_Code__c);
                        }*/
                    }
                }
            }
        } 
        
        //D-02075-D-02073
        If(URLAux.contains('/apex/apc_hf_interviews') && ApplicantInfoList[0].Position__c != null){
            ptTimeZone = new map<string, DateTime>();
            //otherConfMatch= [select id,HF_Arrival_Date__c,Engagement__c,Engagement__r.Gender__c,Participant_Id__r.Name from match__c where Engagement__r.Placement_Status__c='Confirmed' AND Engagement__c in:activeSelcEngIds limit 10];
            for(Selection__c s: [Select id,Name,Engagement__c,Engagement__r.Account_Id__r.PersonEmail from Selection__c where Position__c =: ApplicantInfoList[0].Position__c AND Status__c!=null]){
                pTEngids.add(s.Engagement__r.Account_Id__r.PersonEmail);
                ptTimeZone.put(s.Engagement__r.Account_Id__r.PersonEmail,system.Now()+offset);
            }   
            //list<User> ulst=[Select id,email,TimeZoneSidKey from User where email in:pTEngids];
            //system.debug('debug::ulst'+ulst);
            for(User ptU: [Select id,email,profileId,TimeZoneSidKey from User where email in:pTEngids AND User_Interests__c = 'Becoming an au pair' and profileId ='00ea00000024IBy']){
                ptTimeZone.put(ptU.email,DateTime.newInstance((System.now()).getTime()+TimeZone.getTimeZone(ptU.TimeZoneSidKey).getOffset(DateTime.now())));
            }
            //system.debug('debug:::PT time zone==='+ptTimeZone);
        }
        
        //JOSE-D-02160
        If(URLAux.contains('/apex/apc_hf_current_au_pairs')){
            //Retreiving all Matches for Current and Past Au Pairs
            AllConfMatch= [select id,Request_Notes__c,Description__c,HF_Arrival_Date__c,Arrival_Date__c,End_date__c, Actual_End_date__c, Status__c,Match_Date__c,Position_Name__c,Engagement__c,RecordType.Name,
                    Engagement__r.Gender__c,Engagement__r.Age_At_Program_Start__c, Offer_Status__c , Participant_Id__r.PersonBirthdate,
                    Participant_Id__r.Name, Participant_Id__r.FirstName, Participant_Id__r.LastName, Participant_Id__r.Nick_Name__pc, Participant_Id__r.Phone,
                    Participant_Id__r.PersonEmail,Participant_Id__r.Skype_ID__pc, Participant_Id__r.Citizenship__pc, 
                    Participant_Id__r.PersonMobilePhone, Participant_Id__r.PersonMailingStreet, Participant_Id__r.PersonMailingState,
                    Participant_Id__r.PersonMailingPostalCode, Participant_Id__r.PersonMailingCountry, Participant_Id__r.PersonMailingCity,
                    Engagement__r.In_Country__c,Engagement__r.Arrival_PNR_Number__c, Engagement__r.Arrival_Trip_URL__c,request_Expiration__c,
                    Engagement__r.Driving_Frequency__c,Engagement__r.Childcare_Total_Hours__c,Engagement__r.Swimming_Level__c,Engagement__r.Status__c,
                    Airport__c, Hide_from_Host__c, Hide_From_PT__c
                    from match__c 
                    where Host_Account__c =:ApplicantInfoList[0].Account__c AND Engagement__c != null AND
                    (Status__c = 'Confirmed' OR Status__c = 'Ended Early' OR Status__c = 'Completed') AND RecordType.Name =:'AuPairCare' order by createdDate desc limit 15];
            system.debug('@@@@@debug::AllConfMatch'+ AllConfMatch);
            //Retrieve a list of pictures for every Engagment related to the previous Matches
            list<Id> AllconfmatchEngIds = new list<Id>();
            if(AllConfMatch != null && AllConfMatch.size() > 0) {
            	for(Match__c m: AllConfMatch){
                	AllconfmatchEngIds.add(m.Engagement__c);
            	}
        	}
        	list<Engagement__c> EngagementlstMatch = [select id,Intrax_Program__c from Engagement__c where id in:AllconfmatchEngIds];
        	system.debug('@@@@@debug::Engagementlst---'+EngagementlstMatch);
        	if(EngagementlstMatch.size() >0){ 
            	//Storing aall pics in this MAP <String,String>AllConfMatchPhotos
            	AllConfMatchPhotos = aws_controller.getParticipantIPUURL(EngagementlstMatch,false);
            	system.debug('@@@@@debug::AllConfMatchPhotos---'+AllConfMatchPhotos);
        	}	
        }
        
        ConfMatch= [select id,Request_Notes__c,Description__c,HF_Arrival_Date__c,Arrival_Date__c,End_date__c,Status__c,Match_Date__c,Position_Name__c,Engagement__c,RecordType.Name,
                    Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Name,Engagement__r.Account_Id__r.BillingCountry,Engagement__r.Account_Id__r.BillingCity,
                    Engagement__r.Gender__c,Engagement__r.Age_At_Program_Start__c,Participant_Id__r.Name,Offer_Status__c , 
                    Engagement__r.In_Country__c,Engagement__r.Arrival_PNR_Number__c, Engagement__r.Arrival_Trip_URL__c,request_Expiration__c,
                    Engagement__r.Driving_Frequency__c,Engagement__r.Childcare_Total_Hours__c,Engagement__r.Swimming_Level__c,Engagement__r.Status__c, Airport__c, Hide_from_Host__c, Hide_From_PT__c
                    from match__c where Position_Name__c =:ApplicantInfoList[0].Position__c AND Engagement__r.Status__c != 'Program Complete' AND
                    Status__c != 'Withdrawn' AND Status__c != 'Ended Early' AND RecordType.Name =:'AuPairCare' order by createdDate desc limit 1];
        system.debug('@@@@@debug::ConfMatch'+ConfMatch);
        
        withdrawnMatch = [select id,Request_Notes__c,Description__c,HF_Arrival_Date__c,Arrival_Date__c,End_date__c,Status__c,Match_Date__c,Position_Name__c,Engagement__c,RecordType.Name,
                    Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Name,Engagement__r.Account_Id__r.BillingCountry,Engagement__r.Account_Id__r.BillingCity,
                    Engagement__r.Gender__c,Engagement__r.Age_At_Program_Start__c,Participant_Id__r.Name,Offer_Status__c , 
                    Engagement__r.In_Country__c,Engagement__r.Arrival_PNR_Number__c, Engagement__r.Arrival_Trip_URL__c,request_Expiration__c,
                    Engagement__r.Driving_Frequency__c,Engagement__r.Childcare_Total_Hours__c,Engagement__r.Swimming_Level__c,Engagement__r.Status__c, Airport__c, Hide_from_Host__c, Hide_From_PT__c
                    from match__c where Position_Name__c =:ApplicantInfoList[0].Position__c AND Engagement__r.Status__c != 'Program Complete' AND
                    Status__c = 'Withdrawn' AND RecordType.Name =:'AuPairCare' order by createdDate desc limit 1];
        
        if(ConfMatch.size()>0){
            for(Match__c ma: ConfMatch){
                activeSelcEngIds.add(ma.Engagement__c);
            }
        }
        
        if(withdrawnMatch.size() > 0){
            for(Match__c ma: withdrawnMatch){
                activeSelcEngIds.add(ma.Engagement__c);
            }
        }
        
        list<Selection__c> Imageselections=[select id,Engagement__c from Selection__c where position__c=:ApplicantInfoList[0].Position__c];
        //system.debug('debug::Imageselections'+Imageselections.size());
        If(Imageselections.size() > 0) {
            for(Selection__c s: Imageselections){
                activeSelcEngIds.add(s.Engagement__c);
            }
        }
        Engagementlst=[select id,Intrax_Program__c from Engagement__c where id in:activeSelcEngIds];
        //system.debug('debug::Engagementlst---'+Engagementlst);
        
        If(Engagementlst.size() >0){
            //returnURLmap= aws_controller.getParticipantPhotoList(Engagementlst);
            //system.debug('debug::returnURLmap---'+returnURLmap);
            
            participantPhoto = aws_controller.getParticipantIPUURL(Engagementlst,False);
            returnURLmap=participantPhoto;
            //system.debug('debug::::Newvalue=='+value);
        }
        
        If(URLAux.contains('/apex/apc_hf_interviews') && ActiveInterview.size()>0){
            if(activeInterview!=null && activeInterview.size()>0){
                for(Selection__c ac: activeInterview){
                    //system.debug('debug::requestId==='+requestId);
                    If(ac.id==requestId){
                        matchSelection=ac;
                    }
                    
                }
            }
        }
    }
    
    //Past Interviews Pagging
    List<PastInterviewWrapper> PastSelections {get;set;}
    public string pageNumberSelected{get;set;}
    public Integer totalRecords{get; set;}  
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select id,Interview_Start_Date__c,Engagement__r.Gender__c,Interview_End_Date__c,Interview_Extended__c,Status__c, Reason_Other__c,Recommendation_Type__c,Interview_Feedback__c,Interview_Feedback_Options__c,
                                                                                    Engagement__r.Account_Id__r.Name,Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Skype_ID__pc,Engagement__r.Account_Id__r.Phone,Engagement__r.Account_Id__r.PersonHomePhone,Engagement__r.Account_Id__r.Citizenship__pc,
                                                                                    Engagement__r.Account_Id__r.Birth_City__pc,Engagement__r.Account_Id__r.BillingCountry,Engagement__r.Account_Id__r.BillingCity,Engagement__r.Account_Id__r.PersonEmail,Position__c, 
                                                                                    Engagement__r.Placement_Status__c,Engagement__r.Interview_Availability__c
                                                                                    from Selection__c 
                                                                                    where Position__c =: ApplicantInfoList[0].Position__c AND Status__c='InActive'
                                                                                    And Engagement__c Not in(select Engagement__c from match__c where Engagement__c in:activeSelcEngIds and Status__c='Ended Early')
                                                                                   ]));
                // sets the number of records in each page set
                con.setPageSize(10);
                totalRecords = con.getResultSize();
            }
            return con;
        }
        set;
    }
    
    public integer totalPages{
        get{
            totalPages = 0;
            if(totalRecords > 0){
                totalPages = integer.valueOf(math.floor(totalRecords / 10));
                if(math.mod(totalRecords,10) > 0){
                    totalPages += 1;
                }
            }
            return totalPages;
        }set;
    }
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<PastInterviewWrapper> getPastSelections() {
        PastSelections = new List<PastInterviewWrapper>();
        for (Selection__c Selection : (List<Selection__c>)con.getRecords())
            PastSelections.add(new PastInterviewWrapper(Selection));
        return PastSelections;
    }
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    public void setPageNumber(){    
        con.setPageNumber(integer.valueOf(pageNumberSelected));    	
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) con.getRecords());
    }
    
    // returns the previous page of records
    public void previous() {
        con.previous();
        pageNumberSelected = string.valueOf(con.getPageNumber());
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) con.getRecords());
    }
    
    // returns the next page of records
    public void next() {
        con.next();
        pageNumberSelected = string.valueOf(con.getPageNumber());
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) con.getRecords());
    }
    // End of Pagging
    public void CheckExpDate(){
        expireflag=false;
        //system.debug('debug::ActionInterview List'+ activeInterview);
        for(Selection__c ac: ActiveInterview){
            If(System.Now() > ac.Interview_End_Date__c){
                expirInterview=ac;
                expireflag=true;
                
                //Showing Extension Hours
                if (expirInterview.Engagement__r.In_Country__c == 'No') {   		
                    APC_Program_Settings__c ps = [Select OSAP_Interview_Extension_Hours__c From APC_Program_Settings__c];    		
                    InterviewExtension = integer.valueOf(ps.OSAP_Interview_Extension_Hours__c);
                }else{
                    APC_Program_Settings__c ps = [Select ICAP_Interview_Extension_Hours__c From APC_Program_Settings__c];
                    InterviewExtension = integer.valueOf(ps.ICAP_Interview_Extension_Hours__c);
                }
                
                //system.debug('debug::expirInterview'+expirInterview);
            }
            //else{
            //expireflag=false;
            //}
        }
        //system.debug('debug::ExpireFlag'+expireflag);
    }
    
    public PageReference CancelInterview(){
        
        If(matchselection!=null && requestid != null ){
            matchselection.status__c='Inactive';
            //system.debug('debug:::matchselection===:'+matchselection);
            update matchselection;
        }
        
        If(expirInterview != null && requestid == null){
            expirInterview.status__c='Inactive';
            //system.debug('debug:::expirInterview==:'+expirInterview);    
            update expirInterview;
        }
        
        PageReference newpage;
        newpage = new PageReference('/apc_hf_interviews');
        newpage.setRedirect(true);
        return newpage;
    }
    
    public Opportunity HfchildOpp{get{
        if(HfchildOpp == null){
            list<Opportunity> HfchildOpplist = [select id,Name from opportunity where Parent_Opportunity__c =:ReqIntlist[0].Position__r.Host_Opportunity_Id__c and 
                                                (ChildOppType__c ='Match' OR ChildOppType__c ='Rematch') order by createddate desc limit 1]; 
            if(HfchildOpplist!=null && HfchildOpplist.size()>0){
                HfchildOpp = HfchildOpplist[0];
                return HfchildOpp;
            }else{
                Opportunity HfchildOppAux = new Opportunity(); 
                return HfchildOppAux;
            }
        }else{
            return HfchildOpp;
        }
        
    }set;}
    
    
    private Date setStringToDateFormat(String myDate) {
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntYear = integer.valueOf(strDate[2]);
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return d;
    }
    
    public PageReference matchRequest(){
        id sid=apexpages.currentpage().getparameters().get('id');
        //system.debug('debug::sid--'+ sid);
        try{
            ReqIntlist = [Select id,Name,Engagement__c,Engagement__r.In_Country__c,Engagement__r.Name,Interview_Start_Date__c,Interview_End_Date__c,Interview_Extended__c,Status__c, Reason_Other__c,Recommendation_Type__c,Interview_Feedback__c,Interview_Feedback_Options__c,
                          Engagement__r.Account_Id__r.LastName,Engagement__r.Account_Id__r.FirstName,Engagement__r.Account_Id__r.Skype_ID__pc,Engagement__r.Account_Id__r.Phone,Engagement__r.Account_Id__r.Citizenship__pc,
                          Engagement__r.Account_Id__r.Birth_City__pc,Engagement__r.Gender__c,Engagement__r.Account_Id__r.PersonEmail,Position__c,Position__r.Host_Company_Id__r.LastName,Position__r.id,Position__r.Host_Opportunity_Id__c,
                          Engagement__r.Opportunity_Id__c,Engagement__r.Earliest_Match_Date__c,Engagement__r.Latest_Match_Date__c from Selection__c 
                          where id=:sid order by CreatedDate DESC limit 1];
            //system.debug('debug::ReqIntlist--'+ ReqIntlist);
            
            RecordType RecType = [Select Id From RecordType  Where SobjectType = 'Match__c' and DeveloperName = 'AuPairCare' Limit 1];
            ReqmatchObj.Name=ReqIntlist[0].Position__r.Host_Company_Id__r.LastName+' '+ReqIntlist[0].Engagement__r.Account_Id__r.LastName;
            ReqmatchObj.Engagement__c=ReqIntlist[0].Engagement__c;
            ReqmatchObj.Position_Name__c=ReqIntlist[0].Position__c;
            ReqmatchObj.Participant_Id__c=ReqIntlist[0].Engagement__r.Account_Id__c;
            ReqmatchObj.Participant_Opportunity_Id__c=ReqIntlist[0].Engagement__r.Opportunity_Id__c;
            ReqmatchObj.RecordTypeId=RecType.id;
            ReqmatchObj.Status__c='Requested';
            ReqmatchObj.Offer_Status__c='Offered';
            ReqmatchObj.Match_Type__c=ApplicantInfoList[0].Application_Type__c;//'Original';
            ReqmatchObj.Host_Account__c=ApplicantInfoList[0].account__c;
            ReqmatchObj.Host_Family_Child_Opportuniy__c=HfchildOpp.id;
            
            if (ReqIntlist[0].Engagement__r.In_Country__c == 'No') {  
                APC_Program_Settings__c ps = [Select OSAP_Match_Request_Expiration_Hours__c From APC_Program_Settings__c];
                ReqmatchObj.request_Expiration__c = DateTime.now().addHours(Integer.valueOf(ps.OSAP_Match_Request_Expiration_Hours__c));
                ReqmatchObj.Arrival_Date__c=setStringToDateFormat(OSAPArrivalDate);
            }else{
                APC_Program_Settings__c ps = [Select ICAP_Match_Request_Expiration_Hours__c From APC_Program_Settings__c];
                ReqmatchObj.request_Expiration__c = DateTime.now().addHours(Integer.valueOf(ps.ICAP_Match_Request_Expiration_Hours__c));
            }
            upsert ReqmatchObj;
        }catch(Exception e){
            //system.debug('Error getting to send Request Match' + e);
        }
        //Update Selection Records to InActive
        List<Selection__c> supdatelst = new List<Selection__c>();
        for(selection__c s :activeInterview){
            s.status__c='Inactive';
            s.Favorite__c=False;
            supdatelst.add(s);
        }
        update supdatelst;
        
        Engagement__c engagement = [SELECT Id, Placement_Status__c FROM Engagement__c WHERE Id =: ReqIntlist[0].Engagement__c];        
        engagement.Placement_Status__c = 'Pending';        
        update engagement;
        
        PageReference newpage;
        newpage = new PageReference('/apc_hf_interviews');
        newpage.setRedirect(true);
        return newpage;
    }
    public PageReference extendRequest(){
        id sid=apexpages.currentpage().getparameters().get('ssid');
        //system.debug('debug::sid--'+sid);
        list<Selection__c> slst=[select id,Interview_Extended__c,Engagement__r.Earliest_Match_Date__c,Engagement__r.Latest_Match_Date__c,Interview_End_date__c,Engagement__r.In_Country__c from selection__c where id =:sid];
        list<Selection__c> supdatelst= new list<Selection__c>(); 
        for(Selection__c ac: slst){
            //system.debug('debug::ac.id==='+ac.id);
            matchSelection=ac;
        }
        matchselection.Interview_Extended__c=True;
        //Interview Extension Calculations
        if (matchselection.Engagement__r.In_Country__c == 'No') {  
            APC_Program_Settings__c ps = [Select OSAP_Interview_Extension_Hours__c From APC_Program_Settings__c];    		
            matchselection.Interview_End_date__c = DateTime.now().addHours(Integer.valueOf(ps.OSAP_Interview_Extension_Hours__c));
        }else{
            APC_Program_Settings__c ps = [Select ICAP_Interview_Extension_Hours__c From APC_Program_Settings__c];
            matchselection.Interview_End_date__c = DateTime.now().addHours(Integer.valueOf(ps.ICAP_Interview_Extension_Hours__c));
        }
        
        //system.debug('debug::End DAte'+matchselection.Interview_End_date__c);
        supdatelst.add(matchselection);
        update supdatelst;
        PageReference newpage;
        newpage = new PageReference('/apc_hf_interviews?id='+ApplicantInfoList[0].id);
        newpage.setRedirect(true);
        return newpage;
    }
    
    public String f_value_string (set<String> strList){
        String str = '';
        if(strList.size() > 0){    		  			  			
            boolean first_elem = true;
            for(String s : strList){
                if(first_elem == true){
                    str += '(\'' + s + '\'';
                    first_elem = false; 
                }else str += ', \'' + s + '\''; 
            }
            str += ')'; 		
        }
        return str;
    }
    
    public list<Match__c> MatchConf{get{
        
        if(MatchConf == null){
            if(ApplicantInfoList != null && ApplicantInfoList[0].Position__c!=null){
                list<Match__c> ConfMatchListAux= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                                                  Engagement__r.Infant_Specialized_Indicated__c,HF_Arrival_Date__c,
                                                  Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,
                                                  RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, 
                                                  Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,
                                                  Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                                                  Infant_Specialized_Training__c
                                                  from match__c 
                                                  where  Position_Name__c =: ApplicantInfoList[0].Position__c 
                                                  AND    (Status__c = 'Requested' OR Status__c = 'Confirmed')
                                                  AND    RecordType.Name =:'AuPairCare' 
                                                  ORDER BY CreatedDate DESC];
                //system.debug('@@@@@ConfMatchListAux: ' + ConfMatchListAux);
                
                if(ConfMatchListAux!=null && ConfMatchListAux.size()>0){
                    MatchConf = ConfMatchListAux;
                    return MatchConf;
                }else{
                    list<Match__c> matchAux = new list<Match__c>(); 
                    return matchAux;
                }
            }else{
                list<Match__c> matchAux = new list<Match__c>(); 
                return matchAux;
            }
        }else{
            return MatchConf;
        }
        
    }
    set;}
    
    public list<Match__c> AllMatches{get{
        
        if(AllMatches == null){
            if(ApplicantInfoList != null && ApplicantInfoList[0].Position__c!=null){
                list<Match__c> EEMatchListAux= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                                                  Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
                                                  Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,
                                                  RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, 
                                                  Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
                                                  Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                                                  Infant_Specialized_Training__c, Position_Name__r.Status__c,Host_Account__c
                                                  from match__c 
                                                  where  Position_Name__c=: ApplicantInfoList[0].Position__c
                                                  AND    RecordType.Name =:'AuPairCare' 
                                                  ORDER BY CreatedDate DESC];
                //system.debug('@@@@@EEMatchListAux: ' + EEMatchListAux);
                
                if(EEMatchListAux!=null && EEMatchListAux.size()>0){
                    AllMatches = EEMatchListAux;
                    return AllMatches;
                }else{
                    list<Match__c> matchAux = new list<Match__c>(); 
                    return matchAux;
                }
            }else{
                list<Match__c> matchAux = new list<Match__c>(); 
                return matchAux;
            }
        }else{
            return AllMatches;
        }
        
    }
    set;}
    
    public boolean getReMatchAppExists(){
        List<Applicant_Info__c> reMatchAppList = [SELECT Id, CreatedBy__c, Application_Stage__c,Intrax_program__c From Applicant_Info__c where CreatedBy__c =: UserInfo.getUserId() 
                        AND (Application_Type__c = 'Rematch' OR Application_Type__c = 'Renewal' OR Application_Type__c = 'Extension') AND Application_Stage__c='Accepted'                         
                        AND Intrax_Program__c = 'AuPairCare' AND Type__c='Host Family' order by CreatedDate DESC];
        if(reMatchAppList!=null && reMatchAppList.size()>0){
            return true;
        }
        else
            return false;
    }
    
    //JOSE B-03139 Display Match Request Deadline messages in HF and PT portals (Match Deadlines - B)
	public APC_ArrivalDates__c APCArrivalDates {
		get{		
			APC_ArrivalDates__c APCArrivalDates = new APC_ArrivalDates__c();
			APCArrivalDates = apc_portal_utilities.MatchRequestDeadline();
	    	return APCArrivalDates;
		}		
	}
	
	//JOSE B-03139 Display Notification to offer Early Match Disccount 90 days before the current match end date                              
    public list<Match__c> MatchConfOld{get{
        
        if(MatchConfOld == null){
        	//system.debug('@@@@@MatchConfOld: ' + MatchConfOld);
        	if(ApplicantInfoList != null && ApplicantInfoList[0].Application_Type__c=='Renewal' && MatchConf != null && MatchConf.size() == 0){
	        	list<Position__c> lastposition=[Select id from Position__c where Host_Company_Id__c=:ApplicantInfoList[0].Account__c ORDER BY CreatedDate DESC LIMIT 2];
	        	if(lastposition.size()>1){
	           		list<Match__c> MatchConfOldAux =[select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,HF_Arrival_Date__c,
	                            Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
	                            Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,Actual_End_Date__c,Host_Family_Child_Opportuniy__c,
	                            RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, Match_Period__c,
	                            Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
	                            Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
	                            Infant_Specialized_Training__c,Match_Type__c
	                          	from Match__c where Position_Name__c=:lastposition[1].id and (Status__c='Confirmed' OR Status__c='Completed')];
	                //system.debug('@@@@@MatchConfOldAux: ' + MatchConfOldAux);
	                return MatchConfOldAux; 
	            }else{
        			list<Match__c> matchAux = new list<Match__c>(); 
                	return matchAux;
        		}
        	}else{
        		list<Match__c> matchAux = new list<Match__c>(); 
                return matchAux;
        	}
        }else{
            return MatchConfOld;
        }
    }
    set;}                                
    //END JOSE B-03139   
    
    public void hide_from_host(){
    	withdrawnMatch[0].Hide_from_Host__c = true;
    	update withdrawnMatch[0];
    }    
    
}