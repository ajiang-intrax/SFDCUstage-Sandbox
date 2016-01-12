/**
 *  Description     :   Apex class to hold generic and utility like method helpful in callout of AWS Payment Web Service.
 * 
 *  Created By      :   
 * 
 *  Created Date    :   02/18/2014
 * 
 *  Revision Logs   :   V1.0 - Created
 *
**/
public class PaymentHelper {

    /**   
     *  @description    :   Method to check for Null and if yes, then return blank
     *
     *  @args           :   String value
     *
     *  @return         :   String
     *
    **/ 
    public static String parseNull(String value) {
        
        //Return blank if value is null
        if(value == null)
            return '';
        
        //return original value
        return value;
    }
    
    /**   
     *  @description    :   Method to validate Promo Code value on the following basis:-
     *                      1) If Promo Code not found
     *                              Error: We couldn’t find this promo code in our system. Please make sure to enter valid promo code.
     *                      2) If Promo Code in InActive
     *                              Error: This promo code is no longer valid.
     *
     *  @args           :   String value
     *
     *  @return         :   void
     *
    **/ 
    /*public static void validatePromoCode(String promoCode) {
        
        //Checking for user inputted Promo Code value for blank
        if(!String.isBlank(promoCode)) {
            //Retrieving Coupon Code records associated with same promo code value
            List<Coupon_Code__c> couponCodes = [Select ID, Is_Active__c FROM Coupon_Code__c WHERE Promo_Code__c != null AND Promo_Code__c != '' AND Promo_Code__c =: promoCode];
            
            //Checking list for size and null value. 
            //Add error If Promo Code is InActive
            if(couponCodes != null && couponCodes.size() > 0) {
                if(!couponCodes[0].Is_Active__c) {
                    //Adding Message and throwing error
                    throw new PaymentException(Label.ERROR_INACTIVE_PROMO_CODE);    
                }
            } else {
        
                //If Promo Code not found throw exception and then add message on page for user convinience
                //Adding Message and throwing error
                throw new PaymentException(Label.ERROR_UNKNOWN_PROMO_CODE); 
            }
        }
    }*/
    
    /**   
     *  @description    :   Method to apply discount over actual amount as given below:-
     *                          1) If couponCode.Discount__c field have non null value with it then apply that much discount over actaul amount
                                2) If couponCode.Discount__c field have null value with it then deduct Maximum_Discount_Amount__c value from actual value
     *
     *
     *  @args           :   Decimal applyDiscountsOverActualAmount, String promoCode
     *
     *  @return         :   Decimal
     *
    **/ 
    /*public static Decimal applyDiscountsOverActualAmount(Decimal applyDiscountsOverActualAmount, String promoCode) {
        
        //Retrieving Coupon Code records associated with same promo code value
        List<Coupon_Code__c> couponCodes = [Select ID, Maximum_Discount_Amount__c, Discount__c FROM Coupon_Code__c WHERE Promo_Code__c != null AND Promo_Code__c != '' AND Promo_Code__c =: promoCode];
        
        //Checking list for size and null value. 
        //Add error If Promo Code is InActive
        if(couponCodes != null && couponCodes.size() > 0) {
            
            //If couponCode.Discount__c field have non null value with it then apply that much discount over actaul amount
            if(couponCodes[0].Discount__c >= 0)
                applyDiscountsOverActualAmount = applyDiscountsOverActualAmount  -  ((applyDiscountsOverActualAmount * couponCodes[0].Discount__c)/100);
            else
                applyDiscountsOverActualAmount = applyDiscountsOverActualAmount - couponCodes[0].Maximum_Discount_Amount__c;
        }
        
        //Return update amount value
        return applyDiscountsOverActualAmount;
    }*/
    
