public with sharing class FlowController {
    
    public Applicant_Info__c applicantInfo{get; set;}
    
    public FlowController(ApexPages.StandardController controller){
        applicantInfo = (Applicant_Info__c)controller.getRecord();
    }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
        applicantInfo = 
            [Select a.Id , a.Account__c, a.Lead__c, a.Intrax_Program_Options__c From Applicant_Info__c a where a.Id = :applicantInfo.Id];
        if (applicantInfo.Account__c != null && applicantInfo.Intrax_Program_Options__c != 'Ayusa High School')
            return new PageReference('/'+applicantInfo.Account__c);
        else if (applicantInfo.Lead__c != null && applicantInfo.Intrax_Program_Options__c !='Ayusa High School')
            return new PageReference('/'+applicantInfo.Lead__c);
        else
            return new PageReference('/'+applicantInfo.Id);
    }
    public PageReference getFinishPageAppInfo() {
        applicantInfo = 
            [Select a.Id , a.Account__c, a.Lead__c, a.Intrax_Program_Options__c From Applicant_Info__c a where a.Id = :applicantInfo.Id];
        
            return new PageReference('/'+applicantInfo.Id);
    }
    
    public string getUserType(){
    	string userType;
    	List<User> userList = [SELECT Id, Type__c FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1];
    	if(userList.size()>0){
    		userType = userList[0].Type__c;
    	}
    	
    	if(userType != NULL)
    		return userType;
    	else
    		return 'Ayusa';
    		
    }
        
}