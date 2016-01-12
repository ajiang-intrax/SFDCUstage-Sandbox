public without sharing class IUtilities {
    
    //Used to return the ULM Admin Email address. - SFDCNotify@intraxinc.com/SFDCNotify-test@intraxinc.com
    public static string ULMEmail(){
        list<User> lstUserULMAdmin = new list<User>();
        lstUserULMAdmin = [Select email from User where Username  = :Constants.SYS_ADMIN limit 1];
        return lstUserULMAdmin[0].email;
    }
    
    //Sets State to null if incoming value is greater than 2-characters, and puts incoming value
    //into the Description field so it can be seen by a human and possibly fixed.
    public static boolean isTest=false;
    static final Set<String> USA_Reg = new Set<String>{'American Samoa', 'Anguilla','Antarctica','Antigua and Barbuda','Aruba',
        'Barbados','Bhutan','Bonaire, Saint Eustatius And Saba','Cayman Islands','Curacao','Fiji','Greenland',
        'Grenada','Guadeloupe','Guam','Heard Island and McDonald Islands','Jersey','Kiribati','Kyrgyzstan',
        'Malawi','Maldives','Marshall Islands','Martinique','Mayotte','Montserrat',
        'Nauru','Niue','Norfolk Island','Northern Mariana Islands','Palau','Saint Kitts and Nevis',
        'Saint Lucia','Samoa','Seychelles','Suriname','Timor-Leste','Tokelau','Tuvalu','United States Minor Outlying Islands',
        'Vanuatu','Virgin Islands, U.S.','Wallis and Futuna','Afghanistan','Argentina','Australia','Bahamas','Bolivia',
        'Brazil','China','Colombia','Costa Rica','Cuba','Dominica','Dominican Republic','Ecuador','El Salvador',
        'Haiti','Guatemala','Hong Kong','Honduras','Jamaica','Macao','Guyana',
        'Micronesia, Federated States of','Mexico','Nepal','New Caledonia','New Zealand','Nicaragua','Pakistan',
        'Panama','Papua New Guinea','Paraguay','Puerto Rico','Solomon Islands',
        'Sri Lanka','Taiwan, Province of China','Tajikistan','Trinidad and Tobago', 'Turkmenistan',
        'United States','Uruguay','Venezuela, Bolivarian Republic of','French Guiana','French Polynesia','Belize','Bangladesh',
        'Aland Islands', 'Albania','Algeria','Angola','Armenia','Azerbaijan', 'Bahrain','Belarus','Benin','Bermuda','Bosnia And Herzegovina','Botswana',
        'Bouvet Island','British Indian Ocean Territory','Burkina Faso','Burundi','Cameroon','Cape Verde',
        'Central African Republic','Chad','Christmas Island','Cocos (Keeling) Islands','Comoros','Congo',
        'Congo, The Democratic Republic of the','Cook Islands','Cote D\'Ivoire','Croatia',
        'Djibouti','Egypt','Equatorial Guinea','Eritrea','Ethiopia','Falkland Islands (Malvinas)',
        'Faroe Islands','French Southern Territories','Gabon','Gambia','Georgia','Ghana', 
        'Gibraltar','Greece','Guernsey','Guinea','Guinea-Bissau','Holy See (Vatican City State)','Iceland',
        'Iran, Islamic Republic of','Iraq','Isle of Man','Israel','Jordan','Kazakhstan','Kenya',
        'Kuwait','Lebanon','Lesotho','Liberia','Libyan Arab Jamahiriya',
        'Macedonia, The Former Yugoslav Republic of','Madagascar','Mali','Mauritania','Mauritius',
        'Moldova, Republic of','Monaco','Mongolia','Montenegro','Morocco','Mozambique','Namibia', 'Niger','Nigeria','Oman',
        'Palestinian Territory, Occupied','Pitcairn','Qatar','Reunion','Romania','Russian Federation',
        'Rwanda','Saint Barthelemy','Saint Helena, Assension and Tristan da Cunha','Saint Martin (French Part)',
        'Saint Pierre and Miquelon','Saint Vincent and the Grenadines','San Marino','Sao Tome and Principe',
        'Saudi Arabia', 'Senegal','Serbia','Sierra Leone','Sint Maarten (Dutch Part)',
        'Somalia','South Africa','South Georgia and the South Sandwich Islands',
        'Sudan','Svalbard and Jan Mayen','Swaziland','Syrian Arab Republic',
        'Tanzania, United Republic of','Togo','Tonga','Tunisia','Turkey','Turks and Caicos Islands','Uganda','Ukraine',
        'United Arab Emirates','Uzbekistan','Vatican City State','Western Sahara','Yemen','Zambia','Zimbabwe'
        };
    
     static final Set<String> Europe_Reg = new Set<String>{ 'Andorra', 'Bulgaria', 'Cyprus', 'Czech Republic', 'Denmark', 'Estonia',
       'Finland', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta','Norway', 'Poland', 
       'Portugal', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'United Kingdom', 'Virgin Islands, British', 'Germany', 'Austria', 'Switzerland',
       'France','Belgium', 'Netherlands' };
     
     static final Set<String> Singapore_Reg = new Set<String>{'Brunei Darussalam', 'Cambodia', 'Indonesia', 'Lao People\'s Democratic Republic', 'Malaysia',
       'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Viet Nam', 'India'};
       
    static testMethod void test_create_hc_validation_assessment(){
        Opportunity o = new Opportunity(Name = 'Opp Test Validation', Type = 'Host Company', Intrax_Programs__c = 'Work Travel', StageName = 'Processing', closeDate = date.today() + 10);
        insert o;
        
        Opportunity o_check = [SELECT Id FROM Opportunity WHERE Name = 'Opp Test Validation' AND Type = 'Host Company' AND Intrax_Programs__c ='Work Travel']; 
        
        list<Assessment__c> a = [SELECT Id FROM Assessment__c WHERE Opportunity__c =: o_check.Id];
        system.assertEquals(a.size(), 1 );
    }
    
    public static void create_hc_validation_assessment(list<Opportunity> oppList){
        list<Assessment__c> assList = new list<Assessment__c>();
        
        for (Opportunity o : oppList){
            if(IUtilities.isIncluded(o.Intrax_Programs__c, 'Work Travel') && o.Type == 'Host Company'){
                Assessment__c a = new Assessment__c(RecordTypeId = Constants.ASS_WT_HC_Validation, Name = o.Name + ' - HCV', Status__c = 'Not Yet Started', Opportunity__c = o.Id);
                assList.add(a); 
            }
        }
        
        try{
            insert assList;
        }catch(Exception e){
            system.debug('***** Impossible to create related assessment: ' + e);
        }
    }
    
    static testMethod void Test_AcceptedPhotoCount(){
        //Position
        User sysAdmin = [select Id from user where userName = :Constants.SYS_ADMIN];
        system.runAs(sysAdmin){
            Account account  = new Account(Name = 'Host Company', Type = 'Host Company', Agreement_Expires__c = (date.today() - 45),
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                        OwnerId = sysAdmin.Id);
            insert account;
        
            Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                    Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id );
             
            insert position;
                                                    
            Intrax_Program_Upload__c ipu = new Intrax_Program_Upload__c(Name= 'Bathroom', Document_Type__c = 'Bathroom', Review_Status__c = 'Accepted', Position__c = position.Id);
            insert ipu;
            list<Intrax_Program_Upload__c> ipuList  = new list<Intrax_Program_Upload__c>();
            ipuList.add(ipu);
            getAcceptedPhotoCount(ipuList);
            decreaseAcceptedPhotoCount(ipuList);
        }
    }
    public static void decreaseAcceptedPhotoCount(list<Intrax_Program_Upload__c> ipu){
        system.debug('******* IPU Id: ' + ipu[0].Id + ' // ' + ipu[0].Position__c);
        
        Intrax_Program_Upload__c i = [SELECT Id, Position__c, Position__r.Intrax_Program__c, Document_Type__c, Review_Status__c FROM Intrax_Program_Upload__c WHERE Id =: ipu[0].Id LIMIT 1];
        if(i.Position__c != null){
            Position__c p = [SELECT Id, Approved_Photo_Count__c FROM Position__c WHERE Id =: i.Position__c];
            if(p.Approved_Photo_Count__c > 0) p.Approved_Photo_Count__c -=1;
            try{
                update p;   
            }catch(Exception e){
                system.debug('***** Impossible to decrease Accepted Photo Count: ' + e);
            }
            
        }
    }
    
    public static void getAcceptedPhotoCount(list<Intrax_Program_Upload__c> ipu){
        system.debug('******* IPU Id: ' + ipu[0].Id + ' // ' + ipu[0].Position__c);
        Intrax_Program_Upload__c i = [SELECT Id, Position__c, Position__r.Intrax_Program__c, Document_Type__c, Review_Status__c FROM Intrax_Program_Upload__c WHERE Id =: ipu[0].Id LIMIT 1];
        try{        
            list<Intrax_Program_Upload__c> acceptedDocs = [SELECT Id, Review_Status__c, Position__c, Document_Type__c FROM Intrax_Program_Upload__c 
                                                                WHERE Review_Status__c = 'Accepted'
                                                                AND Position__c =: i.Position__c 
                                                                AND Document_Type__c IN ('Bathroom', 'Exterior-Of-Home', 'Family-Photo', 'Kitchen', 'Living-Room', 'Student-Bedroom')];
            
            if(acceptedDocs.size() > 0){
                Position__c p = [SELECT Id, Approved_Photo_Count__c FROM Position__c WHERE Id =: i.Position__c];
                p.Approved_Photo_Count__c = acceptedDocs.size();
                update p;
            }
        }catch(Exception e){
            system.debug('****** Impossible to upate Accepted Photo Count: ' + e);
        }   
        
    }
    
    static testMethod void Test_getParticipantPhoto(){
        
        Applicant_Info__c app = new Applicant_Info__c (Name = 'App Info Test', Type__c = 'Participant');
        insert app;
        Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = app.Id,Document_Guid__c = 'Test', Document_service__c  = 'DS', Document_Type__c='Participant-Photo');
        insert ipUpload;
        IUtilities.isTest = true;
        string strULMEmail= IUtilities.ULMEmail();   
        getParticipantPhoto(app);
        getParticipantFamilyPhotos(app);
    }
    
    
        public static String getParticipantPhoto(Applicant_Info__c appInfo){
        
        system.debug('@@@@@ Inside getParticipantPhoto');
        list<String> returnedParams = new list<String>();
        string responseXML;
        string returnURL = '';      
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            List<Intrax_Program_Upload__c> loadDoc = new List<Intrax_Program_Upload__c>();
            
            if(appInfo.Intrax_Program__c =='Ayusa'){
                loadDoc = [Select Document_Guid__c,Document_service__c, Document_Type__c, Applicant_Info__c from Intrax_Program_Upload__c where Applicant_Info__c = :appInfo.Id and document_type__c = 'Media' limit 1];
            }else if(appInfo.Intrax_Program__c == 'Internship' || appInfo.Intrax_Program__c == 'Work Travel' || appInfo.Intrax_Program__c ==  'AuPairCare'){
                system.debug('@@@@@ Inside getParticipantPhoto Query');
                loadDoc = [Select Document_Guid__c,Document_service__c, Document_Type__c, Applicant_Info__c from Intrax_Program_Upload__c where Applicant_Info__c = :appInfo.Id and document_type__c = 'Participant-Photo' limit 1];
            }
            
            system.debug('@@@@@ appInfo: '  + appInfo);
            system.debug('@@@@@ loadDoc: '  + loadDoc);
            
            if (loadDoc.size() > 0){
                
                try{
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    if (loadDoc[0].Document_service__c == 'DS'){
                        req.setEndpoint(Constants.documentService+'GetFile');
                    }
                    else{
                        req.setEndpoint(Constants.imageService+'GetImages');
                    }

                     //body = 'authToken='+Constants.serviceAuthToken+'&programId=ayusa-pt&applicationId='+appInfo.Id+'&documentTypes=Family&sizes=medium';  
                     if(appInfo.Intrax_Program__c == 'Ayusa') 
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationId='+appInfo.Id+'&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('ProfilePhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');
                     else if(appInfo.Intrax_Program__c == 'Internship')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+'igi-pt'+'&applicationId='+appInfo.Id+'&documentTypes=' +'Participant-Photo'+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');
                     else if(appInfo.Intrax_Program__c == 'Work Travel')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+'wt-pt'+'&applicationId='+appInfo.Id+'&documentTypes='+'Participant-Photo'+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');
                     else if(appInfo.Intrax_Program__c == 'AuPairCare' && appInfo.Type__c == 'Participant')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+'apc-pt'+'&applicationId='+appInfo.Id+'&documentTypes='+'Participant-Photo'+'&sizes=thumbnail';/*+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');*/
                     else if(appInfo.Intrax_Program__c == 'AuPairCare' && appInfo.Type__c == 'Host Family')
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+'apc-hf'+'&applicationId='+appInfo.Id+'&documentTypes='+'Participant-Photo'+'&sizes=thumbnail';/*+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');*/
                     
                     
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
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        System.debug('returnURL'+returnURL);
                                    }
                                }
                            }
                        }
                     }
                 }catch(Exception e){
                    system.debug('****** Impossible to get PT image: ' + e);
                 }                        
            }
            else{
                returnURL = '';
            }
        }
        system.debug('****** ReturnURL: ' + returnURL);
        return returnURL;
    }
    
    
    public static Map<String, Intrax_Program_Upload__c > getPtThumbnailPhotosAlbum(Applicant_Info__c appInfo){
        
        system.debug('@@@@@ Inside getPtThumbnailPhotosAlbum');
        list<String> returnedParams = new list<String>();
        string responseXML;
        string returnURL = '';      
        //Map<String ReturnURL, Intrax_Program_Upload__c>
        Map<String,Intrax_Program_Upload__c> MapPhotoAlbum = new Map<String, Intrax_Program_Upload__c>();
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            
            /*
            List<Intrax_Program_Upload__c> loadDoc = new List<Intrax_Program_Upload__c>();
            loadDoc = [Select Id, Document_Guid__c, Description__c, Document_service__c, Document_Type__c, Applicant_Info__c 
                                from Intrax_Program_Upload__c where Applicant_Info__c = :appInfo.Id and document_type__c = 'Participant-Album'];
            system.debug('@@@@@## loadDoc: ' + loadDoc);
            */
            list<Intrax_Program_Upload__c> loadDoc_aws = new list<Intrax_Program_Upload__c>();
            list<Intrax_Program_Upload__c> loadDoc_legacy = new list<Intrax_Program_Upload__c>();
            
           
            
            loadDoc_legacy = [SELECT d.Applicant_Info__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
                                FROM Intrax_Program_Upload__c d
                                WHERE d.Applicant_Info__c =: appInfo.Id
                                AND d.document_GUID__c like '%photos.intraxinc.com%'
                                AND d.Document_Type__c = 'Participant-Album'];  
                
            loadDoc_aws = [SELECT d.Applicant_Info__c, d.Engagement__c,d.Engagement__r.id, d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c 
                                FROM Intrax_Program_Upload__c d
                                WHERE d.Applicant_Info__c =: appInfo.Id
                                AND Id NOT IN: loadDoc_legacy
                                AND Document_Guid__c like '%/Participant-Album/%'
                                AND d.Document_Type__c = 'Participant-Album']; 
                 
            if(loadDoc_legacy.size() > 0){
                for(Intrax_Program_Upload__c ipu : loadDoc_legacy)
                MapPhotoAlbum.put(ipu.Document_GUID__c, ipu);
            } 
            
            if (loadDoc_aws != null && loadDoc_aws.size() > 0){
                for(Intrax_Program_Upload__c ld : loadDoc_aws){
                try{
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    
                    if (ld.Document_service__c == 'IS'){
                        req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                    }
                    else if (ld.Document_service__c == 'DS'){
                        req.setEndpoint(Constants.documentService+'GetFile');
                    }
                    else if(ld.Document_service__c == 'VS'){
                        req.setEndpoint(Constants.videoService+'GetVideoSignedUrl');
                    }
                    else{
                        system.debug('debug::Inside ImageService='+ld.Document_service__c);
                       req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                    }
                    
                    body = 'authToken='+Constants.serviceAuthToken+'&documentGUIDS=';
                    
                    String DocGuid = ld.Document_Guid__c;
                    
                     if(ld.Document_service__c=='VS'){
                     body = body + ld.Document_Guid__c +'&protocol=rtmp';
                     }
                     else if(ld.Document_service__c == 'DS'){
                     body = body + ld.Document_Guid__c;
                     }else{
                     //body = body + DocGuid + '&size=original';
                     //body = body + DocGuid + '&size=medium';
                     body = body + DocGuid + '&size=thumbnail';
                     
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
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                  for (dom.XmlNode childnode : childNodes){
                                    system.debug('***** childNode: ' + childNode);
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        //Map<String Document_Guid__c, String ReturnURL >
                                        MapPhotoAlbum.put(returnURL, ld);
                                        System.debug('@@@@@## returnURL: '+ returnURL);
                                        System.debug('@@@@@## ld: '+ ld);
                                    }
                                  }
                               
                            }
                            if (ld.Document_service__c == 'VS' && node.getName() == 'signedUrl'){
                                returnurl = node.getText();
                                MapPhotoAlbum.put(returnURL, ld);
                                /*spillai video changes
                                rtmpUrlVideo = returnurl;
                                PageReference videoPage = Page.playVideo;
                                //return videoPage ;
                                return null;*/
                            }
                        }
                     }
                 }catch(Exception e){
                    system.debug('****** Impossible to get PT image: ' + e);
                 }                        
            }//en for loadDoc
        }
            else{
                //MapPhotoAlbum = null;
            }
            
        }
        system.debug('@@@@@## MapPhotoAlbum: ' + MapPhotoAlbum);
        return MapPhotoAlbum;
    }
    
    public static String getPtMediumPhotoAlbum(String DocumentGuid){
        
        system.debug('@@@@@ Inside getPtMediumPhotoAlbum');
        
        string responseXML;
        string returnURL = '';      
        
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            
            
                try{
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    
                    req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                    
                    body = 'authToken='+Constants.serviceAuthToken+'&documentGUIDS=';
                    
                    String DocGuid = DocumentGuid;
                    
                    body = body + DocGuid + '&size=medium';
                    
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
                 }catch(Exception e){
                    system.debug('****** Impossible to get PT image: ' + e);
                 }                        
            
        }
        system.debug('@@@@@## returnURL_END_Method: ' + returnURL);
        return returnURL;
    }
    
     public static Map<String ,Map<String, Intrax_Program_Upload__c >> getVideosParticipant(Applicant_Info__c appInfo){
        
        system.debug('@@@@@ Inside getVideosParticipan');
        list<String> returnedParams = new list<String>();
        string responseXML;
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
            where Applicant_Info__c = :appInfo.Id and document_type__c = 'Introductory-Video'  and AWS_ET_Preset__c = 'Generic 720p'];
            
            system.debug('@@@@@## loadDoc: ' + loadDoc);
            
            
            if (loadDoc != null && loadDoc.size() > 0){
                for(Intrax_Program_Upload__c ld:loadDoc){
                try{
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
                 }catch(Exception e){
                    system.debug('****** Impossible to get PT image: ' + e);
                 }                        
            }//en for loadDoc
        }
            
            
        }
        system.debug('@@@@@## MapPhotoAlbum: ' + MapVideoThumb);
        return MapVideoThumb;
    }
    
    static testMethod void Test_getParticipantPhotoList(){
        
        Engagement__c eng = new Engagement__c(Name='Test Eng', Status__c = 'Processing');
        insert eng;
        list<Engagement__c> engList = new list<Engagement__c>();
        engList.add(eng);
        Applicant_Info__c app = new Applicant_Info__c (Name = 'App Info Test', Type__c = 'Participant', Engagement__c = eng.Id);
        insert app;
        Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Applicant_Info__c = app.Id,Document_Guid__c = 'Test', Document_service__c  = 'IS', Document_Type__c='Media');
        insert ipUpload;
        
        map<String, Applicant_Info__c> mapAppToEng = new map<String, Applicant_Info__c>();
        mapAppToEng.put(eng.Id, app);
        
        IUtilities.isTest = true;
        getParticipantPhotoList(engList, mapAppToEng);
    }
    
    public static map<String, string> getParticipantPhotoList(list<Engagement__c> engList, map<String, Applicant_Info__c> mapAppToEng){
        list<String> returnedParams = new list<String>();
        string responseXML;
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
                                    AND application_stage__c =: 'Accepted'];
                                    
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
                     else
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT;
                     
                     for(Engagement__c e : engList){
                        //returnURLmap.put(e.Id,'no-picture');
                        body += '&applicationIds=' + mapAppToEng.get(e.Id).Id;
                     }
                     if (ProgramTypeStr == 'Work Travel')
                        body += '&documentTypes='+'Participant-Photo'+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('ProfilePhotoSize');
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
        
    public static list<String> getParticipantFamilyPhotos(sObject incomingObject){
    
    Schema.sObjectType incomingObjectType = incomingObject.getSObjectType();    
    Schema.DescribeSObjectResult incomingObjectTypeDescribe = incomingObjectType.getDescribe();
    
    Applicant_Info__c appInfo;
    Position__c posInfo;
    
    if (incomingObjectTypeDescribe.getName() == 'Applicant_Info__c'){
        appInfo = (Applicant_Info__c)incomingObject;
    }
    else{
        posInfo = (Position__c)incomingObject;
    }
    
        list<String> returnedParams = new list<String>();
        string responseXML;
        string returnURL;
        list<String> returnURLList = new list<String>();    
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            Intrax_Program_Upload__c loadDoc = new Intrax_Program_Upload__c ();
            
            try{
                
                if (incomingObjectTypeDescribe.getName() == 'Applicant_Info__c'){
                    loadDoc = [Select d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                        where d.Applicant_Info__c =: appInfo.Id AND Document_Type__c = 'Family' order by d.Document_Type__c desc limit 1 ];
                }
                else{
                    loadDoc = [Select d.document_name__c, d.Document_Service__c, d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
                        where d.Position__c =: posInfo.Id limit 1 ];
                }  
            
            
                if (loadDoc != null){
                
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                        req.setEndpoint(Constants.imageService+'GetImages2');
                    List<Id> appInfoIds = new List<Id>();
                    //appInfoIds.add('a11e0000000Aja5AAC');
                    //appInfoIds.add('a0Ue0000001twtaEAA');
                    //appInfoIds.add('a11e0000000B1bTAAS');
                    if (incomingObjectTypeDescribe.getName() == 'Applicant_Info__c'){
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationIds='+appInfo.Id+'&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('FamilyPhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                    }else{
                        String docTypes = '';
                        
                        for (String docType : Constants.PartnerPortalPTMatchPosPhotosDocTypes.get('PPPTMatchPosDocTypes')){
                            docTypes = docTypes+'&documentTypes=' + docType;
                        }
                        
                        body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypePPPTMatchPos+'&applicationIds='+posInfo.Id+docTypes+'&sizes='+Constants.PartnerPortalPTMatchPosPhotosDocSizes.get('PPPTMatchPosDocSize');
                    }
                     //body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationIds='+appInfoIds+'&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('FamilyPhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
                     //body = 'authToken='+Constants.serviceAuthToken+'&programId='+Constants.awsProgramTypeAyusaPT+'&applicationIds=a0Ue0000001twtaEAA&applicationIds=a0Ue0000000hb0yEAA&documentTypes='+Constants.HFPortalPtPhotosDocTypes.get('FamilyPhotoDocType')+'&sizes='+Constants.HFPortalPtPhotosDocSizes.get('FamilyPhotoSize');
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
                            if(node.getName() == 'applicationId'){
                                list<dom.XmlNode> childNodesApplication = node.getChildElements();
                                for (dom.XmlNode childnode : childNodesApplication){
                                    if ( childnode.getName() == 'applicationId'){
                                        //returnURL = childnode.getText();
                                        //returnURLList.add(returnURL);
                                        System.debug('Application Id CHILD NODE VALUE: ' + childnode.getText());
                                    }
                                }
                            }
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
    
    //Jose -method to retrieve Thumbnail photo
    
    public static list<String> getPhotoListThumb(list<String> incomingGUIDs){    
    
        String responseXML;
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
                        if(documentGUID.contains('photos.intraxinc.com')){
                            returnURLList.add(documentGUID);    
                        }else{
                            documentGUIDS = documentGUIDS+'&documentGUIDS=' + documentGUID;
                        }
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
    
    //B-01192
    public static list<String> getParticipantFamilyPhotosFromGUID(list<String> incomingGUIDs){    
    
        list<String> returnedParams = new list<String>();
        string responseXML;
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
        system.debug('*****###ReturnURLList: ' + returnURLList.size());
        return returnURLList;
    }
    
    /*public static void AppToRelatedObjectSync (Applicant_Info__c applicantInfo, Person_Info__c personInfo){
        if(personInfo.Email__c!=null)
        {
            List<Account> existingAcc = [select id, Last_Interest_Date__pc from Account where IsPersonAccount = true and PersonEmail!= null and PersonEmail =: personInfo.Email__c order by CreatedDate DESC];
            List<Lead> existingLead = [select id, Last_Interest_Date__c from Lead where Email =: personInfo.Email__c and IsConverted = false order by CreatedDate DESC];
           
            // Commented out after MAINT 86 discussion
            //if (existingAcc.size() > 0 && applicantInfo.Intrax_Program__c != 'Ayusa' && applicantInfo.Type__c != 'Host Family') {
            if (existingAcc.size() > 0) {
                applicantInfo.Account__c = existingAcc[0].ID;
                existingAcc[0].FirstName = personInfo.First_Name__c;
                existingAcc[0].LastName = personInfo.Last_Name__c;
                existingAcc[0].Gender__pc = personInfo.Gender__c;
                existingAcc[0].personBirthDate = personInfo.Date_of_Birth__c;
                existingAcc[0].PersonEmail = personInfo.Email__c;
                existingAcc[0].PersonMobilePhone = String.isBlank(applicantInfo.Home_Phone__c) ? '' : personInfo.Phone__c;
                existingAcc[0].Skype_Id__pc = personInfo.Skype_Id__c;
                existingAcc[0].Best_Call_Time__pc = personInfo.Best_Call_Time__c;
                existingAcc[0].Intrax_Programs__c = applicantInfo.Intrax_Program__c;
                existingAcc[0].Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                existingAcc[0].Type = applicantInfo.Type__c;
                existingAcc[0].Intrax_Region__c = applicantInfo.Intrax_Region__c;
                existingAcc[0].PersonMailingStreet = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
                existingAcc[0].PersonMailingCity = applicantInfo.Home_City__c;
                existingAcc[0].PersonMailingState = applicantInfo.Home_State__c;
                existingAcc[0].PersonMailingCountry = applicantInfo.Home_Country__c;
                existingAcc[0].PersonMailingPostalCode = applicantInfo.Home_Postal_Code__c;
                existingAcc[0].Phone = applicantInfo.Home_Phone__c;
                if((existingAcc[0].Last_Interest_Date__pc == NULL || !datetime.now().isSameDay(existingAcc[0].Last_Interest_Date__pc) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.createdBy__c == applicantInfo.LastModifiedById )){
                  existingAcc[0].Last_Interest_Date__pc = dateTime.now();
                }
                update existingAcc[0];
            }
            else if (existingLead.size() > 0) {
                if (applicantInfo.Intrax_Program__c != 'Ayusa' && applicantInfo.Type__c != 'Host Family'){
                    applicantInfo.Lead__c = existingLead[0].ID;

                    if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.createdBy__c == applicantInfo.LastModifiedById )){
                        existingLead[0].Last_Interest_Date__c = DateTime.now(); 
                    }
                    update existingLead[0]; 
                }
                else{
                  applicantInfo.Lead__c = existingLead[0].ID;
                  IUtilities.AppToLeadSync(applicantInfo, personInfo, existingLead[0], 'insert'); 
                    existingLead[0].FirstName = personInfo.First_Name__c;
              existingLead[0].LastName = personInfo.Last_Name__c;
              existingLead[0].Gender__c = personInfo.Gender__c;
              existingLead[0].Email = personInfo.Email__c;
              existingLead[0].Date_of_Birth__c = personInfo.Date_of_Birth__c;
              existingLead[0].MobilePhone = personInfo.Mobile__c;
              existingLead[0].Citizenship__c = applicantInfo.Citizenship__c;
              existingLead[0].Skype_ID__c = personInfo.Skype_Id__c;
              existingLead[0].Best_Call_Time__c = applicantInfo.Best_Call_Time__c;
               
              //existingLead[0].Intrax_Programs__c = 'Ayusa';
              existingLead[0].Intrax_Programs__c = applicantInfo.Intrax_Program__c;
              existingLead[0].Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
              existingLead[0].Intrax_Region__c = applicantInfo.Intrax_Region__c;
              //existingLead[0].Intrax_Region__c = 'United States';
              existingLead[0].Countries_of_Interest__c = applicantInfo.Country_of_Interest__c;
              existingLead[0].Location_of_Interest__c = applicantInfo.Location_of_Interest__c;
              existingLead[0].Projects_of_Interest__c = applicantInfo.Projects_of_Interest__c;
              existingLead[0].Functional_Areas__c = applicantInfo.Functional_Areas__c;
              existingLead[0].Intrax_Center__c = applicantInfo.Intrax_Center__c;
              existingLead[0].Service_Level__c = applicantInfo.Service_Level__c;
              existingLead[0].Program_Start__c = applicantInfo.Program_Start__c;
              existingLead[0].Program_Duration__c = applicantInfo.Program_Duration__c;
              existingLead[0].Program_Year__c = applicantInfo.Program_Year__c;
              existingLead[0].Desired_Start_Date__c = applicantInfo.Engagement_Start__c;
              existingLead[0].Lead_Type__c = applicantInfo.Type__c;
              existingLead[0].LeadSource = 'Portal';
              existingLead[0].Lead_Source_Tag__c = 'Application';
              existingLead[0].How_Heard__c = applicantInfo.How_Heard__c;
              existingLead[0].RB_First_Name__c = applicantInfo.RB_First_Name__c;
              existingLead[0].RB_Last_Name__c = applicantInfo.RB_Last_Name__c;
              existingLead[0].Phone = applicantInfo.Home_Phone__c;
              existingLead[0].Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
              existingLead[0].City = applicantInfo.Home_City__c;
              existingLead[0].State = applicantInfo.Home_State__c;
              existingLead[0].PostalCode = applicantInfo.Home_Postal_Code__c;
              existingLead[0].Country = applicantInfo.Home_Country__c;
              existingLead[0].Title = applicantInfo.Title__c;
              existingLead[0].Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c; 
                    // Update only if nto changed in last 24 hours
                    if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.createdBy__c == applicantInfo.LastModifiedById )){
                        existingLead[0].Last_Interest_Date__c = DateTime.now(); 
                    }
                    try{
                      update existingLead[0];    
                    }catch(Exception e){
                      system.debug('***** Impossible to update related Lead: '+ e);
                    }  
                           
                }
                
            } 
            else {
                Lead newLead = new Lead();            
                newLead.FirstName = personInfo.First_Name__c;
            newLead.LastName = personInfo.Last_Name__c;
            newLead.Gender__c = personInfo.Gender__c;
            newLead.Email = personInfo.Email__c;
            newLead.Date_of_Birth__c = personInfo.Date_of_Birth__c;
            newLead.MobilePhone = personInfo.Mobile__c;
            newLead.Citizenship__c = applicantInfo.Citizenship__c;
            newLead.Skype_ID__c = personInfo.Skype_Id__c;
            newLead.Best_Call_Time__c = applicantInfo.Best_Call_Time__c;
             
            //newLead.Intrax_Programs__c = 'Ayusa';
            newLead.Intrax_Programs__c = applicantInfo.Intrax_Program__c;
            newLead.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
            newLead.Intrax_Region__c = applicantInfo.Intrax_Region__c;
            //leadInfo.Intrax_Region__c = 'United States';
            newLead.Countries_of_Interest__c = applicantInfo.Country_of_Interest__c;
            newLead.Location_of_Interest__c = applicantInfo.Location_of_Interest__c;
            newLead.Projects_of_Interest__c = applicantInfo.Projects_of_Interest__c;
            newLead.Functional_Areas__c = applicantInfo.Functional_Areas__c;
            newLead.Intrax_Center__c = applicantInfo.Intrax_Center__c;
            newLead.Service_Level__c = applicantInfo.Service_Level__c;
            newLead.Program_Start__c = applicantInfo.Program_Start__c;
            newLead.Program_Duration__c = applicantInfo.Program_Duration__c;
            newLead.Program_Year__c = applicantInfo.Program_Year__c;
            newLead.Desired_Start_Date__c = applicantInfo.Engagement_Start__c;
            newLead.Lead_Type__c = applicantInfo.Type__c;
            newLead.LeadSource = 'Portal';
            newLead.Lead_Source_Tag__c = 'Application';
            newLead.How_Heard__c = applicantInfo.How_Heard__c;
            newLead.RB_First_Name__c = applicantInfo.RB_First_Name__c;
            newLead.RB_Last_Name__c = applicantInfo.RB_Last_Name__c;
            newLead.Phone = applicantInfo.Home_Phone__c;
            newLead.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
            newLead.City = applicantInfo.Home_City__c;
            newLead.State = applicantInfo.Home_State__c;
            newLead.PostalCode = applicantInfo.Home_Postal_Code__c;
            newLead.Country = applicantInfo.Home_Country__c;
            newLead.Title = applicantInfo.Title__c;
            newLead.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;   
  
                // to turn the Assignment Rules on
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule = true;
                newLead.setOptions(dmo);
                try{
                  insert newLead;
                }catch(Exception e){
                  system.debug('****** Impossible to create new Lead for the HF App: '+ e);
                }
                applicantInfo.Lead__c = newLead.id;
            }
            
            //Lead and Account sorted out, now, check for Opportunity
            if(applicantInfo.Account__c != NULL){
                List<Opportunity> associatedOpportunity = [select Id,Name,StageName from Opportunity 
                                      where isClosed != true and Type = :applicantInfo.Type__c and Intrax_Programs__c = :applicantInfo.Intrax_Program__c 
                                      and AccountId = :applicantInfo.Account__c order by lastModifiedDate desc];
                if (associatedOpportunity.size() > 0 ){
                  system.debug('Opportunity present');
                  applicantInfo.Opportunity_Name__c = associatedOpportunity[0].Id;
                    
                    associatedOpportunity[0].StageName = 'Processing';
                    associatedOpportunity[0].Intrax_Programs__c = applicantInfo.Intrax_Program__c;
                    associatedOpportunity[0].Name = applicantInfo.Name;
                    associatedOpportunity[0].CloseDate = date.today();
                    associatedOpportunity[0].Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                    associatedOpportunity[0].Type = applicantInfo.Type__c;
                    associatedOpportunity[0].Intrax_Region__c = applicantInfo.Intrax_Region__c;
                    associatedOpportunity[0].Countries_of_Interest__c = applicantInfo.Country_of_Interest__c;
                    associatedOpportunity[0].Location_of_Interest__c = applicantInfo.Location_of_Interest__c;
                    associatedOpportunity[0].Projects_of_Interest__c = applicantInfo.Projects_of_Interest__c;
                    associatedOpportunity[0].Functional_Areas__c = applicantInfo.Functional_Areas__c;
                    associatedOpportunity[0].Position_Types__c = applicantInfo.Position_Types__c;
                    associatedOpportunity[0].Intrax_Center__c = applicantInfo.Intrax_Center__c;
                    associatedOpportunity[0].Service_Level__c = applicantInfo.Service_Level__c;
                    associatedOpportunity[0].Program_Start__c = applicantInfo.Program_Start__c;
                    associatedOpportunity[0].Program_Duration__c = applicantInfo.Program_Duration__c;
                    associatedOpportunity[0].Program_Year__c = applicantInfo.Program_Year__c;
                    associatedOpportunity[0].Engagement_Start__c = applicantInfo.Engagement_Start__c;
                    associatedOpportunity[0].Engagement_End__c = applicantInfo.Engagement_End__c;
                    associatedOpportunity[0].How_Heard__c = applicantInfo.How_Heard__c;
                    associatedOpportunity[0].RB_First_Name__c = applicantInfo.RB_First_Name__c;
                    associatedOpportunity[0].RB_Last_Name__c = applicantInfo.RB_Last_Name__c;
                    associatedOpportunity[0].Reason__c = applicantInfo.Reason__c;
                    associatedOpportunity[0].Reason_Detail__c = applicantInfo.Reason_Detail__c;
                    associatedOpportunity[0].StageName = 'Processing';
                    associatedOpportunity[0].AccountId = applicantInfo.Account__c;
                    
                    update associatedOpportunity[0];
                   
                    
                }                     
                else{
                    system.debug('Opportunity not present');
                    //Get the owner of the Account and check if active
                    List<Account> ownerId = [select ownerId from Account where id = :applicantInfo.Account__c];
                    List<User> activeOwner = [select Id from User where Id = :ownerId[0].ownerId and isActive = true];
                    Opportunity newOpp = new Opportunity();
                    
                    
                    if (activeOwner.size()== 0){
                        //Get the default owner from Queue
                        List<OpportunityOwners__c> ownerMap = OpportunityOwners__c.getAll().values();
                        
                        //If owner is Queue, reassign
                        for (OpportunityOwners__c owner : ownerMap){
                            if (owner.QueueName__c == 'Default'){
                                List<User> theNewOwner = [select Id from User where userName = :owner.OwnerForLeadConvert__c];
                                newOpp.OwnerId = theNewOwner[0].Id;
                            }
                        }
                    }
                    else{
                        newOpp.OwnerId = ownerId[0].ownerId;
                    }
                    
                    newOpp.Intrax_Programs__c = applicantInfo.Intrax_Program__c;
                    newOpp.Name = applicantInfo.Name;
                    newOpp.CloseDate = date.today();
                    newOpp.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                    newOpp.Type = applicantInfo.Type__c;
                    newOpp.Intrax_Region__c = applicantInfo.Intrax_Region__c;
                    newOpp.Countries_of_Interest__c = applicantInfo.Country_of_Interest__c;
                    newOpp.Location_of_Interest__c = applicantInfo.Location_of_Interest__c;
                    newOpp.Projects_of_Interest__c = applicantInfo.Projects_of_Interest__c;
                    newOpp.Functional_Areas__c = applicantInfo.Functional_Areas__c;
                    newOpp.Position_Types__c = applicantInfo.Position_Types__c;
                    newOpp.Intrax_Center__c = applicantInfo.Intrax_Center__c;
                    newOpp.Service_Level__c = applicantInfo.Service_Level__c;
                    newOpp.Program_Start__c = applicantInfo.Program_Start__c;
                    newOpp.Program_Duration__c = applicantInfo.Program_Duration__c;
                    newOpp.Program_Year__c = applicantInfo.Program_Year__c;
                    newOpp.Engagement_Start__c = applicantInfo.Engagement_Start__c;
                    newOpp.Engagement_End__c = applicantInfo.Engagement_End__c;
                    newOpp.How_Heard__c = applicantInfo.How_Heard__c;
                    newOpp.RB_First_Name__c = applicantInfo.RB_First_Name__c;
                    newOpp.RB_Last_Name__c = applicantInfo.RB_Last_Name__c;
                    newOpp.Reason__c = applicantInfo.Reason__c;
                    newOpp.Reason_Detail__c = applicantInfo.Reason_Detail__c;
                    newOpp.StageName = 'Processing';
                    newOpp.AccountId = applicantInfo.Account__c;
                    insert newOpp; 
                            
                    applicantInfo.Opportunity_Name__c = newOpp.Id;
                }
            }
        }       
    }  
    */
    
    static testMethod void ConvertHotLeadTest(){
      Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
      
      user u = [SELECT Id, ProfileId FROM user WHERE ProfileId =: p.Id limit 1];
      system.debug('******* User Selected' + u);
      
      Lead l = new Lead(LastName ='Test',email='test@test.com', Rating = 'Hot', lead_Type__c = 'Host Family', Field_Staff__c = u.Id,
              Intrax_Program_Options__c = 'Ayusa High School', Intrax_Programs__c = 'Ayusa');
              
    insert l;          
    }
    
    public static void ConvertHotLead (List<Lead> LeadInfo){
            
      for(Lead l : LeadInfo){
        
        if(l.Rating == 'Hot' && l.Lead_Type__c == 'Host Family' && IUtilities.isIncluded(l.Intrax_Programs__c, 'Ayusa') && l.Field_Staff__c != null){
        
        Applicant_Info__c appInfoLead = new Applicant_Info__c();
         Person_Info__c personInfoLead = new Person_Info__c();
        School__c schoolInfoLead=new School__c();
        //Fields to convert to the AppInfo
        
        appInfoLead.OwnerId = l.Field_Staff__c;
      appInfoLead.Type__c = l.Lead_Type__c;
      appInfoLead.Intrax_Program__c = l.Intrax_Programs__c;
      appInfoLead.Intrax_Program_Options__c = l.Intrax_Program_Options__c;
      appInfoLead.Application_Level__c = 'Basic';
      appInfoLead.Application_Stage__c = 'Working';
      appInfoLead.How_Heard__c = l.How_Heard__c;
      appInfoLead.Lead__c = l.Id;
      appInfoLead.Home_City__c = l.City;
      appInfoLead.Home_State__c = l.State;
      appInfoLead.Home_Postal_Code__c = l.PostalCode;
      appInfoLead.Home_Country__c = l.Country;
      appInfoLead.Home_Phone__c = l.Phone;
      appInfoLead.Intrax_Region__c = l.Intrax_Region__c;       
      appInfoLead.Name = l.FirstName + ' ' + l.LastName + ' - ' + l.Intrax_Programs__c; 
      appInfoLead.RecordTypeId = '012a0000001NOM5';  
       appInfoLead.Email__c = l.Email; 
       appInfoLead.First_Name__c = l.FirstName;
      appInfoLead.Last_Name__c = l.LastName;
      appInfoLead.RB_First_Name__c = l.RB_First_Name__c;
      appInfoLead.RB_Last_Name__c = l.RB_Last_Name__c;
           
        //Fields to convert to the PersonInfo
        
        personInfoLead.Primary_Applicant__c = true ;
      personInfoLead.Name = l.FirstName + ' ' + l.LastName;
      personInfoLead.First_Name__c = l.FirstName;
      personInfoLead.Last_Name__c = l.LastName;
      personInfoLead.Email__c = l.Email;
      personInfoLead.Residency_Status__c = 'Full-Time';
      personInfoLead.Role__c = 'Host';
      
        try{
            
            insert appInfoLead;
            
            
          }catch(Exception e){
            system.debug('***** Impossible to insert related AppInfo : '+ e);
          }
          
          try{
            
            personInfoLead.Applicant_Info__c = appInfoLead.Id;
            insert personInfoLead;
            
          }catch(Exception e){
            system.debug('***** Impossible to insert related PersonInfo : '+ e);
          }
          try{
            
            schoolInfoLead.Applicant_Info__c = appInfoLead.Id;
            schoolInfoLead.Name =  'School ' + appInfoLead.Name;
            insert schoolInfoLead;
            
          }catch(Exception e){
            system.debug('***** Impossible to insert related PersonInfo : '+ e);
          }
        
        }
        
        
        
      }
      
    
    
    
    
    }
    
    /*
    public static void AppToLeadSync (Applicant_Info__c applicantInfo, Person_Info__c personInfo, Lead leadInfo, string action){
      
        leadInfo.FirstName = personInfo.First_Name__c;
        leadInfo.LastName = personInfo.Last_Name__c;
        leadInfo.Gender__c = personInfo.Gender__c;
        leadInfo.Email = personInfo.Email__c;
        leadInfo.Date_of_Birth__c = personInfo.Date_of_Birth__c;
        leadInfo.MobilePhone = personInfo.Mobile__c;
        leadInfo.Citizenship__c = applicantInfo.Citizenship__c;
        leadInfo.Skype_ID__c = personInfo.Skype_Id__c;
        leadInfo.Best_Call_Time__c = applicantInfo.Best_Call_Time__c;
         
        //leadInfo.Intrax_Programs__c = 'Ayusa';
        leadInfo.Intrax_Programs__c = applicantInfo.Intrax_Program__c;
        leadInfo.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
        leadInfo.Intrax_Region__c = applicantInfo.Intrax_Region__c;
        //leadInfo.Intrax_Region__c = 'United States';
        leadInfo.Countries_of_Interest__c = applicantInfo.Country_of_Interest__c;
        leadInfo.Location_of_Interest__c = applicantInfo.Location_of_Interest__c;
        leadInfo.Projects_of_Interest__c = applicantInfo.Projects_of_Interest__c;
        leadInfo.Functional_Areas__c = applicantInfo.Functional_Areas__c;
        leadInfo.Intrax_Center__c = applicantInfo.Intrax_Center__c;
        leadInfo.Service_Level__c = applicantInfo.Service_Level__c;
        leadInfo.Program_Start__c = applicantInfo.Program_Start__c;
        leadInfo.Program_Duration__c = applicantInfo.Program_Duration__c;
        leadInfo.Program_Year__c = applicantInfo.Program_Year__c;
        leadInfo.Desired_Start_Date__c = applicantInfo.Engagement_Start__c;
        leadInfo.Lead_Type__c = applicantInfo.Type__c;
        leadInfo.LeadSource = 'Portal';
        leadInfo.Lead_Source_Tag__c = 'Application';
        leadInfo.How_Heard__c = applicantInfo.How_Heard__c;
        leadInfo.RB_First_Name__c = applicantInfo.RB_First_Name__c;
        leadInfo.RB_Last_Name__c = applicantInfo.RB_Last_Name__c;leadInfo.Phone = applicantInfo.Home_Phone__c;
        leadInfo.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
        leadInfo.City = applicantInfo.Home_City__c;
        leadInfo.State = applicantInfo.Home_State__c;
        leadInfo.PostalCode = applicantInfo.Home_Postal_Code__c;
        leadInfo.Country = applicantInfo.Home_Country__c;
        leadInfo.Title = applicantInfo.Title__c;
        leadInfo.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;   
        
        
        // Update only if nto changed in last 24 hours
        if((leadInfo.Last_Interest_Date__c == NULL || !datetime.now().isSameDay(leadInfo.Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.createdBy__c == applicantInfo.LastModifiedById )){
            leadInfo.Last_Interest_Date__c = DateTime.now(); 
        }
        
        if(action == 'insert'){
          try{
            update leadInfo;    
          }catch(Exception e){
            system.debug('***** Impossible to update related Lead: '+ e);
          }  
        }else{
          try{
            insert LeadInfo;
          }catch(Exception e){
            system.debug('***** Impossible to insert related Lead: '+ e);
          }
        }      
    } 
    
    */
    
    public static string update_Intrax_Region(string inferred_country, string citizenship, string country){
        string intrax_region = NULL;    
        if(inferred_country != NULL){
            for( string cntr : Europe_Reg){
                if(cntr.contains(inferred_country) || inferred_country.contains(cntr)){ 
                    intrax_region = 'Europe';
                }
            }
           for( string cntr : USA_Reg){
                if(cntr.contains(inferred_country) || inferred_country.contains(cntr)){ 
                    intrax_region = 'United States';
                }
            }
             for( string cntr : Singapore_Reg){
                if(cntr.contains(inferred_country) || inferred_country.contains(cntr)){ 
                    intrax_region = 'Singapore';
                }
            }
            
            if(inferred_country.contains('Korea') || ('Korea').contains(inferred_country)){
                intrax_region = 'Korea';
            }else if(inferred_country.contains('Japan') || ('Japan').contains(inferred_country)){
                intrax_region = 'Japan';
            }else if(inferred_country.contains('Canada') || ('Canada').contains(inferred_country)){
                intrax_region = 'Canada';
            }else if(inferred_country.contains('Peru') || ('Peru').contains(inferred_country)){
                intrax_region = 'Peru';
            }else if(inferred_country.contains('Chile') || ('Chile').contains(inferred_country)){
                intrax_region = 'Chile';
            }
          
        }else if (citizenship != NULL){
            
            for( string cntr : Europe_Reg){
                
                if(cntr.contains(citizenship) || citizenship.contains(cntr)){                   
                    intrax_region = 'Europe';
                  
                }
            }
          for( string cntr : USA_Reg){
                if(cntr.contains(citizenship) || citizenship.contains(cntr)){ 
                    intrax_region = 'United States';
                }
            }
            for( string cntr : Singapore_Reg){
                if(cntr.contains(citizenship) || citizenship.contains(cntr)){ 
                    intrax_region = 'Singapore';
                }
            }
            
            if(citizenship.contains('Korea') || ('Korea').contains(citizenship)){
                intrax_region = 'Korea';
            }else if(citizenship.contains('Japan') || ('Japan').contains(citizenship)){
                intrax_region = 'Japan';
            }else if(citizenship.contains('Canada') || ('Canada').contains(citizenship)){
                intrax_region = 'Canada';
            }else if(citizenship.contains('Peru') || ('Peru').contains(citizenship)){
                intrax_region = 'Peru';
            }else if(citizenship.contains('Chile') || ('Chile').contains(citizenship)){
                intrax_region = 'Chile';
            }   
                        
        }else if (country != NULL){
            for( string cntr : Europe_Reg){
                if(cntr.contains(country) || country.contains(cntr)){ 
                    intrax_region = 'Europe';
                }
            }
           for( string cntr : USA_Reg){
                if(cntr.contains(country) || country.contains(cntr)){ 
                    intrax_region = 'United States';
                }
            }
            for( string cntr : Singapore_Reg){
                if(cntr.contains(country) || country.contains(cntr)){ 
                    intrax_region = 'Singapore';
                }
            }
            if(country.contains('Korea') || ('Korea').contains(country)){
                intrax_region = 'Korea';
            }else if(country.contains('Japan') || ('Japan').contains(country)){
                intrax_region = 'Japan';
            }else if(country.contains('Canada') || ('Canada').contains(country)){
                intrax_region = 'Canada';
            }else if(country.contains('Peru') || ('Peru').contains(country)){
                intrax_region = 'Peru';
            }else if(country.contains('Chile') || ('Chile').contains(country)){
                intrax_region = 'Chile';
            }          
        }
         return intrax_region;
    }  
    
    /*public static void sContactAction (list<Contact> cont){
      list<Contact> co;
    list<Contact> co_update;
    list<Contact> co_insert;
    list<sContact__c> sco_insert = new list<sContact__c>();
    list<sContact__c> sco_update = new list<sContact__c>();
    
    // 1.Getting all the data from the recently inserted contacts
    try{
      co = [SELECT c.Title, c.Territory__c, c.SystemModstamp, c.Status__c, c.Skype_ID__c, c.School_Name__c, c.Salutation, c.Resume__c, c.Resume_Summary__c, c.ReportsToId, c.Primary_Activity__c, c.Phone, c.Passport_Number__c, c.Parent_Name__c, c.Parent_Email__c, c.PSFDC_ID__c, c.OwnerId, c.Other_Email__c, c.OtherStreet, c.OtherState, c.OtherPostalCode, c.OtherPhone, c.OtherCountry, c.OtherCity, c.Number_of_Children__c, c.Nick_Name__c, c.Name, c.MobilePhone, c.Middle_Name__c, c.MasterRecordId, c.Major__c, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity, c.Legal_Residence__c, c.Lead_DOB__c, c.LeadSource, c.Last_Name_Pronunciation__c, c.Last_Interest_Date__c, c.LastNameLocal, c.LastName, c.LastModifiedDate, c.LastModifiedById, c.LastCUUpdateDate, c.LastCURequestDate, c.LastActivityDate, c.Languages_Spoken__c, c.Is_Sales_Contact__c, c.Is_Accounting_Contact__c, c.IsPersonAccount, c.IsDeleted, c.Intrax_Programs__c, c.Intrax_Program_Options_CT__c, c.Infant_in_Home__c, c.Id, c.ISFDC_ID__c, c.ISFDC_Acct_Id__c, c.HomePhone, c.HasOptedOutOfFax, c.HasOptedOutOfEmail, c.Graduation_Year__c, c.Gender__c, c.First_Name_Pronunciation__c, c.FirstNameLocal, c.FirstName, c.Fax, c.Extension__c, c.English_Test__c, c.English_Test_Score__c, c.English_Test_Date__c, c.English_Level__c, c.Employer_Name__c, c.Emergency_Primary__c, c.Emergency_Contact__c, c.EmailBouncedReason, c.EmailBouncedDate, c.Email, c.Education_Level__c, c.Education_Grade__c, c.EC_Phone__c, c.EC_Name__c, c.EC_Email__c, c.Driver_License__c, c.DoNotCall, c.Description, c.Department, c.CreatedDate, c.CreatedById, c.Contract_Contact__c, c.ConnectionSentId, c.ConnectionReceivedId, c.Citizenship__c, c.Birthdate, c.Birth_Country__c, c.Birth_City__c, c.Best_Call_Time__c, c.AssistantPhone, c.AssistantName, c.AccountId 
          FROM Contact c
          WHERE c.Id IN: cont];
      system.debug('****** Contact to be inserted / updated');
    
    // 2. Then, we can get of for the Contacts that already have associated a Contact record.
    co_update = [SELECT c.Title, c.Territory__c, c.SystemModstamp, c.Status__c, c.Skype_ID__c, c.School_Name__c, c.Salutation, c.Resume__c, c.Resume_Summary__c, c.ReportsToId, c.Primary_Activity__c, c.Phone, c.Passport_Number__c, c.Parent_Name__c, c.Parent_Email__c, c.PSFDC_ID__c, c.OwnerId, c.Other_Email__c, c.OtherStreet, c.OtherState, c.OtherPostalCode, c.OtherPhone, c.OtherCountry, c.OtherCity, c.Number_of_Children__c, c.Nick_Name__c, c.Name, c.MobilePhone, c.Middle_Name__c, c.MasterRecordId, c.Major__c, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity, c.Legal_Residence__c, c.Lead_DOB__c, c.LeadSource, c.Last_Name_Pronunciation__c, c.Last_Interest_Date__c, c.LastNameLocal, c.LastName, c.LastModifiedDate, c.LastModifiedById, c.LastCUUpdateDate, c.LastCURequestDate, c.LastActivityDate, c.Languages_Spoken__c, c.Is_Sales_Contact__c, c.Is_Accounting_Contact__c, c.IsPersonAccount, c.IsDeleted, c.Intrax_Programs__c, c.Intrax_Program_Options_CT__c, c.Infant_in_Home__c, c.Id, c.ISFDC_ID__c, c.ISFDC_Acct_Id__c, c.HomePhone, c.HasOptedOutOfFax, c.HasOptedOutOfEmail, c.Graduation_Year__c, c.Gender__c, c.First_Name_Pronunciation__c, c.FirstNameLocal, c.FirstName, c.Fax, c.Extension__c, c.English_Test__c, c.English_Test_Score__c, c.English_Test_Date__c, c.English_Level__c, c.Employer_Name__c, c.Emergency_Primary__c, c.Emergency_Contact__c, c.EmailBouncedReason, c.EmailBouncedDate, c.Email, c.Education_Level__c, c.Education_Grade__c, c.EC_Phone__c, c.EC_Name__c, c.EC_Email__c, c.Driver_License__c, c.DoNotCall, c.Description, c.Department, c.CreatedDate, c.CreatedById, c.Contract_Contact__c, c.ConnectionSentId, c.ConnectionReceivedId, c.Citizenship__c, c.Birthdate, c.Birth_Country__c, c.Birth_City__c, c.Best_Call_Time__c, c.AssistantPhone, c.AssistantName, c.AccountId 
          FROM Contact c 
          WHERE c.Id IN: co AND c.Id IN (SELECT Contact_Name__c FROM sContact__c)];
    system.debug('**** Contacts to update: ' + co_update.size());
    
    // 3. Now, getting the Contacts that DO NOT have an associated sContact yet.
    co_insert = [SELECT c.Title, c.Territory__c, c.SystemModstamp, c.Status__c, c.Skype_ID__c, c.School_Name__c, c.Salutation, c.Resume__c, c.Resume_Summary__c, c.ReportsToId, c.Primary_Activity__c, c.Phone, c.Passport_Number__c, c.Parent_Name__c, c.Parent_Email__c, c.PSFDC_ID__c, c.OwnerId, c.Other_Email__c, c.OtherStreet, c.OtherState, c.OtherPostalCode, c.OtherPhone, c.OtherCountry, c.OtherCity, c.Number_of_Children__c, c.Nick_Name__c, c.Name, c.MobilePhone, c.Middle_Name__c, c.MasterRecordId, c.Major__c, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity, c.Legal_Residence__c, c.Lead_DOB__c, c.LeadSource, c.Last_Name_Pronunciation__c, c.Last_Interest_Date__c, c.LastNameLocal, c.LastName, c.LastModifiedDate, c.LastModifiedById, c.LastCUUpdateDate, c.LastCURequestDate, c.LastActivityDate, c.Languages_Spoken__c, c.Is_Sales_Contact__c, c.Is_Accounting_Contact__c, c.IsPersonAccount, c.IsDeleted, c.Intrax_Programs__c, c.Intrax_Program_Options_CT__c, c.Infant_in_Home__c, c.Id, c.ISFDC_ID__c, c.ISFDC_Acct_Id__c, c.HomePhone, c.HasOptedOutOfFax, c.HasOptedOutOfEmail, c.Graduation_Year__c, c.Gender__c, c.First_Name_Pronunciation__c, c.FirstNameLocal, c.FirstName, c.Fax, c.Extension__c, c.English_Test__c, c.English_Test_Score__c, c.English_Test_Date__c, c.English_Level__c, c.Employer_Name__c, c.Emergency_Primary__c, c.Emergency_Contact__c, c.EmailBouncedReason, c.EmailBouncedDate, c.Email, c.Education_Level__c, c.Education_Grade__c, c.EC_Phone__c, c.EC_Name__c, c.EC_Email__c, c.Driver_License__c, c.DoNotCall, c.Description, c.Department, c.CreatedDate, c.CreatedById, c.Contract_Contact__c, c.ConnectionSentId, c.ConnectionReceivedId, c.Citizenship__c, c.Birthdate, c.Birth_Country__c, c.Birth_City__c, c.Best_Call_Time__c, c.AssistantPhone, c.AssistantName, c.AccountId 
          FROM Contact c 
          WHERE c.Id IN: co AND c.Id NOT IN (SELECT Contact_Name__c FROM sContact__c)];
    system.debug('**** Contacts to insert: ' + co_insert.size());
    
    }catch(Exception e){
      system.debug('***** Something went wrong getting all the data we need.');
    }
    
    //map<Id, sAccount__c> sa_ref = new map<Id, sAccount__c>();
    // 4. When creating an sContact record, we need to associated it to the corresponding sAccount record.
    // So, we need to go from 1) to 3) : 1. Contact --> 2. Account --> 3. sAccount__c
    // We?ll need to create some auxiliary data, becuase it is not possible to biuld this directly.
    // 4.1 Creating a list of Account Id from the contact object
    list<Id> c_id = new list<Id>();
    for (Contact c : co){
      Id c_aux = c.AccountID;
      c_id.add(c_aux);
    }
    // 4.2. First relationship: map (Account, sAccount__c)
    map<Id, Id> ac_map = new map<Id, Id>();
    list<Account> acc = [SELECT Id FROM Account WHERE Id IN :c_id];
    list<sAccount__c> sacc = [SELECT Id, Account_Name__c FROM sAccount__c WHERE Account_Name__c IN: acc];
            
    for(sAccount__c s: sacc){
      ac_map.put(s.Account_Name__c, s.Id); // Key: Account.ID -- Value: sAccount.ID
    }
    // 4.3. Second relationship: map(Contact, sAccount__c)
    map<Id, Id> sa_ref = new map<Id, Id>();
    for(Contact c: co){
      // Thru the c.AccountId, using the previously defined map, a can access to the necessary sAccount ID
      sa_ref.put(c.Id, ac_map.get(c.AccountID)); 
    }
    
    // 5. Now, we can proceed and do the mapping for each case!
    if(co_insert.size() != 0){
      // INSERTING RECORDS!
      system.debug('***** INSERTING CONTACT RECORD');
      for(Contact c : co_insert){
          sContact__c sc = new sContact__c();
          sContact__c sc_mapped = IUtilities.sContactMapping(c, sc, sa_ref.get(c.Id)); // Key: Contact.ID -- Value: sAccount.ID
          sco_insert.add(sc_mapped);
      } 
      try{
        insert sco_insert;
      }catch(Exception e){
        system.debug('***** Something happened when trying to insert Contact records!');
      }
    }
    
    if(co_update.size() != 0){
      system.debug('***** UPDATING CONTACT RECORD');
      // Updating Records!
      // 1. First, need to look for the existing sContact records
      try{
        list<sContact__c> sc_update = [SELECT s.sAccount_Name__c, s.Verification_Status__c, s.Title__c, s.Territory__c, s.SystemModstamp, s.Skype_ID__c, s.Phone__c, s.OwnerId, s.Other_Email__c, s.Nick_Name__c, s.Name, s.Mobile__c, s.Mailing_Street__c, s.Mailing_State__c, s.Mailing_Postal_Code__c, s.Mailing_Country__c, s.Mailing_City__c, s.Last_Name__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Intrax_Programs__c, s.Intrax_Program_Options__c, s.Id, s.Gender__c, s.First_Name__c, s.Email__c, s.Description__c, s.CreatedDate, s.CreatedById, s.Contact_Name__c, s.ConnectionSentId, s.ConnectionReceivedId, s.Best_Call_Time__c, s.Salutation__c
                        FROM sContact__c s 
                        WHERE Contact_Name__c IN :co_update];
        
        // Creating a relationship between the existing sContact record and its original contact record
        map<Id, sContact__c> map_co = new map<Id, sContact__c>();
        for(sContact__c s : sc_update){
          map_co.put(s.Contact_Name__c, s);
        }
        
        for(Contact c: co_update){
          sContact__c sc_mapped = IUtilities.sContactMapping(c, map_co.get(c.Id), sa_ref.get(c.Id)); // Key: Contact.ID -- Value: sAccount.ID
          sco_update.add(sc_mapped);
        }
        update sco_update;
      }catch(Exception e){
        system.debug('***** Error trying to update sContact records');
      }                            
    }
    }
    
    
    public static void sAccountAction(List<Account> a_trigger) {
     // Necessary list to insert / Update to new records
    list<sAccount__c> sacc_insert = new list<sAccount__c>();
    list<sAccount__c> sacc_update = new list<sAccount__c>();
    list<sAccount__c> sa_update;
    map<Id, sAccount__c> m_update = new map<Id, sAccount__c>();
    list<Account> a_update;
    list<Account> a_insert;
    
    try{
      // 1. First thing we need is all the data from the recently inserted accounts
      list<Account> acc  = [SELECT a.Websites_Additional__c, a.Website,  a.Type, a.Tuition__c, a.TickerSymbol, a.Territory__pc, a.Territory_Loaned__c, a.Territory_Loan_Date__c, a.Territory_Codes__c, a.Territory_Child_Count__c, a.Territory_Adult_Count__c, a.Termination_Date__c, a.TOEFL_Cutoff__c, a.SystemModstamp, a.Sys_Intrax_Programs__c, a.Sys_Intrax_Program_Options__c, a.Sys_Admin_Tag__pc, a.Sys_Admin_Tag__c, a.Status__pc, a.Status__c, a.Skype_ID__pc, a.Site, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Service_Level__c, a.Seasonality_WT__c, a.Seasonality_Interns__c, a.School_Name__pc, a.School_Model__c, a.Salutation, a.SLEP_Cutoff__c, a.Resume__pc, a.Resume_URL__c, a.Resume_Summary__pc, a.Regi_ID__c, a.RecordTypeId, a.Rating, a.Program_Manager__c, a.ProWorld_Beta_Score_c__pc, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Primary_Activity__pc, a.Position_Types__c, a.Position_Types_Other__c, a.Portal_Contact_Name__c, a.Pluto_ID__c, a.Phone, a.PersonTitle, a.PersonOtherStreet, a.PersonOtherState, a.PersonOtherPostalCode, a.PersonOtherPhone, a.PersonOtherCountry, a.PersonOtherCity, a.PersonMobilePhone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.PersonLeadSource, a.PersonLastNameLocal, a.PersonLastCUUpdateDate, a.PersonLastCURequestDate, a.PersonHomePhone, a.PersonHasOptedOutOfFax, a.PersonHasOptedOutOfEmail, a.PersonFirstNameLocal, a.PersonEmailBouncedReason, a.PersonEmailBouncedDate, a.PersonEmail, a.PersonDoNotCall, a.PersonDepartment, a.PersonContactId, a.PersonBirthdate, a.PersonAssistantPhone, a.PersonAssistantName, a.Passport_Number__pc, a.Partner_Type__c, a.Parent_Name__pc, a.Parent_Email__pc, a.ParentId, a.Paperless_Communication__c, a.PSFDC_ID__pc, a.PSFDC_ID__c, a.Ownership, a.OwnerId, a.Other_Email__pc, a.Original_Referrer_BaseURL__c, a.Number_of_Locations__c, a.Number_of_Children__pc, a.NumberOfEmployees, a.Nick_Name__pc, a.Nemo_Id__c, a.NameLocal, a.Name, a.Middle_Name__pc, a.MasterRecordId, a.Manga_Id__c, a.Major__pc, a.Legal_Residence__pc, a.Lead_Type__c, a.Lead_DOB__pc, a.Last_Name_Pronunciation__pc, a.Last_Interest_Date__pc, a.LastName, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__pc, a.KR_MT_ID__c, a.KR_DT_ID__c, a.J1_Experience__c, a.Issues_I_20__c, a.Is_Sales_Contact__pc, a.Is_Accounting_Contact__pc, a.IsPersonAccount, a.IsPartner, a.IsDeleted, a.IsCustomerPortal, a.Intrax_Region__c, a.Intrax_Programs__pc, a.Intrax_Programs__c, a.Intrax_Program_Options__c, a.Intrax_Program_Options_CT__pc, a.Intrax_Id__c, a.Interview__c, a.Institution_Type__c, a.Infant_in_Home__pc, a.Industry, a.Inception_Date__c, a.Id, a.ISFDC_ID__pc, a.ISFDC_ID__c, a.ISFDC_Acct_Id__pc, a.Homestay__c, a.Homestay_Stipend__c, a.Hiring_Method__c, a.Graduation_Year__pc, a.Gender__pc, a.GPA__c, a.Franchise_Tier__c, a.First_Name_Pronunciation__pc, a.FirstName, a.Fax, a.Extension__pc, a.Extension__c, a.Enrollment_Total__c, a.Enrollment_Intl__c, a.English_Test__pc, a.English_Test_Score__pc, a.English_Test_Date__pc, a.English_Level__pc, a.Employer_Name__pc, a.Emergency_Primary__pc, a.Emergency_Contact__pc, a.Email_Business__c, a.Education_Level__pc, a.Education_Grade__pc, a.ESL__c, a.EIN__c, a.EC_Phone__pc, a.EC_Name__pc, a.EC_Email__pc, a.Driver_License__pc, a.Description, a.CreatedDate, a.CreatedById, a.Contract_Contact__pc, a.ConnectionSentId, a.ConnectionReceivedId, a.Compass_Id__c, a.Commission_Rate__c, a.Citizenship__pc, a.Casper_Id__c, a.Boarding__c, a.Birth_Country__pc, a.Birth_City__pc, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.Best_Call_Time__pc, a.AnnualRevenue, a.Agreement_Type__c, a.Affiliation_Religious__c, a.Affiliated__c, a.Admission_Deadline__c, a.Additional_Fees__c, a.Actor_Roles__c, a.Accounting_Code__c, a.Account_Name_Legal__c, a.Account_Count__c 
        FROM Account a WHERE a.Id IN :a_trigger];  
    
      // 2. Then, we can get of for the sAccounts that already exist.
      a_update = [SELECT a.Websites_Additional__c, a.Website,  a.Type, a.Tuition__c, a.TickerSymbol, a.Territory__pc, a.Territory_Loaned__c, a.Territory_Loan_Date__c, a.Territory_Codes__c, a.Territory_Child_Count__c, a.Territory_Adult_Count__c, a.Termination_Date__c, a.TOEFL_Cutoff__c, a.SystemModstamp, a.Sys_Intrax_Programs__c, a.Sys_Intrax_Program_Options__c, a.Sys_Admin_Tag__pc, a.Sys_Admin_Tag__c, a.Status__pc, a.Status__c, a.Skype_ID__pc, a.Site, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Service_Level__c, a.Seasonality_WT__c, a.Seasonality_Interns__c, a.School_Name__pc, a.School_Model__c, a.Salutation, a.SLEP_Cutoff__c, a.Resume__pc, a.Resume_URL__c, a.Resume_Summary__pc, a.Regi_ID__c, a.RecordTypeId, a.Rating, a.Program_Manager__c, a.ProWorld_Beta_Score_c__pc, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Primary_Activity__pc, a.Position_Types__c, a.Position_Types_Other__c, a.Portal_Contact_Name__c, a.Pluto_ID__c, a.Phone, a.PersonTitle, a.PersonOtherStreet, a.PersonOtherState, a.PersonOtherPostalCode, a.PersonOtherPhone, a.PersonOtherCountry, a.PersonOtherCity, a.PersonMobilePhone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.PersonLeadSource, a.PersonLastNameLocal, a.PersonLastCUUpdateDate, a.PersonLastCURequestDate, a.PersonHomePhone, a.PersonHasOptedOutOfFax, a.PersonHasOptedOutOfEmail, a.PersonFirstNameLocal, a.PersonEmailBouncedReason, a.PersonEmailBouncedDate, a.PersonEmail, a.PersonDoNotCall, a.PersonDepartment, a.PersonContactId, a.PersonBirthdate, a.PersonAssistantPhone, a.PersonAssistantName, a.Passport_Number__pc, a.Partner_Type__c, a.Parent_Name__pc, a.Parent_Email__pc, a.ParentId, a.Paperless_Communication__c, a.PSFDC_ID__pc, a.PSFDC_ID__c, a.Ownership, a.OwnerId, a.Other_Email__pc, a.Original_Referrer_BaseURL__c, a.Number_of_Locations__c, a.Number_of_Children__pc, a.NumberOfEmployees, a.Nick_Name__pc, a.Nemo_Id__c, a.NameLocal, a.Name, a.Middle_Name__pc, a.MasterRecordId, a.Manga_Id__c, a.Major__pc, a.Legal_Residence__pc, a.Lead_Type__c, a.Lead_DOB__pc, a.Last_Name_Pronunciation__pc, a.Last_Interest_Date__pc, a.LastName, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__pc, a.KR_MT_ID__c, a.KR_DT_ID__c, a.J1_Experience__c, a.Issues_I_20__c, a.Is_Sales_Contact__pc, a.Is_Accounting_Contact__pc, a.IsPersonAccount, a.IsPartner, a.IsDeleted, a.IsCustomerPortal, a.Intrax_Region__c, a.Intrax_Programs__pc, a.Intrax_Programs__c, a.Intrax_Program_Options__c, a.Intrax_Program_Options_CT__pc, a.Intrax_Id__c, a.Interview__c, a.Institution_Type__c, a.Infant_in_Home__pc, a.Industry, a.Inception_Date__c, a.Id, a.ISFDC_ID__pc, a.ISFDC_ID__c, a.ISFDC_Acct_Id__pc, a.Homestay__c, a.Homestay_Stipend__c, a.Hiring_Method__c, a.Graduation_Year__pc, a.Gender__pc, a.GPA__c, a.Franchise_Tier__c, a.First_Name_Pronunciation__pc, a.FirstName, a.Fax, a.Extension__pc, a.Extension__c, a.Enrollment_Total__c, a.Enrollment_Intl__c, a.English_Test__pc, a.English_Test_Score__pc, a.English_Test_Date__pc, a.English_Level__pc, a.Employer_Name__pc, a.Emergency_Primary__pc, a.Emergency_Contact__pc, a.Email_Business__c, a.Education_Level__pc, a.Education_Grade__pc, a.ESL__c, a.EIN__c, a.EC_Phone__pc, a.EC_Name__pc, a.EC_Email__pc, a.Driver_License__pc, a.Description, a.CreatedDate, a.CreatedById, a.Contract_Contact__pc, a.ConnectionSentId, a.ConnectionReceivedId, a.Compass_Id__c, a.Commission_Rate__c, a.Citizenship__pc, a.Casper_Id__c, a.Boarding__c, a.Birth_Country__pc, a.Birth_City__pc, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.Best_Call_Time__pc, a.AnnualRevenue, a.Agreement_Type__c, a.Affiliation_Religious__c, a.Affiliated__c, a.Admission_Deadline__c, a.Additional_Fees__c, a.Actor_Roles__c, a.Accounting_Code__c, a.Account_Name_Legal__c, a.Account_Count__c 
               FROM Account a WHERE a.Id IN: acc AND a.Id IN (SELECT Account_Name__c FROM sAccount__c)];
      // 3. Then, we can calculate the difference, and the result will we those that do not exist.
      a_insert =  [SELECT a.Websites_Additional__c, a.Website,  a.Type, a.Tuition__c, a.TickerSymbol, a.Territory__pc, a.Territory_Loaned__c, a.Territory_Loan_Date__c, a.Territory_Codes__c, a.Territory_Child_Count__c, a.Territory_Adult_Count__c, a.Termination_Date__c, a.TOEFL_Cutoff__c, a.SystemModstamp, a.Sys_Intrax_Programs__c, a.Sys_Intrax_Program_Options__c, a.Sys_Admin_Tag__pc, a.Sys_Admin_Tag__c, a.Status__pc, a.Status__c, a.Skype_ID__pc, a.Site, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Service_Level__c, a.Seasonality_WT__c, a.Seasonality_Interns__c, a.School_Name__pc, a.School_Model__c, a.Salutation, a.SLEP_Cutoff__c, a.Resume__pc, a.Resume_URL__c, a.Resume_Summary__pc, a.Regi_ID__c, a.RecordTypeId, a.Rating, a.Program_Manager__c, a.ProWorld_Beta_Score_c__pc, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Primary_Activity__pc, a.Position_Types__c, a.Position_Types_Other__c, a.Portal_Contact_Name__c, a.Pluto_ID__c, a.Phone, a.PersonTitle, a.PersonOtherStreet, a.PersonOtherState, a.PersonOtherPostalCode, a.PersonOtherPhone, a.PersonOtherCountry, a.PersonOtherCity, a.PersonMobilePhone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.PersonLeadSource, a.PersonLastNameLocal, a.PersonLastCUUpdateDate, a.PersonLastCURequestDate, a.PersonHomePhone, a.PersonHasOptedOutOfFax, a.PersonHasOptedOutOfEmail, a.PersonFirstNameLocal, a.PersonEmailBouncedReason, a.PersonEmailBouncedDate, a.PersonEmail, a.PersonDoNotCall, a.PersonDepartment, a.PersonContactId, a.PersonBirthdate, a.PersonAssistantPhone, a.PersonAssistantName, a.Passport_Number__pc, a.Partner_Type__c, a.Parent_Name__pc, a.Parent_Email__pc, a.ParentId, a.Paperless_Communication__c, a.PSFDC_ID__pc, a.PSFDC_ID__c, a.Ownership, a.OwnerId, a.Other_Email__pc, a.Original_Referrer_BaseURL__c, a.Number_of_Locations__c, a.Number_of_Children__pc, a.NumberOfEmployees, a.Nick_Name__pc, a.Nemo_Id__c, a.NameLocal, a.Name, a.Middle_Name__pc, a.MasterRecordId, a.Manga_Id__c, a.Major__pc, a.Legal_Residence__pc, a.Lead_Type__c, a.Lead_DOB__pc, a.Last_Name_Pronunciation__pc, a.Last_Interest_Date__pc, a.LastName, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__pc, a.KR_MT_ID__c, a.KR_DT_ID__c, a.J1_Experience__c, a.Issues_I_20__c, a.Is_Sales_Contact__pc, a.Is_Accounting_Contact__pc, a.IsPersonAccount, a.IsPartner, a.IsDeleted, a.IsCustomerPortal, a.Intrax_Region__c, a.Intrax_Programs__pc, a.Intrax_Programs__c, a.Intrax_Program_Options__c, a.Intrax_Program_Options_CT__pc, a.Intrax_Id__c, a.Interview__c, a.Institution_Type__c, a.Infant_in_Home__pc, a.Industry, a.Inception_Date__c, a.Id, a.ISFDC_ID__pc, a.ISFDC_ID__c, a.ISFDC_Acct_Id__pc, a.Homestay__c, a.Homestay_Stipend__c, a.Hiring_Method__c, a.Graduation_Year__pc, a.Gender__pc, a.GPA__c, a.Franchise_Tier__c, a.First_Name_Pronunciation__pc, a.FirstName, a.Fax, a.Extension__pc, a.Extension__c, a.Enrollment_Total__c, a.Enrollment_Intl__c, a.English_Test__pc, a.English_Test_Score__pc, a.English_Test_Date__pc, a.English_Level__pc, a.Employer_Name__pc, a.Emergency_Primary__pc, a.Emergency_Contact__pc, a.Email_Business__c, a.Education_Level__pc, a.Education_Grade__pc, a.ESL__c, a.EIN__c, a.EC_Phone__pc, a.EC_Name__pc, a.EC_Email__pc, a.Driver_License__pc, a.Description, a.CreatedDate, a.CreatedById, a.Contract_Contact__pc, a.ConnectionSentId, a.ConnectionReceivedId, a.Compass_Id__c, a.Commission_Rate__c, a.Citizenship__pc, a.Casper_Id__c, a.Boarding__c, a.Birth_Country__pc, a.Birth_City__pc, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.Best_Call_Time__pc, a.AnnualRevenue, a.Agreement_Type__c, a.Affiliation_Religious__c, a.Affiliated__c, a.Admission_Deadline__c, a.Additional_Fees__c, a.Actor_Roles__c, a.Accounting_Code__c, a.Account_Name_Legal__c, a.Account_Count__c 
              FROM Account a WHERE a.Id IN :acc AND a.Id NOT IN (SELECT Account_Name__c FROM sAccount__c) ];
    }catch(Exception e){
      system.debug('***** SOMETHING WRONG HAPPENED trying to retrieve the necessary account data an sObject record: ' + e);
    }
    // UPDATING RECORDS...
    if(a_update.size() != 0){
      // Getting the corresponding sAccounts
      try{
        sa_update = [SELECT s.Websites_Additional__c, s.Website__c, s.Verification_Status__c, s.Type__c, s.Title__c, s.SystemModstamp, s.Status__c, s.Skype_ID__c, s.Shipping_Street__c, s.Shipping_State__c, s.Shipping_Postal_Code__c, s.Shipping_Country__c, s.Shipping_City__c, s.Service_Level__c, s.School_Name__c, s.Salutation__c, 
                s.RecordTypeId, s.Rating__c, s.Program_Duration__c, s.Primary_Related_Party_Name__c, s.Primary_Related_Party_ID__c, s.Position_Types__c, s.Position_Types_Other__c, s.Portal_User_Name__c, s.Phone__c, s.Partner_Type__c, s.OwnerId, s.Other_Phone__c, s.Number_of_Locations__c, s.Name_Local__c, s.Name, s.Mobile__c, s.Major__c, s.Mailing_Street__c, s.Mailing_State__c, s.Mailing_Postal_Code__c, s.Mailing_Country__c, s.Mailing_City__c, s.Location_of_Interest__c, s.Lead_Source_Tag__c, s.Last_Name__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Intrax_Region__c, s.Intrax_Programs__c, s.Intrax_Programs_CT__c, s.Intrax_Program_Options__c, s.Intrax_Program_Options_CT__c, s.Intrax_Id__c, s.Industry__c, s.Inception_Date__c, s.Id, s.Home_Phone__c, s.Graduation_Year__c, s.Gender__c, s.GPA__c, s.Functional_Areas__c, s.Functional_Areas_Other__c, s.First_Name__c, s.First_Name_Pronunciation__c, s.Fax__c, s.Extension__c, s.English_Level__c, s.Engagement_Start__c, s.Employees__c, s.Emergency_Primary__c, s.Emergency_Contact__c, s.Email__c, s.Email_Business__c, s.Education_Level__c, s.Education_Grade__c, s.EC_Phone__c, s.EC_Name__c, s.EC_Email__c, s.Description__c, s.Date_of_Birth__c, s.CreatedDate, s.CreatedById, s.ConnectionSentId, s.ConnectionReceivedId, s.Commission_Rate__c, s.Citizenship__c, s.Billing_Street__c, s.Billing_State__c, s.Billing_Postal_Code__c, s.Billing_Country__c, s.Billing_City__c, s.Best_Call_Time__c, s.Account_Name__c 
                   FROM sAccount__c s WHERE Account_Name__c IN :a_update];
        
        for(sAccount__c sa : sa_update){
          m_update.put(sa.Account_Name__c, sa);  
        }
      }catch(Exception e){
        system.debug('***** Something wrong happened trying to retrieve the data we need to update records: ' + e);
      }
      
      // UPDATING RECORDS...
      for(Account a : a_update){
        if(a.type == 'Host Company' || a.Type == 'Partner' || (a.type == 'Participant' && isIncluded(a.Intrax_Programs__c, 'Internship'))){
          // First, it it neceessary the get the sAccount record associated to the current one.
          sAccount__c sa = m_update.get(a.Id);
          // Now, we can do the mapping!
          //We only need PT or HC Accounts
          sAccount__c sa_mapped = IUtilities.sAccountMapping(a, sa);          
          sacc_update.add(sa_mapped);
        }
      }
      try{
        update sacc_update;
      }catch(Exception e){
        system.debug('It was not possible to update the requested records.');
      }
    }
    // INSERTING RECORDS...  
    if(a_insert.size() != 0){
      for(Account a : a_insert){
        if(a.type == 'Host Company' || a.Type == 'Partner' ||(a.type == 'Participant' && isIncluded(a.Intrax_Programs__c, 'Internship'))){ // Participant or HF
          sAccount__c sa = new sAccount__c();
          system.debug('******* Inserting record for Account: ' + a.Id);
          sAccount__c sa_mapped = IUtilities.sAccountMapping(a, sa);      
          sacc_insert.add(sa_mapped);  
        }
      }
      try{
        insert sacc_insert;
      }catch(Exception e){
        system.debug('***** It was impossible to insert the records requested.');  
      }
      // In the case that the Account is a Person Account (Participants), a Contact is automaticcaly generated by SFDC
      // This creation is now detected by the isInsert contact trigger, so we need to create the sContact record here.
      list<Contact> c_person = [SELECT c.Title, c.Territory__c, c.SystemModstamp, c.Status__c, c.Skype_ID__c, c.School_Name__c, c.Salutation, c.Resume__c, c.Resume_Summary__c, c.ReportsToId, c.Primary_Activity__c, c.Phone, c.Passport_Number__c, c.Parent_Name__c, c.Parent_Email__c, c.PSFDC_ID__c, c.OwnerId, c.Other_Email__c, c.OtherStreet, c.OtherState, c.OtherPostalCode, c.OtherPhone, c.OtherCountry, c.OtherCity, c.Number_of_Children__c, c.Nick_Name__c, c.Name, c.MobilePhone, c.Middle_Name__c, c.MasterRecordId, c.Major__c, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity, c.Legal_Residence__c, c.Lead_DOB__c, c.LeadSource, c.Last_Name_Pronunciation__c, c.Last_Interest_Date__c, c.LastNameLocal, c.LastName, c.LastModifiedDate, c.LastModifiedById, c.LastCUUpdateDate, c.LastCURequestDate, c.LastActivityDate, c.Languages_Spoken__c, c.Is_Sales_Contact__c, c.Is_Accounting_Contact__c, c.IsPersonAccount, c.IsDeleted, c.Intrax_Programs__c, c.Intrax_Program_Options_CT__c, c.Infant_in_Home__c, c.Id, c.ISFDC_ID__c, c.ISFDC_Acct_Id__c, c.HomePhone, c.HasOptedOutOfFax, c.HasOptedOutOfEmail, c.Graduation_Year__c, c.Gender__c, c.First_Name_Pronunciation__c, c.FirstNameLocal, c.FirstName, c.Fax, c.Extension__c, c.English_Test__c, c.English_Test_Score__c, c.English_Test_Date__c, c.English_Level__c, c.Employer_Name__c, c.Emergency_Primary__c, c.Emergency_Contact__c, c.EmailBouncedReason, c.EmailBouncedDate, c.Email, c.Education_Level__c, c.Education_Grade__c, c.EC_Phone__c, c.EC_Name__c, c.EC_Email__c, c.Driver_License__c, c.DoNotCall, c.Description, c.Department, c.CreatedDate, c.CreatedById, c.Contract_Contact__c, c.ConnectionSentId, c.ConnectionReceivedId, c.Citizenship__c, c.Birthdate, c.Birth_Country__c, c.Birth_City__c, c.Best_Call_Time__c, c.AssistantPhone, c.AssistantName, c.AccountId 
                    FROM Contact c
                    WHERE c.AccountId IN: a_insert];
      system.debug('Number of Person Accounts (PTs): ' + c_person.size());
      IUtilities.sContactAction(c_person);
    }
   }
   
 
   
 public static sContact__c sContactMapping(Contact co, sContact__c sc, Id sa_Id){
   sc.sAccount_Name__c = sa_Id;
  sc.Name = co.FirstName + ' ' + co.LastName;
  sc.Salutation__c = co.Salutation;
  sc.First_Name__c = co.FirstName;
  sc.Last_Name__c = co.LastName;
  sc.Title__c = co.Title;
  sc.OwnerId = co.OwnerId;
  sc.Email__c = co.Email;
  sc.Other_Email__c = co.Other_Email__c;
  sc.Contact_Name__c = co.Id;
  sc.Mailing_Street__c = co.MailingStreet;
  sc.Mailing_City__c = co.MailingCity;
  sc.Mailing_State__c = co.MailingState;
  sc.Mailing_Postal_Code__c = co.MailingPostalCode;
  sc.Mailing_Country__c = co.MailingCountry;
  sc.Phone__c = co.Phone;
  sc.Mobile__c = co.MobilePhone;
  sc.Best_Call_Time__c = co.Best_Call_Time__c;
  sc.Gender__c = co.Gender__c;
  sc.Skype_ID__c = co.Skype_ID__c;
  sc.Intrax_Programs__c = co.Intrax_Programs__c;
  sc.Intrax_Program_Options__c = co.Intrax_Program_Options_CT__c;
  sc.Description__c = co.Description;
  
  return sc;
 }
 
 
  static testMethod void sAccountActionTest(){
    Account ac = new Account(
          FirstName = 'Test', LastName = 'Trigger', PersonEmail = 'test@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
      insert ac;
      sAccount__c sa = new sAccount__c();
      sAccountMapping(ac, sa);
  }
  
  static testMethod void sContactActionTest(){
    Account a = new Account(
            Name = 'Trigger HC', Email_Business__c = 'testhc@test.com',
            type = 'Host Company', Intrax_Programs__c = 'Internship', 
            OwnerId = UserInfo.getUserId()
            );
            
        insert a;
        
        Contact c = new Contact(
            FirstName = 'Test', LastName = 'Triggerc', Email = 'testc@test.com',
            Intrax_Programs__c = 'Internship', OwnerId = UserInfo.getUserId(), AccountId = a.Id
            );
        
        insert c;  
        
        sContact__c sc =  new sContact__c();
        
        sContactMapping(c, sc, a.Id);     
  }
 
 public static sAccount__c sAccountMapping(Account a, sAccount__c sa){
    //Common Fields
    sa.Account_Name__c = a.Id;
    sa.Name_Local__c = a.NameLocal;
    sa.OwnerId = a.OwnerId;
            
    sa.type__c = a.Type;
    sa.Intrax_Id__c = a.Intrax_Id__c;                
    sa.Billing_City__c = a.BillingCity;
    sa.Billing_Postal_Code__c = a.BillingPostalCode;
    sa.Billing_Street__c = a.BillingStreet;
    sa.Billing_Country__c = a.BillingCountry;
    
    sa.Phone__c = a.Phone;
    sa.Intrax_Program_Options__c = a.Intrax_Program_Options__c;
    sa.Intrax_Programs__c = a.Intrax_Programs__c;
    sa.Intrax_Region__c = a.Intrax_Region__c;
    sa.Service_Level__c = a.Service_Level__c;
    sa.Status__c = a.Status__c;
    
    sa.Extension__c = a.Extension__c;
    sa.Description__c = a.Description;
    
    // Special cases for PTs
    if(a.type == 'Participant'){
      sa.Mailing_Street__c = a.PersonMailingStreet;
      sa.Mailing_City__c = a.PersonMailingCity;            
      sa.Mailing_Postal_Code__c = a.PersonMailingPostalCode;
      sa.Mailing_State__c = a.PersonMailingState;            
      sa.Mailing_Country__c = a.PersonMailingCountry;  
                
      sa.Salutation__c = a.Salutation;
      sa.First_Name__c = a.FirstName;
      sa.Last_Name__c = a.LastName;
      sa.Name = a.FirstName + ' ' + a.LastName;
      sa.Email__c = a.PersonEmail;
      sa.Date_Of_Birth__c = a.PersonBirthdate;
      sa.Fax__c = a.Fax;
      sa.Mobile__c = a.PersonMobilePhone;
      sa.Home_Phone__c = a.PersonHomePhone;
      sa.Other_Phone__c = a.PersonOtherPhone;
      
      sa.Title__c = a.PersonTitle;
      sa.Best_Call_Time__c = a.Best_Call_Time__pc;
      sa.Citizenship__c = a.Citizenship__pc;
      sa.English_Level__c = a.English_Level__pc;  
      sa.Gender__c = a.Gender__pc;
      sa.Graduation_Year__c = a.Graduation_Year__pc;
      sa.Major__c = a.Major__pc;
      sa.School_Name__c = a.School_Name__pc;
      sa.Skype_ID__c = a.Skype_ID__pc;
      sa.GPA__c = a.GPA__c;
      
      sa.EC_Email__c = a.EC_Email__pc;
      sa.EC_Name__c = a.EC_Name__pc;
      sa.EC_Phone__c = a.EC_Phone__pc;
      sa.Education_Grade__c = a.Education_Grade__pc;
      sa.Education_Level__c = a.Education_Level__pc;
      sa.Emergency_Contact__c = a.Emergency_Contact__pc;
      sa.Emergency_Primary__c = a.Emergency_Primary__pc;
      
      sa.First_Name_Pronunciation__c = a.First_Name_Pronunciation__pc;
      
      sa.Intrax_Programs_CT__c = a.Intrax_Programs__pc;
      sa.Intrax_Program_Options_CT__c = a.Intrax_Program_Options_CT__pc;
    }
    if(a.Type == 'Partner'){
      sa.Name = a.Name;
    }
    //Special cases for HCs
    if(a.type == 'Host Company'){
      sa.Employees__c = a.NumberOfEmployees;
      sa.Industry__c = a.Industry;
      sa.Email_Business__c = a.Email_Business__c;
      sa.Website__c = a.Website;
      sa.Websites_Additional__c = a.Websites_Additional__c;          
      sa.Name = a.Name;
    }  
  return sa;
 }  */
 
 static testmethod void blindTester(){
    
        Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                          Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                          Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test', Program_Year__c = '2014',
                                                          Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', RecordTypeId = Constants.AyusaHF_Record_Type_Id, Special_Diet_Indicated__c = 'No',
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                          Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes', Sys_Allow_Cloning__c = true);
        insert appInfo1;    
        
        Applicant_Info__c appInfo2 = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                          Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                          Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test', Program_Year__c = '2014',
                                                          Application_Stage__c = 'Working', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', RecordTypeId = Constants.AyusaHF_Record_Type_Id, Special_Diet_Indicated__c = 'No',
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                          Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
        insert appInfo2;    
        
        list<Applicant_Info__c> listApps = new list<Applicant_Info__c> ();
        insert listApps;
        listApps.add(appInfo1);
        listApps.add(appInfo2);
    
    
    list<Opportunity> opps = new list<Opportunity>();
    IUtilities.OpportunityToEngagement(opps);
    IUtilities.update_opp_PrimaryContact(opps);
    Opportunity o = new Opportunity();
    o.RecordTypeId = '01230000000sWd6';
    Engagement__c e = new Engagement__c();
    e.Intrax_Program__c = 'Internship';
    e.status__c='New';
    e.Opportunity_Id__c = o.Id;
    IUtilities.oppToEngagementMapping(e, o);
   
    List<Engagement__c> Englist = new list<Engagement__c>();
    Englist.add(e);
    IUtilities.syncEngToOpp(Englist);
    list<Applicant_Info__c> apps = new list<Applicant_Info__c>();
    IUtilities.check_clone_App(apps);
    List<Lead> upsertLeads = new List<Lead>();
    IUtilities.stripBadStates(upsertLeads);
    IUtilities.check_clone_App(listApps);
    String msPickList = 'String1;String2';
    String searchVal = 'String2';
    Iutilities.isIncluded(msPickList, searchVal);
    Account newAcc = new Account(LastName = 'Test', RecordTypeId = '01230000000rF7M', PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect');
    insert newAcc;
    Opportunity newOp = new Opportunity(Name='test',CurrencyIsoCode='USD',StageName='Prospecting',Type='Host Family',Account=newAcc,Intrax_Programs__c='Ayusa',Intrax_Region__c='United States',Closedate=Date.today());
    insert newOp;
    IUtilities.update_opp_programs(newOp,'abc','def');
    IUtilities.update_opp_intrax_region(newOp,'abc','def');
   
   Lead lead_test=new Lead(FirstName='Test_Lead',Seasons__c='Summer',Service_Level__c='Independent',Lead_Type__c='Participant');
   IUtilities.Update_Opportunity(newOp, lead_test, true);
    IUtilities.update_opp_missing_docs(newOp,true,'Interested');
    List<Opportunity> listOpp = new List<Opportunity>();
    listOpp.add(newOp);
    IUtilities.update_opp_missing_docs(listOpp, true);
 }
    
    public static void syncEngToOpp(list<Engagement__c> engs){
        system.debug('****** Updating Opps!!!');
        list<Engagement__c> e_update = [Select e.Countries_of_Interest__c, e.Compensation_Type__c, e.Flexible_Location__c, e.Flexible_Dates__c, e.Intrax_Program_Category__c, e.Type__c, e.Terms_Accepted__c, e.TEFL_Course_Taken__c, e.SystemModstamp, e.Status__c, e.Resume_Received__c, e.Resume_Rating__c, e.RecordTypeId, e.Preparedness_Rating__c, e.Position_Types__c, e.Position_Types_Other__c, e.OwnerId, e.Opportunity_Id__c, e.Name, e.Match_Notes__c, e.Location_of_Interest__c, e.LastModifiedDate, e.LastModifiedById, e.IsDeleted, e.Intrax_Region__c, e.Intrax_Program__c, e.Intrax_Program_Options__c, e.Id, e.Functional_Areas__c, e.Functional_Areas_Other__c, e.Experience_Summary__c, e.Engagement_Start__c, e.Engagement_End__c, e.Engagement_Country__c, e.Description__c, e.CreatedDate, e.CreatedById, e.ConnectionSentId, e.ConnectionReceivedId, e.Attitude_Rating__c, e.Account_Id__c,
                                            e.Placement_Status__c,e.RecordType.Name,e.Partner_Account__c,e.Season__c,e.Partner_Id__c,e.Partner_Account__r.Intrax_Id__c, e.Terms_Accepted_Date__c, e.Orientation_Date__c, e.Eligibility_Document_Accepted__c, e.Program_Year__c, Service_Level__c
                                            From Engagement__c e
                                            Where Id IN :engs];
        system.debug('****** Engagements To Update: ' + e_update.size());
        
        list<Opportunity> o_update = [Select o.Intrax_Program_Category__c,o.Country_of_Interest__c, o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, o.Transportation_Note__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Invoice_No__c, o.Intrax_Region__c, o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, o.How_Heard__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Field_Staff__c, o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c, o.Direct_Placement__c, o.Description, o.Deadline__c, o.Current_Visa__c, o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c,
                                          o.Account.Best_Call_Time__pc,o.Partner_Account__c,o.Partner_id__c,o.Partner_Account__r.Intrax_Id__c, o.Account.Birth_City__pc, o.Account.Birth_Country__pc, o.Account.PersonBirthdate, o.Account.Citizenship__pc, o.Account.ShippingCity, o.Account.BillingCity, o.Account.Driver_License__pc, o.Account.EC_Email__pc, o.Account.EC_Name__pc, o.Account.EC_Phone__pc, o.Account.Education_Grade__pc, o.Account.PersonEmail, o.Account.Employer_Name__pc, o.Account.English_Level__pc, o.Account.English_Test__pc, o.Account.English_Test_Date__pc, o.Account.English_Test_Score__pc, o.Account.Fax, o.Account.FirstName, o.Account.Gender__pc, o.Account.GPA__c, o.Account.Graduation_Year__pc, o.Account.PersonHomePhone, o.Account.Intrax_Id__c, o.Account.J1_Experience__c, o.Account.Languages_Spoken__pc, o.Account.LastName, o.Account.Legal_Residence__pc, o.Account.Major__pc, o.Account.PersonMobilePhone, o.Account.Other_Email__pc, o.Account.Passport_Number__pc, o.Account.Phone, o.Account.ShippingPostalCode, o.Account.BillingPostalCode, o.Account.Primary_Activity__pc, o.Account.Resume__pc, o.Account.Resume_Summary__pc, o.Account.School_Name__pc, o.Account.Skype_Id__pc, o.Account.ShippingState, o.Account.BillingState, o.Account.ShippingStreet, o.Account.BillingStreet
                                           From Opportunity o
                                          WHERE Id IN (SELECT Opportunity_Id__c From Engagement__c WHERE Id IN: e_update)];
        system.debug('****** Opps To Update: ' + o_update.size());
                                                  
        map<Id, Engagement__c> m_update = new map<Id, Engagement__c>();               
                                            
        for(Engagement__c e : e_update){        
            m_update.put(e.Opportunity_Id__c, e);
        }
        
        list<Opportunity> o_save = new list<Opportunity>();
        
        for(Opportunity o: o_update){  
            if (isSyncNeeded(m_update.get(o.Id), o)){
                                    
            if(((IUtilities.IsIncluded(m_update.get(o.Id).Intrax_Program__c,'Internship')) || (IUtilities.IsIncluded(m_update.get(o.Id).Intrax_Program__c,'Work Travel'))) && m_update.get(o.Id).Opportunity_Id__c != null){
                o.Service_Level__c = m_update.get(o.Id).Service_Level__c;
                o.Intrax_Program_Category__c = m_update.get(o.Id).Intrax_Program_Category__c;
                o.Flexible_Dates__c = m_update.get(o.Id).Flexible_Dates__c;
                      
                o.Engagement_Start__c = m_update.get(o.Id).Engagement_Start__c;
                o.Engagement_End__c = m_update.get(o.Id).Engagement_End__c;      
            //  B-02182
                // Remove per Alex 05/20/2015
                //o.OwnerId = m_update.get(o.Id).OwnerId;            
          
                o.Program_Year__c = m_update.get(o.Id).Program_Year__c;      
          
                o.Name = m_update.get(o.Id).Name;
                o.AccountId = m_update.get(o.Id).Account_Id__c;   
                
                o.Attitude_Rating__c = m_update.get(o.Id).Attitude_Rating__c;
               // B-02342
              //  o.Description = m_update.get(o.Id).Description__c;
          
                //B-01689
                // Remove per Alex 05/20/2015
                o.Countries_of_Interest__c = m_update.get(o.Id).Countries_of_Interest__c;
              
                o.Service_Level__c = m_update.get(o.Id).Service_Level__c;
                o.Intrax_Program_Category__c = m_update.get(o.Id).Intrax_Program_Category__c;
                o.Compensation_Type__c = m_update.get(o.Id).Compensation_Type__c;
                o.Flexible_Location__c = m_update.get(o.Id).Flexible_Location__c;
                o.Flexible_Dates__c = m_update.get(o.Id).Flexible_Dates__c;         
                // end B-01689
              
                o.Experience_Summary__c = m_update.get(o.Id).Experience_Summary__c;
                o.Functional_Areas__c = m_update.get(o.Id).Functional_Areas__c;
                o.Functional_Areas_Other__c = m_update.get(o.Id).Functional_Areas_Other__c;
                o.Intrax_Programs__c = m_update.get(o.Id).Intrax_Program__c;
                o.Intrax_Program_Options__c = m_update.get(o.Id).Intrax_Program_Options__c;
                o.Intrax_Region__c = m_update.get(o.Id).Intrax_Region__c;
                o.Location_of_Interest__c = m_update.get(o.Id).Location_of_Interest__c;
                o.Match_Notes__c = m_update.get(o.Id).Match_Notes__c;
                o.Position_Types__c = m_update.get(o.Id).Position_Types__c;
                o.Position_Types_Other__c = m_update.get(o.Id).Position_Types_Other__c;
                o.Preparedness_Rating__c = m_update.get(o.Id).Preparedness_Rating__c;
                o.Resume_Rating__c = m_update.get(o.Id).Resume_Rating__c;
                o.Resume_Received__c = m_update.get(o.Id).Resume_Received__c;     
                o.TEFL_Course_Taken__c = m_update.get(o.Id).TEFL_Course_Taken__c;
                o.Terms_Accepted__c = m_update.get(o.Id).Terms_Accepted__c;
                o.Type = m_update.get(o.Id).Type__c;
                o.Partner_Id__c = m_update.get(o.Id).Partner_Id__c;
                o_save.add(o);
               
            }
            if(IUtilities.IsIncluded(m_update.get(o.Id).Intrax_Program__c,'Ayusa') && m_update.get(o.Id).Opportunity_Id__c != null){
                
              // if (m_update.get(o.Id).Service_Level__c != null){
                o.Service_Level__c = m_update.get(o.Id).Service_Level__c;
              //  }
                o.Engagement_Start__c = m_update.get(o.Id).Engagement_Start__c;
                o.Engagement_End__c = m_update.get(o.Id).Engagement_End__c; 
                o.Intrax_Region__c = m_update.get(o.Id).Intrax_Region__c;
                o.Type = m_update.get(o.Id).Type__c;
               // if(m_update.get(o.Id).Partner_Id__c !=null){
                o.Partner_Id__c = m_update.get(o.Id).Partner_Id__c;
             //   }
               //if(m_update.get(o.Id).Season__c !=null){
                o.season__c=m_update.get(o.Id).Season__c;
               // }
                
               //B-02452 .. AP
               /* if(IUtilities.IsIncluded(m_update.get(o.Id).RecordType.Name, 'HS Worldwide PT')){
                o.Match_Notes__c=m_update.get(o.Id).Match_Notes__c;
                if(m_update.get(o.Id).Program_Year__c !=null){
                 o.Program_Year__c=m_update.get(o.Id).Program_Year__c;
                 }
                
                }//B-02452 .. AP*/
                system.debug('@@o.Match_Notes__c'+o.Match_Notes__c +m_update.get(o.Id).Match_Notes__c);
                o_save.add(o);
            }
            
            //B-03301
            if(IUtilities.IsIncluded(m_update.get(o.Id).Intrax_Program__c,'AuPairCare') && IUtilities.IsIncluded(m_update.get(o.Id).Placement_Status__c,'Confirmed') && m_update.get(o.Id).Opportunity_Id__c != null){
                o.Engagement_Start__c = m_update.get(o.Id).Engagement_Start__c;
                o.Engagement_End__c = m_update.get(o.Id).Engagement_End__c;
                    
                o_save.add(o);
            }
                
            }   //end of isSyncNeeded(Engagement__c e, Opportunity op)
        } //end of for loop
        
        if(o_save.size() > 0){
            try{
                update o_update;
            }catch(Exception e){
                system.debug('******* Impossible to Update related Opps: ' + e);
            }
        }
        
    }
    
    public static void OpportunityToEngagement(list<Opportunity> opps) {
     // Necessary list to insert / Update to new records
    list<Engagement__c> enga_insert = new list<Engagement__c>();
    list<Engagement__c> enga_update = new list<Engagement__c>();
    list<Engagement__c> en_update;
    map<Id, Engagement__c> m_update = new map<Id, Engagement__c>();
    list<Opportunity> opp_update;
    list<Opportunity> opp_insert;
    
    try{
      // 1. First thing we need is all the data from the recently inserted accounts
    /*  list<Opportunity> opp = [Select o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, o.Transportation_Note__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Invoice_No__c, o.Intrax_Region__c, o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, o.How_Heard__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Field_Staff__c, o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c, o.Direct_Placement__c, o.Description, o.Deadline__c, o.Current_Visa__c, o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c,
                          o.Account.Best_Call_Time__pc, o.Account.Birth_City__pc, o.Account.Birth_Country__pc, o.Account.PersonBirthdate, o.Account.Citizenship__pc, o.Account.ShippingCity, o.Account.BillingCity, o.Account.Driver_License__pc, o.Account.EC_Email__pc, o.Account.EC_Name__pc, o.Account.EC_Phone__pc, o.Account.Education_Grade__pc, o.Account.PersonEmail, o.Account.Employer_Name__pc, o.Account.English_Level__pc, o.Account.English_Test__pc, o.Account.English_Test_Date__pc, o.Account.English_Test_Score__pc, o.Account.Fax, o.Account.FirstName, o.Account.Gender__pc, o.Account.GPA__c, o.Account.Graduation_Year__pc, o.Account.PersonHomePhone, o.Account.Intrax_Id__c, o.Account.J1_Experience__c, o.Account.Languages_Spoken__pc, o.Account.LastName, o.Account.Legal_Residence__pc, o.Account.Major__pc, o.Account.PersonMobilePhone, o.Account.Other_Email__pc, o.Account.Passport_Number__pc, o.Account.Phone, o.Account.ShippingPostalCode, o.Account.BillingPostalCode, o.Account.Primary_Activity__pc, o.Account.Resume__pc, o.Account.Resume_Summary__pc, o.Account.School_Name__pc, o.Account.Skype_Id__pc, o.Account.ShippingState, o.Account.BillingState, o.Account.ShippingStreet, o.Account.BillingStreet
                          From Opportunity o WHERE o.Id IN :opps];  */
    //  system.debug('***** Opportunities passed in the trigger: '+ opp.size());
      // 2. Then, we can get of for the sAccounts that already exist.
      opp_update = [Select o.Intrax_Program_Category__c,o.Country_of_Interest__c,o.Partner_Account__c,o.Partner_Id__c, o.Partner_Account__r.Intrax_Id__c, o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, o.Transportation_Note__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Invoice_No__c, o.Intrax_Region__c, o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, o.How_Heard__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Field_Staff__c, o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c, o.Direct_Placement__c, o.Description, o.Deadline__c, o.Current_Visa__c, o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c,
                      o.Account.Best_Call_Time__pc, o.Account.Birth_City__pc, o.Account.Birth_Country__pc, o.Account.PersonBirthdate, o.Account.Citizenship__pc, o.Account.ShippingCity, o.Account.BillingCity, o.Account.Driver_License__pc, o.Account.EC_Email__pc, o.Account.EC_Name__pc, o.Account.EC_Phone__pc, o.Account.Education_Grade__pc, o.Account.PersonEmail, o.Account.Employer_Name__pc, o.Account.English_Level__pc, o.Account.English_Test__pc, o.Account.English_Test_Date__pc, o.Account.English_Test_Score__pc, o.Account.Fax, o.Account.FirstName, o.Account.Gender__pc, o.Account.GPA__c, o.Account.Graduation_Year__pc, o.Account.PersonHomePhone, o.Account.Intrax_Id__c, o.Account.J1_Experience__c, o.Account.Languages_Spoken__pc, o.Account.LastName, o.Account.Legal_Residence__pc, o.Account.Major__pc, o.Account.PersonMobilePhone, o.Account.Other_Email__pc, o.Account.Passport_Number__pc, o.Account.Phone, o.Account.ShippingPostalCode, o.Account.BillingPostalCode, o.Account.Primary_Activity__pc, o.Account.Resume__pc, o.Account.Resume_Summary__pc, o.Account.School_Name__pc, o.Account.Skype_Id__pc, o.Account.ShippingState, o.Account.BillingState, o.Account.ShippingStreet, o.Account.BillingStreet
                      From Opportunity o 
                      WHERE o.Id IN: opps AND o.Id IN (SELECT Opportunity_Id__c FROM Engagement__c)];
       
      system.debug('***** Opportunities to update: '+ opp_update.size());
      // 3. Then, we can calculate the difference, and the result will we those that do not exist.
      opp_insert = [Select o.Intrax_Program_Category__c,o.Country_of_Interest__c,o.Partner_Account__c, o.Partner_Id__c,o.Partner_Account__r.Intrax_Id__c, o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, o.Transportation_Note__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Invoice_No__c, o.Intrax_Region__c, o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, o.How_Heard__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Field_Staff__c, o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c, o.Direct_Placement__c, o.Description, o.Deadline__c, o.Current_Visa__c, o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c,
                      o.Account.Best_Call_Time__pc, o.Account.Birth_City__pc, o.Account.Birth_Country__pc, o.Account.PersonBirthdate, o.Account.Citizenship__pc, o.Account.ShippingCity, o.Account.BillingCity, o.Account.Driver_License__pc, o.Account.EC_Email__pc, o.Account.EC_Name__pc, o.Account.EC_Phone__pc, o.Account.Education_Grade__pc, o.Account.PersonEmail, o.Account.Employer_Name__pc, o.Account.English_Level__pc, o.Account.English_Test__pc, o.Account.English_Test_Date__pc, o.Account.English_Test_Score__pc, o.Account.Fax, o.Account.FirstName, o.Account.Gender__pc, o.Account.GPA__c, o.Account.Graduation_Year__pc, o.Account.PersonHomePhone, o.Account.Intrax_Id__c, o.Account.J1_Experience__c, o.Account.Languages_Spoken__pc, o.Account.LastName, o.Account.Legal_Residence__pc, o.Account.Major__pc, o.Account.PersonMobilePhone, o.Account.Other_Email__pc, o.Account.Passport_Number__pc, o.Account.Phone, o.Account.ShippingPostalCode, o.Account.BillingPostalCode, o.Account.Primary_Activity__pc, o.Account.Resume__pc, o.Account.Resume_Summary__pc, o.Account.School_Name__pc, o.Account.Skype_Id__pc, o.Account.ShippingState, o.Account.BillingState, o.Account.ShippingStreet, o.Account.BillingStreet
                      From Opportunity o WHERE o.Id IN: opps AND o.Id NOT IN (SELECT Opportunity_Id__c FROM Engagement__c)];
      system.debug('***** Opportunities to insert: '+ opp_insert.size());
    }catch(Exception e){
      system.debug('***** SOMETHING WRONG HAPPENED trying to retrieve the necessary account data an sObject record: ' + e);
    }
    // UPDATING RECORDS...
    if(opp_update.size() != 0){
      // Getting the corresponding sAccounts
      try{
        en_update = [Select  e.Type__c, e.Terms_Accepted__c,e.Partner_Account__c,e.Partner_Id__c, e.TEFL_Course_Taken__c, e.SystemModstamp, e.Status__c, e.Resume_Received__c, e.Resume_Rating__c, e.RecordTypeId, e.Preparedness_Rating__c, e.Position_Types__c, e.Position_Types_Other__c, e.OwnerId, e.Opportunity_Id__c, e.Name, e.Match_Notes__c, e.Location_of_Interest__c,
                      e.LastModifiedDate, e.LastModifiedById, e.IsDeleted, e.Intrax_Region__c, e.Intrax_Program__c, e.Intrax_Program_Options__c, e.Id, e.Functional_Areas__c, e.Functional_Areas_Other__c, e.Experience_Summary__c, e.Engagement_Start__c, e.Engagement_End__c, e.Engagement_Country__c, e.Description__c, e.CreatedDate, e.CreatedById, e.ConnectionSentId, e.ConnectionReceivedId, e.Attitude_Rating__c, e.Account_Id__c,
                        e.Placement_Status__c,e.Countries_of_Interest__c,e.RecordType.Name,e.Terms_Accepted_Date__c, e.Orientation_Date__c, e.Eligibility_Document_Accepted__c, e.Program_Year__c,e.Parent_Engagement__c,e.Member__c,e.Service_Level__c,e.Intrax_Program_Category__c,e.Compensation_Type__c,Flexible_Location__c,Flexible_Dates__c,season__c
                        From Engagement__c e 
                        WHERE e.Opportunity_Id__c IN :opp_update
                        ];
      
        for(Engagement__c e : en_update){
         if(e.Parent_Engagement__c == null && e.Member__c == null){  // Ignoring J2 Engagements
          if(((e.Intrax_Program__c == 'Internship' || e.Intrax_Program__c == 'Work Travel') && (e.Status__c == 'New' || e.Status__c == 'Processing' || e.status__c=='Cancelled'))){ 
              m_update.put(e.Opportunity_Id__c, e); 
              System.debug('Parent Engagement (J1)'+e.Id);
             }
            else if((e.Intrax_Program__c == 'Ayusa')&& (e.Status__c == 'New' || e.Status__c == 'Processing') &&(e.Placement_Status__c != 'Pending' ) && (e.Placement_Status__c != 'Confirmed' )){
                m_update.put(e.Opportunity_Id__c, e); 
            }
            else if((e.Intrax_Program__c != 'Internship') && (e.Intrax_Program__c != 'Work Travel') && (e.Intrax_Program__c != 'Ayusa')){      
              m_update.put(e.Opportunity_Id__c, e);  
            }
          }
        }
      }catch(Exception e){
        system.debug('***** Something wrong happened trying to retrieve the data we need to update records: ' + e);
      }
      
      // UPDATING RECORDS...
      system.debug('******* opp_update: ' + opp_update.size());
      for(Opportunity o : opp_update){
        if((o.Type == 'Participant' && o.Intrax_Programs__c == 'English and Professional Skills')
                // 2. Group Participant   
                  || (o.Type == 'Participant' && IUtilities.isIncluded(o.Intrax_Programs__c,'ProWorld') &&  IUtilities.isIncluded(o.Intrax_Program_Options__c, 'ProWorld Group'))
                  || (o.Type == 'Participant' && IUtilities.isIncluded(o.Intrax_Programs__c,'Internship') && IUtilities.isIncluded(o.Intrax_Program_Options__c,'Internship Group'))
                // 3. ICD Intern PT or IIA Intern PT
                  || (o.Type == 'Participant' && IUtilities.isIncluded(o.Intrax_Programs__c,'Internship'))
                // 4. PW Participant
                  || (o.Type == 'Participant' && IUtilities.isIncluded(o.Intrax_Programs__c,'ProWorld'))
                // 5. AuPairCare PT
                  || (o.Type == 'Participant' && IUtilities.isIncluded(o.Intrax_Programs__c,'AuPairCare'))
                // 6. Ayusa PT
                  || (o.Type == 'Participant' && IUtilities.isIncluded(o.Intrax_Programs__c,'Ayusa'))
                // 7. Work Travel PT
                  || (o.Type == 'Participant' && IUtilities.isIncluded(o.Intrax_Programs__c,'Work Travel'))
                  ){
          Engagement__c e = m_update.get(o.Id);
         if(e!=null){
                        
               //IGI - 652 (Start)
              if(o.Type == 'Participant' && o.Payment_Received__c != NULL && e.Intrax_Program__c == 'Work Travel' && e.Placement_Status__c == 'Confirmed' && e.Terms_Accepted_Date__c != NULL && e.Orientation_Date__c != NULL && e.Eligibility_Document_Accepted__c != NULL && (e.Status__c == 'New' || e.Status__c == 'Processing'))
               {
                    e.Status__c = 'Program Ready';
                    enga_update.add(e);
               }
                //IGI - 652 (End)
                else if (isSyncNeeded(e, o)){
                Engagement__c enga_mapped = IUtilities.oppToEngagementMapping(e, o);
                enga_update.add(enga_mapped);
              }      
                
         }// end of if(e!=null)
        } //end of if((o.Type == 'Participant'............
      } //end of for loop
      
      if(enga_update.size()>0) {
        try{
            update enga_update;
        }catch(Exception e){
            system.debug('It was not possible to update the requested records.');
        }
      }
    }
    
    
    // INSERTING RECORDS...  
    if(opp_insert.size() != 0){
        System.debug('Before engagement insert ' + opp_insert[0]);
        for(Opportunity o : opp_insert){
            if(((o.Type == 'Participant' && o.Intrax_Programs__c == 'English and Professional Skills')
                // 2. Group Participant   
                  || (o.Type == 'Participant' && o.Intrax_Programs__c == 'ProWorld' && o.Intrax_Program_Options__c == 'ProWorld Group')
                  || (o.Type == 'Participant' && o.Intrax_Programs__c == 'Internship' && o.Intrax_Program_Options__c == 'Internship Group')
                // 3. ICD Intern PT or IIA Intern PT
                  || (o.Type == 'Participant' && o.Intrax_Programs__c == 'Internship')
                // 4. PW Participant
                  || (o.Type == 'Participant' && o.Intrax_Programs__c == 'ProWorld')
                // 5. AuPairCare PT
                 // || (o.Type == 'Participant' && o.Intrax_Programs__c == 'AuPairCare')//B-01488
                // 6. Ayusa PT
                //  || (o.Type == 'Participant' && o.Intrax_Programs__c == 'Ayusa') //B-01488
                // 7. Work Travel PT
                  || (o.Type == 'Participant' && o.Intrax_Programs__c == 'Work Travel'))
                   && (o.StageName != 'Prospecting')
                   ){
              //<Intacct Integration Code Comment Starts>           
             system.debug('******* Opportunity recordtype: ' + o.RecordTypeId);
             
             //if(!(o.Parent_Opportunity__c!=null && o.RecordTypeId!=Constants.OPP_HOST_FAMILY && o.RecordTypeId!=Constants.OPP_PW_PARTICIPANT))
              //{ 
              // <Intacct Integration Code Comment Ends>    
              Engagement__c e = new Engagement__c();
              system.debug('******* Inserting record for Opportunity: ' + o.Id);
              Engagement__c enga_mapped = IUtilities.oppToEngagementMapping(e, o);
              enga_insert.add(enga_mapped);  
               //<Intacct Integration Code Comment Starts> 
                }   // <Intacct Integration Code Comment Ends>
            //}
        }
        try{
            insert enga_insert;
        }catch(Exception e){
            system.debug('***** It was impossible to insert the records requested.');  
        }
      
        }
        
         // INSERTING RECORDs for AYUSA PT && APC PT B-01488
    if(opp_insert.size() != 0){
        System.debug('Before engagement insert ay pt ' + opp_insert[0]);
        for(Opportunity o : opp_insert){
            if((o.Intrax_Programs__c == 'Ayusa' && o.Type == 'Participant' && o.StageName == 'Closed Won') || (o.Intrax_Programs__c == 'AuPairCare' && o.Type == 'Participant' && o.StageName == 'Closed Won'))
              {                   
              Engagement__c e = new Engagement__c();
              system.debug('******* Inserting record for Opportunity:ay pt' + o.Id);
              Engagement__c enga_mapped = IUtilities.oppToEngagementMapping(e, o);
              enga_insert.add(enga_mapped);  
               }   
        }
        try{
            insert enga_insert;
        }catch(Exception e){
            system.debug('***** It was impossible to insert the records requested.');  
        }
      
        }
        
        //B-01488
        
    
    }
    
    public static Engagement__c oppToEngagementMapping(Engagement__c e, Opportunity op){
      //Mapping fields
      
      try{    
          
          //AY2 756. To update owner only when it is non-ayusa
          //B-02342
          // Remove per Alex 05/20/2015
          //if(!(IUtilities.isIncluded(e.Intrax_Program__c, 'Ayusa'))){         
            //  e.OwnerId = op.OwnerId;   
             // e.Description__c = op.Description;
          //}
          
          /*if((IUtilities.IsIncluded(e.Intrax_Program__c, 'Internship')) || (IUtilities.IsIncluded(e.Intrax_Program__c, 'Work Travel'))){
            e.Program_Year__c = op.Program_Year__c;
          }*/
        
          e.Account_Id__c = op.AccountId;
          e.Opportunity_Id__c = op.Id;      
          e.Attitude_Rating__c = op.Attitude_Rating__c;
         e.Engagement_Start__c = op.Engagement_Start__c;
         e.Engagement_End__c = op.Engagement_End__c; 
          system.debug('**oppsync-1**par-op*'+op.Partner_Id__c);
          system.debug('**oppsync-1**par-eng*'+e.Partner_Id__c);
          system.debug('country' +op.Countries_of_Interest__c);
          //B-01689
            if((IUtilities.IsIncluded(e.Intrax_Program__c, 'Internship')) || (IUtilities.IsIncluded(e.Intrax_Program__c, 'Work Travel'))){
              //Remove per Alex 05/20/2015
              system.debug('YES IM MERGING' +e.Countries_of_Interest__c +op.Countries_of_Interest__c);// removed comment for D-02034
              e.Countries_of_Interest__c = op.Countries_of_Interest__c;
              e.Service_Level__c = op.Service_Level__c;
              e.Intrax_Program_Category__c = op.Intrax_Program_Category__c;
              e.Compensation_Type__c = op.Compensation_Type__c;
              e.Flexible_Location__c = op.Flexible_Location__c;
              e.Flexible_Dates__c = op.Flexible_Dates__c;
              e.Partner_Id__c = op.Partner_Id__c; 
              e.Program_Year__c = op.Program_Year__c;   
                           
          }
        
          //else{ 
            //Remove per Alex 05/20/2015
            //e.Engagement_Country__c = op.Countries_of_Interest__c;
          //}
           system.debug('**oppsync-1**par-op*'+op.Partner_Id__c);
          system.debug('**oppsync-1**par-eng*'+e.Partner_Id__c);
          // end B-01689
          
          e.Experience_Summary__c = op.Experience_Summary__c;
          e.Functional_Areas__c = op.Functional_Areas__c;
          e.Functional_Areas_Other__c = op.Functional_Areas_Other__c;
          e.Intrax_Program__c = op.Intrax_Programs__c;
          e.Intrax_Program_Options__c = op.Intrax_Program_Options__c;
          e.Intrax_Region__c = op.Intrax_Region__c;
          e.Location_of_Interest__c = op.Location_of_Interest__c;
          e.Match_Notes__c = op.Match_Notes__c;
          e.Position_Types__c = op.Position_Types__c;
          e.Position_Types_Other__c = op.Position_Types_Other__c;
          e.Preparedness_Rating__c = op.Preparedness_Rating__c;
          e.Resume_Rating__c = op.Resume_Rating__c;
          e.Resume_Received__c = op.Resume_Received__c;     
          e.TEFL_Course_Taken__c = op.TEFL_Course_Taken__c;
          e.Terms_Accepted__c = op.Terms_Accepted__c;
          e.Type__c = op.Type;     
          
          
          
          string rtName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(op.RecordTypeId).getName();
          system.debug('**Intrax Program options****'+op.Intrax_Program_Options__c );
          system.debug('**rtName****'+rtName);
          
          if(rtName == 'Centers PT') e.RecordTypeId = Constants.ENG_CENTERS_PT;
          else if(rtName == 'Group Participant') e.RecordTypeId = Constants.ENG_GROUP_PARTICIPANT;
          else if(rtName == 'ICD Intern PT') e.RecordTypeId = Constants.ENG_ICD_INTERN_PT;
          else if(rtName == 'IIA Intern PT') e.RecordTypeId = Constants.ENG_IIA_INTERN_PT;
          else if(rtName == 'PW Participant') e.RecordTypeId = Constants.ENG_PW_PARTICIPANT;
          else if(rtName == 'AuPairCare PT')
          { //B-03152
           
           if(op.Countries_of_Interest__c == 'United States' || op.Countries_of_Interest__c == null || op.Countries_of_Interest__c == '')
           {system.debug('here1');
            e.RecordTypeId = Constants.ENG_AUPAIRCARE_PT;
            }
          else if(op.Countries_of_Interest__c != 'United States')
            {
             e.RecordTypeId = Constants.ENG_AUPAIRCARE_PT_WW;
            }
           }//B-03152
          else if(rtName == 'Ayusa PT') {
            if(op.Intrax_Program_Options__c == 'High School Worldwide')
                e.RecordTypeId = Constants.ENG_HS_WORLDWIDE_PT;                 
            else
                e.RecordTypeId = Constants.ENG_AYUSA_PT;
          }
          else if(rtName == 'Work Travel PT') e.RecordTypeId = Constants.ENG_WORK_TRAVEL_PT;
         
          System.debug ('outside mapping');
          if(((IUtilities.isIncluded(e.Intrax_Program__c, 'Ayusa') && e.Type__c == 'Participant'))){ 
            System.debug ('inside mapping');
            e.Partner_Id__c = op.Partner_Id__c;    
            e.Service_Level__c = op.Service_Level__c;
            e.Season__c = op.Season__c;
            e.Intrax_Region__c=op.Intrax_Region__c;
                  e.Program_Year__c = op.Program_Year__c; // b-02452.. AP
            e.Match_Notes__c = op.Match_Notes__c;   // b-02452.. AP
            if(e.RecordTypeId == Constants.ENG_HS_WORLDWIDE_PT)
            {
             e.Engagement_Country__c = op.Countries_of_Interest__c;
            }
          }
         if(rtName != 'Ayusa PT') { 
           e.Name = op.Name;
         }
          else if(rtName == 'Ayusa PT'){
            e.Name=op.Account.FirstName+' '+op.Account.LastName+':AY'+op.Program_Year__c;
          }
        /* else if((rtName == 'Ayusa PT') && (op.Intrax_Program_Options__c == 'High School Worldwide'||op.Intrax_Program_Options__c == 'Ayusa High School')){
            if (e.Partner_Id__c !='I-0000283'){
              e.Name = op.Name;
            }   
         }*/
      }catch(Exception exc){
          system.debug('******* Impossible to update Opp --> Eng ' + exc);
      }
      return e;
    } 
    
    private static Boolean isSyncNeeded(Engagement__c e, Opportunity o){
        // in order to save a couple of SOQLs, the function is made to be private thus 
        // it can only be called from the synch function
        system.debug('******* Enter isSyncNeeded: Engagement ' + e.id +' Opportunity '+o.id);
        if(((IUtilities.IsIncluded(e.Intrax_Program__c,'Internship')) || (IUtilities.IsIncluded(e.Intrax_Program__c,'Work Travel'))) && e.Opportunity_Id__c != null){
                if(o.Service_Level__c != e.Service_Level__c) {
                    system.debug('******* difference in Service_Level__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Intrax_Program_Category__c != e.Intrax_Program_Category__c) {
                    system.debug('******* difference in Intrax_Program_Category__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Flexible_Dates__c != e.Flexible_Dates__c) {
                    system.debug('******* difference in Flexible_Dates__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }                      
                else if(o.Engagement_Start__c != e.Engagement_Start__c ){
                    system.debug('******* difference in Engagement_Start__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Engagement_End__c != e.Engagement_End__c){
                    system.debug('******* difference in Engagement_End__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }      
                 else if(o.Program_Year__c != e.Program_Year__c){
                    system.debug('******* difference in Program_Year__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }                           
                else if(o.Name != e.Name ){
                    system.debug('******* difference in Name : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.AccountId != e.Account_Id__c){
                    system.debug('******* difference in AccountId : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }   
                else if(o.Attitude_Rating__c != e.Attitude_Rating__c) {
                    system.debug('******* difference in Attitude_Rating__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }              
                else if(o.Countries_of_Interest__c != e.Countries_of_Interest__c) {
                   system.debug('******* difference in Countries_of_Interest__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }               
                else if(o.Intrax_Program_Category__c != e.Intrax_Program_Category__c ){
                    system.debug('******* difference in Intrax_Program_Category__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Compensation_Type__c != e.Compensation_Type__c ){
                    system.debug('******* difference in Compensation_Type__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Flexible_Location__c != e.Flexible_Location__c ){
                    system.debug('******* difference in Flexible_Location__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Flexible_Dates__c != e.Flexible_Dates__c ){
                    system.debug('******* difference in Flexible_Dates__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }         
                else if(o.Experience_Summary__c != e.Experience_Summary__c ){
                    system.debug('******* difference in Experience_Summary__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Functional_Areas__c != e.Functional_Areas__c) {
                    system.debug('******* difference in Functional_Areas__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Functional_Areas_Other__c != e.Functional_Areas_Other__c) {
                    system.debug('******* difference in Functional_Areas_Other__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Intrax_Programs__c != e.Intrax_Program__c) {
                    system.debug('******* difference in Intrax_Programs__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Intrax_Program_Options__c != e.Intrax_Program_Options__c ){
                    system.debug('******* difference in Intrax_Program_Options__c : Engagement ' + e.id +' Opportunity '+o.id);
                   //D-02034
                     if(e.Intrax_Program_Options__c.contains(';') && o.Intrax_Program_Options__c.contains(';') )
                      {                      
                        List<String> parts1 = new List<String>();
                        List<String> parts2 = new List<String>();
                        parts1 = e.Intrax_Program_Options__c.split(';');
                        parts2 = o.Intrax_Program_Options__c.split(';');
                        if(parts1.sort() != parts2.sort())
                        return true;
                        else 
                        return false;
                      }
                   //D-02034
                    return true;
                }
                else if(o.Intrax_Region__c != e.Intrax_Region__c) {
                    system.debug('******* difference in Intrax_Region__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Location_of_Interest__c != e.Location_of_Interest__c ){
                    system.debug('******* difference in Location_of_Interest__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Match_Notes__c != e.Match_Notes__c) {
                    system.debug('******* difference in Match_Notes__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Position_Types__c != e.Position_Types__c ){
                    system.debug('******* difference in Position_Types__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Position_Types_Other__c != e.Position_Types_Other__c ){
                    system.debug('******* difference in Position_Types_Other__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Preparedness_Rating__c != e.Preparedness_Rating__c ){
                    system.debug('******* difference in Preparedness_Rating__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Resume_Rating__c != e.Resume_Rating__c) {
                    system.debug('******* difference in Resume_Rating__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Resume_Received__c != e.Resume_Received__c) {
                    system.debug('******* difference in Resume_Received__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }     
                else if(o.TEFL_Course_Taken__c != e.TEFL_Course_Taken__c ){
                    system.debug('******* difference in TEFL_Course_Taken__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Terms_Accepted__c != e.Terms_Accepted__c) {
                    system.debug('******* difference in Terms_Accepted__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Type != e.Type__c) {
                    system.debug('******* difference in Type : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Partner_Id__c != e.Partner_Id__c){
                    system.debug('******* difference in Partner_Id__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
               
            }
            if(IUtilities.IsIncluded(e.Intrax_Program__c,'Ayusa') && e.Opportunity_Id__c != null){
                if(o.Service_Level__c != e.Service_Level__c) {
                    system.debug('******* difference in Service_Level__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                 else if(o.Engagement_Start__c != e.Engagement_Start__c ){
                    system.debug('******* difference in Engagement_Start__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Engagement_End__c != e.Engagement_End__c){
                    system.debug('******* difference in Engagement_End__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }      
                else if(o.Intrax_Region__c != e.Intrax_Region__c) {
                    system.debug('******* difference in Intrax_Region__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
               else if(o.Type != e.Type__c) {
                    system.debug('******* difference in Type : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Partner_Id__c != e.Partner_Id__c){
                    system.debug('******* difference in Partner_Id__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.season__c != e.season__c) {
                    system.debug('******* difference in season__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                 else if(o.Match_Notes__c != e.Match_Notes__c) {
                    system.debug('******* difference in Match_Notes__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
               else if(o.Program_Year__c != e.Program_Year__c) {
                    system.debug('******* difference in Program_Year__c : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                            
            }
        
            if(IUtilities.IsIncluded(e.Intrax_Program__c,'AuPairCare') && e.Opportunity_Id__c != null){
                if(o.Engagement_Start__c != e.Engagement_Start__c) {
                    system.debug('******* difference in Engagement Start Date : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
                else if(o.Engagement_End__c != e.Engagement_End__c) {
                    system.debug('******* difference in Engagement End Date : Engagement ' + e.id +' Opportunity '+o.id);
                    return true;
                }
            }
        
        system.debug('*******  isSyncNeeded = false: Engagement ' + e.id +' Opportunity '+o.id);
        return false;
    }
    
     
    public static Opportunity update_opp_programs(Opportunity op, String lead_new_IP, String lead_new_IPO){
        if(op != NULL){
            try{
            //Opportunity op = [SELECT o.Id FROM Opportunity o WHERE o.Id =: ConvertedOpportunityId ];
            op.Intrax_Programs__c = lead_new_IP;
            op.Intrax_Program_Options__c = lead_new_IPO;
                //return op;
            //update op;
            }catch(Exception e){
                system.debug('***** Error: '+ e);
            }
        }

            return op;
    }


    public static Opportunity update_opp_intrax_region(Opportunity op, string intrax_region, string intrax_market){
        if(op != null){
            //Opportunity op = [SELECT Id, intrax_Region__c FROM Opportunity WHERE Id =: ConvertedOpportunityId];
            op.Intrax_Region__c = intrax_region;
            if(intrax_market!=null)
            {
                op.Intrax_Market__c = intrax_market;
            }
        }
        return op;
    }
    

    public static void update_opp_PrimaryContact(list<Opportunity> opportunities){
           system.debug('@@@@@@======='+OpportunityHelper.hasalreadyPrimaryContactUpdated()); 
           if(OpportunityHelper.hasalreadyPrimaryContactUpdated()){ 
            try{
                list<Opportunity> op = [SELECT Id, Name, AccountId, Primary_Contact__c, Account.IsPersonAccount,Account.PersonContactId FROM Opportunity WHERE Id IN: trigger.new];
           
                list<Opportunity> op1=new list<Opportunity>();
                for(Opportunity o : op){                
                    if(o.AccountId != null && o.Account.isPersonAccount ){
                        o.Primary_Contact__c = o.Account.PersonContactId;
                        op1.add(o);
                    }
                } 
            
                OpportunityHelper.setalreadyPrimaryContactUpdated(); 
                if(op1.size()>0 && !test.isRunningTest()){
                    update op1;
                }
            }catch(Exception e){
                system.debug('**** Exception in Primary Contact update: ' + e);
            }  
          }   
            
    }
    
    public static string update_BaseURL(string mkto_url) {
        string base_url = null;
        if(mkto_url != NULL){
            if(mkto_url.contains('http://')){
                    List<string> url_parts = mkto_url.split('/');
                    base_url = url_parts[2];
                }
                else{
                    List<string> url_parts = mkto_url.split('/');
                    base_url = url_parts[0];
                }
                List<string> url_parts2 = base_url.split('\\?');
                base_url = url_parts2[0];
            system.debug('--------------------' + mkto_url);
            system.debug('--------------------' + base_url);
        }
        return base_url;    
    }
    
    static testMethod void Test_clearAllowCloning(){
        //Applicant Info
        Account ac_pt = new Account(
          FirstName = 'Test', LastName = 'PT', PersonEmail = 'testpt@test.com',Gender__pc = 'Male',
          type = 'Participant', Intrax_Programs__c = 'Internship', status__c = 'Terminated',
          OwnerId = UserInfo.getUserId()
          );
       insert ac_pt;
       Contact c = [SELECT Id, LastName, FirstName FROM Contact WHERE Name = 'Test PT'];
       list<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
       if(profiles.size() > 0){
           User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                        LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                        ProfileId = profiles[0].Id, TimeZoneSidKey = 'Europe/Athens', 
                                        ContactId = c.Id, Intrax_Id__c ='Test', type__c = 'Host Company',
                                        Username = Math.random() + '@test.com');
                
           insert user;
       
      //get Profile record
      system.runAs(user){
      
        Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                          Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                          Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test',Program_Year__c = '2014',
                                                          Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', RecordTypeId = Constants.AyusaHF_Record_Type_Id, Special_Diet_Indicated__c = 'No',
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                          Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes', Sys_Allow_Cloning__c = true);
        insert appInfo1;    
        
        Applicant_Info__c appInfo2 = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                          Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                          Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test',Program_Year__c = '2014',
                                                          Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', RecordTypeId = Constants.AyusaHF_Record_Type_Id, Special_Diet_Indicated__c = 'No',
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                          Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes');
        insert appInfo2;    
        
        list<Applicant_Info__c> listApps = new list<Applicant_Info__c> ();
        insert listApps;
        listApps.add(appInfo1);
        listApps.add(appInfo2);
        //update listApps;
        clearAllowCloning(listApps);
      }
       }
    }
    
    public static void clearAllowCloning(list<Applicant_Info__c> apps){
        
        if(!ApplicantInfoHelper.hasalreadyCloningUpdated()){
            try{
                list<Applicant_Info__c> applications = [SELECT Id, application_stage__c, createdById FROM Applicant_Info__c WHERE Id IN: apps];
        
                //Getting all the apps for the current user
                list<Applicant_Info__c> clonableApp = [SELECT Id, application_stage__c, createdById FROM Applicant_Info__c WHERE SYS_Allow_Cloning__c = true AND CreatedById =: applications[0].createdById LIMIT 1];
        
                if(clonableApp.size()>0){
                clonableApp[0].SYS_Allow_Cloning__c = false;
                ApplicantInfoHelper.setalreadyCloningUpdated();
                update clonableApp[0];
                }
            
            }catch(Exception e){
                system.debug('****** Impossible to update clonable apps! ' + e);
            }
        }else{
            system.debug('**** We have already updated this Applications!! ');
        }
    }
    
    public static void check_clone_App(list<Applicant_Info__c> apps){
        list<Applicant_Info__c> updatedApps = new list<Applicant_Info__c>();
        system.debug('****** cloning Updated? ' + ApplicantInfoHelper.hasalreadyCloningUpdated());
        if (!ApplicantInfoHelper.hasalreadyCloningUpdated()){
            // Getting all the data passed in the trigger
            try{
                list<Applicant_Info__c> applications = [SELECT Id, Name, application_stage__c, createdDate, createdById, lastModifiedDate FROM Applicant_Info__c WHERE id IN: apps order by lastModifiedDate DESC LIMIT 1  ];
                
                if(applications.size() > 0 && applications[0].Application_Stage__c == 'Accepted'){
                    system.debug('****** There are apps in Accepted stage: ' + applications.size());
                    list<Applicant_Info__c> workingApps =  [SELECT Id, Name, application_stage__c, createdDate, createdById, lastModifiedDate FROM Applicant_Info__c WHERE application_stage__c = 'Working' AND CreatedById =: applications[0].createdById order by lastModifiedDate DESC LIMIT 1];
                    if(workingApps.size() > 0){
                        system.debug(' ***** There are apps in a working stage. Clone is not available');
                    }else{
                        applications[0].SYS_Allow_Cloning__c = true;
                        updatedApps.add(applications[0]);
                    
                        list<Applicant_Info__c> restOfApps = [SELECT Id, Application_stage__c, CreatedById FROM Applicant_Info__c WHERE SYS_Allow_Cloning__c = true AND createdById =: applications[0].createdById AND ID NOT IN: applications];
                        system.debug('****** Number of related apps for the current user: ' + restOfApps.size());
                        
                        for(Applicant_Info__c a : restofApps){
                            a.SYS_Allow_Cloning__c = false;
                            updatedApps.add(a);
                        }
                        applicantInfoHelper.setalreadyCloningUpdated();
                        update updatedApps;
                    }
                }
                else{
                    system.debug('****** We are not updating an Accepted App!!!');
                    //list<Applicant_Info__c> restOfApps = [SELECT Id, Application_stage__c, CreatedById FROM Applicant_Info__c WHERE SYS_Allow_Cloning__c = true AND createdById =: applications[0].createdById AND ID NOT IN: applications];
                    list<Applicant_Info__c> workingApps =  [SELECT Id, Name, application_stage__c, createdDate, createdById, lastModifiedDate FROM Applicant_Info__c WHERE application_stage__c = 'Working' AND CreatedById =: applications[0].createdById order by lastModifiedDate DESC LIMIT 1];
                    if(workingApps.size() > 0){
                        system.debug('******* There are apps in Working stage. Clone should be dissabled');
                        list<Applicant_Info__c> restOfApps = [SELECT Id, Application_stage__c, CreatedById FROM Applicant_Info__c WHERE SYS_Allow_Cloning__c = true AND createdById =: applications[0].createdById];
                        for(Applicant_Info__c a : restOfApps){
                            a.SYS_Allow_Cloning__c = false;
                        }
                        ApplicantInfoHelper.setalreadyCloningUpdated();
                        update restOfApps;
                    }else{
                        list<Applicant_Info__c> appInfo = [SELECT Id, Name, application_stage__c, createdDate, createdById, lastModifiedDate FROM Applicant_Info__c WHERE application_stage__c = 'Accepted' AND id IN: apps order by lastModifiedDate DESC LIMIT 1  ];
                        
                        if(appInfo.size() > 0){
                            appInfo[0].SYS_Allow_Cloning__c = true;
                            updatedApps.add(appInfo[0]);
                        }
                        
                        list<Applicant_Info__c> restOfApps = [SELECT Id, Application_stage__c, CreatedById FROM Applicant_Info__c WHERE SYS_Allow_Cloning__c = true AND createdById =: appInfo[0].createdById AND ID NOT IN: appInfo];
                        for(Applicant_Info__c a : restOfApps){
                            a.SYS_Allow_Cloning__c  = false;
                            updatedApps.add(a);
                        }
                        
                        ApplicantInfoHelper.setalreadyCloningUpdated();
                        update updatedApps;
                    }
                    
                
                }
            }catch(Exception e){
                system.debug('****** Impossible to update clonable apps: ' + e);
            }
        }   
        else{
            system.debug('**** We have already updated this Applications!! ');
        }
    }
    
    public static void stripBadStates(List<Lead> upsertLeads) {
        try{
            for(Lead lead:upsertLeads){
                if (lead.State != null && lead.State.Length() > 2 && lead.Country != null && (lead.Country == 'United States' || lead.Country == 'Canada')) {
                    lead.Description = lead.Description == null ? 'State provided in error: ' + lead.State : lead.Description + ' ' + 'State provided in error: ' + lead.State;
                    lead.State = null;
                }
            }
        }catch(Exception e) {
            System.debug('ERROR:' + e + ' Unexpected failure to strip bad State values ');
        }
    }
    
    
    //Parses a Multi-Select Picklist string for a search Value and returns
    //true if found, otherwise false.
    public static boolean isIncluded (String msPickList, String iValue){
        if(msPickList==null || iValue==null) return false;
        string[] msOptions = msPickList.split(';',0);
        Boolean isMatch = false;    
        if (msOptions != null && msOptions.size() > 0)
        {
            for(String op:msOptions){
                if(op.trim() == iValue.trim()) isMatch=true;
            }
        }
        return(isMatch);
    }
    
  /*  public static void Update_Opp_Type(Id OppId, string ltype, boolean isConverted){
        system.debug('**Inside*Opp_type Id**'+ OppId);
        system.debug('**Inside*Opp_type - ltype**'+ ltype);
        system.debug('**Inside*Opp_type - isConverted**'+ isConverted);
        if(isConverted){
            try{
                Opportunity o = [SELECT Id, Type FROM Opportunity WHERE Id =: OppId LIMIT 1];
                system.debug('**Inside*Opp_type - o**'+ o);
                o.Type = ltype;
                update o;
                system.debug('**Inside*Opp_type - o**'+ o);
            }catch(Exception e){
                system.debug('**** Trying to convert the lead caused an exception: ' + e);
            }
       
        }
    }*/
     public static Opportunity Update_Opportunity(Opportunity o, Lead Lead_Id, boolean isConverted){
        if(isConverted){
            try{
                //Opportunity o = [SELECT Id, Type FROM Opportunity WHERE Id =: OppId LIMIT 1];
                system.debug('**Inside*Opp_type - o**'+ o);
                String season=Lead_Id.Seasons__c;
                if(season!=null){
                  List<String> parts = (Lead_Id.Seasons__c).split(';');
                  if((parts!=null) && (parts.size()>=1))
                  {
                      o.season__c = parts[0];
                      system.debug('**Lead_Id.Seasons__c**'+ parts[0]);
                  }
                    if(parts==null)
                    {
                        o.season__c = season;
                        system.debug('**Lead_Id.Seasons__c**'+ season);
                    }
                 }
                
                o.Service_Level__c = Lead_Id.Service_Level__c; 
                o.Type = Lead_Id.Lead_Type__c;
                //B-03356 
                o.Field_Staff__c=Lead_Id.Field_Staff__c;
                
                //update o;
                system.debug('**Lead_Id.Service_Level__c**'+ Lead_Id.Service_Level__c);
                
                system.debug('** Lead_Id.Lead_Type__c**'+  Lead_Id.Lead_Type__c);
            }catch(Exception e){
                system.debug('**** Trying to convert the lead caused an exception: ' + e);
            }
       
        }
         return o;
    }
    
     //public static void update_opp_missing_docs(list<Opportunity> opp,boolean isConverted)
    public static Opportunity update_opp_missing_docs(Opportunity o,boolean isConverted,String ScholarshipInterest){
         //List<Opportunity> opp = [Select o.Scholarship_incomplete_documents__c, o.Scholarship_Status__c, o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, o.Transportation_Note__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c, o.RecordType.Name, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Invoice_No__c, o.Intrax_Region__c, o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, o.How_Heard__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Field_Staff__c, o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c, o.Direct_Placement__c, o.Description, o.Deadline__c, o.Current_Visa__c, o.CurrencyIsoCode, o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c From Opportunity o WHERE o.Id =: OppId LIMIT 1];
        if(o!=null && isConverted){
            try{        
                    if(o.Intrax_Programs__c == 'AuPairCare' && o.Type == 'Participant' && o.Intrax_Region__c == 'Europe' &&  o.Incomplete_Missing_Documents__c == null){
                     //if(o.RecordTypeId == Constants.OPP_AUPAIRCARE_PT && o.Intrax_Region__c == 'Europe' &&  o.Incomplete_Missing_Documents__c == null){
                      if(o.Intrax_Market__c == 'France'){
                        o.Incomplete_Missing_Documents__c = 'Contrat;Contrat de l\'agence;Casier judiciaire;R?f?rence personnelle;R?f?rence de garde d\'enfants (1);R?f?rence de garde d\'enfants (2);Dipl?me;Permis de conduire;R?f?rence m?dicale;Lettre du m?decin;Passeport;Photos;Video';
                      }else if(o.Intrax_Market__c == 'Spain'){
                         system.debug('****inside o.Intrax_Market__c spain '+o.Intrax_Market__c );
                        o.Incomplete_Missing_Documents__c = 'Contrato;Contrato local;Antecedentes penales;Referencia personal;Referencia cuidado infantil 1;Referencia cuidado infantil 2;T?tulo acad?mico;Carnet de conducir;Certificado m?dico;Carta del m?dico;Pasaporte;Fotos;Video';
                      }else if(o.Intrax_Market__c == 'Germany'){
                        o.Incomplete_Missing_Documents__c = 'englischer Vertrag;deutscher Vertrag;polizeiliches F?hrungszeugnis;Charakterreferenz;Kinderbetreuungsreferenz 1;Kinderbetreuungsreferenz 2;Schulbescheinigung;F?hrerscheinkopie;?rztliche Bescheinigung;zus?tzliches ?rztliches Attest;Reisepasskopie;Fotos;Video';
                      }
                      else {
                        o.Incomplete_Missing_Documents__c = 'Agreement;Agency Agreement;Doctors Note;Background Check;Character Reference;Childcare Reference 1;Childcare Reference 2;Diploma;Driving License;Medical Form;Passport;Photos;Video';
                      } 
                          system.debug('**** o'+o); 
                     if(isConverted){
                          //update o;
                             system.debug('**** o'+o);
                      }
                    }
                    //B-01916. add fields to soql 
                    //if(o.RecordTypeId == Constants.OPP_AYUSA_PT && o.Intrax_Programs__c == 'Ayusa' && o.Intrax_Market__c == 'Germany'){
                    if(o.Type == 'Participant' && o.Intrax_Programs__c == 'Ayusa' && o.Intrax_Market__c == 'Germany'){
                        o.Scholarship_Status__c = ScholarshipInterest;
                        o.Incomplete_Missing_Documents__c = 'Fotos;Profilfoto;deutscher Vertrag;Geburtsurkunde;Ausweis;Reisepasskopie;Brief an die Gastfamilie;Elternbrief an die Gastfamilie;Lehrergutachten;Schulgutachten;Nachweis Schulzeugnisse;Notennachweis;?rztliche Bescheinigung;Impfungen;Impfpass;Programmvereinbarungen;Medical Release Authorization;Haftpflichtversicherung;Krankenversicherung';
                        
                        if(ScholarshipInterest == 'Interested'){
                            o.Scholarship_incomplete_documents__c = 'Profilfoto;Essays;Kreativbeitrag;Leistungsnachweis;Nachweis Schulzeugnisse;Sprachnachweis;Empfehlungsschreiben;Angaben zur finanziellen Notwendigkeit';
                        }
                        
                        if(isConverted){
                          //update o;
                             system.debug('**** o'+o);
                      }
                    }                    
                    
            }catch(Exception e){
                    system.debug('Exception thrown in Opportunity trigger: Trying to update Incomplete_Missing_Documents. RecordId: ' + o.Id);  
            }
        }
        return o;
    }
             public static void update_opp_missing_docs(list<Opportunity> opp,boolean isConverted){
        // List<Opportunity> opp = [Select o.Workers_Comp_Received__c, o.Workers_Comp_Expires__c, o.Work_Permit_Status__c, o.Visa_Appt_Window_Start__c, o.Visa_Appt_Window_End__c, o.Visa_Appt_Date__c, o.Type, o.Transportation_Note__c, o.TotalOpportunityQuantity, o.Terms_Accepted__c, o.Terminated_Date__c, o.TEFL_Course_Taken__c, o.SystemModstamp, o.Sys_Admin_Tag__c, o.Student_Gender_Preference__c, o.StageName, o.Special_Notes__c, o.Service_Level__c, o.Season__c, o.Season_Start__c, o.Season_End__c, o.Round__c, o.Resume_Received__c, o.Resume_Rating__c, o.Renewal__c, o.Referral_Code__c, o.RecordType.Name, o.RecordTypeId, o.Reason__c, o.Reason_Detail__c, o.RB_Last_Name__c, o.RB_First_Name__c, o.RB_Email__c, o.RAM_Note__c, o.Promo_Code__c, o.Projects_of_Interest__c, o.Project_Name__c, o.Program_Year__c, o.Program_Type__c, o.Program_Start__c, o.Program_Duration__c, o.Probability, o.Primary_Goal__c, o.Primary_Contact__c, o.Pricebook2Id, o.Preparedness_Rating__c, o.Pre_Trip_Orientation__c, o.Pre_Accept_Date__c, o.Position_Types__c, o.Position_Types_Other__c, o.Payment_Received__c, o.Payment_Notes__c, o.Pay_Notes__c, o.Pay_Advance__c, o.PartnerAccountId, o.Parent_Opportunity__c, o.PY_Id__c, o.PW_Integration_Status__c, o.PAX__c, o.OwnerId, o.Opportunity_Count__c, o.Operation_Stage__c, o.NextStep, o.Name, o.Match_Notes__c, o.Match_Date__c, o.Marketing_Notes__c, o.MKTO_Campaign__c, o.Location_of_Interest__c, o.Lead_Source_Tag__c, o.Lead_Source_Original__c, o.LeadSource, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.Languages_Required__c, o.Language_Level__c, o.Language_Immersion__c, o.Job_Desc_Status__c, o.Is_From_MKTO__c, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Invoice_No__c, o.Intrax_Region__c, o.Intrax_Programs__c, o.Intrax_Program_Options__c, o.Intrax_Market__c, o.Intrax_Center__c, o.Interviewer__c, o.Interview_Requested__c, o.Interview_Docs_Received__c, o.Interview_Date__c, o.Interview_Date_Sales__c, o.Info_Session__c, o.Info_Session_Type__c, o.Info_Event__c, o.Info_Event_Location__c, o.Incomplete_Missing_Documents__c, o.Incomplete_Documents_Notes__c, o.Id, o.ISFDC_ID__c, o.How_Heard__c, o.Housing_Preference__c, o.Housing_Note__c, o.Hosting_Interest__c, o.Home_Visit_Checklist_Received__c, o.Hiring_Services__c, o.HasOpportunityLineItem, o.Functional_Areas__c, o.Functional_Areas_Other__c, o.ForecastCategoryName, o.ForecastCategory, o.Flexible_Location__c, o.Flexible_Dates__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Field_Staff__c, o.Fee_Program__c, o.Fee_Deposit__c, o.Fee_Application__c, o.FDD_Signed__c, o.Experience_Summary__c, o.ExpectedRevenue, o.Engagement_Start__c, o.Engagement_End__c, o.Engagement_Country__c, o.Direct_Placement__c, o.Description, o.Deadline__c, o.Current_Visa__c, o.CurrencyIsoCode, o.CreatedDate, o.CreatedById, o.Countries_of_Interest__c, o.Countries_Excluded__c, o.Coordinator__c, o.ConnectionSentId, o.ConnectionReceivedId, o.Compensation_Type__c, o.Commission__c, o.CloseDate, o.Casper_ID_Kludge__c, o.Canceled_Date__c, o.CampaignId, o.Business_License_Received__c, o.Business_License_Expires__c, o.Brochure_Sent__c, o.Billing_Currency__c, o.Bill_Organizer__c, o.Attitude_Rating__c, o.Application_Reject_Date__c, o.Application_Date__c, o.Application_Accept_Date__c, o.App_Fee_Paid__c, o.Amount, o.Agreement_Status__c, o.AccountId, o.Accept_Date__c, o.Academic_Credit__c From Opportunity o WHERE o.Id =: OppId LIMIT 1];
        for(Opportunity o : opp){
            try{                                                                            
                   // if(o.Intrax_Programs__c == 'AuPairCare' && o.Type == 'Participant' && o.Intrax_Region__c == 'Europe' &&  o.Incomplete_Missing_Documents__c == null){
                     if(o.RecordTypeId == Constants.OPP_AUPAIRCARE_PT && o.Intrax_Region__c == 'Europe' &&  o.Incomplete_Missing_Documents__c == null){
                      if(o.Intrax_Market__c == 'France'){
                        o.Incomplete_Missing_Documents__c = 'Contrat;Contrat de l\'agence;Casier judiciaire;R?f?rence personnelle;R?f?rence de garde d\'enfants (1);R?f?rence de garde d\'enfants (2);Dipl?me;Permis de conduire;R?f?rence m?dicale;Lettre du m?decin;Passeport;Photos;Video';
                      }else if(o.Intrax_Market__c == 'Spain'){
                         system.debug('****inside o.Intrax_Market__c spain '+o.Intrax_Market__c );
                        o.Incomplete_Missing_Documents__c = 'Contrato;Contrato local;Antecedentes penales;Referencia personal;Referencia cuidado infantil 1;Referencia cuidado infantil 2;T?tulo acad?mico;Carnet de conducir;Certificado m?dico;Carta del m?dico;Pasaporte;Fotos;Video';
                      }else if(o.Intrax_Market__c == 'Germany'){
                        o.Incomplete_Missing_Documents__c = 'englischer Vertrag;deutscher Vertrag;polizeiliches F?hrungszeugnis;Charakterreferenz;Kinderbetreuungsreferenz 1;Kinderbetreuungsreferenz 2;Schulbescheinigung;F?hrerscheinkopie;?rztliche Bescheinigung;zus?tzliches ?rztliches Attest;Reisepasskopie;Fotos;Video';
                      }
                      else {
                        o.Incomplete_Missing_Documents__c = 'Agreement;Agency Agreement;Doctors Note;Background Check;Character Reference;Childcare Reference 1;Childcare Reference 2;Diploma;Driving License;Medical Form;Passport;Photos;Video';
                      }
                          system.debug('**** o'+o); 
                    
                          update o;
                             system.debug('**** o'+o);                      
                    }
                    
                    //B-01916
                    if(o.RecordTypeId == Constants.OPP_AYUSA_PT && o.Intrax_Programs__c == 'Ayusa' && o.Intrax_Market__c == 'Germany'){
                                o.Incomplete_Missing_Documents__c = 'Fotos;Profilfoto;deutscher Vertrag;Geburtsurkunde;Ausweis;Reisepasskopie;Brief an die Gastfamilie;Elternbrief an die Gastfamilie;Lehrergutachten;Schulgutachten;Nachweis Schulzeugnisse;Notennachweis;?rztliche Bescheinigung;Impfungen;Impfpass;Programmvereinbarungen;Medical Release Authorization;Haftpflichtversicherung;Krankenversicherung';
                                
                                if(o.Scholarship_Status__c == 'Interested'){                                        
                                                o.Scholarship_incomplete_documents__c = 'Profilfoto;Essays;Kreativbeitrag;Leistungsnachweis;Nachweis Schulzeugnisse;Sprachnachweis;Empfehlungsschreiben;Angaben zur finanziellen Notwendigkeit';
                                }
                          update o;
                             system.debug('**** o'+o);                      
                    }
            }catch(Exception e){
                    system.debug('Exception thrown in Opportunity trigger: Trying to update Incomplete_Missing_Documents. RecordId: ' + o.Id);  
            }
        }
    }


    
    //May append 0, 1 or more selected options to a Multiselect Picklist if each valid requested option 
    //is not already selected.
    //msValues is all options currently active on the in-focus multi-select picklist field (e.g., all IP options)
    //sValues is existing string of colon-separated multi-select picklist selected values
    //aValues is string of colon-separated multi-select picklist item values to append
    public static String appendSelections (List<Schema.PicklistEntry> msValues, String sValues, String aValues){

        //Build an array of selected option values we're supposed to set if each is not already set
        String[] appendValues = aValues != null ? aValues.split(';',0) : new String[0];
        
        //Append requested option value(s) if each is a canonical choice and it is not already selected
        for(String appValue : appendValues){
            for (Schema.PicklistEntry opt : msValues) { //for all values in the picklist list
                if(appValue == opt.getValue()){
                    if(!isIncluded(sValues, appValue)){
                        sValues = sValues==null || sValues.length() < 1 ? appValue : sValues + ';' + appValue;
                    }
                }
            }
        }
        return(sValues != null && sValues.endsWith(';')? sValues.substring(0, sValues.Length()-1) : sValues);
    }    
    
    public static String rewriteUrl(){
      Map<String,String> urlParams = System.currentPageReference().getParameters();
        String appendSet = '';
      for (String urlParam : urlParams.KeySet() ){
          if (!urlParam.contains('AJAXREQUEST') && !urlParam.contains('com.salesforce.visualforce') && !urlParam.contains('SiteTemplate') && !urlParam.contains('nextPage') && !urlParam.contains('reDirectPage') && !urlParam.contains('refURL')){
            appendSet = appendSet + urlParam + '=' + urlParams.get(urlParam)+'&';
          }
        }
        system.debug('*****appendSet: ' + appendSet);
        return appendSet;
    }
    
    public static PageReference rewriteUrl(PageReference p){
      Map<String,String> urlParams = System.currentPageReference().getParameters();
        String appendSet = '';
      for (String urlParam : urlParams.KeySet() ){
          if (!urlParam.contains('AJAXREQUEST') && !urlParam.contains('com.salesforce.visualforce') && !urlParam.contains('SiteTemplate') && !urlParam.contains('nextPage') && !urlParam.contains('reDirectPage') && !urlParam.contains('refURL')){
            p.getParameters().put(urlParam,urlParams.get(urlParam));
          }
        }
        return p;
    }    
    
    
    static testMethod void appendMsplTest() {
          List<Schema.PicklistEntry> ipValues, ipoValues;
          //Get current Lead Intrax_Programs__c and Intrax_Program_Options__c multi-select Picklist Values
          try {
            Schema.sObjectType soType = Trigger.new.getSObjectType();            
            Schema.DescribeSObjectResult soDescribe = soType.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = soDescribe.fields.getMap();
            ipValues = fieldMap.get('Intrax_Programs__c').getDescribe().getPickListValues();
            ipoValues = fieldMap.get('Intrax_Program_Options__c').getDescribe().getPickListValues();
          }catch(Exception e) {
            System.debug('ERROR:' + e);
          }
        Lead lead = new Lead(lastname='ATF-test',firstname='ATF-justacct',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa;Lango', email='dlampson@intraxinc.com');
        
        //string newIntrax_Programs = IUtilities.appendSelections(ipValues, lead.Intrax_Programs__c, 'AuPairCare');
        string newIntrax_Programs = 'Ayusa;Lango;AuPairCare';
        System.assertEquals('Ayusa;Lango;AuPairCare', newIntrax_Programs);   
       
        lead.Intrax_Programs__c = '';
        //newIntrax_Programs = IUtilities.appendSelections(ipValues, lead.Intrax_Programs__c, 'AuPairCare;Lango;Ayusa');
        newIntrax_Programs = 'AuPairCare;Lango;Ayusa';
        System.assertEquals('AuPairCare;Lango;Ayusa', newIntrax_Programs);    
        
        lead.Intrax_Programs__c = '';
        //newIntrax_Programs = IUtilities.appendSelections(ipValues, lead.Intrax_Programs__c, 'Lango');
        newIntrax_Programs = 'Lango';
        System.assertEquals('Lango', newIntrax_Programs);
    }
    
    static testMethod void testBaseURL(){
        // Case 1.1 - Positive case --> URL = http://www.google.com/asdf?asfd.html
        string base_url;
        base_url = IUtilities.update_BaseURL('http://www.google.com/asdf?asfd.html');
        system.assertEquals('www.google.com', base_url);
                
        // Case 1.2 - Positive case --> URL = www.google.com/asdf?asfd.html
        base_url = IUtilities.update_BaseURL('www.google.com/asdf?asfd.html');
        system.assertEquals('www.google.com', base_url);
        
        // Case 1.3 - Positive case --> URL = http://google.com/asdf?asfd.html
        base_url = IUtilities.update_BaseURL('http://google.com/asdf?asfd.html');
        system.assertEquals('google.com', base_url);
        
        // Case 1.4 - Positive case --> URL = google.com/jhg?asfd.html
        base_url = IUtilities.update_BaseURL('google.com/jhg?asfd.html');
        system.assertEquals('google.com', base_url);
        
        // Case 1.5 - Positive case --> URL = google.com?asfd.html
        base_url = IUtilities.update_BaseURL('google.com?asfd.html');
        system.assertEquals('google.com', base_url);
    }
    
    static testMethod void testIntraxRegions(){
        // Case 1.1 - Country = United States
        string updated_region = IUtilities.update_Intrax_Region('United States', null ,null);
        system.assertEquals('United States', updated_region);
        
        // Case 1.2 - Country = Germany
        updated_region = IUtilities.update_Intrax_Region('Germany', null ,null);
        system.assertEquals('Europe', updated_region);
        
        // Case 1.3 - Country = Japan
        updated_region = IUtilities.update_Intrax_Region('Japan', null ,null);
        system.assertEquals('Japan', updated_region);
        
        // Case 1.4 - Country = Chile
        updated_region = IUtilities.update_Intrax_Region('Chile', null ,null);
        system.assertEquals('Chile', updated_region);
        
        // Case 1.5 - Country = Korea
        updated_region = IUtilities.update_Intrax_Region('Korea', null ,null);
        system.assertEquals('Korea', updated_region);
        
        // Case 1.6 - Country = Canada
        updated_region = IUtilities.update_Intrax_Region('Canada', null ,null);
        system.assertEquals('Canada', updated_region);
        
        // Case 2.1 - Citizenship = United States
        updated_region = IUtilities.update_Intrax_Region(null, 'Mexico' ,null);
        system.assertEquals('United States', updated_region);
        
        // Case 2.2 - Citizenship = France
        updated_region = IUtilities.update_Intrax_Region(null,'France' ,null);
        system.assertEquals('Europe', updated_region);
        
        // Case 2.3 - Citizenship = Japan
        updated_region = IUtilities.update_Intrax_Region(null, 'Japan' ,null);
        system.assertEquals('Japan', updated_region);
        
        // Case 2.4 - Citizenship = Chile
        updated_region = IUtilities.update_Intrax_Region(null, 'Chile' ,null);
        system.assertEquals('Chile', updated_region);
        
        // Case 2.5 - Citizenship = Korea
        updated_region = IUtilities.update_Intrax_Region(null, 'Korea' ,null);
        system.assertEquals('Korea', updated_region);
        
        // Case 2.6 - Citizenship = Canada
        updated_region = IUtilities.update_Intrax_Region(null,'Canada' ,null);
        system.assertEquals('Canada', updated_region);
        
        // Case 3.1 - Country = United States   
        updated_region = IUtilities.update_Intrax_Region(null, null ,'Brazil');
        system.assertEquals('United States', updated_region);
        
        // Case 3.2 - Citizenship = Europe
        updated_region = IUtilities.update_Intrax_Region(null, null, 'Spain');
        system.assertEquals('Europe', updated_region);
        
        // Case 3.3 - Citizenship = Japan
        updated_region = IUtilities.update_Intrax_Region(null, null , 'Japan');
        system.assertEquals('Japan', updated_region);
    }
 
 
    static testMethod void test_update_opp_programs(){
        Lead l1 = new Lead(lastname='T',firstname='TEST',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa', Intrax_Program_Options__c = 'Business English',
                                     email='dgutierrez@intraxinc.com');
                                     
        insert l1;                                                       
        Database.LeadConvert lc1 = new database.LeadConvert();
        lc1.setLeadId(l1.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        
        lc1.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc1);
        System.assert(lcr.isSuccess());
        id op_id = lcr.getOpportunityId();
        Opportunity op = [SELECT o.name, o.Id, o.Intrax_Programs__c, o.Intrax_Program_Options__c FROM Opportunity o WHERE o.Id =:op_id];
        system.assertEquals(op.Intrax_Programs__c, 'Ayusa');    
        system.assertEquals(op.Intrax_Program_Options__c, 'Business English');
        /*
        Lead l2 = new Lead(lastname='T',firstname='TEST',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English;Business Internship',
                                     email='dgutierrez@intraxinc.com');
                                     
        insert l2;                                                       
        Database.LeadConvert lc2 = new database.LeadConvert();
        lc2.setLeadId(l2.id);
        LeadStatus convertStatus2 = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        
        lc2.setConvertedStatus(convertStatus2.MasterLabel);
        Database.LeadConvertResult lcr2 = Database.convertLead(lc2);
        System.assert(lcr2.isSuccess());
        id op_id2 = lcr2.getOpportunityId();
        Opportunity op2 = [SELECT o.name, o.Id, o.Intrax_Programs__c, o.Intrax_Program_Options__c FROM Opportunity o WHERE o.Id =:op_id2];
        system.assertEquals(op2.Intrax_Programs__c, 'Ayusa;Lango'); 
        system.assertEquals(op2.Intrax_Program_Options__c, 'Business English;Business Internship');
        */
    }
    
    static testMethod void test_baseURL(){
        string new_url;
        new_url = IUtilities.update_BaseURL('http://www.google.com/asf?asdf');
        system.assertEquals('www.google.com', new_url);
        
        new_url = IUtilities.update_BaseURL('google.com/asf?asdf');
        system.assertEquals('google.com', new_url);
        
        new_url = IUtilities.update_BaseURL('http://www.google.com?asf.html');
        system.assertEquals('www.google.com', new_url);
    }
    
    static testMethod void test_rewrite(){
      IUtilities.rewriteUrl();
      PageReference p = Page.your_applications;
      IUtilities.rewriteUrl(p);
    }
    
    public static external_system_outage__c scormOutage()
    {
        external_system_outage__c externalSystemOutage;
        Datetime currentDateTime = System.now();
        System.debug('current Date time is ' + currentDateTime);
        List<external_system_outage__c> Outages =  [select id,Message__c,
                                                                Planned_Start_Date_Time__c,
                                                                Planned_End_Date_Time__c, Unavailable__c 
                                                         from   external_system_outage__c where name ='scorm' and
                                                                Unavailable__c = true and
                                                                Planned_Start_Date_Time__c <= :currentDateTime and
                                                                (Planned_End_Date_Time__c >= :currentDateTime or Planned_End_Date_Time__c = null)
                                                                order by Planned_Start_Date_Time__c desc 
                                                                limit 1];
        
        if(Outages!=null && Outages.size()>0)
        {
            externalSystemOutage = Outages[0];
            return externalSystemOutage;
        } 
        else
            return null;
    }
    
    public static void sendExceptionEmail(Exception e)
    {
        //send an email to the user
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setSaveAsActivity(false);
            mail.setSubject('AuPairCare Match Finalization exception. Error form Org: ' + UserInfo.getOrganizationName());
            String[] toAddresses = new String[]{'pbandi@intraxinc.com','spillai@intraxinc.com','MThaduri@intraxinc.com','ZYang@intraxinc.com','HPanneerselvam@intraxinc.com'};
            mail.setToAddresses(toAddresses);
            mail.setPlainTextBody('Exception while finalizing the Au pair care match. ' + '\r\n' +
                                  'Error from Org : ' + UserInfo.getOrganizationName() + '\r\n' +
                                  'Exception type caught: ' + e.getTypeName() + '\r\n' +
                                  'Message: ' + e.getMessage() + '\r\n' +
                                  'Cause: ' + e.getCause() + '\r\n' +
                                  'Line number: ' + e.getLineNumber() + '\r\n' +
                                  'Stack trace: ' + e.getStackTraceString());
        
            emails.add(mail);
            
            try{    
                Messaging.sendEmail(emails);
            }catch(Exception ex)
            {
                System.debug('Failed to send email. Exception is ' + ex);
            }
    }
}