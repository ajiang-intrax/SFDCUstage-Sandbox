public with sharing class FlowPassportUploadController {
   public Id appId{get;set;}
   public static boolean isApexNotTested= True;
public static string applicantId;

    
  public String strEid{get;set;}
  public List<Applicant_Info__c> lstApp; 
    public FlowPassportUploadController (){
        redirect();
       
         
    }   
   public PageReference redirect() {
        
      PageReference nextPage;
       
        String orgId = UserInfo.getOrganizationId();
        system.debug('*******orgid*******'+orgId);
        string strUrl;        
        if(isApexNotTested)
         {      
            strEid =  ApexPages.currentPage().getParameters().get('id');        
         }
         else
         {
            strEid = applicantId;                   
         }
        nextPage = new PageReference(Constants.FlowUploadServiceUrl);
            
        String envId = Constants.CONFG_ENV;    
                     
        nextPage.getParameters().put('OrgId',orgId);
        nextPage.getParameters().put('env',envId);      
        nextPage.getParameters().put('src',Constants.source); 
        nextPage.getParameters().put('pid','intern-pt');       
       
        nextPage.getParameters().put('aid',strEid);
        nextPage.getParameters().put('docType','Passport');
        nextPage.getParameters().put('retparam','FlowFinishUpload');
        system.debug('*******nextPage*******'+nextPage);
        nextPage.setRedirect(false);
        
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