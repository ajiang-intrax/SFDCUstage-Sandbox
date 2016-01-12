public without sharing class TemplateController {
    public boolean IsPartner {get;set;}
    public String appendSet {get; set;}
    public User user {get; set;}
    public String uInParameter {get; set;}   
    public list<Applicant_Info__c> appInfoList {get;set;}
    public list<String> contactIPList {get;set;}    
    
    public List<Contact> cList{get;set;}
    
    public TemplateController(){        
        shouldRedirect = false;
        
        user = [Select Id, FirstName, LastName, User_Interests__c, ContactId,Type__c,Intrax_Id__c, Contact.AccountId, Contact.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c from User where Id =: UserInfo.getUserId()];
        
        if(user.ContactId != null)
        cList = [Select Id,PTR_Portal_Intrax_Program_Default__c FROM Contact WHERE Id=:user.ContactId LIMIT 1];
        
        system.debug('*****### user.User_Interests__c: ' + user.User_Interests__c); 
        system.debug('*****## uIn: '+ ApexPages.currentPage().getParameters().get('uIn'));
        
        if(ApexPages.currentPage().getParameters().get('uIn')!= null){
            uInParameter = ApexPages.currentPage().getParameters().get('uIn');          
        }else{
            uInParameter = null;
        
        }
        
        if(user.Intrax_Id__c!=null && user.Type__c=='Partner'){     
            IsPartner = true;       
        }else{      
            IsPartner = false;                  
        }   
        system.debug('*****template appendSet before: ' + appendSet);   
        if (!ApexPages.currentPage().getParameters().containsKey('id')){        
            appendSet = IUtilities.rewriteUrl();                            
        }else{
            appendSet = '';             
        }           
        system.debug('*****template appendSet: after' + appendSet);
    }
    
    public Integer getUnreadCount(){
        System.debug('ENTERED UNREAD COUNT--->');
        string userType;
        Integer unreadCount;
        Set<Id> accIds = new Set<Id>();     
        String intraxprogram;
        
        if(user!=null){
            System.debug('ENTERED user--->'+user.Id);
            if(user.User_Interests__c!=null && user.User_Interests__c == 'Becoming an au pair'){
                userType = 'Participant';
                accIds = accountIds(userType);
                intraxProgram = 'AuPairCare';
            }
            else if(user.User_Interests__c!=null && user.User_Interests__c == 'Hosting an au pair'){
                userType = 'Host';
                accIds = accountIds('Host Family');
                intraxProgram = 'AuPairCare';
            }
            else if(user.Type__c!=null && user.Type__c=='Partner' && user.ContactId!=null && user.Contact.AccountId!=null && user.Contact.PTR_Portal_Intrax_Program_Default__c!=null){                
                unreadCount = [SELECT Count() FROM Notification__c WHERE Id!=NULL                                                           
                                AND User_Type__c = 'Partner'                                                            
                                AND Intrax_program__c =: user.Contact.PTR_Portal_Intrax_Program_Default__c
                                AND Account__c=:user.Contact.AccountId
                                AND Message_Status__c = 'Unread'];
            }
            
            if(accIds!=null && accIds.size()>0 && userType!=null && intraxProgram!=null){
                unreadCount = [SELECT Count() FROM Notification__c WHERE Id!=NULL                                                           
                                AND User_Type__c =: userType                                                            
                                AND Intrax_program__c =: intraxProgram
                                AND Account__c IN:accIds
                                AND Message_Status__c = 'Unread'];
            }
             
        }
        if(unreadCount!=null)
            return unreadCount;
        else
            return 0;
    }
    
    public Set<Id> accountIds(string userType){
        Set<Id> accIds = new Set<Id>();
        List<Applicant_Info__c> appList = new List<Applicant_Info__c>();
        try{
        if(user!=null && userType!=null){
            appList = [SELECT Id,Account__c,Account__r.PersonEmail,Intrax_program__c,Type__c,CreatedBy__c FROM Applicant_Info__c WHERE CreatedBy__c=:user.Id AND Intrax_program__c='AuPairCare' AND Type__c =:userType];          
            if(appList!=null && appList.size()>0){
                for(Applicant_Info__c app:appList){
                    if(app!=null && app.Account__c!=null)
                        accIds.add(app.Account__c);
                }
            }
        }
        }
        catch(exception e){
            system.debug(e);
        }       
        System.debug('accIds---->'+accIds.size());
        if(accIds!=null && accIds.size()>0){
            return accIds;
        }
        else
            return accIds;
    }
    
    public PageReference checkLogin(){
        //AA 27022014 Ayusa II (AY2)#626To resolve Empty Text Area Rendering issue which insert garbage Html code. 
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8; IE=9; IE=10');
        
        //Variable to hold the Pagereference                
        PageReference pageRef;
        system.debug('Looged in User Type '+userInfo.getUserType());
            
        //Checking for Site User
        if(userInfo.getUserType() == 'Guest') {
            
            //Redirect to login Page
            pageRef = Page.AppEngine_SiteLoginPage;
            pageRef.setRedirect(true);
            
        } else if(userInfo.getUserType() == 'Standard' || userInfo.getUserType() == 'PowerPartner') {
            
            system.debug('');
            return pageRef;
        }
           
        //Return pagereference
        return pageRef;
    }
    
    public String getDefaultIP(){
        string defaultIP='';
        if(user != null && user.Intrax_Id__c != null) {       
            if(user.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                if(user.Contact.PTR_Portal_Intrax_Program_Default__c == 'AuPairCare')
                    defaultIP = 'AuPairCare';
                else if(user.Contact.PTR_Portal_Intrax_Program_Default__c == 'Ayusa')
                    defaultIP = 'Ayusa';
                else if(user.Contact.PTR_Portal_Intrax_Program_Default__c == 'English and Professional Skills')
                    defaultIP = 'English Academy';
                else if(user.Contact.PTR_Portal_Intrax_Program_Default__c == 'Internship')
                    defaultIP = 'Global Internships'; 
                else if(user.Contact.PTR_Portal_Intrax_Program_Default__c == 'Work Travel')
                    defaultIP = 'Work Travel';              
            }
        }
        return defaultIP;
    }
    
    public String getContactIP(){
        string contactIP='';        
        
        if(user != null && user.Intrax_Id__c != null) {       
            if(user.Contact.Intrax_Programs__c != null){
                contactIP = user.Contact.Intrax_Programs__c;                              
            }
        }
        System.debug('contactIP------>'+contactIP);
        return contactIP;
    }
    
    public Integer getContactIPSize(){
        string contactIP='';
        contactIPList = new List<String>();
        
        if(user != null && user.Intrax_Id__c != null) {       
            if(user.Contact.Intrax_Programs__c != null){
                contactIP = user.Contact.Intrax_Programs__c;  
                contactIPList = contactIP.split(';');                            
            }
        }
        System.debug('contactIP------>'+contactIPList.size());
        return contactIPList.size();
    }
    
    public String redirectUrl {public get; private set;}
    public Boolean shouldRedirect {public get; private set;}
    
    public PageReference UpdateToAPC(){     
        if(cList!= null && cList.size()>0){
            cList[0].PTR_Portal_Intrax_Program_Default__c = 'AuPairCare';
            update cList[0];
        }                           
        PageReference pageRefHome = new PageReference('/apex/pr_home');         
        pageRefHome.setRedirect(true);
        return pageRefHome;         
    }
    
    public PageReference UpdateToAyusa(){           
        if(cList!= null && cList.size()>0){
            cList[0].PTR_Portal_Intrax_Program_Default__c = 'Ayusa';
            update cList[0];
        }           
        PageReference pageRefHome = new PageReference('/apex/pr_home');         
        pageRefHome.setRedirect(true);
        return pageRefHome;
    }
    public PageReference UpdateToEA(){      
        if(cList!= null && cList.size()>0){
            cList[0].PTR_Portal_Intrax_Program_Default__c = 'English and Professional Skills';
            update cList[0];
        }               
        PageReference pageRefHome = new PageReference('/apex/pr_home');         
        pageRefHome.setRedirect(true);
        return pageRefHome;
    }
    public pageReference UpdateToIntern(){      
        if(cList!= null && cList.size()>0){
            cList[0].PTR_Portal_Intrax_Program_Default__c = 'Internship';
            update cList[0];
        }               
        PageReference pageRefHome = new PageReference('/apex/pr_home');         
        pageRefHome.setRedirect(true);
        return pageRefHome; 
    }   
    
    public pageReference UpdateToWT(){      
        if(cList!= null && cList.size()>0){
            cList[0].PTR_Portal_Intrax_Program_Default__c = 'Work Travel';
            update cList[0];
        }           
        PageReference pageRefHome = new PageReference('/apex/pr_home');         
        pageRefHome.setRedirect(true);
        return pageRefHome; 
    }
    
    public boolean getIsMatchingStage(){
        list<Applicant_Info__c> appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c, Application_Level__c
                                                    FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                                                    order by CreatedDate desc];
    
        if(appInfoList.size() > 0){
            list<Id> engIds = new list<Id>();
            for(Applicant_Info__c app : appInfoList){
                if (app.Engagement__c != null) engIds.add(app.Engagement__c);
            }           
            if(engIds.size() > 0){
                list<Match__c> matches = [SELECT Id, Status__c, Engagement__c FROM Match__c WHERE Engagement__c IN: engIds 
                                            AND (Status__c =: 'Saved' OR Status__c =: 'Applied' OR Status__c =: 'Confirmed' OR Status__c =: 'Requested' OR Status__c =: 'Recommended')];
                
                if(matches.size() > 0) return true;
                else return false;
            }else return false;
        }else return false;
    }
    
    public boolean getAppStatus (){
        appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c, Application_Level__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            order by CreatedDate desc];
        
        if(appInfoList.Size() > 0){
            if(appInfoList[0].Application_Level__c == 'Main' && appInfoList[0].Application_Stage__c != 'Working')
            {
                return true;
            }
            else
            {
                return false;
            }
            
        }else return false;
    
    }
    
    public Id engagementId{
        get{            
            appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c, Application_Level__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() AND Application_Stage__c != 'Cancelled'
                            order by CreatedDate desc];
                            
            Applicant_Info__c app = appInfoList[0];
            
            if(app.Engagement__c != null){
                return app.Engagement__c;
            }else return null;
            
        }
    }
    
    public Applicant_Info__c getCurrentApp(){
        Applicant_Info__c currentApp;
        List<Applicant_Info__c> currentAppInfoList = [SELECT Id, CreatedBy__c, Account__c, Application_Type__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c, Application_Level__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            order by CreatedDate desc];
        if(currentAppInfoList!=null && currentAppInfoList.size()>0){
            currentApp = currentAppInfoList[0];
        }
        if(currentApp!=null && currentApp.Id!=null){
            return currentApp;
        }else return null;
    }
    
    public Applicant_Info__c getOriginalApp(){
        Applicant_Info__c currentApp;
        List<Applicant_Info__c> currentAppInfoList = [SELECT Id, CreatedBy__c, Account__c, Application_Type__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c, Application_Level__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            AND Application_Type__c='Original'];
        if(currentAppInfoList!=null && currentAppInfoList.size()>0){
            currentApp = currentAppInfoList[0];
        }
        if(currentApp!=null && currentApp.Id!=null){
            return currentApp;
        }else return null;
    }
    
}