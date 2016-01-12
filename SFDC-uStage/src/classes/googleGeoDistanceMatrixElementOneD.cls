public with sharing class googleGeoDistanceMatrixElementOneD {
    public iGeoLocate__c toGeo {get;set;}
    public Double destLatAddress {get;set;}
    public Double destLongAddress {get;set;}
    public Double distanceInKms {get;set;}
    public Double durationInMins {get;set;}
    public String pairingStatus {get; set;}
    
    public googleGeoDistanceMatrixElementOneD(iGeoLocate__c toGeo,Double destLatAddress,Double destLongAddress){
        settoGeo(toGeo);
        setdestLatAddress(destLatAddress);
        setdestLongAddress(destLongAddress);
        setpairingStatus('Dating');
    }


    public void settoGeo (iGeoLocate__c geo){
    	toGeo = geo;    
    }
    public iGeoLocate__c gettoGeo (){
    	return toGeo;
    }
    public void setdestLatAddress (Double coord){
    	destLatAddress = coord;    
    }
    public Double getdestLatAddress (){
    	return destLatAddress;
    }
    public void setdestLongAddress (Double coord){
    	destLongAddress = coord;    
    }
    public Double getdestLongAddress (){
    	return destLongAddress;
    }
    public void setdistanceInKms (Double dist){
    	distanceInKms = dist;    
    }
    public Double getdistanceInKms (){
    	return distanceInKms;
    }
    public void setdurationInMins (Double dist){
    	durationInMins = dist;    
    }
    public Double getdurationInMins (){
    	return durationInMins;
    }
    public void setpairingStatus (String status){
    	pairingStatus = status;    
    }
    public String getpairingStatus (){
    	return pairingStatus;
    }
	public void markAsInCompatible(){
		setpairingStatus('InCompatible');
	}
	public void markAsCompatible(){
		setpairingStatus('Compatible');
	}
}