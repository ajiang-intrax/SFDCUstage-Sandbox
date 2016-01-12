@isTest(seeAllData=true)
private class Test_GoogleGeoController {
	static testMethod void myUnitTest() {
		//Instantiate 
		googleGeoController ggeoc = new googleGeoController();
		//Setting Mock Responses
		//GeoCode Response
		StaticResourceCalloutMock googleGeoCodeResponse = new StaticResourceCalloutMock();
		googleGeoCodeResponse.setStaticResource('googleGeoCodeResponse');
		googleGeoCodeResponse.setStatusCode(200);
		//googleGeoCodeResponse.setHeader('Content-Type', 'application/json');
		//DistanceMatrix Response
		StaticResourceCalloutMock googleDistanceMatrixResponse = new StaticResourceCalloutMock();
		googleDistanceMatrixResponse.setStaticResource('googleDistanceMatrixResponse');
		googleDistanceMatrixResponse.setStatusCode(200);
		//googleDistanceMatrixResponse.setHeader('Content-Type', 'application/json');
		
		googleGeoController.isTestMode = true;
		//Test.setMock(HttpCalloutMock.class, googleGeoCodeResponse);
		ggeoc.sObjectList = [SELECT Id FROM Account WHERE RecordType.Name='AuPairCare HF' AND ID IN (select Account__c from Applicant_Info__c where Intrax_Program__c = 'AuPairCare') LIMIT 10];
		ggeoc.theInstanceGateKeeper();
		googleGeoController.iAmAlreadyCalled = false;
		ggeoc.sObjectList = [SELECT Id FROM Contact WHERE Title='Area Director' LIMIT 10];
		ggeoc.theInstanceGateKeeper();
		googleGeoController.iAmAlreadyCalled = false;
		ggeoc.sObjectList = [select Id from Applicant_Info__c where Intrax_Program__c = 'AuPairCare' LIMIT 10];
		ggeoc.theInstanceGateKeeper();
        googleGeoController.iAmAlreadyCalled = false;
		ggeoc.sObjectList = [select Id,PostalCode,ownerId,Sys_Admin_Tag__c from Lead where Intrax_Programs__c = 'AuPairCare' LIMIT 10];
		ggeoc.theInstanceGateKeeper();
        googleGeoController.iAmAlreadyCalled = false;
		ggeoc.sObjectList = [select Id from Zip_Code__c where Area__c!=null LIMIT 10];
		ggeoc.theInstanceGateKeeper();
        googleGeoController.iAmAlreadyCalled = false;
		ggeoc.sObjectList = [SELECT Id FROM iGeoLocate__c WHERE Account__c!=NULL AND Account__r.Geo_Validation_Status__c='Validation Done' LIMIT 1];
		ggeoc.theInstanceGateKeeper();
		//ApexPages.StandardController sc = new ApexPages.StandardController();
		//googleGeoController ggeoco1 = new googleGeoController(sc);
		ggeoc.sObjectList = [SELECT Id FROM Account WHERE RecordType.Name='AuPairCare HF' AND ID IN (select Account__c from Applicant_Info__c where Intrax_Program__c = 'AuPairCare')];
		ggeoc.theInstanceGateKeeper();
		
	}
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        List<Account> HFAccList = [SELECT Id FROM Account WHERE RecordType.Name='AuPairCare HF' AND ID IN (select Account__c from Applicant_Info__c where Intrax_Program__c = 'AuPairCare') LIMIT 10];
        List<Applicant_Info__c> HFAppList = [SELECT Id FROM Applicant_Info__c WHERE Type__c='Host Family' AND Intrax_Program__c='AuPairCare' AND Account__c!=null LIMIT 10];
        
        iGeoLocate__c FromiGeoL = [SELECT Id FROM iGeoLocate__c WHERE Account__c!=NULL AND Account__r.Geo_Validation_Status__c='Validation Done' LIMIT 1];
        Set<Id> fromGeoLs = new Set<Id>();
        fromGeoLs.add(FromiGeoL.Id);
        
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
        iGL.GeoAddress__Latitude__s = 37.23423423;
        iGL.GeoAddress__Longitude__s = 38.23423;
        insert iGL;
        
        Set<Id> igeoLs = new Set<Id>();
        iGeoLs.add(iGL.Id);
        
        GeoMatch__c placeHolderGM = new GeoMatch__c();
        placeHolderGM.Assignment_Type__c = 'Temporary';
        placeHolderGM.Previous_Zip_Code__c = zip.Id;
        placeHolderGM.New_Area__c = newArea.Id;
        placeHolderGM.FromiGeoLocate__c = FromiGeoL.Id;
        placeHolderGM.ToiGeoLocate__c = iGL.Id;
        placeHolderGM.Match_Status__c='Geo Matched';
        placeHolderGM.serializedMatchMatrix__c = Test_IntraxTestConstants.googleGeoSerializedMatrixSampleResponse;
        insert placeHolderGM;
        
