trigger Trigger_Campaign on Campaign (after Insert,after update,before update) {
    CampaignShare cmp_share=new CampaignShare();
    String flag;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
	if(Trigger.isBefore){
	  if(Trigger.isUpdate){
	  	Set<Id> cmpShareIds = new set<Id>();
	  	for(Campaign record: Trigger.new) {
       		 	if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null &&  record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) {       		 
               		cmpShareIds.add(record.Id);
       		 	}
             	system.debug('**cmpShareIds**'+cmpShareIds);
   		   }
   		   if(cmpShareIds!=null && cmpShareIds.size()>0) {
            flag='before';
            SharingSecurityHelper.persistSharingwithOwner(cmp_share, flag, cmpShareIds);   
   		   }
	  }
	} 
 if(Trigger.isAfter) {
    	 
    	string strCampName;
       Set<Id> CampIds = new set<Id>();
       Map<Id,Id> MapCampaignIds = new  Map<Id,Id>();
        if(Trigger.isInsert) {
          	for(Campaign camp : trigger.new)
          	{          
          			strCampName = camp.Name;
          			if(camp.Partner_Name__c !=null)
			        {
			           	 if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
				       	  MapCampaignIds.put(camp.Id,camp.Partner_Name__c);				       
			        }			    	
			 }
			 if(MapCampaignIds!=null)
			 {			 
			     SharingSecurityHelper.shareCampaign(MapCampaignIds);		
			 }   
          	}
        //Check for the event type
          if(Trigger.isUpdate) {
          	for(Campaign camp : trigger.new)
          	{          
          			strCampName = camp.Name;
          			Id OldPartner = trigger.oldMap.get(camp.Id).Partner_Name__c;
               		Id NewPartner = trigger.newMap.get(camp.Id).Partner_Name__c;   
               		if(OldPartner!=NewPartner && NewPartner!=null)
			        {
			         if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
			       	 MapCampaignIds.put(camp.Id,NewPartner);	
			         List<Campaign_Position__c> lstCampPos = [Select c.Position__r.Host_Company_Id__c, c.Position__r.Name, c.Position__r.Id, c.Position__c, c.Partner_Id__c, c.Name, c.Id, c.Company_Name__c, c.Campaign__r.Type, c.Campaign__r.Name, c.Campaign__r.Id, c.Campaign__c From Campaign_Position__c c where c.Campaign__c = :camp.Id];	
				       For(Campaign_Position__c campPos : lstCampPos)
				       {
				       	 if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
				       	  CampIds.add(campPos.Id);
				       }
			        }			    	
			 }
			 if(MapCampaignIds!=null)
			  SharingSecurityHelper.shareCampaign(MapCampaignIds);
			 if(CampIds!=null)
			 {			 
			     SharingSecurityHelper.shareCampaignPosition(CampIds);		
			 } 
             // ManualSharing - Ownership change
            
               if(!(blnDeployTestFlag))
               { 
                 set<Id> allshareIDs = new set<Id>();
                 for(Campaign shr: Trigger.new)
                 {
                  if(Trigger.oldMap!=null && Trigger.oldMap.get(shr.Id).OwnerId!=null &&  shr.OwnerId != Trigger.oldMap.get(shr.Id).OwnerId) {
                    allshareIDs.add(shr.id);
                  }
                  }
                 if(allshareIDs != NULL && allshareIDs.size()>0)
                  {
                	flag='after';
                	SharingSecurityHelper.persistSharingwithOwner(cmp_share, flag, allshareIDs);    
                  }
                } 
          	}
          }			
              

}