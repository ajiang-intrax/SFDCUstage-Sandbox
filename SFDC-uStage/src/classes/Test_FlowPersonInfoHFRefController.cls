@isTest(seeAllData=false)
private class Test_FlowPersonInfoHFRefController{

    static testMethod void myUnitTest() {
    Person_Info__c engRec = new Person_Info__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(engRec);
     FlowPersonInfoHFRefController ng = new FlowPersonInfoHFRefController(sc);
     Applicant_Info__c ai = new Applicant_Info__c(Name='test');
     insert ai;
     Person_Info__c pi = new Person_Info__c(Name='test',Applicant_Info__c=ai.id);
     insert pi;
     ApexPages.currentPage().getParameters().put('persId',pi.id);
     ng.DeclineReference();
     ng.getFinishPage();
    }
}