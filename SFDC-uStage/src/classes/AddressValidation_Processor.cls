public with sharing class AddressValidation_Processor implements Database.AllowsCallouts {
	
    public String address1 {get; set;}
    public String address2 {get; set;}
    public String address3 {get; set;}
    public String address4 {get; set;}
    public String city {get; set;}
    public String state {get; set;}
    public String postalCode {get; set;}
    public String country {get; set;}
    public String status {get; set;}
    public String addInfo {get; set;}
    public String addressType{get;set;}
    public List<addressValidationService.address> potentialMatches {get; set;}
    public List<Map<String,String>> potentialMatchesList {get; set;}

    public AddressValidation_Processor(){
    	/*
      	 address1 = '600 California';
	     address2 = 'FL 10';
	     address3 = '';
	     address4 = '';
	     city = 'San Francisco';
	     state = 'CA';
	     postalCode = '94108';
	     country = 'United States';
	     status = 'Yet to be verified';
	     addInfo = '';
	    */
    }
    
    public pageReference verifyAddress(){
       	addressValidationService.AddressServicePort avs = new addressValidationService.AddressServicePort();
	    addressValidationService.address address = new addressValidationService.address();
	    addressValidationService.verificationResult avResult = new addressValidationService.verificationResult();
	    
	    potentialMatches =  new List<addressValidationService.address>();
	    potentialMatchesList = new List<Map<String,String>>();
	    
	    address.address1 = address1;
	    address.address2 = address2;
	    address.address3 = address3;
	    address.address4 = address4;
	    address.city = city;
	    address.state = state;
	    address.postalCode = postalCode;
	    address.country  = country;
	    
	    if(!test.isRunningTest()) avResult = avs.verifyAddress(address);
	    
	    status = avResult.status;
	    addInfo = avResult.additionalInfo;
	    potentialMatches = avResult.potentialMatch;
	    
	    if (potentialMatches != null){
	      	for (addressValidationService.address potentialMatch : potentialMatches){
		        map<String,String> potMatch = new map<String,String>();
		        potMatch.put('address1',potentialMatch.address1 );
		        potMatch.put('address2',potentialMatch.address2 );
		        potMatch.put('city',potentialMatch.city );
		        potMatch.put('state',potentialMatch.state );
		        potMatch.put('postalCode',potentialMatch.postalCode );
		        potMatch.put('country',potentialMatch.country );
		        potMatch.put('addressType',potentialMatch.addressType );
		        potentialMatchesList.add(potMatch);
		    }
	    }
	    system.debug(avResult);
	    return null;
     }
}