public without sharing class FlowReferenceAuditController {
    
 public Reference__c reference{get; set;}
    
    public FlowReferenceAuditController(ApexPages.StandardController controller){
     reference = (Reference__c)controller.getRecord();
    }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
                    
         return new PageReference('/'+reference.Id);  
        
      
    }
    
    

}