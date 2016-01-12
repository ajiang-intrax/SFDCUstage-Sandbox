global class AppTriggerHelper {
 /**
    * Description   :   This method checks if the status of position record is "Closed - Filled", then update the related opportunity OperationStage to Matched.
    * @args         :   List of positions
    * @return       :   void
    */
    // public Applicant_Info__c applicantInfo{get;set;}
    public static String testRes = '<documentDAO><authToken>'+Constants.serviceAuthToken+'</authToken><createdBy></createdBy><createdById></createdById><createDate></createDate><lastModifiedBy></lastModifiedBy><lastModifiedById></lastModifiedById><lastModifiedDate></lastModifiedDate><systemModstamp></systemModstamp><documentGUID></documentGUID><body></body><bodyLength></bodyLength><connectionReceived></connectionReceived><connectionReceivedId></connectionReceivedId><connectionSend></connectionSend><connectionSendId></connectionSendId><contentType></contentType><documentType></documentType><description></description><deleted></deleted><partnerShared></partnerShared><modifier></modifier><name></name><owner></owner><ownerId></ownerId><parent></parent><parentId></parentId><exists></exists><infoText></infoText><returnFieldList></returnFieldList><status></status><version></version><programId></programId><applicationId></applicationId><sfdcOrgId></sfdcOrgId><indexDocument>false</indexDocument></documentDAO>';
    public static Boolean isApexBeingTested = false;
       
     @Future(callout=true)
    public static void AutoPdfUpload(String appid,String appName,String doctype) {
        
        
        Set<Id> appIds = new Set<Id>();
        Applicant_Info__c applicantInfo;
        Intrax_Program_Upload__c documentnew = new Intrax_Program_Upload__c();
         String responseXML;
        string baseUrl;
        string partialUrl;
       
      
        PageReference Uploaddoc ;
        String contentType;
        try
         {
        System.debug('Rendering the document*doctype'+doctype);
       
        if(doctype=='Teacher')
        {
           partialUrl = '/ayusa_app_view_pdf_teacher_rec';
           baseUrl = Constants.derivedbaseUrl + partialUrl;
           if(!isApexBeingTested)
           Uploaddoc = new PageReference(baseUrl);        
        
        }
        if(doctype=='School')
        {
            System.debug('Rendering doctype==School*********'+doctype);
           partialUrl = '/ayusa_app_view_pdf_school_rec';
           baseUrl = Constants.derivedbaseUrl + partialUrl;
           System.debug('Rendering doctype==School baseUrl*********'+baseUrl);
           if(!isApexBeingTested)
           Uploaddoc = new PageReference(baseUrl); 
           System.debug('Rendering doctype==School Uploaddoc*********'+Uploaddoc);
            
        }     
         System.debug('Rendering doctype==School Uploaddoc*********'+Uploaddoc);
        Uploaddoc.getParameters().put('id',appid);
        System.debug('Rendering Uploaddoc*********'+Uploaddoc);
        Blob pdfBlob;
        try
        {
        pdfBlob = Uploaddoc.getContentAsPDF();    
        }
        catch(exception e)
        {pdfBlob=Blob.valueOf('');}
        
        Dom.Document doc = new Dom.Document();
    
        contentType = 'application/pdf';
    
        String docXML = '';
   
        docXML = '<documentDAO><authToken>'+Constants.serviceAuthToken+'</authToken><createdBy></createdBy><createdById></createdById><createDate></createDate><lastModifiedBy></lastModifiedBy><lastModifiedById></lastModifiedById><lastModifiedDate></lastModifiedDate><systemModstamp></systemModstamp><documentGUID></documentGUID><body></body><bodyLength></bodyLength><connectionReceived></connectionReceived><connectionReceivedId></connectionReceivedId><connectionSend></connectionSend><connectionSendId></connectionSendId><contentType></contentType><documentType></documentType><description></description><deleted></deleted><partnerShared></partnerShared><modifier></modifier><name></name><owner></owner><ownerId></ownerId><parent></parent><parentId></parentId><exists></exists><infoText></infoText><returnFieldList></returnFieldList><status></status><version></version><programId></programId><applicationId></applicationId><documentType></documentType><sfdcOrgId></sfdcOrgId><indexDocument>false</indexDocument></documentDAO>';

       system.debug('****docXML*******'+docXML);
       doc.load(docXML);
       List<dom.XmlNode> nodelist = doc.getRootElement().getChildElements();
       for (dom.XmlNode node : nodelist){
        if ( node.getName() == 'name'){
                node.addTextNode(doctype + '.pdf');
        }
        if ( node.getName() == 'body'){
                node.addTextNode(EncodingUtil.base64Encode(pdfBlob));
                system.debug('*****pdfcontent********'+EncodingUtil.base64Encode(pdfBlob));
        }
        if ( node.getName() == 'programId'){
                node.addTextNode('ayusa-pt');
        }
        if ( node.getName() == 'contentType'){
                node.addTextNode(contentType);
        }
       
        if ( node.getName() == 'applicationId'){
                node.addTextNode(appid);
        }
          if ( node.getName() == 'documentType'){
                node.addTextNode(doctype);
        }
           if ( node.getName() == 'description'){
                node.addTextNode('Auto Upload');
        }
        if ( node.getName() == 'sfdcorgid'){
                node.addTextNode(UserInfo.getOrganizationId());
        }
      }
      system.debug('****doc*******'+doc);
      system.debug('****docXML*******'+docXML);
       //Instantiate a new http object                 
          Http h = new Http();
          HttpResponse res = new HttpResponse();
                
            //Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
                
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');  
                req.setHeader('Accept', 'application/xml');
                req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                req.setHeader('Content-Type', 'application/xml');
                              

                String body = '';                 
                body = doc.toXmlString(); 
                
                system.debug('****body*******'+body);
                if (!isApexBeingTested)
                {
                req.setBody(body);  
                req.setEndpoint(Constants.documentService+'Create');
                documentnew.Document_service__c = 'DS';
             
                system.debug('****req*******'+req);
               
                //Send the request, and return a response 
                Dom.Document docRes = new Dom.Document();
              try
              {
                    res = h.send(req);
                    responseXML = res.getBody();                   
                    }
                    catch(Exception ex)
                    {
                    responseXML =testRes ;
                    }
              
                system.debug(' ****responseXML*******'+responseXML);
                docRes.load(responseXML);
                system.debug(' ****docRes*******'+docRes);
                List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
                for (dom.XmlNode node : resnodelist){
                    if ( node.getName() == 'result'){
                        documentnew.Document_GUID__c = node.getText();
                    }
                }
                }
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,responseXML));
               
                documentnew.Document_Name__c = doctype + '.pdf';
                documentnew.Applicant_Info__c = appid;
                documentnew.document_type__c = doctype;
                documentnew.Description__c ='Auto Upload';
                documentnew.Name = doctype + '.pdf';
                           
                System.debug('***********documentnew**********'+documentnew);
                upsert documentnew;
      } catch (DMLException e) {
        documentnew.addError('Error uploading file'+e.getMessage());
     // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e.getMessage() ));
     
      } finally {
     }
 
   // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
 
   
        
            
    }
    //<Intacct Integration Code Comment Starts> 
    
      
     
     
     public static Opportunity CreateAppOpp(Applicant_Info__c applicantObj,Id ParentOpportunity, String CurrencyCode, String ChildOppType) {
     system.debug('***CreateAppOpp applicantObj*** ParentOpportunity******'+applicantObj+'****'+ParentOpportunity);
             List<Opportunity > lChildCOpps=[Select id,StageName,Reason__c,Reason_Detail__c,ChildOppType__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                                                Engagement_End__c,Parent_Opportunity__c,RecordTypeID from Opportunity where Parent_Opportunity__c= :ParentOpportunity and ChildOppType__c=:ChildOppType];
               system.debug('***lChildCOpps****'+lChildCOpps);
                system.debug('***parent opp****'+ParentOpportunity);
                 system.debug('***ChildOppType type****'+ChildOppType);
               system.debug('@@ childoppsize @@' +lChildCOpps.size());
                
                //multiple child opportunities exists for only Match break and rematch. 
                if((lChildCOpps==null || lChildCOpps.size()==0) || 
                   (lChildCOpps!=null && lChildCOpps.size()>=0 && (ChildOppType =='Match Break' || ChildOppType =='Rematch')) 
                   )
                {
                system.debug('@@ inside childopppcheck @@');
                List<Account> ownerId = [select ownerId from Account where id = :applicantObj.Account__c];
                            List<User> activeOwner = [select Id from User where Id = :ownerId[0].ownerId and isActive = true];
                            Opportunity newOpp = new Opportunity();
                            system.debug('@@ Ownerid @@' +ownerId);
                            system.debug('@@ activeOwner @@' +activeOwner);
                            if (activeOwner.size()== 0){
                                //Get the default owner from Queue
                                List<OpportunityOwners__c> ownerMap = OpportunityOwners__c.getAll().values();
                                system.debug('@@ inside activeOwner @@');
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
                            newOpp.Intrax_Programs__c = applicantObj.Intrax_Program__c;
                            newOpp.Name = applicantObj.Name;
                            newOpp.ChildOppType__c= ChildOppType;
                            newOpp.CloseDate = date.today();
                           /* if(getflag(applicantObj.Application_Type__c,applicantObj.Intrax_Program__c, applicantObj.Type__c) != null){
                            newOpp.StageName='Closed Won';}
                            else
                            if (PromoCounter ==1)*/
                            //newOpp.StageName='Closed Won';
                            //else
                            newOpp.StageName='Prospecting';
                            newOpp.Intrax_Program_Options__c = applicantObj.Intrax_Program_Options__c;
                            newOpp.Type = applicantObj.Type__c;
                            //no need to appyly the record type here, the opporunity trigger will do it for us.
                            //newOpp.RecordTypeId=Constants.OPP_HOST_FAMILY;
                            newOpp.Intrax_Region__c = applicantObj.Intrax_Region__c;
                            newOpp.Country_of_Interest__c = applicantObj.Country_of_Interest__c;
                            newOpp.Intrax_Program_Category__c  = applicantObj.Intrax_Program_Category__c;
                            newOpp.Service_Level__c = applicantObj.Service_Level__c;
                            newOpp.AccountId = applicantObj.Account__c;
                            newOpp.Parent_Opportunity__c = ParentOpportunity; 
                            newOpp.Location_of_Interest__c = applicantObj.Location_of_Interest__c;
                            newOpp.CurrencyIsoCode = CurrencyCode;
                            newOpp.ChildOppType__c=ChildOppType;
                            //newOpp.Intacct_Entity__c = Constants.APC_Intacct_Entity_Id;

                            //B-02654 Jose 
                            if(applicantObj.CreatedBy__c != null){
                                newOpp.CreatedBy__c = applicantObj.CreatedBy__c;
                            }
                            insert newOpp;
                            system.debug('***CreateAppOpp newOpp*****'+newOpp);
                            system.debug('***new opportunity *****'+newOpp.ID + 'created by' + applicantObj.CreatedBy__c);
                           
                            return newOpp; 
                }
                else                                   
                    return null;                  
     }
      // TO CLOSE CHILD OPP
               
    public static void StageCloser(Applicant_Info__c appobj)
    { 
     List<Opportunity> lChildCOppsstatus = new List<Opportunity>();
     System.debug('** StageCloser application' + appobj + 'name ' + appobj.Opportunity_Name__c);
     lChildCOppsstatus =[Select id,StageName,Parent_Opportunity__c from Opportunity where Parent_Opportunity__c = :appobj.Opportunity_Name__c];
      system.debug('***CHILDOPPSTATUS****'+lChildCOppsstatus);  
      for (Opportunity opp: lChildCOppsstatus)
      {
       if (opp.StageName == 'Prospecting')
       {
        opp.StageName = 'Closed Won';
         system.debug('***CHILDOPPSTATUS****'+opp.StageName);
         update opp;
        }
      }
    }
     //B-02452.. AP
   /* public static void PgmYrAyusa(Applicant_Info__c appobj,String PgmYear){
    List<Opportunity> opp = new List<Opportunity>();
    opp =[Select id,Program_Year__c from Opportunity where ID = :appobj.Opportunity_Name__c];
    if (opp!= null && opp.size()>0){
     for(Opportunity o:opp){
      if (o.Program_Year__c == null){
       system.debug('@@ hii');
       }
      }
     }
    }  */               
    //B-02452.. AP
      public static void CreateAppOppProduct(String ProdName, Id oppId,List<PriceBookEntry> PriceBookList) 
      {
           system.debug('***CreateAppOppProduct****'+oppId);  
        if(PriceBookList!=null && PriceBookList.size()>0)
        {   
              system.debug('***PriceBookList****'+PriceBookList);  
            List<OpportunityLineItem> lstOppProducts = new List<OpportunityLineItem> ();
        
              if(ProdName == 'application_fee' && (lstOppProducts==null || lstOppProducts.size()==0)) 
              {                 
               for(PriceBookEntry pbe: PriceBookList)
                {
                    if(pbe.product2.Product_Keyword__c == 'application_fee'){                                       
                     OpportunityLineItem newOppProduct = new OpportunityLineItem();  
                     newOppProduct.PricebookEntryId = pbe.Id;
                     newOppProduct.Quantity = 1;  
                     newOppProduct.OpportunityId = oppId;  
                     newOppProduct.UnitPrice = pbe.UnitPrice;
                     newOppProduct.Due_Date__c = Date.today();
                     system.debug('@@ due date @@' +newOppProduct.Due_Date__c);
                     //newOppProduct.CurrencyIsoCode = pbe.CurrencyIsoCode;                
                     lstOppProducts.add(newOppProduct);
                    }
                                                      
              }
              }
               if(ProdName == 'Promo Code' && (lstOppProducts==null || lstOppProducts.size()==0)) 
              {                 
               for(PriceBookEntry pbe: PriceBookList)
                {
                     system.debug('@@ inside promo product creation');                
                     OpportunityLineItem newOppProduct = new OpportunityLineItem(); 
                            
                     newOppProduct.PricebookEntryId = pbe.Id;
                     system.debug('@@ PricebookEntryId'+newOppProduct.PricebookEntryId);       
                     newOppProduct.Quantity = 1; 
                     system.debug('@@ newOppProduct.Quantity'+newOppProduct.Quantity);       
                     newOppProduct.OpportunityId = oppId; 
                     system.debug('@@ newOppProduct.OpportunityId'+newOppProduct.OpportunityId);        
                     newOppProduct.UnitPrice = pbe.UnitPrice;
                     system.debug('@@ newOppProduct.UnitPrice'+newOppProduct.UnitPrice);       
                     newOppProduct.Due_Date__c = Date.today();
                     system.debug('@@ due date @@' +newOppProduct.Due_Date__c);
                     //newOppProduct.CurrencyIsoCode = pbe.CurrencyIsoCode;                
                     lstOppProducts.add(newOppProduct);
                                                      
              }
              }
              
              
              if(lstOppProducts!=null && lstOppProducts.size()>0)
              insert lstOppProducts; 
               system.debug('***lstOppProducts****'+lstOppProducts);           
        }        
      }
     //<Intacct Integration Code Comment Ends>   
     
     //APC HF Position Creation (Start)
     
     public static id CreateAppPos(Applicant_Info__c appObj)
     {
        try
        {
        if (appObj.Account__c != NULL)
        {
        system.debug('Enter to create Position');
        Position__c NewPos = new Position__c();
        NewPos.Name = appObj.Name;
        //NewPos.Arrival_Date_Time__c= appObj.Arriving_Time__c;
        //Added to get the same AD owner as Application
        NewPos.OwnerId = appObj.OwnerId;
        NewPos.Arrival_Date_Time__c= appObj.Engagement_Start__c;
        NewPos.Gender_Preference__c = appObj.Gender_Preference__c;
        NewPos.Host_Company_Id__c = appObj.Account__c;
        NewPos.Host_Opportunity_Id__c = appObj.Opportunity_Name__c;
        NewPos.Intrax_Program__c = appObj.Intrax_Program__c;
        NewPos.Intrax_Region__c = appObj.Intrax_Region__c;
        NewPos.Language_1_Desirability__c = appObj.Language_1__c;
        NewPos.Language_2_Desirability__c = appObj.Language_2__c;
        NewPos.Language_3_Desirability__c = appObj.Language_3__c;
        //NewPos.Nationality_Preferences__c = appObj.Nationality_Preferences__c;
        NewPos.Nationality_Preferences__c = appObj.Countries_of_Interest__c;
        NewPos.Pets__c = appObj.Pets_in_House__c;
        newPos.Pet_Types__c = appObj.Pet_Types__c;
        NewPos.Pets_Description__c = appObj.Pets_Description__c;
        NewPos.Postal_Code__c = appObj.Home_Postal_Code__c;
        NewPos.State__c = appObj.Home_State__c;
        NewPos.Street__c = appObj.Home_Street_1__c;
        NewPos.Street_2__c = appObj.Home_Street_2__c;
        NewPos.City__c = appObj.Home_City__c;
        NewPos.Country__c = appObj.Home_Country__c;
        NewPos.Driving_Preference_indicated__c = appObj.Driving_Preference_indicated__c;
        newPos.Interest_Fine_Arts__c = appObj.Interest_Fine_Arts__c;
        newPos.Interests_Hobbies__c = appObj.Interests_Hobbies__c;
        newPos.Interests_Leisure__c = appObj.Interests_Leisure__c;
        newPos.Interest_Sports__c = appObj.Interest_Sports__c;
        
        list<RecordType> HFPosRecType = [Select r.Name From RecordType r WHERE Sobjecttype='Position__c' AND DeveloperName='AuPairCare_HF'];
        
        if(HFPosRecType.size() > 0)
        {
            NewPos.RecordTypeId = HFPosRecType[0].id;
        }
        
        insert NewPos;
        
        //Add Member (Start)
        APCHFMemberSync(appObj);
        //Add Member (End)
        
        if(NewPos.id != NULL)
        {
            boolean spNeeded = false;
            boolean hasChildrenUnder2 = false;
            boolean SingleMother = true;
            boolean SingleFather = true;
            boolean SameSexParent = false;
            String comfortlist = '';
            string hostGender = '';
            
            list<Member__c> AllAppMembers = [SELECT Name,Account_Name__c, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c,
								                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c,
								                    Country_of_Residence__c, Other_Phone__c, Role_Other__c, Residency_Status__c, Title__c,
								                    Work_Supervisor__c, Employer_Name__c, Intrax_Program_Option__c,Background_Check_At__c, Background_Check_By__c, 
								                    Background_Check_Consent_Received__c, Background_Check_Id__c, Background_Check_Msg__c, Background_Check__c ,Special_Needs_Indicated__c, Age__c
								             FROM   Member__c
								             WHERE  Account_Name__c =: appObj.Account__c ];
           
           list<Person_Info__c> HostList = [SELECT Name, Gender__c FROM Person_Info__c WHERE Applicant_Info__c = :appObj.id AND Role__c = 'Host' AND Primary_Applicant__c = true];
           
           if (HostList != NULL && HostList.size() > 0)
           {
             hostGender = HostList[0].Gender__c;
           }
                    
            if (AllAppMembers != NULL && AllAppMembers.size()>0)
            {
                for(Member__c mem: AllAppMembers)
                {
                    if (mem.Role__c == 'Spouse or Partner' || mem.Role__c == 'Spouse')
                    {
                        SingleMother = false;
                        SingleFather = false;
                        
                        if (hostGender == mem.Gender__c)
                        {
                            SameSexParent = true;
                        }
                    }
                    
                    if(mem.Special_Needs_Indicated__c == 'Yes')
                    {
                        spNeeded = true;
                    }
                    if(mem.Age__c < 2) 
                    {
                        hasChildrenUnder2 = true;
                    }
                    
                    if(mem.Age__c <= 1)
                    {
                        comfortlist += '\'' + '0-12 months' + '\',';    
                    }
                    else if(mem.Age__c > 1 && mem.Age__c <= 2)
                    {
                        comfortlist += '\'' + '1-2 years' + '\',';  
                    }
                    else if(mem.Age__c > 2 && mem.Age__c <= 5)
                    {
                        comfortlist += '\'' + '2-5 years' + '\',';  
                    }
                    else if(mem.Age__c > 5 && mem.Age__c <= 10)
                    {
                        comfortlist += '\'' + '5-10 years' + '\','; 
                    }
                    else if(mem.Age__c > 10 && mem.Age__c <= 15)
                    {
                        comfortlist += '\'' + '10-15 years' + '\',';    
                    }
                    else if(mem.Age__c > 15 && mem.Age__c <= 18)
                    {
                        comfortlist += '\'' + '15-18 years' + '\',';    
                    }
                }
            }
            
            if (SingleMother == true && SingleFather == true)
            {
                if (hostGender == 'Male')
                {
                    SingleFather = true;
                    SingleMother = false;
                }
                else
                {
                    SingleFather = false;
                    SingleMother = true;
                }
            }
            
            String SOQLQuery;
            SOQLQuery = 'Select e.Position_Types__c, e.Engagement_Country__c, e.Personality_Independence__c ,e.Live_With_Smoker__c,e.Single_No_Children_Indicated__c, e.Intrax_Region__c, e.Status__c,e.Private_High_School_Indicated__c, e.Type__c, e.Opportunity_Id__r.StageName, e.Opportunity_Id__r.Id,'+
                        + 'e.Opportunity_Id__c,e.Tuition__c , e.Name,e.Service_Level__c, e.Location_of_Interest__c, e.Compensation_Type__c, e.Live_With_Pets__c, e.Intrax_Program__c, e.Interests_Top__c, e.Id, e.Functional_Areas__c,' +
                        + 'e.Engagement_Start__c, e.Engagement_End__c, e.Double_Placement_Indicated__c, e.CreatedById, e.Account_Id__r.Status__pc, e.Account_Id__r.School_Name__pc,' +
                        + ' e.Account_Id__r.English_Level__pc,e.Account_Id__r.age__pc, e.Account_Id__r.Citizenship__pc, e.Account_Id__r.Major__pc, e.Account_Id__r.Status__c, e.Account_Id__r.Type,'+
                        + 'e.Account_Id__r.Name,e.Placement_status__c, e.Account_Id__r.Id, e.Account_Id__r.Birth_Country__pc, e.Account_Id__c, e.Account_Id__r.isPersonAccount, Nationality__c, Gender__c, Drivers_Licence_Indicated__c, Age_At_Program_Start__c, Childcare_total_hours__c, In_Country__c, Infant_Specialized_Indicated__c' + 
                        + ', e.CreatedDate,e.Driving_Frequency__c'
                        + ' From Engagement__c e where ' +
                        + ' e.Intrax_Program__c  INCLUDES (' + '\'' + NewPos.Intrax_Program__c  + '\'' + ')' 
                        + ' AND e.Type__c = \'Participant\' ' +
                        + ' AND Placement_Status__c = \'Not Placed\' ' +
                        + ' AND ((Status__c = \'Processing\') ' +
                        + ' OR (Status__c = \'On Program\' AND Circulation_Start_Date__c <= today AND Circulation_End_Date__c >= today)) '+
                        + ' AND ((In_Country__c = \'Yes\' AND Latest_Match_Date__c >= today) OR (In_Country__c = \'No\') OR (In_Country__c = null)) ' +
                        + ' AND RecordTypeId = \'' + Constants.ENG_AUPAIRCARE_PT + '\' ' +
                        + ' AND ID IN (SELECT Engagement__c FROM Applicant_Info__c WHERE Application_Type__c != \'Extension\' AND Application_Level__c = \'Main\' AND (Application_Stage__c = \'Accepted\' OR Application_Stage__c = \'Submitted\' OR Application_Stage__c = \'In-Review\')) ';
                        
            system.debug('******** SOQLQuery-1:'+SOQLQuery);
            
            
            // Ended Early Criteria
            list<Match__c> listMatch = [Select Status__c, Position_Name__c, Engagement__c 
                                        From Match__c 
                                        Where Position_Name__c =: newPos.Id
                                        And (Status__c = 'Ended Early' OR Offer_Status__c = 'Offered')
                                        AND Intrax_Program__c = 'AuPairCare'];
        
	        String  idString = '(\'';
	        Integer countMatch = 0;
	        for(Match__c match : listMatch){      
	            system.debug('@@@@@matchEarlyEnded: ' + match);           
	            idString += match.Engagement__c + '\',\'';
	            countMatch++;        
	        }          
	                   
	        if(countMatch > 0){
	            idString = idString.substring(0,idString.length()-2); 
	            idString += ')';
	            idString = ' AND  Id NOT IN ' + idString;
	        }else{
	            idString = '';
	        }
	        
	        SOQLQuery += idString;
	        // END - Ended Early Criteria
                       
            if (SameSexParent == true){
                SOQLQuery = SOQLQuery + ' AND e.Same_Sex_Couple_Indicated__c = \'Yes\'';   
            }
            if (SingleMother == true){
                SOQLQuery = SOQLQuery + ' AND e.Single_Mother_Indicated__c = \'Yes\'';   
            }
            if (SingleFather == true){
                SOQLQuery = SOQLQuery + ' AND e.Single_Father_Indicated__c = \'Yes\'';   
            }
            
            if(appObj.Gender_Preference__c != null && appObj.Gender_Preference__c != 'No Preference'){
                string genderPref = appObj.Gender_Preference__c;
                SOQLQuery = SOQLQuery + ' AND e.Gender__c = \'' + genderPref + '\'';
            }
            
            if(appObj.Driving_Preference_indicated__c != null){                 
                if(appObj.Driving_Preference_indicated__c == 'Yes')
                    SOQLQuery = SOQLQuery + ' AND e.Drivers_Licence_Indicated__c = \'Yes\'';                                
             }
            
            if(appObj.Pets_in_House__c == 'Yes')
            {
            	if(appObj.Pet_Types__c != NULL)
            	{
            		list<String> pets = appObj.Pet_Types__c.split(';');         		
	         		String s_pets = '(';
	         		for(String s: pets){
	         			s_pets += '\'' + s + '\',';
	         		}
	         		s_pets = s_pets.substring(0,s_pets.length() -1);
	         		s_pets += ')';
	         		
	         		SOQLQuery += ' AND (e.Pets_Allergy_Indicated__c = \'No\' OR (e.Pets_Allergy_Indicated__c = \'Yes\' AND (e.Pet_Allergy_Types__c EXCLUDES ' + s_pets + ')))';
            	}
            	else
            	{
                	SOQLQuery += ' AND e.Pets_Allergy_Indicated__c = \'No\'';
            	}
            }
                       
            if(spNeeded != null && spNeeded == true){                
                SOQLquery += ' AND (e.Special_Needs_Circulated__c = \'Circulate SN\' OR e.Special_Needs_Circulated__c = \'Circulate Both\')';
            }else{
            	SOQLquery += ' AND (e.Special_Needs_Circulated__c = \'Circulate Standard\' OR e.Special_Needs_Circulated__c = \'Circulate Both\')';
            }
            
            if(hasChildrenUnder2 != null && hasChildrenUnder2 == true){
                SOQLQuery += ' AND e.Under_2_Circulated__c = true';
            }else{              
                SOQLQuery += ' AND (e.Under_2_Circulated__c = false AND e.Infant_Specialized_Circulated__c = false)'; 
                //SOQLQuery += ' AND e.Infant_Specialized_Circulated__c = false';            
            }
            
            if(comfortlist != NULL && comfortlist != '')
            {
                comfortlist = comfortlist.substring (0,comfortlist.length() -1);
                SOQLQuery = SOQLQuery + ' AND e.Children_Comfortable_Ages__c INCLUDES (' + comfortlist + ') ' ;
            }
            
            if(appObj.Aupair_Preferences__c != NULL && appObj.Aupair_Preferences__c == 'Nationality' && appObj.Countries_of_Interest__c != NULL)
            {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                list<string> selectNationality = appObj.Countries_of_Interest__c.split(';');
                len = selectNationality.size();
                for(String s : selectNationality) {
                  if(s.equals('Any Country'))
                     blnNoneExists = true;
                }
         
                if(!blnNoneExists){
                    for (String s: selectNationality){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring (0,slist.length() -1);
            
                    SOQLQuery = SOQLQuery + ' AND e.Account_Id__r.Birth_Country__pc IN (' + slist + ') ' ;
                    system.debug('SOQLQuery-Nationality::::::::::'+SOQLQuery);
                }   
            
            
            
                //string countriesInterest = appObj.Countries_of_Interest__c;
                //SOQLQuery = SOQLQuery + ' AND e.Nationality__c IN :countriesInterest' ;
                //system.debug('SOQLQuery-Nationality::::::::::'+SOQLQuery);
            }
            
            if(appObj.Aupair_Preferences__c != NULL && appObj.Aupair_Preferences__c == 'Language' && appObj.Language_Preferences__c != NULL)
            {
                String slist = '';
                boolean blnNoneExists=false;  
                integer len=0;
                list<string> selectLangs = appObj.Language_Preferences__c.split(';');
                len = selectLangs.size();
                for(String s : selectLangs) {
                  if(s.equals('Any language'))
                     blnNoneExists = true;
                }
         
                system.debug('selectLangs::::::::::'+appObj.Language_Preferences__c);
                system.debug('blnNoneExists::::::::::'+blnNoneExists);
            
                if(!blnNoneExists){
                    for (String s: selectLangs){
                        slist += '\'' + s + '\',';
                    }
                    
                    slist = slist.substring (0,slist.length() -1);
            
                    SOQLQuery = SOQLQuery + ' AND ( e.Primary_Language__c IN (' + slist + ') or e.Language_1__c IN (' + slist + ') or e.Language_2__c IN (' + slist + ') or e.Language_3__c IN (' + slist + ')) ' ;
                    System.debug('SOQLQuery-selectLangs::::::::::'+SOQLQuery);
                } 
                
                
                //string LanguagePref = appObj.Language_Preferences__c;
                //SOQLQuery = SOQLQuery + ' AND ( e.Primary_Language__c IN (' + appObj.Language_Preferences__c + ') or e.Language_1__c IN (' + appObj.Language_Preferences__c + ') or e.Language_2__c IN (' + appObj.Language_Preferences__c + ') or e.Language_3__c IN (' + appObj.Language_Preferences__c + ')) ' ;
                //SOQLQuery = SOQLQuery + ' AND ( e.Primary_Language__c IN :LanguagePref  or e.Language_1__c IN :LanguagePref  or e.Language_2__c IN :LanguagePref or e.Language_3__c IN :LanguagePref ) ' ;
                //System.debug('SOQLQuery-selectLangs::::::::::'+SOQLQuery);
            }
            
             SOQLQuery = SOQLQuery + ' AND Id NOT IN (SELECT Engagement__c FROM Selection__c WHERE Interview_End_Date__c >= today)';
             
             if(appObj.Aupair_Preferences__c != NULL && appObj.Aupair_Preferences__c == 'Nationality')
             {
                SOQLQuery = SOQLQuery + ' ORDER BY e.Account_Id__r.Birth_Country__pc DESC';
             }
             else if (appObj.Aupair_Preferences__c != NULL && appObj.Aupair_Preferences__c == 'Language')
             {
                SOQLQuery = SOQLQuery + ' ORDER BY e.Language_1__c DESC';
             }
             
             if (appObj.Aupair_Preferences__c != NULL)
             {
                SOQLQuery = SOQLQuery + ' , e.Childcare_Total_Hours__c DESC';
             }
             else
             {
                SOQLQuery = SOQLQuery + ' ORDER BY e.Childcare_Total_Hours__c DESC';
             }
             
             SOQLQuery = SOQLQuery + ' , e.CreatedDate DESC';
             SOQLQuery = SOQLQuery + ' , e.Driving_Frequency__c ASC';
             
             SOQLQuery = SOQLQuery + ' LIMIT 3';
             System.debug('SOQLQuery-Final::::::::::'+SOQLQuery);        
             list<Engagement__c> RecommendEngagements = Database.query(SOQLQuery);
             if(RecommendEngagements != NULL && RecommendEngagements.size()>0)
             {
                list<Selection__c> NewSelectionList = new list<Selection__c>();
                for (Engagement__c SingleEngg :RecommendEngagements)
                {
                    Selection__c newSelection = new Selection__c();
                    newSelection.Name = SingleEngg.Account_Id__r.Name;
                    newSelection.Engagement__c = SingleEngg.Id; 
                    newSelection.Position__c = NewPos.id;
                    newSelection.Intrax_Program__c = 'AuPairCare';
                    //newSelection.Status__c = 'Active'; 
                    newSelection.Recommendation_Type__c = 'System';
                    //newSelection.Favorite__c = true;
                    NewSelectionList.add(newSelection);
                }
                if(NewSelectionList != NULL && NewSelectionList.size()>0)
                {
                    insert NewSelectionList;
                }
             }
        }
        
        return NewPos.id;
        }
        else return null;
        }
        catch(Exception e)
        {
           system.debug('**** Error in saving Position');
           return null;
        }
     }
     
     public static boolean APCHFSyncNeeded(Applicant_Info__c oldApp, Applicant_Info__c newApp)
     {
        if(oldApp.Interest_Sports__c != newAPP.Interest_Sports__c || oldApp.Interests_Leisure__c != newApp.Interests_Leisure__c || oldApp.Interests_Hobbies__c != newApp.Interests_Hobbies__c || oldApp.Interest_Fine_Arts__c != newApp.Interest_Fine_Arts__c || oldApp.Engagement_Start__c != newApp.Engagement_Start__c || oldApp.Gender_Preference__c != newApp.Gender_Preference__c || oldApp.Language_1__c != newApp.Language_1__c || oldApp.Language_2__c != newApp.Language_2__c || oldApp.Language_3__c != newApp.Language_3__c || oldApp.Countries_of_Interest__c != newApp.Countries_of_Interest__c || oldApp.Pets_in_House__c != newApp.Pets_in_House__c || oldApp.Pet_Types__c != newApp.Pet_Types__c || oldApp.Pets_Description__c != newApp.Pets_Description__c || oldApp.Home_Postal_Code__c != newApp.Home_Postal_Code__c || oldApp.Home_State__c != newApp.Home_State__c || oldApp.Home_Street_1__c != newApp.Home_Street_1__c || oldApp.Home_Street_2__c != newApp.Home_Street_2__c || oldApp.Home_City__c != newApp.Home_City__c || oldApp.Home_Country__c != newApp.Home_Country__c || oldApp.Driving_Preference_indicated__c != newApp.Driving_Preference_indicated__c)
        {
            return true;
        }
        else return false;
     }
     
     public static void APCHFSync(Applicant_Info__c APCHFApp)
     {
        if(APCHFApp.Position__c != NULL)
        {
            Position__c UpdPos = [SELECT Interest_Sports__c, Interests_Leisure__c, Interests_Hobbies__c, Interest_Fine_Arts__c, Arrival_Date_Time__c, Gender_Preference__c, Language_1_Desirability__c, Language_2_Desirability__c, Language_3_Desirability__c, Nationality_Preferences__c,Pets__c, Pet_Types__c, Pets_Description__c, Postal_Code__c, State__c, Street__c, Street_2__c, City__c, Country__c, Driving_Preference_indicated__c  FROM Position__c WHERE ID = :APCHFApp.Position__c];
            
            UpdPos.Arrival_Date_Time__c= APCHFApp.Engagement_Start__c;
            UpdPos.Gender_Preference__c = APCHFApp.Gender_Preference__c;
            UpdPos.Language_1_Desirability__c = APCHFApp.Language_1__c;
            UpdPos.Language_2_Desirability__c = APCHFApp.Language_2__c;
            UpdPos.Language_3_Desirability__c = APCHFApp.Language_3__c;
            //UpdPos.Nationality_Preferences__c = APCHFApp.Nationality_Preferences__c;
            UpdPos.Nationality_Preferences__c = APCHFApp.Countries_of_Interest__c;
            UpdPos.Pets__c = APCHFApp.Pets_in_House__c;
            UpdPos.Pet_Types__c = APCHFApp.Pet_Types__c;
            UpdPos.Pets_Description__c = APCHFApp.Pets_Description__c;
            UpdPos.Postal_Code__c = APCHFApp.Home_Postal_Code__c;
            UpdPos.State__c = APCHFApp.Home_State__c;
            UpdPos.Street__c = APCHFApp.Home_Street_1__c;
            UpdPos.Street_2__c = APCHFApp.Home_Street_2__c;
            UpdPos.City__c = APCHFApp.Home_City__c;
            UpdPos.Country__c = APCHFApp.Home_Country__c;
            UpdPos.Driving_Preference_indicated__c = APCHFApp.Driving_Preference_indicated__c;
            UpdPos.Interest_Fine_Arts__c = APCHFApp.Interest_Fine_Arts__c;
            UpdPos.Interests_Hobbies__c = APCHFApp.Interests_Hobbies__c;
            UpdPos.Interests_Leisure__c = APCHFApp.Interests_Leisure__c;
            UpdPos.Interest_Sports__c = APCHFApp.Interest_Sports__c;
            
            update UpdPos;
        }
     } 
     
     public static void APCHFMemberSync(Applicant_Info__c APCHFMemberApp)
     {
        boolean isUpdate;
        list<Person_Info__c> personinfoSync = [SELECT Id,Applicant_Info__c, Name, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c,
                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c,
                    Country_of_Residence__c, Other_Phone__c, Role_Other__c, Reference_Request_Note__c, Title__c,
                    Residency_Status__c, Work_Supervisor__c, Employer_Name__c, Intrax_Program_Option__c, Background_Check_At__c, Background_Check_By__c, 
                    Background_Check_Consent_Received__c, Background_Check_Id__c, Background_Check_Msg__c, Background_Check__c, Special_Needs_Indicated__c  
                    from Person_Info__c 
                    where Applicant_Info__c =: APCHFMemberApp.Id  and (role__c in ('Parent','Spouse','Spouse or Partner','Child','Sibling','Other','Friend','Step Parent') or Emergency_Contact_Indicated__c =: 'Yes')];
        
        //get Member list for Family references and Emergency Contacts 
        
        list<Member__c> memberSync = [SELECT Name,Account_Name__c, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c,
                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c,
                    Country_of_Residence__c, Other_Phone__c, Role_Other__c, Residency_Status__c, Title__c,
                    Work_Supervisor__c, Employer_Name__c, Intrax_Program_Option__c,Background_Check_At__c, Background_Check_By__c, 
                    Background_Check_Consent_Received__c, Background_Check_Id__c, Background_Check_Msg__c, Background_Check__c , Special_Needs_Indicated__c
                    from Member__c
                    where Account_Name__c =: APCHFMemberApp.Account__c ];
        
        List<Member__c> newmemberlist = new List<Member__c>();
        if (personinfoSync != NULL && personinfoSync.size() > 0)
        {
        for(Person_Info__c p:personinfoSync){
            
            isUpdate = false;
                       
            Member__c memberNew = new Member__c();
            
            
            if (memberSync.size() > 0){
            
                for(Member__c m:memberSync){
                    
                //if (p.First_Name__c == m.First_Name__c && p.Last_Name__c == m.Last_Name__c && p.Date_Of_Birth__c == m.Date_Of_Birth__c){
                if (p.Name == m.Name && p.Date_Of_Birth__c == m.Date_Of_Birth__c){
                    
                    //updating an old member record                
                    system.debug('***** updating an old member record');
                    m.Role__c = p.Role__c;
                    m.Gender__c = p.Gender__c;
                    m.Email__c = p.Email__c;
                    m.Mobile__c = p.Mobile__c;
                    m.Phone__c = p.Phone__c;
                    m.Profession__c = p.Profession__c;
                    m.Emergency_Contact_Indicated__c = p.Emergency_Contact_Indicated__c;
                    m.Family_Member__c = p.Family_Member__c;
                    m.Country_of_Residence__c = p.Country_of_Residence__c;
                    m.Other_Phone__c = p.Other_Phone__c;
                    m.Role_Other__c = p.Role_Other__c;
                    m.Account_Name__c = APCHFMemberApp.Account__c;  
                    m.Residency_Status__c = p.Residency_Status__c;
                    m.Title__c = p.Title__c;
                    m.Employer_Name__c = p.Employer_Name__c;
                    m.Work_Supervisor__c = p.Work_Supervisor__c;
                    m.Intrax_Program_Option__c = p.Intrax_Program_Option__c;
                    m.Special_Needs_Indicated__c = p.Special_Needs_Indicated__c;            
                    newmemberlist.add(m);
                    isUpdate = true;
                    
                    }
                }
            
                if(isUpdate == false){
                
                //mapping a new member record            
                
                system.debug('***** 1 mapping a new member record');
                memberNew.Name = p.Name;
                memberNew.First_Name__c = p.First_Name__c;
                memberNew.Last_Name__c = p.Last_Name__c;
                memberNew.Date_Of_Birth__c = p.Date_Of_Birth__c;
                memberNew.Role__c = p.Role__c;
                memberNew.Gender__c = p.Gender__c;
                memberNew.Email__c = p.Email__c;
                memberNew.Mobile__c = p.Mobile__c;
                memberNew.Phone__c = p.Phone__c;
                memberNew.Profession__c = p.Profession__c;
                memberNew.Emergency_Contact_Indicated__c = p.Emergency_Contact_Indicated__c;
                memberNew.Family_Member__c = p.Family_Member__c;
                memberNew.Account_Name__c = APCHFMemberApp.Account__c;
                memberNew.Country_of_Residence__c = p.Country_of_Residence__c;
                memberNew.Other_Phone__c = p.Other_Phone__c;
                memberNew.Role_Other__c = p.Role_Other__c;
                memberNew.Residency_Status__c = p.Residency_Status__c;
                memberNew.Title__c = p.Title__c;
                memberNew.Employer_Name__c = p.Employer_Name__c;
                memberNew.Work_Supervisor__c = p.Work_Supervisor__c;
                memberNew.Intrax_Program_Option__c = p.Intrax_Program_Option__c;
                memberNew.Special_Needs_Indicated__c = p.Special_Needs_Indicated__c;  
                            
                newmemberlist.add(memberNew);           
                
                }
            
            }
            else
            {
                
                //mapping a new member record            
                
                system.debug('***** 2 mapping a new member record');
                
                memberNew.Name = p.Name;
                memberNew.First_Name__c = p.First_Name__c;
                memberNew.Last_Name__c = p.Last_Name__c;
                memberNew.Date_Of_Birth__c = p.Date_Of_Birth__c;
                memberNew.Role__c = p.Role__c;
                memberNew.Gender__c = p.Gender__c;
                memberNew.Email__c = p.Email__c;
                memberNew.Mobile__c = p.Mobile__c;
                memberNew.Phone__c = p.Phone__c;
                memberNew.Profession__c = p.Profession__c;
                memberNew.Emergency_Contact_Indicated__c = p.Emergency_Contact_Indicated__c;
                memberNew.Family_Member__c = p.Family_Member__c;
                memberNew.Account_Name__c = APCHFMemberApp.Account__c;
                memberNew.Country_of_Residence__c = p.Country_of_Residence__c;
                memberNew.Other_Phone__c = p.Other_Phone__c;
                memberNew.Role_Other__c = p.Role_Other__c;
                memberNew.Residency_Status__c = p.Residency_Status__c;
                memberNew.Title__c = p.Title__c;
                memberNew.Employer_Name__c = p.Employer_Name__c;
                memberNew.Work_Supervisor__c = p.Work_Supervisor__c;
                memberNew.Intrax_Program_Option__c = p.Intrax_Program_Option__c;
                memberNew.Special_Needs_Indicated__c = p.Special_Needs_Indicated__c; 
                newmemberlist.add(memberNew);
                                                    
            }
        } 
        }
        
        if (newmemberlist != NULL && newmemberlist.size() > 0)
        {
            upsert newmemberlist;
        }
        
        //Add Referenece Part (Start)
        List<Person_Info__c> personinfoRef = new List<Person_Info__c>();
        List<Reference__c> reference = new List<Reference__c>();
        List<Reference__c> newreference = new List<Reference__c>();
        List<Reference__c> referenceAux = new List<Reference__c>();
        Person_Info__c primaryApplicant = new Person_Info__c();
         
        primaryApplicant = [SELECT Id, Name from Person_Info__c where Applicant_Info__c =: APCHFMemberApp.Id  and Primary_Applicant__c  = true ];
        
        //getting APC HF Reference Record Type 
        list<RecordType> RClist = [select id, Name from RecordType where SobjectType='Reference__c' and Name='APC HF' Limit 1];
        
        //get Person_Info list for References 
        
        personinfoRef = [SELECT Name,Id,Applicant_Info__c, First_Name__c, Last_Name__c, Date_Of_Birth__c, Role__c, Gender__c, Reference_Language__c,
                    Email__c, Mobile__c, Phone__c,Profession__c, Emergency_Contact_Indicated__c, Family_Member__c, Reference_Request_Note__c, Reference_Contact_Requested__c
                    from Person_Info__c where Applicant_Info__c =: APCHFMemberApp.Id  and role__c  =: 'Reference'];
        
        //get Reference list for References 
                    
        reference = [SELECT Name,Id,First_Name__c, Last_Name__c, Primary_Applicant_Id__c, Reference_Requested__c, Email__c, Mobile__c, Position__c, Person_Info__c, Applicant_Info__c,
         			Reference_Request_Note__c, Reference_Url__c, Reference_Declined_Url__c, Reference_Contact_Requested__c, RecordTypeId, Intrax_Program__c, Type__c
                    from Reference__c where Position__c =: APCHFMemberApp.Position__c ];             
        
        for(Person_Info__c p:personinfoRef){
            
            isUpdate = false;
                       
            Reference__c referenceNew = new Reference__c();
            
            if (reference.size() > 0){
            
            	for(Reference__c r:reference){
	                if (p.First_Name__c == r.First_Name__c && p.Last_Name__c == r.Last_Name__c && p.Email__c == r.Email__c && r.Applicant_Info__c == APCHFMemberApp.Id){
	                
	                //updating an old member record                
	                system.debug('***** updating an old reference record');
	                r.Mobile__c = p.Mobile__c; 
	                r.Person_Info__c = p.Id;
	                r.Reference_Request_Note__c = p.Reference_Request_Note__c;
	                                                
	                referenceAux.add(r);
	                isUpdate = true;
	                
	                }
            	}
            
            	if(isUpdate == false){
            	
            	//mapping a new member record            
                
                system.debug('***** 1 mapping a new reference record');
                
                //primaryApplicant = [SELECT Id, Name from Person_Info__c where Applicant_Info__c =: appinfoID  and Primary_Applicant__c  = true ];
                
                referenceNew.Name = p.Name;
                referenceNew.First_Name__c = p.First_Name__c;
                referenceNew.Last_Name__c = p.Last_Name__c;
                referenceNew.Email__c = p.Email__c;
                referenceNew.Phone__c = p.Phone__c;
                referenceNew.Mobile__c = p.Mobile__c;
                referenceNew.Position__c = APCHFMemberApp.Position__c;
                referenceNew.Reference_Request_Note__c = p.Reference_Request_Note__c; 
                referenceNew.Reference_Requested__c = true;
                referenceNew.Constant_Reference_URL__c = Constants.derivedbaseUrl; 
                referenceNew.Intrax_Program__c = 'AuPairCare';
         		referenceNew.Reference_Status__c = 'Active' ;
        		referenceNew.Reference_Language__c = p.Reference_Language__c;
                referenceNew.Primary_Applicant_Id__c = primaryApplicant.Id;
                referenceNew.Intrax_Program__c = APCHFMemberApp.Intrax_Program__c;
                referenceNew.Applicant_Info__c = APCHFMemberApp.Id;
                referenceNew.Person_Info__c = p.Id;
                if(RClist != null && RClist.size()>0){
		        	referenceNew.RecordTypeId = RClist[0].Id ;
		        }
                newreference.add(referenceNew);          	
            	}
            
            }else{
                
             	//mapping a new member record            
                
                system.debug('***** 2 mapping a new reference record');
                
                referenceNew.Name = p.Name;
                referenceNew.First_Name__c = p.First_Name__c;
                referenceNew.Last_Name__c = p.Last_Name__c;
                referenceNew.Email__c = p.Email__c;
                referenceNew.Phone__c = p.Phone__c;
                referenceNew.Position__c = APCHFMemberApp.Position__c;
                referenceNew.Mobile__c = p.Mobile__c;
                referenceNew.Reference_Request_Note__c = p.Reference_Request_Note__c; 
                referenceNew.Reference_Requested__c = true;
                referenceNew.Constant_Reference_URL__c = Constants.derivedbaseUrl; 
                referenceNew.Intrax_Program__c = 'AuPairCare';
         		referenceNew.Reference_Status__c = 'Active' ;
        		referenceNew.Reference_Language__c = p.Reference_Language__c;
                referenceNew.Primary_Applicant_Id__c = primaryApplicant.Id;
                referenceNew.Intrax_Program__c = APCHFMemberApp.Intrax_Program__c;
                referenceNew.Applicant_Info__c = APCHFMemberApp.Id;
                referenceNew.Person_Info__c = p.Id;
                if(RClist != null && RClist.size()>0){
		        	referenceNew.RecordTypeId = RClist[0].Id ;
		        }
                
                newreference.add(referenceNew);
                                                    
            }
        }  
        
        try{
        
        	if (referenceAux.size()> 0){
        
        		update(referenceAux);
        		system.debug('*****update reference OK');
        
        	}
        
        }catch(Exception e){
        
        system.debug(e);
        
        }
        //insert new reference records; 
        
        try{
        
        	if (newreference.size()> 0){
        
        		insert(newreference);
        		
        		system.debug('*****insert reference OK');
        
        	}
        
        }catch(Exception e){
        
        system.debug(e);
        
        }
        
        //Add Referenece Part (End)            
           
     }
     
     public static void UpdPosProfile(Id updPosId)
     {
     	if(updPosId != NULL)
     	{
     		Position__c SelPos = [SELECT Name, Profile_Complete__c FROM Position__c WHERE Id =: updPosId];
     		if(SelPos.Profile_Complete__c != true)
     		{
     			SelPos.Profile_Complete__c = true;
     			update SelPos;
     		}
     	}
     }
     
     public static void UpdPosStatus(Id updPosId)
     {
     	if(updPosId != NULL)
     	{
     		Position__c SelPos = [SELECT Name, Profile_Complete__c, Status__c FROM Position__c WHERE Id =: updPosId];
     		if(SelPos.Status__c != 'Matching' && SelPos.Status__c != 'Closed - Filled')
     		{
     			SelPos.Status__c = 'Matching';
     			update SelPos;
     		}
     	}
     }
     
     
}