    /**   
     *  @description    :   Method responsible for parsing of response retrived through "AWS Payment web service" callout.
     *
     *  @args           :   Payment__c payment, paymentScheduledWebServiceInterface.paymentTransactionResultSetDto paymentResponse
     *
     *  @return         :   Payment__c
     *
    **/ 
    public static Payment__c parseWebServiceResponse(Payment__c payment, paymentScheduledWebServiceInterface.paymentTransactionResultSetDto paymentResponse) {
        
        //Loop through result list retrived via making web service callout 
        if(paymentResponse != null) {
            
            //Loop through response retrieved results
            for (paymentScheduledWebServiceInterface.paymentTransactionResultDto resultSetDto : paymentResponse.resultSet) {
            
                //Setting Payment object fields values with the help of response retrived properties values
                payment.Txn_Id__c = resultSetDto.transactionId;
                payment.Sucess__c = resultSetDto.success;
                
                //Recording all the error messages (If any)
                String errorDes = '';
                
                if(resultSetDto.errorsDescriptions != null) {
                    for(String err : resultSetDto.errorsDescriptions)
                        errorDes += err;
                
                    payment.Error_Description__c = errorDes;
                }
                
                errorDes = '';
                
                //Loop through error keys
                if(resultSetDto.errorsKeys != null) {
                    for(String er : resultSetDto.errorsKeys) 
                        errorDes += er;
                    
                    payment.Error_Keys__c = errorDes;
                }
                    
                payment.Txn_Gateway__c = resultSetDto.paymentGateway;
                payment.Txn_Amount__c = resultSetDto.amountCharged;
                payment.Txn_Date__c = resultSetDto.transactionDate;
                payment.Payment_Type__c = resultSetDto.paymentType;
                payment.Txn_Code__c = resultSetDto.approvalCode;
                payment.AVS_Code__c = resultSetDto.avsCode;
                payment.Txn__c =  PaymentConstants.RESPONSE_RECEIVED_FROM_PAYMENT_SERVER 
                                    + PaymentConstants.TRANSACTION_ID + resultSetDto.transactionId 
                                    + PaymentConstants.SUCCESS_STATUS + resultSetDto.success 
                                    + PaymentConstants.APPROVAL_CODE + resultSetDto.approvalCode;
            }
        
            //Return Payment instance
            return payment;
        }           
        
        //Return null
        return null;
    }
    
