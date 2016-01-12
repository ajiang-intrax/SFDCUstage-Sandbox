public with sharing class ReAssign_Owner_AppInfo_Controller {
public Applicant_Info__c applicant{get;set;}
public Applicant_Info__c objApplicant{get;set;}
List<Position__c> lstRelatedPos = new list<Position__c>();
List<Account> lstRelatedHostAcc = new list<Account>();
List<Applicant_Info__c> lstRelatedAppInfo = new list<Applicant_Info__c>();
List<Assessment__c> lstRelatedAss = new list<Assessment__c>();
List<Engagement__c> lstRelatedEng = new list<Engagement__c>();
List<iGeoLocate__c> lstRelatedGeos = new list<iGeoLocate__c>();
List<Intrax_Program_Upload__c> lstRelatedIPUs = new list<Intrax_Program_Upload__c>();
List<Match__c> lstRelatedMatches = new list<Match__c>();
List<Assessment__c> lstRelatedMatchAss = new list<Assessment__c>();
 public String retParam {get;set;}
  Public User DummyObj=new User();
  public User getDummyObj() { return DummyObj; }
  public string NewOwner{get;set;}
      public ReAssign_Owner_AppInfo_Controller(ApexPages.StandardController controller) {
        
                 //Get match Id
            objApplicant = (Applicant_Info__c)controller.getRecord();
           // position  = [Select p.Type__c, p.RecordTypeId, p.Owner.Name, p.Owner.LastName, p.Owner.Username, p.OwnerId, p.Name, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.Functional_Areas_Other__c, p.Earliest_End__c From Position__c p where p.Id =:objPosition.Id  limit 1];
            applicant = [Select a.RecordTypeId,a.Owner.ProfileId, a.Owner.UserRoleId,a.position__c,  a.Owner.Username, a.Owner.Id, a.OwnerId,a.Owner.Name, a.Name, a.Id, a.Engagement__r.Name, a.Engagement__r.OwnerId, a.Engagement__r.Id, a.Engagement__c, a.Account__r.OwnerId, a.Account__r.Ownership, a.Account__r.Name, a.Account__r.Id, a.Account__c, (Select Id, OwnerId, Name From Intrax_Program_Uploads__r) From Applicant_Info__c a where a.Id=:objApplicant.Id Limit 1] ; 
           // retParam = '/' + applicant.Id + '/a?returl=/apex/reassign_owner_appinfo?id=' + applicant.Id ;
             system.debug('***applicant*****'+applicant);
               system.debug('***retParam*****'+retParam);
          
       }
     public PageReference save(){
     	//NewOwner = DummyObj.Dummy_LookUp__c;
     	applicant.OwnerId = DummyObj.Dummy_LookUp__c;
        upsert applicant;
        system.debug('*****applicant********'+applicant);
        ChangeRelatedOwners();
        return new PageReference('/a0U');
    }
       public void ChangeRelatedOwners()
       {
        lstRelatedHostAcc = [Select a.OwnerId From Account a where a.Id =:applicant.Id];
        system.debug('*****lstRelatedHostAcc********'+lstRelatedHostAcc);    
         if(lstRelatedHostAcc!=null && lstRelatedHostAcc.size()>0)
         {
         	For(Account acc : lstRelatedHostAcc)
         	{
         		acc.OwnerId  = applicant.OwnerId;
         	}
         	update lstRelatedHostAcc;
         }
          system.debug('*****lstRelatedHostAcc********'+lstRelatedHostAcc); 
          lstRelatedPos =  [Select a.OwnerId From Position__c a where a.Id =:applicant.Position__c]; 
          system.debug('*****lstRelatedPos********'+lstRelatedPos);    
         if(lstRelatedPos!=null && lstRelatedPos.size()>0)
         {
         	For(Position__c pos : lstRelatedPos)
         	{
         		pos.OwnerId  = applicant.OwnerId;
         	}
         	update lstRelatedPos;
         }
        lstRelatedAss = [Select a.OwnerId From Assessment__c a where a.Position_Name__c  =:applicant.Position__c and a.RecordTypeId !=: Constants.ASS_AY_HF_Validation]; 
          system.debug('*****lstRelatedAss********'+lstRelatedAss);    
         if(lstRelatedAss!=null && lstRelatedAss.size()>0)
         {
         	For(Assessment__c ass : lstRelatedAss)
         	{
         		ass.OwnerId  = applicant.OwnerId;
         	}
         	update lstRelatedAss;
         }
          system.debug('*****lstRelatedAss********'+lstRelatedAss); 
          //Defect D-01024 (Start)
           lstRelatedMatches = [Select m.Status__c, m.Position_Name__c, m.Id, m.Engagement__c From Match__c m where m.Position_Name__c=:applicant.Position__c AND Status__c = 'Confirmed'];
           //Defect D-01024 (End)
          system.debug('*****lstRelatedMatches********'+lstRelatedMatches);
          if(lstRelatedMatches!=null && lstRelatedMatches.size()>0)
          {
          	for(Match__c mat:lstRelatedMatches)
          	{
          		if(mat.Engagement__c!=null)
          		{
          			 lstRelatedEng = [Select a.OwnerId From Engagement__c a where a.Id =:mat.Engagement__c]; 
          			  if(lstRelatedEng!=null && lstRelatedEng.size()>0)
			         {
			         	For(Engagement__c eng : lstRelatedEng)
			         	{
			         		eng.OwnerId  = applicant.OwnerId;
			         	}
			         	update lstRelatedEng;
			         }
          		}
          	}
          } 
        /*  lstRelatedEng = [Select a.OwnerId From Engagement__c a where a.Id =:applicant.Engagement__c]; 
          system.debug('*****lstRelatedEng********'+lstRelatedEng);    
         if(lstRelatedEng!=null && lstRelatedEng.size()>0)
         {
         	For(Engagement__c eng : lstRelatedEng)
         	{
         		eng.OwnerId  = applicant.OwnerId;
         	}
         	update lstRelatedEng;
         }
          system.debug('*****lstRelatedEng********'+lstRelatedEng); */
          
          lstRelatedIPUs = [Select a.OwnerId From Intrax_Program_Upload__c a where a.Applicant_Info__c =:applicant.Id]; 
           system.debug('*****lstRelatedIPUs********'+lstRelatedIPUs);    
         if(lstRelatedIPUs!=null && lstRelatedIPUs.size()>0)
         {
         	For(Intrax_Program_Upload__c ipu : lstRelatedIPUs)
         	{
         		ipu.OwnerId  = applicant.OwnerId;
         	}
         	update lstRelatedIPUs;
         }
          system.debug('*****lstRelatedIPUs********'+lstRelatedIPUs); 
          
         system.debug('*****applicant - OwnerId********'+applicant.OwnerId);  
       }
    
       public pagereference Cancel()
       {
         return new PageReference('/' + applicant.Id);
       }
      
    
       
      
     
     
}