@isTest(seeAllData=false)
private class Test_FlowTomadachiInfoController{

    static testMethod void myUnitTest() {
    	Engagement__c engRec = new Engagement__c();
    	ApexPages.StandardController sc = new ApexPages.StandardController(engRec);
     	FlowTomadachiInfoController ng = new FlowTomadachiInfoController(sc);
 		ng.getFinishPage();
    }
    
}