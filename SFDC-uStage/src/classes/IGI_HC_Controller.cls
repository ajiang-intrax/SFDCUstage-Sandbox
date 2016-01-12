// ------------------------------------------------------------------------
// Class Definition - Controls all the pages related to the Internships Program (IGI) - HCs side
//      There are 2 different pages: 
//          - IGI_HC_MyMatches, that displays a table with all the matched candidates.
//          - IGI_HC_MatchDetails, that displays the detailed information for a specific candidate selected
//              in the page described above. 
//      HCs have the ability to request an interview for a selected candidate.
// 
// Version#   Date            Author                    Description
// -------------------------------------------------------------------------------------------
// 1.0        Dec-4-2012     Diego Gutierrez          Initial Version
// -------------------------------------------------------------------------------------------

public without sharing class IGI_HC_Controller {

    //Initial Definitions
    
    // Campaign Initialization (Start)
    public string offermsg{get;set;}
    public list<Campaign_Session__c> campaignRecords{get;set;}
    public set<String> CampaignIds {get;set;}
     public boolean customMessage {get;set;}
    public list<String> CampaignIdList {get;set;}
    
    public map<String, list<Campaign_Session__c>> campaignSessionWrapper {get;set;}
    public map<String, list<Match__c>> campaignMatchWrapper {get;set;}
    public string campaignSessionSelected{get;set;}
    public list<SelectOption> activeCampaignsSession{get;set;}
    public string campaignSelected{get;set;}
    public list<SelectOption> activeCampaigns{get;set;}
    public set<ID> CampEngIDs {get;set;}
    public list<Campaign_Session__c> campaignOnlySessions{get;set;}
    
    
    // Campaign Initialization (End)
    
    public boolean confirmselected {get; set;} 
    
    public map<String, String> DocuSignEnvMap {get;set;}
    
    public map<String, String> ProfilePhotoMap {get;set;}
    
    public map<String, String> ProfilePhotoCampMap {get;set;}
    
    public Account accountInfo{get;set;}
    public Match__c matchInfo{get;set;}
    public List<Match__c> matchInfoList{get;set;}
    public Engagement__c engagementInfo{get;set;}
    public List<Position__c> positionInfo{get;set;}
    public list<Experience__c> experienceInfoList{get;set;}
    public list<Essay__c> EssayList{get;set;}
    public Applicant_Info__c applicantInfo;
    public List<Position__c> positionInfoList;
    public list<Position__c> HC_Positions{get;set;}
    public List<Match__c> ConfirmedMatches{get;set;}
    public Account persAccInfo{get;set;}
    public User participantUser{get;set;}
    public Engagement__c PartID {get; set;}
    public String returnURL{get; set;}
    
    public list<Match__c> selectedMatches {get;set;}
    
    public Position__c posSingleInfo{get;set;}
    
    public Trip__c trip {get; set;}
    
    public list<Trip__c> listTrips{get;set;}
    
    
    public Position__c positionDetailInfo{get;set;}
    public list<Accommodation_Option__c> AccOptionInfoList{get;set;}
    
    
    public Position__c positionnew{get;set;}
    public list<Position__c> positionnewlist{get;set;}
    
    /* Not needed in this version
    public Datetime participantTZ{get;set;}
    public Datetime userTZ{get;set;}
    //public Datetime participantTZ{get;set;}
    public Datetime CurrUserTZ{get;set;}
    public DateTime compOffset{get;set;}
    public DateTime compOffset1{get;set;}
    public DateTime compOffset2{get;set;}
    */
    
    public Integer iTotalPages {get; set;}
    public Integer itotalPageNumber {get; set;}
    
    public Decimal total_Match{get;set;}
   // public Decimal totalCount_Match{get;set;}
    
   // public static boolean setConfirmTotalMatch = false;
    public static boolean setTotalMatch = false;
    
    public Integer iLIMIT {get; set;} 
    public Integer iOffset {get; set;}
    
    public Map<Integer,String> mapUpdateQuery{get;set;}
    public Map<Integer,Integer> mapOffset{get;set;}
    
    public Map<String, String> PosInfo_Status {get; set;}
   /* public String getPosInfoStatus(Id id)
    {
        if(PosInfo_Status.get(id) !=null)
        {
                return PosInfo_Status.get(id);
        }
        else
          return null;
    }*/
    public Opportunity OppInfo {get; set;}
    
    public String responseXML{get; set;}
    
    
    PageReference p;
    
    //Host company Agreement
    public Account hAcc{get;set;}
    public List<Contact> list_hca{get;set;}
    public User user; 
    public User activeUser {get;set;}
    public Contact hContact {get;set;}
    public Contact getHCContact()
    {
       return hcontact;
    }
     public User getActUserTZ() {
        return activeuser;
    }
    public String getContactIP()
    {
      return activeuser.contact.Intrax_Programs__c;
    }   
        
    /* Not needed in this version
    public string tz;
    public string Utz;
    
    Decimal offsetGmt;
    string strOffsetGmt ;
    Integer intOffsetGmt;
    integer intOffsetGmt1;
    Decimal decOffsetGmt1;
    integer intOffsetGmt2;
    list<string> UOffsetRanges =new list<string>();
    Decimal UoffsetGmt;
    string UstrOffsetGmt ;
    Integer UintOffsetGmt;
    integer UintOffsetGmt1;
    Decimal UdecOffsetGmt1;
    integer UintOffsetGmt2;
    list<string> OffsetRanges =new list<string>();
    boolean blncompoffset1=false;
    boolean blncompoffset2=false;
    boolean blncompoffset=false;
    boolean blnSaveOffset=false;  
    public  Datetime  strcompOffset{get;set;}    
    */
    //RS Added
     public String docGuid{get;set{docGuid=value;}}
     public String PTId {get; set{PTId = value;}}
    // public String mId {get;set{mId=value;}}
    // Properties  
    
    // Filters and sorting stuff
    public string participantSelected{get;set;}
    
    public string PositionStatusSelected{get;set;}
    public list<SelectOption> PositionStatusValue {get;set;}
    
    public string IntProgramSelected{get;set;}
    public list<SelectOption> MatchIntProgram {get;set;}
    
    public string AccountSelected{get;set;}
    public list<SelectOption> MatchAccount {get;set;}
    
    public string SeasonSelected{get;set;}
    public list<SelectOption> MatchSeason {get;set;}
    
    public string ProgramYearSelected{get;set;}
    public list<SelectOption> MatchProgramYear {get;set;}
    
    public string offerStatusSelected{get;set;}
    public list<SelectOption> MatchOfferStatus {get;set;}
    
    public string matchStatusSelected{get;set;}
    public list<SelectOption> MatchStatus {get;set;}
    
    public string positionNameSelected{get;set;}
    public list<SelectOption> positionsName{get;set;}
    
    public list<SelectOption> SortBy{get;set;}
    public list<SelectOption> SortByDirection{get;set;}
    
    public list<SelectOption> SortBy_Match{get;set;}
    public list<SelectOption> Ratings{get;set;}
    public string ratingSelected{get;set;}
    
    //Integer defined for holding Page Number 
    public Integer pageNumber {get; set;}
    public Integer totalPageNumber {get; set;}
    
    public string mId {get; set{
        mId = value;
        }
    }
    
     public string fpage {get; set{
        fpage = value;
        }
    }
    
    public string CurrentPositionSelected;
    
    public string nextPage{get;set{
        nextPage = value;
        }
    }
     public string Sched{get;set{
        Sched = value;
        }
    } public string noShow{get;set{
        noShow = value;
        }
    }
    public string remove{get;set{
        remove = value;
        }
    }
    
    public string Comp{get;set{
        Comp = value;
        }
    }
    public string CompNoShow{get;set{
        CompNoShow = value;
        }
    }
    public string PartNoShow{get;set{
        PartNoShow = value;
        }
    }
    
    
    
    
    
    
     public string removeMatch{get;set{
        removeMatch = value;
        }
    } 
    /* Not Needed in this version
    public string ReSchedSched{get;set{
        ReSchedSched = value;
        }
    }
    public string IntDate{get;set{
        IntDate = value;
        }
    }
    public string InputInterview{get;set{
        InputInterview= value;
        }
    }
   
     public string detail{get;set{
        detail = value;
        }
    }
     public string MakOff{get;set{
       MakOff = value;
        }
    }
    public string Offer{get;set{
       Offer = value;
        }
    }
     public string rejMatch{get;set{
       rejMatch = value;
        }
    }
     public string reSched{get;set{
       reSched = value;
        }
    }
     public string reSchedule{get;set{
       reSched = value;
        }
    }
    public string initCancel{get;set{
       initCancel = value;
        }
    }
      public string schreSchedule{get;set{
       schreSchedule = value;
        }
    }
    public string schCanc{get;set{
       schCanc = value;
        }
    }
    public string schreSched{get;set{
       schreSched = value;
        }
    }
    public string schCancel{get;set{
       schCancel = value;
        }
    }*/
     public string canc{get;set{
       canc = value;
        }
    }
   /* public string SaveCanc{get;set{
      SaveCanc = value;
        }
    }   
    
    public string SaveSchreSchedule{get;set{
       SaveSchreSchedule = value;
        }}
        public string SaveSchCanc{get;set{
       SaveSchCanc = value;
        }
    }
    */
     public pageReference validator(){
        // For now, we?ll only check here not to enter the primary contact twice in HF apps
        
            
                if(matchInfo.Interview_Request_HC1__c==null || matchInfo.Interview_Request_HC2__c==null || matchInfo.Interview_Request_HC3__c==null)
               {
                system.debug('***here****');
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Dates below for requesting interview');
                ApexPages.addMessage(myMsg);
                 customMessage = true;
          return null;
               }
               else
               {
                 customMessage = false;
            return navigator();   
               }
            
            }
        
        
        
    
    public map<String, string> map_match_rating {get;set;}
    
    public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
      List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
      if (first_val != null) { //if there is a first value being provided
         options.add(new selectOption(first_val, first_val)); //add the first option
      }
      Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
      Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
      Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
      List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
      for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
         options.add(new selectOption(a.getValue(),a.getLabel())); //add the value and label to our final list
      }
      return options; //return the List
    } 
    
    public string getPTR(){
    //Engagement__c eng = [SELECT Id FROM Engagement__c WHERE Id =: matchInfo.Engagement__c];
    //system.debug('**** Engagement Info: ' + eng.Id);
    system.debug('matchInfo***'+matchInfo);
    //if  (matchInfo.Engagement__c !=null) {
    list<Intrax_Program_Upload__c> ipu = [SELECT Id, Document_Guid__c, CreatedDate FROM Intrax_Program_Upload__c 
                                            WHERE Engagement__c =: ApexPages.currentPage().getParameters().get('PTId')
                                            AND Document_Type__c = 'Resume'
                                            order by CreatedDate desc];
    
    if(ipu.size() > 0){
        return ipu[0].Document_Guid__c;
    }
    else  return null;
    //}
  //else return '';
    
  
  }
   public string getMatchResume(){
    //Engagement__c eng = [SELECT Id FROM Engagement__c WHERE Id =: matchInfo.Engagement__c];
    //system.debug('**** Engagement Info: ' + eng.Id);
    //system.debug('matchInfo***'+matchInfo);
    //if  (matchInfo.Engagement__c !=null) {
    list<Intrax_Program_Upload__c> ipu = [SELECT Id, Document_Guid__c, CreatedDate FROM Intrax_Program_Upload__c 
                                            WHERE Match__c =: ApexPages.currentPage().getParameters().get('mId')
                                            AND Document_Type__c = 'Resume'
                                            order by CreatedDate desc];
    
    if(ipu.size() > 0){
        return ipu[0].Document_Guid__c;
    }
    else  return null;
    //}
  //else return '';
    
  
  }
    
  public string getPTResume(){
    //Engagement__c eng = [SELECT Id FROM Engagement__c WHERE Id =: matchInfo.Engagement__c];
    //system.debug('**** Engagement Info: ' + eng.Id);
    system.debug('matchInfo***'+matchInfo);
    if  (matchInfo != NULL && matchInfo.Engagement__c !=null) {
    list<Intrax_Program_Upload__c> ipu = [SELECT Id, Document_Guid__c, CreatedDate FROM Intrax_Program_Upload__c 
                                            WHERE Engagement__c =: matchInfo.Engagement__c
                                            AND Document_Type__c = 'Resume'
                                            order by CreatedDate desc];
    
    if(ipu.size() > 0){
        return ipu[0].Document_Guid__c;
    }
    else  return '';
    }
  else return '';
    
  
  }
   public string engId;
    
    // Default Controller
    public IGI_HC_Controller(){
        //RS Added
         engId = ApexPages.currentPage().getParameters().get('PTId');
         if(engId !=null){         
                                 engagementInfo = [SELECT Intrax_Program__c, Primary_Activity__c, School_Name__c, Major__c, Graduation_Date__c, Other_Languages__c, Flexible_Dates__c, Language_1__c, Language_1_Proficiency__c,Language_2__c, Language_2_Proficiency__c,Language_3__c, Language_3_Proficiency__c, Id, Program_Duration__c, 
                                                    Engagement_Start__c, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, 
                                                    Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc 
                                                    FROM Engagement__c WHERE Id =: engId];  
         }
         //AA-B-01806
        if(ApexPages.currentPage().getUrl()!=null)
         {
        if(ApexPages.currentPage().getUrl().contains('/apex/SiteDocViewer')){
           system.debug('@@@@@ SitedocView');
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, we appear to be unable to locate this file. Document GUID= '+ApexPages.currentPage().getParameters().get('docGuid'));
           ApexPages.addMessage(msg);
        }
         }
       
        
        
        //map_match_rating = new map<String, String>();

        system.debug('***Default Constr mId******'+mId);
        /* if (ApexPages.currentPage().getParameters().get('compOffset') != null){
            compOffset = DateTime.ValueOf(ApexPages.currentPage().getParameters().get('compOffset'));
        }
         if (ApexPages.currentPage().getParameters().get('compOffset1') != null){
            compOffset1 = DateTime.ValueOf(ApexPages.currentPage().getParameters().get('compOffset1'));
        }
         if (ApexPages.currentPage().getParameters().get('compOffset2') != null){
            compOffset2 = DateTime.ValueOf(ApexPages.currentPage().getParameters().get('compOffset2'));
        }*/
          if (ApexPages.currentPage().getParameters().get('mId') != null){
            mId = ApexPages.currentPage().getParameters().get('mId');
        }  
        
        if (ApexPages.currentPage().getParameters().get('fpage') != null){
            fpage = ApexPages.currentPage().getParameters().get('fpage');
        } 
        
        positionnewlist = new list<Position__c>();
        PartID = new Engagement__c();
        selectedMatches = new List<Match__c>();
        
        posSingleInfo = new Position__c();
        
        listTrips = new list<trip__c>();
        
        trip = new trip__c();
        
        activeCampaignsSession = new list<SelectOption>();
        activeCampaignsSession.clear();
        
        activeCampaigns = new list<SelectOption>();
        
        campaignSessionWrapper = new map<String, list<Campaign_Session__c>> ();
        campaignMatchWrapper = new map<String, list<Match__c>> ();
        
        DocuSignEnvMap = new map<String, String>();
        PosInfo_Status = new  Map<String, String>();
        hAcc=new Account(); 
        hContact =new Contact();
        if (ApexPages.currentPage().getParameters().get('ptid') != null)
        {
            PartID = [SELECT Id, Type__c, Status__c, Position_Types__c, Primary_Language__c,Position_Types_Other__c, Name, Location_of_Interest__c, LastModifiedDate, 
                                    Account_Id__r.Intrax_Id__c,Intrax_Region__c, Intrax_Program__c, Intrax_Program_Options__c, Functional_Areas__c, Functional_Areas_Other__c, 
                                    Experience_Summary__c,  Engagement_Start__c, Engagement_End__c, Engagement_Country__c, Description__c, CreatedDate, Account_Id__r.PersonMailingStreet,
                                    Account_Id__c, Account_Id__r.isPersonAccount, Account_Id__r.Name, Account_Id__r.FirstName,Account_Id__r.Middle_Name__pc,Account_Id__r.PersonBirthdate,Account_Id__r.LastName, Account_Id__r.Gender__pc, Account_Id__r.PersonMailingCountry, Account_Id__r.Nationality__pc, 
                                    Account_Id__r.PersonMailingCity, Account_Id__r.PersonMailingState, Account_Id__r.PersonMailingPostalCode, Account_Id__r.Phone,Account_Id__r.Nick_Name__pc,
                                    Gender__c, Program_Start__c, Program_Year__c, Needs_Travel__c, Program_Duration__c, Placement_Status__c,Last_Match_Date__c,Account_Id__r.Skype_ID__pc,
                                    Interests_Top__c, Language_1__c, Language_2__c, language_3__c, Single_No_Children_Indicated__c, Private_High_School_Indicated__c, 
                                    Double_Placement_Indicated__c, Live_With_Pets__c, Number_of_Trips__c,Arrival_Trip_Needed__c,Departure_Trip_Needed__c,Account_Id__r.Birth_City__pc, Account_Id__r.Birth_Country__pc, Account_Id__r.Age__pc,
                                    Account_Id__r.Citizenship__pc,Account_Id__r.Legal_Residence__pc, Education_Program_Type__c,Season__c,Service_Level__c,Graduation_Date__c,Flexible_Dates__c, Compensation_Type__c, Account_Id__r.PersonEmail,Account_Id__r.PersonHomePhone,Account_Id__r.PersonMobilePhone,
                                    School_Name__c,Major__c,Language_1_Proficiency__c,Language_2_Proficiency__c,Language_3_Proficiency__c,
                                    (SELECT ID, Name, Status__c FROM Matches__r), (Select Id, Name From Applicant_Info__r ORDER BY Name) 
                                    From Engagement__c
                                    WHERE ID =: ApexPages.currentPage().getParameters().get('ptid')];
                                    
                       
                                    
               if(ApexPages.currentPage().getParameters().get('matchId') != null) 
               {
               selectedMatches = [Select ID, Name, Intrax_Program__c, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Consider_Other_Positions__c, Match_Date__c,Position_Name__r.Street__c,Position_Name__r.Street_2__c, Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c,Position_Name__r.School_Id__c,Position_Name__r.Owner.Phone, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Position_Name__r.Single_No_Children_Indicated__c, Position_Name__r.Engagement_Start__c, Position_Name__r.Pets_Description__c,
                                Participant_Opportunity_Id__r.Name,  Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c,
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c FROM Match__c 
                                WHERE
                                Id =: ApexPages.currentPage().getParameters().get('matchId')];   
                                
                match = selectedMatches[0];
                
                PosSingleInfo = [SELECT p.sAccount__c, p.Functional_Areas__c,p.Host_Company_Id__r.Name, p.Accepts_Couples__c, p.Accepts_Groups__c, p.Requires_Interview__c, Interview_Type__c, p.Typical_Schedule__c, p.Type__c, p.Tuition__c, p.Title__c, p.Tipped_Position__c, p.Terminated_Count__c, p.Supplies_Required__c, p.Supplies_Cost__c, p.Supervisor_Role__c, p.Street__c, p.Street_2__c, p.Status__c, p.State__c, 
                                    p.Special_Notes__c, p.Smoker_in_Family__c, p.Skills_Required__c, p.Single_No_Children_Indicated__c, p.Session__c, p.Owner.Phone, p.Owner.Name, p.Owner.Email,
                                    p.Second_Job_Allowed__c, p.Season__c, p.School_Model__c, p.School_Category__c, p.Required_Duties__c, p.Religious_Restriction_Indicated__c, p.Regional_Location__c, p.RecordTypeId, p.Projects_of_Interest__c, p.Program_Year__c, p.Postal_Code__c, p.Positions_Sold__c, p.Position_Types__c, p.Position_Types_Other__c, p.Position_Supervisor__c, p.Position_Count__c, p.Pets__c, p.Pets_Description__c, 
                                    p.Personality_Independence__c, p.Pending_Count__c, p.Pay_Rate__c, p.Pay_Notes__c, p.Pay_Frequency__c, p.OwnerId, p.Overtime_Rate__c, p.Overtime_Available__c, 
                                    p.Occupational_Category__c, p.Nationality_Preferences__c, p.Name, p.Minimum_Position_Duration__c, p.Minimum_Age__c, p.Maximum_Hours__c, p.Maximum_Age__c, p.Matching_Notes__c, p.Matched_Count__c, p.Marketing_Notes__c,
                                    p.Languages_Required__c, p.Language_Level__c, p.Language_3__c, p.Language_3_Proficiency__c, p.Language_2__c, p.Language_2_Proficiency__c, p.Language_1__c, p.Language_1_Proficiency__c, p.IsDeleted, p.Intrax_Program__c, p.Intrax_Program_Options__c, p.Interview_Date__c, p.Interests__c, p.Id, p.Host_Opportunity_Id__c, 
                                    p.Host_Company_Id__c, p.Gender_Preference__c,  p.Functional_Areas_Secondary__c, p.Functional_Areas_Other__c, p.Flexible_Dates__c, p.Engagement_Start__c, p.Engagement_Latest_Start__c, p.Engagement_End__c, p.Engagement_Earliest_End__c, p.Employment_Hrs_Wk__c, p.Double_Placement_Indicated__c,p.Description__c, p.Departure_Date_Time__c, 
                                    p.Intrax_Program_Category__c, p.Days_Before_Work__c, p.Country__c, p.Countries_of_Interest__c, p.Countries_Excluded__c, p.Coordinator__c, p.Compensation_Type__c, p.Company_Provided_Housing__c, p.Code__c, p.City__c, p.Arrival_Departure_Phone__c, p.Arrival_Departure_Contact__c, p.Arrival_Date_Time__c 
                                    FROM Position__c p
                                    WHERE p.Id =: match.Position_Name__c];
                                    
               }
               else {     
                
                // IGI - 688 (Start)
                Set<Id> allHCAcctLists = new Set<Id>();
                User activeUserNew = [select Id, Intrax_Id__c, ContactId, LocaleSidKey from User where Id = : userInfo.getUserId()];
                if(activeUserNew.Id != null)
                {
                   Account accountInfoNew = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName, Intrax_Programs__c
                                                FROM Account
                                                WHERE Id IN (SELECT AccountId FROM Contact WHERE Id =: activeUserNew.ContactId)];
                    if(accountInfoNew.Id != null)
                    {
                        //allHCAcctLists = getallAccountIDs(accountInfoNew.Id);
                        allHCAcctLists.add(accountInfoNew.Id);
                
                        string parentRecordNewId = accountInfoNew.Id; 
                        boolean continueLoopNew = true;
                
                        while(continueLoopNew)
                        { 
                            list <account> lstAcctNew = [SELECT ID, ParentId, Name From Account Where ParentId =: parentRecordNewId];
                                    
                            if (lstAcctNew.size() == 0)
                            {
                                 continueLoopNew = false;  //no records returned
                                 continue;
                            }
                            else if(lstAcctNew[0].ParentId == null)  //at the top of the hierarchy, get the Name
                            {
                                continueLoopNew=false;
                                continue;
                            }
                            
                            for (account accvalInsNew: lstAcctNew)
                            {
                                allHCAcctLists.add(accvalInsNew.ID);
                            }
                            parentRecordNewId = lstAcctNew[0].ID;
                        } 
                    }
                }
                if(allHCAcctLists.size() > 0)
                {
                    selectedMatches = [Select ID, Name, Intrax_Program__c, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c,Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c,Current_TIPP_Editor__c,
                                (Select Id, Name, dsfs__DocuSign_Envelope_ID__c From DocuSign_Status__r WHERE Signing_Document_Name__c='Work Travel Job Placement' 
                                AND dsfs__Envelope_Status__c='Completed')
                                FROM Match__c 
                                WHERE Engagement__c =: ApexPages.currentPage().getParameters().get('ptid')
                                AND Position_Name__r.Host_Company_Id__c IN : allHCAcctLists];
                          system.debug('In allHCAcctLists');
                }
                else
                {
                    selectedMatches = [Select ID, Intrax_Program__c, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c,Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c,Current_TIPP_Editor__c, 
                                (Select Id, Name, dsfs__DocuSign_Envelope_ID__c From DocuSign_Status__r WHERE Signing_Document_Name__c='Work Travel Job Placement' 
                                AND dsfs__Envelope_Status__c='Completed')
                                FROM Match__c 
                                WHERE Engagement__c =: ApexPages.currentPage().getParameters().get('ptid')];
                     system.debug('Not in allHCAcctLists');
                }
                // IGI - 688 (End)
                 if (selectedMatches.size() > 0)
                {
                 for(Match__c m: selectedMatches )
                 {
                 List<Position_Info__c> pos = new List<Position_Info__c>();
                 pos=[SELECT Match__c, Status__c FROM Position_Info__c WHERE Match__c =:m.Id limit 1];     
                 system.debug('Inside for loop');
                  if((pos!=null) && (pos.size()>=1)){
                        system.debug('Inside if loop'+ pos[0].Status__c);
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
                System.debug('posinfo done');             
                if (selectedMatches.size() > 0)
                {
                    match = selectedMatches[0];
                    
                    //IGI - 841, 842, 843 (Start)
                    for(Match__c EnvMatch : selectedMatches)
                    {
                        if(EnvMatch.DocuSign_Status__r != null && EnvMatch.DocuSign_Status__r.size() > 0 )
                        {
                            DocuSignEnvMap.put(EnvMatch.id, EnvMatch.DocuSign_Status__r[0].dsfs__DocuSign_Envelope_ID__c);
                        }
                        else
                        {
                            DocuSignEnvMap.put(EnvMatch.id, 'no-Envelope');
                        }
                    }
                    //IGI - 841, 842, 843 (End)
                }
                                    
               }
               
               listTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, 
                                Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__c,
                                Match__r.Engagement__r.Name, Match__r.Engagement__r.Id,Engagement__r.Name,Engagement__c,
                                Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c
                                ,Arrival_Date_Time__c, Departure_Date_Time__c
                                FROM Trip__c
                                WHERE Engagement__c = : ApexPages.currentPage().getParameters().get('ptid') ];
                                
                                
               if(ApexPages.currentPage().getParameters().get('tripId') != null) 
               {
            
                //List to hold the trip records
                List<Trip__c> selectedTrips = new List<Trip__c>();  
            
                //Populating list with selected trip record
                selectedTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, Match__r.Engagement__c,
                            Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__r.Name, 
                            Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c
                            ,Arrival_Date_Time__c, Departure_Date_Time__c
                            FROM Trip__c
                            WHERE ID =: ApexPages.currentPage().getParameters().get('tripId')];
                            
                //Checking for null value
                if(selectedTrips != null && selectedTrips.size() > 0) {
            
                    //Populate Instance with the record
                    trip = selectedTrips[0];
                }
        }
                                
             //Application list
                List<Applicant_Info__c> applicantRecordList = new List<Applicant_Info__c>();
                               
                //Populating list with record 
                applicantRecordList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c FROM Applicant_Info__c WHERE Engagement__c =: ApexPages.currentPage().getParameters().get('ptid') LIMIT 1];
                
                //Checking for null value
                if(applicantRecordList != null && applicantRecordList.size() > 0) 
                {
                      returnURL = IUtilities.getParticipantPhoto(applicantRecordList[0]);
                }
             
        }                 
        
        if (ApexPages.currentPage().getParameters().get('pid') != null)
        {
            positionDetailInfo = [SELECT Id, Name,Intrax_Program_Category__c, Language_1__c,Functional_Areas__c,Street__c,Intrax_Program__c,Positions_Sold__c, Host_Company_Id__c, Postal_Code__c,Host_Company_Id__r.Description, Host_Company_Id__r.Name, Code__c, City__c, Country__c, Gender_Preference__c, Minimum_Age__c, Engagement_Start__c, Engagement_End__c, State__c, Language_1_Proficiency__c,
                                    Engagement_Earliest_End__c, Engagement_Latest_Start__c, Employment_Hrs_Wk__c, Hours_Per_Week__c, Typical_Schedule__c, Description__c, Required_Duties__c, Skills_Required__c, Supplies_Required__c, Supplies_Cost__c,
                                    Host_Company_Id__r.Company_Policies__c, Accepts_Groups__c, Host_Company_Id__r.Area_Information__c, Host_Company_Id__r.Cultural_Opportunities__c,Workers_Comp_Coverage__c, 
                                    Requires_Interview__c, Special_Notes__c, Pay_Rate__c, Tipped_Position__c, Overtime_Available__c, Overtime_Rate__c, Pay_Notes__c, Pay_Frequency__c, Days_Before_Work__c, Second_Job_Allowed__c,
                                    Accepts_Couples__c, Company_Provided_Housing__c, Cultural_Activities__c, Host_Company_Id__r.Recommended_Airport__c, Host_Company_Id__r.Nearest_Bus_Station__c, Host_Company_Id__r.Nearest_Train_Station__c, Host_Company_Id__r.Transportation_To_Company__c,
                                    Host_Company_Id__r.Reporting_Instructions__c, Host_Company_Id__r.Travel_Instructions__c, Host_Company_Id__r.Nearest_Work_Authorization_Office__c, Host_Company_Id__r.Work_Authorization_Instructions__c, 
                                    Host_Company_Id__r.Website, Host_Company_Id__r.Websites_Additional__c, Title__c, Host_Company_Id__r.isPersonAccount,Compensation_Type__c,Pay_Rate_Basis__c
                                    FROM Position__c 
                                    WHERE Id =: ApexPages.currentPage().getParameters().get('pid')];
            
            if(positionDetailInfo != null){
            try{
                AccOptionInfoList = [SELECT Id, Name, Position_Name__c, Host_Arranged__c, Host_Recommended__c, Description__c, Accommodation_Site__c, Accommodation_Site__r.Street__c,
                                        Accommodation_Site__r.Street_2__c, Accommodation_Site__r.State__c, Accommodation_Site__r.City__c, Accommodation_Site__r.Country__c, Accommodation_Site__r.Postal_Code__c, Accommodation_Site__r.Type__c,
                                        Accommodation_Site__r.Features__c, Accommodation_Site__r.Additional_Information__c, Accommodation_Site__r.Features_Description__c, Accommodation_Site__r.Business_Name__c,
                                        Additional_Costs__c, Additional_Costs_Description__c, Account__c,
                                        Transportation_Provided__c, Estimated_Distance__c, Gender_Restriction__c, Estimated_Cost__c, Commute_Cost__c, Commute_Options__c
                                        From Accommodation_Option__c 
                                        where Account__c =: positionDetailInfo.Host_Company_Id__c];
                
            }catch(Exception e){
                system.debug('****** Impossibble to get Accomodation Data for this participant: ' + e);
            }
        } 
        }  
        
        // Getting PT Photo
        /*
        list<String> returnedParams = IUtilities.getParticipantPhoto(engagementInfo.Id);
        responseXML = returnedParams[0];
        returnURL = returnedParams[1];
        system.debug('****** responseXML: ' + responseXML);
        system.debug('****** returnURL:' + returnURL);
        */
        positionInfoList = new List<Position__c>();
        //Init();
    }
    // Initializer
    /*
    public void Init(){
        
    }*/
    
    
    //Searching on the basis of the Page Size for the Applications
    public void doSearchForPageSize() {
        
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        
        //Calling Method for Serach
        doSearch();
        
    }
    
    //Searching on the basis of the Page Size for the Applications
    public void doSearchConfirmForPageSize() {
        
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        
        //Calling Method for Serach
        doSearchConfirmedWithdraw();
        
    }
    
   public void doSearchPositionsForPageSize() {
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        //Calling Method for Serach
        doSearchPositions();
    }
    
     //Instance of Application
    public Match__c match {get; set;}
    public list<Match__c> matchRecords {get;set;}
    
    //List of lists of Applicant Info helpful in Pagination
    public List<List<Match__c>> listOfListMatch {get; set;}
    
    //List of Applicant Info records
    public List<Match__c> listMatch {
       /* get{
            //Return listOfListApplication with its correspondinbg index i.e pageNumber
            return listOfListMatch[pageNumber];
            
        } set; */
        
         get{
            //Return listOfListMatch with its correspondinbg index i.e pageNumber
            system.debug('------>GET pageNumber:'+pageNumber); 
            system.debug('------>GET iTotalpageNumber:'+iTotalpageNumber); 
            system.debug('------>GET listOfListMatch size:'+listOfListMatch.size());
            system.debug('------>GET iLIMIT:'+iLIMIT);//5
            system.debug('------>GET ioffset:'+ioffset);
                        
            if(itotalPageNumber > integer.valueOf(iLIMIT/integer.valueOf(limits))){//2>1                                                   
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));//2-1
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                system.debug('------>GET INSIDE:totalPageNumber'+totalPageNumber);//1
                pageNumber = totalPageNumber - 1;    //0       
            }            
                        
            system.debug('------>GET pageNumber after:'+pageNumber);  
            return listOfListMatch[pageNumber];            
        } set; 
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
    
    Integer PAGE_SIZE;
    
    
    
    
    public void doSearchCampaignsForPageSize() {
        //Calling method for setting Page Number and Total Page Number variables
        resetPageNumberAndTotalPageNumber();
        //Calling Method for Serach
        doSearchforCampaigns();
    }
    
    public void doSearchforCampaigns() {
        
        campaignRecords = new list<Campaign_Session__c>();
        campaignOnlySessions = new list<Campaign_Session__c>();
        campaignOnlySessions.clear();
        
        CampaignIds = new set<String>();
        CampaignIdList = new list<String>();
        
        CampEngIDs = new set<ID>();
        ProfilePhotoCampMap = new map<String, String>();
        ProfilePhotoCampMap.clear();
        
        system.debug('******** SortExpression: ' + sortExpression);
        system.debug('******** SortDirection: ' + sortDirection);
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        campaignSessionWrapper.clear();
        campaignMatchWrapper.clear();
        
        //totalPageNumber = pageNumber + 1;
        
        activeUser = [select Id, Intrax_Id__c, ContactId, LocaleSidKey, Type__c, User_Interests__c from User where Id = : userInfo.getUserId()];
        
              
        //Check for current user Intrax Id value 
        if(activeUser != null && activeUser.Id != null) {
            
            accountInfo = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName, Intrax_Programs__c
                                FROM Account
                                WHERE Id IN (SELECT AccountId FROM Contact WHERE Id =: activeUser.ContactId)];
            
            Set<Id> allHCAccountList = getallAccountIDs(accountInfo.Id);
            
            if (campaignSelected != null && campaignSelected  != '' && campaignSessionSelected != null && campaignSessionSelected  != '')
            {
                list<Campaign_Session__c> campfindSessions = [SELECT Name, Session_Label__c FROM Campaign_Session__c WHERE Campaign__c =: campaignSelected AND Name =: campaignSessionSelected];
                if (campfindSessions.size() == 0)
                {
                    campaignSessionSelected = '';
                }
            }
        
            String sOQLQueryForCampaigns = 'SELECT Campaign__c, Campaign__r.Name, Name,Campaign_Name__c,Partner_Name__c, Campaign_StartDate__c,Campaign_EndDate__c,Campaign_Type__c,Session_Label__c,Session_Start__c,Session_End__c,'
                                            + ' (Select Engagement__c, Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c, Engagement__r.Partner_Account__r.Name, Offer_Status__c, Participant_Id__c,'
                                            + 'Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Participant_Id__r.LastName, Participant_Id__r.FirstName, Participant_Id__r.Citizenship__pc, Interview_Status__c,status__c,Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c,'
                                            + ' CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name,Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,'
                                            + 'Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_company_Id__r.Industry from Matches__r)'
                                            + ' FROM Campaign_Session__c'
                                            + ' WHERE Campaign_isActive__c = true AND' 
                                            + ' Host_Company_Name__c IN :allHCAccountList AND';
                                            
             if (campaignSelected != null && campaignSelected  != ''){      
                sOQLQueryForCampaigns += ' Campaign__c =\'' + campaignSelected + '\' AND';
            }
            
            if (campaignSelected != null && campaignSelected  != '' && campaignSessionSelected != null && campaignSessionSelected  != ''){      
                sOQLQueryForCampaigns += ' Name =\'' + campaignSessionSelected + '\' AND';
            }
            
            system.debug('******* QUERY: ' + sOQLQueryForCampaigns);
            //Processing SOQL String 
            sOQLQueryForCampaigns = processSOQLQueryString(sOQLQueryForCampaigns);
            system.debug('******* QUERY: ' + sOQLQueryForCampaigns);
                        
            //Fetching record from the database
            //campaignRecords = Database.query(sOQLQueryForCampaigns + ' ORDER BY ' + sortFullExp);
            campaignRecords = Database.query(sOQLQueryForCampaigns + ' ORDER BY Campaign_StartDate__c ASC, Session_Start__c ASC');
            
            if (campaignSelected != null && campaignSelected  != '')
            {
                campaignOnlySessions = [SELECT Name, Session_Label__c FROM Campaign_Session__c WHERE Campaign__c =: campaignSelected ORDER BY Session_Start__c ASC];    
            }
            
            //set<SelectOption> CampaignSessionNames = new set<SelectOption>();
            list<SelectOption> CampaignSessionNames = new list<SelectOption>();
            
            //set<SelectOption> CampaignNames = new set<SelectOption>();
            list<SelectOption> CampaignNames = new list<SelectOption>();
            activeCampaignsSession.clear(); 
            
            for(Campaign_Session__c cp : campaignRecords){
                //campaignIds.add(cp.Campaign__c);
                if(campaignIds.add(cp.Campaign__c))
                {
                    CampaignIdList.add(cp.Campaign__c);
                    CampaignNames.add(new SelectOption(cp.Campaign__c, cp.Campaign_Name__c));
                }
                
                //CampaignSessionNames.add(new SelectOption(cp.Name, cp.Session_Label__c));
            }
            
            //if (CampaignSessionNames != null && campaignRecords.size() > 0)
            if (campaignRecords.size() > 0)
            {
                //activeCampaignsSession.AddAll(CampaignSessionNames);
                activeCampaigns.AddAll(CampaignNames);
            }
            
            if(campaignOnlySessions != null && campaignOnlySessions.size() > 0)
            {
                for(Campaign_Session__c SessCP : campaignOnlySessions)
                {
                    CampaignSessionNames.add(new SelectOption(SessCP.Name, SessCP.Session_Label__c));
                }
            }
            if (CampaignSessionNames != null && CampaignSessionNames.size() > 0)
            {
                activeCampaignsSession.AddAll(CampaignSessionNames);
            }
            system.debug('***** CampaignIds.Size():' +CampaignIds.Size() );
            
            for(String cpId : CampaignIdList){
                campaignSessionWrapper.put(cpId, new list<Campaign_Session__c>());
            }
            
            /*IGI 819 - Rating system implmentation*/                        
            map_match_rating = new map<String, String>();
           
            if(campaignRecords!= null){
                
                list<Match__c> CampaignSessionMatches = [SELECT Id, Campaign__c FROM Match__c WHERE Campaign_Session__c IN: CampaignRecords];
                system.debug('******** campaignSessionMatches: ' + campaignSessionMatches.size());
                    
                list<Rating__c> ratingList = [SELECT Id, Score__c, Match__c, Match__r.Participant_Id__r.IsPersonAccount, createdById, LastModifiedDate
                                                FROM Rating__c
                                                WHERE Match__c IN :campaignSessionMatches];
               
                map<String, list<Datetime>> map_match_rating_date = new map<String, list<Datetime>>();
                    
                for(Match__c m : campaignSessionMatches){
                    map_match_rating_date.put(m.Id, new list<Datetime>());
                }   
                
                map<Datetime, string> map_date_score = new map<Datetime, String>();
                for(Rating__c r : ratingList){
                    map_match_rating_date.get(r.Match__c).add(r.LastModifiedDate); 
                    map_date_score.put(r.LastModifiedDate, r.score__c);
                }               
                
                map_match_rating = new map<String, String>();
                
                for(Match__c m : campaignSessionMatches){
                    map_match_rating.put(m.id, '0');
                }
                                                 
                if(ratingList.size() > 0){                      
                    for(Rating__c r: ratingList){
                        // We need to sort by lastModified Date the
                        if(map_match_rating_date.get(r.Match__c).size() > 0){
                            map_match_rating_date.get(r.Match__c).sort();
                            integer map_size = map_match_rating_date.get(r.Match__c).size();
                            
                            map_match_rating.put(r.Match__c, map_date_score.get(map_match_rating_date.get(r.Match__c)[map_size-1]) );
                            //map_match_rating.put(string.valueOf(r.Match__c), r.Score__c);
                        }
                    }
                }
                /* End 819 */
            }          
            
            String campaignId;
            for(String cp: CampaignIdList){
                campaignId = cp;
                system.debug('****** getting Campaing id:  ' + campaignId);
            
                //list<Campaign_Position__c> cpList = new list<Campaign_Position__c>();
                for(Campaign_Session__c cp2 : campaignRecords)
                {
                    campaignMatchWrapper.put(cp2.id, cp2.Matches__r);
                    if(cp2.Matches__r != null)
                    {
                        for(Match__c mtc : cp2.Matches__r)
                        {
                            CampEngIDs.add(mtc.Engagement__c);
                        }
                    }
                    
                    if(campaignId == cp2.Campaign__c){
                        system.debug('***** Adding element to list: ' + cp2.Id);
                        campaignSessionWrapper.get(campaignId).add(cp2);                                      
                    }
                }
                
            }
            
            if(CampEngIDs.size() > 0)
            {
                getCampaignEnggPhotos();
            }
            
            //system.debug('***** campaignSessionWrapper: ' + campaignMatchWrapper);
            
            //system.debug('***** campaignSessionWrapper: ' + campaignSessionWrapper.size());
            
            
            
        }      
    }
    
    public void getCampaignEnggPhotos (){
        list<Engagement__c> piccampengs = new list<Engagement__c>();
        map<String, Applicant_Info__c> CampPicAppToEng = new map<String, Applicant_Info__c>();
        
        piccampengs = [SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name,Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c FROM Engagement__c WHERE id in :CampEngIDs ];
        
        list <Applicant_Info__c> appCampRecordList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount 
                                    FROM Applicant_Info__c 
                                    WHERE Engagement__c IN: CampEngIDs
                                    AND application_stage__c =: 'Accepted'];
                                    
        for(Applicant_Info__c a: appCampRecordList)
        {
            CampPicAppToEng.put(a.Engagement__c, a);
        }
        ProfilePhotoCampMap = IUtilities.getParticipantPhotoList(piccampengs, CampPicAppToEng);
        
    }
    
    public void doSearchpositions() 
    {
    
                
        MatchSeason = new list<SelectOption>();
        MatchSeason.add(new SelectOption('Summer', 'Summer'));
        MatchSeason.add(new SelectOption('Winter', 'Winter'));
        MatchSeason.add(new SelectOption('Spring', 'Spring'));
        
        matchInfo = new Match__c();
            
        MatchOfferStatus = getPickValues(matchInfo, 'Offer_Status__c', null);
        
        OppInfo = new Opportunity();
        MatchProgramYear = getPickValues(OppInfo, 'Program_Year__c', null);
                
            
        system.debug('******** SortExpression: ' + sortExpression);
        system.debug('******** SortDirection: ' + sortDirection);
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        activeUser = [select Id, Intrax_Id__c, ContactId, LocaleSidKey, Type__c, User_Interests__c, Contact.Intrax_Programs__c from User where Id = : userInfo.getUserId()];
        matchInfoList = new List<Match__c>();
        
        if(activeUser.Id != null){
            try{
                accountInfo = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName, Intrax_Programs__c
                                FROM Account
                                WHERE Id IN (SELECT AccountId FROM Contact WHERE Id =: activeUser.ContactId)];
                MatchIntProgram = new list<SelectOption>();
               // MatchIntProgram.add(new SelectOption(accountInfo.Intrax_Programs__c, accountInfo.Intrax_Programs__c));
                //B-01493
                ///MatchIntProgram = getSelectedPicklistValues(accountInfo.Intrax_Programs__c);
                MatchIntProgram = getSelectedPicklistValues(activeUser.Contact.Intrax_Programs__c);
                
                Set<Id> allHCAccountList = getallAccountIDs(accountInfo.Id);
                list <account> allAccountDetails = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName
                                FROM Account
                                WHERE Id IN :allHCAccountList];  
                
                 MatchAccount = new list<SelectOption>();
                            
                 for(account accOne : allAccountDetails)
                 {
                    MatchAccount.add(new SelectOption(accOne.ID, accOne.Name));
                 }
                
                system.debug('************* userInfo.Account_ID: '+ activeUser.Intrax_Id__c);
                system.debug('************* accountInfo.Type: ' + accountInfo.Type);
                system.debug('************* accountInfo.Name: ' + accountInfo.Name);
                system.debug('************* positionInfo: ' + positionInfo);
            }
            catch(Exception e){
                system.debug('*********** ' + e);
            }
            
            if(accountInfo.Type == 'Host Company')
            {
                Set<Id> allHCAccountList = getallAccountIDs(accountInfo.Id);
                
                 list <position__c> posList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c, status__c
                                        FROM Position__c 
                                        WHERE Host_Company_Id__c IN :allHCAccountList];
                 
                 position__c posstVal = new position__c();
                 PositionStatusValue = getPickValues(posstVal, 'status__c', null);
                 
                 //B-01493
                    string IP;
                    List<String> contactIPList = new List<String>();
                    
                    if(activeUser.Contact.Intrax_Programs__c != null){
                        IP = activeUser.Contact.Intrax_Programs__c;
                        contactIPList = IP.split(';');
                    }
                 
                 String sOQLQueryForPosition = 'SELECT Name, Code__c, Host_Company_Id__c, Host_Company_Id__r.name, Title__c, Gender_Preference__c,Language_1__c, Language_1_Proficiency__c, Engagement_Start__c, Engagement_Latest_Start__c, Engagement_Earliest_End__c, Engagement_End__c,'
                                            + ' State__c,Intrax_Program_Category__c,Functional_Areas__c, Compensation_Type__c,City__c, Program_Year__c, Season__c,Intrax_Program__c  FROM Position__c WHERE Host_Company_Id__c IN :allHCAccountList AND';
                 
                 if(contactIPList != null && contactIPList.size()>0)
                        {
                            String slist = '';
                            boolean blnNoneExists=false;  
                            integer len=0;
                            len = contactIPList.size();
                            for(String s : contactIPList) 
                            {
                              if(len==1 && s.equals(''))
                                 blnNoneExists = true;             
                            }     
                            if(!blnNoneExists)
                            {
                               for (String s: contactIPList) 
                               {
                                slist += '\'' + s + '\',';              
                               }
                                slist = slist.substring (0,slist.length() -1);   
                                
                                //Forming the OR condition. starting the braces
                                sOQLQueryForPosition = sOQLQueryForPosition + '(';          
                                //OR conditions                    
                                for(string s:contactIPList){
                                    sOQLQueryForPosition = sOQLQueryForPosition + 'Intrax_Program__c = \'' + s + '\' OR ' ;
                                }       
                                //Removing the last OR
                                sOQLQueryForPosition = sOQLQueryForPosition.subString(0, sOQLQueryForPosition.lastIndexOf('OR'));   
                                //closing the braces                                                                                   
                                sOQLQueryForPosition = sOQLQueryForPosition + ') AND';
                                
                           }         
                        }
                        else
                            sOQLQueryForPosition += ' Intrax_Program__c = NULL AND';
                        
                 //Checking for Name value
                    if (positionNameSelected != null && positionNameSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForPosition += ' Name = \'' + positionNameSelected.replaceAll('\\*','%') + '\' AND ';
                    }
                    
                    
                    if (AccountSelected != null && AccountSelected != '')
                    {      
                        
                        //Modify SOQL query for name
                       // sOQLQueryForMatch += ' Position_Name__r.Name = \'' + positionNameSelected.replaceAll('\\*','%') + '\' AND ';
                       sOQLQueryForPosition += ' Host_Company_Id__c = \'' + AccountSelected + '\' AND ';
                    }
                    
                    //Checking for Season value
                    if (SeasonSelected!= null && SeasonSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForPosition += ' Season__c = \'' + SeasonSelected + '\' AND ';
                    }
                    
                     //Checking for Year value
                    if (ProgramYearSelected!= null && ProgramYearSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForPosition += ' Program_Year__c = \'' + ProgramYearSelected + '\' AND ';
                    }
                    
                    if (IntProgramSelected!= null && IntProgramSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForPosition += ' Intrax_Program__c = \'' + IntProgramSelected + '\' AND ';
                    }
                    if (PositionStatusSelected!= null && PositionStatusSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForPosition += ' Status__c = \'' + PositionStatusSelected + '\' AND ';
                    }
                    
                    
                    
                  system.debug('******* QUERY: ' + sOQLQueryForPosition );
                  //Processing SOQL String 
                  sOQLQueryForPosition = processSOQLQueryString(sOQLQueryForPosition);
                  system.debug('******* QUERY: ' + sOQLQueryForPosition );
                                
                  //Fetching record from the database
                  positionInfo = Database.query(sOQLQueryForPosition + ' ORDER BY ' + sortFullExp);
                  System.debug('@@@@@@value in positionRecords ' + positionInfo);
                  
                  positionsName = new list<SelectOption>();
                  
                  for(Position__c p : posList)
                  {
                      positionsName.add(new SelectOption(p.Name, p.Name));
                  }
                 
            }       
        }
    }
    
     //Method for Searching of Confirmed and Withdrawn matches
    public void doSearchConfirmedWithdraw() {
        
        if (confirmselected != null && confirmselected == true)
        {
            matchStatusSelected = '';
            offerStatusSelected = '';
        }
        
        system.debug('******** SortExpression: ' + sortExpression);
        system.debug('******** SortDirection: ' + sortDirection);
        
        ProfilePhotoMap = new map<String, String>();
        ProfilePhotoMap.clear();
        
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        //Reseting total page number
        totalPageNumber = pageNumber + 1;
    
        //Clear the record from the list saved in the previous hit of Search button
        listOfListMatch.clear();
        
        //listOfListMatch.add(new List<Match__c>());
        
        activeUser = [select Id, Intrax_Id__c, ContactId, LocaleSidKey, Type__c, User_Interests__c, Contact.AccountId, Contact.Intrax_Programs__c from User where Id =: userInfo.getUserId()];
        matchInfoList = new List<Match__c>();
        
        if(activeUser.Id != null){
            try{
                accountInfo = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName, Intrax_Programs__c
                                FROM Account
                                WHERE Id IN (SELECT AccountId FROM Contact WHERE Id =: activeUser.ContactId)];
                        
                
                MatchIntProgram = new list<SelectOption>();
                // MatchIntProgram.add(new SelectOption(accountInfo.Intrax_Programs__c, accountInfo.Intrax_Programs__c));
                //B-01493
                //MatchIntProgram = getSelectedPicklistValues(accountInfo.Intrax_Programs__c);
                MatchIntProgram = getSelectedPicklistValues(activeUser.Contact.Intrax_Programs__c);
                
                system.debug('************* userInfo.Account_ID: '+ activeUser.Intrax_Id__c);
                system.debug('************* accountInfo.Type: ' + accountInfo.Type);
                system.debug('************* accountInfo.Name: ' + accountInfo.Name);
                  // need to make position Info a list!!!    
                positionInfo = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c 
                                        FROM Position__c 
                                        WHERE  Host_Company_Id__c =: accountInfo.Id];
                system.debug('************* positionInfo: ' + positionInfo);
            }
            catch(Exception e){
                system.debug('*********** ' + e);
            }
            
            if(accountInfo.Type == 'Host Company')
            {
                Set<Id> allHCAccountList = getallAccountIDs(accountInfo.Id);
                
                /*positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
                                        FROM Position__c 
                                        WHERE Host_Company_Id__c =: accountInfo.Id];*/
                
                positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
                                        FROM Position__c 
                                        WHERE Host_Company_Id__c IN :allHCAccountList];
                
                system.debug('************* position:' + positionInfoList);
                
                list <account> allAccountDetails = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName
                                FROM Account
                                WHERE Id IN :allHCAccountList];  
                
                 MatchAccount = new list<SelectOption>();
                            
                 //positionName.add(new SelectOption('Test', 'Test'));
                 for(account accOne : allAccountDetails)
                 {
                    MatchAccount.add(new SelectOption(accOne.ID, accOne.Name));
                 }
                
                if(positionInfoList.size() == 0)
                {
                    listOfListMatch.add(new List<Match__c>());
                }
                
                if(positionInfoList.size() == 0)
                {
                    listOfListMatch.add(new List<Match__c>());
                }
                
                if(positionInfoList.size() > 0){
                    List<Match__c> mAux;
                    List<Match__c> mAux2 = new list<Match__c>();
                    
                    Set<Id> aAuxIDs = new Set<Id>();
                    
                    for(Position__c p : positionInfoList)
                    {
                        aAuxIDs.add(p.id);
                    }
                    
                    if (aAuxIDs.size() > 0)
                    {
                         mAux = [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                            Name, Participant_Id__c, status__c,Participant_Id__r.Best_Call_Time__pc, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c        
                             FROM Match__c WHERE Position_Name__c IN : aAuxIDs ];
                             system.debug('************** mAUX: ' + mAux);
                             if(mAux.size() > 0){
                            mAux2.addAll(mAux);
                        }
                    }
                    
                    /*for(Position__c p : positionInfoList){
                        mAux = [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                            Name, Participant_Id__c, status__c,Participant_Id__r.Best_Call_Time__pc, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c        
                             FROM Match__c WHERE Position_Name__c =: p.Id ];
                        system.debug('************** mAUX: ' + mAux);
                                    
                        if(mAux.size() > 0){
                            mAux2.addAll(mAux);
                        }
                        
                    }*/

                    //B-01493
                    string IP;
                    List<String> contactIPList = new List<String>();
                    
                    if(activeUser.Contact.Intrax_Programs__c != null){
                        IP = activeUser.Contact.Intrax_Programs__c;
                        contactIPList = IP.split(';');
                    }
                                        
                    System.debug('*****THE VALUE contactIPList:'+contactIPList);

                    //String to hold the dynamic query
                    String sOQLQueryForMatch = 'SELECT Engagement__c, Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c, Engagement__r.Partner_Account__r.Name, Offer_Status__c, Participant_Id__c, Participant_Id__r.Citizenship__pc, Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Participant_Id__r.LastName, Participant_Id__r.FirstName, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,' +
                                               'Id, Name, Engagement__r.Flexible_Dates__c,Position_Name__r.Host_Company_Id__c,Intrax_Program__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_company_Id__r.Industry ' +
                                               'FROM Match__c WHERE Id IN: mAux2 AND';
                    
                    if(contactIPList != null && contactIPList.size()>0)
                    {
                        String slist = '';
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = contactIPList.size();
                        for(String s : contactIPList) 
                        {
                          if(len==1 && s.equals(''))
                             blnNoneExists = true;             
                        }     
                        if(!blnNoneExists)
                        {
                           for (String s: contactIPList) 
                           {
                            slist += '\'' + s + '\',';              
                           }
                            slist = slist.substring (0,slist.length() -1);   
                            
                            //Forming the OR condition. starting the braces
                            sOQLQueryForMatch = sOQLQueryForMatch + '(';        
                            //OR conditions                    
                            for(string s:contactIPList){
                                sOQLQueryForMatch = sOQLQueryForMatch + 'Position_Name__r.Intrax_Program__c = \'' + s + '\' OR ' ;
                            }       
                            //Removing the last OR
                            sOQLQueryForMatch = sOQLQueryForMatch.subString(0, sOQLQueryForMatch.lastIndexOf('OR'));    
                            //closing the braces                                                                                   
                            sOQLQueryForMatch = sOQLQueryForMatch + ') AND';
                            
                       }         
                    }
                    else
                        sOQLQueryForMatch += ' Position_Name__r.Intrax_Program__c = NULL AND';
                        
                    System.debug('*****THE VALUE sOQLQueryForMatch:'+sOQLQueryForMatch);                
                    
                    
                    if(participantSelected != null && participantSelected != ''){
                        sOQLQueryForMatch += ' (Participant_Id__r.LastName Like \'%' + participantSelected.replaceAll('\\*','%') + '%\' OR  Participant_Id__r.FirstName Like \'%' + participantSelected.replaceAll('\\*','%') + '%\') AND'; 
                    }
                    
                    //Checking for Name value
                    if(confirmselected !=null && confirmselected == true)
                    {
                        sOQLQueryForMatch += ' Status__c IN (\'Confirmed\')' + ' AND ';
                    }
                    
                    if (matchStatusSelected!= null && matchStatusSelected != '')
                    {      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Status__c = \'' + matchStatusSelected + '\' AND ';
                    }
                    /*else
                    {
                        sOQLQueryForMatch += ' Status__c IN (\'Confirmed\',\'Withdrawn\')' + ' AND ';
                    }*/
                    
                    //Checking for Name value
                    if (offerStatusSelected!= null && offerStatusSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Offer_Status__c = \'' + offerStatusSelected + '\' AND ';
                    }
                    
                    //Checking for Name value
                    if (positionNameSelected != null && positionNameSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Name = \'' + positionNameSelected.replaceAll('\\*','%') + '\' AND ';
                    }
                    
                    if (AccountSelected != null && AccountSelected != '')
                    {      
                        
                        //Modify SOQL query for name
                       // sOQLQueryForMatch += ' Position_Name__r.Name = \'' + positionNameSelected.replaceAll('\\*','%') + '\' AND ';
                       sOQLQueryForMatch += ' Position_Name__c IN (SELECT Id FROM Position__c WHERE Host_Company_Id__c =\'' + AccountSelected + '\') AND ';
                    }
                    
                    
                    
                    //Checking for Season value
                    if (SeasonSelected!= null && SeasonSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Season__c = \'' + SeasonSelected + '\' AND ';
                    }
                    
                     //Checking for Year value
                    if (ProgramYearSelected!= null && ProgramYearSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Program_Year__c = \'' + ProgramYearSelected + '\' AND ';
                    }
                    
                    if (IntProgramSelected!= null && IntProgramSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Intrax_Program__c = \'' + IntProgramSelected + '\' AND ';
                    }
                    
                    system.debug('******* QUERY: ' + sOQLQueryForMatch );
                    //Processing SOQL String 
                    sOQLQueryForMatch = processSOQLQueryString(sOQLQueryForMatch);
                    String sOQLQueryForCountMatch = sOQLQueryForMatch;
                    system.debug('******* QUERY: ' + sOQLQueryForMatch );
                                
                    //Fetching record from the database
                    matchRecords = Database.query(sOQLQueryForMatch + ' ORDER BY ' + sortFullExp+ ' LIMIT ' + iLIMIT + ' OFFSET ' + iOffset);
                    System.debug('@@@@@@value in matchRecords ' + matchRecords);
                    System.debug('@@@@@@value in pageNumber ' + pageNumber);
                    //Populating list of list with value
                    
                   if(setTotalMatch==false){
                         List<Match__c> Match_Confirmlist = Database.query(sOQLQueryForCountMatch); 
                         total_Match =  Match_Confirmlist.size();
                     Decimal dBlock=0;
                     Integer iBlock=0;
            
                     if(total_Match != null){
                        iTotalPages = Integer.valueOf(Math.Ceil(total_Match/integer.valueOf(limits)));            
                        dBlock = Math.Ceil(total_Match/iLIMIT);                                      
                     }
                     iBlock = integer.valueOf(dBlock);
            
                     System.debug('------->iTotalPages in constructor:'+iTotalPages);
              
                   //7/5 = 2; block=2; if its 1.something, then block should be 2
                   //limits is 5 (no of records to display)
                    mapOffset = new Map<Integer,Integer>();
            
                    Integer c=0;
                    Integer off = 0;
                      for(integer b=iBlock;b>=1;b--){             
                         c++;                
                        {
                                 mapOffset.put(c,off);
                         off = off + iLIMIT;   
                            }                               
                       }           
                        System.debug('------->mapOffset:'+mapOffset);              
                        System.debug('----->mapOffset size:'+mapOffset.size()); // 1,0; 2,5 (iLimit = 5)
                            
            
                        mapUpdateQuery = new Map<Integer,String>();
                        //totalCount/limits
                        List<Integer> offsetValues = mapOffset.values();
                        for(Integer offset:offsetValues){
                        if(offset != 0){
                        
                        integer o = offset/(integer.valueOf(limits));
                        o++;
                        mapUpdateQuery.put(o,'yes');
                          }
                        }
                        System.debug('------->mapUpdateQuery:'+mapUpdateQuery); //2,yes
                        // i.e., pagenumber,yes            
                         
                        System.debug('------->pageNumber:'+pageNumber);
                        System.debug('------->totalPageNumber:'+totalPageNumber);
                        System.debug('------->itotalPageNumber:'+itotalPageNumber);
                    System.debug('------->total match inside if loop:'+total_Match);
                     
                        
                   }
                    System.debug('@@@@@@Total Match ' + total_Match);
                    listOfListMatch.add(new List<Match__c>());
                    
                    //Integer helpful for list of list population
                    Integer i = 0;
                     system.debug('***** MatchRecords.size(): ' +matchRecords.size());
                    //Check for size of list
                    if(matchRecords != null && matchRecords.size() > 0) {
                        
                        //Setting Page Size value
                        PAGE_SIZE = calculatePageSize(matchRecords.size());
              
                        //loop through Applicant Info records
                        for(Match__c mInfo : matchRecords) {
                            
                            //Checking for integer value                
                            if(i == PAGE_SIZE) {
                                
                                //adding new list to the list of list
                                listOfListMatch.add(new List<Match__c>());
                                i=0;
                            }
                      
                            //adding new list at the index of the list
                            listOfListMatch[listOfListMatch.size()-1].add(mInfo);
                            i++;
                        }
                        
                     system.debug('***** listOfListMatch.size(): ' +listOfListMatch.size());
                    // getParticipantPhotoforCurrentPage();
                    if(setTotalMatch==false){
                     getParticipantPhotoforCurrentPage();
                    }
                    setTotalMatch=true; 
                    }
                }
            }
        }      
    }
    
     //method for first button in Applications page
    public void firstForMatch(){
      
        //Checking for size of list of list
        if(listOfListMatch.size() >= 0 ) {
            
            //Increase page number by 1
            pageNumber = 0;
            totalPageNumber = 1;    
            itotalPageNumber = 1; 
            iOffset = 0;
            SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';                         
            doSearchConfirmedWithdraw(); 
              
        }
        getParticipantPhotoforCurrentPage();
    }
    
    //method for next button
    public void nextForMatch(){
       
        //Checking for size of list of list
        if((listOfListMatch.size() >= 0  ) && itotalPageNumber < iTotalPages) {
                    
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
                        SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';
                        doSearchConfirmedWithdraw();
                    }
                }
            }
            
            System.debug('----->NEXT:PageNumber:'+PageNumber);            
            System.debug('----->NEXT:iOffset:'+iOffset);
            System.debug('----->NEXT:itotalPageNumber:'+itotalPageNumber);
        }
        
        getParticipantPhotoforCurrentPage(); 
        
    }
    
    //Method for last button
    public void lastForMatch() {
        //flag = 'REVERSE_DIR';       
        //Checking for size of list of list  
        if(listOfListMatch.size() >= 0) {
            
            pageNumber = iTotalPages - 1;
            totalPageNumber = iTotalPages;
            itotalpageNumber = iTotalPages; 
            
            if(itotalPageNumber > integer.valueOf(iLIMIT/integer.valueOf(limits))){                                                  
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                system.debug('------>GET INSIDE:totalPageNumber'+totalPageNumber);
                pageNumber = totalPageNumber - 1;           
            }
            
            if(mapOffset != null && mapOffset.size()>0){
                //set the offset correctly
                Integer mapSize = mapOffset.size();
                iOffset = mapOffset.get(mapSize);   
                SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';                             
                doSearchConfirmedWithdraw();                                               
            }
            System.debug('----->LAST:iLIMIT:'+iLIMIT);//5
            System.debug('----->LAST:iOffset:'+iOffset);//5
             
        }
      getParticipantPhotoforCurrentPage();
    } 
    
    public void previousForMatch(){
      
        //Check list of list for size
        if(listOfListMatch.size() >= 0 ) {
           
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
                       SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';                        
                       doSearchConfirmedWithdraw();
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
        getParticipantPhotoforCurrentPage();
    }
    
    
     public void firstlist(){
      
        //Checking for size of list of list
        if(listOfListMatch.size() >= 0 ) {
            
            //Increase page number by 1
            pageNumber = 0;
            totalPageNumber = 1;    
            itotalPageNumber = 1; 
            iOffset = 0; 
            SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';                        
            doSearch(); 
              
        }
        getParticipantPhotoforCurrentPage();
    }
    
    //method for next button
    public void nextlist(){
       
        //Checking for size of list of list
        if((listOfListMatch.size() >= 0  ) && itotalPageNumber < iTotalPages) {
                    
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
                        SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';
                        System.debug('Sort direction***'+sortdirection);
                        doSearch();
                    }
                }
            }
            
            System.debug('----->NEXT:PageNumber:'+PageNumber);            
            System.debug('----->NEXT:iOffset:'+iOffset);
            System.debug('----->NEXT:itotalPageNumber:'+itotalPageNumber);
        }
        
        getParticipantPhotoforCurrentPage(); 
        
    }
    
    //Method for last button
    public void lastlist() {
        //flag = 'REVERSE_DIR';       
        //Checking for size of list of list  
        if(listOfListMatch.size() >= 0) {
            
            pageNumber = iTotalPages - 1;
            totalPageNumber = iTotalPages;
            itotalpageNumber = iTotalPages; 
            
            if(itotalPageNumber > integer.valueOf(iLIMIT/integer.valueOf(limits))){                                                  
                totalPageNumber = itotalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                while(totalPageNumber > (integer.valueOf(iLIMIT/integer.valueOf(limits)))){
                    totalPageNumber = totalPageNumber - (integer.valueOf(iLIMIT/integer.valueOf(limits)));
                }
                
                system.debug('------>GET INSIDE:totalPageNumber'+totalPageNumber);
                pageNumber = totalPageNumber - 1;           
            }
            
            if(mapOffset != null && mapOffset.size()>0){
                //set the offset correctly
                Integer mapSize = mapOffset.size();
                iOffset = mapOffset.get(mapSize); 
                SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';                               
                doSearch();                                               
            }
            System.debug('----->LAST:iLIMIT:'+iLIMIT);//5
            System.debug('----->LAST:iOffset:'+iOffset);//5
             
        }
      getParticipantPhotoforCurrentPage();
    } 
    
    public void previouslist(){
      
        //Check list of list for size
        if(listOfListMatch.size() >= 0 ) {
           
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
                       SortDirection=(sortDirection == 'ASC')? 'DESC' : 'ASC';                       
                       doSearch();
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
        getParticipantPhotoforCurrentPage();
    }
    
    
       
    //Method for Searching of Applicant Info
    public void doSearch() {
        system.debug('******** SortExpression: ' + sortExpression);
        system.debug('******** SortDirection: ' + sortDirection);
        //Building full sort expression with sorting order 'ASC' & 'DESC' with 'NULLS LAST' 
        
        ProfilePhotoMap = new map<String, String>();
        ProfilePhotoMap.clear();
        
        sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + 'NULLS LAST';
        
        //Reseting total page number
        totalPageNumber = pageNumber + 1;
    
        //Clear the record from the list saved in the previous hit of Search button
        listOfListMatch.clear();
        
        //listOfListMatch.add(new List<Match__c>());
        
        activeUser = [select Id, Intrax_Id__c, ContactId, LocaleSidKey, Type__c, User_Interests__c, Contact.AccountId, Contact.Intrax_Programs__c from User where Id = : userInfo.getUserId()];
        matchInfoList = new List<Match__c>();
        
        if(activeUser.Id != null){
            try{
                accountInfo = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName, Intrax_Programs__c
                                FROM Account
                                WHERE Id IN (SELECT AccountId FROM Contact WHERE Id =: activeUser.ContactId)];
                MatchIntProgram = new list<SelectOption>();
                //MatchIntProgram.add(new SelectOption(accountInfo.Intrax_Programs__c, accountInfo.Intrax_Programs__c));
                //B-01493
                //MatchIntProgram = getSelectedPicklistValues(accountInfo.Intrax_Programs__c);
                MatchIntProgram = getSelectedPicklistValues(activeUser.Contact.Intrax_Programs__c);
                
                system.debug('************* userInfo.Account_ID: '+ activeUser.Intrax_Id__c);
                system.debug('************* accountInfo.Type: ' + accountInfo.Type);
                system.debug('************* accountInfo.Name: ' + accountInfo.Name);
                  // need to make position Info a list!!!    
                positionInfo = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c 
                                        FROM Position__c 
                                        WHERE  Host_Company_Id__c =: accountInfo.Id];
                system.debug('************* positionInfo: ' + positionInfo);
            }
            catch(Exception e){
                system.debug('*********** ' + e);
            }
            
            if(accountInfo.Type == 'Host Company'){
                /*positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
                                        FROM Position__c 
                                        WHERE Host_Company_Id__c =: accountInfo.Id];*/
                
                set<ID> allaccountVal  =  getallAccountIDs(accountInfo.Id);                 
                
                positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
                                        FROM Position__c 
                                        WHERE Host_Company_Id__c IN :allaccountVal];
                                        
                system.debug('************* position:' + positionInfoList);
                
                 list <account> allAccountDetails = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName
                                FROM Account
                                WHERE Id IN :allaccountVal];  
                
                 MatchAccount = new list<SelectOption>();
                            
                 //positionName.add(new SelectOption('Test', 'Test'));
                 for(account accOne : allAccountDetails)
                 {
                    MatchAccount.add(new SelectOption(accOne.ID, accOne.Name));
                 }
                
                if(positionInfoList.size() == 0)
                {
                    listOfListMatch.add(new List<Match__c>());
                }
                
                if(positionInfoList.size() > 0){
                    List<Match__c> mAux;
                    List<Match__c> mAux2 = new list<Match__c>();
                    
                    Set<Id> aAuxIDs = new Set<Id>();
                    
                    for(Position__c p : positionInfoList)
                    {
                        aAuxIDs.add(p.id);
                    }
                    
                    if (aAuxIDs.size() > 0)
                    {
                         mAux = [SELECT Engagement__c, Hide_From_Host__c, Hide_From_PT__c, Offer_Status__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                            Name, Participant_Id__c, status__c,Participant_Id__r.Best_Call_Time__pc, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c        
                             FROM Match__c WHERE Position_Name__c IN : aAuxIDs ];
                             system.debug('************** mAUX: ' + mAux);
                             if(mAux.size() > 0){
                            mAux2.addAll(mAux);
                        }
                    }
                                       
                    //B-01493
                    string IP;
                    List<String> contactIPList = new List<String>();
                    
                    if(activeUser.Contact.Intrax_Programs__c != null){
                        IP = activeUser.Contact.Intrax_Programs__c;
                        contactIPList = IP.split(';');
                    }
                                        
                    System.debug('*****THE VALUE contactIPList:'+contactIPList);
            
                    //String to hold the dynamic query
                    String sOQLQueryForMatch = 'SELECT Hide_From_Host__c, Hide_From_PT__c, Engagement__c, Engagement__r.Service_Level__c, Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c, Engagement__r.Partner_Account__r.Name, Offer_Status__c, Participant_Id__c, Participant_Id__r.Citizenship__pc, Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Participant_Id__r.LastName, Participant_Id__r.FirstName, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,' +
                                               'Id, Name, Intrax_Program__c,Engagement__r.Flexible_Dates__c,Position_Name__r.Intrax_Program__c, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_company_Id__r.Industry ' +                                            
                                               'FROM Match__c WHERE Id IN: mAux2 AND ';
                    
                    
                    if(contactIPList != null && contactIPList.size()>0)
                    {
                        String slist = '';
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = contactIPList.size();
                        for(String s : contactIPList) 
                        {
                          if(len==1 && s.equals(''))
                             blnNoneExists = true;             
                        }     
                        if(!blnNoneExists)
                        {
                           for (String s: contactIPList) 
                           {
                            slist += '\'' + s + '\',';              
                           }
                            slist = slist.substring (0,slist.length() -1);   
                            
                            //Forming the OR condition. starting the braces
                            sOQLQueryForMatch = sOQLQueryForMatch + '(';        
                            //OR conditions                    
                            for(string s:contactIPList){
                                sOQLQueryForMatch = sOQLQueryForMatch + 'Position_Name__r.Intrax_Program__c = \'' + s + '\' OR ' ;
                            }       
                            //Removing the last OR
                            sOQLQueryForMatch = sOQLQueryForMatch.subString(0, sOQLQueryForMatch.lastIndexOf('OR'));    
                            //closing the braces                                                                                   
                            sOQLQueryForMatch = sOQLQueryForMatch + ') AND';
                            
                            
                             
                           }  
                                    
                    }
                    else
                        sOQLQueryForMatch += ' Position_Name__r.Intrax_Program__c = NULL AND';
                        
                    System.debug('*****THE VALUE sOQLQueryForMatch:'+sOQLQueryForMatch);                                                            
            
                    if(participantSelected != null && participantSelected != ''){
                        sOQLQueryForMatch += ' (Participant_Id__r.LastName Like \'%' + participantSelected.replaceAll('\\*','%') + '%\' OR  Participant_Id__r.FirstName Like \'%' + participantSelected.replaceAll('\\*','%') + '%\') AND'; 
                    }
                    
                    //Checking for Name value
                    if (matchStatusSelected!= null && matchStatusSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Status__c = \'' + matchStatusSelected + '\' AND ';
                    }
                    else
                    {
                        sOQLQueryForMatch += ' Status__c NOT IN (\'Confirmed\',\'Ended Early\')' + ' AND ';
                    }
                    
                    
                    //Checking for Name value
                    if (offerStatusSelected!= null && offerStatusSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Offer_Status__c = \'' + offerStatusSelected + '\' AND ';
                    }
                    
                    //Checking for Name value
                    if (positionNameSelected != null && positionNameSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Name = \'' + positionNameSelected.replaceAll('\\*','%') + '\' AND ';
                    }
                    
                    if (AccountSelected != null && AccountSelected != '')
                    {      
                        
                        //Modify SOQL query for name
                       // sOQLQueryForMatch += ' Position_Name__r.Name = \'' + positionNameSelected.replaceAll('\\*','%') + '\' AND ';
                       sOQLQueryForMatch += ' Position_Name__c IN (SELECT Id FROM Position__c WHERE Host_Company_Id__c =\'' + AccountSelected + '\') AND ';
                    }
                    
                    //Checking for Season value
                    if (SeasonSelected!= null && SeasonSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Season__c = \'' + SeasonSelected + '\' AND ';
                    }
                    
                     //Checking for Year value
                    if (ProgramYearSelected!= null && ProgramYearSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Program_Year__c = \'' + ProgramYearSelected + '\' AND ';
                    }
                    if (IntProgramSelected!= null && IntProgramSelected != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForMatch += ' Position_Name__r.Intrax_Program__c = \'' + IntProgramSelected + '\' AND ';
                    }
                    
                    /*
                    'SELECT Id, Name, Application_Level__c, Application_Stage__c, Engagement_Start__c, Last_Applicant_Update__c, Intrax_Program__c, Program_Year__c,'
                                                        + ' Program_Duration__c, CreatedDate, LastModifiedDate, Account__c, Type__c, Partner_Intrax_Id__c,Incomplete_Missing_Documents__c,'
                                                        + ' Intrax_Program_Options__c, Airport__c, Arriving_Date__c, Arrival_Time__c, Carrier__c, Carrier_Number__c, Submitted_Date__c,' 
                                                        + ' International_Travel__c, Visa_Category__c, Visa_Type__c, Engagement__c, Engagement__r.Name FROM Applicant_Info__c'
                                                        + ' WHERE Partner_Intrax_Id__c = \'' + activeUser.Intrax_Id__c + '\' AND'
                                                                   // + ' Intrax_Program__c = \'' + 'Ayusa' + '\' AND'
                                                                   //    + ' Intrax_Program_Options__c IN ' + optionsString + ' AND'
                                                                    + ' Type__c = \'' + 'Participant' + '\' AND';    
                                                                    
                    */                                                
                    /*                                                
                    //Checking for Name value
                    if (application.Name != null && application.Name != ''){      
                        
                        //Modify SOQL query for name
                        sOQLQueryForApplicantInfo += ' Name Like \'' + application.Name.replaceAll('\\*','%') + '%\' AND ';
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
                    
                    //Checking for Intrax Program
                               
                    if(IntraxProgramSelected!= null && IntraxProgramSelected != ''){  
                        //Modify SOQL query for picklist (picklist act as a string)
                        sOQLQueryForApplicantInfo += ' Intrax_Program__c =\'' + IntraxProgramSelected + '\' AND';
                    }
                    
                    if(ApplicationLevelSelected!= null && ApplicationLevelSelected != ''){  
                        //Modify SOQL query for picklist (picklist act as a string)
                        sOQLQueryForApplicantInfo += ' Application_Level__c =\'' + ApplicationLevelSelected + '\' AND';
                    }
                    
                    if(ApplicationStageSelected != null && ApplicationStageSelected != ''){  
                        //Modify SOQL query for picklist (picklist act as a string)
                        sOQLQueryForApplicantInfo += ' Application_Stage__c =\'' + ApplicationStageSelected + '\' AND';
                    }
                    
                    //Criteria for filtering out the value for working status 
                    if (ApexPages.currentPage().getParameters().get('workingStatus') != null){      
                
                        //Modify SOQL query for picklist (picklist act as a string)
                        sOQLQueryForApplicantInfo += ' Application_Stage__c =\'' + 'Working' + '\'';
                    }
                    
                    //Criteria for filtering out the values on the basis of comfirm status and level value as 'Main'
                    if (ApexPages.currentPage().getParameters().get('submittedStatus') != null){      
                
                        //Modify SOQL query for picklist (picklist act as a string)
                        sOQLQueryForApplicantInfo += ' Application_Level__c =\'' + 'Main' + '\' AND';
                        
                        //Modify SOQL query for picklist (picklist act as a string)
                        sOQLQueryForApplicantInfo += ' Application_Stage__c =\'' + 'Submitted' + '\'';
                        
                    }
                    */
                    system.debug('******* QUERY: ' + sOQLQueryForMatch );
                    String query_wt;
                    String query_igi;
                    List<String> cont_list=new List<String>{'Work Travel','Internship'};
                    for(string s:contactIPList){
                      if(s.equals('Work Travel')){
                              
                               //Modify SOQL query for service level check
                         query_wt = '(Intrax_Program__c=\'Work Travel\' AND Engagement__r.Service_Level__c !=\'Independent\' AND Status__c!=\'Withdrawn\')';                           
                         }
                      if(s.equals('Internship')){
                           
                               //Modify SOQL query for service level check
                          query_igi= '( Intrax_Program__c =\'Internship\' AND Hide_From_Host__c=False AND Status__c NOT IN (\'Saved\',\'Recommended\')' + ' AND Status__c  IN (\'Requested\',\'Applied\',\'Withdrawn\') )';
                            
                          }
                     }  
                   if(contactIPList!=null && contactIPList.size()==1){
                    for(string s:contactIPList){
                          if(s.equals('Work Travel')){
                              
                               //Modify SOQL query for service level check
                               sOQLQueryForMatch += query_wt;
                            
                             }
                             if(s.equals('Internship')){
                           
                               //Modify SOQL query for service level check
                               sOQLQueryForMatch += query_igi;
                            
                             }
                           }  
                       }
                    if(contactIPList.equals(cont_list))
                    {
                       sOQLQueryForMatch += '('+ query_wt + ' OR '+query_igi+')';  
                    }
                    
                    //Processing SOQL String 
                    sOQLQueryForMatch = processSOQLQueryString(sOQLQueryForMatch);
                    system.debug('******* QUERY: ' + sOQLQueryForMatch );
                     String sOQLQueryForCountMatch = sOQLQueryForMatch;
                                                
                    //Fetching record from the database
                    if(SortExpression == 'Rating'){
                        //list<Match__c> mRecordsAux = Database.query(sOQLQueryForMatch);// + ' ORDER BY ' + sortFullExp);
                        list<Match__c> mRecordsAux = Database.query(sOQLQueryForMatch +' LIMIT ' + iLIMIT + ' OFFSET ' + iOffset);
                        
                        list<Rating__c> ratingList = [SELECT Id, Score__c, createdById, Match__c FROM Rating__c WHERE Match__c IN :mRecordsAux];
                        system.debug('******** ratings: ' + ratingList.size());
                        
                        
                        map<String, String> map_match_score =  new map<String, String>();
                        for(Match__c m : mRecordsAux){
                            map_match_score.put(m.id, '0');
                        }
                        
                         if(ratingList.size() > 0){                     
                            for(Rating__c r: ratingList){
                                   map_match_score.put(string.valueOf(r.Match__c), r.Score__c);
                            }
                        }
                        
                        
                        list<Match__c> mAux3 = new List<Match__c>();
                        if(sortDirection == 'ASC'){
                            for(decimal i=0;i<=5;i+=0.5){
                                system.debug('+++++ Evaluating value: ' +i);
                                for(Match__c m: mRecordsAux){
                                    //for(String str: map_match_score.keySet()){
                                        system.debug('****** Evaluating element: ' + m.Id + ' / Score: ' +  map_match_score.get(m.Id));
                                        if(decimal.ValueOf(map_match_score.get(m.Id)) == i){
                                            system.debug('****** Saved!');
                                            mAux3.add(m);
                                        }
                                    //}
                                }
                            }
                        }else{
                            for(decimal i=5;i>=0;i-=0.5){
                                system.debug('+++++ Evaluating value: ' +i);
                                for(Match__c m: mRecordsAux){
                                    system.debug('****** Evaluating element: ' + m.Id + ' / Score: ' +  map_match_score.get(m.Id));
                                    if(decimal.ValueOf(map_match_score.get(m.Id)) == i){
                                        system.debug('****** Saved!');
                                        mAux3.add(m);
                                    }
                                }
                            }
                        }
                        
                        matchRecords = mAux3.deepClone(true,false, false);
                        
                        for(Match__c m1: matchRecords){
                            system.debug('******* Id: ' + m1.Id + ' / Score: ' + map_match_score.get(m1.Id));
                        }
                        
                        
                    }
                    else{
                        //matchRecords = Database.query(sOQLQueryForMatch + ' ORDER BY ' + sortFullExp);
                       matchRecords = Database.query(sOQLQueryForMatch + ' ORDER BY ' + sortFullExp+ ' LIMIT ' + iLIMIT + ' OFFSET ' + iOffset);
                    }
                    
                    /*IGI 819 - Rating system implementation*/
                    list<Rating__c> ratingList = [SELECT Id, Score__c, Match__c, createdById, LastModifiedDate
                                                    FROM Rating__c
                                                    WHERE Match__c IN: matchRecords];
                    
                    map<String, list<Datetime>> map_match_rating_date = new map<String, list<Datetime>>();
                    
                    for(Match__c m : matchRecords){
                        map_match_rating_date.put(m.Id, new list<Datetime>());
                    }   
                    
                    map<Datetime, string> map_date_score = new map<Datetime, String>();
                    for(Rating__c r : ratingList){
                        map_match_rating_date.get(r.Match__c).add(r.LastModifiedDate); 
                        map_date_score.put(r.LastModifiedDate, r.score__c);
                    }               
                    
                    map_match_rating = new map<String, String>();
                    
                    for(Match__c m : matchRecords){
                        map_match_rating.put(m.id, '0');
                    }
                                                     
                    if(ratingList.size() > 0){                      
                        for(Rating__c r: ratingList){
                            //if(userInfo.getUserId() == r.CreatedById){
                            // We need to add the last modified one
                            if(map_match_rating_date.get(r.Match__c).size() > 0){
                                map_match_rating_date.get(r.Match__c).sort();
                                integer map_size = map_match_rating_date.get(r.Match__c).size();
                                
                                map_match_rating.put(r.Match__c, map_date_score.get(map_match_rating_date.get(r.Match__c)[map_size-1]) );
                                //map_match_rating.put(string.valueOf(r.Match__c), r.Score__c);
                            }
                        }
                    }
                    
                    if (ratingSelected!= null && ratingSelected != ''){
                        list<Match__c> matchRatedList = new list<Match__c>(); 
                        for(Match__c m : matchRecords){
                            if(map_match_rating.get(m.Id) == ratingSelected){
                                matchRatedList.add(m);
                            }
                        }   
                        matchRecords = matchRatedList.deepClone(true, false, false);                                        
                    }
                   
                    system.debug('***** MatchRecords.size(): ' +matchRecords.size());
                    
                     if(setTotalMatch==false){
                         List<Match__c> Match_list = Database.query(sOQLQueryForCountMatch); 
                         total_Match =  Match_list.size();
                     Decimal dBlock=0;
                     Integer iBlock=0;
            
                     if(total_Match != null){
                        iTotalPages = Integer.valueOf(Math.Ceil(total_Match/integer.valueOf(limits)));            
                        dBlock = Math.Ceil(total_Match/iLIMIT);                                      
                     }
                     iBlock = integer.valueOf(dBlock);
            
                     System.debug('------->iTotalPages in constructor:'+iTotalPages);
              
                   //7/5 = 2; block=2; if its 1.something, then block should be 2
                   //limits is 5 (no of records to display)
                    mapOffset = new Map<Integer,Integer>();
            
                    Integer c=0;
                    Integer off = 0;
                      for(integer b=iBlock;b>=1;b--){             
                         c++;                
                        {
                                 mapOffset.put(c,off);
                         off = off + iLIMIT;   
                            }                               
                       }           
                        System.debug('------->mapOffset:'+mapOffset);              
                        System.debug('----->mapOffset size:'+mapOffset.size()); // 1,0; 2,5 (iLimit = 5)
                            
            
                        mapUpdateQuery = new Map<Integer,String>();
                        //totalCount/limits
                        List<Integer> offsetValues = mapOffset.values();
                        for(Integer offset:offsetValues){
                        if(offset != 0){
                        
                        integer o = offset/(integer.valueOf(limits));
                        o++;
                        mapUpdateQuery.put(o,'yes');
                          }
                        }
                        System.debug('------->mapUpdateQuery:'+mapUpdateQuery); //2,yes
                        // i.e., pagenumber,yes            
                         
                        System.debug('------->pageNumber:'+pageNumber);
                        System.debug('------->totalPageNumber:'+totalPageNumber);
                        System.debug('------->itotalPageNumber:'+itotalPageNumber);
                    System.debug('------->total match inside if loop:'+total_Match);
                     
                        
                   }
                    System.debug('@@@@@@Total Match ' + total_Match);
                   
                    
                    //Populating list of list with value
                    listOfListMatch.add(new List<Match__c>());
            
                    //Integer helpful for list of list population
                    Integer i = 0;
            
                    //Check for size of list
                    if(matchRecords != null && matchRecords.size() > 0) {
                        
                        //Setting Page Size value
                        PAGE_SIZE = calculatePageSize(matchRecords.size());
                        system.debug('****** Page Size: ' + PAGE_SIZE);
              
                        //loop through Applicant Info records
                        for(Match__c mInfo : matchRecords) {
                            
                            //Checking for integer value                
                            if(i == PAGE_SIZE) {
                                
                                //adding new list to the list of list
                                listOfListMatch.add(new List<Match__c>());
                                i=0;
                            }
                      
                            //adding new list at the index of the list
                            listOfListMatch[listOfListMatch.size()-1].add(mInfo);
                            i++;
                        }  
                     system.debug('***** listOfListMatch.size(): ' +listOfListMatch.size());
                    // getParticipantPhotoforCurrentPage();
                    if(setTotalMatch==false){
                     getParticipantPhotoforCurrentPage();
                    }
                    setTotalMatch=true; 
                      
                    }
                }
            }
        }      
    }
    
    
     public void getParticipantPhotoforCurrentPage(){
        system.debug('***Page number***'+pageNumber);
        List<Match__c> PiclistMatch =  listMatch;
        system.debug('***PiclistMatch***'+PiclistMatch);
        list<Engagement__c> picengs = new list<Engagement__c>();
        Set<ID> picengIDs = new Set<ID>();
        map<String, Applicant_Info__c> PicmapAppToEng = new map<String, Applicant_Info__c>();
        
        for(Match__c pmat : PiclistMatch)
        {
            picengIDs.add(pmat.Engagement__c); 
        }
        if(picengIDs!=null && picengIDs.size()>0)
        {
        picengs = [SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name,Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c 
                    FROM Engagement__c WHERE id in :picengIDs ];
        
        list <Applicant_Info__c> appRecordList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount 
                                    FROM Applicant_Info__c 
                                    WHERE Engagement__c IN: picengIDs
                                    AND application_stage__c =: 'Accepted'];
                                    
        for(Applicant_Info__c a: appRecordList)
        {
            PicmapAppToEng.put(a.Engagement__c, a);
        }
        ProfilePhotoMap = IUtilities.getParticipantPhotoList(picengs, PicmapAppToEng);
        }
        system.debug('******picengs**********'+picengs);
        
        system.debug('******PicmapAppToEng**********'+PicmapAppToEng);
        
        system.debug('******ProfilePhotoMap**********'+ProfilePhotoMap);
    }
    
  
    public PageReference update_matchInfo(){
        try{
            update matchInfo;
        }catch(Exception e){
            system.debug('******* Impossible to update matchInfo: ' + matchInfo.Id);
        }
        PageReference p = new PageReference ('/apex/igi_hc_match_details');
        p.getParameters().put('mid', matchInfo.Id);
        if (ApexPages.currentPage().getParameters().get('fpage') != null)
        {
            p.getParameters().put('fpage', ApexPages.currentPage().getParameters().get('fpage'));
        }
        p.setRedirect(true);
        return p;
    }
    
     
    //method for next button
   /* public void previous(){
      
        //Check list of list for size
        //if(listOfListApplication.size() != 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() >= 0 || listOfListAssessment.size() >= 0) {
         if(listofListMatch.size() != 0){  
            //Decrease page number by 1
            pageNumber-=1;
            totalPageNumber = pageNumber + 1;
        }
        getParticipantPhotoforCurrentPage();
    }*/
    
    /*Workaround for direct page switchung*/
    
    //Method for validation over Page Navigation
    public void pageNavigation(){
         
        /* if user enter more then number ot total page number than set the value last page number in PageNumber. */
        if(totalPageNumber >= (listOfListMatch.size())) {
          
            //Setting page number to maximum value
            pageNumber = listOfListMatch.size() - 1;
            totalPageNumber = listOfListMatch.size();
        }
        
        else if(totalPageNumber == 0) {
            
            pageNumber = 0;
            totalPageNumber = 1;
        }
        else {
            
            pageNumber = totalPageNumber - 1;
        }
    }
    
    //method for next button
   /* public void next(){
      
        //Checking for size of list of list
        //if(listOfListApplication.size() >= 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() >= 0 || listOfListAssessment.size() >= 0) {
        if(listofListMatch.size() >= 0){ 
            //Increase page number by 1
            totalPageNumber= pageNumber + 1;
            pageNumber+=1;
            totalPageNumber +=1;
        } 
        getParticipantPhotoforCurrentPage();
    }
    
    //method for first button
    public void first(){
      
        //Checking for size of list of list
        //if(listOfListApplication.size() >= 0 || listOfListMatches.size() >= 0 || listOfListParticipantAndMatch.size() > =0 || listOfListAssessment.size() >= 0) {
        if(listOfListMatch.size() >=0 ){ 
            //Increase page number by 1
            pageNumber = 0;
            totalPageNumber = 1;
        } 
        getParticipantPhotoforCurrentPage();
    }
    
    //method for Last button
    public void last(){
      
        //Checking for size of list of list
        if(listOfListMatch.size() >= 0) {
         
            //Increase page number by 1
            pageNumber = listOfListMatch.size() -1;         
            totalPageNumber = listOfListMatch.size();
            system.debug('****** Last page size(): ' + pageNumber + ' / ' + totalPageNumber);
            
        } 
        getParticipantPhotoforCurrentPage();
    }
    
    //Method to disable next button 
    public Boolean getNextButtonDisabled(){
 
        //disable when Index of the page is equal to total number of index OR WHEN THERE 
        return (pageNumber == listOfListMatch.size() || pageNumber == listOfListMatch.size()-1);
    }
    
    //Method to disable previous button 
    public Boolean getPreviousButtonDisabled(){
 
        //or when multiplication of currenjt page no. and page size is > then applicantInfo list 
        return (pageNumber == listOfListMatch.size() || pageNumber == 0);
    }
    */
    //Method to disable next button 
    public Boolean getNextButtonDisabledForMatch(){
 
        return (itotalPageNumber >= iTotalPages);
        
    }
    
    //Method to disable previous button 
    public Boolean getPreviousButtonDisabledForMatch(){
 
        return (iTotalPageNumber == 1);
       
    }
    public Boolean getLastButtonDisabledForMatch(){
 
        return (iTotalPageNumber == iTotalPages);
       
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
    
    
    public void resetPageNumberAndTotalPageNumber() {
        
        //Setting value of the variables
        pageNumber = 0;
        totalPageNumber = 1;
         iTotalPageNumber = 1;
        if(total_Match!= null)
        iTotalPages = Integer.valueOf(Math.Ceil(total_Match/integer.valueOf(limits)));
        
    }
    
     public void checkLoginWithMatchSearch() {
        
        //Method for Login validation and then Applications Searching
        checkLogin();
        doSearch();
    }
    
    public void checkLoginWithConfirmMatchSearch() {
        
        checkLogin();
        doSearchConfirmedWithdraw();
      //getParticipantPhotoforCurrentPage();
       
    }
    
    public void checkLoginWithPositionSearch() {
        
        checkLogin();
        doSearchPositions();
    }
    
    public void checkLoginWithCampaignSearch() {
        //Method for Login validation and then Applications Searching
        checkLogin();
        doSearchforCampaigns();
    }
    
    public pageReference checkLogin(){
        system.debug('****** UserName' + userInfo.getUserName());
        system.debug('****** Usertype' + userInfo.getUserType());
        if(userInfo.getUserType() == 'Guest'){
            pageReference p = Page.AppEngine_SiteLoginPage;
            p.setRedirect(true);
            return p;
        }else return null;
        
    }
    public String getCurrentPositionSelected() {
        positionnewlist = [SELECT ID, Name, Code__c, Host_Company_Id__c, Host_Company_Id__r.name, Title__c, Gender_Preference__c, Language_1_Proficiency__c, Engagement_Start__c, Engagement_Latest_Start__c, Engagement_Earliest_End__c, Engagement_End__c,State__c, City__c, Program_Year__c, Season__c,Intrax_Program__c FROM Position__c WHERE ID = :CurrentPositionSelected ];
        if(positionnewlist.size() >0)
        {
            positionnew = positionnewlist[0];
        }
        return CurrentPositionSelected;
    }
                    
    public void setCurrentPositionSelected(String CurrentPositionSelected) { 
        this.CurrentPositionSelected = CurrentPositionSelected; 
    }
    
    public PageReference reload() {
        return null;
    }
    
    public void reloadPosition() {
        positionnewlist = [SELECT ID, Name, Code__c, Host_Company_Id__c, Host_Company_Id__r.name, Title__c, Gender_Preference__c, Language_1_Proficiency__c, Engagement_Start__c, Engagement_Latest_Start__c, Engagement_Earliest_End__c, Engagement_End__c,State__c, City__c, Program_Year__c, Season__c,Intrax_Program__c FROM Position__c WHERE ID = :CurrentPositionSelected ];
        if(positionnewlist.size() >0)
        {
            positionnew = positionnewlist[0];
        }
    }
    
    public pageReference offerPosition(){
        system.debug('We are in... ' + mId);
        Match__c m = [SELECT Id, Offer_Status__c, Start_Date__c, End_Date__c, Position_Name__c, Position_Name__r.Name, Engagement__c, Engagement__r.Name FROM Match__c WHERE Id =: mId];
        system.debug('***** CurrentPosition: ' + CurrentPositionSelected);
        system.debug('***** PrevPosition: ' + m.Position_Name__c);
        
       
         if(m != null){
         Engagement__c eng = [SELECT Id, Name, Account_Id__c, Opportunity_Id__c, Engagement_Start__c,Engagement_End__c FROM Engagement__c WHERE Id =: m.Engagement__c];
         
           if (matchInfo.Start_Date__c == null || matchInfo.Start_Date__c < eng.Engagement_Start__c || matchInfo.Start_Date__c > eng.Engagement_End__c || matchInfo.End_Date__c < eng.Engagement_Start__c ||  matchInfo.End_Date__c > eng.Engagement_End__c)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date and End Date must be within ' + string.valueOf(eng.Engagement_Start__c) + ' and ' + string.ValueOf(eng.Engagement_End__c));
                ApexPages.addMessage(msg);
                return null;
            }
           
            if (matchInfo.Start_Date__c > matchInfo.End_Date__c)
            {   
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date must be less than End Date');
                ApexPages.addMessage(msg);
                return null;
            }
        
         }
        
        if(m != null){
            if ((m.Position_Name__c != CurrentPositionSelected) || (m.Start_Date__c != matchInfo.Start_Date__c) || (m.End_Date__c != matchInfo.End_Date__c))
            {
                m.Offer_Status__c = '';
                //chgEnvID = '1';
                if (CurrentPositionSelected != null && CurrentPositionSelected != '')
                {
                    Position__c SelPosName = [SELECT Id, Name FROM Position__c WHERE Id =: CurrentPositionSelected];
                    m.Name = (SelPosName.Name + ' - ' + m.Engagement__r.Name).left(80);
                }
                List<dsfs__DocuSign_Status__c> dstoDelete = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Match__c = :mId AND Signing_Document_Name__c='Work Travel Job Placement'];
                if(dstoDelete != NULL && dstoDelete.size() > 0)
                {
                    for (dsfs__DocuSign_Status__c dstoDeleteSingle : dstoDelete){
                        delete dstoDeleteSingle;
                    }
                }
                
                list<Notification__c> ObjNotfToDelete = new List<Notification__c>();
                  ObjNotfToDelete = [Select n.Type__c, n.SystemModstamp, n.Subject__c, n.Status__c, n.Position__c, n.Portal_URL__c, n.Partner_Email__c, n.OwnerId, n.Name, n.Match__c, n.MatchStartDate__c, n.LastModifiedDate, n.LastModifiedById, n.IsDeleted, n.Intrax_Program__c, n.Id, n.Engagement__c, n.CurrencyIsoCode, n.CreatedDate, n.CreatedById, n.Contact__c, n.ConnectionSentId, n.ConnectionReceivedId, n.Body__c, n.Account__c, n.AccountId__c From Notification__c n where n.match__c =:m.Id and n.engagement__c = :m.Engagement__c and Type__c =: 'Offer Extended' and status__c != 'Confirmed'];
                  if(ObjNotfToDelete!=null && ObjNotfToDelete.size()>0){
                    for (Notification__c notifyDel : ObjNotfToDelete){
                        delete notifyDel;
                    }
                  }
            }
            //m.Offer_Status__c = 'Offered';
            m.Start_Date__c = matchInfo.Start_Date__c;
            m.End_Date__c = matchInfo.End_Date__c;
            m.Position_Name__c = CurrentPositionSelected;
            try{
                update m;
            }catch(Exception e){
                system.debug('****** Impossible to reassign Position offer: ' +e);
            }
        }
        
        //PageReference p = new PageReference('/apex/C_Matches');
        PageReference p = new PageReference('/apex/WT_Job_Agreement?id='+mId);
        p.setRedirect(true);
        return p;
    }
    
    public pageReference offerIGIPosition(){
        system.debug('We are in... ' + mId);
        Match__c m = [SELECT Id, Offer_Status__c, Start_Date__c, End_Date__c, Position_Name__c, Position_Name__r.Name, Engagement__c, Engagement__r.Name FROM Match__c WHERE Id =: mId];
        system.debug('***** CurrentPosition: ' + CurrentPositionSelected);
        system.debug('***** PrevPosition: ' + m.Position_Name__c);
        if(m != null){
            m.Offer_Status__c = 'Offered';
            update m;
        }
        
        PageReference p = new PageReference('/apex/C_Matches');
        p.setRedirect(true);
        return p;
    }
    
    public pageReference rejectCandidate(){
        Match__c m = [SELECT Id, Offer_Status__c, status__c, Engagement__c FROM Match__c WHERE Id =: mId];
        
        if(m != null){
            
            list<Notification__c> ObjNotfToDelete = new List<Notification__c>();
                  ObjNotfToDelete = [Select n.Type__c, n.SystemModstamp, n.Subject__c, n.Status__c, n.Position__c, n.Portal_URL__c, n.Partner_Email__c, n.OwnerId, n.Name, n.Match__c, n.MatchStartDate__c, n.LastModifiedDate, n.LastModifiedById, n.IsDeleted, n.Intrax_Program__c, n.Id, n.Engagement__c, n.CurrencyIsoCode, n.CreatedDate, n.CreatedById, n.Contact__c, n.ConnectionSentId, n.ConnectionReceivedId, n.Body__c, n.Account__c, n.AccountId__c From Notification__c n where n.match__c =:m.Id and n.engagement__c = :m.Engagement__c and Type__c =: 'Offer Extended' and status__c != 'Confirmed'];
                  if(ObjNotfToDelete!=null && ObjNotfToDelete.size()>0){
                    for (Notification__c notifyDel : ObjNotfToDelete){
                        delete notifyDel;
                    }
                  }
                  
                List<dsfs__DocuSign_Status__c> dstoDelete = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Match__c = :m.Id AND Signing_Document_Name__c='Work Travel Job Placement'];
                if(dstoDelete != NULL && dstoDelete.size() > 0)
                {
                    for (dsfs__DocuSign_Status__c dstoDeleteSingle : dstoDelete){
                        delete dstoDeleteSingle;
                    }
                }
            
            //Commented for MT#140
            m.Offer_Status__c = 'Not Offered';
            m.status__c= 'Withdrawn';
            m.Hide_From_Host__c=true;
            update m;
            
            
        }
        
        PageReference p = new PageReference('/apex/C_Matches');
        
        if (ApexPages.currentPage().getParameters().get('fpage') != null && ApexPages.currentPage().getParameters().get('fpage') == 'hevents')
        {
            p = new PageReference('/apex/Hiring_Event');
        }
        
        p.setRedirect(true);
        return p;
    }
    
    public PageReference navigator(){
        
        
        if (ApexPages.currentPage().getParameters().get('nextPage') != null){
            p = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        }
         system.debug('***next page******'+ApexPages.currentPage().getParameters().get('nextPage'));
        // PageReference P = ApexPages.currentPage();
        system.debug('***mId******'+mId);
         system.debug('****page ref*****'+p);
         /* Not needed in this version
        if (mId != null && (ApexPages.currentPage().getParameters().get('SaveMatch')==null && ApexPages.currentPage().getParameters().get('rejMatch')==null && ApexPages.currentPage().getParameters().get('NoAttend')==null  && ApexPages.currentPage().getParameters().get('Offer')==null && ApexPages.currentPage().getParameters().get('removeMatch')==null && ApexPages.currentPage().getParameters().get('noShow')==null) && ( ApexPages.currentPage().getParameters().get('reSched')!=null || ApexPages.currentPage().getParameters().get('initCancel')!=null || ApexPages.currentPage().getParameters().get('MakOff')!=null || ApexPages.currentPage().getParameters().get('schreSched')!=null || ApexPages.currentPage().getParameters().get('schCancel')!=null || ApexPages.currentPage().getParameters().get('Sched')!=null || ApexPages.currentPage().getParameters().get('detail')!=null || ApexPages.currentPage().getParameters().get('remove')!=null || ApexPages.currentPage().getParameters().get('ReSchedSched')!=null)){
              system.debug('****page ref*****'+p);
               P.getParameters().put('mId', mId);
                system.debug('****page ref*****'+p);
        }*/
        
            system.debug('**************** DETAIL PAGE');
            system.debug('**************** mId'+mId);
            system.debug('**************** param mid'+ApexPages.currentPage().getParameters().get('mId'));
            //system.debug('**************** SaveMatch'+ApexPages.currentPage().getParameters().get('SaveMatch'));
       
        
             if(ApexPages.currentPage().getParameters().get('canc')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                 ReSchedule(mId);   
           
            }
              if(ApexPages.currentPage().getParameters().get('Comp')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                 saveMatchInfo();  
                
            }
              if(ApexPages.currentPage().getParameters().get('CompNoShow')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                 saveMatchInfo();  
           
            }
              if(ApexPages.currentPage().getParameters().get('PartNoShow')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                 saveMatchInfo();  
                  
            }
           /* Not needed in this version
             if(ApexPages.currentPage().getParameters().get('ReSchedSched')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                ReSchedSchedMatchInfo(mId);       
              
           
            }
             if(ApexPages.currentPage().getParameters().get('reSchedule')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                ReSchedule(mId);       
             
           
            }
              if(ApexPages.currentPage().getParameters().get('SaveCanc')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                CancelMatch(mId);       
             
           
            }
               if(ApexPages.currentPage().getParameters().get('SaveSchreSchedule')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                ReSchedule(mId);       
             
           
            }
              if(ApexPages.currentPage().getParameters().get('SaveSchCanc')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                CancelMatch(mId);       
             
           
            }*/
            
            if(ApexPages.currentPage().getParameters().get('removeMatch')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                removeMatch(mId);       
                      
           
            }
                if(ApexPages.currentPage().getParameters().get('SaveMatch')=='true')
            {
               
                saveMatchInfo();       
               
             }
            
          /*   if(ApexPages.currentPage().getParameters().get('Offer')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                MakeOffer(mId);       
              
           
            }
              if(ApexPages.currentPage().getParameters().get('noShow')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                UpdateNoShow(mId);       
              
           
            }
             if(ApexPages.currentPage().getParameters().get('NoAttend')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                NotAttend(mId);       
              
           
            }
              if(ApexPages.currentPage().getParameters().get('rejMatch')=='true')
            {
                system.debug('**************** matchInfo***'+matchInfo);
                
                RejectMatch(mId);       
              
           
            }
            if(blnSaveOffset==true)
            {
                system.debug('****comp***'+compoffset);  
                return null;
            }
           else
           {
          
           }*/
           // Need to comment out the following 2 lines if the code about is uncommented
       p.setRedirect(false);
       return p;            
       
    }
     
    public void removeMatch(Id mId)
    {
        system.debug('***here in Remove*');
    Match__c remMatch =  [SELECT Interview_Status__c, Hide_From_Host__c,Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
   
    If(remMatch.Interview_status__c=='Initiated'|| remMatch.Interview_status__c=='Scheduled')
     remMatch.Interview_status__c = 'Cancelled';
     
     remMatch.status__c='Withdrawn';
     remMatch.Hide_From_Host__c=true;
     update remMatch;
    }
    
    /*public void ReSchedSchedMatchInfo(Id mId)
    {
    Match__c remMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate,  Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
     
    update remMatch;
    }*/
     public void ReSchedule(Id mId)
    {
    Match__c resMatch =  [SELECT Interview_Status__c,Offer_status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
     resMatch.Interview_status__c = 'Cancelled';
     resMatch.Interview_Date__c = null;
     resMatch.status__c='Requested';
     update resMatch;
    }
   /*   public void UpdateNoShow(Id mId)
    {
    Match__c resMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
     resMatch.Interview_status__c = 'Participant No Show';
     //resMatch.Interview_Date__c = null;
     //resMatch.status__c='Withdrawn';
     update resMatch;
    }
     public void CancelMatch(Id mId)
    {
    Match__c cancMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
                                                
     cancMatch.Interview_Date__c = null;
     cancMatch.Interview_status__c = 'On Hold';
    
     update cancMatch;
    }
      public void MakeOffer(Id mId)
    {
    Match__c makMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
                                                
    // makMatch.Interview_Date__c = null;
     makMatch.Interview_status__c = 'Position Offered';
     makMatch.status__c='Offered';
     update makMatch;
    }
      public void RejectMatch(Id mId)
    {
    Match__c rejectMatch =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate,  Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
                                                
     //rejectMatch.Interview_Date__c = null;
     rejectMatch.Interview_status__c = 'No Offer';
     rejectMatch.status__c='Not Offered';
     update rejectMatch;
    }
       public void NotAttend(Id mId)
    {
    Match__c notAttend =  [SELECT Interview_Status__c, Name, Participant_Id__c, status__c, Summary__c, CreatedDate,  Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c
                                                FROM Match__c 
                                                WHERE Id=: mId];
                                                
     //notAttend.Interview_Date__c = null;
     notAttend.Interview_status__c = 'Participant No Show';
     //notAttend.status__c='Withdrawn';
     update notAttend;
    }
    */
    public list<SelectOption> getHCPositions(){
        list<selectOption> l = new list<selectOption>();
        for(Position__c p : HC_Positions){
            l.add(new selectOption(p.Id, p.Name));
        }
        return l;
    }
    // Custom Controller :  All the necessary queries to display all the required data.     
    public IGI_HC_Controller(ApexPages.StandardController controller){
        
        if (confirmselected == null)
        {
            confirmselected = true;
        }
        else if (confirmselected != null && confirmselected != false)
        {
            confirmselected = true;
        }
        
        if (ApexPages.currentPage().getParameters().get('fpage') != null){
            fpage = ApexPages.currentPage().getParameters().get('fpage');
        } 
        
        activeCampaignsSession = new list<SelectOption>();
        
        activeCampaigns = new list<SelectOption>();
        
        campaignSessionWrapper = new map<String, list<Campaign_Session__c>> ();
        campaignMatchWrapper = new map<String, list<Match__c>> ();
        
        system.debug('****** userInfo.getUserType(): ' + userInfo.getUserType());
        
        //Initializing filters stuff
        listOfListMatch = new List<List<Match__c>>();
        
        pageNumber = 0;
        totalPageNumber = 1; 
        limits = '5';
        
        iTotalPageNumber = 1; 
        iLIMIT = 300; 
        iOffset = 0;
        
        Ratings = new list<SelectOption>();
        ratings.add(new SelectOption('0', '0'));
        ratings.add(new SelectOption('0.5', '0.5'));
        ratings.add(new SelectOption('1', '1'));
        ratings.add(new SelectOption('1.5', '1.5'));
        ratings.add(new SelectOption('2', '2'));
        ratings.add(new SelectOption('2.5', '2.5'));
        ratings.add(new SelectOption('3', '3'));
        ratings.add(new SelectOption('3.5', '3.5'));
        ratings.add(new SelectOption('4', '4'));
        ratings.add(new SelectOption('4.5', '4.5'));
        ratings.add(new SelectOption('5', '5'));     
        
        SortBy = new list<SelectOption>();
        //SortBy.add(new SelectOption('Name', 'Name'));
        SortBy.add(new SelectOption('Participant_Id__r.FirstName', 'First Name'));
        SortBy.add(new SelectOption('Participant_Id__r.LastName', 'Last Name'));
        SortBy.add(new SelectOption('Offer_Status__c', 'Offer Status'));
        SortBy.add(new SelectOption('Engagement__r.Engagement_Start__c', 'Engagement Start'));
        SortBy.add(new SelectOption('Engagement__r.Engagement_End__c', 'Engagement End'));
        SortBy.add(new SelectOption('Status__c', 'Match Status'));
        SortBy.add(new SelectOption('Position_Name__c', 'Position'));
        SortBy.add(new SelectOption('Rating', 'Rating'));
        
        SortBy_Match = new list<SelectOption>();
        SortBy_Match.add(new SelectOption('Participant_Id__r.FirstName', 'First Name'));
        SortBy_Match.add(new SelectOption('Participant_Id__r.LastName', 'Last Name'));
        SortBy_Match.add(new SelectOption('Offer_Status__c', 'Offer Status'));
        SortBy_Match.add(new SelectOption('Engagement__r.Engagement_Start__c', 'Engagement Start'));
        SortBy_Match.add(new SelectOption('Engagement__r.Engagement_End__c', 'Engagement End'));
        SortBy_Match.add(new SelectOption('Status__c', 'Match Status'));
        SortBy_Match.add(new SelectOption('Position_Name__c', 'Position'));
      
        /*
         * 
        /*
        SortBy.add(new SelectOption('Position_Name__c', 'Position'));
        SortBy.add(new SelectOption('Program_Duration__c', 'Program Duration'));
        SortBy.add(new SelectOption('Application_Level__c', 'Application Level'));
        SortBy.add(new SelectOption('Application_Stage__c', 'Application Stage'));
        SortBy.add(new SelectOption('CreatedDate', 'Creation Date'));
        SortBy.add(new SelectOption('Last_Applicant_Update__c', 'Last Update (By Applicant)'));
        SortBy.add(new SelectOption('Submitted_Date__c', 'Submission Date'));
        */
        
        if(userInfo.getUserType() != 'Guest'){
            
            // Initializing filter values
            matchInfo = new Match__c();
            OppInfo = new Opportunity();
            
            MatchOfferStatus = getPickValues(matchInfo, 'Offer_Status__c', null);
            
            if(!Test.isRunningTest())
            {
                string PgNm = ApexPages.CurrentPage().getUrl();
                if (PgNm.contains('C_Matches_final') )
                {
                    MatchStatus = new list<SelectOption>();
                    MatchStatus.add(new SelectOption('Save', 'Save'));
                    MatchStatus.add(new SelectOption('Applied', 'Applied'));
                    MatchStatus.add(new SelectOption('Recommended', 'Recommended'));
                    MatchStatus.add(new SelectOption('Requested', 'Requested'));
                    MatchStatus.add(new SelectOption('Confirmed', 'Confirmed'));
                    MatchStatus.add(new SelectOption('Ended Early', 'Ended Early'));
                    MatchStatus.add(new SelectOption('Withdrawn', 'Withdrawn'));
                    //MatchStatus = getPickValues(matchInfo, 'Status__c', null);
                    
                    MatchSeason = new list<SelectOption>();
                    MatchSeason.add(new SelectOption('Summer', 'Summer'));
                    MatchSeason.add(new SelectOption('Winter', 'Winter'));
                    MatchSeason.add(new SelectOption('Spring', 'Spring'));
                    
                }
                else if (PgNm.contains('C_Matches'))
                {
                    MatchStatus = new list<SelectOption>();
                    MatchStatus.add(new SelectOption('Save', 'Save'));
                    MatchStatus.add(new SelectOption('Applied', 'Applied'));
                    MatchStatus.add(new SelectOption('Recommended', 'Recommended'));
                    MatchStatus.add(new SelectOption('Requested', 'Requested'));
                    
                    MatchSeason = new list<SelectOption>();
                    MatchSeason.add(new SelectOption('Summer', 'Summer'));
                    MatchSeason.add(new SelectOption('Winter', 'Winter'));
                    MatchSeason.add(new SelectOption('Spring', 'Spring'));
                    
                }
                else
                {
                    MatchStatus = getPickValues(matchInfo, 'Status__c', null);
                    MatchSeason = getPickValues(OppInfo, 'Season__c', null);
                }
            }
            else
            {
                MatchStatus = getPickValues(matchInfo, 'Status__c', null);
                MatchSeason = getPickValues(OppInfo, 'Season__c', null);
            }
            
            MatchProgramYear = getPickValues(OppInfo, 'Program_Year__c', null);
            
            system.debug('***param Constr******');
            system.debug('***Locale******'+UserInfo.getLocale());
            system.debug('***Now******'+Datetime.now());
            TimeZone tz = UserInfo.getTimeZone();
                System.debug('Display name: ' + tz.getDisplayName());
            
            system.debug('***next page******'+ApexPages.currentPage().getParameters().get('nextPage'));
            
            if (ApexPages.currentPage().getParameters().get('nextPage') != null){
                p = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
            }
            system.debug('*******PageRef******'+p);
            
            if (ApexPages.currentPage().getParameters().get('mId') != null){
                mId = ApexPages.currentPage().getParameters().get('mId');
            }
            system.debug('*******param constr mid***'+mId);
            /* NOT Needed in this version
            if (ApexPages.currentPage().getParameters().get('compOffset') != null){
                compOffset = DateTime.ValueOf(ApexPages.currentPage().getParameters().get('compOffset'));
            }
            if (ApexPages.currentPage().getParameters().get('compOffset1') != null){
                compOffset1 = DateTime.ValueOf(ApexPages.currentPage().getParameters().get('compOffset1'));
            }
            if (ApexPages.currentPage().getParameters().get('compOffset2') != null){
                compOffset2 = DateTime.ValueOf(ApexPages.currentPage().getParameters().get('compOffset2'));
            }
            */
            
           
             
            
            activeUser = [select Id, TimeZoneSidKey,Intrax_Id__c, ContactId, LocaleSidKey, Type__c, User_Interests__c from User where Id = : userInfo.getUserId()];
            
            matchInfoList = new List<Match__c>();
            
            if(activeUser.Id != null){
                try{
                    accountInfo = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName
                                    FROM Account
                                    WHERE Id IN (SELECT AccountId FROM Contact WHERE Id =: activeUser.ContactId)];
                    system.debug('************* userInfo.Account_ID: '+ activeUser.Intrax_Id__c);
                    system.debug('************* accountInfo.Type: ' + accountInfo.Type);
                    system.debug('************* accountInfo.Name: ' + accountInfo.Name);
                      // need to make position Info a list!!!    
                    positionInfo = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c 
                                            FROM Position__c 
                                            WHERE  Host_Company_Id__c =: accountInfo.Id];
                         system.debug('************* positionInfo:** ' + positionInfo);
                }
                catch(Exception e){
                    system.debug('*********** ' + e);
                }
                
                if(mId != NULL){
                    system.debug('**************** DETAIL PAGE');
                    try{                                    
                        matchInfo = [SELECT Position_Name__r.Position_Supervisor__c, Position_Name__r.Position_Supervisor__r.Skype_ID__c, Position_Name__r.Position_Supervisor__r.Name, Position_Name__r.Supervisor_Role__c, Intrax_Program__c, Engagement__r.Program_Year__c, Engagement__r.Season__c, Engagement__c, Interviewer_Notes__c, Start_Date__c, End_Date__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Middle_Name__pc, Participant_Id__r.Gender__pc,Participant_Id__r.Nick_Name__pc, Participant_Id__r.Citizenship__pc, Participant_Id__r.PersonBirthdate, Participant_Id__r.Name, Participant_Id__r.Phone,
                                        Name, Participant_Id__c, status__c, Participant_Id__r.Age__pc, Participant_Id__r.Best_Call_Time__pc, Participant_Id__r.PersonHomePhone,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Position_Name__r.Name, Position_Name__r.Host_Company_Id__r.Id, Position_Name__r.Title__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c, Offer_Status__c
                                        FROM Match__c 
                                        WHERE Id=: mId];  
                                                
                                                
                        if(ApexPages.CurrentPage().getParameters().get('Offer') != null ){
                            CurrentPositionSelected = MatchInfo.Position_Name__r.Id;
                            system.debug('****** CPS: ' + currentPositionSelected);
                            //B-01737 (Start)
                            system.debug('getallAccountIDs(matchInfo.Position_Name__r.Host_Company_Id__r.Id)' + getallAccountIDs(matchInfo.Position_Name__r.Host_Company_Id__r.Id));
                            system.debug('matchInfo.Engagement__r.Program_Year__c' + matchInfo.Engagement__r.Program_Year__c);
                            system.debug('matchInfo.Engagement__r.Season__c)' + matchInfo.Engagement__r.Season__c);
                            HC_Positions = [SELECT Id, Name, Description__c, Matched_Count__c, Program_Year__c, Season__c FROM Position__c WHERE Host_Company_Id__c IN :getallAccountIDs(matchInfo.Position_Name__r.Host_Company_Id__r.Id) AND Status__c =: 'Matching' AND Program_Year__c =: matchInfo.Engagement__r.Program_Year__c AND Season__c =: matchInfo.Engagement__r.Season__c];
                            system.debug('HC_Positions'+HC_Positions);
                            //B-01737 (End)
                        }
                        
                        engagementInfo = [SELECT Intrax_Program__c, Primary_Activity__c, School_Name__c, Major__c, Graduation_Date__c,Education_Program_Type__c,Other_Languages__c, Flexible_Dates__c, Language_1__c, Language_1_Proficiency__c,Language_2__c, Language_2_Proficiency__c,Language_3__c, Language_3_Proficiency__c, Id, Program_Duration__c, 
                                                    Engagement_Start__c, Engagement_End__c, Account_Id__r.Name,Account_Id__r.ShippingStreet,Account_Id__r.BillingStreet,Account_Id__r.ShippingState,Account_Id__r.BillingState, 
                                                    Account_Id__r.ShippingCity,Account_Id__r.BillingCity,Account_Id__r.ShippingPostalCode,Account_Id__r.BillingPostalCode,Engagement_Country__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Phone, Account_Id__r.PersonEmail,  Account_Id__r.Resume__pc 
                                                    FROM Engagement__c WHERE Id =: matchInfo.Engagement__c];
                        
                        if(engagementInfo.Id != null){
                            // Getting applicant_Info__c related record linked thru the engagement
                            applicantInfo = [SELECT Id, Engagement__c, Intrax_Program__c FROM Applicant_Info__c WHERE Engagement__c = :engagementInfo.Id LIMIT 1];
                            
                            experienceInfoList = [SELECT City__c, Country__c, Employer_Name__c, Start_Date__c, End_Date__c, Position_Title__c, Position_Description__c, Applicant_Info__c FROM Experience__c WHERE Applicant_Info__c =: applicantInfo.Id];
                            
                            essayList = [SELECT id,Applicant_Info__c,label__c, Narrative__c, Name, ordinal__c FROM Essay__c a
                                            WHERE Applicant_Info__c =: applicantInfo.Id
                                            and Name != 'Parent Letter'
                                            ORDER BY ordinal__c ASC];
                                            
                            // Getting PT Photo
                            returnURL = IUtilities.getParticipantPhoto(applicantInfo);
                            //responseXML = returnedParams[0];
                            //returnURL = returnedParams[1];
                            //system.debug('****** responseXML: ' + responseXML);
                            system.debug('****** returnURL:' + returnURL);
                        
                        }
                     // positionInfo = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c 
                                            //FROM Position__c 
                                          //  WHERE Id =: matchInfo.Position_Name__c];
                        system.debug('**************** matchInfo*'+matchInfo);
                        if(matchInfo!=null) {    
                            if(matchInfo.Interview_Request_HC1__c!=null||matchInfo.Interview_Request_HC2__c!=null||matchInfo.Interview_Request_HC3__c!=null){
            
                                String ParticipantId =  matchInfo.Participant_Id__c;
            
                                persAccInfo =[SELECT Name,Id, PersonContactId FROM Account WHERE Id=:ParticipantId limit 1];
               
                
                                participantUser = [Select u.TimeZoneSidKey, u.Name, u.LocaleSidKey, u.Intrax_Id__c, u.Id, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.contactid=:persAccInfo.PersonContactId limit 1];
           
                        /* Not needed in this version
                        if(participantUser!=null)
                        {
                            system.debug('**************** test****');                       
                            tz=participantUser.TimeZoneSidKey;
                            system.debug('**************** tz*'+tz);
                            TimeZone tzz = TimeZone.getTimeZone(tz);
                            system.debug('**************** tzz*'+tzz);  
                
                            offsetGmt=Decimal.valueof(tzz.getOffset(DateTime.newInstance(system.today().year(),system.today().month(),system.today().day(),system.now().hour(),system.now().minute(),system.now().second())))/3600000;
                            system.debug('**************** offsetGmt*'+offsetGmt); 
                            intOffsetGmt=Integer.valueOf(offsetGmt);
                            system.debug('**************** intOffsetGmt*'+intOffsetGmt); 
                
                            if(offsetGmt!=intOffsetGmt)
                            {
                            //list<string> OffsetRanges =new list<string>();
                            strOffsetGmt = String.valueof(offsetGmt);
                            system.debug('**************** strOffsetGmt *'+strOffsetGmt ); 
                            OffsetRanges = strOffsetGmt.splitByCharacterType();
                            system.debug('**************** OffsetRanges *'+OffsetRanges );
                            System.debug('OffsetRanges: ' + OffsetRanges);
                            
                            if(strOffsetGmt.contains('.'))
                            {
                                intOffsetGmt1= Integer.ValueOf(OffsetRanges[0]);
                                system.debug('**************** intOffsetGmt1*'+intOffsetGmt1);
                                if(OffsetRanges[2].length()<2)
                                OffsetRanges[2]=offsetRanges[2]+ '0'; 
                                system.debug('**************** OffsetRanges*'+OffsetRanges);
                                decOffsetGmt1= Decimal.ValueOf(OffsetRanges[2]);
                                system.debug('**************** decOffsetGmt1*'+decOffsetGmt1);
                                decOffsetGmt1=decOffsetGmt1.SetScale(2);
                                system.debug('**************** decOffsetGmt1*'+decOffsetGmt1);
                     
                                OffsetGmt1 = (decOffsetGmt1/100)*60;
                                system.debug('**************** decOffsetGmt1 *'+decOffsetGmt1 );
                                intOffsetGmt2 = Integer.valueOf(decOffsetGmt1);
                                system.debug('**************** intOffsetGmt2 *'+intOffsetGmt2 );
                            }
                            if(matchInfo.Interview_Request_HC1__c!=null)
                            {
                                compOffset = matchInfo.Interview_Request_HC1__c.addHours(intOffsetGmt1);
                                system.debug('**************** compOffset *'+compOffset );
                                compOffset = compOffset.addMinutes(intOffsetGmt2);
                            }
                            if(matchInfo.Interview_Request_HC2__c!=null)
                            {
                                compOffset1 = matchInfo.Interview_Request_HC2__c.addHours(intOffsetGmt1);
                                compOffset1 = compOffset1.addMinutes(intOffsetGmt2);
                            }
                            if(matchInfo.Interview_Request_HC3__c!=null)
                            {
                                compOffset2 = matchInfo.Interview_Request_HC3__c.addHours(intOffsetGmt1);
                                compOffset2 = compOffset2.addMinutes(intOffsetGmt2);
                            }
                     
                        }
                        else
                        {
                            if(matchInfo.Interview_Request_HC1__c!=null)
                            {
                                compOffset = matchInfo.Interview_Request_HC1__c.addHours(intOffsetGmt);
                      system.debug('**************** compOffset-- *'+compOffset );
                            }
                            if(matchInfo.Interview_Request_HC2__c!=null)
                            {
                                compOffset1 = matchInfo.Interview_Request_HC2__c.addHours(intOffsetGmt);
                     
                            }
                            if(matchInfo.Interview_Request_HC3__c!=null)
                            {
                                compOffset2 = matchInfo.Interview_Request_HC3__c.addHours(intOffsetGmt);
                
                            }
                                        
                        }
                        
                        system.debug('String format: compOffset '+ compOffset);
                        
                        if(p==null)
                        {
                            //p=new PageReference('/apex/sc_scheduling');
                            p= Page.IGI_HC_MyMatches;
                            p.getParameters().put('mId', mId);
                        if (compOffset != null)
                            p.getParameters().put('compOffset',String.ValueOf(compOffset));
                        if (compOffset1 != null)
                            p.getParameters().put('compOffset1',String.ValueOf(compOffset1));
                        if (compOffset2 != null)
                            p.getParameters().put('compOffset2',String.ValueOf(compOffset2));
                            system.debug('***pp****'+p);
                           // p.setRedirect(true);
                        }
          
                    }*/
                }
                
                        }
                        
            }
            catch(Exception e){
                system.debug('*********** ' + e);
            }
                   
                }else{
                    system.debug('**************** GENERAL PAGE');
                    try{
                        if(accountInfo.Type == 'Host Company'){
                            /* positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
                                                    FROM Position__c 
                                                    WHERE Host_Company_Id__c =: accountInfo.Id];*/
                               
                               positionInfoList = [SELECT Id, Name, Host_Company_Id__c, Description__c, Intrax_Program__c, Engagement_Start__c, Engagement_End__c
                                                    FROM Position__c 
                                                    WHERE Host_Company_Id__c IN : getallAccountIDs(accountInfo.Id)];
                                                    
                            system.debug('************* position:' + positionInfoList);
                            
                            // Initializing the Position Name filter
                            positionsName = new list<SelectOption>();
                            
                            //positionName.add(new SelectOption('Test', 'Test'));
                            for(Position__c p : positionInfoList){
                                positionsName.add(new SelectOption(p.Name, p.Name));
                            }
                            
                            
                            if(positionInfoList.size() > 0){
                                List<Match__c> mAux;
                                List<Match__c> mAux2 = new list<Match__c>();
                                
                                Set<Id> aAuxIDs = new Set<Id>();
                    
                                for(Position__c p : positionInfoList)
                                {
                                    aAuxIDs.add(p.id);
                                }
                                
                                if (aAuxIDs.size() > 0)
                                {
                                     mAux = [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                                        Name, Participant_Id__c, status__c,Participant_Id__r.Best_Call_Time__pc, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c        
                                         FROM Match__c WHERE Position_Name__c IN : aAuxIDs ];
                                         system.debug('************** mAUX: ' + mAux);
                                         if(mAux.size() > 0){
                                        mAux2.addAll(mAux);
                                    }
                                }
                                
                                
                               /* for(Position__c p : positionInfoList){
                                    mAux = [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                                        Name, Participant_Id__c, status__c,Participant_Id__r.Best_Call_Time__pc, Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c        
                                         FROM Match__c WHERE Position_Name__c =: p.Id ];
                                    system.debug('************** mAUX: ' + mAux);
                                                
                                    if(mAux.size() > 0){
                                        mAux2.addAll(mAux);
                                    }
                                    
                                }*/
                                
                                matchInfoList = [SELECT Engagement__c, Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c, Offer_Status__c, Participant_Id__c, Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Participant_Id__r.LastName, Participant_Id__r.FirstName, Interview_Status__c,status__c, Participant_Id__r.Skype_ID__pc,Interview_Response_Note__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c,
                                                    Id, Name, Position_Name__r.Host_Company_Id__c, Position_Name__r.Host_Company_Id__r.Name, Position_Name__r.Position_Supervisor__r.Name,Interview_Request_HC1__c,Interview_Request_HC2__c,Interview_Request_HC3__c, Position_Name__r.Regional_Location__c, Position_Name__r.Name, Position_Name__r.Host_company_Id__r.Industry
                                                    FROM Match__c 
                                                    WHERE Id IN: mAux2  and Interview_status__c!=null ORDER BY Interview_Date__c ASC];
                                
                                
                                ConfirmedMatches =  [SELECT Engagement__c, Engagement__r.Engagement_Country__c,Participant_Id__r.LastName,Participant_Id__r.isPersonAccount, Participant_Id__r.PersonEmail, Interview_Request_Note__c,Participant_Id__r.Skype_ID__pc,Marketing_Notes__c,Participant_Id__r.ShippingStreet,Participant_Id__r.BillingStreet,Participant_Id__r.ShippingState,Participant_Id__r.BillingState, Participant_Id__r.ShippingCity,Participant_Id__r.BillingCity,Participant_Id__r.ShippingPostalCode,Participant_Id__r.BillingPostalCode,Participant_Id__r.Resume__pc,Interview_Status__c, Participant_Id__r.FirstName, Participant_Id__r.Name, Participant_Id__r.Phone,
                                                        Name, Participant_Id__c, status__c,Summary__c, CreatedDate, Interview_Date__c, Position_Name__c, Description__c, Interview_Request_HC1__c, Interview_Request_HC2__c, Interview_Request_HC3__c,     
                                                        Position_Name__r.Host_Company_Id__c, Position_Name__r.Regional_Location__c, Position_Name__r.Position_Supervisor__r.Name,Position_Name__r.Name, Position_Name__r.sAccount__r.Name FROM Match__c 
                                                        WHERE Position_Name__c IN: positionInfo
                                                        AND Interview_Status__c = 'Scheduled' ORDER BY Interview_Date__c ASC];
                                             system.debug('******ConfirmedMatches*******'+ConfirmedMatches);

                                matchInfo=new Match__c();                               
                            }
                        }
                    }
                        catch(Exception e){
                            system.debug('*********** ' + e);
                        }
                    
                }
            }   
        }else checkLogin();
    }
    
    // Allows the user to request an interview for a specific candidate. It will create (through the Match Trigger),
    // a task that will be assigned to the related position owner.
    /* Not needed in this version
    public pagereference requestInterview(){
        system.debug('*************Inside Request*********');
        Datetime IntDate1;
        String Interview;
        
          if(ApexPages.currentPage().getParameters().get('IntDate') == '')
        {
         if(ApexPages.currentPage().getParameters().get('InputInterview') != null)
         {
            Interview = ApexPages.currentPage().getParameters().get('InputInterview');  
            if(Interview=='Int1')
                     {
                       compOffset = null;       
                     
                     } if(Interview=='Int2')
                     {
                         compOffset1 = null;        
                     } if(Interview=='Int3')
                     {
                         compOffset2 = null;    
                     }      
         }
         
        }
         else
         { if(ApexPages.currentPage().getParameters().get('IntDate') != null)
         {
            IntDate1 = DateTime.parse(ApexPages.currentPage().getParameters().get('IntDate'));          
         }
         if(ApexPages.currentPage().getParameters().get('InputInterview') != null)
         {
            Interview = ApexPages.currentPage().getParameters().get('InputInterview');          
         }
         system.debug('*************Interview*********'+Interview);
        
         }   
       
         system.debug('*************Interview*********'+IntDate1);
         system.debug('*************Interview*********'+Interview);
         if(IntDate1!=null)
         {
            String ParticipantId =  matchInfo.Participant_Id__c;
            system.debug('*******ParticipantId**********'+ParticipantId);   
            persAccInfo =[SELECT Name,Id, PersonContactId FROM Account WHERE Id=:ParticipantId limit 1];
            system.debug('*******persAccInfo.contactId**********'+persAccInfo.PersonContactId);
            
            participantUser = [Select u.TimeZoneSidKey, u.Name, u.LocaleSidKey, u.Intrax_Id__c, u.Id, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.contactid=:persAccInfo.PersonContactId limit 1];
            system.debug('*******Passed User Select*********');          
            //system.debug('*******participantUser**********'+participantUser);
            if(participantUser!=null)
            {
             system.debug('**************** test****');   
                 tz=participantUser.TimeZoneSidKey;
                 system.debug('**************** tz*'+tz);
                           
                  
                 TimeZone tzz = TimeZone.getTimeZone(tz);
                 system.debug('**************** tzz*'+tzz);  
                 
                offsetGmt=Decimal.valueof(tzz.getOffset(DateTime.newInstance(system.today().year(),system.today().month(),system.today().day(),system.now().hour(),system.now().minute(),system.now().second())))/3600000;
                system.debug('**************** offsetGmt*'+offsetGmt); 
                intOffsetGmt=Integer.valueOf(offsetGmt);
                 system.debug('**************** intOffsetGmt*'+intOffsetGmt);
                if(offsetGmt!=intOffsetGmt)
                {
                    //list<string> OffsetRanges =new list<string>();
                    strOffsetGmt = String.valueof(offsetGmt);
                     system.debug('**************** strOffsetGmt *'+strOffsetGmt );
                    OffsetRanges = strOffsetGmt.splitByCharacterType();
                    
                    System.debug('OffsetRanges: ' + OffsetRanges);
                     if(strOffsetGmt.contains('.'))
                     {
                      intOffsetGmt1= Integer.ValueOf(OffsetRanges[0]);
                       system.debug('**************** intOffsetGmt1*'+intOffsetGmt1);
                        if(OffsetRanges[2].length()<2)
                         OffsetRanges[2]=offsetRanges[2]+ '0'; 
                          system.debug('**************** OffsetRanges*'+OffsetRanges);
                      decOffsetGmt1= Decimal.ValueOf(OffsetRanges[2]);
                      system.debug('**************** decOffsetGmt1*'+decOffsetGmt1);
                      decOffsetGmt1=decOffsetGmt1.SetScale(2);
                       system.debug('**************** decOffsetGmt1*'+decOffsetGmt1);
                     
                      decOffsetGmt1 = (decOffsetGmt1/100)*60;
                       system.debug('**************** decOffsetGmt1 *'+decOffsetGmt1 );
                      intOffsetGmt2 = Integer.valueOf(decOffsetGmt1);
                       system.debug('**************** intOffsetGmt2 *'+intOffsetGmt2 );
                     }
                     if(Interview=='Int1')
                     {
                      compOffset = IntDate1.addHours(intOffsetGmt1);  
                       
                      system.debug('*************compOffset*********'+compOffset );    
                                        
                      compOffset = compOffset.addMinutes(intOffsetGmt2);
                        system.debug('*************compOffset*********'+compOffset ); 
                        
                       Integer intcompOffset =Integer.ValueOf(compOffset.hourgmt());
                        Integer intcompOffsetMin = Integer.ValueOf(compOffset.minutegmt());
                        
                        */
                      /* DIEGO This was already commented out
                       if(intcompOffset<0) intcompOffset = 24 + intcompOffset ;
                       Integer intcompOffsetMin = Integer.ValueOf(compOffset.minute());
                       system.debug('*************intcompOffset*********'+intcompOffset); 
                       system.debug('*************intcompOffsetMin*********'+intcompOffsetMin); 
                       system.debug('*************blncompoffset*********'+blncompoffset); */
                       
                       /* Not needed in this version
                       if((intcompOffset>=22 && intcompOffsetMin>=0 && intcompOffsetMin<=59) || ((intcompOffset>= 0 && intcompOffsetMin>=0 && intcompOffsetMin<=59 ) && (intcompOffset<5 && intcompOffsetMin>=0 && intcompOffsetMin<=59)))
                       {
                        
                       blncompoffset=true;
                       //  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Interview cannot be scheduled between 10PM - 5AM'));
                      //  return null;
                       }
                       else
                        blncompoffset=false;
                       system.debug('*******blncompoffset*****'+blncompoffset);
                    
                     }
                      if(Interview=='Int2')
                     {
                        system.debug('*************Interview Int2*********'+Interview);
                      compOffset1 = IntDate1.addHours(intOffsetGmt1);                   
                      compOffset1 = compOffset1.addMinutes(intOffsetGmt2);
                      system.debug('*************compOffset1*********'+compOffset1);
                     
                        Integer intcompOffset1 =Integer.ValueOf(compOffset1.hourgmt());
                        Integer intcompOffset1Min = Integer.ValueOf(compOffset1.minutegmt());
                       if((intcompOffset1>=22 && intcompOffset1Min>=0 && intcompOffset1Min<=59) || ((intcompOffset1>= 0 && intcompOffset1Min>=0 && intcompOffset1Min<=59 ) && (intcompOffset1<5 && intcompOffset1Min>=0 && intcompOffset1Min<=59)))
                       {
                        
                       blncompoffset1=true;
                     //   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Interview cannot be scheduled between 10PM - 5AM'));
                     //   return null;
                       }
                       else
                        blncompoffset1=false;
                       system.debug('*******blncompoffset1*****'+blncompoffset1);
                    
                        }
                      if(Interview=='Int3')
                     {
                        system.debug('*************Interview Int3*********'+Interview);
                      compOffset2 = IntDate1.addHours(intOffsetGmt1);                   
                      compOffset2 = compOffset2.addMinutes(intOffsetGmt2);
                       system.debug('*************compOffset2*********'+compOffset2);
                       */
                       
                       /* DIEGO This was already commeted out
                       Integer intcompOffset2 =Integer.ValueOf(compOffset2.hour())-8;
                         if(intcompOffset2<0)
                           intcompOffset2 = 24 + intcompOffset2 ;
                       Integer intcompOffset2Min = Integer.ValueOf(compOffset2.minute());
                       system.debug('*************intcompOffset1*********'+intcompOffset2); 
                       system.debug('*************intcompOffset1*********'+intcompOffset2Min); 
                       system.debug('*************blncompoffset2*********'+blncompoffset2); */
                       
                       /* Not needed for this version
                        Integer intcompOffset2 =Integer.ValueOf(compOffset2.hourgmt());
                        Integer intcompOffset2Min = Integer.ValueOf(compOffset2.minutegmt());
                       if((intcompOffset2>=22 && intcompOffset2Min>=0 && intcompOffset2Min<=59) || ((intcompOffset2>= 0 && intcompOffset2Min>=0 && intcompOffset2Min<=59 ) && (intcompOffset2<5 && intcompOffset2Min>=0 && intcompOffset2Min<=59)))
                       {
                        
                       blncompoffset2=true;
                      //  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Interview cannot be scheduled between 10PM - 5AM'));
                    //     return null;
                       }
                       else
                        blncompoffset2=false;
                       system.debug('*******blncompoffset2*****'+blncompoffset2);
                    
                     }
                     
                }
                else
                {
                
                    if(Interview=='Int1')
                     {
                         system.debug('*************intOffsetGmt*********'+intOffsetGmt); 
                       compOffset = IntDate1.addHours(intOffsetGmt); 
                    */   
                      /* DIEGO This was already commented out
                         system.debug('*************IntDate1*********'+IntDate1);
                         system.debug('*************compOffset*********'+compOffset);
                         system.debug('*************compOffset.hour()*********'+compOffset.hour());
                         system.debug('*************compOffset.minute()*********'+compOffset.minute());
                        Integer intcompOffset =Integer.ValueOf(compOffset.hour())-8;
                         if(intcompOffset<0)
                           intcompOffset = 24 + intcompOffset ;
                       Integer intcompOffsetMin = Integer.ValueOf(compOffset.minute());*/
                     
                    /* Not needed for this version 
                        Integer intcompOffset =Integer.ValueOf(compOffset.hourgmt());
                        Integer intcompOffsetMin = Integer.ValueOf(compOffset.minutegmt());
                       system.debug('*************intcompOffset*********'+intcompOffset); 
                       system.debug('*************intcompOffsetmin*********'+intcompOffsetMin); 
                       system.debug('*************blncompoffset*********'+blncompoffset); 
                       if((intcompOffset>=22 && intcompOffsetMin>=0 && intcompOffsetMin<=59) || ((intcompOffset>= 0 && intcompOffsetMin>=0 && intcompOffsetMin<=59 ) && (intcompOffset<5 && intcompOffsetMin>=0 && intcompOffsetMin<=59)))
                       {
                        
                       blncompoffset=true;
                        // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Interview cannot be scheduled between 10PM - 5AM'));
                        // return null;
                       }
                       else
                        blncompoffset=false;
                       system.debug('*******blncompoffset1*****'+blncompoffset);
                               
                     
                     } if(Interview=='Int2')
                     {
                        system.debug('*************Interview Int2*********'+Interview);
                        system.debug('*************compOffset1*********'+compOffset1); 
                       compOffset1 = IntDate1.addHours(intOffsetGmt); 
                       system.debug('*************compOffset1*********'+compOffset1); 
                       */
                      /* DIEGO This was already commented out
                       Integer intcompOffset1 =Integer.ValueOf(compOffset1.hour())-8;
                        if(intcompOffset1<0)
                           intcompOffset1 = 24 + intcompOffset1;
                       Integer intcompOffset1Min = Integer.ValueOf(compOffset1.minute());
                       system.debug('*************intcompOffset1*********'+intcompOffset1); 
                       system.debug('*************intcompOffset1*********'+intcompOffset1Min); 
                       system.debug('*************blncompoffset1*********'+blncompoffset1); */
                       
                       /*
                        Integer intcompOffset1 =Integer.ValueOf(compOffset1.hourgmt());
                        Integer intcompOffset1Min = Integer.ValueOf(compOffset1.minutegmt());
                       if((intcompOffset1>=22 && intcompOffset1Min>=0 && intcompOffset1Min<=59) || ((intcompOffset1>= 0 && intcompOffset1Min>=0 && intcompOffset1Min<=59 ) && (intcompOffset1<5 && intcompOffset1Min>=0 && intcompOffset1Min<=59)))
                       {
                        
                       blncompoffset1=true;
                       //  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Interview cannot be scheduled between 10PM - 5AM'));
                       //  return null;
                       }
                       else
                        blncompoffset1=false;
                       system.debug('*******blncompoffset1*****'+blncompoffset1);
                    
                      
                     } if(Interview=='Int3')
                     {
                        system.debug('*************Interview Int3*********'+Interview);
                      compOffset2 = IntDate1.addHours(intOffsetGmt);    
                        system.debug('*************compOffset2*********'+compOffset2);    
                        */
                        /* DIEGO This was already commented out Integer intcompOffset2 =Integer.ValueOf(compOffset2.hour())-8;
                          if(intcompOffset2<0)
                           intcompOffset2 = 24 + intcompOffset2;
                       Integer intcompOffset2Min = Integer.ValueOf(compOffset2.minute());
                       system.debug('*************intcompOffset1*********'+intcompOffset2); 
                       system.debug('*************intcompOffset1*********'+intcompOffset2Min); 
                       system.debug('*************blncompoffset1*********'+blncompoffset2); */
                       
                       /*
                        Integer intcompOffset2 =Integer.ValueOf(compOffset2.hourgmt());
                        Integer intcompOffset2Min = Integer.ValueOf(compOffset2.minutegmt());
                       if((intcompOffset2>=22 && intcompOffset2Min>=0 && intcompOffset2Min<=59) || ((intcompOffset2>= 0 && intcompOffset2Min>=0 && intcompOffset2Min<=59 ) && (intcompOffset2<5 && intcompOffset2Min>=0 && intcompOffset2Min<=59)))
                       {
                        
                       blncompoffset2=true;
                        // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Interview cannot be scheduled between 10PM - 5AM'));
                        // return null;
                       }
                       else
                        blncompoffset2=false;
                       system.debug('*******blncompoffset1*****'+blncompoffset2);
                              
                   
                     }
                                    
                }
              
                
                
            }}         
        
         return null;
    }
    */
    
    
    public void saveMatchInfo(){
    
   
            if(ApexPages.currentPage().getParameters().get('SaveMatch')=='true')
            {
        
               
                matchInfo.Interview_Status__c='Initiated';
                 matchInfo.Interview_Date__c = null;
                 matchInfo.Status__c='Requested';
                 update matchInfo;
              }
              
                 
             
              if(ApexPages.currentPage().getParameters().get('Comp')=='true')
              { matchInfo.Interview_Status__c='Completed'; matchInfo.Status__c='Requested';   update matchInfo;}
               if(ApexPages.currentPage().getParameters().get('CompNoShow')=='true')
              { matchInfo.Interview_Status__c='Company No Show';matchInfo.Status__c='Requested';  update matchInfo;}
               if(ApexPages.currentPage().getParameters().get('PartNoShow')=='true')
              { matchInfo.Interview_Status__c='Participant No Show';matchInfo.Status__c='Requested';  update matchInfo;}
   
    }
    
    public boolean getCheckParticipantPhoto(){
        list<Intrax_Program_Upload__c> ipu = [SELECT Id, Name, Document_Type__c FROM Intrax_Program_Upload__c where Applicant_Info__c =: applicantInfo.Id AND Document_Type__c = 'Participant-Photo'];
        if(ipu.size() >= 1){
            return true;
        } else return false;
    }
    
    public List<Intrax_Program_Upload__c> getDocListPTPhoto(){
        return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        where d.Engagement__c =: EngagementInfo.Id AND Document_Type__c = 'Participant-Photo' order by d.Document_Type__c desc ];  
    } 
    
    public List<Intrax_Program_Upload__c> getDocListPTResume(){
        string engId = ApexPages.currentPage().getParameters().get('PTId');
       system.debug('***********Entering getDocListPTResume '+engId);
       if(engId!=null)
       {
        return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        where d.Engagement__c =: engId AND Document_Type__c = 'Resume' order by d.Document_Type__c desc ];     
       }else 
         {
           return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        where d.Engagement__c =: EngagementInfo.Id AND Document_Type__c = 'Resume' order by d.Document_Type__c desc ];  
         }
    }
    
    public PageReference load(){
        // Instantiate a new http object 
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
        
        //B-01590
        system.debug('****** DOCGUID: ' + ApexPages.currentPage().getParameters().get('docGuid'));
        if(ApexPages.currentPage().getParameters().get('docGuid') != null && ApexPages.currentPage().getParameters().get('docGuid') != ''){
        loadDoc = [Select Document_service__c,Document_GUID__c from Intrax_Program_Upload__c where document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/xml');
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
         body = body + ApexPages.currentPage().getParameters().get('docGuid');
         req.setBody(body);
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
         Dom.Document docRes = new Dom.Document();
         String returnurl = null;
         if (!Test.isRunningTest()) {
            res = h.send(req);
            responseXML = res.getBody();
            docRes.load(responseXML);
            list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
         
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
            for (dom.XmlNode node : resnodelist){
                if ( node.getName() == 'result'){
                    returnurl = node.getText();
                }
                
                //AA-B-01806
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
         return new PageReference(returnurl); 
         }else return null;  
         }
        else return null;                
      }
      
      public Set<ID> getallAccountIDs(ID PrimaryID)
      {
         Set<Id> allAccountList = new Set<Id>();
         allAccountList.add(PrimaryID);
                
         string parentRecordId = accountInfo.Id; 
         boolean continueLoop = true;

        while(continueLoop)
        { 
            list <account> lstAcct = [SELECT ID, ParentId, Name From Account Where ParentId =: parentRecordId];
                    
            if (lstAcct.size() == 0)
            {
                 continueLoop = false;  //no records returned
                 continue;
            }
            else if(lstAcct[0].ParentId == null)  //at the top of the hierarchy, get the Name
            {
                continueLoop=false;
                continue;
            }
            
            for (account accvalIns: lstAcct)
            {
                allAccountList.add(accvalIns.ID);
            }
            parentRecordId = lstAcct[0].ID;
        } 
        return allAccountList;
     }
     
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
    
    public void offerCandidate()
    {
        offermsg = '';
        try
        {
            if(ApexPages.CurrentPage().getParameters().get('matID') != null )
            {
                Match__c selMatch = [SELECT ID, Name, Offer_Status__c, Engagement__c FROM Match__c WHERE ID = :ApexPages.CurrentPage().getParameters().get('matID')];
                if (selMatch.Offer_Status__c == 'Offered' || selMatch.Offer_Status__c == 'Accepted')
                {
                    List<dsfs__DocuSign_Status__c> dstoDelete = [select Id,dsfs__DocuSign_Envelope_ID__c, Signing_Document_Name__c from dsfs__DocuSign_Status__c where Match__c = :ApexPages.CurrentPage().getParameters().get('matID') AND Signing_Document_Name__c='Work Travel Job Placement'];
                    if(dstoDelete != NULL && dstoDelete.size() > 0)
                    {
                        for (dsfs__DocuSign_Status__c dstoDeleteSingle : dstoDelete){
                                //delete dstoDeleteSingle;
                               dstoDeleteSingle.Signing_Document_Name__c = 'Old Version';
                          }
                          update dstoDelete;
                    }
                    
                    list<Notification__c> ObjNotfToDelete = new List<Notification__c>();
                      ObjNotfToDelete = [Select n.Type__c, n.SystemModstamp, n.Subject__c, n.Status__c, n.Position__c, n.Portal_URL__c, n.Partner_Email__c, n.OwnerId, n.Name, n.Match__c, n.MatchStartDate__c, n.LastModifiedDate, n.LastModifiedById, n.IsDeleted, n.Intrax_Program__c, n.Id, n.Engagement__c, n.CurrencyIsoCode, n.CreatedDate, n.CreatedById, n.Contact__c, n.ConnectionSentId, n.ConnectionReceivedId, n.Body__c, n.Account__c, n.AccountId__c From Notification__c n where n.match__c =:selMatch.Id and n.engagement__c = :selMatch.Engagement__c and Type__c =: 'Offer Extended' and status__c != 'Confirmed'];
                      if(ObjNotfToDelete!=null && ObjNotfToDelete.size()>0){
                        for (Notification__c notifyDel : ObjNotfToDelete){
                            delete notifyDel;
                        }
                      }
                      
                    Notification_Generator.CreateCandidateJobNotification(ApexPages.CurrentPage().getParameters().get('matID'));
                    offermsg = 'Offer has been scuccesfully submitted.';
                }
                else
                {
                    offermsg = 'This match is not offered yet. Please offer this match before you submit it.';
                }
            }
            else
            {
                offermsg = 'There is some issue in submitting the offer.';
            }
            
        }               
        catch(Exception e)
        {
            offermsg = 'There is some issue in submitting the offer.';
            system.debug('*********** ' + e);
        }
    }
     //RS Added       
    public List<Intrax_Program_Upload__c> getDocList(){
         string engId = ApexPages.currentPage().getParameters().get('PTId');
         system.debug('***********Entering getDocList ');
         if(engId!=null)
        return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
        where d.Engagement__c =: engId AND d.Review_Status__c IN ('Accepted') AND Document_Type__c IN('Resume','Participant-photo','Offer-Document','Extension-DS-7002-(Complete)','DS-7002-(Complete)') order by d.Document_Type__c desc ];  
              else return null;
    } 
     public pageReference enterTippForm(){
        
       String pageref= ApexPages.currentPage().getParameters().get('mId');
       if(pageref != null)
       {
        Match__c m=[Select Current_TIPP_Editor__c from Match__c where Id=:pageref];
        m.Current_TIPP_Editor__c ='Host Company';
        update m;
        pageReference p = new pageReference ('/apex/igi_tipp_host_company_info?mId='+pageref);
        p.setRedirect(true);
         return p;
       }
       return null;
    }
    //RS Added
       public List<Intrax_Program_Upload__c> getMatchDocList(){             
       list<Match__c> matchList =  selectedMatches;     
       system.debug('getMatchDocList matchList: '+matchList); 
       List<Intrax_Program_Upload__c> ipu  = new List<Intrax_Program_Upload__c>();
       List<Intrax_Program_Upload__c> ipuList  = new List<Intrax_Program_Upload__c>();
       string engId = ApexPages.currentPage().getParameters().get('PTId');
         system.debug('***********Entering getDocList ');
         if(engId!=null){
                ipu = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
              where d.Engagement__c =: engId AND d.Review_Status__c IN ('Accepted') AND Document_Type__c IN('Resume','Participant-photo') order by d.Document_Type__c desc ];
              for(Intrax_Program_Upload__c ip :ipu){
                     ipuList.add(ip);
                 }
         }
          if(matchList.size()>0){                    
                 for(Match__c m: matchList )
                 {
                 system.debug('Inside for loop');                 
                 ipu=[Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                 where d.Match__c =:m.Id AND d.Review_Status__c IN ('Accepted') AND Document_Type__c IN('Offer-Document','Extension-DS-7002-(Complete)','DS-7002-(Complete)') order by d.Document_Type__c desc ];                                      
                 for(Intrax_Program_Upload__c ip :ipu){
                     ipuList.add(ip);
                 }
                 }                 
                  return ipuList;         
         }    
       else  return null;        
  
  }
   public void preLoad()
   {
    String hid=ApexPages.currentPage().getParameters().get('Id');
    List<Account> list_hAcc= [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName, Intrax_Programs__c,BillingState,BillingStreet,BillingCity,
           BillingPostalcode,EIN__c,Phone,Fax,Email_Business__c,Website,Company_Type__c,Company_Annual_Revenue__c,NumberOfEmployees,
           Has_Workers_Comp__c,Worker_Comp_Provider__c,Workers_Comp_Policy_Number__c FROM Account WHERE Id=:hid]; 
    if(list_hAcc!=null && list_hAcc.size()>=1){
       hAcc=list_hAcc[0];
      }
    list_hca=[Select id,Name,Title,Email from Contact where AccountId=:hid and Status__c='Active']; 
   }
   public Account getAccount()
   {
     if(hAcc!=null ){
         return hAcc;
     }
     else
       return null; 
   }
   public pageReference validatorhost(){
   
      if(hAcc.BillingState.length() != 2){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Two Letter State Code'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }
        else if(hAcc.BillingPostalcode.length() != 5){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter 5 digit Zip'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }
        else if(hAcc.EIN__c.length() !=9){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter 9 digit EIN'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }
      /*  else if(hAcc.Phone.length() !=10 ){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter 10 digit Phone'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }
       else if(hAcc.Fax!=null && hAcc.Fax.length() != 10){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter 10 digit Fax'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }*/
        else {
            update hAcc;
            return hca_navigator();  
        } 
    
    }
    public PageReference hca_navigator()
    {
     Pagereference retParam;
     if(ApexPages.currentPage().getParameters().get('nextPage') != null)
     {
       retParam= new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
       String pageref= ApexPages.currentPage().getParameters().get('Id');
       if(ApexPages.currentPage().getParameters().get('Id') != null)
       {
           retParam= new PageReference(ApexPages.currentPage().getParameters().get('nextPage')+'?Id='+pageref); 
       }
       if(ApexPages.currentPage().getParameters().get('reDirectPage') == 'true') {
       retParam.setRedirect(true);
       }
       return retParam;
     }
     return null;
    }
     public void loadContact() {
      Id a_id = Id.valueof(ApexPages.currentPage().getParameters().get('Id'));
     //Account acc = [select id, Name from Account where id =:a_id limit 1];
     hContact.AccountId=a_id;
    }
    public Id gethcAccountId() {
        return hContact.AccountId;
    }
    public Pagereference savehcContact()
    {
        if(hContact!=null)
        {
            upsert hContact;
        }
       PageReference retParam= new PageReference('/apex/igi_hc_view_signer'+'?Id='+hContact.AccountId);
       retParam.setRedirect(true);
       return retParam;
    }
    public void LoadSelectedContact()
   {
     Id c_id = Id.valueof(ApexPages.currentPage().getParameters().get('id'));
     hContact = [select id,AccountId,FirstName,LastName,Email,Phone,Title from Contact where id =: c_id limit 1];
   }
}