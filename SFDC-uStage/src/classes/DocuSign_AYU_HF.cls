public with sharing class DocuSign_AYU_HF {
    private String app_info_id;
    private Applicant_Info__c applicantInfo;
    public Docusign_Settings__c settings { get; set; }
    public List<Person_Info__c> pInfoAgreement { get; set; }
    public List<Person_Info__c> pInfoBackground { get; set; } 
    public List<Person_Info__c> fullPISet { get; set; }
    private Person_Info__c pInfoPrimary; 
    public Boolean showBlockOnPage {get; set;}
    
    public DocuSign_AYU_HF(ApexPages.StandardController controller) {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');
        app_info_id = controller.getId();
        settings = Docusign_Settings__c.getInstance('Ayusa_Hosting_Documents'); 
        applicantInfo = [Select a.Type__c, a.Title__c, a.Application_Stage__c, a.Partner_Name__c From Applicant_Info__c a WHERE Id =: app_info_id];
        
        pInfoAgreement = [SELECT Id, Email__c, First_Name__c, Last_Name__c, Applicant_Info__c, Applicant_Info__r.Email__c, Applicant_Info__r.Name, ESSN__c
                              FROM Person_Info__c  
                              WHERE Applicant_Info__c = :app_info_id AND Role__c != 'School Official' AND  
                              Role__c != 'Teacher' AND Role__c != 'Reference' AND Age__c > 17 AND
                              Residency_Status__c != 'Lives Elsewhere'];
                          
        pInfoBackground = [SELECT Id, Email__c, First_Name__c, Last_Name__c, Applicant_Info__c, Applicant_Info__r.Email__c, Applicant_Info__r.Name, ESSN__c
                              FROM Person_Info__c  
                              WHERE Applicant_Info__c = :app_info_id AND Role__c != 'School Official' AND
                              Role__c != 'Teacher' AND Role__c != 'Reference' AND Age__c > 17 AND
                              Residency_Status__c != 'Lives Elsewhere'];
        
        // Getting the Primary Applicant personInfo record
        pInfoPrimary = [SELECT id, Name, Email__c, Primary_Applicant__c, First_Name__c, Last_Name__c
                            FROM Person_Info__c
                            WHERE Applicant_Info__c =: app_info_id AND Primary_Applicant__c = true ];

        Set<Person_Info__c> recipientSet = new Set<Person_Info__c>();
        recipientSet.addAll(pInfoAgreement);             
        recipientSet.addAll(pInfoBackground); 
        fullPISet = new List<Person_Info__c>();
        fullPISet.addAll(recipientSet);   
                          
    }

    public void send() {
        
        showBlockOnPage = true;
        System.debug('@@@@@@ value in showBlockOnPage' + showBlockOnPage );
        //List of String to hold the Email Addresses for the System Administrator Users
        List<String> systemAdministratorEmailAddresses = new List<String>();
             
        //Loop through list of System Adminstrator Users
        for(User sysAdminUser : Utility.getSystemAdministartors()) {
         
            //Populating list with email addresses
            systemAdministratorEmailAddresses.add(sysAdminUser.Email); 
             
         }
        
        try { 
        
        if(checkEnvironment()) {
            DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
            
            String auth = '<DocuSignCredentials><Username>'+ settings.Docusign_User_Id__c +
                        + '</Username><Password>' + settings.Docusign_Password__c
                        + '</Password><IntegratorKey>' + settings.Docusign_Integrator_Key__c
                        + '</IntegratorKey></DocuSignCredentials>';
                        
            dsApiSend.inputHttpHeaders_x = new Map<String, String>();
            dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
            dsApiSend.endpoint_x = settings.Docusign_Webservice_Endpoint__c;      
            
            DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
            envelope.Subject = settings.Docusign_Email_Subject__c + ' ' + pInfoPrimary.First_Name__c + ' ' + pInfoPrimary.Last_Name__c; 
            envelope.EmailBlurb = settings.Docusign_Email_Body__c + ' ' + settings.Docusign_Email_Body_Ext__c;
            envelope.AccountId  = settings.Docusign_Account_Id__c;
            envelope.AllowReassign = false;
            envelope.EnableWetSign = false;
            
            if(!Test.isRunningTest()) {
                // Getting the Branding
                //if(settings.Docusign_Brand_Id__c != null){
                    //envelope.BrandId = settings.Docusign_Brand_Id__c;
                //}else{
                    DocusignAPI.BrandResults br = dsApiSend.GetAccountBrands(settings.Docusign_Account_Id__c);
                    //system.debug('***** BrandResultItem: '+ br.BrandResultItems.BrandResultItem.size() );
                    //system.debug('***** BrandResultItem: '+ br.BrandResultItems.BrandResultItem[1]);
                    for(integer i = 0; i< br.BrandResultItems.BrandResultItem.size() ; i++){
                        DocusignAPI.BrandResultItem brandItem = br.BrandResultItems.BrandResultItem[i];
                        //system.debug('******* brandItem.BrandId ' + brandItem.BrandId);
                        //system.debug('******* getting brandName ' + brandItem.BrandName);
                        if(brandItem.BrandName == settings.Docusign_Brand_Name__c){  
                            //system.debug('**** Getting the barnding' + brandItem.BrandId);               
                            envelope.BrandId = brandItem.BrandId;
                        }
                    }
                //}
            }
            
            //-------- Summary Document 
            PageReference sum_doc = new PageReference('/apex/ayusa_hf_fam_view_pdf_summary'); 
            sum_doc.getParameters().put('id',app_info_id);
            Blob sum_pdfBlob;
            if(!Test.isRunningTest()) {sum_pdfBlob = sum_doc.getContent();}
            
            DocusignAPI.Document sum_document = new DocusignAPI.Document();
            sum_document.ID = 1;
            if(!Test.isRunningTest()) {sum_document.pdfBytes = EncodingUtil.base64Encode(sum_pdfBlob);}
            sum_document.Name = 'HF Summary Document';
            sum_document.FileExtension = 'pdf';
            //------- 
            
            PageReference sign_doc = new PageReference('/apex/SignatureGenerator');
            sign_doc.getParameters().put('id', app_info_id);
            sign_doc.getParameters().put('type', 'Agreement'); 
            Blob sign_pdfBlob;       
            if(!Test.isRunningTest()) { sign_pdfBlob = sign_doc.getContentAsPDF(); }
                    
            DocuSignAPI.Document signature_page = new DocuSignAPI.Document();
            signature_page.ID = 2;
            if(!Test.isRunningTest()) { signature_page.pdfBytes = EncodingUtil.base64Encode(sign_pdfBlob); }
            signature_page.Name = 'Signature Page';
            signature_page.FileExtension = 'pdf';    
            
            PageReference bg_doc = new PageReference('/apex/SignatureGenerator');
            bg_doc.getParameters().put('id', app_info_id);
            bg_doc.getParameters().put('type', 'Background');
            Blob bg_pdfBlob;
            if(!Test.isRunningTest()) { bg_pdfBlob = bg_doc.getContentAsPDF(); }
                    
            DocuSignAPI.Document background_page = new DocuSignAPI.Document();
            background_page.ID = 3;
            if(!Test.isRunningTest()) { background_page.pdfBytes = EncodingUtil.base64Encode(bg_pdfBlob); }
            background_page.Name = 'Background Page';
            background_page.FileExtension = 'pdf';                   
                           
            List<DocuSignAPI.Tab> theTabs = new List<DocuSignAPI.Tab>();
            envelope.Documents = new DocuSignAPI.ArrayOfDocument();
            envelope.Documents.Document = new DocuSignAPI.Document[3];
            envelope.Documents.Document[0] = sum_document; 
            envelope.Documents.Document[1] = signature_page;            
            envelope.Documents.Document[2] = background_page;      
    
            envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
            
            envelope.Tabs = new DocuSignAPI.ArrayOfTab();                                     
               
            Integer listSize = fullPISet.size();
            Map<String, Integer> recipientIDMap = new Map<String, Integer>();
            envelope.Recipients.Recipient = new DocuSignAPI.Recipient[listSize];
            
            for (Integer pi = 0; pi < listSize; pi++) {
                DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
                recipient.Type_x = 'Signer';
                recipient.RoutingOrder = 1;         
                recipient.ID = pi+1;
                 recipient.UserName = fullPISet[pi].First_Name__c + ' ' + fullPISet[pi].Last_Name__c;     
                if(fullPISet[pi].Email__c != null){
                    recipient.Email = fullPISet[pi].Email__c;
                    recipient.SignerName = fullPISet[pi].First_Name__c + ' ' + fullPISet[pi].Last_Name__c;             
                }else{
                    recipient.Email = pInfoPrimary.Email__c;
                    recipient.SignerName = fullPISet[pi].First_Name__c + ' ' + fullPISet[pi].Last_Name__c;
                    /*recipient.SignatureInfo = new DocuSignAPI.RecipientSignatureInfo();
                    recipient.SignatureInfo.SignatureName = fullPISet[pi].First_Name__c + ' ' + fullPISet[pi].Last_Name__c;
                    recipient.SignatureInfo.SignatureInitials = fullPISet[pi].First_Name__c.left(1) + fullPISet[pi].Last_Name__c.left(1);
                    recipient.SignatureInfo.FontStyle = 'Mistral';
                    */
                    recipient.Note = 'Person to sign: ' + fullPISet[pi].First_Name__c + ' ' + fullPISet[pi].Last_Name__c  + ' - On behalf of: '+ pInfoPrimary.First_Name__c + ' ' + pInfoPrimary.Last_Name__c;
                }
                recipientIDMap.put(fullPISet[pi].Id, pi+1);
                envelope.Recipients.Recipient[pi] = recipient;
            }
                           
            for (Integer i = 0; i < pInfoAgreement.size(); i++) {                    
                DocuSignAPI.Tab signature = new DocuSignAPI.Tab();
                signature.Type_x = 'SignHere';
                signature.AnchorTabItem = new DocuSignAPI.AnchorTab();
                signature.AnchorTabItem.AnchorTabString = pInfoAgreement[i].Id + '-AgreementSignature'; //'Name: ' + pInfoAgreement[i].First_Name__c + ' ' + pInfoAgreement[i].Last_Name__c;
                signature.AnchorTabItem.IgnoreIfNotPresent = true;
                signature.DocumentID = 2;
                signature.RecipientID = recipientIDMap.get(pInfoAgreement[i].Id); 
                theTabs.add(signature); 
                
                DocuSignAPI.Tab dateSigned = new DocuSignAPI.Tab();
                dateSigned.Type_x = 'DateSigned';
                dateSigned.AnchorTabItem = new DocuSignAPI.AnchorTab();
                dateSigned.AnchorTabItem.AnchorTabString = pInfoAgreement[i].Id + '-AgreementDate'; //'Name: ' + pInfoAgreement[i].First_Name__c + ' ' + pInfoAgreement[i].Last_Name__c;
                dateSigned.AnchorTabItem.IgnoreIfNotPresent = true;                 
                dateSigned.DocumentID = 2;
                dateSigned.RecipientID = recipientIDMap.get(pInfoAgreement[i].Id);         
                theTabs.add(dateSigned);            
                
                //DocuSignAPI.Tab RecordId = new DocuSignAPI.Tab();
                //RecordId.Type_x = 'Custom';
                //RecordId.CustomTabType = 'SSN'; 
                //RecordId.TabLabel = 'PersonInfo_SFID';
                //RecordId.Name = 'PersonInfo_SFID';
                //RecordId.Value = pInfoAgreement[i].Id;      
                //RecordId.DocumentID = 2;
                //RecordId.PageNumber = 1;            
                //RecordId.RecipientID = recipientIDMap.get(pInfoAgreement[i].Id);
                //RecordId.ConcealValueOnDocument = true;
                //RecordId.CustomTabValidationMessage = 'Please enter SSN as XXX-XX-XXXX';
                //theTabs.add(RecordId);                                     
            }    
           
            for (Integer i = 0; i < pInfoBackground.size(); i++) {                    
                DocuSignAPI.Tab signature = new DocuSignAPI.Tab();
                signature.Type_x = 'SignHere';
                signature.AnchorTabItem = new DocuSignAPI.AnchorTab();
                signature.AnchorTabItem.AnchorTabString = pInfoBackground[i].Id + '-BackgroundSignature'; //'Name: ' + pInfoBackground[i].First_Name__c + ' ' + pInfoBackground[i].Last_Name__c;
                signature.AnchorTabItem.IgnoreIfNotPresent = true;
                signature.DocumentID = 3;
                signature.RecipientID = recipientIDMap.get(pInfoBackground[i].Id); 
                theTabs.add(signature); 
                
                DocuSignAPI.Tab dateSigned = new DocuSignAPI.Tab();
                dateSigned.Type_x = 'DateSigned';
                dateSigned.DocumentID = 3;
                dateSigned.RecipientID = recipientIDMap.get(pInfoBackground[i].Id);
                dateSigned.AnchorTabItem = new DocuSignAPI.AnchorTab();
                dateSigned.AnchorTabItem.AnchorTabString = pInfoBackground[i].Id + '-BackgroundDate'; //'Name: ' + pInfoBackground[i].First_Name__c + ' ' + pInfoBackground[i].Last_Name__c;
                dateSigned.AnchorTabItem.IgnoreIfNotPresent = true;
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
                SSN.AnchorTabItem.AnchorTabString = pInfoBackground[i].Id + '-BackgroundSSN'; //'Name: ' + pInfoBackground[i].First_Name__c + ' ' + pInfoBackground[i].Last_Name__c;          
                SSN.DocumentID = 3;
                SSN.RecipientID = recipientIDMap.get(pInfoBackground[i].Id);
                theTabs.add(SSN);    
                
                DocuSignAPI.Tab RecordId = new DocuSignAPI.Tab();
                RecordId.Type_x = 'Custom';
                RecordId.CustomTabType = 'Text';
                //Dale L 3/5/2014 prototype fix for Ayusa SSN problem 
                //RecordId.TabLabel = 'PersonInfo_SFID';  
                RecordId.TabLabel = 'PersonInfo_SFID-'+i;
                system.debug('*******DSLabel: ' + RecordId.TabLabel);
                //RecordId.Name = 'PersonInfo_SFID';
                RecordId.Name = 'PersonInfo_SFID-'+i;
                system.debug('*******DSName: ' + RecordId.Name);
                RecordId.Value = pInfoBackground[i].Id;      
                RecordId.DocumentID = 3;
                RecordId.PageNumber = 1;
                RecordId.RecipientID = recipientIDMap.get(pInfoBackground[i].Id);
                RecordId.ConcealValueOnDocument = true;
                theTabs.add(RecordId);                                     
            }       
            
            DocuSignAPI.CustomField myCustomField = new DocuSignAPI.CustomField();
            myCustomField.Name = 'DSFSSourceObjectId';
            myCustomField.Value = app_info_id + '~Applicant_Info__c';
            myCustomField.Show = 'false';
            myCustomField.Required = 'false';
            
            envelope.CustomFields = new DocuSignAPI.ArrayOfCustomField();
            envelope.CustomFields.CustomField = new DocuSignAPI.CustomField[1];
            envelope.CustomFields.CustomField[0] = myCustomField;
            envelope.Tabs.Tab = theTabs;                  
            
            try
            {                
                DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);    
                applicantInfo.Application_Stage__c = 'Submitted';
                update applicantInfo;                
            }
            catch (Exception ex)
            {    System.debug('An exception occurred: ' + ex.getMessage());
                
                showBlockOnPage = false;
                
                //Add Error message on page
                 ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.Docusign_Submission_Error_Message);
                 ApexPages.addMessage(msg);
                
                String tabErrorString;
                String documentErrorString;
                String receipientErrorString;
                
                for (integer i = 0; i < envelope.Tabs.Tab.size(); i++) {
                    tabErrorString = 'Tab ' + i + '\n' +  envelope.Tabs.Tab[i].toString();
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Tab ' + i + '\n' +  envelope.Tabs.Tab[i].toString()));
                }
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Custom Field \n' + envelope.CustomFields.CustomField[0].toString()));
                for (integer j = 0; j < envelope.Documents.Document.size(); j++) {
                    documentErrorString = 'Document ' + j + '\n' + envelope.Documents.Document[j].toString();
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Document ' + j + '\n' + envelope.Documents.Document[j].toString()));
                }
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, String.valueOf(envelope.Recipients.Recipient.size())));
                for (integer h = 0; h < envelope.Recipients.Recipient.size(); h++) {
                    receipientErrorString = 'Recipient ' + h + '\n' +  envelope.Recipients.Recipient[h].toString();
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Recipient ' + h + '\n' +  envelope.Recipients.Recipient[h].toString()));
                }
                
                //Building Overall Error Message
                String errorMessage = tabErrorString + '\n' + documentErrorString + '\n' + receipientErrorString;
                
                //Sending Email to System Admin user on occurance of error
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(systemAdministratorEmailAddresses);
                mail.setSubject('Docusign : Web Service Callout Failed');
                mail.setPlainTextBody(ex.getMessage() + errorMessage);
                emails.add(mail);
                Messaging.sendEmail(emails);                                  
            }
        }
        } catch (Exception e) {
             System.debug('An exception occurred: ' + e.getMessage());
             
             showBlockOnPage = false;
                     
             //Add Error message on page
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.Docusign_Submission_Error_Message);
             ApexPages.addMessage(msg);
             
             //Sending Email to System Admin user on occurance of error
             List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             mail.setToAddresses(systemAdministratorEmailAddresses);
             mail.setSubject('Docusign : Web Service Callout Failed');
             mail.setPlainTextBody(e.getMessage());
             emails.add(mail);
             Messaging.sendEmail(emails);
         }
    }
    
    public boolean checkEnvironment(){
        if(!test.isRunningTest()){
            string curl = ApexPages.currentPage().getHeaders().get('Host');
            system.debug('***** curl: ' + curl);
            string ds_env = settings.Docusign_Webservice_Endpoint__c;
            system.debug('***** ds_env: ' + ds_env);
            
            if((curl.contains('.cs') && ds_env.contains('https://demo.')) || (curl.contains('intraxinc.secure.force.com') && ds_env.contains('https://na')) ){
                return true;
            }
            else {
                return false;
                }
        }else{
            return true;
        }       
    }
    
    public string getApplicantInfoId(){
        return app_info_id;
    }
}