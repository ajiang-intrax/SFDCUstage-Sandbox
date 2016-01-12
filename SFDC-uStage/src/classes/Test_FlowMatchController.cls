@isTest(seeAllData=false)
private class Test_FlowMatchController{

    static testMethod void myUnitTest() {
    	
    	 //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', //Account_Id__c = account.Id, 
        //RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant', 
                                                     //Partner_Id__c = partnerAccount.Intrax_Id__c, 
                                                     Program_Duration__c ='1 - 4 weeks',
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes');
        insert engagement;
        
        //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert account;
        
        //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10), Country__c='Australia',
                                                Host_Company_Id__c = account.Id, Status__c='Matching'
                                                );
        insert position;
        
         Opportunity op = new Opportunity(
            Name = 'Test Opportunity', AccountId = account.Id, RecordTypeId = '01230000000sboT', 
            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
            closeDate = date.today(), StageName = 'Closed Won');
        insert op;
        
        
        //Match
    	Match__c match = new Match__c(Name = 'Test Match', 
    									Position_Name__c = position.Id, Status__c = 'Assigned', 
                                    	Engagement__c = engagement.Id, 
                                    	//Portal_Contact_ID__c = contact.Id,
                                    	Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = op.Id);
    	insert match;
        
    	Match__c engRec = new Match__c();
    	ApexPages.StandardController sc = new ApexPages.StandardController(engRec);
    
	     FlowMatchController fmc = new FlowMatchController(sc);
	     fmc.match = match;
	     fmc.getFinishPage();
	     fmc.getFinishPageHome();
	     fmc.getFinishPageValidation();
	     fmc.getFinishPageRematch();
         fmc.getFinishPageAPCMatch();
     
    }
    
}