@isTest(seeAllData = true)
private class test_solution_controller {

    static testMethod void myUnitTest1() {
	       
	  PageReference p=Page.resource_article; 
	        Test.setCurrentPage(p); 
	    	
	    	test.StartTest();
		    solution_controller controller = new solution_controller ();
		    User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
			system.runAs(sysAdmin){
		    		//No Solution Record
		    		Portal_Content__c solAux = controller.solution;
		    		
		    		//Accesing again to Solution Record
		    		Portal_Content__c solAux1 = controller.solution;
		    }
		    test.StopTest();
	  }
	  
	  static testMethod void myUnitTest2() {
	       
	  		PageReference p=Page.resource_article; 
	        Test.setCurrentPage(p); 
	    	Portal_Content__c sol = new Portal_Content__c(Name='Test', Subject__c='test');
		    insert sol;
		    
	    	test.StartTest();
		    solution_controller controller = new solution_controller ();
		    
		    
		    
		    User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
			system.runAs(sysAdmin){
		    		p.getParameters().put('Id',sol.Id);  
		    		Portal_Content__c solAux1 = controller.solution;
		    		Portal_Content__c solAux2 = controller.solution;
		    }
		    test.StopTest();
	  }
	   
	
}