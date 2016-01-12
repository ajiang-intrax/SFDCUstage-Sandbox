/*
    Purpose         :   Helper class for Sharing calls from Triggers.
                
    Created Date    :   10/18/2013
    
    Current Version :   v1.0
   
*/
public without sharing class SharingSecurityHelper {
  /*
    * Description   :   This method shares position, account and applicant when match is updated for validator and confirmed status values
    * @args         :   Id of matches
    * @return       :   void*/
      
  /*
    * Description   :   This method shares position, account and applicant when match is updated for validator and confirmed status values
    * @args         :   Id of matches
    * @return       :   void*/
      
@future
 public static void shareMatch(Set<Id> confMatchids, Set<Id> validatorMatchIds, Set<Id> NewMatchIds) {
    List<Match__c> lstmatches =new List<Match__c>();
    List<Match__c> newMatches =  new List<Match__c>();
     List<Match__c> validateMatches =  new List<Match__c>();
      List<Match__c> confMatches =  new List<Match__c>();
    
    if(NewMatchIds!=null && NewMatchIds.size()>0)
    {
    newmatches =[Select Id,Position_Name__r.Id,RecordTypeId,Campaign__c,Intrax_Program__c,Status__c,Position_Name__r.RecordTypeId,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c,Position_Name__r.Host_Company_Id__c, Interview_Date__c from Match__c 
                               where ID IN:NewMatchIds];
    Set<Id> HCPositionIds = new set<Id>();
    Set<Id> HCMatchEngIds = new set<Id>();
    Map<Id,List<User>> MapCampPartnerUser = new Map<Id,List<User>>();   
    For(Match__c matInfo : newmatches)
    {
    
            If(matInfo.RecordTypeId == Constants.MAT_INTERNSHIP && (matInfo.Position_Name__r.RecordTypeId == Constants.POS_WORK_TRAVEL || matInfo.Position_Name__r.RecordTypeId == Constants.POS_ICD_INTERN_PT))
                {
                HCMatchEngIds.add(matInfo.engagement__c);   
                HCPositionIds.add(matInfo.Position_Name__r.Id);
                }       
                          
                    List<Applicant_Info__c> appInfo;
                    //Pick all applications related to match Engagement                     
                    appInfo = [Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c,a.CreatedById, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                    where a.engagement__c = :matInfo.engagement__c ];
                  
                     if(appInfo!=null && appInfo.size()>0)
                     {
                        //For each application C
                        for(Applicant_Info__c aInfo : appInfo)
                        {                               
                            //Share the Position with the applicant
                            Sharing_Security_Controller.sharePositionRecord(matInfo.Position_Name__c,aInfo.CreatedBy__c);
                            Sharing_Security_Controller.shareAccount(matInfo.Position_Name__r.Host_Company_Id__c, aInfo.CreatedBy__c);
                         }
                     }
                         //Get the Partner associated to the match's engagement
                 if(matInfo.engagement__r.Partner_id__c!=null)
                 {
                  List<User> lstUsr=[Select  u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.Account__c, u.AccountId, u.AboutMe From User u where u.Intrax_Id__c =:matInfo.engagement__r.Partner_id__c];
                   system.debug('******lstUsr********'+lstUsr);
                    If(lstUsr!=null)
                    {                   
                    //Share position with the partner
                         system.debug('******Position_Name__r********'+matInfo.Position_Name__r.Id);
                         system.debug('******Position_Name__r********'+matInfo.Position_Name__c);
                      if(matInfo.RecordTypeId == Constants.MAT_INTERNSHIP)
                      {
                       Sharing_Security_Controller.sharePositionRecord(matInfo.Position_Name__r.Id,lstUsr);
                       if(matInfo.Intrax_Program__c == 'Work Travel' && matInfo.Campaign__c !=null)
                        MapCampPartnerUser.put(matInfo.Campaign__c,lstUsr);
                      }
                      else if(matInfo.RecordTypeId == Constants.MAT_AYUSA && matInfo.Status__c=='Confirmed')
                      {
                       appInfo = [Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c,a.CreatedById, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                    where a.Position__c = :matInfo.Position_Name__c];
                       Sharing_Security_Controller.sharePositionRecord(matInfo.Position_Name__r.Id,lstUsr);
                       Sharing_Security_Controller.shareApplicantRecord(appInfo[0].Id, lstUsr);
                      }
                      else
                       Sharing_Security_Controller.shareROPositionRecord(matInfo.Position_Name__r.Id,lstUsr);
                    }
                 }                         
               
    }
    if(MapCampPartnerUser!=null)
    Sharing_Security_Controller.shareCampPartnerUsers(MapCampPartnerUser);
    
    If(HCPositionIds!=null && HCMatchEngIds!=null)
    {
           List<Position__c> lstHCPositions=new List<Position__c>();
           List<Contact> lstHCContacts=new List<Contact>();
           Set<Id> HCAccountIds =  new set<Id>();
           Set<Id> ParentAccountIds =  new set<Id>();            
           Set<Id> HCContactIds =  new set<Id>();
           Set<Id> HCMatchEngAccIds =  new set<Id>();
           Set<Id> HCMatchesId =  new set<Id>();
           List<User> lstUser=new List<User>();
           List<Account> lstAccounts=new List<Account>();
           List<Account> lstChildrenAccounts=new List<Account>();
           List<Engagement__c> lstEngagements=new List<Engagement__c>();
           List<Match__c> lstHCMatches=new list<Match__c>();
           // List<Match__c> lstHCMatches=new list<Match__c>();
           set<Id> ChildrenAccountIds=new set<Id>();
           lstEngagements = [Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id in : HCMatchEngIds];
           if(lstEngagements!=null && lstEngagements.size()>0)
           {
            For(Engagement__c eng : lstEngagements)
            HCMatchEngAccIds.add(eng.Account_Id__c);
           }     
           
           lstHCPositions = [Select p.RecordTypeId, p.Name, p.Intrax_Program__c, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.City__c From Position__c p
                                where p.id in : HCPositionIds];
           if(lstHCPositions!=null && lstHCPositions.size()>0)
           {
            For(Position__c pos:lstHCPositions)
            HCAccountIds.add(pos.Host_Company_Id__c);          
          
           if(HCAccountIds!=null)
           {
            lstAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.Id in :HCAccountIds];
          
           if(lstAccounts!=null && lstAccounts.size()>0)
           {
            For (Account a: lstAccounts)
            {
                if(a.ParentId == Null)
                ParentAccountIds.add(a.Id);
                if(a.ParentId != Null)
                HCAccountIds.add(a.ParentId);
            }         
          
           lstHCContacts = [Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId in :HCAccountIds];
           if(lstHCContacts!=null && lstHCContacts.size()>0)
           {
           For(Contact con: lstHCContacts)  
           HCContactIds.add(con.Id);           
           If(HCContactIds!=null)
            lstUser = [Select u.Type__c,u.UserRole.DeveloperName, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.ContactId in :HCContactIds];
           if(lstUser!=null && lstUser.size()>0)
           {           
          lstChildrenAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.ParentId in :ParentAccountIds];
         
          If(lstChildrenAccounts!=null && lstChildrenAccounts.size()>0)
          {
          For(Account cacc: lstChildrenAccounts)
          {
            ChildrenAccountIds.add(cacc.Id);
            HCAccountIds.add(cacc.Id);
          }
          If(ChildrenAccountIds!=null)
          {
          lstHCPositions = [Select p.RecordTypeId, p.Name, p.Intrax_Program__c, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.City__c From Position__c p
                                where p.Host_Company_Id__c in : ChildrenAccountIds];
          For(Position__c p:lstHCPositions)
          HCPositionIds.add(p.Id);                      
          
          If(HCPositionIds!=null)
          lstHCMatches = [Select Id,Position_Name__r.Id, Position_Name__c,Status__c,Position_Name__r.RecordTypeId,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c,Position_Name__r.Host_Company_Id__c, Interview_Date__c from Match__c 
                               where Position_Name__c IN:HCPositionIds];
          
          If(lstHCMatches!=null && lstHCMatches.size()>0)
          {
          For(Match__c m:lstHCMatches)  
          HCMatchesId.add(m.Engagement__c);
          
          If(HCMatchesId!=null)
          {
           lstEngagements = [Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id in : HCMatchesId];
           if(lstEngagements!=null && lstEngagements.size()>0)
           {
            for(Engagement__c eng:lstEngagements)
            {
            HCMatchEngIds.add(eng.Id);
            HCAccountIds.add(eng.Account_Id__c);
            }         
           
           }                     
          }
          }
          }
           Sharing_Security_Controller.shareHCPosHCUsers(HCPositionIds,lstUser);
           Sharing_Security_Controller.shareHCAccHCUsers(HCAccountIds,lstUser);
          } 
            Sharing_Security_Controller.shareHCEngHCUsers(HCMatchEngIds,lstUser);
            Sharing_Security_Controller.shareHCAccHCUsers(HCMatchEngAccIds,lstUser);
           } 
           }
           }
           }
           }

    }
    }
       

      if (confMatchids!=null)
      {
    confMatches = [Select Id, Status__c,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c, Position_Name__r.Host_Company_Id__c,Interview_Date__c from Match__c 
                               where ID IN:confMatchids];
                      
                    
   for (Match__c matInfo:confMatches)
    {
       List<User> lstUsr = new List<User>();
         system.debug('*****matInfo - 0*******'+matInfo);                             
        if(matInfo.engagement__r.Partner_id__c!=null)
                 {
                 lstUsr=[Select u.Name, u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.Account__c, u.AccountId, u.AboutMe From User u where u.Intrax_Id__c =:matInfo.engagement__r.Partner_id__c];
                   system.debug('******lstUsr********'+lstUsr);
                    If(lstUsr!=null)
                    {
                        //Share position with the partner
                         system.debug('******Position_Name__r********'+matInfo.Position_Name__r.Id);
                            system.debug('******Position_Name__r********'+matInfo.Position_Name__c);
                        Sharing_Security_Controller.sharePositionRecord(matInfo.Position_Name__r.Id,lstUsr);
                    }
                 }
       
         if(matInfo.Position_Name__r.Host_Opportunity_Id__c!=null)
         {
         List<Applicant_Info__c> lstMatchPosAppInfo =[Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                        where a.Opportunity_Name__c = :matInfo.Position_Name__r.Host_Opportunity_Id__c ];
              if(lstMatchPosAppInfo!=null && lstMatchPosAppInfo.size()>0)
              {
                    //For each application related to a position
                      system.debug('*****lstMatchPosAppInfo*******'+lstMatchPosAppInfo);    
                    for(Applicant_Info__c appInfo :lstMatchPosAppInfo )
                    {
                         //Pick all Partners associated to an Engagement
                           system.debug('*****appInfo*******'+appInfo);    
                        if(matInfo.Engagement__r.Partner_Id__c!=NULL)
                        {
                             system.debug('*****matInfo.Engagement__r.Partner_Id__c*******'+matInfo.Engagement__r.Partner_Id__c); 
                           If(lstUsr!=null)
                            {
                              system.debug('*****lstUsr*******'+lstUsr);            
                                //Share the applications with the partner
                                Sharing_Security_Controller.shareROApplicantRecord(appInfo.Id,lstUsr);                                
                            }
                        }
                    }
               } 
    }     }                      
    }
     if (validatorMatchIds!=null)
     {
    validateMatches = [Select Id,Campaign__c,RecordTypeId,Intrax_Program__c, Status__c,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c,Position_Name__r.Host_Company_Id__c, Interview_Date__c from Match__c 
                               where ID IN:validatorMatchIds];
       Map<Id,List<User>> MapMatchCampaignIds = new Map<Id,List<User>>();     
       for(Match__c matInfo:validateMatches) 
       {                     
             if(matInfo.Validator__c != null)
             {
                 system.debug('*****matInfo - 1*******'+matInfo);   
                List<Account> accountInfo = [SELECT Id, Name, Intrax_Id__c, Type, isPersonAccount, LastName FROM Account WHERE Id =: matInfo.Position_Name__r.Host_Company_Id__c];
                List<User> usr=[Select u.Name, u.Id, u.ContactId, u.City, u.Alias, u.AccountId From User u where u.contactId=:matInfo.Validator__c];
                if(usr!=null && usr.size()>0)
                {
                    for(User user : usr)
                    {
                         system.debug('*****matInfo - 1-user*******'+user);   
                        Sharing_Security_Controller.sharePositionRecord(matInfo.Position_Name__c,user.Id);
                        Sharing_Security_Controller.shareEngRecord(matInfo.Engagement__c,user.Id);
                        if(accountInfo !=null && accountInfo.size()>0)
                        For(Account acc : accountInfo)
                            Sharing_Security_Controller.shareMatchAccountRecord(acc.Id,user.Id);
                    }
                }
              }
              if(matInfo.Campaign__c !=null && matInfo.RecordTypeId == Constants.MAT_INTERNSHIP &&  matInfo.Intrax_Program__c =='Work Travel' && matInfo.Engagement__r.Partner_id__c!=null)
              {
                List<User> lstPartnerUser =  new List<User>();
                lstPartnerUser=[Select u.Name, u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.Account__c, u.AccountId, u.AboutMe From User u where u.Intrax_Id__c =:matInfo.engagement__r.Partner_id__c];
                   system.debug('******lstPartnerUser********'+lstPartnerUser);
                    If(lstPartnerUser!=null)
                    {
                       MapMatchCampaignIds.put(matInfo.Campaign__c,lstPartnerUser);
                    }
                
              }
            
       }
       if(MapMatchCampaignIds!=null)
       {
       Sharing_Security_Controller.shareCampPartnerUsers(MapMatchCampaignIds);
       }
     }
 }
  /**
    * Description   :   This method shares position, account and applicant when match is updated for validator and confirmed status values
    * @args         :   Id of matches
    * @return       :   void
    //  */  
 
 public static void shareApplicant(Set<Id> Appids) {
    List<Applicant_Info__c> lstApplicants =new List<Applicant_Info__c>();
        
    if(Appids!=null)
    {
    lstApplicants =[Select a.OwnerId, a.Lives_With__c,a.Partner_Intrax_Id__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Language_2__c, a.Id, a.Home_Street_1__c, a.Home_State__c, a.Email__c, a.CreatedBy__c, a.CreatedById, a.Country_of_Birth__c, a.Country__c, a.Arrival_Time__c, a.Application_Level__c, a.Academic_Years_Completed__c From Applicant_Info__c a where a.ID IN:Appids];
    If(lstApplicants!=null && lstApplicants.size()>0)
   {
    Sharing_Security_Controller.shareRecord(lstApplicants);
    Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.Name ='Guest Users'];  
    Sharing_Security_Controller.shareRecordGuestUsers(lstApplicants, grp.Id);
    For(Applicant_Info__c ap : lstApplicants)
    {
      
       String app_Partner_Id = ap.Partner_Intrax_Id__c;
              system.debug('**app_Partner_Id******'+app_Partner_Id);
              if(app_Partner_Id!=null && app_Partner_Id!='')
              {
              try{
            
              List<User> lstUser=[Select u.UserRole.PortalRole, u.UserRole.PortalType, u.UserRole.DeveloperName, 
                      u.UserRole.RollupDescription, u.UserRole.ParentRoleId, u.UserRole.Name, 
                      u.UserRole.Id, u.UserRoleId, u.ProfileId, u.PortalRole, u.ManagerId, u.IsPortalSelfRegistered,
                       u.IsPortalEnabled, u.IsActive, u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.FirstName,
                        u.CreatedById, u.Account__c, u.AccountId  From User u where u.Intrax_Id__c =:app_Partner_Id limit 1];
                     
                      If(lstUser.size() > 0 && lstUser!=null)
                      {
                            for(User usr :lstUser)
                            {
                                system.debug('***usr***'+usr);
                                
                                 Sharing_Security_Controller.sharePartnerApplicant(ap.Id,usr.Id);
                                 system.debug('***usr.UserRole.ParentRoleId***'+usr.UserRole.ParentRoleId);
                                 system.debug('***usr.UserRole.ParentRoleId ap.Id***'+ap.Id);
                                 Sharing_Security_Controller.sharePartnerRoleUp(ap.Id,usr.UserRole.ParentRoleId);
                       
                            }               
                      }
                }
              
              catch(Exception e){           
                               
                  system.debug(e);
              
              }
              }
    }
   }
    }
                                         
                  
 }
  /**
    * Description   :   This method shares position, account and applicant when match is updated for validator and confirmed status values
    * @args         :   Id of matches
    * @return       :   void
    //  */  
  @future
 public static void sharePTAccount (Set<Id> Appids) {
    List<Applicant_Info__c> lstApplicants =new List<Applicant_Info__c>();
    
    
    if(Appids!=null)
    {
    lstApplicants =[Select a.account__c,a.account__r.Id,a.OwnerId, a.Lives_With__c,a.Partner_Intrax_Id__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Language_2__c, a.Id, a.Home_Street_1__c, a.Home_State__c, a.Email__c, a.CreatedBy__c, a.CreatedById, a.Country_of_Birth__c, a.Country__c, a.Arrival_Time__c, a.Application_Level__c, a.Academic_Years_Completed__c From Applicant_Info__c a where a.ID IN:Appids];
    if(lstApplicants!=null && lstApplicants.size()>0)
    {
    For(Applicant_Info__c ap : lstApplicants)
    {
     if(ap.Partner_Intrax_Id__c!=NULL)
     {
      List<User> lstUsr = [Select u.Intrax_Id__c, u.Id, u.Account__c, u.AccountId From User u where u.Intrax_Id__c=:ap.Partner_Intrax_Id__c];
     If(lstUsr!=null && lstUsr.size()>0)
     {
      For(User usr:lstUsr)
      {
      Sharing_Security_Controller.shareAccount(ap.account__r.Id, usr.Id);
      }
     }
     }
    }
    }                                    
    }             
 }
 /**
    * Description   :   This method shares position, account and applicant when match is updated for validator and confirmed status values
    * @args         :   Id of matches
    * @return       :   void
    //  */

 public static void shareAssessment(Set<Id> AssessmentIds) {
    List<Assessment__c> lstNewHFAssessment =new List<Assessment__c>();
    List<Assessment__c> lstNewPTAssessment =new List<Assessment__c>();
    List<Assessment__c> lstNewSCAssessment =new List<Assessment__c>();
    List<Assessment__c> lstOtherAssessment =new List<Assessment__c>();
    List<Assessment__c> lstAssessment =new List<Assessment__c>();   
    List<Assessment__c> lstShareAssessment =new List<Assessment__c>();
    Map<Id,Id> ShareHFAssessmentMap = new Map<Id,Id>();
    Map<Id,Id> SharePTAssessmentMap = new Map<Id,Id>();
    Map<Id,List<User>> SharePartnerAssessmentMap = new Map<Id,List<User>>();
    Map<Id,Id> ShareSCPartnerAssessmentMap = new Map<Id,Id>();
    Map<Id,Id> ShareOtherAssessmentMap = new Map<Id,Id>();
     Map<Id,Id> ShareAssessmentOwnerMap = new Map<Id,Id>();
    List<Applicant_Info__c> accAppInfo;
     List<Applicant_Info__c> appInfo ;
       List<User> PartnerUser ;
         List<Applicant_Info__c> PTInfo ;
     
     Group grp;
    User usr;
    
    if(AssessmentIds!=null)
    lstAssessment=[Select a.Engagement__r.Account_Id__c,a.Youth_Experience_Description__c,a.RecordType.Name,a.Record_Type_Group__c,a.Engagement__r.Partner_Account__c,
    a.Wrap_Up_Complete_Indicated__c,a.Position_Name__r.Host_Company_Id__c,a.engagement__r.Partner_id__c,  a.Wrap_Up_Complete_Description__c, a.Welcomers__c, a.Validation_Counter__c,
    a.Upcoming_Separation_Positive__c, a.Upcoming_Separation_Description__c, a.Travel_Arrangements_Indicated__c, a.Time_Period__c, a.SystemModstamp, a.Study_Area__c,
    a.Student_Safety_Approach__c, a.Storage_Area__c, a.Status__c, a.Separation_Plan_Description__c, a.School_Responder__c, a.School_Curriculum_Positive__c, a.School_Adjustment_Positive__c,
    a.School_Adjustment_Description__c, a.School_Activities__c, a.Safety_Hazards__c, a.Safety_Hazards_Description__c, a.Return_Expectations__c, a.Return_Challenges__c,
    a.Resident_Total__c, a.Resident_Participants__c, a.Resident_Illness_Description__c, a.Resident_Change_Indicated__c, a.Resident_Change_Description__c, a.Resident_Adults__c,
    a.Representative__c, a.Repeat_Interest_Indicated__c, a.Repeat_Interest_Description__c, a.RecordTypeId, a.Program_Satisfaction_Positive__c, a.Program_Satisfaction_Description__c,
    a.Program_Impact_Description__c, a.Program_End_Feeling__c, a.Position_Name__c, a.Participant_change_Description__c, a.Participant_Name__c, a.Participant_Change_Positive__c,
    a.Participant_Advice__c, a.PT_Responsibilities__c, a.PT_Responsibilities_Expectations__c, a.PT_Expense_Expectations__c, a.OwnerId, a.Overall_Assessment__c,
    a.Nearby_Support_Description__c, a.Name, a.Month_Number__c, a.Month_Counter__c, a.Match_Name__c, a.Last_School_Day__c, a.LastModifiedDate, a.LastModifiedById,
    a.LastActivityDate, a.IsDeleted, a.Insurance_Info_Received__c, a.Initial_Language_Level__c, a.Initial_Impressions__c, a.Initial_Experience_Positive__c,
    a.Initial_Experience_Description__c, a.In_Touch_Balance_Positive__c, a.In_Touch_Balance_Description__c, a.Id, a.IEW_Participation_Indicated__c, a.Host_Rules__c,
    a.Host_Name__c, a.Host_Motivation__c, a.Host_Memories__c, a.Host_Benefit_Description__c, a.Home_Description__c, a.Holiday_Planning_Positive__c, a.Holiday_Planning_Description__c,
    a.Future_Contact_Plan_Positive__c, a.Friendship_Development_Positive__c, a.Friendship_Development_Description__c, a.First_Return_Activity__c, a.Feeling_Uncomfortable__c,
    a.Feeling_Uncomfortable_Description__c, a.Feeling_Homesick__c, a.Family_Dynamics_Positive__c, a.Family_Bonding_Positive__c, a.Family_Bonding_Description__c,
    a.Family_Activities__c, a.Expectations_for_Year__c, a.Expectation_Of_Participant__c, a.Exchange_Learning_Positive__c, a.Exchange_Learning_Description__c,
    a.Exchange_Experience_Summary__c, a.Enrollment_Period_Start__c, a.Enrollment_Period_End__c, a.Engagement__c, a.Departure_Ready_Indicated__c, a.CurrencyIsoCode,
    a.CreatedDate, a.CreatedById, a.Count_Down__c, a.Contact_Type__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Confirmed_Date__c, a.Community_Service_Indicated__c,
    a.Community_Service_Description__c, a.Community_Description__c, a.Community_Dangerous_Areas__c, a.Communication_Style_Positive__c, a.Communication_Description__c, a.Comments__c,
    a.Cleanliness__c, a.Cleanliness_Description__c, a.Challenges__c, a.Bedroom_Type__c, a.Bedroom_Sharing__c, a.Bedroom_Privacy__c, a.Bed_Type__c, a.Average_Week_Description__c,
    a.Assessment_Staff__c, a.Assessment_Location__c, a.Assessment_Date__c, a.Anticipated_Return_Positive__c, a.Airport__c, a.Adjusting_Positive__c, a.Adjusting_Description__c,
    a.Additional_Support_Requested__c, a.Additional_Support_Description__c, a.Access_To_Utilities__c From Assessment__c a where a.ID IN:AssessmentIds];
    
    
    
    system.debug('*******lstAssessment*******'+lstAssessment);
    system.debug('*******lstAssessment - size*******'+lstAssessment.size());
    
    if(lstAssessment !=null && lstAssessment.size()>0)
    {
        
     grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.Name ='Guest Users'];
      system.debug('*******lstAssessment grp*******'+grp);
     Sharing_Security_Controller.shareAssessmentWithPublicGroup(grp.Id,lstAssessment);
  
             
    For(Assessment__c assInfo : lstAssessment)
    {   
    system.debug('*******assInfo*******'+assInfo);
    if(assInfo.Engagement__c !=null)
    {    
     if(assInfo.Engagement__r.Partner_Id__c!=null)
     {
     PartnerUser = [Select u.Intrax_Id__c, u.Intrax_Account_ID__c, u.Id, u.Account__c, u.AccountId From User u where u.Intrax_Id__c= :assInfo.Engagement__r.Partner_Id__c];                               
      if(PartnerUser!=null && PartnerUser.size()>0)
                    {
                         system.debug('*******lstAssessment PartnerUser*******'+PartnerUser);
                    //  for(User user :PartnerUser)
                     //  {
                            //Share the assessment with the HF Account Applicant
                            SharePartnerAssessmentMap.put(assInfo.Id,PartnerUser);
                             system.debug('*******partner SharePartnerAssessmentMap*******'+SharePartnerAssessmentMap);
                      // }
                         system.debug('*******assInfo*******'+assInfo);
                    }
                  
    }
    }               
   
    if(assInfo.Record_Type_Group__c == 'AY PT Contact' || assInfo.RecordType.Name == 'AY PT Orientation' || assInfo.RecordType.Name=='WT PT Check-In' || assInfo.RecordType.Name=='WT PT Monthly Contact' || assInfo.RecordType.Name=='IGI PT Final Program')    
    
    {  
     system.debug('*******lstAssessment  PTInfo account *******'+assInfo.Participant_Name__c);
     if(assInfo.Participant_Name__c!=null)
     {
     PTInfo = [Select a.CreatedById,a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                    where a.account__c = :assInfo.Participant_Name__c]; 
     }
     else
     {
         PTInfo = [Select a.CreatedById,a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                    where a.account__c = :assInfo.Engagement__r.Account_Id__c]; 
     }
     system.debug('*******lstAssessment PTInfo*******'+PTInfo);    
                  
                     if(PTInfo!=null && PTInfo.size()>0)
                     {
                        //For each application
                        for(Applicant_Info__c pInfo : PTInfo)
                        {                               
                            //Share the assessment with the applicant
                            SharePTAssessmentMap.put(assInfo.Id,pInfo.CreatedBy__c);
                            //Sharing_Security_Controller.shareAssessment(assInfo.Id,aInfo.CreatedBy__c);
                         }
                     }
                        
    }                                    
  
    else
    {
        
     system.debug('*******lstAssessment host account *******'+assInfo.Position_Name__r.Host_Company_Id__c);
     if (assInfo.Position_Name__r.Host_Company_Id__c!=null){
     accAppInfo = [Select a.CreatedById,a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c, a.Arriving_Time__c, a.Account__c From Applicant_Info__c a where a.Account__c=:assInfo.Position_Name__r.Host_Company_Id__c];
     system.debug('*******lstAssessment host account accAppInfo*******'+accAppInfo);
                   if(accAppInfo!=null && accAppInfo.size()>0)
                    {
                         system.debug('*******lstAssessment accAppInfo*******'+accAppInfo);
                        for(Applicant_Info__c applicant :accAppInfo)
                        {
                            //Share the assessment with the HF Account Applicant
                            ShareOtherAssessmentMap.put(assInfo.Id,applicant.CreatedBy__c);
                        }
                        //  Sharing_Security_Controller.shareAssessment(assInfo.Id,applicant.CreatedBy__c);
                    }
    
    
                  
    }
    }  
    }
      system.debug('*******lstAssessment inside helper ShareOtherAssessmentMap*******'+ShareOtherAssessmentMap);
    system.debug('*******lstAssessment inside helper SharePTAssessmentMap*******'+SharePTAssessmentMap);
    
 

    if (SharePTAssessmentMap !=null && SharePTAssessmentMap.size()>0)
    {
        Sharing_Security_Controller.shareAssessment(SharePTAssessmentMap);
    }
  
    if (ShareOtherAssessmentMap !=null  && ShareOtherAssessmentMap.size()>0)
    {
        Sharing_Security_Controller.shareAssessment(ShareOtherAssessmentMap);
    }
      if (SharePartnerAssessmentMap !=null  && SharePartnerAssessmentMap.size()>0)
    {
        Sharing_Security_Controller.sharePartnerAssessment(SharePartnerAssessmentMap);
    }
    system.debug('*******lstAssessment inside helper ShareOtherAssessmentMap*******'+ShareOtherAssessmentMap);
    system.debug('*******lstAssessment inside helper SharePTAssessmentMap*******'+SharePTAssessmentMap);
    system.debug('*******lstAssessment inside helper SharePartnerAssessmentMap*******'+SharePartnerAssessmentMap);
 }}
 /**
    * Description   :   This method shares engagement with Partner
    * @args         :   Id of engagements
    * @return       :   void
    //  */  
  @future
 public static void shareEngagement(Set<Id> NewEngids,Set<Id> Engids,Set<Id> CREngIds) {
    List<Engagement__c> lstEngs =new List<Engagement__c>();
     List<Engagement__c> lstCREngs =new List<Engagement__c>();
    
    
    if(NewEngids!=null)
    {
    lstEngs =[Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id in : NewEngids];
     For(Engagement__c eng : lstEngs)
    {
        system.debug('****eng*******'+eng.Id);
        List<Account> lstAccount = [Select a.Id, a.FirstName From Account a where a.Id = : eng.Account_Id__c];
        if(lstAccount!=null && lstAccount.size()>0)
        {
        List<Applicant_Info__c> applicant = [Select a.Position__r.Position_Types__c, a.Position__r.CreatedById, a.Position__r.Name, a.Position__r.OwnerId, a.Position__r.Id, a.Position__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Id, a.Email__c, a.CreatedBy__c, a.Country__c, a.Citizenship__c, a.Arriving_Time__c, a.Account__c,a.CreatedById From Applicant_Info__c a where  a.Account__c =:lstAccount[0].Id];
        if(applicant!=null && applicant.size()>0)
        {
            for(Applicant_Info__c app :applicant)  
            { 
                 Sharing_Security_Controller.shareEngRecord(eng.Id,app.CreatedBy__c);
                 Sharing_Security_Controller.shareAccount(eng.Account_Id__c,app.CreatedBy__c);
            }
        }
        }
    }
    }
    
    if(Engids!=null)
    {
    lstEngs =[Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id in : Engids];
     For(Engagement__c eng : lstEngs)
    {
      if(eng.Partner_Id__c!=null)
      {     
       List<User> partnerUser = [select Id from User where Intrax_Id__c = :eng.Partner_Id__c];
       if (partnerUser!=null && partnerUser.size() > 0)
       {
        Sharing_Security_Controller.shareEngRecord(eng.Id,partnerUser);
        Sharing_Security_Controller.shareAccount(eng.Account_Id__c,partnerUser);
      }
      }
    
    }
    }
    
    if(CREngIds!=null)
    {
    lstCREngs =[Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id in : CREngIds];
   
     For(Engagement__c eng : lstCREngs)
    {
       Sharing_Security_Controller.shareEngRecordToCRs(eng.Id);
       Sharing_Security_Controller.shareEngAccountRecordToCRs(eng.Account_Id__c);
            
    }
    }
                                          
                  
 }
  /**
    * Description   :   This method shares position from Campaign Position with campaign Partner
    * @args         :   Id of matches
    * @return       :   void
    //  */  
  @future
 public static void shareCampaignPosition (Set<Id> CampPosIds) {
    List<Campaign_Position__c> lstCampPos =new List<Campaign_Position__c>(); 
    Campaign camp;  
    system.debug('*****CampPosIds******'+CampPosIds);
    if(CampPosIds!=null)
    {
    lstCampPos =[Select c.Position__c, c.Partner_Id__c, c.Name, c.Id, c.Company_Name__c, c.Campaign_Name__c,c.Campaign__r.Partner_Name__c,c.campaign__c,c.Position__r.host_company_Id__c From Campaign_Position__c c where c.ID IN:CampPosIds];
     system.debug('*****CampPosIds******'+CampPosIds);
    if(lstCampPos!=null && lstCampPos.size()>0)
    {
    For(Campaign_Position__c cp : lstCampPos)
    {
        
         system.debug('*****cp******'+cp);
        if(cp.Campaign__c !=null)
        {     
        camp = [SELECT Partner_Name__c FROM Campaign WHERE Id =:cp.Campaign__c limit 1];    
        if(camp!=null)
        {      
        List<Account> lstAccount =[Select a.Intrax_Id__c, a.Id From Account a where a.Id=:camp.Partner_Name__c];
        Position__c pos= [select p.host_company_Id__c from position__c p where p.id = :cp.Position__c];
        if(lstAccount!=null && lstAccount.size()>0)
            {
                For(Account acc : lstAccount)   
                {    
                         system.debug('*****acc******'+acc);    
                List<User> PartnerUserList = [Select Id from User where Intrax_Id__c=: acc.Intrax_Id__c];
                if(PartnerUserList!=null)
                {
                    system.debug('*****PartnerUserList******'+PartnerUserList);   
                    system.debug('*****cp.Position__c******'+cp.Position__c);   
                    Sharing_Security_Controller.sharePositionRecord(cp.Position__c, PartnerUserList);                   
                    Sharing_Security_Controller.sharePositionAccountRecord(pos.host_company_Id__c, PartnerUserList);
                }
                }
            }
    }   }}
    }
    }
 }
    @future
    public static void persistPositionSharing(String ShareString) {
        system.debug('******persist called**'+ShareString );
        Position__Share[] reasons = (Position__Share[])JSON.deserialize(shareString, Position__Share[].class);
       system.debug('******persist called reasons**'+reasons );
        
        Database.insert(reasons, false);
    }
     @future
    public static void persistAccountSharing(String ShareString) {
        system.debug('******persist called**'+ShareString );
        AccountShare[] reasons = (AccountShare[])JSON.deserialize(shareString, AccountShare[].class);
       system.debug('******persist called reasons**'+reasons );
        
        Database.insert(reasons, false);
    }
      @future
    public static void persistAppInfoSharing(String ShareString) {
        system.debug('******persist called**'+ShareString );
        Applicant_Info__Share[] reasons = (Applicant_Info__Share[])JSON.deserialize(shareString, Applicant_Info__Share[].class);
       system.debug('******persist called reasons**'+reasons );
        
        Database.insert(reasons, false);
    }
      @future
    public static void persistAssessmentSharing(String ShareString) {
        system.debug('******persist called**'+ShareString );
        Assessment__Share[] reasons = (Assessment__Share[])JSON.deserialize(shareString, Assessment__Share[].class);
       system.debug('******persist called reasons**'+reasons );
        
        Database.insert(reasons, false);
    }
    @future  
    public static void persistEngSharing(String ShareString) {
        system.debug('******persist called**'+ShareString );
        Engagement__Share[] reasons = (Engagement__Share[])JSON.deserialize(shareString, Engagement__Share[].class);
       system.debug('******persist called reasons**'+reasons );
        
        Database.insert(reasons, false);
    }
    
   
     public static void shareStandardUser(Set<Id> UserIds,set<String> UserIntraxIds)
    {
           List<User> lstUser=new List<User>();
           Map<Id,Id> MapMatCampIds = new map<Id,Id>();
           Map<Id,Id> MapCampPartnerUsers =  new map<Id,Id>();
           List<Campaign> lstCampaign =  new list<Campaign>();
           lstCampaign =[Select c.Type, c.Partner_Name__c, c.Name, c.IsActive, c.Intrax_Region__c, c.Intrax_Programs__c, c.Intrax_Market__c, c.Id From Campaign c where c.Partner_Name__c in ( Select a.Id from account a where Intrax_Id__c in :UserIntraxIds)];
           
           lstUser = [Select u.Type__c,u.UserRole.DeveloperName, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.ManualShareExists__c From User u where u.Id in :UserIds];
            Map<Id,List<User>> SharePTApplicantMap = new Map<Id,List<User>>();
           List<Engagement__c> lstEng =new  List<Engagement__c> ();
           if(lstUser!=null && lstUser.size()>0)
           {
            For(User user: lstUser)
            {
                       
              set<Id> AccountIds = new Set<Id>();
              set<Id> AssessmentIds = new Set<Id>();
              lstEng = [SELECT Id, Type__c, Account_Id__r.ParentId, Account_Id__r.RecordTypeId, Account_Id__r.Type, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name,
                 Account_Id__r.Id, Account_Id__c,Status__c, Position_Types__c, Position_Types_Other__c, Name, Location_of_Interest__c From Engagement__c WHERE Partner_ID__c =: user.Intrax_Id__c AND Type__c = 'Participant'];              
               If(lstEng!=null && lstEng.size()>0)
               {                
                Sharing_Security_Controller.shareEngPartnerApplicant(lstEng,user.Id);
                 For(Engagement__c engInfo : lstEng)    
                 {           
                  AccountIds.add(engInfo.Account_Id__r.Id);
                 }
              
                Sharing_Security_Controller.shareAccount(AccountIds,user.Id);
               
                
                   List<Match__c> lstEngMatch=new list<Match__c>();
                  
                   lstEngMatch=[Select m.Position_Name__c,m.RecordTypeId,m.Participant_Id__r.FirstName,m.Position_Name__r.Host_Company_Id__c, m.Participant_Id__r.LastName, m.Participant_Id__r.Name, 
                   m.Participant_Id__c, m.Name, m.Match_Type__c, m.Id, m.Engagement__r.CreatedById, m.Engagement__r.Name, 
                   m.Engagement__r.Id, m.Engagement__c,m.Status__c,(Select Name,Id,Status__c From Match_Assessments__r)  From Match__c m where m.Engagement__c in :lstEng];
                   set<Id> PosIds = new set<Id>();
                   set<Id> NonConfPosIds = new set<Id>();
                   system.debug('******lstEngMatch*****'+lstEngMatch);
                   if(lstEngMatch!=null && lstEngMatch.size()>0)
                   {
                    for(Match__c mat:lstEngMatch)
                    {                                       
                    if(mat.Status__c == 'Confirmed' || mat.RecordTypeId==Constants.MAT_INTERNSHIP)    
                     PosIds.add(mat.Position_Name__c);
                    else
                      NonConfPosIds.add(mat.Position_Name__c);
                    if(mat.Match_Assessments__r.size()>0)
                     {
                        for (Assessment__c ass: mat.Match_Assessments__r)
                        {
                            if(ass.Status__c == 'Confirmed')
                             AssessmentIds.add(ass.Id);
                              system.debug('******AssessmentIds*****'+AssessmentIds);
                        }
                     }
                    }                                   
                  
                   if(NonConfPosIds!=null)
                   Sharing_Security_Controller.shareROEngMatchPositionApplicant(NonConfPosIds,user.Id);
                  
                   if(PosIds!=null)
                   Sharing_Security_Controller.shareEngMatchPositionApplicant(PosIds,user.Id); 
                   
                  
                   if(AssessmentIds!=null) 
                   Sharing_Security_Controller.shareStdUsrEngMatchAssessment(AssessmentIds,user.Id);  
                   
                       List<Applicant_Info__c> lstMatchPosAppInfo =[Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                        where a.position__c in :PosIds];
                      if(lstMatchPosAppInfo!=null && lstMatchPosAppInfo.size()>0)
                      {
                         Sharing_Security_Controller.shareROApplicantRecord(lstMatchPosAppInfo,user.Id);
                      }                    
            
                   }
               }
             
          if(lstCampaign!=null && lstCampaign.size()>0)
          {
            set<Id> campIds=new set<Id>();
            For(Campaign camp:lstCampaign)
            {
                campIds.add(camp.Id);
            }
            if(campIds!=null)
            {
                set<Id> campPosIds=new set<Id>();
                set<Id> campSessionIds=new set<Id>();
                List<Campaign_Position__c> lstCampPos =[Select c.Position__c, c.Partner_Id__c, c.Name, c.Id, c.Company_Name__c, c.Campaign_Name__c,c.Campaign__r.Partner_Name__c,c.campaign__c,c.Position__r.host_company_Id__c From Campaign_Position__c c where c.campaign__c IN:campIds];
                For(Campaign_Position__c campPos:lstCampPos)
                {
                    campPosIds.add(campPos.Position__c);
                }
                List<Campaign_Session__c> lstCampSessions =[Select c.SystemModstamp, c.Spaces_Filled__c, c.Campaign__r.Partner_Name__c,c.Spaces_Available__c, c.Session_Start__c, c.Session_Label__c, c.Session_End__c, c.OwnerId, c.Name, c.Maximum_Capacity__c, c.Id, c.Host_Company_Name__c, c.CurrencyIsoCode, c.Campaign_isActive__c, c.Campaign__c, c.Campaign_Type__c, c.Campaign_StartDate__c, c.Campaign_Name__c, c.Campaign_EndDate__c, c.Allocated_Quantity__c From Campaign_Session__c c where c.Campaign__c in :campIds];
                For(Campaign_Session__c campSession : lstCampSessions)
                {
                    campSessionIds.add(campSession.Id);
                }
                Sharing_Security_Controller.shareCampPartnerUsers(campIds,user.Id);
                if(campPosIds!=null)
                Sharing_Security_Controller.shareROEngMatchPositionApplicant(campPosIds,user.Id);
                if(campSessionIds!=null)
                Sharing_Security_Controller.shareHCCampSessionHCUsers(campSessionIds,user.Id);
            }
          }    
                 
               
             // comment the following for removing Partner Sharing     
         List<Applicant_Info__c> lstAppInfo = [Select a.Years_in_Home__c, a.Writing_Skills__c, a.Weight__c, a.Visa_Type__c, a.Visa_Category__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Terms_Accepted__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Sys_Allow_Cloning__c, a.Sys_Admin_Tag__c, a.Submitted__c, a.Submitted_Date__c, a.Study_Weeks__c, a.Study_Time__c, a.Street__c, a.State__c, a.Standard_Delivery__c, a.Special_Needs_Food__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, a.Smoker_Student__c, a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Service_Level__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.School_Name__c, a.School_Name_SOR__c, a.School_Employee__c, a.SOR_Received_Date__c, a.Reviewed_Date__c, a.Resume__c, a.Residence_Club__c, a.Religious_Sharing_Indicated__c, a.Religious_Restriction_Indicated__c, a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.References_Requested__c, a.References_Received__c, a.References_Audited__c, a.Reference_Count__c, a.Reference_Check__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reason__c, a.Reason_Detail__c, a.Reading_Comprehension__c, a.RB_Last_Name__c, a.RB_First_Name__c, a.Questions__c, a.Projects_of_Interest__c, a.Program_Year__c, a.Program_Start__c, a.Program_Start_Opinion__c, a.Program_Selector__c, a.Program_Preference_Comment__c, a.Program_Duration__c, a.Profile_Summary__c, a.Private_High_School_Tuition__c, a.Private_High_School_Indicated__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Prior_Visa_Start_Date__c, a.Prior_Visa_End_Date__c, a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Experience_DEPR__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.Primary_Activity__c, a.Previous_Address_Complete__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Position__c, a.Position_Types__c, a.Position_Types_Other__c, a.Portal_Contact_Id__c, a.Points_of_Interest__c, a.Pluto_Id__c, a.Placement_Pending__c, a.PhotoId__c, a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Pax__c, a.Pax_Count__c, a.Passport_Number__c, a.Passport_Country__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Own_insurance__c, a.Overall_Progress__c, a.Other_Languages__c, a.Opportunity_Name__c, a.Nemo_Update_Request_At__c, a.Nemo_Id__c, a.Nearest_City__c, a.Nationality_Preferences__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Location_of_Interest__c, a.Location_Preference_3__c, a.Location_Preference_2__c, a.Location_Preference_1__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c, a.Last_Name__c, a.Last_Applicant_Update__c, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.Language_spoken_years_3__c, a.Language_spoken_years_2__c, a.Language_spoken_years_1__c, a.Language_spoken_3__c, a.Language_spoken_2__c, a.Language_spoken_1__c, a.Language_3__c, a.Language_3_Proficiency__c, a.Language_2__c, a.Language_2_Proficiency__c, a.Language_1__c, a.Language_1_Proficiency__c, a.IsVisaDocumentPageSubmitted__c, a.IsDeleted, a.Intrax_Region__c, a.Intrax_Program__c, a.Intrax_Program_Options__c, a.Intrax_Insurance__c, a.Intrax_Homestay_Accommodations__c, a.Intrax_Center__c, a.Intrax_Accommodations__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Incomplete_Missing_Documents__c, a.Incomplete_Documents_Notes__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.How_Heard__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Homestay__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Province__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Health_Needs_Indicated__c, a.Health_Needs_Description__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Graduated__c, a.Government_Assistence_Indicated__c, a.General_Summary__c, a.Gender_Preference__c, a.GPA__c, a.GPA_Self_Reported__c, a.Functional_Areas__c, a.Functional_Areas_Other__c, a.Flight_Number__c, a.Flight_Arrival_Time__c, a.Flight_Arrival_Date__c, a.Flexible_Dates__c, a.First_Name__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Members_Complete__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Express_Delivery__c, a.Exchange_Agency_Employment__c, a.Exchange_Agency_Employer_Name__c, a.Entity_Id__c, a.Enquiry_Channel__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c, a.English_Teach_Name__c, a.English_Summary__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c, a.Engagement__c, a.Engagement_Start__c, a.Engagement_End__c, a.Employer_Name__c, a.Emergency_Contact_Complete__c, a.Email__c, a.Education_Grade__c, a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c, a.Deposit_Fee_Accepted__c, a.Date_of_Birth__c, a.Daily_Meal_Commitment__c, a.CurrencyIsoCode, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.createdBy__c, a.Country_of_Interest__c, a.Country_of_Birth__c, a.Country__c, a.Coordinator__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.City__c, a.Citizenship__c, a.Children_Enrolled__c, a.Check_out_Date__c, a.Check_in_Date__c, a.Center_Disclosure_Accepted__c, a.Carrier__c, a.Carrier_Number__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Best_Call_Time_c__c, a.Best_Call_Time__c, a.Behavioral_Problems__c, a.Behavioral_Problems_Description__c, a.Bedrooms__c, a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.BGC_Required_Count_AYU__c, a.BGC_Passed_Count_AYU__c, a.BGC_Failed_Count_AYU__c, a.BGC_D_Remaining__c, a.Attendance_Problems__c, a.Attendance_Problems_Description__c, a.Arriving_Time__c, a.Arriving_Date__c, a.Arrival_Time__c, a.Application_Stage__c, a.Application_Level__c, a.Applicant_Info_Count__c, a.Any_housing_that_fits_my_program_dates__c, a.Any_Special_Food_Requirement__c, a.Allergies_from_Partner__c, a.Allergies_from_Applicant__c, a.Allergies_Other_desc__c, a.Allergies_Other_Partner__c, a.Allergies_Indicated__c, a.Airport__c, a.Airport_Transfer_Departure__c, a.Airport_Transfer_Arrival__c, a.Account__c, a.Accommodation_Price_Range__c, a.Accommodation_Preference__c, a.Accepted_Date__c,
            a.Academic_Years_Completed__c From Applicant_Info__c a where a.Partner_Intrax_Id__c=:user.Intrax_Id__c ];
             system.debug('***************** lstAppInfo ' + lstAppInfo);
           
             if(lstAppInfo!=null && lstAppInfo.size()>0)
             {
                Sharing_Security_Controller.shareApplicantRecord(lstAppInfo,user.Id);
              }
               
                 /*   List<UserRole> ExecutiveRoleUsr=[Select u.PortalType, u.PortalRole, u.ParentRoleId, u.Name, u.Id,u.DeveloperName From UserRole u Where u.DeveloperName='PartnerCustomerExecutive'];
                     
                    if(user.UserRole.DeveloperName=='PartnerCustomerUser')
                        {
                            // Sharing_Security_Controller.sharePartnerApplicant(appInfo.Id,user.Id);
                             Sharing_Security_Controller.sharePartnerRoleUp(lstAppInfo,user.UserRole.ParentRoleId);
                             if(ExecutiveRoleUsr!=null && ExecutiveRoleUsr.size()>0)
                             {
                               
                                 Sharing_Security_Controller.sharePartnerRoleUp(lstAppInfo,ExecutiveRoleUsr[0].Id);
                             }
                        }
                           if(user.UserRole.DeveloperName=='PartnerCustomerManager')
                        {
                             Sharing_Security_Controller.sharePartnerRoleUp(lstAppInfo,user.UserRole.ParentRoleId);
                        } */
            }
            
            }
           
    }
    
     
    public static void sharePartnerContact(Set<Id> ContactIds)
    {
           List<User> lstUser=new List<User>();
           Map<Id,Id> MapMatCampIds = new map<Id,Id>();
           Map<Id,Id> MapCampPartnerUsers =  new map<Id,Id>();
           List<Campaign> lstCampaign =  new list<Campaign>();
           lstCampaign =[Select c.Type, c.Partner_Name__c, c.Name, c.IsActive, c.Intrax_Region__c, c.Intrax_Programs__c, c.Intrax_Market__c, c.Id From Campaign c where c.Partner_Name__c in (Select c.AccountId From Contact c where c.Id in :ContactIds)];
           
           lstUser = [Select u.Type__c,u.UserRole.DeveloperName, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualPartnerShareExists__c, u.ContactId From User u where u.ContactId in :ContactIds];
            Map<Id,List<User>> SharePTApplicantMap = new Map<Id,List<User>>();
           List<Engagement__c> lstEng =new  List<Engagement__c> ();
           if(lstUser!=null && lstUser.size()>0)
           {
            For(User user: lstUser)
            {
                       
              set<Id> AccountIds = new Set<Id>();
              set<Id> AssessmentIds = new Set<Id>();
              lstEng = [SELECT Id, Type__c, Account_Id__r.ParentId, Account_Id__r.RecordTypeId, Account_Id__r.Type, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.Name,
                 Account_Id__r.Id, Account_Id__c,Status__c, Position_Types__c, Position_Types_Other__c, Name, Location_of_Interest__c From Engagement__c WHERE Partner_ID__c =: user.Intrax_Id__c AND Type__c = 'Participant'];              
               If(lstEng!=null && lstEng.size()>0)
               {                
                Sharing_Security_Controller.shareEngPartnerApplicant(lstEng,user.Id);
                 For(Engagement__c engInfo : lstEng)    
                 {           
                  AccountIds.add(engInfo.Account_Id__r.Id);
                 }
              
                Sharing_Security_Controller.shareAccount(AccountIds,user.Id);
               
                
                   List<Match__c> lstEngMatch=new list<Match__c>();
                  
                   lstEngMatch=[Select m.Position_Name__c,m.RecordTypeId,m.Participant_Id__r.FirstName,m.Position_Name__r.Host_Company_Id__c, m.Participant_Id__r.LastName, m.Participant_Id__r.Name, 
                   m.Participant_Id__c, m.Name, m.Match_Type__c, m.Id, m.Engagement__r.CreatedById, m.Engagement__r.Name, 
                   m.Engagement__r.Id, m.Engagement__c,m.Status__c,(Select Name,Id From Match_Assessments__r)  From Match__c m where m.Engagement__c in :lstEng];
                   set<Id> PosIds = new set<Id>();
                   set<Id> NonConfPosIds = new set<Id>();
                   if(lstEngMatch!=null && lstEngMatch.size()>0)
                   {
                    for(Match__c mat:lstEngMatch)
                    {                                       
                    if(mat.Status__c == 'Confirmed' || mat.RecordTypeId==Constants.MAT_INTERNSHIP)    
                     PosIds.add(mat.Position_Name__c);
                    else
                      NonConfPosIds.add(mat.Position_Name__c);
                     if(mat.Match_Assessments__r.size()>0)
                     {
                        for (Assessment__c ass: mat.Match_Assessments__r)
                         AssessmentIds.add(ass.Id);
                     }
                    }                                   
                  
                   if(NonConfPosIds!=null)
                   Sharing_Security_Controller.shareROEngMatchPositionApplicant(NonConfPosIds,user.Id);
                  
                   if(PosIds!=null)
                   Sharing_Security_Controller.shareEngMatchPositionApplicant(PosIds,user.Id); 
                   
                   if(AssessmentIds!=null) 
                   Sharing_Security_Controller.shareStdUsrEngMatchAssessment(AssessmentIds,user.Id);  
                   
                       List<Applicant_Info__c> lstMatchPosAppInfo =[Select a.Opportunity_Name__c, a.Id,a.Partner_Intrax_Id__c, a.createdBy__c, a.Application_Stage__c, a.Application_Level__c From Applicant_Info__c a 
                                        where a.position__c in :PosIds];
                      if(lstMatchPosAppInfo!=null && lstMatchPosAppInfo.size()>0)
                      {
                         Sharing_Security_Controller.shareROApplicantRecord(lstMatchPosAppInfo,user.Id);
                      }                    
            
                   }
               }
             
          if(lstCampaign!=null && lstCampaign.size()>0)
          {
            set<Id> campIds=new set<Id>();
            For(Campaign camp:lstCampaign)
            {
                campIds.add(camp.Id);
            }
            if(campIds!=null)
            {
                set<Id> campPosIds=new set<Id>();
                set<Id> campSessionIds=new set<Id>();
                List<Campaign_Position__c> lstCampPos =[Select c.Position__c, c.Partner_Id__c, c.Name, c.Id, c.Company_Name__c, c.Campaign_Name__c,c.Campaign__r.Partner_Name__c,c.campaign__c,c.Position__r.host_company_Id__c From Campaign_Position__c c where c.campaign__c IN:campIds];
                For(Campaign_Position__c campPos:lstCampPos)
                {
                    campPosIds.add(campPos.Position__c);
                }
                List<Campaign_Session__c> lstCampSessions =[Select c.SystemModstamp, c.Spaces_Filled__c, c.Campaign__r.Partner_Name__c,c.Spaces_Available__c, c.Session_Start__c, c.Session_Label__c, c.Session_End__c, c.OwnerId, c.Name, c.Maximum_Capacity__c, c.Id, c.Host_Company_Name__c, c.CurrencyIsoCode, c.Campaign_isActive__c, c.Campaign__c, c.Campaign_Type__c, c.Campaign_StartDate__c, c.Campaign_Name__c, c.Campaign_EndDate__c, c.Allocated_Quantity__c From Campaign_Session__c c where c.Campaign__c in :campIds];
                For(Campaign_Session__c campSession : lstCampSessions)
                {
                    campSessionIds.add(campSession.Id);
                }
                Sharing_Security_Controller.shareCampPartnerUsers(campIds,user.Id);
                if(campPosIds!=null)
                Sharing_Security_Controller.shareROEngMatchPositionApplicant(campPosIds,user.Id);
                if(campSessionIds!=null)
                Sharing_Security_Controller.shareHCCampSessionHCUsers(campSessionIds,user.Id);
            }
          }    
                 
               
             // comment the following for removing Partner Sharing     
         List<Applicant_Info__c> lstAppInfo = [Select a.Years_in_Home__c, a.Writing_Skills__c, a.Weight__c, a.Visa_Type__c, a.Visa_Category__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Terms_Accepted__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Sys_Allow_Cloning__c, a.Sys_Admin_Tag__c, a.Submitted__c, a.Submitted_Date__c, a.Study_Weeks__c, a.Study_Time__c, a.Street__c, a.State__c, a.Standard_Delivery__c, a.Special_Needs_Food__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, a.Smoker_Student__c, a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Service_Level__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.School_Name__c, a.School_Name_SOR__c, a.School_Employee__c, a.SOR_Received_Date__c, a.Reviewed_Date__c, a.Resume__c, a.Residence_Club__c, a.Religious_Sharing_Indicated__c, a.Religious_Restriction_Indicated__c, a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.References_Requested__c, a.References_Received__c, a.References_Audited__c, a.Reference_Count__c, a.Reference_Check__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reason__c, a.Reason_Detail__c, a.Reading_Comprehension__c, a.RB_Last_Name__c, a.RB_First_Name__c, a.Questions__c, a.Projects_of_Interest__c, a.Program_Year__c, a.Program_Start__c, a.Program_Start_Opinion__c, a.Program_Selector__c, a.Program_Preference_Comment__c, a.Program_Duration__c, a.Profile_Summary__c, a.Private_High_School_Tuition__c, a.Private_High_School_Indicated__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Prior_Visa_Start_Date__c, a.Prior_Visa_End_Date__c, a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Experience_DEPR__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.Primary_Activity__c, a.Previous_Address_Complete__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Position__c, a.Position_Types__c, a.Position_Types_Other__c, a.Portal_Contact_Id__c, a.Points_of_Interest__c, a.Pluto_Id__c, a.Placement_Pending__c, a.PhotoId__c, a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Pax__c, a.Pax_Count__c, a.Passport_Number__c, a.Passport_Country__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Own_insurance__c, a.Overall_Progress__c, a.Other_Languages__c, a.Opportunity_Name__c, a.Nemo_Update_Request_At__c, a.Nemo_Id__c, a.Nearest_City__c, a.Nationality_Preferences__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Location_of_Interest__c, a.Location_Preference_3__c, a.Location_Preference_2__c, a.Location_Preference_1__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c, a.Last_Name__c, a.Last_Applicant_Update__c, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.Language_spoken_years_3__c, a.Language_spoken_years_2__c, a.Language_spoken_years_1__c, a.Language_spoken_3__c, a.Language_spoken_2__c, a.Language_spoken_1__c, a.Language_3__c, a.Language_3_Proficiency__c, a.Language_2__c, a.Language_2_Proficiency__c, a.Language_1__c, a.Language_1_Proficiency__c, a.IsVisaDocumentPageSubmitted__c, a.IsDeleted, a.Intrax_Region__c, a.Intrax_Program__c, a.Intrax_Program_Options__c, a.Intrax_Insurance__c, a.Intrax_Homestay_Accommodations__c, a.Intrax_Center__c, a.Intrax_Accommodations__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Incomplete_Missing_Documents__c, a.Incomplete_Documents_Notes__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.How_Heard__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Homestay__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Province__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Health_Needs_Indicated__c, a.Health_Needs_Description__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Graduated__c, a.Government_Assistence_Indicated__c, a.General_Summary__c, a.Gender_Preference__c, a.GPA__c, a.GPA_Self_Reported__c, a.Functional_Areas__c, a.Functional_Areas_Other__c, a.Flight_Number__c, a.Flight_Arrival_Time__c, a.Flight_Arrival_Date__c, a.Flexible_Dates__c, a.First_Name__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Members_Complete__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Express_Delivery__c, a.Exchange_Agency_Employment__c, a.Exchange_Agency_Employer_Name__c, a.Entity_Id__c, a.Enquiry_Channel__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c, a.English_Teach_Name__c, a.English_Summary__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c, a.Engagement__c, a.Engagement_Start__c, a.Engagement_End__c, a.Employer_Name__c, a.Emergency_Contact_Complete__c, a.Email__c, a.Education_Grade__c, a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c, a.Deposit_Fee_Accepted__c, a.Date_of_Birth__c, a.Daily_Meal_Commitment__c, a.CurrencyIsoCode, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.createdBy__c, a.Country_of_Interest__c, a.Country_of_Birth__c, a.Country__c, a.Coordinator__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.City__c, a.Citizenship__c, a.Children_Enrolled__c, a.Check_out_Date__c, a.Check_in_Date__c, a.Center_Disclosure_Accepted__c, a.Carrier__c, a.Carrier_Number__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Best_Call_Time_c__c, a.Best_Call_Time__c, a.Behavioral_Problems__c, a.Behavioral_Problems_Description__c, a.Bedrooms__c, a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.BGC_Required_Count_AYU__c, a.BGC_Passed_Count_AYU__c, a.BGC_Failed_Count_AYU__c, a.BGC_D_Remaining__c, a.Attendance_Problems__c, a.Attendance_Problems_Description__c, a.Arriving_Time__c, a.Arriving_Date__c, a.Arrival_Time__c, a.Application_Stage__c, a.Application_Level__c, a.Applicant_Info_Count__c, a.Any_housing_that_fits_my_program_dates__c, a.Any_Special_Food_Requirement__c, a.Allergies_from_Partner__c, a.Allergies_from_Applicant__c, a.Allergies_Other_desc__c, a.Allergies_Other_Partner__c, a.Allergies_Indicated__c, a.Airport__c, a.Airport_Transfer_Departure__c, a.Airport_Transfer_Arrival__c, a.Account__c, a.Accommodation_Price_Range__c, a.Accommodation_Preference__c, a.Accepted_Date__c,
            a.Academic_Years_Completed__c From Applicant_Info__c a where a.Partner_Intrax_Id__c=:user.Intrax_Id__c ];
             system.debug('***************** lstAppInfo ' + lstAppInfo);
           
             if(lstAppInfo!=null && lstAppInfo.size()>0)
             {
                Sharing_Security_Controller.shareApplicantRecord(lstAppInfo,user.Id);
              }
               
                    List<UserRole> ExecutiveRoleUsr=[Select u.PortalType, u.PortalRole, u.ParentRoleId, u.Name, u.Id,u.DeveloperName From UserRole u Where u.DeveloperName='PartnerCustomerExecutive'];
                     
                    if(user.UserRole.DeveloperName=='PartnerCustomerUser')
                        {
                            // Sharing_Security_Controller.sharePartnerApplicant(appInfo.Id,user.Id);
                             Sharing_Security_Controller.sharePartnerRoleUp(lstAppInfo,user.UserRole.ParentRoleId);
                             if(ExecutiveRoleUsr!=null && ExecutiveRoleUsr.size()>0)
                             {
                               
                                 Sharing_Security_Controller.sharePartnerRoleUp(lstAppInfo,ExecutiveRoleUsr[0].Id);
                             }
                        }
                           if(user.UserRole.DeveloperName=='PartnerCustomerManager')
                        {
                             Sharing_Security_Controller.sharePartnerRoleUp(lstAppInfo,user.UserRole.ParentRoleId);
                        }
            }
            
            }
           
    }
     public static void shareHCPortalContact(Set<Id> ContactIds)
    {
           List<User> lstUser=new List<User>();
           List<Campaign_Session__c> lstCampSession = new  List<Campaign_Session__c>();
           set<Id> campSessionIds = new set<Id>();
           lstUser = [Select u.Type__c,u.UserRole.DeveloperName, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.ContactId in :ContactIds];
           
           List<Position__c> lstPositions =new  List<Position__c> ();
           List<Match__c> lstPosMatches=new list<Match__c>();
           List<Account> lstAccounts=new list<Account>();
           List<Account> lstChildrenAccounts = new list<Account>();
           if(lstUser!=null && lstUser.size()>0)
           {
            For(User user: lstUser)
            {                      
              set<Id> AccountIds = new Set<Id>(); 
              set<Id> ParentAccountIds = new Set<Id>(); 
              set<Id> PositionIds = new Set<Id>();
              set<Id> EngIds = new Set<Id>();     
              set<Id> EngAccountIds = new Set<Id>();        
              lstAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.Intrax_Id__c =: user.Intrax_Id__c AND a.Type = 'Host Company'];              
             system.debug('***lstAccounts***'+lstAccounts);
               If(lstAccounts!=null && lstAccounts.size()>0)
               {   
                 For(Account acc : lstAccounts)    
                 {           
                  AccountIds.add(acc.Id);
                  if(acc.ParentId ==null)
                  ParentAccountIds.add(acc.Id); 
                 }
                 if(ParentAccountIds!=null)
                 {
                 lstChildrenAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.ParentId in :ParentAccountIds];
                 if(lstChildrenAccounts!=null && lstChildrenAccounts.size()>0)
                 {
                 For(Account cacc:lstChildrenAccounts)
                 AccountIds.add(cacc.Id);
                 }
                 }                                            
                Sharing_Security_Controller.shareAccount(AccountIds,user.Id);               
                lstPositions = [Select p.RecordTypeId, p.Name, p.Intrax_Program__c, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.City__c From Position__c p
                                where p.Host_Company_Id__c in : AccountIds];
                 system.debug('***lstPositions***'+lstPositions); 
                if(lstPositions!=null && lstPositions.size()>0)
                {
                 For(Position__c pos: lstPositions)
                 PositionIds.add(pos.Id);
                  
                 if(PositionIds!=null) 
                 Sharing_Security_Controller.shareEngMatchPositionApplicant(PositionIds,user.Id);
                 
                 lstPosMatches =[Select m.Position_Name__c,m.Participant_Id__r.FirstName,m.Position_Name__r.Host_Company_Id__c, m.Participant_Id__r.LastName, m.Participant_Id__r.Name, 
                   m.Participant_Id__c, m.Name, m.Match_Type__c, m.Id, m.Engagement__r.CreatedById, m.Engagement__r.Name, 
                   m.Engagement__r.Id, m.Engagement__c,m.Engagement__r.Account_Id__c  From Match__c m where m.Position_Name__c in :lstPositions];
                  system.debug('***lstPosMatches***'+lstPosMatches); 
                 if(lstPosMatches!=null && lstPosMatches.size()>0)
                 {
                    For(Match__c mat:lstPosMatches)
                    {
                        EngIds.add(mat.Engagement__c);
                        EngAccountIds.add(mat.Engagement__r.Account_Id__c);
                    }
                      Sharing_Security_Controller.shareAccount(EngAccountIds,user.Id); 
                      Sharing_Security_Controller.shareEngagements(EngIds,user.Id);
                 }  
                  
              
                }
                lstCampSession = [Select c.Spaces_Filled__c, c.Spaces_Available__c, c.Session_Start__c, c.Session_Label__c, c.Session_End__c, c.Partner_Name__c, c.Name, c.Maximum_Capacity__c,  c.Id, c.Host_Company_Name__c,
                 c.CurrencyIsoCode, c.Campaign_isActive__c, c.Campaign__c, c.Campaign_Type__c, c.Campaign_StartDate__c, c.Campaign_Name__c, c.Campaign_EndDate__c, c.Allocated_Quantity__c From Campaign_Session__c c where c.Host_Company_Name__c in :AccountIds];
               if(lstCampSession!=null && lstCampSession.size()>0)
               {
                For(Campaign_Session__c camp:lstCampSession)
                    {
                        campSessionIds.add(camp.Id);                      
                    }
                    Sharing_Security_Controller.shareHCCampSessionHCUsers(campSessionIds, user.Id);
               }
               }
            }
           }
    }
     @future
      public static void shareHCPortalContactPositions(Set<Id> HCPositionIds)
    {
           List<Position__c> lstHCPositions=new List<Position__c>();
           List<Contact> lstHCContacts=new List<Contact>();
           Set<Id> HCAccountIds =  new set<Id>();
           Set<Id> ParentAccountIds =  new set<Id>();            
           Set<Id> HCContactIds =  new set<Id>();
           Set<Id> ChildrenAccountIds =  new set<Id>();
           Set<Id> HCMatchesId =  new set<Id>();
           Set<Id> HCMatchEngIds =  new set<Id>();
           List<User> lstUser=new List<User>();
           List<Account> lstAccounts=new List<Account>();
           List<Account> lstChildrenAccounts=new List<Account>();
           List<Match__c> lstHCMatches=new List<Match__c>();
           List<Engagement__c> lstEngagements=new List<Engagement__c>();
            system.debug('***HCPositionIds******'+HCPositionIds);
           lstHCPositions = [Select p.RecordTypeId, p.Name, p.Intrax_Program__c, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.City__c From Position__c p
                                where p.id in : HCPositionIds];
           system.debug('***lstHCPositions******'+lstHCPositions);
           if(lstHCPositions!=null && lstHCPositions.size()>0)
           {
            For(Position__c pos:lstHCPositions)
            HCAccountIds.add(pos.Host_Company_Id__c);          
          system.debug('***HCAccountIds******'+HCAccountIds);
           if(HCAccountIds!=null)
           {
            lstAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.Id in :HCAccountIds];
           system.debug('***lstAccounts******'+lstAccounts);
           if(lstAccounts!=null && lstAccounts.size()>0)
           {
            For (Account a: lstAccounts)
            {
                if(a.ParentId == Null)
                ParentAccountIds.add(a.Id);
                if(a.ParentId != Null)
                HCAccountIds.add(a.ParentId);
            }
               system.debug('***ParentAccountIds******'+ParentAccountIds);
           lstChildrenAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.ParentId in :ParentAccountIds];
             system.debug('***lstChildrenAccounts******'+lstChildrenAccounts);
           
            system.debug('***HCAccountIds -2******'+HCAccountIds);
           lstHCContacts = [Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId in :HCAccountIds];
             system.debug('***lstHCContacts******'+lstHCContacts);
           if(lstHCContacts!=null && lstHCContacts.size()>0)
           {
           For(Contact con: lstHCContacts)  
           HCContactIds.add(con.Id);  
            system.debug('***HCContactIds******'+HCContactIds);
                   
           If(HCContactIds!=null)
            lstUser = [Select u.Type__c,u.UserRole.DeveloperName, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.ContactId in :HCContactIds];
          system.debug('***lstUser******'+lstUser);
          if(lstUser!=null && lstUser.size()>0)
          {
          If(lstChildrenAccounts!=null && lstChildrenAccounts.size()>0)
          {
          For(Account cacc: lstChildrenAccounts)
          {
            ChildrenAccountIds.add(cacc.Id);
            HCAccountIds.add(cacc.Id);
          }
          If(ChildrenAccountIds!=null)
          {
          lstHCPositions = [Select p.RecordTypeId, p.Name, p.Intrax_Program__c, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.City__c From Position__c p
                                where p.Host_Company_Id__c in : ChildrenAccountIds];
          For(Position__c p:lstHCPositions)
          HCPositionIds.add(p.Id);                      
          
          If(HCPositionIds!=null)
          lstHCMatches = [Select Id,Position_Name__r.Id,participant_Id__c,Position_Name__c,Status__c,Position_Name__r.RecordTypeId,Engagement__c,Engagement__r.Partner_Id__c,Validator__c,Position_Name__r.Host_Opportunity_Id__c,Position_Name__r.Host_Company_Id__c, Interview_Date__c from Match__c 
                               where Position_Name__c IN:HCPositionIds];
          
          If(lstHCMatches!=null && lstHCMatches.size()>0)
          {
          For(Match__c m:lstHCMatches)  
          {
          //HCMatchesId.add(m.Engagement__c);
          HCMatchEngIds.add(m.Engagement__c);
          HCAccountIds.add(m.participant_Id__c);
          }
        /*  If(HCMatchesId!=null)
          {
           lstEngagements = [Select e.Opportunity_Id__c, e.Id, e.Partner_Id__c,e.CreatedById, e.Age_At_Program_Start__c, e.Account_Id__c From Engagement__c e WHERE  e.Id in : HCMatchesId];
           if(lstEngagements!=null && lstEngagements.size()>0)
           {
            for(Engagement__c eng:lstEngagements)
            {
            HCMatchEngIds.add(eng.Id);
            HCAccountIds.add(eng.Account_Id__c);
            }
           }
          }*/
            if(HCMatchEngIds!=null)
            Sharing_Security_Controller.shareHCEngHCUsers(HCMatchEngIds,lstUser);
           }                     
          
          
          }
          }         
            Sharing_Security_Controller.shareHCPosHCUsers(HCPositionIds,lstUser);
            Sharing_Security_Controller.shareHCAccHCUsers(HCAccountIds,lstUser);
            }
           }
           }
           }      
          }
          } 
          
      @future
      public static void shareCampSessions(Set<Id> CampSessionIds)
      {
          List<Campaign_Session__c> lstCampSessions=new List<Campaign_Session__c> ();
          set<Id> HCAccountIds =  new set<Id>();
          set<Id> PartnerAccountIds =  new set<Id>();
          set<Id> ParentAccountIds =  new set<Id>();
          set<Id> HCContactIds =  new set<Id>();
          list<Account> lstAccounts=new list<Account>();
          list<Account> lstChildrenAccounts=new list<Account>();
          list<Contact> lstHCContacts=new list<Contact>();
          list<User> lstUser=new list<User>();
          if(CampSessionIds!=null)
          {
          lstCampSessions =[Select c.SystemModstamp, c.Spaces_Filled__c, c.Campaign__r.Partner_Name__c,c.Spaces_Available__c, c.Session_Start__c, c.Session_Label__c, c.Session_End__c, c.OwnerId, c.Name, c.Maximum_Capacity__c, c.Id, c.Host_Company_Name__c, c.CurrencyIsoCode, c.Campaign_isActive__c, c.Campaign__c, c.Campaign_Type__c, c.Campaign_StartDate__c, c.Campaign_Name__c, c.Campaign_EndDate__c, c.Allocated_Quantity__c From Campaign_Session__c c where c.Id in :CampSessionIds];
          if(lstCampSessions!=null && lstCampSessions.size()>0)
          {
            for(Campaign_Session__c objCampSession : lstCampSessions)
            {
                If(objCampSession.Host_Company_Name__c!=null)
                {
                    HCAccountIds.add(objCampSession.Host_Company_Name__c);
                }
                If(objCampSession.Campaign__r.Partner_Name__c!=null)
                {
                    PartnerAccountIds.add(objCampSession.Campaign__r.Partner_Name__c);
                }
            }
            if(HCAccountIds!=null)
            {
           lstAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.Id in :HCAccountIds];
           system.debug('***lstAccounts******'+lstAccounts);
           if(lstAccounts!=null && lstAccounts.size()>0)
           {
            For (Account a: lstAccounts)
            {
                if(a.ParentId == Null)
                ParentAccountIds.add(a.Id);
                if(a.ParentId != Null)
                HCAccountIds.add(a.ParentId);
            }
           }
               system.debug('***ParentAccountIds******'+ParentAccountIds);
           if(ParentAccountIds!=null) 
           {   
           lstChildrenAccounts= [Select a.Type, a.Status__c, a.RecordTypeId, a.ParentId, a.Intrax_Id__c, a.Id From Account a WHERE a.ParentId in :ParentAccountIds];
             system.debug('***lstChildrenAccounts******'+lstChildrenAccounts);
            For(Account cacc: lstChildrenAccounts)
           {           
            HCAccountIds.add(cacc.Id);
           }
           }
           if(PartnerAccountIds!=null)
           {
            for(Id accid :PartnerAccountIds)
            {
                  HCAccountIds.add(accid);
            }
           }
            system.debug('***HCAccountIds -2******'+HCAccountIds);
           lstHCContacts = [Select c.Id, c.FirstName, c.AccountId From Contact c where c.AccountId in :HCAccountIds];
             system.debug('***lstHCContacts******'+lstHCContacts);
           if(lstHCContacts!=null && lstHCContacts.size()>0)
           {
           For(Contact con: lstHCContacts)  
           HCContactIds.add(con.Id);  
            system.debug('***HCContactIds******'+HCContactIds);
                   
           If(HCContactIds!=null)
            lstUser = [Select u.Type__c,u.UserRole.DeveloperName, u.Profile.Name, u.ProfileId, u.IsActive, u.Intrax_Id__c, u.Id,u.UserRole.ParentRoleId, u.Contact.ManualHCPortalUserShareExists__c, u.ContactId From User u where u.ContactId in :HCContactIds];
          system.debug('***lstUser******'+lstUser);
          if(lstUser!=null && lstUser.size()>0)
          {
             Sharing_Security_Controller.shareHCCampSessionHCUsers(CampSessionIds,lstUser);
          }
          
          }
        }
            }
            
          }
          }
            
   
   @future
   public static void shareWTParticipant(Set<Id> WTAppIds)
    {
    List<Applicant_Info__c> lstApplicants=new List<Applicant_Info__c> ();
    if(WTAppIds!=null)
    {
    lstApplicants =[Select a.OwnerId, a.Lives_With__c,a.Partner_Intrax_Id__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Language_2__c, a.Id, a.Home_Street_1__c, a.Home_State__c, a.Email__c, a.CreatedBy__c, a.CreatedById, a.Country_of_Birth__c, a.Country__c, a.Arrival_Time__c, a.Application_Level__c, a.Academic_Years_Completed__c,a.Engagement__c From Applicant_Info__c a where a.ID IN:WTAppIds];
    If(lstApplicants!=null && lstApplicants.size()>0)
    {
    set<Id> EngIds = new set<Id>(); 
    set<Id> EngAccIds = new set<Id>();  
    set<Id> MatPosIds = new set<Id>();  
    set<Id> MatPosAccIds = new set<Id>();
    For(Applicant_Info__c ap:lstApplicants)
    {
    EngIds.add(ap.Engagement__c);
    }
    if(EngIds!=null)
    {           
    List<Engagement__c> lstEng = [select id, Orientation_Date__c,Terms_Accepted_Date__c,status__c,Account_Id__c  from Engagement__c where id =:EngIds];
    if(lstEng!=null && lstEng.size()>0)
    {
        For(Engagement__c eng : lstEng)
        {
            EngAccIds.add(eng.Account_Id__c);
        }
    }
    
     List<Match__c> lstMatches = [SELECT Id,  Status__c,Engagement__r.Placement_Status__c, Engagement__r.Id,Position_Name__c,Position_Name__r.Host_Company_Id__c, Engagement__c FROM Match__c WHERE Engagement__c in :EngIds];
     if(lstMatches!=null && lstMatches.size()>0)
     {
        For(Match__c mat:lstMatches)
        {
            MatPosIds.add(mat.Position_Name__c);
            MatPosAccIds.add(mat.Position_Name__r.Host_Company_Id__c);
        }
     } 
     For(Applicant_Info__c ap:lstApplicants)
    {
     Sharing_Security_Controller.shareApplicantRecord(ap.Id, ap.CreatedBy__c);
     Sharing_Security_Controller.shareEngagements(EngIds, ap.CreatedBy__c);
     Sharing_Security_Controller.shareAccount(EngAccIds, ap.CreatedBy__c); 
     if(MatPosIds!=null)
     {                          
     Sharing_Security_Controller.shareEngMatchPositionApplicant(MatPosIds, ap.CreatedBy__c);
     Sharing_Security_Controller.shareAccount(MatPosAccIds, ap.CreatedBy__c);
     }                      
    } 
    }          
    }
    }
    }
    
      /**
    * Description   :   This method shares Campaign with campaign Partner
    * @args         :   Map of Campaigns Ids and PartnerIds
    * @return       :   void
    //  */  
  @future
 public static void shareCampaign (Map<Id,Id> MapCampaignIds) {
     
    system.debug('*****MapCampaignIds******'+MapCampaignIds);
    Map<Id,List<User>> MapCampPartnerUser = new Map<Id,List<User>>();
    Set<Id> campIds = MapCampaignIds.keySet() ;
    system.debug('****campIds******'+campIds);
    List<User> lstUser = new list<User>();
    For(Id camp:campIds)
    {
     List<Account> lstAccount = [Select Intrax_Id__c From Account where Id = :MapCampaignIds.get(camp)];
     for(Account acc:lstAccount)
     {
     lstUser = [Select Id from User where Intrax_Id__c =: acc.Intrax_Id__c];
     MapCampPartnerUser.put(camp,lstUser);
     }
    }
    if(MapCampPartnerUser!=null)
    {
        Set<Id> campSessionIds = new set<Id>();
          List<Campaign_Session__c> lstCampSessions =[Select c.SystemModstamp, c.Spaces_Filled__c, c.Campaign__r.Partner_Name__c,c.Spaces_Available__c, c.Session_Start__c, c.Session_Label__c, c.Session_End__c, c.OwnerId, c.Name, c.Maximum_Capacity__c, c.Id, c.Host_Company_Name__c, c.CurrencyIsoCode, c.Campaign_isActive__c, c.Campaign__c, c.Campaign_Type__c, c.Campaign_StartDate__c, c.Campaign_Name__c, c.Campaign_EndDate__c, c.Allocated_Quantity__c From Campaign_Session__c c where c.Campaign__c in :campIds];
                For(Campaign_Session__c campSession : lstCampSessions)
                {
                    campSessionIds.add(campSession.Id);
                }
        Sharing_Security_Controller.shareCampPartnerUsers(MapCampPartnerUser); 
        
        if(campSessionIds!=null)       
        Sharing_Security_Controller.shareHCCampSessionHCUsers(campSessionIds,lstUser);
    }
 } 
 // Ownership change - Manual sharing code
 
  public static void persistSharing(sObject sobj, String flag, set<Id> record_id){
 	 
    list<Manual_Sharing_Info__c> ManualShareInfolst = new list<Manual_Sharing_Info__c>();
    list<Sobject> SharetoPersist = new list<Sobject>();
   
 	String Name_Share;
    String sOQLQuery;
   
    if(sobj.getsObjectType()==Applicant_Info__share.sObjectType)
    {
    	Name_Share='Applicant_Info__Share';  
    }
 
    
  if(flag=='before'){
  
  //for(Id id:record_id ) {
   /*if(sobj.getsObjectType()==Engagement__share.sObjectType || sobj.getsObjectType()==Applicant_Info__Share.sObjectType ||  sobj.getsObjectType()==Assessment__share.sObjectType ||  
      sobj.getsObjectType()==Campaign_Session__share.sObjectType || sobj.getsObjectType()==Pay_Event__share.sObjectType)*/
    if(sobj.getsObjectType()==Applicant_Info__Share.sObjectType )
      { 
 	   sOQLQuery = 'SELECT UserOrGroupId, RowCause, ParentId, LastModifiedDate, LastModifiedById, IsDeleted, AccessLevel FROM '+ Name_Share
                                                + ' WHERE ParentId IN : record_id  AND'
                                                + ' RowCause = \'' + 'Manual'+ '\'' ; 
       System.debug('****value in sOQLQuery ' + sOQLQuery);
     }
  
    
            //Fetching record from the database
    
      SharetoPersist = Database.query(sOQLQuery);        
      if(SharetoPersist != NULL && SharetoPersist.size()>0)
       {
           for(Sobject sobjresult :SharetoPersist)
             {
               Manual_Sharing_Info__c newmShare = new Manual_Sharing_Info__c();
               //newmShare.Object_ID__c = id;
                if(sobjresult.getsObjectType()==Applicant_Info__Share.sObjectType)
           	    {
                 newmShare.Object_ID__c = (String)sobjresult.get('ParentId');
           	    } 
               newmShare.User_ID__c = (String)sobjresult.get('UserOrGroupId');
               ManualShareInfolst.add(newmShare);
               system.debug('inside share object');
              }
        }       
    //}
      if (ManualShareInfolst != NULL && ManualShareInfolst.size()>0)
      {
        insert ManualShareInfolst;
      }
                 
   }
    if(flag=='after')
    {
    	list<SObject> allManualAppShare = new list<SObject>();
        list<Manual_Sharing_Info__c> selMShareSQL = [SELECT Object_ID__c, User_ID__c FROM Manual_Sharing_Info__c WHERE Object_ID__c IN : record_id];
         if (selMShareSQL != NULL && selMShareSQL.size()>0)
          {
             for (Manual_Sharing_Info__c SingleShr : selMShareSQL)
               {
               	SObject single_shr;
               
               if(sobj.getsObjectType()==Applicant_Info__Share.sObjectType)
           	    {
                single_shr =new Applicant_Info__Share();
                single_shr.put('ParentId' ,SingleShr.Object_ID__c);
                single_shr.put('AccessLevel' , 'Edit');
           	    }
           	   
               single_shr.put('UserOrGroupId' ,SingleShr.User_ID__c);
             
               allManualAppShare.add(single_shr);
              }
           }
           if(allManualAppShare != NULL && allManualAppShare.size()>0)
           {
           	 
             if(sobj.getsObjectType()==Applicant_Info__Share.sObjectType)
           	 {
           	 	 List<Applicant_Info__Share> appShareList = (List<Applicant_Info__Share>)allManualAppShare;
                 insert appShareList;
           	 }
           	
              delete selMShareSQL;
              system.debug('inserting & deleting');
            }
        }
   }
   
  public static void persistSharingWithOwner(sObject sobj, String flag, set<Id> record_id){
 	System.debug('Persist Sharing with owner***');
    list<Manual_Sharing_Info__c> ManualShareInfolst = new list<Manual_Sharing_Info__c>();
    list<Sobject> SharetoPersist = new list<Sobject>();
   
    String ObjectName;
 	String Name_Share;
    String sOQLQuery;
    if(sobj.getsObjectType()==Engagement__share.sObjectType)
    {
    	Name_Share='Engagement__Share';  
        ObjectName='Engagement__c';
    }
    else if(sobj.getsObjectType()==Applicant_Info__share.sObjectType)
    {
    	Name_Share='Applicant_Info__Share';  
        ObjectName='Applicant_Info__c';
    }
    else if(sobj.getsObjectType()==Position__share.sObjectType)
    {
    	Name_Share='Position__Share';  
        ObjectName='Position__c';
    }
    else if(sobj.getsObjectType()==Assessment__share.sObjectType)
    {
    	Name_Share='Assessment__Share';
        ObjectName='Assessment__c';
    }
    else if(sobj.getsObjectType()==Campaign_Session__share.sObjectType)
    {
    	Name_Share='Campaign_Session__Share';  
       ObjectName='Campaign_Session__c';
    }
     else if(sobj.getsObjectType()==Pay_Event__share.sObjectType)
    {
    	Name_Share='Pay_Event__Share';  
        ObjectName='Pay_Event__c';
    }
   
    
  if(flag=='before'){
   
   if(sobj.getsObjectType()==Engagement__share.sObjectType || sobj.getsObjectType()==Applicant_Info__Share.sObjectType ||  sobj.getsObjectType()==Assessment__share.sObjectType ||  
      sobj.getsObjectType()==Campaign_Session__share.sObjectType || sobj.getsObjectType()==Position__share.sObjectType || sobj.getsObjectType()==Pay_Event__share.sObjectType){ 
 	   sOQLQuery = 'SELECT UserOrGroupId, RowCause, ParentId, LastModifiedDate, LastModifiedById, IsDeleted, AccessLevel FROM '+ Name_Share
                                                + ' WHERE ParentId IN : record_id  AND '
                                                + ' RowCause = \'' + 'Manual'+ '\'' ; 
     System.debug('****value in sOQLQuery ' + sOQLQuery);
    }
    if(sobj.getsObjectType()==CaseShare.sObjectType ){ 
 	   sOQLQuery = 'SELECT UserOrGroupId, RowCause, CaseId, LastModifiedDate, LastModifiedById, IsDeleted,  CaseAccessLevel FROM CaseShare'
                                                + ' WHERE CaseId IN : record_id   AND '
                                                + ' RowCause = \'' + 'Manual'+ '\'' ; 
     System.debug('****value in sOQLQuery ' + sOQLQuery);
      ObjectName='Case';
    } 
    else if(sobj.getsObjectType()==CampaignShare.sObjectType ){ 
 	   sOQLQuery = 'SELECT UserOrGroupId, RowCause, CampaignId, LastModifiedDate, LastModifiedById, IsDeleted,  CampaignAccessLevel FROM CampaignShare'
                                                + ' WHERE CampaignId IN : record_id  AND '
                                                + ' RowCause = \'' + 'Manual'+ '\'' ; 
     System.debug('****value in sOQLQuery ' + sOQLQuery);
       ObjectName='Campaign';
    }
    else if(sobj.getsObjectType()==LeadShare.sObjectType ){ 
 	   sOQLQuery = 'SELECT UserOrGroupId, RowCause, LeadId, LastModifiedDate, LastModifiedById, IsDeleted,  LeadAccessLevel FROM LeadShare'
                                                + ' WHERE LeadId IN : record_id  AND '
                                                + ' RowCause = \'' + 'Manual'+ '\'' ; 
      System.debug('****value in sOQLQuery ' + sOQLQuery);
       ObjectName='Lead';
    }
    else if(sobj.getsObjectType()==OpportunityShare.sObjectType ){ 
 	   sOQLQuery = 'SELECT UserOrGroupId, RowCause, OpportunityId, LastModifiedDate, LastModifiedById, IsDeleted,  OpportunityAccessLevel FROM OpportunityShare'
                                                + ' WHERE OpportunityId IN : record_id  AND '
                                                + ' RowCause = \'' + 'Manual'+ '\'' ; 
     System.debug('****value in sOQLQuery ' + sOQLQuery);
     ObjectName='Opportunity';
    } 
    else if(sobj.getsObjectType()==AccountShare.sObjectType ){ 
 	   sOQLQuery = 'SELECT UserOrGroupId, RowCause, AccountId, LastModifiedDate, LastModifiedById, IsDeleted, OpportunityAccessLevel,AccountAccessLevel FROM AccountShare'
                                                + ' WHERE AccountId IN : record_id  AND '
                                                + ' RowCause = \'' + 'Manual'+ '\'' ; 
     System.debug('****value in sOQLQuery ' + sOQLQuery);
     ObjectName='Account';
    }
    
      SharetoPersist = Database.query(sOQLQuery);        
      if(SharetoPersist != NULL && SharetoPersist.size()>0)
       {
           for(Sobject sobj_result:SharetoPersist)
             {
               Manual_Sharing_Info__c newmShare = new Manual_Sharing_Info__c();
            
               if(sobj_result.getsObjectType()==Engagement__share.sObjectType || sobj_result.getsObjectType()==Applicant_Info__Share.sObjectType ||
                  sobj_result.getsObjectType()==Assessment__share.sObjectType || sobj_result.getsObjectType()==Campaign_Session__share.sObjectType || 
                  sobj_result.getsObjectType()==Position__share.sObjectType || sobj_result.getsObjectType()==Pay_Event__share.sObjectType )
           	    {
                 newmShare.Object_ID__c = (String)sobj_result.get('ParentId');
           	    }
                else if(sobj_result.getsObjectType()==CaseShare.sObjectType)
           	    {
                 newmShare.Object_ID__c = (String)sobj_result.get('CaseId');
           	    } 
                else if(sobj_result.getsObjectType()==CampaignShare.sObjectType)
           	    {
                newmShare.Object_ID__c = (String)sobj_result.get('CampaignId');
           	    }
                else if(sobj_result.getsObjectType()==LeadShare.sObjectType)
           	    {
                newmShare.Object_ID__c = (String)sobj_result.get('LeadId');
           	    }
                else if(sobj_result.getsObjectType()==OpportunityShare.sObjectType)
           	    {
                newmShare.Object_ID__c = (String)sobj_result.get('OpportunityId');
           	    }
           	    else if(sobj_result.getsObjectType()==AccountShare.sObjectType)
           	    {
                newmShare.Object_ID__c = (String)sobj_result.get('AccountId');
           	    }
               newmShare.User_ID__c = (String)sobj_result.get('UserOrGroupId');
               ManualShareInfolst.add(newmShare);
               system.debug('inside share object');
              }
          }       

     
      
     String OwnerPersist_Qry ;
     if(sobj.getsObjectType()==Engagement__share.sObjectType || sobj.getsObjectType()==Assessment__share.sObjectType || sobj.getsObjectType()==Campaign_Session__share.sObjectType || 
        sobj.getsObjectType()==Pay_Event__share.sObjectType || sobj.getsObjectType()==Position__share.sObjectType || sobj.getsObjectType()==Caseshare.sObjectType || 
         sobj.getsObjectType()==Applicant_Info__share.sObjectType)
     {
     
     OwnerPersist_Qry = 'Select OwnerId, Owner.Profile.Name from '+ ObjectName + ' WHERE Id IN :record_id and Owner.Type=\''+'User'+'\'';  
     List<Sobject> qryresult =  Database.query(OwnerPersist_Qry);
     if(qryresult != NULL && qryresult.size()>0)
     {
     Map<Id, Sobject> userProfile  = new Map<Id, Sobject>(qryresult);   
      
     if(userProfile != NULL && userProfile.size()>0)
     {
      for(Id s_old:record_id){
        SObject OwnerPersist=userProfile.get(s_old);
        //system.debug('sobjecttype'+OwnerPersist.getSObject('Owner'));
       // if(OwnerPersist.getSObject('Owner').getSobjecttype()==User.sObjecttype)
         if(OwnerPersist != null){
           System.debug('Owner is User***');
           String pName= (String)OwnerPersist.getSobject('Owner').getSobject('Profile').get('Name');
           if(pName=='OCPM PT' || pName=='OCPM Agent Portal' || pName=='OCPM HC' || pName=='OCPM University')
      	   {
        	system.debug('Old owner is OCPM PT or AgentPortal or HC or University'); 
        	Manual_Sharing_Info__c newmShare = new Manual_Sharing_Info__c();
        	newmShare.Object_ID__c = s_old;
        	newmShare.User_ID__c = (String) OwnerPersist.get('OwnerId');
        	ManualShareInfolst.add(newmShare);
          }
          else
          {
           system.debug('Old owner is  not OCPM PT or AgentPortal or HC or University');    
          }
         }
         else{
          System.debug('Owner is Queue***');  
         }
        } 
       }
      }
     }  
     if (ManualShareInfolst != NULL && ManualShareInfolst.size()>0)
     {
       insert ManualShareInfolst;
     }
    }
    if(flag=='after')
    {
    	list<SObject> allManualAppShare = new list<SObject>();
        list<Manual_Sharing_Info__c> selMShareSQL = [SELECT Object_ID__c, User_ID__c FROM Manual_Sharing_Info__c WHERE Object_ID__c IN : record_id];
        if (selMShareSQL != NULL && selMShareSQL.size()>0)
          {
             for (Manual_Sharing_Info__c SingleShr : selMShareSQL)
               {
               	SObject single_shr;
               	if(sobj.getsObjectType()==Engagement__share.sObjectType)
           	    {
                ObjectName='Engagement__c';
                single_shr =new Engagement__share();
                single_shr.put('ParentId' ,SingleShr.Object_ID__c);
                single_shr.put('AccessLevel' , 'Edit');
           	    }
           	    else if(sobj.getsObjectType()==Applicant_Info__Share.sObjectType)
           	    {
                ObjectName='Applicant_Info__c';
                single_shr =new Applicant_Info__Share();
                single_shr.put('ParentId' ,SingleShr.Object_ID__c);
                single_shr.put('AccessLevel' , 'Edit');
           	    }
           	    else if(sobj.getsObjectType()==Position__Share.sObjectType)
           	    {
                ObjectName='Position__c';
                single_shr =new Position__Share();
                single_shr.put('ParentId' ,SingleShr.Object_ID__c);
                single_shr.put('AccessLevel' , 'Edit');
           	    }
           	    else if(sobj.getsObjectType()==Assessment__share.sObjectType)
           	    {
                ObjectName='Assessment__c';
                single_shr =new Assessment__share();
                single_shr.put('ParentId' ,SingleShr.Object_ID__c);
                single_shr.put('AccessLevel' , 'Edit');
           	    } 
                else if(sobj.getsObjectType()==Campaign_Session__share.sObjectType)
           	    {
                ObjectName='Campaign_Session__c';
                single_shr =new Campaign_Session__share();
                single_shr.put('ParentId' ,SingleShr.Object_ID__c);
                single_shr.put('AccessLevel' , 'Edit');
           	    } 
                else if(sobj.getsObjectType()==Pay_Event__share.sObjectType)
           	    {
                ObjectName='Pay_Event__c';
                single_shr =new Pay_Event__share();
                single_shr.put('ParentId' ,SingleShr.Object_ID__c);
                single_shr.put('AccessLevel' , 'Edit');
           	    } 
                else if(sobj.getsObjectType()==CaseShare.sObjectType)
           	    {
                ObjectName='Case';
                single_shr =new CaseShare();
                single_shr.put('CaseId' ,SingleShr.Object_ID__c);
                single_shr.put('CaseAccessLevel' , 'Edit');
           	    } 
                else if(sobj.getsObjectType()==CampaignShare.sObjectType)
           	    {
                ObjectName='Campaign';
                single_shr =new CampaignShare();
                single_shr.put('CampaignId' ,SingleShr.Object_ID__c);
                single_shr.put('CampaignAccessLevel' , 'Edit');
           	    }
                else if(sobj.getsObjectType()==LeadShare.sObjectType)
           	    {
                ObjectName='Lead';
                single_shr =new LeadShare();
                single_shr.put('LeadId' ,SingleShr.Object_ID__c);
                single_shr.put('LeadAccessLevel' , 'Edit');
           	    }
                else if(sobj.getsObjectType()==OpportunityShare.sObjectType)
           	    {
                ObjectName='Opportunity';
                single_shr =new OpportunityShare();
                single_shr.put('OpportunityId' ,SingleShr.Object_ID__c);
                single_shr.put('OpportunityAccessLevel' , 'Edit');
           	    }
           	    else if(sobj.getsObjectType()==AccountShare.sObjectType)
           	    {
                ObjectName='Account';
                single_shr =new AccountShare();
                single_shr.put('AccountId' ,SingleShr.Object_ID__c);
                single_shr.put('AccountAccessLevel' , 'Edit');
                single_shr.put('OpportunityAccessLevel' , 'Edit');
           	    }
               single_shr.put('UserOrGroupId' ,SingleShr.User_ID__c);
             
                 allManualAppShare.add(single_shr);
              }
           }
         if(allManualAppShare != NULL && allManualAppShare.size()>0)
         {
           String OwnerCheck;
          if(sobj.getsObjectType()==OpportunityShare.sObjectType || sobj.getsObjectType()== CampaignShare.sObjectType || sobj.getsObjectType()== AccountShare.sObjectType){  
       
            OwnerCheck  = 'Select OwnerId, Owner.Profile.Name from '+ ObjectName + ' WHERE Id IN :record_id';
           }
          else{
            OwnerCheck = 'Select OwnerId, Owner.Profile.Name from '+ ObjectName + ' WHERE Id IN :record_id and Owner.Type=\''+'User'+'\'';
           }
           
           List<Sobject> qryresult =  Database.query(Ownercheck);
           Map<Id, Sobject> usermap ;
           if(qryresult != NULL && qryresult.size()>0)
           {
          // Map<Id, Sobject> usermap  = new Map<Id, Sobject>((List<sobject>)Database.query(OwnerCheck));  
            usermap  = new Map<Id, Sobject>(qryresult); 
           }
           System.debug('map****'+usermap);
        
           if(allManualAppShare != NULL && allManualAppShare.size()>0)
           {
           	 if(sobj.getsObjectType()==Engagement__share.sObjectType)
           	 {
           	 	 List<Engagement__Share> engShareList = (List<Engagement__Share>)allManualAppShare;
                 /* for(Id s_new:record_id){
                    User u = [Select Id, Profile.Name from User where id in (select OwnerId from Engagement__c where id=:s_new)];
                     for(Integer i=0; i<engShareList.size();i++){
                         if(engShareList[i].get('UserOrGroupId')==u.Id && engShareList[i].get('ParentId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           engShareList.remove(i);                         
                         }
                     }
                 }*/
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Engagement__c gobj = (Engagement__c) usermap.get(s_new);
                    if(gobj != null) {
                     for(Integer i=0; i<engShareList.size();i++){
                         if(engShareList[i].get('UserOrGroupId')==gobj.OwnerId && engShareList[i].get('ParentId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           engShareList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert engShareList;
           	 }
           	 else if(sobj.getsObjectType()==Applicant_Info__Share.sObjectType)
           	 {
           	 	 List<Applicant_Info__Share> appShareList = (List<Applicant_Info__Share>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Applicant_Info__c gobj = (Applicant_Info__c) usermap.get(s_new);
                    if(gobj != null) {
                     for(Integer i=0; i<appShareList.size();i++){
                         if(appShareList[i].get('UserOrGroupId')==gobj.OwnerId && appShareList[i].get('ParentId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           appShareList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert appShareList;
           	 }
           	 else if(sobj.getsObjectType()==Position__Share.sObjectType)
           	 {
           	 	 List<Position__Share> posShareList = (List<Position__Share>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Position__c gobj = (Position__c) usermap.get(s_new);
                    if(gobj != null) {
                     for(Integer i=0; i<posShareList.size();i++){
                         if(posShareList[i].get('UserOrGroupId')==gobj.OwnerId && posShareList[i].get('ParentId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           posShareList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert posShareList;
           	 }
           	 else if(sobj.getsObjectType()==Assessment__share.sObjectType)
           	 {
           	 	 List<Assessment__Share> assShareList = (List<Assessment__Share>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Assessment__c gobj = (Assessment__c) usermap.get(s_new);
                     if(gobj != null) {
                     for(Integer i=0; i<assShareList.size();i++){
                         if(assShareList[i].get('UserOrGroupId')==gobj.OwnerId && assShareList[i].get('ParentId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           assShareList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert assShareList;
           	 } 
           	 else if(sobj.getsObjectType()==Campaign_Session__share.sObjectType)
           	 {
           	 	 List<Campaign_Session__Share> campShareList = (List<Campaign_Session__Share>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Campaign_Session__c gobj = (Campaign_Session__c) usermap.get(s_new);
                     if(gobj!=null) {
                     for(Integer i=0; i<campShareList.size();i++){
                         if(campShareList[i].get('UserOrGroupId')==gobj.OwnerId && campShareList[i].get('ParentId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           campShareList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert campShareList;
           	 }
             else if(sobj.getsObjectType()==Pay_Event__share.sObjectType)
           	 {
           	 	 List<Pay_Event__Share> payeventList = (List<Pay_Event__Share>)allManualAppShare;
                   
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Pay_Event__c gobj = (Pay_Event__c) usermap.get(s_new);
                     if(gobj != null) {
                     for(Integer i=0; i<payeventList.size();i++){
                         if(payeventList[i].get('UserOrGroupId')==gobj.OwnerId && payeventList[i].get('ParentId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           payeventList.remove(i);                         
                        }
                      }
                    }
                  }
                }
               insert payeventList;
           	 }
             else if(sobj.getsObjectType()==Caseshare.sObjectType)
           	 {
           	 	 List<Caseshare> caseList = (List<Caseshare>)allManualAppShare;
                    
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                    Case c = (Case)usermap.get(s_new);
                     system.debug('Case**'+c);
                     if(c!=null) {
                      for(Integer i=0; i<caseList.size();i++){
                         if(caseList[i].get('UserOrGroupId')==c.OwnerId && caseList[i].get('CaseId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           caseList.remove(i);                         
                         }
                       }
                      }
                    }
                 }
                insert caseList;
           	 }
             else if(sobj.getsObjectType()==Campaignshare.sObjectType)
           	 {
           	 	 List<Campaignshare> camList = (List<Campaignshare>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Campaign gobj = (Campaign) usermap.get(s_new);
                     if(gobj.Owner.getSobjectType()==User.sObjecttype) {
                     for(Integer i=0; i<camList.size();i++){
                         if(camList[i].get('UserOrGroupId')==gobj.OwnerId && camList[i].get('CampaignId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           camList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert camList;
           	 }
             else if(sobj.getsObjectType()==Leadshare.sObjectType)
           	 {
           	 	 List<Leadshare> LeadList = (List<Leadshare>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Lead gobj = (Lead) usermap.get(s_new);
                     if(gobj != null) {
                     for(Integer i=0; i<LeadList.size();i++){
                         if(LeadList[i].get('UserOrGroupId')==gobj.OwnerId && LeadList[i].get('LeadId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           LeadList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert LeadList;
           	 }
             else if(sobj.getsObjectType()==Opportunityshare.sObjectType)
           	 {
           	 	 List<Opportunityshare> oppList = (List<Opportunityshare>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Opportunity gobj = (Opportunity) usermap.get(s_new);
                     if(gobj.Owner.getSobjectType()==User.sObjecttype) {
                     for(Integer i=0; i<oppList.size();i++){
                         if(oppList[i].get('UserOrGroupId')==gobj.OwnerId && oppList[i].get('OpportunityId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           oppList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert oppList;
           	 }
           	 else if(sobj.getsObjectType()==Accountshare.sObjectType)
           	 {
           	 	 List<Accountshare> AccList = (List<Accountshare>)allManualAppShare;
                 if(usermap != NULL && usermap.size()>0)
                 {
                 for(Id s_new:record_id){
                     Account gobj = (Account) usermap.get(s_new);
                     if(gobj.Owner.getSobjectType()==User.sObjecttype) {
                     for(Integer i=0; i<AccList.size();i++){
                         if(AccList[i].get('UserOrGroupId')==gobj.OwnerId && AccList[i].get('AccountId')==s_new){
                           System.debug('Manual Sharing not needed - Since Its Owner now') ;
                           AccList.remove(i);                         
                        }
                      }
                    }
                  }
                }
                 insert AccList;
           	 }
              delete selMShareSQL;
              system.debug('inserting & deleting');
           }
        }
      }
   }
 
 }