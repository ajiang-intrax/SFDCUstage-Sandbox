@isTest
public with sharing class Test_IGI_Upload_Redirection_Controller {
    static testMethod void myUnitTest() {
        /* Opportunity hostOpportunity = new Opportunity(Name = 'Host - Opp', AccountId = hostCompany.Id, CloseDate = Date.Today(), StageName = 'Test',
                                                            Intrax_Programs__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostOpportunity;*/
            //Insert Position Instance
           /* Position__c position = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, Host_Opportunity_Id__c = hostOpportunity.Id, 
                                                    Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(),Engagement_End__c = date.today().addDays(15) );
            
            insert position;*/
             //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',type__c='Participant',Application_Stage__c = 'Declined - Agent',ETR_Received_Date__c=null);
                insert appInfo;
                system.debug('*******appInfoid****'+appInfo.Id);
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id,citizenship__c='United States');
                insert personInfo;
                Person_Info__c personInfo1 = new Person_Info__c(Primary_Applicant__c = false, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo.Id,citizenship__c='Singapore');
                insert personInfo1;
                Test.startTest();
                pagereference pgref;                
                IGI_Upload_Redirection_Controller.isApexNotTested=false;
                IGI_Upload_Redirection_Controller.applicantId=appInfo.Id;
                IGI_Upload_Redirection_Controller upload= new IGI_Upload_Redirection_Controller();
               
       
        //system.debug('******ref*********'+guc.strRef);
        //guc.redirect();
        Test.stopTest();
    }
}