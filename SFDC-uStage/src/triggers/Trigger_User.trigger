trigger Trigger_User on User (before update,after update) {
   
    if(trigger.isBefore){
        Set<Id> lstUserIds = new set<Id>();
        Set<String> lstUserIntraxIds = new set<String>();
        boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
        if(trigger.isUpdate){
            
            for(User ObjUser: Trigger.new){
                 string strUserName = ObjUser.Name;
                 boolean blnOldManualShare = trigger.oldMap.get(ObjUser.Id).ManualShareExists__c;
                 boolean blnNewManualShare = trigger.newMap.get(ObjUser.Id).ManualShareExists__c;
                 if(blnOldManualShare!=blnNewManualShare && blnNewManualShare) 
                 {
                    if(!(blnDeployTestFlag))
                    {
                     lstUserIds.add(ObjUser.Id); 
                     lstUserIntraxIds.add(ObjUser.Intrax_Id__c);
                    }   
                 }
                 
               }
                     if(lstUserIds!=null && lstUserIds.size()>0)
                     SharingSecurityHelper.shareStandardUser(lstUserIds,lstUserIntraxIds);
               
                     
        } 
        }
    
}