global class Schedulable_ShareStandardUser_Batch implements Schedulable {
  global void execute(SchedulableContext sc){
    ShareStandardUserBatch batch = new ShareStandardUserBatch();
    Database.executeBatch(batch);
  }
}