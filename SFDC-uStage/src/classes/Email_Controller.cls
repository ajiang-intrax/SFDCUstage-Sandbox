public without sharing class Email_Controller {
	
	public list<Person_Info__c> personInfoList;
	public Person_Info__c personinfo{get; set;}
	public User user {get; set;}
	public String uInParameter {get; set;}  
	
	
	public Email_Controller(){
	
	Id aId = ApexPages.currentPage().getParameters().get('Id');
	personInfoList = [Select p.Id, p.First_Name__c, p.Last_Name__c From Person_Info__c p Where p.Applicant_Info__c = : aId and p.Primary_Applicant__c = : true]; 
	
	if(personInfoList.size()>0 && personInfoList != null){
		personinfo = personinfoList[0];
	}	
	
	user = [Select Id, User_Interests__c, FirstName, LastName, ContactId,Type__c,Intrax_Id__c, Contact.AccountId from User where Id =: UserInfo.getUserId()];
	
	uInParameter = user.User_Interests__c; 
	 
	
	}

}