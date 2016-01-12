/**
 *  Purpose         :   Ranking Match.
 *              
 *  Created Date    :   08/12/2012
 *  
 *  Current Version :   v1.0
 *  
 *  Revision Log    :   V_1.1 Created
 *  
 **/
public with sharing class ParticipantRankingMatchScreen { 
    
    //Position to hold the participant data
    public Engagement__c participant {get; set;}
    public List<Account> relatedParty {get; set;}
    Public Engagement__c DummyObj=new Engagement__c();
    public Match__c match{get; set;}
    
    //Position to hold the list of position wrapper instance
    List<Position__c> positions;
    List<Position__c> originalPositions;
    List<List<PositionWrapper>> listOfListPosition;
    
    //These properties are for displaying results count message on Searched Result section
    //i.e. Showing 1 - 10 of 100 results
    public Integer resultsStartNumber{get;set;}
    public Integer resultsStopNumber{get;set;}
    public Integer totalResults{get;set;}
    public integer ListIndex = 0;
    public Integer pageNO = 1;
    public Date PositionEngagementStart{get;set;}
    public Date PositionEngagementEnd{get;set;}
    //Sort direction parameter
    public String sortDir {get; set;}
    
    //Variable to store Search result message
    public String searchResultMessage{get;set;}
    
    //Selected Program Options
    public List<String> selectProgramOptions {get; set;}
    public String selectProgramOption {get; set;}
    public List<String> selectInterestedCountries {get; set;}
    public String selectInterestedCountry {get; set;}
    public List<String> selectProgramCategories {get; set;}
    public String selectProgramCategory {get; set;}
    public List<String> selectlangLevels {get; set;}
    public String selectlangLevel {get; set;}
    public List<String> selectProgDurations {get; set;}
    public String selectProgDuration {get; set;}
    public List<String> selectPositionTypes {get; set;}
    public List<String> selectCompensationTypes {get; set;}
    public String selectPositionType {get; set;}
    public String selectCompensationType {get; set;}
    public List<String> selectAreas {get; set;}
    //public List<String>  selectCountriesInt{get; set;}
    public String selectCountry {get; set;}
    public String selectArea{get; set;}
    public List<String> selectCompTypes {get; set;}
    public String selectCompType{get;set;}
     public List<String> selectIntCountries {get; set;}
    public String selectCountries{get;set;}
    public String regLocation{get;set;}
    public Engagement__c getDummyObj() { return DummyObj; }
     public List<string> oppCountIntid;
    //Map Opportunity Wrapper
    Map<Integer, List<PositionWrapper>> mapPositionWrapper;
    public Map<Integer, List<PositionWrapper>> mapOfListPositionWrapper;
        
    //Set to hold the Existing Matches for paticipant
    Set<String> existingMatches;
    
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
    
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> programOptions {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
            //Describe Program options
            Schema.DescribeFieldResult F = Position__c.Intrax_Program_Options__c.getDescribe();
            
            //add picklist values
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            pickListOptions.add(new SelectOption('Business Internship', 'Business Internship'));
             pickListOptions.add(new SelectOption('Career Preparation Activity', 'Career Preparation Activity'));
            pickListOptions.add(new SelectOption('Hospitality Internship', 'Hospitality Internship'));
            pickListOptions.add(new SelectOption('Internship Abroad', 'Internship Abroad'));
            pickListOptions.add(new SelectOption('Internship Group', 'Internship Group'));
            pickListOptions.add(new SelectOption('Internship - J1', 'Internship - J1'));

            pickListOptions.add(new SelectOption('ProWorld Internships', 'ProWorld Internships'));
            pickListOptions.add(new SelectOption('Practical Training', 'Practical Training'));
            pickListOptions.add(new SelectOption('Summer Entrepreneurship', 'Summer Entrepreneurship'));
            pickListOptions.add(new SelectOption('WEST', 'WEST'));
            
            return pickListOptions;  
            
             /* List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Intrax_Program_Options__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;*/
            
        }
    }
    //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> lstFuncAreas {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
           Schema.DescribeFieldResult fieldResult = Position__c.Functional_Areas__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
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
            pickListOptions.add(new SelectOption('Paid', 'Paid'));
            pickListOptions.add(new SelectOption('Stipend', 'Stipend'));
            pickListOptions.add(new SelectOption('Unpaid', 'Unpaid'));
                       
            return pickListOptions;
        }
    }
     //Get Position Program Picklist Options in Custom picklist
    public List<SelectOption> PositionType {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
                       
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Position_Types__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
             {
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
             }
            
            
            return pickListOptions;
        }
    }
    public List<SelectOption> CompensationType {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
            
                       
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Compensation_Type__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
             {
                 pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
             }
            
            
            return pickListOptions;
        }
    }
     
    //Get Position Program Picklist Options in Custom picklist
  public List<SelectOption> lstIntCountries {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Country__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
            return pickListOptions;
        }
    }
    public List<SelectOption> lstInterestedCountries {
        get {
            
            //Variable to hold the picklist data
            List<SelectOption> pickListOptions = new List<SelectOption>();
             pickListOptions.add(new SelectOption('--None--', '--None--'));
            //Describe Program options
            Schema.DescribeFieldResult fieldResult = Position__c.Countries_of_Interest__c.getDescribe();
            
            for(Schema.PicklistEntry val  :  fieldResult.getPicklistValues() )
            {
              pickListOptions.add(new SelectOption(val.getValue(),val.getLabel()));
         
            }
            
            
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
    //Constructor
    public ParticipantRankingMatchScreen(ApexPages.StandardController controller) {
        
        try {
            
            //get standard controller instance
            participant = (Engagement__c)controller.getRecord();
             match = new Match__c(Engagement__c = participant.Id);
            selectProgramOptions = new List<String>();
            PositionEngagementStart=DummyObj.Engagement_Start__c;            
            PositionEngagementEnd=DummyObj.Engagement_End__c;
            selectlangLevels = new List<String>();
            selectAreas = new List<String>();
            //selectCountriesInt = new List<String>();
            selectPositionTypes = new List<String>();
            selectCompensationTypes = new List<String>();
            //Call inIt Method
            if(System.currentPageReference().getParameters().get('prog')=='Internship' || System.currentPageReference().getParameters().get('prog')=='Work Travel')
                initIntern();
           if (System.currentPageReference().getParameters().get('prog')=='Ayusa')
             initAyusa();
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
    }
    
    //Fetch participant details and get the appropriate position records
    public void initIntern() {
        
        //check if participant is not null
        if(participant != null) {
            
            //fetch the position record detail from data base
            participant = [Select e.Position_Types__c,e.Partner_Account__c , e.Personality_Independence__c ,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c,e.Name,e.Flexible_Dates__c,e.Flexible_Location__c, e.Location_of_Interest__c, e.Intrax_Program__c, e.Id, e.Functional_Areas__c,
             e.Engagement_Start__c,e.Live_With_Pets__c,e.Live_With_Smoker__c, e.Engagement_End__c, e.Countries_of_Interest__c, e.Compensation_Type__c, e.Account_Id__r.Citizenship__pc,e.Account_Id__r.Name,
             e.Account_Id__c, e.Account_Id__r.LastName,e.Intrax_Program_Category__c ,e.Intrax_Program_Options__c ,e.Interests_Top__c,e.Double_Placement_Indicated__c,(Select Position_Name__c, Participant_Id__c, Id, Engagement__c From Matches__r)  From Engagement__c e where Id =: participant.Id];
    
             System.debug('SOQLQuery-participant::::::::::'+participant); 
             //relatedParty = [select Id,accounttoid,opportunityid from Account where id=:participant.Partner_Account__r.Id]; 
         
           /* string strCountries ='';
            string[] StrList;
            if(participant.Countries_of_Interest__c!=null)
            {
            strCountries+=String.valueof(participant.Countries_of_Interest__c).replace(';',',');           
            StrList=strCountries.split(',');
            }*/
           
            //initialize set
            existingMatches = new Set<String>();
            if(participant.Matches__r != null && participant.Matches__r.size() > 0) {
                for(Match__c match : participant.Matches__r)
                    existingMatches.add(match.Position_Name__c);
            }
            
            //Build SOQl Query
            String SOQLQuery;
            boolean blnActive=false;
            PositionEngagementStart=DummyObj.Engagement_Start__c;
            PositionEngagementEnd=DummyObj.Engagement_End__c;
            
            //Check for the selected programs
        
                SOQLQuery = 'Select Id, Name, Host_Company_Id__c, Functional_Areas__c, Host_Company_Id__r.lastname,Program_Year__c,Host_Opportunity_Id__c,flexible_dates__c,  Regional_Location__c, Engagement_Start__c, Engagement_End__c, Compensation_Type__c, Skills_Required__c,'
                                + '  Position_Types__c, Intrax_Program__c, Intrax_Program_Options__c, Countries_of_interest__c,Intrax_program_category__c from Position__c where Intrax_Program__c = \'' + participant.Intrax_Program__c + '\''
                                + ' AND Status__c = \'Matching\'';
           
          
            
           if(selectProgramCategory != null && selectProgramCategory != '' && selectProgramCategory!='--None--') 
                {
                if(selectProgramCategory=='Hospitality & Tourism' && selectAreas!=null )
                  selectAreas.clear();
                if(selectProgramCategory!='Hospitality & Tourism' && selectPositionTypes!=null)
                  selectPositionTypes.clear();
                SOQLQuery = SOQLQuery + ' AND Intrax_Program_Category__c in (\'' + selectProgramCategory +'\')  ';
                System.debug('SOQLQuery-selectProgramCategory::::::::::'+SOQLQuery);
                }
             
            if(selectPositionTypes != null && selectPositionTypes.size()>0 && selectProgramCategory == 'Hospitality & Tourism')
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
                SOQLQuery = SOQLQuery + ' AND Position_Types__c  INCLUDES (' + slist + ') ' ;
                System.debug('SOQLQuery-selectPositionTypes::::::::::'+SOQLQuery);
               }         
               }
                if(selectCompensationTypes != null && selectCompensationTypes.size()>0 )
                {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectCompensationTypes.size();
                for(String s : selectCompensationTypes) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;                
                }         
               System.debug('selectCompensationTypes::::::::::'+selectCompensationTypes);
               System.debug('blnNoneExists::::::::::'+blnNoneExists);
               if(!blnNoneExists)
               {
                 for (String s: selectCompensationTypes) 
                 {
                     slist += '\'' + s + '\',';
                 }
                slist = slist.substring (0,slist.length() -1);
                SOQLQuery = SOQLQuery + ' AND Compensation_Type__c  IN (' + slist + ') ' ;
                System.debug('SOQLQuery-selectCompensationType::::::::::'+SOQLQuery);
               }         
               }
               
               
               
                /*   if(selectCompType != null && selectCompType!='' && selectCompType!='--None--')
                {
                selectCompTypes =new list<string>();                
                selectCompTypes.Add(selectCompType);            
                SOQLQuery = SOQLQuery + ' AND Compensation_Type__c  IN :selectCompTypes ';
                System.debug('SOQLQuery-selectCompTypes::::::::::'+SOQLQuery);
                } 
           */ 
               
            if(selectAreas != null && selectAreas.size()>0 && selectProgramCategory != 'Hospitality & Tourism')
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
                    SOQLQuery = SOQLQuery + ' AND Functional_Areas__c  INCLUDES (' + slist + ') ' ;
                    System.debug('SOQLQuery-selectAreas::::::::::'+SOQLQuery);
                   }         
               }
               if(selectIntCountries != null && selectIntCountries.size()>0)
                {
                Integer DelNone;
                System.debug('selectIntCountries::::::::::'+selectIntCountries);
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
                SOQLQuery = SOQLQuery + 'AND Position__c.country__c  IN :selectIntCountries ';
                System.debug('SOQLQuery-selectIntCountries::::::::::'+SOQLQuery);
           }         
                }
            if(selectInterestedCountries != null && selectInterestedCountries.size()>0)
                {
                Integer DelNone;
                System.debug('selectInterestedCountries::::::::::'+selectInterestedCountries);
                boolean blnNoneExists=false;  
                integer len=0;
                len = selectInterestedCountries.size();
                for(String s : selectInterestedCountries) 
                {
                  if(len==1 && s.equals('--None--'))
                     blnNoneExists = true;
                }
         
           System.debug('selectInterestedCountries::::::::::'+selectInterestedCountries);
           System.debug('blnNoneExists::::::::::'+blnNoneExists);
           if(!blnNoneExists)
           {
                SOQLQuery = SOQLQuery + 'AND Position__c.Countries_of_Interest__c  IN :selectInterestedCountries ';
                System.debug('SOQLQuery-selectInterestedCountries::::::::::'+SOQLQuery);
           }         
                }
            if(PositionEngagementStart != null || PositionEngagementEnd!=null || (PositionEngagementStart != null && PositionEngagementEnd!=null) )
                 {
                  if(PositionEngagementStart != null && PositionEngagementEnd==null)
                  {
                  SOQLQuery = SOQLQuery + ' AND Engagement_Start__c >=: PositionEngagementStart';
                  System.debug('SOQLQuery-PositionEngagementStart::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart == null && PositionEngagementEnd!=null)
                  {
                  Date todaydate = System.today();
                  SOQLQuery = SOQLQuery + ' AND Engagement_Start__c >=:todaydate and Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart!= null && PositionEngagementEnd!=null && PositionEngagementStart<=PositionEngagementEnd)
                  {
                  SOQLQuery = SOQLQuery + ' AND Engagement_Start__c >=: PositionEngagementStart and Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementStart PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  System.debug('PositionEngagementStart::::::::::'+PositionEngagementStart); 
                  System.debug('PositionEngagementEnd::::::::::'+PositionEngagementEnd); 
                  }
        
            if(regLocation!=null && regLocation!='') 
                {
                regLocation=String.escapeSingleQuotes(regLocation);
                SOQLQuery = SOQLQuery + ' AND Regional_Location__c like \'%' + regLocation + '%\'  ';
                System.debug('SOQLQuery-regLocation::::::::::'+SOQLQuery);
                }  
          
                  
               
                System.debug('SOQLQuery::::::::::'+SOQLQuery);
                positions = Database.query(SOQLQuery);
                originalPositions = positions;
            }
            
            //Check for the opportunities size
            if(positions != null && positions.size() > 0) {
            
                //Query object
                List<wwwIntraxincComMatchRanking.query> queries = new List<wwwIntraxincComMatchRanking.query>();
                wwwIntraxincComMatchRanking.query query = new wwwIntraxincComMatchRanking.query();
                query.queryString = 'sort by functional areas';
                queries.add(query);
                
                //Call Ranking webservice
                wwwIntraxincComMatchRanking.RankingServicePort rankingServicePort = new wwwIntraxincComMatchRanking.RankingServicePort();
                System.debug(rankingServicePort);
                
                wwwIntraxincComMatchRanking.resultSet resultSet = rankingServicePort.matchRanking('internship', RankingMatchUtility.prepareEntityProps(participant), 
                                                    RankingMatchUtility.preparePositionList(positions), queries);
                
                //Parse response
                mapOfListPositionWrapper = RankingMatchUtility.parseResponseForPositions(resultSet);
                
                //Set default sorting parameter
                sortDir = 'DESC';
            } else {
                mapOfListPositionWrapper = new Map<Integer, List<PositionWrapper>>();
            }
            
            //Sort Result by default
            sortByRanking(mapOfListPositionWrapper);
        }
     public void initAyusa() {
        
        //check if participant is not null
        if(participant != null) {
            
            //fetch the position record detail from data base
            participant = [Select e.Position_Types__c,e.Partner_Account__c , e.Personality_Independence__c ,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c,e.Name,e.Flexible_Dates__c,e.Flexible_Location__c, e.Location_of_Interest__c, e.Intrax_Program__c, e.Id, e.Functional_Areas__c,
             e.Engagement_Start__c,e.Live_With_Pets__c,e.Live_With_Smoker__c, e.Engagement_End__c, e.Countries_of_Interest__c, e.Compensation_Type__c, e.Account_Id__r.Citizenship__pc,e.Account_Id__r.Name,e.Intrax_program_category__c,e.Intrax_program_options__c,
             e.Account_Id__c, e.Account_Id__r.LastName,e.Interests_Top__c,e.Double_Placement_Indicated__c,(Select Position_Name__c, Participant_Id__c, Id, Engagement__c From Matches__r)  From Engagement__c e where Id =: participant.Id];
    
             System.debug('SOQLQuery-participant::::::::::'+participant); 
             //relatedParty = [select Id,accounttoid,opportunityid from Account where id=:participant.Partner_Account__r.Id]; 
         
           /* string strCountries ='';
            string[] StrList;
            if(participant.Countries_of_Interest__c!=null)
            {
            strCountries+=String.valueof(participant.Countries_of_Interest__c).replace(';',',');           
            StrList=strCountries.split(',');
            }*/
           
            //initialize set
            existingMatches = new Set<String>();
            if(participant.Matches__r != null && participant.Matches__r.size() > 0) {
                for(Match__c match : participant.Matches__r)
                    existingMatches.add(match.Position_Name__c);
            }
            
            //Build SOQl Query
            String SOQLQuery;
            boolean blnActive=false;
            PositionEngagementStart=DummyObj.Engagement_Start__c;
            PositionEngagementEnd=DummyObj.Engagement_End__c;
            
            //Check for the selected programs
        
                SOQLQuery = 'Select Id, Name, Host_Company_Id__c, Functional_Areas__c, Host_Company_Id__r.lastname,Program_Year__c,Host_Opportunity_Id__c,flexible_dates__c,  Regional_Location__c, Engagement_Start__c, Engagement_End__c, Compensation_Type__c, Skills_Required__c,'
                                + '  Position_Types__c,Intrax_Program_Category__c , Intrax_Program__c, Intrax_Program_Options__c, Countries_of_interest__c from Position__c where Intrax_Program__c = \'' + participant.Intrax_Program__c + '\''
                                + ' AND Status__c = \'Matching\'';
           
          
            
           if(selectProgramOption != null && selectProgramOption != '' && selectProgramOption!='--None--') 
                {
                if(selectProgramOption!='Business Internship' && selectProgramOption!='Summer Entrepreneurship' && selectProgramOption!='WEST' && selectProgramOption!='Practical Training' && selectAreas!=null )
                  selectAreas.clear();
                if(selectProgramOption!='Hospitality Internship' && selectPositionTypes!=null)
                  selectPositionTypes.clear();
                SOQLQuery = SOQLQuery + ' AND Intrax_Program_Options__c INCLUDES (\'' + selectProgramOption +'\') ';
                System.debug('SOQLQuery-selectProgramOption::::::::::'+SOQLQuery);
                }
             if(selectlangLevel != null &&  selectlangLevel != '' && selectlangLevel!='--None--')
                {
                selectlangLevels =new list<string>();
                for (Integer i = Integer.ValueOf(selectlangLevel); i <= 10; i++)
                  {
                    selectlangLevels.Add(String.ValueOf(i));
                  }                              
                System.debug('selectlangLevels::::::::::'+selectlangLevels);
                SOQLQuery = SOQLQuery + ' AND Language_Level__c  IN :selectlangLevels ';
                System.debug('SOQLQuery-selectlangLevels::::::::::'+SOQLQuery);
                }
            
            if(selectPositionTypes != null && selectPositionTypes.size()>0 && selectProgramOption == 'Hospitality Internship')
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
                SOQLQuery = SOQLQuery + ' AND Position_Types__c  INCLUDES (' + slist + ') ' ;
                System.debug('SOQLQuery-selectPositionTypes::::::::::'+SOQLQuery);
               }         
               }
            if(selectAreas != null && selectAreas.size()>0 && (selectProgramOption == 'Business Internship'|| selectProgramOption!='Summer Entrepreneurship' || selectProgramOption!='WEST' || selectProgramOption!='Practical Training'))
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
                    SOQLQuery = SOQLQuery + ' AND Functional_Areas__c  INCLUDES (' + slist + ') ' ;
                    System.debug('SOQLQuery-selectAreas::::::::::'+SOQLQuery);
                   }         
               }
               if(selectIntCountries != null && selectIntCountries.size()>0)
                {
                Integer DelNone;
                System.debug('selectIntCountries::::::::::'+selectIntCountries);
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
                SOQLQuery = SOQLQuery + 'AND Position__c.country__c  IN :selectIntCountries ';
                System.debug('SOQLQuery-selectIntCountries::::::::::'+SOQLQuery);
           }         
                }
            if(PositionEngagementStart != null || PositionEngagementEnd!=null || (PositionEngagementStart != null && PositionEngagementEnd!=null) )
                 {
                  if(PositionEngagementStart != null && PositionEngagementEnd==null)
                  {
                  SOQLQuery = SOQLQuery + ' AND Engagement_Start__c >=: PositionEngagementStart';
                  System.debug('SOQLQuery-PositionEngagementStart::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart == null && PositionEngagementEnd!=null)
                  {
                  Date todaydate = System.today();
                  SOQLQuery = SOQLQuery + ' AND Engagement_Start__c >=:todaydate and Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  else if (PositionEngagementStart!= null && PositionEngagementEnd!=null && PositionEngagementStart<=PositionEngagementEnd)
                  {
                  SOQLQuery = SOQLQuery + ' AND Engagement_Start__c >=: PositionEngagementStart and Engagement_End__c <=: PositionEngagementEnd ';
                  System.debug('SOQLQuery-PositionEngagementStart PositionEngagementEnd::::::::::'+SOQLQuery);
                  }
                  System.debug('PositionEngagementStart::::::::::'+PositionEngagementStart); 
                  System.debug('PositionEngagementEnd::::::::::'+PositionEngagementEnd); 
                  }
            if(selectCompType != null && selectCompType!='' && selectCompType!='--None--')
                {
                selectCompTypes =new list<string>();                
                selectCompTypes.Add(selectCompType);            
                SOQLQuery = SOQLQuery + ' AND Compensation_Type__c  IN :selectCompTypes ';
                System.debug('SOQLQuery-selectCompTypes::::::::::'+SOQLQuery);
                } 
            
            if(regLocation!=null && regLocation!='') 
                {
                regLocation=String.escapeSingleQuotes(regLocation);
                SOQLQuery = SOQLQuery + ' AND Regional_Location__c like \'%' + regLocation + '%\'  ';
                System.debug('SOQLQuery-regLocation::::::::::'+SOQLQuery);
                }  
          
                  
               
                System.debug('SOQLQuery::::::::::'+SOQLQuery);
                positions = Database.query(SOQLQuery);
                originalPositions = positions;
            }
            
            //Check for the opportunities size
            if(positions != null && positions.size() > 0) {
            
                //Query object
                List<wwwIntraxincComMatchRanking.query> queries = new List<wwwIntraxincComMatchRanking.query>();
                wwwIntraxincComMatchRanking.query query = new wwwIntraxincComMatchRanking.query();
                query.queryString = 'sort by functional areas';
                queries.add(query);
                
                //Call Ranking webservice
                wwwIntraxincComMatchRanking.RankingServicePort rankingServicePort = new wwwIntraxincComMatchRanking.RankingServicePort();
                System.debug(rankingServicePort);
                
                wwwIntraxincComMatchRanking.resultSet resultSet = rankingServicePort.matchRanking('internship', RankingMatchUtility.prepareEntityProps(participant), 
                                                    RankingMatchUtility.preparePositionList(positions), queries);
                
                //Parse response
                mapOfListPositionWrapper = RankingMatchUtility.parseResponseForPositions(resultSet);
                
                //Set default sorting parameter
                sortDir = 'DESC';
            } else {
                mapOfListPositionWrapper = new Map<Integer, List<PositionWrapper>>();
            }
            
            //Sort Result by default
            sortByRanking(mapOfListPositionWrapper);
        }
    
    
     //Getter method to diplay the Position record on page
    public List<PositionWrapper> getPossibleMatchesList() {
        
        //return the records in current context
        if(listOfListPosition != null && listOfListPosition.size() > 0 && listOfListPosition[0] != null && listOfListPosition[0].size() > 0 && listOfListPosition.size() >= ListIndex+1)
            return listOfListPosition[ListIndex];
        else
            return new List<PositionWrapper>();
    }
    
    //This method is to perform the save operation
    public PageReference save() {
        
        try {
            //Create a new list of Matched record
            List<Match__c> matches = new List<Match__c>();
            Engagement__c eng;
            //loop through the wrapper list and create matches for selected participants
            for(List<PositionWrapper> listWrapper : listOfListPosition) {
                for(PositionWrapper pWrapper : listWrapper) {
                    if(pWrapper.selected)
                    {
                    if(participant!=null)
                    {
                        if(pWrapper.position.Intrax_Program__c =='Ayusa') 
                        {
                             string strName= participant.Account_Id__r.LastName + ' - '+ pWrapper.position.Host_Company_Id__r.LastName + ' - ' + 'AY'+ pWrapper.position.Program_Year__c ;                      
                            matches.add(new Match__c(Name = strName, Participant_Id__c = participant.Account_Id__c, Position_Name__c = pWrapper.position.Id, Rank_at_Match__c = pWrapper.ranking, Similarity_at_Match__c = pWrapper.sim,engagement__c=participant.Id,RecordTypeId=Constants.MAT_AYUSA ));
                        }
                        else if(pWrapper.position.Intrax_Program__c =='Internship') 
                            matches.add(new Match__c(Name = participant.Account_Id__r.Name, Participant_Id__c = participant.Account_Id__c, Position_Name__c = pWrapper.position.Id, Rank_at_Match__c = pWrapper.ranking, Similarity_at_Match__c = pWrapper.sim,engagement__c=participant.Id,RecordTypeId=Constants.MAT_INTERNSHIP));
                    }}
                }
            }
            
            //Check for the matches
            if(matches.size() > 0)
                insert matches;
            return new PageReference('/' + participant.Id);
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
            resultsStartNumber = resultsStartNumber - Constants.PAGE_SIZE;
            resultsStopNumber = resultsStopNumber  - listOfListPosition[ListIndex].size();
        }
        
        if(ListIndex > 0)
            ListIndex--;
    }
            
    //Increments the ListIndex for paging
    public void getNext() {
        
        pageNO  = pageNO + 1;
        if(totalResults > resultsStopNumber) {
            resultsStartNumber = resultsStopNumber + 1;
            resultsStopNumber = resultsStopNumber  + listOfListPosition[ListIndex + 1].size();
        }
 
        if(ListIndex < listOfListPosition.size()-1 )
            ListIndex++;
    }
    
    //SortByRanking
    public void sortByRanking(Map<Integer, List<PositionWrapper>> mapOfListPositionWrapper) {
        
        //Create a list of Rank
        List<Integer> rankingList = new List<Integer>(mapOfListPositionWrapper.keySet());
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
        listOfListPosition = new List<List<PositionWrapper>>();
        listOfListPosition.add(new List<PositionWrapper>());
        
        //Set the variable for default
        ListIndex = 0;
        resultsStartNumber = 0;
        resultsStopNumber = 0;
        totalResults = 0;
        
        //loop through the list
        for(Integer rank : orderedRankingList) {
            
            //Loop through the results
            for(PositionWrapper posWrapper : mapOfListPositionWrapper.get(rank)) {
                
                //Add the opportunity record in list of list Opportunity wrapper
                //add only Page Size records in a list
                if(listOfListPosition[listOfListPosition.size() - 1].size() == Constants.PAGE_SIZE)
                    listOfListPosition.add(new List<PositionWrapper>());
                    
                //avoid if matches are already then, then do not include
               if(!existingMatches.contains(posWrapper.position.Id)) {
                      
                    //add opportunity record in the list to be displayed on the page
                    listOfListPosition[listOfListPosition.size() - 1].add(posWrapper);
                    
                    //increase the total counter
                    totalResults = totalResults + 1;
                }
            }
        }
        
        //Check if total counter is greater then zero then set the other variables values
        if(totalResults > 0) {
            
            //Show the search results from 1st record
            resultsStartNumber = 1;
            if(totalResults > Constants.PAGE_SIZE)
                resultsStopNumber = Constants.PAGE_SIZE;
            else
                resultsStopNumber = totalResults;
            searchResultMessage = String.valueOf(totalResults) + ' record(s) found.';
        
        } else
          searchResultMessage = 'No record(s) found.';
    }
    
    //Method to sort result
    public void sortResults() {
        
        //Sort result
        sortByRanking(mapOfListPositionWrapper);
    }
}