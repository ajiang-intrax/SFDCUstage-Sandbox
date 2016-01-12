global class IPUTriggerHelper {
   /**
    * Description   :   This method deletes Uploaded documents through Intrax Program Uploads
    * @args         :   Document Service, Document Guid Id, Record Id
    * @return       :   void
    */
  @Future(callout=true)
  public static void deleteUpload(String docServ, String Id, String docGUID) {
  	system.debug('******Inside HELPER**********');
	Http h = new Http();
    String responseXML;
   
    HttpResponse res = new HttpResponse();
   
   HttpRequest req = new HttpRequest();
    req.setMethod('POST'); 
       req.setHeader('Accept', 'application/xml');
    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
    String body = '';
    if (docServ == 'DS'){
        req.setEndpoint(Constants.documentService+'Remove');
    }
    else{
        req.setEndpoint(Constants.imageService+'Remove');
    }
     body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';    
     body = body + docGUID;
     	system.debug('******Inside body**********'+body);
     req.setBody(body);
     //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
     system.debug('******req.getBody()**********'+req.getBody());
     Dom.Document docRes = new Dom.Document();
     string returnurl = null;
     res = h.send(req);
     
     system.debug('****Res****'+ res);
     responseXML = res.getBody();
       system.debug('****responseXML****'+ responseXML);
     docRes.load(responseXML);

     List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
     
   	 for (dom.XmlNode node : resnodelist){
     if ( node.getName() == 'result'){
         returnurl = node.getText(); 
    }
    }      
    }
      public static void deleteIPU(String ipuId) {
      try{
	      Intrax_Program_Upload__c ObjIPU = new Intrax_Program_Upload__c();	
	     	ObjIPU = [Select Document_service__c,Description__c,id from Intrax_Program_Upload__c where id = :ipuId];
	       delete ObjIPU;
      }
      catch(Exception e){
	        system.debug('********* IPU delete Error: ' + e);
	    }
     }
    //@Future(callout=true)
    public static void TagEngOnIPU(Map<Id,Id> IPUEngagement)
    {
    	try{
    		system.debug('*********Entered tagEngOnIPU');
	    List<Intrax_Program_Upload__c> lstIPUUpdate= new List<Intrax_Program_Upload__c>();	
		Set<id> ipuIds = IPUEngagement.keySet() ;
	    List<Intrax_Program_Upload__c> lstIPUs = [Select Document_service__c,Description__c,id,engagement__c from Intrax_Program_Upload__c where id in :ipuIds];
		For(Intrax_Program_Upload__c ipu:lstIPUs)
		{
			ipu.Engagement__c = IPUEngagement.get(ipu.Id);
		   lstIPUUpdate.add(ipu);	
		   
		}
		if(lstIPUUpdate!=null && lstIPUUpdate.size()>0)
		update lstIPUUpdate;
    	}
    	catch(Exception e){
            system.debug('********* tag engagement on IPU Error: ' + e);
        }
    }
    /* @Future(callout=true)
    public static void shareIPURecord(Id ipuId, Id AppInfoId)
    {
    	Intrax_Program_Upload__c ObjIPU = new Intrax_Program_Upload__c();
    	ObjIPU = [select ID,Document_Guid__c,Applicant_Info__r.OwnerId,Applicant_Info__r.Id,OwnerId,Document_service__c,Description__c from Intrax_Program_Upload__c where id = :ipuId];
    	system.debug('*****trigger.new ObjIPU********'+ObjIPU);
    	Sharing_Security_Controller.shareIPURecord(ObjIPU.Id,ObjIPU.Applicant_Info__r.Id);
    	system.debug('*****trigger.new ObjIPU********'+ObjIPU);
    }*/
}