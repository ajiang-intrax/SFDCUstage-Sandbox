@isTest(seeAllData=false)
private class Test_Schedulable_APC_Stipend_Pay_Events{

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
     String jobId = System.schedule('Test Batch APC Stipend PE','0 50 1 * * ? *',new Schedulable_APC_Stipend_Pay_Events());
     CronTrigger ct = fetchCronTrigger(jobId);
     system.assert(ct.Id != null);
     system.assertEquals(0, ct.TimesTriggered);
     system.assertEquals(50, ct.NextFireTime.minute());
     Test.stopTest();
    }
    
}