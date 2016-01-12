@isTest(seeAllData=false)
private class Test_FlowReferredLeadController{

    static testMethod void myUnitTest() {
    Lead engRec = new Lead();
    ApexPages.StandardController sc = new ApexPages.StandardController(engRec);
     FlowReferredLeadController ng = new FlowReferredLeadController(sc);
     ng.getFinishPage();
    }
    
}