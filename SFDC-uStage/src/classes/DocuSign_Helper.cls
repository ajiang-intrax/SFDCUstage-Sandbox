public class DocuSign_Helper 
{
  public string PDFContentStr {get;set;}
  
  //AA APC
     @future 
    public static void updDs(string AppID, string EnvpID) 
    {
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.Applicant_Info__c = AppID;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        dsStatus.Signing_Document_Name__c = 'AuPairCare Program Terms & Conditions';
        insert dsStatus;
    }
    
    public static void updApp(string AppID)
    {
  //update DocuSign Status into AppInfo
    Applicant_Info__c AInfo = [SELECT ID, Terms_Accepted_Date__c,Terms_Accepted__c,PageStatus_Complete__c FROM Applicant_Info__c WHERE ID =: AppID];
    AInfo.Terms_Accepted_Date__c = date.today();
    AInfo.Terms_Accepted__c= True;
    update AInfo;
    }
    
    
  @future 
    public static void updEngg(string EnggID, string EnvpID)
    {
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.Engagement__c = EnggID;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        dsStatus.Signing_Document_Name__c = 'Work Program Terms & Conditions';
        
        /*list<User> lstGuestUser = [Select id, name, u.UserType From User u WHERE u.UserType  = 'Guest' AND Name = 'Intrax Application Engine Site Guest User'];
        if(lstGuestUser != NULL && lstGuestUser.size() > 0)
        {
            dsStatus.OwnerId = lstGuestUser[0].id;
        }*/
        
        insert dsStatus;
    }
    
    
    public static void updhostAcc(string AccId, string EnvpID)
    {
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.dsfs__Company__c = AccId;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        dsStatus.Signing_Document_Name__c = 'IGI Host Company Agreement';
        
        insert dsStatus;
    }
    
    
    
    @future 
    public static void updDSEngg(string EnggID, string EnvpID, string DocName)
    {
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.Engagement__c = EnggID;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        dsStatus.Signing_Document_Name__c = DocName;
        insert dsStatus;
    }
     
    public static void updMember(string MemberID, string EnvpID) 
    {
      system.debug('******inside updMember - MemberID******'+MemberID);
      system.debug('******inside updMember - EnvpID******'+EnvpID);
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.Member__c = MemberID;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        //MT 337
        dsStatus.Signing_Document_Name__c = 'Ayusa Member Background Check';
        insert dsStatus;
        system.debug('******inside updMember - dsStatus******'+dsStatus);
    }
    
    @future 
      public static void updMatch(string MatcID, string EnggID, string EnvpID) 
      {
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.Match__c = MatcID;
        dsStatus.Engagement__c = EnggID;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        dsStatus.Signing_Document_Name__c='Work Travel Job Placement';
        insert dsStatus;
      } 
      
      @future 
      public static void updAPCMatch(string MatcID, string EnggID, string EnvpID) 
      {
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.Match__c = MatcID;
        dsStatus.Engagement__c = EnggID;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        dsStatus.Signing_Document_Name__c='APC Child Care Agreement';
        insert dsStatus;
      }
      
      @future 
    public static void updAPCADEnv(string userProfileID, string EnvpID)
    {
    	Global_Constants__c AgreementYear = Global_Constants__c.getInstance();
    	
        Integer currentYear = System.Today().year();
        dsfs__DocuSign_Status__c dsStatus = new dsfs__DocuSign_Status__c();
        dsStatus.UserProfile__c = userProfileID;
        dsStatus.dsfs__DocuSign_Envelope_ID__c = EnvpID;
        dsStatus.Signing_Document_Name__c = 'AuPairCare Area Director Agreement';
        dsStatus.Signing_Document_Year__c = AgreementYear.APC_RM_and_AD_Agreement_Year__c;
        insert dsStatus;
    }
      
      
   
   public DocuSign_Helper()
   {
      PDFContentStr = '';
   }
   //Manish
   public static PageReference CreateAPCHFCCEnvelope()
    {
        Docusign_Settings__c settings =Docusign_Settings__c.getValues('AuPairCare');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string MatID = System.currentPageReference().getParameters().get('mid');
      string UserType= System.currentPageReference().getParameters().get('uType');
      
      string envelopeId = '';
      string EmailBlurb = '';
      string URLToken = '';
      string urlBase = '';
      string childSpecialNeeds='';
      
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();

      Match__c match = [SELECT ID,  Engagement__r.ID, Engagement__r.Account_Id__c,Position_Name__c, Position_Name__r.Host_Company_Id__c FROM Match__c WHERE ID = :MatID];
      
      Applicant_Info__c app = [SELECT Id,Account__c,Type__c,Children_Special_Needs_Indicated__c,Position__c,Intrax_Program__c FROM Applicant_Info__c WHERE Position__c=:match.Position_Name__c AND Intrax_Program__c='AuPairCare' AND Type__c='Host Family' LIMIT 1];
      if(app!=null && app.Account__c!=null){
          List<Member__c> members = [SELECT Id,Account_Name__c,Special_Needs_Indicated__c FROM Member__c WHERE Account_Name__c=:app.Account__c];
          if(members!=null && members.size()>0){
              for(Member__c m:members){
                  if(m.Special_Needs_Indicated__c=='Yes'){
                      childSpecialNeeds = m.Special_Needs_Indicated__c;
                  }
              }
          }
          //childSpecialNeeds = app.Children_Special_Needs_Indicated__c;
      }
      
      list<Account> partAccountDetails = [SELECT Name, PersonEmail FROM Account WHERE ID = :match.Engagement__r.Account_Id__c];

      //list<User> HFAccountDetails = [Select Id, Name, email from User where Id =: UserInfo.getUserId()];      
      
      list<Account> HFAccountDetails = [SELECT Name, PersonEmail FROM Account WHERE ID = :match.Position_Name__r.Host_Company_Id__c];
      
      
      system.debug('Host Company ID: ' + match.Position_Name__r.Host_Company_Id__c);
      
      if (UserType == 'Participant')
      {
          //urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_ap_home';
          urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_hf_cc_agreement_signed';
          URLToken = urlBase;
      }
      else
      {
          //urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_hf_match_payment_addons';
          urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_hf_cc_agreement_signed';
          URLToken = urlBase; 
      }
      
      if (partAccountDetails.size() > 0 && HFAccountDetails.size() > 0)
      {
          string partusername = partAccountDetails[0].Name;
          string partEmail = partAccountDetails[0].PersonEmail;
          string partSignerName = partAccountDetails[0].Name;
          string partNote = '';
          
          string Emprusername = HFAccountDetails[0].Name;
          string EmprEmail = HFAccountDetails[0].PersonEmail;
          string EmprSignerName = HFAccountDetails[0].Name;
          string emplNote = '';
          
          system.debug('Part email: ' + partEmail);
          system.debug('Empr Email: ' + EmprEmail);
          
          if (partEmail != '' && EmprEmail != '' && partEmail != null && EmprEmail != null)
          {
              Username.add(partusername);
              Username.add(Emprusername);
              
              Email.add(partEmail);
              Email.add(EmprEmail);
              
              SignName.add(partSignerName);
              SignName.add(EmprSignerName);
              
              Note.add(emplNote);   
              Note.add(partNote);
              
              SignAnchorTabStr.add('JobPT-Signature');
              DateAnchorTabStr.add('JobPT-DateSigned');                  
              
              SignAnchorTabStr.add('JobHF-Signature');
              DateAnchorTabStr.add('JobHF-DateSigned');
                            
              List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Match__c = :MatID AND Signing_Document_Name__c='APC Child Care Agreement'];
              
              if (dsStatus.size() > 0){
                envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
              }
              System.debug('envelopeId------>'+envelopeId);
              System.debug('matID------>'+matID);
              System.debug('userType------>'+userType);
              
             if (UserType == 'HostFamily' && envelopeId != '')
              {
                  try
                  {
                      URLToken = DocuSign_Util.getSigningURL('APC', settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Emprusername, EmprEmail, MatID, 'HostFamily' ); 
                  }
                  catch (Exception Ex)
                  {
                      System.debug('An exception occurred: ' + ex.getMessage());
                  }
              }
              else
              {
                  try
                  {
                        if (envelopeId == '')
                        {
                            DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, MatID, 'APC Child Care Agreement','/apex/apc_hf_cc_agreement_pdf?specialChild='+childSpecialNeeds, 'APC Child Care Agreement', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);
                            envelopeId = es.EnvelopeID;
                            URLToken = DocuSign_Util.getSigningURL('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, partusername, partEmail, MatID, 'Participant'); 
                            updAPCMatch(MatID, match.Engagement__r.ID, envelopeId );
                        }
                        else
                        {
                            URLToken = DocuSign_Util.getSigningURL('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, partusername, partEmail, MatID, 'Participant');
                        }
                        
                  }
                  catch (Exception Ex)
                  {
                      System.debug('An exception occurred: ' + ex.getMessage());
                  }
              }
          }
      }
        /*
        try{
            if(UserType == 'Participant' && MatID!=null){
                List<Match__c> matchList = [SELECT Id,offer_status__c FROM Match__c WHERE Id=:MatID LIMIT 1];
                if(matchList!=null && matchList.size()>0){
                    matchList[0].offer_status__c = 'Accepted';
                    update matchList[0];
                }
            }
        }
        catch(exception ex){
            System.debug('An exception occurred updating the match offer status to accepted: ' + ex.getMessage());
        }
        */
      System.debug('URLToken------>'+URLToken);
      PageReference Jobreference=new PageReference(URLToken);
      Jobreference.setRedirect(true);
      return Jobreference;
    }
    
   public static PageReference CreateIWTJobEnvelope()
    {
     // DocusignIWTSettings__c settings = DocusignIWTSettings__c.getInstance();
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string MatID = System.currentPageReference().getParameters().get('id');
      string UserType= System.currentPageReference().getParameters().get('uType');
      
     // string varCrtNewEnv= System.currentPageReference().getParameters().get('CrtNewEnv');
      
      string envelopeId = '';
      string EmailBlurb = '';
      string URLToken = '';
      string urlBase = '';
      
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();

      Match__c match = [SELECT ID,  Engagement__r.ID, Engagement__r.Account_Id__c, Position_Name__r.Host_Company_Id__c FROM Match__c WHERE ID = :MatID];
      
      /*if (varCrtNewEnv != NULL && varCrtNewEnv == '1')
      {
         List<dsfs__DocuSign_Status__c> dstoDelete = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Match__c = :MatID AND Signing_Document_Name__c='Work Travel Job Placement'];
         if(dstoDelete != NULL && dstoDelete.size() > 0)
         {
           delete dstoDelete;
         }
      }*/
      
      list<Account> partAccountDetails = [SELECT Name, PersonEmail FROM Account WHERE ID = :match.Engagement__r.Account_Id__c];

      list<User> HFAccountDetails = [Select Id, Name, email from User where Id =: UserInfo.getUserId()];      
      
      
      system.debug('Host Company ID: ' + match.Position_Name__r.Host_Company_Id__c);
      
      if (UserType == 'Participant')
      {
          urlBase = BaseURLsettings.DocuSign_Participant_URL__c + '/WT_Job_Final_PT';
          URLToken = urlBase;
      }
      else
      {
          urlBase = BaseURLsettings.DocuSign_HC_URL__c + '/WT_Job_Final';
          URLToken = urlBase; 
      }
      
      if (partAccountDetails.size() > 0 && HFAccountDetails.size() > 0)
      {
          string partusername = partAccountDetails[0].Name;
          string partEmail = partAccountDetails[0].PersonEmail;
          string partSignerName = partAccountDetails[0].Name;
          string partNote = '';
          
          string Emprusername = HFAccountDetails[0].Name;
          string EmprEmail = HFAccountDetails[0].email;
          string EmprSignerName = HFAccountDetails[0].Name;
          string emplNote = '';
          
          system.debug('Part email: ' + partEmail);
          system.debug('Empr Email: ' + EmprEmail);
          
          if (partEmail != '' && EmprEmail != '' && partEmail != null && EmprEmail != null)
          {
              Username.add(Emprusername);
              Username.add(partusername);
              
              Email.add(EmprEmail);
              Email.add(partEmail);
             
              SignName.add(EmprSignerName);
              SignName.add(partSignerName);
             
              Note.add(emplNote);   
              Note.add(partNote);
              
              
              SignAnchorTabStr.add('JobEmpr-Signature');
              SignAnchorTabStr.add('JobPart-Signature');
              
              DateAnchorTabStr.add('JobEmpr-DateSigned');
              DateAnchorTabStr.add('JobPart-DateSigned');
              
              List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Match__c = :MatID AND Signing_Document_Name__c='Work Travel Job Placement'];
              
              if (dsStatus.size() > 0){
                envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
              }
              
             if (UserType == 'Participant' && envelopeId != '')
              {
                  try
                  {
                      URLToken = DocuSign_Util.getSigningURL('IWT', settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, partusername, partEmail, MatID, 'Participant' ); 
                  }
                  catch (Exception Ex)
                  {
                      System.debug('An exception occurred: ' + ex.getMessage());
                  }
              }
              else
              {
                  try
                  {
                        if (envelopeId == '')
                        {
                            DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, MatID, 'Work Travel Job Placement','/apex/WT_Job_Content', 'Work Travel Job Placement', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);
                            envelopeId = es.EnvelopeID;
                            URLToken = DocuSign_Util.getSigningURL('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Emprusername, EmprEmail, MatID, 'HostCompany'); 
                            updMatch(MatID, match.Engagement__r.ID, envelopeId );
                        }
                        else
                        {
                            URLToken = DocuSign_Util.getSigningURL('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Emprusername, EmprEmail, MatID, 'HostCompany');
                        }
                        
                  }
                  catch (Exception Ex)
                  {
                      System.debug('An exception occurred: ' + ex.getMessage());
                  }
              }
          }
      }
      
      PageReference Jobreference=new PageReference(URLToken);
      Jobreference.setRedirect(true);
      return Jobreference;
      
    }
    
    public static PageReference CreateIWTTCEnvelope()
    {
     // DocusignIWTSettings__c settings = DocusignIWTSettings__c.getInstance();   
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string envelopeID = '';
      string EngID = System.currentPageReference().getParameters().get('id');
      
      string EmailBlurb = '';
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();
      
      Engagement__c engagement = [SELECT ID,  Account_Id__c  FROM Engagement__c WHERE ID = :EngID];
      
      Account pAccountDetails = [SELECT FirstName,LastName, PersonEmail FROM Account WHERE ID = :engagement.Account_Id__c];
      
      List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Engagement__c = :EngID AND Signing_Document_Name__c =: 'Work Program Terms & Conditions'];
      
      if (dsStatus.size() > 0){
        envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
      }
      
      //string username = pAccountDetails.PersonEmail;
      string Enggname = pAccountDetails.FirstName + ' ' + pAccountDetails.LastName;
      string EnggEmail = pAccountDetails.PersonEmail;
      string EnggSignerName = pAccountDetails.FirstName + ' ' + pAccountDetails.LastName;
      string EnggNote = ' ';
      
      Username.add(Enggname);
      Email.add(EnggEmail);
      SignName.add(EnggSignerName);
      Note.add(EnggNote);
      SignAnchorTabStr.add('TC-Signature');
      DateAnchorTabStr.add('TC-DateSigned');
      
      
      //string urlBase = 'https://cs14.salesforce.com/apex/IWT_TC_Final';
      string urlBase = BaseURLsettings.DocuSign_Participant_URL__c + '/IWT_TC_Final';
      string URLToken = urlBase;
      if (envelopeID != '')
      {
          try
          {
               URLToken = DocuSign_Util.getSigningURL('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Enggname, EnggEmail, EngID, 'Participant');
          }
          catch (Exception ex)
          {
              System.debug('An exception occurred: ' + ex.getMessage());
          }
      }
      else
      {
          try
          {
              DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, EngID, 'Work Program Terms & Conditions','/apex/IWT_Terms_Conditions', 'Work Program Terms & Conditions', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);  
              envelopeId = es.EnvelopeID;
              URLToken = DocuSign_Util.getSigningURL('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Enggname, EnggEmail, EngID, 'Participant');
              updEngg(EngID, envelopeID);
          }
          catch (Exception e)
          {
              System.debug('An exception occurred: ' + e.getMessage());
          }
      }
      
      PageReference reference=new PageReference(URLToken);
      reference.setRedirect(true);
      return reference;
      
    }
    
    public static PageReference CreateIGIHCAEnvelope()
    {
     // DocusignIWTSettings__c settings = DocusignIWTSettings__c.getInstance();   
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('Credentials_IGI');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string envelopeID = '';
      string contactId = System.currentPageReference().getParameters().get('id');
      
      string EmailBlurb = '';
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
     // list<string> ptitle = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();
      list<string> PNameAnchorTabStr = new List<String>();
      list<string> PTitleAnchorTabStr = new List<String>();
      Contact c = [SELECT ID,Name,Email,AccountId,Title FROM Contact WHERE ID = :contactId];
      
      //Account hAcc = [SELECT FirstName,LastName, PersonEmail FROM Account WHERE ID = :c.AccountId];
      
    
     
      string c_name = c.Name;
      string c_Email =c.Email;
      string c_SignerName = c.Name;
      string c_Note = ' ';
      string titlestr=c.title;
      
      Username.add(c_name);
      Email.add(c_Email);
      SignName.add(c_Name);
      Note.add(c_Note);
      //ptitle.add(c_title);
      SignAnchorTabStr.add('HCA-Signature');
      DateAnchorTabStr.add('HCA-DateSigned');
      PNameAnchorTabStr.add('HCA-PrintName');
      PTitleAnchorTabStr.add('HCA-Title');
      //string urlBase = 'https://cs14.salesforce.com/apex/IWT_TC_Final';
      string urlBase = BaseURLsettings.DocuSign_HC_URL__c + '/igi_hc_agreement_thanks';
      string URLToken = urlBase;
   
          try
          {
              DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, c.AccountId, 'IGI Host Company Agreement','/apex/igi_hc_agreement_pdf', 'IGI Host Company Agreement', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,PNameAnchorTabStr,PTitleAnchorTabStr,titlestr,EmailBlurb, false, true);  
              envelopeId = es.EnvelopeID;
              updHostAcc(c.AccountId, envelopeID);
          }
          catch (Exception e)
          {
              System.debug('An exception occurred: ' + e.getMessage());
          }
     // }
      
      PageReference reference=new PageReference(URLToken);
      reference.setRedirect(true);
      return reference;
      
    }
    
      public PageReference CreateAYMemberBGCEnvelope()
    {
     // DocusignIWTSettings__c settings = DocusignIWTSettings__c.getInstance();  
       Docusign_Settings__c ObjDocSetting = Docusign_Settings__c.getValues('Ayusa_BGC_Age_18'); 
       Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string envelopeID = '';
      system.debug('***pagereference*****'+ApexPages.currentPage().getParameters());
      system.debug('*****************ApexPages.currentPage().getParameters().get()*****************'+ApexPages.currentPage().getParameters().get('mid'));
      string MemberID = ApexPages.currentPage().getParameters().get('mid');
      system.debug('*****MemberID******'+MemberID);
      string EmailBlurb = '';
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();
      list<string> SSNAnchorTabStr = new List<String>();
      Member__c member = [Select m.Role__c,m.Account_Name__r.PersonEmail, m.Residency_Status__c, m.Name, m.Last_Name__c, m.Intrax_Program_Option__c, m.Id, m.Gender__c, m.First_Name__c, m.Email__c, m.Date_of_Birth__c, m.Background_Check__c, m.Background_Check_Required__c, m.Background_Check_Msg__c, m.Background_Check_Id__c, m.Background_Check_Consent_Received__c, m.Background_Check_By__c, m.Background_Check_At__c, m.BGC_Notes__c, m.Age__c, m.Account_Name__c From Member__c m where m.ID = :MemberID];
      
      //Account pAccountDetails = [SELECT FirstName,LastName, PersonEmail FROM Account WHERE ID = :engagement.Account_Id__c];
    //MT 337. Condition added in query.    
      List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c,Signing_Document_Name__c from dsfs__DocuSign_Status__c where Member__c = :MemberID AND Signing_Document_Name__c = 'Ayusa Member Background Check'];
      
      if (dsStatus.size() > 0){
        envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
      }
      
      //string username = pAccountDetails.PersonEmail;
      string memberName = member.First_Name__c + ' ' + member.Last_Name__c;
      string memberEmail;
      if(member.Email__c!=null)
      memberEmail = member.Email__c;
      else if(member.Account_Name__c!=null)
      memberEmail = member.Account_Name__r.PersonEmail;
       else
      memberEmail = '';
      string memberSignerName = member.First_Name__c + ' ' + member.Last_Name__c;
      string memberNote = ' ';
      
      Username.add(memberName);
      Email.add(memberEmail);
      SignName.add(memberSignerName);
      Note.add(memberNote);
      SignAnchorTabStr.add(MemberID + '-Signature');
      DateAnchorTabStr.add(MemberID + '-DateSigned');
      SSNAnchorTabStr.add(MemberID + '-BackgroundSSN');
      
      //string urlBase = 'https://cs14.salesforce.com/apex/IWT_TC_Final';
      string urlBase = BaseURLsettings.DocuSign_Participant_URL__c + '/Ayusa_Member_BGC_CallBack';
      string URLToken = urlBase;
      if (envelopeID != '')
      {
          try
          {
               URLToken = DocuSign_Util.getSigningURL('AY',ObjDocSetting.Docusign_Username__c, ObjDocSetting.Docusign_Password__c, ObjDocSetting.Docusign_Integrator_Key__c, ObjDocSetting.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, memberName, memberEmail, MemberID, 'Participant');
          }
          catch (Exception ex)
          {
              System.debug('An exception occurred: ' + ex.getMessage());
          }
      }
      else
      {
          try
          {
              system.debug('*****inside else**');
              DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('AY',ObjDocSetting.Docusign_Username__c, ObjDocSetting.Docusign_Password__c, ObjDocSetting.Docusign_Integrator_Key__c, ObjDocSetting.Docusign_Webservice_Endpoint__c, ObjDocSetting.Docusign_Account_Id__c, ObjDocSetting.Docusign_Brand_Name__c, MemberID, 'Ayusa Member Background Check','/apex/SignatureGenerator_Member', 'Ayusa Member Background Check', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,SSNAnchorTabStr,EmailBlurb, true,false);  
             system.debug('*****es**'+es);
              envelopeId = es.EnvelopeID;
              system.debug('*****envelopeId**'+envelopeId);
              URLToken = DocuSign_Util.getSigningURL('AY',ObjDocSetting.Docusign_Username__c, ObjDocSetting.Docusign_Password__c, ObjDocSetting.Docusign_Integrator_Key__c, ObjDocSetting.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, memberName, memberEmail, MemberID, 'Participant');
              system.debug('*****URLToken******'+URLToken);
              updMember(MemberID, envelopeID);
          }
          catch (Exception e)
          {
              System.debug('An exception occurred: ' + e.getMessage());
          }
      }
      
      PageReference reference=new PageReference(URLToken);
      reference.setRedirect(true);
      return reference;
      
    }
    
    public void OpenEnvelopePDF()
    {
      //DocusignIWTSettings__c settings = DocusignIWTSettings__c.getInstance();   
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string envelopeID = System.currentPageReference().getParameters().get('envelopeID');
      PDFContentStr = DocuSign_Util.createPDF('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, envelopeID);
    }
    
    //AA APC
    //Start
     public static PageReference CreateAPCHFEnvelope()
    {
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('AuPairCare');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string envelopeID = '';
      string AppID = System.currentPageReference().getParameters().get('id');
      
      string EmailBlurb = '';
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();
      
      Applicant_Info__c application=[SELECT ID,RecordType.Name, Account__c, Application_Type__c  FROM Applicant_Info__c WHERE ID = :AppID];
      
      Account pAccountDetails = [SELECT FirstName,LastName, PersonEmail FROM Account WHERE ID = :application.Account__c];
      
      List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Applicant_Info__c = :AppID AND Signing_Document_Name__c='AuPairCare Program Terms & Conditions'];
      
      if (dsStatus.size() > 0){
        envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
      }
      
      string Appname = pAccountDetails.FirstName + ' ' + pAccountDetails.LastName;
      string AppEmail = pAccountDetails.PersonEmail;
      string AppSignerName = pAccountDetails.FirstName + ' ' + pAccountDetails.LastName;
      string AppgNote = ' ';
      
      Username.add(Appname);
      Email.add(AppEmail);
      SignName.add(AppSignerName);
      Note.add(AppgNote);
      SignAnchorTabStr.add('TC-Signature');
      DateAnchorTabStr.add('TC-DateSigned');
      
     string urlBase;
     If(application.RecordType.Name=='AuPairCare HF'){
         
         //if(application.Application_Type__c == 'Extension'){
             //urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_hf_home';   
         //}
         //else{
             urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_hf_app_agreements';
         //}
     //urlBase = BaseURLsettings.DocuSign_Participant_URL__c + '/apc_ds_close'; 
      
     }
        else
        {
            If(application.Application_Type__c == 'Original')
            {
                urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_ap_main_agreements_signed';
            }
            else if(application.Application_Type__c == 'Extension' || application.Application_Type__c == 'Renewal')
            {
                urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_ap_main_ext_agreements';
            }
            else
            {
                urlBase = BaseURLsettings.DocuSign_AuPairCare_URL__c + '/apc_ds_close';
            }
        }
      string URLToken = urlBase;
      if (envelopeID != '')
      {
          try
          {
              URLToken = DocuSign_Util.getSigningURL('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Appname, AppEmail, AppID, 'Participant');
              
          }
          catch (Exception ex)
          {
              System.debug('An exception occurred: ' + ex.getMessage());
          }
      }
      else
      {
          try
          {
             system.debug('debug:: All Paremeters::='+ settings.Docusign_Username__c+ '= '+settings.Docusign_Password__c+ '= '+settings.Docusign_Integrator_Key__c+ '= '+settings.Docusign_Webservice_Endpoint__c+ '= '+settings.Docusign_Account_Id__c+ '= '+settings.Docusign_Brand_Name__c+ '= '+AppID+ '= '+'AuPairCare Program Terms & Conditions'+ '= '+'/apex/APCHF_Terms_Conditions'+ '= '+'Work Program Terms & Conditions'+ '= '+Username+ '= '+Email+ '= '+SignName+ '= '+Note+ '= '+SignAnchorTabStr+ '= '+DateAnchorTabStr+ '= '+EmailBlurb);
             If(application.RecordType.Name=='AuPairCare HF'){
             DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, AppID,'AuPairCare Host Family Agreement','/apex/APCHF_Terms_Conditions', 'AuPairCare Program Terms & Conditions', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);
             envelopeId = es.EnvelopeID;  
             }else{ 
              DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, AppID, 'AuPairCare Program Terms & Conditions','/apex/APCPT_Terms_Conditions', 'AuPairCare Program Terms & Conditions', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);
              envelopeId = es.EnvelopeID;  
             }
              URLToken = DocuSign_Util.getSigningURL('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Appname, AppEmail,AppID, 'Participant');
              updDs(AppID, envelopeID);
              
          }
          catch (Exception e)
          {
              System.debug('An exception occurred: ' + e.getMessage());
          }
      }
      
      PageReference reference=new PageReference(URLToken);
      reference.setRedirect(true);
      return reference;
      
    }
    //End
    
    public static PageReference CreateIGITCEnvelope()
    {
      //DocusignIWTSettings__c settings = DocusignIWTSettings__c.getInstance();   
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string envelopeID = '';
      string EngID = System.currentPageReference().getParameters().get('id');
      
      string EmailBlurb = '';
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();
      
      Engagement__c engagement = [SELECT ID,  Account_Id__c  FROM Engagement__c WHERE ID = :EngID];
      
      Account pAccountDetails = [SELECT FirstName,LastName, PersonEmail FROM Account WHERE ID = :engagement.Account_Id__c];
      
      List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Engagement__c = :EngID AND Signing_Document_Name__c =: 'Internship Terms & Conditions'];
      
      if (dsStatus.size() > 0){
        envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
      }
      
      //string username = pAccountDetails.PersonEmail;
      string Enggname = pAccountDetails.FirstName + ' ' + pAccountDetails.LastName;
      string EnggEmail = pAccountDetails.PersonEmail;
      string EnggSignerName = pAccountDetails.FirstName + ' ' + pAccountDetails.LastName;
      string EnggNote = ' ';
      
      Username.add(Enggname);
      Email.add(EnggEmail);
      SignName.add(EnggSignerName);
      Note.add(EnggNote);
      SignAnchorTabStr.add('TC-Signature');
      DateAnchorTabStr.add('TC-DateSigned');
      
      
      string urlBase = BaseURLsettings.DocuSign_Participant_URL__c + '/igi_pt_TC_final';
      string URLToken = urlBase;
      if (envelopeID != '')
      {
          try
          {
               URLToken = DocuSign_Util.getSigningURL('IGI',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Enggname, EnggEmail, EngID, 'Participant');
          }
          catch (Exception ex)
          {
              System.debug('An exception occurred: ' + ex.getMessage());
          }
      }
      else
      {
          try
          {
              DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('IGI',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, EngID, 'Internship Terms & Conditions','/apex/igi_pt_TC_content', 'Internship Terms & Conditions', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);  
              envelopeId = es.EnvelopeID;
              URLToken = DocuSign_Util.getSigningURL('IGI',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, Enggname, EnggEmail, EngID, 'Participant');
              updDSEngg(EngID, envelopeID,'Internship Terms & Conditions');
          }
          catch (Exception e)
          {
              System.debug('An exception occurred: ' + e.getMessage());
          }
      }
      
      PageReference reference=new PageReference(URLToken);
      reference.setRedirect(true);
      return reference;
      
    }
    
    
    public static PageReference CreateWTCandidateJob()
    {
     // DocusignIWTSettings__c settings = DocusignIWTSettings__c.getInstance();
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('Credentials_IWT_IGI');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      string MatID = System.currentPageReference().getParameters().get('id');
      string UserType= System.currentPageReference().getParameters().get('uType');
      
     // string varCrtNewEnv= System.currentPageReference().getParameters().get('CrtNewEnv');
      
      string envelopeId = '';
      string EmailBlurb = '';
      string URLToken = '';
      string urlBase = '';
      
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();
      Engagement__c EngUpdate = new Engagement__c();

      Match__c match = [SELECT ID,  Engagement__r.ID, Engagement__r.Account_Id__c, Position_Name__r.Host_Company_Id__c FROM Match__c WHERE ID = :MatID];
      if(MatID!=null && MatID!= '')
      {
       EngUpdate = [SELECT ID,Initial_Match_Offer_Accepted__c,Initial_Match_Offer_Received__c from Engagement__c where ID =: match.Engagement__c];
        system.debug('ENGUPDATE' +EngUpdate);
       } 
      
      
      /*if (varCrtNewEnv != NULL && varCrtNewEnv == '1')
      {
         List<dsfs__DocuSign_Status__c> dstoDelete = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Match__c = :MatID AND Signing_Document_Name__c='Work Travel Job Placement'];
         if(dstoDelete != NULL && dstoDelete.size() > 0)
         {
           delete dstoDelete;
         }
      }*/
      
      list<Account> partAccountDetails = [SELECT Name, PersonEmail FROM Account WHERE ID = :match.Engagement__r.Account_Id__c];

      //list<User> HFAccountDetails = [Select Id, Name, email from User where Id =: UserInfo.getUserId()];      
      
      
      //system.debug('Host Company ID: ' + match.Position_Name__r.Host_Company_Id__c);
      
     //if (UserType == 'Participant')
      //{
          urlBase = BaseURLsettings.DocuSign_Participant_URL__c + '/WT_Job_Final_PT';
          URLToken = urlBase;
     /* }
      else
      {
          urlBase = BaseURLsettings.DocuSign_HC_URL__c + '/WT_Job_Final';
          URLToken = urlBase; 
      }*/
      
      if (partAccountDetails.size() > 0 )
      {
          string partusername = partAccountDetails[0].Name;
          string partEmail = partAccountDetails[0].PersonEmail;
          string partSignerName = partAccountDetails[0].Name;
          string partNote = '';
          
          /*string Emprusername = HFAccountDetails[0].Name;
          string EmprEmail = HFAccountDetails[0].email;
          string EmprSignerName = HFAccountDetails[0].Name;
          string emplNote = '';*/
          
          system.debug('Part email: ' + partEmail);
          //system.debug('Empr Email: ' + EmprEmail);
          
          if (partEmail != '' && partEmail != null)
          {
              //Username.add(Emprusername);
              Username.add(partusername);
              
              //Email.add(EmprEmail);
              Email.add(partEmail);
             
              //SignName.add(EmprSignerName);
              SignName.add(partSignerName);
             
              //Note.add(emplNote);   
              Note.add(partNote);
              
              
              //SignAnchorTabStr.add('JobEmpr-Signature');
              SignAnchorTabStr.add('JobPart-Signature');
              
              //DateAnchorTabStr.add('JobEmpr-DateSigned');
              DateAnchorTabStr.add('JobPart-DateSigned');
              
              List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where Match__c = :MatID AND Signing_Document_Name__c='Work Travel Job Placement'];
              
              if (dsStatus.size() > 0){
                envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
              }
              
              
              try
                  {
                        if (envelopeId == '')
                        {
                            DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('IWT',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, MatID, 'Work Travel Job Placement','/apex/WT_Part_Job_Content', 'Work Travel Job Placement', Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);
                            envelopeId = es.EnvelopeID;
                            URLToken = DocuSign_Util.getSigningURL('IWT', settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, partusername, partEmail, MatID, 'Participant' ); 
                            updMatch(MatID, match.Engagement__r.ID, envelopeId );
                            if(EngUpdate!=null)
                            {
                             EngUpdate.Initial_Match_Offer_Received__c = date.today();
                             update EngUpdate;//B-03377
                             }
                        }
                        else
                        {
                            URLToken = DocuSign_Util.getSigningURL('IWT', settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, partusername, partEmail, MatID, 'Participant' );
                        }
                        
                  }
             catch (Exception Ex)
                  {
                      System.debug('An exception occurred: ' + ex.getMessage());
                  }
              
          }
      }
      
      PageReference Jobreference=new PageReference(URLToken);
      Jobreference.setRedirect(true);
      return Jobreference;
      
    }
    
    public static PageReference CreateAPCADEnvelope()
    {
      Docusign_Settings__c settings =Docusign_Settings__c.getValues('AuPairCare');
      Global_Constants__c BaseURLsettings = Global_Constants__c.getInstance();
      
      //string RMID = System.currentPageReference().getParameters().get('RMuID');
      //string ADID= System.currentPageReference().getParameters().get('ADuID');
      string userProfileID= System.currentPageReference().getParameters().get('uProfileID');
      string UserType= System.currentPageReference().getParameters().get('uType');
      
      
      string envelopeId = '';
      string EmailBlurb = '';
      string URLToken = '';
      string urlBase = '';
      
      list<string> Username = new List<String>();
      list<string> Email = new List<String>();
      list<string> SignName = new List<String>();
      list<string> Note = new List<String>();
      list<string> SignAnchorTabStr = new List<String>();
      list<string> DateAnchorTabStr = new List<String>();

      
      list<User_Profile__c> ADUserDetails = new list<User_Profile__c>();
      list<User> RMUserDetails = new list<User>();
      
      ADUserDetails = [Select u.User__r.ManagerId, u.User__r.Email, u.User__r.Name, u.User__r.FirstName, u.User__r.LastName, u.User__c From User_Profile__c u WHERE ID = :userProfileID];
      
      system.debug('ADUserDetails **** ' + ADUserDetails);
      
      if(ADUserDetails != NULL && ADUserDetails.size() > 0)
      {
        if (ADUserDetails[0].User__r.ManagerId != NULL)
        {
            RMUserDetails = [Select Id, Name, email, Profile.Name, Contact.AccountId from User where Id =: ADUserDetails[0].User__r.ManagerId];
            
            system.debug('RMUserDetails **** ' + RMUserDetails);
        }
      }
      
         
      if (UserType == 'AD')
      {
          urlBase = BaseURLsettings.APC_RM_and_AD_Portal_URL__c + '/ds_apc_close';
          //urlBase = 'https://cdev-intrax.cs23.force.com/apcfield/ds_apc_close';
          URLToken = urlBase;
      }
      else
      {
          urlBase = BaseURLsettings.APC_RM_and_AD_Portal_URL__c + '/ds_apc_close';
          //urlBase = 'https://cdev-intrax.cs23.force.com/apcfield/ds_apc_close';
          URLToken = urlBase; 
      }
      
      
      if (RMUserDetails.size() > 0 && ADUserDetails.size() > 0)
      {
          string RMNote = '';
          string ADNote = '';
          
          if (RMUserDetails[0].Email != NULL && ADUserDetails[0].User__r.Email != NULL && RMUserDetails[0].Name != null && ADUserDetails[0].User__r.Name != null)
          {
              Username.add(RMUserDetails[0].Name);
              Username.add(ADUserDetails[0].User__r.Name);
              
              Email.add(RMUserDetails[0].Email);
              Email.add(ADUserDetails[0].User__r.Email);
             
              SignName.add(RMUserDetails[0].Name);
              SignName.add(ADUserDetails[0].User__r.Name);
             
              Note.add(RMNote);   
              Note.add(ADNote);
              
              
              SignAnchorTabStr.add('APCRM-Signature');
              SignAnchorTabStr.add('APCAD-Signature');
              
              DateAnchorTabStr.add('APCRM-DateSigned');
              DateAnchorTabStr.add('APCAD-DateSigned');
              
              Integer currentYear = System.Today().year();
              string agrName = 'AuPairCare Area Director Agreement';
              
              List<dsfs__DocuSign_Status__c> dsStatus = [select Id,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where UserProfile__c = :userProfileID AND Signing_Document_Name__c= :agrName AND Signing_Document_Year__c =: BaseURLsettings.APC_RM_and_AD_Agreement_Year__c];
              
              if (dsStatus.size() > 0){
                envelopeId = dsStatus[0].dsfs__DocuSign_Envelope_ID__c;
              }
              
             if (UserType == 'AD' && envelopeId != '')
              {
                  try
                  {
                      URLToken = DocuSign_Util.getSigningURL('APC', settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, ADUserDetails[0].User__r.Name, ADUserDetails[0].User__r.Email, userProfileID, 'AD' ); 
                  }
                  catch (Exception Ex)
                  {
                      System.debug('An exception occurred: ' + ex.getMessage());
                  }
              }
              else
              {
                  try
                  {
                        if (envelopeId == '')
                        {
                            DocuSignAPI.EnvelopeStatus es = DocuSign_Util.CreateDSEnvelope('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, settings.Docusign_Account_Id__c, settings.Docusign_Brand_Name__c, userProfileID, agrName,'/apex/ds_apc_ad_agreement_env', agrName, Username, Email, SignName, Note, SignAnchorTabStr, DateAnchorTabStr,EmailBlurb, true, true);
                            envelopeId = es.EnvelopeID;
                            URLToken = DocuSign_Util.getSigningURL('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, RMUserDetails[0].Name, RMUserDetails[0].Email, userProfileID, 'RM'); 
                            updAPCADEnv(userProfileID, envelopeId );
                        }
                        else
                        {
                            URLToken = DocuSign_Util.getSigningURL('APC',settings.Docusign_Username__c, settings.Docusign_Password__c, settings.Docusign_Integrator_Key__c, settings.Docusign_Webservice_Endpoint__c, urlBase, envelopeId, RMUserDetails[0].Name, RMUserDetails[0].Email, userProfileID, 'RM');
                        }
                        
                  }
                  catch (Exception Ex)
                  {
                      System.debug('An exception occurred: ' + ex.getMessage());
                  }
              }
          }
      }
      
      PageReference PageRef =new PageReference(URLToken);
      PageRef.setRedirect(true);
      return PageRef;
      
    }
}