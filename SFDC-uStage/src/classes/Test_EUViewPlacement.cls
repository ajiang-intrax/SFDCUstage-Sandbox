@isTest
public class Test_EUViewPlacement {
 static testMethod void myTest()
 {
  User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
  
            //Run in user context
   System.runAs(sysAdmin) {
   List<Profile> profiles = [Select Id from Profile where Name = 'Intrax Developer' limit 1];
        
        //Check for list Size
   if(profiles.size() > 0) {
     //Record Type
   User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                     TimeZoneSidKey = 'America/Los_Angeles', ProfileId = profiles[0].Id,
                                    Username = Math.random() + '@test.com');
            
    insert user;
    sysAdmin.ManagerId = user.Id;
    update sysAdmin;
   }
     RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
    System.assertEquals(true, hostCompanyRecordType != null);
   
    List<Account> acc_list= new List<Account>();
    
        //Account
    Account account  = new Account(Name = 'Test_HF', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', Intrax_Region__c = 'United States');
     //insert account;
     
    acc_list.add(account);
     
    RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
    Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com');
    //insert participantAccount;
    acc_list.add(participantAccount);
         
    Account participantAccount1  = new Account(FirstName = 'Test1', LastName = 'Participant Accoun1t', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test1@test1.com');
    //insert participantAccount1;
    acc_list.add(participantAccount1);
        //Contact
    Contact contact = new Contact(FirstName = 'Host', LastName = 'Contact', AccountId = account.Id, Email = 'test@test.com');
     insert contact;
    
    RecordType partnerAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
    Account partnerAccount  = new Account(Name = 'Partner1', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                      Status__c = 'Prospect',  Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'Ayusa High School', Intrax_Region__c = 'Europe');
    insert partnerAccount;
    Contact contact1Partner = new Contact(FirstName = 'USA', LastName = 'Contact',Phone='123456', AccountId = partnerAccount.Id, Email = 'testusa@test.com',Emergency_Contact__c='First',Intrax_Programs__c ='Ayusa',Intrax_Program_Options_CT__c ='Ayusa High School');
    insert contact1Partner;
    Contact contact2Partner = new Contact(FirstName = 'SF', LastName = 'Contact',Phone='99999', AccountId = partnerAccount.Id, Email = 'testsf@test.com',Emergency_Contact__c='Second',Intrax_Programs__c ='Ayusa',Intrax_Program_Options_CT__c ='Ayusa High School');
    insert contact2Partner;
   
     Account partnerAccount1  = new Account(Name = 'Partner2', RecordTypeId = partnerAccountRecordType.Id, Type = 'Partner', 
                                     Status__c = 'Prospect',   Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', Intrax_Region__c = 'Europe');
   // insert partnerAccount1;
    acc_list.add(partnerAccount1);
    insert acc_list;
     Contact contact3Partner = new Contact(FirstName = 'SF1', LastName = 'Contact1',Phone='88888', AccountId = partnerAccount1.Id, Email = 'testsf@test.com',Emergency_Contact__c='First',Intrax_Programs__c ='Ayusa',Intrax_Program_Options_CT__c ='High School Worldwide');
    insert contact3Partner;
       
    List<Opportunity> opp_list = new List<Opportunity>();
    
        //Opportunity
   Opportunity opportunity_1 = new Opportunity(Name = 'Test Opportunity 1', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'Ayusa High School', 
                                                    Intrax_Region__c = 'Europe', Intrax_Market__c = 'Germany', CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = participantAccount.Id, Program_Year__c = '2013',
                                                        Partner_Id__c= partnerAccount.Id, Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',Partner_Account__c = partnerAccount.Id);
    //insert opportunity_1;
    opp_list.add(opportunity_1);
    Opportunity opportunity1 = new Opportunity(Name = 'Test Opportunity 2', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'Ayusa HighSchool', 
                                                    Intrax_Region__c = 'France', Intrax_Market__c = 'Germany', CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = participantAccount.Id, Program_Year__c = '2013',
                                                    Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started',Partner_Id__c= partnerAccount1.Id,Partner_Account__c=partnerAccount1.Id);
    //insert opportunity1;
    opp_list.add(opportunity1);
    insert opp_list;
    List<Engagement__c> eng_list=new List<Engagement__c>();
    RecordType HSengagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='HS Worldwide PT' Limit 1];
    Engagement__c HSengagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = participantAccount.Id, 
                                                        RecordTypeId = HSengagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'Ayusa High School', Intrax_Region__c = 'Europe',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 20), Engagement_End__c = (date.today() + 100), 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
   // insert HSengagement;
   eng_list.add(HSengagement);
   Engagement__c HSengagement1 = new Engagement__c(Name='Test Engagement1', 
                                                        Account_Id__c = participantAccount.Id, 
                                                        RecordTypeId = HSengagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'Ayusa High School', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 20), Engagement_End__c = (date.today() + 100), 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
    //insert HSengagement1;
    eng_list.add(HSengagement1);
    Engagement__c HSengagement2=new Engagement__c(Name='Test Engagement2', 
                                                        Account_Id__c = participantAccount.Id, 
                                                        RecordTypeId = HSengagementRecordType.ID,
                                                        Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'High School Worldwide', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 20), Engagement_End__c = (date.today() + 100), 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
    
    //insert HSengagement2;
    eng_list.add(HSengagement2);
   /* Engagement__c HSengagement3=new Engagement__c(Name='Test Engagement3', 
                                                        Account_Id__c = participantAccount1.Id, 
                                                        RecordTypeId = HSengagementRecordType.ID,
                                                        Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'Ayusa High School', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = (date.today() - 20), Engagement_End__c = (date.today() + 100), 
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
    
    //insert HSengagement3;
   eng_list.add(HSengagement3);*/
    insert eng_list;
    Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'Ayusa High School', 
                                                Intrax_Region__c = 'Europe', Engagement_Start__c = System.today(),
                                                Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia', Status__c='Matching');
    insert position;
    List<Match__c> mat_list=new List<Match__c>();
    
    Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Confirmed', 
                                        Engagement__c = HSengagement.Id, Participant_Opportunity_Id__c = opportunity_1.Id);
     mat_list.add(match);
   // insert match;
    /*Match__c match1 = new Match__c(Name = 'Test Match1', Position_Name__c = position.Id, Status__c = 'Withdrawn', 
                                        Engagement__c = HSengagement1.Id, Participant_Opportunity_Id__c = opportunity1.Id);
    mat_list.add(match1);*///insert match1;
    Match__c match2 = new Match__c(Name = 'Test Match2', Position_Name__c = position.Id, Status__c = 'Confirmed', 
                                        Engagement__c = HSengagement1.Id,  Participant_Opportunity_Id__c = opportunity1.Id);
    mat_list.add(match2);
    Match__c match3 = new Match__c(Name = 'Test Match3', Position_Name__c = position.Id, Status__c = 'Withdrawn', 
                                        Engagement__c = HSengagement2.Id, Participant_Opportunity_Id__c = opportunity1.Id);
    mat_list.add(match3);
    
   /* Match__c match4 = new Match__c(Name = 'Test Match4', Position_Name__c = position.Id, Status__c = 'Withdrawn', 
                                        Engagement__c = HSengagement3.Id, Participant_Opportunity_Id__c = opportunity1.Id);
    mat_list.add(match4);*/
    insert mat_list;
     //Application - Host Family
    List<Applicant_Info__c> app_list= new List<Applicant_Info__c>();
    List<Person_Info__c> per_list= new List<Person_Info__c>();
    Applicant_Info__c appInfo_HF = new Applicant_Info__c(Name = 'test-HSW-HF', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA',
                                                                  Special_Diet_Indicated__c = 'Yes', Position__c=position.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'High School Worldwide',  Account__c=account.Id);
     app_list.add(appInfo_HF);
                
    
   //Record Type
    RecordType partnerApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='Ayusa PT' Limit 1];
        
    //Assert for Results
   // System.assertEquals(true, partnerApplicationRecordType != null);
   Applicant_Info__c appInfo_PT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance', Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = partnerApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Engagement__c = HSengagement.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                                  Intrax_Program_Options__c = 'YES',Account__c = participantAccount.Id);
        
    app_list.add(appInfo_PT);
    insert app_list;
     //Personal Info
     Person_Info__c personInfo_Primary = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                                    Name  = 'Test_HF', First_Name__c='Primary',Gender__c = 'Male',
                                                    Applicant_Info__c = app_list[0].Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
    per_list.add(personInfo_Primary);
    Person_Info__c personInfo_Parent = new Person_Info__c(Family_Member__c = true,
                                                    First_Name__c  = 'Parent_HF', Gender__c = 'Male',
                                                    Applicant_Info__c = app_list[0].Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Parent',
                                                    Date_of_Birth__c = date.newInstance(1942, 6, 21) );
    per_list.add(personInfo_Parent);
    /*Person_Info__c personInfo_Spouse = new Person_Info__c(Family_Member__c = true,
                                                    First_Name__c  = 'Spouse_HF', Gender__c = 'Male',
                                                    Applicant_Info__c = app_list[0].Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='Spouse',
                                                    Date_of_Birth__c = date.newInstance(1971, 2, 27) );
    per_list.add(personInfo_Spouse);*/
    insert per_list;
    
    Test.startTest();
    ApexPages.CurrentPage().getParameters().put('Id', HSengagement.Id);
    EUViewPlacement euView = new EUViewPlacement();
    Boolean b= euView.gethasMatch();
    Opportunity op=[Select Intrax_Region__c,Intrax_Market__c,Partner_Account__r.Id from Opportunity where ID =:opportunity_1.Id limit 1];
    String s=euView.getcode();
    Match__c m =euView.getconfirm_match();
   Applicant_Info__c app=euView.getapplndetail();
    app=euView.getPTapplndetail();
    System.debug('after applicaiton');
    List<Person_Info__c> pri=euView.getParent();
    List<Person_Info__c> pri_list=euView.getNotparent();
    User u=euView.getRM();
   
    s=euView.getUSAPartAcc();
 
    s=euView.getEmerPartAcc();   
  
    String s1=euView.getPartAcc(); 
   Integer i=euView.getappCount();
   euview.appCount=i;
   ApexPages.StandardController sc = new ApexPages.StandardController(HSengagement2);
    EUViewPlacement euViewtest = new EUViewPlacement(sc);
 //   ApexPages.CurrentPage().getParameters().put('Id', HSengagement3.Id);
    EUViewPlacement euView2 = new EUViewPlacement();
    //System.assertEquals(euView2.gethasMatch(),false);
    ApexPages.CurrentPage().getParameters().put('Id', HSengagement1.Id);
    EUViewPlacement euView1 = new EUViewPlacement();
    System.assertEquals((euView1.getcode()).equals('en-US'),true);
     s=euView1.getEmerPartAcc();  
    euView.hasMatch=false;
    euview.code='de';
    euview.confirm_match=match;
    euview.applndetail=appInfo_HF;
    euview.PTapplndetail=appInfo_PT;
    euview.parent=null;
    euview.Notparent=null;
    euview.PartAcc ='second' ;
    euview.EmerPartAcc ='first';
    euview.USAPartAcc='first';
    euview.rm=sysAdmin;
     
    Test.stopTest();
 }
}
}