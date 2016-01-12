@isTest(seeAllData=false)
public class TestSevisAutoSendingBatch {

static testmethod void sevisAutoSendingBatchTester(){ 
    
    Test.startTest();
    User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN ];
    SevisAutoSendingBatch.isTest = true;
    SevisAutoSendingBatch  myBatch = new SevisAutoSendingBatch();
	Id jobId = Database.executeBatch(myBatch, 6);
	System.debug('*************************************Test Started Sevis Batch Apex job:  ' + jobId);
    Test.stopTest();
}

}