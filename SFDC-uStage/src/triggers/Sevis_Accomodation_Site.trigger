trigger Sevis_Accomodation_Site on Accommodation_Site__c (after update) {
    if(trigger.isAfter){
        if(trigger.isUpdate){   
            for (Accommodation_Site__c newValues : Trigger.new){
                if (newValues.Sevis_UEV_Val_USAdd__c == true ){
                    //Get Accomodation
                    List<Accommodation__c> acco = [Select Id,Engagement__c from Accommodation__c where Accommodation_Site__c = :newValues.Id];
                    //Get Engagement
                    List<Engagement__c> updateEVengagements = new List<Engagement__c>(); 
                    for (Accommodation__c acc : acco ){
                        List<Engagement__c> engagements = [select Id,Sevis__c,Sevis_UEV_SOA_Add__c from Engagement__c e where 
                        e.Intrax_Program__c in ('Ayusa','Internship','Work Travel') and e.Sevis__c != NULL and e.Id = :acc.Engagement__c ];
                        if (engagements.size() > 0){
                        	for (Engagement__c engagement : engagements){
                            	engagement.Sevis_UEV_U_USAdd__c =  true;
                            	updateEVengagements.add(engagement);
                        	}
                        }
                    }
                    if (updateEVengagements.size() > 0)
                        update updateEVengagements;
                }
            }           
        }
    } 
}