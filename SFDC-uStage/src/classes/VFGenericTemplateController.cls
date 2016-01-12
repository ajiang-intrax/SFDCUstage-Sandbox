/**
 *   Description    :  This class is to handle fetch opportunity and related data
 * 
 *   Created Date  :  01/27/2012
 * 
 *   Revision Logs  :  V1.0 - Created  
 *
 **/ 
public without sharing class VFGenericTemplateController {

    //Capture the Opportunity Id
    public Id opportunityId {get; set;}
    
    //Getter Method for Opportunity
    public Opportunity getOpportunity() {
        
        List<Opportunity> listOpportunity = [SELECT Id, Name, Countries_of_Interest__c, Deadline__c, 
                                             Coordinator__c, Interviewer__c, OwnerID, AccountID, Account.Name, Account.FirstName, Account.Phone, Account.PersonEmail, 
                                             Coordinator__r.FirstName, Coordinator__r.LastName, Coordinator__r.Email, Coordinator__r.Phone, Coordinator__r.Territory__c,
                                             Interviewer__r.FirstName, Interviewer__r.LastName, Interviewer__r.Email, Interviewer__r.Phone, Interviewer__r.Territory__c,
                                             Owner.FirstName, Owner.LastName, Owner.Title, Owner.Email, Owner.Phone, Owner.CommunityNickname,
                                             Account.Casper_Id__c FROM Opportunity 
                                             WHERE ID =: opportunityId LIMIT 1];
        
        //Check for size of list
        if(listOpportunity.size()>0) { 
            return listOpportunity[0];
        }   
        else {
            //Return null
            return null;
        }
    }     
}