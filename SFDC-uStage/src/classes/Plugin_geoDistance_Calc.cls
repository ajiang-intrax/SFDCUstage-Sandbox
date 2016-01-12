global class Plugin_geoDistance_Calc implements Process.Plugin,Database.AllowsCallouts{
	
	public decimal distance {get; set;}
    public String measurement {get; set;}
    public String timex {get; set;}
    public String timeUnit {get; set;}
	
	global Process.PluginResult invoke(Process.PluginRequest request) { 
		
		String AccountId = (String) request.inputParameters.get('AccountId');
		String AssessmentId = (String) request.inputParameters.get('AssessmentId');
			
		addressValidationService.AddressServicePort geo = new addressValidationService.AddressServicePort();
        addressValidationService.distance distanceCalculated = new addressValidationService.distance();
        addressValidationService.duration durationCalculated = new addressValidationService.duration();
        system.debug('****** AssessmentId: ' + AssessmentId);
        system.debug('****** AccountId: ' + AccountId);
        
        list<iGeoLocate__c> fromGeoLoc = [SELECT id,Name, Assessment__c, geoAddress__Latitude__s, geoAddress__Longitude__s, Account__c, createdDate FROM iGeoLocate__c WHERE Assessment__c =: AssessmentId order by CreatedDate desc];
        list<iGeoLocate__c> toGeoLoc = [SELECT id, Name, geoAddress__Latitude__s, geoAddress__Longitude__s, Account__c, CreatedDate FROM iGeoLocate__c WHERE Account__c =: AccountId order by CreatedDate desc];
        
	    map<String,Object> result = new Map<String,Object>();
        
        if(fromGeoLoc.size() > 0 && toGeoLoc.size() >0 && fromGeoLoc[0].GeoAddress__Latitude__s != toGeoLoc[0].GeoAddress__Latitude__s 
        	&& fromGeoLoc[0].GeoAddress__Longitude__s != toGeoLoc[0].GeoAddress__Longitude__s
        	&& fromGeoLoc[0].GeoAddress__Latitude__s != null && toGeoLoc[0].GeoAddress__Longitude__s != null){
	     	if(!test.isRunningTest()){
		     	distanceCalculated = geo.calculateDistance(string.ValueOf(fromGeoLoc[0].geoAddress__Latitude__s), string.ValueOf(fromGeoLoc[0].GeoAddress__Longitude__s), string.ValueOf(toGeoLoc[0].GeoAddress__Latitude__s), string.ValueOf(toGeoLoc[0].GeoAddress__Longitude__s), 'SHORTEST_DISTANCE');
			    durationCalculated = distanceCalculated.duration;
			    //distance = distanceCalculated.distance.format();
		    	distance = distanceCalculated.distance;
		        measurement = distanceCalculated.measurement;
		        timex = durationCalculated.time_x.format();
		        timeUnit = durationCalculated.timeUnit;
	     	}
	        system.debug('***** DISTANCE!!!!!! ' + distance);
	       
	      	list<GeoMatch__c> existing_gm = [SELECT Id, Assessment__c, CreatedDate FROM GeoMatch__c WHERE Assessment__c =: AssessmentId order by createdDate DESC];
	      	if(existing_gm.size() > 0){
	      		existing_gm[0].PB_DistanceInMiles__c = distance;
	      		update existing_gm[0];
	      	}else{
		        GeoMatch__c gm = new GeoMatch__c(
		        	Name = 'GeoMatch- From:'+ fromGeoLoc[0].Name + ' To: ' + toGeoLoc[0].Name,
		        	FromiGeoLocate__c = fromGeoLoc[0].Id,
		        	ToiGeoLocate__c = toGeoLoc[0].Id, 
		        	PB_DistanceInMiles__c = distance, 
		        	Assessment__c = AssessmentId
		        	);
	      	
	        	insert gm;
	      	}
	        result.put('Distance_To_Host', distance); 
	        
        }
        return new Process.PluginResult(result); 
	}
	
	
	 global Process.PluginDescribeResult describe() { 
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 

        result.inputParameters = new list<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter('AccountId', 
               		Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter('AssessmentId', 
               		Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        
        result.outputParameters = new list<Process.PluginDescribeResult.OutputParameter>{
            	new Process.PluginDescribeResult.OutputParameter('Distance_To_Host', 
               		Process.PluginDescribeResult.ParameterType.decimal) 
        }; 
        return result;
	 }
	
}