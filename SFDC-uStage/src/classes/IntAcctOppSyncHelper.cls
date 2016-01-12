global class IntAcctOppSyncHelper implements Database.AllowsCallouts {
    public static string xmlData ='';
    public static string endPoint='';
    public static string responseXML = '';
    public static string computedResponse;
    public static string responseId = '';
    public static integer errorCounter = 0;
    public static string appErrorMsg = '';
    public static String testRes='';
    public static Boolean isApexBeingTested = false;
    public static Id paymentId;
    public static String ARUpdateKey='';
    public static String matchType='';
    public static String ScheduleIntacct='';
    
    public static List<Intacct__c> insertIntacctList;
    public static List<Account> updateAcctList;//=new List<Account>();
    public static List<Intacct__c> insertIntacctLstInner;// = new List<Intacct__c>();
    
    public Opportunity opportunityRecSyncBack {get;set;}
    public Map<String,String> responseFromIntacct {get;set;}
    
    public IntAcctOppSyncHelper(ApexPages.StandardController stdController){
    	sObject theObject = stdController.getRecord();
        if (theObject.getSObjectType() == Opportunity.SObjectType){
        	opportunityRecSyncBack = (Opportunity)theObject;
        }
    }
 
    /*OLD CODE commenting out the old code since now we will use only sync
    public static void InitiaiteIntAcct(Id accId) {
        List<Account> lstAccount;
        system.debug('******Inside HELPER**********');
        List<String> computedResponses;
        List<String> KeyValues; 
        lstAccount =[Select a.Status__c,a.Name,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:accId LIMIT 1];
        System.debug('****lstAccount: ' + lstAccount);
        List<User> userList = [SELECT Id, Type__c,Intacct_Company_ID__c FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1];
        System.debug('****userList: ' + userList);
        
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint');
        System.debug('****appconstant: ' + appconstant);
        endpoint=appconstant.Value__c;
        
        if(lstAccount!=null && lstAccount.size()>0)
        {
            
            For(Account acc:lstAccount)
            {
                
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                
                Dom.Document doc = new Dom.Document();
                List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
                
                doc.load(Constants.CreateCustomerXMLTemplate);
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    system.debug('*node***'+node);
                    
                    //system.debug('*objFieldName***'+objFieldName);
                    if(node.getName() == 'operation')
                    {
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for(dom.XmlNode childnode : childnodelist)
                        {
                            system.debug('*childnode***'+childnode);                 
                            if(childnode.getName()=='content')
                            {
                                List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                                for(dom.Xmlnode nextchild: nextchildnodelist)
                                {system.debug('*nextchild***'+nextchild);
                                 if(nextchild.getName()=='function')                 
                                 {
                                     List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                     for(dom.Xmlnode next2child: next2childnodelist)
                                     {
                                         system.debug('*next2child***'+next2child);
                                         if(next2child.getName()=='create_contact')                 
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName = Constants.IntAcctXMLNode2SObjField.get(next3child.getName());
                                                 system.debug('*objFieldName***'+objFieldName);  
                                                 
                                                 if (next3child.getName() == 'contactname' && objFieldName != null && objFieldName != ''){
                                                     if (acc.get(objFieldName)!= null){                          
                                                         String textval = (String)acc.get(objFieldName) + '(' +  (String)acc.get('IntacctID__c') + ')';
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                     
                                                 }
                                                 else if (next3child.getName() == 'printas'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }                               
                                                 else if (next3child.getName() == 'firstname'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'lastname'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'phone1'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'fax'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     // else{
                                                     //     errorCounter = errorCounter+1;
                                                     //     appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     // }
                                                 }
                                                 else if (next3child.getName() == 'email1'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                 }
                                                 else if(next3child.getName() == 'mailaddress')
                                                 {
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     {
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldNameMA1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName()); 
                                                         system.debug('*objFieldNameMA1***'+objFieldNameMA1);
                                                         system.debug('*acc.get(objFieldNameMA1)***'+acc.get(objFieldNameMA1));
                                                         if(next4child.getName() == 'address1'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'city'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'state'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'zip'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'country'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                     } 
                                                 }
                                             }}
                                         else if (next2child.getName()=='create_customer')                   
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName = Constants.IntAcctXMLNode2SObjField.get(next3child.getName());                                
                                                 if (next3child.getName() == 'customerid' && objFieldName != null && objFieldName != ''){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                     
                                                 }
                                                 else if (next3child.getName() == 'name'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'contactinfo'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1)+ '(' +  (String)acc.get('IntacctID__c') + ')';
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'primary'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1)+ '(' +  (String)acc.get('IntacctID__c') + ')';
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'billto'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1)+ '(' +  (String)acc.get('IntacctID__c') + ')';
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'shipto'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1)+ '(' +  (String)acc.get('IntacctID__c') + ')';
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'externalid'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'externalid' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 
                                             }}}}}}}}}                  
                
                
                
                
                xmlData = doc.toXmlString();
                
                system.debug('*****xmlData*******'+xmlData);
                system.debug('*****errorCounter*******'+errorCounter);
                system.debug('*****appErrorMsg*******'+appErrorMsg);
                if (errorCounter == 0)
                    computedResponse=IntAcctOppSyncHelper.getContent();                             
                system.debug('*****computedResponse*******'+computedResponse);                               
                if(computedResponse!=null && computedResponse.contains('#'))                         
                {
                    computedResponses = computedResponse.split('#',2);
                }
                if(computedResponses!=null)
                {             
                    computedResponse = computedResponses[0];              
                    
                    system.debug('*****computedResponses*******'+computedResponses);
                    system.debug('*****computedResponse*******'+computedResponse);
                }
                system.debug('*****computedResponse*******'+computedResponse);  
                if(computedResponse!=null)
                {
                    //Now sync the account to customer in Intacct
                    IntAcctOppSyncHelper.SyncAccountToCustomer(accId);
                    Intacct__c  objIntacct = new Intacct__c();
                    objIntacct.Account__c = acc.Id;
                    //objIntacct.Request_XML__c = xmldata;
                    //objIntacct.Response_XML__c = responseXML;
                    objIntacct.Intacct_Response__c = computedResponse;
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.Type__c='Create Customer';
                    insert objIntacct;
                    system.debug('*****objIntacct*******'+objIntacct);  
                }
            }
            
            
        }
        
        //  return computedResponse;
    }*/
    
	/*OLD CODE commenting out -- just using sync
    public static Intacct__c InitiaiteIntAcct2(Id accId) {
        List<Account> lstAccount;
        system.debug('******Inside HELPER**********');
        List<String> computedResponses;
        List<String> KeyValues; 
        lstAccount =[Select a.Status__c,a.Name,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,
                     a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, 
                     a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, 
                     a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, 
                     a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, 
                     a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:accId LIMIT 1];
        System.debug('****lstAccount: ' + lstAccount);
        List<User> userList = [SELECT Id, Type__c,Intacct_Company_ID__c FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1];
        System.debug('****userList: ' + userList);
        
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint');
        System.debug('****appconstant: ' + appconstant);
        endpoint=appconstant.Value__c;
        Intacct__c  objIntacct = new Intacct__c();
        if(lstAccount!=null && lstAccount.size()>0)
        {
            
            For(Account acc:lstAccount)
            {
                
                //Http h = new Http();
                //HttpRequest req = new HttpRequest();
                
                Dom.Document doc = new Dom.Document();
                List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
                
                doc.load(Constants.CreateCustomerXMLTemplate);
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    system.debug('*node***'+node);
                    
                    //system.debug('*objFieldName***'+objFieldName);
                    if(node.getName() == 'operation')
                    {
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for(dom.XmlNode childnode : childnodelist)
                        {
                            system.debug('*childnode***'+childnode);                 
                            if(childnode.getName()=='content')
                            {
                                List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                                for(dom.Xmlnode nextchild: nextchildnodelist)
                                {system.debug('*nextchild***'+nextchild);
                                 if(nextchild.getName()=='function')                 
                                 {
                                     List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                     for(dom.Xmlnode next2child: next2childnodelist)
                                     {
                                         system.debug('*next2child***'+next2child);
                                         if(next2child.getName()=='create_contact')                 
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName = Constants.IntAcctXMLNode2SObjField.get(next3child.getName());
                                                 system.debug('*objFieldName***'+objFieldName);  
                                                 
                                                 if (next3child.getName() == 'contactname' && objFieldName != null && objFieldName != ''){
                                                     if (acc.get(objFieldName)!= null){                          
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                     
                                                 }
                                                 else if (next3child.getName() == 'printas'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }                               
                                                 else if (next3child.getName() == 'firstname'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'lastname'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'phone1'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'fax'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'email1'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                 }
                                                 else if(next3child.getName() == 'mailaddress')
                                                 {
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     {
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldNameMA1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName()); 
                                                         system.debug('*objFieldNameMA1***'+objFieldNameMA1);
                                                         system.debug('*acc.get(objFieldNameMA1)***'+acc.get(objFieldNameMA1));
                                                         if(next4child.getName() == 'address1'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'city'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'state'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'zip'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                         if(next4child.getName() == 'country'){
                                                             if (acc.get(objFieldNameMA1)!= null){
                                                                 String textval = (String)acc.get(objFieldNameMA1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                         }
                                                     } 
                                                 }
                                             }}
                                         else if (next2child.getName()=='create_customer')                   
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName = Constants.IntAcctXMLNode2SObjField.get(next3child.getName());                                
                                                 if (next3child.getName() == 'customerid' && objFieldName != null && objFieldName != ''){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                     
                                                 }
                                                 else if (next3child.getName() == 'name'){
                                                     if (acc.get(objFieldName)!= null){
                                                         String textval = (String)acc.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'contactinfo'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'primary'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'billto'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'shipto'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'contactname' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 else if (next3child.getName() == 'externalid'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'externalid' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
                                                     }}
                                                 
                                             }}}}}}}}}                  
                
                
                
                
                xmlData = doc.toXmlString();
                
                system.debug('*****xmlData*******'+xmlData);
                system.debug('*****errorCounter*******'+errorCounter);
                system.debug('*****appErrorMsg*******'+appErrorMsg);
                
                if (errorCounter == 0)
                {
                    Http h = new Http();
                    HttpResponse res = new HttpResponse();
                    
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
                    
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST');  
                    req.setheader('Content-type','x-intacct-xml-request');
                    req.setHeader('Accept', 'application/xml');
                    String body = xmlData;
                    system.debug('*****req*******'+req);
                    system.debug('*****xmlData*******'+xmlData);
                    system.debug('*****body*******'+body);
                    req.setTimeout(120000);
                    req.setBody(body);  
                    req.setEndpoint(endPoint);
                    // Send the request, and return a response 
                    system.debug('*****req*******'+req); 
                    system.debug('*****isApexBeingTested*******'+isApexBeingTested); 
                    if (!isApexBeingTested){
                        res = h.send(req);
                        system.debug('*****res*******'+res); 
                        responseXML = res.getBody();
                        system.debug('*****responseXML*******'+responseXML); 
                    }
                    else{
                        responseXML = testRes;
                    }
                    
                    system.debug('*****responseXML*******'+responseXML);  
                    Dom.Document responsedoc = new Dom.Document();
                    String finalResult='Success';
                    if (!isApexBeingTested){
                        responsedoc = res.getBodyDocument();
                        system.debug('*****responsedoc*******'+responsedoc);  
                        dom.XmlNode OperationNode =  responsedoc.getRootElement().getChildElement('operation', null) ;
                        system.debug('*****OperationNode*******'+OperationNode);
                        
                        
                        for(Dom.XmlNode node1: OperationNode.getChildElements()) {
                            if(node1.getName()=='result') {
                                //handle error condition
                                dom.XmlNode ResultNode =  node1.getChildElement('status', null) ;
                                if(resultNode!=null && ResultNode.getText()=='success')
                                    continue;
                                else
                                {
                                    finalResult='Failure';
                                    break;
                                }
                            }
                        }
                        
                        if(finalResult=='Success')
                        {
                            System.debug('Account creation successfull.');
                            //IntAcctOppSyncHelper.SyncAccountToCustomer(accId);
                        }
                        else
                            System.debug('Account creation Failed');
                        
                        objIntacct.Account__c = acc.Id;
                        objIntacct.Request_XML__c = xmldata;
                        objIntacct.Response_XML__c = responseXML;
                        objIntacct.Intacct_Response__c = finalResult;
                        objIntacct.Last_Sync_Date__c=system.now();
                        objIntacct.Type__c='Create Customer';
                        system.debug('*****objIntacct*******'+objIntacct);  
                    }
                    else{
                        objIntacct.Account__c = acc.Id;
                        objIntacct.Request_XML__c = xmldata;
                        objIntacct.Response_XML__c = 'Test Successful';
                        objIntacct.Intacct_Response__c = finalResult;
                        objIntacct.Last_Sync_Date__c=system.now();
                        objIntacct.Type__c='Create Customer';
                        system.debug('*****objIntacct*******'+objIntacct); 
                    }
                }
                else
                {
                    objIntacct.Account__c = acc.Id;
                    objIntacct.Request_XML__c = xmldata;
                    objIntacct.Response_XML__c = 'Something went wrong in constructing the request xml.' + 'Error Counter: ' + errorCounter
                        + 'appErrorMsg: ' + appErrorMsg ;
                    objIntacct.Intacct_Response__c = 'Failure';
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.Type__c='Create Customer';
                    system.debug('*****objIntacct*******'+objIntacct);                     
                }
            }
        }
        return objIntacct;
    }
	*/
    
    /*OLD CODE commenting out the old code since now we will use only sync
    public static void InitiaiteIntAcct_new(Id accId) {
        List<Account> lstAccount;
        system.debug('******Inside HELPER**********');
        List<String> computedResponses;
        List<String> KeyValues; 
        lstAccount =[Select a.Status__c,a.Name,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:accId LIMIT 1];
        System.debug('****lstAccount: ' + lstAccount);
        List<User> userList = [SELECT Id, Type__c,Intacct_Company_ID__c FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1];
        System.debug('****userList: ' + userList);
        
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint');
        System.debug('****appconstant: ' + appconstant);
        endpoint=appconstant.Value__c;
        
        if(lstAccount!=null && lstAccount.size()>0)
        {
            
            For(Account acc:lstAccount)
            {
                
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                
                Dom.Document doc = new Dom.Document();
                List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
                
                doc.load(Constants.CreateCustomerXMLTemplate_new);
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    system.debug('*node***'+node);
                    
                    //system.debug('*objFieldName***'+objFieldName);
                    if(node.getName() == 'operation')
                    {
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for(dom.XmlNode childnode : childnodelist)
                        {
                            system.debug('*childnode***'+childnode);                 
                            if(childnode.getName()=='content')
                            {
                                List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                                for(dom.Xmlnode nextchild: nextchildnodelist)
                                {system.debug('*nextchild***'+nextchild);
                                 if(nextchild.getName()=='function')                 
                                 {
                                     List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                     for(dom.Xmlnode next2child: next2childnodelist)
                                     {
                                         system.debug('*next2child***'+next2child);
                                         if (next2child.getName()=='create_customer')                   
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName2 = Constants.IntAcctXMLNode2SObjField.get(next3child.getName());                                
                                                 if (next3child.getName() == 'customerid' && objFieldName2 != null && objFieldName2 != ''){
                                                     if (acc.get(objFieldName2)!= null){
                                                         String textval = (String)acc.get(objFieldName2);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName2 + ' cannot be blank;';
                                                     }
                                                     
                                                 }
                                                 else if (next3child.getName() == 'name'){
                                                     if (acc.get(objFieldName2)!= null){
                                                         String textval = (String)acc.get(objFieldName2);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName2 + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'contactinfo')
													{
                                                     List<dom.XmlNode> contactInfoChildNodeList =  next3child.getChildElements();
                                                     
														for(dom.Xmlnode contactInfoChild: contactInfoChildNodeList)
														{
														if(contactInfoChild.getName()=='contact')                 
														{  
															List<dom.XmlNode> contactChildnodelist =  contactInfoChild.getChildElements();
															for(dom.Xmlnode contactChild: contactChildnodelist)
															{ 
																system.debug('*contactChild***'+contactChild);
																String objFieldName = Constants.IntAcctXMLNode2SObjField.get(contactChild.getName());
																system.debug('*objFieldName***'+objFieldName);  
																
																if (contactChild.getName() == 'contactname' && objFieldName != null && objFieldName != ''){
																	if (acc.get(objFieldName)!= null){                          
																		String textval = (String)acc.get(objFieldName) + '(C' +  (String)acc.get('IntacctID__c') + ')';
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																	
																}
																else if (contactChild.getName() == 'printas'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																}                               
																else if (contactChild.getName() == 'firstname'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																}
																else if (contactChild.getName() == 'lastname'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																}
																else if (contactChild.getName() == 'phone1'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																	}
																else if (contactChild.getName() == 'fax'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																}
																else if (contactChild.getName() == 'email1'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																}
																else if(contactChild.getName() == 'mailaddress')
																{
																	List<dom.XmlNode> mailAddressChildNodeList =  contactChild.getChildElements();
																	for(dom.Xmlnode mailAddresschild: mailAddressChildNodeList)
																	{
																		system.debug('*mailAddresschild***'+mailAddresschild);
																		String objFieldNameMA1 = Constants.IntAcctXMLNode2SObjField.get(mailAddresschild.getName()); 
																		system.debug('*objFieldNameMA1***'+objFieldNameMA1);
																		system.debug('*acc.get(objFieldNameMA1)***'+acc.get(objFieldNameMA1));
																		if(mailAddresschild.getName() == 'address1'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'city'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																			}
																		if(mailAddresschild.getName() == 'state'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'zip'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'country'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																	} 
																}
															}
														}
													  }			 
													 
													}
                                                 else if (next3child.getName() == 'billto')
													{
                                                     List<dom.XmlNode> contactInfoChildNodeList =  next3child.getChildElements();
													 for(dom.Xmlnode contactInfoChild: contactInfoChildNodeList)
													 {
														if(contactInfoChild.getName()=='contact')                 
														{  
															List<dom.XmlNode> contactChildnodelist =  contactInfoChild.getChildElements();
															for(dom.Xmlnode contactChild: contactChildnodelist)
															{ 
																system.debug('*contactChild***'+contactChild);
																String objFieldName = Constants.IntAcctXMLNode2SObjField.get(contactChild.getName());
																system.debug('*objFieldName***'+objFieldName);  
																
																if (contactChild.getName() == 'contactname' && objFieldName != null && objFieldName != ''){
																	if (acc.get(objFieldName)!= null){                          
																		String textval = 'B_' +  (String)acc.get('IntacctID__c');
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																	
																}
																else if (contactChild.getName() == 'printas'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																}                               
																else if(contactChild.getName() == 'mailaddress')
																{
																	List<dom.XmlNode> mailAddressChildNodeList =  contactChild.getChildElements();
																	for(dom.Xmlnode mailAddresschild: mailAddressChildNodeList)
																	{
																		system.debug('*mailAddresschild***'+mailAddresschild);
																		String objFieldNameMA1 = Constants.IntAcctXMLNode2SObjField.get(mailAddresschild.getName()); 
																		system.debug('*objFieldNameMA1***'+objFieldNameMA1);
																		system.debug('*acc.get(objFieldNameMA1)***'+acc.get(objFieldNameMA1));
																		if(mailAddresschild.getName() == 'address1'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'city'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																			}
																		if(mailAddresschild.getName() == 'state'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'zip'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'country'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																	} 
																}
															}
														}
													  }	
                                                    }
                                                 else if (next3child.getName() == 'shipto')
												 {
                                                     List<dom.XmlNode> contactInfoChildNodeList =  next3child.getChildElements();
													 for(dom.Xmlnode contactInfoChild: contactInfoChildNodeList)
													 {
														if(contactInfoChild.getName()=='contact')                 
														{  
															List<dom.XmlNode> contactChildnodelist =  contactInfoChild.getChildElements();
															for(dom.Xmlnode contactChild: contactChildnodelist)
															{ 
																system.debug('*contactChild***'+contactChild);
																String objFieldName = Constants.IntAcctXMLNode2SObjField.get(contactChild.getName());
																system.debug('*objFieldName***'+objFieldName);  
																
																if (contactChild.getName() == 'contactname' && objFieldName != null && objFieldName != ''){
																	if (acc.get(objFieldName)!= null){                          
																		String textval = 'S_' +  (String)acc.get('IntacctID__c');
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																	
																}
																else if (contactChild.getName() == 'printas'){
																	if (acc.get(objFieldName)!= null){
																		String textval = (String)acc.get(objFieldName);
																		contactChild.addTextNode(textval);                              
																	}
																	else{
																		errorCounter = errorCounter+1;
																		appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
																	}
																}
																else if(contactChild.getName() == 'mailaddress')
																{
																	List<dom.XmlNode> mailAddressChildNodeList =  contactChild.getChildElements();
																	for(dom.Xmlnode mailAddresschild: mailAddressChildNodeList)
																	{
																		system.debug('*mailAddresschild***'+mailAddresschild);
																		String objFieldNameMA1 = Constants.IntAcctXMLNode2SObjField.get(mailAddresschild.getName()); 
																		system.debug('*objFieldNameMA1***'+objFieldNameMA1);
																		system.debug('*acc.get(objFieldNameMA1)***'+acc.get(objFieldNameMA1));
																		if(mailAddresschild.getName() == 'address1'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'city'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																			}
																		if(mailAddresschild.getName() == 'state'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'zip'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																		if(mailAddresschild.getName() == 'country'){
																			if (acc.get(objFieldNameMA1)!= null){
																				String textval = (String)acc.get(objFieldNameMA1);
																				mailAddresschild.addTextNode(textval);                              
																			}
																		}
																	} 
																}
															}
														}
													  }	
                                                     
												 }
                                                 else if (next3child.getName() == 'externalid'){
                                                     List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next4child: next4childnodelist)
                                                     { 
                                                         system.debug('*next4child***'+next4child);
                                                         String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                         if (next4child.getName() == 'externalid' && objFieldName1 != null && objFieldName1 != ''){
                                                             if (acc.get(objFieldName1)!= null){
                                                                 String textval = (String)acc.get(objFieldName1);
                                                                 next4child.addTextNode(textval);                              
                                                             }
                                                             else{
                                                                 errorCounter = errorCounter+1;
                                                                 appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                             }
                                                             
                                                         }
                                                         
														}
													}
                                                 
												}
											}
										}
									}
								}
							}
						}
					}
				}                  
                
                
                xmlData = doc.toXmlString();
                
                system.debug('*****xmlData*******'+xmlData);
                system.debug('*****errorCounter*******'+errorCounter);
                system.debug('*****appErrorMsg*******'+appErrorMsg);
                if (errorCounter == 0)
                    computedResponse=IntAcctOppSyncHelper.getContent();                             
                system.debug('*****computedResponse*******'+computedResponse);                               
                if(computedResponse!=null && computedResponse.contains('#'))                         
                {
                    computedResponses = computedResponse.split('#',2);
                }
                if(computedResponses!=null)
                {             
                    computedResponse = computedResponses[0];              
                    
                    system.debug('*****computedResponses*******'+computedResponses);
                    system.debug('*****computedResponse*******'+computedResponse);
                }
                system.debug('*****computedResponse*******'+computedResponse);  
                if(computedResponse!=null)
                {
                    //Now sync the account to customer in Intacct
                    IntAcctOppSyncHelper.SyncAccountToCustomer(accId);
                    Intacct__c  objIntacct = new Intacct__c();
                    objIntacct.Account__c = acc.Id;
                    //objIntacct.Request_XML__c = xmldata;
                    //objIntacct.Response_XML__c = responseXML;
                    objIntacct.Intacct_Response__c = computedResponse;
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.Type__c='Create Customer';
                    insert objIntacct;
                    system.debug('*****objIntacct*******'+objIntacct);  
                }
            }
        }
    }
    */

    /*OLD CODE commenting out ..just using sync
    //@Future(callout=true)
    public static void CheckandCreateCustomer(Id accId)
    {
        String isExists='Failure';
        List<Account> accList=[Select a.id,a.IntacctID__c, a.Status__c,a.Intacct_Sync_At__c,a.Type,
                               a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,
                               a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, 
                               a.Intrax_Program_Category__c, a.Intrax_Id__c,
                               a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, 
                               a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, 
                               a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, 
                               a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity from account a where id= :accId];
        if(accList!=null && accList.size()>0)
        isExists=IntAcctOppSyncHelper.IsCustomerExists(accList[0].IntacctID__c);
        
        if(isExists=='Success')
        {
            system.debug('Account Exists. Just sync and insert intacct record');
            Account tempAcct = IntAcctOppSyncHelper.bulkSyncAccountToCustomer(accList[0]);
            updateAcctList.add(tempAcct);
            
            //check if the Intacct customer record exists or not. If not create it
            List<Intacct__c> lstParentIntacct = [Select i.Parent_Intacct__c, i.Intacct_Response__c, i.Id, i.Account__c 
                                                 From Intacct__c i where 
                            					 i.account__c=:accList[0].Id and 
                            					 i.Is_Parent__c=true and
                            					 i.Intacct_Response__c='Success'];
            
            if(lstParentIntacct!=null && lstParentIntacct.size()==0)
            {
                Intacct__c objIntacct = new Intacct__c();
                objIntacct.Account__c = accList[0].Id;
                //objIntacct.Request_XML__c = xmldata;
                //objIntacct.Response_XML__c = responseXML;
                objIntacct.Intacct_Response__c = 'Success';
                objIntacct.Last_Sync_Date__c=system.now();
                objIntacct.Type__c='Create Customer';
                insertIntacctLstInner.add(objIntacct);
            }
        }
        else
        {
            Intacct__c TempIntacct= IntAcctOppSyncHelper.InitiaiteIntAcct2(accList[0].Id);
            insertIntacctLstInner.Add(TempIntacct);
            if(tempIntacct.Intacct_Response__c == 'Success')
            {
                Account tempAcct2 = IntAcctOppSyncHelper.bulkSyncAccountToCustomer(accList[0]);
            	updateAcctList.add(tempAcct2);
            }
         system.debug('Create account and sync and insert Intacct Record') ; 
        }
    }
	*/
    
    /*OLD CODE commenting out the old code since now we will use only sync
    @Future(callout=true)
    public static void UpdateCustomer(Id accId, Id IntacctId) {
        List<Account> lstAccount;
        List<Intacct__c> lstIntacct;
        List<String> computedResponses;
        List<String> KeyValues;
        system.debug('******Inside UpdateCustomer**********'+accId+'**********'+IntacctId);
        
        lstAccount =[Select a.Status__c,a.Name,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:accId LIMIT 1];
        System.debug('****lstAccount: ' + lstAccount);
        lstIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where i.Account__c=:accId and i.Is_Parent__c=true];
        
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint');
        System.debug('****appconstant: ' + appconstant);
        endpoint=appconstant.Value__c;
        
        if(lstAccount!=null && lstAccount.size()>0)
        {
            
            For(Account acc:lstAccount)
            {
                
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                
                Dom.Document doc = new Dom.Document();
                List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
                
                doc.load(Constants.UpdateCustomerXMLTemplate);
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    system.debug('*node***'+node);
                    
                    //system.debug('*objFieldName***'+objFieldName);
                    if(node.getName() == 'operation')
                    {
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for(dom.XmlNode childnode : childnodelist)
                        {
                            system.debug('*childnode***'+childnode);                 
                            if(childnode.getName()=='content')
                            {
                                List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                                for(dom.Xmlnode nextchild: nextchildnodelist)
                                {system.debug('*nextchild***'+nextchild);
                                 if(nextchild.getName()=='function')                 
                                 {
                                     List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                     for(dom.Xmlnode next2child: next2childnodelist)
                                     {
                                         system.debug('*next2child***'+next2child);
                                         if(next2child.getName()=='update_contact')                  
                                         {  string  result;
                                          
                                          String objFieldNameAtt = Constants.IntAcctXMLNode2SObjField.get('contactname');
                                          system.debug('*next2child.objFieldNameAtt***'+objFieldNameAtt);
                                          String Atttextval = (String)acc.get(objFieldNameAtt)+ '(' +  (String)acc.get('IntacctID__c') + ')';
                                          system.debug('*Atttextval***'+Atttextval);
                                          next2child.setAttribute('contactname',Atttextval);    
                                          
                                          List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                          for(dom.Xmlnode next3child: next3childnodelist)
                                          { 
                                              system.debug('*next3child***'+next3child);
                                              String objFieldName = Constants.IntAcctXMLNode2SObjField.get(next3child.getName());
                                              system.debug('*objFieldName***'+objFieldName);  
                                              
                                              if (next3child.getName() == 'contactname' && objFieldName != null && objFieldName != ''){
                                                  if (acc.get(objFieldName)!= null){                          
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                                  else{
                                                      errorCounter = errorCounter+1;
                                                      appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                  }
                                                  
                                              }
                                              else if (next3child.getName() == 'printas'){
                                                  if (acc.get(objFieldName)!= null){
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                                  else{
                                                      errorCounter = errorCounter+1;
                                                      appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                  }
                                              }                               
                                              else if (next3child.getName() == 'firstname'){
                                                  if (acc.get(objFieldName)!= null){
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                                  else{
                                                      errorCounter = errorCounter+1;
                                                      appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                  }
                                              }
                                              else if (next3child.getName() == 'lastname'){
                                                  if (acc.get(objFieldName)!= null){
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                                  else{
                                                      errorCounter = errorCounter+1;
                                                      appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                  }
                                              }
                                              else if (next3child.getName() == 'phone1'){
                                                  if (acc.get(objFieldName)!= null){
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                              }
                                              else if (next3child.getName() == 'fax'){
                                                  // if (acc.get(objFieldName)!= null){
                                                  String textval = '123';//(String)acc.get(objFieldName);
                                                  next3child.addTextNode(textval);                              
                                                  // }
                                                  // else{
                                                  //     errorCounter = errorCounter+1;
                                                  //     appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                  // }
                                              }
                                              else if (next3child.getName() == 'email1'){
                                                  if (acc.get(objFieldName)!= null){
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                              }
                                              else if(next3child.getName() == 'mailaddress')
                                              {
                                                  List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                  for(dom.Xmlnode next4child: next4childnodelist)
                                                  {
                                                      system.debug('*next4child***'+next4child);
                                                      String objFieldNameMA1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName()); 
                                                      system.debug('*objFieldNameMA1***'+objFieldNameMA1);
                                                      system.debug('*acc.get(objFieldNameMA1)***'+acc.get(objFieldNameMA1));
                                                      if(next4child.getName() == 'address1'){
                                                          if (acc.get(objFieldNameMA1)!= null){
                                                              String textval = (String)acc.get(objFieldNameMA1);
                                                              next4child.addTextNode(textval);                              
                                                          }
                                                      }
                                                      if(next4child.getName() == 'city'){
                                                          if (acc.get(objFieldNameMA1)!= null){
                                                              String textval = (String)acc.get(objFieldNameMA1);
                                                              next4child.addTextNode(textval);                              
                                                          }
                                                      }
                                                      if(next4child.getName() == 'state'){
                                                          if (acc.get(objFieldNameMA1)!= null){
                                                              String textval = (String)acc.get(objFieldNameMA1);
                                                              next4child.addTextNode(textval);                              
                                                          }
                                                      }
                                                      if(next4child.getName() == 'zip'){
                                                          if (acc.get(objFieldNameMA1)!= null){
                                                              String textval = (String)acc.get(objFieldNameMA1);
                                                              next4child.addTextNode(textval);                              
                                                          }
                                                      }
                                                      if(next4child.getName() == 'country'){
                                                          if (acc.get(objFieldNameMA1)!= null){
                                                              String textval = (String)acc.get(objFieldNameMA1);
                                                              next4child.addTextNode(textval);                              
                                                          }
                                                      }
                                                  } 
                                              }
                                          }}
                                         
                                         else if (next2child.getName()=='update_customer')                   
                                         {   String objFieldNameAtt1 = Constants.IntAcctXMLNode2SObjField.get('customerid');
                                          system.debug('*next2child.objFieldNameAtt1***'+objFieldNameAtt1);
                                          String Atttextval1 = (String)acc.get(objFieldNameAtt1);
                                          system.debug('*Atttextval1***'+Atttextval1);
                                          next2child.setAttribute('customerid',Atttextval1);    
                                          List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                          for(dom.Xmlnode next3child: next3childnodelist)
                                          { 
                                              system.debug('*next3child***'+next3child);
                                              String objFieldName = Constants.IntAcctXMLNode2SObjField.get(next3child.getName());                                
                                              if (next3child.getName() == 'customerid' && objFieldName != null && objFieldName != ''){
                                                  if (acc.get(objFieldName)!= null){
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                                  else{
                                                      errorCounter = errorCounter+1;
                                                      appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                  }
                                                  
                                              }
                                              else if (next3child.getName() == 'name'){
                                                  if (acc.get(objFieldName)!= null){
                                                      String textval = (String)acc.get(objFieldName);
                                                      next3child.addTextNode(textval);                              
                                                  }
                                                  else{
                                                      errorCounter = errorCounter+1;
                                                      appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                  }
                                              }
                                              else if (next3child.getName() == 'contactinfo'){
                                                  List<dom.XmlNode> next4childnodelist =  next3child.getChildElements();
                                                  for(dom.Xmlnode next4child: next4childnodelist)
                                                  { 
                                                      system.debug('*next4child***'+next4child);
                                                      String objFieldName1 = Constants.IntAcctXMLNode2SObjField.get(next4child.getName());                               
                                                      if (next4child.getName() == 'contactname' && objFieldName != null && objFieldName != ''){
                                                          if (acc.get(objFieldName)!= null){
                                                              String textval = (String)acc.get(objFieldName1);
                                                              next4child.addTextNode(textval);                              
                                                          }
                                                          else{
                                                              errorCounter = errorCounter+1;
                                                              appErrorMsg = appErrorMsg +  objFieldName1 + ' cannot be blank;';
                                                          }
                                                          
                                                      }
                                                  }}}}}}}}}}}                  
                
                
                
                
                xmlData = doc.toXmlString();
                
                system.debug('*****xmlData*******'+xmlData);
                system.debug('*****errorCounter*******'+errorCounter);
                system.debug('*****appErrorMsg*******'+appErrorMsg);
                if (errorCounter == 0)
                    computedResponse=IntAcctOppSyncHelper.getContent();                             
                if(computedResponse.contains('#'))                         
                {
                    computedResponses = computedResponse.split('#',2);
                }
                if(computedResponses!=null)
                {             
                    computedResponse = computedResponses[0];              
                    
                    system.debug('*****computedResponses*******'+computedResponses);
                    system.debug('*****computedResponse*******'+computedResponse);
                }
                system.debug('*****computedResponse*******'+computedResponse);                         
                
                system.debug('*****computedResponse*******'+computedResponse);  
                if(computedResponse!=null)
                {
                    IntAcctOppSyncHelper.SyncAccountToCustomer(accId);
                    For(Intacct__c  objIntacct: lstIntacct)
                    {
                        objIntacct.Intacct_Response__c = computedResponse;
                        update objIntacct;
                        system.debug('*****objIntacct*******'+objIntacct);  
                    }
                    
                }
            }
            
            
        }
        
        //  return computedResponse;
    }
    */
    
    /*OLD CODE commenting out the old code since now we will use only sync
    public static void SyncAccountToCustomer(Id accId) {
        List<Account> lstAccount;
        lstAccount =[Select a.Status__c,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:accId LIMIT 1];
        System.debug('****lstAccount: ' + lstAccount);
        if(lstAccount!=null && lstAccount.size()>0)
        {
            Account acc = lstAccount[0];
            system.debug('******Inside HELPER**********');
            HttpRequest req = new HttpRequest();
            System.debug('******SyncAccountToCustomer UserInfo.getUserId*******' +UserInfo.getUserID());
            system.debug('******SyncAccountToCustomer API.Partner_Server_URL_70**********' +acc.APIServerUrl__c);
            
            Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAccountSyncUrl');
            System.debug('****appconstant: ' + appconstant);
            String endPointAccountSync = appconstant.Value__c + 'syncIntactAccount?accountId='+ accId+'&sfdcAPIServerUrl='+acc.APIServerUrl__c;
            
            system.debug('******Encoded url **********' + endPointAccountSync);
            req.setTimeout(120000);
            req.setEndpoint(endPointAccountSync);
            req.setMethod('GET');
            String authorizationHeader = 'Basic ';
            //EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            Http http = new Http();
            system.debug('request ' + req);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
            if(res.getBody().containsIgnoreCase(acc.IntacctID__c) && res.getBody().containsIgnoreCase('updated successfully'))
            {
                System.debug('Account sync completed successsfully for the account' + accId);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Account Successfully synced';
            }
            else
            {
                system.debug('Account sync failed for the account' + accId);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Account Sync Failed';
            }
            update acc;
        }
    }*/
    
    public static void SyncAccountToCustomer_new(Id accId) {
        List<Account> lstAccount;
        lstAccount =[Select a.Status__c,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:accId LIMIT 1];
        System.debug('****lstAccount: ' + lstAccount);
        if(lstAccount!=null && lstAccount.size()>0)
        {
            Account acc = lstAccount[0];
            system.debug('******Inside HELPER**********');
            HttpRequest req = new HttpRequest();
            System.debug('******SyncAccountToCustomer UserInfo.getUserId*******' +UserInfo.getUserID());
            system.debug('******SyncAccountToCustomer API.Partner_Server_URL_70**********' +acc.APIServerUrl__c);
            
            Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAccountSyncUrl');
            System.debug('****appconstant: ' + appconstant);
            String endPointAccountSync = appconstant.Value__c + 'syncIntactAccount?accountId='+ accId+'&sfdcAPIServerUrl='+acc.APIServerUrl__c;
            
            system.debug('******Encoded url **********' + endPointAccountSync);
            req.setTimeout(120000);
            req.setEndpoint(endPointAccountSync);
            req.setMethod('GET');
            String authorizationHeader = 'Basic ';
            //EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            Http http = new Http();
            system.debug('request ' + req);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
            if(res.getBody().containsIgnoreCase(acc.IntacctID__c) && res.getBody().containsIgnoreCase('updated successfully'))
            {
                System.debug('Account sync completed successsfully for the account' + accId);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Account Successfully synced';
                
                List<Intacct__c> lstParentIntacct = 
                    [Select i.Is_Parent__c, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where 
                            i.account__c=:acc.Id and 
                     		i.Type__c = 'Create Customer' and
                            i.Is_Parent__c=true and
                            i.Intacct_Response__c='Success'];
                
                if(lstParentIntacct==null || lstParentIntacct.size()==0)
                {
                    Intacct__c  objIntacct = new Intacct__c();
                    objIntacct.Account__c = acc.Id;
                    objIntacct.Request_XML__c = 'Request: ' + req + ' Body : ' + req.getBody();
                    objIntacct.Response_XML__c = res.getBody();
                    objIntacct.Intacct_Response__c = 'Success';
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.Type__c='Create Customer';
                    system.debug('*****objIntacct*******'+objIntacct);  
                    insert objIntacct;
                }
            }
            else
            {
                system.debug('Account sync failed for the account' + accId);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Account Sync Failed';
                
                List<Intacct__c> lstParentIntacct = 
                    [Select i.Is_Parent__c, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where 
                            i.account__c=:acc.Id and
                     		i.Type__c = 'Create Customer' and
                            i.Is_Parent__c=true and
                            i.Intacct_Response__c='Success'];
                
                if(lstParentIntacct==null || lstParentIntacct.size()==0)
                {
                    Intacct__c  objIntacct = new Intacct__c();
                    objIntacct.Account__c = acc.Id;
                    objIntacct.Request_XML__c = 'Request: ' + req + ' Body : ' + req.getBody();
                    objIntacct.Response_XML__c = res.getBody();
                    objIntacct.Intacct_Response__c = 'Failure';
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.Type__c='Create Customer';
                    system.debug('*****objIntacct*******'+objIntacct);  
                    insert objIntacct;
                }
                
            }
            update acc;
        }
    }
    
    @Future(callout=true)
    public static void SyncAccountToCustomerfuture(Id accId)
    {
		System.debug('Inside the method SyncAccountToCustomerfuture');        
        IntAcctOppSyncHelper.SyncAccountToCustomer_new(accId);
    }
    
     public static void bulkSyncAccountToCustomer(Account custAcct) {
        System.debug('****bulkSyncAccountToCustomer: ');
        if(custAcct!=null)
        {
            Account acc = custAcct;
            system.debug('******Inside HELPER**********');
            HttpRequest req = new HttpRequest();
            System.debug('******SyncAccountToCustomer UserInfo.getUserId*******' +UserInfo.getUserID());
            system.debug('******SyncAccountToCustomer API.Partner_Server_URL_70**********' +acc.APIServerUrl__c);
            
            Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAccountSyncUrl');
            System.debug('****appconstant: ' + appconstant);
            String endPointAccountSync = appconstant.Value__c + 'syncIntactAccount?accountId='+ acc.Id+'&sfdcAPIServerUrl='+acc.APIServerUrl__c;
            
            system.debug('******Encoded url **********' + endPointAccountSync);
            req.setTimeout(120000);
            req.setEndpoint(endPointAccountSync);
            req.setMethod('GET');
            String authorizationHeader = 'Basic ';
            //EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            Http http = new Http();
            system.debug('request ' + req);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
            if(res.getBody().containsIgnoreCase(acc.IntacctID__c) && res.getBody().containsIgnoreCase('updated successfully'))
            {
                System.debug('Account sync completed successsfully for the account' + acc.Id);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Migration Successful';
                updateAcctList.add(acc);
                
                List<Intacct__c> lstParentIntacct = 
                    [Select i.Is_Parent__c, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where 
                            i.account__c=:acc.Id and 
                            i.Is_Parent__c=true and
                            i.Intacct_Response__c='Success'];
                
                if(lstParentIntacct==null || lstParentIntacct.size()==0)
                {
                    Intacct__c  objIntacct = new Intacct__c();
                    objIntacct.Account__c = acc.Id;
                    objIntacct.Request_XML__c = 'Request: ' + req + ' Body : ' + req.getBody();
                    objIntacct.Response_XML__c = res.getBody();
                    objIntacct.Intacct_Response__c = 'Success';
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.Type__c='Create Customer';
                    system.debug('*****objIntacct*******'+objIntacct);  
                    insertIntacctLstInner.add(objIntacct);
                }
               
            }
            else
            {
                system.debug('Account sync failed for the account' + acc.Id);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Migration Failed';
                updateAcctList.add(acc);
                
                List<Intacct__c> lstParentIntacct = 
                    [Select i.Is_Parent__c, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where 
                            i.account__c=:acc.Id and 
                            i.Is_Parent__c=true and
                            i.Intacct_Response__c='Success'];
                
                if(lstParentIntacct==null || lstParentIntacct.size()==0)
                {
                    Intacct__c  objIntacct = new Intacct__c();
                    objIntacct.Account__c = acc.Id;
                    objIntacct.Request_XML__c = 'Request: ' + req + ' Body : ' + req.getBody();
                    objIntacct.Response_XML__c = res.getBody();
                    objIntacct.Intacct_Response__c = 'Failure';
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.Type__c='Create Customer';
                    system.debug('*****objIntacct*******'+objIntacct);  
                    insertIntacctLstInner.add(objIntacct);
                }                
            }
            //return acc;
        }
         //return custAcct;
    }
	
	/*OLD CODE commenting out the old code since now we will use only sync    
    @Future(callout=true)    
    public static void SyncAccountToCustomer(Id accId,boolean isCallOut) {
        List<Account> lstAccount;
        lstAccount =[Select a.Status__c,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:accId LIMIT 1];
        System.debug('****lstAccount: ' + lstAccount);
        if(lstAccount!=null && lstAccount.size()>0)
        {
            Account acc = lstAccount[0];
            system.debug('******Inside HELPER**********');
            HttpRequest req = new HttpRequest();
            System.debug('******SyncAccountToCustomer UserInfo.getUserId*******' +UserInfo.getUserID());
            system.debug('******SyncAccountToCustomer API.Partner_Server_URL_70**********' +acc.APIServerUrl__c);
            
            Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAccountSyncUrl');
            System.debug('****appconstant: ' + appconstant);
            String endPointAccountSync = appconstant.Value__c + 'syncIntactAccount?accountId='+ accId+'&sfdcAPIServerUrl='+acc.APIServerUrl__c;
            
            system.debug('******Encoded url **********' + endPointAccountSync);
            req.setEndpoint(endPointAccountSync);
            req.setMethod('GET');
            String authorizationHeader = 'Basic ';
            //EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            Http http = new Http();
            system.debug('request ' + req);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
            if(res.getBody().containsIgnoreCase(acc.IntacctID__c) && res.getBody().containsIgnoreCase('updated successfully'))
            {
                System.debug('Account sync completed successsfully for the account' + accId);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Account Successfully synced';
            }
            else
            {
                system.debug('Account sync failed for the account' + accId);
                //now update the intacct sync field on the account.
                acc.Intacct_Sync_At__c = System.Now();
                acc.Intacct_Sync_By__c = UserInfo.getUserId();
                acc.Intacct_Sync_Msg__c = 'Account Sync Failed';
            }
            update acc;
        }
    }
*/
    
    
    /*OLD Code commenting out, just using sync
    //@Future(callout=true)
    public static String IsCustomerExists(String intacctCustomerId) {
        List<String> computedResponses;
        List<String> KeyValues;
        String finalResult;
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint'); 
        endpoint=appconstant.Value__c;
        
        Dom.Document doc = new Dom.Document();
        List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
        
        doc.load(Constants.GetCustomerAccountXMLTemplate);
        nodelist =  doc.getRootElement().getChildElements();
        // Infuse data from the SOQL query into nodelist
        for (dom.XmlNode node : nodelist)
        {
            system.debug('*node***'+node);
            //system.debug('*objFieldName***'+objFieldName);
            if(node.getName() == 'operation')
            {
                List<dom.XmlNode> childnodelist =  node.getChildElements();
                for(dom.XmlNode childnode : childnodelist)
                {
                    system.debug('*childnode***'+childnode);                 
                    if(childnode.getName()=='content')
                    {
                        List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                        for(dom.Xmlnode nextchild: nextchildnodelist)
                        {
                            system.debug('*nextchild***'+nextchild);
                            if(nextchild.getName()=='function')                 
                            {
                                List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                for(dom.Xmlnode next2child: next2childnodelist)
                                {
                                    system.debug('*next2child***'+next2child);
                                    if(next2child.getName()=='get_list')                   
                                    {  
                                        dom.Xmlnode getList = next2child;
                                        
                                        dom.Xmlnode expression = getList.addChildElement('filter',null,null).addChildElement('expression',null,null);
                                        expression.addChildElement('field',null,null).addTextNode('customerid');
                                        expression.addChildElement('operator',null,null).addTextNode('=');
                                        expression.addChildElement('value',null,null).addTextNode(intacctCustomerId);
                                        getList.addChildElement('fields',null,null).addChildElement('field',null,null).addTextNode('customerId');
                                        
                                    }//end of if get_list
                                }
                            }
                        }
                    }
                }
            }
        }       
        
        xmlData = doc.toXmlString();
        
        system.debug('*****xmlData*******'+xmlData);
        system.debug('*****errorCounter*******'+errorCounter);
        system.debug('*****appErrorMsg*******'+appErrorMsg);
        
        //computedResponse=IntAcctOppSyncHelper.getContent(); 
        if (errorCounter == 0)
        {
            
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');  
            req.setheader('Content-type','x-intacct-xml-request');
            req.setHeader('Accept', 'application/xml');
            String body = xmlData;
            system.debug('*****req*******'+req);
            system.debug('*****xmlData*******'+xmlData);
            system.debug('*****body*******'+body);
            req.setTimeout(120000);
            req.setBody(body);  
            req.setEndpoint(endPoint);
            // Send the request, and return a response 
            system.debug('*****req*******'+req); 
            system.debug('*****isApexBeingTested*******'+isApexBeingTested); 
            if (!isApexBeingTested){
                res = h.send(req);
                system.debug('*****res*******'+res); 
                responseXML = res.getBody();
                system.debug('*****responseXML*******'+responseXML); 
            }
            else{
                responseXML = testRes;
            }
            
            system.debug('*****responseXML*******'+responseXML);  
            Dom.Document responsedoc = new Dom.Document();
            if (!isApexBeingTested){
                responsedoc = res.getBodyDocument();
                system.debug('*****responsedoc*******'+responsedoc);  
                dom.XmlNode OperationNode =  responsedoc.getRootElement().getChildElement('operation', null) ;
                system.debug('*****OperationNode*******'+OperationNode);
                dom.XmlNode OperationResultNode =  OperationNode.getChildElement('result', null) ;
                system.debug('*****OperationResultNode*******'+OperationResultNode);
                dom.XmlNode ResultNode =  OperationResultNode.getChildElement('status', null) ;
                system.debug('*****ResultNode*******'+ResultNode);
                
                if (ResultNode!=null && ResultNode.getText() == 'success'){
                    dom.XmlNode dataNode = OperationResultNode.getChildElement('data', null);
                    if(dataNode!=null )
                    {
                     finalResult='Success';   
                    }
                	else
                     finalResult='Failure';   
                }
                else{
                   	finalResult='Failure';   
                }
            }
            else{
                finalResult = 'Success';
            }
            
            system.debug('*****computedResponse*******'+computedResponse);
            
        }  
        if (isApexBeingTested){
            finalResult = 'Success';
        } 
        //---------------------------------------------------------------------
        return finalResult;
    }//end of  GetRecordKey
    */
    
    public static string getContent() {
        // Instantiate a new http object 
        
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
        
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        req.setMethod('POST');  
        req.setheader('Content-type','x-intacct-xml-request');
        req.setHeader('Accept', 'application/xml');
        String body = xmlData;
        system.debug('*****req*******'+req);
        system.debug('*****xmlData*******'+xmlData);
        system.debug('*****body*******'+body);
        
        req.setBody(body);  
        req.setEndpoint(endPoint);
        // Send the request, and return a response 
        system.debug('*****req*******'+req); 
        system.debug('*****isApexBeingTested*******'+isApexBeingTested); 
        if (!isApexBeingTested){
            res = h.send(req);
            system.debug('*****res*******'+res); 
            responseXML = res.getBody();
            system.debug('*****responseXML*******'+responseXML); 
        }
        else{
            responseXML = testRes;
        }
        
        system.debug('*****responseXML*******'+responseXML);  
        Dom.Document doc = new Dom.Document();
        if (!isApexBeingTested){
            doc = res.getBodyDocument();
            system.debug('*****doc*******'+doc);  
            dom.XmlNode OperationNode =  doc.getRootElement().getChildElement('operation', null) ;
            system.debug('*****OperationNode*******'+OperationNode);
            dom.XmlNode OperationResultNode =  OperationNode.getChildElement('result', null) ;
            system.debug('*****OperationResultNode*******'+OperationResultNode);
            dom.XmlNode ResultNode =  OperationResultNode.getChildElement('status', null) ;
            system.debug('*****ResultNode*******'+ResultNode);
            dom.XmlNode KeyNode = OperationResultNode.getChildElement('key', null);
            system.debug('*****KeyNode*******'+KeyNode);
            
            if (ResultNode.getText() == 'success'){
                computedResponse = 'Success';
                if(KeyNode!=null)
                    computedResponse= computedResponse + '#' + KeyNode.getText();
            }
            
            else{
                computedResponse = 'Failure';
                
            }
        }
        else{
            computedResponse = 'Failure';
        }
        
        system.debug('*****computedResponse*******'+computedResponse);
        return  computedResponse;     
    }
    
    @Future(callout=true)
    public static void CreateSalesOrder(Id OppId, Id IntacctId, Id PaymentRecId, Boolean isServiceCredit, Id PrevMatchOppId, List<Id> payListIds,String Type) {
        List<Opportunity> lstOpportunities;
        List<OpportunityLineItem> lstOppProducts;
        List<String> computedResponses;
        List<String> KeyValues;
        List<Intacct__c> lstIntacct;
        List<Intacct__c> lstParentIntacct;
        insertIntacctList = new List<Intacct__c>();
        
        if(Type!='')
            IntAcctOppSyncHelper.matchType= Type;
            
        
        if(paymentRecId!=null)
			IntAcctOppSyncHelper.paymentId= paymentRecId;
        else
            IntAcctOppSyncHelper.paymentId = null;
        
        //system.debug('******Inside CreateSalesOrder**********'+OppId+'**********'+IntacctId);
        System.debug('paylist ids after calling intacct in salesorder method ' + payListIds);
        lstOpportunities = [Select id,AccountId,Intacct_Customer__c,StageName,Reason__c,ChildOppType__c,Reason_Detail__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                            Engagement_End__c,Matched_pt_Account__c,Parent_Opportunity__c,CurrencyIsoCode from Opportunity where id=:OppId LIMIT 1];
        System.debug('****lstOpportunities: ' + lstOpportunities);
        
        //lstOppProducts=[Select Id, Intacct_Department__c,PricebookEntryId,PricebookEntry.ProductCode, OpportunityId,  CurrencyIsoCode, Quantity, UnitPrice, Due_Date__c From OpportunityLineItem where OpportunityId=:lstOpportunities[0].Id and PricebookEntry.Product2.ChildOppType__c=:lstOpportunities[0].ChildOppType__c];
        
        lstOppProducts=[Select Id, Intacct_Department__c,PricebookEntryId,PricebookEntry.ProductCode, 
                        Intacct_Location__c, OpportunityId,  CurrencyIsoCode, Quantity, UnitPrice, 
                        Due_Date__c From OpportunityLineItem where OpportunityId=:lstOpportunities[0].Id];
        
        lstParentIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where 
                            i.account__c=:lstOpportunities[0].AccountId and 
                            i.Is_Parent__c=true and
                            i.Intacct_Response__c='Success'];
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint');
        System.debug('****appconstant: ' + appconstant);
        endpoint=appconstant.Value__c;
        
        if(lstOpportunities!=null && lstOpportunities.size()>0)
        {
            
            For(Opportunity opp:lstOpportunities)
            {
                
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                
                Dom.Document doc = new Dom.Document();
                List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
                
                doc.load(Constants.CreateSOXMLTemplate);
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    system.debug('*node***'+node);
                    
                    //system.debug('*objFieldName***'+objFieldName);
                    if(node.getName() == 'operation')
                    {
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for(dom.XmlNode childnode : childnodelist)
                        {
                            system.debug('*childnode***'+childnode);                 
                            if(childnode.getName()=='content')
                            {
                                List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                                for(dom.Xmlnode nextchild: nextchildnodelist)
                                {system.debug('*nextchild***'+nextchild);
                                 if(nextchild.getName()=='function')                 
                                 {
                                     List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                     for(dom.Xmlnode next2child: next2childnodelist)
                                     {
                                         system.debug('*next2child***'+next2child);
                                         if(next2child.getName()=='create_sotransaction')                   
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName = Constants.IntAcctXMLNodeSO2SObjField.get(next3child.getName());
                                                 system.debug('*objFieldName***'+objFieldName);  
                                                 
                                                 if (next3child.getName() == 'datecreated'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next31childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next31child: next31childnodelist)
                                                     {                           
                                                         if (next31child.getName() == 'year'){                                                   
                                                             next31child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next31child.getName() == 'month'){                                                 
                                                             next31child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next31child.getName() == 'day'){                                                   
                                                             next31child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }                       
                                                 
                                                 else if (next3child.getName() == 'customerid'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'datedue'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next32childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next32child: next32childnodelist)
                                                     {                           
                                                         if (next32child.getName() == 'year'){                                                   
                                                             next32child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next32child.getName() == 'month'){                                                 
                                                             next32child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next32child.getName() == 'day'){                                                   
                                                             next32child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }                  
                                                 else if (next3child.getName() == 'basecurr'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'currency'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 if (next3child.getName() == 'exchratedate'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next31childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next31child: next31childnodelist)
                                                     {                           
                                                         if (next31child.getName() == 'year'){                                                   
                                                             next31child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next31child.getName() == 'month'){                                                 
                                                             next31child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next31child.getName() == 'day'){                                                   
                                                             next31child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'customfields'){
                                                     List<dom.XmlNode> next33childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next33child: next33childnodelist)
                                                     {                           
                                                         if (next33child.getName() == 'customfield'){                                                
                                                             List<dom.XmlNode> next331childnodelist =  next33child.getChildElements();
                                                             for(dom.Xmlnode next331child: next331childnodelist)
                                                             {                                  
                                                                 if(next331child.getName() == 'customfieldname')
                                                                 {
                                                                     if(next331child.getText() == 'SFDCOPPID' ||
                                                                        next331child.getText() == 'AUPAIR_NAME' ||
                                                                        next331child.getText() == 'START_DATE' ||
                                                                        next331child.getText() == 'END_DATE' )
                                                                     {
                                                                         String oppfieldName = Constants.IntAcctXMLNodeSO2SObjField.get(next331child.getText());
                                                                         if (opp.get(oppfieldName)!= null)
                                                                         {
                                                                         String textVal='';
                                                                         if(oppfieldName == 'Engagement_Start__c' || oppfieldName == 'Engagement_End__c')
                                                                         {
                                                                             Date dt = (Date)opp.get(oppfieldName);
                                                                             textVal=string.valueof(dt.month()) +'/'+string.valueOf(dt.day())
                                                                                 +'/'+string.valueOf(dt.year());
                                                                         }
                                                                         else
                                                                             textval = (String)opp.get(oppfieldName);
                                                                         next33child.addChildElement('customfieldvalue',null,null).addTextNode(textval);                              
                                                                     }
                                                                     else{
                                                                         next33child.addChildElement('customfieldvalue',null,null).addTextNode('');
                                                                     }
                                                                   }
                                                                 }
                                                             }
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'sotransitems'){
                                                     //PricebookEntry ObjPriceBookEntry;
                                                     for(OpportunityLineItem olitem:lstOppProducts)
                                                     {   
                                                         //ObjPriceBookEntry = [Select p.ProductCode, p.Id From PricebookEntry p where p.Id =:olitem.PricebookEntryId];  
                                                         dom.Xmlnode NewSOTransItem = next3child.addChildElement('sotransitem',null,null);
                                                         
                                                         NewSOTransItem.addChildElement('itemid',null,null).addTextNode(olitem.PricebookEntry.ProductCode);
                                                         NewSOTransItem.addChildElement('warehouseid',null,null).addTextNode('Default Warehouse');
                                                         NewSOTransItem.addChildElement('quantity',null,null).addTextNode(string.valueof(olitem.Quantity));
                                                         NewSOTransItem.addChildElement('unit',null,null).addTextNode('Each');
                                                         NewSOTransItem.addChildElement('price',null,null).addTextNode(string.valueof(olitem.UnitPrice));
                                                         
                                                         NewSOTransItem.addChildElement('locationid',null,null).addTextNode(string.valueof(olitem.Intacct_Location__c));
                                                         NewSOTransItem.addChildElement('departmentid',null,null).addTextNode('100');
                                                         
                                                         NewSOTransItem.addChildElement('memo',null,null).addTextNode('MEMO');
                                                         
                                                         dom.XmlNode customField = NewSOTransItem.addChildElement('customfields',null,null).addChildElement('customfield',null,null);
                                                         customField.addChildElement('customfieldname',null,null).addTextNode('DUE_DATE');
                                                         datetime dt= olitem.due_date__c;
                                                         customField.addChildElement('customfieldvalue',null,null).addTextNode(string.valueof(dt.format('MM/dd/YYYY')));
                                                         
                                                         NewSOTransItem.addChildElement('revrectemplate',null,null).addTextNode('100 at Invoicing');
                                                         dom.XmlNode revrecstartdate = NewSOTransItem.addChildElement('revrecstartdate',null,null);
                                                         date date1 =  system.today()+30;
                                                         string daytag = String.valueof(date1.day());
                                                         string monthtag = String.valueof(date1.month());
                                                         string yeartag = String.valueof(date1.year());
                                                         revrecstartdate.addChildElement('year',null,null).addTextNode(yeartag);
                                                         revrecstartdate.addChildElement('month',null,null).addTextNode(monthtag);
                                                         revrecstartdate.addChildElement('day',null,null).addTextNode(daytag);
                                                         
                                                         NewSOTransItem.addChildElement('customerid',null,null).addTextNode(string.valueof(opp.Intacct_Customer__c));                           
                                                         
                                                         
                                                     } //FOR OPPORTUNITY
                                                 }//SOTRANSITEMS                   
                                                 
                                             }}}}}}}}} 
                // Infuse data from the SOQL query into nodelist         
                Intacct__c  objIntacct;  
                xmlData = doc.toXmlString();
                string KeyValue;
                string Docno;
                system.debug('*****xmlData*******'+xmlData);
                system.debug('*****errorCounter*******'+errorCounter);
                system.debug('*****appErrorMsg*******'+appErrorMsg);
                if (errorCounter == 0)
                    computedResponse=IntAcctOppSyncHelper.getContent();
                else
                    {
                        objIntacct = new Intacct__c();
                        objIntacct.Account__c = opp.AccountId;
                    	objIntacct.Request_XML__c = xmldata;
                    	objIntacct.Response_XML__c = 'Something went wrong in constructing the request xml.' + 'Error Counter: ' + errorCounter
                        	+ 'appErrorMsg: ' + appErrorMsg ;
                    	objIntacct.Intacct_Response__c = 'Failure';
                    	objIntacct.Last_Sync_Date__c=system.now();
                        objIntacct.opportunity__c=opp.Id;
                        objIntacct.Type__c='Create Sales Order';
                        objIntacct.Parent_Intacct__c=IntacctId;
                        insertIntacctList.Add(objIntacct);
                        system.debug('*****objIntacct*******'+objIntacct);  
                        insert insertIntacctList;
                        return;
                    }
                
                system.debug('*****computedResponse*******'+computedResponse);                               
                if(computedResponse!=null && computedResponse.contains('#'))                         
                {
                    computedResponses = computedResponse.split('#',2);
                }
                if(computedResponses!=null)
                {
                    KeyValue = computedResponses[1];
                    if(KeyValue.contains('-'))                         
                    {
                        KeyValues = KeyValue.split('-',2);
                    }
                    Docno = KeyValues[1];
                    computedResponse = computedResponses[0];
                    
                    system.debug('*****KeyValue*******'+KeyValue);  
                    system.debug('*****computedResponses*******'+computedResponses);
                    system.debug('*****computedResponse*******'+computedResponse);
                }
                
                if(computedResponse!=null)
                {
                    if(lstParentIntacct!=null && lstParentIntacct.size()>0) //&& (!(lstIntacct!=null && lstIntacct.size()>0)))
                    {
                        //for(Intacct__c intacct:lstParentIntacct)    
                        //{
                            objIntacct = new Intacct__c();
                            objIntacct.Account__c = opp.AccountId;
                            objIntacct.Request_XML__c = xmldata;
                        	objIntacct.Response_XML__c = responseXML;
                            objIntacct.Intacct_Response__c = computedResponse;
                            objIntacct.Last_Sync_Date__c=system.now();
                            objIntacct.opportunity__c=opp.Id;
                            objIntacct.Type__c='Create Sales Order';
                            objIntacct.Parent_Intacct__c=IntacctId;
                            objIntacct.Intacct_Document_No__c = Docno;
                            insertIntacctList.Add(objIntacct);
                            //insert objIntacct;
                            system.debug('*****objIntacct*******'+objIntacct);
                            
                        //}
                    	}
                    
                    system.debug('*****lstIntacct*******'+lstIntacct);  
                    system.debug('*****lstParentIntacct*******'+lstParentIntacct);  
                    If(computedResponse=='Success'  && lstParentIntacct!=null && lstParentIntacct.size()>0 )
                    {
                        if (!Test.isRunningTest()){
                            IntAcctOppSyncHelper.CreateRevContract(opp.Id,opp.AccountId,lstParentIntacct[0].Id,KeyValue,Docno,isServiceCredit,PrevMatchOppId,payListIds);
                        }
                    }
                    //Insert all the intaccct records SO,RC,SI and AR update
                    insert insertIntacctList;
                    IntAcctOppSyncHelper.paymentId=null;
                    IntAcctOppSyncHelper.ARUpdateKey='';
                    system.debug('****objIntacct-SO*******'+objIntacct);  
                    
                }
                else
                {
                    System.debug('Sales Order - Computed response is null');
                    //computer response is null. 
                    objIntacct = new Intacct__c();
                    objIntacct.Account__c = opp.AccountId;
                    objIntacct.Request_XML__c = xmldata;
                    objIntacct.Response_XML__c = responseXML;
                    //objIntacct.Intacct_Response__c = computedResponse;
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.opportunity__c=opp.Id;
                    objIntacct.Type__c='Create Sales Order';
                    objIntacct.Parent_Intacct__c=IntacctId;
                    insertIntacctList.Add(objIntacct);
                    
                    system.debug('*****objIntacct*******'+objIntacct);
                    
                    //Insert all the intaccct records SO,RC,SI and AR update
                    insert insertIntacctList;
                    IntAcctOppSyncHelper.paymentId=null;
                    IntAcctOppSyncHelper.ARUpdateKey='';
                    system.debug('****objIntacct-SO*******'+objIntacct);   
                }
                
            }
        }
        //  return computedResponse;
    }
    
    public static void CreateRevContract(Id OppId,Id OppAccountId, Id IntacctId, String KeyValue, String Docno, Boolean isServiceCredit, Id PrevMatchOppId, List<Id> payListIds) 
    {
        List<Opportunity> lstOpportunities;
        List<OpportunityLineItem> lstOppProducts;  
        List<String> computedResponses;
        List<String> KeyValues;
        List<Intacct__c>  lstIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where i.opportunity__c=:OppId and i.Is_Parent__c!=true and Type__c='Create Revenue Contract'];
        lstOpportunities = [Select id,Intacct_Customer__c,AccountId,StageName,Reason__c,Reason_Detail__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                            Engagement_End__c,Matched_pt_Account__c,Parent_Opportunity__c,CurrencyIsoCode from Opportunity where id=:OppId LIMIT 1];
        System.debug('****lstOpportunities: ' + lstOpportunities);
        lstOppProducts=[Select Id, Intacct_Department__c,PricebookEntryId,PricebookEntry.ProductCode, Intacct_Location__c,
                        OpportunityId,  CurrencyIsoCode, Quantity, UnitPrice,Due_Date__c From OpportunityLineItem 
                        where OpportunityId=:lstOpportunities[0].Id];
        System.debug('paylist ids after calling intacct in CreateRevContract method ' + payListIds);
        if(lstOpportunities!=null && lstOpportunities.size()>0)
        {
            
            For(Opportunity opp:lstOpportunities)
            {
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                
                Dom.Document doc = new Dom.Document();
                List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
                //PricebookEntry ObjPriceBookEntry;
                doc.load(Constants.CreateRCXMLTemplate);
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    system.debug('*node***'+node);
                    
                    //system.debug('*objFieldName***'+objFieldName);
                    if(node.getName() == 'operation')
                    {
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for(dom.XmlNode childnode : childnodelist)
                        {
                            system.debug('*childnode***'+childnode);                 
                            if(childnode.getName()=='content')
                            {
                                List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                                for(dom.Xmlnode nextchild: nextchildnodelist)
                                {system.debug('*nextchild***'+nextchild);
                                 if(nextchild.getName()=='function')                 
                                 {
                                     List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                     for(dom.Xmlnode next2child: next2childnodelist)
                                     {
                                         system.debug('*next2child***'+next2child);
                                         if(next2child.getName()=='create_sotransaction')                   
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName = Constants.IntAcctXMLNodeSO2SObjField.get(next3child.getName());
                                                 system.debug('*objFieldName***'+objFieldName);  
                                                 
                                                 if (next3child.getName() == 'datecreated'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next31childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next31child: next31childnodelist)
                                                     {                           
                                                         if (next31child.getName() == 'year'){                                                   
                                                             next31child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next31child.getName() == 'month'){                                                 
                                                             next31child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next31child.getName() == 'day'){                                                   
                                                             next31child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'createdfrom'){                       
                                                     next3child.addTextNode(KeyValue);                              
                                                 }                                   
                                                 else if (next3child.getName() == 'customerid'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'documentno'){                       
                                                     next3child.addTextNode(Docno);                              
                                                 }
                                                 else if (next3child.getName() == 'datedue'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next32childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next32child: next32childnodelist)
                                                     {                           
                                                         if (next32child.getName() == 'year'){                                                   
                                                             next32child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next32child.getName() == 'month'){                                                 
                                                             next32child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next32child.getName() == 'day'){                                                   
                                                             next32child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }                  
                                                 else if (next3child.getName() == 'basecurr'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'currency'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 if (next3child.getName() == 'exchratedate'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next31childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next31child: next31childnodelist)
                                                     {                           
                                                         if (next31child.getName() == 'year'){                                                   
                                                             next31child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next31child.getName() == 'month'){                                                 
                                                             next31child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next31child.getName() == 'day'){                                                   
                                                             next31child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'customfields'){
                                                     List<dom.XmlNode> next33childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next33child: next33childnodelist)
                                                     {                           
                                                         if (next33child.getName() == 'customfield'){                                                
                                                             List<dom.XmlNode> next331childnodelist =  next33child.getChildElements();
                                                             for(dom.Xmlnode next331child: next331childnodelist)
                                                             {
                                                                 if(next331child.getName() == 'customfieldname')
                                                                 {
                                                                     if(next331child.getText() == 'SFDCOPPID' ||
                                                                        next331child.getText() == 'AUPAIR_NAME' ||
                                                                        next331child.getText() == 'START_DATE' ||
                                                                        next331child.getText() == 'END_DATE' )
                                                                     {
                                                                         String oppfieldName = Constants.IntAcctXMLNodeSO2SObjField.get(next331child.getText());
                                                                         if (opp.get(oppfieldName)!= null)
                                                                         {
                                                                         String textVal='';
                                                                         if(oppfieldName == 'Engagement_Start__c' || oppfieldName == 'Engagement_End__c')
                                                                         {
                                                                             Date dt = (Date)opp.get(oppfieldName);
                                                                             textVal=string.valueof(dt.month()) +'/'+string.valueOf(dt.day())
                                                                                 +'/'+string.valueOf(dt.year());
                                                                         }
                                                                         else
                                                                             textval = (String)opp.get(oppfieldName);
                                                                         next33child.addChildElement('customfieldvalue',null,null).addTextNode(textval);                              
                                                                     }
                                                                     else{
                                                                         next33child.addChildElement('customfieldvalue',null,null).addTextNode('');
                                                                     }
                                                                   }
                                                                 }

                                                             }
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'sotransitems'){
                                                     
                                                     //PricebookEntry ObjPriceBookEntry;
                                                     for(OpportunityLineItem olitem:lstOppProducts)
                                                     {   
                                                         //ObjPriceBookEntry = [Select p.ProductCode, p.Id From PricebookEntry p where p.Id =:olitem.PricebookEntryId];  
                                                         dom.Xmlnode NewSOTransItem = next3child.addChildElement('sotransitem',null,null);
                                                         
                                                         NewSOTransItem.addChildElement('itemid',null,null).addTextNode(olitem.PricebookEntry.ProductCode);
                                                         NewSOTransItem.addChildElement('warehouseid',null,null).addTextNode('Default Warehouse');
                                                         NewSOTransItem.addChildElement('quantity',null,null).addTextNode(string.valueof(olitem.Quantity));
                                                         NewSOTransItem.addChildElement('unit',null,null).addTextNode('Each');
                                                         NewSOTransItem.addChildElement('price',null,null).addTextNode(string.valueof(olitem.UnitPrice));
                                                         
                                                         NewSOTransItem.addChildElement('locationid',null,null).addTextNode(string.valueof(olitem.Intacct_Location__c));
                                                         NewSOTransItem.addChildElement('departmentid',null,null).addTextNode('100');
                                                         NewSOTransItem.addChildElement('memo',null,null).addTextNode('MEMO');
                                                         
                                                         dom.XmlNode customField = NewSOTransItem.addChildElement('customfields',null,null).addChildElement('customfield',null,null);
                                                         customField.addChildElement('customfieldname',null,null).addTextNode('DUE_DATE');
                                                         datetime dt= olitem.due_date__c;
                                                         customField.addChildElement('customfieldvalue',null,null).addTextNode(string.valueof(dt.format('MM/dd/YYYY')));
                                                         
                                                         NewSOTransItem.addChildElement('revrectemplate',null,null).addTextNode('100 at Invoicing');
                                                         dom.XmlNode revrecstartdate = NewSOTransItem.addChildElement('revrecstartdate',null,null);
                                                         date date1 =  system.today()+30;
                                                         string daytag = String.valueof(date1.day());
                                                         string monthtag = String.valueof(date1.month());
                                                         string yeartag = String.valueof(date1.year());
                                                         revrecstartdate.addChildElement('year',null,null).addTextNode(yeartag);
                                                         revrecstartdate.addChildElement('month',null,null).addTextNode(monthtag);
                                                         revrecstartdate.addChildElement('day',null,null).addTextNode(daytag);
                                                         
                                                         NewSOTransItem.addChildElement('customerid',null,null).addTextNode(string.valueof(opp.Intacct_Customer__c));                           
                                                         
                                                         
                                                     } //FOR OPPORTUNITY
                                                     
                                                     
                                                 }
                                             }                 
                                             
                                         }}}}}}}}       
                
                xmlData = doc.toXmlString();
                string RCKeyValue;
                string RCDocno;
                system.debug('*****xmlData*******'+xmlData);
                system.debug('*****errorCounter*******'+errorCounter);
                system.debug('*****appErrorMsg*******'+appErrorMsg);
                
                Intacct__c  objIntacct;
                if (errorCounter == 0)
                    computedResponse=IntAcctOppSyncHelper.getContent();
                else
                    {
                        objIntacct = new Intacct__c();
                        objIntacct.Account__c = OppAccountId;
                    	objIntacct.Request_XML__c = xmldata;
                    	objIntacct.Response_XML__c = 'Something went wrong in constructing the request xml.' + 'Error Counter: ' + errorCounter
                        	+ 'appErrorMsg: ' + appErrorMsg ;
                    	objIntacct.Intacct_Response__c = 'Failure';
                    	objIntacct.Last_Sync_Date__c=system.now();
                        objIntacct.opportunity__c=OppId;
                        objIntacct.Type__c='Create Revenue Contract';
                        objIntacct.Parent_Intacct__c=IntacctId;
                        insertIntacctList.Add(objIntacct);
                        system.debug('*****objIntacct*******'+objIntacct);  
                        //insert insertIntacctList;
                        return;
                    }
                
                system.debug('*****computedResponse*******'+computedResponse);                               
                if(computedResponse!=null && computedResponse.contains('#'))                         
                {
                    computedResponses = computedResponse.split('#',2);
                }
                if(computedResponses!=null)
                {
                    RCKeyValue = computedResponses[1];
                    if(RCKeyValue.contains('-'))                         
                    {
                        KeyValues = RCKeyValue.split('-',2);
                    }
                    RCDocno = KeyValues[1];
                    computedResponse = computedResponses[0];
                    system.debug('*****RCKeyValue*******'+RCKeyValue);  
                    system.debug('*****computedResponses*******'+computedResponses); 
                    system.debug('*****computedResponse*******'+computedResponse); 
                }
                  
                if(computedResponse!=null)
                {
                    objIntacct = new Intacct__c();
                    objIntacct.Account__c = OppAccountId;
                    objIntacct.Request_XML__c = xmldata;
                    objIntacct.Response_XML__c = responseXML;
                    objIntacct.Intacct_Response__c = computedResponse;
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.opportunity__c=OppId;
                    objIntacct.Type__c='Create Revenue Contract';
                    objIntacct.Parent_Intacct__c=IntacctId;
                    objIntacct.Intacct_Document_No__c = RCDocno;
                    insertIntacctList.Add(objIntacct);
                }
                else
                {
                    System.debug('Revenue Contract - Computed response is null');
                    objIntacct = new Intacct__c();
                    objIntacct.Account__c = OppAccountId;
                    objIntacct.Request_XML__c = xmldata;
                    objIntacct.Response_XML__c = responseXML;
                    //objIntacct.Intacct_Response__c = computedResponse;
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.opportunity__c=OppId;
                    objIntacct.Type__c='Create Revenue Contract';
                    objIntacct.Parent_Intacct__c=IntacctId;
                    insertIntacctList.Add(objIntacct);
                    system.debug('*****objIntacct*******'+objIntacct);
                }
                
                if (!Test.isRunningTest()){
                    If(computedResponse=='Success' && IntAcctOppSyncHelper.matchType!='Rematch')
                    {
                        IntAcctOppSyncHelper.divideSIOnDueDate(OppId,OppAccountId,IntacctId,RCKeyValue,RCDocno);
                        
                        //Now do ARUpdate if there is any payment made and if there is a sales invoice
                        if(IntAcctOppSyncHelper.matchType!='Rematch')
                        {
                            if(IntAcctOppSyncHelper.PaymentId!=null && !String.isBlank(IntAcctOppSyncHelper.PaymentId))
                            {
                                System.debug('****Before calling AR update IntAcctOppSyncHelper.PaymentRecId '  + IntAcctOppSyncHelper.PaymentId);
                                IntAcctOppSyncHelper.CreateAccountReceivables(OppId,OppAccountId,IntacctId);
                            }
                            else if(isServiceCredit = true && PrevMatchOppId !=null && payListIds!=null)
                            {
                                //find out if there are any outstanding invoices on the previous match opportunity.
                                //If yes, then close them with the service credit that we just received.
                                System.debug('ServiceCredit is true and PrevMatchOppId and payListIds' + PrevMatchOppId + payListIds);
                                List<Payment__c> paymentList = [Select id,Account_Name__c,Opportunity_Name__c,Txn_Amount__c,
                                                                Txn_Id__c
                                                                from Payment__c where id in :payListIds];
                                
                                if(paymentList!=null && paymentList.size()>0)
                                {
                                    System.debug('outstanding sales invoices : ' + paymentList);
                                    for(Payment__c payment:paymentList)
                                    {
                                        IntAcctOppSyncHelper.ApplyAccountReceivables(OppId,OppAccountId,IntacctId,
                                                                                     payment.Txn_Id__c,ARUpdateKey,payment.Txn_Amount__c);
                                    }
                                }
                            }
                            else
                                System.debug('****There is no payment made. Hence no AR Update is done.');
                        }
                    }
                    
                    If(computedResponse=='Success' && IntAcctOppSyncHelper.matchType=='Rematch')
                        IntAcctOppSyncHelper.divideSIOnDueDateARupdate(OppId,OppAccountId,IntacctId,RCKeyValue,RCDocno,payListIds);
                }
            }
        }
    }
    
    public static void divideSIOnDueDate(Id OppId,Id OppAccountId, Id IntacctId,String RCKeyValue, String RCDocno){
        List<AggregateResult> lstOlItemDueDates;
        List<OpportunityLineItem> lstOppProducts; 
        List<Date> lstDueDates;
        if(OppId != null)
        {
            //first get the list of different due dates.
            lstOlItemDueDates = [Select due_date__c From OpportunityLineItem where OpportunityId=:OppId
                                 GROUP BY due_date__c order by due_date__c asc];
            if(lstOlItemDueDates!= null && lstOlItemDueDates.size()>0)
            {
                System.debug('lstDueDates:' + lstOlItemDueDates);
                Integer counter=0;
                //now loop through the distinct due dates, get the opportunity products and call the createSalesInvoice method.
                for(AggregateResult OLdueDate: lstOlItemDueDates)
                {
                    counter = counter + 1;
                    System.debug('rcdocno' + RCDocno + '-' + String.valueof(counter));
                    Date dueDate = (date)OLdueDate.get('due_date__c');
                    System.debug('due date1 : ' + OLdueDate.get('due_date__c') + 'due date2 ' + dueDate);
                    lstOppProducts=[Select Id, Intacct_Department__c,PricebookEntryId,PricebookEntry.ProductCode, Intacct_Location__c,
                                    OpportunityId,  CurrencyIsoCode, Quantity, UnitPrice,due_date__c From OpportunityLineItem 
                                    where OpportunityId=:OppId and due_date__c = :dueDate order by unitPrice desc];
                    if(lstOppProducts !=null && lstOppProducts.size()>0)
                    {
                        if(counter==1)
                            ARUpdateKey=RCDocno + '-' + String.valueof(counter);
                        
                        System.debug('lstOppProducts:' + lstOppProducts);
                        String response;
                        response = CreateSalesInvoice(OppId,OppAccountId,IntacctId,RCKeyValue,RCDocno + '-' + String.valueof(counter) ,lstOppProducts,dueDate);
                        System.debug('Resposne from CreateSalesInvoice method:' + response);
                    }
                    
                }
            }
        }
    }
    
    public static void divideSIOnDueDateARupdate(Id OppId,Id OppAccountId, Id IntacctId,String RCKeyValue, String RCDocno, List<Id> payListIds)
    {
        List<AggregateResult> lstOlItemDueDates;
        List<OpportunityLineItem> lstOppProducts; 
        List<Date> lstDueDates;
        if(OppId != null)
        {
            //first get the list of different due dates.
            lstOlItemDueDates = [Select due_date__c From OpportunityLineItem where OpportunityId=:OppId
                                 GROUP BY due_date__c order by due_date__c asc];
            if(lstOlItemDueDates!= null && lstOlItemDueDates.size()>0)
            {
                System.debug('lstDueDates:' + lstOlItemDueDates);
                Integer counter=0;
                //now loop through the distinct due dates, get the opportunity products and call the createSalesInvoice method.
                for(AggregateResult OLdueDate: lstOlItemDueDates)
                {
                    counter = counter + 1;
                    System.debug('rcdocno' + RCDocno + '-' + String.valueof(counter));
                    Date dueDate = (date)OLdueDate.get('due_date__c');
                    System.debug('due date1 : ' + OLdueDate.get('due_date__c') + 'due date2 ' + dueDate);
                    lstOppProducts=[Select Id, Intacct_Department__c,PricebookEntryId,PricebookEntry.ProductCode, Intacct_Location__c,
                                    OpportunityId,  CurrencyIsoCode, Quantity, UnitPrice,due_date__c From OpportunityLineItem 
                                    where OpportunityId=:OppId and due_date__c = :dueDate order by unitPrice desc];
                    if(lstOppProducts !=null && lstOppProducts.size()>0)
                    {
                        if(counter==1)
                            ARUpdateKey=RCDocno + '-' + String.valueof(counter);
                        
                        System.debug('lstOppProducts:' + lstOppProducts);
                        String response;
                        response = CreateSalesInvoice(OppId,OppAccountId,IntacctId,RCKeyValue,RCDocno + '-' + String.valueof(counter) ,lstOppProducts,dueDate);
                        
                        //check if there is manual payment done by the user.
                        if(response=='Success')
                        {   
                            if(counter==1 && IntAcctOppSyncHelper.PaymentId!=null && !String.isBlank(IntAcctOppSyncHelper.PaymentId))
                            {
                                System.debug('****Before calling AR update IntAcctOppSyncHelper.PaymentRecId '  + IntAcctOppSyncHelper.PaymentId);
                                IntAcctOppSyncHelper.CreateAccountReceivables(OppId,OppAccountId,IntacctId);
                            }
                            
                            if(payListIds!=null && payListIds.size()>=counter)
                            {
                                //that means we have some service credit payment too.
                                List<Payment__c> paymentList = [Select id,Account_Name__c,Opportunity_Name__c,Txn_Amount__c,
                                                                Txn_Id__c
                                                                from Payment__c where id = :payListIds.get(counter-1)];
                                
                                List<Sales_Invoice__c> ServiceCreditSIs = [Select id,Account__c,Amount_Due__c,Total__c,Document_Type__c,Document_Number__c,
                                                                           Opportunity__c,Payment_Status__c,Name,Opportunity__r.childOppType__c
                                                                           from 	Sales_Invoice__c
                                                                           where	Account__c = :OppAccountId 
                                                                           and Opportunity__r.childOppType__c = 'Match Break'
                                                                           and	(Payment_Status__c = 'Open' or payment_Status__c = 'Partially Paid' or payment_status__c = '') 
                                                                           and	Document_type__c = 'Sales Invoice'
                                                                           and Total__c <= 0 order by Createddate desc limit 1];
                                
                                if(paymentList!=null && paymentList.size()>0 && ServiceCreditSIs!=null && ServiceCreditSIs.size()>0 )
                                {
                                    System.debug('outstanding sales invoices : ' + paymentList);
                                    IntAcctOppSyncHelper.ApplyAccountReceivables(OppId,OppAccountId,IntacctId,
                                                                                 RCDocno + '-' + String.valueof(counter),ServiceCreditSIs[0].Document_Number__c,paymentList[0].Txn_Amount__c);
                                }
                                
                            }
                        }
                        System.debug('Resposne from CreateSalesInvoice method:' + response);
                    }
                }                  
            }
        }
    }
                          
    public static string CreateSalesInvoice(Id OppId,Id OppAccountId, Id IntacctId,String RCKeyValue, String RCDocno, List<OpportunityLineItem> lstOppProducts,Date dueDate) {
        List<String> computedResponses;
        List<String> KeyValues;
        List<Opportunity> lstOpportunities;
        List<Intacct__c>  lstIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where i.opportunity__c=:OppId and i.Is_Parent__c!=true and Type__c='Create Revenue Contract'];
        lstOpportunities = [Select id,Intacct_Customer__c,AccountId,StageName,Reason__c,Reason_Detail__c,Countries_of_Interest__c,Location_of_Interest__c,Program_Year__c,Engagement_Start__c,
                            Engagement_End__c,Matched_pt_Account__c,Parent_Opportunity__c,CurrencyIsoCode from Opportunity where id=:OppId LIMIT 1];
        System.debug('****lstOpportunities: ' + lstOpportunities);
        //lstOppProducts=[Select Id, Intacct_Department__c,PricebookEntryId,PricebookEntry.ProductCode, OpportunityId,  CurrencyIsoCode, Quantity, UnitPrice From OpportunityLineItem where OpportunityId=:lstOpportunities[0].Id];
        
        if(lstOpportunities!=null && lstOpportunities.size()>0)
        {
            
            For(Opportunity opp:lstOpportunities)
            {
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                //PricebookEntry ObjPriceBookEntry;
                Dom.Document doc = new Dom.Document();
                List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
                
                doc.load(Constants.CreateSIXMLTemplate);
                nodelist =  doc.getRootElement().getChildElements();
                // Infuse data from the SOQL query into nodelist
                for (dom.XmlNode node : nodelist){
                    system.debug('*node***'+node);
                    
                    //system.debug('*objFieldName***'+objFieldName);
                    if(node.getName() == 'operation')
                    {
                        List<dom.XmlNode> childnodelist =  node.getChildElements();
                        for(dom.XmlNode childnode : childnodelist)
                        {
                            system.debug('*childnode***'+childnode);                 
                            if(childnode.getName()=='content')
                            {
                                List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                                for(dom.Xmlnode nextchild: nextchildnodelist)
                                {system.debug('*nextchild***'+nextchild);
                                 if(nextchild.getName()=='function')                 
                                 {
                                     List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                     for(dom.Xmlnode next2child: next2childnodelist)
                                     {
                                         system.debug('*next2child***'+next2child);
                                         if(next2child.getName()=='create_sotransaction')                   
                                         {  
                                             List<dom.XmlNode> next3childnodelist =  next2child.getChildElements();
                                             for(dom.Xmlnode next3child: next3childnodelist)
                                             { 
                                                 system.debug('*next3child***'+next3child);
                                                 String objFieldName = Constants.IntAcctXMLNodeSO2SObjField.get(next3child.getName());
                                                 system.debug('*objFieldName***'+objFieldName);  
                                                 
                                                 if (next3child.getName() == 'datecreated'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next31childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next31child: next31childnodelist)
                                                     {                           
                                                         if (next31child.getName() == 'year'){                                                   
                                                             next31child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next31child.getName() == 'month'){                                                 
                                                             next31child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next31child.getName() == 'day'){                                                   
                                                             next31child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'createdfrom'){                       
                                                     next3child.addTextNode(RCKeyValue);                              
                                                 }                                   
                                                 
                                                 else if (next3child.getName() == 'customerid'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'documentno'){                       
                                                     next3child.addTextNode(RCDocno);                              
                                                 }
                                                 
                                                 else if (next3child.getName() == 'datedue'){
                                                     if(dueDate<System.Today())
                                                         dueDate= System.Today();
                                                     string daytag = String.valueof(dueDate.day());
                                                     string monthtag = String.valueof(dueDate.month());
                                                     string yeartag = String.valueof(dueDate.year());
                                                     List<dom.XmlNode> next32childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next32child: next32childnodelist)
                                                     {                           
                                                         if (next32child.getName() == 'year'){                                                   
                                                             next32child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next32child.getName() == 'month'){                                                 
                                                             next32child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next32child.getName() == 'day'){                                                   
                                                             next32child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }                  
                                                 else if (next3child.getName() == 'basecurr'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'currency'){
                                                     if (opp.get(objFieldName)!= null){
                                                         String textval = (String)opp.get(objFieldName);
                                                         next3child.addTextNode(textval);                              
                                                     }
                                                     else{
                                                         errorCounter = errorCounter+1;
                                                         appErrorMsg = appErrorMsg +  objFieldName + ' cannot be blank;';
                                                     }
                                                 }
                                                 if (next3child.getName() == 'exchratedate'){
                                                     date date1 =  system.today();
                                                     string daytag = String.valueof(date1.day());
                                                     string monthtag = String.valueof(date1.month());
                                                     string yeartag = String.valueof(date1.year());
                                                     List<dom.XmlNode> next31childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next31child: next31childnodelist)
                                                     {                           
                                                         if (next31child.getName() == 'year'){                                                   
                                                             next31child.addTextNode(yeartag);                              
                                                         }
                                                         else if (next31child.getName() == 'month'){                                                 
                                                             next31child.addTextNode(monthtag);                              
                                                         } 
                                                         else if (next31child.getName() == 'day'){                                                   
                                                             next31child.addTextNode(daytag);                              
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'customfields'){
                                                     List<dom.XmlNode> next33childnodelist =  next3child.getChildElements();
                                                     for(dom.Xmlnode next33child: next33childnodelist)
                                                     {                           
                                                         if (next33child.getName() == 'customfield'){                                                
                                                             List<dom.XmlNode> next331childnodelist =  next33child.getChildElements();
                                                             for(dom.Xmlnode next331child: next331childnodelist)
                                                             {                                 
																 if(next331child.getName() == 'customfieldname')
                                                                 {
                                                                     if(next331child.getText() == 'SFDCOPPID' ||
                                                                        next331child.getText() == 'AUPAIR_NAME' ||
                                                                        next331child.getText() == 'START_DATE' ||
                                                                        next331child.getText() == 'END_DATE' )
                                                                     {
                                                                         String oppfieldName = Constants.IntAcctXMLNodeSO2SObjField.get(next331child.getText());
                                                                         if (opp.get(oppfieldName)!= null)
                                                                         {
                                                                         String textVal='';
                                                                         if(oppfieldName == 'Engagement_Start__c' || oppfieldName == 'Engagement_End__c')
                                                                         {
                                                                             Date dt = (Date)opp.get(oppfieldName);
                                                                             textVal=string.valueof(dt.month()) +'/'+string.valueOf(dt.day())
                                                                                 +'/'+string.valueOf(dt.year());
                                                                         }
                                                                         else
                                                                             textval = (String)opp.get(oppfieldName);
                                                                         next33child.addChildElement('customfieldvalue',null,null).addTextNode(textval);                              
                                                                     }
                                                                     else{
                                                                         next33child.addChildElement('customfieldvalue',null,null).addTextNode('');
                                                                     }
                                                                   }
                                                                 }
                                                             }
                                                         }
                                                     }
                                                 }
                                                 else if (next3child.getName() == 'sotransitems'){                                                                    
                                                     
                                                     
                                                     //PricebookEntry ObjPriceBookEntry;
                                                     for(OpportunityLineItem olitem:lstOppProducts)
                                                     {   
                                                         //ObjPriceBookEntry = [Select p.ProductCode, p.Id From PricebookEntry p where p.Id =:olitem.PricebookEntryId];  
                                                         dom.Xmlnode NewSOTransItem = next3child.addChildElement('sotransitem',null,null);
                                                         
                                                         NewSOTransItem.addChildElement('itemid',null,null).addTextNode(olitem.PricebookEntry.ProductCode);
                                                         NewSOTransItem.addChildElement('warehouseid',null,null).addTextNode('Default Warehouse');
                                                         NewSOTransItem.addChildElement('quantity',null,null).addTextNode(string.valueof(olitem.Quantity));
                                                         NewSOTransItem.addChildElement('unit',null,null).addTextNode('Each');
                                                         NewSOTransItem.addChildElement('price',null,null).addTextNode(string.valueof(olitem.UnitPrice));
                                                         
                                                         NewSOTransItem.addChildElement('locationid',null,null).addTextNode(string.valueof(olitem.Intacct_Location__c));
                                                         NewSOTransItem.addChildElement('departmentid',null,null).addTextNode('100');
                                                         NewSOTransItem.addChildElement('memo',null,null).addTextNode('MEMO');
                                                         
                                                         dom.XmlNode customField = NewSOTransItem.addChildElement('customfields',null,null).addChildElement('customfield',null,null);
                                                         customField.addChildElement('customfieldname',null,null).addTextNode('DUE_DATE');
                                                         datetime dt;
                                                         if(olitem.due_date__c <system.Today())
                                                             dt= System.Today();
                                                         else
                                                             dt= olitem.due_date__c;
                                                         
                                                         customField.addChildElement('customfieldvalue',null,null).addTextNode(string.valueof(dt.format('MM/dd/YYYY')));
                                                         
                                                         NewSOTransItem.addChildElement('revrectemplate',null,null).addTextNode('100 at Invoicing');
                                                         dom.XmlNode revrecstartdate = NewSOTransItem.addChildElement('revrecstartdate',null,null);
                                                         date date1 =  system.today()+30;
                                                         string daytag = String.valueof(date1.day());
                                                         string monthtag = String.valueof(date1.month());
                                                         string yeartag = String.valueof(date1.year());
                                                         revrecstartdate.addChildElement('year',null,null).addTextNode(yeartag);
                                                         revrecstartdate.addChildElement('month',null,null).addTextNode(monthtag);
                                                         revrecstartdate.addChildElement('day',null,null).addTextNode(daytag);
                                                         
                                                         NewSOTransItem.addChildElement('customerid',null,null).addTextNode(string.valueof(opp.Intacct_Customer__c));                           
                                                         
                                                         
                                                     } //FOR OPPORTUNITY
                                                     
                                                     
                                                 }                   
                                                 
                                             }}}}}}}}}       
                
                xmlData = doc.toXmlString();
                Intacct__c  objIntacct;  
                system.debug('*****xmlData*******'+xmlData);
                system.debug('*****errorCounter*******'+errorCounter);
                system.debug('*****appErrorMsg*******'+appErrorMsg);
                if (errorCounter == 0)
                    computedResponse=IntAcctOppSyncHelper.getContent();
                else
                {
                    objIntacct = new Intacct__c();
                    objIntacct.Account__c = OppAccountId;
                    objIntacct.Request_XML__c = xmldata;
                    objIntacct.Response_XML__c = 'Something went wrong in constructing the request xml.' + 'Error Counter: ' + errorCounter
                        + 'appErrorMsg: ' + appErrorMsg ;
                    objIntacct.Intacct_Response__c = 'Failure';
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.opportunity__c=OppId;
                    objIntacct.Type__c='Create Sales Invoice';
                    objIntacct.Parent_Intacct__c=IntacctId;
                    insertIntacctList.Add(objIntacct);
                    system.debug('*****objIntacct*******'+objIntacct);  
                    return 'Failure';
                }
                
                system.debug('*****computedResponse*******'+computedResponse);                               
                if(computedResponse!=null && computedResponse.contains('#'))                         
                {
                    computedResponses = computedResponse.split('#',2);
                }
                string SIDocno;
                string SIKeyValue;
                if(computedResponses!=null)
                {
                    SIKeyValue = computedResponses[1];
                    if(SIKeyValue.contains('-'))                         
                    {
                        KeyValues = SIKeyValue.split('-',2);
                    }
                    SIDocno = KeyValues[1];
                    computedResponse = computedResponses[0];
                    system.debug('*****SIKeyValue*******'+SIKeyValue);  
                    system.debug('*****computedResponses*******'+computedResponse); 
                }
                
                if(computedResponse!=null)
                {
                        objIntacct = new Intacct__c();
                        objIntacct.Account__c = OppAccountId;
                    	objIntacct.Request_XML__c = xmldata;
                    	objIntacct.Response_XML__c = responseXML;
                        objIntacct.Intacct_Response__c = computedResponse;
                        objIntacct.Last_Sync_Date__c=system.now();
                        objIntacct.opportunity__c=OppId;
                        objIntacct.Type__c='Create Sales Invoice';
                        objIntacct.Parent_Intacct__c=IntacctId;
                        objIntacct.Intacct_Document_No__c = SIDocno;
                        insertIntacctList.Add(objIntacct);
                }
                else
                {
                    System.debug('Sales Invoice - Computed response is null');
                    objIntacct = new Intacct__c();
                    objIntacct.Account__c = OppAccountId;
                    objIntacct.Request_XML__c = xmldata;
                    objIntacct.Response_XML__c = 'Something went wrong in constructing the request xml.' + 'Error Counter: ' + errorCounter
                        + 'appErrorMsg: ' + appErrorMsg ;
                    objIntacct.Intacct_Response__c = 'Failure';
                    objIntacct.Last_Sync_Date__c=system.now();
                    objIntacct.opportunity__c=OppId;
                    objIntacct.Type__c='Create Sales Invoice';
                    objIntacct.Parent_Intacct__c=IntacctId;
                    insertIntacctList.Add(objIntacct);
                    system.debug('*****objIntacct*******'+objIntacct);  
                    return 'Failure';
                }
            }
        }
        
        return computedResponse;
        
    }
    
    public static void CreateAccountReceivables(Id OppId,Id OppAccountId,Id IntacctId) {
        List<String> computedResponses;
        List<String> KeyValues;
        List<Opportunity> lstOpportunities;
        List<OpportunityLineItem> lstOppProducts;
        List<Account> lstAccount;
        Id SalesInvoiceIntacctId;
        String SIprRecordKey;
        
        List <Intacct__c> SIIntct = new List<Intacct__c>();
        
        //AA for Schedule Payments
        If(ScheduleIntacct != '' && ScheduleIntacct=='CreatIntaact')
            insertIntacctList = new List<Intacct__c>();
        
        if (Test.isRunningTest())
        {
            //This is for test classes to run
            Intacct__c anIntacctRecord = new Intacct__c();
            anIntacctRecord.Account__c = OppAccountId;
            anIntacctRecord.Opportunity__c = OppId;
            anIntacctRecord.Type__c = 'Create Sales Invoice';
            insert anIntacctRecord;
            SalesInvoiceIntacctId = anIntacctRecord.Id;
        }
        
        lstAccount =[Select a.Status__c,a.Name,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:OppAccountId LIMIT 1];
        List<Intacct__c>  lstIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where i.Account__c=:OppAccountId and i.Is_Parent__c!=true and Type__c='Create Account Receivables'];
        //List<Intacct__c>  salesInvoiceIntacctlst = [Select i.Id, i.Intacct_Document_No__c, i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Account__c From Intacct__c i where id=:SalesInvoiceIntacctId limit 1] ;
        List<Payment__c>  PaymentLst = [Select  i.Id, i.Account_Name__c,i.Account_Receivables_Intacct__c, i.Opportunity_Name__c,  i.LastModifiedDate, i.LastModifiedById, i.Txn_Amount__c,i.Txn_Code__c,i.Txn_Date__c, i.Txn_Id__c, i.Txn_Gateway__c,Txn_Type__c From Payment__c i where id=:IntAcctOppSyncHelper.PaymentId limit 1] ;
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint'); 
        endpoint=appconstant.Value__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        Dom.Document doc = new Dom.Document();
        List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
        
        //first get the invoice prrecordkey
        //SIprRecordKey = IntAcctOppSyncHelper.GetRecordKey('Sales Invoice-' + String.valueof(salesInvoiceIntacctlst[0].Intacct_Document_No__c));
        List<Sales_invoice__c> si=[select id, name,Document_Type__c,Document_Number__c from
                                   sales_invoice__c where Name = :ARUpdateKey
                                   and account__c = :OppAccountId limit 1];
        if(si!=null && si.size()>0)
            SIprRecordKey = IntAcctOppSyncHelper.GetRecordKey(si[0].Document_Type__c + '-' + ARUpdateKey);
        else
            SIprRecordKey = IntAcctOppSyncHelper.GetRecordKey('Sales Invoice-' + ARUpdateKey);
        
        if(SIprRecordKey==null || SIprRecordKey=='Failure')
        {
            System.debug('Unable to retrieve the PR record key for the sales Invoice: ' + 'Sales Invoice-' + ARUpdateKey);
            Intacct__c objIntacct1 = new Intacct__c();
            objIntacct1.Account__c = OppAccountId;
            objIntacct1.Request_XML__c = xmldata;
            objIntacct1.Response_XML__c =  responseXML + '\r\n' + 
                'Unable to retrieve the PR record key for the sales Invoice: ' + 'Sales Invoice-' + ARUpdateKey;
            objIntacct1.Intacct_Response__c =  'Failure';
            objIntacct1.Last_Sync_Date__c=system.now();
            objIntacct1.opportunity__c=OppId;
            objIntacct1.Type__c='Create Account Receivables';
            objIntacct1.Parent_Intacct__c=IntacctId;
            insertIntacctList.Add(objIntacct1);
            
            If(ScheduleIntacct != '' && ScheduleIntacct=='CreatIntaact')
            insert objIntacct1;
            
            return;
        }
        
        doc.load(Constants.CreateARXMLTemplate);
        nodelist =  doc.getRootElement().getChildElements();
        // Infuse data from the SOQL query into nodelist
        for (dom.XmlNode node : nodelist)
        {
            system.debug('*node***'+node);
            //system.debug('*objFieldName***'+objFieldName);
            if(node.getName() == 'operation')
            {
                List<dom.XmlNode> childnodelist =  node.getChildElements();
                for(dom.XmlNode childnode : childnodelist)
                {
                    system.debug('*childnode***'+childnode);                 
                    if(childnode.getName()=='content')
                    {
                        List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                        for(dom.Xmlnode nextchild: nextchildnodelist)
                        {
                            system.debug('*nextchild***'+nextchild);
                            if(nextchild.getName()=='function')                 
                            {
                                List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                for(dom.Xmlnode next2child: next2childnodelist)
                                {
                                    system.debug('*next2child***'+next2child);
                                    if(next2child.getName()=='create_arpayment')                   
                                    {  
                                        dom.Xmlnode NewARPayment = next2child;
                                        NewARPayment.addChildElement('customerid',null,null).addTextNode(lstAccount[0].IntacctID__c);
                                        NewARPayment.addChildElement('paymentamount',null,null).addTextNode(string.valueof(PaymentLst[0].Txn_Amount__c));
                                        NewARPayment.addChildElement('bankaccountid',null,null).addTextNode('APC WFB Checking');
                                        NewARPayment.addChildElement('refid',null,null).addTextNode(string.valueof(PaymentLst[0].Txn_Id__c));
                                        NewARPayment.addChildElement('overpaylocid',null,null).addTextNode('21');
                                        NewARPayment.addChildElement('overpaydeptid',null,null).addTextNode('100');
                                        dom.XmlNode datereceived = NewARPayment.addChildElement('datereceived',null,null);
                                        datetime date1 =  PaymentLst[0].Txn_Date__c;
                                        string daytag = String.valueof(date1.day());
                                        string monthtag = String.valueof(date1.month());
                                        string yeartag = String.valueof(date1.year());
                                        datereceived.addChildElement('year',null,null).addTextNode(yeartag);
                                        datereceived.addChildElement('month',null,null).addTextNode(monthtag);
                                        datereceived.addChildElement('day',null,null).addTextNode(daytag);
                                        NewARPayment.addChildElement('paymentmethod',null,null).addTextNode('Credit Card');
                                        NewARPayment.addChildElement('basecurr',null,null).addTextNode('USD');
                                        NewARPayment.addChildElement('currency',null,null).addTextNode('USD');
                                        
                                        dom.XmlNode exchratedate = NewARPayment.addChildElement('exchratedate',null,null);
                                        exchratedate.addChildElement('year',null,null).addTextNode(yeartag);
                                        exchratedate.addChildElement('month',null,null).addTextNode(monthtag);
                                        exchratedate.addChildElement('day',null,null).addTextNode(daytag);
                                        NewARPayment.addChildElement('exchratetype',null,null).addTextNode('Intacct Daily Rate');
                                        
                                        dom.XmlNode arpaymentitem = NewARPayment.addChildElement('arpaymentitem',null,null);
                                        arpaymentitem.addChildElement('invoicekey',null,null).addTextNode(SIprRecordKey);
                                        arpaymentitem.addChildElement('amount',null,null).addTextNode(string.valueof(PaymentLst[0].Txn_Amount__c));
                                    }//end of if create_arpayment
                                }
                            }
                        }
                    }
                }
            }
        }       
        
        xmlData = doc.toXmlString();
        Intacct__c  objIntacct;  
        system.debug('*****xmlData*******'+xmlData);
        system.debug('*****errorCounter*******'+errorCounter);
        system.debug('*****appErrorMsg*******'+appErrorMsg);
        if (errorCounter == 0)
            computedResponse=IntAcctOppSyncHelper.getContent();                             
        else
        {
            	objIntacct = new Intacct__c();
                objIntacct.Account__c = OppAccountId;
            	objIntacct.Request_XML__c = xmldata;
                objIntacct.Response_XML__c =  'Something went wrong in constructing the request xml.' + 'Error Counter: ' + errorCounter
                        	+ 'appErrorMsg: ' + appErrorMsg ;
                objIntacct.Intacct_Response__c =  'Failure';
                objIntacct.Last_Sync_Date__c=system.now();
                objIntacct.opportunity__c=OppId;
                objIntacct.Type__c='Create Account Receivables';
                objIntacct.Parent_Intacct__c=IntacctId;
                insertIntacctList.Add(objIntacct);
            
            	If(ScheduleIntacct != '' && ScheduleIntacct=='CreatIntaact')
            	insert objIntacct;
            	return;
        }
        
        system.debug('*****computedResponse*******'+computedResponse);                               
        if(computedResponse!=null && computedResponse.contains('#'))                         
        {
            computedResponses = computedResponse.split('#',2);
        }
        string ARKeyValue;
        if(computedResponses!=null)
        {
            ARKeyValue = computedResponses[1];
            computedResponse = computedResponses[0];
            system.debug('*****ARKeyValue*******'+ARKeyValue);  
            system.debug('*****computedResponses*******'+computedResponse); 
        }
        
        if(computedResponse!=null)
        {
                objIntacct = new Intacct__c();
                objIntacct.Account__c = OppAccountId;
                objIntacct.Intacct_Response__c = computedResponse;
            	objIntacct.Request_XML__c = xmldata;
                objIntacct.Response_XML__c = responseXML;
                objIntacct.Last_Sync_Date__c=system.now();
                objIntacct.opportunity__c=OppId;
                objIntacct.Type__c='Create Account Receivables';
                objIntacct.Parent_Intacct__c=IntacctId;
                objIntacct.Intacct_Document_No__c = ARKeyValue;
                insertIntacctList.Add(objIntacct);
                
                //AA for Schedule Payments
                If(ScheduleIntacct != '' && ScheduleIntacct=='CreatIntaact')
                insert objIntacct;
            
        }
        else
        {
            System.debug('CreateAccountReceivables - computed resposne is null ');
            	objIntacct = new Intacct__c();
                objIntacct.Account__c = OppAccountId;
                //objIntacct.Intacct_Response__c = computedResponse;
            	objIntacct.Request_XML__c = xmldata;
                objIntacct.Response_XML__c = responseXML;
                objIntacct.Last_Sync_Date__c=system.now();
                objIntacct.opportunity__c=OppId;
                objIntacct.Type__c='Create Account Receivables';
                objIntacct.Parent_Intacct__c=IntacctId;
                insertIntacctList.Add(objIntacct);
                
            	//AA for Schedule Payments
                If(ScheduleIntacct != '' && ScheduleIntacct=='CreatIntaact')
                insert objIntacct;
            	
            	return;
        }
        
    }//end of  CreateAccountReceivables
    
    public static String GetRecordKey(String transactionKey) {
        List<String> computedResponses;
        List<String> KeyValues;
        String prRecordKeyValue;
        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint'); 
        endpoint=appconstant.Value__c;
        
        Dom.Document doc = new Dom.Document();
        List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
        
        doc.load(Constants.GetRecordKeyXMLTemplate);
        nodelist =  doc.getRootElement().getChildElements();
        // Infuse data from the SOQL query into nodelist
        for (dom.XmlNode node : nodelist)
        {
            system.debug('*node***'+node);
            //system.debug('*objFieldName***'+objFieldName);
            if(node.getName() == 'operation')
            {
                List<dom.XmlNode> childnodelist =  node.getChildElements();
                for(dom.XmlNode childnode : childnodelist)
                {
                    system.debug('*childnode***'+childnode);                 
                    if(childnode.getName()=='content')
                    {
                        List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                        for(dom.Xmlnode nextchild: nextchildnodelist)
                        {
                            system.debug('*nextchild***'+nextchild);
                            if(nextchild.getName()=='function')                 
                            {
                                List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                for(dom.Xmlnode next2child: next2childnodelist)
                                {
                                    system.debug('*next2child***'+next2child);
                                    if(next2child.getName()=='get_list')                   
                                    {  
                                        dom.Xmlnode getList = next2child;
                                        
                                        dom.Xmlnode expression = getList.addChildElement('filter',null,null).addChildElement('expression',null,null);
                                        expression.addChildElement('field',null,null).addTextNode('transactionid');
                                        expression.addChildElement('operator',null,null).addTextNode('=');
                                        expression.addChildElement('value',null,null).addTextNode(transactionKey);
                                        getList.addChildElement('fields',null,null).addChildElement('field',null,null).addTextNode('prrecordkey');
                                        
                                    }//end of if get_list
                                }
                            }
                        }
                    }
                }
            }
        }       
        
        xmlData = doc.toXmlString();
        
        system.debug('*****xmlData*******'+xmlData);
        system.debug('*****errorCounter*******'+errorCounter);
        system.debug('*****appErrorMsg*******'+appErrorMsg);
        
        //computedResponse=IntAcctOppSyncHelper.getContent(); 
        if (errorCounter == 0)
        {
            
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');  
            req.setheader('Content-type','x-intacct-xml-request');
            req.setHeader('Accept', 'application/xml');
            String body = xmlData;
            system.debug('*****req*******'+req);
            system.debug('*****xmlData*******'+xmlData);
            system.debug('*****body*******'+body);
            req.setTimeout(120000);
            req.setBody(body);  
            req.setEndpoint(endPoint);
            // Send the request, and return a response 
            system.debug('*****req*******'+req); 
            system.debug('*****isApexBeingTested*******'+isApexBeingTested); 
            if (!isApexBeingTested){
                res = h.send(req);
                system.debug('*****res*******'+res); 
                responseXML = res.getBody();
                system.debug('*****responseXML*******'+responseXML); 
            }
            else{
                responseXML = testRes;
            }
            
            system.debug('*****responseXML*******'+responseXML);  
            Dom.Document responsedoc = new Dom.Document();
            if (!isApexBeingTested){
                responsedoc = res.getBodyDocument();
                system.debug('*****responsedoc*******'+responsedoc);  
                dom.XmlNode OperationNode =  responsedoc.getRootElement().getChildElement('operation', null) ;
                system.debug('*****OperationNode*******'+OperationNode);
                dom.XmlNode OperationResultNode =  OperationNode.getChildElement('result', null) ;
                system.debug('*****OperationResultNode*******'+OperationResultNode);
                dom.XmlNode ResultNode =  OperationResultNode.getChildElement('status', null) ;
                system.debug('*****ResultNode*******'+ResultNode);
                
                dom.XmlNode prrecordkeyNode ;
                dom.XmlNode dataNode = OperationResultNode.getChildElement('data', null);
                 
                if(dataNode!=null)
                {
                    dom.XmlNode sotransactionNode = dataNode.getChildElement('sotransaction', null);
                    if(sotransactionNode!=null)
                    {
                       prrecordkeyNode= sotransactionNode.getChildElement('prrecordkey', null);
                        if(prrecordkeyNode==null)
                        {
                            prRecordKeyValue = 'Failure';
                            return prRecordKeyValue;
                        }
                        
                    }
                    else
                    {
                        prRecordKeyValue = 'Failure';
                        return prRecordKeyValue;
                    }
                }   
                else
                {
                    prRecordKeyValue = 'Failure';
                    return prRecordKeyValue;
                }
                
                //dom.XmlNode prrecordkeyNode = OperationResultNode.getChildElement('data', null).getChildElement('sotransaction', null).getChildElement('prrecordkey', null);
                //system.debug('*****prrecordkeyNode*******'+prrecordkeyNode);
                
                if (ResultNode!=null && ResultNode.getText() == 'success'){
                    computedResponse = 'Success';
                    if(prrecordkeyNode!=null)
                        prRecordKeyValue= prrecordkeyNode.getText();
                    else
                        prRecordKeyValue = 'Failure';
                }
                
                else{
                    prRecordKeyValue = 'Failure';
                    
                }
            }
            else{
                prRecordKeyValue = '1061';
            }
            
            system.debug('*****computedResponse*******'+computedResponse);
            
        }
        else 
            prRecordKeyValue='Failure';
        
        if (isApexBeingTested){
            prRecordKeyValue = '1061';
        } 
        //---------------------------------------------------------------------
        return prRecordKeyValue;
    }//end of  GetRecordKey
    
    public static void ApplyAccountReceivables(Id OppId,Id OppAccountId,Id IntacctId, String SIforARUpdate, String ARPaymentKey, decimal amount) {
        List<String> computedResponses;
        List<String> KeyValues;
        List<Opportunity> lstOpportunities;
        List<OpportunityLineItem> lstOppProducts;
        List<Account> lstAccount;
        Id SalesInvoiceIntacctId;
        String SIprRecordKey;
        String ARPaymentPrRecordKey;
        //insertIntacctList = new List<Intacct__c>();
        List <Intacct__c> SIIntct = new List<Intacct__c>();
        
        if (Test.isRunningTest())
        {
            //This is for test classes to run
            Intacct__c anIntacctRecord = new Intacct__c();
            anIntacctRecord.Account__c = OppAccountId;
            anIntacctRecord.Opportunity__c = OppId;
            anIntacctRecord.Type__c = 'Create Sales Invoice';
            insert anIntacctRecord;
            SalesInvoiceIntacctId = anIntacctRecord.Id;
        }
        
        lstAccount =[Select a.Status__c,a.Name,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,a.Description,
                     a.APISessionId__c,a.APIServerUrl__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, a.Intrax_Program_Category__c, 
                     a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, 
                     a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, a.PersonMailingState, a.PersonMailingPostalCode, 
                     a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, 
                     a.BillingCity From Account a where a.id=:OppAccountId LIMIT 1];
        List<Intacct__c>  lstIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, 
                                        i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where 
                                        i.Account__c=:OppAccountId and i.Is_Parent__c!=true and 
                                        Type__c='Apply Account Receivables'];

        Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAPIEndpoint'); 
        endpoint=appconstant.Value__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        Dom.Document doc = new Dom.Document();
        List<dom.XmlNode> nodelist = new List<dom.XmlNode>();
        
        //first get the invoice prrecordkey
        //SIprRecordKey = IntAcctOppSyncHelper.GetRecordKey('Sales Invoice-' + String.valueof(salesInvoiceIntacctlst[0].Intacct_Document_No__c));
        List<Sales_invoice__c> si=[select id, name,Document_Type__c,Document_Number__c from
                                   sales_invoice__c where Name = :SIforARUpdate
                                   and account__c = :OppAccountId limit 1];
        if(si!=null && si.size()>0)
           SIprRecordKey = IntAcctOppSyncHelper.GetRecordKey(si[0].Document_Type__c+'-' + SIforARUpdate);
        else
         SIprRecordKey = IntAcctOppSyncHelper.GetRecordKey('Sales Invoice-' + SIforARUpdate);
        
        if(SIprRecordKey==null || SIprRecordKey=='Failure')
        {
            System.debug('Unable to retrieve the PR record key for the sales Invoice: ' + 'Sales Invoice-' + SIforARUpdate);
            Intacct__c objIntacct1 = new Intacct__c();
            objIntacct1.Account__c = OppAccountId;
            objIntacct1.Request_XML__c = xmldata;
            objIntacct1.Response_XML__c =  responseXML + '\r\n' + 
                'Unable to retrieve the PR record key for the sales Invoice: ' + 'Sales Invoice-' + SIforARUpdate;
            objIntacct1.Intacct_Response__c =  'Failure';
            objIntacct1.Last_Sync_Date__c=system.now();
            objIntacct1.opportunity__c=OppId;
            objIntacct1.Type__c='Apply Account Receivables';
            objIntacct1.Parent_Intacct__c=IntacctId;
            insertIntacctList.Add(objIntacct1);
            return;
        }
        
        List<Sales_invoice__c> siTemp=[select id, name,Document_Type__c,Document_Number__c from
                                   sales_invoice__c where Name = :ARPaymentKey
                                   and account__c = :OppAccountId limit 1];
        if(siTemp!=null && siTemp.size()>0)
            ARPaymentPrRecordKey = IntAcctOppSyncHelper.GetRecordKey(siTemp[0].Document_Type__c + '-' + ARPaymentKey);
        else
            ARPaymentPrRecordKey = IntAcctOppSyncHelper.GetRecordKey('Sales Invoice-' + ARPaymentKey);
        
        if(ARPaymentPrRecordKey==null || ARPaymentPrRecordKey=='Failure')
        {
            System.debug('Unable to retrieve the PR record key for the sales Invoice: ' + 'Sales Invoice-' + ARPaymentKey);
            Intacct__c objIntacct2 = new Intacct__c();
            objIntacct2.Account__c = OppAccountId;
            objIntacct2.Request_XML__c = xmldata;
            objIntacct2.Response_XML__c =  responseXML + '\r\n' + 
                'Unable to retrieve the PR record key for the sales Invoice: ' + 'Sales Invoice-' + ARPaymentKey;
            objIntacct2.Intacct_Response__c =  'Failure';
            objIntacct2.Last_Sync_Date__c=system.now();
            objIntacct2.opportunity__c=OppId;
            objIntacct2.Type__c='Apply Account Receivables';
            objIntacct2.Parent_Intacct__c=IntacctId;
            insertIntacctList.Add(objIntacct2);
            return;
        }
        
        doc.load(Constants.ApplyARXMLTemplate);
        nodelist =  doc.getRootElement().getChildElements();

        // Infuse data from the SOQL query into nodelist
        for (dom.XmlNode node : nodelist)
        {
            system.debug('*node***'+node);
            if(node.getName() == 'operation')
            {
                List<dom.XmlNode> childnodelist =  node.getChildElements();
                for(dom.XmlNode childnode : childnodelist)
                {
                    system.debug('*childnode***'+childnode);                 
                    if(childnode.getName()=='content')
                    {
                        List<dom.XmlNode> nextchildnodelist =  childnode.getChildElements();
                        for(dom.Xmlnode nextchild: nextchildnodelist)
                        {
                            system.debug('*nextchild***'+nextchild);
                            if(nextchild.getName()=='function')                 
                            {
                                List<dom.XmlNode> next2childnodelist =  nextchild.getChildElements();
                                for(dom.Xmlnode next2child: next2childnodelist)
                                {
                                    system.debug('*next2child***'+next2child);
                                    if(next2child.getName()=='apply_arpayment')                   
                                    {  
                                        dom.Xmlnode NewARPayment = next2child;
                                        NewARPayment.addChildElement('arpaymentkey',null,null).addTextNode(ARPaymentPrRecordKey);
                                        dom.XmlNode paymentdate = NewARPayment.addChildElement('paymentdate',null,null);
                                        Date date1 =  System.Today();
                                        string daytag = String.valueof(date1.day());
                                        string monthtag = String.valueof(date1.month());
                                        string yeartag = String.valueof(date1.year());
                                        paymentdate.addChildElement('year',null,null).addTextNode(yeartag);
                                        paymentdate.addChildElement('month',null,null).addTextNode(monthtag);
                                        paymentdate.addChildElement('day',null,null).addTextNode(daytag);
                                        NewARPayment.addChildElement('memo',null,null).addTextNode('Applying service credit to outstanding invoices');
                                        NewARPayment.addChildElement('overpaylocid',null,null).addTextNode('21');
                                        NewARPayment.addChildElement('overpaydeptid',null,null).addTextNode('100');
                                        dom.XmlNode arpaymentitems = NewARPayment.addChildElement('arpaymentitems',null,null);
                                        dom.XmlNode arpaymentitem = arpaymentitems.addChildElement('arpaymentitem',null,null);
                                        arpaymentitem.addChildElement('invoicekey',null,null).addTextNode(SIprRecordKey);
                                        arpaymentitem.addChildElement('amount',null,null).addTextNode(String.valueof(amount));
                                    }//end of if apply_arpayment
                                }
                            }
                        }
                    }
                }
            }
        }       
        
        xmlData = doc.toXmlString();
        Intacct__c  objIntacct;
        
        system.debug('*****xmlData*******'+xmlData);
        system.debug('*****errorCounter*******'+errorCounter);
        system.debug('*****appErrorMsg*******'+appErrorMsg);
        if (errorCounter == 0)
            computedResponse=IntAcctOppSyncHelper.getContent();                             
        else
        {
            objIntacct = new Intacct__c();
            objIntacct.Account__c = OppAccountId;
            objIntacct.Request_XML__c = xmldata;
            objIntacct.Response_XML__c = 'Something went wrong in constructing the request xml.' + 'Error Counter: ' + errorCounter
                        	+ 'appErrorMsg: ' + appErrorMsg ;
            objIntacct.Intacct_Response__c = 'Failure';
            objIntacct.Last_Sync_Date__c=system.now();
            objIntacct.opportunity__c=OppId;
            objIntacct.Type__c='Apply Account Receivables';
            objIntacct.Parent_Intacct__c=IntacctId;
            insertIntacctList.Add(objIntacct);
            return;
        }
        
        system.debug('*****computedResponse*******'+computedResponse);                               
        if(computedResponse!=null && computedResponse.contains('#'))                         
        {
            computedResponses = computedResponse.split('#',2);
        }
        string ARKeyValue;
        if(computedResponses!=null)
        {
            ARKeyValue = computedResponses[1];
            computedResponse = computedResponses[0];
            system.debug('*****ARKeyValue*******'+ARKeyValue);  
            system.debug('*****computedResponses*******'+computedResponse); 
        }
          
        if(computedResponse!=null)
        {
                objIntacct = new Intacct__c();
                objIntacct.Account__c = OppAccountId;
            	objIntacct.Request_XML__c = xmldata;
                objIntacct.Response_XML__c = responseXML;
                objIntacct.Intacct_Response__c = computedResponse;
                objIntacct.Last_Sync_Date__c=system.now();
                objIntacct.opportunity__c=OppId;
                objIntacct.Type__c='Apply Account Receivables';
                objIntacct.Parent_Intacct__c=IntacctId;
                objIntacct.Intacct_Document_No__c = ARKeyValue;
                insertIntacctList.Add(objIntacct);
        }
        else
        {
            System.debug('Computed response is null');
            objIntacct = new Intacct__c();
            objIntacct.Account__c = OppAccountId;
            objIntacct.Request_XML__c = xmldata;
            objIntacct.Response_XML__c = responseXML;
            //objIntacct.Intacct_Response__c = computedResponse;
            objIntacct.Last_Sync_Date__c=system.now();
            objIntacct.opportunity__c=OppId;
            objIntacct.Type__c='Apply Account Receivables';
            objIntacct.Parent_Intacct__c=IntacctId;
            insertIntacctList.Add(objIntacct);
            system.debug('*****objIntacct*******'+objIntacct);
            return;
        }
    }//end of  ApplyAccountReceivables
    
    public void syncBackIntacctObjForOpp(){
    	String baseEndPoint = Global_Constants__c.getInstance().Intacct_ReSync_URL__c;
    	Map<String,String> parameterizedEndPoints = new Map<String,String>();
    	responseFromIntacct = new Map<String,String>();
    	String parameterizedEndPoint = '';
    	String urlParams = '';
    	//For a given opportunity id, get all the intacct objects - SO and SI and trigger syncback
    	Opportunity loadedOppRec = [select Id,Name,(select Name,Document_Number__c,Document_Type__c from R00N40000001jWpMEAU__r),(select Name,Document_Number__c,Document_Type__c from R00N40000001jWqUEAU__r) from Opportunity where Id =:opportunityRecSyncBack.Id];
    	for (Sales_Invoice__c si : loadedOppRec.R00N40000001jWpMEAU__r){
    		parameterizedEndPoint = '';
    		urlParams = '';
    		system.debug(si);
    		urlParams = 'docid='+si.Document_Number__c+'&doctype='+EncodingUtil.urlEncode(si.Document_Type__c,'UTF-8');
    		//parameterizedEndPoint = baseEndPoint+EncodingUtil.urlEncode(urlParams,'UTF-8');
    		parameterizedEndPoint = baseEndPoint+urlParams;
    		parameterizedEndPoints.put(si.Document_Number__c,parameterizedEndPoint);
    	}
    	for (Sales_Order__c so : loadedOppRec.R00N40000001jWqUEAU__r){
    		parameterizedEndPoint = '';
    		urlParams = '';
    		system.debug(so);
    		urlParams = 'docid='+so.Document_Number__c+'&doctype='+EncodingUtil.urlEncode(so.Document_Type__c,'UTF-8');
    		//parameterizedEndPoint = baseEndPoint+EncodingUtil.urlEncode(urlParams,'UTF-8');
    		parameterizedEndPoint = baseEndPoint+urlParams;
    		parameterizedEndPoints.put(so.Document_Number__c,parameterizedEndPoint);
    	}

    	system.debug(loadedOppRec);
    	Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        String aSyncUrl = '';
        String processedResponse = '';
		Pattern p = Pattern.compile(Global_Constants__c.getInstance().Intacct_ReSync_Response_Pattern_RegEx__c);
		for (String docId : parameterizedEndPoints.keySet()){
			System.debug('URL Being called:'+aSyncUrl);
			aSyncUrl = parameterizedEndPoints.get(docId);
			processedResponse = '';
	        req.setEndpoint(aSyncUrl);
			req.setMethod('GET'); 
			String response;
			System.debug(aSyncUrl);
			res = h.send(req);
			response = res.getBody();
			System.debug(response);
	        Matcher sm = p.matcher(response);
	        while (sm.find()) {
	            processedResponse = processedResponse + sm.group();
	        }
			responseFromIntacct.put(docId,processedResponse.stripHtmlTags());
		}
		if (responseFromIntacct.keySet().size() == 0){
			responseFromIntacct.put('NoRecords','No Sales Order (or) Sales Invoice present for this Opportunity');
		}
    }
}