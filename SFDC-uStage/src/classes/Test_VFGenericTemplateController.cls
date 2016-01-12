@isTest(seeAllData=false)
private class Test_VFGenericTemplateController{

    static testMethod void myUnitTest() {
     VFGenericTemplateController ng = new VFGenericTemplateController();
     Date myDate2 = 
        date.newinstance(Date.today().year(), Date.today().month()-2, Date.today().day());
     Opportunity o = new Opportunity(Name='Test',StageName='Closed - Won',CloseDate=myDate2);
     insert o;
     ng.getOpportunity();
    }
    
}