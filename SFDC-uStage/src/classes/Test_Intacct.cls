@isTest(seeAllData=true)
public class Test_Intacct {
    static testmethod void intacctTester(){
    	//Create Test data
    	Opportunity existingOpportunity = [select Id,AccountId from Opportunity limit 1];
    	Intacct__c anIntacctRecord = new Intacct__c();
    	anIntacctRecord.Account__c = existingOpportunity.AccountId;
    	anIntacctRecord.Opportunity__c = existingOpportunity.Id;
    	anIntacctRecord.Type__c = 'Create Sales Invoice';
		insert anIntacctRecord;
		
		Applicant_Info__c anApp = [select Id from Applicant_Info__c limit 1];
		Payment__c paymentRecord = new Payment__c();
		paymentRecord.Account_Name__c = existingOpportunity.AccountId;
		paymentRecord.Account_Receivables_Intacct__c = anIntacctRecord.Id;
		paymentRecord.Amount__c = 100.00;
		paymentRecord.Card_Holder__c = anApp.Id;
		paymentRecord.Opportunity_Name__c = existingOpportunity.Id;
		paymentRecord.Sales_Invoice_Intacct__c = anIntacctRecord.Id;
		paymentRecord.Txn_Amount__c = 100.00;
		paymentRecord.Txn_Id__c = 'TXN123';
		paymentRecord.Txn_Date__c = System.now();
		
		insert paymentRecord;
		
    	anIntacctRecord = [select Id,Opportunity__c,Opportunity__r.AccountId,Type__c ,Account__c from Intacct__c where Opportunity__c != null limit 1];
    	StaticResourceCalloutMock CreateSalesOrderMockResponse = new StaticResourceCalloutMock();
		CreateSalesOrderMockResponse.setStaticResource('CreateSalesOrderMockResponse');
		CreateSalesOrderMockResponse.setStatusCode(200);
		CreateSalesOrderMockResponse.setHeader('Content-Type', 'application/xml');
		//Test.setMock(HttpCalloutMock.class, mock);
        
        StaticResourceCalloutMock CreateRevenueContractMockResponse = new StaticResourceCalloutMock();
        CreateRevenueContractMockResponse.setStaticResource('CreateRevenueContractMockResponse');
		CreateRevenueContractMockResponse.setStatusCode(200);
		CreateRevenueContractMockResponse.setHeader('Content-Type', 'application/xml');
		//Test.setMock(HttpCalloutMock.class, mock1);
		
		StaticResourceCalloutMock CreateSalesInvoiceMockResponse = new StaticResourceCalloutMock();
        CreateSalesInvoiceMockResponse.setStaticResource('CreateSalesInvoiceMockResponse');
		CreateSalesInvoiceMockResponse.setStatusCode(200);
		CreateSalesInvoiceMockResponse.setHeader('Content-Type', 'application/xml');
		
		StaticResourceCalloutMock CreateAccountReceivablesMockResponse = new StaticResourceCalloutMock();
        CreateAccountReceivablesMockResponse.setStaticResource('CreateAccountReceivablesMockResponse');
		CreateAccountReceivablesMockResponse.setStatusCode(200);
		CreateAccountReceivablesMockResponse.setHeader('Content-Type', 'application/xml');
		//Test.setMock(HttpCalloutMock.class, mock1);
		//Account oppAcc = [select Account from Opportunity where Id = :anIntacctRecord.Opportunity__c];
		
/*		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		multimock.setStaticResource('http://api.salesforce.com/foo/sfdc','CreateSalesOrderMockResponse');
		multimock.setStaticResource('http://api.salesforce.com/foo/sfdc','CreateRevenueContractMockResponse');
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/xml');
		//Test.setMock(HttpCalloutMock.class, multimock);*/
		
		Test.startTest();
        IntAcctOppSyncHelper.isApexBeingTested = true;
		IntAcctOppSyncHelper.SyncAccountToCustomer_new(anIntacctRecord.Opportunity__r.AccountId);
        IntAcctOppSyncHelper.SyncAccountToCustomerfuture(anIntacctRecord.Opportunity__r.AccountId);
        List<Account> accList=[Select a.id,a.IntacctID__c, a.Status__c,a.Intacct_Sync_At__c,a.Type,
                               a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,
                               a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, 
                               a.Intrax_Program_Category__c, a.Intrax_Id__c,
                               a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, 
                               a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, 
                               a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, 
                               a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity from account a where id= :anIntacctRecord.Opportunity__r.AccountId];
		System.debug('accList[0]' + accList[0]);
        
        IntAcctOppSyncHelper.updateAcctList =new List<Account>();
        if(accList!=null && accList.size()>0)        
        IntAcctOppSyncHelper.bulkSyncAccountToCustomer(accList[0]);
        
		Test.setMock(HttpCalloutMock.class, CreateSalesOrderMockResponse);
		IntAcctOppSyncHelper.isApexBeingTested = true;
        IntAcctOppSyncHelper.insertIntacctList = new List<Intacct__c>();
		IntAcctOppSyncHelper.CreateSalesOrder(anIntacctRecord.Opportunity__c, anIntacctRecord.Id,null,false,null,null,'');
        
        Test.setMock(HttpCalloutMock.class, CreateSalesOrderMockResponse);
		IntAcctOppSyncHelper.isApexBeingTested = true;
        IntAcctOppSyncHelper.insertIntacctList = new List<Intacct__c>();
		IntAcctOppSyncHelper.CreateSalesOrder(anIntacctRecord.Opportunity__c, anIntacctRecord.Id,paymentRecord.Id,false,null,null,'');
		
		Test.setMock(HttpCalloutMock.class, CreateRevenueContractMockResponse);
		IntAcctOppSyncHelper.isApexBeingTested = true;
        IntAcctOppSyncHelper.insertIntacctList = new List<Intacct__c>();
		IntAcctOppSyncHelper.CreateRevContract(anIntacctRecord.Opportunity__c, anIntacctRecord.Opportunity__r.AccountId, anIntacctRecord.Id, '1054', 'SO0224',false,null,null);
		
		Test.setMock(HttpCalloutMock.class, CreateSalesInvoiceMockResponse);
		IntAcctOppSyncHelper.isApexBeingTested = true;
        IntAcctOppSyncHelper.insertIntacctList = new List<Intacct__c>();
		IntAcctOppSyncHelper.CreateSalesInvoice(anIntacctRecord.Opportunity__c, anIntacctRecord.Opportunity__r.AccountId, anIntacctRecord.Id, '1054', 'SO0224',new list<OpportunityLineItem>(),system.today());
		
        Test.setMock(HttpCalloutMock.class, CreateAccountReceivablesMockResponse);
		IntAcctOppSyncHelper.isApexBeingTested = true;
        IntAcctOppSyncHelper.PaymentId = paymentRecord.Id;
		IntAcctOppSyncHelper.CreateAccountReceivables(anIntacctRecord.Opportunity__c, anIntacctRecord.Opportunity__r.AccountId, anIntacctRecord.Id);
		
        Test.setMock(HttpCalloutMock.class, CreateAccountReceivablesMockResponse);
		IntAcctOppSyncHelper.isApexBeingTested = true;
        IntAcctOppSyncHelper.PaymentId = paymentRecord.Id;
		IntAcctOppSyncHelper.ApplyAccountReceivables(anIntacctRecord.Opportunity__c, anIntacctRecord.Opportunity__r.AccountId, anIntacctRecord.Id,'INV0123-1','INV0124-1',1000);
        
        IntAcctOppSyncHelper.divideSIOnDueDate(anIntacctRecord.Opportunity__c, anIntacctRecord.Opportunity__r.AccountId, anIntacctRecord.Id, '1054', 'SO0224');
        IntAcctOppSyncHelper.divideSIOnDueDateARupdate(anIntacctRecord.Opportunity__c, anIntacctRecord.Opportunity__r.AccountId, anIntacctRecord.Id, '1054', 'SO0224', new List<Id>{paymentRecord.id});
		
		Test.stopTest();
    }
    
