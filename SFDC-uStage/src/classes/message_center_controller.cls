public without sharing class message_center_controller {

    public User activeUser{get;set;}
            
    public String contIdChosen{get;set;}
    
    public message_center_controller(){
        activeUser =[SELECT Id, Name, Email, Type__c, User_Interests__c, ContactId, Intrax_Id__c, Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id =: userInfo.getUserId()];                                      
    }
        
    public List<Notification__c> geturgentNotificationsListPTR(){
        List<Notification__c> NotificationsList = new List<Notification__c>();
        if(activeUser!=null && activeUser.Type__c=='Partner'){
            if(activeUser!=null && activeUser.ContactId!=null && activeUser.Contact.AccountId!=null && activeUser.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                NotificationsList = [SELECT Id, Status__c, Message_Status__c, Subject__c, Email_Sent_At__c, Type__c, User_Type__c, Urgency__c, Intrax_Program__c, Contact__c, ownerId, Body__c, Is_Parent__c, Engagement__c
                                FROM Notification__c  WHERE Id!=NULL
                                AND Account__c=:activeUser.Contact.AccountId                             
                                AND User_Type__c = 'Partner'                                                            
                                AND Intrax_program__c =: activeUser.Contact.PTR_Portal_Intrax_Program_Default__c
                                ORDER BY Email_Sent_At__c DESC, Urgency__c];
                System.debug('urgent size------>'+NotificationsList.size());                                    
            }
        }
        System.debug('urgent size------>'+NotificationsList.size());
        
        if(NotificationsList!=null && NotificationsList.size()>0)
            return NotificationsList;
        else
            return null;
    }
            
    public List<Notification__c> getNotificationsListAPC(){
        List<Notification__c> NotificationsList = new List<Notification__c>();
        
        Set<Id> accIds = new Set<Id>();
        String userType;
        String intraxProgram;
        
        if(activeUser!=null){
            if(activeUser.User_Interests__c!=null && activeUser.User_Interests__c == 'Becoming an au pair'){
                userType = 'Participant';
                accIds = accountIds(userType);
                intraxProgram = 'AuPairCare';
            }
            else if(activeUser.User_Interests__c!=null && activeUser.User_Interests__c == 'Hosting an au pair'){
                userType = 'Host';
                accIds = accountIds('Host Family');
                intraxProgram = 'AuPairCare';
            }
            /*else if(activeUser.Type__c!=null && activeUser.Type__c=='Partner'){
                userType = 'Partner';
                intraxProgram = user.Contact.PTR_Portal_Intrax_Program_Default__c;
            }
            */
            if(accIds!=null && accIds.size()>0 && userType!=null && intraxProgram!=null){       
                NotificationsList = [SELECT Id, Status__c, Message_Status__c, Subject__c, Email_Sent_At__c, Type__c, User_Type__c, Urgency__c, Intrax_Program__c,Account__c, Contact__c, ownerId, Body__c, Dynamic_Content__c, Is_Parent__c, Engagement__c
                                FROM Notification__c  WHERE Id!=NULL
                                AND Account__c IN:accIds                             
                                AND User_Type__c =: userType                                                            
                                AND Intrax_program__c =: intraxProgram
                                ORDER BY Email_Sent_At__c DESC, Urgency__c];
                System.debug('urgent apc pt size------>'+NotificationsList.size());                 
            }
        
        }
        System.debug('urgent apc pt size------>'+NotificationsList.size());
        
        if(NotificationsList!=null && NotificationsList.size()>0)
            return NotificationsList;
        else
            return null;
    }
        
    
    public Set<Id> accountIds(string userType){
        Set<Id> accIds = new Set<Id>();
        List<Applicant_Info__c> appList = new List<Applicant_Info__c>();
        try{
        if(activeUser!=null && userType!=null){
            appList = [SELECT Id,Account__c,Account__r.PersonEmail,Intrax_program__c,Type__c,CreatedById,CreatedBy__c FROM Applicant_Info__c WHERE CreatedBy__c=:activeUser.Id AND Intrax_program__c='AuPairCare' AND Type__c =:userType];            
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
    
    public PageReference markAsRead()
    {   
        try{
         System.debug('Id chosen:-------'+contIdChosen);
         //Notification__c toMark = new Notification__c(id=contIdChosen,Message_Status__c='Read');       
         List<Notification__c> toMark = [SELECT Id,Message_Status__c FROM Notification__c WHERE Id=:contIdChosen LIMIT 1];
         if(toMark!=null && toMark.size()>0){
            toMark[0].Message_Status__c = 'Read';
            update toMark[0];
         }      
         //getUrgentNotifications();
         
        }
        catch(exception e){
            System.debug('Error:-------'+e);
        }
        return null;
        
    }
    
    public PageReference checkLogin(){                          
        if(activeUser!=null && activeUser.Type__c == 'Partner'){
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
                
                system.debug('standard or power user');
                return pageRef;
            }
               
            //Return pagereference
            return pageRef;                         
        }
        
        else if(activeUser!=null && (activeUser.User_Interests__c=='Becoming an au pair' || activeUser.User_Interests__c=='Hosting an au pair')){
            AppEngine_Controller AEC = new AppEngine_Controller();
            PageReference pageRef;
            pageRef = AEC.checkLogin();     
            return pageRef;             
        }
        else 
            return null;
    }
    
}