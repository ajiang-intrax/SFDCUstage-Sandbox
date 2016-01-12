//This component is part of Invoice IT Deployment
@isTest (seeAllData=true)
public with sharing class Test_InvoiceITClasses {
    static testmethod void testBasicObjects() {
        //Insert Account
        list<RecordType> recordTypes = [Select Id from RecordType where SObjectType = 'Account' AND Name = 'Person Account' AND IsActive = true];
        Account account = new Account();
        if(recordTypes.size() > 0){
            account.RecordTypeId = recordTypes[0].Id;   
        }
        account.LastName = 'Test Last';
        account.PersonEmail = 'test@test.com';
        
        insert account;
        
        //Insert an Opportunity
        recordTypes = [Select Id from RecordType where SObjectType = 'Opportunity' AND Name = 'Ayusa PT' AND IsActive = true];
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        if(recordTypes.size() > 0){
            opportunity.RecordTypeId = recordTypes[0].Id;   
        }
        opportunity.StageName = 'Finalization';
        opportunity.CloseDate = System.today() + 10; 
        opportunity.Name = 'Test Opp';
        opportunity.Match_Date__c = System.today() + 7;
        opportunity.Engagement_Start__c = System.today() + 60;
        
        insert opportunity;
        
        //Insert payment plan
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Name = '30-50-20';
        paymentPlan.Percentage_1__c = 30;
        paymentPlan.Percentage_2__c = 50;
        paymentPlan.Percentage_3__c = 20;
        paymentPlan.Date_Field_1__c = 'Now';
        paymentPlan.Date_Field_2__c = 'Match_Date__c';
        paymentPlan.Date_Field_3__c = 'Engagement_Start__c';
        
        insert paymentPlan;
        
        Pricebook2 standard = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        if (!standard.isActive) {
            standard.isActive = true;
            update standard;
        }

        Product2 product = new Product2(); 
        //[Select ProductCode, Payment_Plan__c, Name, Id From Product2 where IsActive = true limit 1];
        
        product.Name = 'Test Product';
        product.Family = 'AuPairCare';
        product.CurrencyIsoCode = 'USD';
        product.Payment_Plan__c = paymentPlan.Id;
        
        insert product;
        
        PricebookEntry one = new PricebookEntry();
        one.pricebook2Id = standard.id;
        one.product2id = product.id;
        one.unitprice = 1249.0;
        one.isactive = true;
        insert one;
        
        OpportunityLineItem line = new OpportunityLineItem();
        line.Quantity = 1.0;
        line.UnitPrice = 300;
        line.PricebookEntryId = one.Id;
        line.Payment_Plan__c = paymentPlan.Id;
        line.OpportunityId = opportunity.Id;
        
        insert line;
        
        //Now try changing the payment plan on the line
        line.Payment_Plan__c = null;
        
        update line;
        
        //Now roll back the details
        line.Payment_Plan__c = paymentPlan.Id;
        
        update line;
        
        //Update the opportunity to create an order
        opportunity.Create_Order__c = true;
        
        /*update opportunity;
        
        invoiceit_s__Job__c job = [select id from invoiceit_s__Job__c where Opportunity__c = :opportunity.Id];
        
        system.assertNotEquals(job, Null);
        
        job.invoiceit_s__Create_Invoice_Automatically__c = true;
        
        update job;
        
        invoiceit_s__Invoice__c invoice = [select id,invoiceit_s__Invoice_Status__c from invoiceit_s__Invoice__c where invoiceit_s__Order__c = :job.Id];
        
        system.assertEquals(invoice.invoiceit_s__Invoice_Status__c, 'Posted');
        
        PageReference pageRef = new PageReference('/apex/newViewInvoice?scontrolCaching=1&id='+invoice.Id); 
        Test.setCurrentPage(pageRef);
        
        ControllerEmailInvoice controller = new ControllerEmailInvoice();
        controller.sInvoiceId = invoice.Id; */
        //invoiceit_s__Invoice__c inv = controller.invoice;
        //list<invoiceit_s__Invoice_Lines__c> listOfInvoiceLines = controller.listOfInvoiceLines;
    }
}