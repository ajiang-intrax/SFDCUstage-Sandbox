/** * Class Name: MergePdf
* Description : Helper Class of IPUListActionController for Batch Printing of DS Forms
* Copyright : IntraxInc
* * @author : Atif Ali
* */ 

public with sharing class MergePdf{
    // Getting Organization Id
    String orgId = UserInfo.getOrganizationId();
    public static Boolean isTestMode = false;
    public String responseXML{get; set;}
    // Map of IPU ids
    Map<string,Intrax_Program_Upload__c > mapIPUId = new Map<string,Intrax_Program_Upload__c >();
    // List of IPU reocrds
    list<Intrax_Program_Upload__c> loadDoc = new list<Intrax_Program_Upload__c>();
    
        public PageReference bulkload(list <string> lstguid){
        // Instantiate a new http object 
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        string responseBody;
        
        //B-01590
        if(lstguid != null && lstguid.size() > 0){
        loadDoc = [Select id,Document_service__c from Intrax_Program_Upload__c where document_Guid__c in:lstguid];
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(120000); 
        req.setHeader('Accept', 'application/xml');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
        String body = '';
        req.setEndpoint(Constants.documentService+'MergePDFs');
         body = 'authToken='+Constants.serviceAuthToken+'&programId=Sevis';
         String input='';
         string guids='';
         list<String> parts= new list<string>();
         system.debug('listguid'+lstguid);
         system.debug('Debug::constant'+ Body);
         for (integer a=0; a< lstguid.size(); a++){
             //parts=lstguid.get(a).split('\\/');
             //input = parts[parts.size()-1];
             input=lstguid.get(a);
             guids+='&documentGUIDs=';
             guids+=input;
             //guids+=EncodingUtil.URLEncode(input,'UTF-8');
             //guids.add(input);
             system.debug('debug::SplitString='+guids);
         }
         
         body=  body+'&sfdcOrgId='+orgid+guids;
         System.debug('Debug::'+ Body);
         req.setBody(body);
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
         Dom.Document docRes = new Dom.Document();
         System.debug('Debug::'+ Body);
         String returnurl = null;
         string result='';
         string status='';
         Intrax_Program_Upload__c ParentIPU;
         
             if (!isTestMode){
                 res = h.send(req);
                 responseBody= res.getbody();
                 System.debug('Debug::ResponseBody'+ responseBody);
                 System.debug('Debug::StatusCode'+ res.getStatusCode());
                 If(res.getStatusCode()!= 200)
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
                 
                 responseXML = res.getBody();
                 docRes.load(responseXML);
                 List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                 DOM.XMLNode root = docRes.getRootElement();
                 system.debug('debug:Root ='+root);
                 system.debug('Debug::resmorelist'+resnodelist);
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
                 for (dom.XmlNode node : resnodelist){
                    for(Dom.Xmlnode IPUNodes : node.getChildElements()){
                        system.debug('debug::Node.getName'+IPUNodes.getName());
                        system.debug('debug::Node.gettext'+IPUNodes.getText());
                        
                        if (IPUNodes.getName() == 'result'){
                        result=IPUNodes.getText();
                        }
                        
                        If(IPUNodes.getName() == 'status'){
                            status=IPUNodes.getText();
                        }
                        
                    }
                 }
             } 
             else{
             	Status = 'OK';
             }     
                 system.debug('debug:: Status='+status);
                 system.debug('debug:: Result='+result);
                 
                 If(Status == 'OK'){
                    RecordType RecType = [Select Id From RecordType  Where SobjectType = 'Intrax_Program_Upload__c' and DeveloperName = 'SEVIS'];
                    ParentIPU = new Intrax_Program_Upload__c();
                    ParentIPU.Name= 'Batch DS-2019 '+datetime.now().format();
                    ParentIPU.Document_GUID__c=Result;
                    ParentIPU.Printed_Date__c=system.today();
                    ParentIPU.RecordTypeId=RecType.id;
                    ParentIPU.Document_Type__c='DS-2019';
                    ParentIPU.Document_Service__c='DS';
                    ParentIPU.Is_Parent__c=True;
                    Insert ParentIPU;
                  
                  list<Intrax_Program_Upload__c> updchildIPUlst = new list<Intrax_Program_Upload__c>();
                  
                  for(Intrax_Program_Upload__c ChildIPU : loadDoc){
                  mapIPUId.put(ChildIPU.id,ChildIPU);
                  }
                  
                      for(Intrax_Program_Upload__c IPUobj:loadDoc){
                        Intrax_Program_Upload__c IPU = mapIPUId.get(IPUobj.id);
                        IPU.Parent_Intrax_Program_Upload__c=ParentIPU.id;
                        IPU.Printed_Date__c=system.today();
                        updchildIPUlst.add(IPU);
                      }
                  Database.SaveResult[] results = Database.update(updchildIPUlst,false);
                  //update updchildIPUlst;
                  
                 String ParentRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ParentIPU.Id;
                 return new PageReference(ParentRecordURL);
                 }
                 else{
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Status);
                    ApexPages.addMessage(msg);
                    return null;
                 }
	        }
	        else return null;
        }
        
        public void setTestMode(){
        isTestMode = true;
        }
}