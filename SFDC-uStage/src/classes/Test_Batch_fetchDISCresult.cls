@isTest(seeAllData=true)
public class Test_Batch_fetchDISCresult 
{
	static testMethod void myUnitTest() 
	{
		test.startTest();
        
        Batch_fetchDISCresult batch = new Batch_fetchDISCresult();
        Database.executeBatch(batch);
       
        test.stopTest(); 
	}
}