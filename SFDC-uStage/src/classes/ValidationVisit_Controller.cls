public with sharing class ValidationVisit_Controller {
	 
	 public static boolean isTest=false;
	 public User user{get;set;}
     public List<Match__c> getlstValidationVisits() 
       {
       	string SOQLQuery;
       	List<Match__c> lstValidationVisits;
       	if(!isTest)
       	{
       	 user = [Select Id, ContactId,Type__c,Intrax_Id__c,UserRole.PortalRole, UserRole.PortalType, UserRole.DeveloperName, 
                      UserRole.RollupDescription, UserRole.ParentRoleId, UserRole.Name,  Contact.AccountId, Contact.Intrax_Programs__c, User_Interests__c from User where Id =: UserInfo.getUserId()]; 
          system.debug('*******user********'+user);
       	}
       	       	
          if(user.contactId!=null || user.ContactId=='')
          {           	        	
           SOQLQuery = ' Select m.Position_Name__r.State__c, m.Position_Name__r.City__c, m.Validator__r.Program_Role_As_Text__c, m.Validator__r.Program_Role__c, m.Validator__c,m.Match_Type__c, m.Validation_Visit_Due_Date__c, m.Validation_Visit_Date__c, m.Status__c, m.Start_Date__c,m.Position_Name__r.Name,m.Engagement__r.Name, m.Engagement__r.Id, m.Position_Name__r.Id, m.Position_Name__c, m.Name,  m.Id, m.Engagement__c, m.CreatedDate, m.CreatedById From Match__c m where m.Validator__c = ' + '\'' + user.contactId  + '\' and m.Status__c = \'Confirmed\' and ((m.Match_Type__c=\'Permanent\' and m.Validation_Visit_Date__c = NULL) or m.Match_Type__c=\'Temporary\')';
          // SOQLQuery = ' Select m.Validator__r.Program_Role_As_Text__c, m.Validator__r.Program_Role__c, m.Validator__c, m.Match_Type__c,m.Validation_Visit_Due_Date__c, m.Validation_Visit_Date__c, m.Status__c, m.Start_Date__c,m.Position_Name__r.Name,m.Engagement__r.Name, m.Engagement__r.Id, m.Position_Name__r.Id, m.Position_Name__c, m.Name, m.Id, m.Engagement__c, m.CreatedDate, m.CreatedById, (Select Id, Name, RecordTypeId, Assessment_Date__c, Status__c From Match_Assessments__r  where RecordTypeId=' + '\'' + constants.ASS_AY_HF_Validation  + '\') From Match__c m where m.Validator__c = \'003e0000006Vs3C\' and ((m.Match_Type__c=\'Permanent\' and m.Validation_Visit_Date__c = NULL) or m.Match_Type__c=\'Temporary\')  ';
          
            lstValidationVisits = Database.query(SOQLQuery);
           system.debug('*******lstValidationVisits********'+lstValidationVisits);
         
         
          }
       	
      
       	
            return lstValidationVisits;
          }
       
       
}