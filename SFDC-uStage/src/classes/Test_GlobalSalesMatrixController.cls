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
@isTest(seeAllData=true)
private class Test_GlobalSalesMatrixController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test        
        LeadRouting__c leadRouting = new LeadRouting__c();  
        leadRouting.Lead_Type__c ='Host Company';
        leadRouting.Program__c = 'Internship';
        leadRouting.Country_of_Origin__c = 'Singapore';
        leadRouting.Country_of_Interest__c = 'United States';
        leadRouting.Queue__c = 'Outbound - EU';
        insert leadRouting;
        
        list<LeadRouting__c> lstLeadRouting = new list<LeadRouting__c>();
        lstLeadRouting.add(leadRouting);
        
        ApexPages.StandardController newCaseController = new ApexPages.StandardController(leadRouting);
        GlobalSalesMatrixController globalSalesmatrix = new GlobalSalesMatrixController(newCaseController);   
        
        ApexPages.StandardSetController newSetController = new ApexPages.StandardSetController(lstLeadRouting);
        GlobalSalesMatrixController globalSalesmatrixSet = new GlobalSalesMatrixController(newSetController);
             
       	globalSalesmatrix.objLeadRouting.Lead_Type__c ='Host Company';
        globalSalesmatrix.objLeadRouting.Program__c = 'Internship';
        globalSalesmatrix.objLeadRouting.Country_of_Origin__c = 'Singapore';
        globalSalesmatrix.objLeadRouting.Country_of_Interest__c = 'United States';
        globalSalesmatrix.objLeadRouting.Queue__c = 'Outbound - EU';
        globalSalesmatrix.filterRecord();
        
        system.assertEquals(1, globalSalesmatrix.lstLeadRoutingSelectdRecord.size());
        system.assertEquals(leadRouting.Id, globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Id);
        system.assertEquals(1, globalSalesmatrix.lstLeadRoutingdRecordCloned.size());
        system.assertEquals(leadRouting.Id, globalSalesmatrix.lstLeadRoutingdRecordCloned[0].Id);
        
        globalSalesmatrix.hasNext =  globalSalesmatrix.hasNext;
        globalSalesmatrix.hasPrevious = globalSalesmatrix.hasPrevious;
        globalSalesmatrix.pageNumber = globalSalesmatrix.pageNumber;
        globalSalesmatrix.nextPage();
        system.assertEquals(1, globalSalesmatrix.lstLeadRoutingSelectdRecord.size());
        globalSalesmatrix.previousPage();
        system.assertEquals(1, globalSalesmatrix.lstLeadRoutingSelectdRecord.size());
        globalSalesmatrix.firstPage();
        system.assertEquals(1, globalSalesmatrix.lstLeadRoutingSelectdRecord.size());
        globalSalesmatrix.lastPage();
        system.assertEquals(1, globalSalesmatrix.lstLeadRoutingSelectdRecord.size());
        
        system.assertEquals(leadRouting.Id, globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Id); 
    	
        globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Country_of_Interest__c = 'Spain';
        globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Country_of_Origin__c = 'Spain';
        globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Lead_Type__c = 'Host Family';
        globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Program__c = 'Ayusa';
        globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Queue__c = 'Ayusa';
        globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Intrax_Program__c = true;
        globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Intrax_Program_Option__c = true;
        globalSalesmatrix.updateRecord();
        
        system.assertEquals(1, globalSalesmatrix.lstLeadRoutingSelectdRecord.size());
        system.assertEquals(leadRouting.Id, globalSalesmatrix.lstLeadRoutingSelectdRecord[0].Id);
        system.assertEquals('Ayusa', globalSalesmatrix.lstLeadRoutingSelectdRecord[0].ProposedProgram__c);
        system.assertEquals('Spain', globalSalesmatrix.lstLeadRoutingSelectdRecord[0].ProposedCountryofInterest__c);
        system.assertEquals('Host Family', globalSalesmatrix.lstLeadRoutingSelectdRecord[0].ProposedLeadType__c); 
        system.assertEquals('Spain', globalSalesmatrix.lstLeadRoutingSelectdRecord[0].ProposedCountryofOrigin__c); 
       	
        globalSalesmatrix.objLeadRouting.StartDate__c = Date.today();
        globalSalesmatrix.objLeadRouting.EndDate__c = Date.today();
        globalSalesmatrix.submitDate();
        
        list<LeadRouting__c> lstSize = new list<LeadRouting__c>();
        for(LeadRouting__c itrLead : globalSalesmatrix.summaryRecord){
        	if(itrLead.Id == leadRouting.Id){
        		lstSize.add(itrLead);
        	}
        }
        system.assertEquals(1, lstSize.size());
        system.assertEquals(lstSize[0].Id, leadRouting.Id);
        
        globalSalesmatrix.newRecord();
        globalSalesmatrix.summaryDateSelection();
        globalSalesmatrix.backGSM();
        
        globalSalesmatrix.approvedRecordId = leadRouting.Id;
        globalSalesmatrix.appprovalAction();
        
        globalSalesmatrix.rejectedRecordId = leadRouting.Id;
        globalSalesmatrix.appprovalAction();
        
        globalSalesmatrix.newLeadRouting.Lead_Type__c ='Participant';
        globalSalesmatrix.newLeadRouting.Program__c = 'Internship';
        globalSalesmatrix.newLeadRouting.Country_of_Origin__c = 'Belgium';
        globalSalesmatrix.newLeadRouting.Country_of_Interest__c = 'Spain';
        globalSalesmatrix.newLeadRouting.Queue__c = 'Outbound - EU';
        globalSalesmatrix.createRecord();
        
        globalSalesmatrix.deletedRecordId = leadRouting.Id;
        globalSalesmatrix.deleteRecord();
        
        globalSalesmatrix.rejectedRecordId = leadRouting.Id;
        globalSalesmatrix.appprovalAction();
        
        leadRouting.NewRule__c = true;
        update leadRouting;
        globalSalesmatrix.approvedRecordId = leadRouting.Id;
        globalSalesmatrix.appprovalAction();
        
        globalSalesmatrix.excelGenerate();
        
    }
}