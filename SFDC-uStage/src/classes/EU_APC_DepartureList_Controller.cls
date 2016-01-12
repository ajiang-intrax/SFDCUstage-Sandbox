public with Sharing class EU_APC_DepartureList_Controller{
  public String opptyId{get;set;} /** get set the variable for opportunity Id take value from visual component.**/
  public Date OppEngStart{get;set;}
  public List<Opportunity> OtherOpportunities{get;set;}
   public List<Opportunity> getOtherOpps() {
       List<Opportunity> CurrentOpp = [select id,Engagement_Start__c from opportunity where id=:opptyId];
       if(CurrentOpp!=null && CurrentOpp.size()>0)
        {
           OppEngStart = CurrentOpp[0].Engagement_Start__c;
       }       
        OtherOpportunities = [Select o.RecordTypeId, o.Primary_Contact__r.Email, o.Primary_Contact__r.Phone, o.Primary_Contact__r.MobilePhone, o.Primary_Contact__r.Name, o.Primary_Contact__r.FirstName, o.Primary_Contact__r.LastName, o.Primary_Contact__r.Id, o.Primary_Contact__c, o.Id, o.Engagement_Start__c, o.Countries_of_Interest__c From Opportunity o where 
        o.Countries_of_Interest__c='United States'  and o.type ='Participant' and o.oPeration_Stage__c='Matched' and o.Intrax_Market__c = 'Germany' and o.RecordTypeId=:Constants.OPP_AUPAIRCARE_PT and o.Engagement_Start__c=:OppEngStart order by o.Primary_Contact__r.Name];
        
        return OtherOpportunities;
         
   }
}