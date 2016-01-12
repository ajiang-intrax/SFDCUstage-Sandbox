global class ShareHCPortalUsers implements Database.Batchable<sObject>{
    public String SOQLQuery=null ;
    public List<User> lstHCPortalUser;
    public static  boolean FirstRun =false;
    // public boolean NoShareBatch =false;
    global Database.Querylocator start(Database.BatchableContext BC ){        
        Decimal BatchLimit;
        List<User> lstUser=  new list<User>();
       
        JobSettings__c ObjJobSetting = JobSettings__c.getValues('ShareHCPortalUserBatch');
         if(ObjJobSetting==null)
         {
             JobSettings__c ObjShareHCUserJob = new  JobSettings__c();
             ObjShareHCUserJob.Name ='ShareHCPortalUserBatch';
             ObjShareHCUserJob.BatchLimit__c = 1;
             insert ObjShareHCUserJob;
              FirstRun = True; 
         }
         else 
         {
             BatchLimit = ObjJobSetting.BatchLimit__c;
         }
          
       if(FirstRun) 
       {       	
       	SOQLQuery =  'Select u.Type__c, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.Type__c=\'Host Company\' and u.Contact.ManualHCPortalUserShareExists__c=false and u.Profile.Name=\'OCPM HC\' and u.IsActive=true and u.Intrax_Id__c!=null order by u.lastmodifiedDate asc limit 1';
       }
       else
       {     
        Integer integerValue = BatchLimit.intValue();
        SOQLQuery =  'Select u.Type__c, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.Type__c=\'Host Company\' and u.Contact.ManualHCPortalUserShareExists__c=false and u.Profile.Name=\'OCPM HC\' and u.IsActive=true and u.Intrax_Id__c!=null order by u.lastmodifiedDate asc limit :integerValue';
      system.debug('*****SOQLQuery*****'+SOQLQuery);
       }           
      system.debug('******SOQLQuery ***********'+SOQLQuery);
        return Database.getQueryLocator(SOQLQuery);         
       
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope ){
     
       lstHCPortalUser = (List<User>)scope;
       boolean returnflag;
       List<Contact> lstContact=new  List<Contact>();
       List<Contact> ConToBeUpdated=new  List<Contact>();
         system.debug('******lstHCPortalUser ***********'+lstHCPortalUser);
       if(lstHCPortalUser!=null && lstHCPortalUser.size()>0)
       {        
       for(User usr : lstHCPortalUser)
       {
       	lstContact= [select c.ManualHCPortalUserShareExists__c from Contact c where c.id=:usr.contactId];
       	system.debug('******lstContact***********'+lstContact);
       	If(lstContact!=null && lstContact.size()>0)
       	{
       		for(Contact con: lstContact)
       		{
       			con.ManualHCPortalUserShareExists__c = True;
       			ConToBeUpdated.add(con);
       		}
       	}
       }
      if(ConToBeUpdated.size()>0) 
       update ConToBeUpdated;
       }
          
     }          
      
    
    global void finish(Database.BatchableContext BC){
        
    }

}