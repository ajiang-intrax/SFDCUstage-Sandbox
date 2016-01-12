public class ApplicantInfoHelper {

    private static boolean alreadyCloningUpdated = false;

    public static boolean hasalreadyCloningUpdated () 
    {
        return alreadyCloningUpdated;
    }
    
    public static void setalreadyCloningUpdated() 
    {
        alreadyCloningUpdated = true;
    }
    
    private static boolean alreadySyncedFields = false;

    public static boolean hasalreadySyncedFields () 
    {
        return alreadySyncedFields;
    }
    
    public static void setalreadySyncedFields() 
    {
        alreadySyncedFields = true;
    }
    
  /*  private static boolean syncWTRepeatAppFields = false;

    public static boolean hasWTRepeatAppSyncedFields() 
    {
        return syncWTRepeatAppFields;
    }
    
    public static void setWTRepeatAppSyncedFields() 
    {
        syncWTRepeatAppFields = true;
    }*/
    public static Applicant_Info__c setApp_IntraxRegion_and_Market(Applicant_Info__c applicantInfo, string pName){
       if(pName == null){
            applicantInfo.Intrax_Region__c = 'United States';
        }else if(pName == 'Intrax Canada') applicantInfo.Intrax_Region__c = 'Canada';
        else if(pName == 'Intrax Chile') applicantInfo.Intrax_Region__c = 'Chile';
        else if(pName == 'Ayusa Germany') {
            applicantInfo.Intrax_Region__c = 'Europe';
            applicantInfo.Intrax_Market__c = 'Germany';
        }else if(pName == 'Intrax Brazil') {
            applicantInfo.Intrax_Region__c = 'United States';
            applicantInfo.Intrax_Market__c = 'Brazil';
        }else if(pName == 'Intrax Turkey') {
            applicantInfo.Intrax_Region__c = 'Europe';
            applicantInfo.Intrax_Market__c = 'Turkey';
        }else if(pName == 'Intrax France'){
            applicantInfo.Intrax_Region__c = 'Europe';
            applicantInfo.Intrax_Market__c = 'France';
        }else if(pName == 'Intrax Japan'){
            applicantInfo.Intrax_Region__c = 'Japan';
        }else if(pName == 'Intrax Korea'){
            applicantInfo.Intrax_Region__c = 'Korea';
        }else if(pName == 'Intrax Peru'){
            applicantInfo.Intrax_Region__c = 'Peru';
        }else if(pName == 'Intrax Singapore'){
            applicantInfo.Intrax_Region__c = 'Singapore';
        }else{
            applicantInfo.Intrax_Region__c = 'United States';
            applicantInfo.Intrax_Market__c = 'Partner';
        }
     
       return applicantInfo;
      }
      
      //B-03166
     
      public static Applicant_Info__c setApp_IntraxRegion_and_MarketForPT(Applicant_Info__c applicantInfo)
      {
        List<Account> BusAcc = new List<Account>();
        if(applicantInfo.Partner_Intrax_Id__c == null || applicantInfo.Partner_Intrax_Id__c == '') 
           {
            applicantInfo.Intrax_Region__c = 'United States';
           }
          else
           { 
            BusAcc = [SELECT Id, Intrax_Market__c,Intrax_Region__c,Name, type, Intrax_Id__c FROM Account WHERE Intrax_Id__c =: applicantInfo.Partner_Intrax_Id__c AND type = 'Partner'];
            if(BusAcc!=null && BusAcc.size()>0)
            {
             applicantInfo.Intrax_Market__c = BusAcc[0].Intrax_Market__c;
             applicantInfo.Intrax_Region__c = BusAcc[0].Intrax_Region__c;
             system.debug('hiiiii');
            }
           } 
       return applicantInfo;
      }
     
      public static void setApp_IntrxRegion_and_MktForPT(Applicant_Info__c applicantInfo)
      {
        List<Account> BusAcc = new List<Account>();
        if(applicantInfo.Partner_Intrax_Id__c == null || applicantInfo.Partner_Intrax_Id__c == '') 
           {
            applicantInfo.Intrax_Region__c = 'United States';
           }
          else
           { 
            BusAcc = [SELECT Id, Intrax_Market__c,Intrax_Region__c,Name, type, Intrax_Id__c FROM Account WHERE Intrax_Id__c =: applicantInfo.Partner_Intrax_Id__c AND type = 'Partner'];
            if(BusAcc!=null && BusAcc.size()>0)
            {
             applicantInfo.Intrax_Market__c = BusAcc[0].Intrax_Market__c;
             applicantInfo.Intrax_Region__c = BusAcc[0].Intrax_Region__c;
             system.debug('hiiiii');
            }
           } 
           update applicantInfo;
          
        }
      
      //B-03166
    
    public static void syncOppFields(Id oppId, Applicant_Info__c applicantInfo){
        Opportunity opp = [select Id,RecordTypeId,Name,StageName, isClosed, Type, Intrax_Programs__c, AccountId, Intrax_Program_Options__c, Intrax_Region__c, Countries_of_Interest__c, Last_Applicant_Update__c, 
                            Location_of_Interest__c, Functional_Areas__c, Position_Types__c, Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c, Engagement_Start__c, Engagement_End__c, How_Heard__c, 
                            RB_First_Name__c, RB_Last_Name__c, Reason__c, Reason_Detail__c, Enquiry_Channel__c, Partner_Account__c, Application_Date__c
                            from Opportunity
                            Where Id =: oppId];
                            
        opp.Intrax_Programs__c = applicantInfo.Intrax_Program__c;
        if(applicantInfo.Intrax_Program_Options__c != null && applicantInfo.Intrax_Program_Options__c != '')//B-03197
        {
         opp.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
        }
        opp.Intrax_Program_Category__c = applicantInfo.Intrax_Program_Category__c ;
        opp.Type = applicantInfo.Type__c;
        if((applicantInfo.Intrax_Program__c == 'AuPairCare' || applicantInfo.Intrax_Program__c == 'Ayusa') && applicantInfo.Type__c == 'Participant')
        { 
          //B-03337
          opp.Application_Date__c = applicantInfo.Submitted_Date__c;
            
          if(applicantInfo.Intrax_Region__c!=null && applicantInfo.Partner_Intrax_Id__c!=null)
          {
           opp.Intrax_Region__c = applicantInfo.Intrax_Region__c;
          }
        }
        else
        {
         opp.Intrax_Region__c = applicantInfo.Intrax_Region__c;
        }
        opp.Countries_of_Interest__c = applicantInfo.Country_of_Interest__c;
       
        opp.Last_Applicant_Update__c = applicantInfo.Last_Applicant_Update__c;
        opp.Projects_of_Interest__c = applicantInfo.Projects_of_Interest__c;
        opp.Functional_Areas__c = applicantInfo.Functional_Areas__c;
        opp.Position_Types__c = applicantInfo.Position_Types__c;
        opp.Intrax_Center__c = applicantInfo.Intrax_Center__c;
        opp.Program_Start__c = applicantInfo.Program_Start__c;
        
        //B-02452
       /* if(applicantInfo.Intrax_Program__c != 'Ayusa' && applicantInfo.Type__c != 'Participant'){
        opp.Program_Year__c = applicantInfo.Program_Year__c;
        }//B-02452 .. AP*/
        if(!(applicantInfo.Intrax_Program__c == 'Work Travel' || (applicantInfo.Intrax_Program__c == 'Ayusa' && applicantInfo.Type__c == 'Participant'))){
            opp.Engagement_Start__c = applicantInfo.Engagement_Start__c;
            opp.Engagement_End__c = applicantInfo.Engagement_End__c;
        }
        opp.How_Heard__c = applicantInfo.How_Heard__c;
        opp.RB_First_Name__c = applicantInfo.RB_First_Name__c;
        opp.RB_Last_Name__c = applicantInfo.RB_Last_Name__c;
        opp.Reason__c = applicantInfo.Reason__c;
        opp.Reason_Detail__c = applicantInfo.Reason_Detail__c;
        opp.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;
        // IGI 640
        opp.Partner_Account__c = applicantInfo.Partner_Account__c;
       if(applicantInfo.Intrax_Program__c == 'Ayusa' && applicantInfo.Type__c =='Participant' && applicantInfo.Partner_Intrax_Id__c != 'I-0000283'){
            opp.Program_Duration__c = applicantInfo.Program_Duration__c;
            opp.Program_Year__c = applicantInfo.Program_Year__c; 
        }
       
        else if(applicantInfo.Intrax_Program__c != 'Ayusa'|| applicantInfo.Type__c !='Participant')
        {
           opp.Program_Duration__c = applicantInfo.Program_Duration__c;
           opp.Program_Year__c = applicantInfo.Program_Year__c; 
           opp.Service_Level__c = applicantInfo.Service_Level__c;
           opp.Location_of_Interest__c = applicantInfo.Location_of_Interest__c;
        }

        try{
            update opp;
        }catch(Exception e){
            system.debug('***** Impossible to sync opp fields: ' + e);
        }
        
    }

    public static void syncLeadFields (Lead l, Applicant_Info__c applicantInfo){
        setalreadySyncedFields();
        /*
        Lead l = [SELECT isConverted,ConvertedAccountId, Intrax_Programs__c, Intrax_Program_Options__c, Intrax_Region__c, Countries_of_Interest__c, Last_Applicant_Update__c, Lead_Type__c, 
                        Location_of_Interest__c, Functional_Areas__c, Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c, Desired_Start_Date__c, Street, City, State, Country, PostalCode, How_Heard__c, RB_First_Name__c, 
                        RB_Last_Name__c, Reason__c, Reason_Detail__c, Phone, Enquiry_Channel__c, FirstName, LastName, Gender__c, Date_of_Birth__c, Citizenship__c, Email, MobilePhone, Skype_Id__c, Best_Call_Time__c
                        FROM Lead WHERE Id =: leadId];
        
        Applicant_Info__c applicantInfo = [SELECT Id, Intrax_Program__c, Intrax_Program_Options__c, Intrax_Region__c, Country_of_Interest__c, Last_Applicant_Update__c, Type__c, 
                                            Location_of_Interest__c, Functional_Areas__c, Intrax_Center__c, Service_Level__c, Program_Start__c, Program_Duration__c, Program_Year__c, Engagement_Start__c, Engagement_End__c, Home_Street_1__c, Home_City__c, Home_State__c, Home_Country__c, Home_Postal_Code__c, How_Heard__c, RB_First_Name__c, 
                                            RB_Last_Name__c, Reason__c, Reason_Detail__c, Home_Phone__c, Enquiry_Channel__c, First_Name__c, Last_Name__c, Date_of_Birth__c, Projects_of_Interest__c
                                            FROM Applicant_Info__c WHERE Id =: applicantInfoId];
        */  
        
        /*                                      
        Person_Info__c personInfo = [SELECT Id, First_Name__c, Last_Name__c, Gender__c, Date_Of_Birth__c, Citizenship__c, email__c, Mobile__c, Phone__c, Skype_Id__c, Best_call_Time__c, Applicant_Info__c 
                                                FROM Person_Info__c 
                                                WHERE Applicant_Info__c =: applicantInfo.Id and Primary_Applicant__c =: true LIMIT 1];
        */
        l.Intrax_Programs__c = applicantInfo.Intrax_Program__c;
        if(applicantInfo.Intrax_Program__c != 'AuPairCare' && applicantInfo.Type__c != 'Participant')//B-03197
        {
         l.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
        } 
        l.Lead_Type__c = applicantInfo.Type__c;
        l.Intrax_Region__c = applicantInfo.Intrax_Region__c;
        l.Countries_of_Interest__c = applicantInfo.Country_of_Interest__c;
        l.Last_Applicant_Update__c = applicantInfo.Last_Applicant_Update__c;
        l.Location_of_Interest__c = applicantInfo.Location_of_Interest__c;
        l.Projects_of_Interest__c   = applicantInfo.Projects_of_Interest__c;
        l.Functional_Areas__c = applicantInfo.Functional_Areas__c;
        l.Intrax_Center__c = applicantInfo.Intrax_Center__c;
        l.Service_Level__c = applicantInfo.Service_Level__c;
        l.Program_Start__c = applicantInfo.Program_Start__c;
        l.Program_Duration__c = applicantInfo.Program_Duration__c;
        l.Program_Year__c   = applicantInfo.Program_Year__c;
        l.Intrax_Program_Category__c  = applicantInfo.Intrax_Program_Category__c ;
        if(!(applicantInfo.Intrax_Program__c == 'Work Travel' || (applicantInfo.Intrax_Program__c == 'Ayusa' && applicantInfo.Type__c == 'Participant'))){
            l.Desired_Start_Date__c = applicantInfo.Engagement_Start__c;
        }
    l.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + '\r\n' + applicantInfo.Home_Street_2__c;
        l.City = applicantInfo.Home_City__c;
        l.State = applicantInfo.Home_State__c;
        l.PostalCode = applicantInfo.Home_Postal_Code__c;
        //excluding for IGI. B-01513
        if(!(applicantInfo.RecordTypeId==Constants.ICD_Intern_PT_Record_Type_Id && applicantInfo.Application_Level__c == 'Basic'))
        {
            l.Country = applicantInfo.Home_Country__c;
        }
        l.How_Heard__c = applicantInfo.How_Heard__c;
        l.RB_First_Name__c = applicantInfo.RB_First_Name__c;
        l.RB_Last_Name__c = applicantInfo.RB_Last_Name__c;
        l.Reason__c = applicantInfo.Reason__c;
        l.Reason_Detail__c = applicantInfo.Reason_Detail__c;
        l.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;
        if(applicantInfo.Home_Phone__c != null && applicantInfo.Home_Phone__c != '') l.Phone = applicantInfo.Home_Phone__c;
        /*
        l.FirstName = personInfo.First_Name__c;
        l.LastName = personInfo.Last_Name__c;
        l.Gender__c = personInfo.gender__c;
        l.Date_of_Birth__c = personInfo.Date_Of_Birth__c;
        l.Citizenship__c = personInfo.citizenship__c;
        l.Email = personInfo.Email__c;
        l.MobilePhone = personInfo.Mobile__c;
        if(applicantInfo.Home_Phone__c != null && applicantInfo.Home_Phone__c != '') l.Phone = applicantInfo.Home_Phone__c;
        else l.Phone = personInfo.Phone__c;
        l.Skype_ID__c = personInfo.Skype_Id__c;
        l.Best_Call_Time__c = personInfo.Best_Call_Time__c;
        */
        
        try{
            if(!l.IsConverted) update l;
        }catch(Exception e){
            system.debug('***** Impossible to sync Lead fields: ' + e);
        }
    }

    public static void syncAccountFields (Id accountId, Applicant_Info__c applicantInfo){
        Account a = [SELECT Id, Intrax_Programs__c, Intrax_Program_Options__c, Intrax_Region__c, Type, 
                            PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingCountry, personMailingPostalCode, 
                            ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode,
                            BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,
                            Phone, FirstName, LastName, Gender__pc, PersonBirthDate, citizenship__pc, personEmail, PersonMobilePhone, Skype_id__pc, best_call_time__pc 
                        FROM Account 
                        WHERE Id =: accountId];
        /*
        Person_Info__c personInfo = [SELECT Id, First_Name__c, Last_Name__c, Gender__c, Date_Of_Birth__c, Citizenship__c, email__c, Mobile__c, Phone__c, Skype_Id__c, Best_call_Time__c, Applicant_Info__c 
                                                FROM Person_Info__c 
                                                WHERE Applicant_Info__c =: applicantInfo.Id and Primary_Applicant__c =: true LIMIT 1];              
        */
        // Fields from applciant_Info__c
        a.Intrax_Programs__c = applicantInfo.Intrax_Program__c;
        a.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
        a.Type = applicantInfo.Type__c;
        a.Intrax_Program_Category__c  = applicantInfo.Intrax_Program_Category__c ;
        if((applicantInfo.Intrax_Program__c == 'AuPairCare' || applicantInfo.Intrax_Program__c == 'Ayusa') && applicantInfo.Type__c == 'Participant')
         {
          if(applicantInfo.Intrax_Region__c!=null && applicantInfo.Partner_Intrax_Id__c!=null)
          {
           a.Intrax_Region__c = applicantInfo.Intrax_Region__c;
          }
         }
        else 
         {
          a.Intrax_Region__c = applicantInfo.Intrax_Region__c;
         }
        a.PersonMailingStreet = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + '\r\n' + applicantInfo.Home_Street_2__c;
        a.PersonMailingCity  = applicantInfo.Home_City__c;
        if(applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Type__c == 'Participant'){
        a.PersonMailingState = applicantInfo.State__c;
        }else{
        a.PersonMailingState = applicantInfo.Home_State__c;
        }
        a.PersonMailingPostalCode = applicantInfo.Home_Postal_Code__c;
        a.PersonMailingCountry = applicantInfo.Home_Country__c;
        if(applicantInfo.Home_Phone__c != null && applicantInfo.Home_Phone__c != '') a.Phone = applicantInfo.Home_Phone__c;
        // Fields from Person_Info__c
        /*
        a.FirstName = personInfo.First_Name__c;
        a.LastName = personInfo.Last_Name__c;
        a.Gender__pc = personInfo.gender__c;
        a.PersonBirthdate = personInfo.Date_Of_Birth__c;
        a.Citizenship__pc = personInfo.citizenship__c;
        a.PersonEmail = personInfo.Email__c;
        a.PersonMobilePhone = personInfo.Mobile__c;
        if(applicantInfo.Home_Phone__c != null && applicantInfo.Home_Phone__c != '') a.Phone = applicantInfo.Home_Phone__c;
        else a.Phone = personInfo.Phone__c;
        a.Skype_ID__pc = personInfo.Skype_Id__c;
        a.Best_Call_Time__pc = personInfo.Best_Call_Time__c;
        */
        System.debug('Before populating APCHF shipping and Billing Address');
        //For APC Host Family, copy the host family address as billing address and Shipping address.
        if(applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Type__c == 'Host Family')
        {
            System.debug('inside  APCHF shipping and Billing Address');
            //Person Account Shipping Address.
            a.ShippingStreet = a.PersonMailingStreet;
            a.ShippingCity  = a.PersonMailingCity;
            a.ShippingState = a.PersonMailingState;
            a.ShippingPostalCode = a.PersonMailingPostalCode;
            a.ShippingCountry = a.PersonMailingCountry;
            
            //Person Account Billing Address.
            if (a.BillingStreet == null)
            {
            a.BillingStreet = a.PersonMailingStreet;
            a.BillingCity  = a.PersonMailingCity;
            a.BillingState = a.PersonMailingState;
            a.BillingPostalCode = a.PersonMailingPostalCode;
            a.BillingCountry = a.PersonMailingCountry; 
            }        
        }
        
        try{
            update a;
        }catch (Exception e){
            system.debug('***** Impossible to sync account fields: ' + e);
        }
    }
    public static void syncWTAppFields(Applicant_Info__c app,Person_Info__c per)
    {
     if(app.Account__c!=null && app.Intrax_Program__c=='Work Travel' && app.Application_Level__c=='Main' && app.Application_Stage__c=='Working')
      {
       list<Applicant_Info__c> ExistingAppInfo = [select id, CreatedBy__c, CreatedBy__r.Profile.Name, Intrax_Program__c, RecordTypeId , name ,Application_Type__c,
             School_Name__c, Major__c, Language_2__c, Language_3__c from Applicant_Info__c  where (Account__c =: app.Account__c AND application_Stage__c = 'Accepted' AND createdDate < :app.createdDate) order by createdDate DESC]; 
         if(ExistingAppInfo != NULL && ExistingAppInfo.size() >= 1)
         {
         Account a = [SELECT Id, Middle_Name__pc, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,PersonHomePhone,
         PersonMobilePhone, FirstName, LastName, Gender__pc, PersonBirthDate, citizenship__pc, personEmail,  Skype_id__pc,  Birth_City__pc, Birth_Country__pc, Legal_Residence__pc
         From Account WHERE Id =: app.Account__c];
         List<Member__c> mem=[Select id,Name,First_Name__c,Last_Name__c,Email__c,Mobile__c,Role_other__c,J2_Dependent__c,Account_Name__c from Member__c where Account_Name__c=:a.Id];
         List<Person_Info__c> emergency=new List<Person_Info__c>();
          if(per.Primary_Applicant__c==true)
         {
            per.Middle_Name__c=a.Middle_Name__pc;
            per.Gender__c=a.Gender__pc;
            per.Date_of_Birth__c=a.PersonBirthDate;
            per.Citizenship__c=a.citizenship__pc;
            per.Birth_City__c=a.Birth_City__pc;
            per.Birth_Country__c=a.Birth_Country__pc;
            per.Country_of_Residence__c=a.Legal_Residence__pc;
            per.Phone__c=a.PersonHomePhone;
            per.Mobile__c=a.PersonMobilePhone;
            per.Skype_Id__c=a.Skype_id__pc; 
         }
         
         app.Home_Street_1__c = a.BillingStreet;
         app.Home_City__c  = a.BillingCity;
         app.Home_State__c = a.BillingState;
         app.Home_Postal_Code__c = a.BillingPostalCode;
         app.Home_Country__c = a.BillingCountry; 
         app.School_Name__c = existingAppInfo[0].School_Name__c;
         app.Major__c = existingAppInfo[0].Major__c;
         app.Language_2__c= existingAppInfo[0].Language_2__c;
         app.Language_3__c= existingAppInfo[0].Language_3__c;
         try{
            update app;
        }catch (Exception e){
            system.debug('***** Impossible to update Appln fields: ' + e);
        }
        if(mem!=null && mem.size() >0){
            for(Member__c m:mem){
             if(m.J2_Dependent__c==false){
                Person_Info__c p = new Person_Info__c();
                p.Applicant_Info__c=app.Id;
                p.Name=m.First_Name__c+' '+m.Last_Name__c;
                p.First_Name__c=m.First_Name__c;
                p.Last_Name__c=m.Last_Name__c;
                p.Email__c=m.Email__c;
                p.Mobile__c=m.Mobile__c;
                p.Role__c='Other';
                p.Role_other__c=m.Role_other__c;
                p.Emergency_Contact_Indicated__c = 'Yes';
                emergency.add(p);
              }
            }
         }
        if(emergency!=null && emergency.size() >0)
        {
          system.debug('inside Emergency members***');
          insert emergency;     
        }
         system.debug('inside syncWTAppfields***');
        }
      }
     
    }
    
    
}