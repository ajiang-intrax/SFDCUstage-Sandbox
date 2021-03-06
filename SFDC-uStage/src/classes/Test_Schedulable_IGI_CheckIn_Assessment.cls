@isTest(seeAllData=false)
public class Test_Schedulable_IGI_CheckIn_Assessment 
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
     String jobId = System.schedule('Test IGI CheckIn Assessment','0 0 7 * * ? *',new Schedulable_IGI_CheckIn_Assessment());
     CronTrigger ct = fetchCronTrigger(jobId);
     Test.stopTest();
    }
}