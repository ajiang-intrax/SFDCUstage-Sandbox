/**
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
@isTest(seeAllData=false)
public class Test_apc_match_controller {
    
    static testMethod void myUnitTest() {
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        APC_Program_Settings__c ps = new APC_Program_Settings__c(OSAP_Interview_Extension_Hours__c = 24);
        insert ps;
        
       //APC  PT--
        //Record Type
         RecordType rtaccpt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rtaccpt.Id, Type = 'Partner');
        insert account;
         
       //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //AA Record Type (APCPT)
        RecordType rtAPCPT = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Contact
        Contact contact2 = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact2;
        
         //Portal User
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                             LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                             ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                             ContactId = contact2.Id, Intrax_Id__c ='Test',
                             Username = Math.random() + '@test.com', User_Interests__c='Becoming an au pair');
        
        insert user;
        
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
        
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
       
       Engagement__c myEngagement_2 = new Engagement__c(
         Name='TestEngagement',Partner_Account__c=account.id ,  Program_Duration__c = 'Academic Year', Type__c = 'Participant', Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized',
         Gender__c = 'Male', Actual_Arrival__c = date.today() + 100, Driving_Frequency__c = 'Sometimes (2-3 days per week)', OwnerId=sysAdmin.Id, Status__c = 'On Program',
         Language_1__c = 'Spanish', Driving_Experience__c = 'City', Allergies_Indicated__c = 'Yes', Drivers_Licence_Indicated__c = 'Yes', Swimming_Indicated__c = 'Yes'
       );
      insert myEngagement_2;
      
        //Record Type
        RecordType rtHF = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        RecordType rteng = [select id,Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        //Account
        Account accountEng  = new Account(OwnerId = UserInfo.getUserId(),FirstName='testfirst',lastName = 'Testlast',PersonEmail='aa@test.com',PersonHomePhone='2345678977', RecordTypeId = rteng.Id, Type = 'Host Family');
        insert accountEng;
        
        Engagement__c myEngagement_1 = new Engagement__c(
          Name='TestEngagement',Account_Id__c=accountEng.id ,  Program_Duration__c = 'Academic Year', Type__c = 'Participant', Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized',
          Gender__c = 'Male', Actual_Arrival__c = date.today() + 100, Driving_Frequency__c = 'Sometimes (2-3 days per week)', OwnerId=sysAdmin.Id, Status__c = 'On Program',
          Language_1__c = 'Spanish', Driving_Experience__c = 'City', Allergies_Indicated__c = 'Yes', Drivers_Licence_Indicated__c = 'Yes', Swimming_Indicated__c = 'Yes'
       );
      insert myEngagement_1;
        
        //AA Applicant Info APCPT
        Applicant_Info__c appInfoAPCPT = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                               Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                               Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',Intrax_Program_Category__c='Business',
                                                               Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                               Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
                                                               Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                               Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',Allow_Intrax_To_Apply__c=True,
                                                               Parent_Marital_Status__c = 'Separated', GPA_Self_Reported__c = 'Test',
                                                               Home_Country__c = 'United States',
                                                               Being_AuPair_Indicated__c ='Yes', 
                                                               AP_Completion_Year_Indicated__c = 'No',
                                                               Visa_Denied__c = 'Yes',
                                                               Visa_Type__c = 'J-1', 
                                                               US_Passport_Indicated__c = 'Yes',
                                                               Childcare_Experience_Indicated__c ='No',
                                                               Drivers_Licence_Indicated__c = 'No',
                                                               Curfew_Indicated__c = 'No',RecordTypeId = rtAPCPT.Id, Special_Diet_Indicated__c = 'No',Language_3_Proficiency__c='',Language_2_Proficiency__c='',Language_1_Proficiency__c='',
                                                               Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', Language_3__c='English',Language_2__c='',Language_1__c='',
                                                               Primary_Language__c = 'English', School_Transportation__c = 'Bus', Service_Level__c='Independent',Engagement_End__c=System.today()+10,
                                                               Engagement_Start__c = System.today()-2, 
                                                               Engagement__c=myEngagement_1.id,Accommodation_Preference__c = 'Homestay',Application_Level__c='Main',Intrax_Program__c='AuPairCare',Application_Type__c='Orignal',Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
        insert appInfoAPCPT;
        
        //appInfoAPCPT.Engagement__c=myEngagement_1.id;
        //update appInfoAPCPT;
        
        Account accountHf  = new Account(Name='test', RecordTypeId = rtHF.Id, Type = 'Partner');
        insert accountHf;
        
        //Contact
        Contact contactHF = new Contact(LastName = 'LastName', AccountId = accountHf.Id, Email = 'test@test.com');
        insert contactHf;
                
              
        //Portal User
        User userHf = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                             LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                             ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                             ContactId = contactHf.Id, Intrax_Id__c ='Test',
                             Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
        
        insert userHf;
         //Run in user context
       //System.runAs(sysAdmin) {
        
        RecordType rtposition = [select id, Name from RecordType where SobjectType='Position__c' and Name='AuPairCare HF' Limit 1];
        
        Account myAccountpo = new Account(Name='Test');
        insert myAccountpo;
        
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c = myAccountpo.Id, Status__c ='Matching', Country__c = 'United States', 
                                    RecordTypeId =rtposition.id,Pets__c = 'Yes', Pet_Types__c = 'Dog');
        insert myPosition;
        
        //Record Type (Applicant HF)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];

        //Applicant Info HF
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                          Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                          Country_of_Interest__c = 'Whatever', Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test',
                                                          Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                          Position__c=myPosition.id,Gender_Preference__c = 'female', Study_Weeks__c = 1, Intrax_Program__c = 'AuPairCare', Program_Start_Opinion__c = 'Yes',CreatedBy__c=UserInfo.getUserId());
        insert appInfo;
        
        system.debug('debug::=='+appInfo);
           
        Selection__c sec = new Selection__c(
        Name = 'Testselection',  OwnerId = UserInfo.getUserId(),Intrax_Program__c='AuPairCare',Position__c=myPosition.id,Engagement__c=myEngagement_1.id,
        Interview_Start_Date__c=date.newInstance(2015, 6, 20), Interview_End_Date__c=date.newInstance(2015, 7, 20),Status__c='Active');
        insert sec;
        
        Selection__c sec2 = new Selection__c(
        Name = 'Testselection2',  OwnerId = UserInfo.getUserId(),Intrax_Program__c='AuPairCare',Position__c=myPosition.id,Engagement__c=myEngagement_1.id,
        Interview_Start_Date__c=date.newInstance(2015, 6, 20), Interview_End_Date__c=date.newInstance(2015, 7, 20),Status__c='Active');
        insert sec2;
        
        Selection__c sec4 = new Selection__c(
        Name = 'Testselection2',  OwnerId = UserInfo.getUserId(),Intrax_Program__c='AuPairCare',Position__c=myPosition.id,Engagement__c=myEngagement_1.id,
        Interview_Start_Date__c=date.newInstance(2015, 6, 20), Interview_End_Date__c=date.newInstance(2015, 7, 20),Recommendation_Type__c='System');
        insert sec4;
        
        RecordType rtmatch = [select id, Name from RecordType where SobjectType='Match__c' and Name='AuPairCare' Limit 1];
        
        match__c match= new match__c(Name=sec.Name,Position_Name__c=appInfo.Position__c,RecordTypeId=rtmatch.id,Arrival_Date__c=date.newInstance(2015, 7, 20));
        insert match;
        
        system.debug('debug::testMatch'+match);
           
        match__c ConfMatch= [select id,Arrival_Date__c,RecordType.Name,Position_Name__c,Engagement__c,
                        Engagement__r.Gender__c,Participant_Id__r.Name,Offer_Status__c 
                        from match__c where Position_Name__c =:appInfo.Position__c
                        order by createdDate desc limit 1];
        system.debug('debug::ConfMatch'+ConfMatch);
        //'00519000000lFa9'
        User_Preference__c up = new User_Preference__c(Name='User Preference',Object__c='Engagement__c',Saved_Records__c='[myEngagement_1.id]',Dismissed_Records__c ='[myEngagement_1.id]',User__c =user.Id);
        insert up;
     //}
      
      PageReference PageRef = Page.apc_hf_interviews;
      Test.setCurrentPage(PageRef);
      apc_match_controller apcmatch= new apc_match_controller(); 
      apcmatch.requestid=sec.id;
      apcmatch.checkInterviews();
      apcmatch.CancelInterview(); 
      User_Profile__c userProfAD=apcmatch.userProfAD;
      List<selectOption> getOSAPArrivalDates=apcmatch.getOSAPArrivalDates;
      List<PastInterviewWrapper> PastSelections=apcmatch.getPastSelections();
      integer totalPages=apcmatch.totalPages;
      Boolean hasNext=apcmatch.hasNext;
      Boolean hasPrevious=apcmatch.hasPrevious;
      ApexPages.StandardSetController con =  apcmatch.con;
      apcmatch.pageNumberSelected='1';
      Integer pageNumber=apcmatch.pageNumber;
      apcmatch.setPageNumber();
      apcmatch.next();
      apcmatch.CheckExpDate();
      list<Match__c> MatchConf=apcmatch.MatchConf;
      apexpages.currentpage().getparameters().put('id',sec.id);
      apcmatch.matchRequest();
      Double offset=apcmatch.offset;
          
      apexpages.currentpage().getparameters().put('ssid',sec.id);
      apcmatch.extendRequest();
     
      PageRef = Page.apc_hf_match_request;
      Test.setCurrentPage(PageRef);
      apexpages.currentpage().getparameters().put('id',sec.id);
      //apc_match_controller apcmatch2= new apc_match_controller(); 
     
    }
}