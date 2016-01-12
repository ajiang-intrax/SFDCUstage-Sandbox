global class CreateAssessmentBatch implements Database.Batchable<sObject>{
	
    public String SOQLQuery=null ;
    public boolean isTest=False;
    public static  boolean FirstRun =false;
    public Match__c match{get; set;}
    public Match__c confMatch{get; set;}
    public Account participantAccount{get; set;}
    public Account hostAccount{get; set;}
    public integer count{get;set;}
    public string StartMonth;
    public Integer StartMonthNumber;
    public List<Match__c> matchList;
    public List<Assessment__c> lstAssessment = new List<Assessment__c>();
    public List<Assessment__c> LstExistingMatchPTAssessment=new  List<Assessment__c>();
    public List<Assessment__c> LstExistingMatchHFAssessment=new  List<Assessment__c>();
    public List<Assessment__c> lstMatchAssessment = new List<Assessment__c>();
    global Database.Querylocator start(Database.BatchableContext BC ){        
        DateTime PrevDate;
        DateTime TodayDate = system.now();
        Decimal BatchLimit;
        System.debug('***TodayDate ********'+TodayDate);
        system.debug('******FirstRun ***********'+FirstRun);
        string AyusaRecordType=Constants.MAT_AYUSA;        
      
          JobSettings__c ObjJobSetting = JobSettings__c.getValues('CreateAssessmentBatch');
         if(ObjJobSetting==null)
         {
             JobSettings__c ObjAssessmentJob = new  JobSettings__c();
             ObjAssessmentJob.Name ='CreateAssessmentBatch';
             ObjAssessmentJob.BatchLimit__c = 1;
             insert ObjAssessmentJob;
              FirstRun = True; 
         }
         else 
         {
             BatchLimit = ObjJobSetting.BatchLimit__c;
         }
            
       if(FirstRun) 
       {
            SOQLQuery = 'Select m.sys_error_tag__c,m.Status__c,m.Name,m.MCAssExists__c, m.Start_Date__c, m.Position_Name__r.Name,m.Position_Name__r.Host_Company_Id__c, m.Position_Name__r.Id, m.Position_Name__c, m.Participant_Id__r.Type, m.Participant_Id__r.Name, m.Participant_Id__r.Id, ' +
        + ' m.Participant_Id__c, m.LastModifiedDate,m.Intrax_Program_Option__c,m.Id, m.Engagement__r.Program_Duration__c, m.Engagement__r.Type__c, m.Engagement__r.Intrax_Program__c,m.Engagement__r.Prog_Duration_Extended__c,m.Engagement__r.PDExtendedDate__c, m.Engagement__r.Engagement_End__c, m.Engagement__r.Engagement_Start__c, ' +
        + ' m.Engagement__r.Engagement_Country__c, m.Engagement__r.Name, m.Engagement__c, m.Check_Out_Date__c, m.Check_In_Date__c,  (Select Name, Month_Number__c, Host_Name__c, Match_Name__c, Participant_Name__c, ' +
        + ' Position_Name__c, Engagement__c, Assessment_Date__c, Program_End_Feeling__c, Time_Period__c, Count_Down__c From Match_Assessments__r) From Match__c m where m.Start_Date__c!=null and m.status__c=\'Confirmed\' and m.RecordTypeId=:AyusaRecordType and m.sys_error_tag__c=null and (m.MCAssExists__c=false or m.Engagement__r.Prog_Duration_Extended__c=true) and (m.Intrax_Program_Option__c =\'Ayusa High School;\' or m.Intrax_Program_Option__c =\'YES;\')  order by m.lastmodifiedDate asc limit 15';     
            }
       else
       {
       
         
        Integer integerValue = BatchLimit.intValue();
        SOQLQuery = 'Select m.sys_error_tag__c,m.Status__c,m.Name,m.MCAssExists__c, m.Start_Date__c, m.Position_Name__r.Name,m.Position_Name__r.Host_Company_Id__c, m.Position_Name__r.Id, m.Position_Name__c, m.Participant_Id__r.Type, m.Participant_Id__r.Name, m.Participant_Id__r.Id, ' +
        + ' m.Participant_Id__c,m.LastModifiedDate,m.Intrax_Program_Option__c, m.Id, m.Engagement__r.Program_Duration__c, m.Engagement__r.Type__c, m.Engagement__r.Intrax_Program__c, m.Engagement__r.Engagement_End__c,m.Engagement__r.PDExtendedDate__c,m.Engagement__r.Prog_Duration_Extended__c, m.Engagement__r.Engagement_Start__c, ' +
        + ' m.Engagement__r.Engagement_Country__c, m.Engagement__r.Name, m.Engagement__c, m.Check_Out_Date__c, m.Check_In_Date__c,  (Select Name, Month_Number__c, Host_Name__c, Match_Name__c, Participant_Name__c, ' +
        + ' Position_Name__c, Engagement__c, Assessment_Date__c, Program_End_Feeling__c, Time_Period__c, Count_Down__c From Match_Assessments__r) From Match__c m where m.Start_Date__c!=null and m.status__c=\'Confirmed\' and m.sys_error_tag__c=null and m.RecordTypeId=:AyusaRecordType and (m.MCAssExists__c=false or m.Engagement__r.Prog_Duration_Extended__c=true) and (m.Intrax_Program_Option__c =\'Ayusa High School;\' or m.Intrax_Program_Option__c =\'YES;\') order by m.lastmodifiedDate asc limit :integerValue';
 
      system.debug('*****SOQLQuery*****'+SOQLQuery);
       }           
      system.debug('******SOQLQuery ***********'+SOQLQuery);
        return Database.getQueryLocator(SOQLQuery);         
         
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope ){
       List<Match__c> errorMatches = new List<Match__c>();
       matchList = (List<Match__c>)scope;
       boolean returnflag;
         system.debug('******matchList ***********'+matchList);
       if(matchList!=null && matchList.size()>0)
       {        
       
        AssessmentBulkCreateController abc=new AssessmentBulkCreateController();
        abc.BulkCreate(matchList);
       }
           
     }          
      
    
    global void finish(Database.BatchableContext BC){
        
    }

}