/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest(seeAllData = true)
private class Test_Pricing_Controller {
    
    
    static testMethod void PricingPublisherTester() {
        // TO DO: implement unit test
        
        List<PriceBookEntry> couponCodes = new List<PriceBookEntry>();
        //List<PriceBookEntry> standartFeeApc = new List<PriceBookEntry>();
        
        Pricebook2 standardPB = [select id from Pricebook2 where IsStandard = true limit 1];
        
        Product2 prod1 = new product2(name='Application Fee', family = 'Host Family',Intrax_Program__c= 'AupairCare',ChildOppType__c='Application',Description = 'Application Fee', IsActive = true,Fee_Type__c='Fixed');
        insert prod1;
        Product2 prod2 = new product2(name='Waived application fee',family = 'Promo codes',Intrax_Program__c= 'AupairCare',ChildOppType__c='Application', Description = 'Waived application fee', IsActive = true,Fee_Type__c='Fixed',Promo_Code__c = 'APCFAMILY');
        insert prod2;
        
        //For Standard Pricebook
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice2;
        
        //For Custom Pricebook
        Pricebook2 ApcPriceBook2test = new Pricebook2 (name='APC USA HF',Intrax_Programs__c= 'AupairCare',Description='Price book for APC HFs in USA',IsActive = true,Price_Book_Code__c= 'APC USA');
        insert ApcPriceBook2test;
        
        PricebookEntry customPbEntry1 = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false, Pricebook2Id = ApcPriceBook2test.ID);
        insert customPbEntry1;
        PricebookEntry customPbEntry2 = new PricebookEntry(Product2Id = prod2.Id, UnitPrice = -50, IsActive = true, UseStandardPrice = false, Pricebook2Id = ApcPriceBook2test.ID);
        //insert customPbEntry2;
        
