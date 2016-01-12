global class ShareAssessmentBatch implements Database.Batchable<sObject>{
    public String SOQLQuery=null ;
     public String SOQLQuery1=null ;
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
   
    global Database.Querylocator start(Database.BatchableContext BC ){        
        DateTime PrevDate;
        DateTime TodayDate = system.now();
        Decimal BatchLimit;
        List<Assessment__c> lstAss=  new list<Assessment__c>();
        List<Assessment__Share> lstAssShare=new list<Assessment__Share>();
             
        SOQLQuery =  'Select a.Status__c,a.Name, a.Month_Number__c,a.Record_Type_Group__c,a.Assessment_Date__c,a.Host_Name__c, a.Match_Name__c, a.Participant_Name__c, a.Position_Name__c, a.Engagement__c, a.Count_Down__c, a.Id, a.ManualShareExists__c From Assessment__c a where a.RecordTypeId != \'012a0000001NabzAAC\' and a.ManualShareExists__c=false Order By a.CreatedDate ASC LIMIT 50';
               //  SOQLQuery = 'Select Month_Number__c,Record_Type_Group__c,Assessment_Date__c,Host_Name__c, Match_Name__c, Participant_Name__c, Position_Name__c, Engagement__c, Count_Down__c From Assessment__c Order By CreatedDate ASC LIMIT 50';   
           // lstAss = Database.Query(SOQLQuery); 
          /*  Set<Id> LstAssId = new Set<Id>();
            
            if(lstAss!=null && lstAss.size()>0)
            {
            	for(Assessment__c ass :lstAss)
            	LstAssId.add(ass.Id);
            }
            lstAssShare = [Select a.UserOrGroupId, a.RowCause, a.ParentId, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.AccessLevel From Assessment__Share a where a.RowCause='Manual' and a.ParentId not in :LstAssId];    
            Set<Id> lstAssShareId = new Set<Id>();
            if(lstAssShare!=null && lstAssShare.size()>0)
            {
            	for(Assessment__Share ass :lstAssShare)
            	lstAssShareId.add(ass.ParentId);
            }
            SOQLQuery1 = 'Select Month_Number__c,Record_Type_Group__c,Assessment_Date__c,Host_Name__c, Match_Name__c, Participant_Name__c, Position_Name__c, Engagement__c, Count_Down__c From Assessment__c where Id not in :lstAssShareId Order By CreatedDate ASC LIMIT 50';*/   
              
        return Database.getQueryLocator(SOQLQuery);         
         
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope ){
     
       lstAssessment = (List<Assessment__c>)scope;
       boolean returnflag;
       List<Assessment__c> AssToBeUpdated=new  List<Assessment__c>();
         system.debug('******lstAssessment ***********'+lstAssessment);
       if(lstAssessment!=null && lstAssessment.size()>0)
       {        
       for(Assessment__c ass : lstAssessment)
       {
       	system.debug('******ass ***********'+ass);
       	ass.ManualShareExists__c = True;
       	AssToBeUpdated.add(ass);
       		system.debug('******ass ***********'+ass);
       }
       	system.debug('******AssToBeUpdated ***********'+AssToBeUpdated);
       update AssToBeUpdated;
       }
          
     }          
      
    
    global void finish(Database.BatchableContext BC){
        
    }

}