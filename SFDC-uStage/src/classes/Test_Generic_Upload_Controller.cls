@isTest
public with sharing class Test_Generic_Upload_Controller {
    static testMethod void myUnitTest() {
             //Create Test Data
            RecordType IGIApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
            RecordType WTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
            RecordType APCHFApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
            RecordType APCPTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
           
            Applicant_Info__c appInfo1 = new Applicant_Info__c(Name = 'test', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',type__c='Participant',Application_Stage__c = 'Declined - Agent',
                                        ETR_Received_Date__c=null, recordTypeId = IGIApplRecordType.Id);
            insert appInfo1;

           	system.debug('*******appInfoid****'+appInfo1.Id);
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo1.Id);
            insert personInfo;
            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
            Generic_Upload_Controller.applicantId=appInfo1.Id;
            ApexPages.CurrentPage().getParameters().put('eid', appInfo1.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
        	
       
        	//system.debug('******ref*********'+guc.strRef);
       		guc.redirect();
        	Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
             //Create Test Data
            RecordType IGIApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
            RecordType WTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
            RecordType APCHFApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
            RecordType APCPTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
           
            
            Applicant_Info__c appInfo2 = new Applicant_Info__c(Name = 'test', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',type__c='Participant',Application_Stage__c = 'Declined - Agent',
                                        ETR_Received_Date__c=null, recordTypeId = WTApplRecordType.Id);
            insert appInfo2;
            
            
           	system.debug('*******appInfoid****'+appInfo2.Id);
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo2.Id);
            insert personInfo;
            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
        	
        	Generic_Upload_Controller.applicantId=appInfo2.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', appInfo2.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
           
       
        	//system.debug('******ref*********'+guc.strRef);
       		guc.redirect();
        	Test.stopTest();
    }
    
    static testMethod void myUnitTest3() {
             //Create Test Data
            RecordType IGIApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
            RecordType WTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
            RecordType APCHFApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
            RecordType APCPTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
                       
            Applicant_Info__c appInfo3 = new Applicant_Info__c(Name = 'test', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',type__c='Host Family',Application_Stage__c = 'Declined - Agent',
                                        ETR_Received_Date__c=null, recordTypeId = APCHFApplRecordType.Id);
            insert appInfo3;            
            
           	system.debug('*******appInfoid****'+appInfo3.Id);
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo3.Id);
            insert personInfo;
            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
            
            Generic_Upload_Controller.applicantId=appInfo3.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', appInfo3.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
            
       
        	//system.debug('******ref*********'+guc.strRef);
       		guc.redirect();
        	Test.stopTest();
    }
    
    static testMethod void myUnitTest4() {
             //Create Test Data
            RecordType IGIApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='ICD Intern PT' Limit 1];
            RecordType WTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='Work Travel PT' Limit 1];
            RecordType APCHFApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
            RecordType APCPTApplRecordType = [select id,Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare PT' Limit 1];
                       
            Applicant_Info__c appInfo4 = new Applicant_Info__c(Name = 'test', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345',type__c='Participant',Application_Stage__c = 'Declined - Agent',
                                        ETR_Received_Date__c=null, recordTypeId = APCPTApplRecordType.Id);
            insert appInfo4;
            
           	system.debug('*******appInfoid****'+appInfo4.Id);
            Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, First_Name__c  = UserInfo.getFirstName(), Applicant_Info__c = appInfo4.Id);
            insert personInfo;
            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
                        
            Generic_Upload_Controller.applicantId=appInfo4.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', appInfo4.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
       
        	//system.debug('******ref*********'+guc.strRef);
       		guc.redirect();
        	Test.stopTest();
    }
    /*
    static testMethod void myUnitTest5() {
             //Create Test Data
                       
            Position__c pos1 = new Position__c(Name = 'test', Street__c = 'test', City__c = 'test', State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Status__c ='Matching', Intrax_Program__c = 'Internship');
            insert pos1;
            
           	system.debug('*******appInfoid****'+pos1.Id);
            
            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
                        
            //Generic_Upload_Controller.applicantId=appInfo4.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', pos1.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
       
        	//system.debug('******ref*********'+guc.strRef);
       		guc.redirect();
        	Test.stopTest();
    }
    */
    static testMethod void myUnitTest6() {
             //Create Test Data
                       
            Case myCase = new Case(Status = 'New');
            insert myCase;
           	system.debug('*******appInfoid****'+myCase.Id);
            
            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
                        
            //Generic_Upload_Controller.applicantId=appInfo4.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', myCase.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
			guc.redirect();
        	Test.stopTest();
    }
    
     static testMethod void myUnitTest7() {
             //Create Test Data
                       
            Group__c gr = new Group__c(Name = 'test');
            insert gr;

            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
                        
            //Generic_Upload_Controller.applicantId=appInfo4.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', gr.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
			guc.redirect();
        	Test.stopTest();
    }
    
    static testMethod void myUnitTest8() {
             //Create Test Data
                       
            User_Profile__c up = new User_Profile__c(Name = 'test');
            insert up;

            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
                        
            //Generic_Upload_Controller.applicantId=appInfo4.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', up.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
			guc.redirect();
        	Test.stopTest();
    }
    
    static testMethod void myUnitTest9() {
             //Create Test Data
                       
            Position_Info__c pinfo = new Position_Info__c(Name = 'test');
            insert pinfo;

            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
                        
            //Generic_Upload_Controller.applicantId=appInfo4.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', pinfo.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
			guc.redirect();
        	Test.stopTest();
    }
    
    static testMethod void myUnitTest10() {
             //Create Test Data
                       
            Engagement__c eng = new Engagement__c(Name = 'test');
            insert eng;

            Test.startTest();
            Generic_Upload_Controller.isApexNotTested=false;
                        
            //Generic_Upload_Controller.applicantId=appInfo4.Id;
        	ApexPages.CurrentPage().getParameters().put('eid', eng.Id);
            Generic_Upload_Controller guc = new Generic_Upload_Controller();
			guc.redirect();
        	Test.stopTest();
    }
}