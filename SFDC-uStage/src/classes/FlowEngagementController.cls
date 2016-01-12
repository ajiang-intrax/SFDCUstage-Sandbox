public with sharing class FlowEngagementController {
    public Engagement__c engagement{get; set;}
    public Flow.Interview.WT_Position_Info_Submission myFlow { get; set; }
    
    public FlowEngagementController (ApexPages.StandardController controller){
        engagement = (Engagement__c)controller.getRecord();  
         }   
    
     public PageReference getAYFinishPage() {                      
        return new PageReference('/'+engagement.Id);
    }
    
     public PageReference getAPCFinishPage() {                      
        return new PageReference('/'+engagement.Id);
    }    
    
    public string getCurrentYear() {
        return string.valueOf(System.today().year());
    }
    
    //Method to get the output parameter in the flow and redirect the user to the Uploader or to a thank you page.
    
     public String getParam() {
 
         if (myFlow==null){
         return '';
         }else 
         return myFlow.FinishParam;
    }
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
                    
    //return new PageReference('javascript:window.close()'); 
    PageReference P = Page.AY_PT_Interview_thank_you;   
    P.setRedirect(true);
    return P;
    }
    
    public PageReference getFinishPageValidation() {
                    
      return new PageReference('javascript:window.close()'); 
    // PageReference P = Page.Validation_public_thank_you;   
    //   P.setRedirect(true);
     //   return P;
    }
    public PageReference getWTFinishPage() {
                    
    //return new PageReference('javascript:window.close()'); 
    PageReference P = Page.WT_Orientation_Thank_You;   
    P.setRedirect(true);
    return P;
    }
    
    public PageReference getWTCheckInFinishPage() {
                    
        //return new PageReference('javascript:window.close()'); 
        PageReference P = Page.Home;   
        P.setRedirect(true);
        return P;
    }
    public PageReference getIGICheckInFinishPage() {
                    
        //return new PageReference('javascript:window.close()'); 
        PageReference P = Page.igi_home;   
        P.setRedirect(true);
        return P;
    }
    public PageReference getIGIMidProgramFinishPage() {
                    
        //return new PageReference('javascript:window.close()'); 
        PageReference P = Page.igi_home;   
        P.setRedirect(true);
        return P;
    }
    
     public PageReference getIGIFinalProgramFinishPage() {
                    
        //return new PageReference('javascript:window.close()'); 
        PageReference P = Page.igi_home;   
        P.setRedirect(true);
        return P;
    }
        
    public PageReference getWTSecondJobFinishPage() {
                        
        //return new PageReference('javascript:window.close()'); 
        PageReference P;
        if(getParam() == 'In-Review'){
            P = new PageReference('/Home');   
        } else if(getParam() == 'No Upload'){
            P = new PageReference('/Home');
        } else{
            P = new PageReference('/flow_uploader_redirection' + '?id=' + engagement.Id + '&docType=Offer-Document'); // new PageReference('/participant_thank_you_uploader');  
        } 
        P.setRedirect(true);
        return P;
    
    }
    
}