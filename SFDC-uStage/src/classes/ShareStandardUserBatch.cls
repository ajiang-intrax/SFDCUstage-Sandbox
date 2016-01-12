global class ShareStandardUserBatch implements Database.Batchable<sObject>,DataBase.Stateful{
    public String SOQLQuery=null ;
    public List<User> lstStandardUser;
  public List<User> lstUserToBeUpdated=new  List<User>();
    public static  boolean FirstRun =false;
    // public boolean NoShareBatch =false;
    global Database.Querylocator start(Database.BatchableContext BC ){        
        Decimal BatchLimit;
        List<User> lstUser=  new list<User>();
       
        JobSettings__c ObjJobSetting = JobSettings__c.getValues('ShareStandardUserBatch');
         if(ObjJobSetting==null)
         {
             JobSettings__c ObjShareStdUsersJob = new  JobSettings__c();
             ObjShareStdUsersJob.Name ='ShareStandardUserBatch';
             ObjShareStdUsersJob.BatchLimit__c = 1;
             insert ObjShareStdUsersJob;
              FirstRun = True; 
         }
         else 
         {
             BatchLimit = ObjJobSetting.BatchLimit__c;
         }          
          
       if(FirstRun) 
       {        
        SOQLQuery =  'Select u.Type__c,u.Name, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id, u.ManualShareExists__c From User u where u.Type__c=\'Partner\' and u.ManualShareExists__c=false and u.Profile.Name=\'Intrax Standard User\' and u.IsActive=true and u.Intrax_Id__c!=null order by u.lastmodifiedDate desc limit 1';
       }
       else
       {     
        Integer integerValue = BatchLimit.intValue();
        SOQLQuery =  'Select u.Type__c,u.Name, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id, u.ManualShareExists__c From User u where u.Type__c=\'Partner\' and u.ManualShareExists__c=false and u.Profile.Name=\'Intrax Standard User\' and u.IsActive=true and u.Intrax_Id__c!=null order by u.lastmodifiedDate desc limit :integerValue';
      system.debug('*****SOQLQuery*****'+SOQLQuery);
       }           
      system.debug('******SOQLQuery ***********'+SOQLQuery);
        return Database.getQueryLocator(SOQLQuery);         
       
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope ){
     
       lstStandardUser = (List<User>)scope;
       boolean returnflag;
       
       system.debug('******bc ***********'+bc);
         system.debug('******lstStandardUser ***********'+lstStandardUser);
       if(lstStandardUser!=null && lstStandardUser.size()>0)
       {        
       for(User usr : lstStandardUser)
       {
            usr.ManualShareExists__c = True;
                lstUserToBeUpdated.add(usr);
        }
         system.debug('******lstUserToBeUpdated-e ***********'+lstUserToBeUpdated);
        }
       
      
          
    }       
      
    
    global void finish(Database.BatchableContext BC){
    	system.debug('******lstUserToBeUpdated-f ***********'+lstUserToBeUpdated);
       if(lstUserToBeUpdated.size()>0) 
       update lstUserToBeUpdated;
        
    }

}