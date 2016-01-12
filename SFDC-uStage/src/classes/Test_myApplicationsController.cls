@isTest(seeAllData=false)
private class Test_myApplicationsController{

    static testMethod void myUnitTest() {
    	ApexPages.CurrentPage().getParameters().put('nextPage', 'Test');
    	ApexPages.CurrentPage().getParameters().put('Id', '01234');
     	myApplicationsController mac = new myApplicationsController();
     	mac.navigator();
    }
    
}