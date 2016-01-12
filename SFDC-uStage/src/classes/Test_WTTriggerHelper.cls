@isTest
public class Test_WTTriggerHelper {
 public static testMethod void unittest1() 
 {
  
       Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Work Travel', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac_pt;
      
      
      Account ac_hc = new Account(
          Name = 'Test HC',
          type = 'Host Company', Intrax_Programs__c = 'Work Travel', status__c = 'Contracted',Workers_Comp_Received__c=System.today(),
          Business_License_Received__c=system.today(),EIN__c='324324334',Phone='234324',
          OwnerId = UserInfo.getUserId(),BillingStreet='Street 25',BillingState='SS',BillingCity='City',BillingCountry='saffdsdf',BillingPostalcode='334334');
          
      insert ac_hc;
      Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_hc.Id, RecordTypeId = '01230000000roCr', 
            Type='Host Company', Intrax_Programs__c = 'Work Travel', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won',Agreement_Status__c='Completed',Job_Desc_Status__c='Ops Approved');
        insert op;
          
          Position__c p = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Host_Opportunity_Id__c=op.Id,Opportunity_Stage__c='Closed Won',
            Intrax_Program__c = 'Work Travel', Intrax_Region__c = 'Europe', Status__c = 'Closed - Filled',Match_Offer_Status__c ='Offered',
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          
          );
          insert p;
         Position__c p1 = new Position__c(
            Name = 'Test Web Designer', Host_Company_Id__c = ac_hc.Id,Host_Opportunity_Id__c=op.Id,Opportunity_Stage__c='Processing',
            Intrax_Program__c = 'Work Travel', Intrax_Region__c = 'Europe', Status__c = 'Matching',Match_Offer_Status__c ='Accepted',
            Intrax_Program_Options__c = 'Business English',Country__c='Australia', Engagement_Start__c = date.today(), Engagement_End__c = (date.today()+1)
          
          );
          insert p1;
          
          
          Opportunity op_pt = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt.Id, RecordTypeId = '01230000000skjc', 
            Type='Participant', Intrax_Programs__c = 'Work Travel', Intrax_Region__c = 'Europe', 
            StageName = 'Processing',closeDate = date.today());
          insert op_pt;
         Engagement__c ca = new Engagement__c (
            Name = 'Candidate Test', Type__c = 'Participant',Account_Id__c = ac_pt.Id,Status__c='Program Ready',Opportunity_Id__c=op_pt.Id
          );
          insert ca;
          Match__c m = new Match__c(
            Name = 'Web Design - Match',Offer_Status__c = 'Offered',Service_Level__c='Independent',Interview_Status__c = 'Initiated', Position_Name__c = p.Id, Engagement__c = ca.Id, Participant_Id__c = ac_pt.Id,
            Participant_Opportunity_Id__c = op.Id, RecordTypeId = '012a0000001NYBK',Status__c = 'Interview Pending');         
          insert m;        
          
   
      List<Opportunity> newlist=new List<Opportunity>();
      List<Position__c> newpos=new List<Position__c>();
      newlist.add(op);
      Test.startTest();
      
      WTTriggerHelper.OPClosedWon(newlist);
      Match__c updateMatch=[Select Status__c,Offer_Status__c from Match__c where Id =:m.id];
      System.assertEquals((updateMatch.status__c).equals('Confirmed'),true);
      newpos.add(p1);
      WTTriggerHelper.positionMatchUpdate(newpos);
      System.assertEquals((updateMatch.Offer_Status__c).equals('Accepted'),true);
     // System.debug('match'+m.Status__c+m.Offer_Status__c);
     
      Test.stopTest();
     
 }
}