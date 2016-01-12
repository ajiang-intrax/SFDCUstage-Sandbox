trigger Trigger_Case on Case (after insert, before update, after update) {
   CaseShare case_share=new CaseShare();
    String flag;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
    if(Trigger.isBefore){
      if(Trigger.isUpdate){
        Set<Id> CaseShareIds = new set<Id>();
     
        for(Case record: Trigger.new) {
                if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null &&  record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) {                
                    CaseShareIds.add(record.Id);
                  //  system.debug(' before update Trigger.old'+Trigger.oldMap.get(record.Id).OwnerId+' Trigger.new'+record.OwnerId);
                }
                system.debug('**CaseShareIds**'+CaseShareIds);
           }
           if(CaseShareIds!=null && CaseShareIds.size()>0) {
            flag='before';
            SharingSecurityHelper.persistSharingWithOwner(case_share, flag, CaseShareIds);   
           }
           
      }
    }
    
  if(Trigger.isAfter){
   if(Trigger.isInsert){
    list<Id> caseIds = new List<Id>{};

    for (Case theCase:trigger.new) 
        caseIds.add(theCase.Id);
        
        list<Case> cases = new List<Case>{}; 
        for(Case c : [Select Id,RecordType.Name,OwnerId,Account.OwnerId,Type,Origin,RecordTypeId, Engagement__c, Engagement__r.Current_Accommodation_State__c from Case where Id in :caseIds]) {
            Database.DMLOptions dmo = new Database.DMLOptions();
            
            if(c.RecordTypeId == Constants.CASE_WT){
               system.debug('@@hiiii'+c.Engagement__r.Current_Accommodation_State__c);
                dmo.assignmentRuleHeader.useDefaultRule = true;
                c.setOptions(dmo);
            }
            if(c.RecordType.Name == 'Internship' && c.Origin == 'Web'){
                dmo.assignmentRuleHeader.useDefaultRule = true;
                c.setOptions(dmo);
            }
            //B-01931
            if(c.RecordType.Name == 'AuPairCare')
            {
             c.OwnerId = c.Account.OwnerId;
            }//B-01931
            cases.add(c);
        }

        Database.update(cases);
     } 
      if(Trigger.isUpdate){
          // ManualSharing - Ownership change
 
               if(!(blnDeployTestFlag))
               { 
                 set<Id> allshareIDs = new set<Id>();
                 for(Case record: Trigger.new)
                 {
                    if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null &&  record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) {                
                        allshareIDs.add(record.Id);
                     // system.debug('Trigger.old'+Trigger.oldMap.get(record.Id).OwnerId+' Trigger.new'+record.OwnerId);
                     }
                 }
                 if(allshareIDs != NULL && allshareIDs.size()>0)
                  {
                    flag='after';
                    SharingSecurityHelper.persistSharingWithOwner(case_share, flag, allshareIDs);    
                  }
               } 
      }
  }
  
  
}