@isTest(seeAllData=false)
private class Test_FlowIGIValidateController{

    static testMethod void myUnitTest() {
    	IGI_Validate__c iv = new IGI_Validate__c();
     	ApexPages.StandardController sc = new ApexPages.StandardController(iv);
     	FlowIGIValidateController ivc1 = new FlowIGIValidateController(sc);
     	
     	FlowIGIValidateController ivc2 = new FlowIGIValidateController();
     	ivc2.getFinishPage();
    }
    
}