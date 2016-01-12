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
@isTest(seeAllData=true)
private class Test_SharingSecurityHelper {
/*
    Purpose         :   Test class for RankingtchController.
               
    Created Date    :   06/06/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void myUnitTest() {
        //start testing from here
        Test.startTest();
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
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
                insert appInfo;
                  Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-AY1', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No',Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
             //   insert appInfo1;
        Set<Id> appids = new set<Id>();
          Set<Id> matids = new set<Id>();
           Set<Id> valmatids = new set<Id>();
            Set<Id> confmatids = new set<Id>();
       appids.add(appInfo.Id);
       // appids.add(appInfo1.Id); 
        SharingSecurityHelper.shareApplicant(appids);
      Set<Id> PTAppids = new set<Id>();
      PTAppids.add(appInfo.Id);
      
     SharingSecurityHelper.sharePTAccount(PTAppids);
         User user = [Select u.Name, u.Id, u.FirstName, u.Email, u.CreatedById, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Name= 'ULM Admin'];
     
        
          List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
         List<RecordType> partnerAdminRecordType = [Select Id from RecordType where DeveloperName = 'Partner_Admin' AND SObjectType = 'Account' AND IsActive = true ];
       
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
             //Create a host company record
            Account partnerAdmin = new Account(Name = 'Test - Partner', RecordTypeId = partnerAdminRecordType[0].Id);
            insert partnerAdmin;
            
            Account hostCompany1 = new Account(Name = 'Host1 - Company',type='Host Company', RecordTypeId = hostRecordType[0].Id);
           insert hostCompany1;
           
              Account hostCompany2 = new Account(Name = 'Host2 - Company',type='Host Company', RecordTypeId = hostRecordType[0].Id,parentId=hostCompany1.Id);
           insert hostCompany2;
           
             system.debug('***hostCompany1****'+hostCompany1);
             system.debug('***hostCompany2****'+hostCompany2);
           List<Account> HCAccList =  [Select Intrax_Id__c from Account where Name = 'Host1 - Company' limit 1];
            system.debug('***HCAccList****'+HCAccList);
            
             Contact c = new Contact(FirstName = 'Test', LastName='Contact', accountId=partnerAdmin.Id);
             insert c;
             
              Contact c1 = new Contact(FirstName = 'Test', LastName='Contact', accountId=hostCompany1.Id);
             insert c1;
             
              List<Profile> profiles = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
                List<Profile> HCprofiles = [Select Id from Profile where Name = 'OCPM HC' limit 1];
        
            User PartnerUser = new User(Alias = 'alias', Email = 'testUser0001@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Partner',
                                    Username = Math.random() + '@test.com');
            
            insert PartnerUser;
            
            User PartnerUser1 = new User(Alias = 'alias', Email = 'testUser0002@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = HCprofiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c1.Id, Intrax_Id__c =HCAccList[0].Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
            
            insert PartnerUser1;
           
              system.debug('***PartnerUser1****'+PartnerUser1);
           
            //Insert Host Opportunity
            Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
            insert hostOpportunity;
            
            //Insert Position Instance
            Position__c position1 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3,Country__c='Australia' , Status__c='Matching');
            
            insert position1;
            
              Position__c position2 = new Position__c(Name = 'TestPosition',Country__c='Australia', Host_Company_ID__c = hostCompany1.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3 , Status__c='Matching');
            
            insert position2;  
            
              system.debug('****position2*****'+position2);      
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
            
            //Create test data
            List<Engagement__c> listEngagement = new List<Engagement__c>();
            
             //insert in list
            for(Integer i = 0; i < 2; i++) {
                listEngagement.add(new Engagement__c(name='TestEng'+i,Opportunity_Id__c=listOpportunity[i].Id,  Partner_Id__c=PartnerUser.Intrax_Id__c,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa PT','Engagement__c'),ACCOUNT_ID__C=listAccount[i].Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24)));
            }
            
            //insert data in bulk 
            insert listEngagement;            
          
            //Create matched records with Interview Pending Status
            List<Match__c> matchesForPosition1 = new List<Match__c>();
            List<Match__c> matchesForPosition2 = new List<Match__c>();
              Campaign testCamp1= new Campaign(Name='TestCamp1',Partner_Name__c=partnerAdmin.Id);
            insert testCamp1;         
            //loop through the opportunity and add records in the list
            Integer i = 0;
            for(Opportunity opp : listOpportunity)
            {
                if(i < 1)
                {
                matchesForPosition1.add(new Match__c(Name = 'Test', Engagement__c = listEngagement[i].Id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position1.Id, Status__c = 'Interview Pending', Interview_Date__c = Date.today() + 1));
                i++;
                matchesForPosition2.add(new Match__c(Name = 'Test', Engagement__c = listEngagement[i].Id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position2.Id, Status__c = 'Interview Pending',Campaign__c=testCamp1.Id));
                }
                 
            }
            
            //insert matches data'
            insert matchesForPosition1;
            insert matchesForPosition2;
            system.debug('****matchesForPosition2*****'+matchesForPosition2);
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
               ObjAssessmentHF.Position_Name__c = matchesForPosition1[0].Position_Name__r.Id;
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
            
         SharingSecurityHelper.shareAssessment(assIds);
         
         
          Engagement__c hostEngagement = new Engagement__c(Name = 'TestHost - Opp', Account_Id__c = hostCompany.Id, Status__c = 'Test',Placement_Status__c = 'Not Placed' ,
                                                            Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostEngagement;
         
          set<Id> NewEngids = new set<Id>();
              set<Id> Engids = new set<Id>();
               set<Id> CREngIds = new set<Id>();
             NewEngids.add(hostEngagement.Id);  
               Engids.add(hostEngagement.Id);  
                 CREngIds.add(hostEngagement.Id);  
               
                SharingSecurityHelper.shareEngagement(NewEngids,Engids,CREngIds);
                
                Set<Id> ContactIds = new set<Id>();
                ContactIds.add(c.Id);
                  Set<Id> HCContactIds = new set<Id>();
                HCContactIds.add(c1.Id);
                  Set<Id> HCPositionIds = new set<Id>();
                  HCPositionIds.add(position1.Id);
                  HCPositionIds.add(position2.Id);
                  system.debug('***HCPositionIds******'+HCPositionIds);
                SharingSecurityHelper.sharePartnerContact(ContactIds);
                SharingSecurityHelper.shareHCPortalContact(HCContactIds);
                 SharingSecurityHelper.shareHCPortalContactPositions(HCPositionIds);
                 
                 Test.stoptest();
                 
                 
             SharingSecurityHelper.shareWTParticipant(appids);
            //testCampPos.Campaign__c = testCamp1.id;
       
        }
    static testMethod void myUnitTest1() {
        //start testing from here
        Test.startTest(); 
         List<RecordType> partnerAdminRecordType = [Select Id from RecordType where DeveloperName = 'Partner_Admin' AND SObjectType = 'Account' AND IsActive = true ];
         List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
     
            //Create a host company record
            Account hostCompany = new Account(Name = 'Host - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
            
             //Create a host company record
            Account partnerAdmin = new Account(Name = 'Test - Partner', RecordTypeId = partnerAdminRecordType[0].Id);
            insert partnerAdmin;
            
            Account hostCompany1 = new Account(Name = 'Host1 - Company',type='Host Company', RecordTypeId = hostRecordType[0].Id);
           insert hostCompany1;  
           
             Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today());
            insert hostOpportunity;
           
            Position__c position1 = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Test', Intrax_Program_Options__c = 'Test', Engagement_Start__c = Date.today() + 3,Country__c='Australia' );
            
            insert position1;
            
            Campaign testCamp1= new Campaign(Name='TestCamp1',Partner_Name__c=partnerAdmin.Id);
            insert testCamp1;
            
            Campaign_Position__c testCampPos= new  Campaign_Position__c(Name='TestCampPos',Campaign__c=testCamp1.Id,position__c= position1.Id);
            insert testCampPos;
            set<Id> CampPosIds = new set<Id>();
             set<Id> CampSessionIds = new set<Id>();
            
            Campaign_Session__c testCampSession= new  Campaign_Session__c(Campaign__c=testCamp1.Id,Host_Company_Name__c=hostCompany.Id);
            insert testCampSession;            
           
            
            CampPosIds.add(testCampPos.Id);
            CampSessionIds.add(testCampSession.Id);
             SharingSecurityHelper.shareCampaignPosition(CampPosIds);
              SharingSecurityHelper.shareCampSessions(CampSessionIds);
              
               List<Profile> profiles = [Select p.Name, p.Id From Profile p where p.Name='Intrax Standard User' limit 1];
          
         
               User StdUser = new User(Alias = 'alias', Email = 'testUser0003@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    Intrax_Id__c ='Test',type__c='Partner',ManualShareExists__c=false,
                                    Username = Math.random() + '@test.com');
            
               insert StdUser;
         
            set<Id> StdUserIds =  new set<Id>();
            set<String> StdUserIntaxIds = new set<string>();
            StdUserIds.add(StdUser.Id);
           StdUserIntaxIds.add(StdUser.Intrax_Id__c); 
            SharingSecurityHelper.shareStandardUser(StdUserIds,StdUserIntaxIds); 
        Test.stoptest();  
    }
static Id getRecordType(String rtName,String sObjectName){
    List<RecordType> rt = [select Id from RecordType where sObjectType = :sObjectName and name = :rtName ];
    if (rt.size() > 0){
        return rt[0].Id;
    }
    else{
        return null;
    }
}        
}