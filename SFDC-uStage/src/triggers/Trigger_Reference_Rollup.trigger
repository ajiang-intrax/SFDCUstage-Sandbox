trigger Trigger_Reference_Rollup on Reference__c (after insert, after update , after delete,after undelete) {
    
    List <Id> posIds = new List<Id> ();
    List <Id> AppIds = new List<Id> ();
    List <Position__c> position = new List<Position__c>();
    List <Applicant_Info__c> Application = new List<Applicant_Info__c>();
    List <AggregateResult> reference = new List<AggregateResult>();
      
    if(!trigger.isdelete){
        for(Reference__c req:trigger.new){
            if(req.Position__c != null){
            posIds.add(req.Position__c);
            //AppIds.add(req.Applicant_Info__c);
            
            If(req.Position__c==null)
            posIds.add(Trigger.oldMap.get(req.id).Position__c);
            
            //If(req.Applicant_Info__c==null)
            //AppIds.add(Trigger.oldMap.get(req.id).Applicant_Info__c);
            
            //system.debug('debug::Value= '+posIds);
            }
        }
    }
    else{
        for(Reference__c req:trigger.old){
            {
            posIds.add(req.Position__c);
            //AppIds.add(req.Applicant_Info__c);
            }
        }
    }
    
    If(posIds.size()>0){
        position = [Select Id, Approved_Ref_Count__c From Position__c Where Id In :posIds];
        reference = [Select Position__c, Count(Id) From Reference__c Where Position__c IN: (posIds) 
        AND Status__c IN ('Confirmed')
        Group By Position__c];
        for(AggregateResult ar: reference){
            for(Position__c p:position){
                if(ar.get('Position__c') == p.Id){
                    p.Approved_Ref_Count__c= Decimal.ValueOf(String.ValueOf(ar.get('expr0')));
                }
            }
        }
        update(position);
    }
    /*
    If(AppIds.size()>0){
        Application = [Select Id, Approved_Ref_Count__c From Applicant_Info__c Where Id In :AppIds];
        reference = [Select Applicant_Info__c, Count(Id) From Reference__c Where Applicant_Info__c IN: (AppIds) 
        AND Status__c IN ('Confirmed')
        Group By Applicant_Info__c];
        System.debug('debug::APP '+Application);
        System.debug('debug::Ref '+reference);
        for(AggregateResult ar: reference){
            for(Applicant_Info__c app:Application){
                if(ar.get('Applicant_Info__c') == app.Id){
                    app.Approved_Ref_Count__c= Decimal.ValueOf(String.ValueOf(ar.get('expr0')));
                }
            }
        }
        update(Application);
    }       
*/

	if(Trigger.isAfter)
	{
		if(Trigger.isUpdate)
		{
			list<RecordType> RClist = [select id, Name from RecordType where SobjectType='Reference__c' and Name='APC HF' Limit 1];
			
			for(Reference__c APCreq:trigger.new)
			{
				integer RefApprovalCnt = 0;
				if (APCreq.Status__c == 'Confirmed' && APCreq.RecordTypeId == RClist[0].Id && APCreq.Applicant_Info__c != NULL)
				{
					list<Reference__c> ApcRfCntLst = [SELECT Status__c FROM Reference__c WHERE Applicant_Info__c =: APCreq.Applicant_Info__c];
					
					if (ApcRfCntLst.size() > 0)
					{
						for (Reference__c SingleRef : ApcRfCntLst)
						{
							if(SingleRef.Status__c == 'Confirmed')
							{
								RefApprovalCnt = RefApprovalCnt+1;
							}
						}
						if (RefApprovalCnt >= 2)
						{
							list<Applicant_Info__c> ApcAppList = [SELECT PageStatus_Complete__c FROM Applicant_Info__c WHERE Id =: APCreq.Applicant_Info__c];
							if(ApcAppList.size() > 0)
							{
								 if(ApcAppList[0].PageStatus_Complete__c != NULL && !(ApcAppList[0].PageStatus_Complete__c.contains('009')) )
					            {
					                if(ApcAppList[0].PageStatus_Complete__c != null && ApcAppList[0].PageStatus_Complete__c != '')
					                {
					                    ApcAppList[0].PageStatus_Complete__c = ApcAppList[0].PageStatus_Complete__c + ';009'; 
					                }
					                else
					                {
					                    ApcAppList[0].PageStatus_Complete__c = '009'; 
					                }
					                update ApcAppList[0];
					            }
					            else
					            {
					                if (ApcAppList[0].PageStatus_Complete__c == NULL)
					                {
					                    ApcAppList[0].PageStatus_Complete__c = '009';
					                    update ApcAppList[0];
					                }
					            }
							}
						}
					}
				}
			}
		} 
	}
}