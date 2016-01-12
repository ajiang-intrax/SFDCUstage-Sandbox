public without sharing class FlowPersonInfoAuditController {
    
 public Person_Info__c personInfo{get; set;}
    
    public FlowPersonInfoAuditController(ApexPages.StandardController controller){
     personInfo = (Person_Info__c)controller.getRecord();
    }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
                    
         return new PageReference('/'+personInfo.Id);  
        
      
    }
    
    

}