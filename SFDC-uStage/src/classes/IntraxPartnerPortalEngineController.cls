/*
Class: IntraxPartnerPortalEngineController

Description: Master class to control the wugork flow of the Intrax Partner Portal..

*/
public with sharing class IntraxPartnerPortalEngineController {
    
    public String ShowTripInfoType {get; set;}
    /*Variable Helpfulin Pagination*/
    public  string CampStrURL {get;set;}
    public  string partialUrl {get;set;}
    public  string fileUploadUrl {get;set;}
    public  string derivedUrl{get;set;}
    public  String orgId {get;set;}
    public  String strEid{get;set;}
    
    public  string retParam1{get;set;}
    public  string retParam2{get;set;}
    public  string retParam3{get;set;}
    public  string retParam4{get;set;}
    public  string retParam5{get;set;}
    public  string retParam6{get;set;}
    public  string retParam7{get;set;}
    public  string retParam8{get;set;}
    public  string retParam9{get;set;}
    public  string retParam10{get;set;}
    //AA 19-02-2014 Ayusa II-Story 633-- New document type added
    public  string retParam11{get;set;}
    public  string retParam12{get;set;}
    
    public String ApprivalTripNeeded { get; set; }
    public String DepartureTripNeeded { get; set; }
    
    public  string rType{get;set;}
    public  List<Engagement__c> lstEng;
    public String progId{get; set{progId=value;}}
  
    public date FromDate{get;set;}
    public date ToDate{get;set;}
    
    public date SubmittedFromDate{get;set;}
    public date SubmittedToDate{get;set;}
    
    //Variable to hold the page size
    Integer PAGE_SIZE;
    
    public String responseXML{get; set;}
    public String returnURL{get; set;}
    public String returnURLHF{get; set;}
    public list<String> returnURLListHF{get; set;}
    
    //Integer defined for holding Page Number 
    public Integer pageNumber {get; set;}
    public Integer totalPageNumber {get; set;}
    public Integer iTotalPages {get; set;}
    public Integer itotalPageNumber {get; set;}
    
    //public List<selectOption> PartnerIntraxPrograms{get; set;}
    
    /*Variables for Partners*/
    
    public Integer FlagAppsCount{get;set;}
    public Integer DecAppsCount{get;set;}
    public Integer SubAppsCount{get;set;}
    public Integer AccAppsCount{get;set;}
    
    //JOSE B-03077
    public Integer AwaitingCount{get;set;}
    public Integer ActiInterviewsCount{get;set;}
    public Integer InCountryCount{get;set;}
    public Integer InterviewFeedCount{get;set;}
    
    public Integer NewMatch30Count{get;set;}
    public Integer ExtensionEngCount{get;set;}
    public Integer PreArrivalCount{get;set;}
    public Integer OnProgramCount{get;set;}
    
    public Integer AppSubLastYearCount{get;set;}
    public Integer  AppAcceptedLastYearCount{get;set;}
    
    public Set<Id> ActiveInterviewsEng {get;set;}
    
    public String awaitingEngsParam {get;set;}
    public String activeInterEngsParam {get;set;}
    public String inCountryEngsParam {get;set;}
    public String interviewFeedbackEngsParam {get;set;}
    
    public String newMatchesEngsParam {get;set;}
    public String extensionEngsParam {get;set;}
    public String preArrivalEngsParam {get;set;}
    public String ProgramUSAEngsParam {get;set;}
    
    public Set<Id> submittedApps {get;set;}
    public Set<Id> acceptedApps {get;set;}
    
    public String submittedAppsParam {get;set;}
    public String acceptedAppsParam {get;set;}
    
    public set<Id> setEngagement;
    
    //END JOSE B-03077
        
    public list<Reference__c> referenceListCheck{get;set;}
    public list<Applicant_Info__c> summaryReviewAppsList{get;set;}
        
    public Set<Id> mainSubmittedApps {get;set;}
    
    public Set<Id> mainWorkingApps {get;set;}
    
    public Set<Id> incompleteAssApps {get;set;}
    public Set<Id> notStartedAssApps {get;set;}
    public Set<Id> toHealthReviewApps {get;set;}
    public Set<Id> bgCheckReviewApps {get;set;}
    public Set<Id> schoolDetailsVerifyApps {get;set;}
    
    public String incompleteAssAppsParam {get;set;}
    public String notStartedAssAppsParam {get;set;}
    public String toHealthReviewAppsParam {get;set;}
    public String bgCheckReviewAppsParam {get;set;}
    public String schoolDetailsVerifyAppsParam {get;set;}
    
   
    
    public String registrationURL{get; set;}
    public String getURL(){
        return registrationURL;
    }
    public Integer inCompleteAssAppsSize{get;set;}
    public Integer notStartedAssAppsSize{get;set;}
    public Integer toHealthReviewAppsSize{get;set;}
    public Integer bgCheckReviewAppsSize{get;set;}
    public Integer schoolDetailsVerifyAppsSize{get;set;}
    
    public Position__c position { set; get;}
    public Assessment__c selectedAssessment { set; get;}
    public Engagement__c engagement { set; get;}
    public Person_Info__c personPrimary { set; get;}

    public Id assId {set; get;}
    public String assessmentField {set;get;}
    public Boolean testsfdc { set; get;}  
    //RS added
    public list<Position_Info__c> posInfo { set; get;}     
    
    public map<String, String> DocuSignEnvMap {get;set;}   
    
    //String to hold the URL Value
    public String nextPage {get; set 
        { 
            nextPage = value; 
        }
    }  
      
    //Variable to hold redirect Page string
    public String reDirectPage {get; set
        {
            reDirectPage = value;
        }
    }
    public String docType {get; set
        {
            docType = value;
        }
    }
    /*Instances of records displayed on the Portal*/
    
    //variable to hold EssayQS Family Letter
    public list<Essay__c> EssayFamilyLetter {get;set;}
    public Essay__c FamilyLetter {get;set;}
    
    //Current logged in user instance
    public User activeUser {get;set;}
    public Account accParntner {get;set;} 
    
    //Variable to hold Host Company Account Instance
    public Account hostCompany {get; set;}
    
    //varaiable to hold the Host Company contacts Instance
    public Contact hostContact {get; set;}
    
    /*Variable and Getter Setter for Engagement__c (Participant) record */
    
    //Variable to hold the Engagement (Participant) instance
    public Engagement__c participant {get; set;}
    public list<Engagement__c> participantRecords{get;set;} 
    public list<Engagement__c> totalRecords{get;set;} 
    public string participantId{get;set;}
    
    //Variable to hold the family members of the matched position data
    public Applicant_Info__c familyApp{get;set;}
    public list<Person_Info__c> familyInfo{get;set;}

    
    public Applicant_Info__c applicationRecord {get;set;}
    
    public Applicant_Info__c DocapplicationRecord {get;set;}
    
    //Map to hold the Participant record and Match record
    Map<Id, Match__c> mapParticipantIdWithMatch {get; set;}
    
    // User data we nned to display in the Site
    public list<User> ayusaContact{get;set;}
    public Contact ContactUser{get;set;}
    public Account AccountUser{get;set;}
    public User ManagerUser{get;set;}
    public Position__c positionInfo{get;set;}
    public Map<String, String> PosInfo_Status {get; set;}
    
    // Family Photos List
    
    public list<Intrax_Program_Upload__c> FamilyPhotos {get;set;}
  
    //List of lists of Engagement and match helpful in Pagination
    public List<List<EngagementMatchWrapper>> listOfListParticipantAndMatch {get; set;}
    //B-03379
     Map<Id,String> mapEnglabel = new Map<Id,String>();
    
    
    //List of Participant records and Match record
    public List<EngagementMatchWrapper> listParticipantAndMatch {
        get{
            //Return listOfListParticipant with its correspondinbg index i.e pageNumber
            system.debug('------>GET pageNumber:'+pageNumber);//79
            system.debug('------>GET iTotalpageNumber:'+iTotalpageNumber);//90
            system.debug('------>GET listOfListParticipantAndMatch size:'+listOfListParticipantAndMatch.size());//80
            system.debug('------>GET iLIMIT:'+iLIMIT);//3
            system.debug('------>GET ioffset:'+ioffset);//400
                        
            if(itotalPageNumber > integer.valueOf(iLIMIT/integer.valueOf(limits))){//90>80                                                    
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));//90-80
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                system.debug('------>GET INSIDE:totalPageNumber'+totalPageNumber);//10
                pageNumber = totalPageNumber - 1;           
            }            
                        
            system.debug('------>GET pageNumber after:'+pageNumber);  
            return listOfListParticipantAndMatch[pageNumber];            
        } set; 
    }

    public List<selectOption> getIncompleteMissingDocs(){
       return getPickValues(this.application, 'Incomplete_Missing_Documents__c', null);
    }
    
    // Filters
    public list<SelectOption> PartnerIntraxPrograms {get;set;}
    public String intraxProgramSelected{get;set;}

    public list<SelectOption> ApplicationLevel {get;set;}
    //public list<SelectOption> applicationLevelWT{get;set;}
    public list<SelectOption> ApplicationStage {get;set;}
    public list<SelectOption> ApplicationStageWT {get;set;}
    public list<SelectOption> ApplicationStageAPC {get;set;}
    public list<SelectOption> ProgramDuration {get;set;}
    public string programDurationSelected{get;set;}
    
    public list<SelectOption> Views {get;set;}
    public list<SelectOption> ViewsEng {get;set;}
    
    public string viewSelected{get;set;}
    
    public list<SelectOption> PartnerAccounts {get;set;}
    public string partnerAccSelected{get;set;}
    public Map<String,String> mapPartnerNameIntraxId;
        
    public string PartPartnerAccSelected{get;set;}
    
    //B-01694  (Start)
    public list<SelectOption> ProgramYear {get;set;}
    public string ProgramYearSelected{get;set;}
    
    
    public list<SelectOption> ProgramSeason {get;set;}
    public string ProgramSeasonSelected{get;set;}
    
    public list<SelectOption> IntraxRegion {get;set;}
    public string IntraxRegionSelected{get;set;}
    
    public list<SelectOption> ProgramSvLvl {get;set;}
    public string ProgramSvLvlSelected{get;set;}
    //B-01694  (End)
              
    //public string ApplicationLevelSelected{get;set{ApplicationLevelSelected = value;}}    
    //public list<string> ApplicationStageSelected{get;set{ApplicationStageSelected = value;}}
    public string ApplicationLevelSelected{get;set;}    
    public list<string> ApplicationStageSelected{get;set;}
    
    public list<SelectOption> EngagementStatus {get;set;}
    public list<SelectOption> Status {get;set;}
    public string statusSelected{get;set;}
    public string EngagementStatusSelected {get;set;}
    
    public list<SelectOption> PlacementStatus {get;set;}
    public string PlacementStatusSelected {get;set;}    
    
    public list<SelectOption> SNCIndicated {get;set;}
    public string SNCIndicatedSelected {get;set;}
    
    public string PendingPDOSelected {get;set;}
    public string NeedsTravelSelected{get;set;}
    
    public list<SelectOption> SortBy{get;set;}
    public list<SelectOption> SortByDirection{get;set;}
    
    public list<SelectOption> SortByParticipant{get;set;}
    public list<SelectOption> SortByCampPos{get;set;}
    
    public list<SelectOption> SortByCampaign{get;set;}
    
    public string DoublePlacementSelected {get;set;}
    public string SingleNoChildrenSelected{get;set;}
    public string PendingSchoolSelected{get;set;}
    
    public string PreProgramTripIndicated{get;set;}   
        
    // Campaign Filters
    public string campaignSelected{get;set;}
    public list<SelectOption> activeCampaigns{get;set;}
    
    /*
    // Create new App vars
    public list<SelectOption> appTypeOptions{get;set;}
    public string appTypeSelected{get;set;}
    */
    
    public List<selectOption> getSelectedPicklistValues(string selectedValues){
        list<SelectOption> availableValues = new list<SelectOption>();
        string[] msOptions = new string[]{};
        if(selectedValues != null)
            msOptions = selectedValues.split(';',0);
                        
        if(msOptions.size() > 0){
            for(string option : msOptions){
                availableValues.add(new SelectOption(Option, Option));
            }
        }else{
            availableValues.add(new SelectOption('', 'No values available'));
        }
        
        return availableValues;
    }
    
    public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
      List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
      string DefaultConIP;
      if (first_val != null) { //if there is a first value being provided
         options.add(new selectOption(first_val, first_val)); //add the first option
      }
      Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
      Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
      Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
      List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
       if(field_name == 'Service_Level__c') 
      { 
       //List to hold the Users records
        List<User> users = [select Id, Intrax_Id__c, LocaleSidKey, FirstName, LastName, ContactId, Contact.AccountId, Contact.Intrax_Programs__c, Contact.Intrax_Program_Options_CT__c, Contact.PTR_Portal_Intrax_Program_Default__c,User_Interests__c from User where Id=:userInfo.getUserId()]; 
         if(users.size() > 0 && users != null) {        
             activeUser = users[0];
             }
         
        if(activeUser != null && activeUser.Intrax_Id__c != null) { 
                DefaultConIP = getDefaultIP(); 
        
        }
      
         
      }
      for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
         if (DefaultConIP == 'Work Travel' && field_name == 'Service_Level__c' && a.getLabel() == 'Placement Only')
          {
           system.debug('here to exclude'); 
           //do nothing
          }
         
         else 
          options.add(new selectOption(a.getValue(),a.getLabel())); //add the value and label to our final list
          
      }
     
      return options; //return the List
    } 
    
    
    public List<schema.fieldsetmember> getAssFieldSet(){      
        return getFields('Assessment__c', assessmentField);
    }
    
    public static List<schema.fieldsetmember> getFields(String objectName, String fieldSetName) {  
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();            
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);        
        return fieldSetObj.getFields(); 
    } 
    
    
    //Method to disable next button 
    public Boolean getNextButtonDisabledForParticipant(){
 
        //disable when Index of the page is equal to total number of index OR WHEN THERE 
        return (itotalPageNumber >= iTotalPages);
        //return (pageNumber == listOfListParticipantAndMatch.size() || pageNumber == listOfListParticipantAndMatch.size()-1);
    }
    
    //Method to disable previous button 
    public Boolean getPreviousButtonDisabledForParticipant(){
 
        //or when multiplication of currenjt page no. and page size is > then Paticipant list 
        return (iTotalPageNumber == 1);
        //return (pageNumber == listOfListParticipantAndMatch.size() || pageNumber == 0);
    }
    
    //Set to hold the Participant (Engagement) Ids
    List<String> listEngagementIds;
    
    /*Variable and Getter Setter for Applicant_Info__c (Application) record */
    
    //Instance of Application
    public Applicant_Info__c application {get; set;}
    public list<Applicant_Info__c> applicantRecords {get;set;}
    
    //List of lists of Applicant Info helpful in Pagination
    public List<List<Applicant_Info__c>> listOfListApplication {get; set;}
    
    //List of Applicant Info records
    public List<Applicant_Info__c> listApplication {        
        get{            
            System.debug('----->GET:pageNumber:'+pageNumber);
            
            if(itotalPageNumber > integer.valueOf(iLIMIT/integer.valueOf(limits))){//90>80                                                    
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));//90-80
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                system.debug('------>GET INSIDE:totalPageNumber'+totalPageNumber);//10
                pageNumber = totalPageNumber - 1;           
            }
            System.debug('----->GET: after pageNumber:'+pageNumber);
            //Return listOfListApplication with its correspondinbg index i.e pageNumber
            return listOfListApplication[pageNumber];
            
        } set; 
    }
    
    //Method to disable next button 
    public Boolean getNextButtonDisabled(){
 
        //disable when Index of the page is equal to total number of index OR WHEN THERE 
        return (itotalPageNumber >= iTotalPages);
        //return (pageNumber == listOfListApplication.size() || pageNumber == listOfListApplication.size()-1);
    }
    
    //Method to disable previous button 
    public Boolean getPreviousButtonDisabled(){
 
        //or when multiplication of currenjt page no. and page size is > then applicantInfo list 
        return (iTotalPageNumber == 1);
        //return (pageNumber == listOfListApplication.size() || pageNumber == 0);
    }
    
    /*Attachment insatnce have Applicant photo with it*/
    
    //Attachment Instance
    public Attachment attachment {get; set;}
    
    //Instance to hold the Personl Info record details associated with Applicant Info record
    public Person_Info__c personInfo {get; set;}
    List<Person_Info__c> listPersonInfo {get; set;}
    list<Audit_Info__c> listAuditInfo {get;set;}
    public Audit_Info__c auditInfo {get;set;}
    
    //String to hold Intrax Program Options
    String optionsString;
 
    /*Variable and Getter Setter for Match__c (Match) record */
    
    //Instance of Match
    public Match__c match {get; set;}
    public string matchId {get; set;}
    
    public Match__c newMatch {get;set;}

    //List of lists of Matches helpful in Pagination
    public List<List<Match__c>> listOfListMatches {get; set;}
    
    //List of Match records
    public List<Match__c> listMatches {
        get{
            //Return listOfListMatches with its correspondinbg index i.e pageNumber
            return listOfListMatches[pageNumber];
            
        } set; 
    }
       
    //Method to disable next button 
    public Boolean getNextButtonDisabledForMatches(){
 
        //disable when Index of the page is equal to total number of index OR WHEN THERE 
        return (pageNumber == listOfListMatches.size() || pageNumber == listOfListMatches.size()-1);
    }
    
    //Method to disable previous button 
    public Boolean getPreviousButtonDisabledForMatches(){
 
        //or when multiplication of currenjt page no. and page size is > then Matches list 
        return (pageNumber == listOfListMatches.size() || pageNumber == 0);
    }
    
    /*Variable for Trip__c (trips) record */
    
    //Trip Object record Instance
    public Trip__c trip {get; set;}
    public Trip__c newTrip {get;set;}
    
    //List of Trip records going to be displayes on Page
    public list<Trip__c> listTrips{get;set;}
    
    //List to hold the Match records
    public list<Match__c> selectedMatches {get;set;}
    
    public list<Match__c> selectedConfirmMatches {get;set;}
    
    
    //Boolean Variable helpful in rerendering
    public Boolean showTravelForm {get; set;}
    public Boolean showTripAfterSave {get; set;}
    
    //Trip record Id is going to be delete
    public Id tripIdForDelete {get; set;}

    
    
    
    /*Variable and Getter Setter for Assessment__c (Assessment) record */
    
    //Variable to hold the insatance for Assessment object
    public Assessment__c assessment {get; set;}
    
    //List of lists of Assessment helpful in Pagination
    public List<List<Assessment__c>> listOfListAssessment {get; set;}
    
    //List of Assessment records
    public List<Assessment__c> listAssessment {
        get{
            //Return listOfListAssessment with its correspondinbg index i.e pageNumber
            return listOfListAssessment[pageNumber];
            
        } set; 
    }
    
    
    //Method to disable next button 
    public Boolean getNextButtonDisabledForAssessments(){
 
        //disable when Index of the page is equal to total number of index OR WHEN THERE 
        return (pageNumber == listOfListAssessment.size() || pageNumber == listOfListAssessment.size()-1);  
    }
    
    //Method to disable previous button   
    public Boolean getPreviousButtonDisabledForAssessments(){
 
        //or when multiplication of currenjt page no. and page size is > then Matches list 
        return (pageNumber == listOfListAssessment.size() || pageNumber == 0);
    }
    
    /*Work Around for select options list for Page size selection*/
    
    //String to hold the limit value
    public String limits{set;get;}
    
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        return options;
    }
    
    /*Work Around for Sorting of Table*/
      
    //String helpful in sorting
    private String sortDirection = 'ASC';
    private String sortExp = 'Name';
    
    //String to hold sorting full Expression
    String sortFullExp;
    
    //Getter Setter for getting the value for Sort Expression
    public String sortExpression{
      
      get {
        
          //return value of list to sort
          return sortExp;
      }
      
      set {
            system.debug('***** value: ' + value);
            system.debug('***** SortExp:' + SortExp);
            system.debug('***** SortDirection:' + SortDirection);
          //if the column is clicked on then switch between Ascending and Descending modes
          if (value == sortExp) {
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
          } else {
                sortDirection = 'ASC';
          }
          
            //String Value
            sortExp = value;
        }
    }
    
    //Method for getting sort direction value
    public String getSortDirection(){
        
        //if column is selected retrun it ascending
        if (sortExpression == null || sortExpression == '') {
          return 'ASC';
        } else {
          return sortDirection;
        }
    }
    
    //Method for setting sort direction value
    public void setSortDirection(String value){  
    
        sortDirection = value;
    }
    
    //Storing for Assessments
    private String sortDirectionForAssessments = 'ASC';
    private String sortExpForAssessments = 'name';
    
    //String to hold sorting full Expression
    String sortFullExpForAssessments;
    
    //Getter Setter for getting the value for Sort Expression 
    public String sortExpressionForAssessments {
      
      get {
        
          //return value of list to sort
          return sortExpForAssessments;
      }
      
      set {
        
          //if the column is clicked on then switch between Ascending and Descending modes
          if (value == sortExpForAssessments) {
                sortDirectionForAssessments = (sortDirectionForAssessments == 'ASC')? 'DESC' : 'ASC';
          } else {
                sortDirectionForAssessments = 'ASC';
          }
          
            //String Value
            sortExpForAssessments = value;
        }
    }
   
    //Method for getting sort direction value
    public String getSortDirectionForAssessments(){
        
        //if column is selected retrun it ascending
        if (sortExpressionForAssessments == null || sortExpressionForAssessments == '') {
          return 'ASC';
        } else {
          return sortDirectionForAssessments;
        }
    }
    
    //Method for setting sort direction value
    public void setSortDirectionForAssessments(String value){  
    
        sortDirectionForAssessments = value;
    }
    
    /*Workaround for Select option list displayed on Participants and Matches Pages*/
    
    //Engagement__c (Participants)
    public String selectedParticipant {get; set;}
    public List<SelectOption> participantOptions {get; set;}
    public Boolean isSelectedParticipant {get; set;}
    
    //Matches
    public String selectedMatch {get; set;}
    public List<SelectOption> matchOptions {get; set;}
    public Boolean isSelectedMatch {get; set;}
    
    /*
    public boolean getisAppEditable(){
        system.debug('********** APP STAGE: + ' + application.Application_Stage__c );
        if(application.Application_Stage__c == 'Working' || application.Application_Stage__c == 'Submitted' || application.Application_Stage__c == 'Conditional'){
            return true;
        }
        else return false;
    }
    */
    
    public Applicant_Info__c applicantInfo {get;set;}
    
    public list<Accommodation_Option__c> AccOptionInfoList{get;set;}
    //Constructor
           
           
    public string engagementIntraxProgram{
        get{
            return match.Engagement__r.Intrax_Program__c;
        }
    }
    
    public list<SelectOption> createMatchOptions {get;set;}
    public list<Engagement__c> selectedEngagements  {get;set;}
    public string EngagementId {get;set;}
    public string positionId {get;set;}       
    
    public pageReference createMatch(){
        system.debug('Inside Create Match method');
        Pagereference p = new Pagereference('/apex/pr_match_new');
        
        // Initial Checks
        /* IGI 534
        if((newMatch.Start_Date__c < positionInfo.Engagement_Start__c) || (newMatch.Start_Date__c > positionInfo.Engagement_Latest_Start__c)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date must be within ' + string.valueOf(positionInfo.Engagement_Start__c) + ' and ' + string.ValueOf(positionInfo.Engagement_Latest_Start__c));
            ApexPages.addMessage(msg);
            return null;
        }
        if((newMatch.End_Date__c < positionInfo.Engagement_Earliest_End__c) || (newMatch.End_Date__c > positionInfo.Engagement_End__c)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'End Date must be within ' + string.valueOf(positionInfo.Engagement_Earliest_End__c) + ' and ' + string.ValueOf(positionInfo.Engagement_End__c));
            ApexPages.addMessage(msg);
            return null;
        }
        
        if((engagementId == null && positionId == null) || newMatch.Start_Date__c == null || newMatch.End_Date__c == null || newMatch.Consider_Other_Positions__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You are missing one or more of the required fields below.');
            ApexPages.addMessage(msg);
            return null;
        }
        */
        //Pagereference p = new Pagereference('/apex/pr_match_new');
        if(ApexPages.CurrentPage().getParameters().get('mOrigin') == 'pos') {
            Engagement__c eng = [SELECT Id, Name, Account_Id__c, Opportunity_Id__c, Engagement_Start__c,Engagement_End__c FROM Engagement__c WHERE Id =: engagementId];
            
            if (newMatch.Start_Date__c == null || newMatch.Start_Date__c < eng.Engagement_Start__c || newMatch.Start_Date__c > eng.Engagement_End__c || newMatch.End_Date__c < eng.Engagement_Start__c ||  newMatch.End_Date__c > eng.Engagement_End__c)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date and End Date must be within ' + string.valueOf(eng.Engagement_Start__c) + ' and ' + string.ValueOf(eng.Engagement_End__c));
                ApexPages.addMessage(msg);
                return null;
            }
            
            if (newMatch.Start_Date__c > newMatch.End_Date__c)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date must be less than End Date');
                ApexPages.addMessage(msg);
                return null;
            }
            
            newMatch.Name = (positionInfo.Name + ' - ' + eng.Name).left(80);
            newMatch.Position_Name__c = positionInfo.Id;
            newMatch.Engagement__c = eng.Id;
            newMatch.Participant_Opportunity_Id__c = eng.Opportunity_Id__c;
            newMatch.Participant_Id__c = eng.Account_Id__c;
            
            //IGI - 805 (Start)
            if(ApexPages.CurrentPage().getParameters().get('CampID') != null && ApexPages.CurrentPage().getParameters().get('CampID') != '')
            {
                newMatch.Campaign__c = ApexPages.CurrentPage().getParameters().get('CampID');
            }
            //IGI - 805 (End)
        }
        else if(ApexPages.CurrentPage().getParameters().get('mOrigin') == 'mat' ) {
           
            Position__c pos = [SELECT Id, Name FROM Position__c WHERE Id =: engagementId];
            
            if (newMatch.Start_Date__c == null || newMatch.Start_Date__c < participant.Engagement_Start__c || newMatch.Start_Date__c > participant.Engagement_End__c || newMatch.End_Date__c < participant.Engagement_Start__c ||  newMatch.End_Date__c > participant.Engagement_End__c)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date and End Date must be within ' + string.valueOf(participant.Engagement_Start__c) + ' and ' + string.ValueOf(participant.Engagement_End__c));
                ApexPages.addMessage(msg);
                return null;
            }
            
            if (newMatch.Start_Date__c > newMatch.End_Date__c)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date must be less than End Date');
                ApexPages.addMessage(msg);
                return null;
            }
            
            newMatch.Name = (pos.Name + ' - ' + participant.Name).left(80);
            newMatch.Position_Name__c = pos.Id;
            newMatch.Engagement__c = participant.Id;
            newMatch.Participant_Opportunity_Id__c = participant.Opportunity_Id__c;
            newMatch.Participant_Id__c = participant.Account_Id__c;
            
            Campaign[] camp = [Select ID, Name from Campaign where Name =: mapEnglabel.get(engagementId)]; 
            if(camp[0]!=null)
            {
             newMatch.Campaign__c = camp[0].Id;
            } 
            
        }
        if(newMatch.Participant_Id__c!=null && newMatch.Consider_Other_Positions__c!=null && newMatch.Start_Date__c!=null && newMatch.End_Date__c!=null ){
        
            newMatch.RecordTypeId = Constants.MAT_INTERNSHIP;
            newMatch.Status__c = 'Applied';
            
            insert newMatch;
            
            if(ApexPages.CurrentPage().getParameters().get('mOrigin') == 'pos') 
            {
                P.getParameters().put('pId',  positionInfo.Id);
                P.getParameters().put('mOrigin', 'pos');
                if(ApexPages.CurrentPage().getParameters().get('CampID') != null && ApexPages.CurrentPage().getParameters().get('CampID') != '')
                {
                    P.getParameters().put('CampID',  ApexPages.CurrentPage().getParameters().get('CampID'));
                }
            }
            
            if(ApexPages.CurrentPage().getParameters().get('mOrigin') == 'mat') 
            {
                P.getParameters().put('participantId',  participant.Id);
                P.getParameters().put('mOrigin', 'mat');
            }
            
            //p.setRedirect(true);
            //return p;
            //B-01696 (Start)
            string redPage = '/apex/pr_match_new_confirm';
            if(ApexPages.CurrentPage().getParameters().get('mOrigin') == 'mat' )
            {
                redPage = '/apex/pr_pt_matches';
            }
            Pagereference pRedir = new Pagereference(redPage);
            if(ApexPages.CurrentPage().getParameters().get('mOrigin') == 'mat') 
            {
                pRedir.getParameters().put('participantId',  participant.Id);
            }
            pRedir.setRedirect(true);
            return pRedir;
            //B-01696 (End)
        }
        
        else{
            p = new PageReference('/apex/pr_match_new?pId=' +engagement.Id + 'mOrigin='+ ApexPages.CurrentPage().getParameters().get('mOrigin'));
            p.setRedirect(true);
            return p;
        }
    }
    
    
    public Integer iLIMIT {get; set;} 
    public Integer iOffset {get; set;}
    public Decimal totalCount{get;set;}
    public Decimal totalCount_App{get;set;}
    public Map<Integer,String> mapUpdateQuery{get;set;}
    public Map<Integer,Integer> mapOffset{get;set;}
    public string flag;
    public string AppName{get;set;}
    public string EngName{get;set;}
    
    public IntraxPartnerPortalEngineController() {
        
        //AA-B-01806
        if(!Test.isRunningTest()) {
            if(ApexPages.currentPage().getUrl().contains('/apex/SiteDocViewer')){
               system.debug('@@@@@ SitedocView');
               ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, we appear to be unable to locate this file. Document GUID= '+ApexPages.currentPage().getParameters().get('docGuid'));
               ApexPages.addMessage(msg); 
            }
        }        
        
        system.debug('***** Are we here?');
                                                
        ShowTripInfoType = '';
        
        if(ApexPages.currentPage().getParameters().get('CampId') != null)
        {
            CampStrURL = ApexPages.currentPage().getParameters().get('CampId');
        }
        
        
        
        campaignPositionWrapper = new map<String, list<Campaign_Position__c>> ();
        //campaignIds = new set<String>();
        //cpInfo = new Campaign_Position__c(); 
        
        /*
        appTypeOptions = new list<SelectOption>();
        appTypeOptions.add(new SelectOption('IGI', 'Intrax Global Internship Application'));
        appTypeOptions.add(new SelectOption('WT', 'Work and Travel Application'));
        */
        
        DocuSignEnvMap = new map<String, String>();
        
        activeCampaigns = new list<SelectOption>();
        
        applicantInfo = new Applicant_Info__c();
        
        //Memory Allocation to the collections and Instances
        fileUploadUrl = Constants.fileUploadUrl;   
        hostCompany = new Account();
        hostContact = new Contact();
      
        system.debug('USERTYPE '+userInfo.getUserType());
        listOfListParticipantAndMatch = new List<List<EngagementMatchWrapper>>();
        participant = new Engagement__c();
        participantRecords = new list<Engagement__c>();
        totalRecords = new List<Engagement__c>();
        listEngagementIds = new List<String>();
        
        listOfListapplication = new List<List<Applicant_Info__c>>();
        application = new Applicant_Info__c();
        applicantRecords = new List<Applicant_Info__c>();

        personInfo = new Person_Info__c();
        attachment = new Attachment();
        listPersonInfo = new List<Person_Info__c>();
        auditInfo = new Audit_Info__c();
        listAuditInfo = new list<Audit_Info__c>();
        
        listOfListMatches = new List<List<Match__c>>();
        match = new Match__c();
        newMatch = new Match__c();
        
        mapParticipantIdWithMatch = new Map<Id, Match__c>();
        
        selectedMatches = new List<Match__c>();  
        
        selectedConfirmMatches = new List<Match__c>(); 
        
        applicationRecord = new Applicant_Info__c();
        
        DocapplicationRecord = new Applicant_Info__c();
        
        familyApp = new Applicant_Info__c();
        familyInfo = new list<Person_Info__c>();
       
        assessment = new Assessment__c();
        listOfListAssessment = new List<List<Assessment__c>>();
        //RS Added
        posInfo = new list<Position_Info__c>(); 
        ayusaContact = new list<User>();
        ContactUser = new Contact();
        AccountUser = new Account();
        ManagerUser = new User();
        positionInfo = new Position__c();
        
        FamilyPhotos = new list<Intrax_Program_Upload__c>();
        PosInfo_Status = new  Map<String, String>();
       
        
        // Filling filter values
        //applicationLevel = getPickValues(application, 'Application_Level__c', null);
        applicationLevel = new list<SelectOption>();
        applicationLevel.add(new SelectOption('Basic', 'Basic'));
        applicationLevel.add(new SelectOption('Main', 'Main'));
        
        /*applicationLevelWT = new list<SelectOption>();
        applicationLevelWT.add(new SelectOption('Basic', 'Basic'));
        applicationLevelWT.add(new SelectOption('Main', 'Main'));
        */
        applicationStage = getPickValues(application, 'Application_Stage__c', null);
        applicationStageWT = new list<SelectOption>();
        applicationStageWT.add(new SelectOption('Working', 'Working'));
        applicationStageWT.add(new SelectOption('Submitted', 'Submitted'));
        applicationStageWT.add(new SelectOption('In-Review', 'In-Review'));
        applicationStageWT.add(new SelectOption('Accepted', 'Accepted'));
        applicationStageWT.add(new SelectOption('Declined - Agent', 'Declined - Agent'));
        applicationStageWT.add(new SelectOption('Declined - Inbound Country', 'Declined - Inbound Country'));
        
                
        applicationStageAPC = new list<SelectOption>();
        applicationStageAPC.add(new SelectOption('Working', 'Working'));
        applicationStageAPC.add(new SelectOption('Submitted', 'Submitted'));
        applicationStageAPC.add(new SelectOption('In-Review', 'In-Review'));
        applicationStageAPC.add(new SelectOption('Conditional', 'Conditional'));
        applicationStageAPC.add(new SelectOption('Accepted', 'Accepted'));
        applicationStageAPC.add(new SelectOption('Declined', 'Declined'));
        applicationStageAPC.add(new SelectOption('Declined - Agent', 'Declined - Agent'));
        applicationStageAPC.add(new SelectOption('Cancelled', 'Cancelled'));
        
        programDuration = new list<SelectOption>();
        programDuration.add(new SelectOption('Fall Semester', 'Fall Semester'));
        programDuration.add(new SelectOption('Spring Semester', 'Spring Semester'));
        programDuration.add(new SelectOption('Academic Year', 'Academic Year'));
        
        views = new List<SelectOption>();
        views.add(new SelectOption('Interviews to Start', 'Interviews to Start'));
        views.add(new SelectOption('Interviews to Complete', 'Interviews to Complete'));
        views.add(new SelectOption('Health Forms to Review', 'Health Forms to Review'));
        views.add(new SelectOption('BG Checks to Review', 'BG Checks to Review'));
        views.add(new SelectOption('School Details to Verify', 'School Details to Verify'));
        
        //JOSE B-03077 -- Vies List for Participant Page pr_pt_list.page
        viewsEng = new List<SelectOption>();
        viewsEng.add(new SelectOption('Awaiting Placement', 'Awaiting Placement'));
        viewsEng.add(new SelectOption('Active Interviews', 'Active Interviews'));
        viewsEng.add(new SelectOption('In-Country', 'In-Country'));
        viewsEng.add(new SelectOption('Interview Feedback', 'Interview Feedback'));
        viewsEng.add(new SelectOption('New Matches (last 30 days)', 'New Matches (last 30 days)'));
        viewsEng.add(new SelectOption('Extensions', 'Extensions'));
        viewsEng.add(new SelectOption('Pre-Arrival', 'Pre-Arrival'));
        viewsEng.add(new SelectOption('On Program (In USA)', 'On Program (In USA)'));
        //END JOSE B-03077
                        
        //B-01694  (Start)
        programYear = new list<SelectOption>();
        //programYear.add(new SelectOption('2014', '2014'));
        //programYear.add(new SelectOption('2015', '2015'));                              
        
        ProgramSeason = getPickValues(participant, 'Season__c', null);
        IntraxRegion = getPickValues(participant, 'Intrax_Region__c', null);
        
        ProgramSvLvl = getPickValues(participant, 'Service_Level__c', null);
        //B-01694  (End)      
        
        /*system.debug('***** IPS: ' + IntraxProgramSelected);
        IntraxProgramSelected = '';
        system.debug('***** IPS: ' + IntraxProgramSelected);
        */        
        
        Status = new list<SelectOption>();
        Status.add(new SelectOption('Match Pending', 'Match Pending'));
        Status.add(new SelectOption('Matched', 'Matched'));
        Status.add(new SelectOption('Off Program', 'Off Program'));
        
        Position__c p = new Position__c();
        SNCIndicated = getPickValues(p, 'Single_No_Children_Indicated__c', null);
        
        //PlacementStatus = getPickValues(participant, 'Placement_Status__c', null);
        PlacementStatus = new list<SelectOption>();
        PlacementStatus.add(new SelectOption('Confirmed', 'Confirmed'));
        PlacementStatus.add(new SelectOption('Not Placed', 'Not Placed'));
        PlacementStatus.add(new SelectOption('Pending', 'Pending'));        
        
        //B-02446 (Start)               
        EngagementStatus = new List<SelectOption>();
        EngagementStatus.add(new SelectOption('Processing','Processing'));
        EngagementStatus.add(new SelectOption('Program Ready','Program Ready'));
        EngagementStatus.add(new SelectOption('On Program','On Program'));
        EngagementStatus.add(new SelectOption('Program Complete','Program Complete'));
        EngagementStatus.add(new SelectOption('Cancelled','Cancelled'));
        EngagementStatus.add(new SelectOption('Early Departure','Early Departure'));
        EngagementStatus.add(new SelectOption('Terminated','Terminated'));                   
        //B-02446 (End)
        
        SortBy = new list<SelectOption>();
        SortBy.add(new SelectOption('Name', 'Name'));
        SortBy.add(new SelectOption('Intrax_Program__c', 'Program Name'));
        SortBy.add(new SelectOption('Program_Duration__c', 'Program Duration'));
        SortBy.add(new SelectOption('Application_Level__c', 'Application Level'));
        SortBy.add(new SelectOption('Application_Stage__c', 'Application Stage'));
        SortBy.add(new SelectOption('CreatedDate', 'Creation Date'));
        SortBy.add(new SelectOption('Last_Applicant_Update__c', 'Last Update (By Applicant)'));
        SortBy.add(new SelectOption('Submitted_Date__c', 'Submission Date'));
        
        SortByParticipant = new list<SelectOption>();
        SortByParticipant.add(new SelectOption('Name', 'Name'));
        SortByParticipant.add(new SelectOption('Program_Duration__c', 'Program Duration'));
        SortByParticipant.add(new SelectOption('Status__c', 'Engagement Status'));
        SortByParticipant.add(new SelectOption('Engagement_Start__c', 'Engagement Start'));
        SortByParticipant.add(new SelectOption('Engagement_End__c', 'Engagement End'));
        SortByParticipant.add(new SelectOption('Last_Match_Date__c', 'Last Match Date'));
        
        SortByCampPos = new list<SelectOption>();
        SortByCampPos.add(new SelectOption('Position__r.Host_Company_Id__c','Name1'));
        SortByCampPos.add(new SelectOption('Position__r.Code__c','Position Code'));
        SortByCampPos.add(new SelectOption('Expiration_Date__c','Expiration Date'));
        SortByCampPos.add(new SelectOption('Allocated_Quantity__c','Allocated Quantity'));
        SortByCampPos.add(new SelectOption('Position__r.City__c','City'));
        SortByCampPos.add(new SelectOption('Position__r.State__c','State'));
        SortByCampPos.add(new SelectOption('Position__r.Gender_Preference__c','Gender Preference'));
        SortByCampPos.add(new SelectOption('Position__r.Language_1_Proficiency__c','English Level'));
        SortByCampPos.add(new SelectOption('Position__r.Engagement_Start__c','Earliest Start Date'));
        SortByCampPos.add(new SelectOption('Position__r.Engagement_Latest_Start__c','Latest Start Date'));
        SortByCampPos.add(new SelectOption('Position__r.Engagement_Earliest_End__c','Earliest End Date'));
        SortByCampPos.add(new SelectOption('Position__r.Engagement_End__c','Latest End Date'));

        SortByCampaign = new list<SelectOption>();
        SortByCampaign.add(new SelectOption('Campaign__r.Name', 'Campaign Name'));
        
        SortByDirection = new list<SelectOption>();
        SortByDirection.add(new SelectOption('ASC', 'Ascending'));
        SortByDirection.add(new SelectOption('DESC', 'Descending'));
        
        
        //Memory Allocation to select Options list
        matchOptions = new List<SelectOption>();
        participantOptions = new List<SelectOption>();
        
        //Setting flag values
        isSelectedMatch = false;
        isSelectedParticipant = false;
        showTripAfterSave = false;
        showTravelForm = false;
        
        newTrip = new Trip__c();
        
        //Setting default values for the varaiables
        pageNumber = 0;
        totalPageNumber = 1; 
        limits = '5';
        iTotalPageNumber = 1;
        
        //Set to hold the Program options will use in WHERE clause of SOQL
        List<String> intraxProgramOptionsList = new List<String>();
        
        //Populate Set with values
        intraxProgramOptionsList.add('Ayusa High School');
        intraxProgramOptionsList.add('YES');
        
        //Getting String values (Intrax Program Options)
        optionsString = quotedString(intraxProgramOptionsList);
        
        //List to hold the Users records
        List<User> users = [select Id, Intrax_Id__c, LocaleSidKey, FirstName, LastName, ContactId, Contact.AccountId, Contact.Intrax_Programs__c, Contact.Intrax_Program_Options_CT__c, Contact.PTR_Portal_Intrax_Program_Default__c,User_Interests__c from User where Id=:userInfo.getUserId()]; 
        
        //Check for list size
        if(users.size() > 0 && users != null) {        
    
            //Getting current logged in user value
            activeUser = users[0];
            
            if(activeUser.Contact.AccountId !=null){
                list<Account> accParntnerList = [select Id, Name, APC_Recruitment_Goal__c FROM Account WHERE Id =: activeUser.Contact.AccountId]; 
                accParntner = accParntnerList[0];
            }
        } 
                        
        String pageName = ApexPages.CurrentPage().getUrl();         
        if(pageName != null){
            pageName = pageName.replaceFirst('/apex/','');
        }
        System.debug('---pagename--->'+pageName); 
                        
        if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
            intraxProgramSelected = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;
        } 
        
        //Adding picklist values even when coming from quicklinks. (hence using contains)
        if(pageName.contains('pr_app_list') || pageName.contains('pr_pt_list')) {
            if(intraxProgramSelected == 'Work Travel' || intraxProgramSelected == 'Internship' || intraxProgramSelected == 'AuPairCare'){
                programYear.add(new SelectOption('2014', '2014'));
                programYear.add(new SelectOption('2015', '2015'));
            }
            if(intraxProgramSelected == 'Work Travel' || intraxProgramSelected == 'Internship' ){                                             
                programYear.add(new SelectOption('2016', '2016'));//B-02240
            }
            if(intraxProgramSelected == 'Ayusa'){
                programYear = new list<SelectOption>();                              
                programYear.add(new SelectOption('2014-2015', '2014-2015'));
                programYear.add(new SelectOption('2015-2016', '2015-2016'));
                programYear.add(new SelectOption('2016-2017', '2016-2017'));//B-02332
            }
            
        }
        //RS Added
        if(pageName.contains('pr_pt_match_details') || pageName.contains('pr_pt_match_details')) {
        if(ApexPages.currentPage().getParameters().get('matchId') != null)
              {
              system.debug(' Inside positionInfo');
              posInfo=[select id,status__c from Position_Info__c where Match__c =:Id.valueof(ApexPages.currentPage().getParameters().get('matchId'))limit 1];
              system.debug('positionInfo : '+posInfo.size());
              }
        }        
                                                  
        iLIMIT = 400; 
        iOffset = 0;
        
        //JOSE B-03077
        if(ApexPages.currentPage().getUrl().contains('/apex/pr_pt_list')){ 
            
            if(ApexPages.currentPage().getParameters().get('awaitingEngs') != NULL){
                awaitingEngsParam = ApexPages.currentPage().getParameters().get('awaitingEngs');
                viewSelected = 'Awaiting Placement';
                
            }else if(ApexPages.currentPage().getParameters().get('actInterEngs') != NULL){
                activeInterEngsParam = ApexPages.currentPage().getParameters().get('actInterEngs');
                viewSelected = 'Active Interviews';
                
            }else if(ApexPages.currentPage().getParameters().get('inCountryEngs') != NULL){
                inCountryEngsParam = ApexPages.currentPage().getParameters().get('inCountryEngs');
                viewSelected = 'In-Country';
                
            }else if(ApexPages.currentPage().getParameters().get('interFeedEngs') != NULL){
                interviewFeedbackEngsParam = ApexPages.currentPage().getParameters().get('interFeedEngs');
                viewSelected = 'Interview Feedback';
                
            }else if(ApexPages.currentPage().getParameters().get('newMatchesEngs') != NULL){
                newMatchesEngsParam = ApexPages.currentPage().getParameters().get('newMatchesEngs');
                viewSelected = 'New Matches (last 30 days)';
                
            }else if(ApexPages.currentPage().getParameters().get('extensionEngs') != NULL){
                extensionEngsParam = ApexPages.currentPage().getParameters().get('extensionEngs');
                viewSelected = 'Extensions';
                
            }else if(ApexPages.currentPage().getParameters().get('preArrivalEngs') != NULL){
                preArrivalEngsParam = ApexPages.currentPage().getParameters().get('preArrivalEngs');
                viewSelected = 'Pre-Arrival';
                
            }else if(ApexPages.currentPage().getParameters().get('ProgramUSAEngs') != NULL){
                ProgramUSAEngsParam = ApexPages.currentPage().getParameters().get('ProgramUSAEngs');
                viewSelected = 'On Program (In USA)';
                
            }
        }
        //END JOSE B-03077
        
        //B-01905
        if(ApexPages.currentPage().getUrl().contains('/apex/pr_home') || ApexPages.currentPage().getUrl().contains('/apex/pr_app_list')){            
            mainSubmittedApps = new Set<Id>();
            
            mainWorkingApps = new Set<Id>();
            
            incompleteAssApps = new Set<Id>();
            notStartedAssApps = new Set<Id>();
            toHealthReviewApps = new Set<Id>();
            bgCheckReviewApps = new Set<Id>();
            schoolDetailsVerifyApps = new Set<Id>();
            
            
            //JOSE B-03077
            ActiveInterviewsEng = new Set<Id>();
            submittedApps = new Set<Id>();
            acceptedApps = new Set<Id>();
            //END JOSE B-03077
            
            if(ApexPages.currentPage().getParameters().get('notStartedAssApps') != NULL){
                notStartedAssAppsParam = ApexPages.currentPage().getParameters().get('notStartedAssApps');
                viewSelected = 'Interviews to Start';
            }
            if(ApexPages.currentPage().getParameters().get('incompleteAssApps') != NULL){
                incompleteAssAppsParam = ApexPages.currentPage().getParameters().get('incompleteAssApps');
                viewSelected = 'Interviews to Complete';
            }
            if(ApexPages.currentPage().getParameters().get('toHealthReviewApps') != NULL){
                toHealthReviewAppsParam = ApexPages.currentPage().getParameters().get('toHealthReviewApps');
                viewSelected = 'Health Forms to Review';
            }
            if(ApexPages.currentPage().getParameters().get('bgCheckReviewApps') != NULL){
                bgCheckReviewAppsParam = ApexPages.currentPage().getParameters().get('bgCheckReviewApps');
                viewSelected = 'BG Checks to Review';
            }
            if(ApexPages.currentPage().getParameters().get('schoolDetailsVerifyApps') != NULL){
                schoolDetailsVerifyAppsParam = ApexPages.currentPage().getParameters().get('schoolDetailsVerifyApps');
                viewSelected = 'School Details to Verify';
            }
            if(ApexPages.currentPage().getParameters().get('submittedApps') != NULL){
                submittedAppsParam = ApexPages.currentPage().getParameters().get('submittedApps');
                viewSelected = 'Accepted Applications';
            }
            if(ApexPages.currentPage().getParameters().get('acceptedApps') != NULL){
                acceptedAppsParam = ApexPages.currentPage().getParameters().get('acceptedApps');
                viewSelected = 'Accepted Applications';
            }
            
            
            inCompleteAssAppsSize = 0;
            notStartedAssAppsSize = 0;
            toHealthReviewAppsSize = 0;   
            bgCheckReviewAppsSize = 0;  
            schoolDetailsVerifyAppsSize = 0;
            
            FlagAppsCount = 0;
            DecAppsCount = 0;
            SubAppsCount = 0;
            AccAppsCount = 0;
            
            
            
            //JOSE B-03077
            ActiveInterviewsEng = new Set<Id>();
            Set<Id> InterviewFeedEng = new Set<Id>();
            Set<Id> AllAcceptedAPCEng = new Set<Id>();
            
            //END JOSE B-03077 
            
            //JOSE B-03077
            AwaitingCount = 0;
            ActiInterviewsCount = 0;
            InCountryCount = 0;
            InterviewFeedCount = 0;
            
            NewMatch30Count = 0;
            ExtensionEngCount = 0;
            PreArrivalCount = 0;
            OnProgramCount = 0;
            
            AppSubLastYearCount = 0;
            AppAcceptedLastYearCount = 0;
            
            Integer CurrentYear = system.today().year();
            Date yearStart = date.newInstance(CurrentYear, 1, 1);
            Date yearEnd = date.newInstance(CurrentYear, 12, 31);
            system.debug('@@@@yearStart: ' + yearStart);
            //END JOSE B-03077 
            
            system.debug('Entered ====');
            //Check for current user Intrax Id value 
            if(activeUser != null && activeUser.Intrax_Id__c != null) {                     
                string IP;
                List<String> contactIPList = new List<String>();
                string DefaultConIP;
                
                if(activeUser.Contact.Intrax_Programs__c != null){
                    IP = activeUser.Contact.Intrax_Programs__c;
                    contactIPList = IP.split(';');
                }
                
                if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                    DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
                }
                System.debug('userId===='+activeUser.Intrax_Id__c);
                if(activeUser.Intrax_Id__c != NULL && DefaultConIP!= NULL){
                    List<Applicant_Info__c> appList = [SELECT Id,Partner_Intrax_Id__c, Type__c,Intrax_program__c,Application_Level__c, PageStatus_Complete__c, Application_Stage__c, Application_Type__c, CreatedDate,
                                                    Engagement__c, Engagement__r.Name, Engagement__r.Status__c, Engagement__r.Placement_Status__c, Engagement__r.In_Country__c
                                                    FROM Applicant_Info__c 
                                                    WHERE Partner_Intrax_Id__c =: activeUser.Intrax_Id__c AND Type__c = 'Participant' 
                                                    AND Intrax_Program__c =: DefaultConIP AND ( (Application_Level__c = 'Basic' AND Application_Stage__c = 'Submitted')
                                                    OR (Application_Stage__c = 'Declined - Agent') OR (Application_Stage__c = 'Declined') OR (Application_Stage__c = 'Declined - Ayusa')
                                                    OR (Application_Stage__c = 'Declined - Inbound Country')
                                                    OR (Application_Level__c = 'Main' AND Application_Stage__c = 'Submitted')
                                                    OR (Application_Stage__c = 'Accepted') OR (Application_Level__c = 'Main' AND Application_Stage__c = 'Working'))];
                                    
                    System.debug('size===='+appList.size());                                
                    if(appList!=null && appList.size()>0){
                        for(Applicant_Info__c app:appList){
                            if(app.Application_Level__c == 'Basic' && app.Application_Stage__c == 'Submitted'){
                                FlagAppsCount = FlagAppsCount+1;
                            }
                            else if(app.Application_Stage__c == 'Declined - Agent' || app.Application_Stage__c == 'Declined' || app.Application_Stage__c == 'Declined - Ayusa' || app.Application_Stage__c == 'Declined - Inbound Country'){
                                DecAppsCount = DecAppsCount+1;
                            }
                            else if( app.Application_Level__c == 'Main' && app.Application_Stage__c == 'Working'){
                                mainWorkingApps.add(app.Id);
                                 system.debug('***mainWorkingApps********* app.Id: ' + app.Id);
                            }
                            else if(app.Application_Level__c == 'Main' && app.Application_Stage__c == 'Submitted'){
                                SubAppsCount = SubAppsCount+1;
                                mainSubmittedApps.add(app.Id);
                                //partner review page is not complete && participant's health overview is complete
                                if(app.PageStatus_Complete__c!=null){
                                    if((!(app.PageStatus_Complete__c.Contains('041'))) && (app.PageStatus_Complete__c.Contains('016'))){
                                        toHealthReviewApps.add(app.Id);
                                    }
                                    if(!app.PageStatus_Complete__c.Contains('046')){
                                        bgCheckReviewApps.add(app.Id);
                                    }
                                    if(!app.PageStatus_Complete__c.Contains('047')){
                                        schoolDetailsVerifyApps.add(app.Id);
                                    }                                       
                                }
                            }
                            else if(app.Application_Stage__c == 'Accepted'){
                                AccAppsCount = AccAppsCount+1;
                                //JOSE B-03077
                                if(app.Engagement__r.Status__c == 'Processing' && app.Engagement__r.Placement_Status__c == 'Not Placed' && app.Engagement__r.In_Country__c == 'No'){
                                    AwaitingCount = AwaitingCount + 1;
                                    ActiveInterviewsEng.add(app.Engagement__c);
                                }
                                if(app.Engagement__r.Status__c == 'Processing' && app.Engagement__r.Placement_Status__c == 'Not Placed' && app.Engagement__r.In_Country__c == 'Yes'){
                                    InCountryCount = InCountryCount + 1;
                                }
                                if(app.Engagement__r.Status__c == 'Processing' && app.Engagement__r.Placement_Status__c == 'Not Placed'){
                                    InterviewFeedEng.add(app.Engagement__c);
                                }
                                //New Matches (last 30 days)
                                if(app.Engagement__c != null){
                                    AllAcceptedAPCEng.add(app.Engagement__c);
                                }
                                //"Pre-Arrival"  - APC Engagement with In Country = No and status = Program Ready 
                                if(app.Engagement__r.Status__c == 'Program Ready'  && app.Engagement__r.In_Country__c == 'No'){
                                    PreArrivalCount = PreArrivalCount + 1;
                                }
                                //"On Program (In USA)" – APC Engagement with Status = On program
                                if(app.Engagement__r.Status__c == 'On Program'){
                                    OnProgramCount = OnProgramCount + 1;
                                }
                                //"Applications Accepted" – count of Applications with Stage = Accepted created between in last calendar year
                                if(app.CreatedDate >= yearStart  && app.CreatedDate <= yearEnd){
                                    AppAcceptedLastYearCount = AppAcceptedLastYearCount + 1;
                                    acceptedApps.add(app.Id);
                                }
                                //END JOSE B-03077
                            }
                            
                            //JOSE B-03077
                            // "Extensions" - APC Engagement  in Processing or Program ready status with related Application with Type = Renewal 
                            if(app.Application_Type__c == 'Renewal'){
                                if(app.Engagement__r.Status__c == 'Processing' || app.Engagement__r.Status__c == 'Program Ready'){
                                    ExtensionEngCount = ExtensionEngCount + 1;
                                }
                            }
                            //"Applications Submitted" – count of Applications with Stage != Cancelled or Declined created between in last calendar year
                            if(app.Application_Stage__c != 'Declined'){
                                if(app.CreatedDate >= yearStart  && app.CreatedDate <= yearEnd){
                                    AppSubLastYearCount = AppSubLastYearCount + 1;
                                    submittedApps.add(app.Id);
                                }
                            }
                            //END JOSE B-03077
                            /*
                            else if(app.Application_Level__c == 'Main' && app.Application_Stage__c == 'Working'){
                                mainWorkingApps.add(app.Id);
                                //partner review page is not complete && participant's health overview is complete
                                if(app.PageStatus_Complete__c != null){
                                    if((!(app.PageStatus_Complete__c.Contains('041'))) && (app.PageStatus_Complete__c.Contains('016'))){
                                        toHealthReviewApps.add(app.Id);
                                    }
                                }
                            }
                            */
                        }
                    }
                    
                    if(toHealthReviewApps!=null){
                        toHealthReviewAppsSize = toHealthReviewApps.size();
                    }
                    if(bgCheckReviewApps!=null){
                        bgCheckReviewAppsSize = bgCheckReviewApps.size();
                    }
                    if(schoolDetailsVerifyApps!=null){
                        schoolDetailsVerifyAppsSize = schoolDetailsVerifyApps.size();
                    }
                    //JOSE B-03077
                    //Active Interviews" – Same as above but only a subset where there are related Active Selections
                    if(ActiveInterviewsEng!=null){
                        list<Engagement__c> selecListEng = [SELECT Id, Name, (SELECT Id, Status__c FROM Selections__r where Status__c = 'Active') FROM Engagement__c WHERE Id IN: ActiveInterviewsEng];
                        for(Engagement__c eng:selecListEng){
                            system.debug('@@@@@eng.Selections__r for Engagement: ' + eng.Name +' /// '+ eng.Selections__r);
                            if(eng.Selections__r !=null && eng.Selections__r.size()>0){
                                ActiInterviewsCount = ActiInterviewsCount + 1;
                            }
                        }
                    }
                    //"Interview Feedback" – APC Engagements with Status = Processing, Placement Status = Not Placed with any related  Selection with Interview Feedback != null
                    if(InterviewFeedEng!=null){
                        list<Engagement__c> selecListEngFeed = [SELECT Id, Name, (SELECT Id, Status__c, Interview_Feedback__c FROM Selections__r where Interview_Feedback__c != null) FROM Engagement__c WHERE Id IN: InterviewFeedEng];
                        for(Engagement__c engFeed:selecListEngFeed){
                            system.debug('@@@@@eng.Selections__r Feedback for Engagement: ' + engFeed.Name +' /// '+ engFeed.Selections__r);
                            if(engFeed.Selections__r !=null && engFeed.Selections__r.size()>0){
                                InterviewFeedCount = InterviewFeedCount + 1;
                            }
                        }
                    }
                    //New Matches (last 30 days)
                    if(AllAcceptedAPCEng!=null){
                        date d = system.today().addDays(-30);
                        list<Match__c> List30Matches = [SELECT Id, Name FROM Match__c WHERE Engagement__c IN: AllAcceptedAPCEng AND Status__c = 'Confirmed' AND Start_Date__c >= :d];
                        if(List30Matches!=null && List30Matches.size()>0){
                            system.debug('@@@@@New 30 Days Matches: ' + List30Matches);
                            NewMatch30Count = List30Matches.size();
                        } 
                    }
                    //END JOSE B-03077
                }   
                
               /* 
                if(mainSubmittedApps!=null && mainSubmittedApps.size()>0){    
                    List<Applicant_Info__c> assAppsList = [SELECT Id, (SELECT Id,Status__c,Application__c,RecordTypeId FROM Assessments__r WHERE RecordTypeId =: Constants.ASS_APC_PT_PR_Interview) FROM Applicant_Info__c WHERE Id IN: mainSubmittedApps]; 
                    for(Applicant_Info__c app:assAppsList){
                        if(app.Assessments__r.size()==0 || app.Assessments__r==NULL){
                            notStartedAssApps.add(app.Id);
                        }
                        else{
                            for(Assessment__c ass:app.Assessments__r){
                                if(ass.Status__c == 'Incomplete'){
                                    incompleteAssApps.add(ass.Application__c);
                                }
                            }
                        }
                    }
                }
                */
                
                 if(mainWorkingApps!=null && mainWorkingApps.size()>0){  
                    system.debug('***mainWorkingApps********* : ' + mainWorkingApps);  
                    List<Applicant_Info__c> assAppsList = [SELECT Id, (SELECT Id,Status__c,Application__c,RecordTypeId FROM Assessments__r WHERE RecordTypeId =: Constants.ASS_APC_PT_PR_Interview) FROM Applicant_Info__c WHERE Id IN: mainWorkingApps]; 
                    if (assAppsList!=null && assAppsList.size()>0)
                    {
                    system.debug('***mainWorkingApps**assAppsList******* : ' + assAppsList);    
                    for(Applicant_Info__c app:assAppsList){
                        if(app.Assessments__r.size()==0 || app.Assessments__r==NULL){
                            system.debug('**mainWorkingApps****notStartedAssApps********* : ');  
                            notStartedAssApps.add(app.Id);
                        }
                        else{
                            for(Assessment__c ass:app.Assessments__r){
                                if(ass.Status__c == 'Incomplete'){
                                    system.debug('**mainWorkingApps****incompleteAssApps********* : ');  
                                    incompleteAssApps.add(ass.Application__c);
                                }
                            }
                        }
                    }
                 }
                }
                
                if(notStartedAssApps != null){
                    notStartedAssAppsSize = notStartedAssApps.size();
                } 
                if(incompleteAssApps != null){
                    incompleteAssAppsSize = incompleteAssApps.size();
                }         
                
                            
            }
        }
                
        
        referenceListCheck = new list<Reference__c>();        
                      
        system.debug('@@@@@inside Reference check/page:' + ApexPages.currentPage().getUrl());
        
        if((ApexPages.currentPage().getUrl().contains('/apex/pr_app_references_to_review')||ApexPages.currentPage().getUrl().contains('/apex/pr_home')) && activeUser != null && activeUser.Intrax_Id__c != null){
            referenceListCheck = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Person_Info__c, Applicant_Info__c,
                            Applicant_Info__r.Partner_Intrax_Id__c, Applicant_Info__r.Application_Level__c,Applicant_Info__r.Application_Stage__c,Applicant_Info__r.Name,Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId, Reference_Created_Date__c,
                            Intrax_Program__c, Type__c, Experience_Name__c, Reference_Status__c, Phone__c, Phone_Country_Code__c, CreatedDate, LastModifiedDate, Status__c 
                            from Reference__c WHERE Reference_Status__c = 'Active' AND Status__c = 'Complete' AND Applicant_Info__r.Partner_Intrax_Id__c =: activeUser.Intrax_Id__c
                            AND Applicant_Info__r.Application_Level__c = 'Main' AND (Applicant_Info__r.Application_Stage__c = 'Submitted')];
                
        }
        
        summaryReviewAppsList = new list<Applicant_Info__c>();
        
        if((ApexPages.currentPage().getUrl().contains('/apex/pr_app_summary_review') || ApexPages.currentPage().getUrl().contains('/apex/pr_home')) && activeUser != null && activeUser.Intrax_Id__c != null){
            summaryReviewAppsList = [SELECT Id,Name,(SELECT Id,Name,Reference_Status__c,Status__c,Experience_Name__c,Person_Info__c FROM References__r WHERE Reference_Status__c = 'Active' AND ((Status__c = 'Confirmed' AND Experience_Name__c != NULL AND Person_Info__c = NULL) OR ( Status__c = 'Confirmed' AND (Experience_Name__c = null OR Person_Info__c != null) ) )),Partner_Intrax_Id__c,Doctor_Form_reviewed__c,BGC_Reviewed__c,Graduation_Verified__c, Type__c,Intrax_program__c,Application_Level__c, PageStatus_Complete__c, Application_Stage__c FROM Applicant_Info__c 
                                    WHERE Application_Level__c = 'Main' AND Application_Stage__c = 'Submitted' AND Type__c = 'Participant' AND Intrax_Program__c = 'AuPairCare'];
        }
        
        
        
        partnerAccounts = new List<SelectOption>();
        mapPartnerNameIntraxId = new Map<String,String>();
        
        if(ApexPages.currentPage().getUrl().contains('/apex/pr_app_list') || ApexPages.currentPage().getUrl().contains('/apex/pr_pt_list')){            
            if(activeUser.Intrax_Id__c != null){
              if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null && activeUser.Contact.PTR_Portal_Intrax_Program_Default__c=='Work Travel')
              {
                  //system.debug('Program year selected');
                  Integer s=(System.today() + 92).Year();
                  system.debug('Program year default - WT ***'+String.valueof(s));  
                  ProgramYearSelected=String.valueof(s);
              }
                List<Account> a = [SELECT Name,Intrax_Id__c FROM Account WHERE ParentId!= NULL AND Parent.Intrax_Id__c =: activeUser.Intrax_Id__c LIMIT 50];
                if(a!=null && a.size()>0){
                    for(Account acc:a){                     
                        partnerAccounts.add(new SelectOption(acc.Name,acc.Name));
                        mapPartnerNameIntraxId.put(acc.Name,acc.Intrax_Id__c);
                    }
                }
            }
            
        }
        
                
        if(ApexPages.currentPage().getParameters().get('ApplicationLevelSelected') != null){
            ApplicationLevelSelected = ApexPages.currentPage().getParameters().get('ApplicationLevelSelected');
        }
        if(ApexPages.currentPage().getParameters().get('ApplicationStageSelected') != null){
            ApplicationStageSelected = new List<String>();
            if(ApexPages.currentPage().getParameters().get('ApplicationStageSelected') == 'Declined'){
                ApplicationStageSelected.add('Declined');                                           
                ApplicationStageSelected.add('Declined - Agent');
                ApplicationStageSelected.add('Declined - Ayusa');
                ApplicationStageSelected.add('Declined - Inbound Country');             
            }
            else            
                ApplicationStageSelected.add(ApexPages.currentPage().getParameters().get('ApplicationStageSelected'));
        }
        
        
        //Check for null
        if(activeUser != null && activeUser.Intrax_Id__c != null) {
            
            //List to hold the account records
            List<Account> hostCompanies = [SELECT Id, Name, Intrax_Id__c, Type, Intrax_Programs__c, isPersonAccount FROM Account WHERE Intrax_Id__c =: activeUser.Intrax_Id__c 
                                                AND Type = 'Partner'];
                                                
            //Check for size of list
            if(hostCompanies.size() > 0 && hostCompanies != null) {
                
                //Account record corresponding to the current logged in user
                hostCompany = hostCompanies[0]; 
                //B-01493
                //PartnerIntraxPrograms = getSelectedPicklistValues(hostCompany.Intrax_Programs__c);                
                PartnerIntraxPrograms = getSelectedPicklistValues(activeUser.Contact.Intrax_Programs__c);
            
                           
            }
                                
            //Check for host company
            if(hostCompany != null) {
                            
                //Query for contact records related to Host Company record
                List<Contact> hostContacts = [Select Id, Name, AccountId From Contact Where AccountId =: hostCompany.Id ORDER BY Name];
            
                //Check for null value
                if(hostContacts != null && hostContacts.size() > 0) {
                    
                    //Popualate contact instance 
                    hostContact = hostContacts[0];
                }   
            }
            
            dofullCount();
            dofullCount_App();
        }   
    
        if(ApexPages.currentPage().getParameters().get('search') != null){
            URLSearchValue = ApexPages.currentPage().getParameters().get('search');
            System.debug('debug::URLSearchValue--Cons'+URLSearchValue);
            SearchAgain();            
        }
        
        if(ApexPages.currentPage().getParameters().get('AppName') != null){
            AppName = ApexPages.currentPage().getParameters().get('AppName');    
        }
        
        if(ApexPages.currentPage().getParameters().get('EngName') != null){
            EngName = ApexPages.currentPage().getParameters().get('EngName');                      
        }
        
    //List to hold the Engagement records
    selectedEngagements = new list<Engagement__c>();
    
    //Added for B-01441 (Start)        
    if(ApexPages.currentPage().getParameters().get('AppId') != null && ApexPages.currentPage().getParameters().get('participantId') == null)
    {
        rType='app';
        progId='wt-pt';
        DocapplicationRecord = [SELECT Name, ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c FROM Applicant_Info__c WHERE Id =: ApexPages.currentPage().getParameters().get('AppId') LIMIT 1];
        
        string PartnerAppDocURL = '/pr_app_document_review';
        //retParam1 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Pre-Departure-Orientation-Agreement');
        retParam1 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam1 = retParam1 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam1 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam1)),'UTF-8');
                   
                    //retParam2 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('PT-Double-Placement-Agreement');
                    retParam2 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam2 = retParam2 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam2 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam2)),'UTF-8');                
 
                    retParam3 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam3 = retParam3 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam3 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam3)),'UTF-8');                
 
                    retParam4 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam4 = retParam4 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam4 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam4)),'UTF-8');
                    
                    retParam5 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam5 = retParam5 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam5 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam5)),'UTF-8');    
                    
                    retParam6 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam6 = retParam6 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam6 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam6)),'UTF-8');    
                    
                    retParam7 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam7 = retParam7 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam7 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam7)),'UTF-8');      
                    
                    retParam8 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam8 = retParam8 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam8 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam8)),'UTF-8');       
                    
                    retParam9 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam9 = retParam9 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam9 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam9)),'UTF-8'); 
                    
                    retParam10 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam10 = retParam10 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam10 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam10)),'UTF-8'); 
                    
                    retParam11 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam11 = retParam11 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam11 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam11)),'UTF-8');  
                   
                    retParam12 = Site.getCurrentSiteUrl().removeEnd('/')  +  PartnerAppDocURL;
                    retParam12 = retParam12 + '?AppId=' + ApexPages.currentPage().getParameters().get('AppId');
                    retParam12 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam12)),'UTF-8');  
    }
    
    //Added for B-01441 (End) 
    
    // getting the info for the Campaign Position Details page
    
    if(ApexPages.currentPage().getParameters().get('pId') != null){
        system.debug('***** Position Id: ' + ApexPages.currentPage().getParameters().get('pId'));
        
        positionInfo = [SELECT Id, Name, Marketing_Notes__c, Intrax_Program__c, Country__c, Host_Company_Id__c, Host_Company_Id__r.Description, Host_Company_Id__r.Name, Code__c, City__c, Gender_Preference__c, Minimum_Age__c, Engagement_Start__c, Engagement_End__c, State__c, Language_1_Proficiency__c,
                            Engagement_Earliest_End__c, Engagement_Latest_Start__c, Employment_Hrs_Wk__c, Typical_Schedule__c, Description__c, Required_Duties__c, Skills_Required__c, Supplies_Required__c, Supplies_Cost__c,
                            Host_Company_Id__r.Company_Policies__c, Accepts_Groups__c, Host_Company_Id__r.Area_Information__c, Host_Company_Id__r.Cultural_Opportunities__c, 
                            Requires_Interview__c, Special_Notes__c, Pay_Rate__c, Tipped_Position__c, Overtime_Available__c, Overtime_Rate__c, Pay_Notes__c, Pay_Frequency__c, Days_Before_Work__c, Second_Job_Allowed__c,
                            Accepts_Couples__c, Company_Provided_Housing__c, Host_Company_Id__r.Recommended_Airport__c, Host_Company_Id__r.Nearest_Bus_Station__c, Host_Company_Id__r.Nearest_Train_Station__c, Host_Company_Id__r.Transportation_To_Company__c,
                            Host_Company_Id__r.Reporting_Instructions__c, Host_Company_Id__r.Travel_Instructions__c, Host_Company_Id__r.Nearest_Work_Authorization_Office__c, Host_Company_Id__r.Work_Authorization_Instructions__c, 
                            Host_Company_Id__r.Website, Host_Company_Id__r.Websites_Additional__c, Title__c, Host_Company_Id__r.isPersonAccount 
                            FROM Position__c 
                            WHERE Id =: ApexPages.currentPage().getParameters().get('pId') ];
        
        if(ApexPages.currentPage().getParameters().get('mOrigin') == 'pos'){
            
            //B-01695 (Start)
            selectedEngagements = [SELECT Id, Name, Intrax_Program__c,Account_Id__r.FirstName, Partner_Id__c, placement_status__c, Account_Id__r.PersonBirthdate, Account_Id__r.LastName FROM Engagement__c 
                                        WHERE Intrax_Program__c = 'Work Travel' and Partner_Id__c =: hostcompany.Intrax_Id__c
                                        and (Status__c NOT IN ('Cancelled', 'Terminated', 'Program Complete','Early Departure')) 
                                        and Placement_Status__c =: 'Not Placed' Order BY Account_Id__r.LastName ASC
                                        ];
            if(selectedEngagements != null && selectedEngagements.size() > 0){
                createMatchOptions = new list<SelectOption>();
                
                Date mydate;
                String sdate;
                DateTime dT;
                for(Engagement__c e : selectedEngagements)
                {
                    if (e.Account_Id__r.PersonBirthdate != NULL)
                    {
                        dT = e.Account_Id__r.PersonBirthdate;
                        myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                        sdate = String.valueOf(myDate);
                        //createMatchOptions.add(new SelectOption(e.Id, e.Name + ' - ' + sdate) ); //Commented for B-03247
                        //B-03247
                        String Name;
                        if(e.Account_Id__r.FirstName != null && e.Account_Id__r.FirstName != '')
                        {
                         Name = e.Account_Id__r.LastName + ' ' + e.Account_Id__r.FirstName;
                        }
                        else
                        {
                         Name = e.Account_Id__r.LastName;
                        }
                        createMatchOptions.add(new SelectOption(e.Id,Name + ' - ' + sdate) );
                        //B-03247
                    }
                    else
                    {
                        createMatchOptions.add(new SelectOption(e.Id, e.Name) );
                    }
                }
            }
            //B-01695 (End)
        }
        if(positionInfo != null){
            try{
                AccOptionInfoList = [SELECT Id, Name, Position_Name__c, Host_Arranged__c, Host_Recommended__c, Description__c, Accommodation_Site__c, Accommodation_Site__r.Street__c,
                                        Accommodation_Site__r.Street_2__c, Accommodation_Site__r.State__c, Accommodation_Site__r.City__c, Accommodation_Site__r.Country__c, Accommodation_Site__r.Postal_Code__c, Accommodation_Site__r.Type__c,
                                        Accommodation_Site__r.Features__c, Accommodation_Site__r.Additional_Information__c, Accommodation_Site__r.Features_Description__c, Accommodation_Site__r.Business_Name__c,
                                        Additional_Costs__c, Additional_Costs_Description__c, Account__c,
                                        Transportation_Provided__c, Estimated_Distance__c, Gender_Restriction__c, Estimated_Cost__c, Commute_Cost__c, Commute_Options__c
                                        From Accommodation_Option__c 
                                        where Account__c =: positionInfo.Host_Company_Id__c];
                                        //where Position_Name__c =: positionInfo.Id];
                
            }catch(Exception e){
                system.debug('****** Impossibble to get Accomodation Data for this participant: ' + e);
            }
        }               
                            
    }   
        
    //Get the info of the current Assessment object        
    if(ApexPages.currentPage().getParameters().get('AssessmentId') != null) {
        system.debug('****** AssessmentId: ' + ApexPages.currentPage().getParameters().get('AssessmentId')); 
            
        RecordType validationId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY HF Validation'];
        RecordType HFinterviewId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY HF Interview'];
        RecordType PTinterviewId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY PT Orientation'];
        RecordType HomeVisitId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY Home Visit'];

       try{ 
           selectedAssessment = [select Youth_Experience_Description__c,Record_Type_Group__c, Wrap_Up_Complete_Indicated__c,Wrap_Up_Complete_Description__c,Welcomers__c,Validation_Counter__c,
                                    Upcoming_Separation_Positive__c,Upcoming_Separation_Description__c,Travel_Arrangements_Indicated__c,Time_Period__c,SystemModstamp,
                                    Study_Area__c,Student_Safety_Approach__c,Storage_Area__c,Status__c, Separation_Plan_Description__c,School_Curriculum_Positive__c,
                                    School_Adjustment_Positive__c,School_Adjustment_Description__c,Safety_Hazards__c,Safety_Hazards_Description__c,
                                    Return_Expectations__c,Return_Challenges__c,Resident_Total__c,Resident_Participants__c,Resident_Illness_Description__c,Resident_Change_Indicated__c,
                                    Resident_Change_Description__c,Resident_Adults__c,Representative__c,Repeat_Interest_Indicated__c,Repeat_Interest_Description__c,RecordTypeId, RecordType.Name,Program_Satisfaction_Positive__c,
                                    Program_Satisfaction_Description__c,Program_Impact_Description__c,Program_End_Feeling__c,Position_Name__c,Participant_change_Description__c,Participant_Name__c,
                                    Participant_Change_Positive__c,School_Responder__c,Enrollment_Period_Start__c,Enrollment_Period_End__c, Participant_Advice__c,PT_Responsibilities_Expectations__c,PT_Expense_Expectations__c,OwnerId,Overall_Assessment__c,
                                    Nearby_Support_Description__c,Name,Month_Number__c,Month_Counter__c,Match_Name__c,Last_School_Day__c,LastModifiedDate,LastModifiedById,
                                    LastActivityDate,IsDeleted,Insurance_Info_Received__c,Initial_Language_Level__c,Initial_Impressions__c,Initial_Experience_Positive__c,
                                    Initial_Experience_Description__c,In_Touch_Balance_Positive__c,In_Touch_Balance_Description__c,Id,IEW_Participation_Indicated__c,Host_Name__c,
                                    Host_Motivation__c,Host_Memories__c,Host_Benefit_Description__c,Home_Description__c,Holiday_Planning_Positive__c,Holiday_Planning_Description__c,
                                    Future_Contact_Plan_Positive__c,Friendship_Development_Positive__c,Friendship_Development_Description__c,First_Return_Activity__c,
                                    Feeling_Uncomfortable__c,Feeling_Uncomfortable_Description__c,Feeling_Homesick__c,Family_Dynamics_Positive__c,Family_Bonding_Positive__c,
                                    Family_Bonding_Description__c,Expectations_for_Year__c,Expectation_Of_Participant__c,Exchange_Learning_Positive__c,Exchange_Learning_Description__c,
                                    Exchange_Experience_Summary__c,Engagement__c,Departure_Ready_Indicated__c,CurrencyIsoCode,CreatedDate,CreatedById,Count_Down__c,
                                    Contact_Type__c,ConnectionSentId,ConnectionReceivedId,Community_Service_Indicated__c,Community_Service_Description__c,Community_Description__c,
                                    Community_Dangerous_Areas__c,Communication_Style_Positive__c,Communication_Description__c,Comments__c,Cleanliness__c,Cleanliness_Description__c,
                                    Bedroom_Sharing__c,Bedroom_Privacy__c,Bed_Type__c,Average_Week_Description__c,Assessment_Staff__c,Assessment_Location__c,Assessment_Date__c,Anticipated_Return_Positive__c,Airport__c,
                                    Adjusting_Positive__c,Adjusting_Description__c,Additional_Support_Requested__c, Bedroom_Type__c, Family_Activities__c, Host_Rules__c, PT_Responsibilities__c, Challenges__c, School_Activities__c,
                                    Additional_Support_Description__c,Access_To_Utilities__c 
                                    from Assessment__c WHERE ID =: ApexPages.currentPage().getParameters().get('AssessmentId')];


        
        //******************This is the new code for the Assessmente Objects FieldSet**************    
        
        //*****We get all the info about the Engagement__c linked with the current Assessment Object
        
        if(selectedAssessment.Engagement__c != null){
            engagement = [SELECT Id,Name,Program_Duration__c,Placement_Status__c,  Class_8__c,Class_7__c,Class_6__c, Class_5__c, Class_4__c, Class_3__c, Class_2__c, Class_1__c,
                            Grade_Level__c,Orientation_Date__c 
                            FROM Engagement__c WHERE Id =: selectedAssessment.Engagement__c];
        }
        
        //*****We get all the info about the Position__c linked with the current Assessment Object
        /* No longer necessary - Story AY2 583
        if(selectedAssessment.Position_Name__c != null){ 
            position = [SELECT Id, Engagement_Start__c  FROM Position__c WHERE Id =: selectedAssessment.Position_Name__c];
        }*/
        
         
    //*****Comparations to create an String varible with the name of the FieldSet for HF & PT & SC Contact
        
        if(selectedAssessment.Record_Type_Group__c == 'AY HF Contact'){
            if(engagement.Program_Duration__c  == 'Academic Year'){
                system.debug('Time Period Value  '+assessmentField );
                assessmentField = 'HF' + selectedAssessment.Time_Period__c  + 'Y';
                system.debug('****Test***'+ assessmentField );
            }else if(engagement.Program_Duration__c  == 'Fall Semester'){
                assessmentField = 'HF' + selectedAssessment.Time_Period__c  + 'Sem1';
            }else if(engagement.Program_Duration__c  == 'Spring Semester'){
                assessmentField = 'HF' + selectedAssessment.Time_Period__c  + 'Sem2';
            }
            
            system.debug('*****AssessmentField:  '+assessmentField );
        
        }else if(selectedAssessment.Record_Type_Group__c == 'AY PT Contact'){
            if(engagement.Program_Duration__c  == 'Academic Year'){
                system.debug('Time Period Value  ' + assessmentField );
                assessmentField = 'PT' + selectedAssessment.Time_Period__c  + 'Y';
                system.debug('****Test***'+ assessmentField );
            }else if(engagement.Program_Duration__c  == 'Fall Semester'){
                assessmentField = 'PT' + selectedAssessment.Time_Period__c  + 'Sem1'; 
            }else if(engagement.Program_Duration__c  == 'Spring Semester'){
                assessmentField = 'PT' + selectedAssessment.Time_Period__c  + 'Sem2';
            }
            system.debug('*****AssessmentField:  '+assessmentField );
        
        }else if(selectedAssessment.Record_Type_Group__c == 'AY SC Contact'){
            if(engagement.Program_Duration__c  == 'Academic Year'){
                system.debug('Time Period Value  ' + assessmentField );
                assessmentField = 'SC' + selectedAssessment.Time_Period__c  + 'Y';
                system.debug('****Test***'+ assessmentField );
            }else if(engagement.Program_Duration__c  == 'Fall Semester'){
                assessmentField = 'SC' + selectedAssessment.Time_Period__c  + 'Sem1'; 
            }else if(engagement.Program_Duration__c  == 'Spring Semester'){
                assessmentField = 'SC' + selectedAssessment.Time_Period__c  + 'Sem2';
            }
            
            system.debug('*****AssessmentField:  '+assessmentField );
        
        }
       }catch(Exception e){
            system.debug('****** Impossible to retrieve Assessments Information: ' + e);
       }   
     }   
     
     //*****************End of the new code************************
       
     //Checking for the Partcipant (Account) Id value corresponding to current page URL
    system.debug('***** Participant Id: ' + ApexPages.currentPage().getParameters().get('participantId'));
    if(ApexPages.currentPage().getParameters().get('participantId') != null) {
            
            participantId = ApexPages.currentPage().getParameters().get('participantId');
            
            //Populating list with records
            selectedEngagements = [SELECT Id, Type__c, Status__c, Position_Types__c, Position_Types_Other__c, Name, Location_of_Interest__c, LastModifiedDate, Opportunity_Id__c,
                                    Account_Id__r.Intrax_Id__c,Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Functional_Areas__c, Functional_Areas_Other__c, 
                                    Experience_Summary__c,  Engagement_Start__c, Engagement_End__c, Engagement_Country__c, Description__c, CreatedDate,
                                    Account_Id__c, Account_Id__r.isPersonAccount, Account_Id__r.Name, Account_Id__r.FirstName,Account_Id__r.Middle_Name__pc,Account_Id__r.PersonBirthdate,Account_Id__r.LastName, Account_Id__r.Gender__pc, Account_Id__r.PersonMailingCountry, Account_Id__r.Nationality__pc, 
                                    Account_Id__r.PersonMailingCity, Account_Id__r.PersonMailingState, Account_Id__r.PersonMailingPostalCode, Account_Id__r.Phone,Account_Id__r.PersonMobilePhone,Account_Id__r.PersonHomePhone,Account_Id__r.PersonEmail,Account_Id__r.Skype_ID__pc,
                                    Gender__c, Program_Start__c, Program_Year__c, Needs_Travel__c, Program_Duration__c, Placement_Status__c,Last_Match_Date__c,
                                    Interests_Top__c, Language_1__c, Language_2__c, language_3__c, Single_No_Children_Indicated__c, Private_High_School_Indicated__c, 
                                    Double_Placement_Indicated__c, Live_With_Pets__c, Number_of_Trips__c,Arrival_Trip_Needed__c,Departure_Trip_Needed__c,Pre_Program_Trip_Indicated__c,Account_Id__r.Birth_City__pc, Account_Id__r.Birth_Country__pc,
                                    Account_Id__r.Citizenship__pc,Account_Id__r.Legal_Residence__pc, Account_Id__r.Age__pc, Interview_Availability__c, Earliest_Match_Date__c, Latest_Match_Date__c, Arrival_Trip_URL__c, Departure_Trip_URL__c,SEVIS_ID__c,
                                    (SELECT ID, Name, Status__c FROM Matches__r), (Select Id,Name From Applicant_Info__r ORDER BY Name) From Engagement__c
                                    WHERE ID =: ApexPages.currentPage().getParameters().get('participantId')];
             //Checking list for size
            if(selectedEngagements != null && selectedEngagements.size() > 0) {
            
                //Populating record instance with the value
                participant = selectedEngagements[0];   
                system.debug('******* PT Name:' + Participant.Name);
                system.debug('*****### PT Intrax_Program:' + Participant.Intrax_Program__c);
                 List<Applicant_Info__c> Register_App = new List<Applicant_Info__c>();
                Register_App =   [Select Id,CreatedBy__c,CreatedBy__r.Profile.Name,CreatedBy__r.ProfileId,CreatedBy__r.Type__c,Email__c,Name,Application_Stage__c From Applicant_Info__c where Engagement__c=:participant.Id and Application_Stage__c=:'Accepted' order by createdDate DESC];         
           
                if((Register_App !=null) && (Register_App.size()>=1)) {
                //System.debug('Appln id: Profile name'+Register_App[0].Id+' '+Register_App[0].CreatedBy__r.ProfileId+ Register_App[0].CreatedBy__r.Profile.Name+' '+Register_App[0].CreatedBy__c+' '+Register_App[0].CreatedBy__r.Type__c);
                if((Participant.Intrax_Program__c=='Work Travel') &&  (Register_App[0].CreatedBy__r.Profile.Name !=null) &&  (Register_App[0].CreatedBy__r.Profile.Name == 'OCPM Agent Portal'))
                 {
                    registrationURL = 'http://'+ Site.getDomain().replace('intrax.', 'intraxinc.') + '/intraxappengine/AppEngine_SiteRegister?partnerId=' + activeUser.Intrax_Id__c + 
                                                '&FN=' +  participant.Account_Id__r.FirstName +'&LN=' +  participant.Account_Id__r.LastName +'&email=' + Register_App[0].Email__c + '&PartnerApp=true';
                 }
                }
            }
            
            if(ApexPages.currentPage().getParameters().get('mOrigin') == 'mat' ){
                //B-01695 (Start)
                list<Campaign_Position__c> cpAux = [SELECT Position__c, Position__r.Name, Campaign_Name__c, Partner_Id__c, Position__r.Host_Company_Id__c, Campaign__c, Campaign_isActive__c, Intrax_Program__c 
                                                        FROM Campaign_Position__c
                                                        WHERE Campaign_IsActive__c =: true AND Partner_Id__c =: String.valueOf(activeUser.Contact.AccountId).left(15)
                                                        AND Intrax_Program__c = 'Work Travel' AND Campaign_EndDate__c >=: System.Today().addMonths(-6) ORDER BY Position__r.Name ASC,Campaign_StartDate__c DESC];
                //selectedPositions = [SELECT Id, Name, Intrax_Program__c FROM Position__c WHERE Intrax_Program__c = 'Work Travel' and Partner_Id__c =: hostcompany.Intrax_Id__c and Placement_Status__c =: 'Not Placed'];
                if(cpAux != null && cpAux.size() > 0){
                    createMatchOptions = new list<SelectOption>();
                   
                    for(Campaign_Position__c cp : cpAux){
                       createMatchOptions.add(new SelectOption(cp.Position__c, cp.Campaign_Name__c + ' - ' + cp.Position__r.Name) );
                        mapEnglabel.put(cp.Position__c,cp.Campaign_Name__c);
                        
                    }
                }
                //B-01695 (End)
            }
            
            
            
            rType='eng';
            progId='upload_eng';
            
            if(progId!=null && participantId!=null && ! Test.isRunningTest())
                {
                    
                    retParam1 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Pre-Departure-Orientation-Agreement');
                    retParam1 = retParam1 + '&participantId=' + participantId;
                    retParam1 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam1)),'UTF-8');
                   
                    retParam2 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('PT-Double-Placement-Agreement');
                    retParam2 = retParam2 + '&participantId=' + participantId;
                    retParam2 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam2)),'UTF-8');                
 
                    retParam3 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('NP-Double-Placement-Agreement');
                    retParam3 = retParam3 + '&participantId=' + participantId;
                    retParam3 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam3)),'UTF-8');                
 
                    retParam4 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('SNK-Placement-Agreement');
                    retParam4 = retParam4 + '&participantId=' + participantId;
                    retParam4 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam4)),'UTF-8');
                    
                    retParam5 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Participant-Eligibility-Form');
                    retParam5 = retParam5 + '&participantId=' + participantId;
                    retParam5 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam5)),'UTF-8');    
                    
                    retParam6 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('University-Letter');
                    retParam6 = retParam6 + '&participantId=' + participantId;
                    retParam6 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam6)),'UTF-8');    
                    
                    retParam7 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('University-Letter-Translation');
                    retParam7 = retParam7 + '&participantId=' + participantId;
                    retParam7 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam7)),'UTF-8');      
                    
                    retParam8 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Terms-and-Conditions');
                    retParam8 = retParam8 + '&participantId=' + participantId;
                    retParam8 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam8)),'UTF-8');       
                    
                    retParam9 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Offer-Document');
                    retParam9 = retParam9 + '&participantId=' + participantId;
                    retParam9 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam9)),'UTF-8'); 
                    
                    retParam10 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Other');
                    retParam10 = retParam10 + '&participantId=' + participantId;
                    retParam10 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam10)),'UTF-8'); 
                    
                    //AA 19-02-2014 Ayusa II-Story 633-- New document type added
                    //'Private-School-Agreement','Tutoring-Agreement'
                    retParam11 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Private-School-Agreement');
                    retParam11 = retParam11 + '&participantId=' + participantId;
                    retParam11 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam11)),'UTF-8');  
                   
                    retParam12 = Site.getCurrentSiteUrl().removeEnd('/')  +  Constants.PARTNER_PORTAL_DOCTYPES.get('Tutoring-Agreement');
                    retParam12 = retParam12 + '&participantId=' + participantId;
                    retParam12 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam12)),'UTF-8');        
                 
                }
            //Checking for null value
            if(participant.Id != null) {
                // Checking for the Participant Trips
                listTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, 
                                Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__c,
                                Match__r.Engagement__r.Name, Match__r.Engagement__r.Id,Engagement__r.Name,Engagement__c,
                                Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c,
                                Engagement__r.Intrax_Program__c, Departure_Date_Time__c, Arrival_Date_Time__c, Arrival_to_Host_Community_Date__c, Ground_Transporation_Type__c
                                FROM Trip__c
                                WHERE Engagement__c =: participant.Id];
                
                //IGI - 880 (Start)
                if (participant.Intrax_Program__c == 'Work Travel' && participant.Status__c == 'Program Ready')
                {
                    if(listTrips != NULL && listTrips.size() > 0)
                    {
                        for(Trip__c TripRec:listTrips)
                        {
                            if(TripRec.Arrival_to_Host_Community__c == true)
                            {
                                ShowTripInfoType = 'Arrival';
                            }
                        }
                        if(ShowTripInfoType == '')
                        {
                            newTrip.Arrival_to_Host_Community__c = true;
                        }
                    }
                    else
                    {
                        newTrip.Arrival_to_Host_Community__c = true;
                    }
                    
                }
                else if (participant.Intrax_Program__c == 'Work Travel' && participant.Status__c == 'On Program')
                {
                    if(listTrips != NULL && listTrips.size() > 0)
                    {
                        for(Trip__c TripRec:listTrips)
                        {
                            if(TripRec.Departure_from_Host_Community__c == true)
                            {
                                ShowTripInfoType = 'Departure';
                            }
                        }
                        if(ShowTripInfoType == '')
                        {
                            newTrip.Departure_from_Host_Community__c = true;
                        }                       
                    }
                    else
                    {
                        newTrip.Departure_from_Host_Community__c = true;
                    }
                    
                }
                //IGI - 880 (End)
                
                //listMatchesPT = [SELECT Id, Position_Name__c, Position_Name__r.Name, status__c, Interview_Status__c, Offer_Status__c, Name, Engagement__c FROM Match__c WHERE Engagement__c =: participant.Id];
                                
                //Application list
                List<Applicant_Info__c> applicantRecordList = new List<Applicant_Info__c>();
                               
                //Populating list with record 
                applicantRecordList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Type__c FROM Applicant_Info__c WHERE Engagement__c =: participant.ID LIMIT 1];
                
                //Checking for null value
                if(applicantRecordList != null && applicantRecordList.size() > 0) {
                
                    //Getting Application record
                    applicationRecord =  applicantRecordList[0];
                            
                    //Checking for Photo Attached to Participant or not
                    //if(ApexPages.currentPage().getParameters().get('isPhotoAvailable') != null && applicationRecord != null) {
                    if(applicationRecord != null) {
                    
                        //***************
                        
                        // Instantiate a new http object 
                        returnURL = IUtilities.getParticipantPhoto(applicationRecord);
                                               
                    }
                }
            }
        
        //We are taking the AppInfo record if the partipanId does exist in the URL to get the profile picture (There is no engagement in this App)
        
        }else if(ApexPages.currentPage().getParameters().get('Id') != null){
            //Application list
                List<Applicant_Info__c> applicantRecordList = new List<Applicant_Info__c>();
                               
                //Populating list with record 
                applicantRecordList = [SELECT ID, PhotoId__c, Type__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c FROM Applicant_Info__c WHERE Id =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
                
                //Checking for null value
                if(applicantRecordList != null && applicantRecordList.size() > 0) {
                
                    //Getting Application record
                    applicationRecord =  applicantRecordList[0];
                            
                    //Checking for Photo Attached to Participant or not
                    //if(ApexPages.currentPage().getParameters().get('isPhotoAvailable') != null && applicationRecord != null) {
                    if(applicationRecord != null) {
                    
                    system.debug('*****###ApplicantRecord ID: ' + applicationRecord.Id );
                    
                    returnURL = IUtilities.getParticipantPhoto(applicationRecord);  
                        
                    }
                }
        }
        
        
        //Checking for the Applicant Id value corresponding to current page URL
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            
            //List to hold the Application records
            List<Applicant_Info__c> selectedApplications = new List<Applicant_Info__c>();   
            
            //Populating list with Application records
            selectedApplications = [SELECT Id, Name, Intrax_Program__c, Application_Level__c, Application_Stage__c, Program_Start__c, Program_Duration__c,
                                        CreatedDate, LastModifiedDate, Account__c, Field_Work_Experience__c, Prior_Exchange_Experience__c, Program_Year__c,
                                        Prior_Host_Experience__c, Prior_Host_Experience_DEPR__c, Engagement_End__c, Engagement_Start__c, Education_Grade__c,
                                        Graduated__c, Graduation_Date__c, Study_Time__c, Study_Weeks__c, English_Study_Years__c, Prior_Hosting_Agency__c,
                                        Language_spoken_1__c, Language_spoken_2__c, Language_spoken_3__c, Language_spoken_years_1__c, Language_spoken_years_2__c,
                                        Language_spoken_years_3__c, Languages_Spoken__c, Writing_Skills__c, English_Level__c, Speaking_Skills__c, Submitted_Date__c,
                                        Functional_Areas__c, Interests__c, Location_of_Interest__c, Projects_of_Interest__c, Fax__c, How_Heard__c, 
                                        Exchange_Agency_Employment__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Incomplete_Missing_Documents__c,
                                        International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name, Engagement__r.Id FROM Applicant_Info__c 
                                        WHERE ID =: ApexPages.currentPage().getParameters().get('Id')];
            
            //Checking list for null value
            if(selectedApplications != null && selectedApplications.size() > 0) {           
            
                //Getting Applicant Id value
                application = selectedApplications[0];
            }
                 
            //Checking for applicant info record for null
            if(application != null) {  
                
                listPersonInfo = [SELECT Id, First_Name__c, Middle_Name__c, Last_Name__c, Nick_Name__c, Gender__c, Date_of_Birth__c, Citizenship__c,
                                    Applicant_Info__c, Skype_Id__c, Email__c FROM Person_Info__c 
                                    WHERE Applicant_Info__c = : application.ID];
                       
                //Check for size and null value             
                if(listPersonInfo != null && listPersonInfo.size() > 0) {
                    //Query for getting record details
                    personInfo = listPersonInfo[0];
                    
                }
                
                // Getting the last Audit Info record
                listAuditInfo = [Select a.Volunteer_Essay__c, a.Volunteer_Essay_Note__c, a.Type__c, a.SystemModstamp, a.Student_Photos__c, a.Student_Photos_Note__c, a.Student_Letter__c, a.Student_Letter_Note__c, a.Signatures__c, a.Signatures_Note__c, a.School_Years__c, a.School_Years_Note__c, a.Reference_Count__c, a.Reference_Count_Note__c, 
                                    a.Ref_Suitability__c, a.Ref_Suitability_Note__c, a.Ref_Relationship__c, a.Ref_Relationship_Note__c, a.Ref_Recommend__c, a.Ref_Recommend_Note__c, a.Ref_Opinion__c, a.Ref_Opinion_Note__c, a.RecordTypeId, a.Profile__c, a.Profile_Note__c, a.Prior_Hosting__c, a.Prior_Hosting_Note__c, a.Prior_Exchange__c, 
                                    a.Prior_Exchange_Note__c, a.Pets__c, a.Pets_Note__c, a.Person_Info__c, a.Participant__c, a.Participant_Note__c, a.Parent_Letter__c, a.Parent_Letter_Note__c, a.Name, a.LastModifiedDate, a.LastModifiedById, a.Language__c, a.Language_Note__c, a.IsDeleted, a.Interview__c, 
                                    a.Interview_Note__c, a.Interests__c, a.Interests_Note__c, a.Interest_Essay__c, a.Interest_Essay_Note__c, a.Income_Level__c, a.Income_Level_Note__c, a.Id, a.Homesick_Essay__c, a.Homesick_Essay_Note__c, a.Home_Type__c, a.Home_Type_Note__c, a.Home_Language__c, a.Home_Language_Note__c, a.Health__c, a.Health_Note__c, 
                                    a.HF_Letter__c, a.HF_Letter_Note__c, a.Government_Assistance__c, a.Government_Assistance_Note__c, a.Goal_Essay__c, a.Goal_Essay_Note__c, a.Federal_Subsidy__c, a.Federal_Subsidy_Note__c, a.Exchange_Org_Employee__c, a.Exchange_Org_Employee_Note__c, a.English_Ability__c, a.English_Ability_Note__c, a.Eligibility__c,
                                    a.Eligibility_Note__c, a.Document_Status__c, a.Diet__c, a.Diet_Note__c, a.Dates__c, a.Dates_Note__c, a.Daily_Meals__c, a.Daily_Meals_Note__c, a.CurrencyIsoCode, a.Crime_Charge__c, a.Crime_Charge_Note__c, a.CreatedDate, a.CreatedById, a.Contact__c, a.Contact_Note__c, a.ConnectionSentId, a.ConnectionReceivedId, 
                                    a.Coach_Contact__c, a.Coach_Contact_Note__c, a.Citizenship__c, a.Citizenship_Note__c, a.Biographical__c, a.Biographical_Note__c, a.Bedroom_Sharing__c, a.Bedroom_Sharing_Note__c, a.Audit_Status__c, a.Applicant_Status__c, a.Applicant_Info__c, a.Age__c, a.Age_Note__c, a.Activity_Photos__c, a.Activity_Photos_Note__c, a.Academic__c, a.Academic_Note__c, a.Abuse_Charge__c, a.Abuse_Charge_Note__c 
                                    From Audit_Info__c a WHERE Applicant_Info__c =: application.Id order by CreatedDate DESC];
                
                if(listAuditInfo != null && listAuditInfo.size() >0){
                    system.debug('****** Getting in here?');
                    auditInfo = listAuditInfo[0];
                }
            }
        }
        
        //*************************
        
        //Checking for the Participant Id value corresponding to current page URL
        
        if(ApexPages.currentPage().getParameters().get('matchId') != null) {
            //Populating list with the match records
            selectedMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Consider_Other_Positions__c, Match_Date__c,Position_Name__r.Street__c,Position_Name__r.Street_2__c, Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c,Position_Name__r.School_Id__c,Position_Name__r.Owner.Phone, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,Engagement__r.Pre_Program_Trip_Indicated__c,Engagement__r.Visa_Type__c,
                                Position_Name__r.Single_No_Children_Indicated__c, Position_Name__r.Engagement_Start__c, Position_Name__r.Pets_Description__c,
                                Participant_Opportunity_Id__r.Name,  Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c,
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c, Intrax_Program__c,Current_TIPP_Editor__c
                                FROM Match__c 
                                WHERE
                                Id =: ApexPages.currentPage().getParameters().get('matchId')];                                   
                                //Engagement__c =: participant.Id order by Start_Date__c desc];
                                 system.debug('debug:: From If');
                                 system.debug('debug:: Engagement Visa Status------'+selectedMatches[0].Engagement__r.Visa_Type__c);
                                 system.debug('debug:: Intrax Program------'+selectedMatches[0].Engagement__r.Intrax_Program__c);
                                 system.debug('debug:: Current TIPP Editor------'+selectedMatches[0].Current_TIPP_Editor__c);
                                
                                //ID =: ApexPages.currentPage().getParameters().get('matchId') //AA-25/3/2014[AY2-645] Add 5 new columns 
        }else{
            //Populating list with the match records
            if(participant.Intrax_Program__c == 'Ayusa'){
                if (participant.Id != NULL)
                {
                    selectedMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,Engagement__r.Pre_Program_Trip_Indicated__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c, Intrax_Program__c
                                FROM Match__c 
                                WHERE (status__c =: 'Confirmed' OR status__c =: 'Completed' OR status__c =: 'Ended Early') 
                                AND Engagement__c =: participant.Id order by Start_Date__c desc];
                                system.debug('debug:: From Else');
                                
                    selectedConfirmMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,Engagement__r.Pre_Program_Trip_Indicated__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c FROM Match__c 
                                WHERE Engagement__c =: participant.Id AND Status__c = 'Confirmed' order by Start_Date__c desc];  
                 }             
                                
                                // ID =: ApexPages.currentPage().getParameters().get('matchId')]; 
                                //AA-21/3/2014[AY2-644] Add two new columns 
            //}else{
            }else if( ApexPages.currentPage().getParameters().get('pId') == null){
                if(participant.Id != NULL){
                    
                    if(participant.Intrax_Program__c == 'AuPairCare'){
                        selectedMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c,Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,Engagement__r.Pre_Program_Trip_Indicated__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c, Intrax_Program__c,
                                (Select Id, Name, dsfs__DocuSign_Envelope_ID__c From DocuSign_Status__r WHERE Signing_Document_Name__c='Work Travel Job Placement' 
                                AND dsfs__Envelope_Status__c='Completed')
                                FROM Match__c 
                                WHERE Engagement__c =: participant.Id AND (Status__c = 'Requested' OR Status__c = 'Confirmed')];
                    }else{
                        selectedMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c,Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,Engagement__r.Pre_Program_Trip_Indicated__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c, Intrax_Program__c,
                                (Select Id, Name, dsfs__DocuSign_Envelope_ID__c From DocuSign_Status__r WHERE Signing_Document_Name__c='Work Travel Job Placement' 
                                AND dsfs__Envelope_Status__c='Completed')
                                FROM Match__c 
                                WHERE Engagement__c =: participant.Id];
                    }
                                
                    selectedConfirmMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c,Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,Engagement__r.Pre_Program_Trip_Indicated__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c, Intrax_Program__c  
                                FROM Match__c 
                                WHERE Engagement__c =: participant.Id AND Status__c = 'Confirmed' order by Start_Date__c desc];
                    
                    system.debug('debug:: From Else If');
                                
                    if (selectedMatches != null && selectedMatches.size() > 0){
                        //IGI - 841, 842, 843 (Start)
                        for(Match__c EnvMatch : selectedMatches){
                            if(EnvMatch.DocuSign_Status__r != null && EnvMatch.DocuSign_Status__r.size() > 0 ){
                                DocuSignEnvMap.put(EnvMatch.id, EnvMatch.DocuSign_Status__r[0].dsfs__DocuSign_Envelope_ID__c);
                            }
                            else{
                                DocuSignEnvMap.put(EnvMatch.id, 'no-Envelope');
                            }
                        }
                        //IGI - 841, 842, 843 (End)
                    }
                   if (selectedMatches.size() > 0){
                        for(Match__c m: selectedMatches ){
                             List<Position_Info__c> pos = new List<Position_Info__c>();
                             pos=[SELECT Match__c, Status__c FROM Position_Info__c WHERE Match__c =:m.Id limit 1];     
                             system.debug('Inside for loop');
                                if((pos!=null) && (pos.size()>=1)){
                                   system.debug('Inside if loop'+pos[0].Status__c);
                                   if(pos[0].Status__c !=null)
                                   PosInfo_status.put(m.id, pos[0].Status__c);
                                   else
                                   PosInfo_status.put(m.id, 'No Status');                      
                                }else if(pos.size()==0){
                                    system.debug('Inside else if loop');
                                    PosInfo_status.put(m.id,'Not Yet Started');
                                }
                        }                          
                    } 
                    system.debug('posinfo done'); 
                }//IF2 END - participant.Id != NULL## 
            }//IF1 END - ApexPages.currentPage().getParameters().get('pId') == null##
        }//ELSE END
        system.debug('*****###selectedMatches.size() = ' + selectedMatches.size());
         /*if (selectedMatches.size() > 0 && ApexPages.currentPage().getParameters().get('matchId') != null &&ApexPages.currentPage().getParameters().get('participantId') != null){
                        for(Match__c m: selectedMatches ){
                             List<Position_Info__c> pos = new List<Position_Info__c>();
                             pos=[SELECT Match__c, Status__c FROM Position_Info__c WHERE Match__c =:m.Id limit 1];     
                             system.debug('Inside for loop');
                                if((pos!=null) && (pos.size()>=1)){
                                   system.debug('Inside if loop'+pos[0].Status__c);
                                   if(pos[0].Status__c !=null)
                                   PosInfo_status.put(m.id, pos[0].Status__c);
                                   else
                                   PosInfo_status.put(m.id, 'No Status');                      
                                }else if(pos.size()==0){
                                    system.debug('Inside else if loop');
                                    PosInfo_status.put(m.id,'Not Yet Started');
                                }
                        }                          
                    } 
                    system.debug('posinfo done'); */
            //Checking list for size
            if(selectedMatches != null && selectedMatches.size() > 0) {
                //Populating match instance with record
                if(ApexPages.currentPage().getParameters().get('matchId') != null)
                {
                    match = selectedMatches[0];
                }
                else
                {
                    if (selectedConfirmMatches != null && selectedConfirmMatches.size() > 0)
                    {
                        match  = selectedConfirmMatches[0];
                    }
                    else
                    {
                        match  = selectedMatches[0];
                    }
                
                }
             
                if(participant.Intrax_Program__c == 'Ayusa'){
                    try{
                    system.debug('*****###match.Position_Name__r.OwnerId ' + match.Position_Name__r.OwnerId);
                     ayusaContact = [Select u.Phone, u.Name, u.Id, u.Email, u.Country, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Id=: match.Position_Name__r.OwnerId LIMIT 1];
                     if(ayusaContact != null){
                     system.debug('*****###ayusaContact --- ContactId: ' + ayusaContact[0].Phone);
                        system.debug('*****###ayusaContact --- Account__c: ' + ayusaContact[0].Email);
                        system.debug('*****###ayusaContact --- Manager: ' + ayusaContact[0].Country);
                        system.debug('*****###ayusaContact --- Phone: ' + ayusaContact[0].Phone);
                        system.debug('*****###ayusaContact --- Email: ' + ayusaContact[0].Email);
                        system.debug('*****###ayusaContact --- City: ' + ayusaContact[0].City);
                         system.debug('*****###ayusaContact --- Country: ' + ayusaContact[0].Country);
                        
                        //Getting manager ID from the ayusaContact
                     if(ayusaContact[0].ManagerId != null) {
                            //Populating contact instance with record
                            ManagerUser = [SELECT Id, Name, Title  FROM User WHERE id =: ayusaContact[0].ManagerId LIMIT 1];
                              system.debug('*****###ManagerUser --- Name: ' + ManagerUser.Name);
                        system.debug('*****###ManagerUser --- Title: ' + ManagerUser.Title);
                    
                        }
                     }
                        
                    }catch(Exception e){
                        system.debug('****** Impossible to retrieve Ayusa Contact Information '+e);
                    }
                
                }
                
            }
            
            //Getting positionInfo from  SelectedMatches.Position_Name
            if(match.Position_Name__c != null) {
                                
                try{
                    positionInfo = [SELECT p.sAccount__c, Host_Company_Id__r.Name, p.Accepts_Couples__c, p.Accepts_Groups__c, p.Requires_Interview__c, Interview_Type__c, p.Typical_Schedule__c, p.Type__c, p.Tuition__c, p.Title__c, p.Tipped_Position__c, p.Terminated_Count__c, p.Supplies_Required__c, p.Supplies_Cost__c, p.Supervisor_Role__c, p.Street__c, p.Street_2__c, p.Status__c, p.State__c, 
                p.Special_Notes__c, p.Functional_Areas__c, p.Smoker_in_Family__c, p.Skills_Required__c, p.Single_No_Children_Indicated__c, p.Session__c, p.Owner.Phone, p.Owner.Name, p.Owner.Email,
                p.Second_Job_Allowed__c, p.Season__c, p.School_Model__c, p.School_Category__c, p.Required_Duties__c, p.Religious_Restriction_Indicated__c, p.Regional_Location__c, p.RecordTypeId, p.Projects_of_Interest__c, p.Program_Year__c, p.Postal_Code__c, p.Positions_Sold__c, p.Position_Types__c, p.Position_Types_Other__c, p.Position_Supervisor__c, p.Position_Count__c, p.Pets__c, p.Pets_Description__c, 
                p.Personality_Independence__c, p.Pending_Count__c, p.Pay_Rate__c, p.Pay_Notes__c, p.Pay_Frequency__c, p.OwnerId, p.Overtime_Rate__c, p.Overtime_Available__c, 
                p.Occupational_Category__c, p.Nationality_Preferences__c, p.Name, p.Minimum_Position_Duration__c, p.Minimum_Age__c, p.Maximum_Hours__c, p.Maximum_Age__c, p.Matching_Notes__c, p.Matched_Count__c, p.Marketing_Notes__c,
                p.Languages_Required__c, p.Language_Level__c, p.Language_3__c, p.Language_3_Proficiency__c, p.Language_2__c, p.Language_2_Proficiency__c, p.Language_1__c, p.Language_1_Proficiency__c, p.IsDeleted, p.Intrax_Program__c, p.Intrax_Program_Options__c, p.Interview_Date__c, p.Interests__c, p.Id, p.Host_Opportunity_Id__c, 
                p.Host_Company_Id__c, p.Gender_Preference__c, p.Functional_Areas_Secondary__c, p.Functional_Areas_Other__c, p.Flexible_Dates__c, p.Engagement_Start__c, p.Engagement_Latest_Start__c, p.Engagement_End__c, p.Engagement_Earliest_End__c, p.Employment_Hrs_Wk__c, p.Double_Placement_Indicated__c, p.Description__c, p.Departure_Date_Time__c,
                p.Days_Before_Work__c, p.Country__c, p.Countries_of_Interest__c, p.Countries_Excluded__c, p.Coordinator__c, p.Compensation_Type__c, p.Company_Provided_Housing__c, p.Code__c, p.City__c, p.Arrival_Departure_Phone__c, p.Arrival_Departure_Contact__c, p.Arrival_Date_Time__c 
                FROM Position__c p
                WHERE p.Id =: match.Position_Name__c];
                
                }catch(Exception e){
                    system.debug('****** Impossible to retrieve positionInfo '+e);
                }
                
            }
            
            //Getting Account info for the Institution (School) linked with the POsition
            if(match.Position_Name__r.School_Id__c != null) {
                //Populating contact instance with record
                
                try{
                    AccountUser = [SELECT Id, Name, Enrollment_Total__c, ShippingStreet, ShippingPostalCode, ShippingCountry, Type, Phone, PersonMobilePhone, PersonOtherPhone, Portal_Contact_Name__c, isPersonAccount FROM Account WHERE id =: match.Position_Name__r.School_Id__c LIMIT 1];
                    //system.debug('*****###ContactUser --- Name: ' + ContactUser.Name);
                     //Getting Contact info linked with Owner User
                    if(AccountUser.Portal_Contact_Name__c != null) {
                        //Populating contact instance with record
                        ContactUser = [SELECT Id, Name, ReportsToId FROM Contact WHERE id =: AccountUser.Portal_Contact_Name__c LIMIT 1];
                        system.debug('*****###ContactUser --- Name: ' + ContactUser.Name);
                    }
                }catch(Exception e){
                    system.debug('****** Impossible to Account User Information '+e);
                }
            }
            
        // Getting the HF app data through the Position
        list<Applicant_Info__c> selectedHFApps = new list<Applicant_Info__c>();
        list<Person_Info__c> personPrimaryList = new list<Person_Info__c>();
        system.debug('*****###match.Position_Name__r.Id: '+ match.Position_Name__r.Id);
        
        if(match.Position_Name__r.Id != null && participant.Intrax_Program__c == 'Ayusa'){
            selectedHFApps = [SELECT ID, Name, Home_Street_1__c, Home_Street_2__c, Home_Postal_Code__c, Home_City__c, Home_Country__c, Home_State__c, Home_Phone__c, Home_Type__c,
                                Bedrooms__c, Bedroom_Shared_Indicated__c, Bathrooms__c, Pets__c, Pets_Description__c, Family_Activities__c, Smoker_in_Family__c, Special_Diet_Indicated__c,
                                Special_Diet_Description__c, Community_Type__c, Community_Population__c, Community_Description__c, Nearest_City__c, Airport__c, Engagement_Start__c,
                                Account__r.PersonMailingState, Account__r.Name, Account__r.ShippingStreet, Account__r.ShippingPostalCode, Account__r.ShippingCountry, Account__r.PersonMailingCity, Account__r.PersonMailingStreet, Account__r.PersonMailingPostalCode, Account__r.PersonMailingCountry, Account__r.Phone,  Account__r.PersonMobilePhone, Account__r.PersonOtherPhone,
                                Account__r.Type, Position__c ,Pet_types__c,Account__r.PersonEmail
                                FROM Applicant_Info__c WHERE Position__c =: match.Position_Name__r.Id];
        
            if(selectedHFApps != null && selectedHFApps.size() > 0){
                
                familyApp = selectedHFApps[0];
                
                personPrimaryList= [SELECT ID, Name, Mobile__c, Other_Phone__c, Work_Phone__c,Email__c   FROM Person_Info__c WHERE Applicant_Info__c  =: familyApp.Id AND Primary_Applicant__c =: true ];
                
                system.debug('*****###personPrimaryList.size(): '+ personPrimaryList.size());
                
                if(personPrimaryList != null && personPrimaryList.size() > 0){
                    personPrimary = personPrimaryList[0];
                    system.debug('*****###personPrimary.Mobile__c: '+ personPrimary.Mobile__c);
                }
             }
            
            //Getting Letter to PT fron Essasy Qs Object
            if(participant.Applicant_Info__r != NULL && participant.Intrax_Program__c == 'Ayusa' ){
                try{
                    EssayFamilyLetter = [SELECT label__c, Name, Narrative__c FROM Essay__c
                             WHERE Name = 'Host Family Letter'
                             AND Applicant_Info__c =: familyApp.Id];
                             
                    if(EssayFamilyLetter != null && EssayFamilyLetter.size() >0){
                         FamilyLetter = EssayFamilyLetter[0];
                    }
                }catch(Exception e){
                    system.debug('***** Impossible to retrieve Essay: Host Family Letter');
                }
            }
             
            familyInfo = [SELECT ID, Name, First_Name__c, Last_Name__c, Age__c, Role__c, Primary_Applicant__c, Profession__c 
                            FROM Person_Info__c 
                            WHERE Applicant_Info__c =: familyApp.Id
                            AND (Role__c =: 'Host' OR Role__c =: 'Spouse' OR Role__c =: 'Parent' OR Role__c =: 'Child' OR Role__c =: 'Spouse or Partner')  ORDER By Age__c DESC];
            list<Intrax_Program_Upload__c> familyPosPhotos;
            
            //MT 360
            if(familyApp.Position__c != null){
                FamilyPhotos = [SELECT Id, Name, Description__c, Position__c, Document_Type__c, Document_Name__c, Document_GUID__c,Review_Status__c FROM Intrax_Program_Upload__c 
                                        WHERE (Position__c =: familyApp.Position__c AND (Document_Type__c =: 'Kitchen' OR Document_Type__c =: 'Living-Room' OR Document_Type__c =: 'Bathroom' OR Document_Type__c =: 'Student-Bedroom' 
                                        OR Document_Type__c =: 'Exterior-Of-Home' OR Document_Type__c =: 'Family-Photo' OR Document_Type__c =: 'HostFamily') AND Review_Status__c =: 'Accepted' )]; 
                                       //AA Commented out AYUSA 662
                                       // OR (Applicant_Info__c =: familyApp.Id AND Document_Type__c =: 'HostFamily')];
                     
                if(FamilyPhotos.size()>0 && FamilyPhotos != null){
                    
                    returnURLListHF= new list<String>();
                    //Position__c posInfo = [select Id from Position__c where Id = :familyApp.Position__c];
                    //returnURLListHF = IUtilities.getParticipantFamilyPhotos(posInfo);
                    
                    //B-01192. Calling a new function by passing the Accepted Document GUIDs only.                    
                    list<String> listGUID = new list<String>();
                    for(Intrax_Program_Upload__c ipu:FamilyPhotos){                                        
                        listGUID.add(ipu.Document_GUID__c);                     
                    }                    
                    returnURLListHF = IUtilities.getParticipantFamilyPhotosFromGUID(listGUID); 
                    
                    system.debug('*****@@@listGUID: ' +listGUID); 
                    system.debug('*****@@@listGUID size: ' +listGUID.size()); 
                    system.debug('*****@@@returnURLListHF: ' +returnURLListHF); 
                    
                }
            }
        }
        
        //Checking for the Trip Id value corresponding to current page URL
        if(ApexPages.currentPage().getParameters().get('tripId') != null) {
            
            //List to hold the trip records
            List<Trip__c> selectedTrips = new List<Trip__c>();  
            
            //Populating list with selected trip record
            selectedTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, Match__r.Engagement__c,
                            Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__r.Name, 
                            Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c,
                            Arrival_Date_Time__c, Departure_Date_Time__c, Engagement__r.Intrax_Program__c, Ground_Transporation_Type__c, Arrival_to_Host_Community_Date__c
                            FROM Trip__c
                            WHERE ID =: ApexPages.currentPage().getParameters().get('tripId')];
                            
            //Checking for null value
            if(selectedTrips != null && selectedTrips.size() > 0) {
            
                //Populate Instance with the record
                trip = selectedTrips[0];
                /*
                if(trip.Arriving_Date__c != null){
                    String timeZone = [select timeZoneSidKey from User where id=:userinfo.getUserId()].timeZoneSidKey;
                    System.debug('TIME ZONE '+timeZone);                
                    system.debug('*******FromDate**********'+FromDate);                 
                    Date inputDate;
                    String[] tempStr = String.valueOf(trip.Arriving_Date__c).split('/');
                    system.debug('*******tempStr**********'+tempStr); 
                    Integer d = Integer.valueOf(tempStr[1]);
                    system.debug('*******d**********'+d); 
                    Integer m = Integer.valueOf(tempStr[0]);
                    system.debug('*******m**********'+m); 
                    Integer y = Integer.valueOf(tempStr[2]);
                    system.debug('*******y**********'+y); 
                    inputDate = Date.newInstance(y,m,d);        
                    system.debug('*******inputDate**********'+inputDate); 
                                    
                    
                    DateTime refDate1 = DateTime.newInstanceGMT(inputDate.year(), inputDate.month(), inputDate.day(), 0, 0, 0); 
                    system.debug('*******refDate1**********'+refDate1); 
                    
                    trip.Arriving_Date__c = refDate1;
                }
                */
            }
        }
    }
    
    /*Method having logic related to Login redirections and validations*/
    
    //Method helpful in Site Login check and further Page redirection
    public PageReference checkLogin(){
        //AA 27022014 Ayusa II (AY2)#626To resolve Empty Text Area Rendering issue which insert garbage Html code. 
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8; IE=9; IE=10');
        
        //Variable to hold the Pagereference                
        PageReference pageRef;
        system.debug('Looged in User Type '+userInfo.getUserType());
            
        //Checking for Site User
        if(userInfo.getUserType() == 'Guest') {
            
            //Redirect to login Page
            pageRef = Page.AppEngine_SiteLoginPage;
            pageRef.setRedirect(true);
            
        } else if(userInfo.getUserType() == 'Standard' || userInfo.getUserType() == 'PowerPartner') {
            
            system.debug('');
            return pageRef;
        }
           
        //Return pagereference
        return pageRef;
    }
    
    //Method for checking for login validation and make a search for Participant in a single action call
    public void checkLoginWithParticipantSearch() {
        
        //Method for Login validation and then Participant Searching
        checkLogin();
        doSearchForParticipant();
    }
    
    //Method for checking for login validation and make a search for Applications in a single action call
    public void checkLoginWithApplicationSearch() {
        
        //Method for Login validation and then Applications Searching
        checkLogin();
        doSearch();
        
    }
    
    public void checkLoginWithCampaignSearch() {
        //Method for Login validation and then Applications Searching
        checkLogin();
        string DefaultConIP;
        
        if(activeUser != null && activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
            DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
        }
        if(DefaultConIP == 'Work Travel')
         {
            sortExpression ='Campaign_StartDate__c';
            sortDirection = 'DESC'; 
          }
        //B-03246
         
        doSearchforCampaigns();
    }
    
    //Method for checking for login validation and make a search for Matches in a single action call
    public void checkLoginWithMatchSearch() {
        
        //Method for Login validation and then Applications Searching
        checkLogin();
        doSearchForMatches();
    }
    
    //Method for checking for login validation and report access (IGI - 604) - Start
    public void checkLoginWithReportSearch() {
        
        //Method for Login validation and then Applications Searching
        checkLogin();
        //doSearchForReports();
    }
    
    public list <report> getallpartnerreports() 
    {
        Global_Constants__c ReportSetting = Global_Constants__c.getInstance();
        list <report> allrpts = new list<report>(); 
        list <User> UserPrograms = [SELECT Id, Type__c, Contact.Account.Intrax_Programs__c,Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id =: userInfo.getUserId()];
        
        if (UserPrograms.size() > 0)
        {
            for (User chkUser : UserPrograms)
            {
                if (chkUser.Type__c == 'Partner')
                {
                    if(IUtilities.isIncluded(chkUser.Contact.Account.Intrax_Programs__c, 'Work Travel')&& chkUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Work Travel')
                    {
                        string WTReportFolderName = ReportSetting.Work_Travel_Report_Folder_Name__c;
                        list <report> rpts = [select id, name, description from report where ownerid IN (select id from folder where developername = :WTReportFolderName) and ownerid != null order by name];
                        system.debug('@@WTReportFolderName'+WTReportFolderName);
                        system.debug('rpts'+rpts);
                        if (rpts.size() > 0 )
                        {
                         system.debug('has wt');
                            allrpts.addall(rpts);
                        }
                    }
                    if(IUtilities.isIncluded(chkUser.Contact.Account.Intrax_Programs__c, 'Internship')&& chkUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Internship')
                    {
                        string WTReportFolderName = ReportSetting.Internship_Report_Folder_Name__c;
                        list <report> rpts = [select id, name, description from report where ownerid IN (select id from folder where developername = :WTReportFolderName) and ownerid != null order by name];
                       
                        if (rpts.size() > 0 )
                        {
                          system.debug('has intership');
                            allrpts.addall(rpts);
                        }
                    }
                    if(IUtilities.isIncluded(chkUser.Contact.Account.Intrax_Programs__c, 'Ayusa')&& chkUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Ayusa')
                    {
                        string WTReportFolderName = ReportSetting.AYUSA_Report_Folder_Name__c;
                        list <report> rpts = [select id, name, description from report where ownerid IN (select id from folder where developername = :WTReportFolderName) and ownerid != null order by name];
                        
                        if (rpts.size() > 0 )
                        {
                          system.debug('has Ayusa');
                            allrpts.addall(rpts);
                        }
                    }
                    if(IUtilities.isIncluded(chkUser.Contact.Account.Intrax_Programs__c, 'AuPairCare')&& chkUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'AuPairCare')
                    {
                        string WTReportFolderName = ReportSetting.AuPairCare_Report_Folder_Name__c;
                        list <report> rpts = [select id, name, description from report where ownerid IN (select id from folder where developername = :WTReportFolderName) and ownerid != null order by name];
                      
                        if (rpts.size() > 0 )
                        {
                          system.debug('has apc');
                            allrpts.addall(rpts);
                        }
                    }
                }
                else if (chkUser.Type__c == 'Host Company')
                {
                   string WTReportFolderName = ReportSetting.Host_Company_Report_Folder_Name__c;
                   list <report> rpts = [select id, name, description from report where ownerid IN (select id from folder where developername = :WTReportFolderName) and ownerid != null order by name];
                   if (rpts.size() > 0 )
                   {
                       allrpts.addall(rpts);
                   }
                   
                }
            }
        }
        return allrpts;
        
    }
    
    public PageReference getReportUrl()
    {
        string str = '/' + ApexPages.currentPage().getParameters().get('guid') + '?export=1&enc=UTF-8&xf=xls';
        system.debug('@@' +str);
        return new PageReference(str);
        
    }
    
    //Method for checking for login validation and report access (IGI - 604) - End
  
    /*Method having sQOL Building workaround and called for searching*/
    public void dofullCount(){
    //GET FULL COUNT FIRST.  NO LIMIT In Query
            //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
            sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
            
            string IP_New;
            List<String> contactIPList_New = new List<String>();
            string DefaultConIP;
            
            if(activeUser.Contact.Intrax_Programs__c != null){
                IP_New = activeUser.Contact.Intrax_Programs__c;
                contactIPList_New = IP_New.split(';');
            }
            
            if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
            }
            
            System.debug('*****THE VALUE Contact IP CT _New:'+activeUser.Contact.Intrax_Programs__c);
            System.debug('*****THE VALUE contactIPList_New:'+contactIPList_New);
                        
            //String to hold the dynamic query
            String sOQLQueryForParticipant_New = 'SELECT Count() FROM Engagement__c'+
                                                + ' WHERE '//Partner_ID__c = \'' + activeUser.Intrax_Id__c + '\' AND '
                                                + ' Type__c = \'' + 'Participant' + '\' AND';             
            
            if(activeUser.Intrax_Id__c != null){    
                if(PartPartnerAccSelected != null && PartPartnerAccSelected=='Own'){
                    sOQLQueryForParticipant_New += ' Partner_ID__c = \'' + activeUser.Intrax_Id__c + '\' AND';
                } 
                else if(PartPartnerAccSelected != null && mapPartnerNameIntraxId!=null){
                    if(mapPartnerNameIntraxId.get(PartPartnerAccSelected)!=null){
                        sOQLQueryForParticipant_New += ' Partner_ID__c = \'' + mapPartnerNameIntraxId.get(PartPartnerAccSelected) + '\' AND';
                    }
                }                                        
            }
            
            //Checking for Default Contact IP
            if(DefaultConIP != null){
                sOQLQueryForParticipant_New = sOQLQueryForParticipant_New + ' Intrax_Program__c INCLUDES (\'' + DefaultConIP + '\') AND';
            }
            else{
                sOQLQueryForParticipant_New += ' Intrax_Program__c = NULL AND';
            }
            /*
            //Checking for Name value
            if (participant.Name != null && participant.Name != ''){      
                
                //Modify SOQL query for picklist (picklist act as a string)
                //IGI 578 (Start)
                string participantVar_New = String.escapeSingleQuotes(participant.Name);
                //sOQLQueryForParticipant +=  ' Name Like \'%' + participant.Name.replaceAll('\\*','%') + '%\' AND ';
                sOQLQueryForParticipant_New +=  ' Name Like \'%' + participantVar_New.replaceAll('\\*','%') + '%\' AND ';
                //IGI 578 (End)
            }
            */
            //Checking for Name value
            if (EngName != null && EngName != ''){      
                string participantVar_New = String.escapeSingleQuotes(EngName);
                sOQLQueryForParticipant_New +=  ' Name Like \'%' + participantVar_New.replaceAll('\\*','%') + '%\' AND ';
            }
          
            //Checking for Program Duration
            if (programDurationSelected != null && programDurationSelected != ''){      
            
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Program_Duration__c =\'' + programDurationSelected + '\' AND';
            }
            
            //B-01694  (Start)
            if(ProgramYearSelected!= null && ProgramYearSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Program_Year__c =\'' + ProgramYearSelected + '\' AND';
            }
            
            if(ProgramSeasonSelected!= null && ProgramSeasonSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Season__c =\'' + ProgramSeasonSelected + '\' AND';
            }
            
            if(IntraxRegionSelected!= null && IntraxRegionSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Intrax_Region__c =\'' + IntraxRegionSelected + '\' AND';
            }
            
            if(ProgramSvLvlSelected!= null && ProgramSvLvlSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Service_Level__c =\'' + ProgramSvLvlSelected + '\' AND';
            }
            //B-01694  (End)
            
            
            if(IntraxProgramSelected != null && IntraxProgramSelected != ''){
                sOQLQueryForParticipant_New += ' Intrax_Program__c =\'' + IntraxProgramSelected + '\' AND';
            }
            
            //Checking for Program Year
            if (participant.Program_Year__c != null && participant.Program_Year__c != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Program_Year__c =\'' + participant.Program_Year__c + '\' AND';
            }
            
            //Checking for Program Year
            if (PlacementStatusSelected != null &&PlacementStatusSelected != ''){    
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Placement_Status__c =\'' + PlacementStatusSelected + '\' AND';
            }
            
            if (EngagementStatusSelected != null && EngagementStatusSelected != '' ){   
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant_New += ' Status__c =\'' + EngagementStatusSelected + '\' AND';
            }
            else{               
                //B-02446 - Excluding New Status                
                sOQLQueryForParticipant_New += ' Status__c != \'New\' AND';            
            }
            //Checking for Interview_Status__c field value
            if (StatusSelected != null && StatusSelected != '' ){   
                //Modify SOQL query for picklist (picklist act as a string)
                if(StatusSelected == 'Match Pending'){
                    sOQLQueryForParticipant_New += ' Placement_Status__c IN (\'Not Placed\', \'Pending\') AND Status__c NOT IN(\'Early Departure\', \'Program Completed\', \'Terminated\', \'Cancelled\')';
                }
                else if(StatusSelected == 'Matched'){
                    sOQLQueryForParticipant_New += ' Placement_Status__c IN (\'Confirmed\') AND Status__c NOT IN(\'Early Departure\', \'Program Completed\', \'Terminated\', \'Cancelled\')';
                }
                else if(StatusSelected == 'Off Program'){
                    sOQLQueryForParticipant_New += ' Status__c IN(\'Early Departure\', \'Program Completed\', \'Terminated\', \'Cancelled\')';
                }
            }
            
            //  Conditional filter: Only available when IP = Ayusa
            
            if(IntraxProgramSelected == 'Ayusa' && ApprivalTripNeeded != null && ApprivalTripNeeded != ''){
                if(ApprivalTripNeeded == 'Yes') sOQLQueryForParticipant_New += ' Arrival_Trip_Needed__c =\'' + 'YES' + '\' AND';
                else if(ApprivalTripNeeded == 'No') sOQLQueryForParticipant_New += ' Arrival_Trip_Needed__c =\'' + 'NO' + '\' AND';
                else sOQLQueryForParticipant_New += ' Arrival_Trip_Needed__c =\'' + 'YES' + '\' AND Arrival_Trip_Needed__c =\'' +'NO' + '\' AND';
            }
            
            if(IntraxProgramSelected == 'Ayusa' && DepartureTripNeeded != null && DepartureTripNeeded != ''){
                if(DepartureTripNeeded == 'Yes') sOQLQueryForParticipant_New += ' Departure_Trip_Needed__c =\'' + 'YES' + '\' AND';
                else if(DepartureTripNeeded == 'No') sOQLQueryForParticipant_New += ' Departure_Trip_Needed__c =\'' + 'NO' + '\' AND';
                else sOQLQueryForParticipant_New += ' Departure_Trip_Needed__c =\'' + 'YES' + '\' AND Departure_Trip_Needed__c =\'' +'NO' + '\' AND';
            }
            
            if(IntraxProgramSelected == 'Ayusa' && PreProgramTripIndicated != null && PreProgramTripIndicated != ''){
                if(PreProgramTripIndicated == 'Yes') sOQLQueryForParticipant_New += ' Pre_Program_Trip_Indicated__c =\'' + 'YES' + '\' AND';
                else if(PreProgramTripIndicated == 'No') sOQLQueryForParticipant_New += ' Pre_Program_Trip_Indicated__c =\'' + 'NO' + '\' AND';
                else sOQLQueryForParticipant_New += ' Pre_Program_Trip_Indicated__c =\'' + 'YES' + '\' AND Pre_Program_Trip_Indicated__c =\'' +'NO' + '\' AND';
            }
            
            //Checking for Needs Travel field value
            
            //Getting Processed SOQL String value
            sOQLQueryForParticipant_New = processSOQLQueryString(sOQLQueryForParticipant_New);
            System.debug('@@@@@@ value in sOQLQueryForParticipant_New ' + sOQLQueryForParticipant_New);
                        
            //to get full count of records
            totalCount = Database.countQuery(sOQLQueryForParticipant_New); //LIMIT REMOVED                        
            
            System.debug('------->iLIMIT in constructor:'+iLIMIT);
            System.debug('------->limits in constructor:'+limits);
            
            Decimal dBlock=0;
            Integer iBlock=0;
            
            if(totalCount!=null){
                iTotalPages = Integer.valueOf(Math.Ceil(totalCount/integer.valueOf(limits)));                                    
                dBlock = Math.Ceil(totalCount/iLIMIT);                       
            }
            
            iBlock = integer.valueOf(dBlock);
            
            //1253/400 = 3; block=3; if its 3.something, then block should be 4
            //limits is 5 (no of records to display)
            mapOffset = new Map<Integer,Integer>();
            
            Integer c=0;
            Integer off = iOffset;
            for(integer b=iBlock;b>=1;b--){             
                c++;                
                {
                    mapOffset.put(c,off);
                    off = off + iLIMIT;   
                }                               
            }           
            System.debug('------->mapOffset:'+mapOffset);              
            System.debug('----->mapOffset size:'+mapOffset.size());
            //1,0; 2,401; 3,801; 4,1201;            
            
            mapUpdateQuery = new Map<Integer,String>();
            //totalCount/limits
            List<Integer> offsetValues = mapOffset.values();
            for(Integer offset:offsetValues){
                if(offset != 0){
                    //offset = offset-1;                
                    integer o = offset/(integer.valueOf(limits));
                    o++;
                    mapUpdateQuery.put(o,'yes');
                }
            }
            System.debug('------->mapUpdateQuery:'+mapUpdateQuery);
            //81,yes; 161,yes; 241,yes; i.e., pagenumber,yes            
                        
            System.debug('------->pageNumber:'+pageNumber);
            System.debug('------->totalPageNumber:'+totalPageNumber);
            System.debug('------->itotalPageNumber:'+itotalPageNumber);
            
    }   
    
    //to get full count of applications
    public void doFullCount_App(){
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        //Reseting total page number
        totalPageNumber = pageNumber + 1;
    
        //Clear the record from the list saved in the previous hit of Search button
        listOfListApplication.clear();
        
              
        //Check for current user Intrax Id value 
        if(activeUser != null && activeUser.Intrax_Id__c != null) {         
            //B-01493
            string IP;
            List<String> contactIPList = new List<String>();
            string DefaultConIP;
            
            if(activeUser.Contact.Intrax_Programs__c != null){
                IP = activeUser.Contact.Intrax_Programs__c;
                contactIPList = IP.split(';');
            }
            
            if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
            }
            
            System.debug('*****THE VALUE Contact IP CT:'+activeUser.Contact.Intrax_Programs__c);
            System.debug('*****THE VALUE contactIPList:'+contactIPList);
            
            String sOQLQueryForApplicantInfo_New;
            
            if(notStartedAssAppsParam!=null && notStartedAssAppsParam == 'yes' && notStartedAssApps!=null){                               
                    sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: notStartedAssApps AND';                
            }
            else if(inCompleteAssAppsParam!=null && inCompleteAssAppsParam == 'yes' && inCompleteAssApps!=null){                              
                    sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: inCompleteAssApps AND';                
            }
            else if(toHealthReviewAppsParam!=null && toHealthReviewAppsParam == 'yes' && toHealthReviewApps!=null){                              
                    sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: toHealthReviewApps AND';               
            }
            else if(bgCheckReviewAppsParam!=null && bgCheckReviewAppsParam == 'yes' && bgCheckReviewApps!=null){                              
                    sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: bgCheckReviewApps AND';               
            }
            else if(schoolDetailsVerifyAppsParam!=null && schoolDetailsVerifyAppsParam == 'yes' && schoolDetailsVerifyApps!=null){                              
                    sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: schoolDetailsVerifyApps AND';               
            }
            else if(submittedAppsParam!=null && submittedAppsParam == 'yes' && submittedApps!=null){                              
                    sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: submittedApps AND';  
            }
            else if(acceptedAppsParam!=null && acceptedAppsParam == 'yes' && acceptedApps!=null){                              
                    sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: acceptedApps AND';  
            }
            else{                       
            //String to hold the dynamic query
            sOQLQueryForApplicantInfo_New = 'SELECT Count() FROM Applicant_Info__c'
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND';    
            }
            
            System.debug('*****THE VALUE sOQLQueryForApplicantInfo_New:'+sOQLQueryForApplicantInfo_New);
            
            //B-02116            
            
            if(activeUser.Intrax_Id__c != null){    
                if(PartnerAccSelected != null && PartnerAccSelected=='Own'){
                    sOQLQueryForApplicantInfo_New += ' Partner_Intrax_Id__c = \'' + activeUser.Intrax_Id__c + '\' AND';
                } 
                else if(PartnerAccSelected != null && mapPartnerNameIntraxId!=null){
                    if(mapPartnerNameIntraxId.get(PartnerAccSelected)!=null){
                        sOQLQueryForApplicantInfo_New += ' Partner_Intrax_Id__c = \'' + mapPartnerNameIntraxId.get(PartnerAccSelected) + '\' AND';
                    }
                }                                        
            }                       
            
            //Checking for Default Contact IP
            if(DefaultConIP != null){   
                sOQLQueryForApplicantInfo_New = sOQLQueryForApplicantInfo_New + ' Intrax_Program__c = \'' + DefaultConIP + '\' AND ' ;                          
            }
            else{
                sOQLQueryForApplicantInfo_New += ' Intrax_Program__c = NULL AND';
            }
            
            //Checking for Name value
            if (AppName != null && AppName != ''){                      
                //Modify SOQL query for name                
                string applicationVar = String.escapeSingleQuotes(AppName);               
                sOQLQueryForApplicantInfo_New += ' Name Like \'%' + applicationVar.replaceAll('\\*','%') + '%\' AND ';                
            }
            
            //Checking for Program Duration
            if (programDurationSelected != null && programDurationSelected != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Program_Duration__c =\'' + programDurationSelected + '\' AND';
            }
            
            //Checking for Program Year
            if (application.Program_Year__c != null && application.Program_Year__c != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Program_Year__c =\'' + application.Program_Year__c + '\' AND';
            }
            
                        
            //Checking for Incomplete Missing Documents - Conditional Filter: Only available when IP = Ayusa
            if (intraxProgramSelected == 'Ayusa' && application.Incomplete_Missing_Documents__c != null && application.Incomplete_Missing_Documents__c != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Incomplete_Missing_Documents__c INCLUDES (\'' + application.Incomplete_Missing_Documents__c + '\') AND';
            }
            /*
            if(IntraxProgramSelected != null && IntraxProgramSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Intrax_Program__c =\'' + IntraxProgramSelected + '\' AND';
            }
            */
            if(ApplicationLevelSelected!= null && ApplicationLevelSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Application_Level__c =\'' + ApplicationLevelSelected + '\' AND';
            }
            
            //B-01694  (Start)
            if(ProgramYearSelected!= null && ProgramYearSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Program_Year__c =\'' + ProgramYearSelected + '\' AND';
            }
            
            if(ProgramSeasonSelected!= null && ProgramSeasonSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Season__c =\'' + ProgramSeasonSelected + '\' AND';
            }
            
            if(ProgramSvLvlSelected!= null && ProgramSvLvlSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo_New += ' Service_Level__c =\'' + ProgramSvLvlSelected + '\' AND';
            }
            //B-01694  (End)
            System.debug('------ApplicationStageSelected---->'+ApplicationStageSelected);
            if(ApplicationStageSelected != null && ApplicationStageSelected.size()>0){  
                //Modify SOQL query for picklist (picklist act as a string)
                System.debug('------ApplicationStageSelected inside---->'+ApplicationStageSelected.size());
                System.debug('------ApplicationStageSelected inside value---->'+ApplicationStageSelected[0]);
                if(ApplicationStageSelected.size()>=1 && ApplicationStageSelected[0] != ''){
                    System.debug('------ApplicationStageSelected inside value entered---->');
                    string slist='';
                    for (String s: ApplicationStageSelected) 
                    {                            
                        slist += '\'' + s + '\',';              
                    }
                    slist = slist.substring (0,slist.length() -1); 
                    //Forming the OR condition. starting the braces
                    sOQLQueryForApplicantInfo_New = sOQLQueryForApplicantInfo_New + ' (';        
                    //OR conditions                    
                    for(string s:ApplicationStageSelected){                 
                        sOQLQueryForApplicantInfo_New = sOQLQueryForApplicantInfo_New + 'Application_Stage__c = \'' + s + '\' OR ' ;
                    }       
                    //Removing the last OR
                    sOQLQueryForApplicantInfo_New = sOQLQueryForApplicantInfo_New.subString(0, sOQLQueryForApplicantInfo_New.lastIndexOf('OR'));    
                    //closing the braces                                                                                   
                    sOQLQueryForApplicantInfo_New = sOQLQueryForApplicantInfo_New + ') AND'; 
                }                               
            }
            system.debug('*******sOQLQueryForApplicantInfo_New**********'+sOQLQueryForApplicantInfo_New);
            
            if(FromDate != null){ 
                String timeZone = [select timeZoneSidKey from User where id=:userinfo.getUserId()].timeZoneSidKey;
                System.debug('TIME ZONE '+timeZone);                
                system.debug('*******FromDate**********'+FromDate);
                
                string stringDate = String.ValueOf(FromDate);
                system.debug('***** stringDate: ' + stringDate);
                Date inputDate;
                String[] tempStr = stringDate.split('-');
                system.debug('*******tempStr**********'+tempStr); 
                Integer d = Integer.valueOf(tempStr[2]);
                system.debug('*******d**********'+d); 
                Integer m = Integer.valueOf(tempStr[1]);
                system.debug('*******m**********'+m); 
                Integer y = Integer.valueOf(tempStr[0]);
                system.debug('*******y**********'+y); 
                inputDate = Date.newInstance(y,m,d);
                        
                system.debug('*******inputDate**********'+inputDate); 
                              
                
                DateTime refDate1 = DateTime.newInstanceGMT(inputDate.year(), inputDate.month(), inputDate.day(), 0, 0, 0); 
                system.debug('*******refDate1**********'+refDate1);   
                
                           
                //Modify SOQL query for picklist (picklist act as a string)            
               //sOQLQueryForApplicantInfo += ' CreatedDate >= ' + refDate1.format('yyyy-MM-dd',timeZone) + 'T' + refDate1.format('HH:mm:ss.SSS',timeZone) + 'Z' + ' AND ' ;
               sOQLQueryForApplicantInfo_New += ' CreatedDate >= ' + refDate1.formatGMT('yyyy-MM-dd') + 'T' + refDate1.formatGMT('HH:mm:ss.SSS') + 'Z' + ' AND ' ;
                system.debug('*******sOQLQueryForApplicantInfo_New**********'+sOQLQueryForApplicantInfo_New);
            }
            if(ToDate != null){  
                String timeZone = [select timeZoneSidKey from User where id=:userinfo.getUserId()].timeZoneSidKey;
                System.debug('TIME ZONE '+timeZone);
                system.debug('*******ToDate**********'+ToDate);                 
                Date inputDate;
                string stringDate = String.ValueOf(ToDate);
                system.debug('***** stringDate: ' + stringDate);
                String[] tempStr = stringDate.split('-');
                system.debug('*******tempStr**********'+tempStr); 
                Integer d = Integer.valueOf(tempStr[2]);
                system.debug('*******d**********'+d); 
                Integer m = Integer.valueOf(tempStr[1]);
                system.debug('*******m**********'+m); 
                Integer y = Integer.valueOf(tempStr[0]);
                system.debug('*******y**********'+y); 
                
                inputDate = Date.newInstance(y,m,d);      
            
                //DateTime refDate1 = DateTime.newInstanceGMT(inputDate.year(), inputDate.month(), inputDate.day(), 23, 59, 59); 
                DateTime refDate1 = DateTime.newInstanceGMT(inputDate.year(), inputDate.month(), inputDate.day(), 23, 59, 59);
                system.debug('*******refDate1**********'+refDate1); 
                
                //Modify SOQL query for picklist (picklist act as a string)
                //sOQLQueryForApplicantInfo += ' CreatedDate <= ' + refDate1.format('yyyy-MM-dd',timeZone) + 'T' + refDate1.format('HH:mm:ss.SSS',timeZone) + 'Z' + ' AND' ;
                sOQLQueryForApplicantInfo_New += ' CreatedDate <= ' + refDate1.formatGMT('yyyy-MM-dd') + 'T' + refDate1.formatGMT('HH:mm:ss.SSS') + 'Z' + ' AND ' ;
                system.debug('*******sOQLQueryForApplicantInfo_New**********'+sOQLQueryForApplicantInfo_New);
            }
                        system.debug('******* QUERY: ' + sOQLQueryForApplicantInfo_New );
                        
            if(SubmittedFromDate != null){                 
               sOQLQueryForApplicantInfo_New += ' Submitted_Date__c >= :SubmittedFromDate AND ' ;                
            }
            
            if(SubmittedToDate != null){                  
                sOQLQueryForApplicantInfo_New += ' Submitted_Date__c <= :SubmittedToDate AND ' ;                
            }
            
            system.debug('*******sOQLQueryForApplicantInfo_New**********'+sOQLQueryForApplicantInfo_New);
            
            //Processing SOQL String 
            sOQLQueryForApplicantInfo_New = processSOQLQueryString(sOQLQueryForApplicantInfo_New);
            system.debug('******* QUERY: ' + sOQLQueryForApplicantInfo_New );
                        
            //Fetching record from the database
            //applicantRecords = Database.countQuery(sOQLQueryForApplicantInfo);
            totalCount_app = Database.countQuery(sOQLQueryForApplicantInfo_New); //LIMIT REMOVED  
            
            System.debug('@@@@@@value in totalCount_app ' + totalCount_app);
            System.debug('@@@@@@value in pageNumber ' + pageNumber);
            
            Decimal dBlock=0;
            Integer iBlock=0;
            
            if(totalCount_app != null){
                iTotalPages = Integer.valueOf(Math.Ceil(totalCount_app/integer.valueOf(limits)));            
                dBlock = Math.Ceil(totalCount_app/iLIMIT);                                      
            }
            iBlock = integer.valueOf(dBlock);
            
            System.debug('------->iTotalPages in constructor:'+iTotalPages);
            
            //1253/400 = 3; block=3; if its 3.something, then block should be 4
            //limits is 5 (no of records to display)
            mapOffset = new Map<Integer,Integer>();
            
            Integer c=0;
            Integer off = iOffset;
            for(integer b=iBlock;b>=1;b--){             
                c++;                
                {
                    mapOffset.put(c,off);
                    off = off + iLIMIT;   
                }                               
            }           
            System.debug('------->mapOffset:'+mapOffset);              
            System.debug('----->mapOffset size:'+mapOffset.size());
            //1,0; 2,401; 3,801; 4,1201;            
            
            mapUpdateQuery = new Map<Integer,String>();
            //totalCount/limits
            List<Integer> offsetValues = mapOffset.values();
            for(Integer offset:offsetValues){
                if(offset != 0){
                    //offset = offset-1;                
                    integer o = offset/(integer.valueOf(limits));
                    o++;
                    mapUpdateQuery.put(o,'yes');
                }
            }
            System.debug('------->mapUpdateQuery:'+mapUpdateQuery);
            //81,yes; 161,yes; 241,yes; i.e., pagenumber,yes            
                        
            System.debug('------->pageNumber:'+pageNumber);
            System.debug('------->totalPageNumber:'+totalPageNumber);
            System.debug('------->itotalPageNumber:'+itotalPageNumber);
                        
        }
    }
    
    
    //Searching on the basis of the Page Size for the Participants
    public void doSearchOnTheBasisOfPageSizeForParticipant() {
        System.debug('******HERE 1 (START):');
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        dofullcount();
        flag = 'REVERSE_DIR';
        //Calling Method for Serach
        doSearchForParticipant();
        System.debug('******HERE LAST (END):');
    }
    
    //Method for Searching of Participant (Engagement)  
    public void doSearchForParticipant() {
        System.debug('******HERE 2:');
        dofullCount();  
        System.debug('******HERE 3:');
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        system.debug('---->sortExpression in Participant search:'+sortExpression);
        system.debug('---->sortDirection in Participant search:'+sortDirection);
        /*
        if(sortDirection == 'DESC' && flag == 'REVERSE_DIR'){
            system.debug('ENTERED REVERSE DIR FLAG---->');
            sortDirection = 'ASC';
        }
        */
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        //Reseting total page number
        //totalPageNumber = pageNumber + 1;        
           
        //Clear the record from the list saved in the previous hit of Search button
        listOfListParticipantAndMatch.clear();
        
        participantRecords.clear();
        
        //Check for current user Intrax Id value 
        if(activeUser != null && activeUser.Intrax_Id__c != null) {
            
                                    
            //ORIGINAL. LIMIT and OFFSET in QUERY
            //B-01493
            string IP;
            List<String> contactIPList = new List<String>();
            string DefaultConIP;
            
            if(activeUser.Contact.Intrax_Programs__c != null){
                IP = activeUser.Contact.Intrax_Programs__c;
                contactIPList = IP.split(';');
            }
            
            if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
            }
            
            System.debug('*****THE VALUE Contact IP CT:'+activeUser.Contact.Intrax_Programs__c);
            System.debug('*****THE VALUE contactIPList:'+contactIPList);
                        
            //String to hold the dynamic query
            String sOQLQueryForParticipant = 'SELECT Id, Type__c, Status__c, Position_Types__c, Position_Types_Other__c, Name, Location_of_Interest__c,' 
                                                + ' LastModifiedDate, Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Functional_Areas__c,' 
                                                + ' Functional_Areas_Other__c, Experience_Summary__c,  Engagement_Start__c, Engagement_End__c, Account_Id__r.Name,'
                                                + ' Engagement_Country__c, Description__c, CreatedDate, Account_Id__c, Partner_ID__c, Gender__c,Last_Match_Date__c,'
                                                + ' Program_Start__c, Program_Year__c, Needs_Travel__c, Program_Duration__c, Interests_Top__c, Language_1__c, Language_2__c, language_3__c,'
                                                + ' Single_No_Children_Indicated__c, Private_High_School_Indicated__c, Double_Placement_Indicated__c, Live_With_Pets__c, Number_of_Trips__c,Arrival_Trip_Needed__c,Departure_Trip_Needed__c,Pre_Program_Trip_Indicated__c,Placement_Status__c,'
                                                + ' (SELECT ID, Name, Status__c, Double_Placement_Indicated__c,Double_Placement__c, Single_No_Children__c FROM Matches__r), (Select Id, Name From Applicant_Info__r ORDER BY Name DESC) From Engagement__c'
                                                + ' WHERE '//Partner_ID__c = \'' + activeUser.Intrax_Id__c + '\' AND '
                                                + ' Type__c = \'' + 'Participant' + '\' AND';
                                                            
            
            if(activeUser.Intrax_Id__c != null){    
                if(PartPartnerAccSelected != null && PartPartnerAccSelected=='Own'){
                    sOQLQueryForParticipant += ' Partner_ID__c = \'' + activeUser.Intrax_Id__c + '\' AND';
                } 
                else if(PartPartnerAccSelected != null && mapPartnerNameIntraxId!=null){
                    if(mapPartnerNameIntraxId.get(PartPartnerAccSelected)!=null){
                        sOQLQueryForParticipant += ' Partner_ID__c = \'' + mapPartnerNameIntraxId.get(PartPartnerAccSelected) + '\' AND';
                    }
                }                                        
            }
            
            //Checking for Default Contact IP
            if(DefaultConIP != null){   
                sOQLQueryForParticipant = sOQLQueryForParticipant + ' Intrax_Program__c INCLUDES (\'' + DefaultConIP + '\') AND' ;                          
            }
            else{
                sOQLQueryForParticipant += ' Intrax_Program__c = NULL AND';
            }
            
            
            //JOSE B-03077 View filters from PArticipant Quicklinks
            if(awaitingEngsParam!=null && awaitingEngsParam == 'yes'){                               
                sOQLQueryForParticipant += ' Status__c = \'Processing\' AND Placement_Status__c = \'Not Placed\' AND In_Country__c = \'No\' AND';
                system.debug('@@@@@inside awaitingEngsParam : ' + sOQLQueryForParticipant);
                awaitingEngsParam = null;           
            
            }else if(activeInterEngsParam!=null && activeInterEngsParam == 'yes'){                               
                setEngagement = retrieveEngagementList('activeInterEngsParam');
                system.debug('@@@@@inside activeInterEngsParam setEngagement: ' + setEngagement);
                sOQLQueryForParticipant += ' Id IN: setEngagement AND';
                system.debug('@@@@@inside activeInterEngsParam: ' + sOQLQueryForParticipant);
                //activeInterEngsParam = null;           
            
            }else if(inCountryEngsParam!=null && inCountryEngsParam == 'yes'){                               
                sOQLQueryForParticipant += ' Status__c = \'Processing\' AND Placement_Status__c = \'Not Placed\' AND In_Country__c = \'Yes\' AND';
                system.debug('@@@@@inside inCountryEngsParam: ' + sOQLQueryForParticipant);
                //inCountryEngsParam = null;           
            
            }else if(interviewFeedbackEngsParam!=null && interviewFeedbackEngsParam == 'yes'){                               
                setEngagement = retrieveEngagementList('interviewFeedbackEngsParam');
                sOQLQueryForParticipant += ' Id IN: setEngagement AND';
                system.debug('@@@@@inside awaitingEngsParam: ' + sOQLQueryForParticipant);
                //interviewFeedbackEngsParam = null;           
            
            }else if(newMatchesEngsParam!=null && newMatchesEngsParam == 'yes'){                               
                setEngagement = retrieveEngagementList('newMatchesEngsParam');
                sOQLQueryForParticipant += ' Id IN: setEngagement AND';
                system.debug('@@@@@inside newMatchesEngsParam: ' + sOQLQueryForParticipant);
                //newMatchesEngsParam = null;           
            }
            else if(extensionEngsParam!=null && extensionEngsParam == 'yes'){                               
                setEngagement = retrieveEngagementList('extensionEngsParam');
                sOQLQueryForParticipant += ' Id IN: setEngagement AND';
                system.debug('@@@@@inside extensionEngsParam: ' + sOQLQueryForParticipant);
                //extensionEngsParam = null;           
            }
            else if(preArrivalEngsParam!=null && preArrivalEngsParam == 'yes'){                               
                sOQLQueryForParticipant += ' Status__c = \'Program Ready\' AND In_Country__c = \'No\' AND';
                system.debug('@@@@@inside preArrivalEngsParam: ' + sOQLQueryForParticipant);
                //preArrivalEngsParam = null;           
            }
            else if(ProgramUSAEngsParam!=null && ProgramUSAEngsParam == 'yes'){                               
                sOQLQueryForParticipant += ' Status__c = \'On Program\' AND';
                system.debug('@@@@@inside ProgramUSAEngsParam: ' + sOQLQueryForParticipant);
                //ProgramUSAEngsParam = null;           
            }
            //END JOSE B-03077 
            
            
            //Checking for Name value
            if(engName != null && engName != ''){      
                string participantVar = String.escapeSingleQuotes(engName);
                sOQLQueryForParticipant +=  ' Name Like \'%' + participantVar.replaceAll('\\*','%') + '%\' AND ';
            }
            
            //Checking for Program Duration
            if (programDurationSelected != null && programDurationSelected != ''){      
            
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Program_Duration__c =\'' + programDurationSelected + '\' AND';
            }
            
            //B-01694  (Start)
            if(ProgramYearSelected!= null && ProgramYearSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Program_Year__c =\'' + ProgramYearSelected + '\' AND';
            }
            
            if(ProgramSeasonSelected!= null && ProgramSeasonSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Season__c =\'' + ProgramSeasonSelected + '\' AND';
            }
            
            if(IntraxRegionSelected!= null && IntraxRegionSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Intrax_Region__c =\'' + IntraxRegionSelected + '\' AND';
            }
            
            if(ProgramSvLvlSelected!= null && ProgramSvLvlSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Service_Level__c =\'' + ProgramSvLvlSelected + '\' AND';
            }
            //B-01694  (End)
            
            system.debug('***** Intrax Program Selected: ' + IntraxProgramSelected);
            if(IntraxProgramSelected != null && IntraxProgramSelected != ''){
                sOQLQueryForParticipant += ' Intrax_Program__c =\'' + IntraxProgramSelected + '\' AND';
            }
            
            //Checking for Program Year
            if (participant.Program_Year__c != null && participant.Program_Year__c != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Program_Year__c =\'' + participant.Program_Year__c + '\' AND';
            }
            
            //Checking for Program Year
            if (PlacementStatusSelected != null &&PlacementStatusSelected != ''){    
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Placement_Status__c =\'' + PlacementStatusSelected + '\' AND';
            }
            
            if (EngagementStatusSelected != null && EngagementStatusSelected != '' ){   
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForParticipant += ' Status__c =\'' + EngagementStatusSelected + '\' AND';
            }
            else{               
                //B-02446 - Excluding New Status                
                sOQLQueryForParticipant += ' Status__c != \'New\' AND';             
            }
            //Checking for Interview_Status__c field value
            if (StatusSelected != null && StatusSelected != '' ){   
                //Modify SOQL query for picklist (picklist act as a string)
                if(StatusSelected == 'Match Pending'){
                    sOQLQueryForParticipant += ' Placement_Status__c IN (\'Not Placed\', \'Pending\') AND Status__c NOT IN(\'Early Departure\', \'Program Completed\', \'Terminated\', \'Cancelled\')';
                }
                else if(StatusSelected == 'Matched'){
                    sOQLQueryForParticipant += ' Placement_Status__c IN (\'Confirmed\') AND Status__c NOT IN(\'Early Departure\', \'Program Completed\', \'Terminated\', \'Cancelled\')';
                }
                else if(StatusSelected == 'Off Program'){
                    sOQLQueryForParticipant += ' Status__c IN(\'Early Departure\', \'Program Completed\', \'Terminated\', \'Cancelled\')';
                }
            }
            
            //  Conditional filter: Only available when IP = Ayusa
            
            if(IntraxProgramSelected == 'Ayusa' && ApprivalTripNeeded != null && ApprivalTripNeeded != ''){
                if(ApprivalTripNeeded == 'Yes') sOQLQueryForParticipant += ' Arrival_Trip_Needed__c =\'' + 'YES' + '\' AND';
                else if(ApprivalTripNeeded == 'No') sOQLQueryForParticipant += ' Arrival_Trip_Needed__c =\'' + 'NO' + '\' AND';
                else sOQLQueryForParticipant += ' Arrival_Trip_Needed__c =\'' + 'YES' + '\' AND Arrival_Trip_Needed__c =\'' +'NO' + '\' AND';
            }
            
            if(IntraxProgramSelected == 'Ayusa' && DepartureTripNeeded != null && DepartureTripNeeded != ''){
                if(DepartureTripNeeded == 'Yes') sOQLQueryForParticipant += ' Departure_Trip_Needed__c =\'' + 'YES' + '\' AND';
                else if(DepartureTripNeeded == 'No') sOQLQueryForParticipant += ' Departure_Trip_Needed__c =\'' + 'NO' + '\' AND';
                else sOQLQueryForParticipant += ' Departure_Trip_Needed__c =\'' + 'YES' + '\' AND Departure_Trip_Needed__c =\'' +'NO' + '\' AND';
            }
            
            if(IntraxProgramSelected == 'Ayusa' && PreProgramTripIndicated != null && PreProgramTripIndicated != ''){
                if(PreProgramTripIndicated == 'Yes') sOQLQueryForParticipant += ' Pre_Program_Trip_Indicated__c =\'' + 'YES' + '\' AND';
                else if(PreProgramTripIndicated == 'No') sOQLQueryForParticipant += ' Pre_Program_Trip_Indicated__c =\'' + 'NO' + '\' AND';
                else sOQLQueryForParticipant += ' Pre_Program_Trip_Indicated__c =\'' + 'YES' + '\' AND Pre_Program_Trip_Indicated__c =\'' +'NO' + '\' AND';
            }
            
            //Checking for Needs Travel field value
            
            //Getting Processed SOQL String value
            sOQLQueryForParticipant = processSOQLQueryString(sOQLQueryForParticipant);
            System.debug('@@@@@@ value in sOQLQueryForParticipant ' + sOQLQueryForParticipant);
            System.debug('******HERE 4:');
            System.debug('----> value in iLIMIT ' + iLIMIT);
            System.debug('----> value in iOffset ' + iOffset);
            System.debug('----> value in setEngagement: ' + setEngagement);
            
            //Fetching record from the database
            participantRecords = Database.query(sOQLQueryForParticipant + 'ORDER BY ' + sortFullExp + ' LIMIT ' + iLIMIT + ' OFFSET ' + iOffset);            
            totalCount = participantRecords.size(); 
            // Pending PDO Filter. Conditional filter: Only available when IP = Ayusa
            if(IntraxProgramSelected == 'Ayusa' && PendingPDOSelected != null && PendingPDOSelected != ''){
                list<Intrax_Program_Upload__c> pdo_pt = [SELECT Engagement__c, Document_Type__c FROM Intrax_Program_Upload__c 
                                                                WHERE Engagement__c IN: participantRecords AND Document_Type__c = 'Pre-Departure-Orientation-Agreement'];
                
                map<String, String> mappdo_notpending = new map<String, string>();
                map<String, String> mappdo_pending = new map<String, string>();
                for(Intrax_Program_Upload__c ipu : pdo_pt){
                    if(ipu.Document_Type__c == 'Pre-Departure-Orientation-Agreement')
                        mappdo_notpending.put(ipu.Engagement__c, 'Included' );
                }
                list<Engagement__c> eng_notpending  = new list<Engagement__c>();
                list<Engagement__c> eng_pending  = new list<Engagement__c>();
                
                for(Engagement__c e : participantRecords){
                    if(mappdo_notpending.containsKey(e.Id)) eng_notpending.add(e);
                    else eng_pending.add(e);
                }

                if(PendingPDOSelected == 'Yes') participantRecords = eng_pending;
                else if(PendingPDOSelected == 'No') participantRecords = eng_notpending;
            }
            
            // Applying Match Filters
            if(IntraxProgramSelected == 'Ayusa' && ((DoublePlacementSelected != null && DoublePlacementSelected != '') || (SingleNoChildrenSelected != null && SingleNoChildrenSelected != '')) ){
                string sOQLQueryForMatch = 'SELECT Id, Name, Double_Placement_Indicated__c, Double_Placement__c,Single_No_Children_Indicated__c, Single_No_Children__c, Engagement__c'
                                                + ' FROM Match__c' 
                                                + ' WHERE Engagement__c IN: participantRecords AND';
                
                if(DoublePlacementSelected != null && DoublePlacementSelected != ''){
                    sOQLQueryForMatch += ' Double_Placement__c =' + DoublePlacementSelected + ' AND';
                }
                
                if(SingleNoChildrenSelected != null && SingleNoChildrenSelected != ''){
                    sOQLQueryForMatch += ' Single_No_Children__c =' + SingleNoChildrenSelected + ' AND';
                }
                            
                sOQLQueryForMatch = processSOQLQueryString(sOQLQueryForMatch); 
                system.debug('@@@@@@ value in sOQLQueryForMatch ' + sOQLQueryForMatch); 
                list<Match__c> MatchRecords = Database.query(sOQLQueryForMatch); 
                
                if(PendingSchoolSelected != null && PendingSchoolSelected != ''){
                    list<Intrax_Program_Upload__c> pdo_pt = [SELECT Document_Type__c, Match__c FROM Intrax_Program_Upload__c 
                                                                    WHERE Match__c IN: MatchRecords AND Document_Type__c =: 'School-Permission' and Review_Status__c =: 'Confirmed'];
                    if(pdo_pt.Size() == 0){
                        if(PendingSchoolSelected == 'No') matchRecords.clear();
                    }else{
                        // We found some records that meet the filter criteria
                        map<String, String> mappdo_notpending = new map<String, string>();
                        map<String, String> mappdo_pending = new map<String, string>();
                        for(Intrax_Program_Upload__c ipu : pdo_pt){
                            if(ipu.Document_Type__c == 'School-Permission')
                                mappdo_notpending.put(ipu.Match__c, 'Included' );
                        }
                        list<Match__c> m_notpending  = new list<Match__c>();
                        list<Match__c> m_pending  = new list<Match__c>();
                        
                        for(Match__c m : matchRecords){
                            if(mappdo_notpending.containsKey(m.Id)) m_notpending.add(m);
                            else m_pending.add(m);
                        }
                        system.debug('****** match Pending: ' + m_pending.size());
                        system.debug('****** match NOT Pending: ' + m_notpending.size());
        
                        if(PendingSchoolSelected == 'Yes') matchRecords = m_pending;
                        else if(PendingSchoolSelected == 'No') matchRecords = m_notpending;
                    }
                }
                
                
                if(MatchRecords.size() > 0){
                    list<string> AuxIds =  new list<string>();
                    for(Match__c m : MatchRecords){
                        AuxIds.add(m.Engagement__c);
                    } 
                
                
                    participantRecords = [SELECT Id, Type__c, Status__c, Position_Types__c, Position_Types_Other__c, Name, Location_of_Interest__c,
                                                LastModifiedDate, Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Functional_Areas__c,
                                                Functional_Areas_Other__c, Experience_Summary__c,  Engagement_Start__c, Engagement_End__c, Account_Id__r.Name,
                                                Engagement_Country__c, Description__c, CreatedDate, Account_Id__c, Partner_ID__c, Gender__c,Last_Match_Date__c,
                                                Program_Start__c, Program_Year__c, Needs_Travel__c, Program_Duration__c, Interests_Top__c, Language_1__c, Language_2__c, language_3__c,
                                                Single_No_Children_Indicated__c, Private_High_School_Indicated__c, Double_Placement_Indicated__c, Live_With_Pets__c, Number_of_Trips__c,Arrival_Trip_Needed__c,Departure_Trip_Needed__c,Pre_Program_Trip_Indicated__c,Placement_Status__c,
                                                (SELECT ID, Name, Status__c, Double_Placement_Indicated__c, Double_Placement__c, Single_No_Children__c FROM Matches__r),(Select Id, Name From Applicant_Info__r ORDER BY Name DESC) 
                                                From Engagement__c
                                                WHERE Id IN: AuxIds];
                                                
                }else{
                    participantRecords.clear();
                }                             
                /*
                if(PendingSchoolSelected != null && PendingSchoolSelected != ''){
                    list<Intrax_Program_Upload__c> pdo_pt = [SELECT Document_Type__c, Match__c FROM Intrax_Program_Upload__c 
                                                                    WHERE Match__c IN: MatchRecords AND Document_Type__c =: 'School-Permission' and Review_Status__c =: 'Confirmed'];
                if(pdo_pt.Size() > 0){
                    // We found some records that meet the filter criteria
                    map<String, String> mappdo_notpending = new map<String, string>();
                    map<String, String> mappdo_pending = new map<String, string>();
                    for(Intrax_Program_Upload__c ipu : pdo_pt){
                        if(ipu.Document_Type__c == 'School-Permission')
                            mappdo_notpending.put(ipu.Match__c, 'Included' );
                    }
                    list<Match__c> m_notpending  = new list<Match__c>();
                    list<Match__c> m_pending  = new list<Match__c>();
                    
                    for(Match__c m : matchRecords){
                        if(mappdo_notpending.containsKey(m.Id)) m_notpending.add(m);
                        else m_pending.add(m);
                    }
    
                    if(PendingSchoolSelected == 'Yes') matchRecords = m_pending;
                    else if(PendingSchoolSelected == 'No') matchRecords = m_notpending;
                }else{
                    if(PendingPDOSelected == 'Yes') matchRecords = m_pending;
                    else if(PendingPDOSelected == 'No') matchRecords = m_notpending;
                }
                */
                
                
                
                
            }
           
            //Populating list of list with value
            listOfListParticipantAndMatch.add(new List<EngagementMatchWrapper>());
            
            //Integer is going to be helpful to populate list of list
            Integer i = 0;
            /*          
            //Check for size of list
            if(totalRecords != null && totalRecords.size()>0){
                //Setting Page Size value
                PAGE_SIZE = calculatePageSize(totalRecords.size());
            }
            */
            if(participantRecords != null && participantRecords.size() > 0) {
                
                //Setting Page Size value
                PAGE_SIZE = calculatePageSize(participantRecords.size());
                
                //Setting Default Value
                participantOptions.add(new SelectOption('None', 'None'));
                
                //loop through Participants records
                for(Engagement__c partAcc : participantRecords) {
                    
                    //Populating Select List with the Matches Options Options
                    participantOptions.add(new SelectOption(partAcc.Id, partAcc.Name));
                    
                    //Populating set with the engagement Ids
                    listEngagementIds.add(partAcc.Id);
                    
                    //Populating Map with the values
                    
                    //Checking for match record associated with Engagement record
                    //IGI - 716 (Commented Below Lines of code) - Start
                    /*if(partAcc.Matches__r == null || partAcc.Matches__r.size() == 0) {
                    
                        //Popukating map with values
                        mapParticipantIdWithMatch.put(partAcc.ID, new Match__c());
                    
                    } else {
                        
                        //Popukating map with values
                        mapParticipantIdWithMatch.put(partAcc.ID, partAcc.Matches__r[0]);
                    }*/
                    //IGI - 716 (Commented Below Lines of code) - End
                            
                    //Checking for integer value                
                    if(i == PAGE_SIZE) {
                        
                        //Adding new List to the list of list
                        listOfListParticipantAndMatch.add(new List<EngagementMatchWrapper>());
                        i=0;
                    }
              
                    //adding new List at the index of the List
                    //IGI - 716 (Commented 1st Line and added below lines) - Start
                    //listOfListParticipantAndMatch[listOfListParticipantAndMatch.size()-1].add(new EngagementMatchWrapper(partAcc, mapParticipantIdWithMatch.get(partAcc.Id)));
                    if(partAcc.Matches__r == null || partAcc.Matches__r.size() == 0) 
                    {
                        listOfListParticipantAndMatch[listOfListParticipantAndMatch.size()-1].add(new EngagementMatchWrapper(partAcc, new Match__c()));
                    }
                    else
                    {
                        listOfListParticipantAndMatch[listOfListParticipantAndMatch.size()-1].add(new EngagementMatchWrapper(partAcc, partAcc.Matches__r[0]));
                    }
                    //IGI - 716 (Commented 1st Line and added below lines) - End
                    i++;
                }
            }     
            
            //Checking for Assessments
            if(ApexPages.currentPage().getParameters().get('isAssessments') != null) {
                
                //String to hold Quoted Engagement Id Strings related to Host Company
                String quotedEngagementIds = '';
                
                //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
                sortFullExpForAssessments = sortExpressionForAssessments  + ' ' + sortDirectionForAssessments + ' ' + 'NULLS LAST';
        
                //Clear the record from the list saved in the previous hit of Search button
                listOfListAssessment.clear();
            
                //Check for value in Set
                if(ApexPages.currentPage().getParameters().get('participantId') != null)
                {
                    list<string> PAssesmentId = new list<string>();
                    PAssesmentId.add(ApexPages.currentPage().getParameters().get('participantId'));
                    quotedEngagementIds = quotedString(PAssesmentId);
                }
                else if(listEngagementIds != null) 
                {
                    //Getting Quoted String of Engagement Ids
                    quotedEngagementIds = quotedString(listEngagementIds);
                }
                
                //Check for null value for the String
                if(quotedEngagementIds != null && quotedEngagementIds != '') {
                    
                    //String to hold the dynamic query
                    String sOQLQueryForAssessment = 'SELECT Id, Engagement__c, Record_Type_Group__c, Assessment_Date__c, Host_Name__c , Match_Name__c, Name, Count_Down__c, RecordTypeId,' 
                                                        + ' Resident_Total__c, Overall_Assessment__c, Participant_Name__c, Time_Period__c, RecordType.Name,'
                                                        + ' Engagement__r.Program_Year__c, Engagement__r.Name, Match_Name__r.Name, Status__c From Assessment__c' 
                                                        + ' WHERE Engagement__c IN ' + quotedEngagementIds + ' AND'
                                                        + ' Status__c = \'' + 'Confirmed' + '\' AND ' 
                                                        + ' (Record_Type_Group__c = \'' + 'AY PT Contact' + '\' OR Record_Type_Group__c = \'' + 'AY HF Contact' + '\' OR Record_Type_Group__c = \'' + 'AY SC Contact' + '\' OR RecordType.Name = \'' + 'AY PT Orientation' + '\') AND '; 
                                                          
                    //Checking for Status(Stage) value
                    if (assessment.Name != null && assessment.Name != ''){      
                
                        //Modify SOQL query for picklist (picklist act as a string)
                        //IGI 578 (Start)
                        string assessmentVar = String.escapeSingleQuotes(assessment.Name);
                        
                        //sOQLQueryForAssessment += ' Name Like \'%' + assessment.Name.replaceAll('\\*','%') + '%\' AND ';
                        sOQLQueryForAssessment += ' Name Like \'%' + assessmentVar.replaceAll('\\*','%') + '%\' AND ';
                        //IGI 578 (End) 
                    }
                    
                    //Checking for Program Year value
                    if (assessment.Engagement__r.Program_Year__c != null && assessment.Engagement__r.Program_Year__c != ''){      
                
                        //Modify SOQL query for picklist (picklist act as a string)
                        sOQLQueryForAssessment += ' Engagement__r.Program_Year__c =\'' + assessment.Engagement__r.Program_Year__c + '\' AND';
                    }
                    system.debug('******* Query for Assessment: ' + sOQLQueryForAssessment);
                    //Getting processed SOQL String value
                    sOQLQueryForAssessment = processSOQLQueryString(sOQLQueryForAssessment);
                    system.debug('******* Query for Assessment: ' + sOQLQueryForAssessment);
                                    
                    //Fetching record from the database
                    //List<Assessment__c> assessmentsRecords = Database.query(sOQLQueryForAssessment + 'ORDER BY ' + sortFullExpForAssessments);
                    List<Assessment__c> assessmentsRecords = Database.query(sOQLQueryForAssessment + 'ORDER BY Count_Down__c ASC' );
                    
                    system.debug('*****###AssessmentRecord size = ' + assessmentsRecords.size());
                    system.debug('*****###Engagement ID = ' + quotedEngagementIds);
                    
                                        
                    //Populating list of list with value
                    listOfListAssessment.add(new List<Assessment__c>());
                    
                    Integer j = 0;
    
                    //Check for size of list
                    if(assessmentsRecords != null && assessmentsRecords.size() > 0) {
                        
                        //Setting Page Size value
                        PAGE_SIZE = calculatePageSize(assessmentsRecords.size());
                        
                        //loop through Assessment records
                        for(Assessment__c assess : assessmentsRecords) {
                            
                            //Checking for integer value                
                            if(j == PAGE_SIZE) {
                                
                                //Adding new List to the list of list
                                listOfListAssessment.add(new List<Assessment__c>());
                                j=0;
                            }
                            
                            //adding new List at the index of the List
                            listOfListAssessment[listOfListAssessment.size()-1].add(assess);
                            j++;
                        }
                    }     
                    
                } else {
                    
                    //Populating list of list with value
                    listOfListAssessment.add(new List<Assessment__c>());
                }   
            
                       
            }
         }
    }
    
    public void doActionForViewList(){
        notStartedAssAppsParam = null;
        inCompleteAssAppsParam = null;
        toHealthReviewAppsParam = null;
        bgCheckReviewAppsParam = null;
        schoolDetailsVerifyAppsParam = null;
        applicantRecords.clear();
        
        if(viewSelected == 'Interviews to Start'){          
            notStartedAssAppsParam = 'yes';                     
        }
        else if(viewSelected == 'Interviews to Complete'){
            inCompleteAssAppsParam = 'yes';           
        }
        else if(viewSelected == 'Health Forms to Review'){
            toHealthReviewAppsParam = 'yes';             
        }
        else if(viewSelected == 'BG Checks to Review'){
            bgCheckReviewAppsParam = 'yes';             
        }
        else if(viewSelected == 'School Details to Verify'){
            schoolDetailsVerifyAppsParam = 'yes';             
        }
        
        else{
            notStartedAssAppsParam = null;
            inCompleteAssAppsParam = null;
            toHealthReviewAppsParam = null;  
            bgCheckReviewAppsParam = null;   
            schoolDetailsVerifyAppsParam = null;
        }

        doSearchForPageSize();
    }
    
    //JOSE B-03077
    public void doActionForViewListEng(){
        
        awaitingEngsParam = null; 
        activeInterEngsParam = null;
        inCountryEngsParam = null;
        interviewFeedbackEngsParam = null; 
        newMatchesEngsParam = null;
        extensionEngsParam = null;
        preArrivalEngsParam = null;
        ProgramUSAEngsParam = null;
        
        participantRecords.clear();
        
        if(viewSelected == 'Awaiting Placement'){          
            awaitingEngsParam = 'yes';                     
        }
        else if(viewSelected == 'Active Interviews'){
            activeInterEngsParam = 'yes';           
        }
        else if(viewSelected == 'In-Country'){
            inCountryEngsParam = 'yes';             
        }
        else if(viewSelected == 'Interview Feedback'){
            interviewFeedbackEngsParam = 'yes';             
        }
        else if(viewSelected == 'New Matches (last 30 days)'){
            newMatchesEngsParam = 'yes';             
        }
        else if(viewSelected == 'Extensions'){
            extensionEngsParam = 'yes';             
        }
        else if(viewSelected == 'Pre-Arrival'){
            preArrivalEngsParam = 'yes';             
        }
        else if(viewSelected == 'On Program (In USA)'){
            ProgramUSAEngsParam = 'yes';             
        }
        
        else{
            awaitingEngsParam = null; 
            activeInterEngsParam = null;
            inCountryEngsParam = null;
            interviewFeedbackEngsParam = null; 
            newMatchesEngsParam = null;
            extensionEngsParam = null;
            preArrivalEngsParam = null;
            ProgramUSAEngsParam = null;
        }

        doSearchForParticipant();
    }
    //END JOSE B-03077
  
                
    
    //Searching on the basis of the Page Size for the Applications
    public void doSearchForPageSize() {
             
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        dofullcount_App();
        flag = 'REVERSE_DIR';
        //Calling Method for Serach
        doSearch();
        
    }
           
    //Method for Searching of Applicant Info
    public void doSearch() {
        dofullcount_App();
        system.debug('******** SortExpression in app search: ' + sortExpression);
        system.debug('******** SortDirection in app search: ' + sortDirection);
        /*
        if(sortDirection == 'DESC' && flag == 'REVERSE_DIR'){
            system.debug('ENTERED REVERSE DIR FLAG---->');
            sortDirection = 'ASC';
        }
        */
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        //Reseting total page number
        totalPageNumber = pageNumber + 1;
    
        //Clear the record from the list saved in the previous hit of Search button
        listOfListApplication.clear();
        
              
        //Check for current user Intrax Id value 
        if(activeUser != null && activeUser.Intrax_Id__c != null) {         
            //B-01493
            string IP;
            List<String> contactIPList = new List<String>();
            string DefaultConIP;
            
            if(activeUser.Contact.Intrax_Programs__c != null){
                IP = activeUser.Contact.Intrax_Programs__c;
                contactIPList = IP.split(';');
            }
            
            if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
            }
            
            System.debug('*****THE VALUE Contact IP CT:'+activeUser.Contact.Intrax_Programs__c);
            System.debug('*****THE VALUE contactIPList:'+contactIPList);
            String sOQLQueryForApplicantInfo;
            
            if(notStartedAssAppsParam!=null && notStartedAssAppsParam == 'yes' && notStartedAssApps!=null){                               
                    sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: notStartedAssApps AND';                
            }
            else if(inCompleteAssAppsParam!=null && inCompleteAssAppsParam == 'yes' && inCompleteAssApps!=null){                              
                    sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: inCompleteAssApps AND';                
            }
            else if(toHealthReviewAppsParam!=null && toHealthReviewAppsParam == 'yes' && toHealthReviewApps!=null){                              
                    sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: toHealthReviewApps AND';               
            }
            else if(bgCheckReviewAppsParam!=null && bgCheckReviewAppsParam == 'yes' && bgCheckReviewApps!=null){                              
                    sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: bgCheckReviewApps AND';               
            }
            else if(schoolDetailsVerifyAppsParam!=null && schoolDetailsVerifyAppsParam == 'yes' && schoolDetailsVerifyApps!=null){                              
                    sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: schoolDetailsVerifyApps AND';               
            }
            
            else if(submittedAppsParam!=null && submittedAppsParam == 'yes' && submittedApps!=null){                              
                    sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: submittedApps AND';               
            }
            
            else if(acceptedAppsParam!=null && acceptedAppsParam == 'yes' && acceptedApps!=null){                              
                    sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND Id IN: acceptedApps AND';               
            }
            else{
            //String to hold the dynamic query
            sOQLQueryForApplicantInfo = 'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'   
                                                + ' WHERE Type__c = \'' + 'Participant' + '\' AND';
            }                                           
            System.debug('*****THE VALUE sOQLQueryForApplicantInfo:'+sOQLQueryForApplicantInfo);
            
            //B-02116            
            if(activeUser.Intrax_Id__c != null){ 
                if(PartnerAccSelected != null && PartnerAccSelected=='Own'){
                    sOQLQueryForApplicantInfo += ' Partner_Intrax_Id__c = \'' + activeUser.Intrax_Id__c + '\' AND';
                } 
                else if(PartnerAccSelected != null && mapPartnerNameIntraxId!=null){
                    if(mapPartnerNameIntraxId.get(PartnerAccSelected)!=null){
                        sOQLQueryForApplicantInfo += ' Partner_Intrax_Id__c = \'' + mapPartnerNameIntraxId.get(PartnerAccSelected) + '\' AND';
                    }
                }                                             
            }
            
            System.debug(':::::::sOQLQueryForApplicantInfo::::OR::::'+sOQLQueryForApplicantInfo);
            
            //Checking for Default Contact IP
            if(DefaultConIP != null){   
                sOQLQueryForApplicantInfo = sOQLQueryForApplicantInfo + ' Intrax_Program__c = \'' + DefaultConIP + '\' AND ' ;                          
            }
            else{
                sOQLQueryForApplicantInfo += ' Intrax_Program__c = NULL AND';
            }
            
            //Checking for Name value
            if (AppName != null && AppName != ''){                      
                //Modify SOQL query for name                
                string applicationVar = String.escapeSingleQuotes(AppName);               
                sOQLQueryForApplicantInfo += ' Name Like \'%' + applicationVar.replaceAll('\\*','%') + '%\' AND ';                
            }
            
            //Checking for Program Duration
            if (application.Program_Duration__c != null && application.Program_Duration__c != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Program_Duration__c =\'' + application.Program_Duration__c + '\' AND';
            }
            
            //Checking for Program Year
            if (application.Program_Year__c != null && application.Program_Year__c != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Program_Year__c =\'' + application.Program_Year__c + '\' AND';
            }
            
                        
            //Checking for Incomplete Missing Documents - Conditional Filter: Only available when IP = Ayusa
            if (intraxProgramSelected == 'Ayusa' && application.Incomplete_Missing_Documents__c != null && application.Incomplete_Missing_Documents__c != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Incomplete_Missing_Documents__c INCLUDES (\'' + application.Incomplete_Missing_Documents__c + '\') AND';
            }
            /*
            if(IntraxProgramSelected != null && IntraxProgramSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Intrax_Program__c =\'' + IntraxProgramSelected + '\' AND';
            }
            */
            if(ApplicationLevelSelected!= null && ApplicationLevelSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Application_Level__c =\'' + ApplicationLevelSelected + '\' AND';
            }
            
            //B-01694  (Start)
            if(ProgramYearSelected!= null && ProgramYearSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Program_Year__c =\'' + ProgramYearSelected + '\' AND';
            }
            
            if(ProgramSeasonSelected!= null && ProgramSeasonSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Season__c =\'' + ProgramSeasonSelected + '\' AND';
            }
            
            if(ProgramSvLvlSelected!= null && ProgramSvLvlSelected != ''){  
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForApplicantInfo += ' Service_Level__c =\'' + ProgramSvLvlSelected + '\' AND';
            }
            //B-01694  (End)
            
            if(ApplicationStageSelected != null && ApplicationStageSelected.size()>0){  
                if(ApplicationStageSelected.size()>=1 && ApplicationStageSelected[0] != ''){
                string slist='';
                for (String s: ApplicationStageSelected) 
                {
                    slist += '\'' + s + '\',';              
                }
                slist = slist.substring (0,slist.length() -1); 
                //Forming the OR condition. starting the braces
                sOQLQueryForApplicantInfo = sOQLQueryForApplicantInfo + ' (';        
                //OR conditions                    
                for(string s:ApplicationStageSelected){
                    sOQLQueryForApplicantInfo = sOQLQueryForApplicantInfo + 'Application_Stage__c = \'' + s + '\' OR ' ;
                }       
                //Removing the last OR
                sOQLQueryForApplicantInfo = sOQLQueryForApplicantInfo.subString(0, sOQLQueryForApplicantInfo.lastIndexOf('OR'));    
                //closing the braces                                                                                   
                sOQLQueryForApplicantInfo = sOQLQueryForApplicantInfo + ') AND';
                }         
            }
            
            if(FromDate != null){ 
                String timeZone = [select timeZoneSidKey from User where id=:userinfo.getUserId()].timeZoneSidKey;
                System.debug('TIME ZONE '+timeZone);                
                system.debug('*******FromDate**********'+FromDate);
                
                string stringDate = String.ValueOf(FromDate);
                system.debug('***** stringDate: ' + stringDate);
                Date inputDate;
                String[] tempStr = stringDate.split('-');
                system.debug('*******tempStr**********'+tempStr); 
                Integer d = Integer.valueOf(tempStr[2]);
                system.debug('*******d**********'+d); 
                Integer m = Integer.valueOf(tempStr[1]);
                system.debug('*******m**********'+m); 
                Integer y = Integer.valueOf(tempStr[0]);
                system.debug('*******y**********'+y); 
                inputDate = Date.newInstance(y,m,d);
                        
                system.debug('*******inputDate**********'+inputDate); 
                              
                
                DateTime refDate1 = DateTime.newInstanceGMT(inputDate.year(), inputDate.month(), inputDate.day(), 0, 0, 0); 
                system.debug('*******refDate1**********'+refDate1);   
                
                           
                //Modify SOQL query for picklist (picklist act as a string)            
               //sOQLQueryForApplicantInfo += ' CreatedDate >= ' + refDate1.format('yyyy-MM-dd',timeZone) + 'T' + refDate1.format('HH:mm:ss.SSS',timeZone) + 'Z' + ' AND ' ;
               sOQLQueryForApplicantInfo += ' CreatedDate >= ' + refDate1.formatGMT('yyyy-MM-dd') + 'T' + refDate1.formatGMT('HH:mm:ss.SSS') + 'Z' + ' AND ' ;
                system.debug('*******sOQLQueryForApplicantInfo**********'+sOQLQueryForApplicantInfo);
            }
            if(ToDate != null){  
                String timeZone = [select timeZoneSidKey from User where id=:userinfo.getUserId()].timeZoneSidKey;
                System.debug('TIME ZONE '+timeZone);
                system.debug('*******ToDate**********'+ToDate);                 
                Date inputDate;
                string stringDate = String.ValueOf(ToDate);
                system.debug('***** stringDate: ' + stringDate);
                String[] tempStr = stringDate.split('-');
                system.debug('*******tempStr**********'+tempStr); 
                Integer d = Integer.valueOf(tempStr[2]);
                system.debug('*******d**********'+d); 
                Integer m = Integer.valueOf(tempStr[1]);
                system.debug('*******m**********'+m); 
                Integer y = Integer.valueOf(tempStr[0]);
                system.debug('*******y**********'+y); 
                
                inputDate = Date.newInstance(y,m,d);      
            
                //DateTime refDate1 = DateTime.newInstanceGMT(inputDate.year(), inputDate.month(), inputDate.day(), 23, 59, 59); 
                DateTime refDate1 = DateTime.newInstanceGMT(inputDate.year(), inputDate.month(), inputDate.day(), 23, 59, 59);
                system.debug('*******refDate1**********'+refDate1); 
                
                //Modify SOQL query for picklist (picklist act as a string)
                //sOQLQueryForApplicantInfo += ' CreatedDate <= ' + refDate1.format('yyyy-MM-dd',timeZone) + 'T' + refDate1.format('HH:mm:ss.SSS',timeZone) + 'Z' + ' AND' ;
                sOQLQueryForApplicantInfo += ' CreatedDate <= ' + refDate1.formatGMT('yyyy-MM-dd') + 'T' + refDate1.formatGMT('HH:mm:ss.SSS') + 'Z' + ' AND ' ;
                system.debug('*******sOQLQueryForApplicantInfo**********'+sOQLQueryForApplicantInfo);
            }
                        system.debug('******* QUERY: ' + sOQLQueryForApplicantInfo );
                        
            if(SubmittedFromDate != null){                 
               sOQLQueryForApplicantInfo += ' Submitted_Date__c >= :SubmittedFromDate AND ' ;                
            }
            
            if(SubmittedToDate != null){                  
                sOQLQueryForApplicantInfo += ' Submitted_Date__c <= :SubmittedToDate AND ' ;                
            }
            
            system.debug('*******sOQLQueryForApplicantInfo**********'+sOQLQueryForApplicantInfo);
            //Processing SOQL String 
            sOQLQueryForApplicantInfo = processSOQLQueryString(sOQLQueryForApplicantInfo);
            system.debug('******* QUERY: ' + sOQLQueryForApplicantInfo );
                        
            //Fetching record from the database
            applicantRecords = Database.query(sOQLQueryForApplicantInfo + ' ORDER BY ' + sortFullExp + ' LIMIT ' + iLIMIT + ' OFFSET ' + iOffset);
                                     
            System.debug('@@@@@@value in applicantRecords ' + applicantRecords);
            System.debug('@@@@@@value in pageNumber ' + pageNumber);
            //Populating list of list with value
            listOfListApplication.add(new List<Applicant_Info__c>());
            
            //Integer helpful for list of list population
            Integer i = 0;
    
            //Check for size of list
            if(applicantRecords != null && applicantRecords.size() > 0) {
                
                //Setting Page Size value
                PAGE_SIZE = calculatePageSize(applicantRecords.size());
      
                //loop through Applicant Info records
                for(Applicant_Info__c appInfo : applicantRecords) {
                    
                    //Checking for integer value                
                    if(i == PAGE_SIZE) {
                        
                        //adding new list to the list of list
                        listOfListApplication.add(new List<Applicant_Info__c>());
                        i=0;
                    }
              
                    //adding new list at the index of the list
                    listOfListApplication[listOfListApplication.size()-1].add(appInfo);
                    i++;
                }  
            }
        }
              
    }
    
    public transient list<Campaign_Position__c> campaignRecords{get;set;}
    //public list<Campaign_Position__c> campaignRecords{get;set;}
    public set<String> CampaignIds {get;set;}
    public map<String, list<Campaign_Position__c>> campaignPositionWrapper {get;set;}
    public list<Campaign_Position__c> cposList{get;set;}
    public void doSearchCampaignsForPageSize() {
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        //Calling Method for Serach
        doSearchforCampaigns();
    }
    
    public void doSearchforCampaigns() {
        
        /*New vars */
        campaignRecords = new list<Campaign_Position__c>();
        CampaignIds = new set<String>();
      //  cposList = new list<Campaign_Position__c>();
        system.debug('******** SortExpression: ' + sortExpression);
        system.debug('******** SortDirection: ' + sortDirection);
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
       
        //Reseting total page number
        totalPageNumber = pageNumber + 1;
    
        string DefaultConIP;
        
        if(activeUser != null && activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
            DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
        }
              
        //Check for current user Intrax Id value 
        if(activeUser != null && activeUser.Intrax_Id__c != null) {
        
            datetime tenmonthsBackDate = date.today();
            tenmonthsBackDate = tenmonthsBackDate.addMonths(-10);
            String strtenmonthsBackDate = tenmonthsBackDate.format('yyyy-MM-dd');
        
            //String to hold the dynamic query
            String sOQLQueryForCampaigns = 'SELECT Campaign__c, Campaign__r.Name, Campaign_isActive__c, Name, Campaign_Name__c, Campaign_Type__c, Campaign_StartDate__c, Campaign_EndDate__c, Allocated_Quantity__c, Position__r.Code__c, Position__r.Host_Company_Id__r.name, Position__r.Title__c, Partner_Id__c,'
                                            + ' Expiration_Date__c, Position__r.Gender_Preference__c, Position__r.Language_1_Proficiency__c, Position__r.Engagement_Start__c, Position__r.Engagement_Latest_Start__c, Position__r.Engagement_Earliest_End__c, Position__r.Engagement_End__c,'
                                            + ' Position__r.State__c, Position__r.City__c, Intrax_Program__c'
                                            + ' FROM Campaign_Position__c'
                                            //+ ' WHERE Partner_Id__c = \'001e000000BvfGY\'';
                                            + ' WHERE Campaign_isActive__c = true AND' 
                                            + ' Partner_Id__c = \'' + String.valueOf(activeUser.Contact.AccountId).left(15)  + '\' AND' 
                                            + ' Expiration_Date__c >= ' + strtenmonthsBackDate  + ' AND'; 
            
            //Checking for Name value            
            if (campaignSelected != null && campaignSelected  != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForCampaigns += ' Campaign_Name__c =\'' + campaignSelected + '\' AND';
            }    
            
            //Checking for Default Contact IP
            if(DefaultConIP != null){   
                sOQLQueryForCampaigns = sOQLQueryForCampaigns + ' Intrax_Program__c = \'' + DefaultConIP + '\' AND ' ;                          
            }
            else{
                sOQLQueryForCampaigns += ' Intrax_Program__c = NULL AND';
            }
             
             
             // B-03246
             if(DefaultConIP == 'Work Travel')
             {
              datetime sixmonthsBackDate = date.today();
              sixmonthsBackDate = sixmonthsBackDate.addMonths(-6);
              String strsixmonthsBackDate = sixmonthsBackDate.format('yyyy-MM-dd');
              system.debug('datetime6months back' +strsixmonthsBackDate +sixmonthsBackDate);
              sOQLQueryForCampaigns += 'Campaign_EndDate__c >=' + strsixmonthsBackDate + 'AND'; 
             }
             //B-03246 
             
            system.debug('******* QUERY: ' + sOQLQueryForCampaigns);
            //Processing SOQL String 
            sOQLQueryForCampaigns = processSOQLQueryString(sOQLQueryForCampaigns);
            system.debug('******* QUERY: ' + sOQLQueryForCampaigns);
                       
            //Fetching record from the database
            // B-03246
            /* if(DefaultConIP == 'Work Travel')
              {
               campaignRecords = Database.query(sOQLQueryForCampaigns + ' ORDER BY Campaign_StartDate__c DESC '); 
              }
                //B-03246
            else
            {  */  
            campaignRecords = Database.query(sOQLQueryForCampaigns + ' ORDER BY ' + sortFullExp+' LIMIT 500');
            //}
           
            set<SelectOption> CampaignNames = new set<SelectOption>();
            for(Campaign_Position__c cp : campaignRecords){
                campaignIds.add(cp.Campaign__c);
                system.debug('campaing' +campaignIds);
                system.debug('campaignNames'+campaignNames);
                campaignNames.add(new SelectOption(cp.Campaign_Name__c, cp.Campaign_Name__c));
                system.debug('campaignNames'+campaignNames);
            }
            
            activeCampaigns.AddAll(campaignNames);
            
            system.debug('***** CampaignIds.Size():' +CampaignIds.Size() );
            
            for(String cpId : campaignIds){
                campaignPositionWrapper.put(cpId, new list<Campaign_Position__c>());
            }
            system.debug('***** CampaignPositionWrapper: ' + campaignPositionWrapper);
            String campaignId;
            for(String cp: campaignIds){
                campaignId = cp;
                system.debug('****** getting Campaing id:  ' + campaignId);
            
                //list<Campaign_Position__c> cpList = new list<Campaign_Position__c>();
                
                for(Campaign_Position__c cp2 : campaignRecords){
                    if(campaignId == cp2.Campaign__c){
                        system.debug('***** Adding element to list: ' + cp2.Id);
                        campaignPositionWrapper.get(campaignId).add(cp2);
                      //  cposList.add(cp2);
                        //cpList.Add(cp2);
                    }
                }
                //system.debug('***** cpList.size(): ' + cpList.size());
                //campaignPositionWrapper.put(cp.Id, cpList);
            }
            
            system.debug('***** CampaignPositionWrapper: ' + campaignPositionWrapper.size());
             system.debug('***** CampaignPositionWrapper: ' + campaignPositionWrapper);
            
            //System.debug('@@@@@@value in campainsRecords ' + applicantRecords);
            //System.debug('@@@@@@value in pageNumber ' + pageNumber);
            //Populating list of list with value
                        
        }      
    }
    
    public list<Campaign_Position__c> campaignPosRecords{get;set;}
   /* public void doSearchforCampaignsPositions() {
        
        
        campaignPosRecords = new list<Campaign_Position__c>();
        CampaignIds = new set<String>();
        system.debug('******** SortExpression: ' + sortExpression);
        system.debug('******** SortDirection: ' + sortDirection);
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        //Reseting total page number
        totalPageNumber = pageNumber + 1;
    
        string DefaultConIP;
        
        if(activeUser != null && activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
            DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
        }
              
        //Check for current user Intrax Id value 
        if(activeUser != null && activeUser.Intrax_Id__c != null) {
        
            datetime tenmonthsBackDate = date.today();
            tenmonthsBackDate = tenmonthsBackDate.addMonths(-10);
            String strtenmonthsBackDate = tenmonthsBackDate.format('yyyy-MM-dd');
        
            //String to hold the dynamic query
            String sOQLQueryForCampaigns = 'SELECT Campaign__c, Campaign__r.Name, Campaign_isActive__c, Name, Campaign_Name__c, Campaign_Type__c, Campaign_StartDate__c, Campaign_EndDate__c, Allocated_Quantity__c, Position__r.Code__c, Position__r.Host_Company_Id__r.name, Position__r.Title__c, Partner_Id__c,'
                                            + ' Expiration_Date__c, Position__r.Gender_Preference__c, Position__r.Language_1_Proficiency__c, Position__r.Engagement_Start__c, Position__r.Engagement_Latest_Start__c, Position__r.Engagement_Earliest_End__c, Position__r.Engagement_End__c,'
                                            + ' Position__r.State__c, Position__r.City__c, Intrax_Program__c'
                                            + ' FROM Campaign_Position__c'
                                            //+ ' WHERE Partner_Id__c = \'001e000000BvfGY\'';
                                            + ' WHERE Campaign_isActive__c = true AND' 
                                            + ' Partner_Id__c = \'' + String.valueOf(activeUser.Contact.AccountId).left(15)  + '\' AND' 
                                            + ' Expiration_Date__c >= ' + strtenmonthsBackDate  + ' AND'; 
            
            //Checking for Name value            
            if (campaignSelected != null && campaignSelected  != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForCampaigns += ' Campaign_Name__c =\'' + campaignSelected + '\' AND';
            }    
            
            //Checking for Default Contact IP
            if(DefaultConIP != null){   
                sOQLQueryForCampaigns = sOQLQueryForCampaigns + ' Intrax_Program__c = \'' + DefaultConIP + '\' AND ' ;                          
            }
            else{
                sOQLQueryForCampaigns += ' Intrax_Program__c = NULL AND';
            }
             
             
             // B-03246
             if(DefaultConIP == 'Work Travel')
             {
              datetime sixmonthsBackDate = date.today();
              sixmonthsBackDate = sixmonthsBackDate.addMonths(-6);
              String strsixmonthsBackDate = sixmonthsBackDate.format('yyyy-MM-dd');
              system.debug('datetime6months back' +strsixmonthsBackDate +sixmonthsBackDate);
              sOQLQueryForCampaigns += 'Campaign_EndDate__c >=' + strsixmonthsBackDate + 'AND'; 
             }
             //B-03246 
             
            system.debug('******* QUERY: ' + sOQLQueryForCampaigns);
            //Processing SOQL String 
            sOQLQueryForCampaigns = processSOQLQueryString(sOQLQueryForCampaigns);
            system.debug('******* QUERY: ' + sOQLQueryForCampaigns);
                       
            //Fetching record from the database
            
            campaignPosRecords = Database.query(sOQLQueryForCampaigns + ' ORDER BY ' + sortFullExp);
          
           
            set<SelectOption> CampaignNames = new set<SelectOption>();
            for(Campaign_Position__c cp : campaignPosRecords){
                campaignIds.add(cp.Campaign__c);
                campaignNames.add(new SelectOption(cp.Campaign_Name__c, cp.Campaign_Name__c));
            }
            
            activeCampaigns.AddAll(campaignNames);
            
            system.debug('***** CampaignIds.Size():' +CampaignIds.Size() );
            
            for(String cpId : campaignIds){
                campaignPositionWrapper.put(cpId, new list<Campaign_Position__c>());
            }
            
            String campaignId;
            for(String cp: campaignIds){
                campaignId = cp;
                system.debug('****** getting Campaing id:  ' + campaignId);
            
                list<Campaign_Position__c> cpList = new list<Campaign_Position__c>();
                for(Campaign_Position__c cp2 : campaignPosRecords){
                    if(campaignId == cp2.Campaign__c){
                        system.debug('***** Adding element to list: ' + cp2.Id);
                        campaignPositionWrapper.get(campaignId).add(cp2);
                        //cpList.Add(cp2);
                    }
                }
               
                //campaignPositionWrapper.put(cp.Id, cpList);
            }
            
            system.debug('***** CampaignPositionWrapper: ' + campaignPositionWrapper.size());
            system.debug('***** CampaignPositionWrapper: ' + campaignPositionWrapper);
            
            
            //System.debug('@@@@@@value in campainsRecords ' + applicantRecords);
            //System.debug('@@@@@@value in pageNumber ' + pageNumber);
            //Populating list of list with value
                        
        }      
    }
    
    */
    
       //Searching on the basis of the Page Size for the Matches
    public void doSearchOnTheBasisOfPageSizeForMatch() {
        
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        
        //Calling Method for Serach
        doSearchForMatches();
        
    }
    
    //Method for Searching of Matches   
    public void doSearchForMatches() {
        
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        //Reseting total page number
        totalPageNumber = pageNumber + 1;
            
        //Clear the record from the list saved in the previous hit of Search button
        listOfListMatches.clear();
        
        //Check for null
        if(hostCompany != null) {
            
            //String to hold the dynamic query
            String sOQLQueryForMatch = 'SELECT Id, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,'
                                            + ' Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.name, Status__c,' 
                                            + ' SNK_Indicated__C, Double_Placement_Indicated__c, Parent_Permission__c, Placement_Type__c,' 
                                            + ' Student_Permission__c, SNK_Permission__c, Engagement__r.Name, Participant_Opportunity_Id__r.Name, Match_Type__c,' 
                                            + ' Engagement__r.Status__c, Engagement__r.Intrax_Program__c, Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,Engagement__r.Pre_Program_Trip_Indicated__c,Position_Name__r.Single_No_Children_Indicated__c, Single_No_Children__c, Double_Placement__c,'
                                            + ' (SELECT ID, Match__c, Name FROM Trips__r) FROM Match__c'
                                            //+ ' Where Position_Name__r.Host_Company_Id__c = \'' + hostCompany.ID + '\' AND ';
                                            + ' Where Portal_Contact_Id__r.AccountId = \'' + hostCompany.ID + '\' AND ';
            
            //Checking for Name value
            if (match.Name != null && match.Name != ''){   
                //Modify SOQL query for the Name String
                //IGI 578 (Start)
                string namevar = String.escapeSingleQuotes(match.Name);
                //sOQLQueryForMatch += ' Name Like \'' + match.Name.replaceAll('\\*','%') + '%\' AND ';
                sOQLQueryForMatch += ' Name Like \'' + namevar.replaceAll('\\*','%') + '%\' AND ';
                //IGI 578 (End)
            }
            
            if (IntraxProgramSelected != null ){ 
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForMatch += ' Engagement__r.Intrax_Program__c =\'' + IntraxProgramSelected + '\' AND';
            }
            
            if (SNCIndicatedSelected != null ){
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForMatch += ' Position_Name__r.Single_No_Children_Indicated__c =\'' + SNCIndicatedSelected  + '\' AND'; 
            }
              
            //Checking for Interview_Status__c field value
            if (match.Status__c != null && match.Status__c != ''){
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForMatch += ' Status__c =\'' + match.Status__c + '\' AND';
            }
            
            //Checking for Interview_Status__c field value
            if (EngagementStatusSelected != null ){   
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForMatch += ' Engagement__r.Status__c =\'' + EngagementStatusSelected + '\' AND';
            }
            //Checking for Match Type field value
            if (match.Match_Type__c != null && match.Match_Type__c != ''){      
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForMatch += ' Match_Type__c =\'' + match.Match_Type__c + '\' AND';
            }
            
            
            //Checking for Confirmed Status field value
            /* Not used now
            if (ApexPages.currentPage().getParameters().get('confirmedStatus') != null || ApexPages.currentPage().getParameters().get('confirmedWithNoTripStatus') != null){    
        
                //Modify SOQL query for picklist (picklist act as a string)
                sOQLQueryForMatch += ' Status__c =\'' + 'Confirmed' + '\' AND';
                
            }*/
            
            //Getting Processed SOQL String value
            sOQLQueryForMatch = processSOQLQueryString(sOQLQueryForMatch);
            
            //Fetching record from the database
            List<Match__c> matchRecords = Database.query(sOQLQueryForMatch + 'ORDER BY ' + sortFullExp);
            
            //Checking for Page Parameters
            /* Not used for now
            if (ApexPages.currentPage().getParameters().get('confirmedWithNoTripStatus') != null) { 
                
                //Temporary list for match record
                List<Match__c> matchTempList = new List<Match__c>();
                
                //Loop through match records
                for(Match__c matchWithNoTrip : matchRecords) {
                    
                    //Check for match status and child presence
                    if(matchWithNoTrip.Trips__r == null || matchWithNoTrip.Trips__r.size() == 0) {
                        
                        //Add Match record in the list
                        matchTempList.add(matchWithNoTrip);
                    }
                }
                
                //Checking list for size
                if(matchTempList.size() > 0) {
                    
                    //Overide Match record with temporary records list
                    matchRecords = matchTempList;
                }
            }   
            */
            //Populating list of list with value
            listOfListMatches.add(new List<Match__c>());
            
            Integer i = 0;
    
            //Check for size of list
            if(matchRecords != null && matchRecords.size() > 0) {
                
                //Setting Page Size value
                PAGE_SIZE = calculatePageSize(matchRecords.size());
      
                //Setting Default Value
                matchOptions.add(new SelectOption('None', 'None'));
        
                //loop through Match__c records
                for(Match__c myMatch : matchRecords) {
                
                    //Populating Select List with the Matches Options Options
                    matchOptions.add(new SelectOption(myMatch.Id, myMatch.Name));
                            
                    //Checking for integer value                  
                    if(i == PAGE_SIZE) {
                        
                        //adding new list to the list of list
                        listOfListMatches.add(new List<Match__c>());
                        i=0;
                    }
              
                    //adding new list at the index of the list
                    listOfListMatches[listOfListMatches.size()-1].add(myMatch);
                    i++;
                }
            }     
        }
                
        //Checking for Match Id for null value
        
    } 
    
    /*Method for Processing the sOQLQueryString*/
    
    public string processSOQLQueryString(String sOQLString) {
        
        //String to hold the sOQLQuery String
        String sOQLQueryForsObject;
        
        //Trim String
        sOQLQueryForsObject = sOQLString.trim();
  
        //If query ends with 'AND' 
        if(sOQLQueryForsObject.endsWith('AND')) {
   
            //fetching the value in between two 'AND's
            sOQLQueryForsObject = sOQLQueryForsObject.subString(0, sOQLQueryForsObject.lastIndexOf('AND')); 
        }
        
        //If  the query ends with 'WHERE' i.e. unfilled values     
        if(sOQLQueryForsObject.endsWith('WHERE')){
        
            //fetching the value in between two 'WHERE's
            sOQLQueryForsObject = sOQLQueryForsObject.subString(0, sOQLQueryForsObject.lastIndexOf('WHERE')); 
            
        } 
        
        //Return string
        return sOQLQueryForsObject;
    }
    
    //Method for setting the Page size value based on queried records list
    public Integer calculatePageSize(Integer sizeOfRecordsList) {
        
        Integer pageSizeValue;
        
        //Setting Page Size
        if(Integer.valueOf(limits) < sizeOfRecordsList) {
            pageSizeValue = Integer.valueOf(limits);
        } else {
            pageSizeValue = sizeOfRecordsList;
        }
        
        //Return Page size
        return pageSizeValue;
    }
    
    /*Work around for the Pagination Buttons*/
    
    public void resetPageNumberAndTotalPageNumber() {
        
        //Setting value of the variables
        pageNumber = 0;
        totalPageNumber = 1;
        iTotalPageNumber = 1;
        if(totalCount!= null)
        iTotalPages = Integer.valueOf(Math.Ceil(totalCount/integer.valueOf(limits)));
    }
  
    //method for next button
    public void next(){
      
        //Checking for size of list of list
        if((listOfListApplication.size() >= 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() >= 0 || listOfListAssessment.size() >= 0 )&& itotalPageNumber < iTotalPages) {
                    
            //Increase page number by 1
            totalPageNumber= pageNumber + 1;
            pageNumber+=1;
            totalPageNumber +=1;
            if(itotalPageNumber < iTotalPages)
                itotalPageNumber +=1;
            System.debug('----->NEXT:mapUpdateQuery:'+mapUpdateQuery);    
              
            if(mapUpdateQuery != null && mapUpdateQuery.size()>0){
                for(integer m:mapUpdateQuery.keySet()){
                    if(itotalPageNumber == m){            
                        //set the offset correctly
                        integer mid = (m-1) * integer.valueOf(limits);
                        iOffset = mid ; 
                        System.debug('------>entered next,iOffset:'+iOffset);
                        dosearchforparticipant();
                    }
                }
            }
            
            System.debug('----->NEXT:PageNumber:'+PageNumber);            
            System.debug('----->NEXT:iOffset:'+iOffset);
            System.debug('----->NEXT:itotalPageNumber:'+itotalPageNumber);
        } 
    }
    
    //method for next button
    public void nextForApplications(){
      
        //Checking for size of list of list
        if((listOfListApplication.size() >= 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() >= 0 || listOfListAssessment.size() >= 0 )&& itotalPageNumber < iTotalPages) {
                    
            //Increase page number by 1
            totalPageNumber= pageNumber + 1;
            pageNumber+=1;
            totalPageNumber +=1;
            if(itotalPageNumber < iTotalPages)
                itotalPageNumber +=1;
            System.debug('----->NEXT:mapUpdateQuery:'+mapUpdateQuery);    
              
            if(mapUpdateQuery != null && mapUpdateQuery.size()>0){
                for(integer m:mapUpdateQuery.keySet()){
                    if(itotalPageNumber == m){            
                        //set the offset correctly
                        integer mid = (m-1) * integer.valueOf(limits);
                        iOffset = mid ; 
                        System.debug('------>entered next,iOffset:'+iOffset);
                        dosearch();
                    }
                }
            }
            
            System.debug('----->NEXT:PageNumber:'+PageNumber);            
            System.debug('----->NEXT:iOffset:'+iOffset);
            System.debug('----->NEXT:itotalPageNumber:'+itotalPageNumber);
        } 
    }
    
    //method for first button
    public void first(){
      
        //Checking for size of list of list
        if(listOfListApplication.size() >= 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() > =0 || listOfListAssessment.size() >= 0) {           
            //Increase page number by 1
            pageNumber = 0;
            totalPageNumber = 1;    
            itotalPageNumber = 1; 
            iOffset = 0; 
            resetPageNumberAndTotalPageNumber();
            dosearchforparticipant();                
        } 
    }
     //method for first button in Applications page
    public void firstForApplications(){
      
        //Checking for size of list of list
        if(listOfListApplication.size() >= 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() > =0 || listOfListAssessment.size() >= 0) {
            
            //Increase page number by 1
            pageNumber = 0;
            totalPageNumber = 1;    
            itotalPageNumber = 1; 
            iOffset = 0;                         
            dosearch();   
              
        } 
    }
    
    //method for Last button
    public void last(){
        flag = 'REVERSE_DIR';
        //Checking for size of list of list
        if(listOfListApplication.size() >= 0) {
            
            System.debug('----->LAST:iTotalPages:'+iTotalPages);
            System.debug('----->LAST:pageNumber:'+pageNumber);
            
            pageNumber = iTotalPages - 1;
            totalPageNumber = iTotalPages;
            itotalpageNumber = iTotalPages; //90
            
            System.debug('----->LAST:iTotalPages:'+iTotalPages);
            System.debug('----->LAST:pageNumber:'+pageNumber);
            
            if(itotalPageNumber > integer.valueOf(iLIMIT/integer.valueOf(limits))){//90>80                                                    
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));//90-80
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                system.debug('------>GET INSIDE:totalPageNumber'+totalPageNumber);//10
                pageNumber = totalPageNumber - 1;           
            }            
            
            if(mapOffset != null && mapOffset.size()>0){
                //set the offset correctly
                Integer mapSize = mapOffset.size();
                iOffset = mapOffset.get(mapSize);                                
                dosearch();                                                
            }
            System.debug('----->LAST:iLIMIT:'+iLIMIT);//3
            System.debug('----->LAST:iOffset:'+iOffset);//400
                        
            
        } 
    }
    
    //Method for last button
    public void lastForMatches() {
        
        //Checking for size of list of list
        if(listOfListMatches.size() >= 0) {
         
            //Increase page number by 1
            pageNumber = listOfListMatches.size() -1;
            totalPageNumber = listOfListMatches.size();
            
        }   
    }
    
    //Method for last button
    public void lastForParticipant() {
        flag = 'REVERSE_DIR';       
        //Checking for size of list of list  
        if(listOfListParticipantAndMatch.size() >= 0) {
            
            pageNumber = iTotalPages - 1;
            totalPageNumber = iTotalPages;
            itotalpageNumber = iTotalPages; //90
            
            if(itotalPageNumber > integer.valueOf(iLIMIT/integer.valueOf(limits))){//90>80                                                    
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));//90-80
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                system.debug('------>GET INSIDE:totalPageNumber'+totalPageNumber);//10
                pageNumber = totalPageNumber - 1;           
            }
            
            if(mapOffset != null && mapOffset.size()>0){
                //set the offset correctly
                Integer mapSize = mapOffset.size();
                iOffset = mapOffset.get(mapSize);                                
                dosearchforparticipant();                                                
            }
            System.debug('----->LAST:iLIMIT:'+iLIMIT);//3
            System.debug('----->LAST:iOffset:'+iOffset);//400
             
        }
    }
    
    //Method for last button
    public void lastForAssessment() {
                
        //Checking for size of list of list  
        if(listOfListAssessment.size() >= 0) {
         
            //Increase page number by 1
            pageNumber = listOfListAssessment.size() -1;
            totalPageNumber = listOfListAssessment.size();   
        }
    }
    
    //method for previous button
    public void previous(){
      
        //Check list of list for size
        if(listOfListApplication.size() != 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() >= 0 || listOfListAssessment.size() >= 0) {
           
            //Decrease page number by 1
            if(pageNumber > 0)
            pageNumber-=1;
            totalPageNumber = pageNumber + 1;
            if(itotalPageNumber > 1)
            itotalPageNumber = iTotalPageNumber - 1;
            
            if(mapUpdateQuery != null && mapUpdateQuery.size()>0){
                for(integer m:mapUpdateQuery.keySet()){
                    if(itotalPageNumber == (m-1)){
                        //set the offset correctly                      
                        iOffset = iOffset - iLIMIT ;                         
                        dosearchforparticipant();
                    }
                }
            }
            if(itotalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                System.debug('------>entered reset pageNumber');
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                pageNumber = totalPageNumber - 1;
            }           
            
            System.debug('----->Prev:PageNumber:'+PageNumber);            
            System.debug('----->Prev:iOffset:'+iOffset);
            System.debug('----->Prev:itotalPageNumber:'+itotalPageNumber);            
            
        }
    }
    
    //method for previous for applications button
    public void previousForApplications(){
      
        //Check list of list for size
        if(listOfListApplication.size() != 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() >= 0 || listOfListAssessment.size() >= 0) {
           
            //Decrease page number by 1
            if(pageNumber > 0)
            pageNumber-=1;
            totalPageNumber = pageNumber + 1;
            if(itotalPageNumber > 1)
            itotalPageNumber = iTotalPageNumber - 1;
            
            if(mapUpdateQuery != null && mapUpdateQuery.size()>0){
                for(integer m:mapUpdateQuery.keySet()){
                    if(itotalPageNumber == (m-1)){
                        //set the offset correctly                      
                        iOffset = iOffset - iLIMIT ;                         
                        dosearch();
                    }
                }
            }
            if(itotalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                System.debug('------>entered reset pageNumber');
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                pageNumber = totalPageNumber - 1;
            }           
            
            System.debug('----->Prev:PageNumber:'+PageNumber);            
            System.debug('----->Prev:iOffset:'+iOffset);
            System.debug('----->Prev:itotalPageNumber:'+itotalPageNumber);            
            
        }
    }
    
    /*Workaround for direct page switchung*/
    
    //Method for validation over Page Navigation
    public void pageNavigation(){
                
        /* if user enter more then number ot total page number than set the value last page number in PageNumber. */
        if(iTotalPageNumber >= iTotalPages) {
        //totalPageNumber >= (listOfListParticipantAndMatch.size()) ||   
            //Setting page number to maximum value                      
            iTotalPageNumber = iTotalPages;
            last();
        }        
        else if(itotalPageNumber == 0) {
            
            pageNumber = 0;
            totalPageNumber = 1;
            iTotalPageNumber = 1;
            firstForApplications();
        }
        else {
            
            pageNumber = itotalPageNumber - 1;
            
            System.debug('------->Navigate mapOffset:'+mapOffset);                                     
            System.debug('------->Navigate mapUpdateQuery:'+mapUpdateQuery);
            //81,yes;
            
            integer updateNow=0;
            integer breakNow=0;            
            for(integer i:mapUpdateQuery.keySet()){             
                if(breakNow == 0){
                    if(itotalPageNumber < i){//100<81; 100<161; 100<241                     
                        breakNow=1;
                    }
                System.debug('------->Navigate inside updateNow:'+updateNow);               
                }
                updateNow++;
            }
            if(breakNow ==0){
                updateNow++;
            }            
            System.debug('------->Navigate mapOffset.get(updateNow):'+mapOffset.get(updateNow));
            if(mapOffset.get(updateNow) != null)
                iOffset = mapOffset.get(updateNow);
            else
                iOffset = 0;
                   
            System.debug('------->Navigate iOffset:'+iOffset);
            flag = 'REVERSE_DIR';       
            dosearch(); 
            
        }
    }
    
    //Method for validation over Page Navigation
    public void pageNavigationForMatch(){
    
        /* if user enter more then number ot total page number than set the value last page number in PageNumber. */
        if(totalPageNumber >= (listOfListMatches.size())) {
          
            //Setting page number to maximum value
            pageNumber = listOfListMatches.size() - 1;
            totalPageNumber = listOfListMatches.size();
        }
        
        else if(totalPageNumber == 0) {
            
            pageNumber = 0;
            totalPageNumber = 1;
        }
        else {
            
            pageNumber = totalPageNumber - 1;
        }
    }
    
    //Method for validation over Page Navigation
    public void pageNavigationForParticipant(){
    
        /* if user enter more then number ot total page number than set the value last page number in PageNumber. */
        if(iTotalPageNumber >= iTotalPages) {
                   
            iTotalPageNumber = iTotalPages;
            lastForParticipant();
        } 
        else if(itotalPageNumber == 0) {
            
            pageNumber = 0;
            totalPageNumber = 1;
            iTotalPageNumber = 1;
            first();
        }
        else {
            
            pageNumber = itotalPageNumber - 1;
            
            System.debug('------->Navigate mapOffset:'+mapOffset);              
            
            //1,0; 2,400;
            System.debug('------->Navigate mapUpdateQuery:'+mapUpdateQuery);
            //81,yes;
            
            integer updateNow=0;
            integer breakNow=0;            
            for(integer i:mapUpdateQuery.keySet()){             
                if(breakNow == 0){
                    if(itotalPageNumber < i){//100<81; 100<161; 100<241                     
                        breakNow=1;
                    }
                System.debug('------->Navigate inside updateNow:'+updateNow);               
                }
                updateNow++;
            }
            if(breakNow ==0){
                updateNow++;
            }
            System.debug('------->Navigate updateNow:'+updateNow);
            System.debug('------->Navigate mapOffset.get(updateNow):'+mapOffset.get(updateNow));
            if(mapOffset.get(updateNow) != null)
                iOffset = mapOffset.get(updateNow);
            else
                iOffset = 0;
                   
            System.debug('------->Navigate iOffset:'+iOffset);
            flag = 'REVERSE_DIR';       
            dosearchforparticipant();  
            
            
        }
    }
    
    //Method for validation over Page Navigation
    public void pageNavigationForAssessment(){
    
        /* if user enter more then number ot total page number than set the value last page number in PageNumber. */
        if(totalPageNumber >= (listOfListAssessment.size())) {
          
            //Setting page number to maximum value
            pageNumber = listOfListAssessment.size() - 1;
            totalPageNumber = listOfListAssessment.size();
        }
        
        else if(totalPageNumber == 0) {
            
            pageNumber = 0;
            totalPageNumber = 1;
        }
        else {
            
            pageNumber = totalPageNumber - 1;
        }
    } 
    
    //convert a List<String> into a quoted, comma separated String literal for inclusion in a dynamic SOQL Query
    private String quotedString(List<String> listOfStrings) {
        String newStr = '' ;
        
        //Loop through List of String
        for(String myStr : listOfStrings) {
            
            String str = String.valueOf(myStr);
            newStr += '\'' + str + '\',';
        }
        
        newStr = newStr.lastIndexOf(',') > 0 ? '(' + newStr.substring(0,newStr.lastIndexOf(',')) + ')' : newStr ;
        
        return newStr;
    }
    
    //Method going to be call on when some user will clicks on Add Travel Info button
    public pageReference addTravelInfo (){
        pageReference p = new pageReference ('/apex/pr_pt_travel_visa_new?participantId=' + participant.Id);
        p.setRedirect(true);
        return p;
    }  
    
    //RS Added
     public pageReference openTIPPForm (){
        pageReference p = new pageReference ('/apex/igi_tipp_host_company_info?id=' + match.Id);
        p.setRedirect(true);
        match.Current_TIPP_Editor__c = 'Partner Agent';
        update match;
        return p;
    }         
    
     //RS Added
     public pageReference openTIPPPDFForm (){
        pageReference p = new pageReference ('/apex/igi_tipp_pdf_view?id=' + match.Id);
        p.setRedirect(true);               
        return p;
    }        
    
    //Method for Saving travel information for the Trip record
    public PageReference saveInfoOfTrip() {
        
        //Setting flag value
        showTripAfterSave = true;
        showTravelForm = false;
        // relating new trip to the match / Engagement in context
        
        newTrip.Match__c = match.Id;
        newTrip.Engagement__c = participant.Id;
        
        
        //Insert trip record
        try{
            insert newTrip;
        }catch(Exception e){
            system.debug('******** ' + e);
        }
        
        PageReference p = new PageReference('/apex/pr_pt_travel_visa?participantId=' + participant.Id);
        p.setRedirect(true);
        return p;            
    }
    
    //Method for Updating individual Trip record
    public Pagereference updateIndividualTrip() {
        
        //Insert trip record
        if(trip != null){
            System.debug('@@@@@ value in trip ' + trip);
            update trip;
        }   
        return backToTrips();
              
    }
    
    //Method for Navigating Back to Trip Page
    public Pagereference backToTrips() {
        
        //Setting flag value
        showTripAfterSave = true;
        //Setting Pagereference  
        PageReference travelPageReference = new PageReference('/apex/pr_pt_travel_visa?participantId=' + participant.Id);
        travelPageReference.setRedirect(true);
        return travelPageReference;
    }
    
    //Method for Navigating Back to Partcipants Page
    public Pagereference backToPartcipant() {
        
        //Setting Pagereference  
        PageReference participantPageReference = Page.pr_pt_list;
        participantPageReference.setRedirect(false);
        return participantPageReference;
    }
    
    //Method for Navigating Back to Matches Page
    public Pagereference backToMatches() {
        
        //Setting Pagereference  
        PageReference matchPageReference = Page.Matches;
        matchPageReference.setRedirect(false);
        return matchPageReference;
    }
    
    //Method to deleted family member record 
    public void deleteTrip() {    
        
        //Check for Null
        if(tripIdForDelete != null) {
                 
            //Create a Map
            Map<Id, Trip__c> mapTrip = new Map<Id, Trip__c>(listTrips);
            
            //Delete Trip form database
            Database.delete(Id.valueOf(tripIdForDelete), true);
            
            //Remove from Map
            mapTrip.remove(Id.valueOf(tripIdForDelete));
            
            //Put data back in list
            listTrips = mapTrip.values();   
        }
    }
    
    //method for saving the information for Participant
    public PageReference updateParticipant() {
        system.debug('updating eng');
        //Update participant
        update participant;
        
        //Return value
        return backToPartcipant();
    }
    
     public List<Intrax_Program_Upload__c> getDocList(){
        
        if(ApexPages.currentPage().getParameters().get('participantId')!=null){
           // docType = ApexPages.currentPage().getParameters().get('docType');
        
            //AA 19-02-2014 Ayusa II-Story 633-- New document type added
            return [Select d.document_name__c,d.Document_Type__c, d.Review_Status__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                        where d.engagement__c =: ApexPages.currentPage().getParameters().get('participantId') AND 
                        d.document_type__c IN('Pre-Departure-Orientation-Agreement',
                        'PT-Double-Placement-Agreement', 'NP-Double-Placement-Agreement', 'NP-Double-Placement-Agreement', 'SNK-Placement-Agreement', 'Participant-Eligibility-Form', 'University-Letter', 
                        'University-Letter-Translation', 'Terms-and-Conditions', 'Offer-Document', 'Other' , 'Private-School-Agreement','Tutoring-Agreement', 'Participant-Photo')];
        }
        else return null;
     }
     
     public List<Intrax_Program_Upload__c> getAppDocList(){
        
        if(ApexPages.currentPage().getParameters().get('AppId') != null && ApexPages.currentPage().getParameters().get('participantId') == null)
        {
           if (DocapplicationRecord.Engagement__c != NULL)
           {
                return [Select d.document_name__c,d.Document_Type__c, d.Review_Status__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                        where d.engagement__c =: DocapplicationRecord.Engagement__c AND 
                        d.document_type__c IN('Pre-Departure-Orientation-Agreement',
                        'PT-Double-Placement-Agreement', 'NP-Double-Placement-Agreement', 'NP-Double-Placement-Agreement', 'SNK-Placement-Agreement', 'Participant-Eligibility-Form', 'University-Letter', 
                        'University-Letter-Translation', 'Terms-and-Conditions', 'Offer-Document', 'Other' , 'Private-School-Agreement','Tutoring-Agreement','Participant-Photo')];
           }
           else
           {
                return [Select d.document_name__c,d.Document_Type__c, d.Review_Status__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                        where d.Applicant_Info__c =: ApexPages.currentPage().getParameters().get('AppId') AND 
                        d.document_type__c IN('Pre-Departure-Orientation-Agreement',
                        'PT-Double-Placement-Agreement', 'NP-Double-Placement-Agreement', 'NP-Double-Placement-Agreement', 'SNK-Placement-Agreement', 'Participant-Eligibility-Form', 'University-Letter', 
                        'University-Letter-Translation', 'Terms-and-Conditions', 'Offer-Document', 'Other' , 'Private-School-Agreement','Tutoring-Agreement','Participant-Photo')];
           }
        }
        else return null;
     }
     public List<dsfs__DocuSign_Status__c> getPartDocList(){
        
        if(ApexPages.currentPage().getParameters().get('participantId')!=null){
                
            // Story B-01440
            return [Select   d.Id, d.dsfs__DocuSign_Envelope_ID__c  , d.Signing_Document_Name__c from dsfs__DocuSign_Status__c d
                        where d.engagement__c =: ApexPages.currentPage().getParameters().get('participantId') AND 
                       d.Signing_Document_Name__c in ( 'Work Travel Job Placement' , 'Work Program Terms & Conditions')];
        }
       
        else return null ;
     } 
     
     public List<Notification__c> getVisaSupportLetter(){
        
        if(ApexPages.currentPage().getParameters().get('participantId')!=null){
                
            // Story B-01440
            return [Select   d.Action_URL__c FROM Notification__c d
                        where d.engagement__c =: ApexPages.currentPage().getParameters().get('participantId') and d.type__c='Visa Support Letter' ];
        }
       
        else return null ;
     } 
     
     public PageReference uploadDocs() {
        
        //Update participant
        system.debug('***doctype*****'+doctype);
       // PageReference pg = redirect();
       //PageReference pg= new PageReference('/apex/fileUploaderRedirection');
      // pg.getParameters().put('participantId', ApexPages.currentPage().getParameters().get('participantId'));
      // pg.getParameters().put('doctype', ApexPages.currentPage().getParameters().get('docType'));
        
       //pg.setRedirect(false); 
        //Return value
        return null;
    }
    
    public String loadPhoto(String docGuidParam ){
        
    // Instantiate a new http object 
    Http h = new Http();
    HttpResponse res = new HttpResponse();
    Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
    
    //B-01590
    if(docGuidParam != null){
     loadDoc = [Select Document_service__c from Intrax_Program_Upload__c where document_Guid__c = :docGuidParam ];
     system.debug('*****@@@loadDoc en load(): '+ loadDoc);
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
    HttpRequest req = new HttpRequest();
    req.setMethod('POST'); 
    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
    String body = '';
    if (loadDoc.Document_service__c == 'DS'){
        req.setEndpoint(Constants.documentService+'GetFile');
    }
    else{
        req.setEndpoint(Constants.imageService+'GetFile');
    }
     body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';    
     body = body + docGuidParam;
     if(!test.isRunningTest()) req.setBody(body);
     //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
     Dom.Document docRes = new Dom.Document();
     String returnurl = null;
     res = h.send(req);
     responseXML = res.getBody();
     docRes.load(responseXML);
     List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
     //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
     for (dom.XmlNode node : resnodelist){
        if ( node.getName() == 'result'){
            returnurl = node.getText();
        }
     }
     system.debug('*****@@@returnurl en loadPhoto(): '+ returnurl);
     return returnurl;  
     }
         else return null;                 
  }
      
      
      public PageReference load(){
        
    // Instantiate a new http object 
    Http h = new Http();
    HttpResponse res = new HttpResponse();
    Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
    
    //B-01590
    if(ApexPages.currentPage().getParameters().get('docGuid') != null){
    loadDoc = [Select Document_service__c,Document_GUID__c from Intrax_Program_Upload__c where document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
    HttpRequest req = new HttpRequest();
    req.setMethod('POST'); 
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
     body = body + ApexPages.currentPage().getParameters().get('docGuid');
     if(!test.isRunningTest()) req.setBody(body);
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
     Dom.Document docRes = new Dom.Document();
     String returnurl = null;
     res = h.send(req);
     responseXML = res.getBody();
     docRes.load(responseXML);
     List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
     for (dom.XmlNode node : resnodelist){
        if ( node.getName() == 'result'){
            returnurl = node.getText();
        }
        
        //AA-B-01806 AWS Error handling 
        if(node.getName() == 'error'){
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
     return new PageReference(returnurl);  
     }
     else return null;                  
  }
  
     // Doc Upload  
  public PageReference deletefile(){
        
    // Instantiate a new http object 
    Http h = new Http();
    HttpResponse res = new HttpResponse();
    Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
    
    //B-01590
    if(ApexPages.currentPage().getParameters().get('docGuid') != null){
    loadDoc = [Select Document_service__c,id,Delete_Pending__c from Intrax_Program_Upload__c where document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
    HttpRequest req = new HttpRequest();
    req.setMethod('POST'); 
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
     body = body + ApexPages.currentPage().getParameters().get('docGuid');
     req.setBody(body);
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
     Dom.Document docRes = new Dom.Document();
     string returnurl = null;
     if (!test.isRunningTest()){
         res = h.send(req);
         system.debug('****Res****'+ res);
         responseXML = res.getBody();
           system.debug('****responseXML****'+ responseXML);
         docRes.load(responseXML);
         system.debug('****DocList***'+getDocList());
         /* Comment the following for removing Sharing (AYII-136) */
         loaddoc.Delete_Pending__c=true;
         update loaddoc;
         /* Uncomment the following for removing Sharing (AYII-136)*/
         // delete loaddoc;
         // getDocList();
         /* #AYII-136 */ 
         List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
        for (dom.XmlNode node : resnodelist){
         if ( node.getName() == 'result'){
             returnurl = node.getText();
        }
        }
     }
    return  null;
    //return new PageReference(returnurl);      
    }
    else return null;            
  }      
  
    //method for saving the information for Match
    public PageReference updateMatch() {
        
        //Update participant
        update match;
         
        //Return value
        return backToMatches();
    }
    
    
    public String getDefaultIP(){
        string defaultIP='';
        if(ActiveUser != null && ActiveUser.Intrax_Id__c != null) {       
            if(ActiveUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                if(ActiveUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'AuPairCare')
                    defaultIP = 'AuPairCare';
                else if(ActiveUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Ayusa')
                    defaultIP = 'Ayusa';
                else if(ActiveUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'English and Professional Skills')
                    defaultIP = 'English Academy';
                else if(ActiveUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Internship')
                    defaultIP = 'Global Internships'; 
                else if(ActiveUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Work Travel')
                    defaultIP = 'Work Travel';              
            }
            else
                defaultIP = '';
        }
        return defaultIP;
    }
    
    
    
    public pageReference OpenApplicationsWithSearch(){      
        Pagereference pageRef = new Pagereference('/apex/pr_app_list?AppName='+URLSearchValue);     
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public pageReference OpenParticipantsWithSearch(){      
        Pagereference pageRef = new Pagereference('/apex/pr_pt_list?EngName='+URLSearchValue);      
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    public string URLSearchValue{get;set;}
    Public List<Engagement__c> engList{get;set;}
    Public List<Applicant_Info__c> appList{get;set;}
   
    
    Public void SearchAgain(){
       string DefaultConIP;
       URLSearchValue  = URLSearchValue.replaceAll('[^A-Za-z0-9 .]','');
       
       if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
            DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
        }
       
       engList = New List<Engagement__c>();
       appList = New List<Applicant_Info__c>();
       if(URLSearchValue.length() > 1){
           System.debug('debug::URLSearchValue'+URLSearchValue);
           String searchStr = '*'+URLSearchValue+'*';
           String searchQuery = 'FIND \'' + searchStr + '\' IN Name FIELDS RETURNING  Applicant_Info__c (Id,Name,Application_Level__c,Application_Stage__c,CreatedDate, Submitted_Date__c,Intrax_Program__c,Intrax_Program_Options__c,Engagement__r.Id,Partner_Intrax_Id__c,Type__c WHERE Intrax_Program__c = \'' + DefaultConIP + '\' AND Type__c = \'' + 'Participant' + '\' LIMIT 5),Engagement__c (Id,Name,Status__c,Placement_Status__c,Engagement_Start__c,Engagement_End__c,Intrax_Program__c,Type__c,Partner_Id__c WHERE Intrax_Program__c INCLUDES (\'' + DefaultConIP + '\') AND Type__c = \'' + 'Participant' + '\' LIMIT 5) LIMIT 10';
           List<List <sObject>> searchList = search.query(searchQuery);
           appList = ((List<Applicant_Info__c>)searchList[0]);
           engList  = ((List<Engagement__c>)searchList[1]);                   
           /*if(appList.size() == 0 && engList.size() == 0){
               apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'No results were found.'));
               return;
           }
           */
       }
       else{
           apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters.'));
           return;
       }
    }
    

    //Wrapper class to hold the Engagement record with Match record associated with it
    public class EngagementMatchWrapper {
        
        //Variables
        public Engagement__c engagementRecord {get; set;}
        public Match__c matchRecord {get; set;}
        
        //Calling constructor
        public EngagementMatchWrapper(Engagement__c engagementRecord, Match__c matchRecord) {
            
            this.engagementRecord = engagementRecord;
            this.matchRecord = matchRecord;
        }
    } 
    
    
    
    
    
    public class campPosWrapper {
        
        //Variables
        public Campaign CampRecord {get; set;}
        public Campaign_Position__c CampPosRecord {get; set;}
        
        //Calling constructor
        public campPosWrapper(Campaign CampRecord, Campaign_Position__c CampPosRecord) {
            
            this.CampRecord = CampRecord;
            this.CampPosRecord = CampPosRecord;
        }
    } 
    //B-02412 /Jose - Creating a list on Selection Records (Interviews) for pr_pt_matches  
    public list<Selection__c> selectedInterviews{get{
    
    if(selectedInterviews == null){
        if(ApexPages.currentPage().getParameters().get('participantId') != null){
            list<Selection__c> selectionList = [Select SystemModstamp, Status__c, Recommendation_Type__c, Reason_Other__c, Position__c, OwnerId, Notes__c,
                                                Name,  LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Intrax_Program__c, Interview_Start_Date__c,
                                                Interview_Feedback__c, Interview_Feedback_Options__c, Interview_Extended__c, Interview_End_Date__c, Id, Favorite__c, Engagement__c, CurrencyIsoCode,
                                                CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId, Position__r.Host_Company_Id__r.LastName, Position__r.Name
                                                From Selection__c
                                                where Engagement__c =: ApexPages.currentPage().getParameters().get('participantId') AND (Status__c = 'Active' OR Status__c = 'Inactive')  ];
            
            return selectionList;
            
        }else{
            list<Selection__c> selecListAux = new list<Selection__c>(); 
            return selecListAux;
        }
    }else{
        return selectedInterviews;
    }
    
    }
    set;}
    
    
    //JOSE B-03077
    public set<Id> retrieveEngagementList(String filterType){
        
        set<Id> engagementSet = new set<Id>();
        
        string DefaultConIP;
        if(activeUser != null && activeUser.Intrax_Id__c != null) {                     
            if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                DefaultConIP = activeUser.Contact.PTR_Portal_Intrax_Program_Default__c;                
            }
        }   
        
        if(filterType == 'activeInterEngsParam'){
            list<Engagement__c> selecListEng = [SELECT Id, Name, (SELECT Id, Status__c FROM Selections__r where Status__c = 'Active') 
                                                FROM Engagement__c 
                                                WHERE Status__c = 'Processing' AND Placement_Status__c = 'Not Placed' AND In_Country__c = 'No' AND Type__c = 'Participant' AND Intrax_Program__c INCLUDES ('AuPairCare') ];
            for(Engagement__c eng:selecListEng){
                system.debug('@@@@@eng.Selections__r for Engagement: ' + eng.Name +' /// '+ eng.Selections__r);
                if(eng.Selections__r !=null && eng.Selections__r.size()>0){
                    engagementSet.add(eng.Id);
                }
             }
        
        }else if(filterType == 'interviewFeedbackEngsParam'){
            
            list<Engagement__c> selecListEng = [SELECT Id, Name, (SELECT Id, Status__c, Interview_Feedback__c FROM Selections__r where Interview_Feedback__c != null)
                                                FROM Engagement__c 
                                                WHERE Status__c = 'Processing' AND Placement_Status__c = 'Not Placed' AND Type__c = 'Participant' AND Intrax_Program__c INCLUDES ('AuPairCare') ];
            for(Engagement__c eng:selecListEng){
                system.debug('@@@@@eng.Selections__r for Engagement: ' + eng.Name +' /// '+ eng.Selections__r);
                if(eng.Selections__r !=null && eng.Selections__r.size()>0){
                    engagementSet.add(eng.Id);
                }
             }
        }
        //"New Matches (last 30 days)" – APC Engagement with confirmed match where match date >= {Today – 30 days}
        else if(filterType == 'newMatchesEngsParam'){
            
            date d = system.today().addDays(-30);
            list<Engagement__c> selecListEng = [SELECT Id, Name, (SELECT Id, Name, Engagement__c FROM Matches__r where Status__c = 'Confirmed' AND Start_Date__c >= :d)
                                                FROM Engagement__c 
                                                WHERE Type__c = 'Participant' AND Intrax_Program__c INCLUDES ('AuPairCare') ];
            for(Engagement__c eng:selecListEng){
                system.debug('@@@@@eng.Selections__r for Engagement: ' + eng.Name +' /// '+ eng.Matches__r);
                if(eng.Matches__r !=null && eng.Matches__r.size()>0){
                    engagementSet.add(eng.Id);
                }
             }
        }
        //"Extensions" - APC Engagement  in Processing or Program ready status with related Application with Type = Renewal 
        else if(filterType == 'extensionEngsParam'){
            List<Applicant_Info__c> appList = [SELECT Id,Partner_Intrax_Id__c, Type__c,Intrax_program__c,Application_Level__c, PageStatus_Complete__c, Application_Stage__c, Application_Type__c, CreatedDate,
                                                    Engagement__c, Engagement__r.Name, Engagement__r.Status__c, Engagement__r.Placement_Status__c, Engagement__r.In_Country__c
                                                    FROM Applicant_Info__c 
                                                    WHERE Partner_Intrax_Id__c =: activeUser.Intrax_Id__c AND Type__c = 'Participant' 
                                                    AND Intrax_Program__c =: DefaultConIP AND ( (Application_Level__c = 'Basic' AND Application_Stage__c = 'Submitted')
                                                    OR (Application_Stage__c = 'Declined - Agent') OR (Application_Stage__c = 'Declined') OR (Application_Stage__c = 'Declined - Ayusa')
                                                    OR (Application_Stage__c = 'Declined - Inbound Country')
                                                    OR (Application_Level__c = 'Main' AND Application_Stage__c = 'Submitted')
                                                    OR (Application_Stage__c = 'Accepted') OR (Application_Level__c = 'Main' AND Application_Stage__c = 'Working')) AND Application_Type__c = 'Renewal' ];
                                    
            system.debug('@@@@appList.size = '+ appList.size());                                
            if(appList!=null && appList.size()>0){
            for(Applicant_Info__c ap:appList){
                    if(ap.Engagement__c !=null){
                        engagementSet.add(ap.Engagement__c);
                    }
                }
            }
        
        }
        
        system.debug('@@@@@engagementSet: '+ engagementSet);
        
        return engagementSet;
    }
    //END retrieveEngagementList(String filterType)
    //END JOSE B-03077
   
     

}