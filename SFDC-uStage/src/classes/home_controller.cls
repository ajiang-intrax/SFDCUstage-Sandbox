public with sharing class home_controller {
    
    public boolean avoid_callouts;
    
    public String userAgentCheck{get;set;}
    public String UserInterests{get;set;} 
    public String userProfileName{get;set;}
    public List<Applicant_Info__c> ApplicantInfoList{get;set;}
    public Applicant_Info__c AppInfo{get;set;}
    public map<String, Boolean> AllowExtendMap{get;set;}
    public map<String, Boolean> AllowRenewMap{get;set;}
    public map<String, Boolean> AllowRematchMap{get;set;}
    public String buttonClass{get;set;}
    public Match__c matchConf{get;set;}
    public List<Match__c> OrigMatchList{get;set;}
    public Match__c OrigConfMatch{get;set;}
    public list<Match__c> withdrawnMatchList{get;set;}
    public Match__c withdrawnMatch{get;set;}
    public Person_Info__c PersonInfo{get;set;}
    public Applicant_Info__c currentApp{get;set;}    
    
    public List<Selection__c> selectionList{get;set;}
    public List<Selection__c> selectionListInactive{get;set;}
    public Match__c confMatch{get;set;}
    //public Map<string,integer> hoursnew{get;set;}
    public decimal DaysDue{get;set;}
    public Integer MatchRequestExpiration{get;set;}
    
    public List<Member__c> HostAccMemberList{get;set;}
    public Member__c HostAccMember{get;set;}
    public Date dToday { get { return System.today(); }}    
    public String URLAux;
    public map<String, String> returnURLMap {get;set;}
    set<Id> poistionset=new set<Id>();
    public list<Position__c> Positionlst{get;set;}
    public User_Profile__c currentUserProf{get;set;}
    public list<Match__c> matchList{get;set;}
    public string msgDisplay{get;set;}
    //Get User TimeZone
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 *3600 *24.0);
    }}
    
    public home_controller(){
        
        URLAux = ApexPages.currentPage().getUrl();
        msgDisplay = ApexPages.currentPage().getParameters().get('msgDisplay');
        AllowExtendMap = new  map<String, Boolean>();
        AllowRenewMap = new  map<String, Boolean>();
        AllowRematchMap = new map<String,boolean>();
        AppInfo = new Applicant_Info__c();
        disControlLen=true;
        avoid_callouts = false;
        
        ApplicantInfoList = [Select a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
            a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Submitted__c, a.Study_Time__c, a.Street__c, a.State__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, 
            a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
            a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Accommodation_Price_Range__c, a.Arrival_Time__c, a.Health_Needs_Indicated__c,
            a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Points_of_Interest__c, 
            a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, a.Opportunity_Name__c, a.Nearest_City__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c,a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.IsDeleted, a.Intrax_Program_Options__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Government_Assistence_Indicated__c, a.GPA__c, a.GPA_Self_Reported__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, 
            a.Exchange_Agency_Employer_Name__c, a.Intrax_Program__c, a.Terms_Accepted__c, a.Program_Start_Opinion__c, a.Arriving_Date__c, a.Arriving_Time__c, a.Carrier__c, a.Carrier_Number__c, a.Intrax_Accommodations__c, a.Flexible_Dates__c,
            a.Entity_Id__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c,a.Country_of_Interest__c, a.English_Teach_Name__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c,
            a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Country_of_Birth__c,a.Visa_Type__c, a.How_Heard__c,a.How_Heard_Detail__c,a.How_Heard_Other__c, a.Engagement_End__c, a.Smoker_Student__c, a.Health_Needs_Description__c,
            a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c, a.Questions__c, a.Casper_Id__c,a.Visa_Category__c, a.Program_Start__c, a.Study_Weeks__c, a.Accommodation_Preference__c, a.Program_Selector__c,
            a.Daily_Meal_Commitment__c, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.CreatedById, 
            a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.Children_Enrolled__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Intrax_Center__c,
            a.Bedrooms__c, a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.RecordType.Name, a.IsVisaDocumentPageSubmitted__c,Intrax_Region__c,
            a.Citizenship__c, a.Attendance_Problems__c, a.Allergies_Other_Partner__c,a.Allergies_Other_desc__c,a.Attendance_Problems_Description__c, a.Application_Stage__c, a.Application_Level__c, a.Allergies_from_Partner__c,
            a.Allergies_from_Applicant__c, a.Allergies_Indicated__c, a.Airport__c, a.Account__c, a.Academic_Years_Completed__c,a.School_Name_SOR__c, a.Primary_Activity__c, a.Experience_Complete__c,
            a.Functional_Areas__c, a.Position_Types__c, a.Service_Level__c, a.Projects_of_Interest__c, a.Location_Preference_1__c, a.Location_Preference_2__c, a.Location_Preference_3__c, SYS_Allow_Cloning__c,
            Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,a.Extension_Length__c,a.Engagement__r.SEVIS_ID__c,
            a.Application_Type__c, a.Engagement__c,a.Engagement__r.Name, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c,a.Engagement__r.Placement_Status__c ,a.Extension_Au_Pair_Agreed__c, a.Engagement__r.Interview_Availability__c, Engagement__r.OwnerId,
            a.Position__c, a.Engagement__r.Arrival_PNR_Number__c, a.Engagement__r.Arrival_Trip_URL__c, a.Engagement__r.Dep_PNR_number__c, a.Engagement__r.Departure_Trip_URL__c, a.Engagement__r.Engagement_End__c, a.Engagement__r.Flight_booking_needed__c,
            Account__r.LastName, Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,Account__r.BillingCountry,Account__r.FirstName, Engagement__r.Departure_Request_Deadline__c, Engagement__r.Profile_Update_Required__c,Engagement__r.Engagement_Type__c,
            a.Intrax_Program_Category__c,a.Location_of_Interest__c,a.CreatedBy__c, a.PageStatus_Complete__c, a.PageStatus_Started__c, a.Account__r.OwnerId                              
            From Applicant_Info__c a
            where a.CreatedBy__c =: UserInfo.getUserId() AND a.Intrax_Program__c = 'AuPairCare' AND Application_Stage__c != 'Cancelled' order by a.CreatedDate DESC,a.Application_Type__c DESC];
    
        buildAllowMapExtension();
        
        matchConf = new Match__c();
        OrigConfMatch = new Match__c();
        OrigMatchList = new List<Match__c>();
        currentApp = new Applicant_Info__c();
        selectionList = new List<Selection__c>();
        selectionListInactive = new List<Selection__c>();
        confMatch = new Match__c();
        
        HostAccMemberList = new List<Member__c>();
        HostAccMember = new Member__c();
        
        list<User_Profile__c> Userlist = new list<User_Profile__c>();
        currentUserProf = new User_Profile__c();
         
        
        if(ApplicantInfoList!=null && ApplicantInfoList.size()>0){
            currentApp = ApplicantInfoList[0];
            system.debug('debug:::positionRecord'+currentApp.Position__c);
            //system.debug('debug:::ApplicantInfoList'+ApplicantInfoList);
            if(currentApp.Type__c == 'Host Family' && ApplicantInfoList[0].Position__c!=null){
                matchList = [Select Id, Match_Type__c,Host_Account__c,Request_Notes__c,offer_status__c,Engagement__c, City__c,Start_Date__c, End_Date__c, Position_Name__c, 
                             Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c,Airport_code__c,Engagement__r.In_Country__c,
                             Engagement__r.Infant_Specialized_Indicated__c,RecordType.Name,Engagement__r.Gender__c, Participant_Id__r.Name,
                             Engagement__r.Engagement_end__c,Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                             Infant_Specialized_Training__c, Position_Name__r.Host_Company_Id__c,Participant_Id__c,Position_Name__r.Host_Company_Id__r.LastName,
                             Position_Name__r.Host_Company_Id__r.Gender__pc,Position_Name__r.Host_Company_Id__r.FirstName,
                             Position_Name__r.Host_Company_Id__r.PersonMailingStreet,Position_Name__r.Host_Company_Id__r.PersonMailingCity,
                             Position_Name__r.Host_Company_Id__r.PersonMailingState,Position_Name__r.Host_Company_Id__r.Phone,HF_Arrival_Date__c,
                             Position_Name__r.Host_Company_Id__r.Skype__c,Arrival_Date__c,Match_Date__c,Request_Expiration__c, Hide_from_PT__c, Hide_from_Host__c
                             from Match__c 
                             WHERE Position_Name__c =: ApplicantInfoList[0].Position__c AND 
                                   Status__c != 'Withdrawn' 
                             ORDER BY CreatedDate DESC];  
            }else if(ApplicantInfoList[0].Engagement__c != null){
                matchList = [Select Id, Match_Type__c,Host_Account__c,Request_Notes__c,Engagement__r.Account_Id__r.Name,Position_Name__r.Host_Company_Id__r.Name,
                             Position_Name__r.Host_Company_Id__r.BillingCity,offer_status__c,Engagement__c, City__c,Start_Date__c, 
                             End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.In_Country__c, Engagement__r.Engagement_Start__c,
                             Engagement__r.Engagement_end__c,Engagement__r.Under_2_Total_Hours__c,Participant_Id__c,Participant_Id__r.Legal_Residence__pc,
                             Status__c,Airport_code__c,Engagement__r.Infant_Specialized_Indicated__c,RecordType.Name,Participant_Id__r.Name,
                             Infant_Specialized_Training__c, Position_Name__r.Host_Company_Id__c,Position_Name__r.Host_Company_Id__r.LastName,
                             Position_Name__r.Host_Company_Id__r.Gender__pc,Position_Name__r.Host_Company_Id__r.FirstName,Request_Expiration__c,
                             Position_Name__r.Host_Company_Id__r.PersonMailingStreet,Position_Name__r.Host_Company_Id__r.PersonMailingCity,
                             Position_Name__r.Host_Company_Id__r.PersonMailingState,Position_Name__r.Host_Company_Id__r.Phone, Hide_from_PT__c, Hide_from_Host__c,
                             Position_Name__r.Host_Company_Id__r.Skype__c,Arrival_Date__c,Match_Date__c,HF_Arrival_Date__c 
                             from Match__c 
                             WHERE Engagement__c =: ApplicantInfoList[0].Engagement__c 
                             AND Intrax_Program__c = 'AuPairCare'
                             AND status__c not in ('Withdrawn','Ended Early')
                             //AND   Status__c != 'Withdrawn' AND Status__c != 'Ended Early' 
                             ORDER BY CreatedDate DESC];
                             
                withdrawnMatchList = [Select Id, Match_Type__c,Host_Account__c,Request_Notes__c,Engagement__r.Account_Id__r.Name,Position_Name__r.Host_Company_Id__r.Name,
                             Position_Name__r.Host_Company_Id__r.BillingCity,offer_status__c,Engagement__c, City__c,Start_Date__c, 
                             End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.In_Country__c, Engagement__r.Engagement_Start__c,
                             Engagement__r.Engagement_end__c,Engagement__r.Under_2_Total_Hours__c,Participant_Id__c,Participant_Id__r.Legal_Residence__pc,
                             Status__c,Airport_code__c,Engagement__r.Infant_Specialized_Indicated__c,RecordType.Name,Participant_Id__r.Name,
                             Infant_Specialized_Training__c, Position_Name__r.Host_Company_Id__c,Position_Name__r.Host_Company_Id__r.LastName,
                             Position_Name__r.Host_Company_Id__r.Gender__pc,Position_Name__r.Host_Company_Id__r.FirstName,Request_Expiration__c,
                             Position_Name__r.Host_Company_Id__r.PersonMailingStreet,Position_Name__r.Host_Company_Id__r.PersonMailingCity,
                             Position_Name__r.Host_Company_Id__r.PersonMailingState,Position_Name__r.Host_Company_Id__r.Phone, Hide_from_PT__c, Hide_from_Host__c,
                             Position_Name__r.Host_Company_Id__r.Skype__c,Arrival_Date__c,Match_Date__c,HF_Arrival_Date__c 
                             from Match__c 
                             WHERE Engagement__c =: ApplicantInfoList[0].Engagement__c 
                             AND   Status__c = 'Withdrawn'
                             ORDER BY CreatedDate DESC];
                
                selectionList = [SELECT Id, Position__r.Host_Company_Id__r.Gender__pc,Position__r.Gender_Preference__c,Position__c,Name, Engagement__c, Interview_End_Date__c, Status__c,Position__r.Host_Company_Id__r.LastName,Position__r.Host_Company_Id__r.PersonEmail,Position__r.Host_Company_Id__r.phone,Position__r.Host_Company_Id__r.Skype_ID__pc,Position__r.Host_Company_Id__r.Birth_City__pc,Position__r.Host_Company_Id__r.Citizenship__pc,Position__r.Host_Company_Id__r.billingcity,Position__r.Host_Company_Id__r.billingcountry,Position__r.Host_Company_Id__r.personmailingstate FROM Selection__c WHERE Engagement__c=:ApplicantInfoList[0].Engagement__c AND Status__c='Active' order by Interview_End_Date__c ASC];
                //system.debug('debug::selectionList=='+selectionList);
                selectionListInactive = [SELECT Id,Position__r.Host_Company_Id__r.Gender__pc,Position__r.Gender_Preference__c,Position__c,Name,Engagement__c, Interview_End_Date__c, Status__c,Position__r.Host_Company_Id__r.LastName,Position__r.Host_Company_Id__r.PersonEmail,Position__r.Host_Company_Id__r.phone,Position__r.Host_Company_Id__r.Skype_ID__pc,Position__r.Host_Company_Id__r.Birth_City__pc,Position__r.Host_Company_Id__r.Citizenship__pc,Position__r.Host_Company_Id__r.billingcity,Position__r.Host_Company_Id__r.billingcountry FROM Selection__c WHERE Engagement__c=:ApplicantInfoList[0].Engagement__c AND Status__c='InActive' order by Interview_End_Date__c ASC];
                system.debug('debug::selectionListInactive=='+selectionListInactive);
                
                Userlist =  [Select Id, User__c, Area_Profile__c, OwnerId, User__r.Name, User__r.Phone, User__r.Email, User__r.FirstName, User__r.Username,
                    User__r.Contact.Name, User__r.Contact.Phone, User__r.Contact.Email, User_Email__c, Area_Profile__r.Name, Area_Profile__r.Educational_Institution_1_URL__c, Area_Profile__r.Educational_Institution_2_URL__c, Area_Profile__r.Educational_Institution_3_URL__c,
                    Area_Profile__r.Educational_Institution_1__c, Area_Profile__r.Educational_Institution_2__c, Area_Profile__r.Educational_Institution_3__c, Area_Profile__r.Climate__c, Area_Profile__r.Description__c, Area_Profile__r.APC_Field_Region__c
                    From User_Profile__c
                    where User__c =: currentApp.Engagement__r.OwnerId]; 
            }
            
            //if(matchList!=null && matchList.size()>0 && matchList[0].End_Date__c != null && matchList[0].Status__c == 'Confirmed')
            if(matchList!=null && matchList.size()>0 && matchList[0].Status__c != 'Withdrawn'){
                matchConf = matchList[0];
                                
                if(currentApp.Type__c == 'Host Family' && matchConf.Position_Name__r.Host_Company_Id__c!=null)   
                	OrigmatchList = [Select Id, Match_Type__c,Host_Account__c,Request_Notes__c,offer_status__c,Engagement__c, City__c,Start_Date__c, End_Date__c, Position_Name__c, 
                             Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c,Airport_code__c,Engagement__r.In_Country__c,
                             Engagement__r.Infant_Specialized_Indicated__c,RecordType.Name,Engagement__r.Gender__c, Participant_Id__r.Name,
                             Engagement__r.Engagement_end__c,Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                             Infant_Specialized_Training__c, Position_Name__r.Host_Company_Id__c,Participant_Id__c,Position_Name__r.Host_Company_Id__r.LastName,
                             Position_Name__r.Host_Company_Id__r.Gender__pc,Position_Name__r.Host_Company_Id__r.FirstName,
                             Position_Name__r.Host_Company_Id__r.PersonMailingStreet,Position_Name__r.Host_Company_Id__r.PersonMailingCity,
                             Position_Name__r.Host_Company_Id__r.PersonMailingState,Position_Name__r.Host_Company_Id__r.Phone,HF_Arrival_Date__c,
                             Position_Name__r.Host_Company_Id__r.Skype__c,Arrival_Date__c,Match_Date__c,Request_Expiration__c, Hide_from_PT__c, Hide_from_Host__c
                             from Match__c 
                             WHERE Host_Account__c =: matchConf.Position_Name__r.Host_Company_Id__c AND 
                                   (Status__c = 'Confirmed' OR Status__c = 'Completed') 
                             ORDER BY CreatedDate DESC LIMIT 1];
                
                if(currentApp.Type__c == 'Participant' && matchConf.Participant_Id__c!=null)   
                	OrigmatchList = [Select Id, Match_Type__c,Host_Account__c,Request_Notes__c,offer_status__c,Engagement__c, City__c,Start_Date__c, End_Date__c, Position_Name__c, 
                             Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c,Airport_code__c,Engagement__r.In_Country__c,
                             Engagement__r.Infant_Specialized_Indicated__c,RecordType.Name,Engagement__r.Gender__c, Participant_Id__r.Name,
                             Engagement__r.Engagement_end__c,Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                             Infant_Specialized_Training__c, Position_Name__r.Host_Company_Id__c,Participant_Id__c,Position_Name__r.Host_Company_Id__r.LastName,
                             Position_Name__r.Host_Company_Id__r.Gender__pc,Position_Name__r.Host_Company_Id__r.FirstName,
                             Position_Name__r.Host_Company_Id__r.PersonMailingStreet,Position_Name__r.Host_Company_Id__r.PersonMailingCity,
                             Position_Name__r.Host_Company_Id__r.PersonMailingState,Position_Name__r.Host_Company_Id__r.Phone,HF_Arrival_Date__c,
                             Position_Name__r.Host_Company_Id__r.Skype__c,Arrival_Date__c,Match_Date__c,Request_Expiration__c, Hide_from_PT__c, Hide_from_Host__c
                             from Match__c 
                             WHERE Participant_Id__c =: matchConf.Participant_Id__c AND 
                                   (Status__c = 'Confirmed' OR Status__c = 'Completed') 
                             ORDER BY CreatedDate DESC LIMIT 1];
                
                
                if(OrigmatchList!=null && OrigmatchList.size()>0)                    
                    	OrigConfMatch = OrigmatchList[0];
                }
            
            system.debug('debug:::OrigConfMatch'+OrigConfMatch);
            
            if(withdrawnMatchList != null && withdrawnMatchList.size() > 0){                
                withdrawnMatch = withdrawnMatchList[0];
            }
            
            system.debug('debug:::matchConf'+matchConf);
            if(Userlist!=null && Userlist.size()>0){
                currentUserProf = Userlist[0];
            }
            
            if(matchList!=null && matchList.size()>0 && (matchList[0].Status__c == 'Confirmed')){
                confMatch = matchList[0];
                if(confMatch!=null && confMatch.Position_Name__c!=null && confMatch.Position_Name__r.Host_Company_Id__c!=null){                 
                    HostAccMemberList = [SELECT Id,Name,First_Name__c, Last_Name__c, Phone__c,Skype_Id__c,Role__c,Account_Name__c FROM Member__c WHERE Account_Name__c=:confMatch.Position_Name__r.Host_Company_Id__c AND Role__c='Spouse or Partner' LIMIT 1];                 
                    system.debug('@@@@@confmatch HostAccMemberList: ' +HostAccMemberList.size());
                    if(HostAccMemberList!=null && HostAccMemberList.size()>0){
                        HostAccMember = HostAccMemberList[0];                       
                    }
                    system.debug('@@@@@match: ' + confMatch);
                }
            }
            
        }
        
        if((URLAux.contains('/apex/apc_ap_interviews') ||URLAux.contains('/apex/apc_ap_home'))){
            If(selectionList.size()>0){
                system.debug('@@@@@selectionList: ' + selectionList);
                for(Selection__c ac: selectionList){
                    poistionset.add(ac.position__c);
                }
            }
            If(selectionListInactive.size()>0){
                for(Selection__c ac: selectionListInactive){
                    poistionset.add(ac.position__c);
                }
            }
            Positionlst=[select id,Intrax_Program__c from Position__c where id in:poistionset];
            system.debug('debug::Positionlst---'+Positionlst); 
            If(Positionlst.size()>0){
                returnURLMap= aws_controller.getParticipantPhotoList(Positionlst);
                system.debug('debug::returnURLMap---'+returnURLMap);
            }
        }
        /*
if(matchConf !=null && matchConf.Request_Expiration__c != null && matchConf.Request_Expiration__c.getTime() > System.Now().getTime()){
decimal Hours = decimal.valueOf(matchConf.Request_Expiration__c.getTime()- System.Now().getTime());
MatchRequestExpiration=integer.valueOf(Hours/(1000*60*60));
system.debug('$$$ Hours:' + Hours);
system.debug('$$$ matchConf.Request_Expiration__c.getTime()==' + matchConf.Request_Expiration__c.getTime());
system.debug('$$$ System.Now().getTime()==:' + System.Now().getTime());

//decimal Hours = decimal.valueOf(matchConf.End_Date__c - System.Now().getTime());
//hoursnew.put(matchConf.id,integer.valueOf(Hours/(1000*60*60)));
//APC_Program_Settings__c apcconstant = APC_Program_Settings__c.getOrgDefaults();
//MatchRequestExpiration=integer.valueOf(apcconstant.PT_Match_Request_Expiration_Hours__c);
//system.debug('debug::apcconstant=='+apcconstant.PT_Match_Request_Expiration_Hours__c);
//Date startDate = matchConf.End_Date__c;
//DaysDue = decimal.valueOf((system.Today().daysBetween(startDate))*24);
system.debug('$$$ Match Hours:' + DaysDue);
}
else{
MatchRequestExpiration=0;
//DaysDue=0;
}*/
            
        
        /*
        system.debug('@@@@@ enter getOpportunityProductCart()'); 
         //B-02654 Jose : Retreaving APC Products fro Travel Payment
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_travel_payment')){
            //paymentController = new apc_hf_payment_controller(this);
            getOpportunityProductCart();
        }
        */
    }
    
    //Past Interviews Pagging
    List<PastInterviewWrapper> PastSelections {get;set;}
    public string pageNumberSelected{get;set;}
    public Integer totalRecords{get; set;}  
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,Position__r.Host_Company_Id__r.personmailingstate ,Position__r.Host_Company_Id__r.Gender__pc, Position__r.Gender_Preference__c,Position__c,Name,Engagement__c, Interview_End_Date__c, Status__c,Position__r.Host_Company_Id__r.LastName,Position__r.Host_Company_Id__r.PersonEmail,Position__r.Host_Company_Id__r.phone,Position__r.Host_Company_Id__r.Skype_ID__pc,Position__r.Host_Company_Id__r.Birth_City__pc,Position__r.Host_Company_Id__r.Citizenship__pc,Position__r.Host_Company_Id__r.billingcity,Position__r.Host_Company_Id__r.billingcountry FROM Selection__c WHERE Engagement__c=:ApplicantInfoList[0].Engagement__c AND Status__c='InActive']));
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
        returnURLmap = aws_controller.getParticipantPhotoList((list<Position__c>) con.getRecords());
    }
    
    /*
    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }*/
    
     // returns the previous page of records
     public void previous() {
         con.previous();
         pageNumberSelected = string.valueOf(con.getPageNumber());
         returnURLmap = aws_controller.getParticipantPhotoList((list<Position__c>) con.getRecords());
     }

     // returns the next page of records
     public void next() {
         con.next();
         pageNumberSelected = string.valueOf(con.getPageNumber());
         returnURLmap = aws_controller.getParticipantPhotoList((list<Position__c>) con.getRecords());
     }
    
    // End of PaggingWrapper
    
    public PageReference DeclineMatchOffer(){  
        System.debug('--------decline matchConf ID'+matchConf.Id);
        if(matchConf!=null && matchConf.Id!=null){
            matchConf.Offer_Status__c = 'Declined'; 
            matchConf.Status__c = 'Withdrawn'; 
            update matchConf;            
        }
        PageReference p = Page.apc_ap_home;
        p.setRedirect(true);
        return p;
    }
    
    public string getReturnURL(){
        String sURL = '';
        if(URLAux != null){              
            if(URLAux.contains('/apex/apc_ap_home') || URLAux.contains('/apex/apc_ap_interviews') || URLAux.contains('/apex/apc_ap_match_request')){
               //if(currentApp!= null && currentApp.Intrax_Program__c ==  'AuPairCare'){
               if((!avoid_callouts || avoid_callouts == null) && matchConf!=null && matchConf.Id!=null && matchConf.Position_Name__c!=null && matchConf.Position_Name__r.Host_Company_Id__c!=null){     
                   list<Intrax_Program_Upload__c> ipulits = getHostFamilyProfilePhoto();
                   
                   list<String> myGUIDs = new list<String>();
                   if(ipulits!=null && ipulits.size()>0){ 
                       for(Intrax_Program_Upload__c ipu : ipulits){ 
                            myGUIDs.add(ipu.Document_GUID__c);
                       }
                       if(myGUIDs!=null && myGUIDs.size()>0 && !Test.isRunningTest()){
                        sURL = IUtilities.getPhotoListThumb(myGUIDs)[0];
                       }
                       system.debug('@@@@@ sURL: ' + sURL); 
                   }                  
               }
            }
        }
        return sURL;
    }
    
    public List<Intrax_Program_Upload__c> getHostFamilyProfilePhoto(){      
        List<Intrax_Program_Upload__c> ipuList = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Account__c =: matchConf.Position_Name__r.Host_Company_Id__c and d.Document_Type__C IN ('Participant-Photo') LIMIT 1];
        
        if(ipuList!=null && ipuList.size()>0){
            return ipuList;
        }
        else
            return null;
    }
    
    public boolean getIsEngProgReady(){
        boolean ProgReady = false;
        if(currentApp!=null && currentApp.Engagement__c!=null){
            if(currentApp.Engagement__r.Status__c=='Program Ready'){
                ProgReady = true;
            }
        }
        return ProgReady;
    }
    
    public boolean getcheckForOnProgramInterviewing(){
        Applicant_info__c appInfoOld = new Applicant_Info__c();
        List<Match__c> mList = new List<Match__c>();
        boolean returnResult = false;
        //current should be interviewing for renewal application AND old should be accepted app and on program(with conf match) .
        if(ApplicantInfoList!=null && ApplicantInfoList.size()>1){//user should have 2 applications
            if(currentApp!=null && currentApp.Application_Type__c == 'Renewal' && (currentApp.Engagement__r.Status__c=='Processing' || currentApp.Engagement__r.Status__c=='Program Ready')){
                for(Applicant_Info__c app:applicantInfoList){
                    if(app.application_type__c == 'Original' && app.application_level__c =='Main' && app.application_stage__c=='Accepted' && app.Engagement__c!=null && app.Engagement__r.Status__c=='On Program'){
                        appInfoOld = app;
                        break;
                    }
                }
                if(appInfoOld!=null && appInfoOld.Id!=null && appInfoOld.Engagement__c!=null){
                    mList = [Select Id, Match_Type__c, Engagement__c, City__c,Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c, Position_Name__r.Host_Company_Id__c,Position_Name__r.Host_Company_Id__r.LastName,Position_Name__r.Host_Company_Id__r.Gender__pc,Position_Name__r.Host_Company_Id__r.FirstName,Position_Name__r.Host_Company_Id__r.PersonMailingStreet,Position_Name__r.Host_Company_Id__r.PersonMailingCity,Position_Name__r.Host_Company_Id__r.PersonMailingState,Position_Name__r.Host_Company_Id__r.Phone,Position_Name__r.Host_Company_Id__r.Skype__c from Match__c WHERE Engagement__c =: appInfoOld.Engagement__c AND Status__c='Confirmed' ORDER BY CreatedDate DESC];
                    if(mList!=null && mList.size()>0){
                        returnResult=true;
                    }
                }
                                
            }
            
        }
        return returnResult;        
    }
    
    public boolean getfutureInterviewsExist(){
        integer futureInterviews=0;
        if(selectionList!=null && selectionList.size()>0){
            for(Selection__c s:selectionList){
                //checking for future interviews
                if(s.Interview_End_Date__c > System.now()){
                    futureInterviews++;                 
                }
            }
            if(futureInterviews > 0)
                return true;
            else
                return false;
        }
        else
            return false;
    }
    
    public Applicant_Info__c applicant{get{
    
    if(applicant == null){
        list<Applicant_Info__c> app = [Select a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
            a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Submitted__c, a.Study_Time__c, a.Street__c, a.State__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, 
            a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
            a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Accommodation_Price_Range__c, a.Arrival_Time__c, a.Health_Needs_Indicated__c,
            a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Points_of_Interest__c, 
            a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c,
            a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, a.Opportunity_Name__c, a.Nearest_City__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c,
            a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c,a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.IsDeleted, a.Intrax_Program_Options__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c,
            a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c,
            a.Government_Assistence_Indicated__c, a.GPA__c, a.GPA_Self_Reported__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, 
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
            Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,a.Extension_Length__c, a.Extension_DOS_Fee_Indicated__c,
            a.Application_Type__c, a.Engagement__c, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c, a.Engagement__r.OwnerId, a.Extension_Au_Pair_Agreed__c,
            a.Position__c, a.Engagement__r.Arrival_PNR_Number__c, a.Engagement__r.Arrival_Trip_URL__c, a.Engagement__r.Engagement_End__c, a.Engagement__r.Private_High_School_Indicated__c,
            a.Engagement__r.Requested_Departure_1__c, a.Engagement__r.Requested_Departure_2__c, a.Engagement__r.Requested_Departure_3__c, a.Engagement__r.Departing_City__c,  a.Engagement__r.Flight_booking_needed__c,
            a.Engagement__r.International_Destination_Airport__c,a.Engagement__r.Domestic_Departure_Airport__c, Engagement__r.Owner.Phone, Engagement__r.Departure_Request_Deadline__c 
            From Applicant_Info__c a
            where a.Id =: ApexPages.currentPage().getParameters().get('Id')];
        if(app!=null && app.size()>0){
            applicant = app[0];
            return applicant;
        }else{
            Applicant_Info__c appAux = new Applicant_Info__c(); 
            return appAux;
        }
    }else{
        return applicant;
    }
    
    }
    set;}
    
    public Applicant_Info__c applicantHF{get{
    system.debug('@@@@@inside applicantHF');
    if(applicantHF == null){
        if(ApplicantInfoList!=null && ApplicantInfoList.size()>0){
            list<Match__c> match = [Select Id, Match_Type__c, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Engagement__c =: ApplicantInfoList[0].Engagement__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];  
            system.debug('@@@@@match: ' + match);
            if(match!=null && match.size()>0){
                
                //Retrieve PT Query
                //list<Applicant_Info__c> SelectAPapp = [SELECT Account__r.FirstName, Account__r.LastName, Id, Application_Type__c, CreatedBy__c FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                list<Applicant_Info__c> SelectAPapp = [SELECT Application_Stage__c, Extension_Length__c, Account__r.FirstName, Account__r.LastName, Id,
                Application_Type__c, CreatedBy__c, CreatedDate, LastModifiedDate 
                FROM Applicant_Info__c WHERE Position__c =: match[0].Position_Name__c ORDER BY CreatedDate DESC];
                
                if(SelectAPapp != NULL && SelectAPapp.size() > 0 && SelectAPapp[0].CreatedBy__c != NULL){
                    system.debug('@@@@@applicantHF: '+ SelectAPapp[0]);
                    return SelectAPapp[0];
                }else{
                    Applicant_Info__c appAux = new Applicant_Info__c();
                    return appAux;
                }
            }else{
                Applicant_Info__c appAux = new Applicant_Info__c();
                return appAux;
            }
        }else{
            Applicant_Info__c appAux = new Applicant_Info__c();
            return appAux;
        }
    }else{
        return applicantHF;
    }
    
    }set;} 
    
    public Applicant_Info__c applicantPT{get{
    system.debug('@@@@@inside applicantPT');
    if(applicantPT == null){
        if(ApplicantInfoList!=null && ApplicantInfoList.size()>0){
            list<Match__c> match = [Select Id, Match_Type__c, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Position_Name__c =: ApplicantInfoList[0].Position__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];  
            system.debug('@@@@@match: ' + match);
            if(match!=null && match.size()>0){
                
                //Retrieve PT Query
                //list<Applicant_Info__c> SelectAPapp = [SELECT Account__r.FirstName, Account__r.LastName, Id, Application_Type__c, CreatedBy__c FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                list<Applicant_Info__c> SelectAPapp = [SELECT Application_Stage__c, Account__c, Account__r.FirstName, Account__r.LastName,Account__r.Name, Id,
                Application_Type__c, CreatedBy__c, CreatedDate, LastModifiedDate, Extension_Au_Pair_Agreed__c,Engagement__r.Engagement_End__c 
                FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c ORDER BY CreatedDate DESC];
                
                if(SelectAPapp != NULL && SelectAPapp.size() > 0 && SelectAPapp[0].CreatedBy__c != NULL){
                    system.debug('@@@@@applicantPT: '+ SelectAPapp[0]);
                    return SelectAPapp[0];
                }else{
                    Applicant_Info__c appAux = new Applicant_Info__c();
                    return appAux;
                }
            }else{
                Applicant_Info__c appAux = new Applicant_Info__c();
                return appAux;
            }
        }else{
            Applicant_Info__c appAux = new Applicant_Info__c();
            return appAux;
        }
    }else{
        return applicantPT;
    }
    
    }set;}
    
    public Applicant_Info__c applicantPTnoExtend{get{
    system.debug('@@@@@inside applicantPTnoExtend');
    if(applicantPTnoExtend == null){
        if(ApplicantInfoList!=null && ApplicantInfoList.size()>0){
            list<Match__c> match = [Select Id,Match_Type__c, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Position_Name__c =: ApplicantInfoList[0].Position__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];  
            system.debug('@@@@@match: ' + match);
            if(match!=null && match.size()>0){
                
                //Retrieve PT Query
                //list<Applicant_Info__c> SelectAPapp = [SELECT Account__r.FirstName, Account__r.LastName, Id, Application_Type__c, CreatedBy__c FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c AND Application_Stage__c = 'Accepted' ORDER BY CreatedDate DESC];
                list<Applicant_Info__c> SelectAPapp = [SELECT Application_Stage__c, Account__c, Account__r.FirstName, Account__r.LastName, Id,
                Application_Type__c, CreatedBy__c, CreatedDate, LastModifiedDate 
                FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c ORDER BY CreatedDate DESC];
                
                if(SelectAPapp != NULL && SelectAPapp.size() > 0 && SelectAPapp[0].CreatedBy__c != NULL){
                    system.debug('@@@@@SelectAPapp[0]: '+ SelectAPapp[0]);
                    
                    list<Applicant_Info__c> SelectAPappNoExtend = [SELECT Application_Stage__c, Account__c, Account__r.FirstName, Account__r.LastName, Id,
                    Application_Type__c, CreatedBy__c, CreatedDate, LastModifiedDate 
                    FROM Applicant_Info__c WHERE Account__c =: SelectAPapp[0].Account__c AND Application_Stage__c != 'Cancelled' ORDER BY CreatedDate DESC];
                    
                    if(SelectAPappNoExtend != NULL && SelectAPappNoExtend.size() > 0 && SelectAPappNoExtend[0].CreatedBy__c != NULL){
                        return SelectAPappNoExtend[0];
                    }else{
                        Applicant_Info__c appAux = new Applicant_Info__c();
                        return appAux;
                    }
                    
                }else{
                    Applicant_Info__c appAux = new Applicant_Info__c();
                    return appAux;
                }
            }else{
                Applicant_Info__c appAux = new Applicant_Info__c();
                return appAux;
            }
        }else{
            Applicant_Info__c appAux = new Applicant_Info__c();
            return appAux;
        }
    }else{
        return applicantPTnoExtend;
    }
    
    }set;}  
    
    public String Pt_Photo{get{
        system.debug('@@@@@applicantPT.Id: '+ applicantPT.Id);
        
        list<Intrax_Program_Upload__c> photos = [SELECT Document_GUID__c 
                                                    FROM Intrax_Program_Upload__c 
                                                    WHERE Document_Type__c = 'Participant-Photo' AND Applicant_Info__c =: applicantPT.Id
                                                    limit 1
                                                    ];
        system.debug('@@@@@photos: '+ photos);
        list<String> myGUIDs = new list<String>();
        
        for(Intrax_Program_Upload__c ipu : photos){ 
            myGUIDs.add(ipu.Document_GUID__c);
        }       
        
        if(myGUIDs!=null && myGUIDs.size()>0 && !Test.isRunningTest()){
            if(aws_controller.getPhotoListThumb(myGUIDs)!=null && aws_controller.getPhotoListThumb(myGUIDs).size()>0){
                return aws_controller.getPhotoListThumb(myGUIDs)[0];
            }else{
                return null;
            }
        }else{
            return null;
        }
        
    }set;}
    
    /*
    public User usertest{get{
     
    if(userTest == null){
        list<User> userTestList = [Select Id, Email, Phone, Username, name
            From User
            where id =: applicant.Engagement__r.OwnerId]; 
        if(userTestList!=null && userTestList.size()>0){
            usertest = userTestList[0];
            system.debug('@@@@@usertest.Name: ' + usertest.Name);
            system.debug('@@@@@usertest.Email: ' + usertest.Email);
            system.debug('@@@@@usertest.Phone: ' + usertest.Phone);
            system.debug('@@@@@usertest.Username: ' + usertest.Username);
            return usertest;
        }else{
            User usertestAux = new User(); 
            return usertestAux;
        }
    }else{
        return usertest;
    }
    
    }
    set;}
    */
    
    
    public String photoADUrl{get{
     
        if(photoADUrl == null){
            
            if(userProfAD.id !=null){
                system.debug('@@@@@userProfAD.Id photo: ' + userProfAD.Id);
                if(!Test.isRunningTest()){
                    photoADUrl=aws_controller.getApcManagerPhoto(String.valueOf(userProfAD.Id));
                }
                return photoADUrl;
            }else{
                String photoADUrlAux = 'no picture'; 
                return photoADUrlAux;
            }
        }else{
            return photoADUrl;
        }
        
        }
    set;}
    
    public String photoRMUrl{get{
     
        if(photoRMUrl == null){
            
            if(userProfRM.id !=null){
                system.debug('@@@@@userProfAD.Id photo: ' + userProfRM.Id);
                if(!Test.isRunningTest()){
                    photoRMUrl=aws_controller.getApcManagerPhoto(String.valueOf(userProfRM.Id));
                }
                return photoRMUrl;
            }else{
                String photoADUrlAux = 'no picture'; 
                return photoADUrlAux;
            }
        }else{
            return photoRMUrl;
        }
        
        }
    set;}
    
   
    public Account partnerAcc{get{
     
    if(partnerAcc == null){
        system.debug('@@@@@Inside partnerAcc');
        system.debug('@@@@@applicant.Partner_Intrax_Id__c: ' + applicant.Partner_Intrax_Id__c);
        list<Account> partnerAccList = [Select Id, Name, BillingStreet, BillingPostalCode, BillingCountry, BillingCity, Phone, Intrax_Id__c
            From Account 
            where Intrax_Id__c =: currentApp.Partner_Intrax_Id__c]; 
        if(partnerAccList!=null && partnerAccList.size()>0){
            partnerAcc = partnerAccList[0];
            system.debug('@@@@@partnerAcc.Name: ' + partnerAcc.Name);
            return partnerAcc;
        }else{
            Account partnerAccAux = new Account(); 
            return partnerAccAux;
        }
    }else{
        return partnerAcc;
    }
    
    }
    set;}
    
    //JOSE B-03142  //APC PT Contact Us page
    public User_Profile__c userProfAD{get{
        try{
        if(userProfAD == null){
            system.debug('@@@@@currentApp.OwnerId: ' + currentApp.OwnerId);
            if(currentApp.Account__r.OwnerId!=null && String.valueOf(currentApp.Account__r.OwnerId).left(3) != '00G'){
                list<User_Profile__c> userProfADList = [Select Id, User__c, Area_Profile__c, OwnerId, User_Email__c, User_Name__c, User_Phone__c,
                Area_Profile__r.Name, Area_Profile__r.Educational_Institution_1_URL__c, Area_Profile__r.Educational_Institution_2_URL__c, Area_Profile__r.Educational_Institution_3_URL__c,
                Area_Profile__r.Educational_Institution_1__c, Area_Profile__r.Educational_Institution_2__c, Area_Profile__r.Educational_Institution_3__c,
                Area_Profile__r.Climate__c, Area_Profile__r.Description__c, Area_Profile__r.APC_Field_Region__c
                    From User_Profile__c
                     where User__c =: currentApp.Engagement__r.OwnerId];
                    //where User__c =: currentApp.Account__r.OwnerId]; // D-01966
                if(userProfADList!=null && userProfADList.size()>0){
                    userProfAD = userProfADList[0];
                    return userProfAD;
                }else{
                    User_Profile__c userProfADAux = new User_Profile__c(); 
                    return userProfADAux;
                }
            }else{
                User_Profile__c userProfADAux = new User_Profile__c(); 
                return userProfADAux;
            }
        }else{
            return userProfAD;
        }
        }catch(Exception e){
            system.debug('@@@@@Exception in userProfAD: ' + e);
            User_Profile__c userProfADAux = new User_Profile__c(); 
            return userProfADAux;
        }
    }
    set;}
    
    
    public User_Profile__c userProfRM{get{
        try{
        if(userProfRM == null){
            if(userProfAD.OwnerId != null){
                system.debug('@@@@@userProfAD.OwnerId: ' + userProfAD.OwnerId);
                list<User_Profile__c> userProfRMList = [Select Id, User__c, Area_Profile__c, OwnerId, User_Email__c, User_Name__c, User_Phone__c
                    From User_Profile__c 
                    where User__c =: userProfAD.OwnerId]; 
                if(userProfRMList!=null && userProfRMList.size()>0){
                    userProfRM = userProfRMList[0];
                    return userProfRM;
                }else{
                    User_Profile__c userProfRMAux = new User_Profile__c(); 
                    return userProfRMAux;
                }
            
            }else{
                User_Profile__c userProfRMAux = new User_Profile__c(); 
                return userProfRMAux;
            }
        
        }else{
            return userProfRM;
        }
        }catch(Exception e){
            system.debug('@@@@@Exception in userProfRM: ' + e);
            User_Profile__c userProfRMAux = new User_Profile__c(); 
            return userProfRMAux;
        }
    }
    set;}
    
    
    public String Pt_Photo_acc{get{
        system.debug('@@@@@ Pt_Photo__acc applicantPT.Account__c: '+ applicantPT.Account__c);
        
        list<Intrax_Program_Upload__c> photos = [SELECT Document_GUID__c, Account__c 
                                                    FROM Intrax_Program_Upload__c 
                                                    WHERE Document_Type__c = 'Participant-Photo' AND Account__c =: applicantPT.Account__c
                                                    limit 1
                                                    ];
        //system.debug('@@@@@photos: '+ photos);
        list<String> myGUIDs = new list<String>();
        
        for(Intrax_Program_Upload__c ipu : photos){ 
            myGUIDs.add(ipu.Document_GUID__c);
        }       
        
        if(myGUIDs!=null && myGUIDs.size()>0 && !Test.isRunningTest()){
            if(aws_controller.getPhotoListThumb(myGUIDs)!=null && aws_controller.getPhotoListThumb(myGUIDs).size()>0){
                return aws_controller.getPhotoListThumb(myGUIDs)[0];
            }else{
                return null;
            }
        }else{
            return null;
        }
        
    }set;}
    
     //JOSE B-02827 and B-03142  //APC PT Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Contact_Information__c InsuranceInfo{get{
        
        if(InsuranceInfo == null){
            return apc_portal_utilities.InsuranceInfo();
        
        }else{
            return InsuranceInfo;  
        }
    } 
    set;}
    
    //JOSE B-02827 and B-03142  //APC PT Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Contact_Information__c HQInfo{get{
        if(HQInfo == null){
            return apc_portal_utilities.HQInfo();
        
        }else{
            return HQInfo;
        }
    }
    set;}
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Contact_Information__c EmergencyLine{get{
         if(EmergencyLine == null){
            return apc_portal_utilities.EmergencyLine();
        
        }else{
            return EmergencyLine;
        }
    }
    set;}
    
    public Boolean disControlLen{get;set;}
    
    public PageReference changeDisableLen(){
        system.debug('@@@@@inside changeDisableLen');
        disControlLen = false;
        return null;
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
    
    public PageReference checkLogin()
    {        
        // we dont need to create this queries all the time in different places --> centralized in configuration_controller. 
        // Fow now I have created this as static... @SHANKAR, Do you think we should create an instance of the class instead?? 
        PageReference p;
        User u = configuration_controller.getUserInfo();
        UserInterests = u.User_Interests__c;
        if(u.ProfileId !=null){
            Profile profile = [Select Name from Profile where Id =: u.ProfileId limit 1];
            userProfileName = profile.Name ;    
        }
        //Specific actions / method by audience or program
        if(u.User_Interests__c == 'Hosting an au pair'){
            return configuration_controller.apc_portal_checkLogin('HF');
        }else if(u.User_Interests__c == 'Hosting an au pair'){
            return configuration_controller.apc_portal_checkLogin('PT');
        }else return null;  
    }
    
    public PageReference CreateEOPChildOpp()
    {
        PageReference p = checkLogin();
        //First create the child opportunity "End Of Program" if it doesnot exists.
        Id appId = ApexPages.currentPage().getParameters().get('Id');
        if(appId!=null)
        {
            System.debug('createChildPtOpp');
            List<Applicant_Info__c> appInfoList = 
                [SELECT Id,Opportunity_Name__c,Intrax_Program__c,RecordType.Name,Account__c,Application_Type__c,Account__r.Intacct_Sync_By__c,
                 name,Intrax_Program_Options__c,Type__c,Intrax_Region__c,Country_of_Interest__c,Intrax_Program_Category__c,
                 Service_Level__c,Location_of_Interest__c,CreatedBy__c, CreatedById
                 FROM Applicant_Info__c WHERE id = :appId
                 LIMIT 1];
            if(appInfoList!=null && appInfoList.size()>0)
            {                           
                System.debug('createChildPtOpp of type end of program. applicant details' + appInfoList[0]);
                Opportunity EOPChildOpp = AppTriggerHelper.CreateAppOpp(appInfoList[0],appInfoList[0].Opportunity_Name__c,'USD','End of program');
                System.debug('Child opportunity creation suuccessfull' + EOPChildOpp);
                
                //Also create the Intacct account if it doesnot exist already.
                //Sorry cannot do callout after doing a DML operation.
                /*if(appInfoList[0].account__c !=null && appInfoList[0].Intrax_Program__c == 'AuPairCare' 
                   && appInfoList[0].Type__c == 'Participant')
                {
                    Intacct_Wrapper wrapper= new Intacct_wrapper();
                    List<Intacct__c> parentIntacct = [Select id from Intacct__c 
                                                      where Account__c =:appInfoList[0].account__c and
                                                      Is_Parent__c = true and
                                                      Type__c = 'Create Customer' and
                                                      Intacct_Response__c = 'Success'
                                                      limit 1];
                    //intacct account no present so create it and sync
                    if(parentIntacct.isEmpty())
                    {
                        System.debug('Parent Intacct is not present. Create one and sync');
                        wrapper.CreateIntacctAccnt_Sync(appInfoList[0].account__c);//,'Non-Future');   
                    }
                }*/
            }
        }
        return p;
    }
    
    public void buildAllowMapExtension()
    {
        system.debug('@@@@@ inside buildAllowMapExtension()');
        try{
        
        for(Applicant_Info__c SingleApp:ApplicantInfoList)
        {
            if (SingleApp.Application_Stage__c != 'Cancelled')
            {
                AppInfo = SingleApp;
                break;
            }
        }
        system.debug('***AppInfo***'+AppInfo);
        for(Applicant_Info__c app:ApplicantInfoList)
        {
            system.debug('***app.id***'+app.id);
            system.debug('***AppInfo.id***'+AppInfo.id);
        if(app.id == AppInfo.id)
        {
                Boolean isRenewAllowed = false; 
                Boolean isExtendAllowed = false;    
                Boolean isRematchAllowed = false;
                
                if(app.Type__c == 'Host Family' && app.application_stage__c == 'Accepted')
                {
                    if(app.Position__c != null){
                        list<Match__c> match = [Select Id, Match_Type__c, HF_Arrival_Date__c,Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c from Match__c WHERE Position_Name__c =: app.Position__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];  
                        if(match!=null && match.size()>0 && match[0].End_Date__c != null && match[0].Status__c == 'Confirmed'){
                            
                            system.debug('@@@@@ match[0].Engagement__r.Engagement_Start__c: ' + match[0].Engagement__r.Engagement_Start__c);
                            
                            if(match[0].End_Date__c.addMonths(-6) <= date.today() && (match[0].HF_Arrival_Date__c !=null && date.today()>=match[0].HF_Arrival_Date__c))
                            {
                                system.debug('@@@@@ HF // Meeting timing condition ALLOWED to RENEWALL');
                                system.debug('@@@@@ HF // Extension Qualify Date'+match[0].End_Date__c.addDays(-40));
                                
                                isRenewAllowed = true;      
                                
                                if(match[0].End_Date__c.addDays(-40) >= date.today() )
                                {
                                    list<Applicant_Info__c> SelectAPapp = [SELECT Application_Type__c, CreatedBy__c FROM Applicant_Info__c WHERE Engagement__c =: match[0].Engagement__c 
                                                                           AND Application_Stage__c = 'Accepted' 
                                                                           AND application_type__c = 'Original' 
                                                                           ORDER BY CreatedDate DESC];
                                    if(SelectAPapp != NULL && SelectAPapp.size() > 0 && SelectAPapp[0].CreatedBy__c != NULL)
                                    {
                                        //JOSE- I added Application_Stage__c = 'Working' . We could have multiple Accepted,Canceled "Renewal/Extesion" Apss that they shouldn't stop the Extension process
                                        list<Applicant_Info__c> chkExtensionAP = [SELECT Application_Type__c FROM Applicant_Info__c WHERE CreatedBy__c =:SelectAPapp[0].CreatedBy__c AND Application_Type__c IN ('Extension','Renewal') AND Application_Stage__c = 'Working' ];
                                        if(chkExtensionAP.size() == 0)
                                        {
                                            system.debug('@@@@@ HF // Meeting timing condition ALLOWED to EXTEND');
                                            isExtendAllowed = true;
                                        }
                                    }
                                }
                            }
                        }
                        //AA For Match Complete and Re-Match Case:
                        else if(match!=null && match.size()>0 && match[0].Status__c == 'Completed'){
                        isRenewAllowed = true;  
                        }else if(match!=null && match.size()>0 && match[0].Status__c == 'Ended Early'){
                        isRematchAllowed = true;  
                        }
                    }
                    //AllowExtendMap.put(app.id, true); 
                }
                else if(app.Type__c == 'Participant' && app.application_stage__c == 'Accepted' && app.application_type__c == 'Original')
                {
                    if(app.Engagement__c != null)
                    {
                        list<Match__c> match = [Select Id, Match_Type__c, HF_Arrival_Date__c,Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Position_Name__r.Host_Company_Id__c, Status__c from Match__c WHERE Engagement__c =: app.Engagement__c AND Status__c != 'Withdrawn' ORDER BY CreatedDate DESC];
                        if(match != NULL && match.size() > 0 && match[0].End_Date__c != null && match[0].Status__c == 'Confirmed')
                        {
                            if(match[0].End_Date__c.addMonths(-6) <= date.today() && (match[0].HF_Arrival_Date__c !=null && date.today()>=match[0].HF_Arrival_Date__c))
                            {
                                system.debug('@@@@@ PT // Meeting timing condition ALLOWED to RENEWALL');
                                isRenewAllowed = true;  
                                
                                if(match[0].Position_Name__r.Host_Company_Id__c != NULL)
                                {
                                    //system.debug('@@@@@ match[0].Position_Name__r.Host_Company_Id__c'+match[0].Position_Name__r.Host_Company_Id__c);
                                    list<Applicant_Info__c> HFExtlist = [SELECT Application_Type__c, CreatedBy__c, Application_Stage__c FROM Applicant_Info__c WHERE Account__c =: match[0].Position_Name__r.Host_Company_Id__c AND Application_Stage__c != 'Cancelled' ORDER BY CreatedDate DESC];
                                    
                                    if(HFExtlist != NULL && HFExtlist.size() > 0 && HFExtlist[0].Application_Stage__c == 'Accepted')// && HFExtlist[0].Application_Type__c == 'Original')
                                    {
                                        system.debug('@@@@@ PT // Meeting timing condition ALLOWED to EXTEND');
                                        isExtendAllowed = true;
                                    }
                                }
                            }
                                    
                        }   
                    }
                }
            
                AllowRenewMap.put(app.id, isRenewAllowed);  
                AllowExtendMap.put(app.id, isExtendAllowed);
                AllowRematchMap.put(app.id, isRematchAllowed);
            }else{
                AllowRenewMap.put(app.id, false);   
                AllowExtendMap.put(app.id, false);
                AllowRematchMap.put(app.id,false);
            }
        }// END for() condition
        
        }catch(Exception e){
                system.debug('@@@@@Exception in Home_Controller.buildAllowMapExtension(): ' + e);
        }
    }
    
     public PageReference confirmPtExtension(){
        system.debug('@@@@@inside confirmPtExtension()');
        //Code for actions
        if(ApexPages.currentPage().getParameters().get('conf') == 'true'){
            currentApp.Extension_Au_Pair_Agreed__c = 'Yes';
        }
        //Saving application
        upsert currentApp;
        //Final PageRedirection code
        PageReference p = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        if(ApexPages.currentPage().getParameters().get('idNeeded') != 'false')
            p.getParameters().put('id', currentApp.Id);
        if(ApexPages.currentPage().getParameters().get('reDirectPage') == 'true')
            p.setRedirect(true);
        return p;
     
     }
     
     
    public User user{get{
     
    if(user == null){
        list<User> userList = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        if(userList!=null && userList.size()>0){
            user = userList[0];
            return user;
        }else{
            User userAux = new User(); 
            return userAux;
        }
    }else{
        return user;
    }
    
    }
    set;}
    
    //B-02750 Jose (PT Flight Request)
    public list<String> USairportscode{get{
        if(USairportscode == null){
            system.debug('*****@@@ in getAirportsListUSA()');
            list<Airports__c> airportsList = [Select Name, Airport_Name__c, Country__c from Airports__c WHERE Country__c = 'USA' and AuPairCare__c =true];
            List<String> AirportsUSAAux = new String[airportsList.size()];
            String auxTextAir;
            
            for(integer i=0; i<airportsList.size();i++){
                auxTextAir =  '"' + String.valueOf(airportsList[i].Name) + ' - ' +   String.valueOf(airportsList[i].Airport_Name__c) + ', ' +  String.valueOf(airportsList[i].Country__c + '"');
                AirportsUSAAux[i]=auxTextAir;
            }
            
            system.debug('*****@@@ AirportsUSAAux: ' + AirportsUSAAux);
            
            return AirportsUSAAux;
        
        }else{
            return USairportscode;
        }
    }
    set;}
    
    //B-02750 Jose (PT Flight Request)
    public list<String> NoUSairportscode{get{
        if(NoUSairportscode == null){
            system.debug('*****@@@ in getAirportsListUSA()');
            list<Airports__c> airportsList = [Select Name, Airport_Name__c, Country__c from Airports__c WHERE Country__c != 'USA' /*and AuPairCare__c =true*/];
            List<String> AirportsNoUSAAux = new String[airportsList.size()];
            String auxTextAir;
            
            for(integer i=0; i<airportsList.size();i++){
                auxTextAir =  '"' + String.valueOf(airportsList[i].Name) + ' - ' +   String.valueOf(airportsList[i].Airport_Name__c) + ', ' +  String.valueOf(airportsList[i].Country__c + '"');
                AirportsNoUSAAux[i]=auxTextAir;
            }
            
            system.debug('*****@@@ AirportsNoUSAAux: ' + AirportsNoUSAAux);
            
            return AirportsNoUSAAux;
        
        }else{
            return NoUSairportscode;
        }
    }
    set;}
    
    
    //B-02750 Jose (PT Flight Request)
    
    public list<String> ApcHolydays{get{
        if(ApcHolydays == null){
            system.debug('*****@@@ in ApcHolidays()');
            list<Holidays__c> apcHolydaysList = [Select Name, Date__c from Holidays__c WHERE AuPairCare__c =true];
            List<String> apcHolydaysListAux = new String[apcHolydaysList.size()];
            String auxTextDate;
            
            for(integer i=0; i< apcHolydaysList.size();i++){
                auxTextDate =  '"' + String.valueOf(apcHolydaysList[i].Date__c.Month()) + '-' + String.valueOf(apcHolydaysList[i].Date__c.Day()) + '-' + String.valueOf(apcHolydaysList[i].Date__c.Year()) + '"';
                apcHolydaysListAux[i]=auxTextDate;
            }
            
            system.debug('*****@@@ apcHolydaysListAux: ' + apcHolydaysListAux);
            return apcHolydaysListAux;
        
        }else{
            return ApcHolydays;
        }
    }
    set;}
    
    
    //B-02750 Jose (PT Flight Request)
    public Boolean isBeforeEndDate{get;set;}
    public Boolean isDuplicateDate{get;set;}
    public String insuranceSelector{get;set;}
    
    //B-02750 Jose (PT Flight Request)
    public void checkFlights(){
        
        system.debug('@@@@@applicant.Engagement__r.Requested_Departure_1__c: ' + applicant.Engagement__r.Requested_Departure_1__c);
        if( (applicant.Engagement__r.Requested_Departure_1__c != null && applicant.Engagement__r.Requested_Departure_1__c < applicant.Engagement__r.Engagement_End__c)
            || (applicant.Engagement__r.Requested_Departure_2__c != null && applicant.Engagement__r.Requested_Departure_2__c < applicant.Engagement__r.Engagement_End__c)
            || (applicant.Engagement__r.Requested_Departure_3__c != null && applicant.Engagement__r.Requested_Departure_3__c < applicant.Engagement__r.Engagement_End__c) ){
        
            isBeforeEndDate = true;
        }else{
            isBeforeEndDate = false;
        }
    }
    
    //B-02750 Jose (PT Flight Request)
    public PageReference saveFlights(){
        
        PageReference p;
        
        if(ApexPages.currentPage().getParameters().get('noFlight') == null){
            if( (applicant.Engagement__r.Requested_Departure_1__c != null && applicant.Engagement__r.Requested_Departure_1__c < applicant.Engagement__r.Engagement_End__c)
                || (applicant.Engagement__r.Requested_Departure_2__c != null && applicant.Engagement__r.Requested_Departure_2__c < applicant.Engagement__r.Engagement_End__c)
                || (applicant.Engagement__r.Requested_Departure_3__c != null && applicant.Engagement__r.Requested_Departure_3__c < applicant.Engagement__r.Engagement_End__c) ){
                
                isBeforeEndDate = true;
                
            }else{
                isBeforeEndDate = false;
            }
            
            if( applicant.Engagement__r.Requested_Departure_1__c == applicant.Engagement__r.Requested_Departure_2__c
                || applicant.Engagement__r.Requested_Departure_1__c == applicant.Engagement__r.Requested_Departure_3__c
                || applicant.Engagement__r.Requested_Departure_2__c == applicant.Engagement__r.Requested_Departure_3__c){
                
                isDuplicateDate = true;
                
            }else{
                isDuplicateDate = false;
            }
        
            if(isBeforeEndDate == true || isDuplicateDate == true){
                return null;
            }
            
            if(insuranceSelector == 'Yes'){
                p = Page.apc_ap_travel_payment;
                p.getParameters().put('id', applicant.Id);
                applicant.Engagement__r.Flight_booking_needed__c = null;
                if(applicant.Engagement__r.Departure_Request_Deadline__c != null && (Date.today() > applicant.Engagement__r.Departure_Request_Deadline__c) ){
                    p.getParameters().put('kw', 'eop_insurance_fee,eop_return_flight_late_fee');
                }else{
                    p.getParameters().put('kw', 'eop_insurance_fee');
                }
                
            }else if(insuranceSelector == 'No' && applicant.Engagement__r.Departure_Request_Deadline__c != null && (Date.today() > applicant.Engagement__r.Departure_Request_Deadline__c) ){
                p = Page.apc_ap_travel_payment;
                p.getParameters().put('id', applicant.Id);
                p.getParameters().put('kw', 'eop_return_flight_late_fee');
                applicant.Engagement__r.Flight_booking_needed__c = null;
                
            }else{
                p = Page.apc_ap_home;
            }
        }else{
            p = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
            applicant.Engagement__r.Requested_Departure_1__c = null;
            applicant.Engagement__r.Requested_Departure_2__c = null;
            applicant.Engagement__r.Requested_Departure_3__c = null;
            applicant.Engagement__r.Domestic_Departure_Airport__c = null;
            applicant.Engagement__r.International_Destination_Airport__c = null;
            
        }
        
        update applicant.Engagement__r; 
        p.setRedirect(true);
        return p;
        
        
    }
    
    public void resetNoFlights(){
        isBeforeEndDate = false;
        isDuplicateDate = false;
    }
    
    //B-02654 Jose
    public String InsurancePrice{get{
        if(InsurancePrice == null){
            
            Pricing_Controller controller = new Pricing_Controller();
            String PriceBookName = controller.getPriceBook('APC USA','Participant','All');
            list<PriceBookEntry> PricebookList = controller.getAPCPBEFromKeyword(PriceBookName,'Participant','End of program', 'eop_insurance_fee');
            if(PricebookList!=null && PricebookList.size()>0){
                return string.valueof(PricebookList[0].UnitPrice);
            }else{
                return null;
            }
            
            
        }else{
            return InsurancePrice;
        }
        
    }
    set;}
    
    //B-02654 Jose
    public String LateFlightPrice{get{ 
        if(LateFlightPrice == null){
            
            Pricing_Controller controller = new Pricing_Controller();
            String PriceBookName = controller.getPriceBook('APC USA','Participant','All');
            list<PriceBookEntry> PricebookList = controller.getAPCPBEFromKeyword(PriceBookName,'Participant','End of program', 'eop_return_flight_late_fee');
            if(PricebookList!=null && PricebookList.size()>0){
                return string.valueof(PricebookList[0].UnitPrice);
            }else{
                return null;
            }
            
            
        }else{
            return LateFlightPrice;
        }
        
    }
    set;}
    
    //B-02654 Jose : Check if the Au Pair paid insurance
    public Boolean isTravelPaid{get{ 
        if(isTravelPaid == null){
            list<Opportunity> childOpportunityListAux =[select id,ChildOppType__c,Name,Parent_Opportunity__c, Type FROM Opportunity 
                                                        WHERE Parent_Opportunity__c=:currentApp.Opportunity_Name__c AND ChildOppType__c='End of program'];
            system.debug('@@@@@childOpportunityListAux: '+ childOpportunityListAux);
            
            if(childOpportunityListAux != null && childOpportunityListAux.size() > 0 ){
                list<OpportunityLineItem> oppItemList = [Select Id, Product2.Name, Product2.Product_Keyword__c, Name, OpportunityId From OpportunityLineItem where OpportunityId =:childOpportunityListAux[0].id AND Product2.Product_Keyword__c = 'eop_insurance_fee'  ];          
                
                if(oppItemList != null && oppItemList.size() > 0 ){
                    return true;
                }else{
                    return false;
                }
            }else{
                return false;
            }
        }else{
            return isTravelPaid;
        }
         
    }
    set;}
    
    
    //Jose B-02984 We need to upload an  APC file from the home page 
    public String fileUploadUrl{get{ 
        if(fileUploadUrl == null){
            fileUploadUrl=Constants.fileUploadUrl2;
            return fileUploadUrl;
        }else{
            return fileUploadUrl;
        }
    }
    set;}
    
    //Jose B-02984 We need to upload an  APC file from the home page 
    public String ProgId{get{ 
        if(ProgId == null){
            if(currentApp.Type__c == 'Participant'){
                ProgId='apc-pt';
            }else{
                ProgId='apc-hf';
            }
            return ProgId;
        }else{
            return ProgId;
        }
    }
    set;}
    
    //Jose B-02984 We need to upload an  APC file from the home page 
    public String retParam{get{ 
        if(retParam == null){
            String RetString = DeriveRetParam(ProgId);
            system.debug('@@@@@ RetString' +RetString); 
            if(RetString != null){
                retParam = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(RetString)),'UTF-8');
            }
            system.debug('@@@@@ retParam' +retParam); 
            return retParam;
        }else{
            return retParam;
        }
    }
    set;}
    
    //Jose B-02984 DocType Fetching From URL
    public String DeriveRetParam(String ProgramId){
        
        string retParam;
        string DocumentType;
        
        system.debug('@@@@@ ProgramId' +ProgramId);
        system.debug('@@@@@ ApexPages.currentPage().getParameters().get(docType2)' +ApexPages.currentPage().getParameters().get('docType2'));
       
        if(ApexPages.currentPage().getParameters().get('docType2')!=null){
            DocumentType =  ApexPages.currentPage().getParameters().get('docType2');
            system.debug('@@@@@ docType2' +DocumentType);
        }
        
        // For APC DocumentUpload
        if(ProgramId=='apc-pt' && currentApp != null){
            if(Constants.APC_DOCTYPES.containsKey(DocumentType)) {
                retParam= Site.getBaseUrl().removeEnd('/')  +  Constants.APC_DOCTYPES.get(DocumentType);
                system.debug('@@@@@ retParam' +retParam); 
                if(!retParam.contains('apc_ap_home')){
                	retParam = retParam + '&id=' + currentApp.Id;
                }
                system.debug('@@@@@ retParam (APC): ' +retParam);
            }
        }
        else if(ProgramId=='apc-hf' && currentApp != null){
            if(Constants.APC_HF_DOCTYPES.containsKey(DocumentType)) {
                retParam= Site.getBaseUrl().removeEnd('/')  +  Constants.APC_HF_DOCTYPES.get(DocumentType);
                system.debug('@@@@@ retParam' +retParam); 
                retParam = retParam + '&id=' + currentApp.Id;
                system.debug('@@@@@ retParam (APC): ' +retParam);
            }
        }
        
        return retParam;
    }
    
    //Jose B-02984
    public Boolean isProofEducation{get{ 
        if(isProofEducation == null){
            list<Intrax_Program_Upload__c> ProofList = [Select document_name__c, Document_Type__c, document_guid__c from Intrax_Program_Upload__c
                                                           where Engagement__c =: currentApp.Engagement__c and Document_Type__c IN ('Proof-of-Education') order by Document_Type__c desc ];   
            system.debug('debug::Inside isProofEducation ====' + ProofList);
            
            if(ProofList!=NULL && ProofList.size() > 0){
                isProofEducation = true;
            }else{
                isProofEducation = false;
            }
            return isProofEducation;
            
        }else{
            return isProofEducation;
        }
    }
    set;}
    
    //JOSE B-02985 AP Completion Certificate create / make available in portal 
    public PageReference generateAuPairCertificate(){
        try{
            PageReference p; 
            if(currentApp.Engagement__c != null){
                p = apc_portal_utilities.generateAuPairCareCertificate(currentApp.Engagement__c, currentApp.Account__r.FirstName, currentApp.Account__r.LastName, currentApp.Engagement__r.Engagement_Start__c, currentApp.Engagement__r.Engagement_End__c);
            }
            return p;
        
        }catch(Exception e){
            system.debug('@@@@@ Exception in generateAuPairCertificate(): ' + e);
            return null;
        }
    }
    
    public void hide_from_pt(){
        system.debug('******* ' + withdrawnMatch);
        withdrawnMatch.Hide_from_PT__c = true;
        avoid_callouts = true;
        update withdrawnMatch;
    }  

}