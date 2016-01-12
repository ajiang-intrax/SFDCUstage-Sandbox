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
private class Test_Pricing_Publisher {

         
    static testMethod void myUnitTest() {
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
        
        Pricing_Publisher.getPricebookDetail('ALL','ALL','Fixed','Information Media & Communications','AupairCare');
        Pricing_Publisher.getAPCPricebookDetail('United States','ALL','Fixed','AupairCare','Application');
        Pricing_Publisher.getAPCDiscountedPb('United States','ALL','Fixed','AupairCare','Application','MULTIPLE');
        //Pricing_Publisher.getDiscountPrice('APC USA','ALL', 'Application','MULTIPLE');
        try{
                }
        catch(Exception e){
        system.debug('***** '+e);
        }
    }
}