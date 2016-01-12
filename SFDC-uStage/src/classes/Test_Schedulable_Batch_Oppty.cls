@isTest(seeAllData=false)
private class Test_Schedulable_Batch_Oppty{

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
     String jobId = System.schedule('Test Daily Activities','0 0 7 * * ? *',new Schedulable_Batch_Oppty_Email_Attachment());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
    
}