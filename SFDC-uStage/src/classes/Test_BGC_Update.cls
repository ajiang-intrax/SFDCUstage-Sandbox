@isTest(seeAllData=false)
private class Test_BGC_Update{

    static testMethod void myUnitTest() {
     BGC_Update ng = new BGC_Update();
     
     Date myDate = 
        date.newinstance(Date.today().year()-17, Date.today().month(), Date.today().day());
        Date myDate1 = 
        date.newinstance(Date.today().year(), Date.today().month()-1, Date.today().day()-1);
        Date myDate2 = 
        date.newinstance(Date.today().year(), Date.today().month()-2, Date.today().day());
        
     User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
     Opportunity o = new Opportunity(Name='Test',OwnerId=sysAdmin.Id,StageName='Closed - Won',CloseDate=myDate2);
     insert o;
     Applicant_Info__c ai = new Applicant_Info__c(Name='test',Type__c = 'Host Family',Engagement_Start__c=myDate1,Opportunity_Name__c=o.Id);
     insert ai;
     Person_Info__c pi = new Person_Info__c(Name='test',Applicant_Info__c=ai.id,Primary_Applicant__c = false,Date_of_Birth__c=myDate);
     insert pi;
     Database.executeBatch(ng);
     
    }
    
}