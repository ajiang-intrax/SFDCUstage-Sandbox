public without sharing class SevisWrapper {

public Engagement__c engagement{get; set;}
public List<Engagement__c> engagementList{get; set;}
public List<Engagement__c> skippedEngagements{get; set;}
public Map<Id,Engagement__c> nodupSkippedEngagements{get; set;}
public String responseXML {get; set;}
public Map<String,Map<String,String>> credentials{get; set;}
public Map<String,Map<String,String>> constants{get; set;}
public string AROUsername{get;set;}
public map<string, string> AROMap{get;set;}

//Testing helpers
public static Boolean isTest = false;


//This Constructor is for page level access
public SevisWrapper(ApexPages.StandardController stdController ){
    //Pick record in context
    engagement = (Engagement__c)stdController.getRecord();
    //Get it as a list
    engagementList = [Select  e.Parent_Engagement__c, e.Parent_Engagement__r.Status__c, e.Parent_Engagement_Start__c, e.Parent_Engagement_End__c, e.SEVIS_Update_EV_Add_TIPP__c, e.SEVIS_Degree_Type__c, e.SEVIS_Field_of_Study__c, e.Major__c, e.Profession__c, e.Years_of_Experience__c, e.Education_Program_Type__c,  e.Graduation_Date__c,      
    e.Sevis__c,e.Account_Id__c,e.SEVIS_Program__c, e.SEVIS_Position__c, e.SEVIS_Occupation__c, e.Engagement_Start__c, e.Engagement_End__c, 
    e.Received_US_Govt_Funds__c,e.Program_Sponsor_Funds__c,e.Other_Financial_Support__c,e.Int_Org_Funding__c,e.Other_Org_Funding__c,e.Other_Org_Name__c,
    Personal_Funds__c,e.SEVIS_UEV__c,e.Sevis_UEV_Val_USAdd__c, e.Sevis_UEV_U_USAdd__c,e.Sevis_UEV_SOA_Edit__c, e.Sevis_UEV_SOA_Add__c, e.Sevis_UEV_Bio__c,e.Sevis_UEV_Pro_Amend__c,
    e.Total_Compensation__c,e.SEVIS_Subject_Code__c,Intrax_Program__c,e.Sevis_Lock__c, e.Placement_Status__c, e.Status__c,e.Is_Traveling__c, e.SEVIS_ID__c, e.Sevis_UEV_Nonstandard_SoA__c,Intrax_Program_Options__c
    From Engagement__c e 
     where ID = :engagement.Id];
}

//This Constructor is for batch process 
public SevisWrapper(List<Engagement__c> engList){
    engagementList = engList;
}

public SevisWrapper(Engagement__c eng){
     //Get it as a list
    engagementList = [Select  e.Parent_Engagement__c, e.Parent_Engagement__r.Status__c, e.Parent_Engagement_Start__c, e.Parent_Engagement_End__c, e.SEVIS_Update_EV_Add_TIPP__c, e.SEVIS_Degree_Type__c, e.SEVIS_Field_of_Study__c, e.Major__c, e.Profession__c, e.Years_of_Experience__c, e.Education_Program_Type__c,  e.Graduation_Date__c, 
    e.Sevis__c,e.Account_Id__c,e.SEVIS_Program__c, e.SEVIS_Position__c, e.SEVIS_Occupation__c, e.Engagement_Start__c, e.Engagement_End__c, 
    e.Received_US_Govt_Funds__c,e.Program_Sponsor_Funds__c,e.Other_Financial_Support__c,e.Int_Org_Funding__c,e.Other_Org_Funding__c,e.Other_Org_Name__c,
    Personal_Funds__c,e.SEVIS_UEV__c,e.Sevis_UEV_Val_USAdd__c, e.Sevis_UEV_U_USAdd__c,e.Sevis_UEV_SOA_Edit__c, e.Sevis_UEV_SOA_Add__c, e.Sevis_UEV_Bio__c,e.Sevis_UEV_Pro_Amend__c,
    e.Total_Compensation__c,e.SEVIS_Subject_Code__c,Intrax_Program__c,e.Sevis_Lock__c, e.Placement_Status__c, e.Status__c,e.Is_Traveling__c, e.SEVIS_ID__c, e.Sevis_UEV_Nonstandard_SoA__c,Intrax_Program_Options__c
    From Engagement__c e 
     where ID = :eng.Id];
}

//The package function with the logic
public PageReference packageData(){ 
    PageReference p = null;
    if(engagement!=null)p= new ApexPages.Standardcontroller(engagement).view() ;
    getCredentials();
    getConstants();
    Global_Constants__c GlobalSetting = Global_Constants__c.getInstance();
    AROUsername = GlobalSetting.SEVIS_ARO_Username__c; 
    
    list<SEVIS_Responsible_Officers__c> ARONames = [SELECT Email__c, Intrax_Programs__c, Official_Name__c, SEVIS_Username__c FROM SEVIS_Responsible_Officers__c];
    
    AROMap = new map<string, string>();
    
    if (ARONames != NULL && ARONames.size() > 0)
    {
        for (SEVIS_Responsible_Officers__c SingleARO :ARONames)
        {
            AROMap.put(SingleARO.Official_Name__c, SingleARO.SEVIS_Username__c);
        }
    }
    
    //Batch related objects are instantiated outside loop
    iSevisWebServiceWrapper.ExchangeVisitorBatchRequest_element batch = new iSevisWebServiceWrapper.ExchangeVisitorBatchRequest_element();
    iSevisWebServiceWrapper.ExchangeVisitorBatchSoap11 handle = new iSevisWebServiceWrapper.ExchangeVisitorBatchSoap11();
    iSevisWebServiceWrapper.ExchangeVisitorBatchResponse_element response = new iSevisWebServiceWrapper.ExchangeVisitorBatchResponse_element();
    batch.ExchangeVisitorRequest =  new List<iSevisWebServiceWrapper.exchangeVisitorRequest>();  
    batch.Header  = new iSevisWebServiceWrapper.Header(); 
    
    //Sevis Map holds Engagement ID mapped to Sevis Record
    Map<Id,Sevis__c> sevisMap = new Map<Id,Sevis__c>();
    //Sevis List holds existing SEVIS records for bulk update
    List<Sevis__c> sevisList = new List<Sevis__c>();
    //List to hold skipped engagements
    skippedEngagements = new List<Engagement__c>();
    nodupSkippedEngagements = new map<Id,Engagement__c>();
    
    // Added for Story 79 (Start)
    Map<Id,Match__c> EnggMatchMap = new Map<Id,Match__c>();
    // Added for Story 79 (End)
    String sSkipped = '';
    
    //For each engagement in the list of engagements
    for (Engagement__c engagement : engagementList){
        
        //If record is locked don't do anything     
        if (engagement.SEVIS_LOCK__c){
            engagement.Sevis_Skipped_Processing_Reason__c = 'Record is locked for Transaction';
            //sSkipped += 'Record is locked for Transaction';
            //system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
            skippedEngagements.add(engagement);
        }
        // Wrapper should not grab Engagements with SEVIS ID set to "N/A"
        else if (engagement.SEVIS_ID__c =='N/A'){
            engagement.Sevis_Skipped_Processing_Reason__c = 'SEVIS data exists in the HAL';
            //sSkipped += 'SEVIS data exists in the HAL';
            skippedEngagements.add(engagement);
        }
        //SEVIS Program Must be not NULL in order for SEVIS Create/Update to send from SFDC
        else if (engagement.SEVIS_Program__c ==NULL){
            engagement.Sevis_Skipped_Processing_Reason__c = 'SEVIS program is missing';
            //sSkipped += 'SEVIS program is missing';
            skippedEngagements.add(engagement);
        }
        //Added for APC Extension (Start)
        else if (engagement.Intrax_Program__c == 'AuPairCare' && engagement.Parent_Engagement__c !=NULL && (engagement.Status__c == 'Program Ready' || engagement.Status__c == 'Processing') && engagement.Parent_Engagement__r.Status__c == 'On Program')
        {
            engagement.Sevis_Skipped_Processing_Reason__c = 'Cannot send SEVIS info while First Engagement is On Program';
            skippedEngagements.add(engagement);
        }
        //Added for APC Extension (End)
        else{
            System.debug('***********************Initiating Request for'+engagement.Id);
            //Pick Participant Record (Person Account) for Exchange Vistor Details
            Account participant = [Select a.Middle_Name__pc, a.PersonEmail, a.Gender__pc, a.PersonBirthDate, a.Legal_Residence__pc, a.LastName, a.FirstName, a.Citizenship__pc, a.Birth_Country__pc, a.Birth_City__pc From Account a where Id = :engagement.Account_Id__c ];
            
            if (participant.LastName==null || participant.Gender__pc==null ||participant.PersonBirthDate==null || participant.Birth_City__pc==null || participant.Birth_Country__pc==null || participant.Citizenship__pc==null || participant.Legal_Residence__pc==null )
            {
                sSkipped += 'Biographical info missing: ';
                skippedEngagements.add(engagement);
            
            
            if (participant.LastName==null){
          // engagement.Sevis_Skipped_Processing_Reason__c = 'LastName';
            sSkipped +=' LastName,';
           // skippedEngagements.add(engagement);
            }
             if (participant.Gender__pc==null){
            //engagement.Sevis_Skipped_Processing_Reason__c = 'Gender';
            sSkipped += ' Gender,';
           // skippedEngagements.add(engagement);
            }
             if (participant.PersonBirthDate==null){
           // engagement.Sevis_Skipped_Processing_Reason__c = 'PersonBirthDate';
            sSkipped +=' PersonBirthDate,';
            //skippedEngagements.add(engagement);
            }
             if (participant.Birth_City__pc==null){
           // engagement.Sevis_Skipped_Processing_Reason__c = 'Birth City';
            sSkipped +=' Birth City,';
           // skippedEngagements.add(engagement);
            }
             if (participant.Birth_Country__pc==null){
           // engagement.Sevis_Skipped_Processing_Reason__c = 'Birth Country';
            sSkipped +=' Birth Country,';
           // skippedEngagements.add(engagement);
            }
             if (participant.Citizenship__pc==null){
          //  engagement.Sevis_Skipped_Processing_Reason__c = 'Citizenship';
            sSkipped +=' Citizenship,';
           // skippedEngagements.add(engagement);
            }
            if (participant.Legal_Residence__pc==null){
           // engagement.Sevis_Skipped_Processing_Reason__c = 'Legal Residence';
            sSkipped +=' Legal Residence,';
           // skippedEngagements.add(engagement);
            }
            engagement.Sevis_Skipped_Processing_Reason__c =sSkipped;
            
                      
            }
            
            else if (participant.FirstName !=null && findSpecialCharacter(participant.FirstName) ){
            engagement.Sevis_Skipped_Processing_Reason__c = 'First Name contains special character';
            System.debug('findSpecialCharacter:#####' + participant.FirstName);
           // sSkipped +=' Birth City,';
            skippedEngagements.add(engagement);
            } 
            else if (participant.Middle_Name__pc !=null && findSpecialCharacter(participant.Middle_Name__pc) ){
            engagement.Sevis_Skipped_Processing_Reason__c = 'Middle Name contains special character';
            System.debug('findSpecialCharacter:#####' + participant.Middle_Name__pc);
           // sSkipped +=' Birth City,';
            skippedEngagements.add(engagement);
            } 
            else if (participant.LastName !=null && findSpecialCharacter(participant.LastName) ){
            engagement.Sevis_Skipped_Processing_Reason__c = 'Last Name contains special character';
            System.debug('findSpecialCharacter:#####' + participant.LastName);
           // sSkipped +=' Birth City,';
            skippedEngagements.add(engagement);
            } 
              else if (participant.Birth_City__pc !=null && findSpecialCharacter(participant.Birth_City__pc) ){
            engagement.Sevis_Skipped_Processing_Reason__c = 'Birth City contains special character';
            System.debug('findSpecialCharacter:#####' + participant.Birth_City__pc);
           // sSkipped +=' Birth City,';
            skippedEngagements.add(engagement);
            }      
                   
            else 
            {
                          
            //Load the sevis record for this engagement. A given engagement can have only one SEVIS record. 
            List<Sevis__c> sevis = [select Id,SEVIS_Ack_Results__c,SEVIS_Ack_Received_At__c,SEVIS_ID__c from Sevis__c s where s.Id = :engagement.Sevis__c ];
            //Instantiate a new Sevis as at this juncture , we don't know if the participant has a sevis history/record (or) not
            Sevis__c newSevis = new Sevis__c();
            newSevis.SEVIS_Ack_Received_At__c = NULL;
                    
            //Individual record related classes are instantiated inside the loop
            iSevisWebServiceWrapper.exchangeVisitorRequest indreq =  new iSevisWebServiceWrapper.exchangeVisitorRequest();
            indreq.ExchangeVisitor = new iSevisWebServiceWrapper.ExchangeVisitor();
            indreq.SiteOfActivity = new iSevisWebServiceWrapper.SiteOfActivity();
            /*if (engagement.Intrax_Program__c == 'Internship' && (engagement.SEVIS_ID__c == '' || engagement.SEVIS_ID__c == NULL))
            {
                indreq.TIPP = new iSevisWebServiceWrapper.TIPP(); 
                indreq.TIPP.TIPPPhases = new list<iSevisWebServiceWrapper.TIPPPhase>(); 
            }*/
            indreq.Header = new iSevisWebServiceWrapper.Header(); 
            
            //If there is no SEVIS history for the engagement, it's a CREATEEV
            if (sevis.size() == 0 ){
                System.debug('==========================CREATEEV-AFRESH=========================:'+engagement.Id);
                // Pick Match Record
                //List<Match__c> match = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
                List<Match__c> match = new List<Match__c>();
                if (engagement.Intrax_Program__c == 'Ayusa')
                {
                    match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c, m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' order by LastModifiedDate desc];
                }
                else
                {
                    match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c, m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' and Is_Future_SOA__c = false and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate desc];
                }
                system.debug('*** Match information is as follows :' + match);
                //Go do the mapping with the newSevis instance
                if (rumbleGrumbleAndMumble(engagement,match,indreq,newSevis,participant)){
                    //Set Site of Activity as ADD_SOA as its a new addition
                    //SEVIS 67 & 68 (Start)
                    if (engagement.Placement_Status__c == 'Exempt' && (engagement.SEVIS_ID__c == '' || engagement.SEVIS_ID__c == NULL))
                    {
                        indreq.SiteOfActivity.siteOfActivityAction = 'ADD_EXEMPT';
                    }
                    else
                    {
                        indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                        /*if (engagement.Intrax_Program__c == 'Internship')
                        {
                             List<Development_Plan__c> DevPlanList = match[0].Development_Plans__r;
                             if (DevPlanList != NULL && DevPlanList.size() > 0)
                             {
                                  indreq.SiteOfActivity.siteOfActivityAction = 'ADD_TIPP';
                             }
                             else
                             {
                                  indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                             }
                        }
                        else
                        {
                            indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                        }*/
                    }
                    //SEVIS 67 & 68 (End)
                    system.debug('Adding Id'+engagement.Id+'to sevismap');
                    //Add to SEVIS Map
                    sevisMap.put(engagement.Id,newSevis);
                    //Add to batch
                    batch.ExchangeVisitorRequest.add(indreq);
                    if (match == null){
                        system.debug('*** Match is null ***');
                    }
                    else if (match.size() == 0){
                        system.debug('*** Match size is zero ***');
                    }
                    // Added for Story 79 (Start)
                    if (match != null && match.size() > 0)
                    {
                        EnggMatchMap.put(engagement.Id, match[0]);
                        system.debug('**** Match is not null or zero, engagement ID is: ' + engagement.Id);
                    }
                    // Added for Story 79 (End)
                }
            }
            else if (sevis[0].SEVIS_ID__c == NULL ){
                //In iSEVIS but no SEVISID
                // Pick Match Record
                System.debug('===========================CREATEEV-NOT_IN_GOV:'+engagement.Id);
                //List<Match__c> match = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
                
                List<Match__c> match = new List<Match__c>();
                if (engagement.Intrax_Program__c == 'Ayusa')
                {
                    match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c, m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' order by LastModifiedDate DESC];
                }
                else
                {
                    match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c, m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' and Is_Future_SOA__c = false and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate DESC];
                }
                
                system.debug('*** SEVIS ID is null, match information is :' + match);
                //Go do the mapping with the newSevis instance
                if (rumbleGrumbleAndMumble(engagement,match,indreq,sevis[0],participant)){
                    //Set Site of Activity as ADD_SOA as its a new addition
                    
                    //SEVIS 67 & 68 (Start)
                    if (engagement.Placement_Status__c == 'Exempt' && (engagement.SEVIS_ID__c == '' || engagement.SEVIS_ID__c == NULL))
                    {
                        indreq.SiteOfActivity.siteOfActivityAction = 'ADD_EXEMPT';
                    }
                    else
                    {
                        indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                        /*if (engagement.Intrax_Program__c == 'Internship')
                        {
                             List<Development_Plan__c> DevPlanList = match[0].Development_Plans__r;
                             if (DevPlanList != NULL && DevPlanList.size() > 0)
                             {
                                  indreq.SiteOfActivity.siteOfActivityAction = 'ADD_TIPP';
                             }
                             else
                             {
                                  indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                             }
                        }
                        else
                        {
                            indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                        }*/
                    }
                    //SEVIS 67 & 68 (End)
                    system.debug('Adding Id'+engagement.Id+'to sevismap');
                    //Add to SEVIS Map
                    sevisMap.put(engagement.Id,sevis[0]);
                    //Add to batch
                    batch.ExchangeVisitorRequest.add(indreq);
                    
                    // Added for Story 79 (Start)
                    if (match == null){
                        system.debug('**** match is null ***');
                    }
                    else if (match.size() == 0){
                        system.debug('*** match size is zero ***');
                    }
                    if (match != null && match.size() > 0)
                    {
                        EnggMatchMap.put(engagement.Id, match[0]);
                        system.debug('**** match is not null or zero in size, engagement ID is ' + engagement.Id);
                    }
                    // Added for Story 79 (End)
                }               
            }
            //There is a sevis history for the participant and so, it's an UPDATEEV
            else{
                //All updates cannot go at one shot
                System.debug('UPDATEEV'+engagement.Id);
                sevis[0].SEVIS_Request_Sent_At__c = DateTime.now();
                //While we are , it does indicate its an UPDATEEV, however, we process only if the flags are set
                if (engagement.SEVIS_UEV__c){
                    //There are updates
                    List<Match__c> match;
                    
                    if (engagement.SEVIS_Update_EV_Add_TIPP__c){
                        //match = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :engagement.Id and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
                        match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c,m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' order by LastModifiedDate desc];
                        system.debug('*** Update being done, match information is as follows: ' + match);
                        //Go do the mapping with the existing Sevis instance
                        if (rumbleGrumbleAndMumble(engagement,match,indreq,sevis[0],participant)){
                            /*if (engagement.Sevis_UEV_Val_USAdd__c) {
                                indreq.ExchangeVisitor.validation = 'TRUE';
                                engagement.SEVIS_When_Validation_Sent__c = System.now();
                            }   */
                            indreq.SiteOfActivity.siteOfActivityAction = 'EDIT_SOA';
                            
                            //indreq.SiteOfActivity.siteOfActivityAction = 'ADD_TIPP';
                            
                            
                            batch.ExchangeVisitorRequest.add(indreq);
                            sevisMap.put(engagement.Id,sevis[0]);
                            
                            // Added for Story 79 (Start)
                            if (match == null){
                                system.debug('*** match is null ***');
                            }
                            else if (match.size() == 0){
                                system.debug('*** match size is zero ***');
                            }
                            if (match != null && match.size() > 0)
                            {
                                EnggMatchMap.put(engagement.Id, match[0]);
                                system.debug('*** match is not null or zero in size, engagement ID is ' + engagement.Id);
                            }
                            // Added for Story 79 (End)
                        }
                    }
                    else if (engagement.Sevis_UEV_Bio__c || engagement.Sevis_UEV_Pro_Amend__c || engagement.Sevis_UEV_SOA_Edit__c || engagement.Sevis_UEV_Val_USAdd__c || engagement.Sevis_UEV_U_USAdd__c || engagement.Sevis_UEV_Nonstandard_SoA__c){
                        //match = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :engagement.Id and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
                        if (engagement.Intrax_Program__c == 'Ayusa')
                        {
                            match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c,m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' order by LastModifiedDate desc];
                        }
                        else
                        {
                            match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c,m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and Is_Future_SOA__c = false and SEVIS_UEV_SOA_Add__c = false and m.Status__c = 'Confirmed' order by LastModifiedDate desc];
                        }
                        system.debug('*** Update being done, match information is as follows: ' + match);
                        //Go do the mapping with the existing Sevis instance
                        if (rumbleGrumbleAndMumble(engagement,match,indreq,sevis[0],participant)){
                            if (engagement.Sevis_UEV_Val_USAdd__c) {
                                indreq.ExchangeVisitor.validation = 'TRUE';
                                engagement.SEVIS_When_Validation_Sent__c = System.now();
                            }   
                            //indreq.SiteOfActivity.siteOfActivityAction = 'EDIT_SOA';
                            
                            //SEVIS 67 & 68 (Start)
                            if (engagement.Placement_Status__c == 'Exempt')
                            {
                                indreq.SiteOfActivity.siteOfActivityAction = 'ADD_EXEMPT';
                            }
                            else if (engagement.Is_Traveling__c)
                            {
                                indreq.SiteOfActivity.siteOfActivityAction = 'ADD_ONTRAVEL';
                            }
                            else if (engagement.Placement_Status__c == 'Not Placed' && (engagement.Status__c == 'Program Ready' || engagement.Status__c == 'On Program'))
                            {
                                indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SEEKINGEMP';
                            }
                            else
                            {
                                /*if (engagement.Intrax_Program__c == 'Internship')
                                {
                                    List<Development_Plan__c> DevPlanList = match[0].Development_Plans__r;
                                    if (DevPlanList != NULL && DevPlanList.size() > 0)
                                    {
                                        indreq.SiteOfActivity.siteOfActivityAction = 'EDIT_SITE';
                                    }
                                    else
                                    {
                                        indreq.SiteOfActivity.siteOfActivityAction = 'EDIT_SOA';
                                    }
                                }
                                else
                                {
                                    indreq.SiteOfActivity.siteOfActivityAction = 'EDIT_SOA';
                                }*/
                                indreq.SiteOfActivity.siteOfActivityAction = 'EDIT_SOA';
                            } 
                            //SEVIS 67 & 68 (End)
                            
                            batch.ExchangeVisitorRequest.add(indreq);
                            //Reset all the flags to indicate the updates have been picked and sent to iSEVIS
                            //Commented for SEVIS - 80 (Start)
                            /*engagement.Sevis_UEV_Bio__c = false;
                            engagement.Sevis_UEV_Pro_Amend__c = false;
                            engagement.Sevis_UEV_SOA_Edit__c = false;
                            engagement.Sevis_UEV_Val_USAdd__c = false;
                            engagement.Sevis_UEV_U_USAdd__c = false;
                            engagement.Sevis_UEV_Nonstandard_SoA__c = false;*/
                            //Commented for SEVIS - 80 (End)
                            //Add to SEVIS map
                            sevisMap.put(engagement.Id,sevis[0]);
                            
                            // Added for Story 79 (Start)
                            if (match == null){
                                system.debug('*** match is null ***');
                            }
                            else if (match.size() == 0){
                                system.debug('*** match size is zero ***');
                            }
                            if (match != null && match.size() > 0)
                            {
                                EnggMatchMap.put(engagement.Id, match[0]);
                                system.debug('*** match is not null or zero in size, engagement ID is ' + engagement.Id);
                            }
                            // Added for Story 79 (End)
                        }
                    }
                    else if (engagement.Sevis_UEV_SOA_Add__c ){
                        //New Match added
                        //Get to the newly added match and get it
                        //match = [Select m.Position_Name__c, m.Participant_Id__c, m.Is_Primary_SOA__c, m.Engagement__c,m.School_Id__c From Match__c m where Engagement__c = :engagement.Id and SEVIS_UEV_SOA_Add__c = true and m.Status__c = 'Confirmed' order by LastModifiedDate asc];
                        if (engagement.Intrax_Program__c == 'Ayusa')
                        {
                            match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c,m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Is_Primary_SOA__c, m.Engagement__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and m.Status__c = 'Confirmed' order by LastModifiedDate desc];
                        }
                        else
                        {
                            match = [Select (Select Name, Cultural_Component__c, Description__c, End__c, Evaluation_Methods__c, Goal__c, Instructional_Methods__c, Learning_Outcome__c, Phase__c, Start__c, Supervision__c, Additional_Remarks__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c, Supervisor_Signed_TIPP__c From Development_Plans__r), m.ARO_Signed_TIPP_Name__c, m.ARO_Signed_TIPP__c, m.PT_Signed_TIPP__c,m.Current_TIPP_Editor__c, m.Position_Name__c, m.Participant_Id__c, m.Is_Primary_SOA__c, m.Engagement__c,m.School_Id__c, m.SEVIS_UEV_SOA_Add__c From Match__c m where Engagement__c = :engagement.Id and Is_Future_SOA__c = false and SEVIS_UEV_SOA_Add__c = true and m.Status__c = 'Confirmed' order by LastModifiedDate desc];
                        }
                        //Go do the mapping with the existing Sevis instance
                        if (rumbleGrumbleAndMumble(engagement,match,indreq,sevis[0],participant)){
                            batch.ExchangeVisitorRequest.add(indreq);
                            //indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                            
                            //SEVIS 67 & 68 (Start)
                            if (engagement.Placement_Status__c == 'Exempt')
                            {
                                indreq.SiteOfActivity.siteOfActivityAction = 'ADD_EXEMPT';
                            }
                            else if (engagement.Is_Traveling__c)
                            {
                                indreq.SiteOfActivity.siteOfActivityAction = 'ADD_ONTRAVEL';
                            }
                            else if (engagement.Placement_Status__c == 'Not Placed' && (engagement.Status__c == 'Program Ready' || engagement.Status__c == 'On Program'))
                            {
                                indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SEEKINGEMP';
                            }
                            else
                            {
                                /*if (engagement.Intrax_Program__c == 'Internship')
                                {
                                    List<Development_Plan__c> DevPlanList = match[0].Development_Plans__r;
                                    if (DevPlanList != NULL && DevPlanList.size() > 0)
                                    {
                                        indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SITE';
                                    }
                                    else
                                    {
                                        indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                                    }
                                }
                                else
                                {
                                    indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                                }*/
                                indreq.SiteOfActivity.siteOfActivityAction = 'ADD_SOA';
                            }
                            //SEVIS 67 & 68 (End)
                            //Commented for SEVIS - 80 (Start)
                            //engagement.Sevis_UEV_SOA_Add__c = false;
                            //Commented for SEVIS - 80 (End)
                            //Add to SEVIS map
                            sevisMap.put(engagement.Id,sevis[0]);
                            
                            // Added for Story 79 (Start)
                            if (match == null){
                                system.debug('*** match is null ***');
                            }
                            else if (match.size() == 0){
                                system.debug('*** match size is zero ***');
                            }
                            if (match != null && match.size() > 0)
                            {
                                EnggMatchMap.put(engagement.Id, match[0]);
                                system.debug('*** match is not null or zero in size, engagement ID is ' + engagement.Id);
                            }
                            // Added for Story 79 (End)
                        }
                    }
                }
                else{
                   engagement.Sevis_Skipped_Processing_Reason__c = 'Record has no updates to be processed';
                   // sSkipped +='Record has no updates to be processed';
                   // system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                    skippedEngagements.add(engagement);
                }
            }
            //Set individual record Header
            
            // Story 112: retrieve user name/password for iSevis access per program
            //If Engagement.IntraxProgramOption = WEST, then use WEST SEVIS Program / User
            //If Engagement.IntraxProgramOption <> WEST, and Engagement.SevisProgram = 14-Trainee, then use Training SEVIS Program / User
            //If Engagement.IntraxProgramOption <> WEST, and Engagement.SevisProgram = 15-Intern, then use Internship SEVIS Program / User
            
            if (engagement.Intrax_Program__c == 'Ayusa' || engagement.Intrax_Program__c == 'Work Travel'){
                indreq.Header.user_x = credentials.get(engagement.Intrax_Program__c).get('UserName');
                indreq.Header.password = credentials.get(engagement.Intrax_Program__c).get('Password');
            }  // engagement.Intrax_Program_Options__c == 'WEST'
            else if (engagement.Intrax_Program__c == 'Internship' && engagement.Intrax_Program_Options__c != NULL && engagement.Intrax_Program_Options__c.contains('WEST')){
                indreq.Header.user_x = credentials.get('West').get('UserName');
                indreq.Header.password = credentials.get('West').get('Password');  
            }
            else if (engagement.Intrax_Program__c == 'Internship' && engagement.Intrax_Program_Options__c != 'WEST' && engagement.SEVIS_Program__c =='14-Trainee'){
                indreq.Header.user_x = credentials.get('Training').get('UserName');
                indreq.Header.password = credentials.get('Training').get('Password');  
            }
            else if (engagement.Intrax_Program__c == 'Internship' && engagement.Intrax_Program_Options__c != 'WEST' && engagement.SEVIS_Program__c =='15-Intern'){
                indreq.Header.user_x = credentials.get('Internship').get('UserName');
                indreq.Header.password = credentials.get('Internship').get('Password');  
            }
            else if (engagement.Intrax_Program__c == 'AuPairCare'){
                indreq.Header.user_x = credentials.get('AuPairCare').get('UserName');
                indreq.Header.password = credentials.get('AuPairCare').get('Password'); 
            }
            indreq.Header.appId = engagement.Id;
            indreq.Header.paxId = engagement.Id;
            System.debug('***********************End Constructing Request for'+engagement.Id);
         }
        }
        
      // engagement.Sevis_Skipped_Processing_Reason__c = sSkipped;
       //system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
         
    }
    
    //Processing of engagements is over and ready to send the information to iSEVIS
    try{
        //Set Batch Header
        batch.Header.user_x = 'salesforce';
        batch.Header.password = 'changeme'; 
        //Only if there are records to be sent
        if (batch.ExchangeVisitorRequest.size() > 0){
            System.debug('REQUEST SIZE+++++'+batch.ExchangeVisitorRequest);
            System.debug('REQUEST HEADER+++++'+batch.Header);
            //Make the webservice call
            if (!isTest){
            	system.debug('Start Time:'+DateTime.now());
                response = handle.ExchangeVisitorBatch(batch.Header, batch.ExchangeVisitorRequest);
                system.debug('Start Time:'+DateTime.now());
            }
            else{
                //Test Response for code coverage
                iSevisWebServiceWrapper.ExchangeVisitorBatchResponse_element testResponse = new iSevisWebServiceWrapper.ExchangeVisitorBatchResponse_element();
                List<iSevisWebServiceWrapper.exchangeVisitorResponse> testIndResList = new List<iSevisWebServiceWrapper.exchangeVisitorResponse>();
                iSevisWebServiceWrapper.exchangeVisitorResponse testIndRes = new iSevisWebServiceWrapper.exchangeVisitorResponse();
                iSevisWebServiceWrapper.Header testResHeader = new iSevisWebServiceWrapper.Header();
                List<iSevisWebServiceWrapper.XSDError> xsdErrors = new List<iSevisWebServiceWrapper.XSDError>();
                iSevisWebServiceWrapper.XSDError xsdError = new iSevisWebServiceWrapper.XSDError();
                xsdErrors.add(xsdError);
                                
                response = testResponse;
                testIndResList.add(testIndRes);
                response.ExchangeVisitorResponse = testIndResList;

                response.Header = testResHeader;
                response.Header.paxId = engagement.Id;
                response.Header.xsdErrors = xsdErrors;
                response.ExchangeVisitorResponse[0].Header = testResHeader;
                response.ExchangeVisitorResponse[0].Header.paxId = engagement.Id;
                response.ExchangeVisitorResponse[0].Header.xsdErrors = xsdErrors; 
            }
            
            //Response obtained!
            System.debug('Response!!!!!!'+response);
            if (response.ExchangeVisitorResponse != null){
                //Assume with a positive thought that there is no error :)
                String errorMessage = 'No Error';
                //Do ERROR processing :)
                Sevis__c sevisResult =  new Sevis__c();
                List<Engagement__c> engagementResult = new List<Engagement__c>(); 
                
                //Added for Story 79 (Start)
                List<Match__c> MatchUpdResult = new List<Match__c>(); 
                //Added for Story 79 (End)
            
                //Two types of errors are instantiated
                String XSDErrors = '';
                String validationErrors = '';
                
                for ( iSevisWebServiceWrapper.exchangeVisitorResponse indRes : response.ExchangeVisitorResponse){
                    system.debug('indRes:'+indRes);
                    System.debug('Got back result for'+indRes.Header.paxId);
                    system.debug(sevisMap);
                    //sevisResult = sevisMap.get(indRes.Header.paxId);
                    System.debug('BatchHeader!!!!:'+response.Header);
                    if (response.Header.paxId != 'iSEVIS-XSD-Errors'){
                        
                        //If there are XSD errors accumulated them
                        if (indRes.Header.xsdErrors != NULL){
                            for (iSevisWebServiceWrapper.XSDError xsdError : response.Header.xsdErrors){
                                XSDErrors = XSDErrors + xsdError.message;
                            }
                        }
                        
                        if (XSDErrors != '')
                            XSDErrors = 'XSDErrors are: ' + XSDErrors;
                            
                        //Pick the sevis record from the Map to update it with the response values
                        sevisResult = sevisMap.get(indRes.Header.paxId);
                        system.debug(sevisResult);
                        
                        //If there are validation errors, accumulate them
                        if (indRes.Header.validationErrors != NULL){
                            for (iSevisWebServiceWrapper.validationError validationError : indRes.Header.validationErrors){
                                validationErrors = validationErrors + validationError.message + ':' + validationError.field;
                            }
                        }
                        
                        if (validationErrors != '')
                            validationErrors = 'Validation Errors are: ' + validationErrors;
                            
                        System.debug('Errors:' + XSDErrors + '+' + validationErrors);   
                        //If its a new SEVIS record created for that engagement     
                        if (sevisResult.SEVIS_Ack_Received_At__c == null){
                            sevisResult.SEVIS_Ack__c = indRes.Header.statusCode;
                            String finalError = '';
                            if(XSDErrors + validationErrors != '')
                                finalError = indRes.Header.statusMessage + ' due to: '+XSDErrors + validationErrors;
                            sevisResult.SEVIS_Ack_Results__c = finalError.left(32766) ;
                            sevisResult.SEVIS_Ack_Received_At__c =  DateTime.now();
                            //This is a new SEVIS and because of the relationship , we cannot do bulk insert and hence doing individual inserts
                            insert sevisResult;
                            //Once inserted, map this sevis record with the engagement in context
                            for (Engagement__c engagement : engagementList){
                                if (engagement.Id == indRes.Header.paxId){
                                    engagement.Sevis__c = sevisResult.Id;
                                    //Added is condition for SEVIS - 80
                                    if (indRes.Header.statusCode == 'SUCCESS')
                                    {
                                        //Lock the record till we hear back from iSEVIS/Gov SEVIS
                                        engagement.SEVIS_LOCK__c = True;
                                        engagement.Sevis_Skipped_Processing_Reason__c = '';
                                        //system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                                        //Keeping adding the engagement to be updated into a list
                                    }
                                    engagementResult.add(engagement);
                                }
                            }
                        }
                        //Its an existing SEVIS
                        else{
                            sevisResult.SEVIS_Ack__c = indRes.Header.statusCode;
                            String finalError = indRes.Header.statusMessage + ' due to: '+XSDErrors + validationErrors;
                            sevisResult.SEVIS_Ack_Results__c = finalError.left(32766) ;
                            sevisResult.SEVIS_Ack_Received_At__c = DateTime.now();
                            //Add this to the sevisList for bulk update
                            sevisList.add(sevisResult);
                            for (Engagement__c engagement : engagementList){
                                if (engagement.Id == indRes.Header.paxId){
                                    //Added is condition for SEVIS - 80
                                    if (indRes.Header.statusCode == 'SUCCESS')
                                    {
                                        System.debug('!!!!engagement!!!!!'+engagement);
                                        //Lock the record till we hear back from iSEVIS/Gov SEVIS
                                        engagement.SEVIS_LOCK__c = True;
                                        engagement.Sevis_Skipped_Processing_Reason__c = '';
                                       // system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                                        if (engagement.SEVIS_Update_EV_Add_TIPP__c)
                                        {
                                            engagement.SEVIS_Update_EV_Add_TIPP__c = false;
                                        }
                                        else if (engagement.Sevis_UEV_Bio__c || engagement.Sevis_UEV_Pro_Amend__c || engagement.Sevis_UEV_SOA_Edit__c || engagement.Sevis_UEV_Val_USAdd__c || engagement.Sevis_UEV_U_USAdd__c || engagement.Sevis_UEV_Nonstandard_SoA__c)
                                        {
                                            engagement.Sevis_UEV_Bio__c = false;
                                            engagement.Sevis_UEV_Pro_Amend__c = false;
                                            engagement.Sevis_UEV_SOA_Edit__c = false;
                                            engagement.Sevis_UEV_Val_USAdd__c = false;
                                            engagement.Sevis_UEV_U_USAdd__c = false;
                                            engagement.Sevis_UEV_Nonstandard_SoA__c = false;
                                        }
                                        else if (engagement.Sevis_UEV_SOA_Add__c)
                                        {
                                            engagement.Sevis_UEV_SOA_Add__c = false;
                                            
                                            //Added for Story 79 (Start)
                                            Match__c MatchToUpdSoa = EnggMatchMap.get(engagement.Id);
                                            if (MatchToUpdSoa != null)
                                            {
                                                MatchToUpdSoa.SEVIS_UEV_SOA_Add__c = false;
                                                MatchUpdResult.add(MatchToUpdSoa);
                                            }
                                            //Added for Story 79 (End)
                                        }
                                        
                                        engagementResult.add(engagement);
                                    }
                                }
                            }
                        }
                    }
                }
                //Update existing SEVIS records
                if (sevisList.size() > 0)
                {
                    update sevisList;
                }
                
                //Update all engagements
                if (engagementResult.size() > 0)
                {
                    update engagementResult;
                }
                
                //Added for Story 79 (Start)
                if (MatchUpdResult.size() >0)
                {
                    update MatchUpdResult;
                }
                //Added for Story 79 (End)
                
            }
            else{
                Boolean alreadyAdded = false;       
                for (Engagement__c engagement : engagementList){
                    alreadyAdded = false;
                    for (Engagement__c skippedEngagement : skippedEngagements){
                        if (skippedEngagement.Id == engagement.Id){
                            alreadyAdded = true;
                            break;
                        }
                    }
                    if (!alreadyAdded){
                        engagement.Sevis_Skipped_Processing_Reason__c = 'No response received from iSEVIS';
                       // system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                        skippedEngagements.add(engagement);
                    }
                }
            }
            
            system.debug(response); 
        }
    }
    catch(Exception e){
        System.debug('Exception Caught'+e);
        for (Engagement__c engagement : engagementList){
            engagement.Sevis_Skipped_Processing_Reason__c = e.getMessage()+ e.getCause() + '@' + DateTime.now();
            //system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
            skippedEngagements.add(engagement);
        }
    }
    if (skippedEngagements.size() > 0){     
        for (Engagement__c skippedEngagement : skippedEngagements){
            nodupSkippedEngagements.put(skippedEngagement.id,skippedEngagement);
        }
        update nodupSkippedEngagements.values();
    }
     
    return p;
}

