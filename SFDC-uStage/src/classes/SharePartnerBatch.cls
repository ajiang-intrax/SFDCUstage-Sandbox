global class SharePartnerBatch implements Database.Batchable<sObject>,DataBase.Stateful{
    public String SOQLQuery=null ;
    public List<User> lstPartnerUser;
    List<Contact> ConToBeUpdated=new  List<Contact>();
    public static  boolean FirstRun =false;
    // public boolean NoShareBatch =false;
    global Database.Querylocator start(Database.BatchableContext BC ){        
        Decimal BatchLimit;
        List<User> lstUser=  new list<User>();
       
        JobSettings__c ObjJobSetting = JobSettings__c.getValues('SharePartnerBatch');
         if(ObjJobSetting==null)
         {
             JobSettings__c ObjSharePartnerJob = new  JobSettings__c();
             ObjSharePartnerJob.Name ='SharePartnerBatch';
             ObjSharePartnerJob.BatchLimit__c = 1;
             insert ObjSharePartnerJob;
              FirstRun = True; 
         }
         else 
         {
             BatchLimit = ObjJobSetting.BatchLimit__c;
         }
          
       if(FirstRun) 
       {        
        SOQLQuery =  'Select u.Type__c, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id, u.Contact.ManualPartnerShareExists__c, u.ContactId From User u where u.Type__c=\'Partner\' and u.Contact.ManualPartnerShareExists__c=false and u.Profile.Name=\'OCPM Agent Portal\' and u.IsActive=true and u.Intrax_Id__c!=null order by u.lastmodifiedDate asc limit 1';
       }
       else
       {     
        Integer integerValue = BatchLimit.intValue();
        SOQLQuery =  'Select u.Type__c, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id, u.Contact.ManualPartnerShareExists__c, u.ContactId From User u where u.Type__c=\'Partner\' and u.Contact.ManualPartnerShareExists__c=false and u.Profile.Name=\'OCPM Agent Portal\' and u.IsActive=true and u.Intrax_Id__c!=null order by u.lastmodifiedDate asc limit :integerValue';
      system.debug('*****SOQLQuery*****'+SOQLQuery);
       }           
      system.debug('******SOQLQuery ***********'+SOQLQuery);
        return Database.getQueryLocator(SOQLQuery);         
       
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope ){
     
       lstPartnerUser = (List<User>)scope;
       boolean returnflag;
       List<Contact> lstContact=new  List<Contact>();
       
         system.debug('******lstPartnerUser ***********'+lstPartnerUser);
       if(lstPartnerUser!=null && lstPartnerUser.size()>0)
       {        
       for(User usr : lstPartnerUser)
       {
        lstContact= [select c.ManualPartnerShareExists__c from Contact c where c.id=:usr.contactId];
        system.debug('******usr***********'+usr);
        If(lstContact!=null && lstContact.size()>0)
        {
            for(Contact con: lstContact)
            {
                con.ManualPartnerShareExists__c = True;
                ConToBeUpdated.add(con);
            }
        }
       }
   
       }
          
     }          
      
    
    global void finish(Database.BatchableContext BC){
           if(ConToBeUpdated.size()>0) 
       update ConToBeUpdated;
    }

}