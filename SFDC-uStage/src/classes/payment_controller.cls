public class payment_controller {
    
    //public String ipAddress {get; set;}
    public PaymentWrapper payWrapper {get; set;}
    public List<Account> accountinfo {get; set;}
    public List<Account> Payaccount{get; set;}
    public Payment__c payment {get; set;}
    public List<Payment__c> ErrorPaymentRecords{get; set;}
    public Payment_Subscription__c paymentSubscription {get; set;}
    public String paymentRecordId {get; set;}
    public String paymentTxId {get; set;}
    public String paymentDate {get; set;}
    public String paymentError{get; set;}
    public decimal amount{get;set;}
    public List<Sales_Invoice__c> payInvoices{get;set;}
    public List<Sales_Invoice__c> InvoiceID{get;set;}
    public List<Sales_Invoice__c> SalesInvoice{get;set;}
    public List<Sales_Invoice__c> PaymentSuccessNoIntacctSync{get;set;}
    //public List<Sales_Invoice__c> refundInvoices{get;set;}
    public apc_portal_controller mainController{get;set;}
    public Applicant_Info__c applicantInfo{get;set;} 
    public List<Applicant_Info__c> ApplicantInfoList {get;set;}  
    public map<String,String>MaskSubscription {get;set;}
    public map<String,DateTime>LastSubscriptionDate {get;set;}
    public map<id,decimal>amountdueMap{get;set;}
    Public set<Id> AccountIds= new set<Id>();
    Public set<Id> InvIds= new set<Id>();
    public String ARUpdateKey {get; set;}
    Public List<String>ErrorCode{get; set;}
    Public List<Error_Keys__c> Errorkey{get; private set;}
    
    //Get User TimeZone
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        system.debug('debug:::Display name: ' + tz.getDisplayName());
        return tz.getOffset(DateTime.now()) / (1000 *3600 *24.0);
    }}
    
    public payment_controller(){
        MaskSubscription= new map<String,String>();
        LastSubscriptiondate= new map<String,DateTime>();
        payWrapper = new PaymentWrapper();
        applicantInfo= new Applicant_Info__c();
        payment = new Payment__c();
        payment.Txn_Reference_Id__c = GuidGenerator.generateGUID();
        amountdueMap= new map<id,decimal>();
        payInvoices= new list<Sales_Invoice__c>();
        //refundInvoices= new list<Sales_Invoice__c>();
        PaymentSuccessNoIntacctSync= new list<Sales_Invoice__c>();
        ErrorPaymentRecords= new list<Payment__c>();
        
        ErrorCode = new List<String> { '202', '204','208', '210','222','203' };
            Errorkey =[Select Name,Cybersource_Error_Message__c From Error_Keys__c where Name in:ErrorCode order by Name asc ];//ErrorCode];
        
        SalesInvoice = [select Name,Id,Account__r.Name,notes__c,
                        Document_Number__c,Total__c,Opportunity__c,Opportunity__r.ChildOppType__c, Payment_Status__c,Amount_Due__c,Amount_Paid__c,
                        Ship_Date__c,Account__r.id,
                        (select id,Error_Keys__c,Account_Name__c,Amount__c,Sales_Invoice__r.Ship_Date__c,Sales_Invoice__r.Payment_Status__c,
                         Sales_Invoice__r.Amount_Due__c,Sales_Invoice__r.Total__c,Sales_Invoice__r.Opportunity__c,Sales_Invoice__r.Name ,
                         Sales_Invoice__r.Account__r.Name,Sales_Invoice__r.Document_Number__c,CreatedDate,sucess__c,Payment_Type__c 
                         from Payments__r
                         //where Error_Keys__c != null and Error_Keys__c in:ErrorCode and Sucess__c= false and 
                         //Sales_Invoice__r.Payment_Status__c != 'Paid' 
                         order by createdDate desc)
                        from Sales_Invoice__c where Payment_Status__c != 'Paid' AND 
                        Opportunity__r.ChildOppType__C !='Application' AND Opportunity__r.StageName ='Closed Won'
                        AND Ship_Date__c <= TODAY
                        ANd Amount_Due__c >0.00 
                        order by Ship_Date__c Asc];
        system.debug('debug::++++++SalesInvoice'+SalesInvoice);
        
        For(Sales_Invoice__c Inv: SalesInvoice){
            AccountIds.add(Inv.Account__c);
            MaskSubscription.put(Inv.Account__c,'Not Available');
            LastSubscriptionDate.put(Inv.Account__c,null);
            amountdueMap.put(Inv.id,Inv.Amount_Due__c);
        }
        
        for(Sales_Invoice__c Inv1: SalesInvoice){
            //now loop through all the related payments and find out if there are any payment ecords. If no, tjen SI is open
            if(Inv1.payments__r.size()==0)
            {
                payInvoices.add(Inv1);
                continue;
            }
            else
            {
                //now loop through all the related payments and find out if there are any success records. If yes ignore
                Boolean isSuccess = false;
                for(Payment__c pay : Inv1.payments__r)
                {
                    if(pay.sucess__c == true && pay.Payment_Type__c != 'Service Credit')
                    {
                        PaymentSuccessNoIntacctSync.Add(Inv1);
                        system.debug('payment already made. But SI payment status not updated by Intacct');
                        isSuccess = true;
                        break;
                    }
                    else
                        continue;
                }
                
                if(isSuccess==false)
                {
                    Boolean isCollectionReportError = false;
                    //now agian looop through if we have any payment records with certain failures if yes then include them
                    //in the collection report.
                    for(Payment__c pay : Inv1.payments__r)
                    {
                        if(pay.Error_Keys__c =='202' ||
                           pay.Error_Keys__c =='204' ||
                           pay.Error_Keys__c =='208' ||
                           pay.Error_Keys__c =='210' ||
                           pay.Error_Keys__c =='222' ||
                           pay.Error_Keys__c =='203')
                        {
                            system.debug('Payment failed with collection report errors.');
                            ErrorPaymentRecords.Add(pay);
                            isCollectionReportError = true;
                            break;
                        }
                        else
                            continue;
                    }
                    
                    if(isCollectionReportError == false)
                    {
                        payInvoices.Add(Inv1);
                    }
                }
                
            }
            
            
            
            /*If(Inv1.Payments__r.size()==0 && Inv1.Total__c > 0){
                payInvoices.add(Inv1);
            }
            else if(Inv1.Payments__r.size()==0 && Inv1.Total__c < 0){
                refundInvoices.add(Inv1);
            }
            else if(Inv1.Payments__r != NULL && Inv1.Payments__r.size()>0){
                ErrorPaymentRecords.add(Inv1.Payments__r[0]);
            }*/
        }
        system.debug('debug:::a.payInvoices'+payInvoices);
        
        If(AccountIds.size()>0){
            accountinfo=[select id,(select Encrypted_Token__c,Account__r.id,Createddate,Txn_Date__c from Payment_subscriptions__r where Is_Active__c = True order by createdDate desc) from Account where Id in:AccountIds];
            for (Account  a: accountinfo) {
                system.debug('debug:::a.Payment_subscriptions__r'+a.Payment_subscriptions__r);
                
                for (Payment_subscription__c Subs : a.Payment_subscriptions__r) {
                    string MaskCard='******************' + EncryptionDecryptionHandler.decrypt(Subs.Encrypted_Token__c).subString(EncryptionDecryptionHandler.decrypt(Subs.Encrypted_Token__c).length()-4, EncryptionDecryptionHandler.decrypt(Subs.Encrypted_Token__c).length());
                    
                    MaskSubscription.put(Subs.Account__r.id,'******************' + EncryptionDecryptionHandler.decrypt(Subs.Encrypted_Token__c).subString(EncryptionDecryptionHandler.decrypt(Subs.Encrypted_Token__c).length()-4, EncryptionDecryptionHandler.decrypt(Subs.Encrypted_Token__c).length()));
                    system.debug('debug:::MaskSubscription'+MaskSubscription);
                    LastSubscriptionDate.put(Subs.Account__r.id,Subs.Txn_Date__c);
                    
                }
            }
        }
        system.debug('**AccountIds'+AccountIds);
        system.debug('**InvIds'+InvIds);
        
    }
    
    //AA Schedule Payment --- 
    Public Pagereference makeAWSPayment(){
        try
        {
        system.debug('debug:::AccountId'+ApexPages.currentPage().getParameters().get('AcctId'));
        system.debug('debug:::amountdueMap'+amountdueMap);
        String AcctId=ApexPages.currentPage().getParameters().get('AcctId');
        ARUpdateKey=ApexPages.currentPage().getParameters().get('InvId');
        system.debug('debug:::ARUpdateKey'+ARUpdateKey);
        String childApplicationOpportunity= ApexPages.currentPage().getParameters().get('childApplicationOpportunity');
        
        If(AcctId!= null){
            Payaccount=[select id,firstName,LastName,PersonEmail,(select Encrypted_Token__c,Account__r.id,CC_Type__c from Payment_subscriptions__r where Is_Active__c = True) from Account where Id=:AcctId limit 1];
            for (Account  a: Payaccount) {
                system.debug('debug:::a.Payment_subscriptions__r'+a.Payment_subscriptions__r);
                for (Payment_subscription__c Subs : a.Payment_subscriptions__r) {
                    paymentSubscription=subs;
                }
            }
            
            applicantInfo = [Select id, Casper_Id__c,Position__c, Engagement__c, Application_Type__c, CreatedBy__c, Application_Stage__c, Application_Level__c, Application_Level_Application_Stage__c 
                             From Applicant_Info__c
                             Where Application_Stage__c = 'Accepted'
                             And Application_Level__c = 'Main'
                             And Account__c =: AcctId ORDER BY CreatedDate DESC
                             LIMIT 1];
        }
        amount =0.0;
        system.debug('debug:::Payaccount[0].id'+amountdueMap.get(ARUpdateKey));
        payWrapper.amount = amountdueMap.get(ARUpdateKey);
        system.debug('debug:::payWrapper.amount'+payWrapper.amount);
        payment.Card_Holder__c = applicantInfo.Id;
        payment.Account_Name__c=Payaccount[0].id;
        payment.First_Name__c=Payaccount[0].firstName;
        payment.Last_Name__c=Payaccount[0].LastName ;
        payment.Amount__c = payWrapper.amount;
        payment.Txn_Amount__c = payWrapper.amount;
        payment.Card_Holder__c = applicantInfo.id;
        payment.Payment_Subscription__c=paymentSubscription.id;
        payment.Sales_Invoice__c=ARUpdateKey;
        payment.CC_Type__c=paymentSubscription.CC_Type__c;
        
        system.debug('debug::childApplicationOpportunity'+childApplicationOpportunity);
        if(childApplicationOpportunity!=null)
            payment.Opportunity_Name__c = childApplicationOpportunity;
        
        //Variable to hold the AWS Subcription process response result
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        
        System.debug('makeAWSPayment payment record is '+ payment);
        System.debug('makeAWSPayment paymentSubscription record is '+ paymentSubscription);
        System.debug('makeAWSPayment applicantInfo record is '+ applicantInfo);
        System.debug('makeAWSPayment payWrapper record is '+ payWrapper);
        
        //Passing response for parsing and then populate payment record with response retrived properties values
        if(!Test.isRunningTest()) {
            
            try{
                
                If(payWrapper.amount>0){
                    paymentResponse = PaymentService.CreateSubcriptionPayment(paymentSubscription,payment, applicantInfo,  payWrapper);
                    payment.Txn_Type__c='Charge';
                }
                else{
                    paymentResponse = PaymentService.SubcriptionRefund(paymentSubscription,payment, applicantInfo,  payWrapper);
                    payment.Txn_Type__c='Refund';
                }
                payment=PaymentHelper.parseEncryptedWebServiceResponsePayment(payment, paymentResponse); 
                
                System.debug('Repeat makeAWSPayment payment record is '+ payment);
                System.debug('@@@@ paymentSubscription ' + paymentSubscription);
                System.debug('@@@@ paymentResponse ' + paymentResponse);
            }catch(Exception ex) {
                IUtilities.sendExceptionEmail(ex);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
                return null;
            }
            
        }
        
        //Trying to create a new payment record in system with response retrieved value and implementing post callout logic according to it
        try {
            //In case of success Txn Id should be there in callout response 
            if(!String.isBlank(payment.Txn_Id__c)){
                system.debug('*****###payment test: ' + payment);
                payment.Txn_Amount__c = payWrapper.amount;
                //payment.Txn_Amount__c = payWrapper.amount.abs();
                insert payment;
                
                system.debug('payment success---> ' + payment.Sucess__c);
                try{
                	Notification_Generator.callAPCNotifications(null, payment);
                }
                catch(exception ex){
                    IUtilities.sendExceptionEmail(ex);
                    system.debug('ERROR IN SENDING SCHEDULED PAYMENT NOTIFICATION'+ex);
                }
                
                //Populating string with masked Credit Card number string, Going to be displayed on page
                system.debug('*****##payment test: ' + payment);
                paymentRecordId = payment.Id;
                paymentTxId = payment.Txn_Id__c;
                paymentDate = String.valueOf(payment.Txn_Date__c);
                system.debug('*****## paymentTxId: ' + paymentTxId);
                
                
                // Creating the attachment pdf payment confirmation                
                PageReference pdf = Page.apc_hf_match_payment_confirmation_pdf;                
                system.debug('*****## pdf: ' + pdf);
                pdf.getParameters().put('paymentAmount',String.valueOf(payment.Txn_Amount__c));
                pdf.getParameters().put('paymentDate',paymentDate);
                pdf.getParameters().put('paymentTxId',paymentTxId);
                pdf.getParameters().put('title','AuPairCare Childcare Application');
                //pdf.getParameters().put('id',applicantinfo.id);
                pdf.setRedirect(true);
                
                If(payment.Txn_Amount__c >0){
                    PageReference p = Page.apc_hf_ScheduleAccountReceivables;
                    p.getParameters().put('paymentId',paymentRecordId);
                    p.getParameters().put('ARUpdateKey',ARUpdateKey);
                    
                    if(!String.isBlank(paymentTxId))
                        P.getParameters().put('paymentTxId', paymentTxId);
                    if(!String.isBlank(paymentDate))
                        P.getParameters().put('paymentDate', paymentDate);
                    
                    p.setRedirect(true);
                    return p;
                }
                else{
                    PageReference p = Page.apc_hf_schedule_payment_confirmation;
                    if(!String.isBlank(paymentTxId))
                        P.getParameters().put('paymentTxId', paymentTxId);
                    if(!String.isBlank(paymentDate))
                        P.getParameters().put('paymentDate', paymentDate);
                    
                    p.setRedirect(true);
                    return p;
                }
            } 
            else {
                //If there is any exception, still insert the payment record with error for tracking purpose
                insert payment;
                
                system.debug('payment success---> ' + payment.Sucess__c);
                try{
                	Notification_Generator.callAPCNotifications(null, payment);
                }
                catch(exception e){
                    IUtilities.sendExceptionEmail(e);
                    system.debug('ERROR IN SENDING SCHEDULED PAYMENT NOTIFICATION'+e);
                }
                
                paymentError = payment.Error_Description__c.replace('_',' ');
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'' + payment.Error_Description__c);
                ApexPages.addMessage(errorMessage);
                system.debug('@@ error :'+errorMessage);
                
                system.debug('*****### We are here 2  - paymentSubscription test: ' + payment);
                system.debug('@@@ paymentSubscription.Txn_Reference_Id__c@@@' +payment.Txn_Reference_Id__c);
                
                PageReference p = Page.apc_hf_schedule_payment_confirmation;
                p.getParameters().put('paymentId',paymentRecordId);
                
                if(!String.isBlank(paymentTxId))
                    P.getParameters().put('paymentTxId', paymentTxId);
                if(!String.isBlank(paymentDate))
                    P.getParameters().put('paymentDate', paymentDate);
                
                if(!String.isBlank(paymentError))
                    P.getParameters().put('paymentError', paymentError);
                
                p.setRedirect(true);
                return p;
            }
            return null;
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
    
    Public pagereference ScheduleAccountReceivablescall(){
        
        ARUpdateKey=ApexPages.currentPage().getParameters().get('ARUpdateKey');
        String paymentId = ApexPages.currentPage().getParameters().get('paymentId');
        system.debug('debug::ARUpdateKey'+ARUpdateKey);
        system.debug('debug::paymentId'+paymentId);
        
        If(ARUpdateKey != null && paymentId != null){
            IntAcctOppSyncHelper.paymentId=paymentId;//ApexPages.currentPage().getParameters().get('paymentId');
            
            InvoiceID = [select Name,Id,Document_Number__c,Account__r.Name,Total__c,Opportunity__c, Payment_Status__c,Amount_Due__c,Amount_Paid__c,Ship_Date__c,Account__r.id
                         from Sales_Invoice__c where Id=:ARUpdateKey];
            
            List<Intacct__c> Intact=[select id from Intacct__c where account__c=:InvoiceID[0].Account__c and Is_Parent__c=true and 
                                     Intacct_Response__c='Success' and type__c='Create Customer' limit 1];
            IntAcctOppSyncHelper.ARUpdateKey=InvoiceID[0].Document_Number__c;
            
            //CreateAccountReceivables(Id OppId,Id OppAccountId,Id IntacctId)
            IntAcctOppSyncHelper.ScheduleIntacct='CreatIntaact';
            IntAcctOppSyncHelper.CreateAccountReceivables(InvoiceID[0].Opportunity__c,InvoiceID[0].Account__c,Intact[0].id);
        }
        PageReference p = Page.apc_hf_schedule_payment_confirmation;
        p.getParameters().put('paymentTxId',ApexPages.currentPage().getParameters().get('paymentTxId'));
        p.getParameters().put('paymentDate',ApexPages.currentPage().getParameters().get('paymentDate'));
        p.setRedirect(true);
        return p;
        
    }
}