public without sharing class MyProfileEditPageController {
    private User user;
    private boolean isEdit = false;
    public String  strURL;
    public Id contactId;
    public User getUser() {
        return user;
    }
    public String DbUserEmail {get; set;}
    public String trimUserName {get; set;}
   
    public MyProfileEditPageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email,createddate,User_Interests__c
                FROM User
                WHERE id = :UserInfo.getUserId()];
         DbUserEmail=user.email;
         contactId= user.contact.id;
         TrimUserName=(user.username).substringBefore('@');
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
        
        //AA For APC New version CSS Browser Compatibility Fixed.
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        if(userAgent.contains('rv:11.0')) {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        }
        else{
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', ' IE=Edge');
        }  
    }
    
    public PageReference save() {
         if (user.contact != null) {             
            setContactFields(user.contact, user);
        }
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern = Pattern.compile(emailRegex);
            // Then instantiate a new Matcher object "MyMatcher"
            Matcher MyMatcher = MyPattern.matcher(DbUserEmail);
            if (!MyMatcher.matches()) {
              ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Email, please try again');
                  ApexPages.addMessage(msg);
                  return null;
            }
        
        
        system.debug('debug::User Email'+user.email);
        system.debug('debug::User New Email'+DbUserEmail);
        
        list<User> lstUsers = [SELECT Id,Username,Email FROM User WHERE (Email=:DbUserEmail or Username =:DbUserEmail) AND Id!=:UserInfo.getUserId() Limit 1];
        
        system.debug('List of Users'+lstUsers);
          If(lstUsers.size()>0){
            for(User u : lstUsers){
                 //production version
                system.debug('debug::Duplicate User Email'+u.Email);
             if(u.email == DbUserEmail){
                    system.debug('****** EMAIL ALREADY IN USE');
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info, 'The email you are trying to register with is already in use. Please choose another.');
                    ApexPages.addMessage(msg);
                    return null;                    
                }
             else if(u.username == DbUserEmail){ 
             system.debug('****** User name already IN USE');
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info, 'Email you are trying to register is matched with username.Please choose another.');
             ApexPages.addMessage(msg);
             return null;      
            }
           }
        }
          
        If(user.username.contains('06030000000pqif')){
        PageReference Profilepage =new PageReference( '/account_overview_edit_msg?DbUserEmail='+DbUserEmail);
        //Profilepage = IUtilities.rewriteUrl(Profilepage);
        Profilepage.setRedirect(true);
        return Profilepage;
        }
        try {
         user.username=DbUserEmail;
         user.email=DbUserEmail;    
         update user;
         PageReference Profilepage =new PageReference( '/account_overview'); 
         if (user.contact != null) 
         {         
            Profilepage =new PageReference( '/account_overview_dummy'); 
         }
         else
         {
         	Profilepage =new PageReference( '/account_overview');   
         }
         Profilepage.setRedirect(true);
         Profilepage = IUtilities.rewriteUrl(Profilepage);
         return Profilepage;
         isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
         
         PageReference Profilepage;
         Profilepage =new PageReference('/account_overview');   
         Profilepage.setRedirect(false);
         Profilepage = IUtilities.rewriteUrl(Profilepage);
         return Profilepage;
    }
    
        public PageReference confirm() {
        if (user.contact != null) {             
            setContactFields(user.contact, user);
        }
         try {
             string NewUserEmail=Apexpages.currentpage().getparameters().get('DbUserEmail');
             If(user.username != NewUserEmail){
             user.username=NewUserEmail;
             user.email=NewUserEmail;
             update user;
             PageReference Profilepage =new PageReference( '/account_overview');   
             Profilepage.setRedirect(true);
             Profilepage = IUtilities.rewriteUrl(Profilepage);
             return Profilepage;
             }
             else{
             user.email=NewUserEmail;
             update user;
             }
             if (user.contact != null) { 
                    update user.contact;
                }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
         
         PageReference Profilepage =new PageReference( '/account_overview');   
         Profilepage.setRedirect(false);
         Profilepage = IUtilities.rewriteUrl(Profilepage);
         return Profilepage;
    }
      
    public PageReference cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title, User_Interests__c,
               street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
              FROM User
              WHERE id = :UserInfo.getUserId()];
       
       PageReference Profilepage;
        
       if(user.User_Interests__c == 'Hosting an au pair' || user.User_Interests__c == 'Becoming an au pair'){
             Profilepage =new PageReference('/account_overview');
       }else{
            Profilepage =new PageReference( '/account_overview');
       }
       Profilepage.setRedirect(true);
       //Profilepage = IUtilities.rewriteUrl(Profilepage);
       return Profilepage;    
    }
    
    private static void setContactFields(Contact c, User u) {
        c.title = u.title;
        c.firstname = u.firstname;
        c.lastname = u.lastname;
        c.email = u.email;
        c.phone = u.phone;
        c.mobilephone = u.mobilephone;
        c.fax = u.fax;
        c.mailingstreet = u.street;
        c.mailingcity = u.city;
        c.mailingstate = u.state;
        c.mailingpostalcode = u.postalcode;
        c.mailingcountry = u.country;
    }
   
    
    public PageReference update_contact()
    {   System.debug('Contact:'+contactid+'User id'+ user.id);
    	Contact vCont= [Select Email from Contact where id=:contactid limit 1];
    	User v_us=[Select Email from User where id=:user.id limit  1];
    	if((vCont !=null) && (v_us!=null)){
    	vCont.Email=v_us.Email;
    	update vCont;
    	List<Applicant_Info__c> app= new List<Applicant_Info__c>();
        app = [select id,Account__r.Id, Email__c from Applicant_Info__c where CreatedBy__c =: user.id order by LastModifiedDate DESC];
    	System.debug('Contact Email'+vCont.Email);
    	if((app!=null) & (app.size() >=1)) {
    		app[0].Email__c = v_us.Email;
    		update app[0];
            List<Person_Info__c> per= new List<Person_Info__c>();
            per =[select id,Email__c,Applicant_Info__c from Person_Info__c where Applicant_Info__c=:app[0].id and Primary_Applicant__c = true];
    		if((per!=null)&(per.size() >=1)){
    			per[0].Email__c=v_us.Email;
    			update per[0];
    		}
    	 }
    	}
    	
    	 PageReference Profilepage =new PageReference( '/account_overview');   
         Profilepage.setRedirect(true);
         Profilepage = IUtilities.rewriteUrl(Profilepage);
         return Profilepage;
    }
}