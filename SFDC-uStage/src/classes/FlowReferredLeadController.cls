public class FlowReferredLeadController{
    public FlowReferredLeadController (ApexPages.StandardController controller){
    } 
    
    //Return custom Finish page for the VWF
    public PageReference getFinishPage() {
      PageReference P = Page.West_HC_Finish;   
      P.setRedirect(true);
      return P; 
    }
}