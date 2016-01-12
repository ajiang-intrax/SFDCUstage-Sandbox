@isTest(seeAllData=false)

private class Test_ScormWebService {

    static testMethod void myUnitTest() {
    	ScormWebService sws = new ScormWebService();
    	sws.setTestMode();
    	sws.body = 'testbody';
    	sws.courseId = sws.generateGUID();
    	String regId = sws.CreateRegistration();
    	sws.getLaunchUrl(regId , '0A21800000005F1' ,True,'A2180000');
    	sws.getRegistrationResult(regId,'A21800000');
    	ScormWebService.Courselaunch Cl = new ScormWebService.Courselaunch();
    }
}