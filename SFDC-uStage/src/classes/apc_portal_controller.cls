public without sharing class apc_portal_controller {
    
    public search_controller mySearch{get;set;}
    public apc_hf_payment_controller paymentController{get;set;}
    public profile_controller myProfile{get;set;}
    public Boolean displayInputputText{get;set;}
    public Boolean paymentPlanAvailable{get;set;}
    public Boolean isAccountBalanceMatched{get;set;}
    public Boolean chkBx{get;set;}
    public Boolean userPaidAlready{get;set;}
    public String selected{get;set;}
    public String aircode{get;set;}
    public list<SelectOption> options{get;set;}
    public Boolean sel{get;set;}
    public List<Opportunity_Product_Cart> oppProdCartList{get;set;}
    public List<Opportunity_Product_Cart> selectedOppProdCartList{get;set;}
    public List<Applicant_Info__c> ApplicantInfoList{get;set;}
    public list<Match__c> ConfMatchList{get;set;}
    public list<Member__c> memberlist{get;set;}
    public List<Opportunity> ChildOpportunityList{get;set;}
    public List<Opportunity> ParentOpportunityList{get;set;}
    public List<Sales_Invoice__c> serviceCreditSIs{get;set;}
    public Applicant_Info__c ApplicantInfo{get;set;}
    public Match__c ConfMatch{get;set;}
    public List<Match__c> lastconfmatchList{get;set;}
    public Match__c lastConfMatch{get;set;}
    public Opportunity ChildOpportunity{get;set;}
    public Opportunity ParentOpportunity{get;set;}
    public Decimal price{get;set;}
    public Boolean Infant{get;set;}
    public Decimal price1{get;set;}
    public Map<String,List<Opportunity_Product_Cart>> itemMap{get;set;}
    public Map<Date,List<Opportunity_Product_Cart>> StandardItemsDateMap{get;set;}
    public Map<Date,double> StandardItemsPriceMap{get;set;}
    public Map<Date,double> StandardItemsPriceMapWithSC{get;set;}
    public Map<Date,List<Opportunity_Product_Cart>> PaymentPlanItemsDateMap{get;set;}
    public Map<Date,double> PaymentPlanItemsPriceMap{get;set;}
    public Map<Date,double> PaymentPlanItemsPriceMapWithSC{get;set;}
    public Map<Date,List<Opportunity_Product_Cart>> InstallmentItemsDateMap{get;set;}
    public Map<Date,double> InstallmentItemsPriceMap{get;set;}
    public Map<Date,double> InstallmentItemsPriceMapWithSC{get;set;}
    public Map<Integer,double> payListIds{get;set;}
    public double StandardItemsTotalPrice{get;set;}
    public double InstallmentItemsTotalPrice{get;set;}
    public double paymentplanItemsTotalPrice{get;set;}
    
    public double StandardItemsTotalPriceWithSC{get;set;}
    public double InstallmentItemsTotalPriceWithSC{get;set;}
    public double paymentplanItemsTotalPriceWithSC{get;set;}
    
    public double selectedItemsTotalPrice{get;set;}
    public Map<date,double> SelectedItemsPriceMapDueNow{get;set;}
    public Map<date,double> SelectedItemsPriceMapDueLater{get;set;}

    public string selectedPlan{get;set;}
    public Integer NoOfInstallments{get;set;}
    public Pricing_Controller pc{get;set;}
    public string paramMatchId{get;set;}  
    public String radio { get; set; }  
    public String className;
    public String URLAux{get;set;}
    public boolean schdPaymentsAvailable{get;set;}
    public boolean isServiceCreditApplicable{get;set;}
    public string msgDisplay{get;set;}
    public double totalServiceCredit{get;set;}
    public Integer InterviewExtension{get;set;}
    
    // Default constructor
    public apc_portal_controller(){
        
        className = '@Class:'+String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))+': ';
        paramMatchId = ApexPages.currentPage().getParameters().get('mid');
        //System.debug(className + 'paramMatchId---->'+ApexPages.currentPage().getParameters().get('mid'));
        URLAux = ApexPages.currentPage().getUrl(); 
        msgDisplay = ApexPages.currentPage().getParameters().get('msgDisplay');
        //System.debug(className + 'apc_portal_controller constructor');
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
                             Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.BillingState,Account__r.BillingCountry,Account__r.FirstName, Account__r.OwnerId,CreatedBy__c,
                             Country_of_Interest__c,Intrax_Program_Category__c,Location_of_Interest__c 
                             From Applicant_Info__c a where a.CreatedBy__c =: UserInfo.getUserId() AND Application_Stage__c = 'Accepted' AND Intrax_Program__c = 'AuPairCare' order by a.CreatedDate DESC];
        //System.debug(className + 'debug::ApplicantInfoList'+ApplicantInfoList);
        //System.debug(className + 'debug::UserInfo.getUserId()'+UserInfo.getUserId());
        
        if(ApplicantInfoList != null && ApplicantInfoList.size()>0 && ApplicantInfoList[0].Position__c!=null){
            ApplicantInfo= ApplicantInfoList[0];
            ConfMatchList= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                            Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
                            Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,Actual_End_Date__c,Host_Family_Child_Opportuniy__c,
                            RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, Match_Period__c,
                            Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
                            Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc, Hide_from_Host__c, Hide_From_PT__c,
                            Infant_Specialized_Training__c,Match_Type__c
                            from match__c 
                            where  Position_Name__c =: ApplicantInfoList[0].Position__c 
                            AND    Status__c =: 'Requested' 
                            AND    Offer_Status__c = :'Accepted'
                            AND    RecordType.Name =:'AuPairCare' 
                            ORDER BY CreatedDate DESC];
            //System.debug(className + 'debug::ConfMatchlist '+ConfMatchList);
            
            memberlist = [Select id, m.Age__c From Member__c m where Account_Name__c =: applicantinfo.Account__c and Role__c ='Child'];
            //System.debug(className + 'debug::memberlist'+memberlist);
            
            if (memberlist.size()>0 && memberlist!= null)
            {
                APC_Program_Settings__c apc_ps = [Select Under_2_months__c From APC_Program_Settings__c]; 
                //System.debug('****APC_Program_Settings: ' + apc_ps);
                
                Infant = false;
                for (Member__c m:memberlist)
                {
                    if(m.Age__c*12 < apc_ps.Under_2_months__c)
                    {
                        Infant = true;
                        break;
                    }
                }
            }
            
            if(ConfMatchList !=null && ConfMatchList.size()>0 )
            {
                ConfMatch=ConfMatchList[0];
                //System.debug(className + 'debug::ConfMatch '+ConfMatch);
                
            }   
            userPaidAlready=false;
            if(ApplicantInfo.Opportunity_Name__c !=null)
            {
                childOpportunityList =[select id,ChildOppType__c,Name,Parent_Opportunity__c,
                                       Type
                                       from Opportunity 
                                       where Parent_Opportunity__c=:applicantInfo.Opportunity_Name__c 
                                       and   ChildOppType__c='Match'];                        
                if(childOpportunityList!=null && childOpportunityList.size()>0)
                {
                    childOpportunity = childOpportunityList[0];
                    
                    //check if there is any payment record on the child opportunity if yes then inform users that he already paid.
                    List<Payment__c> paymentList= [Select p.Id, p.name,p.Payment_Type__c From Payment__c p
                              where p.Payment_Type__c != 'Service Credit' and p.Opportunity_Name__c = :childOpportunityList[0].id and p.Sucess__c=true];
                    if(paymentList!=null && paymentList.size()>0)
                    {
                        system.debug('This means the user has already paid');
                        userPaidAlready = true;
                    }
                    //System.debug(className + 'debug::APC child Application Fee opportunity '+childOpportunity );
                }
            }
            
            
        }
        
        
        if(URLAux!=null && URLAux.contains('/apex/apc_hf_search_au_pairs')){
            mySearch = new search_controller('Engagement__c');
        }
        
        if(URLAux!=null && (URLAux.contains('/apex/apc_hf_match_payment_confirmation')||
                            URLAux.contains('/apex/apc_hf_match_payment_confirm_interim')||
                            URLAux.contains('/apex/apc_hf_match_payment_confirmation_pdf'))){
                                paymentController = new apc_hf_payment_controller('PaymentConfirmed');
                                if(StandardItemsDateMap!=null)
                                    System.debug(className + '@@ apc_hf_match_payment_checkout StandardItemsDateMap' +StandardItemsDateMap);
                                else
                                    System.debug(className + '@@  apc_hf_match_payment_checkoutStandardItemsDateMap in null');
                                
                            }
        //system.debug('uRLAux====='+URLAux);
        if(URLAux!=null && URLAux.contains('/apex/apc_hf_au_pair_profile')){
            myProfile = new profile_controller('Engagement__c');
            ExtHours();
            //system.debug('InterviewExtension====='+InterviewExtension);
        }
        
        if(URLAux!=null && URLAux.contains('/apex/apc_hf_profile')){  
            myProfile = new profile_controller('Position__c'); 
        }
        
        if(URLAux!=null && URLAux.contains('/apex/apc_hf_match_payment_addons'))
        {         
            pc=new pricing_controller();
            String PricebookMain = pc.getPriceBook('APC USA','Host Family','All');
            //System.debug(className + '@@ PRICEBOOKmain' +PricebookMain);
            displayInputputText = true;
            
            list<PriceBookEntry> Pricebook1 = pc.getAPCPBEFromKeyword('APC USA','Host Family','Match','match_infant_specialization_fee');
            //System.debug(className + '@@ PRICEBOOK1' +Pricebook1);
            price1= Pricebook1[0].UnitPrice;
            
            if(ConfMatch !=null)
            {
                //System.debug(className + 'debug::ConfMatch '+ConfMatch);
                if (Infant == true && ConfMatch.Engagement__r.Infant_Specialized_Circulated__c == True && 
                    ConfMatch.Engagement__r.In_Country__c == 'No')
                {
                    radio = 'Yes';
                    confMatch.Infant_Specialized_Training__c = 'Yes';            
                }
                else
                {
                     radio = null;
                    confMatch.Infant_Specialized_Training__c = 'No';
                }
            }   
        }
        
        if(URLAux!=null && URLAux.contains('/apex/apc_hf_match_payment_options'))
        {
            paymentController = new apc_hf_payment_controller(this);
            getOpportunityProductCart();
        }
        
         if(URLAux!=null && URLAux.contains('/apex/apc_view_sales_invoice'))
        {
            //paymentController = new apc_hf_payment_controller(this);
            //getOpportunityProductCart();
        }
    }
    
      //Get User TimeZone
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        system.debug('debug:::Display name: ' + tz.getDisplayName());
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 *3600 *24.0);
    }}
    public void checkradio(){        
        //System.debug(className + 'Selected value is: ' + radio); 
        
        if (radio == 'Yes')
            confMatch.Infant_Specialized_Training__c = 'Yes';
        else 
            confMatch.Infant_Specialized_Training__c = 'No';
        
    } 
    
    public List<selectOption> getairportcode1() {
        
        List<Airports__c> airportcode =[Select Name, Airport_Name__c from Airports__c where Country__c = 'USA' and AuPairCare__c =true];
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new selectOption('','NONE'));
        for (Airports__c arc: airportcode)
        {
            string airportcodename = arc.Name + '-' + arc.Airport_Name__c;
            
            options.add(new selectOption(airportcodename,airportcodename));
            airportcodename = '';
        }
        
        //System.debug(className + '*************options:'+options);
        
        return options;
        
    }
    
    public List<selectOption> getairportcode(){
        
        //System.debug(className + '*****@@@ in getairportcode()');
        
        list<Airports__c> airportsList = [Select Name, Airport_Name__c, Country__c from Airports__c WHERE Country__c = 'USA'and AuPairCare__c =true];
        
        List<SelectOption> AirportsUSAAux = new List<SelectOption>();
        String auxTextAir;
        
        AirportsUSAAux.add(new selectOption('','NONE'));
        for(integer i=0; i<airportsList.size();i++){
            auxTextAir =  '"' + String.valueOf(airportsList[i].Name) + ' - ' +   String.valueOf(airportsList[i].Airport_Name__c) + ', ' +  String.valueOf(airportsList[i].Country__c + '"');
            AirportsUSAAux.add(new selectOption(auxTextAir,auxTextAir));
        }
        //System.debug(className + '*****@@@ AirportsUSAAux: ' + AirportsUSAAux);
        return AirportsUSAAux;
    }
    
    public list<String> getairportscode(){
        
        //System.debug(className + '*****@@@ in getAirportsListUSA()');
        
        list<Airports__c> airportsList = [Select Name, Airport_Name__c, Country__c from Airports__c WHERE Country__c = 'USA' and AuPairCare__c =true];
        
        List<String> AirportsUSAAux = new String[airportsList.size()];
        String auxTextAir;
        
        
        for(integer i=0; i<airportsList.size();i++){
            auxTextAir =  '"' + String.valueOf(airportsList[i].Name) + ' - ' +   String.valueOf(airportsList[i].Airport_Name__c) + ', ' +  String.valueOf(airportsList[i].Country__c + '"');
            AirportsUSAAux[i]=auxTextAir;
        }
        //System.debug(className + '*****@@@ AirportsUSAAux: ' + AirportsUSAAux);
        return AirportsUSAAux;
    }
    
    public void getOpportunityProductCart(){
        isAccountBalanceMatched=true;
        if(ApplicantInfo.Application_Type__c=='Renewal' || ApplicantInfo.Application_Type__c=='Extension'){
        List<Position__c> lastposition=[Select id from Position__c where Host_Company_Id__c=:ApplicantInfo.Account__c ORDER BY CreatedDate DESC LIMIT 2];
        If(lastposition.size()>1)
           lastconfmatchList=[select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                            Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
                            Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,Actual_End_Date__c,Host_Family_Child_Opportuniy__c,
                            RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, Match_Period__c,
                            Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
                            Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                            Infant_Specialized_Training__c,Match_Type__c
                          from match__c where Position_Name__c=:lastposition[1].id and (Status__c='Confirmed' OR Status__c='Completed')];
        }
        
        //A rematch application might have service credit from previous application. Populate the values.
        if(ApplicantInfo.application_type__c=='Rematch')
        {
            totalServiceCredit = 0;
            ServiceCreditSIs = [Select id,Account__c,Amount_Due__c,Total__c,Document_Type__c,Document_Number__c,
                                Opportunity__c,Payment_Status__c,Name,Opportunity__r.childOppType__c
                                from    Sales_Invoice__c
                                where   Account__c = :ApplicantInfo.Account__c 
                                //and   Opportunity__c = :matchOppId
                                and Opportunity__r.childOppType__c = 'Match Break'
                                and (Payment_Status__c = 'Open' or payment_Status__c = 'Partially Paid' or payment_status__c = '') 
                                and Document_type__c = 'Sales Invoice'
                                and Total__c <= 0];
            
            for(sales_Invoice__c si : ServiceCreditSIs)
                totalServiceCredit = totalServiceCredit + si.Amount_Due__c;
            totalServiceCredit = totalServiceCredit*-1;
            
            //Now get the account balance from the account balances by entity section
            List<Account_Balance_by_Entity__c> abList = [select id,Account__c,Balance__c,External_Id__c,Name
                                                        from Account_Balance_by_Entity__c
                                                        where account__c=:ApplicantInfo.Account__c];
            
            //System.debug('abList ' + abList);
            if(abList!=null && abList.size()>0)
            {
                System.debug('Total service credit :' + (totalServiceCredit*-1));
                System.debug('Account Balance : ' + double.valueof(abList[0].Balance__c));
                if(double.valueof(abList[0].Balance__c) == (totalServiceCredit*-1))
                {
                    //system.debug('Both total service credit and account balance are equal. so proceed with the rematch');
                    isAccountBalanceMatched=true;
                }
                else
                {
                    isAccountBalanceMatched=false;
                    return;
                }
            }
            else{
                //System.debug('Something went wrong here. There is no account balances by entity on this account');
                isAccountBalanceMatched = false;
                return;
            }
            
        }
        else
            totalServiceCredit = 0;
        
        if(totalServiceCredit >0 && ApplicantInfo.application_type__c=='Rematch')
        {
            isServiceCreditApplicable = true;
        }
        else
            isServiceCreditApplicable = false;
        
        pc = new Pricing_Controller();
        pc.match = confMatch;
        
        If(lastconfmatchList != null && lastconfmatchList.size()>0)
        pc.lastconfmatch=lastconfmatchList[0];
        
        pc.opportunity = childOpportunity;
        pc.applicantInfo = ApplicantInfo;
        
        if(confMatch.Engagement__r.In_Country__c=='Yes')
        {
            if(math.abs(confMatch.End_Date__c.daysBetween(confMatch.Start_Date__c))>=305)
                paymentPlanAvailable = true;
            else
                paymentPlanAvailable = false;
        }
        else
            paymentPlanAvailable = true;
        
        oppProdCartList = new List<Opportunity_Product_Cart>();
        oppProdCartList= pc.getMatchOpportunityProducts('APC USA',ChildOpportunity.Type,ChildOpportunity.ChildOppType__c);
        
        StandardItemsDateMap= new Map<Date,List<Opportunity_Product_Cart>>();
        StandardItemsDateMap = Opportunity_Product_cart.getItemsDateMap(oppProdCartList,'Standard',confMatch.Start_Date__c);
        //System.debug(className + '@@ StandardItemsDateMap' +StandardItemsDateMap);
        
        StandardItemsPriceMap = new Map<Date,double>();
        StandardItemsPriceMap = Opportunity_Product_cart.getItemSumOnDueDate(StandardItemsDateMap);
        //System.debug(className + '@@ StandardItemsPriceMap' +StandardItemsPriceMap);
        
        PaymentPlanItemsDateMap= new Map<Date,List<Opportunity_Product_Cart>>();
        PaymentPlanItemsDateMap = Opportunity_Product_cart.getItemsDateMap(oppProdCartList,'Installment',confMatch.Start_Date__c);
        //System.debug(className + '@@ PaymentPlanItemsDateMap' +PaymentPlanItemsDateMap);
        
        PaymentPlanItemsPriceMap = new Map<Date,double>();
        PaymentPlanItemsPriceMap = Opportunity_Product_cart.getItemSumOnDueDate(PaymentPlanItemsDateMap);
        //System.debug(className + '@@ PaymentPlanItemsPriceMap' +PaymentPlanItemsPriceMap);
        
        InstallmentItemsDateMap= new Map<Date,List<Opportunity_Product_Cart>>();
        InstallmentItemsDateMap = Opportunity_Product_cart.getItemsDueLaterDateMap(oppProdCartList,'Future',confMatch.Start_Date__c);
        //System.debug(className + '@@ InstallmentItemsDateMap' +InstallmentItemsDateMap);
        
        InstallmentItemsPriceMap = new Map<Date,double>();
        InstallmentItemsPriceMap = Opportunity_Product_cart.getItemSumOnDueDate(InstallmentItemsDateMap);
        //System.debug(className + '@@ InstallmentItemsPriceMap' +InstallmentItemsPriceMap);
        
        if(isServiceCreditApplicable)
        {
            //copy the totalServiceCredit to a local variable first
            double tempServiceCredit = totalServiceCredit;
            
            StandardItemsPriceMapWithSC = new Map<Date,double>();
            double price=0.0;
            for(Date key : StandardItemsPriceMap.keySet())
            {
                price = StandardItemsPriceMap.get(key);
                if(tempServiceCredit>=price)
                {
                    tempServiceCredit = tempServiceCredit - price;
                    price = 0;
                }
                else
                {
                    price = price - tempServiceCredit;
                    tempServiceCredit = 0;
                }
                StandardItemsPriceMapWithSC.put(key,price);
                
            }
            
            //reset the tempServiceCredit with totalServiceCredit
            tempServiceCredit = totalServiceCredit;
            PaymentPlanItemsPriceMapWithSC = new Map<Date,double>();
            price=0.0;
            for(Date key : PaymentPlanItemsPriceMap.keySet())
            {
                price = PaymentPlanItemsPriceMap.get(key);
                if(tempServiceCredit>=price)
                {
                    tempServiceCredit = tempServiceCredit - price;
                    price = 0;
                }
                else
                {
                    price = price - tempServiceCredit;
                    tempServiceCredit = 0;
                }
                PaymentPlanItemsPriceMapWithSC.put(key,price);
                
            }
            
            InstallmentItemsPriceMapWithSC = new Map<Date,double>();
            price=0.0;
            for(Date key : InstallmentItemsPriceMap.keySet())
            {
                price = InstallmentItemsPriceMap.get(key);
                if(tempServiceCredit>=price)
                {
                    tempServiceCredit = tempServiceCredit - price;
                    price = 0;
                }
                else
                {
                    price = price - tempServiceCredit;
                    tempServiceCredit = 0;
                }
                InstallmentItemsPriceMapWithSC.put(key,price);
                
            }
            
        }
        
        NoOfInstallments= InstallmentItemsDateMap.keySet().size();
        
        StandardItemsTotalPrice = getStandardItemsTotalPrice();
        paymentplanItemsTotalPrice = getPaymentPlanItemsTotalPrice();
        InstallmentItemsTotalPrice = getInstallmentItemsTotalPrice();
    }
    
    
    double getStandardItemsTotalPrice()
    {
        double TotalPrice= 0.0;
        if(isServiceCreditApplicable)
        {
            for(Date key : StandardItemsPriceMapWithSC.keySet())
            {
                TotalPrice = TotalPrice + StandardItemsPriceMapWithSC.get(key);
            }
        }
        else
        {
            for(Date key : StandardItemsPriceMap.keySet())
            {
                TotalPrice = TotalPrice + StandardItemsPriceMap.get(key);
            }
        }
        
        return TotalPrice;
    }
    
    double getPaymentPlanItemsTotalPrice()
    {
        double TotalPrice= 0.0;
        if(isServiceCreditApplicable)
        {
            for(Date key : PaymentPlanItemsPriceMapWithSC.keySet())
            {
                TotalPrice = TotalPrice + PaymentPlanItemsPriceMapWithSC.get(key);
            }
            for(Date key : InstallmentItemsPriceMapWithSC.keySet())
            {
                TotalPrice = TotalPrice + InstallmentItemsPriceMapWithSC.get(key);
            }
        }
        else
        {
            for(Date key : PaymentPlanItemsPriceMap.keySet())
            {
                TotalPrice = TotalPrice + PaymentPlanItemsPriceMap.get(key);
            }
            for(Date key : InstallmentItemsPriceMap.keySet())
            {
                TotalPrice = TotalPrice + InstallmentItemsPriceMap.get(key);
            }
        }
        
        return TotalPrice;
    }
    
    double getInstallmentItemsTotalPrice()
    {
        double TotalPrice = 0.0;
        if(isServiceCreditApplicable)
        {
            for(Date key : InstallmentItemsPriceMapWithSC.keySet())
            {
                TotalPrice = TotalPrice + InstallmentItemsPriceMapWithSC.get(key);
            }
        }
        else
        {
            for(Date key : InstallmentItemsPriceMap.keySet())
            {
                TotalPrice = TotalPrice + InstallmentItemsPriceMap.get(key);
            } 
        }
        
        return TotalPrice;
    }
    
    
    public PageReference navigator(){
        
        // ** APC- Preventing the user navigate in the application when the real Application_Stage__c = 'Submitted'. Problem with the cache when the user clicks back automaticatlly.
        //If is an APC App and is Submitted go directly to your_application      
        
        //System.debug(className + '***** Inside Navigator');
        // System.debug(className + '###### docType2: ' + docType );
        Applicant_Info__c applicantInfo = new Applicant_Info__c();
        
        Id aIdStage = ApexPages.currentPage().getParameters().get('Id');
        
        //System.debug(className + 'urlaux' + URLAux);
        if(URLAux!=null && URLAux.contains('/apex/apc_hf_match_payment_addons'))
        {         
            if(confMatch!=null)
            {
                //System.debug(className + 'Navigator: ' + 'url: ' + URLAux);
                //System.debug('the radio button value is ' + radio);
                if(radio !=null & radio == 'Yes')
                    confMatch.Infant_Specialized_Training__c = 'Yes';
                else if(radio == null || radio =='No')
                    confMatch.Infant_Specialized_Training__c = 'No';
                    
                update confMatch;
                PageReference p = Page.apc_hf_match_payment_options;
                p.setRedirect(true);
                return p;
            } 
        }
        else if(URLAux!=null && URLAux.contains('/apex/apc_hf_match_payment_options'))
        {  
            //System.debug(className + 'Navigator: ' + 'url: ' + URLAux);
            String plan = ApexPages.currentPage().getParameters().get('SelectedPayment');
            if(plan!=null && !String.isEmpty(plan))
            {
                selectedPlan=plan;
                //System.debug(className + 'selected plan is ' + selectedPlan);
                //Populate the selected cart list as per the selected plan
                populateSelectedCartList();
            }
            PageReference p = Page.apc_hf_match_payment_checkout;
            p.setRedirect(false);
            return p;
        }
        
        return null;
    }
    
    public PageReference populateSelectedItems(){
        //System.debug(className + '***** Inside populateSelectedItems');
        String plan = ApexPages.currentPage().getParameters().get('SelectedPayment');
        if(plan!=null && !String.isEmpty(plan))
        {
            selectedPlan=plan;
            //System.debug(className + 'selected plan is ' + selectedPlan);
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
        payListIds = new Map<Integer,double>();
        Integer counter=0;
        
        if(selectedPlan == 'Standard')
        {
            for(Opportunity_product_cart opp : oppProdCartList)
            {
                if(opp.paymentMethod=='All' || opp.paymentMethod=='Standard')
                    selectedOppProdCartList.Add(opp);
            }
            selectedItemsTotalPrice = StandardItemsTotalPrice;
            if(isServiceCreditApplicable)
            {
                for(Date key : StandardItemsPriceMapWithSC.keySet())
                {
                    counter = counter +1;
                if(key<=System.today())
                {
                    SelectedItemsPriceMapDueNow.put(key,StandardItemsPriceMapWithSC.get(key));
                    if(StandardItemsPriceMap.get(key) != StandardItemsPriceMapWithSC.get(key))
                        payListIds.put(counter,StandardItemsPriceMap.get(key) - StandardItemsPriceMapWithSC.get(key));
                }
                else
                    SelectedItemsPriceMapDueLater.put(key,StandardItemsPriceMapWithSC.get(key));
                    if(StandardItemsPriceMap.get(key) != StandardItemsPriceMapWithSC.get(key))
                        payListIds.put(counter,StandardItemsPriceMap.get(key) - StandardItemsPriceMapWithSC.get(key));
                }
            }
            else
            {
                for(Date key : StandardItemsPriceMap.keySet())
                {
                if(key<=System.today())
                    SelectedItemsPriceMapDueNow.put(key,StandardItemsPriceMap.get(key));
                else
                    SelectedItemsPriceMapDueLater.put(key,StandardItemsPriceMap.get(key));
                }
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
            
            if(isServiceCreditApplicable)
            {
                counter =0;
                for(Date key : PaymentPlanItemsPriceMapWithSC.keySet())
                {
                    counter = counter + 1;
                    if(key<=System.today())
                    { 
                        SelectedItemsPriceMapDueNow.put(key,PaymentPlanItemsPriceMapWithSC.get(key));
                        if(PaymentPlanItemsPriceMap.get(key) != PaymentPlanItemsPriceMapWithSC.get(key))
                            payListIds.put(counter,PaymentPlanItemsPriceMap.get(key) - PaymentPlanItemsPriceMapWithSC.get(key));
                    }
                    else
                    {
                        SelectedItemsPriceMapDueLater.put(key,PaymentPlanItemsPriceMapWithSC.get(key));
                        if(PaymentPlanItemsPriceMap.get(key) != PaymentPlanItemsPriceMapWithSC.get(key))
                            payListIds.put(counter,PaymentPlanItemsPriceMap.get(key) - PaymentPlanItemsPriceMapWithSC.get(key));
                    }
                }
                for(Date key : InstallmentItemsPriceMapWithSC.keySet())
                {
                    counter = counter+1;
                    SelectedItemsPriceMapDueLater.put(key,InstallmentItemsPriceMapWithSC.get(key));
                    if(InstallmentItemsPriceMap.get(key) != InstallmentItemsPriceMapWithSC.get(key))
                            payListIds.put(counter,InstallmentItemsPriceMap.get(key) - InstallmentItemsPriceMapWithSC.get(key));
                }
            }
            else
            {
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
            
            
        }
        
        if(SelectedItemsPriceMapDueLater!=null && SelectedItemsPriceMapDueLater.size()>0)
            schdPaymentsAvailable=true;
        else
            schdPaymentsAvailable=false;
        
    }
    
    public PageReference ViewSalesInvoice()
    {
        //System.debug('Inside viewSalesInvoice');
        PageReference returnPg;
        if(ApexPages.currentPage().getParameters().get('documenttype')!=null)
        {
            /*List<Account> lstAccount;
            lstAccount =[Select a.Status__c,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,
                         a.Description,a.APISessionId__c,a.APIServerUrl__c,a.API_Partner_Server_URL_70__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, 
                         a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, 
                         a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, 
                         a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, 
                         a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:ApplicantInfo.account__c
                         LIMIT 1];
            System.debug('****lstAccount: ' + lstAccount);
            
            Account acc = lstAccount[0];*/
            
            HttpRequest req = new HttpRequest();
            
            Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAccountSyncUrl');
            //System.debug('****appconstant: ' + appconstant);
            
            String endPointAccountSync = appconstant.Value__c + 'getSessionId?accountId='+ ApplicantInfo.account__c;
            //String endPointAccountSync = 'https://srvvpc-app-dev.intraxinc.com:8443/IntraxMiddleTier-1.0.1-SNAPSHOT/imtrest/' + 
              //                          'getSessionId?accountId='+ ApplicantInfo.account__c;
            
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
            
            String documentid = ApexPages.currentPage().getParameters().get('documentid');
            System.debug('documentid is ' + documentid);
            
            String documenttype = 'Sales+Invoice';//ApexPages.currentPage().getParameters().get('documenttype');
            System.debug('documenttype is ' + documenttype);
            
            String sforcekey=resultArray.get('encodedSid');
            System.debug('after encoding sforcekey' + sforcekey);
            
            String endpoint = resultArray.get('encodedurl');
            System.debug('after encoding endpoint' + endpoint);
            
            String mega='shared';
            String userentity='intrax-sandbox';
            String objectentity='apc';
            String accountentity='intrax-sandbox';
            String url = 'https://www.intacct.com/ia/acct/sforcerouter.phtml?.action=PRINT_SODOCUMENT&' +
                '.documentid=' + documentid + '&' +
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
            returnPg = null;
        
        return returnPg;
    }
    
    public PageReference SynchronizeSalesDocument()
    {
        //System.debug('Inside SynchronizeSalesDocument');
        PageReference returnPg;
        if(ApexPages.currentPage().getParameters().get('documenttype')!=null)
        {
            /*List<Account> lstAccount;
            lstAccount =[Select a.Status__c,a.Intacct_Sync_At__c,a.Type,a.Intacct_Sync_By__c,a.Intacct_Sync_Msg__c,
                         a.Description,a.APISessionId__c,a.APIServerUrl__c,a.API_Partner_Server_URL_70__c,a.PersonEmail, a.LastName, a.Intrax_Programs__c, 
                         a.Intrax_Program_Category__c, a.Intrax_Id__c, a.IntacctID__c, a.Id, a.FirstName, a.Fax, a.ShippingStreet, 
                         a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.PersonMailingStreet, 
                         a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry, a.PersonMailingCity, a.BillingStreet, 
                         a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.id=:ApplicantInfo.account__c
                         LIMIT 1];
            System.debug('****lstAccount: ' + lstAccount);
            
            Account acc = lstAccount[0];*/
            
            HttpRequest req = new HttpRequest();
            
            Application_Constants__c appconstant = Application_Constants__c.getInstance('IntacctAccountSyncUrl');
            //System.debug('****appconstant: ' + appconstant);
            
            //String endPointAccountSync = appconstant.Value__c + 'getSessionId?accountId='+ accId;
            String endPointAccountSync = 'https://srvvpc-app-dev.intraxinc.com:8443/IntraxMiddleTier-1.0.1-SNAPSHOT/imtrest/' + 
                                          'getSessionId?accountId='+ ApplicantInfo.account__c;
            
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
            
            String documentid = ApexPages.currentPage().getParameters().get('documentid');
            System.debug('documentid is ' + documentid);
            
            String documenttype = 'Sales+Invoice';//ApexPages.currentPage().getParameters().get('documenttype');
            System.debug('documenttype is ' + documenttype);
            
            String sforcekey=resultArray.get('encodedSid');
            System.debug('after encoding sforcekey' + sforcekey);
            
            String endpoint = resultArray.get('encodedurl');
            System.debug('after encoding endpoint' + endpoint);
            
            String mega='shared';
            String userentity='intrax-sandbox';
            String objectentity='apc';
            String accountentity='intrax-sandbox';
            String url = 'https://www.intacct.com/ia/acct/smartlinklaunch.phtml?' +
                '.sess='+'OrRd9e0yau-SBNzBGG_dnTJL79ME3A..&'+
                '.smartlinkkey=33&' +
                '.op=5200&' +
                '.vid=Sales+Invoice-' + documentid + '&' +
                '.dt=Sales+Invoice';
            
            System.debug('URl is ' + url);
            returnPg = new PageReference(url);
        }
        else
            returnPg = null;
        
        return returnPg;
    }
    
    
    public PageReference viewtransfercost()
    {
        //system.debug('@@@@@ selected: ' + selected);
        if (selected != '')
        { 
            //System.debug(className + '@@selected' +selected);    
            String[] aircode = selected.split('-');
            //System.debug(className + '@@selectdcode'+aircode[0]);
            aircode[0] = aircode[0].replace('\"', '');
            //System.debug(className + '@@selectdcode'+aircode[0]);
            list<PriceBookEntry> Pricebookinfant = pc.getAPCTravelService('APC USA','Host Family','Match',aircode[0].trim());
            ConfMatch.Airport_Code__c = aircode[0].trim();
            //System.debug(className + '@@ Pricebookinfant' +Pricebookinfant);
            //System.debug(className + '@@ PRICEBOOK' +Pricebookinfant[0].UnitPrice);
            price = Pricebookinfant[0].UnitPrice;
            sel = true;
            
            
            
        }
        else 
        { 
            //System.debug(className + '@@selected' +selected);    
            sel=false;
        } 
        return null;  
    }
    
    public PageReference click(){   
        if(chkBx){
            ConfMatch.Airport_Code__c ='';
            displayInputputText = false;
            sel= false;
        }
        else{
            
            displayInputputText = true;
        }
        return null;
    }
    
    public PageReference inCountrySkipPage(){
        CreateMatchChildOpp();
        if(ConfMatch!=null)
        {
            if(ConfMatch.Engagement__r.In_Country__c == 'Yes')
            {
                PageReference p = Page.apc_hf_match_payment_options;
                p.setRedirect(true);
                return p;
            }
            else 
                return null;
            
        }
        else 
            return null;
    }
    
    public Applicant_Info__c applicant{get{
        
        if(applicant == null){
            list<Applicant_Info__c> app = [Select a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
                                           a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Submitted__c, a.Study_Time__c, a.Street__c, a.State__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, 
                                           a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
                                           a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Accommodation_Price_Range__c, a.Arrival_Time__c, a.Health_Needs_Indicated__c,
                                           a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Points_of_Interest__c, 
                                           a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c,
                                           a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, a.Opportunity_Name__c, a.Nearest_City__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c,
                                           a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c,a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.IsDeleted, a.Intrax_Program_Options__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c,
                                           a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c,
                                           a.Government_Assistence_Indicated__c, a.GPA__c, a.GPA_Self_Reported__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, 
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
                                           Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,a.Extension_Length__c, a.Extension_DOS_Fee_Indicated__c,
                                           a.Application_Type__c, a.Engagement__c, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c, a.Engagement__r.OwnerId, a.Extension_Au_Pair_Agreed__c,
                                           a.Position__c, a.Engagement__r.Arrival_PNR_Number__c, a.Engagement__r.Arrival_Trip_URL__c, a.Engagement__r.Engagement_End__c, a.Engagement__r.Private_High_School_Indicated__c,
                                           a.Engagement__r.Requested_Departure_1__c, a.Engagement__r.Requested_Departure_2__c, a.Engagement__r.Requested_Departure_3__c, a.Engagement__r.Departing_City__c,  a.Engagement__r.Flight_booking_needed__c,
                                           a.Engagement__r.International_Destination_Airport__c,a.Engagement__r.Domestic_Departure_Airport__c, Account__r.Name,
                                           Account__r.discretionary_discount__c,Account__r.rematch_type__c,CreatedBy__c
                                           From Applicant_Info__c a
                                           where a.CreatedBy__c =: UserInfo.getUserId() AND Application_Stage__c != 'Cancelled' AND Intrax_Program__c = 'AuPairCare' AND Application_Level__c = 'Main' order by a.CreatedDate DESC];
            if(app!=null && app.size()>0){
                applicant = app[0];
                return applicant;
            }else{
                Applicant_Info__c appAux = new Applicant_Info__c(); 
                return appAux;
            }
        }else{
            return applicant;
        }
    }
                                       set;}
    
    
    
    //Jose-B-02827 //APC HF COntact Us page
    
    public Zip_Code__c zipAreaHF{get{
        //system.debug('@@@@@inside zipAreaHF');
        if(zipAreaHF == null){
            if(applicant.Home_Postal_Code__c != null){
                
                list<Zip_Code__c> zipList = [Select Id, Zip_Code__c, Area__c, Area__r.Area_Director__c
                                             From Zip_Code__c 
                                             where Zip_Code__c LIKE: '%' + string.valueof(applicant.Home_Postal_Code__c).left(5) + '%']; 
                
                if(zipList!=null && zipList.size()>0){
                    Zip_Code__c zipA = zipList[0];
                    return zipA;
                }else{
                    Zip_Code__c areaAux = new Zip_Code__c(); 
                    return areaAux;
                }
            }else{
                Zip_Code__c areaAux = new Zip_Code__c(); 
                return areaAux; 
            }
        }else{
            return zipAreaHF;
        }
        
    }
                                 set;}
    
    
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page
    public User_Profile__c ADUserProf{get{
        try{
        if(ADUserProf == null){
            if(appInfoHost.Account__r.OwnerId!= null && String.valueOf(appInfoHost.Account__r.OwnerId).left(3) != '00G'){
                //system.debug('@@@@@ApplicantInfo.Id: ' + appInfoHost.Id);
                //system.debug('@@@@@AppInfoHost.Account__r.OwnerId: ' + AppInfoHost.Account__r.OwnerId);
                list<User_Profile__c> userListP = [Select Id, User_Name__c, User_Email__c, User_Phone__c
                                                   From User_Profile__c 
                                                   where User__c =: AppInfoHost.Account__r.OwnerId]; 
                
                if(userListP!=null && userListP.size()>0){
                    User_Profile__c userprof = userListP[0];
                    return userprof;
                }else{
                    User_Profile__c uprofAux = new User_Profile__c(); 
                    return uprofAux; 
                }
            }else if(zipAreaHF.Area__r.Area_Director__c != null){
                
                list<User_Profile__c> userListP = [Select Id, User_Name__c, User_Email__c, User_Phone__c
                                                   From User_Profile__c 
                                                   where User__c =: zipAreaHF.Area__r.Area_Director__c]; 
                
                if(userListP!=null && userListP.size()>0){
                    User_Profile__c userprof = userListP[0];
                    return userprof;
                }else{
                    User_Profile__c uprofAux = new User_Profile__c(); 
                    return uprofAux; 
                }
            }else{
                User_Profile__c uprofAux = new User_Profile__c(); 
                return uprofAux; 
            }
        }else{
            return ADUserProf;
        }
        }catch(Exception e){
            //system.debug('@@@@@Exception in ADUserProf: ' + e);
            User_Profile__c uprofAux = new User_Profile__c(); 
            return uprofAux;
        }
        
        }
        set;}
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Sales_Assignments__c MatchingExpert{get{
        try{
        if(MatchingExpert == null){
            if(appInfoHost.Account__r.OwnerId!=null && String.valueOf(appInfoHost.Account__r.OwnerId).left(3) != '00G'){
                User uAd = [Select Id, Name, Region__c From User WHERE Id =: appInfoHost.Account__r.OwnerId]; 
                return apc_portal_utilities.MatchingExpert(uAd.Region__c);
            }else{
                APC_Sales_Assignments__c apcSalesAux = new APC_Sales_Assignments__c(); 
                return apcSalesAux;
            }
        
        }else{
            return MatchingExpert;  
        }
        }catch(Exception e){
            //system.debug('@@@@@Exception in MatchingExpert: ' + e);
            APC_Sales_Assignments__c apcSalesAux = new APC_Sales_Assignments__c(); 
            return apcSalesAux;
        }   
    }
    set;}

    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public Applicant_Info__c appInfoHost{get{
        try{
        if(appInfoHost == null){
            list<Applicant_Info__c> ApplicantInfoListAux = [Select Id, Name, Account__r.OwnerId
                                From Applicant_Info__c a 
                                where a.CreatedBy__c =: UserInfo.getUserId() AND Intrax_Program__c = 'AuPairCare' AND Application_Stage__c != 'Cancelled' order by a.CreatedDate DESC];
            //system.debug(className + 'debug::ApplicantInfoListAux'+ApplicantInfoListAux);
            //system.debug(className + 'debug::UserInfo.getUserId()'+UserInfo.getUserId());
        
            if(ApplicantInfoListAux != null && ApplicantInfoListAux.size()>0){
                appInfoHost= ApplicantInfoListAux[0];
                return appInfoHost;
            }else{
                Applicant_Info__c appInfoHostAux = new Applicant_Info__c(); 
                return appInfoHostAux;
            }
        
        }else{
            return appInfoHost;  
        }
        }catch(Exception e){
            //system.debug('@@@@@Exception in appInfoHost: ' + e);
            Applicant_Info__c appInfoHostAux = new Applicant_Info__c(); 
            return appInfoHostAux;
        }   
    }
    set;}
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Contact_Information__c BillingInfo{get{
        try{
        if(BillingInfo == null){
            APC_Contact_Information__c apcBilling = APC_Contact_Information__c.getValues('Billing Information');
            if(apcBilling!=null){
                return apcBilling;
            }else{
                APC_Contact_Information__c apcBillingAux = new APC_Contact_Information__c(); 
                return apcBillingAux; 
            }
        }else{
            return BillingInfo;
        }
        }catch(Exception e){
            //system.debug('@@@@@Exception in BillingInfo: ' + e);
            APC_Contact_Information__c apcBillingAux = new APC_Contact_Information__c(); 
            return apcBillingAux;
        }    
    }
    set;}
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Contact_Information__c InsuranceInfo{get{
        
        if(InsuranceInfo == null){
            return apc_portal_utilities.InsuranceInfo();
        
        }else{
            return InsuranceInfo;  
        }
    }
    set;}
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Contact_Information__c HQInfo{get{
        if(HQInfo == null){
            return apc_portal_utilities.HQInfo();
        
        }else{
            return HQInfo;
        }
    }
    set;}
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public APC_Contact_Information__c EmergencyLine{get{
         if(EmergencyLine == null){
            return apc_portal_utilities.EmergencyLine();
        
        }else{
            return EmergencyLine;
        }
    }
    set;}
    
    
    //Jose-B-02827 //APC HF COntact Us page
    public String photoADUrl{get{
        
        if(photoADUrl == null){
            
            if(ADUserProf.id !=null){
                //system.debug('@@@@@ADUserProf.Id photo: ' + ADUserProf.Id);
                if(!Test.isRunningTest()){
                    photoADUrl=aws_controller.getApcManagerPhoto(String.valueOf(ADUserProf.Id));
                }
                return photoADUrl;
            }else{
                String photoADUrlAux = 'no picture'; 
                return photoADUrlAux;
            }
        }else{
            return photoADUrl;
        }
        
    }
                             set;}  
    
    //Jose-B-02827 //Send Email to Matching Expert - apc_ap_contact
    public String Subject{get;set;}
    public String MessageBody{get;set;}
    
    //Jose-B-02827 //Send Email to Matching Expert - apc_ap_contact
    public PageReference sendEmailToExpert(){
        //system.debug('@@@@@inside sendEmailToExpert()');
        PageReference p;
        p = new PageReference('/apex/apc_hf_contact');
        p.setRedirect(true);
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Case Cas = new Case();
        
        try{
            if(MatchingExpert.ME_Email__c!=null){
                
                String htmlBody = '<p>Hi '+ MatchingExpert.ME_Email__c +',</p><p>Host Family '+ applicant.Account__r.Name + ' would like to ask you something:</p><p>"'+ MessageBody + '"</p>';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                list<String> listEmailString = new list<String>{MatchingExpert.ME_Email__c};
                //system.debug('@@@@@listEmailString: ' + listEmailString);
                mail.setToAddresses(listEmailString);
                mail.setSubject(Subject);
                mail.setSaveAsActivity(false);
                mail.setHtmlBody(htmlBody);
                
                emails.add(mail);
                Messaging.sendEmail(emails);  
                
            }
           
            Cas.RecordTypeId = Constants.CASE_AuPairCare;
            Cas.Origin = 'Web';
            Cas.AccountId = applicant.Account__c;
            Cas.Subject = Subject;
            Cas.Description = MessageBody;
            Cas.Type = 'Help With Matching';
            insert Cas;
            
        }catch(Exception e){
            system.debug('#####Error sending HF email to Matching expert : ' + e);
        }
        return p;
        
    }
    
    
     public void ExtHours(){
     
       //system.debug('debug::ExtHours');
       if (ApplicantInfo!=null)
       {
       //system.debug('@@@@@ApplicantInfo.Id: ' + ApplicantInfo.Id);
                //Showing Extension Hours
                if (ApplicantInfo.Engagement__r.In_Country__c == 'No') {        
                    APC_Program_Settings__c ps = [Select OSAP_Interview_Extension_Hours__c From APC_Program_Settings__c];           
                    InterviewExtension = integer.valueOf(ps.OSAP_Interview_Extension_Hours__c);
                }else{
                    APC_Program_Settings__c ps = [Select ICAP_Interview_Extension_Hours__c From APC_Program_Settings__c];
                    InterviewExtension = integer.valueOf(ps.ICAP_Interview_Extension_Hours__c);
                }
         //system.debug('debug::ExtHours'+InterviewExtension);
       }   
       
    }
    
    
    //Jose-B-02819 //Retrieving the last APp Match to see the status
    
    public Applicant_Info__c applicantSearch{get{
        
        if(applicantSearch == null){
            list<Applicant_Info__c> app = [Select a.Emergency_Contact_Complete__c, a.Previous_Address_Complete__c, a.graduated__c, a.School_Officials_Title__c, a.School_Officials_Name__c, a.Behavioral_Problems__c, Behavioral_Problems_Description__c, a.Language_spoken_1__c, a.Language_spoken_2__c, a.Language_spoken_3__c, a.Language_spoken_years_1__c, a.Language_spoken_years_2__c, a.Language_spoken_years_3__c, a.Years_in_Home__c, a.Writing_Skills__c, 
                                           a.Weight__c, a.Type__c, a.Title__c, a.TimeZoneSidKey__c, a.Teaching_Method__c, a.TE_Known_for_Months__c, a.TE_Known_For_Years__c, a.SystemModstamp, a.Submitted__c, a.Study_Time__c, a.Street__c, a.State__c, a.Special_Ed__c, a.Special_Ed_Description__c, a.Special_Diet__c, a.Special_Diet_Indicated__c, a.Special_Diet_Expectations__c, a.Special_Diet_Expectation_Description__c, a.Special_Diet_Description__c, a.Speaking_Skills__c, a.Smoking_Location__c, a.Smoker_in_Family__c, 
                                           a.Skip_or_Repeat__c, a.Skip_or_Repeat_Description__c, a.Single_No_Children_Indicated__c, a.Shared_Bedroom__c, a.Shared_Bathroom__c, a.Second_Language_Level__c, a.School_Transportation__c, a.School_Transportation_Description__c, a.School_Recruiting_Indicated__c, a.School_Recruiting_Description__c, a.School_Name__c, a.School_Employee__c, a.SOR_Received_Date__c, 
                                           a.Religious_Activity_on_Program__c, a.Religious_Activity_Home__c, a.Religion__c, a.RecordTypeId, a.Recommended_Grade__c, a.Reading_Comprehension__c, a.Private_Bedroom__c, a.Private_Bathroom__c, a.Accommodation_Price_Range__c, a.Arrival_Time__c, a.Health_Needs_Indicated__c,
                                           a.Prior_Hosting_Agency__c, a.Prior_Host_Experience__c, a.Prior_Host_Description__c, a.Prior_Exchange_Visa__c, a.Prior_Exchange_Experience__c, a.Primary_Language__c, a.PreUniversity_Years_at_Start__c, a.PreUniversity_Years_Required__c, a.Postal_Code__c, a.Points_of_Interest__c, 
                                           a.Pets_in_House__c, a.Pets__c, a.Pets_Description__c, a.Pet_Types__c, a.Pet_Count__c, a.Personality_Structure__c, a.Personality_Opinionatedness__c, a.Personality_Maturity__c, a.Personality_Independence__c, a.Personality_Funniness__c, a.Personality_Expressiveness__c, a.Personality_Energy_Level__c,
                                           a.Partner_Name__c, a.Partner_Intrax_Id__c, a.Parent_Marital_Status__c, a.PR_Traditional_Family_Stmt__c, a.PR_Interview_Date__c, a.PR_English_Interview_Stmt__c, a.OwnerId, a.Overall_Progress__c, a.Opportunity_Name__c, a.Nearest_City__c, a.Name, a.Meal_Self_Sufficient__c, a.Major__c, a.Low_Grade_Count__c,
                                           a.Lives_With__c, a.Lives_With_Other__c, a.Lived_Independently__c, a.Lived_Independently_Description__c, a.Live_With_Smoker__c, a.Live_With_Pets__c, a.Live_With_Pets_Description__c, a.Legal_Guardian__c, a.Lead__c,a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.Languages_Spoken__c, a.IsDeleted, a.Intrax_Program_Options__c, a.International_Travel__c, a.International_Travel_Description__c, a.Interests__c,
                                           a.Interests_Top__c, a.Id, a.How_Long_Tought__c, a.How_Long_Study_English__c, a.Household_Income_Range__c, a.Host_Special_Diet__c, a.Home_Visit_Checklist__c, a.Home_Type__c, a.Home_Street_2__c, a.Home_Street_1__c, a.Home_State__c, a.Home_Responsibilities__c, a.Home_Postal_Code__c, a.Home_Phone__c, a.Home_Country__c, a.Home_City__c, a.Height__c, a.Graduation_Year__c, a.Graduation_Expected_by_School__c, a.Graduation_Date__c,
                                           a.Government_Assistence_Indicated__c, a.GPA__c, a.GPA_Self_Reported__c, a.Field_Work_Experience__c, a.Fax__c, a.Family_Member_Count__c, a.Family_Activities__c, a.Extracurricular_Transportation__c, a.Exchange_Agency_Employment__c, 
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
                                           Portal_Contact_Id__c, Program_Duration__c, Last_Applicant_Update__c, a.Extension_Preferences__c,a.Extension_Length__c, a.Extension_DOS_Fee_Indicated__c,
                                           a.Application_Type__c, a.Engagement__c, a.Engagement__r.Engagement_Start__c, a.Engagement__r.Status__c, a.Engagement__r.OwnerId, a.Extension_Au_Pair_Agreed__c,
                                           a.Position__c, a.Engagement__r.Arrival_PNR_Number__c, a.Engagement__r.Arrival_Trip_URL__c, a.Engagement__r.Engagement_End__c, a.Engagement__r.Private_High_School_Indicated__c,
                                           a.Engagement__r.Requested_Departure_1__c, a.Engagement__r.Requested_Departure_2__c, a.Engagement__r.Requested_Departure_3__c, a.Engagement__r.Departing_City__c,  a.Engagement__r.Flight_booking_needed__c,
                                           a.Engagement__r.International_Destination_Airport__c,a.Engagement__r.Domestic_Departure_Airport__c
                                           From Applicant_Info__c a
                                           where a.CreatedBy__c =: UserInfo.getUserId() AND Application_Stage__c != 'Cancelled' order by a.CreatedDate DESC];
            if(app!=null && app.size()>0){
                applicantSearch = app[0];
                return applicantSearch;
            }else{
                Applicant_Info__c appAux = new Applicant_Info__c(); 
                return appAux;
            }
        }else{
            return applicantSearch;
        }
        
    }
                                             set;}
    public list<Match__c> MatchConf{get{
        
        if(MatchConf == null){
            if(applicantSearch != null && applicantSearch.Position__c!=null){
                list<Match__c> ConfMatchListAux= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                                                  Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
                                                  Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,
                                                  RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, 
                                                  Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
                                                  Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                                                  Infant_Specialized_Training__c
                                                  from match__c 
                                                  where  Position_Name__c =: applicantSearch.Position__c 
                                                  AND    (Status__c = 'Requested' OR Status__c = 'Confirmed')
                                                  AND    RecordType.Name =:'AuPairCare' 
                                                  ORDER BY CreatedDate DESC];
                //system.debug('@@@@@ConfMatchListAux: ' + ConfMatchListAux);
                
                if(ConfMatchListAux!=null && ConfMatchListAux.size()>0){
                    MatchConf = ConfMatchListAux;
                    return MatchConf;
                }else{
                    list<Match__c> matchAux = new list<Match__c>(); 
                    return matchAux;
                }
            }else{
                list<Match__c> matchAux = new list<Match__c>(); 
                return matchAux;
            }
        }else{
            return MatchConf;
        }
        
    }
    set;}
    
    public list<Match__c> AllMatches{get{
        
        if(AllMatches == null){
            if(applicantSearch != null && applicantSearch.Position__c!=null){
                list<Match__c> EEMatchListAux= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                                                  Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
                                                  Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,
                                                  RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, 
                                                  Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
                                                  Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                                                  Infant_Specialized_Training__c, Position_Name__r.Status__c,Host_Account__c
                                                  from match__c 
                                                  where  Position_Name__c=: applicantSearch.Position__c
                                                  AND    RecordType.Name =:'AuPairCare' 
                                                  ORDER BY CreatedDate DESC];
                //system.debug('@@@@@EEMatchListAux: ' + EEMatchListAux);
                
                if(EEMatchListAux!=null && EEMatchListAux.size()>0){
                    AllMatches = EEMatchListAux;
                    return AllMatches;
                }else{
                    list<Match__c> matchAux = new list<Match__c>(); 
                    return matchAux;
                }
            }else{
                list<Match__c> matchAux = new list<Match__c>(); 
                return matchAux;
            }
        }else{
            return AllMatches;
        }
        
    }
    set;}
    
    public boolean getReMatchAppExists(){
        List<Applicant_Info__c> reMatchAppList = [SELECT Id, CreatedBy__c, Application_Stage__c,Intrax_program__c From Applicant_Info__c where CreatedBy__c =: UserInfo.getUserId() 
                        AND (Application_Type__c = 'Rematch' OR Application_Type__c = 'Renewal' OR Application_Type__c = 'Extension') AND Application_Stage__c='Accepted'                         
                        AND Intrax_Program__c = 'AuPairCare' AND Type__c='Host Family' order by CreatedDate DESC];
        if(reMatchAppList!=null && reMatchAppList.size()>0){
            return true;
        }
        else
            return false;
    }
    
    
    //JOSE B-03139 Display Notification to offer Early Match Disccount 90 days before the current match end date                              
    public list<Match__c> MatchConfOld{get{
        
        if(MatchConfOld == null){
            //system.debug('@@@@@MatchConfOld: ' + MatchConfOld);
            if(applicantSearch.Application_Type__c=='Renewal' && MatchConf != null && MatchConf.size() == 0){
                list<Position__c> lastposition=[Select id from Position__c where Host_Company_Id__c=:ApplicantInfo.Account__c ORDER BY CreatedDate DESC LIMIT 2];
                if(lastposition.size()>1){
                    list<Match__c> MatchConfOldAux =[select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                                Engagement__r.Infant_Specialized_Indicated__c,Engagement__r.Infant_Specialized_Circulated__c,
                                Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,Actual_End_Date__c,Host_Family_Child_Opportuniy__c,
                                RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, Match_Period__c,
                                Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,Engagement__r.Under_2_Circulated__c,
                                Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                                Infant_Specialized_Training__c,Match_Type__c
                                from Match__c where Position_Name__c=:lastposition[1].id and (Status__c='Confirmed' OR Status__c='Completed')];
                    //system.debug('@@@@@MatchConfOldAux: ' + MatchConfOldAux);
                    return MatchConfOldAux;
                }else{
                    list<Match__c> matchAux = new list<Match__c>(); 
                    return matchAux;
                }
            }else{
                list<Match__c> matchAux = new list<Match__c>(); 
                return matchAux;
            }
        }else{
            return MatchConfOld;
        }
    }
    set;}                                
    //END JOSE B-03139                                 
    
    public void CreateMatchChildOpp()
    {   //First create the child opportunity "Match" if it doesnot exists.
       
        if(ApplicantInfo!=null)
        {       //System.debug('createChild HF Opp of type Match. applicant details' + ApplicantInfo);
                Opportunity MatchChildOpp = AppTriggerHelper.CreateAppOpp(ApplicantInfo,ApplicantInfo.Opportunity_Name__c,'USD','Match');
                //System.debug('Child opportunity creation suuccessfull' + MatchChildOpp);
           
        }
    }
        
        
    
}