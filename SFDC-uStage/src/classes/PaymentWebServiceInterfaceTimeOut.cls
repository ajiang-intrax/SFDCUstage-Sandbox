//Generated by wsdl2apex

public class PaymentWebServiceInterfaceTimeOut {
    public class encryptedPaymentTransactionResultDto {
        public String transactionId;
        public String success;
        public String[] errorsKeys;
        public String[] errorsDescriptions;
        public String paymentGateway;
        public String amountCharged;
        public String transactionDate;
        public String approvalCode;
        public String avsCode;
        public String currency_x;
        public String paymentType;
        private String[] transactionId_type_info = new String[]{'transactionId','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] success_type_info = new String[]{'success','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] errorsKeys_type_info = new String[]{'errorsKeys','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','-1','false'};
        private String[] errorsDescriptions_type_info = new String[]{'errorsDescriptions','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','-1','false'};
        private String[] paymentGateway_type_info = new String[]{'paymentGateway','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] amountCharged_type_info = new String[]{'amountCharged','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] transactionDate_type_info = new String[]{'transactionDate','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] approvalCode_type_info = new String[]{'approvalCode','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] avsCode_type_info = new String[]{'avsCode','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] currency_x_type_info = new String[]{'currency','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] paymentType_type_info = new String[]{'paymentType','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'transactionId','success','errorsKeys','errorsDescriptions','paymentGateway','amountCharged','transactionDate','approvalCode','avsCode','currency_x','paymentType'};
    }
    public class encryptedPaymentTransactionResultSetDto {
        public PaymentWebServiceInterfaceTimeOut.encryptedPaymentTransactionResultDto[] resultSet;
        private String[] resultSet_type_info = new String[]{'resultSet','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'resultSet'};
    }
    public class getTransactionStatus {
        public String transactionReferenceID;
        public String targetDate;
        public Boolean isTest;
        private String[] transactionReferenceID_type_info = new String[]{'transactionReferenceID','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] targetDate_type_info = new String[]{'targetDate','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] isTest_type_info = new String[]{'isTest','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'transactionReferenceID','targetDate','isTest'};
    }
    public class createCreditCardTransaction {
        public PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest createCreditCardTransactionRequest;
        public Boolean isTest;
        private String[] createCreditCardTransactionRequest_type_info = new String[]{'createCreditCardTransactionRequest','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] isTest_type_info = new String[]{'isTest','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'createCreditCardTransactionRequest','isTest'};
    }
    public class encryptedCreateCreditCardTransactionResponse {
        public PaymentWebServiceInterfaceTimeOut.encryptedPaymentTransactionResultSetDto createCreditCardTransactionResponse;
        private String[] createCreditCardTransactionResponse_type_info = new String[]{'createCreditCardTransactionResponse','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'createCreditCardTransactionResponse'};
    }
    public class createCreditCardTransactionRequest {
        public String transactionReferenceID;
        public String customerId;
        public Long cvNumber;
        public Double amount;
        public String currencyRef;
        public String businessUnitRef;
        public String productLineRef;
        public String userDefinedField1;
        public String userDefinedField2;
        public String userDefinedField3;
        public String userDefinedField4;
        public String comments;
        public String billingFirstName;
        public String billingLastName;
        public String billingEmail;
        public String billingStreet1;
        public String billingStreet2;
        public String billingCity;
        public String billingState;
        public String billingCountry;
        public String billingPostalCode;
        public String billingPhoneNumber;
        public String creditCardTypeRef;
        public String cardHolderName;
        public String accountNumber;
        public String expirationMonth;
        public String expirationYear;
        private String[] transactionReferenceID_type_info = new String[]{'transactionReferenceID','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] customerId_type_info = new String[]{'customerId','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] cvNumber_type_info = new String[]{'cvNumber','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] amount_type_info = new String[]{'amount','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] currencyRef_type_info = new String[]{'currencyRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] businessUnitRef_type_info = new String[]{'businessUnitRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] productLineRef_type_info = new String[]{'productLineRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField1_type_info = new String[]{'userDefinedField1','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField2_type_info = new String[]{'userDefinedField2','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField3_type_info = new String[]{'userDefinedField3','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField4_type_info = new String[]{'userDefinedField4','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] comments_type_info = new String[]{'comments','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] billingFirstName_type_info = new String[]{'billingFirstName','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingLastName_type_info = new String[]{'billingLastName','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingEmail_type_info = new String[]{'billingEmail','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingStreet1_type_info = new String[]{'billingStreet1','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingStreet2_type_info = new String[]{'billingStreet2','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] billingCity_type_info = new String[]{'billingCity','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingState_type_info = new String[]{'billingState','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] billingCountry_type_info = new String[]{'billingCountry','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingPostalCode_type_info = new String[]{'billingPostalCode','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingPhoneNumber_type_info = new String[]{'billingPhoneNumber','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] creditCardTypeRef_type_info = new String[]{'creditCardTypeRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] cardHolderName_type_info = new String[]{'cardHolderName','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] accountNumber_type_info = new String[]{'accountNumber','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] expirationMonth_type_info = new String[]{'expirationMonth','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] expirationYear_type_info = new String[]{'expirationYear','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'transactionReferenceID','customerId','cvNumber','amount','currencyRef','businessUnitRef','productLineRef','userDefinedField1','userDefinedField2','userDefinedField3','userDefinedField4','comments','billingFirstName','billingLastName','billingEmail','billingStreet1','billingStreet2','billingCity','billingState','billingCountry','billingPostalCode','billingPhoneNumber','creditCardTypeRef','cardHolderName','accountNumber','expirationMonth','expirationYear'};
    }
    public class paymentTransactionResultDto {
        public String transactionId;
        public Boolean success;
        public String[] errorsKeys;
        public String[] errorsDescriptions;
        public String paymentGateway;
        public Double amountCharged;
        public DateTime transactionDate;
        public String approvalCode;
        public String avsCode;
        public String currency_x;
        public String paymentType;
        private String[] transactionId_type_info = new String[]{'transactionId','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] success_type_info = new String[]{'success','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] errorsKeys_type_info = new String[]{'errorsKeys','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','-1','false'};
        private String[] errorsDescriptions_type_info = new String[]{'errorsDescriptions','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','-1','false'};
        private String[] paymentGateway_type_info = new String[]{'paymentGateway','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] amountCharged_type_info = new String[]{'amountCharged','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] transactionDate_type_info = new String[]{'transactionDate','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] approvalCode_type_info = new String[]{'approvalCode','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] avsCode_type_info = new String[]{'avsCode','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] currency_x_type_info = new String[]{'currency','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] paymentType_type_info = new String[]{'paymentType','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'transactionId','success','errorsKeys','errorsDescriptions','paymentGateway','amountCharged','transactionDate','approvalCode','avsCode','currency_x','paymentType'};
    }
    public class encryptedCreateCreditCardTransactionRequest {
        public String transactionReferenceID;
        public String customerId;
        public String cvNumber;
        public String amount;
        public String currencyRef;
        public String businessUnitRef;
        public String productLineRef;
        public String userDefinedField1;
        public String userDefinedField2;
        public String userDefinedField3;
        public String userDefinedField4;
        public String comments;
        public String billingFirstName;
        public String billingLastName;
        public String billingEmail;
        public String billingStreet1;
        public String billingStreet2;
        public String billingCity;
        public String billingState;
        public String billingCountry;
        public String billingPostalCode;
        public String billingPhoneNumber;
        public String creditCardTypeRef;
        public String cardHolderName;
        public String accountNumber;
        public String expirationMonth;
        public String expirationYear;
        private String[] transactionReferenceID_type_info = new String[]{'transactionReferenceID','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] customerId_type_info = new String[]{'customerId','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] cvNumber_type_info = new String[]{'cvNumber','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] amount_type_info = new String[]{'amount','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] currencyRef_type_info = new String[]{'currencyRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] businessUnitRef_type_info = new String[]{'businessUnitRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] productLineRef_type_info = new String[]{'productLineRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField1_type_info = new String[]{'userDefinedField1','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField2_type_info = new String[]{'userDefinedField2','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField3_type_info = new String[]{'userDefinedField3','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] userDefinedField4_type_info = new String[]{'userDefinedField4','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] comments_type_info = new String[]{'comments','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] billingFirstName_type_info = new String[]{'billingFirstName','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingLastName_type_info = new String[]{'billingLastName','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingEmail_type_info = new String[]{'billingEmail','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingStreet1_type_info = new String[]{'billingStreet1','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingStreet2_type_info = new String[]{'billingStreet2','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] billingCity_type_info = new String[]{'billingCity','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingState_type_info = new String[]{'billingState','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] billingCountry_type_info = new String[]{'billingCountry','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingPostalCode_type_info = new String[]{'billingPostalCode','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] billingPhoneNumber_type_info = new String[]{'billingPhoneNumber','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] creditCardTypeRef_type_info = new String[]{'creditCardTypeRef','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] cardHolderName_type_info = new String[]{'cardHolderName','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] accountNumber_type_info = new String[]{'accountNumber','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] expirationMonth_type_info = new String[]{'expirationMonth','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] expirationYear_type_info = new String[]{'expirationYear','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'transactionReferenceID','customerId','cvNumber','amount','currencyRef','businessUnitRef','productLineRef','userDefinedField1','userDefinedField2','userDefinedField3','userDefinedField4','comments','billingFirstName','billingLastName','billingEmail','billingStreet1','billingStreet2','billingCity','billingState','billingCountry','billingPostalCode','billingPhoneNumber','creditCardTypeRef','cardHolderName','accountNumber','expirationMonth','expirationYear'};
    }
    public class encryptedCreateCreditCardTransaction {
        public PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransactionRequest createCreditCardTransactionRequest;
        public Boolean isTest;
        private String[] createCreditCardTransactionRequest_type_info = new String[]{'createCreditCardTransactionRequest','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] isTest_type_info = new String[]{'isTest','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'createCreditCardTransactionRequest','isTest'};
    }
    public class getTransactionStatusResponse {
        public PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto createCreditCardTransactionResponse;
        private String[] createCreditCardTransactionResponse_type_info = new String[]{'createCreditCardTransactionResponse','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'createCreditCardTransactionResponse'};
    }
    public class paymentTransactionResultSetDto {
        public PaymentWebServiceInterfaceTimeOut.paymentTransactionResultDto[] resultSet;
        private String[] resultSet_type_info = new String[]{'resultSet','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'resultSet'};
    }
    public class createCreditCardTransactionResponse {
        public PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto createCreditCardTransactionResponse;
        private String[] createCreditCardTransactionResponse_type_info = new String[]{'createCreditCardTransactionResponse','http://www.intrax.com/internal/HostCompany/xsd/Payment/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/','false','false'};
        private String[] field_order_type_info = new String[]{'createCreditCardTransactionResponse'};
    }
    public class PaymentTransactionServicePort {
        //public String endpoint_x = 'http://srvvpc-app-dev.intraxinc.com:8080/epi-ws-server-0.0.2-SNAPSHOT/paymentTransactionService';
        public String endpoint_x = Global_Constants__c.getInstance().Payment_Service_Endpoint__c;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.intrax.com/internal/HostCompany/xsd/Payment/', 'PaymentWebServiceInterfaceTimeOut'};
        public PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto createCreditCardTransaction(PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionRequest createCreditCardTransactionRequest,Boolean isTest) {
            PaymentWebServiceInterfaceTimeOut.createCreditCardTransaction request_x = new PaymentWebServiceInterfaceTimeOut.createCreditCardTransaction();
            request_x.createCreditCardTransactionRequest = createCreditCardTransactionRequest;
            request_x.isTest = isTest;
            PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionResponse response_x;
            Map<String, PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionResponse> response_map_x = new Map<String, PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://www.intrax.com/internal/HostCompany/xsd/Payment/',
              'createCreditCardTransaction',
              'http://www.intrax.com/internal/HostCompany/xsd/Payment/',
              'createCreditCardTransactionResponse',
              'PaymentWebServiceInterfaceTimeOut.createCreditCardTransactionResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.createCreditCardTransactionResponse;
        }
        public PaymentWebServiceInterfaceTimeOut.paymentTransactionResultSetDto getTransactionStatus(String transactionReferenceID,String targetDate,Boolean isTest) {
            PaymentWebServiceInterfaceTimeOut.getTransactionStatus request_x = new PaymentWebServiceInterfaceTimeOut.getTransactionStatus();
            request_x.transactionReferenceID = transactionReferenceID;
            request_x.targetDate = targetDate;
            request_x.isTest = isTest;
            PaymentWebServiceInterfaceTimeOut.getTransactionStatusResponse response_x;
            Map<String, PaymentWebServiceInterfaceTimeOut.getTransactionStatusResponse> response_map_x = new Map<String, PaymentWebServiceInterfaceTimeOut.getTransactionStatusResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://www.intrax.com/internal/HostCompany/xsd/Payment/',
              'getTransactionStatus',
              'http://www.intrax.com/internal/HostCompany/xsd/Payment/',
              'getTransactionStatusResponse',
              'PaymentWebServiceInterfaceTimeOut.getTransactionStatusResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.createCreditCardTransactionResponse;
        }
        public PaymentWebServiceInterfaceTimeOut.encryptedPaymentTransactionResultSetDto encryptedCreateCreditCardTransaction(PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransactionRequest createCreditCardTransactionRequest,Boolean isTest) {
            PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransaction request_x = new PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransaction();
            request_x.createCreditCardTransactionRequest = createCreditCardTransactionRequest;
            request_x.isTest = isTest;
            PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransactionResponse response_x;
            Map<String, PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransactionResponse> response_map_x = new Map<String, PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransactionResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://www.intrax.com/internal/HostCompany/xsd/Payment/',
              'encryptedCreateCreditCardTransaction',
              'http://www.intrax.com/internal/HostCompany/xsd/Payment/',
              'encryptedCreateCreditCardTransactionResponse',
              'PaymentWebServiceInterfaceTimeOut.encryptedCreateCreditCardTransactionResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.createCreditCardTransactionResponse;
        }
    }
}