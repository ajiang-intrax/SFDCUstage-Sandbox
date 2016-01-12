@isTest(seeAllData=false)
private class Test_ShareAssessment_Batch{

    static testMethod void myUnitTest() {
    	  Test.startTest();
      
        
     ShareAssessmentBatch ng = new ShareAssessmentBatch();
  
      Database.executeBatch(ng);
       
      
        ShareAssessmentBatch ng1 = new ShareAssessmentBatch();
       // ShareAssessmentBatch.FirstRun =true;
  
      Database.executeBatch(ng1);
       Test.stopTest();
    }
    
}