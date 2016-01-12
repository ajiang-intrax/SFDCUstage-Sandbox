@isTest
private class Test_MenuApplication_Controller {

    static testMethod void myUnitTest1() {
        
        PageReference p=Page.AppEngine_Home; 
        Test.setCurrentPage(p); 
        
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
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        sysAdmin.Email='test@josele.com';
        //update sysAdmin;
        //Portal User
        User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = 'test@josele.com', User_Interests__c='Hosting an au pair');
            
        insert user;
        
        //Create a new test account and set contact as portal contact
        Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
        insert portalAccount;
            
        //Fetch intract Id for this account id
        portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
        Account myAccount = new Account(Name='Test');
        insert myAccount;
         
        Position__c myPosition = new Position__c(Name='TestPosition',Host_Company_Id__c=myAccount.Id, Status__c ='Matching', Country__c = 'United States');
        insert myPosition;
        
        
        System.runAs(sysAdmin){
        
       
            
         //Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country', Position__c= myPosition.id,
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = sysAdmin.Id);
        insert appInfo;
        
       
        test.starttest();
        
        MenuApplication_Controller controller = new MenuApplication_Controller();
        
        String appId=controller.appId;
        String viewpage=controller.viewpage;
        PageReference page=controller.page;
        String appIdAux2=controller.appIdAux2;
        
        ApexPages.currentPage().getParameters().put('nextPage', '/apex/your_applications');
       
        controller.SubmitApp();
        
        ApexPages.currentPage().getParameters().put('id', appInfo.id);
        ApexPages.currentPage().getParameters().put('ObjId', appInfo.id);
        ApexPages.currentPage().getParameters().put('nextPage', 'true');
        ApexPages.currentPage().getParameters().put('viewpage', 'true');
        
        controller.SubmitApp();
        
        
        test.stoptest();
        
      }
     
    }
}