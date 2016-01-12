public with sharing class FlowUploadController {
    public List<Position__c> lstPos;
  public string partialUrl {get;set;}
  public string derivedUrl{get;set;}
  public String strEid{get;set;}
  public string returnId;
  public List<Applicant_Info__c> lstApp;
public static boolean isApexNotTested= True;
public static string applicantId;

    public Applicant_Info__c applicantInfo{get; set;}
     public Flow.Interview.Internship_PT_Leads_USA InternFlow {get; set;}
    public FlowUploadController (){
     
    }   
 
    public PageReference getFinishPage() {
        
    PageReference nextPage;
        
        if(InternFlow != null) returnId = InternFlow.appinfoid;
  
         system.debug('******** returnId*******'+ returnId);     
         system.debug('******** InternFlow*******'+ InternFlow);
         if(isApexNotTested)
         {
         lstApp = [Select  (Select Citizenship__c From Person_Info__r), Id  From Applicant_Info__c  where Id = :returnId limit 1];
         }
         else
         {
             lstApp = [Select  (Select Citizenship__c From Person_Info__r), Id  From Applicant_Info__c  where Id = :applicantId limit 1];
         }        
        if(lstApp!=null && lstApp.size()!=0)
        {
            System.debug('****lstApp*****'+lstApp);
         for(Applicant_Info__c app :lstApp)
        { 
            if(app.Person_Info__r.size() > 0)
            {
                for (Person_Info__c p :app.Person_Info__r)
                {
                    if(p.Citizenship__c == 'United States')
                    {
                        System.debug('****Citizenship__c*****'+p.Citizenship__c);
                        nextPage = new PageReference('/FlowUploadController');
                   }
                   else
                   { 
                     nextPage = new PageReference('/FlowResumeUpload');
                     nextPage.getParameters().put('AppInfoID',returnId); 
                   }
                }
            }
        }
        }   
         
        System.debug('****nextPage*****'+nextPage);
        
         return nextPage;
    }}
   
       
    
    /*static testMethod void testIt(){
        test.startTest();
        Applicant_Info__c a = new Applicant_Info__c();
        a.Last_Name__c = 'test';
        a.Street__c = 'test';
        a.City__c = 'test';
        a.State__c = 'CA';
        a.Postal_Code__c = '12345';
        a.Country__c = 'United States';
        a.Home_Phone__c = '12345';
        a.Date_of_Birth__c = date.ValueOf('1968-09-21');
        a.Email__c = 'test@test.com';
        insert a;
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        PageReference flsync = Page.FLAppSyncLeadExists;
        FlowController fc = new FlowController(sc);
        Test.setCurrentPageReference(flsync);
        fc.getFinishPage();     
        test.stopTest();
    }*/