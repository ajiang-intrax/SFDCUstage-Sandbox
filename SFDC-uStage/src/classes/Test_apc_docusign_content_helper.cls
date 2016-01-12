@isTest(seeAllData=true)
public class Test_apc_docusign_content_helper 
{
	static testMethod void myUnitTest()
	{
		Match__c mat = [SELECT Position_Name__c, Position_Name__r.Host_Company_Id__c FROM Match__c WHERE Intrax_Program__c = 'AuPairCare' AND Position_Name__c != NULL LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', mat.Id);
		ApexPages.StandardController controller = new ApexPages.StandardController(mat);
		apc_docusign_content_helper ap = new apc_docusign_content_helper(controller);
		
		Applicant_Info__c app = [SELECT Account__c FROM Applicant_Info__c WHERE Intrax_Program__c = 'AuPairCare' AND Type__c = 'Host Family' AND Account__c != NULL LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', app.Id);
		ApexPages.StandardController controller1 = new ApexPages.StandardController(app);
		apc_docusign_content_helper ap1 = new apc_docusign_content_helper(controller1);
	}
}