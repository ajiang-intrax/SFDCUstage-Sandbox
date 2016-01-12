public class googleGeoDistanceMatrixElement {
    public iGeoLocate__c fromGeo {get;set;}
    public iGeoLocate__c toGeo {get;set;}
    public Double sourceLatAddress {get;set;}
    public Double sourceLongAddress {get;set;}
    public Double destLatAddress {get;set;}
    public Double destLongAddress {get;set;}
    public Double distanceInKms {get;set;}
    public Double durationInMins {get;set;}
    public String pairingStatus {get; set;}
    
    public googleGeoDistanceMatrixElement(iGeoLocate__c fromGeo,iGeoLocate__c toGeo,Double sourceLatAddress,Double sourceLongAddress,Double destLatAddress,Double destLongAddress){
        setfromGeo(fromGeo);
        settoGeo(toGeo);
        setsourceLatAddress(sourceLatAddress);
        setsourceLongAddress(sourceLongAddress);
        setdestLatAddress(destLatAddress);
        setdestLongAddress(destLongAddress);
        setpairingStatus('Dating');
    }
    public void setfromGeo (iGeoLocate__c geo){
    	fromGeo = geo;    
    }
    public iGeoLocate__c getfromGeo (){
    	return fromGeo;
    }
    public void settoGeo (iGeoLocate__c geo){
    	toGeo = geo;    
    }
    public iGeoLocate__c gettoGeo (){
    	return toGeo;
    }
    public void setsourceLatAddress (Double coord){
    	sourceLatAddress = coord;    
    }
    public Double getsourceLatAddress (){
    	return sourceLatAddress;
    }
    public void setsourceLongAddress (Double coord){
    	sourceLongAddress = coord;    
    }
    public Double getsourceLongAddress (){
    	return sourceLongAddress;
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
	public void divorceThisPair(){
		fromGeo = null;
		toGeo = null;
		sourceLatAddress = null;
		sourceLongAddress = null;
		destLatAddress = null;
		destLongAddress = null;
		setpairingStatus('Divorced');
	}
	public void makeFromSingle(){
		toGeo = null;
		destLatAddress = null;
		destLongAddress = null;
		setpairingStatus('Single');
	}
	public void markAsInCompatible(){
		setpairingStatus('InCompatible');
	}
	public void markAsCompatible(){
		setpairingStatus('Compatible');
	}
}