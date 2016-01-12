public class apc_hf_payment_controller {
    
    public string TypeCreditCardSelected{get;set;}
    public string monthSelected{get;set;}
    public string yearSelected{get;set;}
    public apc_portal_controller mainController{get;set;}
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
        options.add(new SelectOption(string.valueof(year + 11),string.valueof(year + 11)));
        options.add(new SelectOption(string.valueof(year + 12),string.valueof(year + 12)));
        options.add(new SelectOption(string.valueof(year + 13),string.valueof(year + 13)));
        options.add(new SelectOption(string.valueof(year + 14),string.valueof(year + 14)));
        options.add(new SelectOption(string.valueof(year + 15),string.valueof(year + 15)));
        
        return options;
    }
    
    public PaymentWrapper payWrapper {get; set;}
    public PaymentSubscriptionWrapper PaySubsWrapper {get; set;}
    public List<Payment_Subscription__c> TokenRetrive {get; set;}
    public Payment__c payment {get; set;}
    public Payment_Subscription__c paymentSubscription {get; set;}
    public Boolean authorization {get; set;}
    public String maskedCCNumber {get; set;}        
    public String paymentRecordId {get; set;}
    public Boolean isConfirmPayment {get; set;}
    public Boolean useCurrentBillingAddressInfo {get; set;}
    public String paymentTxId {get; set;}
    public Decimal paymentAmount {get; set;}
    public String paymentDate {get; set;}
    
    public decimal amount{get;set;}
    public Opportunity childApplicationOpportunity{get;set;}
    public List<Person_info__c> personInfoList {get;set;}
    public List<Applicant_Info__c> ApplicantInfoList {get;set;}    
    public Person_Info__c personInfo{get;set;}
    public Applicant_Info__c applicantInfo{get;set;}    
    public Boolean isPaymentSuccessful{get; set;}
    public String paymentError{get; set;}
    public list<Opportunity> opp{get;set;}
    public List<Account> accountInfo{get;set;}
    public Account acctObj{get;set;}
    public Id paramAppId{get;set;}
    public Id paramMatchId{get;set;}
    public Id paramOppId{get;set;}
    public String hasAnyException{get;set;}
    //default constructor    
    public apc_hf_payment_controller(apc_portal_controller apcportalcontroller){
        mainController= apcportalcontroller;
        String URLAux = ApexPages.currentPage().getUrl(); 
        System.debug('apc_hf_payment_controller constructor' + 'url is: ' + URLAux);
        if(mainController.StandardItemsDateMap!=null)
            system.debug('@@ apc_hf_payment_controller StandardItemsDateMap' +mainController.StandardItemsDateMap);
        else
            system.debug('@@  apc_hf_payment_controller StandardItemsDateMap in null');
        
        paramAppId = ApexPages.currentPage().getParameters().get('sAppId');
        paramMatchId = ApexPages.currentPage().getParameters().get('mId');
        System.debug('sAppId--->'+paramAppId);
        
        isConfirmPayment = false;
        personInfoList = new List<Person_Info__c>();
        ApplicantInfoList = new List<Applicant_Info__c>();
        ApplicantInfoList=mainController.ApplicantInfoList;
        applicantInfo=mainController.ApplicantInfo;
        childApplicationOpportunity=mainController.ChildOpportunity;
        
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
                          p.Overall_Health__c,p.Medication_Indicated__c,p.Medication_Description__c, p.Hospitalization_Description__c,p.Psychiatric_Treatment_Description__c,p.Graduation_Date__c, p.Drug_Dependency_Description__c, p.Physical_Disabilities_Description__c, p.Contagious_Disease_Description__c,
                          p.Illnesses__c, p.Illness_Description__c, p.Chronic_Disease__c, p.Chronic_Disease_Description__c, p.Pregnancy_Indicated__c,p.Physical_Disabilities_Indicated__c,
                          p.Contagious_Disease_Indicated__c,p.Drug_Dependency_Indicated__c,p.Braces_Indicated__c,p.Braces_Removal_Date__c,p.Health_Concerns__c,p.Source_Referral_Other__c,
                          p.Medical_Health_Agreement__c, Reference_Request_Note__c,Program_Phone__c,Program_Phone_Type__c,
                          p.Physical_Exam_Date__c,p.History_Of_Illness_Indicated__c,p.History_Of_Illness_Details__c, p.Overall_Health_From_Doctor__c
                          From Person_Info__c p 
                          Where p.Applicant_Info__c =:applicantInfo.Id and role__c='Host' LIMIT 1];
        
        if(applicantInfo!=null && applicantInfo.Account__c!=null)
            accountInfo = [select Id,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry,FirstName,LastName,PersonEmail from Account where Id  = :applicantInfo.Account__c];
        
        if(personInfoList!=null && personInfoList.size()>0){
            personInfo = personInfoList[0];
        }
        
        if(accountInfo!=null && accountInfo.size()>0){
            acctObj = accountInfo[0];
        }
        
        //Check subscription Token Availibity
        TokenRetrive=[select Id,Account__c,Encrypted_Token__c,Txn_Amount__c,Txn_Code__c,Txn_Date__c,Txn_Gateway__c,Txn_Id__c,Txn_Reference_Id__c,
                      Txn_Result__c,Txn_Result_Msg__c,Txn_Type__c,Txn_User__c,Is_Active__c
                      from Payment_Subscription__c where Account__c=:applicantInfo.Account__c AND Is_Active__c = True order by CreatedDate desc limit 1];
        system.debug('debug::TokenRetrive--'+TokenRetrive);
    }
    
    //this constructor is only called from apc_hf_match_payment_confirmation pages
    public apc_hf_payment_controller(String afterPaymentConfirmation){
        
        try
        {
            String URLAux = ApexPages.currentPage().getUrl(); 
            System.debug('apc_hf_payment_controller constructor' + 'url is: ' + URLAux);
            
            if(ApexPages.currentPage().getParameters().get('Id') != null) 
            {
                paramAppId = ApexPages.currentPage().getParameters().get('Id');
                System.debug('paramAppId ' + paramAppId);
            }
            
            if(ApexPages.currentPage().getParameters().get('mId') != null) {
                paramMatchId = ApexPages.currentPage().getParameters().get('mId');
                System.debug('paramMatchId ' + paramMatchId);
            }
            
            if(ApexPages.currentPage().getParameters().get('oppId') != null) {
                paramOppId = ApexPages.currentPage().getParameters().get('oppId');
                System.debug('paramOppId ' + paramOppId);
            }
            
            if(ApexPages.currentPage().getParameters().get('paymentTxId') != null) {
                paymentTxId = ApexPages.currentPage().getParameters().get('paymentTxId');
                System.debug('paymentTxId ' + paymentTxId);
            }
            
            if(ApexPages.currentPage().getParameters().get('paymentDate') != null){ 
                paymentDate = ApexPages.currentPage().getParameters().get('paymentDate');
                System.debug('paymentDate ' + paymentDate);
            }
            
            if(ApexPages.currentPage().getParameters().get('paymentId') != null) {
                paymentRecordId = ApexPages.currentPage().getParameters().get('paymentId');
                System.debug('paymentRecordId ' + paymentRecordId);
                
            }
            
             if(ApexPages.currentPage().getParameters().get('IsException') != null) {
                hasAnyException = ApexPages.currentPage().getParameters().get('IsException');
                System.debug('hasAnyException ' + hasAnyException);
            }
            else
                hasAnyException = 'false';
            
        }
        catch(Exception e)
        {
            IUtilities.sendExceptionEmail(e);
        }
    }
    
    /*public void updateRecords()
    {
        if(paramOppId!=null)
        {
            List<Opportunity> childOpp = [SELECT Id,Name,AccountId FROM Opportunity WHERE Id=:paramOppId 
                                          and StageName != 'Closed Won' LIMIT 1];
            if(childOpp!=null && childOpp.size()>0)
            {
                Match__c tempConfMatch=null;
                if(paramMatchId!=null)
                {
                    List<Match__c> confMatch = [SELECT Id,Name,Start_Date__c,End_Date__c,Participant_Id__c,Participant_Id__r.name,Position_Name__r.OwnerId,Engagement__c FROM Match__c WHERE Id=:paramMatchId LIMIT 1];
                    if(confMatch!=null && confMatch.size()>0){
                        tempConfMatch = confMatch[0];
                        tempConfMatch.Status__c = 'Confirmed';
                        //AA B-03243
                        tempConfMatch.Host_Account__c=childOpp[0].AccountId;
                        update tempConfMatch;
                        System.debug('match update successful match is ' + tempConfMatch);
                        
                        //B-03226. Share AP Account and Application with Position owner                
                        Set<Id> accIds = new Set<Id>();
                        accIds.add(confMatch[0].Participant_Id__c);
                        
                        Sharing_Security_Controller.shareAccount(accIds,confMatch[0].Position_Name__r.OwnerId);
                        
                        List<Applicant_Info__c> PTAppList = [Select a.Id,a.OwnerId,a.Engagement__c From Applicant_Info__c a where a.engagement__c = :confMatch[0].Engagement__c];                                
                        if(PTAppList!=null && PTAppList.size()>0)
                        {
                            Sharing_Security_Controller.shareApplicantRecord(PTAppList,confMatch[0].Position_Name__r.OwnerId);
                        }                    
                        
                    }
                }
                
                if(paymentRecordId !=null)
                {
                    List<Payment__c> paymentList = [SELECT Id,Name,serializedProductList__c,Amount__c FROM Payment__c WHERE Id=:paymentRecordId LIMIT 1];
                    if(paymentList!=null & paymentList.size()>0)
                    {
                        paymentAmount = paymentList[0].amount__c;
                        List<Opportunity_Product_Cart> selectedOppProds = 
                            (List<Opportunity_Product_Cart>)JSON.deserialize(paymentList[0].serializedProductList__c, 
                                                                             List<Opportunity_Product_Cart>.class);
                        if(selectedOppProds!=null && selectedOppProds.size()>0)
                        {
                            System.debug('@class: apc_hf_payment_controller: selectedOppProds' + selectedOppProds);
                            insertOppProds(selectedOppProds);
                        }
                        if(paramOppId!=null)
                        {
                            closeChildOpp(paramOppId,tempConfMatch);
                        }
                    }
                }
                
            }
        }
    }*/
    
    public PageReference updateRecords1()
    {
        PageReference p = Page.apc_hf_match_payment_confirmation;
        String hasException = 'false';
        try
        {
            if(paramOppId!=null)
            {
                List<Opportunity> childOpp = [SELECT Id,Name,AccountId FROM Opportunity WHERE Id=:paramOppId 
                                              and StageName != 'Closed Won' LIMIT 1];
                if(childOpp!=null && childOpp.size()>0)
                {
                    Match__c tempConfMatch=null;
                    if(paramMatchId!=null)
                    {
                        List<Match__c> confMatch = [SELECT Id,Name,Start_Date__c,End_Date__c,Participant_Id__c,Participant_Id__r.name,Position_Name__r.OwnerId,Engagement__c FROM Match__c WHERE Id=:paramMatchId LIMIT 1];
                        if(confMatch!=null && confMatch.size()>0)
                        {
                            tempConfMatch = confMatch[0];
                            tempConfMatch.Status__c = 'Confirmed';
                            tempConfMatch.Host_Account__c=childOpp[0].AccountId;
                            update tempConfMatch;
                            System.debug('match update successful match is ' + tempConfMatch);
                            
                            /*try
                            {
                                //B-03226. Share AP Account and Application with Position owner                
                                Set<Id> accIds = new Set<Id>();
                                accIds.add(confMatch[0].Participant_Id__c);
                                
                                Sharing_Security_Controller.shareAccount(accIds,confMatch[0].Position_Name__r.OwnerId);
                                
                                List<Applicant_Info__c> PTAppList = [Select a.Id,a.OwnerId,a.Engagement__c From Applicant_Info__c a where a.engagement__c = :confMatch[0].Engagement__c];                                
                                if(PTAppList!=null && PTAppList.size()>0)
                                {
                                    Sharing_Security_Controller.shareApplicantRecord(PTAppList,confMatch[0].Position_Name__r.OwnerId);
                                } 
                                
                            }
                            catch(Exception e)
                            {
                                hasException = 'true';
                                System.debug('Some exception occured while sharing the AP Account' +
                                             'and Application with Position owner. Exception is ' + e);
                                sendExceptionEmail(e);
                            }*/
                        }
                    }
                }
            }
            
        }
        catch(Exception e)
        {
            hasException = 'true';
            System.debug('Some exception occured while updating the match status to confirmed'
                        + 'Exception is '  + e);
            IUtilities.sendExceptionEmail(e);
            //send an email to sfdcnotify group about the match finalization error
            
        }
        finally
        {
            p.getParameters().put('Id',paramAppId);
            p.getParameters().put('mId',paramMatchId);
            p.getParameters().put('oppId',paramOppId);
            p.getParameters().put('paymentId',paymentRecordId);
            if(!String.isBlank(paymentTxId))
                p.getParameters().put('paymentTxId', paymentTxId);
            if(!String.isBlank(paymentDate))
                p.getParameters().put('paymentDate', paymentDate);
            
            if(hasException !=null && hasException == 'true')
            {
                p.getParameters().put('IsException','true');                
            }
            else
            {
                p.getParameters().put('IsException','false'); 
            }
            
        }
        p.setRedirect(true);
        return p;
    }
    
    
    public void updateRecords2()
    {
        try
        {
            if(hasAnyException == 'true')
            return ;
            
            if(paymentRecordId !=null)
            {
                List<Payment__c> paymentList = [SELECT Id,Name,serializedProductList__c,Amount__c FROM Payment__c WHERE Id=:paymentRecordId LIMIT 1];
                if(paymentList!=null & paymentList.size()>0)
                {
                    paymentAmount = paymentList[0].amount__c;
                    List<Opportunity_Product_Cart> selectedOppProds = 
                        (List<Opportunity_Product_Cart>)JSON.deserialize(paymentList[0].serializedProductList__c, 
                                                                         List<Opportunity_Product_Cart>.class);
                    if(selectedOppProds!=null && selectedOppProds.size()>0)
                    {
                        System.debug('@class: apc_hf_payment_controller: selectedOppProds' + selectedOppProds);
                        insertOppProds(selectedOppProds);
                    }
                    Match__c tempConfMatch=null;
                    if(paramMatchId!=null)
                    {
                        List<Match__c> confMatch = [SELECT Id,Name,Start_Date__c,End_Date__c,Participant_Id__c,Participant_Id__r.name,Position_Name__r.OwnerId,Engagement__c FROM Match__c WHERE Id=:paramMatchId LIMIT 1];
                        if(confMatch!=null && confMatch.size()>0)
                        {
                            tempConfMatch = confMatch[0];
                           
							try
                            {
                            	//B-03468 Setting Position Status to 'CLosed-Filled'
                            	if(confMatch.size() > 0 && confmatch[0].Position_Name__c != null){
                            		closeRelatedPosition(confMatch[0].Position_Name__c);
                            	}
                                //B-03226. Share AP Account and Application with Position owner                
                                Set<Id> accIds = new Set<Id>();
                                accIds.add(confMatch[0].Participant_Id__c);
                                
                                Sharing_Security_Controller.shareAccount(accIds,confMatch[0].Position_Name__r.OwnerId);
                                
                                List<Applicant_Info__c> PTAppList = [Select a.Id,a.OwnerId,a.Engagement__c From Applicant_Info__c a where a.engagement__c = :confMatch[0].Engagement__c];                                
                                if(PTAppList!=null && PTAppList.size()>0)
                                {
                                    Sharing_Security_Controller.shareApplicantRecord(PTAppList,confMatch[0].Position_Name__r.OwnerId);
                                } 
                                
                            }
                            catch(Exception e)
                            {
                                hasAnyException = 'true';
                                System.debug('Some exception occured while sharing the AP Account' +
                                             'and Application with Position owner. Exception is ' + e);
                                IUtilities.sendExceptionEmail(e);
                                return;
                            }
                            
                            if(paramOppId!=null)
                            {
                                closeChildOpp(paramOppId,tempConfMatch);
                            }
                            
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            hasAnyException= 'true';
            IUtilities.sendExceptionEmail(e);
        }
    }
    
    public void closeRelatedPosition(Id posId){
    	list<Position__c> pList = [SELECT Id, Status__c FROM Position__c WHERE Id =: posId ];
    	if(pList.size() > 0){
    		plist[0].Status__c = 'Closed - Filled';
    	}
    	
    	update pList[0];  	    	
    }
    
    public void init()
    {
        isPaymentSuccessful = true;
        system.debug('inside init method of apc_hf_payment_contorller');
        payment = new Payment__c();
        paymentSubscription = new Payment_Subscription__c();
        payWrapper = new PaymentWrapper();
        PaySubsWrapper= new PaymentSubscriptionWrapper();
        isConfirmPayment = false;
        useCurrentBillingAddressInfo = false;           
        amount =0.0;
        system.debug('SelectedItemsPriceMapDueNow' + mainController.SelectedItemsPriceMapDueNow);
        for(double amountTemp : mainController.SelectedItemsPriceMapDueNow.Values())
        {
            amount = amount + amountTemp;
        }
        System.debug('amount is ' + amount);
        
        if(ApexPages.currentPage().getParameters().get('expireMonth') != null) 
            monthSelected = ApexPages.currentPage().getParameters().get('expireMonth');
        if(ApexPages.currentPage().getParameters().get('expireYear') != null) 
            yearSelected = ApexPages.currentPage().getParameters().get('expireYear');
        if(ApexPages.currentPage().getParameters().get('maskCCNumber') != null) 
            maskedCCNumber = ApexPages.currentPage().getParameters().get('maskCCNumber');
        
        if(ApexPages.currentPage().getParameters().get('paymentTxId') != null) 
            paymentTxId = ApexPages.currentPage().getParameters().get('paymentTxId');
        
        if(ApexPages.currentPage().getParameters().get('paymentDate') != null) 
            paymentDate = ApexPages.currentPage().getParameters().get('paymentDate');
        
        if(ApexPages.currentPage().getParameters().get('paymentId') != null) {
            paymentRecordId = ApexPages.currentPage().getParameters().get('paymentId');
            
            System.debug('payemnt record id' + paymentRecordId);
            List<Payment__c> paymentRecords = [Select Id, Amount__c, Txn_Id__c FROM Payment__c WHERE ID =: ID.valueOf(paymentRecordId)];
            if(paymentRecords.size() > 0) {
                payWrapper.amount = paymentRecords[0].Amount__c;
                payWrapper.txnId =  paymentRecords[0].Txn_Id__c;
            }
        }
        If(TokenRetrive.size()>0){
            navigateToPaymentNonEditPage();
        }
    }
    
    //AA Schedule Payment --- CreateSubcription Token 
    Public Pagereference makeAWSPayment(){
        
		try
        {
        isPaymentSuccessful = true;
       
        amount =0.0;
        decimal TotalAmount=0.0;
        for(double amount : mainController.SelectedItemsPriceMapDueNow.Values()){
            TotalAmount = TotalAmount + amount;
        }
        
        totalAmount = totalAmount.setScale(2);
        payWrapper.amount = TotalAmount;
        amount = TotalAmount;
        
        //Setting required properties before invoking payment web service
        system.debug('*****### payment.Amount__c: ' + payment.Amount__c);
        system.debug('*****### payment.Promo_Code__c: ' + payment.Promo_Code__c);
        
        //Populating some other properties
        if(!String.isBlank(monthSelected))
            payWrapper.cardExpirationMonth = monthSelected;
        if(!String.isBlank(yearSelected))
            payWrapper.cardExpirationYear = yearSelected;
        if(!String.isBlank(TypeCreditCardSelected))
            payWrapper.cardType = TypeCreditCardSelected;
        
        
        //Now save all the selected product list in a serialized format in the payment object, irrespective of whether the payment is successfull or not.
        payment.serializedProductList__c= JSON.serialize(mainController.selectedOppProdCartList);
        system.debug('*****### We are here 1  - payment test: ' + payment);
        payment.Card_Holder__c = applicantInfo.Id;
        payment.Account_Name__c=applicantInfo.Account__c;
        payment.Txn_Type__c='Charge';
        payment.Amount__c = payWrapper.amount;
        
        if(childApplicationOpportunity!=null)
            payment.Opportunity_Name__c = childApplicationOpportunity.Id;
        
        paymentSubscription.Txn_Type__c='Create';
        paymentSubscription.Account__c=applicantInfo.Account__c;
        paymentSubscription.Txn_Amount__c=payWrapper.amount;
        
        //Variable to hold the AWS Subscription process response result
        paymentScheduledWebServiceInterface.createSubscriptionResponse CreateSubcriptionResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        paymentScheduledWebServiceInterface.createSubscriptionResponse paymentResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
        
        System.debug('makeAWSPayment payment record is '+ payment);
        System.debug('makeAWSPayment paymentSubscription record is '+ paymentSubscription);
        System.debug('makeAWSPayment payWrapper record is '+ payWrapper);
        
        if(!Test.isRunningTest()) {
            
            If(TokenRetrive.size() == 0){
                //Making web service callout to get the response
                CreateSubcriptionResponse = PaymentService.CreateSubcription(paymentSubscription, applicantInfo, PaySubsWrapper, payWrapper,acctObj);
                paymentSubscription = PaymentHelper.parseEncryptedWebServiceResponseToken(paymentSubscription, CreateSubcriptionResponse);
                //paymentSubscription.Error_Description__c = 'The card verification (CVV) check failed. Please enter correct CVV code.';
                //paymentSubscription.Error_Keys__c = '230';
                //paymentSubscription.Encrypted_Token__c = null;
                System.debug('@@@@ CreateSubcriptionResponse ' + CreateSubcriptionResponse);
                If(paymentSubscription.Encrypted_Token__c != null){
                    paymentSubscription.Is_Active__c  = True;
                    paymentSubscription.Txn_Amount__c  = TotalAmount;
                    try
                    {
                        
                        //StringException s = new StringException();
                        //throw s;
                        paymentResponse = PaymentService.CreateSubcriptionPayment(paymentSubscription,payment, applicantInfo,  payWrapper);
                        payment=PaymentHelper.parseEncryptedWebServiceResponsePayment(payment, paymentResponse);
                        
                    }
                    catch(Exception e)
                    {
                        backToPaymentEditPage();
                        IUtilities.sendExceptionEmail(e);
                    }
                    
                }
                
            }
            If(TokenRetrive.size()>0 && TokenRetrive[0].Is_Active__c==True){
                try{
                    
                    Payment_Subscription__c RepeatPaymentSubcription=TokenRetrive[0];
                    System.debug('Repeat makeAWSPayment RepeatPaymentSubcription record is '+ RepeatPaymentSubcription);
                    paymentResponse = PaymentService.CreateSubcriptionPayment(RepeatPaymentSubcription,payment, applicantInfo,  payWrapper);
                    payment=PaymentHelper.parseEncryptedWebServiceResponsePayment(payment, paymentResponse); 
                }
                catch(Exception e)
                {
                    backToPaymentEditPage();
                    IUtilities.sendExceptionEmail(e);
                }
            }
            
        } else {
            //Setting paymentSubscription object fields values with the help of response retrived properties values
            paymentSubscription.Txn_Type__c='Create';
            paymentSubscription.Account__c=applicantInfo.Account__c;
            paymentSubscription.Txn_Amount__c=payWrapper.amount;
            payment.Txn_Id__c = String.valueOf(Math.random() + '_1');
            payment.Txn_Type__c='Charge';
            payment.Sucess__c = true;
            payment.Txn_Gateway__c = 'Cyberspace';
            payment.Txn_Amount__c = 123.45;
            payment.Txn_Date__c = System.now();
            payment.Payment_Type__c = 'Visa';
            payment.Txn_Code__c = '123XXX';
        }
        //Trying to create a new payment record in system with response retrieved value and implementing post callout logic according to it
        system.debug('*****###payment test: ' + payment);
        system.debug('*****###paymentSubscription test: ' + paymentSubscription);
        
        // Insert Token paymentSubscription.
        If(TokenRetrive.size()==0 && paymentSubscription.Encrypted_Token__c != null &&  paymentSubscription.Encrypted_Token__c != ''){
            insert paymentSubscription;
        }
        
        if(!String.isBlank(payment.Txn_Id__c))  {      
            //To Override Transaction amount it should be removed when code moved to production
            payment.Txn_Amount__c = amount;
            insert payment;
            
            if(mainController.payListIds!=null && mainController.payListIds.Size()>0)
            {
                List<payment__c> payList = new List<payment__c>();
                for(integer counter: mainController.payListIds.KeySet())
                {
                    System.debug('counter is ' + counter);
                    Payment__c serviceCreditPmnt = new Payment__c();
                    serviceCreditPmnt.Account_Name__c = applicantInfo.Account__c;
                    serviceCreditPmnt.Opportunity_Name__c = childApplicationOpportunity.Id;
                    serviceCreditPmnt.Payment_Type__c = 'Service Credit';
                    decimal amt = mainController.payListIds.get(counter);
                    amt=amt.setScale(2);
                    serviceCreditPmnt.Txn_Amount__c = amt;
                    serviceCreditPmnt.Amount__c = amt;
                    serviceCreditPmnt.Sucess__c = true;
                    serviceCreditPmnt.Txn_Date__c = System.now();
                    serviceCreditPmnt.Txn_Gateway__c = 'Au Pair Care';
                    serviceCreditPmnt.Txn_Id__c = ''+counter;
                    serviceCreditPmnt.Txn_Reference_Id__c = ''+counter;
                    serviceCreditPmnt.Txn__c = 'Service Credit applied to sales invoice number ' + counter;
                    serviceCreditPmnt.Card_Holder__c = applicantInfo.Id;
                    system.debug('payment before insert ' + serviceCreditPmnt);
                    payList.add(serviceCreditPmnt);
                }
                if(payList!=null && payList.size()>0)
                {
                    insert paylist;
                }
            }
            
            system.debug('debug::PaySubsWrapper++++'+PaySubsWrapper);
            try
            {
                if(accountInfo!=null && accountInfo.size()>0)
                {
                    System.debug('before accountBillingStreet' + accountInfo[0].BillingStreet);
                    System.debug('before paymentBillingStreet' + PaySubsWrapper.BillingStreet + ' street2 ' + PaySubsWrapper.BillingStreet2);
                    String accountBillingStreet = accountInfo[0].BillingStreet.replace('\r\n','');
                    String paymentBillingStreet;
                    if(PaySubsWrapper.BillingStreet2!=null)
                        paymentBillingStreet= PaySubsWrapper.BillingStreet.replace('\r\n','') + PaySubsWrapper.BillingStreet2.replace('\r\n','');
                    else
                        paymentBillingStreet = PaySubsWrapper.BillingStreet.replace('\r\n','');
                    System.debug('after accountBillingStreet' + accountBillingStreet);
                    System.debug('after paymentBillingStreet' + paymentBillingStreet);
                    
                    if (accountBillingStreet != paymentBillingStreet ||
                        accountInfo[0].BillingCity != PaySubsWrapper.BillingCity ||
                        accountInfo[0].BillingState != PaySubsWrapper.BillingState ||
                        accountInfo[0].BillingPostalCode != PaySubsWrapper.BillingPostalCode ||
                        accountInfo[0].BillingCountry != PaySubsWrapper.BillingCountry)
                    {
                        if(PaySubsWrapper.BillingStreet2!=null)
                            accountInfo[0].BillingStreet= PaySubsWrapper.BillingStreet+ '\r\n' + PaySubsWrapper.BillingStreet2;
                        else
                            accountInfo[0].BillingStreet= PaySubsWrapper.BillingStreet;
                        
                        accountInfo[0].BillingCity = PaySubsWrapper.BillingCity;
                        accountInfo[0].BillingState = PaySubsWrapper.BillingState;
                        accountInfo[0].BillingPostalCode = PaySubsWrapper.BillingPostalCode;
                        accountInfo[0].BillingCountry = PaySubsWrapper.BillingCountry;
                        system.debug('@@ check point1. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                        update accountInfo[0];
                        system.debug('@@ check point2. AccountInfo is' +accountInfo[0] +  'payment is ' + payment);
                    }
                }
            }
            catch(Exception e)
        	{
            	IUtilities.sendExceptionEmail(e);
            }
                        
            //Populating string with masked Credit Card number string, Going to be displayed on page
            system.debug('*****##payment test: ' + payment);
            paymentRecordId = payment.Id;
            paymentTxId = payment.Txn_Id__c;
            paymentAmount = payment.Txn_Amount__c.setScale(2);
            paymentDate = String.valueOf(payment.Txn_Date__c);
            system.debug('*****## paymentTxId: ' + paymentTxId);
            system.debug('*****## paymentAmount: ' + paymentAmount);
            
            // Creating the attachment pdf payment confirmation
            
            PageReference pdf = Page.apc_hf_match_payment_confirmation_pdf;
            
            system.debug('*****## pdf: ' + pdf);
            pdf.getParameters().put('paymentAmount',String.valueOf(paymentAmount));
            pdf.getParameters().put('paymentDate',paymentDate);
            pdf.getParameters().put('paymentTxId',paymentTxId);
            pdf.getParameters().put('title','AuPairCare Childcare Application');
            //pdf.getParameters().put('id',applicantinfo.id);
            pdf.setRedirect(true);
            
            // Take the PDF content
            Blob b = pdf.getContent();
            
            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('payment_confirmation.pdf');
            efa.setBody(b);
            //send an email to the user
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String emailPrimary= personinfo.Email__c;
            //String[] toAddresses = new String[]{emailPrimary};
            //mail.setToAddresses(toAddresses);
            mail.setSaveAsActivity(false);
            //mail.setSubject('AuPairCare Fee Payment Confirmation');
            //Get the payment email ID from Custom Setting Application Constants
            String EmailPaymentId;
            List<Application_Constants__c> appconstants = Application_Constants__c.getall().values();
            Application_Constants__c appconstant = Application_Constants__c.getInstance('APC_Payment_Confirmation_ID');
            EmailPaymentId=appconstant.Value__c;
            mail.setTemplateId(EmailPaymentId);
            mail.setTargetObjectId(applicantinfo.CreatedBy__c); 
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            emails.add(mail);
            
            try{    
                Messaging.sendEmail(emails);
            }catch(Exception ex)
            {
                System.debug('Failed to send email. Exception is ' + ex);
            }
            
            PageReference p = Page.apc_hf_match_payment_confirm_interim;
            p.getParameters().put('Id',applicantInfo.Id);
            p.getParameters().put('mId',mainController.ConfMatch.Id);
            p.getParameters().put('oppId',mainController.ChildOpportunity.Id);
            p.getParameters().put('paymentId',paymentRecordId);
            
            if(!String.isBlank(paymentTxId))
                P.getParameters().put('paymentTxId', paymentTxId);
            if(!String.isBlank(paymentDate))
                P.getParameters().put('paymentDate', paymentDate);
            
            p.setRedirect(true);
            return p;
            
        } 
        
        else {
            isPaymentSuccessful= false;
            //If there is any exception, still insert the payment record with error for tracking purpose
            If(!String.isBlank(paymentSubscription.Error_Description__c))
                payment.Error_Description__c=paymentSubscription.Error_Description__c.replace('_',' ');
            
            If(!String.isBlank(payment.Error_Description__c))
                payment.Error_Description__c=payment.Error_Description__c.replace('_',' ');
            
            If(paymentSubscription.Error_Keys__c != null)
                payment.Error_Keys__c=paymentSubscription.Error_Keys__c;
            
            //system.debug('paymentSubscription.Error_Keys__c:::::'+paymentSubscription.Error_Keys__c);
            
            insert payment;
			if(!String.isBlank(payment.Error_Description__c))
                paymentError = payment.Error_Description__c;
            else
                paymentError = 'Please check your credit card details and try again. If you are still unable to pay, please submit another credit card or contact our Billing Department at 800-428-7247 option 4 for assistance.';
            
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'' + paymentError);
            ApexPages.addMessage(errorMessage);
            system.debug('@@ error :'+errorMessage);
            
            system.debug('*****### We are here 2  - paymentSubscription test: ' + paymentSubscription);
            system.debug('@@@ paymentSubscription.Txn_Reference_Id__c@@@' +paymentSubscription.Txn_Reference_Id__c);
            //Reset billing address data
            paymentSubscription = new payment_Subscription__c();
            payment = new payment__c();
            //Reset credit card info
            TypeCreditCardSelected=null;
            payWrapper.ccNumber=null;
            monthSelected=null;
            yearSelected=null;
            payWrapper.cvvNumber=null;
            
            //If transaction failed, keeping amount and promocode
            paymentSubscription.Txn_Amount__c = amount;
            
            useCurrentBillingAddressInfo = false;
            
            backToPaymentEditPage();
            system.debug('*****### isConfirmPayment:' + isConfirmPayment);
            system.debug('*****### isPaymentSuccessful:' + isPaymentSuccessful);
            
            return null;
        	}
        }
        catch(Exception e)
        {
            backToPaymentEditPage();
            paymentError = e.getMessage();
            IUtilities.sendExceptionEmail(e);
            return null;
        }
    }
    
    
    public pagereference noPaymentRequired()
    {   
        try
        {
            if(mainController.payListIds!=null && mainController.payListIds.size()>0 )
            {
                List<payment__c> payList = new List<payment__c>();
                for(integer counter: mainController.payListIds.KeySet())
                {
                    System.debug('counter is ' + counter);
                    Payment__c serviceCreditPmnt = new Payment__c();
                    serviceCreditPmnt.Account_Name__c = applicantInfo.Account__c;
                    //Now save all the selected product list in a serialized format in the payment object, irrespective of whether the payment is successfull or not.
                    if(counter ==1)
                    {
                        serviceCreditPmnt.serializedProductList__c= JSON.serialize(mainController.selectedOppProdCartList);
                    }
                    serviceCreditPmnt.Opportunity_Name__c = childApplicationOpportunity.Id;
                    serviceCreditPmnt.Payment_Type__c = 'Service Credit';
                    decimal amt= mainController.payListIds.get(counter);
                    amt=amt.setScale(2);
                    serviceCreditPmnt.Txn_Amount__c = amt;
                    serviceCreditPmnt.Amount__c =amt;
                    serviceCreditPmnt.Sucess__c = true;
                    serviceCreditPmnt.Txn_Date__c = System.now();
                    serviceCreditPmnt.Txn_Gateway__c = 'Au Pair Care';
                    serviceCreditPmnt.Txn_Id__c = ''+counter;
                    serviceCreditPmnt.Txn_Reference_Id__c = ''+counter;
                    serviceCreditPmnt.Txn__c = 'Service Credit applied to sales invoice number ' + counter;
                    serviceCreditPmnt.Card_Holder__c = applicantInfo.Id;
                    system.debug('payment before insert ' + serviceCreditPmnt);
                    payList.add(serviceCreditPmnt);
                }
                if(payList!=null && payList.size()>0)
                {
                    insert paylist;
                }
                
                PageReference p = Page.apc_hf_match_payment_confirm_interim;
                p.getParameters().put('Id',applicantInfo.Id);
                p.getParameters().put('mId',mainController.ConfMatch.Id);
                p.getParameters().put('oppId',mainController.ChildOpportunity.Id);
                if(payList!=null && payList.size()>0)
                {
                    p.getParameters().put('paymentId',payList[0].id);
                }
                else
                    p.getParameters().put('paymentId',null);
                if(!String.isBlank(paymentTxId))
                    P.getParameters().put('paymentTxId', '');
                if(!String.isBlank(paymentDate))
                    P.getParameters().put('paymentDate', '');
                p.setRedirect(true);
                return p;
            }
            else 
                return null;
            
        }
        catch(Exception e)
        {
         IUtilities.sendExceptionEmail(e);   
            return null;
        }
        
    }
    
    public pagereference navigateToPaymentOptionsPage()
    {
        PageReference pdf = Page.apc_hf_match_payment_options;
        pdf.setRedirect(true);
        system.debug('*****## pdf: ' + pdf);
        return pdf;
    }
    
    public void blankOutAddressDetailsOnPaymentPage() {
        
        if(useCurrentBillingAddressInfo != null && useCurrentBillingAddressInfo) {
            
            //Populating Address fields on payment record
            payment.Billing_FirstName__c = personInfo.First_Name__c;
            payment.Billing_LastName__c = personInfo.Last_Name__c;
            PaySubsWrapper.BillingEmail = personInfo.Email__c;
            
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
            
            //PaySubsWrapper.BillingStreet = applicantInfo.Account__r.BillingStreet;
            //payment.Billing_Street_2__c = applicantInfo.Home_Street_2__c;
            PaySubsWrapper.BillingCity = applicantInfo.Account__r.BillingCity;
            PaySubsWrapper.BillingState = applicantInfo.Account__r.BillingState;
            PaySubsWrapper.BillingCountry = applicantInfo.Account__r.BillingCountry;
            PaySubsWrapper.BillingPostalCode = applicantInfo.Account__r.BillingPostalCode;
            
        } 
        else {
            
            //Populating Address fields on payment record
            payment.Billing_FirstName__c = '';
            payment.Billing_LastName__c = '';
            payment.Billing_Email__c = '';
            //payment.Billing_Phone__c = '';
            PaySubsWrapper.BillingEmail='';
            PaySubsWrapper.BillingStreet = '';
            PaySubsWrapper.BillingStreet2 = '';
            PaySubsWrapper.BillingCity  = '';
            PaySubsWrapper.BillingState = '';
            PaySubsWrapper.BillingCountry = '';
            PaySubsWrapper.BillingPostalCode = '';
        }
    }
    
    public void backToPaymentEditPage() {
        isConfirmPayment = false;
    }
    
    public void navigateToPaymentNonEditPage() {
        isPaymentSuccessful = true;
        paymentSubscription.Txn_Reference_Id__c = GuidGenerator.generateGUID();
        payment.Txn_Reference_Id__c = GuidGenerator.generateGUID();
        
        If(TokenRetrive.size() == 0){
            if(String.isBlank(payWrapper.ccNumber)||String.isBlank(payWrapper.cvvNumber) ) 
            {
                system.debug('@@ cc numbr @@' +payWrapper.ccNumber);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Please enter all required values'));
            }
            
            else{
                system.debug('*****###into navigateToPaymentNonEditPage()');
                maskedCCNumber = '************' + payWrapper.ccNumber.subString(payWrapper.ccNumber.length()-4, payWrapper.ccNumber.length());
                payment.Amount__c = amount;
                System.debug('navigateToPaymentNonEditPage : ' + payment);
                isConfirmPayment = true;            
            }
            
        }
        
        If(TokenRetrive.size()>0){
            PaySubsWrapper = new PaymentSubscriptionWrapper();
            paymentScheduledWebServiceInterface.createSubscriptionResponse paymentSubscriptionRetrieveResponse =  new paymentScheduledWebServiceInterface.createSubscriptionResponse();
            paymentSubscriptionRetrieveResponse = PaymentService.CreateSubcriptionRetrieve(TokenRetrive);
            PaySubsWrapper=PaymentHelper.parseEncryptedWebServiceResponseRetrieve(PaySubsWrapper, paymentSubscriptionRetrieveResponse);
            
            PaySubsWrapper.BillingStreet = accountInfo[0].BillingStreet;
            PaySubsWrapper.BillingCity=accountInfo[0].BillingCity;
            PaySubsWrapper.BillingState= accountInfo[0].BillingState;
            PaySubsWrapper.BillingPostalCode= accountInfo[0].BillingPostalCode;
            PaySubsWrapper.BillingCountry= accountInfo[0].BillingCountry;
            
            system.debug('debug::PaySubsWrapper'+PaySubsWrapper);
            //maskedCCNumber='************' + PaySubsWrapper.ccNumber.subString(PaySubsWrapper.ccNumber.length()-4, PaySubsWrapper.ccNumber.length());
            system.debug('debug::masked CC Number =='+PaySubsWrapper.maskedCCNumber);
            maskedCCNumber=PaySubsWrapper.maskedCCNumber;
            system.debug('debug::TokenRetrive=='+TokenRetrive);
            isConfirmPayment = true;
        }
    }
    
    public void insertOppProds(List<Opportunity_Product_Cart> selectedProdCart)
    {
        System.debug('@Class : apc_hf_payment_Controller : insertOppProds');
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
            
            //System.debug(' oppLineItem UnitPrice: ' + oppLineItem.UnitPrice + ' Due date: ' + oppLineitem.Due_Date__c + 
            //             ' PricebookentryId: ' + oppLineitem.PricebookEntryId + ' oppId: ' + oppLineItem.Opportunity +
            //             ' Product Code' +  oppLineItem.productCode + ' payment method ' + oppLineItem.Payment_Method__c   +
            //             ' descripton' + oppLineItem.Description);
            listFinalOppProducts.Add(oppLineitem);
        }
        if(listFinalOppProducts != null && listFinalOppProducts.size() > 0)
            insert listFinalOppProducts;
    }
    
    public void closeChildOpp(Id opportunityId,Match__c tempConfMatch)
    {
        System.debug('@Class : apc_hf_payment_Controller : closeChildOpp');
        List<Opportunity> childOpp = [SELECT Id,Name,AccountId FROM Opportunity WHERE Id=:opportunityId 
                                      and StageName != 'Closed Won' LIMIT 1];
        if(childOpp!=null && childOpp.size()>0)
        {
            //set the intacct payment recordid to this
            System.debug('@class:apc_hf_payment_controller Inside closeChildOpp paymentRecordId ' + paymentRecordId);
            
            if(tempConfMatch!=null)
            {
                childOpp[0].Engagement_Start__c= tempConfMatch.start_date__c;
                childOpp[0].Engagement_end__c= tempConfMatch.end_date__c;
                childOpp[0].matched_pt_account__c = tempConfMatch.Participant_Id__r.name;            
            }
            
            childOpp[0].StageName = 'Closed Won';
            update childOpp[0];
            System.debug('child Opportunity closed successfully');
        }
    }
    
    /*public void sendExceptionEmail(Exception e)
    {
        //send an email to the user
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setSaveAsActivity(false);
            mail.setSubject('AuPairCare Match Finalization exception. Error form Org: ' + UserInfo.getOrganizationName());
    	    String[] toAddresses = new String[]{'pbandi@intraxinc.com','spillai@intraxinc.com','MThaduri@intraxinc.com','ZYang@intraxinc.com','HPanneerselvam@intraxinc.com'};
            mail.setToAddresses(toAddresses);
 			mail.setPlainTextBody('Exception while finalizing the Au pair care match. ' + '\r\n' +
                                  'Error from Org : ' + UserInfo.getOrganizationName() + '\r\n' +
                                  'Exception type caught: ' + e.getTypeName() + '\r\n' +
								  'Message: ' + e.getMessage() + '\r\n' +
                                  'Cause: ' + e.getCause() + '\r\n' +
                                  'Line number: ' + e.getLineNumber() + '\r\n' +
                                  'Stack trace: ' + e.getStackTraceString());
        
            emails.add(mail);
            
            try{    
                Messaging.sendEmail(emails);
            }catch(Exception ex)
            {
                System.debug('Failed to send email. Exception is ' + ex);
            }
    }*/
}