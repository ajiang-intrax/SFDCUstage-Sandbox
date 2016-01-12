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
private class test_googleGeoHelper {
    static testMethod void myunittest7(){
        Account HFAcc = new Account();
        HFAcc.recordTypeId = [SELECT Id FROM RecordType WHERE Name='AuPairCare HF' AND sObjectType='Account' LIMIT 1].Id;
        HFAcc.LastName = 'testhfacc';
        HFAcc.Phone = '2342342341';
        HFAcc.Type = 'Host Family';
        HFAcc.Status__c = 'Contracted';
        HFAcc.Intrax_Programs__c = 'AuPairCare';
        HFAcc.Intrax_Region__c = 'United States';
        HFAcc.PersonMailingPostalCode = '94108';
        insert HFAcc;
        
        Test.startTest();
        Test.setCurrentPage(new pageReference('Account'));
        ApexPages.StandardController controller = new ApexPages.StandardController(HFAcc);
        googleGeoHelper ggHelper = new googleGeoHelper();
        ggHelper.HFAccount = HFAcc;
        ggHelper.justGoBackToHFAccount();
        Test.stopTest();
    }
    
    static testMethod void myUnitTest6(){
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        
        Account HFAcc = new Account();
        HFAcc.recordTypeId = [SELECT Id FROM RecordType WHERE Name='AuPairCare HF' AND sObjectType='Account' LIMIT 1].Id;
        HFAcc.LastName = 'testhfacc';
        HFAcc.Phone = '2342342341';
        HFAcc.Type = 'Host Family';
        HFAcc.Status__c = 'Contracted';
        HFAcc.Intrax_Programs__c = 'AuPairCare';
        HFAcc.Intrax_Region__c = 'United States';
        HFAcc.PersonMailingPostalCode = '94108';
        insert HFAcc;
        
        iGeoLocate__c HFiGL = new iGeoLocate__c();
        HFiGL.Account__c = HFAcc.Id;
        insert HFiGL;
        
        Area__c area = new Area__c();
        area.Name = 'Anna Shafi - 880 Cooridor-East Bay';
        if(uList!=null && uList.size()>0)
        area.Area_Director__c = uList[0].Id;
        insert area;
        
        Zip_Code__c zip = new Zip_Code__c();
        zip.Name = 'Z-94108';
        zip.City__c = 'UNION CITY';
        zip.State__c = 'CA';
        zip.zip_code__c = '94108';
        zip.Type__c = 'STANDARD';
        zip.Area__c = area.Id;
        insert zip;
        
        List<Zip_Code__c> zipList = new List<Zip_Code__c>();
        zipList.add(zip);                
        Set<Id> selZipIds = new Set<Id>();
        selZipIds.add(zip.Id);
        
        Test.startTest();
        Test.setCurrentPage(new pageReference('geoZipCodesTab'));
        ApexPages.currentPage().getParameters().put('id', zip.Id);
        ApexPages.currentPage().getParameters().put('type', 'areaVisualizer');
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(zipList);
        googleGeoHelper ggHelper = new googleGeoHelper(controller); 
        ggHelper.newAreaZipList = new List<geoNewAreaZipsWrapperClass>();
        ggHelper.area = area;    
        ggHelper.areas = area.Id;
        ggHelper.zipCode = zip;
        ggHelper.selZipNames=selZipIds;
        ggHelper.displaySelectedZipCodes();
        ggHelper.createNewAreaFromSelectedZipCodes();
        ggHelper.newAreaName = 'testArea';
        //ggHelper.SaveNewArea();
        //ggHelper.assignZipToNewArea();        
        ggHelper.resetAndFilter();
        //ggHelper.populateAreasAndZipCount();        
        Test.stopTest();
    }
    
