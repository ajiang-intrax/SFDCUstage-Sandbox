@RestResource(urlMapping='/Getpricing/*')
global class Pricing_Publisher {
    
    public string CountryofResidence {get;set;}
    public string Fee_Type{get;set;}
    public string IntraxProgramCategory{get;set;}
    public string IntraxProgram{get;set;}
    public static string PriceBook{get;set;}
    
    
    
    public static list<PriceBookEntry> getPricebookDetail(string CountryofResidence, string To_Country, string Fee_Type,string IntraxProgramCategory,string IntraxProgram){
        system.debug('@@@ pricebook detailfuncton@@');
        Pricing_Controller price_controller= new Pricing_Controller();
        PriceBook = price_controller.getPriceBook(CountryofResidence,IntraxProgram);
        return price_controller.getPricebookList(To_Country,IntraxProgramCategory,PriceBook,Fee_Type);
    }
    
    
    public static list<PriceBookEntry> getAPCPricebookDetail(string Region, string To_Country, string Fee_Type,string IntraxProgram,String ChildOppType){
        system.debug('debug::APCpricebook detailfuncton@@');
        Pricing_Controller price_controller= new Pricing_Controller();
        PriceBook = price_controller.getPriceBook(Region,IntraxProgram,To_Country);
        String promoCode= null;
        return price_controller.getAPCPricebookList(PriceBook,'Host Family',Fee_Type,ChildOppType,promoCode);
    }
    
    //Wihout Price book Code       
    public static list<PriceBookEntry> getAPCDiscountedPb(string Region, string To_Country, string Fee_Type,string IntraxProgram,String ChildOppType, String PromoCode){
        system.debug('debug::getAPCDiscountedPb detailfuncton@@');
        if(PromoCode!= ''){
        Pricing_Controller price_controller= new Pricing_Controller();
        PriceBook = price_controller.getPriceBook(Region,IntraxProgram,To_Country);
        return price_controller.getAPCPricebookList(PriceBook,'Host Family',Fee_Type,ChildOppType,PromoCode);
        }
        else 
        return null;
    }
    
    
   /* // Need Price book
    public static list<PriceBookEntry> getDiscountPrice(String PriceBookCode,String FeeType, String ChildOppType,String PromoCode){
        
        list<PriceBookEntry> fixedFee= new list<PriceBookEntry>();
        system.debug('debug:: FeeType=='+FeeType);
        system.debug('debug:: PromoCode=='+PromoCode);
        system.debug('debug:: PriceBookCode=='+PriceBookCode);
        system.debug('debug:: ChildOppType=='+ChildOppType);
        If(PromoCode!= ''){
            fixedFee = [Select Id,CurrencyIsoCode,UnitPrice,PriceBook2.Name,PriceBook2.Price_Book_Code__c,PriceBook2.Intrax_Programs__c, Product2Id, Product2.Description,Product2.Destination__c, 
                        Product2.Name,Product2.Start_Date__c 
                        from PriceBookEntry where Product2.Fee_Type__c=:FeeType AND Product2.Promo_Code__c=:PromoCode AND Product2.IsActive = true AND PriceBook2.Price_Book_Code__c=:PriceBookCode and Product2.ChildOppType__c =:ChildOppType
                        AND IsActive = true AND PriceBook2.IsActive =true order by Product2.Start_Date__c desc] ;
        }
        system.debug('debug::ListOfPricebook'+ fixedFee);
        If(fixedFee.size()>0){
            return fixedFee;
        }
        return  new list<PriceBookEntry>();
    }*/
    
}