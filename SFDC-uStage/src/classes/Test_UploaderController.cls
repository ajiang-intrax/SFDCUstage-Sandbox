@isTest(seeAllData=true)
private class Test_UploaderController{

    static testMethod void myUnitTest() {
    Engagement__c eng = [SELECT Id from Engagement__c ORDER BY CreatedDate DESC LIMIT 1];
    ApexPages.StandardController sc = new ApexPages.StandardController(eng);
    UploaderController.isTestMode = true;
    UploaderController uc = new UploaderController (sc);
    PageReference P = uc.goToUploader();
    }
}