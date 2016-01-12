@isTest(seeAllData=false)
public class Test_Batch_Match_SOAChange 
{
	static testMethod void myUnitTest() {
        // TO DO: implement unit test
           RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount  = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States', BillingStreet='Fremont', BillingCity='Fremont',
                                        BillingPostalCode='94538',BillingState ='CA',BillingCountry='USA');
                                        
        insert partnerAccount;
        
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test WT', RecordTypeId = Constants.WT_PT_Record_Type_Id, Home_Street_1__c = 'test', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test',  Application_Level__c = 'Main', 
                                                                Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Working',
                                                                Partner_Account__c = partnerAccount.Id);
      
        insert appInfo;
        
        Account partnerInfo = new Account (Name = 'Partner Acc', Email_Business__c = 'test@test.com', type = 'Partner');
        //Account partnerInfo = [SELECT Id, Name, Intrax_Id__c, type FROM Account WHERE Type = 'Partner' limit 1];
                        
        insert partnerInfo; 
         
        system.debug('******* Intrax_Id__c: ' + partnerInfo.Intrax_Id__c);  
        
        appInfo.Partner_Intrax_Id__c = partnerInfo.Intrax_Id__c; // Matching app and Partner
      
        Contact c_partner = new Contact(FirstName = 'Test1', LastName = 'Partner', AccountId = partnerInfo.Id, email='test@test.com');
      
        insert c_partner;
        
        Account companyInfo = new Account(Name = 'Host Company', type='Host Company', Intrax_Programs__c = 'Internship');
        
        insert companyInfo;
        
        Position__c p1 = new Position__c (Name = 'Test Host Company - Pos 1',Country__c='Australia', Intrax_Program__c = 'Work Travel', Host_Company_Id__c = companyInfo.Id);
        insert p1;
        Position__c p2 = new Position__c (Name = 'Test Host Company - Pos 2', Country__c='Australia',Intrax_Program__c = 'Work Travel', Host_Company_Id__c = companyInfo.Id);
        insert p2;
        
        Account ac_pt1 = new Account(
          FirstName = 'Test', LastName = 'PT1', PersonEmail = 'testpt1@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
        insert ac_pt1;
        
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = ac_pt1.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT1'];
        
        RecordType MatchRecordType = [select id, Name from RecordType where SobjectType='Match__c' and Name='Internship' Limit 1];
        
        Match__c matchInfo = new Match__c (Name = 'Match Name', Consider_Other_Positions__c = false, Position_Name__c = p1.Id, RecordTypeId = MatchRecordType.ID);
        insert matchInfo;
        
        
        
        
        
        
        test.startTest();
        
        Batch_Match_SOAChange batch = new Batch_Match_SOAChange();
        Database.executeBatch(batch);
        
       
        Database.executeBatch(batch);
        
        test.stopTest();
}
}