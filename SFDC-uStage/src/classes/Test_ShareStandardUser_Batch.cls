@isTest(seeAllData=True)
private class Test_ShareStandardUser_Batch{

    static testMethod void myUnitTest() {
    	  Test.startTest();
      
        
     ShareStandardUserBatch ng = new ShareStandardUserBatch();
  
      Database.executeBatch(ng);
       
      
        ShareStandardUserBatch ng1 = new ShareStandardUserBatch();
        ShareStandardUserBatch.FirstRun =true;
  
      Database.executeBatch(ng1);
       Test.stopTest();
    }
    
}