@isTest(seeAllData=false)
private class Test_FlowEngagementController{

    static testMethod void myUnitTest() {
	    Engagement__c engRec = new Engagement__c();
	    ApexPages.StandardController sc = new ApexPages.StandardController(engRec);
	    FlowEngagementController ec = new FlowEngagementController(sc);
	    ec.getFinishPage();
	    ec.getFinishPageValidation();
	    ec.getWTCheckInFinishPage();
	    ec.getWTFinishPage();
	    ec.getAYFinishPage();
        ec.getAPCFinishPage();
	    ec.getCurrentYear();
	    ec.getParam();
	    ec.getWTSecondJobFinishPage();
	    ec.getIGICheckInFinishPage();
	    ec.getIGIMidProgramFinishPage();
    }
    
}