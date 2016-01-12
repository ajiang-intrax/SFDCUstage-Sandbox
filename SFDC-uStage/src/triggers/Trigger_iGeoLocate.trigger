trigger Trigger_iGeoLocate on iGeoLocate__c (after insert,after update) {
	//Instantiate Google Geo Controller
	System.debug('Inside GeoLocate trigger before instance creation');
	googleGeoController gGeoC = new googleGeoController();
	System.debug('Inside GeoLocate trigger after instance creation');
	System.debug(UserInfo.getName());
	Map<String,Trigger_Exclusion__c> triggerExclusionMapAll = Trigger_Exclusion__c.getAll();
	Map<String,Trigger_Exclusion__c> triggerExclusionMapiGeo = new Map<String,Trigger_Exclusion__c>();
	for (String csName : triggerExclusionMapAll.keySet()){
		If (triggerExclusionMapAll.get(csName).Object__c == 'iGeoLocate__c'){
			triggerExclusionMapiGeo.put(csName,triggerExclusionMapAll.get(csName));
		}
	}
	
	Set<String> fieldNames = iGeoLocate__c.sObjectType.getDescribe().fields.getMap().keySet();
	for (String csName : triggerExclusionMapiGeo.keySet()){
		for (String fieldName : fieldNames){
			if(triggerExclusionMapiGeo.get(csName).Field_Name__c == fieldName){
				if (Trigger.new[0].get(fieldName) != null && Trigger.new[0].get(fieldName).equals(triggerExclusionMapiGeo.get(csName).value__c)){
					System.debug('I have to be excluded it seems because,'+Trigger.new[0].get(fieldName)+triggerExclusionMapiGeo.get(csName).value__c);
					return;
				}
			}
		}
	}
	if(trigger.isAfter){
        if(trigger.isInsert){
        	//PB Record Containers
	        Set<Id> iGeolocateIds = new set<Id>();
	        string id;
	        //GoogleMapsAPI container - Below conditinal checks isolate GoogleMapsAPI records from the PB records
	        List<iGeoLocate__c> giGeolocates = new List<iGeoLocate__c>();
			//Load the lookups as well as we need them for decision making
	        List<iGeoLocate__c> iGeoLocateListHeavy = [select Id,isUpdated__c,Applicant_Info__c,Applicant_Info__r.RecordTypeId,Contact__c,Contact__r.Title,Lead__c,Account__c,Zip_Code__c from iGeoLocate__c where id in :trigger.newMap.keySet()];
	        //Loop the loaded data
	        for(iGeoLocate__c ObjiGeoloc:iGeoLocateListHeavy)
	        {
	        	//If the GeoLocate is for AppInfo and is of APCH (OR) is for APC AD Contact (OR) for Lead (OR) for Account add to the GoogleMapsAPI container
	        	// Need to refine conditions
		        if ( (ObjiGeoloc.Applicant_Info__c != null && ObjiGeoloc.Applicant_Info__r.RecordTypeId == '01213000000AUyw') || (ObjiGeoloc.Contact__c != null && ObjiGeoloc.Contact__r.Title == 'Area Director') || (ObjiGeoloc.Lead__c != null) || (ObjiGeoloc.Account__c != null) || (ObjiGeoloc.Zip_Code__c != null)){
		        	giGeolocates.add(ObjiGeoloc);
		        }
		        else{
			        id =ObjiGeoloc.Id;  
			        iGeolocateIds.add(id);         
		        } 
	         } 
	        if(!system.isBatch() && !Test.isRunningTest()){
	        	//Pass the PB Container to PB Code
		        iGeoLocateTriggerHelper.computelstGeoCode(iGeolocateIds);
		        //The GoogleMapsAPI container to the GoogleGeoController
		        gGeoC.sObjectList = giGeolocates;
				gGeoC.theInstanceGateKeeper();
	        }
        } //End if trigger.isInsert
        
        If(trigger.isUpdate)
        {
        	//PB Container
        	Set<Id> iGeolocateIds = new set<Id>();
            string id;
            //GoogleMapsAPI Container
            List<iGeoLocate__c> giGeolocates = new List<iGeoLocate__c>();
			//Load the heavy record with all lookups needed for decision making
            List<iGeoLocate__c> iGeoLocateListHeavy = [select Id,isUpdated__c,Applicant_Info__c,Applicant_Info__r.RecordTypeId,Contact__c,Contact__r.Title,Lead__c,Account__c from iGeoLocate__c where id in :trigger.newMap.keySet()];
        	For(iGeoLocate__c geo : iGeoLocateListHeavy)
        	{
        		//Logic for populating the GoogleMapsAPI container
				if ( (geo.Applicant_Info__c != null && geo.Applicant_Info__r.RecordTypeId == '01213000000AUyw') ){
					giGeolocates.add(geo);
				}
				System.debug('doesthiscomehere?'+geo.Applicant_Info__r+geo.Contact__r.Title+geo.Contact__r);
				if((geo.Contact__c != null && geo.Contact__r.Title == 'Area Director') || (geo.Lead__c != null) || (geo.Account__c != null)){
				    giGeolocates.add(geo);
				}
				
				//PB Logic 
              	if(geo.isUpdated__c)
              	{ 
                	 id =geo.Id;  
         			 iGeolocateIds.add(id);
         			 system.debug('****id*******'+id);
         			 
         			 if(!system.isBatch() && !Test.isRunningTest())
			          	iGeoLocateTriggerHelper.computelstGeoCode(iGeolocateIds);
                }
                //GoogleMapsAPI calls
                else{
                	if(!system.isBatch() && !Test.isRunningTest()){
                		gGeoC.sObjectList = giGeolocates;
						gGeoC.theInstanceGateKeeper();
                		
                	}
                }
        	}
        }
    }
}