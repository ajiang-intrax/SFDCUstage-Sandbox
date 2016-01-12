public with sharing class apc_payEvent_controller {

public Date startDate{get;set;}
public Date endDate{get;set;}
public Date payDate{get;set;}
public String stage{get;set;}
public Boolean flag1{get;set;}
public Boolean flag2{get;set;}
public Boolean flag3{get;set;}
public list<Pay_Event__c> payEvents{get;set;}
public integer listSize{get;set;}

public List<SelectOption> stageOptions {
get{            
	//Variable to hold the picklist data
	List<SelectOption> pickListOptions = new List<SelectOption>();          
	//add picklist values
	pickListOptions.add(new SelectOption('--None--','--None--'));
	pickListOptions.add(new SelectOption('Confirmed', 'Confirmed'));
	pickListOptions.add(new SelectOption('Processed', 'Processed'));
	return pickListOptions;
	}
}


	public apc_payEvent_controller(){
	
	}
	
	public apc_payEvent_controller(ApexPages.StandardSetController controller){
		listSize = 0;
		payEvents = new list<Pay_Event__c>();
		flag1 = true;
		flag2 = false;
		flag3 = false;
	}
	
	public void search(){
		try{
		//setting stage value to Processed for Pay Event confirmation
		stage ='Confirmed';
		if(startDate == null){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an Start Date'));
    	
    	}else if(endDate == null){
		    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an End Date'));
    	
    	}else{
			payEvents = [SELECT Id, Name, Approved_By__c, Event_Date__c, Reference_Id__c, Payee__c, Quantity__c, Stage__c, Pay_Date__c 
                                        	FROM Pay_Event__c 
                                        	WHERE (Stage__c = 'Pending' OR Stage__c = 'Unearned') and
                                            Event_Date__c  <=: endDate and Event_Date__c >=: startDate and
                                            Intrax_Program__c = 'AuPairCare'];
            
            if(payEvents!=null && payEvents.size()>0){
            	system.debug('@@@@@payEvents.size()' + payEvents.size());
            	listSize = payEvents.size();
            	flag1 = false;
            	flag2 = true; 
            }else{
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Pay period dates are invalid. Please re-enter start and end dates'));
            }
		}
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was en error. Please contact to the admin or try later'));
		}	
	
	}
	
	public void searchConfirm(){
		try{
		//setting stage value to Processed for Pay Event confirmation
		stage ='Processed';
		if(startDate == null){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a Start Date'));
    	
    	}else if(endDate == null){
		    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an End Date'));
    	
    	}else if(payDate == null){
		    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a Pay Date'));
    	
    	}else{
			payEvents = [SELECT Id, Name, Approved_By__c, Event_Date__c, Reference_Id__c, Payee__c, Quantity__c, Stage__c, Pay_Date__c 
                                        	FROM Pay_Event__c 
                                        	WHERE Stage__c = 'Confirmed' and
                                            Event_Date__c  <=: endDate and Event_Date__c >=: startDate and
                                            Intrax_Program__c = 'AuPairCare'];
            
            if(payEvents!=null && payEvents.size()>0){
            	system.debug('@@@@@payEvents.size()' + payEvents.size());
            	listSize = payEvents.size();
            	flag1 = false;
            	flag2 = true; 
            }else{
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Not found any "Pending" Pay Even between those'+ startDate.format() +' and ' + endDate.format() + '. Please enter valid dates'));
            }
		}
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was en error. Please contact to the admin or try later'));
		}	
	
	}
	
	//confirm mass update to confirm
	public void confirm(){
		try{
		
		list<Pay_Event__c> pEventList = new list<Pay_Event__c>();
		for(Pay_Event__c pe:payEvents){
			pe.Stage__c = stage;
			if(payDate!= null){
				pe.Pay_Date__c = payDate;
			}
			pEventList.add(pe);
		}
		update peventList;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'You have sucessfully updated  '+ pEventList.size() +' pay period records'));
		flag3=true;
		
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was en error. Please contact to the admin or try later'));
		}
			
	}
	
	//cancel and back to Pay Event List
	public PageReference cancel(){
		 pagereference p = new pagereference(ApexPages.currentPage().getParameters().get('retURL'));
		 p.setRedirect(true);
		 system.debug('@@@@@page: ' + p);
		 return p;
	}

}