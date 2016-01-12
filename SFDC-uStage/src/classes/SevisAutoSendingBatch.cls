global class SevisAutoSendingBatch implements Database.Batchable<SObject>,Database.AllowsCallouts {

    //Testing helpers
    public static Boolean isTest = false;
    
    global Database.Querylocator start (Database.BatchableContext context){
        System.debug('===============Sevis Auto Sending Start==========');
        List<Engagement__c> EngagementsWithGovSevisIds = [Select e.Id, e.Name, e.Sevis__r.Sevis_ID__c from Engagement__c e where e.Intrax_Program__c in ('Ayusa','Internship','Work Travel','AuPairCare') and e.Sevis__c in ( select id from Sevis__c where Sevis_ID__c != null)  order by e.Name];
        return Database.getQueryLocator(
        [Select e.Parent_Engagement__c, e.Parent_Engagement__r.Status__c, e.Parent_Engagement_Start__c, e.Parent_Engagement_End__c, e.SEVIS_Update_EV_Add_TIPP__c, e.SEVIS_Degree_Type__c, e.SEVIS_Field_of_Study__c, e.Major__c, e.Profession__c, e.Years_of_Experience__c, e.Education_Program_Type__c,  e.Graduation_Date__c, 
        e.Name, e.Sevis__c,e.Account_Id__c,e.SEVIS_Program__c,e.Sevis_Skipped_Processing_Reason__c, e.SEVIS_Position__c, e.SEVIS_Occupation__c, e.Engagement_Start__c, e.Engagement_End__c, 
    e.Received_US_Govt_Funds__c,e.Program_Sponsor_Funds__c,e.Other_Financial_Support__c,e.Int_Org_Funding__c,e.Other_Org_Funding__c,e.Other_Org_Name__c,
    Personal_Funds__c,e.SEVIS_UEV__c,e.Sevis_UEV_Val_USAdd__c, e.Sevis_UEV_U_USAdd__c,e.Sevis_UEV_SOA_Edit__c, e.Sevis_UEV_SOA_Add__c, e.Sevis_UEV_Bio__c,e.Sevis_UEV_Pro_Amend__c,
    e.Total_Compensation__c,e.SEVIS_Subject_Code__c,Intrax_Program__c,e.Sevis_Lock__c , e.Placement_Status__c, e.Status__c,e.Is_Traveling__c, e.SEVIS_ID__c, e.Sevis_UEV_Nonstandard_SoA__c,e.Intrax_Program_Options__c
    From Engagement__c e 
       where (e.Intrax_Program__c in ('Ayusa','Internship','Work Travel','AuPairCare')
            AND e.Status__c =: 'Program Ready' 
            and e.Sevis_Lock__c = :false
            AND e.Sevis_ID__c != 'N/A'
            and e.Id not in :EngagementsWithGovSevisIds)
            OR
            (e.Intrax_Program__c in ('Ayusa','Internship','Work Travel','AuPairCare') AND (e.Status__c =: 'Program Ready' OR e.Status__c =: 'On Program') AND  e.Sevis_ID__c != 'N/A' and e.Sevis_Lock__c = :false AND e.SEVIS_UEV__c = :true AND e.Sevis_ID__c != null AND e.Sevis_UEV_Pro_Amend__c = :true)
            OR
            (e.Intrax_Program__c in ('Ayusa','Internship','Work Travel','AuPairCare') AND (e.Status__c =: 'Program Ready' OR e.Status__c =: 'On Program') AND e.Sevis_ID__c != 'N/A' and e.Sevis_Lock__c = :false AND e.SEVIS_UEV__c = :true AND e.Sevis_ID__c != null AND e.Sevis_UEV_Val_USAdd__c = :true)
            OR
            (e.Intrax_Program__c in ('Ayusa','Internship','Work Travel','AuPairCare') AND (e.Status__c =: 'Program Ready' OR e.Status__c =: 'On Program') AND e.Sevis_ID__c != 'N/A' and e.Sevis_Lock__c = :false AND e.SEVIS_UEV__c = :true AND e.Sevis_ID__c != null AND (NOT e.Sevis__r.SEVIS_Response__c LIKE '%S2124%')
            AND (e.Sevis_UEV_Bio__c = :true OR e.Sevis_UEV_Nonstandard_SoA__c = :true OR e.Sevis_UEV_SOA_Add__c = :true OR e.Sevis_UEV_SOA_Edit__c = :true OR e.Sevis_UEV_U_USAdd__c = :true))
            order by e.Name]);
     
    }     
    
    /* execute method is called once per transaction with a unique group of up to 200 records from the scope */
    global void execute(Database.BatchableContext context,List<SObject> scope) {
        System.debug('=============Sevis Auto Sending kicks off============');
        for(SObject rec: scope){
            Engagement__c eng = (Engagement__c)rec;
            System.debug('==============Engagement: =========' + eng.name);         
        }
        if(isTest) SevisWrapper.isTest=true;
        SevisWrapper batchWrapper = new SevisWrapper(scope);        
        batchWrapper.packageData();
    }
    
    global void finish(Database.BatchableContext context){
        System.debug ('================Sevis Auto Sending Complete');
    }
}