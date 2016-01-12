@isTest(seeAllData=true)
private class Test_SiteLoginController {

    static testMethod void myUnitTest() {
        
        // Instantiate a new controller with all parameters in the page
        System.currentPageReference().getParameters().put('uIn','APCHF');
        ApexPages.currentPage().getHeaders().put('USER-AGENT', 'rv:11.0');
        ApexPages.currentPage().getParameters().put('startURL', '/Positions?');       
        //System.assertEquals(controller.login(),null);    
        
        User user1 = [SELECT Id, Name, User_Interests__c From User WHERE User_Interests__c = 'Becoming a high school exchange student' LIMIT 1];
        
        SiteLoginController src = new SiteLoginController(new Apexpages.StandardController(user1));
        System.currentPageReference().getParameters().put('uIn','APCHF');
        SiteLoginController srcnoParam = new SiteLoginController();
        
        src.username = 'marlon.brando@intraxinc.com';
        src.password = 'test0000';
        
        
        
        test.StartTest();
              
           system.runAs(user1){
                //ApexPages.currentPage().getParameters().put('startURL1', 'testt');     
                src.login();
                src.nextPage='SomeValue';
                ApexPages.currentPage().getHeaders().put('USER-AGENT', 'rv:11.0');
                src.checkLogin();
                ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mobi');
                src.checkLogin();
                src.username = null;
                ApexPages.currentPage().getParameters().put('unauth', 'true');
                ApexPages.currentPage().getParameters().put('startURL', 'hola');
                src.login();
                ApexPages.currentPage().getParameters().put('startURL', null);
                ApexPages.currentPage().getParameters().put('nextPage', 'aaaa');
                src.login();
                /*System.currentPageReference().getParameters().put('startURL','/Positio');
                System.currentPageReference().getHeaders().put('USER-AGENT','rv:12.0');
                System.currentPageReference().getParameters().put('unauth','true');
                System.currentPageReference().getHeaders().put('USER-AGENT','rv:11.0');*/
            }
            
        test.StopTest();    
    }
}