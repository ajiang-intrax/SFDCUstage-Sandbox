public without sharing class search_controller {
    
    // Test variables
    //public final string appId = 'a0U19000000Y8gE';
    public final string appId = '';
    // End test Variables
        
    public map<string, map<String, set<String>>> myfilters {get;set;}
    public map<string, map<string, map<String, set<String>>>> savedFilters {get;set;}
        
    public string key_object;   
    public string query; 
    
    public Position__c myPosition;
    public Applicant_Info__c myApp {get;set;}
    
    public String saveSearchName {get;set;}
    public Boolean isAlreadySavedSearch {get;set;}
    
    public map<String, boolean> isVisitedId{get;set;}
    
    public map<String, String> returnURLmap {get;set;}
    
    public map<String, String> returnIPUURLmap {get;set;}
    
    public set<String> favRecords {get;set;}
    public map<String, boolean> isFavoriteId{get;set;}
    public map<String, String> applicationTypeMap{get;set;}
    
    public map <String, boolean> matchEarlyEnded{get;set;}
    
    public set<String> sugRecords {get;set;}
    public map<String, boolean> isSuggestedId{get;set;}
    
    public set<String> disRecords {get;set;}
    public map<String, boolean> isDismissedId{get;set;}
    
    public map<String, boolean> isExitInterviewId{get;set;}
    
    public Map<String ,Map<String, Intrax_Program_Upload__c>> MapPTVideoThumb{get;set;}
    public Integer MapVideoSize {get;set;}
    
    public map<String, Integer> numFotosId{get;set;}
    public map<String, Integer> numVideosId{get;set;}
    
    public final date d_today = date.today();
    
    public list<Engagement__c> myEngList {get;set;}
    
    public list<User_Preference__c> user_preferences{       
         get{
            if (user_preferences == null){
                user_preferences = [SELECT Id, User__c, Dismissed_Records__c, Saved_Records__c, Viewed_Records__c, Saved_Searches__c 
                                    FROM User_Preference__c 
                                    WHERE User__c =: userInfo.getUserId()
                                    AND Object__c =: key_object];
            }
            
            return user_preferences;
        }set;       
    }
    
    // Class Constructor --> Variables we need to instatite before we start loading data...
    public search_controller(){
        myfilters = new map<string, map<String, set<String>>>();  
        map_field_label = new map<String, String>();    
        getMapFieldLabel();
        getSavedFilters();  
        List<SelectOption> lst = ArrivalDates;
    }
    
    public search_controller(string obj){
        myfilters = new map<string, map<String, set<String>>>();        
        key_object = obj;
        searchList = new list<SearchWrapper>();
        map_field_label = new map<String, String>();
        getMapFieldLabel();
        getSavedFilters();
        List<SelectOption> lst = ArrivalDates;
        
        MapPTVideoThumb = new Map<String ,Map<String, Intrax_Program_Upload__c>>();
        MapVideoSize = 0;
        
        if(appId == ''){
            myApp = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c 
                                            From Applicant_Info__c
                                            Where CreatedBy__c =: userInfo.getUserId()
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1   ];
        
        }else{
            // Test Mode - Fixed app
            myApp = [Select id, Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c 
                                            From Applicant_Info__c
                                            Where Id =: appId
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1   ];
        }
        
        myPosition = [SELECT Id, Name,Status__c,Host_Company_Id__r.lastName, Pets__c, Pet_Types__c, Host_Company_Id__r.CreatedById, createdDate, Host_Company_Id__r.Gender__pc                                      
                            FROM Position__c
                            WHERE id =: myApp.Position__c  
                                AND Status__c NOT IN ('Closed', 'Filled', 'Withdrawn')
                            ORDER BY CreatedDate DESC
                            LIMIT 1   ];
        applyCookieSearch();
        setresults();
    }
    
    
    public void getNumFotosAndVideoId() {
        
            numFotosId = new map<String, Integer>();
            numVideosId = new map<String, Integer>();
                
            AggregateResult[] photosAndVideos = [SELECT Engagement__c engId, Document_Type__c docType, Count(Id) num
                                        FROM Intrax_Program_Upload__c 
                                        WHERE Document_Type__c IN ('Participant-Album','Introductory-Video')
                                        AND Engagement__c IN: getengList()
                                        GROUP BY Engagement__c, Document_Type__c ];
                            
            for(AggregateResult photoVideo : photosAndVideos){         
                transient String doc_type = (String)photoVideo.get('docType') ;
                if (doc_type == 'Participant-Album'){
                    numFotosId.put((String)photoVideo.get('engId'), (Integer)photoVideo.get('num'));
                } 
                if (doc_type == 'Introductory-Video'){
                     numVideosId.put((String)photoVideo.get('engId'), (Integer)photoVideo.get('num'));
                }                 
            }
            
            for(Engagement__c a: getengList()){
                if(!numFotosId.containsKey(a.Id)){
                    numFotosId.put(a.Id, 0);
                }
                if(!numVideosId.containsKey(a.Id)){
                    numVideosId.put(a.Id, 0);
                }
            }
            
            //system.debug('-*-*-* numFotosId: ' + numFotosId);
            //system.debug('-*-*-* numVideosId: ' + numVideosId);
    }
    
    public Integer totalRecords{get; set;}    
    public Integer pageSize{get;set;}
    
    public integer totalPages{
        get{
            totalPages = 0;
            if(totalRecords > 0){
                totalPages = integer.valueOf(math.floor(totalRecords / pageSize));
                if(math.mod(totalRecords,pageSize) > 0){
                    totalPages += 1;
                }
            }
            return totalPages;
        }set;
    }
    
    private void getContext(){
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
        List<Engagement__c> lstEng = (list<Engagement__c>) results.getRecords();
//        returnIPUURLmap = aws_controller.getParticipantIPUURL(lstEng,false);
        returnURLmap = returnIPUURLmap;
        getFavoriteRecords();
        getDismissedRecords();
        getSuggestedRecords();
        getVisitedRecords();
        getNumFotosAndVideoId();        
        getAppplicationType();
        getExitInterviews();
        //getMatchEarlyEnded();
    }
        
    
    
    public void previousPage(){
        results.previous();
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
        returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Engagement__c>) results.getRecords(),false);
        pageNumberSelected = string.valueOf(results.getPageNumber());
        pageNumberSelected2 = pageNumberSelected;
        savePageNumberCookie();
        getContext();
    }
    
    public void nextPage(){
        results.next();
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
        returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Engagement__c>) results.getRecords(),false);
        pageNumberSelected = string.valueOf(results.getPageNumber());
        pageNumberSelected2 = pageNumberSelected;
        savePageNumberCookie();
        getContext();
    }
    
    public string pageNumberSelected{get;set;}
    public string pageNumberSelected2{get;set;}
    
    public void setpageNumber(){    
        //system.debug('-*-*-*-*- setpageNumber: ' + pageNumberSelected);
        pageNumberSelected2 = pageNumberSelected;
        results.setPageNumber(integer.valueOf(pageNumberSelected));     
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
        returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Engagement__c>) results.getRecords(),false);
        savePageNumberCookie();
        getContext();
    }
    
    public void setpageNumber2(){    
        //system.debug('-*-*-*-*- setpageNumber2: ' + pageNumberSelected2);
        pageNumberSelected = pageNumberSelected2;
        setpageNumber();
    }
    
    
    public void setPageSize(){
        results.setPageSize(pageSize);
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
        returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Engagement__c>) results.getRecords(),false);
        savePageSizeCookie();
        getContext();
    }
    
    public list<SelectOption> pageNumbers{
        get{
            list<SelectOption> pages = new list<SelectOption>();
            for(integer i = 1; i<= totalPages; i++){
                pages.Add(new SelectOption(string.valueOf(i), string.valueOf(i)));
            }
            return pages;
        }set;
    }
    
    public list<SelectOption> pageSizeOptions{
        get{
            pageSizeOptions = new list<SelectOption>();
            pageSizeOptions.add(new selectOption('5', '5'));
            pageSizeOptions.add(new selectOption('10', '10'));
            pageSizeOptions.add(new selectOption('20', '20'));
            return pageSizeOptions;
        }set;
        
    }
    
    public String f_value_string (list<String> strList){
        String str = '';
        if(strList.size() > 0){                                 
            transient boolean first_elem = true;
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
    
    public String f_value_string (set<String> strList){
        String str = '';
        if(strList.size() > 0){                                 
            transient boolean first_elem = true;
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
    
    // Jose - B-02655 (Creating a Engagement list for PT Host Community)
    public ApexPages.StandardSetController community_results {
        get{
            if(community_results == null){
                
                pageSize = 20; // Should all these values to be stored in config?? or even we should created a diferent controller for this?
                home_controller hcontroller = new home_controller();
                //system.debug('@@@@@hcontroller.applicant.Engagement__r.OwnerId: ' + hcontroller.applicant.Engagement__r.OwnerId);
                query = 'Select Id, Name, Status__c, Engagement_Start__c, Engagement_End__c, Account_Id__c, Account_Id__r.FirstName, Account_Id__r.LastName,' +
                            + 'Account_Id__r.PersonEmail, Account_Id__r.Citizenship__pc' +
                            + ' From Engagement__c  where OwnerId = \''+ hcontroller.applicant.Engagement__r.OwnerId + '\' AND Status__c = \'On Program\'';
                
                community_results = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                community_results.setPageSize(pageSize);
                
                totalRecords = community_results.getResultSize();
                
                if(totalRecords > 0){
                    totalPages = integer.valueOf(math.floor(totalRecords / pageSize));
                    if(math.mod(totalRecords,pageSize) > 0){
                        totalPages += 1;
                    }
                }
                
            }
            return community_results;
        }set;
    }
    
    // Jose - B-02655 (Creating a Engagement list for PT Host Community)
    public List<Engagement__c> getengCommList(){
        
        List<Engagement__c> engCommList = new List<Engagement__c>();
         
        for(Engagement__c eng : (list<Engagement__c>) community_results.getRecords())
            engCommList.add(eng);
        
        return engCommList;
        
    }
    
    // Jose - B-02655 (Creating a Engagement list for PT Host Community)
    public void setpageNumberComm(){        
        community_results.setPageNumber(integer.valueOf(pageNumberSelected));       
    }
    
    public string setDefaultFilterCriteria(string key_object){
        string query = '';
        
        if(key_object == 'Engagement__c'){
            boolean hasChildrenUnder2 = false;      
            boolean sameSexCouple = false;  
            boolean hasSpecialNeeds = false;
            boolean singleParent = true;
            
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
                query += ' AND (Pets_Allergy_Indicated__c = \'No\' OR (Pets_Allergy_Indicated__c = \'Yes\' AND (Pet_Allergy_Types__c NOT IN ' + s_pets + ')))';
            }
            
            if(singleParent == true){
                if(myPosition.Host_Company_Id__r.Gender__pc == 'Male') query += 'AND Single_Father_Indicated__c = \'Yes\'';
                else if(myPosition.Host_Company_Id__r.Gender__pc == 'Female') query += 'AND Single_Mother_Indicated__c = \'Yes\'';
            }
            
            if(sameSexCouple){
                query += ' AND Same_Sex_Couple_Indicated__c = \'Yes\'';
            }
            
            if(hasChildrenUnder2){
                query += ' AND Under_2_Circulated__c = true';
            }else{              
                //Modified on Oct 29 after checking with Yang: 
                query += ' AND (Under_2_Circulated__c = false AND Infant_Specialized_Circulated__c = false)';
                //query += ' AND Infant_Specialized_Circulated__c = false';
                                
            }
            
            if(hasSpecialNeeds){                
                query += ' AND (Special_Needs_Circulated__c = \'Circulate SN\' OR Special_Needs_Circulated__c = \'Circulate Both\')';
            }else{
                query += ' AND (Special_Needs_Circulated__c = \'Circulate Standard\' OR Special_Needs_Circulated__c = \'Circulate Both\')';
            }
            
            query += getEarlyEndedCriteria();
            
            query += ' AND ((In_Country__c = \'Yes\' AND Latest_Match_Date__c >= :d_today) OR (In_Country__c = \'No\') OR (In_Country__c = null))'; 
            
            
        }
        //system.debug('@@@@@@ setDefaultFilterCriteria: ' + query);
        return query;
    }
    
    public void resetQuery(){
        if(key_Object == 'Applicant_Info__c'){
                query = 'Select Id, (SELECT Id, Age__c, Name, Primary_Applicant__c, nick_name__c, Gender__c, Role__c FROM Person_Info__r),' + 
                                + ' (SELECT Id, Experience_Type__c FROM Experience__r)' + 
                                + ' Name, Special_Diet__c, US_Arrival_Date__c, Account__c, Account__r.FirstName, Intrax_Program_Options__c, Swimming_Level__c, Childcare_total_hours__c, Home_Country__c, Intrax_Program__c, Type__c, Application_Level__c, Application_Stage__c, Language_Spoken_1__c ' +
                                + ' from Applicant_Info__c ' + 
                                + ' WHERE Intrax_Program__c = \'AuPairCare\' AND type__c = \'Participant\''
                                + ' AND Application_Stage__c = \'Accepted\'';                   
                                
        }else if(key_Object == 'Engagement__c'){            
            query = 'Select Id, Name, Engagement_Type__c, Nationality__c, In_Country__c, Infant_Specialized_Indicated__c, Infant_Specialized_Circulated__c, Special_Needs_Indicated__c, Engagement_Start__c, Latest_Match_Date__c, Earliest_Match_Date__c, Intrax_Program__c, Age_At_program_Start__c, Swimming_Level__c, Gender__c, Type__c, Actual_Arrival__c, Account_Id__r.FirstName, Account_Id__r.Nick_Name__pc, Intrax_Program_Options__c, Interest_Sports__c, Interest_Fine_Arts__c, Language_1__c, Language_2__c, Language_3__c, ' +
                        + ' Special_Diet__c, Interests_Hobbies__c, Childcare_Total_Hours__c, Driving_Frequency__c, Under_2_Total_Hours__c, Circulation_Start_Date__c, Circulation_End_Date__c, Special_Needs_Circulated__c, Account_Id__r.Age__pc, ' +
                        + '(SELECT Id, Name, Swimming_Level__c, Driving_Frequency__c, Drivers_Licence_Acquired__c, Home_Country__c, Accepted_Date__c FROM Applicant_Info__r WHERE Application_Stage__c = \'Accepted\' order by CreatedDate desc  LIMIT 1) FROM Engagement__c' +
                        + ' WHERE Intrax_Program__c = \'AuPairCare\' AND type__c = \'Participant\'' + 
                        + ' AND Placement_Status__c = \'Not Placed\' ' +
                        + ' AND ((Status__c = \'Processing\') ' +
                        + ' OR (Status__c = \'On Program\' AND Circulation_Start_Date__c <= : d_today AND Circulation_End_Date__c >= : d_today)) '+
                        + ' AND ID IN (SELECT Engagement__c FROM Applicant_Info__c WHERE Application_Level__c = \'Main\' AND (Application_Stage__c = \'Accepted\' OR Application_Stage__c = \'Submitted\' OR Application_Stage__c = \'In-Review\')) '+
                        + ' AND RecordTypeId = \'' + Constants.ENG_AUPAIRCARE_PT + '\'' +
                        + ' AND ID NOT IN (SELECT Engagement__c FROM Match__c WHERE Offer_Status__c IN (\'Offered\') AND Intrax_Program__c = \'AuPairCare\' )' +
                        //+ ' AND ID NOT IN (SELECT Engagement__c FROM Match__c WHERE Offer_Status__c IN (\'Accepted\', \'Offered\') )';
                        + getSelectionCriteria();
        }
       
                        
        system.debug('@@@@@@ query1: ' + query);
        query += setDefaultFilterCriteria(key_object);
    }
    
    public string default_query;
        
    public string getDefaultQuery(){
        
        resetQuery();
        
        //system.debug('****** query after setDefaultFilterCriteria: ' + query);
        // Need to analyze the dismissed records here... 

        if(user_preferences.size() > 0 && user_preferences[0].Dismissed_Records__c != null){
            set<String> d = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);  
            if(d.size() > 0){
                query += ' AND Id NOT IN ' + f_value_string(d);
            }
        }       
        
        //Jose for default filter Newest B-02945
        //query += ' ORDER By Applicant_Info__r.Accepted_Date__c DESC';
        sortingSelected = getOrderByCookie();
        system.debug('@@@@@@ sortingSelected5: ' + sortingSelected);
        if(sortingSelected != null){
            if(sortingSelected == 'Age_At_Program_Start__c' || sortingSelected == 'Earliest_Match_Date__c'){
                query += ' ORDER By ' + sortingSelected + ' ASC NULLS LAST' ;
            }else{
                query += ' ORDER By ' + sortingSelected + ' DESC';
            }
        }else{
             sortingSelected = 'Earliest_Match_Date__c';
             query += ' ORDER By Earliest_Match_Date__c ASC NULLS LAST';
        }
         system.debug('@@@@@@ sortingSelected6: ' + sortingSelected);
        default_query = query;
         
        return query;       
    }
    
    public ApexPages.StandardSetController setresults(){
        if(results == null){
            
            pageSize = 10; // Should all these values to be stored in config?? or even we should created a diferent controller for this?
                            
            query = getDefaultQuery();     
            system.debug('@@@@@@ query: ' + query);
            myEngList = dataBase.query(query);                
            //results = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            results = new ApexPages.StandardSetController(myEngList);
         Integer pageSizeCookie = getPageSizeCookie();
                                
                if(pageSizeCookie != null && pageSizeCookie != pageSize){
                    pageSize = pageSizeCookie;
                }
            results.setPageSize(pageSize);
            
            totalRecords = results.getResultSize();
            
            if(totalRecords > 0){
                totalPages = integer.valueOf(math.floor(totalRecords / pageSize));
                if(math.mod(totalRecords,pageSize) > 0){
                    totalPages += 1;
                }
            }
            
        String pageNumberCookie = getPageNumberCookie();
                system.debug('@@@@@@ ResultsPageNumberCookie: ' + pageNumberCookie);
                system.debug('@@@@@@ ResultspageNumberSelected: ' + pageNumberSelected);
                if(pageNumberCookie != null){
                    pageNumberSelected = pageNumberCookie;
                    pageNumberSelected2 = pageNumberSelected;
                    results.setPageNumber(Integer.valueof(pageNumberSelected)); 
                    system.debug('@@@@@@ ResultspageNumberSelected: ' + pageNumberSelected);
                }
            if(key_object == 'Applicant_Info__c'){
                //returnURLmap = aws_controller.getParticipantPhotoList((list<Applicant_Info__c>) results.getRecords());
                returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Applicant_Info__c>) results.getRecords());
            }else if(key_object == 'Engagement__c'){
                //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
                returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Engagement__c>) results.getRecords(),false);
            }
            // We need to check if the records has been marked as Favorite or dismissed
            
            getContext();
        } 
        return results;                             
    }
    
    public ApexPages.StandardSetController results {
        get{
            return results;
        }set;
    }
    
    public List<Engagement__c> getengList(){
        
        List<Engagement__c> engList = new List<Engagement__c>();
        system.debug('******** results: '  + results);
        for(Engagement__c eng : (list<Engagement__c>) results.getRecords())
            engList.add(eng);
        
        return engList;       
    }
    
        
    public string f_object {get;set;}
    public string f_field {get;set;}
    public string f_label {get;set;}
    public set<String> f_value_set{get;set;}
    
    public void processSelectedValues(String s){
        //system.debug('****** f_object:' + f_object);
        //system.debug('****** f_field: ' + f_field);     
        //system.debug('****** f_label: ' + f_label);
        
        //system.debug('******** Values: '  + s);
        f_value_set = new set<string>();
        f_value_set.add(s);  
                    
        if(f_value_set.contains('Any')) {   
            removeFilter(f_object, f_label);
        }else{
            addValueToFilters(f_field, f_value_set, false);
        }
        //addValueToFilters(f_field, f_value_set, false);
    }
    
    public void processSelectedValues(list<String> values){
        //system.debug('****** f_object:' + f_object);
        //system.debug('****** f_field: ' + f_field);     
        //system.debug('****** f_label: ' + f_label);
        //system.debug('******** Values: '  + values);
        f_value_set = new set<string>();
        f_value_set.addAll(values);   
        if(f_value_set.contains('Any')) {   
            removeFilter(f_object, f_label);
        }else{
            addValueToFilters(f_field, f_value_set, true);
        }
        
        //system.debug('****** MY FILTERS: ' + myfilters);
    }
    
    public void addValueToFilters(string field, set<String> values, boolean multiselect){
            
        if(myfilters.containsKey(f_object)){
            if(myfilters.get(f_object).containsKey(f_label)){                           
                //if(multiselect == true){                      
                    //myfilters.get(f_object).get(f_label).addAll(values);                      
                //}else{
                    myfilters.get(f_object).get(f_label).clear();
                    myfilters.get(f_object).get(f_label).addAll(values);
                //}
            }else{
                myfilters.get(f_object).put(f_label, new set<String>());
                myfilters.get(f_object).get(f_label).addAll(values);
            }               
        }else{
            myfilters.put(f_object, new map<String, set<String>>());
            myfilters.get(f_object).put(f_label, new set<String>());
            myfilters.get(f_object).get(f_label).addAll(values);
        }
        
        //system.debug('-*-*-*-*-* addValueToFilters : '+ field + values);
        //system.debug('-*-*-*-*-* myfilters : '+ myfilters);
    }
    
    public list<String> nationalitySelected{get;set;}
    public list<String> languageSelected{get;set;}
    public list<String> experienceSelected{get;set;}
    public list<String> experienceTypeSelected{get;set;}
    public string drivingLicenseSelected{get;set;}
    public string swimmersSelected{get;set;}
    public string ageSelected{get;set;}
    public list<String> dietSelected{get;set;}
    public string genderSelected{get;set;}  
    public string ArrivalSelected{get;set;} 
    public string currentLocationSelected{get;set;} 
    public string trainingSelected{get;set;}    
    public list<string> hobbiesSelected{get;set;}
    
    public string dismissedSelected{get;set;}
    public string favoriteSelected{get;set;}
    public string onlyFavoriteSelected{get;set;}
    public string onlySuggestedSelected{get;set;}   
    
    public string savedSearchSelected{get;set;}     
    
    map<String, String> map_field_label;
    
    public void applyFilter(){
        resetQuery();  
            
        //system.debug('******* myfilters: ' + myfilters);
        //system.debug('******* f_field: ' + f_field);
        //system.debug('******* nationalitySelected: ' + nationalitySelected);
        
        
        if(f_field == 'Show_only_favorites' && onlyFavoriteSelected != null && onlyFavoriteSelected != '' && onlyFavoriteSelected == 'true')
            processSelectedValues(onlyFavoriteSelected);   
        
        if(f_field == 'Show_only_suggested' && onlySuggestedSelected != null && onlySuggestedSelected != '' && onlySuggestedSelected == 'true')
            processSelectedValues(onlySuggestedSelected);   
        
        if(f_field == 'Nationality__c'){
            if( nationalitySelected != null && nationalitySelected.size() > 0)
                processSelectedValues(nationalitySelected);   
            else removeFilter(f_object, f_label);                   
        }
        else if(f_field == 'Language_1__c'){
            if(languageSelected != null && languageSelected.size() > 0)
                processSelectedValues(languageSelected);
            else removeFilter(f_object, f_label);       
        }
        else if(f_field == 'Children_Ages__c'){ 
            if(experienceSelected != null && experienceSelected.size() > 0)
                processSelectedValues(experienceSelected);  
            else removeFilter(f_object, f_label);       
        }
        else if(f_field == 'Experience_Type__c'){ 
            if(experienceTypeSelected != null && experienceTypeSelected.size() > 0)
                processSelectedValues(experienceTypeSelected); 
            else removeFilter(f_object, f_label);       
        }
        else if(f_field == 'Drivers_Licence_Indicated__c' && drivingLicenseSelected != null && drivingLicenseSelected != ''){
            processSelectedValues(DrivingLicenseSelected);          
        }
        else if(f_field == 'Swimming_Indicated__c' && swimmersSelected != null && swimmersSelected != ''){
            processSelectedValues(SwimmersSelected);        
        }           
        else if(f_field == 'Age_At_Program_Start__c' && ageSelected != null && ageSelected != ''){
            if(ageSelected != 'Any') processSelectedValues(ageSelected);
            else removeFilter(f_object, f_label);               
        }
        else if(f_field == 'Special_Diet__c'){
            if(dietSelected != null && dietSelected.size() > 0)
                processSelectedValues(dietSelected);    
            else removeFilter(f_object, f_label);   
        }   
        else if(f_field == 'Gender__c' && genderSelected != null && genderSelected != ''){
            if(genderSelected != 'Any') processSelectedValues(genderSelected);
            else removeFilter(f_object, f_label);           
        }
        else if(f_field == 'Earliest_Match_Date__c' && arrivalSelected != null && arrivalSelected != ''){
            if(arrivalSelected != 'Any') processSelectedValues(arrivalSelected);
            else removeFilter(f_object, f_label);       
        }else if(f_field == 'Interest_Sports__c'){
            if(hobbiesSelected != null && hobbiesSelected.size() > 0)
                processSelectedValues(hobbiesSelected);         
            else removeFilter(f_object, f_label);
        }else if(f_field == 'Infant_Specialized_Circulated__c' && trainingSelected != null && trainingSelected != ''){
            if(trainingSelected != 'Any') processSelectedValues(trainingSelected);
            else removeFilter(f_object, f_label);                   
        }else if(f_field == 'In_Country__c' && currentLocationSelected != null && currentLocationSelected != ''){
            if(currentLocationSelected != 'Any') processSelectedValues(currentLocationSelected);
            else removeFilter(f_object, f_label);           
        }
        
        buildQuery();
    }
    
    public string sortingSelected{get;set;}
    
    public void buildQuery(){
        buildQuery(false);
    }
    
    public void buildQuery(boolean init_query){
        system.debug('******* buildQuery init_query: ' + init_query);
        //system.debug('******* buildQuery myfilters: ' + myfilters);
        saveCookieSearch();
        resetquery();
        boolean no_results = false;
        
        processFilterValues();          
        
        if(DismissedSelected != null || DismissedSelected != ''){
            if(DismissedSelected == 'false'){
         
                if(user_preferences.size() > 0){
                    if (user_preferences[0].Dismissed_Records__c != null) disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
                    else disRecords = new set<String>(); 
                    //set<String> d = (set<String>) json.deserialize(up[0].Dismissed_Records__c, set<String>.class);    
                    if(disRecords.size() > 0){
                        query += ' AND Id NOT IN ' + f_value_string(disRecords);                                    }
                    }
                }
            }
            /*if(FavoriteSelected != null || FavoriteSelected != ''){
                if(FavoriteSelected == 'true'){
                    list<User_Preference__c> up = [SELECT Id, User__c, Dismissed_Records__c, Saved_Records__c FROM User_Preference__c WHERE 
                                                            User__c =: userInfo.getUserId()
                                                            AND Object__c = 'Engagement__c'];
                                                            
                    if(up.size() > 0){
                        if (up[0].Saved_Records__c != null) favRecords = (set<String>) json.deserialize(up[0].Saved_Records__c, set<String>.class);
                        else favRecords = new set<String>(); 
                        //set<String> d = (set<String>) json.deserialize(up[0].Dismissed_Records__c, set<String>.class);    
                        if(favRecords.size() > 0){
                            query += ' AND Id IN ' + f_value_string(favRecords);
                        }
                    }
                }
            }*/
            
            if(onlyFavoriteSelected != null || onlyFavoriteSelected != ''){
                if(onlyFavoriteSelected == 'true'){
                        
                    list<String> favoriteId = getFavoriteId();
              
                    if(favoriteId.size() > 0){
                        query += ' AND Id IN ' + f_value_string(favoriteId);
                    }else{
                        query += ' AND Id IN (\'\')';
                    }
                }
            }
            
            if(onlySuggestedSelected != null || onlySuggestedSelected != ''){
                if(onlySuggestedSelected == 'true'){
                        
                    list<String> suggestedId = getSuggestedId();
              
                    if(suggestedId.size() > 0){
                        query += ' AND Id IN ' + f_value_string(suggestedId);
                    }else{
                        query += ' AND Id IN (\'\')';
                    }
                }
            }
           
                            
        for(String s_object : myfilters.keySet()){
            //system.debug('******* Key: ' + s_object + ' / ' + key_object);
            if(s_object == key_object){
                map<String, set<String>> values = myfilters.get(s_object);                                  
                for(String s_field : values.keySet()){                      
                    // Special Cases
                    //system.debug('******* map_field_label: ' + map_field_label.get(s_field));
                                    
                    if(map_field_label.get(s_field) == 'Interest_Sports__c'){                                                   
                        query += ' AND (Interest_Sports__c INCLUDES ' + f_value_string(values.get(s_field)) + ' OR Interests_Hobbies__c INCLUDES ' + f_value_string(values.get(s_field)) + ' OR Interest_Fine_Arts__c INCLUDES ' + f_value_string(values.get(s_field)) +')';
                    }else if(map_field_label.get(s_field) == 'Language_1__c'){                          
                        query += ' AND (Language_1__c IN ' + f_value_string(values.get(s_field)) + ' OR Language_2__c IN ' + f_value_string(values.get(s_field)) + ' OR Language_3__c IN ' + f_value_string(values.get(s_field)) + ')';                     
                    }else if(map_field_label.get(s_field) == 'Age_At_Program_Start__c' && ageSelected <> 'Any'){
                        query += ' AND Age_At_Program_Start__c >= ' + ageSelected;              
                    }else if(map_field_label.get(s_field) == 'Earliest_Match_Date__c' && arrivalSelected != 'Any'){
                         date d_arrivalSelected = date.parse(ArrivalSelected);
                         system.debug('****** d_arrivalSelected: ' + d_arrivalSelected);
                         query += ' AND Earliest_Match_Date__c <= : d_arrivalSelected';  
                         //query += ' AND (Latest_Match_Date__c >= : d_arrivalSelected OR Earliest_Match_Date__c >= : d_arrivalSelected)';        
                    }else if(map_field_label.get(s_field) == 'Infant_Specialized_Circulated__c' && trainingSelected != 'Any'){
                         if(trainingSelected == 'Infant Specialized')
                            query += ' AND Infant_Specialized_Circulated__c = true';
                         else if(trainingSelected == 'Standard Training')
                            query += ' AND Infant_Specialized_Circulated__c = false';       
                    }else if(map_field_label.get(s_field) == 'In_Country__c' && currentLocationSelected != 'Any'){
                         if(currentLocationSelected == 'Already in the Country')
                            query += ' AND In_Country__c = \'Yes\'';    
                         else if(currentLocationSelected == 'Overseas') 
                            query += ' AND In_Country__c = \'No\''; 
                    }else if(map_field_label.get(s_field) == 'Drivers_Licence_Indicated__c'){
                        if(DrivingLicenseSelected == 'true')
                            query += ' AND Drivers_Licence_Indicated__c = \'Yes\'';
                    }else if(map_field_label.get(s_field) == 'Swimming_Indicated__c'){
                        if(SwimmersSelected == 'true')
                            query += ' AND Swimming_Indicated__c = \'Yes\'';
                    }else{
                        // General Cases                    
                        query += ' AND ';
                        query += map_field_label.get(s_field) + ' IN ';
                        query += f_value_string(values.get(s_field));                   
                    }                   
                    
                }
            }else{
                map<String, set<String>> values = myfilters.get(s_object);   
               //system.debug('********** values: ' +  values);  
                if(myfilters.get(s_object).size() > 0){
                    string query_sub = 'SELECT Id, ' + key_object + ',';                                
                    for(String s_field : values.keySet()){
                        //system.debug('********** s_field: ' +  s_field);
                        //system.debug('********** map_field_label: ' +  map_field_label.get(s_field));    
                         query_sub += map_field_label.get(s_field) + ',';
                    }
                    query_sub = query_sub.substring(0, query_sub.length()-1) + ' FROM ' + s_object;
                   // system.debug('********** query_sub: ' +  query_sub);                
                    
                    query_sub += ' WHERE ' + key_object + ' != null AND ';
                    for(String s_field : values.keySet()){                       
                         query_sub += map_field_label.get(s_field) + ' INCLUDES ' + f_value_string(values.get(s_field)) + ' AND ';
                    }
                    
                    query_sub = query_sub.substring(0, query_sub.length() - 4);
                    
                    //system.debug('********** query_sub: ' +  query_sub); 
                    
                    if(s_object == 'Experience__c'){
                        list<Experience__c> sub_results = dataBase.query(query_sub);
                        list<Id> myIds = new list<Id>();
                        for(Experience__c e : sub_results) myIds.add(e.Engagement__c); 
                        
                        if(sub_results.size() > 0)  query += ' AND Id IN ' + f_value_string(myIds);
                        else query += ' AND Name = \'no_results\'';
                    }               
                
                }
            }
             
        }
        system.debug('@@@@@@ sortingSelected2: ' + sortingSelected);
        if(init_query){ 
            sortingSelected = getOrderByCookie();
        }else{
            saveOrderByCookie();
        }
        system.debug('@@@@@@ sortingSelected3: ' + sortingSelected);
        if(sortingSelected != '' && sortingSelected != NULL){
            if(sortingSelected == 'Age_At_Program_Start__c' || sortingSelected == 'Earliest_Match_Date__c'){
                query += ' ORDER By ' + sortingSelected + ' ASC NULLS LAST' ;
            }else{
                query += ' ORDER By ' + sortingSelected + ' DESC';
            }
            
        }else{
            query += ' ORDER By Earliest_Match_Date__c ASC NULLS LAST';
        }
        system.debug('@@@@@@ sortingSelected4: ' + sortingSelected);
        if(no_results) results = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        else results = new ApexPages.StandardSetController(Database.getQueryLocator(query));

        if(init_query){            
            Integer pageSizeCookie = getPageSizeCookie();                           
            if(pageSizeCookie != null){
                pageSize = pageSizeCookie;
            }else{
                pageSize = 10;
            }
        }
        results.setPageSize(pageSize);
        totalRecords = results.getResultSize();
        
        if(init_query){
            String pageNumberCookie = getPageNumberCookie();
            if(pageNumberCookie != null){
                pageNumberSelected = pageNumberCookie;
                pageNumberSelected2 = pageNumberSelected;
                results.setPageNumber(Integer.valueof(pageNumberSelected)); 
            }else{
                pageNumberSelected = '1';
                pageNumberSelected2 = '1';
            }
        }else{
            pageNumberSelected = '1';
            pageNumberSelected2 = '1';
        }
        
       
        
        //system.debug('***** results: ' + results);
        if(totalRecords > 0){
            totalPages = integer.valueOf(math.floor(totalRecords / pageSize));
            if(math.mod(totalRecords,pageSize) > 0){
                totalPages += 1;
            }
      
        }
        
        list<Engagement__c> ptEngList = (list<Engagement__c>) results.getRecords();
        if(searchList.size() > 0){
            //returnURLMap.putAll(aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords()));
            returnIPUURLmap.putAll(aws_controller.getParticipantIPUURL(ptEngList,false));
        }else{
            //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
            returnIPUURLmap = aws_controller.getParticipantIPUURL(ptEngList,false);
        }
        
        getContext();
        getIsAlreadySavedSearch();
        
    }
    
    public list<SelectOption> sortingOptions{
        get{
            list<SelectOption> opts = new list<SelectOption>();
            opts.add(new SelectOption('Earliest_Match_Date__c', 'Available Date'));
            opts.add(new SelectOption('Childcare_Total_Hours__c', 'Childcare Hours')); 
            opts.add(new SelectOption('Age_At_Program_Start__c', 'Age'));                           
            return opts;
            
        }
    }
    
    public void processFilterValues(){
        for(String s_object : myfilters.keySet()){
            map<String, set<String>> filterValues = myfilters.get(s_object); 
            
                for(String s_field : filterValues.keySet()){    
                    List<String> setValue = new List<String> (filterValues.get(s_field));
                    
                    //system.debug('*@*@*@*@*@ s_field: ' + s_field);
                    //system.debug('*@*@*@*@*@ setValue: ' + setValue);
                    
                    
                    if(s_field == 'Au Pair\'s Training') trainingSelected = setValue.get(0);
                    else if(s_field == 'Au Pair\'s Current Location') currentLocationSelected = setValue.get(0);
                    else if(s_field == 'Gender') genderSelected = setValue.get(0);
                    else if(s_field == 'Minimum Age') ageSelected = setValue.get(0);
                    else if(s_field == 'Preferred Arrival') arrivalSelected = setValue.get(0);
                    else if(s_field == 'My Favorites') onlyFavoriteSelected = setValue.get(0);
                    else if(s_field == 'Suggested Au Pairs') onlySuggestedSelected = setValue.get(0);
                    else if(s_field == 'Preferred Arrival') arrivalSelected = setValue.get(0);
                    else if(s_field == 'Nationality'){ 
                        nationalitySelected = setValue;
                    }else if(s_field == 'Language Spoken'){ 
                        languageSelected = setValue;
                    }else if(s_field == 'Experience with Ages'){ 
                        experienceSelected = setValue;
                    }else if(s_field == 'Experience Type'){ 
                        experienceTypeSelected = setValue;
                    }else if(s_field == 'Hobbies and Interests'){ 
                        hobbiesSelected = setValue;
                    }else if(s_field == 'Special Diet'){ 
                        dietSelected = setValue;
                    }
                }
            }
        
    }
    
    public boolean getIsMyFiltersEmpty(){
        boolean filter_empty = true;
        if(!myFilters.isEmpty()){
            for(string s_object : myFilters.keySet()){
                if(!myFilters.get(s_object).isEmpty()){
                    filter_empty = false;
                    break;
                }
            }
        }
        return filter_empty;
        //if(myFilters.isEmpty() || myFilters.size() == 0) return true;
        //else return false;
    }
    
    public string f_value{get;set;}     
    
    public void removeFilter(String obj, string label){
        //system.debug('****** f_object: ' + obj);
        //system.debug('****** Value to be removed: ' + label);       
        
        //system.debug('******* MyFilters 1: ' + myfilters);
        
        myfilters.get(obj).remove(label);
        
        //system.debug('****** LABEL: ' + f_label);
        if(f_label == 'Au Pair\'s Training') trainingSelected = '';
        else if(f_label == 'Au Pair\'s Current Location') currentLocationSelected = '';
        else if(f_label == 'Gender') genderSelected = '';
        else if(f_label == 'Minimum Age') ageSelected = '';
        else if(f_label == 'Preferred Arrival') ArrivalSelected = '';
        else if(f_label == 'My Favorites') onlyFavoriteSelected = 'false';
        else if(f_label == 'Suggested Au Pairs') onlySuggestedSelected = 'false';
        else if(f_label == 'Preferred Arrival') ArrivalSelected = '';
        else if(f_label == 'Nationality'){ 
            nationalitySelected = removeElementFromList(nationalitySelected, f_value);
        }else if(f_label == 'Language Spoken'){ 
            languageSelected = removeElementFromList(languageSelected, f_value);
        }else if(f_label == 'Experience with Ages'){ 
            ExperienceSelected = removeElementFromList(ExperienceSelected, f_value);
        }else if(f_label == 'Experience Type'){ 
            ExperienceTypeSelected = removeElementFromList(ExperienceTypeSelected, f_value);
        }else if(f_label == 'Hobbies and Interests'){ 
            hobbiesSelected = removeElementFromList(hobbiesSelected, f_value);
        }else if(f_label == 'Special Diet'){ 
            DietSelected = removeElementFromList(DietSelected, f_value);
        }
        //system.debug('******* MyFilters 2: ' + myfilters);  
        
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
        returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Engagement__c>) results.getRecords(),false);
        getContext();
    }
    
    public void removeFilter(){
        //system.debug('****** f_object: ' + f_object);
        //system.debug('****** Value to be removed: ' + f_value);
        //system.debug('****** Field to be removed: ' + f_label);         
        
        //system.debug('******* MyFilters 1: ' + myfilters);
        if(f_value == 'Any'){
            myfilters.get(f_object).remove(f_label);
            
            if(f_label == 'Nationality') nationalitySelected = null;
            else if(f_label == 'Language Spoken') languageSelected = null;
            else if(f_label == 'Experience with Ages') ExperienceSelected = null;
            else if(f_label == 'Hobbies and Interests') hobbiesSelected = null;
            else if(f_label == 'Special Diet') dietSelected = null;
            
        }else{
        
            myfilters.get(f_object).get(f_label).remove(f_value);
            
            if(myfilters.get(f_object).get(f_label) == null || myfilters.get(f_object).get(f_label).size() == 0){
                myfilters.get(f_object).keySet().remove(f_label);           
            }
            
            if(f_label == 'Au Pair\'s Training') trainingSelected = '';
            else if(f_label == 'Au Pair\'s Current Location') currentLocationSelected = '';
            else if(f_label == 'Gender') genderSelected = '';
            else if(f_label == 'Minimum Age') ageSelected = '';
            else if(f_label == 'Preferred Arrival') ArrivalSelected = '';
            else if(f_label == 'My Favorites') onlyFavoriteSelected = 'false';
            else if(f_label == 'Suggested Au Pairs') onlySuggestedSelected = 'false';
            else if(f_label == 'Nationality'){ 
                nationalitySelected = removeElementFromList(nationalitySelected, f_value);
            }else if(f_label == 'Language Spoken'){ 
                languageSelected = removeElementFromList(languageSelected, f_value);
            }else if(f_label == 'Experience with Ages'){ 
                ExperienceSelected = removeElementFromList(ExperienceSelected, f_value);
            }else if(f_label == 'Experience Type'){ 
                ExperienceTypeSelected = removeElementFromList(ExperienceTypeSelected, f_value);
            }else if(f_label == 'Hobbies and Interests'){ 
                hobbiesSelected = removeElementFromList(hobbiesSelected, f_value);
            }else if(f_label == 'Special Diet'){ 
                DietSelected = removeElementFromList(DietSelected, f_value);
            }
        }
        //system.debug('******* MyFilters 3: ' + myfilters);  
        
        BuildQuery();
                
        //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
        returnIPUURLmap = aws_controller.getParticipantIPUURL((list<Engagement__c>) results.getRecords(),false);
        getContext();
    }
    
    public list<String> removeElementFromList(list<String> filter_values, string removed_value){
            for(integer i=0; i < filter_values.size(); i++){
                //system.debug('**** Here?' + removed_value);
                //system.debug('**** value from list' + filter_values.get(i));
                if(filter_values.get(i) == removed_value){
                    filter_values.remove(i);
                    break;
                }
            }
            //system.debug('******* new list: ' +  filter_values);
            return filter_values;
    }
    
    
    public void clearAllFiltersCommand(){
        clearAllFilters();
        saveCookieSearch();
        pageNumberSelected = '1';
        pageNumberSelected2 = '1';
    }
    
    
    public void clearAllFilters(){
        
        myfilters.keySet().removeAll(myfilters.keySet());
        resetQuery();
        
        system.debug('****@@@@ query2: ' + query);
        results = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        results.setPageSize(pageSize);
        totalRecords = results.getResultSize();
        if(totalRecords > 0){
            totalPages = integer.valueOf(math.floor(totalRecords / pageSize));
            if(math.mod(totalRecords,pageSize) > 0){
                totalPages += 1;
            }
      
        }
        
        List<Engagement__c> ptEngList = (list<Engagement__c>) results.getRecords();
        
        if(searchList.size() > 0){
            //returnURLMap.putAll(aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords()));
            returnIPUURLmap.putAll(aws_controller.getParticipantIPUURL(ptEngList,false));
        }else{
            //returnURLmap = aws_controller.getParticipantPhotoList((list<Engagement__c>) results.getRecords());
            returnIPUURLmap = aws_controller.getParticipantIPUURL(ptEngList,false);
        }
        
        nationalitySelected = null;
        languageSelected = null;
        arrivalSelected = null;
        ExperienceSelected = null;
        currentLocationSelected = null;
        SwimmersSelected = null;
        DrivingLicenseSelected = null;
        genderSelected = null;
        dietSelected = null;
        hobbiesSelected = null;         
        trainingSelected = null;            
        if(onlyFavoriteSelected != null && onlyFavoriteSelected == 'true'){
            onlyFavoriteSelected = 'false';
        }
        if(onlySuggestedSelected != null && onlySuggestedSelected == 'true'){
            onlySuggestedSelected = 'false';
        }
        
        getContext();
    }
    
