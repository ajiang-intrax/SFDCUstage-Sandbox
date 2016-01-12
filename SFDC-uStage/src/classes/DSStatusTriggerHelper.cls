/*
    Purpose         :   Helper class for Trigger_DSStatus.
                
    Created Date    :   04/16/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
                        
*/
public with sharing class DSStatusTriggerHelper{

    /**
    * Description   :   This method checks for all the DSStatus and update the related Applicant Info. 
    * @args         :   List of DSStatuses
    * @return       :   void
    */
    public static void updateApplicantInfoFk(List<dsfs__DocuSign_Status__c> lstDSStatus) {
        
        //Property to hold match related opportunities id
        Set<Id> statusIds = new Set<Id>();
        Person_Info__c personInfo=new Person_Info__c ();
       
        List<dsfs__DocuSign_Status__c> StatusesToBeUpdated = new List<dsfs__DocuSign_Status__c>();
      
        //loop through the matche and get the related id
        if(lstDSStatus!=null)
        {
        for(dsfs__DocuSign_Status__c status: lstDSStatus) {
         
            If (status.Person_Info__c != null && status.Applicant_Info__c == null) { 
            personInfo=[select Applicant_Info__c from Person_Info__c where id=:status.Person_Info__c ];             
            status.Applicant_Info__c = personInfo.Applicant_Info__c;
                  
            }
           
        }
        }
    
       } 
       }