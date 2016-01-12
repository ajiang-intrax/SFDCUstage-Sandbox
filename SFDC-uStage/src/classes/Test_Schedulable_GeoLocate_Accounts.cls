@isTest(seeAllData=false)
private class Test_Schedulable_GeoLocate_Accounts{

    public static CronTrigger fetchCronTrigger(String jobId) 
    {
        return [
        select CronExpression,
        TimesTriggered,
        NextFireTime
        from CronTrigger
        where Id = :jobId
      ];
    }
    static testMethod void myUnitTest() 
    {
     Test.startTest();
     String jobId = System.schedule('Test Daily Activities','0 0 7 * * ? *',new Schedulable_GeoLocate_Accounts());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
    
}