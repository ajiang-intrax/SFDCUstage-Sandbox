/*
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ReAssign_Controller {
/*
    Purpose         :   Test class for RankingtchController.
               
    Created Date    :   06/06/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void myUnitTest() {
        //start testing from here
        Test.startTest();
        
                
        Set<Id> appids = new set<Id>();
          Set<Id> matids = new set<Id>();
           Set<Id> valmatids = new set<Id>();
            Set<Id> confmatids = new set<Id>();
       
     
     // SharingSecurityHelper.sharePTAccount(PTAppids);
         User user = [Select u.Name, u.Id, u.FirstName, u.Email, u.CreatedById, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Name= 'ULM Admin'];
     
       
          List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
            insert hostOpportunity;
            
            Engagement__c hostEngagement = new Engagement__c(Name = 'TestHost - Opp', Account_Id__c = hostCompany.Id, Status__c = 'Test',Placement_Status__c = 'Not Placed' ,
                                                            Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostEngagement;
           
            //Insert Position Instance
            Position__c position1 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3,Engagement__c= hostEngagement.Id,Country__c='Australia', Status__c = 'Matching');
            
            insert position1;
              Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Home_Responsibilities__c = 'Test',Partner_Intrax_Id__c='I-102345',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No',Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',Position__c=position1.Id);
                insert appInfo;
                     
            //Create test data
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 2; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType[0].Id, PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            
            //Create list of opportunities
            List<Opportunity> listOpportunity = new List<Opportunity>();
            
            //insert in list
            for(Account acc : listAccount) {
                listOpportunity.add(new Opportunity(Name = 'Test', AccountId = acc.Id, CloseDate = Date.Today(), Project_Name__c = 'test',
                                                    App_Fee_Paid__c = true, Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', 
                                                    Engagement_Start__c = Date.today(), StageName = 'Closed Won'));
            }
            
            insert listOpportunity;
          
            //Create matched records with Interview Pending Status
            List<Match__c> matchesForPosition1 = new List<Match__c>();
            List<Match__c> matchesForPosition2 = new List<Match__c>();
            map<Integer, Match__c> mapMatch = new map<Integer, Match__c>();
            Integer i = 0;
            //loop through the opportunity and add records in the list
            for(Opportunity opp : listOpportunity){
                i = i++;
                mapMatch.put(i, new Match__c(Name = 'Test',Engagement__c=hostEngagement.ID, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Interview Pending', Interview_Date__c = Date.today() + 1));
                //matchesForPosition1.add(new Match__c(Name = 'Test',Engagement__c=hostEngagement.ID, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Interview Pending', Interview_Date__c = Date.today() + 1));
               // matchesForPosition2.add(new Match__c(Name = 'Test', Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position2.Id, Status__c = 'Interview Pending' ));
            }
            matchesForPosition1 = mapMatch.values();
            //insert matches data'
            insert matchesForPosition1;
            matids.add(matchesForPosition1[0].id);
            valmatids.add(matchesForPosition1[0].id);
            confmatids.add(matchesForPosition1[0].id);
             SharingSecurityHelper.shareMatch(matids, valmatids, confmatids);
             
               Assessment__c ObjAssessmentPT = new  Assessment__c();
               ObjAssessmentPT.Match_Name__c =matchesForPosition1[0].id;
               ObjAssessmentPT.Engagement__c = matchesForPosition1[0].Engagement__c;
               ObjAssessmentPT.Position_Name__c = matchesForPosition1[0].Position_Name__r.Id;
               ObjAssessmentPT.Participant_Name__c = matchesForPosition1[0].Participant_Id__c;
               ObjAssessmentPT.Host_Name__c = matchesForPosition1[0].Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentPT.Name = matchesForPosition1[0].Name + ' PTC';  
               ObjAssessmentPT.Record_Type_Group__c = 'AY PT Contact'; 
                            
               insert ObjAssessmentPT; 
               
               
                  Assessment__c ObjAssessmentHF = new  Assessment__c();
               ObjAssessmentHF.Match_Name__c =matchesForPosition1[0].id;
               ObjAssessmentHF.Engagement__c = matchesForPosition1[0].Engagement__c;
               ObjAssessmentHF.Position_Name__c = position1.Id;
               ObjAssessmentHF.Participant_Name__c = matchesForPosition1[0].Participant_Id__c;
               ObjAssessmentHF.Host_Name__c = matchesForPosition1[0].Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentHF.Name = matchesForPosition1[0].Name + ' HFC';  
               ObjAssessmentHF.Record_Type_Group__c = 'AY HF Contact'; 
                            
               insert ObjAssessmentHF;
               
                Assessment__c ObjAssessmentSC = new  Assessment__c();
               ObjAssessmentSC.Match_Name__c =matchesForPosition1[0].id;
               ObjAssessmentSC.Engagement__c = matchesForPosition1[0].Engagement__c;
               ObjAssessmentSC.Position_Name__c = matchesForPosition1[0].Position_Name__r.Id;
               ObjAssessmentSC.Participant_Name__c = matchesForPosition1[0].Participant_Id__c;
               ObjAssessmentSC.Host_Name__c = matchesForPosition1[0].Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentSC.Name = matchesForPosition1[0].Name + ' SCC';  
               ObjAssessmentSC.Record_Type_Group__c = 'AY SC Contact'; 
                            
               insert ObjAssessmentSC;
              
             set<Id> assIds = new set<Id>();
             assIds.add(ObjAssessmentPT.Id);
              assIds.add(ObjAssessmentHF.Id);
              assIds.add(ObjAssessmentSC.Id);
            
      
         
         
         
         
          set<Id> NewEngids = new set<Id>();
              set<Id> Engids = new set<Id>();
               set<Id> CREngIds = new set<Id>();
             NewEngids.add(hostEngagement.Id);  
               Engids.add(hostEngagement.Id);  
                 CREngIds.add(hostEngagement.Id); 
          
          Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-AY1', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No',Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Account__c=listAccount[0].Id,Engagement__c=hostEngagement.Id,
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
          insert appInfo1;
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        Contact co = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId =: listAccount[0].Id ];
        
        User user1 = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    User_Interests__c ='Becoming a high school exchange student',Type__c = 'Participant',
                                    ContactId = co.Id, Dummy_LookUp__c = user.Id,
                                    Username = Math.random() + '@test.com');
                                    
        insert user1;
         ApexPages.StandardController sc1 = new ApexPages.StandardController(position1);
           
         ReAssign_Owner_Controller roc = new ReAssign_Owner_Controller(sc1);
         
         roc.DummyObj = user1;
         User u=roc.getDummyObj();
              roc.save(); 
             roc.cancel(); 
          ApexPages.StandardController sc2 = new ApexPages.StandardController(appInfo1);     
           ReAssign_Owner_AppInfo_Controller roc1 = new ReAssign_Owner_AppInfo_Controller(sc2);  
            roc1.DummyObj = user1;
         User u1=roc1.getDummyObj();
              roc1.save(); 
              roc1.cancel();
           
               //ChangeRelatedOwners();
        }

}