public void getCredentials(){
    List<Credentials__c> credentialList = [select Name,User_Name__c,Password__c,Type__c from Credentials__c where Name like 'Sevis%'];
    credentials = new Map<String,Map<String,String>>();
    for (Credentials__c credential : credentialList){
        Map<String,String> userPassInd = new Map<String,String>();
        userPassInd.put('UserName',credential.User_Name__c);
        userPassInd.put('Password',credential.Password__c);
        credentials.put(credential.Type__c,userPassInd);
    }
}

public void getConstants(){
    List<Application_Constants__c> ayusaNoMatchSOAList = [select Key__c,Program__c,Value__c from Application_Constants__c where Name like 'Sevis Ayusa NoMatch%'];
    constants = new Map<String,Map<String,String>>();
    Map<String,String> ayusaNoMatchSOA = new Map<String,String>();
    for (Application_Constants__c constant : ayusaNoMatchSOAList){
        ayusaNoMatchSOA.put(constant.Program__c+constant.Key__c,constant.Value__c);
    }
    constants.put('NoMatchSOA',ayusaNoMatchSOA);
}

public Boolean rumbleGrumbleAndMumble(Engagement__c engagement,List<Match__c> match,iSevisWebServiceWrapper.exchangeVisitorRequest indreq, Sevis__c sevis,Account participant){
            system.debug('Did I come in?');
            Boolean ayusaWOMatch = false;
            Position__c position;
            Account hostCompanyOrHostFamily;
            List<Account> school;
            List<Member__c> members;
            if (match.size() == 0 && engagement.Intrax_Program__c == 'Ayusa'){
                ayusaWOMatch = true;
            }
            
            //SEVIS 67 & 68 (Start)
            Boolean AvoidNoAsses = false;
            Boolean OtherSoAType = false;
            if (engagement.Placement_Status__c == 'Exempt' && (engagement.SEVIS_ID__c == '' || engagement.SEVIS_ID__c == NULL))
            {
                OtherSoAType = true;
            }
            else if (Engagement.SEVIS_UEV__c && engagement.SEVIS_ID__c != '' && engagement.SEVIS_ID__c != null && engagement.Placement_Status__c == 'Exempt')
            {
                OtherSoAType = true;
            }
            else if(Engagement.SEVIS_UEV__c && engagement.Is_Traveling__c && engagement.SEVIS_ID__c != '' && engagement.SEVIS_ID__c != null)
            {
                OtherSoAType = true;
            }
            else if(engagement.Intrax_Program__c != 'AuPairCare' && Engagement.SEVIS_UEV__c && engagement.SEVIS_ID__c != '' && engagement.SEVIS_ID__c != null && engagement.Placement_Status__c == 'Not Placed' && (engagement.Status__c == 'Program Ready' || engagement.Status__c == 'On Program'))
            {
                OtherSoAType = true;
            }
            //SEVIS 67 & 68 (End)
            if (match.size() > 0 || ayusaWOMatch || OtherSoAType){
                
                if (!ayusaWOMatch && !OtherSoAType){
                    //Pick Position Information
                    position = [Select p.Owner.Name, p.Owner.FirstName, p.Owner.LastName, p.Hours_Per_Week__c, p.Employment_Hrs_Wk__c,p.Compensation_Type__c, p.Pay_Rate__c, p.Pay_Rate_Basis__c, p.Non_Monetary_Comp_Value__c, p.Non_Monetary_Comp_Description__c, p.Workers_Comp_Coverage__c, p.Position_Supervisor__r.FirstName, p.Position_Supervisor__r.LastName, p.Position_Supervisor__r.Title, p.Position_Supervisor__r.Phone, p.Position_Supervisor__r.Email, Site_Name__c, Functional_Areas__c,     p.Street__c, p.Street_2__c, p.State__c,p.SEVIS_Address_Override__c,p.SEVIS_Address_Override_Reason__c, p.Postal_Code__c, p.Host_Company_Id__c, p.Host_Opportunity_Id__c, p.School_Id__c, p.City__c,p.Primary_Activity_Site__c,p.Title__c From Position__c p where Id = :match[0].Position_Name__c];
                    //Pick Host Company Information
                    hostCompanyOrHostFamily = [select Website, EIN__c, Has_Workers_Comp__c, Worker_Comp_Provider__c, NumberOfEmployees, Company_Annual_Revenue__c, Fax, Name,FirstName,LastName,Phone,SEVIS_Address_Override__c,SEVIS_Address_Override_Reason__c,Account_Name_Legal__c, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity from Account where Id = :position.Host_Company_Id__c];
                    system.debug('*** initial value of hostCompanyOrHostFamily is as follows: ' + hostCompanyOrHostFamily);
                    system.debug('*** hostCompanyOrHostFamily.Phone is: ' + hostCompanyOrHostFamily.Phone);
                    //Pick School Information (only for Ayusa)
                    school = [select Name,Account_Name_Legal__c,SEVIS_Address_Override__c,SEVIS_Address_Override_Reason__c, ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity from Account where Id = :match[0].School_Id__c];
                    //Pick Members Information (only for Ayusa)
                    system.debug(' *** hostCompanyOrHostFamily.Id:' + hostCompanyOrHostFamily.Id);
                    members = [select First_Name__c,Last_Name__c,Phone__c from Member__c where Role__c in ('Spouse or Partner') and Account_Name__c = :hostCompanyOrHostFamily.Id];
                }
                //Pick Accomodation Site
                List<Accommodation__c> accommodation = [Select a.Match__c, a.Id, a.Accommodation_Site__c From Accommodation__c a where Engagement__c = :engagement.Id order by CreatedDate desc];
                
                //if (!ayusaWOMatch && !OtherSoAType)
                if (!ayusaWOMatch){
                    if (accommodation.size() > 0){
                        list <Accommodation_Site__c> accommodationSite = [Select a.Street__c, a.Street_2__c, a.State__c,a.SEVIS_Address_Override__c,a.SEVIS_Address_Override_Reason__c, a.Postal_Code__c, a.City__c From Accommodation_Site__c a where a.Id = :accommodation[0].Accommodation_Site__c ];
                        //Acco Site Goes here
                        if (accommodationSite.size() > 0)
                        {
                            //SEVIS - 102 (Start)
                            if (accommodationSite[0].Street__c == '' || accommodationSite[0].City__c == '' || accommodationSite[0].State__c == '' || accommodationSite[0].Postal_Code__c == '' || accommodationSite[0].Street__c == NULL || accommodationSite[0].City__c == NULL || accommodationSite[0].State__c == NULL || accommodationSite[0].Postal_Code__c == NULL)
                            {
                                if (engagement.Sevis_UEV_U_USAdd__c || engagement.Sevis_UEV_Val_USAdd__c)
                                {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Validation cannot be sent without US Address';
                                   // system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                                }
                                else
                                {
                                     //by Anna D-01879 
                            if (accommodationSite[0].Street__c!=null && findSpecialCharacter(accommodationSite[0].Street__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'AccommodationSite.Street contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                    indreq.ExchangeVisitor.address1 = accommodationSite[0].Street__c ;
                                     //by Anna D-01879 
                            if (accommodationSite[0].Street_2__c!=null && findSpecialCharacter(accommodationSite[0].Street_2__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'AccommodationSite.Street_2 contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                    indreq.ExchangeVisitor.address2 = accommodationSite[0].Street_2__c ;
                                     //by Anna D-01879 
                            if (accommodationSite[0].City__c!=null && findSpecialCharacter(accommodationSite[0].City__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'AccommodationSite.City contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                    indreq.ExchangeVisitor.city = accommodationSite[0].City__c;
                                    
                                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    indreq.ExchangeVisitor.stateCode = accommodationSite[0].State__c ;
                                    indreq.ExchangeVisitor.postalCode = matchAndReplace('-.*',accommodationSite[0].Postal_Code__c,'') ;
                                    if (accommodationSite[0].SEVIS_Address_Override__c==true)
                                    {
                                        indreq.ExchangeVisitor.explanationCode='OO';
                                        indreq.ExchangeVisitor.explanation=accommodationSite[0].SEVIS_Address_Override_Reason__c;
                                    }
                                    
                                }
                            } 
                            else
                            {   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                 //by Anna D-01879
                                 if (accommodationSite[0].Street__c!=null && findSpecialCharacter(accommodationSite[0].Street__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'AccommodationSite.Street contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.ExchangeVisitor.address1 = accommodationSite[0].Street__c ;
                                 if (accommodationSite[0].Street_2__c!=null && findSpecialCharacter(accommodationSite[0].Street_2__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'AccommodationSite.Street 2 contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.ExchangeVisitor.address2 = accommodationSite[0].Street_2__c ;
                                 if (accommodationSite[0].City__c!=null && findSpecialCharacter(accommodationSite[0].City__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'AccommodationSite.City contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.ExchangeVisitor.city = accommodationSite[0].City__c;
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                       indreq.ExchangeVisitor.stateCode = accommodationSite[0].State__c ;
                                indreq.ExchangeVisitor.postalCode = matchAndReplace('-.*',accommodationSite[0].Postal_Code__c,'') ;
                                if (accommodationSite[0].SEVIS_Address_Override__c==true)
                                    {
                                        indreq.ExchangeVisitor.explanationCode='OO';
                                        indreq.ExchangeVisitor.explanation=accommodationSite[0].SEVIS_Address_Override_Reason__c;
                                    }
                            }
                            //SEVIS - 102 (End)
                        }
                        else
                        {
                            AvoidNoAsses = true;
                            engagement.Sevis_Skipped_Processing_Reason__c = 'Accommodation does not have an Accommodation Site'; 
                            //system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                        }
                    }  
                    // Modified this block for B-02571 
                    else if (engagement.Intrax_Program__c == 'Ayusa' || engagement.Intrax_Program__c == 'AuPairCare'){
                        //Pick address from HF Account
                        //SEVIS - 102 (Start)
                        //system.debug('*** hostCompanyOrHostFamily Address is : ' + hostCompanyOrHostFamily.BillingStreet + ' ' + hostCompanyOrHostFamily.BillingCity + ' ' + hostCompanyOrHostFamily.BillingState + ' ' + hostCompanyOrHostFamily.BillingPostalCode);
                        if (hostCompanyOrHostFamily.BillingStreet == '' || hostCompanyOrHostFamily.BillingCity == '' || hostCompanyOrHostFamily.BillingState == '' || hostCompanyOrHostFamily.BillingPostalCode == '' || hostCompanyOrHostFamily.BillingStreet == NULL || hostCompanyOrHostFamily.BillingCity == NULL || hostCompanyOrHostFamily.BillingState == NULL || hostCompanyOrHostFamily.BillingPostalCode == NULL)
                        {
                            if (engagement.Sevis_UEV_U_USAdd__c || engagement.Sevis_UEV_Val_USAdd__c)
                            {
                                AvoidNoAsses = true;
                                engagement.Sevis_Skipped_Processing_Reason__c = 'Validation cannot be sent without US Address';
                               // system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }
                            else
                            {    //////////////////////////////////////////////////////////////////////////////////////////////////////
                                 //by Anna D-01879 
                            if (hostCompanyOrHostFamily.BillingStreet!=null && findSpecialCharacter(hostCompanyOrHostFamily.BillingStreet))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/Host Family Billing Street contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.ExchangeVisitor.address1 = hostCompanyOrHostFamily.BillingStreet ;
                                
                                     //by Anna D-01879 
                            if (hostCompanyOrHostFamily.BillingCity!=null && findSpecialCharacter(hostCompanyOrHostFamily.BillingCity))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/Host Family Billing City contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.ExchangeVisitor.city = hostCompanyOrHostFamily.BillingCity;
                                //////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                
                                indreq.ExchangeVisitor.stateCode = hostCompanyOrHostFamily.BillingState ;
                                indreq.ExchangeVisitor.postalCode = matchAndReplace('-.*',hostCompanyOrHostFamily.BillingPostalCode,'') ;
                                if (hostCompanyOrHostFamily.SEVIS_Address_Override__c==true)
                                {
                                    system.debug('*** hostCompanyOrHostFamily.SEVIS_Address_Override__c==true');
                                    indreq.ExchangeVisitor.explanationCode='OO';
                                    indreq.ExchangeVisitor.explanation=hostCompanyOrHostFamily.SEVIS_Address_Override_Reason__c;
                                }
                            }
                        }
                        else
                        {   ///////////////////////////////////////////////////////////////////////////////////////////////////////
                            //by Anna D-01879 
                            if (hostCompanyOrHostFamily.BillingStreet!=null && findSpecialCharacter(hostCompanyOrHostFamily.BillingStreet))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/Host Family Billing Street contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.ExchangeVisitor.address1 = hostCompanyOrHostFamily.BillingStreet ;
                            //by Anna D-01879 
                             if (hostCompanyOrHostFamily.BillingCity!=null && findSpecialCharacter(hostCompanyOrHostFamily.BillingCity))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/Host Family Billing City contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.ExchangeVisitor.city = hostCompanyOrHostFamily.BillingCity;
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////
                            indreq.ExchangeVisitor.stateCode = hostCompanyOrHostFamily.BillingState ;
                            indreq.ExchangeVisitor.postalCode = matchAndReplace('-.*',hostCompanyOrHostFamily.BillingPostalCode,'') ;
                            if (hostCompanyOrHostFamily.SEVIS_Address_Override__c==true)
                            {
                                indreq.ExchangeVisitor.explanationCode='OO';
                                indreq.ExchangeVisitor.explanation=hostCompanyOrHostFamily.SEVIS_Address_Override_Reason__c;
                            }
                        }
                        //SEVIS - 102 (End)
                    }
                    //SEVIS - 102 (Start)
                    else
                    {
                        if (engagement.Sevis_UEV_U_USAdd__c || engagement.Sevis_UEV_Val_USAdd__c)
                        {
                            AvoidNoAsses = true;
                            engagement.Sevis_Skipped_Processing_Reason__c = 'Validation cannot be sent without US Address';
                           // system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                        }
                    }
                    //SEVIS - 102 (End)
                }
                
                sevis.SEVIS_Request_Sent_At__c = DateTime.now();
                
                //PersonAccount goes here
                if(engagement.SEVIS_ID__c != NULL)
                {
                    indreq.ExchangeVisitor.sevisId = engagement.SEVIS_ID__c.mid(1,engagement.SEVIS_ID__c.length());
                }
                else
                {
                    indreq.ExchangeVisitor.sevisId = engagement.SEVIS_ID__c;
                }
                
                indreq.ExchangeVisitor.firstName = participant.FirstName;
                indreq.ExchangeVisitor.lastName = participant.LastName;
                indreq.ExchangeVisitor.middleName = participant.Middle_Name__pc;
                indreq.ExchangeVisitor.birthDate = participant.PersonBirthdate;
                indreq.ExchangeVisitor.genderCode = participant.Gender__pc.left(1);
                indreq.ExchangeVisitor.birthCity = participant.Birth_City__pc;
                 indreq.ExchangeVisitor.emailAddress = participant.PersonEmail;
                indreq.ExchangeVisitor.birthCountryCode = getCountryCode(participant.Birth_Country__pc);
                indreq.ExchangeVisitor.citizenshipCountryCode = getCountryCode(participant.Citizenship__pc);
                indreq.ExchangeVisitor.residenceCountryCode = getCountryCode(participant.Legal_Residence__pc);
                //Engagement information goes here
                
                //Change for AuPaircare Extension(Start)
                if (engagement.SEVIS_Position__c != NULL)
                    indreq.ExchangeVisitor.positionCode = matchAndReplace(' ',engagement.SEVIS_Position__c.mid(4,engagement.SEVIS_Position__c.length()),'_').toUpperCase() ;
                
                if(engagement.Intrax_Program__c == 'AuPairCare' && engagement.Parent_Engagement__c != NULL && engagement.Parent_Engagement_Start__c != NULL)
                {
                    indreq.ExchangeVisitor.prgStartDate = engagement.Parent_Engagement_Start__c;
                }
                else
                {
                    indreq.ExchangeVisitor.prgStartDate = engagement.Engagement_Start__c ;
                }
                //Change for AuPaircare Extension(End)
                
                indreq.ExchangeVisitor.prgEndDate = engagement.Engagement_End__c ;
                indreq.ExchangeVisitor.newprgEndDate = engagement.Engagement_End__c;
                if (engagement.SEVIS_Program__c != NULL)
                    indreq.ExchangeVisitor.categoryCode = matchAndReplace(' ',engagement.SEVIS_Program__c.mid(3,engagement.SEVIS_Program__c.length()),'_').toUpperCase() ;
                if (engagement.SEVIS_Occupation__c != NULL)
                // indreq.ExchangeVisitor.occupationCategoryCode = matchAndReplace(' ',engagement.SEVIS_Occupation__c.mid(3,engagement.SEVIS_Occupation__c.length()),'_').toUpperCase() ;                                                          
                 
                    {
                        // Defect D-01155 
                    if (engagement.SEVIS_Occupation__c=='02-Information Media and Communications')
                 indreq.ExchangeVisitor.occupationCategoryCode ='INFO_MEDIA_COMMUNICATION';
                 else if (engagement.SEVIS_Occupation__c=='04-Management Business, Commerce and Finance')
                 indreq.ExchangeVisitor.occupationCategoryCode ='MANAGEMENT_BUSINESS_COMMERCE_FINANCE';
                 else if (engagement.SEVIS_Occupation__c=='07-The Sciences, Engineering, Architecture, Mathematics and Industrial Occupations')
                 indreq.ExchangeVisitor.occupationCategoryCode ='SCIENCE_ENGINEERING_ARCHITECTURE_MATH_INDUSTRY';
                 else if (engagement.SEVIS_Occupation__c=='10-Public Administration and Law')
                 indreq.ExchangeVisitor.occupationCategoryCode ='PUBLIC_ADMIN_LAW';
                 else if (engagement.SEVIS_Occupation__c=='12-Hospitality Tourism')
                 indreq.ExchangeVisitor.occupationCategoryCode ='HOSPITALITY_TOURISM';
                 else  indreq.ExchangeVisitor.occupationCategoryCode = matchAndReplace(' ',engagement.SEVIS_Occupation__c.mid(3,engagement.SEVIS_Occupation__c.length()),'_').toUpperCase() ;                                                          
               }
                   
                if (engagement.SEVIS_Subject_Code__c != NULL)
                    indreq.ExchangeVisitor.programSubjectCode = 'D'+matchAndReplace('\\.',engagement.SEVIS_Subject_Code__c.right(7),'_');
                if (engagement.Received_US_Govt_Funds__c)
                    indreq.ExchangeVisitor.receivedUSGovtFunds = 'True';
                else
                    indreq.ExchangeVisitor.receivedUSGovtFunds = 'False';
                
               //Following are added to push it through. Not defined in mapping XLS:
               
               indreq.ExchangeVisitor.printBio = 'True';
               indreq.ExchangeVisitor.printForm = 'True';
               indreq.ExchangeVisitor.printProgramEditSubject = 'True';
               if ((engagement.Intrax_Program__c == 'Work Travel' || engagement.Intrax_Program__c == 'Internship') && !OtherSoAType){
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  //by Anna D-01879 
                            if (Position.Title__c!=null && findSpecialCharacter(Position.Title__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.Title contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.ExchangeVisitor.programSubjectRemarks = Position.Title__c;
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                //SEVIS 83 (Start)
                if (engagement.SEVIS_ID__c != '' && engagement.SEVIS_ID__c != NULL)
                {
                    
                    //by Anna D-01879 
                            if (Position.Title__c!=null && findSpecialCharacter(Position.Title__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.Title contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else                        
                                indreq.ExchangeVisitor.ProgramEditSubjectRemarks = Position.Title__c;
                }
                //SEVIS 83 (End)
                //Pick Opportunity Contact Role of Primary Member and Get First Name and Last Name
                String hcContactFNLN = '';
                List<OpportunityContactRole> ocr = [Select o.Role, o.OpportunityId, o.Id, o.ContactId From OpportunityContactRole o where OpportunityId = :position.Host_Opportunity_Id__c and Role = 'Primary Leader'];
                if (ocr.size() > 0){
                    List<Contact> primaryHCContact = [select firstName, lastName from Contact where Id = :ocr[0].ContactId];
                    if (primaryHCContact.size() > 0)
                        hcContactFNLN = primaryHCContact[0].firstName + ' ' + primaryHCContact[0].lastName;
                }
                //indreq.SiteOfActivity.remarks = Position.Title__c + ';' + hcContactFNLN + ';' + hostCompanyOrHostFamily.Phone;
                system.debug ('*** Chris McFadden examining problematic Phone number - phone number is: ' + hostCompanyOrHostFamily.Phone);
                indreq.ExchangeVisitor.phoneNumber = matchAndReplace('-',matchAndReplace('[) ]',matchAndReplace('[(]',hostCompanyOrHostFamily.Phone,''),''),'');
                
                if (engagement.Intrax_Program__c == 'Internship')
                indreq.SiteOfActivity.remarks = Position.Title__c ;
                else 
                indreq.SiteOfActivity.remarks = Position.Title__c + ';' + hcContactFNLN + ';' + hostCompanyOrHostFamily.Phone;

                system.debug('indreq.SiteOfActivity.remarks'+indreq.SiteOfActivity.remarks);
               }
               
               
               
               // phone number for Ayusa
               else
               {
                //B-02571  (Start)
                if(engagement.Intrax_Program__c == 'AuPairCare')
                {
                    indreq.ExchangeVisitor.programSubjectRemarks = 'Au Pair Program';
                    indreq.SiteOfActivity.remarks = 'Au Pair SOA Update';
                }
                else
                {
                    indreq.ExchangeVisitor.programSubjectRemarks = 'None';
                }
                //B-02571  (End)
                
               // system.debug ('*** Chris McFadden examining problematic Phone number - phone number is: ' + hostCompanyOrHostFamily.Phone);
                if (!ayusaWOMatch && !OtherSoAType)
                {
                    indreq.ExchangeVisitor.phoneNumber = matchAndReplace('-',matchAndReplace('[) ]',matchAndReplace('[(]',hostCompanyOrHostFamily.Phone,''),''),'');
                }
               }
                
                
                
                indreq.ExchangeVisitor.miscFundsName = engagement.Other_Org_Name__c;
                if (engagement.Personal_Funds__c != NULL)
                    indreq.ExchangeVisitor.personal = matchAndReplace(',',engagement.Personal_Funds__c.format(),'') ;
                if (engagement.Total_Compensation__c != NULL)
                    indreq.ExchangeVisitor.miscFundsAmount = matchAndReplace(',',engagement.Total_Compensation__c.format(),'');
                //Site of Activity goes here
                if (!ayusaWOMatch && !OtherSoAType){
                    if (hostCompanyOrHostFamily.Account_Name_Legal__c != null )
                        indreq.SiteOfActivity.siteName =  truncate(hostCompanyOrHostFamily.Account_Name_Legal__c,60);
                    else
                        indreq.SiteOfActivity.siteName =  truncate(hostCompanyOrHostFamily.Name,60);
                    
                    system.debug('SITENAME!!!:'+truncate(indreq.SiteOfActivity.siteName,60));    
                    
                    if (school.size() == 0){
                        //B-02571  (Start)
                        if(engagement.Intrax_Program__c == 'AuPairCare')
                        {
                            if (hostCompanyOrHostFamily.BillingStreet == '' || hostCompanyOrHostFamily.BillingCity == '' || hostCompanyOrHostFamily.BillingState == '' || hostCompanyOrHostFamily.BillingPostalCode == '' || hostCompanyOrHostFamily.BillingStreet == NULL || hostCompanyOrHostFamily.BillingCity == NULL || hostCompanyOrHostFamily.BillingState == NULL || hostCompanyOrHostFamily.BillingPostalCode == NULL)
                            {
                                AvoidNoAsses = true;
                                engagement.Sevis_Skipped_Processing_Reason__c = 'Missing Site of Activity Address';
                            }
                            else
                            {   
                                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                   //by Anna D-01879 
                            if (hostCompanyOrHostFamily.BillingStreet!=null && findSpecialCharacter(hostCompanyOrHostFamily.BillingStreet))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/Host Family Billing Street contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.SiteOfActivity.address1 = hostCompanyOrHostFamily.BillingStreet ;
                                
                                  //by Anna D-01879 
                            if (hostCompanyOrHostFamily.BillingCity!=null && findSpecialCharacter(hostCompanyOrHostFamily.BillingCity))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/Host Family Billing City contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else indreq.SiteOfActivity.city = hostCompanyOrHostFamily.BillingCity;
                            
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            
                                indreq.SiteOfActivity.stateCode = hostCompanyOrHostFamily.BillingState ;
                                indreq.SiteOfActivity.postalCode = matchAndReplace('-.*',hostCompanyOrHostFamily.BillingPostalCode,'') ;
                                if (hostCompanyOrHostFamily.SEVIS_Address_Override__c==true)
                                {
                                    system.debug('*** hostCompanyOrHostFamily.SEVIS_Address_Override__c==true');
                                    indreq.SiteOfActivity.explanationCode='OO';
                                    indreq.SiteOfActivity.explanation=hostCompanyOrHostFamily.SEVIS_Address_Override_Reason__c;
                                }
                            }
                            
                        }
                        //B-02571  (End)
                        else
                        {
                            //SEVIS - 102 (Start)
                            if (position.Street__c == '' || position.City__c == '' || position.State__c == '' || position.Postal_Code__c == '' || position.Street__c == NULL || position.City__c == NULL || position.State__c == NULL || position.Postal_Code__c == NULL)
                            {
                                AvoidNoAsses = true;
                                engagement.Sevis_Skipped_Processing_Reason__c = 'Missing Site of Activity Address';
                                //system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }
                            else
                            {        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                       //by Anna D-01879 
                            if (position.Street__c!=null && findSpecialCharacter(position.Street__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.Street contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.SiteOfActivity.address1 = position.Street__c;
                                       //by Anna D-01879 
                            if (position.Street_2__c!=null && findSpecialCharacter(position.Street_2__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.Street 2 contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.SiteOfActivity.address2 = position.Street_2__c;
                                       //by Anna D-01879 
                            if (position.City__c!=null && findSpecialCharacter(position.City__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.City contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                indreq.SiteOfActivity.city = position.City__c;
                           ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                indreq.SiteOfActivity.stateCode = position.State__c;
                                indreq.SiteOfActivity.postalCode = matchAndReplace('-.*',position.Postal_Code__c,'');
                                if (position.SEVIS_Address_Override__c==true)
                                        {
                                            indreq.SiteOfActivity.explanationCode='OO';
                                            indreq.SiteOfActivity.explanation=position.SEVIS_Address_Override_Reason__c;
                                        }
                            }
                            //SEVIS - 102 (End)
                        }
                     }
                    else{
                        //SEVIS - 102 (Start)
                        if (school[0].ShippingStreet == '' || school[0].ShippingCity == '' || school[0].ShippingState == '' || school[0].ShippingPostalCode == '' || school[0].ShippingStreet == NULL || school[0].ShippingCity == NULL || school[0].ShippingState == NULL || school[0].ShippingPostalCode == NULL)
                        {
                            AvoidNoAsses = true;
                           // system.debug('Sevis_Skipped_Processing_Reason__c = No valid match tagged to the engagement;');
                          //  system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            engagement.Sevis_Skipped_Processing_Reason__c = 'Missing Site of Activity Address';
                        }
                        else
                        {
                            indreq.SiteOfActivity.siteName = truncate(school[0].Name,60);
                            indreq.SiteOfActivity.address1 = school[0].ShippingStreet;
                            indreq.SiteOfActivity.city = school[0].ShippingCity;
                            indreq.SiteOfActivity.stateCode = school[0].ShippingState;
                            indreq.SiteOfActivity.postalCode = matchAndReplace('-.*',school[0].ShippingPostalCode,'');
                            if (school[0].SEVIS_Address_Override__c==true)
                                    {
                                        indreq.SiteOfActivity.explanationCode='OO';
                                        indreq.SiteOfActivity.explanation=school[0].SEVIS_Address_Override_Reason__c;
                                    }
                        }
                        //SEVIS - 102 (End)
                    } 
                    
                    if(engagement.Intrax_Program__c == 'AuPairCare')
                    {
                        // B-02571  (Start)
                          //by Anna D-01879 
                            if (Position.Owner.FirstName!=null && findSpecialCharacter(Position.Owner.FirstName))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position Owner First Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                        indreq.ExchangeVisitor.resAddrContactFirstName = Position.Owner.FirstName;
                          //by Anna D-01879 
                            if (Position.Owner.LastName!=null && findSpecialCharacter(Position.Owner.LastName))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position Owner Last Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                        indreq.ExchangeVisitor.resAddrContactLastName = Position.Owner.LastName;
                        // B-02571  (End)
                    }
                    
                    // B-02571  (Added AuPairCare in If Condition)
                    if(engagement.Intrax_Program__c == 'Ayusa') // D-01797-- || engagement.Intrax_Program__c == 'AuPairCare')
                    {
                        indreq.ExchangeVisitor.resAddrType='HST';
                        
                           //by Anna D-01879 
                            if (hostCompanyOrHostFamily.FirstName!=null && findSpecialCharacter(hostCompanyOrHostFamily.FirstName))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'HostCompany/Host Family FirstName contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.ExchangeVisitor.resAddrHostFamilyPContactFirstName = hostCompanyOrHostFamily.FirstName ;
                            
                           //by Anna D-01879 
                            if (hostCompanyOrHostFamily.LastName!=null && findSpecialCharacter(hostCompanyOrHostFamily.LastName))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/HostFamily LastName contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.ExchangeVisitor.resAddrHostFamilyPContactLastName = hostCompanyOrHostFamily.LastName;
                        
                        
                        
                        if (Members.size() > 0 ){
                            ///////////////////////////////////////////////////////////////////////////////////////
                             //by Anna D-01879 
                            if (Members[0].First_Name__c!=null && findSpecialCharacter(Members[0].First_Name__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Members First Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.ExchangeVisitor.resAddrHostFamilySContactFirstName = Members[0].First_Name__c;
                            
                             //by Anna D-01879 
                            if (Members[0].Last_Name__c!=null && findSpecialCharacter(Members[0].Last_Name__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Members Last Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.ExchangeVisitor.resAddrHostFamilySContactLastName = Members[0].Last_Name__c;
                            ///////////////////////////////////////////////////////////////////////////////////////
                        }
                        indreq.ExchangeVisitor.resAddrHostFamilyPhone = matchAndReplace('[)] ',matchAndReplace('[(]',hostCompanyOrHostFamily.Phone,''),'-');
                    }
                    indreq.SiteOfActivity.primarySite = match[0].Is_Primary_SOA__c;
                    indreq.SiteOfActivity.locationId = match[0].Id;
                    
                    
                    //B-02525 (Start)
                    //if (engagement.Intrax_Program__c == 'Internship' && (engagement.SEVIS_ID__c == '' || engagement.SEVIS_ID__c == NULL))
                    if (engagement.Intrax_Program__c == 'Internship' )
                    {
                        List<Development_Plan__c> DevelopmentPlanList = match[0].Development_Plans__r;
                        
                        if (DevelopmentPlanList != NULL && DevelopmentPlanList.size() > 0)
                        {
                            indreq.TIPP = new iSevisWebServiceWrapper.TIPP(); 
                            indreq.TIPP.TIPPPhases = new list<iSevisWebServiceWrapper.TIPPPhase>(); 
                            
                            indreq.TIPP.emailAddress = participant.PersonEmail;
                            if (engagement.Intrax_Program_Options__c != NULL && engagement.Intrax_Program_Options__c.contains('WEST'))
                            {
                                indreq.TIPP.tippExemptProgram = 'KW';
                                indreq.TIPP.isIWT = true;
                            }
                            else
                            {
                                indreq.TIPP.isIWT = false;
                            }
                            //else indreq.TIPP.tippExemptProgram = 'IWT';
                            
                            if (engagement.SEVIS_ID__c == '' || engagement.SEVIS_ID__c == NULL)
                            {
                                indreq.TIPP.print7002 = true;
                            }
                            else if (engagement.Sevis_UEV_SOA_Add__c || engagement.Sevis_UEV_SOA_Edit__c )
                            {
                                indreq.TIPP.print7002 = false;
                            }
                            else indreq.TIPP.print7002 = false;
                            
                            //indreq.TIPP.siteName = position.Site_Name__c;
                            //by Anna D-01879                          
                            if (engagement.SEVIS_Field_of_Study__c!=null && findSpecialCharacter(engagement.SEVIS_Field_of_Study__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'SEVIS Field of Study contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.fieldOfStudy = engagement.SEVIS_Field_of_Study__c;
                            
                            indreq.TIPP.yearsOfExperience = String.ValueOf(Integer.ValueOf(engagement.Years_of_Experience__c));
                            
                             //by Anna D-01879 
                            if (engagement.SEVIS_Degree_Type__c!=null && findSpecialCharacter(engagement.SEVIS_Degree_Type__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'SEVIS Degree Type contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.typeOfDegree = engagement.SEVIS_Degree_Type__c;
                            
                            
                            if(engagement.Graduation_Date__c != NULL)
                            {
                                indreq.TIPP.dateAwardedOrExpected = Date.ValueOf(engagement.Graduation_Date__c);
                            }
                            else
                            {
                                indreq.TIPP.dateAwardedOrExpected = engagement.Graduation_Date__c;
                            }
                            
                            //indreq.TIPP.employerID = hostCompanyOrHostFamily.EIN__c;
                            string einnum = hostCompanyOrHostFamily.EIN__c;
                            if (einnum != NULL && einnum != '')
                            {
                                indreq.TIPP.employerID = einnum.replace('-', '');
                            }
                            else indreq.TIPP.employerID = einnum;
                            
                            indreq.TIPP.fullTimeEmployees = String.ValueOf(hostCompanyOrHostFamily.NumberOfEmployees);
                            
                            if (hostCompanyOrHostFamily.Company_Annual_Revenue__c != NULL && hostCompanyOrHostFamily.Company_Annual_Revenue__c == '0M - 3M')
                            {
                                indreq.TIPP.annualRevenue = '01';
                            }
                            else if (hostCompanyOrHostFamily.Company_Annual_Revenue__c != NULL && hostCompanyOrHostFamily.Company_Annual_Revenue__c == '3M - 10M')
                            {
                                indreq.TIPP.annualRevenue = '02';
                            }
                            else if (hostCompanyOrHostFamily.Company_Annual_Revenue__c != NULL && hostCompanyOrHostFamily.Company_Annual_Revenue__c == '10M - 25M')
                            {
                                indreq.TIPP.annualRevenue = '03';
                            }
                            else if (hostCompanyOrHostFamily.Company_Annual_Revenue__c != NULL && hostCompanyOrHostFamily.Company_Annual_Revenue__c == '>25M')
                            {
                                indreq.TIPP.annualRevenue = '04';
                            }
                            
                            //indreq.TIPP.annualRevenue = hostCompanyOrHostFamily.Company_Annual_Revenue__c;
                            
                            //by Anna D-01879 
                            if (hostCompanyOrHostFamily.Website!=null && findSpecialCharacter(hostCompanyOrHostFamily.Website))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Website contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.websiteURL = hostCompanyOrHostFamily.Website;
                            
                            
                            
                            if (hostCompanyOrHostFamily.Has_Workers_Comp__c == true)
                            {
                                indreq.TIPP.workersCompInd = 'Y';
                            }
                            else
                            {
                                indreq.TIPP.workersCompInd = 'N';
                            }
                            
                               //by Anna D-01879 
                            if (hostCompanyOrHostFamily.Worker_Comp_Provider__c!=null && findSpecialCharacter(hostCompanyOrHostFamily.Worker_Comp_Provider__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Worker Comp Provider contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.workersCompCarrier = hostCompanyOrHostFamily.Worker_Comp_Provider__c;
                            
                            if (position.Workers_Comp_Coverage__c == 'Yes')
                            {
                                indreq.TIPP.workersCompForEvInd = 'Y'; 
                            }
                            else if (position.Workers_Comp_Coverage__c == 'No, exempt')
                            {
                                indreq.TIPP.workersCompForEvInd = 'N'; 
                            }
                            else if (position.Workers_Comp_Coverage__c == 'No, but equivalent coverage')
                            {
                                indreq.TIPP.workersCompForEvInd = 'E'; 
                            }
                            /*else
                            {
                                indreq.TIPP.workersCompForEvInd = 'N'; 
                            }*/
                            
                            indreq.TIPP.evHoursPerWeek = string.valueOf(position.Hours_Per_Week__c);
                            if (position.Compensation_Type__c == 'Paid' || position.Compensation_Type__c == 'Stipend')
                            {
                                indreq.TIPP.stipendInd = 'Y'; 
                            }
                            else if (position.Compensation_Type__c == 'Unpaid')
                            {
                            indreq.TIPP.stipendInd = 'N';
                            }
                            indreq.TIPP.stipendAmount = string.valueOf(position.Pay_Rate__c);
                            //indreq.TIPP.stipendFrequency = position.Pay_Rate_Basis__c;
                            if (position.Pay_Rate_Basis__c != NULL && position.Pay_Rate_Basis__c == 'Per Hour')
                            {
                                indreq.TIPP.stipendFrequency = '01';
                            }
                            else if (position.Pay_Rate_Basis__c != NULL && position.Pay_Rate_Basis__c == 'Per Day')
                            {
                                indreq.TIPP.stipendFrequency = '02';
                            }
                            else if (position.Pay_Rate_Basis__c != NULL && position.Pay_Rate_Basis__c == 'Per Week')
                            {
                                indreq.TIPP.stipendFrequency = '03';
                            }
                            else if (position.Pay_Rate_Basis__c != NULL && position.Pay_Rate_Basis__c == 'Per Month')
                            {
                                indreq.TIPP.stipendFrequency = '04';
                            }
                            else if (position.Pay_Rate_Basis__c != NULL && position.Pay_Rate_Basis__c == 'Per Year')
                            {
                                indreq.TIPP.stipendFrequency = '05';
                            }
                            
                           /* if (engagement.SEVIS_ID__c == '' || engagement.SEVIS_ID__c == NULL)
                            {
                                indreq.TIPP.tippAction = 'ADD_TIPP';
                            }
                            else if (engagement.SEVIS_Update_EV_Add_TIPP__c)
                            {
                                indreq.TIPP.tippAction = 'ADD_TIPP';
                            }
                            else if (engagement.SEVIS_UEV__c)
                            {
                                if (engagement.Sevis_UEV_Bio__c || engagement.Sevis_UEV_Pro_Amend__c || engagement.Sevis_UEV_SOA_Edit__c || engagement.Sevis_UEV_Val_USAdd__c || engagement.Sevis_UEV_U_USAdd__c || engagement.Sevis_UEV_Nonstandard_SoA__c)
                                {
                                    indreq.TIPP.tippAction = 'EDIT_SITE';
                                }
                                else if (engagement.Sevis_UEV_SOA_Add__c )
                                {
                                    indreq.TIPP.tippAction = 'ADD_SITE';
                                }
                                else
                                {
                                    indreq.TIPP.tippAction = 'ADD_TIPP';
                                }
                            }
                            else indreq.TIPP.tippAction = 'ADD_TIPP';*/
                            indreq.TIPP.tippAction = 'ADD_TIPP';
                            
                            if (position.Non_Monetary_Comp_Value__c != NULL)
                            {
                                if(position.Non_Monetary_Comp_Description__c != NULL)
                                {
                                    
                                      //by Anna D-01879 
                                if (findSpecialCharacter(position.Non_Monetary_Comp_Description__c))
                                {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Non Monetary Comp.Description contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                                }    
                            else
                                    indreq.TIPP.nonMonetaryComp = string.valueOf(position.Non_Monetary_Comp_Value__c) + ' ' + position.Non_Monetary_Comp_Description__c;
                                }
                                else
                                {
                                    indreq.TIPP.nonMonetaryComp = string.valueOf(position.Non_Monetary_Comp_Value__c);
                                }
                            }
                            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                             //by Anna D-01879 
                            if (position.Position_Supervisor__r.LastName!=null && findSpecialCharacter(position.Position_Supervisor__r.LastName))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position Supervisor Last Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.supervisorLastName = position.Position_Supervisor__r.LastName;
                            
                                                        
                             //by Anna D-01879 
                            if (position.Position_Supervisor__r.FirstName!=null && findSpecialCharacter(position.Position_Supervisor__r.FirstName))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position Supervisor First Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.supervisorFirstName = position.Position_Supervisor__r.FirstName;
                            
                             //by Anna D-01879 
                            if (position.Position_Supervisor__r.title!=null && findSpecialCharacter(position.Position_Supervisor__r.title))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'SEVIS Degree Type contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.supervisorTitle = position.Position_Supervisor__r.title;
                            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            
                            
                            //indreq.TIPP.supervisorPhone = matchAndReplace('[)] ',matchAndReplace('[(]',position.Position_Supervisor__r.Phone,''),'-');
                            indreq.TIPP.supervisorPhone =  matchAndReplace('-',matchAndReplace('[) ]',matchAndReplace('[(]',position.Position_Supervisor__r.Phone,''),''),'');
                            indreq.TIPP.supervisorEmail = position.Position_Supervisor__r.Email;
                            //indreq.TIPP.supervisorFax  = matchAndReplace('[)] ',matchAndReplace('[(]',hostCompanyOrHostFamily.Fax,''),'-');
                            indreq.TIPP.supervisorFax  = matchAndReplace('-',matchAndReplace('[) ]',matchAndReplace('[(]',hostCompanyOrHostFamily.Fax,''),''),'');
                            
                            
                            if(match[0].ARO_Signed_TIPP__c != NULL)
                            {
                                indreq.TIPP.officialSignatureDate = Date.ValueOf(match[0].ARO_Signed_TIPP__c);
                                //indreq.TIPP.officialUserName = AROUsername;
                                if (AROMap != NULL && AROMap.get(match[0].ARO_Signed_TIPP_Name__c) != NULL)
                                {
                                    indreq.TIPP.officialUserName = AROMap.get(match[0].ARO_Signed_TIPP_Name__c);
                                }
                                else
                                {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'ARO Official Signer Name missing in Match.';
                                }
                            }
                           /* else
                            {
                                indreq.TIPP.officialSignatureDate = match[0].ARO_Signed_TIPP__c;
                            }*/
                            
                            if(match[0].PT_Signed_TIPP__c != NULL)
                            {
                                indreq.TIPP.evSignatureDate = Date.ValueOf(match[0].PT_Signed_TIPP__c);
                            }
                            /*else
                            {
                                indreq.TIPP.evSignatureDate = match[0].PT_Signed_TIPP__c;
                            }*/
                            
                            //indreq.TIPP.siteID = '';
                            ///////////////////////////////////////////////////////////////////////////////////////////////////
                            //by Anna D-01879 
                            if (position.Street__c!=null && findSpecialCharacter(position.Street__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.Street contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.address1 = position.Street__c;
                            //by Anna D-01879 
                            if (position.Street_2__c!=null && findSpecialCharacter(position.Street_2__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.Street 2 contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.address2 = position.Street_2__c;
                            //by Anna D-01879 
                            if (position.City__c!=null && findSpecialCharacter(position.City__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Position.City contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.city = position.City__c;
                            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            indreq.TIPP.stateCode = position.State__c;
                            indreq.TIPP.postalCode = position.Postal_Code__c;
                            if (position.SEVIS_Address_Override__c==true)
                            {
                                 indreq.TIPP.explanationCode = 'OO';
                                 indreq.TIPP.explanation = position.SEVIS_Address_Override_Reason__c;
                            }
                            
                            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                             //by Anna D-01879 
                            if (hostCompanyOrHostFamily.Name!=null && findSpecialCharacter(hostCompanyOrHostFamily.Name))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Host Company/Host Family Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                            indreq.TIPP.siteName = truncate(hostCompanyOrHostFamily.Name,60);
                            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            if (match[0].Is_Primary_SOA__c == true)
                            {
                                indreq.TIPP.primarySite = true; 
                            }
                            else
                            {
                                indreq.TIPP.primarySite = false; 
                            }
                            
                            indreq.TIPP.locationId = match[0].Id;
                            indreq.TIPP.remarks = Position.Title__c ;
                            
                            //Phase code (Start) 
                            
                            for(Development_Plan__c devPlan :DevelopmentPlanList)
                            {
                                //indreq.TIPPPhase.phaseId = 
                                /*indreq.TIPPPhase.phaseName = devPlan.Name;
                                indreq.TIPPPhase.startDate = devPlan.Start__c;
                                indreq.TIPPPhase.endDate = devPlan.End__c;
                                indreq.TIPPPhase.trainingField = position.Functional_Areas__c;
                                indreq.TIPPPhase.superLastName = devPlan.Supervisor_Last_Name__c;
                                indreq.TIPPPhase.superFirstName = devPlan.Supervisor_First_Name__c;
                                indreq.TIPPPhase.superMiddleInitial = '';
                                indreq.TIPPPhase.superTitle = devPlan.Supervisor_Title__c;
                                indreq.TIPPPhase.superEmail = devPlan.Supervisor_Email__c;
                                indreq.TIPPPhase.superPhone = devPlan.Supervisor_Phone__c;
                                indreq.TIPPPhase.superPhoneExt = '';
                                indreq.TIPPPhase.superSignatureDate = devPlan.Supervisor_Signed_TIPP__c;
                                indreq.TIPPPhase.evRole = devPlan.Description__c;
                                indreq.TIPPPhase.goalsAndObjectives = devPlan.Goal__c;
                                indreq.TIPPPhase.supervisorAndQualifications = devPlan.Supervision__c;
                                indreq.TIPPPhase.culturalActivities = devPlan.Cultural_Component__c;
                                indreq.TIPPPhase.skillsLearned = devPlan.Learning_Outcome__c;
                                indreq.TIPPPhase.teachingMethod = devPlan.Instructional_Methods__c;
                                indreq.TIPPPhase.howCompetencyMeasured = devPlan.Evaluation_Methods__c;
                                indreq.TIPPPhase.additionalRemarks = devPlan.Additional_Remarks__c;
                                indreq.TIPPPhases.add(indreq.TIPPPhase);*/
                                iSevisWebServiceWrapper.TIPPPhase TIPPPhase = new iSevisWebServiceWrapper.TIPPPhase(); 
                                
                                            //by Anna D-01879 
                            if (devPlan.Name!=null && findSpecialCharacter(devPlan.Name))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.phaseName = devPlan.Name;
                                
                                TIPPPhase.DevelopmentPlanId = devPlan.Id;
                                //TIPPPhase.startDate = devPlan.Start__c;
                                if (devPlan.Start__c != NULL)
                                {
                                    //Date TippSatrtDate = devPlan.Start__c;
                                   //TIPPPhase.startDate = TippSatrtDate.format('yyyy-mm-dd');
                                   TIPPPhase.startDate = Date.Valueof(devPlan.Start__c);
                                }
                                else
                                {
                                    TIPPPhase.startDate = devPlan.Start__c;
                                }
                                
                                //TIPPPhase.endDate = devPlan.End__c;
                                if (devPlan.End__c != NULL)
                                {
                                    //Date TippEndDate = devPlan.End__c;
                                   // TIPPPhase.endDate = TippEndDate.format('yyyy-mm-dd');
                                   TIPPPhase.endDate = Date.Valueof(devPlan.End__c );
                                }
                                else
                                {
                                    TIPPPhase.endDate = devPlan.End__c;
                                }
                                
                                TIPPPhase.trainingField = position.Functional_Areas__c;
                                
                                
                                       //by Anna D-01879 
                            if (devPlan.Supervisor_Last_Name__c!=null && findSpecialCharacter(devPlan.Supervisor_Last_Name__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Supervisor Last Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.superLastName = devPlan.Supervisor_Last_Name__c;
                                
                                       //by Anna D-01879 
                            if (devPlan.Supervisor_First_Name__c!=null && findSpecialCharacter(devPlan.Supervisor_First_Name__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Supervisor First Name contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.superFirstName = devPlan.Supervisor_First_Name__c;
                                
                                TIPPPhase.superMiddleInitial = '';
                                
                                       //by Anna D-01879 
                            if (devPlan.Supervisor_Title__c!=null && findSpecialCharacter(devPlan.Supervisor_Title__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Supervisor Title contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.superTitle = devPlan.Supervisor_Title__c;
                                
                                TIPPPhase.superEmail = devPlan.Supervisor_Email__c;
                                //TIPPPhase.superPhone = matchAndReplace('[)] ',matchAndReplace('[(]',devPlan.Supervisor_Phone__c,''),'-');
                                TIPPPhase.superPhone = matchAndReplace('-',matchAndReplace('[) ]',matchAndReplace('[(]',devPlan.Supervisor_Phone__c,''),''),'');
                                TIPPPhase.superPhoneExt = '';
                                if(devPlan.Supervisor_Signed_TIPP__c != NULL)
                                {
                                    TIPPPhase.superSignatureDate = Date.ValueOf(devPlan.Supervisor_Signed_TIPP__c);
                                }
                                else
                                {
                                    TIPPPhase.superSignatureDate = devPlan.Supervisor_Signed_TIPP__c;
                                }
                                
                                       
                                   //by Anna D-01879 
                            if (devPlan.Description__c!=null && findSpecialCharacter(devPlan.Description__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Description contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.evRole = devPlan.Description__c;
                                
                                   //by Anna D-01879 
                            if (devPlan.Goal__c!=null && findSpecialCharacter(devPlan.Goal__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Goal contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.goalsAndObjectives = devPlan.Goal__c;
                                
                                
                                     //by Anna D-01879 
                            if (devPlan.Supervision__c!=null && findSpecialCharacter(devPlan.Supervision__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Supervision contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.supervisorAndQualifications = devPlan.Supervision__c;
                                     //by Anna D-01879 
                            if (devPlan.Cultural_Component__c!=null && findSpecialCharacter(devPlan.Cultural_Component__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Cultural Component contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.culturalActivities = devPlan.Cultural_Component__c;
                                     //by Anna D-01879 
                            if (devPlan.Learning_Outcome__c!=null && findSpecialCharacter(devPlan.Learning_Outcome__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Learning Outcome contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.skillsLearned = devPlan.Learning_Outcome__c;
                                     //by Anna D-01879 
                            if (devPlan.Instructional_Methods__c!=null && findSpecialCharacter(devPlan.Instructional_Methods__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Instructional Methods contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.teachingMethod = devPlan.Instructional_Methods__c;
                                     //by Anna D-01879 
                            if (devPlan.Evaluation_Methods__c!=null && findSpecialCharacter(devPlan.Evaluation_Methods__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Evaluation Methods contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.howCompetencyMeasured = devPlan.Evaluation_Methods__c;
                                     //by Anna D-01879 
                            if (devPlan.Additional_Remarks__c!=null && findSpecialCharacter(devPlan.Additional_Remarks__c))
                            {
                                    AvoidNoAsses = true;
                                    engagement.Sevis_Skipped_Processing_Reason__c = 'Dev.Plan Additional Remarks contains special character';
                                    system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                            }    
                            else
                                TIPPPhase.additionalRemarks = devPlan.Additional_Remarks__c;
                              /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
                                indreq.TIPP.TIPPPhases.add(TIPPPhase);
                            }
                            
                            //Phase code (End)
                        }
                        
                    }
                    //B-02525 (End)
                }
                else if (ayusaWOMatch){
                    indreq.SiteOfActivity.siteName =  truncate(constants.get('NoMatchSOA').get('AyusaNoMatch_SOA_SiteName'),60);
                    indreq.SiteOfActivity.address1 = constants.get('NoMatchSOA').get('AyusaNoMatch_SOA_Address1') ;
                    indreq.SiteOfActivity.address2 = constants.get('NoMatchSOA').get('AyusaNoMatch_SOA_Address2') ;
                    indreq.SiteOfActivity.city = constants.get('NoMatchSOA').get('AyusaNoMatch_SOA_City') ;
                    indreq.SiteOfActivity.stateCode = constants.get('NoMatchSOA').get('AyusaNoMatch_SOA_State_Code') ;
                    indreq.SiteOfActivity.postalCode = constants.get('NoMatchSOA').get('AyusaNoMatch_SOA_Postal_Code') ;
                }
                
                //B-02618  (Start)
                if (ayusaWOMatch || OtherSoAType)
                {
                    indreq.ExchangeVisitor.phoneNumber = matchAndReplace('-',matchAndReplace('[) ]',matchAndReplace('[(]','415 434-5440',''),''),'');
                }
                //B-02618  (End)
                
                             
                
                if (AvoidNoAsses == false)
                {
                    if (!checkQualityofData(indreq,engagement)){
                    system.debug('checkQualityofDataaaaaaaaaaaaaaaaaaaaaaaaaa');
                    skippedEngagements.add(engagement);
                    return false;
                    }
                    else
                    {
                        system.debug('AvoidNoAsses' + AvoidNoAsses);
                        system.debug('Nooooooooooooooooo skip');
                        return true;
                    }
                }
                else
                {
                    boolean alradded = false; 
                    for (Engagement__c skipEngagement : skippedEngagements){
                        if (skipEngagement.Id == engagement.Id){
                            alradded = true;
                            break;
                        }
                    }
                    if (alradded == false)
                    {
                        skippedEngagements.add(engagement);
                    }
                    return false;
                }
            } 
            else{
              //  system.debug('Sevis_Skipped_Processing_Reason__c = No valid match tagged to the engagement');
                engagement.Sevis_Skipped_Processing_Reason__c = 'No valid match tagged to the engagement';
                skippedEngagements.add(engagement);
                return false;
            }
    }
    
    public Boolean checkQualityofData(iSevisWebServiceWrapper.exchangeVisitorRequest indreq,Engagement__c engagement){
        
        if (indreq.ExchangeVisitor.prgEndDate == NULL){
            engagement.Sevis_Skipped_Processing_Reason__c = 'Program End Date cannot be null';
          //  system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
            return false;
        }
        if (indreq.ExchangeVisitor.resAddrHostFamilyPhone!= null){
        system.debug('resAddrHostFamilyPhoneeeeeeeeeeeeeeeeeeeeeeeeee' + indreq.ExchangeVisitor.resAddrHostFamilyPhone);
            if (!matches('\\b\\d{3}[-.]?\\d{3}[-.]?\\d{4}\\b',indreq.ExchangeVisitor.resAddrHostFamilyPhone)){
          //  system.debug('indreq.ExchangeVisitor.resAddrHostFamilyPhone  beforeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' + indreq.ExchangeVisitor.resAddrHostFamilyPhone);
                engagement.Sevis_Skipped_Processing_Reason__c = 'Host Account Phone is not XXX-XXX-XXXX format; Current value is:'+indreq.ExchangeVisitor.resAddrHostFamilyPhone;
           //     system.debug('engagement.Sevis_Skipped_Processing_Reason__c' + engagement.Sevis_Skipped_Processing_Reason__c);
                return false;
            }
        }
        return true;
    }
    
    public String getCountryCode(String countryName){
        List<Country_Names__c> countryCodeList = [select Country_Code_2__c,FIPS_Code__c from Country_Names__c where Long_Name__c = :countryName];
        if (countryCodeList.size() > 0)
            return countryCodeList[0].FIPS_Code__c;
        else
            return 'XX';
    }
    
    public String matchAndReplace(String regEx,String sourceString, String replacementString){
         if (sourceString != null){
            // First, instantiate a new Pattern object "MyPattern"
            pattern MyPattern = pattern.compile(regEx);
            
            // Then instantiate a new Matcher object "MyMatcher"
            Matcher MyMatcher = MyPattern.matcher(sourceString);
            
            // You can use the system static method assert to verify the match
            return MyMatcher.replaceAll(replacementString);
         }
         else
            return '';
    }
    
    public Boolean matches(String regEx,String sourceString){
        return pattern.matches(regEx,sourceString);
    }    
  public Boolean findSpecialCharacter(String sourceString){
         if (sourceString != null){
            Boolean b=false;
          // pattern MyPattern = pattern.compile('[^A-Za-z0-9@#\\s]');
          // pattern MyPattern = pattern.compile('[^@#$%&,.;:"`()+!~<>?{}/=+\\w\\s\\*]');
            pattern MyPattern = pattern.compile('[^@#$%&,.;:"`()+_!~<>?{}/=\\w\\s\\]\\[\\*\\|\\-\\^\\p{P}]');          
            Matcher MyMatcher = MyPattern.matcher(sourceString);
            Integer c=0;
            while (MyMatcher.find())
            {
           // Boolean b = MyMatcher.find();
            System.debug('findSpecialCharacter isss:#####'+ MyMatcher.group(0));
            c=c+1;
            }
             System.debug('findSpecialCharacter count is :#####'+ c);
            if (c>0)
            b=true;
             System.debug('findSpecialCharacter is:#####'+ b);
            return b ;
         }
         else
            return false;
    }
    public String truncate(String value, Integer length)
    {
        if (value != null && value.length() > length)
        value = value.substring(0, length);
        return value;
    }
}