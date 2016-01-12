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
private class Test_PluginMapPersonToMember {

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
                                                RecordTypeId = positionRecordType.Id,
                                                Engagement_End__c = system.today().addDays(10), Host_Company_Id__c = account.Id
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
                                                    
     Person_Info__c personReference1 = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = false,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
      
     insert personReference1; 
     
     Person_Info__c personReference2 = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = false,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
      
     insert personReference2; 
         
     
     Member__c member1Same = new Member__c(First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                  Account_Name__c = account.Id, Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                Date_of_Birth__c = date.newInstance(1980, 2, 17) );  
     
     insert member1Same;
     
     //Reference__c reference1Same = new Reference__c(First_Name__c  = 'test', Email__c = 'test@test.com', Position__c = appInfoTest.Position__c, 
     //                                            Last_Name__c = 'Test'); 
     Reference__c reference1Same = new Reference__c(First_Name__c  = 'test', Email__c = 'test@test.com', 
                                                 Last_Name__c = 'Test'); 
     
     insert reference1Same; 
      
      
      
      system.runAs(user1){
        
        test.startTest();
        
        PluginMapPersonToMember Plugin = new PluginMapPersonToMember();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        
        inputParams.put('AppInfoID',appInfoTest.Id);
        inputParams.put('AccountID',account.Id);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = Plugin.invoke(request);
        
        Process.PluginDescribeResult result2 = Plugin.describe();
        
                
        test.stopTest();
      }
    }
    
    static testMethod void myUnitTest2() {
      
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
                                                RecordTypeId = positionRecordType.Id,
                                                Engagement_End__c = system.today().addDays(10), Host_Company_Id__c = account.Id
                                                ); 
      
      insert position;
      
      
      Applicant_Info__c appInfoTest = new Applicant_Info__c(Position__c = position.Id, Name = 'test', RecordTypeId = '012a0000001NOM5AAO', Home_Street_1__c = 'test', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test',  Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Working');
      
      insert appInfoTest;
      
      
      Person_Info__c primaryApp = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Sibling',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                                                    
     insert primaryApp;
      
      Person_Info__c personMember1 = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = true,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Sibling',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                                                    
     insert personMember1;
                                                    
     Person_Info__c personReference1 = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = false,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
      
     insert personReference1; 
      
         
     
     Member__c member1Same = new Member__c(First_Name__c  = 'test2', Gender__c = 'Male', Email__c = 'test2@test.com',
                                                  Account_Name__c = account.Id, Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                Date_of_Birth__c = date.newInstance(1980, 2, 17) );  
     
     insert member1Same;
     
     Reference__c reference1Same = new Reference__c(First_Name__c  = 'test2', Email__c = 'test2@test.com', Position__c = appInfoTest.Position__c, 
                                                 Last_Name__c = 'Test'); 
     
     insert reference1Same; 
      
      
      
      system.runAs(user1){
        
        test.startTest();
        
        PluginMapPersonToMember Plugin = new PluginMapPersonToMember();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        
        inputParams.put('AppInfoID',appInfoTest.Id);
        inputParams.put('AccountID',account.Id);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = Plugin.invoke(request);
        
        Process.PluginDescribeResult result2 = Plugin.describe();
        
                
        test.stopTest();
      }
    }
    
     static testMethod void myUnitTest3() {
      
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
                                                RecordTypeId = positionRecordType.Id,
                                                Engagement_End__c = system.today().addDays(10), Host_Company_Id__c = account.Id
                                                ); 
      
      insert position;
      
      
      Applicant_Info__c appInfoTest = new Applicant_Info__c(Position__c = position.Id, Name = 'test', RecordTypeId = '012a0000001NOM5AAO', Home_Street_1__c = 'test', Home_City__c = 'test', Home_Street_2__c = 'test',Home_State__c = 'test', Home_Postal_Code__c = 'test', Home_Country__c = 'test', Type__c = 'Host Family', Business_in_Home_Description__c = 'test',  Application_Level__c = 'Main', Community_Population__c = 600, Nearest_City__c = 'test', Airport__c = 'test',Community_Website__c = 'www.test.com', Community_Description__c = 'test', Points_of_Interest__c = 'test', Home_Type__c = 'Condo', Application_Stage__c = 'Working');
      
      insert appInfoTest;
      
      
      Person_Info__c primaryApp = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Sibling',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                                                    
     insert primaryApp;
      
      Person_Info__c personMember1 = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = true,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Sibling',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                                                    
     insert personMember1;
                                                    
     Person_Info__c personReference1 = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = false,
                                                    First_Name__c  = 'test', Gender__c = 'Male', Email__c = 'test@test.com',
                                                    Applicant_Info__c = appInfoTest.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Reference',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
      
     insert personReference1; 
      
         
     
     /*Member__c member1Same = new Member__c(First_Name__c  = 'test2', Gender__c = 'Male', Email__c = 'test2@test.com',
                                                  Account_Name__c = account.Id, Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                Date_of_Birth__c = date.newInstance(1980, 2, 17) );  
     
     insert member1Same;
     
     Reference__c reference1Same = new Reference__c(First_Name__c  = 'test2', Email__c = 'test2@test.com', Position__c = appInfoTest.Position__c, 
                                                 Last_Name__c = 'Test'); 
     
     insert reference1Same;*/ 
      
      
      
      system.runAs(user1){
        
        test.startTest();
        
        PluginMapPersonToMember Plugin = new PluginMapPersonToMember();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        
        inputParams.put('AppInfoID',appInfoTest.Id);
        inputParams.put('AccountID',account.Id);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = Plugin.invoke(request);
        
        Process.PluginDescribeResult result2 = Plugin.describe();
        
                
        test.stopTest();
      }
    }
}