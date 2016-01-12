trigger Trigger_Campaign_Session on Campaign_Session__c (before update,after insert, after update) {
	Campaign_Session__Share camp_share=new Campaign_Session__Share();
    String flag;
	if(Trigger.isBefore){
	  if(Trigger.isUpdate){
	  	Set<Id> CampaignSessionIds = new set<Id>();
	  	for(Campaign_Session__c record: Trigger.new) {
       		 	if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null &&  record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) {       		 
               		CampaignSessionIds.add(record.Id);
       		 	}
             	system.debug('**CampaignSessionIds**'+CampaignSessionIds);
   		   }
   		   if(CampaignSessionIds!=null && CampaignSessionIds.size()>0) {
            flag='before';
            SharingSecurityHelper.persistSharingwithOwner(camp_share, flag, CampaignSessionIds);   
   		   }
   		   
	  }
	}

    if(Trigger.isAfter) {
    	boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    	string strCampName;
       Set<Id> CampSessionIds = new set<Id>();
      
        //Check for the event type
          if(Trigger.isInsert) {			
               for(Campaign_Session__c campSessionInfo : trigger.new)
               { 
               	system.debug('*****campSessionInfo******'+campSessionInfo);                
               	strCampName =   campSessionInfo.Name;  
              	 if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
			    	CampSessionIds.add(campSessionInfo.Id);
			    }
			    
			    if(CampSessionIds!=null)
			    {
			     system.debug('*****CampSessionIds******'+CampSessionIds); 			 
			     SharingSecurityHelper.shareCampSessions(CampSessionIds);			    	
			    }
			    }
			     if(Trigger.isUpdate) 
			     {
			     	 for(Campaign_Session__c campSessionInfo : trigger.new)
                     {
                     Id OldHCAccount = trigger.oldMap.get(campSessionInfo.Id).Host_Company_Name__c;
               	     Id NewHCAccount = trigger.newMap.get(campSessionInfo.Id).Host_Company_Name__c;  
               	     Id OldCampaign = trigger.oldMap.get(campSessionInfo.Id).Campaign__c;
               	     Id NewCampaign = trigger.newMap.get(campSessionInfo.Id).Campaign__c;  
              		 	system.debug('*****campSessionInfo******'+campSessionInfo);                
               			strCampName =   campSessionInfo.Name;  
                	if((OldHCAccount!=NewHCAccount && NewHCAccount!=null) || (OldCampaign!=NewCampaign && NewCampaign!=null))
                	{
              	    if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
			    	CampSessionIds.add(campSessionInfo.Id);
			          }
                    }
                // ManualSharing - Ownership change
            
               if(!(blnDeployTestFlag))
               { 
                 set<Id> allshareIDs = new set<Id>();
                 for(Campaign_Session__c shr: Trigger.new)
                 {
                   if(Trigger.oldMap!=null && Trigger.oldMap.get(shr.Id).OwnerId!=null &&  shr.OwnerId != Trigger.oldMap.get(shr.Id).OwnerId) {
                    allshareIDs.add(shr.id);
                   }  
                 }
                 if(allshareIDs != NULL && allshareIDs.size()>0)
                  {
                	flag='after';
                	SharingSecurityHelper.persistSharingwithOwner(camp_share, flag, allshareIDs);    
                  }
                } 
                     
                       	
			    if(CampSessionIds!=null)
			    {
			     system.debug('*****CampSessionIds******'+CampSessionIds); 			 
			     SharingSecurityHelper.shareCampSessions(CampSessionIds);			    	
			    }
			    
			     	
			     	
			     }
    
    }
}