global class iGeoLocateTriggerHelper {
   /**
    * Description   :   This method deletes Uploaded documents through Intrax Program Uploads
    * @args         :   Document Service, Document Guid Id, Record Id
    * @return       :   void
    */
     public static boolean isTest=false;

     @Future(callout=true)
     public static void computelstGeoCode(Set<Id> iGeolocateIds) {
	     
	     if(iGeolocateIds!=null  && iGeolocateIds.size()>0)
	     calculateGeoCode(iGeoLocateIds);
       
     }
     
     public static void computelstGeoCode_batch(set<Id> iGeoLocateIds){
     	
	     calculateGeoCode(iGeoLocateIds);
     }  
     
     public static void calculateGeoCode(set<Id> iGeoLocateIds){
     	List<iGeoLocate__c> loadGeoLocateToBeUpdated = new  List<iGeoLocate__c>();   
	     String coordinates;
	     xmlApacheOrgXmlSoap.Map_x GeoCodeResponse = new xmlApacheOrgXmlSoap.Map_x ();
	     List<geoservicesWebservices.GeoObject> geoObjects = new List<geoservicesWebservices.GeoObject>();
	     
	     
     	for (Id loadGeoLocateId:iGeolocateIds){
	    	geoservicesWebservices.GeoObject geoObject = new geoservicesWebservices.GeoObject();
	    	iGeoLocate__c loadGeoLocate;
	       	loadGeoLocate = [Select i.Assessment__r.Street__c, i.Assessment__r.State__c, i.Assessment__r.City__c, i.Assessment__r.Postal_Code__c, i.Assessment__r.Country__c, i.Accommodation_Site__r.Street__c, i.Accommodation_Site__r.State__c, i.Accommodation_Site__r.City__c, i.Accommodation_Site__r.Postal_Code__c, i.Accommodation_Site__r.Country__c, i.Position__r.Country__c, i.Position__r.Postal_Code__c, i.Position__r.State__c, i.Position__r.City__c, i.Position__r.Street__c, i.Position__c,i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, i.Contact__r.MailingCountry, i.Contact__r.MailingPostalCode, i.Contact__r.MailingState, i.Contact__r.MailingCity, i.Contact__r.MailingStreet, i.Contact__r.Id, i.Contact__c, i.Account__r.PersonMailingCountry, i.Account__r.PersonMailingPostalCode, i.Account__r.PersonMailingState, i.Account__r.PersonMailingCity, i.Account__r.PersonMailingStreet, i.Account__r.Type, i.Account__r.Name, i.Account__c, i.Account__r.BillingStreet, i.Account__r.BillingState, i.Account__r.BillingCity, i.Account__r.BillingCountry, i.Account__r.BillingPostalCode, 
	       						i.Position_Info__r.Company_Street_1__c, i.Position_Info__r.Company_Street_2__c, i.Position_Info__r.Company_State__c, i.Position_Info__r.Company_City__c, i.Position_Info__r.Company_Postal_Code__c, i.Position_Info__r.Company_Country__c
		     	 				From iGeoLocate__c i 
		     	 				where id =: loadGeoLocateId  ];
	        system.debug('********loadGeoLocate ***********'+loadGeoLocate );
	         
	        if(loadGeoLocate.Position__c!=null)
	        {
	        geoObject.address1 = loadGeoLocate.Position__r.Street__c;
	        geoObject.city = loadGeoLocate.Position__r.City__c ;
	        geoObject.country = loadGeoLocate.Position__r.Country__c ;
	        geoObject.postalCode = loadGeoLocate.Position__r.Postal_Code__c ;
	        geoObject.state = loadGeoLocate.Position__r.State__c ;
	        geoObject.geoId = loadGeoLocateId;
	         system.debug('********geoObject ***********'+geoObject );
	        }
	        if(loadGeoLocate.Position_Info__c!=null)
	        {
	        geoObject.address1 = loadGeoLocate.Position_Info__r.Company_Street_1__c;
	        geoObject.city = loadGeoLocate.Position_Info__r.Company_City__c ;
	        geoObject.country = loadGeoLocate.Position_Info__r.Company_Country__c ;
	        geoObject.postalCode = loadGeoLocate.Position_Info__r.Company_Postal_Code__c ;
	        geoObject.state = loadGeoLocate.Position_Info__r.Company_State__c ;
	        geoObject.geoId = loadGeoLocateId;
	         system.debug('********geoObject ***********'+geoObject );
	        }
	        if(loadGeoLocate.Accommodation_Site__c != null){
	        	geoObject.address1 = loadGeoLocate.Accommodation_Site__r.Street__c;
		        geoObject.city = loadGeoLocate.Accommodation_Site__r.City__c ;
		        geoObject.country = loadGeoLocate.Accommodation_Site__r.Country__c ;
		        geoObject.postalCode = loadGeoLocate.Accommodation_Site__r.Postal_Code__c ;
		        geoObject.state = loadGeoLocate.Accommodation_Site__r.State__c ;
		        geoObject.geoId = loadGeoLocateId;
		        system.debug('********geoObject ***********'+geoObject );
	        }
	        if(loadGeoLocate.Assessment__c != null){
	        	geoObject.address1 = loadGeoLocate.Assessment__r.Street__c;
		        geoObject.city = loadGeoLocate.Assessment__r.City__c ;
		        geoObject.country = loadGeoLocate.Assessment__r.Country__c ;
		        geoObject.postalCode = loadGeoLocate.Assessment__r.Postal_Code__c ;
		        geoObject.state = loadGeoLocate.Assessment__r.State__c ;
		        geoObject.geoId = loadGeoLocateId;
		        system.debug('********geoObject ***********'+geoObject );
	        }
	        if(loadGeoLocate.Account__c!=null)
	        {
	        geoObject.address1 = loadGeoLocate.Account__r.BillingStreet;
	        geoObject.city = loadGeoLocate.Account__r.BillingCity;
	        geoObject.country = loadGeoLocate.Account__r.BillingCountry;
	        geoObject.postalCode = loadGeoLocate.Account__r.BillingPostalCode;
	        geoObject.state = loadGeoLocate.Account__r.BillingState;
	        geoObject.geoId = loadGeoLocateId;
	         system.debug('********geoObject ***********'+geoObject );
	        }
	        if(loadGeoLocate.contact__c!=null)
	        {
	        geoObject.address1 = loadGeoLocate.Contact__r.MailingStreet;
	        geoObject.city = loadGeoLocate.Contact__r.MailingCity ;
	        geoObject.country = loadGeoLocate.Contact__r.MailingCountry ;
	        geoObject.postalCode = loadGeoLocate.Contact__r.MailingPostalCode ;
	        geoObject.state = loadGeoLocate.Contact__r.MailingState ;
	        geoObject.geoId = loadGeoLocateId;
	        system.debug('********geoObject ***********'+geoObject );
	        }
	        
	        geoObjects.add(geoObject);
	        system.debug('********geoObjects ***********'+geoObjects );
	    
	    }
	     if(!isTest){
	     	system.debug('********isTest***********'+isTest);
	       // geoservicesWebservices.geoservices_cfc handle =  new geoservicesWebservices.geoservices_cfc();
	        try{
		        geoservicesWebservices.geoservices_cfc newHandle =  new geoservicesWebservices.geoservices_cfc();
		        system.debug('********newHandle ***********'+newHandle );
		        GeoCodeResponse = newHandle.getGeoCode(geoObjects);
		        system.debug('********GeoCodeResponse***********'+GeoCodeResponse);
	            system.debug('********coordinates***********'+coordinates);
	        } catch(Exception ex) {}
	        
	       if(GeoCodeResponse.item!=null)
	       {
		    for (xmlApacheOrgXmlSoap.mapItem gitem  :GeoCodeResponse.item){
		     	 iGeoLocate__c ResloadGeoLocate = new iGeoLocate__c();
		     	 ResloadGeoLocate = [Select i.Position__r.Country__c, i.isUpdated__c,i.Position__r.Postal_Code__c, i.Position__r.State__c, i.Position__r.City__c, i.Position__r.Street__c, i.Position__c,
		     	 						i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, i.Contact__r.MailingCountry, i.Contact__r.MailingPostalCode, i.Contact__r.MailingState, 
		     	 						i.Contact__r.MailingCity, i.Contact__r.MailingStreet, i.Contact__r.Id, i.Contact__c, i.Account__r.PersonMailingCountry, i.Account__r.PersonMailingPostalCode, 
		     	 						i.Account__r.PersonMailingState, i.Account__r.PersonMailingCity, i.Account__r.PersonMailingStreet, i.Account__r.Type, i.Account__r.Name, i.Account__c,
		     	 						i.Accommodation_Site__r.Street__c, i.Accommodation_Site__r.State__c, i.Accommodation_Site__r.City__c, i.Accommodation_Site__r.Postal_Code__c, i.Accommodation_Site__r.Country__c,
		     	 						i.Assessment__r.Street__c, i.Assessment__r.State__c, i.Assessment__r.City__c, i.Assessment__r.Postal_Code__c, i.Assessment__r.Country__c,
		     	 						i.Position_Info__r.Company_Street_1__c, i.Position_Info__r.Company_Street_2__c, i.Position_Info__r.Company_State__c, i.Position_Info__r.Company_City__c, i.Position_Info__r.Company_Postal_Code__c, i.Position_Info__r.Company_Country__c
		     	 						From iGeoLocate__c i where id =: gitem.key  ];
		   
		     	// ResloadGeoLocate.Id = gitem.key;  	  
		       
		         coordinates=gitem.value;
		         
		         system.debug('********ResloadGeoLocate***********'+ResloadGeoLocate);
		         system.debug('********coordinates***********'+coordinates);
		         String[] CoordinateList;
		        if(coordinates!='' && coordinates.length()!=0 && coordinates!='Error geocoding') {
		        	CoordinateList = coordinates.split('&');
		            system.debug('********CoordinateList***********'+CoordinateList);
			        String strLong = CoordinateList[0].substringAfterLast('=');
			        String strLat = CoordinateList[1].substringAfterLast('=');
			        Decimal DecLong=Decimal.valueOf(strLong);
			        Decimal DecLat=Decimal.valueOf(strLat);
			        system.debug('********strLat***********'+strLat);
		            system.debug('********strLong***********'+strLong);
		            system.debug('********DecLong***********'+DecLong);
		            system.debug('********DecLat***********'+DecLat);
		        	ResloadGeoLocate.GeoAddress__Latitude__s =DecLat;
		         	ResloadGeoLocate.GeoAddress__Longitude__s =DecLong;
		        	ResloadGeoLocate.isUpdated__c=false;
		         	system.debug('********Address_GeoCoordinates__Latitude__s***********'+ ResloadGeoLocate.GeoAddress__Latitude__s);
		            system.debug('********Address_GeoCoordinates__Longitude__s***********'+  ResloadGeoLocate.GeoAddress__Longitude__s );
		        }
		        
		        loadGeoLocateToBeUpdated.add(ResloadGeoLocate);
		         
		    }
	       }
	        system.debug('********loadGeoLocateToBeUpdated***********'+loadGeoLocateToBeUpdated);
	            
	        if(loadGeoLocateToBeUpdated.size()>0) update loadGeoLocateToBeUpdated;
	       
	    }
	     
	    else{
	            //GeoCodeResponse =  'fromLongitude=-122.354542&fromLatitude=47.548196';      
	    }
	   
     }
       
         
     
}