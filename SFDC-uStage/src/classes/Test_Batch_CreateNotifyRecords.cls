@isTest(seeAllData=false)
public class Test_Batch_CreateNotifyRecords 
{
	static testMethod void myUnitTest() {
         Account account  = new Account(FirstName = 'Test', LastName = 'HF Account', Status__c = 'Prospect',
                                                    Type = 'Host Family',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test2.com');                                                    
                        
      insert account;
      
        test.startTest();
        
        Batch_CreateNotifyRecords batch = new Batch_CreateNotifyRecords();
        Database.executeBatch(batch);       
        test.stopTest(); 
 }
}