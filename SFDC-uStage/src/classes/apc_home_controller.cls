public with sharing class apc_home_controller {
    
    public home_controller myHome{get;set;}
    public apc_match_controller myHomeMatch{get;set;}
    //public apc_match_controller myProfile{get;set;}
    public search_controller mySearch{get;set;}
    public apc_pt_invoice_controller myInvoiceController{get;set;}
    public String URLAux{get;set;}
    
    // Default constructor
    public apc_home_controller(){
        
        /* 
         All the generic code like retrieving application, match, opportunity, engagemnt information should be done here.
         and then the instance of this main controller has to be passed to child controller instead of again re-quering it 
         in the child controller.
         */
        
        URLAux = ApexPages.currentPage().getUrl(); 
        
        //The child controllers has to intialized as per the page invoked and then just return.
        if(URLAux!=null && (URLAux.contains('/apex/apc_ap_travel_payment_confirmation')||
                            URLAux.contains('/apex/apc_ap_travel_payment_confirmation_pdf')||
                            URLAux.contains('/apex/apc_ap_main_payment_confirmation')||
                            URLAux.contains('/apex/apc_ap_main_payment_confirmation_pdf')))
        {
            myInvoiceController = new apc_pt_invoice_controller('PaymentConfirmed');
            return;
        }
        
        if(URLAux!=null && (URLAux.contains('/apex/apc_ap_main_payment')))
        {
            myHome = new home_controller();
            myInvoiceController = new apc_pt_invoice_controller(myHome);
            return;
        }
        
        /*This is not correct. We are actually calling all constructors irrespective of what page is invoked. 
        So with the new architecture we are actually running more SOQL queries than before. This has to be change at some point.*/
        myHome = new home_controller();
        myHomeMatch= new apc_match_controller(); 
        if(URLAux!=null && URLAux.contains('apc_ap_community')){
            mySearch = new search_controller();
        }
        
        /*Here am passing the child controller 'myHome' to my invoice controller because I dont want re-run all those queries.
        I will just the myhome controller class variables directly.*/
        //myInvoiceController = new apc_pt_invoice_controller(myHome);
        //myProfile = new apc_match_controller('Engagement__c');
    }    
    
    public APC_ArrivalDates__c APCArrivalDates {
        get{        
            APC_ArrivalDates__c APCArrivalDates = new APC_ArrivalDates__c();
            APCArrivalDates = apc_portal_utilities.MatchRequestDeadline();
            return APCArrivalDates;
        }       
    }
}