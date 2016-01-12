public with sharing class ScormWebService {
	
	public String responseJSON{get; set;}
	public String body{get; set;}
	public static Boolean isTestMode = false;
	public list<scorm__c> scormCoursetList;
	Http h = new Http();
    HttpResponse res = new HttpResponse();
	
	public with sharing class Courselaunch {
    public string launchUrl{get;set;}
    public string regid{get;set;}
    public string complete{get;set;}
    public string score{get;set;}
    public string totaltime{get;set;}
    public string format{get;set;}
    public string success{get;set;}
    public string instanceid{get;set;}
	}
	
    public String registrationId{get;set;}
    public String courseId{get;set;}
    public String learnerId{get;set;}
    public String learnerFirstName{get;set;}
    public String learnerLastName{get;set;}
    public String appId{get;set;}
    public Courselaunch courses{get;set;}
    
	public string generateGUID(){
	Blob aes = Crypto.generateAesKey(128);
	String hex = EncodingUtil.convertToHex(aes);
	System.debug('uuid is ' + hex);
	return hex;
	}
   
   
   public string CreateRegistration(){
    registrationId=generateGUID();
    HttpRequest req = new HttpRequest();
    req.setMethod('GET'); 
    req.setHeader('Accept', 'application/json');
    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
    
    // In All Test Enviroment enableScormProdTraining should be false because we used Generic First, Last Name and Email to launch the Training.
    If(constants.enableScormProdTraining== False){
        String testRegistrationId;
    	learnerFirstName='Test First_Name';
    	learnerLastName='Test_Last_Name';
    	learnerId='scormtest@email.com';
        List<Scorm_Settings__c> Scorm =[select Test_Registration_Id__c from Scorm_Settings__c where Course_Id__c =: courseId];
        if((Scorm!=null) && (Scorm.size() > =1)){
        testRegistrationId=Scorm[0].Test_Registration_Id__c;
        }
        system.debug('Registration Id '+testRegistrationId);
        return testRegistrationId;
    }
    string url=Constants.ScormServiceUrl+'createRegistration?registrationId='+registrationId+'&courseId='+courseId+'&learnerId='+learnerId+'&learnerFirstName='+learnerFirstName+'&learnerLastName='+learnerLastName+'&appId='+appId;
    url=url.replaceAll(' ','%20');
	req.setEndpoint(url);
	//req.setEndpoint(Constants.ScormServiceUrl+'createRegistration?registrationId='+registrationId+'&courseId='+courseId+'&learnerId='+learnerId+'&learnerFirstName='+learnerFirstName+'&learnerLastName='+learnerLastName);
    system.debug('debug::Request'+req);
     if (!isTestMode){
         res = h.send(req);
         responseJSON = res.getBody();
         system.debug('debug:responseStatusRegistartion======'+res);
         system.debug('debug:responseJSONRegistartion Message======'+responseJSON);
         If(responseJSON.contains('Successfully')){
         return registrationId;
         }
    }
  return null;
  }
  
  public PageReference getLaunchUrl(String regId, String ScormId, Boolean disableTracking,string appId){
    
    // Instantiate a new HTTP request, specify the method (getLaunchUrl) as well as the endpoint     
    HttpRequest req = new HttpRequest();
    req.setMethod('GET'); 
    req.setHeader('Accept', 'application/json');
    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
    //string retParam= 'https://' + ApexPages.currentPage().getHeaders().get('Host') +'/apcfield/apex/apc_fs_ad_training?getUpdatedResult='+ScormId;
    string retParam;
    system.debug('debug::ApexPages.currentPage()'+ApexPages.currentPage().getUrl());
     
    
    if (!isTestMode){
         		//getting the return URL for the SFDC enviorment (RM)
              if(ApexPages.currentPage().getUrl().contains('utype='+constants.APCRMProfileId)){ 
                //retParam='https://' + ApexPages.currentPage().getHeaders().get('Host') +'/apex/apc_fs_ad_training?getUpdatedResult='+ScormId;
                retParam=Site.getBaseUrl() +'/apex/apc_fs_ad_training?getUpdatedResult='+ScormId;
                System.debug('@@@@@ retParam: 1' + Site.getBaseUrl() );  
                System.debug('@@@@@ retParam: 2' + retParam );  

                //getting the return URL for the Communities (AD)
                }else if(ApexPages.currentPage().getUrl().contains('utype='+constants.APCADProfileId)){
                retParam=Site.getBaseUrl() +'/apex/apc_fs_ad_training?getUpdatedResult='+ScormId;
              
                }  
               else 
               {
                     
                 retParam=Site.getBaseUrl()+'/igi_home';  
                   
              }
    }
    
	req.setEndpoint(Constants.ScormServiceUrl+'getLaunchUrl?registrationId='+regId+'&redirectOnExitUrl='+retParam +'&disableTracking='+disableTracking+'&appId='+appId);
    system.debug('debug::Request'+req);
    String returnurl = null;
     if (!isTestMode){
         res = h.send(req);
         responseJSON = res.getBody();
         system.debug('debug::responseStatusRegistartion======'+res);
         system.debug('debug::responseJSONRegistartion Message======'+responseJSON);
         
         courses = (Courselaunch)JSON.deserialize(responseJSON,Courselaunch.class);
         system.debug('debug::deserializeString Message======'+courses.launchUrl);
         If(courses.launchUrl!= null){
         	return new PageReference(courses.launchUrl);
         }
    }
    
    return null;
  }
  
    public Courselaunch getRegistrationResult(string regId,string appId){
    
    // Instantiate a new HTTP request, specify the method (getLaunchUrl) as well as the endpoint     
    HttpRequest req = new HttpRequest();
    req.setMethod('GET'); 
    req.setHeader('Accept', 'application/json');
    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
	req.setEndpoint(Constants.ScormServiceUrl+'getRegistrationResult?registrationId='+regId+'&resultsFormat=course&dataFormat=JSON'+'&appId='+appId);
    system.debug('debug::Request'+req);
     if (!isTestMode){
         res = h.send(req);
         responseJSON = res.getBody();
         system.debug('debug::responseStatusRegistartion======'+res);
         system.debug('debug::responseJSONRegistartion Message======'+responseJSON);
         courses = (Courselaunch)JSON.deserialize(responseJSON,Courselaunch.class);
         system.debug('debug::deserializeString Message======'+courses);
         return courses;
     }else{
     	Courselaunch courseobj= new Courselaunch();
     	courseobj.score='10.0';
     	courseobj.success='Passed';
     	courseobj.complete='Complete';
     	courseobj.totaltime='120';
     	courses=courseobj;
     	return courses;
     }
    return null;
  }
  
   public void setTestMode(){
    isTestMode = true;
   }

}