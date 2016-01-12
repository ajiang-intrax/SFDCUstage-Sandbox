trigger Sevis_Account on Account (after update) {
    //I have to exclude this trigger if Auto Sync Application.
    if(TriggerExclusion.isTriggerExclude('Account')){
        return;
    }
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
            List<Engagement__c> updateEVengagements = new List<Engagement__c>();
            for (Account newValues : Trigger.new){
                if(Trigger.oldMap!=null && Trigger.oldMap.get(newValues.Id).OwnerId!=null &&  newValues.OwnerId != Trigger.oldMap.get(newValues.Id).OwnerId) 
                {
                        //do nothing.  Excluding this trigger when Owner changes.
                }
                else{
                
                if (newValues.Sevis_UEV_Bio__c == true){
                    //Only one?
                    List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_Bio__c from Engagement__c e where 
                    e.Intrax_Program__c in ('Ayusa','Internship','Work Travel','AuPairCare') and e.Sevis__c != NULL and e.Account_Id__c = :newValues.Id ];
                    for (Engagement__c engagement : engagements){
                        engagement.Sevis_UEV_Bio__c =  true;
                        updateEVengagements.add(engagement);
                    }
                }
                if (newValues.Sevis_UEV_SOA_Edit__c == true){
                    
                        List<Match__c> matches = [select Id,Engagement__c from Match__c where School_Id__c = :newValues.Id and Status__c = 'Confirmed'];
                        if (matches != NULL && matches.size() > 0)
                        {
                            set<ID> EnggIDFList = new set<ID>();
                            
                            for (Match__c match : matches)
                            {
                                if (match.Engagement__c != NULL)
                                {
                                    EnggIDFList.add(match.Engagement__c);
                                }
                            }
                            
                            if (EnggIDFList != NULL && EnggIDFList.size() > 0)
                            {
                                List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_SOA_Edit__c from Engagement__c e where 
                                e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id IN :EnggIDFList ];
                                
                                if(engagements != NULL && engagements.size() > 0)
                                {
                                    for (Engagement__c engagement : engagements)
                                    {
                                        engagement.Sevis_UEV_SOA_Edit__c =  true;
                                        updateEVengagements.add(engagement);
                                    }
                                }
                            }
                        }
                        
                       /* for (Match__c match : matches){
                            List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_SOA_Edit__c from Engagement__c e where 
                            e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id = :match.Engagement__c ];
                            for (Engagement__c engagement : engagements){
                                engagement.Sevis_UEV_SOA_Edit__c =  true;
                                updateEVengagements.add(engagement);
                            }
                        }*/
                    }
                // when host family's address changes, it should trigger an US address SEVIS update for related engagements    
                if (newValues.Sevis_UEV_U_USAdd__c == true){
                    List<Position__c> positions = [select Id from Position__c where Host_Company_Id__c = :newValues.Id];
                    
                    if (positions != NULL && positions.size() > 0)
                    {
                        List<Match__c> matches = [select Id,Engagement__c from Match__c where Position_Name__c IN :positions and Status__c = 'Confirmed'];
                        
                        if (matches != NULL && matches.size() > 0)
                        {
                            set<ID> EnggIDList = new set<ID>();
                            for (Match__c match : matches)
                            {
                                if (match.Engagement__c != NULL)
                                {
                                    EnggIDList.add(match.Engagement__c);
                                }
                            }
                            if (EnggIDList != NULL && EnggIDList.size() > 0)
                            {
                                List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_U_USAdd__c, Sevis_UEV_SOA_Edit__c, Intrax_Program__c from Engagement__c e where 
                                e.Intrax_Program__c in ('Ayusa','AuPairCare') and e.Sevis__c != NULL and e.Id IN :EnggIDList ];
                                
                                if (engagements != NULL && engagements.size() > 0)
                                {
                                    for (Engagement__c engagement : engagements)
                                    {
                                        if(engagement.Intrax_Program__c == 'AuPairCare')
                                        {
                                            if (Trigger.oldMap.get(newValues.Id).BillingCity !=  Trigger.newMap.get(newValues.Id).BillingCity || Trigger.oldMap.get(newValues.Id).BillingPostalCode !=  Trigger.newMap.get(newValues.Id).BillingPostalCode || Trigger.oldMap.get(newValues.Id).BillingState !=  Trigger.newMap.get(newValues.Id).BillingState || Trigger.oldMap.get(newValues.Id).BillingStreet !=  Trigger.newMap.get(newValues.Id).BillingStreet)
                                            {
                                                engagement.Sevis_UEV_U_USAdd__c =  true;
                                            }
                                            engagement.Sevis_UEV_SOA_Edit__c =  true;
                                            updateEVengagements.add(engagement);
                                        }
                                        else
                                        {
                                            engagement.Sevis_UEV_U_USAdd__c =  true;
                                            updateEVengagements.add(engagement);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                   /* for (Position__c position : positions){
                        List<Match__c> matches = [select Id,Engagement__c from Match__c where Position_Name__c = :position.Id and Status__c = 'Confirmed'];
                        for (Match__c match : matches){
                            List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_SOA_Edit__c from Engagement__c e where 
                            e.Intrax_Program__c in ('Ayusa') and e.Sevis__c != NULL and e.Id = :match.Engagement__c ];
                            for (Engagement__c engagement : engagements){
                                engagement.Sevis_UEV_U_USAdd__c =  true;
                                updateEVengagements.add(engagement);
                            }
                        }
                    }*/
                }
                
                
                if (updateEVengagements.size() > 0)
                    update updateEVengagements;
                }
            }   
        }
    }   
}