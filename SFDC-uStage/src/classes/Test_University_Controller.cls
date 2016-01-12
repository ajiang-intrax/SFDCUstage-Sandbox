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
private class Test_University_Controller {

    static testMethod void myUnitTest() {
		//Account userAccount = [SELECT Id FROM Account WHERE Name =: 'Intrax Program Applicants' limit 1];
    	//Contact
        //Contact userContact = new Contact(LastName = 'LastName', AccountId = userAccount.Id, email = 'test@test.com');
        //insert userContact;
        list<Profile> profiles = [Select Id from Profile where Name = 'OCPM University' limit 1];
        
        
    	Account grAccount = new Account(Name ='Group Account', Type = 'Institution', Intrax_Programs__c = 'Internship', Institution_type__c = 'University');
        insert grAccount;
        
        Contact grContact = new Contact(FirstName = 'Group Contact FN', LastName = 'LN', Email = 'test@test.com', AccountId = grAccount.Id);
        insert grContact;        
    	
        //Portal User
        User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                ContactId = grContact.Id,
                                Intrax_Id__c ='I-123456',
                                Username = Math.random() + '@test.com');
        
        insert user;
        
        
        Group__c gr = new Group__c(Name='Group Test',Intrax_Program_Category__c='Social Development', Intrax_program_option__c='WEST',Engagement_Start__c = date.today() + 50, Engagement_End__c = date.today() + 100, Location__c = 'Madrid', Country__c = 'Spain');
		insert gr;
		
		Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-IGI', Street__c = 'test', City__c = 'test',
                                                                  	Postal_Code__c = '12345',  Type__c = 'Participant', Country__c = 'United States', 
                                                                  	Home_Phone__c = '12345', Intrax_Program__c = 'Internship',                 
                                                                  	Application_Stage__c = 'Main', Application_Level__c = 'Submitted',                                                                  
                                                                  	Primary_Language__c = 'English', Language_1__c = 'Spanish', Language_1_Proficiency__c = 'Advanced', 
                                                                  	createdBy__c = user.Id, Country_of_Interest__c = 'United States', 
               														Engagement_Start__c = date.today()+ 91, Engagement_End__c = date.today() + 200,
               														Group__c = gr.Id);
        insert appInfo;
        
        Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
				                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
				                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
				                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Test', role__c = 'Student', Citizenship__c = 'Spain',
				                                                    Date_of_Birth__c = date.newInstance(1995, 2, 17), Country_of_Residence__c = 'United States',
				                                                    Skype_Id__c = 'mySkype',
				               										Phone__c = '123456', Phone_Type__c = 'Home');
				               										
       insert personInfo;
       
       Person_Info__c emergency1 = new Person_Info__c(Primary_Applicant__c = false, Family_Member__c = true,
				                                                    First_Name__c  = 'Emergency', Gender__c = 'Male',
				                                                    Applicant_Info__c = appInfo.Id, Email__c = 'test@test.com',
				                                                    Birth_City__c = 'Murcia', Last_Name__c = 'Contact 1', role__c = 'Student',
				                                                    Date_of_Birth__c = date.newInstance(1972, 2, 17), 
				                                                    Skype_Id__c = 'mySkype', Emergency_Contact_Indicated__c = 'Yes',
				               										Phone__c = '123456', Phone_Type__c = 'Home');
      insert emergency1; 
      
      Intrax_Program_Upload__c ipu_invoice = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS', Group__c = gr.Id, Document_Type__c='Invoice');
      insert ipu_invoice;
      
      Intrax_Program_Upload__c ipu_group_upload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test2', Document_service__c  = 'DS', Group__c = gr.Id, Document_Type__c='University-Group-Uploads');
      insert ipu_group_upload;
      
      ApexPages.currentPage().getParameters().put('docType', 'Invoice');
       
      University_Controller controller = new University_Controller();       														
      controller.checkLogin();      
      
      ApexPages.currentPage().getParameters().put('dType', 'Invoice');
      ApexPages.currentPage().getParameters().put('groupId', gr.Id);
      ApexPages.currentPage().getParameters().put('docGUID', 'Test');
      ApexPages.currentPage().getParameters().put('appInfo', appInfo.Id);
      
      controller.load_by_docType();      
      controller.load_by_docGuid();
      controller.getDocumentUrl();
      controller.getReportUrl();
      controller.update_applicant_info();     
    
    }
}