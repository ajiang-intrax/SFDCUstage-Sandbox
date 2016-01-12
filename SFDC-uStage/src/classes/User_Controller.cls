public with sharing class User_Controller {
    
    public User activeUser {get;set;}
    public list<Applicant_Info__c> appInfoList {get;set;}
    public Accommodation__c accommodation{get;set;}
    public List<Engagement__c> eng {get; set;}
    public Engagement__c currentEng;
    public Map<String,String> checklistMap {get;set;}
    //public Map<String,String> confirmlistMap {get;set;}
    public List<Notification__c> list_notification {get;set;}
    public List<Assessment__c> confirmAss {get;set;}
    public Date c_date {get;set;}
    public Date due_date {get;set;}
    public static boolean firstRun = true;
    public User_Controller(){        
        activeUser = [SELECT Id, Name, FirstName, LastName, Intrax_Id__c, User_Interests__c, Type__c, ContactId, Contact.Intrax_Programs__c,Contact.Account.Intrax_Id__c,Contact.Account.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c,Contact.Account.INT_Agreement_Received__c,Contact.Account.INT_Agreement_Expires__c,Contact.AccountId FROM User WHERE Id =: userInfo.getUserId()];
    }
    
    public User_Controller(ApexPages.StandardController sc){
        activeUser = [SELECT Id, Name, FirstName, LastName, Intrax_Id__c, User_Interests__c, Type__c, ContactId, Contact.Intrax_Programs__c,Contact.Account.Intrax_Id__c,Contact.Account.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c,Contact.AccountId FROM User WHERE Id =: userInfo.getUserId()];
        list_notification = new  List<Notification__c>();
    }
    
    public string inputValue{get;set;}
    
    public pageReference GoSearch(){
        System.debug('----> ENTERED SEARCH');
        Pagereference pageRef = new Pagereference('/apex/pr_person_lookup'+'?search='+inputValue);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public boolean getIsInternshipUser (){
        if(IUtilities.isIncluded(activeUser.Contact.Account.Intrax_Programs__c, 'Internship')){
            return true;
        }else return false;
    }
    //B-03292 
    public boolean getDisplayHCA() {
       boolean expHCA=false;
       if(activeUser.Contact.Account.INT_Agreement_Expires__c!=null && activeUser.Contact.Account.INT_Agreement_Expires__c-30 <= System.today())   
       {
         expHCA=true;   
       }
       
       if(IUtilities.isIncluded(activeUser.Contact.Intrax_Programs__c,'Internship') && (activeuser.Contact.Account.INT_Agreement_Received__c==null || expHCA))
       {
           return true;
       }
      return false;
    }  
    //B-03292
    
    //B-03380
    public boolean getDocusignStatus() {
       boolean dStatus=false;
       List<dsfs__DocuSign_Status__c> lstdStatus= new List<dsfs__DocuSign_Status__c>();
       lstdStatus=[Select id,dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c where dsfs__Company__c =:activeuser.Contact.AccountId];
       for(dsfs__DocuSign_Status__c d:lstdStatus)
       {
        if(d.dsfs__Envelope_Status__c=='Sent' || d.dsfs__Envelope_Status__c == 'Delivered' )
        {
          dStatus=true;
        }
       }
      return dStatus;
    }  
    
    
    //B-03380
    
    //B-03108
    public void setIntraxIdHC(User u){
     
     List<User> activeUser1 = new List<User>();
     activeUser1 = [SELECT Id, Name, FirstName, LastName, Intrax_Id__c, User_Interests__c, Type__c, ContactId, Contact.Intrax_Programs__c,Contact.Account.Intrax_Id__c,Contact.Account.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id =: u.Id limit 1];
     List<User> usrUpdate = new List<User>();
    
     for(User usr:activeUser1)
     {
      usrUpdate.add(usr);
     }
     if(usrUpdate !=null && usrUpdate.size()>0)
     {
     update usrUpdate[0];
     firstRun = false;
     }
    
     }   
    //B-03108
    
    public String getDefaultIP(){
        string defaultIP='';
        if(activeUser != null && activeUser.Intrax_Id__c != null) {       
            if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'AuPairCare')
                    defaultIP = 'AuPairCare';
                else if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Ayusa')
                    defaultIP = 'Ayusa';
                else if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'English and Professional Skills')
                    defaultIP = 'English Academy';
                else if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Internship')
                    defaultIP = 'Global Internships'; 
                else if(activeUser.Contact.PTR_Portal_Intrax_Program_Default__c == 'Work Travel')
                    defaultIP = 'Work Travel';              
            }
        }
        return defaultIP;
    }
    
    public string getEngagementId (){
        system.debug('User Infomation is : ' + UserInfo.getUserId());
        appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            AND application_Stage__c =: 'Accepted'
                            order by CreatedDate desc];
        
        if(appInfoList.Size() > 0){
            return appInfoList[0].Engagement__c;
        }else return null;
    
    }
    
    public string getApplicationId (){
        list <Applicant_Info__c> appInfoLst = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c,Engagement__r.Placement_Status__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            AND application_Stage__c !=: 'Cancelled'
                            order by CreatedDate desc];
        
        if(appInfoLst.Size() > 0){            
            return appInfoLst[0].Id;
        }else return null;
    
    }
    
     public Applicant_Info__c getApplicationInfo (){
        system.debug('Entered getApplicationInfo in User Controller');
        list <Applicant_Info__c> appInfoLst = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c,Engagement__r.Placement_Status__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            AND application_Stage__c !=: 'Cancelled'
                            order by CreatedDate desc];
        
        if(appInfoLst.Size() > 0){  
            system.debug('getApplicationInfo in User Controller');
              system.debug('getApplicationInfo: User Controller' + appInfoLst[0].Engagement__r.Placement_Status__c);                      
            return appInfoLst[0];
        }else return null;
    
    }
    
    public Applicant_Info__c getCurrentApp(){
        
        Applicant_Info__c app = new Applicant_Info__c();
        
        list <Applicant_Info__c> appInfoLst = [SELECT Id, Application_Level__c, Application_Stage__c, Application_Type__c, Position__c, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, Engagement__c
                                FROM Applicant_Info__c WHERE CreatedBy__c =: activeUser.Id AND application_Stage__c !=: 'Cancelled' ORDER BY CreatedDate desc];
        
        if(appInfoLst!=null && appInfoLst.Size() > 0){
            app = appInfoLst[0];
        }
            
        return app;
    }
    
    public Applicant_Info__c getOriginalApp(){
        
        Applicant_Info__c app = new Applicant_Info__c();
        
        list <Applicant_Info__c> appInfoLst = [SELECT Id, OwnerId,Application_Level__c, Application_Stage__c, Application_Type__c, Position__c, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, Engagement__c
                                FROM Applicant_Info__c WHERE CreatedBy__c =: activeUser.Id AND Application_Type__c='Original'];
        
        if(appInfoLst!=null && appInfoLst.Size() > 0){
            app = appInfoLst[0];
            //System.debug('user controller app ownerId---->'+appInfoLst[0].ownerId);
        }
            
        return app;
    }
    
    public boolean getHasConfirmedMatch(){        
        boolean confMatchExists = false;
        
        Applicant_Info__c app = getOriginalApp();
        if(app!=null && app.Id!=null && app.Position__c!=null){
            List<Match__c> matchList = [SELECT Id,Position_Name__c,Status__c,Offer_Status__c FROM Match__c WHERE Position_Name__c=:app.Position__c];
            if(matchList!=null && matchList.size()>0){
                for(Match__c m:matchList){
                    if(m.Status__c=='Confirmed'){
                        confMatchExists=true;//Has at least one confirmed match
                    }
                }
            }
        }
        return confMatchExists;
    }
    
    public boolean getOnProgramEngg()
    {
        string engagementId = getEngagementId();
        system.debug('Engagement ID is : ' + engagementId);
        if(engagementId != null)
        {
            list<Engagement__c> enggLst = [SELECT ID, Status__c FROM Engagement__c WHERE ID =: engagementId AND Status__c =: 'On Program' AND Placement_Status__c =: 'Confirmed'];
            if (enggLst != null && enggLst.size() > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }
    public Engagement__c getEngChecklist(){
        eng=new List<Engagement__c>();
        appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c,Engagement__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            order by CreatedDate desc];
        if((appInfoList!=null) && (appInfoList.Size() > 0)){
               eng = [SELECT Id,Service_Level__c,Status__c FROM Engagement__c
                                                WHERE Id =: appInfoList[0].Engagement__c];
             if((eng !=null) && (eng.size() >0) )
             { 
                System.debug('**Checklist***');
                currentEng=eng[0];
                confirmAss= [Select Id,Status__c, Confirmed_Date__c,CreatedDate,RecordType.Name, Engagement__c from Assessment__c where 
                             (Engagement__c=:eng[0].Id and Status__c='Confirmed' and Confirmed_Date__c !=null) order by CreatedDate desc];
                setConfirmedDate();
                setNextDueDate();
                return eng[0];
              }
        }
        return null;
    }
    
   public void setConfirmedDate()
   {
      boolean flag=false;
       if(confirmAss != null){
           for(Assessment__c c:confirmAss)
           {
             if(flag==false){
               if(c.RecordType.name=='WT PT Monthly Contact' && c.status__c=='Confirmed') 
               {
                  c_date = c.Confirmed_Date__c;
                  flag=true;
                }
             }
           }
       }
       if(flag == false)
       {
           c_date=null;
       }
   }
   public void setNextDueDate()
   {
      boolean dueflag=false;
       if(confirmAss != null){
           for(Assessment__c c:confirmAss)
           {
             if(dueflag==false){
               if((c.RecordType.name=='WT PT Monthly Contact' && c.status__c=='Confirmed')||
                   (c.RecordType.name=='WT PT Check-In' && c.status__c=='Confirmed'))
               {
                  due_date = c.Confirmed_Date__c;
                  due_date=due_date.addDays(25);
                  dueflag=true;
                }
             }
           }
       }
       if(dueflag == false)
       {
           due_date=null;
       }
   }
    
    public Map<String,String> getcheckNotificationlist()
   {
     checklistMap = new Map<String,String>();
     List<Notification__c> list_noti= new List<Notification__c>();
     list_noti=[select status__c,Type__c,CreatedDate, Completed_date__c from Notification__c where Engagement__c =: currentEng.Id];
     if(list_noti != null && list_noti.size() > 0 )
     {
      for(Notification__c n:list_noti)
      {
         checklistmap.put(n.Type__c, n.status__c);
         System.debug('**Notification***'+n.Type__c+' Status'+n.Status__c);
       } 
     }
     return checklistMap;
    }
    public Boolean getRenderTerms(){
     return checklistMap.containsKey('Terms and Conditions');
    }
     public Boolean getRenderOffer(){
     return checklistMap.containsKey('Offer Extended');
    }
     public Boolean getRenderOrient(){
     return checklistMap.containsKey('Orientation');
    }
    public Boolean getRendervisa(){
     return checklistMap.containsKey('Visa Support Letter');
    }
    public Boolean getRendervisaresult(){
     return checklistMap.containsKey('Visa Result');
    }
    public Boolean getRendertravel(){
     return checklistMap.containsKey('Travel Info Needed');
    }
    public Boolean getRendercheckin(){
     return checklistMap.containsKey('Check-In Assessment');
    }
    public void ConfirmNotificationlist()
    {
     List<Notification__c> list_noti= new List<Notification__c>();
     list_noti=[select status__c,Type__c,CreatedDate, Completed_date__c from Notification__c where Engagement__c =: ApexPages.currentPage().getParameters().get('eid')
         and (Status__c='Complete' or Status__c='Confirmed')];
      system.debug('ApexPages.currentPage().getParameters().get(eid):' + ApexPages.currentPage().getParameters().get('eid'));  
      if(list_noti != null && list_noti.size() > 0 && ApexPages.currentPage().getParameters().get('eid')!='' && ApexPages.currentPage().getParameters().get('eid')!=null)
      {
       system.debug('list_noti.size():' + list_noti.size());    
       list_notification=list_noti;        
      }
    }
    public List<Notification__c> getConfirmlist()
    {
        return list_notification;
    }
    
    public Accommodation__c getAccSiteInfo(){
        string engagementId = getEngagementId();
        accommodation = new Accommodation__c();
        if(engagementId != null){
            try{
            accommodation = [SELECT Id, Accommodation_Site__r.City__c, Accommodation_Site__r.State__c, Accommodation_Site__r.Street__c, Accommodation_Site__r.Street_2__c, 
                                                Accommodation_Site__r.Postal_Code__c, Accommodation_Site__r.Country__c, Engagement__c, createdDate 
                                                FROM Accommodation__c 
                                                WHERE Engagement__c =: engagementId
                                                order by createdDate desc limit 1];
            }catch(Exception e){
                system.debug('***** No Address Info to display: ' + e);
                
            }                                       
        }
        return accommodation;
    }
    
    public string getIntraxId(){
        appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c 
                            FROM Applicant_Info__c 
                            WHERE CreatedBy__c =: UserInfo.getUserId() order by CreatedDate desc];
        
        if(appInfoList.Size() > 0){
            return appInfoList[0].Account__r.Intrax_Id__c;
        }else return null;
    }
    
    public boolean getIsWTUser (){
        if(IUtilities.isIncluded(activeUser.Contact.Intrax_Programs__c, 'Work Travel')){
            return true;
        }else return false;
    }
    public boolean getIsIGIUser (){
        if(IUtilities.isIncluded(activeUser.Contact.Intrax_Programs__c, 'Internship')){
            return true;
        }else return false;
    }
        
    
    public boolean getIsAYUSAParticipant (){
        if(IUtilities.isIncluded(activeUser.User_Interests__c, 'Becoming a high school exchange student')){
            return true;
        }else return false;
    }
    
    public boolean getIsWTParticipant (){
        if(IUtilities.isIncluded(activeUser.User_Interests__c, 'Becoming a Work Travel Participant')){
            return true;
        }else return false;
    }
    
   public boolean getIsIGIParticipant (){
        if(IUtilities.isIncluded(activeUser.User_Interests__c, 'Finding an internship')){
            return true;
        }else return false;
    }
    
        
    public string getActiveUserType(){
        string usertype;
        if(IUtilities.isIncluded(activeUser.User_Interests__c, 'Hosting an international student')) usertype = 'Host Family';
        if(IUtilities.isIncluded(activeUser.User_Interests__c, 'Becoming a Work Travel Participant')
            || IUtilities.isIncluded(activeUser.User_Interests__c, 'Becoming a high school exchange student') || IUtilities.isIncluded(activeUser.User_Interests__c, 'Finding an internship')) usertype = 'Participant';
        else if(activeUser.Type__c == 'Partner') usertype = 'Partner';
        else if(activeUser.Type__c == 'Host Company') usertype = 'Host Company';
        else if(activeUser.Type__c == 'Institution') userType = 'Institution';
        if(getOriginalApp()!=null){
            System.debug('originalAPP---->'+getOriginalApp());
            System.debug('originalAPP owner---->'+getOriginalApp().ownerId);
        }    
        return usertype;
    }
    
    
    public boolean getCheckHFUser(){
        if(IUtilities.isIncluded(activeUser.User_Interests__c, 'Hosting an international student')) return true;
        else return false;
    }
    
    //B-03185
    @future
   public static void DisableContact(String email)
    {
     List<User> u = new List<User>();
     u = [Select Id, Name, Email,UserRoleId,IsActive,ContactId from User where Email=:email];
     system.debug('user' +u);
     u[0].IsActive = false;
    // u[0].IsPortalEnabled = false;
     update u[0];
     system.debug('userhere' +u[0]);
    }
    //B-03185
  
       //Checklogin to test authenticated user 
    public PageReference checkLogin(){
        PageReference p;
            system.debug('USERTYPE '+userInfo.getUserType());
        if (userInfo.getUserType() == 'Guest'){
            p = Page.AppEngine_SiteLoginPage;
            p = IUtilities.rewriteUrl(p);
            p.setRedirect(true);
        }
        return p;
        /*
        else if(userInfo.getUserType() == 'Standard' || userInfo.getUserType() == 'PowerPartner'){
            system.debug('');
            return p;
        }
        else{
            System.debug('###### enter in the loop');
             User user = [Select Id, ContactId,Type__c,Intrax_Id__c, User_Interests__c, Contact.AccountId from User where Id =: UserInfo.getUserId()];
             //Getting the value to determine the user interests (and allow or deny creating some types of applications)
             UserInterests = user.User_Interests__c;
            //Check the logged in user type for Partner
            if(user.Type__c=='Partner')
            {
                IsPartner = true;
                
                lstPartnerApp =[Select Id, Name ,  Intrax_Program_Options__c, Intrax_Program__c, Application_Level__c, Application_Stage__c, Intrax_Center__c, Program_Duration__c from Applicant_Info__c where Partner_Intrax_Id__c =: user.Intrax_Id__c];
                Boolean allowedToAccess = false;
                for (Applicant_Info__c partnerApp: lstPartnerApp)
                {
                    if(applicantInfo.Id!=null && partnerApp.Id == applicantInfo.Id && applicantInfo.application_stage__c == 'Working' || applicantInfo.application_stage__c == 'Submitted' )                   
                    {
                         allowedToAccess = true;                                                           
                    }
                }
                if (!allowedToAccess){
                    p = Page.ApplicantsInfo;
                    p.setRedirect(true);
                }
                return p;          
            }
            else{            
      
                String userId = userInfo.getUserId();
                User activeUser = [select Id,email,Phone,street,city,state,postalcode,country from User where Id = :userId];
                // OLD VERSION:if (applicantInfo.Submitted__c && view == NULL){
                
                if(applicantInfo.Application_Stage__c != 'Working' && applicantInfo.Id != null && ApexPages.currentPage().getParameters().get('view')  == NULL){ 
                    p = Page.AppEngine_Home;
                    p.setRedirect(true);
                    return p;
                }
                else if (applicantInfo.Id != null){
                    if (isPartner != true && applicantInfo.createdById != activeUser.Id){               
                        p = Page.AppEngine_Home;
                        p.setRedirect(true);
                        return p;
                    }
                    else
                        return null;
                }
                else 
                return null;
            }       
        }   */    
    }
}