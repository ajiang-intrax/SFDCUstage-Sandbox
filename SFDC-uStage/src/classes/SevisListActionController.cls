public with sharing class SevisListActionController {
    //This is the key to process list selected records
    private ApexPages.StandardSetController standardController;
    public List<Intrax_Program_Upload__c> dsForms{get; set;}
    public Map<ID,Account> sevisAccounts {get; set;}
    public Map<ID,Map<String,String>> sevisPaymentConstants {get; set;}
    public List<Sevis__c> selectedSevis {get; set;}
    public Integer totalValue {get; set;}
    public Map <String,String> sevisPaymentConstantsAll {get; set;}
    public SevisListActionController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
    }
    
    public PageReference getAllData(){
        List<Sevis__c> selectedSevis = (List<Sevis__c>) standardController.getSelected();
        dsForms = [select Id,Sevis__c,Document_Guid__c from Intrax_Program_Upload__c where Sevis__c in :selectedSevis];
        return null;
    }
    
    //Get all Payment XML related
    public PageReference getPaymentData(){
        //get Selected Records in List View
        selectedSevis = (List<Sevis__c>) standardController.getSelected();
        //Stores Account related info and Constants
        sevisAccounts = new Map<ID,Account>();
        sevisPaymentConstants =  new Map<ID,Map<String,String>>();
        List<Engagement__c> sevisEngagements = [select Id,Account_Id__c,Sevis__c,Intrax_Program__c,Intrax_Program_Options__c,SEVIS_Program__c from Engagement__c where Sevis__c in :selectedSevis];
        Map<Id,Engagement__c> sevisEngagementsMap = new Map<Id,Engagement__c>();
        Map<Id,Account> sevisAccountMap = new Map<Id,Account>();
        List<ID> sevisAccountIds = new List<ID>();
        totalValue = 0;

        for (Engagement__c sevisEngagement : sevisEngagements){
            sevisEngagementsMap.put(sevisEngagement.Sevis__c,sevisEngagement);
            sevisAccountIds.add(sevisEngagement.Account_Id__c);
        }

        List<Account> sevisAccountList = [select Id,Middle_Name__pc, PersonEmail,FirstName,LastName,PersonBirthdate from Account where Id in :sevisAccountIds];
        
        for (Account sevisAccount : sevisAccountList){
            sevisAccountMap.put(sevisAccount.Id,sevisAccount);
        }
        //Load the Payment Constants
        List <Application_Constants__c> sevisPaymentConstantsAllList =  [select Program__c,Program_Options__c,Sevis_Program__c,Key__c,Value__c from Application_Constants__c where name like 'SEVIS Payment%'];
        sevisPaymentConstantsAll = new Map<String,String>();
        //Package it
        for (Application_Constants__c sevisPaymentConstant : sevisPaymentConstantsAllList){
            if (sevisPaymentConstant.Program_Options__c != NULL)
                sevisPaymentConstantsAll.put(sevisPaymentConstant.Program__c+sevisPaymentConstant.Program_Options__c+sevisPaymentConstant.Sevis_Program__c+sevisPaymentConstant.Key__c,sevisPaymentConstant.Value__c);
            else 
                sevisPaymentConstantsAll.put(sevisPaymentConstant.Program__c+sevisPaymentConstant.Sevis_Program__c+sevisPaymentConstant.Key__c,sevisPaymentConstant.Value__c);
        }
        //For each selected SEVIS record
        for (Sevis__c sevis : selectedSevis){
            //Get the related Engagement
            Engagement__c sevisEngagement = sevisEngagementsMap.get(sevis.Id);
            //Set the constants
            Map<String,String> currentRecordsConstants = new Map<String,String>();
            //Retrieve evCategory
            if (sevisEngagement.Intrax_Program_Options__c == 'WEST'){
                if (sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.Intrax_Program_Options__c+sevisEngagement.SEVIS_Program__c+'evCategory') != NULL)
                    currentRecordsConstants.put('evCategory',sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.Intrax_Program_Options__c+sevisEngagement.SEVIS_Program__c+'evCategory'));
                else 
                    currentRecordsConstants.put('evCategory','');
            }
            else{
                if (sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'evCategory') != NULL)
                    currentRecordsConstants.put('evCategory',sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'evCategory'));
                else 
                    currentRecordsConstants.put('evCategory','');
            }
            
            //Retrieve program number
            if (sevisEngagement.Intrax_Program_Options__c == 'WEST'){
                if (sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.Intrax_Program_Options__c+sevisEngagement.SEVIS_Program__c+'evProgramNumber') != NULL)
                    currentRecordsConstants.put('evProgramNumber',sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.Intrax_Program_Options__c+sevisEngagement.SEVIS_Program__c+'evProgramNumber'));
                else 
                    currentRecordsConstants.put('evProgramNumber','');
            }
            else{
                if (sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'evProgramNumber')!= NULL)
                    currentRecordsConstants.put('evProgramNumber',sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'evProgramNumber'));
                else 
                    currentRecordsConstants.put('evProgramNumber','');
            }       
            
            //Retrieve SEVIS fee
            if (sevisEngagement.Intrax_Program_Options__c == 'WEST'){
                if (sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.Intrax_Program_Options__c+sevisEngagement.SEVIS_Program__c+'fee') != NULL){
                    currentRecordsConstants.put('fee',sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.Intrax_Program_Options__c+sevisEngagement.SEVIS_Program__c+'fee'));
                    totalValue = totalValue + Integer.valueOf(sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'fee'));
                }
                else 
                    currentRecordsConstants.put('fee','');
            }
            else{
                if (sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'fee') != NULL){
                    currentRecordsConstants.put('fee',sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'fee'));
                    totalValue = totalValue + Integer.valueOf(sevisPaymentConstantsAll.get(sevisEngagement.Intrax_Program__c+sevisEngagement.SEVIS_Program__c+'fee'));
                }
                else 
                    currentRecordsConstants.put('fee','');
            }       
                
            //Add the cosntants to payment constants global variable
            sevisPaymentConstants.put(sevis.Id,currentRecordsConstants);
            //Add the accounts to the global Sevis Accounts variable
            sevisAccounts.put(sevis.Id,sevisAccountMap.get(sevisEngagement.Account_Id__c));
        } 
        return null;
    }
    
    public PageReference updateSelectedSevisRecs()
    {       
        // Call StandardSetController 'save' method to update (optional, you can use your own DML)
        return standardController.save();   
    } 
    //Set the tracking fields
    public PageReference printPaymentXML()
    {       
        List<Sevis__c> selectedSevis = (List<Sevis__c>) standardController.getSelected();
        // Call StandardSetController 'save' method to update (optional, you can use your own DML)
        for (Sevis__c sevisRec : selectedSevis){
            sevisRec.SEVIS_Fee_Paid__c = true;
            sevisRec.SEVIS_Payment_XML_Printed_By__c = UserInfo.getUserId();
            sevisRec.SEVIS_Payment_XML_Printed_At__c = datetime.now();
        }
        return standardController.save();   
    }
    //Download as XML
    public PageReference downloadPaymentXML()
    {       
        return Page.SevisPrintPaymentXMLResult ;   
    }
}