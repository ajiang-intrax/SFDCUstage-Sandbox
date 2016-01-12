global class Schedulable_SharePartner_Batch implements Schedulable {
  global void execute(SchedulableContext sc){
    SharePartnerBatch batch = new SharePartnerBatch();
    Database.executeBatch(batch);
  }
}