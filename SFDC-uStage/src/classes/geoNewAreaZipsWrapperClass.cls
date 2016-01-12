public class geoNewAreaZipsWrapperClass {
     public Boolean isSelected {get;set;}
     public Zip_Code__c cZipCode {get;set;}

     public geoNewAreaZipsWrapperClass(Zip_Code__c cZipCode){
          this.cZipCode = cZipCode;
     }
}