global class IPUUpdate {
@Future(callout=true)
 public static void updateMeta(String GUID,String description,String service){
    try {
		String responseXML;
      Dom.Document doc = new Dom.Document();
      String docXML = '<metaUpdateDAO><authToken></authToken><connectionReceived></connectionReceived><connectionReceivedId></connectionReceivedId><connectionSend></connectionSend><connectionSendId></connectionSendId><deleted></deleted><description></description><documentGUID></documentGUID><exists></exists><infoText></infoText><lastModifiedBy></lastModifiedBy><lastModifiedById></lastModifiedById><lastModifiedDate></lastModifiedDate><name></name><partnerShared></partnerShared><private></private><returnFieldList></returnFieldList><sfdcOrgId></sfdcOrgId><status></status><systemModstamp></systemModstamp><version></version></metaUpdateDAO>';
      doc.load(docXML);
      List<dom.XmlNode> nodelist = doc.getRootElement().getChildElements();
      for (dom.XmlNode node : nodelist){
        if ( node.getName() == 'documentGUID'){
                node.addTextNode(GUID);
        }
        if ( node.getName() == 'lastModifiedDate'){
                node.addTextNode(datetime.now().format('yyyy-mm-dd HH:mm:ss'));
        }
        if ( node.getName() == 'description'){
                node.addTextNode(description);
        }
        if ( node.getName() == 'systemModstamp'){
                node.addTextNode(datetime.now().format('yyyy-mm-dd  HH:mm:ss'));
        }
        if ( node.getName() == 'authToken'){
                node.addTextNode('aRsPuKzDqKeQv4pBb9gEySf2mLkUqOdQhL');
        }
      }

       //Instantiate a new http object                 
          Http h = new Http();
          HttpResponse res = new HttpResponse();
                
            //Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
                
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');  
                req.setHeader('Accept', 'application/xml');
                req.setHeader('Content-Type', 'application/xml');
                req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                if (service == 'IS')
					req.setEndpoint(Constants.imageService+'UpdateMetadata');
				else
					req.setEndpoint(Constants.documentService+'UpdateMetadata');
                String body = doc.toXmlString();
                req.setBody(body);  
                
             //Send the request, and return a response 
                Dom.Document docRes = new Dom.Document();
                res = h.send(req);
                responseXML = res.getBody();
                docRes.load(responseXML);
                
                system.debug(responseXML);
                List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                /*for (dom.XmlNode node : resnodelist){
                    if ( node.getName() == 'result'){
                       if (node.getText().equals('Ok')){
                       	return true;
                       }
                       else
                       	return false;
                    }
                    else
                    	return false;
                }
                return false;*/

      } catch (DMLException e) {
	      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e.getMessage() ));
      } finally {
     }
   }
}