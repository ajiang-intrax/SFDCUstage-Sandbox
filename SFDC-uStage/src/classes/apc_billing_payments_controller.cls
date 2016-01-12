public with sharing class apc_billing_payments_controller
{
    public MyProfilePageController parentController{get;set;}
    
    //Payment related Variables
    public PaymentWrapper payWrapper {get; set;}
    public PaymentSubscriptionWrapper PaySubsWrapper {get; set;}
    public List<Payment_Subscription__c> subscriptionsRecord {get; set;}
    public Payment_Subscription__c paymentSubscription {get; set;}
    public string TypeCreditCardSelected{get;set;}
    public string monthSelected{get;set;}
    public string yearSelected{get;set;}
    public String ipAddress {get; set;}
    public Boolean isPaymentSuccessful{get; set;}
    public Boolean useCurrentBillingAddressInfo {get; set;}
    public String paymentError{get; set;}
    public List<Account> accountInfo{get;set;}
    public Account acctObj{get;set;}
    public List<Person_info__c> personInfoList {get;set;}
    public Payment__c payment {get; set;}
    public List<Applicant_Info__c> ApplicantInfoList{get;set;}
    public list<Match__c> ConfMatchList{get;set;}
    public List<Sales_Invoice__c> serviceCreditSIs{get;set;}
    
    public Person_Info__c personInfo{get;set;}
    public Applicant_Info__c ApplicantInfo{get;set;}
    public Match__c ConfMatch{get;set;}
    
    public String URLAux{get;set;}
    
    public boolean hasServiceCredit{get;set;}
    public double totalServiceCredit{get;set;}
    
    public boolean hasScheduledPayments{get;set;}
    public List<Sales_invoice__c> scheduledPayments{get;set;}
    
    public boolean hasPastPayments{get;set;}
    public List<Sales_invoice__c> pastPayments{get;set;}
    public List<Sales_invoice__c> pastPaymentsWithoutMatchBreakSC{get;set;}
    
     public List<SelectOption> getTypeCard(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Visa','Visa'));
        options.add(new SelectOption('MasterCard','MasterCard'));
        options.add(new SelectOption('AmericanExpress','American Express')); 
        options.add(new SelectOption('Discover','Discover')); 
        
        return options;
    }
    
    public List<SelectOption> getMonth(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('01','January'));
        options.add(new SelectOption('02','February'));
        options.add(new SelectOption('03','March'));
        options.add(new SelectOption('04','April'));
        options.add(new SelectOption('05','May'));
        options.add(new SelectOption('06','June'));
        options.add(new SelectOption('07','July'));
        options.add(new SelectOption('08','August'));
        options.add(new SelectOption('09','September'));
        options.add(new SelectOption('10','October'));
        options.add(new SelectOption('11','November'));
        options.add(new SelectOption('12','December'));
        
        return options;
    }
    
    public List<SelectOption> getYear(){
        List<SelectOption> options = new List<SelectOption>();
        Date currentdate = date.today();
        integer year = currentdate.year();
        
        options.add(new SelectOption(string.valueof(year),string.valueof(year)));
        options.add(new SelectOption(string.valueof(year + 1),string.valueof(year + 1)));
        options.add(new SelectOption(string.valueof(year + 2),string.valueof(year + 2)));
        options.add(new SelectOption(string.valueof(year + 3),string.valueof(year + 3)));
        options.add(new SelectOption(string.valueof(year + 4),string.valueof(year + 4)));
        options.add(new SelectOption(string.valueof(year + 5),string.valueof(year + 5)));
        options.add(new SelectOption(string.valueof(year + 6),string.valueof(year + 6)));
        options.add(new SelectOption(string.valueof(year + 7),string.valueof(year + 7)));
        options.add(new SelectOption(string.valueof(year + 8),string.valueof(year + 8)));
        options.add(new SelectOption(string.valueof(year + 9),string.valueof(year + 9)));
        options.add(new SelectOption(string.valueof(year + 10),string.valueof(year + 10)));
        
        return options;
    }
    
    public apc_billing_payments_controller(MyProfilePageController profilePageController)
    {
        this.parentController = profilePageController;
        System.debug('apc_billing_payments constructor');
        ApplicantInfoList = [Select a.PageStatus_Complete__c,a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
                             a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Submitted__c, a.Study_Time__c, a.Street__c, a.State__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, 
                             a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
                             a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Accommodation_Price_Range__c, a.Arrival_Time__c, a.Health_Needs_Indicated__c,
                             a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Points_of_Interest__c, 
                             a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c, a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, a.Opportunity_Name__c, a.Nearest_City__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c, a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c,a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.IsDeleted, a.Intrax_Program_Options__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c, a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c, a.Government_Assistence_Indicated__c, a.GPA__c, a.GPA_Self_Reported__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, 
                             a.Exchange_Agency_Employer_Name__c, a.Intrax_Program__c, a.Terms_Accepted__c, a.Program_Start_Opinion__c, a.Arriving_Date__c, a.Arriving_Time__c, a.Carrier__c, a.Carrier_Number__c, a.Intrax_Accommodations__c, a.Flexible_Dates__c,
                             a.Entity_Id__c, a.English_Test_Type__c, a.English_Test_Score__c, a.English_Teacher_Title__c, a.English_Teach_Name__c, a.English_Study_Years__c, a.English_Level__c, a.English_Ability__c,
                             a.ETR_Received_Date__c, a.ESSN__c, a.Double_Placement_Indicated__c, a.Country_of_Birth__c,a.Visa_Type__c, a.How_Heard__c,a.How_Heard_Detail__c,a.How_Heard_Other__c, a.Engagement_End__c, a.Smoker_Student__c, a.Health_Needs_Description__c,
                             a.Distance_to_School__c, a.Disabilities__c, a.Disabilities_Description__c, a.Questions__c, a.Visa_Category__c, a.Program_Start__c, a.Study_Weeks__c, a.Accommodation_Preference__c, a.Program_Selector__c,
                             a.Daily_Meal_Commitment__c, a.Curfew_Weekends__c, a.Curfew_Weekdays__c, a.Curfew_Indicated__c, a.Criminal_Investigation_Indicated__c, a.Criminal_Investigation_Description__c, a.Criminal_Convictions_Indicated__c, a.Criminal_Convictions_Description__c, a.CreatedDate, a.CreatedById, 
                             a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Website__c, a.Community_Type__c, a.Community_Population__c, a.Community_Description__c, a.Classroom_Cooperation__c, a.Children_Enrolled__c, a.Business_in_Home__c, a.Business_in_Home_Description__c, a.Intrax_Center__c,
                             a.Bedrooms__c, a.Bedroom_Type__c, a.Bedroom_Shared_With__c, a.Bedroom_Shared_Indicated__c, a.Bathrooms__c, a.Bathroom_Type__c, a.RecordType.Name, a.IsVisaDocumentPageSubmitted__c,Intrax_Region__c,
                             a.Citizenship__c, a.Attendance_Problems__c, a.Allergies_Other_Partner__c,a.Allergies_Other_desc__c,a.Attendance_Problems_Description__c, a.Application_Stage__c, a.Application_Level__c, a.Allergies_from_Partner__c,
                             a.Allergies_from_Applicant__c, a.Allergies_Indicated__c, a.Airport__c, a.Account__c, a.Academic_Years_Completed__c,a.School_Name_SOR__c, a.Primary_Activity__c, a.Experience_Complete__c,
                             a.Functional_Areas__c, a.Position_Types__c, a.Service_Level__c, a.Projects_of_Interest__c, a.Location_Preference_1__c, a.Location_Preference_2__c, a.Location_Preference_3__c, SYS_Allow_Cloning__c,
                             Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,a.Extension_Length__c,
                             a.Application_Type__c, a.Engagement__c, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c, a.Extension_Au_Pair_Agreed__c, a.Engagement__r.Interview_Availability__c,
                             a.Position__c,Account__r.Age__pc, Account__r.Name, a.casper_Id__c, PromoCode__c ,Account__r.discretionary_discount__c,Account__r.rematch_type__c,
                             Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,Account__r.BillingCountry,Account__r.FirstName
                             From Applicant_Info__c a where a.CreatedBy__c =: UserInfo.getUserId() 
                             AND Intrax_Program__c = 'AuPairCare' 
                             order by a.CreatedDate DESC];
        System.debug('debug::ApplicantInfoList'+ApplicantInfoList);
        System.debug('debug::UserInfo.getUserId()'+UserInfo.getUserId());
        
        if(ApplicantInfoList != null && ApplicantInfoList.size()>0)
        {
            ApplicantInfo= ApplicantInfoList[0];
            if(ApplicantInfoList[0].Position__c!=null)
            {
                ConfMatchList= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                                Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
                                Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,Actual_End_Date__c,Host_Family_Child_Opportuniy__c,
                                RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, Match_Period__c,
                                Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
                                Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                                Infant_Specialized_Training__c,Match_Type__c
                                from match__c 
                                where  Position_Name__c =: ApplicantInfoList[0].Position__c 
                                AND    ( Status__c =: 'Requested' or status__c = :'Confirmed')
                                AND    Offer_Status__c = :'Accepted'
                                AND    RecordType.Name =:'AuPairCare' 
                                ORDER BY CreatedDate DESC];
                System.debug('debug::ConfMatchlist '+ConfMatchList);
                
                if(ConfMatchList !=null && ConfMatchList.size()>0 )
                {
                    ConfMatch=ConfMatchList[0];
                    System.debug('debug::ConfMatch '+ConfMatch);
                }
            }
            
            if(ApplicantInfo!=null && ApplicantInfo.Account__c!=null)
            {
                //first see if there is any service credit available.
                {
                    System.debug('before finding SC. Application is ' + ApplicantInfo);
                    totalServiceCredit = 0;
                    ServiceCreditSIs = [Select id,Account__c,Amount_Due__c,Total__c,Document_Type__c,Document_Number__c,
                                        Opportunity__c,Payment_Status__c,Name,Opportunity__r.childOppType__c
                                        from 	Sales_Invoice__c
                                        where	Account__c = :ApplicantInfo.Account__c 
                                        //and	Opportunity__c = :matchOppId
                                        and Opportunity__r.childOppType__c = 'Match Break'
                                        and	(Payment_Status__c = 'Open' or payment_Status__c = 'Partially Paid' or payment_status__c = '') 
                                        and	Document_type__c = 'Sales Invoice'
                                        and Total__c <= 0];
                    
                    if(ServiceCreditSIs!=null && ServiceCreditSIs.size()>0)
                    {
                      for(sales_Invoice__c si : ServiceCreditSIs)
                        totalServiceCredit = totalServiceCredit + si.Amount_Due__c;
                    	totalServiceCredit = totalServiceCredit*-1;  
                        hasServiceCredit = true;
                        System.debug('after finding SC. ServiceCreditSIs is ' + ServiceCreditSIs + 'totalServiceCredit  is' + totalServiceCredit);  
                    }
                    else
                    {
                        totalServiceCredit = 0;
                        hasServiceCredit = false;
                        System.debug('after finding SC. NO SC present ');  
                    }
                    
                }
                
                //Next check if there are any past payments
                {
                    System.debug('before finding past payments. Application is ' + ApplicantInfo);
                    
                    pastPayments = [Select id,Amount_Due__c,Amount_Paid__c,Total__c,Payment_Status__c,
                                    Document_Type__c,Document_Number__c,Date__c,Ship_Date__c,Invoice_Amount__c,
                                    Account__c,opportunity__c,Name,Opportunity__r.childOppType__c,
                                    Intacct_Entity__r.name,Parent_Entity__r.name,(Select id,name,Payment_Method__c,Payment_Type__c,
                                                                                 Payment_Date__c,Document_Number__c,Posting_Date__c from 
                                                                                 Sales_Invoice_Payment_Details__r order by Posting_Date__c desc limit 1)
                                    from 	Sales_Invoice__c
                                    where	Account__c = :ApplicantInfo.Account__c 
                                    and	(Payment_Status__c = 'Paid') 
                                    and	(Document_type__c = 'Sales Invoice' or document_type__c = 'Sales Invoice Manual')
                                    and Total__c > 0
                                    order by date__c desc, ship_date__c desc, Document_Number__c desc];
                    
                    if(pastPayments!=null && pastPayments.size()>0)
                    {
                        //in the past payments filter out the invoices which are cancelled by service credit.
                        pastPaymentsWithoutMatchBreakSC = new List<Sales_Invoice__c>();
                        
						for(Sales_Invoice__c si: pastPayments)
                        {
                            List<Sales_Invoice_Payment__c> paymentList = si.Sales_Invoice_Payment_Details__r;
                            if(paymentList!=null  && paymentList.size()==1)
                            {
                                if(paymentList[0].Payment_Type__c == 'Credit')
                                    continue;
                                else
                                    pastPaymentsWithoutMatchBreakSC.add(si);
                            }
                            else
                                pastPaymentsWithoutMatchBreakSC.add(si);
                        }
						if(pastPaymentsWithoutMatchBreakSC.size()>0)
                        {
                            hasPastPayments = true;
                            System.debug('after finding past payments without match break SC. pastPayments are ' + pastPaymentsWithoutMatchBreakSC); 
                        }
                        
                        System.debug('after finding past payments. pastPayments are ' + pastPayments); 
                    }
                    else
                    {
                        hasPastPayments = false;
                        pastPayments = null;
                        System.debug('no past payments present'); 
                    }
                    
                    
                }
                
                //Next check if there are any scheduled payments
                {
                    System.debug('before finding scheduled Payments. Application is ' + ApplicantInfo);
                    
                    scheduledPayments = [Select id,Amount_Due__c,Amount_Paid__c,Total__c,Payment_Status__c,
                                         Document_Type__c,Document_Number__c,Date__c,Ship_Date__c,Invoice_Amount__c,
                                         Account__c,opportunity__c,Name,Opportunity__r.childOppType__c,
                                         Intacct_Entity__r.name,Parent_Entity__r.name,(Select id,name,Payment_Method__c,Payment_Type__c,
                                                                                       Payment_Date__c,Document_Number__c,Posting_Date__c from 
                                                                                       Sales_Invoice_Payment_Details__r)
                                         from 	Sales_Invoice__c
                                         where	Account__c = :ApplicantInfo.Account__c 
                                         and	(Payment_Status__c = 'Open' or payment_Status__c = 'Partially Paid'or payment_status__c = '')
                                         and	(Document_type__c = 'Sales Invoice' or document_type__c = 'Sales Invoice Manual')
                                         and Total__c >= 0
                                         order by ship_date__c asc, Document_Number__c asc];
                    
                    if(scheduledPayments!=null && scheduledPayments.size()>0)
                    {
                        hasScheduledPayments = true;
                        System.debug('after finding scheduled Payments. scheduledPayments are ' + scheduledPayments); 
                    }
                    else
                    {
                        hasScheduledPayments = false;
                        scheduledPayments = null;
                        System.debug('no scheduled Payments present'); 
                    }
                    
                }
            }
            else
            {
                System.debug('Application present but account is null. Making everything null');
                
                totalServiceCredit = 0;
                hasServiceCredit = false;
                
                scheduledPayments = null;
                hasScheduledPayments = false;
                
                pastPayments = null;
                hasPastPayments = false;
                System.debug('hasServiceCredit' + hasServiceCredit + ' hasScheduledPayments' + hasScheduledPayments + 
                             ' hasPastPayments' + hasPastPayments);
            }
            
            
        }
        
    }
    
    public apc_billing_payments_controller(String PageName){
        PaySubsWrapper = new PaymentSubscriptionWrapper();
        payWrapper = new PaymentWrapper();
        paymentSubscription = new Payment_Subscription__c();
        isPaymentSuccessful = true;
        
        personInfoList = new List<Person_Info__c>();
        ApplicantInfoList = [Select Account__r.LastName, Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,
                             Account__r.BillingCountry,Account__r.FirstName,Account__r.PersonEmail,Casper_Id__c,Account__r.id
                             From Applicant_Info__c a
                             where a.CreatedBy__c =: UserInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by a.CreatedDate DESC];
        System.debug('debug::ApplicantInfoList'+ApplicantInfoList);
        System.debug('debug::UserInfo.getUserId()'+UserInfo.getUserId());
        if(ApplicantInfoList != null && ApplicantInfoList.size()>0){
            ApplicantInfo= ApplicantInfoList[0];
        }
        
        personInfoList = [Select First_Name__c,Last_Name__c,Email__c From Person_Info__c p  Where p.Applicant_Info__c =:applicantInfo.Id and role__c='Host' LIMIT 1];
        if(personInfoList!=null && personInfoList.size()>0 && ApplicantInfoList.size()>0){
            personInfo = personInfoList[0];
        }
    }
    
    
    public apc_billing_payments_controller(){
    }
    
    public void blankOutAddressDetailsOnPaymentPage() {
        
        if(useCurrentBillingAddressInfo != null && useCurrentBillingAddressInfo) {
            
            //Populating Address fields on payment record
            //payment.Billing_FirstName__c = personInfo.First_Name__c;
            //payment.Billing_LastName__c = personInfo.Last_Name__c;
            PaySubsWrapper.BillingEmail = applicantInfo.Account__r.PersonEmail;
         
            List<String> addresses = applicantInfo.Account__r.BillingStreet.Split('\r\n',2);
            
             if(addresses!=null && addresses.size()>0)
            {
                System.debug('addresses is ' + addresses);
                if(addresses.size()==1)
                {
                    PaySubsWrapper.BillingStreet = addresses[0];
                }
                else if(addresses.size()==2)
                {
                    PaySubsWrapper.BillingStreet = addresses[0];
                	PaySubsWrapper.BillingStreet2 = addresses[1];
                }
            }
            
            PaySubsWrapper.BillingCity= applicantInfo.Account__r.BillingCity;
            PaySubsWrapper.BillingState = applicantInfo.Account__r.BillingState;
            PaySubsWrapper.BillingCountry = applicantInfo.Account__r.BillingCountry;
            PaySubsWrapper.BillingPostalCode = applicantInfo.Account__r.BillingPostalCode;
            
        } 
        
        else {
            PaySubsWrapper.BillingEmail = '';
            PaySubsWrapper.BillingStreet = '';
            PaySubsWrapper.BillingStreet2= '';
            PaySubsWrapper.BillingCity = '';
            PaySubsWrapper.BillingState  = '';
            PaySubsWrapper.BillingCountry = '';
            PaySubsWrapper.BillingPostalCode= '';
        }
    }
    
    public PageReference UpdateCCDetails(){
        system.debug('debug::monthSelected'+monthSelected);
        system.debug('debug::yearSelected'+yearSelected);
        system.debug('debug::TypeCreditCardSelected'+TypeCreditCardSelected);
       
        if(!String.isBlank(monthSelected))
            payWrapper.cardExpirationMonth = monthSelected;
        if(!String.isBlank(yearSelected))
            payWrapper.cardExpirationYear = yearSelected;
        if(!String.isBlank(TypeCreditCardSelected))
            payWrapper.cardType = TypeCreditCardSelected;
        
        if(ApplicantInfo!=null && ApplicantInfo.Account__c!=null)
        accountInfo = [select Id,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry,FirstName,LastName,PersonEmail from Account where Id  = :ApplicantInfo.Account__c];

        if(accountInfo!=null && accountInfo.size()>0){
            acctObj = accountInfo[0];
        }
        // Creation of New Subscription
        Payment_Subscription__c PS= new Payment_Subscription__c();
        PS=createSubcriptionToken(applicantInfo,payWrapper,acctObj);
        if(!String.isBlank(PS.Encrypted_Token__c)){
             PageReference p = Page.apc_PaymentSubscription_delete;
             P.getParameters().put('TxnId', PS.Txn_Id__c);
             P.getParameters().put('AcctID', PS.Account__c);
             p.setRedirect(true);
             return p;
        }
        system.debug('debug::Return Null');
        return null;
    }
    
    Public payment_Subscription__c createSubcriptionToken(Applicant_Info__c applicantInfo,PaymentWrapper payWrapper,Account acctObj){
	    Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();   
        //Proceed further only and only if map of header parameter have not null value with it
        if(mapHeaders != null) {
            ipAddress = mapHeaders.get(PaymentConstants.TRUE_CLIENT_IP);
            if(ipAddress == null){
                ipAddress = mapHeaders.get(PaymentConstants.X_SALESFORCE_SIP);
            }
        }
		System.debug('**** Inside createSubcriptionToken Method *******');
        paymentSubscription = new Payment_Subscription__c();
        paymentSubscription.Txn_Reference_Id__c = GuidGenerator.generateGUID();
        paymentSubscription.IP_Address__c = ipAddress;
        paymentSubscription.Txn_Type__c='update';
        paymentSubscription.Account__c=ApplicantInfo.Account__r.id;
        paymentSubscription.Txn_Amount__c=0.0;//payWrapper.amount;
        paymentSubscription.CC_Type__c=TypeCreditCardSelected;
                
        paymentScheduledWebServiceInterface.createSubscriptionResponse CreateSubcriptionResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        
        System.debug('makeAWSPayment paymentSubscription record is '+ paymentSubscription);
        System.debug('makeAWSPayment applicantInfo record is '+ applicantInfo);
        System.debug('makeAWSPayment PaySubsWrapper record is '+ PaySubsWrapper);
        System.debug('makeAWSPayment payWrapper record is '+ payWrapper);
        System.debug('makeAWSPayment acctObj record is '+ acctObj);
        CreateSubcriptionResponse = PaymentService.CreateSubcription(paymentSubscription, applicantInfo, PaySubsWrapper, payWrapper,acctObj);
       try{
        paymentSubscription = PaymentHelper.parseEncryptedWebServiceResponseToken(paymentSubscription, CreateSubcriptionResponse);
        system.debug('debug::paymentSubscription---'+paymentSubscription);
           
           if(!String.isBlank(paymentSubscription.Txn_Id__c)){
                system.debug('*****###paymentSubscription test: ' + paymentSubscription);
                paymentSubscription.Is_Active__c  = True;
                paymentSubscription.Txn_Amount__c  = 0.0;
               
                insert paymentSubscription;
                
                if(accountInfo!=null && accountInfo.size()>0)
                {
                    System.debug('before accountBillingStreet' + accountInfo[0].BillingStreet);
                    System.debug('before paymentBillingStreet' + PaySubsWrapper.BillingStreet + ' street2 ' + PaySubsWrapper.BillingStreet2);
                    String accountBillingStreet = accountInfo[0].BillingStreet.replace('\r\n','');
                    String paymentBillingStreet = PaySubsWrapper.BillingStreet + PaySubsWrapper.BillingStreet2;
                    System.debug('after accountBillingStreet' + accountBillingStreet);
                    System.debug('after paymentBillingStreet' + paymentBillingStreet);
                    
                    if (accountBillingStreet != paymentBillingStreet ||
                        accountInfo[0].BillingCity != PaySubsWrapper.BillingCity ||
                        accountInfo[0].BillingState != PaySubsWrapper.BillingState ||
                        accountInfo[0].BillingPostalCode != PaySubsWrapper.BillingPostalCode ||
                        accountInfo[0].BillingCountry != PaySubsWrapper.BillingCountry)
                    {
                        accountInfo[0].BillingStreet= PaySubsWrapper.BillingStreet+ '\r\n' + PaySubsWrapper.BillingStreet2;
                        accountInfo[0].BillingCity = PaySubsWrapper.BillingCity;
                        accountInfo[0].BillingState = PaySubsWrapper.BillingState;
                        accountInfo[0].BillingPostalCode = PaySubsWrapper.BillingPostalCode;
                        accountInfo[0].BillingCountry = PaySubsWrapper.BillingCountry;
                        system.debug('@@ check point1. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                        update accountInfo[0];
                        system.debug('@@ check point2. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                    }
                }
               return paymentSubscription;
            }
           else{
               insert paymentSubscription;
               isPaymentSuccessful = false;
               paymentError = paymentSubscription.Error_Description__c.replace('_',' ');
               return paymentSubscription;
           }
           
       }
        catch(Exception ex) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
           system.debug('***Unable to update CC details');
           return null;
       }
    }
    
    //@Future
    Public PageReference deleteSubscriptionToken(){
        String TxnId= ApexPages.currentPage().getParameters().get('TxnId');
        String AcctId =ApexPages.currentPage().getParameters().get('AcctId');
        system.debug('TxnId=='+TxnId+'AcctId=='+AcctId);
        list<Payment_Subscription__c> subscriptionsRecord = new list<Payment_Subscription__c>();
        //Check subscription Token Availibity
        subscriptionsRecord=[select Id,Account__c,Encrypted_Token__c,Txn_Amount__c,Txn_Code__c,Txn_Date__c,Txn_Gateway__c,Txn_Id__c,Txn_Reference_Id__c,
                             Txn_Result__c,Txn_Result_Msg__c,Txn_Type__c,Txn_User__c,Is_Active__c,Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,
                             Account__r.BillingCountry,Account__r.FirstName,Account__r.lastName
                             from Payment_Subscription__c where Account__c=:AcctId and 
                             Txn_Id__c !=:TxnId and Txn_Type__c !='Delete' and Is_Active__c =True];
        system.debug('debug::Old_Subscriptions=='+subscriptionsRecord);
        PaySubsWrapper = new PaymentSubscriptionWrapper();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentSubscriptiondeleteResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        
        If(subscriptionsRecord.size()>0){
            try{
                paymentSubscriptiondeleteResponse = PaymentService.DeleteSubscription(subscriptionsRecord);
                PaySubsWrapper=PaymentHelper.parseEncryptedWebServiceResponseDelete(PaySubsWrapper, paymentSubscriptiondeleteResponse);
                
                List<Payment_Subscription__c> deletePSL= new List<Payment_Subscription__c>();
                If(PaySubsWrapper.Sucess==True){
                    for(Payment_Subscription__c PS : subscriptionsRecord){
                        PS.Is_Active__c=false;
                        PS.Txn_Type__c='delete';
                        PS.Encrypted_Token__c='';
                        deletePSL.add(PS);
                    }
                    update deletePSL;
                }
                
                PageReference p = Page.apc_billing_payments;
                p.setRedirect(true);
                return p;
                
            }catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
                system.debug('***Unable to delete subscription record');
            }
        }
        else{
            PageReference p = Page.apc_billing_payments;
            p.setRedirect(true);
            return p;
        }
        return null; 
    }
    public void getCCDetails(){
        //Check subscription Token Availibity
        subscriptionsRecord=[select Id,Account__c,Encrypted_Token__c,Txn_Amount__c,Txn_Code__c,Txn_Date__c,Txn_Gateway__c,Txn_Id__c,Txn_Reference_Id__c,
                             Txn_Result__c,Txn_Result_Msg__c,Txn_Type__c,Txn_User__c,Is_Active__c,Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,
                             Account__r.BillingCountry,Account__r.FirstName,Account__r.lastName
                             from Payment_Subscription__c where Account__c=:applicantInfo.Account__c and Is_Active__c = True Order by CreatedDate desc limit 1];
        PaySubsWrapper = new PaymentSubscriptionWrapper();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentSubscriptionRetrieveResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        
        If(subscriptionsRecord.size()>0 && subscriptionsRecord[0].Is_Active__c==True){
            try{
                paymentSubscriptionRetrieveResponse = PaymentService.CreateSubcriptionRetrieve(subscriptionsRecord);
                PaySubsWrapper=PaymentHelper.parseEncryptedWebServiceResponseRetrieve(PaySubsWrapper, paymentSubscriptionRetrieveResponse);
                system.debug('debug::PaySubsWrapper.subscription id '+PaySubsWrapper.ccNumber);
                system.debug('debug::PaySubsWrapper.ccNumber'+PaySubsWrapper.maskedCCNumber);
                //maskedCCNumber='************' + PaySubsWrapper.ccNumber.subString(PaySubsWrapper.ccNumber.length()-4, PaySubsWrapper.ccNumber.length());
                system.debug('debug::subscriptionsRecord=='+subscriptionsRecord);
            }catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
                system.debug('***Unable to Retrieve CC Detail');
            }
        }
    }
    
   /* ******* End of CC Payment Section ********** */
    
    public PageReference ViewSalesInvoice()
    {
        System.debug('Inside viewSalesInvoice');
        PageReference returnPg;
        if(ApexPages.currentPage().getParameters().get('documenttype')!=null && ApplicantInfo.account__c!=null)
        {
            HttpRequest req = new HttpRequest();
            Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAccountSyncUrl');
            System.debug('****appconstant: ' + appconstant);
            
            String endPointAccountSync = appconstant.Value__c + 'getSessionId?accountId='+ ApplicantInfo.account__c;
            //String endPointAccountSync = 'https://srvvpc-app-dev.intraxinc.com:8443/IntraxMiddleTier-1.0.1-SNAPSHOT/imtrest/' + 
              //  'getSessionId?accountId='+ ApplicantInfo.account__c;
            
            system.debug('******Encoded url **********' + endPointAccountSync);
            req.setEndpoint(endPointAccountSync);
            req.setMethod('GET');
            String authorizationHeader = 'Basic ';
            req.setHeader('Authorization', authorizationHeader);
            Http http = new Http();
            system.debug('request ' + req);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            Map<String,String> resultArray= (Map<String,String>)JSON.deserialize(res.getBody(),Map<String,String>.class);
            
            if(resultArray !=null && resultArray.size()>0)
            {
                String documentNumber = ApexPages.currentPage().getParameters().get('documentNumber');
                System.debug('documentNumber is ' + documentNumber);
                
                //String documenttype = 'Sales+Invoice';//ApexPages.currentPage().getParameters().get('documentType');
                String documenttype = ApexPages.currentPage().getParameters().get('documentType');
                System.debug('documenttype is ' + documenttype);
                
                String sforcekey=resultArray.get('encodedSid');
                System.debug('after encoding sforcekey' + sforcekey);
                
                String endpoint = resultArray.get('encodedurl');
                System.debug('after encoding endpoint' + endpoint);
                
                String mega='shared';
                String userentity= ApexPages.currentPage().getParameters().get('parentEntity');
                String objectentity=ApexPages.currentPage().getParameters().get('intacctEntity');
                String accountentity=ApexPages.currentPage().getParameters().get('parentEntity');
                String url = 'https://www.intacct.com/ia/acct/sforcerouter.phtml?.action=PRINT_SODOCUMENT&' +
                    '.documentid=' + documentNumber + '&' +
                    '.documenttype=' + documenttype + '&' +
                    '.sforcekey=' + sforcekey + '&' +
                    '.endpoint=' + endpoint + '&' +
                    '.mega=' + mega + '&' +
                    '.userentity=' + userentity + '&' +
                    '.objectentity=' + objectentity + '&' +
                    '.accountentity=' + accountentity;
                
                System.debug('URl is ' + url);
                
                returnPg = new PageReference(url);
            }
            else
            {
                returnPg = null;
                system.debug('some exception occured. not able to retrieve the salesforce session id from the java service');
            }
            
            
        }
        else
        {
            returnPg = null;
            system.debug('no document type or applicant account present');
        }
        
        return returnPg;
    }
    
}