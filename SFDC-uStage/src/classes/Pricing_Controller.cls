public without sharing class Pricing_Controller {
    
    public list<Country_Region_Map__c> CountryRegionList{get;set;}
    public map<integer,string> priceMap;
    public Country_Region_Map__c country_region{get;set;}
    public PriceBook2 priceBook{get;set;}
    public Match__c match{get;set;}
    public Match__c lastconfmatch{get;set;}
    public Opportunity opportunity{get;set;}
    public Engagement__c engagementObj{get;set;}
    public Applicant_Info__c applicantInfo{get;set;}   
    public list<PriceBookEntry> priceBookEntryList{get;set;}
    
    public String getPriceBook(String CountryofResidence,String IntraxProgram){
        
        CountryRegionList  =  new list<Country_Region_Map__c>();
        CountryRegionList= [SELECT ID ,Country__c,Intrax_Program__c,Price_Book__c,Region__c from Country_Region_Map__c WHERE Country__c=:CountryofResidence AND Intrax_Program__c=:IntraxProgram limit 1];
        system.debug('debug::Price_Book List'+CountryRegionList);
        if(CountryRegionList.size()>0 && CountryRegionList != null){
            return CountryRegionList[0].Price_Book__c;          
        }
        else
            return null;
    }
    
    
    public list<PriceBookEntry> getPricebookList(String CountryofInterest,String IntraxProgramCategory ,String PriceBook,String FeeType){
        
        If(CountryofInterest != null && IntraxProgramCategory  != null && PriceBook != null && FeeType != null){
            list<PriceBookEntry> fixedFee= new list<PriceBookEntry>();
            
            If(IntraxProgramCategory=='Information Media & Communications')
                IntraxProgramCategory='Info Media & Communication';
            
            system.debug('debug::CountryofInterest=='+CountryofInterest+'IntraxProgramCategory=='+IntraxProgramCategory+'PriceBook=='+PriceBook+'FeeType=='+FeeType);        
            fixedFee = [Select Id, CurrencyIsoCode,UnitPrice,PriceBook2.Name,PriceBook2.Intrax_Programs__c, Product2Id, Product2.Description,Product2.Destination__c, Product2.Name 
                        from PriceBookEntry where Product2.Destination__c =:CountryofInterest AND Product2.Fee_Type__c=:FeeType AND Product2.Family=:IntraxProgramCategory.replaceAll('&','and') AND Product2.IsActive = true 
                        AND IsActive = true AND PriceBook2.IsActive =true AND PriceBook2.Name = :PriceBook order by  CreatedDate desc] ;
            
            system.debug('debug::ListOfPricebook'+ fixedFee);
            If(fixedFee.size()>0){
                return fixedFee;
            }
        }
        return  new list<PriceBookEntry>();
    }
    
    
    
    public String getPriceBook(String Region,String IntraxProgram,String To_Country){
        
        CountryRegionList  =  new list<Country_Region_Map__c>();
        CountryRegionList= [SELECT ID ,Country__c,Intrax_Program__c,Price_Book__c,Region__c from Country_Region_Map__c WHERE Country__c=:To_Country AND Intrax_Program__c=:IntraxProgram AND Region__c=:Region   limit 1];
        system.debug('debug::Price_Book List'+CountryRegionList);
        if(CountryRegionList.size()>0 && CountryRegionList != null){
            return CountryRegionList[0].Price_Book__c;
        }
        else
            return null;
    }
    
    
    public list<PriceBookEntry> getAPCPricebookList(String PriceBookCode,String UserType, String FeeType, String ChildOppType,String promoCode){
        //If(CountryofInterest != null && PriceBook != null && FeeType != null){
        list<PriceBookEntry> fixedFee= new list<PriceBookEntry>();
        system.debug('debug:: FeeType=='+FeeType);
        system.debug('debug:: PriceBookCode=='+PriceBookCode);
        system.debug('debug:: ChildOppType=='+ChildOppType);
        
        
        fixedFee = [Select Id,CurrencyIsoCode,UnitPrice,PriceBook2.Name,PriceBook2.Price_Book_Code__c,PriceBook2.Intrax_Programs__c, 
                    Product2Id, Product2.Description,Product2.Destination__c, Product2.Name,Product2.Start_Date__c,Product2.Product_Keyword__c,
					Product2.CurrencyIsoCode
                    from   PriceBookEntry 
                    where  Product2.Fee_Type__c=:FeeType AND Product2.IsActive = true AND 
                    PriceBook2.Price_Book_Code__c=:PriceBookCode AND Product2.ChildOppType__c =:ChildOppType AND 
                    IsActive = true AND PriceBook2.IsActive =true AND 
                    Product2.Promo_Code__c=:promoCode AND Product2.user_type__c = :UserType
                    order by Product2.Start_Date__c desc] ;
        system.debug('debug::ListOfPricebook'+ fixedFee);
        If(fixedFee.size()>0){
            return fixedFee;
        }
        return  new list<PriceBookEntry>();
    }
    
    
    public list<PriceBookEntry> getAllAPCPricebookList(String PriceBookCode, String UserType, String OppType){
        list<PriceBookEntry> apcPriceBookEntries= new list<PriceBookEntry>();
        system.debug('debug:: PriceBookCode=='+PriceBookCode);
        system.debug('debug:: UserType=='+UserType);
        system.debug('debug:: OppType=='+OppType);
        
        apcPriceBookEntries = [Select pbe.Id,Product2.Name, pbe.Product2Id, Product2.Description,Product2.Family,Product2.ProductCode,
                               pbe.CurrencyIsoCode, pbe.UnitPrice,pbe.PriceBook2.Name,pbe.product2.CurrencyIsoCode,
                               pbe.PriceBook2.Price_Book_Code__c,pbe.PriceBook2.Intrax_Programs__c,
                               Product2.User_Type__c, Product2.Payment_Method__c, Product2.Fee_Type__c, Product2.Due_Date_Type__c,
                               Product2.Product_Keyword__c, Product2.Sort_Order__c, Product2.ChildOppType__c,
                               Product2.Promo_Code__c, Product2.Airport_Code__c,Product2.Refundable__c,
                               Product2.Help_Text__c, Product2.Intacct_Department__c, Product2.Intacct_GL_Group__c
                               from   PriceBookEntry pbe
                               where  Product2.IsActive = true AND
                               IsActive = true AND
                               PriceBook2.IsActive =true AND 
                               PriceBook2.Price_Book_Code__c=:PriceBookCode AND 
                               Product2.ChildOppType__c =:OppType AND 
                               Product2.User_Type__c=:UserType 
                               order  by Product2.Start_Date__c desc] ;
        system.debug('debug::apcPriceBookEntries'+ apcPriceBookEntries);
        if(apcPriceBookEntries!=null && apcPriceBookEntries.size()>0)
            return apcPriceBookEntries;
        else    
            return null;
    }
    
    public list<Opportunity_Product_Cart> getMatchOpportunityProducts(String PriceBookCode, String UserType, String OppType)
    {
        list<PriceBookEntry> allPriceBookEntries;
        list<Opportunity_Product_Cart> newOppProducts;
        /*
         String priceBookCode = 'APC USA';
         String userType='Host Family';
         String oppType = 'Match';match = [Select Id, match_date__c,Start_Date__c, end_date__c, Engagement__r.Engagement_Start__c,
                        Engagement__r.Engagement_end__c,Engagement__r.In_Country__c, Engagement__c 
                 From   Match__c 
                 Where  id= 'a0R19000000LjX3'];
        opportunity = [Select Id from Opportunity where id= '00619000002sCUf'];
        System.debug('match is : ' + match);
        System.debug('opportunity is : ' + opportunity);*/
        //First retrieve all the price book entries.
        allPriceBookEntries = getAllAPCPricebookList(priceBookCode, userType, oppType);
        if(allPriceBookEntries!=null && allPriceBookEntries.size()>0)
        {
            //Now process all the price book entires that are retrieved and add to default list of o`portunity product items
            newOppProducts = processPriceBookEntries(allPriceBookEntries);
            
            //if this is an incoutnry aupair, we need to process the explicit promos separtely
            if(match.Engagement__r.In_Country__c == 'Yes')
            newOppProducts = processMatchICAPExplicitPromos(allPriceBookEntries, newOppProducts);
            
            //Now we need to process some implicit promos if any applicable
            for(Opportunity_Product_Cart oppLineItem :newOppProducts )
            {
                System.debug('oppLineItem ' + oppLineItem);
            }
            
            //insert the OpporunitylineItems under the opportunity
            /*if(newOppProducts!=null && newOppProducts.size()>0)
            insert newOppProducts;*/ 
            system.debug('debug::newopp'+newOppProducts);
            //We have all the opporutnity product lineitems that are applicable for this match.
            return newOppProducts;
            
        }
        else
            return null;
    }
    
    public void insertMatchOpporuntityProducts(list<OpportunityLineItem> lstOppProducts,String paymentMethod)
    {
        list<OpportunityLineItem> listFinalOppProducts = new list<OpportunityLineItem>();
        for(OpportunityLineItem oppLineItem : lstOppProducts)
        {
            System.debug('insertMatch : payment method' + oppLineItem.payment_method__c + ' product family ' + oppLineItem.Product_Family__c);
            if(oppLineItem.payment_method__c==paymentMethod || oppLineItem.payment_method__c == 'All')
                listFinalOppProducts.Add(oppLineItem);
            else
                continue;
                    
        }
        
        if(listFinalOppProducts != null && listFinalOppProducts.size() > 0)
        insert listFinalOppProducts;
        
    }
    
    /*Process all the pricebook entries that are retrieved.
    Check the applicability condition.
    If applicable, compute price and due date*/
    public list<Opportunity_Product_Cart> processPriceBookEntries(list<PriceBookEntry> priceBookEntries)
    {
        list<Opportunity_Product_Cart> newOppProducts = new list<Opportunity_Product_Cart>();
        
        /*loop through all the price book entries and process them*/
        for(PriceBookEntry pbe: priceBookEntries)
        {
            system.debug('price book entry' + pbe);      
            /*call the conditionality function to check whether this product is applicable or not*/
            if(isProductApplicable(pbe))
            {
                Opportunity_Product_Cart newOppProduct = new Opportunity_Product_Cart();
                double price;
                Date dueDate;
                newOppProduct.productCode=pbe.product2.ProductCode;
                newOppProduct.currencyIsoCode=pbe.product2.currencyIsoCode;
                
                /*call the price computation function*/
                newOppProduct.unitPrice = computeProductPrice(pbe);
                
                /*call the date computation function*/
                newOppProduct.dueDate = computeProductDueDate(pbe);
                
                newOppProduct.priceBookEntryId = pbe.Id;
                newOppProduct.Quantity = 1; 
                newOppProduct.OpportunityId = opportunity.Id; 
                newOppProduct.productName = pbe.Product2.Name;
                newOppProduct.paymentMethod = pbe.product2.payment_method__c;
                newOppProduct.productDescription = pbe.product2.Description;
                newOppProduct.productFamily =pbe.product2.Family;
                newOppProduct.productHelpText=pbe.product2.Help_Text__c;
                
                System.debug(' PpplineItem UnitPrice: ' + newOppProduct.UnitPrice + ' Due date: ' + newOppProduct.dueDate + 
                             ' PricebookentryId: ' + newOppProduct.priceBookEntryId + ' Product Name ' + newOppProduct.productName + 
                             ' Product Code' +  newOppProduct.productCode + ' payment method ' + newOppProduct.paymentMethod  +
                             ' Help Text' + newOppProduct.productHelpText + ' descripton' + newOppProduct.productDescription);
                newOppProducts.Add(newOppProduct);
            }
        }
        return newOppProducts;
    }
    
    public boolean isProductApplicable(PriceBookEntry pbe)
    {
        /*start of extension match initiated by host Family*/
        if(ApplicantInfo!=null && ApplicantInfo.application_type__c == 'Extension' && ApplicantInfo.Type__c == 'Host Family')
        {
            /*if extension then we need to verify if regular rates apply or extension rates apply.
             If a HF 'extends' with an AuPair who has only been placed with the HF for less than 6 months, 
			the regular (NOT extension) program rates apply.
			An example:  A HF matched with an ICAP for 5 1/2 month to finish the AP term wamts to extend the same AP, 
			the program fee will be $650 per month instead of the extension rates currently listed in the price book
             */
            
            boolean applyExtensionRate=false;
            
            if(lastconfmatch!=null)
            {
                System.debug('days ' + lastconfmatch.Start_Date__c.daysBetween(lastconfmatch.end_Date__c));
                if(lastconfmatch.Start_Date__c.daysBetween(lastconfmatch.end_Date__c)>=183)
                    applyExtensionRate = true;
                else 
                    applyExtensionRate = false;
            }
            else
            {
                //be default we are applyiing applyExtensionRate
                applyExtensionRate = true;
                System.debug('Something is wrong here. We cannot have an extension application without a previous match' +
                             ' confirmed or completed');
                //return false;
            }
			
            //DOS extension is mandatory for any extension.
 			if(pbe.Product2.Product_Keyword__c == 'extension_DOS_fee')
				return true;
            
            if(applyExtensionRate)
            {
                if(applicantInfo.Extension_Length__c == '6' && pbe.Product2.Product_Keyword__c == 'extension_6months_program_fee')
                	return true;
                else if(applicantInfo.Extension_Length__c == '9' && pbe.Product2.Product_Keyword__c == 'extension_9months_program_fee')
                	return true;
                else if(applicantInfo.Extension_Length__c == '12')
                {
                    if(pbe.Product2.Product_Keyword__c == 'extension_12months_program_fee' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_1' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_2' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_3' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_4' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_dowpayment' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_1' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_2' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_3' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_4' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_downpayment')
                        return true;
                }
                else
                	return false;
            }
            else
            {
                if(applicantInfo.Extension_Length__c == '6' && pbe.Product2.Product_Keyword__c == 'extension_icap_6months')
                	return true;
                else if(applicantInfo.Extension_Length__c == '9' && pbe.Product2.Product_Keyword__c == 'extension_icap_9months')
                	return true;
                else if(applicantInfo.Extension_Length__c == '12')
                {
                    if(pbe.Product2.Product_Keyword__c == 'extension_icap_12month_program_fee' ||
                       pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_1' ||
                       pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_2' ||
                       pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_3' ||
                       pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_4' ||
                       pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_downpayment' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_1' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_2' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_3' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_4' ||
                       pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_downpayment')
                        return true;
                }
                else
                	return false;
            }
        }
		/*End of extension match initiated by host Family*/
        
        /*start of renewal application initiated by participant*/
        if(ApplicantInfo!=null && ApplicantInfo.application_type__c == 'Renewal' && ApplicantInfo.Type__c == 'Participant')
        {
          if(pbe.Product2.Product_Keyword__c == 'pt_renewal_dos_extension_fee')
              return true;
        }
        /*End of renewal application initiated by participant*/
        
        /*End of program participant opportunities*/
        if(ApplicantInfo!=null && ApplicantInfo.Type__c == 'Participant')
        {
          if(pbe.Product2.Product_Keyword__c == 'eop_insurance_fee' ||
             pbe.Product2.Product_Keyword__c == 'eop_return_flight_late_fee' )
              return true;
        }
        /*End of program participant opportunities*/
        
        if(match !=null && ApplicantInfo!=null && match.Engagement__r.In_Country__c == 'No' && ApplicantInfo.application_type__c != 'Extension')
        {
            if(pbe.Product2.Product_Keyword__c == 'match_osap_lumpsum_deposit' ||
               pbe.Product2.Product_Keyword__c == 'match_osap_lumpsum_balance'||
               pbe.Product2.Product_Keyword__c == 'match_osap_sevis_fee'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_deposit'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_downpayment'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_1'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_2'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_3'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_4'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_downpayment'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_1'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_2'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_3'||
               pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_4'||
               pbe.Product2.Product_Keyword__c == 'eop_insurance_fee'||
               pbe.Product2.Product_Keyword__c == 'eop_return_flight_late_fee')
                return true;
            else if(pbe.Product2.Product_Keyword__c == 'match_infant_specialization_fee')
                return conditionalityCheck1(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'match_osap_nz_aupair_surcharge')
                return conditionalityCheck2(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'Travel')
                return conditionalityCheck3(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'match_promo_codes')
                return conditionalityCheck4(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'match_repeat_family_discount')
                return conditionalityCheck8(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'match_OSAP_early_discount')
                return conditionalityCheck9(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'rematch_qualified_discount')
                return conditionalityCheck11(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'rematch_discretionary_discount')
                return conditionalityCheck12(pbe);
            else
                return false;
        }
        else if(match!=null && ApplicantInfo!=null && match.Engagement__r.In_Country__c == 'Yes' && ApplicantInfo.application_type__c != 'Extension')
        {
            if(pbe.Product2.Product_Keyword__c == 'eop_insurance_fee'||
               pbe.Product2.Product_Keyword__c == 'eop_return_flight_late_fee')
                return true;
            else if(pbe.Product2.Product_Keyword__c == 'match_icap_lumpsum_deposit' ||  //this is not currently used
               	pbe.Product2.Product_Keyword__c == 'match_icap_standard_program_fee')
                return conditionalityCheck5(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_deposit'|| //this is not currently used
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_downpayment'||  //this is for icap downpayment
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_1'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_2'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_3'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_4'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_downpayment'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_1'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_2'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_3'||
                    pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_4')
                return conditionalityCheck6(pbe);
             else if(pbe.Product2.Product_Keyword__c == 'match_repeat_family_discount')
                return conditionalityCheck10(pbe);
			else if(pbe.Product2.Product_Keyword__c == 'rematch_qualified_discount')
                return conditionalityCheck11(pbe);
            else if(pbe.Product2.Product_Keyword__c == 'rematch_discretionary_discount')
                return conditionalityCheck12(pbe);            
            else 
                return false;
        }
        else
            return false;
    }
    
    /*check if the product with keyword = match_infant_specialization_fee
    is appplicable or not*/
    public boolean conditionalityCheck1(PriceBookEntry pbe)
    {
        /*place holder for checking the applicability of infant specialization fee*/
        if(match.Infant_Specialized_Training__c=='Yes')
            return true;
        else
            return false;
    }
    
    /*check if the product with keyword = match_osap_nz_aupair_surcharge
    is appplicable or not*/
    public boolean conditionalityCheck2(PriceBookEntry pbe)
    {
        /*place holder for checking the applicability of nz aupair surcharge*/
        if(match.Participant_Id__r.Legal_Residence__pc !=null &&
           (match.Participant_Id__r.Legal_Residence__pc == 'Australia'  ||
           match.Participant_Id__r.Legal_Residence__pc == 'New Zealand'))
            return true;
        else
           return false;
    }
    
    /*check if the product with keyword = Travel
    is appplicable or not*/
    public boolean conditionalityCheck3(PriceBookEntry pbe)
    {
        /*place holder for checking the applicability of Travel product*/
        if((pbe.Product2.Airport_Code__c!=null && pbe.Product2.Airport_Code__c == match.Airport_code__c)||
           (pbe.Product2.Airport_Code__c==null && match.Airport_code__c==null))
            return true;
        else
            return false;
    }
    
    /*check if the product with keyword = match_promo_codes
    is appplicable or not for OSAP */
    public boolean conditionalityCheck4(PriceBookEntry pbe)
    {
        /*place holder for checking the applicability of match_promo_codes product for OSAP*/
        if(pbe.Product2.Promo_Code__c == applicantinfo.PromoCode__c)
            return true;
        else
            return false;
    }
    
    /*check if the product are applicable for ICAP lumsum 
    is appplicable or not*/
    public boolean conditionalityCheck5(PriceBookEntry pbe)
    {
        return true;
    }
    
    /*check if this product is appplicable for ICAP Installment plan*/
    public boolean conditionalityCheck6(PriceBookEntry pbe)
    {
        System.debug('days between' + math.abs(match.End_Date__c.daysBetween(match.Start_Date__c)));
        //If the no. of match days or engagement days are greate than equal to 305 days for any incountry aupair then HF is eligible for installment option.
        if(math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))>=305)
            return true;
        else
            return false;
    }
    
    /*check if the product with keyword = match_promo_codes and
    is appplicable or not to ICAP*/
    public boolean conditionalityCheck7(PriceBookEntry pbe)
    {
        /*place holder for checking the applicability of match_promo_codes product for ICAP*/
        if(pbe.Product2.promo_code__c == applicantinfo.PromoCode__c)
            return true;
        else
            return false;
    }
    
    /*check if the product are applicable for OSAP Repeat Family Discount or not*/
    public boolean conditionalityCheck8(PriceBookEntry pbe)
    {
        if(match.Match_Type__c=='Renewal' && match.Start_Date__c.daysBetween(match.end_date__c) >= 365)
            return true;
        else
            return false;
    }
    
    /*check if the product are applicable for OSAP Early Discount or not*/
    public boolean conditionalityCheck9(PriceBookEntry pbe)
    {
        //If(lastmatch.Start_Date__c.addDays(-91) > date.today())
        system.debug('debug::Inside_conditionalityCheck9' + lastconfmatch);
        If(lastconfmatch != null && lastconfmatch.End_Date__c.addDays(-90) > date.today())
            return true;
        else
            return False;
    }
    
    /*check if the product are applicable for ICAP Repeat Family Discount or not*/
    public boolean conditionalityCheck10(PriceBookEntry pbe)
    {
        if(match.Match_Type__c=='Renewal' && match.Start_Date__c.daysBetween(match.end_date__c) >= 365)
            return true;
        else
            return false;
    }
    
    /*check if the product with keyword = rematch_qualified_discount and
    is appplicable or not*/
    public boolean conditionalityCheck11(PriceBookEntry pbe)
    {
        /*place holder for checking the applicability of match_promo_codes product for ICAP*/
        if(applicantInfo.application_type__c =='Rematch' &&
           applicantinfo.account__r.rematch_type__c !=null && 
           applicantinfo.account__r.rematch_type__c == 'Qualified')
            return true;
        else
            return false;
    }
    
    /*check if the product with keyword = rematch_discretionary_discount and
    is appplicable or not*/
    public boolean conditionalityCheck12(PriceBookEntry pbe)
    {
        /*place holder for checking the applicability of match_promo_codes product for ICAP*/
        if(applicantInfo.application_type__c =='Rematch' &&
           applicantinfo.account__r.discretionary_discount__c !=null )
            return true;
        else
            return false;
    }
    
    public double computeProductPrice(PriceBookEntry pbe)
    {
        if(pbe.Product2.Product_Keyword__c == 'match_osap_lumpsum_deposit')
            return computePrice1(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_lumpsum_balance')
            return computePrice2(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_sevis_fee')
            return computePrice3(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_deposit')
            return computePrice4(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_downpayment')
            return computePrice5(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_1')
            return computePrice6(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_2')
            return computePrice7(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_3')
            return computePrice8(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_4')
            return computePrice9(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_downpayment')
            return computePrice10(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_1')
            return computePrice11(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_2')
            return computePrice12(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_3')
            return computePrice13(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_4')
            return computePrice14(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_lumpsum_deposit')
            return computePrice15(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_standard_program_fee')
            return computePrice16(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_deposit')
            return computePrice17(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_downpayment')
            return computePrice18(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_1')
            return computePrice19(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_2')
            return computePrice20(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_3')
            return computePrice21(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_4')
            return computePrice22(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_downpayment')
            return computePrice23(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_1')
            return computePrice24(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_2')
            return computePrice25(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_3')
            return computePrice26(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_4')
            return computePrice27(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_infant_specialization_fee')
            return computePrice28(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_nz_aupair_surcharge')
            return computePrice29(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'Travel')
            return computePrice30(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_promo_codes')
            return computePrice31(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'eop_return_flight_late_fee')
            return computePrice34(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'eop_insurance_fee')
            return computePrice35(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_repeat_family_discount')
            return computePrice36(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_OSAP_early_discount')
            return computePrice37(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'rematch_qualified_discount')
            return computePrice38(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'rematch_discretionary_discount')
            return computePrice39(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'extension_12months_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_1' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_2' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_3' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_4' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_dowpayment' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_1' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_2' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_3' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_4' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_downpayment' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_12month_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_1' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_2' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_3' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_4' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_downpayment' ||
                pbe.Product2.Product_Keyword__c == 'extension_6months_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_9months_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_6months' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_9months' ||
                pbe.Product2.Product_Keyword__c == 'extension_DOS_fee'
               )
            return computePrice40(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'pt_renewal_dos_extension_fee')
            return computePrice41(pbe);
        else
            return null;
    }
    
    public date computeProductDueDate(PriceBookEntry pbe)
    {
        if(pbe.Product2.Product_Keyword__c == 'match_osap_lumpsum_deposit')
            return computeDueDate1(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_lumpsum_balance')
            return computeDueDate2(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_sevis_fee')
            return computeDueDate3(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_deposit')
            return computeDueDate4(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_downpayment')
            return computeDueDate5(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_1')
            return computeDueDate6(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_2')
            return computeDueDate7(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_3')
            return computeDueDate8(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_installment_4')
            return computeDueDate9(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_downpayment')
            return computeDueDate10(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_1')
            return computeDueDate11(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_2')
            return computeDueDate12(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_3')
            return computeDueDate13(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_payment_plan_fee_installment_4')
            return computeDueDate14(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_lumpsum_deposit')
            return computeDueDate15(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_standard_program_fee')
            return computeDueDate16(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_deposit')
            return computeDueDate17(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_downpayment')
            return computeDueDate18(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_1')
            return computeDueDate19(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_2')
            return computeDueDate20(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_3')
            return computeDueDate21(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_installment_4')
            return computeDueDate22(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_downpayment')
            return computeDueDate23(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_1')
            return computeDueDate24(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_2')
            return computeDueDate25(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_3')
            return computeDueDate26(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_icap_payment_plan_fee_installment_4')
            return computeDueDate27(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_infant_specialization_fee')
            return computeDueDate28(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_osap_nz_aupair_surcharge')
            return computeDueDate29(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'Travel')
            return computeDueDate30(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_promo_codes')
            return computeDueDate31(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'eop_return_flight_late_fee')
            return computeDueDate36(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'eop_insurance_fee')
            return computeDueDate37(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_repeat_family_discount')
            return computeDueDate38(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'match_OSAP_early_discount')
            return computeDueDate39(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'rematch_qualified_discount')
            return computeDueDate40(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'rematch_discretionary_discount')
            return computeDueDate41(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'extension_DOS_fee')
            return computeDueDate42(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'extension_12months_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_12month_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_6months_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_9months_program_fee' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_6months' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_9months' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_dowpayment' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_downpayment' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_downpayment')
            return computeDueDate43(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_1' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_1' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_1')
            return computeDueDate44(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_2' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_2' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_2')
            return computeDueDate45(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_3' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_3' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_3')
            return computeDueDate46(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'extension_payment_plan_installment_4' ||
                pbe.Product2.Product_Keyword__c == 'extension_icap_payment_plan_installment_4' ||
                pbe.Product2.Product_Keyword__c == 'extension_payment_plan_fee_installment_4')
            return computeDueDate47(pbe);
        else if(pbe.Product2.Product_Keyword__c == 'pt_renewal_dos_extension_fee')
            return computeDueDate48(pbe);
        else 
            return null;
    }
    
    /*For product with keyword = match_osap_lumpsum_deposit */
    public double computePrice1(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_lumpsum_balance */
    public double computePrice2(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_sevis_fee */
    public double computePrice3(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_deposit */
    public double computePrice4(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_downpayment */
    public double computePrice5(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_1 */
    public double computePrice6(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_2 */
    public double computePrice7(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_3 */
    public double computePrice8(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_4 */
    public double computePrice9(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_downpayment */
    public double computePrice10(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_1 */
    public double computePrice11(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_2 */
    public double computePrice12(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_3 */
    public double computePrice13(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_4 */
    public double computePrice14(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_icap_lumpsum_deposit */
    public double computePrice15(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_icap_standard_program_fee */
    public double computePrice16(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            price = math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))*pbe.UnitPrice;
            return price;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_deposit */
    public double computePrice17(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            //calcualte the number of days left on the aupair's visa
            return price;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_downpayment */
    public double computePrice18(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            /*calcualte the number of days left on the aupair's visa*/
            price = math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))*pbe.UnitPrice;//*0.35;
            return price;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_1 */
    public double computePrice19(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            //calcualte the number of days left on the aupair's visa*day rate* 65% / 4
            price = math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))*pbe.UnitPrice;//*0.65/4;
            return price;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_2 */
    public double computePrice20(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            //calcualte the number of days left on the aupair's visa*day rate* 65% / 4
            price = math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))*pbe.UnitPrice;//*0.65/4;
            return price;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_3 */
    public double computePrice21(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            //calcualte the number of days left on the aupair's visa*day rate* 65% / 4
            price = math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))*pbe.UnitPrice;//*0.65/4;
            return price;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_4 */
    public double computePrice22(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            //calcualte the number of days left on the aupair's visa*day rate* 65% / 4
            price = math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))*pbe.UnitPrice;//*0.65/4;
            return price;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_downpayment */
    public double computePrice23(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_1 */
    public double computePrice24(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_2 */
    public double computePrice25(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_3 */
    public double computePrice26(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_4 */
    public double computePrice27(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_infant_specialization_fee */
    public double computePrice28(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_nz_aupair_surcharge */
    public double computePrice29(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = Travel */
    public double computePrice30(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_promo_codes */
    public double computePrice31(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For ICAP promo downpayment*/
    public double computePrice32(PriceBookEntry pbe)
    {
        double price;
        /*calcualte the number of days left on the aupair's visa*/
        //price = pbe.UnitPrice*0.35;
        //for ICAP also the promo discount is realized in full during down payment.
        price = pbe.UnitPrice;
        return price;
    }
    
    /*For ICAP promo installment1, installemnt2 , installment3, installment4 */
    public double computePrice33(PriceBookEntry pbe)
    {
        double price;
        //calcualte the number of days left on the aupair's visa*day rate* 65% / 4
        price = pbe.UnitPrice*0.65/4;
        return price;
    }
    
    /*For product with keyword = eop_return_flight_late_fee */
    public double computePrice34(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = eop_insurance_fee */
    public double computePrice35(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_repeat_family_discount */
    public double computePrice36(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
	/*For product with keyword = match_OSAP_early_discount */
	public double computePrice37(PriceBookEntry pbe)
	{
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = rematch_qualified_discount */
    public double computePrice38(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = rematch_discretionary_discount */
    public double computePrice39(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
        {
            if(applicantinfo.account__r.discretionary_discount__c!=null)
                return applicantinfo.account__r.discretionary_discount__c * -1;
            else
                return 0;
        }
    }
    
    /*For product with keyword = for all extension match products */
    public double computePrice40(PriceBookEntry pbe)
    {
        double price;
        if(pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = pt_renewal_dos_extension_fee */
    public double computePrice41(PriceBookEntry pbe)
    {
        double price;
        if(applicantinfo.type__c == 'Participant' && pbe.Product2.Fee_Type__c=='Fixed')
            return pbe.UnitPrice;
        else
            return price;
    }
    
    /*For product with keyword = match_osap_lumpsum_deposit */
    public Date computeDueDate1(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
            return dueDate;
    }
    
    /*For product with keyword = match_osap_lumpsum_balance */
    public Date computeDueDate2(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_sevis_fee */
    public Date computeDueDate3(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_deposit */
    public Date computeDueDate4(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
            return dueDate;
    }
    
    /*For product with keyword = match_osap_payment_plan_downpayment */
    public Date computeDueDate5(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_1 */
    public Date computeDueDate6(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 60;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_2 */
    public Date computeDueDate7(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 90;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_3 */
    public Date computeDueDate8(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 120;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_installment_4 */
    public Date computeDueDate9(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 150;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_downpayment */
    public Date computeDueDate10(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_1 */
    public Date computeDueDate11(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 60;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_2 */
    public Date computeDueDate12(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 90;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_3 */
    public Date computeDueDate13(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 120;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_payment_plan_fee_installment_4 */
    public Date computeDueDate14(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 150;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_lumpsum_deposit */
    public Date computeDueDate15(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
        {   
            if(match.start_date__c <= System.Today())
                return match.start_date__c - 1;
            else
                return System.Today();
        }
        else
            return dueDate;
    }
    
    /*For product with keyword = match_icap_standard_program_fee */
    public Date computeDueDate16(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
        {   
            if(match.start_date__c <= System.Today())
                return match.start_date__c - 1;
            else
                return System.Today();
        }
        else
            return dueDate;
    }
    
    /*For product with keyword = match_icap_payment_plan_deposit */
    public Date computeDueDate17(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
        {   
            if(match.start_date__c <= System.Today())
                return match.start_date__c - 1;
            else
                return System.Today();
        }
        else
            return dueDate;
    }
    
    /*For product with keyword = match_icap_payment_plan_downpayment */
    public Date computeDueDate18(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
        {   
            if(match.start_date__c <= System.Today())
                return match.start_date__c - 1;
            else
                return System.Today();
        }
        else
            return dueDate;
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_1 */
    public Date computeDueDate19(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 60;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_2 */
    public Date computeDueDate20(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 90;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_3 */
    public Date computeDueDate21(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 120;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_installment_4 */
    public Date computeDueDate22(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 150;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_downpayment */
    public Date computeDueDate23(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
        {   
            if(match.start_date__c <= System.Today())
                return match.start_date__c - 1;
            else
                return System.Today();
        }
        else
            return dueDate;
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_1 */
    public Date computeDueDate24(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 60;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_2 */
    public Date computeDueDate25(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 90;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_3 */
    public Date computeDueDate26(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 120;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_icap_payment_plan_fee_installment_4 */
    public Date computeDueDate27(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 150;
            return dueDate;
        }
    }
    
    /*For product with keyword = match_infant_specialization_fee */
    public Date computeDueDate28(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = match_osap_nz_aupair_surcharge */
    public Date computeDueDate29(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = Travel */
    public Date computeDueDate30(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = match_promo_codes OSAP AND ICAP downpayment */
    public Date computeDueDate31(PriceBookEntry pbe)
    {
        Date dueDate;
        if(match.Engagement__r.In_Country__c=='Yes')
        {   
            if(match.start_date__c <= System.Today())
                return match.start_date__c - 1;
            else
                return System.Today();
        }
        else
        {       
            if(match.Engagement__r.In_Country__c=='No')
            {
                if((match.Start_Date__c - 30 )>System.Today())
                    dueDate = match.Start_Date__c - 30;
                else
                    dueDate = System.Today();
            }
            else
                dueDate= System.Today();
            return dueDate;
        }
    }   
    
    
    /*For product match icap promo installment 1 */
    public Date computeDueDate32(PriceBookEntry pbe)
    {
        Date dueDate;
        dueDate= match.Start_Date__c + 60;
        return dueDate;
    }
    
    /*For product match icap promo installment 2 */
    public Date computeDueDate33(PriceBookEntry pbe)
    {
        Date dueDate;
        dueDate= match.Start_Date__c + 90;
        return dueDate;
    }
    
    /*For product match icap promo installment 3 */
    public Date computeDueDate34(PriceBookEntry pbe)
    {
        Date dueDate;
        dueDate= match.Start_Date__c + 120;
        return dueDate;
    }
    
    /*For product match icap promo installment 4 */
    public Date computeDueDate35(PriceBookEntry pbe)
    {
        Date dueDate;
        dueDate= match.Start_Date__c + 150;
        return dueDate;
    }
    
    /*For product with keyword = eop_return_flight_late_fee */
    public Date computeDueDate36(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
            return dueDate;
    }
    
    /*For product with keyword = eop_insurance_fee */
    public Date computeDueDate37(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
            return dueDate;
    }
    
    /*For product with keyword = match_repeat_family_discount */
    public Date computeDueDate38(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if(match.Engagement__r.In_Country__c=='No')
            {
                if((match.Start_Date__c - 30 )>System.Today())
                    dueDate = match.Start_Date__c - 30;
                else
                    dueDate = System.Today();
            }
            else if(match.Engagement__r.In_Country__c=='Yes')
            {   
                if(match.start_date__c <= System.Today())
                    dueDate = match.start_date__c - 1;
                else
                    dueDate = System.Today();
            }
        }
        return dueDate;
    }
    
    /*For product with keyword = match_OSAP_early_discount */
    public Date computeDueDate39(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_Date__c - 30;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = rematch_qualified_discount */
    public Date computeDueDate40(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            dueDate = System.Today();
        else
        {
            if(match.Engagement__r.In_Country__c=='No')
            {
                if((match.Start_Date__c - 30 )>System.Today())
                    dueDate = match.Start_Date__c - 30;
                else
                    dueDate = System.Today();
                
            }
            else if(match.Engagement__r.In_Country__c=='Yes')
            {   
                if(match.start_date__c <= System.Today())
                    dueDate = match.start_date__c - 1;
                else
                    dueDate = System.Today();
            }
        }
        return dueDate;
    }
    
    /*For product with keyword = rematch_discretionary_discount */
    public Date computeDueDate41(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            if(match.Engagement__r.In_Country__c=='No')
            {
                if((match.Start_Date__c - 30 )>System.Today())
                    dueDate = match.Start_Date__c - 30;
                else
                    dueDate = System.Today();
	        }
           	else if(match.Engagement__r.In_Country__c=='Yes')
            {   
                if(match.start_date__c <= System.Today())
                    dueDate = match.start_date__c - 1;
                else
                    dueDate = System.Today();
            }
        }
        return dueDate;
    }
    
    
    /*For product with keyword = extension_DOS_fee */
    public Date computeDueDate42(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
            return dueDate;
    }
    
    /*For product with keyword = extension_12months_program_fee,extension_9months_program_fee,extension_6months_program_fee,extension_payment_plan_dowpayment
     * extension_payment_plan_fee_downpayment,extension_icap_payment_plan_downpayment,extension_icap_12month_program_fee,extension_icap_6months,extension_icap_9months
	*/
    public Date computeDueDate43(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
        {   
            if(match.start_date__c <= System.Today())
                return match.start_date__c - 1;
            else
                return System.Today();
        }
        else
        {
            if((match.Start_Date__c - 30 )>System.Today())
                dueDate = match.Start_date__c - 30;
            else if(match.start_date__c <= System.Today())
                dueDate = match.start_date__c - 1;
            else
                dueDate = System.Today();
            return dueDate;
        }
    }
    
    /*For product with keyword = extension_payment_plan_installment_1,extension_payment_plan_fee_installment_1,extension_icap_payment_plan_installment_1 */
    public Date computeDueDate44(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_date__c + 60;
            return dueDate;
        }
    }
    
    /*For product with keyword = extension_payment_plan_installment_2,extension_payment_plan_fee_installment_2,extension_icap_payment_plan_installment_2 */
    public Date computeDueDate45(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_Date__c + 90;
            return dueDate;
        }
    }
    
    /*For product with keyword = extension_payment_plan_installment_3,extension_payment_plan_fee_installment_3,extension_icap_payment_plan_installment_3 */
    public Date computeDueDate46(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_date__c + 120;
            return dueDate;
        }
    }
    
    /*For product with keyword = extension_payment_plan_installment_4,extension_payment_plan_fee_installment_4,extension_icap_payment_plan_installment_4 */
    public Date computeDueDate47(PriceBookEntry pbe)
    {
        Date dueDate;
        if(pbe.Product2.due_date_type__c=='Invdate')
            return System.Today();
        else
        {
            dueDate= match.Start_date__c + 150;
            return dueDate;
        }
    }
    
    /*For product with keyword = pt_renewal_dos_extension_fee */
    public Date computeDueDate48(PriceBookEntry pbe)
    {
        Date dueDate;
        if(applicantinfo.type__c == 'Participant' && pbe.Product2.due_date_type__c=='Invdate')
            return  System.Today();
        else
            return System.Today();
    }
    
    /*Process all the pricebook entries that are retrieved.
    Check the applicability condition. If applicable, compute price and due date*/
    public list<Opportunity_Product_Cart> processMatchICAPExplicitPromos(list<PriceBookEntry> priceBookEntries, list<Opportunity_Product_Cart> newOppProducts)
    {
        
        /*loop through all the price book entries and process the ICAP Explicit promos if applicable*/
        for(PriceBookEntry pbe: priceBookEntries)
        {
            system.debug('price book entry' + pbe);      
            
            if(pbe.Product2.Product_Keyword__c == 'match_promo_codes')
            {
                /*check if this promo code is avaialable on match or not
                .....
                .....
                */    
                if(conditionalityCheck7(pbe))
                {
                Opportunity_Product_Cart newOppProduct = new Opportunity_Product_Cart();
                //Ok first process this promo entry for ICAP lumpsum
                /*call the price computation function*/
                newOppProduct.UnitPrice = computeProductPrice(pbe);
                /*call the date computation function*/
                newOppProduct.dueDate = computeDueDate31(pbe);
                newOppProduct.productCode=pbe.product2.ProductCode;
                newOppProduct.currencyIsoCode=pbe.product2.currencyIsoCode;
                newOppProduct.priceBookEntryId = pbe.Id;
                newOppProduct.Quantity = 1; 
                newOppProduct.OpportunityId = opportunity.Id; 
                newOppProduct.productName = pbe.Product2.Name;
                newOppProduct.productDescription = pbe.product2.Description;
                newOppProduct.productFamily =pbe.product2.Family;
                newOppProduct.productHelpText=pbe.product2.Help_Text__c;  
                newOppProduct.paymentMethod = 'Standard';
                newOppProducts.Add(newOppProduct);
                
                
                //Now check the payment plan option is applicable or not for this promo
                if(conditionalityCheck6(pbe))
                {
                    Opportunity_Product_Cart newOppProduct1 = new Opportunity_Product_Cart();
                    //Now process this promo entry for ICAP donwpayment
                    ///call the price computation function
                    newOppProduct1.UnitPrice = computePrice32(pbe);
                    //call the date computation function
                    newOppProduct1.dueDate = computeDueDate31(pbe);
                    newOppProduct1.productCode=pbe.product2.ProductCode;
                    newOppProduct1.currencyIsoCode=pbe.product2.currencyIsoCode;
                    newOppProduct1.priceBookEntryId = pbe.Id;
                    newOppProduct1.Quantity = 1; 
                    newOppProduct1.OpportunityId = opportunity.Id; 
                    newOppProduct1.productName = pbe.Product2.Name;
                    newOppProduct1.productDescription = pbe.product2.Description;
                    newOppProduct1.productFamily =pbe.product2.Family;
                    newOppProduct1.productHelpText=pbe.product2.Help_Text__c;  
                    newOppProduct1.paymentMethod = 'Installment';
                    newOppProducts.Add(newOppProduct1);  
                    
                    //Commenting the below code because the promo for iCap is realized in full during downpayment hence no need
                    //to add it in installment orders.
                    /*
                    Opportunity_Product_Cart newOppProduct2 = new Opportunity_Product_Cart();
                    //Now process this promo entry for ICAP installment 1
                    //call the price computation function
                    newOppProduct2.UnitPrice = computePrice33(pbe);
                    //call the date computation function
                    newOppProduct2.dueDate = computeDueDate32(pbe);
                    newOppProduct2.productCode=pbe.product2.ProductCode;
                    newOppProduct2.currencyIsoCode=pbe.product2.currencyIsoCode;
                    newOppProduct2.priceBookEntryId = pbe.Id;
                    newOppProduct2.Quantity = 1; 
                    newOppProduct2.OpportunityId = opportunity.Id; 
                    newOppProduct2.productName = pbe.Product2.Name;
                    newOppProduct2.productDescription = pbe.product2.Description;
                    newOppProduct2.productFamily =pbe.product2.Family;
                    newOppProduct2.productHelpText=pbe.product2.Help_Text__c;  
                    newOppProduct2.paymentMethod = 'Installment';
                    newOppProducts.Add(newOppProduct2);
                    
                    Opportunity_Product_Cart newOppProduct3 = new Opportunity_Product_Cart();
                    //Now process this promo entry for ICAP installment 2
                    //call the price computation function
                    newOppProduct3.UnitPrice = computePrice33(pbe);
                    //call the date computation function
                    newOppProduct3.dueDate = computeDueDate33(pbe);
                    newOppProduct3.productCode=pbe.product2.ProductCode;
                    newOppProduct3.currencyIsoCode=pbe.product2.currencyIsoCode;
                    newOppProduct3.priceBookEntryId = pbe.Id;
                    newOppProduct3.Quantity = 1; 
                    newOppProduct3.OpportunityId = opportunity.Id; 
                    newOppProduct3.productName = pbe.Product2.Name;
                    newOppProduct3.productDescription = pbe.product2.Description;
                    newOppProduct3.productFamily =pbe.product2.Family;
                    newOppProduct3.productHelpText=pbe.product2.Help_Text__c;  
                    newOppProduct3.paymentMethod = 'Installment';
                    newOppProducts.Add(newOppProduct3);
                    
                    Opportunity_Product_Cart newOppProduct4 = new Opportunity_Product_Cart();
                    //Now process this promo entry for ICAP installment 3
                    //call the price computation function
                    newOppProduct4.UnitPrice = computePrice33(pbe);
                    //call the date computation function
                    newOppProduct4.dueDate = computeDueDate34(pbe);
                    newOppProduct4.productCode=pbe.product2.ProductCode;
                    newOppProduct4.currencyIsoCode=pbe.product2.currencyIsoCode;
                    newOppProduct4.priceBookEntryId = pbe.Id;
                    newOppProduct4.Quantity = 1; 
                    newOppProduct4.OpportunityId = opportunity.Id; 
                    newOppProduct4.productName = pbe.Product2.Name;
                    newOppProduct4.productDescription = pbe.product2.Description;
                    newOppProduct4.productFamily =pbe.product2.Family;
                    newOppProduct4.productHelpText=pbe.product2.Help_Text__c;  
                    newOppProduct4.paymentMethod = 'Installment'; 
                    newOppProducts.Add(newOppProduct4);
                    
                    Opportunity_Product_Cart newOppProduct5 = new Opportunity_Product_Cart();
                    //Now process this promo entry for ICAP installment 4
                    //call the price computation function
                    newOppProduct5.UnitPrice = computePrice33(pbe);
                    //call the date computation function
                    newOppProduct5.dueDate = computeDueDate35(pbe);
                    newOppProduct5.productCode=pbe.product2.ProductCode;
                    newOppProduct5.currencyIsoCode=pbe.product2.currencyIsoCode;
                    newOppProduct5.priceBookEntryId = pbe.Id;
                    newOppProduct5.Quantity = 1; 
                    newOppProduct5.OpportunityId = opportunity.Id; 
                    newOppProduct5.productName = pbe.Product2.Name;
                    newOppProduct5.productDescription = pbe.product2.Description;
                    newOppProduct5.productFamily =pbe.product2.Family;
                    newOppProduct5.productHelpText=pbe.product2.Help_Text__c;  
                    newOppProduct5.paymentMethod = 'Installment';
                    newOppProducts.Add(newOppProduct5);
                    */
                }                   
                
               }
            }
        }
        return newOppProducts;
    }
    
    public List<PriceBookEntry> getAPCTravelService(String PriceBookCode, String UserType, String OppType, String airportCode){
        list<PriceBookEntry> apcPriceBookEntries= new list<PriceBookEntry>();
        system.debug('debug:: PriceBookCode=='+PriceBookCode);
        system.debug('debug:: UserType=='+UserType);
        system.debug('debug:: OppType=='+OppType);
        system.debug('debug:: airportCode=='+airportCode);
        apcPriceBookEntries = [Select pbe.Id,Product2.Name, pbe.Product2Id, Product2.Description,Product2.Family,Product2.ProductCode,
                               pbe.CurrencyIsoCode, pbe.UnitPrice,pbe.PriceBook2.Name,Product2.CurrencyIsoCode,
                               pbe.PriceBook2.Price_Book_Code__c,pbe.PriceBook2.Intrax_Programs__c,
                               Product2.User_Type__c, Product2.Payment_Method__c, Product2.Fee_Type__c, Product2.Due_Date_Type__c,
                               Product2.Product_Keyword__c, Product2.Sort_Order__c, Product2.ChildOppType__c,
                               Product2.Promo_Code__c, Product2.Airport_Code__c,Product2.Refundable__c,
                               Product2.Help_Text__c, Product2.Intacct_Department__c, Product2.Intacct_GL_Group__c
                               from   PriceBookEntry pbe
                               where  Product2.IsActive = true AND
                               IsActive = true AND
                               PriceBook2.IsActive =true AND 
                               PriceBook2.Price_Book_Code__c=:PriceBookCode AND 
                               Product2.ChildOppType__c =:OppType AND 
                               Product2.User_Type__c=:UserType AND
                               Product2.Airport_Code__c = :airportCode
                               LIMIT 1] ;
        system.debug('debug::apcPriceBookEntries'+ apcPriceBookEntries);
        if(apcPriceBookEntries!=null && apcPriceBookEntries.size()>0)
            return apcPriceBookEntries;
        else    
            return null;
    }
    
    public List<PriceBookEntry> getAPCPBEFromKeyword(String PriceBookCode, String UserType, String OppType, String ProductKeyword){
        list<PriceBookEntry> apcPriceBookEntries= new list<PriceBookEntry>();
        system.debug('debug:: PriceBookCode=='+PriceBookCode);
        system.debug('debug:: UserType=='+UserType);
        system.debug('debug:: OppType=='+OppType);
        system.debug('debug:: ProductKeyword=='+ProductKeyword);
        apcPriceBookEntries = [Select pbe.Id,Product2.Name, pbe.Product2Id, Product2.Description,Product2.Family,Product2.ProductCode,
                               pbe.CurrencyIsoCode, pbe.UnitPrice,pbe.PriceBook2.Name,Product2.CurrencyIsoCode,
                               pbe.PriceBook2.Price_Book_Code__c,pbe.PriceBook2.Intrax_Programs__c,
                               Product2.User_Type__c, Product2.Payment_Method__c, Product2.Fee_Type__c, Product2.Due_Date_Type__c,
                               Product2.Product_Keyword__c, Product2.Sort_Order__c, Product2.ChildOppType__c,
                               Product2.Promo_Code__c, Product2.Airport_Code__c,Product2.Refundable__c,
                               Product2.Help_Text__c, Product2.Intacct_Department__c, Product2.Intacct_GL_Group__c
                               from   PriceBookEntry pbe
                               where  Product2.IsActive = true AND
                               IsActive = true AND
                               PriceBook2.IsActive =true AND 
                               PriceBook2.Price_Book_Code__c=:PriceBookCode AND 
                               Product2.ChildOppType__c =:OppType AND 
                               Product2.User_Type__c=:UserType AND
                               Product2.Product_Keyword__c = :ProductKeyword
                               order  by pbe.UnitPrice desc] ;
        system.debug('debug::apcPriceBookEntries'+ apcPriceBookEntries);
        if(apcPriceBookEntries!=null && apcPriceBookEntries.size()>0)
            return apcPriceBookEntries;
        else    
            return null;
    }
    
    
    public list<OpportunityLineItem> getMatchBreakOpportunityProducts(String PriceBookCode, String UserType, 
                                                                      String OppType, Opportunity matchBreakOpp)
    {
        list<PriceBookEntry> allPriceBookEntries;
        list<OpportunityLineItem> allPreviousProducts;
        list<OpportunityLineItem> allServiceCredits= new List<OpportunityLineItem>();
		double serviceCreditAmount = 0.0;
        
        System.debug('In getMatchBreakOpportunityProducts method');
        if(match!=null && engagementObj!=null)
        {
            System.debug('match is ' + match );
            System.debug('engagementObj is ' + engagementObj );
            allPriceBookEntries = getAllAPCPricebookList(PriceBookCode,UserType,OppType);
            if(allPriceBookEntries !=null && allPriceBookEntries.size()>0)
            {
                System.debug('allPriceBookEntries' + allPriceBookEntries);
                
                Double unUsedDays = 0;
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.OpportunityId = matchBreakOpp.Id; 
            	oppLineItem.Description =  allPriceBookEntries[0].product2.Description;
            	//oppLineItem.unitPrice = oppProdCart.unitPrice;
            	oppLineItem.PricebookEntryId = allPriceBookEntries[0].Id;
            	oppLineItem.Due_Date__c = System.today() + 365;
            	oppLineItem.Quantity =1; 
            	oppLineItem.Payment_Method__c = allPriceBookEntries[0].Product2.Payment_Method__c;
                unUsedDays = (math.abs(match.End_Date__c.daysBetween(match.Start_Date__c)) - match.Match_Period__c);
                System.debug('match period: ' + match.Match_Period__c + ' match_type__c :' + match.match_type__c + ' engagementObj.In_Country__c: ' + 
                             engagementObj.In_Country__c);
                if(match.Match_Period__c < 183 && 
                   (match.match_type__c =='Original' || match.match_type__c=='Renewal' || match.match_type__c=='Extension') && 
                    (math.abs(match.End_Date__c.daysBetween(match.Start_Date__c))>=365))
                {
                	//Do full refund
                    System.debug('This is a OSAP match break for original match with in 6 months. Hence do a full refund');
                	allPreviousProducts = [Select id,OpportunityId,ProductCode,
                    	                     	 UnitPrice,PricebookEntryId,	
                        	          	     	 Due_Date__c, Quantity, Payment_Method__c
                            	      	  from   OpportunityLineItem 
                                	  	  where  OpportunityId = :match.Host_Family_Child_Opportuniy__c and 
                                  			 	 Refundable__c =true];
                    
                    for(OpportunityLineItem item : allPreviousProducts)
                    {
                        serviceCreditAmount = serviceCreditAmount + (item.UnitPrice/365)*unUsedDays;
                    }
                }
                else
                {
                    System.debug('This match break does not qualify for full refund. We only service credit 500 USD/month for unused days');
                   // service credit only 500 usd for per month
                   //Calculate the number of months remaining and refund 500 per month
                   serviceCreditAmount = (unUsedDays*12/365)*500;
                }
                System.debug('match period: ' + match.Match_Period__c + ' unused days :' + unUsedDays + ' service credit amount: ' + serviceCreditAmount);
                oppLineItem.unitPrice = serviceCreditAmount*-1;
                allServiceCredits.add(oppLineItem);
            }
            
        }
        
        return allServiceCredits;
        
    }
}