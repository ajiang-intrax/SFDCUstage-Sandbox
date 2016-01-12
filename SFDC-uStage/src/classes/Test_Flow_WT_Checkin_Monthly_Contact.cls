@isTest(seeAllData=false)
private class Test_Flow_WT_Checkin_Monthly_Contact {

    static testMethod void myUnitTest() {
	    Engagement__c eng = new Engagement__c();
	    ApexPages.StandardController sc = new ApexPages.StandardController(eng);
	    Flow_WT_Checkin_Monthly_Contact ng = new Flow_WT_Checkin_Monthly_Contact(sc);
	    ng.getFinishPage();
    }
    
}