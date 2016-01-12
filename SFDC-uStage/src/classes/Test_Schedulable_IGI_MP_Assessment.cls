@isTest(seeAllData=false)
private class Test_Schedulable_IGI_MP_Assessment{

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
     String jobId = System.schedule('Test IGI MP Assessment','0 0 9 * * ? *',new Schedulable_IGI_MP_Assessment());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
    
}