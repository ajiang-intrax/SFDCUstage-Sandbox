@isTest(seeAllData=false)
private class Test_Constants_CloneApp {
		
	static testMethod void myUnitTest() {           
        map<String, String> PERSONINFO_NOT_CLONED_FIELDS = Constants_CloneApp.PERSONINFO_NOT_CLONED_FIELDS;
        map<String, String> APPLICANTINFO_NOT_CLONED_FIELDS = Constants_CloneApp.APPLICANTINFO_NOT_CLONED_FIELDS;
    }
    

}