@isTest(seeAllData=true)
private class test_aws_controller {

    static testMethod void myAwsControllerTest() {
       
       PageReference p=Page.apc_hf_home; 
       Test.setCurrentPage(p); 
       
      
       User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
       
       //Record Type (Centers)
       RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
       
       Account myAccountPT = new Account(Name='Test');
       insert myAccountPT;
       
       Engagement__c myEngagement = new Engagement__c(Name='TestEngagement', Program_Duration__c = 'Academic Year', OwnerId=sysAdmin.Id);
       insert myEngagement;
       
       //Applicant Info PT
       Applicant_Info__c appInfoPT = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test',
                                                                  Postal_Code__c = '12345',  Type__c = 'Participant',
                                                                  Country__c = 'United States', Home_Phone__c = '12345',
                                                                  Application_Stage__c = 'Accepted', Application_Level__c = 'Main',
                                                                  Intrax_Program__c = 'AuPairCare', Engagement__c = myEngagement.id,
                                                                  RecordTypeId = rtAPC.Id, Account__c = myAccountPT.id, CreatedBy__c=sysAdmin.id,
                                                                  Primary_Language__c = 'English');
       insert appInfoPT;
       User_Profile__c usprof = new User_Profile__c(Name='test', User__c = sysAdmin.id );
       insert usprof;
       
       Intrax_Program_Upload__c ipUpload = new Intrax_Program_Upload__c(Document_Guid__c = 'Test', Document_service__c  = 'DS', Applicant_Info__c = appInfoPT.Id, Document_Type__c='Participant-Photo', User_Profile__c = usprof.id, Engagement__c = myEngagement.Id);
       insert ipUpload;
       
       Intrax_Program_Upload__c ipUploadVideo = new Intrax_Program_Upload__c(Document_Guid__c = 'Test00', Applicant_Info__c = appInfoPT.Id, Document_service__c  = 'DS', Engagement__c = myEngagement.Id, document_type__c = 'Introductory-Video', AWS_ET_Preset__c = 'Generic 720p');
       insert ipUploadVideo;
       
       list<Engagement__c> engList = new list<Engagement__c>();
       engList.add(myEngagement);
       map<String, Applicant_Info__c> mapAppToEng = new map<String, Applicant_Info__c>();
       mapAppToEng.put(myEngagement.Id, appInfoPT);
       
       list<Applicant_Info__c> appInfoList = new list<Applicant_Info__c>();
       appInfoList.add(appInfoPT);
       
       update appInfoList;
       list<String> incomingGUIDs = new list<String>();
       incomingGUIDs.add('test00');
       
       String StringGUID = 'test00';
       
       StaticResourceCalloutMock CreateMockResponse = new StaticResourceCalloutMock();
       CreateMockResponse.setStaticResource('CreateMockResponse');
       CreateMockResponse.setStatusCode(200);
       CreateMockResponse.setHeader('Content-Type', 'application/xml'); 
       
       Test.startTest();
       
       //Set request parameters
       ApexPages.currentPage().getParameters().put('docGuid', 'Test');
    
       Test.setMock(HttpCalloutMock.class, CreateMockResponse);
       
       aws_controller.getApcManagerPhoto(usprof.id);
       aws_controller.loadPhoto(appInfoPT);
       aws_controller.getVideosParticipant(myEngagement);
       //aws_controller.getVideosParticipant(appInfoPT);
       aws_controller.getParticipantPhotoList(engList, mapAppToEng);
       aws_controller.getParticipantPhotoList(appInfoList);
       aws_controller.getParticipantPhotoList(engList);
       aws_controller.getPhotoListThumb(incomingGUIDs);
       aws_controller.getPhotoURL(StringGUID);
       aws_controller.getPhotoList(incomingGUIDs);
       
       Test.stopTest();
    }
}