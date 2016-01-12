/*
Class: ApplicantProductWrapper

Description: 

*/
global class ApplicantProductWrapper implements Comparable {
	
	//properties
	public Boolean selected {get; set;}
	public Applicant_Info__c applicantInfo {get; set;}
	public Applicant_Product__c applicantProduct {get; set;}
	public Product2 product {get; set;}
    
    //Constructor
    public ApplicantProductWrapper(Boolean selected, Applicant_Info__c applicantInfo, Applicant_Product__c applicantProduct) {
        
    	//Set variables
    	this.selected = selected;
    	this.applicantInfo = applicantInfo;
    	this.applicantProduct = applicantProduct;
    }
    
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        
        // Cast argument to OpportunityWrapper
        ApplicantProductWrapper aPW = (ApplicantProductWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (applicantProduct.Sort_Order__c > aPW.applicantProduct.Sort_Order__c) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (applicantProduct.Sort_Order__c < aPW.applicantProduct.Sort_Order__c) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}