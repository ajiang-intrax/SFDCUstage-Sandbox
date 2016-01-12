@isTest(seeAllData=true)
private class Test_AssessmentBulkCreateController {

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
       //  myEngagement.Program_Duration__c = 'Academic Year';
        // update myEngagement;
         
         system.debug('********* myMatch: ' + myMatch.Engagement__c);
         system.debug('********* myMatch: ' + myMatch.Engagement__r.Program_Duration__c);
       Test.startTest();
         
         AssessmentBulkCreateController abcc = new AssessmentBulkCreateController();
         
        List<Match__c> matchList = new List<Match__c>();
        matchList.add(myMatch);
        abcc.confMatch = myMatch;
        // abcc.confMatch.Engagement__r.Program_Duration__c = 'Academic Year';
        abcc.BulkCreate(matchlist);
         
         abcc.GetSCStartingCount(myMatch,'August');
         
         abcc.GetSCStartingCount(myMatch,'October');
         abcc.GetSCStartingCount(myMatch,'December');
         abcc.GetSCStartingCount(myMatch,'March');
         abcc.GetStartingCount(myMatch,'January');
         abcc.GetStartingCount(myMatch,'February');
         abcc.GetStartingCount(myMatch,'March');
         abcc.GetStartingCount(myMatch,'April');
         abcc.GetStartingCount(myMatch,'May');
         abcc.GetStartingCount(myMatch,'June');
         abcc.GetStartingCount(myMatch,'July');
         abcc.GetStartingCount(myMatch,'August');
         abcc.GetStartingCount(myMatch,'September');
         abcc.GetStartingCount(myMatch,'October');
         abcc.GetStartingCount(myMatch,'November');
         abcc.GetStartingCount(myMatch,'December');
         
         myEngagement.Program_Duration__c = 'Spring Semester';
         
         //AA
         abcc.GetSCStartingCount(myMatch,'December');
         abcc.GetSCStartingCount(myMatch,'March');
         
         update myEngagement;
         abcc.GetStartingCount(myMatch,'January');
         abcc.GetStartingCount(myMatch,'February');
         abcc.GetStartingCount(myMatch,'March');
         abcc.GetStartingCount(myMatch,'April');
         abcc.GetStartingCount(myMatch,'May');
         abcc.GetStartingCount(myMatch,'June');
         abcc.GetStartingCount(myMatch,'July');
         //AA
         abcc.GetSCTimePeriod(myMatch,2);
         abcc.GetSCTimePeriod(myMatch,1);
         
         myEngagement.Program_Duration__c = 'Fall Semester';
         //AA
         abcc.GetSCStartingCount(myMatch,'August');
         abcc.GetSCStartingCount(myMatch,'October');
         update myEngagement;
         
         abcc.GetStartingCount(myMatch,'August');
         abcc.GetStartingCount(myMatch,'September');
         abcc.GetStartingCount(myMatch,'October');
         abcc.GetStartingCount(myMatch,'November');
         abcc.GetStartingCount(myMatch,'December');
         abcc.GetStartingCount(myMatch,'January');
         abcc.GetStartingCount(myMatch,'February');
         abcc.GetMonthName(myMatch,6);
         abcc.GetMonthName(myMatch,5);
         abcc.GetMonthName(myMatch,4);
         abcc.GetMonthName(myMatch,3);
         abcc.GetMonthName(myMatch,2);
         abcc.GetMonthName(myMatch,1);
         //AA
         abcc.GetSCTimePeriod(myMatch,2);
         abcc.GetSCTimePeriod(myMatch,1);
        
         
         myEngagement.Program_Duration__c = 'Academic Year';
         update myEngagement;
         
