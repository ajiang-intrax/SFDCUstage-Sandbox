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
@isTest
private class Test_CSignatureGenerator_Member {

    static testMethod void myUnitTest() {
         
      RecordType positionRecordType = [select id,Name from RecordType where SobjectType='Position__c' and Name='Ayusa HF' Limit 1];
      
            
      Account account  = new Account(FirstName = 'Test', LastName = 'HF Account', Status__c = 'Prospect',
    											 	Type = 'Host Family',
    											 	Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
    											 	Intrax_Region__c = 'United States', PersonEmail = 'test@test2.com');
    											 	
	  //Account account = [SELECT Id, Name, Intrax_Id__c, type FROM Account WHERE Type = 'Partner' limit 1];
                        
      insert account;  
      
      system.debug('******* Intrax_Id__c: ' + account.Intrax_Id__c);  
      
      //Contact co = new Contact(FirstName = 'Test1', LastName = 'Partner', AccountId = account.Id, email='test@test.com');
      
      //insert co;
      
      list<Profile> profiles = [Select Id from Profile where Name = 'System Administrator' limit 1];
      
      User user1 = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    Intrax_Id__c = account.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
      insert user1; 
	 
	 
	 
      
      Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'Ayusa High School', 
									 			Intrax_Region__c = 'United States', Engagement_Start__c = system.today(),
									 			RecordTypeId = positionRecordType.Id,Country__c='Australia',
									 			Engagement_End__c = system.today().addDays(10), Host_Company_Id__c = account.Id, Status__c='Matching'
									 			); 
      
      insert position;
      
      
      
      Applicant_Info__c appInfoTest = new Applicant_Info__c(Position__c = position.Id, Name = 'test', RecordTypeId = '012a0000001NOM5AAO', Home_Street_1__c = 'test', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test',  Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Working');
      
      insert appInfoTest;
      
      Person_Info__c personMember1 = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = true,
	                                                First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
	                                                Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
	                                                Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Sibling',
	                                                Date_of_Birth__c = date.newInstance(1980, 2, 17) );
	                                                
	 insert personMember1;
	 
     Member__c member1Same = new Member__c(First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
	                                              Account_Name__c = account.Id, Birth_City__c = 'Test', Last_Name__c = 'Test',Intrax_program_option__c='Ayusa High School',
	                                           Residency_Status__c ='Stays frequently',Background_Check__c='Not Required',Date_of_Birth__c = date.newInstance(1980, 2, 17) );  
     
     insert member1Same;
      List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
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
                listEngagement.add(new Engagement__c(name='TestEng'+i,Opportunity_Id__c=listOpportunity[i].Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa PT','Engagement__c'),ACCOUNT_ID__C=listAccount[i].Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24)));
            }
            
            //insert data in bulk 
            insert listEngagement;            
          
            //Create matched records with Interview Pending Status
            List<Match__c> matchesForPosition1 = new List<Match__c>();
            List<Match__c> matchesForPosition2 = new List<Match__c>();
            
            //loop through the opportunity and add records in the list
            Integer i = 0;
            for(Opportunity opp : listOpportunity){
                matchesForPosition1.add(new Match__c(Name = 'Test', Engagement__c = listEngagement[i].Id, Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position.Id, Status__c = 'Assigned', Interview_Date__c = Date.today() + 1));
                i++;
               // matchesForPosition2.add(new Match__c(Name = 'Test', Participant_Id__c = opp.AccountId, Participant_Opportunity_Id__c = opp.Id, Position_Name__c = position2.Id, Status__c = 'Interview Pending' ));
            }
            
            //insert matches data'
            insert matchesForPosition1;        
     
        CSignatureGenerator_Member cs = new CSignatureGenerator_Member();
        cs.getMembers();
       
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