    static testmethod void intacct_wrapper_tester(){
    	//Create Test data
    	Intacct_wrapper wrapper = new Intacct_wrapper();
    	Opportunity existingOpportunity = [select Id,AccountId from Opportunity limit 1];
        Match__c existingMatch = [select Id from match__c limit 1];
    	Intacct__c anIntacctRecord = new Intacct__c();
    	anIntacctRecord.Account__c = existingOpportunity.AccountId;
    	anIntacctRecord.Opportunity__c = existingOpportunity.Id;
    	anIntacctRecord.Type__c = 'Create Sales Invoice';
		insert anIntacctRecord;
		
		Applicant_Info__c anApp = [select Id from Applicant_Info__c limit 1];
		Payment__c paymentRecord = new Payment__c();
		paymentRecord.Account_Name__c = existingOpportunity.AccountId;
		paymentRecord.Account_Receivables_Intacct__c = anIntacctRecord.Id;
		paymentRecord.Amount__c = 100.00;
		paymentRecord.Card_Holder__c = anApp.Id;
		paymentRecord.Opportunity_Name__c = existingOpportunity.Id;
		paymentRecord.Sales_Invoice_Intacct__c = anIntacctRecord.Id;
		paymentRecord.Txn_Amount__c = 100.00;
		paymentRecord.Txn_Id__c = 'TXN123';
		paymentRecord.Txn_Date__c = System.now();
		
		insert paymentRecord;
		
    	anIntacctRecord = [select Id,Opportunity__c,Opportunity__r.AccountId,Type__c,Account__c from Intacct__c where Opportunity__c != null limit 1];
    	StaticResourceCalloutMock CreateSalesOrderMockResponse = new StaticResourceCalloutMock();
		CreateSalesOrderMockResponse.setStaticResource('CreateSalesOrderMockResponse');
		CreateSalesOrderMockResponse.setStatusCode(200);
		CreateSalesOrderMockResponse.setHeader('Content-Type', 'application/xml');
		//Test.setMock(HttpCalloutMock.class, mock);
        
        StaticResourceCalloutMock CreateRevenueContractMockResponse = new StaticResourceCalloutMock();
        CreateRevenueContractMockResponse.setStaticResource('CreateRevenueContractMockResponse');
		CreateRevenueContractMockResponse.setStatusCode(200);
		CreateRevenueContractMockResponse.setHeader('Content-Type', 'application/xml');
		//Test.setMock(HttpCalloutMock.class, mock1);
		
		StaticResourceCalloutMock CreateSalesInvoiceMockResponse = new StaticResourceCalloutMock();
        CreateSalesInvoiceMockResponse.setStaticResource('CreateSalesInvoiceMockResponse');
		CreateSalesInvoiceMockResponse.setStatusCode(200);
		CreateSalesInvoiceMockResponse.setHeader('Content-Type', 'application/xml');
		
		StaticResourceCalloutMock CreateAccountReceivablesMockResponse = new StaticResourceCalloutMock();
        CreateAccountReceivablesMockResponse.setStaticResource('CreateAccountReceivablesMockResponse');
		CreateAccountReceivablesMockResponse.setStatusCode(200);
		CreateAccountReceivablesMockResponse.setHeader('Content-Type', 'application/xml');

		Test.startTest();
		
		Test.setMock(HttpCalloutMock.class, CreateSalesOrderMockResponse);
		IntAcctOppSyncHelper.isApexBeingTested = true;
        IntAcctOppSyncHelper.insertIntacctList = new List<Intacct__c>();
		wrapper.CreateSalesOrder(anIntacctRecord.Opportunity__c, anIntacctRecord.Account__c);
        
		wrapper.CreateIntacctAccnt_Sync(anIntacctRecord.Opportunity__r.AccountId);
        wrapper.UpdateIntacctAccnt_Sync(anIntacctRecord.Opportunity__r.AccountId,anIntacctRecord.id);
        //wrapper.SyncIntacctAccnt(anIntacctRecord.Opportunity__r.AccountId);
        wrapper.CreateAndApplyServiceCredit(anIntacctRecord.Opportunity__c,anIntacctRecord.Opportunity__r.AccountId,anIntacctRecord.Opportunity__c,
                                           5000,existingMatch.Id);
		Test.stopTest();
    }
}