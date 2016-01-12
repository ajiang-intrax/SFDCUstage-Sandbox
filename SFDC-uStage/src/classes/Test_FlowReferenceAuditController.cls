@isTest(seeAllData=false)
private class Test_FlowReferenceAuditController{

    static testMethod void myUnitTest() {
    Reference__c engRec = new Reference__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(engRec);
     FlowReferenceAuditController ng = new FlowReferenceAuditController(sc);
    }
    
}