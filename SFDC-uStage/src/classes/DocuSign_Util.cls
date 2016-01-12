public class DocuSign_Util 
{
    public static DocuSignAPI.EnvelopeStatus CreateDSEnvelope(string ProgramName, string DocuSignUserName, string DocuSignPwd, string DocuSignIntKey, string DocuSignEndURL, string DocuSignAcctID, string DocuSignBrand, string ObjId, string EnvSubject, string VfPgName, string DocName, list<string> Username, list<string> Email, list<string> SignName, list<string> Note, list<string> SignAnchorTabStr, list<string> DateAnchorTabStr, string EmailBlurb, boolean isInSession, boolean isRouting)
    {
    	DocuSignAPI.EnvelopeStatus es;
    	system.debug('***Inside DSEnvelope******');
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
          system.debug('***after apisend call******');  
        String auth = '<DocuSignCredentials><Username>' + DocuSignUserName +
            + '</Username><Password>' + DocuSignPwd +
            + '</Password><IntegratorKey>' + DocuSignIntKey +
            + '</IntegratorKey></DocuSignCredentials>';
            system.debug('***after apisend call - auth******'+auth);                         
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        dsApiSend.endpoint_x = DocuSignEndURL;
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject = EnvSubject;
        envelope.EmailBlurb = EmailBlurb;
        envelope.AccountId  = DocuSignAcctID;
        envelope.AllowReassign = false;
        envelope.EnableWetSign = false;
             system.debug('***after apisend call - envelope******'+envelope);    
        if(!Test.isRunningTest())
        {
            DocusignAPI.BrandResults br = dsApiSend.GetAccountBrands(DocuSignAcctID);
            for(integer bn = 0; bn< br.BrandResultItems.BrandResultItem.size() ; bn++)
             {
                   DocusignAPI.BrandResultItem brandItem = br.BrandResultItems.BrandResultItem[bn];
                   if(brandItem.BrandName == DocuSignBrand)
                   {  
                        envelope.BrandId = brandItem.BrandId;
                   }
             }
        }
        
       // PageReference sum_doc = 'Page.'+ PgName; 
         system.debug('***after apisend call - envelope pagereference******'+envelope); 
        PageReference sum_doc = new PageReference(VfPgName); 
        sum_doc.getParameters().put('id',ObjId);
        Blob sum_pdfBlob;
        if(!Test.isRunningTest()) {sum_pdfBlob = sum_doc.getContent();}
          system.debug('***after apisend call - envelope sum_doc******'+sum_doc); 
        DocusignAPI.Document sum_document = new DocusignAPI.Document();
        sum_document.ID = 1;
        if(!Test.isRunningTest()) {sum_document.pdfBytes = EncodingUtil.base64Encode(sum_pdfBlob);}
        sum_document.Name = DocName;
        sum_document.FileExtension = 'pdf';
          system.debug('***after apisend call - envelope sum_document******'+sum_document); 
        envelope.Documents = new DocuSignAPI.ArrayOfDocument();
        envelope.Documents.Document = new DocuSignAPI.Document[1];
        envelope.Documents.Document[0] = sum_document; 
        
        envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[Username.size()];
         system.debug('***after apisend call - envelope sum_document envelope******'+envelope); 
        //system.debug('Number of user ' + Username.size());
        for (integer i=0;i<Username.size();i++)
        {
            DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
            if (isInSession == true)
            {
                recipient.CaptiveInfo = new DocuSignAPI.RecipientCaptiveInfo();
                recipient.CaptiveInfo.ClientUserId = Username[i];
            }
            recipient.Type_x = 'Signer';
            //system.debug('RoutingOrder ' + i);
            if (isRouting == true)
            {
                recipient.RoutingOrder = i+1;
            } 
            else
            {
                recipient.RoutingOrder = 1;
            } 
            system.debug('***after apisend call - recipient******'+recipient); 
            system.debug('ID: ' + i);      
            recipient.ID = i+1;
            recipient.UserName = Username[i];     
            recipient.Email = Email[i];
            recipient.SignerName = SignName[i];             
            recipient.Note = Note[i];
            envelope.Recipients.Recipient[i] = recipient;
             system.debug('***after apisend call - recipient envelope******'+recipient+'**********'+envelope); 
        }
        
        List<DocuSignAPI.Tab> theTabs = new List<DocuSignAPI.Tab>();
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        
        for (integer j=0;j<SignAnchorTabStr.size();j++)
         {
            DocuSignAPI.Tab signature = new DocuSignAPI.Tab();
            signature.Type_x = 'SignHere';
            signature.AnchorTabItem = new DocuSignAPI.AnchorTab();
            signature.AnchorTabItem.AnchorTabString = SignAnchorTabStr[j];
            system.debug('AnchorTabString ' + SignAnchorTabStr[j]);
            signature.AnchorTabItem.IgnoreIfNotPresent = true;
            signature.DocumentID = sum_document.ID;
            signature.RecipientID = j+1; 
            theTabs.add(signature); 
            system.debug('*****signature******* ' + signature);
            DocuSignAPI.Tab dateSigned = new DocuSignAPI.Tab();
            dateSigned.Type_x = 'DateSigned';
            dateSigned.AnchorTabItem = new DocuSignAPI.AnchorTab();
            dateSigned.AnchorTabItem.AnchorTabString = DateAnchorTabStr[j];
            system.debug('DateSignedAnchorTabString ' + DateAnchorTabStr[j]);
            dateSigned.AnchorTabItem.IgnoreIfNotPresent = true;                 
            dateSigned.DocumentID = sum_document.ID;
            dateSigned.RecipientID = j+1;         
            theTabs.add(dateSigned);
            
            
         }
        
        envelope.Tabs.Tab = theTabs;   
        system.debug('***after apisend call - recipient envelope theTabs******'+theTabs);
       /* if(!Test.isRunningTest()){
        	 system.debug('***before dsapisend******'+envelope);
            return dsApiSend.CreateAndSendEnvelope(envelope);
           
        }
        else{
            return null;
        }   */
        try {  
	        es  = dsApiSend.CreateAndSendEnvelope(envelope);  
	        System.debug('***es**** - ' + es);  
			//envelopeId = es.EnvelopeID;  

		} catch ( CalloutException e) {  
			System.debug('Exception - ' + e );  
			//envelopeId = 'Exception - ' + e;  
		}
		return  es;      
    }
   
    public static DocuSignAPI.EnvelopeStatus CreateDSEnvelope(string ProgramName, string DocuSignUserName, string DocuSignPwd, string DocuSignIntKey, string DocuSignEndURL, string DocuSignAcctID, string DocuSignBrand, string ObjId, string EnvSubject, string VfPgName, string DocName, list<string> Username, list<string> Email, list<string> SignName, list<string> Note, list<string> SignAnchorTabStr, list<string> DateAnchorTabStr, list<string> SSNAnchorTabStr,string EmailBlurb, boolean isInSession, boolean isRouting)
    {
    	DocuSignAPI.EnvelopeStatus es;
    	system.debug('***Inside DSEnvelope******');
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
          system.debug('***after apisend call******');  
        String auth = '<DocuSignCredentials><Username>' + DocuSignUserName +
            + '</Username><Password>' + DocuSignPwd +
            + '</Password><IntegratorKey>' + DocuSignIntKey +
            + '</IntegratorKey></DocuSignCredentials>';
            system.debug('***after apisend call - auth******'+auth);                         
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        dsApiSend.endpoint_x = DocuSignEndURL;
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject = EnvSubject;
        envelope.EmailBlurb = EmailBlurb;
        envelope.AccountId  = DocuSignAcctID;
        envelope.AllowReassign = false;
        envelope.EnableWetSign = false;
             system.debug('***after apisend call - envelope******'+envelope);    
        if(!Test.isRunningTest())
        {
            DocusignAPI.BrandResults br = dsApiSend.GetAccountBrands(DocuSignAcctID);
            for(integer bn = 0; bn< br.BrandResultItems.BrandResultItem.size() ; bn++)
             {
                   DocusignAPI.BrandResultItem brandItem = br.BrandResultItems.BrandResultItem[bn];
                   if(brandItem.BrandName == DocuSignBrand)
                   {  
                        envelope.BrandId = brandItem.BrandId;
                   }
             }
        }
        
       // PageReference sum_doc = 'Page.'+ PgName; 
         system.debug('***after apisend call - envelope pagereference******'+envelope); 
        PageReference sum_doc = new PageReference(VfPgName); 
        sum_doc.getParameters().put('id',ObjId);
        Blob sum_pdfBlob;
        if(!Test.isRunningTest()) {sum_pdfBlob = sum_doc.getContent();}
          system.debug('***after apisend call - envelope sum_doc******'+sum_doc); 
        DocusignAPI.Document sum_document = new DocusignAPI.Document();
        sum_document.ID = 1;
        if(!Test.isRunningTest()) {sum_document.pdfBytes = EncodingUtil.base64Encode(sum_pdfBlob);}
        sum_document.Name = DocName;
        sum_document.FileExtension = 'pdf';
          system.debug('***after apisend call - envelope sum_document******'+sum_document); 
        envelope.Documents = new DocuSignAPI.ArrayOfDocument();
        envelope.Documents.Document = new DocuSignAPI.Document[1];
        envelope.Documents.Document[0] = sum_document; 
        
        envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[Username.size()];
         system.debug('***after apisend call - envelope sum_document envelope******'+envelope); 
        //system.debug('Number of user ' + Username.size());
        for (integer i=0;i<Username.size();i++)
        {
            DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
            if (isInSession == true)
            {
                recipient.CaptiveInfo = new DocuSignAPI.RecipientCaptiveInfo();
                recipient.CaptiveInfo.ClientUserId = Username[i];
            }
            recipient.Type_x = 'Signer';
            //system.debug('RoutingOrder ' + i);
            if (isRouting == true)
            {
                recipient.RoutingOrder = i+1;
            } 
            else
            {
                recipient.RoutingOrder = 1;
            } 
            system.debug('***after apisend call - recipient******'+recipient); 
            system.debug('ID: ' + i);      
            recipient.ID = i+1;
            recipient.UserName = Username[i];     
            recipient.Email = Email[i];
            recipient.SignerName = SignName[i];             
            recipient.Note = Note[i];
            envelope.Recipients.Recipient[i] = recipient;
             system.debug('***after apisend call - recipient envelope******'+recipient+'**********'+envelope); 
        }
        
        List<DocuSignAPI.Tab> theTabs = new List<DocuSignAPI.Tab>();
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        
        for (integer j=0;j<SignAnchorTabStr.size();j++)
         {
            DocuSignAPI.Tab signature = new DocuSignAPI.Tab();
            signature.Type_x = 'SignHere';
            signature.AnchorTabItem = new DocuSignAPI.AnchorTab();
            signature.AnchorTabItem.AnchorTabString = SignAnchorTabStr[j];
            system.debug('AnchorTabString ' + SignAnchorTabStr[j]);
            signature.AnchorTabItem.IgnoreIfNotPresent = true;
            signature.DocumentID = sum_document.ID;
            signature.RecipientID = j+1; 
            theTabs.add(signature); 
            system.debug('*****signature******* ' + signature);
            DocuSignAPI.Tab dateSigned = new DocuSignAPI.Tab();
            dateSigned.Type_x = 'DateSigned';
            dateSigned.AnchorTabItem = new DocuSignAPI.AnchorTab();
            dateSigned.AnchorTabItem.AnchorTabString = DateAnchorTabStr[j];
            system.debug('DateSignedAnchorTabString ' + DateAnchorTabStr[j]);
            dateSigned.AnchorTabItem.IgnoreIfNotPresent = true;                 
            dateSigned.DocumentID = sum_document.ID;
            dateSigned.RecipientID = j+1; 
             theTabs.add(dateSigned);
            DocuSignAPI.Tab SSN = new DocuSignAPI.Tab();
            SSN.ConcealValueOnDocument = true;
            SSN.CustomTabValidationPattern = '^[0-9]{3}-[0-9]{2}-[0-9]{4}$';
            SSN.CustomTabValidationMessage = 'Please enter SSN as XXX-XX-XXXX';
            SSN.Type_x = 'Custom';
            SSN.TabLabel = 'SSN';
            SSN.CustomTabType = 'SSN';
            SSN.CustomTabWidth = 80;
            SSN.AnchorTabItem = new DocuSignAPI.AnchorTab();
            SSN.AnchorTabItem.AnchorTabString = SSNAnchorTabStr[j];          
            SSN.DocumentID = sum_document.ID;
            SSN.RecipientID = j+1;     
            theTabs.add(SSN);
              DocuSignAPI.Tab RecordId = new DocuSignAPI.Tab();
                RecordId.Type_x = 'Custom';
                RecordId.CustomTabType = 'Text';
                //Dale L 3/5/2014 prototype fix for Ayusa SSN problem 
                //RecordId.TabLabel = 'PersonInfo_SFID';  
                RecordId.TabLabel = 'Member_SFID';
                system.debug('*******DSLabel: ' + RecordId.TabLabel);
                //RecordId.Name = 'PersonInfo_SFID';
                RecordId.Name = 'Member_SFID';
                system.debug('*******DSName: ' + RecordId.Name);
                RecordId.Value = ObjId;      
                RecordId.DocumentID = sum_document.ID;
                RecordId.PageNumber = 1;
                RecordId.RecipientID = j+1;
                RecordId.ConcealValueOnDocument = true;   
            theTabs.add(RecordId);
         }
          
        envelope.Tabs.Tab = theTabs;   
        
        system.debug('***after apisend call - recipient envelope theTabs******'+theTabs);
       if(!Test.isRunningTest()){
        	 system.debug('***before dsapisend******'+envelope);
            return dsApiSend.CreateAndSendEnvelope(envelope);
           
        }
        else{
            return null;
        }  
           
    }
     
    
    public static string getSigningURL(string ProgramName, string DocuSignUserName, string DocuSignPwd, string DocuSignIntKey, string DocuSignEndURL, string urlBase, string envelopeId, string userName, string Email, string ObjId, string uTypeStr) 
    {
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();

        String auth = '<DocuSignCredentials><Username>' + DocuSignUserName +
            + '</Username><Password>' + DocuSignPwd +
            + '</Password><IntegratorKey>' + DocuSignIntKey +
            + '</IntegratorKey></DocuSignCredentials>';
                                
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        dsApiSend.endpoint_x = DocuSignEndURL;        

        DocuSignAPI.RequestRecipientTokenAuthenticationAssertion assertion = new DocuSignAPI.RequestRecipientTokenAuthenticationAssertion();
        assertion.AssertionID = GuidGenerator.generateGUID();
        assertion.AuthenticationInstant = DateTime.Now();
        assertion.AuthenticationMethod = 'Password';
        assertion.SecurityDomain = 'Request Recipient Token';
        
        DocuSignAPI.RequestRecipientTokenClientURLs urls = new DocuSignAPI.RequestRecipientTokenClientURLs();
        
        urls.OnSigningComplete = urlBase + '?event=SignComplete&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnViewingComplete = urlBase + '?event=ViewComplete&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnCancel = urlBase + '?event=Cancel&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnDecline = urlBase + '?event=Decline&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnSessionTimeout = urlBase + '?event=Timeout&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnTTLExpired = urlBase + '?event=TTLExpired&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnIdCheckFailed = urlBase + '?event=IDCheck&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnAccessCodeFailed = urlBase + '?event=AccessCode&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        urls.OnException = urlBase + '?event=Exception&uname=' + userName + '&ObjId=' + ObjId + '&uTypeStr=' + uTypeStr + '&ProgramName=' + ProgramName;
        
        if(!Test.isRunningTest()){
            return dsApiSend.RequestRecipientToken(envelopeId, userName, userName, Email, assertion, urls);
        }
        else{
            return null;
        }
    }
    
    public static string createPDF(string ProgramName, string DocuSignUserName, string DocuSignPwd, string DocuSignIntKey, string DocuSignEndURL, string EnvelopeID)
    {
    	string PDFBytesinStr = '';
    	DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();

        String auth = '<DocuSignCredentials><Username>' + DocuSignUserName +
            + '</Username><Password>' + DocuSignPwd +
            + '</Password><IntegratorKey>' + DocuSignIntKey +
            + '</IntegratorKey></DocuSignCredentials>';
        
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        dsApiSend.endpoint_x = DocuSignEndURL;
        
        //String EnvelopeID = System.currentPageReference().getParameters().get('EnvID');
		
		if(!Test.isRunningTest())
		{
			try {
			    DocuSignAPI.EnvelopePDF es 
			    = dsApiSend.RequestPDFNoWaterMark(EnvelopeID);
			   PDFBytesinStr = es.PDFBytes;
			     //PDFBytesinStr = EncodingUtil.base64Decode(es.PDFBytes);
			   // PDFBytesinStr =  EncodingUtil.base64Encode(es.PDFBytes);
			} catch ( CalloutException e) {
			    System.debug('Exception - ' + e );
			    envelopeId = 'Exception - ' + e;
			}
		}
		return PDFBytesinStr;    
    }
    // HC Agreement
    public static DocuSignAPI.EnvelopeStatus CreateDSEnvelope(string ProgramName, string DocuSignUserName, string DocuSignPwd, string DocuSignIntKey, string DocuSignEndURL, string DocuSignAcctID, string DocuSignBrand, string ObjId, string EnvSubject, string VfPgName, string DocName, list<string> Username, list<string> Email, list<string> SignName, list<string> Note, list<string> SignAnchorTabStr, list<string> DateAnchorTabStr,list<string> PnameAnchorTabStr,list<string> pTitleAnchorTabStr, string titlestr,string EmailBlurb, boolean isInSession, boolean isRouting)
    {
    	DocuSignAPI.EnvelopeStatus es;
    	system.debug('***Inside DSEnvelope******');
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
          system.debug('***after apisend call******');  
        String auth = '<DocuSignCredentials><Username>' + DocuSignUserName +
            + '</Username><Password>' + DocuSignPwd +
            + '</Password><IntegratorKey>' + DocuSignIntKey +
            + '</IntegratorKey></DocuSignCredentials>';
            system.debug('***after apisend call - auth******'+auth);                         
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        dsApiSend.endpoint_x = DocuSignEndURL;
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject = EnvSubject;
        envelope.EmailBlurb = EmailBlurb;
        envelope.AccountId  = DocuSignAcctID;
        envelope.AllowReassign = false;
        envelope.EnableWetSign = false;
             system.debug('***after apisend call - envelope******'+envelope);    
        if(!Test.isRunningTest())
        {
            DocusignAPI.BrandResults br = dsApiSend.GetAccountBrands(DocuSignAcctID);
            for(integer bn = 0; bn< br.BrandResultItems.BrandResultItem.size() ; bn++)
             {
                   DocusignAPI.BrandResultItem brandItem = br.BrandResultItems.BrandResultItem[bn];
                   if(brandItem.BrandName == DocuSignBrand)
                   {  
                        envelope.BrandId = brandItem.BrandId;
                   }
             }
        }
        
       // PageReference sum_doc = 'Page.'+ PgName; 
         system.debug('***after apisend call - envelope pagereference******'+envelope); 
        PageReference sum_doc = new PageReference(VfPgName); 
        sum_doc.getParameters().put('id',ObjId);
        Blob sum_pdfBlob;
        if(!Test.isRunningTest()) {sum_pdfBlob = sum_doc.getContent();}
          system.debug('***after apisend call - envelope sum_doc******'+sum_doc); 
        DocusignAPI.Document sum_document = new DocusignAPI.Document();
        sum_document.ID = 1;
        if(!Test.isRunningTest()) {sum_document.pdfBytes = EncodingUtil.base64Encode(sum_pdfBlob);}
        sum_document.Name = DocName;
        sum_document.FileExtension = 'pdf';
          system.debug('***after apisend call - envelope sum_document******'+sum_document); 
        envelope.Documents = new DocuSignAPI.ArrayOfDocument();
        envelope.Documents.Document = new DocuSignAPI.Document[1];
        envelope.Documents.Document[0] = sum_document; 
        
        envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[Username.size()];
         system.debug('***after apisend call - envelope sum_document envelope******'+envelope); 
        //system.debug('Number of user ' + Username.size());
        for (integer i=0;i<Username.size();i++)
        {
            DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
            if (isInSession == true)
            {
                recipient.CaptiveInfo = new DocuSignAPI.RecipientCaptiveInfo();
                recipient.CaptiveInfo.ClientUserId = Username[i];
            }
            recipient.Type_x = 'Signer';
            //system.debug('RoutingOrder ' + i);
            if (isRouting == true)
            {
                recipient.RoutingOrder = i+1;
            } 
            else
            {
                recipient.RoutingOrder = 1;
            } 
            system.debug('***after apisend call - recipient******'+recipient); 
            system.debug('ID: ' + i);      
            recipient.ID = i+1;
            recipient.UserName = Username[i];     
            recipient.Email = Email[i];
            recipient.SignerName = SignName[i];             
            recipient.Note = Note[i];
            envelope.Recipients.Recipient[i] = recipient;
             system.debug('***after apisend call - recipient envelope******'+recipient+'**********'+envelope); 
        }
        
        List<DocuSignAPI.Tab> theTabs = new List<DocuSignAPI.Tab>();
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        
        for (integer j=0;j<SignAnchorTabStr.size();j++)
         {
            DocuSignAPI.Tab signature = new DocuSignAPI.Tab();
            signature.Type_x = 'SignHere';
            signature.AnchorTabItem = new DocuSignAPI.AnchorTab();
            signature.AnchorTabItem.AnchorTabString = SignAnchorTabStr[j];
            system.debug('AnchorTabString ' + SignAnchorTabStr[j]);
            signature.AnchorTabItem.IgnoreIfNotPresent = true;
            signature.DocumentID = sum_document.ID;
            signature.RecipientID = j+1; 
            theTabs.add(signature); 
            system.debug('*****signature******* ' + signature);
            DocuSignAPI.Tab dateSigned = new DocuSignAPI.Tab();
            dateSigned.Type_x = 'DateSigned';
            dateSigned.AnchorTabItem = new DocuSignAPI.AnchorTab();
            dateSigned.AnchorTabItem.AnchorTabString = DateAnchorTabStr[j];
            system.debug('DateSignedAnchorTabString ' + DateAnchorTabStr[j]);
            dateSigned.AnchorTabItem.IgnoreIfNotPresent = true;                 
            dateSigned.DocumentID = sum_document.ID;
            dateSigned.RecipientID = j+1;         
            theTabs.add(dateSigned);
            
            DocuSignAPI.Tab PName = new DocuSignAPI.Tab();
            PName.ConcealValueOnDocument = true;
            PName.Type_x = 'FullName';
            PName.TabLabel = 'Print Name';
            //PName.CustomTabType = 'PrintName';
            //PName.CustomTabWidth = 150;
            PName.AnchorTabItem = new DocuSignAPI.AnchorTab();
            PName.AnchorTabItem.AnchorTabString = PnameAnchorTabStr[j];          
            PName.DocumentID = sum_document.ID;
            PName.RecipientID = j+1;     
            theTabs.add(PName);
            
          
            
           /* DocuSignAPI.Tab PTitle = new DocuSignAPI.Tab();
            PTitle.ConcealValueOnDocument = true;
            PTitle.Type_x = 'Custom';
            PTitle.TabLabel = 'SSN';
            PTitle.Value = 'CEO';
           // PTitle.CustomTabType = 'Title';
           // PTitle.CustomTabWidth = 150;
            PTitle.AnchorTabItem = new DocuSignAPI.AnchorTab();
            PTitle.AnchorTabItem.AnchorTabString = PTitleAnchorTabStr[j];          
            PTitle.DocumentID = sum_document.ID;
            PTitle.RecipientID = j+1;     
            theTabs.add(PTitle);*/
            
           DocuSignAPI.Tab RecordId = new DocuSignAPI.Tab();
                RecordId.Type_x = 'Custom';
                RecordId.CustomTabType = 'Text';
               
                RecordId.TabLabel = 'Name';
                system.debug('*******DSLabel: ' + RecordId.TabLabel);
                //RecordId.Name = 'PersonInfo_SFID';
                RecordId.Name = 'Title';
                system.debug('*******DSName: ' + RecordId.Name);
               
                RecordId.Value = titlestr; 
               
                RecordId.AnchorTabItem = new DocuSignAPI.AnchorTab();
                RecordId.AnchorTabItem.AnchorTabString = PTitleAnchorTabStr[j];      
                RecordId.DocumentID = sum_document.ID;
                RecordId.PageNumber = 1;
                RecordId.RecipientID = j+1;
              
            theTabs.add(RecordId);
            
          /*  DocuSignAPI.Tab PTitle = new DocuSignAPI.Tab();
            PTitle.ConcealValueOnDocument = true;
            PTitle.Type_x = 'Custom';
            PTitle.TabLabel = 'Title';
            PTitle.CustomTabType = 'Title';
            PTitle.CustomTabWidth = 150;
            PTitle.AnchorTabItem = new DocuSignAPI.AnchorTab();
            PTitle.AnchorTabItem.AnchorTabString = PTitleAnchorTabStr[j];          
            PTitle.DocumentID = sum_document.ID;
            PTitle.RecipientID = j+1;     
            theTabs.add(PTitle);
            
             DocuSignAPI.Tab RecordId1 = new DocuSignAPI.Tab();
                RecordId1.Type_x = 'Custom';
                RecordId1.CustomTabType = 'Text';
                //Dale L 3/5/2014 prototype fix for Ayusa SSN problem 
                //RecordId.TabLabel = 'PersonInfo_SFID';  
                RecordId1.TabLabel = 'Title';
                system.debug('*******DSLabel: ' + RecordId.TabLabel);
                //RecordId.Name = 'PersonInfo_SFID';
                RecordId1.Name = 'Title';
                system.debug('*******DSName: ' + RecordId1.Name);
                RecordId1.Value = ObjId;      
                RecordId1.DocumentID = sum_document.ID;
                RecordId1.PageNumber = 1;
                RecordId1.RecipientID = j+1;
                RecordId1.ConcealValueOnDocument = true;   
            theTabs.add(RecordId1);*/
           
            
         }
        
        envelope.Tabs.Tab = theTabs;   
        system.debug('***after apisend call - recipient envelope theTabs******'+theTabs);
     
        try {  
	        es  = dsApiSend.CreateAndSendEnvelope(envelope);  
	        System.debug('***es**** - ' + es);  
			//envelopeId = es.EnvelopeID;  

		} catch ( CalloutException e) {  
			System.debug('Exception - ' + e );  
			//envelopeId = 'Exception - ' + e;  
		}
		return  es;      
    }
}