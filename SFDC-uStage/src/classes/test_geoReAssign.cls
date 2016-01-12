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
@isTest(seeAllData=True)
private class test_geoReAssign {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        
        Area__c area = new Area__c();
        area.Name = 'Anna Shafi - 880 Cooridor-East Bay';
        if(uList!=null && uList.size()>0)
        area.Area_Director__c = uList[0].Id;
        insert area;
        
        Area__c newArea = new Area__c();
        newArea.Name = 'Oakland Hills';
        if(uList!=null && uList.size()>0)
        newArea.Area_Director__c = uList[1].Id;
        insert newArea;
        
        Zip_Code__c zip = new Zip_Code__c();
        zip.Name = 'Z-94587';
        zip.City__c = 'UNION CITY';
        zip.State__c = 'CA';
        zip.zip_code__c = '94587';
        zip.Type__c = 'STANDARD';
        zip.Area__c = area.Id;
        insert zip;
        
        iGeoLocate__c iGL = new iGeoLocate__c();
        iGL.Contact__c = uList[1].ContactId;
        insert iGL;
        
        GeoMatch__c placeHolderGM = new GeoMatch__c();
        placeHolderGM.Assignment_Type__c = 'Temporary';
        placeHolderGM.Previous_Zip_Code__c = zip.Id;
        placeHolderGM.New_Area__c = newArea.Id;
        placeHolderGM.FromiGeoLocate__c = iGL.Id;
        placeHolderGM.Match_Status__c='Geo Prematch';
        placeHolderGM.serializedMatchMatrix__c = Test_IntraxTestConstants.googleGeoSerializedMatrixSampleResponse;
        insert placeHolderGM;
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(placeHolderGM);
		GeoReassign geoReAss = new GeoReAssign(controller);
		GeoReassign.MyWrapper a = new GeoReassign.MyWrapper('HF','22','22');
        geoReAss.placeHolderGeoMatch = placeHolderGM;        
        geoReAss.showPreMatch();
        //geoReAss.continueMethod();
        geoReAss.retainMethod();
        geoReAss.Visualize();
        geoReAss.AssignToHF();
        geoReAss.CancelAndReturn();
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        
        Area__c area = new Area__c();
        area.Name = 'Anna Shafi - 880 Cooridor-East Bay';
        if(uList!=null && uList.size()>0)
        area.Area_Director__c = uList[0].Id;
        insert area;
        
        Area__c newArea = new Area__c();
        newArea.Name = 'Oakland Hills';
        if(uList!=null && uList.size()>0)
        newArea.Area_Director__c = uList[1].Id;
        insert newArea;
        
        Zip_Code__c zip = new Zip_Code__c();
        zip.Name = 'Z-94587';
        zip.City__c = 'UNION CITY';
        zip.State__c = 'CA';
        zip.zip_code__c = '94587';
        zip.Type__c = 'STANDARD';
        zip.Area__c = area.Id;
        insert zip;
        
        iGeoLocate__c iGL = new iGeoLocate__c();
        iGL.Contact__c = uList[1].ContactId;
        insert iGL;
        
        GeoMatch__c placeHolderGM = new GeoMatch__c();
        placeHolderGM.Assignment_Type__c = 'Temporary';
        placeHolderGM.Previous_Zip_Code__c = zip.Id;
        placeHolderGM.New_Area__c = newArea.Id;
        placeHolderGM.FromiGeoLocate__c = iGL.Id;
        placeHolderGM.Match_Status__c='Geo Prematch';
        placeHolderGM.serializedMatchMatrix__c = Test_IntraxTestConstants.googleGeoSerializedMatrixSampleResponse;
        insert placeHolderGM;
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(placeHolderGM);
        ApexPages.currentPage().getParameters().put('OriginalGeoMatchId', placeHolderGM.Id);
        ApexPages.currentPage().getParameters().put('sType', 'reAssignHF');
		GeoReassign geoReAss = new GeoReAssign(controller);
		GeoReassign.MyWrapper a = new GeoReassign.MyWrapper('HF','22','22');
        geoReAss.placeHolderGeoMatch = placeHolderGM;  
        geoReAss.originalGeoMatchId = placeHolderGM.Id;
        geoReAss.showPreMatch();        
        geoReAss.retainMethod();
        geoReAss.Visualize();
        geoReAss.AssignToHF();
        geoReAss.CancelAndReturn();
        Test.stopTest();
    }
}