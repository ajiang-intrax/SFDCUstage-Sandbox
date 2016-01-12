public with sharing class FlowIGIValidateController{

    public IGI_Validate__c IGIValidate{get; set;}
    
    public FlowIGIValidateController(ApexPages.StandardController controller) { 
        IGIValidate = (IGI_Validate__c)controller.getRecord();
    }

    //Return custom Finish page for the VWF
    public PageReference getFinishPage() {
      PageReference P = Page.CloseWin;   
      P.setRedirect(true);
      return P; 
    }
    
    public FlowIGIValidateController() {
 
    }
}