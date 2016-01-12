/**
 *  Description     :   Apex class responsible to set request properties and then to process response of AWS Payment web service.
 * 
 *  Created By      :   
 * 
 *  Created Date    :   02/18/2014
 * 
 *  Revision Logs   :   V1.0 - Created
 *
**/
public class PaymentService {
    
    /**   
     *  @description    :   Method to invoke "AWS Payment Web Service" through parsed WSDL methods for getting credit card transaction details.
     *
     *  @args           :   Payment__c payment, Applicant_Info__c cardHolder, Person_Info__c personInfo, PaymentWrapper payWrapper
     *
     *  @return         :   paymentScheduledWebServiceInterface.paymentTransactionResultSetDto
     *
    **/ 
    public static paymentScheduledWebServiceInterface.paymentTransactionResultSetDto makeCreditCardTransactionRequest(Payment__c payment, Applicant_Info__c cardHolder, Person_Info__c personInfo, PaymentWrapper payWrapper) {
        
        //Variables to hold the AWS Payment Service response parameters 
        paymentScheduledWebServiceInterface.PaymentTransactionServicePort paymentInterface = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
        paymentScheduledWebServiceInterface.paymentTransactionResultSetDto paymentResponse =  new paymentScheduledWebServiceInterface.paymentTransactionResultSetDto();
        paymentScheduledWebServiceInterface.createCreditCardTransactionRequest paymentRequest = new paymentScheduledWebServiceInterface.createCreditCardTransactionRequest();
        
        //Setting Card Details
        paymentRequest.accountNumber = String.valueOf(payWrapper.ccNumber); 
        paymentRequest.expirationMonth = PaymentHelper.parseNull(String.valueOf(payWrapper.cardExpirationMonth));
        paymentRequest.expirationYear = PaymentHelper.parseNull(String.valueOf(payWrapper.cardExpirationYear));
        paymentRequest.cvNumber = Integer.valueOf(payWrapper.cvvNumber);
        paymentRequest.creditCardTypeRef = PaymentHelper.parseNull(payWrapper.cardType);
        paymentRequest.businessUnitRef = System.Label.PAYMENT_BUSSINESS_REF;
        paymentRequest.currencyRef = PaymentHelper.parseNull('USD');
        paymentRequest.amount = payWrapper.amount;
        paymentrequest.transactionReferenceID = PaymentHelper.parseNull(payment.Txn_Reference_Id__c);
        
        //Payment Billing Address Details
        paymentRequest.billingStreet1 = PaymentHelper.parseNull(payment.Billing_Street_1__c);
        paymentRequest.billingStreet2 = PaymentHelper.parseNull(payment.Billing_Street_2__c);
        paymentRequest.billingCity = PaymentHelper.parseNull(payment.Billing_City__c);
        paymentRequest.billingState = PaymentHelper.parseNull(payment.Billing_State__c);
        paymentRequest.billingCountry = PaymentHelper.parseNull(payment.Billing_Country__c);
        paymentRequest.billingPostalCode = PaymentHelper.parseNull(payment.Billing_Postal_Code__c);
        
        //Card Holder Details
        /*paymentRequest.cardHolderName =  personInfo.Name;
        paymentRequest.billingFirstName = PaymentHelper.parseNull(personInfo.First_Name__c);
        paymentRequest.billingLastName = PaymentHelper.parseNull(personInfo.Last_Name__c);
        paymentRequest.billingEmail = PaymentHelper.parseNull(personInfo.Email__c);
        paymentRequest.billingPhoneNumber = PaymentHelper.parseNull(personInfo.Phone__c);
        */
        
        paymentRequest.cardHolderName =  PaymentHelper.parseNull(payment.Billing_FirstName__c + payment.Billing_LastName__c);
        paymentRequest.billingFirstName = PaymentHelper.parseNull(payment.Billing_FirstName__c);
        paymentRequest.billingLastName = PaymentHelper.parseNull(payment.Billing_LastName__c);
        paymentRequest.billingEmail = PaymentHelper.parseNull(payment.Billing_Email__c);
        //paymentRequest.billingPhoneNumber = PaymentHelper.parseNull(personInfo.Phone__c);
        
        
        //Customer ID
        if(cardHolder.Casper_Id__c != null)
            //paymentRequest.customerId = Integer.valueOf(cardHolder.Casper_Id__c);
            paymentRequest.customerId = cardHolder.Casper_Id__c;
        
        //Try to make a web service callout
        try {
        
            //Web Service Callout to AWS Payment Service
            paymentResponse = paymentInterface.createCreditCardTransaction(paymentRequest,!Global_Constants__c.getInstance().CyberSource_Prod__c);        
            return paymentResponse;
        
        } catch (Exception e){
            IUtilities.sendExceptionEmail(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
    }
    
   
    
    //SPILLAI-ENCRYPTION-CHANGES
    /**   
     *  @description    :   Method to invoke "AWS Payment Web Service" through parsed WSDL methods for getting credit card transaction details.
     *
     *  @args           :   Payment__c payment, Applicant_Info__c cardHolder, Person_Info__c personInfo, PaymentWrapper payWrapper
     *
     *  @return         :   paymentScheduledWebServiceInterface.paymentTransactionResultSetDto
     *
    **/ 
    public static paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto makeEncryptedCreditCardTransactionRequest(Payment__c payment, Applicant_Info__c cardHolder, Person_Info__c personInfo, PaymentWrapper payWrapper) {
        
        
        
        system.debug('*****@@@ System.Label.PAYMENT_BUSSINESS_REF: ' + System.Label.PAYMENT_BUSSINESS_REF);
        system.debug('*****@@@ payment: ' + payment);
        
        //Variables to hold the AWS Payment Service response parameters 
        paymentScheduledWebServiceInterface.PaymentTransactionServicePort paymentInterface = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
        paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto paymentResponse =  new paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto();
        paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransactionRequest paymentRequest = new paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransactionRequest();
        //TIMEOUT Variables
        PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto paymentResponseTimeOut = new PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto();
        PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort paymentInterfaceTimeOut = new PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort();
        PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest paymentRequestTimeOut = new PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest();
               
        //Setting Card Details
        paymentRequest.accountNumber = EncryptionDecryptionHandler.encrypt(String.valueOf(payWrapper.ccNumber)); 
        paymentRequest.expirationMonth = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(String.valueOf(payWrapper.cardExpirationMonth)));
        paymentRequest.expirationYear = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(String.valueOf(payWrapper.cardExpirationYear)));
        paymentRequest.cvNumber = EncryptionDecryptionHandler.encrypt(payWrapper.cvvNumber);
        paymentRequest.creditCardTypeRef = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payWrapper.cardType));
        paymentRequest.businessUnitRef = EncryptionDecryptionHandler.encrypt(System.Label.PAYMENT_BUSSINESS_REF);
        paymentRequest.currencyRef = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull('USD'));
        //Commmenting this line and hardcodig the amount as cyber source is throwing error for certain amounts.
        if(Global_Constants__c.getInstance().CyberSource_Prod__c==false)
        	paymentRequest.amount = EncryptionDecryptionHandler.encrypt('1000');
        else
            paymentRequest.amount = EncryptionDecryptionHandler.encrypt(String.valueOf(payWrapper.amount));
        
        paymentrequest.transactionReferenceID = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Txn_Reference_Id__c));
        System.debug('@@@ Tranxnrefid @@@'+paymentrequest.transactionReferenceID);
        //Payment Billing Address Details
        paymentRequest.billingStreet1 = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_Street_1__c));
        paymentRequest.billingStreet2 = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_Street_2__c));
        paymentRequest.billingCity = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_City__c));
        paymentRequest.billingState = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_State__c));
        paymentRequest.billingCountry = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_Country__c));
        paymentRequest.billingPostalCode = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_Postal_Code__c));
        
        //Card Holder Details
        paymentRequest.cardHolderName =  EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_FirstName__c) + PaymentHelper.parseNull(payment.Billing_LastName__c));
        //paymentRequest.cardHolderName =  EncryptionDecryptionHandler.encrypt(personInfo.Name);
        /*
        paymentRequest.billingFirstName = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(personInfo.First_Name__c));
        paymentRequest.billingLastName = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(personInfo.Last_Name__c));
        paymentRequest.billingEmail = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(personInfo.Email__c));
        paymentRequest.billingPhoneNumber = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(personInfo.Phone__c));
        */
        paymentRequest.billingFirstName = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_FirstName__c));
        paymentRequest.billingLastName = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_LastName__c));
        paymentRequest.billingEmail = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_Email__c));
        //paymentRequest.billingPhoneNumber = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Billing_Phone__c));
        
        //Customer ID
        if(cardHolder.Casper_Id__c != null)
            paymentRequest.customerId = EncryptionDecryptionHandler.encrypt(String.valueOf(cardHolder.Casper_Id__c));
        
        //Try to make a web service callout
        try {
        
            //Web Service Callout to AWS Payment Service
            system.debug('*****@@@ paymentRequest: ' + paymentRequest);
           
            paymentResponse = paymentInterface.encryptedCreateCreditCardTransaction(paymentRequest,!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            
            system.debug('*****@@@ paymentResponse: ' + paymentResponse);
            return paymentResponse;
        
        }catch (System.CalloutException e){
        IUtilities.sendExceptionEmail(e);
        paymentResponseTimeOut = paymentInterfaceTimeOut.getTransactionStatus('payment.Txn_Reference_Id__c',string.valueOf(payment.Txn_Date__c),!Global_Constants__c.getInstance().CyberSource_Prod__c); 
        System.debug('ERROR:call out exception' + e);
          return null;
        }
         catch (Exception e){
             IUtilities.sendExceptionEmail(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            //ApexPages.addMessage(new ApexPages.Message();
            system.debug('*****@@@ Exception ' + e);
            return null;
        }
    }   
    

    //AALI-Schedule-CreateSubcription
    /**   
     *  @description    :   Method to invoke "AWS Schedule Payment Web Service" through parsed WSDL methods for getting credit card transaction details.
     *
     *  @args           :   Payment__c payment, Applicant_Info__c cardHolder, Person_Info__c personInfo, PaymentWrapper payWrapper
     *
     *  @return         :   paymentScheduledWebServiceInterface.createSubscriptionResponse
     *
    **/ 
    public static paymentScheduledWebServiceInterface.createSubscriptionResponse CreateSubcription(payment_Subscription__c payment, Applicant_Info__c cardHolder, PaymentSubscriptionWrapper PaySubsWrapper, PaymentWrapper payWrapper,Account acctObj) 
    {
        system.debug('*****@@@ System.Label.PAYMENT_BUSSINESS_REF: ' + System.Label.PAYMENT_BUSSINESS_REF);
        system.debug('*****@@@ payment: ' + payment);
        
        //Variables to hold the AWS Payment Service response parameters 
        paymentScheduledWebServiceInterface.PaymentTransactionServicePort paymentInterface = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        paymentScheduledWebServiceInterface.createSubscriptionRequest paymentRequest = new paymentScheduledWebServiceInterface.createSubscriptionRequest();
        //TIMEOUT Variables
        PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto paymentResponseTimeOut = new PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto();
        PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort paymentInterfaceTimeOut = new PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort();
        PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest paymentRequestTimeOut = new PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest();
               
        //Setting Card Details
        paymentRequest.accountNumber = EncryptionDecryptionHandler.encrypt(String.valueOf(payWrapper.ccNumber)); 
        paymentRequest.expirationMonth = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(String.valueOf(payWrapper.cardExpirationMonth)));
        paymentRequest.expirationYear = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(String.valueOf(payWrapper.cardExpirationYear)));
        paymentRequest.cvNumber = EncryptionDecryptionHandler.encrypt(payWrapper.cvvNumber);
        paymentRequest.creditCardTypeRef = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payWrapper.cardType));
        paymentRequest.businessUnitRef = EncryptionDecryptionHandler.encrypt(System.Label.PAYMENT_BUSSINESS_REF);
        paymentRequest.currencyRef = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull('USD'));
        paymentRequest.amount = EncryptionDecryptionHandler.encrypt('0');
        paymentRequest.transactionReferenceID = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Txn_Reference_Id__c));
        System.debug('@@@ Tranxnrefid @@@'+paymentrequest.transactionReferenceID);
        //Payment Billing Address Details
        paymentRequest.billingStreet1 = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(PaySubsWrapper.BillingStreet));
        paymentRequest.billingStreet2 = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(PaySubsWrapper.BillingStreet2));
        paymentRequest.billingCity = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(PaySubsWrapper.BillingCity));
        paymentRequest.billingState = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(PaySubsWrapper.BillingState));
        paymentRequest.billingCountry = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(PaySubsWrapper.BillingCountry));
        paymentRequest.billingPostalCode = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(PaySubsWrapper.BillingPostalCode));
        
        //Card Holder Details
        paymentRequest.cardHolderName =  EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(acctObj.FirstName) + PaymentHelper.parseNull(acctObj.LastName));
      
        paymentRequest.billingFirstName = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(acctObj.FirstName));
        paymentRequest.billingLastName = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(acctObj.LastName));
        paymentRequest.billingEmail = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(acctObj.PersonEmail));
                
        //Customer ID
        if(cardHolder.Casper_Id__c != null)
            paymentRequest.customerId = EncryptionDecryptionHandler.encrypt(String.valueOf(cardHolder.Casper_Id__c));
        
        //Try to make a web service callout
        try {
            //Web Service Callout to AWS Payment Service
            system.debug('*****@@@ paymentRequest: ' + paymentRequest);
            paymentResponse = paymentInterface.encryptedCreateSubscription(paymentRequest,!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            system.debug('*****@@@ paymentResponse: ' + paymentResponse);
            return paymentResponse;
        
        }catch (System.CalloutException e){
        IUtilities.sendExceptionEmail(e);
        paymentResponseTimeOut = paymentInterfaceTimeOut.getTransactionStatus('payment.Txn_Reference_Id__c',string.valueOf(payment.Txn_Date__c),!Global_Constants__c.getInstance().CyberSource_Prod__c); 
         System.debug('ERROR:call out exception' + e);
          return null;
        }
         catch (Exception e){
            IUtilities.sendExceptionEmail(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            system.debug('*****@@@ Exception ' + e);
            return null;
        }
    }
    
 
 //AALI-Schedule-Payment-CreateSubcriptionPayment
    /**   
     *  @description    :   Method to invoke "AWS Schedule Payment Web Service" through parsed WSDL methods for getting credit card transaction details.
     *
     *  @args           :   Payment__c payment, Applicant_Info__c cardHolder, PaymentWrapper payWrapper
     *
     *  @return         :   paymentScheduledWebServiceInterface.createSubscriptionResponse
     *
    **/
    
  public static paymentScheduledWebServiceInterface.createSubscriptionResponse CreateSubcriptionPayment(payment_Subscription__c SubscriptionId,payment__c payment, Applicant_Info__c cardHolder, PaymentWrapper payWrapper)
    {
        system.debug('*****@@@ System.Label.PAYMENT_BUSSINESS_REF: ' + System.Label.PAYMENT_BUSSINESS_REF);
        system.debug('*****@@@ payment: ' + payment);
        
        //Variables to hold the AWS Payment Service response parameters 
        paymentScheduledWebServiceInterface.PaymentTransactionServicePort paymentInterface = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        paymentScheduledWebServiceInterface.createSubscriptionRequest paymentRequest = new paymentScheduledWebServiceInterface.createSubscriptionRequest();
        //TIMEOUT Variables
        PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto paymentResponseTimeOut = new PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto();
        PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort paymentInterfaceTimeOut = new PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort();
        PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest paymentRequestTimeOut = new PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest();
               
        //Setting Card Details
        paymentRequest.businessUnitRef = EncryptionDecryptionHandler.encrypt(System.Label.PAYMENT_BUSSINESS_REF);
        paymentRequest.currencyRef = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull('USD'));
        if(Global_Constants__c.getInstance().CyberSource_Prod__c==false)
        	paymentRequest.amount = EncryptionDecryptionHandler.encrypt('1000');
        else
        	paymentRequest.amount = EncryptionDecryptionHandler.encrypt(String.valueOf(payWrapper.amount));
        
        //For 205 Error code is 1004.00 and For 204 Error Code is 1051.00
        //paymentRequest.amount = EncryptionDecryptionHandler.encrypt('1051.00');
        paymentRequest.transactionReferenceID = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Txn_Reference_Id__c));
        paymentRequest.subscriptionID = SubscriptionId.Encrypted_Token__c;
        System.debug('@@@ Tranxnrefid @@@'+paymentrequest.transactionReferenceID);

        //Customer ID
        if(cardHolder.Casper_Id__c != null)
            paymentRequest.customerId = EncryptionDecryptionHandler.encrypt(String.valueOf(cardHolder.Casper_Id__c));
        
        //Try to make a web service callout
        try {
            //Web Service Callout to AWS Payment Service
            system.debug('*****@@@ paymentRequest: ' + paymentRequest);
           
            paymentResponse = paymentInterface.encryptedSubscriptionPayment(paymentRequest,!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            
            system.debug('*****@@@ paymentResponse: ' + paymentResponse);
            return paymentResponse;
        
        }catch (System.CalloutException e){
        IUtilities.sendExceptionEmail(e);
        paymentResponseTimeOut = paymentInterfaceTimeOut.getTransactionStatus('payment.Txn_Reference_Id__c',string.valueOf(payment.Txn_Date__c),!Global_Constants__c.getInstance().CyberSource_Prod__c); 
         System.debug('ERROR:call out exception' + e);
          return null;
        }
         catch (Exception e){
            IUtilities.sendExceptionEmail(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            system.debug('*****@@@ Exception ' + e);
            return null;
        }
    }
    
     //AALI-RefundSubcription
    /**   
     *  @description    :   Method to invoke "AWS Schedule Payment Web Service" through parsed WSDL methods for getting credit card transaction details.
     *
     *  @args           :   Payment__c payment, Applicant_Info__c cardHolder, PaymentWrapper payWrapper
     *
     *  @return         :   paymentScheduledWebServiceInterface.createSubscriptionResponse
     *
    **/
    
  public static paymentScheduledWebServiceInterface.createSubscriptionResponse SubcriptionRefund(payment_Subscription__c SubscriptionId,payment__c payment, Applicant_Info__c cardHolder, PaymentWrapper payWrapper)
    {
        system.debug('*****@@@ System.Label.PAYMENT_BUSSINESS_REF: ' + System.Label.PAYMENT_BUSSINESS_REF);
        system.debug('*****@@@ payment: ' + payment);
        
        //Variables to hold the AWS Payment Service response parameters 
        paymentScheduledWebServiceInterface.PaymentTransactionServicePort paymentInterface = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        paymentScheduledWebServiceInterface.createSubscriptionRequest paymentRequest = new paymentScheduledWebServiceInterface.createSubscriptionRequest();
        //TIMEOUT Variables
        PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto paymentResponseTimeOut = new PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto();
        PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort paymentInterfaceTimeOut = new PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort();
        PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest paymentRequestTimeOut = new PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest();
               
        //Setting Card Details
        paymentRequest.businessUnitRef = EncryptionDecryptionHandler.encrypt(System.Label.PAYMENT_BUSSINESS_REF);
        paymentRequest.currencyRef = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull('USD'));
        Decimal refundAmount=payWrapper.amount;
        system.debug('debug::refundAmount.abs()==='+refundAmount.abs());
        if(Global_Constants__c.getInstance().CyberSource_Prod__c==false)
          paymentRequest.amount = EncryptionDecryptionHandler.encrypt('1000');
        else
        	paymentRequest.amount = EncryptionDecryptionHandler.encrypt(String.valueOf(refundAmount.abs()));
        
        paymentRequest.transactionReferenceID = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(payment.Txn_Reference_Id__c));
        paymentRequest.subscriptionID = SubscriptionId.Encrypted_Token__c;
        System.debug('@@@ Tranxnrefid @@@'+paymentrequest.transactionReferenceID);

        //Customer ID
        if(cardHolder.Casper_Id__c != null)
            paymentRequest.customerId = EncryptionDecryptionHandler.encrypt(String.valueOf(cardHolder.Casper_Id__c));
        
        //Try to make a web service callout
        try {
        
            //Web Service Callout to AWS Payment Service
            system.debug('*****@@@ paymentRequest: ' + paymentRequest);
            paymentResponse = paymentInterface.encryptedSubscriptionRefund(paymentRequest,!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            system.debug('*****@@@ paymentResponse: ' + paymentResponse);
            return paymentResponse;
        
        }catch (System.CalloutException e){
            IUtilities.sendExceptionEmail(e);
        paymentResponseTimeOut = paymentInterfaceTimeOut.getTransactionStatus('payment.Txn_Reference_Id__c',string.valueOf(payment.Txn_Date__c),!Global_Constants__c.getInstance().CyberSource_Prod__c); 
         System.debug('ERROR:call out exception' + e);
          return null;
        }
         catch (Exception e){
            IUtilities.sendExceptionEmail(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            system.debug('*****@@@ Exception ' + e);
            return null;
        }
    }
   
   //AALI-Schedule-Payment-CreateSubcriptionRetrieve
    /**   
     *  @description    :   Method to invoke "AWS Schedule Payment Web Service" through parsed WSDL methods for getting credit card transaction details.
     *
     *  @args           :   payment_Subscription__c payment
     *
     *  @return         :   paymentScheduledWebServiceInterface.createSubscriptionResponse
     *
    **/
    
  public static paymentScheduledWebServiceInterface.createSubscriptionResponse CreateSubcriptionRetrieve(List<Payment_Subscription__c> SubscriptionId)
    {
        system.debug('*****@@@ System.Label.PAYMENT_BUSSINESS_REF: ' + System.Label.PAYMENT_BUSSINESS_REF);
        
        //Variables to hold the AWS Payment Service response parameters 
        paymentScheduledWebServiceInterface.PaymentTransactionServicePort paymentInterface = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        paymentScheduledWebServiceInterface.createSubscriptionRequest paymentRequest = new paymentScheduledWebServiceInterface.createSubscriptionRequest();
        //TIMEOUT Variables
        PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto paymentResponseTimeOut = new PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto();
        PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort paymentInterfaceTimeOut = new PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort();
        PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest paymentRequestTimeOut = new PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest();
               
        //Setting Card Details
        paymentRequest.businessUnitRef = EncryptionDecryptionHandler.encrypt(System.Label.PAYMENT_BUSSINESS_REF);
        paymentRequest.transactionReferenceID = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(SubscriptionId[0].Txn_Reference_Id__c));
        paymentRequest.subscriptionID = SubscriptionId[0].Encrypted_Token__c;
        System.debug('@@@ Tranxnrefid @@@'+paymentrequest.transactionReferenceID);
        
        //Try to make a web service callout
        try {
            //Web Service Callout to AWS Payment Service
            system.debug('*****@@@ paymentRequest: ' + paymentRequest);
            paymentResponse = paymentInterface.encryptedSubscriptionRetrieve(paymentRequest,!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            system.debug('*****@@@ paymentResponse: ' + paymentResponse);
            return paymentResponse;
            
        }catch (System.CalloutException e){
            IUtilities.sendExceptionEmail(e);
            paymentResponseTimeOut = paymentInterfaceTimeOut.getTransactionStatus('SubscriptionId[0].Txn_Reference_Id__c',string.valueOf(SubscriptionId[0].Txn_Date__c),!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            System.debug('ERROR:call out exception' + e);
            return null;
        }
        catch (Exception e){
            IUtilities.sendExceptionEmail(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            system.debug('*****@@@ Exception ' + e);
            return null;
        }
    }
    
    //AALI-Schedule-Payment-Delete Subcription
    /**   
     *  @description    :   Method to invoke "AWS Schedule Payment Web Service" through parsed WSDL methods for getting credit card transaction details.
     *
     *  @args           :   payment_Subscription__c payment
     *
     *  @return         :   paymentScheduledWebServiceInterface.createSubscriptionResponse
     *
    **/
    
  public static paymentScheduledWebServiceInterface.createSubscriptionResponse DeleteSubscription(List<Payment_Subscription__c> SubscriptionId)
    {
        system.debug('*****@@@ System.Label.PAYMENT_BUSSINESS_REF: ' + System.Label.PAYMENT_BUSSINESS_REF);
        
        //Variables to hold the AWS Payment Service response parameters 
        paymentScheduledWebServiceInterface.PaymentTransactionServicePort paymentInterface = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        paymentScheduledWebServiceInterface.createSubscriptionRequest paymentRequest = new paymentScheduledWebServiceInterface.createSubscriptionRequest();
        //TIMEOUT Variables
        PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto paymentResponseTimeOut = new PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto();
        PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort paymentInterfaceTimeOut = new PaymentWebServiceInterfaceTimeOut.PaymentTransactionServicePort();
        PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest paymentRequestTimeOut = new PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest();
               
        //Setting Card Details
        paymentRequest.businessUnitRef = EncryptionDecryptionHandler.encrypt(System.Label.PAYMENT_BUSSINESS_REF);
        paymentRequest.transactionReferenceID = EncryptionDecryptionHandler.encrypt(PaymentHelper.parseNull(SubscriptionId[0].Txn_Reference_Id__c));
        paymentRequest.subscriptionID = SubscriptionId[0].Encrypted_Token__c;
        System.debug('@@@ Tranxnrefid @@@'+paymentrequest.transactionReferenceID);

        //Try to make a web service callout
        try {
            //Web Service Callout to AWS Payment Service
            system.debug('*****@@@ paymentRequest: ' + paymentRequest);
            paymentResponse = paymentInterface.encryptedSubscriptionDelete(paymentRequest,!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            system.debug('*****@@@ paymentResponse: ' + paymentResponse);
            return paymentResponse;
            
        }catch (System.CalloutException e){
            IUtilities.sendExceptionEmail(e);
            paymentResponseTimeOut = paymentInterfaceTimeOut.getTransactionStatus('SubscriptionId[0].Txn_Reference_Id__c',string.valueOf(SubscriptionId[0].Txn_Date__c),!Global_Constants__c.getInstance().CyberSource_Prod__c); 
            System.debug('ERROR:call out exception' + e);
            return null;
        }
        catch (Exception e){
            IUtilities.sendExceptionEmail(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            system.debug('*****@@@ Exception ' + e);
            return null;
        }
    }
    
}