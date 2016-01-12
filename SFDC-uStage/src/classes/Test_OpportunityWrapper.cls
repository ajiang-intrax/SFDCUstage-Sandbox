@isTest(seeAllData=false)
private class Test_OpportunityWrapper{

    static testMethod void myUnitTest() {
    Opportunity opportunity = new Opportunity();
     Double sim = 0;
     Integer ranking = 0;
     OpportunityWrapper ng = new OpportunityWrapper(opportunity,sim,ranking);
    }
    
}