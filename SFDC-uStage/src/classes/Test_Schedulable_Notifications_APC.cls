@isTest(seeAllData=false)
public with sharing class Test_Schedulable_Notifications_APC{

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
    static testMethod void myUnitTest1() 
    {
     Test.startTest();
     String jobId = System.schedule('Test APC NOtifications','0 0 7 * * ? *',new Schedulable_Notifications_APC());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
    static testMethod void myUnitTest2() 
    {
     Test.startTest();
     String jobId = System.schedule('Test APC NOtifications','0 0 7 * * ? *',new Schedulable_Notifications_APC_Match());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
    
}