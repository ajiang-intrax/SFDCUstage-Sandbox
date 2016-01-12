public class EUViewPlacement {
    private ApexPages.standardController standardController;
    public String code {set;}
    public String oid {get; set;}
    public String p_acc {get; set;}
    public Match__c confirmMatchId {get;set;}
    public String lang_region {get;set;}
    public String lang_market {get;set;}
    public Match__c confirm_match {set;}
    public String applnId {get; set;}
    public List<Applicant_Info__c> appln { get; set; }
    public Applicant_Info__c applndetail {  set; }
    public Applicant_Info__c PTapplndetail{ set; }
    public Integer appCount {set;}
    public Integer count=0;
    public List<Opportunity> checkcode { get; set; }
    public List<Person_Info__c> Parent { set; }
    public List<Person_Info__c> list_parent { get; set; }
    public List<Person_Info__c> Notparent {  set; }
    public String hostAcc {get;set;}
    public String hostPos {get;set;}
    public String hostApp {get;set;}
    public String PartAcc { set; }
    public String USAPartAcc { set; }
    public String EmerPartAcc { set; }
    public User RM { set; }
    public String own { get; set; }
    public List<Contact> partcont {get; set;}
    public EUViewPlacement(ApexPages.StandardController controller) {
     this.standardController = controller;
    }
    public EUViewPlacement()
    {
         
    }

public Boolean hasMatch {set {value = false;}}
public List<Match__c> ConfirmMatch {get;set;}

public Boolean gethasMatch(){
ConfirmMatch = new List<Match__c>(); 
if(ApexPages.currentPage().getParameters().get('Id') != null) {
ConfirmMatch = [Select ID, Position_Name__r.Host_Company_Id__r.LastName,Position_Name__r.Street__c,Position_Name__r.Country__c,Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Postal_Code__c,
                                Position_Name__r.Host_Company_Id__r.PersonMobilePhone,Position_Name__r.Host_Company_Id__r.Phone,Position_Name__r.Host_Company_Id__r.PersonEmail,
                                Position_Name__r.Host_Company_Id__r.FirstName,Position_Name__r.Host_Company_Id__r.Name,Position_Name__r.Pets__c,Position_Name__r.Pets_Description__c,
                                Position_Name__r.Double_Placement_Indicated__c,Position_Name__r.Single_No_Children_Indicated__c,Position_Name__r.Smoker_in_Family__c,End_Date__c,
                                Start_Date__c,Participant_Opportunity_Id__c,Owner_Name__c,Owner_Phone__c,Owner_Email__c,Local_Staff_Contact__r.Name, Local_Staff_Contact__r.Phone, Local_Staff_Contact__r.Email,Position_Name__r.Ownerid,
                                School_Id__r.Name,School_Id__r.BillingStreet,
                                School_Id__r.BillingCountry,School_Id__r.BillingCity, School_Id__r.BillingState, School_Id__r.BillingPostalCode,School_Id__r.Website
                                FROM Match__c 
                                WHERE Engagement__c =:ApexPages.currentPage().getParameters().get('Id')  AND Status__c = 'Confirmed']; 
 
                  if (ConfirmMatch != null && ConfirmMatch.size() == 1)
                    {
                        confirmMatchId=ConfirmMatch[0];
                        oid=ConfirmMatch[0].Participant_Opportunity_Id__c;
                        own=ConfirmMatch[0].Position_Name__r.Ownerid;
                       // hostAcc=ConfirmMatch[0].Position_Name__r.Host_Company_Id__r.Id; 
                        hostPos=ConfirmMatch[0].Position_Name__r.Id; 
                        return true;
                    }
   }
   return false;
}
public String getcode(){
   gethasMatch();
   getapplndetail();
   checkcode = new list<Opportunity>();
   checkcode = [Select Intrax_Region__c,Intrax_Market__c,Partner_Account__r.Id  from Opportunity where ID =:oid];
   String ger='de';
   String other='en-US';
   if((checkcode!= null) &&(checkcode.size() >= 1)){
     p_acc=checkcode[0].Partner_Account__r.Id;
     if(String.isNotEmpty(checkcode[0].Intrax_Region__c))
     {
      lang_region=checkcode[0].Intrax_Region__c;
      if(String.isNotEmpty(checkcode[0].Intrax_Market__c)){
         lang_market = checkcode[0].Intrax_Market__c;
          if(lang_region.equals('Europe') && lang_market.equals('Germany') )
          {
            return ger;
          }
       }
      }
    }
   return other;
}
public User getRM()
{
  List<User> RM_user=new List<User>();
  User rm_con=new User();
  User manager=new User();
  List<User> RM_contact=new List<User>();
  RM_user=[Select ManagerId from User where id =:own];
  if((RM_user!= null) &&(RM_user.size() >= 1)){
  manager= RM_user[0];
  }
  RM_contact=[Select Name,Title,Phone,Email from User where id =:RM_user[0].ManagerId Limit 1];     
  if((RM_contact!= null) &&(RM_contact.size() >= 1)){
    rm_con = RM_contact[0];
   }
  return rm_con;
}

public String getUSAPartAcc(){
   String emp = ' ';
   partcont = new list<Contact>();
   partcont = [Select id,Phone from Contact where Account.Id=:p_acc and Emergency_Contact__c='First' and Intrax_Programs__c ='Ayusa' and Intrax_Program_Options_CT__c ='Ayusa High School'];
   if((partcont!= null) &&(partcont.size() >= 1)){
           emp=partcont[0].Phone;
       }
  return emp; 
 }
public String getEmerPartAcc(){
   String emp = ' ';
   partcont = new list<Contact>();
   partcont = [Select id,Phone from Contact where Account.Id =:p_acc and Emergency_Contact__c='First' and Intrax_Programs__c ='Ayusa' and (Intrax_Program_Options_CT__c ='High School Worldwide' or Intrax_Program_Options_CT__c = 'Summer Camp') ];
   if((partcont!= null) &&(partcont.size() >= 1)){
           emp=partcont[0].Phone;
       }
  return emp; 
 }
 
 public String getPartAcc(){
   String emp = ' ';
   partcont = new list<Contact>();
   partcont = [Select id,Phone from Contact where Account.Id=:p_acc and Emergency_Contact__c='Second' and Intrax_Programs__c ='Ayusa' and Intrax_Program_Options_CT__c ='Ayusa High School'];
   if((partcont!= null) &&(partcont.size() >= 1)){
           emp=partcont[0].Phone;
    }
  return emp; 
 }
   
   
public Match__c getconfirm_match()
{
  return confirmMatchId;
}
public List<Person_Info__c> getParent()
{
  appln = new List<Applicant_Info__c>();
  list_parent= new List<Person_Info__c>();
  appln=[Select ID from Applicant_Info__c where Id =:hostApp ];
    if((appln != null)&& (appln.size() >=1))
    {
    applnId=appln[0].ID;
    list_parent=[Select Role__c,First_Name__c,Last_Name__c, Age__c,Profession__c from Person_Info__c where Applicant_Info__r.Id=: applnId and Role__c IN ('Host','Spouse or Partner','Spouse')];
    }
  return list_parent;
}

public List<Person_Info__c> getNotparent()
{
  appln = new List<Applicant_Info__c>();
  list_parent= new List<Person_Info__c>();
  appln=[Select ID from Applicant_Info__c where Id =:hostApp];
    if((appln != null)&& (appln.size() >=1))
    {
    applnId=appln[0].ID;
    list_parent=[Select Role__c,First_Name__c,Last_Name__c, Age__c,Gender__c from Person_Info__c where Applicant_Info__r.Id=: applnId and Primary_Applicant__c=false and Role__c NOT IN ('Host','School Official','Reference','Spouse or Partner','Spouse')];
    }
   
  return list_parent;
}
public Applicant_Info__c getPTapplndetail()
{
  appln = new List<Applicant_Info__c>();
  Applicant_Info__c ap=new Applicant_Info__c();
  List<Applicant_Info__c> list_ap=new List<Applicant_Info__c>();
  appln=[Select ID from Applicant_Info__c where Engagement__r.ID =:ApexPages.currentPage().getParameters().get('Id')];
    if((appln != null)&& (appln.size() >=1))
    {
    list_ap=[Select Airport__c,Nearest_City__c from Applicant_Info__c where Id=:appln[0].ID];
    ap=list_ap[0];  
    }
    return ap;
}
public Applicant_Info__c getapplndetail()
{
  count=0;
  appln = new List<Applicant_Info__c>();
  Applicant_Info__c ap=new Applicant_Info__c();
  appln=[Select Id,Application_Stage__c,Family_Activities__c,Bedrooms__c,Bedroom_Shared_Indicated__c,Bathrooms__c,Special_Diet_Indicated__c,Special_Diet_Description__c,
                      Community_Type__c,Community_Description__c,Community_Population__c,Nearest_City__c,Airport__c,
                      Pet_Types__c from Applicant_Info__c where Position__r.Id =:hostPos];
  for(Applicant_Info__c var_app:appln){
        if(var_app.Application_Stage__c=='Accepted')
            {
              count=count+1;
              hostApp=var_app.Id;
              ap=var_app;  
            }
  }
  return ap;  
 }
 public Integer getappCount(){
        return count;
    }
}