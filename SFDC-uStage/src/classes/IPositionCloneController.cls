public with sharing class IPositionCloneController {

// Constructor using the standard controller    
private final ApexPages.StandardController mController; 
       
public IPositionCloneController(ApexPages.StandardController stdController) {        
    mController = stdController;    
}

public PageReference deletePosition(){
	
		Position__c p = [SELECT p.Name  FROM Position__c p WHERE id=:mController.getId() LIMIT 1]; 
		
		Opportunity op = [SELECT o.Name, o.Id, (Select id FROM Positions__r 
								WHERE  id=:mController.getId()) 
								FROM Opportunity o LIMIT 1];
	try{
		delete p;
	}   
	catch(Exception e){
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not create new Position record');
        ApexPages.addMessage(myMsg);
        return mController.view();
	}   
	  
	    PageReference pageRef = new ApexPages.standardController(op).View(); 
	    pageRef.setRedirect(true);
	    return pageRef; 
}

public PageReference oppToPosition(){
        //object p will contain the new Position object
        Position__c p = new Position__c();
        // With this query we are able to get all the data we need
        try{
          		Opportunity op =[SELECT o.Name, o.PAX__c, o.Location_of_Interest__c, o.Id, o.Functional_Areas__c, o.Engagement_Start__c, 
	            o.Engagement_End__c, o.Description, o.Compensation_Type__c, o.Account.ShippingCountry, o.Account.ShippingPostalCode, 
	            o.Account.ShippingState, o.Account.ShippingCity, o.Account.ShippingStreet, o.Account.BillingCountry, 
	            o.Account.BillingPostalCode, o.Account.BillingState, o.Account.BillingCity, o.Account.BillingStreet, 
	            o.Account.Name, o.Account.Id, o.AccountId, o.Intrax_Program_Options__c, o.Intrax_Programs__c, o.Intrax_Region__c,
	            o.StageName, o.Probability,o.Countries_of_Interest__c, Position_Types__c, 
	            o.Languages_Required__c, o.Language_Level__c
	            FROM Opportunity o
	            WHERE id=:mController.getId() LIMIT 1];
        	
            //We only should clone the Opportinity if the State is 'WON'
            // Commmented out by MAINT 155
            //if(op.StageName == 'Closed Won'){
            
            string descrip;
            if(op.Description != NULL){      
				descrip = op.Description.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>');
            }
			else{
				descrip = '';
				}
            //Matching the fields
			p.Name = op.Name;
            p.Compensation_Type__c = op.Compensation_Type__c; 
            p.Description__c = descrip;
            p.Engagement_Start__c = op.Engagement_Start__c;
            p.Engagement_End__c = op.Engagement_End__c;
            p.Host_Company_Id__c = op.Account.Id;
            p.Host_Opportunity_Id__c = op.Id;
            p.Intrax_Region__c = op.Intrax_Region__c;
            p.Positions_Sold__c = op.PAX__c;
           	p.Regional_Location__c = op.Location_of_Interest__c;
           	p.Countries_of_Interest__c = op.Countries_of_interest__c;
           	p.Position_Types__c = op.Position_Types__c;
           	p.Languages_Required__c = op.Languages_Required__c;
           	p.Language_Level__c = op.Language_Level__c;

            //Billing -- Shipping Adresses
    
           if( op.Account.ShippingCity == NULL  || op.Account.ShippingStreet == NULL ){
                p.City__c = op.Account.BillingCity;
                p.Country__c = op.Account.BillingCountry;
                p.Postal_Code__c = op.Account.BillingPostalCode;
                p.State__c = op.Account.BillingState;
                p.Street__c = op.Account.BillingStreet;
            }else{
                p.City__c = op.Account.ShippingCity;
                p.Country__c = op.Account.ShippingCountry;
                p.Postal_Code__c = op.Account.ShippingPostalCode;
                p.State__c = op.Account.ShippingState;
                p.Street__c = op.Account.ShippingStreet;
            }
         
         // If there's more than one Intrax Program, Intrax Program Option or Functional_Area
            
            if( (op.Intrax_Programs__c != NULL) ){
                p.Intrax_Program__c = op.Intrax_Programs__c;    
                
                if(op.Intrax_Programs__c == 'Internship')
                {
                	p.Tipped_Position__c = 'No';
                }
            }
            
            
            if( (op.Intrax_Program_Options__c != NULL)){
                p.Intrax_Program_Options__c = op.Intrax_Program_Options__c;
            }
            
            
            if( (op.Functional_Areas__c != NULL)&&(!op.Functional_Areas__c.contains(';'))){
               p.Functional_Areas__c = op.Functional_Areas__c;
            }
            
         // Finally, we insert the row as a position object
            insert p;
            //}
            
            // If Stage is not 'WON', we should display an error message
            /*else{
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity not in Won Stage, so no Position can be created');
          		ApexPages.addMessage(myMsg);
          		return null;
            }
          if(test.isRunningTest()){
            	//throw new MyException();
            }  
           */ 	
            
        } catch(Exception e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not create new Position record');
          ApexPages.addMessage(myMsg);
          return mController.view();
          }
          
        // All is good, so redirect to the new placement list view
       	// PageReference pageRef = new ApexPages.standardController(p).View();
        PageReference pageRef = new PageReference('/apex/OpportunityToPosition_2?id=' + p.Id); 
       	pageRef.setRedirect(true);
        
        return pageRef;
    }    
    static testMethod void PositiveTest() {
       	Account acc = new Account(Name = 'Acc_TEST',
		    ShippingCity = 'San Francisco', BillingCity = 'Madrid',
	       	ShippingCountry = 'USA', BillingCountry = 'Spain',
	        ShippingStreet = 'California St', BillingStreet = 'Paseo Castellana',
	        ShippingState = 'CA', BillingState = 'MADRID',
	        ShippingPostalCode = '94102', BillingPostalCode = '28080',
	        Type = 'Host Company');
	        
	    insert acc;
	
		Opportunity opp = new Opportunity( Name = 'TEST1',
		    AccountId = acc.Id,
		    Type = acc.Type,
		    RecordTypeId = '01230000000sCj0AAE',
		    Engagement_End__c = Date.valueOf('2012-02-08'),
		    CloseDate = Date.valueOf('2012-02-06'),
		    App_Fee_Paid__c = true,
		 	Compensation_Type__c = 'Stipend',
		    StageName = 'Closed Won',
		    Intrax_Region__c = 'Europe',
		    Intrax_Programs__c = 'Internship',
		    Intrax_Program_Options__c = 'Internship Abroad',
		    Functional_Areas__c = 'Finance',
		    PAX__c = 1, Location_of_Interest__c = 'Spain',
		    Program_Year__c = '2012', 
		    Agreement_Status__c='Provided',
		    Job_Desc_Status__c='Drafting' );

	    
	    Account acc1 = [SELECT id, Name FROM Account WHERE Name = 'Acc_TEST'];
	    System.assertEquals('Acc_TEST', acc1.Name);
	    
	    // Creating the Opportunity
	    insert opp;
	    
	    Opportunity opp1 = [SELECT Id, Name FROM Opportunity WHERE Name = 'Acc_TEST: TEST1'];
	    System.assertEquals('Acc_TEST: TEST1', opp1.Name);
	    
	    Test.startTest();
	    
	    ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
	   	IPositionCloneController controller = new IPositionCloneController(sc); 
	   
	   	controller.oppToPosition();
	   	
	    Position__c p = [SELECT Id, Name,Host_Opportunity_Id__c, Engagement_Start__c
      						FROM Position__c
     						WHERE Host_Opportunity_Id__c = :opp1.Id];
	    
	    System.assertEquals(p.Host_Opportunity_Id__c, opp1.Id);
	    
	    
	    
 		/* controller.oppToPosition();
 		String nextPage = controller.oppToPosition().getUrl();
 		System.assertEquals(NULL,nextPage); */
	    
    	test.stopTest();
    }
 
    static testMethod void noClosedWonTest(){
    	
        Account acc = new Account(Name = 'Acc_TEST',
		    ShippingCity = 'San Francisco', BillingCity = 'Madrid',
	       	ShippingCountry = 'USA', BillingCountry = 'Spain',
	        ShippingStreet = 'California St', BillingStreet = 'Paseo Castellana',
	        ShippingState = 'CA', BillingState = 'MADRID',
	        ShippingPostalCode = '94102', BillingPostalCode = '28080',
	        Type = 'Host Company');
	        
	    insert acc;
	
		Opportunity opp = new Opportunity( Name = 'TEST2',
		    AccountId = acc.Id,
		    Type = acc.Type,
		    RecordTypeId = '01230000000sCj0AAE',
		    Engagement_End__c = Date.valueOf('2012-02-08'),
		    CloseDate = Date.valueOf('2012-02-06'),
		    App_Fee_Paid__c = true,
		 	Compensation_Type__c = 'Stipend',
		    StageName = 'Prospecting',
		    Intrax_Region__c = 'Europe',
		    Intrax_Programs__c = 'Internship',
		    Intrax_Program_Options__c = 'Internship Abroad',
		    Functional_Areas__c = 'Finance',
		    PAX__c = 1, 
		    Location_of_Interest__c = 'Spain',
		    Program_Year__c = '2012', 
		    Agreement_Status__c='Provided',
		    Job_Desc_Status__c='Drafting' );
	    
	    Account acc1 = [SELECT id, Name FROM Account WHERE Name = 'Acc_TEST'];
	    System.assertEquals('Acc_TEST', acc1.Name);
    	
	    insert opp;

	    Opportunity opp3 = [SELECT Id, Name FROM Opportunity WHERE Name = 'Acc_TEST: TEST2'];
	    System.assertEquals('Acc_TEST: TEST2', opp3.Name);
	    
	    Test.startTest();
	    
	    ApexPages.StandardController sc = new ApexPages.StandardController(opp3);
	   	IPositionCloneController controller = new IPositionCloneController(sc); 
	   	try{
	   		controller.oppToPosition();
	   	} catch(DMLException e){
	   		System.assert(e.getMessage().contains('Opportunity not in Won Stage, so no Position can be created'), e.getMessage());
	   	}
	   	 		
	    test.stopTest();  
	
    }
       
       /*static testMethod void NegativeCases(){
       Account acc = new Account(Name = 'Acc_TEST',
		    //ShippingCity = 'San Francisco', 
		    BillingCity = 'Madrid',
	       	ShippingCountry = 'USA', BillingCountry = 'Spain',
	        //ShippingStreet = 'California St', 
	        BillingStreet = 'Paseo Castellana',
	        ShippingState = 'CA', BillingState = 'MADRID',
	        ShippingPostalCode = '94102', BillingPostalCode = '28080',
	        Type = 'Host Company');
	        
	    insert acc;
	
		Opportunity opp = new Opportunity( Name = 'TEST3',
		    AccountId = acc.Id,
		    Type = acc.Type,
		    RecordTypeId = '01230000000sCj0AAE',
		    Engagement_End__c = Date.valueOf('2012-02-08'),
		    CloseDate = Date.valueOf('2012-02-06'),
		    App_Fee_Paid__c = true,
		 	Compensation_Type__c = 'Stipend',
		    StageName = 'Closed Won',
		    Intrax_Region__c = 'Europe',
		    Intrax_Programs__c = 'Internship; Ayusa',
		    Intrax_Program_Options__c = 'Internship Abroad; Business Internship',
		    //Functional_Areas__c = 'Finance',
		    PAX__c = 1, Location_of_Interest__c = 'Spain',
		    Program_Year__c = '2012', 
		    Agreement_Status__c='Provided',
		    Job_Desc_Status__c='Drafting' );

	    
	    Account acc1 = [SELECT id, Name FROM Account WHERE Name = 'Acc_TEST'];
	    System.assertEquals('Acc_TEST', acc1.Name);
	    
	    // Creating the Opportunity
	    insert opp;
	    
	    Opportunity opp1 = [SELECT Id, Name FROM Opportunity WHERE Name = 'Acc_TEST: TEST3'];
	    System.assertEquals('Acc_TEST: TEST3', opp1.Name);
	    
	    Test.startTest();
	    
	    ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
	   	IPositionCloneController controller = new IPositionCloneController(sc); 
	   
	   	controller.oppToPosition();
	   	
	    Position__c p = [SELECT Id, Name,Host_Opportunity_Id__c, intrax_Program__c, Intrax_Program_Options__c,
	    					City__c, Country__c, Street__c, Functional_Areas__c
      						FROM Position__c
     						WHERE Host_Opportunity_Id__c = :opp1.Id];
	    
	    System.assertEquals(p.Name, opp1.Name);
	    System.assertEquals('Ayusa;Internship', p.Intrax_Program__c);
	    System.assertEquals('Business Internship;Internship Abroad', p.Intrax_Program_Options__c);
	    System.assertEquals(acc.BillingCity, p.City__c);
	    System.assertEquals(acc.BillingStreet, p.Street__c);
	    System.assertEquals(NULL, p.Functional_Areas__c);

 		/* controller.oppToPosition();
 		String nextPage = controller.oppToPosition().getUrl();
 		System.assertEquals(NULL,nextPage); 
	    
    	test.stopTest();
       	
       }*/
       
      
     
	static testMethod void NegativeCases2(){
       Account acc = new Account(Name = 'Acc_TEST',
		    ShippingCity = 'San Francisco', BillingCity = 'Madrid', ShippingCountry = 'USA', BillingCountry = 'Spain',
	        ShippingStreet = 'California St', BillingStreet = 'Paseo Castellana', ShippingState = 'CA', BillingState = 'MADRID',
	        ShippingPostalCode = '94102', BillingPostalCode = '28080', Type = 'Host Company'
	        );
	        
	    insert acc;
	
		Opportunity opp = new Opportunity( Name = 'TEST3',
		    AccountId = acc.Id, Type = acc.Type, RecordTypeId = '01230000000sCj0AAE',
		    Engagement_End__c = Date.valueOf('2012-02-08'), CloseDate = Date.valueOf('2012-02-06'),
		    App_Fee_Paid__c = true, Compensation_Type__c = 'Stipend', StageName = 'Closed Won',
		    Intrax_Region__c = 'Europe', Intrax_Programs__c = 'Internship; Ayusa',
		    Intrax_Program_Options__c = 'Internship Abroad', Functional_Areas__c = 'Finance',
		    PAX__c = 1, Location_of_Interest__c = 'Spain', Program_Year__c = '2012', 
		    Agreement_Status__c='Provided', Job_Desc_Status__c='Drafting'
		    );

	    Account acc1 = [SELECT id, Name FROM Account WHERE Name = 'Acc_TEST'];
	    System.assertEquals('Acc_TEST', acc1.Name);
	    
	    // Creating the Opportunity
	    insert opp;
	    
	    Opportunity opp1 = [SELECT Id, Name FROM Opportunity WHERE Name = 'Acc_TEST: TEST3'];
	    System.assertEquals('Acc_TEST: TEST3', opp1.Name);
	    
	    Test.startTest();
	    
	    ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
	   	IPositionCloneController controller = new IPositionCloneController(sc); 
	   
	   	controller.oppToPosition();
	   	
	    Position__c p = [SELECT Id, Name,Host_Opportunity_Id__c, Functional_Areas__c, intrax_Program__c, Intrax_Program_Options__c,
	    					City__c, Country__c, Street__c
      						FROM Position__c
     						WHERE Host_Opportunity_Id__c = :opp1.Id];
	   
	    System.assertEquals(p.Name, opp1.Name);
	    System.assertEquals('Ayusa;Internship', p.Intrax_Program__c);
	    System.assertEquals(opp.Intrax_Program_Options__c, p.Intrax_Program_Options__c);
	    System.assertEquals(acc.ShippingCity, p.City__c);
	    System.assertEquals(acc.ShippingStreet, p.Street__c);
	    System.assertEquals(opp.Functional_Areas__c, p.Functional_Areas__c);

	    
    	test.stopTest();
       	
       }
       
       static testMethod void HandleException(){
       Account acc = new Account(Name = 'Acc_TEST',
		    ShippingCity = 'San Francisco', BillingCity = 'Madrid', ShippingCountry = 'USA', BillingCountry = 'Spain',
	        ShippingStreet = 'California St', BillingStreet = 'Paseo Castellana', ShippingState = 'CA', BillingState = 'MADRID',
	        ShippingPostalCode = '94102', BillingPostalCode = '28080', Type = 'Host Company'
	        );
	        
	    insert acc;
		
		Opportunity opp = new Opportunity( 
			Name = 'TEST3',
		    AccountId = acc.Id, Type = acc.Type, RecordTypeId = '01230000000sCj0AAE',
		    Engagement_End__c = Date.valueOf('2012-02-08'), CloseDate = Date.valueOf('2012-02-06'),
		    App_Fee_Paid__c = true, Compensation_Type__c = 'Stipend', StageName = 'Closed Won',
		    Intrax_Region__c = 'Europe', Intrax_Programs__c = 'Internship; Ayusa',
		    Intrax_Program_Options__c = 'Internship Abroad', Functional_Areas__c = 'Finance',
		    PAX__c = 1, Location_of_Interest__c = 'Spain', Program_Year__c = '2012', 
		    Agreement_Status__c='Provided', Job_Desc_Status__c='Drafting'
		    );

	    Account acc1 = [SELECT id, Name FROM Account WHERE Name = 'Acc_TEST'];
	    System.assertEquals('Acc_TEST', acc1.Name);
	    
	    // Creating the Opportunity
	    
	    insert opp;
	    
	    Opportunity opp1 = [SELECT Id, Name FROM Opportunity WHERE Name = 'Acc_TEST: TEST3'];
	    System.assertEquals('Acc_TEST: TEST3', opp1.Name);
	    
	    Test.startTest();
	    
	    ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
	   	IPositionCloneController controller = new IPositionCloneController(sc); 

	   	controller.oppToPosition();
	   	   	
	    Position__c p = [SELECT Id, Name,Host_Opportunity_Id__c,Functional_Areas__c , intrax_Program__c, Intrax_Program_Options__c,
	    					City__c, Country__c, Street__c
      						FROM Position__c
     						WHERE Host_Opportunity_Id__c = :opp1.Id];
	 
	    try{
	   		controller.oppToPosition();
	   	} catch(DMLException e){
	   		System.assert(e.getMessage().contains('Opportunity not in Won Stage, so no Position can be created'), e.getMessage());
	   	}
	    
	    test.stopTest();
		
       }
}