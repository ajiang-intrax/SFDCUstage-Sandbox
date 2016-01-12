/** * Class Name: IPUListActionController
* Description : Batch Printing of DS Forms
                Once the batches of DS Forms have been downloaded from the government, Now user can select multiple Document and confirm their selection. 
                User can select multiple records on a List View for IPU. This new feature allows user to send more than one document for printing and in predefined sort order.
                and updates a “When Printed” date field on IPU record.

* Copyright : IntraxInc
* * @author : Atif Ali
* */ 

public with sharing class IPUListActionController {

	ApexPages.StandardSetController setcon;
	public List<String> lstguid = new List<string>();
	PageReference returnPage;
	//List of sObjects
	public List<Intrax_Program_Upload__c> selectedIPU {get; set;}
	//List of IPU Ids
	List <id> IPUids = new List<id>();
	Boolean DocumentType=False;
	// Variable to cusotmize error messages
	public boolean customMessage {get;set;}
	
	Public string SevisIPUListViewURL {get; set;}
	//Test mode
	//public static Boolean isTestMode = false;


   public IPUListActionController(ApexPages.StandardSetController setcontroller){
    setcon=setcontroller;

        //Fetch Ids from URL
        String conId = ApexPages.currentPage().getParameters().get('id'); 

        for(String str : conId.split(',')) {
        ipuids.add(str);
        }

        //Query selected IPU records from DataBase
        selectedIPU= [Select Id,Name,Document_Type__c,Document_GUID__c,Sevis__r.SEVIS_ARO_Name__c,Engagement__r.Partner_Account__c,Engagement__r.Account_Id__r.LastName From Intrax_Program_Upload__c Where Id in :IPUids order by Sevis__r.SEVIS_ARO_Name__c,Engagement__r.Partner_Account__c,Engagement__r.Account_Id__r.LastName]; 

        //Paasing List of IPU from StandardSetController
        setController = new ApexPages.StandardSetController(selectedIPU); 

        //Set selected records
        setController.setSelected(selectedIPU);
   }

   public PageReference Confirm(){
   	
      If(selectedIPU.size()>0){
          for(Intrax_Program_Upload__c IPUload: selectedIPU ){
	          If(IPUload.Document_Type__c != 'DS-2019'){
	          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select only "DS-2019" Document Type');
              ApexPages.addMessage(msg);
              return null;
	          }
	          else{
	          lstguid.add(IPUload.Document_GUID__c);
	          }
          }
      }
      system.debug('debug::lst'+lstguid);
      // Creating Object of  Mergepdf Helper Class
      MergePdf MergPdfObj = new MergePdf();
      //PageReference Webserviceresponse=MergPdfObj.bulkload(lstguid);
      //return Webserviceresponse;
      return MergPdfObj.bulkload(lstguid);
   }
   
      Public PageReference doCancel(){
    
        /******************************
        * GET OBJECT PREFIX LIST
        ******************************/
        Map<String,String> PrefixList = PrefixList();

        /*****************************
        * SET OBJECT AND LIST VIEW LABEL NAME
        *****************************/
        SevisIPUListViewURL = ListViewURL(PrefixList,'Intrax_Program_Upload__c','DS-2019 To Print');
        system.debug('debug::SevisIPUListViewURL'+SevisIPUListViewURL);
        return returnPage = new PageReference (SevisIPUListViewURL);
   }

      Public Map<String,String> PrefixList(){
            Map<String,String> PrefixList = new Map<String,String>{};
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            for(String sObj : gd.keySet()){
                Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
                PrefixList.put(r.getName(), r.getKeyPrefix());
            }
            return PrefixList;
        }
               
     Public String ListViewURL(Map<String,String> PrefixList,String ObjectName,String ListViewLabel){
        String ListViewURL;
        String ListViewId;
        String q = 'SELECT Name FROM '+ ObjectName +' LIMIT 1';
        ApexPages.StandardSetController ACC = new ApexPages.StandardSetController(Database.getQueryLocator(q));
        List<SelectOption> ListViews = ACC.getListViewOptions();
        for(SelectOption w : ListViews ){
            if(w.getLabel()==ListViewLabel){
                ListViewId = w.getValue().left(15);
                ListViewURL='/'+PrefixList.get(ObjectName)+'?fcf='+ListViewId;
            }
        }
        return ListViewURL;
     }
}