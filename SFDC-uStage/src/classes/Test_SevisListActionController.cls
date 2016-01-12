@isTest(seeAllData = true)
private class Test_SevisListActionController {
	static testmethod void myUnitTest(){
		test.startTest();
			List<Engagement__c> sevisEng = [select Sevis__c from Engagement__c where Sevis__c != null and Account_Id__c != null];
			List<Id> sevisIds = new List<Id>();
			for (Engagement__c eng : sevisEng){
				sevisIds.add(eng.Sevis__c);
			}
	
			List<Sevis__c> sevis = [select Id from Sevis__c where Id in :sevisIds limit 10];
	
			ApexPages.StandardSetController sc = new ApexPages.StandardSetController(sevis);
			sc.setSelected(sevis);
	
			SevisListActionController slac = new SevisListActionController(sc);
	
			slac.getAllData();
			slac.getPaymentData();
			slac.updateSelectedSevisRecs();
			slac.printPaymentXML();
			slac.downloadPaymentXML();
		test.stopTest();
	}
}