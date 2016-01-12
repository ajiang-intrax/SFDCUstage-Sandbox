/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    global String appendSet {get; set;}
    global String uInParameter {get; set;}
    global PageReference SiteLogin;
    public String userAgentCheck {get; set;}
    public Boolean firstTimeLogin {get; set;}
    public String apexErrorSummary {get; set;}
    
    global User user;
    
    global String nextPage {get; set
        {
            nextPage = value;
        }
    }
    
    global SiteLoginController(ApexPages.StandardController stdController){
        this.user = (User)stdController.getRecord(); 
        
    }
    
    
    global SiteLoginController(){
    	firstTimeLogin = false;
        appendSet = IUtilities.rewriteUrl();
        
    //uInParameter is used to detect which program we are into.
        if(ApexPages.currentPage().getParameters().get('uIn') !=null ){
        
        uInParameter = ApexPages.currentPage().getParameters().get('uIn'); 
        if((uInParameter=='WTPT'||uInParameter=='IGIG'||uInParameter=='APCPT') && ApexPages.currentPage().getParameters().get('IsRepeatApp')=='true' && ApexPages.currentPage().getParameters().get('email') !=null  &&ApexPages.currentPage().getParameters().get('isInvitation')=='true'){
        
        username = ApexPages.currentPage().getParameters().get('email'); 
        
        }
        
        }
      
    
       
    }
    //B-01356
    public string getURLParam(){
        String URLParam = ApexPages.currentPage().getParameters().get('uIn');
        return URLParam;
    }
    
    public PageReference checkLogin(){
        
            //Check if the device is a Mobile device 
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        //system.debug('*****@@@userAgent: '+ userAgent);
        userAgentCheck = '';
        //system.debug('*****@@@into checkIsMobile');
        
            if(userAgent.contains('Mobi') && !userAgent.contains('iPad')) {
                userAgentCheck = 'smartphone';
                system.debug('*****@@@userAgentCheck: '+ userAgentCheck);
            }
        
        //**end of the checking isMobile process
        
        //Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        //AA For APC New version CSS Browser Compatibility Fixed.
        
        if(userAgent.contains('rv:11.0')) {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        }
        else{
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', ' IE=Edge');
        }
         
        PageReference p;
        system.debug('*****###USERTYPE '+userInfo.getUserType());
        
        if (userInfo.getUserType() == 'Guest'){
            p = null;
        }else{
             //AA 30/4/2014 Maint# 243
             //p = new PageReference('/LoginRedirection' + '?' + appendSet)
             p = new PageReference('/MessagingPage' + '?' + appendSet);
             system.debug('guest');
            p.setRedirect(true);   
        }
                
        return p;
        
    }
    

    global PageReference login() {
        firstTimeLogin = false;
        system.debug('*****###UserInfo.getSessionId(); ' + UserInfo.getSessionId());
        system.debug('*****###UserInfo.getName(); ' + UserInfo.getName());
        system.debug('*****###UserInfo.getUserEmail(); ' + UserInfo.getUserEmail());
        
        String redirect = System.currentPageReference().getParameters().get('unauth');
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        System.debug('==== startUrl ====='+startUrl);       
        if (System.currentPageReference().getParameters().get('startUrl') != null)
        {
            startUrl = System.currentPageReference().getParameters().get('startUrl');
            
        }
        else
        {
             startUrl = System.currentPageReference().getParameters().get('nextPage');
             System.debug('==== startUrl ====='+startUrl); 
             if(uInParameter=='WTPT' && ApexPages.currentPage().getParameters().get('IsRepeatApp')=='true' && ApexPages.currentPage().getParameters().get('partnerId') !=null  && ApexPages.currentPage().getParameters().get('isInvitation')=='true'){
                startUrl = startUrl+'?uIn=WTPT&IsRepeatApp='+ApexPages.currentPage().getParameters().get('IsRepeatApp')+'&partnerId='+ApexPages.currentPage().getParameters().get('partnerId'); 
              }
             System.debug('==== startUrl ====='+startUrl);        
        }
        
        if(!startUrl.contains('/Positions?') && !startUrl.contains('/RemoteAccessAuthorizationPage.apexp?') && redirect=='true'){
            startUrl = startUrl+'?'+appendSet;
            appendSet =  IUtilities.rewriteUrl(); 
            System.debug('==== appendSet====='+appendSet);
        }
           System.debug('==== startUrl ====='+startUrl);       
       
       try{       	
   		
       System.debug('*****@@@ startUrl: '+startUrl);
       system.debug('password:::::::::' +password);
       SiteLogin = Site.login(username, password, startUrl);
       System.debug('*****@@@ SiteLogin: '+SiteLogin);
       
       }catch(Exception e){       					
       					
       					ApexPages.addMessages(e);
                        
                        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     
                         //create an email list
                         //String[] toAddresses = new String[]{'SFDCNotify@intraxinc.com', 'jlopez@intraxinc.com'};
                         String[] toAddresses = new String[]{IUtilities.ULMEmail(), 'jlopez@intraxinc.com'};
                                  
                         mail.setToAddresses(toAddresses);
                         mail.setSubject('Control Login Exception');
                         mail.setPlainTextBody('User: '+ user.FirstName + ' ' + user.LastName + '. User ID: ' + user.Id + '. User Profile: ' + UserInfo.getProfileId() + '. Enviorement(SB or Prod): ' + Userinfo.getOrganizationId() + '. Method: login(). Class: SiteLoginController.cls. ' + ' Exception (Line - 51): '+ e.getMessage());
                         emails.add(mail);
                         Messaging.sendEmail(emails); 
        }
        
        //##### - HP
       	if(SiteLogin == null && password != null && password != ''){
       		list<User> userRecord = new list<User>();
			userRecord = [select Id, isActive, Sys_Admin_Tag__c, lastlogindate  from User where Username = :username and isActive = true and lastlogindate = null and Sys_Admin_Tag__c != null and (User_Interests__c = 'Hosting an au pair' or User_Interests__c = 'Becoming an au pair')];
			//userRecord = [select Id, isActive, Sys_Admin_Tag__c, lastlogindate  from User where Username = :username and isActive = true and Sys_Admin_Tag__c != null and (User_Interests__c = 'Hosting an au pair' or User_Interests__c = 'Becoming an au pair')];
	        if(userRecord != null && userRecord.size() > 0){
	        	firstTimeLogin = true;
	        	apexErrorSummary = 'Welcome back! We have been busy making improvements. <br><br><a href="AppEngine_ForgotPassword?">Reset your password</a>';
	       	}
       	}
       	//##### - HP
        return SiteLogin;
        
        //return Site.login(username, password, startUrl);
    }
    
    global static testMethod void testSiteLoginController () {
        test.StartTest();
           
            // Instantiate a new controller with all parameters in the page
            System.currentPageReference().getParameters().put('uIn','rv:11.0');
            SiteLoginController controller = new SiteLoginController ();
            controller.username = 'test@salesforce.com';
            controller.password = '123456'; 
            ApexPages.currentPage().getParameters().put('startURL', 'test');       
            System.assertEquals(controller.login(),null);    
            
            User user1 = [SELECT Id, Name, User_Interests__c From User WHERE User_Interests__c = 'Studying English' LIMIT 1];
            ApexPages.StandardController sc = new ApexPages.StandardController(user1);
            SiteLoginController controller1 = new SiteLoginController (sc);
            system.runAs(user1){
                //ApexPages.currentPage().getParameters().put('startURL1', 'testt');     
                controller1.login();
                Controller.nextPage='SomeValue';
                System.currentPageReference().getParameters().put('startURL','/Positio');
                System.currentPageReference().getHeaders().put('USER-AGENT','rv:12.0');
                System.currentPageReference().getParameters().put('unauth','true');
                controller1.checkLogin();
                System.currentPageReference().getHeaders().put('USER-AGENT','rv:11.0');
                controller1.checkLogin();
                controller1.login();
                System.currentPageReference().getParameters().put('uIn','rv:11.0');
                controller1.getURLParam();
            }
            
    test.StopTest();    
    }    

}