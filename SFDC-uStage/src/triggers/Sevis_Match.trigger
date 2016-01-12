trigger Sevis_Match on Match__c (after insert, after update, before update) {
  if(TriggerExclusion.isTriggerExclude('Match')){
        return;
    }
    if(trigger.isInsert || trigger.isUpdate ){ 
      /* set<Id> setEngId = new set<Id>();
      set<Id> setEngIds = new set<Id>();
      Map<Id,Engagement__c> mapEngRec;
      Map<Id,Engagement__c> mapEngRecs;
      List<Engagement__c> engagements = new List<Engagement__c>();
   
        for (Match__c newValues : Trigger.new){
           if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' )
           {
            if(newValues.Engagement__c !=null)
            {
             setEngId.add(newValues.Engagement__c);
            }
           }
           
           if(newValues.Intrax_Program__c =='Internship')
           {
            if ((trigger.oldMap.get(newValues.Id).ARO_Signed_TIPP__c != trigger.newMap.get(newValues.Id).ARO_Signed_TIPP__c) || (trigger.oldMap.get(newValues.Id).PT_Signed_TIPP__c != trigger.newMap.get(newValues.Id).PT_Signed_TIPP__c))
            {
             if(newValues.Engagement__c !=null)
             {
              setEngIds.add(newValues.Engagement__c);
             }
            }
           
           }
           
         }
      
       if (setEngId !=null && setEngId.size()>0)
       {
       
       mapEngRec = new Map<Id,Engagement__c>([select Id,Sevis__c,Sevis_UEV_SOA_Add__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id IN:setEngId ]);
               
       }
        if (setEngIds !=null && setEngIds.size()>0)
       {
       
       mapEngRecs = new Map<Id,Engagement__c>([select Id,Sevis__c,Sevis_UEV_SOA_Add__c, Sevis_UEV_SOA_Edit__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Internship') and e.Sevis__c != NULL and e.Id IN:setEngIds]);
               
       }
      */
     
        for (Match__c newValues : Trigger.new){
            if (newValues.Sevis_UEV_SOA_Add__c == true && newValues.Status__c == 'Confirmed' ){
                //Get Engagement
                List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_SOA_Add__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id = :newValues.Engagement__c ];
                /*
                if(mapEngRec!=null && newValues.Engagement__c !=null && mapEngRec.size()>0)
                {
                 if(mapEngRec.get(newValues.Engagement__c)!=null)
                 {
                  List<Engagement__c> engagements.add(mapEngRec.get(newValues.Engagement__c));
                  }
                 }                 
                 */
                if(engagements.size() > 0){
                    if (Trigger.isAfter){
                        engagements[0].Sevis_UEV_SOA_Add__c =  true;
                        engagements[0].Sevis_UEV_Nonstandard_SoA__c = false;
                        update engagements[0];
                    } 
                }
                else{
                    if(Trigger.isBefore){
                        newValues.SEVIS_UEV_SOA_Add__c = false;
                    }
                }
            }
            else if (Trigger.isAfter && Trigger.isUpdate && newValues.Intrax_Program__c =='Internship')
            {
                if ((trigger.oldMap.get(newValues.Id).ARO_Signed_TIPP__c != trigger.newMap.get(newValues.Id).ARO_Signed_TIPP__c) || (trigger.oldMap.get(newValues.Id).PT_Signed_TIPP__c != trigger.newMap.get(newValues.Id).PT_Signed_TIPP__c))
                {
                    List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_SOA_Add__c, Sevis_UEV_SOA_Edit__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Internship') and e.Sevis__c != NULL and e.Id = :newValues.Engagement__c ];
                     /*
                    if(mapEngRecs!=null && newValues.Engagement__c !=null && mapEngRecs.size()>0)
                    {
                     if(mapEngRecs.get(newValues.Engagement__c)!=null)
                     {
                      List<Engagement__c> engagements.add(mapEngRecs.get(newValues.Engagement__c));
                      }
                     }                 
                 */
                    
                    if(engagements.size() > 0)
                    {
                        engagements[0].Sevis_UEV_SOA_Edit__c = true; 
                        update engagements[0];
                    }
                }
            }
        }           
    }                     
}