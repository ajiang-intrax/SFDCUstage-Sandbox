/**
 *  Description 	:   Wrapper class to hold Payment related details
 * 
 *  Created By  	:   
 *
 *  Created Date	:   03-06-2014
 * 
 *  Revision Logs	:  	V1.0 - Created
 *                  
 **/
public class PaymentWrapper {
	
	//Properties
	public String cardType {get; set;}
	public String cardExpirationMonth {get; set;}
	public String cardExpirationYear {get; set;}
	public String ccNumber {get; set;}
	public String cvvNumber {get; set;}
	public String bussinessReference {get; set;}
	public String currencyReference {get; set;}
	public String comments {get; set;}
	public Decimal amount {get; set;}
	public String promoCode {get; set;}
	public String txnId {get; set;}
	
	//Constructor
	public PaymentWrapper() {
	
	}
}