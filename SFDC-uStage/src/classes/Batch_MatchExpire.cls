global class Batch_MatchExpire implements Database.Batchable<sObject>, Schedulable {
    
public Double Currentoffset;
public Double MatchExpireoffset;
List<Portal_Content__c> pContentListPT = new List<Portal_Content__c>();
List<Portal_Content__c> pContentListHF = new List<Portal_Content__c>();

  //start method to create the initial query and retrieve the appropriate records
  global Database.QueryLocator start(Database.BatchableContext bc) { 
      return Database.getQueryLocator([Select id,Status__c,Name,Request_Expiration__c,Createdby.Timezonesidkey, Intrax_Program__c,Engagement__c, 
                                       Engagement__r.Partner_Account__c, Intrax_Program_Option__c, CreatedById, Participant_Id__c, Position_Name__c 
                                       from match__c where Intrax_Program__c='AuPairCare' AND status__c = 'Requested' AND Match_Type__c != null 
                                       AND Match_Type__c != 'Extension' AND Request_Expiration__c != null and Request_Expiration__c <= :system.now() 
                                       order by CreatedDate asc]);
  } 
  
  //execute method
  global void execute(Database.BatchableContext BC, List<SObject> scope) {
    
    pContentListHF = getPCList('Match Request Expiration HF','Host');
    pContentListPT = getPCList('Match Request Expiration PT','Participant');
    //Loop through the current list Selections
    List<match__c> tempmatch= new List<match__c>();
    
    for(match__c match : (List<match__c>)scope) {
       
    Timezone Tz = Timezone.getTimeZone(match.createdby.Timezonesidkey);

    Currentoffset=Tz.getOffset(DateTime.now()) / (1000 *3600 *24.0);
    MatchExpireoffset=Tz.getOffset(match.Request_Expiration__c) / (1000 *3600 *24.0);
    
    system.debug('debug:::MatchExpireDate=='+match.Name+'=='+match.Request_Expiration__c);
    
    
    DateTime CurrentDateTime= system.Now()+Currentoffset;
    DateTime MatchExpireTime= match.Request_Expiration__c+MatchExpireoffset;
    
    system.debug('debug:::CurrentDateTime=='+CurrentDateTime);
    system.debug('debug:::MatchExpireTime=='+MatchExpireTime);
       
       If(MatchExpireTime <= CurrentDateTime){
        match.Status__c='Withdrawn';
        if(pContentListPT!=null && pContentListPT.size()>0){
        	//call notification generator method to create notification.
            //createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                     
            Notification_Generator.createAPCNotificationFromCS(match,pContentListPT[0].Notification_Type__c,pContentListPT[0].Short_Summary__c,pContentListPT[0].Subject__c,pContentListPT[0].Body__c, pContentListPT[0].Dynamic_Content__c, pContentListPT[0].Urgency__c,pContentListPT[0].User_Type__c, pContentListPT[0].Header_Image__c);
        }
        if(pContentListHF!=null && pContentListHF.size()>0){
            //call notification generator method to create notification.
            //createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, boolean isHeader){                     
            Notification_Generator.createAPCNotificationFromCS(match,pContentListHF[0].Notification_Type__c,pContentListHF[0].Short_Summary__c,pContentListHF[0].Subject__c,pContentListHF[0].Body__c, pContentListHF[0].Dynamic_Content__c, pContentListHF[0].Urgency__c,pContentListHF[0].User_Type__c, pContentListHF[0].Header_Image__c);
        }
        tempmatch.add(match);
        system.debug('debug::'+tempmatch);
        }
    }
    
    //Check for the record size
    if(tempmatch.size() > 0) 
      update tempmatch;
      
      system.debug('debug::'+tempmatch);
  }
  
  //method for the post processing of the records
   global void finish(Database.BatchableContext BC){
    Batch_MatchExpire.startJob(System.now());
  }
    
   global void execute(SchedulableContext sc){
    	Batch_MatchExpire batch = new Batch_MatchExpire();
		Database.executeBatch(batch, 50);
    }  
    
    public static void startJob(DateTime sysTime){
        DateTime nextRunTime= sysTime;
     	integer mins=nextRunTime.minute();
        integer hr=nextRunTime.hour();
        integer cdate=nextRunTime.day();
        integer month=nextRunTime.month();
        integer year=nextRunTime.year();   
        sysTime = sysTime.addHours(1);
        //sysTime = sysTime.addMinutes(2);
        
        String chronJobId = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug('chronJobId:'+chronJobId);
        Batch_MatchExpire matchSched = new Batch_MatchExpire();
        
        //if(!Test.isRunningTest())
        System.schedule('Schduled Match Request Expire'+year+'-'+month+'-'+cdate+'-'+hr+'-'+mins, chronJobId, matchSched);
        
        List<CronTrigger> ctList = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE NextFireTime=null];
        System.debug('CTLIST:'+ctList);
        for(CronTrigger ct: ctList){
            system.abortJob(ct.Id);
        }
    }
    
    //JOSE B-02918 Add new notifications
    global List<Portal_Content__c> getPCList(string sKey, string sUserType){
        List<Portal_Content__c> PortalContentList = [SELECT Id,Name,Type__c,Object__c,Record_Type_Name__c,Status__c,key__c,RegEx__c,Notification_Type__c,
                                                     Short_Summary__c,Subject__c,Body__c,Dynamic_Content__c,Urgency__c,User_Type__c,Header_Image__c FROM Portal_Content__c 
                                                     WHERE Type__c='Notification' AND Key__c=:sKey AND User_Type__c=:sUserType LIMIT 1];
        
        if(PortalContentList!=null && PortalContentList.size()>0)
            return PortalContentList;
        else
            return null;
    }  
   
}