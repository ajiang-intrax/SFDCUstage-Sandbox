public without sharing virtual class MenuApplication_Controller {
	
	public String appId{get; set;}
	public String viewpage{get; set;}
	public PageReference page{get; set;}
	public String appIdAux1;
	public String appIdAux2;
	
	public MenuApplication_Controller() {
	
	}
	
	public PageReference SubmitApp(){
	
	appIdAux1=Apexpages.currentPage().getParameters().get('id');
	appIdAux2=Apexpages.currentPage().getParameters().get('ObjId');
	page = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
	viewpage = ApexPages.currentPage().getParameters().get('viewpage');
	
	system.debug('*****@@in MenuApplication_Controller() ');
	
	try{
		
		if(appIdAux1!=null){
		
		appId=appIdAux1;
		
		}else{
		
		appId=appIdAux2;
		
		}
		
		
		if(appId != null){
			
			Applicant_Info__c applicant = [SELECT a.Id, a.Name, a.Application_Level__c, a.Application_Stage__c From Applicant_Info__c a where a.Id = :appId];	
			
			applicant.Application_Stage__c = 'Submitted';
			
			update applicant;
			
			
			if(page!=null){
				page.getParameters().put('id', applicant.Id);
				if(viewpage=='true'){
            	page.getParameters().put('viewpage', 'true');
            	}
				if(ApexPages.currentPage().getParameters().get('reDirectPage') == 'true'){
            		page.setRedirect(true);
            	}
            	
			}
			
        	return page;
			
		}else{
			return null;
		}
	}catch(Exception e){
    	system.debug('*****###Problem trying to Submit the Application' + e );
    	ApexPages.addMessages(e);
    	return null;
    }
	
}

}