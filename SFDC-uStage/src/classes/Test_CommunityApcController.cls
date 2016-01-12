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
@isTest(seeAllData = true)
private class Test_CommunityApcController {

    static testMethod void myUnitTest_RM() {
        
        
        Account accountRM = new Account(Name = 'Test', OwnerId = UserInfo.getUserId());
        
        insert accountRM;
        
        list<Profile> profiles = [Select Id from Profile where id=:constants.APCRMProfileId limit 1];// Name = 'APC RM' 
        
        Contact contact = new Contact(LastName = 'LastName', Email = 'test@test.com', AccountId=accountRM.Id);
        insert contact;
        
        //UserRole Urole=[SELECT Id, Name FROM Userrole where Name='APC California Sub Region Partner User' LIMIT 1];
        
        User userRM = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles',
                                    ContactId = contact.Id,Intrax_Id__c ='Test',//,UserRoleId=Urole.id,
                                    Username = Math.random() + '@test.com');
        
        
        insert userRM;
        
        Area_Profile__c area = new Area_Profile__c(Name = 'alias', Climate__c = 'test', Cities_Cervised__c= 'test');
        
        insert area;
        
        User_Profile__c userProf = new User_Profile__c(User__c = userRM.id, Name = 'alias', Employment_Term_Length__c = '3 months', Area_Profile__c = area.Id , 
                                    OwnerId = UserInfo.getUserId(), Monthly_Stipend__c = 45);
        insert userProf; 
        
        dsfs__DocuSign_Status__c docuSign = new dsfs__DocuSign_Status__c(dsfs__Envelope_Status__c = 'completed', UserProfile__c = userProf.id);
        
        insert docuSign;
        
        PageReference p=Page.apc_fs_rm_profile; 
        p.getParameters().put('uId',userRM.Id);
        p.getParameters().put('teamParam','true');
        p.getParameters().put('getUpdatedResult','true');
        Test.setCurrentPage(p); 
        