    static testMethod void myUnitTest5(){
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        
        Account HFAcc = new Account();
        HFAcc.recordTypeId = [SELECT Id FROM RecordType WHERE Name='AuPairCare HF' AND sObjectType='Account' LIMIT 1].Id;
        HFAcc.LastName = 'testhfacc';
        HFAcc.Phone = '2342342341';
        HFAcc.Type = 'Host Family';
        HFAcc.Status__c = 'Contracted';
        HFAcc.Intrax_Programs__c = 'AuPairCare';
        HFAcc.Intrax_Region__c = 'United States';
        insert HFAcc;
        
        iGeoLocate__c HFiGL = new iGeoLocate__c();
        HFiGL.Account__c = HFAcc.Id;
        insert HFiGL;
        
        Area__c area = new Area__c();
        area.Name = 'Anna Shafi - 880 Cooridor-East Bay';
        if(uList!=null && uList.size()>0)
        area.Area_Director__c = uList[0].Id;
        insert area;
        
        Zip_Code__c zip = new Zip_Code__c();
        zip.Name = 'Z-94587';
        zip.City__c = 'UNION CITY';
        zip.State__c = 'CA';
        zip.zip_code__c = '94587';
        zip.Type__c = 'STANDARD';
        zip.Area__c = area.Id;
        insert zip;
        
		iGeoLocate__c iGLZip = new iGeoLocate__c();
        iGLZip.Zip_Code__c = zip.Id;
        insert iGLZip;
        
        iGeoLocate__c iGL = new iGeoLocate__c();
        iGL.Contact__c = uList[1].ContactId;
        insert iGL;
        
        GeoMatch__c placeHolderGM = new GeoMatch__c();
        placeHolderGM.Assignment_Type__c = 'Temporary';
        placeHolderGM.Previous_Zip_Code__c = zip.Id;
        placeHolderGM.New_Area__c = area.Id;
        placeHolderGM.FromiGeoLocate__c = HFiGL.Id;
        placeHolderGM.ToiGeoLocate__c = iGL.Id;
        placeHolderGM.Match_Status__c='Geo Matched';
        placeHolderGM.serializedMatchMatrix__c = Test_IntraxTestConstants.googleGeoSerializedMatrixSampleResponse;
        insert placeHolderGM;
        
        Map<String,Id> maparea = new Map<String,Id>();
        maparea.put(area.Name, area.Id);
        
        Test.startTest();
        Test.setCurrentPage(new pageReference('geoZipCodesTab'));        
        ApexPages.StandardController controller = new ApexPages.StandardController(area);            
        googleGeoHelper g = new googleGeoHelper();
        g.areaNameIdMap = maparea;
        //googleGeoHelper ggHelper = new googleGeoHelper(controller);
        //ggHelper.areaNameIdMap = maparea;
        //ggHelper.areaNameIdMap = new Map<String,Id>();
        Test.stopTest();
    }
    
    
    static testMethod void myUnitTest4(){
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        
        Area__c area = new Area__c();
        area.Name = 'Anna Shafi - 880 Cooridor-East Bay';
        if(uList!=null && uList.size()>0)
        area.Area_Director__c = uList[0].Id;
        insert area;
        
        Zip_Code__c zip = new Zip_Code__c();
        zip.Name = 'Z-94587';
        zip.City__c = 'UNION CITY';
        zip.State__c = 'CA';
        zip.zip_code__c = '94587';
        zip.Type__c = 'STANDARD';
        zip.Area__c = area.Id;
        insert zip;
        
        
        Test.startTest();
        Test.setCurrentPage(new pageReference('geoZipCodesTab'));
        ApexPages.StandardController controller = new ApexPages.StandardController(zip);
        googleGeoHelper ggHelper = new googleGeoHelper(controller);
        Test.stopTest();
    }

    static testMethod void myUnitTest3(){
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        
        Area__c area = new Area__c();
        area.Name = 'Anna Shafi - 880 Cooridor-East Bay';
        if(uList!=null && uList.size()>0)
        area.Area_Director__c = uList[0].Id;
        insert area;
        
        Zip_Code__c zip = new Zip_Code__c();
        zip.Name = 'Z-94587';
        zip.City__c = 'UNION CITY';
        zip.State__c = 'CA';
        zip.zip_code__c = '94587';
        zip.Type__c = 'STANDARD';
        zip.Area__c = area.Id;
        insert zip;
        
        iGeoLocate__c iGLZip = new iGeoLocate__c();
        iGLZip.Zip_Code__c = zip.Id;
        insert iGLZip;
        
        Test.startTest();
        Test.setCurrentPage(new pageReference('geoZipCodesTab'));
        ApexPages.StandardController controller = new ApexPages.StandardController(iGLZip);
        googleGeoHelper ggHelper = new googleGeoHelper(controller);
        Test.stopTest();        
    }
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        
        Area__c area = new Area__c();
        area.Name = 'Anna Shafi - 880 Cooridor-East Bay';
        if(uList!=null && uList.size()>0)
        area.Area_Director__c = uList[0].Id;
        insert area;
        
        List<Area__c> areaList = new List<Area__c>();
        areaList.add(area);
        
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
        
        iGeoLocate__c iGLZip = new iGeoLocate__c();
        iGLZip.Zip_Code__c = zip.Id;
        //insert iGLZip;
        
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
        
        Test.setCurrentPage(new pageReference('geoNewAreaCreation'));
        ApexPages.StandardController controller = new ApexPages.StandardController(newArea);
		googleGeoHelper ggHelper = new googleGeoHelper(controller);
        
		gghelper.area = area;
		gghelper.areas = area.Name;
		gghelper.iGeoForAD = iGL;
		ApexPages.currentPage().getParameters().put('Id', placeHolderGM.Id);
		
		//ggHelper.doAllStatQuerying();
		//ggHelper.loadAreaDetails();
		//ggHelper.getAreaValues();
		//ggHelper.getAreas();
		//ggHelper.setAreas(area.Name);
		
		//ggHelper.assignZipToNewArea();
		//ggHelper.createNewZipForAreaAssociation();				
		ggHelper.doReassignments();
		ggHelper.redirectTo1xn();
		ggHelper.returnBackToPreGeoMatch();
		//this should be for Account in standardcontroller
		//ggHelper.justGoBackToHFAccount();
		
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
        
        List<Area__c> areaList = new List<Area__c>();
        areaList.add(area);
        
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
        
                
        
        Test.startTest();
        Test.setCurrentPage(new pageReference('geoAreasTab')); 
        googleGeoHelper g = new googleGeoHelper();
               
        g.doAllStatQuerying();
        //g.assignZipToNewArea();
        g.createNewZipForAreaAssociation();
        g.filterResults();
		Test.stopTest();
		
    }
    
}