public without sharing class CSignatureGenerator {
    public List<Person_Info__c> personInfoList { get; set; }
    public string type { get; set; }

    public CSignatureGenerator () { type = ApexPages.currentPage().getParameters().get('type'); }
    
    public void getMembers(){
        string applicant_Info_Id = ApexPages.currentPage().getParameters().get('id');
        if (type == 'Agreement') {
            personInfoList = [SELECT Email__c, First_Name__c, Last_Name__c, Applicant_Info__c, ESSN__c
                              FROM Person_Info__c  
                              WHERE Applicant_Info__c =: applicant_Info_Id AND 
                              Role__c != 'School Official' AND Role__c != 'Teacher' AND Role__c != 'Reference' AND
                              Residency_Status__c != 'Lives Elsewhere' AND Age__c > 17];  
        }        
        else {
            personInfoList = [SELECT Email__c, First_Name__c, Last_Name__c, Applicant_Info__c, ESSN__c
                              FROM Person_Info__c  
                              WHERE Applicant_Info__c =: applicant_Info_Id AND 
                              Role__c != 'School Official' AND Role__c != 'Teacher' AND Role__c != 'Reference' AND
                              Residency_Status__c != 'Lives Elsewhere' AND Age__c > 17];
        }            
    }
}