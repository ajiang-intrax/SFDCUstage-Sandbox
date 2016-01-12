@isTest(seeAllData=true)
public class Test_IGI_TIPP_Controller {
 public static testMethod void tippInputform_Tester(){
   
        //Account
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Participant' Limit 1];
        
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'Intership', Intrax_Program_Options__c = 'Business Internship',
                                                    Intrax_Region__c = 'United States', PersonEmail = 'test@test1.com');
        insert participantAccount;
       RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='ICD Intern PT' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, engagementRecordType != null);
        Date start_d=System.today() +20;
        Date end_d=System.today()+60;
       
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test11 Engagement', Account_Id__c = participantAccount.Id, RecordTypeId = engagementRecordType.ID,
                                                     Intrax_Program__c = 'Intership', Intrax_Program_Options__c = 'Business Internship', Intrax_Region__c = 'United States',
                                                     Type__c = 'Participant',  Program_Duration__c ='1 - 4 weeks',Engagement_Start__c=start_d,Engagement_End__c=end_d,
                                                     Program_Year__c ='2013', Status__c = 'Prospecting', Needs_Travel__c ='Yes',Placement_Status__c='Confirmed');
        insert engagement;
       
       //Record Type
        RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, hostCompanyRecordType != null);
         RecordType PosInfoRecordType = [select id, Name from RecordType where SobjectType='Position_Info__c' and Name='Training Plan' Limit 1];
        
        
        
        //Account
        Account account  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Internship', Intrax_Program_Options__c = 'Business Internship', Intrax_Region__c = 'United States');
        insert account;
   
      //Position
        Position__c position = new Position__c(Name = 'Test Position', Intrax_Program__c = 'Internship', Intrax_Program_Options__c = 'Business Internship', 
                                                        Intrax_Region__c = 'United States', Engagement_Start__c = System.today(),
                                                        Engagement_End__c = System.today().addDays(10), Host_Company_Id__c = account.Id,Country__c='Australia',Tipped_Position__c='No');
        insert position;
        User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            
            //Run in user context
         System.runAs(sysAdmin) {
             Match__c match = new Match__c(Name = 'Test Match', Position_Name__c = position.Id, Status__c = 'Assigned',
                                                Engagement__c = engagement.Id, Participant_Id__c= participantAccount.Id,
                                                Interview_Status__c = 'Scheduled');
              insert match;
             Match__c matchpdf = new Match__c(Name = 'Test PDF Match', Position_Name__c = position.Id, Status__c = 'Assigned',
                                                Engagement__c = engagement.Id, Participant_Id__c= participantAccount.Id,
                                                Interview_Status__c = 'Scheduled');
              insert matchpdf;
             Position_Info__c posInfo=new Position_Info__c(Name='PosInfo Test',Match__c=matchpdf.Id,RecordTypeId=PosInfoRecordType.Id,Status__c='Accepted');
             insert PosInfo;
            /* Application_Constants__c setting = new Application_Constants__c();
             setting.Name = 'RT_Position_Info_TIPP';
             setting.Key__c = 'RT_Position_Info_TIPP';
             setting.Value__c = '012190000008br8';
             insert setting;*/
             Test.startTest();
             ApexPages.StandardController sc1 = new ApexPages.StandardController(match);
             IGI_TIPP_Controller tipp1=new IGI_TIPP_Controller(sc1);
             IGI_TIPP_Controller tipp=new IGI_TIPP_Controller();
            ApexPages.StandardController sc = new ApexPages.StandardController(match);
             Pagereference p= new Pagereference('/apex/igi_tipp_host_company_info');
             //ApexPages.currentPage().getParameters().put('mId',match.Id);
            ApexPages.currentPage().getParameters().put('pInfo','true');
              Test.setCurrentPage(p);
             tipp.sMatch=match;
             tipp.preLoad();
             
             Position_Info__c pInfo = tipp.getPositionInfo();
             pInfo.Compensation_Type__c='Unpaid';
             tipp.updatePositionInfo();
             pInfo.Company_State__c='DDD';
             tipp.validatorhost();
             pInfo.Company_State__c='DD';
             pInfo = tipp.getPositionInfo();
             pInfo.Company_Postal_Code__c='3434334';
             tipp.validatorhost();
             pInfo.Company_Postal_Code__c='34334';
             pInfo = tipp.getPositionInfo();
             pInfo.EIN__c='34234234234324';
             tipp.validatorhost();
             pInfo.EIN__c='342342324';
             tipp.validatorhost();
             tipp.preLoad();
             String s= tipp.updatePosStatus();
             tipp.navigator();
             p= new Pagereference('/apex/igi_tipp_main?mId=');
             Test.setCurrentPage(p);
             ApexPages.currentPage().getParameters().put('mId',match.Id);   
             tipp.getPosInfo();
             ApexPages.currentPage().getParameters().put('val','n_v'); 
             tipp.validator();
             ApexPages.currentPage().getParameters().put('nextPage','/apex/igi_tipp_new_phase'); 
             ApexPages.currentPage().getParameters().put('nPlan','true'); 
             tipp.loadplan();
             ApexPages.currentPage().getParameters().put('val','d_v'); 
             tipp.validator();
             p=tipp.navigator();
             Test.setCurrentPage(p);
             tipp.getcheckstartdate();
             tipp.getcheckEnddate();
             tipp.deletePlan();
             tipp.validate_phasedate();
             Development_Plan__c dp=tipp.getPlan();
             ApexPages.currentPage().getParameters().put('mId',match.Id);  
             ApexPages.currentPage().getParameters().put('nextPage','/apex/igi_tipp_phase_detail'); 
             ApexPages.currentPage().getParameters().put('up_plan','true');
             ApexPages.currentPage().getParameters().put('dpid',dp.Id);
             tipp.LoadSelectedPlan();
             tipp.getMatchId();
             tipp.gethosMatchId();
             p=tipp.navigator();
             ApexPages.StandardController sc_pdf = new ApexPages.StandardController(matchpdf);
             IGI_TIPP_PDF_Controller tipppdf=new IGI_TIPP_PDF_Controller(sc_pdf);
             ApexPages.currentPage().getParameters().put('Id',matchpdf.Id);   
             tipppdf.preLoad();  
          
             Test.stopTest();
         }		
 
 }
}