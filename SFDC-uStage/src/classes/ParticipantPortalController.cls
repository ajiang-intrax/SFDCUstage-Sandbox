public with sharing class ParticipantPortalController 
{
  public list <applicant_info__c> applicantInfoList;
  
  public Set<ID> EnggIDs;
  
  public list<Match__c> selectedMatches {get;set;}
  
  public list<Match__c> selectedConfirmMatches {get;set;}
  
  public Match__c match {get; set;}
  
  public list<Trip__c> listTrips{get;set;}
  
  public Boolean showTravelForm {get; set;}
  
  public Applicant_Info__c EnggAppInfo{get;set;}
  
  public Trip__c trip {get; set;}
    public Trip__c newTrip {get;set;}
    
    public User activeUser {get;set;} 
    
    public Engagement__c enggVisaDetails{get;set;}
    
    public ID enggID{get;set;}
    
    public Boolean showTripAfterSave {get; set;}
    
    public Id tripIdForDelete {get; set;}
    
    public Engagement__c participant {get; set;}
    
    public list<Engagement__c> partSecondJob {get; set;}
    
    public Boolean showTripPage {get; set;}
    
    public Position__c positionInfo{get;set;}
    
    public list<Accommodation_Option__c> AccOptionInfoList{get;set;}
    
    public map<String, String> DocuSignEnvMap {get;set;}
    
    public String ShowTripInfoType {get; set;}
    
    public User user {get;set;}
    
    public ParticipantPortalController() 
    {
      positionInfo = new Position__c();
      showTripPage = false;
      ShowTripInfoType = '';
      participant = new Engagement__c();
      EnggAppInfo = new applicant_Info__c();
      partSecondJob = new list<Engagement__c>();
      
      newTrip = new Trip__c();
      
      match = new Match__c();
      
      DocuSignEnvMap = new map<String, String>();
      
      showTravelForm = false;
      showTripAfterSave = false;
      selectedMatches = new List<Match__c>(); 
      
      selectedConfirmMatches = new List<Match__c>(); 
      
        applicantInfoList = [Select ID, Engagement__c From Applicant_Info__c a
                    where a.CreatedBy__c =: UserInfo.getUserId() AND application_stage__c =: 'Accepted'
                    order by a.CreatedDate DESC];
        
        EnggIDs = new Set<ID>();
        
        if (applicantInfoList.size() == 0)
        {
          listTrips = new list<Trip__c>();
        }
        
        
        if (applicantInfoList != null && applicantInfoList.size() > 0)
        {
          list<Engagement__c> engVal = [SELECT ID, SEVIS_ID__c,Intrax_Program__c, Status__c FROM Engagement__c WHERE ID = :applicantInfoList[0].Engagement__c ];
          if(engVal.size() > 0){
            participant = engVal[0];            
            partSecondJob = [SELECT ID, SEVIS_ID__c FROM Engagement__c WHERE ID = :applicantInfoList[0].Engagement__c  AND Status__c =: 'On Program' AND Placement_Status__c =: 'Confirmed'];
            
            if (engVal[0].SEVIS_ID__c != NULL)
            {
              showTripPage = true;
              
              //IGI-880 (Start)
              if(engVal[0].Status__c == 'Program Ready')
              {
                list<Trip__c> allArrivalTrips = [Select ID, Name FROM Trip__c WHERE Engagement__c = :applicantInfoList[0].Engagement__c AND Arrival_to_Host_Community__c = :true];
                if(allArrivalTrips.size() == 0)
                {
                  ShowTripInfoType = 'Arrival';
                  newTrip.Arrival_to_Host_Community__c = true;
                }
              }
              else if(engVal[0].Status__c == 'On Program')
              {
                list<Trip__c> allDepartTrips = [Select ID, Name FROM Trip__c WHERE Engagement__c = :applicantInfoList[0].Engagement__c AND Departure_from_Host_Community__c = :true];
                if(allDepartTrips != null && allDepartTrips.size() == 0)
                {
                  ShowTripInfoType = 'Departure';
                  newTrip.Departure_from_Host_Community__c = true;
                }
              }
              //IGI-880 (End)              
            }
          }
          for (applicant_info__c ap : applicantInfoList)
          {
            EnggIDs.add(ap.Engagement__c);
          }
        }
         user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                   street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                    FROM User
                    WHERE id = :UserInfo.getUserId()];
        
        //List to hold the Users records
        List<User> users = [select Id, Intrax_Id__c, LocaleSidKey, FirstName, LastName, Contact.AccountId from User where Id = : userInfo.getUserId()]; 
        
        //Check for list size
        if(users.size() > 0 && users != null) {        
    
            //Getting current logged in user value
            activeUser = users[0];
        } 
        
        if(ApexPages.currentPage().getParameters().get('matchId') != null) {
            //Populating list with the match records
            selectedMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Consider_Other_Positions__c, Match_Date__c,Position_Name__r.Street__c,Position_Name__r.Street_2__c, Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c,Position_Name__r.School_Id__c,Position_Name__r.Owner.Phone, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Position_Name__r.Single_No_Children_Indicated__c, Position_Name__r.Engagement_Start__c, Position_Name__r.Pets_Description__c,
                                Participant_Opportunity_Id__r.Name,  Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c,
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c, Intrax_Program__c, 
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c FROM Match__c 
                                WHERE
                                Id =: ApexPages.currentPage().getParameters().get('matchId')];    
            if (EnggIDs.size() > 0)
          {                   
             listTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, 
                                Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__c,
                                Match__r.Engagement__r.Name, Match__r.Engagement__r.Id,Engagement__r.Name,Engagement__c,
                                Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c
                                ,Arrival_Date_Time__c,Departure_Date_Time__c
                                FROM Trip__c
                                WHERE Engagement__c IN : EnggIDs ];  
            }
          if(selectedMatches.size() > 0 && selectedMatches[0].Position_Name__c != null) {
                                
                try{
                
                positionInfo = [SELECT Id, Name, Host_Company_Id__c, Host_Company_Id__r.Description, Host_Company_Id__r.Name, Code__c, City__c, Gender_Preference__c, Minimum_Age__c, Engagement_Start__c, Engagement_End__c, State__c, Language_1_Proficiency__c,
                            Engagement_Earliest_End__c, Engagement_Latest_Start__c, Employment_Hrs_Wk__c, Typical_Schedule__c, Description__c, Required_Duties__c, Skills_Required__c, Supplies_Required__c, Supplies_Cost__c,
                            Host_Company_Id__r.Company_Policies__c, Accepts_Groups__c, Host_Company_Id__r.Area_Information__c, Host_Company_Id__r.Cultural_Opportunities__c, 
                            Requires_Interview__c, Special_Notes__c, Pay_Rate__c, Tipped_Position__c, Overtime_Available__c, Overtime_Rate__c, Pay_Notes__c, Pay_Frequency__c, Days_Before_Work__c, Second_Job_Allowed__c,
                            Accepts_Couples__c, Company_Provided_Housing__c, Host_Company_Id__r.Recommended_Airport__c, Host_Company_Id__r.Nearest_Bus_Station__c, Host_Company_Id__r.Nearest_Train_Station__c, Host_Company_Id__r.Transportation_To_Company__c,
                            Host_Company_Id__r.Reporting_Instructions__c, Host_Company_Id__r.Travel_Instructions__c, Host_Company_Id__r.Nearest_Work_Authorization_Office__c, Host_Company_Id__r.Work_Authorization_Instructions__c, 
                            Host_Company_Id__r.Website, Host_Company_Id__r.Websites_Additional__c, Title__c, Host_Company_Id__r.isPersonAccount
                            FROM Position__c 
                            WHERE Id =: selectedMatches[0].Position_Name__c ];
                    
               
                AccOptionInfoList = [SELECT Id, Name, Position_Name__c, Host_Arranged__c, Host_Recommended__c, Description__c, Accommodation_Site__c, Accommodation_Site__r.Street__c,
                                        Accommodation_Site__r.Street_2__c, Accommodation_Site__r.State__c, Accommodation_Site__r.City__c, Accommodation_Site__r.Country__c, Accommodation_Site__r.Postal_Code__c, Accommodation_Site__r.Type__c,
                                        Accommodation_Site__r.Features__c, Accommodation_Site__r.Additional_Information__c, Accommodation_Site__r.Features_Description__c, Accommodation_Site__r.Business_Name__c,
                                        Additional_Costs__c, Additional_Costs_Description__c, Account__c,
                                        Transportation_Provided__c, Estimated_Distance__c, Gender_Restriction__c, Estimated_Cost__c, Commute_Cost__c, Commute_Options__c
                                        From Accommodation_Option__c 
                                        where Account__c =: positionInfo.Host_Company_Id__c];
                                        
                 }
                 catch(Exception e){
                    system.debug('****** Impossible to retrieve positionInfo '+e);
                }
                
                
            }
                                         
        }
        
        else if (applicantInfoList != null && applicantInfoList.size() > 0)
        {
          if (EnggIDs.size() > 0)
          {
            selectedMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, Intrax_Program__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c, 
                                (Select Id, Name, dsfs__DocuSign_Envelope_ID__c From DocuSign_Status__r WHERE Signing_Document_Name__c='Work Travel Job Placement' 
                                AND dsfs__Envelope_Status__c='Completed')
                                FROM Match__c 
                                WHERE Engagement__c IN : EnggIDs order by Start_Date__c desc];
                                
              //D-02101                  
         if(participant.Intrax_Program__c == 'Work Travel')
            {
           system.debug('in WT');
           selectedConfirmMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c
                                FROM Match__c 
                                WHERE Engagement__c IN : EnggIDs AND Status__c = 'Confirmed' order by CreatedDate desc];
             }
                     //D-02101                   
            else                    
            {
             
                selectedConfirmMatches = [Select ID, Name, End_Date__c, Start_Date__c, Interview_Date__c, Interview_Status__c, CreatedDate, LastModifiedDate,
                                Participant_Id__r.Name, Portal_Contact_ID__r.Name, Position_Name__r.School_Id__c, Position_Name__r.Street__c,Position_Name__r.Street_2__c,  Position_Name__r.Country__c,
                                Position_Name__r.name, Position_Name__r.Arrival_Date_Time__c, Consider_Other_Positions__c, Match_Date__c, Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.OwnerId, Position_Name__r.Owner.Name, Position_Name__r.Owner.Phone,Position_Name__r.Single_No_Children_Indicated__c,
                                Position_Name__r.Smoker_in_Family__c, Position_Name__r.Pets__c, Position_Name__r.Pets_Description__c, Position_Name__r.Engagement_Start__c,
                                Engagement__r.Name, Engagement__r.Needs_Travel__c, Engagement__r.Number_of_Trips__c, Engagement__r.Intrax_Program__c,Engagement__r.Arrival_Trip_Needed__c,Engagement__r.Departure_Trip_Needed__c,
                                Participant_Opportunity_Id__r.Name, Status__c,SNK_Indicated__C, Double_Placement_Indicated__c, 
                                Placement_Type__c, Parent_Permission__c, Student_Permission__c, SNK_Permission__c, Engagement__r.Status__c, Offer_Status__c,
                                Match_Type__c,School_Address__c,School_Name__c,Owner_Email__c, Owner_Name__c,Owner_State__c,Owner_city__c,Owner_Phone__c
                                FROM Match__c 
                                WHERE Engagement__c IN : EnggIDs AND Status__c = 'Confirmed' order by Start_Date__c desc];
             }                  
               listTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, 
                                Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__c,
                                Match__r.Engagement__r.Name, Match__r.Engagement__r.Id,Engagement__r.Name,Engagement__c,
                                Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c
                                ,Arrival_Date_Time__c,Departure_Date_Time__c
                                FROM Trip__c
                                WHERE Engagement__c IN : EnggIDs ];
               //Checking for the Trip Id value corresponding to current page URL
        if(ApexPages.currentPage().getParameters().get('tripId') != null) {
            
            //List to hold the trip records
            List<Trip__c> selectedTrips = new List<Trip__c>();  
            
            //Populating list with selected trip record
            selectedTrips = [Select ID, Name, Arriving_City__c, Arriving_At__c, Arriving_Date__c, Carrier__c, Carrier_Number__c, Departing_Date__c, Match__r.Engagement__c,
                            Departing_From__c, Departing_City__c, Description__c, International_Leg__c, Record_Locator__c, Match__c, Match__r.Name, Match__r.Engagement__r.Name, 
                            Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c,Match__r.Start_Date__c,Match__r.End_Date__c
                            ,Arrival_Date_Time__c,Departure_Date_Time__c, Ground_Transporation_Type__c, Arrival_to_Host_Community_Date__c
                            FROM Trip__c
                            WHERE ID =: ApexPages.currentPage().getParameters().get('tripId')];
                            
            //Checking for null value
            if(selectedTrips != null && selectedTrips.size() > 0) {
            
                //Populate Instance with the record
                trip = selectedTrips[0];
            }
        }
               
          }
        }
        
        
        if (selectedMatches != null && selectedMatches.size() > 0)
        {
          //IGI - 841, 842, 843 (Start)
          for(Match__c EnvMatch : selectedMatches)
          {
               if(EnvMatch.DocuSign_Status__r != null && EnvMatch.DocuSign_Status__r.size() > 0 )
               {
                 DocuSignEnvMap.put(EnvMatch.id, EnvMatch.DocuSign_Status__r[0].dsfs__DocuSign_Envelope_ID__c);
               }
               else
               {
                 DocuSignEnvMap.put(EnvMatch.id, 'no-Envelope');
               }
          }
          //IGI - 841, 842, 843 (End)
          
          
          if(ApexPages.currentPage().getParameters().get('matchId') != null)
          {
            match  = selectedMatches[0];
          }
          else
          {
            if (selectedConfirmMatches != null && selectedConfirmMatches.size() > 0)
            {
              match  = selectedConfirmMatches[0];
            }
            else
            {
              match  = selectedMatches[0];
            }
            
          }
        }
         if(ApexPages.currentPage().getParameters().get('EnggID') != NULL)
        {
            EnggID = ApexPages.currentPage().getParameters().get('EnggID');
            enggVisaDetails = [SELECT Name, Visa_Interview_Date__c, Visa_Interview_Status__c FROM Engagement__c WHERE ID = :EnggID]; 
            
            list <applicant_info__c> applicantInfolst = [Select Country_of_Interest__c, Application_Level__c , Engagement__c , Application_Stage__c, account__r.FirstName, account__r.IsPersonAccount,account__r.LastName, account__r.Intrax_Id__c, Opportunity_Name__r.Payment_Received__c, Service_level__c 
                                                            From Applicant_Info__c a 
                                                            where a.Engagement__c = :EnggID 
                                                            AND Application_Stage__c != 'Cancelled' ORDER BY CreatedDate DESC]; 
            if (applicantInfolst.size() > 0)
            {
                EnggAppInfo = applicantInfolst[0];
            }
            
        }
    }
    
    public PageReference checkLogin(){
        //AA 27022014 Ayusa II (AY2)#626To resolve Empty Text Area Rendering issue which insert garbage Html code. 
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8; IE=9; IE=10');
        
        //Variable to hold the Pagereference                
        PageReference pageRef;
        system.debug('Looged in User Type '+userInfo.getUserType());
            
        //Checking for Site User
        if(userInfo.getUserType() == 'Guest') {
            
            //Redirect to login Page
            pageRef = Page.AppEngine_SiteLoginPage;
            pageRef.setRedirect(true);
            
        } else if(userInfo.getUserType() == 'Standard' || userInfo.getUserType() == 'PowerPartner') {
            
            system.debug('');
            return pageRef;
        }
           
        //Return pagereference
        return pageRef;
    }
    
    
    
    public pageReference addTravelInfo (){
        pageReference p = new pageReference ('/apex/Participant_Travel_Visa_New?participantId=' + participant.Id);
        //pageReference p = new pageReference ('/apex/pr_pt_travel_visa_new');
        p.setRedirect(true);
        return p;
    }
    
    
    public PageReference saveInfoOfTrip() {
        
        showTripAfterSave = true;
        showTravelForm = false;
        system.debug('Engagement ID Is **** ' + participant.Id);
        newTrip.Engagement__c = participant.Id;
        newTrip.Match__c = match.Id;
      try{
            insert newTrip;
        }catch(Exception e){
            system.debug('******** ' + e);
        }
        
        //PageReference p = new PageReference('/apex/Participant_PT_Travel_Visa?participantId=' + participant.Id);
        PageReference p = new PageReference('/apex/Participant_Travel_Visa');
        p.setRedirect(true);
        return p;            
    }
    
    public Pagereference updateIndividualTrip() {
        
        if(trip != null){
            System.debug('@@@@@ value in trip ' + trip);
            update trip;
        }   
        return backToTrips();
              
    }
    
    public Pagereference backToTrips() {
        
        showTripAfterSave = true;
        //PageReference travelPageReference = new PageReference('/apex/Participant_PT_Travel_Visa?participantId=' + participant.Id);
        PageReference travelPageReference = new PageReference('/apex/Participant_Travel_Visa');
        travelPageReference.setRedirect(true);
        return travelPageReference;
    }
    
    public Pagereference backToPartcipant() {
        
        PageReference participantPageReference = Page.pr_pt_list;
        participantPageReference.setRedirect(false);
        return participantPageReference;
    }
    
    public Pagereference backToMatches() {
        
        PageReference matchPageReference = Page.Matches;
        matchPageReference.setRedirect(false);
        return matchPageReference;
    }
    
    //public void deleteTrip() {    
        
    public PageReference deleteTrip() { 
        if(tripIdForDelete != null) {
                 
            Map<Id, Trip__c> mapTrip = new Map<Id, Trip__c>(listTrips);
            
            Database.delete(Id.valueOf(tripIdForDelete), true);
            
            mapTrip.remove(Id.valueOf(tripIdForDelete));
            
            listTrips = mapTrip.values();   
        }
        
        PageReference travelmainpage = new PageReference('/apex/Participant_Travel_Visa');
        travelmainpage.setRedirect(true);
        return travelmainpage;
    }
    
      public PageReference SaveVisaDate()
      {
        //PageReference P = Page.igi_pt_visa_interview_dt;
        PageReference P = Page.Home;
        if (ApexPages.currentPage().getParameters().get('ActionType') != NULL && ApexPages.currentPage().getParameters().get('ActionType') == 'SaveInterviewDate')
        {
           /*String dVisa=enggVisaDetails.Visa_Interview_Date__c.format();
            enggVisaDetails.Visa_Interview_Date__c=Date.parse(dVisa);
            system.debug('visa**'+dvisa+'date***'+enggVisaDetails.Visa_Interview_Date__c);*/
            upsert enggVisaDetails;
            list<Notification__c> ListNotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: EnggId AND Type__c = 'Visa Interview' AND Status__c = 'Not Started'];
            if(ListNotInfo.size() > 0)
            {
                for(Notification__c NotInfo:ListNotInfo)
                {
                    NotInfo.Status__c = 'Confirmed';
                }
                update ListNotInfo;
            }
            
            
            if (enggVisaDetails.Visa_Interview_Date__c <= date.today())
            {
                P = Page.wt_pt_visa_interview_status;
                P.getParameters().put('EnggId', EnggId);
            }
        }
        else if (ApexPages.currentPage().getParameters().get('ActionType') != NULL && ApexPages.currentPage().getParameters().get('ActionType') == 'SaveInterviewStatus')
        {
            if(enggVisaDetails.Visa_Interview_Status__c == 'Declined � Appealing Decision')
            {
                enggVisaDetails.Visa_Interview_Date__c = NULL;
            }
            upsert enggVisaDetails;
            list<Notification__c> ListNotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: EnggId AND Type__c = 'Visa Result' AND Status__c = 'Not Started'];
            if(ListNotInfo.size() > 0)
            {
                for(Notification__c NotInfo:ListNotInfo)
                {
                    NotInfo.Status__c = 'Confirmed';
                }
                update ListNotInfo;
            }
            if(enggVisaDetails.Visa_Interview_Status__c == 'Declined � Appealing Decision')
            {
                set<id> eid = new set<id>();
                eid.add(EnggId);
                Notification_Generator.sendWTOrientation(eid);
            }
            
        }
        p.setRedirect(true);
        return p;     
      }
    
    
    /*public class EngagementMatchWrapper {
        
        public Engagement__c engagementRecord {get; set;}
        public Match__c matchRecord {get; set;}
        
        public EngagementMatchWrapper(Engagement__c engagementRecord, Match__c matchRecord) {
            
            this.engagementRecord = engagementRecord;
            this.matchRecord = matchRecord;
        }
    }*/
        
    
}