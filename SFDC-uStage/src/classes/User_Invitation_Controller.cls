public without sharing class User_Invitation_Controller {
    public Communication__c comInfo{get;set;}
    private Account partnerInfo;
    private User user;
    //private string ipo_options;
    public string ipo_options {get;set;}
    
    public string DisplayMsg {get;set;}
    
    //Adding multiple invitations - Jose
    public map<Integer, list<String>> emailMap {get;set;}
    public Integer countMap{get;set;}
    public list<String> listWrap;
    public String defaultIP{get;set;}
    public Integer delEmail {get; set;}
    public Boolean invalidPartenerId {get; set;}
    public Boolean invalidApp {get; set;}
   
    
    public User_Invitation_Controller(ApexPages.StandardController controller){
                
        //initi emailList to one position - Jose
        emailMap = new map<Integer, list<String>>();
        countMap = 0;
        listWrap = new List<String> { '', '', ''};
        system.debug('@@@@@listWrap: ' + listWrap);
        
        emailMap.put(countMap, listWrap);
        
        user = [Select Id, Intrax_Id__c, Type__c, Contact.Id, Contact.AccountId, Contact.PTR_Portal_Intrax_Program_Default__c, Contact.Account.Type from User where Id =: UserInfo.getUserId()];
        
        defaultIP = user.Contact.PTR_Portal_Intrax_Program_Default__c;
        
        system.debug('@@@@@user.Intrax_Id__c: ' + user.Intrax_Id__c);
        try{
            if(user.Contact.Account.Type == 'Institution'){
                //University User case
                partnerInfo = [SELECT Id, Name, Intrax_Id__c, Intrax_Programs__c, Intrax_Program_Options__c, type FROM Account WHERE  Id =: user.Contact.AccountId and type = 'Institution' LIMIT 1 ];
            }else{
                // Rest of cases
                partnerInfo = [SELECT Id, Name, Intrax_Id__c, Intrax_Programs__c, Intrax_Program_Options__c, type FROM Account WHERE  Intrax_Id__c =: user.Intrax_Id__c and type = 'Partner' LIMIT 1 ];
            }
            invalidPartenerId = false;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Sorry, you have an invalid Intrax Id.Please contact with your system administrator');
            ApexPages.addMessage(myMsg);
            invalidPartenerId = true;
            system.debug('*****@@@ Exception in User_Invitation_Controller_ Imposible to retrieve a valid partner Account, check Intrax Id.: ' + e);
        }
        comInfo = new Communication__c();
    }
    
    public pageReference CreateCommunication (){
        
        if (ipo_options != NULL && ipo_options != 'Work Travel')
        {
            list<Applicant_Info__c> appCheck = [SELECT Id, Name, Email__c, application_Stage__c, createdDate FROM Applicant_Info__c WHERE Email__c =: comInfo.To_Address__c order by createdDate DESC];
            if(appCheck.size() >0 && appCheck[0].application_stage__c == 'Accepted'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Application already exists for a user with this email address for this Program Year.');
                ApexPages.addMessage(msg);
                return null;
            }
        }
        if(comInfo.Recipient_First_Name__c == null || comInfo.Recipient_Last_Name__c == null|| comInfo.To_Address__c == null || (user.Contact.Account.Type != 'Institution' && ipo_options == null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You are missing one or more of the required fields below.');
            ApexPages.addMessage(msg);
            return null;
        }
        try{ 
           
            String firstName;
            if(comInfo.Recipient_First_Name__c.containsWhiteSpace() ){
                firstName = comInfo.Recipient_First_Name__c.Replace(' ', '%20');
            }else{
                firstName = comInfo.Recipient_First_Name__c;
            }
            
            String lastName;
            if(comInfo.Recipient_Last_Name__c.containsWhiteSpace() ){
                lastName = comInfo.Recipient_Last_Name__c.Replace(' ', '%20');
            }else{
                lastName = comInfo.Recipient_Last_Name__c;
            }
            system.debug('*********** comInfo.Intrax_Program_Options__c -- '+ comInfo.Intrax_Program_Options__c);
            system.debug('*********** ipo_options: ' + ipo_options);
            String ipo;
            
            if(user.Contact.Account.Type != 'Institution'){
                if(ipo_options.containsWhiteSpace() ){
                    ipo = ipo_options.Replace(' ', '%20');
                }else{
                    ipo = ipo_options;
                }
                system.debug('IPO -- ' + ipo);
            }
            //Common parameters
            comInfo.Contact_Name__c = user.Contact.Id;
            comInfo.From_Address__c = 'donotreply@intraxinc.com';
            comInfo.Intrax_Program__c = 'Internship';
            comInfo.Type__c = 'Request';
            comInfo.Type_Code__c = 'NAR';
            comInfo.Status__c = 'Pending';
            comInfo.Method__c = 'Email';
            comInfo.Service_Level__c = 'Premium';
            // We need to dynamically build the URL depending on the environment we are in - Addig the Replace ccheck for University Communities based invitations
            if (partnerInfo.type == 'Institution')
            {
                comInfo.Action_URL__c = 'http://' + Site.getDomain().replace('intrax.', 'intraxinc.') + '/intraxappengine/AppEngine_SiteRegister' + 
                                        '?UniversityId=' + partnerInfo.Intrax_Id__c + 
                                        '&FN=' + firstName + 
                                        '&LN=' + lastName +
                                        '&email=' + comInfo.To_Address__c +                                 
                                        '&slevel=' + comInfo.Service_Level__c + 
                                        '&isInvitation=true';
            }
            else
            {
                comInfo.Action_URL__c = 'http://' + Site.getDomain().replace('intrax.', 'intraxinc.') + '/intraxappengine/AppEngine_SiteRegister' + 
                                        '?partnerId=' + partnerInfo.Intrax_Id__c + 
                                        '&FN=' + firstName + 
                                        '&LN=' + lastName +
                                        '&email=' + comInfo.To_Address__c +                                 
                                        '&slevel=' + comInfo.Service_Level__c + 
                                        '&isInvitation=true';
            }
           if(ipo_options == 'WEST'){
                comInfo.Action_URL__c += '&IPO=' + ipo;
                comInfo.Action_URL__c += '&uIn=IGIG';
           } else if(ipo_options == 'Work Travel'){
                comInfo.Action_URL__c += '&uIn=WTPT';
           } else if(ipo_options == 'Internship' || user.Contact.Account.Type == 'Institution'){
                comInfo.Action_URL__c += '&uIn=IGIG';
           }
           
           system.debug('******* ComInfo BEFORE: ' + comInfo.Action_URL__c);
           String str = comInfo.Action_URL__c.Replace(' ','');
           str =str.trim();
           system.debug('******* ComInfo AFTER: ' + str);
           comInfo.Action_URL__c = str;
       
            insert comInfo;
        }catch(Exception e){
            return null;
        }
        PageReference p;
        if (partnerInfo.type == 'Institution') p = new PageReference('/apex/univ_user_invitation');
        else p = new PageReference('/apex/pr_user_invitation_confirm');
        p.setRedirect(true);
        return p;
    }
    
    public List<SelectOption> getProgramOptions()
    {   
        list<SelectOption> options = new List<SelectOption>();
        /* 1. OPTION 1: only WEST is available: */
        //options.add(new SelectOption('WEST', 'WEST'));
        //options.add(new SelectOption('Work Travel', 'Work Travel'));
        
        /* OPTION 2: ALL parnter´s IPO values are available:*/
        string[] msOptions = partnerInfo.Intrax_Programs__c.split(';',0);
        system.debug('****** msOptions: ' + msOptions);
        
        if (msOptions != null && msOptions.size() > 0)
        {
            for(String op:msOptions){
                if(op == 'Work Travel' || op=='Internship') options.add(new SelectOption(op, op));
            }
        }
        
         return options;
    }
    
    public PageReference checkLogin() {
        PageReference p;
        boolean setreturn;
        if (userInfo.getUserType() == 'Guest'){
            p = Page.AppEngine_SiteLoginPage;
            p.setRedirect(true);
            return p;
        } else
            return null;
    }
     // Method to return from confirmation page to proceed to invite other students for partner users.
    public PageReference return1() {
        PageReference pr = new PageReference('/apex/pr_user_invitation');
        pr.setRedirect(true);
        return pr;
    }
    
    public User_Invitation_Controller()
    {
        user = [Select Id, Intrax_Id__c, Type__c, Contact.Id from User where Id =: UserInfo.getUserId()];
        DisplayMsg  = '';
        comInfo = new Communication__c();
    }
    
    public pageReference CreateLeadCommunication ()
    {
        if(ApexPages.currentPage().getParameters().get('LeadId') != null) 
        {
            Global_Constants__c AppEngURL = Global_Constants__c.getInstance();
            
            Lead qSelLead = [SELECT l.ID, l.Email, FirstName, l.LastName, l.Lead_Type__c, l.Intrax_Programs__c  FROM Lead l WHERE l.ID = :ApexPages.currentPage().getParameters().get('LeadId')];
            list<Applicant_Info__c> appCheck = [SELECT Id, Name, Email__c, application_Stage__c, createdDate FROM Applicant_Info__c WHERE Email__c =: qSelLead.Email AND application_Stage__c != 'Cancelled' order by createdDate DESC];
            
            if(appCheck.size() >0){
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Application already exists for a user with this email address for this Program Year.');
                //ApexPages.addMessage(msg);
                DisplayMsg = 'An Application already exists for a user with this email address.';
                return null;
            }
            
            try{ 
                
                String firstName;
                if(qSelLead.FirstName.containsWhiteSpace() )
                {
                    firstName = qSelLead.FirstName.Replace(' ', '%20');
                    comInfo.Recipient_First_Name__c = qSelLead.FirstName;
                }
                else 
                {
                    firstName = qSelLead.FirstName;
                    comInfo.Recipient_First_Name__c = qSelLead.FirstName;
                }
                
                String lastName;
                
                if(qSelLead.LastName.containsWhiteSpace() )
                {
                    lastName = qSelLead.LastName.Replace(' ', '%20');
                    comInfo.Recipient_Last_Name__c = qSelLead.LastName;
                }
                else 
                {
                    lastName = qSelLead.LastName;
                    comInfo.Recipient_Last_Name__c = qSelLead.LastName;
                }
                
                
                //Common parameters
                comInfo.Contact_Name__c = user.Contact.Id;
                comInfo.From_Address__c = 'donotreply@intraxinc.com';
                comInfo.Intrax_Program__c = 'Internship';
                comInfo.Type__c = 'Request';
                comInfo.Type_Code__c = 'NAR';
                comInfo.Status__c = 'Pending';
                comInfo.Method__c = 'Email';
                comInfo.Service_Level__c = 'Premium';
                comInfo.To_Address__c = qSelLead.Email;
                // We need to dynamically build the URL depending on the environment we are in:
                comInfo.Action_URL__c = AppEngURL.AppEngine_Registration_URL__c + 
                                            //'?partnerId=' + partnerInfo.Intrax_Id__c + 
                                            '?FN=' + firstName + 
                                            '&LN=' + lastName +
                                            '&email=' + comInfo.To_Address__c +                                 
                                            '&slevel=' + comInfo.Service_Level__c ;
                                            //'&uIn=IGIG' + 
                                            //'&isInvitation=true';
               if(qSelLead.Lead_Type__c == 'Participant' && qSelLead.Intrax_Programs__c == 'AuPairCare'){
                    comInfo.Action_URL__c += '&uIn=APCPT';
               } else if(qSelLead.Lead_Type__c == 'Participant' && qSelLead.Intrax_Programs__c == 'Ayusa'){
                    comInfo.Action_URL__c += '&uIn=AYPT';
               } else if(qSelLead.Lead_Type__c == 'Participant' && qSelLead.Intrax_Programs__c == 'Internship'){
                    comInfo.Action_URL__c += '&uIn=IGIG';
               }
               
               system.debug('******* ComInfo BEFORE: ' + comInfo.Action_URL__c);
               String str = comInfo.Action_URL__c.Replace(' ','');
               str =str.trim();
               system.debug('******* ComInfo AFTER: ' + str);
               comInfo.Action_URL__c = str;
                
                if (qSelLead.Lead_Type__c == 'Participant' && (qSelLead.Intrax_Programs__c == 'AuPairCare' || qSelLead.Intrax_Programs__c == 'Ayusa' || qSelLead.Intrax_Programs__c == 'Internship'))
                {
                    insert comInfo;
                    DisplayMsg = 'Invitation sent successfully.';
                }
                else
                {
                    DisplayMsg = 'This is not an appropriate Lead to send the Invitation.';
                }
            }catch(Exception e)
            {
                DisplayMsg = 'Unable to sent Invitation due to some technical issue.';
                return null;
            }
            //PageReference p;
            //p = new PageReference('/'+ApexPages.currentPage().getParameters().get('LeadId'));
           // p = new PageReference('/apex/New_User_From_Lead');
            //p.setRedirect(true);
            //return p;
            return null;
        }
        else return null;
    }
    
    // Contact Communication
    
    // B-03107 b-03106
     public pageReference CreateContactCommunication()
    {
        if(ApexPages.currentPage().getParameters().get('ContactId') != null) 
        {
            Global_Constants__c AppEngURL = Global_Constants__c.getInstance();
               String IntraxId;
            Contact qSelContact = [SELECT c.ID, c.Email, FirstName,Token__c,c.LastName,AccountId,c.Intrax_Programs__c,c.Account.Intrax_Id__c  FROM Contact c WHERE c.ID = :ApexPages.currentPage().getParameters().get('ContactId')];
            
            list<User> user = [SELECT Id, Name,Email FROM User WHERE Email =: qSelContact.Email];
            
            if(qSelContact.FirstName == null || qSelContact.LastName == null || qSelContact.Email == null)
            {
             DisplayMsg = 'Please enter all the required details to send invite : Firstname, LastName, Email.';
             return null;
            }
            
            
            if(user.size() >0){
                DisplayMsg = 'A User already exists for this contact with the same email address.';
                return null;
            }
            
            
            if(qSelContact.AccountId!=null)
            {
             List<Account> acc = [Select id,Name,Status__c,Intrax_Id__c,RecordType.DeveloperName from Account where id =:qSelContact.AccountId limit 1];
             system.debug('@@acc[0].RecordType.DeveloperName' +acc[0].RecordType.DeveloperName +acc[0]);
             if(acc[0].RecordType.DeveloperName != 'Host_Company')
             {
              DisplayMsg = 'This Contact is not attached to a HOST COMPANY account.';
              return null;
             }
            if(acc[0].Status__c == 'Terminated')
             {
              DisplayMsg = 'The Account for this contact is TERMINATED.';
              return null;
             }
             IntraxId = acc[0].Intrax_Id__c;
             
            }
            
            try{ 
                
                String firstName;
               // comInfo.Token__c = GuidGenerator.generateGUID();
                qSelContact.Token__c = GuidGenerator.generateGUID();
                update qSelContact;
                if(qSelContact.FirstName.containsWhiteSpace() )
                {
                    firstName = qSelContact.FirstName.Replace(' ', '%20');
                    comInfo.Recipient_First_Name__c = qSelContact.FirstName;
                }
                else 
                {
                    firstName = qSelContact.FirstName;
                    comInfo.Recipient_First_Name__c = qSelContact.FirstName;
                }
                
                String lastName;
                
                if(qSelContact.LastName.containsWhiteSpace() )
                {
                    lastName = qSelContact.LastName.Replace(' ', '%20');
                    comInfo.Recipient_Last_Name__c = qSelContact.LastName;
                }
                else 
                {
                    lastName = qSelContact.LastName;
                    comInfo.Recipient_Last_Name__c = qSelContact.LastName;
                }
               
                
                //Common parameters
               // comInfo.Contact_Name__c = user.Contact.Id;
                comInfo.From_Address__c = 'donotreply@intraxinc.com';
                comInfo.Intrax_Program__c = 'Internship';
                comInfo.Type__c = 'Request';
                comInfo.Status__c = 'Pending';
                comInfo.Method__c = 'Email';
                comInfo.Service_Level__c = 'Premium';
                comInfo.To_Address__c = qSelContact.Email;
                comInfo.Contact_Id__c = qSelContact.Id;
                // We need to dynamically build the URL depending on the environment we are in:
                comInfo.Action_URL__c = AppEngURL.HC_Portal_URL__c + 
                                            '?FN=' + firstName + 
                                            '&LN=' + lastName +
                                            '&email=' + comInfo.To_Address__c +                                 
                                           // '&slevel=' + comInfo.Service_Level__c +  
                                           '&con=' +qSelContact.Id +
                                            '&isInvitation=true'+  
                                           // '&Token=' + comInfo.Token__c +   
                                            '&Token=' +qSelContact.Token__c +                                   
                                            '&uIn=IGIC'; 
                                            
               system.debug('******* ComInfo BEFORE: ' + comInfo.Action_URL__c);
               String str = comInfo.Action_URL__c.Replace(' ','');
               str =str.trim();
               system.debug('******* ComInfo AFTER: ' + str);
               comInfo.Action_URL__c = str;
                system.debug('@@qSelContact.Intrax_Programs__c' +qSelContact.Intrax_Programs__c);
                if(qSelContact.Intrax_Programs__c =='Internship')
                {
                    insert comInfo;
                    DisplayMsg = 'Invitation sent successfully.';
                    
                }
                else
                {
                    DisplayMsg = 'This is not an appropriate Contact to send the Invitation.';
                }
            }catch(Exception e)
            {
                DisplayMsg = 'Unable to sent Invitation due to some technical issue.';
                return null;
            }
            
            return null;
        }
        else return null;
    }
    
    
      // B-03107 b-03106
    
    
    
    
    public void addEmail(){
        
        countMap++;
        List<String> listWrapAux = new List<String> { '', '', ''};
        emailMap.put(countMap,listWrapAux);
        system.debug('@@@@@emailMap good: ' + emailMap);
    }
    
    public void removeEmail(){
    
        system.debug('@@@@@emailMap: ' + emailMap);
        system.debug('@@@@@delEmail: ' + delEmail);
        emailMap.remove(delEmail);
        system.debug('@@@@@emailMap after: ' + emailMap);
        
        List<List<String>> listWrapAux = emailMap.values();
        Integer sizeMap = emailMap.size();
        system.debug('@@@@@sizeMap: ' + sizeMap);
        system.debug('@@@@@listWrapAux: ' + listWrapAux);
        countMap = 0; 
        
        emailMap = new map<Integer,list<String>>();
        for(Integer i=0; i<sizeMap;i++){
            emailMap.put(i,listWrapAux[i]);
            countMap = i;   
        }
        system.debug('@@@@@emailMap good: ' + emailMap);
        system.debug('@@@@@countMap: ' + countMap);
        
    }
    
    
    public PageReference sendEmail(){
        
        PageReference p;
        p = new PageReference('/apex/pr_user_invitation_confirm');
        p.setRedirect(true);
        String uinParam;
        
        //define uin URL parameter for LINK
        if(defaultIP == 'Work Travel'){
            uinParam = 'WTPT';  
        }else if(defaultIP == 'AuPairCare'){
            uinParam = 'APCPT'; 
        }else if(defaultIP == 'Internship'){
            uinParam = 'IGIG';  
        }
        
        //Get the inivitation email ID from Custom Setting Application Constants
        String EmailId;
        List<Application_Constants__c> appconstants = Application_Constants__c.getall().values();
        Application_Constants__c appconstant = Application_Constants__c.getInstance('AuPair_Partner_Invitation_ID');
        EmailId = appconstant.Value__c;
        
        
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Id =: EmailId];
        String htmlBodyAux = emailTemplate.HtmlValue;
        system.debug('@@@@@emailMap: ' + emailMap);
        system.debug('@@@@@htmlBody: ' + htmlBodyAux);
        try{
            if(emailMap.size()>0){
                for(Integer i:emailMap.keyset()){
                String htmlBody =  htmlBodyAux;
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                list<String> listString = emailMap.get(i);
                htmlBody = htmlBody.replace('{!FirstNameVar}', listString[0]);
                htmlBody = htmlBody.replace('{!LastNameVar}', listString[1]);
                
                String link = 'http://cdev2-intraxinc.cs23.force.com/intraxappengine/AppEngine_SiteRegister?uin='+uinParam+'&FN=' +
                               listString[0]+'&LN='+listString[1]+'&email='+listString[2]+'&partnerId='+user.Intrax_Id__c;
                
                htmlBody = htmlBody.replace('{!LinkVar}', link);
                
                list<String> listEmailString = new list<String>{listString[2]};
                system.debug('@@@@@listEmailString: ' + listEmailString);
                mail.setToAddresses(listEmailString);
                mail.setSubject('Aupair Invitation');
                mail.setSaveAsActivity(false);
                mail.setHtmlBody(htmlBody);
                
                emails.add(mail);
                Messaging.sendEmail(emails); 
                }
            }
        }catch(Exception e){
            system.debug('#####Error sending partner invitation email: ' + e);
        }
        return p;
    }
    
    public pageReference CreateCommunicationMulti (){
        
        system.debug('@@@@@emailMap good: ' + emailMap);
        list<Communication__c> commList = new list<Communication__c>();
        Communication__c commu = new Communication__c();
        String firstName;
        String lastName;
        String emailTo;
        boolean existuser;
        if(emailMap.size()>0){
            for(Integer i:emailMap.keyset()){
                list<String> listString = emailMap.get(i);
                if (defaultIP != NULL && (defaultIP != 'Work Travel' || defaultIP != 'AuPairCare' )){
                  //list<Applicant_Info__c> appCheck = [SELECT Id, Name, Email__c, application_Stage__c, createdDate,Engagement__c,Engagement__r.Status__c FROM Applicant_Info__c WHERE Email__c =: listString[2] order by createdDate DESC];
                  /*list<Applicant_Info__c> appCheck = [SELECT Id, Name, Email__c, application_Stage__c, createdDate,Engagement__c,Engagement__r.Status__c FROM Applicant_Info__c WHERE Id in 
                                                      (Select Applicant_Info__c from Person_Info__c where Email__c =: listString[2]) order by createdDate DESC];*/
                    list<Applicant_Info__c> appCheck = [SELECT Id, Name, Email__c, application_Stage__c, createdDate,Engagement__c,Engagement__r.Status__c,Account__c,Account__r.PersonEmail FROM Applicant_Info__c a WHERE  Account__c!=null and Account__r.PersonEmail = : listString[2] 
                                                        order by createdDate DESC];
                    system.debug('@@@@@ appCheck: ' + appCheck);
                    if(appCheck.size() >0 && appCheck[0].application_stage__c == 'Accepted'&& (appCheck[0].Engagement__c == null || (appCheck[0].Engagement__c != null && 
                       (appCheck[0].Engagement__r.Status__c =='New' ||appCheck[0].Engagement__r.Status__c =='Processing'|| appCheck[0].Engagement__r.Status__c =='Program Ready' || 
                        appCheck[0].Engagement__r.Status__c =='On Program' || appCheck[0].Engagement__r.Status__c =='' || appCheck[0].Engagement__r.Status__c == null ))) ){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Application already exists for a user with this email address for this Program Year.');
                        ApexPages.addMessage(msg);
                        invalidApp = true;
                        return null;
                    }else{
                        invalidApp = false;
                    }
                }
               
            }
            
            try{
            for(Integer i:emailMap.keyset()){
                list<String> listString = emailMap.get(i);
                commu = new Communication__c();
                commu.Contact_Name__c = user.Contact.Id;
                commu.From_Address__c = 'donotreply@intraxinc.com';
                //commu.Intrax_Program__c = 'Internship';
                 if(defaultIP != null){
                    commu.Intrax_Program__c = defaultIP;
                }
                else{
                    commu.Intrax_Program__c = 'Internship';
                }
                
                existuser=false;
                commu.Type__c = 'Request';
                commu.Type_Code__c = 'NAR';
                commu.Status__c = 'Pending';
                commu.Method__c = 'Email';
                commu.Service_Level__c = 'Premium';
                firstName = listString[0];
                lastName = listString[1];
                emailTo = listString[2];
                commu.To_Address__c = emailTo;
                commu.Recipient_First_Name__c = firstName;
                commu.Recipient_Last_Name__c = lastName;
                System.debug('partnerInfo.type ****************'+partnerInfo.type );
                List<User> userCheck = [SELECT Id, FirstName,LastName,username,Email,Profile.Name FROM User WHERE Email =: listString[2] and Profile.Name='OCPM PT'LIMIT 1];
                system.debug('@@@@@ userCheck: ' + userCheck);
                String uname;
                if(userCheck.size() >0 ){
                    uname=userCheck[0].username;
                    existuser=true;    
                }
                if (partnerInfo.type == 'Institution'){
                    commu.Action_URL__c = 'http://' + Site.getDomain().replace('intrax.', 'intraxinc.') + '/intraxappengine/AppEngine_SiteRegister' + 
                                                '?UniversityId=' + partnerInfo.Intrax_Id__c + 
                                                '&FN=' + firstName + 
                                                '&LN=' + lastName +
                                                '&email=' + emailTo +                                 
                                                '&slevel=' + commu.Service_Level__c + 
                                                '&isInvitation=true';
                }else if(existuser==false){
                   if(defaultIP == 'Work Travel' || defaultIP == 'Internship'){
                    commu.Action_URL__c = 'http://' + Site.getDomain().replace('intrax.', 'intraxinc.') + '/intraxappengine/AppEngine_SiteRegister' + 
                                                '?partnerId=' + partnerInfo.Intrax_Id__c + 
                                                '&FN=' + firstName + 
                                                '&LN=' + lastName +
                                                '&email=' + emailTo +                                 
                                                '&slevel=' + commu.Service_Level__c + 
                                                '&isInvitation=true';
                   }
                   else if(defaultIP == 'AuPairCare'){
                    
                    commu.Action_URL__c = 'http://' + Site.getDomain().replace('intraxinc.', 'intrax.').replace('secure.', '') + '/aupaircare/AppEngine_SiteRegister' + 
                                                '?partnerId=' + partnerInfo.Intrax_Id__c + 
                                                '&FN=' + firstName + 
                                                '&LN=' + lastName +
                                                '&email=' + emailTo +                                 
                                                '&slevel=' + commu.Service_Level__c + 
                                                '&isInvitation=true';
                   }
                }
                else if(existuser){
                 if(defaultIP == 'Work Travel' || defaultIP == 'Internship'){
                     commu.Type_Code__c = 'RAR';
                     commu.Action_URL__c = 'http://' + Site.getDomain().replace('intrax.', 'intraxinc.') + '/intraxappengine/AppEngine_SiteLoginPage' + 
                                                '?partnerId=' + partnerInfo.Intrax_Id__c + 
                                                '&email=' + uname +                                 
                                                '&isRepeatApp=true'+ 
                                                '&isInvitation=true';
                 }
                 else if(defaultIP == 'AuPairCare'){
                     commu.Type_Code__c = 'RAR';
                    commu.Action_URL__c = 'http://' + Site.getDomain().replace('intraxinc.', 'intrax.')+ '/aupaircare/AppEngine_SiteLoginPage' + 
                                                '?partnerId=' + partnerInfo.Intrax_Id__c + 
                                                '&email=' + uname +                                 
                                                '&isRepeatApp=true'+ 
                                                '&isInvitation=true';
                 }
                }
                
                if(defaultIP == 'Work Travel'){
                        commu.Action_URL__c += '&uIn=WTPT';
                }else if(defaultIP == 'Internship' || user.Contact.Account.Type == 'Institution'){
                        commu.Action_URL__c += '&uIn=IGIG';
                }else if(defaultIP == 'AuPairCare'){
                        commu.Action_URL__c += '&uIn=APCPT';
                }
                   
                system.debug('@@@@@ commu BEFORE: ' + commu.Action_URL__c);
                String str = commu.Action_URL__c.Replace(' ','');
                str =str.trim();
                system.debug('@@@@@ commu AFTER: ' + str);
                commu.Action_URL__c = str;
               
               commList.add(commu);
                
                
            }//END FOR
            insert commList;
            //END TRY
            }catch(Exception e){
                    system.debug('@@@@@ Exception trying to send the invitation: ' + e);
                    return null; 
            }
                
            }//END IF
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please, enter a value.');
                ApexPages.addMessage(msg);
                return null;
            }
            
            PageReference p;
            if (partnerInfo.type == 'Institution') p = new PageReference('/apex/univ_user_invitation');
            else p = new PageReference('/apex/pr_user_invitation_confirm');
            p.setRedirect(true);
            return p;
    
    }
    
}