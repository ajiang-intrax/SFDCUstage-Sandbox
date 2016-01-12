public without sharing class Notification_Generator {

    /*public Notification_Generator(){
        sendNotifications();
    }*/
    public List<Task> taskList {get; set;}
    public List<Task> taskListNotified {get; set;}
    public List<Match__c> matchList {get; set;}
    public List<Match__c> matchListNotified {get; set;}
    public List<String> months = new List<String>();
    public List<Notification__c> notificationList {get; set;}
    public List<Notification__c> notifications {get; set;}
    public Task task {get; set;}
    public Notification__c notification {get; set;}
    public static List<Assessment__c> assList{get;set;}
    //Aggregation Map
    public Map<Id,Match__c> ProcessedPt {get; set;}
    public Map<Id,Match__c> ProcessedCo {get; set;}
    //Abstraction Map
    public Map<Id,List<Match__c>> NotifyAbtAcc {get; set;} //OuterId - Contact
    public Map<Id,Map<Id,List<Match__c>>> NotifyAbtPos {get; set;}//InnerId-Pos, OuterId-Contact
    public Map<Id,Match__c> NotifyAbtMatch {get; set;} //OuterId - Contact
    public List<String> HFAssRecordTypes{get;set;}
    public List<String> PTAssRecordTypes{get;set;}
    public static boolean MatchingPosFlag=false;
    
    // Global_Constants - Domain URL
    
    public static String globalDomainURL{
        get{
            if(globalDomainURL==null){
                return Global_Constants__c.getInstance().Domain_URL__c;
            }else{
                return globalDomainURL;
            }
        }set;
    }
    
    public static APC_Academy_Details__c academyDetails{
        get{
            if(academyDetails==null){
                
                APC_Academy_Details__c mhc = APC_Academy_Details__c.getInstance();
                if(mhc!=null){
                   return mhc;
                }else{
                    APC_Academy_Details__c mhcAux = new APC_Academy_Details__c();
                    return mhcAux;
                }

            }else{
                return academyDetails;
            }
        }set;
    }
    
    
    //Overloaded constructor for processing Ayusa Assessments
    public Notification_Generator(List<Match__c> matchListBatch){
        matchList = matchListBatch;
        notifications = new List<Notification__c>();
    }
    //Overloaded dummy task based Constructor. Need to remove this and use the above commented one
    public Notification_Generator(List<Task> taskListBatch){
        
    }

    //Generic constructor for UI
    public Notification_Generator(){
                
        notifications = new List<Notification__c>();
        
        matchList = [Select Id,End_Date__c,URL_Monthly_HF__c,Position_Name__c,Participant_Id__c from Match__c m where m.Id in (Select a.Match_Name__c From Assessment__c a where a.Assessment_Date__c = NULL) and  (m.end_date__c = LAST_N_DAYS:30 or m.end_date__c > Today) and m.start_date__c <= Today and m.RecordTypeId in (select Id from RecordType where sObjectType = 'Match__c' and Name='Ayusa')];   
        
    }        
    public static Boolean iAmAlreadyCalled = false;
    
    public static void callAPCNotifications(sObject oldObj,sObject newObj){
        
        try{
        //to avoid duplicate notification being created but allow only Application Participant Accepted
        Boolean flagApp = false;
        Applicant_Info__c OldAppInfoFlag;
        Applicant_Info__c NewAppInfoFlag;
        if(oldObj!=null && oldObj.getsObjectType() == Applicant_Info__c.sObjectType && newObj!=null && newObj.getsObjectType() == Applicant_Info__c.sObjectType){
            OldAppInfoFlag = (Applicant_Info__c)OldObj;
            NewAppInfoFlag = (Applicant_Info__c)newObj;
            if(OldAppInfoFlag.application_stage__c != NewAppInfoFlag.application_stage__c && NewAppInfoFlag.application_stage__c =='Accepted' && NewAppInfoFlag.Type__c =='Participant'){
                flagApp = true; 
            }
        }
        if (iAmAlreadyCalled && flagApp == false ){
            system.debug('@@@@@inside callAPCNotifications()');
            return;
        }else{    
            createAPCNotifications(oldObj,newObj); 
        }
        }catch(Exception e){
            system.debug('*****Error trying to create Dynamic Content for notification callAPCNotifications(): ' + e);
            return;
        }
    }     
    
    public static void createAPCNotifications(sObject oldsObject,sObject newsObject){
            iAmAlreadyCalled = true;               
            string key,specialKey,specialKey2;  

            List<Portal_Content__c> PortalContentList = new List<Portal_Content__c>();
            System.debug('ENTERED NOTIFICATION newsObject.getsObjectType-->'+newsObject.getsObjectType());              
            
            //FORMING THE KEYS FOR APPLICANT INFO OBJECT
            if(oldsObject!= null && newsObject!=null && oldsObject.getsObjectType() == Applicant_Info__c.sObjectType && newsObject.getsObjectType() == Applicant_Info__c.sObjectType){          
                System.debug('ENTERED NOTIFICATION APP INFO-->'+oldsObject);
                Applicant_Info__c OldAppInfo = (Applicant_Info__c)oldsObject;
                Applicant_Info__c NewAppInfo = (Applicant_Info__c)newsObject;           
                string recordTypeName = Schema.SObjectType.Applicant_Info__c.getRecordTypeInfosById().get(NewAppInfo.RecordTypeId).getName();
                
                //KEY = Applicant_Info__c-AuPairCare PT-Original-Basic-Submitted-TO-Main-Working
                if((OldAppInfo.application_level__c != NewAppInfo.application_level__c) || (OldAppInfo.application_stage__c != NewAppInfo.application_stage__c) )
                    key = 'Applicant_Info__c'+'-'+recordTypeName+'-'+oldAppInfo.Application_Type__c+'-'+OldAppInfo.application_level__c+'-'+OldAppInfo.application_stage__c+'-TO-'+NewAppInfo.application_level__c+'-'+NewAppInfo.application_Stage__c;                     
                                    
                if((oldAppInfo.Sales_Notes__c=='' || oldAppInfo.Sales_Notes__c==null) && NewAppInfo.Sales_Notes__c!=null)
                    specialKey = 'Applicant_Info__c'+'-'+recordTypeName+'-'+'BLANK'+'-TO-'+NewAppInfo.Sales_Notes__c;
                
                if((oldAppInfo.Partner_Intrax_Id__c=='' || oldAppInfo.Partner_Intrax_Id__c==null) && NewAppInfo.Partner_Intrax_Id__c!=null){
                    specialKey = 'App assigned Partner';
                }    
                System.debug('ENTERED NOTIFICATION APP KEY-->'+KEY);
                System.debug('ENTERED NOTIFICATION APP specialKey-->'+specialKey);
            }
            
            //FORMING THE KEYS FOR MATCH OBJECT
            else if(newsObject!=null && newsObject.getsObjectType() == Match__c.sObjectType){          
                System.debug('ENTERED NOTIFICATION MATCH INFO-->'+newsObject);
                if(oldsObject == null){                    
                    //Match Insert                    
                    Match__c NewMatch = (Match__c)newsObject; 
                    
                    if(NewMatch.Status__c=='Requested' && NewMatch.Offer_Status__c == 'Offered'){
                        key = 'Match Request Offered';
                    }
                }
                else{
                    //Match Update
                    Match__c OldMatch = (Match__c)oldsObject;
                    Match__c NewMatch = (Match__c)newsObject;           
                    string recordTypeName = Schema.SObjectType.Match__c.getRecordTypeInfosById().get(NewMatch.RecordTypeId).getName();
                    
                    //KEY = Match__c-AuPairCare-Requested-TO-Confirmed
                    //JOSE D-02135 - for match confirm should not be sent when the match that is confirmed is type = Extension
                    if(OldMatch.Status__c != NewMatch.Status__c && NewMatch.Status__c != 'Confirmed'){
                        Key = 'Match__c'+'-'+recordTypeName+'-'+OldMatch.Status__c+'-TO-'+NewMatch.Status__c;
                    }else if(OldMatch.Status__c != NewMatch.Status__c && NewMatch.Status__c == 'Confirmed' && NewMatch.Match_Type__c != 'Extension'){
                    	Key = 'Match__c'+'-'+recordTypeName+'-'+OldMatch.Status__c+'-TO-'+NewMatch.Status__c;
                    }
                    //JOSE D-02135 - for match confirm should not be sent when the match that is confirmed is type = Extension
                    if(OldMatch.Status__c != NewMatch.Status__c && NewMatch.Status__c == 'Confirmed' && NewMatch.Match_Type__c != 'Extension'){
                        list<Engagement__c> engList = [Select  Id, In_Country__c
                                                            From Engagement__c
                                                            Where Id =: NewMatch.Engagement__c AND In_Country__c = 'No'
                                                            ORDER BY CreatedDate DESC
                                                            LIMIT 1];
                        if(engList!=null && engList.size()>0){                        
                            if(NewMatch.Airport_Code__c == null){                                                                
                                specialKey = 'Academy Hotel Info';                                
                            }
                            else if(NewMatch.Airport_Code__c != null){ 
                                specialKey = 'Airport Pickup Info';
                            }
                            
                            if(NewMatch.Infant_Specialized_Training__c == 'Yes'){
                                specialKey2 = 'Training InfoYes';
                            }else if(NewMatch.Infant_Specialized_Training__c == 'No'){
                                specialKey2 = 'Training InfoNo';
                            }
                        }
                        
                    }
                    if(OldMatch.Status__c != NewMatch.Status__c && NewMatch.Status__c == 'Ended Early'){
                        assList = new list<Assessment__c>();
                        assList = [Select  Id, a.Match_Break_Date__c, a.Vacation_Days_Taken__c, a.Education_Allowance_Owed__c
                                                            From Assessment__c a
                                                            Where Match_Name__c =: NewMatch.Id and a.RecordType.Name = 'APC Exit Interview' AND Status__c = 'Confirmed'
                                                            ORDER BY CreatedDate DESC
                                                            LIMIT 1];
                        if(assList!=null && assList.size()>0){
                            specialKey = 'Match Break HF/PT';
                        }
                    }
                    if(OldMatch.Offer_Status__c != NewMatch.Offer_Status__c){
                        specialKey = 'Match__c'+'-'+recordTypeName+'-'+OldMatch.Offer_Status__c+'-TO-'+NewMatch.Offer_Status__c;
                    }
                
                }
                System.debug('ENTERED NOTIFICATION MATCH KEY-->'+KEY);
                System.debug('ENTERED NOTIFICATION MATCH specialKey-->'+specialKey);
            }
            
            //FORMING THE KEYS FOR ENGAGEMENT OBJECT
            else if(oldsObject!= null && newsObject!=null && oldsObject.getsObjectType() == Engagement__c.sObjectType && newsObject.getsObjectType() == Engagement__c.sObjectType){          
                System.debug('ENTERED NOTIFICATION ENGAGEMENT INFO-->'+oldsObject);
                Engagement__c OldEng = (Engagement__c)oldsObject;
                Engagement__c NewEng = (Engagement__c)newsObject;           
                string recordTypeName = Schema.SObjectType.Engagement__c.getRecordTypeInfosById().get(NewEng.RecordTypeId).getName();
                system.debug('@@@@@oldEng.Arrival_Status_Detail__c-->'+oldEng.Arrival_Status_Detail__c);
                system.debug('@@@@@NewEng.Arrival_Status_Detail__c-->'+NewEng.Arrival_Status_Detail__c);
                
                if((oldEng.Arrival_Trip_URL__c=='' || oldEng.Arrival_Trip_URL__c==null) && NewEng.Arrival_Trip_URL__c!=null){
                    specialKey = 'Arrival Flight Booked';
                    list<Match__c> mlist = [Select Id, Name, Position_Name__r.Host_Company_Id__c, Arrival_Date__c, Airport_Code__c from Match__c 
                                                    WHERE Engagement__c =: NewEng.Id AND Status__c != 'Withdrawn' 
                                                    ORDER BY CreatedDate DESC]; 
                    if(mlist !=null && mlist.size()>0){ 
                        if(mlist[0].Airport_Code__c != null){
                            specialKey2 = 'Arrival Flight Booked HF';
                        }            
                    } 
                }
                else if(oldEng.Dep_PNR_number__c==null && NewEng.Dep_PNR_number__c!=null)
                    specialKey = 'Return Flight Booked';
                /*else if(oldEng.Circulation_Start_Date__c!=null && oldEng.Circulation_End_Date__c!=null && OldEng.Placement_Status__c!=NewEng.Placement_Status__c && NewEng.Placement_Status__c=='In Removal')
                    specialKey = 'Applicant_Info__c-AuPairCare PT-Renewal-ANY-ANY-TO-Main-Accepted';//Same as this condition in Application. hence using this key.
				*/                
				else if(oldEng.CPR_Certification_Mailed__c != NewEng.CPR_Certification_Mailed__c && NewEng.CPR_Certification_Mailed__c == 'Yes')
                    specialKey = 'Card Notification';
                else if(oldEng.Arrival_Status__c != NewEng.Arrival_Status__c && NewEng.Arrival_Status__c == 'On Time')
                    specialKey = 'AP Check-in Confirmation';
                else if(oldEng.Arrival_Status_Detail__c != NewEng.Arrival_Status_Detail__c && NewEng.Arrival_Status_Detail__c == 'Late 1')
                    specialKey = 'Late arrival 1';
                else if(oldEng.Arrival_Status_Detail__c != NewEng.Arrival_Status_Detail__c && NewEng.Arrival_Status_Detail__c == 'Late 2')
                    specialKey = 'Late arrival 2';
                else if(oldEng.Pre_Departure_Project_Status__c != NewEng.Pre_Departure_Project_Status__c && NewEng.Pre_Departure_Project_Status__c == 'Incomplete')
                    specialKey = 'Pre-Departure Project Incomplete';
                else if(oldEng.Pre_Departure_Project_Status__c != NewEng.Pre_Departure_Project_Status__c && NewEng.Pre_Departure_Project_Status__c == 'Late')
                    specialKey = 'Pre-Departure Project Late';
                else if(oldEng.Pre_Departure_Project_Status__c != NewEng.Pre_Departure_Project_Status__c && NewEng.Pre_Departure_Project_Status__c == 'Not Submitted')
                    specialKey = 'Pre-Departure Project Not Submitted';
                else if(oldEng.Status__c != NewEng.Status__c && NewEng.Status__c == 'Program Complete'){
                    list<Intrax_Program_Upload__c> ipuList = [select ID,Document_Guid__c,Document_service__c,Description__c, Review_Status__c from Intrax_Program_Upload__c where Engagement__c =: NewEng.Id AND Document_Type__c = 'Proof-of-Education' AND Review_Status__c='Accepted'];
                    if(ipuList != null && ipuList.size()>0){
                        specialKey = 'Completion Certificate';
                    }
                }
                if(oldEng.Arrival_Status_Detail__c != NewEng.Arrival_Status_Detail__c && oldEng.Arrival_Status_Detail__c==null && (NewEng.Arrival_Status_Detail__c == 'Late 1' || NewEng.Arrival_Status_Detail__c == 'Late 2')){
                    specialKey2 = 'AP Late check-in confirmation';
                } 
                                                           
                system.debug('ENTERED NOTIFICATION ENGAGEMENT KEY-->'+specialKey);

            }
            
            //FORMING THE KEYS FOR SELECTION OBJECT
            else if(newsObject!=null && newsObject.getsObjectType() == Selection__c.sObjectType){          
                System.debug('ENTERED NOTIFICATION SELECTION INFO-->'+oldsObject);
                
                Selection__c NewSel = (Selection__c)newsObject;
                Selection__c OldSel;
                
                if(oldsObject!=null){//Update Trigger
                    OldSel = (Selection__c)oldsObject;
                    if(oldSel!=null && OldSel.Status__c != NewSel.Status__c && NewSel.Status__c=='Active')
                        Key= 'Selection__c'+'-'+NewSel.Intrax_Program__c+'-'+NewSel.Status__c;
                }
                else{//old is null. Insert Trigger
                    if(NewSel.status__c=='Active'){
                        Key= 'Selection__c'+'-'+NewSel.Intrax_Program__c+'-'+NewSel.Status__c;
                    }
                }
                                                                                         
                System.debug('ENTERED NOTIFICATION SELECTION KEY-->'+Key);
            }
        
            //FORMING THE KEYS FOR PAYMENT OBJECT
            else if(newsObject!=null && newsObject.getsObjectType() == Payment__c.sObjectType){          
                System.debug('ENTERED NOTIFICATION PAYMENT-->'+oldsObject);
                
                Payment__c NewPay = (Payment__c)newsObject;
                Payment__c OldPay;
                System.debug('ENTERED NOTIFICATION PAYMENT NewPay.Sucess__c-->'+NewPay.Sucess__c);
                if(oldsObject!=null){//Update Trigger
                    //do nothing
                }
                else{//old is null. Insert Trigger
                    if(NewPay.Sucess__c!=null){
                        Key= 'Payment__c'+'-'+NewPay.Sucess__c;
                    }
                }
                                                                                         
                System.debug('ENTERED NOTIFICATION PAYMENT KEY-->'+Key);
            }
            
            //FORMING THE KEYS FOR Intrax_Program_Upload__c INFO OBJECT
            else if(oldsObject!= null && newsObject!=null && oldsObject.getsObjectType() == Intrax_Program_Upload__c.sObjectType && newsObject.getsObjectType() == Intrax_Program_Upload__c.sObjectType){          
                
                system.debug('ENTERED NOTIFICATION Intrax_Program_Upload__c INFO-->'+oldsObject);
                Intrax_Program_Upload__c OldIPUInfo = (Intrax_Program_Upload__c)oldsObject;
                Intrax_Program_Upload__c NewIPUInfo = (Intrax_Program_Upload__c)newsObject;           
                //D-02057
                List<Engagement__c> engList = [SELECT Id,Intrax_Program__c FROM Engagement__c WHERE Id=:NewIPUInfo.Engagement__c];
                if(engList!=null && engList.size()>0){
                
                    if(engList[0].Intrax_Program__c == 'AuPairCare'){
                    if(OldIPUInfo.Review_Status__c != NewIPUInfo.Review_Status__c && NewIPUInfo.Review_Status__c == 'Accepted' && NewIPUInfo.Document_Type__c == 'Proof-of-Education'){
                        specialKey = 'Proof Education Approved';
                    }
                    }    
                }
                system.debug('ENTERED NOTIFICATION Intrax_Program_Upload__c specialKey-->'+specialKey);
            }
            
            if(key!=null || specialKey!=null){  
                PortalContentList = [SELECT Id,Name,Type__c,Object__c,Record_Type_Name__c,Status__c,key__c,RegEx__c,Notification_Type__c,Short_Summary__c,Subject__c,Body__c, Dynamic_Content__c, Urgency__c,User_Type__c, Header_Image__c FROM Portal_Content__c WHERE Type__c='Notification']; 
                if(PortalContentList!=null && PortalContentList.size()>0){
                    for(Portal_Content__c nf : PortalContentList){    
                    //System.debug('Portal content key-->'+nf.regEx__c);                          
                        if(((key!=null && nf.key__c!=null && key==nf.key__c) || (key!= null && nf.regEx__c!=null && Pattern.matches(nf.regEx__c,key)) || (nf.key__c!=null && specialKey!=null && specialKey==nf.key__c) || (nf.regEx__c!=null && specialKey!=null && Pattern.matches(nf.regEx__c,specialKey)) ) ){                            
                            System.debug('Portal content key found-->'+nf.key__c);
                            System.debug('Portal content regEx found-->'+nf.regEx__c);
                            System.debug('nfUserType before------>'+nf.User_Type__c);
                            //pass the values for notification creation
                            createAPCNotificationFromCS(newsObject,nf.Notification_Type__c,nf.Short_Summary__c,nf.Subject__c,nf.Body__c, nf.Dynamic_Content__c, nf.Urgency__c,nf.User_Type__c, nf.Header_Image__c);                                 
                        }
                        if(specialkey2!=null && nf.key__c!=null && specialkey2==nf.key__c){
                            createAPCNotificationFromCS(newsObject,nf.Notification_Type__c,nf.Short_Summary__c,nf.Subject__c,nf.Body__c, nf.Dynamic_Content__c, nf.Urgency__c,nf.User_Type__c, nf.Header_Image__c);                                 
                        }
                    }
                }
            } 
                
            
    }
        
    //JOSE B-02918 Adding Dynamic Content
    public static void createAPCNotificationFromCS(sObject sObjectNew, string nfType, string nfShortSum, string nfSubject, string nfBody, string nfDynamicContent, string nfUrgency, string nfUserType, Boolean nfIsHeader){
        try{
        system.debug('nfUserType------>'+nfUserType);
        system.debug('@@@@@sObjectNew------>'+sObjectNew);
        system.debug('@@@@@sObjectNew.getsObjectType()------>'+sObjectNew.getsObjectType());
        
        Notification__c notification = new Notification__c();
        
            if(sObjectNew!=null && sObjectNew.getsObjectType()==Applicant_Info__c.sObjectType){
                Applicant_Info__c AppInfo = (Applicant_Info__c)sObjectNew;            
                if(AppInfo!=null){
                    //JOSE B-02918 Adding Dynamic Content
                    system.debug('@@@@@nfDynamicContent before: ' + nfDynamicContent);
                    if(nfDynamicContent!=null){
                        try{
                        //Content for PT App link in partner Portal
                        
                        if(nfDynamicContent.contains('[LinkToPTinPTR]')){
                            nfDynamicContent = nfDynamicContent.replace('[LinkToPTinPTR]', '<a target="_blank" href="'+ globalDomainURL +'/globalpartners/pr_pt_profile?participantId='+AppInfo.Engagement__c+'">Link to Participant Details</a>');
                        }
                        if(nfDynamicContent.contains('[LinkToAppPTinPTR]')){
                            nfDynamicContent = nfDynamicContent.replace('[LinkToAppPTinPTR]', '<a target="_blank" href="'+ globalDomainURL +'/globalpartners/apc_ap_main_home?Id='+AppInfo.Id+'&IsPartner=true">Link to Application Details</a>');
                        }
                        //Content for Matching Expert
                        if(nfDynamicContent.contains('[ME_Name]') && AppInfo.OwnerId != null){
                            APC_Sales_Assignments__c MatchingExpert = apc_portal_utilities.MatchingExpert(AppInfo.OwnerId);
                            nfDynamicContent = nfDynamicContent.replace('[ME_Name]', MatchingExpert.ME_First_Name__c + ' ' + MatchingExpert.ME_Last_Name__c );
                            if(nfDynamicContent.contains('[ME_Email]')){
                                nfDynamicContent = nfDynamicContent.replace('[ME_Email]', MatchingExpert.ME_Email__c);
                            }
                            if(nfDynamicContent.contains('[ME_Phone]')){
                                nfDynamicContent = nfDynamicContent.replace('[ME_Phone]', MatchingExpert.ME_Phone__c);
                            }
                        }
                        }catch(Exception e){
                            system.debug('*****Error trying to create Dynamic Content for notification for Applicant Info: ' + e);
                        }
                    } 
                    //End JOSE B-02918
                    if(AppInfo.Intrax_Program__c!=null)
                        notification.Intrax_Program__c = AppInfo.Intrax_Program__c;     
                    if(AppInfo.Intrax_Program_Options__c!=null)
                        notification.Intrax_Program_Options__c = AppInfo.Intrax_Program_Options__c;                      
                    if(AppInfo.CreatedBy__c!=null)
                        notification.OwnerId = AppInfo.CreatedBy__c;
                    if(nfUserType != null && (nfUserType == 'Host' || nfUserType == 'Participant')){   
                        if(AppInfo.Account__c!=null){            
                            notification.account__c = AppInfo.Account__c;                                      
                            notification.contact__c = getContactId(AppInfo.Account__c);
                        }
                    }
                    else if(nfUserType != null && nfUserType == 'Partner'){
                        if(AppInfo.Partner_Account__c!=null){
                            notification.account__c = AppInfo.Partner_Account__c;
                            notification.Contact__c = getContactId(AppInfo.Partner_Account__c);
                        }
                    }
                }        
            }
            else if(sObjectNew!=null && sObjectNew.getsObjectType()==Match__c.sObjectType){
                Match__c match = (Match__c)sObjectNew;     
                if(match!=null){
                    //JOSE B-02918 Adding Dynamic Content
                    system.debug('@@@@@nfDynamicContent before: ' + nfDynamicContent);
                    if(nfDynamicContent!=null){
                        try{
                        //Content for Matching Expert
                        if(nfDynamicContent.contains('[Match__ArrivalDate]') && match.Arrival_Date__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[Match__ArrivalDate]', match.Arrival_Date__c.format());
                        }
                        if(nfDynamicContent.contains('[Match_HFName]') && match.Position_Name__c!=null){
                            list<Position__c> poList = [SELECT Id,Host_Company_Id__c,Name, Host_Company_Id__r.Name FROM Position__c WHERE Id=:match.Position_Name__c LIMIT 1];
                            if(polist!=null && polist.size()>0 && polist[0].Host_Company_Id__r.Name != null)
                            nfDynamicContent = nfDynamicContent.replace('[Match_HFName]', polist[0].Host_Company_Id__r.Name);
                        }
                        if(nfDynamicContent.contains('[Match__HFArrivalDate]') && match.HF_Arrival_Date__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[Match__HFArrivalDate]', match.HF_Arrival_Date__c.format());
                        }
                        if(nfDynamicContent.contains('[AcademyHotel]') && academyDetails.Academy_Hotel_Name__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[AcademyHotel]', academyDetails.Academy_Hotel_Name__c);
                        }
                        if(nfDynamicContent.contains('[AcademyAddress]') && academyDetails.Academy_Address__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[AcademyAddress]', academyDetails.Academy_Address__c);
                        }
                        if(nfDynamicContent.contains('[AcademyPhone]') && academyDetails.Academy_Phone__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[AcademyPhone]', academyDetails.Academy_Phone__c);
                        }
                        if(nfDynamicContent.contains('[Ass_MatchBreakDate]') && match.Id != null){
                            
                            if(assList!=null && assList.size()>0){
                                if(assList[0].Match_Break_Date__c != null){
                                    nfDynamicContent = nfDynamicContent.replace('[Ass_MatchBreakDate]', assList[0].Match_Break_Date__c.format());
                                }
                                if(nfDynamicContent.contains('[Ass_EducationAllowanceOwed]')){
                                    if(assList[0].Education_Allowance_Owed__c != null){
                                        nfDynamicContent = nfDynamicContent.replace('[Ass_EducationAllowanceOwed]', string.valueof(assList[0].Education_Allowance_Owed__c));
                                    }
                                }
                                if(nfDynamicContent.contains(' [Ass_VacationDaysTaken]')){
                                    if(assList[0].Vacation_Days_Taken__c != null){
                                        nfDynamicContent = nfDynamicContent.replace('[Ass_VacationDaysTaken]', string.valueof(assList[0].Vacation_Days_Taken__c));
                                    }
                                }
                            }                           
                        }
                        if(nfDynamicContent.contains('[Au_Pair_Name]') && match.Engagement__c!=null){
                            list<Engagement__c> engList = [Select Id, Name, Partner_Account__c, Account_Id__c, Account_Id__r.Name
                                                        From Engagement__c
                                                        Where Id =: match.Engagement__c
                                                        ORDER BY CreatedDate DESC
                                                        LIMIT 1];
                            if(engList!=null && engList.size()>0 && engList[0].Account_Id__r.Name != null)
                            nfDynamicContent = nfDynamicContent.replace('[Au_Pair_Name]', engList[0].Account_Id__r.Name);
                        }
                        }catch(Exception e){
                            system.debug('*****Error trying to create Dynamic Content for notification for Match: ' + e);
                        }
                    } 
                    //End JOSE B-02918
                    System.debug('nfUserType in match------>'+nfUserType);                    
                    if(match.Intrax_Program__c!=null)
                        notification.Intrax_Program__c = match.Intrax_Program__c;     
                    if(match.Intrax_Program_Option__c!=null)
                        notification.Intrax_Program_Options__c = match.Intrax_Program_Option__c;                      
                    if(match.CreatedById!=null)
                        notification.OwnerId = match.CreatedById;
                    try{
                    if(nfUserType != null){
                        if(nfUserType == 'Participant'){
                            System.debug('nfUserType in PT------>'+nfUserType);
                            if(match.Participant_Id__c!=null){   
                                System.debug('nfUserType in match participant------>'+nfUserType);         
                                notification.account__c = match.Participant_Id__c;                                      
                                notification.contact__c = getContactId(match.Participant_Id__c);
                            }   
                        }else if (nfUserType == 'Host'){
                            System.debug('nfUserType in HOst------>'+nfUserType);
                            System.debug('nfUserType in host position------>'+match.Position_Name__c);
                            //System.debug('nfUserType in host company------>'+match.Position_Name__r.Host_Company_Id__c);
                            if(match.Position_Name__c!=null){
                                //gethostaccount and contact
                                Id hostAccountId = getHostAccountId(match.Position_Name__c);
                                if(hostAccountId!=null){
                                    notification.account__c = hostAccountId;
                                    notification.contact__c = getContactId(hostAccountId);
                                }
                            }                            
                        }else if (nfUserType == 'Partner'){
                            system.debug('nfUserType in Partner------>'+nfUserType);
                            system.debug('nfUserType in Partner Engagement------>'+match.Engagement__c);
                            system.debug('nfUserType in Partner Account------>'+match.Engagement__r.Partner_Account__c);
                            if(match.Engagement__c!=null){
                                list<Engagement__c> engList = [Select Id, Name, Partner_Account__c
                                                        From Engagement__c
                                                        Where Id =: match.Engagement__c
                                                        ORDER BY CreatedDate DESC
                                                        LIMIT 1];
                                if(engList!=null && engList.size()>0){
                                    if(engList[0].Partner_Account__c!=null){
                                        //gethostaccount and contact
                                        notification.account__c = engList[0].Partner_Account__c;
                                        notification.contact__c = getContactId(engList[0].Partner_Account__c);
                                    }
                                }                       
                                
                            }                            
                        }
                    }
                    }catch(Exception e){
                            system.debug('*****Error trying to create Dynamic Content for notification for Match: ' + e);
                    }
                    notification.match__c = match.Id;
                    if(match.engagement__c!=null)
                        notification.engagement__c = match.engagement__c;
                    if(match.Position_Name__c!=null)
                        notification.Position__c = match.Position_Name__c;                                    
                }               
            
            }else if(sObjectNew!=null && sObjectNew.getsObjectType()==Intrax_Program_Upload__c.sObjectType){
                Intrax_Program_Upload__c ipu = (Intrax_Program_Upload__c)sObjectNew;     
                if(ipu!=null){
                    try{
                    //JOSE B-02918 Adding Dynamic Content
                    system.debug('@@@@@nfDynamicContent before: ' + nfDynamicContent);
                    if(nfDynamicContent!=null){
                        try{
                        
                        }catch(Exception e){
                            system.debug('*****Error trying to create Dynamic Content for notification: ' + e);
                        }
                    } 
                    //End JOSE B-02918                   
                    notification.Intrax_Program__c = 'AuPairCare';     
                    if(ipu.CreatedById!=null)
                        notification.OwnerId = ipu.CreatedById;
                    if(nfUserType != null){
                        if(nfUserType == 'Participant'){
                            if(ipu.Engagement__c!=null){            
                                list<Engagement__c> engList = [Select Id, Name, Account_Id__c
                                                        From Engagement__c
                                                        Where Id =: ipu.Engagement__c
                                                        ORDER BY CreatedDate DESC
                                                        LIMIT 1];
                                if(engList!=null && engList.size()>0 && engList[0].Account_Id__c!=null ){
                                    notification.account__c = engList[0].Account_Id__c; 
                                    notification.contact__c = getContactId(engList[0].Account_Id__c);
                                }
                            }   
                        }
                    }
                    if(ipu.Id!=null){
                        notification.Engagement__c = ipu.Engagement__c;
                    }
                }catch(Exception e){
                    system.debug('*****Error trying to create Application notification: ' + e);
                }
                }               
            
            
            
            }else if(sObjectNew!=null && sObjectNew.getsObjectType()==Engagement__c.sObjectType){
                Engagement__c eng = (Engagement__c)sObjectNew;     
                if(eng!=null){
                    try{
                    //JOSE B-02918 Adding Dynamic Content
                    system.debug('@@@@@nfDynamicContent before: ' + nfDynamicContent);
                    if(nfDynamicContent!=null){
                        try{
                        if(nfDynamicContent.contains('[AcademyHotel]') && academyDetails.Academy_Hotel_Name__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[AcademyHotel]', academyDetails.Academy_Hotel_Name__c);
                        }
                        if(nfDynamicContent.contains('[AcademyAddress]') && academyDetails.Academy_Address__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[AcademyAddress]', academyDetails.Academy_Address__c);
                        }
                        if(nfDynamicContent.contains('[AcademyPhone]') && academyDetails.Academy_Phone__c!=null){
                            nfDynamicContent = nfDynamicContent.replace('[AcademyPhone]', academyDetails.Academy_Phone__c);
                        }
                        if(nfDynamicContent.contains('[CurrentDate+2weeks]') && eng.Arrival_Trip_URL__c != null){
                            nfDynamicContent = nfDynamicContent.replace('[CurrentDate+2weeks]', Date.today().addDays(14).format() );
                        }
                        if(nfDynamicContent.contains('[Eng_ArrivalTrip]') && eng.Arrival_Trip_URL__c != null){
                            nfDynamicContent = nfDynamicContent.replace('[Eng_ArrivalTrip]', '<a target="_blank" href="http://' + eng.Arrival_Trip_URL__c + '">Here</a>');
                        }
                        if(nfDynamicContent.contains('[Match_ArrivalDate]')){
                            list<Match__c> mlist = [Select Id, Name, Position_Name__r.Host_Company_Id__c, Arrival_Date__c from Match__c 
                                                    WHERE Engagement__c =: eng.Id AND Status__c != 'Withdrawn' 
                                                    ORDER BY CreatedDate DESC]; 
                            if(mlist !=null && mlist.size()>0){ 
                                if(mlist[0].Arrival_Date__c!=null){
                                    nfDynamicContent = nfDynamicContent.replace('[Match_ArrivalDate]', mlist[0].Arrival_Date__c.format());
                                }            
                            } 
                            
                        }
                        }catch(Exception e){
                            system.debug('*****Error trying to create Dynamic Content for notification: ' + e);
                        }
                    } 
                    //End JOSE B-02918                   
                    if(eng.Intrax_Program__c!=null)
                        notification.Intrax_Program__c = eng.Intrax_Program__c;     
                    if(eng.Intrax_Program_Options__c!=null)
                        notification.Intrax_Program_Options__c = eng.Intrax_Program_Options__c;                      
                    if(eng.CreatedById!=null)
                        notification.OwnerId = eng.CreatedById;
                    if(nfUserType != null){
                        if(nfUserType == 'Participant'){
                            if(eng.Account_Id__c!=null){            
                                notification.account__c = eng.Account_Id__c;                                      
                                notification.contact__c = getContactId(eng.Account_Id__c);
                            }   
                        }else if(nfUserType == 'Host'){
                            list<Match__c> mlist = [Select Id, Name, Position_Name__r.Host_Company_Id__c from Match__c 
                                                    WHERE Engagement__c =: eng.Id AND Status__c != 'Withdrawn' 
                                                    ORDER BY CreatedDate DESC]; 
                            
                            if(mlist !=null && mlist.size()>0){ 
                                if(mlist[0].Position_Name__r.Host_Company_Id__c !=null){
                                notification.account__c = mlist[0].Position_Name__r.Host_Company_Id__c;                                      
                                notification.contact__c = getContactId(mlist[0].Position_Name__r.Host_Company_Id__c);
                                }            
                            }   
                        }
                        
                    }
                    if(eng.Id!=null){
                        notification.engagement__c = eng.Id;
                    }
                }catch(Exception e){
                    system.debug('*****Error trying to create Application notification: ' + e);
                }
                }               
            
            
            
            }else if(sObjectNew!=null && sObjectNew.getsObjectType()==Selection__c.sObjectType){
                Selection__c sel= (Selection__c)sObjectNew;     
                if(sel!=null){
                    //JOSE B-02918 Adding Dynamic Content
                    system.debug('@@@@@nfDynamicContent before: ' + nfDynamicContent);
                    if(nfDynamicContent!=null){
                        try{
                        Engagement__c engSel = new Engagement__c();
                        if(sel.Engagement__c!=null){
                            list <Engagement__c> engSelList = [Select Id, Name from Engagement__c where Id =: sel.Engagement__c];
                            if(engSelList !=null && engSelList.size()>0){
                                engSel = engSelList[0];
                            }   
                        }
                        if(nfDynamicContent.contains('[Sel_EngName]') && engSel.Name != null){
                            nfDynamicContent = nfDynamicContent.replace('[Sel_EngName]', engSel.Name);
                        }
                        if(nfDynamicContent.contains('[Sel_InterviewEndDate]') && sel.Interview_End_Date__c != null){
                            nfDynamicContent = nfDynamicContent.replace('[Sel_InterviewEndDate]', sel.Interview_End_Date__c.format('MMM d,yyyy'));
                        }
                        
                        }catch(Exception e){
                            system.debug('*****Error trying to create Dynamic Content for notification: ' + e);
                        }
                    } 
                    //End JOSE B-02918                    
                    if(sel.Intrax_Program__c!=null)
                        notification.Intrax_Program__c = sel.Intrax_Program__c;                                             
                    if(sel.CreatedById!=null)
                        notification.OwnerId = sel.CreatedById;
                    if(nfUserType != null){
                        if(nfUserType == 'Participant'){
                            if(sel.Engagement__c!=null){
                                Id partAccountId = getpartAccId(sel.Engagement__c);
                                if(partAccountId!=null){
                                    notification.account__c = partAccountId;
                                    notification.contact__c = getContactId(partAccountId);
                                }
                            }   
                        }
                        else if(nfUserType == 'Host'){
                            if(sel.Position__c!=null){
                                //gethostaccount and contact
                                Id hostAccountId = getHostAccountId(sel.Position__c);
                                if(hostAccountId!=null){
                                    notification.account__c = hostAccountId;
                                    notification.contact__c = getContactId(hostAccountId);
                                }
                            }   
                        }
                        
                    }
                    if(sel.Engagement__c!=null)
                        notification.engagement__c = sel.Engagement__c;
                    if(sel.Position__c!=null)
                        notification.Position__c = sel.Position__c;                                   
                }               
            }
            
            else if(sObjectNew!=null && sObjectNew.getsObjectType()==Payment__c.sObjectType){
                Payment__c payment= (Payment__c)sObjectNew;     
                if(payment!=null){                                        
                    notification.Intrax_Program__c = 'AuPairCare';                                             
                    if(payment.CreatedById!=null)
                        notification.OwnerId = payment.CreatedById;
                    if(nfUserType != null){
                        if(nfUserType == 'Host'){
                            if(payment.Account_Name__c!=null){
                                //gethostaccount and contact
                                Id hostAccountId = payment.Account_Name__c;
                                if(hostAccountId!=null){
                                    notification.account__c = hostAccountId;
                                    notification.contact__c = getContactId(hostAccountId);
                                }
                            }   
                        }                        
                    }                     
                }               
            }
            //Sales invoice object.  Called from Batch_Notifications_ScheduledPayment
            else if(sObjectNew!=null && sObjectNew.getsObjectType()==Sales_Invoice__c.sObjectType){
                Sales_Invoice__c SI= (Sales_Invoice__c)sObjectNew;     
                if(SI!=null){                                        
                    notification.Intrax_Program__c = 'AuPairCare';                                             
                    //if(SI.CreatedById!=null)
                    //    notification.OwnerId = SI.CreatedById;
                    if(nfUserType != null){
                        if(nfUserType == 'Host'){
                            if(SI.Account__c!=null){
                                //gethostaccount and contact
                                Id hostAccountId = SI.Account__c;
                                if(hostAccountId!=null){
                                    notification.account__c = hostAccountId;
                                    notification.contact__c = getContactId(hostAccountId);
                                }
                            }   
                        }                        
                    }                     
                }               
            }
                
                //notification.Parent_Notification__c = parentId;
                if(nfType!=null)
                    notification.Type__c = nfType;
                if(nfShortSum!=null)
                    notification.short_summary__c = nfShortSum;
                if(nfSubject!=null)
                    notification.Subject__c = nfSubject;
                //JOSE B-02918 Adding Dynamic Content
                if(nfDynamicContent!=null){
                    system.debug('@@@@@nfDynamicContent after: ' + nfDynamicContent);
                    notification.Dynamic_Content__c = nfDynamicContent;
                }
                if(nfIsHeader==true){
                    notification.Header_Image__c = true;
                }
                notification.Email_Sent_At__c = datetime.now();
                //End JOSE B-02918    
                if(nfBody!=null)
                    notification.Body__c = nfBody;                               
                if(nfUrgency!=null)
                    notification.urgency__c = nfUrgency;
                if(nfUserType!=null)
                    notification.User_Type__c = nfUserType;
                //notification.Engagement__c = engagement.Id;
                //notification.Action_URL__c = 'WT_Orientation_Steps?Id='+engagement.Id;
                notification.Status__c = 'Not Started';
                notification.message_type__c = 'Matching';            
                notification.hide_from_user__c = false;            
                notification.channels__c = 'Email; Portal';
                notification.Message_Status__c = 'Unread'; 
                notification.Parent_Notification__c = NULL;  
                
                System.debug('NOTIFICATION---'+notification);
                
                try{           
                    insert notification;
                }
                catch(exception e){
                    system.debug('EXCEPTION IN NOTIFICATION_GENERATOR CREATING NOTIFICATION---'+e);                
                }
                
                system.debug('NOTIFICATION INSERTED---'+notification.Id);
    	
    	}catch(exception e){
        	System.debug('@@@@EXCEPTION IN NOTIFICATION_GENERATOR CREATING NOTIFICATION---'+e);                
        }
                
    }
    
    public static Id getContactId(Id sAccountId){
        Id conId;
        if(sAccountId!=null){
            List<Contact> conList = [SELECT Id,AccountId FROM Contact WHERE AccountId=:sAccountId LIMIT 1];
            if(conList!=null && conList.size()>0){
                conId = conList[0].Id;
            }
        }
        if(conId!=null) return conId;
        else return null;
    }
    
    public static Id getHostAccountId(Id sPosId){
        Id hostAccId;
        if(sPosId!=null){
            List<Position__c> posList = [SELECT Id,Host_Company_Id__c FROM Position__c WHERE Id=:sPosId LIMIT 1];
            System.debug('@@@@@posList------>'+posList);
            if(posList!=null && posList.size()>0){
                hostAccId = posList[0].Host_Company_Id__c;
                System.debug('@@@@@hostAccId------>'+hostAccId);
            }
        }
        if(hostAccId!=null) return hostAccId;
        else return null;
    }
    
    public static Id getPartAccId(Id sEngId){
        Id partAccId;
        if(sEngId!=null){
            List<Engagement__c> engList = [SELECT Id,Account_Id__c FROM Engagement__c WHERE Id=:sEngId LIMIT 1];
            if(engList!=null && engList.size()>0){
                partAccId = engList[0].Account_Id__c;
            }
        }
        if(partAccId!=null) return partAccId;
        else return null;
    }
    
    //Function to get list of months that have progressed on a given date
    public static List<String> getMonthList(Boolean withHistory){
        Date thisDay =  Date.today();
        Integer monthNum = thisDay.month();
        List<String> monthList = new List<String>();
        if (monthNum == 1 || (withHistory && monthNum > 1)){
            monthList.add('January');
        }
        if (monthNum == 2 || (withHistory && monthNum > 2)){
            monthList.add('February');
        }   
        if (monthNum == 3 || (withHistory && monthNum > 3)){
            monthList.add('March');
        }
        if (monthNum == 4 || (withHistory && monthNum > 4)){
            monthList.add('April');
        }
        if (monthNum == 5 || (withHistory && monthNum > 5)){
            monthList.add('May');
        }
        if (monthNum == 6 || (withHistory && monthNum > 6)){
            monthList.add('June');
        }
        if (monthNum == 7 || (withHistory && monthNum > 7)){
            monthList.add('July');
        }
        if (monthNum == 8 || (withHistory && monthNum > 8)){
            monthList.add('August');
        }
        if (monthNum == 9 || (withHistory && monthNum > 9)){
            monthList.add('September');
        }
        if (monthNum == 10 || (withHistory && monthNum > 10)){
            monthList.add('October');
        }
        if (monthNum == 11 || (withHistory && monthNum > 11)){
            monthList.add('November');
        }
        if (monthNum == 12 || (withHistory && monthNum > 12)){
            monthList.add('December');
        }
        return monthList;
    }
    
    //Record Types of Assessments
    public void getRecordTypesReady(){
        HFAssRecordTypes = new List<String>();
        PTAssRecordTypes = new List<String>();
        HFAssRecordTypes.addAll(Constants.ASS_HF_CONTACT_S1_RECORDTYPES.values());
        HFAssRecordTypes.addAll(Constants.ASS_HF_CONTACT_S2_RECORDTYPES.values());
        HFAssRecordTypes.addAll(Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.values());
        PTAssRecordTypes.addAll(Constants.ASS_PT_CONTACT_S1_RECORDTYPES.values());
        PTAssRecordTypes.addAll(Constants.ASS_PT_CONTACT_S2_RECORDTYPES.values());
        PTAssRecordTypes.addAll(Constants.ASS_PT_CONTACT_YEAR_RECORDTYPES.values());
    }
    
    //Processes Assessments
    public PageReference processAssessments(){
        PageReference P;
        String hostMonthsNotCompleted = '';
        String participantMonthsNotCompleted = '';
        months = getMonthList(false);
        System.debug('monthList searched for: '+months);
        System.debug('Number of matches processed'+matchList.size());
        getRecordTypesReady();
        for (Match__c match: matchList){
            hostMonthsNotCompleted = '';
            participantMonthsNotCompleted = '';
            List<Assessment__c> hostAssessments = [select Id,Time_Period__c from Assessment__c a where a.Assessment_Date__c = NULL and a.Match_Name__c = :match.Id and a.Time_Period__c in :months and a.RecordTypeId in :HFAssRecordTypes ];
            for (Assessment__c hostAssessment : hostAssessments){
                System.debug('Host Assessment not completed for:'+hostAssessment.Time_Period__c);
                if (hostMonthsNotCompleted == ''){
                    hostMonthsNotCompleted = hostAssessment.Time_Period__c;
                }
                else{
                    hostMonthsNotCompleted = hostMonthsNotCompleted + ',' + hostAssessment.Time_Period__c;  
                }
                
            }
            System.debug('Pending Host Assessments are:'+hostAssessments);
            
            //Get the URL for the flow from custom setting
            // Changed Custom setting 'URL' to 'ApplicationConstants'- B01975
            //List<URL__c> assessmentUrlHF = [select URL__c from URL__c where Type__c = 'AyusaMonthlyContactHF'];
            //List<URL__c> assessmentUrlPT = [select URL__c from URL__c where Type__c = 'AyusaMonthlyContactPT'];
            Application_Constants__c assessmentUrlHF= Application_Constants__c.getInstance('AyusaMonthlyContactHF');
            Application_Constants__c assessmentUrlPT= Application_Constants__c.getInstance('AyusaMonthlyContactPT');
            String Url_HF=assessmentUrlHF.Value__c;
            String Url_PT=assessmentUrlPT.Value__c;
            if (hostAssessments.size() > 0 || match.End_Date__c < date.today() ){
                //Create Notification
                Notification__c notification = new Notification__c();
                notification.Subject__c = 'Your Monthly contact is due';
                //notification.Body__c = 'Please complete the assessments for months:'+hostMonthsNotCompleted+' @ ' +match.URL_Monthly_HF__c ;
                if(!String.isBlank(Url_HF))
                notification.Body__c = 'Please complete the assessments at: ' +Url_HF+'id='+match.Id ;
                
                notification.Status__c = 'Not Started';
                notification.Type__c = 'Host Family';
                notification.Intrax_Program__c = 'Ayusa';
                Notification.Match__c = match.Id;
                List<Position__c> position = [select Id,Host_Company_Id__c,Position_Supervisor__c from Position__c where Id = :match.Position_Name__c];
                notification.Contact__c = position[0].Position_Supervisor__c;
                notifications.add(notification);
            }
            
            List<Assessment__c> participantAssessments = [select Id,Time_Period__c from Assessment__c a where a.Assessment_Date__c = NULL and a.Match_Name__c = :match.Id and a.Time_Period__c in :months and a.RecordTypeId in :PTAssRecordTypes];
            for (Assessment__c participantAssessment : participantAssessments){
                System.debug('Participant Assessment not completed for:'+participantAssessment.Time_Period__c);
                if (participantMonthsNotCompleted == ''){
                    participantMonthsNotCompleted = participantAssessment.Time_Period__c;
                }
                else{
                    participantMonthsNotCompleted = participantMonthsNotCompleted + ',' + participantAssessment.Time_Period__c; 
                }
                
            }
            System.debug('Pending Participant Assessments are:'+participantAssessments);
            
            if (participantAssessments.size() > 0 || match.End_Date__c < date.today() ){
                //Create Notification
                Notification__c notification = new Notification__c();
                notification.Subject__c = 'Your Monthly contact is due';
                //notification.Body__c = 'Please complete the assessments for months:'+hostMonthsNotCompleted+' @ ' +match.URL_Monthly_HF__c;
                if(!String.isBlank(Url_PT))
                notification.Body__c = 'Please complete the assessments at: ' +Url_PT+'id='+match.Id;
                
                notification.Status__c = 'Not Started';
                notification.Type__c = 'Participant';
                notification.Intrax_Program__c = 'Ayusa';
                Notification.Match__c = match.Id;
                //Fetch Partcipant Account
                List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :match.Participant_Id__c];
                notification.Contact__c = PTAccount[0].PersonContactId;
                notifications.add(notification);
            }
        }
        insert notifications;
        
        if (ApexPages.currentPage()!=null){
            P = new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
            P.setRedirect(true);
        }
        return P;
    }
    public void CreateHFInterviewNotification(Id AppInfoId)
    {
        system.debug('******inside CreateHFInterviewNotification******'+AppInfoId );
         // Changed Custom setting 'URL' to 'ApplicationConstants'- B01975
     // List<URL__c> ObjURL  = [select URL__c from URL__c where Type__c = 'Assessment_HFInterviewFlow'];
    Application_Constants__c ObjURL= Application_Constants__c.getInstance('InterviewFlowURL');
     String Flow_URL=ObjURL.Value__c;
     system.debug('******inside CreateHFInterviewNotification ObjURL******'+ObjURL.Value__c );
    List<Applicant_Info__c> ObjAppInfo = [Select a.Position__r.Id, a.Account__r.PersonEmail, a.Account__r.Name, a.Account__r.Id, a.Account__c,a.Position__c,a.Position__r.Position_Supervisor__c,a.Position__r.Host_Company_Id__c, a.Name, a.Id From Applicant_Info__c a where a.id = :AppInfoId];
    system.debug('******inside CreateHFInterviewNotification ObjAppInfo******'+ObjAppInfo );
  
   // List<Match__c> objMatch =  [Select m.Status__c, m.Start_Date__c, m.RecordTypeId, m.Position_Name__r.Host_Company_Id__c, m.Position_Name__c, m.Participant_Id__r.Name, m.Participant_Id__r.Id, m.Participant_Id__c, m.Name, m.Id, (Select Id, Name, RecordTypeId, Host_Name__c, Match_Name__c, Participant_Name__c, Position_Name__c From Match_Assessments__r) From Match__c m where m.Position_Name__c = :ObjAppInfo[0].Position__c];  
    //List<Assessment__c> LstExistingMatchPTAssessment = [Select Month_Number__c, Assessment_Date__c,Host_Name__c, Match_Name__c, Participant_Name__c, Position_Name__c, Engagement__c, Count_Down__c From Assessment__c where Participant_Name__c =: objMatch[0].Participant_Id__c and  RecordTypeId =: constants.ASS_AY_PT_Contact];
           
                Notification__c ObjNotification = new Notification__c();
                ObjNotification.Subject__c = 'Your Interview is due';
                //notification.Body__c = 'Please complete the assessments for months:'+hostMonthsNotCompleted+' @ ' +match.URL_Monthly_HF__c;
                if(!String.isBlank(Flow_URL))
                ObjNotification.Body__c = Flow_URL+'id=' + ObjAppInfo[0].Position__r.Id;
                
                ObjNotification.Status__c = 'Not Initiated';
                ObjNotification.Type__c = 'Host Family';
                ObjNotification.Intrax_Program__c = 'Ayusa';
                ObjNotification.position__c=ObjAppInfo[0].Position__r.Id;
                
                if(ObjAppInfo[0].Position__c != null){          
                    List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :ObjAppInfo[0].Position__r.Host_Company_Id__c];
                    ObjNotification.account__c = PTAccount[0].Id;
                    ObjNotification.contact__c = PTAccount[0].PersonContactId;
                }
                    system.debug('******notification******'+notification );
                insert ObjNotification;
                //Notification.Match__c = match.Id;
        
    }
    
     public static void CreateMemberBGCReqNotification(List<Member__c> LstMemberInfo)
    {    
        
   // List<Member__c> LstMemberInfo = [Select m.Role__c, m.Residency_Status__c, m.Name, m.Intrax_Program_Option__c, m.Id, m.First_Name__c, m.Email__c, m.Background_Check_Required__c, m.Age__c, m.Account_Name__c From Member__c m where m.id in :MemberIds];
    List<Notification__c> LstMemberToBeNotified =  new list<Notification__c>();
     // Map<Member__c,List<Notification__c>> rawRecords = new Map<Member__c,List<Notification__c>>();
   If(LstMemberInfo!=null && LstMemberInfo.size()>0)
   {
    for (Member__c member : LstMemberInfo)
    {
              
                 Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotification.Intrax_Program__c = 'Ayusa';
                insert newNotification;
               // LstMemberToBeNotified.add(newNotification);
                system.debug('*****newNotification******'+newNotification);
                  Notification__c ObjNotification = new Notification__c();
                ObjNotification.Subject__c = 'Your Background Check is due';            
                ObjNotification.Body__c = 'Docusign  BGC Email Template';            
                ObjNotification.Type__c = 'Ayusa Member BGC'; 
                 ObjNotification.Intrax_Program__c = 'Ayusa';              
                ObjNotification.Member__c=member.Id;
                if(member.Email__c!=null)
                ObjNotification.Member_Email__c=member.Email__c;
                else
                ObjNotification.Member_Email__c=member.Account_Name__r.PersonEmail;
                ObjNotification.Status__c = 'Not Started';
                ObjNotification.Parent_Notification__c = newNotification.Id;
                system.debug('*****ObjNotification******'+ObjNotification);
                LstMemberToBeNotified.add(ObjNotification);
               // rawRecords.put(member,LstMemberToBeNotified);
                system.debug('****LstMemberToBeNotified********'+LstMemberToBeNotified);
   }
   if(LstMemberToBeNotified!=null && LstMemberToBeNotified.size()>0)
   insert LstMemberToBeNotified;
   }
     
    }
    
     public static void CreateHFApprovalNotification(List<Position__c> lstHFPositions)
    {    
        
      List<Notification__c> LstHFPosToBeNotified =  new list<Notification__c>();
      If(lstHFPositions!=null && lstHFPositions.size()>0)
      {
        for (Position__c position : lstHFPositions)
        {
              
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotification.Intrax_Program__c = position.Intrax_Program__c;     
                newNotification.Intrax_Program_Options__c = position.Intrax_Program_Options__c;        
                insert newNotification;
              
                system.debug('*****newNotification******'+newNotification);
                
                Notification__c ObjNotification = new Notification__c();
                ObjNotification.Subject__c = 'You are now an approved Ayusa Host Family!';            
                ObjNotification.Body__c = 'Your family is now fully approved and ready to start selecting a student. Click below to start looking for a student who is right for you!';            
                ObjNotification.Type__c = 'Host Family Approval';  
                ObjNotification.Intrax_Program__c = position.Intrax_Program__c;     
                ObjNotification.Intrax_Program_Options__c = position.Intrax_Program_Options__c;        
                ObjNotification.Position__c=position.Id;               
                ObjNotification.Status__c = 'Not Started';
                ObjNotification.Parent_Notification__c = newNotification.Id;
                List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :position.Host_Company_Id__c];
                ObjNotification.Account__c = position.Host_Company_Id__c;              
                ObjNotification.Contact__c = PTAccount[0].PersonContactId;
                system.debug('*****ObjNotification******'+ObjNotification);
                list<Applicant_Info__c> appInfoHF = [SELECT Id, Account__c, Position__c, Position__r.Status__c, createdDate, Application_Stage__c, CreatedBy__c FROM Applicant_Info__c WHERE Position__c =: position.Id];
                if(appInfoHF!=null && appInfoHF.size()>0)                
                ObjNotification.OwnerId = appInfoHF[0].CreatedBy__c;
                ObjNotification.Action_URL__c = 'NotificationRedirection?posId=' + position.Id;
                LstHFPosToBeNotified.add(ObjNotification);
               // rawRecords.put(member,LstMemberToBeNotified);
                system.debug('****LstHFPosToBeNotified********'+LstHFPosToBeNotified);
     }
       if(LstHFPosToBeNotified!=null && LstHFPosToBeNotified.size()>0)
       insert LstHFPosToBeNotified;
   }
   MatchingPosFlag = true;
   
     
 }
   public static void CreateRecommendedStuNotification(List<Match__c> lstHFMatches)
    {    
      system.debug('***lstHFMatches*******'+lstHFMatches);  
      List<Notification__c> LstHFMatchesToBeNotified =  new list<Notification__c>();
      If(lstHFMatches!=null && lstHFMatches.size()>0)
      {
        for (Match__c match : lstHFMatches)
        {
              
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotification.Intrax_Program__c = match.Intrax_Program__c;     
                newNotification.Intrax_Program_Options__c = match.Intrax_Program_Option__c;        
             
                insert newNotification;
              
                system.debug('*****newNotification******'+newNotification);
                
                Notification__c ObjNotification = new Notification__c();
                ObjNotification.Subject__c = 'You have an Ayusa recommended student!';            
                ObjNotification.Body__c = 'Ayusa has recommended some students for your family! Click here to view these students and finalize your match today!';            
                ObjNotification.Type__c = 'Recommended Students';               
                ObjNotification.Position__c = match.Position_Name__c;               
                ObjNotification.Status__c = 'Not Started';
                 ObjNotification.Intrax_Program__c = match.Intrax_Program__c;     
                ObjNotification.Intrax_Program_Options__c = match.Intrax_Program_Option__c;        
               
                ObjNotification.Parent_Notification__c = newNotification.Id;
                List<Position__c> lstPos = [select p.OwnerId,p.Host_Company_Id__r.Name, p.Host_Company_Id__r.Id,  p.Host_Company_Id__r.PersonContactId, p.Host_Company_Id__c From Position__c p where p.Id = :match.Position_Name__c];
              
                ObjNotification.Account__c = lstPos[0].Host_Company_Id__c;
                  ObjNotification.Contact__c = lstPos[0].Host_Company_Id__r.PersonContactId;
                ObjNotification.Action_URL__c = 'NotificationRedirection?NotifyRec=true'; 
                list<Applicant_Info__c> appInfoHF = [SELECT Id, Account__c, Position__c, Position__r.Status__c, createdDate, Application_Stage__c, CreatedBy__c FROM Applicant_Info__c WHERE Position__c =: match.Position_Name__c];
                if(appInfoHF!=null && appInfoHF.size()>0)                
                  ObjNotification.OwnerId = appInfoHF[0].CreatedBy__c;
                system.debug('*****ObjNotification******'+ObjNotification);
                LstHFMatchesToBeNotified.add(ObjNotification);
               // rawRecords.put(member,LstMemberToBeNotified);
                system.debug('****LstHFMatchesToBeNotified********'+LstHFMatchesToBeNotified);
     }
       if(LstHFMatchesToBeNotified!=null && LstHFMatchesToBeNotified.size()>0)
       insert LstHFMatchesToBeNotified;
   }
     
 }
