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
private class Test_Sharing_Security_Controller {
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
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No',Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
                insert appInfo;
                
              List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
         List<RecordType> hostRecordType1 = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
            Account hostCompany = new Account(Name = 'TestHost - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
           
             Position__c position = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id,Tipped_Position__c='No', 
                                                    Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(),Country__c='Australia',Engagement_End__c = date.today().addDays(15), Status__c='Matching' );
            
            insert position;
            
            set<Id> PosIds =  new set<Id>();
            PosIds.add(position.Id);
            
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
            
             List<RecordType> partnerAdminRecordType = [Select Id from RecordType where DeveloperName = 'Partner_Admin' AND SObjectType = 'Account' AND IsActive = true ];
            
            Account partnerAdmin = new Account(Name = 'Test - Partner', RecordTypeId = partnerAdminRecordType[0].Id);
            insert partnerAdmin;
            
             Contact c = new Contact(FirstName = 'Test', LastName='Contact', accountId=partnerAdmin.Id);
             insert c;
             
            List<Profile> profiles = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
            User PartnerUser = new User(Alias = 'alias', Email = 'testUser000@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Partner',
                                    Username = Math.random() + '@test.com');
            
            insert PartnerUser;
            	//Create test data
            List<Engagement__c> listEngagement = new List<Engagement__c>();
            
             //insert in list
             
