public with sharing class userProfile {
	
	public List<User_Profile__c> userProfiles {get; set;}
	public User_Profile__c activeUserProfile {get; set;}
	public String docuSignStatusMessage {get; set;}
	
public userProfile(ApexPages.StandardController controller){
	userProfiles = [select Id, Name,Profile_Update__c,Is_Active__c from User_Profile__c up where up.User__c = :UserInfo.getUserId() ];
	for (User_Profile__c userProfile : userProfiles){
		if (userProfile.Is_Active__c){
			activeUserProfile = userProfile;
		}
	}
}

public PageReference handleAPCFSContract(){
	docuSignStatusMessage = 'Your Contract is yet to be signed; Please sign the contract to be eligible to access other parts of the system';
	return null;
}

public PageReference redirect(){
	
	if(!activeUserProfile.Profile_Update__c){
		PageReference p = new PageReference('/apex/DocViewer');
		p.getParameters().put('id',activeUserProfile.Id);
		p.setRedirect(true);
		
		PageReference pageRef = new ApexPages.standardController(activeUserProfile).View(); 
	    pageRef.setRedirect(true);
	    return pageRef; 	
	}
	else{
		PageReference p = new PageReference('/home/home.jsp');
		p.setRedirect(true);
		return p;
	}	
	//return p;
}

}