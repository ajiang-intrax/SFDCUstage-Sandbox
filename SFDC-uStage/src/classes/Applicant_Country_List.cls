@RestResource(urlMapping='/GetApplicantCountryList/*')
global with sharing class Applicant_Country_List {
    
    @HttpGet
    global static List<String> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        if(res!=null)
        	res.addHeader('Content-Type', 'application/json');
        
        return doNothing();
       
    }
    
    global static List<String> doNothing() {
        
        List<String> countries = new List<String>();                
        Set<String> nationalitySubSet = new Set<String>();
    
        /*
        List<AggregateResult> countryList = [SELECT Country_of_Residence__c FROM Person_Info__c where Primary_Applicant__c = true and Role__c = 'Student' and Applicant_Info__r.Type__c = 'Participant' and Applicant_Info__r.Placement_Pending__c='YES' and Applicant_Info__r.Application_Stage__c= 'Accepted' and Applicant_Info__r.Intrax_Program_Options__c includes('Ayusa High School') and Country_of_Residence__c!=null  GROUP BY Country_of_Residence__c];        
        system.debug('***countryList*****'+countryList);
        for(AggregateResult a: countryList){            
            countries.add((String)a.get('Country_of_Residence__c'));
        }
        */
        List<Engagement__c> countryList = [SELECT Id,Name,Placement_Status__c, Status__c, Intrax_Program_Options__c, Intrax_Program__c,Nationality__c,Account_Id__r.Legal_Residence__pc FROM Engagement__c WHERE Intrax_Program__c ='Ayusa' and Intrax_Program_Options__c != 'Tomodachi' and (Status__c ='Processing' OR Status__c = 'Program Ready') and (Placement_Status__c = 'Not Placed' OR Placement_Status__c = 'Pending') AND Account_Id__r.Legal_Residence__pc!= null];
        if(countryList.size()>0){
        	for(Engagement__c e:countryList){
        		if(e.Account_Id__r.Legal_Residence__pc!=null && e.Account_Id__r.Legal_Residence__pc!='')
        			nationalitySubSet.add(e.Account_Id__r.Legal_Residence__pc);        			
        	}
        	countries.AddAll(nationalitySubSet);
            countries.sort();
        }
        
        return countries;
    
    }

}