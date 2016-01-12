/**
 *  Description 	:  Payment Subscription Wrapper class to hold Subcription Payment/Retrieval related details
 * 
 *  Created By  	:   
 *
 *  Created Date	:   10-12-2015
 * 
 *  Revision Logs	:  	V1.0 - Created
 *                  
 **/
public class PaymentSubscriptionWrapper {
	
	//Properties
	public String cardType {get; set;}
	public String cardExpirationMonth {get; set;}
	public String cardExpirationYear {get; set;}
	public String ccNumber {get; set;}
    public String maskedCCNumber {get; set;} 
	public String cvvNumber {get; set;}
	public String bussinessReference {get; set;}
	public String currencyReference {get; set;}
	public String comments {get; set;}
	public Decimal amount {get; set;}
	public String promoCode {get; set;}
	public String txnId {get; set;}
    public Boolean Sucess {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    
    public String BillingStreet {get; set;}
    public String BillingStreet2 {get; set;}
    public String BillingCity {get; set;}
    public String BillingState {get; set;}
    public String BillingCountry {get; set;}
    public String BillingPostalCode {get; set;}
    public String BillingEmail{get; set;}
    
    
        
	
	//Constructor
	public PaymentSubscriptionWrapper() {
	
	}
}