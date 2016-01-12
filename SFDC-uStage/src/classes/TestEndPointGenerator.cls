@isTest(seeAllData=false)
public class TestEndPointGenerator {
    static testMethod void myUnitTest() {
    	System.assert(EndPointGenerator.getEndpoint('fileUploadUrl')!=null,true);
    }
}