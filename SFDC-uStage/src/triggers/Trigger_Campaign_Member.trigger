trigger Trigger_Campaign_Member on CampaignMember (before update,before insert) {
 if(Trigger.isBefore) {
 	 Lead objLead ;
 	 Contact objContact;
 	  string old_Status ;
 	  string new_Status;
 	 List<Lead> lstLeadToBeUpdated;
 	 List<Contact> lstContactToBeUpdated;
 	  Map<Id,Lead> mapLeadToBeUpdated=new Map<Id,Lead>();
 	 Map<Id,Contact> mapContactToBeUpdated = new Map<Id,Contact>();
 	 
    if(Trigger.isUpdate || Trigger.isInsert) {
            for(CampaignMember campMem:trigger.new){ 
            	if(trigger.oldMap!=null)                    
                  old_Status = trigger.oldMap.get(campMem.Id).status;
                if(trigger.newMap!=null) 
                  new_Status = trigger.newMap.get(campMem.Id).status;
                   system.debug('********Inside Trigger old_Status******'+old_Status);   
                   system.debug('********Inside Trigger new_Status******'+new_Status);  
             if(campMem.LeadId!=null)
               objLead = [Select l.Sys_Event_SLEP__c, l.Sys_Event_Interview__c, l.Sys_Event_ID__c, l.Sys_Event_Guests__c, l.Id, l.Info_Event__c,
                          l.Countries_of_Interest__c,l.Gender__c, l.Intrax_Programs__c From Lead l where l.Id=:campMem.LeadId];
             if(campMem.ContactId!=null)
               objContact =[Select c.Sys_Event_SLEP__c, c.Sys_Event_Interview__c, c.Sys_Event_ID__c, c.Sys_Event_Guests__c, c.Id, c.Gender__c From Contact c where c.Id = :campMem.ContactId];
              if(objLead != null)
                {
                   //system.debug('********Inside mapping******'+objLead.Countries_of_Interest__c+'  '+objLead.Intrax_Programs__c+' '+objLead.Gender__c);   
                   if(objLead.Countries_of_Interest__c != null)
                   {
                    campMem.Countries_of_Interest__c = objLead.Countries_of_Interest__c+';'; 
                   }
                   if(objLead.Intrax_Programs__c != null){
                   campMem.Intrax_Programs__c = objLead.Intrax_Programs__c+';';
                   }
                   campMem.Gender__c = objLead.Gender__c;
                }    
                // EU 81
                if(campMem.Status == 'Attended' && objLead != null){
                	Campaign c = [SELECT Id, Event_Type__c, Event_Start__c FROM Campaign WHERE Id=: campMem.CampaignId];
                	if(c.Event_Type__c == 'Info Session'){
                		objLead.Info_Event__c = c.Event_Start__c;
                		//lstLeadToBeUpdated.add(objLead);
                	    mapLeadToBeUpdated.put(objLead.Id,objLead);
                	}
                }
                
                //B-03090
        	 	if(objContact!=null && objContact.Gender__c!=null)
        	 		 campMem.Gender__c = objContact.Gender__c;
                
                if((old_Status!=null && old_Status!=new_Status && new_Status=='Registered') || campMem.Status=='Registered')
                {
                if(objContact!=null && objContact.Sys_Event_ID__c == campMem.CampaignId)
                {
                	 	  system.debug('********Inside Trigger condition objContact******');  
                	 	if(objContact.Sys_Event_Guests__c!=null)
                	 	   	 campMem.Guests__c = objContact.Sys_Event_Guests__c;
                	 	if(objContact.Sys_Event_SLEP__c!=null)
                	 	   	 campMem.SLEP_Test_Desired__c = objContact.Sys_Event_SLEP__c;
                	 	if(objContact.Sys_Event_Interview__c!=null)
                	 	   	 campMem.Interview_Desired__c = objContact.Sys_Event_Interview__c;                 	 	
                	 	objContact.Sys_Event_ID__c  = NULL;
                        objContact.Sys_Event_Guests__c = NULL;
                        objContact.Sys_Event_SLEP__c = NULL;
                        objContact.Sys_Event_Interview__c = NULL;  
                        //lstContactToBeUpdated.add(objContact);
                        	mapContactToBeUpdated.put(objContact.Id,objContact);              	 
                }		
                else if(objLead!=null && objLead.Sys_Event_ID__c == campMem.CampaignId)
                {
                	 	  system.debug('********Inside Trigger condition objLead******');  
                	 	if(objLead.Sys_Event_Guests__c!=null)
                	 	   	 campMem.Guests__c = objLead.Sys_Event_Guests__c;                	 	
                	 	if(objLead.Sys_Event_SLEP__c!=null)
                	 	   	 campMem.SLEP_Test_Desired__c = objLead.Sys_Event_SLEP__c;
                	 	if(objLead.Sys_Event_Interview__c!=null)
                	 	   	 campMem.Interview_Desired__c = objLead.Sys_Event_Interview__c;  
                	 	objLead.Sys_Event_ID__c  = NULL;
                        objLead.Sys_Event_Guests__c = NULL;
                        objLead.Sys_Event_SLEP__c = NULL;
                        objLead.Sys_Event_Interview__c = NULL; 
                        //lstLeadToBeUpdated.add(objLead);
                        mapLeadToBeUpdated.put(objLead.Id,objLead);  
                          
                                   	  
                }		
                
                   campMem.Sys_Registration_Reset__c = datetime.now();
                }
               if(mapContactToBeUpdated!=null && mapContactToBeUpdated.size()>0)
               {
				Set<id> ConIds = mapContactToBeUpdated.keySet() ;	
				lstContactToBeUpdated = new List<Contact>();			
				For(Id conId:ConIds)
				{
				Contact con = new Contact();
				con = mapContactToBeUpdated.get(conId);				
				lstContactToBeUpdated.add(con);
				}
               }
               if(mapLeadToBeUpdated!=null && mapLeadToBeUpdated.size()>0)
               {
				Set<id> LeadIds = mapLeadToBeUpdated.keySet() ;				
				system.debug('**LeadIds****'+LeadIds);
				lstLeadToBeUpdated=new List<Lead>();
				For(Id leadId:LeadIds)
				{
					system.debug('**LeadId****'+leadId);
				Lead newlead = new Lead();
				newlead = mapLeadToBeUpdated.get(leadId);			
				system.debug('**newlead****'+newlead);
				lstLeadToBeUpdated.add(newlead);
					system.debug('**lstLeadToBeUpdated****'+lstLeadToBeUpdated);
				}
					system.debug('**lstLeadToBeUpdated-out****'+lstLeadToBeUpdated);
               }
               if(lstContactToBeUpdated!=null && lstContactToBeUpdated.size()>0)
               update lstContactToBeUpdated;      
               if(lstLeadToBeUpdated!=null && lstLeadToBeUpdated.size()>0)
               update lstLeadToBeUpdated;    
            }
    }
 }
}