public without sharing class Positions_Controller {
  
  public Applicant_Info__c applicantInfo{get;set;}
  public list<Campaign_Position__c> positionlist{get;set;}
  public Position__c positionInfo{get;set;}
  public Match__c matchInfo{get;set;}
  public Account partnerInfo{get;set;}
  // Variable to cusotmize error messages on the VFPs
    public boolean customMessage {get;set;}

  public Positions_Controller(ApexPages.StandardController controller){
    //applicantInfo = (Applicant_Info__c) controller.getRecd();
    system.debug('****** pid: ' +ApexPages.currentPage().getParameters().get('pid'));
    if(ApexPages.currentPage().getParameters().get('pid') != null){
      // DETAIL PAGE
      if(ApexPages.currentPage().getParameters().get('id') != null){
        try{
          applicantInfo = [SELECT Id, Name, Partner_Intrax_Id__c, Account__c, Engagement__c FROM Applicant_Info__c WHERE id =: ApexPages.currentPage().getParameters().get('id')];
        
          partnerInfo = [SELECT Id, Name, Intrax_Id__c, Phone, Email_Business__c, Website, Fax FROM Account WHERE Intrax_Id__c =: applicantInfo.Partner_Intrax_Id__c ];
        }catch(Exception e){
          system.debug('******* Impossible to retrieve records: ' + e);
        }
      }
      
      if(ApexPages.CurrentPage().getParameters().get('mid') != null){
        try{
          matchInfo = [SELECT Id, Consider_Other_Positions__c FROM Match__c WHERE Id =: ApexPages.CurrentPage().getParameters().get('mid')];
        }catch(Exception e){
          system.debug('******* Impossible to retrieve records: ' + e);
        }      
      }
      
      positionInfo = [SELECT p.sAccount__c, Host_Company_Id__r.Name,p.Functional_Areas__c, p.Accepts_Couples__c, p.Accepts_Groups__c, p.Requires_Interview__c, Interview_Type__c, p.Typical_Schedule__c, p.Type__c, p.Tuition__c, p.Title__c, p.Tipped_Position__c, p.Terminated_Count__c, p.Supplies_Required__c, p.Supplies_Cost__c, p.Supervisor_Role__c, p.Street__c, p.Street_2__c, p.Status__c, p.State__c, p.Special_Notes__c, p.Smoker_in_Family__c, p.Skills_Required__c, p.Single_No_Children_Indicated__c, p.Session__c, 
                p.Second_Job_Allowed__c, p.Season__c, p.School_Model__c, p.School_Category__c, p.Required_Duties__c, p.Religious_Restriction_Indicated__c, p.Regional_Location__c, p.RecordTypeId, p.Projects_of_Interest__c, p.Program_Year__c, p.Postal_Code__c, p.Positions_Sold__c, p.Position_Types__c, p.Position_Types_Other__c, p.Position_Supervisor__c, p.Position_Count__c, p.Pets__c, p.Pets_Description__c, 
                p.Personality_Independence__c, p.Pending_Count__c, p.Pay_Rate__c, p.Pay_Notes__c, p.Pay_Frequency__c, p.OwnerId, p.Overtime_Rate__c, p.Overtime_Available__c, 
                p.Occupational_Category__c, p.Nationality_Preferences__c, p.Name, p.Minimum_Position_Duration__c, p.Minimum_Age__c, p.Maximum_Hours__c, p.Maximum_Age__c, p.Matching_Notes__c, p.Matched_Count__c, p.Marketing_Notes__c,
                p.Languages_Required__c, p.Language_Level__c, p.Language_3__c, p.Language_3_Proficiency__c, p.Language_2__c, p.Language_2_Proficiency__c, p.Language_1__c, p.Language_1_Proficiency__c, p.IsDeleted, p.Intrax_Program__c, p.Intrax_Program_Options__c, p.Interview_Date__c, p.Interests__c, p.Id, p.Host_Opportunity_Id__c, 
                p.Host_Company_Id__c, p.Gender_Preference__c,  p.Functional_Areas_Secondary__c, p.Functional_Areas_Other__c, p.Flexible_Dates__c, p.Engagement_Start__c, p.Engagement_Latest_Start__c, p.Engagement_End__c, p.Engagement_Earliest_End__c, p.Employment_Hrs_Wk__c, p.Double_Placement_Indicated__c, p.Description__c, p.Departure_Date_Time__c, 
                p.Days_Before_Work__c, p.Country__c, p.Countries_of_Interest__c, p.Countries_Excluded__c, p.Coordinator__c, p.Compensation_Type__c, p.Company_Provided_Housing__c, p.Code__c, p.City__c, p.Arrival_Departure_Phone__c, p.Arrival_Departure_Contact__c, p.Arrival_Date_Time__c 
                FROM Position__c p
                WHERE p.Id =: ApexPages.currentPage().getParameters().get('pid')];
   
    } else if(ApexPages.currentPage().getParameters().get('id') != null){
    
      applicantInfo = [SELECT Id, Name, Partner_Intrax_Id__c, Account__c FROM Applicant_Info__c WHERE id =: ApexPages.currentPage().getParameters().get('id')];
      system.debug('****** applicantInfo: ' + applicantInfo.Id);
      try{
        Account a = [SELECT Id FROM Account WHERE Intrax_Id__c =: applicantInfo.Partner_Intrax_Id__c];
        system.debug('****** account: ' + a.Id);
        String aId = String.valueOf(a.Id).subString(0,15);
        system.debug('***** aId: ' + aId);
        // Now we need find all of the Campaign_Position__c instance where the Partner IDs match the Applicant_Info_c Partner ID
        positionlist = [SELECT c.Position__r.Code__c, c.Position__r.Title__c, c.Position__r.Engagement_Start__c, c.Position__r.Engagement_End__c, c.SystemModstamp, c.Positions_Sold__c, c.Position__c, c.Position__r.Name, c.Position__r.Engagement_Latest_Start__c, c.Position__r.Engagement_Earliest_End__c, c.Partner_Name__c, c.Partner_Id__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Intrax_Program__c, c.Id, c.Expiration_Date__c, c.Engagement_Start__c, c.CurrencyIsoCode, c.CreatedDate, c.CreatedById, c.ConnectionSentId, c.ConnectionReceivedId, c.Company_Name__c, c.Campaign__c, c.Campaign_Name__c, c.Allocated_Quantity__c 
                  FROM Campaign_Position__c c
                  WHERE c.Partner_Id__c =: aId
                  AND c.Engagement_Start__c > :date.today() 
                  AND c.Expiration_Date__c > :date.today()
                  ];
        //for(Campaign_Position__c cp : camp_positionlist){
          
        //}
        
      }catch(Exception e){
        system.debug('***** Impossible to retrieve any data: ' + e);
      }          
    }else{
      system.debug('***** Impossible to retrieve applicantInfo.Id');
    }
  }
  
  public PageReference updateMatchInfo(){
    try{
      update matchInfo;
    }catch(Exception e){
      system.debug('***** Impossible to update matchInfo: ' + e);
    }
    
    PageReference p = new PageReference('/apex/Positions');
    p.getParameters().put('id', applicantInfo.Id);
    //p.getParameters().put('mid', matchInfo.Id);
    //p.getParameters().put('pid', positionInfo.Id);
    p.setRedirect(true);
    return p;
  }
  
  public pageReference signUpForPosition(){
    system.debug('********** Position Id: ' + positionInfo.Id );
    Match__c m = new Match__c();
    
    if(positionInfo.Id != null){
      // If we find a already created Match for the same company, display a warning message
      // Creating the match...
      // we need a list of Companies the user has already applied for....
      set<String> appliedCompanies = new set<String>();
      
      list<Match__c> appliedMatches = [SELECT Position_Name__c, Position_Name__r.Host_Company_Id__r.Name, Participant_Id__c FROM Match__c WHERE Participant_Id__c =: applicantInfo.Account__c AND Status__c = 'Applied'];
      if(appliedMatches.size() > 0){
        // We have already applied for one or more company positions
        for(Match__c m1 : appliedMatches){
          appliedCompanies.add(m1.Position_Name__r.Host_Company_Id__r.Name);
          system.debug('****** Company Name: ' + m1.Position_Name__r.Host_Company_Id__r.Name);
        }
      }
      
      list<Match__c> mcheck = [SELECT Id, Participant_Id__c, Position_Name__r.Host_Company_Id__r.Name 
                  FROM Match__c WHERE Position_Name__r.Host_Company_Id__r.Name IN: appliedCompanies 
                  AND Position_Name__r.Host_Company_Id__r.Name =: positionInfo.Host_Company_Id__r.Name
                  AND Status__c = 'Applied' ];
      if(mcheck.size() > 0){
        system.debug('***** We can´t register for 2 positions that belong to the same company');
        
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have already applied for a position at '+ positionInfo.Host_Company_Id__r.Name);
              ApexPages.addMessage(msg);
              return null;
      }else{
        system.debug('***** All Correct, let´s create a new Match');
        m.Status__c = 'Applied';
        m.Name = positionInfo.Name + ' - ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        m.Engagement__c = applicantInfo.Engagement__c;
        m.Position_Name__c = positionInfo.Id;
        m.Participant_Id__c = applicantInfo.Account__c;
        m.RecordTypeId = Constants.MAT_INTERNSHIP;
        insert m;
      }
    }
    PageReference p = new PageReference('/apex/Position_Selected_Thank_You');
    p.getParameters().put('id', applicantInfo.Id);
    p.getParameters().put('pid', positionInfo.Id);
    p.getParameters().put('mId', m.Id);
    p.setRedirect(true);
      return p;
    }
  
  public pageReference checkLogin(){
        system.debug('****** Usertype' + userInfo.getUserType());
        if(userInfo.getUserType() == 'Guest'){
            pageReference p = Page.AppEngine_SiteLoginPage;
            p.setRedirect(true);
            return p;
        }else return null;
        
    }

}