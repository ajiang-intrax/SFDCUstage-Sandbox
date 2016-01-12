//This component is part of Invoice IT Deployment
public with sharing class ControllerEmailInvoice {
    public String sInvoiceId {set; get;}
    public invoiceit_s__Sequence_Number__c legalEntity {set;get;}
    public Bank_Account__c bankAccount {set; get;}
    public map<string, string> mapLabelConversion {set;get;}
    string invoiceLanguage;
    
    public ControllerEmailInvoice() {
        mapLabelConversion = new map<string, string>();   
    }
    
    public invoiceit_s__Invoice__c invoice { 
        set; 
        get {
            if(sInvoiceId != null) {
                string sQuery = 'SELECT ' + ControllerEmailInvoice.getObjectFields('invoiceit_s__Invoice__c')
                                + ',invoiceit_s__CurrencyL__r.Name,invoiceit_s__CurrencyL__r.invoiceit_s__Currency_Symbol__c,invoiceit_s__Account__r.invoiceit_s__VAT_No__c,invoiceit_s__Account__r.Intrax_Id__c,invoiceit_s__Account__r.LastName,'
                                + 'invoiceit_s__Shipping_Contact__r.Name, invoiceit_s__Shipping_Contact__r.MailingStreet, invoiceit_s__Shipping_Contact__r.MailingCity, invoiceit_s__Shipping_Contact__r.MailingState , invoiceit_s__Shipping_Contact__r.MailingCountry, invoiceit_s__Shipping_Contact__r.MailingPostalCode,  invoiceit_s__Shipping_Contact__r.Salutation, invoiceit_s__Order__r.Opportunity__r.Invoice_No__c,'
                                + 'invoiceit_s__Billing_Contact__r.Name, invoiceit_s__Billing_Contact__r.MailingStreet, invoiceit_s__Billing_Contact__r.MailingCity, invoiceit_s__Billing_Contact__r.MailingState , invoiceit_s__Billing_Contact__r.MailingCountry, invoiceit_s__Billing_Contact__r.MailingPostalCode, invoiceit_s__Billing_Contact__r.Salutation, '
                                + 'invoiceit_s__Order__r.Name, invoiceit_s__Order__r.Intrax_Region__c,  invoiceit_s__Order__r.Opportunity__r.Sys_Payment_Instruction_Id__c, invoiceit_s__Order__r.Opportunity__r.Sys_Invoice_Language__c,invoiceit_s__Order__r.Opportunity__r.Intrax_Programs__c'
                                + ' FROM invoiceit_s__Invoice__c '
                                + ' WHERE Id =' + '\''+ sInvoiceId + '\'' + ' ';
                sQuery = String.escapeSingleQuotes(sQuery);
                sQuery = sQuery.replace('\\','');
                invoice = Database.query(sQuery);
                
                //get the legal entity data
                map<string, invoiceit_s__Sequence_Number__c> legalEntities = invoiceit_s__Sequence_Number__c.getAll();
                
                if(invoice.invoiceit_s__Order__r.Intrax_Region__c != null && legalEntities.containsKey(invoice.invoiceit_s__Order__r.Intrax_Region__c)) {
                    legalEntity = legalEntities.get(invoice.invoiceit_s__Order__r.Intrax_Region__c);
                }
                
                //Added to get the correct bank account details based on the value of Opportunity.Sys_Payment_Instruction_Id__c
                if(invoice.invoiceit_s__Order__r.Opportunity__r.Sys_Payment_Instruction_Id__c != null){
                    bankAccount = Bank_Account__c.getValues(invoice.invoiceit_s__Order__r.Opportunity__r.Sys_Payment_Instruction_Id__c);
                }else{
                    bankAccount = new Bank_Account__c();
                }
                 
                //based on inv language, get the translations
                invoiceLanguage = invoice.Invoice_Language__c;
                
                mapLabelConversion = new map<string, string>();
                
                for(Label_Mapping__c mapping : Label_Mapping__c.getAll().values()) {
                    sobject sobjectMapping = (sobject) mapping;
                    mapLabelConversion.put(mapping.Name, string.valueOf(sobjectMapping.get(invoiceLanguage)));       
                }  
             }           
            return invoice;         
        }
    }

    public list<invoiceit_s__Invoice_Lines__c> listOfInvoiceLines {
        get {
              string sQuery = 'SELECT ' + ControllerEmailInvoice.getObjectFields('invoiceit_s__Invoice_Lines__c')
                            + ', invoiceit_s__Job_Rate_Plan_Charge__r.Product_Description__c, invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c, invoiceit_s__Job__r.invoiceit_s__Service_Activation_Date__c, invoiceit_s__Job__r.invoiceit_s__Service_End_Date__c, invoiceit_s__Job__r.Name'
                            + ' FROM invoiceit_s__Invoice_Lines__c '
                            + ' WHERE invoiceit_s__Invoice__c =' + '\''+ sInvoiceId + '\'' + ' '
                            + 'ORDER BY invoiceit_s__Sequence_No__c';
              sQuery = String.escapeSingleQuotes(sQuery);
              sQuery = sQuery.replace('\\','');

              return Database.query(sQuery);                
             }
    }
    
    //This method returns a select query string that contains all the standard fields of the object
    public static String getObjectSelectQuery(String objectName) {
        String sQuery = 'SELECT ';
        sQuery += getObjectFields(objectName);
        sQuery += ' FROM '+ objectName + ' ';
        return sQuery;
    }

    //This method returns a comma seperated string of all the standard fields of the object
    public static String getObjectFields(String objectName) {
        String sQuery = '';
        Map<String, Schema.SObjectField> objectFieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for(Schema.SObjectField column: objectFieldMap.values()) {
            //system.debug('column Name is ' + column + 'column permission' + column.getDescribe().isUpdateable());
            sQuery += column+', ';
        }
        sQuery = sQuery.substring(0, sQuery.length()-2);
        sQuery += ' ';
        return sQuery;
    }
}