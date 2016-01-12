public class Trigger_Pay_Event_Helper {
    
    Map<Id, Pay_Event__c> moldPayEvents;
    Map<Id, Pay_Event__c> mnewPayEvents;
    List<Pay_Event__c> loldPayEvents;
    List<Pay_Event__c> lnewPayEvents;
    
    //Constructor with Map signature
    public Trigger_Pay_Event_Helper(Map<Id, Pay_Event__c> oldTriggerPE, Map<Id, Pay_Event__c> newTriggerPE) {
    	moldPayEvents = oldTriggerPE;
		mnewPayEvents = newTriggerPE;        
    }
    
    //Constructor with List signature
    public Trigger_Pay_Event_Helper(List<Pay_Event__c> oldTriggerPE, List<Pay_Event__c> newTriggerPE){
        loldPayEvents = oldTriggerPE;
        lnewPayEvents = newTriggerPE;
    }
    
    //On Insert assign Amount and Type/SubType to automatically generated Pay Events based on Custom Setting lookup
    public void completeNewPayEvents(){
		//Get individual staff stipend amount from user profile so we can override the 
		//standard global setting stipend amount.
		List<Id> uIds = New List<Id>();
        for(Pay_Event__c pe : lnewPayEvents){
            uIds.add(pe.Payee__c != null ? pe.Payee__c : pe.OwnerId);
        }
        List<User_Profile__c> uProfiles = [SELECT Id, User__c, Monthly_Stipend__c FROM User_Profile__c WHERE User__c in :uIds];
        Map<Id, User_Profile__c> mup = New Map<Id, User_Profile__c>();
        for(User_Profile__c up : uProfiles){
            mup.put(up.User__c, up);
        }
		
        //Core process loop.  Map Source to payment values in custom settings and user profiles to complete
        //Pay Event instance attribute assignment and insert.
        for (Pay_Event__c pe : lnewPayEvents){
        	pe.OwnerId = pe.Payee__c != null ? pe.Payee__c : pe.OwnerId; //Needed to push down visibility to payee
        	pe.Approved_By__c = pe.Approved_By__c != null ? pe.Approved_By__c : UserInfo.getUserId(); //Default to current user
            
        	//If not manually created, need to get Type and Amount from Pay Event Settings, and set default for failed lookup.
        	if(pe.Source__c != 'Manual'){
            	pe.Amount__c = 0;
            	pe.Type__c = 'Miscellaneous';
            	pe.Sub_Type__c = 'Error';
                Pay_Event_Settings__c pes = Pay_Event_Settings__c.getValues(pe.Source__c);
                User_Profile__c up = mup.get(pe.Payee__c);
            	if(pes != null){
                    //Override basic Stipend Amount with Payee's individual amount if it exists.
                    if(up != null && pes.PE_Type__c == 'Stipend' && up.Monthly_Stipend__c > 0){
                        pe.Amount__c = pes.Amount_Month_to_Day__c ? mup.get(pe.Payee__c).Monthly_Stipend__c/date.daysInMonth(pe.Event_Date__c.Year(), pe.Event_Date__c.Month()) : mup.get(pe.Payee__c).Monthly_Stipend__c;
                    }else{
            			pe.Amount__c = pes.Amount_Month_to_Day__c ? pes.PE_Amount__c/date.daysInMonth(pe.Event_Date__c.Year(), pe.Event_Date__c.Month()) : pes.PE_Amount__c;
                    }
                    pe.Type__c = pes.PE_Type__c;
                	pe.Sub_Type__c = pes.PE_Sub_Type__c;
            		pe.CurrencyIsoCode = pes.PE_Currency__c;
            		pe.Pay_Event_Setting_Name__c = pes.Name;
            	}
        	}
    	}		
    }
}