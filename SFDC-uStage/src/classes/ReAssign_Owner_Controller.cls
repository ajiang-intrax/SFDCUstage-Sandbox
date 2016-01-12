public with sharing class ReAssign_Owner_Controller {
public Position__c position{get;set;}
public Position__c objPosition{get;set;}
List<Account> lstRelatedHostAcc = new list<Account>();
List<Applicant_Info__c> lstRelatedAppInfo = new list<Applicant_Info__c>();
List<Assessment__c> lstRelatedAss = new list<Assessment__c>();
List<Engagement__c> lstRelatedEng = new list<Engagement__c>();
List<iGeoLocate__c> lstRelatedGeos = new list<iGeoLocate__c>();
List<Match__c> lstRelatedMatches = new list<Match__c>();
List<Intrax_Program_Upload__c> lstRelatedIPUs = new list<Intrax_Program_Upload__c>();
 Public User DummyObj=new User();
  public User getDummyObj() { return DummyObj; }
List<Assessment__c> lstRelatedMatchAss = new list<Assessment__c>();
 public String retParam {get;set;}

      public ReAssign_Owner_Controller(ApexPages.StandardController controller) {
        
                 //Get match Id
            objPosition = (Position__c)controller.getRecord();
           // position  = [Select p.Type__c, p.RecordTypeId, p.Owner.Name, p.Owner.LastName, p.Owner.Username, p.OwnerId, p.Name, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c, p.Functional_Areas_Other__c, p.Earliest_End__c From Position__c p where p.Id =:objPosition.Id  limit 1];
            position = [Select p.RecordType.DeveloperName, p.RecordType.Name, p.RecordType.Id, p.RecordTypeId, p.Owner.Name, p.Owner.Id, p.OwnerId, p.Name, p.Id, p.Host_Opportunity_Id__r.OwnerId, p.Host_Opportunity_Id__r.Name, p.Host_Opportunity_Id__r.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__r.OwnerId, p.Host_Company_Id__r.Name, p.Host_Company_Id__r.MasterRecordId, p.Host_Company_Id__r.Id, p.Host_Company_Id__c, p.Engagement__r.Name, p.Engagement__r.OwnerId, p.Engagement__r.Id, p.Engagement__c, (Select Id, OwnerId, Name From iGeoLocate__r), (Select Id, Name From Matches__r), (Select Id, OwnerId, Name From Intrax_Program_Uploads__r), (Select Id, OwnerId, Name From Position_Assessments__r), (Select Id, OwnerId, Name From Applicant_Info__r) From Position__c p where p.Id=:objPosition.Id Limit 1] ; 
            //retParam = '/' + position.Id + '/a?returl=/apex/reassign_owner?id=' + position.Id ;
             system.debug('***position*****'+position);
               system.debug('***retParam*****'+retParam);
          
       }
     public PageReference save(){
     		position.OwnerId = DummyObj.Dummy_LookUp__c;
        upsert position;
        system.debug('*****position********'+position);
        ChangeRelatedOwners();
        return new PageReference('/'+position.Id);
    }
       public void ChangeRelatedOwners()
       {
        lstRelatedHostAcc = [Select a.OwnerId From Account a where a.Id =:position.Host_Company_Id__r.Id];
        system.debug('*****lstRelatedHostAcc********'+lstRelatedHostAcc);    
         if(lstRelatedHostAcc!=null && lstRelatedHostAcc.size()>0)
         {
         	For(Account acc : lstRelatedHostAcc)
         	{
         		acc.OwnerId  = position.OwnerId;
         	}
         	update lstRelatedHostAcc;
         }
          system.debug('*****lstRelatedHostAcc********'+lstRelatedHostAcc); 
         
         lstRelatedAppInfo = [Select a.OwnerId From Applicant_Info__c a where a.Position__c =:position.Id]; 
          system.debug('*****lstRelatedAppInfo********'+lstRelatedAppInfo);    
         if(lstRelatedAppInfo!=null && lstRelatedAppInfo.size()>0)
         {
         	For(Applicant_Info__c app : lstRelatedAppInfo)
         	{
         		app.OwnerId  = position.OwnerId;
         	}
         	update lstRelatedAppInfo;
         }
          system.debug('*****lstRelatedAppInfo********'+lstRelatedAppInfo); 
          
          lstRelatedAss = [Select a.OwnerId From Assessment__c a where a.Position_Name__c  =:position.Id and a.RecordTypeId !=: Constants.ASS_AY_HF_Validation]; 
          system.debug('*****lstRelatedAss********'+lstRelatedAss);    
         if(lstRelatedAss!=null && lstRelatedAss.size()>0)
         {
         	For(Assessment__c ass : lstRelatedAss)
         	{
         		ass.OwnerId  = position.OwnerId;
         	}
         	update lstRelatedAss;
         }
          system.debug('*****lstRelatedAss********'+lstRelatedAss); 
           Map<Id,Engagement__c> MapEngToBeUpdated = new Map<Id,Engagement__c>();
           //Defect D-01024 (Start)
          lstRelatedMatches = [Select m.Status__c, m.Position_Name__c, m.Id, m.Engagement__c From Match__c m where m.Position_Name__c=:position.Id AND Status__c = 'Confirmed'];
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
			         		eng.OwnerId  = position.OwnerId;
			         		MapEngToBeUpdated.put(eng.Id,eng);
			         	}
			         
			         }
          		}
          	}
          	 List<Engagement__c> lstEngUpdate = new List<Engagement__c>();
          	 If(MapEngToBeUpdated!=null)
          	 {
                Set<id> EngIds = MapEngToBeUpdated.keySet() ;
                system.debug('****EngIds******'+EngIds);
                system.debug('****MapEngToBeUpdated******'+MapEngToBeUpdated);
                For(Id engId:EngIds)
                {
                Engagement__c eng = new Engagement__c();
                eng = MapEngToBeUpdated.get(engId);
                system.debug('****eng******'+eng);
                lstEngUpdate.add(Eng);
                }
                system.debug('****lstEngUpdate******'+lstEngUpdate);
          	 }
               if( lstEngUpdate!=null &&  lstEngUpdate.size()>0)
               update  lstEngUpdate; 
          }
          
        /*  lstRelatedEng = [Select a.OwnerId From Engagement__c a where a.Id =:position.Engagement__c]; 
          system.debug('*****lstRelatedEng********'+lstRelatedEng);    
         if(lstRelatedEng!=null && lstRelatedEng.size()>0)
         {
         	For(Engagement__c eng : lstRelatedEng)
         	{
         		eng.OwnerId  = position.OwnerId;
         	}
         	update lstRelatedEng;
         }*/
         
           lstRelatedGeos = [Select a.OwnerId From iGeoLocate__c a where a.position__c =:position.Id]; 
          system.debug('*****lstRelatedGeos********'+lstRelatedGeos);    
         if(lstRelatedGeos!=null && lstRelatedGeos.size()>0)
         {
         	For(iGeoLocate__c igeo : lstRelatedGeos)
         	{
         		igeo.OwnerId  = position.OwnerId;
         	}
         	update lstRelatedGeos;
         }
          system.debug('*****lstRelatedGeos********'+lstRelatedGeos); 
          lstRelatedIPUs = [Select a.OwnerId From Intrax_Program_Upload__c a where a.position__c =:position.Id]; 
           system.debug('*****lstRelatedIPUs********'+lstRelatedIPUs);    
         if(lstRelatedIPUs!=null && lstRelatedIPUs.size()>0)
         {
         	For(Intrax_Program_Upload__c ipu : lstRelatedIPUs)
         	{
         		ipu.OwnerId  = position.OwnerId;
         	}
         	update lstRelatedIPUs;
         }
          system.debug('*****lstRelatedIPUs********'+lstRelatedIPUs); 
          
         system.debug('*****position - OwnerId********'+position.OwnerId);  
       }
    
       public pagereference Cancel()
       {
         return new PageReference('/' + position.Id);
       }
      
    
       
      
     
     
}