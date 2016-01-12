/**
 * An apex page controller that exposes the site login functionality post login redirection
 */
public class LoginRedirectionController {

    public string partialUrl {get;set;}
    public string derivedUrl{get;set;}
// MT 164
    public PageReference nextPage{get;set;}
    public Boolean isTest = false;
    public  List<Engagement__c> lstEng;
    public Site_Message__c SystemMsg{get; set;}
    public List<Site_Message__c> lstsysmsges {get; set;}
    String UsertimeZone;
    public List<Site_Message__c> lstAnn {get; set;}
    public List<Site_Message__c> lstPriorAnn {get;set;}
    public List<Site_Message__c> nonPriorAnn_Top3 {get;set;}
    public List<Site_Message__c> PriorAnn_Top3 {get;set;}
    
    
    //APC variable
    public List<Applicant_Info__c> lstAppInfo;    
    

      public LoginRedirectionController()
       {
            Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry p : ple)
                {
                    If(UserInfo.getTimeZone().getID()==p.getValue())
                    UsertimeZone=p.getlabel();
                
                system.debug('debug::'+p.getlabel()+'****'+p.getValue()+'\n');
                }
           // Checking message availability for user on the basis of User interest and message Display Dates.                      
           lstAnn=MessagingPageController.checkAnnouncement();           
           
           If(lstAnn.size()>0 ){
               for(Site_Message__c s:lstAnn){
                   If(s.Planned_Start_Date_Time__c != null && s.Planned_End_Date_Time__c != null){
                       string ReplaceMsg=MessagingPageController.matchAndReplace('%Planned_Start_Date_Time__c%',s.message__c,string.valueOf(s.Planned_Start_Date_Time__c));
                       string UserTzone=MessagingPageController.matchAndReplace('%TimeZone%',ReplaceMsg,UsertimeZone);
                       s.Message__c=MessagingPageController.matchAndReplace('%Planned_End_Date_Time__c%',UserTzone,string.valueOf(s.Planned_End_Date_Time__c));
                   }
               }             
           }
           
           lstPriorAnn=MessagingPageController.checkPriorityAnnouncement();
           
           If(lstPriorAnn.size()>0 ){
               for(Site_Message__c s:lstPriorAnn){
                   If(s.Planned_Start_Date_Time__c != null && s.Planned_End_Date_Time__c != null){
                       string ReplaceMsg=MessagingPageController.matchAndReplace('%Planned_Start_Date_Time__c%',s.message__c,string.valueOf(s.Planned_Start_Date_Time__c));
                       string UserTzone=MessagingPageController.matchAndReplace('%TimeZone%',ReplaceMsg,UsertimeZone);
                       s.Message__c=MessagingPageController.matchAndReplace('%Planned_End_Date_Time__c%',UserTzone,string.valueOf(s.Planned_End_Date_Time__c));
                   }
               }             
           }
           
           nonPriorAnn_Top3=MessagingPageController.checkAnnouncement_Top3();
           
           If(nonPriorAnn_Top3.size()>0 ){
               for(Site_Message__c s:nonPriorAnn_Top3){
                   If(s.Planned_Start_Date_Time__c != null && s.Planned_End_Date_Time__c != null){
                       string ReplaceMsg=MessagingPageController.matchAndReplace('%Planned_Start_Date_Time__c%',s.message__c,string.valueOf(s.Planned_Start_Date_Time__c));
                       string UserTzone=MessagingPageController.matchAndReplace('%TimeZone%',ReplaceMsg,UsertimeZone);
                       s.Message__c=MessagingPageController.matchAndReplace('%Planned_End_Date_Time__c%',UserTzone,string.valueOf(s.Planned_End_Date_Time__c));
                   }
               }             
           }
           
           PriorAnn_Top3=MessagingPageController.checkPriorAnnouncement_Top3();
           
