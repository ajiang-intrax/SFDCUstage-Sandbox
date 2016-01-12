public without sharing class CloneApp_Controller {
    // 1. First thing we need to do is to declare the variables we need. For now, I can think on a variable per
    // object we are cloning, but we will probably need mor
    public Applicant_Info__c applicantInfo;
    private list<Person_Info__c> personInfo;
    private list<Member__c> memberInfo;
    
    public string cloned{get;set;}
    public string ExtensionPref{get;set;}
    //private list<School__c> school;
    //private list<Location__c> location;
    //private list<Essay__c> essay;
    public Applicant_Info__c applicantInfoClone{get;set;} //= new Applicant_Info__c();
    
    public String vstate {get;set;}
    
    // 2. The Constructor: Here is where almost all the main action happen
    public CloneApp_Controller(ApexPages.StandardController controller){
        // first, check whether the current user have enough permissions to clone the applications. Checking whether the user has the ownership of the application.
            
        // 2.1. First thing here is to get the current record (the one that we want to clone).
        applicantInfo = (Applicant_Info__c)controller.getRecord();
        system.debug('debug::applicantInfo= '+applicantInfo);
                
        if(applicantInfo.Id != null){
            system.debug('debug::If_InsideConstructor');
            // we need a query to get all the fields we need to clone
            try{
                //Mapping Object Applicant_Info_c and updating fields CreatedDate and Application_Stage__c
                applicantInfo = [SELECT Years_in_Home__c, Under_2_Total_Hours__c, Writing_Skills__c, Weight__c, Visa_Type__c, Visa_Category__c, Type__c, Title__c, TimeZoneSidKey__c, Terms_Accepted__c, Teaching_Method__c, TE_Known_for_Months__c, TE_Known_For_Years__c, SystemModstamp, Sys_Admin_Tag__c, Submitted__c, Submitted_Date__c, Study_Weeks__c, Study_Time__c, Street__c, State__c, Standard_Delivery__c, Special_Needs_Food__c, Special_Ed__c, Special_Ed_Description__c, Special_Diet__c, Special_Diet_Indicated__c, Special_Diet_Expectation_Description__c, Special_Diet_Description__c, Speaking_Skills__c, Smoking_Location__c, Smoker_in_Family__c, Smoker_Student__c, Skip_or_Repeat__c, Skip_or_Repeat_Description__c, Single_No_Children_Indicated__c, Shared_Bedroom__c, Shared_Bathroom__c, Service_Level__c, Second_Language_Level__c, School_Transportation__c, School_Transportation_Description__c, School_Recruiting_Indicated__c, School_Recruiting_Description__c, School_Officials_Title__c, School_Officials_Name__c,
                                    School_Name__c, School_Name_SOR__c, School_Employee__c, SOR_Received_Date__c, Reviewed_Date__c, Resume__c, Residence_Club__c, Religious_Sharing_Indicated__c, Religious_Restriction_Indicated__c, Religious_Activity_on_Program__c, Religious_Activity_Home__c, Religion__c, Reference_Count__c, RecordTypeId, Recommended_Grade__c, Reading_Comprehension__c, RB_Last_Name__c, RB_First_Name__c, Questions__c, Projects_of_Interest__c, Program_Year__c, Program_Start__c, Program_Start_Opinion__c, Program_Selector__c,
                                    Program_Duration__c, Profile_Summary__c, Private_High_School_Tuition__c, Private_High_School_Indicated__c, Private_Bedroom__c, Private_Bathroom__c, Prior_Visa_Start_Date__c, Prior_Visa_End_Date__c, Prior_Hosting_Agency__c, Prior_Host_Experience__c, Prior_Host_Experience_DEPR__c, Prior_Host_Description__c, Prior_Exchange_Visa__c, Prior_Exchange_Experience__c, Primary_Language__c, Primary_Activity__c, Previous_Address_Complete__c, PreUniversity_Years_at_Start__c, PreUniversity_Years_Required__c, Postal_Code__c,
                                    Position_Types__c, Position_Types_Other__c, Points_of_Interest__c, Pluto_Id__c, Placement_Pending__c, PhotoId__c, Pets_in_House__c, Pets__c, Pets_Description__c, Pet_Types__c, Pet_Count__c, Personality_Structure__c, Personality_Opinionatedness__c, Personality_Maturity__c, Personality_Independence__c, Personality_Funniness__c, Personality_Expressiveness__c, Personality_Energy_Level__c, Pax__c, Pax_Count__c, Passport_Number__c, Passport_Country__c, Partner_Name__c, Partner_Intrax_Id__c, Parent_Marital_Status__c,
                                    PR_Traditional_Family_Stmt__c, PR_Interview_Date__c, PR_English_Interview_Stmt__c, OwnerId, Own_insurance__c, Overall_Progress__c, Other_Languages__c, Opportunity_Name__c, Nemo_Update_Request_At__c, Nemo_Id__c, Nearest_City__c, Nationality_Preferences__c, Name, Meal_Self_Sufficient__c, Major__c, Low_Grade_Count__c, Location_of_Interest__c, Lives_With__c, Lives_With_Other__c, Lived_Independently__c, Lived_Independently_Description__c, Live_With_Smoker__c, Live_With_Pets__c, Live_With_Pets_Description__c, Legal_Guardian__c,
                                    Lead__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, Languages_Spoken__c, Language_spoken_years_3__c, Language_spoken_years_2__c, Language_spoken_years_1__c, Language_spoken_3__c, Language_spoken_2__c, Language_spoken_1__c, Language_3__c, Language_3_Proficiency__c, Language_2__c, Language_2_Proficiency__c, Language_1__c, Language_1_Proficiency__c, IsDeleted, Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Intrax_Insurance__c, Intrax_Homestay_Accommodations__c, Intrax_Center__c, Intrax_Accommodations__c,
                                    International_Travel__c, International_Travel_Description__c, Interests__c, Interests_Top__c, Incomplete_Missing_Documents__c, Incomplete_Documents_Notes__c, Id, How_Long_Tought__c, How_Long_Study_English__c, How_Heard__c, Household_Income_Range__c, Host_Special_Diet__c, Homestay__c, Home_Visit_Checklist__c, Home_Type__c, Home_Street_2__c, Home_Street_1__c, Home_State__c, Home_Responsibilities__c, Home_Province__c, Home_Postal_Code__c, Home_Phone__c, Home_Country__c, Home_City__c, Height__c, Health_Needs_Indicated__c,
                                    Health_Needs_Description__c, Graduation_Year__c, Graduation_Expected_by_School__c, Graduation_Date__c, Graduated__c, Government_Assistence_Indicated__c, General_Summary__c, Gender_Preference__c, GPA__c, GPA_Self_Reported__c, Functional_Areas__c, Functional_Areas_Other__c, Flight_Number__c, Flight_Arrival_Time__c, Flight_Arrival_Date__c, Field_Work_Experience__c, Fax__c, Family_Members_Complete__c, Family_Member_Count__c, Family_Activities__c, Extracurricular_Transportation__c, Express_Delivery__c, Exchange_Agency_Employment__c,
                                    Exchange_Agency_Employer_Name__c, Entity_Id__c, English_Test_Type__c, English_Test_Score__c, English_Teacher_Title__c, English_Teach_Name__c, English_Summary__c, English_Study_Years__c, English_Level__c, English_Ability__c, Engagement_Start__c, Engagement_End__c, Employer_Name__c, Emergency_Contact_Complete__c, Email__c, Education_Grade__c, ETR_Received_Date__c, ESSN__c, Double_Placement_Indicated__c, Distance_to_School__c, Disabilities__c, Disabilities_Description__c, Deposit_Fee_Accepted__c, Date_of_Birth__c, Daily_Meal_Commitment__c,
                                    Curfew_Weekends__c, Curfew_Weekdays__c, Curfew_Indicated__c, Criminal_Investigation_Indicated__c, Criminal_Investigation_Description__c, Criminal_Convictions_Indicated__c, Criminal_Convictions_Description__c, CreatedDate, CreatedById, Country_of_Interest__c, Country_of_Birth__c, Country__c, Coordinator__c, ConnectionSentId, ConnectionReceivedId, Community_Website__c, Community_Type__c, Community_Population__c, Community_Description__c, Classroom_Cooperation__c, City__c, Citizenship__c, Children_Enrolled__c, Check_out_Date__c, Check_in_Date__c,
                                    Center_Disclosure_Accepted__c, Carrier__c, Carrier_Number__c, Business_in_Home__c, Business_in_Home_Description__c, Best_Call_Time_c__c, Best_Call_Time__c, Behavioral_Problems__c, Behavioral_Problems_Description__c, Bedrooms__c, Bedroom_Type__c, Bedroom_Shared_With__c, Bedroom_Shared_Indicated__c, Bathrooms__c, Bathroom_Type__c, Attendance_Problems__c, Attendance_Problems_Description__c, Arriving_Time__c, Arriving_Date__c, Arrival_Time__c, Application_Stage__c, Application_Level__c,
                                    Applicant_Info_Count__c, Any_housing_that_fits_my_program_dates__c, Any_Special_Food_Requirement__c, Allergies_from_Partner__c, Allergies_from_Applicant__c, Allergies_Other_desc__c, Allergies_Other_Partner__c, Allergies_Indicated__c, Airport__c, Airport_Transfer_Departure__c, Airport_Transfer_Arrival__c, Account__c, Accommodation_Price_Range__c, Accommodation_Preference__c, Accepted_Date__c, Academic_Years_Completed__c, RecordType.Name, PageStatus_Complete__c, PageStatus_Started__c, Countries_of_Interest__c, Driving_Preference_indicated__c,
                                    Special_Diet_Expectations__c, Portal_Contact_Id__c, Account__r.FirstName, Account__r.LastName, Lead__r.IsConverted, CreatedBy__c ,US_Passport_Indicated__c,Swimming_Level__c,Swimming_Indicated__c, Swimming_Comfort_Children__c,Single_Mother_Indicated__c,Single_Father_Indicated__c,Same_Sex_Couple_Indicated__c,Preferred_Arrival_Date__c,Pets_Allergy_Indicated__c,Pets_Allergy_Description__c,Pet_Allergy_Types__c,Passport_Indicated__c,Aupair_Preferences__c,Away_Count__c,Childcare_Experience_Indicated__c,Children_Comfortable_Ages__c,Children_Special_Needs_Care__c,Children_Special_Needs_Description__c, Children_Special_Needs_Indicated__c,Children_Special_Needs_Skills__c,Drivers_Licence_Acquired__c,Drivers_Licence_Expires__c,Drivers_Licence_Indicated__c,Driving_Comfort_Children__c,
                                    Driving_Experience__c,Driving_Frequency__c,Driving_Snow_Experience__c,Driving_Transmission__c,Family_Description__c,Allergy_Description__c, Interest_Fine_Arts__c,Interests_Hobbies__c,Interests_Hobbies_Description__c,Interests_Leisure__c,Interest_Sports__c,Lived_Away_Indicated__c,Month_Arrival__c,Private_Bedroom_Indicated__c,Application_Type__c,AuPairsResponsibilities__c,Casper_Id__c
                                    from Applicant_Info__c 
                                    WHERE Id =: applicantInfo.Id ];
                 
                if(ApexPages.currentPage().getParameters().get('cloned') != null){ 
                    system.debug('debug::2If_InsideConstructor');
                    cloned = ApexPages.currentPage().getParameters().get('cloned');
                }
            }
            catch(Exception e){
                system.debug('debug::exception_InsideConstructor');
                // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be availabl
                System.debug('*****Imposible to get related ApplicantInfo data: ' + e);
            }
        }       
    }
    
    /* Should we move this into IUtilities or another Auxiliary class???? Is also used in AEC*/ 
    public void deleteAllowCloning(){
        try{
            list<Applicant_Info__c> applications = [SELECT Id, createdbyId, application_stage__c, SYS_allow_cloning__c, CreatedBy__c FROM Applicant_Info__c
                                                        WHERE CreatedBy__c =: userInfo.getUserId()];
            system.debug('********** Number of apps this belong to the current user: ' + applications.size());
            
            for(Applicant_Info__c a : applications){
                a.SYS_Allow_Cloning__c = false;
            }
            
            update applications;
        }catch(Exception e){
            system.debug('****** Impossible to update SYS_Allow_Cloning: ' + e);
        }
    }
    
            
    //AA For APC
    public pageReference CloneAppApc(){ 
            // Only the user that created the app must be able to clone it
            PageReference p;
            
            if(applicantInfo.CreatedBy__c == userInfo.getUserId()){
                applicantCloneApc(applicantInfo);
                personPaCloneApc(applicantInfo, applicantInfoClone);
                essayClone(applicantInfo, applicantInfoClone);
                experienceClone(applicantInfo, applicantInfoClone);
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You don?t have permissions to clone this record');
                ApexPages.addMessage(myMsg);
                //return null;
            }
            
            if(ApexPages.currentPage().getParameters().get('AppType') == 'Renewal'){
            
                p = new PageReference('/apex/apc_hf_app_personal_info?id=' + applicantInfoClone.Id);
                
            
            }else{
                system.debug('Debug::ApplicationType='+applicantInfo.type__c);
                If(applicantInfo.type__c=='Participant'){
                p = new PageReference('/apex/apc_ap_extension_pref?id=' + applicantInfoClone.Id);
                }
                else{
                p = new PageReference('/apex/apc_hf_app_extension_pref?id=' + applicantInfoClone.Id);
                }
            }
            
            system.debug('debug::PageReference==='+p);
            
            if(ApexPages.currentPage().getParameters().get('vstate') != null){
            p.getParameters().put('vstate',ApexPages.currentPage().getParameters().get('vstate'));
            }
            
            p.setRedirect(true);
            return p;
    } 
    
    public void applicantCloneApc(Applicant_Info__c appInfo)    {
                            
        try{
            system.debug('******* appInfo.Id: '+appInfo.Id );
                
            applicantInfoClone = appInfo.clone();
            
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Applicant_Info__c.fields.getMap();
            
            /*for(Schema.SObjectField sfield : M.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug('####### Gettin the field: ' + dfield.getName() );
                if(Constants_CloneApp.APPLICANTINFO_NOT_CLONED_FIELDS.get(dfield.getName()) != null){
                    if(! dfield.isNillable()){
                        system.debug('***** This is a boolean');
                        applicantInfoClone.put(sfield, false);
                    }else{
                        system.debug('***** the value is in the list');
                        applicantInfoClone.put(sfield, null);
                    }
                }
                else{
                    system.debug('****** The value is NOT in the list!!!');
                }
            }*/
            
            system.debug('****** Is lead Converted?: ' + AppInfo.Lead__r.IsConverted);
            if(!appInfo.Lead__r.IsConverted){
                applicantInfoClone.Lead__c = appInfo.Lead__c;
            }
            else applicantInfoClone.Lead__c = null;
            
            if(ApexPages.currentPage().getParameters().get('AppType') == 'Renewal'){
            applicantInfoClone.Name = appInfo.Account__r.FirstName + ' ' + appInfo.Account__r.LastName+ '-Renewal-'+System.Today().year();
            applicantInfoClone.Application_Type__c= 'Renewal';
            applicantInfoClone.PageStatus_Complete__c = '';
            
            }
            else{
            applicantInfoClone.Name = appInfo.Account__r.FirstName + ' ' + appInfo.Account__r.LastName+ '-Extension-'+System.Today().year();
            applicantInfoClone.Application_Type__c= 'Extension';
            applicantInfoClone.PageStatus_Complete__c = '';
            
            if(applicantInfoClone.RecordType.Name=='AuPairCare PT'){
                applicantInfoClone.Month_Arrival__c = null;
            }
            //applicantInfoClone.PageStatus_Started__c = '01;02;03;07';
            applicantInfoClone.Driving_Transmission__c='';
            }
            applicantInfoClone.Private_Bedroom_Indicated__c = null;  
            applicantInfoClone.CreatedBy__c = appInfo.CreatedBy__c;
            applicantInfoClone.RecordTypeId = appInfo.RecordTypeId;
            applicantInfoClone.Terms_Accepted__c = false;
            system.debug('*****###Flag2');
            applicantInfoClone.Application_Stage__c = 'Working';
            applicantInfoClone.Application_level__c = 'Main';
            deleteAllowCloning();
            
            insert applicantInfoClone;
            //AA Extension Essays
             If(applicantInfoClone.RecordType.Name=='AuPairCare PT'){
                List<Essay_Qs__c> essayQList = Essay_Qs__c.getAll().values();
                List<Essay__c> essayList_a = new List<Essay__c>();
                for(integer i=0;i<essayQList.size(); i++){
                    if(applicantInfoClone.Type__c == 'Participant' && applicantInfoClone.Intrax_Program__c == 'AuPairCare'){
                            system.debug('debug::ApplicationInfoType ='+applicantInfoClone.Type__c);
                            if(essayQList[i].Applicant_type__c == 'APC Participant Extension' && essayQList[i].active__c == true){
                            essayList_a.add(new Essay__c(Applicant_Info__c = applicantInfoClone.Id,ordinal__c = essayQList[i].ordinal__c,
                                                     Name = essayQList[i].Name,label__c = essayQList[i].essay_question__c ));
                            }
                    }
                }
                insert essayList_a; 

                If(essayList_a.size()>0){
                     for(Essay__c a: [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                WHERE Applicant_Info__c =: applicantInfoClone.Id
                                and (Not label__c Like '%What special talents or skills %')
                                ORDER BY ordinal__c ASC]){
                        a.Narrative__c= Null;
                        
                     }
                }
            }   
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be availabl
            system.debug('*****Imposible to clone Application: ' + e);
        }       
    }
    
        public static void personPaCloneApc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone )    {

	        try{
	            list<Person_Info__c> personInfo = [SELECT Work_Supervisor__c, Work_Phone__c, Title__c, TimeZoneSidKey__c, SystemModstamp, Special_Needs__c, Skype_Id__c, Role__c, Role_Other__c, Residency_Status__c, Profession__c, Primary_Applicant__c, Preferred_Phone_Type__c, Phone__c, Other_Phone__c, Nick_Name__c, Nemo_Id__c, Nationality__c, Name, Mobile__c, Middle_Name__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Intrax_Program_Option__c, Interests__c, Id, Gender__c, First_Name__c,   
	                                                Family_Member__c, Entity_Id__c, Employer_Name__c, Emergency_Contact__c, Emergency_Contact_Indicated__c, Email__c, Education_Level__c, ESSN__c, Do_you_smoke__c, Do_you_have_any_health_concerns__c, Date_of_Birth__c, CreatedDate, CreatedById, Country_of_Residence__c, ConnectionSentId, ConnectionReceivedId, Community_Service__c, Citizenship__c, Birth_Country__c, Birth_City__c, Best_Call_Time__c,            
	                                                Are_you_allergic_to_animals__c, Applicant_Info__c, Age__c, Age_At_Program_Start__c, Reference_Request_Note__c, Reference_Declined__c,Citizenship_Resident_Indicated__c,Offence_Indicated__c,Special_Needs_Description__c,Marital_Status__c,Special_Needs_Indicated__c,Source_Referral__c,Phone_Type__c,Source_Referral_Other__c,
	                                                Job_Sector__c
	                                                from Person_Info__c
	                                                Where Applicant_Info__c =: appInfo.Id and (Primary_Applicant__c = True or Role__c='Spouse or Partner' or Role__c='Child' or Role__c='Host')];
	            system.debug('*****@@@ personInfo.size(): ' + personInfo.size());                    
	            list<Person_Info__c> personInfoClone = personInfo.deepClone();
	            
	            for(Person_Info__c p:personInfoClone){
	                
	                p.Citizenship_Resident_Indicated__c = null;
	                p.Offence_Indicated__c = null;
	                p.Criminal_Convictions_Description__c = null;
	                p.English_Fluency__c = null; 
	                p.Best_Call_Time__c=null;
	                
	                map<String, Schema.SObjectField> M = Schema.SObjectType.Person_Info__c.fields.getMap();
	                system.debug('####### Gettin the SSSfieldvalues: ' + M.Values());
	                for(Schema.SObjectField sfield : M.Values()){
	                    schema.describefieldresult dfield = sfield.getDescribe();
	                    system.debug('####### Gettin the field: ' + dfield.getName() );
	                    
	                        if(! dfield.isNillable()){
	                    if(Constants_CloneApp.PERSONINFO_NOT_CLONED_FIELDS.get(dfield.getName()) != null){
	                            p.put(sfield, false);
	                    }
	                    else{
	                            system.debug('***** the value is in the list');
	                        }
	                    }
	                    else{
	                        system.debug('****** The value is NOT in the list!!!');
	                    }
	                }
	                
	                p.Applicant_Info__c = appInfoClone.Id;
	            }
	            system.debug('*****@@@ personInfoClone: ' + personInfoClone);  
	            insert personInfoClone;
	        
	        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be availabl
            system.debug('****** Impossible to clone PersonInfoAPC Data for applicant '+ appInfoClone.Id + ': ' + e);
        	}           
        }
    
    //AA APC Experience
        public static void experienceClone(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone){
        
        Map<Id, list<Experience_Detail__c>> experienceDetMap = new Map<Id, list<Experience_Detail__c>>();
        list<Experience_Detail__c> InsertexperdetailClone = new  list<Experience_Detail__c>();
       
	        try{
	            list<Experience__c> experience = [SELECT  e.Name, e.Amount_Hours_Under_2__c, e.Amount_Hours__c, e.Start_Date__c,e.End_Date__c, e.Experience_Type__c,e.Id, e.Experience_Category__c, e.Frequency__c,e.Position_Description__c,e.IsExperienced__c,e.Employer_Name__c,e.Email__c,e.Phone_Country_Code__c,e.Phone__c,e.Reference_Request_Note__c,e.Position_Title__c,
	                                            e.Skills_Required__c,e.First_Name__c,e.Last_Name__c, e.Applicant_Info__c,e.Employment_Hrs__c,e.Position_Responsibilities__c,e.Experience_Clone_Id__c,
	                                            Special_Needs_Description__c,Children_Ages__c,Number_of_Children__c,Special_Needs_Indicated__c,Current_Job__c,Under_2_Percentage__c
	                                            FROM Experience__c e
	                                            WHERE e.Applicant_Info__c =: appInfo.Id];
	            
	            for(Experience__c ex: experience){
	           
	                list<Experience_Detail__c> experienceDetList = [Select e.SystemModstamp, e.Special_Needs_Indicated__c, e.Special_Needs_Description__c, e.Name,
	                                                e.LastModifiedDate, e.LastModifiedById, e.LastActivityDate, e.IsDeleted, e.Id, e.Gender__c, e.Experience_Name__c, e.Date_of_Birth__c,
	                                                e.CurrencyIsoCode, e.CreatedDate, e.CreatedById, e.ConnectionSentId, e.ConnectionReceivedId
	                                                From Experience_Detail__c e
	                                                WHERE e.Experience_Name__c =: ex.Id];
	                
	                if(experienceDetList != null){
	                    list<Experience_Detail__c> experienceDetclone = experienceDetList.deepClone();
	                    experienceDetMap.put(ex.Id, experienceDetclone);
	                }
	            }
	            //get experience Id from Experience List into new the Experience_Clone_Id__c field.
	            for(Experience__c exp: experience){
	                exp.Experience_Clone_Id__c= exp.id;
	            }
	            
	            list<Experience__c> experienceClone = experience.deepClone();
	            system.debug('******* experienceClone: ' + experienceClone);
	            
	            for(Experience__c e: experienceClone){
	                e.Applicant_Info__c = appInfoClone.Id;
	            }
	            insert experienceClone;
	           
	           if(experienceDetMap != null && experienceDetMap.size() > 0){
	               for(Experience__c expclone: experienceClone){
	                    for(Experience_Detail__c expDetclone:experienceDetMap.get(expclone.Experience_Clone_Id__c)){
	                        expDetclone.Experience_Name__c=expclone.id;
	                        InsertexperdetailClone.add(expDetclone);
	                    }
	                }
	                insert InsertexperdetailClone;
	                //End Experience Deep clone
	            }
	            
	        }catch(Exception e){
            system.debug('****** Impossible to clone experience Data for applicant '+ appInfoClone.Id + ': ' + e);
        	}
        }
       
    public static void essayCloneapc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone){
        try{
            list<Essay__c> essay = [SELECT e.Ordinal__c, e.Narrative__c, e.Name, e.Length__c, e.Language__c, e.Label__c, e.IsDeleted, e.Id, e.Applicant_Info__c
                                        FROM Essay__c e
                                        WHERE e.Applicant_Info__c =: appInfo.Id]; 
                                        
            list<Essay__c> essayClone = essay.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(Essay__c e: essayClone){
                e.Applicant_Info__c = appInfoClone.Id;
            }
            
            insert essayClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
    }
       
    //===End of APC Clone Functionality ====
       
        public pageReference CloneApp(){ 
            // Only the user that created the app must be able to clone it
            if(applicantInfo.CreatedBy__c == userInfo.getUserId()){
                applicantClone(applicantInfo);
                personPaClone(applicantInfo, applicantInfoClone);
                memberClone(applicantInfo, applicantInfoClone);
                schoolClone(applicantInfo, applicantInfoClone);             
                locationClone(applicantInfo, applicantInfoClone);
                essayClone(applicantInfo, applicantInfoClone);
            }
            else{
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You don�t have permissions to clone this record');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            PageReference p = new PageReference('/apex/ayusa_hf_clone?cloned=true&id=' + applicantInfo.Id);
            p.setRedirect(true);
            return p;
    } 
    
    public void applicantClone(Applicant_Info__c appInfo)   {
                            
        try{
            system.debug('******* appInfo.Id: '+appInfo.Id );
                
            applicantInfoClone = appInfo.clone();
            
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Applicant_Info__c.fields.getMap();
            
            for(Schema.SObjectField sfield : M.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug('####### Gettin the field: ' + dfield.getName() );
                if(Constants_CloneApp.APPLICANTINFO_NOT_CLONED_FIELDS.get(dfield.getName()) != null){
                    if(! dfield.isNillable()){
                        system.debug('***** This is a boolean');
                        applicantInfoClone.put(sfield, false);
                    }else{
                        system.debug('***** the value is in the list');
                        applicantInfoClone.put(sfield, null);
                    }
                }
                else{
                    system.debug('****** The value is NOT in the list!!!');
                }
            }
            
            system.debug('****** Is lead Converted?: ' + AppInfo.Lead__r.IsConverted);
            if(!appInfo.Lead__r.IsConverted){
                applicantInfoClone.Lead__c = appInfo.Lead__c;
            }
            else applicantInfoClone.Lead__c = null;
            
            applicantInfoClone.Name = appInfo.Account__r.FirstName + ' ' + appInfo.Account__r.LastName;
            applicantInfoClone.CreatedBy__c = appInfo.CreatedBy__c;
            applicantInfoClone.RecordTypeId = appInfo.RecordTypeId;
            applicantInfoClone.Application_Stage__c = 'Working';
            
            deleteAllowCloning();
            
            insert applicantInfoClone;
                
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be availabl
            system.debug('*****Imposible to clone Application: ' + e);
        }       
    }
    
    //Cloning Primary Applicant from Person Info Object
    
    public static void personPaClone(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone )    {
        
        try{
            list<Person_Info__c> personInfo = [SELECT Work_Supervisor__c, Work_Phone__c, Title__c, TimeZoneSidKey__c, SystemModstamp, Special_Needs__c, Skype_Id__c, Role__c, Role_Other__c, Residency_Status__c, Profession__c, Primary_Applicant__c, Preferred_Phone_Type__c, Phone__c, Other_Phone__c, Nick_Name__c, Nemo_Id__c, Nationality__c, Name, Mobile__c, Middle_Name__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Intrax_Program_Option__c, Interests__c, Id, Gender__c, First_Name__c,
                                                    Family_Member__c, Entity_Id__c, Employer_Name__c, Emergency_Contact__c, Emergency_Contact_Indicated__c, Email__c, Education_Level__c, ESSN__c, Do_you_smoke__c, Do_you_have_any_health_concerns__c, Date_of_Birth__c, CreatedDate, CreatedById, Country_of_Residence__c, ConnectionSentId, ConnectionReceivedId, Community_Service__c, Citizenship__c, Birth_Country__c, Birth_City__c, Best_Call_Time__c, 
                                                    Are_you_allergic_to_animals__c, Applicant_Info__c, Age__c, Age_At_Program_Start__c, Reference_Request_Note__c, Reference_Declined__c,Citizenship_Resident_Indicated__c,Offence_Indicated__c,Special_Needs_Description__c,Marital_Status__c,Special_Needs_Indicated__c
                                                    from Person_Info__c
                                                    Where Applicant_Info__c =: appInfo.Id and Primary_Applicant__c = true LIMIT 1];
                                
            list<Person_Info__c> personInfoClone = personInfo.deepClone();
            
            
            for(Person_Info__c p:personInfoClone){
                
                
                map<String, Schema.SObjectField> M = Schema.SObjectType.Person_Info__c.fields.getMap();
                
                for(Schema.SObjectField sfield : M.Values()){
                    schema.describefieldresult dfield = sfield.getDescribe();
                    system.debug('####### Gettin the field: ' + dfield.getName() );
                        if(! dfield.isNillable()){
                    if(Constants_CloneApp.PERSONINFO_NOT_CLONED_FIELDS.get(dfield.getName()) != null){
                            p.put(sfield, false);
                        }else{
                            system.debug('***** the value is in the list');
                            //D-01408 (Start) -- Commented below line
                           // p.put(sfield, null);
                           //D-01408 (End)
                        }
                    }
                    else{
                        system.debug('****** The value is NOT in the list!!!');
                    }
                }
                
                p.Applicant_Info__c = appInfoClone.Id;
            }
            insert personInfoClone;
        
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be availabl
            system.debug('****** Impossible to clone PersonInfo Data for applicant '+ appInfoClone.Id + ': ' + e);
        }           
    }
    
    

    
    //Cloning Members from Members to Person Info object
    
    public static void memberClone(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone )  {
        
        try{
            
            list<Person_Info__c> newpersonInfo = new list<Person_Info__c>();
            
            list<Member__c> memberInfo = [SELECT Name,Account_Name__c, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c,
                                            Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c,
                                            Country_of_Residence__c, Other_Phone__c, Role_Other__c, Residency_Status__c, Title__c,
                                            Work_Supervisor__c, Employer_Name__c, Intrax_Program_Option__c, ESSN__c from Member__c Where Account_Name__c =: appInfo.Account__c];
        
            system.debug('#####member.size():' + memberInfo.size());
                        
            if (memberInfo.size()>0){
            
            for(Member__c m:memberInfo){
            
                Person_Info__c personInfoNew = new Person_Info__c();
                personInfoNew.Name = m.Name;
                personInfoNew.First_Name__c = m.First_Name__c;
                personInfoNew.Last_Name__c = m.Last_Name__c;
                personInfoNew.Date_Of_Birth__c = m.Date_Of_Birth__c;
                personInfoNew.Role__c = m.Role__c;
                personInfoNew.Gender__c = m.Gender__c;
                personInfoNew.Email__c = m.Email__c;
                personInfoNew.Mobile__c = m.Mobile__c;
                personInfoNew.Phone__c = m.Phone__c;
                personInfoNew.Profession__c = m.Profession__c;
                personInfoNew.Emergency_Contact_Indicated__c = m.Emergency_Contact_Indicated__c;
                personInfoNew.Family_Member__c = m.Family_Member__c;
                personInfoNew.Country_of_Residence__c = m.Country_of_Residence__c;
                personInfoNew.Other_Phone__c = m.Other_Phone__c;
                personInfoNew.Role_Other__c = m.Role_Other__c;
                personInfoNew.Residency_Status__c = m.Residency_Status__c;
                personInfoNew.Title__c = m.Title__c;
                personInfoNew.Employer_Name__c = m.Employer_Name__c;
                personInfoNew.Work_Supervisor__c = m.Work_Supervisor__c;
                personInfoNew.ESSN__c = m.ESSN__c;
                personInfoNew.Applicant_Info__c = appInfoClone.Id;
                
                system.debug('#####show personinfoNew before add:' + personInfoNew);
                            
                newpersonInfo.add(personInfoNew);
                
                    
            }
                        
            insert (newpersoninfo);
            
            }
        
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be availabl
            system.debug('****** Impossible to clone MemberInfo Data for applicant '+ appInfoClone.Id + ': ' + e);
        }           
    }
    
    public void schoolClone(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone ) {
        
        try{
            if(appInfo.Type__c == 'Host Family'){

                appInfoClone.RecordTypeId = constants.AyusaHF_Record_Type_Id; 
                                
                list<School__c> school = [SELECT SystemModstamp, Student_Census__c, Street__c, State__c, Postal_Code__c, Phone__c, Name__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, Email__c, CreatedDate, CreatedById, Country__c, Contact_Title__c, Contact_Name__c, ConnectionSentId, ConnectionReceivedId, City__c, Category__c, Applicant_Info__c, Academic_Year_Start__c
                                                from School__c 
                                                WHERE Applicant_Info__c =: appInfo.Id];
                            
                list<School__c> schoolClone = school.deepClone();
                
                for(School__c s: schoolClone){
                    s.Applicant_Info__c = appInfoClone.Id; 
                }
                
                insert schoolClone;
                
                }
        }catch(Exception e){
                // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be availabl
                System.debug('****** Impossible to clone School Data for applicant '+ appInfoClone.Id + ': ' + e);
               
        }
    }
    
    public static void essayClone(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone){
        try{
            list<Essay__c> essay = [SELECT e.Ordinal__c, e.Narrative__c, e.Name, e.Length__c, e.Language__c, e.Label__c, e.IsDeleted, e.Id, e.Applicant_Info__c
                                        FROM Essay__c e
                                        WHERE e.Applicant_Info__c =: appInfo.Id AND e.Ordinal__c !=16];
                                        
            list<Essay__c> essayClone = essay.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(Essay__c e: essayClone){
                e.Applicant_Info__c = appInfoClone.Id;
            }
            
            insert essayClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
    }
    
    public static void locationClone(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone )    {
        
        try{
            if(appInfo.Type__c == 'Host Family'){
                //Mapping Object Location__c and updating field CreatedDate and Applicant_Info__c
                List<Location__c> location = [SELECT Type__c, SystemModstamp, Street__c, State__c, Postal_Code__c, Occupancy_Years__c, Occupancy_Start__c, Occupancy_End__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CreatedDate, CreatedById, Country__c, ConnectionSentId, ConnectionReceivedId, City__c, Applicant_Info__c
                                                from Location__c 
                                                WHERE Applicant_Info__c =: appInfo.Id];
                
                list<Location__c> locationClone = location.deepClone();
                            
                for(Location__c l:locationClone){                       
                    l.Applicant_Info__c = appInfoClone.Id;
                }
                            
                insert locationClone;
                
                }
            }catch(Exception e){
                System.debug('****** Impossible to clone Location Data for applicant '+ appInfoClone.Id + ': ' + e);
                }
    }
            
        //else if(applicantInfo.Type__c == 'Participant'){
/*              
                //Mapping Object Essay__c and updating field CreatedDate and Applicant_Info__c
                
                essay = [SELECT SystemModstamp, Ordinal__c, Narrative__c, Name, Length__c, LastModifiedDate, LastModifiedById, Language__c, Label__c, IsDeleted, Id, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId, Applicant_Info__c
                from Essay__c WHERE Applicant_Info__c =: applicantInfo.Id]; 
                
                List<Location__c> essayClone = new List<Location__c>();
                essayClone = essay;
                essayClone.CreatedDate = date.today();
                essayClone.Applicant_Info__c = applicantInfoClone.Id; // new Applicant_Info --> new Id --> new applicant_info__c
                
                insert essayClone;
    */
    
    public pageReference navigateToNewAppHome(){
        Applicant_Info__c newApp;
        try{
            newapp = [SELECT Id FROM Applicant_Info__c WHERE CreatedBy__c =: userInfo.getUserId() order by CreatedDate DESC LIMIT 1];
            
        }catch (Exception e){
            system.debug('****** Something wrong happened trying to get the newest record!!');
        }
        
        Pagereference p = new PageReference('/apex/ayusa_hf_home?id=' + newApp.Id);
        p.setRedirect(true);
        return p;
    }
    
    public string getnewAppId(){
        Applicant_Info__c newApp;
        try{
            newApp = [SELECT Id FROM Applicant_Info__c WHERE CreatedBy__c =: userInfo.getUserId() order by CreatedDate DESC LIMIT 1];
            
        }catch (Exception e){
            system.debug('****** Something wrong happened trying to get the newest record!!');
        }
        return newApp.Id;
        
    }
    
    public boolean getcheckWorkingApps(){
        
        list<Applicant_Info__c> apps = [SELECT Id FROM Applicant_Info__c WHERE Application_Stage__c =: 'Working' AND CreatedBy__c =: userInfo.getUserId()];
        if(apps.size() == 0) return true;
        else return false;
    }
    
    public PageReference checkLogin() {
        PageReference p;
        boolean setreturn;
        if (userInfo.getUserType() == 'Guest'){
            p = Page.AppEngine_SiteLoginPage;
            p.setRedirect(true);
            return p;
        } else
            return null;
              
            
    }       
    
}