         abcc.GetSCTimePeriod(myMatch,4);
         abcc.GetSCTimePeriod(myMatch,3);
         abcc.GetSCTimePeriod(myMatch,2);
         abcc.GetSCTimePeriod(myMatch,1);
         abcc.GetMonthName(myMatch,11);
         abcc.GetMonthName(myMatch,10);
         abcc.GetMonthName(myMatch,9);
         abcc.GetMonthName(myMatch,8);
         abcc.GetMonthName(myMatch,7);
         abcc.GetMonthName(myMatch,6);
         abcc.GetMonthName(myMatch,5);
         abcc.GetMonthName(myMatch,4);
         abcc.GetMonthName(myMatch,3);
         abcc.GetMonthName(myMatch,2);
         abcc.GetMonthName(myMatch,1);
         //now the fun
         
        abcc.GetStartMonthName(12);
        abcc.GetStartMonthName(11);
        abcc.GetStartMonthName(10);
        abcc.GetStartMonthName(9);
        abcc.GetStartMonthName(8);
        abcc.GetStartMonthName(7);
        abcc.GetStartMonthName(6);
        abcc.GetStartMonthName(5);
        abcc.GetStartMonthName(4);
        abcc.GetStartMonthName(3);
        abcc.GetStartMonthName(2);
        abcc.GetStartMonthName(1);
    
    //User sysAdmin = [select id from User where username = :Constants.SYS_ADMIN];

        abcc.CreatePTAssessment(myMatch,10,user.Id);
        abcc.CreateSCAssessment(myMatch,10,user.Id);
        abcc.CreateHFAssessment(myMatch,10,user.Id);
        //abcc.UpdatePTAssessment(myMatch,4,user.Id);
        //abcc.UpdateSCAssessment(myMatch,4,user.Id);
       // abcc.UpdateHFAssessment(myMatch,4,user.Id);
       /// List<Match__c> matchList = new List<Match__c>();
       // matchList.add(myMatch);
       // abcc.BulkCreate(matchlist);
           Assessment__c ObjAssessmentPT = new  Assessment__c();
               ObjAssessmentPT.Match_Name__c =myMatch.id;
               ObjAssessmentPT.Engagement__c = myMatch.Engagement__c;
               ObjAssessmentPT.Position_Name__c = myMatch.Position_Name__r.Id;
               ObjAssessmentPT.Participant_Name__c = myMatch.Participant_Id__c;
               ObjAssessmentPT.Host_Name__c =myMatch.Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentPT.Name = myMatch.Name + ' PTC';  
               ObjAssessmentPT.Record_Type_Group__c = 'AY PT Contact'; 
                            
               insert ObjAssessmentPT; 
          AssessmentBulkCreateController abcc1 = new AssessmentBulkCreateController();
         
        List<Match__c> matchList1 = new List<Match__c>();
        matchList1.add(myMatch);
        abcc1.confMatch = myMatch;
        // abcc.confMatch.Engagement__r.Program_Duration__c = 'Academic Year';
        abcc1.BulkCreate(matchlist1);
        
        
          Assessment__c ObjAssessmentHF = new  Assessment__c();
               ObjAssessmentHF.Match_Name__c =myMatch.id;
               ObjAssessmentHF.Engagement__c = myMatch.Engagement__c;
               ObjAssessmentHF.Position_Name__c = myMatch.Position_Name__r.Id;
               ObjAssessmentHF.Participant_Name__c = myMatch.Participant_Id__c;
               ObjAssessmentHF.Host_Name__c = myMatch.Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentHF.Name = myMatch.Name + ' HFC';  
               ObjAssessmentHF.Record_Type_Group__c = 'AY HF Contact'; 
                            
               insert ObjAssessmentHF;
               
      AssessmentBulkCreateController abcc2 = new AssessmentBulkCreateController();
         
        List<Match__c> matchList2 = new List<Match__c>();
        matchList2.add(myMatch);
        abcc2.confMatch = myMatch;
        // abcc.confMatch.Engagement__r.Program_Duration__c = 'Academic Year';
        Test.stopTest();
        system.runAs(user){
        abcc2.BulkCreate(matchlist2);
        }
     
    }
    
    
}