global with sharing class Pricing_Info_Wrapper {

public String CurrencyCode {get; set;}
static decimal stFee=0;
public decimal finalStPrice{get; set;}
public Boolean Isdata{get; set;}

global Pricing_Info_Wrapper(list<PriceBookEntry> pblst){
    
    system.debug('debug::pblst Size'+ pblst.size());        
         If(pblst.size()>0){
            for(PriceBookEntry pb:pblst){
                system.debug('debug::UnitPrice'+ pb.UnitPrice);
                stFee=pb.UnitPrice+stFee;
                system.debug('debug::Starting price'+ stFee);
            }
            CurrencyCode=pblst[0].CurrencyIsoCode;
            finalStPrice=stFee.setscale(0);
            system.debug('debug::Final price'+ finalStPrice);
            system.debug('debug::CurrencyCode==='+ CurrencyCode);
            Isdata=true;
            }
            else
            Isdata=false;
    }
}