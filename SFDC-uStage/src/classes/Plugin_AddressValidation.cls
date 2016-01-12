global class Plugin_AddressValidation implements Process.Plugin,Database.AllowsCallouts{
	
	global Process.PluginResult invoke(Process.PluginRequest request) { 
		// Get the subject of the Chatter post from the flow
	    String address1 = (String) request.inputParameters.get('address1');
	    String address2 = (String) request.inputParameters.get('address2');
	    String city = (String) request.inputParameters.get('city');
	    String state = (String) request.inputParameters.get('state');
	    String postalCode = (String) request.inputParameters.get('postalCode');
	    String country = (String) request.inputParameters.get('country');
	    //Boolean verified = (Boolean) request.inputParameters.get('verified');
	    
	    map<String,String> result = new map<String,String> ();
	    
	    AddressValidation_Processor avProcessor = new AddressValidation_Processor();
        avProcessor.address1 = address1;
       	avProcessor.address2 = address2;
        avProcessor.address3 = '';
        avProcessor.address4 = '';
        avProcessor.city = city;
        avProcessor.state = state;
        avProcessor.postalCode = postalCode;
        avProcessor.country = country;
        
        avProcessor.verifyAddress();
        
        /*
        result.put('status',avProcessor.status);
        result.put('address1',address1);
        result.put('address2',address2);
        result.put('city',city);
        result.put('state',state);
        result.put('postalCode',postalCode);
        result.put('country',country);
        result.put('additionalInformation', avProcessor.addInfo);
        */
        
        //system.debug('****** Potential Matches: ' + avProcessor.potentialMatchesList);
        if(avProcessor.potentialMatchesList.size() > 0){
	        result.put('address1_opt1',avProcessor.potentialMatchesList.get(0).get('address1'));
	        result.put('address2_opt1',avProcessor.potentialMatchesList.get(0).get('address2'));
	        result.put('city_opt1',avProcessor.potentialMatchesList.get(0).get('city'));
	        result.put('state_opt1',avProcessor.potentialMatchesList.get(0).get('state'));
	        result.put('postalCode_opt1',avProcessor.potentialMatchesList.get(0).get('postalCode'));
	        result.put('country_opt1',avProcessor.potentialMatchesList.get(0).get('country'));
	        result.put('addressType1',avProcessor.potentialMatchesList.get(0).get('addressType'));
        }
        if(avProcessor.potentialMatchesList.size() > 1){
	        result.put('address1_opt2',avProcessor.potentialMatchesList.get(1).get('address1'));
	        result.put('address2_opt2',avProcessor.potentialMatchesList.get(1).get('address2'));
	        result.put('city_opt2',avProcessor.potentialMatchesList.get(1).get('city'));
	        result.put('state_opt2',avProcessor.potentialMatchesList.get(1).get('state'));
	        result.put('postalCode_opt2',avProcessor.potentialMatchesList.get(1).get('postalCode'));
	        result.put('country_opt2',avProcessor.potentialMatchesList.get(1).get('country'));
	        result.put('addressType2',avProcessor.potentialMatchesList.get(1).get('addressType'));
        }

        result.put('status', avProcessor.status);
        result.put('additionalInformation', avProcessor.addInfo);
        
        return new Process.PluginResult(result); 
        
        
	}
	
	 // Returns the describe information for the interface
    global Process.PluginDescribeResult describe() { 
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
        //result.Name = "flowchatplugin";
        //result.Tag = "chat";
        result.inputParameters = new list<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter('address1', 
               		Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter('address2', 
               		Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter('city', 
               		Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter('state', 
               		Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter('postalCode', 
               		Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter('country', 
               		Process.PluginDescribeResult.ParameterType.STRING, true)
               /*
               new Process.PluginDescribeResult.InputParameter('verified', 
               		Process.PluginDescribeResult.ParameterType.STRING, true)
               */
            }; 
        	
        	
            result.outputParameters = new list<Process.PluginDescribeResult.OutputParameter>{
            	new Process.PluginDescribeResult.OutputParameter('status', 
               		Process.PluginDescribeResult.ParameterType.STRING),
           		new Process.PluginDescribeResult.OutputParameter('additionalInfo', 
               		Process.PluginDescribeResult.ParameterType.STRING),
           		new Process.PluginDescribeResult.OutputParameter('address1_opt1', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('address2_opt1', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('city_opt1', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('state_opt1', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('postalCode_opt1', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('country_opt1', 
               		Process.PluginDescribeResult.ParameterType.STRING),
               	new Process.PluginDescribeResult.OutputParameter('address1_opt2', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('address2_opt2', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('city_opt2', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('state_opt2', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('postalCode_opt2', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('country_opt2', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('existingRecord', 
               		Process.PluginDescribeResult.ParameterType.STRING),
            	new Process.PluginDescribeResult.OutputParameter('service', 
               		Process.PluginDescribeResult.ParameterType.STRING),
               	new Process.PluginDescribeResult.OutputParameter('addressType1', 
               		Process.PluginDescribeResult.ParameterType.STRING), 
               	new Process.PluginDescribeResult.OutputParameter('addressType2', 
               		Process.PluginDescribeResult.ParameterType.STRING)
        	};
           
        return result; 
    }
}