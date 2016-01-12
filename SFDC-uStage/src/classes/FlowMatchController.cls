public with sharing class FlowMatchController {
	public Match__c match{get; set;}
	public Id userId{get; set;}
	public String userFirstName{get; set;}
	public String userLastName{get; set;}
	public String ProfileName{get; set;}
	    
    
    public FlowMatchController (ApexPages.StandardController controller){
    	match = (Match__c)controller.getRecord();
    	userId = userInfo.getUserId();
    	userFirstName = userInfo.getFirstName();
    	userLastName = userInfo.getLastName();
    	User UserProfileNm = [Select u.Profile.Name, u.ProfileId From User u WHERE u.Id =: userInfo.getUserId()];
  		ProfileName = UserProfileNm.Profile.Name;
  
        }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
                    
    //  return new PageReference('javascript:window.close()'); 
     PageReference P = Page.AY_Contact_public_thank_you;   
       P.setRedirect(true);
        return P;
    }
    
    public PageReference getFinishPageRematch() {
                    
    //  return new PageReference('javascript:window.close()'); 
       
       
       Match__c matchid = [select Id,Name, Engagement__c from Match__c  where Id  = :match.Id]; 
       PageReference P = new PageReference('/' + matchid.Engagement__c );   
       P.setRedirect(true);
        return P;
    }
    
    public PageReference getFinishPageAPCMatch() {
       Match__c matchid = [select Id,Name, Engagement__c from Match__c  where Id  = :match.Id]; 
       PageReference P = new PageReference('/' + matchid.Id);   
       P.setRedirect(true);
        return P;
    }    
    
    public PageReference getFinishPageValidation() {
                    
    //  return new PageReference('javascript:window.close()'); 
     PageReference P = Page.Validation_public_thank_you;   
       P.setRedirect(true);
        return P;
    }
    
    public PageReference getFinishPageHome() {
                    
    //  return new PageReference('javascript:window.close()'); 
     PageReference P = Page.Home_public_thank_you;   
       P.setRedirect(true);
        return P;
    }
}