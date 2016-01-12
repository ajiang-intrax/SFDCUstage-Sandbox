trigger Trigger_Accommodation on Accommodation__c (before insert) {
  
    if(trigger.isBefore){
        if(trigger.isInsert){   
            for (Accommodation__c acc : Trigger.new){
                acc.Is_Current__c = true;
               
                //Get all accomodations Accomodation records related to the Engagement
                List<Accommodation__c> accList = [Select Id,Engagement__c,Name, Is_Current__c  
                								from Accommodation__c 
                								where Engagement__c = :acc.Engagement__c
                								];
                								
                system.debug('****** Related acc size(): ' + accList.size());
                
                List<Accommodation__c> updateAccomodations = new List<Accommodation__c>(); 
                
                for (Accommodation__c a : accList ){                        
                    if (a.Id != acc.Id ){
                      a.Is_Current__c = false;
                      updateAccomodations.add(a);
                    }
                }
                if (updateAccomodations.size() > 0) update updateAccomodations;
                
            }           
        }
    }  

}