           If(PriorAnn_Top3.size()>0 ){
               for(Site_Message__c s:PriorAnn_Top3){
                   If(s.Planned_Start_Date_Time__c != null && s.Planned_End_Date_Time__c != null){
                       string ReplaceMsg=MessagingPageController.matchAndReplace('%Planned_Start_Date_Time__c%',s.message__c,string.valueOf(s.Planned_Start_Date_Time__c));
                       string UserTzone=MessagingPageController.matchAndReplace('%TimeZone%',ReplaceMsg,UsertimeZone);
                       s.Message__c=MessagingPageController.matchAndReplace('%Planned_End_Date_Time__c%',UserTzone,string.valueOf(s.Planned_End_Date_Time__c));
                   }
               }             
           }
           
       }
       
       //AA 1/4/2014 MAINT-243 Add new method.
       public PageReference message(){
            //Get User TimeZone Value
            Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry p : ple)
                {
                    If(UserInfo.getTimeZone().getID()==p.getValue())
                    UsertimeZone=p.getlabel();
                
                system.debug('debug::'+p.getlabel()+'****'+p.getValue()+'\n');
                }
           // Checking message availability for user on the basis of User interest and message Display Dates.
           lstsysmsges=MessagingPageController.checkmsg();
           
           If(lstsysmsges.size()>0 ){
               for(Site_Message__c s:lstsysmsges){
                   If(s.Planned_Start_Date_Time__c != null && s.Planned_End_Date_Time__c != null){
                       string ReplaceMsg=MessagingPageController.matchAndReplace('%Planned_Start_Date_Time__c%',s.message__c,string.valueOf(s.Planned_Start_Date_Time__c));
                       string UserTzone=MessagingPageController.matchAndReplace('%TimeZone%',ReplaceMsg,UsertimeZone);
                       s.Message__c=MessagingPageController.matchAndReplace('%Planned_End_Date_Time__c%',UserTzone,string.valueOf(s.Planned_End_Date_Time__c));
                   }
               }
            return null;    
           }
           else{
           return this.redirect();  
           }
       }    
       
       
       public PageReference redirect()
       {
// MT 164

        try
        {
        PageReference nextPage;
        String strnextPage = System.currentPageReference().getParameters().get('nextPage');
        
        String appendSet = '';
        appendSet = IUtilities.rewriteUrl();
        system.debug('***************** appendSet ' + appendSet);
        
        User user = [Select Id, ContactId,Type__c,Intrax_Id__c, Email, UserRole.PortalRole, UserRole.PortalType, UserRole.DeveloperName, 
                        UserRole.RollupDescription, UserRole.ParentRoleId, UserRole.Name,  Contact.AccountId, Contact.Intrax_Programs__c, User_Interests__c, Contact.PTR_Portal_Intrax_Program_Default__c
                        from User where Id =: UserInfo.getUserId()]; 
        system.debug('***************** user ' + user);
        
        if(user!=null){
                 
            system.debug('***************** user check ' + user);
                
            lstAppInfo = [Select a.Id, a.createdDate, a.application_level__c, a.Application_Stage__c, a.Application_Type__c, PageStatus_Started__c, PageStatus_Complete__c From Applicant_Info__c a 
                    where a.createdBy__c=:user.Id
                    order by a.createdDate desc];
                    
            system.debug('***************** lstAppInfo ' + lstAppInfo);    
        }   
           // comment the following for removing Sharing (AYII-136) (Line 33-128)
                
          
            // comment till the above line for removing sharing (AYII-136)
            if(user.Intrax_Id__c!=null && user.Type__c=='Partner')
            { 
                 
               // comment till the above line for removing sharing (AYII-136)
                system.debug('***************** user ' + user);
                // nextPage = new PageReference('/apex/applicantsInfo?isPartner=true');
                // Redirecting to the new Partners Home Page
                String contactIP;
                List<String> contactIPList = new List<String>();
                if(user != null && user.Intrax_Id__c != null) {       
                    if(user.Contact.Intrax_Programs__c != null){
                        contactIP = user.Contact.Intrax_Programs__c;  
                        contactIPList = contactIP.split(';');                            
                    }                   
                }
                //Multiple IP exists and No default IP chosen   
                if(contactIPList.size()>=1 && (user.Contact.PTR_Portal_Intrax_Program_Default__c == NULL || user.Contact.PTR_Portal_Intrax_Program_Default__c == '')){
                    nextPage = new PageReference('/apex/Partner_DefaultIP_Selection');
                }
                else{
                    //nextPage = new PageReference('/apex/Home');
                    nextPage = new PageReference('/apex/pr_home');
                    nextPage.setRedirect(false);
                }
            }
            else if(user.Type__c == 'Institution'){
                    nextPage = new PageReference('/apex/univ_home');
            
            }else{
                
                // In case we are not partners, we need to redirect to different places depending on several options
                if(User.User_Interests__c == 'Studying English'){
                    nextPage = new PageReference('/apex/your_applications?isPartner=false&'+appendSet);
                }
                // If I am a IGI PT
                else if(user.User_Interests__c == 'Finding an internship')
                { 
                    if(lstAppInfo.size() > 0 )
                    { 
                      if(lstAppInfo[0].application_level__c == 'Main' && lstAppInfo[0].application_stage__c != 'Working') nextPage = new PageReference('/apex/igi_home?'+appendSet);
                      else if(lstAppInfo[0].application_level__c == 'Basic' && lstAppInfo[0].application_Stage__c == 'Working') nextPage = new PageReference('/apex/igi_pt_app_personal_info?Id='+lstAppInfo[0].Id);
                      else if(lstAppInfo[0].application_level__c == 'Basic' && lstAppInfo[0].application_Stage__c == 'Submitted') nextPage = new PageReference('/apex/igi_pt_app_completion?Id='+lstAppInfo[0].Id);
                      else nextPage = new PageReference('/apex/igi_pt_app_home?Id='+lstAppInfo[0].Id);
                  }
                    else nextPage = new PageReference('/apex/redirection?'+appendSet);
                  /* OLD CODE IGI 643 + OLD Redirection
                    if(System.currentPageReference().getParameters().get('isInvitation') == 'true')
                    {
                      list<Person_Info__c> personCheck = [SELECT Id, Email__c, Primary_Applicant__c, Applicant_Info__c, Applicant_Info__r.Application_Stage__c 
                                        FROM Person_Info__c 
                                        WHERE Email__c =: user.Email and Primary_Applicant__c =: true];
                    
                    if (personCheck.size() > 0){
                      nextPage = new PageReference('/apex/AppEngine_Home?'+appendSet);
                    }
                    else{
                      nextPage = new PageReference('/apex/Home_isInvitation?'+appendSet+'&nextPage=/apex/Participant_preapp_home&reDirectPage=true&app=IGI&role=Student');
                    }
                    }
                    else if(Site.getCurrentSiteUrl().contains('intraxappengine'))
                        nextPage = new PageReference('/apex/AppEngine_Home?'+appendSet);
                    else               
                        nextPage = new PageReference('/apex/PT_Home?'+appendSet);
                    */
                }else{
                    // 2. If I am a IGI HC and one of my programs is Internships
                    // if(user.Type__c == 'Host Company' && user.Contact.Intrax_Programs__c == 'Internship'){
                    //    nextPage = new PageReference('/apex/SC_Home?'+appendSet);
                    // }else{
                    // 2. If I am a IGI HC
                    
                   //B-03108
                    if(user.User_Interests__c == 'Looking for an intern'){
                       nextPage = new PageReference('/apex/Home?'+appendSet);
                      }
                     if(user.Type__c == 'Host Company' && user.Contact.Intrax_Programs__c == 'Internship'){
                   
                     nextPage = new PageReference('/apex/Home?isPartner=false&'+appendSet);
                     }
                    //B-03108
                    else{
                        
                        if(user.User_Interests__c == 'Hosting an au pair' || user.User_Interests__c == 'Becoming an au pair'){
                            
                            if(lstAppInfo!=null && lstAppInfo.size()>0){
                                
                                if(user.User_Interests__c == 'Becoming an au pair' && lstAppInfo[0].application_level__c=='Main'
                                && lstAppInfo[0].Application_Type__c == 'Original'){
                                    
                                    if (lstAppInfo[0].PageStatus_Started__c != NULL && lstAppInfo[0].PageStatus_Complete__c != NULL &&
                                    lstAppInfo[0].PageStatus_Started__c.contains('31') && lstAppInfo[0].PageStatus_Complete__c.contains('039') && 
                                    !(lstAppInfo[0].PageStatus_Complete__c.contains('040'))){
                                        nextPage = new PageReference('/apex/apc_ap_main_agreements?id=' + lstAppInfo[0].Id +'&'+ appendSet);
                                    
                                    }else if (lstAppInfo[0].PageStatus_Started__c != NULL && lstAppInfo[0].PageStatus_Complete__c != NULL && 
                                    lstAppInfo[0].PageStatus_Started__c.contains('31') && !(lstAppInfo[0].PageStatus_Complete__c.contains('039'))){
                                        nextPage = new PageReference('/apex/apc_ap_main_disc?id=' + lstAppInfo[0].Id +'&'+ appendSet);
                                    }
                                    /*else if (lstAppInfo[0].PageStatus_Complete__c.contains('040') && lstAppInfo[0].Application_Stage__c == 'Working')
                                    {
                                        nextPage = new PageReference('/apex/apc_ap_main_completion?id=' + lstAppInfo[0].Id +'&'+ appendSet);
                                    }*/
                                    
                                    else if (lstAppInfo[0].PageStatus_Started__c != NULL && lstAppInfo[0].PageStatus_Complete__c != NULL && 
                                    lstAppInfo[0].PageStatus_Complete__c.contains('040') && (lstAppInfo[0].Application_Stage__c == 'Accepted')){
                                        nextPage = new PageReference('/apex/apc_ap_home?id=' + lstAppInfo[0].Id +'&'+ appendSet);
                                    
                                    }
                                    else if (lstAppInfo[0].PageStatus_Started__c != NULL && lstAppInfo[0].PageStatus_Complete__c != NULL && 
                                    (lstAppInfo[0].Application_Stage__c == 'Submitted'||lstAppInfo[0].Application_Stage__c == 'In-Review')){
                                        nextPage = new PageReference('/apex/apc_ap_basic_completion?id=' + lstAppInfo[0].Id +'&viewpage=true&'+ appendSet);
                                    
                                    }else{ 
                                        nextPage = new PageReference('/apex/apc_ap_main_home?id=' + lstAppInfo[0].Id +'&'+ appendSet);
                                    }
                                
                                }else if(user.User_Interests__c == 'Becoming an au pair' && lstAppInfo[0].application_level__c=='Basic'
                                && lstAppInfo[0].Application_Type__c == 'Original'){ 
                                    nextPage = new PageReference('/apex/apc_ap_basic_personal_info?id=' + lstAppInfo[0].Id +'&'+ appendSet);
                                
                                }else if(user.User_Interests__c == 'Becoming an au pair' && lstAppInfo[0].application_level__c=='Main'
                                && lstAppInfo[0].Application_Type__c != 'Original'){ 
                                    nextPage = new PageReference('/apex/apc_ap_home' +'?'+ appendSet);
                                
                                }else if(user.User_Interests__c == 'Hosting an au pair' && lstAppInfo[0].application_level__c=='Main'){ 
                                    nextPage = new PageReference('/apex/apc_hf_home' +'?'+ appendSet);
                                
                                }else{
                                    nextPage = new PageReference('/apex/your_applications?'+appendSet);
                                }
                            }else{
                                nextPage = new PageReference('/apex/redirection?'+appendSet);
                            }
                            
                        }else{
                        // 3. If I am a Ayusa PT
                        if(user.User_Interests__c == 'Becoming a high school exchange student' && user.Type__c != 'Partner' ){
                                nextPage = new PageReference('/apex/your_applications?isPartner=false&'+appendSet);
                        }else{
                            // 4. If I am a Ayusa HF
                            if(user.User_Interests__c == 'Hosting an international student' && user.Type__c != 'Partner' ){                             
                                nextPage = new PageReference('/apex/Home?'+appendSet);
                            }else{
                                // 5. WT Participant
                                if(user.User_Interests__c == 'Becoming a Work Travel Participant' && user.Type__c != 'Partner' ){ 
                                    //if(ApexPages.currentPage().getHeaders().get('Referer').contains('/Positions?')) nextPage = new PageReference('/apex/Positions?'+appendSet);  
                                    if (System.currentPageReference().getParameters().get('isInvitation') == 'true')
                                    {
                                        list<Person_Info__c> personCheck = [SELECT Id, Email__c, Primary_Applicant__c, Applicant_Info__c, Applicant_Info__r.Application_Stage__c 
                                        FROM Person_Info__c 
                                        WHERE Email__c =: user.Email and Primary_Applicant__c =: true];
                                        
                                        if (personCheck.size() > 0)
                                        {
                                            nextPage = new PageReference('/apex/Home?'+appendSet);
                                        }
                                        else
                                        {
                                            nextPage = new PageReference('/apex/Home_isInvitation?'+appendSet+'&nextPage=/apex/participant_preapp_home&reDirectPage=true&app=WT&role=Student');
                                        }
                                         system.debug('nextpage***1'+nextPage);
                                    }
                                                          
                                    else
                                    { 
                                    nextPage = new PageReference('/apex/Home?'+appendSet);
                              
                                //    system.debug('page reference***'+System.currentPageReference().getParameters().get('isInvitation')+' Repeat app'+System.currentPageReference().getParameters().get('isRepeat'));  
                                    }
                                    if(System.currentPageReference().getParameters().get('isRepeatApp') == 'true' && System.currentPageReference().getParameters().get('partnerId') != null)
                                     {
                                     //nextPage = new PageReference('/apex/Home_isInvitation?partnerId='+System.currentPageReference().getParameters().get('partnerId')+'&nextPage=/apex/participant_preapp_home&reDirectPage=true&app=WT&role=Student');
                                      nextPage = new PageReference('/apex/your_applications?partnerId='+System.currentPageReference().getParameters().get('partnerId'));
                                     }
                                    system.debug('nextpage***2'+nextPage);
                                       
                                }else{
                                    // 5. Default case. In none of the previous conditions, the user is redirected to my applications page (for now)
                                    system.debug('debug::For Host Company Portal');
                                    nextPage = new PageReference('/apex/Home?isPartner=false&'+appendSet);
                                    
                                }
                            }
                        }
                    }
                }
            }
         }  
            nextPage.setRedirect(false);  
            
            if(Test.isRunningTest()){
            
            user.Contact.OwnerId=null;
            
            }
                         
            return nextPage;              
// MT 164        
       }catch (Exception e) {
             
             ApexPages.addMessages(e); 
                       
             System.debug('An exception occurred: ' + e.getMessage());
                       
             List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             
             //create an email list
             //String[] toAddresses = new String[]{'SFDCNotify@intraxinc.com'};
             String[] toAddresses = new String[]{IUtilities.ULMEmail()}; 
                          
             mail.setToAddresses(toAddresses);
             mail.setSubject('Login Redirection Exception');
             mail.setPlainTextBody('User / '+ user.FirstName + ' ' + user.LastName + ' / with ID: ' + user.Id + ' has generated an exception: ' + e.getMessage());
             emails.add(mail);
             
             if (!isTest){
                 Messaging.sendEmail(emails);
             } 
             return null;
         }
       }
}