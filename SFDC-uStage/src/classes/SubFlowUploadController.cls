public with sharing class SubFlowUploadController {
   public Id appId{get;set;}
   public static boolean isApexNotTested= True;
public static string applicantId;
    public SubFlowUploadController (){
    	if(isApexNotTested)
         {    	
     	  appId = ApexPages.currentPage().getParameters().get('id');
        system.debug('*********appid****'+appId);
         }
         else
         {
         	appId=applicantId;
         }
         
    }   
 
    public PageReference getFinishPage() {
    	
    PageReference nextPage;
    	
        nextPage = new PageReference('/FlowUploadController');
       
              
         return nextPage;
    }
    }
   
       
    
    /*static testMethod void testIt(){
        test.startTest();
        Applicant_Info__c a = new Applicant_Info__c();
        a.Last_Name__c = 'test';
        a.Street__c = 'test';
        a.City__c = 'test';
        a.State__c = 'CA';
        a.Postal_Code__c = '12345';
        a.Country__c = 'United States';
        a.Home_Phone__c = '12345';
        a.Date_of_Birth__c = date.ValueOf('1968-09-21');
        a.Email__c = 'test@test.com';
        insert a;
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        PageReference flsync = Page.FLAppSyncLeadExists;
        FlowController fc = new FlowController(sc);
        Test.setCurrentPageReference(flsync);
        fc.getFinishPage();     
        test.stopTest();
    }*/