/*
    Purpose         :   Ranking Match.
                
    Created Date    :   02/06/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
                        V_1.2 - 07/10/2012 - Modified - Ranking list ordered Ascending
*/
public with sharing class RankingController {
    
    
    //Property to hold Position instance 
    Position__c position;
    Public Position__c DummyObj=new Position__c();
    public Match__c match{get; set;}
    set<Id> ReqMatchEngagementIds;
    Set<Id> engAppInfo; 
    Engagement__c engagement;
    List<Engagement__c> engagements;
    List<Engagement__c> orginalEngagements;
    List<Engagement__c> ReqMatchEngagements;
    List<List<EngagementWrapper>> listOfListEngagements;
    
    //Set to hold the Existing Matches for position
    set<String> existingMatches;
    
    //These properties are for displaying results count message on Searched Result section
    //i.e. Showing 1 - 10 of 100 results
    public Integer resultsStartNumber{get;set;}
    public Integer resultsStopNumber{get;set;}
    public Integer totalResults{get;set;}
    public integer ListIndex = 0;
    public Integer pageNO = 1;
    public Date PositionEngagementStart{get;set;}
    public String ArrivalSelected{get;set;}
    public Date PositionEngagementEnd{get;set;}
    //Sort direction parameter
    public String sortDir {get; set;}
    
    //Variable to store Search result message
    public String searchResultMessage{get;set;}
    
    //Map Opportunity Wrapper
    Map<Integer, List<EngagementWrapper>> mapEngagementWrapper;
    public Map<Integer, List<EngagementWrapper>> mapOfListEngagementWrapper;
    
    public final date d_today = date.today();
    
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> langLevel {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();          
                       
            //add picklist values
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('1', '1'));
            pickListOptions.add(new SelectOption('2', '2'));
            pickListOptions.add(new SelectOption('3', '3'));
            pickListOptions.add(new SelectOption('4', '4'));
            pickListOptions.add(new SelectOption('5', '5'));
                                    
            return pickListOptions;
        }
    }
    
    public List<SelectOption> religiousActivityOptions {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                                   
            pickListOptions.add(new SelectOption('', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Religious_Activity_Home__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
                pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));                   
            }
            
            return pickListOptions;
        }
    }
    
     public List<SelectOption> drivingAbilityFilterOptions {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                                   
            pickListOptions.add(new SelectOption('', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Assessment__c.PT_Driving_Ability__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
                pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));                   
            }
            
            return pickListOptions;
        }
    }
    
    public List<SelectOption> lstlangLevel {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                                   
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Language_1_Proficiency__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
                pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));                   
            }
            
            return pickListOptions;
        }
    }
    
    public List<SelectOption> lstserviceLevel {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();                      
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Service_Level__c.getDescribe();            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() ){
                pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));                   
            }                  
            return pickListOptions;
        }
    }
      //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> ProgDuration {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                      
            //add picklist values
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('1 Month', '1 Month'));
            pickListOptions.add(new SelectOption('2 Months', '2 Months'));
            pickListOptions.add(new SelectOption('3 Months', '3 Months'));
            pickListOptions.add(new SelectOption('4 Months', '4 Months'));
            pickListOptions.add(new SelectOption('5 Months', '5 Months'));
            pickListOptions.add(new SelectOption('6 Months', '6 Months'));
            pickListOptions.add(new SelectOption('7 Months', '7 Months'));
            pickListOptions.add(new SelectOption('8 Months', '8 Months'));
            pickListOptions.add(new SelectOption('9 Months', '9 Months'));
            pickListOptions.add(new SelectOption('10 Months', '10 Months'));
            pickListOptions.add(new SelectOption('11 Months', '11 Months'));
            pickListOptions.add(new SelectOption('12 Months', '12 Months'));            
            return pickListOptions;
        }
    }
   
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstAgeRange {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             
            //add picklist values
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('18–20', '18–20'));
            pickListOptions.add(new SelectOption('21–25', '21–25'));
            pickListOptions.add(new SelectOption('26–30', '26–30'));
            pickListOptions.add(new SelectOption('>30', '>30'));
                        
            return pickListOptions;
        }
    }
    
    public list<SelectOption> apc_ageOptions{
        get{
            list <SelectOption> values = new list<SelectOption>();
            values.add(new SelectOption('--None--', '--None--'));
            values.add(new selectOption('18', '18'));
            values.add(new selectOption('19', '19'));
            values.add(new selectOption('20', '20'));
            values.add(new selectOption('21', '21'));
            values.add(new selectOption('22', '22'));
            values.add(new selectOption('23', '23'));
            values.add(new selectOption('24', '24'));
            values.add(new selectOption('25', '25'));
            values.add(new selectOption('26', '26'));
            return values;
        }set;           
    }
    
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstAges {
        get{            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                       
            //add picklist values
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('15', '15'));
            pickListOptions.add(new SelectOption('16', '16'));
            pickListOptions.add(new SelectOption('17', '17'));
            pickListOptions.add(new SelectOption('18', '18'));
                        
            return pickListOptions;
        }
    }
    
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> PositionType {
        get{
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                     
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Position_Types__c.getDescribe();            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() ){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
            }
            return pickListOptions;
        }
    }
    
    public List<SelectOption> childrenAgesOptions {
        get{
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                     
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Children_Comfortable_Ages__c.getDescribe();            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() ){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
            }
            return pickListOptions;
        }
    }
    
    public List<SelectOption> specialNeedsOptions {
        get{
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                     
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Special_Needs_Circulated__c.getDescribe();            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() ){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
            }
            return pickListOptions;
        }
    }
    
     public List<SelectOption> lstSNK {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Single_No_Children_Indicated__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));         
            }
                       
            return pickListOptions;
        }
    }
    
    public List<SelectOption> TuitionRange {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
                       
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Tuition__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
               pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));         
            }
            
            return pickListOptions;
        }
    }
        //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> GenderPref {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            //pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('Female', 'Female'));
            pickListOptions.add(new SelectOption('Male', 'Male'));
            
            //Describe Program options
                       
            return pickListOptions;
        }
    }
     public List<SelectOption> Categories {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                       
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.School_Category__c.getDescribe();            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));         
            }          
            
            return pickListOptions;
        }
    }
         //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> SmokerFamily {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Smoker_in_Family__c.getDescribe();            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));         
            }
            return pickListOptions;
        }
    }
    
    public List<SelectOption> Religion {
        get {            
           //Variable to hold the picklist data
           List<SelectOption> pickListOptions = new List<SelectOption>();
                       
           pickListOptions.add(new SelectOption('--None--', '--None--'));
           //Describe Program options
           Schema.DescribeFieldResult fieldResult = Applicant_Info__c.Religion__c.getDescribe();
            
           for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));         
           }
           return pickListOptions;
        }
    }
    
    public List<SelectOption> eng_ReligionOptions {
        get {            
           //Variable to hold the picklist data
           List<SelectOption> pickListOptions = new List<SelectOption>();
                       
           pickListOptions.add(new SelectOption('', '--None--'));
           //Describe Program options
           Schema.DescribeFieldResult fieldResult = Engagement__c.Religion__c.getDescribe();
            
           for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));         
           }
           return pickListOptions;
        }
    }
    
    public List<SelectOption> ProgramDuration {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();                      
                       
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('Academic Year', 'Academic Year'));
            pickListOptions.add(new SelectOption('Fall Semester', 'Fall Semester'));                       
            pickListOptions.add(new SelectOption('Spring Semester', 'Spring Semester'));
            //Describe Program options                      
            return pickListOptions;
        }
    }
    
    public List<SelectOption> Interests {
        get {
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Interests__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
            }       
            
            return pickListOptions;
        }
    }
    
    public List<SelectOption> Pets {
        get {            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
                                  
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Pets__c.getDescribe();
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues()){
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));         
            }
            return pickListOptions;
        }
    }
    public list<SelectOption> nationality_final;
    public list<SelectOption> apc_nationality{
        get{
            if(nationality_final == null || nationality_final.size() == 0 ){
                List<SelectOption> options = new List<SelectOption>();
                list<String> active_nationalities = new list<String>();
                
                for(Engagement__c e : engagements){
                    active_nationalities.add(e.Nationality__c);             
                }
                active_nationalities.sort();
                set<string> active_nationalities_set = new set<String>();
                active_nationalities_set.addAll(active_nationalities);
                if(active_nationalities_set.size () > 0) options.add(new SelectOption('--None--', '--None--'));           
                for(string s : active_nationalities_set){
                    if(s!=null) options.add(new SelectOption(s,s));
                }
                nationality_final = options;
                return options;
            }else return nationality_final;
        }set;
        
    }
    
    public List<SelectOption> Nationality {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
                       
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            //MT 354 (Start)
            //Schema.DescribeFieldResult fieldResult = Position__c.Nationality_Preferences__c.getDescribe();
            Schema.DescribeFieldResult fieldResult = Account.Nationality__pc.getDescribe();
            //MT 354 (End)
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
             {
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
             }
            
            
            return pickListOptions;
        }
    }
     //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> PrepRating {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
                      
            //add picklist values
            pickListOptions.add(new SelectOption('1', '1'));
            pickListOptions.add(new SelectOption('2', '2'));
            pickListOptions.add(new SelectOption('3', '3'));
            pickListOptions.add(new SelectOption('4', '4'));
            pickListOptions.add(new SelectOption('5', '5'));
            pickListOptions.add(new SelectOption('6', '6'));
            pickListOptions.add(new SelectOption('7', '7'));
            pickListOptions.add(new SelectOption('8', '8'));
            pickListOptions.add(new SelectOption('9', '9'));
            pickListOptions.add(new SelectOption('10', '10'));
            
            return pickListOptions;
        }
    }
     public List<SelectOption> lstIntraxProgCategory {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Intrax_Program_Category__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
    
    public List<String> selectProgramCategories {get; set;}
    public String selectProgramCategory {get; set;}
      //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> PersonalityRating {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
                      
            //add picklist values
            pickListOptions.add(new SelectOption('1', '1'));
            pickListOptions.add(new SelectOption('2', '2'));
            pickListOptions.add(new SelectOption('3', '3'));
            pickListOptions.add(new SelectOption('4', '4'));
            pickListOptions.add(new SelectOption('5', '5'));
           
            
            return pickListOptions;
        }
    }
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> CompType {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
                      
            //add picklist values
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('Hourly', 'Hourly'));
            pickListOptions.add(new SelectOption('Stipend', 'Stipend'));
            pickListOptions.add(new SelectOption('Unpaid', 'Unpaid'));
                       
            return pickListOptions;
        }
    }
     //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> programOptions {
        get {
            
            //Variable to hold the picklist data
           List<SelectOption> pickListOptions = new List<SelectOption>();
            
            //Describe Program options
            Schema.DescribeFieldResult F = Position__c.Intrax_Program_Options__c.getDescribe();
            
            //add picklist values
            pickListOptions.add(new SelectOption('--None--', '--None--'));          
            pickListOptions.add(new SelectOption('Internship Group', 'Internship Group'));
            pickListOptions.add(new SelectOption('Internship - J1', 'Internship - J1'));
            pickListOptions.add(new SelectOption('Practical Training', 'Practical Training'));      
            pickListOptions.add(new SelectOption('WEST', 'WEST'));
            
            return pickListOptions;
              //Variable to hold the picklist data
         
        }
    }
    
      public List<SelectOption> AyusaProgramOptions {
        get {
            
            //Variable to hold the picklist data
           List<SelectOption> pickListOptions = new List<SelectOption>();
            
            //Describe Program options
            Schema.DescribeFieldResult F = Position__c.Intrax_Program_Options__c.getDescribe();
            
            //add picklist values
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('Ayusa High School', 'Ayusa High School'));
             pickListOptions.add(new SelectOption('YES', 'YES'));           
           pickListOptions.add(new SelectOption('Tomodachi', 'Tomodachi')); 
           //pickListOptions.add(new SelectOption('High School Worldwide', 'High School Worldwide'));  
            return pickListOptions;
              //Variable to hold the picklist data
         
        }
    }
    
    public list<SelectOption> language_final;
    public list<SelectOption> apc_languages {
        get{
            if(language_final == null || language_final.size() == 0 ){
                List<SelectOption> options = new List<SelectOption>();
                list<String> languages = new list<String>();
                
                list<Engagement__c> engagement_no_female = database.query(SOQLQuery_no_female);
                 
                for(Engagement__c e : engagement_no_female){
                    if(e.Primary_Language__c != null && e.Primary_Language__c != '') languages.add(e.Primary_Language__c);
                    if(e.Language_1__c != null && e.Language_1__c != '') languages.add(e.Language_1__c);
                    if(e.Language_2__c!= null && e.Language_2__c != '') languages.add(e.Language_2__c);
                    if(e.Language_3__c != null && e.Language_3__c != '') languages.add(e.Language_3__c);            
                }
                languages.sort();
                set<string> languages_set = new set<String>();
                languages_set.addAll(languages);
                if(languages_set.size () > 0) options.add(new SelectOption('--None--', '--None--'));             
                for(string s : languages_set){
                    if(s!=null) options.add(new SelectOption(s,s));
                }
                
                language_final = options;
                return options;         
            }else return language_final;
        }set;
    }
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstLangs {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Account.Languages_Spoken__pc.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
     //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstLangSpoken {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Account.Languages_Spoken__pc.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
     public List<SelectOption> lstSpecialDiet {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Account.Special_Diet__pc.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
    
    public List<SelectOption> apc_SpecialDiet {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Special_Diet__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
    
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstFuncAreas {
        get {
            
            //Variable to hold the picklist data
           
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
         
            Schema.DescribeFieldResult fieldResult = Engagement__c.Functional_Areas__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }            
            
            return pickListOptions;
        }
    }
    public List<SelectOption> lstDPIndicated {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Double_Placement_Indicated__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
    public List<SelectOption> lstIntCountries {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Countries_of_Interest__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstCitizenship {
        get {
           List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Account.Citizenship__pc.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            return pickListOptions;
            //Variable to hold the picklist data
          
        }
    }
    
    public List<SelectOption> experienceAgesOptions {
        get {
           List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Experience__c.Children_Ages__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            return pickListOptions;
            //Variable to hold the picklist data
          
        }
    }
    
    public List<SelectOption> experienceTypeOptions {
        get {
           List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Experience__c.Experience_Type__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            return pickListOptions;
            //Variable to hold the picklist data
          
        }
    }
    
    public List<SelectOption> drivingSnowOptions {
        get {
           List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Driving_Snow_Experience__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            return pickListOptions;
            //Variable to hold the picklist data
          
        }
    }
    
    public List<SelectOption> drivingFrequencyOptions {
        get {
           List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Engagement__c.Driving_Frequency__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            return pickListOptions;
            //Variable to hold the picklist data
          
        }
    }
        
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstEduGrade{
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
           
            //add picklist values
            pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('Freshman', 'Freshman'));
            pickListOptions.add(new SelectOption('Sophomore', 'Sophomore'));
            pickListOptions.add(new SelectOption('Junior', 'Junior'));
            pickListOptions.add(new SelectOption('Senior', 'Senior'));
            pickListOptions.add(new SelectOption('Post Graduate', 'Post Graduate'));
           
            
            return pickListOptions;
        }
    }
    
    public List<SelectOption> hobbiesOptions{
        get{
            list<SelectOption> options = new list<SelectOption>();
            /// CHANGE TO ENGAGEMENT!!!!
            options.add(new SelectOption('--None--', '--None--'));
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
    //Selected Program Options
    public List<String> selectGenderPrefs {get; set;}
    public String selectGenderPref {get; set;}
    
    public List<String> selectSmokerFamilies {get; set;}
    public String selectSmokerFamily {get; set;}
    
    public List<String> selectInterests {get; set;}
    public String selectInterest {get; set;}
    public String selectDPIndicated  {get; set;}
    public List<String> selectNationalPreferences {get; set;}
    
    
    public List<String> selectSchoolCategories {get; set;}
    public String selectSchoolCategory {get; set;}
    
    public List<String> selectTuitionRanges {get; set;}
    public String selectTuitionRange {get; set;}
    
     public List<String> selectProgramDurations {get; set;}
    public String selectProgramDuration {get; set;}
    
    public List<String> selectPets {get; set;}
    public String selectPet {get; set;}
    
    public List<String> selectSNKs {get; set;}
    public String selectSNK {get; set;}
    
    public List<String> selectReligions {get; set;}
    public String selectReligion {get; set;}
    
    public List<String> selectProgramOptions {get; set;}
    public String selectProgramOption {get; set;}
    
    public List<String> selectAyusaProgramOptions {get; set;}
    public String selectAyusaProgramOption {get; set;}
     //Selected Citizenship
    public List<String> selectPositionTypes {get; set;}
    public String selectPositionType {get; set;}
    
    //Selected Citizenship
    public List<String> selectCitizenships {get; set;}
    public String selectCitizenship {get; set;}
    
    public List<String> selectLangs {get; set;}
    public String selectLang {get; set;}
    
    public List<String> selectIntCountries {get; set;}
    
    public List<String> selectAreas {get; set;}
    public String selectArea{get; set;}
    
    public List<string> selectAgeRanges {get; set;}
    public String selectAgeRange {get; set;}
    
    public List<string> selectAges {get; set;}
    
    public List<String> selectIntCounts {get; set;}
    public String selectIntCount {get; set;}
    
     //Selected Grade
    public List<String> selectEduGrades {get; set;}
    public String selectEduGrade {get; set;}

    public String selectPartner {get; set;}
    public String selectSpecialDiet {get; set;}
    public list<String> specialDietSelected{get;set;}
    
    //Selected English Level
    //public List<String> selectEnglishLevels {get; set;}
    //public String selectEnglishLevel {get; set;}
    
     //Selected Language Level
    public List<String> selectlangLevels {get; set;}
    public String selectlangLevel {get; set;}
    
    public List<String> selectserviceLevels {get; set;}
    public String selectserviceLevel {get; set;}
    
    public String interest{get;set;}
    public String schoolName{get;set;}
    public String selectEngName{get;set;}
    public String major{get;set;}
    public List<String> selectPrepRatings {get; set;}
    public String selectPrepRating{get;set;}
    
    public List<String> selectEnergyLevelRatings {get; set;}
    public String selectEnergyLevelRating{get;set;}
    public List<String> selectExpressivenessRatings {get; set;}
    public String selectExpressivenessRating{get;set;}
    public List<String> selectFunninessRatings {get; set;}
    public String selectFunninessRating{get;set;}
    public List<String> selectIndependenceRatings {get; set;}
    public String selectIndependenceRating{get;set;}
    public List<String> selectMaturityRatings {get; set;}
    public String selectMaturityRating{get;set;}
    public List<String> selectOpinionatednessRatings {get; set;}
    public String selectOpinionatednessRating{get;set;}
    public List<String> selectStructureRatings {get; set;}
     public List<String> selectLanguagesSpoken {get; set;}
    public String selectStructureRating{get;set;}
    
    public List<String> selectStartDurations {get; set;}
    public String selectStartDuration{get;set;}
    public List<String> selectEndDurations {get; set;}
    public String selectEndDuration{get;set;}
    public List<String> selectPersRatings {get; set;}
    public String selectPersRating{get;set;}
    public List<String> selectExpRatings {get; set;}
    public String selectExpRating{get;set;}
    public List<String> selectCompTypes {get; set;}
    public String selectCompType{get;set;}
    public Position__c getDummyObj() { return DummyObj; }
    public set<id> engPartid;
    
    public list<string> SelectNationality{get;set;}
    
    //Standard Constructor
    public RankingController(ApexPages.StandardController controller) {
        
        try {
            //Get program record Id
            position = (Position__c)controller.getRecord();
            match = new Match__c(Position_Name__c = position.Id);
            system.debug('****here I am*****');
            
            selectProgramOptions = new List<String>();
            selectIntCountries = new list<string>();
            selectCitizenships = new List<String>();
            selectlangLevels = new List<String>();
            selectserviceLevels = new List<String>();
            selectLangs = new List<String>();
            selectCompTypes = new List<String>();
            selectPositionTypes = new List<String>();
            selectAreas = new List<String>();
            selectAyusaProgramOptions=new List<string>();
            selectNationalPreferences=new List<string>();
            selectInterests=new List<string>();
            selectLanguagesSpoken=new List<string>();
         // selectAgeRanges = new List<String>();
            if(ArrivalSelected != null && ArrivalSelected != ''){
                DummyObj.Engagement_Start__c = date.parse(ArrivalSelected);
            }else{
                DummyObj.Engagement_Start__c = null;
            }      
                
            PositionEngagementStart=DummyObj.Engagement_Start__c;
            //selectCountriesInt = new List<String>();
            PositionEngagementEnd=DummyObj.Engagement_End__c;
            
            totalResults = 0;
            if(System.currentPageReference().getParameters().get('prog')=='Internship' || System.currentPageReference().getParameters().get('prog')=='Work Travel')
                initIntern();
            else if (System.currentPageReference().getParameters().get('prog')=='Ayusa')
                initAyusa();
            else if(System.currentPageReference().getParameters().get('prog')=='AuPairCare')
                initAPC();
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
    }
    
    public string swimmersSelected {get;set;}
    public string drivingLicenseIndicated{get;set;}
    public list<String> hobbiesSelected{get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string ptname{get;set;}
    public string specialNeedsIndicated{get;set;}
    public string inCountrySelected{get;set;}
    public string infantSpecializedSelected{get;set;}
    public list<String> experienceAgesSelected{get;set;}
    public list<String> experienceTypeSelected{get;set;}
    public list<String> childrenAgesSelected{get;set;}
    public string confSpecialNeedsSelected{get;set;}
    public string religionIndicated{get;set;}
    public string religiousActivityIndicated{get;set;}
    public string drivingSnowIndicated{get;set;}
    public string drivingFrequencyIndicated{get;set;}
    public string nativeIndicated{get;set;}
    public decimal childrenU2{get;set;}
    public decimal childrenTotal{get;set;}
    public boolean hasSpecialneeds{get;set;}
    public list<Match__c> previousMatches{get;set;}
    public map<String, integer> interviews_by_pt{get;set;}
    public string drivingAbilityFilterIndicated{get;set;}
    
    public string SOQLQuery_no_female;
    
    public boolean getPositionNotClosed(){        
        if(position != null && position.Status__c=='Closed - Filled'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'This Position is Closed-Filled and is not available for matching.'));   
            return false;
        }
        else 
            return true;        
    }
    
    public void initAPC() {
        
            //check if position is not null
            if(position != null) {           
                //fetch the position record detail from data base
                position = [Select Name,Matched_Count__c, Service_Level__c,Intrax_Program__c, Functional_Areas__c,Intrax_Program_Options__c, Id, Host_Opportunity_Id__c, 
                            Host_Company_Id__c, Host_Company_ID__r.Citizenship__pc, Engagement_Start__c, Engagement_End__c, Compensation_Type__c, Host_Company_Id__r.Gender__pc,
                            State__c, Status__c, Country__c, Regional_Location__c, Countries_of_Interest__c, Position_Types__c, Flexible_Dates__c, Pets__c, Pet_Types__c, Language_Preferences__c,
                            (Select Id, Participant_Opportunity_Id__c, Participant_Id__c,Engagement__c, Engagement__r.Name, Status__c from Matches__r)  
                            From Position__c 
                            where Id =: position.Id];
                
                if(position.Status__c=='Closed - Filled'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'This Position is Closed-Filled and is not available for matching.'));                    
                }
                
                existingMatches = new set<String>();
                previousMatches = new list<Match__c>();
                list<Id> matchesIds = new list<Id>();
                if(position.Matches__r != null && position.Matches__r.size() > 0) {
                    for(Match__c match : position.Matches__r)
                        if(match.Status__c == 'Confirmed'){
                            matchesIds.add(match.Id);
                        }
                    previousMatches = [SELECT Id, Engagement__c, Engagement__r.Name FROM Match__c WHERE Id IN: matchesIds];
                }
                
                system.debug('+++++ existing Matches: ' + previousMatches);
        
                String SOQLQuery;
                boolean blnActive=false;
                if(ArrivalSelected != null && ArrivalSelected != ''){
                    DummyObj.Engagement_Start__c = date.parse(ArrivalSelected);
                }else{
                    DummyObj.Engagement_Start__c = null;
                }             
                PositionEngagementStart=DummyObj.Engagement_Start__c;
                PositionEngagementEnd=DummyObj.Engagement_End__c;
               
             
            SOQLQuery = 'Select e.Position_Types__c, e.Earliest_Match_Date__c, e.Engagement_Country__c, e.Personality_Independence__c ,e.Live_With_Smoker__c,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c,e.Tuition__c , e.Name,e.Service_Level__c, e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c, e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc, e.Infant_Specialized_Circulated__c, e.Under_2_Circulated__c, Religion__c, Religious_Activity_Home__c,' +
                        + 'e.Account_Id__r.English_Level__pc,e.Account_Id__r.age__pc, e.Account_Id__r.Citizenship__pc, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type, Special_Needs_Circulated__c,Under_2_Total_Hours__c, Drivers_Licence_Acquired__c, Driving_Frequency__c, '+
                        + 'e.Account_Id__r.Name,e.Placement_status__c, e.Account_Id__r.Id, e.Account_Id__c, e.Account_Id__r.isPersonAccount, Nationality__c, Gender__c, Drivers_Licence_Indicated__c, Age_At_Program_Start__c, Childcare_Total_Hours__c, In_Country__c, Infant_Specialized_Indicated__c, Children_Special_Needs_Care__c, Children_Comfortable_Ages__c, ' + 
                        + 'e.Match_Notes__c, Primary_Language__c, Language_1__c, Language_2__c, Language_3__c ' +
                        + 'From Engagement__c e where ' +
                        + 'e.Intrax_Program__c  INCLUDES (' + '\'' + position.Intrax_Program__c  + '\'' + ') ' +  
                        + ' AND e.Type__c = \'Participant\' ' +
                        + ' AND Placement_Status__c = \'Not Placed\'' +
                        + ' AND ((Status__c = \'Processing\') ' +
                        + ' OR (Status__c = \'On Program\' AND Circulation_Start_Date__c <= : d_today AND Circulation_End_Date__c >= : d_today)) '+
                        + ' AND ((In_Country__c = \'Yes\' AND Latest_Match_Date__c >= :d_today) OR (In_Country__c = \'No\') OR (In_Country__c = null)) ' +
                        + ' AND RecordTypeId = \'' + Constants.ENG_AUPAIRCARE_PT + '\' ' +
                        + ' AND ID IN (SELECT Engagement__c FROM Applicant_Info__c WHERE  Application_Level__c = \'Main\' AND (Application_Stage__c = \'Accepted\' OR Application_Stage__c = \'Submitted\' OR Application_Stage__c = \'In-Review\')) ' +
                        + ' AND Id NOT IN (Select s.Engagement__c From Selection__c s Where s.Intrax_Program__c = \'AuPairCare\' And s.Position__c = \'' + position.Id   +'\' And s.Recommendation_Type__c != null) ' +                    
                        + getEarlyEndedCriteria();
                        
            system.debug('******** SOQLQuery-1:'+SOQLQuery);
           
            //**** DEFAULT FILTERS (Depends on Position Info)
            
            list<Match__c> activeMatches = [SELECT Engagement__c, Position_Name__c FROM Match__c WHERE Offer_Status__c IN ('Offered') and Intrax_Program__c = 'AuPairCare'];
            
            if(activeMatches.size() > 0){
                string idm = '(\'';                 
                for (Match__c m : activeMatches) {
                    if(m.Engagement__c != null) idm += m.Engagement__c + '\',\'';
                }
                idm = idm.substring(0,idm.length()-2); 
                idm += ')';
                
                SOQLQuery = SOQLQuery + ' AND ID NOT IN ' + idm ;
            }
            
            // getting Members Info
            boolean hasChildrenUnder2 = false;      
            boolean sameSexCouple = false;  
            hasSpecialNeeds = false;
            boolean singleParent = true;
            childrenU2 = 0;
            childrenTotal = 0;
            
            //if(true){//position.Host_Company_Id__c != null && position.Host_Company_Id__c != ''){
            list<Member__c> familyMembers = [SELECT Id, Age__c, Special_Needs_Indicated__c, Account_Name__c, Role__c, gender__c
                                                FROM Member__c
                                                WHERE Account_Name__c =: position.Host_Company_Id__c
                                                ];
                                                
            if(familyMembers.size() > 0){
                for(Member__c m : familyMembers){                   
                    if(m.Role__c == 'Spouse or Partner'){
                        singleParent = false;
                        if(position.Host_Company_Id__r.Gender__pc == m.Gender__c) sameSexCouple = true; 
                    }else if(m.Role__c == 'Child'){ 
                        childrenTotal++;
                        if(m.Age__c < 2){
                            hasChildrenUnder2 = true;
                            childrenU2++;
                        }
                        if(m.Special_Needs_Indicated__c == 'Yes'){
                            hasSpecialNeeds = true;
                        }
                    }                                           
                }
            }               
            
            if(position.Pets__c == 'Yes' && position.Pet_Types__c != null){
                list<String> pets = position.Pet_Types__c.split(';');               
                String s_pets = '(';
                for(String s: pets){
                    s_pets += '\'' + s + '\',';
                }
                s_pets = s_pets.substring(0,s_pets.length() -1);
                s_pets += ')';
                SOQLQuery += ' AND (e.Pets_Allergy_Indicated__c = \'No\' OR (e.Pets_Allergy_Indicated__c = \'Yes\' AND (e.Pet_Allergy_Types__c NOT IN ' + s_pets + ')))';
            }
            
            if(singleParent == true){
                if(position.Host_Company_Id__r.Gender__pc == 'Male') SOQLQuery += 'AND Single_Father_Indicated__c = \'Yes\'';
                else if(position.Host_Company_Id__r.Gender__pc == 'Female') SOQLQuery += 'AND Single_Mother_Indicated__c = \'Yes\'';
            }
            
            if(sameSexCouple){
                SOQLQuery += ' AND e.Same_Sex_Couple_Indicated__c = \'Yes\'';
            }
            
            if(hasChildrenUnder2){
                SOQLQuery += ' AND Under_2_Circulated__c = true';
            }else{              
                SOQLQuery += ' AND (Under_2_Circulated__c = false AND Infant_Specialized_Circulated__c = false)'; 
                //SOQLQuery += ' AND Infant_Specialized_Circulated__c = false';             
            }
            //SOQLquery += ' AND SpecialNeedsCirculated = \'' + specialNeedsIndicated + '\''; 
            
            if(specialNeedsIndicated != null && specialNeedsIndicated!= '' && specialNeedsIndicated != '--None--'){
                SOQLquery += ' AND Special_Needs_Circulated__c = \'' + specialNeedsIndicated + '\''; 
            }else{
                if(hasSpecialNeeds){ 
                    SOQLquery += ' AND (Special_Needs_Circulated__c = \'Circulate SN\' OR Special_Needs_Circulated__c = \'Circulate Both\')';
                }else{
                    SOQLquery += ' AND (Special_Needs_Circulated__c = \'Circulate Standard\' OR Special_Needs_Circulated__c = \'Circulate Both\')';
                }
            }
            
            //***** END DEFAULT FILTERS
            
            if(experienceAgesSelected != null && experienceAgesSelected.size() > 0){
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = experienceAgesSelected.size();
                for(String s : experienceAgesSelected) {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
                if(!blnNoneExists){
                    for (String s: experienceAgesSelected){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring(0,slist.length() -1);
                    String q = 'SELECT Engagement__c FROM Experience__c WHERE Children_Ages__c Engagement__c != NULL AND INCLUDES (' + slist + ')';

                    list<Experience__c> listExp = Database.query(q); 
                
                    String idString = '';
                                
                    if(listExp.size() > 0){
                        idString = '(\'';                   
                        for (Experience__c exp : listExp) {
                            if(exp.Engagement__c != null)idString += exp.Engagement__c + '\',\'';
                        }
                        idString = idString.substring(0,idString.length()-2); 
                        idString += ')';
                    }else{
                        idString = '(\'\')';
                    }
                    
                    SOQLQuery = SOQLQuery + ' AND ID IN ' + idString ;      
                }
            }
            
            if(experienceTypeSelected != null && experienceTypeSelected.size() > 0){
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = experienceTypeSelected.size();
                for(String s : experienceTypeSelected) {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
                if(!blnNoneExists){
                    for (String s: experienceTypeSelected){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring(0,slist.length() -1);
                    String q = 'SELECT Engagement__c FROM Experience__c WHERE Experience_Type__c IN (' + slist + ')';

                    list<Experience__c> listExp = Database.query(q); 
                
                    String idString = '';
                                
                    if(listExp.size() > 0){
                        idString = '(\'';                   
                        for (Experience__c exp : listExp) {
                            if(exp.Engagement__c != null) idString += exp.Engagement__c + '\',\'';
                        }
                        idString = idString.substring(0,idString.length()-2); 
                        idString += ')';
                    }else{
                        idString = '(\'\')';
                    }
                    
                    SOQLQuery = SOQLQuery + ' AND ID IN ' + idString ;                              
                }
            }
            
            if(inCountrySelected != null && inCountrySelected == 'true'){               
                SOQLQuery += ' AND e.In_Country__c = \'Yes\'';
            }
            
            if(infantSpecializedSelected != null && infantSpecializedSelected == 'true'){               
                SOQLQuery += ' AND e.Infant_Specialized_Circulated__c = true';
            }
            
            if(confSpecialNeedsSelected != null && confSpecialNeedsSelected == 'true'){                 
                SOQLQuery += ' AND e.Children_Special_Needs_Care__c = \'Yes\'';
            }
            
            if(religionIndicated != null && religionIndicated != ''){               
                SOQLQuery += ' AND e.Religion__c = \'' + religionIndicated + '\'';
            }
            
            if(religiousActivityIndicated != null && religiousActivityIndicated != ''){                 
                SOQLQuery += ' AND e.Religious_Activity_Home__c = \'' + religiousActivityIndicated + '\'';
            }
            
            system.debug('***** ptName: ' + ptName);
            if(ptname != null && ptname!= ''){
                list<String> ptNameList = ptName.split(' ', 0);
                SOQLQuery += 'AND ( ';
                for(integer i = 0; i< ptNameList.size(); i++){
                    SOQLQuery = SOQLQuery + ' e.Account_Id__r.FirstName like \'%' + ptNameList[i] + '%\' OR e.Account_Id__r.LastName like \'%' + ptNameList[i] + '%\' ';
                    if(i < ptNameList.size() - 1) SOQLQuery += ' OR ';
                }
                SOQLQuery += ') ';
            }
            /*
            if(lastname != null && lastName!= ''){
                SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.LastName like \'%' + lastName + '%\'';
            }
            */
            /*          
            if(hasSpecialNeeds || (specialNeedsIndicated != null && specialNeedsIndicated!= '' && specialNeedsIndicated != '--None--')){                
                SOQLQuery = SOQLQuery + ' AND e.Special_Needs_Circulated__c = \'' + specialNeedsIndicated + '\'';
            }*/
            
            
            if(childrenAgesSelected != null && childrenAgesSelected.size() > 0){
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = childrenAgesSelected.size();
                for(String s : childrenAgesSelected) {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
                if(!blnNoneExists){
                    for (String s: childrenAgesSelected){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring (0,slist.length() -1);
            
                    SOQLQuery = SOQLQuery + ' AND e.Children_Comfortable_Ages__c INCLUDES (' + slist + ') ' ;
                }         
            }
                        
            if(hobbiesSelected != null && hobbiesSelected.size() > 0){
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = hobbiesSelected.size();
                for(String s : hobbiesSelected) {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
                if(!blnNoneExists){
                    for (String s: hobbiesSelected){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring (0,slist.length() -1);
            
                    SOQLQuery = SOQLQuery + ' AND (e.Interest_Sports__c IN (' + slist + ') OR e.Interests_Hobbies__c IN (' + slist + ') OR e.Interest_Fine_Arts__c IN (' + slist + ') )';
                    
                } 
            }
            
            if(PositionEngagementStart != null && PositionEngagementEnd==null) {
                SOQLQuery = SOQLQuery + ' AND e.Earliest_Match_Date__c <=: PositionEngagementStart';
                system.debug('SOQLQuery-PositionEngagementStart::::::::::'+PositionEngagementStart);
                system.debug('SOQLQuery-PositionEngagementStart::::::::::'+SOQLQuery);
            }
            
            if(specialDietSelected != null && specialDietSelected.size() > 0){
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = specialDietSelected.size();
                for(String s : specialDietSelected) {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
                if(!blnNoneExists){
                    for (String s: specialDietSelected){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring (0,slist.length() -1);
            
                    SOQLQuery = SOQLQuery + ' AND e.Special_Diet__c IN (' + slist + ') ' ;
                } 
            }
            
            if(nativeIndicated != null && nativeIndicated != ''){
                if(nativeIndicated == 'true'){
                    SOQLQuery = SOQLQuery + ' AND e.Language_1__c = \'English\'';
                }
            }
            
            if(selectGenderPref == null || selectGenderPref == ''){
                SOQLQuery = SOQLQuery + ' AND e.Gender__c = \'Female\'';
            }else{
                SOQLQuery = SOQLQuery + ' AND e.Gender__c = \'' + selectGenderPref + '\'';
            }
            
            if(swimmersSelected != null){
                system.debug('**** Swimmers Selected: ' + swimmersSelected);
                if(swimmersSelected == 'true')
                    SOQLQuery = SOQLQuery + ' AND e.Swimming_Indicated__c = \'Yes\'';                               
            }
            
            if(drivingFrequencyIndicated != null && drivingFrequencyIndicated != '' ){ 
                SOQLQuery = SOQLQuery + ' AND e.Driving_Frequency__c = \'' + drivingFrequencyIndicated + '\'';                              
            }
            
            if(drivingSnowIndicated != null && drivingSnowIndicated != '' ){                
                SOQLQuery = SOQLQuery + ' AND e.Driving_Snow_Experience__c = \'' + drivingSnowIndicated + '\'';                             
            }
            
            if((selectNationality != null && selectNationality.size() > 0)){
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectNationality.size();
                for(String s : selectNationality) {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
                if(!blnNoneExists){
                    for (String s: selectNationality){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring (0,slist.length() -1);
            
                    SOQLQuery = SOQLQuery + ' AND e.Nationality__c IN (' + slist + ') ' ;
                }         
            }
            
            
            if((selectLangs != null && selectLangs.size()>0) && (selectlangLevel==null || selectlangLevel=='' || selectlangLevel=='--None--')){
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectLangs.size();
                for(String s : selectLangs) {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
                system.debug('selectLangs::::::::::'+selectLangs);
                system.debug('blnNoneExists::::::::::'+blnNoneExists);
            
                if(!blnNoneExists){
                    for (String s: selectlangs){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring (0,slist.length() -1);
            
                    SOQLQuery = SOQLQuery + ' AND ( e.Primary_Language__c IN (' + slist + ') or e.Language_1__c IN (' + slist + ') or e.Language_2__c IN (' + slist + ') or e.Language_3__c IN (' + slist + ')) ' ;
                    System.debug('SOQLQuery-selectLangs::::::::::'+SOQLQuery);
                }         
            }
            
            if(selectAgeRange != null && selectAgeRange != '--None--'){
                   SOQLQuery = SOQLQuery + ' AND e.Age_at_Program_Start__c >= ' + selectAgeRange;                   
                
            }
            /*  
                if(PositionEngagementStart != null || PositionEngagementEnd!=null || (PositionEngagementStart != null && PositionEngagementEnd!=null) ) {
                    if(PositionEngagementStart != null && PositionEngagementEnd==null) {
                        SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=: PositionEngagementStart';
                        system.debug('SOQLQuery-PositionEngagementStart::::::::::'+SOQLQuery);
                    }else if (PositionEngagementStart == null && PositionEngagementEnd!=null){
                        date todaydate = System.today();
                        SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=:todaydate and e.Engagement_End__c <=: PositionEngagementEnd ';
                  
                        system.debug('SOQLQuery-PositionEngagementEnd::::::::::'+SOQLQuery);
                    }else if (PositionEngagementStart!= null && PositionEngagementEnd!=null && PositionEngagementStart<=PositionEngagementEnd){
                        SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=: PositionEngagementStart and e.Engagement_End__c <=: PositionEngagementEnd ';
                        system.debug('SOQLQuery-PositionEngagementStart PositionEngagementEnd::::::::::'+SOQLQuery);
                    }
                  
                    system.debug('PositionEngagementStart::::::::::'+PositionEngagementStart); 
                    system.debug('PositionEngagementEnd::::::::::'+PositionEngagementEnd); 
                    
                    
                }
             */   
                
            if(drivingAbilityFilterIndicated != null && drivingAbilityFilterIndicated != '' ){ 
                    String q = 'Select Engagement__c from Assessment__c where PT_Driving_Ability__c = \'' + drivingAbilityFilterIndicated + '\'';
    
                    list<Assessment__c> listAss = Database.query(q); 
                    
                    String idString = '';
                                    
                    if(listAss.size() > 0){
                        idString = '(\'';                   
                        for (Assessment__c assess : listAss) {
                            if(assess.Engagement__c != null)idString += assess.Engagement__c + '\',\'';                         
                        }
                        idString = idString.substring(0,idString.length()-2); 
                        idString += ')';
                    }else{
                        idString = '(\'\')';
                    }
                    
                    SOQLQuery = SOQLQuery + ' AND ID IN ' + idString ;                              
                }
                            
            System.debug('SOQLQuery-Final::::::::::'+SOQLQuery);        
            engagements = Database.query(SOQLQuery);
            
            SOQLQuery_no_female = SOQLQuery.remove('AND e.Gender__c = \'Female\'');
            
            orginalEngagements = engagements;
            
            interviews_by_pt = new map<String, Integer>();
            
            list<Selection__c> selections = [SELECT Id, Engagement__c, Position__c, Status__c
                                                FROM Selection__c 
                                                WHERE Engagement__c IN: engagements
                                                AND Status__c = 'Active'];
            
            for(Engagement__c e : engagements){
                interviews_by_pt.put(e.Id, 0);
            }
            
            integer counter = 0;
            for(Selection__c sel : selections){
                counter = interviews_by_pt.get(sel.Engagement__c) + 1;
                interviews_by_pt.put(sel.Engagement__c, counter);
            }
                
            //Check for the opportunities size
            if(engagements != null && engagements.size() > 0) {
            
                //Query object
                List<wwwIntraxincComMatchRanking.query> queries = new List<wwwIntraxincComMatchRanking.query>();
                wwwIntraxincComMatchRanking.query query = new wwwIntraxincComMatchRanking.query();
                query.queryString = 'sort by functional areas';
                queries.add(query);
                
                //Call Ranking webservice
                wwwIntraxincComMatchRanking.RankingServicePort rankingServicePort = new wwwIntraxincComMatchRanking.RankingServicePort();
                System.debug(rankingServicePort);
                
                wwwIntraxincComMatchRanking.resultSet resultSet = rankingServicePort.matchRanking('internship', RankingMatchUtility.prepareEntityProps(position), 
                                                    RankingMatchUtility.prepareCandidateList(engagements), queries);
                system.debug('*******resultSet*********'+resultSet);
                //Parse response
                mapOfListEngagementWrapper = RankingMatchUtility.parseResponseForEng(resultSet);
                system.debug('*******map - resultSet*********'+mapOfListEngagementWrapper);
                //Set default sorting parameter
                
                sortDir = 'DESC';
            } else {
                mapOfListEngagementWrapper = new Map<Integer, List<EngagementWrapper>>();
                system.debug('*******else - map - resultSet*********'+mapOfListEngagementWrapper);
            }
            
            //Sort Result by default
            sortByRanking(mapOfListEngagementWrapper);
        }
    }
    
    public void initIntern() {
        try {
            //check if position is not null
            if(position != null) {
           
                //fetch the position record detail from data base
                position = [Select Name,Matched_Count__c, Service_Level__c,Intrax_Program__c, Functional_Areas__c,Intrax_Program_Options__c, Id, Host_Opportunity_Id__c, 
                            Host_Company_ID__c, Host_Company_ID__r.Citizenship__pc, Engagement_Start__c, Engagement_End__c, Compensation_Type__c, 
                            State__c, Country__c, Regional_Location__c, Countries_of_Interest__c, Position_Types__c, Flexible_Dates__c,
                            (Select Id, Participant_Opportunity_Id__c, Participant_Id__c,Engagement__c from Matches__r)  From Position__c where Id =: position.Id];
             system.debug('******position********'+position);   
              
                //initialize set
                existingMatches = new Set<String>();
                if(position.Matches__r != null && position.Matches__r.size() > 0) {
                    for(Match__c match : position.Matches__r)
                        existingMatches.add(match.engagement__c + '-' + match.Participant_Id__c);
                }
               
                
                //Build SOQl Query
                String SOQLQuery;
                boolean blnActive=false;
                PositionEngagementStart=DummyObj.Engagement_Start__c;
                PositionEngagementEnd=DummyObj.Engagement_End__c;
               
             
     
          if (selectPartner!=null && selectPartner!='')
         {
                engPartid = new set<id>();
                selectPartner=String.escapeSingleQuotes(selectPartner);
                selectPartner ='%'+ selectPartner + '%'; 
                list<account> acc= [Select id,name From Account a where a.name like :selectPartner];
            set<id> accid = new set<id>();
            if(acc!=null && acc.size()>0)
            {
            for(account tempacc : acc)
            {            
            accid.add(tempacc.id);
            }
            }
             System.debug('acc::::::::::'+acc);
              System.debug('accid::::::::::'+accid);
          
             SOQLQuery = 'Select e.Position_Types__c,e.Engagement_Country__c, e.Personality_Independence__c ,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c, e.Name, e.Service_Level__c,e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c, e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc,' +
                        + ' e.Account_Id__r.English_Level__pc,e.Tuition__c , e.Account_Id__r.Citizenship__pc,e.Live_With_Smoker__c, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type,'+
                        + 'e.Account_Id__r.Name,e.Account_Id__r.age__pc, e.Account_Id__r.isPersonAccount, e.Placement_status__c, e.Account_Id__r.Id, e.Account_Id__c From Engagement__c e where ' +
                        + 'e.Intrax_Program__c  INCLUDES (' + '\'' + position.Intrax_Program__c  + '\'' + ')' +
                        + 'AND e.Type__c = \'Participant\'  AND (e.Status__c = \'Processing\' or e.Status__c =\'Program Ready\' or e.Status__c =\'On Program\') and (e.Placement_Status__c = \'Not Placed\' or e.Placement_Status__c =\'Pending\' ) AND e.Account_Id__r.Type = \'Participant\' '+ 
                        + 'AND (e.Account_Id__r.Status__c = \'Prospect\' OR e.Account_Id__r.Status__c = \'Active\' OR e.Account_Id__r.Status__c = \'Contracted\') and e.Partner_Account__c in :accid ';
              
             
         } 
             
        
        else
         {
          SOQLQuery = 'Select e.Position_Types__c, e.Engagement_Country__c,e.Personality_Independence__c ,e.Live_With_Smoker__c,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c,e.Tuition__c , e.Name,e.Service_Level__c, e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c, e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc,' +
                        + ' e.Account_Id__r.English_Level__pc,e.Account_Id__r.age__pc, e.Account_Id__r.Citizenship__pc, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type,'+
                        + 'e.Account_Id__r.Name,e.Placement_status__c, e.Account_Id__r.Id, e.Account_Id__c, e.Account_Id__r.isPersonAccount From Engagement__c e where ' +
                        + 'e.Intrax_Program__c  INCLUDES (' + '\'' + position.Intrax_Program__c  + '\'' + ')' 
                        + 'AND e.Type__c = \'Participant\'  AND (e.Status__c = \'Processing\' or e.Status__c =\'Program Ready\' or e.Status__c =\'On Program\') and (e.Placement_Status__c = \'Not Placed\' or e.Placement_Status__c =\'Pending\' )  AND e.Account_Id__r.Type = \'Participant\' '+ 
                        + 'AND (e.Account_Id__r.Status__c = \'Prospect\' OR e.Account_Id__r.Status__c = \'Active\' OR e.Account_Id__r.Status__c = \'Contracted\') '; 
                        
         }        
                System.debug('SOQLQuery-1::::::::::'+SOQLQuery);
                
                if(selectProgramOption != null && selectProgramOption != '' && selectProgramOption!='--None--') 
                {
                if(selectProgramOption=='Hospitality Internship' && selectAreas!=null )
                  selectAreas.clear();
                if(selectProgramOption!='Hospitality Internship' && selectPositionTypes!=null)
                  selectPositionTypes.clear();
                SOQLQuery = SOQLQuery + ' AND e.Intrax_Program_Options__c INCLUDES (\'' + selectProgramOption +'\') ';
                System.debug('SOQLQuery-selectProgramOption::::::::::'+SOQLQuery);
                }
                 if(selectProgramCategory != null && selectProgramCategory != '' && selectProgramCategory!='--None--') 
                {
                if(selectProgramCategory=='Hospitality & Tourism' && selectAreas!=null )
                  selectAreas.clear();
                if(selectProgramCategory!='Hospitality & Tourism' && selectPositionTypes!=null)
                  selectPositionTypes.clear();
                SOQLQuery = SOQLQuery + ' AND e.Intrax_Program_Category__c in (\'' + selectProgramCategory +'\')  ';
                System.debug('SOQLQuery-selectProgramCategory::::::::::'+SOQLQuery);
                }             
               
                if(selectCitizenships != null && selectCitizenships.size()>0)
                {
                Integer DelNone;
                System.debug('selectCitizenships::::::::::'+selectCitizenships);
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectCitizenships.size();
                for(String s : selectCitizenships) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
           System.debug('selectCitizenships::::::::::'+selectCitizenships);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
                SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.Citizenship__pc  IN :selectCitizenships ';
                System.debug('SOQLQuery-selectCitizenships::::::::::'+SOQLQuery);
           }         
                }
                 if(selectIntCountries != null && selectIntCountries.size()>0)
                {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectIntCountries.size();
                for(String s : selectIntCountries) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                 
           }
        
         
           System.debug('selectIntCountries::::::::::'+selectIntCountries);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
             for (String s: selectIntCountries) 
             {
          slist += '\'' + s + '\',';
            System.debug('SOQLQuery-slist::::::::::'+slist);
          }
          slist = slist.substring (0,slist.length() -1);
          //System.debug('SOQLQuery-slist-out::::::::::'+slist);
               SOQLQuery = SOQLQuery + ' AND e.countries_of_Interest__c  INCLUDES (' + slist + ') ' ;
              
               
                System.debug('SOQLQuery-selectIntCountries::::::::::'+SOQLQuery);
           }         
                }
                
                
                
         if((selectLangs != null && selectLangs.size()>0) && (selectlangLevel!=null && selectlangLevel!='' && selectlangLevel!='--None--') )
         {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectLangs.size();
                for(String s : selectLangs) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                 
                }
         
           System.debug('selectLangs::::::::::'+selectLangs);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
             for (String s: selectlangs) 
             {
                 slist += '\'' + s + '\',';
             }
                slist = slist.substring (0,slist.length() -1);
         System.debug('selectlangLevel::::::::::'+selectlangLevel);
            If(selectlangLevel!=null && selectlangLevel!='' && selectlangLevel!='--None--')
            {               
                  selectlangLevels =new List<String>();
                  if(selectlangLevel=='Beginner')
                  {
                  selectlangLevels.add('Beginner');
                  selectlangLevels.add('Limited');
                  selectlangLevels.add('Intermediate');
                  selectlangLevels.add('Advanced');
                  selectlangLevels.add('Native/Fluent');
                  }
                  else if(selectlangLevel=='Limited')
                  {
                  selectlangLevels.add('Limited');
                  selectlangLevels.add('Intermediate');
                  selectlangLevels.add('Advanced');
                  selectlangLevels.add('Native/Fluent');
                  }
                  else if(selectlangLevel=='Intermediate')
                  {
                  selectlangLevels.add('Intermediate');
                  selectlangLevels.add('Advanced');
                  selectlangLevels.add('Native/Fluent');
                  }
                  else if(selectlangLevel=='Advanced')
                  {
                  selectlangLevels.add('Advanced');
                  selectlangLevels.add('Native/Fluent');
                  }
                  else if(selectlangLevel=='Native/Fluent')
                  {
                  selectlangLevels.add('Native/Fluent');
                  }
            }
            
             System.debug('selectlangLevels::::::::::'+selectlangLevels);
                
                SOQLQuery = SOQLQuery + ' AND ( e.Primary_Language__c IN (' + slist + ') or (e.Language_1__c IN (' + slist + ') and e.Language_1_Proficiency__c IN :selectlangLevels) or (e.Language_2__c IN (' + slist + ') and e.Language_2_Proficiency__c IN :selectlangLevels) or (e.Language_3__c IN (' + slist + ') and e.Language_3_Proficiency__c IN :selectlangLevels)) ' ;
                System.debug('SOQLQuery-selectLangs::::::::::'+SOQLQuery);
           }         
         }
         if((selectLangs != null && selectLangs.size()>0) && (selectlangLevel==null || selectlangLevel=='' || selectlangLevel=='--None--') )
         {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectLangs.size();
                for(String s : selectLangs) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                 
                }
         
           System.debug('selectLangs::::::::::'+selectLangs);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
             for (String s: selectlangs) 
             {
                 slist += '\'' + s + '\',';
             }
                slist = slist.substring (0,slist.length() -1);
            
                SOQLQuery = SOQLQuery + ' AND ( e.Primary_Language__c IN (' + slist + ') or e.Language_1__c IN (' + slist + ') or e.Language_2__c IN (' + slist + ') or e.Language_3__c IN (' + slist + ')) ' ;
                System.debug('SOQLQuery-selectLangs::::::::::'+SOQLQuery);
           }         
         }
        
          if(selectAreas != null && selectAreas.size()>0 && (selectProgramCategory != 'Hospitality & Tourism' || selectProgramOption!='Hospitality Internship'))
           {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectAreas.size();
                for(String s : selectAreas) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;                 
                }
         
           System.debug('selectAreas::::::::::'+selectAreas);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
             for (String s: selectAreas) 
             {
              slist += '\'' + s + '\',';
              }
                slist = slist.substring (0,slist.length() -1);
                SOQLQuery = SOQLQuery + ' AND e.Functional_Areas__c  INCLUDES (' + slist + ') ' ;
                System.debug('SOQLQuery-selectAreas::::::::::'+SOQLQuery);
           }         
          }
               
               /* if(selectlangLevel != null &&  selectlangLevel != '' && selectlangLevel!='--None--')
                {
                  selectlangLevels =new list<string>();
                  for (Integer i = Integer.ValueOf(selectlangLevel); i <= 10; i++)
                    {
                    selectlangLevels.Add(String.ValueOf(i));
                    }
                              
                System.debug('selectlangLevels::::::::::'+selectlangLevels);
                SOQLQuery = SOQLQuery + ' AND e.Language_Level__c  IN :selectlangLevels ';
                System.debug('SOQLQuery-selectlangLevels::::::::::'+SOQLQuery);
                  
                }*/
                
                
                  if(selectserviceLevel != null && selectserviceLevel!='' && selectserviceLevel!='--None--')
                {
                selectserviceLevels =new list<string>();                
             selectserviceLevels.Add(selectserviceLevel);
            
                SOQLQuery = SOQLQuery + ' AND e.Service_Level__c  IN :selectserviceLevels ';
                System.debug('SOQLQuery-selectserviceLevels::::::::::'+SOQLQuery);
           }       
                
                
             /*   
                 if(selectserviceLevels != null && selectserviceLevels.size()>0 )
                {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectserviceLevels.size();
                for(String s : selectserviceLevels) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                 
           }
         
           System.debug('selectserviceLevels::::::::::'+selectserviceLevels);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
             for (String s: selectserviceLevels) 
             {
          slist += '\'' + s + '\',';
          }
          slist = slist.substring (0,slist.length() -1);
                SOQLQuery = SOQLQuery + ' AND e.Service_Level__c  IN (' + slist + ') ' ;
                System.debug('SOQLQuery-selectserviceLevels::::::::::'+SOQLQuery);
           }         
                }
          */               
                
                if(selectPositionTypes != null && selectPositionTypes.size()>0 && (selectProgramOption == 'Hospitality Internship' ||  selectProgramCategory == 'Hospitality & Tourism'))
                {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectPositionTypes.size();
                for(String s : selectPositionTypes) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                 
           }
         
           System.debug('selectPositionTypes::::::::::'+selectPositionTypes);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
             for (String s: selectPositionTypes) 
             {
          slist += '\'' + s + '\',';
          }
          slist = slist.substring (0,slist.length() -1);
                SOQLQuery = SOQLQuery + ' AND e.Position_Types__c  INCLUDES (' + slist + ') ' ;
                System.debug('SOQLQuery-selectPositionTypes::::::::::'+SOQLQuery);
           }         
                }
                
               /*  if(selectEduGrade != null &&  selectEduGrade != '' && selectEduGrade!='--None--')
                {
                  selectEduGrades =new List<String>();
                  if(selectEduGrade=='Freshman')
                  {
                    selectEduGrades.add('Freshman');
                  selectEduGrades.add('Sophomore');
                  selectEduGrades.add('Junior');
                  selectEduGrades.add('Senior');
                  selectEduGrades.add('Post Graduate');
                  }
                  else if(selectEduGrade=='Sophomore')
                  {
                  selectEduGrades.add('Sophomore');
                  selectEduGrades.add('Junior');
                  selectEduGrades.add('Senior');
                  selectEduGrades.add('Post Graduate');
                  }
                  else if(selectEduGrade=='Junior')
                  {
                  selectEduGrades.add('Junior');
                  selectEduGrades.add('Senior');
                  selectEduGrades.add('Post Graduate');
                  }
                  else if(selectEduGrade=='Senior')
                  {
                  selectEduGrades.add('Senior');
                  selectEduGrades.add('Post Graduate');
                  }
                  else if(selectEduGrade=='Post Graduate')
                  {
                  selectEduGrades.add('Post Graduate');
                  }
                
                System.debug('selectEduGrades::::::::::'+selectEduGrades);
                SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.Education_Grade__pc  IN :selectEduGrades ';
                System.debug('SOQLQuery-selectEduGrades::::::::::'+SOQLQuery);
                }*/
                if(selectPrepRating!=null && selectPrepRating!='0')
                {
                   selectPrepRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectPrepRating); i <= 10; i++)
               {
                    selectPrepRatings.Add(String.ValueOf(i));
            }
                              
                System.debug('selectPrepRatings::::::::::'+selectPrepRatings);
                SOQLQuery = SOQLQuery + ' AND e.Preparedness_Rating__c  IN :selectPrepRatings ';
                System.debug('SOQLQuery-selectPrepRatings::::::::::'+SOQLQuery);
                
                }
           
                if(selectCompType != null && selectCompType!='' && selectCompType!='--None--')
                {
                selectCompTypes =new list<string>();                
             selectCompTypes.Add(selectCompType);
            
                SOQLQuery = SOQLQuery + ' AND e.Compensation_Type__c  IN :selectCompTypes ';
                System.debug('SOQLQuery-selectCompTypes::::::::::'+SOQLQuery);
           }         
                
                if(selectAgeRanges!=null && selectAgeRange!='' && selectAgeRange!='--None--')
                {
                 
                   Integer lowerLim;
                   Integer UpperLim;
                   selectAgeRanges =new list<string>();
                   Integer AgeDiffLL;
                   
                   selectAgeRanges = selectAgeRange.splitByCharacterType();
                   System.debug('selectAgeRanges::::::::::'+selectAgeRanges);
                   if(!(selectAgeRange.contains('>')))
                   {
                     
                   lowerLim = Integer.ValueOf(selectAgeRanges[0]);
                   UpperLim = Integer.ValueOf(selectAgeRanges[2]);
                   AgeDiffLL = System.Today().year() - lowerLim;
                   Integer AgeDiffUL = System.Today().year() - UpperLim;
                   System.debug('lowerLim::::::::::'+lowerLim);
                   System.debug('UpperLim::::::::::'+UpperLim);
                     
                   SOQLQuery = SOQLQuery + ' AND  CALENDAR_YEAR(e.Account_Id__r.PersonBirthdate)<=:AgeDiffLL AND CALENDAR_YEAR(e.Account_Id__r.PersonBirthdate)>=: AgeDiffUL ';
                   }
                   else
                   {
                     lowerLim = Integer.ValueOf(selectAgeRanges[1]);
                     AgeDiffLL = System.Today().year() - lowerLim;
                     system.debug('System.Today().year()::::::::::'+System.Today().year());
                     
                     SOQLQuery = SOQLQuery + ' AND CALENDAR_YEAR(e.Account_Id__r.PersonBirthdate)<=:AgeDiffLL ';
                   }
                              
               
               System.debug('SOQLQuery-selectAgeRanges::::::::::'+SOQLQuery);
                
                }
              
                if(selectPersRating!=null && selectPersRating!='0')
                {
                   selectPersRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectPersRating); i <= 10; i++)
               {
                    selectPersRatings.Add(String.ValueOf(i));
            }
                      
                System.debug('selectPersRatings::::::::::'+selectPersRatings);
                SOQLQuery = SOQLQuery + ' AND e.Attitude_Rating__c  IN :selectPersRatings ';
                System.debug('SOQLQuery-selectPersRatings::::::::::'+SOQLQuery);
                
                }
                if(selectExpRating!=null && selectExpRating!='0')
                {
                   selectExpRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectExpRating); i <= 10; i++)
               {
                    selectExpRatings.Add(String.ValueOf(i));
            }
                              
                System.debug('selectExpRatings::::::::::'+selectExpRatings);
                SOQLQuery = SOQLQuery + ' AND e.Resume_Rating__c  IN :selectExpRatings ';
                System.debug('SOQLQuery-selectExpRatings::::::::::'+SOQLQuery);
                
                }
             
                if(interest!=null && interest!='') 
                {
                interest=String.escapeSingleQuotes(interest);
                SOQLQuery = SOQLQuery + ' AND e.Location_of_Interest__c like \'%' + interest + '%\'  ';
                System.debug('SOQLQuery-interest::::::::::'+SOQLQuery);
                }
               
               /*  if(schoolName!=null && schoolName!='') 
                {
                schoolName=String.escapeSingleQuotes(schoolName);               
                System.debug('schoolName::::::::::'+schoolName);
                SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.School_Name__pc like \'%' + schoolName + '%\'  ';
                System.debug('SOQLQuery-schoolName::::::::::'+SOQLQuery);
                }*/
                 if(major!=null && major!='') 
                {
                major=String.escapeSingleQuotes(major);
                SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.Major__pc like \'%' + major + '%\'  ';
                System.debug('SOQLQuery-major::::::::::'+SOQLQuery);
                }
               
                if(PositionEngagementStart != null || PositionEngagementEnd!=null || (PositionEngagementStart != null && PositionEngagementEnd!=null) )
                {
                  if(PositionEngagementStart != null && PositionEngagementEnd==null)
                  {
                  SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=: PositionEngagementStart';
                  System.debug('SOQLQuery-PositionEngagementStart::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart == null && PositionEngagementEnd!=null)
                  {
                  Date todaydate = System.today();
                  SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=:todaydate and e.Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart!= null && PositionEngagementEnd!=null && PositionEngagementStart<=PositionEngagementEnd)
                  {
                  SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=: PositionEngagementStart and e.Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementStart PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  System.debug('PositionEngagementStart::::::::::'+PositionEngagementStart); 
                  System.debug('PositionEngagementEnd::::::::::'+PositionEngagementEnd); 
                }
                if((selectStartDuration != '--None--' && selectStartDuration!=null) || (selectEndDuration!='--None--' && selectEndDuration!=null) || (selectStartDuration != '--None--' && selectStartDuration!=null && selectEndDuration!='--None--' && selectEndDuration!=null) )
                {
                 Integer EndDuration = 12;
                 Integer StartDuration = 0;
                System.debug('******StartDuration::::::::::'+selectStartDuration);
                System.debug('******EndDuration::::::::::'+selectEndDuration);
                  if(selectStartDuration != '--None--' && selectStartDuration!=null && selectEndDuration=='--None--' && selectEndDuration!=null)
                  {
                  StartDuration=Integer.valueOf(selectStartDuration.substringBefore(' Month'));
                  SOQLQuery = SOQLQuery + ' AND Integer.valueOf(e.Program_Duration__c.substringBefore(\' Month\')) >=: StartDuration and Integer.valueOf(e.Program_Duration__c.substringBefore(\' Month\')) <=: EndDuration ';
                  System.debug('SOQLQuery-Start::::::::::'+SOQLQuery);
                  }
                  else if ((selectStartDuration == '--None--' || selectStartDuration==null) && selectEndDuration!='--None--' && selectEndDuration!=null)
                  {
                  string str=selectEndDuration.substringBefore(' Month');
                  System.debug('******str::::::::::'+str);
                  EndDuration = Integer.valueOf(str);
                  System.debug('******StartDuration::::::::::'+EndDuration);
                  SOQLQuery = SOQLQuery + ' AND Integer.valueOf(e.Program_Duration__c.substringBefore(\' Month\')) >=:StartDuration and Integer.valueOf(e.Program_Duration__c.substringBefore(\' Month\')) <=: EndDuration ';
                  System.debug('SOQLQuery-End::::::::::'+SOQLQuery);
                  }
                  else if (selectStartDuration!= '--None--' && selectStartDuration!=null && selectEndDuration!=null && selectStartDuration<=selectEndDuration)
                  {
                  StartDuration=Integer.valueOf(selectStartDuration.substringBefore(' Month'));
                  EndDuration = Integer.valueOf(selectEndDuration.substringBefore(' Month'));
                  SOQLQuery = SOQLQuery + ' AND Integer.valueOf(e.Program_Duration__c.substringBefore(\' Month\')) >=: StartDuration and Integer.valueOf(e.Program_Duration__c.substringBefore(\' Month\')) <=: EndDuration ';
                  System.debug('SOQLQuery-Start End::::::::::'+SOQLQuery);
                  }
                  System.debug('PositionEngagementStart::::::::::'+StartDuration); 
                  System.debug('PositionEngagementEnd::::::::::'+EndDuration); 
                }
                    
                    System.debug('SOQLQuery-Final::::::::::'+SOQLQuery);        
                    engagements = Database.query(SOQLQuery);
                    orginalEngagements = engagements;
                } 
             
                   
                
            
            
            //Check for the opportunities size
            if(engagements != null && engagements.size() > 0) {
            
                //Query object
                List<wwwIntraxincComMatchRanking.query> queries = new List<wwwIntraxincComMatchRanking.query>();
                wwwIntraxincComMatchRanking.query query = new wwwIntraxincComMatchRanking.query();
                query.queryString = 'sort by functional areas';
                queries.add(query);
                
                //Call Ranking webservice
                wwwIntraxincComMatchRanking.RankingServicePort rankingServicePort = new wwwIntraxincComMatchRanking.RankingServicePort();
                System.debug(rankingServicePort);
                
                wwwIntraxincComMatchRanking.resultSet resultSet = rankingServicePort.matchRanking('internship', RankingMatchUtility.prepareEntityProps(position), 
                                                    RankingMatchUtility.prepareCandidateList(engagements), queries);
                system.debug('*******resultSet*********'+resultSet);
                //Parse response
               mapOfListEngagementWrapper = RankingMatchUtility.parseResponseForEng(resultSet);
                system.debug('*******map - resultSet*********'+mapOfListEngagementWrapper);
                //Set default sorting parameter
                
                sortDir = 'DESC';
            } else {
               mapOfListEngagementWrapper = new Map<Integer, List<EngagementWrapper>>();
                 system.debug('*******else - map - resultSet*********'+mapOfListEngagementWrapper);
            }
            
            //Sort Result by default
           sortByRanking(mapOfListEngagementWrapper);
        } catch(Exception e){
            System.debug(e);
            ApexPages.addMessages(e);
        }
    }
    
    //Fetch position details and get the appropriate opportunity records with account detail
  public void initAyusa() {
        try {
            //check if position is not null
            if(position != null) {
                
                //fetch the position record detail from data base
                position = [Select Name, RecordType.Name,Program_Year__c,Functional_Areas__c, Matched_Count__c, Double_Placement_Indicated__c,Intrax_Program__c, Intrax_Program_Options__c, Id, Host_Opportunity_Id__c, 
                            Host_Company_ID__c,Host_Company_Id__r.LastName, Single_No_Children_Indicated__c,Personality_Independence__c,Host_Company_ID__r.Citizenship__pc, Engagement_Start__c, Gender_Preference__c,Positions_Sold__c,Religious_Restriction_Indicated__c,Engagement_End__c, Compensation_Type__c, 
                            State__c, Country__c, Regional_Location__c,Smoker_in_Family__c,Pets__c,Interests__c,School_Category__c,Nationality_Preferences__c,Countries_of_Interest__c, Position_Types__c, Flexible_Dates__c,
                            (Select Id, Participant_Opportunity_Id__c, engagement__c,Participant_Id__c from Matches__r)  From Position__c where Id =: position.Id];
               
                string strPosIP = position.Intrax_Program__c;
                //initialize set
                existingMatches = new Set<String>();
                if(position.Matches__r != null && position.Matches__r.size() > 0) {
                    for(Match__c match : position.Matches__r)
                       existingMatches.add(match.engagement__c + '-' + match.Participant_Id__c);
                }
                
                system.debug('****position.Intrax_Program__c*****'+position.Intrax_Program__c);
                system.debug('****position.Record Type*****'+position.RecordType.Name);
              
               if(position.RecordType.Name =='HS Worldwide HF') {
               ReqMatchEngagements=[Select e.Account_Id__r.Nationality__pc,e.Id,e.Account_Id__r.Gender__pc,e.Account_Id__c,(Select engagement__c,Status__c,Engagement__r.Id From Matches__r where status__c='Requested') 
               From Engagement__c e where e.RecordType.Name='HS Worldwide PT' and  e.Intrax_Program__c=:strPosIP  and e.Type__c = 'Participant'  AND (e.Status__c = 'Processing' or e.Status__c ='Program Ready' or e.Status__c ='On Program') and (e.Placement_Status__c = 'Not Placed' or e.Placement_Status__c ='Pending' ) AND e.Account_Id__r.Type = 'Participant' AND (e.Account_Id__r.Status__c = 'Prospect' OR e.Account_Id__r.Status__c = 'Active' OR e.Account_Id__r.Status__c = 'Contracted')];
               }
               else {
               ReqMatchEngagements=[Select e.Account_Id__r.Nationality__pc,e.Id,e.Account_Id__r.Gender__pc,e.Account_Id__c,(Select engagement__c,Status__c,Engagement__r.Id From Matches__r where status__c='Requested') 
               From Engagement__c e where e.RecordType.Name='Ayusa PT' and e.Intrax_Program__c=:strPosIP  and e.Type__c = 'Participant'  AND (e.Status__c = 'Processing' or e.Status__c ='Program Ready' or e.Status__c ='On Program') and (e.Placement_Status__c = 'Not Placed' or e.Placement_Status__c ='Pending' ) AND e.Account_Id__r.Type = 'Participant' AND (e.Account_Id__r.Status__c = 'Prospect' OR e.Account_Id__r.Status__c = 'Active' OR e.Account_Id__r.Status__c = 'Contracted')];
               }
               system.debug('****ReqMatchEngagements size*****'+ReqMatchEngagements.size());
              
              // e.Intrax_Program__c  INCLUDES + '( ' + position.Intrax_Program__c + ')'  AND
               ReqMatchEngagementIds=new set<Id>();
                if(ReqMatchEngagements !=null && ReqMatchEngagements.size()>0)
                {
                    for(Engagement__c eng : ReqMatchEngagements)
                    {
                        if(eng.Matches__r!=null && eng.Matches__r.size()>0)
                        ReqMatchEngagementIds.add(eng.Id);
                    }
                }
                  System.debug('ReqMatchEngagementIds::::::::::'+ReqMatchEngagementIds);
                //Build SOQl Query
                String SOQLQuery;
                boolean blnActive=false;
                PositionEngagementStart=DummyObj.Engagement_Start__c;
                PositionEngagementEnd=DummyObj.Engagement_End__c;
               
             
     if (ReqMatchEngagementIds!=null && ReqMatchEngagementIds.size()>0)
     {
         if (selectPartner!=null && selectPartner!='')
         {
                engPartid = new set<id>();
                selectPartner=String.escapeSingleQuotes(selectPartner);
                selectPartner ='%'+ selectPartner + '%'; 
                list<account> acc= [Select id,name From Account a where a.name like :selectPartner];
            set<id> accid = new set<id>();
            if(acc!=null && acc.size()>0)
            {
            for(account tempacc : acc)
            {            
            accid.add(tempacc.id);
            }
            }
             System.debug('acc::::::::::'+acc);
              System.debug('accid::::::::::'+accid);
          
             SOQLQuery = 'Select e.RecordType.Name,e.Position_Types__c, e.Personality_Independence__c ,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c, e.Name, e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c,e.Tuition__c , e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc,' +
                        + ' e.Account_Id__r.English_Level__pc,e.Account_Id__r.isPersonAccount, e.Account_Id__r.Citizenship__pc,e.Live_With_Smoker__c, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type,'+
                        + 'e.Account_Id__r.Name,e.Account_Id__r.LastName,e.Account_Id__r.age__pc,e.Placement_status__c,e.Age_At_Program_Start__c, e.Account_Id__r.Id, e.Account_Id__c From Engagement__c e where ' +
                        + 'e.Intrax_Program__c  INCLUDES (' + '\'' + position.Intrax_Program__c  + '\'' + ')' +
                        + ' AND e.Type__c = \'Participant\'  AND (e.Status__c = \'Processing\' or e.Status__c =\'Program Ready\' or e.Status__c =\'On Program\') and (e.Placement_Status__c = \'Not Placed\' or e.Placement_Status__c =\'Pending\' )  '+ 
                        +  ' AND e.Account_Id__r.Type = \'Participant\' ' + 'AND (e.Account_Id__r.Status__c = \'Prospect\' OR e.Account_Id__r.Status__c = \'Active\' OR e.Account_Id__r.Status__c = \'Contracted\') and e.Partner_Account__c in :accid and e.Id not in :ReqMatchEngagementIds';
           
             
                     } 
        
             
        
        else
         {
          SOQLQuery = 'Select e.RecordType.Name,e.Position_Types__c,e.Placement_status__c, e.Personality_Independence__c ,e.Live_With_Smoker__c,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c, e.Name, e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c, e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc,' +
                        + ' e.Account_Id__r.English_Level__pc,e.Account_Id__r.LastName,e.Account_Id__r.isPersonAccount, e.Account_Id__r.Citizenship__pc, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type,'+
                        + 'e.Account_Id__r.Name,e.Tuition__c , e.Account_Id__r.age__pc,e.Account_Id__r.Id,e.Age_At_Program_Start__c, e.Account_Id__r.Nationality__pc,e.Account_Id__r.Gender__pc,e.Account_Id__c From Engagement__c e where ' +
                         + 'e.Intrax_Program__c  INCLUDES (' + '\'' + position.Intrax_Program__c  + '\'' + ')' +
                        + ' AND e.Type__c = \'Participant\'   AND (e.Status__c = \'Processing\' or e.Status__c =\'Program Ready\' or e.Status__c =\'On Program\') and (e.Placement_Status__c = \'Not Placed\' or e.Placement_Status__c =\'Pending\' )  '+
                        + ' AND e.Account_Id__r.Type = \'Participant\' '+ 
                        + ' AND (e.Account_Id__r.Status__c = \'Prospect\' OR e.Account_Id__r.Status__c = \'Active\' OR e.Account_Id__r.Status__c = \'Contracted\') and e.Id not in :ReqMatchEngagementIds';
                        
        }  
     }
     else
     {
        if (selectPartner!=null && selectPartner!='')
         {
                engPartid = new set<id>();
                selectPartner=String.escapeSingleQuotes(selectPartner);
                selectPartner ='%'+ selectPartner + '%'; 
                list<account> acc= [Select id,name From Account a where a.name like :selectPartner];
            set<id> accid = new set<id>();
            if(acc!=null && acc.size()>0)
            {
            for(account tempacc : acc)
            {            
            accid.add(tempacc.id);
            }
            }
             System.debug('acc::::::::::'+acc);
              System.debug('accid::::::::::'+accid);
          
             SOQLQuery = 'Select e.RecordType.Name,e.Position_Types__c, e.Personality_Independence__c ,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c, e.Name, e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c,e.Tuition__c ,e.Account_Id__r.LastName,e.Account_Id__r.isPersonAccount, e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc,' +
                        + ' e.Account_Id__r.English_Level__pc, e.Account_Id__r.Citizenship__pc,e.Live_With_Smoker__c, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type,'+
                        + 'e.Account_Id__r.Name,e.Account_Id__r.age__pc,e.Placement_status__c,e.Age_At_Program_Start__c, e.Account_Id__r.Id, e.Account_Id__c From Engagement__c e where ' +
                        + 'e.Intrax_Program__c  INCLUDES (' + '\'' + position.Intrax_Program__c  + '\'' + ')' +
                        + ' AND e.Type__c = \'Participant\'  AND (e.Status__c = \'Processing\' or e.Status__c =\'Program Ready\' or e.Status__c =\'On Program\') and (e.Placement_Status__c = \'Not Placed\' or e.Placement_Status__c =\'Pending\' )  '+ 
                        +  ' AND e.Account_Id__r.Type = \'Participant\' ' + 'AND (e.Account_Id__r.Status__c = \'Prospect\' OR e.Account_Id__r.Status__c = \'Active\' OR e.Account_Id__r.Status__c = \'Contracted\') and e.Partner_Account__c in :accid ';
           
             
                     } 
        
             
        
        else
         {
          SOQLQuery = 'Select e.RecordType.Name,e.Position_Types__c,e.Placement_status__c, e.Personality_Independence__c ,e.Live_With_Smoker__c,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c, e.Name, e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c, e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc,' +
                        + ' e.Account_Id__r.English_Level__pc,e.Account_Id__r.LastName, e.Account_Id__r.isPersonAccount,e.Account_Id__r.Citizenship__pc, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type,'+
                        + 'e.Account_Id__r.Name,e.Tuition__c , e.Account_Id__r.age__pc,e.Account_Id__r.Id,e.Age_At_Program_Start__c, e.Account_Id__r.Nationality__pc,e.Account_Id__r.Gender__pc,e.Account_Id__c From Engagement__c e where ' +
                         + 'e.Intrax_Program__c  INCLUDES (' + '\'' + position.Intrax_Program__c  + '\'' + ')' +
                        + ' AND e.Type__c = \'Participant\'   AND (e.Status__c = \'Processing\' or e.Status__c =\'Program Ready\' or e.Status__c =\'On Program\') and (e.Placement_Status__c = \'Not Placed\' or e.Placement_Status__c =\'Pending\' )  '+
                        + ' AND e.Account_Id__r.Type = \'Participant\' '+ 
                        + ' AND (e.Account_Id__r.Status__c = \'Prospect\' OR e.Account_Id__r.Status__c = \'Active\' OR e.Account_Id__r.Status__c = \'Contracted\') ';
                        
        }  
     }      
              if(position.RecordType.Name =='HS Worldwide HF') {
                SOQLQuery = SOQLQuery + ' AND e.RecordType.Name = \'HS Worldwide PT\' ';
                  System.debug('AND e.RecordTypeName = \'HS Worldwide PT\''+SOQLQuery);
              }
              else{
                SOQLQuery = SOQLQuery + ' AND e.RecordType.Name = \'Ayusa PT\' ';
                  System.debug('AND e.RecordTypeName = \'Ayusa PT\''+SOQLQuery);
              } 
                
                System.debug('SOQLQuery-1::::::::::'+SOQLQuery);            
                  
               if(PositionEngagementStart != null || PositionEngagementEnd!=null || (PositionEngagementStart != null && PositionEngagementEnd!=null) )
                {
                  if(PositionEngagementStart != null && PositionEngagementEnd==null)
                  {
                  SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=: PositionEngagementStart';
                  System.debug('SOQLQuery-PositionEngagementStart::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart == null && PositionEngagementEnd!=null)
                  {
                  Date todaydate = System.today();
                  SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=:todaydate and e.Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart!= null && PositionEngagementEnd!=null && PositionEngagementStart<=PositionEngagementEnd)
                  {
                  SOQLQuery = SOQLQuery + ' AND e.Engagement_Start__c >=: PositionEngagementStart and e.Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementStart PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  System.debug('PositionEngagementStart::::::::::'+PositionEngagementStart); 
                  System.debug('PositionEngagementEnd::::::::::'+PositionEngagementEnd); 
                }
                   if(selectGenderPref != null && selectGenderPref!='' && selectGenderPref!='--None--')
                    {                         
                      SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.Gender__pc = \'' + selectGenderPref + '\'';
                     System.debug('SOQLQuery-selectGenderPref::::::::::'+SOQLQuery);
                 } 
                  if(selectProgramDuration != null && selectProgramDuration!='' && selectProgramDuration!='--None--')
                    {                         
                      SOQLQuery = SOQLQuery + ' AND e.Program_Duration__c = \'' + selectProgramDuration + '\'';
                     System.debug('SOQLQuery-selectProgramDuration::::::::::'+SOQLQuery);
                 }
                      if(selectReligions != null && selectReligions.size()>0)
                   {
                      engAppInfo = new Set<Id>();
                        Integer DelNone;
                        System.debug('selectReligions::::::::::'+selectReligions);
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = selectReligions.size();
                        for(String s : selectReligions) 
                          {
                          if(len==1 && (s.equals('--None--')||s.equals('No Preference')))
                             blnNoneExists = true;
                          if(s.equals('No Preference'))
                            blnNoneExists = true;
                         }
                 
                   System.debug('selectReligions::::::::::'+selectReligions);
                   System.debug('blnNoneExists::::::::::'+blnNoneExists);
                   if(!blnNoneExists)
                   {
                    
                   
                     List<Applicant_Info__c> appInfoList = [SELECT Id,Name,Religion__c,Engagement__c FROM Applicant_Info__c WHERE Religion__c in :selectReligions and Engagement__c!=null];
                    if(appInfoList.size()>0){
                    for(Applicant_Info__c app:appInfoList){                     
                            engAppInfo.add(app.Engagement__c);
                    }
                    
                     System.debug('SOQLQuery-appInfoList::::::::::'+appInfoList);  
                    }  
                    System.debug('engAppInfo::::::::::'+engAppInfo);        
                  // if(engAppInfo.size()>0){
                        SOQLQuery = SOQLQuery + ' AND  e.Id  IN :engAppInfo ';
                        System.debug('SOQLQuery-selectReligions::::::::::'+SOQLQuery);
                   //}
                   }}         
                       
                 if(selectTuitionRange != null && selectTuitionRange!='' && selectTuitionRange!='--None--')
                    {                         
                      SOQLQuery = SOQLQuery + ' AND e.tuition__c = \'' + selectTuitionRange + '\'';
                     System.debug('SOQLQuery-selectTuitionRange::::::::::'+SOQLQuery);
                 }         
                
                   if(selectAyusaProgramOptions != null && selectAyusaProgramOptions.size()>0)
                    {
                        Integer DelNone;
                         String slist = '';
                        System.debug('selectAyusaProgramOptions::::::::::'+selectAyusaProgramOptions);
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = selectAyusaProgramOptions.size();
                        for(String s : selectAyusaProgramOptions) 
                          {
                          if(len==1 && s.equals('--None--'))
                             blnNoneExists = true;
                        
                         }
                 
                   System.debug('selectAyusaProgramOptions::::::::::'+selectAyusaProgramOptions);
                   System.debug('blnNoneExists::::::::::'+blnNoneExists);
                   
                   if(!blnNoneExists)
                   {
                     for (String s: selectAyusaProgramOptions) 
                             {
                            slist += '\'' + s + '\',';
                            System.debug('SOQLQuery-slist::::::::::'+slist);
                          }
                          slist = slist.substring (0,slist.length() -1);
                        SOQLQuery = SOQLQuery + ' AND  e.Intrax_Program_Options__c Includes (' + slist + ') ';
                        System.debug('SOQLQuery-selectAyusaProgramOptions::::::::::'+SOQLQuery);
                   }         
                 } 
                   
                 if(selectSmokerFamily == 'Yes')
                    {                         
                     SOQLQuery = SOQLQuery + ' AND e.Live_With_Smoker__c = \'Yes\'';
                     System.debug('SOQLQuery-selectSmokerFamily::::::::::'+SOQLQuery);
                    }   
                     if(selectSNK == 'Yes')
                    {                         
                     SOQLQuery = SOQLQuery + ' AND e.Single_No_Children_Indicated__c = \'Yes\'';
                     System.debug('SOQLQuery-Single_No_Children_Indicated__c::::::::::'+SOQLQuery);
                    }  
                      if(selectDPIndicated == 'Yes')
                    {                         
                     SOQLQuery = SOQLQuery + ' AND e.Double_Placement_Indicated__c = \'Yes\'';
                     System.debug('SOQLQuery-Double_Placement_Indicated__c::::::::::'+SOQLQuery);
                    } 
                     if(selectEngName!=null && selectEngName!='') 
                {
                selectEngName=String.escapeSingleQuotes(selectEngName);               
                System.debug('selectEngName::::::::::'+selectEngName);
                SOQLQuery = SOQLQuery + ' AND e.Name like \'%' + selectEngName + '%\'  ';
                System.debug('SOQLQuery-selectEngName::::::::::'+SOQLQuery);
                }
                 if(selectPet == 'Yes')
                    {                         
                     SOQLQuery = SOQLQuery + ' AND e.Live_With_pets__c  = \'Yes\'';
                     System.debug('SOQLQuery-selectPet::::::::::'+SOQLQuery);
                     }  
                      if(selectSpecialDiet != null && selectSpecialDiet!='' && selectSpecialDiet!='--None--')
                    {                         
                     SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.Special_Diet__pc  = \'' + selectSpecialDiet + '\'';
                     System.debug('SOQLQuery-selectSpecialDiet::::::::::'+SOQLQuery);
                     }  
                      if(selectSchoolCategory == 'Private')
                    {                         
                     SOQLQuery = SOQLQuery + ' AND e.Private_High_School_Indicated__c  = \'Yes\'';
                     System.debug('SOQLQuery-Private_High_School_Indicated__c::::::::::'+SOQLQuery);
                     } 
                   
                       if(selectNationalPreferences != null && selectNationalPreferences.size()>0)
                   {
                        Integer DelNone;
                        System.debug('selectNationalPreferences::::::::::'+selectNationalPreferences);
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = selectNationalPreferences.size();
                        for(String s : selectNationalPreferences) 
                          {
                          if(len==1 && (s.equals('--None--')||s.equals('No Preference')))
                             blnNoneExists = true;
                          if(s.equals('No Preference'))
                            blnNoneExists = true;
                         }
                 
                   System.debug('selectNationalPreferences::::::::::'+selectNationalPreferences);
                   System.debug('blnNoneExists::::::::::'+blnNoneExists);
                   if(!blnNoneExists)
                   {
                        SOQLQuery = SOQLQuery + ' AND  e.Account_Id__r.Nationality__pc  IN :selectNationalPreferences ';
                        System.debug('SOQLQuery-selectNationalPreferences::::::::::'+SOQLQuery);
                   }         
                 } 
                  if(selectInterests != null && selectInterests.size()>0)
                   {
                      String slist = '';
                        Integer DelNone;
                        System.debug('selectInterests::::::::::'+selectInterests);
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = selectInterests.size();
                        for(String s : selectInterests) 
                          {
                          if(len==1 && s.equals('--None--'))
                             blnNoneExists = true;
                         }
                 
                   System.debug('selectInterests::::::::::'+selectInterests);
                   System.debug('blnNoneExists::::::::::'+blnNoneExists);
                   if(!blnNoneExists)
                           {
                             for (String s: selectInterests) 
                             {
                            slist += '\'' + s + '\',';
                            System.debug('SOQLQuery-slist::::::::::'+slist);
                          }
                          slist = slist.substring (0,slist.length() -1);
                     SOQLQuery = SOQLQuery + ' AND  e.Interests_Top__c  INcludes (' + slist + ') ';
                        System.debug('SOQLQuery-selectInterests::::::::::'+SOQLQuery);
                          
                  }
                   }
                   if(selectLanguagesSpoken != null && selectLanguagesSpoken.size()>0)
                   {
                         String slist = '';
                        Integer DelNone;
                        System.debug('selectLanguagesSpoken::::::::::'+selectLanguagesSpoken);
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = selectLanguagesSpoken.size();
                        for(String s : selectLanguagesSpoken) 
                          {
                          if(len==1 && s.equals('--None--'))
                             blnNoneExists = true;
                         }
                 
                   System.debug('selectLanguagesSpoken::::::::::'+selectLanguagesSpoken);
                   System.debug('blnNoneExists::::::::::'+blnNoneExists);
                        if(!blnNoneExists)
                           {
                             for (String s: selectLanguagesSpoken) 
                             {
                            slist += '\'' + s + '\',';
                            System.debug('SOQLQuery-slist::::::::::'+slist);
                          }
                          slist = slist.substring (0,slist.length() -1);
                        
                               SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.Languages_Spoken__pc  INCLUDES (' + slist + ') ' ;
                              
                               
                                System.debug('SOQLQuery-selectLanguagesSpoken::::::::::'+SOQLQuery);
                           }
                     
                 }
                  if(selectAges != null && selectAges.size()>0)
                   {
                         String slist = '';
                         List<decimal> lstDblAges = new list<decimal>();
                        Integer DelNone;
                        System.debug('selectAges::::::::::'+selectAges);
                        boolean blnNoneExists=false;  
                        integer len=0;
                        len = selectAges.size();
                        for(string s : selectAges) 
                          {
                          if(len==1 && s.equals('--None--'))
                             blnNoneExists = true;
                          if(s.equals('--None--'))
                             blnNoneExists = true;
                         }
                 
                   System.debug('selectAges::::::::::'+selectAges);
                   System.debug('blnNoneExists::::::::::'+blnNoneExists);
                        if(!blnNoneExists)
                           {
                            for (String s:  selectAges) 
                             {
                                lstDblAges.add(decimal.valueof(s));
                                System.debug('SOQLQuery-lstDblAges::::::::::'+lstDblAges);
                          }
                     
                               SOQLQuery = SOQLQuery + ' AND e.Age_At_Program_Start__c  IN :lstDblAges ' ;                             
                               
                                System.debug('SOQLQuery-selectAges::::::::::'+SOQLQuery);
                           }
                     
                 }
                
              
                if(selectEnergyLevelRating!=null && selectEnergyLevelRating!='0')
                {
                   selectEnergyLevelRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectEnergyLevelRating); i <= 10; i++)
                 {
                    selectEnergyLevelRatings.Add(String.ValueOf(i));
                 }
                      
                System.debug('selectEnergyLevelRatings::::::::::'+selectEnergyLevelRatings);
                SOQLQuery = SOQLQuery + ' AND e.Personality_Energy_Level__c IN :selectEnergyLevelRatings ';
                System.debug('SOQLQuery-selectEnergyLevelRatings::::::::::'+SOQLQuery);
                
                }
                 if(selectExpressivenessRating!=null && selectExpressivenessRating!='0')
                {
                   selectExpressivenessRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectExpressivenessRating); i <= 10; i++)
                 {
                    selectExpressivenessRatings.Add(String.ValueOf(i));
                 }
                      
                System.debug('selectExpressivenessRatings::::::::::'+selectExpressivenessRatings);
                SOQLQuery = SOQLQuery + ' AND e.Personality_Expressiveness__c IN :selectExpressivenessRatings ';
                System.debug('SOQLQuery-selectExpressivenessRatings::::::::::'+SOQLQuery);
                
                }
                 if(selectFunninessRating!=null && selectFunninessRating!='0')
                {
                   selectFunninessRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectFunninessRating); i <= 10; i++)
                 {
                    selectFunninessRatings.Add(String.ValueOf(i));
                 }
                      
                System.debug('selectFunninessRatings::::::::::'+selectFunninessRatings);
                SOQLQuery = SOQLQuery + ' AND e.Personality_Funniness__c IN :selectFunninessRatings ';
                System.debug('SOQLQuery-selectFunninessRatings::::::::::'+SOQLQuery);
                
                }
                 if(selectIndependenceRating!=null && selectIndependenceRating!='0')
                {
                   selectIndependenceRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectIndependenceRating); i <= 10; i++)
                 {
                    selectIndependenceRatings.Add(String.ValueOf(i));
                 }
                      
                System.debug('selectIndependenceRatings::::::::::'+selectIndependenceRatings);
                SOQLQuery = SOQLQuery + ' AND e.Personality_Independence__c IN :selectIndependenceRatings ';
                System.debug('SOQLQuery-selectIndependenceRatings::::::::::'+SOQLQuery);
                
                }
                 if(selectMaturityRating!=null && selectMaturityRating!='0')
                {
                   selectMaturityRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectMaturityRating); i <= 10; i++)
                 {
                    selectMaturityRatings.Add(String.ValueOf(i));
                 }
                      
                System.debug('selectMaturityRatings::::::::::'+selectMaturityRatings);
                SOQLQuery = SOQLQuery + ' AND e.Personality_Maturity__c IN :selectMaturityRatings ';
                System.debug('SOQLQuery-selectMaturityRatings::::::::::'+SOQLQuery);
                
                }
                 if(selectOpinionatednessRating!=null && selectOpinionatednessRating!='0')
                {
                   selectOpinionatednessRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectOpinionatednessRating); i <= 10; i++)
                 {
                    selectOpinionatednessRatings.Add(String.ValueOf(i));
                 }
                      
                System.debug('selectOpinionatednessRatings::::::::::'+selectOpinionatednessRatings);
                SOQLQuery = SOQLQuery + ' AND e.Personality_Opinionatedness__c IN :selectOpinionatednessRatings ';
                System.debug('SOQLQuery-selectOpinionatednessRatings::::::::::'+SOQLQuery);
                
                }
                 if(selectStructureRating!=null && selectStructureRating!='0')
                {
                   selectStructureRatings =new list<string>();
                  for (Integer i = Integer.ValueOf(selectStructureRating); i <= 10; i++)
                 {
                    selectStructureRatings.Add(String.ValueOf(i));
                 }
                      
                System.debug('selectStructureRatings::::::::::'+selectStructureRatings);
                SOQLQuery = SOQLQuery + ' AND e.Personality_Structure__c IN :selectStructureRatings ';
                System.debug('SOQLQuery-selectStructureRatings::::::::::'+SOQLQuery);
                
                }
                            
                    System.debug('SOQLQuery-Final::::::::::'+SOQLQuery);        
                    engagements = Database.query(SOQLQuery);
                    orginalEngagements = engagements;
                }          
            
            //Check for the opportunities size
            if(engagements != null && engagements.size() > 0) {
            
                //Query object
                List<wwwIntraxincComMatchRanking.query> queries = new List<wwwIntraxincComMatchRanking.query>();
                wwwIntraxincComMatchRanking.query query = new wwwIntraxincComMatchRanking.query();
                query.queryString ='sort by functional areas';
                queries.add(query);
                  system.debug('******queries******'+queries);
                system.debug('******Query******'+query);
                
                //Call Ranking webservice
                wwwIntraxincComMatchRanking.RankingServicePort rankingServicePort = new wwwIntraxincComMatchRanking.RankingServicePort();
                System.debug(rankingServicePort);
                
                wwwIntraxincComMatchRanking.resultSet resultSet = rankingServicePort.matchRanking('hostFamily', RankingMatchUtility.prepareHFPositionProps(position), 
                                                    RankingMatchUtility.prepareEngagementList(engagements), queries);
                                                     system.debug('*******resultSet*********'+resultSet);
                  system.debug('******mapOfListEngagementWrapper******'+mapOfListEngagementWrapper);
                //Parse response
                mapOfListEngagementWrapper = RankingMatchUtility.parseResponseForEng(resultSet);
                  system.debug('******mapOfListEngagementWrapper******'+mapOfListEngagementWrapper);
                //Set default sorting parameter
                sortDir = 'DESC';
            } else {
                mapOfListEngagementWrapper = new Map<Integer, List<EngagementWrapper>>();
            }
            
            
            //Sort Result by default
           sortByRanking(mapOfListEngagementWrapper);
             system.debug('******mapOfListEngagementWrapper******'+mapOfListEngagementWrapper);
        } catch(Exception e){
            System.debug(e);
            ApexPages.addMessages(e);
        }
    }
    
    //Getter method to diplay the Opportunity record on page
    public List<EngagementWrapper> getPossibleMatchesList() {
        
        //return the records in current context
        if(listOfListEngagements != null && listOfListEngagements.size() > 0 && listOfListEngagements[0] != null && listOfListEngagements[0].size() > 0 && listOfListEngagements.size() >= ListIndex+1)
        {
            system.debug('listOfListEngagements****'+ listOfListEngagements);
            return listOfListEngagements[ListIndex];
        }
        else
        {
          
            return new List<EngagementWrapper>();
        }
    }
    
    //This method is to perform the save operation
    public PageReference save() {        
        try {
            //Create a new list of Matched record
            List<Match__c> matches = new List<Match__c>();
            
            list<Selection__c> selections = new list<Selection__c>();
            engagement__c eng;
            //loop through the wrapper list and create matches for selected participants
            for(List<EngagementWrapper> listWrapper : listOfListEngagements) {
                for(EngagementWrapper eWrapper : listWrapper) {
                    if(eWrapper.selected){
                        if(eWrapper.engagement!=null){
                            if(position.Intrax_Program__c=='Ayusa') {
                                string strName= eWrapper.engagement.Account_Id__r.LastName + ' - '+ position.Host_Company_Id__r.LastName + ' - ' + 'AY'+ position.Program_Year__c ;                                                  
                                matches.add(new Match__c(
                                                        Name = strName, Participant_Id__c = eWrapper.engagement.Account_Id__r.Id, 
                                                        Participant_Opportunity_Id__c = eWrapper.engagement.Opportunity_Id__r.Id, 
                                                        Position_Name__c = position.Id, Rank_at_Match__c = eWrapper.ranking, 
                                                        Similarity_at_Match__c = eWrapper.sim,engagement__c=eWrapper.engagement.Id,
                                                        RecordTypeId=Constants.MAT_AYUSA));
                            }
                            else if (position.Intrax_Program__c=='Internship' || position.Intrax_Program__c=='Work Travel')
                                matches.add(new Match__c(
                                                        Name = eWrapper.engagement.Account_Id__r.Name, 
                                                        Participant_Id__c = eWrapper.engagement.Account_Id__r.Id  , 
                                                        Participant_Opportunity_Id__c = eWrapper.engagement.Opportunity_Id__r.Id, 
                                                        Position_Name__c = position.Id, Rank_at_Match__c = eWrapper.ranking, 
                                                        Similarity_at_Match__c = eWrapper.sim,engagement__c=eWrapper.engagement.Id,
                                                        RecordTypeId=Constants.MAT_INTERNSHIP));
                            else if(position.Intrax_Program__c=='AuPairCare'){
                                selections.add(new Selection__c(
                                                        Name = eWrapper.engagement.Account_Id__r.Name, 
                                                        Engagement__c = eWrapper.engagement.Id, 
                                                        Position__c = position.Id, 
                                                        Intrax_Program__c = 'AuPairCare',
                                                        //Status__c = 'Active', 
                                                        Recommendation_Type__c = 'Staff'
                                                        ));
                            }
                        }
                    
                    }
                }
            }
            
            //Check for the matches
            if(matches.size() > 0) insert matches;
            else if(selections.size() > 0) insert selections;
            
            return new PageReference('/' + position.Id);
        
        
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    /** This code is to handle the paging part */
    //Decrements the ListIndex for paging
    public void getPrevious() {
        
        //decrease the page counter by one, when previous is clicked
        pageNO  = pageNO - 1;
        if(resultsStartNumber > 1) {
            resultsStartNumber = resultsStartNumber - Constants.RANK_PAGE_SIZE;
            resultsStopNumber = resultsStopNumber  - listOfListEngagements[ListIndex].size();
        }
        
        if(ListIndex > 0)
            ListIndex--;
    }
            
    //Increments the ListIndex for paging
    public void getNext() {
        
        pageNO  = pageNO + 1;
        if(totalResults > resultsStopNumber) {
            resultsStartNumber = resultsStopNumber + 1;
            resultsStopNumber = resultsStopNumber  + listOfListEngagements[ListIndex + 1].size();
        }
 
        if(ListIndex < listOfListEngagements.size()-1 )
            ListIndex++;
    }
    
    //SortByRanking
    public void sortByRanking(Map<Integer, List<EngagementWrapper>> mapOfListEngagementWrapper) {
        
        //Create a list of Rank
        List<Integer> rankingList = new List<Integer>(mapOfListEngagementWrapper.keySet());
        rankingList.sort();
        
        //List to hold teh clone of Ranking list
        List<Integer> orderedRankingList = new List<Integer>();
        
        if(sortDir == 'ASC') {
            
            //Set the records in desending format
            for(Integer i = rankingList.size()-1; i >= 0; i--) {
                
                //Add Item in final list to be processed
                orderedRankingList.add(rankingList[i]);
            }
            
            //set sort direction to descending order
            sortDir = 'DESC';
        } else if(sortDir == 'DESC') {
            
            //Set the records in desending format
            for(Integer i = 0; i < rankingList.size(); i++) {
                
                //Add Item in final list to be processed
                orderedRankingList.add(rankingList[i]);
            }
            
            //set sort direction to descending order
            sortDir = 'ASC';
        } 
        
        //add a new list in list of list
        listOfListEngagements = new List<List<EngagementWrapper>>();
        listOfListEngagements.add(new List<EngagementWrapper>());
        
        //Set the variable for default
        ListIndex = 0;
        resultsStartNumber = 0;
        resultsStopNumber = 0;
        totalResults = 0;
        
        //loop through the list
        for(Integer rank : orderedRankingList) {
            
            //Loop through the results
            for(EngagementWrapper EngagementWrapper : mapOfListEngagementWrapper.get(rank)) {
                
                //Add the opportunity record in list of list Opportunity wrapper
                //add only Page Size records in a list
                if(listOfListEngagements[listOfListEngagements.size() - 1].size() == Constants.RANK_PAGE_SIZE)
                    listOfListEngagements.add(new List<EngagementWrapper>());
                    
                //avoid if matches are already then, then do not include
                if(!existingMatches.contains(EngagementWrapper.engagement.Id + '-' + EngagementWrapper.engagement.Account_Id__r.Id)) {
                      
                    //add opportunity record in the list to be displayed on the page
                    listOfListEngagements[listOfListEngagements.size() - 1].add(EngagementWrapper);
                    
                    //increase the total counter
                    totalResults = totalResults + 1;
                }
            }
        }
        
        //Check if total counter is greater then zero then set the other variables values
        if(totalResults > 0) {
            
            //Show the search results from 1st record
            resultsStartNumber = 1;
            if(totalResults > Constants.RANK_PAGE_SIZE)
                resultsStopNumber = Constants.RANK_PAGE_SIZE;
            else
                resultsStopNumber = totalResults;
            searchResultMessage = String.valueOf(totalResults) + ' record(s) found.';
        
        } else
          searchResultMessage = 'No record(s) found.';
            system.debug('******orderedRankingList******'+orderedRankingList);
             system.debug('******listOfListEngagements******'+listOfListEngagements);
    }
    
    //Method to sort result
    public void sortResults() {
        
        //Sort result
        sortByRanking(mapOfListEngagementWrapper);
    }
    
     
    
    public String getEarlyEndedCriteria(){
        try{
            list<Match__c> listMatch = [Select Status__c, Position_Name__c, Engagement__c 
                                        From Match__c 
                                        Where Position_Name__c =: position.Id
                                        And Status__c = 'Ended Early'];
            
            String idString = '';
            if(listMatch.size() > 0){
                idString = '(\'';
                for(Match__c match : listMatch){                    
                    if(match.Engagement__c != null)idString += match.Engagement__c + '\',\'';
                }
                
                idString = idString.substring(0,idString.length()-2); 
                idString += ')';
                idString = ' AND  Id NOT IN ' + idString;
            }
            
            return idString;
            
            
        }catch(Exception e){
            system.debug('Error getting the match records: ' + e);
            return '';
        }       
        
    }
    
     public List<SelectOption> ArrivalDates{
        get{
            try{
            system.debug('****@@@@inside  getlistArrivalDates()');
                        
            List<APC_ArrivalDates__c> listArrivalDates =  [Select US_Arrival__c, Match_Request_Deadline__c
                                                           From APC_ArrivalDates__c
                                                           Where Match_Request_Deadline__c > :date.today()
                                                           Order By Match_Request_Deadline__c Asc];
            
            system.debug('****@@@@ listArrivalDates: ' + listArrivalDates); 
            
            List<SelectOption> options = new List<SelectOption>();
           
            for (APC_ArrivalDates__c arc: listArrivalDates)
            {
                string dateArrival = datetime.newInstance(arc.US_Arrival__c.year(), arc.US_Arrival__c.month(),arc.US_Arrival__c.day()).format('MM/dd/yyyy');
                options.add(new selectOption(dateArrival,dateArrival));
                dateArrival = '';
            }
            
            System.debug('*************options:'+options);
            return options;              
           
        }catch(Exception e){system.debug('@@@@@ Exception in ArrivalDates: ' + e);
            return null;
        }
        }set;
    } 
    
    private Date setStringToDateFormat(String myDate) {
        system.debug('+++++ setStringToDateFormat: ' + myDate);
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntYear = integer.valueOf(strDate[2]);
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        system.debug('+++++ setStringToDateFormat: ' + d);
        return d;
    } 
    
}