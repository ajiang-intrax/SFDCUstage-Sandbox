public with sharing class Flow_WT_Checkin_Monthly_Contact {
	
	public Engagement__c engagement{get;set;}
	
	public Flow_WT_Checkin_Monthly_Contact(ApexPages.StandardController controller){
		engagement = (Engagement__c)controller.getRecord();
	}
	
	public PageReference getFinishPage() {
    	return new PageReference('/' + engagement.Id);
    	
    }
}