@isTest
public class Test_Batch_SSC {
	static testMethod void myUnitTest() {
		
	//User sysAdmin = [SELECT Id, username FROM User where username=: Constants.SYS_ADMIN LIMIT 1];
      User user = [Select u.Name, u.Id, u.FirstName, u.Email, u.CreatedById, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Name= 'ULM Admin'];
      
    // system.runAs(sysAdmin){
       
         
         RecordType engagementRecordType = [select id, Name from RecordType where SobjectType='Engagement__c' and Name='Ayusa PT' Limit 1];
        
         Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', RecordTypeId = engagementRecordType.Id);
         insert myEngagement;
         
         Account myAccount = new Account(Name='Test');
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
        
         Match__c myMatch =  new Match__c(Name='Testmatch',Match_Type__c = 'Temporary',Engagement__r = myEngagement,Start_Date__c = date.today() +10,Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed',  Engagement__c = myEngagement.Id, Position_Name__c=myPosition.Id, RecordTypeId = matchRecordType.Id);
         insert myMatch;
         
         Assessment__c ObjAssessmentPT = new  Assessment__c();
	       ObjAssessmentPT.Match_Name__c =myMatch.id;
	       ObjAssessmentPT.Engagement__c = myMatch.Engagement__c;
	       ObjAssessmentPT.Position_Name__c = myMatch.Position_Name__r.Id;
	       ObjAssessmentPT.Participant_Name__c = myMatch.Participant_Id__c;
	       ObjAssessmentPT.Host_Name__c =myMatch.Position_Name__r.Host_Company_Id__c;                               
	       ObjAssessmentPT.Name = myMatch.Name + ' PTC';  
	       ObjAssessmentPT.Record_Type_Group__c = 'AY PT Contact'; 
	                    
	       insert ObjAssessmentPT;
		
	List<Assessment__Share> lstAssShare = new List<Assessment__Share>();
  
	Assessment__Share assShare = new Assessment__Share();
	assShare.ParentId = ObjAssessmentPT.Id;
	assShare.UserOrGroupId =user.Id;
	assShare.AccessLevel = 'Edit';
	lstAssShare.add(assShare);
	
  
	test.startTest();
        
    Batch_SSC batch = new Batch_SSC(lstAssShare);
    Database.executeBatch(batch,200);
   
    test.stopTest(); 
	}
}