        couponCodes.add(customPbEntry2);
        insert couponCodes;
        Pricing_Info_Wrapper PricingInfoWrapper= new Pricing_Info_Wrapper(couponCodes);
        Test.startTest();
        Pricing_Publisher.getPricebookDetail('ALL','ALL','Fixed','Information Media & Communications','AupairCare');
        Pricing_Publisher.getAPCPricebookDetail('United States','ALL','Fixed','AupairCare','Application');
        Pricing_Publisher.getAPCDiscountedPb('United States','ALL','Fixed','AupairCare','Application','MULTIPLE');
        Pricing_Publisher.getAPCDiscountedPb('United States','ALL','Fixed','AupairCare','Application','');
        Test.stopTest();
        //Pricing_Publisher.getDiscountPrice('APC USA','ALL', 'Application','MULTIPLE');
        try{
        }
        catch(Exception e){
            system.debug('***** '+e);
        }
    }
    
    static testMethod void PricingControllerTester() {
       
        
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
                                                    Legal_Residence__pc = 'Australia');
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
        Opportunity hfMatchOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match');
        insert hfMatchOpp;
                   
        Opportunity hfMatchBreakOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match Break');
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
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = HFApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Position__c = hfposition.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'AuPairCare', 
                                                                  Intrax_Program_Options__c = 'YES',Intrax_region__c ='United States',
                                                                  PromoCode__c='MULTIPLES'
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
        
        Test.startTest();
        Try
        {
            Pricing_Controller pc=new Pricing_Controller();
            System.debug('Engagement ' + engagement);
            System.debug('match ' + match);
            System.debug('ConfMatchList ' + ConfMatchList);
            System.debug('HFappInfo ' + HFappInfo);
            System.debug('hfMatchOpp ' + hfMatchOpp);
            System.debug('hfMatchBreakOpp ' + hfMatchBreakOpp);
            pc.getPriceBook('United States','AuPairCare');
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
                pc.insertMatchOpporuntityProducts(olList,'Standard');
        }
        catch(Exception e){
            system.debug('***** '+e);
        }
        
        Test.stopTest();
        
        
    }
    
    static testmethod void PricingControllerTester2()
    {
        
        
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
                                                        In_Country__c ='Yes',
                                                        Engagement_Start__c =System.today().addDays(60), Status__c = 'Prospecting',
                                                        Engagement_End__c =System.today().addDays(425));
        insert engagement;
       
        
        RecordType hfAccountRecordType = [select id, Name from RecordType where SobjectType='Account' and Name='AuPairCare HF' Limit 1];
        
        Account hfAccount  = new Account(FirstName = 'Test', LastName = 'HF Account', Status__c = 'Prospect',
                                                    RecordTypeId = hfAccountRecordType.Id, Type = 'Participant',
                                                    Intrax_Programs__c = 'AuPairCare', Intrax_Program_Options__c = 'Infant Specialized', 
                                                    Intrax_Region__c = 'United States', PersonEmail = 'apc@hf.com',
                                                    Legal_Residence__pc = 'Australia');
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
        Opportunity hfMatchOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match');
        insert hfMatchOpp;
                   
        Opportunity hfMatchBreakOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match Break');
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
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = HFApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Position__c = hfposition.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'AuPairCare', 
                                                                  Intrax_Program_Options__c = 'YES',Intrax_region__c ='United States',
                                                                  PromoCode__c='MULTIPLES'
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
        
        Test.startTest();
        Try
        {
            System.debug('Before test2');
            Pricing_Controller pc1=new Pricing_Controller();
            pc1.applicantInfo= HFappInfo;
            pc1.match= ConfMatchList;
            pc1.opportunity=hfMatchOpp;
            pc1.engagementObj=engagement;
            
            System.debug('Engagement ' + engagement);
            System.debug('match ' + match);
            System.debug('ConfMatchList ' + ConfMatchList);
            System.debug('HFappInfo ' + HFappInfo);
            System.debug('hfMatchOpp ' + hfMatchOpp);
            System.debug('hfMatchBreakOpp ' + hfMatchBreakOpp);
            list<Opportunity_Product_Cart> opList = new list<Opportunity_Product_Cart>();
            opList= pc1.getMatchOpportunityProducts('APC USA1','Host Family','Match');
            
            List<PriceBookEntry> pbeLst = pc1.getAPCTravelService('APC USA1','Host Family','Match', 'TYS');
            if(pbeLst!=null && pbeLst.size()>0)
            {
               pc1.conditionalityCheck2(pbeLst[0]);
               pc1.computePrice1(pbeLst[0]);
               pc1.computePrice2(pbeLst[0]);
               pc1.computePrice3(pbeLst[0]);
               pc1.computePrice4(pbeLst[0]);
               pc1.computePrice5(pbeLst[0]);
               pc1.computePrice6(pbeLst[0]);
               pc1.computePrice7(pbeLst[0]);
               pc1.computePrice8(pbeLst[0]);
               pc1.computePrice9(pbeLst[0]);
               pc1.computePrice10(pbeLst[0]);
               pc1.computePrice11(pbeLst[0]);
               pc1.computePrice12(pbeLst[0]);
               pc1.computePrice13(pbeLst[0]);
               pc1.computePrice14(pbeLst[0]);
               pc1.computePrice15(pbeLst[0]);
               pc1.computePrice16(pbeLst[0]);
               pc1.computePrice17(pbeLst[0]);
               pc1.computePrice18(pbeLst[0]);
               pc1.computePrice19(pbeLst[0]);
               pc1.computePrice20(pbeLst[0]);
               pc1.computePrice21(pbeLst[0]);
               pc1.computePrice22(pbeLst[0]);
               pc1.computePrice23(pbeLst[0]);
               pc1.computePrice24(pbeLst[0]);
               pc1.computePrice25(pbeLst[0]);
               pc1.computePrice26(pbeLst[0]);
               pc1.computePrice27(pbeLst[0]);
               pc1.computePrice28(pbeLst[0]);
               pc1.computePrice29(pbeLst[0]);
               pc1.computePrice30(pbeLst[0]);
               pc1.computePrice31(pbeLst[0]);
               pc1.computePrice32(pbeLst[0]);
               pc1.computePrice33(pbeLst[0]);
               pc1.computePrice34(pbeLst[0]);
               pc1.computePrice35(pbeLst[0]);
               pc1.computePrice36(pbeLst[0]);
               pc1.computePrice37(pbeLst[0]);
               pc1.computePrice38(pbeLst[0]);
               pc1.computePrice39(pbeLst[0]);
               
                pc1.computeDueDate1(pbeLst[0]);
               pc1.computeDueDate2(pbeLst[0]);
               pc1.computeDueDate3(pbeLst[0]);
               pc1.computeDueDate4(pbeLst[0]);
               pc1.computeDueDate5(pbeLst[0]);
               pc1.computeDueDate6(pbeLst[0]);
               pc1.computeDueDate7(pbeLst[0]);
               pc1.computeDueDate8(pbeLst[0]);
               pc1.computeDueDate9(pbeLst[0]);
               pc1.computeDueDate10(pbeLst[0]);
               pc1.computeDueDate11(pbeLst[0]);
               pc1.computeDueDate12(pbeLst[0]);
               pc1.computeDueDate13(pbeLst[0]);
               pc1.computeDueDate14(pbeLst[0]);
               pc1.computeDueDate15(pbeLst[0]);
               pc1.computeDueDate16(pbeLst[0]);
               pc1.computeDueDate17(pbeLst[0]);
               pc1.computeDueDate18(pbeLst[0]);
               pc1.computeDueDate19(pbeLst[0]);
               pc1.computeDueDate20(pbeLst[0]);
               pc1.computeDueDate21(pbeLst[0]);
               pc1.computeDueDate22(pbeLst[0]);
               pc1.computeDueDate23(pbeLst[0]);
               pc1.computeDueDate24(pbeLst[0]);
               pc1.computeDueDate25(pbeLst[0]);
               pc1.computeDueDate26(pbeLst[0]);
               pc1.computeDueDate27(pbeLst[0]);
               pc1.computeDueDate28(pbeLst[0]);
               pc1.computeDueDate29(pbeLst[0]);
               pc1.computeDueDate30(pbeLst[0]);
               pc1.computeDueDate31(pbeLst[0]);
               pc1.computeDueDate32(pbeLst[0]);
               pc1.computeDueDate33(pbeLst[0]);
               pc1.computeDueDate34(pbeLst[0]);
               pc1.computeDueDate35(pbeLst[0]);
               pc1.computeDueDate36(pbeLst[0]);
               pc1.computeDueDate37(pbeLst[0]);
            }
            pbeLst = pc1.getAPCPBEFromKeyword('APC USA1','Host Family','Match', 'match_icap_payment_plan_installment_1');
            if(pbeLst!=null && pbeLst.size()>0)
            {
               pc1.conditionalityCheck2(pbeLst[0]);
               pc1.computePrice1(pbeLst[0]);
               pc1.computePrice2(pbeLst[0]);
               pc1.computePrice3(pbeLst[0]);
               pc1.computePrice4(pbeLst[0]);
               pc1.computePrice5(pbeLst[0]);
               pc1.computePrice6(pbeLst[0]);
               pc1.computePrice7(pbeLst[0]);
               pc1.computePrice8(pbeLst[0]);
               pc1.computePrice9(pbeLst[0]);
               pc1.computePrice10(pbeLst[0]);
               pc1.computePrice11(pbeLst[0]);
               pc1.computePrice12(pbeLst[0]);
               pc1.computePrice13(pbeLst[0]);
               pc1.computePrice14(pbeLst[0]);
               pc1.computePrice15(pbeLst[0]);
               pc1.computePrice16(pbeLst[0]);
               pc1.computePrice17(pbeLst[0]);
               pc1.computePrice18(pbeLst[0]);
               pc1.computePrice19(pbeLst[0]);
               pc1.computePrice20(pbeLst[0]);
               pc1.computePrice21(pbeLst[0]);
               pc1.computePrice22(pbeLst[0]);
               pc1.computePrice23(pbeLst[0]);
               pc1.computePrice24(pbeLst[0]);
               pc1.computePrice25(pbeLst[0]);
               pc1.computePrice26(pbeLst[0]);
               pc1.computePrice27(pbeLst[0]);
               pc1.computePrice28(pbeLst[0]);
               pc1.computePrice29(pbeLst[0]);
               pc1.computePrice30(pbeLst[0]);
               pc1.computePrice31(pbeLst[0]);
               pc1.computePrice32(pbeLst[0]);
               pc1.computePrice33(pbeLst[0]);
               pc1.computePrice34(pbeLst[0]);
               pc1.computePrice35(pbeLst[0]);
               
               pc1.computeDueDate1(pbeLst[0]);
               pc1.computeDueDate2(pbeLst[0]);
               pc1.computeDueDate3(pbeLst[0]);
               pc1.computeDueDate4(pbeLst[0]);
               pc1.computeDueDate5(pbeLst[0]);
               pc1.computeDueDate6(pbeLst[0]);
               pc1.computeDueDate7(pbeLst[0]);
               pc1.computeDueDate8(pbeLst[0]);
               pc1.computeDueDate9(pbeLst[0]);
               pc1.computeDueDate10(pbeLst[0]);
               pc1.computeDueDate11(pbeLst[0]);
               pc1.computeDueDate12(pbeLst[0]);
               pc1.computeDueDate13(pbeLst[0]);
               pc1.computeDueDate14(pbeLst[0]);
               pc1.computeDueDate15(pbeLst[0]);
               pc1.computeDueDate16(pbeLst[0]);
               pc1.computeDueDate17(pbeLst[0]);
               pc1.computeDueDate18(pbeLst[0]);
               pc1.computeDueDate19(pbeLst[0]);
               pc1.computeDueDate20(pbeLst[0]);
               pc1.computeDueDate21(pbeLst[0]);
               pc1.computeDueDate22(pbeLst[0]);
               pc1.computeDueDate23(pbeLst[0]);
               pc1.computeDueDate24(pbeLst[0]);
               pc1.computeDueDate25(pbeLst[0]);
               pc1.computeDueDate26(pbeLst[0]);
               pc1.computeDueDate27(pbeLst[0]);
               pc1.computeDueDate28(pbeLst[0]);
               pc1.computeDueDate29(pbeLst[0]);
               pc1.computeDueDate30(pbeLst[0]);
               pc1.computeDueDate31(pbeLst[0]);
               pc1.computeDueDate32(pbeLst[0]);
               pc1.computeDueDate33(pbeLst[0]);
               pc1.computeDueDate34(pbeLst[0]);
               pc1.computeDueDate35(pbeLst[0]);
               pc1.computeDueDate36(pbeLst[0]);
               pc1.computeDueDate37(pbeLst[0]);
                pc1.computeDueDate38(pbeLst[0]);
                pc1.computeDueDate39(pbeLst[0]);
                pc1.computeDueDate40(pbeLst[0]);
                pc1.computeDueDate41(pbeLst[0]);
                pc1.computeDueDate42(pbeLst[0]);
                pc1.computeDueDate43(pbeLst[0]);
                pc1.computeDueDate44(pbeLst[0]);
                pc1.computeDueDate45(pbeLst[0]);
                pc1.computeDueDate46(pbeLst[0]);
                pc1.computeDueDate47(pbeLst[0]);
            }
            
        }
        catch(Exception e){
            system.debug('***** '+e);
        }
        
        Test.stopTest();
        
    }
    
    static testmethod void PricingControllerExtensionAppTester()
    {
        
        
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
        
        Product2 prod4 = new product2(name='extension_DOS_fee', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'Program Fee For an OSAP Deposit Payment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'All',
                                      Due_Date_Type__c = 'Invdate', Airport_Code__c= '',
                                      Product_Keyword__c = 'extension_DOS_fee', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod4);
        
        Product2 prod5 = new product2(name='extension_12months_program_fee', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'extension_12months_program_fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'All',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'extension_12months_program_fee', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod5);
        
        
        Product2 prod6 = new product2(name='extension_payment_plan_dowpayment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'extension_payment_plan_dowpayment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'extension_payment_plan_dowpayment', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod6);
        
        Product2 prod7 = new product2(name='extension_payment_plan_fee_downpayment', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'extension_payment_plan_fee_downpayment', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'extension_payment_plan_fee_downpayment', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod7);
        
        
        Product2 prod8 = new product2(name='extension_payment_plan_installment_1', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'ICAP Program Fee', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'extension_payment_plan_installment_1', Refundable__c = true,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod8);
        
        Product2 prod9 = new product2(name='extension_payment_plan_installment_2', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                      ChildOppType__c='Match',Description = 'extension_payment_plan_installment_2', 
                                      IsActive = true,Fee_Type__c='Fixed',
                                      user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                      Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                      Product_Keyword__c = 'extension_payment_plan_installment_2', Refundable__c = false,
                                      Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod9);
        
        Product2 prod10 = new product2(name='extension_payment_plan_fee_installment_2', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'extension_payment_plan_fee_installment_2', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'extension_payment_plan_fee_installment_2', Refundable__c = true,
                                       Promo_Code__c='',CurrencyIsoCode='USD');
        allProducts.Add(prod10);
        
        Product2 prod11 = new product2(name='extension_payment_plan_fee_installment_2', family = 'Program Fees',Intrax_Program__c= 'AuPairCare',
                                       ChildOppType__c='Match',Description = 'extension_payment_plan_fee_installment_2', 
                                       IsActive = true,Fee_Type__c='Fixed',
                                       user_type__c = 'Host Family',Payment_Method__c = 'Installment',
                                       Due_Date_Type__c = 'Computable', Airport_Code__c= '',
                                       Product_Keyword__c = 'extension_payment_plan_fee_installment_2', Refundable__c = true,
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
                                                    Legal_Residence__pc = 'Australia');
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
        Opportunity hfMatchOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match');
        insert hfMatchOpp;
                   
        Opportunity hfMatchBreakOpp = new Opportunity(
            Name = 'Test HF Opportunity', AccountId = hfAccount.Id, RecordTypeId = oppRecordType.Id, 
            Type='Host Family', Intrax_Programs__c = 'AuPairCare', Intrax_Region__c = 'United States', 
            closeDate = date.today(), StageName = 'Prospecting', childOppType__c = 'Match Break');
        insert hfMatchBreakOpp;
        
        RecordType matchRecordType = [select id,Name from RecordType where SobjectType='match__c' and Name='AuPairCare' Limit 1];       
        //Match
        Match__c match = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = hfposition.Id, Status__c = 'Requested', RecordTypeId = matchRecordType.Id, 
                                        Engagement__c = engagement.Id, Offer_Status__c = 'Accepted',Match_Type__c = 'Extension',
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() +60),
                                        End_Date__c = (date.today() +425),Match_Date__c = date.today(),
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = ptOpp.Id,
                                         Host_Family_Child_Opportuniy__c = hfMatchOpp.id);
        insert match;
        
        Match__c lastConfmatch = new Match__c(Name = 'Test Match', 
                                        Position_Name__c = hfposition.Id, Status__c = 'Confirmed', RecordTypeId = matchRecordType.Id, 
                                        Engagement__c = engagement.Id, Offer_Status__c = 'Accepted',Match_Type__c = 'Original',
                                        Participant_Id__c = participantAccount.Id,start_date__c=(date.today() -366),
                                        End_Date__c = (date.today() -1),Match_Date__c = (date.today() -366),
                                        Interview_Status__c = 'Scheduled', Participant_Opportunity_Id__c = ptOpp.Id,
                                         Host_Family_Child_Opportuniy__c = hfMatchOpp.id);
        insert lastConfmatch;
        
        RecordType HFApplicationRecordType = [select id, Name from RecordType where SobjectType='Applicant_Info__c' AND Name='AuPairCare HF' Limit 1];
        
        Applicant_Info__c HFappInfo = new Applicant_Info__c(Name = 'test-apchf', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  //Partner_Intrax_Id__c = users[0].Intrax_Id__c, 
                                                                  Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = HFApplicationRecordType.Id, 
                                                                  Special_Diet_Indicated__c = 'No', Position__c = hfposition.Id,
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                                  Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                                  Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'AuPairCare', 
                                                                  Intrax_Program_Options__c = 'YES',Intrax_region__c ='United States',
                                                                  PromoCode__c='MULTIPLES',Application_type__c = 'Extension',extension_length__c='12'
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
        
        Test.startTest();
        Try
        {
            System.debug('Before test2');
            Pricing_Controller pc1=new Pricing_Controller();
            pc1.applicantInfo= HFappInfo;
            pc1.match= ConfMatchList;
            pc1.opportunity=hfMatchOpp;
            pc1.engagementObj=engagement;
            pc1.lastConfMatch=lastConfMatch;
            System.debug('Engagement ' + engagement);
            System.debug('match ' + match);
            System.debug('ConfMatchList ' + ConfMatchList);
            System.debug('HFappInfo ' + HFappInfo);
            System.debug('hfMatchOpp ' + hfMatchOpp);
            System.debug('hfMatchBreakOpp ' + hfMatchBreakOpp);
            System.debug('lastConfMatch ' + lastConfMatch);
            
            list<Opportunity_Product_Cart> opList = new list<Opportunity_Product_Cart>();
            opList= pc1.getMatchOpportunityProducts('APC USA1','Host Family','Match');
            
            //list<OpportunityLineItem> oLList = new list<OpportunityLineItem>();
            //oLList = pc1.getMatchBreakOpportunityProducts('APC USA1','Host Family', 'Match Break', hfMatchBreakOpp);
                
            //if(opList!=null && opList.size()>0)
              //  pc1.insertMatchOpporuntityProducts(opList,'Standard');
            
            
            /*list<Opportunity_Product_Cart> opList = new list<Opportunity_Product_Cart>();
            opList= pc1.getMatchOpportunityProducts('APC USA1','Host Family','Match');
            
            List<PriceBookEntry> pbeLst = pc1.getAPCTravelService('APC USA1','Host Family','Match', 'TYS');
            if(pbeLst!=null && pbeLst.size()>0)
            {
               pc1.conditionalityCheck2(pbeLst[0]);
               pc1.computePrice1(pbeLst[0]);
               pc1.computePrice2(pbeLst[0]);
               pc1.computePrice3(pbeLst[0]);
               pc1.computePrice4(pbeLst[0]);
               pc1.computePrice5(pbeLst[0]);
               pc1.computePrice6(pbeLst[0]);
               pc1.computePrice7(pbeLst[0]);
               pc1.computePrice8(pbeLst[0]);
               pc1.computePrice9(pbeLst[0]);
               pc1.computePrice10(pbeLst[0]);
               pc1.computePrice11(pbeLst[0]);
               pc1.computePrice12(pbeLst[0]);
               pc1.computePrice13(pbeLst[0]);
               pc1.computePrice14(pbeLst[0]);
               pc1.computePrice15(pbeLst[0]);
               pc1.computePrice16(pbeLst[0]);
               pc1.computePrice17(pbeLst[0]);
               pc1.computePrice18(pbeLst[0]);
               pc1.computePrice19(pbeLst[0]);
               pc1.computePrice20(pbeLst[0]);
               pc1.computePrice21(pbeLst[0]);
               pc1.computePrice22(pbeLst[0]);
               pc1.computePrice23(pbeLst[0]);
               pc1.computePrice24(pbeLst[0]);
               pc1.computePrice25(pbeLst[0]);
               pc1.computePrice26(pbeLst[0]);
               pc1.computePrice27(pbeLst[0]);
               pc1.computePrice28(pbeLst[0]);
               pc1.computePrice29(pbeLst[0]);
               pc1.computePrice30(pbeLst[0]);
               pc1.computePrice31(pbeLst[0]);
               pc1.computePrice32(pbeLst[0]);
               pc1.computePrice33(pbeLst[0]);
               pc1.computePrice34(pbeLst[0]);
               pc1.computePrice35(pbeLst[0]);
               
               pc1.computeDueDate1(pbeLst[0]);
               pc1.computeDueDate2(pbeLst[0]);
               pc1.computeDueDate3(pbeLst[0]);
               pc1.computeDueDate4(pbeLst[0]);
               pc1.computeDueDate5(pbeLst[0]);
               pc1.computeDueDate6(pbeLst[0]);
               pc1.computeDueDate7(pbeLst[0]);
               pc1.computeDueDate8(pbeLst[0]);
               pc1.computeDueDate9(pbeLst[0]);
               pc1.computeDueDate10(pbeLst[0]);
               pc1.computeDueDate11(pbeLst[0]);
               pc1.computeDueDate12(pbeLst[0]);
               pc1.computeDueDate13(pbeLst[0]);
               pc1.computeDueDate14(pbeLst[0]);
               pc1.computeDueDate15(pbeLst[0]);
               pc1.computeDueDate16(pbeLst[0]);
               pc1.computeDueDate17(pbeLst[0]);
               pc1.computeDueDate18(pbeLst[0]);
               pc1.computeDueDate19(pbeLst[0]);
               pc1.computeDueDate20(pbeLst[0]);
               pc1.computeDueDate21(pbeLst[0]);
               pc1.computeDueDate22(pbeLst[0]);
               pc1.computeDueDate23(pbeLst[0]);
               pc1.computeDueDate24(pbeLst[0]);
               pc1.computeDueDate25(pbeLst[0]);
               pc1.computeDueDate26(pbeLst[0]);
               pc1.computeDueDate27(pbeLst[0]);
               pc1.computeDueDate28(pbeLst[0]);
               pc1.computeDueDate29(pbeLst[0]);
               pc1.computeDueDate30(pbeLst[0]);
               pc1.computeDueDate31(pbeLst[0]);
               pc1.computeDueDate32(pbeLst[0]);
               pc1.computeDueDate33(pbeLst[0]);
               pc1.computeDueDate34(pbeLst[0]);
               pc1.computeDueDate35(pbeLst[0]);
               pc1.computeDueDate36(pbeLst[0]);
               pc1.computeDueDate37(pbeLst[0]);
            }
            pbeLst = pc1.getAPCPBEFromKeyword('APC USA1','Host Family','Match', 'match_icap_payment_plan_installment_1');
            if(pbeLst!=null && pbeLst.size()>0)
            {
               pc1.conditionalityCheck2(pbeLst[0]);
               pc1.computePrice1(pbeLst[0]);
               pc1.computePrice2(pbeLst[0]);
               pc1.computePrice3(pbeLst[0]);
               pc1.computePrice4(pbeLst[0]);
               pc1.computePrice5(pbeLst[0]);
               pc1.computePrice6(pbeLst[0]);
               pc1.computePrice7(pbeLst[0]);
               pc1.computePrice8(pbeLst[0]);
               pc1.computePrice9(pbeLst[0]);
               pc1.computePrice10(pbeLst[0]);
               pc1.computePrice11(pbeLst[0]);
               pc1.computePrice12(pbeLst[0]);
               pc1.computePrice13(pbeLst[0]);
               pc1.computePrice14(pbeLst[0]);
               pc1.computePrice15(pbeLst[0]);
               pc1.computePrice16(pbeLst[0]);
               pc1.computePrice17(pbeLst[0]);
               pc1.computePrice18(pbeLst[0]);
               pc1.computePrice19(pbeLst[0]);
               pc1.computePrice20(pbeLst[0]);
               pc1.computePrice21(pbeLst[0]);
               pc1.computePrice22(pbeLst[0]);
               pc1.computePrice23(pbeLst[0]);
               pc1.computePrice24(pbeLst[0]);
               pc1.computePrice25(pbeLst[0]);
               pc1.computePrice26(pbeLst[0]);
               pc1.computePrice27(pbeLst[0]);
               pc1.computePrice28(pbeLst[0]);
               pc1.computePrice29(pbeLst[0]);
               pc1.computePrice30(pbeLst[0]);
               pc1.computePrice31(pbeLst[0]);
               pc1.computePrice32(pbeLst[0]);
               pc1.computePrice33(pbeLst[0]);
               pc1.computePrice34(pbeLst[0]);
               pc1.computePrice35(pbeLst[0]);
               
               pc1.computeDueDate1(pbeLst[0]);
               pc1.computeDueDate2(pbeLst[0]);
               pc1.computeDueDate3(pbeLst[0]);
               pc1.computeDueDate4(pbeLst[0]);
               pc1.computeDueDate5(pbeLst[0]);
               pc1.computeDueDate6(pbeLst[0]);
               pc1.computeDueDate7(pbeLst[0]);
               pc1.computeDueDate8(pbeLst[0]);
               pc1.computeDueDate9(pbeLst[0]);
               pc1.computeDueDate10(pbeLst[0]);
               pc1.computeDueDate11(pbeLst[0]);
               pc1.computeDueDate12(pbeLst[0]);
               pc1.computeDueDate13(pbeLst[0]);
               pc1.computeDueDate14(pbeLst[0]);
               pc1.computeDueDate15(pbeLst[0]);
               pc1.computeDueDate16(pbeLst[0]);
               pc1.computeDueDate17(pbeLst[0]);
               pc1.computeDueDate18(pbeLst[0]);
               pc1.computeDueDate19(pbeLst[0]);
               pc1.computeDueDate20(pbeLst[0]);
               pc1.computeDueDate21(pbeLst[0]);
               pc1.computeDueDate22(pbeLst[0]);
               pc1.computeDueDate23(pbeLst[0]);
               pc1.computeDueDate24(pbeLst[0]);
               pc1.computeDueDate25(pbeLst[0]);
               pc1.computeDueDate26(pbeLst[0]);
               pc1.computeDueDate27(pbeLst[0]);
               pc1.computeDueDate28(pbeLst[0]);
               pc1.computeDueDate29(pbeLst[0]);
               pc1.computeDueDate30(pbeLst[0]);
               pc1.computeDueDate31(pbeLst[0]);
               pc1.computeDueDate32(pbeLst[0]);
               pc1.computeDueDate33(pbeLst[0]);
               pc1.computeDueDate34(pbeLst[0]);
               pc1.computeDueDate35(pbeLst[0]);
               pc1.computeDueDate36(pbeLst[0]);
               pc1.computeDueDate37(pbeLst[0]);
            }*/
            
        }
        catch(Exception e){
            system.debug('***** '+e);
        }
        
        Test.stopTest();
        
    }
    
    
}