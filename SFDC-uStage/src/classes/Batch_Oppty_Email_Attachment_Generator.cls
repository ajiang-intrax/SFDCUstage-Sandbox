global class Batch_Oppty_Email_Attachment_Generator implements Database.Batchable<sObject>{

global Database.Querylocator start(Database.BatchableContext BC ){        
      string  SOQLQuery;
        Date d = System.today()+14;
       String APCRecordType= Constants.OPP_AUPAIRCARE_PT;
       SOQLQuery = 'Select o.RecordTypeId,o.Primary_Contact__r.Id, o.Primary_Contact__r.Email, o.Primary_Contact__r.Phone, o.Primary_Contact__r.MobilePhone, o.Primary_Contact__r.Name, o.Primary_Contact__r.FirstName, o.Primary_Contact__r.LastName,  o.Primary_Contact__c, o.Id, o.Engagement_Start__c, o.Countries_of_Interest__c From Opportunity o where ' 
       + '  o.Countries_of_Interest__c=\'United States\' and o.Intrax_Market__c = \'Germany\' and o.RecordTypeId =:APCRecordType and o.type =\'Participant\' and o.oPeration_Stage__c=\'Matched\' and o.Engagement_Start__c=:d order by o.Primary_Contact__r.Name ';
                
      
      system.debug('*****SOQLQuery*****'+SOQLQuery);
     
        return Database.getQueryLocator(SOQLQuery);         
         
    }   
    
  global void execute(Database.BatchableContext BC, List<sObject> scope) {
  List<Opportunity> lstOpps = new List<Opportunity>();
       lstOpps = (List<Opportunity>)scope;
         List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
    // First, need to obtain the ID of the email template we created.
    EmailTemplate et = [Select e.TimesUsed, e.TemplateType, e.TemplateStyle, e.SystemModstamp, e.Subject, e.OwnerId, e.NamespacePrefix, e.Name, e.Markup, e.LastUsedDate, e.LastModifiedDate, e.LastModifiedById, e.IsActive, e.Id, e.HtmlValue, e.FolderId, e.Encoding, e.DeveloperName, e.Description, e.CreatedDate, e.CreatedById, e.BrandTemplateId, e.Body, e.ApiVersion From EmailTemplate e where e.templatetype='visualforce' and e.DeveloperName='DE_16_PT_Flight_Social_NW_Match_V2'];
  Map<Id,Id> OppContactMap= new map<Id,Id>();
   For(Opportunity opp:lstOpps)
   {
    OppContactMap.put(opp.Id,opp.Primary_Contact__r.Id);
   }
   
   If(OppContactMap!=null && OppContactMap.size()>0)
   {
    Set<id> oppIds = OppContactMap.keySet() ;
    
      for (Id oppId : oppIds) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setTemplateId(et.Id);
      mail.setSaveAsActivity(true);
      mail.setTargetObjectId(OppContactMap.get(oppId));
      mail.setWhatId(oppId);
      allMails.add(mail);
      }
       Messaging.SendEmailResult [] result = Messaging.sendEmail(allMails);
      
   }
  }
   global void finish(Database.BatchableContext BC){
        
    }
}