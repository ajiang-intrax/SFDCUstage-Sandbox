/*
Class: Callouts to enable BGC

Description: This class picks data from Applicant_Info__c and child Dependant_Info__c object and 
constructs an XML to call the Nemo REST interface to get the Background check done for applicants
and dependants. 

*/

public with sharing class BGCCallout {
//Set the variables needed

public String computedResponse {get; set;}
public String responseXML {get; set;}
public String responseId {get; set;}
public String xmlData {get; set;}
public String endPoint {get; set;}
public Integer errorCounter {get; set;}
public String appErrorMsg {get; set;}
public static Boolean isApexBeingTested = false;
public static String testRes = '<?xml version="1.0" encoding="UTF-8"?><BackgroundCheckResponse><BackgroundCheckId>77429</BackgroundCheckId><Result>Pass</Result><Errors/><Request><EntityId>00002</EntityId><EntityType>AYUSFDCFamily</EntityType><Token>0E15E28C-B3CD-C47F-45FACE98868A73E5</Token><LastName>tester fn</LastName><FirstName>tester ln</FirstName><MiddleInitial>E</MiddleInitial><SSN>123-45-6789</SSN><DOB>9/21/1968</DOB><Address><HouseNumber>10</HouseNumber><StreetName>test st</StreetName><City>test</City><State>CA</State><Zip>12345</Zip></Address></Request></BackgroundCheckResponse>';
public final Applicant_Info__c appInfo;
public sObject obj;
public Applicant_Info__c apInfo;
public final Member__c memberInfo;
public Account memAccInfo;
public Member__c memInfo;
public Person_Info__c personInfo;
public Person_Info__c persInfo;
public List<Person_Info__c> depPersonInfoLIST;  
 
public Id appInfoId;
 
  public BGCCallout(ApexPages.StandardController stdController)
  {
    endPoint = Constants.backGroundCheckUrl;
    if(stdController.getRecord().getsObjectType()==Applicant_Info__c.sObjectType)
     appInfo = (Applicant_Info__c)stdController.getRecord();
    else if (stdController.getRecord().getsObjectType()==Member__c.sObjectType)
     memberInfo = (Member__c)stdController.getRecord();
    
    system.debug('****appInfo*****'+appInfo);
    system.debug('****memberInfo*****'+memberInfo);
         
  }
    
  public PageReference saveResult(){    

        //Query applicant info
        apinfo = [select a.id,a.Home_Street_1__c,a.Home_city__c,a.Home_state__c, a.Home_postal_code__c
        from Applicant_Info__c a where a.id = :appInfo.Id];
        
        //Query person info for Primary applicant
        personInfo= [select p.id,p.Entity_Id__c,p.first_name__c,p.middle_name__c,
        p.last_name__c,p.essn__c,p.date_of_Birth__c,p.Background_Check__c 
        from Person_Info__c p where p.Applicant_Info__c = :apinfo.id and p.Primary_Applicant__c =: true];
        
        //Query person info for person associated with Primary applicant
        depPersonInfoLIST= [select p.id,p.Entity_Id__c,p.first_name__c,p.middle_name__c,
        p.last_name__c,p.essn__c,p.date_of_Birth__c,p.Background_Check__c 
        from Person_Info__c p where p.Applicant_Info__c = :apInfo.id and p.Primary_Applicant__c =: false and (p.Background_Check__c = null or (p.Background_Check__c = 'Errors' or p.Background_Check__c = 'System Error'))];
        
                
            
    try{
        
        errorCounter = 0;
        appErrorMsg = '';
        
        Dom.Document doc = new Dom.Document();
        List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
        
        if (personInfo.Background_Check__c == null || (personInfo.Background_Check__c == 'Errors' || personInfo.Background_Check__c == 'System Error')){
            // Load the standard template for BGC
            doc.load(Constants.BGCXMLTemplate);
            // Get the nodes in the template
            nodelist =  doc.getRootElement().getChildElements();
            // Infuse data from the SOQL query into nodelist
            for (dom.XmlNode node : nodelist){
                String objFieldName = Constants.BGCXMLNode2SObjField.get(node.getName());

                if ( node.getName() != 'Address'){
                    if (node.getName() != 'DOB' && objFieldName != null && objFieldName != ''){
                        if (personInfo.get(objFieldName)!= null){
                            String textval = (String)personInfo.get(objFieldName);
                            if (node.getName() == 'MiddleInitial')
                                node.addTextNode(textval.substring(0, 1));
                            else
                                node.addTextNode(textval);                              
                        }
                        else{
                            if (node.getName() != 'MiddleInitial'){
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                            }
                        }
                    }
                    else if (node.getName() == 'DOB'){
                        if (personInfo.Date_of_Birth__c != null){
                            node.addTextNode(personInfo.Date_of_Birth__c.format());
                        }
                        else{
                            errorCounter = errorCounter+1;
                            appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                        }
                    }
                        
                }
                
                else if ( node.getName() == 'Address'){
                    List<dom.XmlNode> childnodelist =  node.getChildElements();
                    for (dom.XmlNode childnode : childnodelist){
                        String objFieldNameChild = Constants.BGCXMLNode2SObjField.get(childnode.getName());

                        if (childnode.getName() != 'HouseNumber' && childnode.getName() != 'StreetName' && objFieldNameChild != null && objFieldNameChild != ''){
                            if(apInfo.get(objFieldNameChild) != null){
                                childnode.addTextNode((String)apInfo.get(objFieldNameChild));
                            }
                            else{
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  objFieldNameChild + ' cannot be blank;';
                            }
                        }
                        else if (childnode.getName() == 'HouseNumber'){
                            String street = (String)apInfo.get(objFieldNameChild);
                            String HouseNumber = '';
                            if (street == null){
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  'House number cannot be blank;';
                            }
                            else{
                                Pattern p = Pattern.compile('^[0-9]*'); 
                                Matcher hm = p.matcher(street);
                                while (hm.find()) {
                                    HouseNumber = HouseNumber + hm.group();
                                }
                                if (HouseNumber == '' ){
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  'Could not extract House number from street;'; 
                                }
                                else{
                                    childnode.addTextNode(HouseNumber);
                                }
                            }
                        }
                        else if (childnode.getName() == 'StreetName'){
                            String street = (String)apInfo.get(objFieldNameChild);                          
                            String streetName = '';
                            if (street == null){
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  'Street name cannot be blank;';
                            }
                            else{                           
                                Pattern sp = Pattern.compile(' .*');
                                Matcher sm = sp.matcher(street);        
                                while (sm.find()) {
                                    streetName = streetName + sm.group();
                                }
                                streetName = streetName.trim();                         
                                if (streetName == ''){
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  'Could not extract street name;';
                                }
                                else
                                    childnode.addTextNode(streetName);
                            }                                           
                        }
                    }
                }
            }
                
            xmlData = doc.toXmlString();
            if (errorCounter == 0)
            {
                getContent();
            }   
            else
                throw new applicationException(appErrorMsg);
            
            if (computedResponse.contains('Successful')){
                personInfo.Background_Check__c = 'Passed';  
        
            }
            else if (computedResponse.contains('Service Error')){
                personInfo.Background_Check__c = 'System Error';  
            }
            else{
                personInfo.Background_Check__c = 'Research';
            }
            personInfo.Background_Check_At__c = System.now();
            personInfo.Background_Check_By__c = UserInfo.getName();
            personInfo.Background_Check_Msg__c = computedResponse;
            personInfo.Background_Check_Id__c = responseId;
            personInfo.BGC_Notes__c = responseXML;
            //update personInfo;
            
        }
    
        if(depPersonInfoLIST.size()!=0)
        {
        for (Person_Info__c depPersonInfo : depPersonInfoLIST){
            try{
                xmlData = '';
                responseXML = '';
                computedResponse = '';
                responseId = '';
                errorCounter = 0;
                appErrorMsg = '';
                doc = new Dom.Document();
                // Load the standard template for BGC
                doc.load(Constants.BGCXMLTemplate);
                // Get the nodes in the template
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    String objFieldName = Constants.BGCXMLNode2SObjField.get(node.getName());

                    if ( node.getName() != 'Address'){
                        if (node.getName() != 'DOB' && objFieldName != null && objFieldName != ''){
                            if (depPersonInfo.get(objFieldName)!= null){
                                String textval = (String)depPersonInfo.get(objFieldName);
                                if (node.getName() == 'MiddleInitial')
                                    node.addTextNode(textval.substring(0, 1));
                                else
                                    node.addTextNode(textval);                              
                                
                            }
                            else{
                                if (node.getName() != 'MiddleInitial'){
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                }
                            }
                        }
                        else if (node.getName() == 'DOB'){
                            if (depPersonInfo.Date_of_Birth__c != null){
                                node.addTextNode(depPersonInfo.Date_of_Birth__c.format());
                            }
                            else{
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                            }
                        }
                    }
                    else if ( node.getName() == 'Address'){
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for (dom.XmlNode childnode : childnodelist){
                            String objFieldNameChild = Constants.BGCXMLNode2SObjField.get(childnode.getName());

                            if (childnode.getName() != 'HouseNumber' && childnode.getName() != 'StreetName' && objFieldNameChild != null && objFieldNameChild != ''){
                                if(apInfo.get(objFieldNameChild) != null){
                                    childnode.addTextNode((String)apInfo.get(objFieldNameChild));
                                }
                                else{
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  objFieldNameChild + ' cannot be blank;';   
                                }
                            }
                            else if (childnode.getName() == 'HouseNumber'){
                                String street = (String)apInfo.get(objFieldNameChild);
                                String HouseNumber = '';
                                if (street == null){
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  'House number cannot be blank;';
                                }       
                                else{                       
                                    Pattern p = Pattern.compile('^[0-9]*'); 
                                    Matcher sm = p.matcher(street);
                                    while (sm.find()) {
                                        HouseNumber = HouseNumber + sm.group();
                                    }
                                    if (HouseNumber == '' ){
                                        errorCounter = errorCounter+1;
                                        appErrorMsg = appErrorMsg +  'Could not extract House number from street;';
                                    }
                                    else
                                        childnode.addTextNode(HouseNumber);
                                }
                            }
                            else if (childnode.getName() == 'StreetName'){
                                String street = (String)apInfo.get(objFieldNameChild);                          
                                String streetName = '';
                                if (street == null){
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  'Street name cannot be blank;';
                                }
                                else{                               
                                    Pattern sp = Pattern.compile(' .*');
                                    Matcher sm = sp.matcher(street);        
                                    while (sm.find()) {
                                        streetName = streetName + sm.group();
                                    }
                                    streetName = streetName.trim();                         
                                    if (streetName == ''){
                                        errorCounter = errorCounter+1;
                                        appErrorMsg = appErrorMsg +  'Could not extract street name;';
                                    }
                                    else
                                        childnode.addTextNode(streetName);
                                }                                           
                            }                                                       
                        }
                    }
                }
                
                xmlData = doc.toXmlString();
                computedResponse = '';

                if (errorCounter == 0)
                    getContent();   
                else
                    throw new applicationException(appErrorMsg);                
                
                if (computedResponse.contains('Successful')){
                    depPersonInfo.Background_Check__c = 'Passed';   
                }
                else if (computedResponse.contains('Service Error')){
                    depPersonInfo.Background_Check__c = 'System Error';   
                }
                else{
                    depPersonInfo.Background_Check__c = 'Research'; 
                }
                depPersonInfo.Background_Check_At__c = System.now();
                depPersonInfo.Background_Check_By__c = UserInfo.getName();
                depPersonInfo.Background_Check_Msg__c = computedResponse;
                depPersonInfo.Background_Check_Id__c = responseId;              
                depPersonInfo.BGC_Notes__c = responseXML;
                
            }
            catch(ApplicationException ae){
            	depPersonInfo.Background_Check__c = 'Errors';
                depPersonInfo.Background_Check_Msg__c = 'Internal Error: '+ae.getMessage();
                depPersonInfo.Background_Check_At__c = System.now();
                depPersonInfo.Background_Check_By__c = UserInfo.getName();
            }
            catch(Exception e){
                depPersonInfo.Background_Check__c = 'System Error';
                depPersonInfo.Background_Check_Msg__c = 'System Error: '+e.getMessage();
                depPersonInfo.Background_Check_At__c = System.now();
                depPersonInfo.Background_Check_By__c = UserInfo.getName();
                                    
            }
        }
    }
    }
    catch(ApplicationException ae){
        personInfo.Background_Check__c = 'Errors';
        personInfo.Background_Check_Msg__c = 'Internal Error: '+ae.getMessage();
        personInfo.Background_Check_At__c = System.now();
        personInfo.Background_Check_By__c = UserInfo.getName();
    }
    catch(Exception e){
        personInfo.Background_Check__c = 'System Error';
        personInfo.Background_Check_Msg__c = 'System Error: '+e.getMessage();
        personInfo.Background_Check_At__c = System.now();
        personInfo.Background_Check_By__c = UserInfo.getName();
    }
    update personInfo;
    if (depPersonInfoLIST != null && depPersonInfoLIST.size() > 0)
        update depPersonInfoLIST;
    PageReference pageRef = new ApexPages.standardController(appInfo).View(); 
    pageRef.setRedirect(true);
    return pageRef; 
    
    
  }   
  public PageReference saveMemberBGCResult(){    

     memInfo =  [Select m.Role__c,m.ESSN__c,m.Street__c,m.State__c,m.Postal_Code__c,m.Residency_Status__c,m.Middle_Name__c,m.Date_of_Birth__c,m.EntityId__c, m.Name,m.Account_Name__r.PersonEmail,m.Account_Name__r.PersonMailingState,m.Account_Name__r.PersonMailingPostalCode, m.Account_Name__r.PersonMailingStreet,m.Account_Name__r.PersonMailingCity, m.Account_Name__c, m.Last_Name__c,m.email__c, m.Intrax_Program_Option__c, m.Id, m.First_Name__c, m.City__c, m.Background_Check__c, m.Background_Check_Required__c, m.Background_Check_Msg__c, m.Background_Check_Id__c, m.Background_Check_Consent_Received__c, m.Background_Check_By__c,m.BGC_Signed_Date__c, m.Background_Check_At__c, m.Age__c From Member__c m where m.Id = :memberInfo.Id];  
	 if(memInfo!=null)
	 memAccInfo = [select a.PersonEmail,a.PersonMailingState,a.PersonMailingPostalCode, a.PersonMailingStreet,a.PersonMailingCity, a.Id from account a where a.Id =:memInfo.Account_Name__c Limit 1];				
    try{
        
        errorCounter = 0;
        appErrorMsg = '';
        
        Dom.Document doc = new Dom.Document();
        List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
        system.debug('****nodelist*******'+nodelist);
        if ((memInfo.Background_Check__c == null || (memInfo.Background_Check__c == 'Errors' || memInfo.Background_Check__c == 'System Error')) && memInfo.BGC_Signed_Date__c !=null){
            // Load the standard template for BGC
            doc.load(Constants.BGCXMLTemplate);
            // Get the nodes in the template
            nodelist =  doc.getRootElement().getChildElements();
            // Infuse data from the SOQL query into nodelist
              system.debug('****nodelist*******'+nodelist);
            for (dom.XmlNode node : nodelist){
                String objFieldName = Constants.BGCXMLNodeMemberSObjField.get(node.getName());
 				 system.debug('****objFieldName*******'+objFieldName);
                if ( node.getName() != 'Address'){
                    if (node.getName() != 'DOB' && objFieldName != null && objFieldName != ''){
                        if (memInfo.get(objFieldName)!= null){
                            String textval = (String)memInfo.get(objFieldName);
                            if (node.getName() == 'MiddleInitial')
                                node.addTextNode(textval.substring(0, 1));
                            else
                                node.addTextNode(textval);                              
                        }
                        else{
                            if (node.getName() != 'MiddleInitial'){
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                            }
                        }
                    }
                    else if (node.getName() == 'DOB'){
                        if (memInfo.Date_of_Birth__c != null){
                            node.addTextNode(memInfo.Date_of_Birth__c.format());
                        }
                        else{
                            errorCounter = errorCounter+1;
                            appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                        }
                    }
                        
                }
                
                else if ( node.getName() == 'Address'){
                    List<dom.XmlNode> childnodelist =  node.getChildElements();
                    for (dom.XmlNode childnode : childnodelist){
                    	system.debug('*****childnode********'+childnode);
                        String objFieldNameChild = Constants.BGCXMLNodeMemberSObjField.get(childnode.getName());
							system.debug('*****objFieldNameChild********'+objFieldNameChild);
                        if (childnode.getName() != 'HouseNumber' && childnode.getName() != 'StreetName' && objFieldNameChild != null && objFieldNameChild != ''){
                            if(memAccInfo.get(objFieldNameChild) != null){
                                childnode.addTextNode((String)memAccInfo.get(objFieldNameChild));
                            }
                            else{
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  objFieldNameChild + ' cannot be blank;';
                            }
                        }
                        else if (childnode.getName() == 'HouseNumber'){
                            	system.debug('*****memAccInfo.get(objFieldNameChild)********'+memAccInfo.get(objFieldNameChild));
                            String street = (String)memAccInfo.get(objFieldNameChild);
                            
                            String HouseNumber = '';
                            if (street == null){
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  'House number cannot be blank;';
                            }
                            else{
                                Pattern p = Pattern.compile('^[0-9]*'); 
                                Matcher hm = p.matcher(street);
                                while (hm.find()) {
                                    HouseNumber = HouseNumber + hm.group();
                                }
                                if (HouseNumber == '' ){
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  'Could not extract House number from street;'; 
                                }
                                else{
                                    childnode.addTextNode(HouseNumber);
                                }
                            }
                        }
                        else if (childnode.getName() == 'StreetName'){
                            String street = (String)memAccInfo.get(objFieldNameChild);                          
                            String streetName = '';
                            if (street == null){
                                errorCounter = errorCounter+1;
                                appErrorMsg = appErrorMsg +  'Street name cannot be blank;';
                            }
                            else{                           
                                Pattern sp = Pattern.compile(' .*');
                                Matcher sm = sp.matcher(street);        
                                while (sm.find()) {
                                    streetName = streetName + sm.group();
                                }
                                streetName = streetName.trim();                         
                                if (streetName == ''){
                                    errorCounter = errorCounter+1;
                                    appErrorMsg = appErrorMsg +  'Could not extract street name;';
                                }
                                else
                                    childnode.addTextNode(streetName);
                            }                                           
                        }
                    }
                }
            }
                
            xmlData = doc.toXmlString();
            if (errorCounter == 0)
            {
                getContent();
            }   
            else
                throw new applicationException(appErrorMsg);
            
            if (computedResponse.contains('Successful')){
                memInfo.Background_Check__c = 'Passed';  
        
            }
            else if (computedResponse.contains('Service Error')){
                memInfo.Background_Check__c = 'System Error';  
            }
            else{
                memInfo.Background_Check__c = 'Research';
            }
            memInfo.Background_Check_At__c = System.now();
            memInfo.Background_Check_By__c = UserInfo.getName();
            memInfo.Background_Check_Msg__c = computedResponse;
            memInfo.Background_Check_Id__c = responseId;
            memInfo.BGC_Notes__c = responseXML;
            //update personInfo;
            
        }
           else if(memInfo.Age__c < 18 || memInfo.Residency_Status__c == 'Lives Elsewhere')
           {
           	memInfo.Background_Check__c = 'Errors';
            memInfo.Background_Check_At__c = System.now();
            memInfo.Background_Check_By__c = UserInfo.getName();
            memInfo.Background_Check_Msg__c = 'Internal Error: Member is not eligible for Background Check;';
            memInfo.Background_Check_Id__c = responseId;
            memInfo.BGC_Notes__c = responseXML;
           }
           else if(memInfo.BGC_Signed_Date__c==NULL)
           {
           	memInfo.Background_Check__c = 'Errors';
           	memInfo.Background_Check_At__c = System.now();
            memInfo.Background_Check_By__c = UserInfo.getName();
            memInfo.Background_Check_Msg__c = 'Internal Error: BGC Signed Date cannot be null;';
            memInfo.Background_Check_Id__c = responseId;
            memInfo.BGC_Notes__c = responseXML;
           }
                
            }
            catch(ApplicationException ae){
            	memInfo.Background_Check__c = 'Errors';
                memInfo.Background_Check_Msg__c = 'Internal Error: '+ae.getMessage();
                memInfo.Background_Check_At__c = System.now();
                memInfo.Background_Check_By__c = UserInfo.getName();
            }
            catch(Exception e){
                memInfo.Background_Check__c = 'System Error';
                memInfo.Background_Check_Msg__c = 'System Error: '+e.getMessage();
                memInfo.Background_Check_At__c = System.now();
                memInfo.Background_Check_By__c = UserInfo.getName();
                                    
            }      
    
    
   
    update memInfo;
    
    PageReference pageRef = new ApexPages.standardController(memInfo).View(); 
    pageRef.setRedirect(true);
    return pageRef; 
    
    
  }    
  
  public void getContent() {
    try{
    // Instantiate a new http object 
        
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');  
        String body = 'XmlRequestString='+xmlData;
    
        if (!Constants.enableBGCProd){
            body = body + '&testtype=validation';   
        }
        
        req.setBody(body);  
        req.setEndpoint(endPoint);
    // Send the request, and return a response 
        
        if (!isApexBeingTested){
            res = h.send(req);
            responseXML = res.getBody();
           
        }
        else{
            responseXML = testRes;
        }
        
        String stripSSN = '';
        Pattern p = Pattern.compile('<(s|S)(s|S)(n|N)>.*</(s|S)(s|S)(n|N)>');   
        Matcher sm = p.matcher(responseXML);
        while (sm.find()) {
            stripSSN = stripSSN + sm.group();
        }
        
        responseXML = responseXML.replaceAll(stripSSN, '<SSN>XXX-XX-XXX'+stripSSN.substring(stripSSN.length()-7));
        
        Dom.Document doc = new Dom.Document();
        if (!isApexBeingTested){
            doc = res.getBodyDocument();
            dom.XmlNode ResultNode =  doc.getRootElement().getChildElement('Result', null) ;
            computedResponse = '';
    
            if (ResultNode.getText() == 'Pass'){
                computedResponse = 'Verfication Successful';
            }
            dom.XmlNode ErrorNode =  doc.getRootElement().getChildElement('Errors', null) ;
            
            List<dom.Xmlnode> errors = ErrorNode.getChildElements();
            if (!errors.isEmpty()){
                computedResponse = 'Failed due to: ';
                for (dom.Xmlnode error : errors){
                computedResponse = computedResponse + error.getText();
                
                }
            }
            
            dom.XmlNode ResponseIdNode = doc.getRootElement().getChildElement('ResultId', null);
            responseId = ResponseIdNode.getText();          
        }
        else{
            computedResponse = 'Verfication Successful';
            responseId = '123';
        }
    }
    catch (Exception e){
        computedResponse = 'Service Error: '+e.getMessage()+e.getTypeName();
    }       
  }
  