            for(Integer i = 0; i < 2; i++) {
                listEngagement.add(new Engagement__c(name='TestEng'+i,Opportunity_Id__c=listOpportunity[i].Id,	Partner_Id__c=PartnerUser.Intrax_Id__c,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa PT','Engagement__c'),ACCOUNT_ID__C=listAccount[i].Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24)));
            }
            
            insert listEngagement;
          
            //Create matched records with Interview Pending Status
            List<Match__c> matchesForPosition1 = new List<Match__c>();
            List<Match__c> matchesForPosition2 = new List<Match__c>();
            
            //loop through the opportunity and add records in the list
            Integer i = 0;
            for(Opportunity opp : listOpportunity){
            	if(i < 1)
            	{
                matchesForPosition1.add(new Match__c(Name = 'Test', Engagement__c = listEngagement[i].Id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position.Id, Status__c = 'Interview Pending', Interview_Date__c = Date.today() + 1));
               // matchesForPosition2.add(new Match__c(Name = 'Test', Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position2.Id, Status__c = 'Interview Pending' ));
               i++;
            	}
            }
            
            //insert matches data'
            insert matchesForPosition1;
            
             Assessment__c ObjAssessmentPT = new  Assessment__c();
               ObjAssessmentPT.Match_Name__c =matchesForPosition1[0].id;
               ObjAssessmentPT.Engagement__c = matchesForPosition1[0].Engagement__c;
               ObjAssessmentPT.Position_Name__c = matchesForPosition1[0].Position_Name__r.Id;
               ObjAssessmentPT.Participant_Name__c = matchesForPosition1[0].Participant_Id__c;
               ObjAssessmentPT.Host_Name__c = matchesForPosition1[0].Position_Name__r.Host_Company_Id__c;                               
               ObjAssessmentPT.Name = matchesForPosition1[0].Name + ' PTC';  
               ObjAssessmentPT.Record_Type_Group__c = 'AY PT Contact'; 
                            
               insert ObjAssessmentPT; 
                
            //Insert Host Opportunity
            Engagement__c hostEngagement = new Engagement__c(Name = 'TestHost - Opp', Account_Id__c = hostCompany.Id, Status__c = 'Test',Placement_Status__c = 'Not Placed' ,
                                                            Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostEngagement;
            
             Person_Info__c emergencyContact = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c = 'test@myT.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert emergencyContact;
        User user = [Select u.Name, u.Id, u.FirstName, u.Email, u.CreatedById, u.ContactId, u.City, u.Account__c, u.AccountId From User u where u.Name= 'ULM Admin'];
                  //instantiate controller 
           List<User> lstUsr = new list<User>();
           lstUsr.add(user);
            List<Assessment__c> lstAss = new  List<Assessment__c> ();
             lstAss.add(ObjAssessmentPT);
             set<Id> AssessmentIds =  new set<Id>();
             AssessmentIds.add(ObjAssessmentPT.Id);
            Map<Id,Id> SharePTAssessmentMap = new Map<Id,Id>();
            SharePTAssessmentMap.put(ObjAssessmentPT.Id,user.Id);
            List<Applicant_Info__c> lstApp = new list<Applicant_Info__c>();
            lstApp.add(appInfo);
            Sharing_Security_Controller controller = new Sharing_Security_Controller(new ApexPages.StandardController(appInfo));
           controller.shareRecord();
             Sharing_Security_Controller.shareRecord(appInfo.Id);
             Sharing_Security_Controller.shareApplicantRecord(appInfo.Id,user.Id);
             Sharing_Security_Controller.shareRecord(lstApp);
             Sharing_Security_Controller.shareApplicantRecord(lstApp,user.Id);
             List<User> lstappuser = new list<User>();
             lstappuser.add(user);
             Sharing_Security_Controller.shareApplicantRecord(appInfo.Id,lstappuser);
             Sharing_Security_Controller.shareRecordGuestUsers(appInfo.Id);
             Sharing_Security_Controller.sharePartnerApplicant(appInfo.Id,user.Id);
           List<Engagement__c> lstEng = new list<Engagement__c>();
           lstEng.add(hostEngagement);
              // Sharing_Security_Controller.sharePartnerRoleUp(lstApp,user.Id);
                  Sharing_Security_Controller.shareEngPartnerApplicant(lstEng,user.Id);
                     Sharing_Security_Controller.shareEngRecordToCRs(hostEngagement.Id);
                      Sharing_Security_Controller.shareEngRecord(hostEngagement.Id,user.Id);
                      Sharing_Security_Controller.sharePositionRecord(position.Id,user.Id);
                      Sharing_Security_Controller.shareEngMatchPositionApplicant(position.Id,user.Id);
                      Sharing_Security_Controller.sharePosRecordGuestUsers(position.Id);
                      Sharing_Security_Controller.sharePosPartnerApplicant(position.Id,user.Id);
                      Sharing_Security_Controller.shareMatRecord(position.Id,user.Id);
                      Sharing_Security_Controller.tagApplicationToAccAndOrLead(emergencyContact);
                       Sharing_Security_Controller.shareEngAccountRecordToCRs(hostCompany.Id);
                         Sharing_Security_Controller.shareAccount(hostCompany.Id,user.Id);
                         set<Id> accId = new set<Id>();
                         accId.add(hostCompany.Id);
                         Sharing_Security_Controller.shareAccount(accId,user.Id);
                           Sharing_Security_Controller.shareAccount(hostCompany.Id,lstappuser);
                          Sharing_Security_Controller.shareMatchAccountRecord(hostCompany.Id,user.Id);
                           Sharing_Security_Controller.shareAssessment(SharePTAssessmentMap);
                            
                             Group  grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.Name ='Guest Users'];
   
                            Sharing_Security_Controller.shareAssessmentWithPublicGroup(grp.Id,lstAss);
                             Sharing_Security_Controller.shareAssessment(ObjAssessmentPT.Id,user.Id);
               
                Sharing_Security_Controller.sharePositionRecord(position.Id,lstUsr);
                Sharing_Security_Controller.sharePositionAccountRecord(listAccount[0].Id,lstUsr);
                Sharing_Security_Controller.shareEngMatchPositionApplicant(PosIds,user.Id);
                Sharing_Security_Controller.shareEngMatchAssessment(AssessmentIds,user.Id);
                Sharing_Security_Controller.shareStdUsrEngMatchAssessment(AssessmentIds,user.Id);
                
                  
                Sharing_Security_Controller.shareROApplicantRecord(appInfo.Id, lstUsr);
                Sharing_Security_Controller.shareROApplicantRecord(lstApp, user.Id);
                Sharing_Security_Controller.shareROEngMatchPositionApplicant(PosIds, user.Id);              
                Sharing_Security_Controller.shareROPositionRecord(position.Id,lstUsr);
                
                set<Id> engIds = new set<Id>();
                engIds.add(hostEngagement.Id);
                
                set<Id> accIds = new set<Id>();
                accIds.add(hostCompany.Id);
                
                Set<Id> UserIds = new set<Id>();
                UserIds.add(user.Id);
                Sharing_Security_Controller.shareEngagements(engIds,user.Id);
              //Sharing_Security_Controller.sharePartnerRoleUp(appInfo.Id, UserIds);
               Sharing_Security_Controller.shareEngRecord(hostEngagement.Id, lstUsr);
               Sharing_Security_Controller.shareHCPosHCUsers(PosIds, lstUsr);
                 Sharing_Security_Controller.shareHCAccHCUsers(accIds, lstUsr);
                 Sharing_Security_Controller.shareHCEngHCUsers(engIds, lstUsr);
                 // List<RecordType> partnerAdminRecordType = [Select Id from RecordType where DeveloperName = 'Partner_Admin' AND SObjectType = 'Account' AND IsActive = true ];
         
                  //Account partnerAdmin = new Account(Name = 'Test - Partner', RecordTypeId = partnerAdminRecordType[0].Id);
           // insert partnerAdmin;
                  Campaign testCamp1= new Campaign(Name='TestCamp1',Partner_Name__c=partnerAdmin.Id);
            insert testCamp1;            
           
             set<Id> CampSessionIds = new set<Id>();
            
            Campaign_Session__c testCampSession= new  Campaign_Session__c(Campaign__c=testCamp1.Id,Host_Company_Name__c=hostCompany.Id);
            insert testCampSession;            
           
            CampSessionIds.add(testCampSession.Id);
                 
              Sharing_Security_Controller.shareHCCampSessionHCUsers(CampSessionIds, user.Id);
              Sharing_Security_Controller.shareHCCampSessionHCUsers(CampSessionIds, lstUsr);
                Sharing_Security_Controller.shareEngPartnerApplicant(hostEngagement.Id, user.Id);
                
                Lead lr = new Lead(LastName ='Test',email='test@myT.com',Intrax_Programs__c='Ayusa',
        Intrax_Program_Options__c = 'Ayusa High School',Lead_Type__c='Host Family',IsConverted = false);
        insert lr;
        
            Sharing_Security_Controller.tagApplicationToAccAndOrLead(emergencyContact);
            
           
            //stop test here
            Test.stopTest();
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
    
    static testMethod void UnitTestSelecTrig() 
    {
        //Account Creation
        Account myAccountHF = new Account(Name='Test');
        insert myAccountHF;
        

        //Position    
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccountHF.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
        
        //Engagment
        Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year');
      	insert myEngagement;
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        //Applicant Info HF
        Applicant_Info__c appInfoHF = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                            Postal_Code__c = '12345',  Type__c = 'Host Family',
                                                            Country__c = 'United States', Home_Phone__c = '12345',
                                                            //Partner_Intrax_Id__c = portalAccount.Intrax_Id__c,
                                                            Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                            Intrax_Program__c = 'AuPairCare', Account__c = myAccountHF.id,
                                                            RecordTypeId = rtAPC.Id, Position__c= myPosition.id,Engagement__c=myEngagement.id, CreatedBy__c=sysAdmin.id, 
                                                            Primary_Language__c = 'English');
        insert appInfoHF;
        
        //Selection
        Selection__c selec = new Selection__c(Name='TestSelection',Position__c=myPosition.id,Engagement__c=myEngagement.id);
        insert selec;
    }
    
        }