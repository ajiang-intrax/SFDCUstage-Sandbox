/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_IPUListActionController {

    static testMethod void myUnitTest() {
        
    Test.startTest();
    
    // TO DO: implement unit test
    Applicant_Info__c newApp = new Applicant_Info__c(Name='test',Height__c = '60', WEight__c = '30');
 
     RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
     //Account
     Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                    Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
     insert account;
     Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id);
     insert position;
     
     list<Intrax_Program_Upload__c> loadDoc = [select Name from Intrax_Program_Upload__c limit 1];
     
     Intrax_Program_Upload__c loadDocobj = new Intrax_Program_Upload__c(Name='test',Applicant_Info__c=newApp.id, Position__c = position.Id, Document_GUID__c='xyz',
     Document_Name__c='test.doc',Document_Service__c='IS',Document_Type__c='DS-2019', Review_Status__c = 'Accepted');
     insert newApp;
     
     insert loadDocobj ;
        
      ApexPages.currentPage().getParameters().put('id',loadDocobj.id);
      ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(loaddoc);
      IPUListActionController IPUController = new IPUListActionController(sc);
      MergePdf MergPdfObj = new MergePdf();
      
		Intrax_Program_Upload__c mergePdf1 = new Intrax_Program_Upload__c();
		Intrax_Program_Upload__c mergePdf2 = new Intrax_Program_Upload__c();
		mergePdf1.Name = 'Pdf1';
		mergePdf1.Document_GUID__c = 'abc';
		mergePdf1.Document_Service__c = 'DS';
		insert mergePdf1;
		mergePdf2.Name = 'Pdf2';
		mergePdf2.Document_GUID__c = '123';
		mergePdf2.Document_Service__c = 'DS';
		insert mergePdf2;

		List<Intrax_Program_Upload__c> ipuList = [select Id,Document_Guid__c,Document_Service__c from Intrax_Program_Upload__c];
		List<String> guids = new List<String>();
		for (Intrax_Program_Upload__c ipu : ipuList)
		{
			guids.add(ipu.Document_Guid__c);
		}
		MergPdfObj.setTestMode();
		MergPdfObj.bulkload(guids);	       
      
      try{
    	 string status='OK';
         IPUController.Confirm();
      }catch(Exception e) {
      }
      IPUController.doCancel();
      IPUController.PrefixList();
      Map<String,String> PrefixList = new Map<String,String>();
      IPUController.ListViewURL(PrefixList, 'Intrax_Program_Upload__c','All');
      Test.stopTest();
      }
}