/**     public void saveAsFavorite(){
        system.debug('******* RECORD ID: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        
        list<User_Preference__c> up = [SELECT Id, User__c, Saved_Records__c FROM User_Preference__c WHERE 
                                            User__c =: userInfo.getUserId()
                                            AND Object__c = :key_object];
        system.debug('******* record: ' + up);
        if(up.size() == 0){
            // We need to create a new record
            User_Preference__c upnew = new User_Preference__c(User__c = userInfo.getUserId());
            favRecords = new set<String>();
            favRecords.add(ApexPages.CurrentPage().getParameters().get('recordId'));
            upnew.Saved_Records__c = json.serialize(favRecords);
            upnew.Object__c = key_object;
            
            system.debug('favRecords: ' + favRecords);      
            insert upnew;   
        }else{
            // We already have a record for this user --> We need to deserialize the existing data
            if(up[0].saved_Records__c != null){
                favRecords = (set<String>) json.deserialize(up[0].Saved_Records__c, set<String>.class);
            }
            system.debug('****** deserialized: ' + favRecords);
            //if(favRecords.size() > 0){
                favRecords.add(ApexPages.CurrentPage().getParameters().get('recordId'));
                system.debug('****** deserialized 2: ' + favRecords);
                up[0].Saved_Records__c = json.serialize(favRecords);
                update up[0];
            //}
        }
        
        // Creating a new Selection__c record       
        createSelectionRecord(getCurrentPosition(), ApexPages.CurrentPage().getParameters().get('recordId'));
        
        getFavoriteRecords();
    }*/
    
    public void saveAsFavorite(){
        //system.debug('****** saveAsFavorite');
        //system.debug('****** recordId: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        //system.debug('****** userInfo: ' + userInfo.getUserId());
        saveSelection (true);
        getFavoriteRecords();
    }
    
    public void removeAsFavorite(){
        //system.debug('****** removeAsFavorite');
        //system.debug('****** recordId: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        //system.debug('****** userInfo: ' + userInfo.getUserId());
        saveSelection (false);
        getFavoriteRecords();
    }
    
    public void saveSelection(boolean favorite){
    
        Selection__c selection;
        Position__c position = new Position__c();
        
        try{
                
                selection = [Select Position__c, Id, Engagement__c, Favorite__c
                                                From Selection__c 
                                                Where Intrax_Program__c = 'AuPairCare' 
                                                And Position__c =: myPosition.Id
                                                And Engagement__c =: ApexPages.CurrentPage().getParameters().get('recordId')
                                                ORDER BY CreatedDate DESC
                                                LIMIT 1];       
                                                                                     
                //system.debug('****** SELECTION: ' + selection);
                    
            }catch(Exception e){
                system.debug('Error getting the favorite records: ' + e);
            }               

            if (selection != null) {
                
                selection.Favorite__c = favorite;
                //system.debug('****** UPDATE: ' + selection);
                update selection;
                
            } else {
                //B-02881
                Engagement__c eng = [SELECT Id,Account_Id__r.LastName FROM Engagement__c 
                                    WHERE Id =: ApexPages.CurrentPage().getParameters().get('recordId') LIMIT 1];
                selection = new Selection__c (
                    Name = myPosition.Host_Company_Id__r.LastName+' '+ eng.Account_Id__r.LastName,
                    Position__c = myPosition.Id,
                    Engagement__c = eng.Id,
                    Favorite__c = favorite,
                    Intrax_Program__c = 'AuPairCare'
                );
                
                //system.debug('****** INSERT: ' + selection);
                insert selection;
            }
    }

    
    
    
    
    
    public void createSelectionRecord(string posId, string engId){
        //B-02881
        Engagement__c eng = [SELECT Id, Account_Id__r.LastName FROM Engagement__c WHERE Id =: engId LIMIT 1];
        
        Selection__c selection = new Selection__c();
        //selection.Name = eng.Account_Id__r.Name;
        selection.Name = myPosition.Host_Company_Id__r.Name+' '+ eng.Account_Id__r.LastName;
        selection.Engagement__c = engId;
        selection.Position__c = posId;
        selection.Intrax_Program__c = 'AuPairCare';
        selection.Favorite__c = true;
        try{
            insert selection;
        }catch(Exception e){
            system.debug('***** Error creating Selection record: ' + e);
        }
    }
    
   /* public Position__c getCurrentPosition(){
        
  
        
        return [SELECT Id, Status__c, Pets__c, Pet_Types__c, Host_Company_Id__r.CreatedById, createdDate, Host_Company_Id__r.Gender__pc 
                    FROM Position__c 
                    WHERE Host_Company_Id__r.CreatedById =: userInfo.getUserId()
                    AND (Status__c = 'Pending' or Status__c = 'Matching')
                    order by createdDate desc];
            
    }/*
    
 /**    public void removeAsFavorite(){
        list<User_Preference__c> up = [SELECT Id, User__c, Saved_Records__c FROM User_Preference__c WHERE 
                                            User__c =: userInfo.getUserId()
                                            AND Object__c = :key_object];
        
        favRecords = (set<String>) json.deserialize(up[0].Saved_Records__c, set<String>.class);
        system.debug('***** favRecords: ' + favRecords);
        system.debug('***** recordId: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        if(favRecords.contains(ApexPages.CurrentPage().getParameters().get('recordId'))){
            favRecords.remove(ApexPages.CurrentPage().getParameters().get('recordId'));
            up[0].Saved_Records__c = json.serialize(favRecords);
            update up[0];
        }
        system.debug('***** favRecords: ' + favRecords);
        getFavoriteRecords();
                                            
    }*/
    
   /* public void getFavoriteRecords(){
        isFavoriteId = new map<String, Boolean>();
        list<User_Preference__c> up = [SELECT Id, User__c, Saved_Records__c FROM User_Preference__c WHERE 
                                            User__c =: userInfo.getUserId()
                                            AND Object__c =: key_object];
                                                
        if(up.size() > 0){  
            if (up[0].Saved_Records__c != null && up[0].Saved_Records__c != '') favRecords = (set<String>) json.deserialize(up[0].Saved_Records__c, set<String>.class);
            else favRecords = new set<String>();
        }else favRecords = new set<String>();
        
        for(Engagement__c a: getengList()){
            if(favRecords.contains(a.Id)){
                isFavoriteId.put(a.Id, true);
            }else isFavoriteId.put(a.Id, false);
        }
    }*/
    
     public void getFavoriteRecords(){
        
        isFavoriteId = new map<String, Boolean>();
            
            try{
        
                    list<Selection__c> selection = [Select s.Position__c, s.Id, s.Engagement__c, s.Favorite__c
                                                    From Selection__c s
                                                    Where s.Intrax_Program__c = 'AuPairCare' 
                                                    And s.Position__c =: myPosition.Id];                                             
                                                        
                   //system.debug('#@#@#@ getFavoriteRecords: ' + selection);
                    
                    for(Selection__c sel : selection){              
                        if (sel.Engagement__c != null){                     
                            isFavoriteId.put(sel.Engagement__c,sel.Favorite__c);
                        }
                    }
                    
                    for(Engagement__c a: getengList()){
                        if(!isFavoriteId.containsKey(a.Id)){
                            isFavoriteId.put(a.Id, false);
                        }
                    }
                    
            }catch(Exception e){
                system.debug('Error getting the favorite records: ' + e);
            }
                
            //system.debug('@@@@@isFavoriteId: ' + isFavoriteId);         
     }
     
     
     
     public list<Selection__c> list_selections{
        get{
            if (list_selections == null) {
                list_selections = [Select s.Position__c, s.Id, s.Engagement__c, s.Favorite__c, s.Recommendation_Type__c
                                    From Selection__c s
                                    Where s.Intrax_Program__c = 'AuPairCare'
                                    And s.Position__c =: myPosition.Id];
            }
            return list_selections;
        }set;
     } 
     
      public list<String> getFavoriteId(){
        
        list<String> favoriteId = new list<String>();
            
            try{

                    for(Selection__c sel : list_selections){              
                        if (sel.Engagement__c != null && sel.Favorite__c == true){                     
                            favoriteId.add(sel.Engagement__c);
                        }
                    }
                    
            }catch(Exception e){
                system.debug('Error getting the favorite records: ' + e);
                return favoriteId;
            }
                
            //system.debug('@@@@@favoriteId: ' + favoriteId);  
            return favoriteId;
                
     }
     
     public void getSuggestedRecords(){
        
        isSuggestedId = new map<String, Boolean>();
            
            try{
                    for(Selection__c sel : list_selections){              
                        if (sel.Engagement__c != null && sel.Recommendation_Type__c != null){                     
                            isSuggestedId.put(sel.Engagement__c, true);
                        }
                    }
                    
                    for(Engagement__c a: getengList()){
                        if(!isSuggestedId.containsKey(a.Id)){
                            isSuggestedId.put(a.Id, false);
                        }
                    }
                    
            }catch(Exception e){
                system.debug('Error getting the suggested records: ' + e);
            }
                
            //system.debug('@@@@@isSuggestedId: ' + isSuggestedId);           
     }
     
     public list<String> getSuggestedId(){
        
        list<String> suggestedId = new list<String>();
            
            try{

                    for(Selection__c sel : list_selections){              
                        if (sel.Engagement__c != null && sel.Recommendation_Type__c != null){                        
                            suggestedId.add(sel.Engagement__c);
                        }
                    }
                    
            }catch(Exception e){
                system.debug('Error getting the favorite records: ' + e);
                return suggestedId;
            }
                
            //system.debug('@@@@@suggestedId: ' + suggestedId);    
            return suggestedId;
                
     }
    
    public void saveAsDismissed(){
       // system.debug('******* RECORD ID: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        
        if(user_preferences.size() == 0){
            // We need to create a new record
            User_Preference__c upnew = new User_Preference__c(Name = userInfo.getFirstName() + ' ' + userInfo.getLastName(), 
                                                                User__c = userInfo.getUserId());
            disRecords = new set<String>();
            disRecords.add(ApexPages.CurrentPage().getParameters().get('recordId'));
            upnew.Dismissed_Records__c = json.serialize(disRecords);
            upnew.Object__c = key_object;
            
            //system.debug('disRecords: ' + disRecords);      
            insert upnew;   
        }else{
            // We already have a record for this user --> We need to deserialize the existing data
            if (user_preferences[0].Dismissed_Records__c != null) disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
            else disRecords = new set<String>();
            system.debug('****** deserialized: ' + disRecords);
            //if(disRecords.size() > 0){
                disRecords.add(ApexPages.CurrentPage().getParameters().get('recordId'));
                //system.debug('****** deserialized 2: ' + disRecords);
                user_preferences[0].Dismissed_Records__c = json.serialize(disRecords);
                update user_preferences[0];
            //}
        }
        
        getDismissedRecords();
        //applyFilter();
    }
    
    public void removeAsDismissed(){
       
        disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
        //system.debug('***** disRecords: ' + disRecords);
        //system.debug('***** recordId: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        if(disRecords.contains(ApexPages.CurrentPage().getParameters().get('recordId'))){
            disRecords.remove(ApexPages.CurrentPage().getParameters().get('recordId'));
            user_preferences[0].Dismissed_Records__c = json.serialize(disRecords);
            update user_preferences[0];
        }
        //system.debug('***** disRecords: ' + disRecords);
        getDismissedRecords();
                                                    
    }
    
    public void getDismissedRecords(){
        isDismissedId = new map<String, Boolean>();
                     
        try{            
            if(user_preferences.size() > 0){
                ///system.debug('***** ' + up[0].Dismissed_Records__c);
                if (user_preferences[0].Dismissed_Records__c != null) disRecords = (set<String>) json.deserialize(user_preferences[0].Dismissed_Records__c, set<String>.class);
                else disRecords = new set<String>();
            }else disRecords = new set<String>();
            for(Engagement__c a: getengList()){
                if(disRecords.contains(a.Id)){
                    isDismissedId.put(a.Id, true);
                }else isDismissedId.put(a.Id, false);
            }
        }catch(Exception e){
            system.debug('***** Exception getDismissedRecords: ' + e);
        }
    }
    
    public void getExitInterviews(){
        isExitInterviewId = new map<String, Boolean>();

         list<Assessment__c> listAssessment = [Select a.Engagement__c, a.Participant_Description__c, a.Match_Break_Reason_Detail__c, a.Vacation_Days_Taken__c, a.Education_Allowance_Owed__c, a.Stipend_Owed_Amount__c
                                                From Assessment__c a
                                                Where a.RecordType.Name = 'APC Exit Interview'
                                                ORDER BY CreatedDate DESC
                                                //LIMIT 1
                                                ];
                                              
        try{     
            set<string> setAssessments = new set<string>();      
            for(Assessment__c m :listAssessment){ 
                setAssessments.add(m.Engagement__c); 
            }
                
            for(Engagement__c a: getengList()){
                if(setAssessments.contains(a.Id)){
                    isExitInterviewId.put(a.Id, true);
                }else isExitInterviewId.put(a.Id, false);
            }
        }catch(Exception e){
            system.debug('***** Exception getExitInterviews: ' + e);
        }
    }
    
    public Map<String, String> pt_photos{get;set;}
        
    public void getParticipantPhotoList(){
            list<Intrax_Program_Upload__c> photos;
            List<Engagement__c> ptEng = new List<Engagement__c>();
            if(key_object == 'Engagement__c'){          
                /*photos = [SELECT Document_GUID__c, Description__c FROM Intrax_Program_Upload__c 
                            WHERE Engagement__c =: ApexPages.CurrentPage().getParameters().get('pt_id')
                            AND Document_Type__c = 'Participant-Album' limit 5
                            ];*/
                  ptEng = [select Id,Intrax_Program__c from Engagement__c where RecordType.Name = 'AuPairCare PT' and Id = :ApexPages.CurrentPage().getParameters().get('pt_id')];
            }else{
                photos = [SELECT Document_GUID__c, Description__c FROM Intrax_Program_Upload__c 
                            WHERE Applicant_Info__c =: ApexPages.CurrentPage().getParameters().get('pt_id')
                            AND Document_Type__c = 'Participant-Album' limit 5
                            ];
            }
            
            Map<String, String> myGUIDs = new Map<String, String>();
        
            
            
            if(key_object != 'Engagement__c'){
                for(Intrax_Program_Upload__c ipu : photos) myGUIDs.put(ipu.Document_GUID__c, ipu.Description__c);  
                pt_photos = aws_controller.getPhotoListWithDesc(myGUIDs);
            }
            else{
                /*for(Intrax_Program_Upload__c ipu : photos) myGUIDs.put(ipu.Document_GUID__c, ipu.Description__c);  
                pt_photos = aws_controller.getPhotoListWithDesc(myGUIDs);*/
                pt_photos = aws_controller.getParticipantIPUURL(ptEng,true);
            }
            system.debug('+-+-+-+- pt_photos: ' + pt_photos);           
    }
    
   
 /*
    public list<String> pt_photos{get;set;}
    
    public void getParticipantPhotoList(){
        system.debug('******** pt_id ' + ApexPages.CurrentPage().getParameters().get('pt_id'));
        list<Intrax_Program_Upload__c> photos;
        if(key_object == 'Applicant_Info__c'){
            photos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
                            WHERE Applicant_Info__c =: ApexPages.CurrentPage().getParameters().get('pt_id')
                            AND Document_Type__c = 'Participant-Album' limit 5
                            ];
        }else if(key_object == 'Engagement__c'){
            photos = [SELECT Document_GUID__c FROM Intrax_Program_Upload__c 
                            WHERE Engagement__c =: ApexPages.CurrentPage().getParameters().get('pt_id')
                            AND Document_Type__c = 'Participant-Album' limit 5
                            ];
        }
        
        list<String> myGUIDs = new list<String>();
        
        for(Intrax_Program_Upload__c ipu : photos) myGUIDs.add(ipu.Document_GUID__c);
                    
        pt_photos = aws_controller.getPhotoList(myGUIDs);
    }

*/
    public void retrieveVideo(){     
        //Applicant_Info__c applicantInfo = new Applicant_Info__c();
        Engagement__c eng = new Engagement__c();
        //String appId = ApexPages.CurrentPage().getParameters().get('pt_id'); 
        String ptId = ApexPages.CurrentPage().getParameters().get('pt_id'); 
        //system.debug('@@@@@### appId: ' + ApexPages.CurrentPage().getParameters().get('pt_id'));
        if(ptId!=null){
            if(key_object == 'Applicant_Info__c'){
                Applicant_Info__c applicantInfo = new Applicant_Info__c();
                applicantInfo = [Select Id, Name from Applicant_Info__c where Id =:ptId ];
                MapPTVideoThumb = aws_controller.getVideosParticipant(applicantInfo);
            }
            else if(key_object == 'Engagement__c'){
                Engagement__c engagement = new Engagement__c();
                engagement = [Select Id, Name from Engagement__c where Id =: ptId ];
                MapPTVideoThumb = aws_controller.getVideosParticipant(engagement);
            }               
        }    
                           
        set<String> mapvidKeys;
        list<Map<String, Intrax_Program_Upload__c>> mapvidValues;
                           
        if(MapPTVideoThumb != null && !MapPTVideoThumb.isEmpty() && !MapPTVideoThumb.values()[0].isEmpty() ){
            try{
                MapVideoSize = MapPTVideoThumb.size();
                mapvidKeys = MapPTVideoThumb.keyset();
                mapvidValues = MapPTVideoThumb.values();
                //system.debug('@@@@@### MapVideoSize: ' + MapVideoSize);
                //system.debug('@@@@@### mapvidKeys: ' + mapvidKeys);
                //system.debug('@@@@@### mapvidValues: ' + mapvidValues);
                }catch(Exception e){
                    system.debug('******** e');
                    MapVideoSize=0;
                }
        }else{
            MapVideoSize=0;
        }
    }
    
    // *********** WRAPPER SECTION
    //###Comparation Procces - Search Wrapper
    public list<SearchWrapper> searchListAux;
    public list<SearchWrapper> searchList{get; set;}
    
    public List<SearchWrapper> wrappers{
        get{
            list<SearchWrapper> searchItems = new List<SearchWrapper>();
            
            for (Engagement__c searchItem : (List<Engagement__c>)results.getRecords()){
                SearchWrapper wrap = new SearchWrapper(searchItem);
                for(SearchWrapper sl:searchList){
                    if(sl.eng.id == wrap.eng.id && sl.checked == true){
                        wrap.checked = true;
                    }
                }
              
                searchItems.add(wrap);  
                        
            }
            
            
            
            //system.debug('@@@@@ searchItems: ' + searchItems);
            searchListAux = new list<SearchWrapper>();
            searchListAux = searchItems;
            return searchItems;
        }set;
    }
    
    public void removeElementFromWrapper(){
        //system.debug('@@@@@ recordId: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        for (SearchWrapper swa : searchListAux){
            if(swa.eng.Id == ApexPages.CurrentPage().getParameters().get('recordId')){
                swa.checked = false;    
                
            }
            for(Integer i = 0; i < searchList.size(); i++){
                if(searchList[i].eng.id == ApexPages.CurrentPage().getParameters().get('recordId') &&
                   ApexPages.CurrentPage().getParameters().get('recordId') == swa.eng.id ){
                    searchList.remove(i);
                }
            }
        }
        
    }   
    
    public void buildWrapper(){
        //system.debug('@@@@@ buildWrapper() searchListAux: ' + searchListAux);
        //system.debug('@@@@@ buildWrapper() searchList: ' + searchList);
        //system.debug('@@@@@ recordId: ' + ApexPages.CurrentPage().getParameters().get('recordId'));
        Boolean isChecked = false;
        for (SearchWrapper swa : searchListAux) {
            
            if(swa.checked){
                for(Integer i = 0; i < searchList.size(); i++){
                    if(searchList[i].eng.id == ApexPages.CurrentPage().getParameters().get('recordId')){
                        isChecked = true;
                        break;
                    }
                  }
                if(isChecked == false &&  ApexPages.CurrentPage().getParameters().get('recordId') == swa.eng.id){
                    searchList.add(swa);
                }
             }else{
                  for(Integer i = 0; i < searchList.size(); i++){
                    if(searchList[i].eng.id == ApexPages.CurrentPage().getParameters().get('recordId') &&
                       ApexPages.CurrentPage().getParameters().get('recordId') == swa.eng.id ){
                        searchList.remove(i);
                    }
                  }
             }
         } 
         //system.debug('@@@@@ searchList: ' + searchList);
    }
    
    public void removeWrapper(){
        
         searchList = new list<SearchWrapper>();
         //system.debug('@@@@@ searchList: ' + searchList);
    }
    
    public list<SelectOption> nationalityOptions_final;
    public List<SelectOption> NationalityOptions{
        get{
            if(nationalityOptions_final == null || nationalityOptions_final.size() == 0 ){
                list<Engagement__c> myEngList = dataBase.query(getDefaultQuery());
                //list<Engagement__c> myEngList = (List<Engagement__c>) results.getRecords();
                List<SelectOption> options = new List<SelectOption>();
                list<String> active_nationalities = new list<String>();
                
                for(Engagement__c e : myEngList){
                    active_nationalities.add(e.Nationality__c);             
                }
                active_nationalities.sort();
                set<string> active_nationalities_set = new set<String>();
                active_nationalities_set.addAll(active_nationalities);
                            
                for(string s : active_nationalities_set){
                    if(s!=null) options.add(new SelectOption(s,s));
                }
                nationalityOptions_final = options;   
                return options;
            }else return nationalityOptions_final;
        }set;
    }
    public list<SelectOption> languageOptions_final;
    public List<SelectOption> LanguageOptions{
        get{            
            if(languageOptions_final == null || languageOptions_final.size() == 0 ){
                list<Engagement__c> myEngList = dataBase.query(getDefaultQuery());
                //list<Engagement__c> myEngList = (List<Engagement__c>) results.getRecords();
                List<SelectOption> options = new List<SelectOption>();
                list<String> active_languages = new list<String>();
                
                for(Engagement__c e : myEngList){
                    active_languages.add(e.Language_1__c);       
                    if(e.Language_2__c != null) active_languages.add(e.Language_2__c);       
                    if(e.Language_3__c != null) active_languages.add(e.Language_3__c);              
                }
                active_languages.sort();
                set<string> active_languages_set = new set<String>();
                active_languages_set.addAll(active_languages);
                            
                for(string s : active_languages_set){
                    if(s!=null) options.add(new SelectOption(s,s));
                }
                languageOptions_final = options;                  
                return options;
            }else return languageOptions_final;
        }set;
    }
    
    public List<SelectOption> ExperienceOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult =
            Experience__c.Children_Ages__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
                  
            return options;
        }set;
    }
    
    public List<SelectOption> experienceTypeOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult =
            Experience__c.Experience_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
                  
            return options;
        }set;
    }
    
    public list<SelectOption> ageOptions{
        get{
            ageOptions = new list<SelectOption>();
            ageOptions.add(new selectOption('18', '18'));
            ageOptions.add(new selectOption('19', '19'));
            ageOptions.add(new selectOption('20', '20'));
            ageOptions.add(new selectOption('21', '21'));
            ageOptions.add(new selectOption('22', '22'));
            ageOptions.add(new selectOption('23', '23'));
            ageOptions.add(new selectOption('24', '24'));
            ageOptions.add(new selectOption('25', '25'));
            ageOptions.add(new selectOption('26', '26'));
            return ageOptions;
        }set;           
    }
    
    public List<SelectOption> DietOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            /// CHANGE TO ENGAGEMENT!!!!
            Schema.DescribeFieldResult fieldResult =
            Engagement__c.Special_Diet__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
                  
            return options;
        }set;
    }
    
    public List<SelectOption> hobbiesOptions{
        get{
            list<SelectOption> options = new list<SelectOption>();
            /// CHANGE TO ENGAGEMENT!!!!
            Schema.DescribeFieldResult fieldResult; 
            List<Schema.PicklistEntry> ple;
            
            fieldResult = Engagement__c.Interest_Sports__c.getDescribe();
            ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
            
            fieldResult = Engagement__c.Interest_Fine_Arts__c.getDescribe();
            ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
            
            fieldResult = Engagement__c.Interests_Hobbies__c.getDescribe();
            ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }           
                  
            return options;
        }set;
    }
    
    public Date firstAvailableArrivalDate{
        get{
            try{
                APC_ArrivalDates__c arrivalDates =  [Select US_Arrival__c, Match_Request_Deadline__c
                                                   From APC_ArrivalDates__c
                                                   Where Match_Request_Deadline__c >= :date.today()
                                                   Order By Match_Request_Deadline__c Asc
                                                   Limit 1];
                                                   
                return arrivalDates.US_Arrival__c;
            
            }catch(Exception e){
                system.debug('Error getting arrival dates: ' + e);          
                return date.today();
            }
        }set;
    }
    
    public List<SelectOption> ArrivalDates{
        get{
            try{
            //system.debug('****@@@@inside  getlistArrivalDates()');
            
            list<SelectOption> optionsDate = new List<SelectOption>();
            system.debug('****** TODAY(): ' + date.today());
            
            List<APC_ArrivalDates__c> listArrivalDates =  [Select US_Arrival__c, Match_Request_Deadline__c
                                                           From APC_ArrivalDates__c
                                                           Where Match_Request_Deadline__c >= :date.today()
                                                           Order By Match_Request_Deadline__c Asc];
            
            //system.debug('****@@@@ listArrivalDates: ' + listArrivalDates); 
            
            if(listArrivalDates!= null && listArrivalDates.size()>0){
            Integer firstmonth = listArrivalDates[0].US_Arrival__c.month();
            Integer firstyear = listArrivalDates[0].US_Arrival__c.year();
            String firstmonthStr = String.valueOf(firstmonth);
            String firstyearStr = String.valueOf(firstyear);
                
            Integer lastmonth = listArrivalDates[listArrivalDates.size()-1].US_Arrival__c.month();
            Integer lastyear = listArrivalDates[listArrivalDates.size()-1].US_Arrival__c.year();
            String lastmonthStr = String.valueOf(lastmonth);
            String lastyearStr = String.valueOf(lastyear);
                
            String label;
            String value; 
            
            //system.debug('****@@@@ firstmonth: ' + firstmonth); 
            //system.debug('****@@@@ firstyear: ' + firstyear); 
            //system.debug('****@@@@ lastmonth: ' + lastmonth); 
            //system.debug('****@@@@ lastyear: ' + lastyear); 
            
         
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

                
             //Creating a days Map<>
            Map<Integer,Integer> daysMap = new Map<Integer,Integer>();    
            daysMap.put(1,31); //'January'
            daysMap.put(2,28); //'February'
            daysMap.put(3,31); //'March
            daysMap.put(4,30); //'April
            daysMap.put(5,31); //'May'
            daysMap.put(6,30); //'June'
            daysMap.put(7,31); //'July'
            daysMap.put(8,31); //'August'
            daysMap.put(9,30); //'September'
            daysMap.put(10,31);  //'October'
            daysMap.put(11,30); //'November');
            daysMap.put(12,31); //'December');
            
            //Creating months values for current year
            for(integer r=firstmonth; r<13; r++){
                 //value = String.valueOf(r) +'/'+ '01'+'/'+ firstyear;
                 value = String.valueOf(r) +'/'+ daysMap.get(r) +'/'+ firstyear;
                 label = monthMap.get(r) +' '+ firstyearStr;
                 optionsDate.add(new SelectOption(value, label)); 
            }
            
            if(firstyear != lastyear){        
                //Creating months values for next year
                for(integer j=1; j<13; j++){
                     //value = String.valueOf(j) +'/'+ '01'+'/'+ lastyear;
                     value = String.valueOf(j) +'/'+ daysMap.get(j) +'/'+ lastyear;
                     label = monthMap.get(j) +' '+ lastyear;
                     optionsDate.add(new SelectOption(value, label)); 
                }
            }
                       
           //system.debug('****@@@@ optionsDate: ' + optionsDate); 
               return optionsDate;
            
           }else{
            return null;
           }
           
        }catch(Exception e){system.debug('@@@@@ Exception in ArrivalDates: ' + e);
            return null;
        }
        }set;
    }  
    
    
    public List<SelectOption> USArrivalDates{
        get{
        
            //system.debug('****@@@@inside  getlistUSArrivalDates()');
            
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
            
            //system.debug('****@@@@ currentmonth: ' + currentmonth); 
            //system.debug('****@@@@ currentyear: ' + currentyear);
            
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
           
           //system.debug('****@@@@ optionsDate: ' + optionsDate); 
            
           return optionsDate;
        }set;
    } 
     
    public map<string, boolean> highlightsEmpty{
        get{
            map<string, boolean> values = new map<string, boolean>();
            map<String, list<String>> highlights = apc_portal_utilities.highLightsBuilder(getEngList());
            for(string engId : highlights.keySet()){
                if(highlights.get(engId).size() == 0)  values.put(engId, false);
                else values.put(engId, true);
            }
            
            return values;
            
        }set;
        
    }
    
    public map<String, list<String>> highlights {
        get{        
            map<String, list<String>> HLList = apc_portal_utilities.highLightsBuilder(getEngList());
                                        /*, primary,
                                        LifeGuardDocList, siblingList,
                                        listExperience, getMapEducation().get('University/College'),
                                        getMapEducation().get('Vocational Training'));  */  
            return HLList;
        }       
    }
    
    //JOSE B-03139 Display Match Request Deadline messages in HF and PT portals (Match Deadlines - B)
    public APC_ArrivalDates__c APCArrivalDates {
        get{        
            APC_ArrivalDates__c APCArrivalDates = new APC_ArrivalDates__c();
            APCArrivalDates = apc_portal_utilities.MatchRequestDeadline();
            return APCArrivalDates;
        }       
    }
    
    
    public void getVisitedRecords(){
        
        isVisitedId = new map<String, Boolean>();
        set<String> viewRecords = new set<String>();
        
        try{
                                            
            if(user_preferences.size() != 0){             
                // We already have a record for this user --> We need to deserialize the existing data
                if (user_preferences[0].Viewed_Records__c != null) {
                     viewRecords = (set<String>) json.deserialize(user_preferences[0].Viewed_Records__c, set<String>.class);
                }               
            }       
            
            for(String id : viewRecords){
                isVisitedId.put(id, true);
            }       
            
            for(Engagement__c a: getengList()){
                if(!isVisitedId.containsKey(a.Id)){
                    isVisitedId.put(a.Id, false);
                }
            }                           
            
            
            
            }catch(Exception e){
                system.debug('Error getting the visited records: ' + e);
            }
                
            //system.debug('@@@@@isVisitedId: ' + isVisitedId);           
   
        
    }
    
     public PageReference saveVisit(){
        //system.debug('****** saveVisit'); 
        
        set<String> viewRecords = new set<String>();
             
        if(user_preferences.size() == 0){
            // We need to create a new record
            User_Preference__c upnew = new User_Preference__c(User__c = userInfo.getUserId());          
            viewRecords.add(ApexPages.CurrentPage().getParameters().get('recordId'));
            upnew.Viewed_Records__c = json.serialize(viewRecords);
            upnew.Object__c = key_object;
            
            //system.debug('viewRecords: ' + viewRecords);        
            insert upnew;   
        }else{
            // We already have a record for this user --> We need to deserialize the existing data
            if (user_preferences[0].Viewed_Records__c != null) {
                 viewRecords = (set<String>) json.deserialize(user_preferences[0].Viewed_Records__c, set<String>.class);
            }
            
            //system.debug('****** deserialized: ' + viewRecords);
            
            if (!viewRecords.contains(ApexPages.CurrentPage().getParameters().get('recordId'))) {
                viewRecords.add(ApexPages.CurrentPage().getParameters().get('recordId'));
                system.debug('****** deserialized 2: ' + viewRecords);
                user_preferences[0].Viewed_Records__c = json.serialize(viewRecords);
                update user_preferences[0];
                
                Engagement__c engagement = [Select Id, Portal_Views_Count__c FROM Engagement__c WHERE Id =: ApexPages.CurrentPage().getParameters().get('recordId')];
        
                if (engagement.Portal_Views_Count__c == null) {
                    engagement.Portal_Views_Count__c = 1;
                }else{
                    engagement.Portal_Views_Count__c = engagement.Portal_Views_Count__c + 1 ;
                }                                       
                
                update engagement;
            }           
        } 
         
        PageReference pageRef = new PageReference('/apex/apc_hf_au_pair_profile?id=' + ApexPages.CurrentPage().getParameters().get('recordId'));
        pageRef.setRedirect(true); 
        return pageRef;     
    }
    
    public void showOnlyFavorite(){
        //system.debug('***** onlyFavorite: '+ onlyFavoriteSelected);
        
        String onlyFavoriteSelectedAux = onlyFavoriteSelected;
        
        clearAllFilters();
                
        f_object = 'Show_only_favorites';
        f_field = 'Show_only_favorites';
        f_label = 'My Favorites';
        
        onlyFavoriteSelected = onlyFavoriteSelectedAux;
        
        applyFilter();
    }
    
    
   public void showOnlySuggested (){
        //system.debug('***** onlySuggested: ' + onlySuggestedSelected);
        
        String onlySuggestedSelectedAux = onlySuggestedSelected;
        
        clearAllFilters();
        
        f_object = 'Show_only_suggested';
        f_field = 'Show_only_suggested';
        f_label = 'Suggested Au Pairs';     
        
        onlySuggestedSelected = onlySuggestedSelectedAux;
                
        applyFilter();
    }
    
        
    public List<SelectOption> savedSearchNames{
        get{
        
            //system.debug('****@@@@inside  savedSearchNames() ' + savedFilters );
            
            list<SelectOption> optionsSavedSearch = new List<SelectOption>();
          
            for (String searchName : savedFilters.keySet()){
                optionsSavedSearch.add(new SelectOption(searchName, searchName)); 
            }
                       
           //system.debug('****@@@@ optionsSavedSearch: ' + optionsSavedSearch); 
            
           return optionsSavedSearch;
        }set;
    } 
    
    
    private void saveOrderByCookie(){
        Cookie mySessionIDCookie = new Cookie('mySessionIDCookie', UserInfo.getSessionID(), null,-1,false);     
        Cookie orderByCookie = new Cookie('orderByCookie', sortingSelected,null,-1,false);
        system.debug('@@@@@@@ saveOrderByCookie: ' + orderByCookie);
        ApexPages.currentPage().setCookies(new Cookie[]{orderByCookie, mySessionIDCookie}); 
    }     
    
    private void savePageNumberCookie(){
        Cookie mySessionIDCookie = new Cookie('mySessionIDCookie', UserInfo.getSessionID(), null,-1,false);     
        Cookie pageNumberCookie = new Cookie('pageNumberCookie', pageNumberSelected,null,-1,false);
        system.debug('@@@@@@@ pageNumberCookie: ' + pageNumberCookie);
        ApexPages.currentPage().setCookies(new Cookie[]{pageNumberCookie, mySessionIDCookie}); 
    }    
    
    private void savePageSizeCookie(){
        Cookie mySessionIDCookie = new Cookie('mySessionIDCookie', UserInfo.getSessionID(), null,-1,false);     
        Cookie pageSizeCookie = new Cookie('pageSizeCookie', String.valueof(pageSize),null,-1,false);
        //system.debug('@@@@@@@ pageSizeCookie: ' + pageSizeCookie);
        ApexPages.currentPage().setCookies(new Cookie[]{pageSizeCookie, mySessionIDCookie}); 
    } 

    private void saveCookieSearch(){            
        Cookie mySessionIDCookie = new Cookie('mySessionIDCookie', UserInfo.getSessionID(), null,-1,false);     
        Cookie searchFiltersCookie = new Cookie('searchFiltersCookie', json.serialize(myFilters),null,-1,false);
        //system.debug('@@@@@@@ searchFiltersCookie: ' + searchFiltersCookie);
        ApexPages.currentPage().setCookies(new Cookie[]{searchFiltersCookie,mySessionIDCookie}); 
    }
    
    private String getOrderByCookie(){
        String mySessionID = UserInfo.getSessionID();
        Cookie mySessionIDCookie = ApexPages.currentPage().getCookies().get('mySessionIDCookie');
        String orderByCookie = null;
        
        if(mySessionIDCookie != null){
            if(mySessionIDCookie.getValue() != mySessionID){
                saveSessionIdCookie();
                deleteRelatedCookies(); 
            }else{
                Cookie cookieOrderBy = ApexPages.currentPage().getCookies().get('orderByCookie'); 
                system.debug('@@@@@@@ getOrderByCookie: ' + cookieOrderBy);   
                if(cookieOrderBy != null){
                    if(cookieOrderBy.getValue() != null && cookieOrderBy.getValue() != ''){
                        orderByCookie = cookieOrderBy.getValue();                       
                    }               
                }
            }    
        }else{
            saveSessionIdCookie(); 
            deleteRelatedCookies(); 
        }
        system.debug('@@@@@@@ orderByCookie: ' + orderByCookie);   
        return orderByCookie;
    }     
    
    private String getPageNumberCookie(){
        String mySessionID = UserInfo.getSessionID();
        Cookie mySessionIDCookie = ApexPages.currentPage().getCookies().get('mySessionIDCookie');
        String pageNumberCookie = null;
        
        //system.debug('@@@@@@@ getPageNumberCookie mySessionID: ' + mySessionID);
        //system.debug('@@@@@@@ getPageNumberCookie mySessionIDCookie: ' + mySessionIDCookie);
        
        if(mySessionIDCookie != null){
            if(mySessionIDCookie.getValue() != mySessionID){
                saveSessionIdCookie();
                deleteRelatedCookies(); 
            }else{
                Cookie cookiePageNumber = ApexPages.currentPage().getCookies().get('pageNumberCookie'); 
                system.debug('@@@@@@@ getPageNumberCookie: ' + cookiePageNumber);   
                if(cookiePageNumber != null){
                    if(cookiePageNumber.getValue() != null && cookiePageNumber.getValue() != '' && totalPages >= Integer.valueof(cookiePageNumber.getValue())){
                        pageNumberCookie = cookiePageNumber.getValue();                     
                    }               
                }
            }    
        }else{
            saveSessionIdCookie(); 
            deleteRelatedCookies(); 
        }
        
        return pageNumberCookie;
        
    }
    
    private void saveSessionIdCookie(){
        Cookie mySessionIDCookie = new Cookie('mySessionIDCookie', UserInfo.getSessionID(), null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{mySessionIDCookie});    
    }
    
    private String getSessionIdCookie(){
        String cookieMySession = null;
        Cookie mySessionIDCookie = ApexPages.currentPage().getCookies().get('mySessionIDCookie');
        if (mySessionIDCookie != null && mySessionIDCookie.getValue() != null && mySessionIDCookie.getValue() != ''){
            cookieMySession = mySessionIDCookie.getValue();
        }
        return cookieMySession; 
    }
    
    private Integer getPageSizeCookie(){
        String mySessionID = UserInfo.getSessionID();
        Cookie mySessionIDCookie = ApexPages.currentPage().getCookies().get('mySessionIDCookie');
        Integer pageSizeCookie = null;
        //system.debug('@@@@@@@ getPageSizeCookie mySessionID: ' + mySessionID);
        //system.debug('@@@@@@@ getPageSizeCookie mySessionIDCookie: ' + mySessionIDCookie);
        
        if(mySessionIDCookie != null){
            if(mySessionIDCookie.getValue() != mySessionID){
                saveSessionIdCookie();
                deleteRelatedCookies();
            }else{
                Cookie cookiePageSize = ApexPages.currentPage().getCookies().get('pageSizeCookie'); 
                //system.debug('@@@@@@@ getPageSizeCookie: ' + cookiePageSize);
                if(cookiePageSize != null){
                    if(cookiePageSize.getValue() != null && cookiePageSize.getValue() != ''){
                        pageSizeCookie = Integer.valueof(cookiePageSize.getValue()); 
                    }                           
                } 
            }    
        }else{
            saveSessionIdCookie();
            deleteRelatedCookies(); 
        }
        
        return pageSizeCookie;
   
    }
     

    private void deleteRelatedCookies(){
        Cookie searchFiltersCookie = new Cookie('searchFiltersCookie', json.serialize(new map<string, map<String, set<String>>>()),null,1,false);
        Cookie pageSizeCookie = new Cookie('pageSizeCookie', null,null,1,false);
        Cookie pageNumberCookie = new Cookie('pageNumberCookie', null,null,1,false);
        Cookie orderByCookie = new Cookie('orderByCookie', null,null,1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{searchFiltersCookie,pageSizeCookie,pageNumberCookie,orderByCookie});
    }
    
    private void applyCookieSearch(){     
        String mySessionID = UserInfo.getSessionID();
        Cookie mySessionIDCookie = ApexPages.currentPage().getCookies().get('mySessionIDCookie');
        
        if(mySessionIDCookie != null && mySessionIDCookie.getValue() != mySessionID){
            mySessionIDCookie = new Cookie('mySessionIDCookie', mySessionID, null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{mySessionIDCookie}); 
            deleteRelatedCookies();
        }
        
        Cookie searchFiltersCookie = ApexPages.currentPage().getCookies().get('searchFiltersCookie');

        if(searchFiltersCookie != null) {
            myfilters.keySet().removeAll(myfilters.keySet());
            myfilters = ( map<string, map<String, set<String>>>) json.deserialize(searchFiltersCookie.getValue(), map<string, map<String, set<String>>>.class);
            buildQuery(true); 
                        
        }
        
    }
    
    public void applySavedSearch(){     
        clearAllFilters();
        getSavedFilters();
        //system.debug('****@@@@ applySavedSearch: ' + savedSearchSelected);
        //system.debug('****@@@@ savedFilters: ' + savedFilters);
        //system.debug('****@@@@ SavedSearch: ' + savedFilters.get(savedSearchSelected));
        myfilters = savedFilters.get(savedSearchSelected);
        savedSearchSelected = '';
        buildQuery();       
    }
    
    public void getSavedFilters(){
        savedFilters = new map<string, map<string, map<String, set<String>>>>();
        
        if(user_preferences.size() != 0 && user_preferences[0].Saved_Searches__c != null){
             savedFilters = (map<string, map<string, map<String, set<String>>>>) json.deserialize(user_preferences[0].Saved_Searches__c, map<string, map<string, map<String, set<String>>>>.class);
        }               
    }
    
    public void saveSearch(){
            
        savedFilters = new map<string, map<string, map<String, set<String>>>>();
  
        if(user_preferences.size() == 0){
            // We need to create a new record               
            savedFilters.put(saveSearchName,myFilters);
            
            User_Preference__c upnew = new User_Preference__c(User__c = userInfo.getUserId());
            upnew.Saved_Searches__c = json.serialize(savedFilters);
            upnew.Object__c = key_object;
 
            //system.debug('****** Insert savedFilters: ' + savedFilters);    
            
            insert upnew;
        }else{
            if (user_preferences[0].Saved_Searches__c != null){
                 savedFilters = (map<string, map<string, map<String, set<String>>>>) json.deserialize(user_preferences[0].Saved_Searches__c, map<string, map<string, map<String, set<String>>>>.class);
            }
            
            savedFilters.remove(saveSearchName);                
            
            savedFilters.put(saveSearchName,myFilters);
            user_preferences[0].Saved_Searches__c = json.serialize(savedFilters);
            
            //system.debug('****** update savedFilters: ' + savedFilters);   
            
            update user_preferences[0];
        }
        
        saveSearchName = '';
        isAlreadySavedSearch = true;
    }
    
     
    public void getMapFieldLabel(){
        map_field_label = new Map<String,String>();
        
        map_field_label.put('Preferred Arrival', 'Earliest_Match_Date__c');
        map_field_label.put('Nationality', 'Nationality__c');
        map_field_label.put('Language Spoken','Language_1__c');
        map_field_label.put('Experience with Ages', 'Children_Ages__c');
        map_field_label.put('Swimmers Only', 'Swimming_Indicated__c');
        map_field_label.put('Au Pair\'s Current Location', 'In_Country__c');
        map_field_label.put('Au Pair\'s Training', 'Infant_Specialized_Circulated__c');
        map_field_label.put('Minimum Age', 'Age_At_Program_Start__c');
        map_field_label.put('Hobbies and Interests', 'Interest_Sports__c');
        map_field_label.put('Special Diet', 'Special_Diet__c');
        map_field_label.put('Gender', 'Gender__c');
        map_field_label.put('Drivers Only', 'Drivers_Licence_Indicated__c');
        map_field_label.put('Swimmers Only', 'Swimming_Indicated__c');
        map_field_label.put('Suggested Only', 'Show_only_suggested');
        map_field_label.put('Favorites Only', 'Show_only_favorites');
        
    }

    
    public void getIsAlreadySavedSearch(){
        Boolean result = false;
        getSavedFilters();      
        //system.debug('-*-*-*-*-*- savedFilters:' + savedFilters);       
        //system.debug('-*-*-*-*-*- myFilters:' + myFilters);     
        for(String searchName : savedFilters.keySet()){
            if(result == false){
                //system.debug('-*-*-*-*-*- searchName:' + searchName);
                map<string, map<String, set<String>>> savedObjects = savedFilters.get(searchName); 
                boolean check_object = true;                                
                    for(String objectName : savedObjects.keySet()){
                        if(check_object == true){
                            //system.debug('-*-*-*-*-*- objectName:' + objectName);
                            if(savedObjects.size() == myFilters.size() && myFilters.containsKey(objectName)){
                                map<String, set<String>> filters = savedObjects.get(objectName);
                                map<String, set<String>> filtersAux = myFilters.get(objectName);
                                boolean check_category = true;  
                                for(String f_category : filters.keySet()){
                                    if(check_category == true){
                                        //system.debug('-*-*-*-*-*- f_category:' + f_category);
                                        if(filters.size() == filtersAux.size() && filtersAux.containsKey(f_category)){
                                            check_category = compareSetValues(filters.get(f_category), filtersAux.get(f_category));
                                        }else{
                                            check_category = false;
                                            break;
                                        }
                                    }
                                }                               
                                check_object = check_category;                                                                  
                            }else{
                                check_object = false;
                                break;
                            }
                        }
                    }                   
                    result = check_object;                              
                }
            }
            
        //system.debug('-*-*-*-*-*- isAlreadySavedSearch result:' + result);
        isAlreadySavedSearch = result;  
    }
    
    
    
    private Boolean compareSetValues (set<String> set1, set<String> set2){
        Boolean result = true;
        //system.debug('-*-*-*-*-*- compareSetValues: ' + set1);
        //system.debug('-*-*-*-*-*- compareSetValues: ' + set2);
        if(set1.size() == set2.size()){
            for (String str1 : set1){
                //system.debug('-*-*-*-*-*- str1:' + str1);
                //system.debug('-*-*-*-*-*- set2.contains(str1):' + set2.contains(str1));
                if (!set2.contains(str1)) result = false;
            }
        }else{
            result = false;
        }
        
        //system.debug('-*-*-*-*-*- compareSetValues result:' + result);
        return result;
    }
    
    
    public void getAppplicationType(){
                
        applicationTypeMap = new map<String, String>();
            
            try{
        
                    list<Applicant_Info__c> applicant = [Select Engagement__c, Application_Type__c, CreatedDate  
                                                            From Applicant_Info__c
                                                            Where Engagement__c != null and Application_type__c != null
                                                            and Engagement__c IN : getengList()
                                                            Order By  Engagement__c, CreatedDate Desc];                                          
                                                        
                    
                    for(Applicant_Info__c app : applicant){             
                        if (app.Engagement__c != null && !applicationTypeMap.containsKey(app.Engagement__c)){                       
                            applicationTypeMap.put(app.Engagement__c,app.Application_Type__c);
                        }
                    }
                    
                    for(Engagement__c a: getengList()){
                        if(!applicationTypeMap.containsKey(a.Id)){
                            applicationTypeMap.put(a.Id, '');
                        }
                    }
                    
            }catch(Exception e){
                system.debug('Error getting the applicationType records: ' + e);
            }
                
           //system.debug('@@@@@applicationTypeMap: ' + applicationTypeMap);         
    
    }
    
    public void getMatchEarlyEnded(){
        
        matchEarlyEnded = new map<String, boolean>();
        list<Match__c> listMatch = new list<Match__c>();
        try{
        system.debug('@@@@@matchEarlyEnded: ' + myPosition); 
           listMatch = [Select Status__c, Position_Name__c, Engagement__c 
                                        From Match__c 
                                        Where Position_Name__c =: myPosition.Id
                                        And Status__c = 'Ended Early'];
            system.debug('@@@@@matchEarlyEnded: ' + listMatch); 
            for(Match__c match : listMatch){      
                system.debug('@@@@@matchEarlyEnded: ' + match);           
                matchEarlyEnded.put(match.Engagement__c, true);
            }
            
            for(Engagement__c a: getengList()){
                if(!matchEarlyEnded.containsKey(a.Id)){
                    matchEarlyEnded.put(a.Id, false);
                }
            }
            
        }catch(Exception e){
            system.debug('Error getting the match records: ' + e);
        }
       // system.debug('@@@@@matchEarlyEnded: ' + matchEarlyEnded);    
    }
    
    public String getEarlyEndedCriteria(){
        
        list<Match__c> listMatch = [Select Status__c, Position_Name__c, Engagement__c 
                                        From Match__c 
                                        Where Position_Name__c =: myPosition.Id
                                        And Status__c = 'Ended Early'];
        
        String  idString = '(\'';
        Integer countMatch = 0;
        for(Match__c match : listMatch){      
            system.debug('@@@@@matchEarlyEnded: ' + match);           
            idString += match.Engagement__c + '\',\'';
            countMatch++;        
        }          
                   
        if(countMatch > 0){
            idString = idString.substring(0,idString.length()-2); 
            idString += ')';
            idString = ' AND  Id NOT IN ' + idString;
        }else{
            idString = '';
        }
        
        /*list<Id> idString = new list<Id>();
        for(Match__c match : listMatch){      
            idString.add(match.Engagement__c);
        }
        
        if(idString.size()>0){
            return ' AND  Id NOT IN :idString';
        }*/
        
        system.debug('@@@@@matchEarlyEnded2: ' + idString);
         
        return idString;
    }
    
    
    public String getSelectionCriteria(){
        
        list<Selection__c> listSelection = [Select s.Position__c, s.Id, s.Engagement__c, s.Favorite__c,s.Status__c, s.Interview_Start_Date__c, s.Interview_End_Date__c
                                            From Selection__c s
                                            Where s.Intrax_Program__c = 'AuPairCare' 
                                            And s.Position__c =: myPosition.Id
                                            AND s.Status__c IN ('Active','Inactive')
                                            ORDER BY CreatedDate DESC];         
        
        String  idString = '(\'';
        Integer countMatch = 0;
        for(Selection__c selection : listSelection){      
            system.debug('@@@@@selection: ' + selection);           
            idString += selection.Engagement__c + '\',\'';
            countMatch++;        
        }          
                   
        if(countMatch > 0){
            idString = idString.substring(0,idString.length()-2); 
            idString += ')';
            idString = ' AND  Id NOT IN ' + idString;
        }else{
            idString = '';
        }
        
        /*list<Id> idString = new list<Id>();
        for(Match__c match : listMatch){      
            idString.add(match.Engagement__c);
        }
        
        if(idString.size()>0){
            return ' AND  Id NOT IN :idString';
        }*/
        
        system.debug('@@@@@getSelectionCriteria: ' + idString);
         
        return idString;
    }
    
    

}