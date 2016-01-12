// ------------------------------------------------------------------------
// Class Definition - Controller associated to MyApplicationsComponent.component. Widget that displyas 
//                      a brief introduction to the user's current applications. For now, this component is only shown
//                      in the PT Dashboard page (PT_Home)
// 
// Version#   Date            Author                    Description
// -------------------------------------------------------------------------------------------
// 1.0        Dec-6-2012     Diego Gutierrez          Initial Version
// -------------------------------------------------------------------------------------------

public with sharing class myApplicationsController {
    // Variables definition
    private User activeUser;
    public List<Applicant_Info__c> applicantInfo {get;set;} 
    
    // Navigator: We need to pass the applicantInfo.Id
    public PageReference navigator(){
        
        PageReference P = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
        
        if (ApexPages.currentPage().getParameters().get('Id') != null){
               P.getParameters().put('Id',ApexPages.currentPage().getParameters().get('Id'));
        }
        
        P.setRedirect(true);
        return P;    
    }
    
    //Controller: we need to get all the application attached to the active user. 
    // For now, we are assuming that applicantInfo records contain a reference to an Account. In other case, it will be impossible
    // to get the necessary data. 
    // In further versions, it would be good to use sAccounts instead od Accounts.
    public myApplicationsController(){
        try{
            //User needs to be logged in:
            activeUser = [select Id, Intrax_Id__c, ContactId, Email, Name from User where Id = : userInfo.getUserId()];         
        }catch( Exception e){
            System.debug('Impossible to get the active user.');
        }
            if(activeUser.Id != NULL){
                // For now, applications are only tied to Accounts, NOT sAccounts
                Account accountInfo;
                try{
                    accountInfo = [SELECT Id, Name 
                                    FROM Account
                                    WHERE Id IN (SELECT AccountId FROM Contact WHERE Id =: activeUser.ContactId)];
                                    system.debug('*****accountInfo ******'+accountInfo );
                                    //WHERE Intrax_Id__c =: activeUser.Intrax_Id__c]; 
                    if(accountInfo.Name == 'Intrax Program Applicants'){
                        Person_Info__c personInfo = [Select Id, Email__c, Primary_Applicant__c, Applicant_Info__c, Name
                                                        From Person_Info__c 
                                                        Where Email__c =: activeUser.Email and Name =: activeUser.Name and Primary_Applicant__c =: true];
                        applicantInfo = [SELECT Id, Name, Application_Stage__c, Type__c,Application_Level__c, Intrax_Program_options__c, createdDate
                                            FROM Applicant_Info__c 
                                            WHERE Id =: personInfo.Applicant_Info__c];
                        
                    }
                    else{
                        // Then, we need the applications
                        // For now, limiting to the most recent one
                        applicantInfo = [SELECT Id, Name, Application_Stage__c, Type__c,Application_Level__c, Intrax_Program_options__c, createdDate
                                            FROM Applicant_Info__c 
                                            WHERE createdById =: activeUser.Id
                                            order by createdDate desc
                                            limit 1];
                    }
                     system.debug('*****applicantInfo ******'+applicantInfo );
                }catch(Exception e){
                    system.debug('**** No associated applications for this user');
                }
            }
    }
     
}