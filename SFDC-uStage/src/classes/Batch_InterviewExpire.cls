global class Batch_InterviewExpire implements Database.Batchable<sObject>, Schedulable {

public Double Currentoffset;
public Double EndDateoffset;
    
  //start method to create the initial query and retrieve the appropriate records
  global Database.QueryLocator start(Database.BatchableContext bc) {

    //check if running from test method then only execute one batch with the latest data
      return Database.getQueryLocator([Select Name,id,Status__c,Interview_End_Date__c,createdby.Timezonesidkey from selection__c where Interview_end_date__c != null and Status__c = 'Active' order by CreatedDate asc]);
  }
  
  //execute method
  global void execute(Database.BatchableContext BC, List<SObject> scope) {
    
    //Loop through the current list Selections
    List<Selection__c> tempslection= new List<Selection__c>();

    for(Selection__c selection : (List<Selection__c>)scope) {
    
    Timezone Tz = Timezone.getTimeZone(selection.createdby.Timezonesidkey);
    Currentoffset=Tz.getOffset(DateTime.now()) / (1000 *3600 *24.0);
    
    EndDateoffset=Tz.getOffset(selection.Interview_End_Date__c) / (1000 *3600 *24.0);
    
    system.debug('debug:::InterviewEndDate=='+selection.Name+'=='+selection.Interview_End_Date__c);
    
    
    DateTime CurrentDateTime= system.Now()+Currentoffset;
    DateTime EndDateTime= selection.Interview_End_Date__c+EndDateoffset;
    
    system.debug('debug:::CurrentDateTime=='+CurrentDateTime);
    system.debug('debug:::EndDateTime=='+EndDateTime);
   
      if(EndDateTime <= CurrentDateTime) {
        system.debug('debug::InsideIf=='+ selection.Name);
        selection.Status__c='InActive';
        tempslection.add(selection);
        Currentoffset=0.0;
        EndDateoffset=0.0;
      }
      system.debug('debug::'+tempslection);
    }
    
    //Check for the record size
    if(tempslection.size() > 0) 
      update tempslection;
      system.debug('debug::'+tempslection);
  }
  
  //method for the post processing of the records
  global void finish(Database.BatchableContext BC){
    Batch_InterviewExpire.startJob(System.now());
  }
    
   global void execute(SchedulableContext sc){
    	Batch_InterviewExpire batch = new Batch_InterviewExpire();
		Database.executeBatch(batch, 50);
    }  
    
 public static void startJob(DateTime sysTime){
    	DateTime nextRunTime= sysTime;
     	integer mins=nextRunTime.minute();
        integer hr=nextRunTime.hour();
        integer cdate=nextRunTime.day();
        integer month=nextRunTime.month();
        integer year=nextRunTime.year();   
        sysTime = sysTime.addHours(2);
        //sysTime = sysTime.addMinutes(2);
        
        String chronJobId = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug('chronJobId:'+chronJobId);
        Batch_InterviewExpire matchSched = new Batch_InterviewExpire();
        //if(!Test.isRunningTest())
        System.schedule('Schduled Interview Request Expire'+year+'-'+month+'-'+cdate+'-'+hr+'-'+mins, chronJobId, matchSched);
     
     List<CronTrigger> ctList = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE NextFireTime=null];
     System.debug('CTLIST:'+ctList);
     for(CronTrigger ct: ctList){
         system.abortJob(ct.Id);
     }
        
    }   
    
    
}