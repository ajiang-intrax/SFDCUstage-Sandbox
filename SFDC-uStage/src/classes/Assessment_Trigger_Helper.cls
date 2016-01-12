public class Assessment_Trigger_Helper {
    
	public static boolean firstRun = true; //Limit Trigger execution to 1 pass per transaction
    
    //Creates new Pay Event and populates it with values common to all Assessment triggered events.
    public static Pay_Event__c createPayEvent(Assessment__c a){
        Pay_Event__c pe = New Pay_Event__c();
           	pe.Approved_By__c = Global_Constants__c.getInstance().ULM_Admin_ID__c;
			pe.Customer__c = a.Name.left(40);                 
           	pe.Event_Date__c = a.Assessment_Date__c;
           	pe.Reference_Id__c = a.id;
           	pe.Reference_Object__c = 'Assessment';
			pe.Intrax_Program__c = a.Intrax_Program__c;
           	pe.Intrax_Region__c = a.Intrax_Region__c;
        return(pe);
    }
}