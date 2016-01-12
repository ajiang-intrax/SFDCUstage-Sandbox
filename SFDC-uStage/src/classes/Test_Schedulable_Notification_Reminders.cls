@isTest
private class Test_Schedulable_Notification_Reminders {
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
     String jobId = System.schedule('Test Daily Activities','0 0 11 * * ? *',new Schedulable_Notification_Reminders());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
    
}