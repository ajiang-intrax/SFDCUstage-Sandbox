@isTest(seeAllData=false)
public class Test_Schedulable_fetchDISCresult 
{
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
     String jobId = System.schedule('Test Fetch DISC Result','0 0 7 * * ? *',new Schedulable_fetchDISCresult());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
}