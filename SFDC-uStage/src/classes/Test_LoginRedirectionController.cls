@isTest(SeeAllData=true)
public class Test_LoginRedirectionController {
    static testMethod void myUnitTest() {
        LoginRedirectionController lc = new LoginRedirectionController();
        test.startTest();
        lc.isTest = true;
        lc.redirect();          
        
        User partner = [SELECT Id,Intrax_Id__c, Name, User_Interests__c From User WHERE Intrax_Id__c != null and Type__c = 'Partner' LIMIT 1];

        Date myDate = date.newinstance(Date.today().year()-17, Date.today().month(), Date.today().day());
        Date myDate1 = date.newinstance(Date.today().year(), Date.today().month()-1, Date.today().day()-1);
        Date myDate2 = date.newinstance(Date.today().year(), Date.today().month()-2, Date.today().day());
                            
        Opportunity o = new Opportunity(Name='Test',OwnerId=partner.Id,StageName='Closed - Won',CloseDate=myDate2);
        insert o;
        Applicant_Info__c ai = new Applicant_Info__c(Name='test',Type__c = 'Host Family',Engagement_Start__c=myDate1,Opportunity_Name__c=o.Id,Partner_Intrax_Id__c=partner.Intrax_Id__c);
        insert ai;
        Person_Info__c pi = new Person_Info__c(Name='test',Applicant_Info__c=ai.id,Primary_Applicant__c = false,Date_of_Birth__c=myDate);
        insert pi;                      
          List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
          Account hostCompany = new Account(Name = 'TestHost - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
             Engagement__c hostEngagement = new Engagement__c(Name = 'TestHost - Opp', Account_Id__c = hostCompany.Id, Status__c = 'Test',Placement_Status__c = 'Not Placed' ,Partner_ID__c=partner.Intrax_Id__c,
                                                            Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15),Type__c='Participant');
            insert hostEngagement;
            Engagement__Share  engShare = new Engagement__Share ();
    engShare.ParentId = hostEngagement.Id;
    engShare.UserOrGroupId = partner.Id;
    engShare.AccessLevel = 'Edit';
    Database.SaveResult sr = Database.insert(engShare,false);
        List<Engagement__c> lst = new list<Engagement__c>();
        lst.add(hostEngagement);
        lc.lstEng = lst;
        system.runAs(partner){
            lc.redirect();
        }
        
        test.stopTest();
    }
       static testMethod void myUnitTest1() {
        
       PageReference p=Page.AppEngine_Home; 
       //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        
        Test.setCurrentPage(p); 
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
       
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        sysAdmin.Email='test@josele.com';
        //update sysAdmin;
        
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
        
        System.runAs(sysAdmin) {
                
        //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country',
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = sysAdmin.Id);
        insert appInfo;
        
        //Personal Info
        Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true,
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male', Email__c='test@josele.com',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfo;
        
        List<Site_Message__c> lstsysmsges = new List<Site_Message__c>();
        Site_Message__c testunit = new Site_Message__c(Name='Hola', message__c='Hello', Planned_Start_Date_Time__c = System.today(), Planned_End_Date_Time__c = System.today().addDays(4));
        lstsysmsges.add(testunit);
        insert lstsysmsges;
        
        
        Test.startTest();
                
        LoginRedirectionController lc1 = new LoginRedirectionController();
        
        lc1.lstsysmsges = lstsysmsges; 
        
        ApexPages.currentPage().getParameters().put('isInvitation', 'true');
        
        lc1.message();
        lc1.redirect();
        
        sysAdmin.User_Interests__c='Studying English';
        //update sysAdmin;
        lc1.redirect();
        sysAdmin.User_Interests__c='Finding an internship';
        //update sysAdmin;
        lc1.redirect();
        sysAdmin.User_Interests__c='Looking for an intern';
        //update sysAdmin;
        lc1.redirect();
        sysAdmin.User_Interests__c='Becoming a Work Travel Participant';
        //update sysAdmin;
        lc1.redirect();
        
        
        
        Test.stopTest();
                
        }
        
      }
    }
        /*static testMethod void myUnitTest2() {
        LoginRedirectionController lc2 = new LoginRedirectionController();
        test.startTest();
        lc2.isTest = true;
        
        
        User user2 = [SELECT Id, Name, User_Interests__c From User U where IsActive = true limit 1];//WHERE User_Interests__c = 'Looking for an intern' LIMIT 1];

        system.runAs(user2){
            lc2.redirect();
        }
        
        
        test.stopTest();
        
       }*/
        static testMethod void myUnitTest3() {
        LoginRedirectionController lc3 = new LoginRedirectionController();
        test.startTest();
        lc3.isTest = true;
        
        
        User user3 = [SELECT Id, Name, User_Interests__c From User WHERE User_Interests__c = 'Becoming a high school exchange student' LIMIT 1];

        system.runAs(user3){
            lc3.redirect();
        }
        test.stopTest();
        
       }
        static testMethod void myUnitTest4() {
        LoginRedirectionController lc4 = new LoginRedirectionController();
        test.startTest();
        lc4.isTest = true;
        
        
        User user4 = [SELECT Id, Name, User_Interests__c From User WHERE User_Interests__c = 'Hosting an international student' LIMIT 1];

        system.runAs(user4){
            lc4.redirect();
        }
        
        test.stopTest();
        
       }
        /*static testMethod void myUnitTest5() {
        LoginRedirectionController lc5 = new LoginRedirectionController();
        test.startTest();
        lc5.isTest = true;
        
        
        User user5 = [SELECT Id, Name, User_Interests__c From User WHERE User_Interests__c = 'Becoming a Work Travel Participant' LIMIT 1];
        ApexPages.currentPage().getParameters().put('isInvitation', 'true');
        system.runAs(user5){
        lc5.redirect();
        }

        system.runAs(user5){
            ApexPages.currentPage().getHeaders().put('Referer','/Positions?');
            lc5.redirect();
        
        test.stopTest();
        }
       }
          static testMethod void myUnitTest6() {
        LoginRedirectionController lc5 = new LoginRedirectionController();
        test.startTest();
        lc5.isTest = true;
        
        
        User user5 = [SELECT Id, Name, User_Interests__c From User WHERE User_Interests__c = 'Finding an internship' LIMIT 1];

        system.runAs(user5){
            lc5.redirect();
        }

          
        
        test.stopTest();
        
       }
       
        static testMethod void myUnitTest7() {
        LoginRedirectionController lc5 = new LoginRedirectionController();
        test.startTest();
        
        lc5.isTest = true;
        Site_Message__c Sitem = new Site_Message__c(Name='NewTest',Display_Start_Date_Time__c=System.now(),Display_End_Date_Time__c=System.now(),Planned_Start_Date_Time__c=System.now(),Planned_End_Date_Time__c=System.now(),Message__c='Start Time: %Planned_Start_Date_Time__c% PDT End Time  : %Planned_End_Date_Time__c% ',Sites__c='Intrax_Application_Engine; Intrax_Company_Portal; Intrax_Participant_Portal; Intrax_Partners_Portal');
        //Site_Message__c Sitem=[select id,Display_Start_Date_Time__c,Display_End_Date_Time__c,Planned_Start_Date_Time__c,Planned_End_Date_Time__c,Message__c,Sites__c,User_Interests__c from Site_Message__c limit 1];     
        User user5 = [SELECT Id, Name, User_Interests__c From User WHERE User_Interests__c = 'Finding an internship' LIMIT 1];

        system.runAs(user5){
            lc5.message();
            string PlannedStartdate=MessagingPageController.matchAndReplace('%Planned_Start_Date_Time__c%','Please note the system will be down for maintenance at the following times:%Planned_Start_Date_Time__c% | %Planned_End_Date_Time__c%','Test');
        }
        test.stopTest();
        
       }*/
        
}