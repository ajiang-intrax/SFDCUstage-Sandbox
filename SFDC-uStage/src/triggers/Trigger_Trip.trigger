trigger Trigger_Trip on Trip__c (after insert,after update,after delete) {
    /*Related to story 685*/
    
    Set<Id> newArrEngIds = new Set<Id>();
    Set<Id> newDepEngIds = new Set<Id>();
    
    if(Trigger.isAfter) 
    {
    	//if(Trigger.isInsert || Trigger.isUpdate){
    if(Trigger.isUpdate){
    for(Trip__c t:Trigger.new){
        
        if(t.Type__c == NULL)  
        {      
        List<Trip__c> relatedTrips = [SELECT Id,Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c FROM Trip__c WHERE Engagement__c=:t.Engagement__c];
        
        for(Trip__c trip:relatedTrips){
            if(trip.Arrival_to_Host_Community__c){
                for(Trip__c tripAgain:relatedTrips){
                    if(tripAgain.Arrival_to_Host_Country__c){
                        newArrEngIds.add(t.Engagement__c);   
                    }   
                }
            }
        }
        
        List<Engagement__c> ArrEngList = [SELECT Id,Arrival_Trip_Needed__c FROM Engagement__c WHERE Id IN: newArrEngIds];
        if(ArrEngList.size()>0){
            for(Engagement__c eng:ArrEngList){
                eng.Arrival_Trip_Needed__c = 'No';
            }
            update ArrEngList;    
        }
        else{
            List<Engagement__c> ArrEngListYes = [SELECT Id,Arrival_Trip_Needed__c FROM Engagement__c WHERE Id=:t.Engagement__c];
            if(ArrEngListYes.size()>0){
                for(Engagement__c eng:ArrEngListYes){
                    eng.Arrival_Trip_Needed__c = 'Yes';
                }
                update ArrEngListYes;    
            }
        }
        
        for(Trip__c trip:relatedTrips){
            if(trip.Departure_from_Host_Community__c==TRUE){
                newDepEngIds.add(t.Engagement__c);    
            }
        }
        
        List<Engagement__c> DepEngList = [SELECT Id,Departure_Trip_Needed__c FROM Engagement__c WHERE Id IN: newDepEngIds];
        System.debug('size-------'+depenglist.size());
        if(DepEngList.size()>0){
            for(Engagement__c eng:DepEngList){
                eng.Departure_Trip_Needed__c = 'No';
            }
            update DepEngList;    
        }  
        else{
            List<Engagement__c> DepEngListYes = [SELECT Id,Departure_Trip_Needed__c FROM Engagement__c WHERE Id=:t.Engagement__c];
            if(DepEngListYes.size()>0){
                for(Engagement__c eng:DepEngListYes){
                    eng.Departure_Trip_Needed__c = 'Yes';
                }
                update DepEngListYes;    
            }
        }
    }  
    }
    
    }
    
	}
	
    if(Trigger.isAfter) 
    {
    	if(Trigger.isInsert)
    	{
    		for(Trip__c nTrip:Trigger.new)
    		{
    			if(nTrip.Type__c == NULL)  
    			{
    			list <Notification__c> TripNot = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c = :nTrip.Engagement__c AND Type__c ='Travel Info Needed' AND Status__c = 'Not Started'];
    			if (TripNot != NULL && TripNot.size() > 0)
    			{
    				for (Notification__c notfc : TripNot)
    				{
    					notfc.Status__c = 'Confirmed';
    				}
    				update TripNot;
    			}
    			
    			
    			list <Notification__c> DepTripNot = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c = :nTrip.Engagement__c AND Type__c ='Departure Info Needed' AND Status__c = 'Not Started'];
    			if (DepTripNot != NULL && DepTripNot.size() > 0)
    			{
    				for (Notification__c depnotfc : DepTripNot)
    				{
    					depnotfc.Status__c = 'Confirmed';
    				}
    				update DepTripNot;
    			}
    			}
    			
    		}
    	}
    }	
    
    if(Trigger.isDelete){
    
        for(Trip__c t:Trigger.old){
        
        if(t.Type__c == NULL)  
    	{
                
        List<Trip__c> relatedTrips = [SELECT Id,Arrival_to_Host_Community__c,Arrival_to_Host_Country__c,Departure_from_Host_Community__c FROM Trip__c WHERE Engagement__c=:t.Engagement__c];
        
        for(Trip__c trip:relatedTrips){
            if(trip.Arrival_to_Host_Community__c){
                for(Trip__c tripAgain:relatedTrips){
                    if(tripAgain.Arrival_to_Host_Country__c){
                        newArrEngIds.add(t.Engagement__c);   
                    }   
                }
            }
        }
        
        List<Engagement__c> ArrEngList = [SELECT Id,Arrival_Trip_Needed__c FROM Engagement__c WHERE Id IN: newArrEngIds];
        if(ArrEngList.size()>0){
            for(Engagement__c eng:ArrEngList){
                eng.Arrival_Trip_Needed__c = 'No';
            }
            update ArrEngList;    
        }
        else{
            List<Engagement__c> ArrEngListYes = [SELECT Id,Arrival_Trip_Needed__c FROM Engagement__c WHERE Id=:t.Engagement__c];
            if(ArrEngListYes.size()>0){
                for(Engagement__c eng:ArrEngListYes){
                    eng.Arrival_Trip_Needed__c = 'Yes';
                }
                update ArrEngListYes;    
            }
        }
        
        for(Trip__c trip:relatedTrips){
            if(trip.Departure_from_Host_Community__c==TRUE){
                newDepEngIds.add(t.Engagement__c);    
            }
        }
        
        List<Engagement__c> DepEngList = [SELECT Id,Departure_Trip_Needed__c FROM Engagement__c WHERE Id IN: newDepEngIds];
        System.debug('size-------'+depenglist.size());
        if(DepEngList.size()>0){
            for(Engagement__c eng:DepEngList){
                eng.Departure_Trip_Needed__c = 'No';
            }
            update DepEngList;    
        }  
        else{
            List<Engagement__c> DepEngListYes = [SELECT Id,Departure_Trip_Needed__c FROM Engagement__c WHERE Id=:t.Engagement__c];
            if(DepEngListYes.size()>0){
                for(Engagement__c eng:DepEngListYes){
                    eng.Departure_Trip_Needed__c = 'Yes';
                }
                update DepEngListYes;    
            }
        }
        }
    }
    
    }

}