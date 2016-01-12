@isTest (seeAllData = True)
private class Test_Trigger_Assessment {
 static testMethod void myUnitTest() {
 	 
      User user = [Select u.Name, u.Id, u.FirstName, u.Email, u.CreatedById, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Name= 'ULM Admin'];
     
            RecordType engagementRecordType = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
  
         Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', RecordTypeId = engagementRecordType.Id);
         insert myEngagement;
         
         Account myAccount = new Account(Name='Test', RecordTypeId = hostRecordType[0].Id);
         insert myAccount;
         
         RecordType pa = [SELECT Name, SobjectType,IsPersonType FROM RecordType WHERE SobjectType='Account' AND IsPersonType=True and Name = 'Participant'];
         
         Account myPtAccount = new Account(FirstName='TestPT',LastName='TestPT',personEmail='testpt@test.com',recordTypeId=pa.Id);
         insert myPtAccount;
         
         Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccount.Id, Status__c ='Matching', Country__c = 'United States');
         insert myPosition;
         
         Opportunity op = new Opportunity(Name = 'Test Opportunity', AccountId = myPtAccount.Id, RecordTypeId = '01230000000sboT', 
                                            Type='Participant', Intrax_Programs__c = 'Internship', Intrax_Region__c = 'Europe', 
                                            closeDate = date.today(), StageName = 'Closed Won');
         insert op;
         
         RecordType matchRecordType = [select id, Name from RecordType where SobjectType='Match__c' and Name='Ayusa' Limit 1];                
         
         Match__c myMatch =  new Match__c(Name='Testmatch',Engagement__r = myEngagement,Start_Date__c = date.today() +10,Participant_Opportunity_Id__c = op.Id,Match_Type__c='Permanent',status__c = 'Confirmed', Engagement__c = myEngagement.Id, Position_Name__c=myPosition.Id, RecordTypeId = matchRecordType.Id);
         insert myMatch;
           Test.startTest();
             
               Assessment__c ObjAssessmentPT = new  Assessment__c();
               ObjAssessmentPT.Match_Name__c =myMatch.id;
               ObjAssessmentPT.Engagement__c = myMatch.Engagement__c;
               ObjAssessmentPT.Position_Name__c =myMatch.Position_Name__r.Id;
               ObjAssessmentPT.Participant_Name__c = myMatch.Participant_Id__c;
               ObjAssessmentPT.Host_Name__c = myMatch.Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentPT.Name = myMatch.Name + ' PTC';  
               ObjAssessmentPT.Record_Type_Group__c = 'AY PT Contact'; 
               OBjAssessmentPT.Engagement__c = myEngagement.Id;
               OBjAssessmentPT.Street__c = 'Street';
               ObjAssessmentPT.RecordTypeId = Constants.ASS_AY_Home_Visit;   
               OBjAssessmentPT.Assessment_Date__c = System.today();           
               insert ObjAssessmentPT;
               
               ObjAssessmentPT.ManualShareExists__c = true;
               update ObjAssessmentPT;
               
               ObjAssessmentPT.Status__c = 'Confirmed';
               ObjAssessmentPT.Overall_Assessment__c = 'Positive';
               update OBjAssessmentPT;
           Test.stopTest();
                     
 }
 static testMethod void myUnitTest2() {
 	
      User user = [Select u.Name, u.Id, u.FirstName, u.Email, u.CreatedById, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Name= 'ULM Admin'];
     
         RecordType engagementRecordType = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
         
         Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', RecordTypeId = engagementRecordType.Id);
         insert myEngagement;
                  
        Test.startTest();
             
               Assessment__c ObjAssessmentPT = new  Assessment__c();
               ObjAssessmentPT.Name = 'Test';  
               OBjAssessmentPT.Engagement__c = myEngagement.Id;
               OBjAssessmentPT.Street__c = 'Street';
               ObjAssessmentPT.RecordTypeId = Constants.ASS_WT_PT_Check_In;
               ObjAssessmentPT.Address_Verified__c = true;             
               insert ObjAssessmentPT;
               
               ObjAssessmentPT.ManualShareExists__c = true;
               update ObjAssessmentPT;
               
               ObjAssessmentPT.Status__c = 'Confirmed';
               ObjAssessmentPT.Overall_Assessment__c = 'Positive';
               ObjAssessmentPT.OwnerId = user.Id;
               ObjAssessmentPT.ManualShareExists__c = True;
               update OBjAssessmentPT;
           Test.stopTest();
 }
 
 static testMethod void myUnitTest3() {
 	
      User user = [Select u.Name, u.Id, u.FirstName, u.Email, u.CreatedById, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Name= 'ULM Admin'];
     
         RecordType engagementRecordType = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
         
         Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', RecordTypeId = engagementRecordType.Id);
         insert myEngagement;
                  
         
			   
        Test.startTest();
             
               Assessment__c ObjAssessmentPT = new  Assessment__c();
               ObjAssessmentPT.Name = 'Test';  
               OBjAssessmentPT.Engagement__c = myEngagement.Id;
               OBjAssessmentPT.Street__c = 'Street';
               ObjAssessmentPT.RecordTypeId = Constants.ASS_WT_PT_Check_In;
               ObjAssessmentPT.Address_Verified__c = true;             
               insert ObjAssessmentPT;
               
               Accommodation_Site__c asite = new Accommodation_Site__c();
               asite.Street__c = 'street name';
               insert asite;
               
               Accommodation__c acc = new Accommodation__c();		       
			   acc.Engagement__c = ObjAssessmentPT.Engagement__c;
			   acc.Accommodation_Site__c = asite.Id;
			   insert acc;
		   
               ObjAssessmentPT.ManualShareExists__c = true;
               update ObjAssessmentPT;
               
               ObjAssessmentPT.Status__c = 'Confirmed';
               ObjAssessmentPT.Overall_Assessment__c = 'Positive';
               ObjAssessmentPT.OwnerId = user.Id;
               ObjAssessmentPT.ManualShareExists__c = True;
               update OBjAssessmentPT;
									
           Test.stopTest();
 }
}