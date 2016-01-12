public class geoservicesWebServices {
//Generated by wsdl2apex

    public class GeoObject {
        public String address1;
        public String city;
        public String country;
        public String geoId;
        public String postalCode;
        public String state;
        private String[] address1_type_info = new String[]{'address1','http://geoservices.webservices',null,'1','1','true'};
        private String[] city_type_info = new String[]{'city','http://geoservices.webservices',null,'1','1','true'};
        private String[] country_type_info = new String[]{'country','http://geoservices.webservices',null,'1','1','true'};
        private String[] geoId_type_info = new String[]{'geoId','http://geoservices.webservices',null,'1','1','true'};
        private String[] postalCode_type_info = new String[]{'postalCode','http://geoservices.webservices',null,'1','1','true'};
        private String[] state_type_info = new String[]{'state','http://geoservices.webservices',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://geoservices.webservices','false','false'};
        private String[] field_order_type_info = new String[]{'address1','city','country','geoId','postalCode','state'};
    }
    public class geoservices_cfc {
        public list<Application_Constants__c> geoServiceEndpointList;
    	public string GeoServiceEndpoint(){
    		string endpoint;
    		geoServiceEndpointList = Application_Constants__c.getAll().values();
    		if(geoServiceEndpointList != null && geoServiceEndpointList.size() > 0){
    			for(Application_Constants__c ap : geoServiceEndpointList){
    				if(ap.Name == 'Geoservices cfc Endpoint'){
    					endpoint = ap.Value__c;
    				}
    			}
    		}
    		return endpoint;
    	}   
        public String endpoint_x = GeoServiceEndpoint();
        //public String endpoint_x = 'https://cfdev.intraxinc.com/webservices/geoservices/geoservices.cfc';
        //public String endpoint_x = 'https://casper.aupaircare.com/webservices/geoservices/geoservices.cfc';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x = 120000;
        private String[] ns_map_type_info = new String[]{'http://xml.apache.org/xml-soap', 'xmlApacheOrgXmlSoap', 'http://geoservices.webservices', 'geoservicesWebservices'};
        public xmlApacheOrgXmlSoap.Map_x getGeoCode(geoservicesWebservices.GeoObject[] geoObjects) {
            geoservicesWebservices.getGeoCode_element request_x = new geoservicesWebservices.getGeoCode_element();
            geoservicesWebservices.getGeoCodeResponse_element response_x;
            request_x.geoObjects = geoObjects;
            request_x.timeout_x = 120000;
            Map<String, geoservicesWebservices.getGeoCodeResponse_element> response_map_x = new Map<String, geoservicesWebservices.getGeoCodeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://geoservices.webservices',
              'getGeoCode',
              'http://geoservices.webservices',
              'getGeoCodeResponse',
              'geoservicesWebservices.getGeoCodeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getGeoCodeReturn;
        }
    }
    public class getGeoCodeResponse_element {
        public xmlApacheOrgXmlSoap.Map_x getGeoCodeReturn;
        private String[] getGeoCodeReturn_type_info = new String[]{'getGeoCodeReturn','http://geoservices.webservices',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://geoservices.webservices','true','false'};
        private String[] field_order_type_info = new String[]{'getGeoCodeReturn'};
    }
    public class getGeoCode_element {
        public geoservicesWebservices.GeoObject[] geoObjects;
        private String[] geoObjects_type_info = new String[]{'geoObjects','http://geoservices.webservices',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://geoservices.webservices','true','false'};
        private String[] field_order_type_info = new String[]{'geoObjects'};
        private Integer timeout_x;
    }
}