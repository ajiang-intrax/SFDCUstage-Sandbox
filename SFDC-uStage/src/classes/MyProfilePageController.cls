/**
 * An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
 */
public with sharing class MyProfilePageController {

    private User user;
    private boolean isEdit = false;
    public String  strURL;
    public String URLAux{get;set;}
    public list<Applicant_Info__c> appInfoList {get;set;}
    public apc_billing_payments_controller apcBillingPayments{get;set;}
    public apc_billing_payments_controller apcBillingEditPage{get;set;}
    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email,User_Interests__c
                FROM User
                WHERE id = :UserInfo.getUserId()];
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
        
         URLAux = ApexPages.currentPage().getUrl(); 
        
        //The child controllers has to intialized as per the page invoked and then just return.
        if(URLAux!=null && (URLAux.contains('/apex/apc_billing_payments') ||
                            URLAux.contains('/apex/apc_view_sales_invoice') ))
        {
            apcBillingPayments = new apc_billing_payments_controller(this);
            return;
        }
        
        if(URLAux!=null && (URLAux.contains('/apex/apc_cc_update')))
        {
            apcBillingEditPage = new apc_billing_payments_controller('apc_cc_update');
            //return;
        }
    }
    
    public Boolean getIsEdit() {
        return isEdit;
    }
    
    public PageReference edit() {
      /*  
      PageReference editpage =new PageReference( '/MyProfileEditPage');
      */
      PageReference editpage =new PageReference( '/account_overview_edit');   
      isEdit = true; 
      editpage.setRedirect(true);
      editpage = IUtilities.rewriteUrl(editpage);
      return editpage;
    }    
    
    public void save() {
        if (user.contact != null) {              
            setContactFields(user.contact, user);
        }
        
        try {
            update user;
            if (user.contact != null) { 
                update user.contact;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }
    
    public PageReference changePassword() {
        PageReference cp = Page.AppEngine_ChangePassword;
        cp = IUtilities.rewriteUrl(cp); 
        return cp;
    }
    
    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
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
     public string getIntraxId(){
        appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c 
                            FROM Applicant_Info__c 
                            WHERE CreatedBy__c =: UserInfo.getUserId() order by CreatedDate desc];
        
        if(appInfoList.Size() > 0){
            return appInfoList[0].Account__r.Intrax_Id__c;
        }else return null;
    }
    static testMethod void testSave() {         
        
        PageReference p=Page.AppEngine_Home; 
        Test.setCurrentPage(p);   
        ApexPages.currentPage().getParameters().put('USER-AGENT', 'Mobi');
        ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
        ApexPages.currentPage().getParameters().put('uIn', 'APCHF'); 
        
        // Modify the test to query for a portal user that exists in your org
        List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='CustomerSuccess'];

        if (existingPortalUsers.isEmpty()) {
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
            System.currentPageReference().getHeaders().put('USER-AGENT','rv:12.0');
            MyProfilePageController controller = new MyProfilePageController();
            System.assertEquals(currentUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            System.assert(controller.isEdit == false, 'isEdit should default to false');
            controller.edit();
            System.assert(controller.isEdit == true);
            controller.cancel();
            System.assert(controller.isEdit == false);
            
            Contact c = new Contact();
            c.LastName = 'TestContact';
            insert c;
            
            setContactFields(c, currentUser);
            controller.save();
            system.debug('*************Page.ChangePassword.getUrl()********************'+Page.ChangePassword.getUrl());
            system.debug('*************controller.changePassword().getUrl()********************'+controller.changePassword().getUrl());
            System.assert(Page.ChangePassword.getUrl().contains('changepassword'));
             System.assert(controller.changePassword().getUrl().contains('changepassword'));
         
        } else {
            User existingPortalUser = existingPortalUsers[0];
            String randFax = Math.rint(Math.random() * 1000) + '5551234';
            
            System.runAs(existingPortalUser) {
                MyProfilePageController controller = new MyProfilePageController();
                System.assertEquals(existingPortalUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
                System.assert(controller.isEdit == false, 'isEdit should default to false');
                controller.edit();
                System.assert(controller.isEdit == true);
                
                controller.cancel();
                System.assert(controller.isEdit == false);
                
                controller.getUser().Fax = randFax;
                controller.save();
                System.assert(controller.isEdit == false);
            }
            
            // verify that the user and contact were updated
            existingPortalUser = [Select id, fax, Contact.Fax from User where id =: existingPortalUser.Id];
            System.assert(existingPortalUser.fax == randFax);
            System.assert(existingPortalUser.Contact.fax == randFax);
        }
    }

	public Applicant_Info__c getApplication()
	{
		list<Applicant_Info__c> lstAppInfo = [Select a.Id, a.createdDate, a.application_level__c, a.Application_Stage__c From Applicant_Info__c a 
                    where a.createdBy__c=:UserInfo.getUserId() AND a.Application_Stage__c = 'Working'
                    order by a.createdDate desc];
        if (lstAppInfo != NULL && lstAppInfo.size() > 0)
        {
        	return lstAppInfo[0];
        }
        else
        {
        	return null;
        }
	}
	
	public PageReference backToApp()
	{
		Applicant_Info__c appVal = getApplication();
		PageReference p;
		if(appVal != NULL)
		{
			if(appVal.application_level__c == 'Main' && appVal.application_stage__c == 'Working') 
			{
				p = new PageReference('/apex/igi_pt_app_home?Id='+appVal.Id);
				p.setRedirect(true);
                return p;
			}
            else if(appVal.application_level__c == 'Basic' && appVal.application_Stage__c == 'Working') 
            {
            	p = new PageReference('/apex/igi_pt_app_personal_info?Id='+appVal.Id);
            	p.setRedirect(true);
                return p;
            }
            else return null;
		}
		else return null;
	}

}