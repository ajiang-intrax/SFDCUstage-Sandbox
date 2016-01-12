trigger Sevis_Position on Position__c (after update) {
if(TriggerExclusion.isTriggerExclude('Position')){
        return;
    }
Set<ID> setPositionId = new Set<ID>();
list<Engagement__c> lstToUpdate = new list<Engagement__c>();
List<Engagement__c> engagement = new List<Engagement__c>(); 
 set<String> setmatchEngId = new set<String>();
    if(Trigger.isAfter) {   
        if(trigger.isUpdate){   
            for (Position__c newValues : Trigger.new){
                if (newValues.Sevis_UEV_SOA_Edit__c){
                  system.debug('@@ adding positionid');
                  setPositionId.add(newValues.Id);
                 } 
                }
                //Get Match
                List<Match__c> matches = [select Id,Engagement__c from Match__c where Position_Name__c IN:setPositionId  and Status__c = 'Confirmed'];
                //Get Engagement
                
                
                if(matches!=null && matches.size()>0){
                for (Match__c match : matches){
                system.debug('@@ adding match.eng');
                    setmatchEngId.add(match.Engagement__c);
                 }
                 engagement = [select Id,Sevis__c,Sevis_UEV_SOA_Edit__c from Engagement__c e where e.Id IN :setmatchEngId ];
                }
                
                    if(engagement != null && engagement.size() > 0){
                        for(Engagement__c itrEngagement : engagement){
                            if (itrEngagement.Sevis__c != NULL){
                                system.debug('@@ doing update');
                                itrEngagement.Sevis_UEV_SOA_Edit__c =  true;
                                lstToUpdate.add(itrEngagement);
                            }
                        }
                    }               
               if (lstToUpdate.size() > 0){
                system.debug('@@ updating eng');
                update lstToUpdate;
               }
               
        }   
    }
}
/*trigger Sevis_Position on Position__c (after update) {
    if(Trigger.isAfter) {   
        if(trigger.isUpdate){   
            for (Position__c newValues : Trigger.new){
                if (newValues.Sevis_UEV_SOA_Edit__c == true ){
                    //Get Match
                    List<Match__c> matches = [select Id,Engagement__c from Match__c where Position_Name__c = :newValues.Id and Status__c = 'Confirmed'];
                    //Get Engagement
                    List<Engagement__c> engagements = new List<Engagement__c>(); 
                    for (Match__c match : matches){
                        List<Engagement__c> engagement = [select Id,Sevis__c,Sevis_UEV_SOA_Edit__c from Engagement__c e where e.Id = :match.Engagement__c ];
                        if(engagement.size() > 0){
                            if (engagement[0].Sevis__c != NULL){
                                engagement[0].Sevis_UEV_SOA_Edit__c =  true;
                                engagements.add(engagement[0]);
                            }
                        }
                    }
                    if (engagements.size() > 0)
                        update engagements;
                }
            }           
        }   
    }
}*/