public static void MarkIGINotifyComplete(Id AppId, String IntraxProgramCategory) 
 {
    system.debug('**Inside NG**********'+AppId+'***********'+IntraxProgramCategory);
    List<Intrax_Program_Upload__c> ReqIPUList=new list<Intrax_Program_Upload__c>();
             If(IntraxProgramCategory=='Business' || IntraxProgramCategory=='Information Media & Communications' || IntraxProgramCategory=='Public Administration & Law' || IntraxProgramCategory=='Engineering')
                         {
                            ReqIPUList =[Select i.View_File__c, i.RecordTypeId, i.Parent_Intrax_Program_Upload__c, i.OwnerId, i.Name, i.Is_Parent__c, i.IsDeleted, i.Intrax_Programs__c, i.Id, i.Engagement__c, i.Document_Type__c, i.Document_GUID__c, i.Applicant_Info__c From Intrax_Program_Upload__c i where i.Applicant_Info__c =:AppId and i.Document_Type__c in :Constants.IGI_BUS_IN_REQ_DOCTYPES];
                            if(ReqIPUList!=null && ReqIPUList.size()>0)
                            {
                                //Boolean blnJobOfferDocument=false;
                                Boolean blnPassport=false;Boolean blnResume=false;Boolean blnLangProof=false;
                                
                                For(Intrax_Program_Upload__c ipu :ReqIPUList)
                                {
                                    //if(ipu.Document_Type__c == 'Offer-Document')
                                    //blnJobOfferDocument = true;                                       
                                    if(ipu.Document_Type__c == 'Passport')
                                    blnPassport = true;
                                    else if(ipu.Document_Type__c == 'Resume')
                                    blnResume = true;
                                    else if(ipu.Document_Type__c == 'Proof-of-Language-Level')
                                    blnLangProof = true;
                                    
                                }                                                       
                                //&& blnJobOfferDocument 
                                if(blnLangProof && blnPassport && blnResume)
                                {
                                    if(ReqIPUList[0].Engagement__c != null)
                                        UpdateNotification(ReqIPUList[0].Engagement__c);
                                }
                            
                            }                                                           
                        }
                        /*else if (IntraxProgramCategory=='Social Development')
                        {
                            ReqIPUList =[Select i.View_File__c, i.RecordTypeId, i.Parent_Intrax_Program_Upload__c, i.OwnerId, i.Name, i.Is_Parent__c, i.IsDeleted, i.Intrax_Programs__c, i.Id, i.Engagement__c, i.Document_Type__c, i.Document_GUID__c, i.Applicant_Info__c From Intrax_Program_Upload__c i where i.Applicant_Info__c =:AppId and i.Document_Type__c in :Constants.IGI_SD_REQ_DOCTYPES];
                            if(ReqIPUList!=null && ReqIPUList.size()>0)
                            {
                                Boolean blnResume=false;
                        
                                For(Intrax_Program_Upload__c ipu :ReqIPUList)
                                {                                                                           
                                    if(ipu.Document_Type__c == 'Resume')
                                    blnResume = true;                                       
                                }
                                if(!blnResume)
                                UpdateNotification(ReqIPUList[0].Engagement__c);
                            } 
                            
                        }*/
                        else if (IntraxProgramCategory=='Hospitality & Tourism')
                        {
                            ReqIPUList =[Select i.View_File__c, i.RecordTypeId, i.Parent_Intrax_Program_Upload__c, i.OwnerId, i.Name, i.Is_Parent__c, i.IsDeleted, i.Intrax_Programs__c, i.Id, i.Engagement__c, i.Document_Type__c, i.Document_GUID__c, i.Applicant_Info__c From Intrax_Program_Upload__c i where i.Applicant_Info__c =:AppId and i.Document_Type__c in :Constants.IGI_HT_REQ_DOCTYPES];
                            if(ReqIPUList!=null && ReqIPUList.size()>0)
                            {
                                Boolean blnJobOfferDocument=false;Boolean blnPassport=false;Boolean blnResume=false;Boolean blnLangProof=false;boolean blnIntroVideo=false;boolean blnUnivDiploma=false;
                                 
                                For(Intrax_Program_Upload__c ipu :ReqIPUList)
                                {
                                  // if(ipu.Document_Type__c == 'Offer-Document')
                                    //blnJobOfferDocument = true;
                                    if(ipu.Document_Type__c == 'Passport')
                                    blnPassport = true;
                                    else if(ipu.Document_Type__c == 'Resume')
                                    blnResume = true;
                                    else if(ipu.Document_Type__c == 'Proof-of-Language-Level')
                                    blnLangProof = true;   
                                    else if(ipu.Document_Type__c == 'Introduction-Video')
                                    blnIntroVideo = true;
                                    //else if(ipu.Document_Type__c == 'University-Diploma')
                                    //blnUnivDiploma = true;                                
                                } // && blnJobOfferDocument && blnUnivDiploma
                            if(blnLangProof  && blnPassport && blnResume && blnIntroVideo )
                                if(ReqIPUList[0].Engagement__c != null)
                                    UpdateNotification(ReqIPUList[0].Engagement__c);
                            } 
                            
                        }
         }
     public static void UpdateNotification(Id EngId)                    
     {
        system.debug('**Inside UpdateNotification**********'+EngId);
        List<Notification__c> NotifyToBeUpdated= new list<Notification__c>();
        if(EngId != null){
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c,Intrax_Program__c,Intrax_Program_Options__c,Status__c from Notification__c where Engagement__c =:EngId and type__c='Required Documents'];
        system.debug('**Inside allExistingNotifications**********'+allExistingNotifications);
                if(allExistingNotifications!=null && allExistingNotifications.size()>0)
                {
                    for(Notification__c notify : allExistingNotifications)
                    {
                        notify.Status__c='Confirmed';
                        NotifyToBeUpdated.add(notify);
                    }
                    if(NotifyToBeUpdated!=null && NotifyToBeUpdated.size()>0)
                    update NotifyToBeUpdated;
                } 
        }
    }

                  


 public static void CreateConfirmedStuNotification(List<Match__c> lstHFMatches)
    {    
        
      List<Notification__c> LstHFMatchesToBeNotified =  new list<Notification__c>();
      If(lstHFMatches!=null && lstHFMatches.size()>0)
      {
        for (Match__c match : lstHFMatches)
        {
              
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                 newNotification.Intrax_Program__c = match.Intrax_Program__c;     
                newNotification.Intrax_Program_Options__c = match.Intrax_Program_Option__c;        
             
                insert newNotification;
              
                system.debug('*****newNotification******'+newNotification);
                
                Notification__c ObjNotification = new Notification__c();
                ObjNotification.Subject__c = 'Your match with an Ayusa student is confirmed!';            
                ObjNotification.Body__c = 'Ayusa has confirmed your match. Click here to view your student and learn more about them!';            
                ObjNotification.Type__c = 'Confirmed Students';               
               ObjNotification.Position__c = match.Position_Name__c;               
                ObjNotification.Status__c = 'Not Started';
                 ObjNotification.Intrax_Program__c = match.Intrax_Program__c;     
                ObjNotification.Intrax_Program_Options__c = match.Intrax_Program_Option__c;        
            
                ObjNotification.Parent_Notification__c = newNotification.Id;
                List<Position__c> lstPos = [select p.OwnerId,p.Host_Company_Id__r.Name, p.Host_Company_Id__r.Id,  p.Host_Company_Id__r.PersonContactId, p.Host_Company_Id__c From Position__c p where p.Id = :match.Position_Name__c];
                ObjNotification.Account__c = lstPos[0].Host_Company_Id__c;
                ObjNotification.Contact__c = lstPos[0].Host_Company_Id__r.PersonContactId;
                ObjNotification.Action_URL__c = 'NotificationRedirection?ConfmatId=' + match.Position_Name__c; 
                list<Applicant_Info__c> appInfoHF = [SELECT Id, Account__c, Position__c, Position__r.Status__c, createdDate, Application_Stage__c, CreatedBy__c FROM Applicant_Info__c WHERE Position__c =: match.Position_Name__c];
                if(appInfoHF!=null && appInfoHF.size()>0)                
                  ObjNotification.OwnerId = appInfoHF[0].CreatedBy__c;
                system.debug('*****ObjNotification******'+ObjNotification);
                LstHFMatchesToBeNotified.add(ObjNotification);
               // rawRecords.put(member,LstMemberToBeNotified);
                system.debug('****LstHFMatchesToBeNotified********'+LstHFMatchesToBeNotified);
     }
       if(LstHFMatchesToBeNotified!=null && LstHFMatchesToBeNotified.size()>0)
       insert LstHFMatchesToBeNotified;
   }
     
 }
    public void CreatePTOrientationNotification(Id MatchId)
    {
        system.debug('******inside CreatePTOrientationNotification******'+ MatchId );
      // Changed Custom setting 'URL' to 'ApplicationConstants'- B01975
     //List<URL__c> ObjURL  = [select URL__c from URL__c where Type__c = 'Assessment_PTOrientationFlow'];
     Application_Constants__c ObjURL= Application_Constants__c.getInstance('OrientationFlowURL');
    String Flow_URL=ObjURL.Value__c;
    system.debug('******inside CreatePTInterviewNotification ObjURL******'+ObjURL.Value__c);
    List<Match__c> objMatch =  [Select m.Status__c, m.Start_Date__c, m.Engagement__r.Id,m.RecordTypeId, m.Position_Name__r.Host_Company_Id__c, m.Position_Name__c, m.Participant_Id__r.Name, m.Participant_Id__r.Id, m.Participant_Id__c, m.Name, m.Id From Match__c m where m.Id = :MatchId];  
     List<Assessment__c> LstExistingMatchPTAssessment = [Select Month_Number__c, Assessment_Date__c,Host_Name__c, Match_Name__c, Participant_Name__c, Position_Name__c, Engagement__c, Count_Down__c From Assessment__c where Participant_Name__c =: objMatch[0].Participant_Id__c and  RecordTypeId =: constants.ASS_AY_PT_Orientation];
           if(LstExistingMatchPTAssessment==null || LstExistingMatchPTAssessment.size()==0)
            {
                Notification__c ObjNotification = new Notification__c();
                ObjNotification.Subject__c = 'Your Orientation is due';
                //notification.Body__c = 'Please complete the assessments for months:'+hostMonthsNotCompleted+' @ ' +match.URL_Monthly_HF__c;
                if(!String.isBlank(Flow_URL))
                ObjNotification.Body__c =Flow_URL+'id=' + objMatch[0].Engagement__r.Id;
                
                ObjNotification.Status__c = 'Not Initiated';
                ObjNotification.Type__c = 'Participant';
                ObjNotification.Intrax_Program__c = 'Ayusa';
                ObjNotification.Match__c = objMatch[0].Id;
                ObjNotification.MatchStartDate__c=objMatch[0].Start_Date__c;
                ObjNotification.engagement__c = objMatch[0].Engagement__r.Id;
                //ObjNotification.accountid__c = objMatch[0].Participant_Id__c;
                List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :objMatch[0].Participant_Id__c];
                ObjNotification.account__c = PTAccount[0].Id;
                ObjNotification.contact__c = PTAccount[0].PersonContactId;
                    system.debug('******notification******'+notification );
                insert ObjNotification;
            }
                
        
    }
    
    
        public static void sendWTOrientation(Set<Id> probEngForNotificationSet){
        //Data structures to be used
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById, Intrax_Program__c,Intrax_Program_Options__c,
                  SEVIS_ID__c, Visa_Interview_Date__c, Visa_Interview_Status__c, Status__c, Placement_Status__c from Engagement__c where Id in :probEngForNotificationSet];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c,Intrax_Program__c,Intrax_Program_Options__c,Status__c from Notification__c where Engagement__c = :probEngForNotificationList];
        //New Type but not totally new to the engagement
        //List<Notification__c> netNewNotifications = new List<Notification__c>();
        //Map<Engagement__c,List<Notification__c>> netNewNotificationsMap = new Map<Engagement__c,List<Notification__c>>(); 
        //New 
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        
          map<Id, Applicant_Info__c> map_eng_with_app = new map<Id, Applicant_Info__c>();
        map<Id, Person_Info__c> map_app_with_pinfo = new map<Id, Person_Info__c>();
        map<Id, Person_Info__c> map_app_with_ppinfo = new map<Id, Person_Info__c>();
        
        set<id> allapplst = new set<id>();
        if(probEngForNotificationList.size() > 0)
        {
            list<Applicant_Info__c> applst = [SELECT Id, CreatedBy__c, Engagement__c,Application_Stage__c, Special_Diet_Indicated__c, Allergies_Indicated__c, Disabilities__c, Visa_Category__c, Visa_Type__c FROM Applicant_Info__c WHERE Engagement__c IN: probEngForNotificationList];
            if(applst.size() > 0)
            {
                for(Applicant_Info__c a : applst)
                {
                    map_eng_with_app.put(a.Engagement__c, a);
                    allapplst.add(a.id);
                }
                //Emergency Contact List
              /*  list<Person_Info__c> EmergencyList = [select ID, Applicant_Info__c, Name From Person_Info__c Where Applicant_Info__c IN :allapplst and Emergency_Contact_Indicated__c = 'Yes'];
                if (EmergencyList.size() > 0)
                {
                    for(Person_Info__c pers : EmergencyList)
                    {
                        map_app_with_pinfo.put(pers.Applicant_Info__c, pers);
                    }
                }
                //Health Info List
                list<Person_Info__c> PersonHealthList = [select Name, ID, Applicant_Info__c, Hospitalization_Indicated__c, Psychiatric_Treatment_Indicated__c, Medication_Indicated__c From Person_Info__c Where Applicant_Info__c IN :allapplst and Primary_Applicant__c = true];
                if (PersonHealthList.size() > 0)
                {
                    for(Person_Info__c ppers : PersonHealthList)
                    {
                        map_app_with_ppinfo.put(ppers.Applicant_Info__c, ppers);
                    }
                }
                */
            }
        }
        
        
        
        //Flags     
        Boolean WTQuestionnaire = false;
        Boolean DocuSignTC = false;
        Boolean SupportLetter = false;
        Boolean TravelVisa = false;
        Boolean PrimaryJob = false;
        Boolean VisaInterviewDate = false;
        Boolean VisaInterviewStatus = false;
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList){
            newNotifications = new List<Notification__c>();
            //netNewNotifications = new List<Notification__c>();
            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id)){
                WTQuestionnaire = false;
                DocuSignTC = false;
                SupportLetter = false;
                TravelVisa = false;
                PrimaryJob = false;
                VisaInterviewDate = false;
                VisaInterviewStatus = false;
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id)){
                    //if (notification.Type__c == 'WT Questionnaire' ){
                    if (notification.Type__c == 'Orientation' ){
                        //Existing Notification - Future Needs
                        WTQuestionnaire = true; 
                    }
                    if (notification.Type__c == 'Terms and Conditions' ){
                        //Existing Notification - Future Needs
                        DocuSignTC = true; 
                    }
                    if (notification.Type__c == 'Visa Support Letter' ){
                        //Existing Notification - Future Needs
                        SupportLetter = true; 
                    }
                    
                    if (notification.Type__c == 'Travel Info Needed' ){
                        //Existing Notification - Future Needs
                        TravelVisa = true; 
                    }
                    
                    if (notification.Type__c == 'Job Information Needed' && notification.Status__c != 'Confirmed'){
                        //Existing Notification - Future Needs
                        PrimaryJob = true; 
                    }
                    
                     if (notification.Type__c == 'Visa Interview' && (notification.Status__c == 'Not Initiated' || notification.Status__c == 'Not Started' || notification.Status__c == 'In Progress'))
                    {
                        VisaInterviewDate = true; 
                    }                    
                    if (notification.Type__c == 'Visa Result' && (notification.Status__c == 'Not Initiated' || notification.Status__c == 'Not Started' || notification.Status__c == 'In Progress'))
                    {
                        VisaInterviewStatus = true; 
                    }
                    
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                if (!WTQuestionnaire){
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    //newNotification.Type__c = 'WT Questionnaire';
                    newNotification.Type__c = 'Orientation';
                    //Add to list for bulk insert - raw records
                    //netNewNotifications.add(newNotification);
                    newNotifications.add(newNotification);                  
                }
                if (!DocuSignTC){
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    //newNotification.Type__c = 'WT Questionnaire';
                    newNotification.Type__c = 'Terms and Conditions';
                    //Add to list for bulk insert - raw records
                    //netNewNotifications.add(newNotification);
                    newNotifications.add(newNotification);                  
                }
                if (!SupportLetter && engagement.SEVIS_ID__c != NULL){
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    //newNotification.Type__c = 'WT Questionnaire';
                    newNotification.Type__c = 'Visa Support Letter';
                    //Add to list for bulk insert - raw records
                    //netNewNotifications.add(newNotification);
                    newNotifications.add(newNotification);                  
                }
                
                if (!TravelVisa && engagement.SEVIS_ID__c != NULL){
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    //newNotification.Type__c = 'WT Questionnaire';
                    newNotification.Type__c = 'Travel Info Needed';
                    //Add to list for bulk insert - raw records
                    //netNewNotifications.add(newNotification);
                    newNotifications.add(newNotification);                  
                }
                
                if (!PrimaryJob && engagement.Status__c == 'On Program' && (engagement.Placement_Status__c == 'Not Placed' || engagement.Placement_Status__c == 'Exempt') ){
                    list<Position_Info__c> selallPosInfo = [SELECT ID from Position_Info__c WHERE Engagement__c =: engagement.ID AND Is_Primary_SOA__c =: true AND Status__c IN ('Working','In-Review') ];
                    if (selallPosInfo.size() == 0)
                    {
                        Notification__c newNotification = new Notification__c();
                        newNotification.Type__c = 'Job Information Needed';
                        newNotifications.add(newNotification);       
                    }           
                }
                 system.debug('*****Visa Interview *** send***VisaInterviewDate: ' + VisaInterviewDate);
                 // map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1' &&
                  if (!VisaInterviewDate &&  map_eng_with_app.get(engagement.id).Application_Stage__c == 'Accepted' && engagement.Status__c == 'Program Ready' && ((engagement.Visa_Interview_Date__c == NULL && engagement.Visa_Interview_Status__c == 'Declined – Appealing Decision')||(engagement.Visa_Interview_Date__c == NULL && engagement.Visa_Interview_Status__c == NULL)))
                {
                    //Notification__c newNotification = new Notification__c();
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Interview';
                    newNotifications.add(newNotification);                  
                }
                 system.debug('*****Visa Result *** send***VisaInterviewStatus: ' + VisaInterviewStatus); //map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1' &&
                //if (!IGIVisaInterviewStatus && (engagement.Visa_Interview_Date__c != NULL) && (engagement.Visa_Interview_Date__c <= date.today()))
                if (!VisaInterviewStatus && (engagement.Visa_Interview_Status__c == NULL || engagement.Visa_Interview_Status__c == 'Declined – Appealing Decision') && engagement.Visa_Interview_Date__c != NULL && engagement.Visa_Interview_Date__c <= date.today() &&  map_eng_with_app.get(engagement.id).Application_Stage__c == 'Accepted')              
                {
                    //Notification__c newNotification = new Notification__c();
                    system.debug('*****Visa Result *** send***engagementID: ' + engagement.Id);
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Result';
                    newNotifications.add(newNotification);                  
                }
                //Reset Parent
                
                //netNewNotificationsMap.put(engagement,newNotifications);
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else{
                //Create Parent first
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                //Create new raw Questionnaire Notification
                newNotification = new Notification__c();
                //newNotification.Type__c = 'WT Questionnaire';
                newNotification.Type__c = 'Orientation';
                newNotifications.add(newNotification);
                newNotification = new Notification__c(); 
                //newNotification.Type__c = 'Terms and Conditions';
                newNotification.Type__c = 'Terms and Conditions';
                //Add to list for bulk insert - raw records
                newNotifications.add(newNotification);
                
                if (engagement.SEVIS_ID__c != NULL)
                {
                    newNotification = new Notification__c(); 
                    newNotification.Type__c = 'Visa Support Letter';
                    newNotifications.add(newNotification);
                    
                    newNotification = new Notification__c(); 
                    newNotification.Type__c = 'Travel Info Needed';
                    newNotifications.add(newNotification);
                }
                
                if (engagement.Status__c == 'On Program' && (engagement.Placement_Status__c == 'Not Placed' || engagement.Placement_Status__c == 'Exempt'))
                {
                    list<Position_Info__c> selallPosInfo = [SELECT ID from Position_Info__c WHERE Engagement__c =: engagement.ID AND Is_Primary_SOA__c =: true AND Status__c IN ('Working','In-Review') ];
                    if (selallPosInfo.size() == 0)
                    {
                        newNotification = new Notification__c(); 
                        newNotification.Type__c = 'Job Information Needed';
                        newNotifications.add(newNotification);
                    }
                }
                //   && map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1'
                 if (!VisaInterviewDate  && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Accepted' && engagement.Visa_Interview_Date__c == NULL && engagement.Status__c == 'Program Ready' && map_eng_with_app.get(engagement.id).CreatedBy.Type__c != 'Partner')
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Interview';
                    newNotifications.add(newNotification);
                }
                
                if (!VisaInterviewStatus && (engagement.Visa_Interview_Date__c != NULL) && (engagement.Visa_Interview_Date__c <= date.today()))
                {
                     system.debug('*****Visa Result *** send***engagementID: ' + engagement.Id);
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Result';
                    newNotifications.add(newNotification);                  
                }
                
                newNotificationsMap.put(engagement,newNotifications);
            }
            
        }       
        //populateNotification(netNewNotificationsMap);
        createNotification(newNotificationsMap);
        update updateNotifications;
        
    }
    
    public static void sendWTCheckInNotification(map<Id, Id> probEngForNotificationSet){
        //Data structures to be used
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById,Intrax_Program__c,Intrax_Program_Options__c from Engagement__c where Id in :probEngForNotificationSet.keySet()];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c,Intrax_Program__c,Intrax_Program_Options__c 
                                                                from Notification__c 
                                                                where Engagement__c = :probEngForNotificationList
                                                                AND (Type__c = 'Check-In Assessment' OR Type__c = 'Parent') // Added to avoid 50k GL issues
                                                                ];
       
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        //Flags     
        Boolean CheckInAssessment = false;
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList){
            newNotifications = new List<Notification__c>();

            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id)){
                CheckInAssessment = false;
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id)){
                    if (notification.Type__c == 'Check-In Assessment' ){
                        //Existing Notification - Future Needs
                        CheckInAssessment = true; 
                    }
                   
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                if (!CheckInAssessment){
                    system.debug('******* Creating new Check-In Notification');
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Check-In Assessment';
                    newNotification.Assessment__c = probEngForNotificationSet.get(engagement.Id);
                    //Add to list for bulk insert - raw records
                    //netNewNotifications.add(newNotification);
                    newNotifications.add(newNotification);                  
                }
                
                //Reset Parent
                
                //netNewNotificationsMap.put(engagement,newNotifications);
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else{
                //Create Parent first
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                //Create new raw Questionnaire Notification
                newNotification = new Notification__c();
                //newNotification.Type__c = 'WT Questionnaire';
                newNotification.Type__c = 'Check-In Assessment';
                newNotification.Assessment__c = probEngForNotificationSet.get(engagement.Id);
                newNotifications.add(newNotification);
                
                newNotificationsMap.put(engagement,newNotifications);
            }
            
        }       
        //populateNotification(netNewNotificationsMap);
        createNotification(newNotificationsMap);
        update updateNotifications;
        
    }
    
    //public static void sendWTMonthlyContactNotification(Set<Id> probEngForNotificationSet){
    public static void sendWTMonthlyContactNotification(map<Id, Id> probEngForNotificationMap){ // map: Engagement Id, Assessment Id
        //Data structures to be used
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById,Intrax_Program__c,Intrax_Program_Options__c from Engagement__c where Id in :probEngForNotificationMap.keySet()];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c, Assessment__c,Intrax_Program__c,Intrax_Program_Options__c 
                                                                from Notification__c 
                                                                where Engagement__c = :probEngForNotificationList
                                                               AND (Type__c = 'Monthly Contact' OR Type__c = 'Parent')// Added to avoid 50k GL issues
                                                                ];
        
        //New 
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        //Flags 
        //  
        Boolean MCAssessment = false;
        //
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList){
            newNotifications = new List<Notification__c>();
            //netNewNotifications = new List<Notification__c>();
            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id)){
                MCAssessment = false;
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id)){
                    system.debug(' ***** Notification id/Type: ' + notification.Id + ' / ' + notification.Type__c); 
                    /*if (notification.Type__c == 'Monthly Contact' ){
                    //    //Existing Notification - Future Needs
                        MCAssessment = true; 
                    }*/
                    
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                //
                /*if (!MCAssessment){ */
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Monthly Contact';
                    newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                    //Add to list for bulk insert - raw records
                    newNotifications.add(newNotification);                  
                /*} */
                
                //Reset Parent
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else{
                //Create Parent first
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                //Create new raw Questionnaire Notification
                newNotification = new Notification__c();
                newNotification.Type__c = 'Monthly Contact';
                newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                newNotifications.add(newNotification);
                
                newNotificationsMap.put(engagement,newNotifications);
            }
           
        }      
        //populateNotification(netNewNotificationsMap);
        createNotification(newNotificationsMap);
        update updateNotifications;
        
    }
    
    
    public static void sendIGIMonthlyContactNotification(map<Id, Id> probEngForNotificationMap){ // map: Engagement Id, Assessment Id
        //Data structures to be used
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById,Intrax_Program__c,Intrax_Program_Options__c from Engagement__c where Id in :probEngForNotificationMap.keySet()];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c, Assessment__c,Intrax_Program__c,Intrax_Program_Options__c 
                                                                from Notification__c 
                                                                where Engagement__c = :probEngForNotificationList
                                                                AND (Type__c = 'Monthly Contact' OR Type__c = 'Parent')// Added to avoid 50k GL issues
                                                                ];
        
        //New 
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        //Flags 
        //  
        Boolean MCAssessment = false;
        //
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList){
            newNotifications = new List<Notification__c>();
            //netNewNotifications = new List<Notification__c>();
            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id)){
                MCAssessment = false;
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id)){
                    system.debug(' ***** Notification id/Type: ' + notification.Id + ' / ' + notification.Type__c); 
                    /*if (notification.Type__c == 'Monthly Contact' ){
                    //    //Existing Notification - Future Needs
                        MCAssessment = true; 
                    }*/
                    
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                //
                /*if (!MCAssessment){ */
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Monthly Contact';
                    newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                    //Add to list for bulk insert - raw records
                    newNotifications.add(newNotification);                  
                /*} */
                
                //Reset Parent
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else{
                //Create Parent first
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                //Create new raw Questionnaire Notification
                newNotification = new Notification__c();
                newNotification.Type__c = 'Monthly Contact';
                newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                newNotifications.add(newNotification);
                
                newNotificationsMap.put(engagement,newNotifications);
            }
           
        }      
        //populateNotification(netNewNotificationsMap);
        createIGINotification(newNotificationsMap);
        update updateNotifications;
        
    }
    public static void sendIGIMidProgramNotification(map<Id, Id> probEngForNotificationMap){ // map: Engagement Id, Assessment Id
        //Data structures to be used
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById,Intrax_Program__c,Intrax_Program_Options__c from Engagement__c where Id in :probEngForNotificationMap.keySet()];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c, Assessment__c,Intrax_Program__c,Intrax_Program_Options__c 
                                                                from Notification__c 
                                                                where Engagement__c = :probEngForNotificationList
                                                                AND (Type__c = 'Mid Program Assessment' OR Type__c = 'Parent')// Added to avoid 50k GL issues
                                                                ];
        
        //New 
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        //Flags 
        //  
        Boolean MCAssessment = false;
        //
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList){
            newNotifications = new List<Notification__c>();
            //netNewNotifications = new List<Notification__c>();
            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id)){
                MCAssessment = false;
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id)){
                    system.debug(' ***** Notification id/Type: ' + notification.Id + ' / ' + notification.Type__c); 
                  if (notification.Type__c == 'Mid Program Assessment' ){
                        //Existing Notification - Future Needs
                        MCAssessment = true; 
                    }
                    
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                //
              if (!MCAssessment){
                    system.debug('******* Creating new Mid Program Notification Notification');
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Mid Program Assessment';
                    newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                    //Add to list for bulk insert - raw records
                    newNotifications.add(newNotification);                  
              }
                
                //Reset Parent
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else{
                //Create Parent first
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                //Create new raw Questionnaire Notification
                newNotification = new Notification__c();
                newNotification.Type__c = 'Mid Program Assessment';
                newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                newNotifications.add(newNotification);
                
                newNotificationsMap.put(engagement,newNotifications);
            }
           
        }      
        //populateNotification(netNewNotificationsMap);
        createIGINotification(newNotificationsMap);
        update updateNotifications;
        
    }
    
         public static void sendIGIFinalProgramNotification(map<Id, Id> probEngForNotificationMap){ // map: Engagement Id, Assessment Id
        //Data structures to be used
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById,Intrax_Program__c,Intrax_Program_Options__c from Engagement__c where Id in :probEngForNotificationMap.keySet()];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c, Assessment__c,Intrax_Program__c,Intrax_Program_Options__c 
                                                                from Notification__c 
                                                                where Engagement__c = :probEngForNotificationList
                                                                AND (Type__c = 'Final Program Assessment' OR Type__c = 'Parent')// Added to avoid 50k GL issues
                                                                ];
        
        //New 
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        //Flags 
        //  
        Boolean MCAssessment = false;
        //
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList){
            newNotifications = new List<Notification__c>();
            //netNewNotifications = new List<Notification__c>();
            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id)){
                MCAssessment = false;
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id)){
                    system.debug(' ***** Notification id/Type: ' + notification.Id + ' / ' + notification.Type__c); 
                  if (notification.Type__c == 'Final Program Assessment' ){
                        //Existing Notification - Future Needs
                        MCAssessment = true; 
                    }
                    
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                //
              if (!MCAssessment){
                    system.debug('******* Creating new Final Program Notification Notification');
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Final Program Assessment';
                    newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                    //Add to list for bulk insert - raw records
                    newNotifications.add(newNotification);                  
              }
                
                //Reset Parent
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else{
                //Create Parent first
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                //Create new raw Questionnaire Notification
                newNotification = new Notification__c();
                newNotification.Type__c = 'Final Program Assessment';
                newNotification.Assessment__c = probEngForNotificationMap.get(engagement.Id);
                newNotifications.add(newNotification);
                
                newNotificationsMap.put(engagement,newNotifications);
            }
           
        }      
        //populateNotification(netNewNotificationsMap);
        createIGINotification(newNotificationsMap);
        update updateNotifications;
        
    }

    
    // v2 of the CreateNotification Method --> Bulkifying actions... 
    public static void createNotification(Map<Engagement__c,List<Notification__c>> rawRecords){
        List<Notification__c> masterUpsertNotificationList = new List<Notification__c>();
        
        map<Id, Applicant_Info__c> map_eng_to_app = new map<Id, Applicant_Info__c>();
        list<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c IN: rawRecords.keySet()];
        if(app.size() > 0){
            for(Applicant_Info__c a : app){
                map_eng_to_app.put(a.Engagement__c, a);
            }
        }
        
        map<Id, Account> map_eng_to_ptaccount = new map<Id, Account>();
        
        list<Engagement__c> ptAcc_Eng = [SELECT Account_Id__c,Intrax_Program__c,Intrax_Program_Options__c FROM Engagement__c WHERE Id IN: rawRecords.keySet()];
        set<Id> account_Ids = new set<Id>();
        
        map<Id, Id> aux_map_eng_acc = new map<Id, Id>();
        for(Engagement__c e  : ptAcc_Eng){
            aux_map_eng_acc.put(e.Account_Id__c, e.Id);
            account_Ids.add(e.Account_Id__c);
        }
        list<Account> PTAccount = [Select Id, PersonContactId  From Account where ID IN :account_Ids];
        for(Account a : PTAccount){
            map_eng_to_ptaccount.put(aux_map_eng_acc.get(a.Id), a);
        }
         
        // Getting all the parent Notifications
        list<Notification__c> parentNotifications = [SELECT Id, Engagement__c,Intrax_Program__c,Intrax_Program_Options__c FROM Notification__c WHERE Engagement__c IN: rawRecords.KeySet() AND is_Parent__c = true AND Type__c = 'Parent'];
        map<Id, Id> map_pnotif_to_eng = new map<Id, Id>();
        for(Notification__c n : parentNotifications){
            map_pnotif_to_eng.put(n.Engagement__c, n.Id);
        }
        
        for (Engagement__c engagement : rawRecords.keySet()){
            Id parentId = null;
            system.debug('***** engagementID: ' + engagement.Id);
            if (rawRecords.get(engagement).size()> 0 && rawRecords.get(engagement).get(0).Type__c == 'Parent' && map_eng_to_app.get(engagement.Id).CreatedBy__c != null){
                system.debug('***** If there?s already a parent Notification, enter here...');
                rawRecords.get(engagement).get(0).Subject__c = 'Pending actions for WT Application';
                rawRecords.get(engagement).get(0).Body__c = 'Please take actions for Pending Items';
                rawRecords.get(engagement).get(0).Engagement__c = engagement.Id;
                rawRecords.get(engagement).get(0).Intrax_Program__c = engagement.Intrax_Program__c;     
                rawRecords.get(engagement).get(0).Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                /*List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: engagement.Id LIMIT 1];
                if(app != null && app.size()>0)
                { 
                rawRecords.get(engagement).get(0).OwnerId  = app[0].createdBy__c;
                }*/
                // v2
                rawRecords.get(engagement).get(0).OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                //rawRecords.get(engagement).get(0).OwnerId = engagement.createdById;             
                insert rawRecords.get(engagement).get(0);
                parentId = rawRecords.get(engagement).get(0).Id;
            }
            // v2
            else{
                parentId = map_pnotif_to_eng.get(engagement.Id);
            }
            /*else{
                Notification__c parentNotification = [select Id from Notification__c where Engagement__c = :engagement.Id and Type__c='Parent'];
                parentId = parentNotification.Id;
            }*/
            //List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :engagement.Account_Id__c];
            for (Notification__c notification : rawRecords.get(engagement)){
                
                if (notification.Type__c == 'Orientation'){
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Orientation Not Completed';
                    notification.Body__c = 'Completing your Orientation is an important part of having a successful program.  Please click the button below to get started.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    //notification.Engagement__c = engagement.Id;
                    /*
                    List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: engagement.Id LIMIT 1];
                    if(app != null && app.size()>0)
                    { 
                    notification.OwnerId = app[0].createdBy__c;
                    }*/
                    // v2
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    /*
                    notification.account__c = PTAccount[0].Id;
                    notification.contact__c = PTAccount[0].PersonContactId;
                    */
                    // v2
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'WT_Orientation_Steps?Id='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                 if (notification.Type__c == 'Visa Interview')
                {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'When is your visa interview?';
                    notification.Body__c = 'Please tell us the day your visa interview is scheduled for.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                   notification.Action_URL__c = 'wt_pt_visa_interview_dt?EnggId='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Visa Result')
                {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'How did your visa interview go?';
                    notification.Body__c = 'When you complete your visa interview, please provide Intrax with the official results of the interview. If there was some issue, we will contact you to help you resolve it.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'wt_pt_visa_interview_status?EnggId='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Terms and Conditions'){
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Program Terms and Conditions Not Signed';
                    notification.Body__c = 'Please click the button below to sign your Program Terms and Conditions.';
                    notification.Engagement__c = engagement.Id;
                      notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    /*
                    List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: engagement.Id LIMIT 1];
                    if(app != null && app.size()>0)
                    { 
                    notification.OwnerId = app[0].createdBy__c;
                    }*/
                    // v2
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    
                    /*
                    notification.account__c = PTAccount[0].Id;
                    notification.contact__c = PTAccount[0].PersonContactId;
                    */
                    // v2
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'IWT_TC_Agreement?Id='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Check-In Assessment'){
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Check-In Due';
                    notification.Body__c = 'Our records indicate that you should be arriving soon! Please complete the Check-In process as soon as you arrive to begin your program.';
                    notification.Engagement__c = engagement.Id;
                      notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    /*List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: engagement.Id LIMIT 1];
                    if(app != null && app.size()>0)
                    { 
                    notification.OwnerId = app[0].createdBy__c;
                    }
                    */
                    // v2
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    
                    /*
                    notification.account__c = PTAccount[0].Id;
                    notification.contact__c = PTAccount[0].PersonContactId;
                    */
                    // v2
                    if(map_eng_to_ptaccount.get(engagement.Id) != null){
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    }
                    system.debug('*****map_eng_to_app.get(engagement.Id).CreatedBy__c******'+map_eng_to_app.get(engagement.Id).CreatedBy__c);
                    
                    notification.Action_URL__c = 'participant_check_in?Id='+engagement.Id;
                    if(map_eng_to_app.get(engagement.Id).CreatedBy__c != null){
                        masterUpsertNotificationList.add(notification);
                    }
                }
                 if (notification.Type__c == 'Monthly Contact'){
                    //MC Assessment Code
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Monthly Contact Due';
                    notification.Body__c = 'Your Monthly Contact is due this week. Please complete it as soon as possible.';
                    notification.Engagement__c = engagement.Id;
                      notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    /*
                    List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: engagement.Id LIMIT 1];
                    if(app != null && app.size()>0)
                    { 
                    notification.OwnerId = app[0].createdBy__c;
                    }*/
                    // v2
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    
                    /*
                    notification.account__c = PTAccount[0].Id;
                    notification.contact__c = PTAccount[0].PersonContactId;
                    */
                    // v2
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'participant_monthly_contact?Id='+engagement.Id;
                    if(map_eng_to_app.get(engagement.Id).CreatedBy__c != null){
                        masterUpsertNotificationList.add(notification);
                    }
                    
                }
                if (notification.Type__c == 'Visa Support Letter'){
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Visa Support Letter';
                    notification.Body__c = 'Please print this support letter and take a copy of it with you to your upcoming visa interview.';
                    notification.Engagement__c = engagement.Id;
                      notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    /*List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: engagement.Id LIMIT 1];
                    if(app != null && app.size()>0)
                    { 
                    notification.OwnerId = app[0].createdBy__c;
                    }*/
                    // v2
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    
                    /*
                    notification.account__c = PTAccount[0].Id;
                    notification.contact__c = PTAccount[0].PersonContactId;
                    */
                    // v2
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'WT_Visa_Support_Letter?Id='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Travel Info Needed'){
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Travel Information Needed';
                    notification.Body__c = 'Please provide your travel details as soon as you have booked your trip.';
                    notification.Engagement__c = engagement.Id;
                      notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    /*List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: engagement.Id LIMIT 1];
                    if(app != null && app.size()>0)
                    { 
                    notification.OwnerId = app[0].createdBy__c;
                    }*/
                    // v2
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    
                    /*
                    notification.account__c = PTAccount[0].Id;
                    notification.contact__c = PTAccount[0].PersonContactId;
                    */
                    // v2
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'Participant_Travel_Visa';
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Job Information Needed'){
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Job Information Required';
                    notification.Body__c = 'Our records indicate that you are currently On Program and do not have a job. You are required to submit your new job information and documents as soon as you secure employment. Intrax will need to review and approve your job details before you can begin working.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'participant_second_job_Info?id='+engagement.Id+'&isPrimarySOA=true';
                    masterUpsertNotificationList.add(notification);
                }
            }
            if (rawRecords.get(engagement).size()> 0 && rawRecords.get(engagement).get(0).Type__c == 'Parent'){
                rawRecords.get(engagement).get(0).Status__c = 'Not Started';
                //rawRecords.get(engagement).get(0).account__c = PTAccount[0].Id;
                //rawRecords.get(engagement).get(0).contact__c = PTAccount[0].PersonContactId;
               rawRecords.get(engagement).get(0).OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                rawRecords.get(engagement).get(0).account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                rawRecords.get(engagement).get(0).contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                masterUpsertNotificationList.add(rawRecords.get(engagement).get(0));
            }
        }
        upsert masterUpsertNotificationList;
    }
    
    public static void CreateJobOfferNotification(ID JobMatchID)
    {
        Id parentId = null; 
        Match__c MatchInfo = [SELECT ID, Offer_Status__c, Engagement__c, Engagement__r.Account_Id__c, Position_Name__r.Host_Company_Id__r.Name FROM Match__c WHERE ID =: JobMatchID];
        List <Notification__c> NotificationList = [select Id,Engagement__c,Type__c from Notification__c where Engagement__c = :MatchInfo.Engagement__c AND Type__c = 'Parent'];
                    List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :MatchInfo.Engagement__r.Account_Id__c];
                    if (NotificationList.size() > 0)
                    {
                        Notification__c newNotification = new Notification__c();
                        newNotification.Type__c = 'Offer Extended';
                        newNotification.Intrax_Program__c = 'Work Travel';
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = NotificationList[0].ID;
                        newNotification.Subject__c = 'Congratulations! A new Job Offer has been extended to you and requires your signature!';
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' has offered you a job through Intrax Work Travel. However, your position is not confirmed until you accept by signing the job offer.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = JobMatchID;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'WT_Job_Agreement?Id='+JobMatchID+'&uType=Participant';
                        insert newNotification;
                    }
                    else 
                    {
                        Notification__c ParentNotification = new Notification__c();
                        ParentNotification.Type__c = 'Parent';
                        ParentNotification.Subject__c = 'Pending actions for WT Application';
                        ParentNotification.Body__c = 'Please take actions for Pending Items';
                        ParentNotification.Engagement__c = MatchInfo.Engagement__c;
                        insert ParentNotification;
                        parentId=ParentNotification.ID;
                        
                        
                        Notification__c newNotification = new Notification__c();
                        newNotification.Type__c = 'Offer Extended';
                        newNotification.Intrax_Program__c = 'Work Travel';
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = parentId;
                        newNotification.Subject__c = 'Congratulations! A new Job Offer has been extended to you and requires your signature!'; 
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' has offered you a job through Intrax Work Travel. However, your position is not confirmed until you accept by signing the job offer.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = JobMatchID;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'WT_Job_Agreement?Id='+JobMatchID+'&uType=Participant';
                        insert newNotification;
                    }
    }
    
    public static void CreateCandidateJobNotification(ID JobMatchID)
    {
        Id parentId = null; 
        Match__c MatchInfo = [SELECT ID, Offer_Status__c, Engagement__c, Engagement__r.Account_Id__c, Position_Name__r.Host_Company_Id__r.Name FROM Match__c WHERE ID =: JobMatchID];
        List <Notification__c> NotificationList = [select Id,Engagement__c,Type__c from Notification__c where Engagement__c = :MatchInfo.Engagement__c AND Type__c = 'Parent'];
                    List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :MatchInfo.Engagement__r.Account_Id__c];
                    if (NotificationList.size() > 0)
                    {
                        Notification__c newNotification = new Notification__c();
                        newNotification.Type__c = 'Offer Extended';
                        newNotification.Intrax_Program__c = 'Work Travel';
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = NotificationList[0].ID;
                        newNotification.Subject__c = 'Congratulations! A new Job Offer has been extended to you and requires your signature!';
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' has offered you a job through Intrax Work Travel. However, your position is not confirmed until you accept by signing the job offer.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = JobMatchID;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'WT_Cndt_Job_Agreement?Id='+JobMatchID+'&uType=Participant';
                        insert newNotification;
                    }
                    else 
                    {
                        Notification__c ParentNotification = new Notification__c();
                        ParentNotification.Type__c = 'Parent';
                        ParentNotification.Subject__c = 'Pending actions for WT Application';
                        ParentNotification.Body__c = 'Please take actions for Pending Items';
                        ParentNotification.Engagement__c = MatchInfo.Engagement__c;
                        insert ParentNotification;
                        parentId=ParentNotification.ID;
                        
                        
                        Notification__c newNotification = new Notification__c();
                        newNotification.Type__c = 'Offer Extended';
                        newNotification.Intrax_Program__c = 'Work Travel';
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = parentId;
                        newNotification.Subject__c = 'Congratulations! A new Job Offer has been extended to you and requires your signature!'; 
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' has offered you a job through Intrax Work Travel. However, your position is not confirmed until you accept by signing the job offer.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = JobMatchID;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'WT_Cndt_Job_Agreement?Id='+JobMatchID+'&uType=Participant';
                        insert newNotification;
                    }
    }
    
    public static void CreatePrimaryJobNotification(set<ID> EngListIDs)
    {
        if (EngListIDs != null && EngListIDs.size() > 0)
        {
            for (ID OneEnggID :EngListIDs)
            {
                    Id parentId = null; 
                    Engagement__c EnggInfo = [SELECT ID, Account_Id__c, Name, Intrax_Program__c, Intrax_Program_Options__c FROM Engagement__c WHERE ID =: OneEnggID];
                    List <Notification__c> NotificationList = [select Id,Engagement__c,Type__c from Notification__c where Engagement__c = :EnggInfo.ID AND Type__c = 'Parent'];
                    List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :EnggInfo.Account_Id__c];
                    if (NotificationList.size() > 0)
                    {
                        Notification__c newNotification = new Notification__c();
                        newNotification.Type__c = 'Job Information Needed';
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = NotificationList[0].ID;
                        newNotification.Subject__c = 'Job Information Required';
                        newNotification.Body__c = 'Our records indicate that you are currently On Program and do not have a job. You are required to submit your new job information and documents as soon as you secure employment. Intrax will need to review and approve your job details before you can begin working.';
                        newNotification.Engagement__c = EnggInfo.ID;
                        newNotification.Intrax_Program__c = EnggInfo.Intrax_Program__c; 
                        newNotification.Intrax_Program_Options__c = EnggInfo.Intrax_Program_Options__c;  
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: EnggInfo.ID and application_stage__c =: 'Accepted' LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'participant_second_job_Info?id='+EnggInfo.Id+'&isPrimarySOA=true';
                        insert newNotification;
                    }
                    else 
                    {
                        Notification__c ParentNotification = new Notification__c();
                        ParentNotification.Type__c = 'Parent';
                        ParentNotification.Subject__c = 'Pending actions for WT Application';
                        ParentNotification.Body__c = 'Please take actions for Pending Items';
                        ParentNotification.Engagement__c = EnggInfo.ID;
                        insert ParentNotification;
                        parentId=ParentNotification.ID;
                        
                        
                        Notification__c newNotification = new Notification__c();
                        newNotification.Type__c = 'Job Information Needed';
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = parentId;
                        newNotification.Subject__c = 'Job Information Required';
                        newNotification.Body__c = 'Our records indicate that you are currently On Program and do not have a job. You are required to submit your new job information and documents as soon as you secure employment. Intrax will need to review and approve your job details before you can begin working.';
                        newNotification.Engagement__c = EnggInfo.ID;
                        newNotification.Intrax_Program__c = EnggInfo.Intrax_Program__c; 
                        newNotification.Intrax_Program_Options__c = EnggInfo.Intrax_Program_Options__c;  
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: EnggInfo.ID and application_stage__c =: 'Accepted' LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'participant_second_job_Info?id='+EnggInfo.Id+'&isPrimarySOA=true';
                        insert newNotification;
                    }
            }
        }
    }
    
    public static void CreateDepartureNotification(set<ID> DepartEnggList)
    {
        if (DepartEnggList != NULL && DepartEnggList.size() >0)
        {
            list<Notification__c> allNewAddedNotifies = new list<Notification__c>();
            
            list<Engagement__c> allReadyEngg = [SELECT ID, Name, Intrax_Program__c, Intrax_Program_Options__c, Account_Id__c, Account_Id__r.PersonContactId, (Select CreatedBy__c from Applicant_Info__r WHERE application_stage__c =: 'Accepted' ORDER BY CreatedDate DESC) FROM Engagement__c WHERE ID IN :DepartEnggList];
            
            // Getting all the parent Notifications
            list<Notification__c> pNotifies = [SELECT Id, Engagement__c,Intrax_Program__c,Intrax_Program_Options__c FROM Notification__c WHERE Engagement__c IN: DepartEnggList AND is_Parent__c = true AND Type__c = 'Parent'];
            map<Id, Id> map_pnotify_to_engg = new map<Id, Id>();
            for(Notification__c np : pNotifies)
            {
                map_pnotify_to_engg.put(np.Engagement__c, np.Id);
            }
            
            for (Engagement__c eg:allReadyEngg)
            {
                if (map_pnotify_to_engg.get(eg.Id) != NULL)
                {
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Departure Info Needed';
                    newNotification.Status__c = 'Not Started';
                    newNotification.Parent_Notification__c = map_pnotify_to_engg.get(eg.Id);
                    newNotification.Subject__c = 'Departure Information Needed';
                    newNotification.Body__c = 'Our records indicate that your program will be ending soon. Please take a moment to provide your departure travel details.';
                    newNotification.Engagement__c = eg.ID;
                    newNotification.Intrax_Program__c = eg.Intrax_Program__c; 
                    newNotification.Intrax_Program_Options__c = eg.Intrax_Program_Options__c;  
                    
                    List<Applicant_Info__c> getApplList = eg.Applicant_Info__r;
                    if (getApplList != null && getApplList.size() > 0)
                    {
                        newNotification.OwnerId = getApplList[0].createdBy__c;
                    }
                    
                    newNotification.account__c = eg.Account_Id__c;
                    newNotification.contact__c = eg.Account_Id__r.PersonContactId;
                    newNotification.Action_URL__c = 'Participant_Travel_Visa';
                    allNewAddedNotifies.add(newNotification);
                }
                else
                {
                    Notification__c ParentNotification = new Notification__c();
                    ParentNotification.Type__c = 'Parent';
                    ParentNotification.Subject__c = 'Pending actions for WT Application';
                    ParentNotification.Body__c = 'Please take actions for Pending Items';
                    ParentNotification.Engagement__c = eg.ID;
                    insert ParentNotification;
                    ID parentId=ParentNotification.ID;
                        
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Departure Info Needed';
                    newNotification.Status__c = 'Not Started';
                    newNotification.Parent_Notification__c = parentId;
                    newNotification.Subject__c = 'Departure Information Needed';
                    newNotification.Body__c = 'Our records indicate that your program will be ending soon. Please take a moment to provide your departure travel details.';
                    newNotification.Engagement__c = eg.ID;
                    newNotification.Intrax_Program__c = eg.Intrax_Program__c; 
                    newNotification.Intrax_Program_Options__c = eg.Intrax_Program_Options__c;  
                    
                    List<Applicant_Info__c> getApplList = eg.Applicant_Info__r;
                    if (getApplList != null && getApplList.size() > 0)
                    {
                        newNotification.OwnerId = getApplList[0].createdBy__c;
                    }
                    
                    newNotification.account__c = eg.Account_Id__c;
                    newNotification.contact__c = eg.Account_Id__r.PersonContactId;
                    newNotification.Action_URL__c = 'Participant_Travel_Visa';
                    allNewAddedNotifies.add(newNotification);
                }
            }
            
            if(allNewAddedNotifies != NULL && allNewAddedNotifies.size()>0)
            {
                insert allNewAddedNotifies; 
            }
        }
    }
    
    
    public static void sendIGINotifications(Set<Id> probEngForNotificationSet)
    {
        List<Engagement__c> probEngForNotificationList = [select Orientation_Date__c,Id,Account_Id__c,OwnerId,createdById, Intrax_Program__c,Intrax_Program_Options__c,
                  SEVIS_ID__c, Status__c, Placement_Status__c, Visa_Interview_Date__c, Visa_Interview_Status__c, Terms_Accepted_Date__c from Engagement__c where Id in :probEngForNotificationSet];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c,Intrax_Program__c,Intrax_Program_Options__c,Status__c from Notification__c where Engagement__c = :probEngForNotificationList];
        
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        
        map<Id, Applicant_Info__c> map_eng_with_app = new map<Id, Applicant_Info__c>();
        map<Id, Person_Info__c> map_app_with_pinfo = new map<Id, Person_Info__c>();
        map<Id, Person_Info__c> map_app_with_ppinfo = new map<Id, Person_Info__c>();
        
        set<id> allapplst = new set<id>();
        if(probEngForNotificationList.size() > 0)
        {
            list<Applicant_Info__c> applst = [SELECT Id, CreatedBy__c, Engagement__c,Application_Stage__c, Special_Diet_Indicated__c, Allergies_Indicated__c, Disabilities__c, Visa_Category__c, Visa_Type__c FROM Applicant_Info__c WHERE Engagement__c IN: probEngForNotificationList];
            if(applst.size() > 0)
            {
                for(Applicant_Info__c a : applst)
                {
                    map_eng_with_app.put(a.Engagement__c, a);
                    allapplst.add(a.id);
                }
                //Emergency Contact List
                list<Person_Info__c> EmergencyList = [select ID, Applicant_Info__c, Name From Person_Info__c Where Applicant_Info__c IN :allapplst and Emergency_Contact_Indicated__c = 'Yes'];
                if (EmergencyList.size() > 0)
                {
                    for(Person_Info__c pers : EmergencyList)
                    {
                        map_app_with_pinfo.put(pers.Applicant_Info__c, pers);
                    }
                }
                //Health Info List
                list<Person_Info__c> PersonHealthList = [select Name, ID, Applicant_Info__c, Hospitalization_Indicated__c, Psychiatric_Treatment_Indicated__c, Medication_Indicated__c From Person_Info__c Where Applicant_Info__c IN :allapplst and Primary_Applicant__c = true];
                if (PersonHealthList.size() > 0)
                {
                    for(Person_Info__c ppers : PersonHealthList)
                    {
                        map_app_with_ppinfo.put(ppers.Applicant_Info__c, ppers);
                    }
                }
            }
        }
        
        
        //Flags  
        Notification__c newNotification = new Notification__c();    
        Boolean IGIEmergencyContact = false;
        Boolean IGIVisaInterviewDate = false;
        Boolean IGIVisaInterviewStatus = false;
        Boolean IGITravelVisa = false;
        //Boolean IGIRequiredDocuments=false;
        Boolean IGIHealthInfo = false;
        Boolean IGITandC = false;
        Boolean IGIOrient = false;
        IGITravelVisa = false;
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList)
        {
            newNotifications = new List<Notification__c>();
            IGIEmergencyContact = false;
            IGIVisaInterviewDate = false;
            IGIVisaInterviewStatus = false;
            //IGIRequiredDocuments=false;
            IGIHealthInfo = false;
            IGITandC = false;
            IGIOrient=false;
            IGITravelVisa = false;
            //netNewNotifications = new List<Notification__c>();
            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id))
            {
                
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id))
                {
                    if (notification.Type__c == 'Emergency Contact' )
                    {
                        IGIEmergencyContact = true; 
                    }
                    if (notification.Type__c == 'Health Information' )
                    {
                        IGIHealthInfo = true; 
                    }
                    
                    if (notification.Type__c == 'Terms and Conditions' )
                    {
                        IGITandC = true; 
                    }
                    if (notification.Type__c == 'Travel Info Needed' )
                    {
                        IGITravelVisa = true; 
                    }
                //    B-01251   
                
                    //if (notification.Type__c == 'Orientation' &&  (notification.Status__c == 'Not Started'  || notification.Status__c == 'In Progress'   ))
                    if (notification.Type__c == 'Orientation')
                    {
                        IGIOrient = true; 
                    }
                    if (notification.Type__c == 'Visa Interview' && (notification.Status__c == 'Not Initiated' || notification.Status__c == 'Not Started' || notification.Status__c == 'In Progress'))
                    {
                        IGIVisaInterviewDate = true; 
                        system.debug('*****Visa Interview *** send***engagementID: ' + IGIVisaInterviewDate);
                    }                    
                    if (notification.Type__c == 'Visa Result' && (notification.Status__c == 'Not Initiated' || notification.Status__c == 'Not Started' || notification.Status__c == 'In Progress'))
                    {
                        IGIVisaInterviewStatus = true; 
                         system.debug('*****Visa Result *** send***engagementID: ' + IGIVisaInterviewStatus);
                    }
                    /*if (notification.Type__c == 'Required Documents' && (notification.Status__c == 'Not Started' || notification.Status__c == 'In Progress'))
                    {
                        IGIRequiredDocuments = true; 
                    }*/
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                if (!IGIEmergencyContact && (map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id)==NULL))
                {
                    //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Emergency Contact';
                    newNotifications.add(newNotification);                  
                }
                else if (!IGIEmergencyContact && (map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id)!=NULL) && (map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id).Name == 'null null' || map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id).Name == ''))
                {
                     //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Emergency Contact';
                    newNotifications.add(newNotification);  
                }
                
                if (!IGIHealthInfo && (map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id)!= NULL) && (map_eng_with_app.get(engagement.id) != NULL) && (map_eng_with_app.get(engagement.id).Special_Diet_Indicated__c == NULL || map_eng_with_app.get(engagement.id).Special_Diet_Indicated__c == '' || map_eng_with_app.get(engagement.id).Allergies_Indicated__c == NULL || map_eng_with_app.get(engagement.id).Allergies_Indicated__c == '' || map_eng_with_app.get(engagement.id).Disabilities__c == NULL || map_eng_with_app.get(engagement.id).Disabilities__c == ''  || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Hospitalization_Indicated__c == NULL || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Hospitalization_Indicated__c == '' || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Psychiatric_Treatment_Indicated__c == '' || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Psychiatric_Treatment_Indicated__c == NULL || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Medication_Indicated__c == '' || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Medication_Indicated__c == NULL ))
                {
                    //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Health Information';
                    newNotifications.add(newNotification);  
                }
                
                if (!IGITandC && engagement.Terms_Accepted_Date__c == NULL && !engagement.Intrax_Program_Options__c.contains('Internship Group'))
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Terms and Conditions';
                    newNotifications.add(newNotification);                  
                }
                
                if (!IGITravelVisa && engagement.SEVIS_ID__c != NULL)
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Travel Info Needed';
                    newNotifications.add(newNotification);                  
                }
                
                //  B-01251
                 if (!IGIOrient && engagement.Orientation_Date__c == NULL && engagement.Status__c == 'Program Ready' && map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1' )
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Orientation';
                    newNotifications.add(newNotification);                  
                }
                if (!IGIVisaInterviewDate && map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1' && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Accepted' && engagement.Status__c == 'Program Ready' && ((engagement.Visa_Interview_Date__c == NULL && engagement.Visa_Interview_Status__c == 'Declined – Appealing Decision')||(engagement.Visa_Interview_Date__c == NULL && engagement.Visa_Interview_Status__c == NULL)))
                {
                    //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Interview';
                    newNotifications.add(newNotification);   
                     system.debug('*****Visa Interview *** send***engagementID: ' + engagement.Id);               
                }
                
                //if (!IGIVisaInterviewStatus && (engagement.Visa_Interview_Date__c != NULL) && (engagement.Visa_Interview_Date__c <= date.today()))
                if (!IGIVisaInterviewStatus && (engagement.Visa_Interview_Status__c == NULL || engagement.Visa_Interview_Status__c == 'Declined – Appealing Decision') && engagement.Visa_Interview_Date__c != NULL && engagement.Visa_Interview_Date__c <= date.today() && map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1' && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Accepted')              
                {
                    //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Result';
                    newNotifications.add(newNotification); 
                     system.debug('*****Visa Result *** send***engagementID: ' + engagement.Id);                 
                }
               
                /* if (!IGIRequiredDocuments && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Submitted' )
                {
                    //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Required Documents';
                    newNotifications.add(newNotification);                  
                } */
                //Reset Parent
                
                //netNewNotificationsMap.put(engagement,newNotifications);
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else
            {
                //Create Parent first
                //Notification__c newNotification = new Notification__c();
                newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                
                if (!IGIEmergencyContact && (map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id)==NULL))
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Emergency Contact';
                    newNotifications.add(newNotification);
                }
                else if (!IGIEmergencyContact && (map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id)!=NULL) && (map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id).Name == 'null null' || map_app_with_pinfo.get(map_eng_with_app.get(engagement.id).id).Name == ''))
                {
                     //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Emergency Contact';
                    newNotifications.add(newNotification);  
                }
                
                if (!IGIHealthInfo && (map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id)!= NULL) && (map_eng_with_app.get(engagement.id) != NULL) && (map_eng_with_app.get(engagement.id).Special_Diet_Indicated__c == NULL || map_eng_with_app.get(engagement.id).Special_Diet_Indicated__c == '' || map_eng_with_app.get(engagement.id).Allergies_Indicated__c == NULL || map_eng_with_app.get(engagement.id).Allergies_Indicated__c == '' || map_eng_with_app.get(engagement.id).Disabilities__c == NULL || map_eng_with_app.get(engagement.id).Disabilities__c == ''  || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Hospitalization_Indicated__c == NULL || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Hospitalization_Indicated__c == '' || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Psychiatric_Treatment_Indicated__c == '' || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Psychiatric_Treatment_Indicated__c == NULL || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Medication_Indicated__c == '' || map_app_with_ppinfo.get(map_eng_with_app.get(engagement.id).id).Medication_Indicated__c == NULL ))
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Health Information';
                    newNotifications.add(newNotification);  
                }
                if (!IGITandC && engagement.Terms_Accepted_Date__c == NULL && !engagement.Intrax_Program_Options__c.contains('Internship Group'))
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Terms and Conditions';
                    newNotifications.add(newNotification);                  
                }
                
                if (engagement.SEVIS_ID__c != NULL)
                {
                    newNotification = new Notification__c(); 
                    newNotification.Type__c = 'Travel Info Needed';
                    newNotifications.add(newNotification);
                }
                // B-01251
                if (!IGIOrient && engagement.Orientation_Date__c == NULL && engagement.Status__c == 'Program Ready'  && map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1')
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Orientation';
                    newNotifications.add(newNotification); 
                    
                }
                if (!IGIVisaInterviewStatus && map_eng_with_app.get(engagement.id).Visa_Type__c == 'J-1' && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Accepted' && engagement.Visa_Interview_Date__c == NULL)
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Interview';
                    newNotifications.add(newNotification);
                     system.debug('*****Visa Interview1 *** send***engagementID: ' + newNotification); 
                }
                
                if (!IGIVisaInterviewStatus && (engagement.Visa_Interview_Date__c != NULL) && (engagement.Visa_Interview_Date__c <= date.today()))
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Visa Result';
                    newNotifications.add(newNotification);     
                    system.debug('*****Visa Result1 *** send***engagementID: ' + newNotification);              
                }
                 /*if (!IGIRequiredDocuments && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Submitted')
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Required Documents';
                    newNotifications.add(newNotification);                  
                } */
                
                newNotificationsMap.put(engagement,newNotifications);
            }
            
        }       
        //populateNotification(netNewNotificationsMap);
        createIGINotification(newNotificationsMap);
        update updateNotifications;
        
    }
    
    // v2 of the CreateNotification Method --> Bulkifying actions... 
    public static void createIGINotification(Map<Engagement__c,List<Notification__c>> rawRecords)
    {
        List<Notification__c> masterUpsertNotificationList = new List<Notification__c>();
        
        map<Id, Applicant_Info__c> map_eng_to_app = new map<Id, Applicant_Info__c>();
        list<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c IN: rawRecords.keySet()];
        if(app.size() > 0){
            for(Applicant_Info__c a : app){
                map_eng_to_app.put(a.Engagement__c, a);
            }
        }
        
        map<Id, Account> map_eng_to_ptaccount = new map<Id, Account>();
        
        list<Engagement__c> ptAcc_Eng = [SELECT Account_Id__c,Intrax_Program__c,Intrax_Program_Options__c FROM Engagement__c WHERE Id IN: rawRecords.keySet()];
        set<Id> account_Ids = new set<Id>();
        
        map<Id, Id> aux_map_eng_acc = new map<Id, Id>();
        for(Engagement__c e  : ptAcc_Eng){
            aux_map_eng_acc.put(e.Account_Id__c, e.Id);
            account_Ids.add(e.Account_Id__c);
        }
        list<Account> PTAccount = [Select Id, PersonContactId  From Account where ID IN :account_Ids];
        for(Account a : PTAccount){
            map_eng_to_ptaccount.put(aux_map_eng_acc.get(a.Id), a);
        }
        
        // Getting all the parent Notifications
        list<Notification__c> parentNotifications = [SELECT Id, Engagement__c,Intrax_Program__c,Intrax_Program_Options__c FROM Notification__c WHERE Engagement__c IN: rawRecords.KeySet() AND is_Parent__c = true AND Type__c = 'Parent'];
        map<Id, Id> map_pnotif_to_eng = new map<Id, Id>();
        for(Notification__c n : parentNotifications){
            map_pnotif_to_eng.put(n.Engagement__c, n.Id);
        }
        
        for (Engagement__c engagement : rawRecords.keySet())
        {
            Id parentId = null;
            system.debug('***** engagementID: ' + engagement.Id);
            if (rawRecords.get(engagement).size()> 0 && rawRecords.get(engagement).get(0).Type__c == 'Parent' && map_eng_to_app.get(engagement.Id).CreatedBy__c != null)
            {
                system.debug('***** If there?s already a parent Notification, enter here...');
                rawRecords.get(engagement).get(0).Subject__c = 'Pending actions for IGI Application';
                rawRecords.get(engagement).get(0).Body__c = 'Please take actions for Pending Items';
                rawRecords.get(engagement).get(0).Engagement__c = engagement.Id;
                rawRecords.get(engagement).get(0).Intrax_Program__c = engagement.Intrax_Program__c;     
                rawRecords.get(engagement).get(0).Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                rawRecords.get(engagement).get(0).OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                insert rawRecords.get(engagement).get(0);
                parentId = rawRecords.get(engagement).get(0).Id;
            }
            // v2
            else
            {
                parentId = map_pnotif_to_eng.get(engagement.Id);
            }
            //List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :engagement.Account_Id__c];
            for (Notification__c notification : rawRecords.get(engagement))
            {
                
                if (notification.Type__c == 'Emergency Contact')
                {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Emergency Contact  Needed';
                    notification.Body__c = 'Intrax needs to know who we should contact in case you have an emergency.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_pt_app_emergency?Id='+map_eng_to_app.get(engagement.Id).Id+ '&FromNotify=1';
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Visa Interview')
                {   system.debug('*****Visa Interview *** create***engagementID: ' + engagement.Id);
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'When is your visa interview?';
                    notification.Body__c = 'Please tell us the day your visa interview is scheduled for.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                   notification.Action_URL__c = 'igi_pt_visa_interview_dt?EnggId='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Visa Result')
                {   system.debug('*****Visa Result *** create***engagementID: ' + engagement.Id);
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'How did your visa interview go?';
                    notification.Body__c = 'When you complete your visa interview, please provide Intrax with the official results of the interview. If there was some issue, we will contact you to help you resolve it.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_pt_visa_interview_status?EnggId='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                if (notification.Type__c == 'Required Documents')
               {
                   system.debug('*****notification******'+notification);
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Documents Needed';
                    notification.Body__c = 'Additional documents required as part of the application process... Go to the upload page to see which documents still need to be provided.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_pt_app_documents?Id='+map_eng_to_app.get(engagement.Id).Id + '&view=true&doctype=igi-documents';
                    masterUpsertNotificationList.add(notification);
                }
                
                if (notification.Type__c == 'Health Information')
                {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Health Information Needed';
                    notification.Body__c = 'Health information will be used to guide Intrax in making appropriate arrangements for you as an Intrax participant and will be forwarded to our in-country directors. All information will be kept confidential.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_pt_app_health?Id='+map_eng_to_app.get(engagement.Id).Id+ '&FromNotify=1';
                    masterUpsertNotificationList.add(notification);
                }
               //    B-01251 
                 if (notification.Type__c == 'Orientation')
               {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Orientation Not Completed';
                    notification.Body__c = 'Completing your Orientation is an important part of having a successful program.  Please click the button below to get started.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                   
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    notification.Action_URL__c = 'IGI_Orientation_Steps?EnggParam='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
                 // end  Story B-01251
                
                if (notification.Type__c == 'Terms and Conditions')
                {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Sign Programs Terms and Conditions';
                    notification.Body__c = 'Please click the button below to sign your program terms and conditions.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_pt_terms_conditions?Id='+engagement.Id;
                    masterUpsertNotificationList.add(notification);
                }
               
                if (notification.Type__c == 'Travel Info Needed')
                {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Travel Information Needed';
                    notification.Body__c = 'Please provide your travel details as soon as you have booked your trip.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    notification.Action_URL__c = 'igi_pt_travel_visa_details?type=arrival&editMode=true';
                    masterUpsertNotificationList.add(notification);
                }
                
               if (notification.Type__c == 'Monthly Contact'){
                    //MC Assessment Code
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Monthly Contact';
                    notification.Body__c = 'It is time for your monthly contact. Please complete it as soon as possible.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_participant_monthly_contact?Id='+engagement.Id;
                    if(map_eng_to_app.get(engagement.Id).CreatedBy__c != null){
                        masterUpsertNotificationList.add(notification);
                    }
                    
                }
                
                 if (notification.Type__c == 'Mid Program Assessment'){
                    //MC Assessment Code
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Mid Program Assessment';
                    notification.Body__c = 'It is time for your Mid Program Assessment. Please complete it as soon as possible.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_participant_mid_program?Id='+engagement.Id;
                    if(map_eng_to_app.get(engagement.Id).CreatedBy__c != null){
                        masterUpsertNotificationList.add(notification);
                    }
                    
                }
               
                 if (notification.Type__c == 'Final Program Assessment'){
                    //MC Assessment Code
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Final Program Assessment';
                    notification.Body__c = 'You are almost finished with your Internship! Please complete your Final Program Assessment as soon as possible to let us know how it went.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c;  
                    notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    
                    notification.Action_URL__c = 'igi_participant_final_program?Id='+engagement.Id;
                    if(map_eng_to_app.get(engagement.Id).CreatedBy__c != null){
                        masterUpsertNotificationList.add(notification);
                    }
                    
                }                
                
                if (notification.Type__c == 'Check-In Assessment')
                {
                    notification.Status__c = 'Not Started';
                    notification.Parent_Notification__c = parentId;
                    notification.Subject__c = 'Check-In Due';
                    notification.Body__c = 'Our records indicate that you should be arriving soon! Please complete the Check-In process as soon as you arrive to begin your program.';
                    notification.Engagement__c = engagement.Id;
                    notification.Intrax_Program__c = engagement.Intrax_Program__c;     
                    notification.Intrax_Program_Options__c = engagement.Intrax_Program_Options__c; 
                    if (map_eng_to_app.get(engagement.Id).CreatedBy__c != null)
                        notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    else 
                        notification.OwnerId = engagement.OwnerId;
                    //notification.OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                    
                    notification.account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                    notification.contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                    system.debug('*****map_eng_to_app.get(engagement.Id).CreatedBy__c******'+map_eng_to_app.get(engagement.Id).CreatedBy__c);
                    //notification.Action_URL__c = 'participant_check_in?Id='+engagement.Id;
                    notification.Action_URL__c = 'igi_pt_check_in?Id='+engagement.Id;
                  //  if(map_eng_to_app.get(engagement.Id).CreatedBy__c != null){
                      masterUpsertNotificationList.add(notification);
                   // }
                }
              
                
            }
            if (rawRecords.get(engagement).size()> 0 && rawRecords.get(engagement).get(0).Type__c == 'Parent')
            {
                rawRecords.get(engagement).get(0).Status__c = 'Not Started';
                rawRecords.get(engagement).get(0).OwnerId = map_eng_to_app.get(engagement.Id).CreatedBy__c;
                rawRecords.get(engagement).get(0).account__c = map_eng_to_ptaccount.get(engagement.Id).Id;
                rawRecords.get(engagement).get(0).contact__c = map_eng_to_ptaccount.get(engagement.Id).PersonContactId;
                masterUpsertNotificationList.add(rawRecords.get(engagement).get(0));
            }
        }
        upsert masterUpsertNotificationList;
        system.debug('*****masterUpsertNotificationList**' + masterUpsertNotificationList);
    }
    
    
    
    //For IGI Required Document Missing Notification (Start)
    
    public static void sendIGIDocNotifications(Set<Id> probEngForNotificationSet)
    {
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById, Intrax_Program__c,Intrax_Program_Options__c,
                  SEVIS_ID__c, Status__c, Placement_Status__c, Visa_Interview_Date__c, Visa_Interview_Status__c, Terms_Accepted_Date__c from Engagement__c where Id in :probEngForNotificationSet];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c,Intrax_Program__c,Intrax_Program_Options__c,Status__c from Notification__c where Engagement__c = :probEngForNotificationList];
        
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
           if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        
        map<Id, Applicant_Info__c> map_eng_with_app = new map<Id, Applicant_Info__c>();
       
        set<id> allapplst = new set<id>();
        
        if(probEngForNotificationList.size() > 0)
        {
            list<Applicant_Info__c> applst = [SELECT Id, CreatedBy__c, Engagement__c,Application_Stage__c, Special_Diet_Indicated__c, Allergies_Indicated__c, Disabilities__c, Visa_Category__c, Visa_Type__c FROM Applicant_Info__c WHERE Engagement__c IN: probEngForNotificationList];
            if(applst.size() > 0)
            {
                for(Applicant_Info__c a : applst)
                {
                    map_eng_with_app.put(a.Engagement__c, a);
                    allapplst.add(a.id);
                }
            }
        }
        
        //Flags  
        Notification__c newNotification = new Notification__c();    
        Boolean IGIRequiredDocuments=false;
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList)
        {
            newNotifications = new List<Notification__c>();
            IGIRequiredDocuments=false;
            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id))
            {
                
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id))
                {
                   // if (notification.Type__c == 'Required Documents' && (notification.Status__c == 'Not Started' || notification.Status__c == 'In Progress'))
                   if (notification.Type__c == 'Required Documents' )
                    {
                        IGIRequiredDocuments = true; 
                    }
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                if (!IGIRequiredDocuments && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Submitted' )
                {
                    //Notification__c newNotification = new Notification__c();
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Required Documents';
                    newNotifications.add(newNotification);                  
                } 
                //Reset Parent
                
                //netNewNotificationsMap.put(engagement,newNotifications);
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else
            {
                //Create Parent first
                //Notification__c newNotification = new Notification__c();
                newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                
                if (!IGIRequiredDocuments && map_eng_with_app.get(engagement.id).Application_Stage__c == 'Submitted')
                {
                    newNotification = new Notification__c();
                    newNotification.Type__c = 'Required Documents';
                    newNotifications.add(newNotification);                  
                } 
                
                newNotificationsMap.put(engagement,newNotifications);
            }
            
        }       
        //populateNotification(netNewNotificationsMap);
        createIGINotification(newNotificationsMap);
        update updateNotifications;
    } 
    
    public static void sendIGICheckInNotification(map<Id, Id> probEngForNotificationSet)
    {
        //Data structures to be used
        List<Engagement__c> probEngForNotificationList = [select Id,Account_Id__c,OwnerId,createdById,Intrax_Program__c,Intrax_Program_Options__c from Engagement__c where Id in :probEngForNotificationSet.keySet()];
        Map<Id,List<Notification__c>> existingNotifications = new Map<Id,List<Notification__c>>();
        List <Notification__c> allExistingNotifications = [select Id,Engagement__c,Type__c,Intrax_Program__c,Intrax_Program_Options__c 
                                                                from Notification__c 
                                                                where Engagement__c = :probEngForNotificationList
                                                                AND (Type__c = 'Check-In Assessment' OR Type__c = 'Parent') // Added to avoid 50k GL issues
                                                                ];
       
        List<Notification__c> newNotifications = new List<Notification__c>();
        Map<Engagement__c,List<Notification__c>> newNotificationsMap = new Map<Engagement__c,List<Notification__c>>();
        //Update existing - future logic
        List<Notification__c> updateNotifications = new List<Notification__c>();
        //Load existing Notifications for the given probables
        for (Notification__c notification : allExistingNotifications){
            if (existingNotifications.containsKey(notification.Engagement__c)){
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
            else{
                existingNotifications.put(notification.Engagement__c,new List<Notification__c>());
                existingNotifications.get(notification.Engagement__c).add(notification);
            }
        }
        //Flags     
        Boolean CheckInAssessment = false;
        //Check if already notified
        for (Engagement__c engagement : probEngForNotificationList){
            newNotifications = new List<Notification__c>();

            //Create Notification if needed
            if (existingNotifications.containsKey(engagement.Id)){
                CheckInAssessment = false;
                //Future Logic to do reprocess existing notifications
                for (Notification__c notification : existingNotifications.get(engagement.Id)){
                    if (notification.Type__c == 'Check-In Assessment' ){
                        //Existing Notification - Future Needs
                        CheckInAssessment = true; 
                    }
                   
                    if (notification.Type__c == 'Parent'){
                        notification.Status__c = 'Not Started';
                        updateNotifications.add(notification);
                    }
                }
                if (!CheckInAssessment){
                    system.debug('******* Creating new Check-In Notification');
                    //Create new raw Questionnaire Notification
                    Notification__c newNotification = new Notification__c();
                    newNotification.Type__c = 'Check-In Assessment';
                    newNotification.Assessment__c = probEngForNotificationSet.get(engagement.Id);
                    //Add to list for bulk insert - raw records
                    //netNewNotifications.add(newNotification);
                    newNotifications.add(newNotification);                  
                }
                
                //Reset Parent
                
                //netNewNotificationsMap.put(engagement,newNotifications);
                newNotificationsMap.put(engagement,newNotifications);
            }
            //No Notification history for the given engagement
            else{
                //Create Parent first
                Notification__c newNotification = new Notification__c();
                newNotification.Type__c = 'Parent';
                newNotifications.add(newNotification);
                //Create new raw Questionnaire Notification
                newNotification = new Notification__c();
                //newNotification.Type__c = 'WT Questionnaire';
                newNotification.Type__c = 'Check-In Assessment';
                newNotification.Assessment__c = probEngForNotificationSet.get(engagement.Id);
                newNotifications.add(newNotification);
                
                newNotificationsMap.put(engagement,newNotifications);
            }
            
        }       
        //populateNotification(netNewNotificationsMap);
        createIGINotification(newNotificationsMap);
        update updateNotifications;
        
    }
    
    public static void CreateIGIInterviewNotification(set<id> AllMatchIds)
    {
        Id parentId = null; 
    Match__c MatchInfo = new Match__c();
    Notification__c newNotification = new Notification__c();
    list<Notification__c> newNotifications = new list<Notification__c>();

    if (AllMatchIds.size() > 0)
    {
        //set<Id> AllMatchIds =  MatchMapList.keyset();

        for(Id mid: AllMatchIds)
                {
            //MatchInfo = MatchMapList.get(mid);
            MatchInfo = [SELECT ID, Engagement__c, Engagement__r.Account_Id__c, Engagement__r.Intrax_Program__c, Engagement__r.Intrax_Program_Options__c, Position_Name__r.Host_Company_Id__r.Name  FROM Match__c WHERE id =: mid];
            List <Notification__c> NotificationList = [select Id,Engagement__c,Type__c from Notification__c where Engagement__c = :MatchInfo.Engagement__c AND Type__c = 'Parent'];
                system.debug('MatchInfo.Engagement__r.Account_Id__c ****'+MatchInfo); 
                    List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :MatchInfo.Engagement__r.Account_Id__c];
                    system.debug('PTAccount ****'+PTAccount);
                    if (NotificationList.size() > 0)
                    {
                        newNotification = new Notification__c();
                        newNotification.Type__c = 'Initiated';
                        newNotification.Intrax_Program__c = MatchInfo.Engagement__r.Intrax_Program__c;
            newNotification.Intrax_Program_Options__c = MatchInfo.Engagement__r.Intrax_Program_Options__c;  
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = NotificationList[0].ID;
                        newNotification.Subject__c = 'An employer has requested an Interview with you!';
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' company would like to interview you for an Internship. Please select a date/time to schedule the meeting.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = MatchInfo.id;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'igi_pt_match_details?mId=' + MatchInfo.id;
                        newNotifications.add(newNotification);
                    }
                    else 
                    {
                        Notification__c ParentNotification = new Notification__c();
                        ParentNotification.Type__c = 'Parent';
                        ParentNotification.Subject__c = 'Pending actions for IGI Application';
                        ParentNotification.Body__c = 'Please take actions for Pending Items';
                        ParentNotification.Engagement__c = MatchInfo.Engagement__c;
                        insert ParentNotification;
                        parentId=ParentNotification.ID;
                        
                        
                        newNotification = new Notification__c();
                        newNotification.Type__c = 'Initiated';
                        newNotification.Intrax_Program__c = MatchInfo.Engagement__r.Intrax_Program__c;
                              newNotification.Intrax_Program_Options__c = MatchInfo.Engagement__r.Intrax_Program_Options__c;  
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = parentId;
                        newNotification.Subject__c = 'An employer has requested an Interview with you!'; 
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' company would like to interview you for an Internship. Please select a date/time to schedule the meeting.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = MatchInfo.Id;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'igi_pt_match_details?mId=' + MatchInfo.id;
                        newNotifications.add(newNotification);
                    }
        }
        if(newNotifications != NULL && newNotifications.size() > 0)
        {
            upsert newNotifications;
        }

    }
    
       
        
    }
    
    public static void CreateIGIOfferNotification(Set<id> AllMatchIds)
    {
        Id parentId = null;  
    Match__c MatchInfo = new Match__c();
    Notification__c newNotification = new Notification__c();
    list<Notification__c> newNotifications = new list<Notification__c>();

    if (AllMatchIds.size() > 0)
    {
        //set<Id> AllMatchIds =  MatchMapList.keyset();

        for(Id mid: AllMatchIds)
                {
            //MatchInfo = MatchMapList.get(mid);
            MatchInfo = [SELECT ID, Engagement__c, Engagement__r.Account_Id__c, Engagement__r.Intrax_Program__c, Engagement__r.Intrax_Program_Options__c, Position_Name__r.Host_Company_Id__r.Name  FROM Match__c WHERE id =: mid];
            List <Notification__c> NotificationList = [select Id,Engagement__c,Type__c from Notification__c where Engagement__c = :MatchInfo.Engagement__c AND Type__c = 'Parent'];
                    List<Account> PTAccount = [Select Id,PersonContactId  From Account where ID = :MatchInfo.Engagement__r.Account_Id__c];
                    if (NotificationList.size() > 0)
                    {
                        newNotification = new Notification__c();
                        newNotification.Type__c = 'Offer Extended';
                        newNotification.Intrax_Program__c = MatchInfo.Engagement__r.Intrax_Program__c;
                              newNotification.Intrax_Program_Options__c = MatchInfo.Engagement__r.Intrax_Program_Options__c;  
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = NotificationList[0].ID;
                        newNotification.Subject__c = 'Congratulations! A company has offered you an Internship!';
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' has offered you an Internship through Intrax Global Internships. Please review the position and respond to the offer.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = MatchInfo.id;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'igi_pt_match_details?mId=' + MatchInfo.id;
                        newNotifications.add(newNotification);
                    }
                    else 
                    {
                        Notification__c ParentNotification = new Notification__c();
                        ParentNotification.Type__c = 'Parent';
                        ParentNotification.Subject__c = 'Pending actions for IGI Application';
                        ParentNotification.Body__c = 'Please take actions for Pending Items';
                        ParentNotification.Engagement__c = MatchInfo.Engagement__c;
                        insert ParentNotification;
                        parentId=ParentNotification.ID;
                        
                        
                        newNotification = new Notification__c();
                        newNotification.Type__c = 'Offer Extended';
                        newNotification.Intrax_Program__c = MatchInfo.Engagement__r.Intrax_Program__c;
                              newNotification.Intrax_Program_Options__c = MatchInfo.Engagement__r.Intrax_Program_Options__c;  
                        newNotification.Status__c = 'Not Started';
                        newNotification.Parent_Notification__c = parentId;
                        newNotification.Subject__c = 'Congratulations! A company has offered you an Internship!'; 
                        newNotification.Body__c = MatchInfo.Position_Name__r.Host_Company_Id__r.Name + ' has offered you an Internship through Intrax Global Internships. Please review the position and respond to the offer.';
                        newNotification.Engagement__c = MatchInfo.Engagement__c;
                        newNotification.Match__c = MatchInfo.Id;
                        List<Applicant_Info__c> app = [SELECT Id, CreatedBy__c, Engagement__c FROM Applicant_Info__c WHERE Engagement__c =: MatchInfo.Engagement__c LIMIT 1];
                        if(app != null && app.size()>0)
                        { 
                        newNotification.OwnerId = app[0].createdBy__c;
                        }
                        newNotification.account__c = PTAccount[0].Id;
                        newNotification.contact__c = PTAccount[0].PersonContactId;
                        newNotification.Action_URL__c = 'igi_pt_match_details?mId=' + MatchInfo.id;
                        newNotifications.add(newNotification);
                    }
        }
        if(newNotifications != NULL && newNotifications.size() > 0)
        {
            upsert newNotifications;
        }

    }
    
       
        
    }
    public static void CreateIGISupervisorEvaluations(String Type, List<Match__c> matches){
    
        Set<Id> matchIds= new Set<Id>();
        for(Match__c m : matches){
            matchIds.add(m.Id); 
        }
          
        List<Match__c> matchList = [Select Id, Name, Position_Name__r.Position_Supervisor__c, Position_Name__r.Host_Company_Id__c, Position_Name__c, Engagement__r.Visa_Type__c, 
                                        Engagement__r.OwnerId, Engagement__r.Status__c, Engagement__c, Participant_Id__c, Status__c from Match__c where Id IN :matchIds];
                                        
        List<Assessment__c> assesslist = new List<Assessment__c>();
        List<Notification__c> Notilist = new List<Notification__c>();
        if(Type == 'MP' || Type == 'FP'){
            for(Match__c m : matchList){
                if(m.Engagement__r.Status__c == 'On Program' && m.Engagement__r.Visa_Type__c == 'J-1' && m.Status__c == 'Confirmed'){
                    if(m.Position_Name__r.Position_Supervisor__c != null){
                       //create new assessment
                       Assessment__c assess = new  Assessment__c();
                       assess.Completed_With__c = m.Position_Name__r.Position_Supervisor__c;
                       assess.Host_Name__c = m.Position_Name__r.Host_Company_Id__c;
                       assess.Name = (Type =='MP') ? 'Supervisor Mid Program' : 'Supervisor Final Program';
                       assess.Engagement__c = m.Engagement__c;
                       assess.Match_Name__c = m.Id;
                       assess.Participant_Name__c = m.Participant_Id__c;
                       assess.OwnerId = m.Engagement__r.OwnerId;
                       assess.Position_Name__c = m.Position_Name__c;
                       assess.RecordTypeId = (Type =='MP') ? Constants.ASS_IGI_HC_Mid_Program : Constants.ASS_IGI_HC_Final_Program;
                       assess.Status__c = 'Not Yet Started';
                       assessList.add(assess);
                    }
                }
            }
            if(assessList != null && assessList.size() > 0){
                insert assessList;
                // create new notification for each assessment
                for(Assessment__c a : assessList){
                    Notification__c Notify = new Notification__c ();
                    Notify.Account__c = a.Host_Name__c;
                    Notify.Assessment__c=a.Id;
                    Notify.Contact__c = a.Completed_With__c;
                    Notify.Action_URL__c = 'igi_supervisor_evaluation?Id=' +a.Id; 
                    Notify.Intrax_Program__c = 'Internship';
                    Notify.Match__c = a.Match_Name__c;
                    Notify.Status__c = 'Not Started';
                    Notify.Engagement__c = a.Engagement__c;
                    Notify.OwnerId = a.OwnerId;
                    if(Type == 'MP'){
                        Notify.Body__c = 'Our records indicate it is time to complete the mid program assessment for';
                        Notify.Subject__c = 'Complete Supervisor Mid Program Evaluation for';
                    }else{
                        Notify.Body__c = 'Our records indicate it is time to complete the final program assessment for';
                        Notify.Subject__c = 'Complete Supervisor Final Program Evaluation for';
                    }
                    Notify.Type__c =  (Type =='MP'? 'Host Mid Program':'Host Final Program');
                    Notilist.add(Notify);
                }
                if(Notilist != null && Notilist.size() > 0){
                    insert Notilist;
                }   
            }    
        }
    }
    }