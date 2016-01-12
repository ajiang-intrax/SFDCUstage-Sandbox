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
 
@isTest(SeeAllData=false)

private class Test_User_Invitation_Controller {

    static testMethod void myUnitTest() {
        
        Applicant_Info__c appInfoTest = new Applicant_Info__c(Name = 'test', RecordTypeId = '012a0000001NOM5AAO', Home_Street_1__c = 'test', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test',    Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Working');
        
        insert appInfoTest;
        
        Applicant_Info__c appInfoTest_Accepted = new Applicant_Info__c(Name = 'test2', RecordTypeId = '012a0000001NOM5AAO', Home_Street_1__c = 'test2', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test', Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Program_Year__c = '2014', Application_Stage__c = 'Accepted');
        
        insert appInfoTest_Accepted;
        
        RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        Account partnerAccount = new Account(Name = 'Host Company', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert partnerAccount;
        
        Account partnerInfo = [SELECT Id, Name, Intrax_Id__c, type FROM Account WHERE Id=: partnerAccount.Id limit 1];                                  
        //insert partnerInfo;   
        system.debug('******* Intrax_Id__c: ' + partnerInfo.Intrax_Id__c);  
        
        Contact co = new Contact(FirstName = 'Test1', LastName = 'Partner', AccountId = partnerInfo.Id, email='test@test.com');
                
        insert co;
        
        Contact con1 = new Contact(FirstName = 'test HC',LastName = 'hc te',AccountId = partnerInfo.Id, email= 'testhi@email.com');
        insert con1;
        Contact con2 = new Contact(LastName = 'hc',AccountId = partnerInfo.Id, email= 'testhit@email.com');
        insert con2;
        Contact con3 = new Contact(FirstName = 'test1 HC1',LastName = 'hc1 te1',AccountId = partnerInfo.Id, email= 'testhir@email.com');
        insert con3;
        
        RecordType partnerHCType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        Account HCaccnt = new Account(Name = 'Host Company', RecordTypeId = partnerHCType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Internship');
        insert HCaccnt;
        Account HCInfo = [SELECT Id, Name, Intrax_Id__c, type FROM Account WHERE Id=: HCaccnt.Id limit 1]; 
        Contact con4 = new Contact(FirstName = 'testHC',Intrax_Programs__c = 'Internship', LastName = 'hc',AccountId = HCInfo.Id, email= 'testhits@email.com');
        insert con4;
        
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM Agent Portal' limit 1];
        
        User user1 = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = co.Id, Intrax_Id__c = partnerInfo.Intrax_Id__c,
                                    Username = Math.random() + '@test.com');
        insert user1;                           
        
        
        Communication__c comInfo = new Communication__c(Recipient_First_Name__c = 'Test', Recipient_Last_Name__c = 'Test1', To_Address__c = 'a@a.com', Intrax_Program_Options__c = 'WEST');
        insert comInfo;
        
        Communication__c comInfo2 = new Communication__c(Recipient_First_Name__c = 'Test Test', Recipient_Last_Name__c = 'Test 1', To_Address__c = 'a@a.com', Intrax_Program_Options__c = 'Business Internship');
        insert comInfo2;
        
        Communication__c comInfo3 = new Communication__c(Recipient_Last_Name__c = 'Test 1', To_Address__c = 'a@a.com', Intrax_Program_Options__c = 'Business Internship');
        insert comInfo3;
        
        Communication__c comInfo4 = new Communication__c(Recipient_First_Name__c = 'Test Test', Recipient_Last_Name__c = 'Test 1', To_Address__c = 'a@a.com', Intrax_Program_Options__c = 'Business Internship');
        insert comInfo4;
        
        Communication__c comInfo5 = new Communication__c(Recipient_Last_Name__c = 'Test 1', To_Address__c = 'a@a.com', Intrax_Program_Options__c = 'Business Internship');
        insert comInfo5;
        
        system.runAs(user1){
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(comInfo);
            User_Invitation_Controller c = new User_Invitation_Controller(sc);
            c.ipo_options = 'WEST';
            c.comInfo = comInfo;
            c.CreateCommunication();
            //c.getipo_options();
            c.getProgramOptions();
            c.checklogin();
            
            ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(comInfo2);
            User_Invitation_Controller c2 = new User_Invitation_Controller(sc2);
            c2.ipo_options = 'Work Travel';
            c2.comInfo = comInfo2;
            c2.CreateCommunication();
            //c2.getipo_options();
            
            ApexPages.Standardcontroller sc3 = new ApexPages.Standardcontroller(comInfo3);
            User_Invitation_Controller c3 = new User_Invitation_Controller(sc3);
            c3.ipo_options = 'Internship';
            c3.comInfo = comInfo3;
            c3.CreateCommunication();
            //c2.getipo_options();
            
            ApexPages.Standardcontroller sc4 = new ApexPages.Standardcontroller(comInfo2);
            User_Invitation_Controller c4 = new User_Invitation_Controller(sc2);
            c4.ipo_options = 'Intership';
            c4.comInfo = comInfo4;
            c4.CreateCommunication();
            //c2.getipo_options();
            
            ApexPages.Standardcontroller sc5 = new ApexPages.Standardcontroller(comInfo5);
            User_Invitation_Controller c5 = new User_Invitation_Controller(sc5);
            c5.ipo_options = 'Intership';
            c5.comInfo = comInfo5;
            c5.CreateCommunication();
            //c2.getipo_options();
            
            Lead lrOptedOutChecked = new Lead(FirstName ='Test', LastName ='Test',email='test1@test.com',Intrax_Programs__c='Internship',
            Lead_Type__c='Participant',HasOptedOutOfEmail=true);
            insert lrOptedOutChecked;
            Apexpages.currentPage().getParameters().put('LeadId', lrOptedOutChecked.Id);
            User_Invitation_Controller c6 = new User_Invitation_Controller();
            c6.CreateLeadCommunication();
            
             Lead lrOptedOutChecked1 = new Lead(FirstName ='Test Test', LastName ='Test Test',email='test2@test.com',Intrax_Programs__c='AuPairCare',
            Lead_Type__c='Participant',HasOptedOutOfEmail=true);
            //insert lrOptedOutChecked1; 
            //Apexpages.currentPage().getParameters().put('LeadId', lrOptedOutChecked1.Id);
            User_Invitation_Controller c7 = new User_Invitation_Controller();
            c7.CreateLeadCommunication();
            
             Lead lrOptedOutChecked2 = new Lead(FirstName ='Test', LastName ='Test Test',email='test3@test.com',Intrax_Programs__c='Ayusa',
            Lead_Type__c='Participant',HasOptedOutOfEmail=true);
            insert lrOptedOutChecked2;
            Apexpages.currentPage().getParameters().put('LeadId', lrOptedOutChecked2.Id);
            User_Invitation_Controller c8 = new User_Invitation_Controller();
            c8.CreateLeadCommunication();
            
            Apexpages.currentPage().getParameters().put('ContactId', co.Id);
            c8.CreateContactCommunication();
            
            Apexpages.currentPage().getParameters().put('ContactId', con1.Id);
            c8.CreateContactCommunication();
            Apexpages.currentPage().getParameters().put('ContactId', con2.Id);
            c8.CreateContactCommunication();
            Apexpages.currentPage().getParameters().put('ContactId', con3.Id);
            c8.CreateContactCommunication();
            Apexpages.currentPage().getParameters().put('ContactId', con4.Id);
            c8.CreateContactCommunication();
            
            
            test.stopTest();

        }
    }
    
    static testMethod void myUnitTestGroupUser() {
        
        Applicant_Info__c appInfoTest = new Applicant_Info__c(Name = 'test', RecordTypeId = '012a0000001NOM5AAO', Home_Street_1__c = 'test', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test',    Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Working');
        
        insert appInfoTest;
        
        Applicant_Info__c appInfoTest_Accepted = new Applicant_Info__c(Name = 'test2', RecordTypeId = '012a0000001NOM5AAO', Home_Street_1__c = 'test2', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test', Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Program_Year__c = '2014', Application_Stage__c = 'Accepted');
        
        insert appInfoTest_Accepted;
         List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        Account PTAcc = new Account(FirstName = 'Test_Old', LastName='VP',personEmail='ptemail@acc.com',Phone='3432323',RecordTypeId = participantRecordType[0].Id);
        insert PTAcc;
        RecordType rtWTPT= [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1]; 
        Applicant_Info__c app_Accepted = new Applicant_Info__c(Email__c='testwt@test.com',Name = 'WT_Test', RecordTypeId = rtWTPT.id, Home_Street_1__c = 'test2', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Participant', Business_in_Home_Description__c = 'test', Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Program_Year__c = '2014', Application_Stage__c = 'Accepted',Account__c=PTAcc.Id);
        
        insert app_Accepted;

        
        RecordType GroupAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Institution' Limit 1];
        RecordType GroupAccountRecordType_PT = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        Account groupAccount = new Account(Name = 'Group Account',
                                        Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert groupAccount;
        
        groupAccount.Type = 'Institution'; // This is to bypass the ProWorld trigger
        groupAccount.RecordTypeId = groupAccountRecordType.Id; 
        update groupAccount;
        
        Account GroupInfo = [SELECT Id, Name, Intrax_Id__c, type FROM Account WHERE Id=: groupAccount.Id limit 1];                                  
        //insert partnerInfo;   
        system.debug('******* Intrax_Id__c: ' + groupInfo.Intrax_Id__c);  
        
        Contact co = new Contact(FirstName = 'Test1', LastName = 'Group', AccountId = groupInfo.Id, email='test@test.com');        
        insert co;
       
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM University' limit 1];
        list<Profile> profiles_pt = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User user1 = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = co.Id, Intrax_Id__c = groupInfo.Intrax_Id__c, Type__c = 'Institution',
                                    Username = Math.random() + '@test.com');
        insert user1;                           
        
        groupAccount.Type = 'Partner';
        groupAccount.RecordTypeId = groupAccountRecordType_PT.Id; 
        update groupAccount;    
        
        Contact co1 = new Contact(FirstName = 'Test2', LastName = 'Group', AccountId = groupInfo.Id, email='test@test.com',PTR_Portal_Intrax_Program_Default__c='Work Travel');        
        insert co1;
        
         User user2 = new User(Alias = 'alias', Email = 'testwt@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles_pt[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = co1.Id, Intrax_Id__c = groupInfo.Intrax_Id__c, Type__c = 'Partner',
                                    Username = 'testwt2@test.com');
        insert user2;  
         Contact co2 = new Contact(FirstName = 'Test2', LastName = 'Group', AccountId = groupInfo.Id, email='test3@test.com',PTR_Portal_Intrax_Program_Default__c='AuPairCare');        
        insert co2;
        
         User user3 = new User(Alias = 'alias', Email = 'testwt3@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles_pt[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                    ContactId = co2.Id, Intrax_Id__c = groupInfo.Intrax_Id__c, Type__c = 'Partner',
                                    Username = 'testwt3@test.com');
        insert user3;                           
        
        Communication__c comInfo = new Communication__c(Recipient_First_Name__c = 'Test', Recipient_Last_Name__c = 'Test1', To_Address__c = 'a@a.com');
        insert comInfo;
        test.startTest();
        system.runAs(user1){
          //  test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(comInfo);
            User_Invitation_Controller c = new User_Invitation_Controller(sc);
            c.ipo_options = 'WEST';
            c.comInfo = comInfo;
            c.CreateCommunication();
            //c.getipo_options();
            c.getProgramOptions();
            c.checklogin();  
            c.return1();    
            c.addEmail();
            c.CreateCommunicationMulti();
            c.CreateCommunication();
             c.removeEmail();
          //  test.stopTest();

           }
          system.runAs(user2){
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(comInfo);
            User_Invitation_Controller c1 = new User_Invitation_Controller(sc);
            map<Integer, list<String>>  m=new Map<Integer, list<String>>();
            List<String> s=new List<String> { 'fname', 'lname', 'testwt@test.com'};
            m.put(1,s);
            c1.emailMap=m;
           
            c1.CreateCommunicationMulti();
            
          }
         system.runAs(user3){
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(comInfo);
            User_Invitation_Controller c1 = new User_Invitation_Controller(sc);
            map<Integer, list<String>>  m=new Map<Integer, list<String>>();
            List<String> s=new List<String> { 'fname', 'lname', 'testwt1@test.com'};
            m.put(1,s);
            c1.emailMap=m;
           
            c1.CreateCommunicationMulti();
           
          }
        test.stopTest();
           
    }
}