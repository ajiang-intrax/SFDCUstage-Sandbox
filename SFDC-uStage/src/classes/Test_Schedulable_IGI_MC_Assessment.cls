@isTest(seeAllData=false)
private class Test_Schedulable_IGI_MC_Assessment{

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
     String jobId = System.schedule('Test IGI MC Assessment','0 0 10 * * ? *',new Schedulable_IGI_MC_Assessment());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
    
}