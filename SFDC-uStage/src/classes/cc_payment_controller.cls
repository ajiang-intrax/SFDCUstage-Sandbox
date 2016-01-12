public class cc_payment_controller {
    public string TypeCreditCardSelected{get;set;}
    public string monthSelected{get;set;}
    public string yearSelected{get;set;}
    /*public List<SelectOption> month{get;set;}
    public List<SelectOption> year{get;set;}
    public List<SelectOption> TypeCard{get;set;}*/
    public List<SelectOption> getTypeCard(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Visa','Visa'));
        options.add(new SelectOption('MasterCard','MasterCard'));
        options.add(new SelectOption('AmericanExpress','American Express')); 
        options.add(new SelectOption('Discover','Discover')); 
        
        return options;
    }
    public List<SelectOption> getMonth(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('01','January'));
        options.add(new SelectOption('02','February'));
        options.add(new SelectOption('03','March'));
        options.add(new SelectOption('04','April'));
        options.add(new SelectOption('05','May'));
        options.add(new SelectOption('06','June'));
        options.add(new SelectOption('07','July'));
        options.add(new SelectOption('08','August'));
        options.add(new SelectOption('09','September'));
        options.add(new SelectOption('10','October'));
        options.add(new SelectOption('11','November'));
        options.add(new SelectOption('12','December'));
        
        return options;
    }
    public List<SelectOption> getYear(){
        List<SelectOption> options = new List<SelectOption>();
        Date currentdate = date.today();
        integer year = currentdate.year();
        
        options.add(new SelectOption(string.valueof(year),string.valueof(year)));
        options.add(new SelectOption(string.valueof(year + 1),string.valueof(year + 1)));
        options.add(new SelectOption(string.valueof(year + 2),string.valueof(year + 2)));
        options.add(new SelectOption(string.valueof(year + 3),string.valueof(year + 3)));
        options.add(new SelectOption(string.valueof(year + 4),string.valueof(year + 4)));
        options.add(new SelectOption(string.valueof(year + 5),string.valueof(year + 5)));
        options.add(new SelectOption(string.valueof(year + 6),string.valueof(year + 6)));
        options.add(new SelectOption(string.valueof(year + 7),string.valueof(year + 7)));
        options.add(new SelectOption(string.valueof(year + 8),string.valueof(year + 8)));
        options.add(new SelectOption(string.valueof(year + 9),string.valueof(year + 9)));
        options.add(new SelectOption(string.valueof(year + 10),string.valueof(year + 10)));
        options.add(new SelectOption(string.valueof(year + 11),string.valueof(year + 11)));
        options.add(new SelectOption(string.valueof(year + 12),string.valueof(year + 12)));
        options.add(new SelectOption(string.valueof(year + 13),string.valueof(year + 13)));
        options.add(new SelectOption(string.valueof(year + 14),string.valueof(year + 14)));
        options.add(new SelectOption(string.valueof(year + 15),string.valueof(year + 15)));
        
        return options;
    }
    
    public List<Person_info__c> personInfoList {get;set;}
    public List<Account> accountInfo{get;set;}
    public List<Applicant_Info__c> ApplicantInfoList {get;set;}    
    public List<Opportunity_Product_Cart> selectedOppProdCartList{get;set;}
    public Person_Info__c personInfo{get;set;}
    public Opportunity childApplicationOpportunity{get;set;}
    public Match__c confMatch{get;set;}
    public Applicant_Info__c applicantInfo{get;set;}  
    
    public String ipAddress {get; set;}
    public PaymentWrapper payWrapper {get; set;}
    public Payment__c payment {get; set;}
    public String maskedCCNumber {get; set;}        
    public String paymentRecordId {get; set;}
    public Boolean isConfirmPayment {get; set;}
    public Boolean useCurrentBillingAddressInfo {get; set;}
    public String paymentTxId {get; set;}
    public Decimal paymentAmount {get; set;}
    public String paymentDate {get; set;}
    public Decimal amount{get;set;}
    public String nextPageURL1{get;set;}
    public String nextPageURL2{get;set;}
    public Boolean isPaymentSuccessful{get; set;}
    public String paymentError{get; set;}
    public String pymntconfirmEmailTemplateId{get;set;}
    
    public Id paramAppId{get;set;}
    public Id paramMatchId{get;set;}
    public Id paramOppId{get;set;}
    
   public cc_payment_controller()
   {
        system.debug('inside cc_payment_controller');
        payment = new Payment__c();
        payWrapper = new PaymentWrapper();
        isConfirmPayment = false;
        useCurrentBillingAddressInfo = false;           
       
       if(applicantInfo!=null && applicantInfo.Account__c!=null)
       accountInfo = [select Id,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry,FirstName from Account where Id  = :applicantInfo.Account__c];

       System.debug('cc_payment_controller.applicantInfo   : ' + applicantInfo );
       System.debug('cc_payment_controller.childApplicationOpportunity   : ' + childApplicationOpportunity);
       System.debug('cc_payment_controller.personInfo   : ' + personInfo);
       System.debug('cc_payment_controller.match   : ' + confMatch);
       System.debug('cc_payment_controller.amount   : ' + amount);
       System.debug('cc_payment_controller.selectedOppProdCartList   : ' + selectedOppProdCartList);
       System.debug('cc_payment_controller.nextPageURL1   : ' + nextPageURL1);
       System.debug('cc_payment_controller.nextPageURL2   : ' + nextPageURL2);
       System.debug('cc_payment_controller.pymntconfirmEmailTemplateId   : ' + pymntconfirmEmailTemplateId);
       System.debug('cc_payment_controller.accountInfo :' + accountInfo);
       
        /*if(ApexPages.currentPage().getParameters().get('expireMonth') != null) 
            monthSelected = ApexPages.currentPage().getParameters().get('expireMonth');
        if(ApexPages.currentPage().getParameters().get('expireYear') != null) 
            yearSelected = ApexPages.currentPage().getParameters().get('expireYear');
        if(ApexPages.currentPage().getParameters().get('maskCCNumber') != null) 
            maskedCCNumber = ApexPages.currentPage().getParameters().get('maskCCNumber');
        
        if(ApexPages.currentPage().getParameters().get('paymentTxId') != null) 
            paymentTxId = ApexPages.currentPage().getParameters().get('paymentTxId');

        if(ApexPages.currentPage().getParameters().get('paymentDate') != null) 
            paymentDate = ApexPages.currentPage().getParameters().get('paymentDate');
        
        if(ApexPages.currentPage().getParameters().get('paymentId') != null) {
            paymentRecordId = ApexPages.currentPage().getParameters().get('paymentId');
            
            System.debug('payemnt record id' + paymentRecordId);
            List<Payment__c> paymentRecords = [Select Id, Amount__c, Txn_Id__c FROM Payment__c WHERE ID =: ID.valueOf(paymentRecordId)];
            if(paymentRecords.size() > 0) {
                payWrapper.amount = paymentRecords[0].Amount__c;
                payWrapper.txnId =  paymentRecords[0].Txn_Id__c;
            }
        }*/
   }

    public pagereference makeAWSPayment() {
        
       System.debug('cc_payment_controller.applicantInfo   : ' + applicantInfo );
       System.debug('cc_payment_controller.childApplicationOpportunity   : ' + childApplicationOpportunity);
       System.debug('cc_payment_controller.personInfo   : ' + personInfo);
       System.debug('cc_payment_controller.match   : ' + confMatch);
       System.debug('cc_payment_controller.amount   : ' + amount);
       System.debug('cc_payment_controller.selectedOppProdCartList   : ' + selectedOppProdCartList);
       System.debug('cc_payment_controller.nextPageURL1   : ' + nextPageURL1);
       System.debug('cc_payment_controller.nextPageURL2   : ' + nextPageURL2);
       System.debug('cc_payment_controller.pymntconfirmEmailTemplateId   : ' + pymntconfirmEmailTemplateId);
       System.debug('cc_payment_controller.payment   : ' + payment);
        
		try
        {
       if(applicantInfo!=null && applicantInfo.Account__c!=null)
       accountInfo = [select Id,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry,FirstName 
                      from Account 
                      where Id  = :applicantInfo.Account__c];
		System.debug('cc_payment_controller.accountInfo :' + accountInfo);
        
        String URLAux = ApexPages.currentPage().getUrl(); 
        System.debug('URL ' + URLAux + ' makeAWSPayment method');
        isPaymentSuccessful = true;
        
        /*double TotalAmount=0.0;
        for(double amount : mainController.SelectedItemsPriceMapDueNow.Values())
        {
            TotalAmount = TotalAmount + amount;
        }*/
        payWrapper.amount = amount;
        //amount = TotalAmount;
        
        //Setting required properties before invoking payment web service
        system.debug('*****### payment.Amount__c: ' + payment.Amount__c);
        system.debug('*****### payment.Promo_Code__c: ' + payment.Promo_Code__c);
        
        //Populating some other properties
        if(!String.isBlank(monthSelected))
            payWrapper.cardExpirationMonth = monthSelected;
        if(!String.isBlank(yearSelected))
            payWrapper.cardExpirationYear = yearSelected;
        if(!String.isBlank(TypeCreditCardSelected))
            payWrapper.cardType = TypeCreditCardSelected;
        payment.IP_Address__c = ipAddress;
        
        //Now save all the selected product list in a serialized format in the payment object, irrespective of whether the payment is successfull or not.
        if(selectedOppProdCartList != null && selectedOppProdCartList.size()>0)
        payment.serializedProductList__c= JSON.serialize(selectedOppProdCartList);
        
        //We can't overwrite a master-detail field
        //if(payment.Card_Holder__c == null){}
        system.debug('*****### We are here 1  - payment test: ' + payment);
        payment.Card_Holder__c = applicantInfo.Id;
        payment.Account_Name__c=applicantInfo.Account__c;
        //PULL OPPORTUNITY HERE
        if(childApplicationOpportunity!=null)
            payment.Opportunity_Name__c = childApplicationOpportunity.Id;
        
        payment.Amount__c = payWrapper.amount;        
        //For capturing payment failure transaction.... AP
        payment__c paymentCopy = new payment__c();
        paymentCopy = payment;
        System.debug('@@ paymentCopy @@' +paymentCopy +paymentCopy.sucess__c);
        
        //Variable to hold the AWS Payment process response result
        //SPILLAI-ENCRYPTION-CHANGES
        //paymentServiceWebServiceInterfaceNew.paymentTransactionResultSetDto paymentResponse =  new paymentServiceWebServiceInterfaceNew.paymentTransactionResultSetDto();
        paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto paymentResponse =  new paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto();
        //SPILLAI-ENCRYPTION-CHANGES
        //Making web service callout to get the response 
        System.debug('makeAWSPayment payment record is '+ payment);
        System.debug('makeAWSPayment paymentCopy record is '+ paymentCopy);
        System.debug('makeAWSPayment payWrapper record is '+ payWrapper);
        
        if(!Test.isRunningTest()) {
            //SPILLAI-ENCRYPTION-CHANGES
            //paymentResponse = PaymentService.makeCreditCardTransactionRequest(payment, applicantInfo, personInfo, payWrapper);
            // If loop for checking if txn success then get resposne else re query to check status .. AP
            system.debug('paymentcopy success' + paymentCopy.sucess__c);
            if (paymentCopy.sucess__c != false)
            {
                try
                {
                    //StringException s = new StringException();
                    //throw s;
                    paymentResponse = PaymentService.makeEncryptedCreditCardTransactionRequest(payment, applicantInfo, personInfo, payWrapper);
                }
                catch(Exception ex)
                {
                    IUtilities.sendExceptionEmail(ex);
                }
                
            }
            else
            {  
               try
                {
                    //StringException s = new StringException();
                    //throw s;
                    paymentResponse = PaymentService.makeEncryptedCreditCardTransactionRequest(paymentCopy, applicantInfo, personInfo, payWrapper);
                }
                catch(Exception ex)
                {
                    IUtilities.sendExceptionEmail(ex);
                }
                
             }
            //SPILLAI-ENCRYPTION-CHANGES
            System.debug('@@@@ paymentResponse ' + paymentResponse);
        } else {
            //Setting Payment object fields values with the help of response retrived properties values
            payment.Txn_Id__c = String.valueOf(Math.random() + '_1');
            payment.Sucess__c = true;
            payment.Txn_Gateway__c = 'Cyberspace';
            payment.Txn_Amount__c = 123.45;
            payment.Txn_Date__c = System.now();
            payment.Payment_Type__c = 'Visa';
            payment.Txn_Code__c = '123XXX';
        }
        
        //Passing response for parsing and then populate payment record with response retrived properties values
        if(!Test.isRunningTest()) {
            //SPILLAI-ENCRYPTION-CHANGES
            //payment = PaymentHelper.parseWebServiceResponse(payment, paymentResponse);
            try{
                payment = PaymentHelper.parseEncryptedWebServiceResponse(payment, paymentResponse);
                System.debug('@@@@ payment ' + payment);
            }catch(Exception ex) {
                IUtilities.sendExceptionEmail(ex);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
                
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Invalid credit card info. Please check your info is correct'));
                //return null;
            }
            //SPILLAI-ENCRYPTION-CHANGES
            
        }
        
        //Trying to create a new payment record in system with response retrieved value and implementing post callout logic according to it
        try {
            
            //In case of success Txn Id should be there in callout response 
            if(!String.isBlank(payment.Txn_Id__c)) {
                
                system.debug('*****###payment test: ' + payment);
                 payment.Txn_Amount__c = amount;
                insert payment;
                try
                {
                     String accountBillingStreet = accountInfo[0].BillingStreet.replace('\r\n','');
                
                    String paymentBillingStreet;
                    if(payment.Billing_Street_2__c!=null)
                        paymentBillingStreet= payment.Billing_Street_1__c.replace('\r\n','') + payment.Billing_Street_2__c.replace('\r\n','');
                    else
                        paymentBillingStreet = payment.Billing_Street_1__c.replace('\r\n','');
                    
                    if(accountInfo!=null & accountInfo.size()>0)
                    {
                        if (accountBillingStreet != paymentBillingStreet ||
                            accountInfo[0].BillingCity != payment.Billing_City__c ||
                            accountInfo[0].BillingState != payment.Billing_State__c ||
                            accountInfo[0].BillingPostalCode != payment.Billing_Postal_Code__c ||
                            accountInfo[0].BillingCountry != payment.Billing_Country__c )
                        {
                            if(payment.Billing_Street_2__c!=null)
                                accountInfo[0].BillingStreet= payment.Billing_Street_1__c + '\r\n' + payment.Billing_Street_2__c;
                            else
                                accountInfo[0].BillingStreet= payment.Billing_Street_1__c;
                            
                            accountInfo[0].BillingCity = payment.Billing_City__c;
                            accountInfo[0].BillingState = payment.Billing_State__c;
                            accountInfo[0].BillingPostalCode = payment.Billing_Postal_Code__c;
                            accountInfo[0].BillingCountry = payment.Billing_Country__c;
                            system.debug('@@ check point1. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                            update accountInfo[0];
                            system.debug('@@ check point2. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                        }
                    }
                }
                catch(Exception ex)
                {
                    IUtilities.sendExceptionEmail(ex);
                }
                //Populating string with masked Credit Card number string, Going to be displayed on page
                
                system.debug('*****##payment test: ' + payment);
                paymentRecordId = payment.Id;
                paymentTxId = payment.Txn_Id__c;
                paymentAmount = payment.Amount__c.setScale(2);
                paymentDate = String.valueOf(payment.Txn_Date__c);
                system.debug('*****## paymentTxId: ' + paymentTxId);
                system.debug('*****## paymentAmount: ' + paymentAmount);
                
                // Creating the attachment pdf payment confirmation
                
                PageReference pdf = new PageReference('/apex/'+nextPageURL2);
               
                
                system.debug('*****## pdf: ' + pdf);
                pdf.getParameters().put('paymentAmount',String.valueOf(paymentAmount));
                pdf.getParameters().put('paymentDate',paymentDate);
                pdf.getParameters().put('paymentTxId',paymentTxId);
                pdf.getParameters().put('title','AuPairCare Childcare Application');
                //pdf.getParameters().put('id',applicantinfo.id);
                pdf.setRedirect(true);
                
                // Take the PDF content
                Blob b = pdf.getContent();
                
                // Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('payment_confirmation.pdf');
                efa.setBody(b);
                //send an email to the user
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //String emailPrimary= personinfo.Email__c;
                //String[] toAddresses = new String[]{emailPrimary};
                //mail.setToAddresses(toAddresses);
                mail.setSaveAsActivity(false);
                //mail.setSubject('AuPairCare Fee Payment Confirmation');
                
                //Get the payment email ID from Custom Setting Application Constants
                String EmailPaymentId;
                List<Application_Constants__c> appconstants = Application_Constants__c.getall().values();
                //Application_Constants__c appconstant = Application_Constants__c.getInstance('APC_Payment_Confirmation_ID');
                Application_Constants__c appconstant = Application_Constants__c.getInstance(pymntconfirmEmailTemplateId);
                EmailPaymentId=appconstant.Value__c;
                /*for(Application_Constants__c ac:appconstants){
                if (ac.Name == 'APC_Payment_Confirmation_ID'){
                EmailPaymentId=ac.Value__c;
                }
                }*/
                mail.setTemplateId(EmailPaymentId);
                mail.setTargetObjectId(applicantinfo.CreatedBy__c); 
                //mail.setPlainTextBody('Dear '+ personinfo.First_Name__c + ' ' + personinfo.Last_Name__c + ', thanks for paying the fee.');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                emails.add(mail);
                
                try{    
                /*Uncomment this line to send the email payment confirmation */
                Messaging.sendEmail(emails);
                }catch(Exception ex)
                {
                    System.debug('Failed to send email. Exception is ' + ex);
                }
                
                //Map Person_Info records into Member__c and Reference__c records
                /*Uncomment this line to copy References and Members*/
                //MapPersonToReferenceMember.MapPersonToRef(String.valueOf(applicantinfo.Id), String.valueOf(applicantinfo.Account__c)); 
                
                //FINAL METHOD - ACTIONS AFTER SUCCESSFUL PAYMENT   
                //Dont confirm the match just now as we want to keep the payment page as light as possible.
                //we can confirm the match on the next page (thankyou page)
                         
                PageReference p = new PageReference('/apex/'+nextPageURL1);
                p.getParameters().put('Id',applicantInfo.Id);
                if(confMatch!=null)
                {
                    p.getParameters().put('mId',confMatch.Id);
                	if(confMatch.Engagement__c!=null)
                    p.getParameters().put('engagementId',confMatch.Engagement__c);
                }
                else
                {
                    p.getParameters().put('mId','');
                    p.getParameters().put('engagementId','');
                }
                p.getParameters().put('oppId',childApplicationOpportunity.Id);
                p.getParameters().put('paymentId',paymentRecordId);
                if(!String.isBlank(paymentTxId))
                    P.getParameters().put('paymentTxId', paymentTxId);
                //if(!String.isBlank(paymentAmount))
                //    P.getParameters().put('paymentAmount', paymentAmount);
                if(!String.isBlank(paymentDate))
                    P.getParameters().put('paymentDate', paymentDate);
                
                p.setRedirect(true);
                return p;
                
            } else {
                
                //If there us any exception, still insert the payment record with error for tracking purpose
                isPaymentSuccessful= false;
                insert payment;
                
                if(!String.isBlank(payment.Error_Description__c))
                paymentError = payment.Error_Description__c.replace('_',' ');
                else
                paymentError = 'Please check your credit card details and try again. If you are still unable to pay, please submit another credit card or contact our Billing Department at 800-428-7247 option 4 for assistance.';
            
                //paymentError = 'One or more fields contained invalid data, please enter your data again.';
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'' + paymentError);
                ApexPages.addMessage(errorMessage);
                system.debug('@@ error :'+errorMessage);
                
                system.debug('*****### We are here 2  - payment test: ' + payment);
                system.debug('@@@ payment.Txn_Reference_Id__c@@@' +payment.Txn_Reference_Id__c);
                //Reset billing address data
                payment = new Payment__c();
                
                //Reset credit card info
                TypeCreditCardSelected=null;
                payWrapper.ccNumber=null;
                monthSelected=null;
                yearSelected=null;
                payWrapper.cvvNumber=null;
                
                //If transaction failed, keeping amount and promocode
                //payment.Promo_Code__c =  promoCodeValue;
                payment.Amount__c = amount;
                
                
                useCurrentBillingAddressInfo = false;
                backToPaymentEditPage();
                system.debug('*****### isConfirmPayment:' + isConfirmPayment);
                return null;
            }
            
        } catch(Exception ex) {
            IUtilities.sendExceptionEmail(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            return null;
        }
    }
         catch(Exception ex)
                {
                    IUtilities.sendExceptionEmail(ex);
                    return null;
                }
    }
    
    
    public void blankOutAddressDetailsOnPaymentPage() {
        
        if(useCurrentBillingAddressInfo != null && useCurrentBillingAddressInfo) {
            
            //Populating Address fields on payment record
            payment.Billing_FirstName__c = personInfo.First_Name__c;
            payment.Billing_LastName__c = personInfo.Last_Name__c;
            payment.Billing_Email__c = personInfo.Email__c;
            //payment.Billing_Phone__c = personInfo.Phone__c;
            /*payment.Billing_Street_1__c = applicantInfo.Home_Street_1__c;
            payment.Billing_Street_2__c = applicantInfo.Home_Street_2__c;
            payment.Billing_City__c = applicantInfo.Home_City__c;
            payment.Billing_State__c = applicantInfo.Home_State__c;
            payment.Billing_Country__c = applicantInfo.Home_Country__c;
            payment.Billing_Postal_Code__c = applicantInfo.Home_Postal_Code__c;*/
            
            List<String> addresses = applicantInfo.Account__r.BillingStreet.Split('\r\n',2);
            
            if(addresses!=null && addresses.size()>0)
            {
                System.debug('addresses is ' + addresses);
                if(addresses.size()==1)
                {
                    payment.Billing_Street_1__c = addresses[0];
                }
                else if(addresses.size()==2)
                {
                    payment.Billing_Street_1__c = addresses[0];
                    payment.Billing_Street_2__c = addresses[1];
                }
            }
            
            //payment.Billing_Street_1__c = applicantInfo.Account__r.BillingStreet;
           // payment.Billing_Street_2__c = applicantInfo.Home_Street_2__c;
            payment.Billing_City__c = applicantInfo.Account__r.BillingCity;
            payment.Billing_State__c = applicantInfo.Account__r.BillingState;
            payment.Billing_Country__c = applicantInfo.Account__r.BillingCountry;
            payment.Billing_Postal_Code__c = applicantInfo.Account__r.BillingPostalCode;
            //payment.Txn_Reference_Id__c = GuidGenerator.generateGUID();
            
        } else {
            
            //Populating Address fields on payment record
            payment.Billing_FirstName__c = '';
            payment.Billing_LastName__c = '';
            payment.Billing_Email__c = '';
            //payment.Billing_Phone__c = '';
            payment.Billing_Street_1__c = '';
            payment.Billing_Street_2__c = '';
            payment.Billing_City__c = '';
            payment.Billing_State__c = '';
            payment.Billing_Country__c = '';
            payment.Billing_Postal_Code__c = '';
            
            
        }
    }
    
    /*public void backToPaymentEditPage() {
        isConfirmPayment = false;
    }*/
    
    public PageReference backToPaymentEditPage()
    {
        PageReference pdf;
        String  URLAux = ApexPages.currentPage().getUrl();
        
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_travel_payment')){
            pdf = Page.apc_ap_travel_payment;
        }
        
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_main_payment')){
        pdf = Page.apc_ap_main_payment;
        }
        
        pdf.setRedirect(true);
        system.debug('*****## pdf: ' + pdf);
        return pdf;
    }
    
    public void navigateToPaymentNonEditPage() {
        payment.Txn_Reference_Id__c = GuidGenerator.generateGUID();
        if(applicantinfo.Application_Type__c == 'Extension' && applicantinfo.Extension_Payment_Agreed__c == false){
            paymentError='Please acknowledge and agree to the extension program fees to continue';
            isPaymentSuccessful = false;
        }
        // Below If Block as a part of payment error handling .... done by AP        
        if(String.isBlank(payWrapper.ccNumber)||String.isBlank(payWrapper.cvvNumber) ) 
        {
            system.debug('@@ cc numbr @@' +payWrapper.ccNumber);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Please enter all required values'));
        }
        
        
        else{
            system.debug('*****###into navigateToPaymentNonEditPage()');
            maskedCCNumber = '************' + payWrapper.ccNumber.subString(payWrapper.ccNumber.length()-4, payWrapper.ccNumber.length());
            payment.Amount__c = amount;
            System.debug('navigateToPaymentNonEditPage : ' + payment);
            //if(String.isBlank(totalamount))
            //totalamount = '350';
            isConfirmPayment = true;            
            
        }
    }
}