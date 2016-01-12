@isTest(seeAllData=false)
private class Test_AssessmentPage{

    static testMethod void myUnitTest() {
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
        
         Match__c myMatch =  new Match__c(Name='Testmatch',Match_Type__c = 'Temporary',Engagement__r = myEngagement,Position_Name__r = myPosition,Start_Date__c = date.today() +10,Participant_Opportunity_Id__c = op.Id, Status__c = 'Confirmed',  Engagement__c = myEngagement.Id, Position_Name__c=myPosition.Id, RecordTypeId = matchRecordType.Id);
         insert myMatch;
         
           Assessment__c ObjAssessmentHF = new  Assessment__c();
               ObjAssessmentHF.Match_Name__c =myMatch.id;
               ObjAssessmentHF.Engagement__c = myMatch.Engagement__c;
               ObjAssessmentHF.Position_Name__c = myMatch.Position_Name__r.Id;
               ObjAssessmentHF.Participant_Name__c = myMatch.Participant_Id__c;
               ObjAssessmentHF.Host_Name__c = myMatch.Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentHF.Name = myMatch.Name + ' HFC';  
               ObjAssessmentHF.Record_Type_Group__c = 'AY HF Contact'; 
                            
               insert ObjAssessmentHF;
         test.starttest();
     AssessmentPage ng = new AssessmentPage();
     Assessment__c ng1= new Assessment__c();
    
    // ang1.assId = ObjAssessmentHF.Id;
   //  ang1.ass = ObjAssessmentHF;
     ApexPages.currentPage().getParameters().put('id',ObjAssessmentHF.Id);
     ApexPages.StandardController sc = new ApexPages.StandardController(ng1);
    
     AssessmentPage ang1 = new AssessmentPage(sc);
     Pagereference pg = ang1.cancel();
     test.stoptest();
    }
    
}