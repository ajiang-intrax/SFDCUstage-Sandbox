@isTest(seeAllData=false)
private class Test_FlowPersonInfoAuditController{

    static testMethod void myUnitTest() {
    Person_Info__c engRec = new Person_Info__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(engRec);
     FlowPersonInfoAuditController ng = new FlowPersonInfoAuditController(sc);
    }
    
}