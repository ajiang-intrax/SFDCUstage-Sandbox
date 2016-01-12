global class GeoReAssign {
        
    Map<Id,List<googleGeoDistanceMatrixElementOneD>> odGroup {get;set;}
    public GeoMatch__c placeHolderGeoMatch {get;set;}
    public Integer compatibleCount{get;set;}
    public Integer InCompatibleCount{get;set;}   
        
    public List<String> compatibleListName{get;set;}
    public List<String> compatibleListDis{get;set;}
    public List<String> compatibleListDur{get;set;}
    
    public List<String> InCompatibleListName{get;set;}
    public List<String> InCompatibleListDis{get;set;}
    public List<String> InCompatibleListDur{get;set;}
    public Set<Id> toBeInvalidatedHFs {get;set;}
    
    public String selectedAD{get;set;}
    public Map<String,Id> mapADiGeoL{get;set;}
    public String originalGeoMatchId{get;set;}
    public iGeoLocate__c toiGeoLocateOfGM{get;set;}
    
    global class MyWrapper implements Comparable{
        public string sName {get;set;}
        public String dis {get; set;}
        public String dur {get; set;}
        public MyWrapper(String sn, String di, String du) {        
            this.sName = sn;
            this.dis = di;
            this.dur = du;
        }
        
        global Integer compareTo(Object objToCompare) {
        	//Sort by duration
	        //return dur.compareTo(((MyWrapper)objToCompare).dur);
	        
	        MyWrapper existingWrap = (MyWrapper) objToCompare;
		    if (decimal.valueOf(this.dur) == decimal.valueOf(existingWrap.dur)) return 0;
            if (decimal.valueOf(this.dur) > decimal.valueOf(existingWrap.dur)) return 1;
            return -1;
        }
			        			   
    }
            
    public List<MyWrapper> myWrapperListCompatible{
        get{
           if(myWrapperListCompatible == null){
              myWrapperListCompatible = new List<myWrapper> ();              
              for(integer i = 0; i < compatibleListDis.size(); i++){
                  myWrapperListCompatible.add(new MyWrapper(compatibleListName[i],compatibleListDis[i],compatibleListDur[i]));                  
              }
          }
          myWrapperListCompatible.sort();
          return myWrapperListCompatible;
        }
        private set;
    }
    
    public List<MyWrapper> myWrapperListInCompatible{
        get{
           if(myWrapperListInCompatible == null){
              myWrapperListInCompatible = new List<MyWrapper> ();
              for(integer i = 0; i < InCompatibleListDis.size(); i++){
                  myWrapperListInCompatible.add(new MyWrapper(InCompatibleListName[i],InCompatibleListDis[i],InCompatibleListDur[i]));                  
              }
          }
          myWrapperListInCompatible.sort();
          return myWrapperListInCompatible;
        }
        private set;
    }
    
    public String newADName{get;set;}
    public String oldADName{get;set;}
    public Id newADId;     
    public PageReference ZipOrAreaTab{get;set;}
    public String sTypeParam{get;set;}
    
    public GeoReAssign(){
    	compatibleListName = new List<String>();
        InCompatibleListName = new List<String>();
        compatibleListDis = new List<String>();
        compatibleListDur = new List<String>();
        InCompatibleListDis = new List<String>();   
        InCompatibleListDur = new List<String>();
    }
    
    public GeoReAssign(ApexPages.StandardController stdcontroller){
        System.debug('Inside Standard Constructor');
        placeHolderGeoMatch = (GeoMatch__c)stdController.getRecord();
        System.debug('placeHolderGeoMatch--->'+placeHolderGeoMatch);
        placeHolderGeoMatch = [select ToiGeoLocate__c, Duration_In_Mins__c, New_AD__c,Previous_Zip_Code__c,Previous_Area__r.Area_Director__r.Name,Previous_Zip_Code__r.Area__r.Area_Director__r.Name,Previous_Zip_Code__r.Zip_Code__c,serializedMatchMatrix__c,New_Area__c,Previous_Area__c,Previous_Area__r.Area_Director__r.Contact.Id,Assignment_Type__c from geoMatch__c where id = :placeHolderGeoMatch.Id];               
        compatibleCount = 0;
        InCompatibleCount = 0;   
        compatibleListName = new List<String>();
        InCompatibleListName = new List<String>();
        compatibleListDis = new List<String>();
        compatibleListDur = new List<String>();
        InCompatibleListDis = new List<String>();   
        InCompatibleListDur = new List<String>();
        newADName = '';
        oldADName = '';
        //testToGeoNames = new List<String>();
        ADGeoLocateIds = new Set<Id>();
        toBeInvalidatedHFs = new Set<Id>();            
        sTypeParam = ApexPages.currentPage().getParameters().get('sType'); 
        System.debug('sTypeParam----->'+sTypeParam);  
        mapADiGeoL = new Map<String,Id>();   
        originalGeoMatchId = ApexPages.currentPage().getParameters().get('OriginalGeoMatchId');
        if(originalGeoMatchId!=null){
        	//toiGeoLocateOfGM = [SELECT Id, toiGeoLocate__c FROM GeoMatch__c WHERE Id=:originalGeoMatchId LIMIT 1]; 
        }
                  
        if(placeHolderGeoMatch!=null && placeHolderGeoMatch.Previous_Zip_Code__c!=null){            
            ZipOrAreaTab = new PageReference('/apex/geoZipCodesTab');
        }
        else if(placeHolderGeoMatch!=null && placeHolderGeoMatch.Previous_Area__c!=null){             
            ZipOrAreaTab = new PageReference('/apex/geoAreasTab');
        }
        System.debug('ZipOrAreaTab in constructor----->'+ZipOrAreaTab);
        
    }
    
    public set<Id> ADGeoLocateIds;  
    //public List<string> testToGeoNames{get;set;}
    //action method
    public void showPreMatch(){
        System.debug('placeHolderGeoMatch----->'+placeHolderGeoMatch);
        
        odGroup = (Map<Id,List<googleGeoDistanceMatrixElementOneD>>)JSON.deserialize(placeHolderGeoMatch.serializedMatchMatrix__c,Map<Id,List<googleGeoDistanceMatrixElementOneD>>.class);
        for (Id fromiGeoId : odGroup.KeySet()){
            newADId = fromiGeoId;
            //ADGeoLocateIds.add(fromiGeoId);//adding the GL of the new AD
            for (googleGeoDistanceMatrixElementOneD gOneD : odGroup.get(fromiGeoId)){                
                //ADGeoLocateIds.add(gOneD.toGeo.Id);//adding the GL of HF (to get the old AD)
                System.debug('gOneD------>'+gOneD);
                if (gOneD.pairingStatus == 'Compatible'){
                    compatibleCount++;
                    if(sTypeParam=='reAssignHF'){                    	
                    	compatibleListName.add(gOneD.toGeo.Contact__r.Name);
                    	//if(gOneD.toGeo.Id!=toiGeoLocateOfGM){//excluding the iGeoL of AD who is already the matched
                    		mapADiGeoL.put(gOneD.toGeo.Contact__r.Name,gOneD.toGeo.Id);
                    	//}
                    }
                    else{//Zip or Area reassignment
                    	if(gOneD.toGeo.Account__r.Name!=null)
                        	compatibleListName.add(gOneD.toGeo.Account__r.Name);
                    }
                    if(gOneD.distanceInKms!=null)
                        compatibleListDis.add(String.valueOf((Decimal.valueOf(gOneD.distanceInKms)/1.609344).setScale(2, RoundingMode.HALF_UP)));
                    if(gOneD.durationInMins!=null)
                        compatibleListDur.add(String.valueOf(Decimal.valueOf(gOneD.durationInMins).setScale(2, RoundingMode.HALF_UP)));                 
                }
                else if(gOneD.pairingStatus == 'InCompatible'){
                    InCompatibleCount++;
                    if(sTypeParam=='reAssignHF'){                    	
                    	InCompatibleListName.add(gOneD.toGeo.Contact__r.Name);
                    	mapADiGeoL.put(gOneD.toGeo.Contact__r.Name,gOneD.toGeo.Id);
                    }
                    else{//Zip or Area reassignment
	                    if(gOneD.toGeo.Account__r.Name!=null)
	                        InCompatibleListName.add(gOneD.toGeo.Account__r.Name);
                    }
                    if(gOneD.distanceInKms!=null)
                        InCompatibleListDis.add(String.valueOf((Decimal.valueOf(gOneD.distanceInKms)/1.609344).setScale(2, RoundingMode.HALF_UP)));
                    if(gOneD.durationInMins!=null)
                        InCompatibleListDur.add(String.valueOf(Decimal.valueOf(gOneD.durationInMins).setScale(2, RoundingMode.HALF_UP)));
                    
                }
            }
        }
        System.debug('compatibleListName---->'+compatibleListName);
        System.debug('compatibleListDis---->'+compatibleListDis);
        System.debug('compatibleListDur---->'+compatibleListDur);
        
        System.debug('InCompatibleListName---->'+InCompatibleListName);
        System.debug('InCompatibleListDis---->'+InCompatibleListDis);
        System.debug('InCompatibleListDur---->'+InCompatibleListDur);
        
                
        if(newADId!=null){
            List<iGeoLocate__c> iGLList = [SELECT Contact__r.Name FROM iGeoLocate__c WHERE Id=:newADId LIMIT 1];
            if(iGLList!=null && iGLList.size()>0){
                newADName = iGLList[0].Contact__r.Name;
            }
        }
        
        /*if(ADGeoLocateIds!=null && ADGeoLocateIds.size()>0){
            List<GeoMatch__c> GMList = [SELECT ToiGeoLocate__r.Contact__r.Name FROM GeoMatch__c WHERE FromiGeoLocate__c IN: ADGeoLocateIds LIMIT 1];
            if(GMList!=null && GMList.size()>0){
                oldADName = GMList[0].ToiGeoLocate__r.Contact__r.Name;
            }
        }*/
        if (placeHolderGeoMatch.Previous_Zip_Code__r.Area__r.Area_Director__r.Name != null){
        	oldADName = placeHolderGeoMatch.Previous_Zip_Code__r.Area__r.Area_Director__r.Name;
        }
        else{
            oldADName = placeHolderGeoMatch.Previous_Area__r.Area_Director__r.Name;
        }
        //testToGeoNames.add([SELECT ToiGeoLocate__r.Contact__r.Name FROM GeoMatch__c WHERE FromiGeoLocate__c IN: ADGeoLocateIds AND Match_Status__c='Geo Matched' LIMIT 1].ToiGeoLocate__r.Contact__r.Name);
        //testToGeoNames.add([SELECT Contact__r.Name FROM iGeoLocate__c WHERE Id IN :ADGeoLocateIds LIMIT 1].Contact__r.Name);
    }
    
    public PageReference AssignToHF(){
    	GeoMatch__c geoMatch = new GeoMatch__c();
    	List<GeoMatch__c> geoMatchesList = new List<GeoMatch__c>();
    	try{
	    	System.debug('SELECTED AD------->'+selectedAD);
	    	System.debug('SELECTED ADs iGeoL------->'+mapADiGeoL.get(selectedAD));    	
	    	System.debug('placeHolderGeoMatch------->'+placeHolderGeoMatch.Id);	    		    	
	    	
	    	if(originalGeoMatchId!=null){
	    		geoMatchesList = [SELECT Id,ToiGeoLocate__c,Match_Status__c FROM GeoMatch__c WHERE Id=:originalGeoMatchId LIMIT 1];    	
		    	if(geoMatchesList!=null && geoMatchesList.size()>0){
		    		//geoMatchesList[0].ToiGeoLocate__c = mapADiGeoL.get(selectedAD);
		    		geoMatchesList[0].Match_Status__c = 'Geo Invalidated';
		    		update geoMatchesList[0];		    				    		
		    	}
	    	}
                        
            String ADDuration='';
            //get the driving time distance for this AD from both the wrappers
            for(MyWrapper wrap:myWrapperListCompatible){
                if(wrap.sName==selectedAD){
                    System.debug('Compatible wrap dur----->'+wrap.dur);
                    ADDuration = wrap.dur;
                    break;
                }
            }    
            
            if(ADDuration==''){
                for(MyWrapper wrap:myWrapperListInCompatible){
                    if(wrap.sName==selectedAD){
                        System.debug('Incompatible wrap dur----->'+wrap.dur);
                        ADDuration = wrap.dur;
                        break;
                    }
                }
            }
            
	    	System.debug('ADDuration----->'+ADDuration);
            
	    	if(placeHolderGeoMatch!=null){
	    		//set flags
	    		placeHolderGeoMatch.Match_Status__c = 'Geo Matched';
	    		placeHolderGeoMatch.Assignment_Type__c = 'Permanent';
	    		placeHolderGeoMatch.Assigned_AD__c = 'Zipcode AD';
	    		placeHolderGeoMatch.Assigned_AD_Status__c = 'Approved';
	    		placeHolderGeoMatch.Is_In_Range_Of_ZipCode_AD__c = 'Yes';
	    		placeHolderGeoMatch.Is_Imported_From_Casper__c = false;
                if(ADDuration!='' && ADDuration!=null)
                	placeHolderGeoMatch.Duration_in_Mins__c = Decimal.valueOf(ADDuration);
	    		
	    		if(selectedAD!=null){
	    		placeHolderGeoMatch.ToiGeoLocate__c = mapADiGeoL.get(selectedAD);
	    		}
	    		update placeHolderGeoMatch;
	    		
	    		List<GeoMatch__c> chownerList = new List<GeoMatch__c>();
	    		chownerList.add(placeHolderGeoMatch);
	    		//change owners
	    		changeOwnerForGeoMatchedRelatedObjs(chownerList);
	    	}
    	}
    	catch(exception e){
    		System.debug('EXCEPTION WHILE tagging toIgeoLocate with geoMatch'+e);
    	}
    	PageReference p = new PageReference('/apex/googleGeoDistanceVisualizer1xn?id='+placeHolderGeoMatch.Id);
    	p.setRedirect(true);
    	return p;
    }
    
    public PageReference continueMethod(){
        //ReAssignAll
        PageReference p = createReassignments('NewADForAll');
        p.setRedirect(true);
        return p;
    }
    
    public PageReference retainMethod(){
        //Reassign only compatible pairs.  
        PageReference p = createReassignments('NewADOnlyForCompatible');
        p.setRedirect(true);
        return p;
    }
    
    //landing for both buttons method
    public PageReference createReassignments(String sType){
        
        List<GeoMatch__c> reAssignedHFsWithNewZipAD = new List<GeoMatch__c>();
        Integer spawnedGeoMatches = 0;
        //placeHolderGeoMatch = [select Previous_Zip_Code__c,Previous_Zip_Code__r.Zip_Code__c,serializedMatchMatrix__c,New_Area__c from geoMatch__c where id = :ApexPages.currentPage().getParameters().get('Id')]; 
        //odGroup = (Map<Id,List<googleGeoDistanceMatrixElementOneD>>)JSON.deserialize(placeHolderGeoMatch.serializedMatchMatrix__c,Map<Id,List<googleGeoDistanceMatrixElementOneD>>.class);
        for (Id fromiGeoId : odGroup.KeySet()){
            spawnedGeoMatches = 0;
            for (googleGeoDistanceMatrixElementOneD gOneD : odGroup.get(fromiGeoId)){
                //Change AD only for compatible pairs
                if(sType == 'NewADOnlyForCompatible'){
                    if (gOneD.pairingStatus == 'Compatible'){
                        //If a reassignment is compatible, create a new GeoMatch
                        GeoMatch__c aNewADHFAssignment = new GeoMatch__c();
                        aNewADHFAssignment.ToiGeoLocate__c = fromiGeoId;
                        aNewADHFAssignment.FromiGeoLocate__c = gOneD.toGeo.Id;
                        toBeInvalidatedHFs.add(gOneD.toGeo.Id);
                        aNewADHFAssignment.Placeholder_GeoMatch__c = placeHolderGeoMatch.Id;
                        Map<Id,List<googleGeoDistanceMatrixElementOneD>> onePairMatrix = new Map<Id,List<googleGeoDistanceMatrixElementOneD>>();
                        onePairMatrix.put(fromiGeoId,new List<googleGeoDistanceMatrixElementOneD>());
                        onePairMatrix.get(fromiGeoId).add(gOneD);
                        aNewADHFAssignment.serializedMatchMatrix__c = JSON.serialize(onePairMatrix);
                        System.debug('gOneD.durationInMins----->'+gOneD.durationInMins);
                        if(gOneD.durationInMins!=null)
                        	aNewADHFAssignment.Duration_in_Mins__c = gOneD.durationInMins;
                        aNewADHFAssignment.Match_Status__c = 'Geo Matched';
                        //flags
                        aNewADHFAssignment.Is_Imported_From_Casper__c = false;
                        aNewADHFAssignment.Assigned_AD__c = 'Zipcode AD';
                        aNewADHFAssignment.Is_In_Range_Of_ZipCode_AD__c = 'Yes';
                        aNewADHFAssignment.Assignment_Type__c = placeHolderGeoMatch.Assignment_Type__c;
                        aNewADHFAssignment.Assigned_AD_Status__c = 'Approved';                        
                        reAssignedHFsWithNewZipAD.add(aNewADHFAssignment);
                        //Gather the old matches - The GeoMatch with the earlier ZipCode's AD
                        gOneD.pairingStatus = 'Compatible-Spawned';
                    }
                    else if (gOneD.pairingStatus == 'InCompatible'){
                        spawnedGeoMatches++;
                        //based on selected AD in the page. 
                        //if continnue clicked:create geomatches with new AD. i.e., same code as above
                        //if retain clicked, do only compatible.
                    }
                }
                else if(sType == 'NewADForAll'){//Change AD only for all pairs
                        GeoMatch__c aNewADHFAssignment = new GeoMatch__c();
                        aNewADHFAssignment.ToiGeoLocate__c = fromiGeoId;
                        aNewADHFAssignment.FromiGeoLocate__c = gOneD.toGeo.Id;
                    	toBeInvalidatedHFs.add(gOneD.toGeo.Id);
                        aNewADHFAssignment.Placeholder_GeoMatch__c = placeHolderGeoMatch.Id;
                        Map<Id,List<googleGeoDistanceMatrixElementOneD>> onePairMatrix = new Map<Id,List<googleGeoDistanceMatrixElementOneD>>();
                        onePairMatrix.put(fromiGeoId,new List<googleGeoDistanceMatrixElementOneD>());
                        onePairMatrix.get(fromiGeoId).add(gOneD);
                        aNewADHFAssignment.serializedMatchMatrix__c = JSON.serialize(onePairMatrix);
                    	if(gOneD.durationInMins!=null)
                    		aNewADHFAssignment.Duration_in_Mins__c = gOneD.durationInMins;
                        aNewADHFAssignment.Match_Status__c = 'Geo Matched';
                        //flags
                        aNewADHFAssignment.Is_Imported_From_Casper__c = false;
                        aNewADHFAssignment.Assignment_Type__c = placeHolderGeoMatch.Assignment_Type__c;
                        aNewADHFAssignment.Assigned_AD_Status__c = 'Approved';                        
                        if (gOneD.pairingStatus == 'Compatible'){
                        	aNewADHFAssignment.Assigned_AD__c = 'Zipcode AD';
                        	aNewADHFAssignment.Is_In_Range_Of_ZipCode_AD__c = 'Yes';                        	
                        }
                        else{
                        	aNewADHFAssignment.Assigned_AD__c = 'Other AD';
                        	aNewADHFAssignment.Is_In_Range_Of_ZipCode_AD__c = 'No';                        	
                        }
                        reAssignedHFsWithNewZipAD.add(aNewADHFAssignment);
                        //Gather the old matches - The GeoMatch with the earlier ZipCode's AD
                        gOneD.pairingStatus = 'Compatible-Spawned';
                }
            }
        }
        placeHolderGeoMatch.serializedMatchMatrix__c = JSON.serialize(odGroup);
        
        
        System.debug('DEBUG: reAssignedHFsWithNewZipAD---->'+reAssignedHFsWithNewZipAD);
        
        List<GeoMatch__c> oldMatchesOfHFs;
        
        System.debug('DEBUG: reAssignedHFsWithNewZipAD---->'+placeHolderGeoMatch.Previous_Zip_Code__r.Zip_Code__c);
        System.debug('DEBUG: previous AD contactid---->'+placeHolderGeoMatch.Previous_Area__r.Area_Director__r.Contact.Id);
        
        
        if(placeHolderGeoMatch.Previous_Area__c!=null){
            List<Zip_code__c> selectedZips = new List<Zip_Code__c>();
            Set<Id> zipIds = new Set<Id>();
            List<String> zipCodes = new List<String>();
            //Removed query filter and Has_Boundaries__c = true
            selectedZips = [select Zip_Code__c,Boundaries__c from Zip_Code__c where area__c = :placeHolderGeoMatch.Previous_Area__c];
            for (Zip_Code__c zip : selectedZips){
                zipIds.add(zip.Id);
                zipCodes.add(zip.Zip_Code__c);                
            }
            
            //iGeo For the AREA AD
            iGeoLocate__c iGeoForAD = [select id,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Contact__c = :placeHolderGeoMatch.Previous_Area__r.Area_Director__r.Contact.Id];
          
            //All HF iGeos in a GeoMatch 
            oldMatchesOfHFs =[select id,FromiGeoLocate__r.Account__r.Name,FromiGeoLocate__r.Account__r.BillingStreet,
                            FromiGeoLocate__r.Account__r.BillingCity,FromiGeoLocate__r.Account__r.BillingState,
                            FromiGeoLocate__r.Account__r.BillingPostalCode, FromiGeoLocate__r.GeoAddress__Latitude__s,
                            FromiGeoLocate__r.GeoAddress__Longitude__s 
                            from GeoMatch__c 
                            where 
                              FromiGeoLocate__c in :toBeInvalidatedHFs and 
                            FromiGeoLocate__r.Account__r.BillingPostalCode in :zipCodes 
                            and 
                            ToiGeoLocate__c = :iGeoForAD.Id 
                            and 
                            Match_Status__c = 'Geo Matched'];
                            
        }
        else if(placeHolderGeoMatch.Previous_Zip_Code__c!=null){    
            //List<Account> HFAccounts = [select Id from Account where BillingPostalCode = :placeHolderGeoMatch.Previous_Zip_Code__r.Zip_Code__c];
            //Set<Id> HFAccs = (new Map<Id,Account>(HFAccounts)).keySet();
            
            oldMatchesOfHFs = [select id from GeoMatch__c where FromiGeoLocate__c in :toBeInvalidatedHFs];
            //(select id from iGeoLocate__c where Account__c in :HFAccs)
        }
        
        
        System.debug('DEBUG: oldMatchesOfHFs to invalidated---->'+oldMatchesOfHFs);
        for (GeoMatch__c oldHFGeoMatch : oldMatchesOfHFs){
            oldHFGeoMatch.Match_Status__c = 'Geo Invalidated';
        }
        update oldMatchesOfHFs;
        insert reAssignedHFsWithNewZipAD;
        update placeHolderGeoMatch;
        
        System.debug('DEBUG: reAssignedHFsWithNewZipAD New---->'+reAssignedHFsWithNewZipAD);
        System.debug('DEBUG: placeHolderGeoMatch---->'+placeHolderGeoMatch);
        
               
        
        if(placeHolderGeoMatch.Previous_Zip_Code__c!=null){
        	Area__c newArea = [select Id from Area__c where Id=:placeHolderGeoMatch.New_Area__c]; 
            Zip_Code__c zipCode = [select Id,Area__c from Zip_Code__c where Id = :placeHolderGeoMatch.Previous_Zip_Code__c];
            zipCode.Area__c = newArea.Id;
            update zipCode;            
        }
        
        if(placeHolderGeoMatch.Previous_Area__c!=null){ 
        	//for Area reassignment. Just change the Area's AD to new AD!
        	Area__c prevArea = [SELECT Id,Area_Director__c FROM Area__c WHERE Id=:placeHolderGeoMatch.Previous_Area__c];
        	prevArea.Area_Director__c = [SELECT Id,ContactId FROM User WHERE ContactId=:placeHolderGeoMatch.New_AD__c].Id;
        	update prevArea;
        	/*
            List<Zip_Code__c> oldAreaZipCodes = [SELECT Id FROM Zip_Code__c WHERE Area__c=:placeHolderGeoMatch.Previous_Area__c];
            if(oldAreaZipCodes!=null && oldAreaZipCodes.size()>0){
                for(Zip_Code__c zip:oldAreaZipCodes){
                    zip.Area__c = newArea.Id;
                }
                update oldAreaZipCodes;
            }
            */            
        }
                
        //call method to update ownership       
        changeOwnerForGeoMatchedRelatedObjs(reAssignedHFsWithNewZipAD);
        
        //ZipOrAreaTab   
        System.debug('ZipOrAreaTab----->'+ZipOrAreaTab); 
        return ZipOrAreaTab;
     }
     
     public PageReference CancelAndReturn(){
     	if(placeHolderGeoMatch!=null){
     		try{
     			delete placeHolderGeoMatch;
     		}
     		catch(exception e){
     			System.debug('ERROR DELETING PLACEHOLDER MATCH ----->'+e);
     		}
     	}
     	System.debug('ZipOrAreaTab----->'+ZipOrAreaTab);
     	String originalGeoMatchId = ApexPages.currentPage().getParameters().get('OriginalGeoMatchId');
     	if(originalGeoMatchId!=null){
     		PageReference p = new PageReference('/apex/googleGeoDistanceVisualizer1xn?id='+originalGeoMatchId);
     		p.setRedirect(true);
     		return p;
     	}
     	else
     		return ZipOrAreaTab;
     }
     
     public PageReference Visualize(){
     	PageReference p;
     	if(sTypeParam=='reAssignHF'){
     		//Re assign HF
     		p = new PageReference('/apex/googleGeoDistanceVisualizer1xn?id='+placeHolderGeoMatch.Id+'&originalGeoMatchId='+originalGeoMatchId+'&stype=reAssignHF');
  	   	}
  	   	else{
  	   		//Re Assigning Zip or Area
     		p = new PageReference('/apex/googleGeoDistanceVisualizer1xn?id='+placeHolderGeoMatch.Id+'&goBackTo=SplitPage');
  	   	}
     	p.setRedirect(true);
     	return p;     	
     }
     
     public void changeOwnerForGeoMatchedRelatedObjs(List<GeoMatch__c> geoMatchesForChOwn){
        
        if(geoMatchesForChOwn!=null && geoMatchesForChOwn.size()>0){
            Map<Id,GeoMatch__c> mapIdGM = (new Map<Id,GeoMatch__c>(geoMatchesForChOwn));    
            
            
            geoMatchesForChOwn = [SELECT Id,Match_Status__c,HF_Ownership_Set__c,FromiGeoLocate__r.Lead__c,FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__c,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__c,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__c,ToiGeoLocate__r.Contact__r.Id FROM GeoMatch__c WHERE Id IN :mapIdGM.keySet()];
            
            System.debug('ENTERED OWNER CHANGE ----->'+geoMatchesForChOwn);
            System.debug('ENTERED OWNER CHANGE ----->'+geoMatchesForChOwn.size());
            
            Map<Id,Id> contactIdAndOwnerIdMap = new Map<Id,Id>();
            Set<Id> contactIdsOfAds = new Set<Id>(); 
            List<Applicant_Info__c> applicationsToBeChOwned = new List<Applicant_Info__c>();            
            List<Account> accountsToBeChOwned = new List<Account>();
            List<Position__c> positionsToBeChOwned = new List<Position__c>();
            List<Opportunity> oppsToBeChOwned = new List<Opportunity>();
                        
            Set<Id> toiGLs = new Set<Id>();
            //Get All AD's in context
            for (GeoMatch__c geoMatchToBeChOwned : geoMatchesForChOwn){                 
                System.debug('ENTERED OWNER CHANGE ----->'+geoMatchToBeChOwned.ToiGeoLocate__c);  
                toiGLs.add(geoMatchToBeChOwned.ToiGeoLocate__c);    
                //contactIdsOfAds.add(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__c);                
            }
            
            System.debug('ENTERED toiGLs----->'+toiGLs);
                        
            if(toiGLs!=null){
                //contactIdsOfAds.add([SELECT Contact__c FROM iGeoLocate__c WHERE Id IN:toiGLs].Contact__c);
                List<iGeoLocate__c> iGeoList = [SELECT Id,Contact__c FROM iGeoLocate__c WHERE Id IN:toiGLs];
                if(iGeoList!=null && iGeoList.size()>0){
                    for(iGeoLocate__c geoL:iGeoList){
                        contactIdsOfAds.add(geoL.Contact__c);
                    }
                }
            }
                        
            System.debug('ENTERED contactIdsOfAds----->'+contactIdsOfAds);
            
            //Get the corresponding userid and map it
            List<User> ADUsers = [select Id,ContactId from User where contactId in :contactIdsOfAds ]; 
            for (User ADUser : ADUsers){
                if (!contactIdAndOwnerIdMap.containsKey(ADUser.ContactId))
                    contactIdAndOwnerIdMap.put(ADUser.ContactId,ADUser.Id);
            }
            
            System.debug('ENTERED contactIdAndOwnerIdMap----->'+contactIdAndOwnerIdMap);
            
            //Get list of related Applications
            Set<Id> geoMatchesSet = new Map<Id,sObject>(geoMatchesForChOwn).KeySet();
            List<GeoMatch__c> relatedAccounts = [select FromiGeoLocate__r.Account__c from GeoMatch__c where id in :geoMatchesSet];
            Set<Id> relatedAccIds = new Set<Id>();
            for (GeoMatch__c geoMatch : relatedAccounts){
                relatedAccIds.add(geoMatch.FromiGeoLocate__r.Account__c);
            }
            
            System.debug('ENTERED relatedAccIds----->'+relatedAccIds);
            
            List<Applicant_Info__c> relatedAppInfos = [select Id,Account__c,Account__r.Id,ownerid,Position__c,Position__r.OwnerId,CreatedDate from Applicant_Info__c where Account__c in :relatedAccIds ORDER BY CreatedDate ASC];
            Map<Id,Applicant_Info__c> accAppMap = new Map<Id,Applicant_Info__c>();          
            Set<Id> relatedPosIds = new Set<Id>();
            
            for (Applicant_Info__c appInfo : relatedAppInfos){
                accAppMap.put(appInfo.Account__c,appInfo);
                relatedPosIds.add(appInfo.Position__c);             
            }
            
            System.debug('ENTERED accAppMap----->'+accAppMap);
            System.debug('ENTERED relatedPosIds----->'+relatedPosIds);
            
            Map<Id,Position__c> accPosMap = new Map<Id,Position__c>();
            if(relatedPosIds!=null){
                List<Position__c> relatedPosInfos = [SELECT Id,OwnerId,Host_Company_Id__c FROM Position__c WHERE Id IN:relatedPosIds];
                for(Position__c pos:relatedPosInfos){
                    accPosMap.put(pos.Host_Company_Id__c,pos);
                }               
            }
            
            System.debug('ENTERED accPosMap----->'+accPosMap);
            
            List<Opportunity> relatedOpps = [SELECT Id,AccountId,OwnerId,CreatedDate,ChildOppType__c FROM Opportunity WHERE AccountId IN:relatedAccIds AND ChildOppType__c=NULL ORDER BY CreatedDate ASC];
            Map<Id,Opportunity> accOppMap = new Map<Id,Opportunity>();
            for(Opportunity opp:relatedOpps){
            	accOppMap.put(opp.AccountId, opp);
            }
            System.debug('ENTERED accOppMap----->'+accOppMap);
            
            
            //Change the owner of appropriate objects
            for (GeoMatch__c geoMatchToBeChOwned : geoMatchesForChOwn){
                System.debug('ENTERED geoMatchToBeChOwned----->'+geoMatchToBeChOwned);
                
                //Setting the ownership change flag to true
                //geoMatchToBeChOwned.HF_Ownership_Set__c = true;
                
                if (geoMatchToBeChOwned.FromiGeoLocate__r.Account__r.Id != null){
                    
                    geoMatchToBeChOwned.FromiGeoLocate__r.Account__r.OwnerId = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
                    accountsToBeChOwned.add(geoMatchToBeChOwned.FromiGeoLocate__r.Account__r);
                    
                    if(accAppMap!=null && accAppMap.size()>0 && accAppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c)!=null){
	                    accAppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c).ownerid = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
	                    applicationsToBeChOwned.add(accAppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c));
                    }
                    
                    if(accPosMap!=null && accPosMap.size()>0){
                    	if(accPosMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c)!=null){
	                        accPosMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c).ownerId = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
	                        positionsToBeChOwned.add(accPosMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c));
                    	}
                    }
                    
                    if(accOppMap!=null && accOppMap.size()>0){
                    	if(accOppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c)!=null){
		                    accOppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c).ownerId = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
		                    oppsToBeChOwned.add(accOppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c));
                    	}
                    }
                }
            }
            try{
                
                System.debug('ENTERED applicationsToBeChOwned----->'+applicationsToBeChOwned);
                System.debug('ENTERED accountsToBeChOwned----->'+accountsToBeChOwned);
                System.debug('ENTERED positionsToBeChOwned----->'+positionsToBeChOwned);
                System.debug('ENTERED oppsToBeChOwned----->'+oppsToBeChOwned);
                
                //this will set the HF ownership flag to true for the GeoMatch.
                update geoMatchesForChOwn;                
                
                update accountsToBeChOwned;             
                update applicationsToBeChOwned;     
                if(positionsToBeChOwned!=null && positionsToBeChOwned.size()>0){        
                    update positionsToBeChOwned;
                }
                if(oppsToBeChOwned!=null && oppsToBeChOwned.size()>0){
                	update oppsToBeChOwned;
                }                
            }
            catch(exception e){
                system.debug('EXCEPTION----'+e);
            }
        }
        
        
     }
     
     
    
}