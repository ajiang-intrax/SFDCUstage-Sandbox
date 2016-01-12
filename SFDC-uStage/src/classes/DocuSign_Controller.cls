public class DocuSign_Controller 
{
    public string msgDisplay{get;set;}
    public User_Profile__c userProfile{get;set;}
    public double yearlystipend{get;set;}
    public string EmploymentTerm{get;set;}
    public static boolean OfferAccepted = false;
    public DocuSign_Controller()
    {
        msgDisplay = '';
    }
    
    public PageReference MethodAPCCCFinal(){
        String retDsURL = ApexPages.currentPage().getUrl(); 
        If(retDsURL.contains('event'))
        {        
            msgDisplay = '';
            string MatID = System.currentPageReference().getParameters().get('ObjId');
            string eventstr = System.currentPageReference().getParameters().get('event');
            //string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
            string UserType= System.currentPageReference().getParameters().get('uTypeStr');
            
            if (eventstr  == 'SignComplete')
            {
              try
              {             
                //Docusign_helper.updAppPT(AIDstr);                 
                if(UserType == 'Participant' && MatID!=null){
                    List<Match__c> matchList = [SELECT Id,offer_status__c,offer_accepted_date__c,request_Expiration__c,
                                                       arrival_date__c,start_date__c,end_date__c,match_date__c,
                                                       Engagement__r.In_Country__c,Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,
                                                       Engagement__c,match_type__c 
                                                FROM Match__c WHERE Id=:MatID LIMIT 1];
                    if(matchList!=null && matchList.size()>0){
                        matchList[0].offer_status__c = 'Accepted';
                        matchList[0].offer_accepted_date__c = System.Now();
                        
                        //If the PT is from overseas, then match period is 365 days. This is applicable for original matches and re-matches.
                        if(matchList[0].Engagement__r.In_Country__c == 'No')
                        {
                            matchList[0].start_date__c = matchList[0].Arrival_Date__c;
                            matchList[0].End_date__c = matchList[0].Arrival_Date__c + 365;
                        }
                        else //If the PT is incountry then start date is arrival date and end date is engagemnt end data (aka visa end date)
                        {
                            matchList[0].start_date__c = matchList[0].Arrival_Date__c;
                            matchList[0].End_date__c = matchList[0].Engagement__r.Engagement_end__c;
                        }
                        
                        //This is just a temporary fix. we need to change it later.
                        matchList[0].match_date__c = System.Today();
                        
                        //B-02954
                        if (matchList[0].Engagement__r.In_Country__c == 'No') {  
                            APC_Program_Settings__c ps = [Select OSAP_Match_Finalization_Hours__c From APC_Program_Settings__c];            
                            matchList[0].request_Expiration__c = DateTime.now().addHours(Integer.valueOf(ps.OSAP_Match_Finalization_Hours__c));
                        }else{
                            APC_Program_Settings__c ps = [Select ICAP_Match_Finalization_Hours__c From APC_Program_Settings__c];
                            matchList[0].request_Expiration__c = DateTime.now().addHours(Integer.valueOf(ps.ICAP_Match_Finalization_Hours__c));
                        }
                        
                        update matchList[0];
                        
                        //Now update the engagement start date and end date if this is an overseas aupair
                        if(matchlist[0].Engagement__r.In_Country__c == 'No')
                        {
                            List<Engagement__c> engList = [SELECT Id,In_Country__c,Engagement_Start__c,Engagement_end__c
                                                           FROM Engagement__c WHERE Id=:matchlist[0].Engagement__c LIMIT 1];
                            if(engList!=null && engList.size()>0)
                            {
                                engList[0].Engagement_Start__c = matchlist[0].start_date__c;
                                engList[0].Engagement_end__c = matchlist[0].End_date__c+1;
                            }
                            update engList[0];
                        }
                    }
                }
                
                msgDisplay = 'Signed';
              }
              catch (Exception ex)
              {
                  System.debug('An exception occurred: ' + ex.getMessage());
                  msgDisplay = 'We are currently experiencing technical difficulties. Please try again later.';
              }
              
            }
            else if (eventstr  == 'ViewComplete')
            {
                 msgDisplay = 'Viewed';
            }
            else if (eventstr  == 'Cancel')
            {
                 msgDisplay = 'Cancelled';
            }
            else if (eventstr  == 'Decline')
            {
                 msgDisplay = 'Declined';
            }
            else
            {
                msgDisplay = 'Exception';
            }
            PageReference P;
            
            if(UserType == 'Participant'){
                if (msgDisplay == 'Signed' || msgDisplay == 'Viewed')
                {
                     P = new PageReference('/apex/apc_ap_home');
                }
                else
                {
                    P = new PageReference('/apex/apc_ap_match_request?Id='+MatID+'&msgDisplay='+msgDisplay);
                }
            }
            else{
                if (msgDisplay == 'Signed' || msgDisplay == 'Viewed')
                {
                     P = new PageReference('/apex/apc_hf_match_payment_addons');
                }
                else
                {
                    P = new PageReference('/apex/apc_hf_match_agreement?mid='+MatID+'&msgDisplay='+msgDisplay);
                }
            }
            P.setRedirect(true);
            return P; 
        } 
        else return null;
    }
    
    public PageReference MethodAPCTCFinal()
    {
        
        String retDsURL = ApexPages.currentPage().getUrl(); 
        If(retDsURL.contains('event'))
        {
        
            msgDisplay = '';
            string AIDstr = System.currentPageReference().getParameters().get('ObjId');
            string eventstr = System.currentPageReference().getParameters().get('event');
            string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
            
            if (eventstr  == 'SignComplete')
            {
              try
              {
                
                //Docusign_helper.updAppPT(AIDstr); 
                Applicant_Info__c AInfo = [SELECT ID, Terms_Accepted_Date__c,Terms_Accepted__c,PageStatus_Complete__c FROM Applicant_Info__c WHERE ID =: AIDstr];
                AInfo.Terms_Accepted_Date__c = date.today();
                AInfo.Terms_Accepted__c= True;
                AInfo.Application_Stage__c = 'Submitted';
                
                if(!(AInfo.PageStatus_Complete__c.contains('040')) )
                {
                    if(AInfo.PageStatus_Complete__c != null && AInfo.PageStatus_Complete__c != '')
                    {
                        AInfo.PageStatus_Complete__c = AInfo.PageStatus_Complete__c + ';040'; 
                    }
                    else
                    {
                        AInfo.PageStatus_Complete__c = '040'; 
                    }
                }
                update AInfo;
                
                msgDisplay = 'Signed';
              }
              catch (Exception ex)
              {
                  System.debug('An exception occurred: ' + ex.getMessage());
                  msgDisplay = 'We are currently experiencing technical difficulties. Please try again later.';
              }
              
            }
            else if (eventstr  == 'ViewComplete')
            {
                 msgDisplay = 'Viewed';
            }
            else if (eventstr  == 'Cancel')
            {
                 msgDisplay = 'Cancelled';
            }
            else if (eventstr  == 'Decline')
            {
                 msgDisplay = 'Declined';
            }
            else
            {
                msgDisplay = 'Exception';
            }
            PageReference P;
            if (msgDisplay == 'Signed')
            {
                 P = new PageReference('/apex/apc_ap_basic_completion?vstate=welcomehome&Id='+AIDstr);
            }
            else
            {
                P = new PageReference('/apex/apc_ap_main_agreements?Id='+AIDstr+'&msgDisplay='+msgDisplay);
            }
            P.setRedirect(true);
            return P; 
        } 
        else return null;
        
    }
    
    public void MethodforProfileInfo()
    {
        EmploymentTerm = '';
        
        userProfile = new User_Profile__c();
        system.debug('ID ****' + System.currentPageReference().getParameters().get('id'));
        if (System.currentPageReference().getParameters().get('id') != NULL)
        {
            userProfile = [SELECT   u.Employment_Term_Length__c, u.User__r.ManagerId, u.User__r.Email, u.User__r.Name, u.User__r.FirstName, u.User__r.LastName, u.User__c, u.Monthly_Stipend__c From User_Profile__c u WHERE ID = : System.currentPageReference().getParameters().get('id')];
            system.debug('Name****' + userProfile.User__r.Name);
            if (userProfile.Monthly_Stipend__c != NULL)
            {
                yearlystipend = 12 * userProfile.Monthly_Stipend__c;
            }
            
            if (userProfile.Employment_Term_Length__c != NULL && userProfile.Employment_Term_Length__c == '3 months')
            {
                EmploymentTerm = 'March';
            }
            else if (userProfile.Employment_Term_Length__c != NULL && userProfile.Employment_Term_Length__c == '12 months')
            {
                EmploymentTerm = 'December';
            }
        }
    }
    public void MethodTCFinal()
    {
        string EIDstr = System.currentPageReference().getParameters().get('ObjId');
        string eventstr = System.currentPageReference().getParameters().get('event');
        string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
        
        if (eventstr  == 'SignComplete')
        {
          try
          {
            Engagement__c EInfo = [SELECT ID, Terms_Accepted_Date__c FROM Engagement__c WHERE ID =: EIDstr];
            EInfo.Terms_Accepted_Date__c = date.today();
            update EInfo;
            Notification__c NotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: EIDstr AND Type__c = 'Terms and Conditions'];
            NotInfo.Status__c = 'Confirmed';
            update NotInfo;
            msgDisplay = 'Thank you for signing the document. Please proceed to the Home Page.';
          }
          catch (Exception ex)
          {
              System.debug('An exception occurred: ' + ex.getMessage());
              msgDisplay = 'Sorry, there is some technical problem. Please try again later.';
          }
          
        }
        else if (eventstr  == 'ViewComplete')
        {
             msgDisplay = 'Thank you for viewing the document.';
        }
        else if (eventstr  == 'Cancel')
        {
             msgDisplay = 'Please note that you did not complete the signing of this document.Please sign it as soon as possible.';
        }
        else if (eventstr  == 'Decline')
        {
             msgDisplay = 'Sorry to see that you declined the Agreement.';
        }
        else
        {
            msgDisplay = 'Sorry, there is some technical problem. Please try again later.';
        }
    }
    
    public PageReference MethodIGITCFinal()
    {
        string EIDstr = System.currentPageReference().getParameters().get('ObjId');
        string eventstr = System.currentPageReference().getParameters().get('event');
        string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
        
        if (eventstr  == 'SignComplete')
        {
          try
          {
            Engagement__c EInfo = [SELECT ID, Terms_Accepted_Date__c FROM Engagement__c WHERE ID =: EIDstr];
            EInfo.Terms_Accepted_Date__c = date.today();
            update EInfo;
            Applicant_Info__c AInfo= [SELECT ID, Terms_Accepted_Date__c FROM Applicant_Info__c WHERE Engagement__c =: EIDstr AND Application_Stage__c != 'Cancelled' order by CreatedDate desc limit 1];
            AInfo.Terms_Accepted_Date__c = date.today();
            update AInfo;
            Notification__c NotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: EIDstr AND Type__c = 'Terms and Conditions'];
            NotInfo.Status__c = 'Confirmed';
            update NotInfo;
            msgDisplay = 'Thank you for signing the document. Please proceed to your homepage.';
            PageReference P = Page.igi_home;
            p.setRedirect(true);
            return p; 
          }
          catch (Exception ex)
          {
              System.debug('An exception occurred: ' + ex.getMessage());
              msgDisplay = 'We experienced a technical problem. Please try again later.';
          }
          
        }
        else if (eventstr  == 'ViewComplete')
        {
             msgDisplay = 'Thank you for viewing the document.';
        }
        else if (eventstr  == 'Cancel')
        {
             msgDisplay = 'Please note that you did not complete the signing of this document. Please sign it as soon as possible.';
        }
        else if (eventstr  == 'Decline')
        {
             msgDisplay = 'Our records indicate that you declined the agreement.';
        }
        else
        {
            msgDisplay = 'We experienced a technical problem. Please try again later.';
        }
        return null;
    }
    
    
   public void MethodBGCFinal()
    {
       system.debug('***Inside MethodBGCFinal******');
        string EIDstr = System.currentPageReference().getParameters().get('ObjId');
        string eventstr = System.currentPageReference().getParameters().get('event');
        string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
        system.debug('***Inside MethodBGCFinal EIDstr******'+EIDstr);
          system.debug('***Inside MethodBGCFinal eventstr******'+eventstr);
            system.debug('***Inside MethodBGCFinal userTypeStr******'+userTypeStr);
        if (eventstr  == 'SignComplete')
        {
          try
          {
            Member__c EInfo = [SELECT ID, BGC_Signed_Date__c,Background_Check__c,ESSN__c  FROM Member__c WHERE ID =: EIDstr];
            EInfo.BGC_Signed_Date__c = date.today();
            EInfo.Background_Check__c = ''; 
            update EInfo;
            Notification__c NotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Member__c =: EIDstr AND Type__c = 'Ayusa Member BGC'];
            NotInfo.Status__c = 'Confirmed';
            update NotInfo;
            msgDisplay = 'Thank you for signing the document.';
          }
          catch (Exception ex)
          {
              System.debug('An exception occurred: ' + ex.getMessage());
              msgDisplay = 'Sorry, there is some technical problem. Please try again later.';
          }
          
        }
        else if (eventstr  == 'ViewComplete')
        {
             msgDisplay = 'Thank you for viewing the document.';
        }
        else if (eventstr  == 'Cancel')
        {
             msgDisplay = 'Please note that you did not complete the signing of this document.Please sign it as soon as possible.';
        }
        else if (eventstr  == 'Decline')
        {
             msgDisplay = 'Sorry to see that you declined.';
        }
        else
        {
            msgDisplay = 'Sorry, there is some technical problem. Please try again later.';
        }
    }
   public void MethodJobFinal()
    {
        string MIDstr = System.currentPageReference().getParameters().get('ObjId');
        string eventstr = System.currentPageReference().getParameters().get('event');
        string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
        
        if (eventstr  == 'SignComplete')
        {
            try
           {
                Match__c MInfo = [SELECT ID, Offer_Status__c,Engagement__r.In_Country__c, Engagement__r.Intrax_Program__c,Engagement__c, Engagement__r.Account_Id__c FROM Match__c WHERE ID =: MIDstr];
                if (userTypeStr == 'Participant')
                {
                    MInfo.Offer_Status__c = 'Accepted';
                    if(MInfo.Engagement__r.Intrax_Program__c == 'Work Travel')
                    {
                    OfferAccepted = true;
                    MInfo.Status__c = 'Confirmed' ;
                    WTTriggerHelper.skipEngagementafterupdate=true;
                    }
                    List <Notification__c> JobNotification = [select Id,Engagement__c,Type__c from Notification__c where Match__c = :MIDstr AND Engagement__c = :MInfo.Engagement__c AND Type__c = 'Offer Extended' AND status__c != 'Confirmed'];
                    if (JobNotification.size() > 0)
                    {
                        JobNotification[0].Status__c = 'Confirmed';
                        update JobNotification;
                    }
                    
                }
                else
                {
                    MInfo.Offer_Status__c = 'Offered';
                    Notification_Generator.CreateJobOfferNotification(MInfo.ID);
                    
                }
                system.debug('Trigger exclusion before match udpate***'+TriggerExclusion.isTriggerExclude('Position'));
                update MInfo;
                system.debug('Trigger exclusion after match update***'+TriggerExclusion.isTriggerExclude('Position'));
                msgDisplay = 'Thank you for signing the document.';
                if(TriggerExclusion.isTriggerExclude('Position'))
                {
                 TriggerExclusion.triggerExclude('Position',false);
                 }
           }
           catch (Exception ex)
           {
              System.debug('An exception occurred: ' + ex.getMessage());
              msgDisplay = 'Sorry, there is some technical problem. Please try again later.';
           }
        }
        else if (eventstr  == 'ViewComplete')
        {
             msgDisplay = 'Thank you for viewing the document.';
        }
        else if (eventstr  == 'Cancel')
        {
             msgDisplay = 'Please note that you did not complete the signing of this document.Please sign it as soon as possible.';
        }
        else if (eventstr  == 'Decline')
        {
             msgDisplay = 'Sorry to see that you declined the Agreement.';
        }
        else
        {
             msgDisplay = 'Sorry, there is some technical problem. Please try again later.';
        }
    }
    
    public void MethodAPCADEnv()
    {
        string ProfID = System.currentPageReference().getParameters().get('ObjId');
        string eventstr = System.currentPageReference().getParameters().get('event');
        string userTypeStr = System.currentPageReference().getParameters().get('uTypeStr');
       // PageReference P;
        if (eventstr  == 'SignComplete')
        {
            if (userTypeStr == 'RM')
            {
                list<User_Profile__c> updUprofile = [SELECT ID, RM_Contract_Signed_Date__c, User__c, isWelcomeEmail__c, Contract_Signed_Date__c FROM User_Profile__c WHERE ID =: ProfID];
                system.debug('updUprofile***'+updUprofile);
                if (updUprofile  != NULL && updUprofile.size() > 0)
                {
                    //updUprofile[0].Contract_Signed_Date__c = date.today();
                    //Sent registration-DS ready Email to AR
                    /*if(updUprofile[0].isWelcomeEmail__c == false && updUprofile[0].User__c !=null ){
                        System.debug(System.resetPassword(updUprofile[0].User__c,true));
                        updUprofile[0].isWelcomeEmail__c = true;
                        
                    }
                    update updUprofile;*/
                    updUprofile[0].RM_Contract_Signed_Date__c = date.today();
                    update updUprofile;
                }
                //P = new PageReference('/apex/apc_fs_rm_team');
                
            }
            else if (userTypeStr == 'AD')
            {
                list<User_Profile__c> updUprofile = [SELECT ID, User__c, isWelcomeEmail__c, Contract_Signed_Date__c FROM User_Profile__c WHERE ID =: ProfID];
                system.debug('updUprofile***'+updUprofile);
                if (updUprofile  != NULL && updUprofile.size() > 0)
                {
                    updUprofile[0].Contract_Signed_Date__c = date.today();
                    update updUprofile;
                }
               // P = new PageReference('/apex/apc_fs_ad_profile');
            }
        }
        else if (eventstr  == 'ViewComplete')
        {
             
        }
        else if (eventstr  == 'Cancel')
        {
             
        }
        else if (eventstr  == 'Decline')
        {
             
        }
        else
        {
             
        }
        
        /*if(P != NULL)
        {
        	P.setRedirect(true);
            return P;
        }
        else return null;*/
    }
}