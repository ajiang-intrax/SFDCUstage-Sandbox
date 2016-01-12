@isTest(seeAllData=false)

private class Test_AddressValidation {

    static testMethod void myUnitTest() {
        AddressValidation_Processor av = new AddressValidation_Processor();
        av.address1 = '600 California';
        av.address2 = 'FL 10';
        av.address3 = '';
        av.address4 = '';
        av.city = 'San Francisco';
        av.state = 'CA';
        av.postalCode = '94108';
        av.country = 'United States';
        
        Application_Constants__c setting = new Application_Constants__c();
        setting.Name = 'EndPoint_AddressValidation';
        setting.Key__c = 'EndPoint_AddressValidation';
        setting.Value__c = 'http://svc.dev.intraxinc.com:8080/AddressService-v3/AddressService';
        insert setting;
        
        av.verifyAddress();
        
        addressValidationService.geocodeAddressResponse geo = new addressValidationService.geocodeAddressResponse();
        addressValidationService.geocodeResult geor = new addressValidationService.geocodeResult();
        addressValidationService.calculateDistanceResponse calc = new addressValidationService.calculateDistanceResponse();
        addressValidationService.calculateDistance calc1 = new addressValidationService.calculateDistance();
        
        addressValidationService.geocodeAddress gc = new addressValidationService.geocodeAddress();
        addressValidationService.verificationResult ver = new addressValidationService.verificationResult();
        addressValidationService.providerData pr = new addressValidationService.providerData();
        addressValidationService.faultInfo fl = new addressValidationService.faultInfo();
        addressValidationService.verifyAddressResponse verf = new addressValidationService.verifyAddressResponse();
        
        addressValidationService.duration dur = new addressValidationService.duration();
        addressValidationService.distance dis = new addressValidationService.distance();
        addressValidationService.address addr = new addressValidationService.address();
        addressValidationService.AddressServicePort adds = new addressValidationService.AddressServicePort();
        
        
        addressValidationService.verifyAddress verad = new addressValidationService.verifyAddress();
    }
}