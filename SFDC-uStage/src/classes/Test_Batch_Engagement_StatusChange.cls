@isTest(seeAllData=false)
public class Test_Batch_Engagement_StatusChange 
{
	static testMethod void myUnitTest() {
        // TO DO: implement unit test
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        Account account  = new Account(Name = 'AYUSA PT User', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Business_License_Expires__c = (date.today() - 35), Workers_Comp_Expires__c = (date.today() - 60),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
        insert account;
        
        RecordType WTengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
                
        Engagement__c WTengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = date.today(), Engagement_End__c = (date.today() + 100),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        insert WTengagement;
        
        Engagement__c WTengagement1 = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = account.Id, 
                                                        RecordTypeId = WTengagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 10), Engagement_End__c = date.today(),
                                                        //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'On Program', Needs_Travel__c ='Yes');
        insert WTengagement1; 
        
        
        
        test.startTest();
        
        Batch_Engagement_StatusChange batch = new Batch_Engagement_StatusChange();
        Database.executeBatch(batch);
        
       
        Database.executeBatch(batch);
        
        test.stopTest();
}
}