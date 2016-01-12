trigger Trigger_Pay_Event on Pay_Event__c (before insert, after insert,
                                           before update, after update,
                                           before delete, after delete) {
    Pay_Event__Share pay_share=new Pay_Event__Share();
    String flag;
    boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
	if(Trigger.isBefore){
        if(Trigger.isInsert){
            //Complete new PE instance attr from Custom Settings, other defaults
           	Trigger_Pay_Event_Helper tpeh = new Trigger_Pay_Event_Helper(Trigger.old, Trigger.new);
            tpeh.completeNewPayEvents();
        }
        if(Trigger.isUpdate){
         Set<Id> PayEventIds = new set<Id>();
	  	 for(Pay_Event__c record: Trigger.new) {
       		 	if(Trigger.oldMap!=null && Trigger.oldMap.get(record.Id).OwnerId!=null &&  record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId) {       		 
               		PayEventIds.add(record.Id);
       		 	}
             	system.debug('**PayEventIds**'+PayEventIds);
   		   }
   		   if(PayEventIds!=null && PayEventIds.size()>0) {
            flag='before';
            SharingSecurityHelper.persistSharingwithOwner(pay_share, flag, PayEventIds);   
   		   }   
        }
        if(Trigger.isDelete){}
    }
    if (Trigger.isAfter){
        if(Trigger.isInsert){}
        if(Trigger.isUpdate){
             if(!(blnDeployTestFlag))
               { 
                 set<Id> allshareIDs = new set<Id>();
                 for(Pay_Event__c shr: Trigger.new)
                 {
                   if(Trigger.oldMap!=null && Trigger.oldMap.get(shr.Id).OwnerId!=null &&  shr.OwnerId != Trigger.oldMap.get(shr.Id).OwnerId)
                  {
                    allshareIDs.add(shr.id);
                  }
                 }
                 if(allshareIDs != NULL && allshareIDs.size()>0)
                  {
                	flag='after';
                	SharingSecurityHelper.persistSharingwithOwner(pay_share, flag, allshareIDs);    
                  }
                } 
        }
        if(Trigger.isDelete){}
    }
}