    //SPILLAI-ENCRYPTION-CHANGES
    /**   
     *  @description    :   Method responsible for parsing of response retrived through "AWS Payment web service" callout.
     *
     *  @args           :   Payment__c payment, paymentScheduledWebServiceInterface.paymentTransactionResultSetDto paymentResponse
     *
     *  @return         :   Payment__c
     *
    **/ 
    public static Payment__c parseEncryptedWebServiceResponse(Payment__c payment, paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto paymentResponse) {
        
        //Loop through result list retrived via making web service callout 
        if(paymentResponse != null) {
            
            //Loop through response retrieved results
            for (paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultDto resultSetDto : paymentResponse.resultSet) {
            
                //Setting Payment object fields values with the help of response retrived properties values
                payment.Txn_Id__c = EncryptionDecryptionHandler.decrypt(resultSetDto.transactionId);
                
                If(EncryptionDecryptionHandler.decrypt(resultSetDto.success)=='1')
                payment.Sucess__c=True;
                
                //payment.Sucess__c = Boolean.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.success));
                system.debug('debug::success__c before conversion'+EncryptionDecryptionHandler.decrypt(resultSetDto.success));
                system.debug('debug::success__c'+payment.Sucess__c);
                
                //Recording all the error messages (If any)
                String errorDes = '';
             
                //Loop through error keys
                if(resultSetDto.errorsKeys != null) {
                    for(String er : resultSetDto.errorsKeys) 
                        errorDes += EncryptionDecryptionHandler.decrypt(er);
                    
                    payment.Error_Keys__c = errorDes;
                }
                
                String checkErrDes = '';
               if (payment.Error_Keys__c != null)
               {
                for(Error_Keys__c key :Error_Keys__c.getall().values())
                 if (key.Name == payment.Error_Keys__c)
                     checkErrDes =key.UI_Error_Message__c;               
               }
                System.debug('@@ checkErrDes' +checkErrDes);
                
                 errorDes = '';
                 if(resultSetDto.errorsDescriptions != null) {
                    for(String err : resultSetDto.errorsDescriptions)
                        errorDes += EncryptionDecryptionHandler.decrypt(err);
                
                    payment.Error_Description__c = checkErrDes;
                }
                    
                payment.Txn_Gateway__c = EncryptionDecryptionHandler.decrypt(resultSetDto.paymentGateway);
                payment.Txn_Amount__c = decimal.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.amountCharged));
                //String txDate = EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate);
                //matchAndReplace('-',resultSetDto.transactionDate.subString(11,18),':')
                system.debug('*****###resultSetDto.transactionDate: ' + resultSetDto.transactionDate);
                if(resultSetDto.transactionDate != null){
                //payment.Txn_Date__c = datetime.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate));
                payment.Txn_Date__c = system.now();//datetime.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate));
                system.debug('*****###payment.Txn_Date__c: ' + payment.Txn_Date__c);
                system.debug('*****###payment' + EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate));
                
                }
                payment.Payment_Type__c = EncryptionDecryptionHandler.decrypt(resultSetDto.paymentType);
                payment.Txn_Code__c = EncryptionDecryptionHandler.decrypt(resultSetDto.approvalCode);
                payment.AVS_Code__c = EncryptionDecryptionHandler.decrypt(resultSetDto.avsCode);
                payment.Txn__c =  PaymentConstants.RESPONSE_RECEIVED_FROM_PAYMENT_SERVER 
                                    + PaymentConstants.TRANSACTION_ID + EncryptionDecryptionHandler.decrypt(resultSetDto.transactionId) 
                                    + PaymentConstants.SUCCESS_STATUS + EncryptionDecryptionHandler.decrypt(resultSetDto.success) 
                                    + PaymentConstants.APPROVAL_CODE + EncryptionDecryptionHandler.decrypt(resultSetDto.approvalCode);
            }
        
            //Return Payment instance
            return payment;
        }           
        
        //Return null
        return null;
    }
    
     //Atif-ScheduledWebServiceInterface 
    /**   
     *  @description    :   Method responsible for parsing of response retrived through "AWS Payment web service" callout.
     *
     *  @args           :   Payment__c payment, paymentScheduledWebServiceInterface.encryptedCreateSubscriptionResponse CreateSubcriptionResponse
     *
     *  @return         :   Payment__c
     *
    **/ 
    public static payment_Subscription__c parseEncryptedWebServiceResponseToken(payment_Subscription__c paymentSubscription, paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse) {
        
        //Loop through result list retrived via making web service callout 
        if(paymentResponse != null) {
            
                //Setting Payment object fields values with the help of response retrived properties values
                paymentSubscription.Txn_Id__c = EncryptionDecryptionHandler.decrypt(paymentResponse.transactionId);
                
                If(EncryptionDecryptionHandler.decrypt(paymentResponse.success)=='1')
                paymentSubscription.Success__c=True;
                
                system.debug('debug::success__c before conversion'+EncryptionDecryptionHandler.decrypt(paymentResponse.success));
                //system.debug('debug::success__c'+paymentSubscription.Sucess__c);
                
                //Recording all the error messages (If any)
                String errorDes = '';
             
                //Loop through error keys
                if(paymentResponse.errorsKeys != null) {
                    for(String er : paymentResponse.errorsKeys) 
                        errorDes += EncryptionDecryptionHandler.decrypt(er);
                    
                    paymentSubscription.Error_Keys__c = errorDes;
                }
                
                String checkErrDes = '';
               if (paymentSubscription.Error_Keys__c != null)
               {
                for(Error_Keys__c key :Error_Keys__c.getall().values())
                 if (key.Name == paymentSubscription.Error_Keys__c)
                     checkErrDes =key.UI_Error_Message__c;               
               }
                System.debug('@@ checkErrDes' +checkErrDes);
                
                 errorDes = '';
                 if(paymentResponse.errorsDescriptions != null) {
                    for(String err : paymentResponse.errorsDescriptions)
                        errorDes += EncryptionDecryptionHandler.decrypt(err);
                
                    system.debug('debug:::'+errorDes);
                     paymentSubscription.Error_Description__c = checkErrDes;
                }
                    
                paymentSubscription.Txn_Gateway__c = EncryptionDecryptionHandler.decrypt(paymentResponse.paymentGateway);

                system.debug('*****###paymentResponse.transactionDate: ' + paymentResponse.transactionDate);
                if(paymentResponse.transactionDate != null){
                //payment.Txn_Date__c = datetime.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate));
                paymentSubscription.Txn_Date__c = system.now();//datetime.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate));
                system.debug('*****###paymentSubscription.Txn_Date__c: ' + paymentSubscription.Txn_Date__c);
                system.debug('*****###payment' + EncryptionDecryptionHandler.decrypt(paymentResponse.transactionDate));
                
                }
                //payment.Payment_Type__c = EncryptionDecryptionHandler.decrypt(paymentResponse.paymentType);
                paymentSubscription.Txn_Code__c = EncryptionDecryptionHandler.decrypt(paymentResponse.approvalCode);
                //payment.AVS_Code__c = EncryptionDecryptionHandler.decrypt(paymentResponse.avsCode);
                paymentSubscription.Txn_Result_Msg__c =  PaymentConstants.RESPONSE_RECEIVED_FROM_PAYMENT_SERVER 
                                    + PaymentConstants.TRANSACTION_ID + EncryptionDecryptionHandler.decrypt(paymentResponse.transactionId) 
                                    + PaymentConstants.SUCCESS_STATUS + EncryptionDecryptionHandler.decrypt(paymentResponse.success) 
                                    + PaymentConstants.APPROVAL_CODE + EncryptionDecryptionHandler.decrypt(paymentResponse.approvalCode);
                paymentSubscription.Encrypted_Token__c =paymentResponse.subscriptionID;
                system.debug('*****###UserInfo.getUserId== ' +UserInfo.getUserId());
                paymentSubscription.Txn_User__c=UserInfo.getUserId();
            	
            String ipAddress;
            //Setting defaults and memeory allocation to the variables related to Payment Process
            Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();   
            //Proceed further only and only if map of header parameter have not null value with it
            if(mapHeaders != null) {
                ipAddress = mapHeaders.get(PaymentConstants.TRUE_CLIENT_IP);
                if(ipAddress == null){
                    ipAddress = mapHeaders.get(PaymentConstants.X_SALESFORCE_SIP);
                }
            }
            paymentSubscription.IP_Address__c = ipAddress;
            
              return paymentSubscription;
        }           
        return null;
    }
  
  //Atif-ScheduledWebServiceInterface-PaymentResponse
    /**   
     *  @description    :   Method responsible for parsing of response retrived through "AWS Payment web service" callout.
     *
     *  @args           :   Payment__c payment, paymentScheduledWebServiceInterface.encryptedCreateSubscriptionResponse CreateSubcriptionResponse
     *
     *  @return         :   Payment__c
     *
    **/ 
    public static payment__c parseEncryptedWebServiceResponsePayment(payment__c payment, paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse) {
        
        //Loop through result list retrived via making web service callout 
        if(paymentResponse != null) {
            
            //Setting Payment object fields values with the help of response retrived properties values
            payment.Txn_Id__c = EncryptionDecryptionHandler.decrypt(paymentResponse.transactionId);
            
            If(EncryptionDecryptionHandler.decrypt(paymentResponse.success)=='1')
                payment.Sucess__c=True;
            
            system.debug('debug::success__c before conversion'+EncryptionDecryptionHandler.decrypt(paymentResponse.success));
            
            //Recording all the error messages (If any)
            String errorDes = '';
            
            //Loop through error keys
            if(paymentResponse.errorsKeys != null) {
                for(String er : paymentResponse.errorsKeys) 
                    errorDes += EncryptionDecryptionHandler.decrypt(er);
                
                payment.Error_Keys__c = errorDes;
            }
            
            String checkErrDes = '';
            if (payment.Error_Keys__c != null)
            {
                for(Error_Keys__c key :Error_Keys__c.getall().values())
                    if (key.Name == payment.Error_Keys__c)
                    checkErrDes =key.UI_Error_Message__c;               
            }
            System.debug('@@ checkErrDes' +checkErrDes);
            //system.debug('debug::InvalidDecimalError'+EncryptionDecryptionHandler.decrypt(paymentResponse.amountCharged));
            
            errorDes = '';
            if(paymentResponse.errorsDescriptions != null) {
                for(String err : paymentResponse.errorsDescriptions)
                    errorDes += EncryptionDecryptionHandler.decrypt(err);
                
                payment.Error_Description__c = checkErrDes;
                system.debug('debug:::AWSError'+errorDes);
            }
            payment.Txn_Gateway__c = EncryptionDecryptionHandler.decrypt(paymentResponse.paymentGateway);
            
            String ipAddress;
            //Setting defaults and memeory allocation to the variables related to Payment Process
            Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();   
            //Proceed further only and only if map of header parameter have not null value with it
            if(mapHeaders != null) {
                ipAddress = mapHeaders.get(PaymentConstants.TRUE_CLIENT_IP);
                if(ipAddress == null){
                    ipAddress = mapHeaders.get(PaymentConstants.X_SALESFORCE_SIP);
                }
            }
            
            system.debug('*****###paymentResponse.transactionDate: ' + paymentResponse.transactionDate);
            if(paymentResponse.transactionDate != null){
                payment.Txn_Amount__c = decimal.valueOf(EncryptionDecryptionHandler.decrypt(paymentResponse.amountCharged));
                //payment.Txn_Date__c = datetime.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate));
                payment.Txn_Date__c = system.now();//datetime.valueOf(EncryptionDecryptionHandler.decrypt(resultSetDto.transactionDate));
                system.debug('*****###payment' + EncryptionDecryptionHandler.decrypt(paymentResponse.transactionDate));
            }
            system.debug('*****###payment.paymentType: ' + EncryptionDecryptionHandler.decrypt(paymentResponse.paymentType));
            payment.IP_Address__c = ipAddress;
            payment.Payment_Type__c = EncryptionDecryptionHandler.decrypt(paymentResponse.paymentType);
            payment.Txn_Code__c = EncryptionDecryptionHandler.decrypt(paymentResponse.approvalCode);
            payment.AVS_Code__c = EncryptionDecryptionHandler.decrypt(paymentResponse.avsCode);
            payment.Txn__c =  PaymentConstants.RESPONSE_RECEIVED_FROM_PAYMENT_SERVER 
                + PaymentConstants.TRANSACTION_ID + EncryptionDecryptionHandler.decrypt(paymentResponse.transactionId) 
                + PaymentConstants.SUCCESS_STATUS + EncryptionDecryptionHandler.decrypt(paymentResponse.success) 
                + PaymentConstants.APPROVAL_CODE + EncryptionDecryptionHandler.decrypt(paymentResponse.approvalCode);
            
            //Return Payment instance
            return payment;
        }           
        
        return null;
    }
    
   
    //Atif-ScheduledWebServiceInterface-SubcriptionRetrieveResponse
    /**   
     *  @description    :   Method responsible for parsing of response retrived through "AWS Payment web service" callout.
     *
     *  @args           :   Payment__c payment, paymentScheduledWebServiceInterface.encryptedCreateSubscriptionResponse CreateSubcriptionResponse
     *
     *  @return         :   Payment__c
     *
    **/ 
    public static PaymentSubscriptionWrapper parseEncryptedWebServiceResponseRetrieve(PaymentSubscriptionWrapper PaySubsWrapper, paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse) {
        
        if(paymentResponse != null) {
                //Setting PaymentSubscriptionWrapper fields values with the help of response retrived properties values
                PaySubsWrapper.txnId = EncryptionDecryptionHandler.decrypt(paymentResponse.transactionId);
                
                If(EncryptionDecryptionHandler.decrypt(paymentResponse.success)=='1')
                PaySubsWrapper.Sucess=True;
                
               /* 
                //Recording all the error messages (If any)
                String errorDes = '';
                        
                //Loop through error keys
                if(paymentResponse.errorsKeys != null) {
                    for(String er : paymentResponse.errorsKeys) 
                        errorDes += EncryptionDecryptionHandler.decrypt(er);
                    
                    payment.Error_Keys__c = errorDes;
                }
                
                String checkErrDes = '';
               if (payment.Error_Keys__c != null)
               {
                for(Error_Keys__c key :Error_Keys__c.getall().values())
                 if (key.Name == payment.Error_Keys__c)
                     checkErrDes =key.UI_Error_Message__c;               
               }
                System.debug('@@ checkErrDes' +checkErrDes);
                
                 errorDes = '';
                 if(paymentResponse.errorsDescriptions != null) {
                    for(String err : paymentResponse.errorsDescriptions)
                        errorDes += EncryptionDecryptionHandler.decrypt(err);
                
                    payment.Error_Description__c = checkErrDes;
                }
            */
                //PaySubsWrapper.Txn_Gateway__c = EncryptionDecryptionHandler.decrypt(paymentResponse.paymentGateway);
                //payment.Txn_Date__c = system.now();
                //payment.Payment_Type__c = EncryptionDecryptionHandler.decrypt(paymentResponse.paymentType);
                //payment.Txn_Code__c = EncryptionDecryptionHandler.decrypt(paymentResponse.approvalCode);
                //payment.AVS_Code__c = EncryptionDecryptionHandler.decrypt(paymentResponse.avsCode);
                /*payment.Txn__c =  PaymentConstants.RESPONSE_RECEIVED_FROM_PAYMENT_SERVER 
                                    + PaymentConstants.TRANSACTION_ID + EncryptionDecryptionHandler.decrypt(paymentResponse.transactionId) 
                                    + PaymentConstants.SUCCESS_STATUS + EncryptionDecryptionHandler.decrypt(paymentResponse.success) 
                                    + PaymentConstants.APPROVAL_CODE + EncryptionDecryptionHandler.decrypt(paymentResponse.approvalCode); */
            
            system.debug('debug::success__c before conversion'+EncryptionDecryptionHandler.decrypt(paymentResponse.success));
            system.debug('*****###paymentResponse.transactionDate: ' + paymentResponse.transactionDate);
            PaySubsWrapper.ccNumber =EncryptionDecryptionHandler.decrypt(paymentResponse.subscriptionID);
            //PaySubsWrapper.cardType=EncryptionDecryptionHandler.decrypt(paymentResponse.paymentType);
            PaySubsWrapper.cardExpirationMonth=EncryptionDecryptionHandler.decrypt(paymentResponse.cardExpirationMonth);
            PaySubsWrapper.cardExpirationYear=EncryptionDecryptionHandler.decrypt(paymentResponse.cardExpirationYear);
            PaySubsWrapper.cardType=EncryptionDecryptionHandler.decrypt(paymentResponse.cardType);
            PaySubsWrapper.firstName=EncryptionDecryptionHandler.decrypt(paymentResponse.firstName);
            PaySubsWrapper.lastName=EncryptionDecryptionHandler.decrypt(paymentResponse.lastName);
            //PaySubsWrapper.maskedCCNumber='************' + PaySubsWrapper.ccNumber.subString(PaySubsWrapper.ccNumber.length()-4, PaySubsWrapper.ccNumber.length());
            system.debug('debug::payemnt response Credit Card number '+EncryptionDecryptionHandler.decrypt(paymentResponse.creditCardNumber));
            PaySubsWrapper.maskedCCNumber=EncryptionDecryptionHandler.decrypt(paymentResponse.creditCardNumber);
            
            //Return Payment instance
            return PaySubsWrapper;
        }           
        
        //Return null
        return null;
    }
    
    
    //Atif-ScheduledWebServiceInterface-DeleteSubscriptionResponse
    /**   
     *  @description    :   Method responsible for parsing of response retrived through "AWS Payment web service" callout.
     *
     *  @args           :   Payment__c payment, paymentScheduledWebServiceInterface.encryptedCreateSubscriptionResponse CreateSubcriptionResponse
     *
     *  @return         :   Payment__c
     *
    **/ 
    public static PaymentSubscriptionWrapper parseEncryptedWebServiceResponseDelete(PaymentSubscriptionWrapper PaySubsWrapper, paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse) {
        
        if(paymentResponse != null) {
                //Setting PaymentSubscriptionWrapper fields values with the help of response retrived properties values
                PaySubsWrapper.txnId = EncryptionDecryptionHandler.decrypt(paymentResponse.transactionId);
                
                If(EncryptionDecryptionHandler.decrypt(paymentResponse.success)=='1')
                PaySubsWrapper.Sucess=True;
            
            system.debug('debug::success__c before conversion'+EncryptionDecryptionHandler.decrypt(paymentResponse.success));
            system.debug('*****###paymentResponse.transactionDate: ' + paymentResponse.transactionDate);
            PaySubsWrapper.ccNumber =EncryptionDecryptionHandler.decrypt(paymentResponse.subscriptionID);
            PaySubsWrapper.cardType=EncryptionDecryptionHandler.decrypt(paymentResponse.paymentType);
            PaySubsWrapper.maskedCCNumber='************' + PaySubsWrapper.ccNumber.subString(PaySubsWrapper.ccNumber.length()-4, PaySubsWrapper.ccNumber.length());
            
            //Return Payment instance
            return PaySubsWrapper;
        }           
        
        //Return null
        return null;
    }
    
    
    public String matchAndReplace(String regEx,String sourceString, String replacementString){
        // First, instantiate a new Pattern object "MyPattern"
        pattern MyPattern = pattern.compile(regEx);
        
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(sourceString);
        
        // You can use the system static method assert to verify the match
        return MyMatcher.replaceAll(replacementString);
    }
    //SPILLAI-ENCRYPTION-CHANGES
}