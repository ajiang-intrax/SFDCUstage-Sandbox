public with sharing class aws_controller {
    
    public static String responseXML{get;set;}
    public static Integer noOfAPPhotos = 5;
    
    public String fileUploadUrl{
        get{
            return Constants.fileUploadUrl2;
        }
    }
    
    /* Is this useful here?
    public PageReference load_by_doctype(string){
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();      
        //system.debug('DocType: ' +ApexPages.currentPage().getParameters().get('dType') );
        //system.debug('GroupId: ' +ApexPages.currentPage().getParameters().get('groupId') );
                
        loadDoc = [Select Document_service__c,Name,Document_GUID__c, createdDate, document_type__c, Group__c
                        from Intrax_Program_Upload__c 
                        where document_type__c =: ApexPages.currentPage().getParameters().get('dType')
                        //and Group__c =: ApexPages.currentPage().getParameters().get('groupId')
                        order by createdDate desc limit 1]; 
                        
        PageReference p = load(loadDoc);
        return p;       
    }*/
    
    /*
    public static PageReference load_by_docGuid(string docGuid){
        Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();      

        loadDoc = [Select Document_service__c,Name,Document_GUID__c, createdDate
                        from Intrax_Program_Upload__c 
                        where document_GUID__c =: docGuid
                        order by createdDate desc]; 
                        
        PageReference p = load(loadDoc);
        return p;       
    }
    */
    /*
    public static PageReference load( Intrax_Program_Upload__c loadDoc){
    
        // Instantiate a new http object 
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
        HttpRequest req = new HttpRequest();
        req.setMethod('POST'); 
        req.setHeader('Accept', 'application/xml');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
        String body = '';
        if (loadDoc.Document_service__c == 'DS'){
            req.setEndpoint(Constants.documentService+'GetFile');
        }
        
        else{           
            req.setEndpoint(Constants.imageService+'GetFile');
        }
        
        body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';
        body = body + loadDoc.Document_GUID__c;
        
        system.debug('debug::RequestBody'+body);
        req.setBody(body);
        Dom.Document docRes = new Dom.Document();
        String returnurl = null;
        
        if (!Test.isRunningTest()){
             res = h.send(req); 
             responseXML = res.getBody();   
             docRes.load(responseXML);
             List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
             
             for (dom.XmlNode node : resnodelist){
                
                system.debug('debug::node.Name=='+node.getName());
                system.debug('debug::node.getText=='+node.getText());
                  
                if (loadDoc.Document_service__c != 'VS' && node.getName() == 'result'){
                    returnurl = node.getText();
                    //spillai video changes
                    return new PageReference(returnurl);
                }
                 
                             
                if(node.getName() == 'error'){
                string error= node.getText();
                    if(error.contains('is not found')){                        
                        if(Site.getBaseUrl() != null && Site.getBaseUrl().contains('force.com')){
                            pageReference p = new pageReference('/apex/SiteDocViewer?id=' + applicantInfo.Id+'&docGuid='+loadDoc.Document_GUID__c);
                            p.setRedirect(true);
                            return p;   
                        } else{
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, we appear to be unable to locate this file. Document GUID='+loadDoc.document_Guid__c);
                            ApexPages.addMessage(msg);
                            return null;
                        }
                    }
                } 
             }
             //spillai video changes
             return null;
        }
        else{
            return new PageReference('');
        }
    }
    */
    
    public static list<String> getPhotoList(list<String> incomingGUIDs){    
    
        list<String> returnedParams = new list<String>();
        //string responseXML;
        string returnURL;
        list<String> returnURLList = new list<String>();    
        system.debug('+-+-+-+- incomingGUIDs: ' + incomingGUIDs);
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c ();
            
            try{                                        
                if (incomingGUIDs != null){
                    
                
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                     
                    String documentGUIDS = '';
                        
                    for (String documentGUID : incomingGUIDs){
                        if(documentGUID.contains('photos.intraxinc.com')){
                            returnURLList.add(documentGUID);    
                        }else{
                            documentGUIDS = documentGUIDS+'&documentGUIDS=' + documentGUID;
                        }
                    }
                    
                    system.debug('+-+-+-+- returnURLList: ' + returnURLList);
                                            
                    body = 'authToken='+Constants.serviceAuthToken+documentGUIDS+'&size=medium'; //+Constants.PartnerPortalPTMatchPosPhotosDocSizes.get('PPPTMatchPosDocSize');
                    
                     system.debug('Body is:'+body);                  
                     req.setBody(body);
                     system.debug('Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                        system.debug('***** resnodelist: ' + resnodelist);
                        for (dom.XmlNode node : resnodelist){
                            system.debug('***** node: ' + node);                            
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                for (dom.XmlNode childnode : childNodes){
                                    system.debug('***** childNode: ' + childNode);
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        returnURLList.add(returnURL);
                                        System.debug('returnURL'+returnURL);
                                    }
                                    
                                }
                            }
                        }
                     }
                                        
            }
            else{
                returnURLList = null;
            }
          }catch(Exception e){
              system.debug('****** Impossible to get PT image: ' + e);
          } 
        }
        system.debug('*****###ReturnURLList: ' + returnURLList);
        return returnURLList;
    }
    
    public static Map<String, String> getPhotoListWithDesc(Map<String, String> incomingGUIDs){    
    	
    	Map<String, String> returnMap = new Map<String, String>();
    	system.debug('	 ' + incomingGUIDs);
        list<String> returnedParams = new list<String>();
        //string responseXML;
        string returnURL;
        string returnDesc;
         
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c ();
            
            try{                                        
                if (incomingGUIDs.size() > 0){
                    
                
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                     
                    String documentGUIDS = '';
                                            
                    for (String documentGUID : incomingGUIDs.KeySet()){
                        if(documentGUID.contains('photos.intraxinc.com')){                        	
                            returnMap.put(documentGUID, incomingGUIDs.get(documentGUID));    
                        }else{
                            documentGUIDS = documentGUIDS+'&documentGUIDS=' + documentGUID;
                        }
                    }
                    
                    system.debug('+-+-+-+- returnMap: ' + returnMap);
                                            
                    body = 'authToken='+Constants.serviceAuthToken+documentGUIDS+'&size=medium'; //+Constants.PartnerPortalPTMatchPosPhotosDocSizes.get('PPPTMatchPosDocSize');
                    
                     system.debug('Body is:'+body);                  
                     req.setBody(body);
                     system.debug('Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                        system.debug('***** resnodelist: ' + resnodelist);
                        for (dom.XmlNode node : resnodelist){
                            system.debug('***** node: ' + node);                            
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                for (dom.XmlNode childnode : childNodes){
                                    system.debug('***** childNode: ' + childNode);
                                    if (childnode.getName() == 'result'){
                                        returnURL = childnode.getText();                                        
                                        System.debug('returnURL'+returnURL);
                                    }
                                    if (childnode.getName() == 'description'){
                                        returnDesc = childnode.getText();                                        
                                        System.debug('returnDesc'+returnDesc);
                                    }
                                }
                                if(returnDesc == null){
                                	returnDesc = '';
                                }
                                returnMap.put(returnURL, returnDesc);
                            }
                        }
                     }
                                        
            }
          }catch(Exception e){
              system.debug('****** Impossible to get PT image: ' + e);
          } 
        }
        system.debug('*****###returnMap: ' + returnMap.size());
        return returnMap;
    }
    
    
    
    public static string getPhotoURL(String documentGUID){
        
        String returnPhotoURL = 'no-picture';
  
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            
            try{                                        
                if (documentGUID != null){
                
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Accept', 'application/xml');
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    
                    req.setEndpoint(Constants.imageService+'GetFile');
         
                    body = 'authToken='+Constants.serviceAuthToken+'&documentGUID='+documentGUID;//+'&size=medium'; //+Constants.PartnerPortalPTMatchPosPhotosDocSizes.get('PPPTMatchPosDocSize');
                    
                     system.debug('Body is:'+body);                  
                     req.setBody(body);
                     system.debug('Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                        system.debug('***** resnodelist: ' + resnodelist);
                        for (dom.XmlNode node : resnodelist){
                            system.debug('***** node: ' + node);                               
                            if ( node.getName() == 'result'){
                                returnPhotoURL = node.getText();
                                System.debug('***** returnPhotoURL'+returnPhotoURL);
                            }
                        }
                     }                   
                }            
          }catch(Exception e){
              system.debug('****** Impossible to get PT image: ' + e);
          } 
        }
        system.debug('****** returnPhotoURL: ' + returnPhotoURL);
        return returnPhotoURL;
    }
    
    
    public static list<String> getPhotoListThumb(list<String> incomingGUIDs){    
    
        list<String> returnedParams = new list<String>();
        //string responseXML;
        string returnURL;
        list<String> returnURLList = new list<String>();    
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c ();
            
            try{                                        
                if (incomingGUIDs != null){
                
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                     
                    String documentGUIDS = '';
                        
                    for (String documentGUID : incomingGUIDs){
                        documentGUIDS = documentGUIDS+'&documentGUIDS=' + documentGUID;
                    }
                                            
                    body = 'authToken='+Constants.serviceAuthToken+documentGUIDS+'&size=thumbnail'; //+Constants.PartnerPortalPTMatchPosPhotosDocSizes.get('PPPTMatchPosDocSize');
                    
                     system.debug('Body is:'+body);                  
                     req.setBody(body);
                     system.debug('Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                        system.debug('***** resnodelist: ' + resnodelist);
                        for (dom.XmlNode node : resnodelist){
                            system.debug('***** node: ' + node);                            
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                for (dom.XmlNode childnode : childNodes){
                                    system.debug('***** childNode: ' + childNode);
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        returnURLList.add(returnURL);
                                        System.debug('returnURL'+returnURL);
                                    }
                                    
                                }
                            }
                        }
                     }
                                        
            }
            else{
                returnURLList = null;
            }
          }catch(Exception e){
              system.debug('****** Impossible to get PT image: ' + e);
          } 
        }
        system.debug('*****###ReturnURLList: ' + returnURLList.size());
        return returnURLList;
    }
    
    public static map<String, string> getParticipantPhotoList(list<Engagement__c> engList){
        
        string returnURL;
        string applicationId;
        string ProgramTypeStr = '';
        list<String> appIds = new list<String>();
        map<String, String> returnURLmap = new map<String, String>();
        
        map<String, String> mapEngs = new map<String, String>();
        map<String, String> mapPTImage = new map<String, String>();
        
        map<String, String> mapGuidEng = new map<String, String>();
        map<String, String> mapGuidURL = new map<String, String>();
        
        list<String> returnURLList = new list<String>();    
        //system.debug('*****###appinfoId: ' + appInfo);
        for(Engagement__c eng : engList){
            returnURLmap.put(eng.Id,'no-picture');
        }
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            list<Intrax_Program_Upload__c> loadDoc_aws = new list<Intrax_Program_Upload__c>();
            list<Intrax_Program_Upload__c> loadDoc_legacy = new list<Intrax_Program_Upload__c>();
                                   
            if (engList.size() > 0)
            {
                ProgramTypeStr = engList[0].Intrax_Program__c;
            }
              
            try{            
                /*loadDoc_legacy = [SELECT d.Applicant_Info__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
                                FROM Intrax_Program_Upload__c d
                                WHERE d.Engagement__c IN: engList
                                AND d.document_GUID__c like '%photos.intraxinc.com%'
                                AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];  */
                
                loadDoc_aws = [SELECT d.Applicant_Info__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
                                FROM Intrax_Program_Upload__c d
                                WHERE d.Engagement__c IN: engList
                                //AND Id NOT IN: loadDoc_legacy
                                AND Document_Guid__c like '%/Participant-Photo/%'
                                //AND (d.document_GUID like '%photos.intraxinc.com%')
                                AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')]; 
                 
                /*if(loadDoc_legacy.size() > 0){
                    for(Intrax_Program_Upload__c ipu : loadDoc_legacy)
                    returnURLmap.put(ipu.Engagement__c, ipu.Document_GUID__c);
                } */              
                if(loadDoc_aws.size() > 0){
                    if (loadDoc_aws != null || loadDoc_aws.size() > 0){
                        for(Intrax_Program_Upload__c ipu : loadDoc_aws)
                        {
                            string guidpath = ipu.Document_GUID__c;
                            system.debug('@@@@@guidpath: ' + guidpath);
                            list<string> guidVal = new list<string>();
                            guidVal = guidpath.split('/');
                            system.debug('@@@@@guidVal: ' + guidVal);
                            if(guidVal.size()>0){
                                list<String> guidValAux = new list<String>();
                                if(guidVal[guidVal.size()-1].contains('.')){
                                	guidValAux = guidVal[guidVal.size()-1].split('\\.');
                                }else{
                                	guidValAux.add(guidVal[guidVal.size()-1]);
                                }
                                mapGuidEng.put(guidValAux[0],ipu.Engagement__c); 
                            }
                        }
                        
                    
                        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                        HttpRequest req = new HttpRequest();
                        req.setMethod('POST'); 
                        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                        String body = '';
                        req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                         
                        String documentGUIDS = '';
                            
                        for (Intrax_Program_Upload__c documentGUID : loadDoc_aws){
                            documentGUIDS = documentGUIDS+'&documentGUIDS=' + documentGUID.Document_GUID__c;
                        }
                                                
                        body = 'authToken='+Constants.serviceAuthToken+documentGUIDS+'&size=medium'; //+Constants.PartnerPortalPTMatchPosPhotosDocSizes.get('PPPTMatchPosDocSize');
                        
                         system.debug('Body is:'+body);                  
                         req.setBody(body);
                         system.debug('Request is:'+req);
                         Dom.Document docRes = new Dom.Document();
                         if (!Test.isRunningTest())  {
                            res = h.send(req);
                            responseXML = res.getBody();
                            system.debug('Response is:'+res.getBody());
                            docRes.load(responseXML);
                         
                            list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                            system.debug('***** resnodelist: ' + resnodelist);
                            for (dom.XmlNode node : resnodelist){
                                system.debug('***** node: ' + node);                            
                                if ( node.getName() == 'result'){
                                    list<dom.XmlNode> childNodes = node.getChildElements();
                                    for (dom.XmlNode childnode : childNodes){
                                        system.debug('***** childNode: ' + childNode);
                                        if ( childnode.getName() == 'result'){
                                            returnURL = childnode.getText();
                                            returnURLList.add(returnURL);
                                            system.debug('@@@@@returnURL: ' + returnURL);
                                            list<String> GuidfromURL = new list<String>();
                                            GuidfromURL = returnURL.split('/');
                                            system.debug('@@@@@GuidfromURL: ' + GuidfromURL);
                                            if (GuidfromURL.size()>0){
                                            	system.debug('@@@@@Inside GuidfromURL');
                                                list<string> FinalGuidfromURL = new list<string>();
                                                FinalGuidfromURL = GuidfromURL[GuidfromURL.size()-1].split('\\.');
                                                system.debug('@@@@@FinalGuidfromURL'+FinalGuidfromURL);
                                                if(FinalGuidfromURL.size() > 0){
                                                    if(mapGuidEng.get(FinalGuidfromURL[0]) != NULL){
                                                        returnURLmap.put(mapGuidEng.get(FinalGuidfromURL[0]),returnURL);
                                                    } 
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                         }
                                             
                    }
                    else{
                        returnURLmap = null;
                    }
                }
            }catch(Exception e){
                system.debug('****** Impossible to get PT image: ' + e);
                //returnURLmap = null;
                return returnURLmap;
             }
        }
        system.debug('****returnURLmap****'+returnURLmap);
        system.debug('*****###ReturnURLmap: ' + returnURLmap.size());
        return returnURLmap;
    }
        
    /*public static map<String, string> getParticipantPhotoList(list<Engagement__c> engList){
        
        string returnURL;
        string applicationId;
        string ProgramTypeStr = '';
        list<String> appIds = new list<String>();
        map<String, String> returnURLmap = new map<String, String>();
        map<String, String> mapEngs = new map<String, String>();
        map<String, String> mapPTImage = new map<String, String>();
        
        list<String> returnURLList = new list<String>();    
        //system.debug('*****###appinfoId: ' + appInfo);
        for(Engagement__c eng : engList){
            returnURLmap.put(eng.Id,'no-picture');
        }
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            list<Intrax_Program_Upload__c> loadDoc = new list<Intrax_Program_Upload__c>();
                                   
            if (engList.size() > 0)
            {
                ProgramTypeStr = engList[0].Intrax_Program__c;
            }
              
            try{            
                loadDoc = [SELECT d.Applicant_Info__c, d.Engagement__c, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
                                FROM Intrax_Program_Upload__c d
                                WHERE d.Engagement__c IN: engList 
                                AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];  
                
                if (loadDoc != null || loadDoc.size() > 0){
                    for(Intrax_Program_Upload__c ipu : loadDoc){
                        mapPTImage.put(ipu.Engagement__c, 'pt-image-found');
                    }
                    
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    req.setEndpoint(Constants.imageService+'GetImages2');
                    
                    if (ProgramTypeStr == 'Work Travel')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId=wt-pt';
                    else if( ProgramTypeStr == 'AuPairCare')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId=apc-pt';
                    else
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT;                       
                     
                    for(Engagement__c e : engList){
                        
                        body += '&participantIds=' + e.Id;
                    }
                     if (ProgramTypeStr == 'Work Travel')
                        body += '&documentTypes='+'Participant-Photo'+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');
                     else if(ProgramTypeStr == 'AuPairCare')
                        body += '&documentTypes='+'Participant-Photo'+'&sizes=medium';
                     else
                        body += '&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('ProfilePhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     system.debug('****** Body is:'+body);                  
                     req.setBody(body);
                     system.debug('******* Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();

                        for (dom.XmlNode node : resnodelist){
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                for (dom.XmlNode childnode : childNodes){
                                    if ( childnode.getName() == 'participantId'){
                                        applicationId = childNode.getText();
                                        appIds.add(applicationId);
                                        system.debug('***** applicationId!!!!' + childnode.getText());
                                    }
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        //returnURLList.add(returnURL);
                                        system.debug('******** returnURL'+returnURL);
                                    }
                                    // Before doing this, we need to get all the engagements in context
                                    //returnURLapp.put(e.Id, returnURL);
                                }
                                //system.debug('**** mapEngs.get(applicationId): ' + mapEngs.get(applicationId) + '/ returnURL: ' + returnURL);
                                if(mapPTImage.get(applicationId) == 'pt-image-found')
                                    returnURLmap.put(applicationId, returnURL);
                                    
                            }
                        }
                     }
                                         
                }
                else{
                    returnURLmap = null;
                }
            }catch(Exception e){
                system.debug('****** Impossible to get PT image: ' + e);
                //returnURLmap = null;
                return returnURLmap;
             }
        }
        system.debug('*****###ReturnURLmap: ' + returnURLmap.size());
        return returnURLmap;
    }*/
        
    public static map<String, string> getParticipantPhotoList(list<Applicant_Info__c> appInfoList){
        list<String> returnedParams = new list<String>();
        //string responseXML;
        string returnURL;
        string applicationId;
        string ProgramTypeStr = '';
        list<String> appIds = new list<String>();
        map<String, String> returnURLmap = new map<String, String>();
        map<String, String> mapEngs = new map<String, String>();
        map<String, String> mapPTImage = new map<String, String>();
        
        list<String> returnURLList = new list<String>();    
        //system.debug('*****###appinfoId: ' + appInfo);
        for(Applicant_Info__c a : appInfoList){
            returnURLmap.put(a.Id,'no-picture');
        }
        
        
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            list<Intrax_Program_Upload__c> loadDoc = new list<Intrax_Program_Upload__c>();
            /*
            list<Applicant_Info__c> appInfoList = [SELECT ID, PhotoId__c, application_stage__c, Intrax_Program__c, Account__c, Account__r.isPersonAccount 
                                                        FROM Applicant_Info__c 
                                                        WHERE Id IN: appList
                                                        ];
            */                        
            if (appInfoList.size() > 0)
            {
                ProgramTypeStr = appInfoList[0].Intrax_Program__c;
            }
            /*
            for(Applicant_Info__c a: appInfoList){
                mapEngs.put(a.Id, a.Engagement__c);
            }           
             */   
            try{            
                loadDoc = [Select d.Applicant_Info__c, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                            where d.Applicant_Info__c IN: appInfoList AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];  
                
                if (loadDoc != null || loadDoc.size() > 0){
                    for(Intrax_Program_Upload__c ipu : loadDoc){
                        mapPTImage.put(ipu.Applicant_Info__c, 'pt-image-found');
                    }
                    
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    req.setEndpoint(Constants.imageService+'GetImages2');
                    
                     //body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationId='+appInfo.Id+'&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('FamilyPhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     //body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationIds='+appInfoIds+'&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('FamilyPhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     if (ProgramTypeStr == 'Work Travel')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId=wt-pt';
                     else if( ProgramTypeStr == 'AuPairCare')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId=apc-pt';
                     else
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT;                       
                     
                     for(Applicant_Info__c a : appInfoList){
                        //returnURLmap.put(e.Id,'no-picture');
                        body += '&applicationIds=' + a.Id;
                     }
                     if (ProgramTypeStr == 'Work Travel')
                        body += '&documentTypes='+'Participant-Photo'+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');
                     else if(ProgramTypeStr == 'AuPairCare')
                        body += '&documentTypes='+'Participant-Photo'+'&sizes=medium';
                     else
                        body += '&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('ProfilePhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     system.debug('Body is:'+body);                  
                     req.setBody(body);
                     system.debug('Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();

                        for (dom.XmlNode node : resnodelist){
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                for (dom.XmlNode childnode : childNodes){
                                    if ( childnode.getName() == 'applicationId'){
                                        applicationId = childNode.getText();
                                        appIds.add(applicationId);
                                        system.debug('***** applicationId!!!!' + childnode.getText());
                                    }
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        //returnURLList.add(returnURL);
                                        system.debug('returnURL'+returnURL);
                                    }
                                    // Before doing this, we need to get all the engagements in context
                                    //returnURLapp.put(e.Id, returnURL);
                                }
                                //system.debug('**** mapEngs.get(applicationId): ' + mapEngs.get(applicationId) + '/ returnURL: ' + returnURL);
                                if(mapPTImage.get(applicationId) == 'pt-image-found')
                                    returnURLmap.put(applicationId, returnURL);
                                    
                            }
                        }
                     }
                                         
                }
                else{
                    returnURLmap = null;
                }
            }catch(Exception e){
                system.debug('****** Impossible to get PT image: ' + e);
                //returnURLmap = null;
                return returnURLmap;
             }
        }
        system.debug('*****###ReturnURLmap: ' + returnURLmap.size());
        return returnURLmap;
    }
    
    // Fetch Photos from Position 
    public static map<String, string> getParticipantPhotoList(list<Position__c> posList){
        
        string returnURL;
        string applicationId;
        string ProgramTypeStr = '';
        list<String> appIds = new list<String>();
        map<String, String> returnURLmap = new map<String, String>();
        
        map<String, String> mapEngs = new map<String, String>();
        map<String, String> mapPTImage = new map<String, String>();
        
        map<String, String> mapGuidEng = new map<String, String>();
        map<String, String> mapGuidURL = new map<String, String>();
        
        list<String> returnURLList = new list<String>();    
       
        for(Position__c pos : posList){
            returnURLmap.put(pos.Id,'no-picture');
        }
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            list<Intrax_Program_Upload__c> loadDoc = new list<Intrax_Program_Upload__c>();
                                   
            if (posList.size() > 0)
            {
                ProgramTypeStr = posList[0].Intrax_Program__c;
            }
              
            try{            
                loadDoc = [SELECT d.Applicant_Info__c,d.Position__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
                                FROM Intrax_Program_Upload__c d
                                WHERE d.Position__c IN: posList 
                                AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];  
                system.debug('debug::loadDoc--'+loadDoc);
                if (loadDoc != null || loadDoc.size() > 0){
                    for(Intrax_Program_Upload__c ipu : loadDoc)
                    {
                        string guidpath = ipu.Document_GUID__c;
                        list<string> guidVal = new list<string>();
                        guidVal = guidpath.split('/');
                        if(guidVal.size()>0)
                        {
                            mapGuidEng.put(guidVal[guidVal.size()-1],ipu.Position__c); 
                        }
                    }
                    
                    
                
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                     
                    String documentGUIDS = '';
                        
                    for (Intrax_Program_Upload__c documentGUID : loadDoc){
                        documentGUIDS = documentGUIDS+'&documentGUIDS=' + documentGUID.Document_GUID__c;
                    }
                                            
                    body = 'authToken='+Constants.serviceAuthToken+documentGUIDS+'&size=medium'; //+Constants.PartnerPortalPTMatchPosPhotosDocSizes.get('PPPTMatchPosDocSize');
                    
                     system.debug('Body is:'+body);                  
                     req.setBody(body);
                     system.debug('Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                        system.debug('***** resnodelist: ' + resnodelist);
                        for (dom.XmlNode node : resnodelist){
                            system.debug('***** node: ' + node);                            
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                for (dom.XmlNode childnode : childNodes){
                                    system.debug('***** childNode: ' + childNode);
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        returnURLList.add(returnURL);
                                        System.debug('returnURL'+returnURL);
                                        list<string> GuidfromURL = new list<string>();
                                        GuidfromURL = returnURL.split('/');
                                        if (GuidfromURL.size()>0)
                                        {
                                            list<string> FinalGuidfromURL = new list<string>();
                                            FinalGuidfromURL = GuidfromURL[GuidfromURL.size()-1].split('\\.');
                                            if(FinalGuidfromURL.size() > 0)
                                            {
                                                if(mapGuidEng.get(FinalGuidfromURL[0]) != NULL)
                                                {
                                                    returnURLmap.put(mapGuidEng.get(FinalGuidfromURL[0]),returnURL);
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                     }
                                         
                }
                else{
                    returnURLmap = null;
                }
            }catch(Exception e){
                system.debug('****** Impossible to get PT image: ' + e);
                //returnURLmap = null;
                return returnURLmap;
             }
        }
        system.debug('****returnURLmap****'+returnURLmap);
        system.debug('*****###ReturnURLmap: ' + returnURLmap.size());
        return returnURLmap;
    }
    
    
    // Retrieving a list of PT portrait photos from the App when the main object is the Engagement
    public static map<String, string> getParticipantPhotoList(list<Engagement__c> engList, map<String, Applicant_Info__c> mapAppToEng){
        list<String> returnedParams = new list<String>();
        //string responseXML;
        string returnURL;
        string applicationId;
        string ProgramTypeStr = '';
        list<String> appIds = new list<String>();
        map<String, String> returnURLmap = new map<String, String>();
        map<String, String> mapEngs = new map<String, String>();
        map<String, String> mapPTImage = new map<String, String>();
        
        list<String> returnURLList = new list<String>();    
        //system.debug('*****###appinfoId: ' + appInfo);
        for(Engagement__c e : engList){
            returnURLmap.put(e.Id,'no-picture');
        }
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            list<Intrax_Program_Upload__c> loadDoc = new list<Intrax_Program_Upload__c>();
            list<Applicant_Info__c> appInfoList = [SELECT ID, PhotoId__c, application_stage__c, Engagement__c, Engagement__r.Id, Intrax_Program__c, Account__c, Account__r.isPersonAccount 
                                    FROM Applicant_Info__c 
                                    WHERE Engagement__c IN: engList
                                    //AND application_stage__c =: 'Accepted'
                                    ];
                                    
            if (appInfoList.size() > 0)
            {
                ProgramTypeStr = appInfoList[0].Intrax_Program__c;
            }
            
            for(Applicant_Info__c a: appInfoList){
                mapEngs.put(a.Id, a.Engagement__c);
            }           
                
            try{            
                loadDoc = [Select d.Applicant_Info__c, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                            where d.Applicant_Info__c IN: appInfoList AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];  
                
                if (loadDoc != null || loadDoc.size() > 0){
                    for(Intrax_Program_Upload__c ipu : loadDoc){
                        mapPTImage.put(ipu.Applicant_Info__c, 'pt-image-found');
                    }
                    
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    req.setEndpoint(Constants.imageService+'GetImages2');
                    
                     //body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationId='+appInfo.Id+'&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('FamilyPhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     //body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationIds='+appInfoIds+'&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('FamilyPhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     if (ProgramTypeStr == 'Work Travel')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId=wt-pt';
                     else if( ProgramTypeStr == 'AuPairCare')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId=apc-pt';
                     else
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT;                       
                     
                     for(Engagement__c e : engList){
                        //returnURLmap.put(e.Id,'no-picture');
                        body += '&applicationIds=' + mapAppToEng.get(e.Id).Id;
                     }
                     if (ProgramTypeStr == 'Work Travel')
                        body += '&documentTypes='+'Participant-Photo'+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');
                     else if(ProgramTypeStr == 'AuPairCare')
                        body += '&documentTypes='+'Participant-Photo'+'&sizes=medium';
                     else
                        body += '&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('ProfilePhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     system.debug('Body is:'+body);                  
                     req.setBody(body);
                     system.debug('Request is:'+req);
                     Dom.Document docRes = new Dom.Document();
                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        responseXML = res.getBody();
                        system.debug('Response is:'+res.getBody());
                        docRes.load(responseXML);
                     
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();

                        for (dom.XmlNode node : resnodelist){
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                for (dom.XmlNode childnode : childNodes){
                                    if ( childnode.getName() == 'applicationId'){
                                        applicationId = childNode.getText();
                                        appIds.add(applicationId);
                                        system.debug('***** applicationId!!!!' + childnode.getText());
                                    }
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        //returnURLList.add(returnURL);
                                        system.debug('returnURL'+returnURL);
                                    }
                                    // Before doing this, we need to get all the engagements in context
                                    //returnURLapp.put(e.Id, returnURL);
                                }
                                //system.debug('**** mapEngs.get(applicationId): ' + mapEngs.get(applicationId) + '/ returnURL: ' + returnURL);
                                if(mapPTImage.get(applicationId) == 'pt-image-found')
                                    returnURLmap.put(mapEngs.get(applicationId), returnURL);
                                    
                            }
                        }
                     }
                                         
                }
                else{
                    returnURLmap = null;
                }
            }catch(Exception e){
                system.debug('****** Impossible to get PT image: ' + e);
                //returnURLmap = null;
                return returnURLmap;
             }
        }
        system.debug('*****###ReturnURLmap: ' + returnURLmap.size());
        return returnURLmap;
    }
    
     public static Map<String ,Map<String, Intrax_Program_Upload__c >> getVideosParticipant(Applicant_Info__c appInfo){
        
        system.debug('@@@@@ Inside getVideosParticipan');
        list<String> returnedParams = new list<String>();
        string returnURL = '';  
        string returnURLThumb = '';     
        //Map<String ReturnURLThumb,Map<String ReturnURL, Intrax_Program_Upload__c>>
        Map<String ,Map<String, Intrax_Program_Upload__c >> MapVideoThumb = new Map<String ,Map<String, Intrax_Program_Upload__c >>();
        //Map<String ReturnURL, Intrax_Program_Upload__c>
        Map<String,Intrax_Program_Upload__c> MapVideo = new Map<String, Intrax_Program_Upload__c>();
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            List<Intrax_Program_Upload__c> loadDoc = new List<Intrax_Program_Upload__c>();
            
            loadDoc = [Select Id, Document_Guid__c, Thumbnail__c, Description__c, Document_service__c, Document_Type__c, Applicant_Info__c, AWS_ET_Preset__c, AWS_ET_Job_Status__c 
                        from Intrax_Program_Upload__c 
                        where Applicant_Info__c = :appInfo.Id and document_type__c = 'Introductory-Video'];
            
            system.debug('@@@@@## loadDoc: ' + loadDoc);
                            
                if (loadDoc != null && loadDoc.size() > 0){
                    for(Intrax_Program_Upload__c ld:loadDoc){
                    try{
                    if(ld.Document_GUID__c.Contains('permalink.fliqz.com')){
                        map<String, Intrax_Program_Upload__c> video = new map<String, Intrax_Program_Upload__c>();
                        video.put(ld.Document_GUId__c, ld);
                        MapVideoThumb.put('fliqz-video', video);
                    }
                    else if(ld.AWS_ET_Preset__c == 'Generic 720p'){                    
                   
                    
                        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                        HttpRequest req = new HttpRequest();
                        
                        req.setMethod('POST'); 
                        req.setHeader('Accept', 'application/xml');
                        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                        
                        String body = '';
                        String DocGuid = ld.Document_Guid__c;
                        
                        if (ld.Document_service__c == 'DS'){
                            req.setEndpoint(Constants.documentService+'GetFile');
                        }
                        else if(ld.Document_service__c == 'VS'){
                            req.setEndpoint(Constants.videoService+'GetVideoSignedUrl');
                        }
                        else{
                            system.debug('debug::Inside ImageService='+ld.Document_service__c);
                            req.setEndpoint(Constants.imageService+'GetFile');
                        }
                        body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';
                      
                    
                         if(ld.Document_service__c=='VS' && ld.Thumbnail__c== false){
                         body = body + DocGuid +'&protocol=rtmp';
                         }else if(ld.Document_service__c=='VS' && ld.Thumbnail__c== true){
                         body = body + DocGuid +'&protocol=http';
                         }
                         else{
                         body = body + DocGuid;
                         }
                         system.debug('***** BODY: ' + body);
                         
                         
                         
                         req.setBody(body);
    
                         Dom.Document docRes = new Dom.Document();
    
                         if (!Test.isRunningTest())  {
                            res = h.send(req);
                            System.debug('RESPONSE'+res.getBody());
                            responseXML = res.getBody();
                         
                            docRes.load(responseXML);
                            System.debug('docRes'+docRes);
                            list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
    
                            for (dom.XmlNode node : resnodelist){
                                System.debug('nodeName:'+node.getName());
                                if ( ld.Document_service__c != 'VS' && node.getName() == 'result'){
                                    returnURL = node.getText();
                                    //Map<String Document_Guid__c, String ReturnURL >
                                    MapVideo.put(returnURL, ld);
                                    System.debug('@@@@@## returnURL: '+ returnURL);
                                    System.debug('@@@@@## ld: '+ ld);
                                   
                                }
                                if (ld.Document_service__c == 'VS' && node.getName() == 'signedUrl'){
                                    returnurl = node.getText();
                                    if(ld.Thumbnail__c == false){
                                        MapVideo.put(returnURL, ld);
                                        if(returnURLThumb!=null && returnURLThumb!=''){
                                        MapVideoThumb.put(returnURLThumb, MapVideo);
                                        }
                                        
                                    }else{
                                        MapVideoThumb.put(returnURL, MapVideo);
                                        returnURLThumb = returnURL;
                                    }
                                    
                                }
                            }
                         }
                                          
                       }  
                       }catch(Exception e){
                        system.debug('****** Impossible to get PT image: ' + e);
                     }                     
                }//en for loadDoc
                           
            }
            
            
        }
        system.debug('@@@@@## MapPhotoAlbum: ' + MapVideoThumb);
        return MapVideoThumb;
    }
      
    public static Map<String ,Map<String, Intrax_Program_Upload__c >> getVideosParticipant(Engagement__c engagement){
        
        system.debug('@@@@@ Inside getVideosParticipan');
        list<String> returnedParams = new list<String>();
        string returnURL = '';  
        string returnURLThumb = '';     
        //Map<String ReturnURLThumb,Map<String ReturnURL, Intrax_Program_Upload__c>>
        Map<String ,Map<String, Intrax_Program_Upload__c >> MapVideoThumb = new Map<String ,Map<String, Intrax_Program_Upload__c >>();
        //Map<String ReturnURL, Intrax_Program_Upload__c>
        Map<String,Intrax_Program_Upload__c> MapVideo = new Map<String, Intrax_Program_Upload__c>();
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            List<Intrax_Program_Upload__c> loadDoc = new List<Intrax_Program_Upload__c>();           
                            
            loadDoc = [Select Id, Document_Guid__c, Thumbnail__c, Description__c, Document_service__c, Document_Type__c, Applicant_Info__c, AWS_ET_Preset__c, AWS_ET_Job_Status__c, Engagement__c 
                            from Intrax_Program_Upload__c 
                            where Engagement__c =: engagement.Id 
                            and document_type__c = 'Introductory-Video'];
                            
            system.debug('@@@@@## loadDoc: ' + loadDoc);
                         
            if (loadDoc != null && loadDoc.size() > 0){
                for(Intrax_Program_Upload__c ld:loadDoc){
                try{
                    if(ld.Document_GUID__c.Contains('permalink.fliqz.com')){
                        map<String, Intrax_Program_Upload__c> video = new map<String, Intrax_Program_Upload__c>();
                        video.put(ld.Document_GUId__c, ld);
                        MapVideoThumb.put('fliqz-video', video);
                    }else if(ld.AWS_ET_Preset__c == 'Generic 720p'){
                    
                        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                        HttpRequest req = new HttpRequest();
                        
                        req.setMethod('POST'); 
                        req.setHeader('Accept', 'application/xml');
                        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                        
                        String body = '';
                        String DocGuid = ld.Document_Guid__c;
                        
                        if (ld.Document_service__c == 'DS'){
                            req.setEndpoint(Constants.documentService+'GetFile');
                        }
                        else if(ld.Document_service__c == 'VS'){
                            req.setEndpoint(Constants.videoService+'GetVideoSignedUrl');
                        }
                        else{
                            system.debug('debug::Inside ImageService='+ld.Document_service__c);
                            req.setEndpoint(Constants.imageService+'GetFile');
                        }
                        body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';
                      
                    
                         if(ld.Document_service__c=='VS' && ld.Thumbnail__c== false){
                         body = body + DocGuid +'&protocol=rtmp';
                         }else if(ld.Document_service__c=='VS' && ld.Thumbnail__c== true){
                         body = body + DocGuid +'&protocol=http';
                         }
                         else{
                         body = body + DocGuid;
                         }
                         system.debug('***** BODY: ' + body);
                         
                         
                         
                         req.setBody(body);
    
                         Dom.Document docRes = new Dom.Document();
    
                         if (!Test.isRunningTest())  {
                            res = h.send(req);
                            System.debug('RESPONSE'+res.getBody());
                            responseXML = res.getBody();
                         	system.debug('***** responseXML: ' + responseXML);
                         	
                            docRes.load(responseXML);
                            System.debug('***** docRes' + docRes);
                            list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
    
                            for (dom.XmlNode node : resnodelist){
                                System.debug('****** nodeName:' + node.getName());
                                if ( ld.Document_service__c != 'VS' && node.getName() == 'result'){
                                    returnURL = node.getText();
                                    //Map<String Document_Guid__c, String ReturnURL >
                                    MapVideo.put(returnURL, ld);
                                    System.debug('@@@@@## returnURL: '+ returnURL);
                                    System.debug('@@@@@## ld: '+ ld);
                                   
                                }
                                if (ld.Document_service__c == 'VS' && node.getName() == 'signedUrl'){
                                    returnurl = node.getText();
                                    if(ld.Thumbnail__c == false){
                                        MapVideo.put(returnURL, ld);
                                        if(returnURLThumb!=null && returnURLThumb!=''){
                                        MapVideoThumb.put(returnURLThumb, MapVideo);
                                        }
                                        
                                    }else{
                                        MapVideoThumb.put(returnURL, MapVideo);
                                        returnURLThumb = returnURL;
                                    }
                                    
                                }
                            }
                         }
                    }
                 }catch(Exception e){
                    system.debug('****** Impossible to get PT image: ' + e);
                 }                        
            }//en for loadDoc
            
        }
            
            
        }
        system.debug('@@@@@## MapPhotoAlbum: ' + MapVideoThumb);
        return MapVideoThumb;
    }
    
  // Doc Upload  
  public static PageReference loadPhoto(Applicant_Info__c application){ 
    
    // Instantiate a new http object 
    boolean customMessage;
    Http h = new Http();
    HttpResponse res = new HttpResponse();
    Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c();
    
    
    loadDoc = [Select Document_service__c,Name,Document_GUID__c from Intrax_Program_Upload__c where document_Guid__c = :ApexPages.currentPage().getParameters().get('docGuid') ];
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
    HttpRequest req = new HttpRequest();
    req.setMethod('POST'); 
    //AA Fixed View File functionality.
    req.setHeader('Accept', 'application/xml');
    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
    String body = '';
    if (loadDoc.Document_service__c == 'DS'){
        req.setEndpoint(Constants.documentService+'GetFile');
    }
    else if(loadDoc.Document_service__c == 'VS'){
        req.setEndpoint(Constants.videoService+'GetVideoSignedUrl');
    }
    else{
        system.debug('debug::Inside ImageService='+loadDoc.Document_service__c);
        req.setEndpoint(Constants.imageService+'GetFile');
    }
     body = 'authToken='+Constants.serviceAuthToken+'&documentGUID=';

    If(loadDoc.Document_service__c=='VS'){
     body = body + ApexPages.currentPage().getParameters().get('docGuid') +'&protocol=rtmp';
     }
     else{
     body = body + ApexPages.currentPage().getParameters().get('docGuid');
     }
     system.debug('debug::RequestBody'+body);
     req.setBody(body);
     //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,req.getBody() ));
     Dom.Document docRes = new Dom.Document();
     String returnurl = null;
     if(!Test.isRunningTest()){
         res = h.send(req);

         responseXML = res.getBody();

         docRes.load(responseXML);
         List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
         //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
         for (dom.XmlNode node : resnodelist){
            
            system.debug('debug::node.Name=='+node.getName());
            system.debug('debug::node.getText=='+node.getText());
                
                if (loadDoc.Document_service__c != 'VS' && node.getName() == 'result'){
                    returnurl = node.getText();
                    //spillai video changes
                    return new PageReference(returnurl);
                }
                if (loadDoc.Document_service__c == 'VS' && node.getName() == 'signedUrl'){
                    system.debug('debug::VS==node.Name=='+node.getName());
                    returnurl = node.getText();
                    //spillai video changes
                    //rtmpUrlVideo = returnurl;
                    PageReference videoPage = Page.playVideo;
                    //return videoPage ;
                    return null;
                }
                
                if(node.getName() == 'error'){
                customMessage=true;
                string error= node.getText();
                    If(error.contains('is not found')){
                        
                        If(Site.getBaseUrl() != null && Site.getBaseUrl().contains('force.com')){
                        pageReference p = new pageReference('/apex/SiteDocViewer?id=' + application.Id+'&docGuid='+loadDoc.Document_GUID__c);
                        p.setRedirect(true);
                        return p;   
                        }
                    
                        else{
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, we appear to be unable to locate this file. Document GUID='+loadDoc.document_Guid__c);
                        ApexPages.addMessage(msg);
                        return null;
                        }
                    }
                }   
         }
         //spillai video changes
         return null;
    }
    else{
        return new PageReference('testurl');
    }
 
  }
  
  public static String getApcManagerPhoto(String UserPrID){
        
        system.debug('@@@@@ Inside getApcManagerPhoto');
        system.debug('@@@@@ UserPrID: ' + UserPrID);
        
        //string responseXML;
        string returnURL = '';
        string DocumentGuid = '';       
        
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            List<Intrax_Program_Upload__c> loadDoc = new List<Intrax_Program_Upload__c>();
            
                try{
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    loadDoc = [Select Id, Document_Guid__c, Description__c, Document_service__c, Document_Type__c, User_Profile__c, CreatedDate 
                                from Intrax_Program_Upload__c where User_Profile__c =: UserPrID and document_type__c = 'Participant-Photo' order by CreatedDate DESC limit 1];
                    
                    
                    if (loadDoc != null && loadDoc.size() > 0){
                    DocumentGuid =  loadDoc[0].Document_Guid__c;
                    
                    
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    
                    req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                    
                    body = 'authToken='+Constants.serviceAuthToken+'&documentGUIDS=';
                    
                    String DocGuid = DocumentGuid;
                    
                    body = body + DocGuid + '&size=medium';
                    //body = body + DocGuid + '&size=thumbnail';
                    
                    
                    system.debug('***** BODY: ' + body);
                    req.setBody(body);

                    Dom.Document docRes = new Dom.Document();

                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        System.debug('RESPONSE'+res.getBody());
                        responseXML = res.getBody();
                     
                        docRes.load(responseXML);
                        System.debug('docRes'+docRes);
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();

                        for (dom.XmlNode node : resnodelist){
                            System.debug('nodeName:'+node.getName());
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                  for (dom.XmlNode childnode : childNodes){
                                    system.debug('***** childNode: ' + childNode);
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        System.debug('@@@@@## returnURL: '+ returnURL);
                                    }
                                  }
                            }
                        }
                     }
                    
                 }//End IF (loadDoc != null && loadDoc.size() > 0)
                 }catch(Exception e){
                    system.debug('****** Impossible to get Manager photo: ' + e);
                 }                        
            
        }
        system.debug('@@@@@## returnURL_END_Method: ' + returnURL);
        return returnURL;
    }
  
    public static map<String, string> getParticipantIPUURL(list<Engagement__c> engList,Boolean getAlbumToo){
        
        string returnURL;
        string applicationId;
        string ProgramTypeStr = '';
        list<String> appIds = new list<String>();
        map<String, String> returnURLmap = new map<String, String>();
        
        map<String, String> mapEngs = new map<String, String>();
        map<String, String> mapPTImage = new map<String, String>();
        
        map<String, String> mapGuidEng = new map<String, String>();
        map<String, String> mapGuidURL = new map<String, String>();
        
        list<String> returnURLList = new list<String>();    
        //system.debug('*****###appinfoId: ' + appInfo);
        if (!getAlbumToo){
	        for(Engagement__c eng : engList){
	            returnURLmap.put(eng.Id,'no-picture');
	        }
        }
    
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            list<Intrax_Program_Upload__c> loadDoc_aws = new list<Intrax_Program_Upload__c>();
            list<Intrax_Program_Upload__c> loadDoc_legacy = new list<Intrax_Program_Upload__c>();
                                   
            if (engList.size() > 0)
            {
                ProgramTypeStr = engList[0].Intrax_Program__c;
            }
              
            try{      
            	String bucketBaseURL = Global_Constants__c.getInstance().AWS_Bucket_URL__c;       
                /*loadDoc_legacy = [SELECT d.Applicant_Info__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
                                FROM Intrax_Program_Upload__c d
                                WHERE d.Engagement__c IN: engList
                                AND d.document_GUID__c like '%photos.intraxinc.com%'
                                AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];  */
                
                if (!getAlbumToo){
	                loadDoc_aws = [SELECT d.Applicant_Info__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
	                                FROM Intrax_Program_Upload__c d
	                                WHERE d.Engagement__c IN: engList
	                                //AND Id NOT IN: loadDoc_legacy
	                                AND Document_Guid__c like '%/Participant-Photo/%'
	                                //AND (d.document_GUID like '%photos.intraxinc.com%')
	                                AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];
                }
                else{    
                	String getPhotosQuery = 'SELECT d.Applicant_Info__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c'+ 
	                               ' FROM Intrax_Program_Upload__c d '+
	                                ' WHERE d.Engagement__c IN: engList'+
	                                //' AND Id NOT IN: loadDoc_legacy'+
	                                //' AND (d.Document_Guid__c like \'%/Participant-Album/%\')'+
	                                ' AND (d.Document_Type__c = \'Participant-Album\') LIMIT :noOfAPPhotos';
	                loadDoc_aws = Database.query(getPhotosQuery); 	
                } 
                
                /*if(loadDoc_legacy.size() > 0){
                    for(Intrax_Program_Upload__c ipu : loadDoc_legacy)
                    returnURLmap.put(ipu.Engagement__c, ipu.Document_GUID__c);
                } */
                if(loadDoc_aws.size() > 0){
                    for(Intrax_Program_Upload__c ipuurl : loadDoc_aws)
                    {
	                    if(ipuurl.Document_GUID__c != NULL)
	                    {
	                    	if (!getAlbumToo){
	                    		returnURLmap.put(ipuurl.Engagement__c, bucketBaseURL+ipuurl.Document_GUID__c.replace('/original/','/thumbnail/'));
	                    	}
	                    	else{
	                    		returnURLmap.put(bucketBaseURL+ipuurl.Document_GUID__c,ipuurl.description__c);
	                    		//returnURLmap.put(ipuurl.Engagement__c, bucketBaseURL+ipuurl.Document_GUID__c);
	                    	}
	                    }
                    
                    }
                }               
            }catch(Exception e){
                system.debug('****** Impossible to get PT image: ' + e);
                //returnURLmap = null;
                return returnURLmap;
             }
        }
        system.debug('****returnURLmap****'+returnURLmap);
        system.debug('*****###ReturnURLmap: ' + returnURLmap.size());
        return returnURLmap;
    }    
    
    public static map<String, string> getParticipantIPUURL(list<Applicant_Info__c> appInfoList){
        list<String> returnedParams = new list<String>();
        //string responseXML;
        string returnURL;
        string applicationId;
        string ProgramTypeStr = '';
        list<String> appIds = new list<String>();
        map<String, String> returnURLmap = new map<String, String>();
        map<String, String> mapEngs = new map<String, String>();
        map<String, String> mapPTImage = new map<String, String>();
        
        list<String> returnURLList = new list<String>();    
        //system.debug('*****###appinfoId: ' + appInfo);
        for(Applicant_Info__c a : appInfoList){
            returnURLmap.put(a.Id,'no-picture');
        }
        
        
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            list<Intrax_Program_Upload__c> loadDoc = new list<Intrax_Program_Upload__c>();
            /*
            list<Applicant_Info__c> appInfoList = [SELECT ID, PhotoId__c, application_stage__c, Intrax_Program__c, Account__c, Account__r.isPersonAccount 
                                                        FROM Applicant_Info__c 
                                                        WHERE Id IN: appList
                                                        ];
            */                        
            if (appInfoList.size() > 0)
            {
                ProgramTypeStr = appInfoList[0].Intrax_Program__c;
            }
            /*
            for(Applicant_Info__c a: appInfoList){
                mapEngs.put(a.Id, a.Engagement__c);
            }           
             */   
            try{    
            	String bucketBaseURL = Global_Constants__c.getInstance().AWS_Bucket_URL__c;        
                loadDoc = [Select d.Applicant_Info__c, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                            where d.Applicant_Info__c IN: appInfoList AND (d.Document_Type__c = 'Media' OR d.Document_Type__c = 'Participant-Photo')];  
                
                if (loadDoc != null || loadDoc.size() > 0){
                    
                    	for(Intrax_Program_Upload__c ipuapp : loadDoc)
                    	{
                    		if(ipuapp.Document_GUID__c != NULL)
                    		{
                    		returnURLmap.put(ipuapp.Engagement__c, bucketBaseURL+ipuapp.Document_GUID__c.replace('/original/','/thumbnail/'));
                    		}
                    	}
                	 
                }
                else{
                    returnURLmap = null;
                }
            }catch(Exception e){
                system.debug('****** Impossible to get PT image: ' + e);
                //returnURLmap = null;
                return returnURLmap;
             }
        }
        system.debug('*****###ReturnURLmap: ' + returnURLmap.size());
        return returnURLmap;
    }
}