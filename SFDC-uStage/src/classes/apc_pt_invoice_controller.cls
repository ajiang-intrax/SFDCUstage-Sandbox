public with sharing class apc_pt_invoice_controller {
    
    public home_controller myHome{get;set;}
    public List<Applicant_Info__c> ApplicantInfoList{get;set;}
    public list<Match__c> ConfMatchList{get;set;}
    public list<Member__c> memberlist{get;set;}
    public List<Opportunity> childOpportunityList{get;set;}
    public List<Opportunity> ParentOpportunityList{get;set;}
    public List<Person_info__c> personInfoList {get;set;}
    public Person_Info__c personInfo{get;set;}
    public Applicant_Info__c ApplicantInfo{get;set;}
    public Match__c ConfMatch{get;set;}
    public Opportunity ChildOpportunity{get;set;}
    public Opportunity ParentOpportunity{get;set;}
    public Pricing_Controller pc{get;set;}
    
    public Map<String,List<Opportunity_Product_Cart>> itemMap{get;set;}
    public Map<Date,List<Opportunity_Product_Cart>> StandardItemsDateMap{get;set;}
    public Map<Date,double> StandardItemsPriceMap{get;set;}
    public Map<date,double> SelectedItemsPriceMapDueNow{get;set;}
    public Map<date,double> SelectedItemsPriceMapDueLater{get;set;}
    public Map<Date,List<Opportunity_Product_Cart>> PaymentPlanItemsDateMap{get;set;}
    public Map<Date,double> PaymentPlanItemsPriceMap{get;set;}
    public Map<Date,List<Opportunity_Product_Cart>> InstallmentItemsDateMap{get;set;}
    public Map<Date,double> InstallmentItemsPriceMap{get;set;}
    
    public List<Opportunity_Product_Cart> selectedOppProdCartList{get;set;}
    public List<Opportunity_Product_Cart> oppProdCartList{get;set;}
    
    public Boolean paymentPlanAvailable{get;set;}
    public double StandardItemsTotalPrice{get;set;}
    public double InstallmentItemsTotalPrice{get;set;}
    public double paymentplanItemsTotalPrice{get;set;}
    public double selectedItemsTotalPrice{get;set;}
    public string selectedPlan{get;set;}
    public Integer NoOfInstallments{get;set;}
    //public string paramMatchId{get;set;}  
    public String className;
    public String URLAux{get;set;}
    public boolean schdPaymentsAvailable{get;set;}
    public Id paramAppId{get;set;}
    public Id paramMatchId{get;set;}
    public Id paramOppId{get;set;}
    public Id paramEngagementId{get;set;}
    public String paymentTxId {get; set;}
    public Decimal paymentAmount {get; set;}
    public String paymentDate {get; set;}
    public String paymentRecordId {get; set;}
    public String userProfileName{get; set;}
    public boolean PTRenewalPaymentMade{get;set;}
    public List<Payment__c> PTRenewalPayments{get;set;}
    
    /*public apc_pt_invoice_controller()
    {
        //default Constructor
        className = '@Class:'+String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))+': ';
        URLAux = ApexPages.currentPage().getUrl(); 
    }*/
    
    public apc_pt_invoice_controller(home_controller parentController)
    {
        this.myHome = parentController;
        //ok this is common invoicing controller. So we need to assgin the products as per the page.
        className = '@Class:'+String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))+': ';
        URLAux = ApexPages.currentPage().getUrl(); 
        System.debug('Inside apc_pt_invoice_controller(homecontroller)');
        System.debug('URLAux : ' + URLAux);
        ConfMatch = parentController.confMatch;
        ApplicantInfo = parentController.currentApp;
        
        pc = new Pricing_Controller();
        pc.match = parentController.confMatch;
        pc.applicantInfo = parentController.currentApp;
		System.debug('match  :' + pc.match);
        System.debug('applicantInfo  :' + pc.applicantInfo);
        //System.debug('match  :'  pc.match);
        
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_travel_payment')){
            getOpportunityProductCart1('End of program');
        }
        
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_main_payment')){
            //check if the payment is already made for renewal opportuntiy.
            List<payment__c> payList = [SELECT Id,Name,Amount__c,Txn_Amount__c,Txn_Id__c,Txn_Date__c FROM Payment__c 
                                        WHERE Account_Name__c = :ApplicantInfo.account__c and
                                        Opportunity_Name__r.childOppType__c= 'Renewal' and
                                        Txn_Amount__c != null and 
                                        Sucess__c = true limit 1];
            
            if(payList!=null && payList.size()>0)
            {
                PTRenewalPayments = payList;
                PTRenewalPaymentMade = true;
                System.debug('Renewal payment already made. pay list is ' + PTRenewalPayments);
            }
            else
            {
                System.debug('Renewal payment not made.');
                PTRenewalPayments = null;
                PTRenewalPaymentMade = false;
                getOpportunityProductCart1('Renewal');
            }
            
        }
        
         //System.debug('###### enter in the loop');
         User user = [Select Id, ContactId,Type__c,Intrax_Id__c, User_Interests__c, Contact.AccountId, ProfileId 
                      from User where Id =:UserInfo.getUserId()];
            //Getting the value to determine the user interests (and allow or deny creating some types of applications)
         if(user.ProfileId !=null){
                Profile profile = [Select Name from Profile where Id =: user.ProfileId limit 1];
                userProfileName = profile.Name ;    
         }

    }
    
    public void afterLoadAction()
    {
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_travel_payment'))
        {
            updateRecords1();
        }
        
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_main_payment'))
        {	
            updateRecords2();
        }
    }
    
    public void updateRecords1()
    {
        if(paramOppId!=null)
        {
            List<Opportunity> childOpp = [SELECT Id,Name,AccountId FROM Opportunity WHERE Id=:paramOppId and
                                          StageName != 'Closed Won' LIMIT 1];
            if(childOpp!=null && childOpp.size()>0)
            {
                if(paymentRecordId !=null)
                {
                    List<Payment__c> paymentList = [SELECT Id,Name,serializedProductList__c,Amount__c FROM Payment__c WHERE Id=:paymentRecordId LIMIT 1];
                    if(paymentList!=null & paymentList.size()>0)
                    {
                        paymentAmount = paymentList[0].amount__c;
                        if(paymentList[0].serializedProductList__c!=null)
                        {
                            List<Opportunity_Product_Cart> selectedOppProds = 
                                (List<Opportunity_Product_Cart>)JSON.deserialize(paymentList[0].serializedProductList__c, 
                                                                                 List<Opportunity_Product_Cart>.class);
                            if(selectedOppProds!=null && selectedOppProds.size()>0)
                            {
                                System.debug('@class: apc_pt_invoice_controller: selectedOppProds' + selectedOppProds);
                                insertOppProds(selectedOppProds);
                                
                                System.debug('@class: apc_pt_invoice_controller: update engagement insurance dates. paramEngagementId' + paramEngagementId);
                                updateEngagement();
                            }
                        }
                        
                        if(paramOppId!=null)
                        {
                            closeChildOpp(paramOppId);
                        }
                    }
                }
            }
        }
    }
    
    public void updateRecords2()
    {
        if(paramOppId!=null)
        {
            List<Opportunity> childOpp = [SELECT Id,Name,AccountId FROM Opportunity WHERE Id=:paramOppId and
                                          StageName != 'Closed Won' LIMIT 1];
            if(childOpp!=null && childOpp.size()>0)
            {
                if(paymentRecordId !=null)
                {
                    List<Payment__c> paymentList = [SELECT Id,Name,serializedProductList__c,Amount__c FROM Payment__c WHERE Id=:paymentRecordId LIMIT 1];
                    if(paymentList!=null & paymentList.size()>0)
                    {
                        paymentAmount = paymentList[0].amount__c;
                        if(paymentList[0].serializedProductList__c!=null)
                        {
                            List<Opportunity_Product_Cart> selectedOppProds = 
                                (List<Opportunity_Product_Cart>)JSON.deserialize(paymentList[0].serializedProductList__c, 
                                                                                 List<Opportunity_Product_Cart>.class);
                            if(selectedOppProds!=null && selectedOppProds.size()>0)
                            {
                                System.debug('@class: apc_pt_invoice_controller: selectedOppProds' + selectedOppProds);
                                insertOppProds(selectedOppProds);
                            }
                        }
                        
                        //Also update the page status complete on the application.
                        if(applicantinfo.PageStatus_Complete__c != null && applicantinfo.PageStatus_Complete__c != '')
                        {
                            if(!applicantinfo.PageStatus_Complete__c.contains('032'))
                            {
                                applicantinfo.PageStatus_Complete__c = applicantinfo.PageStatus_Complete__c + ';' + '032';      
                            }
                            update applicantinfo;               
                        } 
                        
                        if(paramOppId!=null)
                        {
                            closeChildOpp(paramOppId);
                        }
                    }
                }
            }
        }
    }
    
    public PageReference navigator()
    {
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_main_payment'))
        {	
            PageReference p = Page.apc_ap_main_completion;
            P.getParameters().put('Id', ApexPages.currentPage().getParameters().get('Id'));
		    P.getParameters().put('viewpage', 'true');
            p.setRedirect(true);
            return p;
        }
        else
            return null;
    }
    
    void updateEngagement()
    {
        List<Engagement__c> engList = [Select id,Flight_booking_needed__c,Insurance_Extension_Indicated__c,
                                       Insurance_Extension_Start__c, Insurance_Extension_End__c
                                       from Engagement__c where id = :paramEngagementId];
        if(engList!=null & engList.size()>0)
        {
            engList[0].Insurance_Extension_Start__c = ConfMatch.End_Date__c;
            engList[0].Insurance_Extension_End__c = ConfMatch.End_Date__c + 30;
            engList[0].Insurance_Extension_Indicated__c = 'Yes';
            engList[0].Flight_booking_needed__c = 'Yes';
            update engList[0];
        }
    }
    
    void insertOppProds(List<Opportunity_Product_Cart> selectedProdCart)
    {
        System.debug('@Class : apc_pt_invoice_controller : insertOppProds');
        list<OpportunityLineItem> listFinalOppProducts = new list<OpportunityLineItem>();
        for(Opportunity_product_cart oppProdCart : selectedProdCart)
        {
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = oppProdCart.OpportunityId; 
            oppLineItem.Description = oppProdCart.productDescription;
            oppLineItem.UnitPrice = oppProdCart.unitPrice;
            oppLineitem.PricebookEntryId = oppProdCart.priceBookEntryId;
            oppLineitem.Due_Date__c = oppProdCart.dueDate;
            oppLineitem.Quantity = oppProdCart.Quantity; 
            oppLineItem.Payment_Method__c = oppProdCart.paymentMethod;
            
            System.debug(' oppLineItem UnitPrice: ' + oppLineItem.UnitPrice + ' Due date: ' + oppLineitem.Due_Date__c + 
                         ' PricebookentryId: ' + oppLineitem.PricebookEntryId + ' oppId: ' + oppLineItem.Opportunity +
                         ' Product Code' +  oppLineItem.productCode + ' payment method ' + oppLineItem.Payment_Method__c   +
                         ' descripton' + oppLineItem.Description);
            listFinalOppProducts.Add(oppLineitem);
        }
        if(listFinalOppProducts != null && listFinalOppProducts.size() > 0)
            insert listFinalOppProducts;
    }
    
    void closeChildOpp(Id opportunityId)
    {
        System.debug('@Class : apc_pt_invoice_controller : closeChildOpp');
        List<Opportunity> childOpp = [SELECT Id,Name,AccountId FROM Opportunity WHERE Id=:opportunityId and
                                      StageName != 'Closed Won' LIMIT 1];
        if(childOpp!=null && childOpp.size()>0){
            //set the intacct payment recordid to this
            System.debug('@class:apc_pt_invoice_controller Inside closeChildOpp paymentRecordId ' + paymentRecordId);
            
            childOpp[0].StageName = 'Closed Won';
            update childOpp[0];
            System.debug('child Opportunity closed successfully');
          
        }
    }
    
    //this constructor is only called from apc_ap_travel_payment_confirmation pages
    public apc_pt_invoice_controller(String afterPaymentConfirmation){
        
         //System.debug('###### enter in the loop');
         User user = [Select Id, ContactId,Type__c,Intrax_Id__c, User_Interests__c, Contact.AccountId, ProfileId 
                      from User where Id =:UserInfo.getUserId()];
            //Getting the value to determine the user interests (and allow or deny creating some types of applications)
         if(user.ProfileId !=null){
                Profile profile = [Select Name from Profile where Id =: user.ProfileId limit 1];
                userProfileName = profile.Name ;    
         }
        
        
        URLAux = ApexPages.currentPage().getUrl(); 
        System.debug('apc_pt_invoice_controller constructor' + 'url is: ' + URLAux);
        
        if(ApexPages.currentPage().getParameters().get('Id') != null) 
        {
            paramAppId = ApexPages.currentPage().getParameters().get('Id');
            System.debug('paramAppId ' + paramAppId);
            
            if(paramAppId!=null)
        	{
                ApplicantInfoList = [Select a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
            a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Submitted__c, a.Study_Time__c, a.Street__c, a.State__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, 
            a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
            a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Accommodation_Price_Range__c, a.Arrival_Time__c, a.Health_Needs_Indicated__c,
            a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Points_of_Interest__c, 
            a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, a.Opportunity_Name__c, a.Nearest_City__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c,a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.IsDeleted, a.Intrax_Program_Options__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Government_Assistence_Indicated__c, a.GPA__c, a.GPA_Self_Reported__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, 
            a.Exchange_Agency_Employer_Name__c, a.Intrax_Program__c, a.Terms_Accepted__c, a.Program_Start_Opinion__c, a.Arriving_Date__c, a.Arriving_Time__c, a.Carrier__c, a.Carrier_Number__c, a.Intrax_Accommodations__c, a.Flexible_Dates__c,
            a.Entity_Id__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c,a.Country_of_Interest__c, a.English_Teach_Name__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c,
            a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Country_of_Birth__c,a.Visa_Type__c, a.How_Heard__c,a.How_Heard_Detail__c,a.How_Heard_Other__c, a.Engagement_End__c, a.Smoker_Student__c, a.Health_Needs_Description__c,
            a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c, a.Questions__c, a.Casper_Id__c,a.Visa_Category__c, a.Program_Start__c, a.Study_Weeks__c, a.Accommodation_Preference__c, a.Program_Selector__c,
            a.Daily_Meal_Commitment__c, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.CreatedById, 
            a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.Children_Enrolled__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Intrax_Center__c,
            a.Bedrooms__c, a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.RecordType.Name, a.IsVisaDocumentPageSubmitted__c,Intrax_Region__c,
            a.Citizenship__c, a.Attendance_Problems__c, a.Allergies_Other_Partner__c,a.Allergies_Other_desc__c,a.Attendance_Problems_Description__c, a.Application_Stage__c, a.Application_Level__c, a.Allergies_from_Partner__c,
            a.Allergies_from_Applicant__c, a.Allergies_Indicated__c, a.Airport__c, a.Account__c, a.Academic_Years_Completed__c,a.School_Name_SOR__c, a.Primary_Activity__c, a.Experience_Complete__c,
            a.Functional_Areas__c, a.Position_Types__c, a.Service_Level__c, a.Projects_of_Interest__c, a.Location_Preference_1__c, a.Location_Preference_2__c, a.Location_Preference_3__c, SYS_Allow_Cloning__c,
            Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,a.Extension_Length__c,
            a.Application_Type__c, a.Engagement__c,a.Engagement__r.Name, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c, a.Extension_Au_Pair_Agreed__c, a.Engagement__r.Interview_Availability__c, Engagement__r.OwnerId,
            a.Position__c, a.Engagement__r.Arrival_PNR_Number__c, a.Engagement__r.Arrival_Trip_URL__c, a.Engagement__r.Dep_PNR_number__c, a.Engagement__r.Departure_Trip_URL__c, a.Engagement__r.Engagement_End__c, a.Engagement__r.Flight_booking_needed__c,
			Account__r.LastName, Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,Account__r.BillingCountry,Account__r.FirstName, Engagement__r.Departure_Request_Deadline__c, Engagement__r.Profile_Update_Required__c,
			a.Intrax_Program_Category__c,a.Location_of_Interest__c,a.CreatedBy__c, a.PageStatus_Complete__c, a.PageStatus_Started__c                              
            From Applicant_Info__c a
            where a.id =:paramAppId];
            
                if(ApplicantInfoList!=null && ApplicantInfoList.size()>0)
                  ApplicantInfo =  ApplicantInfoList[0];
        	}
        }
        
        
        
        if(ApexPages.currentPage().getParameters().get('mId') != null) {
            paramMatchId = ApexPages.currentPage().getParameters().get('mId');
            System.debug('paramMatchId ' + paramMatchId);
            
             List<match__c> matchList = [Select Id, Request_Notes__c,Engagement__r.Account_Id__r.Name,Position_Name__r.Host_Company_Id__r.Name,
                             Position_Name__r.Host_Company_Id__r.BillingCity,offer_status__c,Engagement__c, City__c,Start_Date__c, 
                             End_Date__c, Position_Name__c, Engagement__r.Status__c, Engagement__r.In_Country__c, Engagement__r.Engagement_Start__c,
                             Engagement__r.Engagement_end__c,Engagement__r.Under_2_Total_Hours__c,Participant_Id__r.Legal_Residence__pc,
 							 Status__c,Airport_code__c,Engagement__r.Infant_Specialized_Indicated__c,RecordType.Name,Participant_Id__r.Name,
                             Infant_Specialized_Training__c, Position_Name__r.Host_Company_Id__c,Position_Name__r.Host_Company_Id__r.LastName,
                             Position_Name__r.Host_Company_Id__r.Gender__pc,Position_Name__r.Host_Company_Id__r.FirstName,Request_Expiration__c,
                             Position_Name__r.Host_Company_Id__r.PersonMailingStreet,Position_Name__r.Host_Company_Id__r.PersonMailingCity,
                             Position_Name__r.Host_Company_Id__r.PersonMailingState,Position_Name__r.Host_Company_Id__r.Phone,
                             Position_Name__r.Host_Company_Id__r.Skype__c,Arrival_Date__c,Match_Date__c 
                             from Match__c 
                             WHERE Id =:paramMatchId];
            if(matchList!=null && matchList.size()>0)
                ConfMatch=matchList[0];
            
        }
        
        if(ApexPages.currentPage().getParameters().get('oppId') != null) {
            paramOppId = ApexPages.currentPage().getParameters().get('oppId');
            System.debug('paramOppId ' + paramOppId);
        }
        
        if(ApexPages.currentPage().getParameters().get('engagementId') != null) {
            paramEngagementId = ApexPages.currentPage().getParameters().get('engagementId');
            System.debug('paramEngagementId ' + paramEngagementId);
        }
        if(ApexPages.currentPage().getParameters().get('paymentTxId') != null) {
            paymentTxId = ApexPages.currentPage().getParameters().get('paymentTxId');
            System.debug('paymentTxId ' + paymentTxId);
        }
        /*
        if(ApexPages.currentPage().getParameters().get('paymentAmount') != null) {
            paymentAmount = ApexPages.currentPage().getParameters().get('paymentAmount');
            System.debug('paymentAmount ' + paymentAmount);
        }
        */
        if(ApexPages.currentPage().getParameters().get('paymentDate') != null){ 
            paymentDate = ApexPages.currentPage().getParameters().get('paymentDate');
            System.debug('paymentDate ' + paymentDate);
        }
        
        if(ApexPages.currentPage().getParameters().get('paymentId') != null) {
            paymentRecordId = ApexPages.currentPage().getParameters().get('paymentId');
            System.debug('paymentRecordId ' + paymentRecordId);
         }
    }
    
    public void getOpportunityProductCart1(string childOpportunityType)
    {
        System.debug('Inside getOpportunityProductCart1');
        if(pc.applicantInfo.Opportunity_Name__c !=null)
        {
            childOpportunityList =[select id,ChildOppType__c,Name,Parent_Opportunity__c,
                                   Type
                                   from Opportunity 
                                   where Parent_Opportunity__c=:pc.applicantInfo.Opportunity_Name__c 
                                   and   ChildOppType__c=:childOpportunityType];                        
            if(childOpportunityList!=null && childOpportunityList.size()>0)
            {
                pc.opportunity = childOpportunityList[0];
                ChildOpportunity = childOpportunityList[0];
                System.debug(className + 'debug::APC child Application Fee opportunity '+childOpportunityList[0] );
            }
            
            
            personInfoList = [Select p.Work_Supervisor__c, p.Work_Phone__c, p.Title__c, p.TimeZoneSidKey__c, p.Marital_Status__c,
                              p.SystemModstamp, p.Skype_Id__c, p.Role__c, p.Role_Other__c, p.Residency_Status__c, p.Profession__c, p.Primary_Applicant__c, Source_Referral__c,
                              p.Preferred_Phone_Type__c, p.Other_Phone__c, p.Nick_Name__c, p.Nationality__c, p.Special_Needs__c, p.Name, p.Mobile__c,
                              p.Middle_Name__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Intrax_Program_Option__c,
                              p.Interests__c, p.Id, p.Gender__c, p.First_Name__c, p.Entity_Id__c, p.Employer_Name__c, p.Emergency_Contact_Indicated__c, p.Email__c, p.Education_Level__c,
                              p.ESSN__c, p.Date_of_Birth__c, p.CreatedDate, p.CreatedById, p.Country_of_Residence__c, p.ConnectionSentId, p.ConnectionReceivedId, p.Community_Service__c,
                              p.Citizenship__c, p.Birth_Country__c, p.Birth_City__c, p.Best_Call_Time__c, p.Background_Check__c, p.Background_Check_Msg__c, p.Background_Check_Id__c,
                              p.Background_Check_Consent_Received__c, p.Background_Check_By__c, p.Background_Check_At__c, p.BGC_Notes__c,p.Do_you_smoke__c, p.Are_you_allergic_to_animals__c,
                              p.Do_you_have_any_health_concerns__c, p.Applicant_Info__c, p.Family_Member__c, p.Phone__c, p.Applicant_Info__r.Intrax_Center__c,
                              p.Applicant_Info__r.Program_Duration__c, p.Applicant_Info__r.Visa_Type__c, p.Age__c, p.Applicant_Info__r.Deposit_Fee_Accepted__c, Secondary_School_Indicated__c,
                              p.Citizenship_Resident_Indicated__c, p.Offence_Indicated__c, p.Criminal_Convictions_Description__c,Source_Referral_Details__c, Contact_Instructions__c,
                              p.Referral_First_Name__c,p.Referral_Last_Name__c ,p.Referral_State__c,p.Referral_Business_Name__c, Weight_kg__c, Weight_lb__c, Phone_Country_Code_Other__c,
                              p.Other_Phone_Type__c, p.Phone_Type__c, p.Hospitalization_Indicated__c, p.Psychiatric_Treatment_Indicated__c,p.Phone_Country_Code__c, p.Height_cm__c, p.Job_Sector__c, p.English_Fluency__c,
                              p.Overall_Health__c,p.Medication_Indicated__c,p.Medication_Description__c, p.Hospitalization_Description__c,p.Psychiatric_Treatment_Description__c,p.Graduation_Date__c, p.Drug_Dependency_Description__c, 
                              p.Physical_Disabilities_Description__c, p.Contagious_Disease_Description__c,
                              p.Illnesses__c, p.Illness_Description__c, p.Chronic_Disease__c, p.Chronic_Disease_Description__c, p.Pregnancy_Indicated__c,p.Physical_Disabilities_Indicated__c,
                              p.Contagious_Disease_Indicated__c,p.Drug_Dependency_Indicated__c,p.Braces_Indicated__c,p.Braces_Removal_Date__c,p.Health_Concerns__c,p.Source_Referral_Other__c,
                              p.Medical_Health_Agreement__c, Reference_Request_Note__c,Program_Phone__c,Program_Phone_Type__c,
                              p.Physical_Exam_Date__c,p.History_Of_Illness_Indicated__c,p.History_Of_Illness_Details__c, p.Overall_Health_From_Doctor__c
                              From Person_Info__c p 
                              Where p.Applicant_Info__c =:pc.applicantInfo.Id and role__c='Participant' LIMIT 1];
            
            
            if(personInfoList!=null && personInfoList.size()>0)
            {
                personInfo = personInfoList[0];
            }
            
        }
        
        List<String> keywords = new list<string>();
        String applicableProductKeywords;
        
        if(URLAux!=null && URLAux.contains('/apex/apc_ap_main_payment'))
        {
            applicableProductKeywords='pt_renewal_dos_extension_fee';
        }
        else
            applicableProductKeywords = ApexPages.currentPage().getParameters().get('kw');
        
        List<PriceBookEntry> allPriceBookEntries = new List<PriceBookEntry>();
        
        if(applicableProductKeywords!=null && String.isNotBlank(applicableProductKeywords))
        {
            keywords = applicableProductKeywords.split(',');
            
            selectedOppProdCartList = new List<Opportunity_product_cart>();
            SelectedItemsPriceMapDueNow = new Map<date,double>();
            SelectedItemsPriceMapDueLater = new Map<date,double>();
            selectedItemsTotalPrice = 0;
            String PriceBookName = pc.getPriceBook(ApplicantInfo.Country_of_Interest__c,ApplicantInfo.Intrax_Program__c ,'All');
            for(string str : keywords)
            {   
                list<PriceBookEntry> PricebookList = pc.getAPCPBEFromKeyword
                    (PriceBookName,ChildOpportunity.Type,ChildOpportunity.ChildOppType__c, str);
                if(PricebookList!=null && PricebookList.size()>0)
                    allPriceBookEntries.addAll(PricebookList);
            }
            
            if(allPriceBookEntries!=null && allPriceBookEntries.size()>0)
            {
                //Now process all the price book entires that are retrieved and add to default list of opportunity product items
                selectedOppProdCartList = pc.processPriceBookEntries(allPriceBookEntries);
                
                //Now we need to process some implicit promos if any applicable
                for(Opportunity_Product_Cart oppLineItem :selectedOppProdCartList )
                {
                    System.debug('oppLineItem' + oppLineItem);
                    if(oppLineItem.dueDate<=System.today())
                    {
                        SelectedItemsPriceMapDueNow.put(oppLineItem.dueDate,oppLineItem.unitPrice);
                        selectedItemsTotalPrice = selectedItemsTotalPrice + oppLineItem.unitPrice;
                    }
                    else
                    {
                        SelectedItemsPriceMapDueLater.put(oppLineItem.dueDate,oppLineItem.unitPrice);
                    }
                }
            }
        }
        selectedPlan = 'Standard';
        schdPaymentsAvailable = false;
    }
    
    double getStandardItemsTotalPrice()
    {
        double TotalPrice= 0.0;
        for(Date key : StandardItemsPriceMap.keySet())
        {
            TotalPrice = TotalPrice + StandardItemsPriceMap.get(key);
        }
        return TotalPrice;
    }
    
    double getPaymentPlanItemsTotalPrice()
    {
        double TotalPrice= 0.0;
        for(Date key : PaymentPlanItemsPriceMap.keySet())
        {
            TotalPrice = TotalPrice + PaymentPlanItemsPriceMap.get(key);
        }
        for(Date key : InstallmentItemsPriceMap.keySet())
        {
            TotalPrice = TotalPrice + InstallmentItemsPriceMap.get(key);
        }
        return TotalPrice;
    }
    
    double getInstallmentItemsTotalPrice()
    {
        double TotalPrice = 0.0;
        for(Date key : InstallmentItemsPriceMap.keySet())
        {
            TotalPrice = TotalPrice + InstallmentItemsPriceMap.get(key);
        }
        return TotalPrice;
    }
    
    public void CreateIntacctAccount()
    {
        //checkLogin();
        System.debug('ApplicantInfo : ' + ApplicantInfo);
        if(ApplicantInfo.account__c !=null && ApplicantInfo.Intrax_Program__c == 'AuPairCare' 
           && ApplicantInfo.Type__c == 'Participant')
        {
            Intacct_Wrapper wrapper= new Intacct_wrapper();
            List<Intacct__c> parentIntacct = [Select id from Intacct__c 
                                              where Account__c =:applicantInfo.account__c and
                                              Is_Parent__c = true and
                                              Type__c = 'Create Customer' and
                                              Intacct_Response__c = 'Success'
                                              limit 1];
            //intacct account no present so create it and sync
            if(parentIntacct.isEmpty())
            {
                System.debug('Parent Intacct is not present. Create one and sync');
                wrapper.CreateIntacctAccnt_Sync(applicantInfo.account__c);//,'Non-Future');   
            }
        }
    }
    
    /*public PageReference navigator(){
        
        // ** APC- Preventing the user navigate in the application when the real Application_Stage__c = 'Submitted'. Problem with the cache when the user clicks back automaticatlly.
        //If is an APC App and is Submitted go directly to your_application      
        
        System.debug(className + '***** Inside Navigator');
        // System.debug(className + '###### docType2: ' + docType );
        Applicant_Info__c applicantInfo = new Applicant_Info__c();
        
        Id aIdStage = ApexPages.currentPage().getParameters().get('Id');
        
        System.debug(className + 'urlaux' + URLAux);
        if(URLAux!=null && URLAux.contains('/apex/apc_hf_match_payment_addons'))
        {         
            if(confMatch!=null)
            {
                System.debug(className + 'Navigator: ' + 'url: ' + URLAux);
                update confMatch;
                PageReference p = Page.apc_hf_match_payment_options;
                p.setRedirect(true);
                return p;
            } 
        }
        else if(URLAux!=null && URLAux.contains('/apex/apc_hf_match_payment_options'))
        {  
            System.debug(className + 'Navigator: ' + 'url: ' + URLAux);
            String plan = ApexPages.currentPage().getParameters().get('SelectedPayment');
            if(plan!=null && !String.isEmpty(plan))
            {
                selectedPlan=plan;
                System.debug(className + 'selected plan is ' + selectedPlan);
                //Populate the selected cart list as per the selected plan
                //populateSelectedCartList();
            }
            PageReference p = Page.apc_hf_match_payment_checkout;
            p.setRedirect(false);
            return p;
        }
        
        return null;
    }
    
  	public PageReference populateSelectedItems()
  	{
        System.debug(className + '***** Inside populateSelectedItems');
        String plan = ApexPages.currentPage().getParameters().get('SelectedPayment');
        if(plan!=null && !String.isEmpty(plan))
        {
            selectedPlan=plan;
            System.debug(className + 'selected plan is ' + selectedPlan);
            //Populate the selected cart list as per the selected plan
            populateSelectedCartList();
            PageReference p = Page.apc_hf_match_payment_checkout;
            p.setRedirect(false);
            return p;
        }
        else return null;
        
    }
    
    public void populateSelectedCartList()
    {
        selectedOppProdCartList = new List<Opportunity_product_cart>();
        SelectedItemsPriceMapDueNow = new Map<date,double>();
        SelectedItemsPriceMapDueLater = new Map<date,double>();
        
        if(selectedPlan == 'Standard')
        {
            for(Opportunity_product_cart opp : oppProdCartList)
            {
                if(opp.paymentMethod=='All' || opp.paymentMethod=='Standard')
                    selectedOppProdCartList.Add(opp);
            }
            selectedItemsTotalPrice = StandardItemsTotalPrice;
            for(Date key : StandardItemsPriceMap.keySet())
            {
                if(key<=System.today())
                    SelectedItemsPriceMapDueNow.put(key,StandardItemsPriceMap.get(key));
                else
                    SelectedItemsPriceMapDueLater.put(key,StandardItemsPriceMap.get(key));
            }
        }
        
        if(selectedPlan == 'PaymentPlan')
        {
            for(Opportunity_product_cart opp : oppProdCartList)
            {
                if(opp.paymentMethod=='All' || opp.paymentMethod=='Installment')
                    selectedOppProdCartList.Add(opp);
            }
            selectedItemsTotalPrice = paymentplanItemsTotalPrice;
            for(Date key : PaymentPlanItemsPriceMap.keySet())
            {
                if(key<=System.today())
                    SelectedItemsPriceMapDueNow.put(key,PaymentPlanItemsPriceMap.get(key));
                else
                    SelectedItemsPriceMapDueLater.put(key,PaymentPlanItemsPriceMap.get(key));
            }
            for(Date key : InstallmentItemsPriceMap.keySet())
            {
                SelectedItemsPriceMapDueLater.put(key,InstallmentItemsPriceMap.get(key));
            }
        }
        
        if(SelectedItemsPriceMapDueLater!=null && SelectedItemsPriceMapDueLater.size()>0)
            schdPaymentsAvailable=true;
        else
            schdPaymentsAvailable=false;
        
    }*/
}