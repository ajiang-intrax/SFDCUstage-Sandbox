trigger Trigger_Campaign_Position on Campaign_Position__c (after insert, after update) {

    if(Trigger.isAfter) {
    	  boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    	string strCampName;
       Set<Id> CampPosIds = new set<Id>();
      
        //Check for the event type
          if(Trigger.isInsert) {			
               for(Campaign_Position__c campPosInfo : trigger.new)
               { 
               	system.debug('*****campPosInfo******'+campPosInfo); 
               
               	strCampName =   campPosInfo.Name;  
               	if(campPosInfo.Campaign__c !=null)
               	{     
               		Campaign c = [SELECT Partner_Name__c FROM Campaign WHERE Id =: campPosInfo.Campaign__c limit 1];    
               		system.debug('***** campPosInfo.Campaign__r.Partner_Name__c: ' + campPosInfo.Campaign__r.Partner_Name__c);
               		system.debug('***** c.Partner_Name__c: ' + c.Partner_Name__c);	           		
                //if(campPosInfo.Campaign__r.Partner_Name__c!=null)
                if(c.Partner_Name__c != null)
			    {
			    	 if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
			    	CampPosIds.add(campPosInfo.Id);
			    }
			    }}
			    if(CampPosIds!=null)
			    {
			    	  	system.debug('*****CampPosIds******'+CampPosIds); 
			    // if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
			     SharingSecurityHelper.shareCampaignPosition(CampPosIds);			    	
			    }
			    }
	         if(Trigger.isUpdate) {			
               for(Campaign_Position__c campPosInfo : trigger.new)
               {
               	 	system.debug('*****campPosInfo******'+campPosInfo); 
               	Id OldCampaign = trigger.oldMap.get(campPosInfo.Id).Campaign__c;
               	Id NewCampaign = trigger.newMap.get(campPosInfo.Id).Campaign__c;             
               	strCampName =   campPosInfo.Name;           	           		
                if(OldCampaign!=NewCampaign && NewCampaign!=null)
			    {
			        if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
			    	CampPosIds.add(campPosInfo.Id);
			    }
               }  
                if(CampPosIds!=null)
			    {
			    	 	system.debug('*****CampPosIds******'+CampPosIds); 
			   //  if(!(blnDeployTestFlag && strCampName.containsIgnoreCase('Test')))
			     SharingSecurityHelper.shareCampaignPosition(CampPosIds);			    	
			    }
			    }
			    }
}