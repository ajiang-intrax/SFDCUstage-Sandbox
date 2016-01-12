public class PersonInfoHelper {

    public static void syncAccFields(Id accountId, Person_Info__c personInfo){
        
        Account a = [SELECT Id, Intrax_Programs__c, Intrax_Program_Options__c, Intrax_Region__c, Type, PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingCountry, personMailingPostalCode, Phone, FirstName, LastName, Gender__pc, PersonBirthDate, citizenship__pc, personEmail, PersonMobilePhone, Skype_id__pc, best_call_time__pc 
                        FROM Account 
                        WHERE Id =: accountId];
        
        a.FirstName = personInfo.First_Name__c;
        a.LastName = personInfo.Last_Name__c;
        a.Gender__pc = personInfo.gender__c;
        a.PersonBirthdate = personInfo.Date_Of_Birth__c;
        a.Citizenship__pc = personInfo.citizenship__c;
        a.PersonEmail = personInfo.Email__c;
        a.PersonMobilePhone = personInfo.Mobile__c;
        if(personInfo.Applicant_Info__r.Home_Phone__c == null || personInfo.Applicant_Info__r.Home_Phone__c == '') a.Phone = personInfo.Phone__c;
        a.Skype_ID__pc = personInfo.Skype_Id__c;
        a.Best_Call_Time__pc = personInfo.Best_Call_Time__c;
        
        try{
            upsert a;
        }catch(Exception e){
            system.debug('***** Impossible to sync Account and Person Info records: ' + e);
        }   
    }
    public static void syncLeadFields(Id LeadId, Person_Info__c personInfo){
        
        Lead l = [SELECT isConverted,ConvertedAccountId, Intrax_Programs__c, Intrax_Program_Options__c, Intrax_Region__c, Countries_of_Interest__c, Last_Applicant_Update__c, Lead_Type__c, 
                        Location_of_Interest__c, Functional_Areas__c, Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c, Desired_Start_Date__c, Street, City, State, Country, PostalCode, How_Heard__c, RB_First_Name__c, 
                        RB_Last_Name__c, Reason__c, Reason_Detail__c, Phone, Enquiry_Channel__c, FirstName, LastName, Gender__c, Date_of_Birth__c, Citizenship__c, Email, MobilePhone, Skype_Id__c, Best_Call_Time__c
                        FROM Lead WHERE Id =: leadId];
                        
        l.FirstName = personInfo.First_Name__c;
        l.LastName = personInfo.Last_Name__c;
        l.Gender__c = personInfo.gender__c;
        l.Date_of_Birth__c = personInfo.Date_Of_Birth__c;
        l.Citizenship__c = personInfo.citizenship__c;
        l.Email = personInfo.Email__c;
        l.MobilePhone = personInfo.Mobile__c;
        if(personInfo.Applicant_Info__r.Home_Phone__c == null || personInfo.Applicant_Info__r.Home_Phone__c != '') l.Phone = personInfo.Phone_Country_Code__c+'-'+personInfo.Phone__c;
        l.Skype_ID__c = personInfo.Skype_Id__c;
        l.Best_Call_Time__c = personInfo.Best_Call_Time__c;
        
        try{
            if(! l.isConverted) update l;
        }catch(Exception e){
            system.debug('***** Impossible to sync Lead and Person Info records: '+ e);
        }
    }
    
    public static void mapIntraxRegion_Residence(string residence, string appInfoId){
                        
        Account accnt = new Account();
        Applicant_Info__c appInfo= [SELECT Id, Intrax_Region__c,Account__c FROM Applicant_Info__c WHERE Id =: appInfoId LIMIT 1];
        if(appInfo!=null && appInfo.Account__c!=null)
        {
         accnt = [Select Id,Legal_Residence__pc FROM Account WHERE Id =: appInfo.Account__c];
         
        }
        
        if(accnt!=null && accnt.Id!=null)
        {
         accnt.Legal_Residence__pc = residence;
        }        
        if(residence != null || residence != ''){               
            List<Country_Region_Map__c> lstCountryRegionMap = Country_Region_Map__c.getall().values();
            string RegionMap;
            for( Country_Region_Map__c ObjCountryRegionMap:lstCountryRegionMap)
            {
            if (ObjCountryRegionMap.Intrax_Program__c == 'Internship' && ObjCountryRegionMap.Country__c == residence) {
              RegionMap = ObjCountryRegionMap.Region__c;
            }
            }
          if(appInfo!=null)
          appInfo.Intrax_Region__c = RegionMap;
            
        }else appInfo.Intrax_Region__c = '';
        try{
            update appInfo;
            if(accnt!=null && accnt.Id!=null)
            {
             update accnt;
            }
        }catch(Exception e){
            system.debug('***** Impossible to update Intrax Region: ' + e);
        }
    }
    public static void mapIntraxRegion_ResidenceForAllPgms(string residence, string appInfoId){
                        
        Account accnt = new Account();
        Applicant_Info__c appInfo= [SELECT Id, Intrax_Region__c,Account__c FROM Applicant_Info__c WHERE Id =: appInfoId LIMIT 1];
        if(appInfo!=null && appInfo.Account__c!=null)
        {
         accnt = [Select Id,Legal_Residence__pc FROM Account WHERE Id =: appInfo.Account__c];
         
        }
        
        try{
            if(accnt!=null && accnt.Id!=null)
            {
             accnt.Legal_Residence__pc = residence;            
             update accnt;  
            }                
         }catch(Exception e){
             system.debug('***** Impossible to update Intrax Region: ' + e);
         }
    }
}