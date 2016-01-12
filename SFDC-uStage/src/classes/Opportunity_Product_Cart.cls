public without sharing class Opportunity_Product_Cart implements Comparable
{
    public String productCode{get;set;}
    public String productDescription{get;set;}
    public String productName{get;set;}
    public String productFamily{get;set;}
    public String currencyIsoCode{get;set;}
    public String dueDateType{get;set;}
    public Date   dueDate{get;set;}
    public String feeType{get;set;}
    public double unitPrice{get;set;}
    public string productHelpText{get;set;}
    public string paymentMethod{get;set;}
    public Id     priceBookEntryId{get;set;}
    public string productKeyword{get;set;}
    public string airportCode{get;set;}
    public string promoCode{get;set;}
    public string opportunityType{get;set;}
    public Id 	  OpportunityId{get;set;}
    public Integer quantity{get;set;}
    public static string sortType{get;set;}
    // Implement the compareTo() method
    public Integer compareTo(Object compareTo) {
        Opportunity_Product_Cart compareToProduct = (Opportunity_Product_Cart)compareTo;
        if(sortType=='date')
        {
            if (dueDate == compareToProduct.dueDate)
            {
                return 0;
                
            }
            else if (dueDate > compareToProduct.dueDate)
            {
                return 1;
                
            }
            else
            {
                return -1;             
            }
        }
        else
        {
            if(unitPrice==compareToProduct.unitPrice)
                return 0;
            else if(unitPrice<compareToProduct.unitPrice)
                return 1;
            else
                return -1;
        }
    }
    
    public Static Map<Date,double>  getItemSumOnDueDate(Map<Date,List<Opportunity_Product_Cart>> itemDatesMap)
    {
        Map<Date,double> itemPriceMap= new Map<Date,double>();
        for(Date key : itemDatesMap.keySet())
        {
            List<Opportunity_Product_Cart> templist = itemDatesMap.get(key);
            Opportunity_Product_Cart.sortType='price';
            templist.sort();
            double price =0.0;
            for(Opportunity_Product_Cart prod:templist) 
            {
                price = price + prod.unitprice;
                system.debug('==inside loop of price sort==== '+prod.productName + 
                             ' Due Date: ' + prod.duedate + ' price' + prod.unitprice);
            }
            itemPriceMap.put(key,price);
        }
        return itemPriceMap;
    }
    
    public Static Map<Date,List<Opportunity_Product_Cart>> getItemsDateMap(List<Opportunity_Product_Cart> oppProducts,String strPaymentMethod, Date matchStartDate)
    {
        Map<Date,List<Opportunity_Product_Cart>> itemDatesMap= new Map<Date,List<Opportunity_Product_Cart>>();
        
        Opportunity_Product_Cart.sortType= 'date';
        // Sort using the custom compareTo() method, first by date
        oppProducts.sort();
        
        for(Opportunity_Product_Cart opp : oppProducts)
        {
            if((opp.paymentmethod=='All' || opp.paymentmethod==strPaymentMethod) && opp.dueDate<matchStartDate)
            {
                List<Opportunity_Product_Cart> templist = itemDatesMap.get(opp.duedate);
                if (templist == null) {
                    templist = new List<Opportunity_Product_Cart>();
                    itemDatesMap.put(opp.duedate, templist);
                }
                templist.add(opp); 
            }
            
        }
        return itemDatesMap;
    }
    
    public Static Map<Date,List<Opportunity_Product_Cart>> getItemsDueLaterDateMap(List<Opportunity_Product_Cart> oppProducts,String strPaymentMethod, Date matchStartDate)
    {
        Map<Date,List<Opportunity_Product_Cart>> itemDatesMap= new Map<Date,List<Opportunity_Product_Cart>>();
        
        Opportunity_Product_Cart.sortType= 'date';
        // Sort using the custom compareTo() method, first by date
        oppProducts.sort();
        
        for(Opportunity_Product_Cart opp : oppProducts)
        {
            if(strPaymentMethod=='Future'  && opp.dueDate>=matchStartDate)
            {
                List<Opportunity_Product_Cart> templist = itemDatesMap.get(opp.duedate);
                if (templist == null) {
                    templist = new List<Opportunity_Product_Cart>();
                    itemDatesMap.put(opp.duedate, templist);
                }
                templist.add(opp); 
            }
            
        }
        return itemDatesMap;
    }
}