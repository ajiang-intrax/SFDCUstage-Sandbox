@isTest(seeAllData = true)
public class Test_apc_hf_payment_controller {
    
    static testMethod void apc_hf_payment_controller_tester() {
        
         User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
        System.runAs(sysAdmin){
                
            List<Person_Info__c> existingPersonInfoList = [Select p.Work_Supervisor__c, p.Work_Phone__c, p.Title__c, p.TimeZoneSidKey__c, p.Marital_Status__c,
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
                          LIMIT 1];
            
         List<product2> allProducts = new List<product2>();
        
         Pricebook2 standardPB = [select id from Pricebook2 where IsStandard = true limit 1];
        
        list<PricebookEntry> listStandardEntries = new List<PricebookEntry>();
        
        //First create a pricebook
        Pricebook2 ApcPriceBook2test = new Pricebook2 (name='APC USA1',Intrax_Programs__c= 'AuPairCare',
                                                       Description='Price book for APC HFs in USA',IsActive = true,
                                                       Price_Book_Code__c= 'APC USA1');
        insert ApcPriceBook2test;
        
        //Now insert application products and match products and match break products
        Product2 prod1 = new product2(name='Application Fee', family = 'Host Family',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Application',Description = 'Application Fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'application_fee', Refundable__c = false, 
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        
        allProducts.Add(prod1);
        
        Product2 prod2 = new product2(name='Waived application fee', family = 'Promo Codes',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Application',Description = 'Waived application fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = '', Refundable__c = false, 
                                      Promo_Code__c='MULTIPLES',CurrencyIsoCode='USD');
        allProducts.Add(Prod2);
        
        Product2 prod3 = new product2(name='Waived application fee', family = 'Promo Codes',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Application',Description = 'Waived application fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = '', Refundable__c = false,
                                      Promo_Code__c='UNITED',CurrencyIsoCode='USD');
        allProducts.Add(prod3);
        
        Product2 prod4 = new product2(name='Program fee - deposit payment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Program Fee For an OSAP Deposit Payment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_lumpsum_deposit', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod4);
        
        Product2 prod5 = new product2(name='Program fee - Balance amount', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Program fee - Balance amount', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_lumpsum_balance', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod5);
        
        
        Product2 prod6 = new product2(name='Payment plan deposit payment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'OSAP Program Fee Deposit Payment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_payment_plan_deposit', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod6);
        
        Product2 prod7 = new product2(name='Payment plan 1st installment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Payment plan 1st installment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_payment_plan_installment_1', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod7);
        
        
        Product2 prod8 = new product2(name='ICAP Program Fee', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'ICAP Program Fee', 
                                      IsActive = true,Fee_Type__c='Computable',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_icap_standard_program_fee', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod8);
        
        Product2 prod9 = new product2(name='Infant Specialized Fee', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Infant Specialized Fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'All',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_infant_specialization_fee', Refundable__c = false,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod9);
        
        Product2 prod10 = new product2(name='Payment plan fee 1st installment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Payment plan fee 1st installment', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_icap_payment_plan_fee_installment_1', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod10);
        
        Product2 prod11 = new product2(name='Program fee - 1st installment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Program fee - 1st installment', 
                                       IsActive = true,Fee_Type__c='Computable',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_icap_payment_plan_installment_1', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod11);
        
        Product2 prod12 = new product2(name='Program fee - down payment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Program fee - down payment', 
                                       IsActive = true,Fee_Type__c='Computable',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_icap_payment_plan_downpayment', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod12);
        
        Product2 prod13 = new product2(name='Academy Travel Service', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Domestic Air to Knoxville, TN', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'All',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= 'TYS',
                                       Product_Keyword__c = 'Travel', Refundable__c = false,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod13);
        
        Product2 prod14 = new product2(name='Waived Program Fee', family = 'Promo Codes',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Multiples Program Fee Discount', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'All',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_promo_codes', Refundable__c = true,
                                       Promo_Code__c='MULTIPLES',CurrencyIsoCode='USD');
        allProducts.Add(prod14);
        
        Product2 prod15 = new product2(name='Service credit', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match Break',Description = 'Match Break program fee service credit', 
                                       IsActive = true,Fee_Type__c='Computable',
                                       user_type__c = 'Host Family',Payment_Method__c = 'All',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_break_service_credit', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod15);
        
        Product2 prod16 = new product2(name='Insurance', family = 'Insurance',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='End of program',Description = 'Insurance', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Participant',Payment_Method__c = 'Standard',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'eop_insurance_fee', Refundable__c = false,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod16);
        
        
        Product2 prod17 = new product2(name='Late Fee', family = 'Travel',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='End of program',Description = 'Return Flight Late Fee', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Participant',Payment_Method__c = 'Standard',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'eop_return_flight_late_fee', Refundable__c = false,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod17);
        insert allProducts;
        System.debug('All products ' + allProducts);
        
        List<PriceBookEntry> pbe = new List<PriceBookEntry>();
        
        //Fetch the price book and attach the products
        Pricebook2 standardPB1 = [select id from Pricebook2 where id = :ApcPriceBook2test.Id limit 1];
        
        System.debug('standardPB1' + standardPB1);
        
        //Now create price book entries which is a like junction between products and price book
        for(product2 pd : allProducts)
        {
            //For Standard Pricebook
        listStandardEntries.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = pd.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        
            pbe.add(
                new PricebookEntry(Pricebook2Id = standardPB1.Id, Product2Id = pd.Id, 
                                   UnitPrice = 10000, IsActive = true, UseStandardPrice = false)
            );
        }
        System.debug('Before listStandardEntries ' + listStandardEntries);
        insert listStandardEntries;
        System.debug('after listStandardEntries ' + listStandardEntries);
        System.debug('Before pbe ' + pbe);
        insert pbe;
        System.debug('After pbe ' + pbe);
        
        
        //Now create the requried application,opportunity,match,engagement
        
       RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Account
        Account hostCompanyAccount  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert hostCompanyAccount;
        
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='AuPairCare PT' Limit 1];
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'apc@pt.com',
                                                    Legal_Residence__pc = 'Australia');
        insert participantAccount;
	                
        RecordType ptoppRecordType = [select id,Name from RecordType where SobjectType='Opportunity' and Name='AuPairCare PT' Limit 1];       
        Opportunity ptOpp = new Opportunity(
            Name = 'Test pt Opportunity', AccountId = participantAccount.Id, RecordTypeId = ptoppRecordType.Id, 
            Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = '');
        insert ptOpp;
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = participantAccount.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized', 
                                                        Intrax_Region__c = 'United States',Type__c = 'Participant', 
                                                        In_Country__c ='No',
                                                        Engagement_Start__c =System.today().addDays(60), Status__c = 'Prospecting',
                                                        Engagement_End__c =System.today().addDays(425));
        insert engagement;
       
        
        RecordType hfAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        
        Account hfAccount  = new Account(FirstName = 'Test', LastName = 'HF Account', Status__c = 'Prospect',
                                                    RecordTypeId = hfAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'apc@hf.com',
                                                    Legal_Residence__pc = 'Australia',BillingStreet = 'testtest');
        insert hfAccount;
        
        
        
        RecordType hfPositionRecordType = [select id, Name from RecordType where SobjectType='Position__c' and Name='AuPairCare HF' Limit 1];
       //Position
        Position__c hfposition = new Position__c(Name = 'Test Position', Intrax_Program__c = 'AuPairCare', 
                                                Intrax_Program_Options__c = 'Infant Specialized',
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today().addDays(60),
                                                Engagement_End__c = System.today().addDays(425),Country__c='United States',
                                                 Host_Company_Id__c = hostCompanyAccount.Id
                                                );
        insert hfposition;
        
        hfposition.Status__c = 'Matching';
        update hfposition;
        
       RecordType oppRecordType = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Host Family' Limit 1];       
        Opportunity hfParentOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match');
        insert hfParentOpp;
            
       //RecordType oppRecordType = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Host Family' Limit 1];       
        Opportunity hfMatchOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match', Parent_Opportunity__c=hfParentOpp.Id);
        insert hfMatchOpp;
                   
        Opportunity hfMatchBreakOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match Break',Parent_Opportunity__c=hfParentOpp.Id);
        insert hfMatchBreakOpp;
        
        RecordType matchRecordType = [select id,Name from RecordType where SobjectType='match__c' and Name='AuPairCare' Limit 1];       
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = hfposition.Id, Status__c = 'Requested', RecordTypeId = matchRecordType.Id, 
                                        Engagement__c = engagement.Id, Offer_Status__c = 'Accepted',Match_Type__c = 'Original',
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() +60),
                                        End_Date__c = (date.today() +425),Match_Date__c = date.today(),
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = ptOpp.Id,
                                         Host_Family_Child_Opportuniy__c = hfMatchOpp.id);
        insert match;
        RecordType HFApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='AuPairCare HF' Limit 1];
        
        Applicant_Info__c HFappInfo = new Applicant_Info__c(Name = 'test-apchf', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test', Opportunity_Name__c =hfParentOpp.Id,
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = HFApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Position__c = hfposition.Id,
                                                            	  account__c = hfAccount.id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'AuPairCare', 
                                                                  Intrax_Program_Options__c = 'YES',Intrax_region__c ='United States',
                                                                  PromoCode__c='MULTIPLES',CreatedBy__c = '00530000004VrPgAAK'
                                                                  );
        insert HFappInfo;
        
        Match__c ConfMatchList= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                            Engagement__r.Infant_Specialized_Indicated__c,
                            Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,
                            RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, 
                            Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,
                            Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                            Infant_Specialized_Training__c,Host_Family_Child_Opportuniy__c,match_type__c,Match_Period__c
                            from match__c 
                            where  id =:match.id limit 1];
        
            //ApexPages.currentPage().getParameters().put('Id',applicantInfo.Id);
            //ApexPages.currentPage().getParameters().put('mId',mainController.ConfMatch.Id);
            //ApexPages.currentPage().getParameters().put('oppId',mainController.ChildOpportunity.Id);
            ApexPages.currentPage().getParameters().put('documenttype','Sales Order');
            
        Test.startTest();
        Try
        {
			System.debug('Engagement ' + engagement);
            System.debug('match ' + match);
            System.debug('ConfMatchList ' + ConfMatchList);
            System.debug('HFappInfo ' + HFappInfo);
            System.debug('hfMatchOpp ' + hfMatchOpp);
            System.debug('hfMatchBreakOpp ' + hfMatchBreakOpp);
            
            apc_portal_controller apc= new apc_portal_controller();
            apc.ApplicantInfoList = new List<applicant_info__c>{HFappInfo};
                System.debug('app list : ' + apc.ApplicantInfoList);
                apc.ApplicantInfo = HFappInfo;
                apc.ChildOpportunity = hfMatchOpp;
            apc.getairportcode1();
            apc.getairportcode();
            apc.getairportscode();
            apc.getOpportunityProductCart();
            apc.selectedPlan ='Standard';
            apc.populateSelectedCartList();
            
            apc.selectedPlan ='PaymentPlan';
            apc.populateSelectedCartList();
            
            apc.isServiceCreditApplicable=true;
            apc.getOpportunityProductCart();
            apc.selectedPlan ='Standard';
            apc.populateSelectedCartList();
            
            apc.selectedPlan ='PaymentPlan';
            apc.populateSelectedCartList();
            
            apc.selected='SAN-San Diego - Lindberg Field International (CA)';
            APC.viewtransfercost();
            APC.ExtHours();
            Applicant_info__c app1=apc.applicant;
            Zip_Code__c zipAreaHF=apc.zipAreaHF;
            User_Profile__c ADUserProf=apc.ADUserProf;
            APC_Sales_Assignments__c MatchingExpert=apc.MatchingExpert;
            Applicant_Info__c appInfoHost=apc.appInfoHost;
            APC_Contact_Information__c BillingInfo=apc.BillingInfo;
            APC_Contact_Information__c InsuranceInfo=apc.InsuranceInfo;
            APC_Contact_Information__c HQInfo=apc.HQInfo;
            APC_Contact_Information__c EmergencyLine=apc.EmergencyLine;
            String photoADUrl=apc.photoADUrl;
            Applicant_Info__c applicantSearch=apc.applicantSearch;
            list<Match__c> MatchConf=apc.MatchConf;
            list<Match__c> MatchConfOld=apc.MatchConfOld;
            //apc.ViewSalesInvoice();
            //apc.SynchronizeSalesDocument();
            apc.chkBx=true;
            apc.click();
            apc.inCountrySkipPage();
            
            
            apc_hf_payment_controller ahpc = new apc_hf_payment_controller(apc);
            ahpc.init();
            ahpc.makeAWSPayment();
            ahpc.noPaymentRequired();
			ahpc.personInfoList = existingPersonInfoList;
			ahpc.personInfo = existingPersonInfoList[0];            
            ahpc.navigateToPaymentOptionsPage();
            ahpc.insertOppProds(apc.selectedOppProdCartList);
            ahpc.updateRecords();
            ahpc.closeChildOpp(apc.ChildOpportunity.id,apc.ConfMatch);
            ahpc.useCurrentBillingAddressInfo =false;
            ahpc.blankOutAddressDetailsOnPaymentPage();
            ahpc.navigateToPaymentNonEditPage();
            //Pricing_Controller pc=new Pricing_Controller();
            
            /*pc.getPriceBook('United States','AuPairCare');
            pc.getPricebookList('United States','Information Media & Communications','APC USA1','Fixed');
            pc.getPriceBook('United States','AuPairCare','All');
            pc.getAPCPricebookList('APC USA1','Host Family','Fixed','Application','MULTIPLES');
            pc.getAllAPCPricebookList('APC USA1','Host Family','Match');
            pc.applicantInfo= HFappInfo;
            pc.match= ConfMatchList;
            pc.opportunity=hfMatchOpp;
            pc.engagementObj=engagement;
            list<Opportunity_Product_Cart> opList = new list<Opportunity_Product_Cart>();
            opList= pc.getMatchOpportunityProducts('APC USA1','Host Family','Match');
            
            list<OpportunityLineItem> oLList = new list<OpportunityLineItem>();
            oLList = pc.getMatchBreakOpportunityProducts('APC USA1','Host Family', 'Match Break', hfMatchBreakOpp);
                
            if(olList!=null && olList.size()>0)
                pc.insertMatchOpporuntityProducts(olList,'Standard');*/
            
        }
        catch(Exception e){
            system.debug('***** '+e);
       }
        
        Test.stopTest();
        }
    }
    
        static testMethod void cc_payment_controller_tester() {
        
         User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
            
            //Run in user context
        System.runAs(sysAdmin){
                
            List<Person_Info__c> existingPersonInfoList = [Select p.Work_Supervisor__c, p.Work_Phone__c, p.Title__c, p.TimeZoneSidKey__c, p.Marital_Status__c,
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
                          LIMIT 1];
            
         List<product2> allProducts = new List<product2>();
        
         Pricebook2 standardPB = [select id from Pricebook2 where IsStandard = true limit 1];
        
        list<PricebookEntry> listStandardEntries = new List<PricebookEntry>();
        
        //First create a pricebook
        Pricebook2 ApcPriceBook2test = new Pricebook2 (name='APC USA1',Intrax_Programs__c= 'AuPairCare',
                                                       Description='Price book for APC HFs in USA',IsActive = true,
                                                       Price_Book_Code__c= 'APC USA1');
        insert ApcPriceBook2test;
        
        //Now insert application products and match products and match break products
        Product2 prod1 = new product2(name='Application Fee', family = 'Host Family',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Application',Description = 'Application Fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'application_fee', Refundable__c = false, 
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        
        allProducts.Add(prod1);
        
        Product2 prod2 = new product2(name='Waived application fee', family = 'Promo Codes',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Application',Description = 'Waived application fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = '', Refundable__c = false, 
                                      Promo_Code__c='MULTIPLES',CurrencyIsoCode='USD');
        allProducts.Add(Prod2);
        
        Product2 prod3 = new product2(name='Waived application fee', family = 'Promo Codes',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Application',Description = 'Waived application fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = '', Refundable__c = false,
                                      Promo_Code__c='UNITED',CurrencyIsoCode='USD');
        allProducts.Add(prod3);
        
        Product2 prod4 = new product2(name='Program fee - deposit payment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Program Fee For an OSAP Deposit Payment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_lumpsum_deposit', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod4);
        
        Product2 prod5 = new product2(name='Program fee - Balance amount', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Program fee - Balance amount', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_lumpsum_balance', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod5);
        
        
        Product2 prod6 = new product2(name='Payment plan deposit payment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'OSAP Program Fee Deposit Payment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_payment_plan_deposit', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod6);
        
        Product2 prod7 = new product2(name='Payment plan 1st installment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Payment plan 1st installment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_osap_payment_plan_installment_1', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod7);
        
        
        Product2 prod8 = new product2(name='ICAP Program Fee', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'ICAP Program Fee', 
                                      IsActive = true,Fee_Type__c='Computable',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Standard',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_icap_standard_program_fee', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod8);
        
        Product2 prod9 = new product2(name='Infant Specialized Fee', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Infant Specialized Fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'All',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'match_infant_specialization_fee', Refundable__c = false,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod9);
        
        Product2 prod10 = new product2(name='Payment plan fee 1st installment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Payment plan fee 1st installment', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_icap_payment_plan_fee_installment_1', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod10);
        
        Product2 prod11 = new product2(name='Program fee - 1st installment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Program fee - 1st installment', 
                                       IsActive = true,Fee_Type__c='Computable',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_icap_payment_plan_installment_1', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod11);
        
        Product2 prod12 = new product2(name='Program fee - down payment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Program fee - down payment', 
                                       IsActive = true,Fee_Type__c='Computable',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_icap_payment_plan_downpayment', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod12);
        
        Product2 prod13 = new product2(name='Academy Travel Service', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Domestic Air to Knoxville, TN', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'All',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= 'TYS',
                                       Product_Keyword__c = 'Travel', Refundable__c = false,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod13);
        
        Product2 prod14 = new product2(name='Waived Program Fee', family = 'Promo Codes',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'Multiples Program Fee Discount', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'All',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_promo_codes', Refundable__c = true,
                                       Promo_Code__c='MULTIPLES',CurrencyIsoCode='USD');
        allProducts.Add(prod14);
        
        Product2 prod15 = new product2(name='Service credit', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match Break',Description = 'Match Break program fee service credit', 
                                       IsActive = true,Fee_Type__c='Computable',
                                       user_type__c = 'Host Family',Payment_Method__c = 'All',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'match_break_service_credit', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod15);
        
        Product2 prod16 = new product2(name='Insurance', family = 'Insurance',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='End of program',Description = 'Insurance', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Participant',Payment_Method__c = 'Standard',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'eop_insurance_fee', Refundable__c = false,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod16);
        
        
        Product2 prod17 = new product2(name='Late Fee', family = 'Travel',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='End of program',Description = 'Return Flight Late Fee', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Participant',Payment_Method__c = 'Standard',
                                       Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                       Product_Keyword__c = 'eop_return_flight_late_fee', Refundable__c = false,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod17);
        insert allProducts;
        System.debug('All products ' + allProducts);
        
        List<PriceBookEntry> pbe = new List<PriceBookEntry>();
        
        //Fetch the price book and attach the products
        Pricebook2 standardPB1 = [select id from Pricebook2 where id = :ApcPriceBook2test.Id limit 1];
        
        System.debug('standardPB1' + standardPB1);
        
        //Now create price book entries which is a like junction between products and price book
        for(product2 pd : allProducts)
        {
            //For Standard Pricebook
        listStandardEntries.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = pd.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        
            pbe.add(
                new PricebookEntry(Pricebook2Id = standardPB1.Id, Product2Id = pd.Id, 
                                   UnitPrice = 10000, IsActive = true, UseStandardPrice = false)
            );
        }
        System.debug('Before listStandardEntries ' + listStandardEntries);
        insert listStandardEntries;
        System.debug('after listStandardEntries ' + listStandardEntries);
        System.debug('Before pbe ' + pbe);
        insert pbe;
        System.debug('After pbe ' + pbe);
        
        
        //Now create the requried application,opportunity,match,engagement
        
       RecordType hostCompanyRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='Host Company' Limit 1];
        
        //Account
        Account hostCompanyAccount  = new Account(Name = 'Host Company', RecordTypeId = hostCompanyRecordType.Id, Type = 'Host Company', 
                                        Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States');
        insert hostCompanyAccount;
        
        RecordType participantAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='AuPairCare PT' Limit 1];
        Account participantAccount  = new Account(FirstName = 'Test', LastName = 'Participant Account', Status__c = 'Prospect',
                                                    RecordTypeId = participantAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'apc@pt.com',
                                                    Legal_Residence__pc = 'Australia');
        insert participantAccount;
	                
        RecordType ptoppRecordType = [select id,Name from RecordType where SobjectType='Opportunity' and Name='AuPairCare PT' Limit 1];       
        Opportunity ptOpp = new Opportunity(
            Name = 'Test pt Opportunity', AccountId = participantAccount.Id, RecordTypeId = ptoppRecordType.Id, 
            Type='Participant', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = '');
        insert ptOpp;
        
        RecordType engagementRecordType = [select id,Name from RecordType where SobjectType='Engagement__c' and Name='AuPairCare PT' Limit 1];
        
        //Engagement
        Engagement__c engagement = new Engagement__c(Name='Test Engagement', 
                                                        Account_Id__c = participantAccount.Id, 
                                                        RecordTypeId = engagementRecordType.ID,
                                                        Intrax_Program__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized', 
                                                        Intrax_Region__c = 'United States',Type__c = 'Participant', 
                                                        In_Country__c ='No',
                                                        Engagement_Start__c =System.today().addDays(60), Status__c = 'Prospecting',
                                                        Engagement_End__c =System.today().addDays(425));
        insert engagement;
       
        
        RecordType hfAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        
        Account hfAccount  = new Account(FirstName = 'Test', LastName = 'HF Account', Status__c = 'Prospect',
                                                    RecordTypeId = hfAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'apc@hf.com',
                                                    Legal_Residence__pc = 'Australia',BillingStreet = 'testtest');
        insert hfAccount;
        
        
        
        RecordType hfPositionRecordType = [select id, Name from RecordType where SobjectType='Position__c' and Name='AuPairCare HF' Limit 1];
       //Position
        Position__c hfposition = new Position__c(Name = 'Test Position', Intrax_Program__c = 'AuPairCare', 
                                                Intrax_Program_Options__c = 'Infant Specialized',
                                                Intrax_Region__c = 'United States', Engagement_Start__c = System.today().addDays(60),
                                                Engagement_End__c = System.today().addDays(425),Country__c='United States',
                                                 Host_Company_Id__c = hostCompanyAccount.Id
                                                );
        insert hfposition;
        
        hfposition.Status__c = 'Matching';
        update hfposition;
        
       RecordType oppRecordType = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Host Family' Limit 1];       
        Opportunity hfParentOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match');
        insert hfParentOpp;
            
       //RecordType oppRecordType = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Host Family' Limit 1];       
        Opportunity hfMatchOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match', Parent_Opportunity__c=hfParentOpp.Id);
        insert hfMatchOpp;
                   
        Opportunity hfMatchBreakOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match Break',Parent_Opportunity__c=hfParentOpp.Id);
        insert hfMatchBreakOpp;
        
        RecordType matchRecordType = [select id,Name from RecordType where SobjectType='match__c' and Name='AuPairCare' Limit 1];       
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = hfposition.Id, Status__c = 'Requested', RecordTypeId = matchRecordType.Id, 
                                        Engagement__c = engagement.Id, Offer_Status__c = 'Accepted',Match_Type__c = 'Original',
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() +60),
                                        End_Date__c = (date.today() +425),Match_Date__c = date.today(),
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = ptOpp.Id,
                                         Host_Family_Child_Opportuniy__c = hfMatchOpp.id);
        insert match;
        RecordType HFApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='AuPairCare HF' Limit 1];
        
        Applicant_Info__c HFappInfo = new Applicant_Info__c(Name = 'test-apchf', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test', Opportunity_Name__c =hfParentOpp.Id,
                                                                  Application_Stage__c = 'Accepted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = HFApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Position__c = hfposition.Id,
                                                            	  account__c = hfAccount.id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'AuPairCare', 
                                                                  Intrax_Program_Options__c = 'YES',Intrax_region__c ='United States',
                                                                  PromoCode__c='MULTIPLES',CreatedBy__c = '00530000004VrPgAAK'
                                                                  );
        insert HFappInfo;
        
        Match__c ConfMatchList= [select id, Status__c, Airport_code__c, Engagement__r.In_Country__c,
                            Engagement__r.Infant_Specialized_Indicated__c,
                            Match_Date__c, Position_Name__c, Start_Date__c, end_date__c,
                            RecordType.Name, Engagement__r.Gender__c, Participant_Id__r.Name, Offer_Status__c, 
                            Engagement__r.Engagement_Start__c, Engagement__r.Engagement_end__c,
                            Engagement__c, Engagement__r.Under_2_Total_Hours__c, Participant_Id__r.Legal_Residence__pc,
                            Infant_Specialized_Training__c,Host_Family_Child_Opportuniy__c,match_type__c,Match_Period__c
                            from match__c 
                            where  id =:match.id limit 1];
        
            //ApexPages.currentPage().getParameters().put('Id',applicantInfo.Id);
            //ApexPages.currentPage().getParameters().put('mId',mainController.ConfMatch.Id);
            //ApexPages.currentPage().getParameters().put('oppId',mainController.ChildOpportunity.Id);
            ApexPages.currentPage().getParameters().put('documenttype','Sales Order');
            
        Test.startTest();
        Try
        {
			System.debug('Engagement ' + engagement);
            System.debug('match ' + match);
            System.debug('ConfMatchList ' + ConfMatchList);
            System.debug('HFappInfo ' + HFappInfo);
            System.debug('hfMatchOpp ' + hfMatchOpp);
            System.debug('hfMatchBreakOpp ' + hfMatchBreakOpp);
            
            cc_payment_controller cc= new cc_payment_controller();
            cc.ApplicantInfoList = new List<applicant_info__c>{HFappInfo};
                System.debug('app list : ' + cc.ApplicantInfoList);
                cc.ApplicantInfo = HFappInfo;
                cc.childApplicationOpportunity = hfMatchOpp;
            
                        
            //apc_hf_payment_controller ahpc = new apc_hf_payment_controller(apc);
            //ahpc.init();
            cc.makeAWSPayment();
            //cc.noPaymentRequired();
			cc.personInfoList = existingPersonInfoList;
			cc.personInfo = existingPersonInfoList[0];            
            //cc.navigateToPaymentOptionsPage();
            //ahpc.insertOppProds(apc.selectedOppProdCartList);
            //ahpc.updateRecords();
            //ahpc.closeChildOpp(apc.ChildOpportunity.id,apc.ConfMatch);
            cc.useCurrentBillingAddressInfo =false;
            cc.blankOutAddressDetailsOnPaymentPage();
            //cc.navigateToPaymentNonEditPage();
            //Pricing_Controller pc=new Pricing_Controller();
            
            /*pc.getPriceBook('United States','AuPairCare');
            pc.getPricebookList('United States','Information Media & Communications','APC USA1','Fixed');
            pc.getPriceBook('United States','AuPairCare','All');
            pc.getAPCPricebookList('APC USA1','Host Family','Fixed','Application','MULTIPLES');
            pc.getAllAPCPricebookList('APC USA1','Host Family','Match');
            pc.applicantInfo= HFappInfo;
            pc.match= ConfMatchList;
            pc.opportunity=hfMatchOpp;
            pc.engagementObj=engagement;
            list<Opportunity_Product_Cart> opList = new list<Opportunity_Product_Cart>();
            opList= pc.getMatchOpportunityProducts('APC USA1','Host Family','Match');
            
            list<OpportunityLineItem> oLList = new list<OpportunityLineItem>();
            oLList = pc.getMatchBreakOpportunityProducts('APC USA1','Host Family', 'Match Break', hfMatchBreakOpp);
                
            if(olList!=null && olList.size()>0)
                pc.insertMatchOpporuntityProducts(olList,'Standard');*/
            
        }
        catch(Exception e){
            system.debug('***** '+e);
       }
        
        Test.stopTest();
        }

}
}