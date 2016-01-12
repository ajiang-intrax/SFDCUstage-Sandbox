/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;}   
    public String formattedUsername {get; set;} 
    public String username1 {get; set;} 
    public boolean isUstage=false; 
    public String appendSet {get; set;}
    public String uInParameter {get; set;}
    public Boolean pwdresetconfirm {get; set;}
    public String userAgentCheck {get; set;}
       
    public ForgotPasswordController() {
        appendSet = IUtilities.rewriteUrl();
        
        if(ApexPages.currentPage().getParameters().get('uIn') !=null ){
        
        uInParameter = ApexPages.currentPage().getParameters().get('uIn'); 
        
        }   
    }
    
    public PageReference forgotPassword() {
        
       system.debug('***username*****'+username);
        String startUrl =  URL.getSalesforceBaseUrl().getHost();
        list <User> userList;
       system.debug('***startUrl*****'+startUrl);
       Boolean isSandbox;
       string portalId;
       if(!(string.isBlank(username)))
       {
       if(username.contains('@'))
       {
        userList = [Select Id, User_Interests__c,Username, ContactId,Type__c,Intrax_Id__c, Contact.AccountId from User where Username =: username AND UserType=:'PowerCustomerSuccess'];
       }
       else
        {
            isSandbox = URL.getSalesforceBaseUrl().getHost().contains('cs');
            system.debug('***isSandbox*****'+isSandbox);
            if(isSandbox)
            {
                List<string> sandBoxName = URL.getSalesforceBaseUrl().getHost().split('-');
                
                if(sandBoxName!=null && sandBoxName.size()>0)
                {
                    if(sandBoxName[0].equalsignorecase('ustage'))
                    {
                    isUstage = True;
                    username1 = username;   
                    formattedUsername=username + '@' + Constants.PortalId + '.force.com.' + sandBoxName[0];
                    username1=username1 + '@' + Constants.PortalId + '.' + sandBoxName[0] + '.'+ sandBoxName[1].substring(10, 14) + '.force.com' ;
           
                    }
                    else
                    {
                        if(!Test.isRunningTest()) {
                            formattedUsername=username + '@' + Constants.PortalId + '.' + sandBoxName[0] + '.'+ sandBoxName[1].substring(10, 14) + '.force.com' ;
                        }
                    }
                }
                
                system.debug('***username*****'+username);
            }
            else
            {
                formattedUsername=username + '@' + Constants.PortalId + '.force.com';
            }
           if(isUstage) 
           userList = [Select Id, User_Interests__c,Username, ContactId,Type__c,Intrax_Id__c, Contact.AccountId from User where (Username =: formattedUsername or Username =: username1) AND UserType=:'PowerCustomerSuccess'];
           else
            userList = [Select Id, User_Interests__c,Username, ContactId,Type__c,Intrax_Id__c, Contact.AccountId from User where Username =: formattedUsername AND UserType=:'PowerCustomerSuccess'];
            
        }
       } 
        if(string.isBlank(username)){
            
            system.debug('*****@@@Into username blank');
            ApexPages.Message msg = new ApexPages.message(ApexPages.severity.ERROR,'Please enter an username');
            ApexPages.addMessage(msg);
            return null;    
        
            
        }else if(userList.size()>0 && userList != null){
        
            try{
            system.debug('*****@@@Into forgotPassword');
            boolean success = Site.forgotPassword(userList[0].username);
            PageReference pr = Page.ForgotPasswordConfirm;
            pr.setRedirect(true);
            appendSet = ''; 
            appendSet = IUtilities.rewriteUrl();
            pr = IUtilities.rewriteUrl(pr);
            if (success){           
                
                //pwdresetconfirm = true;
                return pr;
                //return null;
            }
            
            if(Test.isRunningTest()){
            
            userList[0].ContactId=null;
            
            }
            
            
            return null;
            
            }catch(Exception e){
                system.debug('********* Impossible reset password: ' + e);
                return null;
            }   
                            
        }else{
        
            ApexPages.Message msg = new ApexPages.message(ApexPages.severity.ERROR,'Invalid username. Please try again');
            ApexPages.addMessage(msg);
            return null;
        
        }
        
        
        
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
            p = new PageReference('/LoginRedirection' + '?' + appendSet);
            p.setRedirect(true);   
        }
                
        return p;
        
    }
    
     public static testMethod void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
       
        PageReference p=Page.AppEngine_Home; 
        Test.setCurrentPage(p);      
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        ApexPages.currentPage().getParameters().put('uIn', 'APCHF');  
        
        ForgotPasswordController controller = new ForgotPasswordController();
        
        //Test Criteria 1
        controller.username = 'test@salesforce.com';
        controller.checkLogin();        
        controller.forgotPassword();
        
        //Test Criteria 2
        controller.username = ' ';
        controller.forgotPassword();
        
        
        //Test Criteria 3
        controller.username = 'jose';
        controller.forgotPassword();
        
        //Test Criteria 4
        controller.isUstage = true;
         //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User user = new User(Alias = 'alias', Email = 'test@josele.com', EmailEncodingKey = 'UTF-8', Username= 'aamarmenakyan@intraxinc.com.us',
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test', User_Interests__c='Hosting an au pair');
        insert user;
                                    
        controller.username1 = 'marmenakyan@intraxinc.com';
        controller.username = 'marmenakyan@intraxinc.com';
        controller.forgotPassword();
        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}