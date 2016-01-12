@isTest(seeAllData=false)
private class Test_CreateAssessmentBatch{

    static testMethod void myUnitTest() {
    	  Test.startTest();
      
        
     CreateAssessmentBatch ng = new CreateAssessmentBatch();
  
      Database.executeBatch(ng);
       
      
        CreateAssessmentBatch ng1 = new CreateAssessmentBatch();
        CreateAssessmentBatch.FirstRun =true;
  
      Database.executeBatch(ng1);
       Test.stopTest();
    }
    
}