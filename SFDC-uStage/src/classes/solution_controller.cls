public with sharing class solution_controller {
	
	public solution_controller(){
	
	}
	
	public Portal_Content__c solution{get{
	
	if(solution == null){
		
		system.debug('@@@@@cname: ' + ApexPages.currentPage().getParameters().get('cname'));
		list<Portal_Content__c> solutionList = [Select id, Name, Body__c, Subject__c
	        From Portal_Content__c
	        where Name =: ApexPages.currentPage().getParameters().get('cname')];
	  	system.debug('@@@@@solutionList: ' + solutionList);
	  	if(solutionList!=null && solutionList.size()>0){
	  		solution = solutionList[0];
	  		return solution;
	  	}else{
	  		Portal_Content__c solutionAux = new Portal_Content__c(); 
	  		return solutionAux;
	  	}
	}else{
		return solution;
	}
	
	}
	set;}	  

}