/**
 * An apex class that creates a portal user
 */
public without sharing class SiteRegisterController {
    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    private Id PORTAL_ACCOUNT_ID = CONSTANTS.Portal_Account_Id;
    public static Boolean isApexBeingTested = false;
    public User user;
    public User activeUser;
    public String appendSet {get; set;}
    public List<Applicant_Info__c> appInfoLead = new List<Applicant_Info__c>();
    public String userId;
    public String userAgentCheck {get; set;}
    public Boolean isService {get; set;}
    public String notServiceUserInterest {get; set;}
    public Boolean existingUser {get; set;}
    String IntraxId; 
     
    public User getUser() {
    
        return user;
    }
    
    public SiteRegisterController () {
        appendSet = IUtilities.rewriteUrl();
       
    }
    
    
    public string langFromURL;
    
    //This is only for registration page where the lang parameter is sent from Intrax website
    public string getLangFromURL(){
        string langFromURL='';
        if(ApexPages.currentPage().getParameters().get('lang') != null){        
            langFromURL = ApexPages.currentPage().getParameters().get('lang');                  
            if(langFromURL!=null){              
                if(langFromURL == 'es'){//Spanish
                    langFromURL='es';
                }           
                else if(langFromURL == 'pt_BR'){//Portuguese
                    langFromURL='pt_BR';
                }
                else
                    langFromURL='en_US';//English
            }
            else
                langFromURL='en_US';
            
            if(langFromURL=='' || langFromURL==null)
                langFromURL='en_US';
        }       
            System.debug('-----langFromURL:'+langFromURL);
            return langFromURL;
    }
    
      
     public SiteRegisterController(ApexPages.StandardController stdController) {
       //isService = false;
       appendSet = IUtilities.rewriteUrl();
        
       this.user = (User)stdController.getRecord();
       //appendSet = IUtilities.rewriteUrl();
       
       String uinString = ApexPages.currentPage().getParameters().get('uIn');
       
         if(ApexPages.currentPage().getParameters().get('uIn') != null){
            isUserInterestinURL = true;
        }else{
            isUserInterestinURL = false;
        }
        
        if(ApexPages.currentPage().getParameters().get('uIn')!=null){
            uInParameter = ApexPages.currentPage().getParameters().get('uIn');
        } 
         
         if(ApexPages.currentPage().getParameters().get('FN') != null){
            system.debug('*** Setting First Name' );
            firstname = ApexPages.currentPage().getParameters().get('FN');
         }
       
       if(ApexPages.currentPage().getParameters().get('LN') != null){
            lastname = ApexPages.currentPage().getParameters().get('LN');
       }
       
       if(ApexPages.currentPage().getParameters().get('email') != null){
            email = ApexPages.currentPage().getParameters().get('email');
       }
             
      }
     
    private String first_time_picklist_option = '- None -'; //first value to display in timezone picklist
    private String first_picklist_option = null; //first value to display in picklist
    private String Locale_first_picklist_option = 'English (United States)'; //first value to display in Time Zone picklist
    private User u; //User sobject
    public boolean hasErrorMessages {get; set;}
    //public String username {get; set;}
    public String firstname {get; set;}
    public String lastname {get; set;}
    public String email {get; set {email = value == null ? value : value.trim(); } }
    public String confirmEmail {get; set;}
    
    // public String timezone { get; set{value=User.TimeZoneSidKey;}}
    public String User_Interests{get; set;}
    public String timezone { get; set;}
    public String locale { get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    //public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public datetime executionTime = datetime.now();
    
    //paramaters to manage which program is the user trying to log/register in - we manage the logo, the backfround pic and the records and field values created.
    public boolean IsUserInterestinURL{get;set;}
    public String uInParameter {get; set;}

      
    public boolean isValidPassword() {
        return password == confirmPassword;
    }
    
     public boolean isValidEmail() {
        return email == confirmEmail;
    }
    
    @future
    public static void UserToInactive(Id userId){
        User userRecord = [select Id, User_Interests__c, Username, CommunityNickname, Email, isActive, IsUserNotServiced__c from User where Id = :userId];
        userRecord.isActive = false;
        userRecord.Username = userRecord.CommunityNickname;
        userRecord.Email = userRecord.CommunityNickname;
        userRecord.IsUserNotServiced__c = true;
        update userRecord;
    }
    
     public PageReference checkLogin(){
        
        isService = true; 
        
        //IGI - Remove Not Serviced Application and Inactive the User.
        list<Applicant_Info__c> appInfoToDelte = [Select Id, Lead__c, CreatedById from Applicant_Info__c where isApplicationDelete__c = true limit 1];
        if(appInfoToDelte != null && appInfoToDelte.size() == 1){
            isService = false;
            Id userId =  appInfoToDelte[0].CreatedById;
            User userInterest = [select Id, User_Interests__c from User where Id = :userId];
            notServiceUserInterest = userInterest.User_Interests__c;
            delete appInfoToDelte;
            UserToInactive(userId);
        }
        
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
        system.debug('*****###get userAgent: '+ApexPages.currentPage().getHeaders().get('USER-AGENT'));
        
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
    
    public PageReference registerUser() {
        
        existingUser=false;
        appendSet = IUtilities.rewriteUrl();
        system.debug('debug::UserInterest'+User_Interests);
        if (!isApexBeingTested){
            if(firstname == null || firstname == '' 
                    || lastname == null || lastname == '' 
                    || email == null || email == ''
                    || confirmEmail == null || confirmEmail == ''
                    //|| username == null || username == ''  
                    || password == null || password == '' 
                    || confirmPassword == null || confirmPassword == '' 
                    || Locale == ' ' || (ApexPages.currentPage().getParameters().get('uIn') == 'APCHF' && Locale == ' ')
                    || timezone == ' ' || (ApexPages.currentPage().getParameters().get('uIn') == 'APCHF' && timezone == ' ')
                    //|| (ApexPages.currentPage().getParameters().get('uIn') == '' && User_Interests == 'I am interested in' )
                    || (ApexPages.currentPage().getParameters().get('uIn') == null && User_Interests == null && Apexpages.currentPage().getParameters().get('partnerApp') == null)
                    
                    )               
                    /*
                    || (ApexPages.currentPage().getParameters().get('uIn') == null && Locale == null)
                    || timezone == '' || (ApexPages.currentPage().getParameters().get('uIn') == null && timezone == null)
                    || User_Interests == 'I am interested in' || (ApexPages.currentPage().getParameters().get('uIn') == null && User_Interests == null)
                    || timezone == '') 
                    */
                    {
                
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.T_0255);
                ApexPages.addMessage(msg);
                return null;
            }

        }
        
        
        
        // it's okay if password is null - we'll send the user a random password in that case// 
        if (!isValidPassword()) {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
          ApexPages.addMessage(msg);
            return null;
        }
        
        
        //Check the user is putting a correct email
        if (!isApexBeingTested){
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(email);
        if (!MyMatcher.matches()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.T_0356);
            ApexPages.addMessage(msg);
            return null;
        }
        }
        
        if (!isValidEmail()) {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.T_0357);
          ApexPages.addMessage(msg);
            return null;
        }    
        
        //if we want to check if the email is unique ???????????
        list<User> users = [SELECT Username,Email FROM User WHERE Username like: (email + '%') or Email=:email];
        //list<User> users = [SELECT Username,Email FROM User WHERE Username like: (username + '%')];
        // Now we need to process the received string, to get only the substring before the @ symbol
        system.debug('*******users**********'+users);
        String emailcon = ApexPages.currentPage().getParameters().get('email');
        list<Contact> con = new list<Contact>();
        list<Contact> lstConExist = new list<Contact>();
        if(ApexPages.currentPage().getParameters().get('uIn') == 'IGIC' && ApexPages.currentPage().getParameters().get('uIn') != null)
        {
          con = [SELECT Id, Name,Email, Account.Intrax_Id__c,Token__c from Contact where Email =:emailcon];
         
         list <Communication__c> com = new list <Communication__c>();
         if(con!=null && con.size()>0)
          {
            lstConExist = [Select Id, Name from Contact where AccountId =: con[0].AccountId];
            IntraxId = con[0].Account.Intrax_Id__c;
            com = [SELECT Id,Name,Token__c,Contact_Id__c from Communication__c where Contact_Id__c =:con[0].Id];
            if(com ==null && com.size() == 0)
            {
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, Invalid user');
             ApexPages.addMessage(msg);
             return null;
            }
             if(con[0].Token__c != ApexPages.currentPage().getParameters().get('Token'))
           
            {
              ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.T_431);
              ApexPages.addMessage(msg);
              return null;
             }
         
         }
         else
         {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, You are not authorised to register');
             ApexPages.addMessage(msg);
             return null;
         }
        }
        for(User u : users){
        
             //production version
            if(u.Email == email){
                system.debug('****** EMAIL ALREADY IN USE');
                existingUser=true;
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.T_0358);
                //ApexPages.addMessage(msg);
                return null;
            }
            
            
            /*
            //APC version to redirect existing email to the login page
            if(u.Email == email){
                system.debug('****** EMAIL ALREADY IN USE');
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The email you are trying to register with is already in use. Please choose another.');
                ApexPages.addMessage(msg);
                
                if (System.currentPageReference().getParameters().get('uIn') != null){
                  String paramuIn=System.currentPageReference().getParameters().get('uIn');
                  PageReference p= new PageReference('/apex/AppEngine_SiteLoginPage' + '?' + 'uIn=' + paramuIn);
                  p.setRedirect(true);
              return p;
                }else{
                  PageReference p= new PageReference('/apex/AppEngine_SiteLoginPage');
                  p.setRedirect(true);
              return p;
                }
              
            }*/
            
            //else if(u.Username.substringBefore('@') == username)
            else if(u.Username.substringBefore('@') == email){
                system.debug('****** USERNAME ALREADY IN USE');
                existingUser=true;
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.T_0359);
                //ApexPages.addMessage(msg);
                return null;
            }
        }
      
        //user.Username = username;
        user.Username = email;
        user.Email = email;
        user.FirstName = firstname;
        user.LastName = lastname;
        //string NickName = username+executionTime.getTime();
        string NickName = Email+executionTime.getTime();
        Integer NickNameLen=NickName.length();
        if(NickNameLen>40)
          NickName = NickName.right(40); 
        else
          //NickName = username+executionTime.getTime();  
          NickName = email+executionTime.getTime();  
          user.CommunityNickname = NickName;
        
        // Setting User Interests dynamically... 
        if(ApexPages.currentPage().getParameters().get('uIn') != null){
            User_Interests = ApexPages.currentPage().getParameters().get('uIn');
            if(User_Interests == 'IGIG') user.User_Interests__c = 'Finding an Internship';
            else if(User_Interests == 'AYPT') user.User_Interests__c = 'Becoming a high school exchange student';
            else if(User_Interests == 'AYHF') user.User_Interests__c = 'Hosting an international student';
            else if(User_Interests == 'CNPT') user.User_Interests__c = 'Studying English';
            else if(User_Interests == 'IGIC') user.User_Interests__c = 'Looking for an intern';
            else if(User_Interests == 'WTPT') user.User_Interests__c = 'Becoming a Work Travel Participant';
            else if(User_Interests == 'APCHF') user.User_Interests__c = 'Hosting an au pair';
            else if(User_Interests == 'APCPT') user.User_Interests__c = 'Becoming an au pair';
            else{
                isUserInterestinURL = false;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Value for User Interests. Please try again');
                ApexPages.addMessage(msg);
                return null;
            }
            
        }else if(Apexpages.currentPage().getParameters().get('partnerApp') != null){
            // We need to set the userInterests in this case...
            Applicant_Info__c appInfo = [select Intrax_Program__c, createdDate from Applicant_Info__c  where (Email__c =: user.Email AND Last_Name__c =: user.LastName) order by CreatedDate desc limit 1];
        
            if(appInfo.Intrax_Program__c == 'Internship') user.User_Interests__c = 'Finding an internship';
            else if(appInfo.Intrax_Program__c == 'Work Travel') user.User_Interests__c = 'Becoming a Work Travel Participant';
        }
        else user.User_Interests__c = User_Interests;
        
        
        if(User_Interests == 'APCHF' || User_Interests == 'APCPT'){
        //user.TimeZoneSidKey = 'America/Los_Angeles';
        //B-02904
        user.TimeZoneSidKey = 'Pacific/Chatham';
        
        }else{
            if (timezone != ' ') {
                user.TimeZoneSidKey = timezone;
            }
        }
        //user.TimeZoneSidKey = timezone;
        
        //if user interest is APCHF we are hidding this field in the page a storing USA in the backend.
        if(User_Interests == 'APCHF' || User_Interests == 'APCPT'){
        
        user.LocaleSidKey = 'en_US';
        
        }else{
          
          if(Locale != ' '){
        
          user.LocaleSidKey = locale;
        
           }
        }
        
        //Setting the Language for Centers application users from the URL parameter
        if(User_Interests == 'CNPT' && ApexPages.currentPage().getParameters().get('lang') != null){
            user.LanguageLocaleKey = getLangFromURL();
        }
       
       
       //B-03108
         if(ApexPages.currentPage().getParameters().get('IntId') != null){
         IntraxId = ApexPages.currentPage().getParameters().get('IntId');         
         }
      
      
       if(User_Interests == 'IGIC' && ApexPages.currentPage().getParameters().get('Token')!=null && user.User_Interests__c == 'Looking for an intern')
       {
         user.Type__c = 'Host Company';
         user.Intrax_Id__c = IntraxId;
       
        }
      //b-03108
       
       
       
       
        // Partner Invitation - Work Travel ( B-02480)
       List<Applicant_Info__c> appInfo_WTPartner = new List<Applicant_Info__c>();
       appInfo_WTPartner = [select id,Application_Level__c,Intrax_Program__c,Account__c,Engagement__c,Application_Stage__c, CreatedBy__c,CreatedBy__r.Profile.Name,RecordType.Name from Applicant_Info__c  where Email__c =: user.Email AND Intrax_Program__c='Work Travel' and RecordType.Name ='Work Travel PT' and CreatedBy__r.Profile.Name != 'OCPM PT'order by createdDate DESC];
      // String WT_userinterest = ApexPages.currentPage().getParameters().get('uIn');
        
       if ((appInfo_WTPartner!= null)&& (appInfo_WTPartner.size() >= 1))  {
            system.debug('*****CreatedById Profile Name'+ appInfo_WTPartner[0].CreatedBy__r.Profile.Name );
              String accountId_WT = PORTAL_ACCOUNT_ID;

              if (!isApexBeingTested){
                   userId = Site.createPortalUser(user, accountId_WT, password,false);
        
                  }
                system.debug('***** We have a Work Travel Partner App!');
                doSharing_PartnerApp(userId, appInfo_WTPartner);
        }
       
        
        
        
        String accountId = PORTAL_ACCOUNT_ID;

        // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        
        //Test class doesn't allow to create an Id. we use isApexBeingTested to provide an userId to the from the tes class and cover the code
        if (!isApexBeingTested)
        {
        //changed to false. 28th aug. Manish
         
        if(User_Interests == 'IGIC' && ApexPages.currentPage().getParameters().get('Token')!=null && user.User_Interests__c == 'Looking for an intern')
        {
         Contact cont = [Select id, name, Email,AccountId from Contact where id =: ApexPages.currentPage().getParameters().get('con')];
         if(cont!=null && cont.AccountId!=null)
         {
           if(userId==null){
           
            userId = Site.createPortalUser(user, cont.AccountId, password,false);
             system.debug('@@ user '+cont.AccountId);
          }
          }
         
         }
         
          if(userId==null){
            userId = Site.createPortalUser(user, accountId, password,false);
          }
        }
        
      //sending registration email 
        if (userId != null){
          
        //send an email to the new user
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String emailUser= email;
                System.debug('emaillllllllllllllllllllllllllllllllllllllllllllll'+ email);
                //String[] toAddresses = new String[]{emailUser,'jlopez@intraxinc.com'};
                String[] toAddresses = new String[]{emailUser};
                //mail.setToAddresses(toAddresses);
                mail.setSaveAsActivity(false);
                //mail.setSubject('AuPairCare Fee Payment Confirmation');
                //Get the payment email ID from Custom Setting Application Constants
                String EmailRegistrationId;
                List<Application_Constants__c> appconstants = Application_Constants__c.getall().values();
                Application_Constants__c appconstant = Application_Constants__c.getInstance('New_User_VF_AppEngine');
                EmailRegistrationId=appconstant.Value__c;
               
                mail.setTemplateId(EmailRegistrationId);
                mail.setTargetObjectId(userId); 
                emails.add(mail);
                
                Messaging.sendEmail(emails);
        
        }
                
                                
        // code to compare the AppInfo created form the Lead with the new user
        System.debug('User_Interests---->'+User_Interests);
        if (userId != null){
            if(User_Interests == 'APCHF'){
                
                //B-03329. Check for existing Lead before creating new
                List<Lead> existingLead = [select id,FirstName,LastName,Email,Status,LeadSource,Lead_Source_Tag__c,Intrax_Programs__c,Lead_Type__c from Lead where Email =: email and Status != 'Closed - Unqualified' and IsConverted = false order by CreatedDate DESC];
                if(existingLead!=null && existingLead.size()>0){
                    existingLead[0].FirstName = firstname;
                    existingLead[0].LastName = lastname;
                    existingLead[0].Email = email;
                    existingLead[0].Status = 'Open - New';
                    existingLead[0].LeadSource = 'Portal';
                    existingLead[0].Lead_Source_Tag__c = 'Application';            
                    
                    //Setting Intrax Programs                                            
                    existingLead[0].Intrax_Programs__c = 'AuPairCare';
                    existingLead[0].Lead_Type__c = 'Host Family';
                    
                    try{
                        update existingLead[0];
                    }
                    catch(exception e){
                        System.debug('ERROR IN UPDATING EXISTING LEAD'+e);
                    }
                }
                else{
                    //B-01474. Create Lead in Open-New (B-03329) status during user registration                         
                    Lead newlead = new Lead();
                    newLead.FirstName = firstname;
                    newLead.LastName = lastname;
                    newLead.Email = email;
                    newLead.Status = 'Open - New';
                    newLead.LeadSource = 'Portal';
                    newLead.Lead_Source_Tag__c = 'Application';            
                    
                    //Setting Intrax Programs                                            
                    newLead.Intrax_Programs__c = 'AuPairCare';
                    newLead.Lead_Type__c = 'Host Family';
                    
                    //newLead.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                    //newLead.Lead_Type__c = '';//Mandatory
                    //newLead.Intrax_Region__c = '';//Mandatory
                    
                    // to turn the Assignment Rules on
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    newLead.setOptions(dmo);
                    
                    try{
                        insert newLead;
                    }catch(Exception e){
                        system.debug('****** Impossible to create new Lead for the HF App: '+ e);
                    }
                }
            }
            //list<Applicant_Info__c> appInfoPartner = [select id,Application_Level__c,Account__c,Engagement__c,Application_Stage__c, CreatedBy__c from Applicant_Info__c  where (Email__c =: user.Email AND Last_Name__c =: user.LastName) ];
           list<Applicant_Info__c> appInfoPartner = [select id,Application_Level__c,Account__c,Intrax_Program__c,Engagement__c,Application_Stage__c, CreatedBy__c,RecordType.Name from Applicant_Info__c  where (Email__c =: user.Email AND Last_Name__c =: user.LastName AND RecordType.Name !='Work Travel PT' AND application_Stage__c != 'Cancelled') order by createdDate DESC];
            if(appInfoPartner != null && appInfoPartner.size()>0 && (ApexPages.currentPage().getParameters().get('partnerApp') == 'true' || ApexPages.currentPage().getParameters().get('partnerId') != NULL))
            {
               /* system.debug('***** We have a Partner App!');
                appInfoPartner[0].CreatedBy__c = userId;
                Applicant_Info__share ais = new Applicant_Info__share();
                system.debug('***** appInfoPartner[0].CreatedBy__c!'+ appInfoPartner[0].CreatedBy__c);
                ais.ParentId = appInfoPartner[0].Id;
                ais.UserOrGroupId = appInfoPartner[0].CreatedBy__c;
                ais.AccessLevel = 'Edit';
                Database.SaveResult sr = Database.insert(ais,false);
                If(appInfoPartner[0].Engagement__c !=null)
                {
                    Engagement__Share  engShare = new Engagement__Share ();
                    system.debug('****appInfoPartner[0].Engagement__c*****'+appInfoPartner[0].Engagement__c);   
                    engShare.ParentId = appInfoPartner[0].Engagement__c;
                    engShare.UserOrGroupId = UserId;
                    engShare.AccessLevel = 'Edit';
                    Database.SaveResult sr1 = Database.insert(engShare,false);
                    
                    AccountShare  accs = new AccountShare ();   
                    accs.AccountId = appInfoPartner[0].Account__c;
                    accs.UserOrGroupId = UserId;
                    accs.AccountAccessLevel = 'Edit';
                    accs.OpportunityAccessLevel = 'None';
                    System.debug('accs AccountID:'+accs.AccountId);
                    System.debug('accs UserOrGroupId:'+accs.UserOrGroupId);
                    Database.SaveResult sr2 = Database.insert(accs,false);
                    
                    
                    //Added By Saroj to correct the Notification Owner (Start)
                    list<Notification__c> WrongOwnerNotifications = [Select n.id, n.Owner.Profile.Name, n.OwnerId, n.Engagement__c From Notification__c n WHERE n.Engagement__c = :appInfoPartner[0].Engagement__c AND n.Owner.Profile.Name != 'OCPM PT'];
                    
                    if (WrongOwnerNotifications != NULL && WrongOwnerNotifications.size() > 0)
                    {
                        for (Notification__c correctNotify : WrongOwnerNotifications)
                        {
                            correctNotify.OwnerId = userId;
                        }
                        update WrongOwnerNotifications;
                    }
                    //Added By Saroj to correct the Notification Owner (End)
                    //B-02252
                      list<Assessment__c> WrongOwnerAssesments = [Select n.id, n.Owner.Profile.Name, n.OwnerId, n.Engagement__c From Assessment__c n WHERE n.Engagement__c = :appInfoPartner[0].Engagement__c AND n.Owner.Profile.Name != 'OCPM PT'];
                    
                    if (WrongOwnerAssesments != NULL && WrongOwnerAssesments.size() > 0)
                    {
                        for (Assessment__c correctNotify : WrongOwnerAssesments)
                        {
                            correctNotify.OwnerId = userId;
                        }
                        system.debug('*****WrongOwnerAssesments: ' +  WrongOwnerAssesments);
                        update WrongOwnerAssesments;
                    }
                    
                    
                } 
             
             // comment till the above line for removing sharing (AYII-136) 
             
                try{
                   update appInfoPartner;  
                  }
                  catch(Exception e){
                  
                  ApexPages.addMessages(e);
                        
                        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     
                         //create an email list
                         //String[] toAddresses = new String[]{'SFDCNotify@intraxinc.com'};
                         String[] toAddresses = new String[]{IUtilities.ULMEmail()};                         
                                  
                         mail.setToAddresses(toAddresses);
                         mail.setSubject('Site Register Exception');
                         mail.setPlainTextBody('User: '+ user.FirstName + ' ' + user.LastName + '. User ID: ' + userId + '. User Profile: ' + UserInfo.getProfileId() + '. Environment ' + Userinfo.getOrganizationId() + '. Method: registerUser(). Class: SiteRegisterController.cls. ' +  e.getMessage());
                         emails.add(mail);
                         Messaging.sendEmail(emails); 
                                   
                  }*/
            
            system.debug('Partner App (not WT)*****');
             doSharing_PartnerApp(userId, appInfoPartner);
          }
        // This code is supossed to be for the Hot Lead Conversion
            system.debug('***** user.Email: ' + user.Email);
            system.debug('***** user.LastName: ' + user.LastName);
            
            appInfoLead = [select id,Application_Level__c,Application_Stage__c, CreatedBy__c, Email__c from Applicant_Info__c  where (Email__c =: user.Email AND CreatedBy__c =: null AND Last_Name__c =: user.LastName) ];
        
            if ( appInfoLead != null && appInfoLead.size()>0 ){
            
                appInfoLead[0].CreatedBy__c = userId;
                appInfoLead[0].Application_Level__c = 'Main';
                appInfoLead[0].Application_Stage__c = 'Working';
                
                system.debug('*****appInfoLead[0].CreatedBy__c = ' + appInfoLead[0].CreatedBy__c);
            
              // comment the following for removing Sharing (AYII-136) (Line 153-158)
              
                Applicant_Info__share ais = new Applicant_Info__share();
    
                ais.ParentId = appInfoLead[0].Id;
                ais.UserOrGroupId = appInfoLead[0].CreatedBy__c;
                ais.AccessLevel = 'Edit';
                Database.SaveResult sr = Database.insert(ais,false);
            
             // comment till the above line for removing sharing (AYII-136) 
             
                try{
                   update appInfoLead;  
                  }
                  catch(Exception e){
                  
                  ApexPages.addMessages(e);
                        
                        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     
                         //create an email list
                         //String[] toAddresses = new String[]{'SFDCNotify@intraxinc.com'};
                         String[] toAddresses = new String[]{IUtilities.ULMEmail()};
                                  
                         mail.setToAddresses(toAddresses);
                         mail.setSubject('Site Register Exception');
                         mail.setPlainTextBody('User: '+ user.FirstName + ' ' + user.LastName + '. User ID: ' + userId + '. User Profile: ' + UserInfo.getProfileId() + '. Environment ' + Userinfo.getOrganizationId() + '. Method: registerUser(). Class: SiteRegisterController.cls. ' +  e.getMessage());
                         emails.add(mail);
                         Messaging.sendEmail(emails); 
                                   
                  }
                
                
                //Sharing_Security_Controller.shareRecord(appInfoLead[0].Id);
                         
            }
        }
                        
        
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                 PageReference rPage;
                 if (System.currentPageReference().getParameters().get('startUrl') != null){
                   //rPage = Site.login(username, password, '/'+System.currentPageReference().getParameters().get('startUrl')+'?'+appendSet);
                   rPage = Site.login(email, password, '/'+System.currentPageReference().getParameters().get('startUrl')+'?'+appendSet);
                 }
                 else{
                   //rPage = Site.login(username, password, '/LoginRedirection?'+appendSet);
                   rPage = Site.login(email, password, '/LoginRedirection?'+appendSet);
                 }
                        
                return rPage;
            }
            else {
                PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        hasErrorMessages = true;
        return null;
    }
    
   public void doSharing_PartnerApp(String user_id,List<Applicant_Info__c> partner_app)
    {      
               system.debug('***** We have a Partner App!');
                partner_app[0].CreatedBy__c = user_id;
                Applicant_Info__share ais = new Applicant_Info__share();
                ais.ParentId = partner_app[0].Id;
                ais.UserOrGroupId = partner_app[0].CreatedBy__c;
                ais.AccessLevel = 'Edit';
                Database.SaveResult sr = Database.insert(ais,false);
                If(partner_app[0].Engagement__c !=null)
                {
                    Engagement__Share  engShare = new Engagement__Share();
                    engShare.ParentId = partner_app[0].Engagement__c;
                    engShare.UserOrGroupId = user_id;
                    engShare.AccessLevel = 'Edit';
                    Database.SaveResult sr1 = Database.insert(engShare,false);
                    
                    AccountShare  accs = new AccountShare ();   
                    accs.AccountId = partner_app[0].Account__c;
                    accs.UserOrGroupId = user_id;
                    accs.AccountAccessLevel = 'Edit';
                    accs.OpportunityAccessLevel = 'None';
                    System.debug('accs AccountID:'+accs.AccountId);
                    System.debug('accs UserOrGroupId:'+accs.UserOrGroupId);
                    Database.SaveResult sr2 = Database.insert(accs,false);
                    
                    
                    //Added By Saroj to correct the Notification Owner (Start)
                    list<Notification__c> WrongOwnerNotifications = [Select n.id, n.Owner.Profile.Name, n.OwnerId, n.Engagement__c From Notification__c n WHERE n.Engagement__c = :partner_app[0].Engagement__c AND n.Owner.Profile.Name != 'OCPM PT'];
                    
                    if (WrongOwnerNotifications != NULL && WrongOwnerNotifications.size() > 0)
                    {
                        for (Notification__c correctNotify : WrongOwnerNotifications)
                        {
                            correctNotify.OwnerId = user_id;
                        }
                        update WrongOwnerNotifications;
                    }
                    //Added By Saroj to correct the Notification Owner (End)
                    //B-02252
                      list<Assessment__c> WrongOwnerAssesments = [Select n.id, n.Owner.Profile.Name, n.OwnerId, n.Engagement__c From Assessment__c n WHERE n.Engagement__c = :partner_app[0].Engagement__c AND n.Owner.Profile.Name != 'OCPM PT'];
                    
                    if (WrongOwnerAssesments != NULL && WrongOwnerAssesments.size() > 0)
                    {
                        for (Assessment__c correctNotify : WrongOwnerAssesments)
                        {
                            correctNotify.OwnerId = user_id;
                        }
                        system.debug('*****WrongOwnerAssesments: ' +  WrongOwnerAssesments);
                        update WrongOwnerAssesments;
                    }
                    
                    
                } 
             
             // comment till the above line for removing sharing (AYII-136) 
             
                try{
                   update partner_app;  
                    system.debug('***** user.Email: ' + user.Email);
                    system.debug('***** user.LastName: ' + user.LastName+'Profile****'+UserInfo.getProfileId());
                  
                  }
                  catch(Exception e){ 
                       List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     
                         //create an email list
                         //String[] toAddresses = new String[]{'SFDCNotify@intraxinc.com'};
                         String[] toAddresses = new String[]{IUtilities.ULMEmail()};                         
                                  
                         mail.setToAddresses(toAddresses);
                         mail.setSubject('Site Register Exception');
                         mail.setPlainTextBody('User: '+ user.FirstName + ' ' + user.LastName + '. User ID: ' + user_id + '. User Profile: ' + UserInfo.getProfileId() + '. Environment ' + Userinfo.getOrganizationId() + '. Method: registerUser(). Class: SiteRegisterController.cls. ' +  e.getMessage());
                         emails.add(mail);
                         Messaging.sendEmail(emails); 
                       //system.debug('Partner app -- error'+e);
                
                  }
              return;
    }
   public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
      List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
      if (first_val != null) { //if there is a first value being provided
         options.add(new selectOption(first_val, first_val)); //add the first option
      }
      Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
      Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
      Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
      List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
      for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
         options.add(new selectOption(a.getValue(),a.getLabel())); //add the value and label to our final list
      }
      return options; //return the List
   }
     
   //return the picklist options for User.TimeZoneSidKey
   public List<selectOption> getTimeZones() {
      return getPickValues( this.user, 'TimeZoneSidKey', first_picklist_option);
   }
   
   public List<selectOption> getLocales() {
      return getPickValues(this.user, 'LocaleSidKey', first_picklist_option);
   }
   
   public List<selectOption> getInterests(){
       return getPickValues(this.user, 'User_Interests__c', null);
   }
    
}