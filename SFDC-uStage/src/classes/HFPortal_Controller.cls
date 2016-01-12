public without sharing class HFPortal_Controller {
    private User activeUser;
    //public list<Applicant_Info__c> applicantInfo {get;set;} 
    //private Account accountInfo;
    //public Position__c positionInfo;
    //private list<Match__c> MatchInfoList;
    public Engagement__c engagementInfo {get;set;}
    public string confMatchExists{get;set;}
    public list<Engagement__c> engagementInfoList {get;set;}
    public map<String, String> ProfilePhotoMap {get;set;}
    public map<String, String> NationalityEngagementList {get;set;}
    public String nationalityEng;
    public String UrlFlag;
    public String ProfilePicURL;
    public list<Person_Info__c>FamilyInfoList {get;set;}
    public Applicant_Info__c applicationRecord {get;set;}
    public Applicant_Info__c applicantInfo{get;set;}
    public Map<Id,string> savedMap = new map<Id,string>();
    public Map<Id,string> RecMap = new map<Id,string>();
    public Set<Id> engIds = new Set<Id>(); 
    public Set<Id> comEngIds = new Set<Id>();            
    static list<Engagement__c> studentsResults=new list<Engagement__c>();     
    public String PositionId;
    public String posHostLastName = '';
    public String posProgYear = '';
    // Pagination
    public list<list<EngagementWrapper>> listOfListStudent{get;set;}  
    
    public boolean checkHFStatus{get;set;}
      
    public String limits{set;get;}
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('10','10'));
        //options.add(new SelectOption('20','20'));
        return options;
    }
       
    
    //List of Trip records going to be displayes on Page
    public list<Trip__c> listTrips{get;set;}
    
    //Boolean Variable helpful in rerendering
    public Boolean showTravelForm {get; set;}    
    
    
    /*Variable and Getter Setter for Match__c (Match) record */
    
    //Instance of Match
    public list<Match__c> listMatches{get;set;}
    public Match__c match {get; set;}
    
    
       
    
    //  Filters 
    public list<SelectOption> nationality{get;set;}
    public set<SelectOption> nationalitySubSet;
    public string nationalitySelected{get;set;}
    public string ptName{get;set;}
    
    public list<SelectOption> gender{get;set;}
    public string genderSelected{get;set;}
    
    public list<SelectOption> ageRange{get;set;}
    public list<String> ageRangeSelected{get;set;}
    
    //ay2 715
    public list<SelectOption> studInterest{get;set;}
    public list<string> studInterestSelected{get;set;}
    
    public String getConfMatchText(){
        string txt='Confirmed as your exchange student';
        return txt;
    }
    public list<SelectOption> religion{get;set;}
    public string religionSelected{get;set;}
    
  //  public list<SelectOption> progDuration{get;set;}
   // public set<SelectOption> progDurationSubSet;
    public string ProgDurationSelected{get;set;}
    
    public String MatchStatusSelected{set;get;}
    public List<SelectOption> getMatchStatus(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Saved Students','Saved Students'));
        options.add(new SelectOption('Recommended Students','Recommended Students'));
        options.add(new SelectOption('Saved and Recommended','Saved and Recommended'));
        return options;
    }
    //AY2 771. Arranged Alphabetical order
     public List<SelectOption> getProgDuration(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Academic Year','Academic Year'));
        options.add(new SelectOption('Fall Semester','Fall Semester'));        
        options.add(new SelectOption('Spring Semester','Spring Semester'));
        return options;
    }
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
    
    
    // Pagination
    public list<SelectOption> SortBy{get;set;}
    public list<SelectOption> SortByDirection{get;set;}
    Integer PAGE_SIZE;
    public Integer pageNumber {get; set;}
    public Integer totalPageNumber {get; set;}
    //String helpful in sorting
    //public String sortDirection = 'ASC';
    //public String sortExp = 'Name';
    
    //String to hold sorting full Expression
    String sortFullExp;
    
    //Getter Setter for getting the value for Sort Expression
    public string sortExpression{get;set;}
    public string sortDirection{get;set;}
    
    //AY2 765
    public void ReverseOrder(){     
        {                       
          //if the column is clicked on then switch between Ascending and Descending modes          
                sortDirection = (sortDirection =='DESC')? 'ASC' : 'DESC';//changed               
        }
        searchStudentsList();
    }
            
    public boolean photosAlreadyRetrieved = false;
    
    public list<EngagementWrapper> studentList{get{ 
        if(ListOfListStudent!=null && ListOfListStudent.size()>0)    
        return ListOfListStudent[pageNumber];
        else return new List<EngagementWrapper>();
        }
      
    set;}
    
    public list<Intrax_Program_Upload__c> StudentPhotosList {get;set;}
    
    public String responseXML{get; set;}
    public String returnURL{get; set;}
    public list<String> returnURLList{get; set;}
     public List<EngagementWrapper> confStudentList
    {get{ 
        if(ListOfListStudent!=null && ListOfListStudent.size()>0)    
        return ListOfListStudent[pageNumber];
        else return new List<EngagementWrapper>();
        }
      
    set;}
      //  return lstEngagementWrapper;
    
    public void resetPageNumberAndTotalPageNumber() {
        
        //Setting value of the variables
        pageNumber = 0;
        totalPageNumber = 1;
        
    }
    
    map<String, Applicant_Info__c> mapAppToEng = new map<String, Applicant_Info__c>();
    public List<EngagementWrapper> engListWrap {get; set;}
    public List<Engagement__c> selectedEngs {get; set;}
     
    public List<EngagementWrapper> lstEngagementWrapper = new List<EngagementWrapper>(); 
    public void GetPosConfMatchesList(List<Position__c> lstHFPositions)
    {
        set<Id> ConfMatchEngIds=new set<Id>();
        Set<Id> HFPosIds = new set<Id>();
        for(Position__c pos : lstHFPositions)
        HFPosIds.add(pos.Id);
        ProfilePhotoMap = new map<String, String>();
        NationalityEngagementList = new map<String, String>();  
        listOfListStudent = new list<list<EngagementWrapper>>();    
        resetPageNumberAndTotalPageNumber();
        List<Engagement__c> ConfMatchesEngs = new List<Engagement__c>();
         List<Match__c> confirmedMatches = [SELECT Id,Status__c,Engagement__c,CreatedDate,Start_Date__c, Recommendation_Expiration__c FROM Match__c WHERE Position_Name__c in :HFPosIds and status__c='Confirmed' order by Start_Date__c Desc];
         system.debug('****confirmedMatches*******'+confirmedMatches);
         if(confirmedMatches!=null && confirmedMatches.size()>0)
         {
            for(Match__c m: confirmedMatches)
            ConfMatchEngIds.add(m.Engagement__c);
         system.debug('****ConfMatchEngIds*******'+ConfMatchEngIds);
         if(ConfMatchEngIds!=null)
         {
          ConfMatchesEngs = [SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name,Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c, Priority_Engagement__c,(Select Name, Start_Date__c From Matches__r order by Start_Date__c Desc) FROM Engagement__c WHERE id in :ConfMatchEngIds ];              
             system.debug('****ConfMatchesEngs*******'+ConfMatchesEngs);
             for(Engagement__c eng:ConfMatchesEngs)
             {  
                 system.debug('****eng*******'+eng);     
            EngagementWrapper ObjEngagementWrapper = new EngagementWrapper(eng);
            ObjEngagementWrapper.EngWrapId = eng.Id;
            ObjEngagementWrapper.eng = eng;
            ObjEngagementWrapper.displayText = 'Confirmed as your exchange student';
            system.debug('****ObjEngagementWrapper*******'+ObjEngagementWrapper);
            lstEngagementWrapper.add(ObjEngagementWrapper);
            //intCount = ObjtmSurveyWrapper.Counter;
         
             }
               system.debug('*******lstEngagementWrapper***********'+lstEngagementWrapper);   
             string HFIntraxProgram = getHFIntraxProgram();            
            if(lstEngagementWrapper.size() > 0){ 
 
                List<Applicant_Info__c> appRecordList = new List<Applicant_Info__c>();
                           
                //Populating list with record
                appRecordList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount 
                                    FROM Applicant_Info__c 
                                    WHERE Engagement__c IN: ConfMatchEngIds
                                    AND application_stage__c =: 'Accepted'];
                                    
                for(Applicant_Info__c a: appRecordList){  
                    mapAppToEng.put(a.Engagement__c, a);
                }
              system.debug('*******lstEngagementWrapper-2***********'+lstEngagementWrapper);     
            PAGE_SIZE = calculatePageSize(lstEngagementWrapper.size());
         //  getStudentPhotoforConfMatches(lstEngagementWrapper);
            Integer i = 0; 
            
            for(Engagement__c e : ConfMatchesEngs){

                //Create a mam map<IDengagement, StringFlagURL> to get the correct URL of the flag.
                
                if(e.Account_Id__r.Citizenship__pc != null){
                
                system.debug('*****###e.Nationality__c: '+ e.Account_Id__r.Citizenship__pc);
                
                nationalityEng = e.Account_Id__r.Citizenship__pc;               
                nationalityEng = nationalityEng.replace(' ','-');
                nationalityEng = nationalityEng.replace(',', '-');
                //nationalityEng = nationalityEng.replace('','-');
                nationalityEng = nationalityEng.replace('(' ,'-');
                nationalityEng = nationalityEng.replace(')','-');
                nationalityEng = nationalityEng.toLowerCase();
                
                UrlFlag = 'https://s3-us-west-1.amazonaws.com/resources.intraxinc.com/all/common/flags/vs1/' + nationalityEng +'.gif';
                
                system.debug('*****###EngagementFlag: '+ UrlFlag);
                
                NationalityEngagementList.put(e.Id,UrlFlag);
                
                system.debug('*****###NationalityEngagementList: '+ NationalityEngagementList.get(e.Id));
                
                }else{
                
                NationalityEngagementList.put(e.Id,null);
                
                system.debug('*****###NationalityEngagementListNull: '+ NationalityEngagementList.get(e.Id));
                
                }
         }
                 listOfListStudent.add(new List<EngagementWrapper>());
                 
                system.debug('*****###listOfListStudent: '+ listOfListStudent);
                
                //loop through Applicant Info records
                for(EngagementWrapper engInfo : lstEngagementWrapper) {                                        
                    system.debug('*******engInfo Ids:'+engInfo.engwrapId);                   
                                
                    if(i == PAGE_SIZE) {
                        
                        //adding new list to the list of list
                        listOfListStudent.add(new List<EngagementWrapper>());
                        i=0;
                           system.debug('*****###listOfListStudent: '+ listOfListStudent);
                    }
              
                    //adding new list at the index of the list
                    listOfListStudent[listOfListStudent.size()-1].add(engInfo);
                       system.debug('*****###listOfListStudent: '+ listOfListStudent);
                    i++;
                } 
                   system.debug('*****###listOfListStudent: '+ listOfListStudent);
                 getStudentPhotoforCurrentPage();  
            }
           
         }
         }
        
         
          
    }       
    public List<EngagementWrapper> getEngagements()
    {            
        //engListWrap.clear();
        Datetime recommendDate;
        Integer countSaved=0;
        Integer countRec=0;  
        String sRecommend='';
        String recDate='';
             
        Id postId = getPositionId();
        
        if(studentList.size()>0){
            for(EngagementWrapper e : studentList){
            {
            sRecommend='';
            recDate='';
            countSaved=0;
            countRec=0; 
         //   EngagementWrapper ObjtmSurveyWrapper = new EngagementWrapper(e.eng);
           // ObjtmSurveyWrapper.engWrapId = e.eng.Id;
            List<Match__c> savedMatches = [SELECT Id,Status__c,Engagement__c,CreatedDate,Recommendation_Expiration__c FROM Match__c WHERE Engagement__c=:e.eng.Id AND Position_Name__c=:postId];
            if(savedMatches.size()>0){   
                for(Match__c m:savedMatches){              
                    if(m.Status__c=='Saved')
                        countSaved++;                        
                    else if(m.Status__c=='Recommended'){
                        countRec++;                        
                        if(m.Recommendation_Expiration__c!=null){
                            recommendDate = m.Recommendation_Expiration__c;
                        }
                    }
                }
                
                if(countRec > 0){
                    sRecommend= '<i class="icon-thumbs-up-alt icon-2x"></i><br/> <em>Recommended by Ayusa for your family</em>';
                    if(recommendDate != null){
                        recDate = recommendDate.format('MM/dd/yy HH:mm:a');
                        sRecommend = sRecommend + '&nbsp;<em>until</em><br/> <span style="color:red">' +recDate + '</span>';
                    }
                    e.displayText = sRecommend;   
                }
                else if(countSaved > 0){
                    e.displayText = '<i class="icon-star-empty icon-2x "></i><br/> <em>Saved as a student you are interested in hosting. </em>';
                } 
                else
                    e.displayText = '';   
                
            }
            else
                e.displayText = '';
            
           // engListWrap.add(ObjtmSurveyWrapper);
         }                    
        }        
    }
    return studentList;
    }     
    
     public Id getPositionId(){
         
        list<Applicant_Info__c> appInfoHF = [SELECT Id, Account__c, Position__c, Position__r.Status__c, createdDate, Application_Stage__c, CreatedBy__c FROM Applicant_Info__c WHERE CreatedBy__c =: userInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by CreatedDate desc limit 1 ];
        if(appInfoHF.size()>0){
            if(appInfoHF[0].Account__c != NULL){
                List<Position__c> posList = [SELECT Id,Status__c,Host_Company_Id__c,CreatedDate,Host_Company_Id__r.LastName,Program_Year__c FROM Position__c WHERE Host_Company_Id__c=:appInfoHF[0].Account__c ORDER BY CreatedDate DESC LIMIT 1];                
                if(posList.size()>0){
                    PositionId = posList[0].Id;
                    posHostLastName = posList[0].Host_Company_Id__r.LastName;
                    posProgYear = posList[0].Program_Year__c;
                }
            }
        }
        system.debug('******* position Id: ' +positionId); 
        if(PositionId != NULL && PositionId != '')
            return PositionId;
        else 
            return null;     
     }
      public List<Position__c> getPositionList(){
         List<Position__c> posList = new List<Position__c>();
        list<Applicant_Info__c> appInfoHF = [SELECT Id, Account__c, Position__c, Position__r.Status__c, createdDate, Application_Stage__c, CreatedBy__c FROM Applicant_Info__c WHERE CreatedBy__c =: userInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by CreatedDate desc limit 1 ];
        if(appInfoHF.size()>0 && appInfoHF[0].Account__c != NULL){
            posList = [SELECT Id,Status__c,Host_Company_Id__c,CreatedDate,Host_Company_Id__r.LastName,Program_Year__c FROM Position__c WHERE Host_Company_Id__c=:appInfoHF[0].Account__c ORDER BY CreatedDate DESC];                
            if(posList.size()>0 && posList!=null){
                return posList;
            }
            else 
            return null;  
        }       
        else 
            return null;     
     }
     
            
     //Save single match
     public PageReference saveMatch(){
         List<Match__c> lstNewSavedMatch = new list<Match__c>();
        try{
            
            String status = getCheckForSavedMatch();
            //AY2 775   
            if(status != ''){
                //Skips creation of Match. Because Match already created.
            } 
            else{
                //no existing match found. create a new match
                Match__c mOne = new Match__c();            
                            
                PositionId = getPositionId();
                if(PositionId != NULL && PositionId != ''){
                    mOne.Position_Name__c = PositionId;                
                }
                String posHostLN='';
                String posPY='';
                 
                if(posHostLastName!=null){
                    posHostLN = posHostLastName;                
                }
                if(posHostLastName!=null){
                    posPY = posProgYear;                
                }           
                //AY2 761            
                mOne.Name = engagementInfo.Account_Id__r.LastName + ' - '+ posHostLN + ' - ' + 'AY'+ posPY ;              
                mOne.Participant_Id__c = engagementInfo.Account_Id__c;            
                mOne.Engagement__c = engagementInfo.Id;
                mOne.Participant_Opportunity_Id__c = engagementInfo.Opportunity_Id__c;
                mOne.RecordTypeId=Constants.MAT_AYUSA;
                mOne.Status__c = 'Saved';
                lstNewSavedMatch.add(mOne);
                
                if(lstNewSavedMatch.size()>0){
                    insert lstNewSavedMatch;
                } 
            }                                         
        }
        catch (Exception e){
            system.debug('******* Problem creating matches: ' + e);
        }       
        
        return null;       
     
     }
     
     //save selected matches
     public PageReference saveSelectedMatches()
     {      
         List<Match__c> lstNewSavedMatches = new list<Match__c>();     
            system.debug('******* entered selected save: ');     
            System.debug('*****engListWrap size:'+engListWrap.size());  
            
            selectedEngs = new List<Engagement__c>();
            
            for(EngagementWrapper engwrapper : studentlist)
            {                  
                System.debug('*****engwrapper.selected---after  clicking save:'+engwrapper.selected);
                if(engwrapper.selected == true){
                    selectedEngs.add(engwrapper.eng);
                }
            }              
        try{  
            //AY2 775          
            if(selectedEngs!=null)  
            getCheckForSavedMatch(selectedEngs); 
                      
            For(Engagement__c selEng : selectedEngs)
            {    
                //AY2 775                               
                if(savedMap.get(selEng.Id)!=null || RecMap.get(selEng.Id)!=null){
                    //Skips creation of Matches. Because Match already created.
                }
                else{ 
                    system.debug('******* looping thru selecteed ones: ');  
                    Match__c m = new Match__c();
                    String posHostLN='';
                    String posPY='';
                    
                    //m.Name = selEng.Account_Id__r.LastName+'-'+selEng.Account_Id__r.FirstName+'-'+'AY'+selEng.Program_Year__c;
                    m.Participant_Id__c = selEng.Account_Id__c;
                    PositionId = getPositionId();
                    if(PositionId != NULL && PositionId != ''){
                        m.Position_Name__c = PositionId;
                    }
                    
                    if(posHostLastName!=null){
                        posHostLN = posHostLastName;                
                    }
                    if(posHostLastName!=null){
                        posPY = posProgYear;                
                    }           
                    //AY2 761            
                    m.Name = selEng.Account_Id__r.LastName + ' - '+ posHostLN + ' - ' + 'AY'+ posPY ;
                    m.Engagement__c = selEng.Id;
                    m.Participant_Opportunity_Id__c = selEng.Opportunity_Id__c;
                    m.RecordTypeId=Constants.MAT_AYUSA;                
                    m.Status__c = 'Saved';
                    lstNewSavedMatches.add(m);
                    System.debug('-------mName:'+m.Name);
                }           
            }
            system.debug('******* lstNewSavedMatches size: ' + lstNewSavedMatches.size());  
            
            if(lstNewSavedMatches.size()>0){
                insert lstNewSavedMatches;
            }
                                          
        }
        catch (Exception e){
            system.debug('******* Problem creating matches: ' + e);
        }
        
        /*
        PageReference p;
        p = Page.Matches_Saved;
        p.setRedirect(true);
        return p;
        */
        //searchStudentsList();
        getEngagements();
        return null;    
     }    
     
     public string getCheckForSavedMatch(){  
         List<Match__c> savedMatches = new List<Match__c>();    
         String sendStatus='';
         Integer countSaved=0;
         Integer countRec=0;    
         Id postId = getPositionId();        
            System.debug('*****sendStatus****'+sendStatus);                      
            savedMatches = [SELECT Id,Status__c,Engagement__c,CreatedDate FROM Match__c WHERE Engagement__c=:engagementId AND Position_Name__c=:postId];
            System.debug('*****savedMatches size****'+savedMatches.size());
            System.debug('*****savedMatches****'+savedMatches);                  
            if(savedMatches.size()>0){
                for(Match__c m:savedMatches){
                    if(m.Status__c == 'Saved'){ 
                        countSaved++;
                    }
                    else if(m.Status__c == 'Recommended'){
                        countRec++;
                    }
                }             
                if(countRec > 0){
                    sendStatus = 'Recommended by Ayusa for your family';
                }
                else if(countSaved > 0){
                    sendStatus = 'Saved as a student you are interested in hosting';
                }
                else
                    sendStatus = '';
            }
            else sendStatus = '';
            
            return sendStatus;
     }
      public void getCheckForSavedMatch(List<Engagement__c> lstEngs){  
         List<Match__c> savedMatches = new List<Match__c>();           
         set<Id>  setEngIds = new set<Id>();
         String sendStatus='';
         Integer countSaved=0;
         Integer countRec=0;    
         savedMap.clear();
         recMap.clear();
         Id postId = getPositionId(); 
         
            system.debug('*******start savedMap: ' +savedMap);
              system.debug('*******start RecMap: ' +RecMap);
                  
           for(Engagement__c eng:lstEngs) 
           setEngIds.add(eng.Id);
                                  
            savedMatches = [SELECT Id,Status__c,Engagement__c,Recommendation_Expiration__c,CreatedDate FROM Match__c WHERE Engagement__c in :setEngIds AND Position_Name__c=:postId];                  
            system.debug('******* lstEngs: ' +lstEngs);
            if(savedMatches.size()>0){
                for(Match__c m:savedMatches){
                    System.debug('*****m Id****'+m.Id);
                    if(m.Status__c == 'Saved'){
                        System.debug('*****entered saved****');
                        savedMap.put(m.Engagement__c,'<i class="icon-star-empty icon-2x "></i><br/> <em>Saved as a student you are interested in hosting. </em>');
                        //countSaved++;
                    }
                    else if(m.Status__c == 'Recommended'){
                         System.debug('*****entered recommended****');
                         String sRecommend='';
                         String recDate='';
                         Datetime recommendDate;
                        sRecommend = '<i class="icon-thumbs-up-alt icon-2x"></i><br/> <em>Recommended by Ayusa for your family</em>';
                        if(m.Recommendation_Expiration__c!=null){
                            recommendDate = m.Recommendation_Expiration__c;
                            recDate = recommendDate.format('MM/dd/yy HH:mm:a');
                            sRecommend = sRecommend + '&nbsp;<em>until</em><br/> <span style="color:red">' +recDate + '</span>';
                        }                      
                    
                        RecMap.put(m.Engagement__c,sRecommend);
                    }
                    
                }
            }                
             system.debug('*******end savedMap: ' +savedMap);
              system.debug('*******end RecMap: ' +RecMap);
              system.debug('*******end RecMap Id: ' +RecMap.get('a0df00000006BKTAA2'));
              system.debug('*******end savedMap Id: ' +savedMap.get('a0df00000006BKTAA2'));
              
                
     }
     
       
    public void searchStudentsList(){
        //system.debug('***Inside searchStudentsList****sortExp:'+sortExp);
        system.debug('***Inside searchStudentsList****sortExpression:'+sortExpression);
        //sortExpression = sortExp;
        system.debug('***Inside searchStudentsList****');
        list <EngagementWrapper> studentListAux = new list<EngagementWrapper>();
        ProfilePhotoMap = new map<String, String>();
        NationalityEngagementList = new map<String, String>();
        listOfListStudent = new list<list<EngagementWrapper>>();
        resetPageNumberAndTotalPageNumber();
        String posId = getPositionId();
        List<String> lstStatus =  new List<String>();
        lstStatus.add('Requested');
        lstStatus.add('Confirmed');
        
        savedMap.clear();
        recMap.clear();
        System.debug('-----sortExpression in search:'+sortExpression);
        System.debug('-----sortDirection in search:'+sortDirection);
        
        
        //engs with not requested and not confirmed matches
        List<Match__c> recMatches = new List<Match__c>(); 
        recMatches = [SELECT Id,Status__c,Engagement__c,Engagement__r.placement_status__c,Engagement__r.Status__c,Position_Name__c FROM Match__c WHERE Status__c !='Requested' AND Status__c != 'Confirmed' AND Intrax_Program__c = 'Ayusa' AND (Engagement__r.Status__c = 'Processing' OR Engagement__r.Status__c = 'Program Ready') LIMIT 30000];
        system.debug('******recMatches********'+recMatches);
        system.debug('******recMatches size********'+recMatches.size());
        if(recMatches.size()>0 && recMatches!=null){
            for(Match__c rm:recMatches){
                if(rm.Engagement__c!=null)                
                engIds.add(rm.Engagement__c);
            }
        }
        
        system.debug('******engIds before********'+engIds);
        
        //not placed and processing engs
        
        List<Engagement__c> npEngs = new List<Engagement__c>();
        //MT778 (Start)
        //npEngs = [SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName,Account_Id__r.Name, Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c, Status__c FROM Engagement__c WHERE Placement_Status__c = 'Not Placed' AND Status__c = 'Processing' AND Intrax_Program__c INCLUDES ('Ayusa') LIMIT 250];
        string npEngsString = 'SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName,Account_Id__r.Name,'
        +' Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c, Status__c, Priority_Engagement__c FROM Engagement__c WHERE Placement_Status__c = \'Not Placed\' AND (Status__c = \'Processing\' OR Status__c = \'Program Ready\') AND '
        + 'Intrax_Program__c INCLUDES (\'Ayusa\') ';
                        
        //Starting the filter logic
        if(nationalitySelected != null && nationalitySelected != ''){
            npEngsString += ' AND  Nationality__c = \'' + nationalitySelected + '\' ';
        }        
        if(ptName != null && ptName != ''){
            string npVar = String.escapeSingleQuotes(ptName);           
            npEngsString += ' AND Account_Id__r.FirstName Like \'%' + npVar.replaceAll('\\*','%') + '%\' ';           
        }
        if(genderSelected != null && genderSelected != ''){
            npEngsString += ' AND Gender__c = \'' + genderSelected + '\' ';
        }
        if(studInterestSelected != null && studInterestSelected.size()>0)
        {
            String slist = '';
            boolean blnNoneExists=false;  
            integer len=0;
            len = studInterestSelected.size();
            for(String s : studInterestSelected) 
            {
              if(len==1 && s.equals(''))
                 blnNoneExists = true;             
            }     
            if(!blnNoneExists)
            {
               for (String s: studInterestSelected) 
               {
                slist += '\'' + s + '\',';              
               }
                slist = slist.substring (0,slist.length() -1);         
                npEngsString = npEngsString + ' AND Interests_top__c  INCLUDES (' + slist + ') ' ;          
                System.debug('npEngsStringSOQL-studInterestSelected::::::::::'+npEngsString);
            }         
        }
        if(progDurationSelected != null && progDurationSelected != ''){
            npEngsString += ' AND Program_Duration__c = \'' + progDurationSelected + '\' ';
        }
        
        if(AgeRangeSelected.size() > 0){
            npEngsString += ' AND Age_At_Program_Start__c IN ' + AgeRangeSelected + '  ';
        }           
        //end of filters
        
        npEngsString = processSOQLQueryString(npEngsString);        
        npEngs = Database.query(npEngsString + ' ORDER BY Name ASC LIMIT 250');
        //MT778 (End)
        system.debug('******npEngs size********'+npEngs.size());
        if(npEngs.size()>0 && npEngs!=null){
            for(Engagement__c npEng:npEngs){
                engIds.add(npEng.Id);
            }
        }
        
        //requested and confirmed matches of the notPlaced engs
        Set<Id> exEngs = new Set<Id>();
        List<Match__c> reqMatches = new List<Match__c>(); 
        if(engIds!=null && engIds.size()>0){
            reqMatches = [SELECT Id,Status__c,Engagement__c,engagement__r.placement_status__c,Position_Name__c FROM Match__c WHERE (Status__c ='Requested' OR Status__c ='Confirmed') AND Intrax_Program__c = 'Ayusa' AND Engagement__c IN:engIds];
            if(reqMatches.size()>0 && reqMatches!=null){
                for(Match__c m:reqMatches){
                    exEngs.add(m.Engagement__c);
                }
            }
        }
        system.debug('******exEngs size********'+exEngs.size());
        
        //excluding the requested and confirmed engs
        if(exEngs.size()>0 && exEngs!=null && engIds.size()>0 && engIds!=null){
            for(Id n:exEngs){
                if(engIds.contains(n)){
                    engIds.remove(n);
                }
            }
        }
        system.debug('******engIds size after removal********'+engIds.size());
                
                
        system.debug('******engIds end ********'+engIds);        
        string SOQLforStudentlist = 'SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name, Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c, Priority_Engagement__c' +
                                        ' FROM Engagement__c ' +
                                        ' WHERE Id IN:engIds ';
                                        
        //Starting the filter logic
        if(nationalitySelected != null && nationalitySelected != ''){
            SOQLforStudentlist += ' AND  Nationality__c = \'' + nationalitySelected + '\' ';
        }
        
        //AY2 755
        if(ptName != null && ptName != ''){
            string ptVar = String.escapeSingleQuotes(ptName);           
            SOQLforStudentlist += ' AND Account_Id__r.FirstName Like \'%' + ptVar.replaceAll('\\*','%') + '%\' ';           
        }
        
        if(genderSelected != null && genderSelected != ''){
            SOQLforStudentlist += ' AND Gender__c = \'' + genderSelected + '\' ';
        }               
     
            if(studInterestSelected != null && studInterestSelected.size()>0)
                {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = studInterestSelected.size();
                for(String s : studInterestSelected) 
                {
                  if(len==1 && s.equals(''))
                     blnNoneExists = true;
                 
           }
         
           System.debug('studInterestSelected::::::::::'+studInterestSelected);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
             for (String s: studInterestSelected) 
             {
          slist += '\'' + s + '\',';
            System.debug('SOQLforStudentlist-slist::::::::::'+slist);
          }
          slist = slist.substring (0,slist.length() -1);
       
         SOQLforStudentlist = SOQLforStudentlist + ' AND Interests_top__c  INCLUDES (' + slist + ') ' ;
        
                System.debug('SOQLQuery-studInterestSelected::::::::::'+SOQLforStudentlist);
          }         
          }
       
        if(progDurationSelected != null && progDurationSelected != ''){
            SOQLforStudentlist += ' AND Program_Duration__c = \'' + progDurationSelected + '\' ';
        }
        
        if(AgeRangeSelected.size() > 0){
            SOQLforStudentlist += ' AND Age_At_Program_Start__c IN ' + AgeRangeSelected + '  ';
        }   
        
        
        SOQLforStudentlist = processSOQLQueryString(SOQLforStudentlist);
         system.debug('******** SOQLforStudentList: ' + SOQLforStudentList);
        
        try{
            System.debug('****studentsResults:SortExpression:'+SortExpression);
            System.debug('****studentsResults:SortDirection:'+SortDirection);
            
            studentsResults = database.query(SOQLforStudentlist + ' ORDER BY ' + SortExpression + ' ' + SortDirection);            
            System.debug('****studentsResults:'+studentsResults);
            System.debug('****studentsResults size:'+studentsResults.size());      
              
            //ay2 715. logic for matches filter - saved, recommended
            Set<Id> allEngIds = new Set<Id>();
            Set<Id> savedEngIds = new Set<Id>();
            Set<Id> recEngIds = new Set<Id>();
            Set<Id> SelectedEngs = new Set<Id>();
               system.debug('****MatchStatusSelected********'+MatchStatusSelected);
            //match stats filter
            if(MatchStatusSelected !='' && MatchStatusSelected != null){ 
            system.debug('******match filter entered********');
                for(Engagement__c allEng:studentsResults){
                    allEngIds.add(allEng.Id);                                
                } 
               List<Match__c>  SelectedMatches = new list<Match__c>();
                Id postId = getPositionId();
                string SOQLQuery;         
                SOQLQuery='SELECT Id,Status__c,Engagement__c FROM Match__c WHERE Engagement__c IN:allEngIds AND Position_Name__c=:postId ';
               
                    if(MatchStatusSelected=='Saved Students'){
                       SOQLQuery+=' AND  Status__c=\'Saved\' ';                       
                    }
                    else if(MatchStatusSelected=='Recommended Students'){
                       SOQLQuery+=' AND  Status__c=\'Recommended\' ';                       
                    }
                    else  if(MatchStatusSelected=='Saved and Recommended'){
                       SOQLQuery+=' AND ( Status__c=\'Saved\' or  Status__c=\'Recommended\' ) ';                       
                    }
              SOQLQuery = processSOQLQueryString(SOQLQuery);
               SelectedMatches= Database.query(SOQLQuery);
                system.debug('****SelectedMatches********'+SelectedMatches);
                if(SelectedMatches!=null && SelectedMatches.size()>0){
                    for(Match__c match:SelectedMatches){
                        SelectedEngs.add(match.Engagement__c);
                    }
                
              
                if(SelectedEngs.size()>0){
                    string finQuery = 'SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name, Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c, Priority_Engagement__c' +
                                                ' FROM Engagement__c ' +
                                                ' WHERE Id IN: SelectedEngs';
                    
                  //  studentsResults.clear();
                  
                   studentsResults = database.query(finQuery + ' ORDER By ' + SortExpression + ' ' + SortDirection);
                    System.debug('-------studentsResults if selected'+studentsResults.size());  
                }
                }
                else studentsResults.clear();
            }
           System.debug('****studentsResults size:'+studentsResults.size()); 
            //applicant info religion filter            
           Set<Id> RelEngIds = new Set<Id>();
            Set<Id> engAppInfo = new Set<Id>();
            System.debug('-------religionSelected'+religionSelected);  
            if(religionSelected != '' && religionSelected != null){
                system.debug('******religion filter entered********');
                  System.debug('-------studentsResults'+studentsResults);  
                for(Engagement__c allEng:studentsResults){
                    RelEngIds.add(allEng.Id);                                
                }                
                
                List<Applicant_Info__c> appInfoList = [SELECT Id,Name,Religion__c,Engagement__c FROM Applicant_Info__c WHERE Engagement__c IN:RelEngIds and Religion__c =: religionSelected];
                if(appInfoList.size()>0){
                    for(Applicant_Info__c app:appInfoList){                     
                            engAppInfo.add(app.Engagement__c);
                    }
                }
                
                if(engAppInfo.size()>0){
                    string regQuery = 'SELECT Id, Name, Placement_Status__c,Opportunity_Id__c,Match_Notes__c,Intrax_Program__c, Program_year__c,Program_Duration__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name, Account_Id__r.Citizenship__pc, Account_Id__r.isPersonAccount, Interests_Top__c, Nationality__c, Gender__c, Priority_Engagement__c' +
                                                ' FROM Engagement__c ' +
                                                ' WHERE Id IN: engAppInfo';
                                            
                    //studentsResults.clear();
                    
                    studentsResults = database.query(regQuery + ' ORDER By ' + SortExpression + ' ' + SortDirection);
                }
                 else studentsResults.clear();
            }            
            //715.end of match filters                      
            
            System.debug('-------studentsResults'+studentsResults.size());  
            System.debug('-------studentsResults'+studentsResults);
            
            //MT 345. Start            
            if(studentsResults.size() > 0){
                List<Engagement__c> priorList = new List<Engagement__c>();
                List<Engagement__c> restList = new List<Engagement__c>();
                
                for(Engagement__c en: studentsResults){
                    if(en.Priority_Engagement__c == TRUE){                      
                        priorList.add(en);                      
                    }
                    else{                       
                        restList.add(en);
                    }
                }
                System.debug('-------priorList'+priorList);
                System.debug('-------restList'+restList);
                
                studentsResults.clear();
                priorList.sort(); //Piority List will be always sorted by Name Asc.
                
                for(Engagement__c prior: priorList){
                    studentsResults.add(prior);
                    System.debug('-------studentsResults:after prior'+studentsResults);
                }
                for(Engagement__c rest: restList){
                    studentsResults.add(rest);
                    System.debug('-------studentsResults:after rest'+studentsResults);
                }                               
            }
            //MT 345. End
            
            string HFIntraxProgram = getHFIntraxProgram();                                
            if(studentsResults.size() > 0){
 
                List<Applicant_Info__c> appRecordList = new List<Applicant_Info__c>();
                           
                //Populating list with record
                appRecordList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount 
                                    FROM Applicant_Info__c 
                                    WHERE Engagement__c IN: studentsResults
                                    AND application_stage__c =: 'Accepted'];
                                    
                for(Applicant_Info__c a: appRecordList){
                    mapAppToEng.put(a.Engagement__c, a);
                }
                    
            
            
            for(Engagement__c e : studentsResults){

                //Create a mam map<IDengagement, StringFlagURL> to get the correct URL of the flag.
                
                if(e.Account_Id__r.Citizenship__pc != null){
                
                system.debug('*****###e.Nationality__c: '+ e.Account_Id__r.Citizenship__pc);
                
                nationalityEng = e.Account_Id__r.Citizenship__pc;               
                nationalityEng = nationalityEng.replace(' ','-');
                nationalityEng = nationalityEng.replace(',', '-');
                //nationalityEng = nationalityEng.replace('','-');
                nationalityEng = nationalityEng.replace('(' ,'-');
                nationalityEng = nationalityEng.replace(')','-');
                nationalityEng = nationalityEng.toLowerCase();
                
                UrlFlag = 'https://s3-us-west-1.amazonaws.com/resources.intraxinc.com/all/common/flags/vs1/' + nationalityEng +'.gif';
                
                system.debug('*****###EngagementFlag: '+ UrlFlag);
                
                NationalityEngagementList.put(e.Id,UrlFlag);
                
                system.debug('*****###NationalityEngagementList: '+ NationalityEngagementList.get(e.Id));
                
                }else{
                
                NationalityEngagementList.put(e.Id,null);
                
                system.debug('*****###NationalityEngagementListNull: '+ NationalityEngagementList.get(e.Id));
                
                }
                
               
                if((IUtilities.isIncluded(HFIntraxProgram, e.Intrax_Program__c) || HFIntraxProgram == null) && mapAppToEng.get(e.Id) != null){
                  
                    // Getting student nationality for the filter
                    system.debug('***** Nationality: ' + e.Nationality__c);
                    if(e.Nationality__c != null && e.Nationality__c != '') nationalitySubSet.add(new SelectOption(e.Nationality__c, e.Nationality__c));                    
                    //if(e.Program_Duration__c!=null && e.Program_Duration__c!='') progDurationSubSet.add(new SelectOption(e.Program_Duration__c,e.Program_Duration__c));
                    //if(e.Interests_top__c!=null && e.Interests_top__c!='') studInterest.add(new SelectOption(e.Interests_top__c,e.Interests_top__c));
                    studentListAux.add(new engagementwrapper(e));
                }
                
                
            }
            
            nationality.AddAll(nationalitySubSet);
            nationality.sort();
            
           // progDuration.AddAll(progDurationSubSet);
           // progDuration.sort();
            
            //system.debug('*****### ProfilePhotoMap,size(): ' + ProfilePhotoMap.size());
            
            System.debug('@@@@@@value in applicantRecords ' + studentListAux);
            System.debug('@@@@@@value in pageNumber ' + pageNumber);
            //Populating list of list with value
            listOfListStudent.add(new List<EngagementWrapper>());
            
            //Integer helpful for list of list population
           
    
            //Check for size of list
            getCheckForSavedMatch(studentsResults);
            
            }
            
            if(studentListAux != null && studentListAux.size() > 0) {
               Integer i = 0;  
                //Setting Page Size value
                PAGE_SIZE = calculatePageSize(studentListAux.size());
                system.debug('******* studentsResults not filter: ' +studentsResults);
                
                system.debug('******* savedMap: ' +savedMap);
                system.debug('******* RecMap: ' +RecMap);
                system.debug('******* studentListAux: ' +studentListAux);                
                
                //loop through Applicant Info records
                for(EngagementWrapper engInfo : studentListAux) {                                        
                    system.debug('*******engInfo Ids:'+engInfo.engwrapId);                   
                    if(savedMap!=null)
                    {
                        if(savedMap.get(engInfo.engwrapId)!=null){
                            engInfo.displayText = savedMap.get(engInfo.engwrapId) ;                            
                        }                        
                    }
                    else{
                        engInfo.displayText='';
                    }
                    
                    if(RecMap!=null)
                    {
                        if(RecMap.get(engInfo.engwrapId)!=null){
                            engInfo.displayText = RecMap.get(engInfo.engwrapId) ;
                        }                        
                    }
                    else{
                        engInfo.displayText='';
                    }
                    system.debug('*******engInfo.displayText:'+engInfo.displayText);
                    
                    if(engInfo.displayText==NULL){                        
                        engInfo.displayText='';
                        system.debug('*******entered null:'+engInfo.displayText);
                    }
                    system.debug('******* engInfo: ' +engInfo);
                    
                    //Checking for integer value                
                    if(i == PAGE_SIZE) {
                        
                        //adding new list to the list of list
                        listOfListStudent.add(new List<EngagementWrapper>());
                        i=0;
                    }
              
                    //adding new list at the index of the list
                    listOfListStudent[listOfListStudent.size()-1].add(engInfo);
                    i++;
                }
                
                 getStudentPhotoforCurrentPage();  
            }
               system.debug('***Inside searchStudentsList listOfListStudent****'+listOfListStudent);
         system.debug('******** engIds: ' + engIds);   //getStudentPhotoforCurrentPage(); 
          
              
        }catch (Exception e){
            system.debug('******* Problem retrieving student records: ' + e);
        }

    }
    
    public void getStudentPhotoforCurrentPage (){
        list<EngagementWrapper> StudentPageList = listOfListStudent[pageNumber];
        System.debug('-----StudentPageList:'+StudentPageList);
        List<Engagement__c> engs =  new list<Engagement__c>();
        for(EngagementWrapper engw : StudentPageList)
        {
        engs.add(engw.eng); 
        }
        ProfilePhotoMap = IUtilities.getParticipantPhotoList(engs, mapAppToEng);
        system.debug('******ProfilePhotoMap**********'+ProfilePhotoMap);
    }
    
    
    /* ORIGINAL CODE
    public void getStudentPhotoforCurrentPage (){
        list<Engagement__c> StudentPageList = listOfListStudent[pageNumber];
        system.debug('****** Number of records in page:' + StudentPageList.size());
        if(StudentPageList.size() > 0){
            for(Engagement__c e: StudentPageList){
                
                ProfilePicURL = '';
                
                if(mapAppToEng.get(e.Id) != null){
                    profilePicURL = IUtilities.getParticipantPhoto(mapAppToEng.get(e.Id));
                }
                
                //Adding the profile picture to the Map
                if(ProfilePicURL == ''){
                    ProfilePicURL = 'no-picture';
                }
                
                ProfilePhotoMap.put(e.Id, ProfilePicURL);
                //system.debug('*****### ProfilePhotoMap[item] loop: ' + ProfilePhotoMap.get(e.Id));
                    
            } 
        }     
    }
    */
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
    
    
    //method for next button
    public void previous(){
      
        //Check list of list for size
        if(listOfListStudent.size() != 0) {
           
            //Decrease page number by 1
            pageNumber-=1;
            totalPageNumber = pageNumber + 1;
        }
        getStudentPhotoforCurrentPage(); 
    }
    
    //method for next button
    public void next(){
        System.debug('---------listOfListStudent:'+listOfListStudent.size());
        //Checking for size of list of list
        if(listOfListStudent.size() >= 0) {
        
            //Increase page number by 1
            totalPageNumber= pageNumber + 1;
            pageNumber+=1;
            totalPageNumber +=1;
        } 
        getStudentPhotoforCurrentPage(); 
        system.debug('******back in next**********');
        //return null;
       
    }
    
    //method for first button
    public void first(){
      
        //Checking for size of list of list
        if(listOfListStudent.size() >= 0) {
         
            //Increase page number by 1
            pageNumber = 0;
            totalPageNumber = 1;
        } 
        getStudentPhotoforCurrentPage(); 
    }
    
    //method for Last button
    public void last(){
      
        //Checking for size of list of list
        if(listOfListStudent.size() >= 0) {
            //Increase page number by 1
            pageNumber = listOfListStudent.size() -1;
            totalPageNumber = listOfListStudent.size();
        } 
        getStudentPhotoforCurrentPage(); 
    }
    
    //Method to disable next button 
    public Boolean getNextButtonDisabled(){
 
        //disable when Index of the page is equal to total number of index OR WHEN THERE 
        return (pageNumber == listOfListStudent.size() || pageNumber == listOfListStudent.size()-1);
    }
    
    //Method to disable previous button 
    public Boolean getPreviousButtonDisabled(){
 
        //or when multiplication of current page no. and page size is > then applicantInfo list 
        return (pageNumber == listOfListStudent.size() || pageNumber == 0);
    }
    
    
    public boolean getCheckHFPositionStatus(){
        try{
                      
            list<Applicant_Info__c> appInfoHF = [SELECT Id, Account__c, Position__c, Position__r.Status__c, createdDate, Application_Stage__c, CreatedBy__c FROM Applicant_Info__c WHERE CreatedBy__c =: userInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by CreatedDate desc limit 1 ];
            system.debug('******appInfoHF******'+appInfoHF);
            //AY2 - 708. Checking for Latest Position's Status. Application Stage condition removed
            if(appInfoHF.size()>0 && appInfoHF!=null)
            {
                if(appInfoHF[0].Account__c !=NULL)
                {          
                List<Position__c> posList = [SELECT Id,Status__c,Host_Company_Id__c,CreatedDate,Host_Company_Id__r.LastName,Program_Year__c FROM Position__c WHERE Host_Company_Id__c=:appInfoHF[0].Account__c ORDER BY CreatedDate DESC LIMIT 1];                
                if(posList.size()>0 && posList!=null)
                 {
                    if(posList[0].Status__c == 'Matching')
                    return true;
                }
                else return false;
            }
            }
            return false;

        }catch(Exception e){
            system.debug('******** There are no applications for this user. ');
            return false;
        }
    }
    
    public string getHFIntraxProgram(){
        list<Applicant_Info__c> appInfoHF = [SELECT Id, Position__c, Position__r.Status__c, createdDate, Application_Stage__c, CreatedBy__c, Intrax_Program__c FROM Applicant_Info__c WHERE CreatedBy__c =: userInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by CreatedDate desc limit 1 ];
        
        if(appInfoHF.size() > 0 ){
            return appInfoHF[0].Intrax_Program__c;
        }
        else return null;
        
    }
    
    public String engagementId;
    
    public HFPortal_Controller(){
        savedMap.clear();
        recMap.clear();
            //this.engListWrap = new List<EngagementWrapper>();
            //getEngagements();
           system.debug('***Inside Constructor****');
              system.debug('***Inside Parameters****'+ApexPages.currentPage().getParameters().get('ConfMatch') );   
               
        // Initializing stuff...
        SortBy = new list<SelectOption>();
        SortBy.add(new SelectOption('Name', 'Name'));
        SortBy.add( new SelectOption('Program_Duration__c', 'Program Duration'));
        
        //AY2 765
        sortExpression = 'Name';
        sortDirection = 'ASC';
        
        ageRangeSelected =  new list<String>();
        
        ageRange = new list<SelectOption>();
        
        ageRange.add(new SelectOption('15', '15'));
        ageRange.add(new SelectOption('16', '16'));
        ageRange.add(new SelectOption('17', '17'));
        ageRange.add(new SelectOption('18', '18'));
        
        
        //Setting default values for the varaiables
        pageNumber = 0;
        totalPageNumber = 1; 
        limits = '5';
        
        Account a = new Account();
        nationality = new list<SelectOption>();
        nationalitySubSet = new set<SelectOption>();
        
        //nationality = getPickValues(a, 'Nationality__pc', null);
        engagementInfo = new Engagement__c();
        gender = getPickValues(engagementInfo, 'Gender__c', null);
        
        studInterest = getPickValues(engagementInfo, 'Interests_top__c', null);
        
        //progDuration = new List<SelectOption>();
        //progDurationSubSet = new set<SelectOption>();
        
        engagementId = ApexPages.currentPage().getParameters().get('participantId');
        
        applicantInfo = new Applicant_Info__c();
        religion = getPickValues(applicantInfo, 'Religion__c', null);
        
        
        showTravelForm = false;
        
        
        // Checking for the Participant Trips
        listTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, 
                        Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__c,
                        Match__r.Engagement__r.Name, Match__r.Engagement__r.Id,Engagement__r.Name,Engagement__c,
                        Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c,
                        Engagement__r.Intrax_Program__c, Departure_Date_Time__c, Arrival_Date_Time__c
                        FROM Trip__c
                        WHERE Engagement__c =: engagementId];
        
        //to get match start date and end date
        Id postId = getPositionId();
        if(engagementId != NULL){
        listMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c,Double_Placement__c, Single_No_Children__c FROM Match__c 
                                WHERE (status__c =: 'Confirmed' OR status__c =: 'Completed' OR status__c =: 'Ended Early') 
                                AND Engagement__c =: engagementId ORDER BY Start_Date__c desc];
        }                    
        if(listMatches!=null && listMatches.size()>0){
            match = listMatches[0];         
        }
        else
            match = new Match__c();
                                      
        // We need to know if the current HF position is in a 'Matching' stage
        checkHFStatus = getCheckHFPositionStatus();
        system.debug('******** checkHFStatus: ' + checkHFStatus);
        
        if(engagementId != null){
            engagementInfo = [SELECT Id, Name, Match_Notes__c, Opportunity_Id__c,Account_Id__r.isPersonAccount, Account_Id__r.Religion__pc, Account_Id__r.LastName, Account_Id__r.FirstName, Account_Id__r.Name, Age_At_Program_Start__c, Nationality__c, Account_Id__r.Citizenship__pc, Gender__c, Program_Year__c, Program_Duration__c, status__c, Interests_Top__c, Language_1__c, Language_1_Proficiency__c,
                                    Intrax_Program_Options__c,Language_2__c, Language_2_Proficiency__c, Language_3__c, Language_3_Proficiency__c, Live_With_Pets__c, Double_Placement_Indicated__c, single_no_children_indicated__c, Private_high_school_indicated__c, Priority_Engagement__c
                                    FROM Engagement__c
                                    WHERE Id =: engagementId limit 1];
        
            //Application list
            List<Applicant_Info__c> applicantRecordList = new List<Applicant_Info__c>();
                           
            //Populating list with record 
            applicantRecordList = [SELECT ID, PhotoId__c, General_Summary__c, English_Summary__c,  application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c FROM Applicant_Info__c WHERE Engagement__c =: engagementInfo.Id LIMIT 1];
            
            //Checking for null value
            if(applicantRecordList != null && applicantRecordList.size() > 0) {
            
                //Getting Application record
                applicationRecord =  applicantRecordList[0];
                
                if(applicationRecord != null) {
                    
                    FamilyInfoList = [SELECT ID, Name, First_Name__c, Last_Name__c, Gender__c, Age__c, Role__c, Primary_Applicant__c, Profession__c 
                                       FROM Person_Info__c 
                                       WHERE Applicant_Info__c =: applicationRecord.Id AND ( Role__c =: 'Parent' OR Role__c =: 'Sibling')];
                    getStudentGoalsEssay(applicationRecord.Id);
                    getStudentVolunteerEssay(applicationRecord.Id);
                    getStudentInterestsEssay(applicationRecord.Id);
                    getStudentLetterEssay(applicationRecord.Id);
                    //create a list with most recent 3 family student pictures 
                    StudentPhotosList = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c , d.createdDate
                                            from Intrax_Program_Upload__c d
                                            where d.Applicant_Info__c =: applicationRecord.Id AND d.Document_Type__c = 'Family' order by d.createdDate desc limit 3 ];  
    
                  system.debug('*******StudentPhotosList**********'+StudentPhotosList);
                    // Instantiate a new http object 
                    
                    returnURL = IUtilities.getParticipantPhoto(applicationRecord);
                       system.debug('*******returnURL**********'+returnURL);
                    returnURLList = IUtilities.getParticipantFamilyPhotos(applicationRecord); 
                       system.debug('*******returnURLList**********'+returnURLList); 
                }                              
            }
        }           
        else
            if(ApexPages.currentPage().getParameters().get('ConfMatch')== 'true' )
            {
            confMatchExists = ApexPages.currentPage().getParameters().get('ConfMatch');
           
            List<Position__c> lstPositions= getPositionList();
            if(confMatchExists=='true'){                
                if(lstPositions!=null && lstPositions.size()>0)
                    GetPosConfMatchesList(lstPositions);            
            }
                  system.debug('***Inside Constructor else****');
            }
        else  if(ApexPages.currentPage().getParameters().get('ShowRecommended')== 'true' )
            {
            MatchStatusSelected='Recommended Students';
            searchStudentsList();
          
            }
            else{           
                
            searchStudentsList();
            //studentList = new list<EngagementWrapper>();
        }
     
        
    }
   
    public Essay__c studentGoals{get;set;}
    public void getStudentGoalsEssay(string appInfoId){
        studentGoals = [SELECT Id, Name, Label__c, Narrative__c, Applicant_Info__c FROM Essay__c WHERE Applicant_Info__c =: appInfoId AND Name = 'Goals'];
        system.debug('***studentGoals****'+studentGoals);
    }
    
    public Essay__c studentLetter{get;set;}
    public void getStudentLetterEssay(string appInfoId){
        studentLetter = [SELECT Id, Name, Label__c, Narrative__c, Applicant_Info__c FROM Essay__c WHERE Applicant_Info__c =: appInfoId AND Name = 'Student Letter'];
         system.debug('***studentLetter****'+studentLetter); 
    }
    public Essay__c studentInterests{get;set;}
    public void getStudentInterestsEssay(string appInfoId){
        studentInterests = [SELECT Id, Name, Label__c, Narrative__c, Applicant_Info__c FROM Essay__c WHERE Applicant_Info__c =: appInfoId AND Name = 'Interest'];
         system.debug('***studentInterests****'+studentInterests); 
    }
    
    public Essay__c studentVolunteer{get;set;}
    public void getStudentVolunteerEssay(string appInfoId){
        studentVolunteer = new Essay__c();
        studentVolunteer = [SELECT Id, Name, Label__c, Narrative__c, Applicant_Info__c FROM Essay__c WHERE Applicant_Info__c =: appInfoId AND Name = 'Volunteer'];
         system.debug('***studentVolunteer****'+studentVolunteer); 
    }
    
     public PageReference checkLogin(){      
        
     engListWrap = new List<EngagementWrapper>();
     getEngagements();  
       
        PageReference p;
            system.debug('USERTYPE '+userInfo.getUserType());
        if (userInfo.getUserType() == 'Guest'){
            p = Page.AppEngine_SiteLoginPage;
            p = IUtilities.rewriteUrl(p);
            p.setRedirect(true);
        }
         system.debug('***Exit CheckLogin****');
        return p;
        
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
        
    public class EngagementWrapper
    {
        public Engagement__c eng{get; set;}
        public Boolean selected{get; set;}  
        public String displayText {get;set;} 
        public Id EngWrapId {get;set;}            
        
        public EngagementWrapper(Engagement__c e)
        {
           eng = e;
           EngWrapId = e.Id;
           selected = false;
           displayText = '';
         
           System.debug('*****e:'+e);
           System.debug('*****selected:'+selected);
        }
    }

  
}