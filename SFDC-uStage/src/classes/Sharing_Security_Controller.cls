public without sharing class Sharing_Security_Controller {

 final Applicant_Info__c appInfo;
 public static String app {get; set
        {
            app = value;
        }
    }
public Sharing_Security_Controller(ApexPages.StandardController sc){
  appInfo = (Applicant_Info__c)sc.getRecord(); 
}
 /**
    * Description   :   This method shares applicant with UserId passed 
    * Scenarios   :   1. Match's Position Opportunity Applicant shared with Match's Enagagement's PartnerId
    * @args         :   ApplicantId, UserId
    * @return       :   void
    */
public static void shareApplicantRecord(Id aid, Id Uid){
  Applicant_Info__share ais = new Applicant_Info__share();

  ais.ParentId = aid;
  ais.UserOrGroupId = Uid;
  ais.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(ais,false);
}

public static void shareApplicantRecord(List<Applicant_Info__c> lstAppInfo,Id Uid){
  
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  For(Applicant_Info__c appInfo:lstAppInfo)
  {
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = appInfo.Id;
  appShare.UserOrGroupId = Uid;
  appShare.AccessLevel = 'Edit';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public static void shareROApplicantRecord(List<Applicant_Info__c> lstAppInfo,Id Uid){
  
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  For(Applicant_Info__c appInfo:lstAppInfo)
  {
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = appInfo.Id;
  appShare.UserOrGroupId = Uid;
  appShare.AccessLevel = 'Read';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public static void shareROEngMatchPositionApplicant(Set<Id> posIds,Id UserId){
  
  List<Position__Share> lstPosShare = new List<Position__Share>();
  
  For(Id posId:posIds)
  {
  Position__Share   posShare = new Position__Share();
  posShare.ParentId = posId;
  posShare.UserOrGroupId =UserId;
  //posShare.AccessLevel = 'Read';
  posShare.AccessLevel = 'Edit';
  lstPosShare.add(posShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstPosShare,false);
  
  
}
public static void shareROPositionRecord(Id PosId,List<User> lstUsr){
  List<Position__Share>  lstPosShare = new List<Position__Share>();
  system.debug('****PosId*****'+PosId);
  //Position__c pos = [select Id,createdById from Position__c where id = :PosId];
  For(User usr: lstUsr)
  {
  Position__Share  posShare = new Position__Share();
  posShare.ParentId = PosId;
  posShare.UserOrGroupId = usr.Id;
  //posShare.AccessLevel = 'Read';
  posShare.AccessLevel = 'Edit';
  lstPosShare.add(posShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstPosShare,false);
  
}
public static void shareROApplicantRecord(Id AppInfoId,List<User> lstUser){
  
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  For(User user:lstUser)
  {
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = AppInfoId;
  appShare.UserOrGroupId = user.Id;
  appShare.AccessLevel = 'Read';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public static void shareApplicantRecord(Id AppInfoId,List<User> lstUser){
  
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  For(User user:lstUser)
  {
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = AppInfoId;
  appShare.UserOrGroupId = user.Id;
  appShare.AccessLevel = 'Edit';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public static void shareAccount(Set<Id> accIds,Id uId){
  List<AccountShare>  lstAccShare = new List<AccountShare>();
  For(Id accId :accIds)
  {
  AccountShare accShare=new AccountShare();
  accShare.AccountId = accId;
  accShare.UserOrGroupId = uId;
  accShare.AccountAccessLevel = 'Edit';
  accShare.OpportunityAccessLevel = 'Edit';
  lstAccShare.add(accShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstAccShare,false);
    
  //System.debug(sr.getErrors());
}
public static void sharePartnerRoleUp(Id AppInfoId,Set<Id> userIds){
  
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  For(Id usrId :userIds)
  {
    Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, g.DoesIncludeBosses, g.DeveloperName, g.CreatedDate, g.CreatedById From Group g where g.RelatedId = :usrId and g.type='Role'];
  
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = AppInfoId;
  appShare.UserOrGroupId = grp.Id;
  appShare.AccessLevel = 'Edit';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public PageReference shareRecord(){
  Applicant_Info__share ais = new Applicant_Info__share();
  
  Applicant_Info__c ai = [select createdBy__c from Applicant_Info__c where id = :appInfo.Id];
  ais.ParentId = appInfo.Id;
  ais.UserOrGroupId = ai.createdBy__c;
  ais.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(ais,false);
  
  PageReference pageRef = new ApexPages.standardController(appInfo).View(); 
    pageRef.setRedirect(true);
    return pageRef; 
}
public static void shareEngRecordToCRs(Id EngId){
  Engagement__Share  engShare = new Engagement__Share ();
  system.debug('****EngId*****'+EngId);
   Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.developerName ='Field_Staff_CR_Users' and g.type='Regular'];
   engShare.ParentId = EngId;
  engShare.UserOrGroupId = grp.Id;
  engShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(engShare,false);
  
  
}
public static void shareEngAccountRecordToCRs(Id AccId){
  AccountShare  accShare = new AccountShare ();
     Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.developerName ='Field_Staff_CR_Users' and g.type='Regular'];
  accShare.AccountId = AccId;
  accShare.UserOrGroupId = grp.Id;
  accShare.AccountAccessLevel = 'Edit';
  accShare.OpportunityAccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(accShare,false);
  
  
}
/**
    * Description   :   This method shares position with UserId passed 
    * Scenarios   :   1. Match's Position Shared with Match's Position's Account's Applicant's CreatedBy
              2. Match's Position Shared with Match's Enagagement's PartnerId
              3. Match's Position Shared with Match's Enagagement's Applicant CreatedBy
                4. Match's Position Shared with Match's Validator's Contact User CreatedBy
            
    * @args         :   Position, UserId
    * @return       :   void
    */
public static void sharePositionRecord(Id PosId,Id UserId){
  Position__Share  posShare = new Position__Share();
  system.debug('****PosId*****'+PosId);
  //Position__c pos = [select Id,createdById from Position__c where id = :PosId];
  posShare.ParentId = PosId;
  posShare.UserOrGroupId = UserId;
  posShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(posShare,false);
  
}
public static void sharePositionRecord(Id PosId,List<User> lstUsr){
  List<Position__Share>  lstPosShare = new List<Position__Share>();
  system.debug('****PosId*****'+PosId);
  //Position__c pos = [select Id,createdById from Position__c where id = :PosId];
  For(User usr: lstUsr)
  {
  Position__Share  posShare = new Position__Share();
  posShare.ParentId = PosId;
  posShare.UserOrGroupId = usr.Id;
  posShare.AccessLevel = 'Edit';
  lstPosShare.add(posShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstPosShare,false);
  
}
public static void sharePositionAccountRecord(Id AccId,List<User> lstUsr){
  List<AccountShare>  lstAccShare = new List<AccountShare>();
  system.debug('****AccId*****'+AccId);
  //Position__c pos = [select Id,createdById from Position__c where id = :PosId];
  For(User usr: lstUsr)
  {
  AccountShare  accShare = new AccountShare();
  accShare.UserOrGroupId = usr.Id;
  accShare.AccountId = accId;
  accShare.AccountAccessLevel = 'Edit';
  accShare.OpportunityAccessLevel = 'Edit';  
  lstAccShare.add(accShare);
  }
  system.debug('****lstAccShare*****'+lstAccShare);
  List<Database.SaveResult> sr = Database.insert(lstAccShare,false);

}
public static void shareEngRecord(Id EngId,Id UserId){
  Engagement__Share  engShare = new Engagement__Share ();
  system.debug('****EngId*****'+EngId);
  //Engagement__c eng = [select Id,createdById from Engagement__c where id = :EngId];
  engShare.ParentId = EngId;
  engShare.UserOrGroupId = UserId;
  engShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(engShare,false);
  
  
}
public static void shareEngRecord(Id EngId,List<User> lstUser){
  List<Engagement__Share>  lstEngShare = new List<Engagement__Share>();
  system.debug('****EngId*****'+EngId);
  For(User usr: lstUser)
  {
  Engagement__Share  engShare = new Engagement__Share();
  engShare.ParentId = EngId;
  engShare.UserOrGroupId = usr.Id;
  engShare.AccessLevel = 'Edit';
  lstEngShare.add(engShare);
  }
  system.debug('****lstEngShare*****'+lstEngShare);
  List<Database.SaveResult> sr = Database.insert(lstEngShare,false);
  
}
public static void shareAccount(Id AccId,List<User> lstUser){
  List<AccountShare>  lstAccShare = new List<AccountShare>();
  system.debug('****AccId*****'+AccId);
  For(User usr: lstUser)
  {
  AccountShare  accShare = new AccountShare();
  accShare.UserOrGroupId = usr.Id;
  accShare.AccountId = accId;
  accShare.AccountAccessLevel = 'Edit';
  accShare.OpportunityAccessLevel = 'Edit';
  lstAccShare.add(accShare);
  }
  system.debug('****lstAccShare*****'+lstAccShare);
  List<Database.SaveResult> sr = Database.insert(lstAccShare,false);
  
}
public static void shareEngMatchPositionApplicant(Id posId,Id UserId){
  Position__Share  posShare = new Position__Share ();
  system.debug('****posId*****'+posId);
  //Position__c pos = [select Id,createdById from Position__c where id = :posId];
  posShare.ParentId = posId;
  posShare.UserOrGroupId = UserId;
  posShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(posShare,false);
  
  
}
public static void shareEngMatchPositionApplicant(Set<Id> posIds,Id UserId){
  
  List<Position__Share> lstPosShare = new List<Position__Share>();
  
  For(Id posId:posIds)
  {
  Position__Share   posShare = new Position__Share();
  posShare.ParentId = posId;
  posShare.UserOrGroupId =UserId;
  posShare.AccessLevel = 'Edit';
  lstPosShare.add(posShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstPosShare,false);
  
  
}
public static void shareHCPosHCUsers(Set<Id> posIds,List<User> lstUsr){
  
  List<Position__Share> lstPosShare = new List<Position__Share>();
  For(User usr:lstUsr)
  {
  For(Id posId:posIds)
  {
  Position__Share   posShare = new Position__Share();
  posShare.ParentId = posId;
  posShare.UserOrGroupId =usr.Id;
  posShare.AccessLevel = 'Edit';
  lstPosShare.add(posShare);
  }
  }
  List<Database.SaveResult> sr = Database.insert(lstPosShare,false);
  
  
}
public static void shareCampPartnerUsers(Map<Id,List<User>> MapCampPartnerUsers){

  List<CampaignShare> lstCampShare = new List<CampaignShare>();  
  Set<id> campIds = MapCampPartnerUsers.keySet() ;
  
  For(Id camp:campIds)
  {
    List<User> partnerUser = MapCampPartnerUsers.get(camp);
    system.debug('****partnerUser******'+partnerUser);
    for(User usr:partnerUser)
    {
      CampaignShare campShare = new CampaignShare();
      campShare.CampaignId = camp; 
      campShare.UserOrGroupId = usr.Id;
      campShare.CampaignAccessLevel = 'Read';  
      system.debug('****campShare******'+campShare);
      lstCampShare.add(campShare);
     }
  }
  system.debug('****lstCampShare******'+lstCampShare);
  List<Database.SaveResult> sr = Database.insert(lstCampShare,false);
  
}
public static void shareCampPartnerUsers(Map<Id,Id> MapCampPartnerUsers){

  List<CampaignShare> lstCampShare = new List<CampaignShare>();  
  Set<id> campIds = MapCampPartnerUsers.keySet() ;
  
  For(Id camp:campIds)
  {
    Id partnerUser = MapCampPartnerUsers.get(camp);
    system.debug('****partnerUser******'+partnerUser);
    CampaignShare campShare = new CampaignShare();
      campShare.CampaignId = camp; 
      campShare.UserOrGroupId = partnerUser;
      campShare.CampaignAccessLevel = 'Read';  
      system.debug('****campShare******'+campShare);
      lstCampShare.add(campShare);
     
  }
  system.debug('****lstCampShare******'+lstCampShare);
  List<Database.SaveResult> sr = Database.insert(lstCampShare,false);
  
}
public static void shareCampPartnerUsers(Set<Id> campIds, Id UserId){

  List<CampaignShare> lstCampShare = new List<CampaignShare>();  
  
  For(Id camp:campIds)
  {
        CampaignShare campShare = new CampaignShare();
      campShare.CampaignId = camp; 
      campShare.UserOrGroupId = UserId;
      campShare.CampaignAccessLevel = 'Read';  
      system.debug('****campShare******'+campShare);
      lstCampShare.add(campShare);
     
  }
  system.debug('****lstCampShare******'+lstCampShare);
  List<Database.SaveResult> sr = Database.insert(lstCampShare,false);
  
}
public static void shareHCEngHCUsers(Set<Id> engIds,List<User> lstUsr){
  
  List<Engagement__Share> lstEngShare = new List<Engagement__Share>();
  For(User usr:lstUsr)
  {
  For(Id engId:engIds)
  {
  Engagement__Share  engShare = new Engagement__Share();
  engShare.ParentId = engId;
  engShare.UserOrGroupId =usr.Id;
  engShare.AccessLevel = 'Edit';
  lstEngShare.add(engShare);
  }
  }
  List<Database.SaveResult> sr = Database.insert(lstEngShare,false);
  
  
}
public static void shareHCAccHCUsers(Set<Id> accIds,List<User> lstUsr){
  
  List<AccountShare> lstAccShare = new List<AccountShare>();
  For(User usr:lstUsr)
  {
  For(Id accId:accIds)
  {
  AccountShare accShare = new AccountShare();
  accShare.AccountId = accId;
  accShare.UserOrGroupId = usr.Id;
  accShare.AccountAccessLevel = 'Edit';
  accShare.OpportunityAccessLevel = 'Edit';
  lstAccShare.add(accShare);
  }
  }
  List<Database.SaveResult> sr = Database.insert(lstAccShare,false);
  
  
}
public static void shareHCCampSessionHCUsers(Set<Id> campSessionIds,List<User> lstUsr){
  
  List<Campaign_Session__Share> lstCampSessionShare = new List<Campaign_Session__Share >();
  For(User usr:lstUsr)
  {
  For(Id csId:campSessionIds)
  {
  Campaign_Session__Share  campSessionShare = new Campaign_Session__Share();
  campSessionShare.ParentId = csId;
  campSessionShare.UserOrGroupId =usr.Id;
  campSessionShare.AccessLevel = 'Edit';
  lstCampSessionShare.add(campSessionShare);
  }
  }
  List<Database.SaveResult> sr = Database.insert(lstCampSessionShare,false);
  
  
}
public static void shareHCCampSessionHCUsers(Set<Id> campSessionIds,Id UserId){
  
  List<Campaign_Session__Share> lstCampSessionShare = new List<Campaign_Session__Share >();
  
  For(Id csId:campSessionIds)
  {
  Campaign_Session__Share  campSessionShare = new Campaign_Session__Share();
  campSessionShare.ParentId = csId;
  campSessionShare.UserOrGroupId =UserId;
  campSessionShare.AccessLevel = 'Edit';
  lstCampSessionShare.add(campSessionShare);
  }
  
  List<Database.SaveResult> sr = Database.insert(lstCampSessionShare,false);
  
  
}
public static void shareEngagements(Set<Id> engIds,Id UserId){
  
  List<Engagement__Share> lstEngShare = new List<Engagement__Share>();
  
  For(Id engId:engIds)
  {
  Engagement__Share   engShare = new Engagement__Share();
  engShare.ParentId = engId;
  engShare.UserOrGroupId =UserId;
  engShare.AccessLevel = 'Edit';
  lstEngShare.add(engShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstEngShare,false);
  
  
}
public static void shareStdUsrEngMatchAssessment(Set<Id> assIds,Id UserId){
  
  List<Assessment__Share> lstAssShare = new List<Assessment__Share>();
  
  For(Id assId:assIds)
  {
  Assessment__Share   assShare = new Assessment__Share();
  assShare.ParentId = assId;
  assShare.UserOrGroupId =UserId;
  assShare.AccessLevel = 'Edit';
  lstAssShare.add(assShare);
  }
  system.debug('**lstAssShare*******'+lstAssShare);
   Batch_SSC batch = new Batch_SSC(lstAssShare);
    Database.executeBatch(batch,200);
 
}
public static void shareEngMatchAssessment(Set<Id> assIds,Id UserId){
  
  List<Assessment__Share> lstAssShare = new List<Assessment__Share>();
  
  For(Id assId:assIds)
  {
  Assessment__Share   assShare = new Assessment__Share();
  assShare.ParentId = assId;
  assShare.UserOrGroupId =UserId;
  assShare.AccessLevel = 'Edit';
  lstAssShare.add(assShare);
  } 
  List<Database.SaveResult> sr = Database.insert(lstAssShare,false);
}
/**
    * Description   :   This method shares assessment with UserId passed 
    * Scenarios   :   1. Assessment Shared with HF user.
              2. Assessment Shared with PT user.
            
    * @args         :   AssessmentId, UserId
    * @return       :   void
    */
    
public static void shareAssessment(Id assId,Id UserId){
  Assessment__Share   assShare = new Assessment__Share();
  
  assShare.ParentId = assId;
  assShare.UserOrGroupId = UserId;
  assShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(assShare,false);
  
  /*Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.Name ='Guest Users'];
  assShare.ParentId = assId;
  assShare.UserOrGroupId = grp.Id;
  assShare.AccessLevel = 'Edit';
  Database.SaveResult srr = Database.insert(assShare,false);*/
}
public static void sharePartnerAssessment(Map<Id,List<User>> sharePartnerAssMap){
  List<Assessment__Share> lstassShare = new List<Assessment__Share>();
  Set<id> assIds = sharePartnerAssMap.keySet() ;
  system.debug('****assIds******'+assIds);
  system.debug('****sharePartnerAssMap******'+sharePartnerAssMap);
  system.debug('****sharePartnerAssMap values ******'+sharePartnerAssMap.values());
  
  For(Id ass:assIds)
  {
    List<User> partnerUser = sharePartnerAssMap.get(ass);
    system.debug('****partnerUser******'+partnerUser);
    for(User usr:partnerUser)
    {
      Assessment__Share   assShare = new Assessment__Share();
      assShare.ParentId = ass;
      assShare.UserOrGroupId = usr.Id;
      assShare.AccessLevel = 'Edit';
      system.debug('****assShare******'+assShare);
      lstassShare.add(assShare);
     }
  }
  system.debug('****lstassShare******'+lstassShare);
  List<Database.SaveResult> sr = Database.insert(lstassShare,false);
  
  
}
public static void shareAssessment(Map<Id,Id> shareHFAssMap){
  List<Assessment__Share> lstassShare = new List<Assessment__Share>();
  Set<id> assIds = shareHFAssMap.keySet() ;
  system.debug('****assIds******'+assIds);
  system.debug('****shareHFAssMap******'+shareHFAssMap);
  For(Id ass:assIds)
  {
  Assessment__Share   assShare = new Assessment__Share();
  assShare.ParentId = ass;
  assShare.UserOrGroupId = shareHFAssMap.get(ass);
  assShare.AccessLevel = 'Edit';
  system.debug('****assShare******'+assShare);
  lstassShare.add(assShare);
  }
  system.debug('****lstassShare******'+lstassShare);
  List<Database.SaveResult> sr = Database.insert(lstassShare,false);
  
  /*Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.Name ='Guest Users'];
  assShare.ParentId = assId;
  assShare.UserOrGroupId = grp.Id;
  assShare.AccessLevel = 'Edit';
  Database.SaveResult srr = Database.insert(assShare,false);*/
}
public static void shareAssessmentWithPublicGroup(Id groupId,List<Assessment__c> lstAss){
  List<Assessment__Share> lstassShare = new List<Assessment__Share>();
  
  For(Assessment__c ass:lstAss)
  {
  Assessment__Share   assShare = new Assessment__Share();
  assShare.ParentId = ass.Id;
  assShare.UserOrGroupId =groupId;
  assShare.AccessLevel = 'Edit';
  lstassShare.add(assShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstassShare,false);
  
  
}
/**
    * Description   :   This method shares assessment with UserId passed 
    * Scenarios   :   1. Assessment Shared with Partner user.                
    * @args         :   AssessmentId, UserId
    * @return       :   void
    */
    
//-- Currently not Used
/*    
public static void shareAssessmentWithPartner(Id assId,Id UserId){
  Assessment__Share   assShare = new Assessment__Share();
  
  assShare.ParentId = assId;
  assShare.UserOrGroupId = UserId;
  assShare.AccessLevel = 'Read';
  Database.SaveResult sr = Database.insert(assShare,false);
  
  
}
public static void shareEngMatchPositionApplicant(list<Match__c> lstMatch,Id UserId){
  
  
  List<Position__Share>  lstposShare = new List<Position__Share>();
  For(Match__c mat:lstMatch)
  {
  Position__Share posShare=new Position__Share();
  posShare.ParentId = mat.Position_Name__c;
  posShare.UserOrGroupId = UserId;
  posShare.AccessLevel = 'Edit';
  lstposShare.add(posShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstposShare,false);
  
  
}*/
//@Future(callout=true)
public static void shareRecord(Id aid){
  Applicant_Info__share ais = new Applicant_Info__share();
  
  Applicant_Info__c ai = [select createdBy__c from Applicant_Info__c where id = :aId];
  ais.ParentId = ai.Id;
  ais.UserOrGroupId = ai.createdBy__c;
  ais.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(ais,false);
}
public static void shareRecord(List<Applicant_Info__c> lstAppInfo){
  
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  For(Applicant_Info__c appInfo:lstAppInfo)
  {
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = appInfo.Id;
  appShare.UserOrGroupId = appInfo.createdBy__c;
  appShare.AccessLevel = 'Edit';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public static void shareRecordGuestUsers(Id aid){
  Applicant_Info__share ais = new Applicant_Info__share();
  
  Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.Name ='Guest Users'];
  ais.ParentId = aid;
  ais.UserOrGroupId = grp.Id;
  ais.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(ais,false);
}
public static void shareRecordGuestUsers(List<Applicant_Info__c> lstAppInfo, Id grpId){
    
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  For(Applicant_Info__c appInfo:lstAppInfo)
  {
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = appInfo.Id;
  appShare.UserOrGroupId = grpId;
  appShare.AccessLevel = 'Edit';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public static void shareEngPartnerApplicant(List<Engagement__c> lstEng,Id uId){
  
  List<Engagement__Share>  lstEngShare = new List<Engagement__Share>();
  For(Engagement__c eng:lstEng)
  {
  Engagement__Share engShare=new Engagement__Share();
  engShare.ParentId = eng.Id;
  engShare.UserOrGroupId = Uid;
  engShare.AccessLevel = 'Edit';
  lstEngShare.add(engShare);
  }
  List<Database.SaveResult> sr = Database.insert(lstEngShare,false);
  
  
}
public static void sharePosRecordGuestUsers(Id pid){
  Position__share posShare = new Position__share();
  
  Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id,g.CreatedDate, g.CreatedById From Group g where g.Name ='Guest Users'];
  posShare.ParentId = pid;
  posShare.UserOrGroupId = grp.Id;
  posShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(posShare,false);
}
public static void shareAccount(Id aId,Id uId){
  AccountShare  ais = new AccountShare ();
  
  ais.AccountId = aId;
  ais.UserOrGroupId = uId;
  ais.AccountAccessLevel = 'Edit';
  ais.OpportunityAccessLevel = 'None';
  System.debug('ais AccountID:'+ais.AccountId);
  System.debug('ais UserOrGroupId:'+ais.UserOrGroupId);
  Database.SaveResult sr = Database.insert(ais,false);
  
  
  System.debug(sr.getErrors());
}

 /**
    * Description   :   This method shares opportunity with UserId passed  
    * Scenarios   :   1. APCHF parent opportunity and child opportuniy are shared with the end user OCPM pt
              
    * @args         :   AccountId, UserId
    * @return       :   void
    */
public static void shareOpportunity(Id oId,Id uId){
  OpportunityShare  ois = new OpportunityShare ();
  
  ois.OpportunityId = oId;
  ois.UserOrGroupId = uId;
  ois.OpportunityAccessLevel = 'Edit';
  //ois.OpportunityAccessLevel = 'None';
  System.debug('ois opportunity Id :'+ois.OpportunityId);
  System.debug('ois UserOrGroupId:'+ois.UserOrGroupId);
  Database.SaveResult sr = Database.insert(ois,false);
  System.debug(sr.getErrors());
}

 /**
    * Description   :   This method shares account with UserId passed  
    * Scenarios   :   1. Match's Position Account Shared with Match's Validator's Contact User CreatedBy
              
    * @args         :   AccountId, UserId
    * @return       :   void
    */
public static void shareMatchAccountRecord(Id aId,Id uId){
  AccountShare  ais = new AccountShare ();
  
  ais.AccountId = aId;
  ais.UserOrGroupId = uId;
  ais.AccountAccessLevel = 'Read';
  ais.OpportunityAccessLevel = 'None';
  System.debug('ais AccountID:'+ais.AccountId);
  System.debug('ais UserOrGroupId:'+ais.UserOrGroupId);
  Database.SaveResult sr = Database.insert(ais,false);
  
  
  System.debug(sr.getErrors());
}

public static void sharePartnerApplicant(Id aId,Id uId){
  Applicant_Info__share ais = new Applicant_Info__share();
  
  ais.ParentId = aid;
  ais.UserOrGroupId = uId;
  ais.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(ais,false);
  
  System.debug(sr.getErrors());
}
public static void sharePartnerRoleUp(Id aId,Id parentroleId){
  System.debug('*aId**'+aId);
  Applicant_Info__share ais = new Applicant_Info__share();
  System.debug('*ais**'+ais);
  Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, g.DoesIncludeBosses, g.DeveloperName, g.CreatedDate, g.CreatedById From Group g where g.RelatedId = :parentroleId and g.type='Role'];
  System.debug('*usrRole**'+grp);
  ais.ParentId = aid;
  ais.UserOrGroupId = grp.Id;
  ais.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(ais,false);
    System.debug('*ais**'+ais);
  
  System.debug(sr.getErrors());
}
//B-03374
public static void shareOppAccWithRole(Id aId,String RoleDevName){
  System.debug('*aId**'+aId);
    
  AccountShare Acctshr = new AccountShare();  
  Group grp = [Select Id,Name,RelatedId,type From Group where RelatedId IN (select Id from userRole where DeveloperName=:RoleDevName) and type='RoleAndSubordinates'];  
  Acctshr.AccountId = aid;
  Acctshr.UserOrGroupId = grp.Id;
  Acctshr.AccountAccessLevel = 'Edit';
  Acctshr.OpportunityAccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(Acctshr,false);
    
  System.debug('*Acctshr**'+Acctshr);
  System.debug('*usrRole**'+grp);
  
  System.debug('Errors-->'+sr.getErrors());
}
    
public static void sharePartnerRoleUp(List<Applicant_Info__c> lstAppInfo,Id parentroleId){
      
  List<Applicant_Info__share>  lsAppInfoShare = new List<Applicant_Info__share>();
  Group grp = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, g.DoesIncludeBosses, g.DeveloperName, g.CreatedDate, g.CreatedById From Group g where g.RelatedId = :parentroleId and g.type='Role'];
  
  For(Applicant_Info__c appInfo:lstAppInfo)
  {
  Applicant_Info__share appShare=new Applicant_Info__share();
  appShare.ParentId = appInfo.Id;
  appShare.UserOrGroupId = grp.Id;
  appShare.AccessLevel = 'Edit';
  lsAppInfoShare.add(appShare);
  }
  List<Database.SaveResult> sr = Database.insert(lsAppInfoShare,false);
  
}
public static void sharePosPartnerApplicant(Id pId,Id uId){
  Position__Share posShare = new Position__Share();
  
  posShare.ParentId = pId;
  posShare.UserOrGroupId = uId;
  posShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(posShare,false);
  
  System.debug(sr.getErrors());
}
public static void shareEngPartnerApplicant(Id engId,Id uId){
  Engagement__Share engShare = new Engagement__Share();
  
  engShare.ParentId = engId;
  engShare.UserOrGroupId = uId;
  engShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(engShare,false);
  
  System.debug(sr.getErrors());
}
public static void shareMatRecord(Id posId,Id uId){
  Position__Share posShare = new Position__Share();
  
  posShare.ParentId = posId;
  posShare.UserOrGroupId = uId;
  posShare.AccessLevel = 'Edit';
  Database.SaveResult sr = Database.insert(posShare,false);
  
  System.debug(sr.getErrors());
}
 
 //Selection Sharing (Start)
 public static void shareselection(Set<Id> PosIds, Set<Id> EnggIds)
    {
    	try
    	{
	        list<Selection__c> listSels = [SELECT Id, Position__c, Engagement__c, Position__r.Host_Company_Id__c, Engagement__r.Account_ID__c FROM Selection__c WHERE Position__c IN :PosIDs];
	        list<Position__c> listSelPos = [SELECT Id, (Select CreatedBy__c From Applicant_Info__r WHERE Application_Stage__c != 'Cancelled' AND CreatedBy__c != NULL ORDER BY CreatedDate DESC ) FROM Position__c WHERE ID IN :PosIds];
	        list<Engagement__c> listSelEngg = [SELECT Id, (Select CreatedBy__c From Applicant_Info__r WHERE Application_Stage__c != 'Cancelled' AND CreatedBy__c != NULL ORDER BY CreatedDate DESC ) FROM Engagement__c WHERE ID IN :EnggIds];
            
	        map<string, string> PositionUserMap = new map<string, string>();
	        map<string, string> EngagementUserMap = new map<string, string>();
	        
            map<string, string> PositionAppMap = new map<string, string>();
            map<string, string> EngagementAppMap = new map<string, string>();
            
	        map<string, string> PositionShareMap = new map<string, string>();
	        map<string, string> EngagementShareMap = new map<string, string>();
	        map<string, string> AccountShareMap = new map<string, string>();
     	        
	        List<Engagement__Share> lstSelEngShare = new List<Engagement__Share>();
	        List<AccountShare> lstSelAccShare = new List<AccountShare>();
	        List<Position__Share> lstSelPosShare = new List<Position__Share>();
	        
            List<Applicant_Info__Share> lstSelAppShare = new List<Applicant_Info__Share>();
            List<Applicant_Info__Share> lstSelEngAppShare = new List<Applicant_Info__Share>();
	        
	        for (Position__c SinglePos : listSelPos)
	        {
	            Boolean appuserfound = false;
	            list<Applicant_Info__c> listApps = SinglePos.Applicant_Info__r;
	            for (Applicant_Info__c SingleApp : listApps)
	            {
	                if(SingleApp.CreatedBy__c != NULL)
	                {
	                    PositionUserMap.put(SinglePos.Id,SingleApp.CreatedBy__c);
                        PositionAppMap.put(SinglePos.Id,SingleApp.id);
	                    appuserfound = true;
	                    break;
	                }
	            }
	            
	            if(appuserfound == false)
	            {
	                PositionUserMap.put(SinglePos.Id,'NoUser');
                    PositionAppMap.put(SinglePos.Id,'NoApp');
	            }
	        }
	        
	        for (Engagement__c SingleEngg : listSelEngg)
	        {
	            Boolean appuserfound = false;
	            list<Applicant_Info__c> listApps = SingleEngg.Applicant_Info__r;
	            for (Applicant_Info__c SingleApp : listApps)
	            {
	                if(SingleApp.CreatedBy__c != NULL)
	                {
	                    EngagementUserMap.put(SingleEngg.Id,SingleApp.CreatedBy__c);
                        EngagementAppMap.put(SingleEngg.Id,SingleApp.id);
	                    appuserfound = true;
	                    break;
	                }
	            }
	            
	            if(appuserfound == false)
	            {
	                EngagementUserMap.put(SingleEngg.Id,'NoUser');
                    EngagementAppMap.put(SingleEngg.Id,'NoApp');
	            }
	        }
	        
	        for (Selection__c SingleSelection: listSels)
	        {
	            if(SingleSelection.Engagement__c != NULL && PositionUserMap.get(SingleSelection.Position__c) != NULL && PositionUserMap.get(SingleSelection.Position__c) != 'NoUser')
	            {
	                Engagement__Share engshr = new Engagement__Share();
	                engshr.ParentId = SingleSelection.Engagement__c;
	                engshr.UserOrGroupId =PositionUserMap.get(SingleSelection.Position__c);
	                engshr.AccessLevel = 'Edit';
	                lstSelEngShare.add(engshr);
                    
                    //Application sharing
                    If(EngagementAppMap.get(SingleSelection.Engagement__c) != 'NoApp'){
                    system.debug('debug:::AppID'+EngagementAppMap.get(SingleSelection.Engagement__c));
                    Applicant_Info__Share appshr = new Applicant_Info__Share();
	                appshr.ParentId = EngagementAppMap.get(SingleSelection.Engagement__c);//  SingleSelection.Engagement__c;
	                appshr.UserOrGroupId =PositionUserMap.get(SingleSelection.Position__c);
	                appshr.AccessLevel = 'Edit';
	                lstSelAppShare.add(appshr);
                    system.debug('debug:::HFApplication'+lstSelAppShare);
                    }
	            }
	            
	            if(SingleSelection.Engagement__r.Account_ID__c != NULL && PositionUserMap.get(SingleSelection.Position__c) != NULL && PositionUserMap.get(SingleSelection.Position__c) != 'NoUser')
	            {
	                AccountShare Acctshr = new AccountShare();
	                Acctshr.AccountId = SingleSelection.Engagement__r.Account_ID__c;
	                Acctshr.UserOrGroupId = PositionUserMap.get(SingleSelection.Position__c);
	                Acctshr.AccountAccessLevel = 'Edit';
	                Acctshr.OpportunityAccessLevel = 'Edit';
	                lstSelAccShare.add(Acctshr);
	            }
	            
	            if(SingleSelection.Position__c != NULL && EngagementUserMap.get(SingleSelection.Engagement__c) != NULL && EngagementUserMap.get(SingleSelection.Engagement__c) != 'NoUser')
	            {
	                Position__Share posshr = new Position__Share();
	                posshr.ParentId = SingleSelection.Position__c;
	                posshr.UserOrGroupId =EngagementUserMap.get(SingleSelection.Engagement__c);
	                posshr.AccessLevel = 'Edit';
	                lstSelPosShare.add(posshr);
                    
                    //Application sharing
                    If(PositionAppMap.get(SingleSelection.Position__c) != 'NoApp'){
                        system.debug('debug:::AppID'+PositionAppMap.get(SingleSelection.Position__c));
                        Applicant_Info__Share appshr = new Applicant_Info__Share();
                        appshr.ParentId = PositionAppMap.get(SingleSelection.Position__c);//SingleSelection.Position__c;
                        appshr.UserOrGroupId =EngagementUserMap.get(SingleSelection.Engagement__c);
                        appshr.AccessLevel = 'Edit';
                        lstSelAppShare.add(appshr);
                        system.debug('debug:::PTApplication'+lstSelAppShare);
                    }
	            }
	            
	            if(SingleSelection.Position__r.Host_Company_Id__c != NULL && EngagementUserMap.get(SingleSelection.Engagement__c) != NULL && EngagementUserMap.get(SingleSelection.Engagement__c) != 'NoUser')
	            {
	                AccountShare Acctshr = new AccountShare();
	                Acctshr.AccountId = SingleSelection.Position__r.Host_Company_Id__c;
	                Acctshr.UserOrGroupId = EngagementUserMap.get(SingleSelection.Engagement__c);
	                Acctshr.AccountAccessLevel = 'Edit';
	                Acctshr.OpportunityAccessLevel = 'Edit';
	                lstSelAccShare.add(Acctshr);
	            }
	        }
	        
	        if(!Test.isRunningTest())
	        {
		        if (lstSelEngShare != NULL && lstSelEngShare.size()>0)
		        {
		            List<Database.SaveResult> sr = Database.insert(lstSelEngShare,false);
		        }
		        if (lstSelPosShare != NULL && lstSelPosShare.size()>0)
		        {
		            List<Database.SaveResult> sr = Database.insert(lstSelPosShare,false);
		        }
		        if (lstSelAccShare != NULL && lstSelAccShare.size()>0)
		        {
		            List<Database.SaveResult> sr = Database.insert(lstSelAccShare,false);
		        }
                if (lstSelAppShare != NULL && lstSelAppShare.size()>0)
		        {
		            List<Database.SaveResult> sr = Database.insert(lstSelAppShare,false);
		        }
	        }
            
        }
        catch (Exception Ex)
        {
            System.debug('An exception occurred on Sharing: ' + ex.getMessage());
        }
        
    }
//Selection Sharing (End)

//@Future(callout=true)
public static void tagApplicationToAccAndOrLead(Person_Info__c personInfo){    
    //Person_Info__c personInfo;
           /* try{
              personInfo = [select Applicant_Info__c,First_Name__c,Last_Name__c,Email__c,Gender__c,Mobile__c from Person_Info__c where id = :pId ]; 
            }catch(Exception e){
              system.debug('***** Impoosible to get any data from Person Info: ' + e);
            }*/
             system.debug('***here-tagapp*****'+personInfo);
            if(personInfo.Email__c!=null)
            {
                List<Account> existingAcc = [select id, Last_Interest_Date__pc from Account where IsPersonAccount = true and PersonEmail!= null and PersonEmail =: personInfo.Email__c order by CreatedDate DESC];
                List<Lead> existingLead = [select id, Status,Field_Staff__c,ConvertedAccountId, Last_Interest_Date__c, Country from Lead where Email =: personInfo.Email__c and Status != 'Closed - Unqualified' and IsConverted = false order by CreatedDate DESC];
                system.debug('******* 123: ' + personInfo.Applicant_Info__c );
                if(personInfo.Applicant_Info__c != null){
                Applicant_Info__c applicantInfo = [select Id,Country_of_interest__c,Account__c,Partner_Intrax_Id__c,Application_Level__c,Application_Stage__c,CreatedById,createdBy__c,LastModifiedById,Intrax_Program__c,Type__c,Lead__c,
                Intrax_Program_Options__c,Home_Phone__c,Home_Street_2__c,Home_Street_1__c,Home_City__c,Home_State__c,Home_Postal_Code__c,Home_Country__c,Title__c,
                Date_of_Birth__c,Enquiry_Channel__c,Currently_Studying__c, One_Year_Work_Experience__c,Five_Years_Work_Experience__c,Intrax_Market__c, Intrax_Region__c, RecordTypeId,Allergies_Indicated__c,Low_Grade_Count__c from Applicant_Info__c where id = :personInfo.Applicant_Info__c ];

                if (existingAcc.size() > 0) {
                    applicantInfo.Account__c = existingAcc[0].ID;
                    if((existingAcc[0].Last_Interest_Date__pc == NULL || !datetime.now().isSameDay(existingAcc[0].Last_Interest_Date__pc) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.createdBy__c == applicantInfo.LastModifiedById )){
                      existingAcc[0].Last_Interest_Date__pc = dateTime.now();
                    }
                    update applicantInfo;
                    //update existingAcc[0];
                }
                else if (existingLead.size() > 0) {  
                	 system.debug('----exisiting lead size' + existingLead.size());
                	 system.debug('----exisiting lead' + existingLead[0]);
                	
                	//B-03219  
                     if(applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Type__c == 'Host Family' && applicantInfo.Application_Level__c == 'Basic')
                    {                                                                     
                         List<Lead> existingLeadOrigin = [select id,Program_Advisor__c, Status,Field_Staff__c,ConvertedAccountId, Last_Interest_Date__c, Country from Lead where Status = 'Open - New' and Email =: personInfo.Email__c and Status != 'Closed - Unqualified' and IsConverted = false order by CreatedDate ASC];
                       
                       if (existingLeadOrigin.size() > 0)
                        {
                         applicantInfo.Field_Staff__c = existingLeadOrigin[0].Field_Staff__c;
                         //B-03356
                         applicantInfo.Program_Advisor__c = existingLeadOrigin[0].Program_Advisor__c;
                    	 system.debug('*Lead***Field_Staff__c****' + existingLeadOrigin[0]);     
                        }                                 
                    }
                    
                    
                    system.debug('-----**Field_Staff__c**----');
                  //// B-03219 
                	 
                    //B-01474. For CNPT and APCHF. D-01343
                    if(applicantInfo.Intrax_Program__c == 'English and Professional Skills' || (applicantInfo.Intrax_Program__c == 'AuPairCare' && applicantInfo.Type__c == 'Host Family'))
                    {                                                                     
                        if(existingLead[0].Status == 'Pre-SQL'){
                            existingLead[0].Status = 'Open - New';   
                        }                                            
                    }
                    system.debug('----->ENtered exisiting lead');
                    
                
                    
                    //B-01513
                    if(applicantInfo.RecordTypeId==Constants.ICD_Intern_PT_Record_Type_Id && applicantInfo.Application_Level__c == 'Basic')
                    {
                        system.debug('----->ENtered basic igig');
                        system.debug('----->personInfo.Country_of_Residence__c:'+personInfo.Country_of_Residence__c);
                        existingLead[0].Currently_Studying__c = applicantInfo.Currently_Studying__c;
                        existingLead[0].One_Year_Work_Experience__c=applicantInfo.One_Year_Work_Experience__c;
                        existingLead[0].Five_Years_Work_Experience__c=applicantInfo.Five_Years_Work_Experience__c;
                        existingLead[0].Country = personInfo.Country_of_Residence__c;
                        //---School values                       
                    }
                    
                    //B-01506
                    if(applicantInfo.RecordTypeId==Constants.AyusaPT_Record_Type_Id){
                        existingLead[0].Allergies_Indicated__c = applicantInfo.Allergies_Indicated__c;                      
                        existingLead[0].Country = personInfo.Country_of_Residence__c;
                        //special diet, hosting interest                        
                    }
                                    
                    try{    
                        system.debug('Before----->existingLead[0].Country:'+existingLead[0].Country);                       
                        update existingLead[0];      
                        system.debug('After----->existingLead[0].Country:'+existingLead[0].Country);                                               
                    }catch(Exception e){
                        system.debug('***** Impossible to update related applicant: '+ e);
                    } 
                                    
                    if (applicantInfo.Intrax_Program__c != 'Ayusa' && applicantInfo.Type__c != 'Host Family'){                      
                        applicantInfo.Lead__c = existingLead[0].ID;
              
                        if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.createdBy__c == applicantInfo.LastModifiedById )){
                            existingLead[0].Last_Interest_Date__c = DateTime.now(); 
                        }                        
                                                
                        try{                
                                      
                          //update applicantInfo;//COMMENTED  
                          //update existingLead[0];                             
                        }catch(Exception e){
                          system.debug('***** Impossible to update related applicant: '+ e);
                        }                           
                        
                    }
                    
                    else                    
                    {
                        applicantInfo.Lead__c = existingLead[0].ID;
                        //IUtilities.AppToLeadSync(applicantInfo, personInfo, existingLead[0], 'insert'); 
                        
                        existingLead[0].FirstName = personInfo.First_Name__c;
                        existingLead[0].LastName = personInfo.Last_Name__c;
                        existingLead[0].Intrax_Programs__c = 'Ayusa';
                        existingLead[0].Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                        existingLead[0].Lead_Type__c = applicantInfo.Type__c;
                        existingLead[0].LeadSource = 'Portal';
                        existingLead[0].Lead_Source_Tag__c = 'Application';
                        // MT 85 - Intrax_Region and Intrax_Market need to be dynamically set
                        //existingLead[0].Intrax_Region__c = 'United States';
                        existingLead[0].Intrax_Region__c = applicantInfo.Intrax_Region__c;
                        existingLead[0].Intrax_Market__c = applicantInfo.Intrax_Market__c;
                        existingLead[0].Email = personInfo.Email__c;
                        existingLead[0].Gender__c = personInfo.Gender__c;
                        existingLead[0].MobilePhone = personInfo.Mobile__c;
                        existingLead[0].Phone = applicantInfo.Home_Phone__c;
                        existingLead[0].Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
                        existingLead[0].City = applicantInfo.Home_City__c;
                        existingLead[0].State = applicantInfo.Home_State__c;
                        existingLead[0].PostalCode = applicantInfo.Home_Postal_Code__c;
                        existingLead[0].Country = applicantInfo.Home_Country__c;
                        existingLead[0].Title = applicantInfo.Title__c;
                        existingLead[0].Date_of_Birth__c = applicantInfo.Date_of_Birth__c;    
                        existingLead[0].Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;   
                        // Update only if nto changed in last 24 hours
                        if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.createdBy__c == applicantInfo.LastModifiedById )){
                            existingLead[0].Last_Interest_Date__c = DateTime.now(); 
                        }
                                                
                        try{
                          //update applicantInfo;//COMMENTED
                          //update existingLead[0];    
                        }catch(Exception e){
                          system.debug('***** Impossible to update related Lead: '+ e);
                        }  
                           
                    }
                    //instead of 2 commented above
                    try{
                        system.debug('Update----->applicantInfo:'+applicantInfo);   
                          update applicantInfo;                            
                        }catch(Exception e){
                          system.debug('***** Impossible to update related Lead: '+ e);
                        }
                    
                } 
                else {
                    // applicantInfo.RecordTypeId == Constants.AyusaHF_Record_Type_Id
                    if (applicantInfo.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id || applicantInfo.RecordTypeId == Constants.WT_PT_Record_Type_Id || applicantInfo.RecordTypeId == Constants.AyusaPT_Record_Type_Id )
                    {
                        if (personInfo.Country_of_Residence__c != NULL)
                        {
                        Lead newLead = new Lead();            
                        newLead.FirstName = personInfo.First_Name__c;
                        newLead.LastName = personInfo.Last_Name__c;
                        newLead.Status = 'Open - New';
                        newLead.Intrax_Programs__c = applicantInfo.Intrax_Program__c; 
                        newLead.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                        newLead.Lead_Type__c = applicantInfo.Type__c;
                        newLead.LeadSource = 'Portal';
                        newLead.Lead_Source_Tag__c = 'Application';
                        // MT 85 - Intrax_Region and Intrax_Market need to be dynamically set
                        //newLead.Intrax_Region__c = 'United States';
                        newLead.Intrax_Region__c = applicantInfo.Intrax_Region__c;
                          newLead.Intrax_Market__c = applicantInfo.Intrax_Market__c;
                        newLead.Email = personInfo.Email__c;
                        newLead.Gender__c = personInfo.Gender__c;
                        newLead.MobilePhone = personInfo.Mobile__c;
                        newLead.Phone = applicantInfo.Home_Phone__c;
                        newLead.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
                        newLead.City = applicantInfo.Home_City__c;
                        newLead.State = applicantInfo.Home_State__c;
                        newLead.PostalCode = applicantInfo.Home_Postal_Code__c;
                        newLead.Country = applicantInfo.Home_Country__c;
                        newLead.Title = applicantInfo.Title__c;
                        newLead.Date_of_Birth__c = applicantInfo.Date_of_Birth__c;
                        newLead.Last_Interest_Date__c = DateTime.now(); 
                        newLead.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;
                        newLead.Citizenship__c = personInfo.citizenship__c;
                        newLead.countries_of_interest__c = applicantInfo.Country_of_Interest__c;
                        System.debug('---applicantInfo----->'+applicantInfo);
                        
                        //B-01513
                        if(applicantInfo.RecordTypeId==Constants.ICD_Intern_PT_Record_Type_Id  && applicantInfo.Application_Level__c == 'Basic')
                        {
                            newLead.Currently_Studying__c = applicantInfo.Currently_Studying__c;
                            newLead.One_Year_Work_Experience__c=applicantInfo.One_Year_Work_Experience__c;
                            newLead.Five_Years_Work_Experience__c=applicantInfo.Five_Years_Work_Experience__c;
                            newLead.Country = personInfo.Country_of_Residence__c;
                            //---School values
                        }
                        
                        //B-01506
                        if(applicantInfo.RecordTypeId==Constants.AyusaPT_Record_Type_Id){
                            newLead.Allergies_Indicated__c = applicantInfo.Allergies_Indicated__c;                          
                            newLead.Country = personInfo.Country_of_Residence__c ;
                            //special diet, hosting interest                        
                        }
                        if(applicantInfo.RecordTypeId==Constants.AyusaHF_Record_Type_Id){                                               
                            newLead.Country = personInfo.Country_of_Residence__c ;
                            //special diet, hosting interest                        
                        }
                    
                        // to turn the Assignment Rules on
                        Database.DMLOptions dmo = new Database.DMLOptions();
                        dmo.assignmentRuleHeader.useDefaultRule = true;
                        newLead.setOptions(dmo);
                        
                        try{
                            insert newLead;
                        }catch(Exception e){
                          system.debug('****** Impossible to create new Lead for the HF App: '+ e);
                        }
                        
                        System.debug('ENTERED NEW LEAD ID IS:---'+newLead.Id);
                        applicantInfo.Lead__c = newLead.id;
                         
                        //B-01326.
                        try{
                            
                                update applicantInfo;  
                                                     
                          }catch(Exception e){
                            system.debug('***** Impossible to update applicant info: '+ e);
                          }
                    }
                      
                }
                else
                {
                    //do not create lead for APC PT during registration
                    if(applicantInfo.RecordTypeId != Constants.Centers_Record_Type_Id && applicantInfo.RecordTypeId != Constants.AuPairCarePT_Record_Type_Id ){ 
                        Lead newLead = new Lead();            
                        newLead.FirstName = personInfo.First_Name__c;
                        newLead.LastName = personInfo.Last_Name__c;
                        newLead.Status = 'Open - New';
                        newLead.Intrax_Programs__c = applicantInfo.Intrax_Program__c; 
                        newLead.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                        newLead.Lead_Type__c = applicantInfo.Type__c;
                        newLead.LeadSource = 'Portal';
                        newLead.Lead_Source_Tag__c = 'Application';
                        // MT 85 - Intrax_Region and Intrax_Market need to be dynamically set
                        //newLead.Intrax_Region__c = 'United States';
                        newLead.Intrax_Region__c = applicantInfo.Intrax_Region__c;
                          newLead.Intrax_Market__c = applicantInfo.Intrax_Market__c;
                        newLead.Email = personInfo.Email__c;
                        newLead.Gender__c = personInfo.Gender__c;
                        newLead.MobilePhone = personInfo.Mobile__c;
                        newLead.Phone = applicantInfo.Home_Phone__c;
                        newLead.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
                        newLead.City = applicantInfo.Home_City__c;
                        newLead.State = applicantInfo.Home_State__c;
                        newLead.PostalCode = applicantInfo.Home_Postal_Code__c;
                        newLead.Country = applicantInfo.Home_Country__c;
                        newLead.Title = applicantInfo.Title__c;
                        newLead.Date_of_Birth__c = applicantInfo.Date_of_Birth__c;
                        newLead.Last_Interest_Date__c = DateTime.now(); 
                        newLead.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;
                        newLead.Citizenship__c = personInfo.citizenship__c;
                        newLead.countries_of_interest__c = applicantInfo.Country_of_Interest__c;
                        //B-01513
                        if(applicantInfo.RecordTypeId==Constants.ICD_Intern_PT_Record_Type_Id  && applicantInfo.Application_Level__c == 'Basic')
                        {
                            newLead.Currently_Studying__c = applicantInfo.Currently_Studying__c;
                            newLead.One_Year_Work_Experience__c=applicantInfo.One_Year_Work_Experience__c;
                            newLead.Five_Years_Work_Experience__c=applicantInfo.Five_Years_Work_Experience__c;
                            newLead.Country = personInfo.Country_of_Residence__c;
                            //---School values
                        }
                        
                        //B-01506
                        if(applicantInfo.RecordTypeId==Constants.AyusaPT_Record_Type_Id){
                            newLead.Allergies_Indicated__c = applicantInfo.Allergies_Indicated__c;                          
                             newLead.Country = personInfo.Country_of_Residence__c;
                            //special diet, hosting interest                        
                        }
                        
                        // to turn the Assignment Rules on
                        Database.DMLOptions dmo = new Database.DMLOptions();
                        dmo.assignmentRuleHeader.useDefaultRule = true;
                        newLead.setOptions(dmo);
                        try{
                          insert newLead;
                        }catch(Exception e){
                          system.debug('****** Impossible to create new Lead for the HF App: '+ e);
                        }
                        System.debug('ENTERED NEW LEAD ID IS:---'+newLead.Id);
                        applicantInfo.Lead__c = newLead.id;
                         
                        //B-01326.
                        try{
                            if (applicantInfo.Intrax_Program__c == 'Ayusa' && applicantInfo.Type__c == 'Host Family'){
                                update applicantInfo;  
                            }                          
                          }catch(Exception e){
                            system.debug('***** Impossible to update applicant info: '+ e);
                          }
                          
                     }
                     
                     else if((applicantInfo.RecordTypeId == Constants.Centers_Record_Type_Id || applicantInfo.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id)  && personInfo.Date_of_Birth__c != NULL){
                        System.debug('-----CENTERS AND APC PT LEAD CREATION-----');
                        Lead newLead = new Lead();            
                        newLead.FirstName = personInfo.First_Name__c;
                        newLead.LastName = personInfo.Last_Name__c;
                        newLead.Status = 'Open - New';
                        newLead.Intrax_Programs__c = applicantInfo.Intrax_Program__c; 
                        newLead.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                        newLead.Lead_Type__c = applicantInfo.Type__c;
                        newLead.LeadSource = 'Portal';
                        newLead.Lead_Source_Tag__c = 'Application';
                        // MT 85 - Intrax_Region and Intrax_Market need to be dynamically set
                        //newLead.Intrax_Region__c = 'United States';
                        newLead.Intrax_Region__c = applicantInfo.Intrax_Region__c;
                        newLead.Intrax_Market__c = applicantInfo.Intrax_Market__c;
                        newLead.Email = personInfo.Email__c;
                        newLead.Gender__c = personInfo.Gender__c;
                        newLead.MobilePhone = personInfo.Mobile__c;
                        newLead.Phone = applicantInfo.Home_Phone__c;
                        newLead.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
                        newLead.City = applicantInfo.Home_City__c;
                        newLead.State = applicantInfo.Home_State__c;
                        newLead.PostalCode = applicantInfo.Home_Postal_Code__c;
                        newLead.Country = applicantInfo.Home_Country__c;
                        newLead.Title = applicantInfo.Title__c;
                        newLead.Date_of_Birth__c = applicantInfo.Date_of_Birth__c;
                        newLead.Last_Interest_Date__c = DateTime.now(); 
                        newLead.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;
                        newLead.Citizenship__c = personInfo.citizenship__c;
                        newLead.countries_of_interest__c = applicantInfo.Country_of_Interest__c;
                                                                        
                        // to turn the Assignment Rules on
                        Database.DMLOptions dmo = new Database.DMLOptions();
                        dmo.assignmentRuleHeader.useDefaultRule = true;
                        newLead.setOptions(dmo);
                        try{
                          System.debug('-----CENTERS LEAD CREATION-----');
                          insert newLead;
                        }catch(Exception e){
                          system.debug('****** Impossible to create new Lead for the HF App: '+ e);
                        }
                        System.debug('ENTERED NEW LEAD ID IS:---'+newLead.Id);
                        applicantInfo.Lead__c = newLead.id;
                        try{                            
                                update applicantInfo;                                   
                          }catch(Exception e){
                            system.debug('***** Impossible to update applicant info: '+ e);
                          }
                        
                    }
                }
                }
            }
            } // end
  }

}