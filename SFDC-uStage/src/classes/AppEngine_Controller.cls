/*
Class: Intrax_AppEngine_Controller

Description: Master class to control the work flow of the intrax application engine

*/ 

/* Uncomment the following for removing SharisaveApplicationng (AYII-136)
//public without sharing class AppEngine_Controller{
and Comment
//public with sharing class AppEngine_Controller{
*/

public with sharing class AppEngine_Controller {
    
    //Initiate all two custom objects with list holders
    public static Boolean isTestMode = false;
    public Boolean docusignRefresh{get;set;}
    public boolean disablepromo{get; set;}
    //public Boolean SOR {get; set { value = false; } }    
    //public String CurrencyCode{get;set;}
    //public Decimal StartingPrice{get;set;}
    //Object Declaration
    public Applicant_Info__c applicantInfo{get; set;}
    public Communication__c communicationInfo{get; set;}
    public Person_Info__c personInfo{get;set;}
    public Person_Info__c parentInfo{get; set;} 
    public Essay__c EssayInfo{get;set;}
    public Essay__c EssayParentLetter{get;set;}
    public Essay__c EssayFamilyLetter{get;set;}
    public School__c schoolInfo{get;set;}
    public Location__c locationInfo{get;set;}
    public Person_Info__c familyInfo{get;set;}
    public Person_Info__c refererInfo{get;set;}
    public User user {get;set;}
    public User setUserType {get;set;}
    public String UserInterests{get;set;}
    public static Boolean isApexBeingTested = false;
    public  boolean blnother;
    Integer pageNumber = 1;
    Boolean isGoToFinalPage; 
    public Boolean isArrival {get; set;}
    public Boolean isVisaDocPageSubmitted{get; set;}
    public List<Account> accountInfo{get;set;}
    public Applicant_Info__c appCurrent{get; set;}
    public Boolean DoctorFormReviewed {get;set;}
    public Boolean BGCFormReviewed {get;set;}
    public Boolean SecondaryFormReviewed {get;set;} 
    //public Boolean LicenseExpires {get;set;}
    
    //Variable to hold the record for Experience and Position Info Objects
    public Experience__c experience{get; set;}
    public Experience__c experienceAPC{get; set;}
    public Position_Info__c positionInfo{get; set;}
    public Position_Info__c positionInfoSecond{get; set;}
    
    // Variables to hold the Education Info
    /* IGI App 2.0 */
    public Education__c educationInfo{get;set;}
    public list<Education__c> educationInfoList{get;set;}
    
    public map<integer, Education__c> educationMap{get;set;}    
    public map<integer,Person_Info__c> emergencyMap{get;set;}
    public map<integer,Experience__c> experienceMap{get;set;} 
    public map<integer,Person_Info__c> dependentsMap{get;set;}  
    
    public Group__c groupInfo{get;set;} 
    
    // APC Education
    public map<string,List<Education__c>> educationApcMap{get;set;}
    public map<string, Integer> educationSizeMap {get;set;}
    public map<Id,List<Intrax_Program_Upload__c>> DocmapEducation{get;set;}
    Public list<Intrax_Program_Upload__c> DocListEducation{get;set;}
    Public list<Intrax_Program_Upload__c> DocListSchool{get;set;}
    Public list<Intrax_Program_Upload__c> DocListUniversity{get;set;}
    Public list<Intrax_Program_Upload__c> DocListCertification{get;set;}
    
    
    //Variable for delete link
    public String experienceId{get;set;}
    public String locationId {get; set;}
    public String familyMemberId {get; set;}
    public String referenceId {get; set;}
    public String emergencyContactId {get; set;}
    
    //List Declaration
    public List<Communication__c> communicationInfoList{get; set;}
    public List<String> recordIds = new List<String>();
    public List<Account> portalAccounts;   
    public List<Person_Info__c> personInfoList;
    public List<Person_Info__c> parentInfoList{get;set;}
    public List<Essay__c> essayList{get;set;}
    public List<Person_Info__c> familyInfoList {get;set;}
    public List<Person_Info__c> refererInfoList {get;set;}
    public List<Person_Info__c> EmergencyInfoList{get;set;}  
    public List<Location__c> locationInfoList{get;set;}
    public List<Person_Info__c> comPersonInfoList {get;set;}
    public List<Applicant_Info__c> lstPartnerApp = new List<Applicant_Info__c>();
    public List<Applicant_Info__c> Applist = new List<Applicant_Info__c>();
    public List<Applicant_Info__c> AppListGeneral{get;set;}
    
    
    //Lists to hold the records for Experience and PositionInfo Objects
    public List<Experience__c> listExperience{get; set;}
    public List<Position_Info__c> listPositionInfo = new List<Position_Info__c>();
    public List<Position_Info__c> listPositionInfoSecond = new List<Position_Info__c>();
    
    //String to get ParticipantPicture from the URL
    
    public list<String> PicList;
    public String getPictureUrl{get;set;}
    
    // IGI 352
    public Position__c posInfo {get;set;}
    
    
    //Other Variable Declarations
    
    public List<String> listProgramCategories {get; set;}
    
    public String[] roles = new String[]{};
        public String[] views = new String[]{};
            public Integer dependentInfoListSize = 0; 
    public String did {get; set;}
    public datetime executionTime = datetime.now();
    public Boolean ETR {get; set { value = false; } }
    public Boolean SOR {get; set { value = false; } }
    public String EssayNarrative{get;set;}
    public String EssayLabel{get;set;}    
    public Blob body{get;set;}
    public String contentType{get; set;}
    public String fileName{get; set;}
    public String docGuid{get;set{docGuid=value;}}
    public boolean IsPartner{get;set;}
    public string strPersonInfoFirstName{get;set;}
    public string strPersonInfoLastName{get;set;}
    public string strPersonInfoEmail{get;set;}
    public String responseXML{get; set;}
    public String essayId{get;set{essayId=value;}}
    public String env{get;set{env=value;}}
    //public String fileUploadUrl{get;set{fileUploadUrl=Constants.fileUploadUrl;}}
    public String fileUploadUrl{get;set;}
    public String videoUploadUrl{get;set;}
    public Boolean disableFileUpload{get;set{disableFileUpload=Constants.disableFileUpload;}}
    public String disableFileUploadText{get;set{disableFileUploadText=Constants.disableFileUploadText;}}
    public String progId{get; set{progId=value;}}
    public String edu_id{get; set{edu_id=value;}}
    public String retParam {get;set;}
    public String idNeeded{get;set;} // Parameter created to specify wheter the Id parameter must be sent to the nex page or not
    
    // AWS Service Base URL
    public String awsWebBaseUrl {get{return Global_Constants__c.getInstance().AWS_Web_Base_Url__c;}}
    // AWS Video Service Base URL
    public String awsVideoWebBaseUrl {get{return EndPointGenerator.getEndpoint('videoWebBaseUrl');}}
    // Centers 
    public String ctrStudentPhoneNumber{get;set{ctrStudentPhoneNumber=Constants.CTR_STUDENT_PHONE_NUMBER;}}
    public String ctrLiveChat{get;set{ctrLiveChat=Constants.CTR_LIVE_CHAT;}}
    public String ctrSkype{get;set{ctrSkype=Constants.CTR_SKYPE;}}
    public String ctrPartnerPhoneNumber{get;set{ctrPartnerPhoneNumber=Constants.CTR_PARTNER_PHONE_NUMBER;}}
    public String ctrStudentEmail{get;set{ctrStudentEmail=Constants.CTR_STUDENT_EMAIL;}}
    public String ctrPartnerEmail{get;set{ctrPartnerEmail=Constants.CTR_PARTNER_EMAIL;}}
    public List<String> listProductDescription {get; set;}
    public String uploadDocDescription {get; set;}
    
    //Variable to get the value for Study Weeks
    public List<SelectOption> listStudyWeeksOptions {get; set;}
    public string selectedStudyWeeks{get;set;}
    public boolean isTestExecution {get; set;}
    
    //Variable to get the value for Service Level (IGI Application)
    public List<SelectOption> listServiceLevel {get; set;}
    public String selectedServiceLevel {get; set;}
    
    // Variable to cusotmize error messages on the VFPs
    public boolean customMessage {get;set;}
    //spillai video changes
    public String rtmpUrlVideo {get;set;}
    public String videotagfront {get;set;}
    public String videotagback {get;set;}
    
    //Centers Language Translations
    
    //Variable to hold the language parameter. This is passed ONLY from centers fileloader VF pages.
    public string lang;
    
    public string getLang(){
        User u = [SELECT Id,Name,languagelocalekey FROM User WHERE Id =: userInfo.getUserId() LIMIT 1];
        if(u!=null){
            lang = u.languagelocalekey;
            if(lang == 'es'){//Spanish
                lang='es_SP';
            }           
            else if(lang == 'pt_BR'){//Portuguese
                lang='pt_BR';
            }
            else
                lang='en_US';//English
        }
        else
            lang='en_US';
        
        if(lang=='' || lang==null)
            lang='en_US';
        
        System.debug('-----Lang:'+lang);
        return lang;
    }   
    
    public Component.Apex.OutputLabel getLabelPrice(string descr){
        Component.Apex.OutputLabel labelPrice = new Component.Apex.OutputLabel();
        labelPrice.escape=false;
        labelPrice.value = 'Label.T_0001'; //{!$Label.T_0001}
        return labelPrice;
    }
    
    
    // IGI App 2.0 Variables
    public string citizen{get;set;}
    public string currently_studying{get;set;}
    public string faculty_led_program{get;set;}
    public string igi_Visa_Status{get;set;}
    public string one_year_exp{get;set;}
    public string five_years_exp{get;set;}
    public string countryOfInterestSelected{get;set;}
    public list<SelectOption> countryOfInterestList{get;set;}
    public string paid_internship{get;set;}
    public string paid_internshipSecond{get;set;}
    
    //public String returnURL{get; set;}
    
    public string PartnerInvite{
        get{
        partnerinvite=ApexPages.currentPage().getParameters().get('partnerId');
        return partnerinvite;
        }
        set;
    }
    public string derivedBaseUrl{
        get{
            derivedBaseUrl = Constants.derivedbaseUrl;
            return derivedBaseUrl;
        }
        set;
    }
    
    //Properties  
    public Document document {
        get {
            if (document == null)
                document = new Document();
            return document;
        }
        set;
    }
    public Intrax_Program_Upload__c documentnew {
        get {
            if (documentnew == null)
                documentnew = new Intrax_Program_Upload__c();
            return documentnew;
        }
        set;
    }
    public String nextPage {get; set
    { 
        nextPage = value;
    }
                           }  
    
    public String reDirectPage {get; set
    {
        reDirectPage = value;
    }
                             }
    
    
    public String role {get; set
    {
        role = value;
        system.debug('********* Role Value =' + role);
    }
                       }
    
    public String clear {get; set
    {
        clear = value;
    }
                        }
    public String view {get; set
    {
        view = value;
    }
                       }
    public Boolean familyMember {get; set
    {
        familyMember = value;
    }
                                }
    public String retURL {get; set
    {
        retURL = value;
    }
                         }
    
    public Boolean isExperienced {get; set
    {
        isExperienced = value;
    }
                                 }
    
    public String add {get; set
    {
        add = value;
    }
                      }        
    public String app {get; set
    {
        app = value;
    }
                      }
    public String docType {get; set
    {
        docType = value;
    }
                          } 
    
    public String comtype {get; set
    {
        comtype = value;
    }
                          } 
    
    public String EssayType {get; set
    {
        EssayType = value;
    }
                            } 
    
    public String EssayUp {get; set
    {
        EssayUp = value;
    }
                          }
    
    public String partnerId {get; set
    {
        partnerId = value;
    }
                            }
    
    public String participantId {get; set
    {
        participantId = value;
    }
                                }
    
    // AA Education
    public String eduid {get; set
    {
        eduid = value;
    }
                        }     
    //This variable is to hold the photo document
    public Attachment photoDoc{get; set;}
    
    //Map to hold the custom setting values
    //Map<String, Site_Text__c> mapSiteTexts = new Map<String, Site_Text__c>();
    //public String siteTexts {get; set;}
    
    public AppEngine_Controller getAEC(){
        return this;
    }
    
    public void updateApplicantInfo(){
        system.debug('debug::update applicantInfo 1');
        update applicantInfo;
    }
    
    // IGI 352
    public list<Position__c> getPositionList () {
        list<Position__c> posList = [SELECT Id, Name, Engagement_Start__c, Program_year__c,Engagement_End__c, Intrax_Program__c FROM Position__c WHERE Intrax_Program__c =: 'Work Travel'];
        return posList;
    }
    // IGI 352
    public pageReference signUpForPosition(){
        return page.Positions;
    }
    
    public string getPartnerIntraxPrograms(){
        User u = [SELECT Contact.Account.Intrax_Programs__c FROM User WHERE Id =: userInfo.getUserId()];
        return String.valueOf(u.Contact.Account.Intrax_Programs__c);
    }
    
    //JOSE ADDING VALUE FOR APP Creation Page  B-02417
    public string getDefaultIP(){
        String value = '';
        User u = [SELECT Id, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id =: userInfo.getUserId()];
        if(u.Contact.PTR_Portal_Intrax_Program_Default__c != null){
            value = String.valueOf(u.Contact.PTR_Portal_Intrax_Program_Default__c);
        }
        system.debug('@@@@@getDefaultIP: ' + value);
        return value;
    }
    
    public pageReference validator(){
        // For now, we?ll only check here not to enter the primary contact twice in HF apps
        
        if(personInfo.First_Name__c == familyInfo.First_Name__c && personInfo.Last_Name__c == familyInfo.Last_Name__c && personInfo.Date_of_Birth__c == familyInfo.Date_of_Birth__c){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please do not list yourself in this section');
            ApexPages.addMessage(msg);
            customMessage = true;
            return null;
        }
        else {
            customMessage = false;
            return navigator();
        }
        
        
    }
    /*
    //B-02630 code added by Chris McFadden
    public void getValidatedPhoneNumber(){
        String rawPhoneInput = personInfo.Phone__c;
        if ((rawPhoneInput.length() >= 11) && (rawPhoneInput.substring(0,1) == '1')){
            personInfo.Phone__c = '(' + rawPhoneInput.substring(1,3) + ')' + ' ' + rawPhoneInput.substring(4,3) + '-' + rawPhoneInput.substring(7,4);
        }
        else if (rawPhoneInput.length() == 10){
            System.debug('personInfo.Phone__c value is: ' + personInfo.Phone__c);
            System.debug('personInfo.Phone__c length is: ' + personInfo.Phone__c.length());
            personInfo.Phone__c = '(' + rawPhoneInput.substring(0,3) + ')' + ' ' + rawPhoneInput.substring(3,3) + '-' + rawPhoneInput.substring(6,4);
        }
        else personInfo.Phone__c = null;        
    }
    */
    public pageReference PPvalidator()
    {
        integer ppvchk = 0;
        
        if ((applicantInfo.Intrax_Program__c == 'Work Travel') && applicantInfo.Engagement_Start__c != NULL && applicantInfo.Engagement_Start__c < Date.Today())
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date must be in the future');
            ApexPages.addMessage(msg);
            ppvchk = 1;
        }
        
        if ((applicantInfo.Intrax_Program__c == 'Work Travel') && applicantInfo.Engagement_Start__c != NULL && applicantInfo.Engagement_End__c != NULL && applicantInfo.Engagement_End__c < applicantInfo.Engagement_Start__c)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'End Date must be after Start Date');
            ApexPages.addMessage(msg);
            ppvchk = 1;
        }
        
        if ((applicantInfo.Intrax_Program__c == 'Work Travel') && applicantInfo.Engagement_Start__c != NULL && applicantInfo.Engagement_End__c != NULL)
        {
            date engst =  date.newinstance(applicantInfo.Engagement_Start__c.year()+ integer.valueof(Math.floor((applicantInfo.Engagement_Start__c.month() + 4 - 1) / 12)) , math.mod(applicantInfo.Engagement_Start__c.month() + 4 -1, 12) + 1 , applicantInfo.Engagement_Start__c.day());
            if (engst < applicantInfo.Engagement_End__c)  
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Program duration cannot be more than 4 months');
                ApexPages.addMessage(msg);
                ppvchk = 1;
            }
        }
        
        if (ppvchk == 1)
        {
            customMessage = true;
            return null;
        }
        else
        {
            customMessage = false;
            return navigator();
        }
    }
    
    public pageReference USStatevalidator(){
        
        string statelist = 'AL:AK:AZ:AR:CA:CO:CT:DE:DC:FL:GA:HI:ID:IL:IN:IA:KS:KY:LA:ME:MD:MA:MI:MN:MS:MO:MT:NE:NV:NH:NJ:NM:NY:NC:ND:OH:OK:OR:PA:RI:SC:SD:TN:TX:UT:VT:VA:WA:WV:WI:WY';
        
        if((positionInfo.Company_Country__c == 'United States' || positionInfo.Company_Country__c == 'USA') && positionInfo.Company_State__c.length() > 0 && (positionInfo.Company_State__c.length() > 2 || !statelist.contains(positionInfo.Company_State__c)))
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'State must be entered in two letter format');
            ApexPages.addMessage(msg);
            customMessage = true;
            return null;
        }
        else {
            customMessage = false;
            return navigator();
        }
        
        
    }
    
    public String getUrlPic(){
        
        getPictureUrl =  IUtilities.getParticipantPhoto(applicantInfo);
        //getPictureUrl =  PicList[0];
        
        // return getPictureUrl;
        
        return getPictureUrl;
        
        
    }
    
    public PageReference StageToInReview(){
        if(applicantInfo.Id != null){
            applicantInfo.Application_Stage__c = 'In-Review';
            try{
                update applicantInfo;
                system.debug('debug::update applicantInfo 2');
            }catch(Exception e){
                system.debug('********* Impossible to update Application Stage to In-Review: ' + e);
            }
        }
        PageReference p = new PageReference('/apex/pr_app_list');
        p.setRedirect(true);
        return p;
    }
    
    
    // Navigator Function -Acts as the starting point for every page.
    public PageReference navigator(){
        
        // ** APC- Preventing the user navigate in the application when the real Application_Stage__c = 'Submitted'. Problem with the cache when the user clicks back automaticatlly.
        //If is an APC App and is Submitted go directly to your_application      
        
        system.debug('***** Inside Navigator');
        system.debug('***** Application Owner'+applicantInfo.ownerId);
        system.debug('###### docType2: ' + docType );
        Applicant_Info__c applicantInfoStage = new Applicant_Info__c();
        
        Id aIdStage = ApexPages.currentPage().getParameters().get('Id');
        
        if(ApexPages.currentPage().getParameters().get('Id') != null) {            
            applicantInfoStage = [Select a.Id,a.Doctor_Form_Reviewed__c, a.Intrax_Program__c, a.Application_Stage__c, a.Application_Level__c, a.Type__c,a.Application_Type__c, a.Children_Indicated__c From Applicant_Info__c a where a.Id = :aIdStage]; 
            //applicantInfoStage = [Select a.Id,a.Doctor_Form_Reviewed__c, a.Intrax_Program__c, a.Application_Stage__c, a.Application_Level__c, a.Type__c,a.Application_Type__c From Applicant_Info__c a where a.Id = :aIdStage]; 
            
            String URLAux = ApexPages.currentPage().getUrl(); 
            
            //if you have already pay - submit your APC HF App to MAIN /WORKING, you are going to go to applications. Prevent the user to pay twice.
            
            if(applicantInfoStage.Type__c == 'Host Family' && applicantInfoStage.Application_Level__c == 'Main' && applicantInfoStage.Application_Stage__c == 'Working' && applicantInfoStage.Intrax_Program__c == 'AuPairCare'
               && applicantInfoStage.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true' 
               //&& applicantInfoStage.Application_Type__c == 'Orignal' 
               && URLAux.contains('/apex/apc_hf_app_payment')){ 
                   //system.debug('*****##Into redirection APC HF Main New APP Main/Basic' );
                   
                   PageReference p = Page.your_applications;
                   p.setRedirect(true);
                   return p;
                   
               }else if(applicantInfoStage.Application_Stage__c != 'Working' && userProfileName != 'OCPM Agent Portal' && applicantInfoStage.Intrax_Program__c == 'AuPairCare' && applicantInfoStage.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true'){  
                   //system.debug('*****##Into redirection APC Main / Working' );
                   
                   //if you have already pay - submit your APC HF App or submit you APC PT, you are going to go to applications. Prevent the user to pay twice.
                   
                   PageReference p = Page.your_applications;
                   p.setRedirect(true);
                   return p;
               }
            
            else if (URLAux.contains('/apex/apc_ap_basic_personal_info') && applicantInfoStage.Type__c == 'Participant' && applicantInfoStage.Intrax_Program__c == 'AuPairCare')
            {
                if(personInfo != NULL)
                {
                    //if (personInfo.Citizenship__c == 'United States' && personInfo.Country_of_Residence__c == 'United States' && personInfo.Marital_Status__c == 'Married' && applicantInfoStage.Children_Indicated__c == 'Yes')
                    //{
                    Decimal APCPTAge = 0;
                    APCPTAge = personInfo.Date_Of_Birth__c.daysBetween(Date.Today())/365.2425;
                    if(personInfo.Date_Of_Birth__c.day() == Date.Today().day() && personInfo.Date_Of_Birth__c.month() == Date.Today().month() )
                    {
                        APCPTAge = Math.round(APCPTAge);  
                    }
                    system.debug('personInfo.Citizenship__c'+personInfo.Citizenship__c);
                    system.debug('personInfo.Country_of_Residence__c'+personInfo.Country_of_Residence__c);
                    system.debug('personInfo.Marital_Status__c'+personInfo.Marital_Status__c);
                    system.debug('applicantInfoStage.Children_Indicated__c'+applicantInfoStage.Children_Indicated__c);
                    system.debug('APCPTAge'+APCPTAge);
                    
                    if (personInfo.Citizenship__c == 'United States' || personInfo.Country_of_Residence__c == 'United States' || personInfo.Marital_Status__c == 'Married' || applicantInfo.Children_Indicated__c == 'Yes' || APCPTAge >= 27 || APCPTAge < 16)
                    {
                        applicantInfo.Application_Stage__c = 'Declined';
                        update applicantInfo;
                        system.debug('debug::update applicantInfo 3');
                        update personInfo;
                        PageReference p = new PageReference('/apex/pt_noservice?id='+aIdStage+'&viewpage=true');
                        p.setRedirect(true);
                        return p;
                    }
                    //}
                }
            }
        }
        
        system.debug('***** Application Owner'+applicantInfo.ownerId);
        // **EnD
        
        String ErrorMessage = '';
        Boolean blnRoleChk =false;
        integer month = 0;
        
        try{
            
            /*Code commented to use listUSArrivalDates in apc_hf_app_program_pref*/
            /*
//transform APC month Arrival to a date
if(applicantInfo.Month_Arrival__c !=null){

month = integer.valueOf(applicantInfo.Month_Arrival__c);

if(month <= date.today().month()){

applicantInfo.Engagement_Start__c = date.newinstance(date.today().year() + 1, month, 1);

}else{

applicantInfo.Engagement_Start__c = date.newinstance(date.today().year(), month, 1);
}           
}*/
            
            //Map to hold the Queue Name as a Key and Queue Id as Value
            Map<String, Id> maptoHoldQueueNameWithQueueID = new Map<String, Id>();
            
            /* Uncomment the following for removing Sharing (AYII-136)    
// Fetching Queue id for logged in user.
/* List<QueueSobject> lstQue =[Select Id, Queue.Name, Queue.ID from QueueSobject WHERE Queue.Name =: Constants.QUEUE_NAME OR Queue.Name =: Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE OR Queue.name=:Constants.QUEUE_NAME_IGI ];

//Loop through List of Queue
for(QueueSobject que : lstQue) {

//Populating Map with Values
maptoHoldQueueNameWithQueueID.put(que.Queue.Name, que.Queue.Id);
}*/
            // Uncomment the above for removing Sharing (AYII-136)
            
            // Saving when the applicant last touched the current application
            
            if(applicantInfo.Last_Applicant_Update__c == null || (!datetime.now().isSameDay(applicantInfo.Last_Applicant_Update__c) && applicantInfo.CreatedById == userInfo.getUserId() )){
                applicantInfo.Last_Applicant_Update__c = datetime.now();
            }
            
            system.debug('***** ' + ApexPages.currentPage().getParameters().get('partnerApp'));
            if(ApexPages.currentPage().getParameters().get('partnerApp') != null){
                try{
                    system.debug('***** app: ' + applicantInfo.Id + ' ' + applicantInfo.Email__c);
                    // We need to check whether we already have an application using this email... 
                    //list<Applicant_Info__c> appCheck = [SELECT Id, email__c, engagement__c, application_stage__c FROM Applicant_info__c WHERE (application_stage__c =: 'Working' or application_stage__c =: 'Submitted' or application_stage__c =: 'In-Review')];
                    list<Person_Info__c> personCheck;
                    list<Engagement__c> personCheckEng;
                    boolean AcceptAppEng =false;
                    
                    personCheck = [SELECT Id, Email__c, Primary_Applicant__c, Applicant_Info__c, Applicant_Info__r.Application_Stage__c,Applicant_Info__r.engagement__c,Applicant_Info__r.Engagement__r.status__c
                                   FROM Person_Info__c 
                                   WHERE Email__c =: applicantInfo.Email__c and Primary_Applicant__c =: true
                                   and (Applicant_Info__r.application_stage__c =: 'Working' or Applicant_Info__r.application_stage__c =: 'Accepted' or Applicant_Info__r.application_stage__c =: 'Submitted' or Applicant_Info__r.application_stage__c =: 'In-Review') LIMIT 1];
                    
                    system.debug('*****personCheck*****'+personCheck[0]);
                    if(personCheck!=null && personCheck[0].Applicant_Info__r.application_stage__c == 'Accepted')
                    {
                        system.debug('*****personCheck[0].Applicant_Info__r.engagement__c*****'+personCheck[0].Applicant_Info__r.engagement__c);     
                        system.debug('*****personCheck[0].Applicant_Info__r.Engagement__r.status__c*****'+personCheck[0].Applicant_Info__r.Engagement__r.status__c);                    
                        if(personCheck[0].Applicant_Info__r.engagement__c!=null)
                        {
                            Id engid = personCheck[0].Applicant_Info__r.engagement__c;
                            system.debug('*****engid*****'+engid );
                            personCheckEng = [SELECT Id, status__c FROM engagement__c WHERE id =:engid];
                            if(personCheckEng!=null && personCheckEng.size()>0) 
                            {
                                if(personCheckEng[0].status__c=='New' || personCheckEng[0].status__c=='Processing' || personCheckEng[0].status__c=='Program Ready' || personCheckEng[0].status__c=='On Program' )                 
                                    AcceptAppEng=true;
                                
                            }}}
                    
                    // system.debug('*****personCheckEng.Size()*****'+personCheckEng.Size());
                    if((personCheck!=null && personCheck.Size() > 0 && personCheck[0].Applicant_Info__r.application_stage__c != 'Accepted') || (personCheck!=null && personCheck.Size() > 0 && personCheck[0].Applicant_Info__r.application_stage__c == 'Accepted' && AcceptAppEng==true)){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Application already exists for a user with this email address for this Program Year.');
                        ApexPages.addMessage(msg);
                        return null;
                    }
                }catch(Exception e){
                    system.debug('**** Impossible to save Partner Id to related applicant');
                }
            }
            
            String pageURL = ApexPages.currentPage().getUrl(); 
            //B-02269 JOSE
            if(pageURL != NULL && pageURL.contains('/apex/apc_ap_main_health_review')){
                try{
                    if(DoctorFormReviewed!=NULL && DoctorFormReviewed==true){
                        applicantInfo.Doctor_Form_Reviewed__c = date.today();
                    }else{
                        applicantInfo.Doctor_Form_Reviewed__c = null;
                    }
                }
                catch(Exception e){
                    system.debug('**** Impossible to save Doctor Form Health Review');
                }
            }
            
            //B-02553 JOSE
            if(pageURL != NULL && pageURL.contains('/apex/apc_ap_main_bgc_review')){
                try{
                    if(BGCFormReviewed!=NULL && BGCFormReviewed==true){
                        applicantInfo.BGC_Reviewed__c = date.today();
                    }else{
                        applicantInfo.BGC_Reviewed__c = null;
                    }
                }
                catch(Exception e){
                    system.debug('**** Impossible to save BGC DATE Review');
                }
            }
            
            //B-02556 JOSE
            if(pageURL != NULL && pageURL.contains('/apex/apc_ap_main_secondary_review')){
                try{
                    if(SecondaryFormReviewed!=NULL && SecondaryFormReviewed==true){
                        applicantInfo.Graduation_Verified__c = date.today();
                    }else{
                        applicantInfo.Graduation_Verified__c = null;
                    }
                }
                catch(Exception e){
                    system.debug('**** Impossible to save Sacondary DATE Review');
                }
            }
            
            //B-02598 Chris
            if(pageURL != NULL && pageURL.contains('/apex/apc_ap_main_driving_experience')){
                try{
                    if(applicantInfo.Drivers_Licence_Expires_Indicated__c==false){
                        
                    }else{
                        applicantInfo.Drivers_Licence_Expires__c = null;
                    }
                }
                catch(Exception e){
                    system.debug('**** Impossible to save Sacondary DATE Review');
                }
            }
            
            //B-02630 Chris
            if(pageURL != NULL && pageURL.contains('/apex/apc_hf_app_employer')){
                try{
                        if(personInfo.Marital_Status__c == 'Married' || personInfo.Marital_Status__c == 'Domestic Partner'){
                            upsert personRole;
                        }
                        upsert personInfo;
                }
                catch(Exception e){
                    System.debug('Validation error: ' +e);
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error: ' +e);
                    ApexPages.addMessage(msg);
                    customMessage = true;
                    return null;
                }
            }
            
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            system.debug('***** ' + ApexPages.currentPage().getParameters().get('partnerId'));
            if(ApexPages.currentPage().getParameters().get('partnerId') != null){
                try{
                    applicantInfo.Partner_Intrax_Id__c = ApexPages.currentPage().getParameters().get('partnerId');
                }catch(Exception e){
                    system.debug('**** Impossible to save Partner Id to related applicant');
                }
            }
            else if(ApexPages.currentPage().getParameters().get('UniversityId') != null){
                try{
                    
                    list<Account> UniversityAcctInfo = [SELECT Id, Name, Intrax_Id__c, Intrax_Programs__c, type FROM Account WHERE  Intrax_Id__c =: ApexPages.currentPage().getParameters().get('UniversityId') and type = 'Institution'];
                    if (UniversityAcctInfo != NULL && UniversityAcctInfo.size() > 0)
                    {
                        applicantInfo.School_Id__c = UniversityAcctInfo[0].id;
                    }
                }catch(Exception e){
                    system.debug('**** Impossible to save University Id to related applicant');
                }
            }
            //B-01633  (Start)
            else if (applicantInfo.Partner_Intrax_Id__c == null && applicantInfo.RecordType.Name == 'Work Travel PT' && applicantInfo.Account__c != NULL)
            {
                //list<Applicant_Info__c> existAppLst = [SELECT Partner_Intrax_Id__c FROM Applicant_Info__c WHERE Email__c = :applicantInfo.Email__c AND Application_Stage__c =: 'Accepted' AND RecordType.Name =: 'Work Travel PT' order by createdDate DESC];
                //D-01214 (Start)
                list<Applicant_Info__c> existAppLst = [SELECT Partner_Intrax_Id__c FROM Applicant_Info__c WHERE Account__c = :applicantInfo.Account__c AND Partner_Intrax_Id__c != NULL AND Application_Stage__c =: 'Accepted' AND RecordType.Name =: 'Work Travel PT' order by createdDate DESC];
                if (existAppLst != NULL && existAppLst.size() >0)
                {
                    applicantInfo.Partner_Intrax_Id__c = existAppLst[0].Partner_Intrax_Id__c;
                }
            }
            //B-01633  (End) 
            
            if(ApexPages.currentPage().getParameters().get('EC') != null){
                if(ApexPages.currentPage().getParameters().get('EC') == 'Partner') 
                    applicantinfo.Enquiry_Channel__c = 'Partner';            
            }
            
            if(ApexPages.currentPage().getParameters().get('IPO') != null){
                try{    
                    applicantInfo.Intrax_Program_Options__c = ApexPages.currentPage().getParameters().get('IPO');
                }catch(Exception e){
                    system.debug('**** Impossible to save especified IPO to related applicant');
                }
            }
            
            if(ApexPages.currentPage().getParameters().get('slevel') != null){
                try{
                    //string slevel = ApexPages.currentPage().getParameters().get('slevel');
                    //system.debug('***** slevel: ' + slevel);
                    //if(IUtilities.isIncluded(applicantInfo.Service_Level__c, slevel))
                    applicantInfo.Service_Level__c = ApexPages.currentPage().getParameters().get('slevel');
                }catch(Exception e){
                    system.debug('**** Impossible to save especified Service Level to related applicant');
                }
            }
            
             //B-02904
            if(applicantInfo.RecordType.Name == 'ICD Intern PT' || applicantInfo.RecordType.Name == 'PW Participant' || applicantInfo.RecordType.Name == 'Work Travel PT' || applicantInfo.RecordType.Name== 'AuPairCare PT' || applicantInfo.RecordType.Name== 'AuPairCare HF'){
                system.debug('debug::saveUserInfo');
                saveUserInfo();
            }
            
            if(applicantInfo.RecordType.Name == 'Work Travel PT'){
                //Populating Service Level with respect to the user selection (Yes/No)
                if(selectedServiceLevel != null && selectedServiceLevel != '' && selectedServiceLevel == Constants.YES) {
                    applicantInfo.Service_Level__c = 'Independent';
                } 
                
                else if(selectedServiceLevel != null && selectedServiceLevel != '' && selectedServiceLevel == Constants.NO) {
                    applicantInfo.Service_Level__c = 'Premium';
                } 
                if(IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c, 'ProWorld Internship') || 
                   IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c, 'WEST') ||
                   IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c, 'Practical Training')) {
                       applicantInfo.Service_Level__c = 'Premium';
                   }            
            }       
            
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            //Populating Applicant Info OwnerId field in case of Intrax Centers Online Application  
            /* Uncomment the following for removing Sharing (AYII-136)
/*if(applicantInfo.RecordType.Name == 'Centers' || app == 'Centers') {

System.debug('Please Enter in this Loop' + applicantInfo.RecordType.Name);

//Checking presence of value in map
if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE) && applicantInfo.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE)) {

//Populating Account Info Owner Id Field with Queue ID
applicantInfo.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_INTRAX_CENTERS_ONLINE);  
}  
} 
ELSE if(applicantInfo.RecordType.Name == 'ICD Intern PT' || app == 'IGI' || applicantInfo.recordType.Name == 'Work Travel PT') {

System.debug('Please Enter in this Loop' + applicantInfo.RecordType.Name);

//Checking presence of value in map
if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_NAME_IGI  ) && applicantInfo.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_IGI  )) {

//Populating Account Info Owner Id Field with Queue ID
applicantInfo.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME_IGI );  
}  
}

//Populating Applicant Info OwnerId field in case of Ayusa Applications
else {

System.debug('Please Enter in this Loop' + applicantInfo.RecordType.Name);

//Checking presence of value in map
if(maptoHoldQueueNameWithQueueID.containsKey(Constants.QUEUE_NAME) && applicantInfo.OwnerId != maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME)) {

//Populating Account Info Owner Id Field with Queue ID
applicantInfo.OwnerId = maptoHoldQueueNameWithQueueID.get(Constants.QUEUE_NAME);  
} 
}*/
            // Uncomment the above for removing Sharing (AYII-136)
            
            
            //APC - Checking AuPairPreferences and putting to null the field doesn't apply
            
            if(ApexPages.currentPage().getParameters().get('AuPairPref') == 'true'){
                
                if(applicantInfo.Aupair_Preferences__c == 'Country'){                
                    applicantInfo.Language_Preferences__c = null;                
                }else if(applicantInfo.Aupair_Preferences__c == 'Language') {                    
                    applicantInfo.Countries_of_Interest__c = null;                    
                }
            }           
            
            //Calling Method for Processing Experience records 
            
            if(experience.Employer_Name__c != null || experience.First_Name__c != null)  {
                system.debug('******into saveExperience');
                saveExperience();                
            }
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            system.debug('*********** PAGE ID: ' + ApexPages.currentPage().getParameters().get('PageId')  );
            
            // IGI App Specific Actions - Determined by PageId
            if(applicantInfo.Intrax_Program__c == 'Internship'){
                
                if(applicantInfo.Application_Level__c == 'Main'){
                    if (paid_internship == 'No'){
                        positionInfo.Pay_Rate__c = null;
                        positionInfo.CurrencyIsoCode = null;
                        positionInfo.Pay_Rate_Basis__c = null;
                        positionInfo.Tipped_Position__c = null;
                    }
                    if (paid_internshipSecond == 'No'){
                        positionInfoSecond.Pay_Rate__c = null;
                        positionInfoSecond.CurrencyIsoCode = null;
                        positionInfoSecond.Pay_Rate_Basis__c = null;
                        positionInfoSecond.Tipped_Position__c = null;
                    }
                }                   
                
                applicantInfo.Visa_Category__c = '';
                applicantInfo.Visa_Type__c = '';
                applicantInfo.US_Domestic_Participant__c = false;
                if(personInfo.Citizenship__c != 'United States' && applicantInfo.Country_of_Interest__c == 'United States'){                    
                    if(personInfo.Country_of_Residence__c == 'United States'){
                        if(igi_visa_status != null && igi_visa_status != ''){
                            
                            if(igi_visa_status == 'no_need_visa'){
                                applicantInfo.Visa_Category__c = 'Student (F)';
                                applicantInfo.Visa_Type__c = 'F-1 Student';
                                applicantInfo.Sevis_Program__c = null;
                                if(!IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training')){
                                    if(IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Internship - J1')) {
                                        applicantInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c.Replace('Internship - J1', 'Practical Training');
                                    }else if(applicantInfo.Intrax_Program_Options__c == null){ 
                                        applicantInfo.Intrax_Program_Options__c = 'Practical Training'; 
                                    }                       
                                    else {
                                        applicantInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c + ';' +  'Practical Training';
                                    }                               
                                }
                            }else if(igi_visa_status == 'need_visa'){
                                applicantInfo.Visa_Category__c = 'Intern (J)';
                                applicantInfo.Visa_Type__c = 'J-1';
                                if(applicantInfo.One_Year_Work_Experience__c == true || applicantInfo.Five_Years_Work_Experience__c == true){
                                    applicantInfo.Sevis_Program__c = '14-Trainee';
                                }else applicantInfo.Sevis_Program__c = '15-Intern';                       
                            }     
                            
                        } 
                    }
                    
                    else{
                        applicantInfo.Visa_Category__c = 'Intern (J)';
                        applicantInfo.Visa_Type__c = 'J-1';
                        if(applicantInfo.One_Year_Work_Experience__c == true || applicantInfo.Five_Years_Work_Experience__c == true){
                            applicantInfo.Sevis_Program__c = '14-Trainee';
                        }else applicantInfo.Sevis_Program__c = '15-Intern';
                        
                        if(applicantInfo.Service_Level__c == 'Independent'){
                            if(!IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Internship - J1'))   {
                                if(IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training')) {
                                    applicantInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c.Replace('Practical Training', 'Internship - J1');
                                }else if(applicantInfo.Intrax_Program_Options__c == null){
                                    applicantInfo.Intrax_Program_Options__c = 'Internship - J1';
                                }else{ 
                                    applicantInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c + ';' +  'Internship - J1';
                                }                               
                            }
                        }else{
                            if(IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Internship - J1')){
                                applicantInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c.Replace('Internship - J1', '');
                            }
                        }
                    }
                } else if(personInfo.Citizenship__c == 'United States' && applicantInfo.Country_of_Interest__c == 'United States'){
                    applicantInfo.Visa_Category__c = '';
                    applicantInfo.Visa_Type__c = '';
                    applicantInfo.US_Domestic_Participant__c = true;
                    if(IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Internship - J1')){
                        applicantInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c.Replace('Internship - J1', '');
                    }
                }
                
                system.debug('******* Setting faculty_led_program: ' + faculty_led_program);
                
                if(faculty_led_program == 'Yes'){
                    if(applicantInfo.Intrax_Program_Options__c == null){
                        applicantInfo.Intrax_Program_Options__c = 'Internship Group';
                    }else if(!IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Internship Group')){
                        applicantInfo.Intrax_Program_Options__c += ';' + 'Internship Group';
                    }
                }else if(faculty_led_program == 'No'){
                    if(IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Internship Group')){
                        applicantInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c.Replace('Internship Group', '');
                    }
                }                   
                
            }
            
            // Validating IGI - Basic APp            
            if(applicantInfo.Application_Level__c == 'Basic' && applicantInfo.Intrax_Program__c == 'Internship'){
                system.debug('******* personInfo*********** ' + personInfo);
                applicantInfo.Validation_Failure_Reason__c = '';                    
                
                if(applicantInfo.Engagement_Start__c != null && personInfo.Date_Of_Birth__c.daysBetween(applicantInfo.Engagement_Start__c) < 18*365.2425  ){
                    if(!applicantInfo.Validation_Failure_Reason__c.contains('Participant age is under 18')){
                        applicantInfo.Validation_Failure_Reason__c = 'Participant age is under 18';
                    }                       
                }
                
                if (applicantInfo.Engagement_Start__c != null && applicantInfo.Engagement_Start__c < (date.today()+90) && applicantInfo.Service_Level__c == 'Premium') {
                    if(applicantInfo.Validation_Failure_Reason__c == ''){
                        if((applicantInfo.US_Domestic_Participant__c) || (IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training')))
                            applicantInfo.Validation_Failure_Reason__c = '';
                        else
                            applicantInfo.Validation_Failure_Reason__c = 'Premium PT - Engagement Start  < 90 days';
                    } else{ 
                        if((applicantInfo.US_Domestic_Participant__c) || (IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training')))
                            applicantInfo.Validation_Failure_Reason__c += '';
                        else 
                            applicantInfo.Validation_Failure_Reason__c += ' / Premium PT - Engagement Start  < 90 days';                            
                    }                       
                }
                if (applicantInfo.Engagement_Start__c != null && applicantInfo.Engagement_Start__c < (date.today()+60) && applicantInfo.Service_Level__c == 'Independent'){
                    if(applicantInfo.Validation_Failure_Reason__c == ''){
                        if((applicantInfo.US_Domestic_Participant__c) || (IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training')))
                            applicantInfo.Validation_Failure_Reason__c = '';
                        else 
                            applicantInfo.Validation_Failure_Reason__c = 'Independent PT - Engagement Start  < 60 days';
                        
                    } else{
                        if((applicantInfo.US_Domestic_Participant__c) || (IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training')))
                            applicantInfo.Validation_Failure_Reason__c += '';
                        else 
                            applicantInfo.Validation_Failure_Reason__c += ' / Independent PT - Engagement Start  < 60 days';                         
                        
                    }                       
                }
                
                // B-01538: Adding extra validation for the basic app
                // Validating Program Duration  
                
                map<String, Program_Duration__c> igi_map = Program_Duration__c.getall();
                for(Program_Duration__c ipd : igi_map.values()){
                    if(ipd.Country__c == applicantInfo.Country_of_Interest__c && ipd.Category__c == applicantInfo.Intrax_Program_Category__c){
                        if((applicantInfo.US_Domestic_Participant__c) || (IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training'))){
                            if(applicantInfo.Validation_Failure_Reason__c == '') applicantInfo.Validation_Failure_Reason__c = '';
                            else applicantInfo.Validation_Failure_Reason__c += '';
                        }
                        else if(applicantInfo.Country_of_Interest__c == 'United States'){
                            if(IUtilities.IsIncluded(applicantInfo.Intrax_Program_Options__c, ipd.Intrax_Program_Option__c) || IUtilities.IsIncluded(applicantInfo.Sevis_Program__c, ipd.Sevis_Program__c)){
                                if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) > ipd.max_Duration__c){
                                    if(applicantInfo.Validation_Failure_Reason__c == '') applicantInfo.Validation_Failure_Reason__c = 'Duration selected exceed maximum allowed';
                                    else applicantInfo.Validation_Failure_Reason__c += ' / Duration selected exceed maximum allowed';
                                }else if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) < ipd.min_Duration__c){
                                    if(applicantInfo.Validation_Failure_Reason__c == '') applicantInfo.Validation_Failure_Reason__c = 'Duration selected does not meet the minimum required';
                                    else applicantInfo.Validation_Failure_Reason__c += ' / Duration selected does not meet the minimum required';
                                }
                            }
                        }else{
                            if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) > ipd.max_Duration__c){
                                if(applicantInfo.Validation_Failure_Reason__c == '') applicantInfo.Validation_Failure_Reason__c = 'Duration selected exceed maximum allowed';
                                else applicantInfo.Validation_Failure_Reason__c += ' / Duration selected exceed maximum allowed';
                            }else if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) < ipd.min_Duration__c){
                                if(applicantInfo.Validation_Failure_Reason__c == '') applicantInfo.Validation_Failure_Reason__c = 'Duration selected does not meet the minimum required';
                                else applicantInfo.Validation_Failure_Reason__c += ' / Duration selected does not meet the minimum required';
                            }
                        }                           
                    }
                }
                
                // Validating Graduation Date                                        
               /* if(EducationInfo.Id != null && educationInfo.Graduation_date__c != null && (educationInfo.Graduation_Date__c.monthsBetween(date.today()) > 6) && applicantInfo.Currently_Studying__c == 'No' && applicantInfo.One_Year_Work_Experience__c == false && applicantInfo.Five_Years_Work_Experience__c == false){
                    if(applicantInfo.Validation_Failure_Reason__c == '') applicantInfo.Validation_Failure_Reason__c = 'Out of school for too long to be an intern / does not have enough work experience to be a trainee';
                    else applicantInfo.Validation_Failure_Reason__c += ' / Out of school for too long to be an intern - does not have enough work experience to be a trainee';              
                } */
                
                if( EducationInfo.Id != null && ((educationInfo.Graduation_date__c != null && applicantInfo.Engagement_Start__c!=null &&  (educationInfo.Graduation_Date__c.daysBetween(applicantInfo.Engagement_Start__c) > 365) ) || (educationInfo.Institution_Type__c!=null && educationInfo.Institution_Type__c.equals('High/Secondary School')))  && 
                    ((applicantInfo.One_Year_Work_Experience__c == false && applicantInfo.Five_Years_Work_Experience__c == false)  || (applicantInfo.Five_Years_Work_Experience__c == false && educationInfo.Institution_Type__c!=null && educationInfo.Institution_Type__c.equals('High/Secondary School'))) ) 
                {
                 if(applicantInfo.Validation_Failure_Reason__c == '')     applicantInfo.Validation_Failure_Reason__c = 'Out of school for too long to be an intern / does not have enough work experience to be a trainee';
                    else applicantInfo.Validation_Failure_Reason__c += ' / Out of school for too long to be an intern / does not have enough work experience to be a trainee';              
                }
                
                system.debug('***** Application Owner'+applicantInfo.ownerId);
                // Premium - Independent - Intrax offers Services?                
                //map<String, Lead_Routing__c> igi_lr_map = Lead_Routing__c.getall();
                list<LeadRouting__c> igi_lr_map = new list<LeadRouting__c>();
                igi_lr_map = [select Id, Name, Country_of_Interest__c, Country_of_Origin__c, Intrax_Program__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, Program__c, Queue__c, Routing_Group__c from LeadRouting__c where NewRule__c = false];
                boolean not_serviced = false;
                //for(Lead_Routing__c lr : igi_lr_map.values()){     
                for(LeadRouting__c lr : igi_lr_map){             
                    // Here we are talking...
                    if(applicantInfo.Country_of_Interest__c == 'United States' && applicantInfo.Service_Level__c == 'Premium'){
                        if(lr.Program__c == 'Internship'){                  
                            if(lr.Country_of_Origin__c == personInfo.Country_of_Residence__c && (lr.Country_of_Interest__c == 'United States' || lr.Country_of_Interest__c == '')){
                                if(lr.Queue__c == 'Not Serviced') {
                                    not_serviced = true;
                                    break;
                                }
                            }
                        }
                    } else if(applicantInfo.Country_of_Interest__c == 'United States' && applicantInfo.Service_Level__c == 'Premium'){
                        if(lr.Program__c == 'Internship - J1'){                 
                            if(lr.Country_of_Origin__c == personInfo.Country_of_Residence__c && (lr.Country_of_Interest__c == 'United States' || lr.Country_of_Interest__c == '')){
                                if(lr.Queue__c == 'Not Serviced') {
                                    not_serviced = true;
                                    break;
                                }
                            }
                        }
                    } else if(applicantInfo.Country_of_Interest__c != 'United States'){
                        if(lr.Country_of_Origin__c == personInfo.Country_of_Residence__c && (lr.Country_of_Interest__c == applicantInfo.Country_of_Interest__c || lr.Country_of_Interest__c == '')){
                            if(lr.Queue__c == 'Not Serviced'){ 
                                not_serviced = true;
                                break;
                            }
                        }
                    }
                    
                }
                
                if(not_serviced == true){
                    if(applicantInfo.Validation_Failure_Reason__c == '') applicantInfo.Validation_Failure_Reason__c = 'Service not available in the specified country';
                    else applicantInfo.Validation_Failure_Reason__c += ' / Service not available in the specified country';               
                }
                
                
            }
            
            if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.Prior_Exchange_Experience__c == 'No'){
                applicantInfo.Prior_Exchange_Visa__c = '';
                applicantInfo.Prior_Visa_Start_Date__c = null;
                applicantInfo.Prior_Visa_End_Date__c = null;
            }
            
            if(applicantInfo.Intrax_Program__c == 'Internship' && citizen == 'Yes'){
                personInfo.Citizenship__c = personInfo.Country_of_Residence__c;
            }
            
            if(applicantInfo.Intrax_Program__c == 'Internship'){
                if(one_year_exp == 'Yes') applicantInfo.One_Year_Work_Experience__c = true;
                else if(one_year_exp == 'No') applicantInfo.One_Year_Work_Experience__c = false;
                
                if(five_years_exp == 'Yes') applicantInfo.Five_Years_Work_Experience__c = true;
                else if(five_years_exp == 'No') applicantInfo.Five_Years_Work_Experience__c = false;
            }
            
            if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.Work_Experience_Indicated__c == 'No'){
                removeExperienceRecords();
            }
            if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.J2_Dependent_Indicated__c == 'No'){
                removeDependentsRecords();
            }
            
            if(applicantInfo.RecordType.Name=='AuPairCare PT' && ApexPages.currentPage().getParameters().get('pageId')=='020'){
                system.debug('Inside saveEducationApc');
                saveEducationApc();
            }
            system.debug('before saveAuPairExperience');
            if(applicantInfo.RecordType.Name=='AuPairCare PT' && applicantInfo.Application_Type__c=='Renewal'&& ApexPages.currentPage().getParameters().get('pageId')=='050'){
                system.debug('Inside saveAuPairExperience');
                //if (applicantInfo.Engagement__c !=null)
                saveAuPairExperience();
            }
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            system.debug('*****@@@before saveExperienceDet()');
            //always save the childre of Experience Details after save the experience record.
            if(ApexPages.currentPage().getParameters().get('saveExperienceDetail') == 'true'){
                
                system.debug('*****@@@into saveExperienceDet()');                
                saveExperienceDet();
            }
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            //Jose - B-02379 Sync Extension HF data with PT App 
            system.debug('@@@@@before syncAPCHFtoPT()');
            if(ApexPages.currentPage().getParameters().get('syncToPT') == 'true'){
                syncAPCHFtoPT();
            }
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            /*
if(ApexPages.currentPage().getParameters().get('saveChildReference') == 'true'){
try{     
system.debug('*****listExperienceChild: ' + listExperienceChild);

list<Experience__c> ExpChildAux = new list<Experience__c>(); 
if(listExperienceChild.size()>0 && listExperienceChild != null){
for (Experience__c ex:listExperienceChild){
if(ex.IsReference__c == false){
ex.Reference_Request_Note__c = null;                        
}
ExpChildAux.add(ex);
}
}

update ExpChildAux;

}catch(Exception e){
system.debug('*****Exception: ' + e);
}
}
*/
            
            //**--Important--Put this after the Experience update**
            //Method used to mark the APC page with a status flag 
            
            if(ApexPages.currentPage().getParameters().get('pageId')=='026' || ApexPages.currentPage().getParameters().get('pageId')=='021' || 
               ApexPages.currentPage().getParameters().get('pageId')=='028' || ApexPages.currentPage().getParameters().get('pageId')=='001' ||
               ApexPages.currentPage().getParameters().get('pageId')=='018' || ApexPages.currentPage().getParameters().get('pageId')=='035' ||
               ApexPages.currentPage().getParameters().get('pageId')=='034' || ApexPages.currentPage().getParameters().get('pageId')=='020' ||
               ApexPages.currentPage().getParameters().get('pageId')=='037' || /*ApexPages.currentPage().getParameters().get('pageId')=='045' ||*/
               ApexPages.currentPage().getParameters().get('pageId')=='041' || ApexPages.currentPage().getParameters().get('pageId')=='046' ||
               ApexPages.currentPage().getParameters().get('pageId')=='047' || ApexPages.currentPage().getParameters().get('pageId')=='049'){
                   String pageidAux = ApexPages.currentPage().getParameters().get('pageId');
                   PageStatusController(pageidAux);
                   system.debug('debug::PageStatusController(pageidAux)');
               }else{
                   system.debug('debug::PageStatusController()');
                   PageStatusController();
               }
            if(ApexPages.currentPage().getParameters().get('pageId')=='063')
            {
                system.debug('*****@@@before resetDependentsPageId');
                resetDependentsPageId();
            }
            if(ApexPages.currentPage().getParameters().get('savePersonRef') == 'true'){
                
                try{
                    list<Person_Info__c> personInfoReferListAux = new list<Person_Info__c>();
                    system.debug('*****###personInfoReferList: ' + personInfoReferList);
                    if(personInfoReferList !=null && personInfoReferList.size()>0 ){
                        
                        for(Person_Info__c personref:personInfoReferList){
                            personref.Name = personref.First_Name__c + ' ' + personref.Last_Name__c;
                            personInfoReferListAux.add(personref);       
                            
                            if(applicantinfo.Type__c == 'Host Family'){
                                
                                for(Person_Info__c personrefaux:personInfoReferList){
                                    
                                    if(personrefaux.Email__c == personref.Email__c && personrefaux.Id != personref.Id){
                                        
                                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide unique contact information for each reference');
                                        ApexPages.addMessage(msg);
                                        
                                        return null;
                                    }
                                }
                                
                                if(personinfo.Email__c == personref.Email__c){
                                    ApexPages.Message msg = new ApexPages.message(ApexPages.severity.ERROR,'One of the email matches with the applicants email');
                                    ApexPages.addMessage(msg);
                                    return null;
                                    
                                }else if(personRole.Email__c == personref.Email__c){
                                    
                                    ApexPages.Message msg = new ApexPages.message(ApexPages.severity.ERROR,'One of the email matches with the spouse email');
                                    ApexPages.addMessage(msg);
                                    return null;
                                }
                                
                            }//end of applicantinfo.Type__c='Host Family' Condition
                            
                            if(applicantinfo.Type__c == 'Participant'){
                                
                                update personref;
                                MapPersonToReferenceAPC.MapPersonToRef(personref.Id);
                                
                            }
                            
                        }
                        
                        update personInfoReferListAux;
                        system.debug('***** Application Owner'+applicantInfo.ownerId);
                    }
                }catch(Exception e) {
                    //ApexPages.addMessages(e);
                    //New B-02931
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error: ' +e);
                    ApexPages.addMessage(msg);
                    customMessage = true;
                    return null;
                }
            }
            
            //Check for List size for PositionInfo
            if(listPositionInfo.size() > 0) {
                if(applicantInfo.Intrax_Program__c == 'Internship')
                {
                    positionInfo.Placement_Number__c=1;
                    positionInfo.Start_Date__c=applicantinfo.Engagement_Start__c;
                    positionInfo.End_Date__c=applicantinfo.Engagement_End__c;
                }
                update positionInfo;
            } else {
                if(applicantinfo.Id!=null)
                    savePositionInfo();
            }
            if(applicantInfo.Intrax_Program__c == 'Internship' && listPositionInfoSecond.size() > 0) {
                positionInfoSecond.Placement_Number__c=2;
                positionInfoSecond.End_Date__c=applicantinfo.Engagement_End__c;
                positionInfo.End_Date__c=positionInfoSecond.Start_Date__c;
                update positionInfoSecond;
                update positionInfo;
            } else {
                if(applicantinfo.Id!=null && applicantInfo.Double_Placement_Indicated__c == 'Yes')
                    savePositionInfoSecond();
            }
            
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            if(ApexPages.currentPage().getParameters().get('app') != null){
                
                saveApplication(ApexPages.currentPage().getParameters().get('app'));
                personInfo.role__c = ApexPages.currentPage().getParameters().get('role');
                
            }else if(applicantInfo.Id != null){             
                saveApplication();                
            }else
                return page.your_applications; 
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            if(ApexPages.currentPage().getParameters().get('saveChildren') == 'true'){                
                saveChildren();
            }
            
            if(ApexPages.currentPage().getParameters().get('saveParents') == 'true'){                
                saveParents();
                saveFamily();
            }
            // AA APC Family/Sibling
            if(ApexPages.currentPage().getParameters().get('saveFamily') == 'true'){                
                saveFamily();
            }          
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            if(personInfo.First_Name__c !=null)
            {
                if(personInfo.Role__c!=null && personInfo.Role__c!='' && personInfo.Role__c!='Parent' && personInfo.Role__c!='Reference' &&personInfo.Role__c!='Other' && personInfo.Primary_Applicant__c!=true )
                {
                    for(string str: constants.ALLOWED_ROLE_LIST)
                    {
                        if(str.equals(personInfo.Role__c))
                            blnRoleChk = true;
                    }
                    if(!blnRoleChk)
                    {
                        personInfo.Email__c = '';
                        personInfo.Mobile__c = '';
                        personInfo.Work_Phone__c = '';
                        personInfo.Profession__c ='';
                    }
                }
                savePersonInfo();
            }
            //}
        system.debug('***** Application Owner'+applicantInfo.ownerId);
        }
        
        catch(Exception e) {
            return null;
        }
        
        try{
            if(personInfo.Primary_Applicant__c ==true)              
            {
                if(ApexPages.currentPage().getParameters().get('groupApp') == null)
                    basics(userInfo.getFirstName() + ' ' + userInfo.getLastName());                
            }
            
            if(communicationInfo.To_Address__c != null && comType != null)
                DefaultCommunicationInfo();               
        }
        catch(Exception e) {
            ApexPages.addMessages(e);
        }
        
        //Jose: B-03072 Stop families if they fail HF eligibility and send then to a sorry page
        try{
            if(ApexPages.currentPage().getParameters().get('checkDOS') == 'true'){
                if(applicantInfo.Private_Bedroom_Indicated__c == 'No' || personInfo.Citizenship_Resident_Indicated__c == 'No' || personInfo.English_Fluency__c == 'No'){    
                    PageReference P = Page.apc_hf_app_completion;
                    P.getParameters().put('id', applicantInfo.Id);
                    P.getParameters().put('viewpage', 'true');
                    P.setRedirect(true);
                    return P;
                }
            }
                          
        }catch(Exception e) {
            ApexPages.addMessages(e);
        }
        
      // B-03157 When system fails to assign AD owner to HF, user should be stopped from continuing app
          try{
            if(applicantInfo.Type__c=='Host Family' && applicantInfo.Intrax_Program__c == 'AuPairCare' && ApexPages.currentPage().getParameters().get('savePersonRef') == 'true')
            {
                system.debug('@@@@@ savePersonRef is true');
                if(applicantInfo.Account__c != null)
                {   
                system.debug('@@@@@ savePersonRef: applicantInfo.Account__c: ' + applicantInfo.Account__c); 
                List<GeoMatch__c> geoMatches = [select Match_Status__c,HF_Ownership_Set__c,FromiGeoLocate__r.Lead__c,FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__c,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__c,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__c,ToiGeoLocate__r.Contact__r.Id from GeoMatch__C where FromiGeoLocate__r.Account__c !=NULL AND FromiGeoLocate__r.Account__c=:applicantInfo.Account__c AND Match_Status__c='Geo Matched'];
                if(geoMatches==null || geoMatches.size()==0 )
                    {    
                    system.debug('@@@@@ savePersonRef: geoMatches is null');                
                    PageReference P = Page.apc_hf_app_completion;
                    P.getParameters().put('id', applicantInfo.Id);
                    P.getParameters().put('viewpage', 'true');
                    P.setRedirect(true);
                    return P;
                    }   
                    
                }
            }
                          
        }catch(Exception e) {
            ApexPages.addMessages(e);
        }
        // B-03157 End  
        
        
        PageReference P = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        String appendSet;
        try{
            
            if(ApexPages.currentPage().getParameters().get('vstate') != null){
                P.getParameters().put('vstate',ApexPages.currentPage().getParameters().get('vstate'));
            }
            
            if(ApexPages.currentPage().getParameters().get('idNeeded') != 'false'){
                
                system.debug('***** idNeeded: ' + ApexPages.currentPage().getParameters().get('idNeeded') );
                P.getParameters().put('id', applicantInfo.Id);
            }
            
            if(ApexPages.currentPage().getParameters().get('viewpage') == 'true'){
                
                system.debug('*****## viewpage show: ' + ApexPages.currentPage().getParameters().get('viewpage') );
                P.getParameters().put('viewpage', 'true');
            }
            /*if(participantId != null){
P.getParameters().put('participantId',participantId);

}
system.debug('***** participantId: ' + participantId );


if(participantId != null)
P.getParameters().put('participantId',participantId);
*/
            
            if(role != null)
                P.getParameters().put('role',role);
            if(view!=null)
                P.getParameters().put('view',view);
            //Check document type for upload
            if (docType != null)
                system.debug('###### docType: ' + docType );
            P.getParameters().put('docType',docType);
            
            //Check Communication type for recommendation
            if (comtype != null)
                P.getParameters().put('comtype',comtype);
            
            if (add != null)
                P.getParameters().put('add',add);
            
            if (EssayUp != null)
                P.getParameters().put('EssayUp',EssayUp);
            
            if(ApexPages.currentPage().getParameters().get('FromNotify') == '1')
                P.getParameters().put('FromNotify', '1');
            
            
            if(ApexPages.currentPage().getParameters().get('reDirectPage') == 'true')
                p.setRedirect(true);
            
            system.debug('###### URL: ' + p );
            
            //Invoke methods for saving essay question and answers
            //Retrive the info only if record type is not Centers
            //We are not going to create any essay for AuPair Right now
            if(applicantInfo.RecordType.Name != 'Centers' && app != 'Centers') {
                System.debug('deBug::RecordType'+applicantInfo.RecordType.Name);
                saveEssayInfo();
                saveEssayAnswer();
            }                
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            //Check if it is Host Family application - save family, location and referer information.
            if(applicantInfo.Type__c == 'Host Family') {
                
                //APC Code
                //system.debug('*****###personRole.First_Name__c OUT: ' + personRole.First_Name__c);
                //system.debug('*****###personRole.Last_Name__c OUT: ' + personRole.Last_Name__c);
                //system.debug('*****###roleInput in the URL: ' + ApexPages.currentPage().getParameters().get('roleInput'));
                
                roleInput = ApexPages.currentPage().getParameters().get('roleInput');
                
                //system.debug('*****###roleInput: ' + roleInput);
                //##ENd APC CODE
                saveSchoolInfo();
                progId = 'ayusa-hf';
                
                if (personRole.First_Name__c != null && personRole.Last_Name__c !=null && roleInput != null ){   
                    system.debug('*****###personRole.First_Name__c: ' + personRole.First_Name__c);    
                    savePersonRole(roleInput);
                }
                
                if (familyInfo.First_Name__c != null && familyInfo.Last_Name__c !=null )
                {       
                    saveFamilyInfo();
                }
                if (locationInfo.Occupancy_Start__c != null && locationInfo.Occupancy_End__c !=null )
                {
                    saveLocationInfo();      
                }           
                if (refererInfo.First_Name__c != null && refererInfo.Last_Name__c !=null )
                    saveRefererInfo();                  
            }
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            if(applicantInfo.Type__c == 'Participant') {
                
                //system.debug('*****###personRole.First_Name__c OUT: ' + personRole.First_Name__c);
                //system.debug('*****###personRole.Last_Name__c OUT: ' + personRole.Last_Name__c);
                //system.debug('*****###roleInput in the URL: ' + ApexPages.currentPage().getParameters().get('roleInput'));
                
                roleInput = ApexPages.currentPage().getParameters().get('roleInput');
                
                //system.debug('*****###roleInput: ' + roleInput);
                
                //progId = 'ayusa-hf';
                if (personRole.First_Name__c != null && personRole.Last_Name__c !=null && roleInput != null )
                {   
                    system.debug('*****###personRole.First_Name__c: ' + personRole.First_Name__c);    
                    savePersonRole(roleInput);
                }
                
                if (personEmergency.First_Name__c != null && personEmergency.Last_Name__c !=null && personEmergency.Email__c !=null)
                {   
                    system.debug('*****###personEmergency.First_Name__c: ' + personEmergency.First_Name__c);    
                    savePersonEmergency();
                }
                
               	if(applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Date_of_Birth__c != null && personInfo.Date_of_Birth__c != null && applicantInfo.Date_of_Birth__c != personInfo.Date_of_Birth__c){
                    applicantInfo.Date_of_Birth__c = personInfo.Date_of_Birth__c;
                    update applicantInfo;
                    system.debug('debug::update applicantInfo 4');
                    
                }
            }
            system.debug('***** Application Owner'+applicantInfo.ownerId);
            if(ApexPages.currentPage().getParameters().get('content') != null)
                P.getParameters().put('content',ApexPages.currentPage().getParameters().get('content'));
            
            //Check redirection for Essay
            if(ApexPages.currentPage().getParameters().get('EssayId') != null){
                P.getParameters().put('EssayId',ApexPages.currentPage().getParameters().get('EssayId'));
                getEssayInfo();                 
            } 
            if(essayType!= null){
                P.getParameters().put('EssayType',EssayType);
            }
            
            if(ApexPages.currentPage().getParameters().get('env') != null)
                P.getParameters().put('env',ApexPages.currentPage().getParameters().get('env'));
            
            //AYUSA HF  B-02164
            if (ApexPages.currentPage().getUrl().contains('/apex/ayusa_hf_fam_primary'))
            {
                if(applicantInfo.Type__c == 'Host Family') {
                    if(applicantInfo.Intrax_Program__c == 'AYUSA'){
                        personInfo.Country_of_Residence__c = applicantInfo.Home_Country__c;
                        update personInfo;
                    }
                }
            }
            //Getting Payment paramenters
            /*
if(payWrapper != null && payWrapper.cardExpirationMonth != null) 
P.getParameters().put('expireMonth', payWrapper.cardExpirationMonth);
if(payWrapper != null && payWrapper.cardExpirationYear != null) 
P.getParameters().put('expireYear', payWrapper.cardExpirationYear);
if(!String.isBlank(maskedCCNumber)) 
P.getParameters().put('maskCCNumber', maskedCCNumber);
if(!String.isBlank(paymentRecordId))
P.getParameters().put('paymentId', paymentRecordId);
*/
            if(!String.isBlank(paymentTxId))
                P.getParameters().put('paymentTxId', paymentTxId);
            if(!String.isBlank(paymentAmount))
                P.getParameters().put('paymentAmount', paymentAmount);
            if(!String.isBlank(paymentDate))
                P.getParameters().put('paymentDate', paymentDate);
            
            /* IGI App 2.0 */
            if(applicantInfo.Intrax_Program__c == 'Internship'){
                //saving Education Information
                if(applicantInfo.Application_Level__c == 'Basic'){
                    try{
                        if(educationInfo.Applicant_Info__c == null){ 
                            educationInfo.Applicant_Info__c = applicantInfo.Id;
                        }
                        upsert educationInfo;
                        
                    }catch(Exception e){
                        system.debug('***** Impossible to save Education Record: ' + e);
                        return null;
                    } 
                }else{
                    try{
                        for(Education__c e :  educationMap.values()){
                            if(e.Applicant_Info__c == null) e.Applicant_Info__c = ApplicantInfo.Id;
                        }
                        system.debug('****** EDUCATION MAP: ' + educationMap);
                        upsert educationMap.values();
                    }catch(Exception e){
                        system.debug('****** EDUCATION MAP ERROR: ' + e);
                    }
                }
                
                saveEmergencyContact();
                saveExperienceIGI();
                saveDependentsIGI();
            } /*end IGI app 2.0*/      
        system.debug('***** Application Owner'+applicantInfo.ownerId);    
        }
        
        catch(Exception e){
            return null;
        }
        system.debug('***** Application Owner'+applicantInfo.ownerId);
        system.debug('*****@@@@@ final page:' + P );
        /*
        //if (P.getUrl().contains('apc_hf_app_program_pref') || P.getUrl().contains('apc_hf_app_family_profile')){
            List<GeoMatch__c> geoMatchesForOwnerChange = [select FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__r.Id from GeoMatch__C where FromiGeoLocate__r.Account__r.Id=:applicantInfo.Account__c];
            if(geoMatchesForOwnerChange!=null && geoMatchesForOwnerChange.size()>0){
                System.debug('ENTERED OWNER CHANGE AEC----->'+geoMatchesForOwnerChange[0].Id);  
                googleGeoController gGeoC = new googleGeoController();              
                gGeoC.sObjectList = geoMatchesForOwnerChange;
                gGeoC.theInstanceGateKeeper();              
            }
        //}
        */
        return P;
    }   
    
    public PageReference getPageA(){
        PageReference P = Page.ayusa_preapp_stu_health;
        P.getParameters().put('id', applicantInfo.Id);
        P.setRedirect(true);
        return P;
    }
    
    public PageReference getPageTeaRecFin(){
        PageReference P = Page.ayusa_public_thank_you;
        P.getParameters().put('id', applicantInfo.Id);
        P.setRedirect(true);
        return P;
    }
    
    public PageReference getPageStuRecFin(){
        PageReference P = Page.ayusa_public_thank_you;
        P.getParameters().put('id', applicantInfo.Id);
        P.setRedirect(true);
        return P;
    }
    
    public PageReference getpageThankyou(){
        PageReference P = Page.ayusa_public_thank_you;
        P.getParameters().put('id', applicantInfo.Id);
        P.setRedirect(true);
        return P;
    }   
    // Not being used?
    public PageReference getpageThankyouIGI(){
        PageReference P = Page.IGI_public_thank_you; 
        P.getParameters().put('id', applicantInfo.Id);
        P.setRedirect(true);
        return P;
    }   
    
    
    //Default constructor
    public AppEngine_Controller(){
        
        disablepromo = false;
        system.debug('@@disablepromo@@' +disablepromo);
        //fileUploadUrl = Constants.fileUploadUrl;
        // Testing DOcViewer
        
        system.debug('@@@@@before docViewew');
        system.debug('@@@@@before ApexPages.currentPage().getParameters().get(docGuid):' +  ApexPages.currentPage().getParameters().get('docGuid') );
        if(ApexPages.currentPage().getUrl().contains('/apex/DocViewer')){
            customMessage=false;
            load();
        }
        
        if(ApexPages.currentPage().getUrl().contains('/apex/SiteDocViewer')){
            customMessage=true;
            system.debug('@@@@@ SitedocView');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, we appear to be unable to locate this file. Document GUID= '+ApexPages.currentPage().getParameters().get('docGuid'));
            ApexPages.addMessage(msg);
        }
        
        
        AppListGeneral = [Select a.Id, ownerId, Application_Stage__c, LastModifiedDate, CreatedDate From Applicant_Info__c a where a.CreatedBy__c =: UserInfo.getUserId() order by a.CreatedDate desc limit 2]; 
        
        if (AppListGeneral.size()>0){
            
            appCurrent = AppListGeneral[0];
            System.debug('AEC constructor app ownerId---->'+appCurrent.ownerId);
        }
        //Invoke Init method
        inIt();
        getProgramType = Constants.Program_Type;
        getHeardDetail = Constants.Heard_Detail;
        
        
    }
    
    public PageReference ProceedSubmit()
    {
        if (System.currentPageReference().getParameters().get('id') != NULL)
        {   
            Applicant_Info__c appupdate = [SELECT ID, Name,CreatedBy__c, Account__c,PageStatus_Started__c, PageStatus_Complete__c FROM Applicant_Info__c WHERE ID =: System.currentPageReference().getParameters().get('id')];
            
            //D-02192 (Start)
            boolean DISCPageStartStatus = false;
            if(appupdate.PageStatus_Started__c != NULL)
            {
            	List<String> IdSelections = appupdate.PageStatus_Started__c.split(';');
				if(IdSelections.size() > 0)
				{
				    for(string SingleIdSelections:IdSelections)
				    {
				        if(SingleIdSelections == '31')
				        {
				        	DISCPageStartStatus = true;
				        }
				    }
				}
            }
            //D-02192 (End)
            
            if(appupdate.PageStatus_Started__c != NULL && DISCPageStartStatus == false )
            {
                if(appupdate.PageStatus_Started__c != null && appupdate.PageStatus_Started__c != '')
                {
                    appupdate.PageStatus_Started__c = appupdate.PageStatus_Started__c + ';31'; 
                }
                else
                {
                    appupdate.PageStatus_Started__c = '31'; 
                }
                update appupdate;
            }
            else
            {
                if (appupdate.PageStatus_Started__c == NULL)
                {
                    appupdate.PageStatus_Started__c = '31';
                    update appupdate;
                }
            }
            
            if(appupdate.PageStatus_Complete__c.contains('039'))
            {
                string RedURL = '/apex/apc_ap_main_agreements?id=' + appupdate.ID;
                PageReference DISCHomePage =new PageReference(RedURL);
                DISCHomePage.setRedirect(true);
                return DISCHomePage; 
            }
            else
            {
                string RedURL = '/apex/apc_ap_main_disc?vstate=checkout&id=' + appupdate.ID;
                PageReference DISCHomePage =new PageReference(RedURL);
                DISCHomePage.setRedirect(true);
                return DISCHomePage; 
            }
        }
        else return null;
    }
    
    //Checklogin to test authenticated user 
    public PageReference checkLogin(){
        
        String urlToRedirect = apexpages.currentPage().getheaders().get('Referer');
        system.debug('urlToRedirect::' +urlToRedirect);
        //IGI - Not Serviced Application Based on Lead.
        if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.Type__c == 'Participant'){
            if(applicantInfo.Lead__c  !=  null && applicantInfo.ApplicationLeadRouting__c != null && applicantInfo.ApplicationLeadRouting__c == 'Not Serviced'){
                PageReference pageRef = Page.ServiceLogout;
                pageRef.getParameters().put('appId',applicantInfo.Id);
                pageRef.setRedirect(true);
                return pageRef;
            }
        }
        
        checkQuality();
        //system.debug('debug::checkEduRecord'+checkEduRecord);
        
        //AA Load Education documents
        if(applicantInfo.RecordType.Name=='AuPairCare PT'){
            LoadEduDocRecord();
        }
        
        //AA APC DocuSigned Block Inside the checkLogin()
        MethodAPCTCFinal();
        
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
        
        PageReference p;
        
        if (userInfo.getUserType() == 'Guest'){
            p = Page.AppEngine_SiteLoginPage;
            
            p = IUtilities.rewriteUrl(p);
            
            p.setRedirect(true);
            return p;
            // TT Added for AY2 666
            // }else if(userInfo.getUserType() == 'Standard' || userInfo.getUserType() == 'PowerPartner'){
        }else if((userInfo.getUserType() == 'Standard' || userInfo.getUserType() == 'PowerPartner') || Site.getCurrentSiteUrl().contains('FieldStaff')){
            system.debug('');
            return p;
        }
        else{
            //System.debug('###### enter in the loop');
            User user = [Select Id, ContactId,Type__c,Intrax_Id__c, User_Interests__c, Contact.AccountId, ProfileId from User where Id =: UserInfo.getUserId()];
            //Getting the value to determine the user interests (and allow or deny creating some types of applications)
            UserInterests = user.User_Interests__c;
            System.debug('**** User Interests are: ' + UserInterests);
            if(user.ProfileId !=null){
                Profile profile = [Select Name from Profile where Id =: user.ProfileId limit 1];
                userProfileName = profile.Name ;    
            }
            //Getting user profile
            
            //Check the logged in user type for Partner
            if(user.Type__c=='Partner')
            {
                IsPartner = true;
                //Jose D-01427
                system.debug('@@@@@before Partner checkPageStatusController()');
                checkPageStatusController();
                //**END**
                lstPartnerApp =[Select Id, Name ,  Intrax_Program_Options__c, Intrax_Program__c, Application_Level__c, RB_Last_Name__c, Application_Stage__c,Airport_Transfer__c, Intrax_Center__c, Program_Duration__c from Applicant_Info__c WHERE Id =: applicantInfo.Id];
                Boolean allowedToAccess = false;
                for (Applicant_Info__c partnerApp: lstPartnerApp){
                    if(applicantInfo.Id!=null && (applicantInfo.application_stage__c == 'Working' ||
                                                                                       applicantInfo.application_stage__c == 'Submitted' || applicantInfo.application_stage__c == 'Declined' ||
                                                                                       applicantInfo.application_stage__c == 'Declined - Agent' || applicantInfo.application_stage__c == 'Conditional' || ApexPages.currentPage().getParameters().get('view')  != NULL) )                   
                    {
                        allowedToAccess = true;                                                           
                    }
                }
                if (!allowedToAccess){
                    // Uncomment when Partner Portal goes live (AYII 397)
                    p = Page.pr_app_list;
                    //p = Page.ApplicantsInfo;
                    // End of AYII 397
                    p.setRedirect(true);
                }
                return p;         
            }
            else{   
                
                //Code to update Experience End Date to today if It is the current job of the APC PT //Related to line 2573
                try{
                    if(listExperienceChildAUX !=null && listExperienceChildAUX.size()>0){
                        system.debug('*****@@@Updating listExperienceChildAUX');
                        update listExperienceChildAUX;
                    }
                }catch(Exception e){
                    system.debug(' ******** Impossible update Experience record ');
                }         
                
                String URLAux = ApexPages.currentPage().getUrl();
                //Jose D-01427
                checkPageStatusController();
                //**END**
                
                
                //system.debug('*****##URLAux: ' + URLAux );
                String userId = userInfo.getUserId();
                User activeUser = [select Id,email,Phone,street,city,state,postalcode,country from User where Id = :userId];
                
                //D-02192 (Start)
	            boolean DISCPageStartStatus = false;
	            if(applicantInfo.PageStatus_Started__c != NULL)
	            {
	            	List<String> IdSelections = applicantInfo.PageStatus_Started__c.split(';');
					if(IdSelections.size() > 0)
					{
					    for(string SingleIdSelections:IdSelections)
					    {
					        if(SingleIdSelections == '31')
					        {
					        	DISCPageStartStatus = true;
					        }
					    }
					}
	            }
	            //D-02192 (End)
                
                // OLD VERSION:if (applicantInfo.Submitted__c && view == NULL){
                if(applicantInfo.Application_Stage__c != 'Working'  && applicantInfo.Intrax_Program__c != 'AuPairCare' && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('view') == NULL && ApexPages.currentPage().getParameters().get('FromNotify')  == NULL){ 
                    if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.application_Level__c == 'Basic') p = new PageReference('/igi_pt_app_completion?Id=' + applicantInfo.Id + '&view=true');
                    else if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.application_Level__c == 'Main') p = new PageReference('/igi_home');
                    //D-01110
                    else p = Page.your_applications;
                    p.setRedirect(true);
                    return p;
                    
                    //if you have already pay - submit your APC HF App to MAIN /WORKING, you are going to go to applications. Prevent the user to pay twice.
                    //}else if(applicantInfo.Application_Stage__c != 'Working' && applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true'){ 
                    //}else if(applicantInfo.Type__c == 'Host Family' && applicantInfo.Application_Level__c == 'Main' && applicantInfo.Application_Stage__c == 'Working' && applicantInfo.Intrax_Program__c == 'AuPairCare'
                    //      && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true' 
                    //      && applicantInfo.Application_Type__c == false && (URLAux.contains('/apex/apc_hf_app_personal_info') || URLAux.contains('/apex/apc_hf_app_eligibility') || URLAux.contains('/apex/apc_hf_app_family_profile')
                    //    || URLAux.contains('/apex/apc_hf_app_program_pref') || URLAux.contains('/apex/apc_hf_app_references?') || URLAux.contains('/apex/apc_hf_app_payment'))){ 
                    
                }else if(applicantInfo.Type__c == 'Host Family' && applicantInfo.Application_Level__c == 'Main' && applicantInfo.Application_Stage__c == 'Working' && applicantInfo.Intrax_Program__c == 'AuPairCare'
                         && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true' 
                         && applicantInfo.Application_Type__c == 'Original'  
                         && URLAux.contains('/apex/apc_hf_app_payment')){ 
                             
                             system.debug('*****##Into redirection APC HF Main New APP Main/Basic' );
                             
                             p = Page.your_applications;
                             p.setRedirect(true);
                             return p;
                             
                         }else if((applicantInfo.Application_Stage__c == 'Accepted') && applicantInfo.Application_Type__c == 'Original' && userProfileName != 'OCPM Agent Portal' && applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Type__c == 'Participant' && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true'){  
                             system.debug('*****##Into redirection APC Acc Main / Submiited/Accepted' );
                             
                             //if you have already pay - submit your APC HF App or submit you APC PT, you are going to go to applications. Prevent the user to pay twice.
                             //if the Au Pair is not qualified when she submit the Basic App, we are not going to allow her to go back to the basic app.
                             
                             p = Page.apc_ap_home;
                             p.setRedirect(true);
                             return p;
                             
                         }else if((applicantInfo.Application_Stage__c == 'Submitted'||applicantInfo.Application_Stage__c == 'In-Review') && applicantInfo.Application_Type__c == 'Original' && userProfileName != 'OCPM Agent Portal' && applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true'){  
                             system.debug('*****##Into redirection APC submitted or inreview' );
                             
                             //if you have already pay - submit your APC HF App or submit you APC PT, you are going to go to applications. Prevent the user to pay twice.
                             //if the Au Pair is not qualified when she submit the Basic App, we are not going to allow her to go back to the basic app.
                             
                             p = new PageReference('/apc_ap_basic_completion?Id='+applicantInfo.Id+'&viewpage=true');
                             p.setRedirect(true);
                             return p;
                             
                         }else if(applicantInfo.Application_Stage__c != 'Working' && userProfileName != 'OCPM Agent Portal' && applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true'){  
                             system.debug('*****##Into redirection APC Main / Working' );
                             
                             //if you have already pay - submit your APC HF App or submit you APC PT, you are going to go to applications. Prevent the user to pay twice.
                             //if the Au Pair is not qualified when she submit the Basic App, we are not going to allow her to go back to the basic app.
                             
                             p = Page.your_applications;
                             p.setRedirect(true);
                             return p;
                             
                         }
                //APC Original AuPair Redirect if all sections completed except the checkout process (Start)
                else if(applicantInfo.Type__c == 'Participant' && applicantInfo.Application_Level__c == 'Main' && applicantInfo.Application_Stage__c == 'Working' && applicantInfo.Intrax_Program__c == 'AuPairCare'
                        && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true' 
                        && userProfileName != 'OCPM Agent Portal' && applicantInfo.Application_Type__c == 'Original'
                        && applicantInfo.PageStatus_Started__c != NULL && applicantInfo.PageStatus_Complete__c != NULL && DISCPageStartStatus == true && applicantInfo.PageStatus_Complete__c.contains('039') && !(applicantInfo.PageStatus_Complete__c.contains('040'))  
                        && URLAux.contains('/apex/apc_ap_main_home'))
                {
                    p = new PageReference('/apex/apc_ap_main_agreements?id=' + applicantInfo.Id);
                    p.setRedirect(true);
                    return p;
                }
                else if(applicantInfo.Type__c == 'Participant' && applicantInfo.Application_Level__c == 'Main' && applicantInfo.Application_Stage__c == 'Working' && applicantInfo.Intrax_Program__c == 'AuPairCare'
                        && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('viewpage')  != 'true' && userProfileName != 'OCPM Agent Portal' && applicantInfo.Application_Type__c == 'Original'
                        && applicantInfo.PageStatus_Started__c != NULL && applicantInfo.PageStatus_Complete__c != NULL && DISCPageStartStatus == true && !(applicantInfo.PageStatus_Complete__c.contains('039'))  
                        && URLAux.contains('/apex/apc_ap_main_home'))
                {
                    p = new PageReference('/apex/apc_ap_main_disc?id=' + applicantInfo.Id);
                    p.setRedirect(true);
                    return p;
                }
                //APC Original AuPair Redirect if all sections completed except the checkout process (End)
                else if (applicantInfo.Id != null){
                    if (isPartner != true && applicantInfo.createdBy__c != activeUser.Id){               
                        p = Page.your_applications;
                        p.setRedirect(true);
                        return p;
                    }
                    else
                        return null;
                }
                else 
                    return null;
            }       
        }       
    }
    
    //Jose D-01427
    public void  checkPageStatusController(){
        
        String URLAux = ApexPages.currentPage().getUrl(); 
        
        try{
            system.debug('*****@@@ready to check pageId');
            if(URLAux.contains('/apex/apc_ap_main_physician_form')){
                PageStatusController('029'); 
            }else if(URLAux.contains('/apex/apc_ap_main_driving_experience')){
                PageStatusController('018'); 
            }else if(URLAux.contains('/apex/apc_ap_main_education_proof')){
                PageStatusController('035'); 
            }else if(URLAux.contains('/apc_ap_main_visa_info')){
                PageStatusController('034');
            }else if(URLAux.contains('/apc_ap_main_video')){
                PageStatusController('036');  
            }else if(URLAux.contains('/apc_ap_main_training')){
                PageStatusController('020'); 
            }else if(URLAux.contains('/apc_ap_main_media')){ 
                PageStatusController('031'); 
            }else if(URLAux.contains('/apc_hf_app_media')){ 
                PageStatusController('044'); 
            }else if(URLAux.contains('/apc_ap_main_bgc_form')){ 
                PageStatusController('037');
            }/*else if(URLAux.contains('/apc_hf_app_interview_status')){ 
                PageStatusController('045');
            }
            */else if(URLAux.contains('/apc_ap_main_experience')){ 
                PageStatusController('021'); 
            }   
            if(applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Type__c == 'Participant' && userProfileName=='OCPM Agent Portal'){
                PageStatusController('038'); 
            }
        }catch (Exception ex){
            System.debug('An exception occurred: ' + ex.getMessage());
        }
    }
    //**END**
    
    public void checkQuality(){
        Education__c[] eduToDelete = [select id from Education__c where Institution_Type__c IN ('University/College','Vocational Training') and Institution_Name__c='' and Program_Type__c='' and city__c='' and Graduation_Date__c=null and Applicant_Info__c =: applicantInfo.Id];
        If(eduToDelete.size()>0){
            system.debug('debug::deleteEmptyEduRecords'+eduToDelete);
            delete eduToDelete; //perform delete statement
        }
    }
    
    
    //Default parameterised constructor
    public AppEngine_Controller(ApexPages.StandardController controller)
    {
        docusignRefresh = true;
        //docusUserRec2AD = new dsfs__DocuSign_Recipient_Status__c();
        //spillai video changes
        //rtmpUrlVideo = 'rtmp://cp67126.edgefcs.net/ondemand/&mp4:mediapm/ovp/content/test/video/spacealonehd_sounas_640_300.mp4';
        videotagfront = '<source src="';
        videotagback  = '" type="rtmp/mp4"/>';
        photoDoc = new Attachment();
        DocmapEducation = new Map<Id,List<Intrax_Program_Upload__c>>();
        String URLAux = ApexPages.currentPage().getUrl(); 
        //  D-01279 --> Moved this query from the IGI section to here
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        
        if(userInfo.getUserType() != 'Standard' && userInfo.getUserType() != 'PowerPartner'){
            if (!isApexBeingTested){
                if(Site.getCurrentSiteUrl().contains('intraxinc.ustage')){
                    env = 'USTAGE';
                }
                /*else if (Site.getCurrentSiteUrl().contains('intraxinc.ayusa')){
env = 'AY';
}*/
                else if (Site.getCurrentSiteUrl().contains('intraxinc.qa')){
                    env = 'QA';
                }
                /*else if (Site.getCurrentSiteUrl().contains('intraxinc.bfdev')){
env = 'BFDEV';
}
else if (Site.getCurrentSiteUrl().contains('intraxinc.spdev')){
env = 'SPDEV';
}
else if (Site.getCurrentSiteUrl().contains('intraxinc.ssdev')){
env = 'SSDEV';
}
else if (Site.getCurrentSiteUrl().contains('intraxinc.igitemp')){
env = 'IGITEMP';
}
else if (Site.getCurrentSiteUrl().contains('intraxinc.dgdev')){
env='DGDEV';
}*/
                else{
                    env = 'PR';
                }
            }
        }    
        //fileUploadUrl = Constants.fileUploadUrl;   
        disableFileUpload = Constants.disableFileUpload;
        disableFileUploadText = Constants.disableFileUploadText;
        
        //Get current URL
        if (!isApexBeingTested){
            String hostVal = Site.getCurrentSiteUrl();
            String urlVal = Apexpages.currentPage().getUrl();
            urlVal=urlVal.replaceAll('/apex/','');
            refUrl = hostVal+ urlVal;
            system.debug('debug::refURL= '+refUrl);
        }
        
        // Centers
        ctrStudentPhoneNumber = Constants.CTR_STUDENT_PHONE_NUMBER;
        ctrLiveChat = Constants.CTR_LIVE_CHAT;
        ctrSkype = Constants.CTR_SKYPE;
        ctrPartnerPhoneNumber = Constants.CTR_PARTNER_PHONE_NUMBER;
        ctrStudentEmail = Constants.CTR_STUDENT_EMAIL;
        ctrPartnerEmail = Constants.CTR_PARTNER_EMAIL;
        
        // #Centers
        
        //Added as per the Story # 57 description (11-08-2013)
        //Populating map with custom setting values
        //mapSiteTexts = Constants.MAP_SITE_TEXT;
        //Site_Text__c siteText = new Site_Text__c();
        //siteText = mapSiteTexts.get(Constants.ACCOMODATION_FEE + Constants.DASH + Constants.CENTERS);
        
        //init payment page state for HF APC App and country code
        listCountryCodeOptions = Constants.PHONE_COUNTRY_CODES;
        isPaymentSuccessful = true;
        //set the standart total amount --->  APC
        
        
        //Old Code APC Pricing Controller
        /*
standartFeeApc = [Select Id, UnitPrice, Product2Id, Product2.Description, Product2.Sort_Order__c, Product2.Help_Text__c, Product2.Start_Date__c, Product2.Promo_CTA__c, Product2.Name from PriceBookEntry where Product2.Name = 'Standard HF Application Fee' AND Product2.IsActive = true AND IsActive = true AND PriceBook2.Name = 'USA APC 2013-14'];
if (standartFeeApc !=null && standartFeeApc.size() > 0){
amount=standartFeeApc[0].UnitPrice;
totalamount=string.valueof(standartFeeApc[0].UnitPrice);
//payment.Amount__c = amount;
}*/
        
        //##End initializate PRodutc price in payment page APC
        
        //Getting site text value
        //if(siteText != null)   
        //siteTexts = siteText.Text_Area__c;
        
        
        
        //fetching applicant record
        // Comment for AYII 136
        // applicantInfo = (Applicant_Info__c)controller.getRecord();
        // Uncomment for AYII 136
        
        //Jose Changes APC 08/20/2014 /// Preventing Exception on navigartor() when we call it to create a new app from your applications (we dont have any application ID in the URL page)
        personRole = new Person_Info__c();
        personEmergency = new Person_Info__c();
        locationInfo = new Location__c();
        familyInfo = new Person_Info__c();
        refererInfo = new Person_Info__c();
        assessment = new Assessment__c();
        //Init referenceList
        
        referenceList = new list<Reference__c>();     
        reference = new Reference__c();
        
        /* AA APC Education */
        educationInfo = new Education__c();
        
        applicantInfo = new Applicant_Info__c();
        system.debug('****KK: line 867 new app Info');
        
        if(ApexPages.currentPage().getParameters().get('grId') != null){
            groupInfo = [SELECT Id, Name FROM Group__c WHERE Id =:ApexPages.currentPage().getParameters().get('grId')];
        }
        
        //AA APC DocuSigned Block Inside the Constructor
        //Id aId = ApexPages.currentPage().getParameters().get('Id');
        Id aId;
        If(ApexPages.currentPage().getParameters().get('Id')==null){
            aId = ApexPages.currentPage().getParameters().get('ObjId');
        }
        else{
            aId = ApexPages.currentPage().getParameters().get('Id');    
        }
        
        
        
        // #AYII 136
        
        //personInfo = (Person_Info__c)controller.getRecord();
        
        // Comment for AYII 136
        // if(applicantInfo.Id != null) {
        // Uncomment for AYII 136
        //if(ApexPages.currentPage().getParameters().get('Id') != null) {
        if(aId != null) {
            applicantInfo = 
                [Select (Select Id, First_Name__c,Last_Name__c,Primary_Applicant__c From Person_Info__r),Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,Account__r.BillingCountry,a.Account__r.Name,a.Children_Indicated__c,a.Account__r.LastName,a.Account__r.FirstName, a.Reason_Other_Description__c, a.Reason__c, a.Reason_Detail__c, a.Season__c, a.First_Name__c, a.Last_Name__c, a.Email__c, a.Previous_Address_Complete__c, a.graduated__c, a.Emergency_Contact_Complete__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Family_Members_Complete__c, a.Partner_Account__c, a.Partner_Name__r.Id,a.Partner_Account__r.Name, a.Partner_Account__r.BillingStreet, a.Partner_Account__r.BillingCity, a.Partner_Account__r.BillingPostalCode, a.Partner_Account__r.BillingCountry, a.Partner_Account__r.Phone, a.Years_in_Home__c, a.Writing_Skills__c, 
                 a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Visa_Category__c, a.Arrival_Time__c, a.Intrax_Accommodations__c,    
                 a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Accommodation_Price_Range__c, a.Health_Needs_Indicated__c,
                 a.Submitted__c,a.Study_Time__c,a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, a.Smoker_Student__c, 
                 a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
                 a.Religious_Sharing_Indicated__c, a.Religious_Restriction_Indicated__c, a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Program_Duration__c, a.Private_High_School_Tuition__c, a.Private_High_School_Indicated__c, a.Private_Bedroom__c, a.Private_Bathroom__c, 
                 a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.Deposit_Fee_Accepted__c, a.Health_Needs_Description__c,
                 a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Center_Disclosure_Accepted__c, a.Arriving_Date__c, a.Arriving_Time__c, a.Carrier__c, a.Carrier_Number__c, a.Accommodation_Preference__c,
                 a.Points_of_Interest__c,  a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Pax__c, a.Pax_Count__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, 
                 a.Opportunity_Name__c,   a.Nearest_City__c, a.Nationality_Preferences__c, a.Name,  a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c, a.Lead__r.Apply_on_Behalf_of_PT__c, 
                 a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.Intrax_Program_Options__c,a.Intrax_Program__c, a.Date_Of_Birth__c, a.Visa_Type__c, a.Questions__c, a.Program_Start_Opinion__c,
                 a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.RB_Last_Name__c, a.RB_First_Name__c, a.How_Heard__c,a.How_Heard_Detail__c,a.How_Heard_Other__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Government_Assistence_Indicated__c, 
                 a.Gender_Preference__c, a.GPA__c, a.GPA_Self_Reported__c,  a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, a.Check_in_Date__c, a.Check_out_Date__c, a.Any_housing_that_fits_my_program_dates__c, a.Homestay__c, a.Residence_Club__c,
                 a.Exchange_Agency_Employer_Name__c, a.Intrax_Center__c, a.Country_of_Birth__c, a.Home_Province__c,a.Street__c, a.City__c,a.Country__c, a.State__c, a.Passport_Number__c, a.Passport_Country__c,
                 a.Entity_Id__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c, a.English_Teach_Name__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c, a.Engagement_Start__c, 
                 a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Standard_Delivery__c, a.Express_Delivery__c, a.Own_insurance__c, a.Intrax_Insurance__c, a.Airport_Transfer_Arrival__c, a.Airport_Transfer_Departure__c, 
                 a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c,a.Daily_Meal_Commitment__c, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.CreatedById, 
                 a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.Study_Weeks__c,
                 a.Children_Enrolled__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Any_Special_Food_Requirement__c, a.Special_Needs_Food__c, a.Program_Selector__c,
                 a.Bedrooms__c,a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.Engagement_End__c, a.Program_Start__c, a.Flexible_Dates__c,
                 a.Country_of_Interest__c, a.Location_of_Interest__c, a.Program_Preference_Comment__c, a.Language_1__c, a.Language_1_Proficiency__c,  a.Language_2__c, a.Language_2_Proficiency__c,  a.Language_3__c, a.Language_3_Proficiency__c, a.Other_Languages__c, 
                 a.Attendance_Problems__c, a.Attendance_Problems_Description__c,a.Allergies_Other_Partner__c,a.Allergies_Other_desc__c, a.Application_Stage__c, a.Application_Level__c,
                 a.Allergies_from_Partner__c, a.Allergies_from_Applicant__c, a.Allergies_Indicated__c, a.Airport__c, a.Account__c, a.Academic_Years_Completed__c, a.Experience_Complete__c,
                 a.Functional_Areas__c, a.Position_Types__c, a.Service_Level__c, a.Location_Preference_1__c, a.Location_Preference_2__c, a.Location_Preference_3__c,
                 a.PhotoId__c, a.CreatedBy__c, a.RecordType.Name, a.Engagement__c, a.Engagement__r.Id, a.Terms_Accepted__c, a.Citizenship__c,a.School_Name_SOR__c, a.Primary_Activity__c,
                 a.Projects_of_Interest__c, SYS_Allow_Cloning__c, Portal_Contact_Id__c, Enquiry_Channel__c, Last_Applicant_Update__c, a.Intrax_Market__c, a.Private_Bedroom_Indicated__c,
                 a.Driving_Preference_indicated__c, a.Countries_of_Interest__c, a.Language_Preferences__c, Preferred_Arrival_Date__c, a.IsDeleted, a.Program_year__c, a.Airport_Transfer__c,
                 a.Passport_Indicated__c, a.Passport_Expiration_Date__c, a.Casper_Id__c,a.US_Arrival_Date__c, a.Intrax_Id__c, 
                 a.Extension_Preferences__c, a.Payment_Method__c,a.Payment_Option__c, a.Allow_Intrax_to_Apply__c, a.Sevis_Program__c,
                 a.Family_Description__c, a.Lived_Away_indicated__c,a.Away_Count__c, a.US_Passport_Indicated__c, a.Match_Extension_Length__c,
                 a.Childcare_Experience_Indicated__c, a.Under_2_Total_Hours__c, a.Being_AuPair_Indicated__c, a.US_AuPair_Agency__c, a.AP_Completion_Year_Indicated__c, a.AP_program_End_Date__c,
                 a.Drivers_Licence_Indicated__c, Drivers_Licence_Acquired__c, a.Driving_Experience__c, a.Driving_Comfort_Children__c,Drivers_Licence_Expires__c,a.Driving_Frequency__c,a.Driving_Transmission__c,
                 a.Driving_Snow_Experience__c,Interest_Sports__c, a.Interest_Fine_Arts__c, a.Interests_Hobbies__c,a.Interests_Hobbies_Description__c, a.Interests_Leisure__c,
                 a.Allergy_Description__c,  a.Pets_Allergy_Indicated__c, a.Pet_Allergy_Types__c, a.Pets_Allergy_Description__c,  a.Driving_Experience_Description__c,
                 a.Single_Mother_Indicated__c, a.Single_Father_indicated__c, a.Same_Sex_Couple_Indicated__c, a.Any_Sibling_Indicated__c, a.Extension_DOS_Fee_Indicated__c, a.Extension_Payment_Agreed__c,
                 a.Application_Type__c, a.Childcare_Total_Hours__c, a.US_Experience_Indicated__c, a.PageStatus_Complete__c, a.PageStatus_Started__c, 
                 a.Children_Comfortable_Ages__c, a.Children_Special_Needs_Indicated__c, a.Children_Special_Needs_Description__c, a.Children_Special_Needs_Care__c, a.Children_Special_Needs_Skills__c,            
                 a.Swimming_Indicated__c,a.Swimming_Level__c,a.Swimming_Comfort_Children__c, a.Aupair_Preferences__c, a.Month_Arrival__c, a.Prior_Visa_Start_Date__c, Prior_Visa_End_Date__c,a.Lived_Away_Description__c,
                 a.Doctor_Form_Reviewed__c, a.BGC_Reviewed__c, Swimming_Lifeguard_Indicated__c,AuPairsResponsibilities__c,Terms_Accepted_Date__c,Visa_Denied__c,Visa_Denial_Reason__c,Visa_Denial_Year__c,Intrax_Program_Category__c, Currently_Studying__c, One_Year_Work_Experience__c, Five_Years_Work_Experience__c, Work_Authorization_Indicated__c, Work_Experience_Indicated__c,J2_Dependent_Indicated__c, J2_Terms_Accepted__c , Validation_Failure_Reason__c, Extension_Geo_Pref_Indicator__c,
                 Extension_Geo_Pref_Detail__c,Children_Comfortable_Number__c,International_Drivers_Licence__c,International_Drivers_Licence_Expires__c,Extension_Departure_Airport__c,Drivers_US_Licence_Indicated__c,
                 Drivers_US_Licence_State__c,Drivers_US_Licence_Received__c,Drivers_US_Licence_Expiration__c,Drivers_wChildren_Indicated__c,
                 Drivers_Accident_Indicated__c,Drivers_Accident_Detail__c,Drivers_PlacementExp_Indicated__c,Extension_Length__c, Position__c, Position__r.OwnerId, Position__r.Profile_Complete__c,
                 Extension_Au_Pair_HF_reference__c,University_Indicated__c,Additional_Training_Indicated__c, Apply_on_Behalf_of_PT__c,PromoCode__c ,US_Domestic_Participant__c, Graduation_Verified__c, ApplicationLeadRouting__c, isApplicationDelete__c,
                 Additional_People_Household_Indicated__c,US_Car_Type_Experience__c,Additional_People_Description__c,Drivers_Licence_Expires_Indicated__c,Intrax_Region__c, Photos_Reviewed__c, Passport_Reviewed__c, Driving_Reviewed__c, Childcare_Reviewed__c
                 From Applicant_Info__c a where a.Id = :aId]; 
            
            
            //setting the value of returnURL to show the Profile Photo and Photo Album in the APC App apc_ap_main_media.page
            
            //New Code APC Pricing Controller
            /* 
system.debug('debug::Opportunity' +applicantInfo.Opportunity_Name__c);
If(ApexPages.currentPage().getUrl().contains('/apex/apc_hf_app_payment') && applicantInfo.Intrax_Program__c=='AuPairCare' && applicantInfo != null && applicantInfo.Opportunity_Name__c != null){
list<Opportunity> opp =[select id,ChildOppType__c,Name from Opportunity where Parent_Opportunity__c=:applicantInfo.Opportunity_Name__c and ChildOppType__c='Application'];
list<OpportunityLineItem> opplineItem=[Select id,unitprice,OpportunityId,Product_Family__c,Product_Description__c from OpportunityLineItem where OpportunityId =: opp[0].id AND Product_Family__c='Host Family' AND Product_Description__c='Application Fee' limit 1];
amount=opplineItem[0].UnitPrice;
totalamount=string.valueof(opplineItem[0].UnitPrice);
system.debug('debug::Application Fee'+opp);
system.debug('debug::child Opportunity' +opp);
}*/
            
            if(!Test.isRunningTest()){
                if(ApexPages.currentPage().getUrl().contains('/apex/apc_hf_app_payment') && applicantInfo.Intrax_Program__c=='AuPairCare' && applicantInfo != null && applicantInfo.Opportunity_Name__c != null){
                    list<Opportunity> opp =[select id,ChildOppType__c,Name from Opportunity where Parent_Opportunity__c=:applicantInfo.Opportunity_Name__c and ChildOppType__c='Application'];
                    //list<OpportunityLineItem> opplineItem=[Select id,unitprice,OpportunityId,Product_Family__c,Product_Description__c from OpportunityLineItem where OpportunityId =: opp[0].id AND Product_Family__c='Host Family' AND Product_Description__c='Application Fee' limit 1];
                    if(opp!=null && opp.size()>0)
                    {
                        childApplicationOpportunity = opp[0];
                        system.debug('debug::APC child Application Fee opportunity '+opp + ' childApplicationOpportunity' + childApplicationOpportunity);
                    }
                    list<PriceBookEntry> Pricebook = Pricing_Publisher.getAPCPricebookDetail('United States','ALL','Fixed',applicantInfo.Intrax_Program__c,'Application');
                    system.debug('debug::Application Fee'+Pricebook);
                    if(Pricebook !=null && Pricebook.size() > 0){
                        amount=Pricebook[0].UnitPrice;
                        totalamount=string.valueof(Pricebook[0].UnitPrice);
                    }
                }
            }
            
            //get APC PArticipant profile Photo and Photo Album
            if(URLAux != null){              
                if(URLAux.contains('/apex/apc_ap_main_media') || URLAux.contains('/apex/apc_hf_app_media')){
                    if(applicantInfo.Intrax_Program__c ==  'AuPairCare'){
                        
                        list<Intrax_Program_Upload__c> ipulits = getDocList();
                        system.debug('@@@@@ ipulits: ' + ipulits);
                        list<String> myGUIDs = new list<String>();
                        
                        for(Intrax_Program_Upload__c ipu : ipulits){ 
                            myGUIDs.add(ipu.Document_GUID__c);
                        }
                        if(myGUIDs!=null && myGUIDs.size()>0){
                            returnURL = IUtilities.getPhotoListThumb(myGUIDs)[0];
                            //returnURL = aws_controller.getParticipantIPUURLforHF(myGUIDs)[0];
                        }
                        system.debug('@@@@@ returnURL: ' + returnURL);
                        	MapPhotoAlbum = IUtilities.getPtThumbnailPhotosAlbum(applicantInfo); 
                        	//MapPhotoAlbum = aws_controller.getPtThumbnailPhotosAlbumforHF(applicantInfo); 
                        
                        if(MapPhotoAlbum != null){
                            MapAlbumSize = MapPhotoAlbum.size();
                        }else{
                            MapAlbumSize=0;                   
                        }
                    }
                }
            }
            
            if(URLAux != null){              
                //B-02269
                if(URLAux.contains('/apex/apc_ap_main_health_review')){
                    if(applicantInfo.Intrax_Program__c ==  'AuPairCare'){
                        if(applicantInfo.Doctor_Form_Reviewed__c != null){
                            DoctorFormReviewed = true;
                        }
                    }
                }
                //B-02553--Jose
                if(URLAux.contains('/apex/apc_ap_main_bgc_review')){
                    if(applicantInfo.Intrax_Program__c ==  'AuPairCare'){
                        if(applicantInfo.BGC_Reviewed__c != null){
                            BGCFormReviewed = true;
                        }
                    }
                }
                //B-02556--Jose
                if(URLAux.contains('/apex/apc_ap_main_secondary_review')){
                    if(applicantInfo.Intrax_Program__c ==  'AuPairCare'){
                        if(applicantInfo.Graduation_Verified__c != null){
                            SecondaryFormReviewed = true;
                        }
                    }
                }
                //B-02598 - Chris
                /*if(URLAux.contains('/apex/apc_ap_main_driving_experience')){
                    if(applicantInfo.Intrax_Program__c ==  'AuPairCare'){
                        if(applicantInfo.Drivers_Licence_Expires__c == null){
                            LicenseExpires = true;
                        }
                    }
                }*/
                
                
            }
            
            
            //get APC PT Video
            if(URLAux != null){
                if(URLAux.contains('/apex/apc_ap_main_video')){
                    if(applicantInfo.Intrax_Program__c ==  'AuPairCare'){
                        MapPTVideoThumb = IUtilities.getVideosParticipant(applicantInfo); 
                        
                        set<String> mapvidKeys;
                        list<Map<String, Intrax_Program_Upload__c>> mapvidValues;
                        
                        if(MapPTVideoThumb != null && !MapPTVideoThumb.isEmpty() && !MapPTVideoThumb.values()[0].isEmpty() ){
                            
                            MapVideoSize = MapPTVideoThumb.size();
                            mapvidKeys=MapPTVideoThumb.keySet();
                            mapvidValues=MapPTVideoThumb.values();
                            isVideoSuccessinit();
                            system.debug('@@@@@### MapVideoSize: ' + MapVideoSize);
                            system.debug('@@@@@### mapvidKeys: ' + mapvidKeys);
                            system.debug('@@@@@### mapvidValues: ' + mapvidValues);
                            
                        }else{
                            MapVideoSize=0;
                        }
                    }
                }
            }
            
            //Geeting the APC Audit_Info from the ApplicantInfo
            auditinfo = new Audit_Info__c();
            flaggedList = '';
            if(applicantinfo.Intrax_Program__c == 'AuPairCare'){
                
                list<Audit_Info__c>  auditinfoList = [Select Id, Audit_Status__c, Age__c, Experience__c, Visa__c , Dates__c, Crime_Charge__c,
                                                      Health__c, Disease__c, Drug_Dependency__c, Marital_Status__c, Driving__c, Disability__c, Pregnant__c, Medication__c, Hospitalization__c,
                                                      Psychiatric_Treatment__c 
                                                      from Audit_Info__c where Applicant_Info__c = :applicantinfo.Id ];
                if(auditinfoList !=null && auditinfoList.size()>0){
                    auditinfo = auditinfoList[0];
                    
                    if(auditinfo.Age__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Date of Birth' + ',';
                    }if(auditinfo.Marital_Status__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Marital Status' + ',';
                    }if(auditinfo.Experience__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Childcare Experience' + ',';
                    }if(auditinfo.Dates__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Graduation Date' + ',';
                    }if(auditinfo.Crime_Charge__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Criminal record' + ',';
                    }if(auditinfo.Driving__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Driver?s License' + ',';
                    }if(auditinfo.Visa__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Visa denial' + ',';
                    }if(auditinfo.Health__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Overall Health' + ',';
                    }if(auditinfo.Disability__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Disability' + ',';
                    }if(auditinfo.Disease__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Contagious Disease' + ',';
                    }if(auditinfo.Drug_Dependency__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Drug or Alcohol Dependency' + ',';
                    }if(auditinfo.Medication__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Medication' + ',';
                    }if(auditinfo.Hospitalization__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Hospitalization' + ',';
                    }if(auditinfo.Psychiatric_Treatment__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Psychiatric Treatment' + ',';
                    }if(auditinfo.Pregnant__c == 'Needs Review'){
                        flaggedList = flaggedList + ' Pregnancy' + ',';
                    }
                    
                    flaggedList=flaggedList.removeEnd(',');
                    system.debug('@@@@@ flaggedList after: ' + flaggedList);
                    
                }
            }
            
            //AA APC Education ApexPages.StandardController
            if(applicantInfo.application_Level__c == 'Main' && applicantInfo.RecordType.Name=='AuPairCare PT'){
                educationInfoList = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c,Address_Street_1__c,Address_Street_2__c,Phone__c,Phone_Country_Code__c,Program_Type_Other__c,Study_Level__c,City__c,Country__c,Postal_Code__c,State__c,Certification__c
                                     FROM Education__c WHERE Applicant_Info__c =: applicantInfo.Id and Institution_Type__c='High/Secondary School' order by CreatedDate DESC];
                if(educationInfoList.size() > 0){
                    system.debug('****** Getting here infolist?');
                    educationInfo = educationInfoList[0];
                }
                buildEduMapApc();
                system.debug('****** Getting here School?');
            }
            getProgramType = Constants.Program_Type;
            getHeardDetail = Constants.Heard_Detail;
            system.debug('##getProgramType'+getProgramType);
            //B-02904
            getAPCPTTimeZone = Constants.APCPT_TimeZone;
            system.debug('debug::getAPCPTTimeZone'+getAPCPTTimeZone);
            
            // Comment for AYII 136
            // From Applicant_Info__c a where a.Id = :applicantInfo.Id];
            // Uncomment for AYII 136
            // From Applicant_Info__c a where a.Id = :aId]; 
            
            //IGI - B-01830 (Start)
            if(!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('/apex/igi_pt_app_personal_info') && applicantInfo != NULL && applicantInfo.Country_of_Interest__c!= null ){
                loadIGICategory();
            }
            //IGI - B-01830 (End)
            
            
            /* IGI App 2.0*/
            if(applicantInfo.Intrax_Program__c == 'Internship'){
                
                educationInfo = new Education__c();
                
                if(applicantInfo.application_Level__c == 'Basic'){
                    educationInfoList = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c, Study_Level__c
                                         FROM Education__c WHERE Applicant_Info__c =: applicantInfo.Id order by CreatedDate DESC];
                    
                    if(educationInfoList.size() > 0){
                        educationInfo = educationInfoList[0];
                    }
                }else{
                    // We need the map, to be able to read / add multiple records
                    buildEducationMap();    
                    buildEmergencyContactMap();     
                    buildExperienceMap(); 
                    buildDependentsMap();
                    
                }
                
                
                
                /*   countryOfInterestList = new list<SelectOption>();
countryOfInterestList.add(new SelectOption('United States', 'United States'));
countryOfInterestList.add(new SelectOption('Chile' , 'Chile'));
countryOfInterestList.add(new SelectOption('China' , 'China'));
countryOfInterestList.add(new SelectOption('France' , 'France'));
countryOfInterestList.add(new SelectOption('Germany' , 'Germany'));
countryOfInterestList.add(new SelectOption('Ghana' , 'Ghana'));
countryOfInterestList.add(new SelectOption('Japan' , 'Japan'));
countryOfInterestList.add(new SelectOption('Peru' , 'Peru'));
countryOfInterestList.add(new SelectOption('Spain' , 'Spain'));
countryOfInterestList.add(new SelectOption('United Kingdom' , 'United Kingdom')); 
*/
                
            }
            
            //initializate addlanguage for APC PT
            /* APC */
            if(applicantInfo.Intrax_Program__c == 'AuPairCare'){
                if(applicantInfo.Language_3__c != null){
                    addlanguage = 2;
                }else if(applicantInfo.Language_2__c != null){
                    addlanguage = 1;
                }else{
                    addlanguage = 0; 
                }
            }
            
            //Populate Product Map
            if(applicantInfo.Intrax_Center__c != null && applicantInfo.Intrax_Center__c != '')
                populateApplicantProductWrapper();
            
            //Populate list with value
            listProductDescription = Constants.PROFESSIONAL_CERTIFICATES_DESCRIPTION_FINAL_LIST;
            
            System.debug('###### Value in list'+listProductDescription);
            
            //Getting list of Options for Study Weeks
            listStudyWeeksOptions = Constants.STUDY_WEEKS_LIST;
            
            //Getting list of Options for Service Level , updated for WT (B-03257)
            listServiceLevel = Constants.SERVICE_LEVEL_LIST;
            
            // Getting some user data we need for IGI Apps
            /* D-01279 - Code moved to the top of the method, as it?s needed for other user types
user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
FROM User
WHERE id = :UserInfo.getUserId()];
*/
            // IGI 352
            if(ApexPages.currentPage().getParameters().get('pid') != null){
                PosInfo = [SELECT Id, Name, Engagement_Start__c, Engagement_End__c 
                           FROM Position__c 
                           WHERE Id =: ApexPages.currentPage().getParameters().get('pid') LIMIT 1];
            }
            
            //Check if it is Host Family application
            if(applicantInfo.Type__c == 'Host Family') {
                
                //Beginnig code APC
                // prepopulating a Person_Info_c list for APC Children
                wrappers=new List<PersonInfoChildWrapper>();
                children = [select p.Id, p.Name, p.Date_of_Birth__c, Special_Needs_Description__c,Special_Needs_Indicated__c, Gender__c
                            From Person_Info__c p 
                            Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Child' 
                            and Family_Member__c = true order by p.Date_of_Birth__c ASC];
                
                
                
                if(children.size()>0 && children!= null){
                    
                    for (Person_Info__c c: children){
                        
                        PersonInfoChildWrapper child = new PersonInfoChildWrapper(nextIdent++,c);
                        
                        wrappers.add(child);
                        
                    }
                    wrappersize=wrappers.size(); 
                    system.debug('*****####existing wrappers; ' + wrappers);    
                    
                }else{
                    
                    system.debug('*****#### Creating defaul child');
                    
                    
                    for (Integer idx=0; idx < 1; idx++){
                        
                        PersonInfoChildWrapper child = new PersonInfoChildWrapper(nextIdent++);
                        child.personInfoChild.Applicant_Info__c = applicantInfo.Id;
                        wrappers.add(child);
                        
                    }
                    wrappersize=wrappers.size();
                    system.debug('*****####wrappers.size(); ' + wrappers.size());
                    system.debug('*****####wrappers; ' + wrappers);
                    
                }
                // #prepopulating a Person_Info_c list for APC Children
                
                
                
                personRole = new Person_Info__c();
                personRoleList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c, p.Role_Other__c,p.Employer_Name__c,p.Phone__c, p.State__c, p.City__c,
                                  p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp,
                                  p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate,
                                  p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c,
                                  p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c,
                                  p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c, p.Phone_Type__c, p.Job_Sector__c,p.Employment_Status__c
                                  From Person_Info__c p 
                                  Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Spouse or Partner' 
                                  and Family_Member__c = true];
                
                if(personRoleList != null && personRoleList.size()>0){
                    personRole = personRoleList[0];
                }
                
                //get the info of the 2 APC HF References
                isReferCheck = false;
                
                //Jose-D-01755 retrieving HF References Stauts
                
                personInfoReferList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c, p.Role_Other__c,p.Employer_Name__c,p.Phone__c, p.State__c, p.City__c,
                                       p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp,
                                       p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate,
                                       p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c,
                                       p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c,
                                       p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c, p.Reference_Contact_Requested__c, p.Reference_Request_Note__c,
                                       p.Reference_Language__c
                                       From Person_Info__c p 
                                       Where p.Applicant_Info__c = :applicantInfo.Id 
                                       and role__c = 'Reference'  order by Name ASC limit 2];
                
                if(personInfoReferList != null && personInfoReferList.size()>0){
                    system.debug('@@@@@personInfoReferList');
                    if(personInfoReferList[0].First_Name__c != null){
                        isReferCheck = true;
                        system.debug('*****####isReferCheck: '+isReferCheck);
                    }
                    //Jose-D-01755 retrieving HF References Status 
                    if(URLAux != null){
                        system.debug('@@@@@URLAux: ' + URLAux);              
                        if(URLAux.contains('/apex/apc_hf_app_references')){
                            system.debug('@@@@@retrieving HF Reference records');
                            if(personInfoReferList[0].First_Name__c != null){
                                    list<Reference__c> HFreferenceList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
                                                     Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
                                                     Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c, CreatedDate, LastModifiedDate, Status__c 
                                                     from Reference__c where Applicant_Info__c =: applicantInfo.Id AND Reference_Status__c = 'Active'];
                                    if(HFreferenceList!=null && HFreferenceList.size()>0){
                                        mapPersonHFRef = new map<String, Reference__c>();
                                        for(Reference__c hfref:HFreferenceList){
                                            mapPersonHFRef.put(hfref.Person_Info__c, hfref);    
                                        }
                                    }   
                            }
                        }
                    }//END if(URLAux != null)
                }//END if(personInfoReferList != null && personInfoReferList.size()>0)
                
                //END APC CODE
                
                schoolInfoList = [Select s.Applicant_Info__c,s.SystemModstamp, s.Student_Census__c, s.Street__c, s.State__c, s.Postal_Code__c, s.Phone__c, 
                                  s.Name__c, s.Name, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.Email__c, s.CreatedDate, s.CreatedById, s.Country__c, s.Contact_Title__c, s.Contact_Name__c, s.ConnectionSentId, s.ConnectionReceivedId, s.City__c, s.Category__c, s.Academic_Year_Start__c 
                                  From School__c s 
                                  Where s.Applicant_Info__c =: applicantInfo.Id];
                
                if(schoolInfoList!=null && schoolInfoList.size()>0){                
                    schoolInfo = schoolInfoList[0];                
                }
                
                progId = 'ayusa-hf';               
                
                if (ApexPages.currentPage().getParameters().get('lid') != null){
                    
                    locationInfoList =  [Select l.Type__c, l.SystemModstamp, l.State__c, l.Street__c, l.Postal_Code__c, 
                                         l.Occupancy_Years__c, l.Occupancy_Start__c, l.Occupancy_End__c, l.Name, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.CreatedDate, l.CreatedById, l.Country__c, l.ConnectionSentId, l.ConnectionReceivedId, l.City__c, l.Applicant_Info__c 
                                         From Location__c l
                                         where l.Applicant_Info__c =: applicantInfo.Id 
                                         and l.id = :ApexPages.currentPage().getParameters().get('lid')];
                    
                    if (locationInfoList.size() > 0)
                        locationInfo = locationInfoList[0];
                    else{
                        locationInfo = new Location__c();
                        locationInfoList =  [Select l.Street__c, l.Type__c, l.SystemModstamp, l.State__c, l.Postal_Code__c, 
                                             l.Occupancy_Years__c, l.Occupancy_Start__c, l.Occupancy_End__c, l.Name, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.CreatedDate, l.CreatedById, l.Country__c, l.ConnectionSentId, l.ConnectionReceivedId, l.City__c, l.Applicant_Info__c 
                                             From Location__c l
                                             where l.Applicant_Info__c =: applicantInfo.Id];
                    } 
                }               
                else{
                    locationInfo = new Location__c();
                    locationInfoList = [Select l.Street__c, l.Type__c, l.SystemModstamp, l.State__c, l.Postal_Code__c, 
                                        l.Occupancy_Years__c, l.Occupancy_Start__c, l.Occupancy_End__c, l.Name, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.CreatedDate, l.CreatedById, l.Country__c, l.ConnectionSentId, l.ConnectionReceivedId, l.City__c, l.Applicant_Info__c 
                                        From Location__c l
                                        where l.Applicant_Info__c =: applicantInfo.Id];
                } 
                if (ApexPages.currentPage().getParameters().get('mid') != null){
                    familyInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c,p.Role_Other__c,p.Work_Supervisor__c,p.Employer_Name__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c 
                                      From Person_Info__c p 
                                      Where p.Applicant_Info__c = :applicantInfo.Id and role__c != 'HostFamily' 
                                      and role__c != 'Reference' and Family_Member__c = true 
                                      and p.Id = :ApexPages.currentPage().getParameters().get('mid')  LIMIT 1];
                    
                    if (familyInfoList.size() > 0){
                        familyInfo = familyInfoList[0];
                    }else{
                        familyInfo = new Person_Info__c();
                        familyInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c, p.Role_Other__c,p.Employer_Name__c,p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c 
                                          From Person_Info__c p 
                                          Where p.Applicant_Info__c = :applicantInfo.Id and role__c != 'HostFamily' 
                                          and role__c != 'Reference' and Family_Member__c = true];
                    } 
                }               
                else{
                    familyInfo = new Person_Info__c();
                    familyInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Role_Other__c, p.Interests__c,p.Employer_Name__c,p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c 
                                      From Person_Info__c p 
                                      Where p.Applicant_Info__c = :applicantInfo.Id and role__c != 'HostFamily' and role__c != 'Reference' and Family_Member__c = true];
                } 
                if (ApexPages.currentPage().getParameters().get('rid') != null){
                    refererInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c,p.Employer_Name__c, p.Work_Supervisor__c,p.Title__c,p.Profession__c, p.Education_Level__c,p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c,p.Reference_Request_Note__c 
                                       From Person_Info__c p 
                                       Where p.Applicant_Info__c = :applicantInfo.Id 
                                       and role__c = 'Reference' and p.Id = :ApexPages.currentPage().getParameters().get('rid') LIMIT 1];
                    if (refererInfoList.size() > 0)
                        refererInfo = refererInfoList[0];
                    else{
                        refererInfo = new Person_Info__c();
                        refererInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c,p.Employer_Name__c, p.Work_Supervisor__c,p.Title__c,p.Education_Level__c,p.Profession__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c, p.Reference_Request_Note__c 
                                           From Person_Info__c p 
                                           Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Reference'];
                    } 
                }               
                else{
                    refererInfo = new Person_Info__c();
                    refererInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c,p.Employer_Name__c, p.Work_Supervisor__c,p.Title__c,p.Education_Level__c,p.Profession__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c, p.Reference_Request_Note__c 
                                       From Person_Info__c p 
                                       Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Reference'];
                } 
            }//--End IF applicantInfo.Type__c == 'Host Family' 
             system.debug('*****before prepopulating experience info for Renewal APC PT ');
            
            // B-03034 APC PT Renewal 
            if(applicantInfo.Type__c == 'Participant'  && applicantInfo.Application_Type__c=='Renewal' && applicantInfo.RecordType.Name=='AuPairCare PT')
              { 
                system.debug('*****prepopulating experience info for Renewal APC PT ');
               experienceAPC = new Experience__c();
               list<Experience__c> listAPCExperience= new list<Experience__c>(); 
               
               listAPCExperience=[SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                     exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                     exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c,
                                     exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                     exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Reference_Language__c,
                                     exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,  exp.Reference_Received__c
                                     FROM Experience__c exp 
                                     WHERE exp.Applicant_Info__c = :applicantInfo.Id AND exp.Experience_Type__c='Au Pair' order by CreatedDate ASC ];
              if (listAPCExperience!=null && listAPCExperience.size()>0)
              {
                 
                 experienceAPC = listAPCExperience[0];
                 system.debug('***** experience info for Renewal APC PT ' + experienceAPC.Name);
              }
              
             }
             
            // end B-03034 APC PT Renewal 
            
            if(applicantInfo.Type__c == 'Participant') {
                
                // prepopulating a Person_Info_c list for APC Parents
                wrappersParent = new List<PersonInfoParentWrapper>();
                
                parents = [select p.Id, p.Name, p.First_Name__c, p.Last_Name__c, p.Date_of_Birth__c, Gender__c, Phone__c, Email__c, Profession__c, Emergency_Contact_Indicated__c,Role_Other__c,Phone_Country_Code__c, Family_Role__c
                           From Person_Info__c p 
                           Where p.Applicant_Info__c = :applicantInfo.Id 
                           and role__c = 'Parent' and Family_Member__c = true order by p.Date_of_Birth__c ASC];
                
                
                if(parents.size()>0 && parents!= null){
                    
                    for (Person_Info__c c: parents){
                        
                        PersonInfoParentWrapper parent = new PersonInfoParentWrapper(nextIdent++,c);
                        
                        wrappersParent.add(parent);
                        
                    }
                    wrapperParsize=wrappersParent.size(); 
                    system.debug('*****####existing wrappersParent; ' + wrappersParent);    
                    addEmergContact();
                }else{                
                    system.debug('*****#### Creating defaul Parent');
                    
                    for (Integer idx=0; idx < 1; idx++){
                        
                        PersonInfoParentWrapper parent = new PersonInfoParentWrapper(nextIdent++);
                        parent.personInfoParent.Applicant_Info__c = applicantInfo.Id;
                        wrappersParent.add(parent);
                    }
                    wrapperParsize=wrappersParent.size();
                    system.debug('*****####wrappersParent.size(); ' + wrappersParent.size());
                    system.debug('*****####wrappersParent; ' + wrappersParent);
                    
                }
                
                //AA Start of APC Participant Family/Sibling Person Info 
                //******************************************************
                // prepopulating a Person_Info_c list for APC Family
                wrappersFamily = new List<PersonInfoFamilyWrapper>();
                
                Family = [select p.Id, p.Name, p.First_Name__c, p.Last_Name__c, p.Date_of_Birth__c, Gender__c, Phone__c, Email__c, Profession__c, Emergency_Contact_Indicated__c,Role_Other__c,Phone_Country_Code__c
                          From Person_Info__c p 
                          Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Sibling' order by p.Date_of_Birth__c ASC];
                
                
                if(Family.size()>0 && Family!= null){
                    
                    for (Person_Info__c c: Family){
                        
                        PersonInfoFamilyWrapper Family = new PersonInfoFamilyWrapper(nextIdent++,c);
                        
                        wrappersFamily.add(Family);
                        
                    }
                    wrapperFamsize=wrappersFamily.size(); 
                    system.debug('*****####existing wrappersFamily; ' + wrappersFamily);    
                    
                }
                //AA End Of APC Participant Family/Sibling Person info
                //**************************************************
                
                if(URLAux != null){              
                    if(!URLAux.contains('/apex/apc_ap_main_add_childcare_experience')){
                        //Prepopulating info for the APC PT Reference
                        personInfoReferList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c, p.Role_Other__c,p.Employer_Name__c,p.Phone__c, p.State__c, p.City__c,
                                               p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp,
                                               p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate,
                                               p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c,
                                               p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c,
                                               p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c, p.Reference_Contact_Requested__c, p.Reference_Request_Note__c,
                                               p.Reference_Language__c
                                               From Person_Info__c p 
                                               Where p.Applicant_Info__c = :applicantInfo.Id 
                                               and role__c = 'Reference'  order by Name ASC limit 1];
                        
                        if(personInfoReferList != null && personInfoReferList.size()>0){
                            system.debug('*****####personInfoReferList');
                            if(personInfoReferList[0].First_Name__c != null){
                                referenceList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
                                                 Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
                                                 Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c, CreatedDate, LastModifiedDate, Status__c 
                                                 from Reference__c where Person_Info__c =: personInfoReferList[0].Id AND Reference_Status__c = 'Active' limit 1];
                                if(referenceList!=null && referenceList.size()>0){
                                    reference=referenceList[0];
                                    system.debug('@@@@@ reference.Email__c: ' + reference.Email__c);
                                    system.debug('@@@@@ reference.Reference_Requested__c: ' + reference.Reference_Requested__c);
                                }   
                                isReferCheck = true;
                                system.debug('*****####isReferCheck: '+isReferCheck);  
                            }
                        }
                    }
                }
                
                // #prepopulating a Person_Info_c list for APC parents
                
                system.debug('*****###after applicantInfo.Type__c == Participant ');    
                personRole = new Person_Info__c();
                personRoleList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c, p.Role_Other__c,p.Employer_Name__c, p.Phone__c, p.State__c, p.City__c,
                                  p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp,
                                  p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate,
                                  p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c,
                                  p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c,
                                  p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c, p.Phone_Type__c, p.Job_Sector__c 
                                  From Person_Info__c p 
                                  Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Host'];
                
                if(personRoleList != null && personRoleList.size()>0){
                    personRole = personRoleList[0];
                }
                
                personEmergency = new Person_Info__c();
                personEmergencyList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c, p.Role_Other__c,p.Employer_Name__c, p.Phone__c, p.State__c, p.City__c,
                                       p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp,
                                       p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate,
                                       p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c,
                                       p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c,
                                       p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c,p.Phone_Country_Code__c, p.Relationship__c
                                       From Person_Info__c p 
                                       Where p.Applicant_Info__c = :applicantInfo.Id and Emergency_contact__c = 'Yes' 
                                       and Family_Member__c = false order by CreatedDate ASC];
                
                if(personEmergencyList != null && personEmergencyList.size()>0){
                    personEmergency = personEmergencyList[0];
                }
                
            }
            //--End IF applicantInfo.Type__c == 'Participant' APC
            
            
            // After applicant Info load communication Info records
            if (ApexPages.currentPage().getParameters().get('cid') != null){
                communicationInfoList = [Select c.Applicant_Info__r.ETR_Received_Date__c, c.Applicant_Info__r.SOR_Received_Date__c, c.Type__c, c.Type_Code__c, c.To_Address__c, c.SystemModstamp, c.Status__c, c.Sender_Last_Name__c, c.Sender_First_Name__c, c.Recipient_Title__c, c.Recipient_Last_Name__c, c.Recipient_First_Name__c, 
                                         c.Name, c.Method__c, c.Message__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.From_Address__c, c.CreatedDate, c.CreatedById, c.ConnectionSentId, c.ConnectionReceivedId, c.Applicant_Info__c, c.Action_URL__c 
                                         From Communication__c c 
                                         WHERE c.Applicant_Info__c =: applicantInfo.Id 
                                         and c.id = :ApexPages.currentPage().getParameters().get('cid') LIMIT 1];
                
                if (communicationInfoList.size() > 0)
                    communicationInfo = communicationInfoList[0];
                else{
                    communicationInfo = new Communication__c();
                    communicationInfoList = [Select c.Applicant_Info__r.ETR_Received_Date__c, c.Applicant_Info__r.SOR_Received_Date__c, c.Type__c, c.Type_Code__c, c.To_Address__c, c.SystemModstamp, c.Status__c, c.Sender_Last_Name__c, c.Sender_First_Name__c, c.Recipient_Title__c, c.Recipient_Last_Name__c, c.Recipient_First_Name__c, 
                                             c.Name, c.Method__c, c.Message__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.From_Address__c, c.CreatedDate, c.CreatedById, c.ConnectionSentId, c.ConnectionReceivedId, c.Applicant_Info__c, c.Action_URL__c 
                                             From Communication__c c 
                                             WHERE c.Applicant_Info__c =: applicantInfo.Id];
                } 
            }               
            else{
                communicationInfo = new Communication__c();
                communicationInfoList = [Select c.Applicant_Info__r.ETR_Received_Date__c, c.Applicant_Info__r.SOR_Received_Date__c, c.Type__c, c.Type_Code__c, c.To_Address__c, c.SystemModstamp, c.Status__c, c.Sender_Last_Name__c, c.Sender_First_Name__c, c.Recipient_Title__c, c.Recipient_Last_Name__c, c.Recipient_First_Name__c, 
                                         c.Name, c.Method__c, c.Message__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.From_Address__c, c.CreatedDate, c.CreatedById, c.ConnectionSentId, c.ConnectionReceivedId, c.Applicant_Info__c, c.Action_URL__c 
                                         From Communication__c c 
                                         WHERE c.Applicant_Info__c =: applicantInfo.Id];
            } 
            for (Communication__c c : communicationInfoList){
                if (c.Type_Code__c == 'ETR')
                    ETR = true;
                if (c.Type_Code__c == 'SOR')
                    SOR = true;
            }
            // Load Person Info records
            if (applicantInfo.Person_Info__r.size() > 0)
            {
                String role = '';
                
                if (applicantInfo.Type__c == 'Participant')
                {
                    //Code for APC
                    if(applicantInfo.Intrax_Program__c == 'AuPairCare'){
                        
                        role = 'Participant';
                        
                    }else{
                        
                        role = 'Student';
                    }
                    
                    //Check for centers application
                    if(applicantInfo.RecordType.Name == 'Centers') {
                        progId = 'centers-pt';
                    } else if(applicantInfo.RecordType.Name == 'ICD Intern PT' || applicantInfo.RecordType.Name == 'PW Participant') {
                        progId  = 'igi-pt';
                    }                    
                    else if (applicantInfo.RecordType.Name == 'Work Travel PT') {
                        progId = 'wt-pt';
                    }
                    //AA For APC PT
                    else if (applicantInfo.RecordType.Name == 'AuPairCare PT') {
                        progId = 'apc-pt';
                    }
                    else{
                        progId = 'ayusa-pt';
                    }
                }
                else if (applicantInfo.Type__c == 'Host Family')
                {
                    role = 'Host';
                    
                    if(applicantInfo.RecordType.Name == 'AuPairCare HF') {
                        progId = 'apc-hf';
                        system.debug('debug:: Program ID');
                    }
                    else{ 
                        progId = 'ayusa-hf';
                    }
                }
                
                if (ApexPages.currentPage().getParameters().get('role') != null){
                    role = ApexPages.currentPage().getParameters().get('role');
                }
                if (role == 'Both'){
                    role = 'Student';
                }
                if (view == 'Both'){
                    role = 'Student';
                }
                if(ApexPages.currentPage().getParameters().get('isPartner')=='true')
                {
                    IsPartner=True;
                }
                if(ApexPages.currentPage().getParameters().get('isPartner')=='false')
                {
                    IsPartner=false;
                }
                
                if (ApexPages.currentPage().getParameters().get('perid')!= null)
                    
                    personInfoList =  [Select p.Work_Supervisor__c, p.Work_Phone__c, p.Title__c, p.TimeZoneSidKey__c, p.Marital_Status__c,
                                       p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Role_Other__c, p.Residency_Status__c, p.Profession__c, p.Primary_Applicant__c, Source_Referral__c,
                                       p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Nick_Name__c, p.Nationality__c, p.Special_Needs__c, p.Name, p.Mobile__c,
                                       p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Intrax_Program_Option__c,
                                       p.Interests__c, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Employer_Name__c, p.Emergency_Contact_Indicated__c, p.Email__c, p.Education_Level__c,
                                       p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Community_Service__c,
                                       p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c, p.Background_Check__c, p.Background_Check_Msg__c, p.Background_Check_Id__c,
                                       p.Background_Check_Consent_Received__c, p.Background_Check_By__c, p.Background_Check_At__c, p.BGC_Notes__c,p.Do_you_smoke__c, p.Are_you_allergic_to_animals__c,
                                       p.Do_you_have_any_health_concerns__c, p.Applicant_Info__c, p.Family_Member__c, p.Phone__c, p.Applicant_Info__r.Intrax_Center__c,
                                       p.Applicant_Info__r.Program_Duration__c, p.Applicant_Info__r.Visa_Type__c, p.Age__c, p.Applicant_Info__r.Deposit_Fee_Accepted__c, Secondary_School_Indicated__c,
                                       p.Citizenship_Resident_Indicated__c, p.Offence_Indicated__c, p.Criminal_Convictions_Description__c,Source_Referral_Details__c, Contact_Instructions__c,
                                       p.Referral_First_Name__c,p.Referral_Last_Name__c ,p.Referral_State__c,p.Referral_Business_Name__c, Weight_kg__c, Weight_lb__c, Phone_Country_Code_Other__c, 
                                       p.Other_Phone_Type__c, p.Phone_Type__c, p.Hospitalization_Indicated__c, p.Psychiatric_Treatment_Indicated__c,p.Phone_Country_Code__c, p.Height_cm__c, p.Job_Sector__c, p.English_Fluency__c,
                                       p.Overall_Health__c,p.Medication_Indicated__c,p.Medication_Description__c, p.Hospitalization_Description__c,p.Psychiatric_Treatment_Description__c,p.Graduation_Date__c, p.Drug_Dependency_Description__c, p.Physical_Disabilities_Description__c, p.Contagious_Disease_Description__c,
                                       p.Illnesses__c, p.Illness_Description__c, p.Chronic_Disease__c, p.Chronic_Disease_Description__c, p.Pregnancy_Indicated__c,p.Physical_Disabilities_Indicated__c,p.Source_Referral_Other__c, 
                                       p.Contagious_Disease_Indicated__c,p.Drug_Dependency_Indicated__c,p.Braces_Indicated__c,p.Braces_Removal_Date__c,p.Health_Concerns__c, p.Medical_Health_Agreement__c, Reference_Request_Note__c,Program_Phone__c,Program_Phone_Type__c,
                                       p.Physical_Exam_Date__c,p.History_Of_Illness_Indicated__c,p.History_Of_Illness_Details__c, p.Overall_Health_From_Doctor__c,Employment_Status__c
                                       From Person_Info__c p Where p.Applicant_Info__c = :applicantInfo.Id and id = :ApexPages.currentPage().getParameters().get('perid')];
                
                else{                   
                    personInfoList = [Select p.Work_Supervisor__c, p.Work_Phone__c, p.Title__c, p.TimeZoneSidKey__c, p.Marital_Status__c,
                                      p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Role_Other__c, p.Residency_Status__c, p.Profession__c, p.Primary_Applicant__c, Source_Referral__c,
                                      p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Nick_Name__c, p.Nationality__c, p.Special_Needs__c, p.Name, p.Mobile__c,
                                      p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Intrax_Program_Option__c,
                                      p.Interests__c, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Employer_Name__c, p.Emergency_Contact_Indicated__c, p.Email__c, p.Education_Level__c,
                                      p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Community_Service__c,
                                      p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c, p.Background_Check__c, p.Background_Check_Msg__c, p.Background_Check_Id__c,
                                      p.Background_Check_Consent_Received__c, p.Background_Check_By__c, p.Background_Check_At__c, p.BGC_Notes__c,p.Do_you_smoke__c, p.Are_you_allergic_to_animals__c,
                                      p.Do_you_have_any_health_concerns__c, p.Applicant_Info__c, p.Family_Member__c, p.Phone__c, p.Applicant_Info__r.Intrax_Center__c,
                                      p.Applicant_Info__r.Program_Duration__c, p.Applicant_Info__r.Visa_Type__c, p.Age__c, p.Applicant_Info__r.Deposit_Fee_Accepted__c, Secondary_School_Indicated__c,
                                      p.Citizenship_Resident_Indicated__c, p.Offence_Indicated__c, p.Criminal_Convictions_Description__c,Source_Referral_Details__c, Contact_Instructions__c,
                                      p.Referral_First_Name__c,p.Referral_Last_Name__c ,p.Referral_State__c,p.Referral_Business_Name__c, Weight_kg__c, Weight_lb__c, Phone_Country_Code_Other__c,
                                      p.Other_Phone_Type__c, p.Phone_Type__c, p.Hospitalization_Indicated__c, p.Psychiatric_Treatment_Indicated__c,p.Phone_Country_Code__c, p.Height_cm__c, p.Job_Sector__c, p.English_Fluency__c,
                                      p.Overall_Health__c,p.Medication_Indicated__c,p.Medication_Description__c, p.Hospitalization_Description__c,p.Psychiatric_Treatment_Description__c,p.Graduation_Date__c, p.Drug_Dependency_Description__c, p.Physical_Disabilities_Description__c, p.Contagious_Disease_Description__c,
                                      p.Illnesses__c, p.Illness_Description__c, p.Chronic_Disease__c, p.Chronic_Disease_Description__c, p.Pregnancy_Indicated__c,p.Physical_Disabilities_Indicated__c,
                                      p.Contagious_Disease_Indicated__c,p.Drug_Dependency_Indicated__c,p.Braces_Indicated__c,p.Braces_Removal_Date__c,p.Health_Concerns__c,p.Source_Referral_Other__c,
                                      p.Medical_Health_Agreement__c, Reference_Request_Note__c,Program_Phone__c,Program_Phone_Type__c,
                                      p.Physical_Exam_Date__c,p.History_Of_Illness_Indicated__c,p.History_Of_Illness_Details__c, p.Overall_Health_From_Doctor__c,Employment_Status__c
                                      From Person_Info__c p 
                                      Where p.Applicant_Info__c = : aId and role__c = :role]; 
                    
                }
                
                
                accountInfo = [select Id,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry,FirstName from Account where Id  = :applicantInfo.Account__c];
                parentInfoList = [select p.Primary_Applicant__c, p.Role_Other__c, p.Title__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Family_Member__c From Person_Info__c p Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Parent'];
                familyInfoList = [select p.Primary_Applicant__c,p.Residency_Status__c, p.Role_Other__c, p.Title__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Family_Member__c From Person_Info__c p Where p.Applicant_Info__c = :applicantInfo.Id and role__c != 'Student' and role__c != 'Reference' and Family_Member__c = true];
                refererInfoList = [select p.Primary_Applicant__c, p.Role_Other__c, p.Title__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Family_Member__c From Person_Info__c p Where p.Applicant_Info__c = :applicantInfo.Id and role__c = 'Reference'];
                EmergencyInfoList = [select p.Primary_Applicant__c, p.Role_Other__c, p.Title__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Family_Member__c From Person_Info__c p Where p.Applicant_Info__c = :applicantInfo.Id and Emergency_Contact_Indicated__c = 'Yes']; 
                
                //AA APC Emergency Contact
                if (personInfoList.size() == 0 || ApexPages.currentPage().getParameters().get('add') == 'true'){
                    personInfo = new Person_Info__c();
                    system.debug('****** Are we getting here? ' + role);    
                    if(role == 'EmergencyContact'){
                        role = 'Other';
                        personInfo.Role__c = role;
                        personInfo.Emergency_Contact_Indicated__c = 'Yes';                      
                    }
                    else{
                        personInfo.Role__c = role;                        
                    }
                }
                
                else{
                    personInfo = personInfoList[0];
                }
                
                if (parentInfoList.size() == 0){
                    parentInfo = new Person_Info__c();
                    parentInfo.Role__c = 'Parent';
                }
                else{
                    parentInfo = parentInfoList[0];
                }
            }
            else{
                personInfo = new Person_Info__c();
            }
            
            if(progId!=null && ApexPages.currentPage().getParameters().get('docType')!=null && applicantInfo!=null){
                string RetString = DeriveRetParam(progId);
                System.debug('####### RetString' +RetString); 
                if(RetString != null)
                    retParam = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(RetString)),'UTF-8');
                System.debug('####### retParam' +retParam); 
            }
            
            
            // **IGI 2.0 -- Specific actions and vars values
            if(applicantInfo.Intrax_Program__c == 'Internship'){
                // We don?t need this for now.
                //if(applicantInfo.Application_Level__c == 'Main')  
                
                // Initializing Languages Values
                if(applicantInfo.Language_3__c != null) addLanguage = 3;
                else if(applicantInfo.Language_2__c != null) addLanguage = 2;
                else if(applicantInfo.Language_1__c != null) addLanguage = 1;
                else addLanguage = 0;
                
                system.debug('******* AddLanguage: ' + addLanguage);
                
                if(applicantInfo.Country_of_Interest__c == 'United States' && personInfo.Country_of_Residence__c == 'United States'){
                    if(personInfo.Citizenship__c == 'United States'){
                        igi_visa_status = '';
                    }else{
                        if(applicantInfo.Visa_Category__c == 'Student (F)' & applicantInfo.Visa_Type__c == 'F-1 Student') igi_visa_status = 'no_need_visa';
                        else if(applicantInfo.Visa_Category__c == 'Intern (J)' & applicantInfo.Visa_Type__c == 'J-1') igi_visa_status = 'need_visa';
                    }
                } 
                
                if(personInfo.Citizenship__c == personInfo.Country_of_Residence__c && personInfo.Country_of_Residence__c != null){
                    citizen = 'Yes';
                } else if(personInfo.Citizenship__c == null || personInfo.Citizenship__c == ''){ 
                    citizen = '';   
                } else citizen = 'No';
                
                if(applicantInfo.One_Year_Work_Experience__c == true) one_year_exp = 'Yes';
                else if(applicantInfo.One_Year_Work_Experience__c == false) one_year_exp = 'No';
                
                if(applicantInfo.Five_Years_Work_Experience__c == true) five_years_exp = 'Yes';
                else if(applicantInfo.Five_Years_Work_Experience__c == false) five_years_exp = 'No';            
                
                if(IUtilities.IsIncluded(applicantInfo.Intrax_Program_Options__c, 'Internship Group')) faculty_led_program = 'Yes';
                //else if(!IUtilities.IsIncluded(applicantInfo.Intrax_Program_Options__c, 'Internship Group') && applicantInfo.Country_of_Interest__c != 'United States') faculty_led_program = 'No';               
                else faculty_led_program = 'No';
            }
            
        }
        else inIt();
        
        //AA Multi-FileLoader Change
        If(applicantInfo.RecordType.Name=='AuPairCare PT' || applicantInfo.RecordType.Name=='ICD Intern PT' || applicantInfo.RecordType.Name=='AuPairCare HF'){
            fileUploadUrl = Constants.fileUploadUrl2;
        }else{
            fileUploadUrl = Constants.fileUploadUrl; 
        }
        system.debug('debug::NewCode'+fileUploadUrl);
        videoUploadUrl = EndPointGenerator.getEndpoint('videoUploadUrl');
        
        if(ApexPages.currentPage().getParameters().get('participantId')!= null){
            
            participantId = ApexPages.currentPage().getParameters().get('participantId');
            
        }
        
        //Retrieve list info
        //Retrive the info only if record type is not Centers or IGI 
        if(applicantInfo.RecordType.Name != 'AuPairCare PT' && applicantInfo.RecordType.Name != 'AuPairCare HF' ){
            if(applicantInfo.RecordType.Name != 'Centers' || applicantInfo.RecordTypeId != Constants.ICD_Intern_PT_Record_Type_Id || applicantInfo.RecordTypeId != Constants.PW_PT_Record_Type_Id) {
                system.debug('***** RT: ' + applicantInfo.RecordType.Name);
                getEssayList();
                getEssayInfo();
                getParentLetter();          
                getFamilyLetter();       
                getFamilyInfoList();
                getLocationInfoList();
                getRefererInfoList();
                getEmergencyInfoList();
            }
        }
        
        if(applicantInfo.RecordType.Name == 'AuPairCare HF' || applicantInfo.RecordType.Name == 'AuPairCare PT'){
            
            system.debug('***** RT-APC: ' + applicantInfo.RecordType.Name);
            getEssayList();
            
        }
        
        AirportsUSA = getAirportsListUSA();
        
        //Memory Allocation to the lists
        listPositionInfo = new List<Position_Info__c>();
        listPositionInfoSecond = new List<Position_Info__c>(); 
        
        // prepopulating a ExperienceDetails list for APC Parents
        
        
        //Begening APC Code for experience and experience details       
        wrappersExp = new List<ExperienceDetailWrapper>();
        try{
            system.debug('*****### HERE ');
            
            
            
            
            if (ApexPages.currentPage().getParameters().get('eid') != null) {
                
                //listExperienceChild = new list<Experience__c>();   
                //Query for Experience Data
                ideisRef = 0;
                
                list<Experience__c> listExperienceAUX = new list<Experience__c>();    
                
                //getting the whole list of Experience records that are experienced. We need this query to provide a value to "ideisRef" into  getCheckAPCParticipantReferences()
                listExperienceAUX = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                     exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                     exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c,
                                     exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                     exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Reference_Language__c,
                                     exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,  exp.Reference_Received__c
                                     FROM Experience__c exp 
                                     WHERE exp.Applicant_Info__c = :applicantInfo.Id AND IsExperienced__c = true];
                
                
                listExperience = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                  exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                  exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c, 
                                  exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,            
                                  exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c,exp.Reference_Language__c,
                                  exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c, exp.Reference_Received__c
                                  FROM Experience__c exp 
                                  WHERE exp.Applicant_Info__c = :applicantInfo.Id
                                  AND IsExperienced__c = true AND exp.Id = :ApexPages.currentPage().getParameters().get('eid')];
                
                
                if(listExperienceAUX.size() > 0) {
                    
                    for(Experience__c expersizeAux: listExperienceAUX){
                        if(expersizeAux.IsReference__c == true ){
                            ideisRef++;
                        }
                    }
                    
                }
                
                //Check list for size
                if(listExperience.size() > 0) {
                    experience = listExperience[0];
                    system.debug('@@@@@ get Reference info from Experience');
                    
                    if(experience.isReference__c == true){
                        
                        referenceList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
                                         Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
                                         Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c, CreatedDate, LastModifiedDate, Status__c 
                                         from Reference__c where Experience_Name__c =: experience.Id AND Reference_Status__c = 'Active' limit 1];
                        if(referenceList!=null && referenceList.size()>0){
                            
                            reference=referenceList[0];
                            system.debug('@@@@@ reference.Email__c: ' + reference.Email__c);
                            system.debug('@@@@@ reference.Reference_Requested__c: ' + reference.Reference_Requested__c);
                        }   
                    }
                    
                }else{
                    experience = new Experience__c();
                    listExperience = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                      exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                      exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c, exp.Current_Job__c,
                                      exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                      exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Frequency__c,exp.Reference_Language__c,
                                      exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c, exp.Reference_Received__c
                                      FROM Experience__c exp 
                                      WHERE exp.Applicant_Info__c = :applicantInfo.Id AND IsExperienced__c = true];
                }
                
                //show experience details values if 'eid' is == true
                experDetails = [select p.Id, p.Name, p.Experience_Name__c, p.Date_of_Birth__c, Special_Needs_Description__c, Special_Needs_Indicated__c, Gender__c
                                From Experience_Detail__c p 
                                Where p.Experience_Name__c = :ApexPages.currentPage().getParameters().get('eid') 
                                order by CreatedDate ASC];
                
                if(experDetails.size()>0 && experDetails!= null){                
                    for (Experience_Detail__c c: experDetails){
                        ExperienceDetailWrapper chiildrenExp = new ExperienceDetailWrapper(nextIdentExp++,c);
                        wrappersExp.add(chiildrenExp);
                    }
                    wrapperExpsize=wrappersExp.size(); 
                    system.debug('*****####existing wrappersExp; ' + wrappersExp);  
                    
                }else{
                    
                    system.debug('*****#### Creating defaul Experience Detail');                
                    
                    for (Integer idx=0; idx < 1; idx++){
                        
                        ExperienceDetailWrapper Expchildren = new ExperienceDetailWrapper(nextIdentExp++);
                        wrappersExp.add(Expchildren);
                        
                    }
                    
                    wrapperExpsize=wrappersExp.size();
                    system.debug('*****####wrappersExp.size(); ' + wrappersExp.size());
                    system.debug('*****####wrappersExp; ' + wrappersExp);
                    
                }
                
                
            }               
            else{
                
                system.debug('*****### showing expereince info ');
                ideisRef = 0;
                experience = new Experience__c();
                listExperienceChild = new list<Experience__c>();
                listExperienceChildAUX = new list<Experience__c>();
                
                
                
                listExperience = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                  exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                  exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c,exp.Current_Job__c,
                                  exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                  exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c,exp.Reference_Language__c,
                                  exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c,  exp.Reference_Received__c
                                  FROM Experience__c exp 
                                  WHERE exp.Applicant_Info__c = :applicantInfo.Id AND IsExperienced__c = true order by exp.Experience_Type__c ASC];
                system.debug('*****### listExperience: ' + listExperience);
                
                system.debug('*****#### Creating defaul Experience Detail');
                
                if(listExperience.size() > 0) {
                    
                    for(Experience__c expersize: listExperience){
                        
                        system.debug('*****@@@1 Experience Current_Job__c -- Name: ' + expersize.Name + '; Current_Job__c: ' + expersize.Current_Job__c);
                        if(expersize.IsReference__c == true ){
                            ideisRef++;
                        }
                        
                        //Condition to update End Date if the experience is the current job of the APC PT 
                        if(expersize.Current_Job__c == true){
                            system.debug('*****@@@2 Experience Current_Job__c -- Name: ' + expersize.Name);
                            expersize.End_Date__c = date.today();
                            listExperienceChildAUX.add(expersize);
                        }
                    }
                    
                    //Updating experience to end date = date.today(); We will change this value to a final date when the reference fill out the  Reference Flow Form
                    
                    
                    system.debug('*****### listExperienceAQUI: ' + listExperience);
                    listExperienceChild = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                           exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                           exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c,exp.Current_Job__c,
                                           exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                           exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Reference_Language__c,
                                           exp.Frequency__c, exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c, exp.Reference_Received__c
                                           FROM Experience__c exp 
                                           WHERE exp.Applicant_Info__c = :applicantInfo.Id AND IsExperienced__c = true
                                           AND (exp.Experience_Type__c != 'Sibling/Family') AND (exp.Experience_Category__c =: 'Private/Individual' OR exp.Experience_Category__c =: 'Public/Group')]; 
                }
                
                for (Integer idx=0; idx < 1; idx++){
                    
                    ExperienceDetailWrapper Expchildren = new ExperienceDetailWrapper(nextIdentExp++);
                    wrappersExp.add(Expchildren);
                    
                }
                wrapperExpsize=wrappersExp.size();
                system.debug('*****####wrappersExp.size(); ' + wrappersExp.size());
                system.debug('*****####wrappersExp; ' + wrappersExp);
                
            } 
            
            //**BEGIN** APC/Jose - Getting a list of all AuPair recreference for apc_ap_main_reference_check B-02180
            referenceListCheck = new list<Reference__c>();
            
            if(URLAux != null){              
                system.debug('@@@@@inside Reference check/page:' + URLAux);
                if(URLAux.contains('/apex/apc_ap_main_reference_check')){
                    referenceListCheck = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
                                          Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId, Reference_Created_Date__c,
                                          Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c, CreatedDate, LastModifiedDate, Status__c 
                                          from Reference__c where Applicant_Info__c =: applicantinfo.Id AND (Reference_Status__c = 'Active' OR Status__c = 'Rejected' ) ];
                    
                    
                }
            }
            //**END** APC/Jose - Getting a list of all AuPair recreference for apc_ap_main_reference_check B-02180
            
        }catch(Exception e){
            
            system.debug('***** Impossible to update related Experience: '+ e);
            
        }   
        //END APC Code for experience and experience details
        
        //Query for Position Info Records
        listPositionInfo = [Select pos.Id, pos.Applicant_Info__c, pos.Company_Annual_Revenue__c, pos.Company_City__c, 
                            pos.Company_Country__c, pos.Company_Description__c, pos.Company_Name__c, pos.Company_Phone__c, 
                            pos.Company_Postal_Code__c, pos.Company_State__c, pos.Company_Street_1__c, pos.Company_Street_2__c, 
                            pos.Company_Website__c,pos.Placement_Number__c, pos.Number_of_Employees__c, pos.Position_Category__c, 
                            pos.Position_Description__c, pos.Position_Title__c, pos.Supervisor_Email__c, pos.End_Date__c, pos.Start_Date__c,
                            pos.Supervisor_First_Name__c, pos.Supervisor_Last_Name__c, pos.Supervisor_Phone__c, pos.Intrax_Program_Category__c, pos.Functional_Areas__c, pos.Functional_Areas_Other__c, pos.Tipped_Position__c,
                            Pay_Rate__c, Pay_Rate_Basis__c
                            FROM Position_Info__c pos 
                            where pos.Applicant_info__c != '' and  pos.Applicant_info__c =: ApexPages.currentPage().getParameters().get('Id') and pos.Placement_Number__c!=2];
        
        //Check list for size      
        if(listPositionInfo.size() > 0) {
            system.debug('listPositionInfo : ' + listPositionInfo);
            positionInfo = listPositionInfo[0];
        } else {
            positionInfo = new Position_Info__c();
        }
        
        if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.Application_Level__c == 'Main'){
            if(positionInfo.Company_Name__c != null && (positionInfo.Pay_Rate__c == 0 || positionInfo.Pay_Rate__c == null)){ 
                paid_internship = 'No';
            } else if(positionInfo.Company_Name__c != null && positionInfo.Pay_rate__c > 0){
                paid_internship = 'Yes';
            }
        }
        
        //Query for Second Position Info Records
        if (applicantInfo.Intrax_Program__c == 'Internship' ) 
        {
            listPositionInfoSecond = [Select pos.Id, pos.Applicant_Info__c, pos.Company_Annual_Revenue__c, pos.Company_City__c, 
                                      pos.Company_Country__c, pos.Company_Description__c, pos.Company_Name__c, pos.Company_Phone__c, 
                                      pos.Company_Postal_Code__c, pos.Company_State__c, pos.Company_Street_1__c, pos.Company_Street_2__c, 
                                      pos.Company_Website__c,pos.Placement_Number__c, pos.Number_of_Employees__c, pos.Position_Category__c, 
                                      pos.Position_Description__c, pos.Position_Title__c, pos.Supervisor_Email__c, pos.End_Date__c, pos.Start_Date__c,
                                      pos.Supervisor_First_Name__c, pos.Supervisor_Last_Name__c, pos.Supervisor_Phone__c, pos.Intrax_Program_Category__c, pos.Functional_Areas__c, pos.Functional_Areas_Other__c, pos.Tipped_Position__c,
                                      Pay_Rate__c, Pay_Rate_Basis__c
                                      FROM Position_Info__c pos 
                                      where   pos.Applicant_info__c != '' and pos.Applicant_info__c =: ApexPages.currentPage().getParameters().get('Id') and pos.Placement_Number__c=2];
            
            //Check list for size  
            if(listPositionInfoSecond.size() > 0) {
                positionInfoSecond = listPositionInfoSecond[0];
            } 
            else 
            {
                positionInfoSecond = new Position_Info__c();
            }
        }
        
        if(applicantInfo.Intrax_Program__c == 'Internship' && applicantInfo.Application_Level__c == 'Main'){
            if(positionInfoSecond.Company_Name__c != null && (positionInfoSecond.Pay_Rate__c == 0 || positionInfoSecond.Pay_Rate__c == null)){ 
                paid_internshipSecond = 'No';
            } else if(positionInfoSecond.Company_Name__c != null && positionInfoSecond.Pay_rate__c > 0){
                paid_internshipSecond = 'Yes';
            }
        }
        //End Query for Second Position Info Records
        
        //Setting Value for Study Weeks field with the selected one
        if(applicantInfo.Study_Weeks__c != null && selectedStudyWeeks != '')
            selectedStudyWeeks = String.valueOf(applicantInfo.Study_Weeks__c);
        
        //Check for PhotoDoc Description
        if(applicantInfo.PhotoId__c != null) {
            List<Attachment> attachments = [SELECT ID, Name, Description FROM Attachment WHERE ID =: applicantInfo.PhotoId__c];
            System.debug('####### Value in attachments' +attachments);
            
            //Check for Attachments
            if(attachments != null || attachments.size() >0) {
                if(attachments[0].Description != null)
                    uploadDocDescription = attachments[0].Description;
            }
        }
        
        //Populating Service Level with respect to the user selection (Yes/No)
        if(applicantInfo.Service_Level__c != null && applicantInfo.Service_Level__c != '' && applicantInfo.Service_Level__c == 'Independent') {
            selectedServiceLevel = Constants.YES;
        } 
        
        else if(applicantInfo.Service_Level__c != null && applicantInfo.Service_Level__c != '' && applicantInfo.Service_Level__c == 'Premium') {
            selectedServiceLevel = Constants.NO;
        } 
        
        //Setting defaults and memeory allocation to the variables related to Payment Process
        //Map to hold current URL header parameters
        Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();   
        
        //Proceed further only and only if map of header parameter have not null value with it
        if(mapHeaders != null) {
            
            ipAddress = mapHeaders.get(PaymentConstants.TRUE_CLIENT_IP);
            if(ipAddress == null){
                ipAddress = mapHeaders.get(PaymentConstants.X_SALESFORCE_SIP);
            }
        }
        
        
        //loop through the Applicant Infor records and populate map     
        for(Applicant_Product__c appProduct : [Select Id, Product__c, Applicant_Info__c, Product_Name__c, Product_Name_Label__c, Description__c, Sort_Order__c, Unit_Price__c, Quantity__c, Start_Date__c, Product__r.Start_Date__c, Help_Text__c, Help_Text_Label__c, Product__r.Family, Product__r.Description, Promo_CTA__c,Promo_CTA_Label__c, Product__r.Product_Description_Label__c, Product_Description_Label__c from Applicant_Product__c 
                                               where Applicant_Info__c =: applicantInfo.Id 
                                               AND Product__c != null AND ( Product__r.Family = 'Package Delivery' OR Product__r.Family = 'Insurance' )]) {
                                                   
                                                   //Populate Map            
                                                   mapAppProductFamily.put(appProduct.Product__r.Family, appProduct.Product__c);//ID1,T_0316                            
                                               }
        
        selectedInsuranceValue = mapAppProductFamily.get(Constants.INSURANCE);
        System.debug('-----applicantInfo.Visa_Category__c'+applicantInfo.Visa_Category__c);
        if(ApplicantInfo.Visa_Category__c == 'Student (F)') 
            selectedPackageDelValue = mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY);        
        System.debug('-----mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY)'+mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY));
        
        //Memory allocation
        payment = new Payment__c();
        payWrapper = new PaymentWrapper();
        isConfirmPayment = false;
        useCurrentBillingAddressInfo = false;           
        
        if(ApexPages.currentPage().getParameters().get('expireMonth') != null) 
            monthSelected = ApexPages.currentPage().getParameters().get('expireMonth');
        if(ApexPages.currentPage().getParameters().get('expireYear') != null) 
            yearSelected = ApexPages.currentPage().getParameters().get('expireYear');
        if(ApexPages.currentPage().getParameters().get('maskCCNumber') != null) 
            maskedCCNumber = ApexPages.currentPage().getParameters().get('maskCCNumber');
        
        if(ApexPages.currentPage().getParameters().get('paymentTxId') != null) 
            paymentTxId = ApexPages.currentPage().getParameters().get('paymentTxId');
        if(ApexPages.currentPage().getParameters().get('paymentAmount') != null) 
            paymentAmount = ApexPages.currentPage().getParameters().get('paymentAmount');
        if(ApexPages.currentPage().getParameters().get('paymentDate') != null) 
            paymentDate = ApexPages.currentPage().getParameters().get('paymentDate');
        
        if(ApexPages.currentPage().getParameters().get('paymentId') != null) {
            paymentRecordId = ApexPages.currentPage().getParameters().get('paymentId');
            
            List<Payment__c> paymentRecords = [Select Id, Amount__c, Txn_Id__c FROM Payment__c WHERE ID =: ID.valueOf(paymentRecordId)];
            if(paymentRecords.size() > 0) {
                payWrapper.amount = paymentRecords[0].Amount__c;
                payWrapper.txnId =  paymentRecords[0].Txn_Id__c;
            }
        }
        /*
//AA IGI Pricing
If(ApexPages.currentPage().getUrl().contains('/apex/igi_pt_app_program_pref') && applicantInfo.Intrax_Program__c=='Internship' && personInfo.Country_of_Residence__c!= null && applicantInfo.Country_of_Interest__c!= null && applicantInfo.Intrax_Program_Category__c != null){
loadIgiPricing();
system.debug('IGI Pricing Constructor');
}*/
    }
    
    // DocType Fetching From Constants Maps
    public String DeriveRetParam(String ProgramId)
    {
        string retParam;
        string DocumentType;
        
        if(ApexPages.currentPage().getParameters().get('docType')!=null)
        {
            DocumentType =  ApexPages.currentPage().getParameters().get('docType');
            System.debug('####### docType' +DocumentType);
        }
        
        if(ProgramId=='centers-pt' && applicantInfo!=null){
            if(Constants.CENTERS_DOCTYPES.containsKey(DocumentType)) 
            {
                retParam=Site.getCurrentSiteUrl().removeEnd('/') +  Constants.CENTERS_DOCTYPES.get(DocumentType);
                System.debug('####### retParam' +retParam); 
                //System.debug('#######  applicantInfo.Id' + applicantInfo.Id); 
                retParam = retParam + '&id=' + applicantInfo.Id;
                
                System.debug('####### retParam' +retParam);     
            } 
        }  
        else if(ProgramId=='igi-pt' && applicantInfo!=null){
            
            if(Constants.IGI_DOCTYPES.containsKey(DocumentType)) 
            {
                retParam= Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.IGI_DOCTYPES.get(DocumentType);
                System.debug('####### retParam' +retParam); 
                retParam = retParam + '&id=' + applicantInfo.Id;
                System.debug('####### retParam' +retParam);     
            } 
        }
        // Code added for WT apps
        else if(ProgramId=='wt-pt' && applicantInfo!=null){
            if(Constants.WT_DOCTYPES.containsKey(DocumentType)) 
            {
                retParam= Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.WT_DOCTYPES.get(DocumentType);
                System.debug('####### retParam' +retParam); 
                retParam = retParam + '&id=' + applicantInfo.Id;
                System.debug('####### retParam' +retParam);     
            } 
        }
        // For APC DocumentUpload
        else if(ProgramId=='apc-pt' && applicantInfo!=null){
            if(Constants.APC_DOCTYPES.containsKey(DocumentType)) {
                try{
                    retParam= Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.APC_DOCTYPES.get(DocumentType);
                    
                }catch(Exception e){
                    retParam = URL.getSalesforceBaseUrl().toExternalForm() + '/apex' + Constants.APC_DOCTYPES.get(DocumentType);
                }
                System.debug('####### retParam' +retParam); 
                retParam = retParam + '&id=' + applicantInfo.Id;
                System.debug('####### retParam (APC): ' +retParam);
            }
        }
        else if(ProgramId=='apc-hf' && applicantInfo!=null){
            if(Constants.APC_HF_DOCTYPES.containsKey(DocumentType)) {
                retParam= Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.APC_HF_DOCTYPES.get(DocumentType);
                System.debug('####### retParam' +retParam); 
                retParam = retParam + '&id=' + applicantInfo.Id;
                System.debug('####### retParam (APC): ' +retParam);
            }
        }
        else{
            if(Constants.AYUSA_DOCTYPES.containsKey(DocumentType)) {
                
                if(UserInfo.getUserType() != 'PowerPartner') {
                    retParam= Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.AYUSA_DOCTYPES.get(DocumentType);
                }
                System.debug('####### retParam' +retParam); 
                // System.debug('#######  applicantInfo.Id' + applicantInfo.Id); 
                retParam = retParam + '&id=' + applicantInfo.Id;
                
                System.debug('####### retParam' +retParam);  
            }   
        }
        
        return retParam;
    }
    //init method
    public void inIt() {
        applicantInfo = new Applicant_Info__c();
        system.debug('KK New Applicantion line 1267');
        String userId = userInfo.getUserId();
        
        User activeUser = [select email,Phone,street,city,state,postalcode,country,type__c from User where Id = :userId];
        personInfo = new Person_Info__c();
        if(activeUser.Type__c != 'Institution'){
            personInfo.First_Name__c = userInfo.getFirstName();
            personInfo.Last_Name__c = userInfo.getLastName();
            personInfo.Email__c = activeUser.email;
        }
        personInfo.Role__c = 'Student';
        communicationInfo = new Communication__c();          
        schoolInfo = new School__c();
        locationInfo = new Location__c();
        familyInfo = new Person_Info__c();
        refererInfo=new Person_Info__c();
        essayList = new List<Essay__c>();
        photoDoc = new Attachment();        
        //mapSiteTexts = Constants.MAP_SITE_TEXT;
        //APC variable for payment
        isPaymentSuccessful = true;
        //##End APC variable for payment
        
        getLang();
        
    }
    
    public List<Intrax_Program_Upload__c> getDocListAll(){
        
        return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                where d.Applicant_Info__c =: applicantInfo.Id order by d.Document_Type__c desc ];  
        
    }
    public List<Intrax_Program_Upload__c> getPhotoListAll(){
        
        return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Participant-Photo') order by d.Document_Type__c desc ];  
        
    }
    
    public list<Assessment__c> getPRIntvList()
    {
        system.debug('@@@@@applicantInfo.Id: ' + applicantInfo.Id);
        system.debug('@@@@@Constants.ASS_APC_PT_PR_Interview: ' + Constants.ASS_APC_PT_PR_Interview);
        return [Select Id, Name, Status__c, Assessment_Date__c  FROM Assessment__c WHERE Application__c =: applicantInfo.Id AND RecordTypeId =: Constants.ASS_APC_PT_PR_Interview];
    }
    
    public list<Assessment__c> getHFPRIntvList()
    {
        system.debug('@@@@@applicantInfo.Id: ' + applicantInfo.Id);
        system.debug('@@@@@Constants.ASS_APC_HF_PR_Interview: ' + Constants.ASS_APC_HF_PR_Interview);
        return [Select Id, Name, Status__c, Assessment_Date__c,Position_Name__r.owner.Name,Position_Name__r.owner.Email,Position_Name__r.owner.phone FROM Assessment__c WHERE Application__c =: applicantInfo.Id AND RecordTypeId =: Constants.ASS_APC_HF_PR_Interview];
    }
    
    /*  
public List<Intrax_Program_Upload__c> getDocPersonList()
{
return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c,Person_Info__c from Intrax_Program_Upload__c d
where d.Person_Info__c IN (SELECT id from Person_Info__c WHERE applicant_info__c =:applicantInfo.Id)];
}
*/
    //Fetch Upload Docs List
    public List<Intrax_Program_Upload__c> getDocList(){
        docType = ApexPages.currentPage().getParameters().get('docType');
        if(docType=='All'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id];
        }
        else if(docType=='AllDocuments'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('FinancialResponsibility','I-20', 'Proof-of-Insurance', 'F1-Visa','Passport') ];
        }
        else if(docType=='Passport' && applicantInfo.RecordType.Name == 'Ayusa PT'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Passport', 'Birth-Certificate') ];
        }
        else if(docType=='Health' && applicantInfo.RecordType.Name == 'Ayusa PT'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Doctor', 'Immunization-Chart','Health') ];
        }
        else if(docType=='Doctor'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Doctor') ];
        }
        else if(docType=='Doctor-Partner'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Doctor', 'Doctor-Partner') ];
        }
        else if(docType=='Agreements' && applicantInfo.RecordType.Name == 'Ayusa PT'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('PT-Agreements', 'Agreements') ];
        }
        else if(docType=='Partner' && applicantInfo.RecordType.Name == 'Ayusa PT'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Medical-Release', 'English-Test', 'Grade-Conversion-Chart', 'Interview-Document', 'Partner-Agreement', 'Partner') ];
        }
        else if(docType=='FinancialResponsibility'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('FinancialResponsibility','I-20', 'Proof-of-Insurance', 'F1-Visa') ];
        }
        else if(docType=='Academic'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('School','Teacher') ];
        }
        else if(docType == 'HostAgreements'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('HFAgreements','BackgroundCheck') ];
        }
        else if(docType == 'Resume'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Resume') ];
        }
        /*Jose APC retrieve Profile Photo for HF and PT*/
        else if(docType == 'Participant-Photo' && applicantInfo.Intrax_Program__c == 'AuPairCare'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Participant-Photo') ];
        }
        /*IGI App 2.0 NEW CODE*/
        else if(docType == 'Participant-Photo' && applicantInfo.RecordType.Name == 'PW Participant'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Participant-Photo', 'Passport', 'Previous-Visa','Other') ];
        }
        else if(docType == 'Participant-Photo' && applicantInfo.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Participant-Photo') ];
        }
        else if(docType == 'WT-Participant-Photo' && applicantInfo.RecordTypeId == Constants.WT_PT_Record_Type_Id){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Participant-Photo') ];
        }
        else if(docType == 'igi-documents' && (applicantInfo.Intrax_Program_Category__c == 'Business' || applicantInfo.Intrax_Program_Category__c == 'Engineering' || applicantInfo.Intrax_Program_Category__c == 'Information Media & Communications' || applicantInfo.Intrax_Program_Category__c == 'Public Administration & Law')){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c, Review_Status__c, d.Person_Info__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('DS-7002-(Company-Signature)', 'DS-7002-(Complete)', 'DS-7002-(Participant-Signature)', 'Extension-DS-7002-(Complete)','Offer-Document', 'FinancialResponsibility', 'Interview-Document', 
                                                                                             'NP-Double-Placement-Agreement', 'Offer-Document', 'PT-Double-Placement-Agreement', 'Participant-Eligibility-Form', 'Passport', 'Pre-Departure-Orientation-Agreement', 'Previous-Visa', 'Resume', 'University-Letter', 'Transcripts', 'University-Letter-Translation', 
                                                                                             'Introductory-Video', 'Proof-of-Language-Level', 'University-Diploma', 'Letter-of-Recommendation')];
        }else if(docType == 'igi-documents' && applicantInfo.Intrax_Program_Category__c == 'Hospitality & Tourism'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c, Review_Status__c, d.Person_Info__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('DS-7002-(Company-Signature)', 'DS-7002-(Complete)', 'DS-7002-(Participant-Signature)','Extension-DS-7002-(Complete)', 'Offer-Document', 'FinancialResponsibility', 'Interview-Document', 
                                                                                             'NP-Double-Placement-Agreement', 'Offer-Document', 'PT-Double-Placement-Agreement', 'Participant-Eligibility-Form', 'Passport', 'Previous-Visa', 'Resume', 'University-Letter', 'Transcripts', 'University-Letter-Translation', 
                                                                                             'Introductory-Video', 'Proof-of-Language-Level', 'University-Diploma', 'Letter-of-Recommendation')];
        }else if(docType == 'igi-documents' && applicantInfo.Intrax_Program_Category__c == 'Social Development'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c, Review_Status__c, d.Person_Info__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('DS-7002-(Complete)', 'Interview-Document', 'Resume', 'University-Letter', 'University-Letter-Translation', 
                                                                                             'Introductory-Video', 'Proof-of-Language-Level', 'University-Diploma', 'Letter-of-Recommendation')];
            
        }
        else if(docType == 'igi-dependentdocs'){
            /*  return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c, Review_Status__c from Intrax_Program_Upload__c d
where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Passport', 'FinancialResponsibility' , 'Proof-of-Relationship')];
*/             
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c,d.Person_Info__c from Intrax_Program_Upload__c d
                    where d.Document_Type__C IN ('Passport', 'FinancialResponsibility' , 'Proof-of-Relationship') and d.Person_Info__c IN (SELECT id from Person_Info__c WHERE applicant_info__c =:applicantInfo.Id)];
            
        }
        /* IGI App 2.0 OLD CODE
else if(docType == 'Participant-Photo' && (applicantInfo.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id || applicantInfo.RecordType.Name == 'PW Participant')){
return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C IN ('Participant-Photo', 'Passport', 'Previous-Visa','Other') ];
}*/
        else
        {
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                    where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__C = :docType ];
        }  
        
    }
    
    //AA Education
    public void LoadEduDocRecord(){
        system.debug('debug::Inside LoadEduDocRecord');
        list<Education__c> listedu= [select id from education__c where Applicant_Info__c =: applicantInfo.Id order by createddate];
        for(Education__c eduloop: listedu){
            DocmapEducation.put(eduloop.id, new List <Intrax_Program_Upload__c> ());       
        }
        DocListEducation= [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c,d.Education__c from Intrax_Program_Upload__c d
                           where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__c IN('University-Diploma','Secondary-School-Diploma','Certificate') order by d.Document_Type__c desc ];
        
        DocListSchool= [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c,d.Education__c from Intrax_Program_Upload__c d
                        where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__c IN('Secondary-School-Diploma') order by d.Document_Type__c desc ];   
        system.debug('debug::Inside getDocListEducation===='+DocListEducation);
        
        DocListUniversity= [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c,d.Education__c from Intrax_Program_Upload__c d
                            where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__c IN('University-Diploma') order by d.Document_Type__c desc ];  
        
        DocListCertification= [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c,d.Education__c from Intrax_Program_Upload__c d
                               where d.Applicant_Info__c =: applicantInfo.Id and d.Document_Type__c IN('Certificate') order by d.Document_Type__c desc ];  
        
        If(DocListEducation.size()>0){
            for(Intrax_Program_Upload__c ipu : DocListEducation){
                if (DocmapEducation.containsKey(ipu.Education__c)){
                    DocmapEducation.get(ipu.Education__c).add(new Intrax_Program_Upload__c(id = ipu.id,document_guid__c=ipu.document_guid__c,Document_Name__c=ipu.Document_Name__c,Education__c=ipu.Education__c));
                }
                else if(ipu.Education__c != null || ipu.Education__c != ''){
                    DocmapEducation.put(ipu.Education__c, new List <Intrax_Program_Upload__c> {ipu});
                }
            }
            system.debug('debug::Inside getDocmapEducation===='+DocmapEducation); 
        } 
    } 
    
    public map<string,string> getDocTypeList()
    {
        set<string> unqDocList = new set<string>();
        map <string,string> doctypestr = new map <string,string>();
        List<Intrax_Program_Upload__c> alldoclst = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                                                    where d.Applicant_Info__c =: applicantInfo.Id];
        
        system.debug('App ID****'+applicantInfo.Id);
        
        if(alldoclst.size() > 0)
        {
            for(Intrax_Program_Upload__c doctypestrsingle: alldoclst)
            {
                unqDocList.add(doctypestrsingle.Document_Type__c);
                doctypestr.put(doctypestrsingle.Document_Type__c, '1');
            }
        }
        if (!unqDocList.contains('Passport'))
        {
            doctypestr.put('Passport', '0');
        }
        if (!unqDocList.contains('Birth-Certificate'))
        {
            doctypestr.put('Birth-Certificate', '0');
        }
        if (!unqDocList.contains('Immunization-Chart'))
        {
            doctypestr.put('Immunization-Chart', '0');
        }
        if (!unqDocList.contains('PT-Agreements'))
        {
            doctypestr.put('PT-Agreements', '0');
        }
        if (!unqDocList.contains('Partner-Agreement'))
        {
            doctypestr.put('Partner-Agreement', '0');
        }
        if (!unqDocList.contains('Medical-Release'))
        {
            doctypestr.put('Medical-Release', '0');
        }
        if (!unqDocList.contains('English-Test'))
        {
            doctypestr.put('English-Test', '0');
        }
        if (!unqDocList.contains('Grade-Conversion-Chart'))
        {
            doctypestr.put('Grade-Conversion-Chart', '0');
        }
        if (!unqDocList.contains('Resume'))
        {
            doctypestr.put('Resume', '0');
        }
        if (!unqDocList.contains('Offer-Document'))
        {
            doctypestr.put('Offer-Document', '0');
        }
        /*if (!unqDocList.contains('DS-7002-(Company-Signature)'))
{
doctypestr.put('DS-7002-(Company-Signature)', '0');
}
if (!unqDocList.contains('DS-7002-(Participant-Signature)'))
{
doctypestr.put('DS-7002-(Participant-Signature)', '0');
}*/
        if (!unqDocList.contains('DS-7002-(Complete)'))
        {
            doctypestr.put('DS-7002-(Complete)', '0');
        }
        if (!unqDocList.contains('Proof-of-Relationship'))
        {
            doctypestr.put('Proof-of-Relationship', '0');
        }
        if (!unqDocList.contains('FinancialResponsibility'))
        {
            doctypestr.put('FinancialResponsibility', '0');
        }
        if (!unqDocList.contains('Participant-Eligibility-Form'))
        {
            doctypestr.put('Participant-Eligibility-Form', '0');
        }
        if (!unqDocList.contains('Pre-Departure-Orientation-Agreement'))
        {
            doctypestr.put('Pre-Departure-Orientation-Agreement', '0');
        }
        if (!unqDocList.contains('University-Diploma'))
        {
            doctypestr.put('University-Diploma', '0');
        }
        if (!unqDocList.contains('Proof-of-Language-Level'))
        {
            doctypestr.put('Proof-of-Language-Level', '0');
        }
        if (!unqDocList.contains('Transcripts'))
        {
            doctypestr.put('Transcripts', '0');
        }
        if (!unqDocList.contains('University-Letter'))
        {
            doctypestr.put('University-Letter', '0');
        }
        if (!unqDocList.contains('University-Letter-Translation'))
        {
            doctypestr.put('University-Letter-Translation', '0');
        }
        if (!unqDocList.contains('Letter-of-Recommendation'))
        {
            doctypestr.put('Letter-of-Recommendation', '0');
        }
        if (!unqDocList.contains('Previous-Visa'))
        {
            doctypestr.put('Previous-Visa', '0');
        }
        if (!unqDocList.contains('Interview-Document'))
        {
            doctypestr.put('Interview-Document', '0');
        }
        if (!unqDocList.contains('Terms-and-Conditions'))
        {
            doctypestr.put('Terms-and-Conditions', '0');
        }
        system.debug(doctypestr);
        return doctypestr;
    }
    
    //Fetch applicant list
    public List<Applicant_Info__c> getApplicantInfoList(){
        return [Select a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
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
                Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,
                a.Application_Type__c
                From Applicant_Info__c a
                where a.CreatedBy__c =: UserInfo.getUserId() order by a.LastModifiedDate DESC];
        //where a.CreatedById =: UserInfo.getUserId() order by a.LastModifiedDate DESC];
    }
    
    public Applicant_Info__c getApplicantInfoWorking(){
        return [Select a.Id, a.LastModifiedDate, a.CreatedDate
                From Applicant_Info__c a
                where Application_Stage__c =: 'Working' AND a.CreatedBy__c =: UserInfo.getUserId() order by a.CreatedDate DESC limit 1];
        //where a.CreatedById =: UserInfo.getUserId() order by a.LastModifiedDate DESC];
    }
    
    // Submitted Applications
    public PageReference goToMyApplications(){
        PageReference myAppListPage = Page.your_applications;
        myAppListPage.setRedirect(true);
        return myAppListPage;
    }
    
    //TODO: changes need to be done
    public PageReference homePage(){
        
        return Page.your_applications;
    }
    
    public String getId(){
        return Apexpages.currentPage().getParameters().get('id');
    }
    
    
    //Basic data check and processing if account present, tag to account,
    //else if Lead present, tag to lead else create lead and tag to lead
    
    public void basics(String appType){
        //To Change applicant name if its a partner user
        system.debug('***+++ isPartner: ' + isPartner);
        
        if(IsPartner==true && personInfo.Primary_Applicant__c==true)
        {
            applicantInfo.Name = personInfo.First_Name__c + ' ' + personInfo.Last_Name__c;
        }
        else {
            if(applicantInfo.First_Name__c != null && applicantInfo.First_Name__c != ''){
                applicantInfo.Name = applicantInfo.First_Name__c + ' ' + applicantInfo.Last_Name__c; 
            }else{
                if(Site.getCurrentSiteUrl() != null) applicantInfo.Name = appType;
            }
        }
        
        String appname;
        
        if(applicantInfo.Name!=null)
            appname=applicantInfo.Name;
        
        if((applicantInfo.Engagement_Start__c !=null || (applicantInfo.RecordType.Name == 'AuPairCare HF' || applicantInfo.RecordType.Name == 'AuPairCare PT'))  
           && applicantInfo.RecordType.Name != 'Centers' && applicantInfo.RecordType.Name != 'Ayusa PT' 
           && applicantInfo.RecordType.Name != 'ICD Intern PT' && applicantInfo.RecordType.Name != 'PW Participant') 
        { 
            system.debug('*************Line- 2681***'+ applicantInfo.RecordType.Name);
            if(applicantInfo.RecordType.Name == 'Work Travel PT')
            {                  
                if(applicantInfo.Name.contains('-WT'))
                { 
                    applicantInfo.Name = appname.substringBefore('-WT');
                }
                // Modified as per IGI 505
                //Integer adYear = applicantInfo.Engagement_Start__c.year();
                //adYear = adYear+1;
                Integer adYear = applicantInfo.Engagement_End__c.year();
                if (applicantInfo.Season__c == 'Winter')
                {
                    adYear = adYear -1;
                }
                applicantInfo.Program_Year__c = string.valueOf(adYear);
                applicantInfo.Name = applicantInfo.Name +'-WT'+adYear;
                
            }else if(applicantInfo.RecordType.Name == 'AuPairCare HF' || applicantInfo.RecordType.Name == 'AuPairCare PT'){
                system.debug('***+++ applicantInfo.Name: ' + applicantInfo.Name);
                if(applicantInfo.Name.contains('-APC'))
                { 
                    applicantInfo.Name = appname.substringBefore('-APC');
                }
                //EU 107
                if(applicantInfo.RecordType.Name == 'AuPairCare HF')
                {
                    //[B-02881] naming conventions
                    //applicantInfo.Name = applicantInfo.Name +'-APCHF-' + applicantInfo.application_type__c;
                }
                
                else if(applicantInfo.RecordType.Name == 'AuPairCare PT')
                {
                    //[B-02881] naming conventions
                    If(applicantInfo.application_Type__c == 'Original'){
                        //applicantInfo.Name = applicantInfo.Name +'-APCPT-' + applicantInfo.application_level__c;
                    }else{
                        //applicantInfo.Name = applicantInfo.Name +'-Extension-' + applicantInfo.application_level__c;   
                    }
                }
                
            }
            else{
                if(applicantInfo.Name.contains('-AY'))
                { 
                    applicantInfo.Name = appname.substringBefore('-AY');
                }
                //EU 107
                if(applicantInfo.RecordType.Name == 'Ayusa HF')
                {
                    Integer adYear = applicantInfo.Engagement_Start__c.year();
                    adYear = adYear+1;
                    applicantInfo.Name = applicantInfo.Name +'-AY'+adYear;
                }
            }
        }      
        else if(applicantInfo.RecordType.Name == 'Ayusa PT')
        {
            system.debug('*************Line- 2681***'+ applicantInfo.RecordType.Name);
            if(applicantInfo.Name.contains('-AY'))
            { 
                applicantInfo.Name = appname.substringBefore('-AY');
            }
            if(applicantInfo.Program_Year__c!= null){
                String[] proYearSplit = applicantInfo.Program_Year__c.split('-');
                String adYear = proYearSplit[1];
                applicantInfo.Name = applicantInfo.Name +'-AY'+adYear;
            }
        }
        
        
        
        //To Update Applicant Name in the case of Centers Application 
        if(applicantInfo.RecordType.Name == 'Centers' || app == 'Centers') {
            
            //Variable to hold the applicate engagement year
            Integer applicantNameSuffixYear;
            
            //Check for values of Program_Start_Opinion__c, Engagement start and Program Start
            if(applicantInfo.Program_Start_Opinion__c == 'Yes') {
                applicantInfo.Program_Start__c = null;
                //applicantInfo.Program_Duration__c = null;
            }
            
            if(applicantInfo.Program_Start_Opinion__c == 'No') {
                applicantInfo.Engagement_Start__c = null;
                // applicantInfo.Study_Weeks__c = null;
            }
            
            //Check if engagement start date not null, then set the engagement year as suffix
            //Else set the today's year as  suffix
            if(applicantInfo.Engagement_Start__c != null)
                applicantNameSuffixYear = applicantInfo.Engagement_Start__c.year();
            //else if(applicantInfo.Program_Start__c != null)
            //applicantNameSuffixYear = applicantInfo.Program_Start__c.year();
            else
                applicantNameSuffixYear = Date.today().year();
            
            //Set the applicant Name 
            applicantInfo.Name = applicantInfo.Name + Constants.HYPHEN + Constants.IC + applicantNameSuffixYear;
        } 
        
        //Update ApplicantInfo
        if(string.isBlank(applicantInfo.CreatedBy__c)){
            applicantInfo.CreatedBy__c = UserInfo.getUserId();
        }
        
        If((applicantInfo.How_Heard__c == 'Web Search' && applicantInfo.How_Heard_Detail__c != 'Other') || (applicantInfo.How_Heard__c == 'Social media' && applicantInfo.How_Heard_Detail__c != 'Other'))
            applicantInfo.How_Heard_Other__c = '';
        
        If(applicantInfo.How_Heard__c == 'Brochure/Poster/Other Publication' || applicantInfo.How_Heard__c == 'Email/Newsletter' || applicantInfo.How_Heard__c == 'Advertisement' || applicantInfo.How_Heard__c == 'Website')
            applicantInfo.How_Heard_Detail__c = '';
        
        if(!TriggerExclusion.skipUpdate_AutoSync){ //I don't want to perform this update if auto sync automation process for WT.
            upsert applicantInfo;
        }
        system.debug('*****###applicantInfo.Id - into basics: ' + applicantInfo.Id); 
    }  
    
    /* Uncomment the following for removing Sharing (AYII-136) 
/*public void tagApplicationToAccAndOrLead(){
System.debug('Going to tag');
if(personInfo.Email__c!=null)
{
List<Account> existingAcc = [select id, Last_Interest_Date__pc from Account where IsPersonAccount = true and PersonEmail!= null and PersonEmail =: personInfo.Email__c order by CreatedDate DESC];
List<Lead> existingLead = [select id, Last_Interest_Date__c from Lead where Email =: personInfo.Email__c and IsConverted = false order by CreatedDate DESC];

// Commented out after MAINT 86 discussion
//if (existingAcc.size() > 0 && applicantInfo.Intrax_Program__c != 'Ayusa' && applicantInfo.Type__c != 'Host Family') {
if (existingAcc.size() > 0) {
applicantInfo.Account__c = existingAcc[0].ID;
if((existingAcc[0].Last_Interest_Date__pc == NULL || !datetime.now().isSameDay(existingAcc[0].Last_Interest_Date__pc) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.CreatedById == applicantInfo.LastModifiedById )){
existingAcc[0].Last_Interest_Date__pc = dateTime.now();
}
//update applicantInfo;
update existingAcc[0];
}
else if (existingLead.size() > 0) {
if (applicantInfo.Intrax_Program__c != 'Ayusa' && applicantInfo.Type__c != 'Host Family'){
applicantInfo.Lead__c = existingLead[0].ID;

if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.CreatedById == applicantInfo.LastModifiedById )){
existingLead[0].Last_Interest_Date__c = DateTime.now(); 
}
//update applicantInfo;
update existingLead[0]; 
}
else{
applicantInfo.Lead__c = existingLead[0].ID;
//IUtilities.AppToLeadSync(applicantInfo, personInfo, existingLead[0], 'insert'); 

existingLead[0].FirstName = personInfo.First_Name__c;
existingLead[0].LastName = personInfo.Last_Name__c;
existingLead[0].Intrax_Programs__c = 'Ayusa';
existingLead[0].Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
existingLead[0].Lead_Type__c = applicantInfo.Type__c;
existingLead[0].LeadSource = 'Portal';
existingLead[0].Lead_Source_Tag__c = 'Application';
//existingLead[0].Intrax_Region__c = 'United States';
existingLead[0].Intrax_Region__c = applicantInfo.Intrax_Region__c;
existingLead[0].Intrax_Market__c = applicantInfo.Intrax_Market__c;
existingLead[0].Email = personInfo.Email__c;
existingLead[0].Gender__c = personInfo.Gender__c;
existingLead[0].MobilePhone = personInfo.Mobile__c;
existingLead[0].Phone = applicantInfo.Home_Phone__c;
existingLead[0].Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
existingLead[0].City = applicantInfo.Home_City__c;
existingLead[0].State = applicantInfo.Home_State__c;
existingLead[0].PostalCode = applicantInfo.Home_Postal_Code__c;
existingLead[0].Country = applicantInfo.Home_Country__c;
existingLead[0].Title = applicantInfo.Title__c;
existingLead[0].Date_of_Birth__c = applicantInfo.Date_of_Birth__c;    
existingLead[0].Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;   
// Update only if nto changed in last 24 hours
if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.CreatedById == applicantInfo.LastModifiedById )){
existingLead[0].Last_Interest_Date__c = DateTime.now(); 
}
try{
//update applicantInfo;
update existingLead[0];    
}catch(Exception e){
system.debug('***** Impossible to update related Lead: '+ e);
}  

}

} 
else {
Lead newLead = new Lead();            
newLead.FirstName = personInfo.First_Name__c;
newLead.LastName = personInfo.Last_Name__c;
newLead.Status = 'Open - New';
newLead.Intrax_Programs__c = applicantInfo.Intrax_Program__c; 
newLead.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
newLead.Lead_Type__c = applicantInfo.Type__c;
newLead.LeadSource = 'Portal';
newLead.Lead_Source_Tag__c = 'Application';
//existingLead[0].Intrax_Region__c = 'United States';
newLead.Intrax_Region__c = applicantInfo.Intrax_Region__c;
newLead.Intrax_Market__c = applicantInfo.Intrax_Market__c;
newLead.Email = personInfo.Email__c;
newLead.Gender__c = personInfo.Gender__c;
newLead.MobilePhone = personInfo.Mobile__c;
newLead.Phone = applicantInfo.Home_Phone__c;
newLead.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
newLead.City = applicantInfo.Home_City__c;
newLead.State = applicantInfo.Home_State__c;
newLead.PostalCode = applicantInfo.Home_Postal_Code__c;
newLead.Country = applicantInfo.Home_Country__c;
newLead.Title = applicantInfo.Title__c;
newLead.Date_of_Birth__c = applicantInfo.Date_of_Birth__c;
newLead.Last_Interest_Date__c = DateTime.now(); 
newLead.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;

// to turn the Assignment Rules on
Database.DMLOptions dmo = new Database.DMLOptions();
dmo.assignmentRuleHeader.useDefaultRule = true;
newLead.setOptions(dmo);
try{
insert newLead;
}catch(Exception e){
system.debug('****** Impossible to create new Lead for the HF App: '+ e);
}
applicantInfo.Lead__c = newLead.id;
}
}       
}  */
    // Uncomment the above for removing Sharing (AYII-136)
    
    public void loadIGICategory()
    {
        listProgramCategories = new List<String>();
        if (applicantInfo.Country_of_Interest__c == 'United States' || applicantInfo.Country_of_Interest__c == 'Chile' || applicantInfo.Country_of_Interest__c == 'China' || applicantInfo.Country_of_Interest__c == 'France' || applicantInfo.Country_of_Interest__c == 'Germany' || applicantInfo.Country_of_Interest__c == 'Japan' || applicantInfo.Country_of_Interest__c == 'Spain' || applicantInfo.Country_of_Interest__c == 'United Kingdom')
        {
            listProgramCategories.add('Business');
        }
        
        if (applicantInfo.Country_of_Interest__c == 'United States' || applicantInfo.Country_of_Interest__c == 'Chile' || applicantInfo.Country_of_Interest__c == 'France' || applicantInfo.Country_of_Interest__c == 'Germany' || applicantInfo.Country_of_Interest__c == 'Japan' || applicantInfo.Country_of_Interest__c == 'Spain' || applicantInfo.Country_of_Interest__c == 'United Kingdom' )
        {
            listProgramCategories.add('Information Media & Communications');
        }
        
        if (applicantInfo.Country_of_Interest__c == 'United States' || applicantInfo.Country_of_Interest__c == 'China' )
        {
            listProgramCategories.add('Public Administration & Law');
        }
        
        if (applicantInfo.Country_of_Interest__c == 'United States' || applicantInfo.Country_of_Interest__c == 'Chile' || applicantInfo.Country_of_Interest__c == 'China' || applicantInfo.Country_of_Interest__c == 'France' || applicantInfo.Country_of_Interest__c == 'Germany' || applicantInfo.Country_of_Interest__c == 'Japan' || applicantInfo.Country_of_Interest__c == 'Spain' || applicantInfo.Country_of_Interest__c == 'United Kingdom')
        {
            listProgramCategories.add('Engineering');
        }
        
        // B-02010
        //if (applicantInfo.Country_of_Interest__c == 'United States' || applicantInfo.Country_of_Interest__c == 'Belize' || applicantInfo.Country_of_Interest__c == 'Ghana' || applicantInfo.Country_of_Interest__c == 'Peru' || applicantInfo.Country_of_Interest__c == 'Spain' )
        if (applicantInfo.Country_of_Interest__c == 'United States' || applicantInfo.Country_of_Interest__c == 'Spain' )
        {
            listProgramCategories.add('Social Development');
        }
        
        if (applicantInfo.Country_of_Interest__c == 'United States' || applicantInfo.Country_of_Interest__c == 'France' || applicantInfo.Country_of_Interest__c == 'Spain' )
        {
            listProgramCategories.add('Hospitality & Tourism');
        }
        
        system.debug('listProgramCategories ****' + listProgramCategories);
    }
    
    /*
//AA IGI Pricing
public void loadIgiPricing(){
Pricing_Info_Wrapper pricingWrapper= Pricing_Publisher.getStartingPrice(personInfo.Country_of_Residence__c, applicantInfo.Country_of_Interest__c, 'Fixed', applicantInfo.Intrax_Program_Category__c,applicantInfo.Intrax_Program__c);
system.debug('debug::wrapper '+pricingWrapper);
system.debug('debug:::wrapper CurrencyCode'+pricingWrapper.CurrencyCode);
If(pricingWrapper.Isdata){
CurrencyCode=pricingWrapper.CurrencyCode;
StartingPrice=pricingWrapper.finalStPrice;
}
else{
CurrencyCode='';
StartingPrice=0.0;
}
}*/
    
    // Method used to first create the Essays
    
    public void saveEssayInfo(){            
        //*****Here we are going to create a new Essay for Host Families
        // story AYII 72 : 
        system.debug('debug::Inside SaveEssayinfo()');
        if(applicantInfo.Type__c == 'Participant' || applicantInfo.Type__c == 'Host Family'){
            // if(applicantInfo.Type__c == 'Participant'){
            List<Essay_Qs__c> essayQList = Essay_Qs__c.getAll().values();
            List<Essay__c> essayList_a = new List<Essay__c>();
            List<Essay__c> essayList = [SELECT label__c, applicant_info__c, ordinal__c
                                        FROM Essay__c 
                                        WHERE applicant_info__c =: applicantInfo.Id order by ordinal__c desc];
            
            system.debug('debug::Essay Name');
            if(essayList.isEmpty()){
                for(integer i=0;i<essayQList.size(); i++){
                    if(applicantInfo.Type__c == 'Participant' && applicantInfo.Intrax_Program__c == 'Work Travel'){
                        if((essayQList[i].Applicant_type__c == 'WT Participant') && essayQList[i].active__c == true){
                            essayList_a.add(new Essay__c(Applicant_Info__c = ApplicantInfo.Id,ordinal__c = essayQList[i].ordinal__c,
                                                         Name = essayQList[i].Name,label__c = essayQList[i].essay_question__c ));
                        }   
                        //For Host Family Apc
                    }else if(applicantInfo.Type__c == 'Host Family' && applicantInfo.Intrax_Program__c == 'AuPairCare'){
                        
                        system.debug('debug::ApplicationInfoType ='+applicantInfo.Type__c);
                        if((essayQList[i].Applicant_type__c == 'Host Family APC') && essayQList[i].active__c == true){
                            essayList_a.add(new Essay__c(Applicant_Info__c = ApplicantInfo.Id,ordinal__c = essayQList[i].ordinal__c,
                                                         Name = essayQList[i].Name,label__c = essayQList[i].essay_question__c, Position__c = ApplicantInfo.Position__c));
                        }
                    }
                    //For Participant APC
                    else if(applicantInfo.Type__c == 'Participant' && applicantInfo.Intrax_Program__c == 'AuPairCare'){
                        
                        system.debug('debug::ApplicationInfoType ='+applicantInfo.Type__c);
                        if((essayQList[i].Applicant_type__c == 'APC Participant') && essayQList[i].active__c == true){
                            essayList_a.add(new Essay__c(Applicant_Info__c = ApplicantInfo.Id,ordinal__c = essayQList[i].ordinal__c,
                                                         Name = essayQList[i].Name,label__c = essayQList[i].essay_question__c ));
                        }
                    }else{
                        system.debug('debug::ApplicationInfoType ='+applicantInfo.Type__c);
                        system.debug('debug::AessayQList[i].Applicant_type__c ='+essayQList[i].Applicant_type__c);
                        system.debug('debug::essayQList[i].active__c =='+essayQList[i].active__c);
                        if((essayQList[i].Applicant_type__c == applicantInfo.Type__c) && essayQList[i].active__c == true){
                            essayList_a.add(new Essay__c(Applicant_Info__c = ApplicantInfo.Id,ordinal__c = essayQList[i].ordinal__c,
                                                         Name = essayQList[i].Name,label__c = essayQList[i].essay_question__c ));
                        }
                    }
                }
                insert essayList_a; 
            }
        }
    }
    
    //Retrieve location info list        
    public List<Location__c> getLocationInfoList(){
        
        string applicant = ApexPages.currentPage().getParameters().get('id');           
        locationInfoList = [Select l.Street__c, l.Type__c, l.SystemModstamp, l.State__c, l.Postal_Code__c, 
                            l.Occupancy_Years__c, l.Occupancy_Start__c, l.Occupancy_End__c, l.Name, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.CreatedDate, l.CreatedById, l.Country__c, l.ConnectionSentId, l.ConnectionReceivedId, l.City__c, l.Applicant_Info__c From Location__c l Where l.applicant_Info__c =: applicant];
        
        if(locationInfoList.size()!=0 && locationInfoList != null){
            return locationInfoList;
        }
        else return null;
    }
    
    //Retrieve location info list        
    public String getProgId(){
        
        string applicant = ApexPages.currentPage().getParameters().get('id');           
        if(applicant!=null)
        {
            Applist = [select a.type__c, RecordType.Name  from applicant_info__c a where a.id=:ApexPages.currentPage().getParameters().get('id') limit 1];
            system.debug('*****Applist******'+Applist);
        } 
        if(Applist.size()!=0 && Applist != null)
        {
            for (Applicant_info__c app :Applist)
            {
                system.debug('*****app******'+app);
                if(app.type__c=='Participant')
                {
                    system.debug('*****apptype******'+app.type__c);
                    //Check for centers application
                    if(app.RecordType.Name == 'Centers') {
                        progId = 'centers-pt';
                    } else if(app.RecordType.Name == 'ICD Intern PT'){
                        progId = 'igi-pt';    
                    }
                    system.debug('*****progId******'+progId);
                }
                else if (app.type__c=='Host Family')
                {
                    system.debug('*****apptype******'+app.type__c);
                    progId = 'ayusa-hf';
                    system.debug('*****progId******'+progId);
                }
                else progId = null;
            }
            return progId;
        }             
        
        else return null;
    }
    
    //Retrieve family info list 
    public List<Person_Info__c> getFamilyInfoList(){
        string applicant = ApexPages.currentPage().getParameters().get('id');               
        familyInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c,p.Work_Supervisor__c,p.Profession__c,p.Employer_Name__c,p.Education_Level__c, p.Title__c,p.Role__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c From Person_Info__c p Where p.Applicant_Info__c = :applicantInfo.Id and role__c != 'Student' and role__c != 'Host' and role__c != 'Reference' and Family_Member__c = true];
        If  (familyInfoList.size()!=0 && familyInfoList!=null)   
        {
            return familyInfoList;                  
        }   
        else
        {
            return null;
        }                         
    }
    
    //Retrieve Referer info list 
    public List<Person_Info__c> getRefererInfoList(){
        string applicant = ApexPages.currentPage().getParameters().get('id');
        refererInfoList = [select p.Primary_Applicant__c,p.Community_Service__c,p.Interests__c,p.Employer_Name__c, p.Work_Supervisor__c,p.Title__c,p.Education_Level__c,p.Profession__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c From Person_Info__c p Where p.Applicant_Info__c = :applicant and role__c = 'Reference'];
        If  (refererInfoList.size()!=0 && refererInfoList!=null)  
        {
            return refererInfoList;                  
        }   
        else
        {
            return null;
        }                         
    }
    
    //Retrieve Emergency Info list
    public List<Person_Info__c> getEmergencyInfoList(){
        string applicant = ApexPages.currentPage().getParameters().get('id');               
        EmergencyInfoList = [select p.Primary_Applicant__c,p.Education_Level__c, p.Title__c,p.Role__c,p.Role_Other__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c,p.Residency_Status__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Family_Member__c From Person_Info__c p Where p.Applicant_Info__c = :applicantInfo.Id and Emergency_Contact_Indicated__c = 'Yes'];
        If  (EmergencyInfoList.size()!=0 && EmergencyInfoList!=null)  
        {
            return EmergencyInfoList;                  
        }   
        else
        {
            return null;
        }                         
    }
    
    
    // Getting the list of every essay for the current applicant         
    public List<Essay__c> getEssayList(){
        string applicant = EssayType;
        return essayList = [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                            WHERE Applicant_Info__c =: applicantInfo.Id
                            and Name != 'Parent Letter'
                            ORDER BY ordinal__c ASC];
    }
    
    public void getParentLetter(){
        if(applicantInfo.Id != NULL && applicantInfo.Type__c == 'Participant'){
            try{
                EssayParentLetter = [SELECT label__c, Name, Narrative__c FROM Essay__c
                                     WHERE Name = 'Parent Letter'
                                     AND Applicant_Info__c =: applicantInfo.Id];
            }catch(Exception e){
                system.debug('***** Impossible to retrieve Essay: Parent Letter');
            }
        }
    }
    
    public void getFamilyLetter(){
        if(applicantInfo.Id != NULL && applicantInfo.Type__c == 'Host Family'){
            try{
                EssayFamilyLetter = [SELECT label__c, Name, Narrative__c FROM Essay__c
                                     WHERE Name = 'Host Family Letter'
                                     AND Applicant_Info__c =: applicantInfo.Id];
            }catch(Exception e){
                system.debug('***** Impossible to retrieve Essay: Host Family Letter');
            }
        }
    }
    
    //Getting the data for the essay's detail page
    public Essay__c getEssayInfo(){
        if(ApexPages.currentPage().getParameters().get('EssayType') == 'Parent' ){
            
            EssayParentLetter = [SELECT label__c, Name, Narrative__c FROM Essay__c
                                 WHERE Name = 'Parent Letter'
                                 AND Applicant_Info__c =: applicantInfo.Id];
            EssayNarrative = EssayParentLetter.Narrative__c;
            EssayLabel = EssayParentLetter.label__c;
        }
        
        else if(ApexPages.currentPage().getParameters().get('EssayType') == 'Host Family' ){
            
            EssayFamilyLetter = [SELECT label__c, Name, Narrative__c FROM Essay__c
                                 WHERE Name = 'Host Family Letter'
                                 AND Applicant_Info__c =: applicantInfo.Id];
            EssayNarrative = EssayFamilyLetter.Narrative__c;
            EssayLabel = EssayFamilyLetter.label__c;
        }
        
        
        else{
            if(ApexPages.currentPage().getParameters().get('EssayId') != null){                 
                EssayInfo = [SELECT Id, Narrative__c , label__c, Name, ordinal__c FROM Essay__c
                             WHERE Id =: ApexPages.currentPage().getParameters().get('EssayId')LIMIT 1];
                EssayNarrative = EssayInfo.Narrative__c;
                EssayLabel = EssayInfo.label__c;
            } 
            else return null;                              
        }
        return EssayInfo;
    }
    
    public void saveEssayAnswer(){
        system.debug('debug::Inside SaveEssayAnswer');
        system.debug('debug::Inside EssayType'+Essaytype);
        
        if(EssayType == 'Parent' && ApexPages.currentPage().getParameters().get('EssayUp') == 'Up'){
            EssayInfo = [SELECT label__c,Name, ordinal__c, Narrative__c FROM Essay__c
                         WHERE Applicant_Info__c =: applicantInfo.Id
                         and Name = 'Parent Letter'
                         LIMIT 1];                
            
        }else if(EssayType == 'Host Family' && ApexPages.currentPage().getParameters().get('EssayUp') == 'Up'){
            EssayInfo = [SELECT label__c,Name, ordinal__c, Narrative__c FROM Essay__c
                         WHERE Applicant_Info__c =: applicantInfo.Id
                         and Name = 'Host Family Letter'
                         LIMIT 1];                
            
        }else  if(EssayType == 'Student' && ApexPages.currentPage().getParameters().get('EssayId') != null){
            EssayInfo = [SELECT label__c,Name, ordinal__c, Narrative__c FROM Essay__c
                         WHERE Id =: ApexPages.currentPage().getParameters().get('EssayId')
                         LIMIT 1]; 
        }//For Host Family APC 
        else if(applicantInfo.Type__c == 'Host Family' && applicantInfo.Intrax_Program__c == 'AuPairCare' && EssayType == 'APC'){
            /*EssayInfo = [SELECT label__c,Name, ordinal__c, Narrative__c FROM Essay__c
WHERE Id =: ApexPages.currentPage().getParameters().get('EssayId')
LIMIT 1];
system.debug('Essayinfo'+Essayinfo);*/
            for (Essay__c essSingle : Essaylist)
            {
                if(applicantInfo.Position__c != NULL)
                {
                    essSingle.Position__c = applicantInfo.Position__c;
                }
            }
            update Essaylist;
        }// For Participant APC
        else if(applicantInfo.Type__c == 'Participant' && applicantInfo.Intrax_Program__c == 'AuPairCare' && EssayType == 'APC'){
            /*EssayInfo = [SELECT label__c,Name, ordinal__c, Narrative__c FROM Essay__c
WHERE Id =: ApexPages.currentPage().getParameters().get('EssayId')
LIMIT 1];
system.debug('Essayinfo'+Essayinfo);*/
            update Essaylist;
        }
        if(EssayInfo!=null){        
            EssayInfo.Narrative__c = EssayNarrative;
            update(EssayInfo);                          
        }
    }
    
    public boolean getcheckCompletedEssays(){
        boolean status = true;
        
        for(integer i=0; i<essayList.size();i++){
            if((essayList[i].Narrative__c == null) || (essayList[i].Narrative__c.length() < 100)) {
                status = false;
                break;
            }
        }
        return status;
    }
    
    public boolean getcheckCompletedEssaysWT(){
        boolean status = true;
        
        for(integer i=0; i<essayList.size();i++){
            //if((essayList[i].Narrative__c == null) || (essayList[i].Narrative__c.length() < 50)) {
            if(essayList[i].Narrative__c == null) {
                status = false;
                break;
            }
        }
        return status;
    }
    
    public boolean getcheckEmergencyContact(){
        if(applicantInfo.Emergency_Contact_Complete__c == true)return true;
        else return false;
    }
    
    public boolean getCheckParentLetter(){
        boolean status = true;
        
        Essay__c essayParent = [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                WHERE Applicant_Info__c =: applicantInfo.Id
                                AND Name =: 'Parent Letter'
                                LIMIT 1];
        
        if((essayParent.Narrative__c == null) || (essayParent.Narrative__c.length() < 200)){
            status = false;
        }
        return status;
    }
    
    public boolean getCheckFamilyLetter(){
        boolean status = true;
        
        try{
            Essay__c essayFamily = [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                    WHERE Applicant_Info__c =: applicantInfo.Id
                                    AND Name =: 'Host Family Letter'
                                    LIMIT 1];
            
            if((essayFamily.Narrative__c == null) || (essayFamily.Narrative__c.length() < 200)){
                status = false;
                
            }
            
            return status;
        }catch(Exception e){
            system.debug('The Essay Host Family Letter does not exist: ' + e);
            status = false;
            return status;
        }
    }
    
    
    //AA APC Swimming Certification Restriction.
    //Start
    public boolean getCheckSwimCert(){
        List<Intrax_Program_Upload__c> ipu = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Lifeguard'];
        if(ipu.size() == 0){
            return true;
        } else return false;
    }     
    //Ends
    public boolean getCheckParticipantPhotos(){
        List<Intrax_Program_Upload__c> ipu = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Media'];
        if(ipu.size() >= 1){
            return true;
        } else return false;
    }
    
    public boolean getCheckWTParticipantPhotos(){
        List<Intrax_Program_Upload__c> ipu = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Participant-Photo'];
        if(ipu.size() >= 1){
            return true;
        } else return false;
    }
    
    public boolean getCheckPreviousAddress(){
        if(applicantInfo.Previous_Address_Complete__c == true)return true;
        else return false;
    }
    
    public boolean getCheckFamilyMembers(){
        if(applicantInfo.Family_Members_Complete__c == true)return true;
        else return false;
    }
    
    public boolean getCheckFamilyAlbum(){
        List<Intrax_Program_Upload__c> ipu = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Family'];
        if(ipu.size() >= 4){
            return true;
        } else return false;
    }
    
    public boolean getCheckSchoolTranscript(){
        List<Intrax_Program_Upload__c> ipu = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Transcripts'];
        if(ipu.size() >= 1){
            return true;
        } else return false;
    }
    
    // ('Doctor', 'Immunization-Chart','Health' )
    public boolean getCheckDoctor(){
        List<Intrax_Program_Upload__c> ipu_d = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Doctor'];
        List<Intrax_Program_Upload__c> ipu_im = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Immunization-Chart'];
        List<Intrax_Program_Upload__c> ipu_h = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Health'];
        
        if((ipu_d.size() >= 1 && ipu_im.size() >= 1) || ipu_h.size() >= 1){
            return true;
        } else return false;
    }
    // 'PT-Agreements', 'Agreements'
    public boolean getCheckAgreements(){
        List<Intrax_Program_Upload__c> ipu = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'PT-Agreements'];
        List<Intrax_Program_Upload__c> ipu_ag = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Agreements'];
        
        if(ipu.size() >= 1 || ipu_ag.size() >= 1 ){
            return true;
        } else return false;
    }
    
    
    public boolean getCheckHFAgreementsUpload(){
        List<Intrax_Program_Upload__c> ipu_hfa = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'HFAgreements'];
        List<Intrax_Program_Upload__c> ipu_bgc = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'BackgroundCheck'];
        if(ipu_hfa.size() >= 1 && ipu_bgc.size() >= 1){
            return true;
        } else return false;
    }
    
    public boolean getCheckHFAgreementsDS(){
        list<dsfs__DocuSign_Status__c> ds_status = [SELECT Id, Name, Applicant_Info__c, dsfs__Envelope_Status__c, dsfs__Completed_Date_Time__c 
                                                    FROM dsfs__Docusign_Status__c 
                                                    WHERE Applicant_Info__c =: applicantInfo.Id and dsfs__Envelope_Status__c = 'Completed'
                                                    order by dsfs__Completed_Date_Time__c DESC];
        if(ds_status.size() >= 1) return true;
        else return false;                                              
        
    }  
    
    public boolean getCheckHFAgreementsDSSent(){
        list<dsfs__DocuSign_Status__c> ds_status = [SELECT Id, Name, Applicant_Info__c, dsfs__Envelope_Status__c, dsfs__Completed_Date_Time__c 
                                                    FROM dsfs__Docusign_Status__c 
                                                    WHERE Applicant_Info__c =: applicantInfo.Id 
                                                    and (dsfs__Envelope_Status__c = 'Sent' OR dsfs__Envelope_Status__c = 'Delivered')
                                                    order by dsfs__Sent_Date_Time__c DESC];
        if(ds_status.size() >= 1) return true;
        else return false;            
        
    }   
    
    
    public boolean getCheckAcademicRecommendation(){         
        List<Intrax_Program_Upload__c> ipu_teacher = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Teacher'];
        List<Intrax_Program_Upload__c> ipu_school = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'School'];
        List<Communication__c> com_school = [SELECT Id, Name, Type_Code__c FROM Communication__c WHERE Applicant_Info__c =: applicantInfo.Id and Type_Code__c = 'SOR']; 
        List<Communication__c> com_teacher = [SELECT Id, Name, Type_Code__c FROM Communication__c WHERE Applicant_Info__c =: applicantInfo.Id and Type_Code__c = 'ETR']; 
        
        if(ipu_school.size() >= 1 || com_school.size() >=1){
            if(ipu_teacher.size() >= 1 || com_teacher.size() >=1){
                return true;
            }else return false;
        }else return false; 
    }
    
    
    public boolean getCheckHFReferences(){
        if(RefererInfoList.size() >= 5) return true;
        else return false;
    }
    
    // Checking whether or not is possible to submit the preapp
    public boolean getcheckPreApp(){
        if(applicantInfo.Program_Duration__c == NULL || personInfo.Gender__c == NULL || applicantInfo.Home_Street_1__c == NULL || applicantInfo.Lives_With__c == NULL || applicantInfo.Graduation_Date__c == NULL)
            return true;
        else return false;
    }
    
    //Checking whether or not is possible to submit the preapp in Case of Centers Application
    public boolean getcheckPreAppCenters(){
        if(personInfo.Gender__c != NULL && applicantInfo.Intrax_Center__c != null && applicantInfo.Terms_Accepted__c == true && applicantInfo.Intrax_Accommodations__c != null && getCheckCtrTravelServices()){
            return true;
        }else return false;
    }
    
    /*IGI APP 2.0*/
    public boolean getCheckMainIGIApp(){
     system.debug('****** Check Main Status');
     boolean approved = false;
     if(applicantInfo.PageStatus_Complete__c != null && applicantInfo.PageStatus_Complete__c.contains('052') && applicantInfo.PageStatus_Complete__c.contains('051') && applicantInfo.PageStatus_Complete__c.contains('053') && applicantInfo.PageStatus_Complete__c.contains('056') && applicantInfo.PageStatus_Complete__c.contains('058') ){
         if(applicantInfo.Service_Level__c == 'Independent' && applicantInfo.PageStatus_Complete__c.Contains('055')
               && (personInfo.Country_of_Residence__c != 'United States' && personInfo.Citizenship__c != 'United States' && applicantInfo.Country_of_Interest__c == 'United States' && applicantInfo.PageStatus_Complete__c.contains('054')) ){
                if(applicantInfo.Visa_Type__c == 'J-1' && applicantInfo.PageStatus_Complete__c.Contains('063')){
                    approved = true;
                  }
                 else if(applicantInfo.Visa_Type__c != 'J-1'){
                   approved = true;  
                 }              
               }
         else if(applicantInfo.Service_Level__c == 'Independent' && applicantInfo.PageStatus_Complete__c.Contains('055')
                        && !(personInfo.Country_of_Residence__c != 'United States' && personInfo.Citizenship__c != 'United States' && applicantInfo.Country_of_Interest__c == 'United States')){
                            approved = true;
               }
         /*else if(applicantInfo.Service_Level__c == 'Independent' && applicantInfo.PageStatus_Complete__c.Contains('055')
                                 && !(personInfo.Country_of_Residence__c != 'United States' && personInfo.Citizenship__c != 'United States' && applicantInfo.Country_of_Interest__c == 'United States')){
                                     approved = true;
               }*/
         else if(applicantInfo.Service_Level__c == 'Premium'
                                          && (personInfo.Country_of_Residence__c != 'United States' && personInfo.Citizenship__c != 'United States' && applicantInfo.Country_of_Interest__c == 'United States' && applicantInfo.PageStatus_Complete__c.contains('054')) ){
               if(applicantInfo.Visa_Type__c == 'J-1' && applicantInfo.PageStatus_Complete__c.Contains('063')){
                    approved = true;
                  }
                 else if(applicantInfo.Visa_Type__c != 'J-1'){
                   approved = true;  
                 }                                   
             }
          else if(applicantInfo.Service_Level__c == 'Premium'
                                                   && !(personInfo.Country_of_Residence__c != 'United States' && personInfo.Citizenship__c != 'United States' && applicantInfo.Country_of_Interest__c == 'United States')){
                                                       approved =  true;                
                }
          /*else if(applicantInfo.Visa_Type__c == 'J-1' && applicantInfo.PageStatus_Complete__c.Contains('063')){
                                                       approved = true;
                                                   }*/
            
        }
        
        return approved;
        
    }
    public boolean checkIGIDependentsAllDocs(String ParticipantId){
        
        /* List<Intrax_Program_Upload__c> ipu_p = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where  Document_Type__c = 'Passport' and Person_Info__c IN (SELECT id from Person_Info__c WHERE applicant_info__c =:applicantInfo.Id)];
List<Intrax_Program_Upload__c> ipu_f = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where  Document_Type__c = 'FinancialResponsibility' and Person_Info__c IN (SELECT id from Person_Info__c WHERE applicant_info__c =:applicantInfo.Id)];
List<Intrax_Program_Upload__c> ipu_r = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where  Document_Type__c = 'Proof-of-Relationship' and Person_Info__c IN (SELECT id from Person_Info__c WHERE applicant_info__c =:applicantInfo.Id)];

*/
        List<Intrax_Program_Upload__c> ipu_p = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where  Document_Type__c = 'Passport' and Person_Info__c= :ParticipantId];
        List<Intrax_Program_Upload__c> ipu_f = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where  Document_Type__c = 'FinancialResponsibility' and Person_Info__c = :ParticipantId];
        List<Intrax_Program_Upload__c> ipu_r = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where  Document_Type__c = 'Proof-of-Relationship' and Person_Info__c =:ParticipantId];
        
        if((ipu_p.size() >= 1 && ipu_f.size() >= 1) && ipu_r.size() >= 1){
            return true;
        } else return false;
    }
    public boolean checkIGIDependentsDocs()
    {
        system.debug('****** Check DependentsDocs Status');
        saveDependentsIGI();
        list<Person_Info__c> dependentsList = [select p.Id  From Person_Info__c p 
                                               WHERE Applicant_Info__c =: applicantInfo.Id and  RecordTypeId=: Constants.IGI_Dependent_Record_Type
                                               order by createdDate DESC];
        
        system.debug('******** Dependents List: ' + dependentsList.size());
        
        if(dependentsList.size() > 0){
            system.debug('****** dependentsList' + dependentsList);
            for(Person_Info__c exp :  dependentsList)
                
            {
                if(!checkIGIDependentsAllDocs(exp.Id)) {
                    system.debug('****** Not all docs exist for' + exp.Id);
                    return false;  
                    
                }
                
            }
        }
        else return false;
        system.debug('***All dependent docs uploaded***');
        
        return true;
    }
    //Checking whether or not is possible to submit the PreApp for IGI Application
    /* IGI App 2.0 - OLD CODE
public boolean getcheckPreAppIGI(){
if(applicantInfo.Intrax_Program_Options__c != NULL  && applicantInfo.Engagement_Start__c != NULL && personInfo.Gender__c != NULL 
&& applicantInfo.Emergency_Contact_Complete__c != false
&& applicantInfo.Home_Country__c != NULL && applicantInfo.Primary_Activity__c != NULL && applicantInfo.Language_1__c != NULL 
&& applicantInfo.Experience_Complete__c != false){
if(applicantInfo.Service_Level__c == null && !(applicantInfo.Intrax_Program_Options__c == 'Business Internship' || applicantInfo.Intrax_Program_Options__c == 'Hospitality Internship') ){
return true;
}else if(applicantInfo.Service_Level__c == 'Independent' && positionInfo.Company_Name__c != NULL){
return true;
}else if(applicantInfo.Service_Level__c == 'Premium'){
return true;
}else return false;
}
else return false;
}*/
    
    public boolean getcheckPreAppWT(){
        if(applicantInfo.Engagement_Start__c != NULL && personInfo.Gender__c != NULL 
           && EmergencyInfoList.Size() > 0
           && applicantInfo.Home_Country__c != NULL && applicantInfo.School_Name__c != NULL && applicantInfo.Language_1_Proficiency__c != NULL 
           && applicantInfo.Experience_Complete__c != false  && applicantInfo.Prior_Exchange_Experience__c != null && getCheckWTParticipantPhotos() && getcheckCompletedEssaysWT()){
               if(applicantInfo.Service_Level__c == 'Independent' && positionInfo.Company_Name__c != NULL){
                   return true;
               }else if(applicantInfo.Service_Level__c == 'Premium'){
                   return true;
               }else return false;
               return true;
           } else return false;
    }
    
    public boolean getCheckCtrTravelServices(){
        list<Applicant_Product__c> ap = [SELECT Id,Applicant_Info__c, Product__c, Product_Name__c, Product_Name_Label__c FROM Applicant_Product__c WHERE Applicant_Info__c =: applicantInfo.Id
                                         AND (Product_Name__c =: 'Intrax Insurance' OR Product_Name__c =: 'Self-Insured')];
        if(ap.size() >= 1) return true;
        else return false;
    }
    
    // Center
    public boolean getcheckCtrAirportTransferReqd(){
        return true;
    }
    
    public boolean getcheckCtrHomestayAccommodationReqd(){
        return true;
    }
    
    public boolean getcheckCtrVisaInformationReqd(){
        return true;
    }
    
    public boolean getcheckCtrVisaDocumentsReqd(){
        return true;
    }
    
    public boolean getcheckCtrPassportLoaded(){
        List<Intrax_Program_Upload__c> passport = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Passport'];
        if(passport.size() >= 1){
            return true;
        }else return false;
    }
    public boolean getcheckCtrBirthCertificateLoaded(){
        List<Intrax_Program_Upload__c> birth_certificate = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Birth-Certificate'];
        if(birth_certificate.size() >= 1){
            return true;
        }else return false;
    } 
    public boolean getIsSelfInsuranceParticipant(){
        list<Applicant_Product__c> appProduct = [SELECT Id, Product_Name__c, Product_Name_Label__c, Applicant_Info__c 
                                                 FROM Applicant_Product__c 
                                                 WHERE Applicant_Info__c =: applicantInfo.Id
                                                 AND Product_Name__c = 'Self-Insured'];
        if(appProduct.size() > 0) return true;
        else return false;                                              
    }
    
    public boolean getcheckCtrFRDocsLoaded(){
        list<Intrax_Program_Upload__c> fr = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'FinancialResponsibility'];
        list<Intrax_Program_Upload__c> i20 = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'I-20'];
        list<Intrax_Program_Upload__c> f1Visa = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'F1-Visa'];
        //list<Intrax_Program_Upload__c> prooffinancial = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Proof-of-Financial'];
        // Commented for AYII Story 131
        //list<Intrax_Program_Upload__c> proofInsurance = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Proof-of-Insurance'];
        
        //if((applicantInfo.Visa_Category__c == 'Student (F)' && fr.size() == 0) || (applicantInfo.Visa_Type__c == 'F-1 Transfer' && (i20.size() == 0 || f1Visa.size() == 0)) || (getIsSelfInsuranceParticipant() && proofInsurance.size() == 0) ){
        if((applicantInfo.Visa_Category__c == 'Student (F)' && fr.size() == 0) || (applicantInfo.Visa_Type__c == 'F-1 Transfer' && (i20.size() == 0 || f1Visa.size() == 0)) ){
            return false;
        }else return true;
        
    }
    
    
    public boolean getCheckCtrHomestay(){
        system.debug('************ IS MULTISELECT BLANK/NULL: ' + String.isBlank(applicantInfo.Accommodation_Preference__c) );
        if((IUtilities.isIncluded(applicantInfo.Accommodation_Preference__c,'Homestay') || IUtilities.isIncluded(applicantInfo.Accommodation_Preference__c,'Homestay;Residence Club')) )
            return true;
        else return false;
    }
    
    public boolean getCheckCtrResidenceClub(){
        system.debug('************ IS MULTISELECT BLANK/NULL: ' + String.isBlank(applicantInfo.Accommodation_Preference__c) );
        if((IUtilities.isIncluded(applicantInfo.Accommodation_Preference__c,'Residence Club') || IUtilities.isIncluded(applicantInfo.Accommodation_Preference__c,'Homestay;Residence Club')) )
            return true;
        else return false;
    }
    
    public boolean getcheckCtrApplicationReadyToSubmit(){
        if(personInfo.Gender__c != null && applicantInfo.Intrax_Center__c != null && applicantInfo.Home_Street_1__c != null && applicantInfo.Intrax_Accommodations__c  != null){
            if(getcheckCtrFRDocsLoaded() && getcheckCtrPassportLoaded()){
                //if(getCheckCentersAPAirportTranfers()){
                //if(applicantInfo.Arriving_Date__c != null){
                return true;
                // }else return false;
                //}else return true;
            }else return false;
        }else return false;
    }
    
    // Centers        
    // Checking whether or not is possible to submit the preapp
    public boolean getcheckCtrPreApp(){
        if(applicantInfo.Name == NULL )
            return true;
        else return false;
    }
    // #Centers
    
    public boolean getcheckMainApp(){
        boolean status = false; // Default case
        // Check fields
        if(personInfo.Birth_City__c != NULL && applicantInfo.Interests__c != NULL && applicantInfo.Home_Responsibilities__c != NULL && applicantInfo.Disabilities__c != NULL && applicantInfo.Private_High_School_Indicated__c != NULL && ApplicantInfo.Parent_Marital_Status__c != NULL && applicantInfo.GPA_Self_Reported__c != NULL){
            // Check functions
            if( getCheckFamilyMembers() && getcheckEmergencyContact() && getcheckCompletedEssays() && getcheckParticipantPhotos() && getCheckDoctor() && getcheckAgreements() && getcheckFamilyAlbum() && getcheckParentLetter() && getcheckAcademicRecommendation() && getcheckSchoolTranscript()){
                status = true;  
            }
        }
        else status = false;
        
        return status; 
    }
    
    public boolean getcheckHFApp(){
        boolean status = false; // Default case
        // Check fields
        if(personInfo.Date_of_Birth__c != NULL && applicantInfo.Home_Type__c != NULL && applicantInfo.Primary_Language__c != NULL && applicantInfo.Community_Type__c != NULL && applicantInfo.School_Transportation__c != NULL && ApplicantInfo.Gender_Preference__c != NULL && SchoolInfo.Name__c != NULL){
            // Check functions
            // AYII story 72: 
            if( getCheckFamilyLetter() && getCheckFamilyMembers() && getcheckPreviousAddress() && getcheckHFReferences() && (getcheckHFAgreementsUpload() || getCheckHFAgreementsDSSent() || getCheckHFAgreementsDS()) ){
                // if( getCheckFamilyMembers() && getcheckPreviousAddress() && getcheckHFReferences() && (getcheckHFAgreementsUpload() || getCheckHFAgreementsDSSent() || getCheckHFAgreementsDS()) ){
                status = true;  
            }
        }
        else status = false;
        
        return status; 
    } 
    
    public boolean getcheckHFAppNoAgree(){
        boolean status = false; // Default case
        // Check fields
        if(personInfo.Date_of_Birth__c != NULL && applicantInfo.Home_Type__c != NULL && applicantInfo.Primary_Language__c != NULL && applicantInfo.Community_Type__c != NULL && applicantInfo.School_Transportation__c != NULL && ApplicantInfo.Gender_Preference__c != NULL && SchoolInfo.Name__c != NULL){
            // Check functions
            // AYII story 72 
            if( getCheckFamilyMembers() && getcheckPreviousAddress() && getcheckHFReferences() && getCheckFamilyLetter()){
                // if( getCheckFamilyMembers() && getcheckPreviousAddress() && getcheckHFReferences()){
                status = true;  
            }
        }
        else status = false;
        
        return status; 
    }
    
    //Save applicant info and accordingly set stage and level for the applicant.  
    
    public void saveApplication() {
        
        system.debug('@@@@@in saveapplication()');  
        boolean blnChkPartner;
        blnChkPartner=getIsPartner();
        
        if(Apexpages.currentPage().getParameters().get('SubmitApp')=='HF')
        {
            applicantInfo.Application_Level__c = 'Main';
            applicantInfo.Application_Stage__c = 'Submitted';
        }else if (Apexpages.currentPage().getParameters().get('SubmitApp')=='APCHF' && !blnChkPartner)
        {
            
            applicantInfo.Application_Stage__c = 'Submitted';
            
            
        }else if (Apexpages.currentPage().getParameters().get('SubmitApp')=='APCPT' && !blnChkPartner){
            
            applicantInfo.Application_Stage__c = 'Submitted';
            
            If(applicantInfo.Application_Type__c=='Extension')
            ExtMatchupdate();
            
        }else if (Apexpages.currentPage().getParameters().get('SubmitApp')=='PA' && !blnChkPartner)
        {
            applicantInfo.Application_Level__c = 'Main';
            applicantInfo.Application_Stage__c = 'Working';
            if(applicantInfo.Intrax_Program__c == 'Internship') resetpageIdValues();
        }
        else if (Apexpages.currentPage().getParameters().get('SubmitApp')=='BS' && !blnChkPartner )
        {
            applicantInfo.Application_Level__c = 'Basic';
            applicantInfo.Application_Stage__c = 'Submitted';
        }
        else if (Apexpages.currentPage().getParameters().get('SubmitApp')=='BS' && blnChkPartner )
        {
            applicantInfo.Application_Level__c = 'Basic';
            applicantInfo.Application_Stage__c = 'Submitted';
        }
        else if (Apexpages.currentPage().getParameters().get('SubmitApp')=='PA' && blnChkPartner )
        {
            applicantInfo.Application_Level__c = 'Main';
            applicantInfo.Application_Stage__c = 'Working';
            if(applicantInfo.Intrax_Program__c == 'Internship') resetpageIdValues();
        }
        else if ((Apexpages.currentPage().getParameters().get('SubmitApp')=='IGIPA' || Apexpages.currentPage().getParameters().get('SubmitApp')=='WTPA') && !blnChkPartner )
        {
            applicantInfo.Application_Level__c = 'Main';
            applicantInfo.Application_Stage__c = 'Submitted';
        }
        else if ((Apexpages.currentPage().getParameters().get('SubmitApp')=='IGIPA' || Apexpages.currentPage().getParameters().get('SubmitApp')=='WTPA') && blnChkPartner )
        {
            applicantInfo.Application_Level__c = 'Main';
            applicantInfo.Application_Stage__c = 'In-Review';
        }else if (Apexpages.currentPage().getParameters().get('SubmitApp')=='APCHFEXT' && !blnChkPartner)
        {
            applicantInfo.Application_Stage__c = 'Accepted';
            
            If(applicantInfo.Application_Type__c=='Extension')
            ExtMatchupdate();
        }
        
        if (Apexpages.currentPage().getParameters().get('LevelAppUp')=='true' && !blnChkPartner)
        { 
            //applicantInfo.Application_Level__c = 'Main' for APC HF;
            if(applicantInfo.Type__c == 'Host Family'){
                applicantInfo.Application_Level__c = 'Main';
                system.debug('debug::::promoCodeValue=='+promoCodeValue);
                applicantInfo.PromoCode__c=promoCodeValue;
            }
            //applicantInfo.Application_Level__c = 'Main' for APC PT if the PT is not pregnant;
            if(personInfo.Pregnancy_Indicated__c == 'No'){
                applicantInfo.Application_Level__c = 'Main';
                system.debug('*****### Changing APC app level from "basic" to "main"');
            }
        }
        
         //Jose: B-03072 Stop families if they fail HF eligibility and send then to a sorry page
        if(ApexPages.currentPage().getParameters().get('checkDOS') == 'true'){
                if(applicantInfo.Private_Bedroom_Indicated__c == 'No' || personInfo.Citizenship_Resident_Indicated__c == 'No' || personInfo.English_Fluency__c == 'No'){
                    system.debug('@@@@@ APC HF Application declined');
                    applicantInfo.Application_Stage__c = 'Declined';
                }
        }   
        
        // B-03157 When system fails to assign AD owner to HF, user should be stopped from continuing app(sorry page)
         
            if(applicantInfo.Type__c=='Host Family' && applicantInfo.Intrax_Program__c == 'AuPairCare' && ApexPages.currentPage().getParameters().get('savePersonRef') == 'true')
            {
                system.debug('@@@@@ savePersonRef:APC HF Application');
                if(applicantInfo.Account__c != null)
                {   
                system.debug('@@@@@ savePersonRef:Account__c' + applicantInfo.Account__c);  
                List<GeoMatch__c> geoMatches = [select Match_Status__c,HF_Ownership_Set__c,FromiGeoLocate__r.Lead__c,FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__c,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__c,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__c,ToiGeoLocate__r.Contact__r.Id from GeoMatch__C where FromiGeoLocate__r.Account__c !=NULL AND FromiGeoLocate__r.Account__c=:applicantInfo.Account__c AND Match_Status__c='Geo Matched'];
                if(geoMatches==null || geoMatches.size()==0 )
                    {                
                    system.debug('@@@@@ savePersonRef APC HF Application declined : fails to assign AD owner to HF');
                    applicantInfo.Application_Stage__c = 'Declined';
                    }   
                    
                }
            }
         
        // B-03157 End
        
        
        if(Apexpages.currentPage().getParameters().get('reviewSubmit')=='RS')
        {
            applicantInfo.Application_Level__c = 'Main';
            applicantInfo.Application_Stage__c = 'Submitted';
            
        }
        if(Apexpages.currentPage().getParameters().get('DeclineBApp')=='DA')
        {
            applicantInfo.Application_Stage__c = 'Declined - Agent';
        }
        if(Apexpages.currentPage().getParameters().get('DeclineApp')=='DA')
        {
            applicantInfo.Application_Stage__c = 'Declined - Agent';
        }
        
        String appname;
        system.debug('******Inside Save 1*******'+ applicantInfo);
        if(applicantInfo.Name!=null)
            appname=applicantInfo.Name;
        system.debug('*****@@@appname: ' + appname);
        
        //prepopulate the CreatedBy__c field with the user Id
        
        if(string.isBlank(applicantInfo.CreatedBy__c)){
            applicantInfo.CreatedBy__c = UserInfo.getUserId();
        }
        
        
        if(applicantInfo.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id && applicantInfo.Intrax_Program_Options__c == 'ProWorld Internship'){
            applicantInfo.RecordTypeId = Constants.PW_PT_Record_Type_Id;
        }else if (applicantInfo.RecordTypeId == Constants.PW_PT_Record_Type_Id && applicantInfo.Intrax_Program_Options__c != 'ProWorld Internship'){
            applicantInfo.RecordTypeId = Constants.ICD_Intern_PT_Record_Type_Id;
        }
        
        if(applicantInfo.Engagement_Start__c !=null && applicantInfo.RecordType.Name != 'Centers' && applicantInfo.RecordType.Name != 'AuPairCare PT' && applicantInfo.RecordType.Name != 'AuPairCare HF' && applicantInfo.RecordType.Name != 'ICD Intern PT' && applicantInfo.RecordType.Name != 'PW Participant' && applicantInfo.RecordType.Name != 'Ayusa PT')
        { 
            if(applicantInfo.RecordType.Name == 'Work Travel PT')
            {                  
                if(applicantInfo.Name.contains('-WT'))
                { 
                    applicantInfo.Name = appname.substringBefore('-WT');
                }
                // Modified as per IGI 505
                //Integer adYear = applicantInfo.Engagement_Start__c.year();
                //adYear = adYear+1;
                Integer adYear = applicantInfo.Engagement_End__c.year();
                if (applicantInfo.Season__c == 'Winter')
                {
                    adYear = adYear -1;
                }
                applicantInfo.Program_Year__c = string.valueOf(adYear);
                applicantInfo.Name = applicantInfo.Name +'-WT'+adYear;
            }
            
            else
            {
                if(applicantInfo.Name.contains('-AY'))
                { 
                    applicantInfo.Name = appname.substringBefore('-AY');
                }
                //EU 107
                if(applicantInfo.RecordType.Name == 'Ayusa HF')
                {
                    Integer adYear = applicantInfo.Engagement_Start__c.year();
                    adYear = adYear+1;
                    applicantInfo.Name = applicantInfo.Name +'-AY'+adYear;
                }
            }
        }    
        else if(applicantInfo.RecordType.Name == 'Ayusa PT')
        {
            system.debug('*************Line- 3672***'+ applicantInfo.RecordType.Name);
            if(applicantInfo.Name.contains('-AY'))
            { 
                applicantInfo.Name = appname.substringBefore('-AY');
            }
            if(applicantInfo.Program_Year__c!= null){
                String[] proYearSplit = applicantInfo.Program_Year__c.split('-');
                String adYear = proYearSplit[1];
                applicantInfo.Name = applicantInfo.Name +'-AY'+adYear;
            }
        }
        
        If((applicantInfo.How_Heard__c == 'Web Search' && applicantInfo.How_Heard_Detail__c != 'Other') || (applicantInfo.How_Heard__c == 'Email/Newsletter') || (applicantInfo.How_Heard__c == 'Social media' && applicantInfo.How_Heard_Detail__c != 'Other'))
            applicantInfo.How_Heard_Other__c = '';
        
        If(applicantInfo.How_Heard__c == 'Brochure/Poster/Other Publication' || applicantInfo.How_Heard__c == 'Email/Newsletter' || applicantInfo.How_Heard__c == 'Advertisement' || applicantInfo.How_Heard__c == 'Website'){
            applicantInfo.How_Heard_Detail__c = '';
            applicantInfo.RB_First_Name__c='';
            applicantInfo.RB_Last_Name__c='';}
        /*
        // AA How Heard Mask Values 
        If(applicantinfo.How_Heard_Detail__c == 'Host Family')
            applicantinfo.How_Heard_Detail__c = 'Family';
         
       If(applicantinfo.How_Heard_Detail__c == 'Au Pair')
            applicantinfo.How_Heard_Detail__c = 'Former Participant';
        
       If(applicantinfo.How_Heard_Detail__c == 'Area Director')
            applicantinfo.How_Heard_Detail__c = 'Our Program Staff';
      */
//Address Validation
string URLAux2 =ApexPages.currentPage().getUrl();
system.debug('debug::addressid'+addressid);
system.debug('debug::ErrorId=='+ErrorId);
system.debug('debug::AddressErr::'+ApexPages.currentPage().getParameters().get('ErrorId'));
        
If(URLAux2 != null && URLAux2.contains('/apex/apc_hf_app_personal_info') && ApexPages.currentPage().getParameters().get('AddressErr')==null){
applicantInfo.Home_Street_1__c=avProcessor.potentialMatchesList.get(addressid).get('address1');
applicantInfo.Home_Street_2__c=avProcessor.potentialMatchesList.get(addressid).get('address2');
applicantInfo.Home_City__c=avProcessor.potentialMatchesList.get(addressid).get('city');
applicantInfo.Home_State__c=avProcessor.potentialMatchesList.get(addressid).get('state');
applicantInfo.Home_Postal_Code__c=avProcessor.potentialMatchesList.get(addressid).get('postalCode');
}
        System.debug('##### Value in applicantInfo'+applicantInfo);
        upsert applicantInfo;
        System.debug('##### Value in applicantInfo'+applicantInfo);
        If(ApexPages.currentPage().getParameters().get('doctype2')=='Passport' || ApexPages.currentPage().getParameters().get('pageId')=='034')
            savePersonInfo(); 
    }
    //B-03299
    Public void ExtMatchupdate(){
        system.debug('@@@@@applicantInfo: ' + applicantInfo.id);
        list<Match__c> matchPT;
        If(applicantInfo.Type__c=='Host Family' && applicantInfo.RecordTypeId == constants.AuPairCareHF_Record_Type_Id)
        {
            matchPT = [Select Id, Engagement__c, Start_Date__c,Arrival_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c 
                       from Match__c WHERE Position_Name__c =: applicantInfo.Position__c AND Status__c = 'Requested' ORDER BY CreatedDate DESC];  
            system.debug('@@@@@matchPT: ' + matchPT);
            if(matchPT!=null && matchPT.size()>0){
                matchPT[0].Offer_Status__c = 'Offered';
                update matchPT[0];
            }
        }
        
        If(applicantInfo.RecordTypeId == constants.AuPairCarePT_Record_Type_Id){
            matchPT = [Select Id, Engagement__c, Start_Date__c,Arrival_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c 
                       from Match__c WHERE Engagement__c =: applicantInfo.Engagement__c AND Status__c = 'Requested' ORDER BY CreatedDate DESC];  
            system.debug('@@@@@matchPT: ' + matchPT);
            if(matchPT!=null && matchPT.size()>0){
                matchPT[0].Offer_Status__c = 'Accepted';
                update matchPT[0];
            }
        }
    }
    //Save PersonInfo
    public void savePersonInfo() { 
        System.debug('####### value in applicant Info '+ personInfo.Applicant_Info__c);
        if (personInfo.Applicant_Info__c == NULL ) personInfo.Applicant_Info__c = applicantInfo.Id;
        
        system.debug('####### value in applicant Info After'+ personInfo.Applicant_Info__c);
        system.debug('***### getUserType: ' + userInfo.getUserType());
        system.debug('***### ' + ApexPages.currentPage().getParameters().get('partnerApp')); 
        if(userInfo.getUserType() == 'PowerCustomerSuccess' && ApexPages.currentPage().getParameters().get('partnerApp') != null){ 
            personInfo.Name = applicantInfo.Name;
            personInfo.First_Name__c = applicantInfo.First_Name__c;
            personInfo.Last_Name__c = applicantInfo.Last_Name__c;
            personInfo.Email__c = applicantInfo.Email__c;
        } else personInfo.Name = personInfo.First_Name__c + ' '+ personInfo.Last_Name__c;
        
        system.debug('***### personInfo.First_Name__c: ' + personInfo.First_Name__c);
        //Host Family application must have a State value before a Lead or Account association
        if (personInfo.Role__c == 'Student'|| personInfo.Role__c == 'Host' || personInfo.Role__c == 'Participant'){
            personInfo.Primary_Applicant__c = true;
            personInfo.Residency_Status__c='Full-Time';
            //TagCode
            if (personInfo.Email__c != null){
                //Host Family application must have a State value before a Lead or Account association
                If(personInfo.Role__c == 'Host'){
                    if(!String.isBlank(applicantInfo.Home_State__c)){
                        /* Uncomment the following for removing Sharing (AYII-136)
//tagApplicationToAccAndOrLead();*/
                    }
                }
                //For all other applications
                else{
                    /* Uncomment the following for removing Sharing (AYII-136)
//tagApplicationToAccAndOrLead();*/
                }
            } 
        }
        else{
            personInfo.Primary_Applicant__c = false;
        }
        
        //Set BackGround Check default value if application is Centers
        if(applicantInfo.RecordType.Name == 'Centers') {  
            personInfo.Background_Check__c = 'Not Required';
        }
        
        if (familyMember!= Null && familyMember) personInfo.Family_Member__c = true;
        
        upsert personInfo;
        System.debug('##### Value in PersonInfo'+personInfo); 
    }   
    
    //Save LocationInfo
    public void saveLocationInfo(){
        try{
            if (locationInfo.Applicant_Info__c == NULL )
                locationInfo.Applicant_Info__c = applicantInfo.Id;
            locationInfo.Name = 'Location ' + ApplicantInfo.Name;
            upsert LocationInfo;
        }catch(Exception e){
            system.debug(' ******** No location records for this applicant.');
        }
    }
    
    //Save FamilyInfo
    public void saveFamilyInfo(){
        try{
            familyInfo.Applicant_Info__c = applicantInfo.Id;
            familyInfo.Name = familyInfo.First_Name__c + ' '+ familyInfo.Last_Name__c;
            if (familyMember!= null && familyMember) familyInfo.Family_Member__c =  true;
            upsert familyInfo;
        }catch(Exception e){
            system.debug(' ******** No Member records for this applicant.');
        }
    }
    
    //Save ReferrerInfo
    public void saveRefererInfo(){
        try{
            refererInfo.Applicant_Info__c = applicantInfo.Id;
            refererInfo.Name = refererInfo.First_Name__c + ' '+ refererInfo.Last_Name__c;
            refererInfo.Role__c='Reference';
            upsert refererInfo;
        }catch(Exception e){
            system.debug(' ******** No Referer records for this applicant.');
        }
    }
    
    //Save SchoolInfo
    public void saveSchoolInfo(){
        try{
            if (schoolInfo.Applicant_Info__c == NULL )
                schoolInfo.Applicant_Info__c = applicantInfo.Id;
            schoolInfo.Name = 'School ' + ApplicantInfo.Name;
            upsert schoolInfo;
        }catch(Exception e){
            system.debug(e);
            system.debug(' ******** No school records for this applicant.');
        }
    } 
    
    public void saveUserInfo(){
        update user;
    }
    
    //############Start APC Education & Training##############    
    // Add new University and Certificate Record
    public void addEducationRecordApc(){
        saveEducationApc();
        Education__c ed = new Education__c();
        ed.Applicant_Info__c=applicantinfo.id;
        If(addedu=='university'){
            ed.Institution_Type__c='University/College';
            applicantInfo.University_Indicated__c='Yes';
        }else{
            ed.Institution_Type__c='Vocational Training';
            applicantInfo.Additional_Training_Indicated__c='Yes';
        }
        insert ed;
        //system.debug('***** Before SaveEducation!'+educationApcMap.values());
        saveApplication();
        buildEduMapApc();
        LoadEduDocRecord();
    }
    
    // Remove existing University and Certificate Record
    public void removeEducationRecordapc(){
        system.debug('***** Removing ed Record: ' + toDelIdent);
        Education__c ed;
        Integer delIndex = -1;
        Integer toBeDeletedIndex = -1;
        for (Education__c delEdu : educationApcMap.get(educationType)){
            delIndex++;
            if (delEdu.Id == delEducationRec){
                ed = delEdu;
                toBeDeletedIndex = delIndex;
            }
        }
        //system.debug('****** Record deleted: ' + ed.Id);
        try{
            delete ed;  
            educationApcMap.get(educationType).remove(toBeDeletedIndex);
            
            // To update Applicant Info for university record
            If(educationType=='university' && educationApcMap.get(educationType).size()==0){
                applicantInfo.University_Indicated__c='No';
                saveApplication();
            }
            // To update Applicant Info for certification record
            If(educationType=='certification' && educationApcMap.get(educationType).size()==0){
                applicantInfo.Additional_Training_Indicated__c='No';
                saveApplication();
            }
            
        }catch(Exception e){
            system.debug('***** Impossible to delete education record: '+e);
        }
        buildEduMapApc();
    }
    
    // Load University and Certificate Record on the page.
    public void buildEduMapApc(){
        educationInfoList = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c,Address_Street_1__c,Address_Street_2__c,Phone__c,Phone_Country_Code__c,Program_Type_Other__c,Study_Level__c,City__c,Country__c,Postal_Code__c,State__c,Certification__c
                             FROM Education__c WHERE Applicant_Info__c =: applicantInfo.Id and Institution_Type__c!='High/Secondary School' 
                             order by CreatedDate];
        
        system.debug('******** Building Education map: ' + educationInfoList.size());
        educationApcMap = new map<string,List<Education__c>>();
        educationSizeMap = new map<string,integer>();
        educationApcMap.put('university',new List<Education__c>());
        educationApcMap.put('certification',new List<Education__c>());
        for(integer i = 1; i<= educationInfoList.size(); i++){
            If(educationInfoList[i-1].Institution_Type__c=='University/College'){
                educationApcMap.get('university').add(educationInfoList[i-1]);
            }
            If(educationInfoList[i-1].Institution_Type__c=='Vocational Training'){
                educationApcMap.get('certification').add(educationInfoList[i-1]);
            }
        }
        for(String key : educationApcMap.keySet())
        {
            educationSizeMap.put(key, educationApcMap.get(key).size());
            system.debug('==inside for loop educationSizeMap==== '+educationSizeMap.get(key)+' Keyyy=== '+key);
        }
    }
    
    // Save all Educatiion Record on the page.
    public void saveEducationApc(){
        system.debug('***** Saving Education record!');
        if(applicantInfo.Application_Level__c == 'Main'){
            try{
                if(educationInfo.Applicant_Info__c == null){ 
                    educationInfo.Applicant_Info__c= applicantInfo.Id;
                    educationInfo.Institution_Type__c='High/Secondary School';
                    educationInfo.Graduation_Date__c=personInfo.Graduation_Date__c;
                }
                upsert educationInfo;
                edu_id=educationInfo.id;
                
                for(Education__c e :  educationApcMap.get('university')){
                    if(e.Applicant_Info__c == null){
                        e.Applicant_Info__c = ApplicantInfo.Id;
                        e.Institution_Type__c='University/College';
                        e.Program_Type__c=ProgramType;
                        
                    }
                }
                system.debug('***** Before Saving University record!'+educationApcMap.values());
                upsert educationApcMap.get('university');
                system.debug('***** after Saving University!'+educationApcMap.values());
                
                for(Education__c e :  educationApcMap.get('certification')){
                    if(e.Applicant_Info__c == null){
                        e.Applicant_Info__c = ApplicantInfo.Id;
                        e.Institution_Type__c='Vocational Training';
                    }
                }
                system.debug('***** Saving certificate record!'+educationApcMap.values());
                upsert educationApcMap.get('certification');
            }catch(Exception e){
                system.debug('***** Impossible to save Education Record: ' + e);
            } 
        }
        saveapplication();
    }
    
    
    //############End APC Education & Training##############
    // Experience for Renewal APC PT 
    public void saveAuPairExperience(){
        system.debug('***** Saving Experience record!');
        system.debug('Application_Type__c is Renewal ');
        integer days;
        Date StartDate;
        Date EndDate;
       
                   
       
            try{
                experienceAPC.Applicant_Info__c = applicantInfo.Id;
                experienceAPC.Experience_Type__c='Au Pair'; 
                experienceAPC.Name='Au Pair Experience';
                
                if(applicantInfo.Account__c !=null){
                system.debug('Engagement  ' + applicantInfo.Engagement__c);
                system.debug('applicantInfo.Account__c: ' + applicantInfo.Account__c);
                
                
                experienceAPC.Engagement__c=applicantInfo.Engagement__c;
                experienceAPC.IsExperienced__c=true;
                    
               
                    list<Match__c> matchPT = [Select Participant_Id__c, Id, Start_Date__c, End_Date__c, Position_Name__c,  Status__c 
                    from Match__c WHERE Participant_Id__c =: applicantInfo.Account__c AND (Status__c=: 'Confirmed') ORDER BY CreatedDate DESC];  
                                                
        
                    if(matchPT!=null && matchPT.size()>0){
                    system.debug('@@@@@matchPT: ' + matchPT);
                    system.debug('@@@@@matchPT[0].Engagement__r.Account_Id__c: ' + matchPT[0].Participant_Id__c);
                    system.debug('Match start date ' + matchPT[0].Start_Date__c);
                    system.debug('Match start date ' + matchPT[0].End_Date__c);
                    
                    
                    Position__c position =[select Host_Company_Id__c,OwnerId, Double_Placement_Indicated__c from Position__c where Id = :matchPT[0].Position_Name__c];
                    if (position !=null && position.Host_Company_Id__c !=null)
                    {
                    system.debug('***position.Host_Company_Id__c******'+position.Host_Company_Id__c);    
                    Account acc = [Select c.Id, c.FirstName, c.LastName , c.Name From Account c where c.Id=: position.Host_Company_Id__c];
               
                    experienceAPC.First_Name__c=acc.FirstName;
                    experienceAPC.Last_Name__c=acc.LastName;
                    
                    if (acc.Name !=NULL)
                        experienceAPC.Name=acc.Name;
                    
                    }
                    experienceAPC.Start_Date__c= matchPT[0].Start_Date__c;
                    experienceAPC.End_Date__c = matchPT[0].End_Date__c;
                    StartDate=matchPT[0].Start_Date__c;
                    EndDate=matchPT[0].End_Date__c;
           
                    //days = experience.Start_Date__c.daysBetween(experience.End_Date__c);
                    days=getDiffBusinessDays(StartDate, EndDate );
  
                    experienceAPC.Amount_Hours__c = days*8;
                    
                    }
                }
                upsert experienceAPC;
            }catch(Exception e){
                system.debug('***** Impossible to save Experience Record: ' + e);
             
        }
       // saveapplication();
    }
 private Integer getDiffBusinessDays(Date startdt, Date enddt) {
    Date tempdate = null;
    if (startdt > enddt) {
    tempdate = enddt;
    enddt = startdt;
    startdt = tempdate;
    }
Integer i = Math.mod((date.newinstance(1985, 6, 24)).daysBetween(startdt),7); // 24/6/85 was a monday
Map<Integer, Map<Integer, Integer>> m = new Map<Integer, Map<Integer, Integer>> {
0 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 5 , 5 => 5 , 6 => 5 },
1 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 4 , 5 => 4 , 6 => 5 },
2 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 3 , 4 => 3 , 5 => 4 , 6 => 5 },
3 => new Map<Integer, Integer> { 1 => 2 , 2 => 2 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
4 => new Map<Integer, Integer> { 1 => 1 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
5 => new Map<Integer, Integer> { 1 => 0 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
6 => new Map<Integer, Integer> { 1 => 1 , 2 => 2 , 3 => 3 , 4 => 4 , 5 => 5 , 6 => 5 }
};
Integer i2 = Math.mod((startdt.daysBetween(enddt)),7);
Integer i3 = (m.get(i)).get(i2);
if (i2 == null || i2 < 1 || i2 > 6) {
if (i >= 0 && i <= 4) { i3 = 1; } 
else  { i3 = 0; }
}
i3 = i3 + 5 * (Math.floor( ((Decimal) startdt.daysBetween(enddt)).divide(7,4))).intValue(); 
if (tempdate != null) i3 *= -1; // negative number of days
return i3;
    }
    /* IGI App 2.0    */
    public void addEducationRecord(){
        system.debug('****** Adding Education Record: ');
        list<integer> keyList = new List<Integer>();     
        if(educationMap!=null){ //D-01517
            keyList.addAll(educationMap.keySet());
            keyList.sort(); 
        }       
        if(keyList.size() == 0){
            educationMap = new Map<Integer,Education__c>();//D-01517
            educationMap.put(1, new Education__c());
        }
        else
            educationMap.put(keyList[keyList.size()-1]+1, new Education__c());        
    }
    
    public void addExperienceRecord(){
        system.debug('****** Adding Experience Record: ');
        if(experienceMap == null) experienceMap = new map<integer,Experience__c>();
        list<integer> keyList = new List<Integer>(); 
        keyList.addAll(experienceMap.keySet());
        keyList.sort();
        if(keyList.size() == 0) experienceMap.put(1, new Experience__c());
        else experienceMap.put(keyList[keyList.size()-1]+1, new Experience__c());
    }
    public void addDependentsRecord(){
        system.debug('****** Adding Experience Record: ');
        if(dependentsMap == null) dependentsMap = new map<integer,Person_Info__c>();
        list<integer> keyList = new List<Integer>(); 
        keyList.addAll(dependentsMap.keySet());
        keyList.sort();
        if(keyList.size() == 0) dependentsMap.put(1, new Person_Info__c());
        else dependentsMap.put(keyList[keyList.size()-1]+1, new Person_Info__c());
    }
    
    public void addEmergencyRecord(){
        system.debug('****** Adding Emergency Record: ');
        if(emergencyMap == null) emergencyMap = new map<integer,Person_Info__c>();
        list<integer> keyList = new List<Integer>(); 
        keyList.addAll(emergencyMap.keySet());
        keyList.sort();
        if(keyList.size() == 0) emergencyMap.put(1, new Person_Info__c());
        else emergencyMap.put(keyList[keyList.size()-1]+1, new Person_Info__c());
    }
    
    public integer getEducationMapLast(){
        list<integer> keyList = new List<Integer>(); 
        keyList.addAll(educationMap.keySet());
        keyList.sort();
        return keylist[keyList.size()-1];
    }
    
    public integer getExperienceMapLast(){
        list<integer> keyList = new List<Integer>(); 
        keyList.addAll(experienceMap.keySet());
        keyList.sort();
        return keylist[keyList.size()-1];
    }
    public integer getDependentsMapLast(){
        list<integer> keyList = new List<Integer>(); 
        keyList.addAll(dependentsMap.keySet());
        keyList.sort();
        return keylist[keyList.size()-1];
    }
    
    public integer getEmergencyMapLast(){
        list<integer> keyList = new List<Integer>(); 
        keyList.addAll(emergencyMap.keySet());
        keyList.sort();
        return keylist[keyList.size()-1];
    }
    
    public void removeEducationRecord(){
        system.debug('***** Removing ed Record: ' + toDelIdent);
        
        Education__c ed = educationMap.get(toDelIdEnt);
        system.debug('****** Record deleted: ' + ed.Id);
        try{
            delete ed; 
            
        }catch(Exception e){
            system.debug('***** Impossible to delete education record: '+e);
        }
        // We need to remove the element from the map
        system.debug('****** Map Size() BFR:' + educationMap.size());
        if(educationMap.containsKey(toDelIdent)){
            educationMap.remove(toDelIdEnt);
        }
        
    }
    
    public void removeEmergencyRecord(){
        system.debug('***** Removing ed Record: ' + toDelIdent);
        
        Person_Info__c p = emergencyMap.get(toDelIdEnt);
        system.debug('****** Record deleted: ' + p.Id);
        try{
            delete p;
        }catch(Exception e){
            system.debug('***** Impossible to delete education record: '+e);
        }
        // We need to remove the element from the map
        system.debug('****** Map Size() BFR:' + emergencyMap.size());
        if(emergencyMap.containsKey(toDelIdent)){
            emergencyMap.remove(toDelIdEnt);
        }
        
    }
    
    public void removeExperienceRecord(){
        system.debug('***** Removing Experience Record: ' + toDelIdent);
        
        Experience__c exp = experienceMap.get(toDelIdEnt);
        system.debug('****** Record deleted: ' + exp.Id);
        try{
            delete exp;
        }catch(Exception e){
            system.debug('***** Impossible to delete education record: '+e);
        }
        // We need to remove the element from the map
        system.debug('****** Map Size() BFR:' + experienceMap.size());
        if(experienceMap.containsKey(toDelIdent)){
            experienceMap.remove(toDelIdEnt);
        }
        
    }
    public void removeDependentsRecord(){
        system.debug('***** Removing Dependents Record: ' + toDelIdent);
        
        Person_Info__c exp = dependentsMap.get(toDelIdEnt);
        system.debug('****** Record deleted: ' + exp.Id);
        try{
            delete exp;
        }catch(Exception e){
            system.debug('***** Impossible to delete dependents record: '+e);
        }
        // We need to remove the element from the map
        system.debug('****** Map Size() BFR:' + dependentsMap.size());
        if(dependentsMap.containsKey(toDelIdent)){
            dependentsMap.remove(toDelIdEnt);
        }
        
    }
    
    public void removeExperienceRecords(){
        list<Experience__c> exp_deleted = [SELECT Id FROM Experience__c WHERE Applicant_Info__c =: applicantInfo.Id];
        
        if(exp_deleted.size() > 0){
            try{
                delete exp_deleted;
            }catch(Exception e){
                system.debug('****** Impossible to delete Experience recods: ' + e);
            }
        }
    }
    public void removeDependentsRecords(){
        list<Person_Info__c> dep_deleted = [SELECT Id FROM Person_Info__c WHERE Applicant_Info__c =: applicantInfo.Id and  RecordTypeId=: Constants.IGI_Dependent_Record_Type];
        
        if(dep_deleted.size() > 0){
            try{
                delete dep_deleted;
            }catch(Exception e){
                system.debug('****** Impossible to delete Dependents recods: ' + e);
            }
        }
    }
    
    public void buildEmergencyContactMap(){
        list<Person_Info__c> emergencyList = [select p.Primary_Applicant__c, p.Role_Other__c, p.Title__c, p.TimeZoneSidKey__c, p.Work_Phone__c, p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Family_Member__c 
                                              From Person_Info__c p 
                                              Where p.Applicant_Info__c = :applicantInfo.Id 
                                              and Emergency_Contact_Indicated__c = 'Yes']; 
        
        if(emergencyList.size() == 0){
            emergencyMap = new map<integer, Person_info__c>(); 
            emergencyMap.put(1, new Person_Info__c());
        } else if(emergencyList.size() > 0){
            emergencyMap = new map<integer, Person_info__c>();  
            for(integer i = 1; i<= emergencyList.size(); i++){
                emergencyMap.put(i, emergencyList[i-1]);
                
            }
            system.debug('****** Map Size() REBUILT:' + emergencyMap.size());   
        }   
        
    }
    
    public void buildEducationMap(){
        educationInfoList = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Applicant_Info__c, study_level__c
                             FROM Education__c 
                             WHERE Applicant_Info__c =: applicantInfo.Id 
                             order by Graduation_Date__c DESC];
        
        system.debug('******** Building Education map: ' + educationInfoList.size());
        
        educationMap = new map<integer, Education__c>();
        if(educationInfoList.size() > 0){           
            for(integer i = 1; i<= educationInfoList.size(); i++){
                educationMap.put(i, educationInfoList[i-1]);
                
            }
            system.debug('****** Map Size() REBUILT:' + educationMap.size());
        }   
        
        
    }
    
    public void buildExperienceMap(){
        list<Experience__c> experienceList = [SELECT exp.ID, exp.Name, exp.Applicant_info__c, exp.City__c, exp.Employer_Name__c, exp.End_Date__c, exp.Country__c,
                                              exp.Position_Description__c, exp.Position_Title__c, exp.Skills_Required__c, exp.Start_Date__c, exp.IsExperienced__c,
                                              exp.Experience_Type__c, exp.Phone__c, exp.Email__c, exp.IsReference__c, exp.Reference_Request_Note__c, Reference_Contact_Requested__c,exp.Current_Job__c,
                                              exp.Number_of_Children__c, exp.Children_Ages__c, exp.Under_2_Percentage__c, exp.First_Name__c, exp.Last_name__c, exp.Position_Responsibilities__c, exp.Special_Needs_Indicated__c, exp.Special_Needs_Description__c,
                                              exp.Employment_Hrs__c, exp.Experience_Category__c, exp.Details_Name__c, exp.Amount_Hours__c, exp.Frequency__c,exp.Reference_Language__c,
                                              exp.Amount_Hours_Under_2__c,exp.Phone_Country_Code__c
                                              FROM Experience__c exp 
                                              WHERE Applicant_Info__c =: applicantInfo.Id 
                                              order by createdDate DESC];
        
        system.debug('******** Building Education map: ' + experienceList.size());
        
        if(experienceList.size() > 0){
            experienceMap = new map<integer, Experience__c>(); 
            for(integer i = 1; i<= experienceList.size(); i++){
                experienceMap.put(i, experienceList[i-1]);
                
            }
        }   
        
        //system.debug('****** Map Size() REBUILT:' + educationMap.size());     
    }
    public void buildDependentsMap(){
        list<Person_Info__c> dependentsList = [select p.Primary_Applicant__c,p.Financial_Support_Description__c,p.Community_Service__c,p.Interests__c, p.Role_Other__c,p.Employer_Name__c,p.Phone__c, p.State__c, p.City__c,
                                               p.Work_Supervisor__c,p.Profession__c, p.Title__c,p.Role__c,p.Education_Level__c, p.TimeZoneSidKey__c, Work_Phone__c, p.SystemModstamp, p.Relationship__c,
                                               p.Skype_Id__c, p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Name, p.Mobile__c, p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate,p.Postal_Code__c , p.Street__c,p.Street_2__c,
                                               p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Email__c, p.ESSN__c, p.Date_of_Birth__c,p.Country__c, 
                                               p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c,
                                               p.Best_Call_Time__c,p.nick_name__c, p.Applicant_Info__c,p.Residency_Status__c,p.Family_Member__c, p.Phone_Type__c, p.Job_Sector__c
                                               From Person_Info__c p 
                                               WHERE Applicant_Info__c =: applicantInfo.Id and  RecordTypeId=: Constants.IGI_Dependent_Record_Type
                                               order by createdDate DESC];
        // (Relationship__c=: 'Child' or Relationship__c=: 'Spouse') and
        system.debug('******** Building Dependents map: ' + dependentsList.size());
        
        if(dependentsList.size() > 0){
            dependentsMap = new map<integer, Person_Info__c>(); 
            for(integer i = 1; i<= dependentsList.size(); i++){
                dependentsMap.put(i, dependentsList[i-1]);
                
            }
        }   
        
        //system.debug('****** Map Size() REBUILT:' + educationMap.size());     
    }
    
    public void saveEmergencyContact(){
        system.debug('***** Saving Emergency record!');
        // We only save only record when the app is on 'Basic'
        
        try{
            
            //Added By Saroj (Start)
            list <Person_Info__c> PerInfotoUpdate = new list <Person_Info__c>();
            for(Person_Info__c pem :  emergencyMap.values())
            {
                if (pem.First_Name__c != '' && pem.Last_Name__c != '' && pem.First_Name__c != NULL && pem.Last_Name__c != NULL)
                {
                    PerInfotoUpdate.add(pem);
                }
            }
            //Added By Saroj (End)
            if(PerInfotoUpdate.size() > 0)
            {
                for(Person_Info__c p :  PerInfotoUpdate){
                    if(p.Applicant_Info__c == null) {
                        p.Applicant_Info__c = ApplicantInfo.Id;
                        p.Emergency_Contact_Indicated__c = 'Yes';
                        p.Name = p.First_Name__c + ' ' + p.Last_Name__c;
                        //p.role = ??
                    }
                }
                
                upsert PerInfotoUpdate;
                
                if (ApplicantInfo.Engagement__c != NULL && ApexPages.currentPage().getParameters().get('FromNotify') != NULL)
                {
                    list<Notification__c> ListNotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: ApplicantInfo.Engagement__c AND Type__c = 'Emergency Contact' AND Status__c = 'Not Started'];
                    if(ListNotInfo.size() > 0)
                    {
                        for(Notification__c NotInfo:ListNotInfo)
                        {
                            NotInfo.Status__c = 'Confirmed';
                        }
                        update ListNotInfo;
                    }
                }
            }
        }catch(Exception e){
            system.debug('****** EDUCATION MAP ERROR: ' + e);
        }
        
    } 
    
    public PageReference saveAPCApptoInReview()
    {
        system.debug('****** Appinfo****: ' + applicantInfo);
        applicantInfo.Application_Stage__c = 'In-Review';
        update applicantInfo;
        system.debug('debug::update applicantInfo 5');
        PageReference P = new PageReference('/apex/pr_app_list');
        P.setRedirect(true);
        return P;
        
    }
    
    public PageReference saveAPCApptoDeclined()
    {
        system.debug('****** Appinfo****: ' + applicantInfo);
        applicantInfo.Application_Stage__c = 'Declined';
        update applicantInfo;
        system.debug('debug::update applicantInfo 6');
        PageReference P = new PageReference('/apex/pr_app_list');
        P.setRedirect(true);
        return P;
        
    }
    
    public PageReference saveHealthInfo()
    {
        // D-01357 --> Included PageStatusController to set PageStatusComplete_Id__c field
        PageStatusController(); 
        update applicantInfo;
        system.debug('debug::update applicantInfo 7');
        update personInfo;
        
        if (ApplicantInfo.Engagement__c != NULL && ApexPages.currentPage().getParameters().get('FromNotify') != NULL)
        {
            list<Notification__c> ListNotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: ApplicantInfo.Engagement__c AND Type__c = 'Health Information' AND Status__c = 'Not Started'];
            if(ListNotInfo.size() > 0)
            {
                for(Notification__c NotInfo:ListNotInfo)
                {
                    NotInfo.Status__c = 'Confirmed';
                }
                update ListNotInfo;
            }
        }
        
        PageReference P = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        p.setRedirect(true);
        return p;
        
    }
    
    public PageReference saveEmergencyContactNotify(){
        system.debug('***** Saving Emergency record!');
        // We only save only record when the app is on 'Basic'
        
        try{
            
            //Added By Saroj (Start)
            list <Person_Info__c> PerInfotoUpdate = new list <Person_Info__c>();
            for(Person_Info__c pem :  emergencyMap.values())
            {
                if (pem.First_Name__c != '' && pem.Last_Name__c != '' && pem.First_Name__c != NULL && pem.Last_Name__c != NULL)
                {
                    PerInfotoUpdate.add(pem);
                }
            }
            //Added By Saroj (End)
            if(PerInfotoUpdate.size() > 0)
            {
                
                for(Person_Info__c p :  PerInfotoUpdate){
                    if(p.Applicant_Info__c == null) {
                        p.Applicant_Info__c = ApplicantInfo.Id;
                        p.Emergency_Contact_Indicated__c = 'Yes';
                        p.Name = p.First_Name__c + ' ' + p.Last_Name__c;
                        //p.role = ??
                    }
                }
                
                upsert PerInfotoUpdate;
                
                if (ApplicantInfo.Engagement__c != NULL && ApexPages.currentPage().getParameters().get('FromNotify') != NULL)
                {
                    list<Notification__c> ListNotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: ApplicantInfo.Engagement__c AND Type__c = 'Emergency Contact' AND Status__c = 'Not Started'];
                    if(ListNotInfo.size() > 0)
                    {
                        for(Notification__c NotInfo:ListNotInfo)
                        {
                            NotInfo.Status__c = 'Confirmed';
                        }
                        update ListNotInfo;
                    }
                }
            }
        }catch(Exception e){
            system.debug('****** EDUCATION MAP ERROR: ' + e);
        }
        PageReference P = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        p.setRedirect(true);
        return p;
        
    } 
    
    public PageReference setPageIdStarted(){
        system.debug('****** SKIP PAGE - PageId: ' + ApexPages.CurrentPage().getParameters().get('PageId'));
        PageReference p = new PageReference('/igi_pt_app_home?Id='+applicantInfo.Id);
        p.setRedirect(true);
        
        string pageId = ApexPages.CurrentPage().getParameters().get('PageId');
        system.debug('****** ' + applicantInfo.Id + ' / ' + applicantInfo.PageStatus_Started__c + ' / ' + applicantInfo.PageStatus_Complete__c);
        if(pageId != null && pageId != ''){
            
            if(applicantInfo.PageStatus_Started__c != null && !(applicantInfo.PageStatus_Started__c.contains(pageId)) && !(applicantInfo.PageStatus_Complete__c.contains(pageId)) ){
                applicantInfo.PageStatus_Started__c += ';' + PageId ;
            } else if(applicantInfo.PageStatus_Started__c == null && !(applicantInfo.PageStatus_Complete__c.contains(pageId))){
                applicantInfo.PageStatus_Started__c = PageId;
            }
            try{
                update applicantInfo;
                system.debug('debug::update applicantInfo 8');
            }catch(Exception e){
                system.debug('****** SetPageIdStarted function ERROR: ' + e);
            }
        }
        
        return p;
    }
    
    public void resetpageIdValues(){
        // For now, we only need to move education Page for 'Completed' to 'Started'
        system.debug('****** RESET Page Ids!!!');
        if(applicantInfo.PageStatus_Complete__c.Contains('052')){       
            applicantInfo.PageStatus_Started__c = '052';
            applicantInfo.PageStatus_Complete__c = applicantInfo.PageStatus_Complete__c.Replace('052;','');
            
        }   
        
    }
    public void resetDependentsPageId(){
        // Change Dependents Page Status 
        system.debug('**** applicantInfo.PageStatus_Complete__c!!!' + applicantInfo.PageStatus_Complete__c);
        
        if(applicantInfo.PageStatus_Complete__c.Contains('063')){  
            system.debug('****PageStatus_Started__c = 063!!!');     
            //applicantInfo.PageStatus_Started__c = '063';
            if (applicantInfo.J2_Dependent_Indicated__c=='Yes')
            {
                
                if(IsPartner==true )
                {   
                    if (!checkIGIDependentsDocs())
                    {
                        system.debug('****J2_Terms_Accepted__c!!!' +applicantInfo.J2_Terms_Accepted__c);
                        applicantInfo.PageStatus_Complete__c = applicantInfo.PageStatus_Complete__c.Replace('063','');
                        system.debug('****before applicantInfo.PageStatus_Complete__c!!!' + applicantInfo.PageStatus_Complete__c);
                        update applicantInfo;
                        system.debug('debug::update applicantInfo 9');
                        system.debug('****after applicantInfo.PageStatus_Complete__c!!!' + applicantInfo.PageStatus_Complete__c);
                    }
                    
                    
                }   
                else 
                {
                    if (applicantInfo.J2_Terms_Accepted__c==false || !checkIGIDependentsDocs())
                    {
                        system.debug('****J2_Terms_Accepted__c!!!' +applicantInfo.J2_Terms_Accepted__c);
                        applicantInfo.PageStatus_Complete__c = applicantInfo.PageStatus_Complete__c.Replace('063','');
                        system.debug('****before applicantInfo.PageStatus_Complete__c!!!' + applicantInfo.PageStatus_Complete__c);
                        update applicantInfo;
                        system.debug('debug::update applicantInfo 10');
                        system.debug('****after applicantInfo.PageStatus_Complete__c!!!' + applicantInfo.PageStatus_Complete__c);
                    }
                }
            }   
            
        }
        
        
    }
    
    public void saveExperienceIGI(){
        system.debug('***** Saving Experience records!');
        // We only save only record when the app is on 'Basic'
        
        try{
            for(Experience__c exp :  experienceMap.values()){
                if(exp.Applicant_Info__c == null) {
                    exp.Applicant_Info__c = ApplicantInfo.Id;
                    exp.Name = exp.Employer_name__c;
                }
            }
            
            upsert experienceMap.values();
        }catch(Exception e){
            system.debug('****** EDUCATION MAP ERROR: ' + e);
        }
        
    } 
    public void saveDependentsIGI(){
        system.debug('***** Saving Dependents records!');
        // We only save only record when the app is on 'Basic'
        
        try{
            for(Person_Info__c exp :  dependentsMap.values()){
                if(exp.Applicant_Info__c == null) {
                    exp.Applicant_Info__c = ApplicantInfo.Id;
                    exp.Name = exp.First_Name__c + exp.Last_Name__c;
                    exp.RecordTypeId=Constants.IGI_Dependent_Record_Type;
                }
            }
            
            upsert dependentsMap.values();
            upsert applicantInfo;
        }catch(Exception e){
            system.debug('****** Dependents MAP ERROR: ' + e);
        }
        
    } 
    
    public boolean getPastGraduation(){      
        if(educationInfo.Graduation_Date__c != null){           
            if(educationInfo.Graduation_Date__c < date.today()) return true;
            else return false; 
        }else return false;
    }
    
    public boolean getFourYearsFromGraduation(){ 
        
        if(educationInfo.Graduation_Date__c != null){
            integer days = educationInfo.Graduation_Date__c.daysBetween(date.today());
            if(days > 1460) return true;
            else return false; 
        }else return false; 
        
    }
    
    public boolean getValidateIGIBasicApp(){
        //system.debug('******* Validate Basic: ' + 18*365.2425 + ' / ' + applicantInfo.Engagement_Start__c.daysBetween(personInfo.Date_Of_Birth__c));
        boolean validate_age= personInfo.Date_Of_Birth__c.daysBetween(applicantInfo.Engagement_Start__c) < 18*365.2425;
        system.debug('IPU'+applicantInfo.Intrax_Program_Options__c+'citizenship'+personInfo.Citizenship__c+'CI**'+applicantInfo.Country_of_Interest__c);
        if(validate_age
           || (applicantInfo.Engagement_Start__c < (date.today()+90) && applicantInfo.Service_Level__c == 'Premium') 
           || (applicantInfo.Engagement_Start__c < (date.today()+60) && applicantInfo.Service_Level__c == 'Independent') ){
               if(applicantInfo.Country_of_Interest__c == 'United States' && !validate_age){
                   if(personInfo.Citizenship__c == 'United States')
                   {
                       
                       if(!applicantInfo.US_Domestic_Participant__c)
                       {
                           return false;
                       }
                   }
                   
                   else if(!IUtilities.isIncluded(applicantInfo.Intrax_Program_Options__c,'Practical Training'))
                   {
                       system.debug('inside Practical Training');
                       return false;
                   }
               }
               else
                   return false;
               
           }else{
               map<String, Program_Duration__c> igi_map = Program_Duration__c.getall();
               for(Program_Duration__c ipd : igi_map.values()){
                   if(ipd.Country__c == applicantInfo.Country_of_Interest__c && ipd.Category__c == applicantInfo.Intrax_Program_Category__c){
                       if(applicantInfo.Country_of_Interest__c == 'United States'){
                           if(IUtilities.IsIncluded(applicantInfo.Intrax_Program_Options__c, ipd.Intrax_Program_Option__c) || IUtilities.IsIncluded(applicantInfo.Sevis_Program__c, ipd.Sevis_Program__c)){
                               if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) > ipd.max_Duration__c){
                                   return false;
                               }else if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) < ipd.min_Duration__c){
                                   return false;
                               }
                           }
                       }else{
                           if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) > ipd.max_Duration__c){
                               return false;
                           }else if(applicantInfo.Engagement_Start__c.monthsBetween(applicantInfo.Engagement_End__c) < ipd.min_Duration__c){
                               return false;
                           }
                       }                           
                   }
               }
               
               // Validating Graduation Date                                           
              /* if(EducationInfo.Id != null && educationInfo.Graduation_date__c != null && (educationInfo.Graduation_Date__c.monthsBetween(date.today()) > 6) && applicantInfo.Currently_Studying__c == 'No' && applicantInfo.One_Year_Work_Experience__c == false && applicantInfo.Five_Years_Work_Experience__c == false){
                   return false;                              
               }*/
               
               if( EducationInfo.Id != null && 
                  ((educationInfo.Graduation_date__c != null && applicantInfo.Engagement_Start__c!=null && (educationInfo.Graduation_Date__c.daysBetween(applicantInfo.Engagement_Start__c) > 365)) || 
                   (educationInfo.Institution_Type__c!=null && educationInfo.Institution_Type__c.equals('High/Secondary School')))  && 
                  ((applicantInfo.One_Year_Work_Experience__c == false && applicantInfo.Five_Years_Work_Experience__c == false) || (applicantInfo.Five_Years_Work_Experience__c == false && educationInfo.Institution_Type__c!=null && educationInfo.Institution_Type__c.equals('High/Secondary School'))) ) 
                {
                   return false;
                }
               
               
               
               // Premium - Independent - Intrax offers Services?                
               //map<String, Lead_Routing__c> igi_lr_map = Lead_Routing__c.getall();
               list<LeadRouting__c> igi_lr_map = new list<LeadRouting__c>();
               igi_lr_map = [select Id, Name, Country_of_Interest__c, Country_of_Origin__c, Intrax_Program__c, Intrax_Program_Option__c, Lead_Type__c, Partner_Intrax_Id__c, Priority__c, Program__c, Queue__c, Routing_Group__c from LeadRouting__c where NewRule__c = false];
               boolean not_serviced = false;
               //for(Lead_Routing__c lr : igi_lr_map.values()){   
               for(LeadRouting__c lr : igi_lr_map){           
                   // Here we are talking...
                   if(applicantInfo.Country_of_Interest__c == 'United States' && applicantInfo.Service_Level__c == 'Premium'){
                       if(lr.Program__c == 'Internship'){                  
                           if(lr.Country_of_Origin__c == personInfo.Country_of_Residence__c && (lr.Country_of_Interest__c == 'United States' || lr.Country_of_Interest__c == '')){
                               if(lr.Queue__c == 'Not Serviced') {
                                   return false;
                               }
                           }
                       }
                   } else if(applicantInfo.Country_of_Interest__c == 'United States' && applicantInfo.Service_Level__c == 'Premium'){
                       if(lr.Program__c == 'Internship - J1'){                 
                           if(lr.Country_of_Origin__c == personInfo.Country_of_Residence__c && (lr.Country_of_Interest__c == 'United States' || lr.Country_of_Interest__c == '')){
                               if(lr.Queue__c == 'Not Serviced') {
                                   return false;
                               }
                           }
                       }
                   } else if(applicantInfo.Country_of_Interest__c != 'United States'){
                       if(lr.Country_of_Origin__c == personInfo.Country_of_Residence__c && (lr.Country_of_Interest__c == applicantInfo.Country_of_Interest__c || lr.Country_of_Interest__c == '')){
                           if(lr.Queue__c == 'Not Serviced'){ 
                               return false;
                           }
                       }
                   }
                   
               }            
               
           }
        return true;
    }
    
    
    /*END IGI App 2.0 code*/
    
    public void saveExperience() {
        System.debug('######## Enter in the method for Experience');
        //try{
        experience.Applicant_Info__c = applicantInfo.Id;
        
        if(applicantInfo.Intrax_Program__c =='AuPairCare'){
            
            if(experience.Employer_Name__c != null){
                experience.Name = experience.Employer_Name__c;
            }else{
                experience.Name = experience.First_Name__c + ' ' + experience.Last_Name__c;
            }
            
        }else{
            experience.Name = 'Experience' + ' ' + experience.Employer_Name__c;
        }
        
        if (isExperienced!= null && isExperienced){ 
            
            integer days;
            decimal auxdays;
            
            
            // We calculate 7 days per week
            days = experience.Start_Date__c.daysBetween(experience.End_Date__c);
            
            system.debug('*****@@@days:' + days);
            // checking if Age is not between 13 and 14
            if(applicantinfo.Intrax_Program__c == 'AuPairCare' && !Test.isRunningTest()){
                
                if(applicantinfo.Date_of_Birth__c.daysBetween(experience.Start_Date__c)/365.2425 >= 12.999 &&
                   applicantinfo.Date_of_Birth__c.daysBetween(experience.Start_Date__c)/365.2425 < 14){
                       experience.Amount_Hours__c = 0;
                       system.debug('*****@@@This experience is between 13 and 14, so CC hours dont count//Amount_Hours__c = 0 ');
                   }else if(experience.Frequency__c == 'One time'){
                       
                       experience.Amount_Hours__c = experience.Employment_Hrs__c;
                       
                   }else if (experience.Frequency__c == 'Daily'){
                       
                       if(days<6){
                           experience.Amount_Hours__c = experience.Employment_Hrs__c * days;
                       }else{
                           
                           auxdays = days/7.0;
                           if(auxdays<1.0){
                               auxdays = 1;
                           } 
                           experience.Amount_Hours__c = auxdays * 5 * experience.Employment_Hrs__c;
                       }
                       //experience.Amount_Hours__c = (days/7) * 5 * Employment_Hrs__c;
                       //experience.Amount_Hours__c = experience.Employment_Hrs__c * days;
                       
                   }else if (experience.Frequency__c == 'Weekly'){
                       
                       auxdays = days/7.0;
                       //auxdays = days/5;
                       
                       system.debug('*****@@@auxdays:' + auxdays);
                       
                       if(auxdays<1.0){	
                           auxdays = 1;
                       } 
                       
                       experience.Amount_Hours__c = experience.Employment_Hrs__c * auxdays;
                       
                       system.debug('*****@@@experience.Employment_Hrs__c:' + experience.Employment_Hrs__c);
                       system.debug('*****@@@experience.Amount_Hours__c:' + experience.Amount_Hours__c);
                       
                   }else if (experience.Frequency__c == 'Monthly'){ 
                       
                       auxdays = days/30.0;
                       //auxdays = days/20;
                       
                       if(auxdays<1.0){
                           auxdays = 1;
                       } 
                       experience.Amount_Hours__c = experience.Employment_Hrs__c * auxdays ;
                   }
                
                if(experience.Amount_Hours__c!=null)
                    experience.Amount_Hours__c = experience.Amount_Hours__c.intValue();
            }
            
            if(!Test.isRunningTest() && experience.Under_2_Percentage__c !=null && experience.Amount_Hours__c != null &&
               (experience.Children_Ages__c.contains('0 - 1') || experience.Children_Ages__c.contains('1 - 2')) ){
                   
                   if(experience.Under_2_Percentage__c == '0%'){
                       experience.Amount_Hours_Under_2__c=0;           
                   }else if(experience.Under_2_Percentage__c == '10%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.1;           
                   }else if(experience.Under_2_Percentage__c == '20%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.2;           
                   }else if(experience.Under_2_Percentage__c == '30%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.3;           
                   }else if(experience.Under_2_Percentage__c == '40%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.4;           
                   }else if(experience.Under_2_Percentage__c == '50%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.5;           
                   }else if(experience.Under_2_Percentage__c == '60%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.6;           
                   }else if(experience.Under_2_Percentage__c == '70%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.7;           
                   }else if(experience.Under_2_Percentage__c == '80%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.8;           
                   }else if(experience.Under_2_Percentage__c == '90%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 0.9;           
                   }else if(experience.Under_2_Percentage__c == '100%'){
                       experience.Amount_Hours_Under_2__c= experience.Amount_Hours__c * 1;         
                   }
               }else{
                   experience.Amount_Hours_Under_2__c=0;
               }
            
            experience.IsExperienced__c =  true;
        }
        
        if (experience.Experience_Type__c == 'Babysitting' || experience.Experience_Type__c == 'Nanny' || experience.Experience_Type__c == 'Au Pair'
            || experience.Experience_Type__c == 'Sibling/Family'){
                
                experience.Experience_Category__c= 'Private/Individual' ;   
                
            }else if(experience.Experience_Type__c == 'Daycare' || experience.Experience_Type__c == 'Camp' || experience.Experience_Type__c == 'Preschool/Kindergarten'
                     || experience.Experience_Type__c == 'Teaching/Tutoring' || experience.Experience_Type__c == 'Coaching' || experience.Experience_Type__c == 'Church' || experience.Experience_Type__c == 'Orphanage'){
                         
                         experience.Experience_Category__c= 'Public/Group' ;
                         
                     }
        
        experience.Reference_Contact_Requested__c = 'Yes';
        
        
        if (experience.IsReference__c == true) experience.Reference_Contact_Requested__c = 'Yes';
        if (isWorkExperienced!= null && isWorkExperienced) experience.Experience_Type__c =  'Work';
        if (experience.Experience_Type__c == 'Sibling/Family') experience.IsReference__c = false;
        upsert experience;
        
        //Maping Experience to Refence record if It is a Reference
        system.debug('@@@@@ experience.IsReference__c:' + experience.IsReference__c);
        if (experience.IsReference__c == true){
            MapPersonToReferenceAPC.MapExperienceToRef(experience.Id);
        }
        
        //}catch(Exception e){
        //  system.debug(' ******** No location records for this applicant.');
        //}
    }
    
    public void savePositionInfo() {
        System.debug('######## Enter in the method for Position Info');
        try{
            if(positionInfo.Applicant_Info__c == NULL )
                system.debug('******* ApplicantInfo.Id Before: ' + applicantInfo.Id);
            positionInfo.Applicant_Info__c = applicantInfo.Id;
            system.debug('******* ApplicantInfo.Id After: ' + positionInfo.Applicant_Info__c);
            positionInfo.Name = 'Position Info ' + applicantInfo.Name;
            if (applicantInfo.Intrax_Program__c == 'Internship' )
            {
                positionInfo.Placement_Number__c=1;
                positionInfo.Start_Date__c=applicantinfo.Engagement_Start__c;
                positionInfo.End_Date__c=applicantinfo.Engagement_End__c;
            }
            upsert positionInfo;
            
        }catch(Exception e){
            system.debug(' ******** No location records for this applicant.');
        }
    }
    
    
    public void savePositionInfoSecond() {
        System.debug('######## Enter in the method for Second Position Info');
        try{
            if(positionInfoSecond.Applicant_Info__c == NULL )
                system.debug('******* ApplicantInfo.Id Before: ' + applicantInfo.Id);
            positionInfoSecond.Applicant_Info__c = applicantInfo.Id;
            system.debug('******* ApplicantInfo.Id After: ' + positionInfoSecond.Applicant_Info__c);
            positionInfoSecond.Name = 'Second Position Info ' + applicantInfo.Name;
            positionInfoSecond.Placement_Number__c=2;
            positionInfoSecond.End_Date__c=applicantinfo.Engagement_End__c;
            positionInfo.End_Date__c=positionInfoSecond.Start_Date__c;
            upsert positionInfoSecond;
            update positionInfo;
            
        }catch(Exception e){
            system.debug(' ******** No second location records for this applicant.');
        }
    }
    
    
    public void deleteAllowCloning(){
        try{
            list<Applicant_Info__c> applications = [SELECT Id, createdbyId, application_stage__c, SYS_allow_cloning__c FROM Applicant_Info__c
                                                    WHERE CreatedById =: userInfo.getUserId()];
            system.debug('********** Number of apps this belong to the current user: ' + applications.size());
            
            for(Applicant_Info__c a : applications){
                a.SYS_Allow_Cloning__c = false;
            }
            
            update applications;
        }catch(Exception e){
            system.debug('****** Impossible to update SYS_Allow_Cloning: ' + e);
        }
    }
    
    //Save Application
    public PageReference saveApplication(String appType) {
        try {
            
            system.debug('*****### Into saveApplication()');
            system.debug('*****### appType: ' + appType);
            
            
            User u = [SELECT Id, ContactId, Type__c, Intrax_Id__c FROM User WHERE Id =: userInfo.getUserId()];
            
            
            system.debug('*****### user.ContactID: ' + u.ContactId );
            
            if (appType == 'TMD'){
                applicantInfo.Intrax_Program_Options__c = 'Tomodachi';
                applicantInfo.Type__c = 'Host Family';
                applicantInfo.Portal_Contact_Id__c = u.ContactId;   
                
            }
            if (appType == 'AyusaPT'){
                applicantInfo.RecordTypeId = constants.AyusaPT_Record_Type_Id;
                applicantInfo.Intrax_Program__c = 'Ayusa';
                if(ApexPages.currentPage().getParameters().get('IPO') == null){
                    applicantInfo.Intrax_Program_Options__c = 'Ayusa High School';
                }
                applicantInfo.Type__c = 'Participant';
                applicantInfo.Application_Level__c = 'Basic';
                applicantInfo.Application_Stage__c = 'Working';
                applicantInfo.Portal_Contact_Id__c = u.ContactId; 
                basics(userInfo.getFirstName() + ' ' + userInfo.getLastName());
            }
            if (appType == 'AyusaHF'){                   
                applicantInfo.RecordTypeId = constants.AyusaHF_Record_Type_Id;
                applicantInfo.Intrax_Program__c = 'Ayusa';
                if(ApexPages.currentPage().getParameters().get('IPO') == null){
                    applicantInfo.Intrax_Program_Options__c = 'Ayusa High School';
                }
                applicantInfo.Type__c = 'Host Family';
                applicantInfo.Application_Level__c = 'Main';
                applicantInfo.Application_Stage__c = 'Working'; 
                applicantInfo.Portal_Contact_Id__c = u.ContactId;                    
                basics(userInfo.getFirstName() + ' ' + userInfo.getLastName());
                deleteAllowCloning();
            }
            if (appType == 'APCHF'){                   
                system.debug('*****###into HF Aupair Condition to save the app');
                applicantInfo.RecordTypeId = constants.AuPairCareHF_Record_Type_Id; 
                applicantInfo.Intrax_Program__c = 'AuPairCare';
                
                if(ApexPages.currentPage().getParameters().get('IPO') == null){
                    //applicantInfo.Intrax_Program_Options__c = 'Ayusa High School';
                }
                
                applicantInfo.Type__c = 'Host Family';
                applicantInfo.Application_Level__c = 'Basic';
                //selecting the pages for review in "Main" Stage
                //applicantInfo.PageStatus_Started__c = '04;05;07'; 
                applicantInfo.Application_Stage__c = 'Working';
                applicantInfo.Home_Country__c = 'United States';
                applicantInfo.Intrax_region__c = 'United States'; 
                applicantInfo.Portal_Contact_Id__c = u.ContactId;                    
                system.debug('*****###applicantInfo.id - before basics: ' + applicantInfo.id );
                basics(userInfo.getFirstName() + ' ' + userInfo.getLastName());
                system.debug('*****###applicantInfo.id - after: ' + applicantInfo.id );
                deleteAllowCloning();
            }
            if (appType == 'APCPT'){
                
                if(ApexPages.currentPage().getParameters().get('partnerId') != null)
                {
                    applicantInfo.Partner_Intrax_Id__c = ApexPages.currentPage().getParameters().get('partnerId');
                }
                
                system.debug('*****###into PT Aupair Condition to save the app');
                applicantInfo.RecordTypeId = constants.AuPairCarePT_Record_Type_Id;
                applicantInfo.Intrax_Program__c = 'AuPairCare';
                //applicantInfo.Intrax_Program_Options__c = 'Infant Specialized'; //B-03197
                if(ApexPages.currentPage().getParameters().get('IPO') == null){
                    //applicantInfo.Intrax_Program_Options__c = 'Ayusa High School';
                }
                applicantInfo.Type__c = 'Participant';
                applicantInfo.Application_Level__c = 'Basic';
                applicantInfo.Application_Stage__c = 'Working';
                applicantInfo.Language_1_Proficiency__c = 'Native/Fluent';
                
                //applicantInfo.Language_spoken_years_1__c = 'native';
                //applicantInfo.PageStatus_Started__c = '17;18;19;20;21;24;25;26;27;28'; 
                //applicantInfo.Home_Country__c = 'United States'; 
                applicantInfo.Portal_Contact_Id__c = u.ContactId;                    
                system.debug('*****###applicantInfo.id - before basics: ' + applicantInfo.id );
                basics(userInfo.getFirstName() + ' ' + userInfo.getLastName());
                system.debug('*****###applicantInfo.id - after: ' + applicantInfo.id );
                deleteAllowCloning();
            }
            
            
            
            if (appType == 'Centers'){                   
                applicantInfo.RecordTypeId = constants.Centers_Record_Type_Id;
                applicantInfo.Intrax_Program__c = 'English and Professional Skills';
                //applicantInfo.Intrax_Program_Options__c = 'English and Professional Skill';
                applicantInfo.Type__c = 'Participant';
                applicantInfo.Application_Level__c = 'Basic';
                applicantInfo.Application_Stage__c = 'Working';   
                applicantInfo.Portal_Contact_Id__c = u.ContactId;                    
                basics(userInfo.getFirstName() + ' ' + userInfo.getLastName());
            }
            
            if (appType == 'IGI'){ 
                
                if(ApexPages.currentPage().getParameters().get('partnerId') != null){
                    applicantInfo.Partner_Intrax_Id__c = ApexPages.currentPage().getParameters().get('partnerId');
                }
                
                if(ApexPages.currentPage().getParameters().get('UniversityId') != null){
                    try{
                        list<Account> UniversityAcctInfo = [SELECT Id, Name, Intrax_Id__c, Intrax_Programs__c, type, Intrax_Region__c FROM Account WHERE  Intrax_Id__c =: ApexPages.currentPage().getParameters().get('UniversityId') and type = 'Institution'];
                        
                        if (UniversityAcctInfo != NULL && UniversityAcctInfo.size() > 0){
                            applicantInfo.School_Id__c = UniversityAcctInfo[0].id; 
                            // D-01355 -- Setting Intrax region Based on School's business Intrax Region value
                            applicantInfo.Intrax_Region__c = UniversityAcctInfo[0].Intrax_Region__c;                                                      
                        }
                        system.debug('****** Group ID: '+ ApexPages.currentPage().getParameters().get('groupApp'));
                        if(ApexPages.currentPage().getParameters().get('groupApp') != null){
                            applicantInfo.Group__c = ApexPages.currentPage().getParameters().get('groupApp');
                        }
                    }catch(Exception e){
                        system.debug('**** Impossible to save University Id to related applicant');
                    }
                }     
                
                applicantInfo.RecordTypeId = constants.ICD_Intern_PT_Record_Type_Id;
                applicantInfo.Intrax_Program__c = 'Internship';
                applicantInfo.Type__c = 'Participant';
                applicantInfo.Portal_Contact_Id__c = u.ContactId;
                if(u.Type__c == 'Partner') applicantInfo.Partner_Intrax_Id__c = u.Intrax_Id__c;     
                
                if(ApexPages.currentpage().getParameters().get('groupApp') != null){
                    Group__c gr = [SELECT Id, Engagement_Start__c, Engagement_End__c, Country__c, Location__c, Functional_Areas__c, Intrax_Program_Category__c, Intrax_Program__c, Intrax_Program_Option__c FROM Group__c WHERE Id =: ApexPages.currentpage().getParameters().get('groupApp')];
                    applicantInfo.First_Name__c = personInfo.First_Name__c;
                    applicantInfo.Last_Name__c = personInfo.Last_Name__c;
                    applicantInfo.Functional_Areas__c = gr.Functional_Areas__c;
                    ApplicantInfo.Intrax_Program_Category__c = gr.Intrax_Program_Category__c;
                    applicantInfo.Email__c = personInfo.Email__c;
                    applicantInfo.Intrax_program_Options__c = gr.Intrax_Program_Option__c;
                    applicantInfo.Engagement_Start__c = gr.Engagement_Start__c;
                    applicantInfo.Engagement_End__c = gr.Engagement_End__c;
                    applicantInfo.Country_of_Interest__c = gr.Country__c;
                    applicantInfo.Location_of_Interest__c = gr.Location__c;
                    applicantInfo.Group__c = ApexPages.currentpage().getParameters().get('groupApp');
                    applicantInfo.Application_Level__c = 'Main';
                    applicantInfo.Application_Stage__c = 'Submitted'; 
                    basics(personInfo.First_Name__c + ' ' + personInfo.Last_Name__c);
                }else{
                    applicantInfo.Application_Level__c = 'Basic';
                    applicantInfo.Application_Stage__c = 'Working'; 
                    applicantInfo.RecordTypeId = constants.ICD_Intern_PT_Record_Type_Id;
                    applicantInfo.Intrax_Program__c = 'Internship';
                    applicantInfo.Type__c = 'Participant';
                    basics(userInfo.getFirstName() + ' ' + userInfo.getLastName()); 
                }                   
            }
            if(appType == 'WT'){                                   
                applicantInfo.RecordTypeId = constants.WT_PT_Record_Type_Id;
                applicantInfo.Intrax_Program__c = 'Work Travel';
                //applicantInfo.Intrax_Program_Options__c = 'English and Professional Skill';
                applicantInfo.Type__c = 'Participant';
                // Initial Status should be Main as per IGI 401
                applicantInfo.Application_Level__c = 'Main';
                applicantInfo.Application_Stage__c = 'Working'; 
                applicantInfo.Language_1__c  = 'English';
                applicantInfo.Primary_Activity__c = 'University Student'; 
                applicantInfo.Portal_Contact_Id__c = u.ContactId; 
                if(u.Type__c == 'Partner') applicantInfo.Partner_Intrax_Id__c = u.Intrax_Id__c;                   
                basics(userInfo.getFirstName() + ' ' + userInfo.getLastName());
            }
            String appname;
            
            if(applicantInfo.Name!=null){
                
                appname=applicantInfo.Name;
                
            }
            
            if((applicantInfo.Engagement_Start__c !=null || applicantInfo.Program_Year__c != null) && applicantInfo.RecordType.Name != 'Centers' && applicantInfo.RecordType.Name != 'ICD Intern PT' && applicantInfo.RecordType.Name != 'PW Participant' && applicantInfo.RecordType.Name != 'Ayusa PT')
                
            { 
                if(applicantInfo.RecordType.Name == 'Work Travel PT')
                    
                {                  
                    if(applicantInfo.Name.contains('-WT'))
                        
                    { 
                        applicantInfo.Name = appname.substringBefore('-WT');
                        
                    }
                    Integer adYear = applicantInfo.Engagement_Start__c.year();
                    adYear = adYear+1;
                    applicantInfo.Name = applicantInfo.Name +'-WT'+adYear;
                    
                    
                }
                
                else{
                    if(applicantInfo.Name.contains('-AY'))
                        
                    { 
                        applicantInfo.Name = appname.substringBefore('-AY');
                        
                    }
                    //EU 107
                    if(applicantInfo.RecordType.Name == 'Ayusa HF')
                    {
                        Integer adYear = applicantInfo.Engagement_Start__c.year();
                        adYear = adYear+1;
                        applicantInfo.Name = applicantInfo.Name +'-AY'+adYear;
                    }
                }
            } 
            else if(applicantInfo.RecordType.Name == 'Ayusa PT')
            {
                system.debug('*************Line- 4499***'+ applicantInfo.RecordType.Name);
                if(applicantInfo.Name.contains('-AY'))
                    
                { 
                    applicantInfo.Name = appname.substringBefore('-AY');
                    
                }
                if(applicantInfo.Program_Year__c!= null){
                    String[] proYearSplit = applicantInfo.Program_Year__c.split('-');
                    String adYear = proYearSplit[1];
                    applicantInfo.Name = applicantInfo.Name +'-AY'+adYear;
                }
            }
            
            
            
        }catch(Exception e) {
            
            ApexPages.addMessages(e);
        }
        
        return null;
    }          
    
    // Doc Upload  
    public PageReference load(){
        
        // Instantiate a new http object 
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
        
        
        if (ApexPages.currentPage().getParameters().get('docGuid').contains('.intraxinc.com') || ApexPages.currentPage().getParameters().get('docGuid').contains('fliqz.com')){
            loadDoc = [Select Document_service__c,Name,Document_GUID__c from Intrax_Program_Upload__c where document_Guid__c = :EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('docGuid'),'UTF-8') ];
            return new PageReference(loadDoc.Document_GUID__c);
        }
        else{
            loadDoc = [Select Document_service__c,Name,Document_GUID__c from Intrax_Program_Upload__c where document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];           
        }

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
        else if(loadDoc.Document_service__c == 'VS'){
            req.setEndpoint(Constants.videoService+'GetVideoSignedUrl');
        }
        else{
            system.debug('debug::Inside ImageService='+loadDoc.Document_service__c);
            req.setEndpoint(Constants.imageService+'GetFile');
        }
        body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';
        
        If(loadDoc.Document_service__c=='VS'){
            body = body + ApexPages.currentPage().getParameters().get('docGuid') +'&protocol=rtmp';
        }
        else{
            body = body + ApexPages.currentPage().getParameters().get('docGuid');
        }
        system.debug('debug::RequestBody'+body);
        req.setBody(body);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
        Dom.Document docRes = new Dom.Document();
        String returnurl = null;
        if (!isTestMode){
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
                if (loadDoc.Document_service__c == 'VS' && node.getName() == 'signedUrl'){
                    system.debug('debug::VS==node.Name=='+node.getName());
                    returnurl = node.getText();
                    //spillai video changes
                    rtmpUrlVideo = returnurl;
                    PageReference videoPage = Page.playVideo;
                    //return videoPage ;
                    return null;
                }
                
                if(node.getName() == 'error'){
                    customMessage=true;
                    string error= node.getText();
                    If(error.contains('is not found')){
                        
                        If(Site.getBaseUrl() != null && Site.getBaseUrl().contains('force.com')){
                            pageReference p = new pageReference('/apex/SiteDocViewer?id=' + applicantInfo.Id+'&docGuid='+loadDoc.Document_GUID__c);
                            p.setRedirect(true);
                            return p;   
                        }
                        
                        else{
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
            return new PageReference('testurl');
        }
        
    }
    
    public void setTestMode(){
        isTestMode = true;
    }
    
    // Doc Upload  
    public PageReference deletefile(){
        
        // Instantiate a new http object 
        //Http h = new Http();
        //HttpResponse res = new HttpResponse();
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
        
        system.debug('*****@@@docGuid (parameter): '+ ApexPages.currentPage().getParameters().get('docGuid'));
        system.debug('*****@@@docGuid (varible): '+ docGuid);
        
        if(docGuid != null){
            
            loadDoc = [Select Document_service__c,id,Delete_Pending__c from Intrax_Program_Upload__c where document_Guid__c = : docGuid ];  
            
        }else if(ApexPages.currentPage().getParameters().get('docGuid') != null){
            
            loadDoc = [Select Document_service__c,id,Delete_Pending__c from Intrax_Program_Upload__c where document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];
            
        }
        
        //B-01590. If condition added
        if(loadDoc != null){
            system.debug('*****@@@Delete_Pending__c): '+ loaddoc.Delete_Pending__c);
            loaddoc.Delete_Pending__c=true;
            update loaddoc;
            /* 
// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
HttpRequest req = new HttpRequest();
req.setMethod('POST'); 
//AA Fixed Delete File functionality.
req.setHeader('Accept', 'application/xml');
req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
String body = '';
if (loadDoc.Document_service__c == 'DS'){
req.setEndpoint(Constants.documentService+'Remove');
}
else{
req.setEndpoint(Constants.imageService+'Remove');
}
body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';    
if(docGuid != null){
body = body + docGuid;
}
else{
body = body + ApexPages.currentPage().getParameters().get('docGuid');
}
//body = body + ApexPages.currentPage().getParameters().get('docGuid');
req.setBody(body);
system.debug('debug::Request='+ req);
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
Dom.Document docRes = new Dom.Document();
string returnurl = null;
if (!isTestMode){
res = h.send(req);
system.debug('****Res****'+ res);
responseXML = res.getBody();
system.debug('****responseXML****'+ responseXML);
docRes.load(responseXML);
system.debug('****DocList***'+getDocList());
/* Comment the following for removing Sharing (AYII-136) 
loaddoc.Delete_Pending__c=true;
update loaddoc;
/* Uncomment the following for removing Sharing (AYII-136
// delete loaddoc;
// getDocList();
/* #AYII-136  
List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
for (dom.XmlNode node : resnodelist){
if ( node.getName() == 'result'){
returnurl = node.getText();
system.debug('debug::returnurl='+returnurl);


}
}
}*/
            
            //Code to pass the parameter "docType=Lifeguard" to the URL when we remove a file in "apc_ap_main_swimming_experience". 
            if(swimParam == 'true'){
                pageReference p = new pageReference('/apex/apc_ap_main_swimming_experience?id=' + applicantInfo.Id + '&docType=Lifeguard');
                p.setRedirect(true);
                return p;
            }else if(phyParam == 'true'){
                pageReference p = new pageReference('/apex/apc_ap_main_physician_form?id=' + applicantInfo.Id + '&docType=Health');
                p.setRedirect(true);
                return p;
            }else if(bgcParam == 'true'){
                pageReference p = new pageReference('/apex/apc_ap_main_bgc_form?id=' + applicantInfo.Id + '&docType=BackgroundCheck');
                p.setRedirect(true);
                return p;
            }else if(driveParam == 'true'){
                pageReference p = new pageReference('/apex/apc_ap_main_driving_experience?id=' + applicantInfo.Id + '&docType=Drivers-License');
                p.setRedirect(true);
                return p;
            }else if(Proofparam == 'true'){
                pageReference p = new pageReference('/apex/apc_ap_main_education_proof?id=' + applicantInfo.Id + '&docType=Proof-of-Education');
                p.setRedirect(true);
                return p;
            }else if(igiMediaParam == 'true'){
                pageReference p = new pageReference('/apex/igi_pt_app_media?id=' + applicantInfo.Id + '&docType=Participant-Photo');
                p.setRedirect(true);
                return p;
            }else if(igiDocsParam == 'true'){
                pageReference p = new pageReference('/apex/igi_pt_app_documents?id=' + applicantInfo.Id + '&docType=igi-documents');
                p.setRedirect(true);
                return p;
            }else if(igiDepsParam == 'true'){
                pageReference p = new pageReference('/apex/igi_pt_app_dependents?id=' + applicantInfo.Id + '&docType=igi-dependentdocs');
                p.setRedirect(true);
                return p;
            }else if(mediaparam == 'true'){
                pageReference p = new pageReference('/apex/apc_ap_main_media?id=' + applicantInfo.Id + '&docType=Participant-Photo');
                p.setRedirect(true);
                return p;
            }else if(apchf_mediaparam == 'true'){
                pageReference p = new pageReference('/apex/apc_hf_app_media?id=' + applicantInfo.Id + '&docType=Participant-Photo');
                p.setRedirect(true);
                return p;
            }else if(Transcriptsparam == 'true'){
                pageReference p = new pageReference('/apex/apc_ap_main_training?id=' + applicantInfo.Id + '&docType=Transcripts');
                p.setRedirect(true);
                return p;
            }else if(Passportparam == 'true'){
                pageReference p = new pageReference('/apc_ap_main_visa_info?id=' + applicantInfo.Id + '&docType=Passport');
                p.setRedirect(true);
                return p;
            }else if(Videoparam == 'true'){
                system.debug('@@@@@inside Videoparam');
                system.debug('@@@@@applicantInfo.Id: ' + applicantInfo.Id);
                
                pageReference p = new pageReference('/apc_ap_main_video?id=' + applicantInfo.Id + '&docType=Introductory-Video');
                p.setRedirect(true);
                system.debug('@@@@@p: ' + p);
                return p;
            }
            else{
                return  null;
            }
            
        }
        return null;
        //return new PageReference(returnurl);                  
    }      
    
    
    public PageReference deletevideo(){
        
        String docGuidAux = '';
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
        list<Intrax_Program_Upload__c> loadDocVideo = new list<Intrax_Program_Upload__c>();
        list<Intrax_Program_Upload__c> loadDocVideoAux = new list<Intrax_Program_Upload__c>();
        
        system.debug('*****@@@docGuid (parameter): '+ ApexPages.currentPage().getParameters().get('docGuid'));
        system.debug('*****@@@docGuid (varible): '+ docGuid);
        
        if(docGuid != null){
            
            loadDoc = [Select Parent_Intrax_Program_Upload__c, Document_service__c,id, AWS_ET_Job_Status__c, Delete_Pending__c,document_Guid__c, Applicant_Info__c,Name from Intrax_Program_Upload__c where document_Guid__c = : docGuid ];  
            
        }else{
            
            loadDoc = [Select Parent_Intrax_Program_Upload__c, Document_service__c, AWS_ET_Job_Status__c, id,Delete_Pending__c,document_Guid__c, Applicant_Info__c,Name from Intrax_Program_Upload__c where document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];
            
        }
        
        if(docGuid.contains('Generic720P')){
            
            loadDocVideo = [Select Parent_Intrax_Program_Upload__c, Document_service__c,Document_GUID__c, id, AWS_ET_Job_Status__c, Delete_Pending__c, Applicant_Info__c,Name from Intrax_Program_Upload__c 
                            where Parent_Intrax_Program_Upload__c != null AND Parent_Intrax_Program_Upload__c= : loadDoc.Parent_Intrax_Program_Upload__c ];  
        }
        String documentGUIDS = '';
        system.debug('*****@@@loadDocVideo: '+ loadDocVideo.size());
        if(loadDocVideo != null && loadDocVideo.size()>0){
            for(Intrax_Program_Upload__c ipu:loadDocVideo){
                ipu.Delete_Pending__c= true;
                docGuid=ipu.Document_GUID__c;
                //docGuidAux = docGuidAux + DocGuid + ','; 
                documentGUIDS = documentGUIDS+'&documentGUID=' + docGuid;
                loadDocVideoAux.add(ipu);
                system.debug('*****@@@@@ipu.id:' + ipu.id);
                //system.debug('*****@@@@@docGuidAux:' + docGuidAux);
                
            }
        }
        
        //docGuidAux = docGuidAux.removeEnd(',');
        //system.debug('@@@@@docGuidAux after remove ",":' + docGuidAux);
        //IPUTriggerHelper.deleteVideoUpload(docGuidAux);
        system.debug('@@@@@documentGUIDS after remove ",":' + documentGUIDS);
        
        Http h = new Http();
        String responseXML;
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST'); 
        req.setHeader('Accept', 'application/xml');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
        String body = '';
        body = 'authToken='+Constants.serviceAuthToken+documentGUIDS;
        
        /*if(!docGuidAux.contains(',')){
req.setEndpoint(Constants.videoService+'Remove');
}else{*/
        
        req.setEndpoint(Constants.videoService+'RemoveTranscodedVideos');
        
        
        body = body + docGuidAux;
        system.debug('******Inside body**********'+body);
        req.setBody(body);
        system.debug('******req.getBody()**********'+req.getBody());
        Dom.Document docRes = new Dom.Document();
        string returnurl = null;
        res = h.send(req);
        
        system.debug('****Res****'+ res);
        responseXML = res.getBody();
        system.debug('****responseXML****'+ responseXML);
        docRes.load(responseXML);
        
        system.debug('*****@@@@@loadDocVideoAux:' + loadDocVideoAux);
        update loadDocVideoAux;
        
        List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
        
        for (dom.XmlNode node : resnodelist){
            if ( node.getName() == 'result'){
                returnurl = node.getText(); 
            }
        }      
        
        
        //Code to pass the parameter "docType=Lifeguard" to the URL when we remove a file in "apc_ap_main_swimming_experience". 
        if(Videoparam == 'true'){
            system.debug('@@@@@inside Videoparam');
            system.debug('@@@@@applicantInfo.Id: ' + applicantInfo.Id);
            
            //pageReference p = new pageReference('apc_ap_main_video?id=' + applicantInfo.Id + '&docType=Introductory-Video');
            pageReference p = new pageReference('/apex/apc_ap_main_video?id=' + applicantInfo.Id + '&docType=Introductory-Video');
            
            p.setRedirect(true);
            system.debug('@@@@@p: ' + p);
            return p;
        }
        else{
            return  null;
        }
        
        //return new PageReference(returnurl);                  
    } 
    // Setting communication fields depending on type of communication invoked. 
    public void DefaultCommunicationInfo()
    {
        string derivedUrl;
        string partialUrl;
        
        if(comType == 'ETR')
        {
            communicationInfo.Type_Code__c='ETR';           
            partialUrl='/AyusaTeacherRec?id='+applicantInfo.Id;
            derivedUrl= Constants.derivedbaseUrl + partialUrl ; 
        }
        
        else if(comType == 'SOR')
        {
            communicationInfo.Type_Code__c='SOR';        
            partialUrl='/AyusaStudentRec?id='+applicantInfo.Id;
            derivedUrl= Constants.derivedbaseUrl + partialUrl ; 
        }
        communicationInfo.Type__c='Request';        
        communicationInfo.Method__c='Email';
        communicationInfo.Intrax_Program__c = 'Ayusa';
        
        comPersonInfoList = [select p.First_Name__c,p.Last_Name__c,p.Email__c,p.Role__c,p.Family_Member__c From Person_Info__c p Where p.Primary_Applicant__c =: true  AND p.Applicant_Info__c =: applicantInfo.Id limit 1];
        if(comPersonInfoList.size() != 0)
        {
            strPersonInfoFirstName=comPersonInfoList[0].First_Name__c;
            strPersonInfoLastName=comPersonInfoList[0].Last_Name__c;
            strPersonInfoEmail= comPersonInfoList[0].Email__c;
        }
        communicationInfo.From_Address__c=strPersonInfoEmail;
        communicationInfo.Sender_First_Name__c=strPersonInfoFirstName;
        communicationInfo.Sender_Last_Name__c=strPersonInfoLastName;        
        communicationInfo.Applicant_Info__c = applicantInfo.Id;                          
        communicationInfo.Action_URL__c = derivedUrl;         
        
        upsert communicationInfo;  
    }
    
    //** Defined to get the IPO as a list    
    public string ipo_options;
    // This method returns picklist values for Recipient Title   
    
    public String getipo_options() {
        return applicantinfo.Intrax_Program_Options__c;
    }
    
    public void setipo_options(String ipo_options) {
        applicantInfo.Intrax_Program_Options__c = ipo_options;
    }
    
    // This method returns picklist values for applicant_info__c.Intrax_Program_Options__c   
    public List<SelectOption> getProgramOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Business Internship','Business Internship'));
        options.add(new SelectOption('Hospitality Internship','Hospitality Intership'));
        options.add(new SelectOption('ProWorld Internship','ProWorld Internship'));
        options.add(new SelectOption('WEST','WEST'));
        options.add(new SelectOption('Practical Training','Practical Training'));
        return options;
        /*
// Variable Declaration -------------------------------------
List<SelectOption> lstipo = new List<SelectOption>();
Schema.Describefieldresult titleField;
List<Schema.Picklistentry> picklistValues;

// Get Picklist values
titleField = Applicant_Info__c.Intrax_Program_Options__c.getDescribe();
picklistValues = titleField.getPicklistValues();

// Add Default value
lstipo.add(new Selectoption('','--None--'));

// Loop through retrieved picklist values -------------------
for(Schema.Picklistentry value: picklistValues )
{   
// Add Select Options
lstipo.add(new Selectoption(value.getLabel(), value.getValue()));
}
// ----------------------------------------------------------

return lstipo;      
*/  
    }
    
    // This method returns picklist values for Recipient Title   
    public List<SelectOption> getRecipientTitle()
    {
        // Variable Declaration -------------------------------------
        List<SelectOption> lstRecipientTitles = new List<SelectOption>();
        Schema.Describefieldresult titleField;
        List<Schema.Picklistentry> picklistValues;
        
        // Get Picklist values
        titleField = Communication__c.Recipient_Title__c.getDescribe();
        picklistValues = titleField.getPicklistValues();
        
        // Add Default value
        lstRecipientTitles.add(new Selectoption('','--None--'));
        
        // Loop through retrieved picklist values -------------------
        for(Schema.Picklistentry value: picklistValues )
        {   
            // Add Select Options
            lstRecipientTitles.add(new Selectoption(value.getLabel(), value.getValue()));
        }
        // ----------------------------------------------------------
        
        return lstRecipientTitles;        
    }
    
    
    //AA Languages
    public List<SelectOption> getLanguages1(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Applicant_Info__c.Language_spoken_1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('getLanguages1::Language_spoken_2__c=='+applicantinfo.Language_spoken_2__c+'Language_spoken_3__c=='+applicantinfo.Language_spoken_3__c);      
        for(Schema.PicklistEntry f : ple)
        {
            If(f.getValue()!= applicantinfo.Language_spoken_2__c && f.getValue()!= applicantinfo.Language_spoken_3__c)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getLanguages2(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Applicant_Info__c.Language_spoken_2__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('getLanguages2::Language_spoken_1__c=='+applicantinfo.Language_spoken_1__c+'Language_spoken_3__c=='+applicantinfo.Language_spoken_3__c);     
        for(Schema.PicklistEntry f : ple)
        {
            If(f.getValue()!= applicantinfo.Language_spoken_1__c && f.getValue()!= applicantinfo.Language_spoken_3__c)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getLanguages3(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Applicant_Info__c.Language_spoken_3__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('getLanguages3::Language_spoken_1__c=='+applicantinfo.Language_spoken_1__c+'Language_spoken_2__c=='+applicantinfo.Language_spoken_2__c);
        for(Schema.PicklistEntry f : ple)
        {
            If(f.getValue()!= applicantinfo.Language_spoken_1__c && f.getValue()!= applicantinfo.Language_spoken_2__c)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public pageReference SkipUpload()
    {
        PageReference p;
        if (ApexPages.currentPage().getParameters().get('docType') == 'Health'){
            p =Page.ayusa_app_doc_assessment;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'Transcripts'){
            p =Page.ayusa_app_school_transcripts;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'Agreements'){
            p =Page.ayusa_app_prog_agreements;
        }  
        else if (ApexPages.currentPage().getParameters().get('docType') == 'Partner'){
            p =Page.ayusa_app_partner_detailed_report;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'Media'){
            p =Page.ayusa_app_stu_photos_videos;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'Passport'){
            p =Page.ayusa_app_passport_details;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'Family'){
            p =Page.ayusa_app_fam_photos_videos;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'HostFamily'){
            p =Page.ayusa_hf_photos_videos;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'HFAgreements'){
            p =Page.ayusa_hf_photos_videos;
        }    
        else if (ApexPages.currentPage().getParameters().get('docType') == 'Teacher'){
            p =Page.ayusa_app_reco_list;
        }
        else if (ApexPages.currentPage().getParameters().get('docType') == 'School'){
            p =Page.ayusa_app_reco_list;
        }
        if (ApexPages.currentPage().getParameters().get('docType') == 'Teacher' || ApexPages.currentPage().getParameters().get('docType') == 'School'){
            p.getParameters().put('docType','Academic');
        }
        else{
            P.getParameters().put('docType',ApexPages.currentPage().getParameters().get('docType'));
        }
        P.getParameters().put('id', applicantInfo.Id);
        if(ApexPages.currentPage().getParameters().get('reDirectPage') == 'true'){
            p.setRedirect(true);
        }
        return p;
    }
    public Boolean getIsPartner(){
        User user = [Select Id,  ContactId,Type__c,Intrax_Id__c, Contact.AccountId from User where Id =: UserInfo.getUserId()];
        if(user.Intrax_Id__c!=null && user.Type__c=='Partner')
        {
            IsPartner = true;
        }
        else
        {
            IsPartner = false;
        }   
        return IsPartner;
    }    
    
    public List<SelectOption> getRoleList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Sibling','Sibling'));
        options.add(new SelectOption('Parent','Parent'));
        options.add(new SelectOption('Step Parent','Step Parent'));
        options.add(new SelectOption('Spouse or Partner','Spouse or Partner'));
        options.add(new SelectOption('Child','Child'));
        options.add(new SelectOption('Other','Other'));
        return options;
    }
    
    public String[] getRoles() {
        return roles;
    }
    
    public void setRoles(String[] roles) {
        this.roles = roles;
    }   
    
    public String getUserInterests(){
        system.debug('*****###UserInterests: ' + UserInterests); 
        return UserInterests;        
    } 
    
    //Check if the user has 0 Apps
    public boolean getCheckHFNoAppStatus(){
        boolean showAvailable = false;
        Applicant_Info__c applicantNoApp;
        try{
            // 1. First, check if there are already existing applications. We just need the last application created for the especified type
            applicantNoApp = [SELECT Id, Type__c, Application_Stage__c, CreatedById, CreatedDate 
                              FROM Applicant_Info__c 
                              WHERE CreatedBy__c =: UserInfo.getUserId()
                              AND Type__c =: 'Host Family'
                              order by CreatedDate desc
                              limit 1];
            
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be available.
            showAvailable = true;
            return showAvailable;
        }
        return showAvailable;   
    }
    
    //Check if the user has more than 1 Apps
    public boolean getCheckHFNumberAppStatus(){
        boolean Available = true;
        List<Applicant_Info__c> listApplicantNoApp;
        listApplicantNoApp = [SELECT Id, Type__c, Application_Stage__c, CreatedById, CreatedDate 
                              FROM Applicant_Info__c 
                              WHERE CreatedBy__c =: UserInfo.getUserId()
                              AND Type__c =: 'Host Family'
                              order by CreatedDate desc];
        if(listApplicantNoApp.size() > 1 ){                              
            Available = false;
        }
        return Available;   
    }
    
    // Created to check whether the user can create a new application or not.
    public boolean getCheckHFAppStatus(){
        boolean createAvailable = false;
        Applicant_Info__c applicant;
        try{
            // 1. First, check if there are already existing applications. We just need the last application created for the especified type
            applicant = [SELECT Id, Type__c, Application_Stage__c, CreatedById, CreatedDate 
                         FROM Applicant_Info__c 
                         WHERE CreatedBy__c =: UserInfo.getUserId()
                         AND Type__c =: 'Host Family'
                         AND application_Stage__c =: 'Working'
                         order by CreatedDate desc
                         limit 1];
            
            system.debug('*****###appID: ' + applicant.Id );
            system.debug('*****###appStage: ' + applicant.Application_Stage__c );
            system.debug('*****###createAvailable1: ' + createAvailable);
            
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be available.
            createAvailable = true;
            return createAvailable;
        }   
        // 2. Checking the the app type is correct and the current stage is working.
        if(applicant.Application_Stage__c == 'Working'){        
            // 2.1. Looking for apps that are older than 6 months.
            if(applicant.CreatedDate <(date.today() - 180)){        
                createAvailable = false;
                system.debug('*****###createAvailable2: ' + createAvailable);
            }
        }else{
            createAvailable = true;
            system.debug('*****###createAvailable3: ' + createAvailable);
        }       
        
        system.debug('*****###createAvailable4: ' + createAvailable);
        return createAvailable;             
    }
    
    // Created to check whether the user can create a new Centers application or not.
    public boolean getCheckCentersAppStatus(){
        boolean createAvailable = false;
        Applicant_Info__c applicant;
        try{
            // 1. First, check if there are already existing applications. We just need the last application created for the especified type
            applicant = [SELECT Type__c, Application_Stage__c, Intrax_Program_Options__c, CreatedById, CreatedDate 
                         FROM Applicant_Info__c 
                         WHERE CreatedById =: UserInfo.getUserId()
                         AND Type__c =: 'Participant' AND Intrax_Program__c =: 'English and Professional Skills'
                         order by CreatedDate desc
                         limit 1];
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be available.
            createAvailable = true;
            return createAvailable;
        }           
        // 2. Checking the the app type is correct and the current stage is working.
        if(applicant.Application_Stage__c == 'Working'){              
            // 2.1. Looking for apps that are older than 6 months.
            if(applicant.CreatedDate < (date.today() - 180)){
                createAvailable = true;
            }
        }else{
            createAvailable = true;
        }
        return createAvailable;             
    }
    
    
    public boolean getCheckPTAppStatus(){
        boolean createAvailable = false;
        Applicant_Info__c applicant;
        try{
            //AA IGI-651 add UserInterest check to avoid WT duplicate applications.
            if(UserInterests == 'Becoming a Work Travel Participant'){
                system.debug('debug::For Work Travel '+UserInterests);
                applicant = [SELECT Type__c, Application_Stage__c,CreatedBy__c, CreatedDate, Engagement__r.Status__c, RecordType.Name
                             FROM Applicant_Info__c 
                             WHERE CreatedBy__c =: UserInfo.getUserId()
                             AND Type__c =: 'Participant' 
                             AND(Application_Stage__c = 'Working' Or Application_Stage__c ='Submitted' or Application_Stage__c='In-Review' or Application_Stage__c='Conditional' or Application_Stage__c='Accepted')
                             order by CreatedDate desc
                             limit 1];
            }
            else {
                system.debug('debug::For AYUSA '+UserInterests);
                //AA 571 Added Engagement Status field
                //AA 571 27/3/2014 Changed CreatedById with CreatedBy__c in where claus.(Issue raised during testing)
                // 1. First, check if there are already existing applications. We just need the last application created for the especified type
                applicant = [SELECT Type__c, Application_Stage__c,CreatedBy__c, CreatedDate, Engagement__r.Status__c, RecordType.Name
                             FROM Applicant_Info__c 
                             WHERE CreatedBy__c =: UserInfo.getUserId()
                             AND Type__c =: 'Participant'
                             order by CreatedDate desc
                             limit 1];
            }                 
        }catch(Exception e){
            // 1.1. If we are here, it's because there are no applications yet for the current user. So the crete button should be available.
            createAvailable = true;
            return createAvailable;
        }           
        //AA 571
        // 2. Checking the the app type is correct and the current stage is working.
        system.debug('debug::applicant.Engagement__r.Status__c '+applicant.Engagement__r.Status__c);
        system.debug('debug::applicant.RecordType.Name :'+applicant.RecordType.Name);
        if(applicant.Application_Stage__c == 'Working' || (applicant.RecordType.Name == 'Work Travel PT' && 
                                                           (applicant.Application_Stage__c == 'Submitted' || applicant.Application_Stage__c == 'In-Review'|| applicant.Application_Stage__c == 'Conditional' || applicant.Application_Stage__c == 'Accepted') && 
                                                           (applicant.Engagement__r.Status__c =='New' || applicant.Engagement__r.Status__c =='Processing'|| applicant.Engagement__r.Status__c =='Program Ready' || applicant.Engagement__r.Status__c =='On Program' || applicant.Engagement__r.Status__c =='' || applicant.Engagement__r.Status__c == null ))){                
                                                               
                                                               // 2.1. Looking for apps that are older than 6 months.
                                                               if(applicant.CreatedDate < (date.today() - 180) && applicant.RecordType.Name != 'Work Travel PT'){
                                                                   createAvailable = true;
                                                               }
                                                           }else{
                                                               createAvailable = true;
                                                           }
        system.debug('debug::CheckPTAppStatusReturn= '+createAvailable);
        return createAvailable;             
    }
    
    
    
    //This method is to redirect to previous page
    public PageReference backNavigator() {
        
        return null;    
    }
    
    //This method is to validate IGI Program Preferences Based flow
    // Not being used?
    public PageReference validateIGIProgramDeterminationServiceLevel() {
        
        //Populating Service Level with respect to the user selection (Yes/No)
        if(selectedServiceLevel != null && selectedServiceLevel != '' && selectedServiceLevel == Constants.YES) {
            applicantInfo.Service_Level__c = 'Independent';
        } 
        
        else if(selectedServiceLevel != null && selectedServiceLevel != '' && selectedServiceLevel == Constants.NO) {
            applicantInfo.Service_Level__c = 'Premium';
        } 
        
        //Check for Service Level on Program Preference Page
        
        ApexPages.currentPage().getParameters().put('nextPage', '/apex/IGI_App_Experience');
        ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
        return navigator();
    }
    
    //This method is to validate IGI Program Preferences Based flow
    // Not being used?
    public PageReference validateIGIProgramPreferencesBack() {
        
        //Check for Service Level on Program Preference Page
        if(applicantInfo.Service_Level__c == 'Independent') {
            
            //Put Placemnet Information page in Param
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/IGI_App_Placement_Information');
            
        } else if (applicantInfo.Service_Level__c == 'Premium') {
            
            //Put Experience page in Param
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/IGI_App_Experience');
        } else {
            
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/IGI_App_Placement_Information');
        }
        
        return navigator();
    }
    
    
    //This methos is to validate my T&C page
    public PageReference validateMyTermsPage() {
        
        //Check if user agrees on T&C
        if(applicantInfo.Terms_Accepted__c == false || applicantInfo.Deposit_Fee_Accepted__c == false) {
            
            //Throw an error message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please accept terms and conditions.'));
            return null;
        }
        if(applicantInfo.Application_Level__c == 'Basic')
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_my_travel_services');
        else 
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_home');
        
        ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
        return navigator();
    }
    
    public boolean getCheckCentersAPAirportTranfers(){
        list<Applicant_Product__c> ap = [SELECT Id,Applicant_Info__c, Product__c, Product_Name__c, Product_Name_Label__c FROM Applicant_Product__c WHERE Applicant_Info__c =: applicantInfo.Id
                                         AND (Product_Name__c =: 'Arrival Transfer')];
        
        if(ap.size() >= 1) return true;
        else return false;
    }
    
    public string getPackageDelivery(){
        list<Applicant_Product__c> ap = [SELECT Id,Applicant_Info__c, Product__c, Product_Name__c, Product_Name_Label__c, Description__c, Product_Description_Label__c FROM Applicant_Product__c WHERE Applicant_Info__c =: applicantInfo.Id
                                         AND (Product_Name__c =: 'Standard Delivery')];
        if(ap.size() >= 1) return ap[0].Description__c;
        else return null;                               
    }
    
    public string getIntraxInsurance(){
        list<Applicant_Product__c> ap = [SELECT Id,Applicant_Info__c, Product__c, Product_Name__c, Product_Name_Label__c, Description__c, Product_Description_Label__c FROM Applicant_Product__c WHERE Applicant_Info__c =: applicantInfo.Id
                                         AND (Product_Name__c =: 'Intrax Insurance')];
        if(ap.size() >= 1) return ap[0].Description__c;
        else return null;                               
    }
    
    public string getArrivalTransfer(){
        list<Applicant_Product__c> ap = [SELECT Id,Applicant_Info__c, Product__c, Product_Name__c, Product_Name_Label__c, Description__c, Product_Description_Label__c FROM Applicant_Product__c WHERE Applicant_Info__c =: applicantInfo.Id
                                         AND (Product_Name__c =: 'Arrival Transfer' OR Product_Name__c =: 'Departure Transfer')];
        system.debug('********* AP SIZE: '+ ap.size());                                 
        if(ap.size() == 1){
            if(ap[0].Product_Name__c == 'Arrival Transfer')
                return System.Label.T_0318;
            else if(ap[0].Product_Name__c == 'Departure Transfer')
                return System.Label.T_0319;
            else
                return null;
        }
        else if(ap.size() == 2)
            return System.Label.T_0318 +' + ' + System.Label.T_0319;  
        else 
            return null;                               
    }
    
    //This methos is to validate My Travel services
    public PageReference validateMyTravelServicesPage() {
        
        isArrival = mapApplicantProduct.get('Travel').get(0).selected;
        
        System.debug('######### Value in Boolean' + isArrival);
        
        // Modified to evoid dynamic navigation
        if(applicantInfo.Application_Level__c == 'Basic')
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_accommodations');
        else
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_accommodations');
        
        ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
        return navigator();
    }
    
    //Method to process the Flight Arrival date and Arrival Time String for converting them in data time format
    private DateTime setStringToDateTimeFormat(String myDate, String myTime) {
        
        //Processing Time String for Formatting
        String mySubString = ' ' + myTime.substring(0, 5) + ':' + '00';
        
        //Getting values in Date Time format from the String
        Datetime dateTimeFieldValue = DateTime.valueOf(myDate + mySubString);
        
        return dateTimeFieldValue;
        
    }
    
    //Upload Image
    /*
public PageReference uplaodPhoto() {

try {

//Uplaod photo document
if(photoDoc.Name != null && photoDoc.Body != null) {

//Upsert document
if(photoDoc.ParentId == null)
photoDoc.ParentId = applicantInfo.Id;
upsert photoDoc;
applicantInfo.PhotoId__c = photoDoc.Id;
update applicantInfo;
}

if(uploadDocDescription != null) {
photoDoc.Description = uploadDocDescription;
}
if(photoDoc != null)
update photoDoc;

} catch(Exception e) {
ApexPages.addMessages(e);
}
//Return null
return null;
}
*/
    //Create  map with with Product Ids
    Map<Id, Applicant_Product__c> mapApplicantProd = new Map<Id, Applicant_Product__c>();
    Map<Id, PricebookEntry> mapPricebookEntryByProductId = new Map<Id, PricebookEntry>();
    public Map<String, List<ApplicantProductWrapper>> mapApplicantProduct {get; set;}
    public Map<String, String> mapDescriptionWithProductId {get; set;}
    public Map<String, String> mapExistingDescriptionWithProductId {get; set;}
    public String existingDescriptionWithProductId {get; set;}
    
    //Varibale to hold the Select list for Package Delivery Family Products
    public List<SelectOption> listPackageDelivery {get; set;}
    public Id selectedPackageDelivery {get; set;}
    
    //Variable to hold the Select list for Insurance Family products
    public List<SelectOption> listInsurancePackage {get; set;}
    public List<String> listInsurancePackageSList {get; set;}
    public Id selectedInsuarancePackage {get; set;} 
    /*
//Variable to hold the Airport Transfer Yes.No    
public String selectedAPTransport {get; set;} 
public List<SelectOption> getListAPTransport() {
List<SelectOption> options = new List<SelectOption>(); 
options.add(new SelectOption('Yes','Yes')); 
options.add(new SelectOption('No','No')); 
return options; 
}

public String getselectedAPTransport() {
return selectedAPTransport;
}

public void setselectedAPTransport(String selectedAPTransport) { this.selectedAPTransport = selectedAPTransport; }
*/   
    
    //Map having Product Description as key and Product Id as value
    public Map<String, Id> mapDescriptionWithProducts {get; set;}
    
    //Story #101 addition
    public List<ApplicantProductWrapper> cambrigeProductsWrapperList {get; set;}
    public String cambrigeProductName {get; set;}
    public Boolean isCambrigeProductSelected {get; set;}
    
    //Story #99 Addition
    public List<ApplicantProductWrapper> noOfLessonsWrapperList {get; set;}
    
    //This method is to get the Product records
    public void populateApplicantProductWrapper() {
        
        //Initialization of the select options list
        listPackageDelivery = new List<SelectOption>();
        listInsurancePackage = new List<SelectOption>();
        listInsurancePackageSList = new List<String>();
        
        //Memory allocation to the map
        mapDescriptionWithProducts = new Map<String, Id>();
        cambrigeProductsWrapperList = new List<ApplicantProductWrapper>();
        noOfLessonsWrapperList = new List<ApplicantProductWrapper>();
        cambrigeProductName = Constants.CAMBRIGE_FCE_PRODUCT_NAME;
        
        //Variable to hold the Applicant Info Id value
        Id applicantIdValue;
        
        //Checking for Id value parameter in the URL
        if(ApexPages.currentPage().getParameters().get(Constants.ID_PARAMETER) != null)
            applicantIdValue = ApexPages.currentPage().getParameters().get(Constants.ID_PARAMETER);
        
        //Checking and validating Id value
        if(applicantInfo.Id == null && applicantIdValue != null && applicantIdValue.getsObjectType().getDescribe().getName() == Constants.APPLICANT_INFO) {
            applicantInfo = [Select Id, Intrax_Center__c From Applicant_Info__c a WHERE ID =: applicantIdValue];
        }
        try{
            
            //loop through the Applicant Infor records and populate map
            for(Applicant_Product__c appProduct : [Select Id, Product__c, Applicant_Info__c, Product_Name__c, Product_Name_Label__c, Description__c, Sort_Order__c, Unit_Price__c, Quantity__c, Start_Date__c, Product__r.Start_Date__c, Help_Text__c, Help_Text_Label__c, Product__r.Family, Product__r.Description, Promo_CTA__c,Promo_CTA_Label__c, Product__r.Product_Description_Label__c, Product_Description_Label__c from Applicant_Product__c 
                                                   where Applicant_Info__c =: applicantInfo.Id 
                                                   AND Product__c != null]) {
                                                       
                                                       //Populate Map
                                                       mapApplicantProd.put(appProduct.Product__c, appProduct);   
                                                       
                                                   }
            
            //initialize map
            mapApplicantProduct = new Map<String, List<ApplicantProductWrapper>>();
            mapDescriptionWithProductId = new Map<String, String>();
            mapExistingDescriptionWithProductId = new Map<String, String>();
            existingDescriptionWithProductId = '';
            
            //Loop through products
            for(PricebookEntry pBEntry : [SELECT ID, UnitPrice, Product2.Name,Product2.Product_Name_Label__c, Product2.Family, Product2.Description, Product2.ProductCode, Product2.Product_Description_Label__c,
                                          Product2.Help_Text__c,Product2.Help_Text_Label__c,Product2.Intrax_Centers__c, Product2.Intrax_Program__c, Product2.Sort_Order__c, 
                                          Product2.Start_Date__c, Product2.Promo_CTA__c, Product2.Promo_CTA_Label__c FROM PricebookEntry 
                                          WHERE Product2.IsActive = true 
                                          //AND Product2.Intrax_Centers__c includes (applicantInfo.Intrax_Center__c)
                                          AND Pricebook2ID IN (Select Pricebook2.Id from Pricebook2 
                                                               WHERE Intrax_Programs__c includes ('English and Professional Skills') 
                                                               AND isActive = true AND isStandard = false
                                                              ) 
                                          ORDER BY Product2.Sort_Order__c]) {
                                              
                                              if(IUtilities.isIncluded(pBEntry.Product2.Intrax_Centers__c, applicantInfo.Intrax_Center__c)){   
                                                  
                                                  //Add  data in Map
                                                  mapPricebookEntryByProductId.put(pBEntry.Product2Id, pBEntry);
                                                  
                                                  //Check if mapApplicantProduct Contains this
                                                  if(mapApplicantProduct.containsKey(pBEntry.Product2.Family)) {
                                                      
                                                      //Check if This product has already been added
                                                      if(mapApplicantProd.containsKey(pBEntry.Product2Id)) {
                                                          
                                                          //Add in mapApplicantProduct
                                                          mapApplicantProduct.get(pBEntry.Product2.Family).add(new ApplicantProductWrapper(true, applicantInfo, 
                                                                                                                                           mapApplicantProd.get(pBEntry.Product2Id)));
                                                      } else {
                                                          
                                                          //Add in mapApplicantProduct
                                                          Applicant_Product__c appProduct = new Applicant_Product__c(Applicant_Info__c = applicantInfo.Id, Product__c = pBEntry.Product2Id, 
                                                                                                                     Description__c = pBEntry.Product2.Description, 
                                                                                                                     Product_Description_Label__c = pBEntry.Product2.Product_Description_Label__c,
                                                                                                                     Sort_Order__c = pBEntry.Product2.Sort_Order__c,
                                                                                                                     Unit_Price__c = pBEntry.UnitPrice,
                                                                                                                     Help_Text__c = pBEntry.Product2.Help_Text__c,
                                                                                                                     Help_Text_Label__c = pBEntry.Product2.Help_Text_Label__c,
                                                                                                                     Start_Date__c = pBEntry.Product2.Start_Date__c,
                                                                                                                     Promo_CTA__c = PBEntry.Product2.Promo_CTA__c,
                                                                                                                     Promo_CTA_Label__c = PBEntry.Product2.Promo_CTA_Label__c,
                                                                                                                     Quantity__c = 1, Product_Name__c = pBEntry.Product2.Name,
                                                                                                                     Product_Name_Label__c = pBEntry.Product2.Product_Name_Label__c);
                                                          
                                                          //Check for the product family
                                                          if(pBEntry.Product2.Family == Constants.SELF_DIRECTED) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                                                              
                                                              //Set appProduct quantity to null
                                                              appProduct.Quantity__c = null;
                                                          }
                                                          
                                                          mapApplicantProduct.get(pBEntry.Product2.Family).add(new ApplicantProductWrapper(false, applicantInfo, appProduct));
                                                      }
                                                      
                                                  } else {
                                                      
                                                      //Check if This product has already been added
                                                      if(mapApplicantProd.containsKey(pBEntry.Product2Id)) {
                                                          
                                                          //Add in mapApplicantProduct
                                                          mapApplicantProduct.put(pBEntry.Product2.Family, 
                                                                                  new List<ApplicantProductWrapper>{new ApplicantProductWrapper(true, applicantInfo, 
                                                                                                                                                mapApplicantProd.get(pBEntry.Product2Id))});
                                                      } else {
                                                          
                                                          //Add in mapApplicantProduct
                                                          Applicant_Product__c appProduct = new Applicant_Product__c(Applicant_Info__c = applicantInfo.Id, Product__c = pBEntry.Product2Id, 
                                                                                                                     Description__c = pBEntry.Product2.Description, 
                                                                                                                     Product_Description_Label__c = pBEntry.Product2.Product_Description_Label__c,
                                                                                                                     Sort_Order__c = pBEntry.Product2.Sort_Order__c,
                                                                                                                     Unit_Price__c = pBEntry.UnitPrice,
                                                                                                                     Help_Text__c = pBEntry.Product2.Help_Text__c,
                                                                                                                     Help_Text_Label__c = PBEntry.Product2.Help_Text_Label__c,
                                                                                                                     Start_Date__c = pBEntry.Product2.Start_Date__c,
                                                                                                                     Promo_CTA__c = PBEntry.Product2.Promo_CTA__c,
                                                                                                                     Promo_CTA_Label__c = PBEntry.Product2.Promo_CTA_Label__c,
                                                                                                                     Quantity__c = 1, Product_Name__c = pBEntry.Product2.Name,
                                                                                                                     Product_Name_Label__c = pBEntry.Product2.Product_Name_Label__c);
                                                          
                                                          //Check for the product family
                                                          if(pBEntry.Product2.Family == Constants.SELF_DIRECTED) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                                                              
                                                              
                                                              //Set appProduct quantity to null
                                                              appProduct.Quantity__c = null;
                                                          }
                                                          
                                                          //Add in mapApplicantProduct
                                                          mapApplicantProduct.put(pBEntry.Product2.Family, 
                                                                                  new List<ApplicantProductWrapper>{new ApplicantProductWrapper(false, applicantInfo, appProduct)});
                                                      }
                                                  }
                                              }
                                          }
            
            //Added for Story #30
            //Loop through products
            for(PricebookEntry pBEntry : [SELECT ID, UnitPrice, Product2.Name, Product2.Product_Name_Label__c, Product2.Family,  Product2.Description, Product2.Product_Description_Label__c, Product2.ProductCode, 
                                          Product2.Help_Text__c, Product2.Help_Text_Label__c, Product2.Intrax_Centers__c, Product2.Intrax_Program__c, Product2.Sort_Order__c, 
                                          Product2.Start_Date__c, Product2.Promo_CTA__c, Product2.Promo_CTA_Label__c FROM PricebookEntry 
                                          WHERE Product2.IsActive = false 
                                          AND Pricebook2ID IN (Select Pricebook2.Id from Pricebook2 
                                                               WHERE Intrax_Programs__c includes ('English and Professional Skills') 
                                                               AND isActive = true AND isStandard = false
                                                              ) 
                                          ORDER BY Product2.Sort_Order__c]) {
                                              
                                              if(mapApplicantProd.containsKey(pBEntry.Product2ID) && IUtilities.isIncluded(pBEntry.Product2.Intrax_Centers__c, applicantInfo.Intrax_Center__c)) {
                                                  System.debug('@@@@@ pBEntry for deactivated ' + pBEntry); 
                                                  //Adding value in the map
                                                  if(mapApplicantProduct.get(pBEntry.Product2.Family) != null)
                                                      mapApplicantProduct.get(pBEntry.Product2.Family).add(new ApplicantProductWrapper(true, applicantInfo, mapApplicantProd.get(pBEntry.Product2Id)));
                                                  else 
                                                      mapApplicantProduct.put(pBEntry.Product2.Family, 
                                                                              new List<ApplicantProductWrapper>{new ApplicantProductWrapper(true, applicantInfo, mapApplicantProd.get(pBEntry.Product2Id))});
                                              }                       
                                          }
            
            
            //Loop through map keyset
            for(String family : mapApplicantProduct.keySet()) { 
                
                //Get List of wrapper and sort it and put it back in map
                List<ApplicantProductWrapper> lstApplicantProductWrapper = mapApplicantProduct.get(family);
                lstApplicantProductWrapper.sort();
                mapApplicantProduct.put(family, lstApplicantProductWrapper);
            }
            System.debug('@@@@@ mapApplicantProduct ' + mapApplicantProduct);
            
            //Added for Story #101
            //loop through the product (Acedemic Programs Type)
            if(mapApplicantProduct.get(Constants.ACADEMIC_PROGRAMS) != null) {
                
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.ACADEMIC_PROGRAMS)) {
                    
                    //Checking for Product Name String
                    if(aPWrapper.applicantProduct != null && aPWrapper.applicantProduct.Product_Name__c != null && aPWrapper.applicantProduct.Product_Name__c.trim() != ''
                       && aPWrapper.applicantProduct.Product_Name__c.trim().toLowerCase() == Constants.CAMBRIGE_FCE_PRODUCT_NAME.trim().toLowerCase()) {
                           
                           //Populating list with the wrapper records
                           cambrigeProductsWrapperList.add(aPWrapper);
                       }
                }   
            }
            
            //Added for Story #99
            //Loop through the product (Self-Directed Type) //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            if(mapApplicantProduct.get(Constants.SELF_DIRECTED) != null) {
                
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.SELF_DIRECTED)) {
                    
                    //Checking for Product Name String 
                    if(aPWrapper.applicantProduct != null && aPWrapper.applicantProduct.Product_Name__c != null && aPWrapper.applicantProduct.Product_Name__c.trim() != ''
                       && aPWrapper.applicantProduct.Product_Name__c.trim().toLowerCase() == Constants.PRIVATE_LESSONS.trim().toLowerCase()) {
                           
                           //Populate wrapper list with the appropriate value
                           noOfLessonsWrapperList.add(aPWrapper);
                       }
                }   
            }
            //CT-109
            
            /*Making those product selected already for whom we are having applicant products on applicant info record*/
            
            //Setting selection for Acedemic Excellence family products
            if(mapApplicantProduct.containsKey(Constants.UNLIMITED_PACKAGE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Loop through the Academic Excellence records and check if there is already a record addres, then mark it as seleted
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.UNLIMITED_PACKAGE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if this product is already associted with database, then mark it as true
                    if(aPWrapper.applicantProduct.Id != null)   {
                        
                        //Setting value in variable for making corresponding radio button as default
                        selectedAcademicExcellenceProductId = aPWrapper.applicantProduct.Product__c;
                    }
                }
            }
            
            //Setting selection for Acedemic Program family products (Only Cambrige Type)
            if(mapApplicantProduct.containsKey(Constants.ACADEMIC_PROGRAMS)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Loop through the Academic Excellence records and check if there is already a record addres, then mark it as seleted
                for(ApplicantProductWrapper aPWrapper : cambrigeProductsWrapperList) {
                    
                    //Check if this product is already associted with database, then mark it as true
                    if(aPWrapper.applicantProduct.Id != null)   {
                        
                        //Setting value in variable for making corresponding radio button as default
                        selectedAcademicProgramsProductId = aPWrapper.applicantProduct.Product__c;
                        isCambrigeProductSelected = true;
                    }
                }
            }
            
            //Add data in Professional Certificates Package list
            if(mapApplicantProduct.containsKey(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Loop through the Professional Certificates records and check if there is already a record addres, then mark it as seleted
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    if(aPWrapper.applicantProduct.Id != null) {
                        if(existingDescriptionWithProductId == null || existingDescriptionWithProductId == '')
                            existingDescriptionWithProductId = aPWrapper.applicantProduct.Product__c;
                        else
                            existingDescriptionWithProductId += ',' + aPWrapper.applicantProduct.Product__c;
                    }
                }
                
                System.debug('existingDescriptionWithProductId ' + existingDescriptionWithProductId);
            }
            
            //Add data in Intensity Package list
            if(mapApplicantProduct.containsKey(Constants.INTENSITY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Loop through the Intensity records and check if there is already a record addres, then mark it as seleted
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.INTENSITY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if this product is already associted with database, then mark it as true
                    if(aPWrapper.applicantProduct.Id != null)   {
                        
                        //Setting value in variable for making corresponding radio button as default
                        selectedIntensityProductId = aPWrapper.applicantProduct.Product__c;
                    }
                }
            }
            /*
//Add data in Package Delievery list
if(mapApplicantProduct.containsKey(Constants.PACKAGE_DELIEVERY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End

//Loop through the Intensity records and check if there is already a record addres, then mark it as seleted
for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.PACKAGE_DELIEVERY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End

//Get data and add in list
//if(aPWrapper.applicantProduct.Product_Description_Label__c!=null)
//listPackageDelivery.add(new SelectOption(aPWrapper.applicantProduct.Product__c, aPWrapper.applicantProduct.Product_Description_Label__c));
//else
listPackageDelivery.add(new SelectOption(aPWrapper.applicantProduct.Product__c, aPWrapper.applicantProduct.Description__c));

//Check if this product is already associted with database, then mark it as true
if(aPWrapper.applicantProduct.Id != null)   {

//Mark package as default
selectedPackageDelivery = aPWrapper.applicantProduct.Product__c;
}
}
}

//Add data in Insurance list
if(mapApplicantProduct.containsKey(Constants.INSURANCE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End

//Loop through the Intensity records and check if there is already a record addres, then mark it as seleted
for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.INSURANCE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End

//Get data and add in list
//if(aPWrapper.applicantProduct.Product_Description_Label__c!=null)
//listInsurancePackage.add(new SelectOption(aPWrapper.applicantProduct.Product__c, aPWrapper.applicantProduct.Product_Description_Label__c));                
//else
listInsurancePackage.add(new SelectOption(aPWrapper.applicantProduct.Product__c, aPWrapper.applicantProduct.Description__c));                

//listInsurancePackageSList.add(aPWrapper.applicantProduct.Product_Description_Label__c);              

//Check if this product is already associted with database, then mark it as true
if(aPWrapper.applicantProduct.Id != null)   {

//Mark package as default
selectedInsuarancePackage = aPWrapper.applicantProduct.Product__c;
}
}            
}
*/
            
            //Add data in Accommodation Package list - CN 95
            if(mapApplicantProduct.containsKey(Constants.ACCOMODATION)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                System.debug('selectedAccommodationProductId in constructor---->'+selectedAccommodationProductId);
                //Loop through the Intensity records and check if there is already a record addres, then mark it as seleted
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.ACCOMODATION)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if this product is already associted with database, then mark it as true
                    if(aPWrapper.applicantProduct.Id != null)   {
                        
                        //Setting value in variable for making corresponding radio button as default
                        selectedAccommodationProductId = aPWrapper.applicantProduct.Product__c;
                    }
                }
            }
        }catch (Exception e){
            system.debug('***** Exception: ' + e);          
        }
    }
    
    /*Code for adding functionality related to Promo CTA field on Product having family as Academic Excellence */
    
    
    public Map<String,String> mapAppProductFamily = new Map<String,String>();
    
    public String selectedInsuranceValue {get;set;} 
    public Component.Apex.selectRadio getCustomInsuranceProducts(){                  
        System.debug('mValue Selected-->'+mapAppProductFamily.get(Constants.INSURANCE)); 
        
        Component.Apex.selectRadio myCustomRadio = new Component.Apex.selectRadio(); 
        myCustomRadio.layout='pageDirection';               
        myCustomRadio.id = 'Insurance_Package';      
        
        if(applicantInfo.Application_Level__c == 'Basic')
            myCustomRadio.disabled = False; 
        else if(applicantInfo.Application_Level__c == 'Main')
            myCustomRadio.disabled = True;      
        
        if(mapApplicantProduct.containsKey(Constants.INSURANCE)) {              
            for(ApplicantProductWrapper myappprod : mapApplicantProduct.get(Constants.INSURANCE)) {
                Component.Apex.selectOption so = new Component.Apex.selectOption();
                so.itemValue = myappprod.applicantProduct.Product__c;               
                Component.Apex.OutputText output = new Component.Apex.OutputText();
                System.debug('-------->'+myappprod.applicantProduct.description__c);
                if(myappprod.applicantProduct.product_description_label__c!=null){                 
                    selectedInsuranceValue = mapAppProductFamily.get(Constants.INSURANCE);                                             
                    output.expressions.value = '{!$Label.' + myappprod.applicantProduct.product_description_label__c + '}';                     
                    string labelValue = string.valueOf(output.value);                       
                    so.itemLabel = labelValue;
                    myCustomRadio.childComponents.add(so);
                }
                else {                 
                    selectedInsuranceValue = mapAppProductFamily.get(Constants.INSURANCE);                  
                    string labelValue = string.valueOf(myappprod.applicantProduct.description__c);                       
                    so.itemLabel = labelValue;
                    myCustomRadio.childComponents.add(so); 
                }
                myCustomRadio.expressions.value = '{!selectedInsuranceValue}';                              
            }
        }                  
        return myCustomRadio;
    }
    
    public String selectedPackageDelValue {get;set;} 
    public Component.Apex.selectRadio getCustomPackageDelivery(){                    
        
        System.debug('mValue Selected-->'+mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY)); 
        
        Component.Apex.selectRadio myCustomRadio = new Component.Apex.selectRadio();   
        myCustomRadio.layout='pageDirection';             
        myCustomRadio.id = 'Package_Delivery';      
        
        if(applicantInfo.Application_Level__c == 'Basic')
            myCustomRadio.disabled = False; 
        else if(applicantInfo.Application_Level__c == 'Main')
            myCustomRadio.disabled = True;    
        
        if(mapApplicantProduct.containsKey(Constants.PACKAGE_DELIEVERY)) {              
            for(ApplicantProductWrapper myappprod : mapApplicantProduct.get(Constants.PACKAGE_DELIEVERY)) {
                Component.Apex.selectOption so = new Component.Apex.selectOption();
                so.itemValue = myappprod.applicantProduct.Product__c;               
                Component.Apex.OutputText output = new Component.Apex.OutputText();
                System.debug('-------->'+myappprod.applicantProduct.description__c);
                if(myappprod.applicantProduct.product_description_label__c!=null){                 
                    selectedPackageDelValue = mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY);                                                
                    output.expressions.value = '{!$Label.' + myappprod.applicantProduct.product_description_label__c + '}';                     
                    string labelValue = string.valueOf(output.value);                       
                    so.itemLabel = labelValue;
                    myCustomRadio.childComponents.add(so);
                }
                else {                 
                    selectedPackageDelValue = mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY);                 
                    string labelValue = string.valueOf(myappprod.applicantProduct.description__c);                       
                    so.itemLabel = labelValue;
                    myCustomRadio.childComponents.add(so); 
                }
                myCustomRadio.expressions.value = '{!selectedPackageDelValue}';                                 
            }
        }                  
        return myCustomRadio;
    }
    
    //Variable to hold the selected Product Id for "Acedemic Excellence" family
    public Id selectedAcademicExcellenceProductId{get; set;}
    public Id prodId {get; set;}
    
    //Variable to hold the "Academic Programs" family Products Id (Only for Cambrige Type)
    public Id selectedAcademicProgramsProductId {get; set;}
    public Id academicProgramsProdId {get; set;}
    
    //Variable to hold the "Professional Certificates" family Products Id
    public Id selectedProfessionalCertificatesProductId {get; set;}
    public Id professionalCertificatesProdId {get; set;}
    public String professionalCertificatesDesc {get; set;}
    public string professionaCertificateDescription {get; set;}
    
    //Variable to hold the the "Intensity" family Products Ids
    public Id selectedIntensityProductId{get; set;}
    public Id intensityProdId {get; set;}
    
    //Variable to hold the the "Accommodation" family Products Ids
    public Id selectedAccommodationProductId{get; set;}
    public Id accommodationProdId {get; set;}
    
    //Mathod for get Product Id as a Parameter corresponding to the selected Radio button from Academic Excellence Family Products list 
    public void selectedProduct() {
        
        //Populating Variable with Selected Product ID
        selectedAcademicExcellenceProductId = prodId;
        
    }
    
    //Method for get Product Id as a Parameter corresponding to the selected Radio button from Academic Programs Family Products list 
    public void selectedAcademicProgramsProduct() {
        
        //Populating Variable with Selected Product ID
        selectedAcademicProgramsProductId = academicProgramsProdId;
    }
    
    //Method for reset the variables
    public void resetVariables() {
        
        selectedAcademicProgramsProductId = null;
        isCambrigeProductSelected = false;
        
    }
    
    //Method for get Product Id as a Parameter corresponding to the selected Radio button from professional Certificates Family Products list 
    public void selectedProfessionalCertificatesProduct() {
        
        //Populating Variable with Selected Product ID
        selectedProfessionalCertificatesProductId = professionalCertificatesProdId;
        
        //Populating Varaible with Slected Product Description
        professionaCertificateDescription = professionalCertificatesDesc;
        
        //Check for Null
        if(selectedProfessionalCertificatesProductId !=  null && professionaCertificateDescription != null) {
            
            //Populate Map with Values
            mapDescriptionWithProductId.put(professionaCertificateDescription, selectedProfessionalCertificatesProductId);
        }
    }
    
    //Method for get Product Id as a Parameter corresponding to the selected Radio button from Intensity Family Products list 
    public void selectedIntensityProduct() {
        
        //Populating Variable with Selected Product ID
        selectedIntensityProductId = intensityProdId;  
        
    }
    
    public void selectedAccommodationProduct() {
        
        //Populating Variable with Selected Product ID
        selectedAccommodationProductId = accommodationProdId;  
        System.debug('selectedAccommodationProductId on click-----'+selectedAccommodationProductId);
    }
    
    //Variable to hold the selectProfessionalCertificates
    public String selectProfessionalCertificates {get; set;}
    
    //CT-112
    public PageReference resetProductsOnProgramSelectionChange() {
        
        if(applicantInfo.Program_Selector__c == Constants.CUSTOM_TYPE) {
            selectedAcademicExcellenceProductId = null;
            
            //Loop through applicant product wrapper list for populating set with the product Id value
            //story 152
            if(noOfLessonsWrapperList!=null){
                for(ApplicantProductWrapper apWrapper : noOfLessonsWrapperList) {
                    apWrapper.selected = false;
                    if(apWrapper.applicantProduct != null)
                        apWrapper.applicantProduct.Quantity__c = 0;
                    
                    
                }
            }
        } else {
            
            
            selectedIntensityProductId = null;
            
            if(mapApplicantProduct != null) {
                if(mapApplicantProduct.get(Constants.ACADEMIC_PROGRAMS) != null) {
                    
                    //Loop through applicant product wrapper list
                    for(ApplicantProductWrapper awrapper :  mapApplicantProduct.get(Constants.ACADEMIC_PROGRAMS)) {
                        
                        //Checking for Product Name String
                        if(awrapper.applicantProduct != null){
                            if(awrapper.applicantProduct.Product_Name__c != null){ 
                                if(awrapper.applicantProduct.Product_Name__c.trim() != '' && awrapper.applicantProduct.Product_Name__c.trim().toLowerCase() != Constants.CAMBRIGE_FCE_PRODUCT_NAME.trim().toLowerCase()){                           
                                    awrapper.selected = false;
                                }   
                            }     
                        }             
                    }
                    
                    //Loop through wrapper list
                    if(cambrigeProductsWrapperList != null){
                        for(ApplicantProductWrapper awrap :cambrigeProductsWrapperList) {
                            awrap.selected = false; 
                        }
                    }
                    
                    //Checking for value in map
                    if(mapApplicantProduct.get(Constants.SELF_DIRECTED) != null) {
                        
                        
                        //Loop through applicant product wrapper list
                        for(ApplicantProductWrapper awrapper :  mapApplicantProduct.get(Constants.SELF_DIRECTED)) {
                            awrapper.selected = false;
                            if(awrapper.applicantProduct != null)
                                awrapper.applicantProduct.Quantity__c = 0;
                            
                            
                            
                            
                            
                        }
                    }
                }
            }
        }
        
        return null;
    }
    //CT-112 End
    
    //B-01476
    
    /*public list<String> getAirportsListUSA(){

system.debug('*****@@@ in getAirportsListUSA()');

list<Airports__c> airportsList = [Select Name, Airport_Name__c, Country__c from Airports__c WHERE Country__c = 'USA'];

List<String> AirportsUSAAux = new String[airportsList.size()];
String auxTextAir;


for(integer i=0; i<airportsList.size();i++){
auxTextAir =  '"' + String.valueOf(airportsList[i].Name) + ' - ' +   String.valueOf(airportsList[i].Airport_Name__c) + ', ' +  String.valueOf(airportsList[i].Country__c + '"');
AirportsUSAAux[i]=auxTextAir;
}
system.debug('*****@@@ AirportsUSAAux: ' + AirportsUSAAux);
return AirportsUSAAux;
}*/
    
    
    //This method is to validate the academic plan
    public PageReference validateAcademicPlan() {
        System.debug('save method');
        //Create a list of Applicant Product to be created
        List<Applicant_Product__c> aPlansToBeCreated = new List<Applicant_Product__c>();
        
        //Create a list of Applicant Product to be updated
        List<Applicant_Product__c> aPlansToBeUpdated = new List<Applicant_Product__c>();
        
        //Create a list of Applicant Product to be deleted
        List<Applicant_Product__c> aPlansToBeDeleted = new List<Applicant_Product__c>();
        
        //Populating Study Weeks field with the value selected by the User
        if(selectedStudyWeeks != null && selectedStudyWeeks != '') {
            applicantInfo.Study_Weeks__c = Integer.valueOf(selectedStudyWeeks);
        }
        
        //loop through the Product
        for(String family : mapApplicantProduct.keySet()) { 
            
            //loop through the product
            for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(family)) {
                
                //Check if record is selected
                if(aPWrapper.selected == true || (family == Constants.SELF_DIRECTED && aPWrapper.applicantProduct.Quantity__c > 0)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if product has already been added
                    if(!mapApplicantProd.containsKey(aPWrapper.applicantProduct.Product__c)) {
                        
                        //add in List to be created
                        aPlansToBeCreated.add(aPWrapper.applicantProduct);
                        
                    } else if(family == Constants.SELF_DIRECTED) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                        
                        //add in List to be created
                        aPlansToBeUpdated.add(aPWrapper.applicantProduct);
                    }
                    
                } else if(family == Constants.SELF_DIRECTED && aPWrapper.applicantProduct.Quantity__c > 0) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Update the record if already exists
                    //Check if product has already been added
                    if(mapApplicantProd.containsKey(aPWrapper.applicantProduct.Product__c)) {
                        
                        //add in List to be created
                        aPlansToBeUpdated.add(aPWrapper.applicantProduct);
                    }
                    
                } else {
                    
                    //Check if product has already been added
                    if(mapApplicantProd.containsKey(aPWrapper.applicantProduct.Product__c)) {
                        
                        //add in List to be created
                        aPlansToBeDeleted.add(aPWrapper.applicantProduct);
                    }
                }
            }   
        }
        
        //Check for teh Academic Excellence Packages
        if(mapApplicantProduct.containsKey(Constants.UNLIMITED_PACKAGE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Chekc if product is already there
            if(!mapApplicantProd.containsKey(selectedAcademicExcellenceProductId)) {
                
                //Add new Applicant product
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.UNLIMITED_PACKAGE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if product is same as selected one
                    if(aPWrapper.applicantProduct.Product__c == selectedAcademicExcellenceProductId) {
                        
                        //add in List to be created
                        aPlansToBeCreated.add(aPWrapper.applicantProduct);
                        
                    } else if(aPWrapper.applicantProduct.Id != null) {
                        
                        //delete the existing products
                        aPlansToBeDeleted.add(aPWrapper.applicantProduct);  
                    }
                }
            }
        } 
        
        //Setting selection for Acedemic Program family products (Only Cambrige Type)
        if(mapApplicantProduct.containsKey(Constants.ACADEMIC_PROGRAMS)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Chekc if product is already there
            if(!mapApplicantProd.containsKey(selectedAcademicProgramsProductId)) {
                
                //Loop through the Academic Excellence records and check if there is already a record addres, then mark it as seleted
                for(ApplicantProductWrapper aPWrapper : cambrigeProductsWrapperList) {
                    
                    //Check if product is same as selected one
                    if(aPWrapper.applicantProduct.Product__c == selectedAcademicProgramsProductId) {
                        
                        //add in List to be created
                        aPlansToBeCreated.add(aPWrapper.applicantProduct);
                        
                    } else if(aPWrapper.applicantProduct.Id != null) {
                        
                        //delete the existing products
                        aPlansToBeDeleted.add(aPWrapper.applicantProduct);  
                    }
                }
            }        
        }
        
        //Check for teh Professional Certificates Packages
        if(mapApplicantProduct.containsKey(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            System.debug('entered save professional------');
            //Create new set to hold the values
            Set<String> setExistingPlans = new Set<String>();
            Set<String> setNewPlans = new Set<String>();
            
            //check for teh exisiting Ids
            if(existingDescriptionWithProductId != null && existingDescriptionWithProductId != '')
                setExistingPlans.addAll(existingDescriptionWithProductId.split(','));
            
            //check for teh exisiting Ids
            if(selectProfessionalCertificates != null && selectProfessionalCertificates != '')
                setNewPlans.addAll(selectProfessionalCertificates.split(','));
            
            //Create a set of products to be deleted
            Set<String> setToBeDeletedPlans = setExistingPlans.clone();
            setToBeDeletedPlans.removeAll(setNewPlans);
            
            //Get the Intersection of setExistingPlans and setNewPlans
            setExistingPlans.retainAll(setNewPlans);
            
            //get the remaining records to be inserted
            setNewPlans.removeAll(setExistingPlans);
            
            //Getting Wrapper list corresponding to the Product family
            for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Check all existing applicant Products with respect to the description
                if(aPWrapper.applicantProduct.Id != null && setToBeDeletedPlans.contains(aPWrapper.applicantProduct.Product__c)) {
                    
                    //add in List to be deleted
                    aPlansToBeDeleted.add(aPWrapper.applicantProduct);
                } 
            }
            
            //Loop through map values
            for(String productId : setNewPlans) {
                
                //Get Price Book Data
                PricebookEntry pBEntry = mapPricebookEntryByProductId.get(productId);
                
                if(!mapDescriptionWithProducts.containsKey(pBEntry.Product2.Description)) {
                    
                    //Add in mapApplicantProduct
                    Applicant_Product__c appProduct = new Applicant_Product__c(Applicant_Info__c = applicantInfo.Id, Product__c = pBEntry.Product2Id, 
                                                                               Description__c = pBEntry.Product2.Description, 
                                                                               Product_Description_Label__c = pBEntry.Product2.Product_Description_Label__c,
                                                                               Sort_Order__c = pBEntry.Product2.Sort_Order__c,
                                                                               Unit_Price__c = pBEntry.UnitPrice,
                                                                               Help_Text__c = pBEntry.Product2.Help_Text__c,
                                                                               Help_Text_Label__c = PBEntry.Product2.Help_Text_Label__c,
                                                                               Start_Date__c = pBEntry.Product2.Start_Date__c,
                                                                               Promo_CTA__c = PBEntry.Product2.Promo_CTA__c,
                                                                               Promo_CTA_Label__c = PBEntry.Product2.Promo_CTA_Label__c,
                                                                               Quantity__c = 1, Product_Name__c = pBEntry.Product2.Name,
                                                                               Product_Name_Label__c = pBEntry.Product2.Product_Name_Label__c);
                    
                    //Add in List to be created
                    aPlansToBeCreated.add(appProduct);
                }
            }
        }
        
        //Check for teh Professional Certificates Packages
        if(mapApplicantProduct.containsKey(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Getting Wrapper list corresponding to the Product family
            for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Check all existing applicant Products with respect to the description
                if(aPWrapper.applicantProduct.Id != null && mapDescriptionWithProductId.containsKey(aPWrapper.applicantProduct.Product_Description_Label__c)) {
                    
                    //add in List to be deleted
                    aPlansToBeDeleted.add(aPWrapper.applicantProduct);
                    System.debug('######### Value in aPlansToBeDeleted' + aPlansToBeDeleted);
                } 
            }
            
            //Loop through map values
            for(String productId : mapDescriptionWithProductId.values()) {
                
                //Get Price Book Data
                PricebookEntry pBEntry = mapPricebookEntryByProductId.get(productId);
                
                //Add in mapApplicantProduct
                Applicant_Product__c appProduct = new Applicant_Product__c(Applicant_Info__c = applicantInfo.Id, Product__c = pBEntry.Product2Id, 
                                                                           Description__c = pBEntry.Product2.Description, 
                                                                           Product_Description_Label__c = pBEntry.Product2.Product_Description_Label__c,
                                                                           Sort_Order__c = pBEntry.Product2.Sort_Order__c,
                                                                           Unit_Price__c = pBEntry.UnitPrice,
                                                                           Help_Text__c = pBEntry.Product2.Help_Text__c,
                                                                           Help_Text_Label__c = PBEntry.Product2.Help_Text_Label__c,
                                                                           Start_Date__c = pBEntry.Product2.Start_Date__c,
                                                                           Promo_CTA__c = PBEntry.Product2.Promo_CTA__c,
                                                                           Promo_CTA_Label__c = PBEntry.Product2.Promo_CTA_Label__c,
                                                                           Quantity__c = 1, Product_Name__c = pBEntry.Product2.Name,
                                                                           Product_Name_Label__c = pBEntry.Product2.Product_Name_Label__c);
                
                
                //Add in List to be created
                aPlansToBeCreated.add(appProduct);
            }
        }
        
        //Check for teh Professional Certificates Packages Reset One
        if(mapApplicantProduct.containsKey(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Getting Wrapper list corresponding to the Product family
            for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.PROFESSIONAL_CERTIFICATE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Check all existing applicant Products with respect to the description
                if(aPWrapper.applicantProduct.Id != null && mapDescriptionWithProducts.containsKey(aPWrapper.applicantProduct.Product_Description_Label__c)) {
                    
                    if(mapDescriptionWithProductId.containsKey(aPWrapper.applicantProduct.Product_Description_Label__c)) {
                        mapDescriptionWithProductId.remove(aPWrapper.applicantProduct.Product_Description_Label__c);
                    } 
                    
                    //add in List to be deleted
                    aPlansToBeDeleted.add(aPWrapper.applicantProduct);
                } 
            }
        }
        
        //Check for teh Intensity Packages
        if(mapApplicantProduct.containsKey(Constants.INTENSITY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Chekc if product is already there
            if(!mapApplicantProd.containsKey(selectedIntensityProductId)) {
                
                //Add new Applicant product
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.INTENSITY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if product is same as selected one
                    if(aPWrapper.applicantProduct.Product__c == selectedIntensityProductId) {
                        
                        //add in List to be created
                        aPlansToBeCreated.add(aPWrapper.applicantProduct);
                        
                    } else if(aPWrapper.applicantProduct.Id != null) {
                        
                        //delete the existing products
                        aPlansToBeDeleted.add(aPWrapper.applicantProduct);  
                    }
                }
            }
        }
        
        //Check for teh Package Delivery
        if(mapApplicantProduct.containsKey(Constants.PACKAGE_DELIEVERY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Chekc if product is already there
            //if(!mapApplicantProd.containsKey(selectedPackageDelValue)) {
            
            //Add new Applicant product
            for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.PACKAGE_DELIEVERY)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                
                //Check if product is same as selected one 
                if(mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY) != null && applicantInfo.Visa_Category__c=='Student (F)'){
                    System.debug('-----ENterered record exists');
                    selectedPackageDelivery = mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY);                         
                }
                
                if(applicantInfo.Visa_Category__c=='Student (F)'){
                    System.debug('-----ENterered student f');
                    selectedPackageDelivery = selectedPackageDelValue;                      
                }                    
                
                if(aPWrapper.applicantProduct.Id == null && aPWrapper.applicantProduct.Product__c == selectedPackageDelivery && applicantInfo.Visa_Category__c=='Student (F)') {
                    
                    //add in List to be created
                    aPlansToBeCreated.add(aPWrapper.applicantProduct);
                    
                }else if(aPWrapper.applicantProduct.Id != null &&( applicantInfo.Visa_Category__c!='Student (F)' || aPWrapper.applicantProduct.Product__c != selectedPackageDelivery)) {
                    //} if(mapAppProductFamily.get(Constants.PACKAGE_DELIEVERY) != null && applicantInfo.Visa_Category__c!='Student (F)'){  
                    
                    //delete the existing products
                    aPlansToBeDeleted.add(aPWrapper.applicantProduct);  
                }
            }
            //}
        }
        
        //Check for teh Insurance
        if(mapApplicantProduct.containsKey(Constants.INSURANCE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Chekc if product is already there
            if(!mapApplicantProd.containsKey(selectedInsuranceValue)) {                
                //Add new Applicant product
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.INSURANCE)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if product is same as selected one
                    //saveMethod
                    //selectedInsuarancePackage = myCustomRadio.value;
                    if(mapAppProductFamily.get(Constants.INSURANCE) != null)
                        selectedInsuarancePackage = mapAppProductFamily.get(Constants.INSURANCE);
                    
                    selectedInsuarancePackage = selectedInsuranceValue;                     
                    
                    if(aPWrapper.applicantProduct.Product__c == selectedInsuarancePackage) {                        
                        //add in List to be created
                        aPlansToBeCreated.add(aPWrapper.applicantProduct);
                        
                    } else if(aPWrapper.applicantProduct.Id != null) {
                        System.debug('to deleted---->'+aPlansToBeDeleted.size());
                        //delete the existing products
                        aPlansToBeDeleted.add(aPWrapper.applicantProduct);  
                    }
                }
            }
        }
        
        //Check for the Accommodation Packages
        if(mapApplicantProduct.containsKey(Constants.ACCOMODATION)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
            
            //Check if product is already there
            if(!mapApplicantProd.containsKey(selectedAccommodationProductId)) {
                
                //Add new Applicant product
                for(ApplicantProductWrapper aPWrapper : mapApplicantProduct.get(Constants.ACCOMODATION)) { //CT-109 Hard Coded string replaced with Constants variable //CT-109 End
                    
                    //Check if product is same as selected one
                    if(aPWrapper.applicantProduct.Product__c == selectedAccommodationProductId) {
                        
                        //add in List to be created
                        aPlansToBeCreated.add(aPWrapper.applicantProduct);
                        
                    } else if(aPWrapper.applicantProduct.Id != null) {
                        
                        //delete the existing products
                        aPlansToBeDeleted.add(aPWrapper.applicantProduct);  
                    }
                }
            } 
        }
        
        if(applicantInfo.Airport_Transfer__c == 'No'){
            list<Applicant_Product__c> apTrans = [SELECT Id,Applicant_Info__c, Product__c, Product_Name__c, Product_Name_Label__c, Description__c, Product_Description_Label__c FROM Applicant_Product__c WHERE Applicant_Info__c =: applicantInfo.Id
                                                  AND (Product_Name__c =: 'Arrival Transfer' OR Product_Name__c =: 'Departure Transfer')];
            system.debug('********* APTrans SIZE: '+ apTrans.size()); 
            if(apTrans.size()>0){
                for(Applicant_Product__c a:apTrans)
                    aPlansToBeDeleted.add(a);
            }
        }
        
        System.debug('@@@@@ value in aPlansToBeCreated ' + aPlansToBeCreated);
        System.debug('@@@@@ value in aPlansToBeDeleted ' + aPlansToBeDeleted);
        System.debug('@@@@@ value in aPlansToBeUpdated ' + aPlansToBeUpdated);
        
        try{
            //Check for the Size
            if(aPlansToBeDeleted.size() > 0)
                delete aPlansToBeDeleted;
            if(aPlansToBeCreated.size() > 0)
                insert aPlansToBeCreated;
            if(aPlansToBeUpdated.size() > 0)
                update aPlansToBeUpdated;
        }
        catch(Exception e){
            system.debug('*****@@@ Exception in PageStatusController: ' + e);
        }
        
        //Call Navigator
        if(applicantInfo.Application_Level__c == 'Basic')
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_my_terms');
        else if(applicantInfo.Application_Level__c == 'Main')
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_my_terms');
        ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
        return navigator();
    }
    
    public PageReference callValidatePlanAndAccommodations() {
        
        //CT-119
        //Checking for the Accommodation Preference value
        if(applicantInfo.Intrax_Accommodations__c == 'Yes') {
            
            if(applicantInfo.Accommodation_Preference__c != Constants.HOMESTAY) {
                
                //Check if user have selected "Accommodation" family products
                if(selectedAccommodationProductId == null) {
                    
                    //Throw an error message
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.T_0354));
                    return null;
                    
                }
            }
        }
        //CT-119 End
        
        //Methods
        selectProfessionalCertificates  = existingDescriptionWithProductId ;
        
        //Validate Products
        validateAcademicPlan();
        
        // Modified to evoid dynamic navigation
        if(applicantInfo.Application_Level__c == Constants.BASIC)
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_preapp_summary');
        else
            ApexPages.currentPage().getParameters().put('nextPage', '/apex/centers_app_summary');
        
        ApexPages.currentPage().getParameters().put('reDirectPage', 'true');
        return navigator();
        
    }
    
    public PageReference callValidatePlanAAndMyTravelService() {
        
        //Check if user have selected "Package Delivery" family products.
        //story 150. added visa category condition        
        selectedPackageDelivery = selectedPackageDelValue;
        if(applicantInfo.Visa_Category__c=='Student (F)' && selectedPackageDelivery == null) {
            
            //Throw an error message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'How should we send your Acceptance Package?: You must select a value.'));
            return null;
        }
        
        selectedInsuarancePackage = selectedInsuranceValue;
        //Check if user have selected "Insurance" family products
        if(selectedInsuarancePackage == null) {            
            //Throw an error message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Students need travel and health insurance coverage during their program in the U.S.: You must select a value.'));
            return null;
        }               
        
        if(applicantInfo.Airport_Transfer__c == 'Yes' && (mapApplicantProduct.get('Travel').get(0).selected == FALSE)){
            //Throw an error message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Do you want to buy airport transfer?: You must select a value.'));
            return null;            
        }
        //Methods
        selectProfessionalCertificates  = existingDescriptionWithProductId ;
        validateAcademicPlan();
        return validateMyTravelServicesPage();
    }
    
    //Method for Uploading Photo and then Navigate to next appropriate page
    /*
public PageReference uploadPhotoAndNavigate() {

//Methods
uplaodPhoto();
return navigator();
}*/
    
    
    
    public boolean getIsIGIIntern (){
        User u = [SELECT Id, Name, User_Interests__c FROM User WHERE Id =: userInfo.getUserId()];
        
        if(u.User_Interests__c == 'Finding an Internship') return true;
        else return false;
    }
    
    //Method to deleted Address location record on click on delete link corresponding to the family previous address list
    public void deleteExperience() {
        
        //Location Instance
        Experience__c ExperienceInstance;
        
        //Check for Null
        if(ExperienceId != null) {
            
            //Create a Map
            Map<Id, Experience__c> mapExperience = new Map<Id, Experience__c>(listExperience);
            
            //Delete experience form database
            Database.delete(Id.valueOf(experienceId), true);
            
            //Remove from Map
            mapExperience.remove(Id.valueOf(experienceId));
            
            //Put data back in list
            listExperience = mapExperience.values();
        }
    }
    
    //Method to deleted Address location record on click on delete link corresponding to the family previous address list
    public void deleteLocation() {
        
        //Location Instance
        Location__c locationInstance;
        
        //Check for Null
        if(locationId != null) {
            
            //Create a Map
            Map<Id, Location__c> mapLocation = new Map<Id, Location__c>(locationInfoList);
            
            //Delete experience form database
            Database.delete(Id.valueOf(locationId), true);
            
            //Remove from Map
            mapLocation.remove(Id.valueOf(locationId));
            
            //Put data back in list
            locationInfoList = mapLocation.values();
        }
    }
    
    //Method to deleted family member record 
    public void deleteFamilyMember() {
        
        //Location Instance
        Person_Info__c familyMemberInstance;
        
        //Check for Null
        if(familyMemberId != null) {
            
            //Create a Map
            Map<Id, Person_Info__c> mapFamilyMember = new Map<Id, Person_Info__c>(familyInfoList);
            
            //Delete experience form database
            Database.delete(Id.valueOf(familyMemberId), true);
            
            //Remove from Map
            mapFamilyMember.remove(Id.valueOf(familyMemberId));
            
            //Put data back in list
            familyInfoList = mapFamilyMember.values();
        }
    }
    
    //Method to deleted family member record 
    
    public pageReference deleteReference() {
        
        //Location Instance
        Person_Info__c referenceInstance;
        
        //Check for Null
        if(referenceId != null) {
            
            //Create a Map
            Map<Id, Person_Info__c> mapReference = new Map<Id, Person_Info__c>(RefererInfoList);
            
            //Delete experience form database
            Database.delete(Id.valueOf(referenceId), true);
            
            //Remove from Map
            mapReference.remove(Id.valueOf(referenceId));
            
            //Put data back in list
            RefererInfoList = mapReference.values();
        }
        
        pageReference p = new pageReference('/apex/ayusa_hf_fam_references?id=' + applicantInfo.Id);
        p.setRedirect(true);
        return p;
    }
    
    public boolean getStudFVisa(){      
        System.debug('-----applicantInfo.Visa_Category__c:'+applicantInfo.Visa_Category__c);
        if(applicantInfo.Visa_Category__c == 'Student (F)'){ 
            System.debug('-----applicantInfo.Visa_Category__c:'+applicantInfo.Visa_Category__c);
            return true;   
        }
        else{
            System.debug('-----entered false');
            return false;
        }   
    }
    
    
    //Method to deleted family member record 
    public void deleteEmergencyContact() {
        
        //Location Instance
        Person_Info__c emergencyConatactInstance;
        
        //Check for Null
        if(emergencyContactId != null) {
            
            //Create a Map
            Map<Id, Person_Info__c> mapReference = new Map<Id, Person_Info__c>(EmergencyInfoList);
            
            //Delete experience form database
            Database.delete(Id.valueOf(emergencyContactId), true);
            
            //Remove from Map
            mapReference.remove(Id.valueOf(emergencyContactId));
            
            //Put data back in list
            EmergencyInfoList = mapReference.values();
        }
    }
    
    
    //########################################################################################
    //################################ APC CODE ##############################################
    //########################################################################################
    
    //beginning List of variables for APC
    
    //Stop Action Polling
    public list<dsfs__DocuSign_Status__c> docusListUser{get; set;}
    public dsfs__DocuSign_Status__c docusUser{get; set;}
    public list<dsfs__DocuSign_Recipient_Status__c> docusRecipientList{get; set;}
    public dsfs__DocuSign_Recipient_Status__c docusUserRec2AD{get; set;}
    
    public list<Experience__c> listExperienceChild{get; set;} 
    public Integer ideisRef{get;set;}
    public list<School__c> schoolInfoList{get;set;}
    public String userAgentCheck{get;set;}  
    public Person_Info__c personRole{get;set;}
    public List<Person_Info__c> personRoleList {get;set;}
    public Person_Info__c personEmergency{get;set;}
    public List<Person_Info__c> personEmergencyList {get;set;}
    public Account personaccount{get; set;}
    public Opportunity opportunity{get; set;}
    public Opportunity childApplicationOpportunity{get;set;}
    public Account appAccount{get; set;}
    public String roleInput{get; set;}
    public List<Person_Info__c> PersonInfoReferList{get;set;}
    public Boolean isReferCheck{get;set;}
    public decimal amount{get;set;}
    public String DescriptionCoupon{get;set;}  
    public String refUrl {get;set;}
    public String vstate {get;set;}
    public String swimParam {get; set{swimParam = value;}}
    public String phyParam {get; set{phyParam = value;}}
    public String bgcParam {get; set{bgcParam = value;}}
    public String driveParam {get; set{driveParam = value;}}
    public String Proofparam {get; set{Proofparam = value;}}
    public String mediaparam {get; set{mediaparam = value;}}
    public String apchf_mediaparam {get; set{apchf_mediaparam = value;}}
    public String Transcriptsparam {get; set{Transcriptsparam = value;}}
    public String Passportparam {get; set{Passportparam = value;}}
    public String Videoparam {get; set{Videoparam = value;}}
    public String ProgramType {get; set;}
    public string EducationId{get; set{EducationId=value;}}
    public String returnURL {get;set;}
    public Map<String, Intrax_Program_Upload__c> MapPhotoAlbum {get;set;}
    public Integer MapAlbumSize {get;set;}
    public Map<String, Intrax_Program_Upload__c> MapPTVideo {get;set;}
    public Map<String ,Map<String, Intrax_Program_Upload__c>> MapPTVideoThumb {get;set;}
    public Integer MapVideoSize {get;set;}
    public String keyURLModal{get;set;}
    public String IdIPU {get;set;}
    public Intrax_Program_Upload__c ipuPhoto {get;set;}
    public String igiMediaParam{get;set{igiMediaParam = value;}}
    public String igiDocsParam{get;set{igiDocsParam = value;}}
    public String igiDepsParam{get;set{igiDepsParam = value;}}
    public Boolean isVideo{get;set;}
    public String userProfileName{get;set;}
    public String flaggedList{get;set;}
    
    public Reference__c reference{get;set;}
    public list<Reference__c> referenceList;
    public list<Reference__c> referenceListCheck{get;set;}
    public Assessment__c assessment{get;set;}
    
    public List<PersonInfoChildWrapper> wrappers {get; set;}
    public List<Person_Info__c>  children {get; set;}
    public Integer toDelIdent {get; set;}
    public Id delEducationRec {get; set;}
    public string educationType {get; set;}
    public string addedu {get; set;}
    public Integer addCount {get; set;}
    private Integer nextIdent=1;
    private Integer nextIdentExp=1;
    public Integer NumberOfChild{get; set;}
    public Integer wrappersize{get; set;}
    public Integer wrapperParsize{get; set;}
    public Integer wrapperFamsize{get; set;}
    public Integer wrapperExpsize{get; set;}
    public Date Today { get { return Date.today(); }}
    public list<Experience__c> listExperienceChildAUX;
    public map<String, Reference__c> mapPersonHFRef{get; set;}
    
    public Audit_Info__c auditinfo{get; set;}
    
    
    public List<PersonInfoParentWrapper> wrappersParent {get; set;}
    public List<Person_Info__c>  parents {get; set;}
    
    public List<ExperienceDetailWrapper> wrappersExp {get; set;}
    public List<Experience_Detail__c>  experDetails {get; set;}
    
    public list<String> AirportsUSA{get; set;}
    
    //AA APC Family/Sibling wrapper   
    public List<PersonInfoFamilyWrapper> wrappersfamily {get; set;}
    public List<Person_Info__c>  Family {get; set;}
    
    public List<SelectOption> getCategoryExperience(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Private/Individual','Private/Individual'));
        options.add(new SelectOption('Public/Group','Public/Group')); 
        return options;
    }
    
    public List<SelectOption> getTypeExperience(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Childcare Individual (Baby Sitting, Nanny, AuPair)','Childcare Individual (Baby Sitting, Nanny, AuPair)'));
        options.add(new SelectOption('Private Tutoring','Private Tutoring')); 
        options.add(new SelectOption('Child Education','Child Education'));
        options.add(new SelectOption('Child Daycare','Child Daycare'));
        return options;
    }
    
    /*
public List<SelectOption> getlistUSArrivalDates(){

List<SelectOption> options = new List<SelectOption>();
list<APC_ArrivalDates__c> listDates = new list<APC_ArrivalDates__c>();

listDates = [SELECT US_Arrival__c FROM APC_ArrivalDates__c WHERE US_Arrival__c > Today order by US_Arrival__c ASC ];

for(APC_ArrivalDates__c adate:listDates){

options.add(new SelectOption(String.valueOf(adate.US_Arrival__c.format()),String.valueOf(adate.US_Arrival__c.format()))); 

}

return options;
}
*/
    
    public List<SelectOption> getlistUSArrivalDates(){
        
        system.debug('****@@@@inside  getlistUSArrivalDates()');
        
        list<SelectOption> optionsDate = new List<SelectOption>();
        
        Integer currentmonth = date.today().month();
        Integer currentyear = date.today().year();
        String currentmonthStr = String.valueOf(currentmonth);
        String currentyearStr = String.valueOf(currentyear);
        String nextyearStr = String.valueOf(currentyear + 1);
        String label;
        String value;
        
        
        //setting the array sizes.
        
        //Creating a month Map<>
        Map<Integer,String> monthMap = new Map<Integer,String>();    
        monthMap.put(1, 'January');
        monthMap.put(2, 'February');
        monthMap.put(3, 'March');
        monthMap.put(4, 'April');
        monthMap.put(5, 'May');
        monthMap.put(6, 'June');
        monthMap.put(7, 'July');
        monthMap.put(8, 'August');
        monthMap.put(9, 'September');
        monthMap.put(10, 'October');
        monthMap.put(11, 'November');
        monthMap.put(12, 'December');
        
        system.debug('****@@@@ currentmonth: ' + currentmonth); 
        system.debug('****@@@@ currentyear: ' + currentyear);
        
        //Creating months values for current year
        for(integer r=currentmonth; r<13; r++){
            value = String.valueOf(r) +'/'+ '01'+'/'+ currentyearStr;
            label = monthMap.get(r) +' '+ currentyearStr;
            optionsDate.add(new SelectOption(value, label)); 
        }
        
        //Creating months values for next year
        for(integer j=1; j<13; j++){
            value = String.valueOf(j) +'/'+ '01'+'/'+ nextyearStr;
            label = monthMap.get(j) +' '+ nextyearStr;
            optionsDate.add(new SelectOption(value, label)); 
        }
        
        system.debug('****@@@@ optionsDate: ' + optionsDate); 
        
        return optionsDate;
    }
    
    public integer addlanguage{get; set;}
    public Boolean addphones{get; set;}
    public Boolean addsibling{get; set;}
    public Boolean addparent{get; set;}
    public Boolean addPtRef{get; set;}
    public Boolean addEmergency{get; set;}
    public String promovalue{get; set;}
    public String totalamount{get; set;}
    public String promoCodeValue{get;set;}
    
    //Variables related to payment process
    
    public List<PriceBookEntry> couponCodes{get; set;}
    public List<PriceBookEntry> standartFeeApc{get; set;}
    public String ipAddress {get; set;}
    public PaymentWrapper payWrapper {get; set;}
    public Payment__c payment {get; set;}
    public String maskedCCNumber {get; set;}        
    public String paymentRecordId {get; set;}
    public Boolean isConfirmPayment {get; set;}
    public Boolean useCurrentBillingAddressInfo {get; set;}
    public String paymentTxId {get; set;}
    public String paymentAmount {get; set;}
    public String paymentDate {get; set;}
    
    public void addotherphone(){
        addphones = true;
    }
    
    public void cleanHowHeard(){
        applicantInfo.How_Heard_Detail__c = null;
        applicantInfo.How_Heard_Other__c = null;
    }
    
    public void removeOtherPhone(){
        addPhones = false;
        personInfo.Other_Phone__c = null;
        personInfo.Other_Phone_Type__c = null;
        personInfo.Phone_Country_Code_Other__c = null;
    }
    
    public void addlanguages(){
        addlanguage++;
    }
    
    public void deletelanguages(){
        
        if(addlanguage == 2){
            
            applicantInfo.Language_3__c = null;
            applicantInfo.Language_3_Proficiency__c = null;
            
        }else if(addlanguage == 1){
            
            applicantInfo.Language_2__c = null;
            applicantInfo.Language_2_Proficiency__c = null;
            
        }
        
        addlanguage--;
    }
    
    public void deletelanguagesIGI(){
        system.debug('******* addlangueage: ' + addlanguage);
        if(addlanguage == 3){        
            applicantInfo.Language_3__c = null;
            applicantInfo.Language_3_Proficiency__c = null;    
        }else if(addlanguage == 2){    
            applicantInfo.Language_2__c = null;
            applicantInfo.Language_2_Proficiency__c = null;
        }else if(addlanguage == 1){    
            applicantInfo.Language_1__c = null;
            applicantInfo.Language_1_Proficiency__c = null;
        }    
        addlanguage--;
    }
    
    public void addsiblings(){
        
        system.debug('****@@@applicantinfo.Any_Sibling_Indicated__c: '+ applicantinfo.Any_Sibling_Indicated__c);
        if(applicantinfo.Any_Sibling_Indicated__c=='Yes'){
            addCount = 1;
            addRowsParfamily();
        }
    }
    
    public void deletesiblings(){
        
        applicantinfo.Any_Sibling_Indicated__c = 'No';
        delWrapperFamily();
        
    }
    
    public void setCurrentDate(){
        experience.End_Date__c = date.today();
    }
    
    
    public void addotherparent(){
        
        //system.debug('*****## into addotherparent');
        addparent = true;
        
    }
    
    public void addPtReference(){
        
        //system.debug('*****## entra en addPtReference');
        addPtRef = true;
        
    }
    
    
    //List for APC credit card types and credit card number
    
    public Boolean promoCode {get;set;}
    public string TypeCreditCardSelected{get;set;}
    
    
    public List<SelectOption> listCountryCodeOptions {get; set;}
    public List<SelectOption> getProgramType{get; set;}
    public List<SelectOption> getHeardDetail{get; set;}
    public List<SelectOption> getAPCPTTimeZone{get; set;}
    //B-02904
     public List<SelectOption> getAPCHFTimeZone{
        get {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('America/New_York','Eastern Daylight Time'));
        options.add(new SelectOption('America/Chicago','Central Daylight Time'));
        options.add(new SelectOption('America/Denver','Mountain Daylight Time')); 
        options.add(new SelectOption('America/Phoenix','Mountain Standard Time')); 
        options.add(new SelectOption('America/Los_Angeles','Pacific Daylight Time')); 
        return options;
        }
     }
    
    public List<SelectOption> getTypeCard(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Visa','Visa'));
        options.add(new SelectOption('MasterCard','MasterCard'));
        options.add(new SelectOption('AmericanExpress','American Express'));
        options.add(new SelectOption('Discover','Discover')); 
        
        return options;
    }
    
    public List<SelectOption> getpromoCodecheck(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getLanguageLevel(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Beginner','Beginner'));
        //options.add(new SelectOption('2','Limited'));
        options.add(new SelectOption('Intermediate','Intermediate'));
        options.add(new SelectOption('Advanced','Advanced'));
        //options.add(new SelectOption('5','Native/Fluent'));
        return options;
    }
    
    
    //List for APC credit card month and year
    
    public string monthSelected{get;set;}
    
    public List<SelectOption> getMonth(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('01','January'));
        options.add(new SelectOption('02','February'));
        options.add(new SelectOption('03','March'));
        options.add(new SelectOption('04','April'));
        options.add(new SelectOption('05','May'));
        options.add(new SelectOption('06','June'));
        options.add(new SelectOption('07','July'));
        options.add(new SelectOption('08','August'));
        options.add(new SelectOption('09','September'));
        options.add(new SelectOption('10','October'));
        options.add(new SelectOption('11','November'));
        options.add(new SelectOption('12','December'));
        
        return options;
    }
    
    public string yearSelected{get;set;}
    
    public List<SelectOption> getYear(){
        List<SelectOption> options = new List<SelectOption>();
        Date currentdate = date.today();
        integer year = currentdate.year();
        
        options.add(new SelectOption(string.valueof(year),string.valueof(year)));
        options.add(new SelectOption(string.valueof(year + 1),string.valueof(year + 1)));
        options.add(new SelectOption(string.valueof(year + 2),string.valueof(year + 2)));
        options.add(new SelectOption(string.valueof(year + 3),string.valueof(year + 3)));
        options.add(new SelectOption(string.valueof(year + 4),string.valueof(year + 4)));
        options.add(new SelectOption(string.valueof(year + 5),string.valueof(year + 5)));
        options.add(new SelectOption(string.valueof(year + 6),string.valueof(year + 6)));
        options.add(new SelectOption(string.valueof(year + 7),string.valueof(year + 7)));
        options.add(new SelectOption(string.valueof(year + 8),string.valueof(year + 8)));
        options.add(new SelectOption(string.valueof(year + 9),string.valueof(year + 9)));
        options.add(new SelectOption(string.valueof(year + 10),string.valueof(year + 10)));
        options.add(new SelectOption(string.valueof(year + 11),string.valueof(year + 11)));
        options.add(new SelectOption(string.valueof(year + 12),string.valueof(year + 12)));
        options.add(new SelectOption(string.valueof(year + 13),string.valueof(year + 13)));
        options.add(new SelectOption(string.valueof(year + 14),string.valueof(year + 14)));
        options.add(new SelectOption(string.valueof(year + 15),string.valueof(year + 15)));
        
        return options;
    }  
    
    public String expireMonth {get; set
    {
        expireMonth = value;
    }
                              }
    
    
    public String expireYear {get; set
    {
        expireYear = value;
    }
                             }
    
    public String maskCCNumber {get; set
    {
        maskCCNumber = value; 
    }
                               }
    
    public String paymentId {get; set
    {
        paymentId = value;
    }
                            }
    
    public String AuPairPref {get; set
    {
        AuPairPref = value;
    }
                             }
    
    public Boolean isWorkExperienced {get; set
    {
        isWorkExperienced = value;
    }
                                     }
    
    public List<SelectOption> getUSAStatesList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select One--'));        
        
        // Find all the states in the custom setting
        Map<String, US_States__c> states = US_States__c.getAll();
        
        // Sort them by name
        List<String> stateNames = new List<String>();
        stateNames.addAll(states.keySet());
        stateNames.sort();
        
        // Create the Select Options.
        for (String stateName : stateNames) {
            US_States__c state = states.get(stateName);
            options.add(new SelectOption(state.Name, state.Name));
        }
        return options;
    }
    
    public list<String> getAirportsListUSA(){
        
        system.debug('*****@@@ in getAirportsListUSA()');
        
        list<Airports__c> airportsList = [Select Name, Airport_Name__c, Country__c from Airports__c WHERE Country__c = 'USA'];
        
        List<String> AirportsUSAAux = new String[airportsList.size()];
        String auxTextAir;
        
        
        for(integer i=0; i<airportsList.size();i++){
            auxTextAir =  '"' + String.valueOf(airportsList[i].Name) + ' - ' +   String.valueOf(airportsList[i].Airport_Name__c) + ', ' +  String.valueOf(airportsList[i].Country__c + '"');
            AirportsUSAAux[i]=auxTextAir;
        }
        system.debug('*****@@@ AirportsUSAAux: ' + AirportsUSAAux);
        return AirportsUSAAux;
    }
    
    
    
    public Boolean CheckPtVideoUpdate(){
        //get APC PT Video
        
        Boolean isThere;
        
        list<Intrax_Program_Upload__c>loadDocAUXvideo = [Select Id, Document_Guid__c, Description__c, Document_service__c, Document_Type__c, Applicant_Info__c, AWS_ET_Preset__c, AWS_ET_Job_Status__c 
                                                         from Intrax_Program_Upload__c 
                                                         where Applicant_Info__c = :applicantinfo.Id and document_type__c = 'Introductory-Video' and AWS_ET_Job_Status__c = 'Success' and AWS_ET_Preset__c = 'Generic 720p' and (NOT Document_Guid__c LIKE '%Thumbnail%')];
        
        if(loadDocAUXvideo !=null && loadDocAUXvideo.size()>0){
            isThere = true;
        }else{
            isThere = false;
        } 
        system.debug('*****@@@isThere: ' + isThere);
        return isThere;
    }
    
    public void isVideoSuccessinit(){
        //cheing in the video is there during the constructor cicle (NO DML allowed)
        list<Intrax_Program_Upload__c> loadDocVid = [Select Id, Document_Guid__c, Thumbnail__c, Description__c, Document_service__c, Document_Type__c, Applicant_Info__c, AWS_ET_Preset__c, AWS_ET_Job_Status__c 
                                                     from Intrax_Program_Upload__c 
                                                     where Applicant_Info__c = :applicantinfo.Id and document_type__c = 'Introductory-Video' and AWS_ET_Preset__c = 'Generic 720p' and AWS_ET_Job_Status__c = 'Success' and (NOT Document_Guid__c LIKE '%Thumbnail%') order by createdDate DESC limit 1 ];
        if(loadDocVid!=null && loadDocVid.size()>0){
            system.debug('@@@@@loadDocVid[0].Document_Guid__c: ' + loadDocVid[0].Document_Guid__c);
            isVideo=true;
        }else{
        }
        
    }
    
    public void isVideoSuccess(){
        
        list<Intrax_Program_Upload__c> loadDocVid = [Select Id, Document_Guid__c, Thumbnail__c, Description__c, Document_service__c, Document_Type__c, Applicant_Info__c, AWS_ET_Preset__c, AWS_ET_Job_Status__c 
                                                     from Intrax_Program_Upload__c 
                                                     where Applicant_Info__c = :applicantinfo.Id and document_type__c = 'Introductory-Video' and AWS_ET_Preset__c = 'Generic 720p' and AWS_ET_Job_Status__c = 'Success' and (NOT Document_Guid__c LIKE '%Thumbnail%') order by createdDate DESC limit 1 ];
        //MapPTVideoThumb = IUtilities.getVideosParticipant(applicantInfo);
        if(loadDocVid!=null && loadDocVid.size()>0){
            system.debug('@@@@@loadDocVid[0].Document_Guid__c: ' + loadDocVid[0].Document_Guid__c);
            //setting iVedo to true
            isVideo=true;
            system.debug('@@@@@MapPTVideoThumb before isVideo: ' + MapPTVideoThumb);
            //Doing a webCall to AWS to retrive the most current DocGuid value
            MapPTVideoThumb = IUtilities.getVideosParticipant(applicantInfo); 
            MapVideoSize = MapPTVideoThumb.size();
            system.debug('@@@@@MapPTVideoThumb after isVideo: ' + MapPTVideoThumb);
            //Updating PageStatusController
            PageStatusController('036'); 
        }else{
            //system.debug('*****@@@MapPTVideoThumb before isVideo: ' + MapPTVideoThumb);
        }
        
    }
    
    //Check AuPair PreApp Status (Qualified, Flagged, Unqualified)
    public PageReference AuditPreApp(){
        system.debug('Inside AuditPreApp Method');
        //Crating Audit_Info Record for Application
        date.today().month();
        Integer currentyear = date.today().year();
        String currentmonthStr = String.valueOf(date.today().month());
        Decimal AgePT = 0;
        //Init the Page
        PageReference p;
        
        //Getting Audit info record related to the applicant info
        list<Audit_Info__c>  auditinfoList = [Select Id from Audit_Info__c where Applicant_Info__c = :applicantinfo.Id ];
        
        if(auditinfoList != null && auditinfoList.size()>0){
            system.debug('Check AuditPreApp Record to create');
            auditinfo = auditinfoList[0];
            
        }else{
            system.debug('Create AuditPreApp Record');
            RecordType rtAuditAPC = [select id, Name from RecordType where SobjectType='Audit_Info__c' and Name='APC PT' Limit 1];
            auditinfo = new Audit_Info__c( Name= applicantinfo.Name + ' - ' + String.valueOf(date.today().month()) + '/' + String.valueOf(date.today().year()) ,
                                          Applicant_Info__c = applicantinfo.Id, RecordTypeId = rtAuditAPC.Id );
            insert auditinfo;
        }
        
        String statusApp;
        Boolean isUnqualified = false;
        Boolean isFlagged = false;
        
        if(!Test.isRunningTest()){
            AgePT = personInfo.Date_Of_Birth__c.daysBetween(Date.Today())/365.2425;
            system.debug('@@@@@Age AuPair: ' + AgePT);
            if(personInfo.Date_Of_Birth__c.day() == Date.Today().day() && personInfo.Date_Of_Birth__c.month() == Date.Today().month() ){
                AgePT = Math.round(AgePT);//mierda  
            }
        }
        system.debug('@@@@@Age AuPair in Decimal final: ' + AgePT);
        
        //Setting all unquelified values to PASS
        auditinfo.Citizenship__c = 'Pass';
        auditinfo.Residency__c = 'Pass';
        auditinfo.Prior_Exchange__c = 'Pass';
        auditinfo.Nationality__c = 'Pass';
        auditinfo.Age__c = 'Pass';
        auditinfo.Marital_Status__c = 'Pass';
        auditinfo.Visa__c = 'Pass';
        auditinfo.US_Passport__c = 'Pass';
        auditinfo.Address__c = 'Pass';
        //Setting all flagged values to PASS
        auditinfo.Experience__c = 'Pass';
        auditinfo.Dates__c = 'Pass';
        auditinfo.Crime_Charge__c = 'Pass';
        auditinfo.Health__c = 'Pass';
        auditinfo.Disease__c = 'Pass';
        auditinfo.Drug_Dependency__c = 'Pass';
        //auditinfo.Driving__c = 'Pass';
        auditinfo.Disability__c = 'Pass';
        auditinfo.Pregnant__c = 'Pass';
        auditinfo.Medication__c = 'Pass';
        auditinfo.Hospitalization__c = 'Pass';
        auditinfo.Psychiatric_Treatment__c = 'Pass';
        
        
        // Conditions for Unqualified
        if(personInfo.Citizenship__c =='United States'){
            auditinfo.Citizenship__c = 'Fail';
            isUnqualified = true;
        }if(personInfo.Country_of_Residence__c == 'United States' || applicantInfo.Home_Country__c == 'United States'){
            auditinfo.Residency__c = 'Fail';
            isUnqualified = true;
        }if(applicantInfo.Home_Country__c == 'United States'){
            auditinfo.Address__c = 'Fail';
            isUnqualified = true;
        }if(applicantInfo.Being_AuPair_Indicated__c=='Yes' && applicantInfo.AP_Completion_Year_Indicated__c == 'No'){
            auditinfo.Prior_Exchange__c = 'Fail';
            isUnqualified = true;
        }if(personInfo.Nationality__c.contains('American')){
            auditinfo.Nationality__c = 'Fail';
            isUnqualified = true;
        }if(AgePT >= 27 || AgePT < 16){
            auditinfo.Age__c = 'Fail';
            isUnqualified = true;
        }if(personInfo.Marital_Status__c=='Married'){
            auditinfo.Marital_Status__c = 'Fail';
            isUnqualified = true;
        }if(applicantInfo.Visa_Denied__c == 'Yes' && applicantInfo.Visa_Type__c == 'J-1'){
            auditinfo.Visa__c = 'Fail';
            isUnqualified = true;
        }if(applicantInfo.US_Passport_Indicated__c == 'Yes'){
            auditinfo.US_Passport__c = 'Fail';
            isUnqualified = true;
        }
        // Conditions for Flagged
        if((AgePT < 27 && AgePT >= 26.5) || (AgePT < 17 && AgePT >= 16)){
            auditinfo.Age__c = 'Needs Review';
            isFlagged = true;
        }if(applicantInfo.Childcare_Experience_Indicated__c=='No'){
            auditinfo.Experience__c = 'Needs Review';
            isFlagged = true;
        }if(applicantInfo.Visa_Denied__c == 'Yes' && applicantInfo.Visa_Type__c != 'J-1'){
            auditinfo.Visa__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Secondary_School_Indicated__c == 'No' && personInfo.Graduation_Date__c == null){
            auditinfo.Dates__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Offence_Indicated__c == 'Yes'){
            auditinfo.Crime_Charge__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Overall_Health__c == 'Fair' ||  personInfo.Overall_Health__c == 'Poor'){
            auditinfo.Health__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Contagious_Disease_Indicated__c == 'Yes'){
            auditinfo.Disease__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Drug_Dependency_Indicated__c == 'Yes'){
            auditinfo.Drug_Dependency__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Marital_Status__c =='Domestic Partner'){
            auditinfo.Marital_Status__c = 'Needs Review';
            isFlagged = true;
        }
        /*if(applicantInfo.Drivers_Licence_Indicated__c =='No'){
auditinfo.Driving__c = 'Needs Review';
isFlagged = true;
}*/
        if(personInfo.Physical_Disabilities_Indicated__c=='Yes'){
            auditinfo.Disability__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Pregnancy_Indicated__c == 'Yes'){
            auditinfo.Pregnant__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Medication_Indicated__c=='Yes'){
            auditinfo.Medication__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Hospitalization_Indicated__c=='Yes'){
            auditinfo.Hospitalization__c = 'Needs Review';
            isFlagged = true;
        }if(personInfo.Psychiatric_Treatment_Indicated__c=='Yes'){
            auditinfo.Psychiatric_Treatment__c = 'Needs Review';
            isFlagged = true;
        }
        
        if(isUnqualified == true){
            statusApp = 'Unqualified';
            //Setting Audit_Status__c
            auditinfo.Audit_Status__c = statusApp;
            applicantInfo.Application_Stage__c = 'Declined';
            p = Page.apc_ap_basic_completion; 
            p.getParameters().put('Id',applicantInfo.Id);
            p.getParameters().put('viewpage','true');
            p.setRedirect(true);
            system.debug('@@@@@page Unqualified: ' + p);
        }else if(isFlagged == true){
            statusApp = 'Flagged';
            //Setting Audit_Status__c
            auditinfo.Audit_Status__c = statusApp;
            applicantInfo.Application_Stage__c = 'Submitted';
            p = Page.apc_ap_basic_completion; 
            p.getParameters().put('Id',applicantInfo.Id);
            p.getParameters().put('viewpage','true');
            p.setRedirect(true);
            system.debug('@@@@@page Flagged: ' + p);    
        }else{
            statusApp = 'Qualified';
            //Setting Audit_Status__c
            auditinfo.Audit_Status__c = statusApp;
            applicantInfo.Application_Level__c = 'Main';
            p = Page.apc_ap_main_home; 
            p.getParameters().put('Id',applicantInfo.Id);
            p.getParameters().put('vstate','newprf');
            p.setRedirect(true);
            system.debug('@@@@@page Qualified: ' + p);
        }
        
        
        update applicantInfo;
        system.debug('debug::update applicantInfo 11');
        update auditinfo;
        system.debug('@@@@@statusApp: ' + statusApp);
        return p;
        
    }
    
    public PageReference QualifyPreApp(){
        
        system.debug('@@@@@inside QualifyPreApp()');
        String statusApp = 'Qualified';
        //Setting Audit_Status__c
        auditinfo.Audit_Status__c = statusApp;
        applicantInfo.Application_Level__c = 'Main';
        applicantInfo.Application_Stage__c = 'Working';
        //as per B-02518 - redirect to the list of applications
        PageReference p = new PageReference('/apex/pr_app_list');
        //PageReference p = Page.apc_ap_basic_completion;
        //PageReference p = Page.apc_ap_main_home; 
        
        //the following line was commented out as per B-02518: 
        //p.getParameters().put('Id',applicantInfo.Id);
        //p.getParameters().put('vstate','newprf');
        p.setRedirect(true);
        update applicantInfo;
        system.debug('debug::update applicantInfo 12');
        update auditinfo;
        
        return p;
    }
    
    public PageReference UnqualifyPreApp(){
        
        system.debug('@@@@@inside UnqualifyPreApp()');
        
        String statusApp = 'Unqualified';
        //Setting Audit_Status__c
        auditinfo.Audit_Status__c = statusApp;
        applicantInfo.Application_Level__c = 'Basic';
        applicantInfo.Application_Stage__c = 'Declined';
        //as per B-02518 - redirect to the list of applications
        PageReference p = new PageReference('/apex/pr_app_list');
        //PageReference p = Page.apc_ap_basic_completion;
        //PageReference p = Page.apc_ap_main_home; 

        //the following line was commented out as per B-02518: 
        //p.getParameters().put('Id',applicantInfo.Id);
        //p.getParameters().put('vstate','newprf');
        p.setRedirect(true);
        update applicantInfo;
        system.debug('debug::update applicantInfo 13');
        update auditinfo;
        
        return p;
    }
    
    //B-02336
    public PageReference sendAppToReview(){
        applicantInfo.Application_Stage__c = 'Working';
        PageReference p = Page.apc_ap_main_home;
        p.getParameters().put('Id',applicantInfo.Id);
        p.getParameters().put('IsPartner','true');
        p.setRedirect(true);
        update applicantInfo;
        system.debug('debug::update applicantInfo 14');
        return p;  
    }
    
    //B-02366
    public List<SelectOption> getCertificationType(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Nursing','Nursing'));
        options.add(new SelectOption('Child Development','Child Development')); 
        options.add(new SelectOption('First Aid','First Aid'));
        options.add(new SelectOption('Cardio Pulmonary Resuscitation (CPR)','Cardio Pulmonary Resuscitation (CPR)'));
        options.add(new SelectOption('Teaching','Teaching'));
        options.add(new SelectOption('Other','Other'));
        return options;
    }
    // END B-02366
    
    
    //Checking and setting the stage of the APC page in Multipicklists
    public void PageStatusController(){
        
        system.debug('*****@@@in PageStatusController()');
        String pageId = ApexPages.currentPage().getParameters().get('pageId');
        
        if(pageId != null){
            if(applicantinfo.PageStatus_Started__c != null && applicantinfo.PageStatus_Started__c != '' ){
                if(applicantinfo.PageStatus_Started__c.contains(pageId+';')){
                    applicantinfo.PageStatus_Started__c = applicantinfo.PageStatus_Started__c.replace(pageId+';','');       
                }else if(applicantinfo.PageStatus_Started__c.contains(pageId)){
                    applicantinfo.PageStatus_Started__c = applicantinfo.PageStatus_Started__c.replace(pageId ,'');      
                }
            }
            
            if(applicantinfo.PageStatus_Complete__c != null && applicantinfo.PageStatus_Complete__c != '' ){
                if(!applicantinfo.PageStatus_Complete__c.contains(pageId)){
                    applicantinfo.PageStatus_Complete__c = applicantinfo.PageStatus_Complete__c + ';' + pageId ;       
                }
            }else{
                
                applicantinfo.PageStatus_Complete__c = pageId;
            }
        }
    }
    
    //Checking and setting the stage of the APC page in Multipicklists for APC Essays
    /*The idea of this methos is get all corner cases where we hava to check special fields or number of records*/
    /*we create to List of Arrays to manage all this process - statusList & pageIdStList */
    public void PageStatusController(String pageIdSt){
        
        try{
            system.debug('*****@@@in PageStatusController(String pageIdSt)');
            system.debug('*****@@@pageIdSt:' + pageIdSt); 
            
            List<Boolean> statusList = new List<Boolean> { true, true };
                List<String> pageIdStList = new List<String>();
            integer counter = 0;
            
            if(pageIdSt=='001'){
                
                if(((personRole.Employer_Name__c == null || personRole.Employer_Name__c == '') && (personInfo.Marital_Status__c == 'Married' || personInfo.Marital_Status__c == 'Domestic Partner'))
                   || ((personinfo.Employer_Name__c == null || personinfo.Employer_Name__c == '') && personInfo.Marital_Status__c == 'Single') ){
                       
                       statusList[1] = false;
                   }
                
                pageIdStList.add('001');
                
                if(applicantinfo.PageStatus_Complete__c != null && applicantinfo.PageStatus_Complete__c != '' ){
                    if(applicantinfo.PageStatus_Complete__c.contains('007')){
                        pageIdStList.add('007');
                    }
                }
                
            }
            
            
            
            //check page completed for APC PT main helath info -- pageId 028
            if(pageIdSt=='028'){
                
                if(personInfo.Medical_Health_Agreement__c == false){
                    statusList[0] = false;
                }
                
                pageIdStList.add('028');
                
            }
            
            
            //check page completed for APC PT apc_ap_main_physician_form -- pageId 029
            if(pageIdSt=='029'){
                system.debug('*****@@@inside 029 Baha:');
                docType='Health';
                if(getDocList() == null || getDocList().size() == 0){
                    statusList[0] = false;
                }
                docType = null;
                pageIdStList.add('029');
                system.debug('*****@@@value of docType:' + docType); 
                
            }
            //check page completed for APC PT aapc_ap_main_visa_info -- pageId 34 
            if(pageIdSt=='034'){
                
                //docType='Passport';
                if((getDocList() == null || getDocList().size() == 0) && applicantInfo.US_Passport_Indicated__c=='No'){
                    statusList[0] = false;
                }
                docType='Participant-Photo';
                pageIdStList.add('034');
            }
            
            //AA check page completed for APC PT apc_ap_main_education_proof
            if(pageIdSt=='035'){
                
                docType='Proof-of-Education';
                if(getDocList() == null || getDocList().size() == 0){
                    statusList[0] = false;
                }
                system.debug('@@@@@statusList[0]: ' + statusList[0]);
                docType=null;
                pageIdStList.add('035');
                
            }
            
            //AA check page completed for APC PT apc_ap_main_media
            if(pageIdSt=='031'){
                system.debug('*****@@@inside 031');
                system.debug('*****@@@MapAlbumSize: ' + MapAlbumSize);
                docType='Participant-Photo';
                if(getDocList() == null || getDocList().size() == 0 || MapAlbumSize<10) {
                    statusList[0] = false;
                }
                //docType = null;
                pageIdStList.add('031');
                system.debug('*****@@@value of docType:' + statusList[0]); 
            }
            
            if(pageIdSt=='044'){
                system.debug('*****@@@inside 044');
                system.debug('*****@@@MapAlbumSize: ' + MapAlbumSize);
                system.debug('*****@@@getDocList(): ' + getDocList().size());
                docType='Participant-Photo';
                if(getDocList() == null || getDocList().size() == 0) {
                    statusList[0] = false;
                }
                //docType = null;
                pageIdStList.add('044');
                system.debug('*****@@@value of docType:' + statusList[0]); 
                
            }
            
            //AA check page completed for APC PT apc_ap_main_video
            if(pageIdSt=='036'){
                system.debug('*****@@@inside 036:' + CheckPtVideoUpdate() );
                if(CheckPtVideoUpdate() == false){
                    statusList[0] = false;
                }
                pageIdStList.add('036');
                
            }
            
            //check page completed for APC PT apc_ap_main_bgc_form -- pageId 037
            if(pageIdSt=='037'){
                system.debug('*****@@@inside 037');
                docType='BackgroundCheck';
                if(getDocList() == null || getDocList().size() == 0){
                    statusList[0] = false;
                }
                docType = null;
                pageIdStList.add('037');
                system.debug('*****@@@value of docType:' + docType); 
                
            }
            
            //B-02567 JOSE : check page completed for APC PT apc_ap_main_HEALT_REVIEW -- pageId 041
            if(pageIdSt=='041'){
                system.debug('*****@@@inside 041');
                if(DoctorFormReviewed == false || DoctorFormReviewed == null){
                    statusList[0] = false;
                }
                pageIdStList.add('041');
            }
            
            //B-02553 JOSE : check page completed for APC PT apc_ap_main_BGC_REVIEW -- pageId 046
            if(pageIdSt=='046'){
                system.debug('*****@@@inside 046');
                if(BGCFormReviewed == false || BGCFormReviewed == null){
                    statusList[0] = false;
                }
                pageIdStList.add('046');
            }
            
            //B-02556 JOSE : check page completed for APC PT apc_ap_main_Secondary_REVIEW -- pageId 047
            if(pageIdSt=='047'){
                system.debug('*****@@@inside 047');
                if(SecondaryFormReviewed == false || SecondaryFormReviewed == null){
                    statusList[0] = false;
                }
                pageIdStList.add('047');
            }
            
            //B-03073 JOSE : check page completed for APC PT apc_ap_main_misc_REVIEW -- pageId 049
            if(pageIdSt=='049'){ 
                system.debug('*****@@@inside 049 Miscellaneus Review');
                if(applicantInfo.Passport_Reviewed__c == false || applicantInfo.Driving_Reviewed__c == false || applicantInfo.Childcare_Reviewed__c == false || applicantInfo.Photos_Reviewed__c == false){
                    statusList[0] = false;
                }
                pageIdStList.add('049');
            }
            
            //check page completed for APC PT apc_ap_main_reference_interview -- pageId 038
            if(pageIdSt=='038'){
                system.debug('*****@@@inside 038');
                system.debug('*****@@@statusList[0] before : ' + statusList[0]);
                
                if(!(getPRIntvList() !=null && getPRIntvList().size()>0)){
                    statusList[0] = false;
                    statusList[1] = false;
                }else{
                    assessment=getPRIntvList()[0];
                    if(assessment.Status__c == 'Incomplete'){
                        statusList[0] = false;
                    }
                }
                pageIdStList.add('038');
                pageIdStList.add('043');
                system.debug('*****@@@statusList[0]:' + statusList[0]);
                system.debug('*****@@@statusList[0]:' + statusList[1]);
                system.debug('*****@@@assessment:' + assessment);
                //AND ( Status__c =: 'Complete' OR  Status__c =: 'Confirmed')
            }
            
            //AA Interview Status for HF
            
            if(pageIdSt=='045'){
                system.debug('*****@@@inside 045');
                system.debug('*****@@@statusList[0] before : ' + statusList[0]);
                if(!(getHFPRIntvList() !=null && getHFPRIntvList().size()>0)){
                    statusList[0] = false;
                }else{
                    assessment=getHFPRIntvList()[0];
                    system.debug('*****@@@assessment.Position_Name__r.Owner.Name' + assessment.Position_Name__r.Owner.Name);
                    if(assessment.Status__c == 'Incomplete'){
                        statusList[0] = false;
                    }
                }
                pageIdStList.add('045');
                system.debug('*****@@@statusList[0]:' + statusList[0]);
                system.debug('*****@@@assessment:' + assessment);
            }
            
            if(pageIdSt=='018'){
                
                docType='Drivers-License';
                if(getDocList() == null || getDocList().size() == 0){
                    statusList[0] = false;
                }
                docType=null;
                pageIdStList.add('018');
                
            }
            
            if(pageIdSt=='020'){
                
                if(docListSchool.size() == 0){
                    statusList[0] = false;
                }
                pageIdStList.add('020');
            }
            
            //Conditions for APC PT Personal References when we cancel the Reference
            if(pageIdSt=='025'){
                statusList[0] = false;
                pageIdStList.add('025');
                
            }
            
            //check page completed for APC PT main references and experiences -- pageId 21 & 25
            if(pageIdSt=='021'){
                
                list<Experience__c> listExperienceChildAux21 = [SELECT exp.ID, exp.Name, exp.IsReference__c
                                                                FROM Experience__c exp WHERE exp.Applicant_Info__c = :applicantInfo.Id AND IsReference__c = true
                                                                AND (exp.Experience_Type__c != 'Sibling/Family') AND (exp.Experience_Category__c =: 'Private/Individual' OR exp.Experience_Category__c =: 'Public/Group')]; 
                
                if(listExperienceChildAux21.size() < 2){
                    statusList[0] = false;
                }
                system.debug('*****@@@@@inside 021');
                system.debug('*****@@@@@listExperienceChildAux21.size(): ' + listExperienceChildAux21.size());
                /*
if(listExperienceChildAux21.size()>0 && listExperienceChildAux21 != null){
for (Experience__c exper:listExperienceChildAux21){
if(exper.IsReference__c == true){
counter++;                        
}
} 
}

if(counter >= 2){
if(personInfoReferList != null){
if(personInfoReferList[0].First_Name__c == null){
statusList[1] = false;
}
}else{
statusList[1] = false;
}
}else{
statusList[1] = false;
}
*/
                //Add References and Experience Id page in the Array
                pageIdStList.add('021');
                //pageIdStList.add('025');
                
                
            }else if(pageIdSt=='026'){
                system.debug('*****@@@inside 026');
                for(integer i=0; i<essayList.size();i++){
                    //This is ultra hardcoded coz in AP APC Original we have some corner cases rendering or not an Essay
                    
                    if(applicantInfo.Application_Type__c=='Original' || applicantInfo.Application_Type__c=='Rematch'){
                        if((essayList[i].Narrative__c == null) || (string.isblank(essayList[i].Narrative__c))) {
                            if(i==2 && applicantinfo.US_Experience_Indicated__c == 'No'){
                            }else{
                                statusList[0] = false;
                                break;
                            }
                        }
                    }else if(applicantInfo.Application_Type__c=='Renewal'){
                        if((essayList[i].Narrative__c == null) || (string.isblank(essayList[i].Narrative__c))) {
                            
                            if(essayList[i].Ordinal__c == 16){
                            }else{
                                statusList[0] = false;
                                break;
                            }
                        }
                    }else{
                        if((essayList[i].Narrative__c == null) || (string.isblank(essayList[i].Narrative__c))) {
                            statusList[0] = false;
                            break;
                        }
                    }
                }
                //Add Essays Id page in the Array
                pageIdStList.add('026');
                
            }
            
            
            //checking if there is any value in "PageStatus_Started__c" and remove the current pageIdSt value (page)
            for (Integer i = 0; i < pageIdStList.size(); i++) {
                
                if(applicantinfo.PageStatus_Started__c != null && applicantinfo.PageStatus_Started__c != '' ){
                    if(applicantinfo.PageStatus_Started__c.contains(pageIdStList[i]+';') && statusList[i] == true){
                        system.debug('*****@@@point01');
                        applicantinfo.PageStatus_Started__c = applicantinfo.PageStatus_Started__c.replace(pageIdStList[i]+';','');     
                        
                    }else if(applicantinfo.PageStatus_Started__c.contains(pageIdStList[i]) && statusList[i] == true){
                        system.debug('*****@@@point02');
                        applicantinfo.PageStatus_Started__c = applicantinfo.PageStatus_Started__c.replace(pageIdStList[i],'');     
                    }
                }
                
                //checking if there is any value in "PageStatus_Completed__c" and add the current "pageIdStList[i]" value (page) or remove it if "status" is false. 
                if(applicantinfo.PageStatus_Complete__c != null && applicantinfo.PageStatus_Complete__c != ''){
                    if(!applicantinfo.PageStatus_Complete__c.contains(pageIdStList[i]) && statusList[i] == true){
                        applicantinfo.PageStatus_Complete__c = applicantinfo.PageStatus_Complete__c + ';' + pageIdStList[i] ;      
                        
                    }else if(applicantinfo.PageStatus_Complete__c.contains(pageIdStList[i]+';') && statusList[i] == false){
                        system.debug('*****@@@point1');
                        applicantinfo.PageStatus_Complete__c = applicantinfo.PageStatus_Complete__c.replace(pageIdStList[i]+';','');
                        if(applicantinfo.PageStatus_Started__c != null && applicantinfo.PageStatus_Started__c != '' ){
                            applicantinfo.PageStatus_Started__c = applicantinfo.PageStatus_Started__c + ';' + pageIdStList[i] ;
                        }else{
                            applicantinfo.PageStatus_Started__c = pageIdStList[i];          
                        }
                        
                    }else if(applicantinfo.PageStatus_Complete__c.contains(pageIdStList[i]) && statusList[i] == false){
                        system.debug('*****@@@point2');
                        applicantinfo.PageStatus_Complete__c = applicantinfo.PageStatus_Complete__c.replace(pageIdStList[i],'');
                        if(applicantinfo.PageStatus_Started__c != null && applicantinfo.PageStatus_Started__c != '' ){
                            applicantinfo.PageStatus_Started__c = applicantinfo.PageStatus_Started__c + ';' + pageIdStList[i] ;
                        }else{
                            applicantinfo.PageStatus_Started__c = pageIdStList[i];          
                        }      
                    }
                    
                }else{
                    system.debug('*****@@@point3');
                    if(statusList[i] == true)
                        applicantinfo.PageStatus_Complete__c = pageIdStList[i];
                }
                
                system.debug('@@@@@applicantinfo.PageStatus_Complete__c: ' + applicantinfo.PageStatus_Complete__c);
                
                if( pageIdSt=='029' || pageIdSt=='018' ||pageIdSt=='034'||pageIdSt=='020'|| pageIdSt=='036' ||  
                   pageIdSt=='031' || pageIdSt=='035'||pageIdSt=='021' || pageIdSt=='025' || pageIdSt=='037' || pageIdSt=='038'||pageIdSt=='044'||pageIdSt=='045'){
                       update applicantinfo;
                   }
                
            } //en for (Integer i = 0; i < pageIdStList.size(); i++) 
            
        }catch(Exception e){
            system.debug('*****@@@ Exception in PageStatusController: ' + e);
        }
        
    }
    
    //#############APC Methods to control Add-Removing records in accordeon tables###########
    
    //#####Begining code APC
    
    //AA APC DocuSigned outside the Constructor
    
    public string msgDisplay{get;set;}
    public PageReference MethodAPCTCFinal()
    {
        //PageReference P = Page.apc_hf_app_agreements;
        PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
        String retDsURL = ApexPages.currentPage().getUrl(); 
        If(retDsURL.contains('event')){
            
            msgDisplay = '';
            string AIDstr = System.currentPageReference().getParameters().get('ObjId');
            string eventstr = System.currentPageReference().getParameters().get('event');
            string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
            
            if (eventstr  == 'SignComplete')
            {
                try
                {
                    
                    Docusign_helper.updApp(AIDstr);
                    applicantinfo.Terms_Accepted__c= True;
                    msgDisplay = 'Signed';
                }
                catch (Exception ex)
                {
                    System.debug('An exception occurred: ' + ex.getMessage());
                    msgDisplay = 'We are currently experiencing technical difficulties. Please try again later.';
                }
                
            }
            else if (eventstr  == 'ViewComplete')
            {
                msgDisplay = 'Viewed';
            }
            else if (eventstr  == 'Cancel')
            {
                msgDisplay = 'Cancelled';
            }
            else if (eventstr  == 'Decline')
            {
                msgDisplay = 'Declined';
            }
            else
            {
                msgDisplay = 'Exception';
            }
        }
        return pageRef; 
    }
    
    public void delWrapper(){
        
        //system.debug('*****#### toDelIdent: ' + toDelIdent);
        
        Integer toDelPos=-1;
        
        for (Integer idx=0; idx<wrappers.size(); idx++){
            
            if (wrappers[idx].ident==toDelIdent){
                
                toDelPos=idx;
            }
        }
        
        if (-1!=toDelPos){
            
            if(wrappers[toDelPos].personInfoChild.Id != null){
                
                delete wrappers[toDelPos].personInfoChild;
                
            }
            
            wrappers.remove(toDelPos);
            
            
        }
        wrappersize=wrappers.size();
        //system.debug('*****#### wrappers.size(): ' + wrappers.size());
        //system.debug('*****#### wrappers: ' + wrappers);
        //system.debug('*****#### : nextIdent ' + nextIdent);
        
    }
    
    public void addRows(){
        
        
        for (Integer idx=0; idx<addCount; idx++){
            
            PersonInfoChildWrapper child = new PersonInfoChildWrapper(nextIdent++);
            child.personInfoChild.Applicant_Info__c = applicantInfo.Id;
            wrappers.add(child);
            system.debug('*****####Onto addrow loop');
            
        }
        wrappersize=wrappers.size();
        
        system.debug('*****#### (addrow Loop)wrappers.size(): ' + wrappers.size());
        
    }
    
    public void saveChildren(){
        
        try{
            
            List<Person_Info__c> personInfoChilds = new List<Person_Info__c>();
            for (PersonInfoChildWrapper wrap : wrappers){
                
                personInfoChilds.add(wrap.personInfoChild);
            }
            
            upsert personInfoChilds;
            //return new PageReference('/' + Schema.getGlobalDescribe().get('Account').getDescribe().getKeyPrefix() + '/o');
            
        }catch(Exception e){
            
            system.debug(' ******** Imposible to create a personInfoChild ');
        }
        
    }
    
    // Parent List Method for PT APC POrtal
    
    public void delWrapperPar(){
        
        system.debug('*****#### toDelIdent: ' + toDelIdent);
        
        Integer toDelPos=-1;
        
        for (Integer idx=0; idx<wrappersParent.size(); idx++){
            
            if (wrappersParent[idx].ident==toDelIdent){
                
                toDelPos=idx;
            }
        }
        
        if (-1!=toDelPos){
            
            if(wrappersParent[toDelPos].personInfoParent.Id != null){
                
                delete wrappersParent[toDelPos].personInfoParent;
                
            }
            
            wrappersParent.remove(toDelPos);
            addEmergContact();
            
            
        }
        wrapperParsize=wrappersParent.size();
        system.debug('*****#### wrappersParent.size(): ' + wrappersParent.size());
        system.debug('*****#### wrappersParent: ' + wrappersParent);
        system.debug('*****#### : nextIdent ' + nextIdent);
        
    }
    
    public void addRowsPar(){
        
        
        for (Integer idx=0; idx<addCount; idx++){
            
            PersonInfoParentWrapper parent = new PersonInfoParentWrapper(nextIdent++);
            parent.personInfoParent.Applicant_Info__c = applicantInfo.Id;
            wrappersParent.add(parent);
            system.debug('*****####Onto addrow loop');
            
        }
        wrapperParsize=wrappersParent.size();
        addEmergContact();
        
        system.debug('*****#### (addrow Loop)wrappersParent.size(): ' + wrappersParent.size());
    }
    
    //AA APC Family/Sibling Method for PT APC Portal
    //Starts
    public void delWrapperFamily(){
        
        system.debug('*****#### toDelIdent: ' + toDelIdent);
        
        Integer toDelPos=-1;
        
        for (Integer idx=0; idx<wrappersFamily.size(); idx++){
            
            if (wrappersFamily[idx].ident==toDelIdent){
                
                toDelPos=idx;
            }
        }
        
        if (-1!=toDelPos){
            
            if(wrappersFamily[toDelPos].personInfoFamily.Id != null){
                
                delete wrappersFamily[toDelPos].personInfoFamily;
                
            }
            
            wrappersFamily.remove(toDelPos);
            addEmergContact();
            
            
            if(wrappersFamily.size() == 0){
                addsibling = false;
            }
            
            
        }
        wrapperFamsize=wrappersFamily.size();
        system.debug('*****#### wrappersFamily.size(): ' + wrappersFamily.size());
        system.debug('*****#### wrappersFamily: ' + wrappersFamily);
        system.debug('*****#### : nextIdent ' + nextIdent);
        
    }
    //Ends
    
    //AA APC Family
    //Start
    public void addRowsParfamily(){
        
        
        for (Integer idx=0; idx<addCount; idx++){
            
            PersonInfoFamilyWrapper Family = new PersonInfoFamilyWrapper(nextIdent++);
            Family.personInfoFamily.Applicant_Info__c = applicantInfo.Id;
            wrappersFamily.add(Family);
            system.debug('*****####Onto addrow loop');
            
        }
        wrapperFamsize=wrappersFamily.size();
        addEmergContact();
        
        system.debug('*****#### (addrow Loop)wrappersFamily.size(): ' + wrappersFamily.size());
    }
    //Ends
    public void saveParents(){
        
        List<Person_Info__c> personInfoParents = new List<Person_Info__c>();
        for (PersonInfoParentWrapper wrap : wrappersParent){
            
            wrap.personInfoParent.Name = wrap.personInfoParent.First_Name__c +' '+ wrap.personInfoParent.Last_Name__c;
            personInfoParents.add(wrap.personInfoParent);
            
            //Setting the gender of the APC Role='Parent'
            if(wrap.personInfoParent.Family_Role__c=='Father'){
                wrap.personInfoParent.Gender__c = 'Male';
            }else if(wrap.personInfoParent.Family_Role__c=='Mother'){
                wrap.personInfoParent.Gender__c = 'Female';
            }else if(wrap.personInfoParent.Family_Role__c=='GrandFather'){
                wrap.personInfoParent.Gender__c = 'Male';
            }else if(wrap.personInfoParent.Family_Role__c=='GrandMother'){
                wrap.personInfoParent.Gender__c = 'Female';
            }else if(wrap.personInfoParent.Family_Role__c=='Other'){
                wrap.personInfoParent.Gender__c = 'Male';
            }
        }
        
        upsert personInfoParents;
        
        //return new PageReference('/' + Schema.getGlobalDescribe().get('Account').getDescribe().getKeyPrefix() + '/o');
    }
    
    //AA APC Family/Sibling
    //Starts
    public void saveFamily(){
        
        List<Person_Info__c> personInfofamily = new List<Person_Info__c>();
        for (PersonInfofamilyWrapper wrap : wrappersfamily){
            
            wrap.personInfofamily.Name = wrap.personInfofamily.First_Name__c; //+' '+ wrap.personInfofamily.Last_Name__c;
            personInfofamily.add(wrap.personInfofamily);
        }
        
        upsert personInfofamily;
        
        //return new PageReference('/' + Schema.getGlobalDescribe().get('Account').getDescribe().getKeyPrefix() + '/o');
    }
    //Ends 
    public void delWrapperExp(){
        
        system.debug('*****#### toDelIdent: ' + toDelIdent);
        
        Integer toDelPos=-1;
        
        try{
            for (Integer idx=0; idx<wrappersExp.size(); idx++){
                
                if (wrappersExp[idx].ident==toDelIdent){
                    
                    toDelPos=idx;
                }
            }
            
            if (-1!=toDelPos){
                
                if(wrappersExp[toDelPos].ExperienceDetailChild.Id != null){
                    
                    delete wrappersExp[toDelPos].ExperienceDetailChild;
                    
                }
                
                wrappersExp.remove(toDelPos);
                
                
            }
            wrapperExpsize=wrappersExp.size();
            system.debug('*****#### wrappersExp.size(): ' + wrappersExp.size());
            system.debug('*****#### wrappersExp: ' + wrappersExp);
            system.debug('*****#### : nextIdentExp ' + nextIdentExp);
            
        }catch(Exception e){
            system.debug(' ******** Impossible delete an Deatil Experience record ');
        }
        
    }
    
    public void addRowsExp(){
        
        
        for (Integer idx=0; idx<addCount; idx++){
            
            ExperienceDetailWrapper expertDet = new ExperienceDetailWrapper(nextIdentExp++);
            wrappersExp.add(expertDet);
            system.debug('*****####Onto addrow loop wrappersExp');
            
        }
        wrapperExpsize=wrappersExp.size();
        
        system.debug('*****#### (addrow Loop)wrappers.size(): ' + wrappersExp.size());
        
    }
    
    public void saveExperienceDet(){
        
        list<list<Decimal>> listAgeRange = new list<list<Decimal>>();
        list<Decimal> listAux;
        
        Boolean child_U2Flag = false;
        Boolean over_End = false;
        Decimal countYearsStart = 0;
        Decimal countYearsEnd = 0;
        Decimal countYearsStartAux;
        Integer totalPeriod;
        Integer timeUp;
        Integer timeDown; 
        Boolean zone1;
        Boolean zone2;
        Boolean zone3;
        Set<Integer> listAuxU2 = new Set<Integer>();
        
        try{
            List<Experience_Detail__c> ExperienceDetailChildren = new List<Experience_Detail__c>();
            totalPeriod = experience.Start_Date__c.daysBetween(experience.End_Date__c);
            system.debug('*****wrappersExp: ' + wrappersExp);
            
            //we define 5 age ranges: 1(0 - 1), 2(1 - 2), 3(3 - 6), 4(6 - 10), 5(10 +)
            
            for (ExperienceDetailWrapper wrap : wrappersExp){
                
                zone1 = false;
                zone2 = false;
                zone3 = false;
                
                listAux = new list<Decimal>();
                //age of each child at the end of the job
                countYearsEnd = Math.Floor(wrap.ExperienceDetailChild.Date_of_Birth__c.daysBetween(experience.End_Date__c)/365.2425);
                
                //Setting Experecience Lookup Field
                if(wrap.ExperienceDetailChild.Experience_Name__c == null){
                    wrap.ExperienceDetailChild.Experience_Name__c = experience.id; 
                }
                
                if (wrap.ExperienceDetailChild.Date_of_Birth__c < experience.Start_Date__c){
                    countYearsStart = Math.Floor(wrap.ExperienceDetailChild.Date_of_Birth__c.daysBetween(experience.Start_Date__c)/365.2425);
                }else if(wrap.ExperienceDetailChild.Date_of_Birth__c >= experience.Start_Date__c && 
                         wrap.ExperienceDetailChild.Date_of_Birth__c < experience.End_Date__c){
                             child_U2Flag = true;
                             countYearsStart = 0;
                         }else{
                             over_End = true;
                             listAux=null;
                             countYearsEnd = 0;
                         }
                
                system.debug('@@@@@ countYearsStart: ' + countYearsStart);
                system.debug('@@@@@ countYearsEnd: ' + countYearsEnd);
                system.debug('@@@@@ Date_of_Birth__c: ' + wrap.ExperienceDetailChild.Date_of_Birth__c);
                
                if(countYearsStart < 2 && over_End == false){
                    child_U2Flag = true;
                    system.debug('@@@@@ This child is Under 2');
                    
                }
                if(over_End == false){
                    for (Decimal pos = countYearsStart; pos <= countYearsEnd; pos++){
                        listAux.add(pos);   
                    } 
                }
                
                system.debug('@@@@@ listAux inside loop: ' + listAux);
                if(listAux != null){
                    listAgeRange.add(listAux);
                }
                ExperienceDetailChildren.add(wrap.ExperienceDetailChild);
                
                //******code for Under2Hours
                countYearsStartAux = Math.Floor(wrap.ExperienceDetailChild.Date_of_Birth__c.daysBetween(experience.Start_Date__c)/365.2425);
                
                
                if(wrap.ExperienceDetailChild.Date_of_Birth__c < experience.Start_Date__c && countYearsStartAux < 2){
                    if(wrap.ExperienceDetailChild.Date_of_Birth__c.addYears(2) >= experience.End_Date__c ){
                        timeUp = experience.Start_Date__c.daysBetween(experience.End_Date__c);  
                    }else{
                        timeUp = experience.Start_Date__c.daysBetween(wrap.ExperienceDetailChild.Date_of_Birth__c.addYears(2));     
                    }
                    zone1 = true;
                }else if(wrap.ExperienceDetailChild.Date_of_Birth__c > experience.Start_Date__c &&
                         wrap.ExperienceDetailChild.Date_of_Birth__c.addYears(2) < experience.End_Date__c){
                             
                             timeDown = (totalPeriod + 1) - wrap.ExperienceDetailChild.Date_of_Birth__c.daysBetween(experience.End_Date__c);
                             timeUp = totalPeriod - wrap.ExperienceDetailChild.Date_of_Birth__c.addYears(2).daysBetween(experience.End_Date__c);
                             zone2 = true;       
                         }else if(wrap.ExperienceDetailChild.Date_of_Birth__c < experience.End_Date__c && countYearsEnd < 2 ){
                             timeDown = (totalPeriod + 1) - wrap.ExperienceDetailChild.Date_of_Birth__c.daysBetween(experience.End_Date__c); 
                             zone3 = true;       
                         } 
                
                if(zone1 == true){
                    for (Integer i = 1; i <= timeUp; i++){
                        listAuxU2.add(i);
                    }
                    system.debug('@@@@@ listAuxU2 zone 1: ' +listAuxU2); 
                }else if(zone2 == true){
                    for (Integer i = timeDown; i <= timeUp; i++){
                        listAuxU2.add(i);   
                    }
                    system.debug('@@@@@ listAuxU2 zone 2: ' +listAuxU2); 
                }else if(zone3 == true){
                    for (Integer i = timeDown; i <= totalPeriod; i++){
                        listAuxU2.add(i);   
                    }
                    system.debug('@@@@@ listAuxU2 zone 3: ' +listAuxU2); 
                } 
                //*****END
                
            }//**END FOR
            system.debug('@@@@@ listAuxU2: ' +listAuxU2);
            system.debug('@@@@@ listAgeRange outside loop: ' + listAgeRange);
            
            //Setting age ranges to false
            Boolean range0_1 = false;
            Boolean range1_2 = false;
            Boolean range3_5 = false;
            Boolean range6_10 = false;
            Boolean range10 = false;
            experience.Children_Ages__c = '';
            
            //we define 5 age ranges: 1(0 - 1), 2(1 - 2), 3(3 - 5), 4(6 - 10), 5(10 +)
            for(list<Decimal> lar:listAgeRange){
                for(Decimal l:lar){
                    if(l>=0 && l<1){
                        range0_1 = true;
                    }else if(l>=1 && l<3){
                        range1_2 = true;
                    }else if(l>=3 && l<6){
                        range3_5 = true;
                    }else if(l>=6 && l<10){
                        range6_10 = true;
                    }else if(l>=10){
                        range10 = true;
                    }
                }
            }
            
            //Setting experience.Children_Ages__c 
            
            if(range0_1 == true){
                experience.Children_Ages__c += '0 - 1' + ';';
            }if(range1_2 == true){
                experience.Children_Ages__c += '1 - 2' + ';';
            }if(range3_5 == true){
                experience.Children_Ages__c += '3 - 5' + ';';
            }if(range6_10 == true){
                experience.Children_Ages__c += '6 - 10' + ';';
            }if(range10 == true){
                experience.Children_Ages__c += '10 +' + ';';
            }
            
            system.debug('@@@@@ experience.Children_Ages__c: ' + experience.Children_Ages__c);
            
            //if any of the children is under the age of  2, add 100% of the total hours to U" total hours
            Decimal PercentU2;
            Decimal TotalhoursU2;
            system.debug('@@@@@ listAuxU2.size(): ' + listAuxU2.size());
            system.debug('@@@@@ totalPeriod: ' + totalPeriod);
            
            if(child_U2Flag){
                Decimal totaldays = listAuxU2.size();
                PercentU2 = totaldays.divide(totalPeriod, 3);
                TotalhoursU2 =  experience.Amount_Hours__c * PercentU2;
                experience.Amount_Hours_Under_2__c= TotalhoursU2;
                system.debug('@@@@@ PercentU2: ' + PercentU2);
                system.debug('@@@@@ experience.Amount_Hours__c: ' + experience.Amount_Hours__c);
                system.debug('@@@@@ TotalhoursU2: ' + TotalhoursU2);
            }else{
                experience.Amount_Hours_Under_2__c= 0;
            }
            
            //updating Experience
            upsert experience;
            
            //updating Experience_Detail
            upsert ExperienceDetailChildren;
            
        }catch(Exception e){
            system.debug(' ******** Impossible create an Experience record: ' + e);
        }
        
        //return new PageReference('/' + Schema.getGlobalDescribe().get('Account').getDescribe().getKeyPrefix() + '/o');
    }
    
    public void addEmergContact(){
        
        addEmergency=false;
        
        if(wrappersParent.size()==1 && wrappersParent[0].personInfoParent.Emergency_Contact_Indicated__c == 'No'){
            
            addEmergency=true;
            
        }else if(wrappersParent.size()==2){
            
            system.debug('*****## wrappersParent.size() (EMER):' + wrappersParent.size());
            
            if(wrappersParent[0].personInfoParent.Emergency_Contact_Indicated__c == 'No' && wrappersParent[1].personInfoParent.Emergency_Contact_Indicated__c == 'No'){
                
                addEmergency = true;
                system.debug('*****## addEmergency:' + addEmergency);
                
            }
        }
    }
    
    // B-01236 - IGI --> redirection for internal users in order to complete PT applications
    public pageReference login_redirect_internal(){
        system.debug('****** Aplication ID: ' + ApexPages.CurrentPage().getParameters().get('Id'));
        
        Applicant_Info__c appInfo = [SELECT Id, Allow_Intrax_to_Apply__c FROM Applicant_Info__c WHERE Id =: ApexPages.CurrentPage().getParameters().get('Id')];
        
        PageReference P;
        if(appInfo.Allow_Intrax_To_Apply__c == true){
            P = new PageReference('/apex/igi_pt_app_personal_info?Id='+appInfo.Id);
        }else{
            P = new PageReference('/apex/delegate_app_completion?Id='+appInfo.Id);
            
        }
        return P;
    }
    
    // #Parent List Method for PT APC POrtal
    //#####EnD Code APC
    public PageReference login_redirect(){
        
        User user = [Select Id, ContactId,Type__c,Intrax_Id__c, User_Interests__c, Contact.AccountId, Email from User where Id =: UserInfo.getUserId()];
        
        system.debug('*****### into the apcredirect()');
        
        PageReference P = Page.your_applications; 
        String appType;
        
        if(user.User_Interests__c == 'Hosting an au pair'){
            appType = 'APCHF';
            personInfo.role__c = 'Host';
            personInfo.RecordTypeId = constants.APC_Host_Primary_Record_Type_Id; 
            P = Page.apc_hf_app_personal_info; 
        }else if(user.User_Interests__c == 'Becoming an au pair'){
            appType = 'APCPT';
            personInfo.role__c = 'Participant';
            personInfo.RecordTypeId = constants.APC_Participant_Record_Type_Id;
            P = Page.apc_ap_basic_personal_info; 
        }else if(user.User_Interests__c == 'Finding an internship'){
            appType = 'IGI';
            personInfo.role__c = 'Student';
        }
        
        saveApplication(appType);
        savePersonInfo();
        
        if(user.User_Interests__c == 'Finding an internship'){
            Applicant_Info__c app = [SELECT Id, Apply_on_behalf_of_PT__c FROM Applicant_Info__c WHERE Id =: applicantInfo.Id];
            if(app.Apply_on_Behalf_of_PT__c == true){
                P = Page.delegate_app_completion;
            }else{
                P = Page.igi_pt_app_personal_info;
            }
        }
        //prepopulate 2 peron Info records as reference in the brand new HF APC application
        if(user.User_Interests__c == 'Hosting an au pair'){
            savePersonInfoReferNew();   
        }else if(user.User_Interests__c == 'Becoming an au pair'){
            //prepopulate 1 peron Info records as reference in the brand new PT APC application
            savePersonInfoReferPTNew(); 
        }
        system.debug('*****### application ID before redirect: ' + applicantInfo.Id);
        
        P.getParameters().put('id', applicantInfo.Id);
        //P.getParameters().put('role', 'Host');
        P.setRedirect(true);
        return P;
        
    } 
    
    //#####APC Code  
    
    //Prepopulate the value of two new person info references for APC HF
    public void savePersonInfoReferNew() {
        
        list<Person_Info__c> PersonInfoReferList = new list<Person_Info__c>();
        Person_Info__c personInfoRef1 = new Person_Info__c(Name = 'Reference 1', Role__c = 'Reference', Reference_Contact_Requested__c = 'Yes',
                                                           Reference_Request_Note__c = 'Hello, we are applying to host an au pair with AuPairCare. Please be our reference. Thank you!', Applicant_Info__c = applicantInfo.Id, RecordTypeId = constants.APC_Reference_Record_Type_Id );
        PersonInfoReferList.add(personInfoRef1);
        Person_Info__c personInfoRef2 = new Person_Info__c(Name = 'Reference 2', Role__c = 'Reference', Reference_Contact_Requested__c = 'Yes',
                                                           Reference_Request_Note__c = 'Hello, we are applying to host an au pair with AuPairCare. Please be our reference. Thank you!',  Applicant_Info__c = applicantInfo.Id, RecordTypeId = constants.APC_Reference_Record_Type_Id);
        PersonInfoReferList.add(personInfoRef2);
        
        try{
            upsert PersonInfoReferList;
            
        }catch(Exception e){
            system.debug('*****###Problem trying to create/update person Role Reference:' + e );
        }
        
    }
    
    //Prepopulate the value a new person info references for APC PT
    public void savePersonInfoReferPTNew() {
        
        Person_Info__c personInfoRef1 = new Person_Info__c(Name = 'Reference 1', Role__c = 'Reference', Reference_Contact_Requested__c = 'Yes', Applicant_Info__c = applicantInfo.Id, RecordTypeId = constants.APC_Reference_Record_Type_Id);
        try{
            upsert personInfoRef1;
            system.debug('*****@@@personInfoRef1: ' + personInfoRef1);
            
        }catch(Exception e){
            system.debug('*****###Problem trying to create/update person Role Reference:' + e );
        }
        
    }
    
    //####EnD APC CODE
    
    //Save personRole APC
    public void savePersonRole(String rolePerson){
        try{
            system.debug(' ******** Into savePersonRole()');
            system.debug(' *****###rolePerson: ' + rolePerson);
            personRole.Applicant_Info__c = applicantInfo.Id;
            personRole.Name = personRole.First_Name__c + ' '+ personRole.Last_Name__c;
            system.debug(' *****###personInfo.Marital_Status__c: ' + personInfo.Marital_Status__c);
            
            if((personInfo.Marital_Status__c == 'Married' || personInfo.Marital_Status__c == 'Domestic Partner') && rolePerson == 'Spouse or Partner'){
                personRole.Role__c = 'Spouse or Partner';
                personRole.Family_Member__c =  true;
                personRole.RecordTypeId = constants.APC_Spouse_Record_Type_Id;
            }else if(rolePerson == 'Host'){
                //
                personRole.Role__c = 'Host';
                personRole.RecordTypeId = constants.APC_Host_Record_Type_Id;
            }
            
            upsert personRole;
        }catch(Exception e){
            system.debug(' ******** IMPOSIBLE TO CREATE A PersonRole');
        }
    }
    
    //Save PersonEmergency APC
    public void savePersonEmergency(){
        try{
            
            system.debug(' ******** Into savePersonEmergency()');
            personEmergency.Applicant_Info__c = applicantInfo.Id;
            personEmergency.Name = personEmergency.First_Name__c + ' '+ personEmergency.Last_Name__c;
            personEmergency.Emergency_Contact__c = 'Yes';
            personEmergency.Emergency_Contact_Indicated__c = 'Yes';
            personEmergency.Role__c = 'Other';
            personEmergency.RecordTypeId = constants.APC_Other_Record_Type_Id;
            upsert personEmergency;
            
        }catch(Exception e){
            system.debug(' ******** IMPOSIBLE TO CREATE A personEmergency');
        }
    }
    
    public PageReference deleteExperienceAPC() {
        
        //Location Instance
        Experience__c ExperienceInstance;
        
        //Check for Null
        if(ExperienceId != null) {
            
            list<Reference__c> refAuxList = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
                                             Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId,
                                             Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c, CreatedDate 
                                             from Reference__c where Experience_Name__c =: experienceId AND Reference_Status__c = 'Active' limit 1];
            
            if(refAuxList!=null && refAuxList.size()>0){
                refAuxList[0].Reference_Status__c = 'Canceled';
                update refAuxList[0];
            }
            //Create a Map
            Map<Id, Experience__c> mapExperience = new Map<Id, Experience__c>(listExperience);
            
            //Delete experience form database
            Database.delete(Id.valueOf(experienceId), true);
            
            //Remove from Map
            mapExperience.remove(Id.valueOf(experienceId));
            
            //Put data back in list
            listExperience = mapExperience.values();
            
            PageStatusController(ApexPages.currentPage().getParameters().get('pageId'));
            
            update applicantinfo;
            
            PageReference p = new pageReference('/apex/apc_ap_main_experience?id=' + applicantInfo.Id);
            p.setRedirect(true);
            return p;
            
        }else{
            
            return null;
            
        }
    }
    
    
    public PageReference deleteReferenceAPC() {
        system.debug('@@@@@inside deleteReferenceAPC()');
        //Check for Null
        if(ExperienceId != null && ReferenceId !=null) {
            
            //Database.delete(Id.valueOf(ReferenceId), true);
            
            experience.isReference__c= false;
            reference.Reference_Status__c = 'Canceled';
            
            update experience;
            update reference;
            
            PageStatusController('021');
            
            PageReference p = new pageReference('/apex/apc_ap_main_add_childcare_experience?id=' + applicantInfo.Id + '&eid=' + ExperienceId );
            p.setRedirect(true);
            return p;
            
        }else{
            
            return null;
            
        }
    }
    
    public PageReference deletePersonReferenceAPC() {
        
        //Check for Null
        //if(personInfoReferList != null && ReferenceId !=null) {
        if(ReferenceId !=null) {
            
            //Database.delete(Id.valueOf(ReferenceId), true);
            
            //personInfoReferList[0].isReference__c= false;
            reference.Reference_Status__c = 'Canceled';
            
            //update experience;
            update reference;
            
            PageStatusController('025');
            
            PageReference p = new pageReference('/apex/apc_ap_main_references?id=' + applicantInfo.Id);
            p.setRedirect(true);
            return p;
            
        }else{
            
            return null;
            
        }
    }
    
    public void syncAPCHFtoPT(){
        
        list<Applicant_Info__c> SelectAPapp = new list<Applicant_Info__c>(); 
        list<Match__c> matchPT = [Select Id, Engagement__c, Start_Date__c,Arrival_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c 
                                  from Match__c WHERE Position_Name__c =: applicantInfo.Position__c AND Status__c = 'Requested' ORDER BY CreatedDate DESC];  
        system.debug('@@@@@matchPT: ' + matchPT);
        
        if(matchPT!=null && matchPT.size()>0){
            SelectAPapp = [SELECT Extension_Length__c, Extension_DOS_Fee_Indicated__c, CreatedBy__c FROM Applicant_Info__c WHERE Engagement__c =: matchPT[0].Engagement__c AND Application_Stage__c = 'Working' ORDER BY CreatedDate DESC];
            system.debug('@@@@@SelectAPapp: ' + SelectAPapp);
            if(SelectAPapp != NULL && SelectAPapp.size() > 0){
                SelectAPapp[0].Extension_Length__c = applicantInfo.Extension_Length__c;
                SelectAPapp[0].Extension_DOS_Fee_Indicated__c = applicantInfo.Extension_DOS_Fee_Indicated__c;
                upsert SelectAPapp[0];
            }
            If(matchPT[0].Arrival_Date__c != null){
                system.debug('@@@@@Extension_Length__c ' + SelectAPapp);
                matchPT[0].Match_Date__c=System.Today();
                matchPT[0].Start_Date__c=matchPT[0].Arrival_Date__c;
                //If(SelectAPapp[0].Extension_Length__c=='12')matchPT[0].End_Date__c=matchPT[0].Arrival_Date__c + 365;
                If(SelectAPapp[0].Extension_Length__c=='12')matchPT[0].End_Date__c=matchPT[0].Arrival_Date__c.addMonths(12);
                If(SelectAPapp[0].Extension_Length__c=='9')matchPT[0].End_Date__c=matchPT[0].Arrival_Date__c.addMonths(9);
                If(SelectAPapp[0].Extension_Length__c=='6')matchPT[0].End_Date__c=matchPT[0].Arrival_Date__c .addMonths(6);
                
                update matchPT[0];
                
                List<Engagement__c> engList = [SELECT Id,In_Country__c,Engagement_Start__c,Engagement_end__c
                                               FROM Engagement__c WHERE Id=:matchPT[0].Engagement__c LIMIT 1];
                if(engList!=null && engList.size()>0)
                {
                    engList[0].Engagement_Start__c = matchPT[0].start_date__c;
                    engList[0].Engagement_end__c = matchPT[0].End_date__c;
                }
                update engList[0];
            }
        }
        
    }
    
    //JOSE - Retreiving the PT name for the HF extension Preference page
    public String getAPCPtName(){
        
        String notFound = 'Participant not found';
        list<Applicant_Info__c> SelectAPapp = new list<Applicant_Info__c>(); 
        list<Match__c> matchPT = [Select Id, Engagement__c, Start_Date__c, End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.Engagement_Start__c, Status__c, Engagement__r.Account_Id__c 
                                  from Match__c WHERE Position_Name__c =: applicantInfo.Position__c ORDER BY CreatedDate DESC];  
        
        system.debug('@@@@@matchPT: ' + matchPT);
        //system.debug('@@@@@matchPT[0].Engagement__r.Account_Id__c: ' + matchPT[0].Engagement__r.Account_Id__c );
        
        if(matchPT!=null && matchPT.size()>0){
            list<Account> accountList = [SELECT Id, Name FROM Account WHERE Id =: matchPT[0].Engagement__r.Account_Id__c limit 1 ];
            system.debug('@@@@@accountList: ' + accountList);
            if(accountList !=null && accountList.size()>0){
                return accountList[0].Name;
            }
        }
        return notFound;
    }
    
    public PageReference skipPage() {
        
        PageStatusController();
        String pageCodeId = ApexPages.currentPage().getParameters().get('pageId');
        //docType = ApexPages.currentPage().getParameters().get('docType');
        PageReference p = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        p.getParameters().put('id', applicantInfo.Id);
        if (docType != null){
            P.getParameters().put('docType',docType);
        }
        if(ApexPages.currentPage().getParameters().get('reDirectPage') == 'true'){
            p.setRedirect(true);
        }
        
        system.debug('@@@@@ Skipage in pageid ' + pageCodeId + 'to: ' + p );
        update applicantInfo;
        system.debug('debug::update applicantInfo 15');
        return p;
    }
    
    
    public void RetrieveIPU() {
        
        
        IdIPU = Apexpages.currentPage().getParameters().get('IdIPU');
        //keyURLModal = Apexpages.currentPage().getParameters().get('keyURLModal');
        system.debug('*****@@@IdIPU: '+ IdIPU);
        system.debug('*****@@@keyURLModal: '+ keyURLModal);
        
        list<Intrax_Program_Upload__c> loadDocList = [Select Id, Document_Guid__c, Description__c, Document_service__c, Document_Type__c, Applicant_Info__c 
                                                      from Intrax_Program_Upload__c where Id =: IdIPU];
        
        if(loadDocList !=null){
            ipuPhoto = loadDocList[0];
        }
        if(ipuPhoto.Document_Guid__c != null){
            List<String> myGUIDs = new List<String>();
            myGUIDs.add(ipuPhoto.Document_Guid__c);
            keyURLModal = iUtilities.getPtMediumPhotoAlbum(ipuPhoto.Document_Guid__c) + '?key='+Date.Today().format();
            //keyURLModal = aws_controller.getPtMediumPhotoAlbumforHF(ipuPhoto.Document_Guid__c)+ '?key='+Date.Today().format();
        }
        
        system.debug('*****@@@ipuPhoto: '+ ipuPhoto);
        system.debug('*****@@@keyURLModal: '+ keyURLModal);
    } 
    
    public void saveRetrieveIPU() {
        
        system.debug('*****@@@ saveRetrieveIPU() ipuPhoto: '+ ipuPhoto);
        update ipuPhoto;
    }
    
    
    //B-02861 Jose - Save Caption Photo Album
    public void saveMapPhotoAlbum() {
        
        String keyPhoto = Apexpages.currentPage().getParameters().get('keyPhoto');
        //keyURLModal = Apexpages.currentPage().getParameters().get('keyURLModal');
        system.debug('*****@@@keyPhoto: '+ keyPhoto);
        update MapPhotoAlbum.get(keyPhoto);
    }
    //B-02861 Jose - Save All Captions Photo Album 
    public void saveMapPhotoAlbumAll() {
        
        Set <String> keySetCap = new Set<String>();
        keySetCap = MapPhotoAlbum.keySet();
        list<Intrax_Program_Upload__c> listCap = new list<Intrax_Program_Upload__c>();
        system.debug('*****@@@keySetCap: '+ keySetCap);
        
        for(String st:keySetCap){
            listCap.add(MapPhotoAlbum.get(st));
        }
        update listCap;
    }   
    
    //Method APC to delete Childcare experience when we click on the icon and run the jquery instruction in apc_ap_main_Experience_childcare...
    public PageReference iWantMyJSValues() {
        //docGuid = Apexpages.currentPage().getParameters().get('docGuid');
        experienceId = Apexpages.currentPage().getParameters().get('experienceId');
        referenceId = Apexpages.currentPage().getParameters().get('referenceId');
        keyURLModal = Apexpages.currentPage().getParameters().get('keyURLModal');
        system.debug('*****@@@keyURLModal: '+ keyURLModal);
        system.debug('*****@@@docGuid: '+ docGuid);
        system.debug('*****@@@experienceId: '+ experienceId);
        system.debug('*****@@@referenceId: '+ referenceId);
        return null;
    } 
    
    public void checkDocuSign(){ 
        system.debug('debug::checkDocuSign');
        Id aId = ApexPages.currentPage().getParameters().get('ObjId');    
        if(aId != null) {
            applicantInfo = 
                [Select (Select Id,First_Name__c,Last_Name__c,Primary_Applicant__c From Person_Info__r),a.Account__r.Name, a.Season__c, a.First_Name__c, a.Last_Name__c, a.Email__c, a.Previous_Address_Complete__c, a.graduated__c, a.Emergency_Contact_Complete__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Family_Members_Complete__c, a.Partner_Name__r.Id,a.Partner_Name__r.Name, a.Years_in_Home__c, a.Writing_Skills__c, 
                 a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Visa_Category__c, a.Arrival_Time__c, a.Intrax_Accommodations__c,    
                 a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Accommodation_Price_Range__c, a.Health_Needs_Indicated__c,
                 a.Submitted__c,a.Study_Time__c,a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, a.Smoker_Student__c, 
                 a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
                 a.Religious_Sharing_Indicated__c, a.Religious_Restriction_Indicated__c, a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Program_Duration__c, a.Private_High_School_Tuition__c, a.Private_High_School_Indicated__c, a.Private_Bedroom__c, a.Private_Bathroom__c, 
                 a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.Deposit_Fee_Accepted__c, a.Health_Needs_Description__c,
                 a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Center_Disclosure_Accepted__c, a.Arriving_Date__c, a.Arriving_Time__c, a.Carrier__c, a.Carrier_Number__c, a.Accommodation_Preference__c,
                 a.Points_of_Interest__c,  a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Pax__c, a.Pax_Count__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, 
                 a.Opportunity_Name__c,   a.Nearest_City__c, a.Nationality_Preferences__c, a.Name,  a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c, 
                 a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.Intrax_Program_Options__c,a.Intrax_Program__c, a.Date_Of_Birth__c, a.Visa_Type__c, a.Questions__c, a.Program_Start_Opinion__c,
                 a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.RB_Last_Name__c, a.RB_First_Name__c, a.How_Heard__c,a.How_Heard_Detail__c,a.How_Heard_Other__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Government_Assistence_Indicated__c, 
                 a.Gender_Preference__c, a.GPA__c, a.GPA_Self_Reported__c,  a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, a.Check_in_Date__c, a.Check_out_Date__c, a.Any_housing_that_fits_my_program_dates__c, a.Homestay__c, a.Residence_Club__c,
                 a.Exchange_Agency_Employer_Name__c, a.Intrax_Center__c, a.Country_of_Birth__c, a.Home_Province__c,a.Street__c, a.City__c,a.Country__c, a.State__c, a.Passport_Number__c, a.Passport_Country__c,
                 a.Entity_Id__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c, a.English_Teach_Name__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c, a.Engagement_Start__c, 
                 a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Standard_Delivery__c, a.Express_Delivery__c, a.Own_insurance__c, a.Intrax_Insurance__c, a.Airport_Transfer_Arrival__c, a.Airport_Transfer_Departure__c, 
                 a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c,a.Daily_Meal_Commitment__c, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.CreatedById, 
                 a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.Study_Weeks__c,
                 a.Children_Enrolled__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Any_Special_Food_Requirement__c, a.Special_Needs_Food__c, a.Program_Selector__c,
                 a.Bedrooms__c,a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.Engagement_End__c, a.Program_Start__c, a.Flexible_Dates__c,
                 a.Country_of_Interest__c, a.Location_of_Interest__c, a.Program_Preference_Comment__c, a.Language_1__c, a.Language_1_Proficiency__c,  a.Language_2__c, a.Language_2_Proficiency__c,  a.Language_3__c, a.Language_3_Proficiency__c, a.Other_Languages__c, 
                 a.Attendance_Problems__c, a.Attendance_Problems_Description__c,a.Allergies_Other_Partner__c,a.Allergies_Other_desc__c, a.Application_Stage__c, a.Application_Level__c,
                 a.Allergies_from_Partner__c, a.Allergies_from_Applicant__c, a.Allergies_Indicated__c, a.Airport__c, a.Account__c, a.Academic_Years_Completed__c, a.Experience_Complete__c,
                 a.Functional_Areas__c, a.Position_Types__c, a.Service_Level__c, a.Location_Preference_1__c, a.Location_Preference_2__c, a.Location_Preference_3__c,
                 a.PhotoId__c, a.CreatedBy__c, a.RecordType.Name, a.Engagement__c, a.Engagement__r.Id, a.Terms_Accepted__c, a.Citizenship__c,a.School_Name_SOR__c, a.Primary_Activity__c,
                 a.Projects_of_Interest__c, SYS_Allow_Cloning__c, Portal_Contact_Id__c, Enquiry_Channel__c, Last_Applicant_Update__c, a.Intrax_Market__c, a.Private_Bedroom_Indicated__c,
                 a.Driving_Preference_indicated__c, a.Countries_of_Interest__c, a.Language_Preferences__c, Preferred_Arrival_Date__c, a.IsDeleted, a.Program_year__c, a.Airport_Transfer__c,
                 a.Passport_Indicated__c, a.Passport_Expiration_Date__c, a.US_Arrival_Date__c, a.Intrax_Id__c, a.Extension_Preferences__c, a.Payment_Method__c,a.Payment_Option__c,
                 a.Family_Description__c, a.Lived_Away_indicated__c,a.Away_Count__c, a.US_Passport_Indicated__c, a.Match_Extension_Length__c,
                 a.Childcare_Experience_Indicated__c, a.Under_2_Total_Hours__c, a.Being_AuPair_Indicated__c, a.US_AuPair_Agency__c, a.AP_Completion_Year_Indicated__c, a.AP_program_End_Date__c,
                 a.Drivers_Licence_Indicated__c, Drivers_Licence_Acquired__c, a.Driving_Experience__c, a.Driving_Comfort_Children__c,Drivers_Licence_Expires__c,a.Driving_Frequency__c,a.Driving_Transmission__c,
                 a.Driving_Snow_Experience__c,Interest_Sports__c, a.Interest_Fine_Arts__c, a.Interests_Hobbies__c,a.Interests_Hobbies_Description__c, a.Interests_Leisure__c,
                 a.Allergy_Description__c,  a.Pets_Allergy_Indicated__c, a.Pet_Allergy_Types__c, a.Pets_Allergy_Description__c,  a.Driving_Experience_Description__c,
                 a.Single_Mother_Indicated__c, a.Single_Father_indicated__c, a.Same_Sex_Couple_Indicated__c, a.Any_Sibling_Indicated__c, a.Extension_DOS_Fee_Indicated__c, a.Extension_Payment_Agreed__c,
                 a.Application_Type__c, a.Childcare_Total_Hours__c, a.US_Experience_Indicated__c, a.PageStatus_Complete__c, a.PageStatus_Started__c, a.Casper_Id__c,
                 a.Children_Comfortable_Ages__c, a.Children_Special_Needs_Indicated__c, a.Children_Special_Needs_Description__c, a.Children_Special_Needs_Care__c, a.Children_Special_Needs_Skills__c,            
                 a.Swimming_Indicated__c,a.Swimming_Level__c,a.Swimming_Comfort_Children__c, a.Aupair_Preferences__c, a.Month_Arrival__c, a.Lived_Away_Description__c,
                 Swimming_Lifeguard_Indicated__c,AuPairsResponsibilities__c,Terms_Accepted_Date__c,Visa_Denied__c,Visa_Denial_Reason__c,Visa_Denial_Year__c,Extension_Geo_Pref_Indicator__c,
                 Extension_Geo_Pref_Detail__c,Children_Comfortable_Number__c,International_Drivers_Licence__c,International_Drivers_Licence_Expires__c,Extension_Departure_Airport__c,Drivers_US_Licence_Indicated__c,
                 Drivers_US_Licence_State__c,Drivers_US_Licence_Received__c,Drivers_US_Licence_Expiration__c,Drivers_wChildren_Indicated__c,Drivers_Accident_Indicated__c,Drivers_Accident_Detail__c,Drivers_PlacementExp_Indicated__c,Extension_Length__c,Extension_Au_Pair_HF_reference__c,University_Indicated__c,Additional_Training_Indicated__c,Intrax_Region__c
                 
                 From Applicant_Info__c a where a.Id = :aId];
            
            docusListUser=[select Id, dsfs__Envelope_Status__c, dsfs__DocuSign_Envelope_ID__c, CreatedDate, UserProfile__c  from dsfs__DocuSign_Status__c where Applicant_Info__c =:applicantInfo.id order by CreatedDate ASC limit 1];
            system.debug('debug::docusListUser ' + docusListUser);
            
            if(docusListUser != null && docusListUser.size() > 0){
                docusUser=docusListUser[0];
                
                docusRecipientList = [Select d.id, d.dsfs__Envelope_Id__c, d.dsfs__Recipient_Status__c, d.dsfs__DocuSign_Routing_Order__c 
                                      From dsfs__DocuSign_Recipient_Status__c d
                                      WHERE d.dsfs__DocuSign_Routing_Order__c = 1 AND  d.dsfs__Envelope_Id__c =: docusUser.dsfs__DocuSign_Envelope_ID__c limit 1];
                system.debug('@@@@@ docusRecipientList01: ' + docusRecipientList);   
                if(docusRecipientList!=null && docusRecipientList.size()>0){
                    docusUserRec2AD=docusRecipientList[0];
                    system.debug('@@@@@ docusUserRec2AD.dsfs__Recipient_Status__c==== ' + docusUserRec2AD.dsfs__Recipient_Status__c); 
                    If(docusUserRec2AD.dsfs__Recipient_Status__c =='Completed'){
                        docusignRefresh = False;}
                    
                    else{
                        docusignRefresh = True;}
                    
                    system.debug('debug:::::' + docusignRefresh);   
                }
                system.debug('@@@@@ docusUserRec2AD: ' + docusUserRec2AD);
                
            }else{
                system.debug('debug:::::' + docusignRefresh);
                docusUser = new dsfs__DocuSign_Status__c();
                docusignRefresh = False;
            }
        } 
    } 
    
    
    //############## Address Validation ###################
    //#####################################################
    
    public string MailingStreet{get;set;}
    public string MailingStreet2{get;set;}
    public string MailingCity{get;set;}
    public string MailingState{get;set;}
    public string MailingPostalCode{get;set;}
    public string Country{get;set;}
    public map<Integer,String> potentialMatchesList {get; set;}
    //public List<Map<String,String>> potentialMatchesList {get; set;}
    public AddressValidation_Processor avProcessor{get; set;}
    public integer addressid {get; set;}
    public string  Errorid {get; set;}
    
    //Address Validation
    public void AddressValidation_controller(){
        String URLAux = ApexPages.currentPage().getUrl();
        
        
        system.debug('debug:::::ApplicantInfo'+applicantInfo.Home_Street_1__c+' '+applicantInfo.Home_Street_2__c+' '+applicantInfo.Home_City__c+' '+applicantInfo.Home_State__c+' '+applicantInfo.Home_State__c+' '+applicantInfo.Home_Postal_Code__c);
        //AddressValidation_Processor avProcessor = new AddressValidation_Processor();
        avProcessor = new AddressValidation_Processor();
        avProcessor.address1 = applicantInfo.Home_Street_1__c;
        avProcessor.address2 = applicantInfo.Home_Street_2__c;
        avProcessor.address3 = '';
        avProcessor.address4 = '';
        avProcessor.city = applicantInfo.Home_City__c;
        avProcessor.state =applicantInfo.Home_State__c;
        avProcessor.postalCode = applicantInfo.Home_Postal_Code__c;
        avProcessor.country = '';//c.Country;
        
        try{
        avProcessor.verifyAddress();
        //throw new applicationException('You cant do that here');
        //throw new Exception('Invalid myValue');
        }
       catch(Exception ex) {
           //ApexPages.addMessages(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
           //ApexPages.addMessages(ex);
           ApexPages.currentPage().getParameters().Put('AddressErr','Error');
        }
        system.debug('debug:::::potentialMatchesList'+avProcessor.potentialMatchesList);
        if(avProcessor.potentialMatchesList.size() > 0){
            potentialMatchesList = new map<Integer,String>();
            for(integer i=0;i< avProcessor.potentialMatchesList.size();i++){
                potentialMatchesList.put(i,avProcessor.potentialMatchesList.get(i).get('address1')+' '+avProcessor.potentialMatchesList.get(i).get('address2')+' '+avProcessor.potentialMatchesList.get(i).get('city')+' '+avProcessor.potentialMatchesList.get(i).get('state')+' '+avProcessor.potentialMatchesList.get(i).get('postalCode'));
            }
        }
        system.debug('debug::Status'+avProcessor.status);
        system.debug('debug::additionalInformation'+avProcessor.addInfo);
        //B-02630 Chris
        try{
            if(URLAux.contains('apex/apc_hf_app_personal_info')){
                personRole.Applicant_Info__c = applicantInfo.Id;
                personRole.Role__c = 'Spouse or Partner';
                if(personInfo.Marital_Status__c == 'Married' || personInfo.Marital_Status__c == 'Domestic Partner'){
                    upsert personRole;
                }
                personInfo.Applicant_Info__c = applicantInfo.Id;
                upsert personInfo;
            }
        }
        catch(Exception e){
            System.debug('Address validation error: ' +e);
        }
    }
    
    //##############################PAYMENT MODULE###########################################
    //#######################################################################################
    
    public void blankOutAddressDetailsOnPaymentPage() {
        
        if(useCurrentBillingAddressInfo != null && useCurrentBillingAddressInfo) {
            
            //Populating Address fields on payment record
            payment.Billing_FirstName__c = personInfo.First_Name__c;
            payment.Billing_LastName__c = personInfo.Last_Name__c;
            payment.Billing_Email__c = personInfo.Email__c;
            //payment.Billing_Phone__c = personInfo.Phone__c;
            /*payment.Billing_Street_1__c = applicantInfo.Home_Street_1__c;
            payment.Billing_Street_2__c = applicantInfo.Home_Street_2__c;
            payment.Billing_City__c = applicantInfo.Home_City__c;
            payment.Billing_State__c = applicantInfo.Home_State__c;
            payment.Billing_Country__c = applicantInfo.Home_Country__c;
            payment.Billing_Postal_Code__c = applicantInfo.Home_Postal_Code__c;*/
            System.debug('Account Billing Street' + applicantInfo.Account__r.BillingStreet);
            
            List<String> addresses = applicantInfo.Account__r.BillingStreet.Split('\r\n',2);
            
            if(addresses!=null && addresses.size()>0)
            {
                System.debug('addresses is ' + addresses);
                if(addresses.size()==1)
                {
                    payment.Billing_Street_1__c = addresses[0];
                    //payment.Billing_Street_2__c = applicantInfo.Home_Street_2__c;
                }
                else if(addresses.size()==2)
                {
                    payment.Billing_Street_1__c = addresses[0];
                    payment.Billing_Street_2__c = addresses[1];
                }
            }
            
            //payment.Billing_Street_1__c = applicantInfo.Account__r.BillingStreet;
           // payment.Billing_Street_2__c = applicantInfo.Home_Street_2__c;
            payment.Billing_City__c = applicantInfo.Account__r.BillingCity;
            payment.Billing_State__c = applicantInfo.Account__r.BillingState;
            payment.Billing_Country__c = applicantInfo.Account__r.BillingCountry;
            payment.Billing_Postal_Code__c = applicantInfo.Account__r.BillingPostalCode;
          //payment.Txn_Reference_Id__c = GuidGenerator.generateGUID();
            
        } else {
            
            //Populating Address fields on payment record
            payment.Billing_FirstName__c = '';
            payment.Billing_LastName__c = '';
            payment.Billing_Email__c = '';
            //payment.Billing_Phone__c = '';
            payment.Billing_Street_1__c = '';
            payment.Billing_Street_2__c = '';
            payment.Billing_City__c = '';
            payment.Billing_State__c = '';
            payment.Billing_Country__c = '';
            payment.Billing_Postal_Code__c = '';
            
            
        }
    }
    
    public void backToPaymentEditPage() {
        isConfirmPayment = false;
    }
    
    public void navigateToPaymentNonEditPage() {
        payment.Txn_Reference_Id__c = GuidGenerator.generateGUID();
        if(applicantinfo.Application_Type__c == 'Extension' && applicantinfo.Extension_Payment_Agreed__c == false){
            paymentError='Please acknowledge and agree to the extension program fees to continue';
            isPaymentSuccessful = false;
        }
        // Below If Block as a part of payment error handling .... done by ABP        
        if(String.isBlank(payWrapper.ccNumber)||String.isBlank(payWrapper.cvvNumber) ) 
        {
            system.debug('@@ cc numbr @@' +payWrapper.ccNumber);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Please enter all required values'));
        }
        
        
        else{
            system.debug('*****###into navigateToPaymentNonEditPage()');
            maskedCCNumber = '************' + payWrapper.ccNumber.subString(payWrapper.ccNumber.length()-4, payWrapper.ccNumber.length());
            payment.Amount__c = amount;
            //if(String.isBlank(totalamount))
            //totalamount = '350';
            isConfirmPayment = true;
            
            if (applicantInfo.PromoCode__c != null)
                applicantInfo.Promo_Code_Indicated__c = 'YES';
            else 
                applicantInfo.Promo_Code_Indicated__c = 'NO';
            update applicantInfo; 
            system.debug('debug::update applicantInfo 16');
            /*  List <Opportunity> newListCheck = new List<Opportunity>();
newListCheck = [Select o.Amount, o.Account_Owner_Full_Name__c, o.AccountId,o.Parent_Opportunity__c, o.Name,o.StageName,o.Id From Opportunity o where o.Parent_Opportunity__c =: applicantinfo.Opportunity_Name__c];
system.debug('@@newListCheck @@ TRYING TO ACCESS THE CHILD OPP' +newListCheck);
system.debug('@@applicantinfo.Opportunity_Name__c' +applicantinfo.Opportunity_Name__c);

Boolean flag = false;

if (NewListCheck[0].StageName !='Closed Won')
{
NewListCheck[0].Description ='Updated sucesfully';
update NewListCheck[0];
flag = true;system.debug('@@flag after loop @@' +flag);
}
if (flag == true){   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'updated succesfully')); }
if (flag == false){   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Opportunity fields are not shared to edit by user.'));}*/
            
        }
    }
    
    //Payment Variables
    public Boolean isPaymentSuccessful{get; set;}
    public String paymentError{get; set;}
    
    /**
*  @description    :   Method responsible for invoking "AWS Payment Web Service" with user inputted payment values as request parameters.
*
*  @args           :   
*
*  @return         :   Pafereference
*
**/ 
    
    
    //AA New Promo Code
    public void checkPromo() {
        system.debug('*****###promocode: ' + promoCodeValue);
        system.debug('debug::Opportunity' +applicantInfo.Opportunity_Name__c);
        
        list<PriceBookEntry> couponCodes=Pricing_Publisher.getAPCDiscountedPb('United States','ALL','Fixed',applicantInfo.Intrax_Program__c,'Application',promoCodeValue);
        
        system.debug('debug::Promo Fee'+couponCodes);
        
        if (couponCodes !=null && couponCodes.size() > 0){
            system.debug('debug::Amount Fee'+amount);
            if(!Test.isRunningTest()) {
                amount=amount + couponCodes[0].UnitPrice;
            }
            system.debug('debug::Amount Fee'+amount);
            totalamount=string.valueof(amount);
            
            applicantInfo.PromoCode__c=promoCodeValue;
            system.debug('Debug::promoCodeValue'+promoCodeValue);
            saveapplication();
            payment.Promo_Code__c = promoCodeValue;
            payment.Amount__c = amount;
            //we get a total discount if the final amount == 0 (Currency)
            if(amount <= 0){
                totalamount = '0';
                system.debug('*****###Into free promo');
                applicantInfo.Promo_Code_Indicated__c = 'YES'; // line added to capture full waive off fee
                update applicantInfo;
                system.debug('debug::update applicantInfo 17');
                promovalue='freePromo';
                
                
            }else{
                disablepromo = true;
                system.debug('@@ disablepromo@@'+disablepromo);
                promovalue='getPromo';
            }
            
            
        }else{
            //Invalid Promo code
            DescriptionCoupon='';
            promovalue='noPromo'; 
            system.debug('*****###promovalue: ' + promovalue);
            //amount = 350;
            totalamount = string.valueof(amount);
            payment.Amount__c = amount;
            promoCodeValue='';
        }
    }
    
    
    // Begin new code Jose has added
    
    /*   public void checkPromo() {

//decimal amountPromo;

system.debug('*****###promocode: ' + promoCodeValue);

//Different prices depend on the APC App is Extension or Original
if(applicantinfo.Application_Type__c == 'Extension'){
standartFeeApc = [Select Id, UnitPrice, Product2Id, Product2.Description, Product2.Sort_Order__c, Product2.Help_Text__c, Product2.Start_Date__c, Product2.Promo_CTA__c, Product2.Name from PriceBookEntry where Product2.Name = 'Standard Extension HF Application Fee' AND Product2.IsActive = true AND IsActive = true AND PriceBook2.Name = 'USA APC 2013-14'];
}else{
standartFeeApc = [Select Id, UnitPrice, Product2Id, Product2.Description, Product2.Sort_Order__c, Product2.Help_Text__c, Product2.Start_Date__c, Product2.Promo_CTA__c, Product2.Name from PriceBookEntry where Product2.Name = 'Standard HF Application Fee' AND Product2.IsActive = true AND IsActive = true AND PriceBook2.Name = 'USA APC 2013-14'];
}

if (standartFeeApc !=null && standartFeeApc.size() > 0){
amount=standartFeeApc[0].UnitPrice;
//amount=Pricebook[0].UnitPrice;
}       

if(!String.IsBlank(promoCodeValue)) {

//Get the Standad fee price for APC HF


//Query Promo discount price Book and hit Product object to check if the Same promo code exists on Product object
couponCodes = [Select Id, UnitPrice, Product2Id, Product2.Description, Product2.Sort_Order__c, Product2.Help_Text__c, Product2.Start_Date__c, Product2.Promo_CTA__c, Product2.Name from PriceBookEntry where Product2.Account_Code__c =: promoCodeValue AND Product2.IsActive = true AND IsActive = true AND PriceBook2.Name = 'USA APC 2013-14'];

//Checking list for size and null value. 
//Add string error parameter If Promo Code is InActive, not exist or 100% 
if(couponCodes.size() > 0) {

//If thsi is a valid promo code, them deduct this from the main amount and store in Payment object for future reference
DescriptionCoupon = couponCodes[0].Product2.Description;
amount = amount - couponCodes[0].UnitPrice;
totalamount = string.valueof(amount);
payment.Promo_Code__c = promoCodeValue;
payment.Amount__c = amount;
//we get a total discount if the final amount == 0 (Currency)
if(amount <= 0){
totalamount = '0';
system.debug('*****###Into free promo');
promovalue='freePromo';
}else
promovalue='getPromo';

}else{

//Invalid Promo code
DescriptionCoupon='';
promovalue='noPromo'; 
system.debug('*****###promovalue: ' + promovalue);
//amount = 350;
totalamount = string.valueof(amount);
payment.Amount__c = amount;
promoCodeValue='';
}
}
}*/
    
    public pagereference makeAWSPayment() {
        try
        {
        isPaymentSuccessful = true;
        
        //Setting required properties before invoking payment web service
        system.debug('*****### payment.Amount__c: ' + payment.Amount__c);
        system.debug('*****### payment.Promo_Code__c: ' + payment.Promo_Code__c);
        //if(payment.Amount__c == null)
        //   payWrapper.amount = 350;       
        //else
        if(payment.Amount__c != null)
            payWrapper.amount = payment.Amount__c;
        
        if(!String.isBlank(payment.Promo_Code__c))
            payWrapper.promoCode = payment.Promo_Code__c;
        
        //Populating some other properties
        if(!String.isBlank(monthSelected))
            payWrapper.cardExpirationMonth = monthSelected;
        if(!String.isBlank(yearSelected))
            payWrapper.cardExpirationYear = yearSelected;
        if(!String.isBlank(TypeCreditCardSelected))
            payWrapper.cardType = TypeCreditCardSelected;
        payment.IP_Address__c = ipAddress;
        
        //We can't overwrite a master-detail field
        //if(payment.Card_Holder__c == null){}
        system.debug('*****### We are here 1  - payment test: ' + payment);
        payment.Card_Holder__c = applicantInfo.Id;
        payment.Account_Name__c=applicantInfo.Account__c;
        if(childApplicationOpportunity!=null)
            payment.Opportunity_Name__c = childApplicationOpportunity.Id;
        
        payment.Amount__c = payWrapper.amount;
        payment.Promo_Code__c = payWrapper.promoCode;
        
        
        //For capturing payment failure transaction.... AP
        payment__c paymentCopy = new payment__c();
        paymentCopy = payment;
        System.debug('@@ paymentCopy @@' +paymentCopy +paymentCopy.sucess__c);
        
        //Variable to hold the AWS Payment process response result
        //SPILLAI-ENCRYPTION-CHANGES
        //paymentServiceWebServiceInterfaceNew.paymentTransactionResultSetDto paymentResponse =  new paymentServiceWebServiceInterfaceNew.paymentTransactionResultSetDto();
        paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto paymentResponse =  new paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto();
        //SPILLAI-ENCRYPTION-CHANGES
        //Making web service callout to get the response 
        if(!Test.isRunningTest()) {
            //SPILLAI-ENCRYPTION-CHANGES
            //paymentResponse = PaymentService.makeCreditCardTransactionRequest(payment, applicantInfo, personInfo, payWrapper);
            // If loop for checking if txn success then get resposne else re query to check status .. AP
            try
            {
                if (paymentCopy.sucess__c != false)
                paymentResponse = PaymentService.makeEncryptedCreditCardTransactionRequest(payment, applicantInfo, personInfo, payWrapper);
                else
                paymentResponse = PaymentService.makeEncryptedCreditCardTransactionRequest(paymentCopy, applicantInfo, personInfo, payWrapper);
            }
            catch(Exception ex)
            {
                Iutilities.sendExceptionEmail(ex);
            }
            
            //SPILLAI-ENCRYPTION-CHANGES
            System.debug('@@@@ paymentResponse ' + paymentResponse);
        } else {
            //Setting Payment object fields values with the help of response retrived properties values
            payment.Txn_Id__c = String.valueOf(Math.random() + '_1');
            payment.Sucess__c = true;
            payment.Txn_Gateway__c = 'Cyberspace';
            payment.Txn_Amount__c = 123.45;
            payment.Txn_Date__c = System.now();
            payment.Payment_Type__c = 'Visa';
            payment.Txn_Code__c = '123XXX';
        }
        
        //Passing response for parsing and then populate payment record with response retrived properties values
        if(!Test.isRunningTest()) {
            //SPILLAI-ENCRYPTION-CHANGES
            //payment = PaymentHelper.parseWebServiceResponse(payment, paymentResponse);
            try{
                 //StringException s = new StringException();
                   //       throw s;
                payment = PaymentHelper.parseEncryptedWebServiceResponse(payment, paymentResponse);
                System.debug('@@@@ payment ' + payment);
            }catch(Exception ex) {
                Iutilities.sendExceptionEmail(ex);
                backToPaymentEditPage();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
                payment.Txn_Id__c=null;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Invalid credit card info. Please check your info is correct'));
                //return null;
            }
            //SPILLAI-ENCRYPTION-CHANGES
            
        }
        
        //Trying to create a new payment record in system with response retrieved value and implementing post callout logic according to it
        try {
            
            //In case of success Txn Id should be there in callout response 
            if(!String.isBlank(payment.Txn_Id__c)) {
                System.debug('debug : transaction id not null');
                system.debug('*****###payment test: ' + payment);
                payment.Txn_Amount__c = payment.Amount__c;
                insert payment;
                System.debug('before accountBillingStreet' + accountInfo[0].BillingStreet);
                System.debug('before paymentBillingStreet' + payment.Billing_Street_1__c + ' street2 ' + payment.Billing_Street_2__c);
                String accountBillingStreet = accountInfo[0].BillingStreet.replace('\r\n','');
                
                String paymentBillingStreet;
                if(payment.Billing_Street_2__c!=null)
                    paymentBillingStreet= payment.Billing_Street_1__c.replace('\r\n','') + payment.Billing_Street_2__c.replace('\r\n','');
                else
                    paymentBillingStreet = payment.Billing_Street_1__c.replace('\r\n','');
                    
                System.debug('after accountBillingStreet' + accountBillingStreet);
                System.debug('after paymentBillingStreet' + paymentBillingStreet);
                
                try
                {
                    if (accountBillingStreet != paymentBillingStreet ||
                        accountInfo[0].BillingCity != payment.Billing_City__c ||
                        accountInfo[0].BillingState != payment.Billing_State__c ||
                        accountInfo[0].BillingPostalCode != payment.Billing_Postal_Code__c ||
                        accountInfo[0].BillingCountry != payment.Billing_Country__c)
                    {
                        if(payment.Billing_Street_2__c!=null)
                            accountInfo[0].BillingStreet= payment.Billing_Street_1__c + '\r\n' + payment.Billing_Street_2__c;
                        else
                            accountInfo[0].BillingStreet= payment.Billing_Street_1__c;
                        
                        accountInfo[0].BillingCity = payment.Billing_City__c;
                        accountInfo[0].BillingState = payment.Billing_State__c;
                        accountInfo[0].BillingPostalCode = payment.Billing_Postal_Code__c;
                        accountInfo[0].BillingCountry = payment.Billing_Country__c;
                        system.debug('@@ check point1. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                        update accountInfo[0];
                        system.debug('@@ check point2. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                    }
                    
                }
                catch(Exception ex) 
                {
                Iutilities.sendExceptionEmail(ex);
                }
                
                
                //Insert a Applicant Product record for Promo Code
                if(couponCodes != null && couponCodes.size() > 0) {
                    
                    //Create applicant product record
                    Applicant_Product__c appProduct = new Applicant_Product__c(Applicant_Info__c = applicantInfo.Id, Product__c = couponCodes[0].Product2Id, 
                                                                               Description__c = couponCodes[0].Product2.Description, 
                                                                               Sort_Order__c = couponCodes[0].Product2.Sort_Order__c,
                                                                               Unit_Price__c = couponCodes[0].UnitPrice,
                                                                               Help_Text__c = couponCodes[0].Product2.Help_Text__c,
                                                                               Start_Date__c = couponCodes[0].Product2.Start_Date__c,
                                                                               Promo_CTA__c = couponCodes[0].Product2.Promo_CTA__c,
                                                                               Quantity__c = 1, Product_Name__c = couponCodes[0].Product2.Name);
                    insert appProduct;
                }            
                
                //Populating string with masked Credit Card number string, Going to be displayed on page
                
                system.debug('*****##payment test: ' + payment);
                paymentRecordId = payment.Id;
                paymentTxId = payment.Txn_Id__c;
                paymentAmount = String.valueOf(payment.Amount__c);
                paymentDate = String.valueOf(payment.Txn_Date__c);
                system.debug('*****## paymentTxId: ' + paymentTxId);
                system.debug('*****## paymentAmount: ' + paymentAmount);
                
                if(applicantinfo.Application_Type__c=='Extension'){
                    applicantinfo.Application_Stage__c='Submitted';
                }
                applicantinfo.Application_Level__c='Main';
                
                // Creating the attachment pdf payment confirmation
                
                PageReference pdf = Page.apc_hf_app_payment_result_pdf;
                
                system.debug('*****## pdf: ' + pdf);
                pdf.getParameters().put('paymentAmount',paymentAmount);
                pdf.getParameters().put('paymentDate',paymentDate);
                pdf.getParameters().put('paymentTxId',paymentTxId);
                //pdf.getParameters().put('id',applicantinfo.id);
                pdf.setRedirect(true);
                
                // Take the PDF content
                Blob b = pdf.getContent();
                
                // Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('payment_confirmation.pdf');
                efa.setBody(b);
                //send an email to the user
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //String emailPrimary= personinfo.Email__c;
                //String[] toAddresses = new String[]{emailPrimary};
                //  mail.setToAddresses(toAddresses);
                mail.setSaveAsActivity(false);
                //mail.setSubject('AuPairCare Fee Payment Confirmation');
                
                //Get the payment email ID from Custom Setting Application Constants
                String EmailPaymentId;
                List<Application_Constants__c> appconstants = Application_Constants__c.getall().values();
                Application_Constants__c appconstant = Application_Constants__c.getInstance('APC_Payment_Confirmation_ID');
                EmailPaymentId=appconstant.Value__c;
                
                mail.setTemplateId(EmailPaymentId);
                mail.setTargetObjectId(applicantinfo.CreatedBy__c); 
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                emails.add(mail);
     
                try{
                    Messaging.sendEmail(emails);
                }catch(Exception ex)
                {
                    System.debug('Failed to send email. Exception is ' + ex);
                }
                
                //Map Person_Info records into Member__c and Reference__c records
                /*Uncomment this line to copy References and Members*/
                //MapPersonToReferenceMember.MapPersonToRef(String.valueOf(applicantinfo.Id), String.valueOf(applicantinfo.Account__c)); 
                
                
                return navigator();
                
            } else {
                System.debug('debug : transaction id not null');
                //If there us any exception, still insert the payment record with error for tracking purpose
                isPaymentSuccessful = false;
                insert payment;
                

                //System.debug('payment is ' + payment);
                if(!String.isBlank(payment.Error_Description__c))
                    paymentError = payment.Error_Description__c.replace('_',' ');
                else
                    paymentError = 'Please check your credit card details and try again. If you are still unable to pay, please submit another credit card or contact our Billing Department at 800-428-7247 option 4 for assistance.';
                
                //paymentError = 'One or more fields contained invalid data, please enter your data again.';
                //ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: ' + payment.Error_Description__c);
                //ApexPages.addMessage(errorMessage);
                
                system.debug('*****### We are here 2  - payment test: ' + payment);
                //system.debug('@@@ payment.Txn_Reference_Id__c@@@' +payment.Txn_Reference_Id__c);
                //Reset billing address data
                payment = new Payment__c();
                
                //Reset credit card info
                TypeCreditCardSelected=null;
                payWrapper.ccNumber=null;
                monthSelected=null;
                yearSelected=null;
                payWrapper.cvvNumber=null;
                
                //If transaction failed, keeping amount and promocode
                payment.Promo_Code__c =  promoCodeValue;
                payment.Amount__c = amount;
                
                
                useCurrentBillingAddressInfo = false;
                backToPaymentEditPage();
                system.debug('*****### isConfirmPayment:' + isConfirmPayment);
                return null;
            }
            
        } catch(Exception ex) {
            Iutilities.sendExceptionEmail(ex);
            backToPaymentEditPage();
            paymentError = ex.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            return null;
        }
        }
        catch(Exception ex) {
            paymentError = ex.getMessage();
            backToPaymentEditPage();
            Iutilities.sendExceptionEmail(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            return null;
        }
    }    
    
    public void CreateApplicationOpp()
    {
        CreateIntacctAccount();
        if (applicantInfo.Application_Level__c == 'Basic' && applicantInfo.Application_Stage__c == 'Working' &&  applicantInfo.RecordTypeId== Constants.AuPairCareHF_Record_Type_Id && applicantInfo.Intrax_Region__c == 'United States')
        {
            if (applicantInfo.Opportunity_Name__c != null)
            { 
                Sharing_Security_Controller.shareOpportunity(applicantInfo.Opportunity_Name__c,applicantInfo.createdBy__c);
                //Create a child opportunity (application fee) if does not exist
                List<Opportunity > lChildCOpps=[Select id,StageName,Reason__c,Reason_Detail__c,ChildOppType__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                                                Engagement_End__c,Parent_Opportunity__c,RecordTypeID from Opportunity where Parent_Opportunity__c= :applicantInfo.Opportunity_Name__c  and 
                                                ChildOppType__c=:'Application'];
                system.debug('@@childopp @@' +lChildCOpps);
                
                Opportunity SuccessChildOpp;
                string OppFeeType = 'Application';
                if(lChildCOpps!=null && lChildCOpps.size()==0)
                {
                    List<Person_Info__c> personInfo = [SELECT Id, First_Name__c, Last_Name__c, Gender__c, Date_of_Birth__c,Country_of_Residence__c, Citizenship__c, Email__c, Mobile__c,
                                                       Phone__c, Skype_Id__c, Best_Call_Time__c, Primary_Applicant__c 
                                                       FROM Person_Info__c WHERE applicant_Info__c =: applicantInfo.Id and Primary_Applicant__c =: true];
                    String CurrencyCode;
                    
                    Id lChildOppId;
                    
                    system.debug('*trigger**'+applicantInfo);
                    system.debug('*personInfo**'+personInfo);
                    if(personInfo!=null && personInfo.size()>0)
                    {                                 
                        
                        List<PriceBookEntry> PriceBookList = new List<PriceBookEntry>(); 
                        PriceBookList = Pricing_Publisher.getAPCPricebookDetail('United States','All','Fixed',applicantInfo.Intrax_Program__c,'Application'); 
                        // applicantInfo.Intrax_Program__c = APC, applicantInfo.Country_of_Interest = All,applicantInfo.Intrax_Program_Category__c = business,personInfo[0].Country_of_Residence__c='United States'
                        system.debug('*PriceBookList**'+personInfo[0].Country_of_Residence__c);
                        system.debug('*PriceBookList**'+PriceBookList);
                        system.debug('*PriceBookList**'+applicantInfo.Intrax_Program_Category__c);
                        if(PriceBookList!=null && PriceBookList.size()>0)
                        {
                            CurrencyCode=PriceBookList[0].CurrencyIsoCode;
                            
                            //if(applicantInfo.Application_Stage__c != Trigger.oldMap.get(applicantInfo.Id).Application_Stage__c)// && opp equals prev opp
                            
                            SuccessChildOpp = AppTriggerHelper.CreateAppOpp(applicantInfo,applicantInfo.Opportunity_Name__c,CurrencyCode,OppFeeType);
                            if(SuccessChildOpp!=null && applicantInfo.PromoCode__c == null)
                            {
                                System.debug('after creating');
                                Sharing_Security_Controller.shareOpportunity(SuccessChildOpp.Id,applicantInfo.createdBy__c);
                                List<PriceBookEntry> PriceBookListNoPromo = new List<PriceBookEntry>(); 
                                PriceBookListNoPromo = Pricing_Publisher.getAPCPricebookDetail('United States','All','Fixed',applicantInfo.Intrax_Program__c,'Application'); 
                                AppTriggerHelper.CreateAppOppProduct('application_fee',SuccessChildOpp.Id,PriceBookListNoPromo ); 
                            }
                            
                            system.debug('@@ applicantInfo,applicantInfo.oppname,currency code,oppfee@@' +applicantInfo +applicantInfo.Opportunity_Name__c);
                            system.debug('@@ currency code @@' +CurrencyCode);
                            system.debug('@@ OppFeeType @@' +OppFeeType);
                            // IntAcctOppSyncHelper.CreateAccountReceivables(applicantInfo.Account__c,applicantInfo.Opportunity_Name__c,applicantInfo.Intrax_Id__c);
                        }
                    }
                }
                else 
                    SuccessChildOpp = lChildCOpps[0];
                
                if(SuccessChildOpp!=null)
                {  
                    childApplicationOpportunity = SuccessChildOpp;
                    List<OpportunityLineItem> lChildProdcts=[Select o.Quantity,o.OpportunityId,o.PricebookEntry.Product2.Name,o.Id,o.Discount From OpportunityLineItem o where o.OpportunityId =: SuccessChildOpp.id];
                    // system.debug('@@lChildProdcts @@' +lChildProdcts);
                    //   system.debug('@@lChildProdctsPricebookEntry.Product2.Name @@' +lChildProdcts[1].PricebookEntry.Product2.Name);
                    if(lChildProdcts != null && lChildProdcts.size()>0)
                    {   Boolean createdwaived=false;
                     for ( OpportunityLineItem olitem :lChildProdcts)
                     {   
                         if(olitem.PricebookEntry.Product2.Name =='Waived Application Fee')
                             createdwaived = True;
                         
                     }                                 
                     if(applicantInfo.PromoCode__c != null && createdwaived==false)// && lChildProdcts[1].PricebookEntry.Product2.Name!='Waived Application Fee')// olitem.PricebookEntry.Product2.Name !='Waived Application Fee'
                     {
                         system.debug('*inside promocode**');
                         List<PriceBookEntry> PriceBookListPc = new List<PriceBookEntry>(); 
                         PriceBookListPc = Pricing_Publisher.getAPCDiscountedPb('United States','All','Fixed',applicantInfo.Intrax_Program__c,'Application', applicantInfo.PromoCode__c);
                         system.debug('*PriceBookListPc**'+PriceBookListPc);
                         OppFeeType = 'Promo Code';                  
                         AppTriggerHelper.CreateAppOppProduct(OppFeeType,SuccessChildOpp.id,PriceBookListPc);
                     }
                     
                    }   
                }
            }
            
        }
    }
    
    
    public void CloseApplicationOpp()
    {
        checkLogin();
        List<Opportunity> lChildCOppsstatus = new List<Opportunity>();
        System.debug('** StageCloser application' + applicantInfo + 'name ' + applicantInfo.Opportunity_Name__c);
        lChildCOppsstatus =[Select id,StageName,Parent_Opportunity__c,AccountId from Opportunity where Parent_Opportunity__c = :applicantInfo.Opportunity_Name__c
                            and ChildOppType__c = 'Application' and stageName != 'Closed Won'];
        system.debug('***CHILDOPPSTATUS****'+lChildCOppsstatus);
        
        if(lChildCOppsstatus!=null && lChildCOppsstatus.size()>0)
        {
            Opportunity opp= lChildCOppsstatus[0];
            if (opp.StageName != 'Closed Won')
            {
                opp.StageName = 'Closed Won';
                system.debug('***CHILDOPPSTATUS****'+opp.StageName);
                update opp;                               
            }
        }
    }
    
    
    public void CreateIntacctAccount()
    {
        checkLogin();
        System.debug('applicantInfo : ' + applicantInfo);
        if(applicantInfo.account__c !=null && applicantInfo.Intrax_Program__c == 'AuPairCare' 
           && applicantInfo.Type__c == 'Host Family')
        {
            Intacct_Wrapper wrapper= new Intacct_wrapper();
            List<Intacct__c> parentIntacct = [Select id from Intacct__c 
                                              where Account__c =:applicantInfo.account__c and
                                              Is_Parent__c = true and
                                              Type__c = 'Create Customer' and
                                              Intacct_Response__c = 'Success'
                                              limit 1];
            //intacct account no present so create it and sync
            if(parentIntacct.isEmpty())
            {
                System.debug('Parent Intacct is not present. Create one and sync');
                wrapper.CreateIntacctAccnt_Sync(applicantInfo.account__c);//,'Non-Future');   
            }
        }
    }
    
    //Jose B-02802 Non US Departure Airport
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
    
    //Jose Getting HF AD (User_Profile) from Position Owner
    public User_Profile__c userProfAD{get{
    
    if(userProfAD == null){
        system.debug('@@@@@ userProdAd applicantinfo.Position__r.OwnerId: ' + applicantinfo.Position__r.OwnerId);
        list<User_Profile__c> userProfADList = [Select Id, User__c, Area_Profile__c, OwnerId, User_Email__c, User_Name__c, User_Phone__c,
        Area_Profile__r.Name, Area_Profile__r.Educational_Institution_1_URL__c, Area_Profile__r.Educational_Institution_2_URL__c, Area_Profile__r.Educational_Institution_3_URL__c,
        Area_Profile__r.Educational_Institution_1__c, Area_Profile__r.Educational_Institution_2__c, Area_Profile__r.Educational_Institution_3__c,
        Area_Profile__r.Climate__c, Area_Profile__r.Description__c, Area_Profile__r.APC_Field_Region__c
            From User_Profile__c
            where User__c =: applicantinfo.Position__r.OwnerId]; 
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
    
    
}