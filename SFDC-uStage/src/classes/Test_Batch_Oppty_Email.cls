@isTest(seeAllData=false)
private class Test_Batch_Oppty_Email{

    static testMethod void myUnitTest() {
    	  Test.startTest();
      
      List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
        String AuPairCare_PT = [SELECT Id FROM RecordType WHERE DeveloperName = 'AuPairCare_PT' AND sObjectType = 'Opportunity' AND IsActive = true LIMIT 1].Id;
        
        //check for the record type size 
        if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            Contact c = new Contact(LastName = 'Test', AccountId = hostCompany.Id, Email = 'test@test.com');
            insert c;
            
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',Primary_Contact__c = c.Id,
            										oPeration_Stage__c = 'Matched', Type = 'Participant',Intrax_Market__c='Germany',Countries_of_Interest__c = 'United States',
            										RecordTypeId = AuPairCare_PT,
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today()+14);
            insert hostOpportunity;
            
        }
        
     Batch_Oppty_Email_Attachment_Generator ng = new Batch_Oppty_Email_Attachment_Generator();
  
      Database.executeBatch(ng);       
      
     
       Test.stopTest();
    }
    
}