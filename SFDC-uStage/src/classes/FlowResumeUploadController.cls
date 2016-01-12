public class FlowResumeUploadController {
   
   public static boolean isApexNotTested= True;
    public static string applicantId;
  public String strEid{get;set;}
  public List<Applicant_Info__c> lstApp; 
  
    public FlowResumeUploadController ()
     {
       redirect();
     }
  
  
     public PageReference redirect()
     {
        PageReference nextPage;
       
        String orgId = UserInfo.getOrganizationId();
        system.debug('*******orgid*******'+orgId);
        string strUrl;        
        if(isApexNotTested)
         {      
            strEid = ApexPages.currentPage().getParameters().get('AppInfoID');      
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
        nextPage.getParameters().put('docType','Resume');
        nextPage.getParameters().put('retparam','FlowPassportUpload');
        system.debug('*******nextPage*******'+nextPage);
        nextPage.setRedirect(false);
        
        return nextPage;
        
     }

}