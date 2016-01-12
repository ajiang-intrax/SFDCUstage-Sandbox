@isTest(seeAllData=false)
private class Test_FlowPositionController{

    static testMethod void myUnitTest() {
	    Position__c pos = new Position__c();
	    ApexPages.StandardController sc = new ApexPages.StandardController(pos);
	    FlowPositionController pc = new FlowPositionController(sc);
	    pc.getFinishPage();
	    pc.getFinishPageValidation();
        pc.getAPCFinishPage();
    }
    
}