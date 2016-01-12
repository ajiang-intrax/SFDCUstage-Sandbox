global class Schedulable_ShareAssessment_Batch implements Schedulable {	
  global void execute(SchedulableContext sc){
    ShareAssessmentBatch batch = new ShareAssessmentBatch();
    Database.executeBatch(batch,5);
  }
}