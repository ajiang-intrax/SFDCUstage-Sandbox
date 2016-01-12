public with sharing class FlowTomadachiInfoController  {
    
  
    
    public FlowTomadachiInfoController (ApexPages.StandardController controller){
  
         }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
                    
    //  return new PageReference('javascript:window.close()'); 
     //PageReference P = new PageReference('http://www.ayusa.org');   
     PageReference P = Page.TMD_HF_public_thank_you; 
       P.setRedirect(true);
        return P;     
      
    }
    
    }