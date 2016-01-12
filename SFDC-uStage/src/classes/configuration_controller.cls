public with sharing class configuration_controller {
	
	public static User getUserInfo(){
		return [SELECT Id, User_Interests__c, ProfileId FROM User WHERE Id =: userInfo.getUserId()]; 
	}
	
	public static PageReference apc_portal_checkLogin(string t){
        if(userInfo.getUserType() == 'Guest'){
            pageReference p = Page.AppEngine_SiteLoginPage;
            p.setRedirect(true);
            return p;
        }else return null;
	}
}