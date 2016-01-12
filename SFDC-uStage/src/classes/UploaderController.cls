public with sharing class UploaderController {
    
    public String fileUploadUrl{get;set;}
    public String retParam {get;set;}
    public String RetString {get;set;}
    public String orgid {get;set;}
    public String ProgId {get;set;}
    public String appId {get;set;}
    public String docType {get;set;}
    public static Boolean isTestMode = false;
    
    public string engId{get;set;}
    
    public UploaderController (){
    
    }
    
    public UploaderController (ApexPages.StandardController controller){
    
    }
    
    public PageReference goToUploader(){
    
    fileUploadUrl = Constants.fileUploadUrl;
    ProgId = 'upload_pos_inf'; 
    if (!isTestMode)
        RetString =Site.getCurrentSiteUrl() + 'participant_thank_you_uploader?id='+ApexPages.currentPage().getParameters().get('id');//().removeEnd('/'); // +  '/apex/Home';
    else
        RetString = '';
    orgID = UserInfo.getOrganizationId();
    
    engId = ApexPages.currentPage().getParameters().get('id');
    
    List<Position_Info__c> lstPosInfo = [SELECT Id,Engagement__c,CreatedDate FROM Position_Info__c WHERE Engagement__c=:engId ORDER BY CreatedDate DESC LIMIT 1];
    if(lstPosInfo.size()>0){
        appId = lstPosInfo[0].Id;
    }
    else
        appId = '';
     
    docType = ApexPages.currentPage().getParameters().get('docType');
        
    if(ApexPages.currentPage().getParameters().get('docType')!=null && ApexPages.currentPage().getParameters().get('id')!=null){
        System.debug('####### RetString: ' + RetString);
        retParam = EncodingUtil.base64Encode(Blob.valueOf(RetString));
        System.debug('####### retParam: ' + retParam); 
    }       
    
    PageReference p = new PageReference(fileUploadUrl); 
    p.getParameters().put('aid', appId);
    p.getParameters().put('docType', docType);
    p.getParameters().put('retparam', retParam);
    p.getParameters().put('orgid', orgID);
    p.getParameters().put('pid', ProgId);
    p.getParameters().put('rType', 'pos_inf');
    
    system.debug('@@@p:' + p);
    p.setRedirect(true);
    return p;
    
    }
}