        List<GeoMatch__c> geoMatchesForChOwnParam = new List<GeoMatch__c>();
        geoMatchesForChOwnParam.add(placeHolderGM);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', HFAppList[0].Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(placeHolderGM);
		GoogleGeoController ggeoC = new GoogleGeoController(controller);
        googleGeoController.isTestMode = true;
		//Test.setMock(HttpCalloutMock.class, googleGeoCodeResponse);
		ggeoc.sObjectList = [SELECT Id FROM Account WHERE RecordType.Name='AuPairCare HF' AND ID IN (select Account__c from Applicant_Info__c where Intrax_Program__c = 'AuPairCare')];
		//ggeoc.theInstanceGateKeeper();
		GoogleGeoController.theGateKeeper(iGeoLs);
        GoogleGeoController.getStaffContactDetails(uList[0].ContactId);
        GoogleGeoController.getHostFamilyContactDetails(HFAccList[0].Id);
        ggeoc.HFChangeOwner();
        GoogleGeoController.computeDistance_future(FromiGeoL.Id,iGeoLs,zip.Id,false);
        GoogleGeoController.computeDistance_future(FromiGeoL.Id,iGeoLs,null,false);
        GoogleGeoController.computeDistance(fromGeoLs,iGeoLs);        
        Test.stopTest();
    }
    
    static testMethod void myUnitTest3() {
        // TO DO: implement unit test
        
        List<User> uList = [SELECT Id,ContactId,Profile.Name,Title FROM User WHERE Profile.Name='APC AD PC' AND ContactId!=null AND Title='Area Director'];
        List<Account> HFAccList = [SELECT Id FROM Account WHERE RecordType.Name='AuPairCare HF' AND ID IN (select Account__c from Applicant_Info__c where Intrax_Program__c = 'AuPairCare' AND Account__r.Geo_Validation_Status__c='Validation Done') LIMIT 10];
        List<Applicant_Info__c> HFAppList = [SELECT Id FROM Applicant_Info__c WHERE Type__c='Host Family' AND Intrax_Program__c='AuPairCare' AND Account__c!=null LIMIT 10];
        
        iGeoLocate__c FromiGeoL = [SELECT Id FROM iGeoLocate__c WHERE Account__c!=NULL AND Account__r.Geo_Validation_Status__c='Validation Done' LIMIT 1];
        Set<Id> fromGeoLs = new Set<Id>();
        fromGeoLs.add(FromiGeoL.Id);
        
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
        
        iGeoLocate__c iGLZip = new iGeoLocate__c();
        iGLZip.zip_code__c = zip.Id;
        iGLZip.GeoAddress__Latitude__s = 38.23423423;
        iGLZip.GeoAddress__Longitude__s = 39.23423;
        insert iGLZip;
        
        iGeoLocate__c iGL = new iGeoLocate__c();
        iGL.Contact__c = uList[1].ContactId;
        iGL.GeoAddress__Latitude__s = 37.23423423;
        iGL.GeoAddress__Longitude__s = 38.23423;
        insert iGL;
        
        Set<Id> igeoLs = new Set<Id>();
        iGeoLs.add(iGL.Id);
        
        GeoMatch__c placeHolderGM = new GeoMatch__c();
        placeHolderGM.Assignment_Type__c = 'Temporary';
        placeHolderGM.Previous_Zip_Code__c = zip.Id;
        placeHolderGM.New_Area__c = newArea.Id;
        placeHolderGM.FromiGeoLocate__c = FromiGeoL.Id;
        placeHolderGM.ToiGeoLocate__c = iGL.Id;
        placeHolderGM.Match_Status__c='Geo Matched';
        placeHolderGM.serializedMatchMatrix__c = Test_IntraxTestConstants.googleGeoSerializedMatrixSampleResponse;
        insert placeHolderGM;
        
        List<GeoMatch__c> geoMatchesForChOwnParam = new List<GeoMatch__c>();
        geoMatchesForChOwnParam.add(placeHolderGM);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', placeHolderGM.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(placeHolderGM);
		GoogleGeoController ggeoC = new GoogleGeoController(controller);
        googleGeoController.isTestMode = true;
		//Test.setMock(HttpCalloutMock.class, googleGeoCodeResponse);
		ggeoc.sObjectList = [SELECT Id FROM Account WHERE RecordType.Name='AuPairCare HF' AND ID IN (select Account__c from Applicant_Info__c where Intrax_Program__c = 'AuPairCare')];
		
        //ggeoc.loadGeoMatrix();
        //ggeoc.loadGeoMatrix1xn();
        ggeoc.applicantInfo = HFAppList[0];
        ggeoc.handleGeoProcesses();
        
        GeoMatch__c placeHolderGM2 = new GeoMatch__c();
        placeHolderGM2.Assignment_Type__c = 'Temporary';
        placeHolderGM2.Previous_Zip_Code__c = zip.Id;
        placeHolderGM2.New_Area__c = newArea.Id;
        placeHolderGM2.FromiGeoLocate__c = FromiGeoL.Id;
        placeHolderGM2.ToiGeoLocate__c = iGL.Id;
        placeHolderGM2.Match_Status__c='Geo ReMatch';
        placeHolderGM2.serializedMatchMatrix__c = Test_IntraxTestConstants.googleGeoSerializedMatrixSampleResponse;
        insert placeHolderGM2;
                
        ggeoc.reAssignHF();
        ApexPages.currentPage().getParameters().put('OriginalGeoMatchId', placeHolderGM.Id);
        ggeoc.matchedToGeoLocateId = iGL.Id;
        ggeoc.associateAdWithHF();
        ggeoc.geoMatch = placeHolderGM;
        //ggeoc.autoMatchMaking();
        ggeoc.changeOwnerForGeoMatchedApplications(geoMatchesForChOwnParam);
        ApexPages.currentPage().getParameters().put('stype', 'reAssignHF');        
        ggeoc.justGoBackToMatch();
        ApexPages.currentPage().getParameters().put('goBackTo', 'SplitPage');
        ggeoc.justGoBackToMatch();
        
        ggeoc.staffContact = [SELECT Id FROM Contact WHERE Title='Area Director' LIMIT 1];
        ggeoc.HFAccount = HFAccList[0];
        ggeoc.HFLead = [select Id,PostalCode,ownerId,Sys_Admin_Tag__c from Lead where Intrax_Programs__c = 'AuPairCare' LIMIT 1];
        ggeoc.uniMatch = false;
        ggeoc.iGeoForAD = iGL;
                
        Test.stopTest();
    }
    
    static testMethod void myUnitTest4() {
        
    }
    
}