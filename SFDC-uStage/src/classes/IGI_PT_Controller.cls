// ------------------------------------------------------------------------
// Class Definition - Controls all the pages related to the Internships Program (IGI) - PTs side
//      There are 2 different pages: 
//          - IGI_PT_MyMatches, that displays a table with all the matched Companies for the active user.
//          - IGI_PT_MatchDetails, that displays the detailed information for a specific company / internship details selected
//              in the page described above. 
// 
// Version#   Date            Author                    Description
// -------------------------------------------------------------------------------------------
// 1.0        Dec-4-2012     Diego Gutierrez          Initial Version
// -------------------------------------------------------------------------------------------

public with sharing virtual class IGI_PT_Controller { 
    
    //Initial Definitions
    
    public string ResourcePhaseStr{get;set;}
    public Person_Info__c personInfo{get;set;}
    public Applicant_Info__c ApplicantInfo{get;set;}
    public list<Match__c> MatchInformation{get;set;}
    public Engagement__c EnggInformation{get;set;}
    public boolean USCountries{get; set;}
    public Applicant_Info__c EnggAppInfo{get;set;}
    public Group__c eggGroupInformation{get;set;}
    public Group__c appGroupInformation{get;set;}
    public boolean eggGroup{get; set;}
    public boolean appGroup{get; set;}
    public boolean appIPO{get; set;}
    public Scorm__c scorm{get; set;}
    public Scorm__c sc{get; set;}
    public string getRegistrationID{get; set;}
    public Account accountInfo{get;set;}
    public Account companyInfo{get;set;}
    public Match__c matchInfo{get;set;}
    public list<Match__c> matchInfoList{get;set;}
    public list<Match__c> interviewList{get;set;} // Matches with Interview Information for the user
    public list<Match__c> noInterviewList{get;set;} // Matches without an interview
    public List<Match__c> ConfirmedMatches{get;set;}
    //public List<Match__c> OldMatches{get;set;}    
    public List<Engagement__c> engagementInfo{get;set;}
    public Position__c positionInfo{get;set;}
    public List<Position__c> positionInfoList;
    public External_System_Outage__c externalSystemOutage{get;set;}
    
    public DateTime selectedDate{get;set;}
    public List<SelectOption> ProposedDates{get;set;}
    public String selectProposedDate {get; set;}
    public String sId {get; set;}
    public list<Scorm_Settings__c> scormlst{get; set;}
    public Set<Id> MatchIds=new set<Id>();
    
    public List<MatchWrapper> lstMatchWrapper;
    public List<Match__c> LstMatches;
    
    public boolean isAccountCreated {get;set;}
    //Engagement Visa Details (Start)
    public User user {get;set;}
    public Engagement__c enggVisaDetails{get;set;}
    public ID enggID{get;set;}
    //Engagement Visa Details (End)
    
    // IGI 2 - Travel Visa (checking for APC ALSO)
    public list<Trip__c> tripList{get;set;}
    public Trip__c MostRecentTrip{get;set;}
    public Trip__c trip{get;set;}
    
    // Group Docs
    public map<string, boolean> mapdocTypesByGroup{get;set;}
    public list<Intrax_Program_Upload__c> otherDocList{get;set;}
    public String responseXML{get; set;}
    public String fileUploadUrl{
        get{
            return Constants.fileUploadUrl2;
        }set;
    }
    
    public String nextPage {get; set
    {
        nextPage = value;
    }
                           }
    public String mId {get; set
    {
        mId = value;
    }
                      }
    public boolean show {get; set
    {
        show = value;
    }
                        }
    public string Sched{get;set{
        Sched = value;
    }}
    public string schCancel{get;set{
        schCancel = value;
    }
                           }
    public string canc{get;set{
        canc = value;
    }
                       
                      } public string noShow{get;set{
                          noShow = value;
                      }
                                            }
    public string remove{get;set{
        remove = value;
    }
                        }
    public string removeMatch{get;set{
        removeMatch = value;
    }
                             } public string MakOff{get;set{
                                 MakOff = value;
                             }
                                                   }
    public string detail{get;set{
        detail = value;
    }
                        }
    public string Offer{get;set{
        Offer = value;
    }
                       } public string reqOther{get;set{
                           reqOther = value;
                       }
                                               }
    public string rejMatch{get;set{
        rejMatch = value;
    }
                          } 
    
    public string ApplyforPosition{get;set{
        ApplyforPosition = value;
    }
                                  } 
    
    public string confirm{get;set{
        confirm = value;
    }
                         } 
    public string SaveReqOther{get;set{
        SaveReqOther = value;
    }
                              }
    public string RevAccept{get;set{
        RevAccept = value;
    }
                           } 
    public string PTDeclined{get;set{
        PTDeclined = value;
    }
                            } 
    
    public Map<String, String> PosInfo_Status {get; set;}
    public pageReference checkLogin(){
        system.debug('****** UserName' + userInfo.getUserName());
        system.debug('****** Usertype' + userInfo.getUserType());
        if(userInfo.getUserType() == 'Guest'){
            pageReference p = Page.AppEngine_SiteLoginPage;
            p.setRedirect(true);
            return p;
        }
        else
        {
            User activeUser;
            Notification__c notification;
            try{
                system.debug('*************** logged user id: ' +userInfo.getUserId());
                activeUser = [select Id, Username,Email,Name, ContactId from User where Id = : userInfo.getUserId()];
                system.debug('*************** userId: ' +activeUser.Id);
            }catch(Exception e){
                system.debug('***** ' + e);
            }
            
            if(activeUser.Id != null){
                try{ 
                    
                    notification = [SELECT Id, Engagement__c,Name FROM Notification__c WHERE OwnerId =: activeUser.Id and Type__c='Orientation' 
                                    and Intrax_Program__c='Internship'and Status__c not in ('Not Initiated','Complete','Confirmed') LIMIT 1 ]; 
                    
                    system.debug('*************** Notification ' + notification.Name);
                    if((notification!=null) && (notification.Engagement__c!=null))
                    {
                        Engagement__c engagement = [Select Id,Name,Orientation_Date__c,Intrax_Program__c
                                                    From Engagement__c where Id =: notification.Engagement__c                                
                                                    AND Intrax_Program__c =: 'Internship'Limit 1];
                        system.debug('*************** Engagement ' + engagement.Name);
                        if(engagement !=null){
                            List<Scorm__c> sc = [Select Name,Complete_Status__c,result__c,Multi_Step_Course__c,Course_Id__c,
                                                 Is_this_a_quiz__c,Score__c,Learner_Id__c,Registration_Id__c,LearnerFirstName__c,
                                                 LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,HasLatestResult__c,
                                                 Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,Passed_Date__c ,Attempt_Count__c,
                                                 Parent_Course_Name__c,Parent_Course_Name__r.score__c,Parent_Course_Name__r.Is_this_a_quiz__c,
                                                 Step_Number__c From Scorm__c WHERE Engagement__c=: engagement.Id ];
                            
                            if((sc!=null ) && (sc.size()>0))
                            {
                                //if there is no scorm outage then call the scorm webservice.
                                external_system_outage__c externalSystemOutage;
                                externalSystemOutage= IUtilities.scormOutage();
                                
                                if(sc[0].HasLatestResult__c==false && externalSystemOutage ==null ){
                                    system.debug('*************** Scorm ' + sc[0].Name);
                                    ScormWebService getUpdatedResult= new ScormWebService();
                                    String registration =sc[0].Registration_Id__c;
                                    String appid=sc[0].Scorm_Application_Id__c;
                                    ScormWebService.Courselaunch CourseObj=getUpdatedResult.getregistrationResult(registration,appid);
                                    
                                    if(CourseObj.score!='unknown'){
                                        sc[0].Score__c=Decimal.valueOf(CourseObj.score);
                                    }
                                    if(CourseObj.score=='unknown'){
                                        sc[0].Score__c=null;
                                    }
                                    sc[0].Total_Time__c=CourseObj.totaltime;
                                    If((CourseObj.complete=='unknown' && CourseObj.success=='unknown')||(CourseObj.complete=='incomplete')){
                                        sc[0].Complete_Status__c='In Progress';
                                        sc[0].Result__c='';
                                    }
                                    if(CourseObj.success=='Passed' && CourseObj.complete=='complete' && sc[0].Result__c !='Passed'){
                                        sc[0].Result__c='Passed';
                                        sc[0].Passed_Date__c=system.today();
                                        sc[0].Complete_Status__c='Completed';
                                        engagement.Orientation_Date__c=sc[0].Passed_Date__c;
                                        update engagement;
                                        system.debug('debug:::Attempt_Count__c'+sc[0].Attempt_Count__c);
                                        sc[0].Attempt_Count__c=sc[0].Attempt_Count__c+1;
                                    }
                                    if(CourseObj.success=='failed' && CourseObj.complete=='complete'){
                                        sc[0].Result__c='Failed';
                                        sc[0].Failed_Date__c=system.today();
                                        sc[0].Complete_Status__c='Completed';
                                        sc[0].Attempt_Count__c=sc[0].Attempt_Count__c+1;
                                    }
                                    sc[0].HasLatestResult__c=true;
                                    update sc[0];
                                }
                            }  
                        }   
                    }
                }catch(Exception e){
                    
                    system.debug('***** There is no OrientationNotification for the current user.'+e);
                }               
            }
            return null;   
        }
    }
    public pageReference saveTrip(){
        try{
            trip.Engagement__c = EnggInformation.Id;   
            system.debug('****** Trip Type: ' + ApexPages.CurrentPage().getParameters().get('type')); 
            if(ApexPages.CurrentPage().getParameters().get('type') == 'arrival'){
                trip.Arrival_to_Host_Community__c = true;
            } else if(ApexPages.CurrentPage().getParameters().get('type') == 'departure'){
                trip.Departure_from_Host_Community__c = true; 
            }
            upsert trip;
        }catch(Exception e){
            system.debug('Impossible to save trip details:' + e);
        }
        
        PageReference p = new PageReference('/apex/igi_home');
        p.setRedirect(true);
        return p;
    }
    
    public boolean getIsArrivalTripIndicated(){
        list<Trip__c> t = [SELECT Id, Arrival_To_Host_Community__c FROM Trip__c WHERE Engagement__c =: enggInformation.Id AND Arrival_To_Host_Community__c =: true];
        if(t.size() > 0) {
            return true;
        }
        else{
            return false;
        }
    }
    
    public boolean getIsDepartureTripIndicated(){
        list<Trip__c> t = [SELECT Id, Departure_From_Host_Community__c FROM Trip__c WHERE Engagement__c =: enggInformation.Id AND Departure_from_Host_Community__c =: true];
        if(t.size() > 0) {
            return true;
        }
        else{
            return false;
        }
    }
    
    // Default Controller
    public IGI_PT_Controller(){
        
        ResourcePhaseStr = '';
        EnggAppInfo = new applicant_Info__c();
        USCountries = false;
        eggGroup = false;
        appGroup = false;
        appIPO = false;
        EnggInformation = new Engagement__c();
        applicantInfo = new applicant_Info__c();
        personInfo = new person_Info__c();
        MatchInformation = new list<Match__c>();
        
        matchInfoList = new list<Match__c>();
        
        trip = new Trip__c();        
        MostRecentTrip = new Trip__c();
        PosInfo_Status = new  Map<String, String>();
        
        //<Intacct Integration Code Comment Starts>
        //SalesInvoice = new Sales_Invoice__c();
        //<Intacct Integration Code Comment Ends>
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        
        list <Applicant_Info__c> appInfoLst = [SELECT Id, Account__c, Group__c,Intrax_Program_Options__c, Group__r.Engagement_Start__c, Group__r.Engagement_End__c, Group__r.Location__c, Group__r.Country__c, Group__r.Description__c, Group__r.Orientation_Date__c,Group__r.Group_Contact_Notes__c, Group__r.Accommodations__c, Group__r.Site_Staff_Contact__c, Group__r.Site_Staff_Contact__r.FirstName, Group__r.Site_Staff_Contact__r.LastName, Group__r.Site_Staff_Contact__r.Email, Group__r.Site_Staff_Contact__r.MobilePhone, Group__r.Site_Staff_Contact__r.Department, 
                                               Intrax_Region__c, Engagement__r.Terms_Accepted_Date__c, Engagement__r.Status__c, Payment_Received__c, First_Name__c, Last_Name__c, Engagement_End__c, Engagement_Start__c, Work_Authorization_Indicated__c, Functional_Areas__c, Intrax_Program_Category__c, Country_of_Interest__c, Application_Level__c , Engagement__c , Application_Stage__c, account__r.FirstName,account__r.IsPersonAccount, account__r.LastName, account__r.Intrax_Id__c, Partner_Account__c, Opportunity_Name__r.Payment_Received__c, Service_level__c, 
                                               CreatedBy__c, createdDate,Engagement__r.Placement_Status__c
                                               FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                                               AND application_Stage__c !=: 'Cancelled'
                                               order by CreatedDate desc];
        
        if(appInfoLst.Size() > 0){
            applicantInfo = appInfoLst[0];
            /*applicantInfo = [Select Account__c, Group__c, Group__r.Engagement_Start__c, Group__r.Engagement_End__c, Group__r.Location__c, Group__r.Country__c, Group__r.Description__c, Group__r.Orientation_Date__c,Group__r.Group_Contact_Notes__c, Group__r.Accommodations__c, Group__r.Site_Staff_Contact__c, 
Intrax_Region__c, Engagement__r.Terms_Accepted_Date__c, Engagement__r.Status__c, Payment_Received__c, First_Name__c, Last_Name__c, Engagement_End__c, Engagement_Start__c, Work_Authorization_Indicated__c, Functional_Areas__c, Intrax_Program_Category__c, Country_of_Interest__c, Application_Level__c , Engagement__c , Application_Stage__c, account__r.FirstName,account__r.IsPersonAccount, account__r.LastName, account__r.Intrax_Id__c, Partner_Account__c, Opportunity_Name__r.Payment_Received__c, Service_level__c 
From Applicant_Info__c a 
where a.Id = :appInfoLst[0].Id];*/
            //B-02184                   
            if(applicantInfo.Intrax_Program_Options__c != null && applicantInfo.Intrax_Program_Options__c.contains('Internship Group'))
                appIPO=true;
            else if (applicantInfo.Engagement__r.Terms_Accepted_Date__c != NULL)
                appIPO=true;
            else appIPO=false;
            //B-02184
            if(applicantInfo.Group__c != null){
                // Getting the associated documents to the Group
                
                mapdocTypesByGroup = new map<string, boolean>();
                otherDocList = new list<Intrax_Program_Upload__c>();
                
                mapdocTypesByGroup.put('Itinerary', false);             
                mapdocTypesByGroup.put('Welcome-Document', false);                  
                mapdocTypesByGroup.put('University-Group-Uploads', false);
                mapdocTypesByGroup.put('Pre-Departure-Orientation-Info', false);
                
                list<Intrax_Program_Upload__c> ipuGroupList = [SELECT Id, Document_GUID__c, Document_Type__c, Group__c, Name FROM Intrax_Program_Upload__c WHERE Group__c =: applicantInfo.Group__c];
                system.debug('****** Documents associated to the group: ' + ipuGroupList.size());   
                
                for(Intrax_Program_Upload__c ipu : ipuGroupList){
                    if(ipu.Document_Type__c == 'Itinerary') mapdocTypesByGroup.put('Itinerary', true);
                    else if(ipu.Document_Type__c == 'Welcome-Document') mapdocTypesByGroup.put('Welcome-Document', true);
                    else if(ipu.Document_Type__c == 'University-Group-Uploads') {
                        mapdocTypesByGroup.put('University-Group-Uploads', true);
                        otherDocList.add(ipu);
                    }else if(ipu.Document_Type__c == 'Pre-Departure-Orientation-Info') mapdocTypesByGroup.put('Pre-Departure-Orientation-Info', true);                  
                }
                // B-02008 Display PT Portal Payment Blocks Dependent on Group
                appGroupInformation = [SELECT Id, Invoice_Participants__c FROM Group__c WHERE Id = :applicantInfo.Group__c];
                appGroup = appGroupInformation.Invoice_Participants__c;
                
                
            } 
            else appGroup=true;
            
            system.debug('Application ID ***'+ appInfoLst[0].Id);
            system.debug('Payment Received: ***'+ applicantInfo.Opportunity_Name__r.Payment_Received__c);
            list<Match__c> confmatchInfoList = new list<Match__c>();
            // B-02008 Display PT Portal Payment Blocks Dependent on Group
            if(applicantInfo.Engagement__c != NULL)
            {
                EnggInformation = [SELECT ID,Group__c, Opportunity_Id__r.Payment_Received__c ,Partner_Account__c, Payment_Received__c FROM Engagement__c WHERE ID = :applicantInfo.Engagement__c];
                
                if (EnggInformation.Group__c!=null)
                {
                    eggGroupInformation = [SELECT Id, Invoice_Participants__c FROM Group__c WHERE Id = :EnggInformation.Group__c];
                    eggGroup = eggGroupInformation.Invoice_Participants__c;
                }
                else eggGroup=true;
                ///    
                system.debug('EnggInformation ID***'+ EnggInformation.Id);
                
                system.debug('EnggInformation Payment_Received__c***'+ EnggInformation.Payment_Received__c);
                // We retrieve here all the Matches 
                matchInfoList = [SELECT Id, lastModifiedDate, Offer_Status__c, Hide_From_PT__c, Hide_From_Host__c, Engagement__c, Name, status__c, Interview_Date__c,Interview_Request_HC1__c,Interview_Response_Note__c,Interview_Status__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.isPersonAccount, 
                                 Position_Name__r.Title__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.City__c, Position_Name__c, Position_Name__r.State__c,
                                 Position_Name__r.Position_Supervisor__r.Name, Position_Name__r.Position_Supervisor__r.Skype_Id__c, Position_Name__r.Position_Supervisor__r.Department, Position_Name__r.Host_Company_Id__r.Website, 
                                 Position_Name__r.Engagement_Start__c, Position_Name__r.Engagement_End__c, Marketing_Notes__c, Position_Name__r.Country__c, Position_Name__r.Description__c, Position_Name__r.Supervisor_Role__c, Position_Name__r.Marketing_Notes__c,Engagement__r.Intrax_Program__c,Start_Date__c,End_Date__c
                                 FROM Match__c 
                                 WHERE Engagement__c =: applicantInfo.Engagement__c
                                 //ORDER BY LastModifiedDate
                                ];
                
                // Getting the list of all the upcoming interviews for the Participant                  
                //Not used for now... we need to come up with a better way of sort matches              
                if(matchInfoList.size() > 0){                 
                    interviewList = new list<Match__c>();
                    noInterviewList = new list<Match__c>();
                    
                    for(Match__c m : matchInfoList){
                        if(!(m.Hide_from_PT__c||m.Hide_From_Host__c)){
                            if(m.Interview_Status__c != null && (m.Interview_Status__c == 'Initiated' || m.Interview_Status__c == 'Scheduled')){
                                interviewList.add(m);
                            }else{
                                noInterviewList.add(m);
                            }
                        }
                    }
                    
                }
                //Getting the position info status from selected Matches
                if (matchInfoList.size() > 0)
                {
                 for(Match__c m: matchInfoList )
                 {
                 List<Position_Info__c> pos = new List<Position_Info__c>();
                 pos=[SELECT Match__c, Status__c FROM Position_Info__c WHERE Match__c =:m.Id limit 1];     
                 system.debug('Inside for loop');
                  if((pos!=null) && (pos.size()>=1)){
                     system.debug('Inside if loop'+pos[0].Status__c);
                     if(pos[0].Status__c !=null)
                     PosInfo_status.put(m.id, pos[0].Status__c);
                     else
                     PosInfo_status.put(m.id, 'No Status');                      
                  }
                  else if(pos.size()==0)
                  {
                    system.debug('Inside else if loop');
                    PosInfo_status.put(m.id,'Not Yet Started');
                  }
                 }                            
                }
                
                /*** Why is this using confmatchInfoList when it is returning all the matches that are not Withdrawn?? Shouldn't we use the one I just created above??? **/
                confmatchInfoList = [SELECT Position_Name__r.Country__c, Status__c FROM Match__c WHERE Engagement__c = :applicantInfo.Engagement__c AND Status__c != 'Withdrawn' order by CreatedDate DESC];
                
                if(EnggInformation.Id != null){
                    tripList = [SELECT Id, Name, Description__c, Arriving_City__c, Arrival_Date_Time__c, Arrival_to_Host_Community__c, Arrival_to_Host_Community_Date__c, Arrival_to_Host_Country__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, Departing_From__c, Departing_City__c, Departure_Date_Time__c, Departure_from_Host_Community__c, Ground_Transporation_Type__c FROM Trip__c WHERE Engagement__c =: EnggInformation.Id ORDER BY CreatedDate DESC];
                    
                    if(tripList != NULL && tripList.size() > 0)
                    {
                        MostRecentTrip = tripList[0];
                    }
                }
            } 
            
            if (confmatchInfoList != NULL && confmatchInfoList.size() > 0 && confmatchInfoList[0].Status__c == 'Confirmed')
            {
                ResourcePhaseStr = 'Phase3';
            }
            else if (applicantInfo.Payment_Received__c != NULL && (applicantInfo.Application_Stage__c == 'Submitted' || applicantInfo.Application_Stage__c == 'Accepted' || applicantInfo.Application_Stage__c == 'In-Review'))
            {
                ResourcePhaseStr = 'Phase2';
            }
            else
            {
                ResourcePhaseStr = 'Phase1';
            }
            
            
            list<person_info__c> personInfoList = [Select Citizenship__c, Country_of_Residence__c, First_Name__c, Last_Name__c
                                                   From Person_Info__c p 
                                                   Where p.Applicant_Info__c = : appInfoLst[0].Id and Primary_Applicant__c = true]; 
            
            
            if(personInfoList.size() > 0)
            {
                personInfo = personInfoList[0];
                if (personInfo.Country_of_Residence__c == 'Antigua and Barbuda' || personInfo.Country_of_Residence__c == 'Argentina'  || personInfo.Country_of_Residence__c == 'Bahamas'|| personInfo.Country_of_Residence__c == 'Barbados'|| personInfo.Country_of_Residence__c == 'Belize'|| personInfo.Country_of_Residence__c == 'Bolivia'|| personInfo.Country_of_Residence__c == 'Brazil'|| personInfo.Country_of_Residence__c == 'Canada'|| personInfo.Country_of_Residence__c == 'Chile'|| personInfo.Country_of_Residence__c == 'Colombia'|| personInfo.Country_of_Residence__c == 'Costa Rica'|| personInfo.Country_of_Residence__c == 'Cuba'|| personInfo.Country_of_Residence__c == 'Dominica'|| personInfo.Country_of_Residence__c == 'Dominican Republic'|| personInfo.Country_of_Residence__c == 'Ecuador'|| personInfo.Country_of_Residence__c == 'El Salvador'|| personInfo.Country_of_Residence__c == 'Grenada'|| personInfo.Country_of_Residence__c == 'Guatemala'|| personInfo.Country_of_Residence__c == 'Guyana'|| personInfo.Country_of_Residence__c == 'Haiti'|| personInfo.Country_of_Residence__c == 'Honduras'|| personInfo.Country_of_Residence__c == 'Jamaica'|| personInfo.Country_of_Residence__c == 'Mexico'|| personInfo.Country_of_Residence__c == 'Nicaragua'|| personInfo.Country_of_Residence__c == 'Panama'|| personInfo.Country_of_Residence__c == 'Paraguay'|| personInfo.Country_of_Residence__c == 'Peru'|| personInfo.Country_of_Residence__c == 'Saint Kitts and Nevis'|| personInfo.Country_of_Residence__c == 'Saint Lucia'|| personInfo.Country_of_Residence__c == 'Saint Vincent and the Grenadines'|| personInfo.Country_of_Residence__c == 'Suriname'|| personInfo.Country_of_Residence__c == 'Trinidad and Tobago'|| personInfo.Country_of_Residence__c == 'Uruguay'|| personInfo.Country_of_Residence__c == 'Venezuela, Bolivarian Republic of'|| personInfo.Country_of_Residence__c == 'Anguilla'|| personInfo.Country_of_Residence__c == 'Aruba'|| personInfo.Country_of_Residence__c == 'Bermuda'|| personInfo.Country_of_Residence__c == 'Bonaire, Saint Eustatius And Saba'|| personInfo.Country_of_Residence__c == 'Virgin Islands, British'|| personInfo.Country_of_Residence__c == 'Cayman Islands'|| personInfo.Country_of_Residence__c == 'Curacao'|| personInfo.Country_of_Residence__c == 'French Guiana'|| personInfo.Country_of_Residence__c == 'Greenland'|| personInfo.Country_of_Residence__c == 'Guadeloupe'|| personInfo.Country_of_Residence__c == 'Martinique'|| personInfo.Country_of_Residence__c == 'Montserrat'|| personInfo.Country_of_Residence__c == 'Puerto Rico'|| personInfo.Country_of_Residence__c == 'Saint Barthelemy'|| personInfo.Country_of_Residence__c == 'Saint Martin (French Part)'|| personInfo.Country_of_Residence__c == 'Saint Pierre and Miquelon'|| personInfo.Country_of_Residence__c == 'Sint Maarten (Dutch Part)'|| personInfo.Country_of_Residence__c == 'South Georgia and the South Sandwich Islands'|| personInfo.Country_of_Residence__c == 'Turks and Caicos Islands'|| personInfo.Country_of_Residence__c == 'Virgin Islands, U.S.')
                {
                    USCountries = true;
                }
                system.debug('Country Residence' + personInfo.Country_of_Residence__c);
                system.debug('Country of Interest' + applicantInfo.Country_of_Interest__c);
            }
            
            if(applicantInfo != NULL && applicantInfo.Engagement__c != NULL)
            {
                MatchInformation = [SELECT ID, Name FROM Match__c m WHERE m.engagement__c = :applicantInfo.Engagement__c AND Status__c = 'Confirmed'];
            }
            
            //<Intacct Integration Code Comment Starts>
            
            /*if(applicantInfo != NULL && applicantInfo.Account__c != NULL)
{
list<Sales_Invoice__c> SalesInvoices = [SELECT Id, Amount_Due__c, CurrencyIsoCode FROM Sales_Invoice__c WHERE State__c != 'DRAFT' AND State__c != 'PAID' AND Account__c = :applicantInfo.Account__c ORDER BY CreatedDate ASC];
if(SalesInvoices != NULL && SalesInvoices.size() > 0)
{
SalesInvoice = SalesInvoices[0];
}
}*/
            //<Intacct Integration Code Comment Ends>
            
        }
        
        if(ApexPages.currentPage().getParameters().get('EnggID') != NULL)
        {
            EnggID = ApexPages.currentPage().getParameters().get('EnggID');
            enggVisaDetails = [SELECT Name, Visa_Interview_Date__c, Visa_Interview_Status__c FROM Engagement__c WHERE ID = :EnggID]; 
            
            list <applicant_info__c> applicantInfolst = [Select Country_of_Interest__c, Application_Level__c , Engagement__c , Application_Stage__c, account__r.FirstName, account__r.IsPersonAccount,account__r.LastName, account__r.Intrax_Id__c, Opportunity_Name__r.Payment_Received__c, Service_level__c 
                                                         From Applicant_Info__c a 
                                                         where a.Engagement__c = :EnggID 
                                                         AND Application_Stage__c != 'Cancelled' ORDER BY CreatedDate DESC]; 
            if (applicantInfolst.size() > 0)
            {
                EnggAppInfo = applicantInfolst[0];
            }
            
        }
        
        if(ApexPages.currentPage().getParameters().get('tId') != null){
            trip = [SELECT Id, Name, Description__c, Arriving_City__c, Arrival_Date_Time__c, Arrival_to_Host_Community__c, Arrival_to_Host_Community_Date__c, Arrival_to_Host_Country__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, Departing_From__c, Departing_City__c, Departure_Date_Time__c, Departure_from_Host_Community__c, Ground_Transporation_Type__c FROM Trip__c WHERE Id =: ApexPages.currentPage().getParameters().get('tId')];
        }
        
        
    }
    
    public PageReference load_by_doctype(){
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();      
        system.debug('DocType: ' +ApexPages.currentPage().getParameters().get('dType') );
        system.debug('GroupId: ' +ApexPages.currentPage().getParameters().get('groupId') );
        
        loadDoc = [Select Document_service__c,Name,Document_GUID__c, createdDate, document_type__c, Group__c
                   from Intrax_Program_Upload__c 
                   where document_type__c =: ApexPages.currentPage().getParameters().get('dType')
                   and Group__c =: ApexPages.currentPage().getParameters().get('groupId')
                   order by createdDate desc limit 1]; 
        
        PageReference p = load(loadDoc);
        return p;       
    }
    
    public PageReference load_by_docGuid(){
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();      
        
        loadDoc = [Select Document_service__c,Name,Document_GUID__c, createdDate
                   from Intrax_Program_Upload__c 
                   where document_GUID__c =: ApexPages.currentPage().getParameters().get('docGUID')
                   order by createdDate desc]; 
        
        PageReference p = load(loadDoc);
        return p;       
    }
    
    public PageReference load( Intrax_Program_Upload__c loadDoc){
        
        // Instantiate a new http object 
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        
        // document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
        HttpRequest req = new HttpRequest();
        req.setMethod('POST'); 
        //AA Fixed View File functionality.
        req.setHeader('Accept', 'application/xml');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
        String body = '';
        if (loadDoc.Document_service__c == 'DS'){
            req.setEndpoint(Constants.documentService+'GetFile');
        }
        
        else{           
            req.setEndpoint(Constants.imageService+'GetFile');
        }
        
        body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';
        
        body = body + loadDoc.Document_GUID__c;
        
        system.debug('debug::RequestBody'+body);
        req.setBody(body);
        Dom.Document docRes = new Dom.Document();
        String returnurl = null;
        
        if (!Test.isRunningTest()){
            res = h.send(req);
            
            responseXML = res.getBody();
            
            docRes.load(responseXML);
            List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
            for (dom.XmlNode node : resnodelist){
                
                system.debug('debug::node.Name=='+node.getName());
                system.debug('debug::node.getText=='+node.getText());
                
                if (loadDoc.Document_service__c != 'VS' && node.getName() == 'result'){
                    returnurl = node.getText();
                    //spillai video changes
                    return new PageReference(returnurl);
                }
                
                if(node.getName() == 'error'){
                    //customMessage=true;
                    string error= node.getText();
                    if(error.contains('is not found')){                        
                        if(Site.getBaseUrl() != null && Site.getBaseUrl().contains('force.com')){
                            pageReference p = new pageReference('/apex/SiteDocViewer?id=' + applicantInfo.Id+'&docGuid='+loadDoc.Document_GUID__c);
                            p.setRedirect(true);
                            return p;   
                        } else{
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, we appear to be unable to locate this file. Document GUID='+loadDoc.document_Guid__c);
                            ApexPages.addMessage(msg);
                            return null;
                        }
                    }
                }   
            }
            //spillai video changes
            return null;
        }
        else{
            return new PageReference('');
        }
    }
    
    // Getting a controller's instance 
    public IGI_PT_Controller Controller{
        get{
            return new IGI_PT_Controller();
        }
        set;
    }
    
    
    //--Uncommenting from here for scheduling
    public pageReference Initialize(){             
        // if(isAccountCreated){
        RetrieveMatches();   
        // }
        return null;
    }
    
    public List<MatchWrapper> getlstMatchWrapper(){
        system.debug('*******lstMatchWrapper********'+lstMatchWrapper);
        return lstMatchWrapper;
    }
    
    private void RetrieveMatches(){
        
        //Retrieve Sorted List of Script Steps based on Sales Script Id.
        Integer intCount=0;         
        
        LstMatches = [SELECT Id, Name, Marketing_Notes__c, status__c, Interview_Date__c,Interview_Request_HC1__c,Interview_Response_Note__c,Interview_Status__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Host_Company_Id__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__c  FROM Match__c 
                      WHERE engagement__c IN: engagementInfo
                      AND Interview_Status__c = 'Initiated' and Id=: ApexPages.currentPage().getParameters().get('mId')];
        system.debug('****************matchInfoList'+LstMatches);
        lstMatchWrapper = new List<MatchWrapper>();
        
        if(LstMatches.Size()>0)
        {
            //system.debug('****blnStepsNotExist****'+blnStepsNotExist);    
            for (Match__c objMatch : LstMatches)
            {
                MatchWrapper ObjMatchWrapper = new MatchWrapper();
                ObjMatchWrapper.MatchId = objMatch.Id;  
                ObjMatchWrapper.response = objMatch.Interview_Response_Note__c;
                ObjMatchWrapper.InterviewStatus  =  objMatch.Interview_Status__c;
                if( ObjMatchWrapper.InterviewStatus !='On Hold')
                    ObjMatchWrapper.reject = false;
                else
                    ObjMatchWrapper.reject = true;
                system.debug('******ObjMatchWrapper.reject**********'+ObjMatchWrapper.reject);
                ObjMatchWrapper.strPosName = objMatch.Position_Name__r.Name;
                ObjMatchWrapper.strCompName = objMatch.Position_Name__r.Name;
                if(objMatch.Interview_Date__c!=null)
                    ObjMatchWrapper.strSelectedResponse=objMatch.Interview_Date__c.format();
                if(objMatch.Interview_Request_HC1__c!=null)
                    ObjMatchWrapper.Request1 =  objMatch.Interview_Request_HC1__c.format();
                else
                    ObjMatchWrapper.Request1 ='';
                if(objMatch.Interview_Request_HC2__c!=null)
                    ObjMatchWrapper.Request2 =  objMatch.Interview_Request_HC2__c.format();
                else
                    ObjMatchWrapper.Request2 ='';
                if(objMatch.Interview_Request_HC3__c!=null)
                    ObjMatchWrapper.Request3 = objMatch.Interview_Request_HC3__c.format(); 
                else
                    ObjMatchWrapper.Request3 ='';
                
                lstMatchWrapper.add(ObjMatchWrapper);
                intCount = ObjMatchWrapper.Counter;
            }}
        system.debug('****************lstMatchWrapper'+lstMatchWrapper);
    }
    
    // Navigator function : For now, we only need to get the Match Id in the context (As a PT, 
    //                      they will be interested on the company info mainly, as well as the job description).
    
    public PageReference navigator(){
        system.debug('*************** nextPage: '+ nextPage);
        system.debug('*************** mId: '+ mId);
        nextPage = ApexPages.currentPage().getParameters().get('nextPage');
        
        PageReference P = new PageReference(nextPage);
        mId = ApexPages.currentPage().getParameters().get('mId');
        
        
        // rejId = ApexPages.currentPage().getParameters().get('rejId');
        system.debug('******* '+ ApexPages.currentPage().getParameters().get('nextPage') );
        system.debug('******* '+ ApexPages.currentPage().getParameters().get('mId') );
        system.debug('***matchinfolist**** '+ matchInfoList);
        
        if (mId != null && ApexPages.currentPage().getParameters().get('Offer')==null && ApexPages.currentPage().getParameters().get('rejMatch')==null && ApexPages.currentPage().getParameters().get('noShow')==null && ApexPages.currentPage().getParameters().get('removeMatch')==null && ApexPages.currentPage().getParameters().get('canc')==null && ApexPages.currentPage().getParameters().get('SaveReqOther')==null && ApexPages.currentPage().getParameters().get('confirm')==null && ApexPages.currentPage().getParameters().get('CancelInterview')==null && ApexPages.currentPage().getParameters().get('reject')==null && (ApexPages.currentPage().getParameters().get('Sched')!=null || ApexPages.currentPage().getParameters().get('remove')!=null || ApexPages.currentPage().getParameters().get('schCancel')!=null || ApexPages.currentPage().getParameters().get('RevAccept')!=null || ApexPages.currentPage().getParameters().get('reqOther')!=null || ApexPages.currentPage().getParameters().get('detail')!=null)){
            P.getParameters().put('mId',mId);
        }
        if(ApexPages.currentPage().getParameters().get('confirm')=='true'|| ApexPages.currentPage().getParameters().get('SaveReqOther')=='true')
        {
            system.debug('******lstMatchWrapper**********'+lstMatchWrapper);
            updateMatchInfo(lstMatchWrapper);
        }
        
        if(ApexPages.currentPage().getParameters().get('Apply')== 'true')
        {
            system.debug('**************** matchInfo***'+matchInfo);                
            ApplyforPosition(mId); 
            
        }
        
        if(ApexPages.currentPage().getParameters().get('removeMatch')== 'true')
        {
            system.debug('**************** matchInfo***'+matchInfo);                
            removeMatch(mId); 
            
        }
        
        if(ApexPages.currentPage().getParameters().get('canc')== 'true')
        {
            system.debug('**************** matchInfo***'+matchInfo);                
            CancelMatch(mId); 
            
        }
        
        if(ApexPages.currentPage().getParameters().get('noShow')=='true')
        {
            system.debug('**************** matchInfo***'+matchInfo);                
            UpdateNoShow(mId);       
            
            
        }
        if(ApexPages.currentPage().getParameters().get('Offer')=='true')
        {
            system.debug('**************** matchInfo***'+matchInfo);            
            AcceptOffer(mId);      
        }
        
        //system.debug('******reject**********'+ApexPages.currentPage().getParameters().get('reject'));
        if(ApexPages.currentPage().getParameters().get('rejMatch')== 'true')
        {
            system.debug('******reject mId**********'+mId);
            RejectMatch(mId);
        }
        
        if(ApexPages.currentPage().getParameters().get('PTDeclined')== 'true')
        {
            system.debug('******reject mId**********'+mId);
            PTDeclinedInterview(mId);
        }
        
        P.setRedirect(true);
        return P;       
    }
    
    public void applyForPosition(Id mId){
        Match__c m =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                       FROM Match__c
                       WHERE Id=: mId];
        
        m.Status__c = 'Applied';    
        update m;
    }
    
    public void CancelMatch(Id mId){
        Match__c cancMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                               FROM Match__c
                               WHERE Id=: mId];
        
        cancMatch.Interview_Date__c = null;
        
        //MT 141 Changes
        //cancMatch.Interview_status__c = 'On Hold';
        cancMatch.Status__c = 'Requested';
        cancMatch.Interview_Status__c = 'Needs Assistance';
        cancMatch.Offer_Status__c = null;
        
        update cancMatch;
    }
    
    public void RejectMatch(Id mId){
        Match__c rejectMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                 FROM Match__c
                                 WHERE Id=: mId];
        
        // rejectMatch.Interview_Date__c = null;
        // MT 141 Changes
        // rejectMatch.Interview_status__c = 'Position Declined';
        // rejectMatch.status__c='Offer Declined';
        rejectMatch.Status__c = 'Withdrawn';
        rejectMatch.Offer_Status__c = 'Declined';
        rejectMatch.Hide_from_PT__c = true;
        update rejectMatch;
    }
    
    public void AcceptOffer(Id mId){
        Match__c accMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate,  Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                              FROM Match__c
                              WHERE Id=: mId];
        
        // accMatch.Interview_Date__c = null;
        
        // MT 141 Changes
        // accMatch.Interview_status__c = 'Position Accepted';
        // accMatch.status__c='Matched';
        accMatch.Status__c = 'Confirmed';
        accMatch.Offer_Status__c = 'Accepted';
        update accMatch;
    }
    
    public void PTDeclinedInterview(Id mId){
        Match__c m =  [SELECT Hide_From_PT__c, Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                       FROM Match__c
                       WHERE Id=: mId];
        // MT 141 Changes
        if(m.Interview_Status__c == 'Initiated'){
            m.Interview_Status__c = 'Participant Declined Interview';                
        }
        
        m.status__c= 'Withdrawn';
        m.Hide_from_PT__c = true; 
        
        update m;
    }
    
    public void removeMatch(Id mId){
        Match__c remMatch =  [SELECT Hide_From_PT__c, Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                              FROM Match__c
                              WHERE Id=: mId];
        // MT 141 Changes
        if(remMatch.Interview_Status__c == 'Completed'){
            remMatch.Interview_Status__c = 'Withdrawn';
            remMatch.Offer_Status__c = 'Declined';                  
        }
        
        else {
            //Commented for MT#140
            //remMatch.Interview_status__c = 'Participant Declined Interview';
            remMatch.status__c= 'Withdrawn';
            // MT 141 Changes
            remMatch.Interview_Status__c = 'Participant Declined Interview';
            remMatch.Offer_Status__c = null;
            remMatch.Hide_from_PT__c = true; 
        }
        update remMatch;
    }
    
    public void UpdateNoShow(Id mId){
        Match__c resMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                              FROM Match__c
                              WHERE Id=: mId];
        
        resMatch.Interview_status__c = 'Company No Show';
        // MT 141 Changes
        resMatch.Offer_Status__c = null;
        //resMatch.Interview_Date__c = null;
        //resMatch.status__c='Withdrawn';
        update resMatch;
    }
    
    
    // Custom Controller :  All the necessary queries to display all the required data. 
    public IGI_PT_Controller(ApexPages.StandardController controller){
        User activeUser;
        system.debug('****** userInfo.getUserType(): ' + userInfo.getUserType());
        if(userInfo.getUserType() != 'Guest'){
            try{
                activeUser = [select Id, Intrax_Id__c, Name, ContactId from User where Id = : userInfo.getUserId()];
                system.debug('*************** userID: ' +activeUser.Intrax_Id__c);
                system.debug('*************** userID: ' +activeUser.Name);  
            }catch(Exception e){
                system.debug('***** ' + e);
            }
            
            if(activeUser.Id != null){
                try{ 
                    /*
accountInfo = [SELECT Id, Name, Account_Name__c, Intrax_Id__c, Type__c 
FROM sAccount__c 
WHERE Account_Name__c IN (SELECT AccountId FROM Contact WHERE Id =: activeUser.ContactId)];
//WHERE Intrax_Id__c =: activeUser.Intrax_Id__c LIMIT 1]; 
*/
                    accountInfo = [SELECT Id, Name, Intrax_Id__c, Type FROM Account WHERE Intrax_Id__c =: activeUser.Intrax_Id__c LIMIT 1 ]; 
                    
                    system.debug('*************** Account ID: ' + accountInfo.Name);
                    
                    if(accountInfo!=null)
                    {
                        engagementInfo = [Select e.Type__c, e.Terms_Accepted__c, e.TEFL_Course_Taken__c, e.SystemModstamp, e.Status__c, e.Resume_Received__c, e.Resume_Rating__c, e.RecordTypeId, e.Preparedness_Rating__c, e.Position_Types__c, e.Position_Types_Other__c, e.OwnerId, e.Opportunity_Id__c, e.Name, e.Match_Notes__c, e.Location_of_Interest__c, e.LastModifiedDate, e.LastModifiedById, e.IsDeleted, e.Intrax_Region__c, e.Intrax_Program__c, e.Intrax_Program_Options__c, e.Id, e.Functional_Areas__c, e.Functional_Areas_Other__c, e.Experience_Summary__c, e.Engagement_Start__c, e.Engagement_End__c, e.Engagement_Country__c, e.Description__c, e.CreatedDate, e.CreatedById, e.ConnectionSentId, e.ConnectionReceivedId, e.Attitude_Rating__c, e.Account_Id__r.Resume__pc, e.Account_Id__r.PersonEmail, e.Account_Id__r.Phone, e.Account_Id__r.FirstName, e.Account_Id__r.LastName, e.Account_Id__r.Name, e.Account_Id__c 
                                          From Engagement__c e 
                                          WHERE e.Account_Id__c =: accountInfo.Id                                 
                                          AND e.Intrax_Program__c =: 'Internship'];
                        system.debug('***** Engagement: ' + engagementInfo[0].Name);                    
                        isAccountcreated = true;   
                    }                
                }catch(Exception e){
                    isAccountcreated = false;
                    system.debug('***** There is no associated Account for the current user.');
                }                             
                if(ApexPages.currentPage().getParameters().get('mId') != NULL){
                    system.debug('**************** DETAIL PAGE');
                    try{
                        matchInfo = [SELECT Hide_From_PT__c, Hide_From_Host__c, Marketing_Notes__c, Engagement__c, Participant_Id__c, Offer_Status__c,Interview_Status__c, Status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,Start_Date__c,End_Date__c,
                                     Position_Name__r.Supervisor_Role__c, Id, Name, Position_Name__r.Host_Company_Id__c,Position_Name__r.Position_Supervisor__r.Skype_ID__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name
                                     FROM Match__c
                                     WHERE Id=: ApexPages.currentPage().getParameters().get('mId') and Interview_status__c != 'Participant Declined Interview'
                                     order by Interview_Date__c DESC];   
                        
                        engagementInfo = [SELECT Id, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc FROM Engagement__c WHERE Id =: matchInfo.Engagement__c];
                        system.debug('***** Engagement: ' + engagementInfo); 
                        positionInfo = [SELECT p.CurrencyIsoCode, p.Intrax_Program_Category__c, p.Language_1__c, P.Language_1_Desirability__c, p.Language_1_Proficiency__c, p.Language_2__c, p.Language_2_Proficiency__c,p.Language_2_Desirability__c,p.Language_3__c, p.Language_3_Proficiency__c, P.Language_3_Desirability__c, p.Pay_Frequency__c, p.Title__c, p.Language_Level__c,p.Functional_Areas__c, p.Terminated_Count__c, p.SystemModstamp, p.Sys_Admin_Tag__c, p.Supervisor_Role__c, p.Street__c, p.Status__c, p.State__c, p.Skills_Required__c, p.Session__c, p.Regional_Location__c, p.Projects_of_Interest__c, 
                                        p.Postal_Code__c, p.Positions_Sold__c, p.Position_Types__c, p.Position_Supervisor__r.Name, p.Position_Count__c, p.Pending_Count__c, p.Pay_Rate__c, p.OwnerId, p.Occupational_Category__c, p.Name, p.Matched_Count__c, p.Marketing_Notes__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Intrax_Region__c, p.Intrax_Program__c, p.Intrax_Program_Options__c, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c,  p.Engagement_Start__c, p.Engagement_End__c, p.Employment_Hrs_Wk__c, p.Description__c, p.Departure_Date_Time__c, p.CreatedDate, p.CreatedById, p.Country__c, p.Countries_of_Interest__c, p.Coordinator__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Compensation_Type__c, p.City__c, p.Arrival_Departure_Phone__c, p.Arrival_Departure_Contact__c, p.Arrival_Departure_Contact_Depr__c, p.Arrival_Date_Time__c, Special_Notes__c
                                        FROM Position__c p
                                        WHERE p.Id =: matchInfo.Position_Name__c];
                        
                        companyInfo = [SELECT Id, Name, Website, NumberOfEmployees, Industry
                                       FROM Account
                                       WHERE Id =: positionInfo.Host_Company_Id__c];
                        system.debug('************* CompanyInfo: '+ CompanyInfo.Name);      
                    }catch(Exception e){
                        system.debug('*********** ' + e);
                    }
                }else{
                    system.debug('**************** GENERAL PAGE');
                    try{
                        matchInfoList =  [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                                          Name, Participant_Id__c, status__c,Summary__c, Offer_Status__c,CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c,     
                                          Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Regional_Location__c, Position_Name__r.Position_Supervisor__r.Name,Position_Name__r.Name, Position_Name__r.sAccount__r.Name 
                                          FROM Match__c 
                                          WHERE Engagement__c IN: engagementInfo
                                          and Interview_status__c!=null  order by Interview_Date__c DESC];
                        system.debug('****************matchInfoList: '+matchInfoList);
                        
                        ConfirmedMatches =  [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                                             Name, Participant_Id__c, status__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c,     
                                             Position_Name__r.Host_Company_Id__c,Offer_Status__c, Position_Name__r.Regional_Location__c, Position_Name__r.Position_Supervisor__r.Name,Position_Name__r.Name, Position_Name__r.sAccount__r.Name 
                                             FROM Match__c  
                                             WHERE engagement__c IN: engagementInfo
                                             AND Interview_Status__c = 'Scheduled' order by Interview_Date__c DESC];
                        
                        system.debug('******ConfirmedMatches*******'+ConfirmedMatches);
                        DateTime tillnow = System.now();
                        /*
OldMatches =   [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
Name, Participant_Id__c, status__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c,     
Position_Name__r.Host_Company_Id__c, Position_Name__r.Regional_Location__c, Position_Name__r.Position_Supervisor__r.Name,Position_Name__r.Name, Position_Name__r.sAccount__r.Name FROM Match__c 
WHERE engagement__c IN: engagementInfo
// MT 141 Changes
//AND Interview_Status__c IN ('Awaiting Decision', 'No Offer', 'Position Offered', 'Position Declined', 'Position Accepted', 'Company No Show', 'Participant No Show') and Interview_Date__c <=: tillnow];      
AND Interview_Status__c IN ('Completed', 'Company No Show', 'Participant No Show') and Interview_Date__c <=: tillnow];                              

*/
                    }       
                    
                    catch(Exception e){
                        
                        system.debug('*********** ' + e);
                    }
                }
            }
        }
        else{
            checkLogin();
        }
    }
    
    public void updateMatchInfo(List<MatchWrapper> lstmatch){
        Match__c match=new Match__c();  
        for(MatchWrapper matchwrap :lstmatch){
            match = [SELECT Id, Name, status__c,Offer_Status__c, Interview_Date__c,Interview_Request_Note__c,Interview_Response_Note__c,Interview_Status__c,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Host_Company_Id__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__c, Position_Name__r.sAccount__r.Name, Position_Name__r.sAccount__r.Industry__c
                     FROM Match__c WHERE id = :matchwrap.MatchId];
            
            if(ApexPages.currentPage().getParameters().get('confirm')=='true')
            {                               
                if(matchwrap.strSelectedResponse!=null)   
                {
                    system.debug('**************** matchwrap.strSelectedResponse***'+matchwrap.strSelectedResponse);                      
                    match.Interview_Date__c = DateTime.Parse(matchwrap.strSelectedResponse);
                    match.Interview_Status__c='Scheduled';
                    // MT 141 Changes
                    match.Offer_Status__c = null;
                    match.Interview_Response_Note__c = matchwrap.response;
                }                            
            }    
            
            if (ApexPages.currentPage().getParameters().get('SaveReqOther')=='true')
            {
                match.Interview_Date__c = null;
                //MT 141 Changes
                //match.Interview_Status__c = 'On Hold';
                match.Interview_Status__c = 'Needs Assistance';
                match.Offer_Status__c = null;
                
                match.Interview_Response_Note__c = matchwrap.response;
            }
            update match;
        }
        
    } 
    
    public PageReference SaveVisaDate()
    {
        //PageReference P = Page.igi_pt_visa_interview_dt;
        PageReference P = Page.igi_home;
        if (ApexPages.currentPage().getParameters().get('ActionType') != NULL && ApexPages.currentPage().getParameters().get('ActionType') == 'SaveInterviewDate')
        {
            upsert enggVisaDetails;
            list<Notification__c> ListNotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: EnggId AND Type__c = 'Visa Interview' AND Status__c = 'Not Started'];
            if(ListNotInfo.size() > 0)
            {
                for(Notification__c NotInfo:ListNotInfo)
                {
                    NotInfo.Status__c = 'Confirmed';
                }
                update ListNotInfo;
            }
            
            
            if (enggVisaDetails.Visa_Interview_Date__c <= date.today())
            {
                P = Page.igi_pt_visa_interview_status;
                P.getParameters().put('EnggId', EnggId);
            }
        }
        else if (ApexPages.currentPage().getParameters().get('ActionType') != NULL && ApexPages.currentPage().getParameters().get('ActionType') == 'SaveInterviewStatus')
        {
            if(enggVisaDetails.Visa_Interview_Status__c == 'Declined � Appealing Decision')
            {
                enggVisaDetails.Visa_Interview_Date__c = NULL;
            }
            upsert enggVisaDetails;
            list<Notification__c> ListNotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: EnggId AND Type__c = 'Visa Result' AND Status__c = 'Not Started'];
            if(ListNotInfo.size() > 0)
            {
                for(Notification__c NotInfo:ListNotInfo)
                {
                    NotInfo.Status__c = 'Confirmed';
                }
                update ListNotInfo;
            }
            if(enggVisaDetails.Visa_Interview_Status__c == 'Declined � Appealing Decision')
            {
                set<id> eid = new set<id>();
                eid.add(EnggId);
                Notification_Generator.sendIGINotifications(eid);
            }
            
        }
        p.setRedirect(true);
        return p;     
    }
    // Story B-01251
    public PageReference OrientationRedirect()
    {
        if(ApexPages.currentPage().getParameters().get('EnggParam') != NULL )
        {
            externalSystemOutage = IUtilities.scormOutage();
            
            if(externalSystemOutage != null)
            {
                System.debug('Outage is true. outage details ' +externalSystemOutage);
                Pagereference outagePage = page.scorm_outage;
                outagePage.setRedirect(false);
                return outagePage;
            } 
            return callScormService();
        }
        else
        {
            return null;
        }
    }
    
    
    public PageReference callScormService() {
        
        if(ApexPages.currentPage().getParameters().get('EnggParam') != null) {
            List<Scorm__c> scorm_Eng=new List<Scorm__c>();
            scorm_Eng = [Select Name,Complete_Status__c,result__c,Course_Id__c,Multi_Step_Course__c,Score__c,Learner_Id__c,Registration_Id__c,LearnerFirstName__c,LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,User_Profile__r.User__r.email,Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,Passed_Date__c ,Attempt_Count__c,Step_Number__c,Parent_Course_Name__c,Parent_Course_Name__r.Complete_Status__c From Scorm__c WHERE  
                         Engagement__c=: ApexPages.currentPage().getParameters().get('EnggParam')  order by CreatedDate desc];
            if(scorm_Eng.size()>0){
                sc=scorm_Eng[0];
                ScormWebService Scormobj= new ScormWebService();
                Scormobj.appId=sc.Scorm_Application_Id__c;
                Scormobj.courseId=sc.Course_Id__c;
                Scormobj.learnerId = sc.Learner_Id__c;
                Scormobj.learnerFirstName = sc.LearnerFirstName__c;
                Scormobj.learnerLastName=sc.LearnerLastName__c;
                PageReference returnUrl;
                If(sc.Registration_Id__c==null || sc.Registration_Id__c==''){
                    //Calling Regsitration Method
                    getRegistrationID =Scormobj.CreateRegistration();
                    system.debug('Registration id is'+getRegistrationID);
                    returnUrl=Scormobj.getLaunchUrl(getRegistrationID,sc.Id,false, Scormobj.appId);
                    sc.Registration_Id__c=getRegistrationID;
                    sc.HasLatestResult__c = false;
                    sc.Last_Scorm_Access__c=system.now();
                    update sc;
                    
                }
                else if(sc.Complete_Status__c=='completed' && sc.result__c=='passed')
                {
                    returnUrl=Scormobj.getLaunchUrl(sc.Registration_Id__c,sc.Id,true,sc.Scorm_Application_ID__c);
                    sc.HasLatestResult__c = true;
                    sc.Last_Scorm_Access__c=system.now();
                    update sc;
                    
                }
                else{
                    system.debug('debug::calling getLaunchUrl method');
                    //Callin getLaunchUrl Method
                    returnUrl=Scormobj.getLaunchUrl(sc.Registration_Id__c,sc.Id,false,sc.Scorm_Application_ID__c);
                    sc.HasLatestResult__c = false;
                    sc.Last_Scorm_Access__c=system.now();
                    update sc;
                    
                }
                list<Notification__c> lstOrientationNotify = [SELECT Status__c FROM Notification__c WHERE Engagement__c =: ApexPages.currentPage().getParameters().get('EnggParam') AND status__c ='Not Started' AND Type__c = 'Orientation'];
                
                if(lstOrientationNotify != NULL && lstOrientationNotify.size() > 0)
                {
                    for( Notification__c sinNotify: lstOrientationNotify)
                    {
                        sinNotify.Status__c = 'In Progress';
                    }
                    update lstOrientationNotify;
                }
                return returnurl; 
            }
            else
            {
                return null;
            }
        }
        else
        {
            return null;
        }
    }         
}