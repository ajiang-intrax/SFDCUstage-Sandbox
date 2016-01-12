public without sharing class theme_controller 
{
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
    public boolean IsPartner {get;set;}
    public String appendSet {get; set;}
    public User user {get; set;}
    public String uInParameter {get; set;}   
    public list<String> contactIPList {get;set;}       
    public List<Contact> cList{get;set;}
    
    public theme_controller()
    {        
    	shouldRedirect = false; 
        user = [SELECT Id, Name, FirstName, LastName, User_Interests__c, Type__c, Intrax_Id__c, ContactId, Contact.AccountId, Contact.Intrax_Programs__c, Contact.Account.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id =: userInfo.getUserId()];
        activeUser = user;        
        //user = [Select Id, FirstName, LastName, User_Interests__c, ContactId,Type__c,Intrax_Id__c, Contact.AccountId, Contact.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c from User where Id =: UserInfo.getUserId()];
        
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
    
    public theme_controller(ApexPages.StandardController sc)
    {        
    	list_notification = new  List<Notification__c>();
    	shouldRedirect = false; 
        user = [SELECT Id, Name, FirstName, LastName, User_Interests__c, Type__c, Intrax_Id__c, ContactId, Contact.AccountId, Contact.Intrax_Programs__c, Contact.Account.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id =: userInfo.getUserId()];
        activeUser = user;        
        //user = [Select Id, FirstName, LastName, User_Interests__c, ContactId,Type__c,Intrax_Id__c, Contact.AccountId, Contact.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c from User where Id =: UserInfo.getUserId()];
        
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
        list <Applicant_Info__c> appInfoLst = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c,Engagement__r.Placement_Status__c,Position__c,Application_Level__c,Application_Type__c,OwnerId
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
        
        list <Applicant_Info__c> appInfoLst = [SELECT Id, Application_Level__c, Application_Stage__c, Application_Type__c, Position__c, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, Engagement__c,OwnerId
                                FROM Applicant_Info__c WHERE CreatedBy__c =: activeUser.Id AND application_Stage__c !=: 'Cancelled' ORDER BY CreatedDate desc];
        
        if(appInfoLst!=null && appInfoLst.Size() > 0){
            app = appInfoLst[0];
        }
            
        return app;
    }
    
    /*public Applicant_Info__c getOriginalApp(){
        
        Applicant_Info__c app = new Applicant_Info__c();
        
        list <Applicant_Info__c> appInfoLst = [SELECT Id, OwnerId,Application_Level__c, Application_Stage__c, Application_Type__c, Position__c, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, Engagement__c
                                FROM Applicant_Info__c WHERE CreatedBy__c =: activeUser.Id AND Application_Type__c='Original'];
        
        if(appInfoLst!=null && appInfoLst.Size() > 0){
            app = appInfoLst[0];
            //System.debug('user controller app ownerId---->'+appInfoLst[0].ownerId);
        }
            
        return app;
    }*/
    
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
    
    public boolean getHADConfirmedMatch(){        
        boolean confMatchExisted = false;
        
        Applicant_Info__c app = getOriginalApp();
        if(app!=null && app.Id!=null && app.Position__c!=null){
            List<Match__c> matchList = [SELECT Id,Position_Name__c,Status__c,Offer_Status__c FROM Match__c WHERE Position_Name__c=:app.Position__c];
            if(matchList!=null && matchList.size()>0){
                for(Match__c m:matchList){
                    if(m.Status__c=='Confirmed' || m.Status__c=='Ended Early' || m.Status__c=='Completed'){
                        confMatchExisted=true;//Had at least one confirmed match earlier
                    }
                }
            }
        }
        return confMatchExisted;
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
      if(list_noti != null && list_noti.size() > 0 )
      {
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
    
    public boolean getIsAPCUser (){
        if(IUtilities.isIncluded(activeUser.Contact.Intrax_Programs__c, 'AuPairCare')){
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
    
       //Checklogin to test authenticated user 
   /* public PageReference checkLogin(){
        PageReference p;
            system.debug('USERTYPE '+userInfo.getUserType());
        if (userInfo.getUserType() == 'Guest'){
            p = Page.AppEngine_SiteLoginPage;
            p = IUtilities.rewriteUrl(p);
            p.setRedirect(true);
        }
        return p;
          
    }*/
    
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
    
    /*public String getDefaultIP(){
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
    }*/
    
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
    	 system.debug('**********getIsMatchingStage');
        list<Applicant_Info__c> appInfoList = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c, Application_Level__c,Engagement__r.Placement_Status__c
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
    
    /*public Applicant_Info__c getCurrentApp(){
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
    }*/
    
    public Applicant_Info__c getOriginalApp(){
        Applicant_Info__c currentApp;
        List<Applicant_Info__c> currentAppInfoList = [SELECT Id, OwnerId, CreatedBy__c, Account__c, Application_Type__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c, Application_Level__c, Position__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            AND Application_Type__c='Original'];
        if(currentAppInfoList!=null && currentAppInfoList.size()>0){
            currentApp = currentAppInfoList[0];
        }
        if(currentApp!=null && currentApp.Id!=null){
            return currentApp;
        }else return null;
    }
    /* public Applicant_Info__c getApplicationInfo (){
     	system.debug('Entered getApplicationInfo in Template Controller');
        list <Applicant_Info__c> appInfoLst = [SELECT Id, CreatedBy__c, Account__c, createdDate, Account__r.Intrax_Id__c, application_stage__c, Engagement__c,Engagement__r.Placement_Status__c
                            FROM Applicant_Info__c WHERE CreatedBy__c =: UserInfo.getUserId() 
                            AND application_Stage__c !=: 'Cancelled'
                            order by CreatedDate desc];
        
        if(appInfoLst.Size() > 0){
        	system.debug('getApplicationInfo in Template Controller');
        	system.debug('getApplicationInfo: Template Controller' + appInfoLst[0].Engagement__r.Placement_Status__c);            
            return appInfoLst[0];
        }else return null;
    
    }*/
}