        //Test Start user RM
        system.runAs(userRM){
        test.startTest(); 
        
        //CASE 1
       CommunityApcController cac = new CommunityApcController();
        
       //cac.DeriveRetParam('test');
       cac.newhire();
       cac.btCancel();
       cac.getDocList();
       cac.buildMapDS();
       cac.buildDSflag();
       cac.cancel();
       //cac.saveProf();
       cac.saveArea();
       cac.redirectUser();
       cac.AddressValidation_controller();
       list<SelectOption> Region_List = cac.Region_List;
       list<SelectOption> getUSAStatesList = cac.getUSAStatesList;
       
       CommunityApcController.convertMonthNumberText(1);
       CommunityApcController.convertMonthNumberText(2);
       CommunityApcController.convertMonthNumberText(3);
       CommunityApcController.convertMonthNumberText(4);
       CommunityApcController.convertMonthNumberText(5);
       CommunityApcController.convertMonthNumberText(6);
       CommunityApcController.convertMonthNumberText(7);
       CommunityApcController.convertMonthNumberText(8);
       CommunityApcController.convertMonthNumberText(9);
       CommunityApcController.convertMonthNumberText(10);
       CommunityApcController.convertMonthNumberText(11);
       CommunityApcController.convertMonthNumberText(12);
       
       test.stopTest();
        }
    }
    
    static testMethod void myUnitTest_AD() {
        
        
        Account accountRM = new Account(Name = 'Test', OwnerId = UserInfo.getUserId());
        
        insert accountRM;
        
        list<Profile> profiles = [Select Id from Profile where id=:constants.APCADProfileId limit 1];//Name = 'APC AD - OCPM'
        
        Contact contact = new Contact(LastName = 'LastName',FirstName='FirstName', Email = 'test@test.com', AccountId=accountRM.Id);
        insert contact;
        
        Contact contact2 = new Contact(LastName = 'LastName',FirstName='FirstName', Email = 'test@test.com.cdev2', AccountId=accountRM.Id);
        insert contact2;
        
        
        User userAD = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    FirstName ='First Name',LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id,Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
        
        
        insert userAD;
        
        Area_Profile__c area = new Area_Profile__c(Name = 'alias', Climate__c = 'test', Cities_Cervised__c= 'test');
        
        insert area;
        
        User_Profile__c userProf1 = new User_Profile__c(User__c = userAD.id, Name = 'alias', Employment_Term_Length__c = '3 months', Area_Profile__c = area.Id , 
                                    OwnerId = UserInfo.getUserId(), Monthly_Stipend__c = 45);
        insert userProf1; 
        
        User_Profile__c userProf2 = new User_Profile__c(User__c = UserInfo.getUserId(), Name = 'alias2', Employment_Term_Length__c = '3 months', Area_Profile__c = area.Id , 
                                    OwnerId = UserInfo.getUserId(), Monthly_Stipend__c = 45);
                                    
        insert userProf2; 
        
        dsfs__DocuSign_Status__c docuSign = new dsfs__DocuSign_Status__c(dsfs__Envelope_Status__c = 'completed', UserProfile__c = userProf1.id,dsfs__DocuSign_Envelope_ID__c='12345678908987');
        
        insert docuSign;
        
        dsfs__DocuSign_Recipient_Status__c docuSignRecipient= new dsfs__DocuSign_Recipient_Status__c(dsfs__DocuSign_Routing_Order__c = 2,dsfs__Envelope_Id__c ='12345678908987',dsfs__DocuSign_Recipient_Id__c='42C22989-8CF4-43B3-873A-37B797F20646',dsfs__Recipient_Status__c ='Completed');
        Insert docuSignRecipient;
        
        Scorm__c scormRec = new Scorm__c(Name = 'alias',Course_Id__c='ahkhak72kjhgkahsd',Result__c='Passed',Is_this_a_quiz__c=true,Multi_Step_Course__c=false,Score__c=10.0,Course_Name__c='APC Test Course',Scorm_Application_ID__c='EVZYGQR5ND',Learner_Id__c='abc@yahooo.com',Total_Time__c='0',User_Profile__c=userProf1.id,Passed_Date__c=date.newInstance(1980, 2, 17));
        insert scormRec; 
        
        Scorm__c ParentscormRec = new Scorm__c(Name = 'Palias',Course_Id__c='ahkhak72kjhgkahsd',Parent_Course_Name__c=scormRec.id,Is_this_a_quiz__c=true,Multi_Step_Course__c=false,Score__c=10.0,Course_Name__c='APC Test Course',Scorm_Application_ID__c='EVZYGQR5ND',Learner_Id__c='abc@yahooo.com',Total_Time__c='0',User_Profile__c=userProf1.id,Passed_Date__c=date.newInstance(1980, 2, 17));
        
        Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS',Document_Type__c='Certificate',Scorm__c=scormRec.id,User_Profile__c=userProf1.id);
        insert ipUpload;
        
        PageReference p=Page.apc_fs_ad_profile; 
        
        p.getParameters().put('areaParam','true');
        Test.setCurrentPage(p); 
        
       //Test Start user RM
        system.runAs(userAD){
        test.startTest(); 
        
        
        //CASE 1
       ApexPages.currentPage().getParameters().put('RegistrationId', '12adasadad123');
       CommunityApcController cac = new CommunityApcController();
        
       //cac.DeriveRetParam('test');       
       cac.docType = 'Participant-Photo';
       cac.getDocList();
       cac.buildMapDS();
       cac.buildDSflag();
       cac.buildMapDS();
       cac.cancel();
       //cac.saveProf();
       cac.saveArea();
       cac.redirectUser();
       list<User_Profile__c> listU = new  list<User_Profile__c>();
       listU.add(userProf1);
       cac.ListUserProf = listU;
       cac.buildMapDS();
       for(integer i=1;i==12;i++){
       string month=CommunityApcController.convertMonthNumberText(i);
       }
       //cac.generateScormCertificate();
       //cac.setTestMode();
       ScormWebService.Courselaunch course = new ScormWebService.Courselaunch();
       course.score='';
       course.success='Passed';
       
       ScormWebService sws = new ScormWebService();
       sws.setTestMode();
       
       cac.scormId=scormRec;
       cac.userProf=userProf1;
       
       cac.generateResult();
       
       ApexPages.currentPage().getParameters().put('ScormID', scormRec.id);
       cac.generateResult();
       
       ApexPages.currentPage().getParameters().put('ScormID', scormRec.id);
       scormrec.Registration_Id__c='12dfaeerasdf';
       update scormrec;
       cac.generateResult();
       
       
       ApexPages.currentPage().getParameters().put('ScormID', null);
       ApexPages.currentPage().getParameters().put('getUpdatedResult', scormRec.id);
       ScormWebService.Courselaunch course2 = new ScormWebService.Courselaunch();
       course2.score='10.00';
       course2.success='Passed';
       course2.complete='complete';
       
       sws.courses=course2;

       cac.generateResult();

       cac.con=contact2;
       cac.newareaProf=area;
       cac.createPartnerAcc();
       
       cac.newareaProf = area;
       cac.con.LastName='Denia';
       cac.createPartnerAcc();
       
       cac.callScormService();
      

       ApexPages.currentPage().getParameters().put('ScormID', null);
       ApexPages.currentPage().getParameters().put('getUpdatedResult', scormRec.id);
       course.score='unknown';
       course.success='Passed';
       //cac.generateResult();
       cac.getLatestScormResults(scormRec);
       
       cac.Ischeck();  
        
       test.stopTest();
        }
    }
}