static testmethod void testBGC(){
    Applicant_Info__c testapp = new Applicant_Info__c();
    Person_Info__c testpers = new Person_Info__c();
    Person_Info__c testdeppers = new Person_Info__c();
    testapp.Home_Street_1__c = '10 test st';
    testapp.Home_State__c = 'CA';
    testapp.Home_City__c = 'test';
    testapp.Home_Country__c = 'United States';
    testapp.Home_Postal_Code__c = '12345';
    testapp.Name ='Test Test';
    insert testapp;
    testpers.Applicant_Info__c = testapp.Id;
    testpers.First_Name__c = 'tester fn';
    testpers.Last_Name__c = 'tester ln';
    testpers.ESSN__c = '123-45-6789';
    testpers.Middle_Name__c = 'xmiddlename';
    testpers.Date_of_Birth__c = date.ValueOf('1968-09-21');
    testpers.Primary_Applicant__c = true;
    testapp.Street__c = '10 test st';
    testapp.State__c = 'CA';
    testapp.City__c = 'test';
    testapp.Country__c = 'United States';
    testapp.Postal_Code__c = '12345';
    testpers.Email__c = 'test@test.com';
    testpers.Background_Check__c = null;
    testpers.Primary_Applicant__c=true; 
    insert testpers;
    testdeppers.First_Name__c = 'tester dep fn';
    testdeppers.Last_Name__c = 'tester dep ln';
    testdeppers.ESSN__c = '123-45-6688';
    testdeppers.Middle_Name__c = 'ymiddlename';
    testdeppers.Date_of_Birth__c = date.ValueOf('1978-09-21');
    testdeppers.Background_Check__c = null;
    testdeppers.Applicant_Info__c = testapp.Id;
    testdeppers.Primary_Applicant__c=false; 
    insert testdeppers;
    ApexPages.StandardController sc = new ApexPages.StandardController(testapp);
    PageReference co = Page.BGCCallout;
    //PageReference p = new PageReference();
    BGCCallout.isApexBeingTested = true;
    BGCCallout bgc = new BGCCallout(sc);
    co=bgc.saveResult();
 
   
    System.assertNotEquals(bgc.appInfo,null);
    System.assertEquals(bgc.personInfo.Background_Check__c,'Passed');
    System.assertEquals(bgc.personInfo.Background_Check_Msg__c,'Verfication Successful');
    System.assert(bgc.personInfo.BGC_Notes__c.contains('<SSN>XXX-XX-XXX9</SSN>'));
    System.assert(bgc.xmlData.contains('<HouseNumber>10</HouseNumber>'));
    System.assert(bgc.xmlData.contains('<StreetName>test st</StreetName>'));
    
    List<Person_Info__c> depPersList = [select d.id,d.Background_Check_Msg__c,BGC_Notes__c from Person_Info__c d 
        where d.applicant_info__c = :testapp.Id and d.Primary_Applicant__c= :false];
    for (Person_Info__c dep : depPersList){
        System.assert(dep.Background_Check_Msg__c == 'Verfication Successful');
        System.assert(dep.BGC_Notes__c.contains('<SSN>XXX-XX-XXX9</SSN>'));
    }
  }    
  static testmethod void testMemberBGC(){
    Member__c testmem = new Member__c();
           
      Account testacc  = new Account(FirstName = 'Test', LastName = 'HF Account', Status__c = 'Prospect',
    											 	Type = 'Host Family',PersonMailingStreet = '10 test st',PersonMailingState = 'CA',
    											 	 PersonMailingCity = 'test',PersonMailingPostalCode = '12345',Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
    											 	Intrax_Region__c = 'United States', PersonEmail = 'test@test2.com');
                
      insert testacc;   
    /*testacc.Type = 'Host Family' ; 
    testacc.PersonMailingStreet = '10 test st';
    testacc.PersonMailingState = 'CA';
    testacc.PersonMailingCity = 'test';   
    testacc.PersonMailingPostalCode = '12345';   
    testacc.Name ='Test Test';
    insert testacc;*/
    testmem.Account_Name__c = testacc.Id;
    testmem.First_Name__c = 'tester fn';
    testmem.Last_Name__c = 'tester ln';
    testmem.ESSN__c = '123-45-6789';
    testmem.Middle_Name__c = 'xmiddlename';
    testmem.Date_of_Birth__c = date.ValueOf('1968-09-21');    
    testmem.Email__c = 'test@test.com';
    testmem.Background_Check__c = null;   
    testmem.BGC_Signed_Date__c =Date.today();  
    insert testmem;
    
    Member__c testmem1 = new Member__c();
    testmem1.Account_Name__c = testacc.Id;
    testmem1.First_Name__c = 'tester fn1';
    testmem1.Last_Name__c = 'tester ln1';
    testmem1.ESSN__c = '123-45-6789';
    testmem1.Middle_Name__c = 'xmiddlename1';
    testmem1.Date_of_Birth__c = date.ValueOf('1968-09-21');    
    testmem1.Email__c = 'test1@test.com';
    testmem1.Background_Check__c = null;  
    testmem1.Residency_Status__c ='Lives Elsewhere'; 
    testmem1.BGC_Signed_Date__c =Date.today();  
    insert testmem1;
   
    ApexPages.StandardController sc1 = new ApexPages.StandardController(testmem1);
    PageReference co1 = Page.BGCCallout;
    //PageReference p = new PageReference();
    BGCCallout.isApexBeingTested = true;
    BGCCallout bgc1 = new BGCCallout(sc1);
    co1=bgc1.saveMemberBGCResult();
 
    ApexPages.StandardController sc = new ApexPages.StandardController(testmem);
    PageReference co = Page.BGCCallout;
    //PageReference p = new PageReference();
    BGCCallout.isApexBeingTested = true;
    BGCCallout bgc = new BGCCallout(sc);
    co=bgc.saveMemberBGCResult();
  /*  System.assertNotEquals(bgc.appInfo,null);
    System.assertEquals(bgc.personInfo.Background_Check__c,'Passed');
    System.assertEquals(bgc.personInfo.Background_Check_Msg__c,'Verfication Successful');
    System.assert(bgc.personInfo.BGC_Notes__c.contains('<SSN>XXX-XX-XXX9</SSN>'));
    System.assert(bgc.xmlData.contains('<HouseNumber>10</HouseNumber>'));
    System.assert(bgc.xmlData.contains('<StreetName>test st</StreetName>'));
    
    List<Person_Info__c> depPersList = [select d.id,d.Background_Check_Msg__c,BGC_Notes__c from Person_Info__c d 
        where d.applicant_info__c = :testapp.Id and d.Primary_Applicant__c= :false];
    for (Person_Info__c dep : depPersList){
        System.assert(dep.Background_Check_Msg__c == 'Verfication Successful');
        System.assert(dep.BGC_Notes__c.contains('<SSN>XXX-XX-XXX9</SSN>'));
    }*/
  }  
  static testmethod void testBGC_fail(){
    Applicant_Info__c testapp = new Applicant_Info__c();
    Person_Info__c testpers = new Person_Info__c();
    Person_Info__c testdeppers = new Person_Info__c();
    /*testapp.Home_Street_1__c = '10 test st';
    testapp.Home_State__c = 'CA';
    testapp.Home_City__c = 'test';
    testapp.Home_Country__c = 'United States';
    testapp.Home_Postal_Code__c = '12345';
    testapp.Name ='Test Test';
    */
    insert testapp;
    testpers.Applicant_Info__c = testapp.Id;
    testpers.First_Name__c = 'tester fn';
    testpers.Last_Name__c = 'tester ln';
    testpers.ESSN__c = '123-45-6789';
    //testpers.Middle_Name__c = 'xmiddlename';
    testpers.Date_of_Birth__c = date.ValueOf('1968-09-21');
    testpers.Primary_Applicant__c = true;
    testapp.Street__c = '10 test st';
    testapp.State__c = 'CA';
    testapp.City__c = 'test';
    testapp.Country__c = 'United States';
    testapp.Postal_Code__c = '12345';
    testpers.Email__c = 'test@test.com';
    testpers.Background_Check__c = null;
    testpers.Primary_Applicant__c=true; 
    insert testpers;
    testdeppers.First_Name__c = 'tester dep fn';
    testdeppers.Last_Name__c = 'tester dep ln';
    testdeppers.ESSN__c = '123-45-6688';
    testdeppers.Middle_Name__c = 'ymiddlename';
    testdeppers.Date_of_Birth__c = date.ValueOf('1978-09-21');
    testdeppers.Background_Check__c = null;
    testdeppers.Applicant_Info__c = testapp.Id;
    testdeppers.Primary_Applicant__c=false; 
    insert testdeppers;
    ApexPages.StandardController sc = new ApexPages.StandardController(testapp);
    PageReference co = Page.BGCCallout;
    //PageReference p = new PageReference();
    BGCCallout.isApexBeingTested = true;
    BGCCallout bgc = new BGCCallout(sc);
    co=bgc.saveResult();
 
   
    System.assertNotEquals(bgc.appInfo,null);
    System.assertEquals(bgc.personInfo.Background_Check__c,'Errors');
    /*
    System.assertEquals(bgc.personInfo.Background_Check_Msg__c,'Verfication Successful');
    System.assert(bgc.personInfo.BGC_Notes__c.contains('<SSN>XXX-XX-XXX9</SSN>'));
    System.assert(bgc.xmlData.contains('<HouseNumber>10</HouseNumber>'));
    System.assert(bgc.xmlData.contains('<StreetName>test st</StreetName>'));*/
    /*
    List<Person_Info__c> depPersList = [select d.id,d.Background_Check_Msg__c,BGC_Notes__c from Person_Info__c d 
        where d.applicant_info__c = :testapp.Id and d.Primary_Applicant__c= :false];
    for (Person_Info__c dep : depPersList){
        //System.assert(dep.Background_Check_Msg__c == 'Verfication Successful');
        System.assert(dep.BGC_Notes__c.contains('<SSN>XXX-XX-XXX9</SSN>'));
    }
    */
  }    
  public class applicationException extends Exception {}
      
}