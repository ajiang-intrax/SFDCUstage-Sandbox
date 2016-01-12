public without sharing class FlowPersonInfoController {
    
    public Person_Info__c personInfo{get; set;}
    
    public FlowPersonInfoController(ApexPages.StandardController controller){
       personInfo = (Person_Info__c)controller.getRecord();
    }   
    
    //Redirect Ayusa flows to the Application, but all others to the Account or Lead page if it exists.
    //Ayusa users may not have a license that lets them see standard objects.
    public PageReference getFinishPage() {
                    
            return new PageReference('/'+personInfo.Id);   
      
    }
     public PageReference DeclineReference() {
                    
          if(ApexPages.currentPage().getParameters().get('persId') != null){
               List<Person_Info__c> HostFamilyReferences = [SELECT Id,First_Name__c,Reference_Url__c,Reference_Requested__c,Reference_Declined__c,Date_Of_Birth__c,Reference_Created_Date__c from Person_Info__c 
                                                          where id = :ApexPages.currentPage().getParameters().get('persId')];
                      system.debug('**persreferences***'+HostFamilyReferences);   
                                                     
                      for (Person_Info__c pers : HostFamilyReferences)
                      {
                     
                          pers.Reference_Declined__c=true;
                          pers.Reference_Created_Date__c = System.Today();
                          update pers;
                        
                      }
            }         
            return null;
    }
    
   /* static testMethod void testIt(){
        test.startTest();
        Applicant_Info__c a = new Applicant_Info__c();
        a.Intrax_Program__c = 'Internship';
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
}