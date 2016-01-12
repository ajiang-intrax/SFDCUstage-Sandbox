public without sharing class extension_controller 
{
    public Applicant_Info__c applicantInfo{get;set;}
    private list<Person_Info__c> personInfo;
    private list<Member__c> memberInfo;
    
    public string cloned{get;set;}
    public string ExtensionPref{get;set;}
    public Applicant_Info__c applicantInfoClone{get;set;} //= new Applicant_Info__c();
    
    public String vstate {get;set;}
    
    public String userAgentCheck{get;set;}
    
    // 2. The Constructor: Here is where almost all the main action happen
    public extension_controller(ApexPages.StandardController controller)
    {
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
                                    Center_Disclosure_Accepted__c, Carrier__c, Carrier_Number__c, Business_in_Home__c, Business_in_Home_Description__c, Best_Call_Time_c__c, Best_Call_Time__c, Behavioral_Problems__c, Behavioral_Problems_Description__c, Bedrooms__c, Bedroom_Type__c, Bedroom_Shared_With__c, Bedroom_Shared_Indicated__c, Bathrooms__c, Bathroom_Type__c, BGC_Required_Count_AYU__c, BGC_Passed_Count_AYU__c, BGC_D_Remaining__c, Attendance_Problems__c, Attendance_Problems_Description__c, Arriving_Time__c, Arriving_Date__c, Arrival_Time__c, Application_Stage__c, Application_Level__c,
                                    Applicant_Info_Count__c, Any_housing_that_fits_my_program_dates__c, Any_Special_Food_Requirement__c, Allergies_from_Partner__c, Allergies_from_Applicant__c, Allergies_Other_desc__c, Allergies_Other_Partner__c, Allergies_Indicated__c, Airport__c, Airport_Transfer_Departure__c, Airport_Transfer_Arrival__c, Account__c, Accommodation_Price_Range__c, Accommodation_Preference__c, Accepted_Date__c, Academic_Years_Completed__c, RecordType.Name, PageStatus_Complete__c, PageStatus_Started__c, Countries_of_Interest__c, Driving_Preference_indicated__c,
                                    Special_Diet_Expectations__c, Portal_Contact_Id__c, Account__r.FirstName, Account__r.LastName, Lead__r.IsConverted, CreatedBy__c ,US_Passport_Indicated__c,Swimming_Level__c,Swimming_Indicated__c, Swimming_Comfort_Children__c,Single_Mother_Indicated__c,Single_Father_Indicated__c,Same_Sex_Couple_Indicated__c,Preferred_Arrival_Date__c,Pets_Allergy_Indicated__c,Pets_Allergy_Description__c,Pet_Allergy_Types__c,Passport_Indicated__c,Aupair_Preferences__c,Away_Count__c,Childcare_Experience_Indicated__c,Children_Comfortable_Ages__c,Children_Special_Needs_Care__c,Children_Special_Needs_Description__c, Children_Special_Needs_Indicated__c,Children_Special_Needs_Skills__c,Drivers_Licence_Acquired__c,Drivers_Licence_Expires__c,Drivers_Licence_Indicated__c,Driving_Comfort_Children__c,
                                    Driving_Experience__c,Driving_Frequency__c,Driving_Snow_Experience__c,Driving_Transmission__c,Family_Description__c,Allergy_Description__c, Interest_Fine_Arts__c,Interests_Hobbies__c,Interests_Hobbies_Description__c,Interests_Leisure__c,Interest_Sports__c,Lived_Away_Indicated__c,Month_Arrival__c,Private_Bedroom_Indicated__c,Application_Type__c,AuPairsResponsibilities__c,Casper_Id__c,
                                    Position__c, Engagement__c, Reason__c,Engagement__r.Engagement_End__c
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
    
    public void checkUser(){
        //Check if the device is a Mobile device 
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        //system.debug('*****@@@userAgent: '+ userAgent);
        userAgentCheck = '';
        //system.debug('*****@@@into checkIsMobile');
        
        if(!Test.isRunningTest()) {
            if(userAgent.contains('Mobi') && !userAgent.contains('iPad')) {
                userAgentCheck = 'smartphone';
                system.debug('*****@@@userAgentCheck: '+ userAgentCheck);
            }
        }else{
        
            userAgent = 'rv:11.0';
            userAgentCheck = 'smartphone';
        }
        //**end of the checking isMobile process
        
        //AA 27022014 Ayusa II (AY2)#626To resolve Empty Text Area Rendering issue which insert garbage Html code.      
        //AA APC New version CSS Browser Compatibility Fixed.
        system.debug('debug::'+userAgent);
        if(userAgent.contains('rv:11.0')) {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        }
        else{
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', ' IE=Edge');
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
    
    public pageReference HFCancelProcess()
    { 
        /*applicantInfo.Name = applicantInfo.Account__r.FirstName + ' ' + applicantInfo.Account__r.LastName+ '-Renewal-'+System.Today().year();
        applicantInfo.Application_Type__c= 'Renewal';
        applicantInfo.PageStatus_Complete__c = '';
        update applicantInfo;*/
        system.debug('***applicantInfo*****'+applicantInfo);
        if (applicantInfo.Application_Stage__c != 'Accepted')
        {
            if(applicantInfo.Position__c != NULL)
            {
                system.debug('***applicantInfo.Position__c*****'+applicantInfo.Position__c);
                list<Match__c> match = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Position_Name__c =: applicantInfo.Position__c AND Status__c NOT IN ('Confirmed', 'Withdrawn') ORDER BY CreatedDate DESC];
                if(match.size()>0)
                {
                    if(match[0].Engagement__c != NULL)
                    {
                        list<Applicant_Info__c> WorkingApApps = [SELECT Engagement__c, Opportunity_Name__c, Account__c, Account__r.FirstName, Account__r.LastName, Application_Type__c, Reason__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE Engagement__c = :match[0].Engagement__c ORDER BY CreatedDate DESC];
                        if(WorkingApApps.size()>0)
                        {
                            /*if (WorkingApApps[0].Opportunity_Name__c != NULL)
                            {
                                list<Opportunity> delopplist = [SELECT ID, Name FROM Opportunity WHERE ID =: WorkingApApps[0].Opportunity_Name__c];
                                if(delopplist.size() > 0)
                                {
                                    delete delopplist;
                                }
                            }*/
                            
                            string enggid = WorkingApApps[0].Engagement__c;
                            
                            WorkingApApps[0].Application_Stage__c = 'Cancelled';
                            WorkingApApps[0].Reason__c = 'Lost Interest';
                            update WorkingApApps[0];
                            
                            list<Applicant_Info__c> listlastAcceptedapp = [SELECT Engagement__c, Position__c, Opportunity_Name__c, Account__c, Account__r.FirstName, Account__r.LastName, Application_Type__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE Account__c = :WorkingApApps[0].Account__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                            if(listlastAcceptedapp.size() > 0)
                            {
                                list<Intrax_Program_Upload__c> cancellipulist = [SELECT Applicant_Info__c, Engagement__c FROM Intrax_Program_Upload__c WHERE Applicant_Info__c =: WorkingApApps[0].id];
                                if(cancellipulist.size() > 0)
                                {
                                    for (Intrax_Program_Upload__c ipu : cancellipulist)
                                    {
                                        ipu.Applicant_Info__c = listlastAcceptedapp[0].Id;
                                        ipu.Engagement__c = listlastAcceptedapp[0].Engagement__c;
                                    }
                                    update cancellipulist;
                                }
                                
                                updateExtensionAPAgreed(listlastAcceptedapp[0].id);
                                
                            }
                            
                            if (enggid != NULL)
                            {
                                list<Engagement__c> delEngglist = [SELECT ID, Name FROM Engagement__c WHERE ID =: enggid];
                                if(delEngglist.size() > 0)
                                {
                                    delete delEngglist;
                                }
                            }
                        }
                    }
                    
                    delete match;
                }
            }
            
            /*if (applicantInfo.Opportunity_Name__c != NULL)
            {
                list<Opportunity> delhfopplist = [SELECT ID, Name FROM Opportunity WHERE ID =: applicantInfo.Opportunity_Name__c];
                if(delhfopplist.size() > 0)
                {
                    delete delhfopplist;
                }
            }*/
            
            
            string posid = applicantInfo.Position__c;
            
            applicantInfo.Position__c = NULL;
            applicantInfo.Application_Stage__c = 'Cancelled';
            applicantInfo.Reason__c = 'Lost Interest';
            update applicantInfo;
            
            list<Applicant_Info__c> listlastAcceptedapp = [SELECT Engagement__c, Position__c, Opportunity_Name__c, Account__c, Account__r.FirstName, Account__r.LastName, Application_Type__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE Account__c = :applicantInfo.Account__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
            if(listlastAcceptedapp.size() > 0)
            {
                list<Intrax_Program_Upload__c> cancellipulist = [SELECT Applicant_Info__c, Engagement__c FROM Intrax_Program_Upload__c WHERE Applicant_Info__c =: applicantInfo.id];
                if(cancellipulist.size() > 0)
                {
                    for (Intrax_Program_Upload__c ipu : cancellipulist)
                    {
                        ipu.Applicant_Info__c = listlastAcceptedapp[0].Id;
                        ipu.Engagement__c = listlastAcceptedapp[0].Engagement__c;
                    }
                    update cancellipulist;
                }
                
                listlastAcceptedapp[0].Extension_Au_Pair_Agreed__c='No'; 
                update listlastAcceptedapp[0];
            }
            
            if (posid != NULL)
            {
                list<Position__c> delhfpos = [SELECT ID, Name FROM Position__c WHERE ID =: posid];
                if(delhfpos.size() > 0)
                {
                    delete delhfpos;
                }
            }
        }
        PageReference p = new PageReference('/apex/apc_hf_home');
        p.setRedirect(true);
        return p;
    }
    
    public pageReference APCancelProcess()
    { 
        system.debug('***applicantInfo*****'+applicantInfo);
        if (applicantInfo.Application_Stage__c != 'Accepted')
        {
            if(applicantInfo.Engagement__c != NULL)
            {
                system.debug('***applicantInfo.Engagement__c*****'+applicantInfo.Engagement__c);
                list<Match__c> match = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Engagement__c =: applicantInfo.Engagement__c AND Status__c NOT IN ('Confirmed', 'Withdrawn') ORDER BY CreatedDate DESC];
                if(match.size()>0)
                {
                    if(match[0].Position_Name__c != NULL)
                    {
                        list<Applicant_Info__c> WorkingHFApps = [SELECT Engagement__c, Position__c, Opportunity_Name__c, Account__c, Account__r.FirstName, Account__r.LastName, Application_Type__c, PageStatus_Complete__c, Reason__c FROM Applicant_Info__c WHERE Position__c = :match[0].Position_Name__c ORDER BY CreatedDate DESC];
                        if(WorkingHFApps.size()>0)
                        {
                            
                            
                            string posid = WorkingHFApps[0].Position__c;
                            
                            
                            WorkingHFApps[0].Application_Stage__c = 'Cancelled';
                            WorkingHFApps[0].Reason__c = 'Lost Interest';
                            update WorkingHFApps[0];
                            
                            list<Applicant_Info__c> listlastAcceptedapp = [SELECT Engagement__c, Position__c, Opportunity_Name__c, Account__c, Account__r.FirstName, Account__r.LastName, Application_Type__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE Account__c = :WorkingHFApps[0].Account__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                            if(listlastAcceptedapp.size() > 0)
                            {
                                list<Intrax_Program_Upload__c> cancellipulist = [SELECT Applicant_Info__c, Engagement__c FROM Intrax_Program_Upload__c WHERE Applicant_Info__c =: WorkingHFApps[0].id];
                                if(cancellipulist.size() > 0)
                                {
                                    for (Intrax_Program_Upload__c ipu : cancellipulist)
                                    {
                                        ipu.Applicant_Info__c = listlastAcceptedapp[0].Id;
                                        ipu.Engagement__c = listlastAcceptedapp[0].Engagement__c;
                                    }
                                    update cancellipulist;
                                }
                                
                                updateExtensionAPAgreed(listlastAcceptedapp[0].id);
                            }
                            
                            if (posid != NULL)
                            {
                                if (match.size()>0)
                                {
                                    for (match__c m: match)
                                    {
                                        m.Status__c = 'Withdrawn';
                                    }
                                    update match;
                                }
                                
                                list<Position__c> delhfpos = [SELECT ID, Name FROM Position__c WHERE ID =: posid];
                                if(delhfpos.size() > 0)
                                {
                                    delete delhfpos;
                                }
                            }
                        }
                    }
                    
                    //delete match;
                }
            }
            
            /*if (applicantInfo.Opportunity_Name__c != NULL)
            {
                list<Opportunity> delhfopplist = [SELECT ID, Name FROM Opportunity WHERE ID =: applicantInfo.Opportunity_Name__c];
                if(delhfopplist.size() > 0)
                {
                    delete delhfopplist;
                }
            }*/
            
            
            string enggid = applicantInfo.Engagement__c;
            
            applicantInfo.Position__c = NULL;
            applicantInfo.Application_Stage__c = 'Cancelled';
            
            system.debug('@@@@@AppType Cancel PT: ' + ApexPages.currentPage().getParameters().get('AppType'));
            
            if(ApexPages.currentPage().getParameters().get('AppType') != 'noExtend'){
                applicantInfo.Reason__c = 'Lost Interest';
            }
            
            update applicantInfo;
            
            list<Applicant_Info__c> listlastAcceptedapp = [SELECT Engagement__c, Position__c, Opportunity_Name__c, Account__c, Account__r.FirstName, Account__r.LastName, Application_Type__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE Account__c = :applicantInfo.Account__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
            if(listlastAcceptedapp.size() > 0)
            {
                list<Intrax_Program_Upload__c> cancellipulist = [SELECT Applicant_Info__c, Engagement__c FROM Intrax_Program_Upload__c WHERE Applicant_Info__c =: applicantInfo.id];
                if(cancellipulist.size() > 0)
                {
                    for (Intrax_Program_Upload__c ipu : cancellipulist)
                    {
                        ipu.Applicant_Info__c = listlastAcceptedapp[0].Id;
                        ipu.Engagement__c = listlastAcceptedapp[0].Engagement__c;
                    }
                    update cancellipulist;
                }
                
                if(ApexPages.currentPage().getParameters().get('AppType') == 'noExtend'){
                    listlastAcceptedapp[0].Extension_Au_Pair_Agreed__c='No'; 
                }
                if(ApexPages.currentPage().getParameters().get('AppType') == 'newFamily'){
                    listlastAcceptedapp[0].Extension_Au_Pair_Agreed__c='No'; 
                }
                
                update listlastAcceptedapp[0];
            }
            
            
            if (enggid != NULL)
            {
                list<Engagement__c> delEngglist = [SELECT ID, Name FROM Engagement__c WHERE ID =: enggid];
                if(delEngglist.size() > 0)
                {
                    delete delEngglist;
                }
            }
        }
        PageReference p = new PageReference('/apex/apc_ap_home');
        p.setRedirect(true);
        return p;
    }
    
    
    /*public pageReference APExtensiontoRenew()
    { 
        applicantInfo.Name = applicantInfo.Account__r.FirstName + ' ' + applicantInfo.Account__r.LastName+ '-Renewal-'+System.Today().year();
        applicantInfo.Application_Type__c= 'Renewal';
        applicantInfo.PageStatus_Complete__c = '';
        update applicantInfo;
        
        if(applicantInfo.Engagement__c != NULL)
        {
            list<Match__c> match = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Engagement__c =: applicantInfo.Engagement__c AND Status__c NOT IN ('Confirmed', 'Withdrawn') ORDER BY CreatedDate DESC];
            if(match.size()>0)
            {
                if(match[0].Position_Name__c != NULL)
                {
                    list<Applicant_Info__c> WorkingApApps = [SELECT Account__r.FirstName, Account__r.LastName, Application_Type__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE Position__c = :match[0].Position_Name__c ORDER BY CreatedDate DESC];
                    if(WorkingApApps.size()>0)
                    {
                        //WorkingApApps[0].Name = WorkingApApps[0].Account__r.FirstName + ' ' + WorkingApApps[0].Account__r.LastName+ '-Renewal-'+System.Today().year();
                        //WorkingApApps[0].Application_Type__c= 'Renewal';
                        //WorkingApApps[0].PageStatus_Complete__c = '';
                        WorkingApApps[0].Extension_Au_Pair_Agreed__c='No'; 
                        update WorkingApApps[0];
                    }
                }
                
                for(Match__c m: match)
                {
                    m.Status__c='Withdrawn';
                }
                update match;
            }
        }
        PageReference p = new PageReference('/apex/apc_ap_extension_pref?id=' + applicantInfo.id);
        p.setRedirect(true);
        return p;
    }
    
    
    public pageReference HFExtensiontoRenew()
    { 
        applicantInfo.Name = applicantInfo.Account__r.FirstName + ' ' + applicantInfo.Account__r.LastName+ '-Renewal-'+System.Today().year();
        applicantInfo.Application_Type__c= 'Renewal';
        applicantInfo.PageStatus_Complete__c = '';
        update applicantInfo;
        
        if(applicantInfo.Position__c != NULL)
        {
            list<Match__c> match = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Position_Name__c =: applicantInfo.Position__c AND Status__c NOT IN ('Confirmed', 'Withdrawn') ORDER BY CreatedDate DESC];
            if(match.size()>0)
            {
                if(match[0].Engagement__c != NULL)
                {
                    list<Applicant_Info__c> WorkingApApps = [SELECT Account__r.FirstName, Account__r.LastName, Application_Type__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE Engagement__c = :match[0].Engagement__c ORDER BY CreatedDate DESC];
                    if(WorkingApApps.size()>0)
                    {
                        WorkingApApps[0].Name = WorkingApApps[0].Account__r.FirstName + ' ' + WorkingApApps[0].Account__r.LastName+ '-Renewal-'+System.Today().year();
                        WorkingApApps[0].Application_Type__c= 'Renewal';
                        WorkingApApps[0].PageStatus_Complete__c = '';
                        update WorkingApApps[0];
                    }
                }
                
                for(Match__c m: match)
                {
                    m.Status__c='Withdrawn';
                }
                update match;
            }
        }
        PageReference p = new PageReference('/apex/apc_hf_app_personal_info?id=' + applicantInfo.id);
        p.setRedirect(true);
        return p;
    }
    
    public pageReference HFRenewtoExtension()
    { 
        list<Applicant_Info__c> hflistApprovedApp = [SELECT Name, Position__c, Engagement__c, account__c, account__r.Name FROM Applicant_Info__c WHERE Account__c =: applicantInfo.Account__c AND Application_Stage__c= 'Accepted' ORDER BY CreatedDate DESC];
        if(hflistApprovedApp.size()>0)
        {
            if (hflistApprovedApp[0].Position__c != NULL)
            {
                list<Match__c> match = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Position_Name__c =: hflistApprovedApp[0].Position__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];
                            if(match!=null && match.size()>0 && match[0].End_Date__c != null && match[0].Status__c == 'Confirmed')
                            {
                                list<Applicant_Info__c> SelectAPapp = [SELECT Years_in_Home__c, Under_2_Total_Hours__c, Writing_Skills__c, Weight__c, Visa_Type__c, Visa_Category__c, Type__c, Title__c, TimeZoneSidKey__c, Terms_Accepted__c, Teaching_Method__c, TE_Known_for_Months__c, TE_Known_For_Years__c, SystemModstamp, Sys_Admin_Tag__c, Submitted__c, Submitted_Date__c, Study_Weeks__c, Study_Time__c, Street__c, State__c, Standard_Delivery__c, Special_Needs_Food__c, Special_Ed__c, Special_Ed_Description__c, Special_Diet__c, Special_Diet_Indicated__c, Special_Diet_Expectation_Description__c, Special_Diet_Description__c, Speaking_Skills__c, Smoking_Location__c, Smoker_in_Family__c, Smoker_Student__c, Skip_or_Repeat__c, Skip_or_Repeat_Description__c, Single_No_Children_Indicated__c, Shared_Bedroom__c, Shared_Bathroom__c, Service_Level__c, Second_Language_Level__c, School_Transportation__c, School_Transportation_Description__c, School_Recruiting_Indicated__c, School_Recruiting_Description__c, School_Officials_Title__c, School_Officials_Name__c,
                                    School_Name__c, School_Name_SOR__c, School_Employee__c, SOR_Received_Date__c, Reviewed_Date__c, Resume__c, Residence_Club__c, Religious_Sharing_Indicated__c, Religious_Restriction_Indicated__c, Religious_Activity_on_Program__c, Religious_Activity_Home__c, Religion__c, Reference_Count__c, RecordTypeId, Recommended_Grade__c, Reading_Comprehension__c, RB_Last_Name__c, RB_First_Name__c, Questions__c, Projects_of_Interest__c, Program_Year__c, Program_Start__c, Program_Start_Opinion__c, Program_Selector__c,
                                    Program_Duration__c, Profile_Summary__c, Private_High_School_Tuition__c, Private_High_School_Indicated__c, Private_Bedroom__c, Private_Bathroom__c, Prior_Visa_Start_Date__c, Prior_Visa_End_Date__c, Prior_Hosting_Agency__c, Prior_Host_Experience__c, Prior_Host_Experience_DEPR__c, Prior_Host_Description__c, Prior_Exchange_Visa__c, Prior_Exchange_Experience__c, Primary_Language__c, Primary_Activity__c, Previous_Address_Complete__c, PreUniversity_Years_at_Start__c, PreUniversity_Years_Required__c, Postal_Code__c,
                                    Position_Types__c, Position_Types_Other__c, Points_of_Interest__c, Pluto_Id__c, Placement_Pending__c, PhotoId__c, Pets_in_House__c, Pets__c, Pets_Description__c, Pet_Types__c, Pet_Count__c, Personality_Structure__c, Personality_Opinionatedness__c, Personality_Maturity__c, Personality_Independence__c, Personality_Funniness__c, Personality_Expressiveness__c, Personality_Energy_Level__c, Pax__c, Pax_Count__c, Passport_Number__c, Passport_Country__c, Partner_Name__c, Partner_Intrax_Id__c, Parent_Marital_Status__c,
                                    PR_Traditional_Family_Stmt__c, PR_Interview_Date__c, PR_English_Interview_Stmt__c, OwnerId, Own_insurance__c, Overall_Progress__c, Other_Languages__c, Opportunity_Name__c, Nemo_Update_Request_At__c, Nemo_Id__c, Nearest_City__c, Nationality_Preferences__c, Name, Meal_Self_Sufficient__c, Major__c, Low_Grade_Count__c, Location_of_Interest__c, Lives_With__c, Lives_With_Other__c, Lived_Independently__c, Lived_Independently_Description__c, Live_With_Smoker__c, Live_With_Pets__c, Live_With_Pets_Description__c, Legal_Guardian__c,
                                    Lead__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, Languages_Spoken__c, Language_spoken_years_3__c, Language_spoken_years_2__c, Language_spoken_years_1__c, Language_spoken_3__c, Language_spoken_2__c, Language_spoken_1__c, Language_3__c, Language_3_Proficiency__c, Language_2__c, Language_2_Proficiency__c, Language_1__c, Language_1_Proficiency__c, IsDeleted, Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Intrax_Insurance__c, Intrax_Homestay_Accommodations__c, Intrax_Center__c, Intrax_Accommodations__c,
                                    International_Travel__c, International_Travel_Description__c, Interests__c, Interests_Top__c, Incomplete_Missing_Documents__c, Incomplete_Documents_Notes__c, Id, How_Long_Tought__c, How_Long_Study_English__c, How_Heard__c, Household_Income_Range__c, Host_Special_Diet__c, Homestay__c, Home_Visit_Checklist__c, Home_Type__c, Home_Street_2__c, Home_Street_1__c, Home_State__c, Home_Responsibilities__c, Home_Province__c, Home_Postal_Code__c, Home_Phone__c, Home_Country__c, Home_City__c, Height__c, Health_Needs_Indicated__c,
                                    Health_Needs_Description__c, Graduation_Year__c, Graduation_Expected_by_School__c, Graduation_Date__c, Graduated__c, Government_Assistence_Indicated__c, General_Summary__c, Gender_Preference__c, GPA__c, GPA_Self_Reported__c, Functional_Areas__c, Functional_Areas_Other__c, Flight_Number__c, Flight_Arrival_Time__c, Flight_Arrival_Date__c, Field_Work_Experience__c, Fax__c, Family_Members_Complete__c, Family_Member_Count__c, Family_Activities__c, Extracurricular_Transportation__c, Express_Delivery__c, Exchange_Agency_Employment__c,
                                    Exchange_Agency_Employer_Name__c, Entity_Id__c, English_Test_Type__c, English_Test_Score__c, English_Teacher_Title__c, English_Teach_Name__c, English_Summary__c, English_Study_Years__c, English_Level__c, English_Ability__c, Engagement_Start__c, Engagement_End__c, Employer_Name__c, Emergency_Contact_Complete__c, Email__c, Education_Grade__c, ETR_Received_Date__c, ESSN__c, Double_Placement_Indicated__c, Distance_to_School__c, Disabilities__c, Disabilities_Description__c, Deposit_Fee_Accepted__c, Date_of_Birth__c, Daily_Meal_Commitment__c,
                                    Curfew_Weekends__c, Curfew_Weekdays__c, Curfew_Indicated__c, Criminal_Investigation_Indicated__c, Criminal_Investigation_Description__c, Criminal_Convictions_Indicated__c, Criminal_Convictions_Description__c, CreatedDate, CreatedById, Country_of_Interest__c, Country_of_Birth__c, Country__c, Coordinator__c, ConnectionSentId, ConnectionReceivedId, Community_Website__c, Community_Type__c, Community_Population__c, Community_Description__c, Classroom_Cooperation__c, City__c, Citizenship__c, Children_Enrolled__c, Check_out_Date__c, Check_in_Date__c,
                                    Center_Disclosure_Accepted__c, Carrier__c, Carrier_Number__c, Business_in_Home__c, Business_in_Home_Description__c, Best_Call_Time_c__c, Best_Call_Time__c, Behavioral_Problems__c, Behavioral_Problems_Description__c, Bedrooms__c, Bedroom_Type__c, Bedroom_Shared_With__c, Bedroom_Shared_Indicated__c, Bathrooms__c, Bathroom_Type__c, BGC_Required_Count_AYU__c, BGC_Passed_Count_AYU__c, BGC_D_Remaining__c, Attendance_Problems__c, Attendance_Problems_Description__c, Arriving_Time__c, Arriving_Date__c, Arrival_Time__c, Application_Stage__c, Application_Level__c,
                                    Applicant_Info_Count__c, Any_housing_that_fits_my_program_dates__c, Any_Special_Food_Requirement__c, Allergies_from_Partner__c, Allergies_from_Applicant__c, Allergies_Other_desc__c, Allergies_Other_Partner__c, Allergies_Indicated__c, Airport__c, Airport_Transfer_Departure__c, Airport_Transfer_Arrival__c, Account__c, Accommodation_Price_Range__c, Accommodation_Preference__c, Accepted_Date__c, Academic_Years_Completed__c, RecordType.Name, PageStatus_Complete__c, PageStatus_Started__c, Countries_of_Interest__c, Driving_Preference_indicated__c,
                                    Special_Diet_Expectations__c, Portal_Contact_Id__c, Account__r.FirstName, Account__r.LastName, Lead__r.IsConverted, CreatedBy__c ,US_Passport_Indicated__c,Swimming_Level__c,Swimming_Indicated__c, Swimming_Comfort_Children__c,Single_Mother_Indicated__c,Single_Father_Indicated__c,Same_Sex_Couple_Indicated__c,Preferred_Arrival_Date__c,Pets_Allergy_Indicated__c,Pets_Allergy_Description__c,Pet_Allergy_Types__c,Passport_Indicated__c,Aupair_Preferences__c,Away_Count__c,Childcare_Experience_Indicated__c,Children_Comfortable_Ages__c,Children_Special_Needs_Care__c,Children_Special_Needs_Description__c, Children_Special_Needs_Indicated__c,Children_Special_Needs_Skills__c,Drivers_Licence_Acquired__c,Drivers_Licence_Expires__c,Drivers_Licence_Indicated__c,Driving_Comfort_Children__c,
                                    Driving_Experience__c,Driving_Frequency__c,Driving_Snow_Experience__c,Driving_Transmission__c,Family_Description__c,Allergy_Description__c, Interest_Fine_Arts__c,Interests_Hobbies__c,Interests_Hobbies_Description__c,Interests_Leisure__c,Interest_Sports__c,Lived_Away_Indicated__c,Month_Arrival__c,Private_Bedroom_Indicated__c,Application_Type__c,AuPairsResponsibilities__c,Casper_Id__c,
                                    Position__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                                    
                               if (SelectAPapp != NULL && SelectAPapp.size()>0)
                               {
                                    applicantInfo.Name = applicantInfo.Account__r.FirstName + ' ' + applicantInfo.Account__r.LastName+ '-Extension-'+System.Today().year();
                                    applicantInfo.Application_Type__c= 'Extension';
                                    applicantInfo.PageStatus_Complete__c = '';
                                    update applicantInfo;
                                    
                                    string HFCreatedByID = applicantInfo.CreatedBy__c;
                                    Applicant_Info__c PTAppInfo = SelectAPapp[0];
                                    
                                    list<Applicant_Info__c> ListWorkingApps = new list<Applicant_Info__c>();
                                    
                                    if (SelectAPapp[0].Account__c != NULL)
                                    {
                                        ListWorkingApps = [SELECT Years_in_Home__c, Under_2_Total_Hours__c, Writing_Skills__c, Weight__c, Visa_Type__c, Visa_Category__c, Type__c, Title__c, TimeZoneSidKey__c, Terms_Accepted__c, Teaching_Method__c, TE_Known_for_Months__c, TE_Known_For_Years__c, SystemModstamp, Sys_Admin_Tag__c, Submitted__c, Submitted_Date__c, Study_Weeks__c, Study_Time__c, Street__c, State__c, Standard_Delivery__c, Special_Needs_Food__c, Special_Ed__c, Special_Ed_Description__c, Special_Diet__c, Special_Diet_Indicated__c, Special_Diet_Expectation_Description__c, Special_Diet_Description__c, Speaking_Skills__c, Smoking_Location__c, Smoker_in_Family__c, Smoker_Student__c, Skip_or_Repeat__c, Skip_or_Repeat_Description__c, Single_No_Children_Indicated__c, Shared_Bedroom__c, Shared_Bathroom__c, Service_Level__c, Second_Language_Level__c, School_Transportation__c, School_Transportation_Description__c, School_Recruiting_Indicated__c, School_Recruiting_Description__c, School_Officials_Title__c, School_Officials_Name__c,
                                        School_Name__c, School_Name_SOR__c, School_Employee__c, SOR_Received_Date__c, Reviewed_Date__c, Resume__c, Residence_Club__c, Religious_Sharing_Indicated__c, Religious_Restriction_Indicated__c, Religious_Activity_on_Program__c, Religious_Activity_Home__c, Religion__c, Reference_Count__c, RecordTypeId, Recommended_Grade__c, Reading_Comprehension__c, RB_Last_Name__c, RB_First_Name__c, Questions__c, Projects_of_Interest__c, Program_Year__c, Program_Start__c, Program_Start_Opinion__c, Program_Selector__c,
                                        Program_Duration__c, Profile_Summary__c, Private_High_School_Tuition__c, Private_High_School_Indicated__c, Private_Bedroom__c, Private_Bathroom__c, Prior_Visa_Start_Date__c, Prior_Visa_End_Date__c, Prior_Hosting_Agency__c, Prior_Host_Experience__c, Prior_Host_Experience_DEPR__c, Prior_Host_Description__c, Prior_Exchange_Visa__c, Prior_Exchange_Experience__c, Primary_Language__c, Primary_Activity__c, Previous_Address_Complete__c, PreUniversity_Years_at_Start__c, PreUniversity_Years_Required__c, Postal_Code__c,
                                        Position_Types__c, Position_Types_Other__c, Points_of_Interest__c, Pluto_Id__c, Placement_Pending__c, PhotoId__c, Pets_in_House__c, Pets__c, Pets_Description__c, Pet_Types__c, Pet_Count__c, Personality_Structure__c, Personality_Opinionatedness__c, Personality_Maturity__c, Personality_Independence__c, Personality_Funniness__c, Personality_Expressiveness__c, Personality_Energy_Level__c, Pax__c, Pax_Count__c, Passport_Number__c, Passport_Country__c, Partner_Name__c, Partner_Intrax_Id__c, Parent_Marital_Status__c,
                                        PR_Traditional_Family_Stmt__c, PR_Interview_Date__c, PR_English_Interview_Stmt__c, OwnerId, Own_insurance__c, Overall_Progress__c, Other_Languages__c, Opportunity_Name__c, Nemo_Update_Request_At__c, Nemo_Id__c, Nearest_City__c, Nationality_Preferences__c, Name, Meal_Self_Sufficient__c, Major__c, Low_Grade_Count__c, Location_of_Interest__c, Lives_With__c, Lives_With_Other__c, Lived_Independently__c, Lived_Independently_Description__c, Live_With_Smoker__c, Live_With_Pets__c, Live_With_Pets_Description__c, Legal_Guardian__c,
                                        Lead__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, Languages_Spoken__c, Language_spoken_years_3__c, Language_spoken_years_2__c, Language_spoken_years_1__c, Language_spoken_3__c, Language_spoken_2__c, Language_spoken_1__c, Language_3__c, Language_3_Proficiency__c, Language_2__c, Language_2_Proficiency__c, Language_1__c, Language_1_Proficiency__c, IsDeleted, Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Intrax_Insurance__c, Intrax_Homestay_Accommodations__c, Intrax_Center__c, Intrax_Accommodations__c,
                                        International_Travel__c, International_Travel_Description__c, Interests__c, Interests_Top__c, Incomplete_Missing_Documents__c, Incomplete_Documents_Notes__c, Id, How_Long_Tought__c, How_Long_Study_English__c, How_Heard__c, Household_Income_Range__c, Host_Special_Diet__c, Homestay__c, Home_Visit_Checklist__c, Home_Type__c, Home_Street_2__c, Home_Street_1__c, Home_State__c, Home_Responsibilities__c, Home_Province__c, Home_Postal_Code__c, Home_Phone__c, Home_Country__c, Home_City__c, Height__c, Health_Needs_Indicated__c,
                                        Health_Needs_Description__c, Graduation_Year__c, Graduation_Expected_by_School__c, Graduation_Date__c, Graduated__c, Government_Assistence_Indicated__c, General_Summary__c, Gender_Preference__c, GPA__c, GPA_Self_Reported__c, Functional_Areas__c, Functional_Areas_Other__c, Flight_Number__c, Flight_Arrival_Time__c, Flight_Arrival_Date__c, Field_Work_Experience__c, Fax__c, Family_Members_Complete__c, Family_Member_Count__c, Family_Activities__c, Extracurricular_Transportation__c, Express_Delivery__c, Exchange_Agency_Employment__c,
                                        Exchange_Agency_Employer_Name__c, Entity_Id__c, English_Test_Type__c, English_Test_Score__c, English_Teacher_Title__c, English_Teach_Name__c, English_Summary__c, English_Study_Years__c, English_Level__c, English_Ability__c, Engagement_Start__c, Engagement_End__c, Employer_Name__c, Emergency_Contact_Complete__c, Email__c, Education_Grade__c, ETR_Received_Date__c, ESSN__c, Double_Placement_Indicated__c, Distance_to_School__c, Disabilities__c, Disabilities_Description__c, Deposit_Fee_Accepted__c, Date_of_Birth__c, Daily_Meal_Commitment__c,
                                        Curfew_Weekends__c, Curfew_Weekdays__c, Curfew_Indicated__c, Criminal_Investigation_Indicated__c, Criminal_Investigation_Description__c, Criminal_Convictions_Indicated__c, Criminal_Convictions_Description__c, CreatedDate, CreatedById, Country_of_Interest__c, Country_of_Birth__c, Country__c, Coordinator__c, ConnectionSentId, ConnectionReceivedId, Community_Website__c, Community_Type__c, Community_Population__c, Community_Description__c, Classroom_Cooperation__c, City__c, Citizenship__c, Children_Enrolled__c, Check_out_Date__c, Check_in_Date__c,
                                        Center_Disclosure_Accepted__c, Carrier__c, Carrier_Number__c, Business_in_Home__c, Business_in_Home_Description__c, Best_Call_Time_c__c, Best_Call_Time__c, Behavioral_Problems__c, Behavioral_Problems_Description__c, Bedrooms__c, Bedroom_Type__c, Bedroom_Shared_With__c, Bedroom_Shared_Indicated__c, Bathrooms__c, Bathroom_Type__c, BGC_Required_Count_AYU__c, BGC_Passed_Count_AYU__c, BGC_D_Remaining__c, Attendance_Problems__c, Attendance_Problems_Description__c, Arriving_Time__c, Arriving_Date__c, Arrival_Time__c, Application_Stage__c, Application_Level__c,
                                        Applicant_Info_Count__c, Any_housing_that_fits_my_program_dates__c, Any_Special_Food_Requirement__c, Allergies_from_Partner__c, Allergies_from_Applicant__c, Allergies_Other_desc__c, Allergies_Other_Partner__c, Allergies_Indicated__c, Airport__c, Airport_Transfer_Departure__c, Airport_Transfer_Arrival__c, Account__c, Accommodation_Price_Range__c, Accommodation_Preference__c, Accepted_Date__c, Academic_Years_Completed__c, RecordType.Name, PageStatus_Complete__c, PageStatus_Started__c, Countries_of_Interest__c, Driving_Preference_indicated__c,
                                        Special_Diet_Expectations__c, Portal_Contact_Id__c, Account__r.FirstName, Account__r.LastName, Lead__r.IsConverted, CreatedBy__c ,US_Passport_Indicated__c,Swimming_Level__c,Swimming_Indicated__c, Swimming_Comfort_Children__c,Single_Mother_Indicated__c,Single_Father_Indicated__c,Same_Sex_Couple_Indicated__c,Preferred_Arrival_Date__c,Pets_Allergy_Indicated__c,Pets_Allergy_Description__c,Pet_Allergy_Types__c,Passport_Indicated__c,Aupair_Preferences__c,Away_Count__c,Childcare_Experience_Indicated__c,Children_Comfortable_Ages__c,Children_Special_Needs_Care__c,Children_Special_Needs_Description__c, Children_Special_Needs_Indicated__c,Children_Special_Needs_Skills__c,Drivers_Licence_Acquired__c,Drivers_Licence_Expires__c,Drivers_Licence_Indicated__c,Driving_Comfort_Children__c,
                                        Driving_Experience__c,Driving_Frequency__c,Driving_Snow_Experience__c,Driving_Transmission__c,Family_Description__c,Allergy_Description__c, Interest_Fine_Arts__c,Interests_Hobbies__c,Interests_Hobbies_Description__c,Interests_Leisure__c,Interest_Sports__c,Lived_Away_Indicated__c,Month_Arrival__c,Private_Bedroom_Indicated__c,Application_Type__c,AuPairsResponsibilities__c,Casper_Id__c,
                                        Position__c, Engagement__c FROM Applicant_Info__c WHERE Account__c =: SelectAPapp[0].Account__c AND Application_Stage__c = 'Working' ORDER BY CreatedDate DESC];
                                    }
                                    
                                    if (ListWorkingApps.size()>0)
                                    {
                                        Applicant_Info__c WorkingApps = ListWorkingApps[0];
                                        
                                        if(WorkingApps.Opportunity_Name__c == NULL)
                                        {
                                            string oppStr = OppCloneApc(PTAppInfo);
                                            if(oppStr != NULL)
                                            {
                                                WorkingApps.Opportunity_Name__c=oppStr;
                                                list<Engagement__c> englist = [SELECT Id, Name FROM Engagement__c WHERE Opportunity_Id__c =: oppStr];
                                                if(englist != NULL && englist.size()>0)
                                                {
                                                    delete englist;
                                                }
                                            }
                                        }
                                        if(WorkingApps.Engagement__c == NULL)
                                        {
                                            string enggStr = EnggCloneapc(PTAppInfo,WorkingApps.Opportunity_Name__c);
                                            if(enggStr != NULL)
                                            {
                                                WorkingApps.Engagement__c = enggStr;
                                                if (enggStr != NULL && HFCreatedByID != NULL)
                                                {
                                                    Sharing_Security_Controller.shareEngRecord(enggStr, HFCreatedByID);
                                                }
                                            }
                                        }
                                        WorkingApps.Name = WorkingApps.Account__r.FirstName + ' ' + WorkingApps.Account__r.LastName+ '-Extension-'+System.Today().year();
                                        WorkingApps.Application_Type__c= 'Extension';
                                        WorkingApps.PageStatus_Complete__c = '';
                                        update WorkingApps;
                                        
                                        if (WorkingApps.Engagement__c!= NULL && applicantInfo.Position__c != NULL)
                                        {
                                            creatematch(WorkingApps.Engagement__c,applicantInfo.Position__c);
                                        }
                                    }
                                    else
                                    {
                                        string oppStr = OppCloneApc(PTAppInfo);
                                        if(oppStr != NULL)
                                        {
                                            list<Engagement__c> englist = [SELECT Id, Name FROM Engagement__c WHERE Opportunity_Id__c =: oppStr];
                                            if(englist != NULL && englist.size()>0)
                                            {
                                                delete englist;
                                            }
                                        }
                                        
                                        string enggStr = EnggCloneapc(PTAppInfo,oppStr);
                                        APExtensionmethods(PTAppInfo.id,applicantInfo.id,enggStr,oppStr,HFCreatedByID);
                                        if (enggStr!= NULL && applicantInfo.Position__c != NULL)
                                        {
                                            creatematch(enggStr,applicantInfo.Position__c);
                                        }
                                        
                                        if (enggStr != NULL && HFCreatedByID != NULL)
                                        {
                                            Sharing_Security_Controller.shareEngRecord(enggStr, HFCreatedByID);
                                        }
                                    }
                                    
                               }
                               
                            }
            }
        }
        PageReference p = new PageReference('/apex/apc_hf_app_extension_pref?id=' + applicantInfo.id);
        p.setRedirect(true);
        return p;
    }*/
    
            
    public pageReference CloneAppApc()
    { 
            string URLAppID = '';
            // Only the user that created the app must be able to clone it
            PageReference p;
            
            if(applicantInfo.CreatedBy__c == userInfo.getUserId())
            {
                if (applicantInfo.type__c=='Host Family')
                {
                    system.debug('***AppType****'+ApexPages.currentPage().getParameters().get('AppType'));
                    if(ApexPages.currentPage().getParameters().get('AppType') == 'Renewal' || ApexPages.currentPage().getParameters().get('AppType') == 'Rematch')
                    {
                        string EnggStr = NULL;
                        applicantCloneApc(applicantInfo);
                        personPaCloneApc(applicantInfo, applicantInfoClone);
                        essayCloneapc(applicantInfo, applicantInfoClone,EnggStr);
                        experienceClone(applicantInfo, applicantInfoClone,EnggStr);
                        EducationCloneapc(applicantInfo, applicantInfoClone,EnggStr);
                        IPUCloneapc(applicantInfo, applicantInfoClone);
                        RefCloneapc(applicantInfo, applicantInfoClone);
                        
                        string PosStr = PosCloneapc(applicantInfo, applicantInfoClone);
                        if(PosStr != NULL)
                        {
                            applicantInfoClone.Position__c = PosStr;
                            update applicantInfoClone;
                        }
                        
                        URLAppID = applicantInfoClone.id;
                        
                        if(applicantInfo.Position__c != NULL)
                        {
                            list<Match__c> APmatch = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Position_Name__r.Host_Company_Id__c, Status__c from Match__c WHERE Position_Name__c =: applicantInfo.Position__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];
                            if(APmatch!=null && APmatch.size()>0 && APmatch[0].End_Date__c != null && APmatch[0].Status__c == 'Confirmed')
                            {
                                list<Applicant_Info__c> SelectAuPairapp = [SELECT CreatedBy__c FROM Applicant_Info__c WHERE Engagement__c =: APmatch[0].Engagement__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                                if (SelectAuPairapp != NULL && SelectAuPairapp.size()>0 && SelectAuPairapp[0].CreatedBy__c != NULL)
                                {
                                    Sharing_Security_Controller.shareApplicantRecord(applicantInfoClone.id, SelectAuPairapp[0].CreatedBy__c);
                                }
                            }
                        }
                    }
                    else if (ApexPages.currentPage().getParameters().get('AppType') == 'Extension')
                    {
                        string EnggIDStr = NULL;
                        applicantCloneApc(applicantInfo);
                        personPaCloneApc(applicantInfo, applicantInfoClone);
                        essayCloneapc(applicantInfo, applicantInfoClone,EnggIDStr);
                        experienceClone(applicantInfo, applicantInfoClone,EnggIDStr);
                        EducationCloneapc(applicantInfo, applicantInfoClone,EnggIDStr);
                        IPUCloneapc(applicantInfo, applicantInfoClone);
                        RefCloneapc(applicantInfo, applicantInfoClone);
                        
                        
                        URLAppID = applicantInfoClone.id;
                        
                        if(applicantInfo.Position__c != NULL)
                        {
                            list<Match__c> match = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Position_Name__c =: applicantInfo.Position__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];
                            if(match!=null && match.size()>0 && match[0].End_Date__c != null && match[0].Status__c == 'Confirmed')
                            {
                                list<Applicant_Info__c> SelectAPapp = [SELECT Years_in_Home__c, Under_2_Total_Hours__c, Writing_Skills__c, Weight__c, Visa_Type__c, Visa_Category__c, Type__c, Title__c, TimeZoneSidKey__c, Terms_Accepted__c, Teaching_Method__c, TE_Known_for_Months__c, TE_Known_For_Years__c, SystemModstamp, Sys_Admin_Tag__c, Submitted__c, Submitted_Date__c, Study_Weeks__c, Study_Time__c, Street__c, State__c, Standard_Delivery__c, Special_Needs_Food__c, Special_Ed__c, Special_Ed_Description__c, Special_Diet__c, Special_Diet_Indicated__c, Special_Diet_Expectation_Description__c, Special_Diet_Description__c, Speaking_Skills__c, Smoking_Location__c, Smoker_in_Family__c, Smoker_Student__c, Skip_or_Repeat__c, Skip_or_Repeat_Description__c, Single_No_Children_Indicated__c, Shared_Bedroom__c, Shared_Bathroom__c, Service_Level__c, Second_Language_Level__c, School_Transportation__c, School_Transportation_Description__c, School_Recruiting_Indicated__c, School_Recruiting_Description__c, School_Officials_Title__c, School_Officials_Name__c,
                                    School_Name__c, School_Name_SOR__c, School_Employee__c, SOR_Received_Date__c, Reviewed_Date__c, Resume__c, Residence_Club__c, Religious_Sharing_Indicated__c, Religious_Restriction_Indicated__c, Religious_Activity_on_Program__c, Religious_Activity_Home__c, Religion__c, Reference_Count__c, RecordTypeId, Recommended_Grade__c, Reading_Comprehension__c, RB_Last_Name__c, RB_First_Name__c, Questions__c, Projects_of_Interest__c, Program_Year__c, Program_Start__c, Program_Start_Opinion__c, Program_Selector__c,
                                    Program_Duration__c, Profile_Summary__c, Private_High_School_Tuition__c, Private_High_School_Indicated__c, Private_Bedroom__c, Private_Bathroom__c, Prior_Visa_Start_Date__c, Prior_Visa_End_Date__c, Prior_Hosting_Agency__c, Prior_Host_Experience__c, Prior_Host_Experience_DEPR__c, Prior_Host_Description__c, Prior_Exchange_Visa__c, Prior_Exchange_Experience__c, Primary_Language__c, Primary_Activity__c, Previous_Address_Complete__c, PreUniversity_Years_at_Start__c, PreUniversity_Years_Required__c, Postal_Code__c,
                                    Position_Types__c, Position_Types_Other__c, Points_of_Interest__c, Pluto_Id__c, Placement_Pending__c, PhotoId__c, Pets_in_House__c, Pets__c, Pets_Description__c, Pet_Types__c, Pet_Count__c, Personality_Structure__c, Personality_Opinionatedness__c, Personality_Maturity__c, Personality_Independence__c, Personality_Funniness__c, Personality_Expressiveness__c, Personality_Energy_Level__c, Pax__c, Pax_Count__c, Passport_Number__c, Passport_Country__c, Partner_Name__c, Partner_Intrax_Id__c, Parent_Marital_Status__c,
                                    PR_Traditional_Family_Stmt__c, PR_Interview_Date__c, PR_English_Interview_Stmt__c, OwnerId, Own_insurance__c, Overall_Progress__c, Other_Languages__c, Opportunity_Name__c, Nemo_Update_Request_At__c, Nemo_Id__c, Nearest_City__c, Nationality_Preferences__c, Name, Meal_Self_Sufficient__c, Major__c, Low_Grade_Count__c, Location_of_Interest__c, Lives_With__c, Lives_With_Other__c, Lived_Independently__c, Lived_Independently_Description__c, Live_With_Smoker__c, Live_With_Pets__c, Live_With_Pets_Description__c, Legal_Guardian__c,
                                    Lead__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, Languages_Spoken__c, Language_spoken_years_3__c, Language_spoken_years_2__c, Language_spoken_years_1__c, Language_spoken_3__c, Language_spoken_2__c, Language_spoken_1__c, Language_3__c, Language_3_Proficiency__c, Language_2__c, Language_2_Proficiency__c, Language_1__c, Language_1_Proficiency__c, IsDeleted, Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Intrax_Insurance__c, Intrax_Homestay_Accommodations__c, Intrax_Center__c, Intrax_Accommodations__c,
                                    International_Travel__c, International_Travel_Description__c, Interests__c, Interests_Top__c, Incomplete_Missing_Documents__c, Incomplete_Documents_Notes__c, Id, How_Long_Tought__c, How_Long_Study_English__c, How_Heard__c, Household_Income_Range__c, Host_Special_Diet__c, Homestay__c, Home_Visit_Checklist__c, Home_Type__c, Home_Street_2__c, Home_Street_1__c, Home_State__c, Home_Responsibilities__c, Home_Province__c, Home_Postal_Code__c, Home_Phone__c, Home_Country__c, Home_City__c, Height__c, Health_Needs_Indicated__c,
                                    Health_Needs_Description__c, Graduation_Year__c, Graduation_Expected_by_School__c, Graduation_Date__c, Graduated__c, Government_Assistence_Indicated__c, General_Summary__c, Gender_Preference__c, GPA__c, GPA_Self_Reported__c, Functional_Areas__c, Functional_Areas_Other__c, Flight_Number__c, Flight_Arrival_Time__c, Flight_Arrival_Date__c, Field_Work_Experience__c, Fax__c, Family_Members_Complete__c, Family_Member_Count__c, Family_Activities__c, Extracurricular_Transportation__c, Express_Delivery__c, Exchange_Agency_Employment__c,
                                    Exchange_Agency_Employer_Name__c, Entity_Id__c, English_Test_Type__c, English_Test_Score__c, English_Teacher_Title__c, English_Teach_Name__c, English_Summary__c, English_Study_Years__c, English_Level__c, English_Ability__c, Engagement_Start__c, Engagement_End__c, Employer_Name__c, Emergency_Contact_Complete__c, Email__c, Education_Grade__c, ETR_Received_Date__c, ESSN__c, Double_Placement_Indicated__c, Distance_to_School__c, Disabilities__c, Disabilities_Description__c, Deposit_Fee_Accepted__c, Date_of_Birth__c, Daily_Meal_Commitment__c,
                                    Curfew_Weekends__c, Curfew_Weekdays__c, Curfew_Indicated__c, Criminal_Investigation_Indicated__c, Criminal_Investigation_Description__c, Criminal_Convictions_Indicated__c, Criminal_Convictions_Description__c, CreatedDate, CreatedById, Country_of_Interest__c, Country_of_Birth__c, Country__c, Coordinator__c, ConnectionSentId, ConnectionReceivedId, Community_Website__c, Community_Type__c, Community_Population__c, Community_Description__c, Classroom_Cooperation__c, City__c, Citizenship__c, Children_Enrolled__c, Check_out_Date__c, Check_in_Date__c,
                                    Center_Disclosure_Accepted__c, Carrier__c, Carrier_Number__c, Business_in_Home__c, Business_in_Home_Description__c, Best_Call_Time_c__c, Best_Call_Time__c, Behavioral_Problems__c, Behavioral_Problems_Description__c, Bedrooms__c, Bedroom_Type__c, Bedroom_Shared_With__c, Bedroom_Shared_Indicated__c, Bathrooms__c, Bathroom_Type__c, BGC_Required_Count_AYU__c, BGC_Passed_Count_AYU__c, BGC_D_Remaining__c, Attendance_Problems__c, Attendance_Problems_Description__c, Arriving_Time__c, Arriving_Date__c, Arrival_Time__c, Application_Stage__c, Application_Level__c,
                                    Applicant_Info_Count__c, Any_housing_that_fits_my_program_dates__c, Any_Special_Food_Requirement__c, Allergies_from_Partner__c, Allergies_from_Applicant__c, Allergies_Other_desc__c, Allergies_Other_Partner__c, Allergies_Indicated__c, Airport__c, Airport_Transfer_Departure__c, Airport_Transfer_Arrival__c, Account__c, Accommodation_Price_Range__c, Accommodation_Preference__c, Accepted_Date__c, Academic_Years_Completed__c, RecordType.Name, PageStatus_Complete__c, PageStatus_Started__c, Countries_of_Interest__c, Driving_Preference_indicated__c,
                                    Special_Diet_Expectations__c, Portal_Contact_Id__c, Account__r.FirstName, Account__r.LastName, Lead__r.IsConverted, CreatedBy__c ,US_Passport_Indicated__c,Swimming_Level__c,Swimming_Indicated__c, Swimming_Comfort_Children__c,Single_Mother_Indicated__c,Single_Father_Indicated__c,Same_Sex_Couple_Indicated__c,Preferred_Arrival_Date__c,Pets_Allergy_Indicated__c,Pets_Allergy_Description__c,Pet_Allergy_Types__c,Passport_Indicated__c,Aupair_Preferences__c,Away_Count__c,Childcare_Experience_Indicated__c,Children_Comfortable_Ages__c,Children_Special_Needs_Care__c,Children_Special_Needs_Description__c, Children_Special_Needs_Indicated__c,Children_Special_Needs_Skills__c,Drivers_Licence_Acquired__c,Drivers_Licence_Expires__c,Drivers_Licence_Indicated__c,Driving_Comfort_Children__c,
                                    Driving_Experience__c,Driving_Frequency__c,Driving_Snow_Experience__c,Driving_Transmission__c,Family_Description__c,Allergy_Description__c, Interest_Fine_Arts__c,Interests_Hobbies__c,Interests_Hobbies_Description__c,Interests_Leisure__c,Interest_Sports__c,Lived_Away_Indicated__c,Month_Arrival__c,Private_Bedroom_Indicated__c,Application_Type__c,AuPairsResponsibilities__c,Casper_Id__c,
                                    Position__c, Engagement__c,Engagement__r.Engagement_End__c FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                                    
                               if (SelectAPapp != NULL && SelectAPapp.size()>0)
                               {
                                    string PosStr = PosCloneapc(applicantInfo, applicantInfoClone);
                                   
                                   // New Code Position to Share Clone Position to PT User
                                   if(PosStr != NULL && SelectAPapp[0].CreatedBy__c != NULL){
                                       Id PosStrId=Id.valueOf(PosStr);
                                       Sharing_Security_Controller.shareMatRecord(PosStrId, SelectAPapp[0].CreatedBy__c);
                                   }
                                   
                                    string HFCreatedByID = applicantInfoClone.CreatedBy__c;
                                    if(PosStr != NULL)
                                    {
                                        applicantInfoClone.Position__c = PosStr;
                                        update applicantInfoClone;
                                    }
                                    Applicant_Info__c PTAppInfo = SelectAPapp[0];
                                    string oppStr = OppCloneApc(PTAppInfo);
                                    
                                    if(oppStr != NULL)
                                    {
                                        list<Engagement__c> englist = [SELECT Id, Name FROM Engagement__c WHERE Opportunity_Id__c =: oppStr];
                                        if(englist != NULL && englist.size()>0)
                                        {
                                            delete englist;
                                        }
                                    }
                                    
                                    string enggStr = EnggCloneapc(PTAppInfo,oppStr,'Extension'); 
                                    
                                    /*string enggStr = NULL;
                                    if(oppStr != NULL)
                                    {
                                        list<Engagement__c> englist = [SELECT Id, Name FROM Engagement__c WHERE Opportunity_Id__c =: oppStr ORDER BY CreatedDate DESC];
                                        if(englist != NULL && englist.size()>0)
                                        {
                                            //delete englist;
                                            enggStr = englist[0].id;
                                            updateEnggDetails(PTAppInfo.Engagement__c, englist[0].id);
                                        }
                                        else
                                        {
                                            enggStr = EnggCloneapc(PTAppInfo,oppStr); 
                                        }
                                    }
                                    else
                                    {
                                        enggStr = EnggCloneapc(PTAppInfo,oppStr); 
                                    }
                                    */
                                    
                                    APExtensionmethods(PTAppInfo.id,URLAppID,enggStr,oppStr,HFCreatedByID);
                                    if (enggStr!= NULL && PosStr != NULL)
                                    {
                                        creatematch(enggStr,PosStr);
                                    }
                                    
                                    if (enggStr != NULL && HFCreatedByID != NULL)
                                    {
                                        Sharing_Security_Controller.shareEngRecord(enggStr, HFCreatedByID);
                                    }
                                    
                                    
                               }
                            }
                        }
                        
                    }
                }
                else if (applicantInfo.type__c=='Participant')
                {
                    System.debug('Inside CloneAppApc, participant condition');
                    applicantCloneApc(applicantInfo);
                    
                    if(applicantInfoClone.Opportunity_Name__c != NULL && applicantInfo.Opportunity_Name__c != applicantInfoClone.Opportunity_Name__c)
                    {
                        list<Engagement__c> englist = [SELECT Id, Name FROM Engagement__c WHERE Opportunity_Id__c =: applicantInfoClone.Opportunity_Name__c];
                        if(englist != NULL && englist.size()>0)
                        {
                            delete englist;
                        }
                    }
                    string enggStr = EnggCloneapc(applicantInfo,applicantInfoClone.Opportunity_Name__c,'Renewal');
                    
                    
                    /*string enggStr = NULL;
                    if(applicantInfoClone.Opportunity_Name__c != NULL && applicantInfo.Opportunity_Name__c != applicantInfoClone.Opportunity_Name__c)
                    {
                        list<Engagement__c> englist = [SELECT Id, Name FROM Engagement__c WHERE Opportunity_Id__c =: applicantInfoClone.Opportunity_Name__c ORDER BY CreatedDate DESC];
                        if(englist != NULL && englist.size()>0)
                        {
                            enggStr = englist[0].id;
                            updateEnggDetails(applicantInfo.Engagement__c, englist[0].id);
                        }
                        else
                        {
                            enggStr = EnggCloneapc(applicantInfo,applicantInfoClone.Opportunity_Name__c);
                        }
                    }
                    else
                    {
                        enggStr = EnggCloneapc(applicantInfo,applicantInfoClone.Opportunity_Name__c);
                    }
                    */
                    
                    if(enggStr != NULL)
                    {
                        applicantInfoClone.Engagement__c = enggStr;
                        update applicantInfoClone;
                    }
                    personPaCloneApc(applicantInfo, applicantInfoClone);
                    essayCloneapc(applicantInfo, applicantInfoClone,enggStr);
                    experienceClone(applicantInfo, applicantInfoClone,enggStr);
                    EducationCloneapc(applicantInfo, applicantInfoClone,enggStr);
                    IPUCloneapc(applicantInfo, applicantInfoClone);
                    DISCCloneapc(applicantInfo, applicantInfoClone);
                    RefCloneapc(applicantInfo, applicantInfoClone);
                    URLAppID = applicantInfoClone.id;
                    
                    list<Match__c> HFmatch = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Position_Name__r.Host_Company_Id__c, Status__c from Match__c WHERE Engagement__c =: applicantInfo.Engagement__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];
                    if(HFmatch!=null && HFmatch.size()>0 && HFmatch[0].End_Date__c != null && HFmatch[0].Status__c == 'Confirmed')
                    {
                        list<Applicant_Info__c> SelectHFapp = [SELECT CreatedBy__c FROM Applicant_Info__c WHERE Position__c =: HFmatch[0].Position_Name__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                        if (SelectHFapp != NULL && SelectHFapp.size()>0 && SelectHFapp[0].CreatedBy__c != NULL)
                        {
                            Sharing_Security_Controller.shareApplicantRecord(applicantInfoClone.id, SelectHFapp[0].CreatedBy__c);
                        }
                    }
                }
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You don?t have permissions to clone this record');
                ApexPages.addMessage(myMsg);
                //return null;
            }
            
            if (applicantInfo.type__c=='Participant')
            {   
                p = new PageReference('/apex/apc_ap_extension_pref?id=' + URLAppID);
            }
            else if (applicantInfo.type__c=='Host Family')
            {
                 if(ApexPages.currentPage().getParameters().get('AppType') == 'Renewal' || ApexPages.currentPage().getParameters().get('AppType') == 'Rematch')
                {
            
                    p = new PageReference('/apex/apc_hf_app_personal_info?id=' + URLAppID);
                }
                else
                {
                    p = new PageReference('/apex/apc_hf_app_extension_pref?id=' + URLAppID);
                }
            }
            
            system.debug('debug::PageReference==='+p);
            
            if(ApexPages.currentPage().getParameters().get('vstate') != null){
            p.getParameters().put('vstate',ApexPages.currentPage().getParameters().get('vstate'));
            }
            
            p.setRedirect(true);
            return p;
    } 
    
    public string OppCloneApc(Applicant_Info__c appInfo)  
    {
        list<Opportunity> opp = [SELECT o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Docs_Sent__c, o.Visa_Docs_Received__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, 
                                    o.Validator__c, o.Type, o.Transportation_Note__c, o.Total_Participants__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.Sys_Payment_Instruction_Id__c, 
                                    o.Sys_Invoice_Language__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c,  o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Screening_Concern__c, 
                                    o.Screening_Concern_Comments__c, o.School_Id__c, o.Scholarship_incomplete_documents__c, o.Scholarship_Type__c, o.Scholarship_Status__c, o.Scholarship_Score__c, o.Scholarship_Documents_Notes__c, o.Round__c, 
                                    o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c,  o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, 
                                    o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, 
                                    o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Program_Trip_Indicated__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, 
                                    o.Pay_Notes__c, o.Pay_Advance__c,  o.Partner_Account__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PPP_Status__c, o.PAX__c, o.OwnerId, 
                                    o.ChildOppType__c, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, 
                                    o.Lead_Source_Original__c, o.LeadSource, o.Last_Contact_Attempt__c, o.Last_Applicant_Update__c, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Language_3__c, o.Language_3_Proficiency__c, 
                                    o.Language_2__c, o.Language_2_Proficiency__c, o.Language_1__c, o.Language_1_Proficiency__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.Invoice_No__c, o.Invoice_Language__c, o.Invoice_Date__c, o.Intrax_Region__c, 
                                    o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Program_Category__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interviewer_Territory__c, o.Interviewer_Phone__c, o.Interviewer_MailingStreet__c, 
                                    o.Interviewer_MailingPostalCode__c, o.Interviewer_MailingCountry__c, o.Interviewer_MailingCity__c, o.Interviewer_LastName__c, o.Interviewer_FirstName__c, o.Interviewer_Email__c, o.Interview_Requested__c, 
                                    o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c,  
                                    o.Incomplete_Documents_Notes__c, o.ISFDC_ID__c, o.How_Heard__c, o.How_Heard_Other__c, o.How_Heard_Detail__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, 
                                    o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, 
                                    o.FiscalQuarter, o.Fiscal, o.Field_Staff__c,  o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Enquiry_Channel__c, 
                                    o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c,  o.Direct_Placement__c, o.Description, o.Deadline__c, o.DFH_Status__c, o.Current_Visa__c,  
                                    o.Create_Order__c, o.Countries_of_Interest__c, o.Countries_of_Interest_Local__c, o.Countries_Excluded__c,  o.Coordinator__c, o.Compensation_Type__c, o.Commission__c, o.CloseDate,  
                                    o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_State__c, o.Billing_Currency__c, 
                                    o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Fee_Received__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, 
                                    o.Agreement_Status__c, o.Acquisition_Campaign__c, o.Account_Owner_Phone__c, o.Account_Owner_Last_Name__c, o.Account_Owner_Full_Name__c, o.Account_Owner_Email__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c 
                                    From Opportunity o
                                    WHERE o.id =: appInfo.Opportunity_Name__c]; 
                                        
            list<Opportunity> oppClone = opp.deepClone();
        	
        	if(appInfo.RecordType.Name=='AuPairCare PT')
            {
                if(oppClone!=null && oppClone.size()>0)
                    oppClone[0].ChildOppType__c = 'Extension';
                	oppClone[0].StageName = 'Prospecting';
            }
        
            insert oppClone;
            
            return oppClone[0].id;
    }
    
    public void applicantCloneApc(Applicant_Info__c appInfo)    
    {
        System.debug('Inside applicantCloneApc');
                            
        try{
            list<Opportunity> opp = [SELECT o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Docs_Sent__c, o.Visa_Docs_Received__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, 
                                    o.Validator__c, o.Type, o.Transportation_Note__c, o.Total_Participants__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.Sys_Payment_Instruction_Id__c, 
                                    o.Sys_Invoice_Language__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c,  o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Screening_Concern__c, 
                                    o.Screening_Concern_Comments__c, o.School_Id__c, o.Scholarship_incomplete_documents__c, o.Scholarship_Type__c, o.Scholarship_Status__c, o.Scholarship_Score__c, o.Scholarship_Documents_Notes__c, o.Round__c, 
                                    o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c,  o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, 
                                    o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, 
                                    o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Program_Trip_Indicated__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, 
                                    o.Pay_Notes__c, o.Pay_Advance__c,  o.Partner_Account__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PPP_Status__c, o.PAX__c, o.OwnerId, 
                                    o.ChildOppType__c, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, 
                                    o.Lead_Source_Original__c, o.LeadSource, o.Last_Contact_Attempt__c, o.Last_Applicant_Update__c, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Language_3__c, o.Language_3_Proficiency__c, 
                                    o.Language_2__c, o.Language_2_Proficiency__c, o.Language_1__c, o.Language_1_Proficiency__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.Invoice_No__c, o.Invoice_Language__c, o.Invoice_Date__c, o.Intrax_Region__c, 
                                    o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Program_Category__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interviewer_Territory__c, o.Interviewer_Phone__c, o.Interviewer_MailingStreet__c, 
                                    o.Interviewer_MailingPostalCode__c, o.Interviewer_MailingCountry__c, o.Interviewer_MailingCity__c, o.Interviewer_LastName__c, o.Interviewer_FirstName__c, o.Interviewer_Email__c, o.Interview_Requested__c, 
                                    o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, 
                                    o.Incomplete_Documents_Notes__c, o.ISFDC_ID__c, o.How_Heard__c, o.How_Heard_Other__c, o.How_Heard_Detail__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, 
                                    o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, 
                                    o.FiscalQuarter, o.Fiscal, o.Field_Staff__c,  o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Enquiry_Channel__c, 
                                    o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c,  o.Direct_Placement__c, o.Description, o.Deadline__c, o.DFH_Status__c, o.Current_Visa__c,  
                                    o.Create_Order__c, o.Countries_of_Interest__c, o.Countries_of_Interest_Local__c, o.Countries_Excluded__c,  o.Coordinator__c, o.Compensation_Type__c, o.Commission__c, o.CloseDate, 
                                    o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_State__c, o.Billing_Currency__c, 
                                    o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Fee_Received__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, 
                                    o.Agreement_Status__c, o.Acquisition_Campaign__c, o.Account_Owner_Phone__c, o.Account_Owner_Last_Name__c, o.Account_Owner_Full_Name__c, o.Account_Owner_Email__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c 
                                    From Opportunity o
                                    WHERE o.id =: appInfo.Opportunity_Name__c]; 
                                        
            list<Opportunity> oppClone = opp.deepClone();
            
            if(appInfo.RecordType.Name=='AuPairCare PT')
            {
                if(oppClone!=null && oppClone.size()>0)
                    oppClone[0].ChildOppType__c = 'Renewal';
                	oppClone[0].StageName = 'Prospecting';
            }
                
            
            insert oppClone;
            
            system.debug('******* appInfo.Id: '+appInfo.Id ); 
                
            applicantInfoClone = appInfo.clone();
            
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Applicant_Info__c.fields.getMap();
            
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
            //AA For Rematch Case
            else if(ApexPages.currentPage().getParameters().get('AppType') == 'Rematch'){
                applicantInfoClone.Name = appInfo.Account__r.FirstName + ' ' + appInfo.Account__r.LastName+ '-Rematch-'+System.Today().year();
                applicantInfoClone.Application_Type__c= 'Rematch';
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
            System.debug('oppClone Before ' + oppClone);
            if (oppClone != NULL)
            {
                System.debug('oppClone inside applicantInfoClone: ' + applicantInfoClone);
                applicantInfoClone.Opportunity_Name__c = oppClone[0].id;
                if(applicantInfoClone.RecordType.Name=='AuPairCare PT'){
                    AppTriggerHelper.CreateAppOpp(applicantInfoClone,applicantInfoClone.Opportunity_Name__c,'USD','Renewal');
                }
                else{
                    AppTriggerHelper.CreateAppOpp(applicantInfoClone,applicantInfoClone.Opportunity_Name__c,'USD','Match');  
                }
                //AppTriggerHelper.CreateAppOpp(applicantInfoClone,applicantInfoClone.Opportunity_Name__c,'USD','Renewal');
            }
            
            applicantInfoClone.Position__c = NULL;
            applicantInfoClone.Engagement__c = NULL;
            applicantInfoClone.Private_Bedroom_Indicated__c = null;  
            applicantInfoClone.CreatedBy__c = appInfo.CreatedBy__c;
            applicantInfoClone.RecordTypeId = appInfo.RecordTypeId;
            applicantInfoClone.Terms_Accepted__c = false;
            system.debug('*****###Flag2');
            applicantInfoClone.Application_Stage__c = 'Working';
            applicantInfoClone.Application_level__c = 'Main';
            //deleteAllowCloning();
            
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
    
    public static void personPaCloneApc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone )    
    {

            try{
                list<Person_Info__c> personInfo = [SELECT Work_Supervisor__c, Work_Phone__c, Title__c, TimeZoneSidKey__c, SystemModstamp, Special_Needs__c, Skype_Id__c, Role__c, Role_Other__c, Residency_Status__c, Profession__c, Primary_Applicant__c, Preferred_Phone_Type__c, Phone__c, Other_Phone__c, Nick_Name__c, Nemo_Id__c, Nationality__c, Name, Mobile__c, Middle_Name__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Intrax_Program_Option__c, Interests__c, Id, Gender__c, First_Name__c,   
                                                    Family_Member__c, Entity_Id__c, Employer_Name__c, Emergency_Contact__c, Emergency_Contact_Indicated__c, Email__c, Education_Level__c, ESSN__c, Do_you_smoke__c, Do_you_have_any_health_concerns__c, Date_of_Birth__c, CreatedDate, CreatedById, Country_of_Residence__c, ConnectionSentId, ConnectionReceivedId, Community_Service__c, Citizenship__c, Birth_Country__c, Birth_City__c, Best_Call_Time__c, Background_Check__c, Background_Check_Msg__c, Background_Check_Id__c, Background_Check_Consent_Received__c,          
                                                    Background_Check_By__c, Background_Check_At__c, BGC_Notes__c, Are_you_allergic_to_animals__c, Applicant_Info__c, Age__c, Age_At_Program_Start__c, Reference_Request_Note__c, Reference_Declined__c,Citizenship_Resident_Indicated__c,Offence_Indicated__c,Special_Needs_Description__c,Marital_Status__c,Special_Needs_Indicated__c,Source_Referral__c,Phone_Type__c,Source_Referral_Other__c,
                                                    Job_Sector__c, Employment_Status__c
                                                    from Person_Info__c
                                                    Where Applicant_Info__c =: appInfo.Id ];
                //and (Primary_Applicant__c = True or Role__c='Spouse or Partner' or Role__c='Child' or Role__c='Host')
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
     public static void experienceClone(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone, String EnggID)
     {
        
        Map<Id, list<Experience_Detail__c>> experienceDetMap = new Map<Id, list<Experience_Detail__c>>();
        list<Experience_Detail__c> InsertexperdetailClone = new  list<Experience_Detail__c>();
       
            try{
                list<Experience__c> experience = [SELECT  e.IsReference__c, e.Reference_Received__c, e.Name, e.Amount_Hours_Under_2__c, e.Amount_Hours__c, e.Start_Date__c,e.End_Date__c, e.Experience_Type__c,e.Id, e.Experience_Category__c, e.Frequency__c,e.Position_Description__c,e.IsExperienced__c,e.Employer_Name__c,e.Email__c,e.Phone_Country_Code__c,e.Phone__c,e.Reference_Request_Note__c,e.Position_Title__c,
                                                e.Skills_Required__c,e.First_Name__c,e.Last_Name__c, e.Applicant_Info__c,e.Employment_Hrs__c,e.Position_Responsibilities__c,e.Experience_Clone_Id__c,
                                                Special_Needs_Description__c,Children_Ages__c,Number_of_Children__c,Special_Needs_Indicated__c,Current_Job__c,Under_2_Percentage__c,
												(Select SystemModstamp, Special_Needs_Indicated__c, Special_Needs_Description__c, Name,
                                                    LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Id, Gender__c, Experience_Name__c, Date_of_Birth__c,
                                                    CurrencyIsoCode, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId
                                                    From Experience_Details__r)
                                                FROM Experience__c e
                                                WHERE e.Applicant_Info__c =: appInfo.Id];
                
                for(Experience__c ex: experience){
               
                    /*list<Experience_Detail__c> experienceDetList = [Select e.SystemModstamp, e.Special_Needs_Indicated__c, e.Special_Needs_Description__c, e.Name,
                                                    e.LastModifiedDate, e.LastModifiedById, e.LastActivityDate, e.IsDeleted, e.Id, e.Gender__c, e.Experience_Name__c, e.Date_of_Birth__c,
                                                    e.CurrencyIsoCode, e.CreatedDate, e.CreatedById, e.ConnectionSentId, e.ConnectionReceivedId
                                                    From Experience_Detail__c e
                                                    WHERE e.Experience_Name__c =: ex.Id];*/
                    
                    if(ex.Experience_Details__r != null){
                        list<Experience_Detail__c> experienceDetclone = ex.Experience_Details__r.deepClone();
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
                    e.Engagement__c = EnggID;
                    e.IsReference__c = true;
                    e.Reference_Received__c = true;
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
    
    
    public static void essayCloneapc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone,string EnggID)
    {
        try{
            list<Essay__c> essay = [SELECT e.Ordinal__c, e.Narrative__c, e.Name, e.Length__c, e.Language__c, e.Label__c, e.IsDeleted, e.Id, e.Applicant_Info__c
                                        FROM Essay__c e
                                        WHERE e.Applicant_Info__c =: appInfo.Id]; 
                                        
            list<Essay__c> essayClone = essay.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(Essay__c e: essayClone){
                e.Applicant_Info__c = appInfoClone.Id;
                e.Engagement__c = EnggID;
            }
            
            insert essayClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
    }
    
    
    public static void EducationCloneapc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone, string EnggID)
    {
        try{
            list<Education__c> education = [SELECT e.Study_Level__c, e.State__c, e.Program_Type__c, e.Program_Type_Other__c, e.Postal_Code__c, e.Phone__c, e.Phone_Country_Code__c, e.Name, 
                                    e.Institution_Type__c, e.Institution_Name__c, e.Id, e.Graduation_Date__c, e.Field_of_Study__c, e.Engagement__c, 
                                    e.Country__c, e.ConnectionSentId, e.ConnectionReceivedId, e.City__c, e.Certification__c, e.Certificate_Expiry_Date__c, e.Applicant_Info__c, e.Address_Street_2__c, 
                                    e.Address_Street_1__c
                                        FROM Education__c e
                                        WHERE e.Applicant_Info__c =: appInfo.Id]; 
                                        
            list<Education__c> educationClone = education.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(Education__c e: educationClone){
                e.Applicant_Info__c = appInfoClone.Id;
                e.Engagement__c = EnggID;
            }
            
            insert educationClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Education Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
    }
   
   public static void IPUCloneapc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone)
   {
        try{
            list<Intrax_Program_Upload__c> ipu = [SELECT i.Applicant_Info__c, i.Engagement__c FROM Intrax_Program_Upload__c i
                                        WHERE i.Applicant_Info__c =: appInfo.Id]; 
                                        
            //list<Intrax_Program_Upload__c> ipuClone = ipu.deepClone();
            //system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            if (ipu.size() > 0)
            {
                for(Intrax_Program_Upload__c e: ipu){
                    e.Applicant_Info__c = appInfoClone.Id;
                    e.Engagement__c = appInfoClone.Engagement__c;
                }
                update ipu;
            }
            
           // insert ipuClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
    }
    
    
    public static void RefCloneapc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone)
    {
        try{
            list<Reference__c> ref = [SELECT r.Type__c, r.Trust_with_Child__c, r.Time_Known__c,r.Sys_Admin_Tag__c, r.Substance_Physical_Abuse__c, r.Street__c, r.Status__c, r.State__c, r.Review_Date__c, r.Relationship_to_Family__c,
            r.Relation_To_Participant__c, r.Reference_Url__c, r.Reference_Status__c, r.Reference_Requested__c, r.Reference_Request_Note__c, r.Reference_Language__c, r.Reference_Declined__c, r.Reference_Declined_Url__c, r.Reference_Created_Date__c, 
            r.Reference_Contact_Requested__c, r.RecordTypeId, r.Recommend_Participation__c, r.Recommend_Participation_Description__c, r.Recommend_Hosting__c, r.Rating__c, r.Prior_Host_Description__c, r.Primary_Applicant__c, r.Primary_Applicant_Id__c,
            r.Primary_App_Last_Name__c, r.Primary_App_First_Name__c, r.Postal_Code__c, r.Position__c, r.Phone__c, r.Phone_Country_Code__c, r.Person_Info__c, r.Participant_Traits__c, r.Participant_Suitability__c, r.OwnerId, r.Name, r.Mobile__c, 
            r.Last_Name__c, r.Intrax_Program__c, r.Intrax_Program_Options__c, r.Id, r.Hosting_Motivation__c, r.Hosting_Interest__c, r.First_Name__c, r.Family_Stability__c, r.Family_Involvement__c, 
            r.Family_Home_Environment__c, r.Family_Home_Cleanliness__c, r.Family_Flexibility__c, r.Family_Financial_Ability__c, r.Family_Dynamics__c, r.Family_Activity__c, r.Experience_Name__c, r.Email__c, r.Eligibility_Confirmation__c, 
            r.Data_Verified__c, r.Data_Verified_Description__c, r.Criminal_Convictions_Description__c, r.Constant_Reference_URL__c, r.ConnectionSentId, r.ConnectionReceivedId, r.Completed_By__c, r.Comments__c, r.City__c, r.Applicant_Info__c, 
            r.Applicant_Info_Last_Name__c, r.Applicant_Info_Id__c, r.Applicant_Info_First_Name__c, r.Allow_AuPair__c
                                        FROM Reference__c r
                                        WHERE r.Applicant_Info__c =: appInfo.Id]; 
            
            set<id> expids = new set<id>();
            map<id,id> mapoldexpwithnew = new map<id,id>();
            
            if (ref != null && ref.size()>0)
            {
                for(Reference__c singleRef:ref)
                {
                    if(singleRef.Experience_Name__c != NULL)
                    {
                        expids.add(singleRef.Experience_Name__c);
                    }
                }
                
                if(expids.size() >0)
                {
                    list<Experience__c> explist =[SELECT id, Experience_Clone_Id__c FROM Experience__c WHERE Experience_Clone_Id__c IN :expids AND Applicant_Info__c =:appInfoClone.Id ];
                    if(explist.size()>0)
                    {
                        for(Experience__c singleexp : explist)
                        {
                            mapoldexpwithnew.put(singleexp.Experience_Clone_Id__c, singleexp.id);
                        }
                        system.debug('****mapoldexpwithnew*****'+mapoldexpwithnew);
                    }
                }
                       
                list<Reference__c> refClone = ref.deepClone();
                system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
                
                for(Reference__c e: refClone){
                    e.Applicant_Info__c = appInfoClone.Id;
                    e.Status__c = 'Confirmed';
                    e.Reference_Requested__c = true;
                    system.debug('****e.Experience_Name__c*****'+e.Experience_Name__c);
                    if(mapoldexpwithnew.get(e.Experience_Name__c) != NULL)
                    {
                        e.Experience_Name__c = mapoldexpwithnew.get(e.Experience_Name__c);
                    }
                }
                
                insert refClone;
            }
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Ref Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
    }
    
    public static void DISCCloneapc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone)
    {
        try{
            list<DISC__c> disc = [SELECT d.Test_Time_Taken__c, d.Test_Completion_DateTime__c, d.Summary_of_Personality__c, d.S_Score__c, d.SDescription__c, 
            d.Report_URL__c, d.Point_System_Result__c, d.OwnerId, d.Name, d.I_Score__c, d.IP_Address__c, d.IDescription__c, d.D_Score__c, d.DDescription__c, 
            d.ConnectionSentId, d.ConnectionReceivedId, d.CasperAPID__c, d.Candidate_Added_DateTime__c, d.C_Score__c, d.CDescription__c, d.AppID__c
                                        FROM DISC__c d
                                        WHERE d.AppID__c =: appInfo.Id]; 
                                        
            list<DISC__c> discClone = disc.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(DISC__c e: discClone){
                e.AppID__c = appInfoClone.Id;
            }
            
            insert discClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone DISC Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
    }
    
    public static string EnggCloneapc(Applicant_Info__c appInfo, string oppIDStr,string EnggAppType){
        try{
        if(appInfo.Engagement__c != NULL)
            {
                list<Engagement__c> EnggInfo = [SELECT e.Visa_Type__c, e.Visa_Interview_Status__c, e.Visa_Interview_Date__c, e.Visa_Category__c, e.Type__c, e.Tuition__c, 
                e.Training_Plan_Signed_PT__c, e.Training_Plan_Signed_HC__c, e.Training_Plan_Accepted__c, e.Total_Compensation__c, e.Terms_Accepted__c, 
                e.Terms_Accepted_Date__c, e.TEFL_Course_Taken__c, e.SystemModstamp, e.Sys_Admin_Tag__c, e.Swimming_Level__c, e.Swimming_Indicated__c, 
                e.Swimming_Comfort_Children__c, e.Status__c, e.Smoker_Student__c, e.Single_No_Children_Indicated__c, e.Single_Mother_Indicated__c, 
                e.Single_Father_Indicated__c,    
                e.Service_Level__c, 
                e.Season__c, e.School_Name__c, e.School_Id__c, e.Same_Sex_Couple_Indicated__c, e.SEVIS_Subject_Code__c, 
                e.SEVIS_Subject_Category__c, e.SEVIS_Program__c, e.SEVIS_Position__c, e.SEVIS_Occupation__c, e.SEVIS_ID__c, e.Risk_coverage_certificate__c, 
                e.Resume_Received__c, e.Resume_Rating__c, e.RecordTypeId, e.Received_US_Govt_Funds__c, e.Reason__c, e.Projects_of_Interest__c, e.Program_Year__c, 
                e.Program_Start__c, e.Program_Sponsor_Funds__c, e.Program_Ready_Date__c, e.Program_Duration__c, e.Prog_Duration_Extended__c, 
                e.Private_High_School_Indicated__c, e.Priority_Engagement__c, e.Primary_Language__c, e.Primary_Activity__c, e.Preparedness_Rating__c, 
                e.Pre_Program_Trip_Start__c, e.Pre_Program_Trip_Indicated__c, e.Pre_Program_Trip_End__c, e.Post_Program_Trip_Start__c, e.Post_Program_Trip_Indicated__c, 
                e.Post_Program_Trip_End__c, e.Position_Types__c, e.Position_Types_Other__c, e.Placement_Status__c, e.Pets_Allergy_Indicated__c, 
                e.Pets_Allergy_Description__c, e.Pet_Allergy_Types__c, e.Personality_Structure__c, e.Personality_Opinionatedness__c, e.Personality_Maturity__c, 
                e.Personality_Independence__c, e.Personality_Funniness__c, e.Personality_Expressiveness__c, e.Personality_Energy_Level__c, e.Personal_Funds__c, 
                e.Payment_Received__c, e.Passport_Review_Date__c, e.Partner_Name__c, e.Partner_Id__c, e.Partner_Account__c, e.Participant_ID__c, 
                e.Parent_Engagement__c, e.Parent_Engagement_Start__c, e.Parent_Engagement_End__c, e.PDExtendedDate__c, e.OwnerId, e.Own_Insurance__c, 
                e.Other_Org_Name__c, e.Other_Org_Funding__c, e.Other_Languages__c, e.Other_Financial_Support__c, e.Orientation_Date__c, e.Orientation_Agreement__c, 
                e.Opportunity_Id__c, e.Number_of_Trips__c, e.Needs_Travel__c, e.Nationality__c, e.Name, e.Mid_Program_Evaluation__c, e.Member__c, e.Match_Notes__c, 
                e.Major__c, e.Location_of_Interest__c, e.Live_With_Smoker__c, e.Live_With_Pets__c, e.Live_With_Pets_Description__c, e.Last_Match_Date__c, 
                e.Language_Level__c, e.Language_Level_Accepted__c, e.Language_3__c, e.Language_3_Proficiency__c, e.Language_2__c, e.Language_2_Proficiency__c, 
                e.Language_1__c, e.Language_1_Proficiency__c, e.Is_Traveling__c, e.Intrax_Region__c, e.Intrax_Program__c, e.Intrax_Program_Options__c, 
                e.Intrax_Program_Category__c, e.Intrax_Id__c, e.Intrax_Center__c, e.Interests_Top__c, e.Interests_Hobbies__c, e.Interests_Hobbies_Description__c, 
                e.Interest_Sports__c, e.Interest_Fine_Arts__c, e.Int_Org_Funding__c, e.Insurance_Provider__c, e.Insurance_Individual_Policy_ID__c, 
                e.Insurance_Group_Policy_ID__c, e.Holiday_Break_Start__c, e.Holiday_Break_End__c, e.Health_Info_Review_Date__c, e.Group__c, e.Graduation_Date__c, 
                e.Grade_Level__c, e.Gender__c, e.Functional_Areas__c, e.Functional_Areas_Other__c, e.Flight_booking_needed__c, e.Flexible_Location__c, 
                e.Flexible_Dates__c, e.Final_Program_Evaluation__c, e.Extension_Geo_Pref_Indicator__c, e.Extension_Geo_Pref_Detail__c, e.Extension_Departure_Airport__c, 
                e.Experience_Summary__c, e.Enrollment_Id__c, e.Engagement_Start__c, e.Engagement_End__c, e.Engagement_Country__c, e.Engagement_Count__c, 
                e.Emergency_Contact_Received__c, e.Eligibility_Document_Accepted__c, e.Education_Program_Type__c, e.Driving_Transmission__c, 
                e.Driving_Snow_Experience__c, e.Driving_Comfort_Children__c, e.Drivers_wChildren_Indicated__c, e.Drivers_US_Licence_Indicated__c, 
                e.Drivers_Licence_Indicated__c, e.Drivers_Accident_Indicated__c, e.Drivers_Accident_Detail__c, e.Double_Placement_Indicated__c, e.Description__c, 
                e.Departure_Trip_Needed__c, e.Departing_City__c, e.Current_Accommodation_State__c,  
                e.Countries_of_Interest__c, e.ConnectionSentId, e.ConnectionReceivedId, e.Compensation_Type__c, e.Class_8__c, e.Class_7__c, e.Class_6__c, e.Class_5__c, 
                e.Class_4__c, e.Class_3__c, e.Class_2__c, e.Class_1__c, e.Children_Special_Needs_Care__c, e.Children_Comfortable_Number__c, 
                e.Children_Comfortable_Ages__c, e.Center_Disclosure_Accepted__c, e.Attitude_Rating__c, e.Arrival_Trip_Needed__c, e.Age_At_Program_Start__c, 
                e.Actual_Arrival__c, e.Account_Owner_Full_Name__c, e.Account_Id__c, Engagement_Type__c,e.Under_2_Total_Hours__c,
                e.Childcare_Total_Hours__c,
                e.Circulation_Start_Date__c,e.Circulation_End_Date__c,e.Earliest_Match_Date__c,e.Latest_Match_Date__c
                From Engagement__c e WHERE e.id = :appInfo.Engagement__c];
                
                list<Engagement__c> enggClone = EnggInfo.deepClone();
                
                list<Match__c> SelmatchEndDate = [Select End_Date__c from Match__c WHERE Engagement__c =: appInfo.Engagement__c AND Status__c = 'Confirmed' ORDER BY CreatedDate DESC];
                
                for(Engagement__c e: enggClone)
                {
                	e.Parent_Engagement__c = appInfo.Engagement__c;
                    e.In_Country__c = 'Yes';
                    e.Engagement_Start__c = NULL;
                    e.Engagement_End__c = NULL;
                    e.Status__c = 'New';
                    e.Placement_Status__c = 'Pending';
                    e.Opportunity_Id__c = oppIDStr;
                    e.Engagement_Type__c = EnggAppType;
                    if(SelmatchEndDate != NULL && SelmatchEndDate[0].End_Date__c != NULL)
                    {
                        //B-03362
                        //e.Engagement_Start__c = SelmatchEndDate[0].End_Date__c.addDays(1); 
                        e.Engagement_Start__c = SelmatchEndDate[0].End_Date__c;
                        
                        //B-03431
                        //e.Circulation_Start_Date__c=SelmatchEndDate[0].End_Date__c;
                        e.Circulation_End_Date__c=SelmatchEndDate[0].End_Date__c;
                        e.Earliest_Match_Date__c=SelmatchEndDate[0].End_Date__c.addDays(1);
                        e.Latest_Match_Date__c=SelmatchEndDate[0].End_Date__c.addDays(1);
                        //system.debug('debug::appInfo.Engagement__r.Engagement_End__c==='+appInfo.Engagement__r.Engagement_End__c);
                        e.Engagement_End__c=appInfo.Engagement__r.Engagement_End__c.addYears(1);
                    }
                }
                
                insert enggClone;
                if(enggClone != NULL && enggClone[0].id != NULL)
                {
                    return enggClone[0].id;
                }
                else return null;
            }
            else return null;
        }catch(Exception e){
        	system.debug('@@@@@ There was an Exception in EnggCloneapc():'+ e);
        	return null;
        }
    }
    
    public static string PosCloneapc(Applicant_Info__c appInfo, Applicant_Info__c appInfoClone)
    {
        if(appInfo.Position__c != NULL)
            {
                list<Position__c> PosInfo = [SELECT p.sAccount__c, p.Website_Status__c, p.Typical_Schedule__c, p.Type__c, p.Tuition__c, p.Title__c, p.Tipped_Position__c, 
                p.Terminated_Count__c, p.Supplies_Required__c, p.Supplies_Cost__c, p.Supervisor_Role__c, p.Street__c, p.Street_2__c, p.Status__c, 
                p.Status_Last_Modified_Date__c, p.State__c, p.Special_Notes__c, p.Smoker_in_Family__c, p.Skills_Required__c, p.Site_Name__c, 
                p.Single_No_Children_Indicated__c, p.Session__c, p.Service_Level__c, p.Second_Job_Allowed__c, p.Season__c, p.School_Model__c, p.School_Id__c, 
                p.School_Category__c, p.Requires_Interview__c, p.Required_Duties__c, p.Renewal__c, p.Religious_Restriction_Indicated__c, 
                p.Regional_Location__c, p.RecordTypeId, p.Published_Rank__c, p.Projects_of_Interest__c, p.Program_Year__c, p.Primary_Activity_Site__c, p.Postal_Code__c, 
                p.Positions_Sold__c, p.Position_Types__c, p.Position_Types_Other__c, p.Position_Supervisor__c, p.Position_Count__c, p.Pluto_ID__c, p.Pets__c, 
                p.Pets_Description__c, p.Personality_Independence__c, p.Pending_Count__c, p.Pay_Rate__c, p.Pay_Rate_Basis__c, p.Pay_Notes__c, p.Pay_Frequency__c, 
                p.OwnerId, p.Overtime_Rate__c, p.Overtime_Available__c, p.Orientation_Agreement__c, p.Opportunity_Stage__c, p.Offered_Count__c, p.Occupational_Category__c, 
                p.Nationality_Preferences__c, p.Name, p.Minimum_Position_Duration__c, p.Minimum_Age__c, p.Maximum_Hours__c, p.Maximum_Age__c, p.Matching_Notes__c, 
                p.Matched_Count__c, p.Match_Offer_Status__c, p.Match_Active_Count__c, p.Marketing_Notes__c, p.Latest_Start__c,  p.Languages_Required__c, 
                p.Language_Level__c, p.Language_3__c, p.Language_3_Proficiency__c, p.Language_3_Desirability__c, p.Language_2__c, p.Language_2_Proficiency__c, 
                p.Language_2_Desirability__c, p.Language_1__c, p.Language_1_Proficiency__c, p.Language_1_Desirability__c, p.Intrax_Region__c, p.Intrax_Program__c, 
                p.Intrax_Program_Options__c, p.Intrax_Program_Option_Depr__c, p.Intrax_Program_Category__c, p.Interview_Type__c, p.Interview_Date__c, p.Interests__c, 
                p.Host_Opportunity_Validator__c, p.Host_Opportunity_Stage__c, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.Hiring_Method__c, p.Gender_Preference__c, 
                p.Functional_Areas__c, p.Functional_Areas_Secondary__c, p.Functional_Areas_Other__c, p.Flexible_Dates__c, p.Field_Support_Supervisor__c, 
                p.Field_Support_Regional_Manager__c, p.Featured_Position_DEPR__c, p.Engagement_Earliest_End__c, p.Employment_Hrs_Wk__c, p.Earliest_End__c, 
                p.Double_Placement_Indicated__c, p.Description__c, p.Departure_Date_Time__c, p.Days_Before_Work__c, p.CurrencyIsoCode, 
                p.Cultural_Activities__c, p.Country__c, p.Countries_of_Interest__c, p.Countries_Excluded__c, p.Coordinator__c,  p.Compensation_Type__c, 
                p.Company_Provided_Housing__c, p.Code__c, p.City__c, p.Arrival_Departure_Phone__c, p.Arrival_Departure_Contact__c, p.Arrival_Departure_Contact_Depr__c, 
                p.Arrival_Date_Time__c, p.Approved_Ref_Count__c,p.Profile_Complete__c, p.Approved_Photo_Count__c, p.Approved_Date__c, p.Accepts_Groups__c, p.Accepts_Couples__c 
                From Position__c p WHERE p.id = :appInfo.Position__c];
                
                list<Position__c> posClone = PosInfo.deepClone();
                
                for(Position__c e: posClone)
                {
                    e.Status__c = 'Matching';
                    e.Host_Opportunity_Id__c = appInfoClone.Opportunity_Name__c;
                }
                
                insert posClone;
                if(posClone != NULL && posClone[0].id != NULL)
                {
                    return posClone[0].id;
                }
                else return null;
            }
            else return null;
    }
    
    
    
    
     public static void creatematch(string enggID,string PosID)
    {
        Opportunity HfchildOpp = new Opportunity();
        Position__c PosInfo = [SELECT Id, Name,Host_Opportunity_Id__c,Host_Company_Id__c FROM Position__c WHERE Id =: PosID];
        system.debug('debuug::'+PosInfo.Host_Opportunity_Id__c);

        list<Opportunity> HfchildOpplist = [select id,Name from opportunity where Parent_Opportunity__c =:PosInfo.Host_Opportunity_Id__c and 
                                                (ChildOppType__c ='Match' OR ChildOppType__c ='Rematch') order by createddate desc limit 1]; 
       	//system.debug('debug::'+HfchildOpplist[0].id); 
        
        Engagement__c EnggInfo = [SELECT Id, Name, Opportunity_Id__c,Account_Id__c, Account_Id__r.CreatedById, Engagement_Start__c,Engagement_End__c  FROM Engagement__c WHERE Id =: enggID];
        system.debug('debug:::EnggInfo=='+EnggInfo);
        
        if(PosInfo!= NULL && EnggInfo != NULL)
        {
            RecordType MatchRrdId=[Select id from RecordType where SobjectType='Match__c' and DeveloperName='AuPairCare'];
            Match__c newMatch = new Match__c();
            newMatch.Name = (PosInfo.Name + ' - ' + EnggInfo.Name).left(80);
            newMatch.Position_Name__c = PosInfo.Id;
            newMatch.Host_Account__c = PosInfo.Host_Company_Id__c;
            newMatch.Engagement__c = EnggInfo.Id;
            newMatch.Participant_Opportunity_Id__c = EnggInfo.Opportunity_Id__c;
            newMatch.Participant_Id__c = EnggInfo.Account_Id__c;
            newMatch.RecordTypeId = MatchRrdId.id;
            newMatch.Status__c = 'Requested';
            newMatch.Offer_Status__c = 'Not Offered';
            newMatch.Match_Type__c = 'Extension';
            newMatch.Arrival_Date__c = EnggInfo.Engagement_Start__c;
            //B-03362
            //newMatch.Start_Date__c = EnggInfo.Engagement_Start__c;
            newMatch.Host_Family_Child_Opportuniy__c=HfchildOpplist[0].id;
            insert newMatch;
            
            //Sharing Match with OCPM PT -- Saroj could you review this
            system.debug('@@@@@# sharing Match with PT User');
            //Sharing_Security_Controller.shareMatRecord(PosInfo.Id, EnggInfo.Account_Id__r.CreatedById);
                
        }
    }
    
    
    @future
    public static void APExtensionmethods(string APID, string HFID,string EnggID,string oppID,string HFCreatedBYStr)
    {
        Applicant_Info__c appInfo = [SELECT Years_in_Home__c, Under_2_Total_Hours__c, Writing_Skills__c, Weight__c, Visa_Type__c, Visa_Category__c, Type__c, Title__c, TimeZoneSidKey__c, Terms_Accepted__c, Teaching_Method__c, TE_Known_for_Months__c, TE_Known_For_Years__c, SystemModstamp, Sys_Admin_Tag__c, Submitted__c, Submitted_Date__c, Study_Weeks__c, Study_Time__c, Street__c, State__c, Standard_Delivery__c, Special_Needs_Food__c, Special_Ed__c, Special_Ed_Description__c, Special_Diet__c, Special_Diet_Indicated__c, Special_Diet_Expectation_Description__c, Special_Diet_Description__c, Speaking_Skills__c, Smoking_Location__c, Smoker_in_Family__c, Smoker_Student__c, Skip_or_Repeat__c, Skip_or_Repeat_Description__c, Single_No_Children_Indicated__c, Shared_Bedroom__c, Shared_Bathroom__c, Service_Level__c, Second_Language_Level__c, School_Transportation__c, School_Transportation_Description__c, School_Recruiting_Indicated__c, School_Recruiting_Description__c, School_Officials_Title__c, School_Officials_Name__c,
                                    School_Name__c, School_Name_SOR__c, School_Employee__c, SOR_Received_Date__c, Reviewed_Date__c, Resume__c, Residence_Club__c, Religious_Sharing_Indicated__c, Religious_Restriction_Indicated__c, Religious_Activity_on_Program__c, Religious_Activity_Home__c, Religion__c, Reference_Count__c, RecordTypeId, Recommended_Grade__c, Reading_Comprehension__c, RB_Last_Name__c, RB_First_Name__c, Questions__c, Projects_of_Interest__c, Program_Year__c, Program_Start__c, Program_Start_Opinion__c, Program_Selector__c,
                                    Program_Duration__c, Profile_Summary__c, Private_High_School_Tuition__c, Private_High_School_Indicated__c, Private_Bedroom__c, Private_Bathroom__c, Prior_Visa_Start_Date__c, Prior_Visa_End_Date__c, Prior_Hosting_Agency__c, Prior_Host_Experience__c, Prior_Host_Experience_DEPR__c, Prior_Host_Description__c, Prior_Exchange_Visa__c, Prior_Exchange_Experience__c, Primary_Language__c, Primary_Activity__c, Previous_Address_Complete__c, PreUniversity_Years_at_Start__c, PreUniversity_Years_Required__c, Postal_Code__c,
                                    Position_Types__c, Position_Types_Other__c, Points_of_Interest__c, Pluto_Id__c, Placement_Pending__c, PhotoId__c, Pets_in_House__c, Pets__c, Pets_Description__c, Pet_Types__c, Pet_Count__c, Personality_Structure__c, Personality_Opinionatedness__c, Personality_Maturity__c, Personality_Independence__c, Personality_Funniness__c, Personality_Expressiveness__c, Personality_Energy_Level__c, Pax__c, Pax_Count__c, Passport_Number__c, Passport_Country__c, Partner_Name__c, Partner_Intrax_Id__c, Parent_Marital_Status__c,
                                    PR_Traditional_Family_Stmt__c, PR_Interview_Date__c, PR_English_Interview_Stmt__c, OwnerId, Own_insurance__c, Overall_Progress__c, Other_Languages__c, Opportunity_Name__c, Nemo_Update_Request_At__c, Nemo_Id__c, Nearest_City__c, Nationality_Preferences__c, Name, Meal_Self_Sufficient__c, Major__c, Low_Grade_Count__c, Location_of_Interest__c, Lives_With__c, Lives_With_Other__c, Lived_Independently__c, Lived_Independently_Description__c, Live_With_Smoker__c, Live_With_Pets__c, Live_With_Pets_Description__c, Legal_Guardian__c,
                                    Lead__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, Languages_Spoken__c, Language_spoken_years_3__c, Language_spoken_years_2__c, Language_spoken_years_1__c, Language_spoken_3__c, Language_spoken_2__c, Language_spoken_1__c, Language_3__c, Language_3_Proficiency__c, Language_2__c, Language_2_Proficiency__c, Language_1__c, Language_1_Proficiency__c, IsDeleted, Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Intrax_Insurance__c, Intrax_Homestay_Accommodations__c, Intrax_Center__c, Intrax_Accommodations__c,
                                    International_Travel__c, International_Travel_Description__c, Interests__c, Interests_Top__c, Incomplete_Missing_Documents__c, Incomplete_Documents_Notes__c, Id, How_Long_Tought__c, How_Long_Study_English__c, How_Heard__c, Household_Income_Range__c, Host_Special_Diet__c, Homestay__c, Home_Visit_Checklist__c, Home_Type__c, Home_Street_2__c, Home_Street_1__c, Home_State__c, Home_Responsibilities__c, Home_Province__c, Home_Postal_Code__c, Home_Phone__c, Home_Country__c, Home_City__c, Height__c, Health_Needs_Indicated__c,
                                    Health_Needs_Description__c, Graduation_Year__c, Graduation_Expected_by_School__c, Graduation_Date__c, Graduated__c, Government_Assistence_Indicated__c, General_Summary__c, Gender_Preference__c, GPA__c, GPA_Self_Reported__c, Functional_Areas__c, Functional_Areas_Other__c, Flight_Number__c, Flight_Arrival_Time__c, Flight_Arrival_Date__c, Field_Work_Experience__c, Fax__c, Family_Members_Complete__c, Family_Member_Count__c, Family_Activities__c, Extracurricular_Transportation__c, Express_Delivery__c, Exchange_Agency_Employment__c,
                                    Exchange_Agency_Employer_Name__c, Entity_Id__c, English_Test_Type__c, English_Test_Score__c, English_Teacher_Title__c, English_Teach_Name__c, English_Summary__c, English_Study_Years__c, English_Level__c, English_Ability__c, Engagement_Start__c, Engagement_End__c, Employer_Name__c, Emergency_Contact_Complete__c, Email__c, Education_Grade__c, ETR_Received_Date__c, ESSN__c, Double_Placement_Indicated__c, Distance_to_School__c, Disabilities__c, Disabilities_Description__c, Deposit_Fee_Accepted__c, Date_of_Birth__c, Daily_Meal_Commitment__c,
                                    Curfew_Weekends__c, Curfew_Weekdays__c, Curfew_Indicated__c, Criminal_Investigation_Indicated__c, Criminal_Investigation_Description__c, Criminal_Convictions_Indicated__c, Criminal_Convictions_Description__c, CreatedDate, CreatedById, Country_of_Interest__c, Country_of_Birth__c, Country__c, Coordinator__c, ConnectionSentId, ConnectionReceivedId, Community_Website__c, Community_Type__c, Community_Population__c, Community_Description__c, Classroom_Cooperation__c, City__c, Citizenship__c, Children_Enrolled__c, Check_out_Date__c, Check_in_Date__c,
                                    Center_Disclosure_Accepted__c, Carrier__c, Carrier_Number__c, Business_in_Home__c, Business_in_Home_Description__c, Best_Call_Time_c__c, Best_Call_Time__c, Behavioral_Problems__c, Behavioral_Problems_Description__c, Bedrooms__c, Bedroom_Type__c, Bedroom_Shared_With__c, Bedroom_Shared_Indicated__c, Bathrooms__c, Bathroom_Type__c, BGC_Required_Count_AYU__c, BGC_Passed_Count_AYU__c, BGC_D_Remaining__c, Attendance_Problems__c, Attendance_Problems_Description__c, Arriving_Time__c, Arriving_Date__c, Arrival_Time__c, Application_Stage__c, Application_Level__c,
                                    Applicant_Info_Count__c, Any_housing_that_fits_my_program_dates__c, Any_Special_Food_Requirement__c, Allergies_from_Partner__c, Allergies_from_Applicant__c, Allergies_Other_desc__c, Allergies_Other_Partner__c, Allergies_Indicated__c, Airport__c, Airport_Transfer_Departure__c, Airport_Transfer_Arrival__c, Account__c, Accommodation_Price_Range__c, Accommodation_Preference__c, Accepted_Date__c, Academic_Years_Completed__c, RecordType.Name, PageStatus_Complete__c, PageStatus_Started__c, Countries_of_Interest__c, Driving_Preference_indicated__c,
                                    Special_Diet_Expectations__c, Portal_Contact_Id__c, Account__r.FirstName, Account__r.LastName, Lead__r.IsConverted, CreatedBy__c ,US_Passport_Indicated__c,Swimming_Level__c,Swimming_Indicated__c, Swimming_Comfort_Children__c,Single_Mother_Indicated__c,Single_Father_Indicated__c,Same_Sex_Couple_Indicated__c,Preferred_Arrival_Date__c,Pets_Allergy_Indicated__c,Pets_Allergy_Description__c,Pet_Allergy_Types__c,Passport_Indicated__c,Aupair_Preferences__c,Away_Count__c,Childcare_Experience_Indicated__c,Children_Comfortable_Ages__c,Children_Special_Needs_Care__c,Children_Special_Needs_Description__c, Children_Special_Needs_Indicated__c,Children_Special_Needs_Skills__c,Drivers_Licence_Acquired__c,Drivers_Licence_Expires__c,Drivers_Licence_Indicated__c,Driving_Comfort_Children__c,
                                    Driving_Experience__c,Driving_Frequency__c,Driving_Snow_Experience__c,Driving_Transmission__c,Family_Description__c,Allergy_Description__c, Interest_Fine_Arts__c,Interests_Hobbies__c,Interests_Hobbies_Description__c,Interests_Leisure__c,Interest_Sports__c,Lived_Away_Indicated__c,Month_Arrival__c,Private_Bedroom_Indicated__c,Application_Type__c,AuPairsResponsibilities__c,Casper_Id__c,
                                    Position__c, Engagement__c, Engagement__r.Engagement_End__c
                                    from Applicant_Info__c 
                                    WHERE Id =: APID ];
                                    
              
             Applicant_Info__c applicantInfoClone = appInfo.clone();
             
             /*list<Opportunity> opp = [SELECT o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Docs_Sent__c, o.Visa_Docs_Received__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, 
                                    o.Validator__c, o.Type, o.Transportation_Note__c, o.Total_Participants__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.Sys_Payment_Instruction_Id__c, 
                                    o.Sys_Invoice_Language__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Screening_Concern__c, 
                                    o.Screening_Concern_Comments__c, o.School_Id__c, o.Scholarship_incomplete_documents__c, o.Scholarship_Type__c, o.Scholarship_Status__c, o.Scholarship_Score__c, o.Scholarship_Documents_Notes__c, o.Round__c, 
                                    o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c,  o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, 
                                    o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, 
                                    o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Program_Trip_Indicated__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, 
                                    o.Pay_Notes__c, o.Pay_Advance__c, o.Partner_Account__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PPP_Status__c, o.PAX__c, o.OwnerId, 
                                    o.ChildOppType__c, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, 
                                    o.Lead_Source_Original__c, o.LeadSource, o.Last_Contact_Attempt__c, o.Last_Applicant_Update__c, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Language_3__c, o.Language_3_Proficiency__c, 
                                    o.Language_2__c, o.Language_2_Proficiency__c, o.Language_1__c, o.Language_1_Proficiency__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.Invoice_No__c, o.Invoice_Language__c, o.Invoice_Date__c, o.Intrax_Region__c, 
                                    o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Program_Category__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interviewer_Territory__c, o.Interviewer_Phone__c, o.Interviewer_MailingStreet__c, 
                                    o.Interviewer_MailingPostalCode__c, o.Interviewer_MailingCountry__c, o.Interviewer_MailingCity__c, o.Interviewer_LastName__c, o.Interviewer_FirstName__c, o.Interviewer_Email__c, o.Interview_Requested__c, 
                                    o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, 
                                    o.Incomplete_Documents_Notes__c, o.ISFDC_ID__c, o.How_Heard__c, o.How_Heard_Other__c, o.How_Heard_Detail__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, 
                                    o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, 
                                    o.FiscalQuarter, o.Fiscal, o.Field_Staff__c,  o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Enquiry_Channel__c, 
                                    o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c,  o.Direct_Placement__c, o.Description, o.Deadline__c, o.DFH_Status__c, o.Current_Visa__c,  
                                    o.Create_Order__c, o.Countries_of_Interest__c, o.Countries_of_Interest_Local__c, o.Countries_Excluded__c,  o.Coordinator__c, o.Compensation_Type__c, o.Commission__c, o.CloseDate, 
                                    o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_State__c, o.Billing_Currency__c,  
                                    o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Fee_Received__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, 
                                    o.Agreement_Status__c, o.Acquisition_Campaign__c, o.Account_Owner_Phone__c, o.Account_Owner_Last_Name__c, o.Account_Owner_Full_Name__c, o.Account_Owner_Email__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c 
                                    From Opportunity o
                                    WHERE o.id =: appInfo.Opportunity_Name__c]; 
                                        
            list<Opportunity> oppClone = opp.deepClone();
            
            insert oppClone;     */ 
                             
             try{
            
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Applicant_Info__c.fields.getMap();
            
            
            system.debug('****** Is lead Converted?: ' + AppInfo.Lead__r.IsConverted);
            if(!appInfo.Lead__r.IsConverted){
                applicantInfoClone.Lead__c = appInfo.Lead__c;
            }
            else applicantInfoClone.Lead__c = null;
            
            applicantInfoClone.Name = appInfo.Account__r.FirstName + ' ' + appInfo.Account__r.LastName+ '-Extension-'+System.Today().year();
            applicantInfoClone.Application_Type__c= 'Extension';
            applicantInfoClone.PageStatus_Complete__c = '';
            
            if(applicantInfoClone.RecordType.Name=='AuPairCare PT')
            {
                applicantInfoClone.Month_Arrival__c = null;
            }
            applicantInfoClone.Driving_Transmission__c='';
            
            applicantInfoClone.Opportunity_Name__c = oppID;
            
            applicantInfoClone.Position__c = NULL;
            applicantInfoClone.Engagement__c = NULL;
            applicantInfoClone.Private_Bedroom_Indicated__c = null;  
            applicantInfoClone.CreatedBy__c = appInfo.CreatedBy__c;
            applicantInfoClone.RecordTypeId = appInfo.RecordTypeId;
            applicantInfoClone.Terms_Accepted__c = false;
            system.debug('*****###Flag2');
            applicantInfoClone.Application_Stage__c = 'Working';
            applicantInfoClone.Application_level__c = 'Main';
            
            /*list<Applicant_Info__c> applications = [SELECT Id, createdbyId, application_stage__c, SYS_allow_cloning__c, CreatedBy__c FROM Applicant_Info__c
                                                        WHERE CreatedBy__c =: userInfo.getUserId()];
            system.debug('********** Number of apps this belong to the current user: ' + applications.size());
            
            for(Applicant_Info__c a : applications){
                a.SYS_Allow_Cloning__c = false;
            }
            
            update applications;*/
            
            insert applicantInfoClone;
            
            
            if (HFCreatedBYStr != NULL)
            {
                Sharing_Security_Controller.shareApplicantRecord(applicantInfoClone.id, HFCreatedBYStr);
            }
            if (applicantInfoClone.CreatedBy__c != NULL)
            {
                Sharing_Security_Controller.shareApplicantRecord(HFID, applicantInfoClone.CreatedBy__c);
            }
            
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
        
        
        Applicant_Info__c appInfoClone = applicantInfoClone;
        
        system.debug('***appInfoClone***'+appInfoClone);
       
        
        try{
                list<Person_Info__c> personInfo = [SELECT Work_Supervisor__c, Work_Phone__c, Title__c, TimeZoneSidKey__c, SystemModstamp, Special_Needs__c, Skype_Id__c, Role__c, Role_Other__c, Residency_Status__c, Profession__c, Primary_Applicant__c, Preferred_Phone_Type__c, Phone__c, Other_Phone__c, Nick_Name__c, Nemo_Id__c, Nationality__c, Name, Mobile__c, Middle_Name__c, Last_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Intrax_Program_Option__c, Interests__c, Id, Gender__c, First_Name__c,   
                                                    Family_Member__c, Entity_Id__c, Employer_Name__c, Emergency_Contact__c, Emergency_Contact_Indicated__c, Email__c, Education_Level__c, ESSN__c, Do_you_smoke__c, Do_you_have_any_health_concerns__c, Date_of_Birth__c, CreatedDate, CreatedById, Country_of_Residence__c, ConnectionSentId, ConnectionReceivedId, Community_Service__c, Citizenship__c, Birth_Country__c, Birth_City__c, Best_Call_Time__c, Background_Check__c, Background_Check_Msg__c, Background_Check_Id__c, Background_Check_Consent_Received__c,          
                                                    Background_Check_By__c, Background_Check_At__c, BGC_Notes__c, Are_you_allergic_to_animals__c, Applicant_Info__c, Age__c, Age_At_Program_Start__c, Reference_Request_Note__c, Reference_Declined__c,Citizenship_Resident_Indicated__c,Offence_Indicated__c,Special_Needs_Description__c,Marital_Status__c,Special_Needs_Indicated__c,Source_Referral__c,Phone_Type__c,Source_Referral_Other__c,
                                                    Job_Sector__c, Employment_Status__c
                                                    from Person_Info__c
                                                    Where Applicant_Info__c =: appInfo.Id ];
                //and (Primary_Applicant__c = True or Role__c='Spouse or Partner' or Role__c='Child' or Role__c='Host')
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
            
            //Experience clone(Start)
            Map<Id, list<Experience_Detail__c>> experienceDetMap = new Map<Id, list<Experience_Detail__c>>();
            list<Experience_Detail__c> InsertexperdetailClone = new  list<Experience_Detail__c>();
       
            try{
                list<Experience__c> experience = [SELECT  e.IsReference__c, e.Reference_Received__c, e.Name, e.Amount_Hours_Under_2__c, e.Amount_Hours__c, e.Start_Date__c,e.End_Date__c, e.Experience_Type__c,e.Id, e.Experience_Category__c, e.Frequency__c,e.Position_Description__c,e.IsExperienced__c,e.Employer_Name__c,e.Email__c,e.Phone_Country_Code__c,e.Phone__c,e.Reference_Request_Note__c,e.Position_Title__c,
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
                    e.Engagement__c = EnggID;
                    e.IsReference__c = true;
                    e.Reference_Received__c = true;
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
            //Experience clone(End)


        //Essay Clone (Start)
        try
        {
            list<Essay__c> essay = [SELECT e.Ordinal__c, e.Narrative__c, e.Name, e.Length__c, e.Language__c, e.Label__c, e.IsDeleted, e.Id, e.Applicant_Info__c
                                        FROM Essay__c e
                                        WHERE e.Applicant_Info__c =: appInfo.Id]; 
                                        
            list<Essay__c> essayClone = essay.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(Essay__c e: essayClone){
                e.Applicant_Info__c = appInfoClone.Id;
                e.Engagement__c = EnggID;
            }
            
            insert essayClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
        //Essay Clone (End)
        
        //Education Clone (Start)
        try{
            list<Education__c> education = [SELECT e.Study_Level__c, e.State__c, e.Program_Type__c, e.Program_Type_Other__c, e.Postal_Code__c, e.Phone__c, e.Phone_Country_Code__c, e.Name, 
                                    e.Institution_Type__c, e.Institution_Name__c, e.Id, e.Graduation_Date__c, e.Field_of_Study__c, e.Engagement__c, 
                                    e.Country__c, e.ConnectionSentId, e.ConnectionReceivedId, e.City__c, e.Certification__c, e.Certificate_Expiry_Date__c, e.Applicant_Info__c, e.Address_Street_2__c, 
                                    e.Address_Street_1__c
                                        FROM Education__c e
                                        WHERE e.Applicant_Info__c =: appInfo.Id]; 
                                        
            list<Education__c> educationClone = education.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(Education__c e: educationClone){
                e.Applicant_Info__c = appInfoClone.Id;
            }
            
            insert educationClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
        //Education Clone (End)

        //IPU Clone (Start)
        try{
            list<Intrax_Program_Upload__c> ipu = [SELECT i.Applicant_Info__c, i.Engagement__c FROM Intrax_Program_Upload__c i
                                        WHERE i.Applicant_Info__c =: appInfo.Id]; 
                                        
            //list<Intrax_Program_Upload__c> ipuClone = ipu.deepClone();
            //system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            if(ipu.size() > 0)
            {
                for(Intrax_Program_Upload__c e: ipu){
                    e.Applicant_Info__c = appInfoClone.Id;
                    e.Engagement__c = EnggID;
                }
                update ipu;
            }
            
            //insert ipuClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
        //IPU Clone (End)
        
        //Reference Clone (Start)
        try{
            list<Reference__c> ref = [SELECT r.Type__c, r.Trust_with_Child__c, r.Time_Known__c,r.Sys_Admin_Tag__c, r.Substance_Physical_Abuse__c, r.Street__c, r.Status__c, r.State__c, r.Review_Date__c, r.Relationship_to_Family__c,
            r.Relation_To_Participant__c, r.Reference_Url__c, r.Reference_Status__c, r.Reference_Requested__c, r.Reference_Request_Note__c, r.Reference_Language__c, r.Reference_Declined__c, r.Reference_Declined_Url__c, r.Reference_Created_Date__c, 
            r.Reference_Contact_Requested__c, r.RecordTypeId, r.Recommend_Participation__c, r.Recommend_Participation_Description__c, r.Recommend_Hosting__c, r.Rating__c, r.Prior_Host_Description__c, r.Primary_Applicant__c, r.Primary_Applicant_Id__c,
            r.Primary_App_Last_Name__c, r.Primary_App_First_Name__c, r.Postal_Code__c, r.Position__c, r.Phone__c, r.Phone_Country_Code__c, r.Person_Info__c, r.Participant_Traits__c, r.Participant_Suitability__c, r.OwnerId, r.Name, r.Mobile__c, 
            r.Last_Name__c, r.Intrax_Program__c, r.Intrax_Program_Options__c, r.Id, r.Hosting_Motivation__c, r.Hosting_Interest__c, r.First_Name__c, r.Family_Stability__c, r.Family_Involvement__c, 
            r.Family_Home_Environment__c, r.Family_Home_Cleanliness__c, r.Family_Flexibility__c, r.Family_Financial_Ability__c, r.Family_Dynamics__c, r.Family_Activity__c, r.Experience_Name__c, r.Email__c, r.Eligibility_Confirmation__c, 
            r.Data_Verified__c, r.Data_Verified_Description__c, r.Criminal_Convictions_Description__c, r.Constant_Reference_URL__c, r.ConnectionSentId, r.ConnectionReceivedId, r.Completed_By__c, r.Comments__c, r.City__c, r.Applicant_Info__c, 
            r.Applicant_Info_Last_Name__c, r.Applicant_Info_Id__c, r.Applicant_Info_First_Name__c, r.Allow_AuPair__c
                                        FROM Reference__c r
                                        WHERE r.Applicant_Info__c =: appInfo.Id]; 
            set<id> expids = new set<id>();
            map<id,id> mapoldexpwithnew = new map<id,id>();
            
            if (ref != null && ref.size()>0)
            {
                for(Reference__c singleRef:ref)
                {
                    if(singleRef.Experience_Name__c != NULL)
                    {
                        expids.add(singleRef.Experience_Name__c);
                    }
                }
                
                if(expids.size() >0)
                {
                    list<Experience__c> explist =[SELECT id, Experience_Clone_Id__c FROM Experience__c WHERE Experience_Clone_Id__c IN :expids AND Applicant_Info__c =:appInfoClone.Id ];
                    if(explist.size()>0)
                    {
                        for(Experience__c singleexp : explist)
                        {
                            mapoldexpwithnew.put(singleexp.Experience_Clone_Id__c, singleexp.id);
                        }
                        system.debug('****mapoldexpwithnew*****'+mapoldexpwithnew);
                    }
                }
            
                                        
                list<Reference__c> refClone = ref.deepClone();
                system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
                
                for(Reference__c e: refClone){
                    e.Applicant_Info__c = appInfoClone.Id;
                    e.Status__c = 'Confirmed';
                    e.Reference_Requested__c = true;
                    system.debug('****e.Experience_Name__c*****'+e.Experience_Name__c);
                    if(mapoldexpwithnew.get(e.Experience_Name__c) != NULL)
                    {
                        e.Experience_Name__c = mapoldexpwithnew.get(e.Experience_Name__c);
                    }
                }
                
                insert refClone;
            }
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }   
        //Reference Clone (End)
        
        //DISC Clone (Start)
        try{
            list<DISC__c> disc = [SELECT d.Test_Time_Taken__c, d.Test_Completion_DateTime__c, d.Summary_of_Personality__c, d.S_Score__c, d.SDescription__c, 
            d.Report_URL__c, d.Point_System_Result__c, d.OwnerId, d.Name, d.I_Score__c, d.IP_Address__c, d.IDescription__c, d.D_Score__c, d.DDescription__c, 
            d.ConnectionSentId, d.ConnectionReceivedId, d.CasperAPID__c, d.Candidate_Added_DateTime__c, d.C_Score__c, d.CDescription__c, d.AppID__c
                                        FROM DISC__c d
                                        WHERE d.AppID__c =: appInfo.Id]; 
                                        
            list<DISC__c> discClone = disc.deepClone();
            system.debug('******* appInfoClone.ID: ' + appInfoClone.Id);
            
            for(DISC__c e: discClone){
                e.AppID__c = appInfoClone.Id;
            }
            
            insert discClone;
            
        }catch(Exception e){
            system.debug('****** Impossible to clone Essay Data for applicant '+ appInfoClone.Id + ': ' + e);
        }
        //DISC Clone (End)
        
        //Assign Engagement to Application (Start)
        appInfoClone.Engagement__c = EnggID;
        update appInfoClone;
        //Assign Engagement to Application (End)
        
        
    }
    //===End of APC Clone Functionality ====
       
       
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
   
   @future
  public static void updateExtensionAPAgreed(id appid)
  {
    list<Applicant_Info__c> updapplist = [SELECT Extension_Au_Pair_Agreed__c FROM Applicant_Info__c WHERE Id =: appid];
    if(updapplist.size() > 0)
    {
        for(Applicant_Info__c app : updapplist)
        {
            app.Extension_Au_Pair_Agreed__c = 'No';
        }
        update updapplist;
    }
  } 
  
  /*@future
  public static void updateEnggDetails(Id PevEnggID , Id NewEnggId)
    {
        if(PevEnggID != NULL && NewEnggId != NULL)
            {
                Engagement__c PrevEnggInfo = [SELECT e.Visa_Type__c, e.Visa_Interview_Status__c, e.Visa_Interview_Date__c, e.Visa_Category__c, e.Type__c, e.Tuition__c, 
                e.Training_Plan_Signed_PT__c, e.Training_Plan_Signed_HC__c, e.Training_Plan_Accepted__c, e.Total_Compensation__c, e.Terms_Accepted__c, 
                e.Terms_Accepted_Date__c, e.TEFL_Course_Taken__c, e.SystemModstamp, e.Sys_Admin_Tag__c, e.Swimming_Level__c, e.Swimming_Indicated__c, 
                e.Swimming_Comfort_Children__c, e.Status__c, e.Smoker_Student__c, e.Single_No_Children_Indicated__c, e.Single_Mother_Indicated__c, 
                e.Single_Father_Indicated__c,   
                e.Service_Level__c, 
                e.Season__c, e.School_Name__c, e.School_Id__c, e.Same_Sex_Couple_Indicated__c,  e.SEVIS_Subject_Code__c, 
                e.SEVIS_Subject_Category__c, e.SEVIS_Program__c, e.SEVIS_Position__c, e.SEVIS_Occupation__c, e.SEVIS_ID__c, e.Risk_coverage_certificate__c, 
                e.Resume_Received__c, e.Resume_Rating__c, e.RecordTypeId, e.Received_US_Govt_Funds__c, e.Reason__c, e.Projects_of_Interest__c, e.Program_Year__c, 
                e.Program_Start__c, e.Program_Sponsor_Funds__c, e.Program_Ready_Date__c, e.Program_Duration__c, e.Prog_Duration_Extended__c, 
                e.Private_High_School_Indicated__c, e.Priority_Engagement__c, e.Primary_Language__c, e.Primary_Activity__c, e.Preparedness_Rating__c, 
                e.Pre_Program_Trip_Start__c, e.Pre_Program_Trip_Indicated__c, e.Pre_Program_Trip_End__c, e.Post_Program_Trip_Start__c, e.Post_Program_Trip_Indicated__c, 
                e.Post_Program_Trip_End__c, e.Position_Types__c, e.Position_Types_Other__c, e.Placement_Status__c, e.Pets_Allergy_Indicated__c, 
                e.Pets_Allergy_Description__c, e.Pet_Allergy_Types__c, e.Personality_Structure__c, e.Personality_Opinionatedness__c, e.Personality_Maturity__c, 
                e.Personality_Independence__c, e.Personality_Funniness__c, e.Personality_Expressiveness__c, e.Personality_Energy_Level__c, e.Personal_Funds__c, 
                e.Payment_Received__c, e.Passport_Review_Date__c, e.Partner_Name__c, e.Partner_Id__c, e.Partner_Account__c, e.Participant_ID__c, 
                e.Parent_Engagement__c, e.Parent_Engagement_Start__c, e.Parent_Engagement_End__c, e.PDExtendedDate__c, e.OwnerId, e.Own_Insurance__c, 
                e.Other_Org_Name__c, e.Other_Org_Funding__c, e.Other_Languages__c, e.Other_Financial_Support__c, e.Orientation_Date__c, e.Orientation_Agreement__c, 
                e.Opportunity_Id__c, e.Number_of_Trips__c, e.Needs_Travel__c, e.Nationality__c, e.Name, e.Mid_Program_Evaluation__c, e.Member__c, e.Match_Notes__c, 
                e.Major__c, e.Location_of_Interest__c, e.Live_With_Smoker__c, e.Live_With_Pets__c, e.Live_With_Pets_Description__c, e.Last_Match_Date__c, 
                e.Language_Level__c, e.Language_Level_Accepted__c, e.Language_3__c, e.Language_3_Proficiency__c, e.Language_2__c, e.Language_2_Proficiency__c, 
                e.Language_1__c, e.Language_1_Proficiency__c, e.Is_Traveling__c, e.Intrax_Region__c, e.Intrax_Program__c, e.Intrax_Program_Options__c, 
                e.Intrax_Program_Category__c, e.Intrax_Id__c, e.Intrax_Center__c, e.Interests_Top__c, e.Interests_Hobbies__c, e.Interests_Hobbies_Description__c, 
                e.Interest_Sports__c, e.Interest_Fine_Arts__c, e.Int_Org_Funding__c, e.Insurance_Provider__c, e.Insurance_Individual_Policy_ID__c, 
                e.Insurance_Group_Policy_ID__c, e.Holiday_Break_Start__c, e.Holiday_Break_End__c, e.Health_Info_Review_Date__c, e.Group__c, e.Graduation_Date__c, 
                e.Grade_Level__c, e.Gender__c, e.Functional_Areas__c, e.Functional_Areas_Other__c, e.Flight_booking_needed__c, e.Flexible_Location__c, 
                e.Flexible_Dates__c, e.Final_Program_Evaluation__c, e.Extension_Geo_Pref_Indicator__c, e.Extension_Geo_Pref_Detail__c, e.Extension_Departure_Airport__c, 
                e.Experience_Summary__c, e.Enrollment_Id__c, e.Engagement_Start__c, e.Engagement_End__c, e.Engagement_Country__c, e.Engagement_Count__c, 
                e.Emergency_Contact_Received__c, e.Eligibility_Document_Accepted__c, e.Education_Program_Type__c, e.Driving_Transmission__c, 
                e.Driving_Snow_Experience__c, e.Driving_Comfort_Children__c, e.Drivers_wChildren_Indicated__c, e.Drivers_US_Licence_Indicated__c, 
                e.Drivers_Licence_Indicated__c, e.Drivers_Accident_Indicated__c, e.Drivers_Accident_Detail__c, e.Double_Placement_Indicated__c, e.Description__c, 
                e.Departure_Trip_Needed__c, e.Departing_City__c, e.Current_Accommodation_State__c,  
                e.Countries_of_Interest__c, e.ConnectionSentId, e.ConnectionReceivedId, e.Compensation_Type__c, e.Class_8__c, e.Class_7__c, e.Class_6__c, e.Class_5__c, 
                e.Class_4__c, e.Class_3__c, e.Class_2__c, e.Class_1__c, e.Children_Special_Needs_Care__c, e.Children_Comfortable_Number__c, 
                e.Children_Comfortable_Ages__c, e.Center_Disclosure_Accepted__c, e.Attitude_Rating__c, e.Arrival_Trip_Needed__c, e.Age_At_Program_Start__c, 
                e.Actual_Arrival__c, e.Account_Owner_Full_Name__c, e.Account_Id__c From Engagement__c e WHERE e.id = :PevEnggID];
                
                Engagement__c NewEnggInfo = [SELECT e.Visa_Type__c, e.Visa_Interview_Status__c, e.Visa_Interview_Date__c, e.Visa_Category__c, e.Type__c, e.Tuition__c, 
                e.Training_Plan_Signed_PT__c, e.Training_Plan_Signed_HC__c, e.Training_Plan_Accepted__c, e.Total_Compensation__c, e.Terms_Accepted__c, 
                e.Terms_Accepted_Date__c, e.TEFL_Course_Taken__c, e.SystemModstamp, e.Sys_Admin_Tag__c, e.Swimming_Level__c, e.Swimming_Indicated__c, 
                e.Swimming_Comfort_Children__c, e.Status__c, e.Smoker_Student__c, e.Single_No_Children_Indicated__c, e.Single_Mother_Indicated__c, 
                e.Single_Father_Indicated__c,   
                e.Service_Level__c, 
                e.Season__c, e.School_Name__c, e.School_Id__c, e.Same_Sex_Couple_Indicated__c, e.SEVIS_Subject_Code__c, 
                e.SEVIS_Subject_Category__c, e.SEVIS_Program__c, e.SEVIS_Position__c, e.SEVIS_Occupation__c, e.SEVIS_ID__c, e.Risk_coverage_certificate__c, 
                e.Resume_Received__c, e.Resume_Rating__c, e.RecordTypeId, e.Received_US_Govt_Funds__c, e.Reason__c, e.Projects_of_Interest__c, e.Program_Year__c, 
                e.Program_Start__c, e.Program_Sponsor_Funds__c, e.Program_Ready_Date__c, e.Program_Duration__c, e.Prog_Duration_Extended__c, 
                e.Private_High_School_Indicated__c, e.Priority_Engagement__c, e.Primary_Language__c, e.Primary_Activity__c, e.Preparedness_Rating__c, 
                e.Pre_Program_Trip_Start__c, e.Pre_Program_Trip_Indicated__c, e.Pre_Program_Trip_End__c, e.Post_Program_Trip_Start__c, e.Post_Program_Trip_Indicated__c, 
                e.Post_Program_Trip_End__c, e.Position_Types__c, e.Position_Types_Other__c, e.Placement_Status__c, e.Pets_Allergy_Indicated__c, 
                e.Pets_Allergy_Description__c, e.Pet_Allergy_Types__c, e.Personality_Structure__c, e.Personality_Opinionatedness__c, e.Personality_Maturity__c, 
                e.Personality_Independence__c, e.Personality_Funniness__c, e.Personality_Expressiveness__c, e.Personality_Energy_Level__c, e.Personal_Funds__c, 
                e.Payment_Received__c, e.Passport_Review_Date__c, e.Partner_Name__c, e.Partner_Id__c, e.Partner_Account__c, e.Participant_ID__c, 
                e.Parent_Engagement__c, e.Parent_Engagement_Start__c, e.Parent_Engagement_End__c, e.PDExtendedDate__c, e.OwnerId, e.Own_Insurance__c, 
                e.Other_Org_Name__c, e.Other_Org_Funding__c, e.Other_Languages__c, e.Other_Financial_Support__c, e.Orientation_Date__c, e.Orientation_Agreement__c, 
                e.Opportunity_Id__c, e.Number_of_Trips__c, e.Needs_Travel__c, e.Nationality__c, e.Name, e.Mid_Program_Evaluation__c, e.Member__c, e.Match_Notes__c, 
                e.Major__c, e.Location_of_Interest__c, e.Live_With_Smoker__c, e.Live_With_Pets__c, e.Live_With_Pets_Description__c, e.Last_Match_Date__c, 
                e.Language_Level__c, e.Language_Level_Accepted__c, e.Language_3__c, e.Language_3_Proficiency__c, e.Language_2__c, e.Language_2_Proficiency__c, 
                e.Language_1__c, e.Language_1_Proficiency__c, e.Is_Traveling__c, e.Intrax_Region__c, e.Intrax_Program__c, e.Intrax_Program_Options__c, 
                e.Intrax_Program_Category__c, e.Intrax_Id__c, e.Intrax_Center__c, e.Interests_Top__c, e.Interests_Hobbies__c, e.Interests_Hobbies_Description__c, 
                e.Interest_Sports__c, e.Interest_Fine_Arts__c, e.Int_Org_Funding__c, e.Insurance_Provider__c, e.Insurance_Individual_Policy_ID__c, 
                e.Insurance_Group_Policy_ID__c, e.Holiday_Break_Start__c, e.Holiday_Break_End__c, e.Health_Info_Review_Date__c, e.Group__c, e.Graduation_Date__c, 
                e.Grade_Level__c, e.Gender__c, e.Functional_Areas__c, e.Functional_Areas_Other__c, e.Flight_booking_needed__c, e.Flexible_Location__c, 
                e.Flexible_Dates__c, e.Final_Program_Evaluation__c, e.Extension_Geo_Pref_Indicator__c, e.Extension_Geo_Pref_Detail__c, e.Extension_Departure_Airport__c, 
                e.Experience_Summary__c, e.Enrollment_Id__c, e.Engagement_Start__c, e.Engagement_End__c, e.Engagement_Country__c, e.Engagement_Count__c, 
                e.Emergency_Contact_Received__c, e.Eligibility_Document_Accepted__c, e.Education_Program_Type__c, e.Driving_Transmission__c, 
                e.Driving_Snow_Experience__c, e.Driving_Comfort_Children__c, e.Drivers_wChildren_Indicated__c, e.Drivers_US_Licence_Indicated__c, 
                e.Drivers_Licence_Indicated__c, e.Drivers_Accident_Indicated__c, e.Drivers_Accident_Detail__c, e.Double_Placement_Indicated__c, e.Description__c, 
                e.Departure_Trip_Needed__c, e.Departing_City__c, e.Current_Accommodation_State__c,  
                e.Countries_of_Interest__c, e.ConnectionSentId, e.ConnectionReceivedId, e.Compensation_Type__c, e.Class_8__c, e.Class_7__c, e.Class_6__c, e.Class_5__c, 
                e.Class_4__c, e.Class_3__c, e.Class_2__c, e.Class_1__c, e.Children_Special_Needs_Care__c, e.Children_Comfortable_Number__c, 
                e.Children_Comfortable_Ages__c, e.Center_Disclosure_Accepted__c, e.Attitude_Rating__c, e.Arrival_Trip_Needed__c, e.Age_At_Program_Start__c, 
                e.Actual_Arrival__c, e.Account_Owner_Full_Name__c, e.Account_Id__c From Engagement__c e WHERE e.id = :NewEnggId];
                
                //list<Engagement__c> enggClone = EnggInfo.deepClone();
                
                list<Match__c> SelmatchEndDate = [Select End_Date__c from Match__c WHERE Engagement__c =: PevEnggID AND Status__c = 'Confirmed' ORDER BY CreatedDate DESC];
                
                //for(Engagement__c e: enggClone)
                //{
                    NewEnggInfo.Engagement_Start__c = NULL;
                    NewEnggInfo.Engagement_End__c = NULL;
                    NewEnggInfo.Status__c = 'Program Ready';
                    NewEnggInfo.Placement_Status__c = 'Pending';
                    NewEnggInfo.RecordTypeId = PrevEnggInfo.RecordTypeId;
                    NewEnggInfo.Intrax_Program__c = PrevEnggInfo.Intrax_Program__c;
                    NewEnggInfo.Swimming_Level__c = PrevEnggInfo.Swimming_Level__c;
                    NewEnggInfo.Swimming_Indicated__c = PrevEnggInfo.Swimming_Indicated__c;
                    NewEnggInfo.Swimming_Comfort_Children__c = PrevEnggInfo.Swimming_Comfort_Children__c;
                    NewEnggInfo.Smoker_Student__c = PrevEnggInfo.Smoker_Student__c;
                    NewEnggInfo.Single_No_Children_Indicated__c = PrevEnggInfo.Single_No_Children_Indicated__c;
                    NewEnggInfo.Single_Mother_Indicated__c = PrevEnggInfo.Single_Mother_Indicated__c;
                    NewEnggInfo.Single_Father_Indicated__c = PrevEnggInfo.Single_Father_Indicated__c;
                    NewEnggInfo.Service_Level__c = PrevEnggInfo.Service_Level__c;
                    NewEnggInfo.Season__c = PrevEnggInfo.Season__c;
                    NewEnggInfo.School_Name__c = PrevEnggInfo.School_Name__c;
                    NewEnggInfo.School_Id__c = PrevEnggInfo.School_Id__c;
                    NewEnggInfo.Same_Sex_Couple_Indicated__c = PrevEnggInfo.Same_Sex_Couple_Indicated__c;
                    NewEnggInfo.Risk_coverage_certificate__c = PrevEnggInfo.Risk_coverage_certificate__c;
                    NewEnggInfo.Resume_Received__c = PrevEnggInfo.Resume_Received__c;
                    NewEnggInfo.Resume_Rating__c = PrevEnggInfo.Resume_Rating__c;
                    NewEnggInfo.Received_US_Govt_Funds__c = PrevEnggInfo.Received_US_Govt_Funds__c;
                    NewEnggInfo.Reason__c = PrevEnggInfo.Reason__c;
                    NewEnggInfo.Projects_of_Interest__c = PrevEnggInfo.Projects_of_Interest__c;
                    NewEnggInfo.Program_Year__c = PrevEnggInfo.Program_Year__c;
                    NewEnggInfo.Program_Start__c = PrevEnggInfo.Program_Start__c;
                    NewEnggInfo.Program_Sponsor_Funds__c = PrevEnggInfo.Program_Sponsor_Funds__c;
                    NewEnggInfo.Program_Ready_Date__c = PrevEnggInfo.Program_Ready_Date__c;
                    NewEnggInfo.Prog_Duration_Extended__c = PrevEnggInfo.Prog_Duration_Extended__c;
                    NewEnggInfo.Private_High_School_Indicated__c = PrevEnggInfo.Private_High_School_Indicated__c;
                    NewEnggInfo.Priority_Engagement__c = PrevEnggInfo.Priority_Engagement__c;
                    NewEnggInfo.Primary_Language__c = PrevEnggInfo.Primary_Language__c;
                    NewEnggInfo.Primary_Activity__c = PrevEnggInfo.Primary_Activity__c;
                    NewEnggInfo.Preparedness_Rating__c = PrevEnggInfo.Preparedness_Rating__c;
                    NewEnggInfo.Pre_Program_Trip_Start__c = PrevEnggInfo.Pre_Program_Trip_Start__c;
                    NewEnggInfo.Pre_Program_Trip_Indicated__c = PrevEnggInfo.Pre_Program_Trip_Indicated__c;
                    NewEnggInfo.Pre_Program_Trip_End__c = PrevEnggInfo.Pre_Program_Trip_End__c;
                    NewEnggInfo.Post_Program_Trip_Start__c = PrevEnggInfo.Post_Program_Trip_Start__c;
                    NewEnggInfo.Post_Program_Trip_Indicated__c = PrevEnggInfo.Post_Program_Trip_Indicated__c;
                    NewEnggInfo.Post_Program_Trip_End__c = PrevEnggInfo.Post_Program_Trip_End__c;
                    NewEnggInfo.Position_Types__c = PrevEnggInfo.Position_Types__c;
                    NewEnggInfo.Position_Types_Other__c = PrevEnggInfo.Position_Types_Other__c;
                    NewEnggInfo.Pets_Allergy_Description__c  = PrevEnggInfo.Pets_Allergy_Description__c ;
                    NewEnggInfo.Pet_Allergy_Types__c = PrevEnggInfo.Pet_Allergy_Types__c;
                    NewEnggInfo.Personality_Structure__c = PrevEnggInfo.Personality_Structure__c;
                    NewEnggInfo.Personality_Opinionatedness__c = PrevEnggInfo.Personality_Opinionatedness__c;
                    NewEnggInfo.Personality_Maturity__c = PrevEnggInfo.Personality_Maturity__c;
                    NewEnggInfo.Personality_Independence__c = PrevEnggInfo.Personality_Independence__c;
                    NewEnggInfo.Personality_Funniness__c = PrevEnggInfo.Personality_Funniness__c;
                    NewEnggInfo.Personality_Expressiveness__c = PrevEnggInfo.Personality_Expressiveness__c;
                    NewEnggInfo.Personality_Energy_Level__c = PrevEnggInfo.Personality_Energy_Level__c;
                    NewEnggInfo.Personal_Funds__c = PrevEnggInfo.Personal_Funds__c;
                    NewEnggInfo.Passport_Review_Date__c = PrevEnggInfo.Passport_Review_Date__c;
                    NewEnggInfo.Partner_Name__c = PrevEnggInfo.Partner_Name__c;
                    NewEnggInfo.Partner_Id__c = PrevEnggInfo.Partner_Id__c;
                    NewEnggInfo.Partner_Account__c = PrevEnggInfo.Partner_Account__c;
                    //NewEnggInfo.Participant_ID__c = PrevEnggInfo.Participant_ID__c;
                    NewEnggInfo.Other_Org_Name__c = PrevEnggInfo.Other_Org_Name__c;
                    NewEnggInfo.Other_Org_Funding__c = PrevEnggInfo.Other_Org_Funding__c;
                    NewEnggInfo.Other_Languages__c = PrevEnggInfo.Other_Languages__c;
                    NewEnggInfo.Other_Financial_Support__c = PrevEnggInfo.Other_Financial_Support__c;
                    NewEnggInfo.Orientation_Date__c = PrevEnggInfo.Orientation_Date__c;
                    NewEnggInfo.Orientation_Agreement__c = PrevEnggInfo.Orientation_Agreement__c;
                    //NewEnggInfo.Nationality__c = PrevEnggInfo.Nationality__c;
                    NewEnggInfo.Language_Level__c = PrevEnggInfo.Language_Level__c;
                    NewEnggInfo.Language_Level_Accepted__c = PrevEnggInfo.Language_Level_Accepted__c;
                    NewEnggInfo.Language_3__c = PrevEnggInfo.Language_3__c;
                    NewEnggInfo.Language_3_Proficiency__c = PrevEnggInfo.Language_3_Proficiency__c;
                    NewEnggInfo.Language_2__c = PrevEnggInfo.Language_2__c;
                    NewEnggInfo.Language_2_Proficiency__c = PrevEnggInfo.Language_2_Proficiency__c;
                    NewEnggInfo.Language_1__c = PrevEnggInfo.Language_1__c;
                    NewEnggInfo.Language_1_Proficiency__c = PrevEnggInfo.Language_1_Proficiency__c;
                    NewEnggInfo.Intrax_Region__c = PrevEnggInfo.Intrax_Region__c;
                    NewEnggInfo.Intrax_Program__c = PrevEnggInfo.Intrax_Program__c;
                    NewEnggInfo.Intrax_Program_Options__c = PrevEnggInfo.Intrax_Program_Options__c;
                    NewEnggInfo.Intrax_Program_Category__c = PrevEnggInfo.Intrax_Program_Category__c;
                    //NewEnggInfo.Intrax_Id__c = PrevEnggInfo.Intrax_Id__c;
                    NewEnggInfo.Intrax_Center__c = PrevEnggInfo.Intrax_Center__c;
                    NewEnggInfo.Interests_Top__c = PrevEnggInfo.Interests_Top__c;
                    NewEnggInfo.Interests_Hobbies__c = PrevEnggInfo.Interests_Hobbies__c;
                    NewEnggInfo.Interests_Hobbies_Description__c = PrevEnggInfo.Interests_Hobbies_Description__c;
                    NewEnggInfo.Interest_Sports__c = PrevEnggInfo.Interest_Sports__c;
                    NewEnggInfo.Interest_Fine_Arts__c = PrevEnggInfo.Interest_Fine_Arts__c;
                    NewEnggInfo.Int_Org_Funding__c = PrevEnggInfo.Int_Org_Funding__c;
                    NewEnggInfo.Insurance_Provider__c = PrevEnggInfo.Insurance_Provider__c;
                    NewEnggInfo.Insurance_Individual_Policy_ID__c = PrevEnggInfo.Insurance_Individual_Policy_ID__c;
                    NewEnggInfo.Insurance_Group_Policy_ID__c = PrevEnggInfo.Insurance_Group_Policy_ID__c;
                    NewEnggInfo.Health_Info_Review_Date__c = PrevEnggInfo.Health_Info_Review_Date__c;
                    NewEnggInfo.Graduation_Date__c = PrevEnggInfo.Graduation_Date__c;
                    NewEnggInfo.Grade_Level__c = PrevEnggInfo.Grade_Level__c;
                    NewEnggInfo.Gender__c = PrevEnggInfo.Gender__c;
                    NewEnggInfo.Functional_Areas__c = PrevEnggInfo.Functional_Areas__c;
                    NewEnggInfo.Functional_Areas_Other__c = PrevEnggInfo.Functional_Areas_Other__c;
                    NewEnggInfo.Flight_booking_needed__c = PrevEnggInfo.Flight_booking_needed__c;
                    NewEnggInfo.Flexible_Location__c = PrevEnggInfo.Flexible_Location__c;
                    NewEnggInfo.Flexible_Dates__c = PrevEnggInfo.Flexible_Dates__c;
                    NewEnggInfo.Final_Program_Evaluation__c = PrevEnggInfo.Final_Program_Evaluation__c;
                    NewEnggInfo.Extension_Geo_Pref_Indicator__c = PrevEnggInfo.Extension_Geo_Pref_Indicator__c;
                    NewEnggInfo.Extension_Geo_Pref_Detail__c = PrevEnggInfo.Extension_Geo_Pref_Detail__c;
                    NewEnggInfo.Experience_Summary__c = PrevEnggInfo.Experience_Summary__c;
                    NewEnggInfo.Engagement_Country__c = PrevEnggInfo.Engagement_Country__c;
                    NewEnggInfo.Emergency_Contact_Received__c = PrevEnggInfo.Emergency_Contact_Received__c;
                    NewEnggInfo.Eligibility_Document_Accepted__c = PrevEnggInfo.Eligibility_Document_Accepted__c;
                    NewEnggInfo.Education_Program_Type__c = PrevEnggInfo.Education_Program_Type__c;
                    NewEnggInfo.Driving_Transmission__c = PrevEnggInfo.Driving_Transmission__c;
                    NewEnggInfo.Driving_Snow_Experience__c = PrevEnggInfo.Driving_Snow_Experience__c;
                    NewEnggInfo.Driving_Comfort_Children__c = PrevEnggInfo.Driving_Comfort_Children__c;
                    NewEnggInfo.Drivers_wChildren_Indicated__c = PrevEnggInfo.Drivers_wChildren_Indicated__c;
                    NewEnggInfo.Drivers_US_Licence_Indicated__c = PrevEnggInfo.Drivers_US_Licence_Indicated__c;
                    NewEnggInfo.Drivers_Licence_Indicated__c = PrevEnggInfo.Drivers_Licence_Indicated__c;
                    NewEnggInfo.Drivers_Accident_Indicated__c = PrevEnggInfo.Drivers_Accident_Indicated__c;
                    NewEnggInfo.Drivers_Accident_Detail__c = PrevEnggInfo.Drivers_Accident_Detail__c;
                    NewEnggInfo.Double_Placement_Indicated__c = PrevEnggInfo.Double_Placement_Indicated__c;
                    NewEnggInfo.Description__c = PrevEnggInfo.Description__c;
                    NewEnggInfo.Departure_Trip_Needed__c = PrevEnggInfo.Departure_Trip_Needed__c;
                    NewEnggInfo.Departing_City__c = PrevEnggInfo.Departing_City__c;
                    NewEnggInfo.Current_Accommodation_State__c = PrevEnggInfo.Current_Accommodation_State__c;
                    NewEnggInfo.Countries_of_Interest__c = PrevEnggInfo.Countries_of_Interest__c;
                    NewEnggInfo.Compensation_Type__c = PrevEnggInfo.Compensation_Type__c;
                    NewEnggInfo.Class_8__c = PrevEnggInfo.Class_8__c;
                    NewEnggInfo.Class_7__c = PrevEnggInfo.Class_7__c;
                    NewEnggInfo.Class_6__c = PrevEnggInfo.Class_6__c;
                    NewEnggInfo.Class_5__c = PrevEnggInfo.Class_5__c;
                    NewEnggInfo.Class_4__c = PrevEnggInfo.Class_4__c;
                    NewEnggInfo.Class_3__c = PrevEnggInfo.Class_3__c;
                    NewEnggInfo.Class_2__c = PrevEnggInfo.Class_2__c;
                    NewEnggInfo.Class_1__c = PrevEnggInfo.Class_1__c;
                    NewEnggInfo.Children_Special_Needs_Care__c = PrevEnggInfo.Children_Special_Needs_Care__c;
                    NewEnggInfo.Children_Comfortable_Number__c = PrevEnggInfo.Children_Comfortable_Number__c;
                    NewEnggInfo.Children_Comfortable_Ages__c = PrevEnggInfo.Children_Comfortable_Ages__c;
                    NewEnggInfo.Center_Disclosure_Accepted__c = PrevEnggInfo.Center_Disclosure_Accepted__c;
                    NewEnggInfo.Attitude_Rating__c = PrevEnggInfo.Attitude_Rating__c;
                    NewEnggInfo.Arrival_Trip_Needed__c = PrevEnggInfo.Arrival_Trip_Needed__c;
                    //NewEnggInfo.Age_At_Program_Start__c = PrevEnggInfo.Age_At_Program_Start__c;
                    NewEnggInfo.Actual_Arrival__c = PrevEnggInfo.Actual_Arrival__c;
                    //NewEnggInfo.Account_Owner_Full_Name__c = PrevEnggInfo.Account_Owner_Full_Name__c;
                    NewEnggInfo.Account_Id__c = PrevEnggInfo.Account_Id__c;
                                        
                    
                    if(SelmatchEndDate != NULL && SelmatchEndDate[0].End_Date__c != NULL)
                    {
                        NewEnggInfo.Engagement_Start__c = SelmatchEndDate[0].End_Date__c.addDays(1); 
                    }
                //}
                
                update NewEnggInfo;
                
            }
            
    }      */
    
}