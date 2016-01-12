public with sharing class FlowPositionController {
	public Position__c position{get; set;}
    
    public FlowPositionController (ApexPages.StandardController controller){
    	position = (Position__c)controller.getRecord();
  
         }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
                    
    //return new PageReference('javascript:window.close()'); 
    PageReference P = Page.AY_HF_Interview_thank_you;   
    P.setRedirect(true);
    return P;
    }

    public PageReference getAPCFinishPage() {                      
        return new PageReference('/'+position.Id);
    }  
    
    public PageReference getFinishPageValidation() {
                    
      return new PageReference('javascript:window.close()'); 
    // PageReference P = Page.Validation_public_thank_you;   
    //   P.setRedirect(true);
     //   return P;
    }
}