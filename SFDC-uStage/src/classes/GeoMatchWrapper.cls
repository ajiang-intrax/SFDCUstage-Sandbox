public with sharing class GeoMatchWrapper {


   public Id ValidatorId {get; set;}
    public GeoMatch__c meet{get;set;}
   public Id GeoMatchId {get; set;}
   public Double DistanceInMiles{get;set;}
   public Double DistanceInKms{get;set;}
   public string strValidatorName {get;set;}   
    public string strSelectedValidator{get;set;}
    public boolean SelectedValidator {get; set;}
      public GeoMatchWrapper(GeoMatch__c m)
        {
            meet=m;
            SelectedValidator=false;
        }
          
        
   
}