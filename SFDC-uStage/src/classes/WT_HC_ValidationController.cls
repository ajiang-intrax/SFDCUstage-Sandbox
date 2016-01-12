public with sharing class WT_HC_ValidationController {
	
    public Opportunity opportunityInfo{get; set;}
    
    public WT_HC_ValidationController(ApexPages.StandardController controller){
        opportunityInfo = (Opportunity)controller.getRecord();
    }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
    	return new PageReference('/' +opportunityInfo.Id);
    	/*
        applicantInfo = 
            [Select a.Id , a.Account__c, a.Lead__c, a.Intrax_Program_Options__c From Applicant_Info__c a where a.Id = :applicantInfo.Id];
        if (applicantInfo.Account__c != null && applicantInfo.Intrax_Program_Options__c != 'Ayusa High School')
            return new PageReference('/'+applicantInfo.Account__c);
        else if (applicantInfo.Lead__c != null && applicantInfo.Intrax_Program_Options__c !='Ayusa High School')
            return new PageReference('/'+applicantInfo.Lead__c);
        else
            return new PageReference('/'+applicantInfo.Id);
        */
    }
    /*
    static testMethod void testIt(){
        test.startTest();
        Applicant_Info__c a = new Applicant_Info__c();
        a.Intrax_Program__c = 'Internship';
        a.Last_Name__c = 'test';
        a.Street__c = 'test';
        a.City__c = 'test';
        a.State__c = 'CA';
        a.Postal_Code__c = '12345';
        a.Country__c = 'United States';
        a.Home_Phone__c = '12345';
        a.Date_of_Birth__c = date.ValueOf('1968-09-21');
        a.Email__c = 'test@test.com';
        insert a;
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        PageReference flsync = Page.FLAppSyncLeadExists;
        FlowController fc = new FlowController(sc);
        Test.setCurrentPageReference(flsync);
        fc.getFinishPage();     
        test.stopTest();
    }*/
}