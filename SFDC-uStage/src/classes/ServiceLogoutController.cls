public class ServiceLogoutController {
	
	public User userRecord;
	public Contact contactRecord;
	
	public ServiceLogoutController() {
		
	}	
	
	public void contactToDelete(){
		userRecord = [Select Id, User_Interests__c, CommunityNickname, ContactId from User where Id = :UserInfo.getUserId()];
		contactRecord = [select Id, IsContactNotServiced__c, Email from Contact where Id = :userRecord.ContactId];
		contactRecord.IsContactNotServiced__c = true;
		contactRecord.Email = userRecord.CommunityNickname;
		update contactRecord;
		if(ApexPages.currentPage().getParameters().get('appId') != null){
			list<Applicant_Info__c> appInfoToDelte = [Select Id, isApplicationDelete__c from Applicant_Info__c where Id = :ApexPages.currentPage().getParameters().get('appId')];
			if(appInfoToDelte != null && appInfoToDelte.size() == 1){
				appInfoToDelte[0].isApplicationDelete__c = true;
				update appInfoToDelte[0];
			}
		}
	}
}